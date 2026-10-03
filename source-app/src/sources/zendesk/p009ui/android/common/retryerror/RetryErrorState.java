package zendesk.p009ui.android.common.retryerror;

import androidx.constraintlayout.core.motion.utils.TypedValues;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.internal.ServerProtocol;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\b\n\u0002\b\u0013\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0087\b\u0018\u00002\u00020\u0001:\u0001\u001fB/\b\u0000\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0003\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0003\u0012\b\b\u0003\u0010\u0007\u001a\u00020\u0005¢\u0006\u0002\u0010\bJ\u000e\u0010\u000f\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u0010J\u000e\u0010\u0011\u001a\u00020\u0005HÀ\u0003¢\u0006\u0002\b\u0012J\u000e\u0010\u0013\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u0014J\u000e\u0010\u0015\u001a\u00020\u0005HÀ\u0003¢\u0006\u0002\b\u0016J1\u0010\u0017\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0003\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00032\b\b\u0003\u0010\u0007\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u0018\u001a\u00020\u00192\b\u0010\u001a\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u001b\u001a\u00020\u0005HÖ\u0001J\u0006\u0010\u001c\u001a\u00020\u001dJ\t\u0010\u001e\u001a\u00020\u0003HÖ\u0001R\u0014\u0010\u0006\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u0014\u0010\u0007\u001a\u00020\u0005X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0014\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\nR\u0014\u0010\u0004\u001a\u00020\u0005X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\f¨\u0006 "}, d2 = {"Lzendesk/ui/android/common/retryerror/RetryErrorState;", "", "retryMessageText", "", "retryMessageTextColor", "", "retryButtonText", "retryButtonTextColor", "(Ljava/lang/String;ILjava/lang/String;I)V", "getRetryButtonText$zendesk_ui_ui_android", "()Ljava/lang/String;", "getRetryButtonTextColor$zendesk_ui_ui_android", "()I", "getRetryMessageText$zendesk_ui_ui_android", "getRetryMessageTextColor$zendesk_ui_ui_android", "component1", "component1$zendesk_ui_ui_android", "component2", "component2$zendesk_ui_ui_android", "component3", "component3$zendesk_ui_ui_android", "component4", "component4$zendesk_ui_ui_android", "copy", "equals", "", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/common/retryerror/RetryErrorState$Builder;", "toString", "Builder", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class RetryErrorState {
    public static final int $stable = 0;
    private final String retryButtonText;
    private final int retryButtonTextColor;
    private final String retryMessageText;
    private final int retryMessageTextColor;

    public RetryErrorState() {
        this(null, 0, null, 0, 15, null);
    }

    public static RetryErrorState copy$default(RetryErrorState retryErrorState, String str, int i, String str2, int i2, int i3, Object obj) {
        if ((i3 & 1) != 0) {
            str = retryErrorState.retryMessageText;
        }
        if ((i3 & 2) != 0) {
            i = retryErrorState.retryMessageTextColor;
        }
        if ((i3 & 4) != 0) {
            str2 = retryErrorState.retryButtonText;
        }
        if ((i3 & 8) != 0) {
            i2 = retryErrorState.retryButtonTextColor;
        }
        return retryErrorState.copy(str, i, str2, i2);
    }

    public final String getRetryMessageText() {
        return this.retryMessageText;
    }

    public final int getRetryMessageTextColor() {
        return this.retryMessageTextColor;
    }

    public final String getRetryButtonText() {
        return this.retryButtonText;
    }

    public final int getRetryButtonTextColor() {
        return this.retryButtonTextColor;
    }

    public final RetryErrorState copy(String retryMessageText, int retryMessageTextColor, String retryButtonText, int retryButtonTextColor) {
        Intrinsics.checkNotNullParameter(retryMessageText, "retryMessageText");
        Intrinsics.checkNotNullParameter(retryButtonText, "retryButtonText");
        return new RetryErrorState(retryMessageText, retryMessageTextColor, retryButtonText, retryButtonTextColor);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof RetryErrorState)) {
            return false;
        }
        RetryErrorState retryErrorState = (RetryErrorState) other;
        return Intrinsics.areEqual(this.retryMessageText, retryErrorState.retryMessageText) && this.retryMessageTextColor == retryErrorState.retryMessageTextColor && Intrinsics.areEqual(this.retryButtonText, retryErrorState.retryButtonText) && this.retryButtonTextColor == retryErrorState.retryButtonTextColor;
    }

    public int hashCode() {
        return (((((this.retryMessageText.hashCode() * 31) + this.retryMessageTextColor) * 31) + this.retryButtonText.hashCode()) * 31) + this.retryButtonTextColor;
    }

    public String toString() {
        return "RetryErrorState(retryMessageText=" + this.retryMessageText + ", retryMessageTextColor=" + this.retryMessageTextColor + ", retryButtonText=" + this.retryButtonText + ", retryButtonTextColor=" + this.retryButtonTextColor + ')';
    }

    public RetryErrorState(String str, int i, String str2, int i2) {
        Intrinsics.checkNotNullParameter(str, "retryMessageText");
        Intrinsics.checkNotNullParameter(str2, "retryButtonText");
        this.retryMessageText = str;
        this.retryMessageTextColor = i;
        this.retryButtonText = str2;
        this.retryButtonTextColor = i2;
    }

    public RetryErrorState(String str, int i, String str2, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this((i3 & 1) != 0 ? "" : str, (i3 & 2) != 0 ? 0 : i, (i3 & 4) != 0 ? "" : str2, (i3 & 8) != 0 ? 0 : i2);
    }

    public final String getRetryMessageText$zendesk_ui_ui_android() {
        return this.retryMessageText;
    }

    public final int getRetryMessageTextColor$zendesk_ui_ui_android() {
        return this.retryMessageTextColor;
    }

    public final String getRetryButtonText$zendesk_ui_ui_android() {
        return this.retryButtonText;
    }

    public final int getRetryButtonTextColor$zendesk_ui_ui_android() {
        return this.retryButtonTextColor;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0003\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0006\u001a\u00020\u0003J\u000e\u0010\u0007\u001a\u00020\u00002\u0006\u0010\b\u001a\u00020\tJ\u0010\u0010\n\u001a\u00020\u00002\b\b\u0001\u0010\u000b\u001a\u00020\fJ\u000e\u0010\r\u001a\u00020\u00002\u0006\u0010\b\u001a\u00020\tJ\u0010\u0010\u000e\u001a\u00020\u00002\b\b\u0001\u0010\u000b\u001a\u00020\fR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u000f"}, d2 = {"Lzendesk/ui/android/common/retryerror/RetryErrorState$Builder;", "", ServerProtocol.DIALOG_PARAM_STATE, "Lzendesk/ui/android/common/retryerror/RetryErrorState;", "(Lzendesk/ui/android/common/retryerror/RetryErrorState;)V", "()V", "build", "buttonText", "text", "", "buttonTextColor", TypedValues.Custom.S_COLOR, "", "messageText", "messageTextColor", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Builder {
        public static final int $stable = 8;
        private RetryErrorState state;

        public Builder() {
            this.state = new RetryErrorState(null, 0, null, 0, 15, null);
        }

        public Builder(RetryErrorState retryErrorState) {
            this();
            Intrinsics.checkNotNullParameter(retryErrorState, ServerProtocol.DIALOG_PARAM_STATE);
            this.state = retryErrorState;
        }

        public final Builder messageText(String text) {
            Intrinsics.checkNotNullParameter(text, "text");
            this.state = RetryErrorState.copy$default(this.state, text, 0, null, 0, 14, null);
            return this;
        }

        public final Builder messageTextColor(int color) {
            this.state = RetryErrorState.copy$default(this.state, null, color, null, 0, 13, null);
            return this;
        }

        public final Builder buttonText(String text) {
            Intrinsics.checkNotNullParameter(text, "text");
            this.state = RetryErrorState.copy$default(this.state, null, 0, text, 0, 11, null);
            return this;
        }

        public final Builder buttonTextColor(int color) {
            this.state = RetryErrorState.copy$default(this.state, null, 0, null, color, 7, null);
            return this;
        }

        public final RetryErrorState getState() {
            return this.state;
        }
    }
}
