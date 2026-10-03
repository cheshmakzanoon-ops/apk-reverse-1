package androidx.datastore.preferences.protobuf;

import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.util.Collections;
import java.util.List;

public final class Field extends GeneratedMessageLite<Field, Builder> implements FieldOrBuilder {
    public static final int CARDINALITY_FIELD_NUMBER = 2;
    private static final Field DEFAULT_INSTANCE;
    public static final int DEFAULT_VALUE_FIELD_NUMBER = 11;
    public static final int JSON_NAME_FIELD_NUMBER = 10;
    public static final int KIND_FIELD_NUMBER = 1;
    public static final int NAME_FIELD_NUMBER = 4;
    public static final int NUMBER_FIELD_NUMBER = 3;
    public static final int ONEOF_INDEX_FIELD_NUMBER = 7;
    public static final int OPTIONS_FIELD_NUMBER = 9;
    public static final int PACKED_FIELD_NUMBER = 8;
    private static volatile Parser<Field> PARSER = null;
    public static final int TYPE_URL_FIELD_NUMBER = 6;
    private int cardinality_;
    private int kind_;
    private int number_;
    private int oneofIndex_;
    private boolean packed_;
    private String name_ = "";
    private String typeUrl_ = "";
    private Internal.ProtobufList<Option> options_ = emptyProtobufList();
    private String jsonName_ = "";
    private String defaultValue_ = "";

    private Field() {
    }

    public enum Kind implements Internal.EnumLite {
        TYPE_UNKNOWN(0),
        TYPE_DOUBLE(1),
        TYPE_FLOAT(2),
        TYPE_INT64(3),
        TYPE_UINT64(4),
        TYPE_INT32(5),
        TYPE_FIXED64(6),
        TYPE_FIXED32(7),
        TYPE_BOOL(8),
        TYPE_STRING(9),
        TYPE_GROUP(10),
        TYPE_MESSAGE(11),
        TYPE_BYTES(12),
        TYPE_UINT32(13),
        TYPE_ENUM(14),
        TYPE_SFIXED32(15),
        TYPE_SFIXED64(16),
        TYPE_SINT32(17),
        TYPE_SINT64(18),
        UNRECOGNIZED(-1);

        public static final int TYPE_BOOL_VALUE = 8;
        public static final int TYPE_BYTES_VALUE = 12;
        public static final int TYPE_DOUBLE_VALUE = 1;
        public static final int TYPE_ENUM_VALUE = 14;
        public static final int TYPE_FIXED32_VALUE = 7;
        public static final int TYPE_FIXED64_VALUE = 6;
        public static final int TYPE_FLOAT_VALUE = 2;
        public static final int TYPE_GROUP_VALUE = 10;
        public static final int TYPE_INT32_VALUE = 5;
        public static final int TYPE_INT64_VALUE = 3;
        public static final int TYPE_MESSAGE_VALUE = 11;
        public static final int TYPE_SFIXED32_VALUE = 15;
        public static final int TYPE_SFIXED64_VALUE = 16;
        public static final int TYPE_SINT32_VALUE = 17;
        public static final int TYPE_SINT64_VALUE = 18;
        public static final int TYPE_STRING_VALUE = 9;
        public static final int TYPE_UINT32_VALUE = 13;
        public static final int TYPE_UINT64_VALUE = 4;
        public static final int TYPE_UNKNOWN_VALUE = 0;
        private static final Internal.EnumLiteMap<Kind> internalValueMap = new Internal.EnumLiteMap<Kind>() {
            @Override
            public Kind findValueByNumber(int i) {
                return Kind.forNumber(i);
            }
        };
        private final int value;

        @Override
        public final int getNumber() {
            if (this == UNRECOGNIZED) {
                throw new IllegalArgumentException("Can't get the number of an unknown enum value.");
            }
            return this.value;
        }

