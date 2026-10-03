package kotlinx.serialization.json.internal;

import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.UByte;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.UInt;
import kotlin.ULong;
import kotlin.UShort;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.ExperimentalSerializationApi;
import kotlinx.serialization.PolymorphicSerializerKt;
import kotlinx.serialization.SerializationStrategy;
import kotlinx.serialization.descriptors.PolymorphicKind;
import kotlinx.serialization.descriptors.PrimitiveKind;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.descriptors.SerialKind;
import kotlinx.serialization.descriptors.StructureKind;
import kotlinx.serialization.encoding.AbstractEncoder;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.encoding.Encoder;
import kotlinx.serialization.internal.AbstractPolymorphicSerializer;
import kotlinx.serialization.internal.NamedValueEncoder;
import kotlinx.serialization.json.ClassDiscriminatorMode;
import kotlinx.serialization.json.Json;
import kotlinx.serialization.json.JsonConfiguration;
import kotlinx.serialization.json.JsonElement;
import kotlinx.serialization.json.JsonElementKt;
import kotlinx.serialization.json.JsonElementSerializer;
import kotlinx.serialization.json.JsonEncoder;
import kotlinx.serialization.json.JsonLiteral;
import kotlinx.serialization.json.JsonNull;
import kotlinx.serialization.modules.SerializersModule;

