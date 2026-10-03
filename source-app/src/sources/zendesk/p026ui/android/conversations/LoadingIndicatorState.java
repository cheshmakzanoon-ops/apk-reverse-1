package zendesk.p026ui.android.conversations;

import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\b\n\u0002\b\f\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0087\b\u0018\u00002\u00020\u0001:\u0001\u0015B\u001b\b\u0000\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\t\u0010\f\u001a\u00020\u0005HÆ\u0003J\u001d\u0010\r\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u000e\u001a\u00020\u00032\b\u0010\u000f\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0010\u001a\u00020\u0005HÖ\u0001J\u0006\u0010\u0011\u001a\u00020\u0012J\t\u0010\u0013\u001a\u00020\u0014HÖ\u0001R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u0016"}, m18d2 = {"Lzendesk/ui/android/conversations/LoadingIndicatorState;", "", "showLoadingIndicator", "", "indicatorColor", "", "(ZI)V", "getIndicatorColor", "()I", "getShowLoadingIndicator", "()Z", "component1", "component2", "copy", "equals", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/conversations/LoadingIndicatorState$Builder;", "toString", "", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class LoadingIndicatorState {
    public static final int $stable = 0;
    private final int indicatorColor;
    private final boolean showLoadingIndicator;

    public LoadingIndicatorState() {
        this(false, 0 == true ? 1 : 0, 3, null);
    }

    public static LoadingIndicatorState copy$default(LoadingIndicatorState loadingIndicatorState, boolean z, int i, int i2, Object obj) {
        if ((i2 & 1) != 0) {
            z = loadingIndicatorState.showLoadingIndicator;
        }
        if ((i2 & 2) != 0) {
            i = loadingIndicatorState.indicatorColor;
        }
        return loadingIndicatorState.copy(z, i);
    }

    public final boolean getShowLoadingIndicator() {
        return this.showLoadingIndicator;
    }

    public final int getIndicatorColor() {
        return this.indicatorColor;
    }

    public final LoadingIndicatorState copy(boolean showLoadingIndicator, int indicatorColor) {
        return new LoadingIndicatorState(showLoadingIndicator, indicatorColor);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof LoadingIndicatorState)) {
            return false;
        }
        LoadingIndicatorState loadingIndicatorState = (LoadingIndicatorState) other;
        return this.showLoadingIndicator == loadingIndicatorState.showLoadingIndicator && this.indicatorColor == loadingIndicatorState.indicatorColor;
    }

    public int hashCode() {
        return (UByte$$ExternalSyntheticBackport0.m30m(this.showLoadingIndicator) * 31) + this.indicatorColor;
    }

    public String toString() {
        return "LoadingIndicatorState(showLoadingIndicator=" + this.showLoadingIndicator + ", indicatorColor=" + this.indicatorColor + ')';
    }

    public LoadingIndicatorState(boolean z, int i) {
        this.showLoadingIndicator = z;
        this.indicatorColor = i;
    }

    public LoadingIndicatorState(boolean z, int i, int i2, DefaultConstructorMarker defaultConstructorMarker) {
        this((i2 & 1) != 0 ? false : z, (i2 & 2) != 0 ? 0 : i);
    }

    public final boolean getShowLoadingIndicator() {
        return this.showLoadingIndicator;
    }

    public final int getIndicatorColor() {
        return this.indicatorColor;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\b\n\u0000\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0006\u001a\u00020\u0003J\u0016\u0010\u0007\u001a\u00020\u00002\u0006\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u000bR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\f"}, m18d2 = {"Lzendesk/ui/android/conversations/LoadingIndicatorState$Builder;", "", "state", "Lzendesk/ui/android/conversations/LoadingIndicatorState;", "(Lzendesk/ui/android/conversations/LoadingIndicatorState;)V", "()V", "build", "loadingIndicatorState", "showLoadingIndicator", "", "indicatorColor", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private LoadingIndicatorState state;

        public Builder() {
            this.state = new LoadingIndicatorState(false, 0 == true ? 1 : 0, 3, null);
        }

        public Builder(LoadingIndicatorState state) {
            this();
            Intrinsics.checkNotNullParameter(state, "state");
            this.state = state;
        }

        public final Builder loadingIndicatorState(boolean showLoadingIndicator, int indicatorColor) {
            this.state = this.state.copy(showLoadingIndicator, indicatorColor);
            return this;
        }

        public final LoadingIndicatorState getState() {
            return this.state;
        }
    }
}