        @Deprecated
        public static Kind valueOf(int i) {
            return forNumber(i);
        }

        public static Kind forNumber(int i) {
            switch (i) {
                case 0:
                    return TYPE_UNKNOWN;
                case 1:
                    return TYPE_DOUBLE;
                case 2:
                    return TYPE_FLOAT;
                case 3:
                    return TYPE_INT64;
                case 4:
                    return TYPE_UINT64;
                case 5:
                    return TYPE_INT32;
                case 6:
                    return TYPE_FIXED64;
                case 7:
                    return TYPE_FIXED32;
                case 8:
                    return TYPE_BOOL;
                case 9:
                    return TYPE_STRING;
                case 10:
                    return TYPE_GROUP;
                case 11:
                    return TYPE_MESSAGE;
                case 12:
                    return TYPE_BYTES;
                case 13:
                    return TYPE_UINT32;
                case 14:
                    return TYPE_ENUM;
                case 15:
                    return TYPE_SFIXED32;
                case 16:
                    return TYPE_SFIXED64;
                case 17:
                    return TYPE_SINT32;
                case 18:
                    return TYPE_SINT64;
                default:
                    return null;
            }
        }

        public static Internal.EnumLiteMap<Kind> internalGetValueMap() {
            return internalValueMap;
        }

        public static Internal.EnumVerifier internalGetVerifier() {
            return KindVerifier.INSTANCE;
        }

        private static final class KindVerifier implements Internal.EnumVerifier {
            static final Internal.EnumVerifier INSTANCE = new KindVerifier();

            private KindVerifier() {
            }

            @Override
            public boolean isInRange(int i) {
                return Kind.forNumber(i) != null;
            }
        }

        Kind(int i) {
            this.value = i;
        }
    }

    public enum Cardinality implements Internal.EnumLite {
        CARDINALITY_UNKNOWN(0),
        CARDINALITY_OPTIONAL(1),
        CARDINALITY_REQUIRED(2),
        CARDINALITY_REPEATED(3),
        UNRECOGNIZED(-1);

        public static final int CARDINALITY_OPTIONAL_VALUE = 1;
        public static final int CARDINALITY_REPEATED_VALUE = 3;
        public static final int CARDINALITY_REQUIRED_VALUE = 2;
        public static final int CARDINALITY_UNKNOWN_VALUE = 0;
        private static final Internal.EnumLiteMap<Cardinality> internalValueMap = new Internal.EnumLiteMap<Cardinality>() {
            @Override
            public Cardinality findValueByNumber(int i) {
                return Cardinality.forNumber(i);
            }
        };
        private final int value;

        @Override
        public final int getNumber() {
            if (this == UNRECOGNIZED) {
                throw new IllegalArgumentException("Can't get the number of an unknown enum value.");
            }
            return this.value;
        }

        @Deprecated
        public static Cardinality valueOf(int i) {
            return forNumber(i);
        }

        public static Cardinality forNumber(int i) {
            if (i == 0) {
                return CARDINALITY_UNKNOWN;
            }
            if (i == 1) {
                return CARDINALITY_OPTIONAL;
            }
            if (i == 2) {
                return CARDINALITY_REQUIRED;
            }
            if (i != 3) {
                return null;
            }
            return CARDINALITY_REPEATED;
        }

        public static Internal.EnumLiteMap<Cardinality> internalGetValueMap() {
            return internalValueMap;
        }

        public static Internal.EnumVerifier internalGetVerifier() {
            return CardinalityVerifier.INSTANCE;
        }

        private static final class CardinalityVerifier implements Internal.EnumVerifier {
            static final Internal.EnumVerifier INSTANCE = new CardinalityVerifier();

            private CardinalityVerifier() {
            }

            @Override
            public boolean isInRange(int i) {
                return Cardinality.forNumber(i) != null;
            }
        }

        Cardinality(int i) {
            this.value = i;
        }
    }