@Metadata(m17d1 = {"\u0000²\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0005\n\u0000\n\u0002\u0010\f\n\u0000\n\u0002\u0010\u0006\n\u0002\b\u0004\n\u0002\u0010\u0007\n\u0002\b\u0004\n\u0002\u0010\t\n\u0002\b\u0002\n\u0002\u0010\n\n\u0002\b\u0002\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\b\u0003\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000*\u0002HK\b3\u0018\u00002\u00020\u00012\u00020\u0002B#\b\u0004\u0012\u0006\u0010\u0003\u001a\u00020\u0004\u0012\u0012\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\b0\u0006¢\u0006\u0002\u0010\tJ\u0010\u0010\u0016\u001a\u00020\u00172\u0006\u0010\u0018\u001a\u00020\u0019H\u0016J\u0018\u0010\u001a\u001a\u00020\u00112\u0006\u0010\u001b\u001a\u00020\u00112\u0006\u0010\u001c\u001a\u00020\u0011H\u0014J\u0018\u0010\u001d\u001a\u00020\u00112\u0006\u0010\u0018\u001a\u00020\u00192\u0006\u0010\u001e\u001a\u00020\u001fH\u0014J\u0010\u0010 \u001a\u00020!2\u0006\u0010\u0018\u001a\u00020\u0019H\u0016J\u0010\u0010\"\u001a\u00020\b2\u0006\u0010#\u001a\u00020\u0007H\u0016J\b\u0010$\u001a\u00020\bH\u0016J\b\u0010%\u001a\u00020\bH\u0016J)\u0010&\u001a\u00020\b\"\u0004\b\u0000\u0010'2\f\u0010(\u001a\b\u0012\u0004\u0012\u0002H'0)2\u0006\u0010*\u001a\u0002H'H\u0016¢\u0006\u0002\u0010+J\u0018\u0010,\u001a\u00020\b2\u0006\u0010-\u001a\u00020\u00112\u0006\u0010*\u001a\u00020.H\u0014J\u0018\u0010/\u001a\u00020\b2\u0006\u0010-\u001a\u00020\u00112\u0006\u0010*\u001a\u000200H\u0014J\u0018\u00101\u001a\u00020\b2\u0006\u0010-\u001a\u00020\u00112\u0006\u0010*\u001a\u000202H\u0014J\u0018\u00103\u001a\u00020\b2\u0006\u0010-\u001a\u00020\u00112\u0006\u0010*\u001a\u000204H\u0014J \u00105\u001a\u00020\b2\u0006\u0010-\u001a\u00020\u00112\u0006\u00106\u001a\u00020\u00192\u0006\u00107\u001a\u00020\u001fH\u0014J\u0018\u00108\u001a\u00020\b2\u0006\u0010-\u001a\u00020\u00112\u0006\u0010*\u001a\u000209H\u0014J\u0018\u0010:\u001a\u00020!2\u0006\u0010-\u001a\u00020\u00112\u0006\u0010;\u001a\u00020\u0019H\u0014J\u0018\u0010<\u001a\u00020\b2\u0006\u0010-\u001a\u00020\u00112\u0006\u0010*\u001a\u00020\u001fH\u0014J\u0018\u0010=\u001a\u00020\b2\u0006\u0010-\u001a\u00020\u00112\u0006\u0010*\u001a\u00020>H\u0014J\u0010\u0010?\u001a\u00020\b2\u0006\u0010-\u001a\u00020\u0011H\u0014J\u0018\u0010@\u001a\u00020\b2\u0006\u0010-\u001a\u00020\u00112\u0006\u0010*\u001a\u00020AH\u0014J\u0018\u0010B\u001a\u00020\b2\u0006\u0010-\u001a\u00020\u00112\u0006\u0010*\u001a\u00020\u0011H\u0014J\u0018\u0010C\u001a\u00020\b2\u0006\u0010-\u001a\u00020\u00112\u0006\u0010*\u001a\u00020DH\u0014J\u0010\u0010E\u001a\u00020\b2\u0006\u0010\u0018\u001a\u00020\u0019H\u0014J\b\u0010F\u001a\u00020\u0007H&J\u001d\u0010G\u001a\u00020H2\u0006\u0010-\u001a\u00020\u00112\u0006\u0010;\u001a\u00020\u0019H\u0002¢\u0006\u0002\u0010IJ\u0015\u0010J\u001a\u00020K2\u0006\u0010-\u001a\u00020\u0011H\u0003¢\u0006\u0002\u0010LJ\u0018\u0010M\u001a\u00020\b2\u0006\u0010N\u001a\u00020\u00112\u0006\u0010#\u001a\u00020\u0007H&J\u0018\u0010O\u001a\u00020.2\u0006\u0010\u0018\u001a\u00020\u00192\u0006\u0010\u001e\u001a\u00020\u001fH\u0016R\u0010\u0010\n\u001a\u00020\u000b8\u0004X\u0085\u0004¢\u0006\u0002\n\u0000R\u0011\u0010\u0003\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR \u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\b0\u0006X\u0084\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u0010\u0010\u0010\u001a\u0004\u0018\u00010\u0011X\u0082\u000e¢\u0006\u0002\n\u0000R\u0011\u0010\u0012\u001a\u00020\u00138F¢\u0006\u0006\u001a\u0004\b\u0014\u0010\u0015\u0082\u0001\u0003PQR¨\u0006S"}, m18d2 = {"Lkotlinx/serialization/json/internal/AbstractJsonTreeEncoder;", "Lkotlinx/serialization/internal/NamedValueEncoder;", "Lkotlinx/serialization/json/JsonEncoder;", "json", "Lkotlinx/serialization/json/Json;", "nodeConsumer", "Lkotlin/Function1;", "Lkotlinx/serialization/json/JsonElement;", "", "(Lkotlinx/serialization/json/Json;Lkotlin/jvm/functions/Function1;)V", "configuration", "Lkotlinx/serialization/json/JsonConfiguration;", "getJson", "()Lkotlinx/serialization/json/Json;", "getNodeConsumer", "()Lkotlin/jvm/functions/Function1;", "polymorphicDiscriminator", "", "serializersModule", "Lkotlinx/serialization/modules/SerializersModule;", "getSerializersModule", "()Lkotlinx/serialization/modules/SerializersModule;", "beginStructure", "Lkotlinx/serialization/encoding/CompositeEncoder;", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "composeName", "parentName", "childName", "elementName", "index", "", "encodeInline", "Lkotlinx/serialization/encoding/Encoder;", "encodeJsonElement", "element", "encodeNotNullMark", "encodeNull", "encodeSerializableValue", "T", "serializer", "Lkotlinx/serialization/SerializationStrategy;", "value", "(Lkotlinx/serialization/SerializationStrategy;Ljava/lang/Object;)V", "encodeTaggedBoolean", "tag", "", "encodeTaggedByte", "", "encodeTaggedChar", "", "encodeTaggedDouble", "", "encodeTaggedEnum", "enumDescriptor", "ordinal", "encodeTaggedFloat", "", "encodeTaggedInline", "inlineDescriptor", "encodeTaggedInt", "encodeTaggedLong", "", "encodeTaggedNull", "encodeTaggedShort", "", "encodeTaggedString", "encodeTaggedValue", "", "endEncode", "getCurrent", "inlineUnquotedLiteralEncoder", "kotlinx/serialization/json/internal/AbstractJsonTreeEncoder$inlineUnquotedLiteralEncoder$1", "(Ljava/lang/String;Lkotlinx/serialization/descriptors/SerialDescriptor;)Lkotlinx/serialization/json/internal/AbstractJsonTreeEncoder$inlineUnquotedLiteralEncoder$1;", "inlineUnsignedNumberEncoder", "kotlinx/serialization/json/internal/AbstractJsonTreeEncoder$inlineUnsignedNumberEncoder$1", "(Ljava/lang/String;)Lkotlinx/serialization/json/internal/AbstractJsonTreeEncoder$inlineUnsignedNumberEncoder$1;", "putElement", "key", "shouldEncodeElementDefault", "Lkotlinx/serialization/json/internal/JsonPrimitiveEncoder;", "Lkotlinx/serialization/json/internal/JsonTreeEncoder;", "Lkotlinx/serialization/json/internal/JsonTreeListEncoder;", "kotlinx-serialization-json"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@ExperimentalSerializationApi
abstract class AbstractJsonTreeEncoder extends NamedValueEncoder implements JsonEncoder {
    protected final JsonConfiguration configuration;
    private final Json json;
    private final Function1<JsonElement, Unit> nodeConsumer;
    private String polymorphicDiscriminator;

    public AbstractJsonTreeEncoder(Json json, Function1 function1, DefaultConstructorMarker defaultConstructorMarker) {
        this(json, function1);
    }

    @Override
    protected String composeName(String parentName, String childName) {
        Intrinsics.checkNotNullParameter(parentName, "parentName");
        Intrinsics.checkNotNullParameter(childName, "childName");
        return childName;
    }

    @Override
    public void encodeNotNullMark() {
    }

    public abstract JsonElement getCurrent();

    public abstract void putElement(String key, JsonElement element);

    @Override
    public final Json getJson() {
        return this.json;
    }

    protected final Function1<JsonElement, Unit> getNodeConsumer() {
        return this.nodeConsumer;
    }

    private AbstractJsonTreeEncoder(Json json, Function1<? super JsonElement, Unit> function1) {
        this.json = json;
        this.nodeConsumer = function1;
        this.configuration = json.getConfiguration();
    }

    @Override
    public final SerializersModule getSerializersModule() {
        return this.json.getSerializersModule();
    }

    @Override
    protected String elementName(SerialDescriptor descriptor, int index) {
        Intrinsics.checkNotNullParameter(descriptor, "descriptor");
        return JsonNamesMapKt.getJsonElementName(descriptor, this.json, index);
    }

    @Override
    public void encodeJsonElement(JsonElement element) {
        Intrinsics.checkNotNullParameter(element, "element");
        encodeSerializableValue(JsonElementSerializer.INSTANCE, element);
    }

    @Override
    public boolean shouldEncodeElementDefault(SerialDescriptor descriptor, int index) {
        Intrinsics.checkNotNullParameter(descriptor, "descriptor");
        return this.configuration.getEncodeDefaults();
    }

    @Override
    public void encodeNull() {
        String currentTagOrNull = getCurrentTagOrNull();
        if (currentTagOrNull == null) {
            this.nodeConsumer.invoke(JsonNull.INSTANCE);
        } else {
            encodeTaggedNull(currentTagOrNull);
        }
    }

    @Override
    public void encodeTaggedNull(String tag) {
        Intrinsics.checkNotNullParameter(tag, "tag");
        putElement(tag, JsonNull.INSTANCE);
    }

    @Override
    public void encodeTaggedInt(String tag, int value) {
        Intrinsics.checkNotNullParameter(tag, "tag");
        putElement(tag, JsonElementKt.JsonPrimitive(Integer.valueOf(value)));
    }

    @Override
    public void encodeTaggedByte(String tag, byte value) {
        Intrinsics.checkNotNullParameter(tag, "tag");
        putElement(tag, JsonElementKt.JsonPrimitive(Byte.valueOf(value)));
    }

    @Override
    public void encodeTaggedShort(String tag, short value) {
        Intrinsics.checkNotNullParameter(tag, "tag");
        putElement(tag, JsonElementKt.JsonPrimitive(Short.valueOf(value)));
    }

    @Override
    public void encodeTaggedLong(String tag, long value) {
        Intrinsics.checkNotNullParameter(tag, "tag");
        putElement(tag, JsonElementKt.JsonPrimitive(Long.valueOf(value)));
    }

    @Override
    public void encodeTaggedFloat(String tag, float value) {
        Intrinsics.checkNotNullParameter(tag, "tag");
        putElement(tag, JsonElementKt.JsonPrimitive(Float.valueOf(value)));
        if (this.configuration.getAllowSpecialFloatingPointValues()) {
            return;
        }
        if (Float.isInfinite(value) || Float.isNaN(value)) {
            throw JsonExceptionsKt.InvalidFloatingPointEncoded(Float.valueOf(value), tag, getCurrent().toString());
        }
    }

    @Override
    public <T> void encodeSerializableValue(SerializationStrategy<? super T> serializer, T value) {
        String strClassDiscriminator;
        Intrinsics.checkNotNullParameter(serializer, "serializer");
        if (getCurrentTagOrNull() != null || !TreeJsonEncoderKt.getRequiresTopLevelTag(WriteModeKt.carrierDescriptor(serializer.getDescriptor(), getSerializersModule()))) {
            AbstractJsonTreeEncoder abstractJsonTreeEncoder = this;
            if (abstractJsonTreeEncoder.getJson().getConfiguration().getUseArrayPolymorphism()) {
                serializer.serialize(abstractJsonTreeEncoder, value);
                return;
            }
            boolean z = serializer instanceof AbstractPolymorphicSerializer;
            if (!z) {
                int i = PolymorphicKt.WhenMappings.$EnumSwitchMapping$0[abstractJsonTreeEncoder.getJson().getConfiguration().getClassDiscriminatorMode().ordinal()];
                if (i != 1 && i != 2) {
                    if (i == 3) {
                        SerialKind kind = serializer.getDescriptor().getKind();
                        strClassDiscriminator = (Intrinsics.areEqual(kind, StructureKind.CLASS.INSTANCE) || Intrinsics.areEqual(kind, StructureKind.OBJECT.INSTANCE)) ? PolymorphicKt.classDiscriminator(serializer.getDescriptor(), abstractJsonTreeEncoder.getJson()) : null;
                    } else {
                        throw new NoWhenBranchMatchedException();
                    }
                }
            } else if (abstractJsonTreeEncoder.getJson().getConfiguration().getClassDiscriminatorMode() != ClassDiscriminatorMode.NONE) {
            }
            if (z) {
                AbstractPolymorphicSerializer abstractPolymorphicSerializer = (AbstractPolymorphicSerializer) serializer;
                if (value == 0) {
                    throw new IllegalArgumentException(("Value for serializer " + serializer.getDescriptor() + " should always be non-null. Please report issue to the kotlinx.serialization tracker.").toString());
                }
                SerializationStrategy<? super T> serializationStrategyFindPolymorphicSerializer = PolymorphicSerializerKt.findPolymorphicSerializer(abstractPolymorphicSerializer, abstractJsonTreeEncoder, value);
                if (strClassDiscriminator != null) {
                    PolymorphicKt.validateIfSealed(serializer, serializationStrategyFindPolymorphicSerializer, strClassDiscriminator);
                }
                PolymorphicKt.checkKind(serializationStrategyFindPolymorphicSerializer.getDescriptor().getKind());
                Intrinsics.checkNotNull(serializationStrategyFindPolymorphicSerializer, "null cannot be cast to non-null type kotlinx.serialization.SerializationStrategy<T of kotlinx.serialization.json.internal.PolymorphicKt.encodePolymorphically>");
                serializer = serializationStrategyFindPolymorphicSerializer;
            }
            if (strClassDiscriminator != null) {
                this.polymorphicDiscriminator = strClassDiscriminator;
            }
            serializer.serialize(abstractJsonTreeEncoder, value);
            return;
        }
        new JsonPrimitiveEncoder(this.json, this.nodeConsumer).encodeSerializableValue(serializer, value);
    }

    @Override
    public void encodeTaggedDouble(String tag, double value) {
        Intrinsics.checkNotNullParameter(tag, "tag");
        putElement(tag, JsonElementKt.JsonPrimitive(Double.valueOf(value)));
        if (this.configuration.getAllowSpecialFloatingPointValues()) {
            return;
        }
        if (Double.isInfinite(value) || Double.isNaN(value)) {
            throw JsonExceptionsKt.InvalidFloatingPointEncoded(Double.valueOf(value), tag, getCurrent().toString());
        }
    }

    @Override
    public void encodeTaggedBoolean(String tag, boolean value) {
        Intrinsics.checkNotNullParameter(tag, "tag");
        putElement(tag, JsonElementKt.JsonPrimitive(Boolean.valueOf(value)));
    }

    @Override
    public void encodeTaggedChar(String tag, char value) {
        Intrinsics.checkNotNullParameter(tag, "tag");
        putElement(tag, JsonElementKt.JsonPrimitive(String.valueOf(value)));
    }

    @Override
    public void encodeTaggedString(String tag, String value) {
        Intrinsics.checkNotNullParameter(tag, "tag");
        Intrinsics.checkNotNullParameter(value, "value");
        putElement(tag, JsonElementKt.JsonPrimitive(value));
    }

    @Override
    public void encodeTaggedEnum(String tag, SerialDescriptor enumDescriptor, int ordinal) {
        Intrinsics.checkNotNullParameter(tag, "tag");
        Intrinsics.checkNotNullParameter(enumDescriptor, "enumDescriptor");
        putElement(tag, JsonElementKt.JsonPrimitive(enumDescriptor.getElementName(ordinal)));
    }

    @Override
    public void encodeTaggedValue(String tag, Object value) {
        Intrinsics.checkNotNullParameter(tag, "tag");
        Intrinsics.checkNotNullParameter(value, "value");
        putElement(tag, JsonElementKt.JsonPrimitive(value.toString()));
    }

    @Override
    public Encoder encodeTaggedInline(String tag, SerialDescriptor inlineDescriptor) {
        Intrinsics.checkNotNullParameter(tag, "tag");
        Intrinsics.checkNotNullParameter(inlineDescriptor, "inlineDescriptor");
        if (StreamingJsonEncoderKt.isUnsignedNumber(inlineDescriptor)) {
            return inlineUnsignedNumberEncoder(tag);
        }
        return StreamingJsonEncoderKt.isUnquotedLiteral(inlineDescriptor) ? inlineUnquotedLiteralEncoder(tag, inlineDescriptor) : super.encodeTaggedInline(tag, inlineDescriptor);
    }

    @Override
    public Encoder encodeInline(SerialDescriptor descriptor) {
        Intrinsics.checkNotNullParameter(descriptor, "descriptor");
        return getCurrentTagOrNull() != null ? super.encodeInline(descriptor) : new JsonPrimitiveEncoder(this.json, this.nodeConsumer).encodeInline(descriptor);
    }

    private final C04131 inlineUnsignedNumberEncoder(final String tag) {
        return new AbstractEncoder() {
            private final SerializersModule serializersModule;

            {
                this.serializersModule = AbstractJsonTreeEncoder.this.getJson().getSerializersModule();
            }

            @Override
            public SerializersModule getSerializersModule() {
                return this.serializersModule;
            }

            public final void putUnquotedString(String s) {
                Intrinsics.checkNotNullParameter(s, "s");
                AbstractJsonTreeEncoder.this.putElement(tag, new JsonLiteral(s, false, null, 4, null));
            }

            @Override
            public void encodeInt(int value) {
                putUnquotedString(UByte$$ExternalSyntheticBackport0.m33m(UInt.m391constructorimpl(value), 10));
            }

            @Override
            public void encodeLong(long value) {
                putUnquotedString(UByte$$ExternalSyntheticBackport0.m$1(ULong.m470constructorimpl(value), 10));
            }

            @Override
            public void encodeByte(byte value) {
                putUnquotedString(UByte.m358toStringimpl(UByte.m314constructorimpl(value)));
            }

            @Override
            public void encodeShort(short value) {
                putUnquotedString(UShort.m621toStringimpl(UShort.m577constructorimpl(value)));
            }
        };
    }

    private final C04121 inlineUnquotedLiteralEncoder(final String tag, final SerialDescriptor inlineDescriptor) {
        return new AbstractEncoder() {
            @Override
            public SerializersModule getSerializersModule() {
                return AbstractJsonTreeEncoder.this.getJson().getSerializersModule();
            }

            @Override
            public void encodeString(String value) {
                Intrinsics.checkNotNullParameter(value, "value");
                AbstractJsonTreeEncoder.this.putElement(tag, new JsonLiteral(value, false, inlineDescriptor));
            }
        };
    }

    @Override
    public CompositeEncoder beginStructure(SerialDescriptor descriptor) {
        JsonTreeEncoder jsonTreeEncoder;
        AbstractJsonTreeEncoder jsonTreeMapEncoder;
        Intrinsics.checkNotNullParameter(descriptor, "descriptor");
        Function1<JsonElement, Unit> function1 = getCurrentTagOrNull() == null ? this.nodeConsumer : new Function1<JsonElement, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(JsonElement jsonElement) {
                invoke2(jsonElement);
                return Unit.INSTANCE;
            }

            public final void invoke2(JsonElement node) {
                Intrinsics.checkNotNullParameter(node, "node");
                AbstractJsonTreeEncoder abstractJsonTreeEncoder = this.this$0;
                abstractJsonTreeEncoder.putElement(abstractJsonTreeEncoder.getCurrentTag(), node);
            }
        };
        SerialKind kind = descriptor.getKind();
        if (Intrinsics.areEqual(kind, StructureKind.LIST.INSTANCE) ? true : kind instanceof PolymorphicKind) {
            jsonTreeEncoder = new JsonTreeListEncoder(this.json, function1);
        } else if (!Intrinsics.areEqual(kind, StructureKind.MAP.INSTANCE)) {
            jsonTreeEncoder = new JsonTreeEncoder(this.json, function1);
        } else {
            Json json = this.json;
            SerialDescriptor serialDescriptorCarrierDescriptor = WriteModeKt.carrierDescriptor(descriptor.getElementDescriptor(0), json.getSerializersModule());
            SerialKind kind2 = serialDescriptorCarrierDescriptor.getKind();
            if ((kind2 instanceof PrimitiveKind) || Intrinsics.areEqual(kind2, SerialKind.ENUM.INSTANCE)) {
                jsonTreeMapEncoder = new JsonTreeMapEncoder(this.json, function1);
            } else if (json.getConfiguration().getAllowStructuredMapKeys()) {
                jsonTreeMapEncoder = new JsonTreeListEncoder(this.json, function1);
            } else {
                throw JsonExceptionsKt.InvalidKeyKindException(serialDescriptorCarrierDescriptor);
            }
            jsonTreeEncoder = jsonTreeMapEncoder;
        }
        String str = this.polymorphicDiscriminator;
        if (str != null) {
            Intrinsics.checkNotNull(str);
            jsonTreeEncoder.putElement(str, JsonElementKt.JsonPrimitive(descriptor.getSerialName()));
            this.polymorphicDiscriminator = null;
        }
        return jsonTreeEncoder;
    }

    @Override
    protected void endEncode(SerialDescriptor descriptor) {
        Intrinsics.checkNotNullParameter(descriptor, "descriptor");
        this.nodeConsumer.invoke(getCurrent());
    }
}
