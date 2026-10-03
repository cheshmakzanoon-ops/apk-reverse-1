package zendesk.p009ui.android.common.connectionbanner;

import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.internal.ServerProtocol;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u000f\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\b\u0087\b\u0018\u00002\u00020\u0001:\u0002\u001c\u001dB/\b\u0000\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0003\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0003\u0010\u0006\u001a\u00020\u0005\u0012\b\b\u0003\u0010\u0007\u001a\u00020\u0005¢\u0006\u0002\u0010\bJ\t\u0010\u000f\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0010\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0011\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0012\u001a\u00020\u0005HÆ\u0003J1\u0010\u0013\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0003\u0010\u0004\u001a\u00020\u00052\b\b\u0003\u0010\u0006\u001a\u00020\u00052\b\b\u0003\u0010\u0007\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u0014\u001a\u00020\u00152\b\u0010\u0016\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0017\u001a\u00020\u0005HÖ\u0001J\u0006\u0010\u0018\u001a\u00020\u0019J\t\u0010\u001a\u001a\u00020\u001bHÖ\u0001R\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\nR\u0011\u0010\u0007\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\n¨\u0006\u001e"}, d2 = {"Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState;", "", "connectionState", "Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState$ConnectionState;", "labelColor", "", "backgroundColor", "successBackgroundColor", "(Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState$ConnectionState;III)V", "getBackgroundColor", "()I", "getConnectionState", "()Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState$ConnectionState;", "getLabelColor", "getSuccessBackgroundColor", "component1", "component2", "component3", "component4", "copy", "equals", "", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState$Builder;", "toString", "", "Builder", "ConnectionState", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class ConnectionBannerState {
    public static final int $stable = 0;
    private final int backgroundColor;
    private final ConnectionState connectionState;
    private final int labelColor;
    private final int successBackgroundColor;

    public ConnectionBannerState() {
        this(null, 0, 0, 0, 15, null);
    }

    public static ConnectionBannerState copy$default(ConnectionBannerState connectionBannerState, ConnectionState connectionState, int i, int i2, int i3, int i4, Object obj) {
        if ((i4 & 1) != 0) {
            connectionState = connectionBannerState.connectionState;
        }
        if ((i4 & 2) != 0) {
            i = connectionBannerState.labelColor;
        }
        if ((i4 & 4) != 0) {
            i2 = connectionBannerState.backgroundColor;
        }
        if ((i4 & 8) != 0) {
            i3 = connectionBannerState.successBackgroundColor;
        }
        return connectionBannerState.copy(connectionState, i, i2, i3);
    }

    public final ConnectionState getConnectionState() {
        return this.connectionState;
    }

    public final int getLabelColor() {
        return this.labelColor;
    }

    public final int getBackgroundColor() {
        return this.backgroundColor;
    }

    public final int getSuccessBackgroundColor() {
        return this.successBackgroundColor;
    }

    public final ConnectionBannerState copy(ConnectionState connectionState, int labelColor, int backgroundColor, int successBackgroundColor) {
        Intrinsics.checkNotNullParameter(connectionState, "connectionState");
        return new ConnectionBannerState(connectionState, labelColor, backgroundColor, successBackgroundColor);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ConnectionBannerState)) {
            return false;
        }
        ConnectionBannerState connectionBannerState = (ConnectionBannerState) other;
        return Intrinsics.areEqual(this.connectionState, connectionBannerState.connectionState) && this.labelColor == connectionBannerState.labelColor && this.backgroundColor == connectionBannerState.backgroundColor && this.successBackgroundColor == connectionBannerState.successBackgroundColor;
    }

    public int hashCode() {
        return (((((this.connectionState.hashCode() * 31) + this.labelColor) * 31) + this.backgroundColor) * 31) + this.successBackgroundColor;
    }

    public String toString() {
        return "ConnectionBannerState(connectionState=" + this.connectionState + ", labelColor=" + this.labelColor + ", backgroundColor=" + this.backgroundColor + ", successBackgroundColor=" + this.successBackgroundColor + ')';
    }

    public ConnectionBannerState(ConnectionState connectionState, int i, int i2, int i3) {
        Intrinsics.checkNotNullParameter(connectionState, "connectionState");
        this.connectionState = connectionState;
        this.labelColor = i;
        this.backgroundColor = i2;
        this.successBackgroundColor = i3;
    }

    public ConnectionBannerState(ConnectionState.Connected connected, int i, int i2, int i3, int i4, DefaultConstructorMarker defaultConstructorMarker) {
        this((i4 & 1) != 0 ? ConnectionState.Connected.INSTANCE : connected, (i4 & 2) != 0 ? 0 : i, (i4 & 4) != 0 ? 0 : i2, (i4 & 8) != 0 ? 0 : i3);
    }

    public final ConnectionState getConnectionState() {
        return this.connectionState;
    }

    public final int getLabelColor() {
        return this.labelColor;
    }

    public final int getBackgroundColor() {
        return this.backgroundColor;
    }

    public final int getSuccessBackgroundColor() {
        return this.successBackgroundColor;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0006\u001a\u00020\u0003J\u000e\u0010\u0007\u001a\u00020\u00002\u0006\u0010\u0007\u001a\u00020\bR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\t"}, d2 = {"Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState$Builder;", "", ServerProtocol.DIALOG_PARAM_STATE, "Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState;", "(Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState;)V", "()V", "build", "connectionState", "Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState$ConnectionState;", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Builder {
        public static final int $stable = 8;
        private ConnectionBannerState state;

        public Builder() {
            this.state = new ConnectionBannerState(null, 0, 0, 0, 15, null);
        }

        public Builder(ConnectionBannerState connectionBannerState) {
            this();
            Intrinsics.checkNotNullParameter(connectionBannerState, ServerProtocol.DIALOG_PARAM_STATE);
            this.state = connectionBannerState;
        }

        public final Builder connectionState(ConnectionState connectionState) {
            Intrinsics.checkNotNullParameter(connectionState, "connectionState");
            this.state = ConnectionBannerState.copy$default(this.state, connectionState, 0, 0, 0, 14, null);
            return this;
        }

        public final ConnectionBannerState getState() {
            return this.state;
        }
    }

    @Metadata(d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b7\u0018\u00002\u00020\u0001:\u0004\u0007\b\t\nB\u000f\b\u0004\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006\u0082\u0001\u0004\u000b\f\r\u000e¨\u0006\u000f"}, d2 = {"Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState$ConnectionState;", "", "stateValue", "", "(Ljava/lang/String;)V", "getStateValue", "()Ljava/lang/String;", "Connected", "Disconnected", "Reconnected", "Reconnecting", "Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState$ConnectionState$Connected;", "Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState$ConnectionState$Disconnected;", "Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState$ConnectionState$Reconnected;", "Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState$ConnectionState$Reconnecting;", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static abstract class ConnectionState {
        public static final int $stable = 0;
        private final String stateValue;

        public ConnectionState(String str, DefaultConstructorMarker defaultConstructorMarker) {
            this(str);
        }

        @Metadata(d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, d2 = {"Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState$ConnectionState$Reconnecting;", "Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState$ConnectionState;", "()V", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
        public static final class Reconnecting extends ConnectionState {
            public static final int $stable = 0;
            public static final Reconnecting INSTANCE = new Reconnecting();

            private Reconnecting() {
                super("Reconnecting", null);
            }
        }

        private ConnectionState(String str) {
            this.stateValue = str;
        }

        public final String getStateValue() {
            return this.stateValue;
        }

        @Metadata(d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, d2 = {"Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState$ConnectionState$Reconnected;", "Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState$ConnectionState;", "()V", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
        public static final class Reconnected extends ConnectionState {
            public static final int $stable = 0;
            public static final Reconnected INSTANCE = new Reconnected();

            private Reconnected() {
                super("Reconnected", null);
            }
        }

        @Metadata(d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, d2 = {"Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState$ConnectionState$Disconnected;", "Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState$ConnectionState;", "()V", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
        public static final class Disconnected extends ConnectionState {
            public static final int $stable = 0;
            public static final Disconnected INSTANCE = new Disconnected();

            private Disconnected() {
                super("Disconnected", null);
            }
        }

        @Metadata(d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, d2 = {"Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState$ConnectionState$Connected;", "Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState$ConnectionState;", "()V", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
        public static final class Connected extends ConnectionState {
            public static final int $stable = 0;
            public static final Connected INSTANCE = new Connected();

            private Connected() {
                super("Connected", null);
            }
        }
    }
}
