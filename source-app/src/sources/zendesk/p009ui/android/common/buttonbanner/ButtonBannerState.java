package zendesk.p009ui.android.common.buttonbanner;

import android.text.Spanned;
import androidx.constraintlayout.core.motion.utils.TypedValues;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.app.FrameMetricsAggregator;
import com.facebook.internal.ServerProtocol;
import kotlin.Metadata;
import kotlin.UByte$;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b+\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0087\b\u0018\u00002\u00020\u0001:\u0001<Bq\b\u0000\u0012\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\n\b\u0003\u0010\b\u001a\u0004\u0018\u00010\t\u0012\n\b\u0003\u0010\n\u001a\u0004\u0018\u00010\t\u0012\n\b\u0003\u0010\u000b\u001a\u0004\u0018\u00010\t\u0012\n\b\u0003\u0010\f\u001a\u0004\u0018\u00010\t\u0012\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u000e\u0012\b\b\u0002\u0010\u000f\u001a\u00020\u0007¢\u0006\u0002\u0010\u0010J\u0010\u0010\"\u001a\u0004\u0018\u00010\u0003HÀ\u0003¢\u0006\u0002\b#J\u0010\u0010$\u001a\u0004\u0018\u00010\u0005HÀ\u0003¢\u0006\u0002\b%J\u0012\u0010&\u001a\u0004\u0018\u00010\u0007HÀ\u0003¢\u0006\u0004\b'\u0010\u0017J\u0012\u0010(\u001a\u0004\u0018\u00010\tHÀ\u0003¢\u0006\u0004\b)\u0010\u0012J\u0012\u0010*\u001a\u0004\u0018\u00010\tHÀ\u0003¢\u0006\u0004\b+\u0010\u0012J\u0012\u0010,\u001a\u0004\u0018\u00010\tHÀ\u0003¢\u0006\u0004\b-\u0010\u0012J\u0012\u0010.\u001a\u0004\u0018\u00010\tHÀ\u0003¢\u0006\u0004\b/\u0010\u0012J\u0010\u00100\u001a\u0004\u0018\u00010\u000eHÀ\u0003¢\u0006\u0002\b1J\u000e\u00102\u001a\u00020\u0007HÀ\u0003¢\u0006\u0002\b3Jx\u00104\u001a\u00020\u00002\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u00072\n\b\u0003\u0010\b\u001a\u0004\u0018\u00010\t2\n\b\u0003\u0010\n\u001a\u0004\u0018\u00010\t2\n\b\u0003\u0010\u000b\u001a\u0004\u0018\u00010\t2\n\b\u0003\u0010\f\u001a\u0004\u0018\u00010\t2\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u000e2\b\b\u0002\u0010\u000f\u001a\u00020\u0007HÆ\u0001¢\u0006\u0002\u00105J\u0013\u00106\u001a\u00020\u00072\b\u00107\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u00108\u001a\u00020\tHÖ\u0001J\u0006\u00109\u001a\u00020:J\t\u0010;\u001a\u00020\u0005HÖ\u0001R\u0018\u0010\u000b\u001a\u0004\u0018\u00010\tX\u0080\u0004¢\u0006\n\n\u0002\u0010\u0013\u001a\u0004\b\u0011\u0010\u0012R\u0018\u0010\f\u001a\u0004\u0018\u00010\tX\u0080\u0004¢\u0006\n\n\u0002\u0010\u0013\u001a\u0004\b\u0014\u0010\u0012R\u0018\u0010\n\u001a\u0004\u0018\u00010\tX\u0080\u0004¢\u0006\n\n\u0002\u0010\u0013\u001a\u0004\b\u0015\u0010\u0012R\u0018\u0010\u0006\u001a\u0004\u0018\u00010\u0007X\u0080\u0004¢\u0006\n\n\u0002\u0010\u0018\u001a\u0004\b\u0016\u0010\u0017R\u0014\u0010\u000f\u001a\u00020\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u001aR\u0016\u0010\r\u001a\u0004\u0018\u00010\u000eX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u001cR\u0016\u0010\u0004\u001a\u0004\u0018\u00010\u0005X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u001eR\u0018\u0010\b\u001a\u0004\u0018\u00010\tX\u0080\u0004¢\u0006\n\n\u0002\u0010\u0013\u001a\u0004\b\u001f\u0010\u0012R\u0016\u0010\u0002\u001a\u0004\u0018\u00010\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b \u0010!¨\u0006="}, d2 = {"Lzendesk/ui/android/common/buttonbanner/ButtonBannerState;", "", "viewType", "Lzendesk/ui/android/common/buttonbanner/ButtonBannerViewType;", "text", "", "isVisible", "", "textColor", "", "iconColor", "backgroundColor", "buttonsBackgroundColor", "styledText", "Landroid/text/Spanned;", "shouldAnimate", "(Lzendesk/ui/android/common/buttonbanner/ButtonBannerViewType;Ljava/lang/String;Ljava/lang/Boolean;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;Landroid/text/Spanned;Z)V", "getBackgroundColor$zendesk_ui_ui_android", "()Ljava/lang/Integer;", "Ljava/lang/Integer;", "getButtonsBackgroundColor$zendesk_ui_ui_android", "getIconColor$zendesk_ui_ui_android", "isVisible$zendesk_ui_ui_android", "()Ljava/lang/Boolean;", "Ljava/lang/Boolean;", "getShouldAnimate$zendesk_ui_ui_android", "()Z", "getStyledText$zendesk_ui_ui_android", "()Landroid/text/Spanned;", "getText$zendesk_ui_ui_android", "()Ljava/lang/String;", "getTextColor$zendesk_ui_ui_android", "getViewType$zendesk_ui_ui_android", "()Lzendesk/ui/android/common/buttonbanner/ButtonBannerViewType;", "component1", "component1$zendesk_ui_ui_android", "component2", "component2$zendesk_ui_ui_android", "component3", "component3$zendesk_ui_ui_android", "component4", "component4$zendesk_ui_ui_android", "component5", "component5$zendesk_ui_ui_android", "component6", "component6$zendesk_ui_ui_android", "component7", "component7$zendesk_ui_ui_android", "component8", "component8$zendesk_ui_ui_android", "component9", "component9$zendesk_ui_ui_android", "copy", "(Lzendesk/ui/android/common/buttonbanner/ButtonBannerViewType;Ljava/lang/String;Ljava/lang/Boolean;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;Landroid/text/Spanned;Z)Lzendesk/ui/android/common/buttonbanner/ButtonBannerState;", "equals", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/common/buttonbanner/ButtonBannerState$Builder;", "toString", "Builder", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class ButtonBannerState {
    public static final int $stable = 8;
    private final Integer backgroundColor;
    private final Integer buttonsBackgroundColor;
    private final Integer iconColor;
    private final Boolean isVisible;
    private final boolean shouldAnimate;
    private final Spanned styledText;
    private final String text;
    private final Integer textColor;
    private final ButtonBannerViewType viewType;

    public ButtonBannerState() {
        this(null, null, null, null, null, null, null, null, false, FrameMetricsAggregator.EVERY_DURATION, null);
    }

    public static ButtonBannerState copy$default(ButtonBannerState buttonBannerState, ButtonBannerViewType buttonBannerViewType, String str, Boolean bool, Integer num, Integer num2, Integer num3, Integer num4, Spanned spanned, boolean z, int i, Object obj) {
        return buttonBannerState.copy((i & 1) != 0 ? buttonBannerState.viewType : buttonBannerViewType, (i & 2) != 0 ? buttonBannerState.text : str, (i & 4) != 0 ? buttonBannerState.isVisible : bool, (i & 8) != 0 ? buttonBannerState.textColor : num, (i & 16) != 0 ? buttonBannerState.iconColor : num2, (i & 32) != 0 ? buttonBannerState.backgroundColor : num3, (i & 64) != 0 ? buttonBannerState.buttonsBackgroundColor : num4, (i & 128) != 0 ? buttonBannerState.styledText : spanned, (i & 256) != 0 ? buttonBannerState.shouldAnimate : z);
    }

    public final ButtonBannerViewType getViewType() {
        return this.viewType;
    }

    public final String getText() {
        return this.text;
    }

    public final Boolean getIsVisible() {
        return this.isVisible;
    }

    public final Integer getTextColor() {
        return this.textColor;
    }

    public final Integer getIconColor() {
        return this.iconColor;
    }

    public final Integer getBackgroundColor() {
        return this.backgroundColor;
    }

    public final Integer getButtonsBackgroundColor() {
        return this.buttonsBackgroundColor;
    }

    public final Spanned getStyledText() {
        return this.styledText;
    }

    public final boolean getShouldAnimate() {
        return this.shouldAnimate;
    }

    public final ButtonBannerState copy(ButtonBannerViewType viewType, String text, Boolean isVisible, Integer textColor, Integer iconColor, Integer backgroundColor, Integer buttonsBackgroundColor, Spanned styledText, boolean shouldAnimate) {
        return new ButtonBannerState(viewType, text, isVisible, textColor, iconColor, backgroundColor, buttonsBackgroundColor, styledText, shouldAnimate);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ButtonBannerState)) {
            return false;
        }
        ButtonBannerState buttonBannerState = (ButtonBannerState) other;
        return this.viewType == buttonBannerState.viewType && Intrinsics.areEqual(this.text, buttonBannerState.text) && Intrinsics.areEqual(this.isVisible, buttonBannerState.isVisible) && Intrinsics.areEqual(this.textColor, buttonBannerState.textColor) && Intrinsics.areEqual(this.iconColor, buttonBannerState.iconColor) && Intrinsics.areEqual(this.backgroundColor, buttonBannerState.backgroundColor) && Intrinsics.areEqual(this.buttonsBackgroundColor, buttonBannerState.buttonsBackgroundColor) && Intrinsics.areEqual(this.styledText, buttonBannerState.styledText) && this.shouldAnimate == buttonBannerState.shouldAnimate;
    }

    public int hashCode() {
        ButtonBannerViewType buttonBannerViewType = this.viewType;
        int iHashCode = (buttonBannerViewType == null ? 0 : buttonBannerViewType.hashCode()) * 31;
        String str = this.text;
        int iHashCode2 = (iHashCode + (str == null ? 0 : str.hashCode())) * 31;
        Boolean bool = this.isVisible;
        int iHashCode3 = (iHashCode2 + (bool == null ? 0 : bool.hashCode())) * 31;
        Integer num = this.textColor;
        int iHashCode4 = (iHashCode3 + (num == null ? 0 : num.hashCode())) * 31;
        Integer num2 = this.iconColor;
        int iHashCode5 = (iHashCode4 + (num2 == null ? 0 : num2.hashCode())) * 31;
        Integer num3 = this.backgroundColor;
        int iHashCode6 = (iHashCode5 + (num3 == null ? 0 : num3.hashCode())) * 31;
        Integer num4 = this.buttonsBackgroundColor;
        int iHashCode7 = (iHashCode6 + (num4 == null ? 0 : num4.hashCode())) * 31;
        Spanned spanned = this.styledText;
        return ((iHashCode7 + (spanned != null ? spanned.hashCode() : 0)) * 31) + UByte$.ExternalSyntheticBackport0.m(this.shouldAnimate);
    }

    public String toString() {
        return "ButtonBannerState(viewType=" + this.viewType + ", text=" + this.text + ", isVisible=" + this.isVisible + ", textColor=" + this.textColor + ", iconColor=" + this.iconColor + ", backgroundColor=" + this.backgroundColor + ", buttonsBackgroundColor=" + this.buttonsBackgroundColor + ", styledText=" + ((Object) this.styledText) + ", shouldAnimate=" + this.shouldAnimate + ')';
    }

    public ButtonBannerState(ButtonBannerViewType buttonBannerViewType, String str, Boolean bool, Integer num, Integer num2, Integer num3, Integer num4, Spanned spanned, boolean z) {
        this.viewType = buttonBannerViewType;
        this.text = str;
        this.isVisible = bool;
        this.textColor = num;
        this.iconColor = num2;
        this.backgroundColor = num3;
        this.buttonsBackgroundColor = num4;
        this.styledText = spanned;
        this.shouldAnimate = z;
    }

    public final ButtonBannerViewType getViewType$zendesk_ui_ui_android() {
        return this.viewType;
    }

    public ButtonBannerState(ButtonBannerViewType buttonBannerViewType, String str, Boolean bool, Integer num, Integer num2, Integer num3, Integer num4, Spanned spanned, boolean z, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? null : buttonBannerViewType, (i & 2) != 0 ? "" : str, (i & 4) != 0 ? false : bool, (i & 8) != 0 ? null : num, (i & 16) != 0 ? null : num2, (i & 32) != 0 ? null : num3, (i & 64) != 0 ? null : num4, (i & 128) == 0 ? spanned : null, (i & 256) == 0 ? z : false);
    }

    public final String getText$zendesk_ui_ui_android() {
        return this.text;
    }

    public final Boolean isVisible$zendesk_ui_ui_android() {
        return this.isVisible;
    }

    public final Integer getTextColor$zendesk_ui_ui_android() {
        return this.textColor;
    }

    public final Integer getIconColor$zendesk_ui_ui_android() {
        return this.iconColor;
    }

    public final Integer getBackgroundColor$zendesk_ui_ui_android() {
        return this.backgroundColor;
    }

    public final Integer getButtonsBackgroundColor$zendesk_ui_ui_android() {
        return this.buttonsBackgroundColor;
    }

    public final Spanned getStyledText$zendesk_ui_ui_android() {
        return this.styledText;
    }

    public final boolean getShouldAnimate$zendesk_ui_ui_android() {
        return this.shouldAnimate;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0010\u0010\u0006\u001a\u00020\u00002\b\b\u0001\u0010\u0007\u001a\u00020\bJ\u0006\u0010\t\u001a\u00020\u0003J\u0010\u0010\n\u001a\u00020\u00002\b\b\u0001\u0010\u0007\u001a\u00020\bJ\u0010\u0010\u000b\u001a\u00020\u00002\b\b\u0001\u0010\u0007\u001a\u00020\bJ\u000e\u0010\f\u001a\u00020\u00002\u0006\u0010\f\u001a\u00020\rJ\u000e\u0010\u000e\u001a\u00020\u00002\u0006\u0010\u000f\u001a\u00020\u0010J\u000e\u0010\u0011\u001a\u00020\u00002\u0006\u0010\u0011\u001a\u00020\u0012J\u0010\u0010\u0013\u001a\u00020\u00002\b\b\u0001\u0010\u0007\u001a\u00020\bJ\u000e\u0010\u0014\u001a\u00020\u00002\u0006\u0010\u0014\u001a\u00020\u0015R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0016"}, d2 = {"Lzendesk/ui/android/common/buttonbanner/ButtonBannerState$Builder;", "", ServerProtocol.DIALOG_PARAM_STATE, "Lzendesk/ui/android/common/buttonbanner/ButtonBannerState;", "(Lzendesk/ui/android/common/buttonbanner/ButtonBannerState;)V", "()V", "backgroundColor", TypedValues.Custom.S_COLOR, "", "build", "buttonsBackgroundColor", "iconColor", "isVisible", "", "styledText", "spanned", "Landroid/text/Spanned;", "text", "", "textColor", "viewType", "Lzendesk/ui/android/common/buttonbanner/ButtonBannerViewType;", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Builder {
        public static final int $stable = 8;
        private ButtonBannerState state;

        public Builder() {
            this.state = new ButtonBannerState(null, null, null, null, null, null, null, null, false, FrameMetricsAggregator.EVERY_DURATION, null);
        }

        public Builder(ButtonBannerState buttonBannerState) {
            this();
            Intrinsics.checkNotNullParameter(buttonBannerState, ServerProtocol.DIALOG_PARAM_STATE);
            this.state = buttonBannerState;
        }

        public final Builder viewType(ButtonBannerViewType viewType) {
            Intrinsics.checkNotNullParameter(viewType, "viewType");
            this.state = ButtonBannerState.copy$default(this.state, viewType, null, null, null, null, null, null, null, false, TypedValues.PositionType.TYPE_POSITION_TYPE, null);
            return this;
        }

        public final Builder text(String text) {
            Intrinsics.checkNotNullParameter(text, "text");
            this.state = ButtonBannerState.copy$default(this.state, null, text, null, null, null, null, null, null, false, 509, null);
            return this;
        }

        public final Builder isVisible(boolean isVisible) {
            this.state = ButtonBannerState.copy$default(this.state, null, null, Boolean.valueOf(isVisible), null, null, null, null, null, false, TypedValues.PositionType.TYPE_PERCENT_Y, null);
            return this;
        }

        public final Builder textColor(int color) {
            this.state = ButtonBannerState.copy$default(this.state, null, null, null, Integer.valueOf(color), null, null, null, null, false, TypedValues.PositionType.TYPE_PERCENT_WIDTH, null);
            return this;
        }

        public final Builder iconColor(int color) {
            this.state = ButtonBannerState.copy$default(this.state, null, null, null, Integer.valueOf(color), null, null, null, null, false, TypedValues.PositionType.TYPE_PERCENT_WIDTH, null);
            return this;
        }

        public final Builder backgroundColor(int color) {
            this.state = ButtonBannerState.copy$default(this.state, null, null, null, null, null, Integer.valueOf(color), null, null, false, 479, null);
            return this;
        }

        public final Builder buttonsBackgroundColor(int color) {
            this.state = ButtonBannerState.copy$default(this.state, null, null, null, null, null, null, Integer.valueOf(color), null, false, 447, null);
            return this;
        }

        public final Builder styledText(Spanned spanned) {
            Intrinsics.checkNotNullParameter(spanned, "spanned");
            this.state = ButtonBannerState.copy$default(this.state, null, null, null, null, null, null, null, spanned, false, 383, null);
            return this;
        }

        public final ButtonBannerState getState() {
            return this.state;
        }
    }
}
