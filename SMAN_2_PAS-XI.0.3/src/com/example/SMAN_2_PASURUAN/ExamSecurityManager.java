package com.example.SMAN_2_PASURUAN;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.admin.DevicePolicyManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.provider.Settings;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.view.WindowInsets;
import android.view.WindowInsetsController;
import android.view.WindowManager;

import java.io.File;
import java.util.Arrays;
import java.util.List;

/**
 * ExamSecurityManager — Pusat Logic Keamanan Ujian
 *
 * Penggunaan di MainActivity:
 *
 *   private ExamSecurityManager security;
 *
 *   @Override protected void onCreate(...) {
 *       security = new ExamSecurityManager(this);
 *       security.applyWindowSecurity();
 *       security.runIntegrityChecks(); // terminates jika gagal
 *   }
 *
 *   @Override protected void onResume() {
 *       security.enterImmersiveMode();
 *       security.tryStartLockTask();
 *   }
 *
 *   @Override public void onWindowFocusChanged(boolean hasFocus) {
 *       if (!hasFocus) security.killExam("focus_lost");
 *   }
 */
public class ExamSecurityManager {

    private static final String TAG = "ExamSecurityManager";

    /**
     * Daftar package cheat / split screen trigger yang langsung
     * menyebabkan terminate jika terdeteksi foreground.
     */
    private static final List<String> BLOCKED_PACKAGES = Arrays.asList(
            "com.whatsapp",
            "com.google.android.apps.messaging",
            "com.android.chrome",
            "org.telegram.messenger",
            "com.facebook.katana",
            "com.instagram.android",
            "com.miui.screenshot",          // Xiaomi screenshot tool
            "com.samsung.android.app.camera", // Samsung camera
            "com.sec.android.app.screenrecorder"
    );

    /** Paket-paket yang diketahui sebagai tool rooting */
    private static final List<String> ROOT_PACKAGES = Arrays.asList(
            "com.topjohnwu.magisk",
            "eu.chainfire.supersu",
            "com.koushikdutta.superuser",
            "com.noshufou.android.su",
            "com.thirdparty.superuser",
            "com.yellowes.su",
            "me.phh.superuser",
            "com.kingroot.kinguser",
            "com.kingo.root",
            "com.smedialink.oneclickroot",
            "com.zhiqupk.root.global",
            "com.alephzain.framaroot"
    );

    private final Activity activity;
    private final Context context;
    private final DevicePolicyManager dpm;
    private final ComponentName adminComponent;

    public ExamSecurityManager(Activity activity) {
        this.activity       = activity;
        this.context        = activity.getApplicationContext();
        this.dpm            = (DevicePolicyManager) context.getSystemService(Context.DEVICE_POLICY_SERVICE);
        this.adminComponent = new ComponentName(context, MyDeviceAdminReceiver.class);
    }

    // =========================================================================
    // WINDOW FLAGS — dipanggil di onCreate, SEBELUM setContentView
    // =========================================================================

    /**
     * Terapkan semua flag keamanan window:
     *  FLAG_SECURE           → blokir screenshot & screen recording
     *  FLAG_KEEP_SCREEN_ON   → layar tidak mati selama ujian
     *  FLAG_DISMISS_KEYGUARD → bypass lock screen (show di atas lock screen)
     */
    public void applyWindowSecurity() {
        Window window = activity.getWindow();

        // Blokir screenshot dan screen recording — WAJIB
        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE);

        // Layar tetap menyala
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

