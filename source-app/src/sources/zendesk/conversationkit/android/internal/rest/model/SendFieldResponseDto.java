package zendesk.conversationkit.android.internal.rest.model;

import java.lang.annotation.Annotation;
import java.util.List;
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
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.SealedClassSerializer;
import kotlinx.serialization.SerialName;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.ArrayListSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;

@Metadata(m17d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b1\u0018\u0000 \u00192\u00020\u0001:\u0004\u0019\u001a\u001b\u001cB#\b\u0017\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007¢\u0006\u0002\u0010\bB\u000f\b\u0004\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\tJ!\u0010\u0012\u001a\u00020\u00132\u0006\u0010\u0014\u001a\u00020\u00002\u0006\u0010\u0015\u001a\u00020\u00162\u0006\u0010\u0017\u001a\u00020\u0018HÇ\u0001R\u0012\u0010\n\u001a\u00020\u0005X¦\u0004¢\u0006\u0006\u001a\u0004\b\u000b\u0010\fR\u0012\u0010\r\u001a\u00020\u0005X¦\u0004¢\u0006\u0006\u001a\u0004\b\u000e\u0010\fR\u0012\u0010\u000f\u001a\u00020\u0005X¦\u0004¢\u0006\u0006\u001a\u0004\b\u0010\u0010\fR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\f\u0082\u0001\u0003\u001d\u001e\u001f¨\u0006 "}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/SendFieldResponseDto;", "", "seen1", "", "sendFieldResponseType", "", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;)V", "id", "getId", "()Ljava/lang/String;", "label", "getLabel", "name", "getName", "getSendFieldResponseType", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "Companion", "Email", "Select", "Text", "Lzendesk/conversationkit/android/internal/rest/model/SendFieldResponseDto$Email;", "Lzendesk/conversationkit/android/internal/rest/model/SendFieldResponseDto$Select;", "Lzendesk/conversationkit/android/internal/rest/model/SendFieldResponseDto$Text;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public abstract class SendFieldResponseDto {
    private final String sendFieldResponseType;

    public static final Companion INSTANCE = new Companion(null);
    private static final Lazy<KSerializer<Object>> $cachedSerializer$delegate = LazyKt.lazy(LazyThreadSafetyMode.PUBLICATION, (Function0) new Function0<KSerializer<Object>>() {
        @Override
        public final KSerializer<Object> invoke() {
            return new SealedClassSerializer("zendesk.conversationkit.android.internal.rest.model.SendFieldResponseDto", Reflection.getOrCreateKotlinClass(SendFieldResponseDto.class), new KClass[]{Reflection.getOrCreateKotlinClass(Email.class), Reflection.getOrCreateKotlinClass(Select.class), Reflection.getOrCreateKotlinClass(Text.class)}, new KSerializer[]{SendFieldResponseDto$Email$$serializer.INSTANCE, SendFieldResponseDto$Select$$serializer.INSTANCE, SendFieldResponseDto$Text$$serializer.INSTANCE}, new Annotation[0]);
        }
    });

    public SendFieldResponseDto(String str, DefaultConstructorMarker defaultConstructorMarker) {
        this(str);
    }

    public abstract String getId();

    public abstract String getLabel();

    public abstract String getName();

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/SendFieldResponseDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/SendFieldResponseDto;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        private final KSerializer get$cachedSerializer() {
            return (KSerializer) SendFieldResponseDto.$cachedSerializer$delegate.getValue();
        }

        public final KSerializer<SendFieldResponseDto> serializer() {
            return get$cachedSerializer();
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public SendFieldResponseDto(int i, String str, SerializationConstructorMarker serializationConstructorMarker) {
        this.sendFieldResponseType = str;
    }

    private SendFieldResponseDto(String str) {
        this.sendFieldResponseType = str;
    }

    @JvmStatic
    public static final void write$Self(SendFieldResponseDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeStringElement(serialDesc, 0, self.sendFieldResponseType);
    }

    public final String getSendFieldResponseType() {
        return this.sendFieldResponseType;
    }

    @Metadata(m17d1 = {"\u0000D\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u000f\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 )2\u00020\u0001:\u0002()BM\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\t\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u000b¢\u0006\u0002\u0010\fB%\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\u0005\u0012\u0006\u0010\b\u001a\u00020\u0005\u0012\u0006\u0010\t\u001a\u00020\u0005¢\u0006\u0002\u0010\rJ\t\u0010\u0015\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0016\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0017\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0018\u001a\u00020\u0005HÆ\u0003J1\u0010\u0019\u001a\u00020\u00002\b\b\u0002\u0010\u0006\u001a\u00020\u00052\b\b\u0002\u0010\u0007\u001a\u00020\u00052\b\b\u0002\u0010\b\u001a\u00020\u00052\b\b\u0002\u0010\t\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u001a\u001a\u00020\u001b2\b\u0010\u001c\u001a\u0004\u0018\u00010\u001dHÖ\u0003J\t\u0010\u001e\u001a\u00020\u0003HÖ\u0001J\t\u0010\u001f\u001a\u00020\u0005HÖ\u0001J&\u0010 \u001a\u00020!2\u0006\u0010\"\u001a\u00020\u00002\u0006\u0010#\u001a\u00020$2\u0006\u0010%\u001a\u00020&HÁ\u0001¢\u0006\u0002\b'R\u001c\u0010\u0006\u001a\u00020\u00058\u0016X\u0097\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u000e\u0010\u000f\u001a\u0004\b\u0010\u0010\u0011R\u0014\u0010\b\u001a\u00020\u0005X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0011R\u0014\u0010\u0007\u001a\u00020\u0005X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0011R\u0011\u0010\t\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0011¨\u0006*"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/SendFieldResponseDto$Text;", "Lzendesk/conversationkit/android/internal/rest/model/SendFieldResponseDto;", "seen1", "", "sendFieldResponseType", "", "id", "name", "label", "text", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", "getId$annotations", "()V", "getId", "()Ljava/lang/String;", "getLabel", "getName", "getText", "component1", "component2", "component3", "component4", "copy", "equals", "", "other", "", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("text")
    public static final class Text extends SendFieldResponseDto {

        public static final Companion INSTANCE = new Companion(null);
        private final String id;
        private final String label;
        private final String name;
        private final String text;

        public static Text copy$default(Text text, String str, String str2, String str3, String str4, int i, Object obj) {
            if ((i & 1) != 0) {
                str = text.id;
            }
            if ((i & 2) != 0) {
                str2 = text.name;
            }
            if ((i & 4) != 0) {
                str3 = text.label;
            }
            if ((i & 8) != 0) {
                str4 = text.text;
            }
            return text.copy(str, str2, str3, str4);
        }

        @SerialName("_id")
        public static void getId$annotations() {
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

        public final String getText() {
            return this.text;
        }

        public final Text copy(String id, String name, String label, String text) {
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(name, "name");
            Intrinsics.checkNotNullParameter(label, "label");
            Intrinsics.checkNotNullParameter(text, "text");
            return new Text(id, name, label, text);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Text)) {
                return false;
            }
            Text text = (Text) other;
            return Intrinsics.areEqual(this.id, text.id) && Intrinsics.areEqual(this.name, text.name) && Intrinsics.areEqual(this.label, text.label) && Intrinsics.areEqual(this.text, text.text);
        }

        public int hashCode() {
            return (((((this.id.hashCode() * 31) + this.name.hashCode()) * 31) + this.label.hashCode()) * 31) + this.text.hashCode();
        }

        public String toString() {
            return "Text(id=" + this.id + ", name=" + this.name + ", label=" + this.label + ", text=" + this.text + ')';
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/SendFieldResponseDto$Text$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/SendFieldResponseDto$Text;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<Text> serializer() {
                return SendFieldResponseDto$Text$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public Text(int i, String str, @SerialName("_id") String str2, String str3, String str4, String str5, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, str, serializationConstructorMarker);
            if (31 != (i & 31)) {
                PluginExceptionsKt.throwMissingFieldException(i, 31, SendFieldResponseDto$Text$$serializer.INSTANCE.getDescriptor());
            }
            this.id = str2;
            this.name = str3;
            this.label = str4;
            this.text = str5;
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(Text self, CompositeEncoder output, SerialDescriptor serialDesc) {
            SendFieldResponseDto.write$Self(self, output, serialDesc);
            output.encodeStringElement(serialDesc, 1, self.getId());
            output.encodeStringElement(serialDesc, 2, self.getName());
            output.encodeStringElement(serialDesc, 3, self.getLabel());
            output.encodeStringElement(serialDesc, 4, self.text);
        }

        @Override
        public String getId() {
            return this.id;
        }

        @Override
        public String getName() {
            return this.name;
        }

        @Override
        public String getLabel() {
            return this.label;
        }

        public final String getText() {
            return this.text;
        }

        public Text(String id, String name, String label, String text) {
            super("text", null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(name, "name");
            Intrinsics.checkNotNullParameter(label, "label");
            Intrinsics.checkNotNullParameter(text, "text");
            this.id = id;
            this.name = name;
            this.label = label;
            this.text = text;
        }
    }

    @Metadata(m17d1 = {"\u0000D\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u000f\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 )2\u00020\u0001:\u0002()BM\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\t\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u000b¢\u0006\u0002\u0010\fB%\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\u0005\u0012\u0006\u0010\b\u001a\u00020\u0005\u0012\u0006\u0010\t\u001a\u00020\u0005¢\u0006\u0002\u0010\rJ\t\u0010\u0015\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0016\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0017\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0018\u001a\u00020\u0005HÆ\u0003J1\u0010\u0019\u001a\u00020\u00002\b\b\u0002\u0010\u0006\u001a\u00020\u00052\b\b\u0002\u0010\u0007\u001a\u00020\u00052\b\b\u0002\u0010\b\u001a\u00020\u00052\b\b\u0002\u0010\t\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u001a\u001a\u00020\u001b2\b\u0010\u001c\u001a\u0004\u0018\u00010\u001dHÖ\u0003J\t\u0010\u001e\u001a\u00020\u0003HÖ\u0001J\t\u0010\u001f\u001a\u00020\u0005HÖ\u0001J&\u0010 \u001a\u00020!2\u0006\u0010\"\u001a\u00020\u00002\u0006\u0010#\u001a\u00020$2\u0006\u0010%\u001a\u00020&HÁ\u0001¢\u0006\u0002\b'R\u0011\u0010\t\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u001c\u0010\u0006\u001a\u00020\u00058\u0016X\u0097\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0010\u0010\u0011\u001a\u0004\b\u0012\u0010\u000fR\u0014\u0010\b\u001a\u00020\u0005X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u000fR\u0014\u0010\u0007\u001a\u00020\u0005X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u000f¨\u0006*"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/SendFieldResponseDto$Email;", "Lzendesk/conversationkit/android/internal/rest/model/SendFieldResponseDto;", "seen1", "", "sendFieldResponseType", "", "id", "name", "label", "email", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", "getEmail", "()Ljava/lang/String;", "getId$annotations", "()V", "getId", "getLabel", "getName", "component1", "component2", "component3", "component4", "copy", "equals", "", "other", "", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("email")
    public static final class Email extends SendFieldResponseDto {

        public static final Companion INSTANCE = new Companion(null);
        private final String email;
        private final String id;
        private final String label;
        private final String name;

        public static Email copy$default(Email email, String str, String str2, String str3, String str4, int i, Object obj) {
            if ((i & 1) != 0) {
                str = email.id;
            }
            if ((i & 2) != 0) {
                str2 = email.name;
            }
            if ((i & 4) != 0) {
                str3 = email.label;
            }
            if ((i & 8) != 0) {
                str4 = email.email;
            }
            return email.copy(str, str2, str3, str4);
        }

        @SerialName("_id")
        public static void getId$annotations() {
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

        public final String getEmail() {
            return this.email;
        }

        public final Email copy(String id, String name, String label, String email) {
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(name, "name");
            Intrinsics.checkNotNullParameter(label, "label");
            Intrinsics.checkNotNullParameter(email, "email");
            return new Email(id, name, label, email);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Email)) {
                return false;
            }
            Email email = (Email) other;
            return Intrinsics.areEqual(this.id, email.id) && Intrinsics.areEqual(this.name, email.name) && Intrinsics.areEqual(this.label, email.label) && Intrinsics.areEqual(this.email, email.email);
        }

        public int hashCode() {
            return (((((this.id.hashCode() * 31) + this.name.hashCode()) * 31) + this.label.hashCode()) * 31) + this.email.hashCode();
        }

        public String toString() {
            return "Email(id=" + this.id + ", name=" + this.name + ", label=" + this.label + ", email=" + this.email + ')';
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/SendFieldResponseDto$Email$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/SendFieldResponseDto$Email;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<Email> serializer() {
                return SendFieldResponseDto$Email$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public Email(int i, String str, @SerialName("_id") String str2, String str3, String str4, String str5, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, str, serializationConstructorMarker);
            if (31 != (i & 31)) {
                PluginExceptionsKt.throwMissingFieldException(i, 31, SendFieldResponseDto$Email$$serializer.INSTANCE.getDescriptor());
            }
            this.id = str2;
            this.name = str3;
            this.label = str4;
            this.email = str5;
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(Email self, CompositeEncoder output, SerialDescriptor serialDesc) {
            SendFieldResponseDto.write$Self(self, output, serialDesc);
            output.encodeStringElement(serialDesc, 1, self.getId());
            output.encodeStringElement(serialDesc, 2, self.getName());
            output.encodeStringElement(serialDesc, 3, self.getLabel());
            output.encodeStringElement(serialDesc, 4, self.email);
        }

        @Override
        public String getId() {
            return this.id;
        }

        @Override
        public String getName() {
            return this.name;
        }

        @Override
        public String getLabel() {
            return this.label;
        }

        public final String getEmail() {
            return this.email;
        }

        public Email(String id, String name, String label, String email) {
            super("email", null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(name, "name");
            Intrinsics.checkNotNullParameter(label, "label");
            Intrinsics.checkNotNullParameter(email, "email");
            this.id = id;
            this.name = name;
            this.label = label;
            this.email = email;
        }
    }

    @Metadata(m17d1 = {"\u0000N\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0010\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 ,2\u00020\u0001:\u0002+,BS\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0005\u0012\u000e\u0010\t\u001a\n\u0012\u0004\u0012\u00020\u000b\u0018\u00010\n\u0012\b\u0010\f\u001a\u0004\u0018\u00010\r¢\u0006\u0002\u0010\u000eB+\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\u0005\u0012\u0006\u0010\b\u001a\u00020\u0005\u0012\f\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u000b0\n¢\u0006\u0002\u0010\u000fJ\t\u0010\u0018\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0019\u001a\u00020\u0005HÆ\u0003J\t\u0010\u001a\u001a\u00020\u0005HÆ\u0003J\u000f\u0010\u001b\u001a\b\u0012\u0004\u0012\u00020\u000b0\nHÆ\u0003J7\u0010\u001c\u001a\u00020\u00002\b\b\u0002\u0010\u0006\u001a\u00020\u00052\b\b\u0002\u0010\u0007\u001a\u00020\u00052\b\b\u0002\u0010\b\u001a\u00020\u00052\u000e\b\u0002\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u000b0\nHÆ\u0001J\u0013\u0010\u001d\u001a\u00020\u001e2\b\u0010\u001f\u001a\u0004\u0018\u00010 HÖ\u0003J\t\u0010!\u001a\u00020\u0003HÖ\u0001J\t\u0010\"\u001a\u00020\u0005HÖ\u0001J&\u0010#\u001a\u00020$2\u0006\u0010%\u001a\u00020\u00002\u0006\u0010&\u001a\u00020'2\u0006\u0010(\u001a\u00020)HÁ\u0001¢\u0006\u0002\b*R\u001c\u0010\u0006\u001a\u00020\u00058\u0016X\u0097\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0010\u0010\u0011\u001a\u0004\b\u0012\u0010\u0013R\u0014\u0010\b\u001a\u00020\u0005X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0013R\u0014\u0010\u0007\u001a\u00020\u0005X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0013R\u0017\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u000b0\n¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0017¨\u0006-"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/SendFieldResponseDto$Select;", "Lzendesk/conversationkit/android/internal/rest/model/SendFieldResponseDto;", "seen1", "", "sendFieldResponseType", "", "id", "name", "label", "select", "", "Lzendesk/conversationkit/android/internal/rest/model/SendFieldSelectDto;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/List;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/List;)V", "getId$annotations", "()V", "getId", "()Ljava/lang/String;", "getLabel", "getName", "getSelect", "()Ljava/util/List;", "component1", "component2", "component3", "component4", "copy", "equals", "", "other", "", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("select")
    public static final class Select extends SendFieldResponseDto {
        private final String id;
        private final String label;
        private final String name;
        private final List<SendFieldSelectDto> select;

        public static final Companion INSTANCE = new Companion(null);
        private static final KSerializer<Object>[] $childSerializers = {null, null, null, null, new ArrayListSerializer(SendFieldSelectDto$$serializer.INSTANCE)};

        public static Select copy$default(Select select, String str, String str2, String str3, List list, int i, Object obj) {
            if ((i & 1) != 0) {
                str = select.id;
            }
            if ((i & 2) != 0) {
                str2 = select.name;
            }
            if ((i & 4) != 0) {
                str3 = select.label;
            }
            if ((i & 8) != 0) {
                list = select.select;
            }
            return select.copy(str, str2, str3, list);
        }

        @SerialName("_id")
        public static void getId$annotations() {
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

        public final List<SendFieldSelectDto> component4() {
            return this.select;
        }

        public final Select copy(String id, String name, String label, List<SendFieldSelectDto> select) {
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(name, "name");
            Intrinsics.checkNotNullParameter(label, "label");
            Intrinsics.checkNotNullParameter(select, "select");
            return new Select(id, name, label, select);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Select)) {
                return false;
            }
            Select select = (Select) other;
            return Intrinsics.areEqual(this.id, select.id) && Intrinsics.areEqual(this.name, select.name) && Intrinsics.areEqual(this.label, select.label) && Intrinsics.areEqual(this.select, select.select);
        }

        public int hashCode() {
            return (((((this.id.hashCode() * 31) + this.name.hashCode()) * 31) + this.label.hashCode()) * 31) + this.select.hashCode();
        }

        public String toString() {
            return "Select(id=" + this.id + ", name=" + this.name + ", label=" + this.label + ", select=" + this.select + ')';
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/SendFieldResponseDto$Select$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/SendFieldResponseDto$Select;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<Select> serializer() {
                return SendFieldResponseDto$Select$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public Select(int i, String str, @SerialName("_id") String str2, String str3, String str4, List list, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, str, serializationConstructorMarker);
            if (31 != (i & 31)) {
                PluginExceptionsKt.throwMissingFieldException(i, 31, SendFieldResponseDto$Select$$serializer.INSTANCE.getDescriptor());
            }
            this.id = str2;
            this.name = str3;
            this.label = str4;
            this.select = list;
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(Select self, CompositeEncoder output, SerialDescriptor serialDesc) {
            SendFieldResponseDto.write$Self(self, output, serialDesc);
            KSerializer<Object>[] kSerializerArr = $childSerializers;
            output.encodeStringElement(serialDesc, 1, self.getId());
            output.encodeStringElement(serialDesc, 2, self.getName());
            output.encodeStringElement(serialDesc, 3, self.getLabel());
            output.encodeSerializableElement(serialDesc, 4, kSerializerArr[4], self.select);
        }

        @Override
        public String getId() {
            return this.id;
        }

        @Override
        public String getName() {
            return this.name;
        }

        @Override
        public String getLabel() {
            return this.label;
        }

        public final List<SendFieldSelectDto> getSelect() {
            return this.select;
        }

        public Select(String id, String name, String label, List<SendFieldSelectDto> select) {
            super("select", null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(name, "name");
            Intrinsics.checkNotNullParameter(label, "label");
            Intrinsics.checkNotNullParameter(select, "select");
            this.id = id;
            this.name = name;
            this.label = label;
            this.select = select;
        }
    }
}
