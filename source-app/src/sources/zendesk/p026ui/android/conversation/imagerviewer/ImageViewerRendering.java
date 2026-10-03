package zendesk.p026ui.android.conversation.imagerviewer;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0007\u0018\u00002\u00020\u0001:\u0001\u0011B\u0007\b\u0016¢\u0006\u0002\u0010\u0002B\u000f\b\u0000\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0010\u001a\u00020\u0004R\u001e\u0010\u0006\u001a\f\u0012\u0004\u0012\u00020\b0\u0007j\u0002`\tX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0014\u0010\f\u001a\u00020\rX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000f¨\u0006\u0012"}, m18d2 = {"Lzendesk/ui/android/conversation/imagerviewer/ImageViewerRendering;", "", "()V", "builder", "Lzendesk/ui/android/conversation/imagerviewer/ImageViewerRendering$Builder;", "(Lzendesk/ui/android/conversation/imagerviewer/ImageViewerRendering$Builder;)V", "onBackButtonClicked", "Lkotlin/Function0;", "", "Lzendesk/ui/android/conversation/imagerviewer/OnClickLambda;", "getOnBackButtonClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function0;", "state", "Lzendesk/ui/android/conversation/imagerviewer/ImageViewerState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/imagerviewer/ImageViewerState;", "toBuilder", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ImageViewerRendering {
    public static final int $stable = 8;
    private final Function0<Unit> onBackButtonClicked;
    private final ImageViewerState state;

    public ImageViewerRendering(Builder builder) {
        Intrinsics.checkNotNullParameter(builder, "builder");
        this.onBackButtonClicked = builder.getOnBackButtonClicked$zendesk_ui_ui_android();
        this.state = builder.getState();
    }

    public final Function0<Unit> getOnBackButtonClicked$zendesk_ui_ui_android() {
        return this.onBackButtonClicked;
    }

    public final ImageViewerState getState() {
        return this.state;
    }

    public ImageViewerRendering() {
        this(new Builder());
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\b\u0007\u0018\u00002\u00020\u0001B\u0011\b\u0010\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0014\u001a\u00020\u0003J\u0018\u0010\u0006\u001a\u00020\u00002\u0010\u0010\u0006\u001a\f\u0012\u0004\u0012\u00020\b0\u0007j\u0002`\tJ\u001a\u0010\u000e\u001a\u00020\u00002\u0012\u0010\u0015\u001a\u000e\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\u000f0\u0016R$\u0010\u0006\u001a\f\u0012\u0004\u0012\u00020\b0\u0007j\u0002`\tX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\n\u0010\u000b\"\u0004\b\f\u0010\rR\u001a\u0010\u000e\u001a\u00020\u000fX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0010\u0010\u0011\"\u0004\b\u0012\u0010\u0013¨\u0006\u0017"}, m18d2 = {"Lzendesk/ui/android/conversation/imagerviewer/ImageViewerRendering$Builder;", "", "rendering", "Lzendesk/ui/android/conversation/imagerviewer/ImageViewerRendering;", "(Lzendesk/ui/android/conversation/imagerviewer/ImageViewerRendering;)V", "()V", "onBackButtonClicked", "Lkotlin/Function0;", "", "Lzendesk/ui/android/conversation/imagerviewer/OnClickLambda;", "getOnBackButtonClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function0;", "setOnBackButtonClicked$zendesk_ui_ui_android", "(Lkotlin/jvm/functions/Function0;)V", "state", "Lzendesk/ui/android/conversation/imagerviewer/ImageViewerState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/imagerviewer/ImageViewerState;", "setState$zendesk_ui_ui_android", "(Lzendesk/ui/android/conversation/imagerviewer/ImageViewerState;)V", "build", "stateUpdate", "Lkotlin/Function1;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private Function0<Unit> onBackButtonClicked;
        private ImageViewerState state;

        public Builder() {
            this.onBackButtonClicked = new Function0<Unit>() {
                public final void invoke2() {
                }

                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }
            };
            this.state = new ImageViewerState(null, null, null, null, null, null, null, 127, null);
        }

        public final Function0<Unit> getOnBackButtonClicked$zendesk_ui_ui_android() {
            return this.onBackButtonClicked;
        }

        public final void setOnBackButtonClicked$zendesk_ui_ui_android(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onBackButtonClicked = function0;
        }

        public final ImageViewerState getState() {
            return this.state;
        }

        public final void setState$zendesk_ui_ui_android(ImageViewerState imageViewerState) {
            Intrinsics.checkNotNullParameter(imageViewerState, "<set-?>");
            this.state = imageViewerState;
        }

        public Builder(ImageViewerRendering rendering) {
            this();
            Intrinsics.checkNotNullParameter(rendering, "rendering");
            this.onBackButtonClicked = rendering.getOnBackButtonClicked$zendesk_ui_ui_android();
            this.state = rendering.getState();
        }

        public Builder(ImageViewerRendering imageViewerRendering, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? new ImageViewerRendering() : imageViewerRendering);
        }

        public final Builder onBackButtonClicked(Function0<Unit> onBackButtonClicked) {
            Intrinsics.checkNotNullParameter(onBackButtonClicked, "onBackButtonClicked");
            this.onBackButtonClicked = onBackButtonClicked;
            return this;
        }

        public final Builder state(Function1<? super ImageViewerState, ImageViewerState> stateUpdate) {
            Intrinsics.checkNotNullParameter(stateUpdate, "stateUpdate");
            this.state = stateUpdate.invoke(this.state);
            return this;
        }

        public final ImageViewerRendering build() {
            return new ImageViewerRendering(this);
        }
    }
}
