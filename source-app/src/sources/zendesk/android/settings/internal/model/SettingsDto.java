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
import kotlinx.serialization.internal.BooleanSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u0000P\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b$\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 >2\u00020\u0001:\u0002=>Bi\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\n\b\u0001\u0010\b\u001a\u0004\u0018\u00010\u0007\u0012\n\b\u0001\u0010\t\u001a\u0004\u0018\u00010\n\u0012\b\b\u0001\u0010\u000b\u001a\u00020\n\u0012\n\b\u0001\u0010\f\u001a\u0004\u0018\u00010\r\u0012\n\b\u0001\u0010\u000e\u001a\u0004\u0018\u00010\u000f\u0012\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011¢\u0006\u0002\u0010\u0012BG\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\u0007\u0012\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\n\u0012\u0006\u0010\u000b\u001a\u00020\n\u0012\u0006\u0010\f\u001a\u00020\r\u0012\n\b\u0002\u0010\u000e\u001a\u0004\u0018\u00010\u000f¢\u0006\u0002\u0010\u0013J\u000b\u0010(\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\t\u0010)\u001a\u00020\u0007HÆ\u0003J\t\u0010*\u001a\u00020\u0007HÆ\u0003J\u0010\u0010+\u001a\u0004\u0018\u00010\nHÆ\u0003¢\u0006\u0002\u0010#J\t\u0010,\u001a\u00020\nHÆ\u0003J\t\u0010-\u001a\u00020\rHÆ\u0003J\u000b\u0010.\u001a\u0004\u0018\u00010\u000fHÆ\u0003JZ\u0010/\u001a\u00020\u00002\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\u00072\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\n2\b\b\u0002\u0010\u000b\u001a\u00020\n2\b\b\u0002\u0010\f\u001a\u00020\r2\n\b\u0002\u0010\u000e\u001a\u0004\u0018\u00010\u000fHÆ\u0001¢\u0006\u0002\u00100J\u0013\u00101\u001a\u00020\n2\b\u00102\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u00103\u001a\u00020\u0003HÖ\u0001J\t\u00104\u001a\u00020\u0005HÖ\u0001J&\u00105\u001a\u0002062\u0006\u00107\u001a\u00020\u00002\u0006\u00108\u001a\u0002092\u0006\u0010:\u001a\u00020;HÁ\u0001¢\u0006\u0002\b<R\u001c\u0010\b\u001a\u00020\u00078\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0014\u0010\u0015\u001a\u0004\b\u0016\u0010\u0017R\u0013\u0010\u0004\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0019R\u001c\u0010\u000b\u001a\u00020\n8\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u001a\u0010\u0015\u001a\u0004\b\u000b\u0010\u001bR\u001c\u0010\u0006\u001a\u00020\u00078\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u001c\u0010\u0015\u001a\u0004\b\u001d\u0010\u0017R\u001c\u0010\f\u001a\u00020\r8\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u001e\u0010\u0015\u001a\u0004\b\u001f\u0010 R \u0010\t\u001a\u0004\u0018\u00010\n8\u0006X\u0087\u0004¢\u0006\u0010\n\u0002\u0010$\u0012\u0004\b!\u0010\u0015\u001a\u0004\b\"\u0010#R\u001e\u0010\u000e\u001a\u0004\u0018\u00010\u000f8\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b%\u0010\u0015\u001a\u0004\b&\u0010'¨\u0006?"}, m18d2 = {"Lzendesk/android/settings/internal/model/SettingsDto;", "", "seen1", "", "identifier", "", "lightTheme", "Lzendesk/android/settings/internal/model/ColorThemeDto;", "darkTheme", "showZendeskLogo", "", "isAttachmentsEnabled", "nativeMessaging", "Lzendesk/android/settings/internal/model/NativeMessagingDto;", "sunCoConfigDto", "Lzendesk/android/settings/internal/model/SunCoConfigDto;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Lzendesk/android/settings/internal/model/ColorThemeDto;Lzendesk/android/settings/internal/model/ColorThemeDto;Ljava/lang/Boolean;ZLzendesk/android/settings/internal/model/NativeMessagingDto;Lzendesk/android/settings/internal/model/SunCoConfigDto;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Lzendesk/android/settings/internal/model/ColorThemeDto;Lzendesk/android/settings/internal/model/ColorThemeDto;Ljava/lang/Boolean;ZLzendesk/android/settings/internal/model/NativeMessagingDto;Lzendesk/android/settings/internal/model/SunCoConfigDto;)V", "getDarkTheme$annotations", "()V", "getDarkTheme", "()Lzendesk/android/settings/internal/model/ColorThemeDto;", "getIdentifier", "()Ljava/lang/String;", "isAttachmentsEnabled$annotations", "()Z", "getLightTheme$annotations", "getLightTheme", "getNativeMessaging$annotations", "getNativeMessaging", "()Lzendesk/android/settings/internal/model/NativeMessagingDto;", "getShowZendeskLogo$annotations", "getShowZendeskLogo", "()Ljava/lang/Boolean;", "Ljava/lang/Boolean;", "getSunCoConfigDto$annotations", "getSunCoConfigDto", "()Lzendesk/android/settings/internal/model/SunCoConfigDto;", "component1", "component2", "component3", "component4", "component5", "component6", "component7", "copy", "(Ljava/lang/String;Lzendesk/android/settings/internal/model/ColorThemeDto;Lzendesk/android/settings/internal/model/ColorThemeDto;Ljava/lang/Boolean;ZLzendesk/android/settings/internal/model/NativeMessagingDto;Lzendesk/android/settings/internal/model/SunCoConfigDto;)Lzendesk/android/settings/internal/model/SettingsDto;", "equals", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_zendesk_android", "$serializer", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class SettingsDto {

    public static final Companion INSTANCE = new Companion(null);
    private final ColorThemeDto darkTheme;
    private final String identifier;
    private final boolean isAttachmentsEnabled;
    private final ColorThemeDto lightTheme;
    private final NativeMessagingDto nativeMessaging;
    private final Boolean showZendeskLogo;
    private final SunCoConfigDto sunCoConfigDto;

    public static SettingsDto copy$default(SettingsDto settingsDto, String str, ColorThemeDto colorThemeDto, ColorThemeDto colorThemeDto2, Boolean bool, boolean z, NativeMessagingDto nativeMessagingDto, SunCoConfigDto sunCoConfigDto, int i, Object obj) {
        if ((i & 1) != 0) {
            str = settingsDto.identifier;
        }
        if ((i & 2) != 0) {
            colorThemeDto = settingsDto.lightTheme;
        }
        ColorThemeDto colorThemeDto3 = colorThemeDto;
        if ((i & 4) != 0) {
            colorThemeDto2 = settingsDto.darkTheme;
        }
        ColorThemeDto colorThemeDto4 = colorThemeDto2;
        if ((i & 8) != 0) {
            bool = settingsDto.showZendeskLogo;
        }
        Boolean bool2 = bool;
        if ((i & 16) != 0) {
            z = settingsDto.isAttachmentsEnabled;
        }
        boolean z2 = z;
        if ((i & 32) != 0) {
            nativeMessagingDto = settingsDto.nativeMessaging;
        }
        NativeMessagingDto nativeMessagingDto2 = nativeMessagingDto;
        if ((i & 64) != 0) {
            sunCoConfigDto = settingsDto.sunCoConfigDto;
        }
        return settingsDto.copy(str, colorThemeDto3, colorThemeDto4, bool2, z2, nativeMessagingDto2, sunCoConfigDto);
    }

    @SerialName("dark_theme")
    public static void getDarkTheme$annotations() {
    }

    @SerialName("light_theme")
    public static void getLightTheme$annotations() {
    }

    @SerialName("native_messaging")
    public static void getNativeMessaging$annotations() {
    }

    @SerialName("show_zendesk_logo")
    public static void getShowZendeskLogo$annotations() {
    }

    @SerialName("sunco_config")
    public static void getSunCoConfigDto$annotations() {
    }

    @SerialName("attachments_enabled")
    public static void isAttachmentsEnabled$annotations() {
    }

    public final String getIdentifier() {
        return this.identifier;
    }

    public final ColorThemeDto getLightTheme() {
        return this.lightTheme;
    }

    public final ColorThemeDto getDarkTheme() {
        return this.darkTheme;
    }

    public final Boolean getShowZendeskLogo() {
        return this.showZendeskLogo;
    }

    public final boolean getIsAttachmentsEnabled() {
        return this.isAttachmentsEnabled;
    }

    public final NativeMessagingDto getNativeMessaging() {
        return this.nativeMessaging;
    }

    public final SunCoConfigDto getSunCoConfigDto() {
        return this.sunCoConfigDto;
    }

    public final SettingsDto copy(String identifier, ColorThemeDto lightTheme, ColorThemeDto darkTheme, Boolean showZendeskLogo, boolean isAttachmentsEnabled, NativeMessagingDto nativeMessaging, SunCoConfigDto sunCoConfigDto) {
        Intrinsics.checkNotNullParameter(lightTheme, "lightTheme");
        Intrinsics.checkNotNullParameter(darkTheme, "darkTheme");
        Intrinsics.checkNotNullParameter(nativeMessaging, "nativeMessaging");
        return new SettingsDto(identifier, lightTheme, darkTheme, showZendeskLogo, isAttachmentsEnabled, nativeMessaging, sunCoConfigDto);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof SettingsDto)) {
            return false;
        }
        SettingsDto settingsDto = (SettingsDto) other;
        return Intrinsics.areEqual(this.identifier, settingsDto.identifier) && Intrinsics.areEqual(this.lightTheme, settingsDto.lightTheme) && Intrinsics.areEqual(this.darkTheme, settingsDto.darkTheme) && Intrinsics.areEqual(this.showZendeskLogo, settingsDto.showZendeskLogo) && this.isAttachmentsEnabled == settingsDto.isAttachmentsEnabled && Intrinsics.areEqual(this.nativeMessaging, settingsDto.nativeMessaging) && Intrinsics.areEqual(this.sunCoConfigDto, settingsDto.sunCoConfigDto);
    }

    public int hashCode() {
        String str = this.identifier;
        int iHashCode = (((((str == null ? 0 : str.hashCode()) * 31) + this.lightTheme.hashCode()) * 31) + this.darkTheme.hashCode()) * 31;
        Boolean bool = this.showZendeskLogo;
        int iHashCode2 = (((((iHashCode + (bool == null ? 0 : bool.hashCode())) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.isAttachmentsEnabled)) * 31) + this.nativeMessaging.hashCode()) * 31;
        SunCoConfigDto sunCoConfigDto = this.sunCoConfigDto;
        return iHashCode2 + (sunCoConfigDto != null ? sunCoConfigDto.hashCode() : 0);
    }

    public String toString() {
        return "SettingsDto(identifier=" + this.identifier + ", lightTheme=" + this.lightTheme + ", darkTheme=" + this.darkTheme + ", showZendeskLogo=" + this.showZendeskLogo + ", isAttachmentsEnabled=" + this.isAttachmentsEnabled + ", nativeMessaging=" + this.nativeMessaging + ", sunCoConfigDto=" + this.sunCoConfigDto + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/settings/internal/model/SettingsDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/settings/internal/model/SettingsDto;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<SettingsDto> serializer() {
            return SettingsDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public SettingsDto(int i, String str, @SerialName("light_theme") ColorThemeDto colorThemeDto, @SerialName("dark_theme") ColorThemeDto colorThemeDto2, @SerialName("show_zendesk_logo") Boolean bool, @SerialName("attachments_enabled") boolean z, @SerialName("native_messaging") NativeMessagingDto nativeMessagingDto, @SerialName("sunco_config") SunCoConfigDto sunCoConfigDto, SerializationConstructorMarker serializationConstructorMarker) {
        if (55 != (i & 55)) {
            PluginExceptionsKt.throwMissingFieldException(i, 55, SettingsDto$$serializer.INSTANCE.getDescriptor());
        }
        this.identifier = str;
        this.lightTheme = colorThemeDto;
        this.darkTheme = colorThemeDto2;
        if ((i & 8) == 0) {
            this.showZendeskLogo = null;
        } else {
            this.showZendeskLogo = bool;
        }
        this.isAttachmentsEnabled = z;
        this.nativeMessaging = nativeMessagingDto;
        if ((i & 64) == 0) {
            this.sunCoConfigDto = null;
        } else {
            this.sunCoConfigDto = sunCoConfigDto;
        }
    }

    public SettingsDto(String str, ColorThemeDto lightTheme, ColorThemeDto darkTheme, Boolean bool, boolean z, NativeMessagingDto nativeMessaging, SunCoConfigDto sunCoConfigDto) {
        Intrinsics.checkNotNullParameter(lightTheme, "lightTheme");
        Intrinsics.checkNotNullParameter(darkTheme, "darkTheme");
        Intrinsics.checkNotNullParameter(nativeMessaging, "nativeMessaging");
        this.identifier = str;
        this.lightTheme = lightTheme;
        this.darkTheme = darkTheme;
        this.showZendeskLogo = bool;
        this.isAttachmentsEnabled = z;
        this.nativeMessaging = nativeMessaging;
        this.sunCoConfigDto = sunCoConfigDto;
    }

    @JvmStatic
    public static final void write$Self$zendesk_zendesk_android(SettingsDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeNullableSerializableElement(serialDesc, 0, StringSerializer.INSTANCE, self.identifier);
        output.encodeSerializableElement(serialDesc, 1, ColorThemeDto$$serializer.INSTANCE, self.lightTheme);
        output.encodeSerializableElement(serialDesc, 2, ColorThemeDto$$serializer.INSTANCE, self.darkTheme);
        if (output.shouldEncodeElementDefault(serialDesc, 3) || self.showZendeskLogo != null) {
            output.encodeNullableSerializableElement(serialDesc, 3, BooleanSerializer.INSTANCE, self.showZendeskLogo);
        }
        output.encodeBooleanElement(serialDesc, 4, self.isAttachmentsEnabled);
        output.encodeSerializableElement(serialDesc, 5, NativeMessagingDto$$serializer.INSTANCE, self.nativeMessaging);
        if (!output.shouldEncodeElementDefault(serialDesc, 6) && self.sunCoConfigDto == null) {
            return;
        }
        output.encodeNullableSerializableElement(serialDesc, 6, SunCoConfigDto$$serializer.INSTANCE, self.sunCoConfigDto);
    }

    public SettingsDto(String str, ColorThemeDto colorThemeDto, ColorThemeDto colorThemeDto2, Boolean bool, boolean z, NativeMessagingDto nativeMessagingDto, SunCoConfigDto sunCoConfigDto, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(str, colorThemeDto, colorThemeDto2, (i & 8) != 0 ? null : bool, z, nativeMessagingDto, (i & 64) != 0 ? null : sunCoConfigDto);
    }

    public final String getIdentifier() {
        return this.identifier;
    }

    public final ColorThemeDto getLightTheme() {
        return this.lightTheme;
    }

    public final ColorThemeDto getDarkTheme() {
        return this.darkTheme;
    }

    public final Boolean getShowZendeskLogo() {
        return this.showZendeskLogo;
    }

    public final boolean isAttachmentsEnabled() {
        return this.isAttachmentsEnabled;
    }

    public final NativeMessagingDto getNativeMessaging() {
        return this.nativeMessaging;
    }

    public final SunCoConfigDto getSunCoConfigDto() {
        return this.sunCoConfigDto;
    }
}
