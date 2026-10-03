package zendesk.conversationkit.android.internal.rest.model;

import java.util.List;
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
import kotlinx.serialization.SerialName;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.ArrayListSerializer;
import kotlinx.serialization.internal.IntSerializer;
import kotlinx.serialization.internal.LinkedHashMapSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u0000V\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0010$\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b&\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 K2\u00020\u0001:\u0002JKBº\u0001\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0001\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0005\u0012\u0019\u0010\t\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u000b\u0018\u00010\n\u0012\b\u0010\f\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\r\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u000e\u001a\u0004\u0018\u00010\u0003\u0012\b\u0010\u000f\u001a\u0004\u0018\u00010\u0003\u0012\b\u0010\u0010\u001a\u0004\u0018\u00010\u0005\u0012\u000e\u0010\u0011\u001a\n\u0012\u0004\u0012\u00020\u0013\u0018\u00010\u0012\u0012\u000e\u0010\u0014\u001a\n\u0012\u0004\u0012\u00020\u0013\u0018\u00010\u0012\u0012\b\u0010\u0015\u001a\u0004\u0018\u00010\u0003\u0012\b\u0010\u0016\u001a\u0004\u0018\u00010\u0017¢\u0006\u0002\u0010\u0018B\u009c\u0001\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\u0005\u0012\u0006\u0010\b\u001a\u00020\u0005\u0012\u0019\u0010\t\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u000b\u0018\u00010\n\u0012\b\u0010\f\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\r\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u000e\u001a\u0004\u0018\u00010\u0003\u0012\b\u0010\u000f\u001a\u0004\u0018\u00010\u0003\u0012\b\u0010\u0010\u001a\u0004\u0018\u00010\u0005\u0012\u000e\u0010\u0011\u001a\n\u0012\u0004\u0012\u00020\u0013\u0018\u00010\u0012\u0012\u000e\u0010\u0014\u001a\n\u0012\u0004\u0012\u00020\u0013\u0018\u00010\u0012\u0012\b\u0010\u0015\u001a\u0004\u0018\u00010\u0003¢\u0006\u0002\u0010\u0019J\t\u0010.\u001a\u00020\u0005HÆ\u0003J\u000b\u0010/\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u0011\u00100\u001a\n\u0012\u0004\u0012\u00020\u0013\u0018\u00010\u0012HÆ\u0003J\u0011\u00101\u001a\n\u0012\u0004\u0012\u00020\u0013\u0018\u00010\u0012HÆ\u0003J\u0010\u00102\u001a\u0004\u0018\u00010\u0003HÆ\u0003¢\u0006\u0002\u0010!J\t\u00103\u001a\u00020\u0005HÆ\u0003J\t\u00104\u001a\u00020\u0005HÆ\u0003J\t\u00105\u001a\u00020\u0005HÆ\u0003J\u001c\u00106\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u000b\u0018\u00010\nHÆ\u0003J\u000b\u00107\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u00108\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u0010\u00109\u001a\u0004\u0018\u00010\u0003HÆ\u0003¢\u0006\u0002\u0010!J\u0010\u0010:\u001a\u0004\u0018\u00010\u0003HÆ\u0003¢\u0006\u0002\u0010!J¿\u0001\u0010;\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\b\b\u0002\u0010\u0007\u001a\u00020\u00052\b\b\u0002\u0010\b\u001a\u00020\u00052\u001b\b\u0002\u0010\t\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u000b\u0018\u00010\n2\n\b\u0002\u0010\f\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u000e\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u00052\u0010\b\u0002\u0010\u0011\u001a\n\u0012\u0004\u0012\u00020\u0013\u0018\u00010\u00122\u0010\b\u0002\u0010\u0014\u001a\n\u0012\u0004\u0012\u00020\u0013\u0018\u00010\u00122\n\b\u0002\u0010\u0015\u001a\u0004\u0018\u00010\u0003HÆ\u0001¢\u0006\u0002\u0010<J\u0013\u0010=\u001a\u00020>2\b\u0010?\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010@\u001a\u00020\u0003HÖ\u0001J\t\u0010A\u001a\u00020\u0005HÖ\u0001J&\u0010B\u001a\u00020C2\u0006\u0010D\u001a\u00020\u00002\u0006\u0010E\u001a\u00020F2\u0006\u0010G\u001a\u00020HHÁ\u0001¢\u0006\u0002\bIR\u0013\u0010\u0010\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u001bR\u001c\u0010\u0004\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u001c\u0010\u001d\u001a\u0004\b\u001e\u0010\u001bR\u0011\u0010\u0007\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010\u001bR\u0015\u0010\u000f\u001a\u0004\u0018\u00010\u0003¢\u0006\n\n\u0002\u0010\"\u001a\u0004\b \u0010!R$\u0010\t\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u000b\u0018\u00010\n¢\u0006\b\n\u0000\u001a\u0004\b#\u0010$R\u0015\u0010\u000e\u001a\u0004\u0018\u00010\u0003¢\u0006\n\n\u0002\u0010\"\u001a\u0004\b%\u0010!R\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b&\u0010\u001bR\u0019\u0010\u0011\u001a\n\u0012\u0004\u0012\u00020\u0013\u0018\u00010\u0012¢\u0006\b\n\u0000\u001a\u0004\b'\u0010(R\u0013\u0010\f\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b)\u0010\u001bR\u0019\u0010\u0014\u001a\n\u0012\u0004\u0012\u00020\u0013\u0018\u00010\u0012¢\u0006\b\n\u0000\u001a\u0004\b*\u0010(R\u0015\u0010\u0015\u001a\u0004\u0018\u00010\u0003¢\u0006\n\n\u0002\u0010\"\u001a\u0004\b+\u0010!R\u0013\u0010\r\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b,\u0010\u001bR\u0011\u0010\b\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b-\u0010\u001b¨\u0006L"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/MessageFieldDto;", "", "seen1", "", "id", "", "name", "label", "type", "metadata", "", "Lkotlinx/serialization/Contextual;", "placeholder", "text", "minSize", "maxSize", "email", "options", "", "Lzendesk/conversationkit/android/internal/rest/model/MessageFieldOptionDto;", "select", "selectSize", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/String;Ljava/util/List;Ljava/util/List;Ljava/lang/Integer;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/String;Ljava/util/List;Ljava/util/List;Ljava/lang/Integer;)V", "getEmail", "()Ljava/lang/String;", "getId$annotations", "()V", "getId", "getLabel", "getMaxSize", "()Ljava/lang/Integer;", "Ljava/lang/Integer;", "getMetadata", "()Ljava/util/Map;", "getMinSize", "getName", "getOptions", "()Ljava/util/List;", "getPlaceholder", "getSelect", "getSelectSize", "getText", "getType", "component1", "component10", "component11", "component12", "component13", "component2", "component3", "component4", "component5", "component6", "component7", "component8", "component9", "copy", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/String;Ljava/util/List;Ljava/util/List;Ljava/lang/Integer;)Lzendesk/conversationkit/android/internal/rest/model/MessageFieldDto;", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class MessageFieldDto {
    private final String email;
    private final String id;
    private final String label;
    private final Integer maxSize;
    private final Map<String, Object> metadata;
    private final Integer minSize;
    private final String name;
    private final List<MessageFieldOptionDto> options;
    private final String placeholder;
    private final List<MessageFieldOptionDto> select;
    private final Integer selectSize;
    private final String text;
    private final String type;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {null, null, null, null, new LinkedHashMapSerializer(StringSerializer.INSTANCE, new ContextualSerializer(Reflection.getOrCreateKotlinClass(Object.class), null, new KSerializer[0])), null, null, null, null, null, new ArrayListSerializer(MessageFieldOptionDto$$serializer.INSTANCE), new ArrayListSerializer(MessageFieldOptionDto$$serializer.INSTANCE), null};

    @SerialName("_id")
    public static void getId$annotations() {
    }

    public final String getId() {
        return this.id;
    }

    public final String getEmail() {
        return this.email;
    }

    public final List<MessageFieldOptionDto> component11() {
        return this.options;
    }

    public final List<MessageFieldOptionDto> component12() {
        return this.select;
    }

    public final Integer getSelectSize() {
        return this.selectSize;
    }

    public final String getName() {
        return this.name;
    }

    public final String getLabel() {
        return this.label;
    }

    public final String getType() {
        return this.type;
    }

    public final Map<String, Object> component5() {
        return this.metadata;
    }

    public final String getPlaceholder() {
        return this.placeholder;
    }

    public final String getText() {
        return this.text;
    }

    public final Integer getMinSize() {
        return this.minSize;
    }

    public final Integer getMaxSize() {
        return this.maxSize;
    }

    public final MessageFieldDto copy(String id, String name, String label, String type, Map<String, ? extends Object> metadata, String placeholder, String text, Integer minSize, Integer maxSize, String email, List<MessageFieldOptionDto> options, List<MessageFieldOptionDto> select, Integer selectSize) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(name, "name");
        Intrinsics.checkNotNullParameter(label, "label");
        Intrinsics.checkNotNullParameter(type, "type");
        return new MessageFieldDto(id, name, label, type, metadata, placeholder, text, minSize, maxSize, email, options, select, selectSize);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof MessageFieldDto)) {
            return false;
        }
        MessageFieldDto messageFieldDto = (MessageFieldDto) other;
        return Intrinsics.areEqual(this.id, messageFieldDto.id) && Intrinsics.areEqual(this.name, messageFieldDto.name) && Intrinsics.areEqual(this.label, messageFieldDto.label) && Intrinsics.areEqual(this.type, messageFieldDto.type) && Intrinsics.areEqual(this.metadata, messageFieldDto.metadata) && Intrinsics.areEqual(this.placeholder, messageFieldDto.placeholder) && Intrinsics.areEqual(this.text, messageFieldDto.text) && Intrinsics.areEqual(this.minSize, messageFieldDto.minSize) && Intrinsics.areEqual(this.maxSize, messageFieldDto.maxSize) && Intrinsics.areEqual(this.email, messageFieldDto.email) && Intrinsics.areEqual(this.options, messageFieldDto.options) && Intrinsics.areEqual(this.select, messageFieldDto.select) && Intrinsics.areEqual(this.selectSize, messageFieldDto.selectSize);
    }

    public int hashCode() {
        int iHashCode = ((((((this.id.hashCode() * 31) + this.name.hashCode()) * 31) + this.label.hashCode()) * 31) + this.type.hashCode()) * 31;
        Map<String, Object> map = this.metadata;
        int iHashCode2 = (iHashCode + (map == null ? 0 : map.hashCode())) * 31;
        String str = this.placeholder;
        int iHashCode3 = (iHashCode2 + (str == null ? 0 : str.hashCode())) * 31;
        String str2 = this.text;
        int iHashCode4 = (iHashCode3 + (str2 == null ? 0 : str2.hashCode())) * 31;
        Integer num = this.minSize;
        int iHashCode5 = (iHashCode4 + (num == null ? 0 : num.hashCode())) * 31;
        Integer num2 = this.maxSize;
        int iHashCode6 = (iHashCode5 + (num2 == null ? 0 : num2.hashCode())) * 31;
        String str3 = this.email;
        int iHashCode7 = (iHashCode6 + (str3 == null ? 0 : str3.hashCode())) * 31;
        List<MessageFieldOptionDto> list = this.options;
        int iHashCode8 = (iHashCode7 + (list == null ? 0 : list.hashCode())) * 31;
        List<MessageFieldOptionDto> list2 = this.select;
        int iHashCode9 = (iHashCode8 + (list2 == null ? 0 : list2.hashCode())) * 31;
        Integer num3 = this.selectSize;
        return iHashCode9 + (num3 != null ? num3.hashCode() : 0);
    }

    public String toString() {
        return "MessageFieldDto(id=" + this.id + ", name=" + this.name + ", label=" + this.label + ", type=" + this.type + ", metadata=" + this.metadata + ", placeholder=" + this.placeholder + ", text=" + this.text + ", minSize=" + this.minSize + ", maxSize=" + this.maxSize + ", email=" + this.email + ", options=" + this.options + ", select=" + this.select + ", selectSize=" + this.selectSize + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/MessageFieldDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/MessageFieldDto;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<MessageFieldDto> serializer() {
            return MessageFieldDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public MessageFieldDto(int i, @SerialName("_id") String str, String str2, String str3, String str4, Map map, String str5, String str6, Integer num, Integer num2, String str7, List list, List list2, Integer num3, SerializationConstructorMarker serializationConstructorMarker) {
        if (8191 != (i & 8191)) {
            PluginExceptionsKt.throwMissingFieldException(i, 8191, MessageFieldDto$$serializer.INSTANCE.getDescriptor());
        }
        this.id = str;
        this.name = str2;
        this.label = str3;
        this.type = str4;
        this.metadata = map;
        this.placeholder = str5;
        this.text = str6;
        this.minSize = num;
        this.maxSize = num2;
        this.email = str7;
        this.options = list;
        this.select = list2;
        this.selectSize = num3;
    }

    public MessageFieldDto(String id, String name, String label, String type, Map<String, ? extends Object> map, String str, String str2, Integer num, Integer num2, String str3, List<MessageFieldOptionDto> list, List<MessageFieldOptionDto> list2, Integer num3) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(name, "name");
        Intrinsics.checkNotNullParameter(label, "label");
        Intrinsics.checkNotNullParameter(type, "type");
        this.id = id;
        this.name = name;
        this.label = label;
        this.type = type;
        this.metadata = map;
        this.placeholder = str;
        this.text = str2;
        this.minSize = num;
        this.maxSize = num2;
        this.email = str3;
        this.options = list;
        this.select = list2;
        this.selectSize = num3;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(MessageFieldDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        output.encodeStringElement(serialDesc, 0, self.id);
        output.encodeStringElement(serialDesc, 1, self.name);
        output.encodeStringElement(serialDesc, 2, self.label);
        output.encodeStringElement(serialDesc, 3, self.type);
        output.encodeNullableSerializableElement(serialDesc, 4, kSerializerArr[4], self.metadata);
        output.encodeNullableSerializableElement(serialDesc, 5, StringSerializer.INSTANCE, self.placeholder);
        output.encodeNullableSerializableElement(serialDesc, 6, StringSerializer.INSTANCE, self.text);
        output.encodeNullableSerializableElement(serialDesc, 7, IntSerializer.INSTANCE, self.minSize);
        output.encodeNullableSerializableElement(serialDesc, 8, IntSerializer.INSTANCE, self.maxSize);
        output.encodeNullableSerializableElement(serialDesc, 9, StringSerializer.INSTANCE, self.email);
        output.encodeNullableSerializableElement(serialDesc, 10, kSerializerArr[10], self.options);
        output.encodeNullableSerializableElement(serialDesc, 11, kSerializerArr[11], self.select);
        output.encodeNullableSerializableElement(serialDesc, 12, IntSerializer.INSTANCE, self.selectSize);
    }

    public final String getId() {
        return this.id;
    }

    public final String getName() {
        return this.name;
    }

    public final String getLabel() {
        return this.label;
    }

    public final String getType() {
        return this.type;
    }

    public final Map<String, Object> getMetadata() {
        return this.metadata;
    }

    public final String getPlaceholder() {
        return this.placeholder;
    }

    public final String getText() {
        return this.text;
    }

    public final Integer getMinSize() {
        return this.minSize;
    }

    public final Integer getMaxSize() {
        return this.maxSize;
    }

    public final String getEmail() {
        return this.email;
    }

    public final List<MessageFieldOptionDto> getOptions() {
        return this.options;
    }

    public final List<MessageFieldOptionDto> getSelect() {
        return this.select;
    }

    public final Integer getSelectSize() {
        return this.selectSize;
    }
}
