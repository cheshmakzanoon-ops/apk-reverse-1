package zendesk.p026ui.android.conversation.waittimebanner;

import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u000f\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0087\b\u0018\u00002\u00020\u0001:\u0001\u001cB%\b\u0000\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0003\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0003\u0010\u0006\u001a\u00020\u0005¢\u0006\u0002\u0010\u0007J\u000e\u0010\r\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u000eJ\u000e\u0010\u000f\u001a\u00020\u0005HÀ\u0003¢\u0006\u0002\b\u0010J\u000e\u0010\u0011\u001a\u00020\u0005HÀ\u0003¢\u0006\u0002\b\u0012J'\u0010\u0013\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0003\u0010\u0004\u001a\u00020\u00052\b\b\u0003\u0010\u0006\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u0014\u001a\u00020\u00152\b\u0010\u0016\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0017\u001a\u00020\u0005HÖ\u0001J\u0006\u0010\u0018\u001a\u00020\u0019J\t\u0010\u001a\u001a\u00020\u001bHÖ\u0001R\u0014\u0010\u0006\u001a\u00020\u0005X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\u0014\u0010\u0004\u001a\u00020\u0005X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\tR\u0014\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\f¨\u0006\u001d"}, m18d2 = {"Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerState;", "", "type", "Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerType;", "onBackgroundColor", "", "focusedBorderColor", "(Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerType;II)V", "getFocusedBorderColor$zendesk_ui_ui_android", "()I", "getOnBackgroundColor$zendesk_ui_ui_android", "getType$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerType;", "component1", "component1$zendesk_ui_ui_android", "component2", "component2$zendesk_ui_ui_android", "component3", "component3$zendesk_ui_ui_android", "copy", "equals", "", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerState$Builder;", "toString", "", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class WaitTimeBannerState {
    public static final int $stable = 0;
    private final int focusedBorderColor;
    private final int onBackgroundColor;
    private final WaitTimeBannerType type;

    public WaitTimeBannerState() {
        this(null, 0, 0, 7, null);
    }

    public static WaitTimeBannerState copy$default(WaitTimeBannerState waitTimeBannerState, WaitTimeBannerType waitTimeBannerType, int i, int i2, int i3, Object obj) {
        if ((i3 & 1) != 0) {
            waitTimeBannerType = waitTimeBannerState.type;
        }
        if ((i3 & 2) != 0) {
            i = waitTimeBannerState.onBackgroundColor;
        }
        if ((i3 & 4) != 0) {
            i2 = waitTimeBannerState.focusedBorderColor;
        }
        return waitTimeBannerState.copy(waitTimeBannerType, i, i2);
    }

    public final WaitTimeBannerType getType() {
        return this.type;
    }

    public final int getOnBackgroundColor() {
        return this.onBackgroundColor;
    }

    public final int getFocusedBorderColor() {
        return this.focusedBorderColor;
    }

    public final WaitTimeBannerState copy(WaitTimeBannerType type, int onBackgroundColor, int focusedBorderColor) {
        Intrinsics.checkNotNullParameter(type, "type");
        return new WaitTimeBannerState(type, onBackgroundColor, focusedBorderColor);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof WaitTimeBannerState)) {
            return false;
        }
        WaitTimeBannerState waitTimeBannerState = (WaitTimeBannerState) other;
        return Intrinsics.areEqual(this.type, waitTimeBannerState.type) && this.onBackgroundColor == waitTimeBannerState.onBackgroundColor && this.focusedBorderColor == waitTimeBannerState.focusedBorderColor;
    }

    public int hashCode() {
        return (((this.type.hashCode() * 31) + this.onBackgroundColor) * 31) + this.focusedBorderColor;
    }

    public String toString() {
        return "WaitTimeBannerState(type=" + this.type + ", onBackgroundColor=" + this.onBackgroundColor + ", focusedBorderColor=" + this.focusedBorderColor + ')';
    }

    public WaitTimeBannerState(WaitTimeBannerType type, int i, int i2) {
        Intrinsics.checkNotNullParameter(type, "type");
        this.type = type;
        this.onBackgroundColor = i;
        this.focusedBorderColor = i2;
    }

    public WaitTimeBannerState(WaitTimeBannerType.Cleared cleared, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this((i3 & 1) != 0 ? WaitTimeBannerType.Cleared.INSTANCE : cleared, (i3 & 2) != 0 ? 0 : i, (i3 & 4) != 0 ? 0 : i2);
    }

    public final WaitTimeBannerType getType$zendesk_ui_ui_android() {
        return this.type;
    }

    public final int getOnBackgroundColor$zendesk_ui_ui_android() {
        return this.onBackgroundColor;
    }

    public final int getFocusedBorderColor$zendesk_ui_ui_android() {
        return this.focusedBorderColor;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0006\u001a\u00020\u0003J\u0006\u0010\u0007\u001a\u00020\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\b"}, m18d2 = {"Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerState$Builder;", "", "state", "Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerState;", "(Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerState;)V", "()V", "build", "waitTimeBannerState", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private WaitTimeBannerState state;

        public Builder() {
            this.state = new WaitTimeBannerState(null, 0, 0, 7, null);
        }

        public Builder(WaitTimeBannerState state) {
            this();
            Intrinsics.checkNotNullParameter(state, "state");
            this.state = state;
        }

        public final Builder waitTimeBannerState() {
            this.state = WaitTimeBannerState.copy$default(this.state, null, 0, 0, 7, null);
            return this;
        }

        public final WaitTimeBannerState getState() {
            return this.state;
        }
    }
}