    @Override
    public int getKindValue() {
        return this.kind_;
    }

    @Override
    public Kind getKind() {
        Kind kindForNumber = Kind.forNumber(this.kind_);
        return kindForNumber == null ? Kind.UNRECOGNIZED : kindForNumber;
    }

    public void setKindValue(int i) {
        this.kind_ = i;
    }

    public void setKind(Kind kind) {
        kind.getClass();
        this.kind_ = kind.getNumber();
    }

    public void clearKind() {
        this.kind_ = 0;
    }

    @Override
    public int getCardinalityValue() {
        return this.cardinality_;
    }

    @Override
    public Cardinality getCardinality() {
        Cardinality cardinalityForNumber = Cardinality.forNumber(this.cardinality_);
        return cardinalityForNumber == null ? Cardinality.UNRECOGNIZED : cardinalityForNumber;
    }

    public void setCardinalityValue(int i) {
        this.cardinality_ = i;
    }

    public void setCardinality(Cardinality cardinality) {
        cardinality.getClass();
        this.cardinality_ = cardinality.getNumber();
    }

    public void clearCardinality() {
        this.cardinality_ = 0;
    }

    @Override
    public int getNumber() {
        return this.number_;
    }

    public void setNumber(int i) {
        this.number_ = i;
    }

    public void clearNumber() {
        this.number_ = 0;
    }

    @Override
    public String getName() {
        return this.name_;
    }

    @Override
    public ByteString getNameBytes() {
        return ByteString.copyFromUtf8(this.name_);
    }

    public void setName(String str) {
        str.getClass();
        this.name_ = str;
    }

    public void clearName() {
        this.name_ = getDefaultInstance().getName();
    }

    public void setNameBytes(ByteString byteString) {
        byteString.getClass();
        checkByteStringIsUtf8(byteString);
        this.name_ = byteString.toStringUtf8();
    }

    @Override
    public String getTypeUrl() {
        return this.typeUrl_;
    }

    @Override
    public ByteString getTypeUrlBytes() {
        return ByteString.copyFromUtf8(this.typeUrl_);
    }

    public void setTypeUrl(String str) {
        str.getClass();
        this.typeUrl_ = str;
    }

    public void clearTypeUrl() {
        this.typeUrl_ = getDefaultInstance().getTypeUrl();
    }

    public void setTypeUrlBytes(ByteString byteString) {
        byteString.getClass();
        checkByteStringIsUtf8(byteString);
        this.typeUrl_ = byteString.toStringUtf8();
    }

    @Override
    public int getOneofIndex() {
        return this.oneofIndex_;
    }

    public void setOneofIndex(int i) {
        this.oneofIndex_ = i;
    }

    public void clearOneofIndex() {
        this.oneofIndex_ = 0;
    }

    @Override
    public boolean getPacked() {
        return this.packed_;
    }

    public void setPacked(boolean z) {
        this.packed_ = z;
    }

    public void clearPacked() {
        this.packed_ = false;
    }

    @Override
    public List<Option> getOptionsList() {
        return this.options_;
    }

    public List<? extends OptionOrBuilder> getOptionsOrBuilderList() {
        return this.options_;
    }

    @Override
    public int getOptionsCount() {
        return this.options_.size();
    }

    @Override
    public Option getOptions(int i) {
        return this.options_.get(i);
    }

    public OptionOrBuilder getOptionsOrBuilder(int i) {
        return this.options_.get(i);
    }

    private void ensureOptionsIsMutable() {
        if (this.options_.isModifiable()) {
            return;
        }
        this.options_ = GeneratedMessageLite.mutableCopy(this.options_);
    }

    public void setOptions(int i, Option option) {
        option.getClass();
        ensureOptionsIsMutable();
        this.options_.set(i, option);
    }

    public void setOptions(int i, Option.Builder builder) {
        ensureOptionsIsMutable();
        this.options_.set(i, builder.build());
    }

