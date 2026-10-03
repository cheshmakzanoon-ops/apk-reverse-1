package com.facebook.gamingservices;

import android.os.Build;
import android.os.Parcel;
import android.os.Parcelable;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import com.facebook.gamingservices.internal.DateFormatter;
import com.facebook.share.model.ShareModel;
import com.facebook.share.model.ShareModelBuilder;
import com.google.gson.annotations.SerializedName;
import j$.time.ZonedDateTime;
import j$.time.format.DateTimeFormatter;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\b\n\u0018\u0000 \u001c2\u00020\u0001:\u0002\u001d\u001cB/\b\u0016\u0012\u0006\u0010\u0003\u001a\u00020\u0002\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0002\u0012\b\u0010\u0005\u001a\u0004\u0018\u00010\u0002\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0002¢\u0006\u0004\b\u0007\u0010\bB\u0011\b\u0016\u0012\u0006\u0010\n\u001a\u00020\t¢\u0006\u0004\b\u0007\u0010\u000bJ\u000f\u0010\r\u001a\u00020\fH\u0016¢\u0006\u0004\b\r\u0010\u000eJ\u001f\u0010\u0012\u001a\u00020\u00112\u0006\u0010\u000f\u001a\u00020\t2\u0006\u0010\u0010\u001a\u00020\fH\u0016¢\u0006\u0004\b\u0012\u0010\u0013R\u0014\u0010\u0003\u001a\u00020\u00028\u0006X\u0087\u0004¢\u0006\u0006\n\u0004\b\u0003\u0010\u0014R\u0016\u0010\u0005\u001a\u0004\u0018\u00010\u00028\u0006X\u0087\u0004¢\u0006\u0006\n\u0004\b\u0005\u0010\u0014R\u0016\u0010\u0006\u001a\u0004\u0018\u00010\u00028\u0006X\u0087\u0004¢\u0006\u0006\n\u0004\b\u0006\u0010\u0014R\u0018\u0010\u0004\u001a\u0004\u0018\u00010\u00028\u0000@\u0000X\u0081\u000e¢\u0006\u0006\n\u0004\b\u0004\u0010\u0014R(\u0010\u001b\u001a\u0004\u0018\u00010\u00152\b\u0010\u0016\u001a\u0004\u0018\u00010\u00158F@BX\u0086\u000e¢\u0006\f\u001a\u0004\b\u0017\u0010\u0018\"\u0004\b\u0019\u0010\u001a¨\u0006\u001e"}, d2 = {"Lcom/facebook/gamingservices/Tournament;", "Lcom/facebook/share/model/ShareModel;", "", "identifier", SDKConstants.PARAM_END_TIME, "title", "payload", "<init>", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", "Landroid/os/Parcel;", "parcel", "(Landroid/os/Parcel;)V", "", "describeContents", "()I", "out", "flags", "", "writeToParcel", "(Landroid/os/Parcel;I)V", "Ljava/lang/String;", "j$/time/ZonedDateTime", "newValue", "getExpiration", "()Lj$/time/ZonedDateTime;", "setExpiration", "(Lj$/time/ZonedDateTime;)V", "expiration", "CREATOR", "Builder", "facebook-gamingservices_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class Tournament implements ShareModel {

    public static final Companion INSTANCE = new Companion(null);

    @SerializedName("tournament_end_time")
    public String endTime;

    @SerializedName("id")
    public final String identifier;

    @SerializedName(SDKConstants.PARAM_TOURNAMENTS_PAYLOAD)
    public final String payload;

    @SerializedName(SDKConstants.PARAM_TOURNAMENTS_TITLE)
    public final String title;

    @Override
    public int describeContents() {
        return 0;
    }

    public final ZonedDateTime getExpiration() {
        String str = this.endTime;
        if (str == null) {
            return null;
        }
        return DateFormatter.INSTANCE.format$facebook_gamingservices_release(str);
    }

    private final void setExpiration(ZonedDateTime zonedDateTime) {
        if (Build.VERSION.SDK_INT < 26 || zonedDateTime == null) {
            return;
        }
        this.endTime = zonedDateTime.format(DateTimeFormatter.ISO_DATE_TIME);
        setExpiration(zonedDateTime);
    }

    public Tournament(String str, String str2, String str3, String str4) {
        Intrinsics.checkNotNullParameter(str, "identifier");
        this.identifier = str;
        this.endTime = str2;
        this.title = str3;
        this.payload = str4;
        setExpiration(str2 == null ? null : DateFormatter.INSTANCE.format$facebook_gamingservices_release(str2));
    }

    public Tournament(Parcel parcel) {
        this(parcel.toString(), parcel.toString(), parcel.toString(), parcel.toString());
        Intrinsics.checkNotNullParameter(parcel, "parcel");
    }

    @Metadata(d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\b\u0016\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0012\b\u0080\b\u0018\u00002\u000e\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00000\u0001B3\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\u0003¢\u0006\u0004\b\t\u0010\nJ\u0015\u0010\u0004\u001a\u00020\u00002\u0006\u0010\u0004\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u000bJ\u0017\u0010\u0006\u001a\u00020\u00002\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005¢\u0006\u0004\b\u0006\u0010\fJ\u0017\u0010\u0007\u001a\u00020\u00002\b\u0010\u0007\u001a\u0004\u0018\u00010\u0003¢\u0006\u0004\b\u0007\u0010\u000bJ\u0017\u0010\b\u001a\u00020\u00002\b\u0010\b\u001a\u0004\u0018\u00010\u0003¢\u0006\u0004\b\b\u0010\u000bJ\u000f\u0010\r\u001a\u00020\u0002H\u0016¢\u0006\u0004\b\r\u0010\u000eJ\u0019\u0010\u0010\u001a\u00020\u00002\b\u0010\u000f\u001a\u0004\u0018\u00010\u0002H\u0016¢\u0006\u0004\b\u0010\u0010\u0011J\u0010\u0010\u0012\u001a\u00020\u0003HÆ\u0003¢\u0006\u0004\b\u0012\u0010\u0013J\u0012\u0010\u0014\u001a\u0004\u0018\u00010\u0005HÆ\u0003¢\u0006\u0004\b\u0014\u0010\u0015J\u0012\u0010\u0016\u001a\u0004\u0018\u00010\u0003HÆ\u0003¢\u0006\u0004\b\u0016\u0010\u0013J\u0012\u0010\u0017\u001a\u0004\u0018\u00010\u0003HÆ\u0003¢\u0006\u0004\b\u0017\u0010\u0013J>\u0010\u0018\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00032\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\u0003HÆ\u0001¢\u0006\u0004\b\u0018\u0010\u0019J\u0010\u0010\u001a\u001a\u00020\u0003HÖ\u0001¢\u0006\u0004\b\u001a\u0010\u0013J\u0010\u0010\u001c\u001a\u00020\u001bHÖ\u0001¢\u0006\u0004\b\u001c\u0010\u001dJ\u001a\u0010!\u001a\u00020 2\b\u0010\u001f\u001a\u0004\u0018\u00010\u001eHÖ\u0003¢\u0006\u0004\b!\u0010\"R\"\u0010\u0004\u001a\u00020\u00038\u0006@\u0006X\u0086\u000e¢\u0006\u0012\n\u0004\b\u0004\u0010#\u001a\u0004\b$\u0010\u0013\"\u0004\b%\u0010&R$\u0010\u0006\u001a\u0004\u0018\u00010\u00058\u0006@\u0006X\u0086\u000e¢\u0006\u0012\n\u0004\b\u0006\u0010'\u001a\u0004\b(\u0010\u0015\"\u0004\b)\u0010*R$\u0010\u0007\u001a\u0004\u0018\u00010\u00038\u0006@\u0006X\u0086\u000e¢\u0006\u0012\n\u0004\b\u0007\u0010#\u001a\u0004\b+\u0010\u0013\"\u0004\b,\u0010&R$\u0010\b\u001a\u0004\u0018\u00010\u00038\u0006@\u0006X\u0086\u000e¢\u0006\u0012\n\u0004\b\b\u0010#\u001a\u0004\b-\u0010\u0013\"\u0004\b.\u0010&R$\u0010/\u001a\u0004\u0018\u00010\u00038\u0006@\u0006X\u0086\u000e¢\u0006\u0012\n\u0004\b/\u0010#\u001a\u0004\b0\u0010\u0013\"\u0004\b1\u0010&¨\u00062"}, d2 = {"Lcom/facebook/gamingservices/Tournament$Builder;", "Lcom/facebook/share/model/ShareModelBuilder;", "Lcom/facebook/gamingservices/Tournament;", "", "identifier", "j$/time/ZonedDateTime", "expiration", "title", "payload", "<init>", "(Ljava/lang/String;Lj$/time/ZonedDateTime;Ljava/lang/String;Ljava/lang/String;)V", "(Ljava/lang/String;)Lcom/facebook/gamingservices/Tournament$Builder;", "(Lj$/time/ZonedDateTime;)Lcom/facebook/gamingservices/Tournament$Builder;", "build", "()Lcom/facebook/gamingservices/Tournament;", "tournament", "readFrom", "(Lcom/facebook/gamingservices/Tournament;)Lcom/facebook/gamingservices/Tournament$Builder;", "component1", "()Ljava/lang/String;", "component2", "()Lj$/time/ZonedDateTime;", "component3", "component4", "copy", "(Ljava/lang/String;Lj$/time/ZonedDateTime;Ljava/lang/String;Ljava/lang/String;)Lcom/facebook/gamingservices/Tournament$Builder;", "toString", "", "hashCode", "()I", "", "other", "", "equals", "(Ljava/lang/Object;)Z", "Ljava/lang/String;", "getIdentifier", "setIdentifier", "(Ljava/lang/String;)V", "Lj$/time/ZonedDateTime;", "getExpiration", "setExpiration", "(Lj$/time/ZonedDateTime;)V", "getTitle", "setTitle", "getPayload", "setPayload", SDKConstants.PARAM_END_TIME, "getEndTime", "setEndTime", "facebook-gamingservices_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Builder implements ShareModelBuilder<Tournament, Builder> {
        private String endTime;
        private ZonedDateTime expiration;
        private String identifier;
        private String payload;
        private String title;

        public static Builder copy$default(Builder builder, String str, ZonedDateTime zonedDateTime, String str2, String str3, int i, Object obj) {
            if ((i & 1) != 0) {
                str = builder.identifier;
            }
            if ((i & 2) != 0) {
                zonedDateTime = builder.expiration;
            }
            if ((i & 4) != 0) {
                str2 = builder.title;
            }
            if ((i & 8) != 0) {
                str3 = builder.payload;
            }
            return builder.copy(str, zonedDateTime, str2, str3);
        }

        public final String getIdentifier() {
            return this.identifier;
        }

        public final ZonedDateTime getExpiration() {
            return this.expiration;
        }

        public final String getTitle() {
            return this.title;
        }

        public final String getPayload() {
            return this.payload;
        }

        public final Builder copy(String identifier, ZonedDateTime expiration, String title, String payload) {
            Intrinsics.checkNotNullParameter(identifier, "identifier");
            return new Builder(identifier, expiration, title, payload);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Builder)) {
                return false;
            }
            Builder builder = (Builder) other;
            return Intrinsics.areEqual(this.identifier, builder.identifier) && Intrinsics.areEqual(this.expiration, builder.expiration) && Intrinsics.areEqual(this.title, builder.title) && Intrinsics.areEqual(this.payload, builder.payload);
        }

        public int hashCode() {
            int iHashCode = this.identifier.hashCode() * 31;
            ZonedDateTime zonedDateTime = this.expiration;
            int iHashCode2 = (iHashCode + (zonedDateTime == null ? 0 : zonedDateTime.hashCode())) * 31;
            String str = this.title;
            int iHashCode3 = (iHashCode2 + (str == null ? 0 : str.hashCode())) * 31;
            String str2 = this.payload;
            return iHashCode3 + (str2 != null ? str2.hashCode() : 0);
        }

        public String toString() {
            return "Builder(identifier=" + this.identifier + ", expiration=" + this.expiration + ", title=" + ((Object) this.title) + ", payload=" + ((Object) this.payload) + ')';
        }

        public Builder(String str, ZonedDateTime zonedDateTime, String str2, String str3) {
            Intrinsics.checkNotNullParameter(str, "identifier");
            this.identifier = str;
            this.expiration = zonedDateTime;
            this.title = str2;
            this.payload = str3;
        }

        public Builder(String str, ZonedDateTime zonedDateTime, String str2, String str3, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this(str, (i & 2) != 0 ? null : zonedDateTime, (i & 4) != 0 ? null : str2, (i & 8) != 0 ? null : str3);
        }

        public final String getIdentifier() {
            return this.identifier;
        }

        public final void setIdentifier(String str) {
            Intrinsics.checkNotNullParameter(str, "<set-?>");
            this.identifier = str;
        }

        public final ZonedDateTime getExpiration() {
            return this.expiration;
        }

        public final void setExpiration(ZonedDateTime zonedDateTime) {
            this.expiration = zonedDateTime;
        }

        public final String getTitle() {
            return this.title;
        }

        public final void setTitle(String str) {
            this.title = str;
        }

        public final String getPayload() {
            return this.payload;
        }

        public final void setPayload(String str) {
            this.payload = str;
        }

        public final String getEndTime() {
            return this.endTime;
        }

        public final void setEndTime(String str) {
            this.endTime = str;
        }

        public final Builder identifier(String identifier) {
            Intrinsics.checkNotNullParameter(identifier, "identifier");
            setIdentifier(identifier);
            return this;
        }

        public final Builder expiration(ZonedDateTime expiration) {
            setExpiration(expiration);
            if (Build.VERSION.SDK_INT >= 26 && expiration != null) {
                setEndTime(expiration.format(DateTimeFormatter.ISO_DATE_TIME));
            }
            return this;
        }

        public final Builder title(String title) {
            setTitle(title);
            return this;
        }

        public final Builder payload(String payload) {
            setPayload(payload);
            return this;
        }

        @Override
        public Tournament build() {
            return new Tournament(this.identifier, this.endTime, this.title, this.payload);
        }

        @Override
        public Builder readFrom(Tournament tournament) {
            Builder builderPayload = tournament == null ? null : identifier(tournament.identifier).expiration(tournament.getExpiration()).title(tournament.title).payload(tournament.payload);
            return builderPayload == null ? this : builderPayload;
        }
    }

    @Override
    public void writeToParcel(Parcel out, int flags) {
        Intrinsics.checkNotNullParameter(out, "out");
        out.writeString(this.identifier);
        out.writeString(this.endTime);
        out.writeString(this.title);
        out.writeString(this.payload);
    }

    @Metadata(d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0011\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\u0003\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0010\u0010\u0004\u001a\u00020\u00022\u0006\u0010\u0005\u001a\u00020\u0006H\u0016J\u001d\u0010\u0007\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00020\b2\u0006\u0010\t\u001a\u00020\nH\u0016¢\u0006\u0002\u0010\u000b¨\u0006\f"}, d2 = {"Lcom/facebook/gamingservices/Tournament$CREATOR;", "Landroid/os/Parcelable$Creator;", "Lcom/facebook/gamingservices/Tournament;", "()V", "createFromParcel", "parcel", "Landroid/os/Parcel;", "newArray", "", "size", "", "(I)[Lcom/facebook/gamingservices/Tournament;", "facebook-gamingservices_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Companion implements Parcelable.Creator<Tournament> {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        @Override
        public Tournament createFromParcel(Parcel parcel) {
            Intrinsics.checkNotNullParameter(parcel, "parcel");
            return new Tournament(parcel);
        }

        @Override
        public Tournament[] newArray(int size) {
            return new Tournament[size];
        }
    }
}
