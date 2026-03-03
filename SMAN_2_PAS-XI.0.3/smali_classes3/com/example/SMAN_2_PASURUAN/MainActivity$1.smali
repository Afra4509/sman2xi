.class Lcom/example/SMAN_2_PASURUAN/MainActivity$1;
.super Ljava/lang/Object;
.source "MainActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/example/SMAN_2_PASURUAN/MainActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/example/SMAN_2_PASURUAN/MainActivity;


# direct methods
.method constructor <init>(Lcom/example/SMAN_2_PASURUAN/MainActivity;)V
    .locals 0
    .param p1, "this$0"    # Lcom/example/SMAN_2_PASURUAN/MainActivity;

    .line 46
    iput-object p1, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity$1;->this$0:Lcom/example/SMAN_2_PASURUAN/MainActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 1

    .line 49
    iget-object v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity$1;->this$0:Lcom/example/SMAN_2_PASURUAN/MainActivity;

    invoke-static {v0}, Lcom/example/SMAN_2_PASURUAN/MainActivity;->access$000(Lcom/example/SMAN_2_PASURUAN/MainActivity;)V

    .line 50
    return-void
.end method