    public void addOptions(Option option) {
        option.getClass();
        ensureOptionsIsMutable();
        this.options_.add(option);
    }

    public void addOptions(int i, Option option) {
        option.getClass();
        ensureOptionsIsMutable();
        this.options_.add(i, option);
    }

    public void addOptions(Option.Builder builder) {
        ensureOptionsIsMutable();
        this.options_.add(builder.build());
    }

    public void addOptions(int i, Option.Builder builder) {
        ensureOptionsIsMutable();
        this.options_.add(i, builder.build());
    }

    public void addAllOptions(Iterable<? extends Option> iterable) {
        ensureOptionsIsMutable();
        AbstractMessageLite.addAll((Iterable) iterable, (List) this.options_);
    }

    public void clearOptions() {
        this.options_ = emptyProtobufList();
    }

    public void removeOptions(int i) {
        ensureOptionsIsMutable();
        this.options_.remove(i);
    }

    @Override
    public String getJsonName() {
        return this.jsonName_;
    }

    @Override
    public ByteString getJsonNameBytes() {
        return ByteString.copyFromUtf8(this.jsonName_);
    }

    public void setJsonName(String str) {
        str.getClass();
        this.jsonName_ = str;
    }

    public void clearJsonName() {
        this.jsonName_ = getDefaultInstance().getJsonName();
    }

    public void setJsonNameBytes(ByteString byteString) {
        byteString.getClass();
        checkByteStringIsUtf8(byteString);
        this.jsonName_ = byteString.toStringUtf8();
    }

    @Override
    public String getDefaultValue() {
        return this.defaultValue_;
    }

    @Override
    public ByteString getDefaultValueBytes() {
        return ByteString.copyFromUtf8(this.defaultValue_);
    }

    public void setDefaultValue(String str) {
        str.getClass();
        this.defaultValue_ = str;
    }

    public void clearDefaultValue() {
        this.defaultValue_ = getDefaultInstance().getDefaultValue();
    }

    public void setDefaultValueBytes(ByteString byteString) {
        byteString.getClass();
        checkByteStringIsUtf8(byteString);
        this.defaultValue_ = byteString.toStringUtf8();
    }

    public static Field parseFrom(ByteBuffer byteBuffer) throws InvalidProtocolBufferException {
        return (Field) GeneratedMessageLite.parseFrom(DEFAULT_INSTANCE, byteBuffer);
    }

    public static Field parseFrom(ByteBuffer byteBuffer, ExtensionRegistryLite extensionRegistryLite) throws InvalidProtocolBufferException {
        return (Field) GeneratedMessageLite.parseFrom(DEFAULT_INSTANCE, byteBuffer, extensionRegistryLite);
    }

    public static Field parseFrom(ByteString byteString) throws InvalidProtocolBufferException {
        return (Field) GeneratedMessageLite.parseFrom(DEFAULT_INSTANCE, byteString);
    }

    public static Field parseFrom(ByteString byteString, ExtensionRegistryLite extensionRegistryLite) throws InvalidProtocolBufferException {
        return (Field) GeneratedMessageLite.parseFrom(DEFAULT_INSTANCE, byteString, extensionRegistryLite);
    }

    public static Field parseFrom(byte[] bArr) throws InvalidProtocolBufferException {
        return (Field) GeneratedMessageLite.parseFrom(DEFAULT_INSTANCE, bArr);
    }

    public static Field parseFrom(byte[] bArr, ExtensionRegistryLite extensionRegistryLite) throws InvalidProtocolBufferException {
        return (Field) GeneratedMessageLite.parseFrom(DEFAULT_INSTANCE, bArr, extensionRegistryLite);
    }

    public static Field parseFrom(InputStream inputStream) throws IOException {
        return (Field) GeneratedMessageLite.parseFrom(DEFAULT_INSTANCE, inputStream);
    }

