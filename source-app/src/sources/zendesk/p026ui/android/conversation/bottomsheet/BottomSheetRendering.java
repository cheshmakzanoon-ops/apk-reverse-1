package zendesk.p026ui.android.conversation.bottomsheet;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.logger.Logger;

@Metadata(m17d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0007\u0018\u0000 \u00132\u00020\u0001:\u0002\u0012\u0013B\u0007\b\u0016¢\u0006\u0002\u0010\u0002B\u000f\b\u0000\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0011\u001a\u00020\u0004R\u001a\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u001a\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\nR\u0014\u0010\r\u001a\u00020\u000eX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010¨\u0006\u0014"}, m18d2 = {"Lzendesk/ui/android/conversation/bottomsheet/BottomSheetRendering;", "", "()V", "builder", "Lzendesk/ui/android/conversation/bottomsheet/BottomSheetRendering$Builder;", "(Lzendesk/ui/android/conversation/bottomsheet/BottomSheetRendering$Builder;)V", "onBottomSheetActionClicked", "Lkotlin/Function0;", "", "getOnBottomSheetActionClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function0;", "onBottomSheetDismissed", "getOnBottomSheetDismissed$zendesk_ui_ui_android", "state", "Lzendesk/ui/android/conversation/bottomsheet/BottomSheetState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/bottomsheet/BottomSheetState;", "toBuilder", "Builder", "Companion", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class BottomSheetRendering {
    public static final int $stable = 0;
    private static final Companion Companion = new Companion(null);
    private static final String LOG_TAG = "BottomSheetRendering";
    private final Function0<Unit> onBottomSheetActionClicked;
    private final Function0<Unit> onBottomSheetDismissed;
    private final BottomSheetState state;

    public BottomSheetRendering(Builder builder) {
        Intrinsics.checkNotNullParameter(builder, "builder");
        this.onBottomSheetActionClicked = builder.getOnBottomSheetActionClicked$zendesk_ui_ui_android();
        this.onBottomSheetDismissed = builder.getOnBottomSheetDismissed$zendesk_ui_ui_android();
        this.state = builder.getState();
    }

    public final Function0<Unit> getOnBottomSheetActionClicked$zendesk_ui_ui_android() {
        return this.onBottomSheetActionClicked;
    }

    public final Function0<Unit> getOnBottomSheetDismissed$zendesk_ui_ui_android() {
        return this.onBottomSheetDismissed;
    }

    public final BottomSheetState getState() {
        return this.state;
    }

    public BottomSheetRendering() {
        this(new Builder());
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\b\u0007\u0018\u00002\u00020\u0001B\u0011\b\u0010\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0016\u001a\u00020\u0003J\u0014\u0010\u0006\u001a\u00020\u00002\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007J\u0014\u0010\r\u001a\u00020\u00002\f\u0010\r\u001a\b\u0012\u0004\u0012\u00020\b0\u0007J\u001a\u0010\u0010\u001a\u00020\u00002\u0012\u0010\u0017\u001a\u000e\u0012\u0004\u0012\u00020\u0011\u0012\u0004\u0012\u00020\u00110\u0018R \u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\t\u0010\n\"\u0004\b\u000b\u0010\fR \u0010\r\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000e\u0010\n\"\u0004\b\u000f\u0010\fR\u001a\u0010\u0010\u001a\u00020\u0011X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0012\u0010\u0013\"\u0004\b\u0014\u0010\u0015¨\u0006\u0019"}, m18d2 = {"Lzendesk/ui/android/conversation/bottomsheet/BottomSheetRendering$Builder;", "", "rendering", "Lzendesk/ui/android/conversation/bottomsheet/BottomSheetRendering;", "(Lzendesk/ui/android/conversation/bottomsheet/BottomSheetRendering;)V", "()V", "onBottomSheetActionClicked", "Lkotlin/Function0;", "", "getOnBottomSheetActionClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function0;", "setOnBottomSheetActionClicked$zendesk_ui_ui_android", "(Lkotlin/jvm/functions/Function0;)V", "onBottomSheetDismissed", "getOnBottomSheetDismissed$zendesk_ui_ui_android", "setOnBottomSheetDismissed$zendesk_ui_ui_android", "state", "Lzendesk/ui/android/conversation/bottomsheet/BottomSheetState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/bottomsheet/BottomSheetState;", "setState$zendesk_ui_ui_android", "(Lzendesk/ui/android/conversation/bottomsheet/BottomSheetState;)V", "build", "stateUpdate", "Lkotlin/Function1;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private Function0<Unit> onBottomSheetActionClicked;
        private Function0<Unit> onBottomSheetDismissed;
        private BottomSheetState state;

        public Builder() {
            this.onBottomSheetActionClicked = new Function0<Unit>() {
                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }

                public final void invoke2() {
                    Logger.m225w("BottomSheetRendering", "BottomSheetRendering#onBottomSheetActionClicked == null", new Object[0]);
                }
            };
            this.onBottomSheetDismissed = new Function0<Unit>() {
                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }

                public final void invoke2() {
                    Logger.m225w("BottomSheetRendering", "BottomSheetRendering#onBottomSheetDismissed == null", new Object[0]);
                }
            };
            this.state = new BottomSheetState(null, null, 0L, false, null, null, null, 127, null);
        }

        public final Function0<Unit> getOnBottomSheetActionClicked$zendesk_ui_ui_android() {
            return this.onBottomSheetActionClicked;
        }

        public final void setOnBottomSheetActionClicked$zendesk_ui_ui_android(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onBottomSheetActionClicked = function0;
        }

        public final Function0<Unit> getOnBottomSheetDismissed$zendesk_ui_ui_android() {
            return this.onBottomSheetDismissed;
        }

        public final void setOnBottomSheetDismissed$zendesk_ui_ui_android(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onBottomSheetDismissed = function0;
        }

        public final BottomSheetState getState() {
            return this.state;
        }

        public final void setState$zendesk_ui_ui_android(BottomSheetState bottomSheetState) {
            Intrinsics.checkNotNullParameter(bottomSheetState, "<set-?>");
            this.state = bottomSheetState;
        }

        public Builder(BottomSheetRendering rendering) {
            this();
            Intrinsics.checkNotNullParameter(rendering, "rendering");
            this.onBottomSheetActionClicked = rendering.getOnBottomSheetActionClicked$zendesk_ui_ui_android();
            this.onBottomSheetDismissed = rendering.getOnBottomSheetDismissed$zendesk_ui_ui_android();
            this.state = rendering.getState();
        }

        public Builder(BottomSheetRendering bottomSheetRendering, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? new BottomSheetRendering() : bottomSheetRendering);
        }

        public final Builder onBottomSheetActionClicked(Function0<Unit> onBottomSheetActionClicked) {
            Intrinsics.checkNotNullParameter(onBottomSheetActionClicked, "onBottomSheetActionClicked");
            this.onBottomSheetActionClicked = onBottomSheetActionClicked;
            return this;
        }

        public final Builder onBottomSheetDismissed(Function0<Unit> onBottomSheetDismissed) {
            Intrinsics.checkNotNullParameter(onBottomSheetDismissed, "onBottomSheetDismissed");
            this.onBottomSheetDismissed = onBottomSheetDismissed;
            return this;
        }

        public final Builder state(Function1<? super BottomSheetState, BottomSheetState> stateUpdate) {
            Intrinsics.checkNotNullParameter(stateUpdate, "stateUpdate");
            this.state = stateUpdate.invoke(this.state);
            return this;
        }

        public final BottomSheetRendering build() {
            return new BottomSheetRendering(this);
        }
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0005"}, m18d2 = {"Lzendesk/ui/android/conversation/bottomsheet/BottomSheetRendering$Companion;", "", "()V", "LOG_TAG", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
