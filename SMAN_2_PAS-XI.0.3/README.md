# SMADA Exam App — Security Upgrade v0.3 → v0.4

Dokumentasi perubahan dan upgrade sistem keamanan aplikasi ujian **SMAN 2 Pasuruan**.  
Berlaku untuk **Kelas X dan XI** (BYOD, tanpa Device Owner provisioning) — **satu APK gabungan**.

---

## APK yang Dihasilkan

| File | Kelas | URL Endpoint | Label | Status |
|------|-------|-------------|-------|--------|
| `SMAN_2_PAS-XI.0.4-unsigned.apk` | XI | `smadapas.biz.id/xi-adminnya./` | SMAN2-XI-0.3 | Terpisah (legacy) |
| `SMAN_2_PAS-X.0.3-unsigned.apk` | X | `smadapas.biz.id/x-adminnya./` | SMAN2-X-0.3 | Terpisah (legacy) |
| `SMAN_2_PAS-X.0.3-aligned-debugSigned.apk` | X | `smadapas.biz.id/x-adminnya./` | SMAN2-X-0.3 | Signed (legacy) |
| `SMAN_2_PAS-X-XI.0.4-unsigned.apk` | **X + XI** | Dipilih saat pertama buka app | SMADA-PAS | Build gabungan |
| `SMAN_2_PAS-X-XI.0.4-aligned-debugSigned.apk` | **X + XI** | Dipilih saat pertama buka app | SMADA-PAS | **Signed — siap install** |

Signed menggunakan `uber-apk-signer-1.3.0`, signature v1 + v2 + v3, berlaku hingga 2044.

### APK Gabungan — Cara Kerja Selector Kelas

Pada **pertama kali buka** setelah install (atau setelah clear data), app menampilkan dialog:

```
Pilih Kelas

  [ Kelas X ]     [ Kelas XI ]
```

Pilihan disimpan ke `SharedPreferences` (`key: "kelas"`, value: `"x"` atau `"xi"`).  
Saat load ujian, URL dipilih otomatis berdasarkan nilai tersebut:

| Nilai | URL yang dimuat |
|-------|----------------|
| `"x"` | `https://smadapas.biz.id/x-adminnya./` |
| `"xi"` | `https://smadapas.biz.id/xi-adminnya./` |

Untuk **ganti kelas**: uninstall → install ulang, atau Settings → App → Clear Data.

---

## Ringkasan Upgrade

| Versi | Deskripsi |
|-------|-----------|
| v0.3 | WebView exam app dasar, lockTaskMode, PIN check, canExecuteSu |
| v0.4 | **Semi-kiosk security architecture** — 6-layer anti-cheat system, implementasi langsung via Smali |

> **Catatan implementasi:** Semua kode keamanan baru diimplementasikan langsung sebagai file `.smali` (bukan Java source) sehingga bisa langsung di-rebuild dengan `apktool b` tanpa perlu Android Studio.

---

## Struktur Folder

```
smada xi/
├── SMAN_2_PAS-XI.0.3/                      ← source GABUNGAN X + XI (apktool decoded)
│   ├── AndroidManifest.xml                 ← diupdate, label: SMADA-PAS
│   ├── res/xml/device_admin_policies.xml   ← baru
│   ├── smali_classes3/com/example/SMAN_2_PASURUAN/
│   │   ├── MainActivity.smali              ← dipatch (6 method + kelas selector)
│   │   ├── ExamGuardService.smali          ← baru
│   │   └── ExamGuardService$1.smali        ← baru (Runnable poll loop)
│   └── src/com/example/SMAN_2_PASURUAN/
│       ├── ExamGuardService.java           ← referensi Java
│       ├── ExamSecurityManager.java        ← referensi Java
│       └── MainActivity_SecurityReference.java ← referensi Java
│
├── SMAN_2_PAS-X.0.3/                       ← source terpisah X (legacy, tidak dipakai)
│
├── SMAN_2_PAS-XI.0.4-unsigned.apk          ← build XI terpisah (legacy)
├── SMAN_2_PAS-X.0.3-unsigned.apk           ← build X terpisah (legacy)
├── SMAN_2_PAS-X.0.3-aligned-debugSigned.apk ← signed X terpisah (legacy)
├── SMAN_2_PAS-X-XI.0.4-unsigned.apk        ← build GABUNGAN X+XI
└── SMAN_2_PAS-X-XI.0.4-aligned-debugSigned.apk ← signed GABUNGAN, siap install
```

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

#### `smali_classes3/.../ExamGuardService.smali` ⭐ Deployed
**Foreground Service monitor keamanan** — diimplementasikan langsung sebagai Smali.

- Poll setiap **500ms** via `Handler.postDelayed` loop (`ExamGuardService$1.smali`)
- `UsageStatsManager.queryUsageStats` — deteksi foreground app tiap 500ms
- Allowlist: `com.example.SMAN_2_PASURUAN`, `android`, `com.android.systemui`, `com.samsung.android`, `com.miui.*`
- Jika app asing terdeteksi → `Process.killProcess(myPid())` + `System.exit(0)`
- Notifikasi ongoing "Ujian Sedang Berlangsung" (channel `exam_guard_channel`, tidak bisa di-dismiss)
- `onStartCommand` return `START_STICKY` — restart otomatis jika di-kill OS

