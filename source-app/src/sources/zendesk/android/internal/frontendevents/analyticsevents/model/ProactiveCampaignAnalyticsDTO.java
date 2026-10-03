package zendesk.android.internal.frontendevents.analyticsevents.model;

import cz.msebera.android.httpclient.cookie.ClientCookie;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;

@Metadata(m17d1 = {"\u0000D\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0011\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 +2\u00020\u0001:\u0002*+BI\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0005\u0012\u0006\u0010\t\u001a\u00020\u0003\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u000b\u001a\u0004\u0018\u00010\f¢\u0006\u0002\u0010\rB-\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\u0005\u0012\u0006\u0010\t\u001a\u00020\u0003\u0012\u0006\u0010\n\u001a\u00020\u0005¢\u0006\u0002\u0010\u000eJ\t\u0010\u0017\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0018\u001a\u00020\u0007HÆ\u0003J\t\u0010\u0019\u001a\u00020\u0005HÆ\u0003J\t\u0010\u001a\u001a\u00020\u0003HÆ\u0003J\t\u0010\u001b\u001a\u00020\u0005HÆ\u0003J;\u0010\u001c\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\u00052\b\b\u0002\u0010\t\u001a\u00020\u00032\b\b\u0002\u0010\n\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u001d\u001a\u00020\u001e2\b\u0010\u001f\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010 \u001a\u00020\u0003HÖ\u0001J\t\u0010!\u001a\u00020\u0005HÖ\u0001J&\u0010\"\u001a\u00020#2\u0006\u0010$\u001a\u00020\u00002\u0006\u0010%\u001a\u00020&2\u0006\u0010'\u001a\u00020(HÁ\u0001¢\u0006\u0002\b)R\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012R\u0011\u0010\b\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0012R\u0011\u0010\t\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0015R\u0011\u0010\n\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0012¨\u0006,"}, m18d2 = {"Lzendesk/android/internal/frontendevents/analyticsevents/model/ProactiveCampaignAnalyticsDTO;", "", "seen1", "", "campaignId", "", "action", "Lzendesk/android/internal/frontendevents/analyticsevents/model/ProactiveCampaignAnalyticsAction;", "timestamp", ClientCookie.VERSION_ATTR, "visitorId", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Lzendesk/android/internal/frontendevents/analyticsevents/model/ProactiveCampaignAnalyticsAction;Ljava/lang/String;ILjava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Lzendesk/android/internal/frontendevents/analyticsevents/model/ProactiveCampaignAnalyticsAction;Ljava/lang/String;ILjava/lang/String;)V", "getAction", "()Lzendesk/android/internal/frontendevents/analyticsevents/model/ProactiveCampaignAnalyticsAction;", "getCampaignId", "()Ljava/lang/String;", "getTimestamp", "getVersion", "()I", "getVisitorId", "component1", "component2", "component3", "component4", "component5", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_zendesk_android", "$serializer", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class ProactiveCampaignAnalyticsDTO {
    private final ProactiveCampaignAnalyticsAction action;
    private final String campaignId;
    private final String timestamp;
    private final int version;
    private final String visitorId;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {null, ProactiveCampaignAnalyticsAction.INSTANCE.serializer(), null, null, null};

    public static ProactiveCampaignAnalyticsDTO copy$default(ProactiveCampaignAnalyticsDTO proactiveCampaignAnalyticsDTO, String str, ProactiveCampaignAnalyticsAction proactiveCampaignAnalyticsAction, String str2, int i, String str3, int i2, Object obj) {
        if ((i2 & 1) != 0) {
            str = proactiveCampaignAnalyticsDTO.campaignId;
        }
        if ((i2 & 2) != 0) {
            proactiveCampaignAnalyticsAction = proactiveCampaignAnalyticsDTO.action;
        }
        ProactiveCampaignAnalyticsAction proactiveCampaignAnalyticsAction2 = proactiveCampaignAnalyticsAction;
        if ((i2 & 4) != 0) {
            str2 = proactiveCampaignAnalyticsDTO.timestamp;
        }
        String str4 = str2;
        if ((i2 & 8) != 0) {
            i = proactiveCampaignAnalyticsDTO.version;
        }
        int i3 = i;
        if ((i2 & 16) != 0) {
            str3 = proactiveCampaignAnalyticsDTO.visitorId;
        }
        return proactiveCampaignAnalyticsDTO.copy(str, proactiveCampaignAnalyticsAction2, str4, i3, str3);
    }

    public final String getCampaignId() {
        return this.campaignId;
    }

    public final ProactiveCampaignAnalyticsAction getAction() {
        return this.action;
    }

    public final String getTimestamp() {
        return this.timestamp;
    }

    public final int getVersion() {
        return this.version;
    }

    public final String getVisitorId() {
        return this.visitorId;
    }

    public final ProactiveCampaignAnalyticsDTO copy(String campaignId, ProactiveCampaignAnalyticsAction action, String timestamp, int version, String visitorId) {
        Intrinsics.checkNotNullParameter(campaignId, "campaignId");
        Intrinsics.checkNotNullParameter(action, "action");
        Intrinsics.checkNotNullParameter(timestamp, "timestamp");
        Intrinsics.checkNotNullParameter(visitorId, "visitorId");
        return new ProactiveCampaignAnalyticsDTO(campaignId, action, timestamp, version, visitorId);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ProactiveCampaignAnalyticsDTO)) {
            return false;
        }
        ProactiveCampaignAnalyticsDTO proactiveCampaignAnalyticsDTO = (ProactiveCampaignAnalyticsDTO) other;
        return Intrinsics.areEqual(this.campaignId, proactiveCampaignAnalyticsDTO.campaignId) && this.action == proactiveCampaignAnalyticsDTO.action && Intrinsics.areEqual(this.timestamp, proactiveCampaignAnalyticsDTO.timestamp) && this.version == proactiveCampaignAnalyticsDTO.version && Intrinsics.areEqual(this.visitorId, proactiveCampaignAnalyticsDTO.visitorId);
    }

    public int hashCode() {
        return (((((((this.campaignId.hashCode() * 31) + this.action.hashCode()) * 31) + this.timestamp.hashCode()) * 31) + this.version) * 31) + this.visitorId.hashCode();
    }

    public String toString() {
        return "ProactiveCampaignAnalyticsDTO(campaignId=" + this.campaignId + ", action=" + this.action + ", timestamp=" + this.timestamp + ", version=" + this.version + ", visitorId=" + this.visitorId + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/internal/frontendevents/analyticsevents/model/ProactiveCampaignAnalyticsDTO$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/internal/frontendevents/analyticsevents/model/ProactiveCampaignAnalyticsDTO;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<ProactiveCampaignAnalyticsDTO> serializer() {
            return ProactiveCampaignAnalyticsDTO$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public ProactiveCampaignAnalyticsDTO(int i, String str, ProactiveCampaignAnalyticsAction proactiveCampaignAnalyticsAction, String str2, int i2, String str3, SerializationConstructorMarker serializationConstructorMarker) {
        if (31 != (i & 31)) {
            PluginExceptionsKt.throwMissingFieldException(i, 31, ProactiveCampaignAnalyticsDTO$$serializer.INSTANCE.getDescriptor());
        }
        this.campaignId = str;
        this.action = proactiveCampaignAnalyticsAction;
        this.timestamp = str2;
        this.version = i2;
        this.visitorId = str3;
    }

    public ProactiveCampaignAnalyticsDTO(String campaignId, ProactiveCampaignAnalyticsAction action, String timestamp, int i, String visitorId) {
        Intrinsics.checkNotNullParameter(campaignId, "campaignId");
        Intrinsics.checkNotNullParameter(action, "action");
        Intrinsics.checkNotNullParameter(timestamp, "timestamp");
        Intrinsics.checkNotNullParameter(visitorId, "visitorId");
        this.campaignId = campaignId;
        this.action = action;
        this.timestamp = timestamp;
        this.version = i;
        this.visitorId = visitorId;
    }

    @JvmStatic
    public static final void write$Self$zendesk_zendesk_android(ProactiveCampaignAnalyticsDTO self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        output.encodeStringElement(serialDesc, 0, self.campaignId);
        output.encodeSerializableElement(serialDesc, 1, kSerializerArr[1], self.action);
        output.encodeStringElement(serialDesc, 2, self.timestamp);
        output.encodeIntElement(serialDesc, 3, self.version);
        output.encodeStringElement(serialDesc, 4, self.visitorId);
    }

    public final String getCampaignId() {
        return this.campaignId;
    }

    public final ProactiveCampaignAnalyticsAction getAction() {
        return this.action;
    }

    public final String getTimestamp() {
        return this.timestamp;
    }

    public final int getVersion() {
        return this.version;
    }

    public final String getVisitorId() {
        return this.visitorId;
    }
}
