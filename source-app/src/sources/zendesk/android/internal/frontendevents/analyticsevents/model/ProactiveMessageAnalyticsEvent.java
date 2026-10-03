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
import zendesk.android.internal.frontendevents.FrontendEventsStorage;
import zendesk.faye.internal.Bayeux;

@Metadata(m17d1 = {"\u0000D\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0014\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 02\u00020\u0001:\u0002/0B_\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\t\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u000b\u001a\u0004\u0018\u00010\f\u0012\b\u0010\r\u001a\u0004\u0018\u00010\u000e¢\u0006\u0002\u0010\u000fB=\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\u0005\u0012\u0006\u0010\b\u001a\u00020\u0005\u0012\u0006\u0010\t\u001a\u00020\u0005\u0012\u0006\u0010\n\u001a\u00020\u0005\u0012\u0006\u0010\u000b\u001a\u00020\f¢\u0006\u0002\u0010\u0010J\t\u0010\u001a\u001a\u00020\u0005HÆ\u0003J\t\u0010\u001b\u001a\u00020\u0005HÆ\u0003J\t\u0010\u001c\u001a\u00020\u0005HÆ\u0003J\t\u0010\u001d\u001a\u00020\u0005HÆ\u0003J\t\u0010\u001e\u001a\u00020\u0005HÆ\u0003J\t\u0010\u001f\u001a\u00020\u0005HÆ\u0003J\t\u0010 \u001a\u00020\fHÆ\u0003JO\u0010!\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\b\b\u0002\u0010\u0007\u001a\u00020\u00052\b\b\u0002\u0010\b\u001a\u00020\u00052\b\b\u0002\u0010\t\u001a\u00020\u00052\b\b\u0002\u0010\n\u001a\u00020\u00052\b\b\u0002\u0010\u000b\u001a\u00020\fHÆ\u0001J\u0013\u0010\"\u001a\u00020#2\b\u0010$\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010%\u001a\u00020\u0003HÖ\u0001J\t\u0010&\u001a\u00020\u0005HÖ\u0001J&\u0010'\u001a\u00020(2\u0006\u0010)\u001a\u00020\u00002\u0006\u0010*\u001a\u00020+2\u0006\u0010,\u001a\u00020-HÁ\u0001¢\u0006\u0002\b.R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012R\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0012R\u0011\u0010\n\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0012R\u0011\u0010\u000b\u001a\u00020\f¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016R\u0011\u0010\t\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0012R\u0011\u0010\b\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0012R\u0011\u0010\u0007\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u0012¨\u00061"}, m18d2 = {"Lzendesk/android/internal/frontendevents/analyticsevents/model/ProactiveMessageAnalyticsEvent;", "", "seen1", "", "buid", "", Bayeux.KEY_CHANNEL, ClientCookie.VERSION_ATTR, "timestamp", FrontendEventsStorage.KEY_SUID, "idempotencyToken", "proactiveCampaign", "Lzendesk/android/internal/frontendevents/analyticsevents/model/ProactiveCampaignAnalyticsDTO;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/android/internal/frontendevents/analyticsevents/model/ProactiveCampaignAnalyticsDTO;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/android/internal/frontendevents/analyticsevents/model/ProactiveCampaignAnalyticsDTO;)V", "getBuid", "()Ljava/lang/String;", "getChannel", "getIdempotencyToken", "getProactiveCampaign", "()Lzendesk/android/internal/frontendevents/analyticsevents/model/ProactiveCampaignAnalyticsDTO;", "getSuid", "getTimestamp", "getVersion", "component1", "component2", "component3", "component4", "component5", "component6", "component7", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_zendesk_android", "$serializer", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class ProactiveMessageAnalyticsEvent {

    public static final Companion INSTANCE = new Companion(null);
    private final String buid;
    private final String channel;
    private final String idempotencyToken;
    private final ProactiveCampaignAnalyticsDTO proactiveCampaign;
    private final String suid;
    private final String timestamp;
    private final String version;

    public static ProactiveMessageAnalyticsEvent copy$default(ProactiveMessageAnalyticsEvent proactiveMessageAnalyticsEvent, String str, String str2, String str3, String str4, String str5, String str6, ProactiveCampaignAnalyticsDTO proactiveCampaignAnalyticsDTO, int i, Object obj) {
        if ((i & 1) != 0) {
            str = proactiveMessageAnalyticsEvent.buid;
        }
        if ((i & 2) != 0) {
            str2 = proactiveMessageAnalyticsEvent.channel;
        }
        String str7 = str2;
        if ((i & 4) != 0) {
            str3 = proactiveMessageAnalyticsEvent.version;
        }
        String str8 = str3;
        if ((i & 8) != 0) {
            str4 = proactiveMessageAnalyticsEvent.timestamp;
        }
        String str9 = str4;
        if ((i & 16) != 0) {
            str5 = proactiveMessageAnalyticsEvent.suid;
        }
        String str10 = str5;
        if ((i & 32) != 0) {
            str6 = proactiveMessageAnalyticsEvent.idempotencyToken;
        }
        String str11 = str6;
        if ((i & 64) != 0) {
            proactiveCampaignAnalyticsDTO = proactiveMessageAnalyticsEvent.proactiveCampaign;
        }
        return proactiveMessageAnalyticsEvent.copy(str, str7, str8, str9, str10, str11, proactiveCampaignAnalyticsDTO);
    }

    public final String getBuid() {
        return this.buid;
    }

    public final String getChannel() {
        return this.channel;
    }

    public final String getVersion() {
        return this.version;
    }

    public final String getTimestamp() {
        return this.timestamp;
    }

    public final String getSuid() {
        return this.suid;
    }

    public final String getIdempotencyToken() {
        return this.idempotencyToken;
    }

    public final ProactiveCampaignAnalyticsDTO getProactiveCampaign() {
        return this.proactiveCampaign;
    }

    public final ProactiveMessageAnalyticsEvent copy(String buid, String channel, String version, String timestamp, String suid, String idempotencyToken, ProactiveCampaignAnalyticsDTO proactiveCampaign) {
        Intrinsics.checkNotNullParameter(buid, "buid");
        Intrinsics.checkNotNullParameter(channel, "channel");
        Intrinsics.checkNotNullParameter(version, "version");
        Intrinsics.checkNotNullParameter(timestamp, "timestamp");
        Intrinsics.checkNotNullParameter(suid, "suid");
        Intrinsics.checkNotNullParameter(idempotencyToken, "idempotencyToken");
        Intrinsics.checkNotNullParameter(proactiveCampaign, "proactiveCampaign");
        return new ProactiveMessageAnalyticsEvent(buid, channel, version, timestamp, suid, idempotencyToken, proactiveCampaign);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ProactiveMessageAnalyticsEvent)) {
            return false;
        }
        ProactiveMessageAnalyticsEvent proactiveMessageAnalyticsEvent = (ProactiveMessageAnalyticsEvent) other;
        return Intrinsics.areEqual(this.buid, proactiveMessageAnalyticsEvent.buid) && Intrinsics.areEqual(this.channel, proactiveMessageAnalyticsEvent.channel) && Intrinsics.areEqual(this.version, proactiveMessageAnalyticsEvent.version) && Intrinsics.areEqual(this.timestamp, proactiveMessageAnalyticsEvent.timestamp) && Intrinsics.areEqual(this.suid, proactiveMessageAnalyticsEvent.suid) && Intrinsics.areEqual(this.idempotencyToken, proactiveMessageAnalyticsEvent.idempotencyToken) && Intrinsics.areEqual(this.proactiveCampaign, proactiveMessageAnalyticsEvent.proactiveCampaign);
    }

    public int hashCode() {
        return (((((((((((this.buid.hashCode() * 31) + this.channel.hashCode()) * 31) + this.version.hashCode()) * 31) + this.timestamp.hashCode()) * 31) + this.suid.hashCode()) * 31) + this.idempotencyToken.hashCode()) * 31) + this.proactiveCampaign.hashCode();
    }

    public String toString() {
        return "ProactiveMessageAnalyticsEvent(buid=" + this.buid + ", channel=" + this.channel + ", version=" + this.version + ", timestamp=" + this.timestamp + ", suid=" + this.suid + ", idempotencyToken=" + this.idempotencyToken + ", proactiveCampaign=" + this.proactiveCampaign + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/internal/frontendevents/analyticsevents/model/ProactiveMessageAnalyticsEvent$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/internal/frontendevents/analyticsevents/model/ProactiveMessageAnalyticsEvent;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<ProactiveMessageAnalyticsEvent> serializer() {
            return ProactiveMessageAnalyticsEvent$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public ProactiveMessageAnalyticsEvent(int i, String str, String str2, String str3, String str4, String str5, String str6, ProactiveCampaignAnalyticsDTO proactiveCampaignAnalyticsDTO, SerializationConstructorMarker serializationConstructorMarker) {
        if (127 != (i & 127)) {
            PluginExceptionsKt.throwMissingFieldException(i, 127, ProactiveMessageAnalyticsEvent$$serializer.INSTANCE.getDescriptor());
        }
        this.buid = str;
        this.channel = str2;
        this.version = str3;
        this.timestamp = str4;
        this.suid = str5;
        this.idempotencyToken = str6;
        this.proactiveCampaign = proactiveCampaignAnalyticsDTO;
    }

    public ProactiveMessageAnalyticsEvent(String buid, String channel, String version, String timestamp, String suid, String idempotencyToken, ProactiveCampaignAnalyticsDTO proactiveCampaign) {
        Intrinsics.checkNotNullParameter(buid, "buid");
        Intrinsics.checkNotNullParameter(channel, "channel");
        Intrinsics.checkNotNullParameter(version, "version");
        Intrinsics.checkNotNullParameter(timestamp, "timestamp");
        Intrinsics.checkNotNullParameter(suid, "suid");
        Intrinsics.checkNotNullParameter(idempotencyToken, "idempotencyToken");
        Intrinsics.checkNotNullParameter(proactiveCampaign, "proactiveCampaign");
        this.buid = buid;
        this.channel = channel;
        this.version = version;
        this.timestamp = timestamp;
        this.suid = suid;
        this.idempotencyToken = idempotencyToken;
        this.proactiveCampaign = proactiveCampaign;
    }

    @JvmStatic
    public static final void write$Self$zendesk_zendesk_android(ProactiveMessageAnalyticsEvent self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeStringElement(serialDesc, 0, self.buid);
        output.encodeStringElement(serialDesc, 1, self.channel);
        output.encodeStringElement(serialDesc, 2, self.version);
        output.encodeStringElement(serialDesc, 3, self.timestamp);
        output.encodeStringElement(serialDesc, 4, self.suid);
        output.encodeStringElement(serialDesc, 5, self.idempotencyToken);
        output.encodeSerializableElement(serialDesc, 6, ProactiveCampaignAnalyticsDTO$$serializer.INSTANCE, self.proactiveCampaign);
    }

    public final String getBuid() {
        return this.buid;
    }

    public final String getChannel() {
        return this.channel;
    }

    public final String getVersion() {
        return this.version;
    }

    public final String getTimestamp() {
        return this.timestamp;
    }

    public final String getSuid() {
        return this.suid;
    }

    public final String getIdempotencyToken() {
        return this.idempotencyToken;
    }

    public final ProactiveCampaignAnalyticsDTO getProactiveCampaign() {
        return this.proactiveCampaign;
    }
}
