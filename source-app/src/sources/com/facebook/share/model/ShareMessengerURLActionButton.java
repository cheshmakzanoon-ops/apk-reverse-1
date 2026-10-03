package com.facebook.share.model;

import android.net.Uri;
import android.os.Parcel;
import android.os.Parcelable;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.devicerequests.internal.DeviceRequestsHelper;
import java.util.Arrays;
import kotlin.Deprecated;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0004\u0018\u0000 \u001e2\u00020\u0001:\u0003\u001d\u001e\u001fB\u000f\b\u0012\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u000f\b\u0010\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007J\b\u0010\u0017\u001a\u00020\rH\u0007J\u0018\u0010\u0018\u001a\u00020\u00192\u0006\u0010\u001a\u001a\u00020\u00062\u0006\u0010\u001b\u001a\u00020\u001cH\u0016R\u0013\u0010\b\u001a\u0004\u0018\u00010\t¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0011\u0010\f\u001a\u00020\r¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\u000eR\u0011\u0010\u000f\u001a\u00020\r¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u000eR\u0013\u0010\u0011\u001a\u0004\u0018\u00010\t¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u000bR\u0013\u0010\u0013\u001a\u0004\u0018\u00010\u0014¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016¨\u0006 "}, d2 = {"Lcom/facebook/share/model/ShareMessengerURLActionButton;", "Lcom/facebook/share/model/ShareMessengerActionButton;", "builder", "Lcom/facebook/share/model/ShareMessengerURLActionButton$Builder;", "(Lcom/facebook/share/model/ShareMessengerURLActionButton$Builder;)V", "parcel", "Landroid/os/Parcel;", "(Landroid/os/Parcel;)V", "fallbackUrl", "Landroid/net/Uri;", "getFallbackUrl", "()Landroid/net/Uri;", "isMessengerExtensionURL", "", "()Z", "shouldHideWebviewShareButton", "getShouldHideWebviewShareButton", "url", "getUrl", "webviewHeightRatio", "Lcom/facebook/share/model/ShareMessengerURLActionButton$WebviewHeightRatio;", "getWebviewHeightRatio", "()Lcom/facebook/share/model/ShareMessengerURLActionButton$WebviewHeightRatio;", "getIsMessengerExtensionURL", "writeToParcel", "", "dest", "flags", "", "Builder", "Companion", "WebviewHeightRatio", "facebook-common_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class ShareMessengerURLActionButton extends ShareMessengerActionButton {
    private final Uri fallbackUrl;
    private final boolean isMessengerExtensionURL;
    private final boolean shouldHideWebviewShareButton;
    private final Uri url;
    private final WebviewHeightRatio webviewHeightRatio;
    public static final Parcelable.Creator<ShareMessengerURLActionButton> CREATOR = new Parcelable.Creator<ShareMessengerURLActionButton>() {
        @Override
        public ShareMessengerURLActionButton createFromParcel(Parcel parcel) {
            Intrinsics.checkNotNullParameter(parcel, "parcel");
            return new ShareMessengerURLActionButton(parcel);
        }

        @Override
        public ShareMessengerURLActionButton[] newArray(int size) {
            return new ShareMessengerURLActionButton[size];
        }
    };

    public ShareMessengerURLActionButton(Builder builder, DefaultConstructorMarker defaultConstructorMarker) {
        this(builder);
    }

    @Metadata(d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\u0005\b\u0086\u0001\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002j\u0002\b\u0003j\u0002\b\u0004j\u0002\b\u0005¨\u0006\u0006"}, d2 = {"Lcom/facebook/share/model/ShareMessengerURLActionButton$WebviewHeightRatio;", "", "(Ljava/lang/String;I)V", "WebviewHeightRatioFull", "WebviewHeightRatioTall", "WebviewHeightRatioCompact", "facebook-common_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public enum WebviewHeightRatio {
        WebviewHeightRatioFull,
        WebviewHeightRatioTall,
        WebviewHeightRatioCompact;

        public static WebviewHeightRatio[] valuesCustom() {
            WebviewHeightRatio[] webviewHeightRatioArrValuesCustom = values();
            return (WebviewHeightRatio[]) Arrays.copyOf(webviewHeightRatioArrValuesCustom, webviewHeightRatioArrValuesCustom.length);
        }
    }

    public final Uri getUrl() {
        return this.url;
    }

    public final Uri getFallbackUrl() {
        return this.fallbackUrl;
    }

    public final boolean isMessengerExtensionURL() {
        return this.isMessengerExtensionURL;
    }

    public final boolean getShouldHideWebviewShareButton() {
        return this.shouldHideWebviewShareButton;
    }

    public final WebviewHeightRatio getWebviewHeightRatio() {
        return this.webviewHeightRatio;
    }

    @Deprecated(message = "getIsMessengerExtensionURL is deprecated. Use isMessengerExtensionURL instead", replaceWith = @ReplaceWith(expression = "isMessengerExtensionURL", imports = {}))
    public final boolean getIsMessengerExtensionURL() {
        return this.isMessengerExtensionURL;
    }

    private ShareMessengerURLActionButton(Builder builder) {
        super(builder);
        this.url = builder.getUrl();
        this.isMessengerExtensionURL = builder.getIsMessengerExtensionURL();
        this.fallbackUrl = builder.getFallbackUrl();
        this.webviewHeightRatio = builder.getWebviewHeightRatio();
        this.shouldHideWebviewShareButton = builder.getShouldHideWebviewShareButton();
    }

    public ShareMessengerURLActionButton(Parcel parcel) {
        super(parcel);
        Intrinsics.checkNotNullParameter(parcel, "parcel");
        this.url = (Uri) parcel.readParcelable(Uri.class.getClassLoader());
        this.isMessengerExtensionURL = parcel.readByte() != 0;
        this.fallbackUrl = (Uri) parcel.readParcelable(Uri.class.getClassLoader());
        this.webviewHeightRatio = (WebviewHeightRatio) parcel.readSerializable();
        this.shouldHideWebviewShareButton = parcel.readByte() != 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        Intrinsics.checkNotNullParameter(dest, "dest");
        super.writeToParcel(dest, flags);
        dest.writeParcelable(this.url, 0);
        dest.writeByte(this.isMessengerExtensionURL ? (byte) 1 : (byte) 0);
        dest.writeParcelable(this.fallbackUrl, 0);
        dest.writeSerializable(this.webviewHeightRatio);
        dest.writeByte(this.isMessengerExtensionURL ? (byte) 1 : (byte) 0);
    }

    @Metadata(d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\b\r\u0018\u00002\u000e\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00000\u0001B\u0005¢\u0006\u0002\u0010\u0003J\b\u0010\u001c\u001a\u00020\u0002H\u0016J\u0012\u0010\u001d\u001a\u00020\u00002\b\u0010\u001e\u001a\u0004\u0018\u00010\u0002H\u0016J\u0010\u0010\u001f\u001a\u00020\u00002\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005J\u000e\u0010 \u001a\u00020\u00002\u0006\u0010\n\u001a\u00020\u000bJ\u000e\u0010!\u001a\u00020\u00002\u0006\u0010\u0010\u001a\u00020\u000bJ\u0010\u0010\"\u001a\u00020\u00002\b\u0010\u0013\u001a\u0004\u0018\u00010\u0005J\u0010\u0010#\u001a\u00020\u00002\b\u0010\u0016\u001a\u0004\u0018\u00010\u0017R\u001c\u0010\u0004\u001a\u0004\u0018\u00010\u0005X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0006\u0010\u0007\"\u0004\b\b\u0010\tR\u001a\u0010\n\u001a\u00020\u000bX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\f\u0010\r\"\u0004\b\u000e\u0010\u000fR\u001a\u0010\u0010\u001a\u00020\u000bX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0011\u0010\r\"\u0004\b\u0012\u0010\u000fR\u001c\u0010\u0013\u001a\u0004\u0018\u00010\u0005X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0014\u0010\u0007\"\u0004\b\u0015\u0010\tR\u001c\u0010\u0016\u001a\u0004\u0018\u00010\u0017X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0018\u0010\u0019\"\u0004\b\u001a\u0010\u001b¨\u0006$"}, d2 = {"Lcom/facebook/share/model/ShareMessengerURLActionButton$Builder;", "Lcom/facebook/share/model/ShareMessengerActionButton$Builder;", "Lcom/facebook/share/model/ShareMessengerURLActionButton;", "()V", "fallbackUrl", "Landroid/net/Uri;", "getFallbackUrl$facebook_common_release", "()Landroid/net/Uri;", "setFallbackUrl$facebook_common_release", "(Landroid/net/Uri;)V", "isMessengerExtensionURL", "", "isMessengerExtensionURL$facebook_common_release", "()Z", "setMessengerExtensionURL$facebook_common_release", "(Z)V", "shouldHideWebviewShareButton", "getShouldHideWebviewShareButton$facebook_common_release", "setShouldHideWebviewShareButton$facebook_common_release", "url", "getUrl$facebook_common_release", "setUrl$facebook_common_release", "webviewHeightRatio", "Lcom/facebook/share/model/ShareMessengerURLActionButton$WebviewHeightRatio;", "getWebviewHeightRatio$facebook_common_release", "()Lcom/facebook/share/model/ShareMessengerURLActionButton$WebviewHeightRatio;", "setWebviewHeightRatio$facebook_common_release", "(Lcom/facebook/share/model/ShareMessengerURLActionButton$WebviewHeightRatio;)V", "build", "readFrom", DeviceRequestsHelper.DEVICE_INFO_MODEL, "setFallbackUrl", "setIsMessengerExtensionURL", "setShouldHideWebviewShareButton", "setUrl", "setWebviewHeightRatio", "facebook-common_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Builder extends ShareMessengerActionButton.Builder<ShareMessengerURLActionButton, Builder> {
        private Uri fallbackUrl;
        private boolean isMessengerExtensionURL;
        private boolean shouldHideWebviewShareButton;
        private Uri url;
        private WebviewHeightRatio webviewHeightRatio;

        public final Uri getUrl() {
            return this.url;
        }

        public final void setUrl$facebook_common_release(Uri uri) {
            this.url = uri;
        }

        public final boolean getIsMessengerExtensionURL() {
            return this.isMessengerExtensionURL;
        }

        public final void setMessengerExtensionURL$facebook_common_release(boolean z) {
            this.isMessengerExtensionURL = z;
        }

        public final Uri getFallbackUrl() {
            return this.fallbackUrl;
        }

        public final void setFallbackUrl$facebook_common_release(Uri uri) {
            this.fallbackUrl = uri;
        }

        public final WebviewHeightRatio getWebviewHeightRatio() {
            return this.webviewHeightRatio;
        }

        public final void setWebviewHeightRatio$facebook_common_release(WebviewHeightRatio webviewHeightRatio) {
            this.webviewHeightRatio = webviewHeightRatio;
        }

        public final boolean getShouldHideWebviewShareButton() {
            return this.shouldHideWebviewShareButton;
        }

        public final void setShouldHideWebviewShareButton$facebook_common_release(boolean z) {
            this.shouldHideWebviewShareButton = z;
        }

        public final Builder setUrl(Uri url) {
            this.url = url;
            return this;
        }

        public final Builder setIsMessengerExtensionURL(boolean isMessengerExtensionURL) {
            this.isMessengerExtensionURL = isMessengerExtensionURL;
            return this;
        }

        public final Builder setFallbackUrl(Uri fallbackUrl) {
            this.fallbackUrl = fallbackUrl;
            return this;
        }

        public final Builder setWebviewHeightRatio(WebviewHeightRatio webviewHeightRatio) {
            this.webviewHeightRatio = webviewHeightRatio;
            return this;
        }

        public final Builder setShouldHideWebviewShareButton(boolean shouldHideWebviewShareButton) {
            this.shouldHideWebviewShareButton = shouldHideWebviewShareButton;
            return this;
        }

        @Override
        public Builder readFrom(ShareMessengerURLActionButton model) {
            return model == null ? this : setUrl(model.getUrl()).setIsMessengerExtensionURL(model.isMessengerExtensionURL()).setFallbackUrl(model.getFallbackUrl()).setWebviewHeightRatio(model.getWebviewHeightRatio()).setShouldHideWebviewShareButton(model.getShouldHideWebviewShareButton());
        }

        @Override
        public ShareMessengerURLActionButton build() {
            return new ShareMessengerURLActionButton(this, null);
        }
    }
}
