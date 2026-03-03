package com.example.SMAN_2_PASURUAN;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.webkit.WebSettings;
import android.webkit.WebView;

import androidx.appcompat.app.AppCompatActivity;

/**
 * MainActivity — Security-Hardened Exam Activity
 *
 * CATATAN: File ini adalah referensi implementasi.
 * Integrasikan logika ini ke dalam MainActivity yang sudah ada
 * (yang berisi kode WebView, PIN, dll).
 *
 * ─────────────────────────────────────────────────────────────
 * URUTAN LIFECYCLE & SECURITY HOOKS:
 *
 *  onCreate        → applyWindowSecurity (FLAG_SECURE), integrity checks,
 *                     setup kill broadcast receiver, start guard service
 *  onStart         → (tidak ada aksi khusus)
 *  onResume        → enterImmersiveMode, tryStartLockTask,
 *                     re-check device admin
 *  onPause         → TRIGGER KILL (pergi ke background)
 *  onStop          → TRIGGER KILL (benar-benar tidak visible)
 *  onDestroy       → cleanup
 *  onWindowFocusChanged(false) → TRIGGER KILL (focus hilang)
 *  onUserLeaveHint → TRIGGER KILL (user tekan Home)
 *  onMultiWindowModeChanged → TRIGGER KILL (multi window)
 *  onPictureInPictureModeChanged → TRIGGER KILL (PIP)
 *  dispatchKeyEvent → intercept BACK, HOME, RECENTS
 * ─────────────────────────────────────────────────────────────
 */
public class MainActivity extends AppCompatActivity {

    private static final String TAG = "MainActivity";

    private ExamSecurityManager security;
    private BroadcastReceiver killReceiver;

    // Flag: apakah ujian sedang aktif (set true setelah auth berhasil)
    private boolean examActive = false;

    // Flag: apakah transisi ke hasil ujian yang diizinkan
    private boolean allowedTransition = false;

    // =========================================================================
    // onCreate
    // =========================================================================
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        // ── SECURITY: FLAG_SECURE harus dipasang SEBELUM super.onCreate ──
        security = new ExamSecurityManager(this);
        security.applyWindowSecurity(); // pasang FLAG_SECURE, keep screen on, dll

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // ── Integrity check: root, ADB, dev options ──
        // Aktifkan ini HANYA di build release (bukan debug)
        if (!BuildConfig.DEBUG) {
            security.runIntegrityChecks();
        }

        // ── Setup kill broadcast receiver ──
        setupKillReceiver();

        // ── Pastikan tidak ada saved instance state (fresh start) ──
        // Jika ada state tersimpan → ada celah, kill
        if (savedInstanceState != null) {
            Log.w(TAG, "savedInstanceState detected — terminating");
            security.killExam("saved_instance_state");
            return;
        }

