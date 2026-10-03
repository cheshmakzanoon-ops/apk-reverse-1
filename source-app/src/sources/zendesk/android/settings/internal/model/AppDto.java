package zendesk.android.settings.internal.model;

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
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;

@Metadata(m17d1 = {"\u0000D\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0010\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 )2\u00020\u0001:\u0002()BC\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0001\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\b\u001a\u0004\u0018\u00010\t\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u000b¢\u0006\u0002\u0010\fB%\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\u0005\u0012\u0006\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\rJ\t\u0010\u0016\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0017\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0018\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0019\u001a\u00020\tHÆ\u0003J1\u0010\u001a\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\b\b\u0002\u0010\u0007\u001a\u00020\u00052\b\b\u0002\u0010\b\u001a\u00020\tHÆ\u0001J\u0013\u0010\u001b\u001a\u00020\u001c2\b\u0010\u001d\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u001e\u001a\u00020\u0003HÖ\u0001J\t\u0010\u001f\u001a\u00020\u0005HÖ\u0001J&\u0010 \u001a\u00020!2\u0006\u0010\"\u001a\u00020\u00002\u0006\u0010#\u001a\u00020$2\u0006\u0010%\u001a\u00020&HÁ\u0001¢\u0006\u0002\b'R\u001c\u0010\u0004\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u000e\u0010\u000f\u001a\u0004\b\u0010\u0010\u0011R\u0011\u0010\u0007\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0011R\u0011\u0010\b\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0011¨\u0006*"}, m18d2 = {"Lzendesk/android/settings/internal/model/AppDto;", "", "seen1", "", "id", "", "status", "name", "settings", "Lzendesk/android/settings/internal/model/AppSettingsDto;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/android/settings/internal/model/AppSettingsDto;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/android/settings/internal/model/AppSettingsDto;)V", "getId$annotations", "()V", "getId", "()Ljava/lang/String;", "getName", "getSettings", "()Lzendesk/android/settings/internal/model/AppSettingsDto;", "getStatus", "component1", "component2", "component3", "component4", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_zendesk_android", "$serializer", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class AppDto {

    public static final Companion INSTANCE = new Companion(null);
    private final String id;
    private final String name;
    private final AppSettingsDto settings;
    private final String status;

    public static AppDto copy$default(AppDto appDto, String str, String str2, String str3, AppSettingsDto appSettingsDto, int i, Object obj) {
        if ((i & 1) != 0) {
            str = appDto.id;
        }
        if ((i & 2) != 0) {
            str2 = appDto.status;
        }
        if ((i & 4) != 0) {
            str3 = appDto.name;
        }
        if ((i & 8) != 0) {
            appSettingsDto = appDto.settings;
        }
        return appDto.copy(str, str2, str3, appSettingsDto);
    }

    @SerialName("_id")
    public static void getId$annotations() {
    }

    public final String getId() {
        return this.id;
    }

    public final String getStatus() {
        return this.status;
    }

    public final String getName() {
        return this.name;
    }

    public final AppSettingsDto getSettings() {
        return this.settings;
    }

    public final AppDto copy(String id, String status, String name, AppSettingsDto settings) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(status, "status");
        Intrinsics.checkNotNullParameter(name, "name");
        Intrinsics.checkNotNullParameter(settings, "settings");
        return new AppDto(id, status, name, settings);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof AppDto)) {
            return false;
        }
        AppDto appDto = (AppDto) other;
        return Intrinsics.areEqual(this.id, appDto.id) && Intrinsics.areEqual(this.status, appDto.status) && Intrinsics.areEqual(this.name, appDto.name) && Intrinsics.areEqual(this.settings, appDto.settings);
    }

    public int hashCode() {
        return (((((this.id.hashCode() * 31) + this.status.hashCode()) * 31) + this.name.hashCode()) * 31) + this.settings.hashCode();
    }

    public String toString() {
        return "AppDto(id=" + this.id + ", status=" + this.status + ", name=" + this.name + ", settings=" + this.settings + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/settings/internal/model/AppDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/settings/internal/model/AppDto;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<AppDto> serializer() {
            return AppDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public AppDto(int i, @SerialName("_id") String str, String str2, String str3, AppSettingsDto appSettingsDto, SerializationConstructorMarker serializationConstructorMarker) {
        if (15 != (i & 15)) {
            PluginExceptionsKt.throwMissingFieldException(i, 15, AppDto$$serializer.INSTANCE.getDescriptor());
        }
        this.id = str;
        this.status = str2;
        this.name = str3;
        this.settings = appSettingsDto;
    }

    public AppDto(String id, String status, String name, AppSettingsDto settings) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(status, "status");
        Intrinsics.checkNotNullParameter(name, "name");
        Intrinsics.checkNotNullParameter(settings, "settings");
        this.id = id;
        this.status = status;
        this.name = name;
        this.settings = settings;
    }

    @JvmStatic
    public static final void write$Self$zendesk_zendesk_android(AppDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeStringElement(serialDesc, 0, self.id);
        output.encodeStringElement(serialDesc, 1, self.status);
        output.encodeStringElement(serialDesc, 2, self.name);
        output.encodeSerializableElement(serialDesc, 3, AppSettingsDto$$serializer.INSTANCE, self.settings);
    }

    public final String getId() {
        return this.id;
    }

    public final String getStatus() {
        return this.status;
    }

    public final String getName() {
        return this.name;
    }

    public final AppSettingsDto getSettings() {
        return this.settings;
    }
}
