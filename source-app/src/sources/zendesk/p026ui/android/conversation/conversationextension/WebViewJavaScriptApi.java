package zendesk.p026ui.android.conversation.conversationextension;

import android.webkit.JavascriptInterface;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0000\u0018\u00002\u00020\u0001B8\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012#\u0010\u0005\u001a\u001f\u0012\u0015\u0012\u0013\u0018\u00010\u0007¢\u0006\f\b\b\u0012\b\b\t\u0012\u0004\b\b(\n\u0012\u0004\u0012\u00020\u00040\u0006¢\u0006\u0002\u0010\u000bJ\b\u0010\f\u001a\u00020\u0004H\u0007J\u0012\u0010\r\u001a\u00020\u00042\b\u0010\n\u001a\u0004\u0018\u00010\u0007H\u0007R\u0014\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R+\u0010\u0005\u001a\u001f\u0012\u0015\u0012\u0013\u0018\u00010\u0007¢\u0006\f\b\b\u0012\b\b\t\u0012\u0004\b\b(\n\u0012\u0004\u0012\u00020\u00040\u0006X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u000e"}, m18d2 = {"Lzendesk/ui/android/conversation/conversationextension/WebViewJavaScriptApi;", "", "onWebSdkClose", "Lkotlin/Function0;", "", "onWebSdkUpdateTitle", "Lkotlin/Function1;", "", "Lkotlin/ParameterName;", "name", "title", "(Lkotlin/jvm/functions/Function0;Lkotlin/jvm/functions/Function1;)V", "close", "setTitle", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class WebViewJavaScriptApi {
    public static final int $stable = 0;
    private final Function0<Unit> onWebSdkClose;
    private final Function1<String, Unit> onWebSdkUpdateTitle;

    public WebViewJavaScriptApi(Function0<Unit> onWebSdkClose, Function1<? super String, Unit> onWebSdkUpdateTitle) {
        Intrinsics.checkNotNullParameter(onWebSdkClose, "onWebSdkClose");
        Intrinsics.checkNotNullParameter(onWebSdkUpdateTitle, "onWebSdkUpdateTitle");
        this.onWebSdkClose = onWebSdkClose;
        this.onWebSdkUpdateTitle = onWebSdkUpdateTitle;
    }

    @JavascriptInterface
    public final void setTitle(String title) {
        this.onWebSdkUpdateTitle.invoke(title);
    }

    @JavascriptInterface
    public final void close() {
        this.onWebSdkClose.invoke();
    }
}
