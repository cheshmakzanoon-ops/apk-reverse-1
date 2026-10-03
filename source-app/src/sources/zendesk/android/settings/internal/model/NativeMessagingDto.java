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
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u0000D\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u001c\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 42\u00020\u0001:\u000234Ba\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0001\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\u0006\u0010\u0007\u001a\u00020\b\u0012\b\u0010\t\u001a\u0004\u0018\u00010\n\u0012\b\u0010\u000b\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\f\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\r\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u000e\u001a\u0004\u0018\u00010\u000f¢\u0006\u0002\u0010\u0010BU\u0012\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\u0006\u0010\u0007\u001a\u00020\b\u0012\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\n\u0012\n\b\u0002\u0010\u000b\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0002\u0010\f\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u0005¢\u0006\u0002\u0010\u0011J\u000b\u0010\u001f\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u0010 \u001a\u0004\u0018\u00010\u0005HÆ\u0003J\t\u0010!\u001a\u00020\bHÆ\u0003J\u000b\u0010\"\u001a\u0004\u0018\u00010\nHÆ\u0003J\u000b\u0010#\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u0010$\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u0010%\u001a\u0004\u0018\u00010\u0005HÆ\u0003J[\u0010&\u001a\u00020\u00002\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u00052\b\b\u0002\u0010\u0007\u001a\u00020\b2\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\n2\n\b\u0002\u0010\u000b\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\f\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u0005HÆ\u0001J\u0013\u0010'\u001a\u00020\b2\b\u0010(\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010)\u001a\u00020\u0003HÖ\u0001J\t\u0010*\u001a\u00020\u0005HÖ\u0001J&\u0010+\u001a\u00020,2\u0006\u0010-\u001a\u00020\u00002\u0006\u0010.\u001a\u00020/2\u0006\u00100\u001a\u000201HÁ\u0001¢\u0006\u0002\b2R\u0013\u0010\t\u001a\u0004\u0018\u00010\n¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013R\u0013\u0010\f\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0015R\u0011\u0010\u0007\u001a\u00020\b¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0017R\u001e\u0010\u0004\u001a\u0004\u0018\u00010\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0018\u0010\u0019\u001a\u0004\b\u001a\u0010\u0015R\u001e\u0010\r\u001a\u0004\u0018\u00010\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u001b\u0010\u0019\u001a\u0004\b\u001c\u0010\u0015R\u0013\u0010\u0006\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u0015R\u0013\u0010\u000b\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001e\u0010\u0015¨\u00065"}, m18d2 = {"Lzendesk/android/settings/internal/model/NativeMessagingDto;", "", "seen1", "", "integrationId", "", "platform", "enabled", "", "brand", "Lzendesk/android/settings/internal/model/BrandDto;", "title", "description", "logoUrl", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;ZLzendesk/android/settings/internal/model/BrandDto;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;ZLzendesk/android/settings/internal/model/BrandDto;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", "getBrand", "()Lzendesk/android/settings/internal/model/BrandDto;", "getDescription", "()Ljava/lang/String;", "getEnabled", "()Z", "getIntegrationId$annotations", "()V", "getIntegrationId", "getLogoUrl$annotations", "getLogoUrl", "getPlatform", "getTitle", "component1", "component2", "component3", "component4", "component5", "component6", "component7", "copy", "equals", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_zendesk_android", "$serializer", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class NativeMessagingDto {

    public static final Companion INSTANCE = new Companion(null);
    private final BrandDto brand;
    private final String description;
    private final boolean enabled;
    private final String integrationId;
    private final String logoUrl;
    private final String platform;
    private final String title;

    public static NativeMessagingDto copy$default(NativeMessagingDto nativeMessagingDto, String str, String str2, boolean z, BrandDto brandDto, String str3, String str4, String str5, int i, Object obj) {
        if ((i & 1) != 0) {
            str = nativeMessagingDto.integrationId;
        }
        if ((i & 2) != 0) {
            str2 = nativeMessagingDto.platform;
        }
        String str6 = str2;
        if ((i & 4) != 0) {
            z = nativeMessagingDto.enabled;
        }
        boolean z2 = z;
        if ((i & 8) != 0) {
            brandDto = nativeMessagingDto.brand;
        }
        BrandDto brandDto2 = brandDto;
        if ((i & 16) != 0) {
            str3 = nativeMessagingDto.title;
        }
        String str7 = str3;
        if ((i & 32) != 0) {
            str4 = nativeMessagingDto.description;
        }
        String str8 = str4;
        if ((i & 64) != 0) {
            str5 = nativeMessagingDto.logoUrl;
        }
        return nativeMessagingDto.copy(str, str6, z2, brandDto2, str7, str8, str5);
    }

    @SerialName("integration_id")
    public static void getIntegrationId$annotations() {
    }

    @SerialName("logo_url")
    public static void getLogoUrl$annotations() {
    }

    public final String getIntegrationId() {
        return this.integrationId;
    }

    public final String getPlatform() {
        return this.platform;
    }

    public final boolean getEnabled() {
        return this.enabled;
    }

    public final BrandDto getBrand() {
        return this.brand;
    }

    public final String getTitle() {
        return this.title;
    }

    public final String getDescription() {
        return this.description;
    }

    public final String getLogoUrl() {
        return this.logoUrl;
    }

    public final NativeMessagingDto copy(String integrationId, String platform, boolean enabled, BrandDto brand, String title, String description, String logoUrl) {
        return new NativeMessagingDto(integrationId, platform, enabled, brand, title, description, logoUrl);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof NativeMessagingDto)) {
            return false;
        }
        NativeMessagingDto nativeMessagingDto = (NativeMessagingDto) other;
        return Intrinsics.areEqual(this.integrationId, nativeMessagingDto.integrationId) && Intrinsics.areEqual(this.platform, nativeMessagingDto.platform) && this.enabled == nativeMessagingDto.enabled && Intrinsics.areEqual(this.brand, nativeMessagingDto.brand) && Intrinsics.areEqual(this.title, nativeMessagingDto.title) && Intrinsics.areEqual(this.description, nativeMessagingDto.description) && Intrinsics.areEqual(this.logoUrl, nativeMessagingDto.logoUrl);
    }

    public int hashCode() {
        String str = this.integrationId;
        int iHashCode = (str == null ? 0 : str.hashCode()) * 31;
        String str2 = this.platform;
        int iHashCode2 = (((iHashCode + (str2 == null ? 0 : str2.hashCode())) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.enabled)) * 31;
        BrandDto brandDto = this.brand;
        int iHashCode3 = (iHashCode2 + (brandDto == null ? 0 : brandDto.hashCode())) * 31;
        String str3 = this.title;
        int iHashCode4 = (iHashCode3 + (str3 == null ? 0 : str3.hashCode())) * 31;
        String str4 = this.description;
        int iHashCode5 = (iHashCode4 + (str4 == null ? 0 : str4.hashCode())) * 31;
        String str5 = this.logoUrl;
        return iHashCode5 + (str5 != null ? str5.hashCode() : 0);
    }

    public String toString() {
        return "NativeMessagingDto(integrationId=" + this.integrationId + ", platform=" + this.platform + ", enabled=" + this.enabled + ", brand=" + this.brand + ", title=" + this.title + ", description=" + this.description + ", logoUrl=" + this.logoUrl + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/settings/internal/model/NativeMessagingDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/settings/internal/model/NativeMessagingDto;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<NativeMessagingDto> serializer() {
            return NativeMessagingDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public NativeMessagingDto(int i, @SerialName("integration_id") String str, String str2, boolean z, BrandDto brandDto, String str3, String str4, @SerialName("logo_url") String str5, SerializationConstructorMarker serializationConstructorMarker) {
        if (4 != (i & 4)) {
            PluginExceptionsKt.throwMissingFieldException(i, 4, NativeMessagingDto$$serializer.INSTANCE.getDescriptor());
        }
        if ((i & 1) == 0) {
            this.integrationId = null;
        } else {
            this.integrationId = str;
        }
        if ((i & 2) == 0) {
            this.platform = null;
        } else {
            this.platform = str2;
        }
        this.enabled = z;
        if ((i & 8) == 0) {
            this.brand = null;
        } else {
            this.brand = brandDto;
        }
        if ((i & 16) == 0) {
            this.title = null;
        } else {
            this.title = str3;
        }
        if ((i & 32) == 0) {
            this.description = null;
        } else {
            this.description = str4;
        }
        if ((i & 64) == 0) {
            this.logoUrl = null;
        } else {
            this.logoUrl = str5;
        }
    }

    public NativeMessagingDto(String str, String str2, boolean z, BrandDto brandDto, String str3, String str4, String str5) {
        this.integrationId = str;
        this.platform = str2;
        this.enabled = z;
        this.brand = brandDto;
        this.title = str3;
        this.description = str4;
        this.logoUrl = str5;
    }

    @JvmStatic
    public static final void write$Self$zendesk_zendesk_android(NativeMessagingDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        if (output.shouldEncodeElementDefault(serialDesc, 0) || self.integrationId != null) {
            output.encodeNullableSerializableElement(serialDesc, 0, StringSerializer.INSTANCE, self.integrationId);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 1) || self.platform != null) {
            output.encodeNullableSerializableElement(serialDesc, 1, StringSerializer.INSTANCE, self.platform);
        }
        output.encodeBooleanElement(serialDesc, 2, self.enabled);
        if (output.shouldEncodeElementDefault(serialDesc, 3) || self.brand != null) {
            output.encodeNullableSerializableElement(serialDesc, 3, BrandDto$$serializer.INSTANCE, self.brand);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 4) || self.title != null) {
            output.encodeNullableSerializableElement(serialDesc, 4, StringSerializer.INSTANCE, self.title);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 5) || self.description != null) {
            output.encodeNullableSerializableElement(serialDesc, 5, StringSerializer.INSTANCE, self.description);
        }
        if (!output.shouldEncodeElementDefault(serialDesc, 6) && self.logoUrl == null) {
            return;
        }
        output.encodeNullableSerializableElement(serialDesc, 6, StringSerializer.INSTANCE, self.logoUrl);
    }

    public NativeMessagingDto(String str, String str2, boolean z, BrandDto brandDto, String str3, String str4, String str5, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? null : str, (i & 2) != 0 ? null : str2, z, (i & 8) != 0 ? null : brandDto, (i & 16) != 0 ? null : str3, (i & 32) != 0 ? null : str4, (i & 64) != 0 ? null : str5);
    }

    public final String getIntegrationId() {
        return this.integrationId;
    }

    public final String getPlatform() {
        return this.platform;
    }

    public final boolean getEnabled() {
        return this.enabled;
    }

    public final BrandDto getBrand() {
        return this.brand;
    }

    public final String getTitle() {
        return this.title;
    }

    public final String getDescription() {
        return this.description;
    }

    public final String getLogoUrl() {
        return this.logoUrl;
    }
}
