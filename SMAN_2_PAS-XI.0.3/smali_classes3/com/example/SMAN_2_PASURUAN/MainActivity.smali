.class public Lcom/example/SMAN_2_PASURUAN/MainActivity;
.super Landroidx/appcompat/app/AppCompatActivity;
.source "MainActivity.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/example/SMAN_2_PASURUAN/MainActivity$mywebClient;
    }
.end annotation


# static fields
.field private static final PIN_TIMEOUT_MS:J = 0x1388L

.field private static final REQUEST_DEV_SETTINGS:I = 0x3ea

.field private static final REQUEST_OVERLAY:I = 0x3e9


# instance fields
.field private imageObserver:Landroid/database/ContentObserver;

.field private mywebView:Landroid/webkit/WebView;

.field private pendingDevRequest:Z

.field private pendingOverlayRequest:Z

.field private final pinCheckRunnable:Ljava/lang/Runnable;

.field private final pinHandler:Landroid/os/Handler;

.field private requestedPin:Z

.field private requestedPinTime:J

.field private videoObserver:Landroid/database/ContentObserver;


# direct methods
.method public constructor <init>()V
    .locals 3

    .line 37
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V

    .line 41
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->requestedPin:Z

    .line 42
    const-wide/16 v1, 0x0

    iput-wide v1, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->requestedPinTime:J

    .line 45
    new-instance v1, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v1, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pinHandler:Landroid/os/Handler;

    .line 46
    new-instance v1, Lcom/example/SMAN_2_PASURUAN/MainActivity$1;

    invoke-direct {v1, p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity$1;-><init>(Lcom/example/SMAN_2_PASURUAN/MainActivity;)V

    iput-object v1, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pinCheckRunnable:Ljava/lang/Runnable;

    .line 52
    iput-boolean v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pendingOverlayRequest:Z

    .line 53
    iput-boolean v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pendingDevRequest:Z

    return-void
.end method

.method static synthetic access$000(Lcom/example/SMAN_2_PASURUAN/MainActivity;)V
    .locals 0
    .param p0, "x0"    # Lcom/example/SMAN_2_PASURUAN/MainActivity;

    .line 37
    invoke-direct {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->checkLockTaskStateAndMaybeClose()V

    return-void
.end method

.method static synthetic access$100(Lcom/example/SMAN_2_PASURUAN/MainActivity;Z)V
    .locals 0
    .param p0, "x0"    # Lcom/example/SMAN_2_PASURUAN/MainActivity;
    .param p1, "x1"    # Z

    .line 37
    invoke-direct {p0, p1}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->handleMediaChange(Z)V

    return-void
.end method

.method private canExecuteSu()Z
    .locals 7

    .line 556
    const/4 v0, 0x0

    .line 557
    .local v0, "process":Ljava/lang/Process;
    const/4 v1, 0x0

    .line 559
    .local v1, "in":Ljava/io/BufferedReader;
    const/4 v2, 0x0

    :try_start_0
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;

    move-result-object v3

    const/4 v4, 0x2

    new-array v4, v4, [Ljava/lang/String;

    const-string v5, "/system/xbin/which"

    aput-object v5, v4, v2

    const-string v5, "su"

    const/4 v6, 0x1

    aput-object v5, v4, v6

    invoke-virtual {v3, v4}, Ljava/lang/Runtime;->exec([Ljava/lang/String;)Ljava/lang/Process;

    move-result-object v3

    move-object v0, v3

    .line 560
    new-instance v3, Ljava/io/BufferedReader;

    new-instance v4, Ljava/io/InputStreamReader;

    invoke-virtual {v0}, Ljava/lang/Process;->getInputStream()Ljava/io/InputStream;

    move-result-object v5

    invoke-direct {v4, v5}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;)V

    invoke-direct {v3, v4}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    move-object v1, v3

    .line 561
    invoke-virtual {v1}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v3
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 562
    .local v3, "line":Ljava/lang/String;
    if-eqz v3, :cond_0

    move v2, v6

    .line 567
    :cond_0
    :try_start_1
    invoke-virtual {v1}, Ljava/io/BufferedReader;->close()V

    .line 568
    if-eqz v0, :cond_1

    invoke-virtual {v0}, Ljava/lang/Process;->destroy()V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    .line 569
    :cond_1
    :goto_0
    goto :goto_1

    :catch_0
    move-exception v4

    goto :goto_0

    .line 562
    :goto_1
    return v2

    .line 563
    .end local v3    # "line":Ljava/lang/String;
    :catchall_0
    move-exception v3

    .line 564
    .local v3, "t":Ljava/lang/Throwable;
    nop

    .line 567
    if-eqz v1, :cond_2

    :try_start_2
    invoke-virtual {v1}, Ljava/io/BufferedReader;->close()V

    goto :goto_2

    .line 569
    :catch_1
    move-exception v4

    goto :goto_3

    .line 568
    :cond_2
    :goto_2
    if-eqz v0, :cond_3

    invoke-virtual {v0}, Ljava/lang/Process;->destroy()V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_1

    .line 569
    :cond_3
    :goto_3
    nop

    .line 564
    return v2
.end method

.method private checkLockTaskStateAndMaybeClose()V
    .locals 4

    .line 373
    nop

    .line 374
    :try_start_0
    const-string v0, "activity"

    invoke-virtual {p0, v0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/ActivityManager;

    .line 375
    .local v0, "am":Landroid/app/ActivityManager;
    const/4 v1, 0x0

    .line 376
    .local v1, "mode":I
    if-eqz v0, :cond_0

    invoke-virtual {v0}, Landroid/app/ActivityManager;->getLockTaskModeState()I

    move-result v2

    move v1, v2

    .line 377
    :cond_0
    if-eqz v1, :cond_1

    .line 379
    const/4 v2, 0x0

    iput-boolean v2, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->requestedPin:Z

    .line 380
    const-wide/16 v2, 0x0

    iput-wide v2, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->requestedPinTime:J

    .line 381
    iget-object v2, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pinHandler:Landroid/os/Handler;

    iget-object v3, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pinCheckRunnable:Ljava/lang/Runnable;

    invoke-virtual {v2, v3}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 382
    invoke-direct {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->onPinnedSuccess()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 383
    return-void

    .line 385
    .end local v0    # "am":Landroid/app/ActivityManager;
    .end local v1    # "mode":I
    :cond_1
    goto :goto_0

    .line 393
    :catch_0
    move-exception v0

    :goto_0
    nop

    .line 396
    new-instance v0, Lcom/example/SMAN_2_PASURUAN/MainActivity$$ExternalSyntheticLambda9;

    invoke-direct {v0, p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity$$ExternalSyntheticLambda9;-><init>(Lcom/example/SMAN_2_PASURUAN/MainActivity;)V

    invoke-virtual {p0, v0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 406
    return-void
.end method

.method private handleMediaChange(Z)V
    .locals 1
    .param p1, "isImage"    # Z

    .line 250
    :try_start_0
    invoke-direct {p0, p1}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->isPotentialScreenshotOrRecording(Z)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 251
    new-instance v0, Lcom/example/SMAN_2_PASURUAN/MainActivity$$ExternalSyntheticLambda5;

    invoke-direct {v0, p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity$$ExternalSyntheticLambda5;-><init>(Lcom/example/SMAN_2_PASURUAN/MainActivity;)V

    invoke-virtual {p0, v0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->runOnUiThread(Ljava/lang/Runnable;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 256
    :catch_0
    move-exception v0

    :cond_0
    :goto_0
    nop

    .line 257
    return-void
.end method

.method private initUiAndRequestPin()V
    .locals 8

    .line 299
    sget v0, Lcom/example/SMAN_2_PASURUAN/R$layout;->activity_main:I

    invoke-virtual {p0, v0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->setContentView(I)V

    .line 300
    sget v0, Lcom/example/SMAN_2_PASURUAN/R$id;->webview:I

    invoke-virtual {p0, v0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/webkit/WebView;

    iput-object v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->mywebView:Landroid/webkit/WebView;

    .line 301
    new-instance v1, Landroid/webkit/WebViewClient;

    invoke-direct {v1}, Landroid/webkit/WebViewClient;-><init>()V

    invoke-virtual {v0, v1}, Landroid/webkit/WebView;->setWebViewClient(Landroid/webkit/WebViewClient;)V

    .line 302
    iget-object v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->mywebView:Landroid/webkit/WebView;

    invoke-virtual {v0}, Landroid/webkit/WebView;->getSettings()Landroid/webkit/WebSettings;

    move-result-object v0

    .line 303
    .local v0, "webSettings":Landroid/webkit/WebSettings;
    iget-object v1, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->mywebView:Landroid/webkit/WebView;

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/webkit/WebView;->clearCache(Z)V

    .line 304
    iget-object v1, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->mywebView:Landroid/webkit/WebView;

    invoke-virtual {v1}, Landroid/webkit/WebView;->clearHistory()V

    .line 305
    const/4 v1, 0x2

    invoke-virtual {v0, v1}, Landroid/webkit/WebSettings;->setCacheMode(I)V

    .line 306
    invoke-virtual {v0, v2}, Landroid/webkit/WebSettings;->setJavaScriptEnabled(Z)V

    .line 308
    const-string v1, "device_policy"

    invoke-virtual {p0, v1}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/app/admin/DevicePolicyManager;

    .line 312
    .local v1, "mDevicePolicyManager":Landroid/app/admin/DevicePolicyManager;
    const/4 v3, 0x0

    .line 314
    .local v3, "alreadyLocked":Z
    const/4 v4, 0x0

    :try_start_0
    const-string v5, "activity"

    invoke-virtual {p0, v5}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Landroid/app/ActivityManager;

    .line 315
    .local v5, "am":Landroid/app/ActivityManager;
    if-eqz v5, :cond_1

    .line 316
    invoke-virtual {v5}, Landroid/app/ActivityManager;->getLockTaskModeState()I

    move-result v6
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 317
    .local v6, "mode":I
    if-eqz v6, :cond_0

    move v7, v2

    goto :goto_0

    :cond_0
    move v7, v4

    :goto_0
    move v3, v7

    goto :goto_1

    .line 319
    .end local v5    # "am":Landroid/app/ActivityManager;
    .end local v6    # "mode":I
    :catch_0
    move-exception v5

    :cond_1
    :goto_1
    nop

    .line 321
    if-nez v3, :cond_2

    .line 324
    :try_start_1
    new-instance v5, Landroid/content/ComponentName;

    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->getApplicationContext()Landroid/content/Context;

    move-result-object v6

    const-class v7, Lcom/example/SMAN_2_PASURUAN/MyDeviceAdminReceiver;

    invoke-direct {v5, v6, v7}, Landroid/content/ComponentName;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 325
    .local v5, "admin":Landroid/content/ComponentName;
    new-array v2, v2, [Ljava/lang/String;

    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->getPackageName()Ljava/lang/String;

    move-result-object v6

    aput-object v6, v2, v4

    invoke-virtual {v1, v5, v2}, Landroid/app/admin/DevicePolicyManager;->setLockTaskPackages(Landroid/content/ComponentName;[Ljava/lang/String;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    .end local v5    # "admin":Landroid/content/ComponentName;
    goto :goto_2

    .line 326
    :catch_1
    move-exception v2

    :goto_2
    nop

    .line 329
    invoke-direct {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->startPinRequest()V

    goto :goto_3

    .line 333
    :cond_2
    iput-boolean v4, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->requestedPin:Z

    .line 334
    const-wide/16 v4, 0x0

    iput-wide v4, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->requestedPinTime:J

    .line 335
    iget-object v2, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pinHandler:Landroid/os/Handler;

    iget-object v4, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pinCheckRunnable:Ljava/lang/Runnable;

    invoke-virtual {v2, v4}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 336
    invoke-direct {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->onPinnedSuccess()V

    .line 338
    :goto_3
    return-void
.end method

.method private isAdbEnabled()Z
    .locals 4

    .line 515
    const-string v0, "adb_enabled"

    const/4 v1, 0x0

    .line 517
    .local v1, "adb":I
    :try_start_0
    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    invoke-static {v2, v0}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;)I

    move-result v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 524
    .end local v1    # "adb":I
    .local v0, "adb":I
    goto :goto_0

    .line 518
    .end local v0    # "adb":I
    .restart local v1    # "adb":I
    :catch_0
    move-exception v2

    .line 520
    .local v2, "e":Ljava/lang/Exception;
    :try_start_1
    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v3

    invoke-static {v3, v0}, Landroid/provider/Settings$Secure;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;)I

    move-result v0
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    .line 523
    .end local v1    # "adb":I
    .restart local v0    # "adb":I
    goto :goto_0

    .line 521
    .end local v0    # "adb":I
    .restart local v1    # "adb":I
    :catch_1
    move-exception v0

    .line 522
    .local v0, "ex":Ljava/lang/Exception;
    const/4 v1, 0x0

    move v0, v1

    .line 525
    .end local v1    # "adb":I
    .end local v2    # "e":Ljava/lang/Exception;
    .local v0, "adb":I
    :goto_0
    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    goto :goto_1

    :cond_0
    const/4 v1, 0x0

    :goto_1
    return v1
.end method

.method private isAssistantVisible()Z
    .locals 6

    .line 177
    const/4 v0, 0x0

    :try_start_0
    const-string v1, "activity"

    invoke-virtual {p0, v1}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/app/ActivityManager;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1

    .line 178
    .local v1, "am":Landroid/app/ActivityManager;
    if-nez v1, :cond_0

    return v0

    .line 182
    :cond_0
    :try_start_1
    invoke-virtual {v1}, Landroid/app/ActivityManager;->getRunningAppProcesses()Ljava/util/List;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :goto_0
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_4

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/app/ActivityManager$RunningAppProcessInfo;

    .line 183
    .local v3, "proc":Landroid/app/ActivityManager$RunningAppProcessInfo;
    if-eqz v3, :cond_3

    iget v4, v3, Landroid/app/ActivityManager$RunningAppProcessInfo;->importance:I

    const/16 v5, 0x64

    if-ne v4, v5, :cond_3

    .line 184
    iget-object v4, v3, Landroid/app/ActivityManager$RunningAppProcessInfo;->processName:Ljava/lang/String;

    if-eqz v4, :cond_1

    iget-object v4, v3, Landroid/app/ActivityManager$RunningAppProcessInfo;->processName:Ljava/lang/String;

    invoke-virtual {v4}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v4

    goto :goto_1

    :cond_1
    const-string v4, ""

    .line 185
    .local v4, "name":Ljava/lang/String;
    :goto_1
    const-string v5, "googlequicksearchbox"

    invoke-virtual {v4, v5}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v5

    if-nez v5, :cond_2

    const-string v5, "assistant"

    invoke-virtual {v4, v5}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v5

    if-nez v5, :cond_2

    const-string v5, "opa"

    invoke-virtual {v4, v5}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v5
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    if-eqz v5, :cond_3

    .line 186
    :cond_2
    const/4 v0, 0x1

    return v0

    .line 189
    .end local v3    # "proc":Landroid/app/ActivityManager$RunningAppProcessInfo;
    .end local v4    # "name":Ljava/lang/String;
    :cond_3
    goto :goto_0

    .line 190
    :catch_0
    move-exception v2

    :cond_4
    nop

    .line 194
    nop

    .line 206
    goto :goto_2

    .line 208
    .end local v1    # "am":Landroid/app/ActivityManager;
    :catch_1
    move-exception v1

    :goto_2
    nop

    .line 209
    return v0
.end method

.method private isDeveloperOptionsEnabled()Z
    .locals 4

    .line 501
    const-string v0, "development_settings_enabled"

    const/4 v1, 0x0

    .line 503
    .local v1, "dev":I
    :try_start_0
    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    invoke-static {v2, v0}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;)I

    move-result v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 510
    .end local v1    # "dev":I
    .local v0, "dev":I
    goto :goto_0

    .line 504
    .end local v0    # "dev":I
    .restart local v1    # "dev":I
    :catch_0
    move-exception v2

    .line 506
    .local v2, "e":Ljava/lang/Exception;
    :try_start_1
    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v3

    invoke-static {v3, v0}, Landroid/provider/Settings$Secure;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;)I

    move-result v0
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    .line 509
    .end local v1    # "dev":I
    .restart local v0    # "dev":I
    goto :goto_0

    .line 507
    .end local v0    # "dev":I
    .restart local v1    # "dev":I
    :catch_1
    move-exception v0

    .line 508
    .local v0, "ex":Ljava/lang/Exception;
    const/4 v1, 0x0

    move v0, v1

    .line 511
    .end local v1    # "dev":I
    .end local v2    # "e":Ljava/lang/Exception;
    .local v0, "dev":I
    :goto_0
    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    goto :goto_1

    :cond_0
    const/4 v1, 0x0

    :goto_1
    return v1
.end method

.method private isDeviceRooted()Z
    .locals 12

    .line 530
    sget-object v0, Landroid/os/Build;->TAGS:Ljava/lang/String;

    .line 531
    .local v0, "buildTags":Ljava/lang/String;
    const/4 v1, 0x1

    if-eqz v0, :cond_0

    const-string v2, "test-keys"

    invoke-virtual {v0, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 532
    return v1

    .line 536
    :cond_0
    const-string v3, "/system/app/Superuser.apk"

    const-string v4, "/sbin/su"

    const-string v5, "/system/bin/su"

    const-string v6, "/system/xbin/su"

    const-string v7, "/data/local/xbin/su"

    const-string v8, "/data/local/bin/su"

    const-string v9, "/system/sd/xbin/su"

    const-string v10, "/system/bin/failsafe/su"

    const-string v11, "/data/local/su"

    filled-new-array/range {v3 .. v11}, [Ljava/lang/String;

    move-result-object v2

    .line 547
    .local v2, "paths":[Ljava/lang/String;
    array-length v3, v2

    const/4 v4, 0x0

    :goto_0
    if-ge v4, v3, :cond_2

    aget-object v5, v2, v4

    .line 548
    .local v5, "path":Ljava/lang/String;
    new-instance v6, Ljava/io/File;

    invoke-direct {v6, v5}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v6}, Ljava/io/File;->exists()Z

    move-result v6

    if-eqz v6, :cond_1

    return v1

    .line 547
    .end local v5    # "path":Ljava/lang/String;
    :cond_1
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 552
    :cond_2
    invoke-direct {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->canExecuteSu()Z

    move-result v1

    return v1
.end method

.method private isPotentialScreenshotOrRecording(Z)Z
    .locals 13
    .param p1, "isImage"    # Z

    .line 260
    const-string v0, "_display_name"

    const-string v1, "_data"

    const/4 v2, 0x0

    .line 262
    .local v2, "c":Landroid/database/Cursor;
    const/4 v3, 0x0

    if-eqz p1, :cond_0

    :try_start_0
    sget-object v4, Landroid/provider/MediaStore$Images$Media;->EXTERNAL_CONTENT_URI:Landroid/net/Uri;

    goto :goto_0

    :cond_0
    sget-object v4, Landroid/provider/MediaStore$Video$Media;->EXTERNAL_CONTENT_URI:Landroid/net/Uri;

    :goto_0
    move-object v6, v4

    .line 263
    .local v6, "uri":Landroid/net/Uri;
    const/4 v4, 0x3

    new-array v7, v4, [Ljava/lang/String;

    aput-object v1, v7, v3

    const/4 v4, 0x1

    aput-object v0, v7, v4

    const-string v5, "date_added"

    const/4 v8, 0x2

    aput-object v5, v7, v8

    .line 264
    .local v7, "projection":[Ljava/lang/String;
    const-string v5, "date_added DESC"

    move-object v11, v5

    .line 265
    .local v11, "order":Ljava/lang/String;
    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v5

    const/4 v8, 0x0

    const/4 v9, 0x0

    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    const-string v12, " LIMIT 1"

    invoke-virtual {v10, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v10

    invoke-virtual/range {v5 .. v10}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v5

    move-object v2, v5

    .line 266
    if-eqz v2, :cond_5

    invoke-interface {v2}, Landroid/database/Cursor;->moveToFirst()Z

    move-result v5
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_5
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v5, :cond_5

    .line 267
    const/4 v5, 0x0

    .line 268
    .local v5, "path":Ljava/lang/String;
    const/4 v8, -0x1

    .line 269
    .local v8, "idx":I
    :try_start_1
    invoke-interface {v2, v1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v1
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    move v8, v1

    goto :goto_1

    :catch_0
    move-exception v1

    .line 270
    :goto_1
    const/4 v1, -0x1

    if-eq v8, v1, :cond_1

    :try_start_2
    invoke-interface {v2, v8}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v9
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_5
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    move-object v5, v9

    .line 271
    :cond_1
    if-nez v5, :cond_2

    .line 272
    :try_start_3
    invoke-interface {v2, v0}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v0
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_1
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    move v8, v0

    goto :goto_2

    :catch_1
    move-exception v0

    .line 273
    :goto_2
    if-eq v8, v1, :cond_2

    :try_start_4
    invoke-interface {v2, v8}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v0

    move-object v5, v0

    .line 275
    :cond_2
    if-eqz v5, :cond_5

    .line 276
    invoke-virtual {v5}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v0

    .line 277
    .local v0, "p":Ljava/lang/String;
    const-string v1, "screenshots"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_3

    const-string v1, "screenshot"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_3

    const-string v1, "screenrecord"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_3

    const-string v1, "screen_record"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_3

    const-string v1, "screenrec"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_3

    const-string v1, "screenrecorder"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_3

    const-string v1, "recording"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_3

    const-string v1, "recordings"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_5
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    if-eqz v1, :cond_5

    .line 278
    :cond_3
    nop

    .line 283
    if-eqz v2, :cond_4

    :try_start_5
    invoke-interface {v2}, Landroid/database/Cursor;->close()V
    :try_end_5
    .catch Ljava/lang/Exception; {:try_start_5 .. :try_end_5} :catch_2

    goto :goto_3

    :catch_2
    move-exception v1

    .line 278
    :cond_4
    :goto_3
    return v4

    .line 283
    .end local v0    # "p":Ljava/lang/String;
    .end local v5    # "path":Ljava/lang/String;
    .end local v6    # "uri":Landroid/net/Uri;
    .end local v7    # "projection":[Ljava/lang/String;
    .end local v8    # "idx":I
    .end local v11    # "order":Ljava/lang/String;
    :cond_5
    if-eqz v2, :cond_7

    :try_start_6
    invoke-interface {v2}, Landroid/database/Cursor;->close()V
    :try_end_6
    .catch Ljava/lang/Exception; {:try_start_6 .. :try_end_6} :catch_3

    goto :goto_5

    :catch_3
    move-exception v0

    goto :goto_5

    :catchall_0
    move-exception v0

    if-eqz v2, :cond_6

    :try_start_7
    invoke-interface {v2}, Landroid/database/Cursor;->close()V
    :try_end_7
    .catch Ljava/lang/Exception; {:try_start_7 .. :try_end_7} :catch_4

    goto :goto_4

    :catch_4
    move-exception v1

    :cond_6
    :goto_4
    throw v0

    .line 282
    :catch_5
    move-exception v0

    .line 283
    if-eqz v2, :cond_7

    :try_start_8
    invoke-interface {v2}, Landroid/database/Cursor;->close()V
    :try_end_8
    .catch Ljava/lang/Exception; {:try_start_8 .. :try_end_8} :catch_3

    .line 284
    :cond_7
    :goto_5
    return v3
.end method

.method private onPinnedSuccess()V
    .locals 1

    .line 410
    new-instance v0, Lcom/example/SMAN_2_PASURUAN/MainActivity$$ExternalSyntheticLambda6;

    invoke-direct {v0, p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity$$ExternalSyntheticLambda6;-><init>(Lcom/example/SMAN_2_PASURUAN/MainActivity;)V

    invoke-virtual {p0, v0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 425
    return-void
.end method

.method private registerMediaObservers()V
    .locals 5

    .line 214
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    .line 216
    .local v0, "handler":Landroid/os/Handler;
    new-instance v1, Lcom/example/SMAN_2_PASURUAN/MainActivity$2;

    invoke-direct {v1, p0, v0}, Lcom/example/SMAN_2_PASURUAN/MainActivity$2;-><init>(Lcom/example/SMAN_2_PASURUAN/MainActivity;Landroid/os/Handler;)V

    iput-object v1, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->imageObserver:Landroid/database/ContentObserver;

    .line 228
    new-instance v1, Lcom/example/SMAN_2_PASURUAN/MainActivity$3;

    invoke-direct {v1, p0, v0}, Lcom/example/SMAN_2_PASURUAN/MainActivity$3;-><init>(Lcom/example/SMAN_2_PASURUAN/MainActivity;Landroid/os/Handler;)V

    iput-object v1, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->videoObserver:Landroid/database/ContentObserver;

    .line 241
    const/4 v1, 0x1

    :try_start_0
    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    sget-object v3, Landroid/provider/MediaStore$Images$Media;->EXTERNAL_CONTENT_URI:Landroid/net/Uri;

    iget-object v4, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->imageObserver:Landroid/database/ContentObserver;

    invoke-virtual {v2, v3, v1, v4}, Landroid/content/ContentResolver;->registerContentObserver(Landroid/net/Uri;ZLandroid/database/ContentObserver;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 242
    :catch_0
    move-exception v2

    :goto_0
    nop

    .line 244
    :try_start_1
    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    sget-object v3, Landroid/provider/MediaStore$Video$Media;->EXTERNAL_CONTENT_URI:Landroid/net/Uri;

    iget-object v4, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->videoObserver:Landroid/database/ContentObserver;

    invoke-virtual {v2, v3, v1, v4}, Landroid/content/ContentResolver;->registerContentObserver(Landroid/net/Uri;ZLandroid/database/ContentObserver;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_1

    .line 245
    :catch_1
    move-exception v1

    :goto_1
    nop

    .line 246
    return-void
.end method

.method private showBlockedDialogAndExit(Ljava/lang/String;)V
    .locals 3
    .param p1, "message"    # Ljava/lang/String;

    .line 488
    new-instance v0, Landroidx/appcompat/app/AlertDialog$Builder;

    invoke-direct {v0, p0}, Landroidx/appcompat/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    .line 489
    const-string v1, "Akses Ditolak"

    invoke-virtual {v0, v1}, Landroidx/appcompat/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroidx/appcompat/app/AlertDialog$Builder;

    move-result-object v0

    .line 490
    invoke-virtual {v0, p1}, Landroidx/appcompat/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroidx/appcompat/app/AlertDialog$Builder;

    move-result-object v0

    .line 491
    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroidx/appcompat/app/AlertDialog$Builder;->setCancelable(Z)Landroidx/appcompat/app/AlertDialog$Builder;

    move-result-object v0

    new-instance v1, Lcom/example/SMAN_2_PASURUAN/MainActivity$$ExternalSyntheticLambda8;

    invoke-direct {v1, p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity$$ExternalSyntheticLambda8;-><init>(Lcom/example/SMAN_2_PASURUAN/MainActivity;)V

    .line 492
    const-string v2, "OK"

    invoke-virtual {v0, v2, v1}, Landroidx/appcompat/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroidx/appcompat/app/AlertDialog$Builder;

    move-result-object v0

    .line 497
    invoke-virtual {v0}, Landroidx/appcompat/app/AlertDialog$Builder;->show()Landroidx/appcompat/app/AlertDialog;

    .line 498
    return-void
.end method

.method private showDevRequireDisableAndOpenSettings(ZZ)V
    .locals 4
    .param p1, "devEnabled"    # Z
    .param p2, "adbEnabled"    # Z

    .line 428
    const-string v0, "Perangkat memiliki Developer Options/ADB aktif. Aplikasi ini harus dijalankan tanpa Developer Options atau ADB aktif."

    .line 429
    .local v0, "msg":Ljava/lang/String;
    if-eqz p1, :cond_0

    if-eqz p2, :cond_0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " (Developer + ADB)."

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    .line 430
    :cond_0
    if-eqz p1, :cond_1

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " (Developer)."

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    .line 431
    :cond_1
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " (ADB)."

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 432
    :goto_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "\n\nSilakan matikan Developer Options/ADB di pengaturan. Jika tidak, aplikasi akan ditutup."

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 434
    new-instance v1, Landroidx/appcompat/app/AlertDialog$Builder;

    invoke-direct {v1, p0}, Landroidx/appcompat/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    .line 435
    const-string v2, "Matikan Developer Options / ADB"

    invoke-virtual {v1, v2}, Landroidx/appcompat/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroidx/appcompat/app/AlertDialog$Builder;

    move-result-object v1

    .line 436
    invoke-virtual {v1, v0}, Landroidx/appcompat/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroidx/appcompat/app/AlertDialog$Builder;

    move-result-object v1

    .line 437
    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Landroidx/appcompat/app/AlertDialog$Builder;->setCancelable(Z)Landroidx/appcompat/app/AlertDialog$Builder;

    move-result-object v1

    new-instance v2, Lcom/example/SMAN_2_PASURUAN/MainActivity$$ExternalSyntheticLambda3;

    invoke-direct {v2, p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity$$ExternalSyntheticLambda3;-><init>(Lcom/example/SMAN_2_PASURUAN/MainActivity;)V

    .line 438
    const-string v3, "Tutup"

    invoke-virtual {v1, v3, v2}, Landroidx/appcompat/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroidx/appcompat/app/AlertDialog$Builder;

    move-result-object v1

    new-instance v2, Lcom/example/SMAN_2_PASURUAN/MainActivity$$ExternalSyntheticLambda4;

    invoke-direct {v2, p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity$$ExternalSyntheticLambda4;-><init>(Lcom/example/SMAN_2_PASURUAN/MainActivity;)V

    .line 443
    const-string v3, "Buka Pengaturan"

    invoke-virtual {v1, v3, v2}, Landroidx/appcompat/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroidx/appcompat/app/AlertDialog$Builder;

    move-result-object v1

    .line 454
    invoke-virtual {v1}, Landroidx/appcompat/app/AlertDialog$Builder;->show()Landroidx/appcompat/app/AlertDialog;

    .line 455
    return-void
.end method

.method private startPinRequest()V
    .locals 4

    .line 342
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->requestedPin:Z

    .line 343
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->requestedPinTime:J

    .line 346
    :try_start_0
    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->startLockTask()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 347
    :goto_0
    goto :goto_1

    :catch_0
    move-exception v0

    goto :goto_0

    .line 351
    :goto_1
    nop

    .line 352
    :try_start_1
    const-string v0, "activity"

    invoke-virtual {p0, v0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/ActivityManager;

    .line 353
    .local v0, "am":Landroid/app/ActivityManager;
    if-eqz v0, :cond_0

    .line 354
    invoke-virtual {v0}, Landroid/app/ActivityManager;->getLockTaskModeState()I

    move-result v1

    .line 355
    .local v1, "mode":I
    if-eqz v1, :cond_0

    .line 356
    const/4 v2, 0x0

    iput-boolean v2, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->requestedPin:Z

    .line 357
    const-wide/16 v2, 0x0

    iput-wide v2, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->requestedPinTime:J

    .line 358
    iget-object v2, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pinHandler:Landroid/os/Handler;

    iget-object v3, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pinCheckRunnable:Ljava/lang/Runnable;

    invoke-virtual {v2, v3}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 359
    invoke-direct {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->onPinnedSuccess()V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    .line 360
    return-void

    .line 364
    .end local v0    # "am":Landroid/app/ActivityManager;
    .end local v1    # "mode":I
    :catch_1
    move-exception v0

    :cond_0
    nop

    .line 367
    iget-object v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pinHandler:Landroid/os/Handler;

    iget-object v1, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pinCheckRunnable:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 368
    iget-object v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pinHandler:Landroid/os/Handler;

    iget-object v1, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pinCheckRunnable:Ljava/lang/Runnable;

    const-wide/16 v2, 0x1388

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 369
    return-void
.end method


# virtual methods
.method public customExitDialog()V
    .locals 4

    .line 575
    new-instance v0, Landroid/app/Dialog;

    invoke-direct {v0, p0}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    .line 578
    .local v0, "dialog":Landroid/app/Dialog;
    sget v1, Lcom/example/SMAN_2_PASURUAN/R$layout;->custom_exit_dialog:I

    invoke-virtual {v0, v1}, Landroid/app/Dialog;->setContentView(I)V

    .line 581
    sget v1, Lcom/example/SMAN_2_PASURUAN/R$id;->textViewYes:I

    invoke-virtual {v0, v1}, Landroid/app/Dialog;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/TextView;

    .line 582
    .local v1, "dialogButtonYes":Landroid/widget/TextView;
    sget v2, Lcom/example/SMAN_2_PASURUAN/R$id;->textViewNo:I

    invoke-virtual {v0, v2}, Landroid/app/Dialog;->findViewById(I)Landroid/view/View;

    move-result-object v2

    check-cast v2, Landroid/widget/TextView;

    .line 585
    .local v2, "dialogButtonNo":Landroid/widget/TextView;
    new-instance v3, Lcom/example/SMAN_2_PASURUAN/MainActivity$4;

    invoke-direct {v3, p0, v0}, Lcom/example/SMAN_2_PASURUAN/MainActivity$4;-><init>(Lcom/example/SMAN_2_PASURUAN/MainActivity;Landroid/app/Dialog;)V

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 594
    new-instance v3, Lcom/example/SMAN_2_PASURUAN/MainActivity$5;

    invoke-direct {v3, p0, v0}, Lcom/example/SMAN_2_PASURUAN/MainActivity$5;-><init>(Lcom/example/SMAN_2_PASURUAN/MainActivity;Landroid/app/Dialog;)V

    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 606
    invoke-virtual {v0}, Landroid/app/Dialog;->show()V

    .line 607
    return-void
.end method

.method synthetic lambda$checkLockTaskStateAndMaybeClose$4$com-example-SMAN_2_PASURUAN-MainActivity(Landroid/content/DialogInterface;I)V
    .locals 1
    .param p1, "d"    # Landroid/content/DialogInterface;
    .param p2, "w"    # I

    .line 401
    invoke-interface {p1}, Landroid/content/DialogInterface;->dismiss()V

    .line 402
    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->finishAffinity()V

    .line 403
    const/4 v0, 0x0

    invoke-static {v0}, Ljava/lang/System;->exit(I)V

    .line 404
    return-void
.end method

.method synthetic lambda$checkLockTaskStateAndMaybeClose$5$com-example-SMAN_2_PASURUAN-MainActivity()V
    .locals 3

    .line 396
    new-instance v0, Landroidx/appcompat/app/AlertDialog$Builder;

    invoke-direct {v0, p0}, Landroidx/appcompat/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    .line 397
    const-string v1, "Aplikasi Tidak Disematkan"

    invoke-virtual {v0, v1}, Landroidx/appcompat/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroidx/appcompat/app/AlertDialog$Builder;

    move-result-object v0

    .line 398
    const-string v1, "Aplikasi tidak disematkan. Aplikasi akan ditutup."

    invoke-virtual {v0, v1}, Landroidx/appcompat/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroidx/appcompat/app/AlertDialog$Builder;

    move-result-object v0

    .line 399
    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroidx/appcompat/app/AlertDialog$Builder;->setCancelable(Z)Landroidx/appcompat/app/AlertDialog$Builder;

    move-result-object v0

    new-instance v1, Lcom/example/SMAN_2_PASURUAN/MainActivity$$ExternalSyntheticLambda7;

    invoke-direct {v1, p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity$$ExternalSyntheticLambda7;-><init>(Lcom/example/SMAN_2_PASURUAN/MainActivity;)V

    .line 400
    const-string v2, "OK"

    invoke-virtual {v0, v2, v1}, Landroidx/appcompat/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroidx/appcompat/app/AlertDialog$Builder;

    move-result-object v0

    .line 405
    invoke-virtual {v0}, Landroidx/appcompat/app/AlertDialog$Builder;->show()Landroidx/appcompat/app/AlertDialog;

    .line 396
    return-void
.end method

.method synthetic lambda$handleMediaChange$3$com-example-SMAN_2_PASURUAN-MainActivity()V
    .locals 1

    .line 252
    :try_start_0
    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->finishAffinity()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    .line 253
    :goto_0
    const/4 v0, 0x0

    invoke-static {v0}, Ljava/lang/System;->exit(I)V

    .line 254
    return-void
.end method

.method synthetic lambda$onCreate$0$com-example-SMAN_2_PASURUAN-MainActivity(Landroid/content/DialogInterface;I)V
    .locals 1
    .param p1, "d"    # Landroid/content/DialogInterface;
    .param p2, "w"    # I

    .line 103
    invoke-interface {p1}, Landroid/content/DialogInterface;->dismiss()V

    .line 104
    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->finishAffinity()V

    .line 105
    const/4 v0, 0x0

    invoke-static {v0}, Ljava/lang/System;->exit(I)V

    .line 106
    return-void
.end method

.method synthetic lambda$onCreate$1$com-example-SMAN_2_PASURUAN-MainActivity(Landroid/content/DialogInterface;I)V
    .locals 4
    .param p1, "d"    # Landroid/content/DialogInterface;
    .param p2, "w"    # I

    .line 108
    invoke-interface {p1}, Landroid/content/DialogInterface;->dismiss()V

    .line 110
    :try_start_0
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.settings.action.MANAGE_OVERLAY_PERMISSION"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "package:"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    .line 111
    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->getPackageName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v2

    invoke-direct {v0, v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    .line 112
    .local v0, "intent":Landroid/content/Intent;
    const/4 v1, 0x1

    iput-boolean v1, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pendingOverlayRequest:Z

    .line 113
    const/16 v1, 0x3e9

    invoke-virtual {p0, v0, v1}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->startActivityForResult(Landroid/content/Intent;I)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 117
    .end local v0    # "intent":Landroid/content/Intent;
    goto :goto_0

    .line 114
    :catch_0
    move-exception v0

    .line 116
    .local v0, "ex":Ljava/lang/Exception;
    const-string v1, "Tidak dapat membuka pengaturan izin overlay. Silakan berikan izin dan jalankan kembali."

    invoke-direct {p0, v1}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->showBlockedDialogAndExit(Ljava/lang/String;)V

    .line 118
    .end local v0    # "ex":Ljava/lang/Exception;
    :goto_0
    return-void
.end method

.method synthetic lambda$onPinnedSuccess$6$com-example-SMAN_2_PASURUAN-MainActivity()V
    .locals 3

    .line 413
    :try_start_0
    iget-object v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->mywebView:Landroid/webkit/WebView;

    const/4 v1, 0x1

    if-nez v0, :cond_0

    .line 414
    sget v0, Lcom/example/SMAN_2_PASURUAN/R$id;->webview:I

    invoke-virtual {p0, v0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/webkit/WebView;

    iput-object v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->mywebView:Landroid/webkit/WebView;

    .line 415
    new-instance v2, Landroid/webkit/WebViewClient;

    invoke-direct {v2}, Landroid/webkit/WebViewClient;-><init>()V

    invoke-virtual {v0, v2}, Landroid/webkit/WebView;->setWebViewClient(Landroid/webkit/WebViewClient;)V

    .line 416
    iget-object v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->mywebView:Landroid/webkit/WebView;

    invoke-virtual {v0}, Landroid/webkit/WebView;->getSettings()Landroid/webkit/WebSettings;

    move-result-object v0

    .line 417
    .local v0, "ws":Landroid/webkit/WebSettings;
    invoke-virtual {v0, v1}, Landroid/webkit/WebSettings;->setJavaScriptEnabled(Z)V

    .line 418
    const/4 v2, 0x2

    invoke-virtual {v0, v2}, Landroid/webkit/WebSettings;->setCacheMode(I)V

    .line 420
    .end local v0    # "ws":Landroid/webkit/WebSettings;
    :cond_0
    iget-object v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->mywebView:Landroid/webkit/WebView;

    invoke-virtual {v0, v1}, Landroid/webkit/WebView;->clearCache(Z)V

    .line 421
    iget-object v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->mywebView:Landroid/webkit/WebView;

    invoke-virtual {v0}, Landroid/webkit/WebView;->clearHistory()V

    .line 422
    iget-object v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->mywebView:Landroid/webkit/WebView;

    const-string v1, "https://smadapas.biz.id/xi-adminnya./"

    invoke-virtual {v0, v1}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 423
    :catch_0
    move-exception v0

    :goto_0
    nop

    .line 424
    return-void
.end method

.method synthetic lambda$onWindowFocusChanged$2$com-example-SMAN_2_PASURUAN-MainActivity()V
    .locals 1

    .line 165
    :try_start_0
    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->finishAffinity()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 166
    :goto_0
    goto :goto_1

    :catch_0
    move-exception v0

    goto :goto_0

    .line 167
    :goto_1
    const/4 v0, 0x0

    invoke-static {v0}, Ljava/lang/System;->exit(I)V

    .line 168
    return-void
.end method

.method synthetic lambda$showBlockedDialogAndExit$9$com-example-SMAN_2_PASURUAN-MainActivity(Landroid/content/DialogInterface;I)V
    .locals 1
    .param p1, "dialog"    # Landroid/content/DialogInterface;
    .param p2, "which"    # I

    .line 493
    invoke-interface {p1}, Landroid/content/DialogInterface;->dismiss()V

    .line 494
    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->finishAffinity()V

    .line 495
    const/4 v0, 0x0

    invoke-static {v0}, Ljava/lang/System;->exit(I)V

    .line 496
    return-void
.end method

.method synthetic lambda$showDevRequireDisableAndOpenSettings$7$com-example-SMAN_2_PASURUAN-MainActivity(Landroid/content/DialogInterface;I)V
    .locals 1
    .param p1, "d"    # Landroid/content/DialogInterface;
    .param p2, "w"    # I

    .line 439
    invoke-interface {p1}, Landroid/content/DialogInterface;->dismiss()V

    .line 440
    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->finishAffinity()V

    .line 441
    const/4 v0, 0x0

    invoke-static {v0}, Ljava/lang/System;->exit(I)V

    .line 442
    return-void
.end method

.method synthetic lambda$showDevRequireDisableAndOpenSettings$8$com-example-SMAN_2_PASURUAN-MainActivity(Landroid/content/DialogInterface;I)V
    .locals 2
    .param p1, "d"    # Landroid/content/DialogInterface;
    .param p2, "w"    # I

    .line 444
    invoke-interface {p1}, Landroid/content/DialogInterface;->dismiss()V

    .line 446
    :try_start_0
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.settings.APPLICATION_DEVELOPMENT_SETTINGS"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 447
    .local v0, "intent":Landroid/content/Intent;
    const/4 v1, 0x1

    iput-boolean v1, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pendingDevRequest:Z

    .line 448
    const/16 v1, 0x3ea

    invoke-virtual {p0, v0, v1}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->startActivityForResult(Landroid/content/Intent;I)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 452
    .end local v0    # "intent":Landroid/content/Intent;
    goto :goto_0

    .line 449
    :catch_0
    move-exception v0

    .line 451
    .local v0, "ex":Ljava/lang/Exception;
    const-string v1, "Tidak dapat membuka pengaturan Developer Options. Aplikasi ditutup."

    invoke-direct {p0, v1}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->showBlockedDialogAndExit(Ljava/lang/String;)V

    .line 453
    .end local v0    # "ex":Ljava/lang/Exception;
    :goto_0
    return-void
.end method

.method protected onActivityResult(IILandroid/content/Intent;)V
    .locals 2
    .param p1, "requestCode"    # I
    .param p2, "resultCode"    # I
    .param p3, "data"    # Landroid/content/Intent;

    .line 459
    invoke-super {p0, p1, p2, p3}, Landroidx/appcompat/app/AppCompatActivity;->onActivityResult(IILandroid/content/Intent;)V

    .line 460
    const/16 v0, 0x3e9

    const/4 v1, 0x1

    if-ne p1, v0, :cond_0

    .line 462
    iput-boolean v1, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pendingOverlayRequest:Z

    goto :goto_0

    .line 463
    :cond_0
    const/16 v0, 0x3ea

    if-ne p1, v0, :cond_1

    .line 465
    iput-boolean v1, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pendingDevRequest:Z

    .line 467
    :cond_1
    :goto_0
    return-void
.end method

.method public onBackPressed()V
    .locals 1

    .line 621
    iget-object v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->mywebView:Landroid/webkit/WebView;

    invoke-virtual {v0}, Landroid/webkit/WebView;->canGoBack()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 622
    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->customExitDialog()V

    goto :goto_0

    .line 626
    :cond_0
    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->customExitDialog()V

    .line 629
    :goto_0
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 4
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .line 70
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onCreate(Landroid/os/Bundle;)V

    .line 74
    :try_start_0
    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->getWindow()Landroid/view/Window;

    move-result-object v0

    const/16 v1, 0x2000

    invoke-virtual {v0, v1}, Landroid/view/Window;->addFlags(I)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 75
    :catch_0
    move-exception v0

    :goto_0
    nop

    .line 79
    :try_start_1
    invoke-direct {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->registerMediaObservers()V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    .line 80
    :goto_1
    goto :goto_2

    :catch_1
    move-exception v0

    goto :goto_1

    .line 83
    :goto_2
    invoke-direct {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->isDeviceRooted()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 84
    const-string v0, "Aplikasi tidak dapat dijalankan pada perangkat yang di-root."

    invoke-direct {p0, v0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->showBlockedDialogAndExit(Ljava/lang/String;)V

    .line 85
    return-void

    .line 89
    :cond_0
    const/4 v0, 0x1

    .line 91
    .local v0, "overlayAllowed":Z
    nop

    .line 92
    :try_start_2
    invoke-static {p0}, Landroid/provider/Settings;->canDrawOverlays(Landroid/content/Context;)Z

    move-result v1
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_2

    move v0, v1

    goto :goto_3

    .line 94
    :catch_2
    move-exception v1

    :goto_3
    nop

    .line 96
    if-nez v0, :cond_1

    .line 98
    new-instance v1, Landroidx/appcompat/app/AlertDialog$Builder;

    invoke-direct {v1, p0}, Landroidx/appcompat/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    .line 99
    const-string v2, "Izin Diperlukan"

    invoke-virtual {v1, v2}, Landroidx/appcompat/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroidx/appcompat/app/AlertDialog$Builder;

    move-result-object v1

    .line 100
    const-string v2, "Aplikasi memerlukan izin layar penuh/overlay. Berikan izin agar aplikasi dapat berjalan."

    invoke-virtual {v1, v2}, Landroidx/appcompat/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroidx/appcompat/app/AlertDialog$Builder;

    move-result-object v1

    .line 101
    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Landroidx/appcompat/app/AlertDialog$Builder;->setCancelable(Z)Landroidx/appcompat/app/AlertDialog$Builder;

    move-result-object v1

    new-instance v2, Lcom/example/SMAN_2_PASURUAN/MainActivity$$ExternalSyntheticLambda0;

    invoke-direct {v2, p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity$$ExternalSyntheticLambda0;-><init>(Lcom/example/SMAN_2_PASURUAN/MainActivity;)V

    .line 102
    const-string v3, "Tutup"

    invoke-virtual {v1, v3, v2}, Landroidx/appcompat/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroidx/appcompat/app/AlertDialog$Builder;

    move-result-object v1

    new-instance v2, Lcom/example/SMAN_2_PASURUAN/MainActivity$$ExternalSyntheticLambda1;

    invoke-direct {v2, p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity$$ExternalSyntheticLambda1;-><init>(Lcom/example/SMAN_2_PASURUAN/MainActivity;)V

    .line 107
    const-string v3, "Beri Izin"

    invoke-virtual {v1, v3, v2}, Landroidx/appcompat/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroidx/appcompat/app/AlertDialog$Builder;

    move-result-object v1

    .line 119
    invoke-virtual {v1}, Landroidx/appcompat/app/AlertDialog$Builder;->show()Landroidx/appcompat/app/AlertDialog;

    .line 120
    return-void

    .line 124
    :cond_1
    invoke-direct {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->isDeveloperOptionsEnabled()Z

    move-result v1

    .line 125
    .local v1, "devEnabled":Z
    invoke-direct {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->isAdbEnabled()Z

    move-result v2

    .line 126
    .local v2, "adbEnabled":Z
    if-nez v1, :cond_3

    if-eqz v2, :cond_2

    goto :goto_4

    .line 130
    :cond_2
    invoke-direct {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->initUiAndRequestPin()V

    goto :goto_5

    .line 128
    :cond_3
    :goto_4
    invoke-direct {p0, v1, v2}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->showDevRequireDisableAndOpenSettings(ZZ)V

    .line 132
    :goto_5
    return-void
.end method

.method protected onDestroy()V
    .locals 2

    .line 290
    :try_start_0
    iget-object v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->imageObserver:Landroid/database/ContentObserver;

    if-eqz v0, :cond_0

    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    iget-object v1, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->imageObserver:Landroid/database/ContentObserver;

    invoke-virtual {v0, v1}, Landroid/content/ContentResolver;->unregisterContentObserver(Landroid/database/ContentObserver;)V

    .line 291
    :cond_0
    iget-object v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->videoObserver:Landroid/database/ContentObserver;

    if-eqz v0, :cond_1

    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    iget-object v1, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->videoObserver:Landroid/database/ContentObserver;

    invoke-virtual {v0, v1}, Landroid/content/ContentResolver;->unregisterContentObserver(Landroid/database/ContentObserver;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 292
    :catch_0
    move-exception v0

    :cond_1
    :goto_0
    nop

    .line 293
    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onDestroy()V

    .line 294
    return-void
.end method

.method public onMultiWindowModeChanged(Z)V
    .locals 1
    .param p1, "isInMultiWindowMode"    # Z

    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onMultiWindowModeChanged(Z)V

    if-eqz p1, :cond_0

    # Split screen detected → kill sequence
    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->finishAndRemoveTask()V

    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->finishAffinity()V

    const/4 v0, 0x0

    invoke-static {v0}, Ljava/lang/System;->exit(I)V

    :cond_0
    return-void
.end method

.method protected onResume()V
    .locals 8

    .line 136
    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onResume()V

    # ── Start ExamGuardService (silently ignore if fails) ──
    :try_start_svc
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/example/SMAN_2_PASURUAN/ExamGuardService;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {p0, v0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->startService(Landroid/content/Intent;)Landroid/content/ComponentName;
    :try_end_svc
    .catch Ljava/lang/Exception; {:try_start_svc .. :try_end_svc} :catch_svc
    :catch_svc

    .line 141
    iget-boolean v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->requestedPin:Z

    if-eqz v0, :cond_1

    .line 144
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    .line 145
    .local v0, "now":J
    iget-wide v2, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->requestedPinTime:J

    sub-long v2, v0, v2

    const-wide/16 v4, 0x1388

    cmp-long v2, v2, v4

    if-gez v2, :cond_0

    .line 147
    iget-object v2, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pinHandler:Landroid/os/Handler;

    iget-object v3, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pinCheckRunnable:Ljava/lang/Runnable;

    invoke-virtual {v2, v3}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 148
    iget-object v2, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pinHandler:Landroid/os/Handler;

    iget-object v3, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pinCheckRunnable:Ljava/lang/Runnable;

    iget-wide v6, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->requestedPinTime:J

    sub-long v6, v0, v6

    sub-long/2addr v4, v6

    invoke-virtual {v2, v3, v4, v5}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    goto :goto_0

    .line 151
    :cond_0
    invoke-direct {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->checkLockTaskStateAndMaybeClose()V

    .line 154
    .end local v0    # "now":J
    :cond_1
    :goto_0
    return-void
.end method

.method public onWindowFocusChanged(Z)V
    .locals 2
    .param p1, "hasFocus"    # Z

    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onWindowFocusChanged(Z)V

    # if focus gained, nothing to do
    if-nez p1, :has_focus

    # focus lost — check if pending permission dialogs (legit flow)
    iget-boolean v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pendingOverlayRequest:Z

    if-nez v0, :has_focus

    iget-boolean v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pendingDevRequest:Z

    if-nez v0, :has_focus

    # focus lost with no pending dialog → kill sequence
    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->finishAndRemoveTask()V

    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->finishAffinity()V

    const/4 v0, 0x0

    invoke-static {v0}, Ljava/lang/System;->exit(I)V

    :has_focus
    return-void
.end method

# ─────────────────────────────────────────────────────────────────────────────
# onPause — app goes to background → kill
# Guard: skip if waiting for overlay/dev-settings permission dialog
# ─────────────────────────────────────────────────────────────────────────────

.method protected onPause()V
    .locals 1

    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onPause()V

    # skip kill if pending overlay permission request
    iget-boolean v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pendingOverlayRequest:Z

    if-nez v0, :skip_pause

    # skip kill if pending dev-settings redirect
    iget-boolean v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pendingDevRequest:Z

    if-nez v0, :skip_pause

    # kill sequence
    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->finishAndRemoveTask()V

    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->finishAffinity()V

    const/4 v0, 0x0

    invoke-static {v0}, Ljava/lang/System;->exit(I)V

    :skip_pause
    return-void
.end method

# ─────────────────────────────────────────────────────────────────────────────
# onStop — app completely hidden → kill (last resort)
# ─────────────────────────────────────────────────────────────────────────────

.method protected onStop()V
    .locals 1

    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onStop()V

    iget-boolean v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pendingOverlayRequest:Z

    if-nez v0, :skip_stop

    iget-boolean v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pendingDevRequest:Z

    if-nez v0, :skip_stop

    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->finishAndRemoveTask()V

    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->finishAffinity()V

    const/4 v0, 0x0

    invoke-static {v0}, Ljava/lang/System;->exit(I)V

    :skip_stop
    return-void
.end method

# ─────────────────────────────────────────────────────────────────────────────
# onUserLeaveHint — Home/Recents button pressed
# ─────────────────────────────────────────────────────────────────────────────

.method protected onUserLeaveHint()V
    .locals 1

    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onUserLeaveHint()V

    iget-boolean v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pendingOverlayRequest:Z

    if-nez v0, :skip_leave

    iget-boolean v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity;->pendingDevRequest:Z

    if-nez v0, :skip_leave

    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->finishAndRemoveTask()V

    invoke-virtual {p0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->finishAffinity()V

    const/4 v0, 0x0

    invoke-static {v0}, Ljava/lang/System;->exit(I)V

    :skip_leave
    return-void
.end method
