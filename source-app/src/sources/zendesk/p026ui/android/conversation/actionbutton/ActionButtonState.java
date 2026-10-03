package zendesk.p026ui.android.conversation.actionbutton;

import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.p017ui.android.internal.model.MessageActionSize;

@Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b+\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0087\b\u0018\u00002\u00020\u0001:\u0001<Bw\b\u0000\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0003\u0012\b\b\u0002\u0010\u0005\u001a\u00020\u0006\u0012\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0003\u0010\b\u001a\u0004\u0018\u00010\t\u0012\n\b\u0003\u0010\n\u001a\u0004\u0018\u00010\t\u0012\n\b\u0002\u0010\u000b\u001a\u0004\u0018\u00010\u0003\u0012\b\b\u0002\u0010\f\u001a\u00020\u0006\u0012\b\b\u0002\u0010\r\u001a\u00020\u000e\u0012\n\b\u0003\u0010\u000f\u001a\u0004\u0018\u00010\t¢\u0006\u0002\u0010\u0010J\u000e\u0010 \u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b!J\u0012\u0010\"\u001a\u0004\u0018\u00010\tHÀ\u0003¢\u0006\u0004\b#\u0010\u0014J\u0010\u0010$\u001a\u0004\u0018\u00010\u0003HÀ\u0003¢\u0006\u0002\b%J\u000e\u0010&\u001a\u00020\u0006HÀ\u0003¢\u0006\u0002\b'J\u0010\u0010(\u001a\u0004\u0018\u00010\u0003HÀ\u0003¢\u0006\u0002\b)J\u0012\u0010*\u001a\u0004\u0018\u00010\tHÀ\u0003¢\u0006\u0004\b+\u0010\u0014J\u0012\u0010,\u001a\u0004\u0018\u00010\tHÀ\u0003¢\u0006\u0004\b-\u0010\u0014J\u0010\u0010.\u001a\u0004\u0018\u00010\u0003HÀ\u0003¢\u0006\u0002\b/J\u000e\u00100\u001a\u00020\u0006HÀ\u0003¢\u0006\u0002\b1J\u000e\u00102\u001a\u00020\u000eHÀ\u0003¢\u0006\u0002\b3J~\u00104\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00062\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\u00032\n\b\u0003\u0010\b\u001a\u0004\u0018\u00010\t2\n\b\u0003\u0010\n\u001a\u0004\u0018\u00010\t2\n\b\u0002\u0010\u000b\u001a\u0004\u0018\u00010\u00032\b\b\u0002\u0010\f\u001a\u00020\u00062\b\b\u0002\u0010\r\u001a\u00020\u000e2\n\b\u0003\u0010\u000f\u001a\u0004\u0018\u00010\tHÆ\u0001¢\u0006\u0002\u00105J\u0013\u00106\u001a\u00020\u00062\b\u00107\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u00108\u001a\u00020\tHÖ\u0001J\u0006\u00109\u001a\u00020:J\t\u0010;\u001a\u00020\u0003HÖ\u0001R\u0016\u0010\u000b\u001a\u0004\u0018\u00010\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012R\u0018\u0010\b\u001a\u0004\u0018\u00010\tX\u0080\u0004¢\u0006\n\n\u0002\u0010\u0015\u001a\u0004\b\u0013\u0010\u0014R\u0014\u0010\f\u001a\u00020\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0017R\u0014\u0010\u0005\u001a\u00020\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0017R\u0018\u0010\u000f\u001a\u0004\u0018\u00010\tX\u0080\u0004¢\u0006\n\n\u0002\u0010\u0015\u001a\u0004\b\u0019\u0010\u0014R\u0014\u0010\r\u001a\u00020\u000eX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u001bR\u0014\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u0012R\u0018\u0010\n\u001a\u0004\u0018\u00010\tX\u0080\u0004¢\u0006\n\n\u0002\u0010\u0015\u001a\u0004\b\u001d\u0010\u0014R\u0016\u0010\u0004\u001a\u0004\u0018\u00010\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001e\u0010\u0012R\u0016\u0010\u0007\u001a\u0004\u0018\u00010\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010\u0012¨\u0006="}, m18d2 = {"Lzendesk/ui/android/conversation/actionbutton/ActionButtonState;", "", "text", "", "uri", "isSupported", "", "urlSource", "backgroundColor", "", "textColor", "actionId", "isLoading", "size", "Lzendesk/core/ui/android/internal/model/MessageActionSize;", "loadingColor", "(Ljava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/String;ZLzendesk/core/ui/android/internal/model/MessageActionSize;Ljava/lang/Integer;)V", "getActionId$zendesk_ui_ui_android", "()Ljava/lang/String;", "getBackgroundColor$zendesk_ui_ui_android", "()Ljava/lang/Integer;", "Ljava/lang/Integer;", "isLoading$zendesk_ui_ui_android", "()Z", "isSupported$zendesk_ui_ui_android", "getLoadingColor$zendesk_ui_ui_android", "getSize$zendesk_ui_ui_android", "()Lzendesk/core/ui/android/internal/model/MessageActionSize;", "getText$zendesk_ui_ui_android", "getTextColor$zendesk_ui_ui_android", "getUri$zendesk_ui_ui_android", "getUrlSource$zendesk_ui_ui_android", "component1", "component1$zendesk_ui_ui_android", "component10", "component10$zendesk_ui_ui_android", "component2", "component2$zendesk_ui_ui_android", "component3", "component3$zendesk_ui_ui_android", "component4", "component4$zendesk_ui_ui_android", "component5", "component5$zendesk_ui_ui_android", "component6", "component6$zendesk_ui_ui_android", "component7", "component7$zendesk_ui_ui_android", "component8", "component8$zendesk_ui_ui_android", "component9", "component9$zendesk_ui_ui_android", "copy", "(Ljava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/String;ZLzendesk/core/ui/android/internal/model/MessageActionSize;Ljava/lang/Integer;)Lzendesk/ui/android/conversation/actionbutton/ActionButtonState;", "equals", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/conversation/actionbutton/ActionButtonState$Builder;", "toString", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ActionButtonState {
    public static final int $stable = 0;
    private final String actionId;
    private final Integer backgroundColor;
    private final boolean isLoading;
    private final boolean isSupported;
    private final Integer loadingColor;
    private final MessageActionSize size;
    private final String text;
    private final Integer textColor;
    private final String uri;
    private final String urlSource;

    public ActionButtonState() {
        this(null, null, false, null, null, null, null, false, null, null, 1023, null);
    }

    public static ActionButtonState copy$default(ActionButtonState actionButtonState, String str, String str2, boolean z, String str3, Integer num, Integer num2, String str4, boolean z2, MessageActionSize messageActionSize, Integer num3, int i, Object obj) {
        return actionButtonState.copy((i & 1) != 0 ? actionButtonState.text : str, (i & 2) != 0 ? actionButtonState.uri : str2, (i & 4) != 0 ? actionButtonState.isSupported : z, (i & 8) != 0 ? actionButtonState.urlSource : str3, (i & 16) != 0 ? actionButtonState.backgroundColor : num, (i & 32) != 0 ? actionButtonState.textColor : num2, (i & 64) != 0 ? actionButtonState.actionId : str4, (i & 128) != 0 ? actionButtonState.isLoading : z2, (i & 256) != 0 ? actionButtonState.size : messageActionSize, (i & 512) != 0 ? actionButtonState.loadingColor : num3);
    }

    public final String getText() {
        return this.text;
    }

    public final Integer getLoadingColor() {
        return this.loadingColor;
    }

    public final String getUri() {
        return this.uri;
    }

    public final boolean getIsSupported() {
        return this.isSupported;
    }

    public final String getUrlSource() {
        return this.urlSource;
    }

    public final Integer getBackgroundColor() {
        return this.backgroundColor;
    }

    public final Integer getTextColor() {
        return this.textColor;
    }

    public final String getActionId() {
        return this.actionId;
    }

    public final boolean getIsLoading() {
        return this.isLoading;
    }

    public final MessageActionSize getSize() {
        return this.size;
    }

    public final ActionButtonState copy(String text, String uri, boolean isSupported, String urlSource, Integer backgroundColor, Integer textColor, String actionId, boolean isLoading, MessageActionSize size, Integer loadingColor) {
        Intrinsics.checkNotNullParameter(text, "text");
        Intrinsics.checkNotNullParameter(size, "size");
        return new ActionButtonState(text, uri, isSupported, urlSource, backgroundColor, textColor, actionId, isLoading, size, loadingColor);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ActionButtonState)) {
            return false;
        }
        ActionButtonState actionButtonState = (ActionButtonState) other;
        return Intrinsics.areEqual(this.text, actionButtonState.text) && Intrinsics.areEqual(this.uri, actionButtonState.uri) && this.isSupported == actionButtonState.isSupported && Intrinsics.areEqual(this.urlSource, actionButtonState.urlSource) && Intrinsics.areEqual(this.backgroundColor, actionButtonState.backgroundColor) && Intrinsics.areEqual(this.textColor, actionButtonState.textColor) && Intrinsics.areEqual(this.actionId, actionButtonState.actionId) && this.isLoading == actionButtonState.isLoading && this.size == actionButtonState.size && Intrinsics.areEqual(this.loadingColor, actionButtonState.loadingColor);
    }

    public int hashCode() {
        int iHashCode = this.text.hashCode() * 31;
        String str = this.uri;
        int iHashCode2 = (((iHashCode + (str == null ? 0 : str.hashCode())) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.isSupported)) * 31;
        String str2 = this.urlSource;
        int iHashCode3 = (iHashCode2 + (str2 == null ? 0 : str2.hashCode())) * 31;
        Integer num = this.backgroundColor;
        int iHashCode4 = (iHashCode3 + (num == null ? 0 : num.hashCode())) * 31;
        Integer num2 = this.textColor;
        int iHashCode5 = (iHashCode4 + (num2 == null ? 0 : num2.hashCode())) * 31;
        String str3 = this.actionId;
        int iHashCode6 = (((((iHashCode5 + (str3 == null ? 0 : str3.hashCode())) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.isLoading)) * 31) + this.size.hashCode()) * 31;
        Integer num3 = this.loadingColor;
        return iHashCode6 + (num3 != null ? num3.hashCode() : 0);
    }

    public String toString() {
        return "ActionButtonState(text=" + this.text + ", uri=" + this.uri + ", isSupported=" + this.isSupported + ", urlSource=" + this.urlSource + ", backgroundColor=" + this.backgroundColor + ", textColor=" + this.textColor + ", actionId=" + this.actionId + ", isLoading=" + this.isLoading + ", size=" + this.size + ", loadingColor=" + this.loadingColor + ')';
    }

    public ActionButtonState(String text, String str, boolean z, String str2, Integer num, Integer num2, String str3, boolean z2, MessageActionSize size, Integer num3) {
        Intrinsics.checkNotNullParameter(text, "text");
        Intrinsics.checkNotNullParameter(size, "size");
        this.text = text;
        this.uri = str;
        this.isSupported = z;
        this.urlSource = str2;
        this.backgroundColor = num;
        this.textColor = num2;
        this.actionId = str3;
        this.isLoading = z2;
        this.size = size;
        this.loadingColor = num3;
    }

    public ActionButtonState(String str, String str2, boolean z, String str3, Integer num, Integer num2, String str4, boolean z2, MessageActionSize messageActionSize, Integer num3, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? "" : str, (i & 2) != 0 ? null : str2, (i & 4) != 0 ? true : z, (i & 8) != 0 ? null : str3, (i & 16) != 0 ? null : num, (i & 32) != 0 ? null : num2, (i & 64) != 0 ? null : str4, (i & 128) != 0 ? false : z2, (i & 256) != 0 ? MessageActionSize.FULL : messageActionSize, (i & 512) == 0 ? num3 : null);
    }

    public final String getText$zendesk_ui_ui_android() {
        return this.text;
    }

    public final String getUri$zendesk_ui_ui_android() {
        return this.uri;
    }

    public final boolean isSupported$zendesk_ui_ui_android() {
        return this.isSupported;
    }

    public final String getUrlSource$zendesk_ui_ui_android() {
        return this.urlSource;
    }

    public final Integer getBackgroundColor$zendesk_ui_ui_android() {
        return this.backgroundColor;
    }

    public final Integer getTextColor$zendesk_ui_ui_android() {
        return this.textColor;
    }

    public final String getActionId$zendesk_ui_ui_android() {
        return this.actionId;
    }

    public final boolean isLoading$zendesk_ui_ui_android() {
        return this.isLoading;
    }

    public final MessageActionSize getSize$zendesk_ui_ui_android() {
        return this.size;
    }

    public final Integer getLoadingColor$zendesk_ui_ui_android() {
        return this.loadingColor;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u000e\u0010\u0006\u001a\u00020\u00002\u0006\u0010\u0006\u001a\u00020\u0007J\u0010\u0010\b\u001a\u00020\u00002\b\b\u0001\u0010\t\u001a\u00020\nJ\u0006\u0010\u000b\u001a\u00020\u0003J\u000e\u0010\f\u001a\u00020\u00002\u0006\u0010\f\u001a\u00020\rJ\u0010\u0010\u000e\u001a\u00020\u00002\b\b\u0001\u0010\t\u001a\u00020\nJ\u000e\u0010\u000f\u001a\u00020\u00002\u0006\u0010\u000f\u001a\u00020\u0010J\u000e\u0010\u0011\u001a\u00020\u00002\u0006\u0010\u0011\u001a\u00020\u0007J\u000e\u0010\u0012\u001a\u00020\u00002\u0006\u0010\u0012\u001a\u00020\u0007R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0013"}, m18d2 = {"Lzendesk/ui/android/conversation/actionbutton/ActionButtonState$Builder;", "", "state", "Lzendesk/ui/android/conversation/actionbutton/ActionButtonState;", "(Lzendesk/ui/android/conversation/actionbutton/ActionButtonState;)V", "()V", "actionId", "", "backgroundColor", "color", "", "build", "isLoading", "", "loadingColor", "size", "Lzendesk/core/ui/android/internal/model/MessageActionSize;", "text", "uri", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private ActionButtonState state;

        public Builder() {
            this.state = new ActionButtonState(null, null, false, null, null, null, null, false, null, null, 1023, null);
        }

        public Builder(ActionButtonState state) {
            this();
            Intrinsics.checkNotNullParameter(state, "state");
            this.state = state;
        }

        public final Builder text(String text) {
            Intrinsics.checkNotNullParameter(text, "text");
            this.state = ActionButtonState.copy$default(this.state, text, null, false, null, null, null, null, false, null, null, 1022, null);
            return this;
        }

        public final Builder uri(String uri) {
            Intrinsics.checkNotNullParameter(uri, "uri");
            this.state = ActionButtonState.copy$default(this.state, null, uri, false, null, null, null, null, false, null, null, 1021, null);
            return this;
        }

        public final Builder backgroundColor(int color) {
            this.state = ActionButtonState.copy$default(this.state, null, null, false, null, Integer.valueOf(color), null, null, false, null, null, 1007, null);
            return this;
        }

        public final Builder actionId(String actionId) {
            Intrinsics.checkNotNullParameter(actionId, "actionId");
            this.state = ActionButtonState.copy$default(this.state, null, null, false, null, null, null, actionId, false, null, null, 959, null);
            return this;
        }

        public final Builder isLoading(boolean isLoading) {
            this.state = ActionButtonState.copy$default(this.state, null, null, false, null, null, null, null, isLoading, null, null, 895, null);
            return this;
        }

        public final Builder loadingColor(int color) {
            this.state = ActionButtonState.copy$default(this.state, null, null, false, null, null, null, null, false, null, Integer.valueOf(color), 511, null);
            return this;
        }

        public final Builder size(MessageActionSize size) {
            Intrinsics.checkNotNullParameter(size, "size");
            this.state = ActionButtonState.copy$default(this.state, null, null, false, null, null, null, null, false, size, null, 767, null);
            return this;
        }

        public final ActionButtonState getState() {
            return this.state;
        }
    }
}
