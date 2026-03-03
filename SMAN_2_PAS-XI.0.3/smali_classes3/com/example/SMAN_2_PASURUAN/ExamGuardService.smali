.class public Lcom/example/SMAN_2_PASURUAN/ExamGuardService;
.super Landroid/app/Service;
.source "ExamGuardService.java"

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/example/SMAN_2_PASURUAN/ExamGuardService$1;
    }
.end annotation

# instance fields
.field public guardHandler:Landroid/os/Handler;

.field public guardRunnable:Ljava/lang/Runnable;

.field public isRunning:Z

# ─────────────────────────────────────────────────────────────────────────────
# constructor
# ─────────────────────────────────────────────────────────────────────────────

.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Landroid/app/Service;-><init>()V

    return-void
.end method

# ─────────────────────────────────────────────────────────────────────────────
# onCreate
# ─────────────────────────────────────────────────────────────────────────────

.method public onCreate()V
    .locals 3

    invoke-super {p0}, Landroid/app/Service;->onCreate()V

    # isRunning = false
    const/4 v0, 0x0
    iput-boolean v0, p0, Lcom/example/SMAN_2_PASURUAN/ExamGuardService;->isRunning:Z

    # guardHandler = new Handler(Looper.getMainLooper())
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Lcom/example/SMAN_2_PASURUAN/ExamGuardService;->guardHandler:Landroid/os/Handler;

    # guardRunnable = new ExamGuardService$1(this)
    new-instance v0, Lcom/example/SMAN_2_PASURUAN/ExamGuardService$1;

    invoke-direct {v0, p0}, Lcom/example/SMAN_2_PASURUAN/ExamGuardService$1;-><init>(Lcom/example/SMAN_2_PASURUAN/ExamGuardService;)V

    iput-object v0, p0, Lcom/example/SMAN_2_PASURUAN/ExamGuardService;->guardRunnable:Ljava/lang/Runnable;

    # createNotificationChannel()
    invoke-direct {p0}, Lcom/example/SMAN_2_PASURUAN/ExamGuardService;->createNotificationChannel()V

    return-void
.end method

# ─────────────────────────────────────────────────────────────────────────────
# onStartCommand
# ─────────────────────────────────────────────────────────────────────────────

.method public onStartCommand(Landroid/content/Intent;II)I
    .locals 2
    .param p1, "intent"     # Landroid/content/Intent;
    .param p2, "flags"      # I
    .param p3, "startId"    # I

    # startForeground(1001, notification)
    invoke-direct {p0}, Lcom/example/SMAN_2_PASURUAN/ExamGuardService;->buildNotification()Landroid/app/Notification;

    move-result-object v0

    const/16 v1, 0x3e9

    invoke-virtual {p0, v1, v0}, Landroid/app/Service;->startForeground(ILandroid/app/Notification;)V

    # if already running, skip
    iget-boolean v0, p0, Lcom/example/SMAN_2_PASURUAN/ExamGuardService;->isRunning:Z

    if-nez v0, :already_running

    # isRunning = true
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/example/SMAN_2_PASURUAN/ExamGuardService;->isRunning:Z

    # handler.post(runnable)
    iget-object v0, p0, Lcom/example/SMAN_2_PASURUAN/ExamGuardService;->guardHandler:Landroid/os/Handler;

    iget-object v1, p0, Lcom/example/SMAN_2_PASURUAN/ExamGuardService;->guardRunnable:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    :already_running
    # return START_STICKY = 1
    const/4 v0, 0x1

    return v0
.end method

# ─────────────────────────────────────────────────────────────────────────────
# onBind
# ─────────────────────────────────────────────────────────────────────────────

.method public onBind(Landroid/content/Intent;)Landroid/os/IBinder;
    .locals 1
    .param p1, "intent"    # Landroid/content/Intent;

    const/4 v0, 0x0

    return-object v0
.end method

# ─────────────────────────────────────────────────────────────────────────────
# onDestroy
# ─────────────────────────────────────────────────────────────────────────────

.method public onDestroy()V
    .locals 2

    # isRunning = false
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/example/SMAN_2_PASURUAN/ExamGuardService;->isRunning:Z

    # remove callbacks if handler exists
    iget-object v0, p0, Lcom/example/SMAN_2_PASURUAN/ExamGuardService;->guardHandler:Landroid/os/Handler;

    if-eqz v0, :skip_remove

    iget-object v1, p0, Lcom/example/SMAN_2_PASURUAN/ExamGuardService;->guardRunnable:Ljava/lang/Runnable;

    if-eqz v1, :skip_remove

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    :skip_remove
    invoke-super {p0}, Landroid/app/Service;->onDestroy()V

    return-void
.end method

# ─────────────────────────────────────────────────────────────────────────────
# createNotificationChannel
# ─────────────────────────────────────────────────────────────────────────────

.method private createNotificationChannel()V
    .locals 4

    # new NotificationChannel(id, name, IMPORTANCE_LOW=2)
    new-instance v0, Landroid/app/NotificationChannel;

    const-string v1, "exam_guard_channel"

    const-string v2, "Ujian Aktif"

    const/4 v3, 0x2

    invoke-direct {v0, v1, v2, v3}, Landroid/app/NotificationChannel;-><init>(Ljava/lang/String;Ljava/lang/CharSequence;I)V

    # setShowBadge(false)
    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/app/NotificationChannel;->setShowBadge(Z)V

    # getSystemService("notification")
    const-string v1, "notification"

    invoke-virtual {p0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    if-eqz v1, :skip_channel

    check-cast v1, Landroid/app/NotificationManager;

    invoke-virtual {v1, v0}, Landroid/app/NotificationManager;->createNotificationChannel(Landroid/app/NotificationChannel;)V

    :skip_channel
    return-void
.end method

# ─────────────────────────────────────────────────────────────────────────────
# buildNotification
# ─────────────────────────────────────────────────────────────────────────────

.method private buildNotification()Landroid/app/Notification;
    .locals 3

    # new Notification.Builder(context, channelId)
    new-instance v0, Landroid/app/Notification$Builder;

    const-string v1, "exam_guard_channel"

    invoke-direct {v0, p0, v1}, Landroid/app/Notification$Builder;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    # setContentTitle
    const-string v1, "Ujian Sedang Berlangsung"

    invoke-virtual {v0, v1}, Landroid/app/Notification$Builder;->setContentTitle(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object v0

    # setContentText
    const-string v1, "Jangan keluar dari aplikasi"

    invoke-virtual {v0, v1}, Landroid/app/Notification$Builder;->setContentText(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object v0

    # setSmallIcon — android.R.drawable.ic_dialog_alert = 0x01080002
    const v1, 0x01080002

    invoke-virtual {v0, v1}, Landroid/app/Notification$Builder;->setSmallIcon(I)Landroid/app/Notification$Builder;

    move-result-object v0

    # setOngoing(true)
    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/app/Notification$Builder;->setOngoing(Z)Landroid/app/Notification$Builder;

    move-result-object v0

    # build()
    invoke-virtual {v0}, Landroid/app/Notification$Builder;->build()Landroid/app/Notification;

    move-result-object v0

    return-object v0
.end method
