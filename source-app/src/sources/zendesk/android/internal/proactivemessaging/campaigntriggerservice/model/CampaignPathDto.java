package zendesk.android.internal.proactivemessaging.campaigntriggerservice.model;

import cz.msebera.android.httpclient.cookie.ClientCookie;
import java.util.List;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.SerialName;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.ArrayListSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u0000D\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010 \n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0010\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 (2\u00020\u0001:\u0002'(B?\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0001\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\u0010\b\u0001\u0010\u0006\u001a\n\u0012\u0004\u0012\u00020\u0005\u0018\u00010\u0007\u0012\u0006\u0010\b\u001a\u00020\u0003\u0012\b\u0010\t\u001a\u0004\u0018\u00010\n¢\u0006\u0002\u0010\u000bB#\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\u00050\u0007\u0012\u0006\u0010\b\u001a\u00020\u0003¢\u0006\u0002\u0010\fJ\t\u0010\u0016\u001a\u00020\u0005HÆ\u0003J\u000f\u0010\u0017\u001a\b\u0012\u0004\u0012\u00020\u00050\u0007HÆ\u0003J\t\u0010\u0018\u001a\u00020\u0003HÆ\u0003J-\u0010\u0019\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\u000e\b\u0002\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\u00050\u00072\b\b\u0002\u0010\b\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\u001a\u001a\u00020\u001b2\b\u0010\u001c\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u001d\u001a\u00020\u0003HÖ\u0001J\t\u0010\u001e\u001a\u00020\u0005HÖ\u0001J&\u0010\u001f\u001a\u00020 2\u0006\u0010!\u001a\u00020\u00002\u0006\u0010\"\u001a\u00020#2\u0006\u0010$\u001a\u00020%HÁ\u0001¢\u0006\u0002\b&R\u001c\u0010\u0004\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\r\u0010\u000e\u001a\u0004\b\u000f\u0010\u0010R\"\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\u00050\u00078\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0011\u0010\u000e\u001a\u0004\b\u0012\u0010\u0013R\u0011\u0010\b\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0015¨\u0006)"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/campaigntriggerservice/model/CampaignPathDto;", "", "seen1", "", "campaignId", "", "pathIds", "", ClientCookie.VERSION_ATTR, "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/util/List;ILkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/util/List;I)V", "getCampaignId$annotations", "()V", "getCampaignId", "()Ljava/lang/String;", "getPathIds$annotations", "getPathIds", "()Ljava/util/List;", "getVersion", "()I", "component1", "component2", "component3", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_zendesk_android", "$serializer", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class CampaignPathDto {
    private final String campaignId;
    private final List<String> pathIds;
    private final int version;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {null, new ArrayListSerializer(StringSerializer.INSTANCE), null};

    public static CampaignPathDto copy$default(CampaignPathDto campaignPathDto, String str, List list, int i, int i2, Object obj) {
        if ((i2 & 1) != 0) {
            str = campaignPathDto.campaignId;
        }
        if ((i2 & 2) != 0) {
            list = campaignPathDto.pathIds;
        }
        if ((i2 & 4) != 0) {
            i = campaignPathDto.version;
        }
        return campaignPathDto.copy(str, list, i);
    }

    @SerialName("pcm_id")
    public static void getCampaignId$annotations() {
    }

    @SerialName("path_ids")
    public static void getPathIds$annotations() {
    }

    public final String getCampaignId() {
        return this.campaignId;
    }

    public final List<String> component2() {
        return this.pathIds;
    }

    public final int getVersion() {
        return this.version;
    }

    public final CampaignPathDto copy(String campaignId, List<String> pathIds, int version) {
        Intrinsics.checkNotNullParameter(campaignId, "campaignId");
        Intrinsics.checkNotNullParameter(pathIds, "pathIds");
        return new CampaignPathDto(campaignId, pathIds, version);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof CampaignPathDto)) {
            return false;
        }
        CampaignPathDto campaignPathDto = (CampaignPathDto) other;
        return Intrinsics.areEqual(this.campaignId, campaignPathDto.campaignId) && Intrinsics.areEqual(this.pathIds, campaignPathDto.pathIds) && this.version == campaignPathDto.version;
    }

    public int hashCode() {
        return (((this.campaignId.hashCode() * 31) + this.pathIds.hashCode()) * 31) + this.version;
    }

    public String toString() {
        return "CampaignPathDto(campaignId=" + this.campaignId + ", pathIds=" + this.pathIds + ", version=" + this.version + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/campaigntriggerservice/model/CampaignPathDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/internal/proactivemessaging/campaigntriggerservice/model/CampaignPathDto;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<CampaignPathDto> serializer() {
            return CampaignPathDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public CampaignPathDto(int i, @SerialName("pcm_id") String str, @SerialName("path_ids") List list, int i2, SerializationConstructorMarker serializationConstructorMarker) {
        if (7 != (i & 7)) {
            PluginExceptionsKt.throwMissingFieldException(i, 7, CampaignPathDto$$serializer.INSTANCE.getDescriptor());
        }
        this.campaignId = str;
        this.pathIds = list;
        this.version = i2;
    }

    public CampaignPathDto(String campaignId, List<String> pathIds, int i) {
        Intrinsics.checkNotNullParameter(campaignId, "campaignId");
        Intrinsics.checkNotNullParameter(pathIds, "pathIds");
        this.campaignId = campaignId;
        this.pathIds = pathIds;
        this.version = i;
    }

    @JvmStatic
    public static final void write$Self$zendesk_zendesk_android(CampaignPathDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        output.encodeStringElement(serialDesc, 0, self.campaignId);
        output.encodeSerializableElement(serialDesc, 1, kSerializerArr[1], self.pathIds);
        output.encodeIntElement(serialDesc, 2, self.version);
    }

    public final String getCampaignId() {
        return this.campaignId;
    }

    public final List<String> getPathIds() {
        return this.pathIds;
    }

    public final int getVersion() {
        return this.version;
    }
}
