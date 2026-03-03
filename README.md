# SMADA Exam App — Security Upgrade v0.3 → v0.4

Dokumentasi perubahan dan upgrade sistem keamanan aplikasi ujian **SMAN 2 Pasuruan** (SMADA XI).

---

## Ringkasan Upgrade

| Versi | Deskripsi |
|-------|-----------|
| v0.3 | WebView exam app dasar, lockTaskMode, PIN check, canExecuteSu |
| v0.4 | **Semi-kiosk security architecture** — 6-layer anti-cheat system |

---

## File yang Diubah / Ditambahkan

### 🔧 Diubah

#### `AndroidManifest.xml`
| Perubahan | Nilai Lama | Nilai Baru | Alasan |
|-----------|-----------|-----------|--------|
| `android:debuggable` | `true` | `false` | Mencegah ADB attach & debug bypass oleh siswa |
| `android:allowBackup` | `true` | `false` | Backup bisa dump data soal ujian |
| `activity excludeFromRecents` | *(tidak ada)* | `true` | App tidak muncul di Recent Apps |
| `activity noHistory` | *(tidak ada)* | `true` | Tidak ada back-stack history |
| `activity finishOnTaskLaunch` | *(tidak ada)* | `true` | App mati otomatis jika task berpindah |
| `activity resizeableActivity` | `false` | `false` | Sudah ada, dipertahankan (blokir split screen) |
| `activity configChanges` | *(tidak ada)* | `orientation\|screenSize\|...` | Cegah `onStop` saat rotasi layar |
| `intent-filter priority` | *(tidak ada)* | `1000` | Prioritas tertinggi sebagai HOME launcher |

#### Permissions Baru Ditambahkan

| Permission | Fungsi |
|-----------|--------|
| `BIND_DEVICE_ADMIN` | Aktivasi Device Admin untuk force-lock & disable camera |
| `QUERY_ALL_PACKAGES` | Scan package root (Magisk, SuperSU, dll) |
| `FOREGROUND_SERVICE` | ExamGuardService bisa jalan terus di background |
| `FOREGROUND_SERVICE_SPECIAL_USE` | Tipe khusus foreground service Android 14+ |
| `WAKE_LOCK` | Cegah processor tidur selama ujian |
| `READ_MEDIA_IMAGES` | Deteksi screenshot via ContentObserver |

---

### 🆕 Ditambahkan

#### `res/xml/device_admin_policies.xml`
Policy Device Admin yang diminta ke siswa saat pertama buka app:
- `force-lock` — paksa lock screen jika app ditutup paksa
- `reset-password` — bisa reset passcode jika ada pelanggaran
- `disable-camera` — matikan kamera selama ujian aktif
- `disable-keyguard-features` — blokir notifikasi di lock screen

---

#### `src/.../ExamGuardService.java`
**Foreground Service monitor keamanan** yang berjalan sepanjang sesi ujian.

- Poll setiap **500ms** via `Handler` loop
- Cek foreground app menggunakan `UsageStatsManager` — jika app lain tampil di depan, broadcast kill
- Cek `ActivityManager.AppTask` — jika task ujian hilang dari stack, broadcast kill
- Notifikasi ongoing "Ujian Sedang Berlangsung" (tidak bisa di-dismiss)
- `START_STICKY` — restart otomatis jika di-kill OS

---

#### `src/.../ExamSecurityManager.java`
**Kelas pusat logic keamanan** — dipanggil dari MainActivity.

Fitur:

| Method | Fungsi |
|--------|--------|
| `applyWindowSecurity()` | Pasang `FLAG_SECURE`, `FLAG_KEEP_SCREEN_ON` — **wajib sebelum `setContentView`** |
| `enterImmersiveMode()` | Full immersive sticky (sembunyikan nav bar + status bar), support Android 11+ & legacy |
| `tryStartLockTask()` | Screen pinning via `startLockTask()` |
| `killExam(reason)` | **Kill sequence lengkap**: `stopService` → `stopLockTask` → `finishAndRemoveTask` → `finishAffinity` → `System.exit(0)` |
| `runIntegrityChecks()` | Root + ADB + Dev Options + package scan + debugger check |
| `isDeviceRooted()` | Cek su binary, busybox, test-keys build tag, `/system` writable |
| `isAdbEnabled()` | Baca `Settings.Global.ADB_ENABLED` |
| `isDeveloperOptionsEnabled()` | Baca `Settings.Global.DEVELOPMENT_SETTINGS_ENABLED` |
| `hasRootPackagesInstalled()` | Scan 12 paket root terkenal via `PackageManager` |
| `isBeingDebugged()` | `android.os.Debug.isDebuggerConnected()` |
| `requestDeviceAdmin()` | Intent aktivasi Device Admin ke user |

---

#### `src/.../MainActivity_SecurityReference.java`
**Referensi implementasi MainActivity** dengan semua security hooks terpasang.

Hook lifecycle yang ditambahkan:

