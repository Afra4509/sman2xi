.class Lcom/example/SMAN_2_PASURUAN/MainActivity$4;
.super Ljava/lang/Object;
.source "MainActivity.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/example/SMAN_2_PASURUAN/MainActivity;->customExitDialog()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/example/SMAN_2_PASURUAN/MainActivity;

.field final synthetic val$dialog:Landroid/app/Dialog;


# direct methods
.method constructor <init>(Lcom/example/SMAN_2_PASURUAN/MainActivity;Landroid/app/Dialog;)V
    .locals 0
    .param p1, "this$0"    # Lcom/example/SMAN_2_PASURUAN/MainActivity;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 585
    iput-object p1, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity$4;->this$0:Lcom/example/SMAN_2_PASURUAN/MainActivity;

    iput-object p2, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity$4;->val$dialog:Landroid/app/Dialog;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 1
    .param p1, "v"    # Landroid/view/View;

    .line 589
    iget-object v0, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity$4;->val$dialog:Landroid/app/Dialog;

    invoke-virtual {v0}, Landroid/app/Dialog;->dismiss()V

    .line 591
    return-void
.end method
