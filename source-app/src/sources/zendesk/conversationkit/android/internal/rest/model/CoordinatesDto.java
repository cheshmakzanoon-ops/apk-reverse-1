package zendesk.conversationkit.android.internal.rest.model;

import androidx.compose.animation.core.ComplexDouble$;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;

@Metadata(m17d1 = {"\u0000D\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0006\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000  2\u00020\u0001:\u0002\u001f B)\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\b¢\u0006\u0002\u0010\tB\u0015\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005¢\u0006\u0002\u0010\nJ\t\u0010\u000e\u001a\u00020\u0005HÆ\u0003J\t\u0010\u000f\u001a\u00020\u0005HÆ\u0003J\u001d\u0010\u0010\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u0011\u001a\u00020\u00122\b\u0010\u0013\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0014\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0015\u001a\u00020\u0016HÖ\u0001J&\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u00002\u0006\u0010\u001a\u001a\u00020\u001b2\u0006\u0010\u001c\u001a\u00020\u001dHÁ\u0001¢\u0006\u0002\b\u001eR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\f¨\u0006!"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/CoordinatesDto;", "", "seen1", "", "lat", "", "long", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(IDDLkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(DD)V", "getLat", "()D", "getLong", "component1", "component2", "copy", "equals", "", "other", "hashCode", "toString", "", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class CoordinatesDto {

    public static final Companion INSTANCE = new Companion(null);
    private final double lat;
    private final double long;

    public static CoordinatesDto copy$default(CoordinatesDto coordinatesDto, double d, double d2, int i, Object obj) {
        if ((i & 1) != 0) {
            d = coordinatesDto.lat;
        }
        if ((i & 2) != 0) {
            d2 = coordinatesDto.long;
        }
        return coordinatesDto.copy(d, d2);
    }

    public final double getLat() {
        return this.lat;
    }

    public final double getLong() {
        return this.long;
    }

    public final CoordinatesDto copy(double lat, double d) {
        return new CoordinatesDto(lat, d);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof CoordinatesDto)) {
            return false;
        }
        CoordinatesDto coordinatesDto = (CoordinatesDto) other;
        return Double.compare(this.lat, coordinatesDto.lat) == 0 && Double.compare(this.long, coordinatesDto.long) == 0;
    }

    public int hashCode() {
        return (ComplexDouble$.ExternalSyntheticBackport0.m(this.lat) * 31) + ComplexDouble$.ExternalSyntheticBackport0.m(this.long);
    }

    public String toString() {
        return "CoordinatesDto(lat=" + this.lat + ", long=" + this.long + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/CoordinatesDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/CoordinatesDto;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<CoordinatesDto> serializer() {
            return CoordinatesDto$$serializer.INSTANCE;
        }
    }

    public CoordinatesDto(double d, double d2) {
        this.lat = d;
        this.long = d2;
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public CoordinatesDto(int i, double d, double d2, SerializationConstructorMarker serializationConstructorMarker) {
        if (3 != (i & 3)) {
            PluginExceptionsKt.throwMissingFieldException(i, 3, CoordinatesDto$$serializer.INSTANCE.getDescriptor());
        }
        this.lat = d;
        this.long = d2;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(CoordinatesDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeDoubleElement(serialDesc, 0, self.lat);
        output.encodeDoubleElement(serialDesc, 1, self.long);
    }

    public final double getLat() {
        return this.lat;
    }

    public final double getLong() {
        return this.long;
    }
}