#### `smali_classes3/.../ExamGuardService$1.smali` ⭐ Deployed
Runnable inner class untuk poll loop. Menggunakan `invoke-virtual/range` untuk
`queryUsageStats(IJJ)` agar register konsekutif (v1–v6) — wajib untuk Dalvik.

---

#### `src/.../ExamSecurityManager.java` *(referensi Java)*
Kelas pusat logic keamanan — untuk referensi jika project di-rebuild dari Android Studio.

| Method | Fungsi |
|--------|--------|
| `applyWindowSecurity()` | Pasang `FLAG_SECURE`, `FLAG_KEEP_SCREEN_ON` |
| `enterImmersiveMode()` | Full immersive sticky, support Android 11+ & legacy |
| `tryStartLockTask()` | Screen pinning via `startLockTask()` |
| `killExam(reason)` | Kill sequence: `stopService` → `stopLockTask` → `finishAndRemoveTask` → `finishAffinity` → `System.exit(0)` |
| `runIntegrityChecks()` | Root + ADB + Dev Options + package scan + debugger check |
| `isDeviceRooted()` | Cek su binary, busybox, test-keys build tag, `/system` writable |
| `hasRootPackagesInstalled()` | Scan 12 paket root (Magisk, SuperSU, dll) via `PackageManager` |

---

#### `MainActivity.smali` — Patch yang Diterapkan ⭐ Deployed

| Method | Perubahan | Aksi |
|--------|-----------|------|
| `onResume` | Ditambah inject di awal | `startService(ExamGuardService)` setiap kali resume |
| `onWindowFocusChanged` | Ditulis ulang total | Focus hilang + tidak ada pending dialog → **kill sequence** |
| `onMultiWindowModeChanged` | Upgrade dari `finish()` | `finishAndRemoveTask` + `finishAffinity` + `System.exit(0)` |
| `onPause` | **Ditambahkan baru** | Background → kill (skip jika `pendingOverlayRequest` / `pendingDevRequest`) |
| `onStop` | **Ditambahkan baru** | Completely hidden → kill |
| `onUserLeaveHint` | **Ditambahkan baru** | Home/Recents button → kill |
| URL selector (line 1964) | **Gabungan X+XI** | Baca SharedPreferences `"kelas"` → load URL xi/x; jika belum set → tampil dialog pilih |

> Guard flag `pendingOverlayRequest` dan `pendingDevRequest` (sudah ada di kode lama) digunakan sebagai bypass sah saat app menunggu user memberi izin di Settings — mencegah false-positive kill.

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

## Cara Rebuild APK

### APK Gabungan X + XI (cara yang dipakai sekarang)

```powershell
# Rebuild satu APK untuk semua kelas
apktool b SMAN_2_PAS-XI.0.3 -o SMAN_2_PAS-X-XI.0.4-unsigned.apk

# Sign
java -jar "uber-apk-signer-1.3.0 (1).jar" --apks SMAN_2_PAS-X-XI.0.4-unsigned.apk
```

Output signed: `SMAN_2_PAS-X-XI.0.4-aligned-debugSigned.apk` — langsung bisa diinstall di HP siswa kelas X maupun XI.

### Rebuild APK terpisah per kelas (legacy)

```powershell
# Kelas XI
apktool b SMAN_2_PAS-XI.0.3 -o SMAN_2_PAS-XI.0.4-unsigned.apk

# Kelas X
apktool b SMAN_2_PAS-X.0.3 -o SMAN_2_PAS-X.0.3-unsigned.apk

# Sign
java -jar "uber-apk-signer-1.3.0 (1).jar" --apks SMAN_2_PAS-XI.0.4-unsigned.apk
java -jar "uber-apk-signer-1.3.0 (1).jar" --apks SMAN_2_PAS-X.0.3-unsigned.apk
```

### Membuat varian kelas baru (misal Kelas XII)

```powershell
# Copy folder gabungan sebagai base
Copy-Item -Recurse SMAN_2_PAS-XI.0.3 SMAN_2_PAS-XII.0.3

# Tambahkan URL XII di MainActivity.smali (bagian selector kelas)
# Tambahkan case baru: "xii" → "https://smadapas.biz.id/xii-adminnya./"

# Ganti label di AndroidManifest.xml
# android:label="SMADA-PAS"   (sudah generik, tidak perlu diganti)

apktool b SMAN_2_PAS-XII.0.3 -o SMAN_2_PAS-XII.0.3-unsigned.apk
java -jar "uber-apk-signer-1.3.0 (1).jar" --apks SMAN_2_PAS-XII.0.3-unsigned.apk
```

### Dari Android Studio (jika punya source project)

1. Copy `ExamGuardService.java` dan `ExamSecurityManager.java` ke `app/src/main/java/com/example/SMAN_2_PASURUAN/`
2. Copy `res/xml/device_admin_policies.xml`
3. Merge `AndroidManifest.xml`
4. Integrasikan method dari `MainActivity_SecurityReference.java` ke `MainActivity.java`
5. Implementasikan SharedPreferences kelas selector di method yang load WebView URL
6. Build release (`debuggable=false` otomatis)

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
*Tools: apktool 2.12.1, uber-apk-signer 1.3.0*  
*APK gabungan: Kelas X dan XI menggunakan satu APK dengan SharedPreferences selector*
