package zendesk.conversationkit.android.internal.faye;

import java.util.Map;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Reflection;
import kotlinx.serialization.ContextualSerializer;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.SerialName;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.DoubleSerializer;
import kotlinx.serialization.internal.LinkedHashMapSerializer;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;
import zendesk.conversationkit.android.model.ConversationStatus;

@Metadata(m17d1 = {"\u0000R\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0006\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010$\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0014\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 02\u00020\u0001:\u0002/0BT\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0001\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\b\u001a\u0004\u0018\u00010\t\u0012\u0019\u0010\n\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\f\u0018\u00010\u000b\u0012\b\u0010\r\u001a\u0004\u0018\u00010\u000e¢\u0006\u0002\u0010\u000fBF\u0012\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\t\u0012\u001b\b\u0002\u0010\n\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\f\u0018\u00010\u000b¢\u0006\u0002\u0010\u0010J\u000b\u0010\u001c\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u0010\u0010\u001d\u001a\u0004\u0018\u00010\u0007HÆ\u0003¢\u0006\u0002\u0010\u0012J\u000b\u0010\u001e\u001a\u0004\u0018\u00010\tHÆ\u0003J\u001c\u0010\u001f\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\f\u0018\u00010\u000bHÆ\u0003JO\u0010 \u001a\u00020\u00002\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u00072\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\t2\u001b\b\u0002\u0010\n\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\f\u0018\u00010\u000bHÆ\u0001¢\u0006\u0002\u0010!J\u0013\u0010\"\u001a\u00020#2\b\u0010$\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010%\u001a\u00020\u0003HÖ\u0001J\t\u0010&\u001a\u00020\u0005HÖ\u0001J&\u0010'\u001a\u00020(2\u0006\u0010)\u001a\u00020\u00002\u0006\u0010*\u001a\u00020+2\u0006\u0010,\u001a\u00020-HÁ\u0001¢\u0006\u0002\b.R\u0015\u0010\u0006\u001a\u0004\u0018\u00010\u0007¢\u0006\n\n\u0002\u0010\u0013\u001a\u0004\b\u0011\u0010\u0012R\u001e\u0010\u0004\u001a\u0004\u0018\u00010\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0014\u0010\u0015\u001a\u0004\b\u0016\u0010\u0017R$\u0010\n\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\f\u0018\u00010\u000b¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0019R\u0013\u0010\b\u001a\u0004\u0018\u00010\t¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u001b¨\u00061"}, m18d2 = {"Lzendesk/conversationkit/android/internal/faye/WsConversationDto;", "", "seen1", "", "id", "", "appMakerLastRead", "", "status", "Lzendesk/conversationkit/android/model/ConversationStatus;", "metadata", "", "Lkotlinx/serialization/Contextual;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/Double;Lzendesk/conversationkit/android/model/ConversationStatus;Ljava/util/Map;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/Double;Lzendesk/conversationkit/android/model/ConversationStatus;Ljava/util/Map;)V", "getAppMakerLastRead", "()Ljava/lang/Double;", "Ljava/lang/Double;", "getId$annotations", "()V", "getId", "()Ljava/lang/String;", "getMetadata", "()Ljava/util/Map;", "getStatus", "()Lzendesk/conversationkit/android/model/ConversationStatus;", "component1", "component2", "component3", "component4", "copy", "(Ljava/lang/String;Ljava/lang/Double;Lzendesk/conversationkit/android/model/ConversationStatus;Ljava/util/Map;)Lzendesk/conversationkit/android/internal/faye/WsConversationDto;", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class WsConversationDto {
    private final Double appMakerLastRead;
    private final String id;
    private final Map<String, Object> metadata;
    private final ConversationStatus status;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {null, null, ConversationStatus.INSTANCE.serializer(), new LinkedHashMapSerializer(StringSerializer.INSTANCE, new ContextualSerializer(Reflection.getOrCreateKotlinClass(Object.class), null, new KSerializer[0]))};

    public WsConversationDto() {
        this((String) null, (Double) null, (ConversationStatus) null, (Map) null, 15, (DefaultConstructorMarker) null);
    }

    public static WsConversationDto copy$default(WsConversationDto wsConversationDto, String str, Double d, ConversationStatus conversationStatus, Map map, int i, Object obj) {
        if ((i & 1) != 0) {
            str = wsConversationDto.id;
        }
        if ((i & 2) != 0) {
            d = wsConversationDto.appMakerLastRead;
        }
        if ((i & 4) != 0) {
            conversationStatus = wsConversationDto.status;
        }
        if ((i & 8) != 0) {
            map = wsConversationDto.metadata;
        }
        return wsConversationDto.copy(str, d, conversationStatus, map);
    }

    @SerialName("_id")
    public static void getId$annotations() {
    }

    public final String getId() {
        return this.id;
    }

    public final Double getAppMakerLastRead() {
        return this.appMakerLastRead;
    }

    public final ConversationStatus getStatus() {
        return this.status;
    }

    public final Map<String, Object> component4() {
        return this.metadata;
    }

    public final WsConversationDto copy(String id, Double appMakerLastRead, ConversationStatus status, Map<String, ? extends Object> metadata) {
        return new WsConversationDto(id, appMakerLastRead, status, metadata);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof WsConversationDto)) {
            return false;
        }
        WsConversationDto wsConversationDto = (WsConversationDto) other;
        return Intrinsics.areEqual(this.id, wsConversationDto.id) && Intrinsics.areEqual((Object) this.appMakerLastRead, (Object) wsConversationDto.appMakerLastRead) && this.status == wsConversationDto.status && Intrinsics.areEqual(this.metadata, wsConversationDto.metadata);
    }

    public int hashCode() {
        String str = this.id;
        int iHashCode = (str == null ? 0 : str.hashCode()) * 31;
        Double d = this.appMakerLastRead;
        int iHashCode2 = (iHashCode + (d == null ? 0 : d.hashCode())) * 31;
        ConversationStatus conversationStatus = this.status;
        int iHashCode3 = (iHashCode2 + (conversationStatus == null ? 0 : conversationStatus.hashCode())) * 31;
        Map<String, Object> map = this.metadata;
        return iHashCode3 + (map != null ? map.hashCode() : 0);
    }

    public String toString() {
        return "WsConversationDto(id=" + this.id + ", appMakerLastRead=" + this.appMakerLastRead + ", status=" + this.status + ", metadata=" + this.metadata + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/faye/WsConversationDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/faye/WsConversationDto;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<WsConversationDto> serializer() {
            return WsConversationDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public WsConversationDto(int i, @SerialName("_id") String str, Double d, ConversationStatus conversationStatus, Map map, SerializationConstructorMarker serializationConstructorMarker) {
        if ((i & 1) == 0) {
            this.id = null;
        } else {
            this.id = str;
        }
        if ((i & 2) == 0) {
            this.appMakerLastRead = null;
        } else {
            this.appMakerLastRead = d;
        }
        if ((i & 4) == 0) {
            this.status = null;
        } else {
            this.status = conversationStatus;
        }
        if ((i & 8) == 0) {
            this.metadata = null;
        } else {
            this.metadata = map;
        }
    }

    public WsConversationDto(String str, Double d, ConversationStatus conversationStatus, Map<String, ? extends Object> map) {
        this.id = str;
        this.appMakerLastRead = d;
        this.status = conversationStatus;
        this.metadata = map;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(WsConversationDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        if (output.shouldEncodeElementDefault(serialDesc, 0) || self.id != null) {
            output.encodeNullableSerializableElement(serialDesc, 0, StringSerializer.INSTANCE, self.id);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 1) || self.appMakerLastRead != null) {
            output.encodeNullableSerializableElement(serialDesc, 1, DoubleSerializer.INSTANCE, self.appMakerLastRead);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 2) || self.status != null) {
            output.encodeNullableSerializableElement(serialDesc, 2, kSerializerArr[2], self.status);
        }
        if (!output.shouldEncodeElementDefault(serialDesc, 3) && self.metadata == null) {
            return;
        }
        output.encodeNullableSerializableElement(serialDesc, 3, kSerializerArr[3], self.metadata);
    }

    public WsConversationDto(String str, Double d, ConversationStatus conversationStatus, Map map, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? null : str, (i & 2) != 0 ? null : d, (i & 4) != 0 ? null : conversationStatus, (i & 8) != 0 ? null : map);
    }

    public final String getId() {
        return this.id;
    }

    public final Double getAppMakerLastRead() {
        return this.appMakerLastRead;
    }

    public final ConversationStatus getStatus() {
        return this.status;
    }

    public final Map<String, Object> getMetadata() {
        return this.metadata;
    }
}