    public static Field parseFrom(InputStream inputStream, ExtensionRegistryLite extensionRegistryLite) throws IOException {
        return (Field) GeneratedMessageLite.parseFrom(DEFAULT_INSTANCE, inputStream, extensionRegistryLite);
    }

    public static Field parseDelimitedFrom(InputStream inputStream) throws IOException {
        return (Field) parseDelimitedFrom(DEFAULT_INSTANCE, inputStream);
    }

    public static Field parseDelimitedFrom(InputStream inputStream, ExtensionRegistryLite extensionRegistryLite) throws IOException {
        return (Field) parseDelimitedFrom(DEFAULT_INSTANCE, inputStream, extensionRegistryLite);
    }

    public static Field parseFrom(CodedInputStream codedInputStream) throws IOException {
        return (Field) GeneratedMessageLite.parseFrom(DEFAULT_INSTANCE, codedInputStream);
    }

    public static Field parseFrom(CodedInputStream codedInputStream, ExtensionRegistryLite extensionRegistryLite) throws IOException {
        return (Field) GeneratedMessageLite.parseFrom(DEFAULT_INSTANCE, codedInputStream, extensionRegistryLite);
    }

    public static Builder newBuilder() {
        return DEFAULT_INSTANCE.createBuilder();
    }

    public static Builder newBuilder(Field field) {
        return DEFAULT_INSTANCE.createBuilder(field);
    }

    public static final class Builder extends GeneratedMessageLite.Builder<Field, Builder> implements FieldOrBuilder {
        Builder(C02601 c02601) {
            this();
        }

        private Builder() {
            super(Field.DEFAULT_INSTANCE);
        }

        @Override
        public int getKindValue() {
            return ((Field) this.instance).getKindValue();
        }

        public Builder setKindValue(int i) {
            copyOnWrite();
            ((Field) this.instance).setKindValue(i);
            return this;
        }

        @Override
        public Kind getKind() {
            return ((Field) this.instance).getKind();
        }

        public Builder setKind(Kind kind) {
            copyOnWrite();
            ((Field) this.instance).setKind(kind);
            return this;
        }

        public Builder clearKind() {
            copyOnWrite();
            ((Field) this.instance).clearKind();
            return this;
        }

        @Override
        public int getCardinalityValue() {
            return ((Field) this.instance).getCardinalityValue();
        }

        public Builder setCardinalityValue(int i) {
            copyOnWrite();
            ((Field) this.instance).setCardinalityValue(i);
            return this;
        }

        @Override
        public Cardinality getCardinality() {
            return ((Field) this.instance).getCardinality();
        }

        public Builder setCardinality(Cardinality cardinality) {
            copyOnWrite();
            ((Field) this.instance).setCardinality(cardinality);
            return this;
        }

        public Builder clearCardinality() {
            copyOnWrite();
            ((Field) this.instance).clearCardinality();
            return this;
        }

        @Override
        public int getNumber() {
            return ((Field) this.instance).getNumber();
        }

        public Builder setNumber(int i) {
            copyOnWrite();
            ((Field) this.instance).setNumber(i);
            return this;
        }

        public Builder clearNumber() {
            copyOnWrite();
            ((Field) this.instance).clearNumber();
            return this;
        }

        @Override
        public String getName() {
            return ((Field) this.instance).getName();
        }

        @Override
        public ByteString getNameBytes() {
            return ((Field) this.instance).getNameBytes();
        }

        public Builder setName(String str) {
            copyOnWrite();
            ((Field) this.instance).setName(str);
            return this;
        }

        public Builder clearName() {
            copyOnWrite();
            ((Field) this.instance).clearName();
            return this;
        }

        public Builder setNameBytes(ByteString byteString) {
            copyOnWrite();
            ((Field) this.instance).setNameBytes(byteString);
            return this;
        }

        @Override
        public String getTypeUrl() {
            return ((Field) this.instance).getTypeUrl();
        }

