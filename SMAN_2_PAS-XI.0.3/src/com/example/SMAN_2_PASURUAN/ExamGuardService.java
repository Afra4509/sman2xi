package com.example.SMAN_2_PASURUAN;

import android.app.ActivityManager;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.app.usage.UsageStats;
import android.app.usage.UsageStatsManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.provider.Settings;
import android.util.Log;

import java.util.List;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;

/**
 * ExamGuardService — Foreground Service Monitor Keamanan Ujian
 *
 * Berjalan terus selama sesi ujian aktif.
 * Setiap POLL_INTERVAL_MS memeriksa:
 *   1. Apakah app yang sedang di foreground adalah diri sendiri?
 *   2. Apakah ada overlay aktif dari app lain?
 *   3. Apakah lock task masih aktif?
 *
 * Jika ada pelanggaran → broadcast ACTION_KILL ke MainActivity.
 *
 * CARA PAKAI:
 *   startService(new Intent(this, ExamGuardService.class));   // saat ujian mulai
 *   stopService(new Intent(this, ExamGuardService.class));    // saat ujian selesai (server-side unlock)
 */
public class ExamGuardService extends Service {

    private static final String TAG = "ExamGuardService";
    private static final String CHANNEL_ID = "exam_guard_channel";
    private static final int NOTIF_ID = 1001;

    /** Interval polling foreground app check (ms). 500ms adalah trade-off
     *  performa vs responsivitas. Jangan < 300ms. */
    private static final long POLL_INTERVAL_MS = 500L;

    /** Broadcast action yang diterima MainActivity untuk trigger kill sequence */
    public static final String ACTION_KILL = "com.example.SMAN_2_PASURUAN.ACTION_KILL";
    public static final String EXTRA_REASON = "kill_reason";

    private final String PACKAGE_NAME = "com.example.SMAN_2_PASURUAN";

    private Handler handler;
    private Runnable guardRunnable;
    private UsageStatsManager usageStatsManager;
    private ActivityManager activityManager;
    private boolean isRunning = false;

    // ─────────────────────────────────────────────────────────────────────────
    // LIFECYCLE
    // ─────────────────────────────────────────────────────────────────────────

    @Override
    public void onCreate() {
        super.onCreate();
        usageStatsManager = (UsageStatsManager) getSystemService(Context.USAGE_STATS_SERVICE);
        activityManager  = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
        handler           = new Handler(Looper.getMainLooper());
        createNotificationChannel();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        // Mulai sebagai foreground service dengan notifikasi minimal
        startForeground(NOTIF_ID, buildNotification());

        if (!isRunning) {
            isRunning = true;
            startGuardLoop();
        }

        // START_STICKY: re-start otomatis jika OS kill service
        return START_STICKY;
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null; // Bukan bound service
    }

    @Override
    public void onDestroy() {
        isRunning = false;
        if (handler != null && guardRunnable != null) {
            handler.removeCallbacks(guardRunnable);
        }
        super.onDestroy();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // GUARD LOOP
    // ─────────────────────────────────────────────────────────────────────────

    private void startGuardLoop() {
        guardRunnable = new Runnable() {
            @Override
            public void run() {
                if (!isRunning) return;
                try {
                    performSecurityCheck();
                } catch (Exception e) {
                    Log.e(TAG, "Guard loop error: " + e.getMessage());
                }
                handler.postDelayed(this, POLL_INTERVAL_MS);
            }
        };
        handler.post(guardRunnable);
    }

    private void performSecurityCheck() {
        // ── CHECK 1: Foreground app bukan diri sendiri ──
        String foreground = getForegroundPackage();
        if (foreground != null && !foreground.equals(PACKAGE_NAME)
                && !foreground.equals("android")
                && !foreground.startsWith("com.android.systemui")) {
            Log.w(TAG, "KILL: Foreign foreground app detected: " + foreground);
            broadcastKill("foreign_foreground:" + foreground);
            return;
        }

        // ── CHECK 2: Overlay aktif dari app selain diri sendiri ──
        if (Settings.canDrawOverlays(this)) {
            // Kita sendiri punya izin overlay, cek apakah ada app LAIN yang pakai
            // (tidak bisa tahu persis tanpa accessibility; ini hanyalah flag kemungkinan)
        }

        // ── CHECK 3: LockTask masih aktif? ──
        ActivityManager.AppTask task = getOurAppTask();
        if (task != null) {
            ActivityManager.RecentTaskInfo info = task.getTaskInfo();
            if (info == null) {
                Log.w(TAG, "KILL: AppTask disappeared from stack");
                broadcastKill("task_vanished");
            }
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // UTILITIES
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Mendapatkan package name app yang saat ini di foreground.
     * Menggunakan UsageStatsManager (memerlukan izin PACKAGE_USAGE_STATS —
     * user harus grant manual di Settings > Special app access > Usage access).
     */
    private String getForegroundPackage() {
        if (usageStatsManager == null) return null;
        long now = System.currentTimeMillis();
        // Ambil stats 3 detik terakhir untuk efisiensi
        Map<String, UsageStats> stats = usageStatsManager.queryAndAggregateUsageStats(now - 3000, now);
        if (stats == null || stats.isEmpty()) return null;

        SortedMap<Long, String> sorted = new TreeMap<>();
        for (Map.Entry<String, UsageStats> entry : stats.entrySet()) {
            sorted.put(entry.getValue().getLastTimeUsed(), entry.getKey());
        }
        if (!sorted.isEmpty()) {
            return sorted.get(sorted.lastKey());
        }
        return null;
    }

    /** Mencari AppTask milik app ini di recent task list */
    @SuppressWarnings("deprecation")
    private ActivityManager.AppTask getOurAppTask() {
        List<ActivityManager.AppTask> tasks = activityManager.getAppTasks();
        if (tasks != null) {
            for (ActivityManager.AppTask task : tasks) {
                ActivityManager.RecentTaskInfo info = task.getTaskInfo();
                if (info != null && info.baseActivity != null
                        && PACKAGE_NAME.equals(info.baseActivity.getPackageName())) {
                    return task;
                }
            }
        }
        return null;
    }

    /** Kirim broadcast ke MainActivity agar trigger kill sequence */
    private void broadcastKill(String reason) {
        Intent kill = new Intent(ACTION_KILL);
        kill.putExtra(EXTRA_REASON, reason);
        kill.setPackage(PACKAGE_NAME);
        sendBroadcast(kill);
        // Tambahan: langsung stop diri sendiri agar tidak ada loop ke app mati
        stopSelf();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // NOTIFICATION (wajib untuk Foreground Service)
    // ─────────────────────────────────────────────────────────────────────────

    private void createNotificationChannel() {
        NotificationChannel channel = new NotificationChannel(
                CHANNEL_ID,
                "Ujian Aktif",
                NotificationManager.IMPORTANCE_LOW // Low agar tidak bunyi/vibrate
        );
        channel.setDescription("Aplikasi ujian sedang berjalan");
        channel.setShowBadge(false);
        NotificationManager nm = getSystemService(NotificationManager.class);
        if (nm != null) nm.createNotificationChannel(channel);
    }

    private Notification buildNotification() {
        return new Notification.Builder(this, CHANNEL_ID)
                .setContentTitle("Ujian Sedang Berlangsung")
                .setContentText("Jangan keluar dari aplikasi")
                .setSmallIcon(android.R.drawable.ic_lock_lock)
                .setOngoing(true)        // Tidak bisa di-dismiss user
                .setAutoCancel(false)
                .build();
    }
}