        // ── Inisialisasi WebView dengan security settings ──
        setupSecureWebView();
    }

    // =========================================================================
    // onResume — re-enforce keamanan setiap kembali ke foreground
    // =========================================================================
    @Override
    protected void onResume() {
        super.onResume();
        security.enterImmersiveMode();

        if (examActive) {
            security.tryStartLockTask();

            // Re-check device admin
            if (!security.isDeviceAdminActive()) {
                Log.w(TAG, "Device admin not active");
                security.requestDeviceAdmin();
            }
        }
    }

    // =========================================================================
    // onPause — setiap kali app tidak visible, kill
    // =========================================================================
    @Override
    protected void onPause() {
        super.onPause();

        if (examActive && !allowedTransition) {
            Log.w(TAG, "onPause fired during exam — killing");
            security.killExam("on_pause");
        }
    }

    // =========================================================================
    // onStop — double-guard, app completely hidden
    // =========================================================================
    @Override
    protected void onStop() {
        super.onStop();

        if (examActive && !allowedTransition) {
            Log.w(TAG, "onStop fired during exam — killing");
            security.killExam("on_stop");
        }
    }

    // =========================================================================
    // onDestroy — cleanup
    // =========================================================================
    @Override
    protected void onDestroy() {
        if (killReceiver != null) {
            try { unregisterReceiver(killReceiver); } catch (Exception ignored) {}
        }
        security.stopLockTaskSafe();
        super.onDestroy();
    }

    // =========================================================================
    // onWindowFocusChanged — DETEKSI PALING RELIABLE
    // Dipanggil setiap kali window focus berpindah (overlay, notification shade,
    // assistant, dialog dari app lain, dll)
    // =========================================================================
    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);

        if (!hasFocus && examActive && !allowedTransition) {
            Log.w(TAG, "Window focus lost during exam — killing");
            security.killExam("focus_lost");
            return;
        }

        if (hasFocus) {
            // Re-enter immersive mode karena status bar mungkin muncul sebentar
            security.enterImmersiveMode();
        }
    }

    // =========================================================================
    // onUserLeaveHint — user tekan tombol Home
    // =========================================================================
    @Override
    protected void onUserLeaveHint() {
        super.onUserLeaveHint();
        if (examActive && !allowedTransition) {
            Log.w(TAG, "User leave hint (Home button) — killing");
            security.killExam("home_button");
        }
    }

    // =========================================================================
    // onMultiWindowModeChanged — split screen detected
    // =========================================================================
    @Override
    public void onMultiWindowModeChanged(boolean isInMultiWindowMode,
                                         android.content.res.Configuration newConfig) {
        super.onMultiWindowModeChanged(isInMultiWindowMode, newConfig);
        if (isInMultiWindowMode && examActive) {
            Log.w(TAG, "Multi-window mode detected — killing");
            security.killExam("multi_window");
        }
    }

    // =========================================================================
    // onPictureInPictureModeChanged — PIP mode detected
    // =========================================================================
    @Override
    public void onPictureInPictureModeChanged(boolean isInPictureInPictureMode,
                                               android.content.res.Configuration newConfig) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig);
        if (isInPictureInPictureMode && examActive) {
            Log.w(TAG, "PIP mode detected — killing");
            security.killExam("pip_mode");
        }
    }

    // =========================================================================
    // dispatchKeyEvent — intercept hardware keys
    // =========================================================================
    @Override
    public boolean dispatchKeyEvent(KeyEvent event) {
        if (!examActive) return super.dispatchKeyEvent(event);

        int keyCode = event.getKeyCode();

        // Blokir tombol-tombol berbahaya
        if (keyCode == KeyEvent.KEYCODE_HOME
                || keyCode == KeyEvent.KEYCODE_APP_SWITCH   // Recents
                || keyCode == KeyEvent.KEYCODE_ASSIST       // Google Assistant
                || keyCode == KeyEvent.KEYCODE_SEARCH
                || keyCode == KeyEvent.KEYCODE_VOICE_ASSIST
                || keyCode == KeyEvent.KEYCODE_BACK) {

            Log.d(TAG, "Blocked key: " + KeyEvent.keyCodeToString(keyCode));

            // Untuk BACK dan HOME: langsung kill (tidak hanya block)
            if (keyCode == KeyEvent.KEYCODE_BACK
                    || keyCode == KeyEvent.KEYCODE_HOME) {
                security.killExam("hardware_key:" + KeyEvent.keyCodeToString(keyCode));
            }

            return true; // Consume event, tidak diteruskan ke system
        }

        // Volume keys: izinkan (tidak berbahaya)
        return super.dispatchKeyEvent(event);
    }

    // =========================================================================
    // onBackPressed — Android 12 dan bawah
    // =========================================================================
    @Override
    public void onBackPressed() {
        if (examActive) {
            Log.w(TAG, "Back pressed during exam — killing");
            security.killExam("back_pressed");
        }
        // Sengaja tidak call super — tidak ada back navigation
    }

    // =========================================================================
    // SETUP HELPERS
    // =========================================================================

    /**
     * Broadcast receiver yang menerima signal kill dari ExamGuardService.
     * Ini memastikan bahkan jika activity tidak respond (misal sedang loading),
     * kill tetap tereksekusi.
     */
    private void setupKillReceiver() {
        killReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                if (ExamGuardService.ACTION_KILL.equals(intent.getAction())) {
                    String reason = intent.getStringExtra(ExamGuardService.EXTRA_REASON);
                    Log.w(TAG, "Kill broadcast received: " + reason);
                    security.killExam("service:" + reason);
                }
            }
        };

        IntentFilter filter = new IntentFilter(ExamGuardService.ACTION_KILL);
        // Android 14+: RECEIVER_NOT_EXPORTED untuk keamanan
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            registerReceiver(killReceiver, filter, Context.RECEIVER_NOT_EXPORTED);
        } else {
            registerReceiver(killReceiver, filter);
        }
    }

    /**
     * Konfigurasi WebView dengan settings paling aman untuk exam.
     * Disable fitur-fitur yang bisa dieksploitasi.
     */
    private void setupSecureWebView() {
        WebView webView = findViewById(R.id.webview); // sesuaikan ID
        if (webView == null) return;

        WebSettings ws = webView.getSettings();

        // Matikan semua fitur yang tidak perlu untuk exam
        ws.setJavaScriptEnabled(true);          // Tetap perlu untuk exam app
        ws.setAllowFileAccess(false);           // Blokir file:// access
        ws.setAllowContentAccess(false);        // Blokir content:// access
        ws.setAllowFileAccessFromFileURLs(false);
        ws.setAllowUniversalAccessFromFileURLs(false);
        ws.setSaveFormData(false);              // Tidak simpan data form
        ws.setSavePassword(false);
        ws.setCacheMode(WebSettings.LOAD_NO_CACHE); // Tidak cache soal
        ws.setGeolocationEnabled(false);
        ws.setMediaPlaybackRequiresUserGesture(false);

        // Disable long-press context menu (copy-paste soal)
        webView.setLongClickable(false);
        webView.setOnLongClickListener(v -> true); // intercept & ignore
        webView.setHapticFeedbackEnabled(false);
    }

    // =========================================================================
    // PUBLIC API — dipanggil dari WebView JS Bridge atau auth flow
    // =========================================================================

    /**
     * Dipanggil setelah autentikasi siswa berhasil (PIN/token valid).
     * Mengaktifkan semua guard.
     */
    public void onExamStarted() {
        examActive = true;
        allowedTransition = false;

        // Start foreground guard service
        startService(new Intent(this, ExamGuardService.class));

        // Lock task
        security.tryStartLockTask();
        security.enterImmersiveMode();

        Log.d(TAG, "Exam session STARTED — all guards active");
    }

    /**
     * Dipanggil saat ujian selesai (dari server-side unlock).
     * Menonaktifkan guard dan mengizinkan transisi ke halaman hasil.
     */
    public void onExamFinished() {
        allowedTransition = true;
        examActive = false;

        stopService(new Intent(this, ExamGuardService.class));
        security.stopLockTaskSafe();

        Log.d(TAG, "Exam session FINISHED — guards disabled");
    }
}
