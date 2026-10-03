package com.facebook.share.model;

import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.devicerequests.internal.DeviceRequestsHelper;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import java.util.Set;
import kotlin.Metadata;
import kotlin.collections.SetsKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000L\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\"\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0005\u0018\u0000 \u001b2\u00020\u0001:\u0002\u001a\u001bB\u000f\b\u0012\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u000f\b\u0010\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007J\b\u0010\n\u001a\u00020\u000bH\u0016J\u0015\u0010\f\u001a\u0004\u0018\u00010\r2\b\u0010\u000e\u001a\u0004\u0018\u00010\u000fH\u0086\u0002J\u0012\u0010\u0010\u001a\u0004\u0018\u00010\u00112\b\u0010\u000e\u001a\u0004\u0018\u00010\u000fJ\u0012\u0010\u0012\u001a\u0004\u0018\u00010\u00132\b\u0010\u000e\u001a\u0004\u0018\u00010\u000fJ\f\u0010\u0014\u001a\b\u0012\u0004\u0012\u00020\u000f0\u0015J\u0018\u0010\u0016\u001a\u00020\u00172\u0006\u0010\u0018\u001a\u00020\u00062\u0006\u0010\u0019\u001a\u00020\u000bH\u0016R\u0010\u0010\b\u001a\u0004\u0018\u00010\tX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u001c"}, d2 = {"Lcom/facebook/share/model/CameraEffectTextures;", "Lcom/facebook/share/model/ShareModel;", "builder", "Lcom/facebook/share/model/CameraEffectTextures$Builder;", "(Lcom/facebook/share/model/CameraEffectTextures$Builder;)V", "parcel", "Landroid/os/Parcel;", "(Landroid/os/Parcel;)V", "textures", "Landroid/os/Bundle;", "describeContents", "", "get", "", SDKConstants.PARAM_KEY, "", "getTextureBitmap", "Landroid/graphics/Bitmap;", "getTextureUri", "Landroid/net/Uri;", "keySet", "", "writeToParcel", "", "out", "flags", "Builder", "Companion", "facebook-common_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class CameraEffectTextures implements ShareModel {
    private final Bundle textures;
    public static final Parcelable.Creator<CameraEffectTextures> CREATOR = new Parcelable.Creator<CameraEffectTextures>() {
        @Override
        public CameraEffectTextures createFromParcel(Parcel parcel) {
            Intrinsics.checkNotNullParameter(parcel, "parcel");
            return new CameraEffectTextures(parcel);
        }

        @Override
        public CameraEffectTextures[] newArray(int size) {
            return new CameraEffectTextures[size];
        }
    };

    public CameraEffectTextures(Builder builder, DefaultConstructorMarker defaultConstructorMarker) {
        this(builder);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    private CameraEffectTextures(Builder builder) {
        this.textures = builder.getTextures();
    }

    public CameraEffectTextures(Parcel parcel) {
        Intrinsics.checkNotNullParameter(parcel, "parcel");
        this.textures = parcel.readBundle(getClass().getClassLoader());
    }

    public final Bitmap getTextureBitmap(String key) {
        Bundle bundle = this.textures;
        Object obj = bundle == null ? null : bundle.get(key);
        if (obj instanceof Bitmap) {
            return (Bitmap) obj;
        }
        return null;
    }

    public final Uri getTextureUri(String key) {
        Bundle bundle = this.textures;
        Object obj = bundle == null ? null : bundle.get(key);
        if (obj instanceof Uri) {
            return (Uri) obj;
        }
        return null;
    }

    public final Object get(String key) {
        Bundle bundle = this.textures;
        if (bundle == null) {
            return null;
        }
        return bundle.get(key);
    }

    public final Set<String> keySet() {
        Bundle bundle = this.textures;
        Set<String> setKeySet = bundle == null ? null : bundle.keySet();
        return setKeySet == null ? SetsKt.emptySet() : setKeySet;
    }

    @Override
    public void writeToParcel(Parcel out, int flags) {
        Intrinsics.checkNotNullParameter(out, "out");
        out.writeBundle(this.textures);
    }

    @Metadata(d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\u0018\u00002\u000e\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00000\u0001B\u0005¢\u0006\u0002\u0010\u0003J\b\u0010\b\u001a\u00020\u0002H\u0016J\u001a\u0010\t\u001a\u00020\u00002\u0006\u0010\n\u001a\u00020\u000b2\b\u0010\f\u001a\u0004\u0018\u00010\rH\u0002J\u0018\u0010\u000e\u001a\u00020\u00002\u0006\u0010\n\u001a\u00020\u000b2\b\u0010\u000f\u001a\u0004\u0018\u00010\u0010J\u0018\u0010\u000e\u001a\u00020\u00002\u0006\u0010\n\u001a\u00020\u000b2\b\u0010\u0011\u001a\u0004\u0018\u00010\u0012J\u000e\u0010\u0013\u001a\u00020\u00002\u0006\u0010\u0014\u001a\u00020\u0015J\u0012\u0010\u0013\u001a\u00020\u00002\b\u0010\u0016\u001a\u0004\u0018\u00010\u0002H\u0016R\u0014\u0010\u0004\u001a\u00020\u0005X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0017"}, d2 = {"Lcom/facebook/share/model/CameraEffectTextures$Builder;", "Lcom/facebook/share/model/ShareModelBuilder;", "Lcom/facebook/share/model/CameraEffectTextures;", "()V", "textures", "Landroid/os/Bundle;", "getTextures$facebook_common_release", "()Landroid/os/Bundle;", "build", "putParcelableTexture", SDKConstants.PARAM_KEY, "", "parcelableTexture", "Landroid/os/Parcelable;", "putTexture", "texture", "Landroid/graphics/Bitmap;", "textureUrl", "Landroid/net/Uri;", "readFrom", "parcel", "Landroid/os/Parcel;", DeviceRequestsHelper.DEVICE_INFO_MODEL, "facebook-common_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Builder implements ShareModelBuilder<CameraEffectTextures, Builder> {
        private final Bundle textures = new Bundle();

        public final Bundle getTextures() {
            return this.textures;
        }

        public final Builder putTexture(String key, Bitmap texture) {
            Intrinsics.checkNotNullParameter(key, SDKConstants.PARAM_KEY);
            return putParcelableTexture(key, texture);
        }

        public final Builder putTexture(String key, Uri textureUrl) {
            Intrinsics.checkNotNullParameter(key, SDKConstants.PARAM_KEY);
            return putParcelableTexture(key, textureUrl);
        }

        private final Builder putParcelableTexture(String key, Parcelable parcelableTexture) {
            if (key.length() > 0 && parcelableTexture != null) {
                this.textures.putParcelable(key, parcelableTexture);
            }
            return this;
        }

        @Override
        public Builder readFrom(CameraEffectTextures model) {
            if (model != null) {
                this.textures.putAll(model.textures);
            }
            return this;
        }

        public final Builder readFrom(Parcel parcel) {
            Intrinsics.checkNotNullParameter(parcel, "parcel");
            return readFrom((CameraEffectTextures) parcel.readParcelable(CameraEffectTextures.class.getClassLoader()));
        }

        @Override
        public CameraEffectTextures build() {
            return new CameraEffectTextures(this, null);
        }
    }
}
