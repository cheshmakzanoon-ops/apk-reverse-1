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
import kotlinx.serialization.internal.BooleanSerializer;
import kotlinx.serialization.internal.LongSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u0000D\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\t\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b'\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 A2\u00020\u0001:\u0002@AB\u007f\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\b\u0012\b\u0010\t\u001a\u0004\u0018\u00010\n\u0012\n\b\u0001\u0010\u000b\u001a\u0004\u0018\u00010\b\u0012\n\b\u0001\u0010\f\u001a\u0004\u0018\u00010\b\u0012\n\b\u0001\u0010\r\u001a\u0004\u0018\u00010\b\u0012\n\b\u0001\u0010\u000e\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u000f\u001a\u0004\u0018\u00010\b\u0012\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011¢\u0006\u0002\u0010\u0012Bo\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\b\u0012\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\n\u0012\n\b\u0002\u0010\u000b\u001a\u0004\u0018\u00010\b\u0012\n\b\u0002\u0010\f\u001a\u0004\u0018\u00010\b\u0012\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\b\u0012\n\b\u0002\u0010\u000e\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\b¢\u0006\u0002\u0010\u0013J\u0010\u0010)\u001a\u0004\u0018\u00010\u0005HÆ\u0003¢\u0006\u0002\u0010\u0017J\u0010\u0010*\u001a\u0004\u0018\u00010\u0005HÆ\u0003¢\u0006\u0002\u0010\u0017J\u000b\u0010+\u001a\u0004\u0018\u00010\bHÆ\u0003J\u0010\u0010,\u001a\u0004\u0018\u00010\nHÆ\u0003¢\u0006\u0002\u0010\u001aJ\u000b\u0010-\u001a\u0004\u0018\u00010\bHÆ\u0003J\u000b\u0010.\u001a\u0004\u0018\u00010\bHÆ\u0003J\u000b\u0010/\u001a\u0004\u0018\u00010\bHÆ\u0003J\u0010\u00100\u001a\u0004\u0018\u00010\u0005HÆ\u0003¢\u0006\u0002\u0010\u0017J\u000b\u00101\u001a\u0004\u0018\u00010\bHÆ\u0003Jz\u00102\u001a\u00020\u00002\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\b2\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\n2\n\b\u0002\u0010\u000b\u001a\u0004\u0018\u00010\b2\n\b\u0002\u0010\f\u001a\u0004\u0018\u00010\b2\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\b2\n\b\u0002\u0010\u000e\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\bHÆ\u0001¢\u0006\u0002\u00103J\u0013\u00104\u001a\u00020\n2\b\u00105\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u00106\u001a\u00020\u0003HÖ\u0001J\t\u00107\u001a\u00020\bHÖ\u0001J&\u00108\u001a\u0002092\u0006\u0010:\u001a\u00020\u00002\u0006\u0010;\u001a\u00020<2\u0006\u0010=\u001a\u00020>HÁ\u0001¢\u0006\u0002\b?R \u0010\u0006\u001a\u0004\u0018\u00010\u00058\u0006X\u0087\u0004¢\u0006\u0010\n\u0002\u0010\u0018\u0012\u0004\b\u0014\u0010\u0015\u001a\u0004\b\u0016\u0010\u0017R\u0015\u0010\t\u001a\u0004\u0018\u00010\n¢\u0006\n\n\u0002\u0010\u001b\u001a\u0004\b\u0019\u0010\u001aR\u001e\u0010\f\u001a\u0004\u0018\u00010\b8\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u001c\u0010\u0015\u001a\u0004\b\u001d\u0010\u001eR\u001e\u0010\u000b\u001a\u0004\u0018\u00010\b8\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u001f\u0010\u0015\u001a\u0004\b \u0010\u001eR\u0015\u0010\u0004\u001a\u0004\u0018\u00010\u0005¢\u0006\n\n\u0002\u0010\u0018\u001a\u0004\b!\u0010\u0017R\u0013\u0010\u0007\u001a\u0004\u0018\u00010\b¢\u0006\b\n\u0000\u001a\u0004\b\"\u0010\u001eR \u0010\u000e\u001a\u0004\u0018\u00010\u00058\u0006X\u0087\u0004¢\u0006\u0010\n\u0002\u0010\u0018\u0012\u0004\b#\u0010\u0015\u001a\u0004\b$\u0010\u0017R\u001e\u0010\u000f\u001a\u0004\u0018\u00010\b8\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b%\u0010\u0015\u001a\u0004\b&\u0010\u001eR\u001e\u0010\r\u001a\u0004\u0018\u00010\b8\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b'\u0010\u0015\u001a\u0004\b(\u0010\u001e¨\u0006B"}, m18d2 = {"Lzendesk/android/settings/internal/model/BrandDto;", "", "seen1", "", "id", "", "accountId", "name", "", "active", "", "deletedAt", "createdAt", "updatedAt", "routeId", "signatureTemplate", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/Long;Ljava/lang/Long;Ljava/lang/String;Ljava/lang/Boolean;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Long;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/Long;Ljava/lang/Long;Ljava/lang/String;Ljava/lang/Boolean;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Long;Ljava/lang/String;)V", "getAccountId$annotations", "()V", "getAccountId", "()Ljava/lang/Long;", "Ljava/lang/Long;", "getActive", "()Ljava/lang/Boolean;", "Ljava/lang/Boolean;", "getCreatedAt$annotations", "getCreatedAt", "()Ljava/lang/String;", "getDeletedAt$annotations", "getDeletedAt", "getId", "getName", "getRouteId$annotations", "getRouteId", "getSignatureTemplate$annotations", "getSignatureTemplate", "getUpdatedAt$annotations", "getUpdatedAt", "component1", "component2", "component3", "component4", "component5", "component6", "component7", "component8", "component9", "copy", "(Ljava/lang/Long;Ljava/lang/Long;Ljava/lang/String;Ljava/lang/Boolean;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Long;Ljava/lang/String;)Lzendesk/android/settings/internal/model/BrandDto;", "equals", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_zendesk_android", "$serializer", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class BrandDto {

    public static final Companion INSTANCE = new Companion(null);
    private final Long accountId;
    private final Boolean active;
    private final String createdAt;
    private final String deletedAt;
    private final Long id;
    private final String name;
    private final Long routeId;
    private final String signatureTemplate;
    private final String updatedAt;

    @SerialName("account_id")
    public static void getAccountId$annotations() {
    }

    @SerialName("created_at")
    public static void getCreatedAt$annotations() {
    }

    @SerialName("deleted_at")
    public static void getDeletedAt$annotations() {
    }

    @SerialName("route_id")
    public static void getRouteId$annotations() {
    }

    @SerialName("signature_template")
    public static void getSignatureTemplate$annotations() {
    }

    @SerialName("updated_at")
    public static void getUpdatedAt$annotations() {
    }

    public final Long getId() {
        return this.id;
    }

    public final Long getAccountId() {
        return this.accountId;
    }

    public final String getName() {
        return this.name;
    }

    public final Boolean getActive() {
        return this.active;
    }

    public final String getDeletedAt() {
        return this.deletedAt;
    }

    public final String getCreatedAt() {
        return this.createdAt;
    }

    public final String getUpdatedAt() {
        return this.updatedAt;
    }

    public final Long getRouteId() {
        return this.routeId;
    }

    public final String getSignatureTemplate() {
        return this.signatureTemplate;
    }

    public final BrandDto copy(Long id, Long accountId, String name, Boolean active, String deletedAt, String createdAt, String updatedAt, Long routeId, String signatureTemplate) {
        return new BrandDto(id, accountId, name, active, deletedAt, createdAt, updatedAt, routeId, signatureTemplate);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof BrandDto)) {
            return false;
        }
        BrandDto brandDto = (BrandDto) other;
        return Intrinsics.areEqual(this.id, brandDto.id) && Intrinsics.areEqual(this.accountId, brandDto.accountId) && Intrinsics.areEqual(this.name, brandDto.name) && Intrinsics.areEqual(this.active, brandDto.active) && Intrinsics.areEqual(this.deletedAt, brandDto.deletedAt) && Intrinsics.areEqual(this.createdAt, brandDto.createdAt) && Intrinsics.areEqual(this.updatedAt, brandDto.updatedAt) && Intrinsics.areEqual(this.routeId, brandDto.routeId) && Intrinsics.areEqual(this.signatureTemplate, brandDto.signatureTemplate);
    }

    public int hashCode() {
        Long l = this.id;
        int iHashCode = (l == null ? 0 : l.hashCode()) * 31;
        Long l2 = this.accountId;
        int iHashCode2 = (iHashCode + (l2 == null ? 0 : l2.hashCode())) * 31;
        String str = this.name;
        int iHashCode3 = (iHashCode2 + (str == null ? 0 : str.hashCode())) * 31;
        Boolean bool = this.active;
        int iHashCode4 = (iHashCode3 + (bool == null ? 0 : bool.hashCode())) * 31;
        String str2 = this.deletedAt;
        int iHashCode5 = (iHashCode4 + (str2 == null ? 0 : str2.hashCode())) * 31;
        String str3 = this.createdAt;
        int iHashCode6 = (iHashCode5 + (str3 == null ? 0 : str3.hashCode())) * 31;
        String str4 = this.updatedAt;
        int iHashCode7 = (iHashCode6 + (str4 == null ? 0 : str4.hashCode())) * 31;
        Long l3 = this.routeId;
        int iHashCode8 = (iHashCode7 + (l3 == null ? 0 : l3.hashCode())) * 31;
        String str5 = this.signatureTemplate;
        return iHashCode8 + (str5 != null ? str5.hashCode() : 0);
    }

    public String toString() {
        return "BrandDto(id=" + this.id + ", accountId=" + this.accountId + ", name=" + this.name + ", active=" + this.active + ", deletedAt=" + this.deletedAt + ", createdAt=" + this.createdAt + ", updatedAt=" + this.updatedAt + ", routeId=" + this.routeId + ", signatureTemplate=" + this.signatureTemplate + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/settings/internal/model/BrandDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/settings/internal/model/BrandDto;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<BrandDto> serializer() {
            return BrandDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public BrandDto(int i, Long l, @SerialName("account_id") Long l2, String str, Boolean bool, @SerialName("deleted_at") String str2, @SerialName("created_at") String str3, @SerialName("updated_at") String str4, @SerialName("route_id") Long l3, @SerialName("signature_template") String str5, SerializationConstructorMarker serializationConstructorMarker) {
        if (1 != (i & 1)) {
            PluginExceptionsKt.throwMissingFieldException(i, 1, BrandDto$$serializer.INSTANCE.getDescriptor());
        }
        this.id = l;
        if ((i & 2) == 0) {
            this.accountId = null;
        } else {
            this.accountId = l2;
        }
        if ((i & 4) == 0) {
            this.name = null;
        } else {
            this.name = str;
        }
        if ((i & 8) == 0) {
            this.active = null;
        } else {
            this.active = bool;
        }
        if ((i & 16) == 0) {
            this.deletedAt = null;
        } else {
            this.deletedAt = str2;
        }
        if ((i & 32) == 0) {
            this.createdAt = null;
        } else {
            this.createdAt = str3;
        }
        if ((i & 64) == 0) {
            this.updatedAt = null;
        } else {
            this.updatedAt = str4;
        }
        if ((i & 128) == 0) {
            this.routeId = null;
        } else {
            this.routeId = l3;
        }
        if ((i & 256) == 0) {
            this.signatureTemplate = null;
        } else {
            this.signatureTemplate = str5;
        }
    }

    public BrandDto(Long l, Long l2, String str, Boolean bool, String str2, String str3, String str4, Long l3, String str5) {
        this.id = l;
        this.accountId = l2;
        this.name = str;
        this.active = bool;
        this.deletedAt = str2;
        this.createdAt = str3;
        this.updatedAt = str4;
        this.routeId = l3;
        this.signatureTemplate = str5;
    }

    @JvmStatic
    public static final void write$Self$zendesk_zendesk_android(BrandDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeNullableSerializableElement(serialDesc, 0, LongSerializer.INSTANCE, self.id);
        if (output.shouldEncodeElementDefault(serialDesc, 1) || self.accountId != null) {
            output.encodeNullableSerializableElement(serialDesc, 1, LongSerializer.INSTANCE, self.accountId);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 2) || self.name != null) {
            output.encodeNullableSerializableElement(serialDesc, 2, StringSerializer.INSTANCE, self.name);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 3) || self.active != null) {
            output.encodeNullableSerializableElement(serialDesc, 3, BooleanSerializer.INSTANCE, self.active);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 4) || self.deletedAt != null) {
            output.encodeNullableSerializableElement(serialDesc, 4, StringSerializer.INSTANCE, self.deletedAt);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 5) || self.createdAt != null) {
            output.encodeNullableSerializableElement(serialDesc, 5, StringSerializer.INSTANCE, self.createdAt);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 6) || self.updatedAt != null) {
            output.encodeNullableSerializableElement(serialDesc, 6, StringSerializer.INSTANCE, self.updatedAt);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 7) || self.routeId != null) {
            output.encodeNullableSerializableElement(serialDesc, 7, LongSerializer.INSTANCE, self.routeId);
        }
        if (!output.shouldEncodeElementDefault(serialDesc, 8) && self.signatureTemplate == null) {
            return;
        }
        output.encodeNullableSerializableElement(serialDesc, 8, StringSerializer.INSTANCE, self.signatureTemplate);
    }

    public BrandDto(Long l, Long l2, String str, Boolean bool, String str2, String str3, String str4, Long l3, String str5, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(l, (i & 2) != 0 ? null : l2, (i & 4) != 0 ? null : str, (i & 8) != 0 ? null : bool, (i & 16) != 0 ? null : str2, (i & 32) != 0 ? null : str3, (i & 64) != 0 ? null : str4, (i & 128) != 0 ? null : l3, (i & 256) == 0 ? str5 : null);
    }

    public final Long getId() {
        return this.id;
    }

    public final Long getAccountId() {
        return this.accountId;
    }

    public final String getName() {
        return this.name;
    }

    public final Boolean getActive() {
        return this.active;
    }

    public final String getDeletedAt() {
        return this.deletedAt;
    }

    public final String getCreatedAt() {
        return this.createdAt;
    }

    public final String getUpdatedAt() {
        return this.updatedAt;
    }

    public final Long getRouteId() {
        return this.routeId;
    }

    public final String getSignatureTemplate() {
        return this.signatureTemplate;
    }
}