        @Override
        public ByteString getTypeUrlBytes() {
            return ((Field) this.instance).getTypeUrlBytes();
        }

        public Builder setTypeUrl(String str) {
            copyOnWrite();
            ((Field) this.instance).setTypeUrl(str);
            return this;
        }

        public Builder clearTypeUrl() {
            copyOnWrite();
            ((Field) this.instance).clearTypeUrl();
            return this;
        }

        public Builder setTypeUrlBytes(ByteString byteString) {
            copyOnWrite();
            ((Field) this.instance).setTypeUrlBytes(byteString);
            return this;
        }

        @Override
        public int getOneofIndex() {
            return ((Field) this.instance).getOneofIndex();
        }

        public Builder setOneofIndex(int i) {
            copyOnWrite();
            ((Field) this.instance).setOneofIndex(i);
            return this;
        }

        public Builder clearOneofIndex() {
            copyOnWrite();
            ((Field) this.instance).clearOneofIndex();
            return this;
        }

        @Override
        public boolean getPacked() {
            return ((Field) this.instance).getPacked();
        }

        public Builder setPacked(boolean z) {
            copyOnWrite();
            ((Field) this.instance).setPacked(z);
            return this;
        }

        public Builder clearPacked() {
            copyOnWrite();
            ((Field) this.instance).clearPacked();
            return this;
        }

        @Override
        public List<Option> getOptionsList() {
            return Collections.unmodifiableList(((Field) this.instance).getOptionsList());
        }

        @Override
        public int getOptionsCount() {
            return ((Field) this.instance).getOptionsCount();
        }

        @Override
        public Option getOptions(int i) {
            return ((Field) this.instance).getOptions(i);
        }

        public Builder setOptions(int i, Option option) {
            copyOnWrite();
            ((Field) this.instance).setOptions(i, option);
            return this;
        }

        public Builder setOptions(int i, Option.Builder builder) {
            copyOnWrite();
            ((Field) this.instance).setOptions(i, builder);
            return this;
        }

        public Builder addOptions(Option option) {
            copyOnWrite();
            ((Field) this.instance).addOptions(option);
            return this;
        }

        public Builder addOptions(int i, Option option) {
            copyOnWrite();
            ((Field) this.instance).addOptions(i, option);
            return this;
        }

        public Builder addOptions(Option.Builder builder) {
            copyOnWrite();
            ((Field) this.instance).addOptions(builder);
            return this;
        }

        public Builder addOptions(int i, Option.Builder builder) {
            copyOnWrite();
            ((Field) this.instance).addOptions(i, builder);
            return this;
        }

        public Builder addAllOptions(Iterable<? extends Option> iterable) {
            copyOnWrite();
            ((Field) this.instance).addAllOptions(iterable);
            return this;
        }

        public Builder clearOptions() {
            copyOnWrite();
            ((Field) this.instance).clearOptions();
            return this;
        }

        public Builder removeOptions(int i) {
            copyOnWrite();
            ((Field) this.instance).removeOptions(i);
            return this;
        }

        @Override
        public String getJsonName() {
            return ((Field) this.instance).getJsonName();
        }

        @Override
        public ByteString getJsonNameBytes() {
            return ((Field) this.instance).getJsonNameBytes();
        }

        public Builder setJsonName(String str) {
            copyOnWrite();
            ((Field) this.instance).setJsonName(str);
            return this;
        }

        public Builder clearJsonName() {
            copyOnWrite();
            ((Field) this.instance).clearJsonName();
            return this;
        }

        public Builder setJsonNameBytes(ByteString byteString) {
            copyOnWrite();
            ((Field) this.instance).setJsonNameBytes(byteString);
            return this;
        }

        @Override
        public String getDefaultValue() {
            return ((Field) this.instance).getDefaultValue();
        }

        @Override
        public ByteString getDefaultValueBytes() {
            return ((Field) this.instance).getDefaultValueBytes();
        }

