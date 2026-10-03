package zendesk.p009ui.android.common.retryerror;

import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.internal.ServerProtocol;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.logger.Logger;

@Metadata(d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0007\u0018\u0000 \u00112\u00020\u0001:\u0002\u0010\u0011B\u0007\b\u0016¢\u0006\u0002\u0010\u0002B\u000f\b\u0000\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J\u0006\u0010\u000f\u001a\u00020\u0004R\u001a\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u0014\u0010\u000b\u001a\u00020\fX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000e¨\u0006\u0012"}, d2 = {"Lzendesk/ui/android/common/retryerror/RetryErrorRendering;", "", "()V", "builder", "Lzendesk/ui/android/common/retryerror/RetryErrorRendering$Builder;", "(Lzendesk/ui/android/common/retryerror/RetryErrorRendering$Builder;)V", "onButtonClicked", "Lkotlin/Function0;", "", "getOnButtonClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function0;", ServerProtocol.DIALOG_PARAM_STATE, "Lzendesk/ui/android/common/retryerror/RetryErrorState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/common/retryerror/RetryErrorState;", "toBuilder", "Builder", "Companion", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class RetryErrorRendering {
    public static final int $stable = 0;
    private static final Companion Companion = new Companion(null);
    private static final String LOG_TAG = "RetryErrorRendering";
    private final Function0<Unit> onButtonClicked;
    private final RetryErrorState state;

    public RetryErrorRendering(Builder builder) {
        Intrinsics.checkNotNullParameter(builder, "builder");
        this.onButtonClicked = builder.getOnButtonClicked$zendesk_ui_ui_android();
        this.state = builder.getState();
    }

    public final Function0<Unit> getOnButtonClicked$zendesk_ui_ui_android() {
        return this.onButtonClicked;
    }

    public final RetryErrorState getState() {
        return this.state;
    }

    public RetryErrorRendering() {
        this(new Builder());
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\b\u0007\u0018\u00002\u00020\u0001B\u0011\b\u0010\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0013\u001a\u00020\u0003J\u0014\u0010\u0006\u001a\u00020\u00002\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007J\u001a\u0010\r\u001a\u00020\u00002\u0012\u0010\u0014\u001a\u000e\u0012\u0004\u0012\u00020\u000e\u0012\u0004\u0012\u00020\u000e0\u0015R \u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\t\u0010\n\"\u0004\b\u000b\u0010\fR\u001a\u0010\r\u001a\u00020\u000eX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000f\u0010\u0010\"\u0004\b\u0011\u0010\u0012¨\u0006\u0016"}, d2 = {"Lzendesk/ui/android/common/retryerror/RetryErrorRendering$Builder;", "", "rendering", "Lzendesk/ui/android/common/retryerror/RetryErrorRendering;", "(Lzendesk/ui/android/common/retryerror/RetryErrorRendering;)V", "()V", "onButtonClicked", "Lkotlin/Function0;", "", "getOnButtonClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function0;", "setOnButtonClicked$zendesk_ui_ui_android", "(Lkotlin/jvm/functions/Function0;)V", ServerProtocol.DIALOG_PARAM_STATE, "Lzendesk/ui/android/common/retryerror/RetryErrorState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/common/retryerror/RetryErrorState;", "setState$zendesk_ui_ui_android", "(Lzendesk/ui/android/common/retryerror/RetryErrorState;)V", "build", "stateUpdate", "Lkotlin/Function1;", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Builder {
        public static final int $stable = 8;
        private Function0<Unit> onButtonClicked;
        private RetryErrorState state;

        public Builder() {
            this.onButtonClicked = new Function0<Unit>() {
                public Object invoke() {
                    m2640invoke();
                    return Unit.INSTANCE;
                }

                public final void m2640invoke() {
                    Logger.w("RetryErrorRendering", "RetryErrorRendering#onButtonClicked == null", new Object[0]);
                }
            };
            this.state = new RetryErrorState(null, 0, null, 0, 15, null);
        }

        public final Function0<Unit> getOnButtonClicked$zendesk_ui_ui_android() {
            return this.onButtonClicked;
        }

        public final void setOnButtonClicked$zendesk_ui_ui_android(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onButtonClicked = function0;
        }

        public final RetryErrorState getState() {
            return this.state;
        }

        public final void setState$zendesk_ui_ui_android(RetryErrorState retryErrorState) {
            Intrinsics.checkNotNullParameter(retryErrorState, "<set-?>");
            this.state = retryErrorState;
        }

        public Builder(RetryErrorRendering retryErrorRendering) {
            this();
            Intrinsics.checkNotNullParameter(retryErrorRendering, "rendering");
            this.onButtonClicked = retryErrorRendering.getOnButtonClicked$zendesk_ui_ui_android();
            this.state = retryErrorRendering.getState();
        }

        public Builder(RetryErrorRendering retryErrorRendering, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? new RetryErrorRendering() : retryErrorRendering);
        }

        public final Builder onButtonClicked(Function0<Unit> onButtonClicked) {
            Intrinsics.checkNotNullParameter(onButtonClicked, "onButtonClicked");
            this.onButtonClicked = onButtonClicked;
            return this;
        }

        public final Builder state(Function1<? super RetryErrorState, RetryErrorState> stateUpdate) {
            Intrinsics.checkNotNullParameter(stateUpdate, "stateUpdate");
            this.state = (RetryErrorState) stateUpdate.invoke(this.state);
            return this;
        }

        public final RetryErrorRendering build() {
            return new RetryErrorRendering(this);
        }
    }

    @Metadata(d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0005"}, d2 = {"Lzendesk/ui/android/common/retryerror/RetryErrorRendering$Companion;", "", "()V", "LOG_TAG", "", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
