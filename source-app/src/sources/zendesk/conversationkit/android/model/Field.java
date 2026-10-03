package zendesk.conversationkit.android.model;

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

@Metadata(m17d1 = {"\u0000J\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b7\u0018\u0000 \u001d2\u00020\u0001:\u0004\u001d\u001e\u001f B#\b\u0017\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007¢\u0006\u0002\u0010\bB\u000f\b\u0004\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\tJ!\u0010\u0016\u001a\u00020\u00172\u0006\u0010\u0018\u001a\u00020\u00002\u0006\u0010\u0019\u001a\u00020\u001a2\u0006\u0010\u001b\u001a\u00020\u001cHÇ\u0001R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0012\u0010\f\u001a\u00020\rX¦\u0004¢\u0006\u0006\u001a\u0004\b\u000e\u0010\u000fR\u0012\u0010\u0010\u001a\u00020\rX¦\u0004¢\u0006\u0006\u001a\u0004\b\u0011\u0010\u000fR\u0012\u0010\u0012\u001a\u00020\rX¦\u0004¢\u0006\u0006\u001a\u0004\b\u0013\u0010\u000fR\u0012\u0010\u0014\u001a\u00020\rX¦\u0004¢\u0006\u0006\u001a\u0004\b\u0015\u0010\u000f\u0082\u0001\u0003!\"#¨\u0006$"}, m18d2 = {"Lzendesk/conversationkit/android/model/Field;", "", "seen1", "", "fieldType", "Lzendesk/conversationkit/android/model/FieldType;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/conversationkit/android/model/FieldType;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Lzendesk/conversationkit/android/model/FieldType;)V", "getFieldType", "()Lzendesk/conversationkit/android/model/FieldType;", "id", "", "getId", "()Ljava/lang/String;", "label", "getLabel", "name", "getName", "placeholder", "getPlaceholder", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "Companion", "Email", "Select", "Text", "Lzendesk/conversationkit/android/model/Field$Email;", "Lzendesk/conversationkit/android/model/Field$Select;", "Lzendesk/conversationkit/android/model/Field$Text;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public abstract class Field {
    public static final String SYSTEM_FIELD_NAME = "dataCapture.systemField.requester.name";
    private final FieldType fieldType;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {FieldType.INSTANCE.serializer()};
    private static final Lazy<KSerializer<Object>> $cachedSerializer$delegate = LazyKt.lazy(LazyThreadSafetyMode.PUBLICATION, (Function0) new Function0<KSerializer<Object>>() {
        @Override
        public final KSerializer<Object> invoke() {
            return new SealedClassSerializer("zendesk.conversationkit.android.model.Field", Reflection.getOrCreateKotlinClass(Field.class), new KClass[]{Reflection.getOrCreateKotlinClass(Email.class), Reflection.getOrCreateKotlinClass(Select.class), Reflection.getOrCreateKotlinClass(Text.class)}, new KSerializer[]{Field$Email$$serializer.INSTANCE, Field$Select$$serializer.INSTANCE, Field$Text$$serializer.INSTANCE}, new Annotation[0]);
        }
    });

    public Field(FieldType fieldType, DefaultConstructorMarker defaultConstructorMarker) {
        this(fieldType);
    }

    public abstract String getId();

    public abstract String getLabel();

    public abstract String getName();

    public abstract String getPlaceholder();

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public Field(int i, FieldType fieldType, SerializationConstructorMarker serializationConstructorMarker) {
        this.fieldType = fieldType;
    }

    private Field(FieldType fieldType) {
        this.fieldType = fieldType;
    }

    @JvmStatic
    public static final void write$Self(Field self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeSerializableElement(serialDesc, 0, $childSerializers[0], self.fieldType);
    }

    public final FieldType getFieldType() {
        return this.fieldType;
    }

    @Metadata(m17d1 = {"\u0000J\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0014\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 22\u00020\u0001:\u000212Be\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\t\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u0007\u0012\u0006\u0010\u000b\u001a\u00020\u0003\u0012\u0006\u0010\f\u001a\u00020\u0003\u0012\b\u0010\r\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\u000e\u001a\u0004\u0018\u00010\u000f¢\u0006\u0002\u0010\u0010B=\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\u0007\u0012\u0006\u0010\t\u001a\u00020\u0007\u0012\u0006\u0010\n\u001a\u00020\u0007\u0012\u0006\u0010\u000b\u001a\u00020\u0003\u0012\u0006\u0010\f\u001a\u00020\u0003\u0012\u0006\u0010\r\u001a\u00020\u0007¢\u0006\u0002\u0010\u0011J\t\u0010\u001b\u001a\u00020\u0007HÆ\u0003J\t\u0010\u001c\u001a\u00020\u0007HÆ\u0003J\t\u0010\u001d\u001a\u00020\u0007HÆ\u0003J\t\u0010\u001e\u001a\u00020\u0007HÆ\u0003J\t\u0010\u001f\u001a\u00020\u0003HÆ\u0003J\t\u0010 \u001a\u00020\u0003HÆ\u0003J\t\u0010!\u001a\u00020\u0007HÆ\u0003JO\u0010\"\u001a\u00020\u00002\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\u00072\b\b\u0002\u0010\t\u001a\u00020\u00072\b\b\u0002\u0010\n\u001a\u00020\u00072\b\b\u0002\u0010\u000b\u001a\u00020\u00032\b\b\u0002\u0010\f\u001a\u00020\u00032\b\b\u0002\u0010\r\u001a\u00020\u0007HÆ\u0001J\u0013\u0010#\u001a\u00020$2\b\u0010%\u001a\u0004\u0018\u00010&HÖ\u0003J\t\u0010'\u001a\u00020\u0003HÖ\u0001J\t\u0010(\u001a\u00020\u0007HÖ\u0001J&\u0010)\u001a\u00020*2\u0006\u0010+\u001a\u00020\u00002\u0006\u0010,\u001a\u00020-2\u0006\u0010.\u001a\u00020/HÁ\u0001¢\u0006\u0002\b0R\u0014\u0010\u0006\u001a\u00020\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013R\u0014\u0010\t\u001a\u00020\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0013R\u0011\u0010\f\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016R\u0011\u0010\u000b\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0016R\u0014\u0010\b\u001a\u00020\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0013R\u0014\u0010\n\u001a\u00020\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u0013R\u0011\u0010\r\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u0013¨\u00063"}, m18d2 = {"Lzendesk/conversationkit/android/model/Field$Text;", "Lzendesk/conversationkit/android/model/Field;", "seen1", "", "fieldType", "Lzendesk/conversationkit/android/model/FieldType;", "id", "", "name", "label", "placeholder", "minSize", "maxSize", "text", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/conversationkit/android/model/FieldType;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;IILjava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;IILjava/lang/String;)V", "getId", "()Ljava/lang/String;", "getLabel", "getMaxSize", "()I", "getMinSize", "getName", "getPlaceholder", "getText", "component1", "component2", "component3", "component4", "component5", "component6", "component7", "copy", "equals", "", "other", "", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("text")
    public static final class Text extends Field {
        public static final int DEFAULT_MAX_SIZE = 128;
        public static final int DEFAULT_MIN_SIZE = 1;
        private final String id;
        private final String label;
        private final int maxSize;
        private final int minSize;
        private final String name;
        private final String placeholder;
        private final String text;

        public static final Companion INSTANCE = new Companion(null);
        private static final KSerializer<Object>[] $childSerializers = {FieldType.INSTANCE.serializer(), null, null, null, null, null, null, null};

        public static Text copy$default(Text text, String str, String str2, String str3, String str4, int i, int i2, String str5, int i3, Object obj) {
            if ((i3 & 1) != 0) {
                str = text.id;
            }
            if ((i3 & 2) != 0) {
                str2 = text.name;
            }
            String str6 = str2;
            if ((i3 & 4) != 0) {
                str3 = text.label;
            }
            String str7 = str3;
            if ((i3 & 8) != 0) {
                str4 = text.placeholder;
            }
            String str8 = str4;
            if ((i3 & 16) != 0) {
                i = text.minSize;
            }
            int i4 = i;
            if ((i3 & 32) != 0) {
                i2 = text.maxSize;
            }
            int i5 = i2;
            if ((i3 & 64) != 0) {
                str5 = text.text;
            }
            return text.copy(str, str6, str7, str8, i4, i5, str5);
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

        public final String getPlaceholder() {
            return this.placeholder;
        }

        public final int getMinSize() {
            return this.minSize;
        }

        public final int getMaxSize() {
            return this.maxSize;
        }

        public final String getText() {
            return this.text;
        }

        public final Text copy(String id, String name, String label, String placeholder, int minSize, int maxSize, String text) {
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(name, "name");
            Intrinsics.checkNotNullParameter(label, "label");
            Intrinsics.checkNotNullParameter(placeholder, "placeholder");
            Intrinsics.checkNotNullParameter(text, "text");
            return new Text(id, name, label, placeholder, minSize, maxSize, text);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Text)) {
                return false;
            }
            Text text = (Text) other;
            return Intrinsics.areEqual(this.id, text.id) && Intrinsics.areEqual(this.name, text.name) && Intrinsics.areEqual(this.label, text.label) && Intrinsics.areEqual(this.placeholder, text.placeholder) && this.minSize == text.minSize && this.maxSize == text.maxSize && Intrinsics.areEqual(this.text, text.text);
        }

        public int hashCode() {
            return (((((((((((this.id.hashCode() * 31) + this.name.hashCode()) * 31) + this.label.hashCode()) * 31) + this.placeholder.hashCode()) * 31) + this.minSize) * 31) + this.maxSize) * 31) + this.text.hashCode();
        }

        public String toString() {
            return "Text(id=" + this.id + ", name=" + this.name + ", label=" + this.label + ", placeholder=" + this.placeholder + ", minSize=" + this.minSize + ", maxSize=" + this.maxSize + ", text=" + this.text + ')';
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public Text(int i, FieldType fieldType, String str, String str2, String str3, String str4, int i2, int i3, String str5, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, fieldType, serializationConstructorMarker);
            if (255 != (i & 255)) {
                PluginExceptionsKt.throwMissingFieldException(i, 255, Field$Text$$serializer.INSTANCE.getDescriptor());
            }
            this.id = str;
            this.name = str2;
            this.label = str3;
            this.placeholder = str4;
            this.minSize = i2;
            this.maxSize = i3;
            this.text = str5;
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(Text self, CompositeEncoder output, SerialDescriptor serialDesc) {
            Field.write$Self(self, output, serialDesc);
            output.encodeStringElement(serialDesc, 1, self.getId());
            output.encodeStringElement(serialDesc, 2, self.getName());
            output.encodeStringElement(serialDesc, 3, self.getLabel());
            output.encodeStringElement(serialDesc, 4, self.getPlaceholder());
            output.encodeIntElement(serialDesc, 5, self.minSize);
            output.encodeIntElement(serialDesc, 6, self.maxSize);
            output.encodeStringElement(serialDesc, 7, self.text);
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

        @Override
        public String getPlaceholder() {
            return this.placeholder;
        }

        public final int getMinSize() {
            return this.minSize;
        }

        public final int getMaxSize() {
            return this.maxSize;
        }

        public final String getText() {
            return this.text;
        }

        public Text(String id, String name, String label, String placeholder, int i, int i2, String text) {
            super(FieldType.TEXT, null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(name, "name");
            Intrinsics.checkNotNullParameter(label, "label");
            Intrinsics.checkNotNullParameter(placeholder, "placeholder");
            Intrinsics.checkNotNullParameter(text, "text");
            this.id = id;
            this.name = name;
            this.label = label;
            this.placeholder = placeholder;
            this.minSize = i;
            this.maxSize = i2;
            this.text = text;
        }

        @Metadata(m17d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0080\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007HÆ\u0001R\u000e\u0010\u0003\u001a\u00020\u0004X\u0080T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0080T¢\u0006\u0002\n\u0000¨\u0006\t"}, m18d2 = {"Lzendesk/conversationkit/android/model/Field$Text$Companion;", "", "()V", "DEFAULT_MAX_SIZE", "", "DEFAULT_MIN_SIZE", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/Field$Text;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<Text> serializer() {
                return Field$Text$$serializer.INSTANCE;
            }
        }
    }

    @Metadata(m17d1 = {"\u0000J\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u000f\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 +2\u00020\u0001:\u0002*+BU\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\t\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\u000b\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\f\u001a\u0004\u0018\u00010\r¢\u0006\u0002\u0010\u000eB-\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\u0007\u0012\u0006\u0010\t\u001a\u00020\u0007\u0012\u0006\u0010\n\u001a\u00020\u0007\u0012\u0006\u0010\u000b\u001a\u00020\u0007¢\u0006\u0002\u0010\u000fJ\t\u0010\u0016\u001a\u00020\u0007HÆ\u0003J\t\u0010\u0017\u001a\u00020\u0007HÆ\u0003J\t\u0010\u0018\u001a\u00020\u0007HÆ\u0003J\t\u0010\u0019\u001a\u00020\u0007HÆ\u0003J\t\u0010\u001a\u001a\u00020\u0007HÆ\u0003J;\u0010\u001b\u001a\u00020\u00002\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\u00072\b\b\u0002\u0010\t\u001a\u00020\u00072\b\b\u0002\u0010\n\u001a\u00020\u00072\b\b\u0002\u0010\u000b\u001a\u00020\u0007HÆ\u0001J\u0013\u0010\u001c\u001a\u00020\u001d2\b\u0010\u001e\u001a\u0004\u0018\u00010\u001fHÖ\u0003J\t\u0010 \u001a\u00020\u0003HÖ\u0001J\t\u0010!\u001a\u00020\u0007HÖ\u0001J&\u0010\"\u001a\u00020#2\u0006\u0010$\u001a\u00020\u00002\u0006\u0010%\u001a\u00020&2\u0006\u0010'\u001a\u00020(HÁ\u0001¢\u0006\u0002\b)R\u0011\u0010\u000b\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011R\u0014\u0010\u0006\u001a\u00020\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0011R\u0014\u0010\t\u001a\u00020\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0011R\u0014\u0010\b\u001a\u00020\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0011R\u0014\u0010\n\u001a\u00020\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0011¨\u0006,"}, m18d2 = {"Lzendesk/conversationkit/android/model/Field$Email;", "Lzendesk/conversationkit/android/model/Field;", "seen1", "", "fieldType", "Lzendesk/conversationkit/android/model/FieldType;", "id", "", "name", "label", "placeholder", "email", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/conversationkit/android/model/FieldType;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", "getEmail", "()Ljava/lang/String;", "getId", "getLabel", "getName", "getPlaceholder", "component1", "component2", "component3", "component4", "component5", "copy", "equals", "", "other", "", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("email")
    public static final class Email extends Field {
        private final String email;
        private final String id;
        private final String label;
        private final String name;
        private final String placeholder;

        public static final Companion INSTANCE = new Companion(null);
        private static final KSerializer<Object>[] $childSerializers = {FieldType.INSTANCE.serializer(), null, null, null, null, null};

        public static Email copy$default(Email email, String str, String str2, String str3, String str4, String str5, int i, Object obj) {
            if ((i & 1) != 0) {
                str = email.id;
            }
            if ((i & 2) != 0) {
                str2 = email.name;
            }
            String str6 = str2;
            if ((i & 4) != 0) {
                str3 = email.label;
            }
            String str7 = str3;
            if ((i & 8) != 0) {
                str4 = email.placeholder;
            }
            String str8 = str4;
            if ((i & 16) != 0) {
                str5 = email.email;
            }
            return email.copy(str, str6, str7, str8, str5);
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

        public final String getPlaceholder() {
            return this.placeholder;
        }

        public final String getEmail() {
            return this.email;
        }

        public final Email copy(String id, String name, String label, String placeholder, String email) {
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(name, "name");
            Intrinsics.checkNotNullParameter(label, "label");
            Intrinsics.checkNotNullParameter(placeholder, "placeholder");
            Intrinsics.checkNotNullParameter(email, "email");
            return new Email(id, name, label, placeholder, email);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Email)) {
                return false;
            }
            Email email = (Email) other;
            return Intrinsics.areEqual(this.id, email.id) && Intrinsics.areEqual(this.name, email.name) && Intrinsics.areEqual(this.label, email.label) && Intrinsics.areEqual(this.placeholder, email.placeholder) && Intrinsics.areEqual(this.email, email.email);
        }

        public int hashCode() {
            return (((((((this.id.hashCode() * 31) + this.name.hashCode()) * 31) + this.label.hashCode()) * 31) + this.placeholder.hashCode()) * 31) + this.email.hashCode();
        }

        public String toString() {
            return "Email(id=" + this.id + ", name=" + this.name + ", label=" + this.label + ", placeholder=" + this.placeholder + ", email=" + this.email + ')';
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/Field$Email$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/Field$Email;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<Email> serializer() {
                return Field$Email$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public Email(int i, FieldType fieldType, String str, String str2, String str3, String str4, String str5, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, fieldType, serializationConstructorMarker);
            if (63 != (i & 63)) {
                PluginExceptionsKt.throwMissingFieldException(i, 63, Field$Email$$serializer.INSTANCE.getDescriptor());
            }
            this.id = str;
            this.name = str2;
            this.label = str3;
            this.placeholder = str4;
            this.email = str5;
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(Email self, CompositeEncoder output, SerialDescriptor serialDesc) {
            Field.write$Self(self, output, serialDesc);
            output.encodeStringElement(serialDesc, 1, self.getId());
            output.encodeStringElement(serialDesc, 2, self.getName());
            output.encodeStringElement(serialDesc, 3, self.getLabel());
            output.encodeStringElement(serialDesc, 4, self.getPlaceholder());
            output.encodeStringElement(serialDesc, 5, self.email);
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

        @Override
        public String getPlaceholder() {
            return this.placeholder;
        }

        public final String getEmail() {
            return this.email;
        }

        public Email(String id, String name, String label, String placeholder, String email) {
            super(FieldType.EMAIL, null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(name, "name");
            Intrinsics.checkNotNullParameter(label, "label");
            Intrinsics.checkNotNullParameter(placeholder, "placeholder");
            Intrinsics.checkNotNullParameter(email, "email");
            this.id = id;
            this.name = name;
            this.label = label;
            this.placeholder = placeholder;
            this.email = email;
        }
    }

    @Metadata(m17d1 = {"\u0000V\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0015\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 52\u00020\u0001:\u000245Bs\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\t\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u0007\u0012\u000e\u0010\u000b\u001a\n\u0012\u0004\u0012\u00020\r\u0018\u00010\f\u0012\u0006\u0010\u000e\u001a\u00020\u0003\u0012\u000e\u0010\u000f\u001a\n\u0012\u0004\u0012\u00020\r\u0018\u00010\f\u0012\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011¢\u0006\u0002\u0010\u0012BI\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\u0007\u0012\u0006\u0010\t\u001a\u00020\u0007\u0012\u0006\u0010\n\u001a\u00020\u0007\u0012\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\r0\f\u0012\u0006\u0010\u000e\u001a\u00020\u0003\u0012\f\u0010\u000f\u001a\b\u0012\u0004\u0012\u00020\r0\f¢\u0006\u0002\u0010\u0013J\t\u0010\u001e\u001a\u00020\u0007HÆ\u0003J\t\u0010\u001f\u001a\u00020\u0007HÆ\u0003J\t\u0010 \u001a\u00020\u0007HÆ\u0003J\t\u0010!\u001a\u00020\u0007HÆ\u0003J\u000f\u0010\"\u001a\b\u0012\u0004\u0012\u00020\r0\fHÆ\u0003J\t\u0010#\u001a\u00020\u0003HÆ\u0003J\u000f\u0010$\u001a\b\u0012\u0004\u0012\u00020\r0\fHÆ\u0003J[\u0010%\u001a\u00020\u00002\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\u00072\b\b\u0002\u0010\t\u001a\u00020\u00072\b\b\u0002\u0010\n\u001a\u00020\u00072\u000e\b\u0002\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\r0\f2\b\b\u0002\u0010\u000e\u001a\u00020\u00032\u000e\b\u0002\u0010\u000f\u001a\b\u0012\u0004\u0012\u00020\r0\fHÆ\u0001J\u0013\u0010&\u001a\u00020'2\b\u0010(\u001a\u0004\u0018\u00010)HÖ\u0003J\t\u0010*\u001a\u00020\u0003HÖ\u0001J\t\u0010+\u001a\u00020\u0007HÖ\u0001J&\u0010,\u001a\u00020-2\u0006\u0010.\u001a\u00020\u00002\u0006\u0010/\u001a\u0002002\u0006\u00101\u001a\u000202HÁ\u0001¢\u0006\u0002\b3R\u0014\u0010\u0006\u001a\u00020\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0015R\u0014\u0010\t\u001a\u00020\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0015R\u0014\u0010\b\u001a\u00020\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0015R\u0017\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\r0\f¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0019R\u0014\u0010\n\u001a\u00020\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u0015R\u0017\u0010\u000f\u001a\b\u0012\u0004\u0012\u00020\r0\f¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u0019R\u0011\u0010\u000e\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u001d¨\u00066"}, m18d2 = {"Lzendesk/conversationkit/android/model/Field$Select;", "Lzendesk/conversationkit/android/model/Field;", "seen1", "", "fieldType", "Lzendesk/conversationkit/android/model/FieldType;", "id", "", "name", "label", "placeholder", "options", "", "Lzendesk/conversationkit/android/model/FieldOption;", "selectSize", "select", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/conversationkit/android/model/FieldType;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/List;ILjava/util/List;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/List;ILjava/util/List;)V", "getId", "()Ljava/lang/String;", "getLabel", "getName", "getOptions", "()Ljava/util/List;", "getPlaceholder", "getSelect", "getSelectSize", "()I", "component1", "component2", "component3", "component4", "component5", "component6", "component7", "copy", "equals", "", "other", "", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("select")
    public static final class Select extends Field {
        public static final int DEFAULT_SELECT_SIZE = 1;
        private final String id;
        private final String label;
        private final String name;
        private final List<FieldOption> options;
        private final String placeholder;
        private final List<FieldOption> select;
        private final int selectSize;

        public static final Companion INSTANCE = new Companion(null);
        private static final KSerializer<Object>[] $childSerializers = {FieldType.INSTANCE.serializer(), null, null, null, null, new ArrayListSerializer(FieldOption$$serializer.INSTANCE), null, new ArrayListSerializer(FieldOption$$serializer.INSTANCE)};

        public static Select copy$default(Select select, String str, String str2, String str3, String str4, List list, int i, List list2, int i2, Object obj) {
            if ((i2 & 1) != 0) {
                str = select.id;
            }
            if ((i2 & 2) != 0) {
                str2 = select.name;
            }
            String str5 = str2;
            if ((i2 & 4) != 0) {
                str3 = select.label;
            }
            String str6 = str3;
            if ((i2 & 8) != 0) {
                str4 = select.placeholder;
            }
            String str7 = str4;
            if ((i2 & 16) != 0) {
                list = select.options;
            }
            List list3 = list;
            if ((i2 & 32) != 0) {
                i = select.selectSize;
            }
            int i3 = i;
            if ((i2 & 64) != 0) {
                list2 = select.select;
            }
            return select.copy(str, str5, str6, str7, list3, i3, list2);
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

        public final String getPlaceholder() {
            return this.placeholder;
        }

        public final List<FieldOption> component5() {
            return this.options;
        }

        public final int getSelectSize() {
            return this.selectSize;
        }

        public final List<FieldOption> component7() {
            return this.select;
        }

        public final Select copy(String id, String name, String label, String placeholder, List<FieldOption> options, int selectSize, List<FieldOption> select) {
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(name, "name");
            Intrinsics.checkNotNullParameter(label, "label");
            Intrinsics.checkNotNullParameter(placeholder, "placeholder");
            Intrinsics.checkNotNullParameter(options, "options");
            Intrinsics.checkNotNullParameter(select, "select");
            return new Select(id, name, label, placeholder, options, selectSize, select);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Select)) {
                return false;
            }
            Select select = (Select) other;
            return Intrinsics.areEqual(this.id, select.id) && Intrinsics.areEqual(this.name, select.name) && Intrinsics.areEqual(this.label, select.label) && Intrinsics.areEqual(this.placeholder, select.placeholder) && Intrinsics.areEqual(this.options, select.options) && this.selectSize == select.selectSize && Intrinsics.areEqual(this.select, select.select);
        }

        public int hashCode() {
            return (((((((((((this.id.hashCode() * 31) + this.name.hashCode()) * 31) + this.label.hashCode()) * 31) + this.placeholder.hashCode()) * 31) + this.options.hashCode()) * 31) + this.selectSize) * 31) + this.select.hashCode();
        }

        public String toString() {
            return "Select(id=" + this.id + ", name=" + this.name + ", label=" + this.label + ", placeholder=" + this.placeholder + ", options=" + this.options + ", selectSize=" + this.selectSize + ", select=" + this.select + ')';
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public Select(int i, FieldType fieldType, String str, String str2, String str3, String str4, List list, int i2, List list2, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, fieldType, serializationConstructorMarker);
            if (255 != (i & 255)) {
                PluginExceptionsKt.throwMissingFieldException(i, 255, Field$Select$$serializer.INSTANCE.getDescriptor());
            }
            this.id = str;
            this.name = str2;
            this.label = str3;
            this.placeholder = str4;
            this.options = list;
            this.selectSize = i2;
            this.select = list2;
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(Select self, CompositeEncoder output, SerialDescriptor serialDesc) {
            Field.write$Self(self, output, serialDesc);
            KSerializer<Object>[] kSerializerArr = $childSerializers;
            output.encodeStringElement(serialDesc, 1, self.getId());
            output.encodeStringElement(serialDesc, 2, self.getName());
            output.encodeStringElement(serialDesc, 3, self.getLabel());
            output.encodeStringElement(serialDesc, 4, self.getPlaceholder());
            output.encodeSerializableElement(serialDesc, 5, kSerializerArr[5], self.options);
            output.encodeIntElement(serialDesc, 6, self.selectSize);
            output.encodeSerializableElement(serialDesc, 7, kSerializerArr[7], self.select);
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

        @Override
        public String getPlaceholder() {
            return this.placeholder;
        }

        public final List<FieldOption> getOptions() {
            return this.options;
        }

        public final int getSelectSize() {
            return this.selectSize;
        }

        public final List<FieldOption> getSelect() {
            return this.select;
        }

        public Select(String id, String name, String label, String placeholder, List<FieldOption> options, int i, List<FieldOption> select) {
            super(FieldType.SELECT, null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(name, "name");
            Intrinsics.checkNotNullParameter(label, "label");
            Intrinsics.checkNotNullParameter(placeholder, "placeholder");
            Intrinsics.checkNotNullParameter(options, "options");
            Intrinsics.checkNotNullParameter(select, "select");
            this.id = id;
            this.name = name;
            this.label = label;
            this.placeholder = placeholder;
            this.options = options;
            this.selectSize = i;
            this.select = select;
        }

        @Metadata(m17d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0080\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00070\u0006HÆ\u0001R\u000e\u0010\u0003\u001a\u00020\u0004X\u0080T¢\u0006\u0002\n\u0000¨\u0006\b"}, m18d2 = {"Lzendesk/conversationkit/android/model/Field$Select$Companion;", "", "()V", "DEFAULT_SELECT_SIZE", "", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/Field$Select;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<Select> serializer() {
                return Field$Select$$serializer.INSTANCE;
            }
        }
    }

    @Metadata(m17d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00070\u0006HÆ\u0001R\u000e\u0010\u0003\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000¨\u0006\b"}, m18d2 = {"Lzendesk/conversationkit/android/model/Field$Companion;", "", "()V", "SYSTEM_FIELD_NAME", "", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/Field;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        private final KSerializer get$cachedSerializer() {
            return (KSerializer) Field.$cachedSerializer$delegate.getValue();
        }

        public final KSerializer<Field> serializer() {
            return get$cachedSerializer();
        }
    }
}
