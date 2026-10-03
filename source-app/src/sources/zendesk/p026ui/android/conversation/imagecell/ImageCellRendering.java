package zendesk.p026ui.android.conversation.imagecell;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import okhttp3.internal.http2.Settings;
import zendesk.core.p017ui.android.internal.model.MessageActionSize;

@Metadata(m17d1 = {"\u0000D\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0007\u0018\u00002\u00020\u0001:\u0001\u001dB\u0007\b\u0016¢\u0006\u0002\u0010\u0002B\u000f\b\u0000\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J\u0006\u0010\u001c\u001a\u00020\u0004R&\u0010\u0006\u001a\u0014\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR(\u0010\f\u001a\u0016\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t\u0018\u00010\rj\u0004\u0018\u0001`\u000eX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R&\u0010\u0011\u001a\u0014\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u000bR,\u0010\u0013\u001a\u001a\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\u0015\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0014X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0017R\u0014\u0010\u0018\u001a\u00020\u0019X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u001b¨\u0006\u001e"}, m18d2 = {"Lzendesk/ui/android/conversation/imagecell/ImageCellRendering;", "", "()V", "builder", "Lzendesk/ui/android/conversation/imagecell/ImageCellRendering$Builder;", "(Lzendesk/ui/android/conversation/imagecell/ImageCellRendering$Builder;)V", "onActionButtonClicked", "Lkotlin/Function2;", "", "", "getOnActionButtonClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function2;", "onImageCellClicked", "Lkotlin/Function1;", "Lzendesk/ui/android/conversation/imagecell/OnClickLambda;", "getOnImageCellClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function1;", "onPostbackButtonClicked", "getOnPostbackButtonClicked$zendesk_ui_ui_android", "onWebViewActionButtonClicked", "Lkotlin/Function3;", "Lzendesk/core/ui/android/internal/model/MessageActionSize;", "getOnWebViewActionButtonClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function3;", "state", "Lzendesk/ui/android/conversation/imagecell/ImageCellState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/imagecell/ImageCellState;", "toBuilder", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ImageCellRendering {
    public static final int $stable = 8;
    private final Function2<String, String, Unit> onActionButtonClicked;
    private final Function1<String, Unit> onImageCellClicked;
    private final Function2<String, String, Unit> onPostbackButtonClicked;
    private final Function3<String, MessageActionSize, String, Unit> onWebViewActionButtonClicked;
    private final ImageCellState state;

    public ImageCellRendering(Builder builder) {
        Intrinsics.checkNotNullParameter(builder, "builder");
        this.onImageCellClicked = builder.getOnImageCellClicked$zendesk_ui_ui_android();
        this.onActionButtonClicked = builder.getOnActionButtonClicked$zendesk_ui_ui_android();
        this.onPostbackButtonClicked = builder.getOnPostbackButtonClicked$zendesk_ui_ui_android();
        this.onWebViewActionButtonClicked = builder.getOnWebViewActionButtonClicked$zendesk_ui_ui_android();
        this.state = builder.getState();
    }

    public final Function1<String, Unit> getOnImageCellClicked$zendesk_ui_ui_android() {
        return this.onImageCellClicked;
    }

    public final Function2<String, String, Unit> getOnActionButtonClicked$zendesk_ui_ui_android() {
        return this.onActionButtonClicked;
    }

    public final Function2<String, String, Unit> getOnPostbackButtonClicked$zendesk_ui_ui_android() {
        return this.onPostbackButtonClicked;
    }

    public final Function3<String, MessageActionSize, String, Unit> getOnWebViewActionButtonClicked$zendesk_ui_ui_android() {
        return this.onWebViewActionButtonClicked;
    }

    public final ImageCellState getState() {
        return this.state;
    }

    public ImageCellRendering() {
        this(new Builder());
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\u0010\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0007\b\u0007\u0018\u00002\u00020\u0001B\u0011\b\u0010\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010%\u001a\u00020\u0003J \u0010\u0006\u001a\u00020\u00002\u0018\u0010\u0006\u001a\u0014\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0007J\"\u0010\u000e\u001a\u00020\u00002\u001a\u0010\u000e\u001a\u0016\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t\u0018\u00010\u000fj\u0004\u0018\u0001`\u0010J \u0010\u0015\u001a\u00020\u00002\u0018\u0010\u0015\u001a\u0014\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0007J&\u0010\u0018\u001a\u00020\u00002\u001e\u0010\u0018\u001a\u001a\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\u001a\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0019J\u001a\u0010\u001f\u001a\u00020\u00002\u0012\u0010&\u001a\u000e\u0012\u0004\u0012\u00020 \u0012\u0004\u0012\u00020 0\u000fR,\u0010\u0006\u001a\u0014\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\n\u0010\u000b\"\u0004\b\f\u0010\rR.\u0010\u000e\u001a\u0016\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t\u0018\u00010\u000fj\u0004\u0018\u0001`\u0010X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0011\u0010\u0012\"\u0004\b\u0013\u0010\u0014R,\u0010\u0015\u001a\u0014\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0016\u0010\u000b\"\u0004\b\u0017\u0010\rR2\u0010\u0018\u001a\u001a\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\u001a\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0019X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001b\u0010\u001c\"\u0004\b\u001d\u0010\u001eR\u001a\u0010\u001f\u001a\u00020 X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b!\u0010\"\"\u0004\b#\u0010$¨\u0006'"}, m18d2 = {"Lzendesk/ui/android/conversation/imagecell/ImageCellRendering$Builder;", "", "rendering", "Lzendesk/ui/android/conversation/imagecell/ImageCellRendering;", "(Lzendesk/ui/android/conversation/imagecell/ImageCellRendering;)V", "()V", "onActionButtonClicked", "Lkotlin/Function2;", "", "", "getOnActionButtonClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function2;", "setOnActionButtonClicked$zendesk_ui_ui_android", "(Lkotlin/jvm/functions/Function2;)V", "onImageCellClicked", "Lkotlin/Function1;", "Lzendesk/ui/android/conversation/imagecell/OnClickLambda;", "getOnImageCellClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function1;", "setOnImageCellClicked$zendesk_ui_ui_android", "(Lkotlin/jvm/functions/Function1;)V", "onPostbackButtonClicked", "getOnPostbackButtonClicked$zendesk_ui_ui_android", "setOnPostbackButtonClicked$zendesk_ui_ui_android", "onWebViewActionButtonClicked", "Lkotlin/Function3;", "Lzendesk/core/ui/android/internal/model/MessageActionSize;", "getOnWebViewActionButtonClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function3;", "setOnWebViewActionButtonClicked$zendesk_ui_ui_android", "(Lkotlin/jvm/functions/Function3;)V", "state", "Lzendesk/ui/android/conversation/imagecell/ImageCellState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/imagecell/ImageCellState;", "setState$zendesk_ui_ui_android", "(Lzendesk/ui/android/conversation/imagecell/ImageCellState;)V", "build", "stateUpdate", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private Function2<? super String, ? super String, Unit> onActionButtonClicked;
        private Function1<? super String, Unit> onImageCellClicked;
        private Function2<? super String, ? super String, Unit> onPostbackButtonClicked;
        private Function3<? super String, ? super MessageActionSize, ? super String, Unit> onWebViewActionButtonClicked;
        private ImageCellState state;

        public Builder() {
            this.onActionButtonClicked = new Function2<String, String, Unit>() {
                public final void invoke2(String str, String str2) {
                    Intrinsics.checkNotNullParameter(str, "<anonymous parameter 0>");
                    Intrinsics.checkNotNullParameter(str2, "<anonymous parameter 1>");
                }

                @Override
                public Unit invoke(String str, String str2) {
                    invoke2(str, str2);
                    return Unit.INSTANCE;
                }
            };
            this.onPostbackButtonClicked = new Function2<String, String, Unit>() {
                public final void invoke2(String str, String str2) {
                    Intrinsics.checkNotNullParameter(str, "<anonymous parameter 0>");
                    Intrinsics.checkNotNullParameter(str2, "<anonymous parameter 1>");
                }

                @Override
                public Unit invoke(String str, String str2) {
                    invoke2(str, str2);
                    return Unit.INSTANCE;
                }
            };
            this.onWebViewActionButtonClicked = new Function3<String, MessageActionSize, String, Unit>() {
                public final void invoke2(String str, MessageActionSize messageActionSize, String str2) {
                    Intrinsics.checkNotNullParameter(str, "<anonymous parameter 0>");
                    Intrinsics.checkNotNullParameter(messageActionSize, "<anonymous parameter 1>");
                    Intrinsics.checkNotNullParameter(str2, "<anonymous parameter 2>");
                }

                @Override
                public Unit invoke(String str, MessageActionSize messageActionSize, String str2) {
                    invoke2(str, messageActionSize, str2);
                    return Unit.INSTANCE;
                }
            };
            this.state = new ImageCellState(null, null, null, null, false, false, null, 0, 0, 0, 0, 0, 0, null, null, null, Settings.DEFAULT_INITIAL_WINDOW_SIZE, null);
        }

        public final Function1<String, Unit> getOnImageCellClicked$zendesk_ui_ui_android() {
            return this.onImageCellClicked;
        }

        public final void setOnImageCellClicked$zendesk_ui_ui_android(Function1<? super String, Unit> function1) {
            this.onImageCellClicked = function1;
        }

        public final Function2<String, String, Unit> getOnActionButtonClicked$zendesk_ui_ui_android() {
            return this.onActionButtonClicked;
        }

        public final void setOnActionButtonClicked$zendesk_ui_ui_android(Function2<? super String, ? super String, Unit> function2) {
            Intrinsics.checkNotNullParameter(function2, "<set-?>");
            this.onActionButtonClicked = function2;
        }

        public final Function2<String, String, Unit> getOnPostbackButtonClicked$zendesk_ui_ui_android() {
            return this.onPostbackButtonClicked;
        }

        public final void setOnPostbackButtonClicked$zendesk_ui_ui_android(Function2<? super String, ? super String, Unit> function2) {
            Intrinsics.checkNotNullParameter(function2, "<set-?>");
            this.onPostbackButtonClicked = function2;
        }

        public final Function3<String, MessageActionSize, String, Unit> getOnWebViewActionButtonClicked$zendesk_ui_ui_android() {
            return this.onWebViewActionButtonClicked;
        }

        public final void setOnWebViewActionButtonClicked$zendesk_ui_ui_android(Function3<? super String, ? super MessageActionSize, ? super String, Unit> function3) {
            Intrinsics.checkNotNullParameter(function3, "<set-?>");
            this.onWebViewActionButtonClicked = function3;
        }

        public final ImageCellState getState() {
            return this.state;
        }

        public final void setState$zendesk_ui_ui_android(ImageCellState imageCellState) {
            Intrinsics.checkNotNullParameter(imageCellState, "<set-?>");
            this.state = imageCellState;
        }

        public Builder(ImageCellRendering rendering) {
            this();
            Intrinsics.checkNotNullParameter(rendering, "rendering");
            this.onImageCellClicked = rendering.getOnImageCellClicked$zendesk_ui_ui_android();
            this.onPostbackButtonClicked = rendering.getOnPostbackButtonClicked$zendesk_ui_ui_android();
            this.state = rendering.getState();
        }

        public Builder(ImageCellRendering imageCellRendering, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? new ImageCellRendering() : imageCellRendering);
        }

        public final Builder onImageCellClicked(Function1<? super String, Unit> onImageCellClicked) {
            this.onImageCellClicked = onImageCellClicked;
            return this;
        }

        public final Builder onActionButtonClicked(Function2<? super String, ? super String, Unit> onActionButtonClicked) {
            Intrinsics.checkNotNullParameter(onActionButtonClicked, "onActionButtonClicked");
            this.onActionButtonClicked = onActionButtonClicked;
            return this;
        }

        public final Builder onWebViewActionButtonClicked(Function3<? super String, ? super MessageActionSize, ? super String, Unit> onWebViewActionButtonClicked) {
            Intrinsics.checkNotNullParameter(onWebViewActionButtonClicked, "onWebViewActionButtonClicked");
            this.onWebViewActionButtonClicked = onWebViewActionButtonClicked;
            return this;
        }

        public final Builder onPostbackButtonClicked(Function2<? super String, ? super String, Unit> onPostbackButtonClicked) {
            Intrinsics.checkNotNullParameter(onPostbackButtonClicked, "onPostbackButtonClicked");
            this.onPostbackButtonClicked = onPostbackButtonClicked;
            return this;
        }

        public final Builder state(Function1<? super ImageCellState, ImageCellState> stateUpdate) {
            Intrinsics.checkNotNullParameter(stateUpdate, "stateUpdate");
            this.state = stateUpdate.invoke(this.state);
            return this;
        }

        public final ImageCellRendering build() {
            return new ImageCellRendering(this);
        }
    }
}
