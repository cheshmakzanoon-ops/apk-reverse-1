package zendesk.p026ui.android.conversation.imagerviewer;

import android.net.Uri;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import net.aihelp.data.model.p005cs.ConversationMsg;
import okhttp3.internal.p011ws.WebSocketProtocol;

@Metadata(m17d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u001f\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0087\b\u0018\u00002\u00020\u0001:\u0001/B[\b\u0000\u0012\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\n\b\u0003\u0010\b\u001a\u0004\u0018\u00010\t\u0012\n\b\u0003\u0010\n\u001a\u0004\u0018\u00010\t\u0012\n\b\u0002\u0010\u000b\u001a\u0004\u0018\u00010\u0003¢\u0006\u0002\u0010\fJ\u0010\u0010\u0018\u001a\u0004\u0018\u00010\u0003HÀ\u0003¢\u0006\u0002\b\u0019J\u0010\u0010\u001a\u001a\u0004\u0018\u00010\u0003HÀ\u0003¢\u0006\u0002\b\u001bJ\u0010\u0010\u001c\u001a\u0004\u0018\u00010\u0003HÀ\u0003¢\u0006\u0002\b\u001dJ\u0010\u0010\u001e\u001a\u0004\u0018\u00010\u0007HÀ\u0003¢\u0006\u0002\b\u001fJ\u0012\u0010 \u001a\u0004\u0018\u00010\tHÀ\u0003¢\u0006\u0004\b!\u0010\u0013J\u0012\u0010\"\u001a\u0004\u0018\u00010\tHÀ\u0003¢\u0006\u0004\b#\u0010\u0013J\u0010\u0010$\u001a\u0004\u0018\u00010\u0003HÀ\u0003¢\u0006\u0002\b%Jb\u0010&\u001a\u00020\u00002\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u00072\n\b\u0003\u0010\b\u001a\u0004\u0018\u00010\t2\n\b\u0003\u0010\n\u001a\u0004\u0018\u00010\t2\n\b\u0002\u0010\u000b\u001a\u0004\u0018\u00010\u0003HÆ\u0001¢\u0006\u0002\u0010'J\u0013\u0010(\u001a\u00020)2\b\u0010*\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010+\u001a\u00020\tHÖ\u0001J\u0006\u0010,\u001a\u00020-J\t\u0010.\u001a\u00020\u0003HÖ\u0001R\u0016\u0010\u000b\u001a\u0004\u0018\u00010\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0016\u0010\u0005\u001a\u0004\u0018\u00010\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u000eR\u0016\u0010\u0006\u001a\u0004\u0018\u00010\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011R\u0018\u0010\n\u001a\u0004\u0018\u00010\tX\u0080\u0004¢\u0006\n\n\u0002\u0010\u0014\u001a\u0004\b\u0012\u0010\u0013R\u0016\u0010\u0004\u001a\u0004\u0018\u00010\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u000eR\u0018\u0010\b\u001a\u0004\u0018\u00010\tX\u0080\u0004¢\u0006\n\n\u0002\u0010\u0014\u001a\u0004\b\u0016\u0010\u0013R\u0016\u0010\u0002\u001a\u0004\u0018\u00010\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u000e¨\u00060"}, m18d2 = {"Lzendesk/ui/android/conversation/imagerviewer/ImageViewerState;", "", "uri", "", "title", "description", "logo", "Landroid/net/Uri;", "toolbarColor", "", "statusBarColor", "authorizationToken", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Landroid/net/Uri;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/String;)V", "getAuthorizationToken$zendesk_ui_ui_android", "()Ljava/lang/String;", "getDescription$zendesk_ui_ui_android", "getLogo$zendesk_ui_ui_android", "()Landroid/net/Uri;", "getStatusBarColor$zendesk_ui_ui_android", "()Ljava/lang/Integer;", "Ljava/lang/Integer;", "getTitle$zendesk_ui_ui_android", "getToolbarColor$zendesk_ui_ui_android", "getUri$zendesk_ui_ui_android", "component1", "component1$zendesk_ui_ui_android", "component2", "component2$zendesk_ui_ui_android", "component3", "component3$zendesk_ui_ui_android", "component4", "component4$zendesk_ui_ui_android", "component5", "component5$zendesk_ui_ui_android", "component6", "component6$zendesk_ui_ui_android", "component7", "component7$zendesk_ui_ui_android", "copy", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Landroid/net/Uri;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/String;)Lzendesk/ui/android/conversation/imagerviewer/ImageViewerState;", "equals", "", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/conversation/imagerviewer/ImageViewerState$Builder;", "toString", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ImageViewerState {
    public static final int $stable = 8;
    private final String authorizationToken;
    private final String description;
    private final Uri logo;
    private final Integer statusBarColor;
    private final String title;
    private final Integer toolbarColor;
    private final String uri;

    public ImageViewerState() {
        this(null, null, null, null, null, null, null, 127, null);
    }

    public static ImageViewerState copy$default(ImageViewerState imageViewerState, String str, String str2, String str3, Uri uri, Integer num, Integer num2, String str4, int i, Object obj) {
        if ((i & 1) != 0) {
            str = imageViewerState.uri;
        }
        if ((i & 2) != 0) {
            str2 = imageViewerState.title;
        }
        String str5 = str2;
        if ((i & 4) != 0) {
            str3 = imageViewerState.description;
        }
        String str6 = str3;
        if ((i & 8) != 0) {
            uri = imageViewerState.logo;
        }
        Uri uri2 = uri;
        if ((i & 16) != 0) {
            num = imageViewerState.toolbarColor;
        }
        Integer num3 = num;
        if ((i & 32) != 0) {
            num2 = imageViewerState.statusBarColor;
        }
        Integer num4 = num2;
        if ((i & 64) != 0) {
            str4 = imageViewerState.authorizationToken;
        }
        return imageViewerState.copy(str, str5, str6, uri2, num3, num4, str4);
    }

    public final String getUri() {
        return this.uri;
    }

    public final String getTitle() {
        return this.title;
    }

    public final String getDescription() {
        return this.description;
    }

    public final Uri getLogo() {
        return this.logo;
    }

    public final Integer getToolbarColor() {
        return this.toolbarColor;
    }

    public final Integer getStatusBarColor() {
        return this.statusBarColor;
    }

    public final String getAuthorizationToken() {
        return this.authorizationToken;
    }

    public final ImageViewerState copy(String uri, String title, String description, Uri logo, Integer toolbarColor, Integer statusBarColor, String authorizationToken) {
        return new ImageViewerState(uri, title, description, logo, toolbarColor, statusBarColor, authorizationToken);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ImageViewerState)) {
            return false;
        }
        ImageViewerState imageViewerState = (ImageViewerState) other;
        return Intrinsics.areEqual(this.uri, imageViewerState.uri) && Intrinsics.areEqual(this.title, imageViewerState.title) && Intrinsics.areEqual(this.description, imageViewerState.description) && Intrinsics.areEqual(this.logo, imageViewerState.logo) && Intrinsics.areEqual(this.toolbarColor, imageViewerState.toolbarColor) && Intrinsics.areEqual(this.statusBarColor, imageViewerState.statusBarColor) && Intrinsics.areEqual(this.authorizationToken, imageViewerState.authorizationToken);
    }

    public int hashCode() {
        String str = this.uri;
        int iHashCode = (str == null ? 0 : str.hashCode()) * 31;
        String str2 = this.title;
        int iHashCode2 = (iHashCode + (str2 == null ? 0 : str2.hashCode())) * 31;
        String str3 = this.description;
        int iHashCode3 = (iHashCode2 + (str3 == null ? 0 : str3.hashCode())) * 31;
        Uri uri = this.logo;
        int iHashCode4 = (iHashCode3 + (uri == null ? 0 : uri.hashCode())) * 31;
        Integer num = this.toolbarColor;
        int iHashCode5 = (iHashCode4 + (num == null ? 0 : num.hashCode())) * 31;
        Integer num2 = this.statusBarColor;
        int iHashCode6 = (iHashCode5 + (num2 == null ? 0 : num2.hashCode())) * 31;
        String str4 = this.authorizationToken;
        return iHashCode6 + (str4 != null ? str4.hashCode() : 0);
    }

    public String toString() {
        return "ImageViewerState(uri=" + this.uri + ", title=" + this.title + ", description=" + this.description + ", logo=" + this.logo + ", toolbarColor=" + this.toolbarColor + ", statusBarColor=" + this.statusBarColor + ", authorizationToken=" + this.authorizationToken + ')';
    }

    public ImageViewerState(String str, String str2, String str3, Uri uri, Integer num, Integer num2, String str4) {
        this.uri = str;
        this.title = str2;
        this.description = str3;
        this.logo = uri;
        this.toolbarColor = num;
        this.statusBarColor = num2;
        this.authorizationToken = str4;
    }

    public final String getUri$zendesk_ui_ui_android() {
        return this.uri;
    }

    public ImageViewerState(String str, String str2, String str3, Uri uri, Integer num, Integer num2, String str4, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? null : str, (i & 2) != 0 ? "" : str2, (i & 4) != 0 ? null : str3, (i & 8) != 0 ? null : uri, (i & 16) != 0 ? null : num, (i & 32) != 0 ? null : num2, (i & 64) != 0 ? null : str4);
    }

    public final String getTitle$zendesk_ui_ui_android() {
        return this.title;
    }

    public final String getDescription$zendesk_ui_ui_android() {
        return this.description;
    }

    public final Uri getLogo$zendesk_ui_ui_android() {
        return this.logo;
    }

    public final Integer getToolbarColor$zendesk_ui_ui_android() {
        return this.toolbarColor;
    }

    public final Integer getStatusBarColor$zendesk_ui_ui_android() {
        return this.statusBarColor;
    }

    public final String getAuthorizationToken$zendesk_ui_ui_android() {
        return this.authorizationToken;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0010\u0010\u0006\u001a\u00020\u00002\b\u0010\u0007\u001a\u0004\u0018\u00010\bJ\u0010\u0010\t\u001a\u00020\u00002\b\b\u0001\u0010\n\u001a\u00020\u000bJ\u0006\u0010\f\u001a\u00020\u0003J\u0010\u0010\r\u001a\u00020\u00002\b\u0010\r\u001a\u0004\u0018\u00010\bJ\u0010\u0010\u000e\u001a\u00020\u00002\b\u0010\u000e\u001a\u0004\u0018\u00010\u000fJ\u0010\u0010\u0010\u001a\u00020\u00002\b\b\u0001\u0010\u0010\u001a\u00020\u000bJ\u0010\u0010\u0011\u001a\u00020\u00002\b\u0010\u0011\u001a\u0004\u0018\u00010\bJ\u000e\u0010\u0012\u001a\u00020\u00002\u0006\u0010\u0012\u001a\u00020\bR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0013"}, m18d2 = {"Lzendesk/ui/android/conversation/imagerviewer/ImageViewerState$Builder;", "", "state", "Lzendesk/ui/android/conversation/imagerviewer/ImageViewerState;", "(Lzendesk/ui/android/conversation/imagerviewer/ImageViewerState;)V", "()V", "authorizationToken", "token", "", "backgroundColor", "color", "", "build", "description", "logo", "Landroid/net/Uri;", "statusBarColor", "title", "uri", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private ImageViewerState state;

        public Builder() {
            this.state = new ImageViewerState(null, null, null, null, null, null, null, 127, null);
        }

        public Builder(ImageViewerState state) {
            this();
            Intrinsics.checkNotNullParameter(state, "state");
            this.state = state;
        }

        public final Builder uri(String uri) {
            Intrinsics.checkNotNullParameter(uri, "uri");
            this.state = ImageViewerState.copy$default(this.state, uri, null, null, null, null, null, null, WebSocketProtocol.PAYLOAD_SHORT, null);
            return this;
        }

        public final Builder authorizationToken(String token) {
            this.state = ImageViewerState.copy$default(this.state, null, null, null, null, null, null, token, 63, null);
            return this;
        }

        public final Builder title(String title) {
            this.state = ImageViewerState.copy$default(this.state, null, title, null, null, null, null, null, 125, null);
            return this;
        }

        public final Builder description(String description) {
            this.state = ImageViewerState.copy$default(this.state, null, null, description, null, null, null, null, 123, null);
            return this;
        }

        public final Builder logo(Uri logo) {
            this.state = ImageViewerState.copy$default(this.state, null, null, null, logo, null, null, null, 119, null);
            return this;
        }

        public final Builder backgroundColor(int color) {
            this.state = ImageViewerState.copy$default(this.state, null, null, null, null, Integer.valueOf(color), null, null, ConversationMsg.TYPE_ADMIN_TYPING, null);
            return this;
        }

        public final Builder statusBarColor(int statusBarColor) {
            this.state = ImageViewerState.copy$default(this.state, null, null, null, null, null, Integer.valueOf(statusBarColor), null, 95, null);
            return this;
        }

        public final ImageViewerState getState() {
            return this.state;
        }
    }
}
