package kotlinx.serialization.json;

import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.MagicApiIntrinsics;
import kotlin.reflect.KType;
import kotlinx.serialization.DeserializationStrategy;
import kotlinx.serialization.SerializationStrategy;
import kotlinx.serialization.SerializersKt;
import kotlinx.serialization.StringFormat;
import kotlinx.serialization.json.internal.DescriptorSchemaCache;
import kotlinx.serialization.json.internal.JsonStreamsKt;
import kotlinx.serialization.json.internal.JsonToStringWriter;
import kotlinx.serialization.json.internal.StreamingJsonDecoder;
import kotlinx.serialization.json.internal.StringJsonLexer;
import kotlinx.serialization.json.internal.TreeJsonDecoderKt;
import kotlinx.serialization.json.internal.TreeJsonEncoderKt;
import kotlinx.serialization.json.internal.WriteMode;
import kotlinx.serialization.modules.SerializersModule;
import kotlinx.serialization.modules.SerializersModuleBuildersKt;
import okhttp3.internal.http2.Settings;

@Metadata(m17d1 = {"\u0000H\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b6\u0018\u0000 %2\u00020\u0001:\u0001%B\u0017\b\u0004\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J'\u0010\u0011\u001a\u0002H\u0012\"\u0004\b\u0000\u0010\u00122\f\u0010\u0013\u001a\b\u0012\u0004\u0012\u0002H\u00120\u00142\u0006\u0010\u0015\u001a\u00020\u0016¢\u0006\u0002\u0010\u0017J \u0010\u0018\u001a\u0002H\u0012\"\u0006\b\u0000\u0010\u0012\u0018\u00012\b\b\u0001\u0010\u0019\u001a\u00020\u001aH\u0086\b¢\u0006\u0002\u0010\u001bJ)\u0010\u0018\u001a\u0002H\u0012\"\u0004\b\u0000\u0010\u00122\f\u0010\u0013\u001a\b\u0012\u0004\u0012\u0002H\u00120\u00142\b\b\u0001\u0010\u0019\u001a\u00020\u001a¢\u0006\u0002\u0010\u001cJ'\u0010\u001d\u001a\u00020\u0016\"\u0004\b\u0000\u0010\u00122\f\u0010\u001e\u001a\b\u0012\u0004\u0012\u0002H\u00120\u001f2\u0006\u0010 \u001a\u0002H\u0012¢\u0006\u0002\u0010!J'\u0010\"\u001a\u00020\u001a\"\u0004\b\u0000\u0010\u00122\f\u0010\u001e\u001a\b\u0012\u0004\u0012\u0002H\u00120\u001f2\u0006\u0010 \u001a\u0002H\u0012¢\u0006\u0002\u0010#J\u0010\u0010$\u001a\u00020\u00162\b\b\u0001\u0010\u0019\u001a\u00020\u001aR\u001c\u0010\u0007\u001a\u00020\b8\u0000X\u0081\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\t\u0010\n\u001a\u0004\b\u000b\u0010\fR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0014\u0010\u0004\u001a\u00020\u0005X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010\u0082\u0001\u0002&'¨\u0006("}, m18d2 = {"Lkotlinx/serialization/json/Json;", "Lkotlinx/serialization/StringFormat;", "configuration", "Lkotlinx/serialization/json/JsonConfiguration;", "serializersModule", "Lkotlinx/serialization/modules/SerializersModule;", "(Lkotlinx/serialization/json/JsonConfiguration;Lkotlinx/serialization/modules/SerializersModule;)V", "_schemaCache", "Lkotlinx/serialization/json/internal/DescriptorSchemaCache;", "get_schemaCache$kotlinx_serialization_json$annotations", "()V", "get_schemaCache$kotlinx_serialization_json", "()Lkotlinx/serialization/json/internal/DescriptorSchemaCache;", "getConfiguration", "()Lkotlinx/serialization/json/JsonConfiguration;", "getSerializersModule", "()Lkotlinx/serialization/modules/SerializersModule;", "decodeFromJsonElement", "T", "deserializer", "Lkotlinx/serialization/DeserializationStrategy;", "element", "Lkotlinx/serialization/json/JsonElement;", "(Lkotlinx/serialization/DeserializationStrategy;Lkotlinx/serialization/json/JsonElement;)Ljava/lang/Object;", "decodeFromString", "string", "", "(Ljava/lang/String;)Ljava/lang/Object;", "(Lkotlinx/serialization/DeserializationStrategy;Ljava/lang/String;)Ljava/lang/Object;", "encodeToJsonElement", "serializer", "Lkotlinx/serialization/SerializationStrategy;", "value", "(Lkotlinx/serialization/SerializationStrategy;Ljava/lang/Object;)Lkotlinx/serialization/json/JsonElement;", "encodeToString", "(Lkotlinx/serialization/SerializationStrategy;Ljava/lang/Object;)Ljava/lang/String;", "parseToJsonElement", "Default", "Lkotlinx/serialization/json/Json$Default;", "Lkotlinx/serialization/json/JsonImpl;", "kotlinx-serialization-json"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class Json implements StringFormat {

    public static final Companion INSTANCE = new Companion(null);
    private final DescriptorSchemaCache _schemaCache;
    private final JsonConfiguration configuration;
    private final SerializersModule serializersModule;

    public Json(JsonConfiguration jsonConfiguration, SerializersModule serializersModule, DefaultConstructorMarker defaultConstructorMarker) {
        this(jsonConfiguration, serializersModule);
    }

    @Deprecated(level = DeprecationLevel.ERROR, message = "Should not be accessed directly, use Json.schemaCache accessor instead", replaceWith = @ReplaceWith(expression = "schemaCache", imports = {}))
    public static void get_schemaCache$kotlinx_serialization_json$annotations() {
    }

    private Json(JsonConfiguration jsonConfiguration, SerializersModule serializersModule) {
        this.configuration = jsonConfiguration;
        this.serializersModule = serializersModule;
        this._schemaCache = new DescriptorSchemaCache();
    }

    public final JsonConfiguration getConfiguration() {
        return this.configuration;
    }

    @Override
    public SerializersModule getSerializersModule() {
        return this.serializersModule;
    }

    public final DescriptorSchemaCache get_schemaCache() {
        return this._schemaCache;
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0087\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lkotlinx/serialization/json/Json$Default;", "Lkotlinx/serialization/json/Json;", "()V", "kotlinx-serialization-json"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion extends Json {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
            super(new JsonConfiguration(false, false, false, false, false, false, null, false, false, null, false, false, null, false, false, null, Settings.DEFAULT_INITIAL_WINDOW_SIZE, null), SerializersModuleBuildersKt.EmptySerializersModule(), null);
        }
    }

    @Override
    public final <T> String encodeToString(SerializationStrategy<? super T> serializer, T value) {
        Intrinsics.checkNotNullParameter(serializer, "serializer");
        JsonToStringWriter jsonToStringWriter = new JsonToStringWriter();
        try {
            JsonStreamsKt.encodeByWriter(this, jsonToStringWriter, serializer, value);
            return jsonToStringWriter.toString();
        } finally {
            jsonToStringWriter.release();
        }
    }

    public final <T> T decodeFromString(String string) {
        Intrinsics.checkNotNullParameter(string, "string");
        SerializersModule serializersModule = getSerializersModule();
        Intrinsics.reifiedOperationMarker(6, "T");
        MagicApiIntrinsics.voidMagicApiCall("kotlinx.serialization.serializer.withModule");
        return (T) decodeFromString(SerializersKt.serializer(serializersModule, (KType) null), string);
    }

    @Override
    public final <T> T decodeFromString(DeserializationStrategy<? extends T> deserializer, String string) {
        Intrinsics.checkNotNullParameter(deserializer, "deserializer");
        Intrinsics.checkNotNullParameter(string, "string");
        StringJsonLexer stringJsonLexer = new StringJsonLexer(string);
        T t = (T) new StreamingJsonDecoder(this, WriteMode.OBJ, stringJsonLexer, deserializer.getDescriptor(), null).decodeSerializableValue(deserializer);
        stringJsonLexer.expectEof();
        return t;
    }

    public final <T> JsonElement encodeToJsonElement(SerializationStrategy<? super T> serializer, T value) {
        Intrinsics.checkNotNullParameter(serializer, "serializer");
        return TreeJsonEncoderKt.writeJson(this, value, serializer);
    }

    public final <T> T decodeFromJsonElement(DeserializationStrategy<? extends T> deserializer, JsonElement element) {
        Intrinsics.checkNotNullParameter(deserializer, "deserializer");
        Intrinsics.checkNotNullParameter(element, "element");
        return (T) TreeJsonDecoderKt.readJson(this, element, deserializer);
    }

    public final JsonElement parseToJsonElement(String string) {
        Intrinsics.checkNotNullParameter(string, "string");
        return (JsonElement) decodeFromString(JsonElementSerializer.INSTANCE, string);
    }
}