| Lifecycle / Event | Aksi |
|-------------------|------|
| `onCreate` | `applyWindowSecurity()` → integrity check → setup kill receiver |
| `onResume` | `enterImmersiveMode()` + `tryStartLockTask()` + re-check device admin |
| `onPause` | **KILL** jika ujian aktif |
| `onStop` | **KILL** jika ujian aktif |
| `onDestroy` | Cleanup receiver + `stopLockTask` |
| `onWindowFocusChanged(false)` | **KILL** — paling sensitif, deteksi overlay/notif/assistant |
| `onUserLeaveHint` | **KILL** — tombol Home ditekan |
| `onMultiWindowModeChanged` | **KILL** — split screen diaktifkan |
| `onPictureInPictureModeChanged` | **KILL** — PIP mode diaktifkan |
| `dispatchKeyEvent` | Intercept HOME, RECENTS, ASSIST, BACK, SEARCH — kill atau block |
| `onBackPressed` | **KILL** — tidak ada navigasi back saat ujian |

---

## Arsitektur 6 Layer Keamanan

```
Layer 6 — Device Integrity Check (pre-exam gate)
    ↓ lolos
Layer 5 — Device Admin (force-lock, disable camera)
    ↓ aktif
Layer 4 — Continuous Background Monitor (ExamGuardService 500ms)
    ↓ berjalan
Layer 3 — Task & Screen Pinning (startLockTask, excludeFromRecents)
    ↓ aktif
Layer 2 — Activity Lifecycle Guards (onPause/onStop/onWindowFocus = KILL)
    ↓ berlapis
Layer 1 — Window & Rendering (FLAG_SECURE, Immersive Mode)
```

---

## Kill Sequence (Urutan Terminasi)

Setiap kali pelanggaran terdeteksi dari layer mana pun:

```
1. stopService(ExamGuardService)
2. stopLockTask()
3. finishAndRemoveTask()     ← hapus dari Recent Apps
4. finishAffinity()          ← close semua activity stack
5. System.exit(0)            ← paksa kill proses
```

---

## Ancaman yang Ditangani

| Ancaman | Mitigasi | Status |
|---------|----------|--------|
| Screenshot | `FLAG_SECURE` | ✅ Efektif |
| Screen recording | `FLAG_SECURE` | ✅ Efektif |
| Tombol Home | `onUserLeaveHint` → kill | ✅ Efektif |
| Recent Apps | `excludeFromRecents` + `onPause` → kill | ✅ Efektif |
| Split Screen | `resizeableActivity=false` + `onMultiWindowModeChanged` | ✅ Efektif |
| Notification drawer | `onWindowFocusChanged` → kill | ✅ Efektif |
| Overlay floating app | `onWindowFocusChanged` → kill | ✅ Sebagian besar |
| Google Assistant | `onWindowFocusChanged` → kill | ✅ Android < 12 |
| ADB debug | `Settings.Global.ADB_ENABLED` check | ⚠️ Bisa bypass offline |
| Developer Options | `DEVELOPMENT_SETTINGS_ENABLED` check | ⚠️ Harus online check |
| Root biasa | su binary + test-keys + busybox check | ⚠️ Bisa di-hide Magisk |
| Magisk / Zygisk | Package scan + su path | ⚠️ MagiskHide bisa bypass |
| Foto layar (HP lain) | Tidak bisa dicegah software | ❌ Prosedural |

---

## Keterbatasan BYOD (tanpa Device Owner)

> Ini adalah batasan sistem Android yang **tidak bisa diatasi** tanpa provisioning Device Owner (factory reset / QR code setup).

1. **`startLockTask()` menampilkan dialog** — siswa bisa klik Cancel. Dengan Device Owner, langsung terkunci tanpa dialog.
2. **Magisk Hide / Zygisk Deny List** — semua deteksi root bisa disembunyikan.
3. **Custom ROM** — bisa patch `FLAG_SECURE`, bypass semua proteksi framework.
4. **Assistant Android 12+ (Pixel/Samsung)** — bisa muncul tanpa trigger `onWindowFocusChanged` di beberapa ROM.
5. **Physical camera** — tidak ada solusi software.

---

## Cara Integrasi ke Project Android Studio

1. Copy `ExamGuardService.java` dan `ExamSecurityManager.java` ke folder `app/src/main/java/com/example/SMAN_2_PASURUAN/`
2. Buat `res/xml/device_admin_policies.xml` (sudah tersedia di folder `res/xml/`)
3. Merge `AndroidManifest.xml` dengan file yang sudah diupdate
4. Integrasikan method dari `MainActivity_SecurityReference.java` ke `MainActivity.java` yang sudah ada
5. Panggil `security.onExamStarted()` setelah auth PIN berhasil
6. Panggil `security.onExamFinished()` dari JS Bridge saat server kirim signal selesai
7. Build dalam mode **release** (`debuggable=false` aktif otomatis)
8. Test di perangkat fisik (bukan emulator)

---

## Requirement Permission yang Harus Di-grant Manual oleh Siswa

| Permission | Lokasi di Settings | Kapan Diminta |
|-----------|-------------------|---------------|
| **Usage Access** | Settings → Special App Access → Usage Access | Saat pertama buka app |
| **Device Admin** | Settings → Security → Device Admin | Saat pertama buka app |
| **Display over other apps** | Settings → Special App Access → All Files (opsional) | Opsional |

---

*Upgrade dilakukan pada: Maret 2026*  
*Package: `com.example.SMAN_2_PASURUAN`*  
*Target SDK: 33 (Android 13)*  
*Min SDK yang direkomendasikan: 26 (Android 8.0)*
