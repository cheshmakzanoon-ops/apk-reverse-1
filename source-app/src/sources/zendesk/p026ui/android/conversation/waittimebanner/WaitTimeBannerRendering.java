package zendesk.p026ui.android.conversation.waittimebanner;

import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0007\u0018\u00002\u00020\u0001:\u0001\u000bB\u0007\b\u0016¢\u0006\u0002\u0010\u0002B\u000f\b\u0000\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J\u0006\u0010\n\u001a\u00020\u0004R\u0014\u0010\u0006\u001a\u00020\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\t¨\u0006\f"}, m18d2 = {"Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerRendering;", "", "()V", "builder", "Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerRendering$Builder;", "(Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerRendering$Builder;)V", "state", "Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerState;", "toBuilder", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class WaitTimeBannerRendering {
    public static final int $stable = 0;
    private final WaitTimeBannerState state;

    public WaitTimeBannerRendering(Builder builder) {
        Intrinsics.checkNotNullParameter(builder, "builder");
        this.state = builder.getState();
    }

    public final WaitTimeBannerState getState() {
        return this.state;
    }

    public WaitTimeBannerRendering() {
        this(new Builder());
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\b\u0007\u0018\u00002\u00020\u0001B\u0011\b\u0010\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010\f\u001a\u00020\u0003J\u001a\u0010\u0006\u001a\u00020\u00002\u0012\u0010\r\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\u00070\u000eR\u001a\u0010\u0006\u001a\u00020\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\b\u0010\t\"\u0004\b\n\u0010\u000b¨\u0006\u000f"}, m18d2 = {"Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerRendering$Builder;", "", "rendering", "Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerRendering;", "(Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerRendering;)V", "()V", "state", "Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerState;", "setState$zendesk_ui_ui_android", "(Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerState;)V", "build", "stateUpdate", "Lkotlin/Function1;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private WaitTimeBannerState state;

        public Builder() {
            this.state = new WaitTimeBannerState(null, 0, 0, 7, null);
        }

        public final WaitTimeBannerState getState() {
            return this.state;
        }

        public final void setState$zendesk_ui_ui_android(WaitTimeBannerState waitTimeBannerState) {
            Intrinsics.checkNotNullParameter(waitTimeBannerState, "<set-?>");
            this.state = waitTimeBannerState;
        }

        public Builder(WaitTimeBannerRendering rendering) {
            this();
            Intrinsics.checkNotNullParameter(rendering, "rendering");
            this.state = rendering.getState();
        }

        public Builder(WaitTimeBannerRendering waitTimeBannerRendering, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? new WaitTimeBannerRendering() : waitTimeBannerRendering);
        }

        public final Builder state(Function1<? super WaitTimeBannerState, WaitTimeBannerState> stateUpdate) {
            Intrinsics.checkNotNullParameter(stateUpdate, "stateUpdate");
            this.state = stateUpdate.invoke(this.state);
            return this;
        }

        public final WaitTimeBannerRendering build() {
            return new WaitTimeBannerRendering(this);
        }
    }
}
