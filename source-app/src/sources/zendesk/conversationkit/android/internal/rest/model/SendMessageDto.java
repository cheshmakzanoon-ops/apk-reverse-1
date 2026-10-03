package zendesk.conversationkit.android.internal.rest.model;

import java.lang.annotation.Annotation;
import java.util.List;
import java.util.Map;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Lazy;
import kotlin.LazyKt;
import kotlin.LazyThreadSafetyMode;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Reflection;
import kotlin.reflect.KClass;
import kotlinx.serialization.ContextualSerializer;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.SealedClassSerializer;
import kotlinx.serialization.SerialName;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.Transient;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.ArrayListSerializer;
import kotlinx.serialization.internal.LinkedHashMapSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u0000L\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010$\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b1\u0018\u0000 \u001e2\u00020\u0001:\u0003\u001e\u001f B\u0019\b\u0017\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005¢\u0006\u0002\u0010\u0006B\u0011\b\u0004\u0012\b\b\u0002\u0010\u0007\u001a\u00020\b¢\u0006\u0002\u0010\tJ!\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u00002\u0006\u0010\u001a\u001a\u00020\u001b2\u0006\u0010\u001c\u001a\u00020\u001dHÇ\u0001R%\u0010\n\u001a\u0015\u0012\u0004\u0012\u00020\b\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\f\u0018\u00010\u000bX¦\u0004¢\u0006\u0006\u001a\u0004\b\r\u0010\u000eR\u0014\u0010\u000f\u001a\u0004\u0018\u00010\bX¦\u0004¢\u0006\u0006\u001a\u0004\b\u0010\u0010\u0011R\u0012\u0010\u0012\u001a\u00020\bX¦\u0004¢\u0006\u0006\u001a\u0004\b\u0013\u0010\u0011R\u001c\u0010\u0007\u001a\u00020\b8\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0014\u0010\u0015\u001a\u0004\b\u0016\u0010\u0011\u0082\u0001\u0002!\"¨\u0006#"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/SendMessageDto;", "", "seen1", "", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILkotlinx/serialization/internal/SerializationConstructorMarker;)V", "sendMessageType", "", "(Ljava/lang/String;)V", "metadata", "", "Lkotlinx/serialization/Contextual;", "getMetadata", "()Ljava/util/Map;", "payload", "getPayload", "()Ljava/lang/String;", "role", "getRole", "getSendMessageType$annotations", "()V", "getSendMessageType", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "Companion", "FormResponse", "Text", "Lzendesk/conversationkit/android/internal/rest/model/SendMessageDto$FormResponse;", "Lzendesk/conversationkit/android/internal/rest/model/SendMessageDto$Text;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public abstract class SendMessageDto {
    private final String sendMessageType;

    public static final Companion INSTANCE = new Companion(null);
    private static final Lazy<KSerializer<Object>> $cachedSerializer$delegate = LazyKt.lazy(LazyThreadSafetyMode.PUBLICATION, (Function0) new Function0<KSerializer<Object>>() {
        @Override
        public final KSerializer<Object> invoke() {
            return new SealedClassSerializer("zendesk.conversationkit.android.internal.rest.model.SendMessageDto", Reflection.getOrCreateKotlinClass(SendMessageDto.class), new KClass[]{Reflection.getOrCreateKotlinClass(FormResponse.class), Reflection.getOrCreateKotlinClass(Text.class)}, new KSerializer[]{SendMessageDto$FormResponse$$serializer.INSTANCE, SendMessageDto$Text$$serializer.INSTANCE}, new Annotation[0]);
        }
    });

    public SendMessageDto(String str, DefaultConstructorMarker defaultConstructorMarker) {
        this(str);
    }

    @Transient
    public static void getSendMessageType$annotations() {
    }

    @JvmStatic
    public static final void write$Self(SendMessageDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
    }

    public abstract Map<String, Object> getMetadata();

    public abstract String getPayload();

    public abstract String getRole();

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/SendMessageDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/SendMessageDto;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        private final KSerializer get$cachedSerializer() {
            return (KSerializer) SendMessageDto.$cachedSerializer$delegate.getValue();
        }

        public final KSerializer<SendMessageDto> serializer() {
            return get$cachedSerializer();
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public SendMessageDto(int i, SerializationConstructorMarker serializationConstructorMarker) {
        this.sendMessageType = "";
    }

    private SendMessageDto(String str) {
        this.sendMessageType = str;
    }

    public SendMessageDto(String str, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? "" : str, (DefaultConstructorMarker) null);
    }

    public final String getSendMessageType() {
        return this.sendMessageType;
    }

    @Metadata(m17d1 = {"\u0000L\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010$\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u000e\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 )2\u00020\u0001:\u0002()BR\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\u0019\u0010\u0006\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\b¢\u0006\u0002\b\t\u0018\u00010\u0007\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u000b\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\f\u001a\u0004\u0018\u00010\r¢\u0006\u0002\u0010\u000eB>\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u001b\b\u0002\u0010\u0006\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\b¢\u0006\u0002\b\t\u0018\u00010\u0007\u0012\n\b\u0002\u0010\n\u001a\u0004\u0018\u00010\u0005\u0012\u0006\u0010\u000b\u001a\u00020\u0005¢\u0006\u0002\u0010\u000fJ\t\u0010\u0016\u001a\u00020\u0005HÆ\u0003J\u001c\u0010\u0017\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\b¢\u0006\u0002\b\t\u0018\u00010\u0007HÆ\u0003J\u000b\u0010\u0018\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\t\u0010\u0019\u001a\u00020\u0005HÆ\u0003JF\u0010\u001a\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\u001b\b\u0002\u0010\u0006\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\b¢\u0006\u0002\b\t\u0018\u00010\u00072\n\b\u0002\u0010\n\u001a\u0004\u0018\u00010\u00052\b\b\u0002\u0010\u000b\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u001b\u001a\u00020\u001c2\b\u0010\u001d\u001a\u0004\u0018\u00010\bHÖ\u0003J\t\u0010\u001e\u001a\u00020\u0003HÖ\u0001J\t\u0010\u001f\u001a\u00020\u0005HÖ\u0001J&\u0010 \u001a\u00020!2\u0006\u0010\"\u001a\u00020\u00002\u0006\u0010#\u001a\u00020$2\u0006\u0010%\u001a\u00020&HÁ\u0001¢\u0006\u0002\b'R'\u0010\u0006\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\b¢\u0006\u0002\b\t\u0018\u00010\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011R\u0016\u0010\n\u001a\u0004\u0018\u00010\u0005X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013R\u0014\u0010\u0004\u001a\u00020\u0005X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0013R\u0011\u0010\u000b\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0013¨\u0006*"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/SendMessageDto$Text;", "Lzendesk/conversationkit/android/internal/rest/model/SendMessageDto;", "seen1", "", "role", "", "metadata", "", "", "Lkotlinx/serialization/Contextual;", "payload", "text", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;)V", "getMetadata", "()Ljava/util/Map;", "getPayload", "()Ljava/lang/String;", "getRole", "getText", "component1", "component2", "component3", "component4", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("text")
    public static final class Text extends SendMessageDto {
        private final Map<String, Object> metadata;
        private final String payload;
        private final String role;
        private final String text;

        public static final Companion INSTANCE = new Companion(null);
        private static final KSerializer<Object>[] $childSerializers = {null, new LinkedHashMapSerializer(StringSerializer.INSTANCE, new ContextualSerializer(Reflection.getOrCreateKotlinClass(Object.class), null, new KSerializer[0])), null, null};

        public static Text copy$default(Text text, String str, Map map, String str2, String str3, int i, Object obj) {
            if ((i & 1) != 0) {
                str = text.role;
            }
            if ((i & 2) != 0) {
                map = text.metadata;
            }
            if ((i & 4) != 0) {
                str2 = text.payload;
            }
            if ((i & 8) != 0) {
                str3 = text.text;
            }
            return text.copy(str, map, str2, str3);
        }

        public final String getRole() {
            return this.role;
        }

        public final Map<String, Object> component2() {
            return this.metadata;
        }

        public final String getPayload() {
            return this.payload;
        }

        public final String getText() {
            return this.text;
        }

        public final Text copy(String role, Map<String, ? extends Object> metadata, String payload, String text) {
            Intrinsics.checkNotNullParameter(role, "role");
            Intrinsics.checkNotNullParameter(text, "text");
            return new Text(role, metadata, payload, text);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Text)) {
                return false;
            }
            Text text = (Text) other;
            return Intrinsics.areEqual(this.role, text.role) && Intrinsics.areEqual(this.metadata, text.metadata) && Intrinsics.areEqual(this.payload, text.payload) && Intrinsics.areEqual(this.text, text.text);
        }

        public int hashCode() {
            int iHashCode = this.role.hashCode() * 31;
            Map<String, Object> map = this.metadata;
            int iHashCode2 = (iHashCode + (map == null ? 0 : map.hashCode())) * 31;
            String str = this.payload;
            return ((iHashCode2 + (str != null ? str.hashCode() : 0)) * 31) + this.text.hashCode();
        }

        public String toString() {
            return "Text(role=" + this.role + ", metadata=" + this.metadata + ", payload=" + this.payload + ", text=" + this.text + ')';
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/SendMessageDto$Text$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/SendMessageDto$Text;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<Text> serializer() {
                return SendMessageDto$Text$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public Text(int i, String str, Map map, String str2, String str3, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, serializationConstructorMarker);
            if (9 != (i & 9)) {
                PluginExceptionsKt.throwMissingFieldException(i, 9, SendMessageDto$Text$$serializer.INSTANCE.getDescriptor());
            }
            this.role = str;
            if ((i & 2) == 0) {
                this.metadata = null;
            } else {
                this.metadata = map;
            }
            if ((i & 4) == 0) {
                this.payload = null;
            } else {
                this.payload = str2;
            }
            this.text = str3;
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(Text self, CompositeEncoder output, SerialDescriptor serialDesc) {
            SendMessageDto.write$Self(self, output, serialDesc);
            KSerializer<Object>[] kSerializerArr = $childSerializers;
            output.encodeStringElement(serialDesc, 0, self.getRole());
            if (output.shouldEncodeElementDefault(serialDesc, 1) || self.getMetadata() != null) {
                output.encodeNullableSerializableElement(serialDesc, 1, kSerializerArr[1], self.getMetadata());
            }
            if (output.shouldEncodeElementDefault(serialDesc, 2) || self.getPayload() != null) {
                output.encodeNullableSerializableElement(serialDesc, 2, StringSerializer.INSTANCE, self.getPayload());
            }
            output.encodeStringElement(serialDesc, 3, self.text);
        }

        public Text(String str, Map map, String str2, String str3, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this(str, (i & 2) != 0 ? null : map, (i & 4) != 0 ? null : str2, str3);
        }

        @Override
        public String getRole() {
            return this.role;
        }

        @Override
        public Map<String, Object> getMetadata() {
            return this.metadata;
        }

        @Override
        public String getPayload() {
            return this.payload;
        }

        public final String getText() {
            return this.text;
        }

        public Text(String role, Map<String, ? extends Object> map, String str, String text) {
            super("text", (DefaultConstructorMarker) null);
            Intrinsics.checkNotNullParameter(role, "role");
            Intrinsics.checkNotNullParameter(text, "text");
            this.role = role;
            this.metadata = map;
            this.payload = str;
            this.text = text;
        }
    }

    @Metadata(m17d1 = {"\u0000X\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010$\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0011\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 /2\u00020\u0001:\u0002./Bb\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\u0019\u0010\u0006\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\b¢\u0006\u0002\b\t\u0018\u00010\u0007\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u0005\u0012\u000e\u0010\u000b\u001a\n\u0012\u0004\u0012\u00020\r\u0018\u00010\f\u0012\b\u0010\u000e\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u000f\u001a\u0004\u0018\u00010\u0010¢\u0006\u0002\u0010\u0011BL\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u001b\b\u0002\u0010\u0006\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\b¢\u0006\u0002\b\t\u0018\u00010\u0007\u0012\n\b\u0002\u0010\n\u001a\u0004\u0018\u00010\u0005\u0012\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\r0\f\u0012\u0006\u0010\u000e\u001a\u00020\u0005¢\u0006\u0002\u0010\u0012J\t\u0010\u001b\u001a\u00020\u0005HÆ\u0003J\u001c\u0010\u001c\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\b¢\u0006\u0002\b\t\u0018\u00010\u0007HÆ\u0003J\u000b\u0010\u001d\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000f\u0010\u001e\u001a\b\u0012\u0004\u0012\u00020\r0\fHÆ\u0003J\t\u0010\u001f\u001a\u00020\u0005HÆ\u0003JV\u0010 \u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\u001b\b\u0002\u0010\u0006\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\b¢\u0006\u0002\b\t\u0018\u00010\u00072\n\b\u0002\u0010\n\u001a\u0004\u0018\u00010\u00052\u000e\b\u0002\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\r0\f2\b\b\u0002\u0010\u000e\u001a\u00020\u0005HÆ\u0001J\u0013\u0010!\u001a\u00020\"2\b\u0010#\u001a\u0004\u0018\u00010\bHÖ\u0003J\t\u0010$\u001a\u00020\u0003HÖ\u0001J\t\u0010%\u001a\u00020\u0005HÖ\u0001J&\u0010&\u001a\u00020'2\u0006\u0010(\u001a\u00020\u00002\u0006\u0010)\u001a\u00020*2\u0006\u0010+\u001a\u00020,HÁ\u0001¢\u0006\u0002\b-R\u0017\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\r0\f¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R'\u0010\u0006\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\b¢\u0006\u0002\b\t\u0018\u00010\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016R\u0016\u0010\n\u001a\u0004\u0018\u00010\u0005X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018R\u0011\u0010\u000e\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u0018R\u0014\u0010\u0004\u001a\u00020\u0005X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u0018¨\u00060"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/SendMessageDto$FormResponse;", "Lzendesk/conversationkit/android/internal/rest/model/SendMessageDto;", "seen1", "", "role", "", "metadata", "", "", "Lkotlinx/serialization/Contextual;", "payload", "fields", "", "Lzendesk/conversationkit/android/internal/rest/model/SendFieldResponseDto;", "quotedMessageId", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/util/Map;Ljava/lang/String;Ljava/util/List;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;Ljava/util/List;Ljava/lang/String;)V", "getFields", "()Ljava/util/List;", "getMetadata", "()Ljava/util/Map;", "getPayload", "()Ljava/lang/String;", "getQuotedMessageId", "getRole", "component1", "component2", "component3", "component4", "component5", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("formResponse")
    public static final class FormResponse extends SendMessageDto {
        private final List<SendFieldResponseDto> fields;
        private final Map<String, Object> metadata;
        private final String payload;
        private final String quotedMessageId;
        private final String role;

        public static final Companion INSTANCE = new Companion(null);
        private static final KSerializer<Object>[] $childSerializers = {null, new LinkedHashMapSerializer(StringSerializer.INSTANCE, new ContextualSerializer(Reflection.getOrCreateKotlinClass(Object.class), null, new KSerializer[0])), null, new ArrayListSerializer(SendFieldResponseDto.INSTANCE.serializer()), null};

        public static FormResponse copy$default(FormResponse formResponse, String str, Map map, String str2, List list, String str3, int i, Object obj) {
            if ((i & 1) != 0) {
                str = formResponse.role;
            }
            if ((i & 2) != 0) {
                map = formResponse.metadata;
            }
            Map map2 = map;
            if ((i & 4) != 0) {
                str2 = formResponse.payload;
            }
            String str4 = str2;
            if ((i & 8) != 0) {
                list = formResponse.fields;
            }
            List list2 = list;
            if ((i & 16) != 0) {
                str3 = formResponse.quotedMessageId;
            }
            return formResponse.copy(str, map2, str4, list2, str3);
        }

        public final String getRole() {
            return this.role;
        }

        public final Map<String, Object> component2() {
            return this.metadata;
        }

        public final String getPayload() {
            return this.payload;
        }

        public final List<SendFieldResponseDto> component4() {
            return this.fields;
        }

        public final String getQuotedMessageId() {
            return this.quotedMessageId;
        }

        public final FormResponse copy(String role, Map<String, ? extends Object> metadata, String payload, List<? extends SendFieldResponseDto> fields, String quotedMessageId) {
            Intrinsics.checkNotNullParameter(role, "role");
            Intrinsics.checkNotNullParameter(fields, "fields");
            Intrinsics.checkNotNullParameter(quotedMessageId, "quotedMessageId");
            return new FormResponse(role, metadata, payload, fields, quotedMessageId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof FormResponse)) {
                return false;
            }
            FormResponse formResponse = (FormResponse) other;
            return Intrinsics.areEqual(this.role, formResponse.role) && Intrinsics.areEqual(this.metadata, formResponse.metadata) && Intrinsics.areEqual(this.payload, formResponse.payload) && Intrinsics.areEqual(this.fields, formResponse.fields) && Intrinsics.areEqual(this.quotedMessageId, formResponse.quotedMessageId);
        }

        public int hashCode() {
            int iHashCode = this.role.hashCode() * 31;
            Map<String, Object> map = this.metadata;
            int iHashCode2 = (iHashCode + (map == null ? 0 : map.hashCode())) * 31;
            String str = this.payload;
            return ((((iHashCode2 + (str != null ? str.hashCode() : 0)) * 31) + this.fields.hashCode()) * 31) + this.quotedMessageId.hashCode();
        }

        public String toString() {
            return "FormResponse(role=" + this.role + ", metadata=" + this.metadata + ", payload=" + this.payload + ", fields=" + this.fields + ", quotedMessageId=" + this.quotedMessageId + ')';
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/SendMessageDto$FormResponse$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/SendMessageDto$FormResponse;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<FormResponse> serializer() {
                return SendMessageDto$FormResponse$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public FormResponse(int i, String str, Map map, String str2, List list, String str3, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, serializationConstructorMarker);
            if (25 != (i & 25)) {
                PluginExceptionsKt.throwMissingFieldException(i, 25, SendMessageDto$FormResponse$$serializer.INSTANCE.getDescriptor());
            }
            this.role = str;
            if ((i & 2) == 0) {
                this.metadata = null;
            } else {
                this.metadata = map;
            }
            if ((i & 4) == 0) {
                this.payload = null;
            } else {
                this.payload = str2;
            }
            this.fields = list;
            this.quotedMessageId = str3;
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(FormResponse self, CompositeEncoder output, SerialDescriptor serialDesc) {
            SendMessageDto.write$Self(self, output, serialDesc);
            KSerializer<Object>[] kSerializerArr = $childSerializers;
            output.encodeStringElement(serialDesc, 0, self.getRole());
            if (output.shouldEncodeElementDefault(serialDesc, 1) || self.getMetadata() != null) {
                output.encodeNullableSerializableElement(serialDesc, 1, kSerializerArr[1], self.getMetadata());
            }
            if (output.shouldEncodeElementDefault(serialDesc, 2) || self.getPayload() != null) {
                output.encodeNullableSerializableElement(serialDesc, 2, StringSerializer.INSTANCE, self.getPayload());
            }
            output.encodeSerializableElement(serialDesc, 3, kSerializerArr[3], self.fields);
            output.encodeStringElement(serialDesc, 4, self.quotedMessageId);
        }

        public FormResponse(String str, Map map, String str2, List list, String str3, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this(str, (i & 2) != 0 ? null : map, (i & 4) != 0 ? null : str2, list, str3);
        }

        @Override
        public String getRole() {
            return this.role;
        }

        @Override
        public Map<String, Object> getMetadata() {
            return this.metadata;
        }

        @Override
        public String getPayload() {
            return this.payload;
        }

        public final List<SendFieldResponseDto> getFields() {
            return this.fields;
        }

        public final String getQuotedMessageId() {
            return this.quotedMessageId;
        }

        public FormResponse(String role, Map<String, ? extends Object> map, String str, List<? extends SendFieldResponseDto> fields, String quotedMessageId) {
            super("formResponse", (DefaultConstructorMarker) null);
            Intrinsics.checkNotNullParameter(role, "role");
            Intrinsics.checkNotNullParameter(fields, "fields");
            Intrinsics.checkNotNullParameter(quotedMessageId, "quotedMessageId");
            this.role = role;
            this.metadata = map;
            this.payload = str;
            this.fields = fields;
            this.quotedMessageId = quotedMessageId;
        }
    }
}
