package zendesk.p009ui.android.common.loadmore;

import androidx.constraintlayout.core.motion.utils.TypedValues;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.internal.ServerProtocol;
import kotlin.Metadata;
import kotlin.enums.EnumEntries;
import kotlin.enums.EnumEntriesKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0012\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u00002\u00020\u0001:\u0002!\"B1\b\u0000\u0012\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u0003\u0012\b\b\u0003\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0003\u0010\u0006\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0007\u001a\u00020\b¢\u0006\u0002\u0010\tJ\u0010\u0010\u0011\u001a\u0004\u0018\u00010\u0003HÀ\u0003¢\u0006\u0002\b\u0012J\u000e\u0010\u0013\u001a\u00020\u0005HÀ\u0003¢\u0006\u0002\b\u0014J\u000e\u0010\u0015\u001a\u00020\u0005HÀ\u0003¢\u0006\u0002\b\u0016J\u000e\u0010\u0017\u001a\u00020\bHÀ\u0003¢\u0006\u0002\b\u0018J3\u0010\u0019\u001a\u00020\u00002\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u00032\b\b\u0003\u0010\u0004\u001a\u00020\u00052\b\b\u0003\u0010\u0006\u001a\u00020\u00052\b\b\u0002\u0010\u0007\u001a\u00020\bHÆ\u0001J\u0013\u0010\u001a\u001a\u00020\u001b2\b\u0010\u001c\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u001d\u001a\u00020\u0005HÖ\u0001J\u0006\u0010\u001e\u001a\u00020\u001fJ\t\u0010 \u001a\u00020\u0003HÖ\u0001R\u0016\u0010\u0002\u001a\u0004\u0018\u00010\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0014\u0010\u0006\u001a\u00020\u0005X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u0014\u0010\u0004\u001a\u00020\u0005X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\rR\u0014\u0010\u0007\u001a\u00020\bX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010¨\u0006#"}, d2 = {"Lzendesk/ui/android/common/loadmore/LoadMoreState;", "", "failedRetryText", "", "progressBarColor", "", "failedRetryTextColor", "status", "Lzendesk/ui/android/common/loadmore/LoadMoreState$LoadMoreStatus;", "(Ljava/lang/String;IILzendesk/ui/android/common/loadmore/LoadMoreState$LoadMoreStatus;)V", "getFailedRetryText$zendesk_ui_ui_android", "()Ljava/lang/String;", "getFailedRetryTextColor$zendesk_ui_ui_android", "()I", "getProgressBarColor$zendesk_ui_ui_android", "getStatus$zendesk_ui_ui_android", "()Lzendesk/ui/android/common/loadmore/LoadMoreState$LoadMoreStatus;", "component1", "component1$zendesk_ui_ui_android", "component2", "component2$zendesk_ui_ui_android", "component3", "component3$zendesk_ui_ui_android", "component4", "component4$zendesk_ui_ui_android", "copy", "equals", "", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/common/loadmore/LoadMoreState$Builder;", "toString", "Builder", "LoadMoreStatus", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class LoadMoreState {
    public static final int $stable = 0;
    private final String failedRetryText;
    private final int failedRetryTextColor;
    private final int progressBarColor;
    private final LoadMoreStatus status;

    @Metadata(d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\u0005\b\u0086\u0081\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002j\u0002\b\u0003j\u0002\b\u0004j\u0002\b\u0005¨\u0006\u0006"}, d2 = {"Lzendesk/ui/android/common/loadmore/LoadMoreState$LoadMoreStatus;", "", "(Ljava/lang/String;I)V", "LOADING", "FAILED", "NONE", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public enum LoadMoreStatus {
        LOADING,
        FAILED,
        NONE;

        private static final EnumEntries $ENTRIES = EnumEntriesKt.enumEntries(values());

        public static EnumEntries<LoadMoreStatus> getEntries() {
            return $ENTRIES;
        }
    }

    public LoadMoreState() {
        this(null, 0, 0, null, 15, null);
    }

    public static LoadMoreState copy$default(LoadMoreState loadMoreState, String str, int i, int i2, LoadMoreStatus loadMoreStatus, int i3, Object obj) {
        if ((i3 & 1) != 0) {
            str = loadMoreState.failedRetryText;
        }
        if ((i3 & 2) != 0) {
            i = loadMoreState.progressBarColor;
        }
        if ((i3 & 4) != 0) {
            i2 = loadMoreState.failedRetryTextColor;
        }
        if ((i3 & 8) != 0) {
            loadMoreStatus = loadMoreState.status;
        }
        return loadMoreState.copy(str, i, i2, loadMoreStatus);
    }

    public final String getFailedRetryText() {
        return this.failedRetryText;
    }

    public final int getProgressBarColor() {
        return this.progressBarColor;
    }

    public final int getFailedRetryTextColor() {
        return this.failedRetryTextColor;
    }

    public final LoadMoreStatus getStatus() {
        return this.status;
    }

    public final LoadMoreState copy(String failedRetryText, int progressBarColor, int failedRetryTextColor, LoadMoreStatus status) {
        Intrinsics.checkNotNullParameter(status, "status");
        return new LoadMoreState(failedRetryText, progressBarColor, failedRetryTextColor, status);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof LoadMoreState)) {
            return false;
        }
        LoadMoreState loadMoreState = (LoadMoreState) other;
        return Intrinsics.areEqual(this.failedRetryText, loadMoreState.failedRetryText) && this.progressBarColor == loadMoreState.progressBarColor && this.failedRetryTextColor == loadMoreState.failedRetryTextColor && this.status == loadMoreState.status;
    }

    public int hashCode() {
        String str = this.failedRetryText;
        return ((((((str == null ? 0 : str.hashCode()) * 31) + this.progressBarColor) * 31) + this.failedRetryTextColor) * 31) + this.status.hashCode();
    }

    public String toString() {
        return "LoadMoreState(failedRetryText=" + this.failedRetryText + ", progressBarColor=" + this.progressBarColor + ", failedRetryTextColor=" + this.failedRetryTextColor + ", status=" + this.status + ')';
    }

    public LoadMoreState(String str, int i, int i2, LoadMoreStatus loadMoreStatus) {
        Intrinsics.checkNotNullParameter(loadMoreStatus, "status");
        this.failedRetryText = str;
        this.progressBarColor = i;
        this.failedRetryTextColor = i2;
        this.status = loadMoreStatus;
    }

    public LoadMoreState(String str, int i, int i2, LoadMoreStatus loadMoreStatus, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this((i3 & 1) != 0 ? "" : str, (i3 & 2) != 0 ? 0 : i, (i3 & 4) != 0 ? 0 : i2, (i3 & 8) != 0 ? LoadMoreStatus.LOADING : loadMoreStatus);
    }

    public final String getFailedRetryText$zendesk_ui_ui_android() {
        return this.failedRetryText;
    }

    public final int getProgressBarColor$zendesk_ui_ui_android() {
        return this.progressBarColor;
    }

    public final int getFailedRetryTextColor$zendesk_ui_ui_android() {
        return this.failedRetryTextColor;
    }

    public final LoadMoreStatus getStatus$zendesk_ui_ui_android() {
        return this.status;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0006\u001a\u00020\u0003J\u000e\u0010\u0007\u001a\u00020\u00002\u0006\u0010\u0007\u001a\u00020\bJ\u0010\u0010\t\u001a\u00020\u00002\b\b\u0001\u0010\n\u001a\u00020\u000bJ\u0010\u0010\f\u001a\u00020\u00002\b\b\u0001\u0010\n\u001a\u00020\u000bJ\u000e\u0010\r\u001a\u00020\u00002\u0006\u0010\r\u001a\u00020\u000eR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u000f"}, d2 = {"Lzendesk/ui/android/common/loadmore/LoadMoreState$Builder;", "", ServerProtocol.DIALOG_PARAM_STATE, "Lzendesk/ui/android/common/loadmore/LoadMoreState;", "(Lzendesk/ui/android/common/loadmore/LoadMoreState;)V", "()V", "build", "failedRetryText", "", "failedRetryTextColor", TypedValues.Custom.S_COLOR, "", "progressBarColor", "status", "Lzendesk/ui/android/common/loadmore/LoadMoreState$LoadMoreStatus;", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Builder {
        public static final int $stable = 8;
        private LoadMoreState state;

        public Builder() {
            this.state = new LoadMoreState(null, 0, 0, null, 15, null);
        }

        public Builder(LoadMoreState loadMoreState) {
            this();
            Intrinsics.checkNotNullParameter(loadMoreState, ServerProtocol.DIALOG_PARAM_STATE);
            this.state = loadMoreState;
        }

        public final Builder status(LoadMoreStatus status) {
            Intrinsics.checkNotNullParameter(status, "status");
            this.state = LoadMoreState.copy$default(this.state, null, 0, 0, status, 7, null);
            return this;
        }

        public final Builder failedRetryText(String failedRetryText) {
            Intrinsics.checkNotNullParameter(failedRetryText, "failedRetryText");
            this.state = LoadMoreState.copy$default(this.state, failedRetryText, 0, 0, null, 14, null);
            return this;
        }

        public final Builder progressBarColor(int color) {
            this.state = LoadMoreState.copy$default(this.state, null, color, 0, null, 13, null);
            return this;
        }

        public final Builder failedRetryTextColor(int color) {
            this.state = LoadMoreState.copy$default(this.state, null, 0, color, null, 11, null);
            return this;
        }

        public final LoadMoreState getState() {
            return this.state;
        }
    }
}
