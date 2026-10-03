package zendesk.conversationkit.android.model;

import java.lang.annotation.Annotation;
import java.util.List;
import java.util.UUID;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Lazy;
import kotlin.LazyKt;
import kotlin.LazyThreadSafetyMode;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.UByte$$ExternalSyntheticBackport0;
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
import kotlinx.serialization.Transient;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.ArrayListSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;
import zendesk.conversationkit.android.internal.FileExtKt;

@Metadata(m17d1 = {"\u0000X\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b7\u0018\u0000 \u00162\u00020\u0001:\t\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001dB\u0019\b\u0017\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005¢\u0006\u0002\u0010\u0006B\u0011\b\u0004\u0012\b\b\u0002\u0010\u0007\u001a\u00020\b¢\u0006\u0002\u0010\tJ!\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u00002\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0014HÇ\u0001R\u001c\u0010\u0007\u001a\u00020\b8\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\n\u0010\u000b\u001a\u0004\b\f\u0010\r\u0082\u0001\b\u001e\u001f !\"#$%¨\u0006&"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageContent;", "", "seen1", "", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILkotlinx/serialization/internal/SerializationConstructorMarker;)V", "messageContentType", "Lzendesk/conversationkit/android/model/MessageType;", "(Lzendesk/conversationkit/android/model/MessageType;)V", "getMessageContentType$annotations", "()V", "getMessageContentType", "()Lzendesk/conversationkit/android/model/MessageType;", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "Carousel", "Companion", "File", "FileUpload", "Form", "FormResponse", "Image", "Text", "Unsupported", "Lzendesk/conversationkit/android/model/MessageContent$Carousel;", "Lzendesk/conversationkit/android/model/MessageContent$File;", "Lzendesk/conversationkit/android/model/MessageContent$FileUpload;", "Lzendesk/conversationkit/android/model/MessageContent$Form;", "Lzendesk/conversationkit/android/model/MessageContent$FormResponse;", "Lzendesk/conversationkit/android/model/MessageContent$Image;", "Lzendesk/conversationkit/android/model/MessageContent$Text;", "Lzendesk/conversationkit/android/model/MessageContent$Unsupported;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public abstract class MessageContent {
    private final MessageType messageContentType;

    public static final Companion INSTANCE = new Companion(null);
    private static final Lazy<KSerializer<Object>> $cachedSerializer$delegate = LazyKt.lazy(LazyThreadSafetyMode.PUBLICATION, (Function0) new Function0<KSerializer<Object>>() {
        @Override
        public final KSerializer<Object> invoke() {
            return new SealedClassSerializer("zendesk.conversationkit.android.model.MessageContent", Reflection.getOrCreateKotlinClass(MessageContent.class), new KClass[]{Reflection.getOrCreateKotlinClass(Carousel.class), Reflection.getOrCreateKotlinClass(File.class), Reflection.getOrCreateKotlinClass(FileUpload.class), Reflection.getOrCreateKotlinClass(Form.class), Reflection.getOrCreateKotlinClass(FormResponse.class), Reflection.getOrCreateKotlinClass(Image.class), Reflection.getOrCreateKotlinClass(Text.class), Reflection.getOrCreateKotlinClass(Unsupported.class)}, new KSerializer[]{MessageContent$Carousel$$serializer.INSTANCE, MessageContent$File$$serializer.INSTANCE, MessageContent$FileUpload$$serializer.INSTANCE, MessageContent$Form$$serializer.INSTANCE, MessageContent$FormResponse$$serializer.INSTANCE, MessageContent$Image$$serializer.INSTANCE, MessageContent$Text$$serializer.INSTANCE, MessageContent$Unsupported$$serializer.INSTANCE}, new Annotation[0]);
        }
    });

    public MessageContent(MessageType messageType, DefaultConstructorMarker defaultConstructorMarker) {
        this(messageType);
    }

    @Transient
    public static void getMessageContentType$annotations() {
    }

    @JvmStatic
    public static final void write$Self(MessageContent self, CompositeEncoder output, SerialDescriptor serialDesc) {
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageContent$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/MessageContent;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        private final KSerializer get$cachedSerializer() {
            return (KSerializer) MessageContent.$cachedSerializer$delegate.getValue();
        }

        public final KSerializer<MessageContent> serializer() {
            return get$cachedSerializer();
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public MessageContent(int i, SerializationConstructorMarker serializationConstructorMarker) {
        this.messageContentType = MessageType.UNSUPPORTED;
    }

    private MessageContent(MessageType messageType) {
        this.messageContentType = messageType;
    }

    public MessageContent(MessageType messageType, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? MessageType.UNSUPPORTED : messageType, (DefaultConstructorMarker) null);
    }

    public final MessageType getMessageContentType() {
        return this.messageContentType;
    }

    @Metadata(m17d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 \u001e2\u00020\u0001:\u0002\u001d\u001eB#\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007¢\u0006\u0002\u0010\bB\u000f\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\tJ\u000e\u0010\f\u001a\u00020\u0005HÀ\u0003¢\u0006\u0002\b\rJ\u0013\u0010\u000e\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u000f\u001a\u00020\u00102\b\u0010\u0011\u001a\u0004\u0018\u00010\u0012HÖ\u0003J\t\u0010\u0013\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0014\u001a\u00020\u0005HÖ\u0001J&\u0010\u0015\u001a\u00020\u00162\u0006\u0010\u0017\u001a\u00020\u00002\u0006\u0010\u0018\u001a\u00020\u00192\u0006\u0010\u001a\u001a\u00020\u001bHÁ\u0001¢\u0006\u0002\b\u001cR\u0014\u0010\u0004\u001a\u00020\u0005X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000b¨\u0006\u001f"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageContent$Unsupported;", "Lzendesk/conversationkit/android/model/MessageContent;", "seen1", "", "id", "", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;)V", "getId$zendesk_conversationkit_conversationkit_android", "()Ljava/lang/String;", "component1", "component1$zendesk_conversationkit_conversationkit_android", "copy", "equals", "", "other", "", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("unsupported")
    public static final class Unsupported extends MessageContent {

        public static final Companion INSTANCE = new Companion(null);
        private final String id;

        public Unsupported() {
            this((String) null, 1, (DefaultConstructorMarker) (0 == true ? 1 : 0));
        }

        public static Unsupported copy$default(Unsupported unsupported, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = unsupported.id;
            }
            return unsupported.copy(str);
        }

        public final String getId() {
            return this.id;
        }

        public final Unsupported copy(String id) {
            Intrinsics.checkNotNullParameter(id, "id");
            return new Unsupported(id);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof Unsupported) && Intrinsics.areEqual(this.id, ((Unsupported) other).id);
        }

        public int hashCode() {
            return this.id.hashCode();
        }

        public String toString() {
            return "Unsupported(id=" + this.id + ')';
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageContent$Unsupported$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/MessageContent$Unsupported;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<Unsupported> serializer() {
                return MessageContent$Unsupported$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public Unsupported(int i, String str, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, serializationConstructorMarker);
            if ((i & 1) != 0) {
                this.id = str;
                return;
            }
            String string = UUID.randomUUID().toString();
            Intrinsics.checkNotNullExpressionValue(string, "toString(...)");
            this.id = string;
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(Unsupported self, CompositeEncoder output, SerialDescriptor serialDesc) {
            MessageContent.write$Self(self, output, serialDesc);
            if (!output.shouldEncodeElementDefault(serialDesc, 0)) {
                String str = self.id;
                String string = UUID.randomUUID().toString();
                Intrinsics.checkNotNullExpressionValue(string, "toString(...)");
                if (Intrinsics.areEqual(str, string)) {
                    return;
                }
            }
            output.encodeStringElement(serialDesc, 0, self.id);
        }

        public Unsupported(String str, int i, DefaultConstructorMarker defaultConstructorMarker) {
            if ((i & 1) != 0) {
                str = UUID.randomUUID().toString();
                Intrinsics.checkNotNullExpressionValue(str, "toString(...)");
            }
            this(str);
        }

        public final String getId$zendesk_conversationkit_conversationkit_android() {
            return this.id;
        }

        public Unsupported(String id) {
            super(MessageType.UNSUPPORTED, (DefaultConstructorMarker) null);
            Intrinsics.checkNotNullParameter(id, "id");
            this.id = id;
        }
    }

    @Metadata(m17d1 = {"\u0000L\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 #2\u00020\u0001:\u0002\"#B3\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\u000e\u0010\u0006\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007\u0012\b\u0010\t\u001a\u0004\u0018\u00010\n¢\u0006\u0002\u0010\u000bB\u001f\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0010\b\u0002\u0010\u0006\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007¢\u0006\u0002\u0010\fJ\t\u0010\u0011\u001a\u00020\u0005HÆ\u0003J\u0011\u0010\u0012\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007HÆ\u0003J%\u0010\u0013\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\u0010\b\u0002\u0010\u0006\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007HÆ\u0001J\u0013\u0010\u0014\u001a\u00020\u00152\b\u0010\u0016\u001a\u0004\u0018\u00010\u0017HÖ\u0003J\t\u0010\u0018\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0019\u001a\u00020\u0005HÖ\u0001J&\u0010\u001a\u001a\u00020\u001b2\u0006\u0010\u001c\u001a\u00020\u00002\u0006\u0010\u001d\u001a\u00020\u001e2\u0006\u0010\u001f\u001a\u00020 HÁ\u0001¢\u0006\u0002\b!R\u0019\u0010\u0006\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010¨\u0006$"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageContent$Text;", "Lzendesk/conversationkit/android/model/MessageContent;", "seen1", "", "text", "", "actions", "", "Lzendesk/conversationkit/android/model/MessageAction;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/util/List;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/util/List;)V", "getActions", "()Ljava/util/List;", "getText", "()Ljava/lang/String;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("text")
    public static final class Text extends MessageContent {
        private final List<MessageAction> actions;
        private final String text;

        public static final Companion INSTANCE = new Companion(null);
        private static final KSerializer<Object>[] $childSerializers = {null, new ArrayListSerializer(MessageAction.INSTANCE.serializer())};

        public static Text copy$default(Text text, String str, List list, int i, Object obj) {
            if ((i & 1) != 0) {
                str = text.text;
            }
            if ((i & 2) != 0) {
                list = text.actions;
            }
            return text.copy(str, list);
        }

        public final String getText() {
            return this.text;
        }

        public final List<MessageAction> component2() {
            return this.actions;
        }

        public final Text copy(String text, List<? extends MessageAction> actions) {
            Intrinsics.checkNotNullParameter(text, "text");
            return new Text(text, actions);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Text)) {
                return false;
            }
            Text text = (Text) other;
            return Intrinsics.areEqual(this.text, text.text) && Intrinsics.areEqual(this.actions, text.actions);
        }

        public int hashCode() {
            int iHashCode = this.text.hashCode() * 31;
            List<MessageAction> list = this.actions;
            return iHashCode + (list == null ? 0 : list.hashCode());
        }

        public String toString() {
            return "Text(text=" + this.text + ", actions=" + this.actions + ')';
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageContent$Text$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/MessageContent$Text;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<Text> serializer() {
                return MessageContent$Text$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public Text(int i, String str, List list, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, serializationConstructorMarker);
            if (1 != (i & 1)) {
                PluginExceptionsKt.throwMissingFieldException(i, 1, MessageContent$Text$$serializer.INSTANCE.getDescriptor());
            }
            this.text = str;
            if ((i & 2) == 0) {
                this.actions = null;
            } else {
                this.actions = list;
            }
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(Text self, CompositeEncoder output, SerialDescriptor serialDesc) {
            MessageContent.write$Self(self, output, serialDesc);
            KSerializer<Object>[] kSerializerArr = $childSerializers;
            output.encodeStringElement(serialDesc, 0, self.text);
            if (!output.shouldEncodeElementDefault(serialDesc, 1) && self.actions == null) {
                return;
            }
            output.encodeNullableSerializableElement(serialDesc, 1, kSerializerArr[1], self.actions);
        }

        public Text(String str, List list, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this(str, (i & 2) != 0 ? null : list);
        }

        public final String getText() {
            return this.text;
        }

        public final List<MessageAction> getActions() {
            return this.actions;
        }

        public Text(String text, List<? extends MessageAction> list) {
            super(MessageType.TEXT, (DefaultConstructorMarker) null);
            Intrinsics.checkNotNullParameter(text, "text");
            this.text = text;
            this.actions = list;
        }
    }

    @Metadata(m17d1 = {"\u0000L\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\t\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u000e\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 )2\u00020\u0001:\u0002()B?\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\u0006\u0010\u0007\u001a\u00020\b\u0012\b\u0010\t\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u000b¢\u0006\u0002\u0010\fB%\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\b\u0012\u0006\u0010\t\u001a\u00020\u0005¢\u0006\u0002\u0010\rJ\t\u0010\u0014\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0015\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0016\u001a\u00020\bHÆ\u0003J\t\u0010\u0017\u001a\u00020\u0005HÆ\u0003J1\u0010\u0018\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\b\b\u0002\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\t\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u0019\u001a\u00020\u001a2\b\u0010\u001b\u001a\u0004\u0018\u00010\u001cHÖ\u0003J\t\u0010\u001d\u001a\u00020\u0003HÖ\u0001J\u0006\u0010\u001e\u001a\u00020\u001aJ\t\u0010\u001f\u001a\u00020\u0005HÖ\u0001J&\u0010 \u001a\u00020!2\u0006\u0010\"\u001a\u00020\u00002\u0006\u0010#\u001a\u00020$2\u0006\u0010%\u001a\u00020&HÁ\u0001¢\u0006\u0002\b'R\u0011\u0010\t\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u000fR\u0011\u0010\u0007\u001a\u00020\b¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u000f¨\u0006*"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageContent$FileUpload;", "Lzendesk/conversationkit/android/model/MessageContent;", "seen1", "", "uri", "", "name", "size", "", "mimeType", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;JLjava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;JLjava/lang/String;)V", "getMimeType", "()Ljava/lang/String;", "getName", "getSize", "()J", "getUri", "component1", "component2", "component3", "component4", "copy", "equals", "", "other", "", "hashCode", "isImageMimeType", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("file_upload")
    public static final class FileUpload extends MessageContent {

        public static final Companion INSTANCE = new Companion(null);
        private final String mimeType;
        private final String name;
        private final long size;
        private final String uri;

        public static FileUpload copy$default(FileUpload fileUpload, String str, String str2, long j, String str3, int i, Object obj) {
            if ((i & 1) != 0) {
                str = fileUpload.uri;
            }
            if ((i & 2) != 0) {
                str2 = fileUpload.name;
            }
            String str4 = str2;
            if ((i & 4) != 0) {
                j = fileUpload.size;
            }
            long j2 = j;
            if ((i & 8) != 0) {
                str3 = fileUpload.mimeType;
            }
            return fileUpload.copy(str, str4, j2, str3);
        }

        public final String getUri() {
            return this.uri;
        }

        public final String getName() {
            return this.name;
        }

        public final long getSize() {
            return this.size;
        }

        public final String getMimeType() {
            return this.mimeType;
        }

        public final FileUpload copy(String uri, String name, long size, String mimeType) {
            Intrinsics.checkNotNullParameter(uri, "uri");
            Intrinsics.checkNotNullParameter(name, "name");
            Intrinsics.checkNotNullParameter(mimeType, "mimeType");
            return new FileUpload(uri, name, size, mimeType);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof FileUpload)) {
                return false;
            }
            FileUpload fileUpload = (FileUpload) other;
            return Intrinsics.areEqual(this.uri, fileUpload.uri) && Intrinsics.areEqual(this.name, fileUpload.name) && this.size == fileUpload.size && Intrinsics.areEqual(this.mimeType, fileUpload.mimeType);
        }

        public int hashCode() {
            return (((((this.uri.hashCode() * 31) + this.name.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m27m(this.size)) * 31) + this.mimeType.hashCode();
        }

        public String toString() {
            return "FileUpload(uri=" + this.uri + ", name=" + this.name + ", size=" + this.size + ", mimeType=" + this.mimeType + ')';
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageContent$FileUpload$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/MessageContent$FileUpload;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<FileUpload> serializer() {
                return MessageContent$FileUpload$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public FileUpload(int i, String str, String str2, long j, String str3, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, serializationConstructorMarker);
            if (15 != (i & 15)) {
                PluginExceptionsKt.throwMissingFieldException(i, 15, MessageContent$FileUpload$$serializer.INSTANCE.getDescriptor());
            }
            this.uri = str;
            this.name = str2;
            this.size = j;
            this.mimeType = str3;
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(FileUpload self, CompositeEncoder output, SerialDescriptor serialDesc) {
            MessageContent.write$Self(self, output, serialDesc);
            output.encodeStringElement(serialDesc, 0, self.uri);
            output.encodeStringElement(serialDesc, 1, self.name);
            output.encodeLongElement(serialDesc, 2, self.size);
            output.encodeStringElement(serialDesc, 3, self.mimeType);
        }

        public final String getUri() {
            return this.uri;
        }

        public final String getName() {
            return this.name;
        }

        public final long getSize() {
            return this.size;
        }

        public final String getMimeType() {
            return this.mimeType;
        }

        public FileUpload(String uri, String name, long j, String mimeType) {
            super(MessageType.FILE_UPLOAD, (DefaultConstructorMarker) null);
            Intrinsics.checkNotNullParameter(uri, "uri");
            Intrinsics.checkNotNullParameter(name, "name");
            Intrinsics.checkNotNullParameter(mimeType, "mimeType");
            this.uri = uri;
            this.name = name;
            this.size = j;
            this.mimeType = mimeType;
        }

        public final boolean isImageMimeType() {
            return FileExtKt.isImageMimeType(this.mimeType);
        }
    }

    @Metadata(m17d1 = {"\u0000L\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0010\t\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0012\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 .2\u00020\u0001:\u0002-.BS\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0005\u0012\u0006\u0010\t\u001a\u00020\n\u0012\b\u0010\u000b\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\f\u001a\u0004\u0018\u00010\r¢\u0006\u0002\u0010\u000eB7\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\u0005\u0012\u0006\u0010\b\u001a\u00020\u0005\u0012\u0006\u0010\t\u001a\u00020\n\u0012\b\u0010\u000b\u001a\u0004\u0018\u00010\u0005¢\u0006\u0002\u0010\u000fJ\t\u0010\u0018\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0019\u001a\u00020\u0005HÆ\u0003J\t\u0010\u001a\u001a\u00020\u0005HÆ\u0003J\t\u0010\u001b\u001a\u00020\u0005HÆ\u0003J\t\u0010\u001c\u001a\u00020\nHÆ\u0003J\u000b\u0010\u001d\u001a\u0004\u0018\u00010\u0005HÆ\u0003JG\u0010\u001e\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\b\b\u0002\u0010\u0007\u001a\u00020\u00052\b\b\u0002\u0010\b\u001a\u00020\u00052\b\b\u0002\u0010\t\u001a\u00020\n2\n\b\u0002\u0010\u000b\u001a\u0004\u0018\u00010\u0005HÆ\u0001J\u0013\u0010\u001f\u001a\u00020 2\b\u0010!\u001a\u0004\u0018\u00010\"HÖ\u0003J\t\u0010#\u001a\u00020\u0003HÖ\u0001J\t\u0010$\u001a\u00020\u0005HÖ\u0001J&\u0010%\u001a\u00020&2\u0006\u0010'\u001a\u00020\u00002\u0006\u0010(\u001a\u00020)2\u0006\u0010*\u001a\u00020+HÁ\u0001¢\u0006\u0002\b,R\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011R\u0013\u0010\u000b\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0011R\u0011\u0010\t\u001a\u00020\n¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R\u0011\u0010\b\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0011R\u0011\u0010\u0007\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0011R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0011¨\u0006/"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageContent$File;", "Lzendesk/conversationkit/android/model/MessageContent;", "seen1", "", "text", "", "altText", "mediaUrl", "mediaType", "mediaSize", "", "attachmentId", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;JLjava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;JLjava/lang/String;)V", "getAltText", "()Ljava/lang/String;", "getAttachmentId", "getMediaSize", "()J", "getMediaType", "getMediaUrl", "getText", "component1", "component2", "component3", "component4", "component5", "component6", "copy", "equals", "", "other", "", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("file")
    public static final class File extends MessageContent {

        public static final Companion INSTANCE = new Companion(null);
        private final String altText;
        private final String attachmentId;
        private final long mediaSize;
        private final String mediaType;
        private final String mediaUrl;
        private final String text;

        public static File copy$default(File file, String str, String str2, String str3, String str4, long j, String str5, int i, Object obj) {
            if ((i & 1) != 0) {
                str = file.text;
            }
            if ((i & 2) != 0) {
                str2 = file.altText;
            }
            String str6 = str2;
            if ((i & 4) != 0) {
                str3 = file.mediaUrl;
            }
            String str7 = str3;
            if ((i & 8) != 0) {
                str4 = file.mediaType;
            }
            String str8 = str4;
            if ((i & 16) != 0) {
                j = file.mediaSize;
            }
            long j2 = j;
            if ((i & 32) != 0) {
                str5 = file.attachmentId;
            }
            return file.copy(str, str6, str7, str8, j2, str5);
        }

        public final String getText() {
            return this.text;
        }

        public final String getAltText() {
            return this.altText;
        }

        public final String getMediaUrl() {
            return this.mediaUrl;
        }

        public final String getMediaType() {
            return this.mediaType;
        }

        public final long getMediaSize() {
            return this.mediaSize;
        }

        public final String getAttachmentId() {
            return this.attachmentId;
        }

        public final File copy(String text, String altText, String mediaUrl, String mediaType, long mediaSize, String attachmentId) {
            Intrinsics.checkNotNullParameter(text, "text");
            Intrinsics.checkNotNullParameter(altText, "altText");
            Intrinsics.checkNotNullParameter(mediaUrl, "mediaUrl");
            Intrinsics.checkNotNullParameter(mediaType, "mediaType");
            return new File(text, altText, mediaUrl, mediaType, mediaSize, attachmentId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof File)) {
                return false;
            }
            File file = (File) other;
            return Intrinsics.areEqual(this.text, file.text) && Intrinsics.areEqual(this.altText, file.altText) && Intrinsics.areEqual(this.mediaUrl, file.mediaUrl) && Intrinsics.areEqual(this.mediaType, file.mediaType) && this.mediaSize == file.mediaSize && Intrinsics.areEqual(this.attachmentId, file.attachmentId);
        }

        public int hashCode() {
            int iHashCode = ((((((((this.text.hashCode() * 31) + this.altText.hashCode()) * 31) + this.mediaUrl.hashCode()) * 31) + this.mediaType.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m27m(this.mediaSize)) * 31;
            String str = this.attachmentId;
            return iHashCode + (str == null ? 0 : str.hashCode());
        }

        public String toString() {
            return "File(text=" + this.text + ", altText=" + this.altText + ", mediaUrl=" + this.mediaUrl + ", mediaType=" + this.mediaType + ", mediaSize=" + this.mediaSize + ", attachmentId=" + this.attachmentId + ')';
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageContent$File$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/MessageContent$File;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<File> serializer() {
                return MessageContent$File$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public File(int i, String str, String str2, String str3, String str4, long j, String str5, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, serializationConstructorMarker);
            if (63 != (i & 63)) {
                PluginExceptionsKt.throwMissingFieldException(i, 63, MessageContent$File$$serializer.INSTANCE.getDescriptor());
            }
            this.text = str;
            this.altText = str2;
            this.mediaUrl = str3;
            this.mediaType = str4;
            this.mediaSize = j;
            this.attachmentId = str5;
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(File self, CompositeEncoder output, SerialDescriptor serialDesc) {
            MessageContent.write$Self(self, output, serialDesc);
            output.encodeStringElement(serialDesc, 0, self.text);
            output.encodeStringElement(serialDesc, 1, self.altText);
            output.encodeStringElement(serialDesc, 2, self.mediaUrl);
            output.encodeStringElement(serialDesc, 3, self.mediaType);
            output.encodeLongElement(serialDesc, 4, self.mediaSize);
            output.encodeNullableSerializableElement(serialDesc, 5, StringSerializer.INSTANCE, self.attachmentId);
        }

        public final String getText() {
            return this.text;
        }

        public final String getAltText() {
            return this.altText;
        }

        public final String getMediaUrl() {
            return this.mediaUrl;
        }

        public final String getMediaType() {
            return this.mediaType;
        }

        public final long getMediaSize() {
            return this.mediaSize;
        }

        public final String getAttachmentId() {
            return this.attachmentId;
        }

        public File(String text, String altText, String mediaUrl, String mediaType, long j, String str) {
            super(MessageType.FILE, (DefaultConstructorMarker) null);
            Intrinsics.checkNotNullParameter(text, "text");
            Intrinsics.checkNotNullParameter(altText, "altText");
            Intrinsics.checkNotNullParameter(mediaUrl, "mediaUrl");
            Intrinsics.checkNotNullParameter(mediaType, "mediaType");
            this.text = text;
            this.altText = altText;
            this.mediaUrl = mediaUrl;
            this.mediaType = mediaType;
            this.mediaSize = j;
            this.attachmentId = str;
        }
    }

    @Metadata(m17d1 = {"\u0000L\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u000e\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 '2\u00020\u0001:\u0002&'B;\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\u000e\u0010\u0006\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007\u0012\u0006\u0010\t\u001a\u00020\n\u0012\b\u0010\u000b\u001a\u0004\u0018\u00010\f¢\u0006\u0002\u0010\rB#\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007\u0012\u0006\u0010\t\u001a\u00020\n¢\u0006\u0002\u0010\u000eJ\t\u0010\u0015\u001a\u00020\u0005HÆ\u0003J\u000f\u0010\u0016\u001a\b\u0012\u0004\u0012\u00020\b0\u0007HÆ\u0003J\t\u0010\u0017\u001a\u00020\nHÆ\u0003J-\u0010\u0018\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\u000e\b\u0002\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u00072\b\b\u0002\u0010\t\u001a\u00020\nHÆ\u0001J\u0013\u0010\u0019\u001a\u00020\n2\b\u0010\u001a\u001a\u0004\u0018\u00010\u001bHÖ\u0003J\t\u0010\u001c\u001a\u00020\u0003HÖ\u0001J\t\u0010\u001d\u001a\u00020\u0005HÖ\u0001J&\u0010\u001e\u001a\u00020\u001f2\u0006\u0010 \u001a\u00020\u00002\u0006\u0010!\u001a\u00020\"2\u0006\u0010#\u001a\u00020$HÁ\u0001¢\u0006\u0002\b%R\u0011\u0010\t\u001a\u00020\n¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u0017\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014¨\u0006("}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageContent$Form;", "Lzendesk/conversationkit/android/model/MessageContent;", "seen1", "", "formId", "", "fields", "", "Lzendesk/conversationkit/android/model/Field;", "blockChatInput", "", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/util/List;ZLkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/util/List;Z)V", "getBlockChatInput", "()Z", "getFields", "()Ljava/util/List;", "getFormId", "()Ljava/lang/String;", "component1", "component2", "component3", "copy", "equals", "other", "", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("form")
    public static final class Form extends MessageContent {
        private final boolean blockChatInput;
        private final List<Field> fields;
        private final String formId;

        public static final Companion INSTANCE = new Companion(null);
        private static final KSerializer<Object>[] $childSerializers = {null, new ArrayListSerializer(Field.INSTANCE.serializer()), null};

        public static Form copy$default(Form form, String str, List list, boolean z, int i, Object obj) {
            if ((i & 1) != 0) {
                str = form.formId;
            }
            if ((i & 2) != 0) {
                list = form.fields;
            }
            if ((i & 4) != 0) {
                z = form.blockChatInput;
            }
            return form.copy(str, list, z);
        }

        public final String getFormId() {
            return this.formId;
        }

        public final List<Field> component2() {
            return this.fields;
        }

        public final boolean getBlockChatInput() {
            return this.blockChatInput;
        }

        public final Form copy(String formId, List<? extends Field> fields, boolean blockChatInput) {
            Intrinsics.checkNotNullParameter(formId, "formId");
            Intrinsics.checkNotNullParameter(fields, "fields");
            return new Form(formId, fields, blockChatInput);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Form)) {
                return false;
            }
            Form form = (Form) other;
            return Intrinsics.areEqual(this.formId, form.formId) && Intrinsics.areEqual(this.fields, form.fields) && this.blockChatInput == form.blockChatInput;
        }

        public int hashCode() {
            return (((this.formId.hashCode() * 31) + this.fields.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.blockChatInput);
        }

        public String toString() {
            return "Form(formId=" + this.formId + ", fields=" + this.fields + ", blockChatInput=" + this.blockChatInput + ')';
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageContent$Form$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/MessageContent$Form;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<Form> serializer() {
                return MessageContent$Form$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public Form(int i, String str, List list, boolean z, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, serializationConstructorMarker);
            if (7 != (i & 7)) {
                PluginExceptionsKt.throwMissingFieldException(i, 7, MessageContent$Form$$serializer.INSTANCE.getDescriptor());
            }
            this.formId = str;
            this.fields = list;
            this.blockChatInput = z;
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(Form self, CompositeEncoder output, SerialDescriptor serialDesc) {
            MessageContent.write$Self(self, output, serialDesc);
            KSerializer<Object>[] kSerializerArr = $childSerializers;
            output.encodeStringElement(serialDesc, 0, self.formId);
            output.encodeSerializableElement(serialDesc, 1, kSerializerArr[1], self.fields);
            output.encodeBooleanElement(serialDesc, 2, self.blockChatInput);
        }

        public final String getFormId() {
            return this.formId;
        }

        public final List<Field> getFields() {
            return this.fields;
        }

        public final boolean getBlockChatInput() {
            return this.blockChatInput;
        }

        public Form(String formId, List<? extends Field> fields, boolean z) {
            super(MessageType.FORM, (DefaultConstructorMarker) null);
            Intrinsics.checkNotNullParameter(formId, "formId");
            Intrinsics.checkNotNullParameter(fields, "fields");
            this.formId = formId;
            this.fields = fields;
            this.blockChatInput = z;
        }
    }

    @Metadata(m17d1 = {"\u0000L\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 #2\u00020\u0001:\u0002\"#B3\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\u000e\u0010\u0006\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007\u0012\b\u0010\t\u001a\u0004\u0018\u00010\n¢\u0006\u0002\u0010\u000bB\u001b\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007¢\u0006\u0002\u0010\fJ\t\u0010\u0011\u001a\u00020\u0005HÆ\u0003J\u000f\u0010\u0012\u001a\b\u0012\u0004\u0012\u00020\b0\u0007HÆ\u0003J#\u0010\u0013\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\u000e\b\u0002\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007HÆ\u0001J\u0013\u0010\u0014\u001a\u00020\u00152\b\u0010\u0016\u001a\u0004\u0018\u00010\u0017HÖ\u0003J\t\u0010\u0018\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0019\u001a\u00020\u0005HÖ\u0001J&\u0010\u001a\u001a\u00020\u001b2\u0006\u0010\u001c\u001a\u00020\u00002\u0006\u0010\u001d\u001a\u00020\u001e2\u0006\u0010\u001f\u001a\u00020 HÁ\u0001¢\u0006\u0002\b!R\u0017\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010¨\u0006$"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageContent$FormResponse;", "Lzendesk/conversationkit/android/model/MessageContent;", "seen1", "", "quotedMessageId", "", "fields", "", "Lzendesk/conversationkit/android/model/Field;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/util/List;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/util/List;)V", "getFields", "()Ljava/util/List;", "getQuotedMessageId", "()Ljava/lang/String;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("formResponse")
    public static final class FormResponse extends MessageContent {
        private final List<Field> fields;
        private final String quotedMessageId;

        public static final Companion INSTANCE = new Companion(null);
        private static final KSerializer<Object>[] $childSerializers = {null, new ArrayListSerializer(Field.INSTANCE.serializer())};

        public static FormResponse copy$default(FormResponse formResponse, String str, List list, int i, Object obj) {
            if ((i & 1) != 0) {
                str = formResponse.quotedMessageId;
            }
            if ((i & 2) != 0) {
                list = formResponse.fields;
            }
            return formResponse.copy(str, list);
        }

        public final String getQuotedMessageId() {
            return this.quotedMessageId;
        }

        public final List<Field> component2() {
            return this.fields;
        }

        public final FormResponse copy(String quotedMessageId, List<? extends Field> fields) {
            Intrinsics.checkNotNullParameter(quotedMessageId, "quotedMessageId");
            Intrinsics.checkNotNullParameter(fields, "fields");
            return new FormResponse(quotedMessageId, fields);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof FormResponse)) {
                return false;
            }
            FormResponse formResponse = (FormResponse) other;
            return Intrinsics.areEqual(this.quotedMessageId, formResponse.quotedMessageId) && Intrinsics.areEqual(this.fields, formResponse.fields);
        }

        public int hashCode() {
            return (this.quotedMessageId.hashCode() * 31) + this.fields.hashCode();
        }

        public String toString() {
            return "FormResponse(quotedMessageId=" + this.quotedMessageId + ", fields=" + this.fields + ')';
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageContent$FormResponse$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/MessageContent$FormResponse;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<FormResponse> serializer() {
                return MessageContent$FormResponse$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public FormResponse(int i, String str, List list, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, serializationConstructorMarker);
            if (3 != (i & 3)) {
                PluginExceptionsKt.throwMissingFieldException(i, 3, MessageContent$FormResponse$$serializer.INSTANCE.getDescriptor());
            }
            this.quotedMessageId = str;
            this.fields = list;
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(FormResponse self, CompositeEncoder output, SerialDescriptor serialDesc) {
            MessageContent.write$Self(self, output, serialDesc);
            KSerializer<Object>[] kSerializerArr = $childSerializers;
            output.encodeStringElement(serialDesc, 0, self.quotedMessageId);
            output.encodeSerializableElement(serialDesc, 1, kSerializerArr[1], self.fields);
        }

        public final String getQuotedMessageId() {
            return this.quotedMessageId;
        }

        public final List<Field> getFields() {
            return this.fields;
        }

        public FormResponse(String quotedMessageId, List<? extends Field> fields) {
            super(MessageType.FORM_RESPONSE, (DefaultConstructorMarker) null);
            Intrinsics.checkNotNullParameter(quotedMessageId, "quotedMessageId");
            Intrinsics.checkNotNullParameter(fields, "fields");
            this.quotedMessageId = quotedMessageId;
            this.fields = fields;
        }
    }

    @Metadata(m17d1 = {"\u0000L\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 \u001f2\u00020\u0001:\u0002\u001e\u001fB)\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u000e\u0010\u0004\u001a\n\u0012\u0004\u0012\u00020\u0006\u0018\u00010\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\b¢\u0006\u0002\u0010\tB\u0013\u0012\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00020\u00060\u0005¢\u0006\u0002\u0010\nJ\u000f\u0010\r\u001a\b\u0012\u0004\u0012\u00020\u00060\u0005HÆ\u0003J\u0019\u0010\u000e\u001a\u00020\u00002\u000e\b\u0002\u0010\u0004\u001a\b\u0012\u0004\u0012\u00020\u00060\u0005HÆ\u0001J\u0013\u0010\u000f\u001a\u00020\u00102\b\u0010\u0011\u001a\u0004\u0018\u00010\u0012HÖ\u0003J\t\u0010\u0013\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0014\u001a\u00020\u0015HÖ\u0001J&\u0010\u0016\u001a\u00020\u00172\u0006\u0010\u0018\u001a\u00020\u00002\u0006\u0010\u0019\u001a\u00020\u001a2\u0006\u0010\u001b\u001a\u00020\u001cHÁ\u0001¢\u0006\u0002\b\u001dR\u0017\u0010\u0004\u001a\b\u0012\u0004\u0012\u00020\u00060\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\f¨\u0006 "}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageContent$Carousel;", "Lzendesk/conversationkit/android/model/MessageContent;", "seen1", "", "items", "", "Lzendesk/conversationkit/android/model/MessageItem;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/util/List;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/util/List;)V", "getItems", "()Ljava/util/List;", "component1", "copy", "equals", "", "other", "", "hashCode", "toString", "", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("carousel")
    public static final class Carousel extends MessageContent {
        private final List<MessageItem> items;

        public static final Companion INSTANCE = new Companion(null);
        private static final KSerializer<Object>[] $childSerializers = {new ArrayListSerializer(MessageItem$$serializer.INSTANCE)};

        public static Carousel copy$default(Carousel carousel, List list, int i, Object obj) {
            if ((i & 1) != 0) {
                list = carousel.items;
            }
            return carousel.copy(list);
        }

        public final List<MessageItem> component1() {
            return this.items;
        }

        public final Carousel copy(List<MessageItem> items) {
            Intrinsics.checkNotNullParameter(items, "items");
            return new Carousel(items);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof Carousel) && Intrinsics.areEqual(this.items, ((Carousel) other).items);
        }

        public int hashCode() {
            return this.items.hashCode();
        }

        public String toString() {
            return "Carousel(items=" + this.items + ')';
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageContent$Carousel$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/MessageContent$Carousel;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<Carousel> serializer() {
                return MessageContent$Carousel$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public Carousel(int i, List list, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, serializationConstructorMarker);
            if (1 != (i & 1)) {
                PluginExceptionsKt.throwMissingFieldException(i, 1, MessageContent$Carousel$$serializer.INSTANCE.getDescriptor());
            }
            this.items = list;
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(Carousel self, CompositeEncoder output, SerialDescriptor serialDesc) {
            MessageContent.write$Self(self, output, serialDesc);
            output.encodeSerializableElement(serialDesc, 0, $childSerializers[0], self.items);
        }

        public final List<MessageItem> getItems() {
            return this.items;
        }

        public Carousel(List<MessageItem> items) {
            super(MessageType.CAROUSEL, (DefaultConstructorMarker) null);
            Intrinsics.checkNotNullParameter(items, "items");
            this.items = items;
        }
    }

    @Metadata(m17d1 = {"\u0000V\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0010\t\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0015\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 42\u00020\u0001:\u000234Bc\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0005\u0012\u0006\u0010\t\u001a\u00020\n\u0012\u000e\u0010\u000b\u001a\n\u0012\u0004\u0012\u00020\r\u0018\u00010\f\u0012\b\u0010\u000e\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u000f\u001a\u0004\u0018\u00010\u0010¢\u0006\u0002\u0010\u0011BK\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0005\u0012\u0006\u0010\b\u001a\u00020\u0005\u0012\u0006\u0010\t\u001a\u00020\n\u0012\u0010\b\u0002\u0010\u000b\u001a\n\u0012\u0004\u0012\u00020\r\u0018\u00010\f\u0012\b\u0010\u000e\u001a\u0004\u0018\u00010\u0005¢\u0006\u0002\u0010\u0012J\t\u0010\u001d\u001a\u00020\u0005HÆ\u0003J\t\u0010\u001e\u001a\u00020\u0005HÆ\u0003J\u000b\u0010\u001f\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\t\u0010 \u001a\u00020\u0005HÆ\u0003J\t\u0010!\u001a\u00020\nHÆ\u0003J\u0011\u0010\"\u001a\n\u0012\u0004\u0012\u00020\r\u0018\u00010\fHÆ\u0003J\u000b\u0010#\u001a\u0004\u0018\u00010\u0005HÆ\u0003J[\u0010$\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\u00052\b\b\u0002\u0010\b\u001a\u00020\u00052\b\b\u0002\u0010\t\u001a\u00020\n2\u0010\b\u0002\u0010\u000b\u001a\n\u0012\u0004\u0012\u00020\r\u0018\u00010\f2\n\b\u0002\u0010\u000e\u001a\u0004\u0018\u00010\u0005HÆ\u0001J\u0013\u0010%\u001a\u00020&2\b\u0010'\u001a\u0004\u0018\u00010(HÖ\u0003J\t\u0010)\u001a\u00020\u0003HÖ\u0001J\t\u0010*\u001a\u00020\u0005HÖ\u0001J&\u0010+\u001a\u00020,2\u0006\u0010-\u001a\u00020\u00002\u0006\u0010.\u001a\u00020/2\u0006\u00100\u001a\u000201HÁ\u0001¢\u0006\u0002\b2R\u0019\u0010\u000b\u001a\n\u0012\u0004\u0012\u00020\r\u0018\u00010\f¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R\u0013\u0010\u000e\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016R\u0013\u0010\u0007\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0016R\u0011\u0010\t\u001a\u00020\n¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0019R\u0011\u0010\b\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u0016R\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u0016R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u0016¨\u00065"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageContent$Image;", "Lzendesk/conversationkit/android/model/MessageContent;", "seen1", "", "text", "", "mediaUrl", "localUri", "mediaType", "mediaSize", "", "actions", "", "Lzendesk/conversationkit/android/model/MessageAction;", "attachmentId", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;JLjava/util/List;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;JLjava/util/List;Ljava/lang/String;)V", "getActions", "()Ljava/util/List;", "getAttachmentId", "()Ljava/lang/String;", "getLocalUri", "getMediaSize", "()J", "getMediaType", "getMediaUrl", "getText", "component1", "component2", "component3", "component4", "component5", "component6", "component7", "copy", "equals", "", "other", "", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("image")
    public static final class Image extends MessageContent {
        private final List<MessageAction> actions;
        private final String attachmentId;
        private final String localUri;
        private final long mediaSize;
        private final String mediaType;
        private final String mediaUrl;
        private final String text;

        public static final Companion INSTANCE = new Companion(null);
        private static final KSerializer<Object>[] $childSerializers = {null, null, null, null, null, new ArrayListSerializer(MessageAction.INSTANCE.serializer()), null};

        public final String getText() {
            return this.text;
        }

        public final String getMediaUrl() {
            return this.mediaUrl;
        }

        public final String getLocalUri() {
            return this.localUri;
        }

        public final String getMediaType() {
            return this.mediaType;
        }

        public final long getMediaSize() {
            return this.mediaSize;
        }

        public final List<MessageAction> component6() {
            return this.actions;
        }

        public final String getAttachmentId() {
            return this.attachmentId;
        }

        public final Image copy(String text, String mediaUrl, String localUri, String mediaType, long mediaSize, List<? extends MessageAction> actions, String attachmentId) {
            Intrinsics.checkNotNullParameter(text, "text");
            Intrinsics.checkNotNullParameter(mediaUrl, "mediaUrl");
            Intrinsics.checkNotNullParameter(mediaType, "mediaType");
            return new Image(text, mediaUrl, localUri, mediaType, mediaSize, actions, attachmentId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Image)) {
                return false;
            }
            Image image = (Image) other;
            return Intrinsics.areEqual(this.text, image.text) && Intrinsics.areEqual(this.mediaUrl, image.mediaUrl) && Intrinsics.areEqual(this.localUri, image.localUri) && Intrinsics.areEqual(this.mediaType, image.mediaType) && this.mediaSize == image.mediaSize && Intrinsics.areEqual(this.actions, image.actions) && Intrinsics.areEqual(this.attachmentId, image.attachmentId);
        }

        public int hashCode() {
            int iHashCode = ((this.text.hashCode() * 31) + this.mediaUrl.hashCode()) * 31;
            String str = this.localUri;
            int iHashCode2 = (((((iHashCode + (str == null ? 0 : str.hashCode())) * 31) + this.mediaType.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m27m(this.mediaSize)) * 31;
            List<MessageAction> list = this.actions;
            int iHashCode3 = (iHashCode2 + (list == null ? 0 : list.hashCode())) * 31;
            String str2 = this.attachmentId;
            return iHashCode3 + (str2 != null ? str2.hashCode() : 0);
        }

        public String toString() {
            return "Image(text=" + this.text + ", mediaUrl=" + this.mediaUrl + ", localUri=" + this.localUri + ", mediaType=" + this.mediaType + ", mediaSize=" + this.mediaSize + ", actions=" + this.actions + ", attachmentId=" + this.attachmentId + ')';
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageContent$Image$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/MessageContent$Image;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<Image> serializer() {
                return MessageContent$Image$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public Image(int i, String str, String str2, String str3, String str4, long j, List list, String str5, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, serializationConstructorMarker);
            if (95 != (i & 95)) {
                PluginExceptionsKt.throwMissingFieldException(i, 95, MessageContent$Image$$serializer.INSTANCE.getDescriptor());
            }
            this.text = str;
            this.mediaUrl = str2;
            this.localUri = str3;
            this.mediaType = str4;
            this.mediaSize = j;
            if ((i & 32) == 0) {
                this.actions = null;
            } else {
                this.actions = list;
            }
            this.attachmentId = str5;
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(Image self, CompositeEncoder output, SerialDescriptor serialDesc) {
            MessageContent.write$Self(self, output, serialDesc);
            KSerializer<Object>[] kSerializerArr = $childSerializers;
            output.encodeStringElement(serialDesc, 0, self.text);
            output.encodeStringElement(serialDesc, 1, self.mediaUrl);
            output.encodeNullableSerializableElement(serialDesc, 2, StringSerializer.INSTANCE, self.localUri);
            output.encodeStringElement(serialDesc, 3, self.mediaType);
            output.encodeLongElement(serialDesc, 4, self.mediaSize);
            if (output.shouldEncodeElementDefault(serialDesc, 5) || self.actions != null) {
                output.encodeNullableSerializableElement(serialDesc, 5, kSerializerArr[5], self.actions);
            }
            output.encodeNullableSerializableElement(serialDesc, 6, StringSerializer.INSTANCE, self.attachmentId);
        }

        public Image(String str, String str2, String str3, String str4, long j, List list, String str5, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this(str, str2, str3, str4, j, (i & 32) != 0 ? null : list, str5);
        }

        public final String getText() {
            return this.text;
        }

        public final String getMediaUrl() {
            return this.mediaUrl;
        }

        public final String getLocalUri() {
            return this.localUri;
        }

        public final String getMediaType() {
            return this.mediaType;
        }

        public final long getMediaSize() {
            return this.mediaSize;
        }

        public final List<MessageAction> getActions() {
            return this.actions;
        }

        public final String getAttachmentId() {
            return this.attachmentId;
        }

        public Image(String text, String mediaUrl, String str, String mediaType, long j, List<? extends MessageAction> list, String str2) {
            super(MessageType.IMAGE, (DefaultConstructorMarker) null);
            Intrinsics.checkNotNullParameter(text, "text");
            Intrinsics.checkNotNullParameter(mediaUrl, "mediaUrl");
            Intrinsics.checkNotNullParameter(mediaType, "mediaType");
            this.text = text;
            this.mediaUrl = mediaUrl;
            this.localUri = str;
            this.mediaType = mediaType;
            this.mediaSize = j;
            this.actions = list;
            this.attachmentId = str2;
        }
    }
}