        public Builder setDefaultValue(String str) {
            copyOnWrite();
            ((Field) this.instance).setDefaultValue(str);
            return this;
        }

        public Builder clearDefaultValue() {
            copyOnWrite();
            ((Field) this.instance).clearDefaultValue();
            return this;
        }

        public Builder setDefaultValueBytes(ByteString byteString) {
            copyOnWrite();
            ((Field) this.instance).setDefaultValueBytes(byteString);
            return this;
        }
    }

    static class C02601 {

        static final int[] f67xa1df5c61;

        static {
            int[] iArr = new int[GeneratedMessageLite.MethodToInvoke.values().length];
            f67xa1df5c61 = iArr;
            try {
                iArr[GeneratedMessageLite.MethodToInvoke.NEW_MUTABLE_INSTANCE.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                f67xa1df5c61[GeneratedMessageLite.MethodToInvoke.NEW_BUILDER.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                f67xa1df5c61[GeneratedMessageLite.MethodToInvoke.BUILD_MESSAGE_INFO.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                f67xa1df5c61[GeneratedMessageLite.MethodToInvoke.GET_DEFAULT_INSTANCE.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
            try {
                f67xa1df5c61[GeneratedMessageLite.MethodToInvoke.GET_PARSER.ordinal()] = 5;
            } catch (NoSuchFieldError unused5) {
            }
            try {
                f67xa1df5c61[GeneratedMessageLite.MethodToInvoke.GET_MEMOIZED_IS_INITIALIZED.ordinal()] = 6;
            } catch (NoSuchFieldError unused6) {
            }
            try {
                f67xa1df5c61[GeneratedMessageLite.MethodToInvoke.SET_MEMOIZED_IS_INITIALIZED.ordinal()] = 7;
            } catch (NoSuchFieldError unused7) {
            }
        }
    }

    @Override
    protected final Object dynamicMethod(GeneratedMessageLite.MethodToInvoke methodToInvoke, Object obj, Object obj2) {
        C02601 c02601 = null;
        switch (C02601.f67xa1df5c61[methodToInvoke.ordinal()]) {
            case 1:
                return new Field();
            case 2:
                return new Builder(c02601);
            case 3:
                return newMessageInfo(DEFAULT_INSTANCE, "\u0000\n\u0000\u0000\u0001\u000b\n\u0000\u0001\u0000\u0001\f\u0002\f\u0003\u0004\u0004Ȉ\u0006Ȉ\u0007\u0004\b\u0007\t\u001b\nȈ\u000bȈ", new Object[]{"kind_", "cardinality_", "number_", "name_", "typeUrl_", "oneofIndex_", "packed_", "options_", Option.class, "jsonName_", "defaultValue_"});
            case 4:
                return DEFAULT_INSTANCE;
            case 5:
                Parser<Field> defaultInstanceBasedParser = PARSER;
                if (defaultInstanceBasedParser == null) {
                    synchronized (Field.class) {
                        defaultInstanceBasedParser = PARSER;
                        if (defaultInstanceBasedParser == null) {
                            defaultInstanceBasedParser = new GeneratedMessageLite.DefaultInstanceBasedParser<>(DEFAULT_INSTANCE);
                            PARSER = defaultInstanceBasedParser;
                        }
                        break;
                    }
                }
                return defaultInstanceBasedParser;
            case 6:
                return (byte) 1;
            case 7:
                return null;
            default:
                throw new UnsupportedOperationException();
        }
    }

    static {
        Field field = new Field();
        DEFAULT_INSTANCE = field;
        GeneratedMessageLite.registerDefaultInstance(Field.class, field);
    }

    public static Field getDefaultInstance() {
        return DEFAULT_INSTANCE;
    }

    public static Parser<Field> parser() {
        return DEFAULT_INSTANCE.getParserForType();
    }
}
