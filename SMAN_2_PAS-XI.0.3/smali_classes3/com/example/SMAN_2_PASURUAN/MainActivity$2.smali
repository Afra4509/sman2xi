.class Lcom/example/SMAN_2_PASURUAN/MainActivity$2;
.super Landroid/database/ContentObserver;
.source "MainActivity.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/example/SMAN_2_PASURUAN/MainActivity;->registerMediaObservers()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/example/SMAN_2_PASURUAN/MainActivity;


# direct methods
.method constructor <init>(Lcom/example/SMAN_2_PASURUAN/MainActivity;Landroid/os/Handler;)V
    .locals 0
    .param p1, "this$0"    # Lcom/example/SMAN_2_PASURUAN/MainActivity;
    .param p2, "arg0"    # Landroid/os/Handler;

    .line 216
    iput-object p1, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity$2;->this$0:Lcom/example/SMAN_2_PASURUAN/MainActivity;

    invoke-direct {p0, p2}, Landroid/database/ContentObserver;-><init>(Landroid/os/Handler;)V

    return-void
.end method


# virtual methods
.method public onChange(Z)V
    .locals 2
    .param p1, "selfChange"    # Z

    .line 219
    iget-object v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity$2;->this$0:Lcom/example/SMAN_2_PASURUAN/MainActivity;

    const/4 v1, 0x1

    invoke-static {v0, v1}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->access$100(Lcom/example/SMAN_2_PASURUAN/MainActivity;Z)V

    .line 220
    return-void
.end method

.method public onChange(ZLandroid/net/Uri;)V
    .locals 2
    .param p1, "selfChange"    # Z
    .param p2, "uri"    # Landroid/net/Uri;

    .line 224
    iget-object v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity$2;->this$0:Lcom/example/SMAN_2_PASURUAN/MainActivity;

    const/4 v1, 0x1

    invoke-static {v0, v1}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->access$100(Lcom/example/SMAN_2_PASURUAN/MainActivity;Z)V

    .line 225
    return-void
.end method
