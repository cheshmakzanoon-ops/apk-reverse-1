package zendesk.guidekit.android.internal.rest.model;

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

@Metadata(m17d1 = {"\u0000D\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\t\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0011\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 *2\u00020\u0001:\u0002)*BC\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0001\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0007\u0012\n\b\u0001\u0010\t\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u000b¢\u0006\u0002\u0010\fB%\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\u0007\u0012\u0006\u0010\t\u001a\u00020\u0007¢\u0006\u0002\u0010\rJ\t\u0010\u0017\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0018\u001a\u00020\u0007HÆ\u0003J\t\u0010\u0019\u001a\u00020\u0007HÆ\u0003J\t\u0010\u001a\u001a\u00020\u0007HÆ\u0003J1\u0010\u001b\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\u00072\b\b\u0002\u0010\t\u001a\u00020\u0007HÆ\u0001J\u0013\u0010\u001c\u001a\u00020\u001d2\b\u0010\u001e\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u001f\u001a\u00020\u0003HÖ\u0001J\t\u0010 \u001a\u00020\u0007HÖ\u0001J&\u0010!\u001a\u00020\"2\u0006\u0010#\u001a\u00020\u00002\u0006\u0010$\u001a\u00020%2\u0006\u0010&\u001a\u00020'HÁ\u0001¢\u0006\u0002\b(R\u001c\u0010\u0006\u001a\u00020\u00078\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u000e\u0010\u000f\u001a\u0004\b\u0010\u0010\u0011R\u001c\u0010\t\u001a\u00020\u00078\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0012\u0010\u000f\u001a\u0004\b\u0013\u0010\u0011R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0015R\u0011\u0010\b\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0011¨\u0006+"}, m18d2 = {"Lzendesk/guidekit/android/internal/rest/model/BrandDto;", "", "seen1", "", "id", "", "channelId", "", "subdomain", "hostMapping", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(IJLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(JLjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", "getChannelId$annotations", "()V", "getChannelId", "()Ljava/lang/String;", "getHostMapping$annotations", "getHostMapping", "getId", "()J", "getSubdomain", "component1", "component2", "component3", "component4", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_guidekit_guidekit_android", "$serializer", "Companion", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class BrandDto {

    public static final Companion INSTANCE = new Companion(null);
    private final String channelId;
    private final String hostMapping;
    private final long id;
    private final String subdomain;

    public static BrandDto copy$default(BrandDto brandDto, long j, String str, String str2, String str3, int i, Object obj) {
        if ((i & 1) != 0) {
            j = brandDto.id;
        }
        long j2 = j;
        if ((i & 2) != 0) {
            str = brandDto.channelId;
        }
        String str4 = str;
        if ((i & 4) != 0) {
            str2 = brandDto.subdomain;
        }
        String str5 = str2;
        if ((i & 8) != 0) {
            str3 = brandDto.hostMapping;
        }
        return brandDto.copy(j2, str4, str5, str3);
    }

    @SerialName("channel_id")
    public static void getChannelId$annotations() {
    }

    @SerialName("host_mapping")
    public static void getHostMapping$annotations() {
    }

    public final long getId() {
        return this.id;
    }

    public final String getChannelId() {
        return this.channelId;
    }

    public final String getSubdomain() {
        return this.subdomain;
    }

    public final String getHostMapping() {
        return this.hostMapping;
    }

    public final BrandDto copy(long id, String channelId, String subdomain, String hostMapping) {
        Intrinsics.checkNotNullParameter(channelId, "channelId");
        Intrinsics.checkNotNullParameter(subdomain, "subdomain");
        Intrinsics.checkNotNullParameter(hostMapping, "hostMapping");
        return new BrandDto(id, channelId, subdomain, hostMapping);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof BrandDto)) {
            return false;
        }
        BrandDto brandDto = (BrandDto) other;
        return this.id == brandDto.id && Intrinsics.areEqual(this.channelId, brandDto.channelId) && Intrinsics.areEqual(this.subdomain, brandDto.subdomain) && Intrinsics.areEqual(this.hostMapping, brandDto.hostMapping);
    }

    public int hashCode() {
        return (((((UByte$$ExternalSyntheticBackport0.m27m(this.id) * 31) + this.channelId.hashCode()) * 31) + this.subdomain.hashCode()) * 31) + this.hostMapping.hashCode();
    }

    public String toString() {
        return "BrandDto(id=" + this.id + ", channelId=" + this.channelId + ", subdomain=" + this.subdomain + ", hostMapping=" + this.hostMapping + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/guidekit/android/internal/rest/model/BrandDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/guidekit/android/internal/rest/model/BrandDto;", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
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
    public BrandDto(int i, long j, @SerialName("channel_id") String str, String str2, @SerialName("host_mapping") String str3, SerializationConstructorMarker serializationConstructorMarker) {
        if (15 != (i & 15)) {
            PluginExceptionsKt.throwMissingFieldException(i, 15, BrandDto$$serializer.INSTANCE.getDescriptor());
        }
        this.id = j;
        this.channelId = str;
        this.subdomain = str2;
        this.hostMapping = str3;
    }

    public BrandDto(long j, String channelId, String subdomain, String hostMapping) {
        Intrinsics.checkNotNullParameter(channelId, "channelId");
        Intrinsics.checkNotNullParameter(subdomain, "subdomain");
        Intrinsics.checkNotNullParameter(hostMapping, "hostMapping");
        this.id = j;
        this.channelId = channelId;
        this.subdomain = subdomain;
        this.hostMapping = hostMapping;
    }

    @JvmStatic
    public static final void write$Self$zendesk_guidekit_guidekit_android(BrandDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeLongElement(serialDesc, 0, self.id);
        output.encodeStringElement(serialDesc, 1, self.channelId);
        output.encodeStringElement(serialDesc, 2, self.subdomain);
        output.encodeStringElement(serialDesc, 3, self.hostMapping);
    }

    public final long getId() {
        return this.id;
    }

    public final String getChannelId() {
        return this.channelId;
    }

    public final String getSubdomain() {
        return this.subdomain;
    }

    public final String getHostMapping() {
        return this.hostMapping;
    }
}
