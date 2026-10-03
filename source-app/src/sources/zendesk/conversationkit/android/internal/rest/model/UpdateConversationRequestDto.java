package zendesk.conversationkit.android.internal.rest.model;

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
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.LinkedHashMapSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u0000J\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010$\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 #2\u00020\u0001:\u0002\"#B>\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\u0019\u0010\u0006\u001a\u0015\u0012\u0004\u0012\u00020\b\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\t\u0018\u00010\u0007\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u000b¢\u0006\u0002\u0010\fB*\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u001b\b\u0002\u0010\u0006\u001a\u0015\u0012\u0004\u0012\u00020\b\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\t\u0018\u00010\u0007¢\u0006\u0002\u0010\rJ\t\u0010\u0012\u001a\u00020\u0005HÆ\u0003J\u001c\u0010\u0013\u001a\u0015\u0012\u0004\u0012\u00020\b\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\t\u0018\u00010\u0007HÆ\u0003J0\u0010\u0014\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\u001b\b\u0002\u0010\u0006\u001a\u0015\u0012\u0004\u0012\u00020\b\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\t\u0018\u00010\u0007HÆ\u0001J\u0013\u0010\u0015\u001a\u00020\u00162\b\u0010\u0017\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0018\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0019\u001a\u00020\bHÖ\u0001J&\u0010\u001a\u001a\u00020\u001b2\u0006\u0010\u001c\u001a\u00020\u00002\u0006\u0010\u001d\u001a\u00020\u001e2\u0006\u0010\u001f\u001a\u00020 HÁ\u0001¢\u0006\u0002\b!R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR$\u0010\u0006\u001a\u0015\u0012\u0004\u0012\u00020\b\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\t\u0018\u00010\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011¨\u0006$"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/UpdateConversationRequestDto;", "", "seen1", "", "client", "Lzendesk/conversationkit/android/internal/rest/model/ClientDto;", "metadata", "", "", "Lkotlinx/serialization/Contextual;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/conversationkit/android/internal/rest/model/ClientDto;Ljava/util/Map;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Lzendesk/conversationkit/android/internal/rest/model/ClientDto;Ljava/util/Map;)V", "getClient", "()Lzendesk/conversationkit/android/internal/rest/model/ClientDto;", "getMetadata", "()Ljava/util/Map;", "component1", "component2", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class UpdateConversationRequestDto {
    private final ClientDto client;
    private final Map<String, Object> metadata;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {null, new LinkedHashMapSerializer(StringSerializer.INSTANCE, new ContextualSerializer(Reflection.getOrCreateKotlinClass(Object.class), null, new KSerializer[0]))};

    public static UpdateConversationRequestDto copy$default(UpdateConversationRequestDto updateConversationRequestDto, ClientDto clientDto, Map map, int i, Object obj) {
        if ((i & 1) != 0) {
            clientDto = updateConversationRequestDto.client;
        }
        if ((i & 2) != 0) {
            map = updateConversationRequestDto.metadata;
        }
        return updateConversationRequestDto.copy(clientDto, map);
    }

    public final ClientDto getClient() {
        return this.client;
    }

    public final Map<String, Object> component2() {
        return this.metadata;
    }

    public final UpdateConversationRequestDto copy(ClientDto client, Map<String, ? extends Object> metadata) {
        Intrinsics.checkNotNullParameter(client, "client");
        return new UpdateConversationRequestDto(client, metadata);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof UpdateConversationRequestDto)) {
            return false;
        }
        UpdateConversationRequestDto updateConversationRequestDto = (UpdateConversationRequestDto) other;
        return Intrinsics.areEqual(this.client, updateConversationRequestDto.client) && Intrinsics.areEqual(this.metadata, updateConversationRequestDto.metadata);
    }

    public int hashCode() {
        int iHashCode = this.client.hashCode() * 31;
        Map<String, Object> map = this.metadata;
        return iHashCode + (map == null ? 0 : map.hashCode());
    }

    public String toString() {
        return "UpdateConversationRequestDto(client=" + this.client + ", metadata=" + this.metadata + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/UpdateConversationRequestDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/UpdateConversationRequestDto;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<UpdateConversationRequestDto> serializer() {
            return UpdateConversationRequestDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public UpdateConversationRequestDto(int i, ClientDto clientDto, Map map, SerializationConstructorMarker serializationConstructorMarker) {
        if (1 != (i & 1)) {
            PluginExceptionsKt.throwMissingFieldException(i, 1, UpdateConversationRequestDto$$serializer.INSTANCE.getDescriptor());
        }
        this.client = clientDto;
        if ((i & 2) == 0) {
            this.metadata = null;
        } else {
            this.metadata = map;
        }
    }

    public UpdateConversationRequestDto(ClientDto client, Map<String, ? extends Object> map) {
        Intrinsics.checkNotNullParameter(client, "client");
        this.client = client;
        this.metadata = map;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(UpdateConversationRequestDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        output.encodeSerializableElement(serialDesc, 0, ClientDto$$serializer.INSTANCE, self.client);
        if (!output.shouldEncodeElementDefault(serialDesc, 1) && self.metadata == null) {
            return;
        }
        output.encodeNullableSerializableElement(serialDesc, 1, kSerializerArr[1], self.metadata);
    }

    public UpdateConversationRequestDto(ClientDto clientDto, Map map, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(clientDto, (i & 2) != 0 ? null : map);
    }

    public final ClientDto getClient() {
        return this.client;
    }

    public final Map<String, Object> getMetadata() {
        return this.metadata;
    }
}
