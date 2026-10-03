package zendesk.p009ui.android.common.button;

import androidx.constraintlayout.core.motion.utils.TypedValues;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.internal.ServerProtocol;
import kotlin.Metadata;
import kotlin.UByte$;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\b\n\u0002\b \n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0087\b\u0018\u00002\u00020\u0001:\u0001*BI\b\u0000\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0003\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\n\b\u0003\u0010\b\u001a\u0004\u0018\u00010\u0007\u0012\n\b\u0003\u0010\t\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\n\u001a\u00020\u0005¢\u0006\u0002\u0010\u000bJ\u000e\u0010\u0016\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u0017J\u000e\u0010\u0018\u001a\u00020\u0005HÀ\u0003¢\u0006\u0002\b\u0019J\u0012\u0010\u001a\u001a\u0004\u0018\u00010\u0007HÀ\u0003¢\u0006\u0004\b\u001b\u0010\rJ\u0012\u0010\u001c\u001a\u0004\u0018\u00010\u0007HÀ\u0003¢\u0006\u0004\b\u001d\u0010\rJ\u0012\u0010\u001e\u001a\u0004\u0018\u00010\u0007HÀ\u0003¢\u0006\u0004\b\u001f\u0010\rJ\u000e\u0010 \u001a\u00020\u0005HÀ\u0003¢\u0006\u0002\b!JP\u0010\"\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\n\b\u0003\u0010\u0006\u001a\u0004\u0018\u00010\u00072\n\b\u0003\u0010\b\u001a\u0004\u0018\u00010\u00072\n\b\u0003\u0010\t\u001a\u0004\u0018\u00010\u00072\b\b\u0002\u0010\n\u001a\u00020\u0005HÆ\u0001¢\u0006\u0002\u0010#J\u0013\u0010$\u001a\u00020\u00052\b\u0010%\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010&\u001a\u00020\u0007HÖ\u0001J\u0006\u0010'\u001a\u00020(J\t\u0010)\u001a\u00020\u0003HÖ\u0001R\u0018\u0010\u0006\u001a\u0004\u0018\u00010\u0007X\u0080\u0004¢\u0006\n\n\u0002\u0010\u000e\u001a\u0004\b\f\u0010\rR\u0014\u0010\n\u001a\u00020\u0005X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u0014\u0010\u0004\u001a\u00020\u0005X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0010R\u0018\u0010\t\u001a\u0004\u0018\u00010\u0007X\u0080\u0004¢\u0006\n\n\u0002\u0010\u000e\u001a\u0004\b\u0012\u0010\rR\u0014\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R\u0018\u0010\b\u001a\u0004\u0018\u00010\u0007X\u0080\u0004¢\u0006\n\n\u0002\u0010\u000e\u001a\u0004\b\u0015\u0010\r¨\u0006+"}, d2 = {"Lzendesk/ui/android/common/button/ButtonState;", "", "text", "", "isLoading", "", "backgroundColor", "", "textColor", "loadingColor", "isClickable", "(Ljava/lang/String;ZLjava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;Z)V", "getBackgroundColor$zendesk_ui_ui_android", "()Ljava/lang/Integer;", "Ljava/lang/Integer;", "isClickable$zendesk_ui_ui_android", "()Z", "isLoading$zendesk_ui_ui_android", "getLoadingColor$zendesk_ui_ui_android", "getText$zendesk_ui_ui_android", "()Ljava/lang/String;", "getTextColor$zendesk_ui_ui_android", "component1", "component1$zendesk_ui_ui_android", "component2", "component2$zendesk_ui_ui_android", "component3", "component3$zendesk_ui_ui_android", "component4", "component4$zendesk_ui_ui_android", "component5", "component5$zendesk_ui_ui_android", "component6", "component6$zendesk_ui_ui_android", "copy", "(Ljava/lang/String;ZLjava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;Z)Lzendesk/ui/android/common/button/ButtonState;", "equals", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/common/button/ButtonState$Builder;", "toString", "Builder", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class ButtonState {
    public static final int $stable = 0;
    private final Integer backgroundColor;
    private final boolean isClickable;
    private final boolean isLoading;
    private final Integer loadingColor;
    private final String text;
    private final Integer textColor;

    public ButtonState() {
        this(null, false, null, null, null, false, 63, null);
    }

    public static ButtonState copy$default(ButtonState buttonState, String str, boolean z, Integer num, Integer num2, Integer num3, boolean z2, int i, Object obj) {
        if ((i & 1) != 0) {
            str = buttonState.text;
        }
        if ((i & 2) != 0) {
            z = buttonState.isLoading;
        }
        boolean z3 = z;
        if ((i & 4) != 0) {
            num = buttonState.backgroundColor;
        }
        Integer num4 = num;
        if ((i & 8) != 0) {
            num2 = buttonState.textColor;
        }
        Integer num5 = num2;
        if ((i & 16) != 0) {
            num3 = buttonState.loadingColor;
        }
        Integer num6 = num3;
        if ((i & 32) != 0) {
            z2 = buttonState.isClickable;
        }
        return buttonState.copy(str, z3, num4, num5, num6, z2);
    }

    public final String getText() {
        return this.text;
    }

    public final boolean getIsLoading() {
        return this.isLoading;
    }

    public final Integer getBackgroundColor() {
        return this.backgroundColor;
    }

    public final Integer getTextColor() {
        return this.textColor;
    }

    public final Integer getLoadingColor() {
        return this.loadingColor;
    }

    public final boolean getIsClickable() {
        return this.isClickable;
    }

    public final ButtonState copy(String text, boolean isLoading, Integer backgroundColor, Integer textColor, Integer loadingColor, boolean isClickable) {
        Intrinsics.checkNotNullParameter(text, "text");
        return new ButtonState(text, isLoading, backgroundColor, textColor, loadingColor, isClickable);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ButtonState)) {
            return false;
        }
        ButtonState buttonState = (ButtonState) other;
        return Intrinsics.areEqual(this.text, buttonState.text) && this.isLoading == buttonState.isLoading && Intrinsics.areEqual(this.backgroundColor, buttonState.backgroundColor) && Intrinsics.areEqual(this.textColor, buttonState.textColor) && Intrinsics.areEqual(this.loadingColor, buttonState.loadingColor) && this.isClickable == buttonState.isClickable;
    }

    public int hashCode() {
        int iHashCode = ((this.text.hashCode() * 31) + UByte$.ExternalSyntheticBackport0.m(this.isLoading)) * 31;
        Integer num = this.backgroundColor;
        int iHashCode2 = (iHashCode + (num == null ? 0 : num.hashCode())) * 31;
        Integer num2 = this.textColor;
        int iHashCode3 = (iHashCode2 + (num2 == null ? 0 : num2.hashCode())) * 31;
        Integer num3 = this.loadingColor;
        return ((iHashCode3 + (num3 != null ? num3.hashCode() : 0)) * 31) + UByte$.ExternalSyntheticBackport0.m(this.isClickable);
    }

    public String toString() {
        return "ButtonState(text=" + this.text + ", isLoading=" + this.isLoading + ", backgroundColor=" + this.backgroundColor + ", textColor=" + this.textColor + ", loadingColor=" + this.loadingColor + ", isClickable=" + this.isClickable + ')';
    }

    public ButtonState(String str, boolean z, Integer num, Integer num2, Integer num3, boolean z2) {
        Intrinsics.checkNotNullParameter(str, "text");
        this.text = str;
        this.isLoading = z;
        this.backgroundColor = num;
        this.textColor = num2;
        this.loadingColor = num3;
        this.isClickable = z2;
    }

    public ButtonState(String str, boolean z, Integer num, Integer num2, Integer num3, boolean z2, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? "" : str, (i & 2) != 0 ? false : z, (i & 4) != 0 ? null : num, (i & 8) != 0 ? null : num2, (i & 16) == 0 ? num3 : null, (i & 32) != 0 ? true : z2);
    }

    public final String getText$zendesk_ui_ui_android() {
        return this.text;
    }

    public final boolean isLoading$zendesk_ui_ui_android() {
        return this.isLoading;
    }

    public final Integer getBackgroundColor$zendesk_ui_ui_android() {
        return this.backgroundColor;
    }

    public final Integer getTextColor$zendesk_ui_ui_android() {
        return this.textColor;
    }

    public final Integer getLoadingColor$zendesk_ui_ui_android() {
        return this.loadingColor;
    }

    public final boolean isClickable$zendesk_ui_ui_android() {
        return this.isClickable;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0010\u0010\u0006\u001a\u00020\u00002\b\b\u0001\u0010\u0007\u001a\u00020\bJ\u0006\u0010\t\u001a\u00020\u0003J\u000e\u0010\n\u001a\u00020\u00002\u0006\u0010\n\u001a\u00020\u000bJ\u0010\u0010\f\u001a\u00020\u00002\b\b\u0001\u0010\u0007\u001a\u00020\bJ\u000e\u0010\r\u001a\u00020\u00002\u0006\u0010\r\u001a\u00020\u000eJ\u0010\u0010\u000f\u001a\u00020\u00002\b\b\u0001\u0010\u0007\u001a\u00020\bR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0010"}, d2 = {"Lzendesk/ui/android/common/button/ButtonState$Builder;", "", ServerProtocol.DIALOG_PARAM_STATE, "Lzendesk/ui/android/common/button/ButtonState;", "(Lzendesk/ui/android/common/button/ButtonState;)V", "()V", "backgroundColor", TypedValues.Custom.S_COLOR, "", "build", "isLoading", "", "loadingColor", "text", "", "textColor", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Builder {
        public static final int $stable = 8;
        private ButtonState state;

        public Builder() {
            this.state = new ButtonState(null, false, null, null, null, false, 63, null);
        }

        public Builder(ButtonState buttonState) {
            this();
            Intrinsics.checkNotNullParameter(buttonState, ServerProtocol.DIALOG_PARAM_STATE);
            this.state = buttonState;
        }

        public final Builder text(String text) {
            Intrinsics.checkNotNullParameter(text, "text");
            this.state = ButtonState.copy$default(this.state, text, false, null, null, null, false, 62, null);
            return this;
        }

        public final Builder isLoading(boolean isLoading) {
            this.state = ButtonState.copy$default(this.state, null, isLoading, null, null, null, false, 61, null);
            return this;
        }

        public final Builder backgroundColor(int color) {
            this.state = ButtonState.copy$default(this.state, null, false, Integer.valueOf(color), null, null, false, 59, null);
            return this;
        }

        public final Builder textColor(int color) {
            this.state = ButtonState.copy$default(this.state, null, false, null, Integer.valueOf(color), null, false, 55, null);
            return this;
        }

        public final Builder loadingColor(int color) {
            this.state = ButtonState.copy$default(this.state, null, false, null, null, Integer.valueOf(color), false, 47, null);
            return this;
        }

        public final ButtonState getState() {
            return this.state;
        }
    }
}
