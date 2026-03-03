.class public Lcom/example/SMAN_2_PASURUAN/MainActivity$mywebClient;
.super Landroid/webkit/WebViewClient;
.source "MainActivity.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/example/SMAN_2_PASURUAN/MainActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1
    name = "mywebClient"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/example/SMAN_2_PASURUAN/MainActivity;


# direct methods
.method public constructor <init>(Lcom/example/SMAN_2_PASURUAN/MainActivity;)V
    .locals 0
    .param p1, "this$0"    # Lcom/example/SMAN_2_PASURUAN/MainActivity;

    .line 608
    iput-object p1, p0, Lcom/example/SMAN_2_PASURUAN/MainActivity$mywebClient;->this$0:Lcom/example/SMAN_2_PASURUAN/MainActivity;

    invoke-direct {p0}, Landroid/webkit/WebViewClient;-><init>()V

    return-void
.end method


# virtual methods
.method public onPageStarted(Landroid/webkit/WebView;Ljava/lang/String;Landroid/graphics/Bitmap;)V
    .locals 0
    .param p1, "view"    # Landroid/webkit/WebView;
    .param p2, "url"    # Ljava/lang/String;
    .param p3, "favicon"    # Landroid/graphics/Bitmap;

    .line 611
    invoke-super {p0, p1, p2, p3}, Landroid/webkit/WebViewClient;->onPageStarted(Landroid/webkit/WebView;Ljava/lang/String;Landroid/graphics/Bitmap;)V

    .line 612
    return-void
.end method

.method public shouldOverrideUrlLoading(Landroid/webkit/WebView;Ljava/lang/String;)Z
    .locals 1
    .param p1, "view"    # Landroid/webkit/WebView;
    .param p2, "url"    # Ljava/lang/String;

    .line 615
    invoke-virtual {p1, p2}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V

    .line 616
    const/4 v0, 0x1

    return v0
.end method
