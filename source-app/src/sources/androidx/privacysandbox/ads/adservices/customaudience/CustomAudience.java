package androidx.privacysandbox.ads.adservices.customaudience;

import android.net.Uri;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.privacysandbox.ads.adservices.common.AdData;
import androidx.privacysandbox.ads.adservices.common.AdSelectionSignals;
import androidx.privacysandbox.ads.adservices.common.AdTechIdentifier;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import j$.time.Instant;
import java.util.List;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000H\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u001c\u0018\u00002\u00020\u0001:\u00014Be\u0012\u0006\u0010\u0003\u001a\u00020\u0002\u0012\u0006\u0010\u0005\u001a\u00020\u0004\u0012\u0006\u0010\u0007\u001a\u00020\u0006\u0012\u0006\u0010\b\u001a\u00020\u0006\u0012\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\n0\t\u0012\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\f\u0012\n\b\u0002\u0010\u000e\u001a\u0004\u0018\u00010\f\u0012\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u000f\u0012\n\b\u0002\u0010\u0012\u001a\u0004\u0018\u00010\u0011¢\u0006\u0004\b\u0013\u0010\u0014J\u001a\u0010\u0017\u001a\u00020\u00162\b\u0010\u0015\u001a\u0004\u0018\u00010\u0001H\u0096\u0002¢\u0006\u0004\b\u0017\u0010\u0018J\u000f\u0010\u001a\u001a\u00020\u0019H\u0016¢\u0006\u0004\b\u001a\u0010\u001bJ\u000f\u0010\u001c\u001a\u00020\u0004H\u0016¢\u0006\u0004\b\u001c\u0010\u001dR\u0017\u0010\u0003\u001a\u00020\u00028\u0006¢\u0006\f\n\u0004\b\u0003\u0010\u001e\u001a\u0004\b\u001f\u0010 R\u0017\u0010\u0005\u001a\u00020\u00048\u0006¢\u0006\f\n\u0004\b\u0005\u0010!\u001a\u0004\b\"\u0010\u001dR\u0017\u0010\u0007\u001a\u00020\u00068\u0006¢\u0006\f\n\u0004\b\u0007\u0010#\u001a\u0004\b$\u0010%R\u0017\u0010\b\u001a\u00020\u00068\u0006¢\u0006\f\n\u0004\b\b\u0010#\u001a\u0004\b&\u0010%R\u001d\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\n0\t8\u0006¢\u0006\f\n\u0004\b\u000b\u0010'\u001a\u0004\b(\u0010)R\u0019\u0010\r\u001a\u0004\u0018\u00010\f8\u0006¢\u0006\f\n\u0004\b\r\u0010*\u001a\u0004\b+\u0010,R\u0019\u0010\u000e\u001a\u0004\u0018\u00010\f8\u0006¢\u0006\f\n\u0004\b\u000e\u0010*\u001a\u0004\b-\u0010,R\u0019\u0010\u0010\u001a\u0004\u0018\u00010\u000f8\u0006¢\u0006\f\n\u0004\b\u0010\u0010.\u001a\u0004\b/\u00100R\u0019\u0010\u0012\u001a\u0004\u0018\u00010\u00118\u0006¢\u0006\f\n\u0004\b\u0012\u00101\u001a\u0004\b2\u00103¨\u00065"}, d2 = {"Landroidx/privacysandbox/ads/adservices/customaudience/CustomAudience;", "", "Landroidx/privacysandbox/ads/adservices/common/AdTechIdentifier;", "buyer", "", "name", "Landroid/net/Uri;", "dailyUpdateUri", "biddingLogicUri", "", "Landroidx/privacysandbox/ads/adservices/common/AdData;", "ads", "j$/time/Instant", "activationTime", SDKConstants.PARAM_EXPIRATION_TIME, "Landroidx/privacysandbox/ads/adservices/common/AdSelectionSignals;", "userBiddingSignals", "Landroidx/privacysandbox/ads/adservices/customaudience/TrustedBiddingData;", "trustedBiddingSignals", "<init>", "(Landroidx/privacysandbox/ads/adservices/common/AdTechIdentifier;Ljava/lang/String;Landroid/net/Uri;Landroid/net/Uri;Ljava/util/List;Lj$/time/Instant;Lj$/time/Instant;Landroidx/privacysandbox/ads/adservices/common/AdSelectionSignals;Landroidx/privacysandbox/ads/adservices/customaudience/TrustedBiddingData;)V", "other", "", "equals", "(Ljava/lang/Object;)Z", "", "hashCode", "()I", "toString", "()Ljava/lang/String;", "Landroidx/privacysandbox/ads/adservices/common/AdTechIdentifier;", "getBuyer", "()Landroidx/privacysandbox/ads/adservices/common/AdTechIdentifier;", "Ljava/lang/String;", "getName", "Landroid/net/Uri;", "getDailyUpdateUri", "()Landroid/net/Uri;", "getBiddingLogicUri", "Ljava/util/List;", "getAds", "()Ljava/util/List;", "Lj$/time/Instant;", "getActivationTime", "()Lj$/time/Instant;", "getExpirationTime", "Landroidx/privacysandbox/ads/adservices/common/AdSelectionSignals;", "getUserBiddingSignals", "()Landroidx/privacysandbox/ads/adservices/common/AdSelectionSignals;", "Landroidx/privacysandbox/ads/adservices/customaudience/TrustedBiddingData;", "getTrustedBiddingSignals", "()Landroidx/privacysandbox/ads/adservices/customaudience/TrustedBiddingData;", "Builder", "ads-adservices_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class CustomAudience {
    private final Instant activationTime;
    private final List<AdData> ads;
    private final Uri biddingLogicUri;
    private final AdTechIdentifier buyer;
    private final Uri dailyUpdateUri;
    private final Instant expirationTime;
    private final String name;
    private final TrustedBiddingData trustedBiddingSignals;
    private final AdSelectionSignals userBiddingSignals;

    public CustomAudience(AdTechIdentifier adTechIdentifier, String str, Uri uri, Uri uri2, List<AdData> list, Instant instant, Instant instant2, AdSelectionSignals adSelectionSignals, TrustedBiddingData trustedBiddingData) {
        Intrinsics.checkNotNullParameter(adTechIdentifier, "buyer");
        Intrinsics.checkNotNullParameter(str, "name");
        Intrinsics.checkNotNullParameter(uri, "dailyUpdateUri");
        Intrinsics.checkNotNullParameter(uri2, "biddingLogicUri");
        Intrinsics.checkNotNullParameter(list, "ads");
        this.buyer = adTechIdentifier;
        this.name = str;
        this.dailyUpdateUri = uri;
        this.biddingLogicUri = uri2;
        this.ads = list;
        this.activationTime = instant;
        this.expirationTime = instant2;
        this.userBiddingSignals = adSelectionSignals;
        this.trustedBiddingSignals = trustedBiddingData;
    }

    public CustomAudience(AdTechIdentifier adTechIdentifier, String str, Uri uri, Uri uri2, List list, Instant instant, Instant instant2, AdSelectionSignals adSelectionSignals, TrustedBiddingData trustedBiddingData, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(adTechIdentifier, str, uri, uri2, list, (i & 32) != 0 ? null : instant, (i & 64) != 0 ? null : instant2, (i & 128) != 0 ? null : adSelectionSignals, (i & 256) != 0 ? null : trustedBiddingData);
    }

    public final AdTechIdentifier getBuyer() {
        return this.buyer;
    }

    public final String getName() {
        return this.name;
    }

    public final Uri getDailyUpdateUri() {
        return this.dailyUpdateUri;
    }

    public final Uri getBiddingLogicUri() {
        return this.biddingLogicUri;
    }

    public final List<AdData> getAds() {
        return this.ads;
    }

    public final Instant getActivationTime() {
        return this.activationTime;
    }

    public final Instant getExpirationTime() {
        return this.expirationTime;
    }

    public final AdSelectionSignals getUserBiddingSignals() {
        return this.userBiddingSignals;
    }

    public final TrustedBiddingData getTrustedBiddingSignals() {
        return this.trustedBiddingSignals;
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof CustomAudience)) {
            return false;
        }
        CustomAudience customAudience = (CustomAudience) other;
        return Intrinsics.areEqual(this.buyer, customAudience.buyer) && Intrinsics.areEqual(this.name, customAudience.name) && Intrinsics.areEqual(this.activationTime, customAudience.activationTime) && Intrinsics.areEqual(this.expirationTime, customAudience.expirationTime) && Intrinsics.areEqual(this.dailyUpdateUri, customAudience.dailyUpdateUri) && Intrinsics.areEqual(this.userBiddingSignals, customAudience.userBiddingSignals) && Intrinsics.areEqual(this.trustedBiddingSignals, customAudience.trustedBiddingSignals) && Intrinsics.areEqual(this.ads, customAudience.ads);
    }

    public int hashCode() {
        int iHashCode = ((this.buyer.hashCode() * 31) + this.name.hashCode()) * 31;
        Instant instant = this.activationTime;
        int iHashCode2 = (iHashCode + (instant != null ? instant.hashCode() : 0)) * 31;
        Instant instant2 = this.expirationTime;
        int iHashCode3 = (((iHashCode2 + (instant2 != null ? instant2.hashCode() : 0)) * 31) + this.dailyUpdateUri.hashCode()) * 31;
        AdSelectionSignals adSelectionSignals = this.userBiddingSignals;
        int iHashCode4 = (iHashCode3 + (adSelectionSignals != null ? adSelectionSignals.hashCode() : 0)) * 31;
        TrustedBiddingData trustedBiddingData = this.trustedBiddingSignals;
        return ((((iHashCode4 + (trustedBiddingData != null ? trustedBiddingData.hashCode() : 0)) * 31) + this.biddingLogicUri.hashCode()) * 31) + this.ads.hashCode();
    }

    public String toString() {
        return "CustomAudience: buyer=" + this.biddingLogicUri + ", activationTime=" + this.activationTime + ", expirationTime=" + this.expirationTime + ", dailyUpdateUri=" + this.dailyUpdateUri + ", userBiddingSignals=" + this.userBiddingSignals + ", trustedBiddingSignals=" + this.trustedBiddingSignals + ", biddingLogicUri=" + this.biddingLogicUri + ", ads=" + this.ads;
    }

    @Metadata(d1 = {"\u0000D\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u000b\u0018\u00002\u00020\u0001B5\u0012\u0006\u0010\u0003\u001a\u00020\u0002\u0012\u0006\u0010\u0005\u001a\u00020\u0004\u0012\u0006\u0010\u0007\u001a\u00020\u0006\u0012\u0006\u0010\b\u001a\u00020\u0006\u0012\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\n0\t¢\u0006\u0004\b\f\u0010\rJ\u0015\u0010\u000e\u001a\u00020\u00002\u0006\u0010\u0003\u001a\u00020\u0002¢\u0006\u0004\b\u000e\u0010\u000fJ\u0015\u0010\u0010\u001a\u00020\u00002\u0006\u0010\u0005\u001a\u00020\u0004¢\u0006\u0004\b\u0010\u0010\u0011J\u0015\u0010\u0014\u001a\u00020\u00002\u0006\u0010\u0013\u001a\u00020\u0012¢\u0006\u0004\b\u0014\u0010\u0015J\u0015\u0010\u0017\u001a\u00020\u00002\u0006\u0010\u0016\u001a\u00020\u0012¢\u0006\u0004\b\u0017\u0010\u0015J\u0015\u0010\u0018\u001a\u00020\u00002\u0006\u0010\u0007\u001a\u00020\u0006¢\u0006\u0004\b\u0018\u0010\u0019J\u0015\u0010\u001c\u001a\u00020\u00002\u0006\u0010\u001b\u001a\u00020\u001a¢\u0006\u0004\b\u001c\u0010\u001dJ\u0015\u0010 \u001a\u00020\u00002\u0006\u0010\u001f\u001a\u00020\u001e¢\u0006\u0004\b \u0010!J\u0015\u0010\"\u001a\u00020\u00002\u0006\u0010\b\u001a\u00020\u0006¢\u0006\u0004\b\"\u0010\u0019J\u001b\u0010#\u001a\u00020\u00002\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\n0\t¢\u0006\u0004\b#\u0010$J\r\u0010&\u001a\u00020%¢\u0006\u0004\b&\u0010'R\u0016\u0010\u0003\u001a\u00020\u00028\u0002@\u0002X\u0082\u000e¢\u0006\u0006\n\u0004\b\u0003\u0010(R\u0016\u0010\u0005\u001a\u00020\u00048\u0002@\u0002X\u0082\u000e¢\u0006\u0006\n\u0004\b\u0005\u0010)R\u0016\u0010\u0007\u001a\u00020\u00068\u0002@\u0002X\u0082\u000e¢\u0006\u0006\n\u0004\b\u0007\u0010*R\u0016\u0010\b\u001a\u00020\u00068\u0002@\u0002X\u0082\u000e¢\u0006\u0006\n\u0004\b\b\u0010*R\u001c\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\n0\t8\u0002@\u0002X\u0082\u000e¢\u0006\u0006\n\u0004\b\u000b\u0010+R\u0018\u0010\u0013\u001a\u0004\u0018\u00010\u00128\u0002@\u0002X\u0082\u000e¢\u0006\u0006\n\u0004\b\u0013\u0010,R\u0018\u0010\u0016\u001a\u0004\u0018\u00010\u00128\u0002@\u0002X\u0082\u000e¢\u0006\u0006\n\u0004\b\u0016\u0010,R\u0018\u0010\u001b\u001a\u0004\u0018\u00010\u001a8\u0002@\u0002X\u0082\u000e¢\u0006\u0006\n\u0004\b\u001b\u0010-R\u0018\u0010.\u001a\u0004\u0018\u00010\u001e8\u0002@\u0002X\u0082\u000e¢\u0006\u0006\n\u0004\b.\u0010/¨\u00060"}, d2 = {"Landroidx/privacysandbox/ads/adservices/customaudience/CustomAudience$Builder;", "", "Landroidx/privacysandbox/ads/adservices/common/AdTechIdentifier;", "buyer", "", "name", "Landroid/net/Uri;", "dailyUpdateUri", "biddingLogicUri", "", "Landroidx/privacysandbox/ads/adservices/common/AdData;", "ads", "<init>", "(Landroidx/privacysandbox/ads/adservices/common/AdTechIdentifier;Ljava/lang/String;Landroid/net/Uri;Landroid/net/Uri;Ljava/util/List;)V", "setBuyer", "(Landroidx/privacysandbox/ads/adservices/common/AdTechIdentifier;)Landroidx/privacysandbox/ads/adservices/customaudience/CustomAudience$Builder;", "setName", "(Ljava/lang/String;)Landroidx/privacysandbox/ads/adservices/customaudience/CustomAudience$Builder;", "j$/time/Instant", "activationTime", "setActivationTime", "(Lj$/time/Instant;)Landroidx/privacysandbox/ads/adservices/customaudience/CustomAudience$Builder;", SDKConstants.PARAM_EXPIRATION_TIME, "setExpirationTime", "setDailyUpdateUri", "(Landroid/net/Uri;)Landroidx/privacysandbox/ads/adservices/customaudience/CustomAudience$Builder;", "Landroidx/privacysandbox/ads/adservices/common/AdSelectionSignals;", "userBiddingSignals", "setUserBiddingSignals", "(Landroidx/privacysandbox/ads/adservices/common/AdSelectionSignals;)Landroidx/privacysandbox/ads/adservices/customaudience/CustomAudience$Builder;", "Landroidx/privacysandbox/ads/adservices/customaudience/TrustedBiddingData;", "trustedBiddingSignals", "setTrustedBiddingData", "(Landroidx/privacysandbox/ads/adservices/customaudience/TrustedBiddingData;)Landroidx/privacysandbox/ads/adservices/customaudience/CustomAudience$Builder;", "setBiddingLogicUri", "setAds", "(Ljava/util/List;)Landroidx/privacysandbox/ads/adservices/customaudience/CustomAudience$Builder;", "Landroidx/privacysandbox/ads/adservices/customaudience/CustomAudience;", "build", "()Landroidx/privacysandbox/ads/adservices/customaudience/CustomAudience;", "Landroidx/privacysandbox/ads/adservices/common/AdTechIdentifier;", "Ljava/lang/String;", "Landroid/net/Uri;", "Ljava/util/List;", "Lj$/time/Instant;", "Landroidx/privacysandbox/ads/adservices/common/AdSelectionSignals;", "trustedBiddingData", "Landroidx/privacysandbox/ads/adservices/customaudience/TrustedBiddingData;", "ads-adservices_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Builder {
        private Instant activationTime;
        private List<AdData> ads;
        private Uri biddingLogicUri;
        private AdTechIdentifier buyer;
        private Uri dailyUpdateUri;
        private Instant expirationTime;
        private String name;
        private TrustedBiddingData trustedBiddingData;
        private AdSelectionSignals userBiddingSignals;

        public Builder(AdTechIdentifier adTechIdentifier, String str, Uri uri, Uri uri2, List<AdData> list) {
            Intrinsics.checkNotNullParameter(adTechIdentifier, "buyer");
            Intrinsics.checkNotNullParameter(str, "name");
            Intrinsics.checkNotNullParameter(uri, "dailyUpdateUri");
            Intrinsics.checkNotNullParameter(uri2, "biddingLogicUri");
            Intrinsics.checkNotNullParameter(list, "ads");
            this.buyer = adTechIdentifier;
            this.name = str;
            this.dailyUpdateUri = uri;
            this.biddingLogicUri = uri2;
            this.ads = list;
        }

        public final Builder setBuyer(AdTechIdentifier buyer) {
            Intrinsics.checkNotNullParameter(buyer, "buyer");
            this.buyer = buyer;
            return this;
        }

        public final Builder setName(String name) {
            Intrinsics.checkNotNullParameter(name, "name");
            this.name = name;
            return this;
        }

        public final Builder setActivationTime(Instant activationTime) {
            Intrinsics.checkNotNullParameter(activationTime, "activationTime");
            this.activationTime = activationTime;
            return this;
        }

        public final Builder setExpirationTime(Instant expirationTime) {
            Intrinsics.checkNotNullParameter(expirationTime, SDKConstants.PARAM_EXPIRATION_TIME);
            this.expirationTime = expirationTime;
            return this;
        }

        public final Builder setDailyUpdateUri(Uri dailyUpdateUri) {
            Intrinsics.checkNotNullParameter(dailyUpdateUri, "dailyUpdateUri");
            this.dailyUpdateUri = dailyUpdateUri;
            return this;
        }

        public final Builder setUserBiddingSignals(AdSelectionSignals userBiddingSignals) {
            Intrinsics.checkNotNullParameter(userBiddingSignals, "userBiddingSignals");
            this.userBiddingSignals = userBiddingSignals;
            return this;
        }

        public final Builder setTrustedBiddingData(TrustedBiddingData trustedBiddingSignals) {
            Intrinsics.checkNotNullParameter(trustedBiddingSignals, "trustedBiddingSignals");
            this.trustedBiddingData = trustedBiddingSignals;
            return this;
        }

        public final Builder setBiddingLogicUri(Uri biddingLogicUri) {
            Intrinsics.checkNotNullParameter(biddingLogicUri, "biddingLogicUri");
            this.biddingLogicUri = biddingLogicUri;
            return this;
        }

        public final Builder setAds(List<AdData> ads) {
            Intrinsics.checkNotNullParameter(ads, "ads");
            this.ads = ads;
            return this;
        }

        public final CustomAudience build() {
            return new CustomAudience(this.buyer, this.name, this.dailyUpdateUri, this.biddingLogicUri, this.ads, this.activationTime, this.expirationTime, this.userBiddingSignals, this.trustedBiddingData);
        }
    }
}
