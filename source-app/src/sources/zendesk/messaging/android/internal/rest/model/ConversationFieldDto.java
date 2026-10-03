package zendesk.messaging.android.internal.rest.model;

import java.util.List;
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
import kotlinx.serialization.internal.ArrayListSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u0000J\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\t\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010 \n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0011\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 +2\u00020\u0001:\u0002*+BG\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\u000e\u0010\b\u001a\n\u0012\u0004\u0012\u00020\u0007\u0018\u00010\t\u0012\n\b\u0001\u0010\n\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\u000b\u001a\u0004\u0018\u00010\f¢\u0006\u0002\u0010\rB3\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0010\b\u0002\u0010\b\u001a\n\u0012\u0004\u0012\u00020\u0007\u0018\u00010\t\u0012\n\b\u0002\u0010\n\u001a\u0004\u0018\u00010\u0007¢\u0006\u0002\u0010\u000eJ\t\u0010\u0018\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0019\u001a\u00020\u0007HÆ\u0003J\u0011\u0010\u001a\u001a\n\u0012\u0004\u0012\u00020\u0007\u0018\u00010\tHÆ\u0003J\u000b\u0010\u001b\u001a\u0004\u0018\u00010\u0007HÆ\u0003J;\u0010\u001c\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\u0010\b\u0002\u0010\b\u001a\n\u0012\u0004\u0012\u00020\u0007\u0018\u00010\t2\n\b\u0002\u0010\n\u001a\u0004\u0018\u00010\u0007HÆ\u0001J\u0013\u0010\u001d\u001a\u00020\u001e2\b\u0010\u001f\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010 \u001a\u00020\u0003HÖ\u0001J\t\u0010!\u001a\u00020\u0007HÖ\u0001J&\u0010\"\u001a\u00020#2\u0006\u0010$\u001a\u00020\u00002\u0006\u0010%\u001a\u00020&2\u0006\u0010'\u001a\u00020(HÁ\u0001¢\u0006\u0002\b)R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u0019\u0010\b\u001a\n\u0012\u0004\u0012\u00020\u0007\u0018\u00010\t¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012R\u001e\u0010\n\u001a\u0004\u0018\u00010\u00078\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0013\u0010\u0014\u001a\u0004\b\u0015\u0010\u0016R\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0016¨\u0006,"}, m18d2 = {"Lzendesk/messaging/android/internal/rest/model/ConversationFieldDto;", "", "seen1", "", "id", "", "type", "", "options", "", "regexp", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(IJLjava/lang/String;Ljava/util/List;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(JLjava/lang/String;Ljava/util/List;Ljava/lang/String;)V", "getId", "()J", "getOptions", "()Ljava/util/List;", "getRegexp$annotations", "()V", "getRegexp", "()Ljava/lang/String;", "getType", "component1", "component2", "component3", "component4", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_messaging_messaging_android", "$serializer", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class ConversationFieldDto {
    private final long id;
    private final List<String> options;
    private final String regexp;
    private final String type;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {null, null, new ArrayListSerializer(StringSerializer.INSTANCE), null};

    public static ConversationFieldDto copy$default(ConversationFieldDto conversationFieldDto, long j, String str, List list, String str2, int i, Object obj) {
        if ((i & 1) != 0) {
            j = conversationFieldDto.id;
        }
        long j2 = j;
        if ((i & 2) != 0) {
            str = conversationFieldDto.type;
        }
        String str3 = str;
        if ((i & 4) != 0) {
            list = conversationFieldDto.options;
        }
        List list2 = list;
        if ((i & 8) != 0) {
            str2 = conversationFieldDto.regexp;
        }
        return conversationFieldDto.copy(j2, str3, list2, str2);
    }

    @SerialName("regexp_for_validation")
    public static void getRegexp$annotations() {
    }

    public final long getId() {
        return this.id;
    }

    public final String getType() {
        return this.type;
    }

    public final List<String> component3() {
        return this.options;
    }

    public final String getRegexp() {
        return this.regexp;
    }

    public final ConversationFieldDto copy(long id, String type, List<String> options, String regexp) {
        Intrinsics.checkNotNullParameter(type, "type");
        return new ConversationFieldDto(id, type, options, regexp);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ConversationFieldDto)) {
            return false;
        }
        ConversationFieldDto conversationFieldDto = (ConversationFieldDto) other;
        return this.id == conversationFieldDto.id && Intrinsics.areEqual(this.type, conversationFieldDto.type) && Intrinsics.areEqual(this.options, conversationFieldDto.options) && Intrinsics.areEqual(this.regexp, conversationFieldDto.regexp);
    }

    public int hashCode() {
        int iM27m = ((UByte$$ExternalSyntheticBackport0.m27m(this.id) * 31) + this.type.hashCode()) * 31;
        List<String> list = this.options;
        int iHashCode = (iM27m + (list == null ? 0 : list.hashCode())) * 31;
        String str = this.regexp;
        return iHashCode + (str != null ? str.hashCode() : 0);
    }

    public String toString() {
        return "ConversationFieldDto(id=" + this.id + ", type=" + this.type + ", options=" + this.options + ", regexp=" + this.regexp + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/messaging/android/internal/rest/model/ConversationFieldDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/messaging/android/internal/rest/model/ConversationFieldDto;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<ConversationFieldDto> serializer() {
            return ConversationFieldDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public ConversationFieldDto(int i, long j, String str, List list, @SerialName("regexp_for_validation") String str2, SerializationConstructorMarker serializationConstructorMarker) {
        if (3 != (i & 3)) {
            PluginExceptionsKt.throwMissingFieldException(i, 3, ConversationFieldDto$$serializer.INSTANCE.getDescriptor());
        }
        this.id = j;
        this.type = str;
        if ((i & 4) == 0) {
            this.options = null;
        } else {
            this.options = list;
        }
        if ((i & 8) == 0) {
            this.regexp = null;
        } else {
            this.regexp = str2;
        }
    }

    public ConversationFieldDto(long j, String type, List<String> list, String str) {
        Intrinsics.checkNotNullParameter(type, "type");
        this.id = j;
        this.type = type;
        this.options = list;
        this.regexp = str;
    }

    @JvmStatic
    public static final void write$Self$zendesk_messaging_messaging_android(ConversationFieldDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        output.encodeLongElement(serialDesc, 0, self.id);
        output.encodeStringElement(serialDesc, 1, self.type);
        if (output.shouldEncodeElementDefault(serialDesc, 2) || self.options != null) {
            output.encodeNullableSerializableElement(serialDesc, 2, kSerializerArr[2], self.options);
        }
        if (!output.shouldEncodeElementDefault(serialDesc, 3) && self.regexp == null) {
            return;
        }
        output.encodeNullableSerializableElement(serialDesc, 3, StringSerializer.INSTANCE, self.regexp);
    }

    public ConversationFieldDto(long j, String str, List list, String str2, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(j, str, (i & 4) != 0 ? null : list, (i & 8) != 0 ? null : str2);
    }

    public final long getId() {
        return this.id;
    }

    public final String getType() {
        return this.type;
    }

    public final List<String> getOptions() {
        return this.options;
    }

    public final String getRegexp() {
        return this.regexp;
    }
}
