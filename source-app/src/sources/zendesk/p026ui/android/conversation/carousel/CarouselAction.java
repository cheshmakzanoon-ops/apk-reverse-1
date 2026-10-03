package zendesk.p026ui.android.conversation.carousel;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.p017ui.android.internal.model.MessageActionSize;

@Metadata(m17d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b7\u0018\u00002\u00020\u0001:\u0004\u0011\u0012\u0013\u0014B5\b\u0004\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0014\b\u0002\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0000\u0012\u0004\u0012\u00020\u00070\u0006\u0012\u0006\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\nR\u001d\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0000\u0012\u0004\u0012\u00020\u00070\u0006¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0011\u0010\b\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\u000fR\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u000e\u0082\u0001\u0004\u0015\u0016\u0017\u0018¨\u0006\u0019"}, m18d2 = {"Lzendesk/ui/android/conversation/carousel/CarouselAction;", "", "id", "", "text", "clickListener", "Lkotlin/Function1;", "", "isLoading", "", "(Ljava/lang/String;Ljava/lang/String;Lkotlin/jvm/functions/Function1;Z)V", "getClickListener", "()Lkotlin/jvm/functions/Function1;", "getId", "()Ljava/lang/String;", "()Z", "getText", "Link", "Postback", "Unsupported", "WebView", "Lzendesk/ui/android/conversation/carousel/CarouselAction$Link;", "Lzendesk/ui/android/conversation/carousel/CarouselAction$Postback;", "Lzendesk/ui/android/conversation/carousel/CarouselAction$Unsupported;", "Lzendesk/ui/android/conversation/carousel/CarouselAction$WebView;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class CarouselAction {
    public static final int $stable = 0;
    private final Function1<CarouselAction, Unit> clickListener;
    private final String id;
    private final boolean isLoading;
    private final String text;

    public CarouselAction(String str, String str2, Function1 function1, boolean z, DefaultConstructorMarker defaultConstructorMarker) {
        this(str, str2, function1, z);
    }

    private CarouselAction(String str, String str2, Function1<? super CarouselAction, Unit> function1, boolean z) {
        this.id = str;
        this.text = str2;
        this.clickListener = function1;
        this.isLoading = z;
    }

    public final String getId() {
        return this.id;
    }

    public final String getText() {
        return this.text;
    }

    public CarouselAction(String str, String str2, C15591 c15591, boolean z, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(str, str2, (i & 4) != 0 ? new Function1<CarouselAction, Unit>() {
            public final void invoke2(CarouselAction it) {
                Intrinsics.checkNotNullParameter(it, "it");
            }

            @Override
            public Unit invoke(CarouselAction carouselAction) {
                invoke2(carouselAction);
                return Unit.INSTANCE;
            }
        } : c15591, z, null);
    }

    public final Function1<CarouselAction, Unit> getClickListener() {
        return this.clickListener;
    }

    public final boolean getIsLoading() {
        return this.isLoading;
    }

    @Metadata(m17d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0005\b\u0007\u0018\u00002\u00020\u0001B1\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0012\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0001\u0012\u0004\u0012\u00020\u00070\u0006\u0012\u0006\u0010\b\u001a\u00020\u0003¢\u0006\u0002\u0010\tR\u0011\u0010\b\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000b¨\u0006\f"}, m18d2 = {"Lzendesk/ui/android/conversation/carousel/CarouselAction$Link;", "Lzendesk/ui/android/conversation/carousel/CarouselAction;", "id", "", "text", "clickListener", "Lkotlin/Function1;", "", "url", "(Ljava/lang/String;Ljava/lang/String;Lkotlin/jvm/functions/Function1;Ljava/lang/String;)V", "getUrl", "()Ljava/lang/String;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Link extends CarouselAction {
        public static final int $stable = 0;
        private final String url;

        public final String getUrl() {
            return this.url;
        }

        public Link(String id, String text, Function1<? super CarouselAction, Unit> clickListener, String url) {
            super(id, text, clickListener, false, null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(text, "text");
            Intrinsics.checkNotNullParameter(clickListener, "clickListener");
            Intrinsics.checkNotNullParameter(url, "url");
            this.url = url;
        }
    }

    @Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\b\u0007\u0018\u00002\u00020\u0001B1\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0012\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0001\u0012\u0004\u0012\u00020\u00070\u0006\u0012\u0006\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\n¨\u0006\u000b"}, m18d2 = {"Lzendesk/ui/android/conversation/carousel/CarouselAction$Postback;", "Lzendesk/ui/android/conversation/carousel/CarouselAction;", "id", "", "text", "clickListener", "Lkotlin/Function1;", "", "isLoading", "", "(Ljava/lang/String;Ljava/lang/String;Lkotlin/jvm/functions/Function1;Z)V", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Postback extends CarouselAction {
        public static final int $stable = 0;

        public Postback(String id, String text, Function1<? super CarouselAction, Unit> clickListener, boolean z) {
            super(id, text, clickListener, z, null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(text, "text");
            Intrinsics.checkNotNullParameter(clickListener, "clickListener");
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0007\u0018\u00002\u00020\u0001B9\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0012\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0001\u0012\u0004\u0012\u00020\u00070\u0006\u0012\u0006\u0010\b\u001a\u00020\u0003\u0012\u0006\u0010\t\u001a\u00020\n¢\u0006\u0002\u0010\u000bR\u0011\u0010\t\u001a\u00020\n¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u0011\u0010\b\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000f¨\u0006\u0010"}, m18d2 = {"Lzendesk/ui/android/conversation/carousel/CarouselAction$WebView;", "Lzendesk/ui/android/conversation/carousel/CarouselAction;", "id", "", "text", "clickListener", "Lkotlin/Function1;", "", "url", "size", "Lzendesk/core/ui/android/internal/model/MessageActionSize;", "(Ljava/lang/String;Ljava/lang/String;Lkotlin/jvm/functions/Function1;Ljava/lang/String;Lzendesk/core/ui/android/internal/model/MessageActionSize;)V", "getSize", "()Lzendesk/core/ui/android/internal/model/MessageActionSize;", "getUrl", "()Ljava/lang/String;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class WebView extends CarouselAction {
        public static final int $stable = 0;
        private final MessageActionSize size;
        private final String url;

        public final String getUrl() {
            return this.url;
        }

        public final MessageActionSize getSize() {
            return this.size;
        }

        public WebView(String id, String text, Function1<? super CarouselAction, Unit> clickListener, String url, MessageActionSize size) {
            super(id, text, clickListener, false, null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(text, "text");
            Intrinsics.checkNotNullParameter(clickListener, "clickListener");
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(size, "size");
            this.url = url;
            this.size = size;
        }
    }

    @Metadata(m17d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\b\u0007\u0018\u00002\u00020\u0001B)\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0012\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0001\u0012\u0004\u0012\u00020\u00070\u0006¢\u0006\u0002\u0010\b¨\u0006\t"}, m18d2 = {"Lzendesk/ui/android/conversation/carousel/CarouselAction$Unsupported;", "Lzendesk/ui/android/conversation/carousel/CarouselAction;", "id", "", "text", "clickListener", "Lkotlin/Function1;", "", "(Ljava/lang/String;Ljava/lang/String;Lkotlin/jvm/functions/Function1;)V", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Unsupported extends CarouselAction {
        public static final int $stable = 0;

        public Unsupported(String id, String text, Function1<? super CarouselAction, Unit> clickListener) {
            super(id, text, clickListener, false, null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(text, "text");
            Intrinsics.checkNotNullParameter(clickListener, "clickListener");
        }
    }
}
