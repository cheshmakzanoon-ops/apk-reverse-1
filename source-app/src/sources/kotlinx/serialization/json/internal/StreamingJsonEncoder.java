package kotlinx.serialization.json.internal;

import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.PolymorphicSerializerKt;
import kotlinx.serialization.SerializationStrategy;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.descriptors.SerialKind;
import kotlinx.serialization.descriptors.StructureKind;
import kotlinx.serialization.encoding.AbstractEncoder;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.encoding.Encoder;
import kotlinx.serialization.internal.AbstractPolymorphicSerializer;
import kotlinx.serialization.json.ClassDiscriminatorMode;
import kotlinx.serialization.json.Json;
import kotlinx.serialization.json.JsonConfiguration;
import kotlinx.serialization.json.JsonElement;
import kotlinx.serialization.json.JsonElementSerializer;
import kotlinx.serialization.json.JsonEncoder;
import kotlinx.serialization.modules.SerializersModule;

@Metadata(m17d1 = {"\u0000¼\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0011\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\u0005\n\u0000\n\u0002\u0010\f\n\u0000\n\u0002\u0010\u0006\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\t\n\u0002\b\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\n\n\u0002\b\u0005\b\u0000\u0018\u00002\u00020\u00012\u00020\u0002B/\b\u0010\u0012\u0006\u0010\u0003\u001a\u00020\u0004\u0012\u0006\u0010\u0005\u001a\u00020\u0006\u0012\u0006\u0010\u0007\u001a\u00020\b\u0012\u000e\u0010\t\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00010\n¢\u0006\u0002\u0010\u000bB/\u0012\u0006\u0010\f\u001a\u00020\r\u0012\u0006\u0010\u0005\u001a\u00020\u0006\u0012\u0006\u0010\u0007\u001a\u00020\b\u0012\u0010\u0010\t\u001a\f\u0012\u0006\u0012\u0004\u0018\u00010\u0001\u0018\u00010\n¢\u0006\u0002\u0010\u000eJ\u0010\u0010\u001c\u001a\u00020\u001d2\u0006\u0010\u001e\u001a\u00020\u001fH\u0016JR\u0010 \u001a\u0002H!\"\n\b\u0000\u0010!\u0018\u0001*\u00020\r26\u0010\"\u001a2\u0012\u0013\u0012\u00110\u0004¢\u0006\f\b$\u0012\b\b%\u0012\u0004\b\b(&\u0012\u0013\u0012\u00110\u0012¢\u0006\f\b$\u0012\b\b%\u0012\u0004\b\b(\u0011\u0012\u0004\u0012\u0002H!0#H\u0082\b¢\u0006\u0002\u0010'J\u0010\u0010(\u001a\u00020)2\u0006\u0010*\u001a\u00020\u0012H\u0016J\u0010\u0010+\u001a\u00020)2\u0006\u0010*\u001a\u00020,H\u0016J\u0010\u0010-\u001a\u00020)2\u0006\u0010*\u001a\u00020.H\u0016J\u0010\u0010/\u001a\u00020)2\u0006\u0010*\u001a\u000200H\u0016J\u0018\u00101\u001a\u00020\u00122\u0006\u0010\u001e\u001a\u00020\u001f2\u0006\u00102\u001a\u000203H\u0016J\u0018\u00104\u001a\u00020)2\u0006\u00105\u001a\u00020\u001f2\u0006\u00102\u001a\u000203H\u0016J\u0010\u00106\u001a\u00020)2\u0006\u0010*\u001a\u000207H\u0016J\u0010\u00108\u001a\u0002092\u0006\u0010\u001e\u001a\u00020\u001fH\u0016J\u0010\u0010:\u001a\u00020)2\u0006\u0010*\u001a\u000203H\u0016J\u0010\u0010;\u001a\u00020)2\u0006\u0010<\u001a\u00020=H\u0016J\u0010\u0010>\u001a\u00020)2\u0006\u0010*\u001a\u00020?H\u0016J\b\u0010@\u001a\u00020)H\u0016J?\u0010A\u001a\u00020)\"\b\b\u0000\u0010!*\u00020B2\u0006\u0010\u001e\u001a\u00020\u001f2\u0006\u00102\u001a\u0002032\f\u0010C\u001a\b\u0012\u0004\u0012\u0002H!0D2\b\u0010*\u001a\u0004\u0018\u0001H!H\u0016¢\u0006\u0002\u0010EJ)\u0010F\u001a\u00020)\"\u0004\b\u0000\u0010!2\f\u0010C\u001a\b\u0012\u0004\u0012\u0002H!0D2\u0006\u0010*\u001a\u0002H!H\u0016¢\u0006\u0002\u0010GJ\u0010\u0010H\u001a\u00020)2\u0006\u0010*\u001a\u00020IH\u0016J\u0010\u0010J\u001a\u00020)2\u0006\u0010*\u001a\u00020\u0017H\u0016J\u0010\u0010K\u001a\u00020)2\u0006\u0010\u001e\u001a\u00020\u001fH\u0002J\u0010\u0010L\u001a\u00020)2\u0006\u0010\u001e\u001a\u00020\u001fH\u0016J\u0018\u0010M\u001a\u00020\u00122\u0006\u0010\u001e\u001a\u00020\u001f2\u0006\u00102\u001a\u000203H\u0016R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\u0010X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0011\u001a\u00020\u0012X\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010\u0005\u001a\u00020\u0006X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R\u000e\u0010\u0007\u001a\u00020\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u001a\u0010\t\u001a\f\u0012\u0006\u0012\u0004\u0018\u00010\u0001\u0018\u00010\nX\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0015R\u0010\u0010\u0016\u001a\u0004\u0018\u00010\u0017X\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010\u0018\u001a\u00020\u0019X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u001b¨\u0006N"}, m18d2 = {"Lkotlinx/serialization/json/internal/StreamingJsonEncoder;", "Lkotlinx/serialization/json/JsonEncoder;", "Lkotlinx/serialization/encoding/AbstractEncoder;", "output", "Lkotlinx/serialization/json/internal/InternalJsonWriter;", "json", "Lkotlinx/serialization/json/Json;", "mode", "Lkotlinx/serialization/json/internal/WriteMode;", "modeReuseCache", "", "(Lkotlinx/serialization/json/internal/InternalJsonWriter;Lkotlinx/serialization/json/Json;Lkotlinx/serialization/json/internal/WriteMode;[Lkotlinx/serialization/json/JsonEncoder;)V", "composer", "Lkotlinx/serialization/json/internal/Composer;", "(Lkotlinx/serialization/json/internal/Composer;Lkotlinx/serialization/json/Json;Lkotlinx/serialization/json/internal/WriteMode;[Lkotlinx/serialization/json/JsonEncoder;)V", "configuration", "Lkotlinx/serialization/json/JsonConfiguration;", "forceQuoting", "", "getJson", "()Lkotlinx/serialization/json/Json;", "[Lkotlinx/serialization/json/JsonEncoder;", "polymorphicDiscriminator", "", "serializersModule", "Lkotlinx/serialization/modules/SerializersModule;", "getSerializersModule", "()Lkotlinx/serialization/modules/SerializersModule;", "beginStructure", "Lkotlinx/serialization/encoding/CompositeEncoder;", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "composerAs", "T", "composerCreator", "Lkotlin/Function2;", "Lkotlin/ParameterName;", "name", "writer", "(Lkotlin/jvm/functions/Function2;)Lkotlinx/serialization/json/internal/Composer;", "encodeBoolean", "", "value", "encodeByte", "", "encodeChar", "", "encodeDouble", "", "encodeElement", "index", "", "encodeEnum", "enumDescriptor", "encodeFloat", "", "encodeInline", "Lkotlinx/serialization/encoding/Encoder;", "encodeInt", "encodeJsonElement", "element", "Lkotlinx/serialization/json/JsonElement;", "encodeLong", "", "encodeNull", "encodeNullableSerializableElement", "", "serializer", "Lkotlinx/serialization/SerializationStrategy;", "(Lkotlinx/serialization/descriptors/SerialDescriptor;ILkotlinx/serialization/SerializationStrategy;Ljava/lang/Object;)V", "encodeSerializableValue", "(Lkotlinx/serialization/SerializationStrategy;Ljava/lang/Object;)V", "encodeShort", "", "encodeString", "encodeTypeInfo", "endStructure", "shouldEncodeElementDefault", "kotlinx-serialization-json"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class StreamingJsonEncoder extends AbstractEncoder implements JsonEncoder {
    private final Composer composer;
    private final JsonConfiguration configuration;
    private boolean forceQuoting;
    private final Json json;
    private final WriteMode mode;
    private final JsonEncoder[] modeReuseCache;
    private String polymorphicDiscriminator;
    private final SerializersModule serializersModule;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[WriteMode.values().length];
            try {
                iArr[WriteMode.LIST.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[WriteMode.MAP.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[WriteMode.POLY_OBJ.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    @Override
    public Json getJson() {
        return this.json;
    }

    public StreamingJsonEncoder(Composer composer, Json json, WriteMode mode, JsonEncoder[] jsonEncoderArr) {
        Intrinsics.checkNotNullParameter(composer, "composer");
        Intrinsics.checkNotNullParameter(json, "json");
        Intrinsics.checkNotNullParameter(mode, "mode");
        this.composer = composer;
        this.json = json;
        this.mode = mode;
        this.modeReuseCache = jsonEncoderArr;
        this.serializersModule = getJson().getSerializersModule();
        this.configuration = getJson().getConfiguration();
        int iOrdinal = mode.ordinal();
        if (jsonEncoderArr != null) {
            JsonEncoder jsonEncoder = jsonEncoderArr[iOrdinal];
            if (jsonEncoder == null && jsonEncoder == this) {
                return;
            }
            jsonEncoderArr[iOrdinal] = this;
        }
    }

    public StreamingJsonEncoder(InternalJsonWriter output, Json json, WriteMode mode, JsonEncoder[] modeReuseCache) {
        this(ComposersKt.Composer(output, json), json, mode, modeReuseCache);
        Intrinsics.checkNotNullParameter(output, "output");
        Intrinsics.checkNotNullParameter(json, "json");
        Intrinsics.checkNotNullParameter(mode, "mode");
        Intrinsics.checkNotNullParameter(modeReuseCache, "modeReuseCache");
    }

    @Override
    public SerializersModule getSerializersModule() {
        return this.serializersModule;
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
    public <T> void encodeSerializableValue(SerializationStrategy<? super T> serializer, T value) {
        String strClassDiscriminator;
        Intrinsics.checkNotNullParameter(serializer, "serializer");
        StreamingJsonEncoder streamingJsonEncoder = this;
        if (streamingJsonEncoder.getJson().getConfiguration().getUseArrayPolymorphism()) {
            serializer.serialize(streamingJsonEncoder, value);
            return;
        }
        boolean z = serializer instanceof AbstractPolymorphicSerializer;
        if (!z) {
            int i = PolymorphicKt.WhenMappings.$EnumSwitchMapping$0[streamingJsonEncoder.getJson().getConfiguration().getClassDiscriminatorMode().ordinal()];
            if (i != 1 && i != 2) {
                if (i == 3) {
                    SerialKind kind = serializer.getDescriptor().getKind();
                    strClassDiscriminator = (Intrinsics.areEqual(kind, StructureKind.CLASS.INSTANCE) || Intrinsics.areEqual(kind, StructureKind.OBJECT.INSTANCE)) ? PolymorphicKt.classDiscriminator(serializer.getDescriptor(), streamingJsonEncoder.getJson()) : null;
                } else {
                    throw new NoWhenBranchMatchedException();
                }
            }
        } else if (streamingJsonEncoder.getJson().getConfiguration().getClassDiscriminatorMode() != ClassDiscriminatorMode.NONE) {
        }
        if (z) {
            AbstractPolymorphicSerializer abstractPolymorphicSerializer = (AbstractPolymorphicSerializer) serializer;
            if (value == 0) {
                throw new IllegalArgumentException(("Value for serializer " + serializer.getDescriptor() + " should always be non-null. Please report issue to the kotlinx.serialization tracker.").toString());
            }
            SerializationStrategy<? super T> serializationStrategyFindPolymorphicSerializer = PolymorphicSerializerKt.findPolymorphicSerializer(abstractPolymorphicSerializer, streamingJsonEncoder, value);
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
        serializer.serialize(streamingJsonEncoder, value);
    }

    private final void encodeTypeInfo(SerialDescriptor descriptor) {
        this.composer.nextItem();
        String str = this.polymorphicDiscriminator;
        Intrinsics.checkNotNull(str);
        encodeString(str);
        this.composer.print(AbstractJsonLexerKt.COLON);
        this.composer.space();
        encodeString(descriptor.getSerialName());
    }

    @Override
    public CompositeEncoder beginStructure(SerialDescriptor descriptor) {
        JsonEncoder streamingJsonEncoder;
        Intrinsics.checkNotNullParameter(descriptor, "descriptor");
        WriteMode writeModeSwitchMode = WriteModeKt.switchMode(getJson(), descriptor);
        if (writeModeSwitchMode.begin != 0) {
            this.composer.print(writeModeSwitchMode.begin);
            this.composer.indent();
        }
        if (this.polymorphicDiscriminator != null) {
            encodeTypeInfo(descriptor);
            this.polymorphicDiscriminator = null;
        }
        if (this.mode == writeModeSwitchMode) {
            return this;
        }
        JsonEncoder[] jsonEncoderArr = this.modeReuseCache;
        if (jsonEncoderArr == null || (streamingJsonEncoder = jsonEncoderArr[writeModeSwitchMode.ordinal()]) == null) {
            streamingJsonEncoder = new StreamingJsonEncoder(this.composer, getJson(), writeModeSwitchMode, this.modeReuseCache);
        }
        return streamingJsonEncoder;
    }

    @Override
    public void endStructure(SerialDescriptor descriptor) {
        Intrinsics.checkNotNullParameter(descriptor, "descriptor");
        if (this.mode.end != 0) {
            this.composer.unIndent();
            this.composer.nextItemIfNotFirst();
            this.composer.print(this.mode.end);
        }
    }

    @Override
    public boolean encodeElement(SerialDescriptor descriptor, int index) {
        Intrinsics.checkNotNullParameter(descriptor, "descriptor");
        int i = WhenMappings.$EnumSwitchMapping$0[this.mode.ordinal()];
        if (i != 1) {
            boolean z = false;
            if (i != 2) {
                if (i != 3) {
                    if (!this.composer.getWritingFirst()) {
                        this.composer.print(AbstractJsonLexerKt.COMMA);
                    }
                    this.composer.nextItem();
                    encodeString(JsonNamesMapKt.getJsonElementName(descriptor, getJson(), index));
                    this.composer.print(AbstractJsonLexerKt.COLON);
                    this.composer.space();
                } else {
                    if (index == 0) {
                        this.forceQuoting = true;
                    }
                    if (index == 1) {
                        this.composer.print(AbstractJsonLexerKt.COMMA);
                        this.composer.space();
                        this.forceQuoting = false;
                    }
                }
            } else if (!this.composer.getWritingFirst()) {
                if (index % 2 == 0) {
                    this.composer.print(AbstractJsonLexerKt.COMMA);
                    this.composer.nextItem();
                    z = true;
                } else {
                    this.composer.print(AbstractJsonLexerKt.COLON);
                    this.composer.space();
                }
                this.forceQuoting = z;
            } else {
                this.forceQuoting = true;
                this.composer.nextItem();
            }
        } else {
            if (!this.composer.getWritingFirst()) {
                this.composer.print(AbstractJsonLexerKt.COMMA);
            }
            this.composer.nextItem();
        }
        return true;
    }

    @Override
    public <T> void encodeNullableSerializableElement(SerialDescriptor descriptor, int index, SerializationStrategy<? super T> serializer, T value) {
        Intrinsics.checkNotNullParameter(descriptor, "descriptor");
        Intrinsics.checkNotNullParameter(serializer, "serializer");
        if (value != null || this.configuration.getExplicitNulls()) {
            super.encodeNullableSerializableElement(descriptor, index, serializer, value);
        }
    }

    @Override
    public Encoder encodeInline(SerialDescriptor descriptor) {
        Intrinsics.checkNotNullParameter(descriptor, "descriptor");
        if (!StreamingJsonEncoderKt.isUnsignedNumber(descriptor)) {
            if (!StreamingJsonEncoderKt.isUnquotedLiteral(descriptor)) {
                return super.encodeInline(descriptor);
            }
            ComposerForUnquotedLiterals composerForUnquotedLiterals = this.composer;
            if (!(composerForUnquotedLiterals instanceof ComposerForUnquotedLiterals)) {
                composerForUnquotedLiterals = new ComposerForUnquotedLiterals(composerForUnquotedLiterals.writer, this.forceQuoting);
            }
            return new StreamingJsonEncoder(composerForUnquotedLiterals, getJson(), this.mode, (JsonEncoder[]) null);
        }
        ComposerForUnsignedNumbers composerForUnsignedNumbers = this.composer;
        if (!(composerForUnsignedNumbers instanceof ComposerForUnsignedNumbers)) {
            composerForUnsignedNumbers = new ComposerForUnsignedNumbers(composerForUnsignedNumbers.writer, this.forceQuoting);
        }
        return new StreamingJsonEncoder(composerForUnsignedNumbers, getJson(), this.mode, (JsonEncoder[]) null);
    }

    private final <T extends Composer> T composerAs(Function2<? super InternalJsonWriter, ? super Boolean, ? extends T> composerCreator) {
        Composer composer = this.composer;
        Intrinsics.reifiedOperationMarker(3, "T");
        return composer instanceof Composer ? (T) this.composer : composerCreator.invoke(this.composer.writer, Boolean.valueOf(this.forceQuoting));
    }

    @Override
    public void encodeNull() {
        this.composer.print(AbstractJsonLexerKt.NULL);
    }

    @Override
    public void encodeBoolean(boolean value) {
        if (this.forceQuoting) {
            encodeString(String.valueOf(value));
        } else {
            this.composer.print(value);
        }
    }

    @Override
    public void encodeByte(byte value) {
        if (this.forceQuoting) {
            encodeString(String.valueOf((int) value));
        } else {
            this.composer.print(value);
        }
    }

    @Override
    public void encodeShort(short value) {
        if (this.forceQuoting) {
            encodeString(String.valueOf((int) value));
        } else {
            this.composer.print(value);
        }
    }

    @Override
    public void encodeInt(int value) {
        if (this.forceQuoting) {
            encodeString(String.valueOf(value));
        } else {
            this.composer.print(value);
        }
    }

    @Override
    public void encodeLong(long value) {
        if (this.forceQuoting) {
            encodeString(String.valueOf(value));
        } else {
            this.composer.print(value);
        }
    }

    @Override
    public void encodeFloat(float value) {
        if (this.forceQuoting) {
            encodeString(String.valueOf(value));
        } else {
            this.composer.print(value);
        }
        if (this.configuration.getAllowSpecialFloatingPointValues()) {
            return;
        }
        if (Float.isInfinite(value) || Float.isNaN(value)) {
            throw JsonExceptionsKt.InvalidFloatingPointEncoded(Float.valueOf(value), this.composer.writer.toString());
        }
    }

    @Override
    public void encodeDouble(double value) {
        if (this.forceQuoting) {
            encodeString(String.valueOf(value));
        } else {
            this.composer.print(value);
        }
        if (this.configuration.getAllowSpecialFloatingPointValues()) {
            return;
        }
        if (Double.isInfinite(value) || Double.isNaN(value)) {
            throw JsonExceptionsKt.InvalidFloatingPointEncoded(Double.valueOf(value), this.composer.writer.toString());
        }
    }

    @Override
    public void encodeChar(char value) {
        encodeString(String.valueOf(value));
    }

    @Override
    public void encodeString(String value) {
        Intrinsics.checkNotNullParameter(value, "value");
        this.composer.printQuoted(value);
    }

    @Override
    public void encodeEnum(SerialDescriptor enumDescriptor, int index) {
        Intrinsics.checkNotNullParameter(enumDescriptor, "enumDescriptor");
        encodeString(enumDescriptor.getElementName(index));
    }
}
