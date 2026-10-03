package zendesk.p026ui.android.conversation.imagecell;

import android.net.Uri;
import java.util.List;
import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import okhttp3.internal.http2.Settings;
import okio.Utf8;
import zendesk.p026ui.android.conversation.actionbutton.ActionButton;

@Metadata(m17d1 = {"\u0000D\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b=\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0087\b\u0018\u00002\u00020\u0001:\u0001WB»\u0001\b\u0000\u0012\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u0006\u0012\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\u0006\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t\u0012\u0010\b\u0002\u0010\u000b\u001a\n\u0012\u0004\u0012\u00020\r\u0018\u00010\f\u0012\b\b\u0003\u0010\u000e\u001a\u00020\u000f\u0012\b\b\u0003\u0010\u0010\u001a\u00020\u000f\u0012\b\b\u0003\u0010\u0011\u001a\u00020\u000f\u0012\b\b\u0003\u0010\u0012\u001a\u00020\u000f\u0012\b\b\u0003\u0010\u0013\u001a\u00020\u000f\u0012\b\b\u0003\u0010\u0014\u001a\u00020\u000f\u0012\n\b\u0002\u0010\u0015\u001a\u0004\u0018\u00010\u0006\u0012\b\b\u0002\u0010\u0016\u001a\u00020\u0017\u0012\n\b\u0002\u0010\u0018\u001a\u0004\u0018\u00010\u0006¢\u0006\u0002\u0010\u0019J\u0010\u00100\u001a\u0004\u0018\u00010\u0003HÀ\u0003¢\u0006\u0002\b1J\u000e\u00102\u001a\u00020\u000fHÀ\u0003¢\u0006\u0002\b3J\u000e\u00104\u001a\u00020\u000fHÀ\u0003¢\u0006\u0002\b5J\u000e\u00106\u001a\u00020\u000fHÀ\u0003¢\u0006\u0002\b7J\u000e\u00108\u001a\u00020\u000fHÀ\u0003¢\u0006\u0002\b9J\u0010\u0010:\u001a\u0004\u0018\u00010\u0006HÀ\u0003¢\u0006\u0002\b;J\u000e\u0010<\u001a\u00020\u0017HÀ\u0003¢\u0006\u0002\b=J\u0010\u0010>\u001a\u0004\u0018\u00010\u0006HÀ\u0003¢\u0006\u0002\b?J\u0010\u0010@\u001a\u0004\u0018\u00010\u0003HÀ\u0003¢\u0006\u0002\bAJ\u0010\u0010B\u001a\u0004\u0018\u00010\u0006HÀ\u0003¢\u0006\u0002\bCJ\u0010\u0010D\u001a\u0004\u0018\u00010\u0006HÀ\u0003¢\u0006\u0002\bEJ\u000e\u0010F\u001a\u00020\tHÀ\u0003¢\u0006\u0002\bGJ\u000e\u0010H\u001a\u00020\tHÀ\u0003¢\u0006\u0002\bIJ\u0016\u0010J\u001a\n\u0012\u0004\u0012\u00020\r\u0018\u00010\fHÀ\u0003¢\u0006\u0002\bKJ\u000e\u0010L\u001a\u00020\u000fHÀ\u0003¢\u0006\u0002\bMJ\u000e\u0010N\u001a\u00020\u000fHÀ\u0003¢\u0006\u0002\bOJ½\u0001\u0010P\u001a\u00020\u00002\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u00062\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\u00062\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\t2\u0010\b\u0002\u0010\u000b\u001a\n\u0012\u0004\u0012\u00020\r\u0018\u00010\f2\b\b\u0003\u0010\u000e\u001a\u00020\u000f2\b\b\u0003\u0010\u0010\u001a\u00020\u000f2\b\b\u0003\u0010\u0011\u001a\u00020\u000f2\b\b\u0003\u0010\u0012\u001a\u00020\u000f2\b\b\u0003\u0010\u0013\u001a\u00020\u000f2\b\b\u0003\u0010\u0014\u001a\u00020\u000f2\n\b\u0002\u0010\u0015\u001a\u0004\u0018\u00010\u00062\b\b\u0002\u0010\u0016\u001a\u00020\u00172\n\b\u0002\u0010\u0018\u001a\u0004\u0018\u00010\u0006HÆ\u0001J\u0013\u0010Q\u001a\u00020\t2\b\u0010R\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010S\u001a\u00020\u000fHÖ\u0001J\u0006\u0010T\u001a\u00020UJ\t\u0010V\u001a\u00020\u0006HÖ\u0001R\u0014\u0010\u0013\u001a\u00020\u000fX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u001bR\u0014\u0010\u0014\u001a\u00020\u000fX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u001bR\u001c\u0010\u000b\u001a\n\u0012\u0004\u0012\u00020\r\u0018\u00010\fX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u001eR\u0016\u0010\u0018\u001a\u0004\u0018\u00010\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010 R\u0014\u0010\u0012\u001a\u00020\u000fX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b!\u0010\u001bR\u0014\u0010\u0011\u001a\u00020\u000fX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\"\u0010\u001bR\u0014\u0010\u0010\u001a\u00020\u000fX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b#\u0010\u001bR\u0016\u0010\u0015\u001a\u0004\u0018\u00010\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b$\u0010 R\u0014\u0010\u0016\u001a\u00020\u0017X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b%\u0010&R\u0016\u0010\u0005\u001a\u0004\u0018\u00010\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b'\u0010 R\u0014\u0010\b\u001a\u00020\tX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b(\u0010)R\u0014\u0010\n\u001a\u00020\tX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b*\u0010)R\u0016\u0010\u0004\u001a\u0004\u0018\u00010\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b+\u0010,R\u0016\u0010\u0007\u001a\u0004\u0018\u00010\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b-\u0010 R\u0014\u0010\u000e\u001a\u00020\u000fX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b.\u0010\u001bR\u0016\u0010\u0002\u001a\u0004\u0018\u00010\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b/\u0010,¨\u0006X"}, m18d2 = {"Lzendesk/ui/android/conversation/imagecell/ImageCellState;", "", "uri", "Landroid/net/Uri;", "localUri", "imageType", "", "messageText", "isError", "", "isPending", "actions", "", "Lzendesk/ui/android/conversation/actionbutton/ActionButton;", "textColor", "", "errorColor", "errorBackgroundColor", "backgroundColor", "actionColor", "actionTextColor", "errorText", "imageCellDirection", "Lzendesk/ui/android/conversation/imagecell/ImageCellDirection;", "authorizationToken", "(Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Ljava/lang/String;ZZLjava/util/List;IIIIIILjava/lang/String;Lzendesk/ui/android/conversation/imagecell/ImageCellDirection;Ljava/lang/String;)V", "getActionColor$zendesk_ui_ui_android", "()I", "getActionTextColor$zendesk_ui_ui_android", "getActions$zendesk_ui_ui_android", "()Ljava/util/List;", "getAuthorizationToken$zendesk_ui_ui_android", "()Ljava/lang/String;", "getBackgroundColor$zendesk_ui_ui_android", "getErrorBackgroundColor$zendesk_ui_ui_android", "getErrorColor$zendesk_ui_ui_android", "getErrorText$zendesk_ui_ui_android", "getImageCellDirection$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/imagecell/ImageCellDirection;", "getImageType$zendesk_ui_ui_android", "isError$zendesk_ui_ui_android", "()Z", "isPending$zendesk_ui_ui_android", "getLocalUri$zendesk_ui_ui_android", "()Landroid/net/Uri;", "getMessageText$zendesk_ui_ui_android", "getTextColor$zendesk_ui_ui_android", "getUri$zendesk_ui_ui_android", "component1", "component1$zendesk_ui_ui_android", "component10", "component10$zendesk_ui_ui_android", "component11", "component11$zendesk_ui_ui_android", "component12", "component12$zendesk_ui_ui_android", "component13", "component13$zendesk_ui_ui_android", "component14", "component14$zendesk_ui_ui_android", "component15", "component15$zendesk_ui_ui_android", "component16", "component16$zendesk_ui_ui_android", "component2", "component2$zendesk_ui_ui_android", "component3", "component3$zendesk_ui_ui_android", "component4", "component4$zendesk_ui_ui_android", "component5", "component5$zendesk_ui_ui_android", "component6", "component6$zendesk_ui_ui_android", "component7", "component7$zendesk_ui_ui_android", "component8", "component8$zendesk_ui_ui_android", "component9", "component9$zendesk_ui_ui_android", "copy", "equals", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/conversation/imagecell/ImageCellState$Builder;", "toString", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ImageCellState {
    public static final int $stable = 8;
    private final int actionColor;
    private final int actionTextColor;
    private final List<ActionButton> actions;
    private final String authorizationToken;
    private final int backgroundColor;
    private final int errorBackgroundColor;
    private final int errorColor;
    private final String errorText;
    private final ImageCellDirection imageCellDirection;
    private final String imageType;
    private final boolean isError;
    private final boolean isPending;
    private final Uri localUri;
    private final String messageText;
    private final int textColor;
    private final Uri uri;

    public ImageCellState() {
        this(null, null, null, null, false, false, null, 0, 0, 0, 0, 0, 0, null, null, null, Settings.DEFAULT_INITIAL_WINDOW_SIZE, null);
    }

    public static ImageCellState copy$default(ImageCellState imageCellState, Uri uri, Uri uri2, String str, String str2, boolean z, boolean z2, List list, int i, int i2, int i3, int i4, int i5, int i6, String str3, ImageCellDirection imageCellDirection, String str4, int i7, Object obj) {
        return imageCellState.copy((i7 & 1) != 0 ? imageCellState.uri : uri, (i7 & 2) != 0 ? imageCellState.localUri : uri2, (i7 & 4) != 0 ? imageCellState.imageType : str, (i7 & 8) != 0 ? imageCellState.messageText : str2, (i7 & 16) != 0 ? imageCellState.isError : z, (i7 & 32) != 0 ? imageCellState.isPending : z2, (i7 & 64) != 0 ? imageCellState.actions : list, (i7 & 128) != 0 ? imageCellState.textColor : i, (i7 & 256) != 0 ? imageCellState.errorColor : i2, (i7 & 512) != 0 ? imageCellState.errorBackgroundColor : i3, (i7 & 1024) != 0 ? imageCellState.backgroundColor : i4, (i7 & 2048) != 0 ? imageCellState.actionColor : i5, (i7 & 4096) != 0 ? imageCellState.actionTextColor : i6, (i7 & 8192) != 0 ? imageCellState.errorText : str3, (i7 & 16384) != 0 ? imageCellState.imageCellDirection : imageCellDirection, (i7 & 32768) != 0 ? imageCellState.authorizationToken : str4);
    }

    public final Uri getUri() {
        return this.uri;
    }

    public final int getErrorBackgroundColor() {
        return this.errorBackgroundColor;
    }

    public final int getBackgroundColor() {
        return this.backgroundColor;
    }

    public final int getActionColor() {
        return this.actionColor;
    }

    public final int getActionTextColor() {
        return this.actionTextColor;
    }

    public final String getErrorText() {
        return this.errorText;
    }

    public final ImageCellDirection getImageCellDirection() {
        return this.imageCellDirection;
    }

    public final String getAuthorizationToken() {
        return this.authorizationToken;
    }

    public final Uri getLocalUri() {
        return this.localUri;
    }

    public final String getImageType() {
        return this.imageType;
    }

    public final String getMessageText() {
        return this.messageText;
    }

    public final boolean getIsError() {
        return this.isError;
    }

    public final boolean getIsPending() {
        return this.isPending;
    }

    public final List<ActionButton> component7$zendesk_ui_ui_android() {
        return this.actions;
    }

    public final int getTextColor() {
        return this.textColor;
    }

    public final int getErrorColor() {
        return this.errorColor;
    }

    public final ImageCellState copy(Uri uri, Uri localUri, String imageType, String messageText, boolean isError, boolean isPending, List<ActionButton> actions, int textColor, int errorColor, int errorBackgroundColor, int backgroundColor, int actionColor, int actionTextColor, String errorText, ImageCellDirection imageCellDirection, String authorizationToken) {
        Intrinsics.checkNotNullParameter(imageCellDirection, "imageCellDirection");
        return new ImageCellState(uri, localUri, imageType, messageText, isError, isPending, actions, textColor, errorColor, errorBackgroundColor, backgroundColor, actionColor, actionTextColor, errorText, imageCellDirection, authorizationToken);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ImageCellState)) {
            return false;
        }
        ImageCellState imageCellState = (ImageCellState) other;
        return Intrinsics.areEqual(this.uri, imageCellState.uri) && Intrinsics.areEqual(this.localUri, imageCellState.localUri) && Intrinsics.areEqual(this.imageType, imageCellState.imageType) && Intrinsics.areEqual(this.messageText, imageCellState.messageText) && this.isError == imageCellState.isError && this.isPending == imageCellState.isPending && Intrinsics.areEqual(this.actions, imageCellState.actions) && this.textColor == imageCellState.textColor && this.errorColor == imageCellState.errorColor && this.errorBackgroundColor == imageCellState.errorBackgroundColor && this.backgroundColor == imageCellState.backgroundColor && this.actionColor == imageCellState.actionColor && this.actionTextColor == imageCellState.actionTextColor && Intrinsics.areEqual(this.errorText, imageCellState.errorText) && this.imageCellDirection == imageCellState.imageCellDirection && Intrinsics.areEqual(this.authorizationToken, imageCellState.authorizationToken);
    }

    public int hashCode() {
        Uri uri = this.uri;
        int iHashCode = (uri == null ? 0 : uri.hashCode()) * 31;
        Uri uri2 = this.localUri;
        int iHashCode2 = (iHashCode + (uri2 == null ? 0 : uri2.hashCode())) * 31;
        String str = this.imageType;
        int iHashCode3 = (iHashCode2 + (str == null ? 0 : str.hashCode())) * 31;
        String str2 = this.messageText;
        int iHashCode4 = (((((iHashCode3 + (str2 == null ? 0 : str2.hashCode())) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.isError)) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.isPending)) * 31;
        List<ActionButton> list = this.actions;
        int iHashCode5 = (((((((((((((iHashCode4 + (list == null ? 0 : list.hashCode())) * 31) + this.textColor) * 31) + this.errorColor) * 31) + this.errorBackgroundColor) * 31) + this.backgroundColor) * 31) + this.actionColor) * 31) + this.actionTextColor) * 31;
        String str3 = this.errorText;
        int iHashCode6 = (((iHashCode5 + (str3 == null ? 0 : str3.hashCode())) * 31) + this.imageCellDirection.hashCode()) * 31;
        String str4 = this.authorizationToken;
        return iHashCode6 + (str4 != null ? str4.hashCode() : 0);
    }

    public String toString() {
        return "ImageCellState(uri=" + this.uri + ", localUri=" + this.localUri + ", imageType=" + this.imageType + ", messageText=" + this.messageText + ", isError=" + this.isError + ", isPending=" + this.isPending + ", actions=" + this.actions + ", textColor=" + this.textColor + ", errorColor=" + this.errorColor + ", errorBackgroundColor=" + this.errorBackgroundColor + ", backgroundColor=" + this.backgroundColor + ", actionColor=" + this.actionColor + ", actionTextColor=" + this.actionTextColor + ", errorText=" + this.errorText + ", imageCellDirection=" + this.imageCellDirection + ", authorizationToken=" + this.authorizationToken + ')';
    }

    public ImageCellState(Uri uri, Uri uri2, String str, String str2, boolean z, boolean z2, List<ActionButton> list, int i, int i2, int i3, int i4, int i5, int i6, String str3, ImageCellDirection imageCellDirection, String str4) {
        Intrinsics.checkNotNullParameter(imageCellDirection, "imageCellDirection");
        this.uri = uri;
        this.localUri = uri2;
        this.imageType = str;
        this.messageText = str2;
        this.isError = z;
        this.isPending = z2;
        this.actions = list;
        this.textColor = i;
        this.errorColor = i2;
        this.errorBackgroundColor = i3;
        this.backgroundColor = i4;
        this.actionColor = i5;
        this.actionTextColor = i6;
        this.errorText = str3;
        this.imageCellDirection = imageCellDirection;
        this.authorizationToken = str4;
    }

    public ImageCellState(Uri uri, Uri uri2, String str, String str2, boolean z, boolean z2, List list, int i, int i2, int i3, int i4, int i5, int i6, String str3, ImageCellDirection imageCellDirection, String str4, int i7, DefaultConstructorMarker defaultConstructorMarker) {
        this((i7 & 1) != 0 ? null : uri, (i7 & 2) != 0 ? null : uri2, (i7 & 4) != 0 ? null : str, (i7 & 8) != 0 ? "" : str2, (i7 & 16) != 0 ? false : z, (i7 & 32) != 0 ? false : z2, (i7 & 64) != 0 ? null : list, (i7 & 128) != 0 ? 0 : i, (i7 & 256) != 0 ? 0 : i2, (i7 & 512) != 0 ? 0 : i3, (i7 & 1024) != 0 ? 0 : i4, (i7 & 2048) != 0 ? 0 : i5, (i7 & 4096) == 0 ? i6 : 0, (i7 & 8192) == 0 ? str3 : "", (i7 & 16384) != 0 ? ImageCellDirection.INBOUND_SINGLE : imageCellDirection, (i7 & 32768) != 0 ? null : str4);
    }

    public final Uri getUri$zendesk_ui_ui_android() {
        return this.uri;
    }

    public final Uri getLocalUri$zendesk_ui_ui_android() {
        return this.localUri;
    }

    public final String getImageType$zendesk_ui_ui_android() {
        return this.imageType;
    }

    public final String getMessageText$zendesk_ui_ui_android() {
        return this.messageText;
    }

    public final boolean isError$zendesk_ui_ui_android() {
        return this.isError;
    }

    public final boolean isPending$zendesk_ui_ui_android() {
        return this.isPending;
    }

    public final List<ActionButton> getActions$zendesk_ui_ui_android() {
        return this.actions;
    }

    public final int getTextColor$zendesk_ui_ui_android() {
        return this.textColor;
    }

    public final int getErrorColor$zendesk_ui_ui_android() {
        return this.errorColor;
    }

    public final int getErrorBackgroundColor$zendesk_ui_ui_android() {
        return this.errorBackgroundColor;
    }

    public final int getBackgroundColor$zendesk_ui_ui_android() {
        return this.backgroundColor;
    }

    public final int getActionColor$zendesk_ui_ui_android() {
        return this.actionColor;
    }

    public final int getActionTextColor$zendesk_ui_ui_android() {
        return this.actionTextColor;
    }

    public final String getErrorText$zendesk_ui_ui_android() {
        return this.errorText;
    }

    public final ImageCellDirection getImageCellDirection$zendesk_ui_ui_android() {
        return this.imageCellDirection;
    }

    public final String getAuthorizationToken$zendesk_ui_ui_android() {
        return this.authorizationToken;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000>\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0014\u0010\u0006\u001a\u00020\u00002\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007J\u0010\u0010\t\u001a\u00020\u00002\b\u0010\n\u001a\u0004\u0018\u00010\u000bJ\u0010\u0010\f\u001a\u00020\u00002\b\b\u0001\u0010\r\u001a\u00020\u000eJ\u0006\u0010\u000f\u001a\u00020\u0003J\u000e\u0010\u0010\u001a\u00020\u00002\u0006\u0010\u0010\u001a\u00020\u000bJ\u000e\u0010\u0011\u001a\u00020\u00002\u0006\u0010\u0011\u001a\u00020\u0012J\u000e\u0010\u0013\u001a\u00020\u00002\u0006\u0010\u0013\u001a\u00020\u000bJ\u000e\u0010\u0014\u001a\u00020\u00002\u0006\u0010\u0014\u001a\u00020\u0015J\u0010\u0010\u0016\u001a\u00020\u00002\b\u0010\u0016\u001a\u0004\u0018\u00010\u000bJ\u0010\u0010\u0017\u001a\u00020\u00002\b\b\u0001\u0010\r\u001a\u00020\u000eJ\u000e\u0010\u0018\u001a\u00020\u00002\u0006\u0010\u0018\u001a\u00020\u0015R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0019"}, m18d2 = {"Lzendesk/ui/android/conversation/imagecell/ImageCellState$Builder;", "", "state", "Lzendesk/ui/android/conversation/imagecell/ImageCellState;", "(Lzendesk/ui/android/conversation/imagecell/ImageCellState;)V", "()V", "actions", "", "Lzendesk/ui/android/conversation/actionbutton/ActionButton;", "authorizationToken", "token", "", "backgroundColor", "color", "", "build", "errorText", "imageCellDirection", "Lzendesk/ui/android/conversation/imagecell/ImageCellDirection;", "imageType", "localUri", "Landroid/net/Uri;", "messageText", "textColor", "uri", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private ImageCellState state;

        public Builder() {
            this.state = new ImageCellState(null, null, null, null, false, false, null, 0, 0, 0, 0, 0, 0, null, null, 0 == true ? 1 : 0, Settings.DEFAULT_INITIAL_WINDOW_SIZE, null);
        }

        public Builder(ImageCellState state) {
            this();
            Intrinsics.checkNotNullParameter(state, "state");
            this.state = state;
        }

        public final Builder uri(Uri uri) {
            Intrinsics.checkNotNullParameter(uri, "uri");
            this.state = ImageCellState.copy$default(this.state, uri, null, null, null, false, false, null, 0, 0, 0, 0, 0, 0, null, null, null, 65534, null);
            return this;
        }

        public final Builder localUri(Uri localUri) {
            Intrinsics.checkNotNullParameter(localUri, "localUri");
            this.state = ImageCellState.copy$default(this.state, null, localUri, null, null, false, false, null, 0, 0, 0, 0, 0, 0, null, null, null, Utf8.REPLACEMENT_CODE_POINT, null);
            return this;
        }

        public final Builder authorizationToken(String token) {
            this.state = ImageCellState.copy$default(this.state, null, null, null, null, false, false, null, 0, 0, 0, 0, 0, 0, null, null, token, 32767, null);
            return this;
        }

        public final Builder imageType(String imageType) {
            Intrinsics.checkNotNullParameter(imageType, "imageType");
            this.state = ImageCellState.copy$default(this.state, null, null, imageType, null, false, false, null, 0, 0, 0, 0, 0, 0, null, null, null, 65531, null);
            return this;
        }

        public final Builder messageText(String messageText) {
            this.state = ImageCellState.copy$default(this.state, null, null, null, messageText, false, false, null, 0, 0, 0, 0, 0, 0, null, null, null, 65527, null);
            return this;
        }

        public final Builder textColor(int color) {
            this.state = ImageCellState.copy$default(this.state, null, null, null, null, false, false, null, color, 0, 0, 0, 0, 0, null, null, null, 65407, null);
            return this;
        }

        public final Builder backgroundColor(int color) {
            this.state = ImageCellState.copy$default(this.state, null, null, null, null, false, false, null, 0, 0, 0, color, 0, 0, null, null, null, 64511, null);
            return this;
        }

        public final Builder errorText(String errorText) {
            Intrinsics.checkNotNullParameter(errorText, "errorText");
            this.state = ImageCellState.copy$default(this.state, null, null, null, null, false, false, null, 0, 0, 0, 0, 0, 0, errorText, null, null, 57343, null);
            return this;
        }

        public final Builder imageCellDirection(ImageCellDirection imageCellDirection) {
            Intrinsics.checkNotNullParameter(imageCellDirection, "imageCellDirection");
            this.state = ImageCellState.copy$default(this.state, null, null, null, null, false, false, null, 0, 0, 0, 0, 0, 0, null, imageCellDirection, null, 49151, null);
            return this;
        }

        public final Builder actions(List<ActionButton> actions) {
            Intrinsics.checkNotNullParameter(actions, "actions");
            this.state = ImageCellState.copy$default(this.state, null, null, null, null, false, false, actions, 0, 0, 0, 0, 0, 0, null, null, null, 65471, null);
            return this;
        }

        public final ImageCellState getState() {
            return this.state;
        }
    }
}
