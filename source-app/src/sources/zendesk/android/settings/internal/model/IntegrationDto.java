package zendesk.android.settings.internal.model;

import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.SerialName;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;

@Metadata(m17d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0015\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 *2\u00020\u0001:\u0002)*B?\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0001\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\u0007\u0012\b\u0010\t\u001a\u0004\u0018\u00010\n\u0012\b\u0010\u000b\u001a\u0004\u0018\u00010\f¢\u0006\u0002\u0010\rB'\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\u0007\u0012\b\u0010\t\u001a\u0004\u0018\u00010\n¢\u0006\u0002\u0010\u000eJ\t\u0010\u0018\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0019\u001a\u00020\u0007HÆ\u0003J\t\u0010\u001a\u001a\u00020\u0007HÆ\u0003J\u000b\u0010\u001b\u001a\u0004\u0018\u00010\nHÆ\u0003J3\u0010\u001c\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\u00072\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\nHÆ\u0001J\u0013\u0010\u001d\u001a\u00020\u00072\b\u0010\u001e\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u001f\u001a\u00020\u0003HÖ\u0001J\t\u0010 \u001a\u00020\u0005HÖ\u0001J&\u0010!\u001a\u00020\"2\u0006\u0010#\u001a\u00020\u00002\u0006\u0010$\u001a\u00020%2\u0006\u0010&\u001a\u00020'HÁ\u0001¢\u0006\u0002\b(R\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u0011\u0010\b\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0010R\u001c\u0010\u0004\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0012\u0010\u0013\u001a\u0004\b\u0014\u0010\u0015R\u0013\u0010\t\u001a\u0004\u0018\u00010\n¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0017¨\u0006+"}, m18d2 = {"Lzendesk/android/settings/internal/model/IntegrationDto;", "", "seen1", "", "id", "", "canUserCreateMoreConversations", "", "canUserSeeConversationList", "waitConfig", "Lzendesk/android/settings/internal/model/WaitConfigDto;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;ZZLzendesk/android/settings/internal/model/WaitConfigDto;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;ZZLzendesk/android/settings/internal/model/WaitConfigDto;)V", "getCanUserCreateMoreConversations", "()Z", "getCanUserSeeConversationList", "getId$annotations", "()V", "getId", "()Ljava/lang/String;", "getWaitConfig", "()Lzendesk/android/settings/internal/model/WaitConfigDto;", "component1", "component2", "component3", "component4", "copy", "equals", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_zendesk_android", "$serializer", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class IntegrationDto {

    public static final Companion INSTANCE = new Companion(null);
    private final boolean canUserCreateMoreConversations;
    private final boolean canUserSeeConversationList;
    private final String id;
    private final WaitConfigDto waitConfig;

    public static IntegrationDto copy$default(IntegrationDto integrationDto, String str, boolean z, boolean z2, WaitConfigDto waitConfigDto, int i, Object obj) {
        if ((i & 1) != 0) {
            str = integrationDto.id;
        }
        if ((i & 2) != 0) {
            z = integrationDto.canUserCreateMoreConversations;
        }
        if ((i & 4) != 0) {
            z2 = integrationDto.canUserSeeConversationList;
        }
        if ((i & 8) != 0) {
            waitConfigDto = integrationDto.waitConfig;
        }
        return integrationDto.copy(str, z, z2, waitConfigDto);
    }

    @SerialName("_id")
    public static void getId$annotations() {
    }

    public final String getId() {
        return this.id;
    }

    public final boolean getCanUserCreateMoreConversations() {
        return this.canUserCreateMoreConversations;
    }

    public final boolean getCanUserSeeConversationList() {
        return this.canUserSeeConversationList;
    }

    public final WaitConfigDto getWaitConfig() {
        return this.waitConfig;
    }

    public final IntegrationDto copy(String id, boolean canUserCreateMoreConversations, boolean canUserSeeConversationList, WaitConfigDto waitConfig) {
        Intrinsics.checkNotNullParameter(id, "id");
        return new IntegrationDto(id, canUserCreateMoreConversations, canUserSeeConversationList, waitConfig);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof IntegrationDto)) {
            return false;
        }
        IntegrationDto integrationDto = (IntegrationDto) other;
        return Intrinsics.areEqual(this.id, integrationDto.id) && this.canUserCreateMoreConversations == integrationDto.canUserCreateMoreConversations && this.canUserSeeConversationList == integrationDto.canUserSeeConversationList && Intrinsics.areEqual(this.waitConfig, integrationDto.waitConfig);
    }

    public int hashCode() {
        int iHashCode = ((((this.id.hashCode() * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.canUserCreateMoreConversations)) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.canUserSeeConversationList)) * 31;
        WaitConfigDto waitConfigDto = this.waitConfig;
        return iHashCode + (waitConfigDto == null ? 0 : waitConfigDto.hashCode());
    }

    public String toString() {
        return "IntegrationDto(id=" + this.id + ", canUserCreateMoreConversations=" + this.canUserCreateMoreConversations + ", canUserSeeConversationList=" + this.canUserSeeConversationList + ", waitConfig=" + this.waitConfig + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/settings/internal/model/IntegrationDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/settings/internal/model/IntegrationDto;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<IntegrationDto> serializer() {
            return IntegrationDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public IntegrationDto(int i, @SerialName("_id") String str, boolean z, boolean z2, WaitConfigDto waitConfigDto, SerializationConstructorMarker serializationConstructorMarker) {
        if (15 != (i & 15)) {
            PluginExceptionsKt.throwMissingFieldException(i, 15, IntegrationDto$$serializer.INSTANCE.getDescriptor());
        }
        this.id = str;
        this.canUserCreateMoreConversations = z;
        this.canUserSeeConversationList = z2;
        this.waitConfig = waitConfigDto;
    }

    public IntegrationDto(String id, boolean z, boolean z2, WaitConfigDto waitConfigDto) {
        Intrinsics.checkNotNullParameter(id, "id");
        this.id = id;
        this.canUserCreateMoreConversations = z;
        this.canUserSeeConversationList = z2;
        this.waitConfig = waitConfigDto;
    }

    @JvmStatic
    public static final void write$Self$zendesk_zendesk_android(IntegrationDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeStringElement(serialDesc, 0, self.id);
        output.encodeBooleanElement(serialDesc, 1, self.canUserCreateMoreConversations);
        output.encodeBooleanElement(serialDesc, 2, self.canUserSeeConversationList);
        output.encodeNullableSerializableElement(serialDesc, 3, WaitConfigDto$$serializer.INSTANCE, self.waitConfig);
    }

    public final String getId() {
        return this.id;
    }

    public final boolean getCanUserCreateMoreConversations() {
        return this.canUserCreateMoreConversations;
    }

    public final boolean getCanUserSeeConversationList() {
        return this.canUserSeeConversationList;
    }

    public final WaitConfigDto getWaitConfig() {
        return this.waitConfig;
    }
}