        // Jika Android 12+: prevent turn-off screen shortcuts
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            window.addFlags(WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD);
        }

        // Hapus status bar dan navigation bar dari touch
        window.addFlags(WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN
                | WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS);
    }

    // =========================================================================
    // IMMERSIVE MODE — dipanggil di onResume & onWindowFocusChanged(true)
    // =========================================================================

    /**
     * Full immersive sticky mode:
     * - Menyembunyikan status bar & navigation bar
     * - Tidak bisa di-swipe-out (BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE)
     * - Re-hides otomatis setelah timeout singkat jika user swipe
     */
    public void enterImmersiveMode() {
        Window window = activity.getWindow();

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            // Android 11+ API modern
            WindowInsetsController controller = window.getInsetsController();
            if (controller != null) {
                controller.hide(WindowInsets.Type.statusBars()
                        | WindowInsets.Type.navigationBars());
                controller.setSystemBarsBehavior(
                        WindowInsetsController.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE);
            }
        } else {
            // Android < 11 fallback
            View decorView = window.getDecorView();
            int flags = View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
                    | View.SYSTEM_UI_FLAG_FULLSCREEN
                    | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                    | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                    | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                    | View.SYSTEM_UI_FLAG_LAYOUT_STABLE;
            decorView.setSystemUiVisibility(flags);
        }
    }

    // =========================================================================
    // LOCK TASK — Screen Pinning
    // =========================================================================

    /**
     * Mencoba memulai lock task (screen pinning).
     * Tanpa device owner, startLockTask() akan menampilkan dialog konfirmasi
     * ke user (satu kali, pertama kali). Setelah user setuju, berikutnya
     * langsung aktif.
     *
     * Dengan device owner: langsung aktif tanpa dialog.
     */
    public void tryStartLockTask() {
        try {
            ActivityManager am = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
            // Cek apakah sudah dalam lock task mode
            if (am != null && am.getLockTaskModeState()
                    == ActivityManager.LOCK_TASK_MODE_NONE) {
                activity.startLockTask();
                Log.d(TAG, "startLockTask() called");
            }
        } catch (Exception e) {
            Log.e(TAG, "startLockTask failed: " + e.getMessage());
        }
    }

    /** Stop lock task — panggil hanya saat ujian selesai atau kill sequence */
    public void stopLockTaskSafe() {
        try {
            activity.stopLockTask();
        } catch (Exception ignored) {}
    }

    // =========================================================================
    // KILL SEQUENCE — Termination Total
    // =========================================================================

    /**
     * Urutan terminasi total aplikasi.
     * Dipanggil dari semua sensor keamanan (lifecycle, focus, service).
     *
     * @param reason string deskripsi alasan kill (untuk logging/debug)
     */
    public void killExam(String reason) {
        Log.w(TAG, "KILL SEQUENCE triggered: " + reason);

        // 1. Hentikan foreground service monitor
        try {
            context.stopService(new android.content.Intent(context, ExamGuardService.class));
        } catch (Exception ignored) {}

        // 2. Stop lock task agar tidak stuck di pinned mode
        stopLockTaskSafe();

        // 3. Hapus task dari recent apps list
        try {
            activity.finishAndRemoveTask();
        } catch (Exception ignored) {}

        // 4. Finish semua activity dalam stack
        try {
            activity.finishAffinity();
        } catch (Exception ignored) {}

        // 5. Paksa kill proses — paling agresif
        // Ini memastikan tidak ada state yang tersimpan di memory
        System.exit(0);
    }

    // =========================================================================
    // INTEGRITY CHECKS — dipanggil di onCreate
    // =========================================================================

    /**
     * Jalankan semua pemeriksaan integritas.
     * TERMINATE jika ada yang gagal.
     */
    public void runIntegrityChecks() {
        if (isDeviceRooted()) {
            killExam("rooted_device");
            return;
        }

        if (isAdbEnabled()) {
            killExam("adb_enabled");
            return;
        }

        if (isDeveloperOptionsEnabled()) {
            killExam("developer_options_enabled");
            return;
        }

        if (hasRootPackagesInstalled()) {
            killExam("root_package_detected");
            return;
        }

        if (isBeingDebugged()) {
            killExam("debugger_attached");
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // ROOT DETECTION
    // ─────────────────────────────────────────────────────────────────────────

    public boolean isDeviceRooted() {
        return checkSuBinary()
                || checkBusybox()
                || checkTestKeys()
                || checkRWSystem();
    }

    /** Cek keberadaan binary su di path umum */
    private boolean checkSuBinary() {
        String[] suPaths = {
                "/system/bin/su", "/system/xbin/su", "/sbin/su",
                "/system/sd/xbin/su", "/system/bin/failsafe/su",
                "/data/local/xbin/su", "/data/local/bin/su", "/data/local/su",
                "/su/bin/su"
        };
        for (String path : suPaths) {
            if (new File(path).exists()) return true;
        }
        return false;
    }

    /** Cek busybox yang sering diinstall bersamaan root */
    private boolean checkBusybox() {
        return new File("/system/xbin/busybox").exists()
                || new File("/system/bin/busybox").exists();
    }

    /** Build tag "test-keys" menandakan custom/modified ROM */
    private boolean checkTestKeys() {
        String tags = Build.TAGS;
        return tags != null && tags.contains("test-keys");
    }

    /** /system ter-mount sebagai read-write (seharusnya read-only) */
    private boolean checkRWSystem() {
        try {
            java.io.File systemFile = new java.io.File("/system");
            // Hanya sebagai heuristik ringan
            return systemFile.canWrite();
        } catch (Exception e) {
            return false;
        }
    }

    /** Cek root package yang terinstall via PackageManager */
    private boolean hasRootPackagesInstalled() {
        PackageManager pm = context.getPackageManager();
        for (String pkg : ROOT_PACKAGES) {
            try {
                pm.getPackageInfo(pkg, 0);
                Log.w(TAG, "Root package found: " + pkg);
                return true;
            } catch (PackageManager.NameNotFoundException ignored) {}
        }
        return false;
    }

    /** Cek status ADB */
    private boolean isAdbEnabled() {
        return Settings.Global.getInt(context.getContentResolver(),
                Settings.Global.ADB_ENABLED, 0) != 0;
    }

    /** Cek Developer Options */
    private boolean isDeveloperOptionsEnabled() {
        return Settings.Global.getInt(context.getContentResolver(),
                Settings.Global.DEVELOPMENT_SETTINGS_ENABLED, 0) != 0;
    }

    /** Cek apakah debugger sedang attached */
    private boolean isBeingDebugged() {
        return android.os.Debug.isDebuggerConnected();
    }

    // =========================================================================
    // DEVICE ADMIN CHECK
    // =========================================================================

    /** Apakah app sudah diaktifkan sebagai Device Admin? */
    public boolean isDeviceAdminActive() {
        return dpm != null && dpm.isAdminActive(adminComponent);
    }

    /**
     * Minta user mengaktifkan Device Admin.
     * Dipanggil di onResume jika !isDeviceAdminActive().
     */
    public void requestDeviceAdmin() {
        android.content.Intent intent = new android.content.Intent(
                DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN);
        intent.putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, adminComponent);
        intent.putExtra(DevicePolicyManager.EXTRA_ADD_EXPLANATION,
                "Diperlukan untuk keamanan sesi ujian. " +
                "Aktifkan Device Admin untuk melanjutkan.");
        activity.startActivityForResult(intent, 1001);
    }

    // =========================================================================
    // OVERLAY CHECK
    // =========================================================================

    /**
     * Cek apakah ada app lain yang memiliki izin SYSTEM_ALERT_WINDOW aktif.
     * CATATAN: Android tidak expose "siapa yang sedang pakai overlay",
     * hanya bisa cek apakah app KITA bisa draw overlay.
     * Untuk deteksi overlay asing, gunakan Accessibility Service (opsional).
     */
    public boolean hasOverlayRisk() {
        // Jika kita tidak punya izin overlay (tidak diminta),
        // tapi ada app lain yang bisa menggambar di atas kita
        // → ini heuristik, tidak bisa 100% akurat tanpa Device Owner
        return false; // Implementasi lanjut: gunakan AccessibilityService
    }
}
