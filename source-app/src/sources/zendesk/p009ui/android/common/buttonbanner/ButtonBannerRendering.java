package zendesk.p009ui.android.common.buttonbanner;

import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.app.FrameMetricsAggregator;
import com.facebook.internal.ServerProtocol;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.logger.Logger;

@Metadata(d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0007\u0018\u0000 \u00132\u00020\u0001:\u0002\u0012\u0013B\u0007\b\u0016¢\u0006\u0002\u0010\u0002B\u000f\b\u0000\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0011\u001a\u00020\u0004R\u001a\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u001a\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\nR\u0014\u0010\r\u001a\u00020\u000eX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010¨\u0006\u0014"}, d2 = {"Lzendesk/ui/android/common/buttonbanner/ButtonBannerRendering;", "", "()V", "builder", "Lzendesk/ui/android/common/buttonbanner/ButtonBannerRendering$Builder;", "(Lzendesk/ui/android/common/buttonbanner/ButtonBannerRendering$Builder;)V", "onViewClicked", "Lkotlin/Function0;", "", "getOnViewClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function0;", "onViewDismissed", "getOnViewDismissed$zendesk_ui_ui_android", ServerProtocol.DIALOG_PARAM_STATE, "Lzendesk/ui/android/common/buttonbanner/ButtonBannerState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/common/buttonbanner/ButtonBannerState;", "toBuilder", "Builder", "Companion", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class ButtonBannerRendering {
    private static final String LOG_TAG = "UnreadMessagesRendering";
    private final Function0<Unit> onViewClicked;
    private final Function0<Unit> onViewDismissed;
    private final ButtonBannerState state;
    private static final Companion Companion = new Companion(null);
    public static final int $stable = 8;

    public ButtonBannerRendering(Builder builder) {
        Intrinsics.checkNotNullParameter(builder, "builder");
        this.onViewClicked = builder.getOnViewClicked$zendesk_ui_ui_android();
        this.onViewDismissed = builder.getOnViewDismissed$zendesk_ui_ui_android();
        this.state = builder.getState();
    }

    public final Function0<Unit> getOnViewClicked$zendesk_ui_ui_android() {
        return this.onViewClicked;
    }

    public final Function0<Unit> getOnViewDismissed$zendesk_ui_ui_android() {
        return this.onViewDismissed;
    }

    public final ButtonBannerState getState() {
        return this.state;
    }

    public ButtonBannerRendering() {
        this(new Builder());
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\b\u0007\u0018\u00002\u00020\u0001B\u0011\b\u0010\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0016\u001a\u00020\u0003J\u0014\u0010\u0006\u001a\u00020\u00002\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007J\u0014\u0010\r\u001a\u00020\u00002\f\u0010\r\u001a\b\u0012\u0004\u0012\u00020\b0\u0007J\u001a\u0010\u0010\u001a\u00020\u00002\u0012\u0010\u0017\u001a\u000e\u0012\u0004\u0012\u00020\u0011\u0012\u0004\u0012\u00020\u00110\u0018R \u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\t\u0010\n\"\u0004\b\u000b\u0010\fR \u0010\r\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000e\u0010\n\"\u0004\b\u000f\u0010\fR\u001a\u0010\u0010\u001a\u00020\u0011X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0012\u0010\u0013\"\u0004\b\u0014\u0010\u0015¨\u0006\u0019"}, d2 = {"Lzendesk/ui/android/common/buttonbanner/ButtonBannerRendering$Builder;", "", "rendering", "Lzendesk/ui/android/common/buttonbanner/ButtonBannerRendering;", "(Lzendesk/ui/android/common/buttonbanner/ButtonBannerRendering;)V", "()V", "onViewClicked", "Lkotlin/Function0;", "", "getOnViewClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function0;", "setOnViewClicked$zendesk_ui_ui_android", "(Lkotlin/jvm/functions/Function0;)V", "onViewDismissed", "getOnViewDismissed$zendesk_ui_ui_android", "setOnViewDismissed$zendesk_ui_ui_android", ServerProtocol.DIALOG_PARAM_STATE, "Lzendesk/ui/android/common/buttonbanner/ButtonBannerState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/common/buttonbanner/ButtonBannerState;", "setState$zendesk_ui_ui_android", "(Lzendesk/ui/android/common/buttonbanner/ButtonBannerState;)V", "build", "stateUpdate", "Lkotlin/Function1;", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Builder {
        public static final int $stable = 8;
        private Function0<Unit> onViewClicked;
        private Function0<Unit> onViewDismissed;
        private ButtonBannerState state;

        public Builder() {
            this.onViewClicked = new Function0<Unit>() {
                public Object invoke() {
                    m2631invoke();
                    return Unit.INSTANCE;
                }

                public final void m2631invoke() {
                    Logger.w("UnreadMessagesRendering", "UnreadMessagesRendering#onViewClicked == null", new Object[0]);
                }
            };
            this.onViewDismissed = new Function0<Unit>() {
                public Object invoke() {
                    m2632invoke();
                    return Unit.INSTANCE;
                }

                public final void m2632invoke() {
                    Logger.w("UnreadMessagesRendering", "UnreadMessagesRendering#onViewDismissed == null", new Object[0]);
                }
            };
            this.state = new ButtonBannerState(null, null, null, null, null, null, null, null, false, FrameMetricsAggregator.EVERY_DURATION, null);
        }

        public final Function0<Unit> getOnViewClicked$zendesk_ui_ui_android() {
            return this.onViewClicked;
        }

        public final void setOnViewClicked$zendesk_ui_ui_android(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onViewClicked = function0;
        }

        public final Function0<Unit> getOnViewDismissed$zendesk_ui_ui_android() {
            return this.onViewDismissed;
        }

        public final void setOnViewDismissed$zendesk_ui_ui_android(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onViewDismissed = function0;
        }

        public final ButtonBannerState getState() {
            return this.state;
        }

        public final void setState$zendesk_ui_ui_android(ButtonBannerState buttonBannerState) {
            Intrinsics.checkNotNullParameter(buttonBannerState, "<set-?>");
            this.state = buttonBannerState;
        }

        public Builder(ButtonBannerRendering buttonBannerRendering) {
            this();
            Intrinsics.checkNotNullParameter(buttonBannerRendering, "rendering");
            this.onViewClicked = buttonBannerRendering.getOnViewClicked$zendesk_ui_ui_android();
            this.onViewDismissed = buttonBannerRendering.getOnViewDismissed$zendesk_ui_ui_android();
            this.state = buttonBannerRendering.getState();
        }

        public Builder(ButtonBannerRendering buttonBannerRendering, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? new ButtonBannerRendering() : buttonBannerRendering);
        }

        public final Builder onViewClicked(Function0<Unit> onViewClicked) {
            Intrinsics.checkNotNullParameter(onViewClicked, "onViewClicked");
            this.onViewClicked = onViewClicked;
            return this;
        }

        public final Builder onViewDismissed(Function0<Unit> onViewDismissed) {
            Intrinsics.checkNotNullParameter(onViewDismissed, "onViewDismissed");
            this.onViewDismissed = onViewDismissed;
            return this;
        }

        public final Builder state(Function1<? super ButtonBannerState, ButtonBannerState> stateUpdate) {
            Intrinsics.checkNotNullParameter(stateUpdate, "stateUpdate");
            this.state = (ButtonBannerState) stateUpdate.invoke(this.state);
            return this;
        }

        public final ButtonBannerRendering build() {
            return new ButtonBannerRendering(this);
        }
    }

    @Metadata(d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0005"}, d2 = {"Lzendesk/ui/android/common/buttonbanner/ButtonBannerRendering$Companion;", "", "()V", "LOG_TAG", "", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
