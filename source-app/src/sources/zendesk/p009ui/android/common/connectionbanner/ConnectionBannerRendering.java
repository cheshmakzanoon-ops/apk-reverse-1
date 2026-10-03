package zendesk.p009ui.android.common.connectionbanner;

import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.internal.ServerProtocol;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.logger.Logger;

@Metadata(d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0007\u0018\u0000 \u00152\u00020\u0001:\u0002\u0014\u0015B\u0007\b\u0016¢\u0006\u0002\u0010\u0002B\u000f\b\u0000\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0013\u001a\u00020\u0004R\u001a\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u0014\u0010\u000b\u001a\u00020\fX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0014\u0010\u000f\u001a\u00020\u0010X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012¨\u0006\u0016"}, d2 = {"Lzendesk/ui/android/common/connectionbanner/ConnectionBannerRendering;", "", "()V", "builder", "Lzendesk/ui/android/common/connectionbanner/ConnectionBannerRendering$Builder;", "(Lzendesk/ui/android/common/connectionbanner/ConnectionBannerRendering$Builder;)V", "onRetryClicked", "Lkotlin/Function0;", "", "getOnRetryClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function0;", "showRetry", "", "getShowRetry$zendesk_ui_ui_android", "()Z", ServerProtocol.DIALOG_PARAM_STATE, "Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState;", "toBuilder", "Builder", "Companion", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class ConnectionBannerRendering {
    public static final int $stable = 0;
    private static final Companion Companion = new Companion(null);
    private static final String LOG_TAG = "ConnectionBannerRendering";
    private final Function0<Unit> onRetryClicked;
    private final boolean showRetry;
    private final ConnectionBannerState state;

    public ConnectionBannerRendering(Builder builder) {
        Intrinsics.checkNotNullParameter(builder, "builder");
        this.onRetryClicked = builder.getOnRetryClicked$zendesk_ui_ui_android();
        this.showRetry = builder.getShowRetry();
        this.state = builder.getState();
    }

    public final Function0<Unit> getOnRetryClicked$zendesk_ui_ui_android() {
        return this.onRetryClicked;
    }

    public final boolean getShowRetry() {
        return this.showRetry;
    }

    public final ConnectionBannerState getState() {
        return this.state;
    }

    public ConnectionBannerRendering() {
        this(new Builder());
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\b\u0007\u0018\u00002\u00020\u0001B\u0011\b\u0010\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0019\u001a\u00020\u0003J\u0014\u0010\u0006\u001a\u00020\u00002\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007J\u000e\u0010\r\u001a\u00020\u00002\u0006\u0010\r\u001a\u00020\u000eJ\u001a\u0010\u0013\u001a\u00020\u00002\u0012\u0010\u001a\u001a\u000e\u0012\u0004\u0012\u00020\u0014\u0012\u0004\u0012\u00020\u00140\u001bR \u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\t\u0010\n\"\u0004\b\u000b\u0010\fR\u001a\u0010\r\u001a\u00020\u000eX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000f\u0010\u0010\"\u0004\b\u0011\u0010\u0012R\u001a\u0010\u0013\u001a\u00020\u0014X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0015\u0010\u0016\"\u0004\b\u0017\u0010\u0018¨\u0006\u001c"}, d2 = {"Lzendesk/ui/android/common/connectionbanner/ConnectionBannerRendering$Builder;", "", "rendering", "Lzendesk/ui/android/common/connectionbanner/ConnectionBannerRendering;", "(Lzendesk/ui/android/common/connectionbanner/ConnectionBannerRendering;)V", "()V", "onRetryClicked", "Lkotlin/Function0;", "", "getOnRetryClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function0;", "setOnRetryClicked$zendesk_ui_ui_android", "(Lkotlin/jvm/functions/Function0;)V", "showRetry", "", "getShowRetry$zendesk_ui_ui_android", "()Z", "setShowRetry$zendesk_ui_ui_android", "(Z)V", ServerProtocol.DIALOG_PARAM_STATE, "Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState;", "setState$zendesk_ui_ui_android", "(Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState;)V", "build", "stateUpdate", "Lkotlin/Function1;", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Builder {
        public static final int $stable = 8;
        private Function0<Unit> onRetryClicked;
        private boolean showRetry;
        private ConnectionBannerState state;

        public Builder() {
            this.onRetryClicked = new Function0<Unit>() {
                public Object invoke() {
                    m2634invoke();
                    return Unit.INSTANCE;
                }

                public final void m2634invoke() {
                    Logger.w("ConnectionBannerRendering", "ConnectionBannerRendering#onRetryClicked == null", new Object[0]);
                }
            };
            this.state = new ConnectionBannerState(null, 0, 0, 0, 15, null);
            this.showRetry = true;
        }

        public final Function0<Unit> getOnRetryClicked$zendesk_ui_ui_android() {
            return this.onRetryClicked;
        }

        public final void setOnRetryClicked$zendesk_ui_ui_android(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onRetryClicked = function0;
        }

        public final ConnectionBannerState getState() {
            return this.state;
        }

        public final void setState$zendesk_ui_ui_android(ConnectionBannerState connectionBannerState) {
            Intrinsics.checkNotNullParameter(connectionBannerState, "<set-?>");
            this.state = connectionBannerState;
        }

        public final boolean getShowRetry() {
            return this.showRetry;
        }

        public final void setShowRetry$zendesk_ui_ui_android(boolean z) {
            this.showRetry = z;
        }

        public Builder(ConnectionBannerRendering connectionBannerRendering) {
            this();
            Intrinsics.checkNotNullParameter(connectionBannerRendering, "rendering");
            this.onRetryClicked = connectionBannerRendering.getOnRetryClicked$zendesk_ui_ui_android();
            this.state = connectionBannerRendering.getState();
        }

        public Builder(ConnectionBannerRendering connectionBannerRendering, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? new ConnectionBannerRendering() : connectionBannerRendering);
        }

        public final Builder onRetryClicked(Function0<Unit> onRetryClicked) {
            Intrinsics.checkNotNullParameter(onRetryClicked, "onRetryClicked");
            this.onRetryClicked = onRetryClicked;
            return this;
        }

        public final Builder showRetry(boolean showRetry) {
            this.showRetry = showRetry;
            return this;
        }

        public final Builder state(Function1<? super ConnectionBannerState, ConnectionBannerState> stateUpdate) {
            Intrinsics.checkNotNullParameter(stateUpdate, "stateUpdate");
            this.state = (ConnectionBannerState) stateUpdate.invoke(this.state);
            return this;
        }

        public final ConnectionBannerRendering build() {
            return new ConnectionBannerRendering(this);
        }
    }

    @Metadata(d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0005"}, d2 = {"Lzendesk/ui/android/common/connectionbanner/ConnectionBannerRendering$Companion;", "", "()V", "LOG_TAG", "", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
