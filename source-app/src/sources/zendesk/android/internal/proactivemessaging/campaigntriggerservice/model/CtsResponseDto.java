package zendesk.android.internal.proactivemessaging.campaigntriggerservice.model;

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
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u0000>\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\r\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 $2\u00020\u0001:\u0002#$B9\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u0007\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\b\u001a\u0004\u0018\u00010\t¢\u0006\u0002\u0010\nB%\u0012\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\u0005¢\u0006\u0002\u0010\u000bJ\u000b\u0010\u0012\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\t\u0010\u0013\u001a\u00020\u0005HÆ\u0003J\u000b\u0010\u0014\u001a\u0004\u0018\u00010\u0005HÆ\u0003J+\u0010\u0015\u001a\u00020\u00002\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\u0005HÆ\u0001J\u0013\u0010\u0016\u001a\u00020\u00172\b\u0010\u0018\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0019\u001a\u00020\u0003HÖ\u0001J\t\u0010\u001a\u001a\u00020\u0005HÖ\u0001J&\u0010\u001b\u001a\u00020\u001c2\u0006\u0010\u001d\u001a\u00020\u00002\u0006\u0010\u001e\u001a\u00020\u001f2\u0006\u0010 \u001a\u00020!HÁ\u0001¢\u0006\u0002\b\"R\u001e\u0010\u0007\u001a\u0004\u0018\u00010\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\f\u0010\r\u001a\u0004\b\u000e\u0010\u000fR\u0013\u0010\u0004\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u000fR\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u000f¨\u0006%"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/campaigntriggerservice/model/CtsResponseDto;", "", "seen1", "", "jwt", "", "message", "campaignId", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", "getCampaignId$annotations", "()V", "getCampaignId", "()Ljava/lang/String;", "getJwt", "getMessage", "component1", "component2", "component3", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_zendesk_android", "$serializer", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class CtsResponseDto {

    public static final Companion INSTANCE = new Companion(null);
    private final String campaignId;
    private final String jwt;
    private final String message;

    public static CtsResponseDto copy$default(CtsResponseDto ctsResponseDto, String str, String str2, String str3, int i, Object obj) {
        if ((i & 1) != 0) {
            str = ctsResponseDto.jwt;
        }
        if ((i & 2) != 0) {
            str2 = ctsResponseDto.message;
        }
        if ((i & 4) != 0) {
            str3 = ctsResponseDto.campaignId;
        }
        return ctsResponseDto.copy(str, str2, str3);
    }

    @SerialName("pcm_id")
    public static void getCampaignId$annotations() {
    }

    public final String getJwt() {
        return this.jwt;
    }

    public final String getMessage() {
        return this.message;
    }

    public final String getCampaignId() {
        return this.campaignId;
    }

    public final CtsResponseDto copy(String jwt, String message, String campaignId) {
        Intrinsics.checkNotNullParameter(message, "message");
        return new CtsResponseDto(jwt, message, campaignId);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof CtsResponseDto)) {
            return false;
        }
        CtsResponseDto ctsResponseDto = (CtsResponseDto) other;
        return Intrinsics.areEqual(this.jwt, ctsResponseDto.jwt) && Intrinsics.areEqual(this.message, ctsResponseDto.message) && Intrinsics.areEqual(this.campaignId, ctsResponseDto.campaignId);
    }

    public int hashCode() {
        String str = this.jwt;
        int iHashCode = (((str == null ? 0 : str.hashCode()) * 31) + this.message.hashCode()) * 31;
        String str2 = this.campaignId;
        return iHashCode + (str2 != null ? str2.hashCode() : 0);
    }

    public String toString() {
        return "CtsResponseDto(jwt=" + this.jwt + ", message=" + this.message + ", campaignId=" + this.campaignId + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/campaigntriggerservice/model/CtsResponseDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/internal/proactivemessaging/campaigntriggerservice/model/CtsResponseDto;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<CtsResponseDto> serializer() {
            return CtsResponseDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public CtsResponseDto(int i, String str, String str2, @SerialName("pcm_id") String str3, SerializationConstructorMarker serializationConstructorMarker) {
        if (2 != (i & 2)) {
            PluginExceptionsKt.throwMissingFieldException(i, 2, CtsResponseDto$$serializer.INSTANCE.getDescriptor());
        }
        if ((i & 1) == 0) {
            this.jwt = null;
        } else {
            this.jwt = str;
        }
        this.message = str2;
        if ((i & 4) == 0) {
            this.campaignId = null;
        } else {
            this.campaignId = str3;
        }
    }

    public CtsResponseDto(String str, String message, String str2) {
        Intrinsics.checkNotNullParameter(message, "message");
        this.jwt = str;
        this.message = message;
        this.campaignId = str2;
    }

    @JvmStatic
    public static final void write$Self$zendesk_zendesk_android(CtsResponseDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        if (output.shouldEncodeElementDefault(serialDesc, 0) || self.jwt != null) {
            output.encodeNullableSerializableElement(serialDesc, 0, StringSerializer.INSTANCE, self.jwt);
        }
        output.encodeStringElement(serialDesc, 1, self.message);
        if (!output.shouldEncodeElementDefault(serialDesc, 2) && self.campaignId == null) {
            return;
        }
        output.encodeNullableSerializableElement(serialDesc, 2, StringSerializer.INSTANCE, self.campaignId);
    }

    public CtsResponseDto(String str, String str2, String str3, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? null : str, str2, (i & 4) != 0 ? null : str3);
    }

    public final String getJwt() {
        return this.jwt;
    }

    public final String getMessage() {
        return this.message;
    }

    public final String getCampaignId() {
        return this.campaignId;
    }
}
