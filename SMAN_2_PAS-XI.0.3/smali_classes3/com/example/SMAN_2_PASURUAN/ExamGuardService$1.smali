.class Lcom/example/SMAN_2_PASURUAN/ExamGuardService$1;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;
.source "ExamGuardService.java"

# synthetic reference to outer ExamGuardService instance
.field final synthetic this$0:Lcom/example/SMAN_2_PASURUAN/ExamGuardService;

# ─────────────────────────────────────────────────────────────────────────────
# constructor
# ─────────────────────────────────────────────────────────────────────────────

.method constructor <init>(Lcom/example/SMAN_2_PASURUAN/ExamGuardService;)V
    .locals 0
    .param p1, "this$0"    # Lcom/example/SMAN_2_PASURUAN/ExamGuardService;

    iput-object p1, p0, Lcom/example/SMAN_2_PASURUAN/ExamGuardService$1;->this$0:Lcom/example/SMAN_2_PASURUAN/ExamGuardService;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

# ─────────────────────────────────────────────────────────────────────────────
# run — 500ms security poll loop
#
# Register layout (v1..v6 consecutive for invoke-virtual/range):
#   v0  = ExamGuardService ref
#   v1  = USM [queryUsageStats receiver] → List → Iterator (reused)
#   v2  = intervalType int=4 [queryUsageStats arg1]
#   v3:v4 = startTime long   [queryUsageStats arg2] → maxTime → 500ms delay
#   v5:v6 = now long         [queryUsageStats arg3] → best pkg + cmp (reused)
#   v7:v8 = lastTimeUsed per item (wide)
#   v9  = pid (kill phase)
#   v10 = handler (reschedule phase)
#   v11 = runnable (reschedule phase)
# ─────────────────────────────────────────────────────────────────────────────

.method public run()V
    .locals 12

    # v0 = ExamGuardService (this$0)
    iget-object v0, p0, Lcom/example/SMAN_2_PASURUAN/ExamGuardService$1;->this$0:Lcom/example/SMAN_2_PASURUAN/ExamGuardService;

    # bail if service stopped
    iget-boolean v2, v0, Lcom/example/SMAN_2_PASURUAN/ExamGuardService;->isRunning:Z

    if-eqz v2, :stop

    # get UsageStatsManager → v1
    const-string v2, "usagestats"

    invoke-virtual {v0, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    if-eqz v1, :reschedule

    check-cast v1, Landroid/app/usage/UsageStatsManager;

    # now → v5:v6
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v5

    # startTime = now - 5000 → v3:v4   (sub-long v3, v5, v3 = v5:v6 - v3:v4)
    const-wide/16 v3, 0x1388

    sub-long v3, v5, v3

    # intervalType = INTERVAL_BEST(4) → v2
    const/4 v2, 0x4

    # queryUsageStats — registers MUST be consecutive for /range:
    # v1=USM(receiver), v2=int, v3:v4=long beginTime, v5:v6=long endTime
    invoke-virtual/range {v1 .. v6}, Landroid/app/usage/UsageStatsManager;->queryUsageStats(IJJ)Ljava/util/List;

    move-result-object v1

    if-eqz v1, :reschedule

    # iterator → v1 (reuse)
    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    # maxTime = 0 → v3:v4 (reuse startTime pair)
    const-wide/16 v3, 0x0

    # best package = null → v5
    const/4 v5, 0x0

    # iterate: find package with highest lastTimeUsed
    :loop_check
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v6

    if-eqz v6, :loop_done

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/app/usage/UsageStats;

    invoke-virtual {v2}, Landroid/app/usage/UsageStats;->getLastTimeUsed()J

    move-result-wide v7

    # cmp-long v6, v7, v3  →  v6 = compare(v7:v8, v3:v4)
    cmp-long v6, v7, v3

    if-lez v6, :loop_check

    move-wide v3, v7

    invoke-virtual {v2}, Landroid/app/usage/UsageStats;->getPackageName()Ljava/lang/String;

    move-result-object v5

    goto :loop_check

    # v5 = most recently used package (or null)
    :loop_done
    if-eqz v5, :reschedule

    # allow own package
    const-string v6, "com.example.SMAN_2_PASURUAN"

    invoke-virtual {v5, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-nez v6, :reschedule

    # allow android system process
    const-string v6, "android"

    invoke-virtual {v5, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-nez v6, :reschedule

    # allow system UI
    const-string v6, "com.android.systemui"

    invoke-virtual {v5, v6}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :reschedule

    # allow Samsung system
    const-string v6, "com.samsung.android"

    invoke-virtual {v5, v6}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :reschedule

    # allow Xiaomi/MIUI system
    const-string v6, "com.miui"

    invoke-virtual {v5, v6}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :reschedule

    # FOREIGN APP DETECTED → kill entire process
    invoke-static {}, Landroid/os/Process;->myPid()I

    move-result v9

    invoke-static {v9}, Landroid/os/Process;->killProcess(I)V

    const/4 v9, 0x0

    invoke-static {v9}, Ljava/lang/System;->exit(I)V

    # reschedule: handler.postDelayed(runnable, 500ms)
    :reschedule
    iget-boolean v6, v0, Lcom/example/SMAN_2_PASURUAN/ExamGuardService;->isRunning:Z

    if-eqz v6, :stop

    iget-object v10, v0, Lcom/example/SMAN_2_PASURUAN/ExamGuardService;->guardHandler:Landroid/os/Handler;

    iget-object v11, v0, Lcom/example/SMAN_2_PASURUAN/ExamGuardService;->guardRunnable:Ljava/lang/Runnable;

    const-wide/16 v3, 0x1f4

    invoke-virtual {v10, v11, v3, v4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    :stop
    return-void
.end method
