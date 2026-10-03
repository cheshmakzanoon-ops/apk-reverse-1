package com.facebook.gamingservices;

import android.media.Image;
import android.os.Build;
import android.os.Parcel;
import android.os.Parcelable;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.devicerequests.internal.DeviceRequestsHelper;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import com.facebook.gamingservices.internal.DateFormatter;
import com.facebook.gamingservices.internal.TournamentScoreType;
import com.facebook.gamingservices.internal.TournamentSortOrder;
import com.facebook.share.model.ShareModel;
import com.facebook.share.model.ShareModelBuilder;
import j$.time.Instant;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000L\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\t\u0018\u0000 ,2\u00020\u0001:\u0002-,B\u0011\b\u0012\u0012\u0006\u0010\u0003\u001a\u00020\u0002¢\u0006\u0004\b\u0004\u0010\u0005B\u0011\b\u0010\u0012\u0006\u0010\u0007\u001a\u00020\u0006¢\u0006\u0004\b\u0004\u0010\bJ\u000f\u0010\n\u001a\u00020\tH\u0016¢\u0006\u0004\b\n\u0010\u000bJ\u001f\u0010\u000f\u001a\u00020\u000e2\u0006\u0010\f\u001a\u00020\u00062\u0006\u0010\r\u001a\u00020\tH\u0016¢\u0006\u0004\b\u000f\u0010\u0010R\u0019\u0010\u0012\u001a\u0004\u0018\u00010\u00118\u0006¢\u0006\f\n\u0004\b\u0012\u0010\u0013\u001a\u0004\b\u0014\u0010\u0015R\u0019\u0010\u0017\u001a\u0004\u0018\u00010\u00168\u0006¢\u0006\f\n\u0004\b\u0017\u0010\u0018\u001a\u0004\b\u0019\u0010\u001aR\u0019\u0010\u001c\u001a\u0004\u0018\u00010\u001b8\u0006¢\u0006\f\n\u0004\b\u001c\u0010\u001d\u001a\u0004\b\u001e\u0010\u001fR\u0019\u0010!\u001a\u0004\u0018\u00010 8\u0006¢\u0006\f\n\u0004\b!\u0010\"\u001a\u0004\b#\u0010$R\u0019\u0010&\u001a\u0004\u0018\u00010%8\u0006¢\u0006\f\n\u0004\b&\u0010'\u001a\u0004\b(\u0010)R\u0019\u0010*\u001a\u0004\u0018\u00010\u00118\u0006¢\u0006\f\n\u0004\b*\u0010\u0013\u001a\u0004\b+\u0010\u0015¨\u0006."}, d2 = {"Lcom/facebook/gamingservices/TournamentConfig;", "Lcom/facebook/share/model/ShareModel;", "Lcom/facebook/gamingservices/TournamentConfig$Builder;", "builder", "<init>", "(Lcom/facebook/gamingservices/TournamentConfig$Builder;)V", "Landroid/os/Parcel;", "parcel", "(Landroid/os/Parcel;)V", "", "describeContents", "()I", "out", "flags", "", "writeToParcel", "(Landroid/os/Parcel;I)V", "", "title", "Ljava/lang/String;", "getTitle", "()Ljava/lang/String;", "Lcom/facebook/gamingservices/internal/TournamentSortOrder;", SDKConstants.PARAM_SORT_ORDER, "Lcom/facebook/gamingservices/internal/TournamentSortOrder;", "getSortOrder", "()Lcom/facebook/gamingservices/internal/TournamentSortOrder;", "Lcom/facebook/gamingservices/internal/TournamentScoreType;", "scoreType", "Lcom/facebook/gamingservices/internal/TournamentScoreType;", "getScoreType", "()Lcom/facebook/gamingservices/internal/TournamentScoreType;", "j$/time/Instant", SDKConstants.PARAM_END_TIME, "Lj$/time/Instant;", "getEndTime", "()Lj$/time/Instant;", "Landroid/media/Image;", "image", "Landroid/media/Image;", "getImage", "()Landroid/media/Image;", "payload", "getPayload", "CREATOR", "Builder", "facebook-gamingservices_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class TournamentConfig implements ShareModel {

    public static final Companion INSTANCE = new Companion(null);
    private final Instant endTime;
    private final Image image;
    private final String payload;
    private final TournamentScoreType scoreType;
    private final TournamentSortOrder sortOrder;
    private final String title;

    public TournamentConfig(Builder builder, DefaultConstructorMarker defaultConstructorMarker) {
        this(builder);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public final String getTitle() {
        return this.title;
    }

    public final TournamentSortOrder getSortOrder() {
        return this.sortOrder;
    }

    public final TournamentScoreType getScoreType() {
        return this.scoreType;
    }

    public final Instant getEndTime() {
        return this.endTime;
    }

    public final Image getImage() {
        return this.image;
    }

    public final String getPayload() {
        return this.payload;
    }

    private TournamentConfig(Builder builder) {
        this.title = builder.getTitle();
        this.sortOrder = builder.getSortOrder();
        this.scoreType = builder.getScoreType();
        this.endTime = builder.getEndTime();
        this.image = builder.getImage();
        this.payload = builder.getPayload();
    }

    public TournamentConfig(Parcel parcel) {
        TournamentSortOrder tournamentSortOrder;
        TournamentScoreType tournamentScoreType;
        Instant instantFrom;
        Intrinsics.checkNotNullParameter(parcel, "parcel");
        this.title = parcel.readString();
        TournamentSortOrder[] tournamentSortOrderArrValuesCustom = TournamentSortOrder.valuesCustom();
        int length = tournamentSortOrderArrValuesCustom.length;
        int i = 0;
        int i2 = 0;
        while (true) {
            if (i2 >= length) {
                tournamentSortOrder = null;
                break;
            }
            tournamentSortOrder = tournamentSortOrderArrValuesCustom[i2];
            if (Intrinsics.areEqual(tournamentSortOrder.name(), parcel.readString())) {
                break;
            } else {
                i2++;
            }
        }
        this.sortOrder = tournamentSortOrder;
        TournamentScoreType[] tournamentScoreTypeArrValuesCustom = TournamentScoreType.valuesCustom();
        int length2 = tournamentScoreTypeArrValuesCustom.length;
        while (true) {
            if (i >= length2) {
                tournamentScoreType = null;
                break;
            }
            tournamentScoreType = tournamentScoreTypeArrValuesCustom[i];
            if (Intrinsics.areEqual(tournamentScoreType.name(), parcel.readString())) {
                break;
            } else {
                i++;
            }
        }
        this.scoreType = tournamentScoreType;
        if (Build.VERSION.SDK_INT >= 26) {
            String string = parcel.readString();
            if (string != null) {
                instantFrom = Instant.from(DateFormatter.INSTANCE.format$facebook_gamingservices_release(string));
            }
            this.endTime = instantFrom;
            this.payload = parcel.readString();
            this.image = null;
        }
        instantFrom = null;
        this.endTime = instantFrom;
        this.payload = parcel.readString();
        this.image = null;
    }

    @Override
    public void writeToParcel(Parcel out, int flags) {
        Intrinsics.checkNotNullParameter(out, "out");
        out.writeString(String.valueOf(this.sortOrder));
        out.writeString(String.valueOf(this.scoreType));
        out.writeString(String.valueOf(this.endTime));
        out.writeString(this.title);
        out.writeString(this.payload);
    }

    @Metadata(d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\"\u0018\u00002\u000e\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00000\u0001B\u0007¢\u0006\u0004\b\u0003\u0010\u0004J\u0017\u0010\u0007\u001a\u00020\u00002\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005¢\u0006\u0004\b\u0007\u0010\bJ\u0015\u0010\u000b\u001a\u00020\u00002\u0006\u0010\n\u001a\u00020\t¢\u0006\u0004\b\u000b\u0010\fJ\u0015\u0010\u000f\u001a\u00020\u00002\u0006\u0010\u000e\u001a\u00020\r¢\u0006\u0004\b\u000f\u0010\u0010J\u0015\u0010\u0013\u001a\u00020\u00002\u0006\u0010\u0012\u001a\u00020\u0011¢\u0006\u0004\b\u0013\u0010\u0014J\u0017\u0010\u0017\u001a\u00020\u00002\b\u0010\u0016\u001a\u0004\u0018\u00010\u0015¢\u0006\u0004\b\u0017\u0010\u0018J\u0017\u0010\u001a\u001a\u00020\u00002\b\u0010\u0019\u001a\u0004\u0018\u00010\u0005¢\u0006\u0004\b\u001a\u0010\bJ\u000f\u0010\u001b\u001a\u00020\u0002H\u0016¢\u0006\u0004\b\u001b\u0010\u001cJ\u0017\u0010!\u001a\u00020\u00002\u0006\u0010\u001e\u001a\u00020\u001dH\u0000¢\u0006\u0004\b\u001f\u0010 J\u0019\u0010!\u001a\u00020\u00002\b\u0010\"\u001a\u0004\u0018\u00010\u0002H\u0016¢\u0006\u0004\b!\u0010#R$\u0010\u0006\u001a\u0004\u0018\u00010\u00058\u0006@\u0006X\u0086\u000e¢\u0006\u0012\n\u0004\b\u0006\u0010$\u001a\u0004\b%\u0010&\"\u0004\b'\u0010(R$\u0010\n\u001a\u0004\u0018\u00010\t8\u0006@\u0006X\u0086\u000e¢\u0006\u0012\n\u0004\b\n\u0010)\u001a\u0004\b*\u0010+\"\u0004\b,\u0010-R$\u0010\u000e\u001a\u0004\u0018\u00010\r8\u0006@\u0006X\u0086\u000e¢\u0006\u0012\n\u0004\b\u000e\u0010.\u001a\u0004\b/\u00100\"\u0004\b1\u00102R$\u0010\u0012\u001a\u0004\u0018\u00010\u00118\u0006@\u0006X\u0086\u000e¢\u0006\u0012\n\u0004\b\u0012\u00103\u001a\u0004\b4\u00105\"\u0004\b6\u00107R$\u0010\u0016\u001a\u0004\u0018\u00010\u00158\u0006@\u0006X\u0086\u000e¢\u0006\u0012\n\u0004\b\u0016\u00108\u001a\u0004\b9\u0010:\"\u0004\b;\u0010<R$\u0010\u0019\u001a\u0004\u0018\u00010\u00058\u0006@\u0006X\u0086\u000e¢\u0006\u0012\n\u0004\b\u0019\u0010$\u001a\u0004\b=\u0010&\"\u0004\b>\u0010(¨\u0006?"}, d2 = {"Lcom/facebook/gamingservices/TournamentConfig$Builder;", "Lcom/facebook/share/model/ShareModelBuilder;", "Lcom/facebook/gamingservices/TournamentConfig;", "<init>", "()V", "", "title", "setTournamentTitle", "(Ljava/lang/String;)Lcom/facebook/gamingservices/TournamentConfig$Builder;", "Lcom/facebook/gamingservices/internal/TournamentSortOrder;", SDKConstants.PARAM_SORT_ORDER, "setTournamentSortOrder", "(Lcom/facebook/gamingservices/internal/TournamentSortOrder;)Lcom/facebook/gamingservices/TournamentConfig$Builder;", "Lcom/facebook/gamingservices/internal/TournamentScoreType;", "scoreType", "setTournamentScoreType", "(Lcom/facebook/gamingservices/internal/TournamentScoreType;)Lcom/facebook/gamingservices/TournamentConfig$Builder;", "j$/time/Instant", SDKConstants.PARAM_END_TIME, "setTournamentEndTime", "(Lj$/time/Instant;)Lcom/facebook/gamingservices/TournamentConfig$Builder;", "Landroid/media/Image;", "image", "setTournamentImage", "(Landroid/media/Image;)Lcom/facebook/gamingservices/TournamentConfig$Builder;", "payload", "setTournamentPayload", "build", "()Lcom/facebook/gamingservices/TournamentConfig;", "Landroid/os/Parcel;", "parcel", "readFrom$facebook_gamingservices_release", "(Landroid/os/Parcel;)Lcom/facebook/gamingservices/TournamentConfig$Builder;", "readFrom", DeviceRequestsHelper.DEVICE_INFO_MODEL, "(Lcom/facebook/gamingservices/TournamentConfig;)Lcom/facebook/gamingservices/TournamentConfig$Builder;", "Ljava/lang/String;", "getTitle", "()Ljava/lang/String;", "setTitle", "(Ljava/lang/String;)V", "Lcom/facebook/gamingservices/internal/TournamentSortOrder;", "getSortOrder", "()Lcom/facebook/gamingservices/internal/TournamentSortOrder;", "setSortOrder", "(Lcom/facebook/gamingservices/internal/TournamentSortOrder;)V", "Lcom/facebook/gamingservices/internal/TournamentScoreType;", "getScoreType", "()Lcom/facebook/gamingservices/internal/TournamentScoreType;", "setScoreType", "(Lcom/facebook/gamingservices/internal/TournamentScoreType;)V", "Lj$/time/Instant;", "getEndTime", "()Lj$/time/Instant;", "setEndTime", "(Lj$/time/Instant;)V", "Landroid/media/Image;", "getImage", "()Landroid/media/Image;", "setImage", "(Landroid/media/Image;)V", "getPayload", "setPayload", "facebook-gamingservices_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Builder implements ShareModelBuilder<TournamentConfig, Builder> {
        private Instant endTime;
        private Image image;
        private String payload;
        private TournamentScoreType scoreType;
        private TournamentSortOrder sortOrder;
        private String title;

        public final String getTitle() {
            return this.title;
        }

        public final void setTitle(String str) {
            this.title = str;
        }

        public final TournamentSortOrder getSortOrder() {
            return this.sortOrder;
        }

        public final void setSortOrder(TournamentSortOrder tournamentSortOrder) {
            this.sortOrder = tournamentSortOrder;
        }

        public final TournamentScoreType getScoreType() {
            return this.scoreType;
        }

        public final void setScoreType(TournamentScoreType tournamentScoreType) {
            this.scoreType = tournamentScoreType;
        }

        public final Instant getEndTime() {
            return this.endTime;
        }

        public final void setEndTime(Instant instant) {
            this.endTime = instant;
        }

        public final Image getImage() {
            return this.image;
        }

        public final void setImage(Image image) {
            this.image = image;
        }

        public final String getPayload() {
            return this.payload;
        }

        public final void setPayload(String str) {
            this.payload = str;
        }

        public final Builder setTournamentTitle(String title) {
            this.title = title;
            return this;
        }

        public final Builder setTournamentSortOrder(TournamentSortOrder sortOrder) {
            Intrinsics.checkNotNullParameter(sortOrder, SDKConstants.PARAM_SORT_ORDER);
            this.sortOrder = sortOrder;
            return this;
        }

        public final Builder setTournamentScoreType(TournamentScoreType scoreType) {
            Intrinsics.checkNotNullParameter(scoreType, "scoreType");
            this.scoreType = scoreType;
            return this;
        }

        public final Builder setTournamentEndTime(Instant endTime) {
            Intrinsics.checkNotNullParameter(endTime, SDKConstants.PARAM_END_TIME);
            this.endTime = endTime;
            return this;
        }

        public final Builder setTournamentImage(Image image) {
            this.image = image;
            return this;
        }

        public final Builder setTournamentPayload(String payload) {
            this.payload = payload;
            return this;
        }

        @Override
        public TournamentConfig build() {
            return new TournamentConfig(this, null);
        }

        public final Builder readFrom$facebook_gamingservices_release(Parcel parcel) {
            Intrinsics.checkNotNullParameter(parcel, "parcel");
            return readFrom((TournamentConfig) parcel.readParcelable(TournamentConfig.class.getClassLoader()));
        }

        @Override
        public Builder readFrom(TournamentConfig model) {
            if (model == null) {
                return this;
            }
            TournamentSortOrder sortOrder = model.getSortOrder();
            if (sortOrder != null) {
                setTournamentSortOrder(sortOrder);
            }
            TournamentScoreType scoreType = model.getScoreType();
            if (scoreType != null) {
                setTournamentScoreType(scoreType);
            }
            Instant endTime = model.getEndTime();
            if (endTime != null) {
                setTournamentEndTime(endTime);
            }
            String title = model.getTitle();
            if (title != null) {
                setTournamentTitle(title);
            }
            setTournamentPayload(model.getPayload());
            return this;
        }
    }

    @Metadata(d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0011\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\u0003\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0010\u0010\u0004\u001a\u00020\u00022\u0006\u0010\u0005\u001a\u00020\u0006H\u0016J\u001d\u0010\u0007\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00020\b2\u0006\u0010\t\u001a\u00020\nH\u0016¢\u0006\u0002\u0010\u000b¨\u0006\f"}, d2 = {"Lcom/facebook/gamingservices/TournamentConfig$CREATOR;", "Landroid/os/Parcelable$Creator;", "Lcom/facebook/gamingservices/TournamentConfig;", "()V", "createFromParcel", "parcel", "Landroid/os/Parcel;", "newArray", "", "size", "", "(I)[Lcom/facebook/gamingservices/TournamentConfig;", "facebook-gamingservices_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Companion implements Parcelable.Creator<TournamentConfig> {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        @Override
        public TournamentConfig createFromParcel(Parcel parcel) {
            Intrinsics.checkNotNullParameter(parcel, "parcel");
            return new TournamentConfig(parcel);
        }

        @Override
        public TournamentConfig[] newArray(int size) {
            return new TournamentConfig[size];
        }
    }
}
