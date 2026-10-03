package retrofit2.converter.kotlinx.serialization;

import java.io.IOException;
import java.lang.reflect.Type;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.BinaryFormat;
import kotlinx.serialization.DeserializationStrategy;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.SerialFormat;
import kotlinx.serialization.SerializationStrategy;
import kotlinx.serialization.SerializersKt;
import kotlinx.serialization.StringFormat;
import okhttp3.MediaType;
import okhttp3.RequestBody;
import okhttp3.ResponseBody;

@Metadata(m17d1 = {"\u0000L\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b0\u0018\u00002\u00020\u0001:\u0002\u001a\u001bB\u0007\b\u0004¢\u0006\u0002\u0010\u0002J)\u0010\u0007\u001a\u0002H\b\"\u0004\b\u0000\u0010\b2\f\u0010\t\u001a\b\u0012\u0004\u0012\u0002H\b0\n2\u0006\u0010\u000b\u001a\u00020\fH&¢\u0006\u0002\u0010\rJ\u0014\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\u00010\u000f2\u0006\u0010\u0010\u001a\u00020\u0011J1\u0010\u0012\u001a\u00020\u0013\"\u0004\b\u0000\u0010\b2\u0006\u0010\u0014\u001a\u00020\u00152\f\u0010\u0016\u001a\b\u0012\u0004\u0012\u0002H\b0\u00172\u0006\u0010\u0018\u001a\u0002H\bH&¢\u0006\u0002\u0010\u0019R\u0012\u0010\u0003\u001a\u00020\u0004X¤\u0004¢\u0006\u0006\u001a\u0004\b\u0005\u0010\u0006\u0082\u0001\u0002\u001c\u001d¨\u0006\u001e"}, m18d2 = {"Lretrofit2/converter/kotlinx/serialization/Serializer;", "", "()V", "format", "Lkotlinx/serialization/SerialFormat;", "getFormat", "()Lkotlinx/serialization/SerialFormat;", "fromResponseBody", "T", "loader", "Lkotlinx/serialization/DeserializationStrategy;", "body", "Lokhttp3/ResponseBody;", "(Lkotlinx/serialization/DeserializationStrategy;Lokhttp3/ResponseBody;)Ljava/lang/Object;", "serializer", "Lkotlinx/serialization/KSerializer;", "type", "Ljava/lang/reflect/Type;", "toRequestBody", "Lokhttp3/RequestBody;", "contentType", "Lokhttp3/MediaType;", "saver", "Lkotlinx/serialization/SerializationStrategy;", "value", "(Lokhttp3/MediaType;Lkotlinx/serialization/SerializationStrategy;Ljava/lang/Object;)Lokhttp3/RequestBody;", "FromBytes", "FromString", "Lretrofit2/converter/kotlinx/serialization/Serializer$FromBytes;", "Lretrofit2/converter/kotlinx/serialization/Serializer$FromString;", "kotlinx-serialization"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class Serializer {
    public Serializer(DefaultConstructorMarker defaultConstructorMarker) {
        this();
    }

    public abstract <T> T fromResponseBody(DeserializationStrategy<? extends T> loader, ResponseBody body);

    protected abstract SerialFormat getFormat();

    public abstract <T> RequestBody toRequestBody(MediaType contentType, SerializationStrategy<? super T> saver, T value);

    private Serializer() {
    }

    public final KSerializer<Object> serializer(Type type) {
        Intrinsics.checkNotNullParameter(type, "type");
        return SerializersKt.serializer(getFormat().getSerializersModule(), type);
    }

    @Metadata(m17d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J)\u0010\u0007\u001a\u0002H\b\"\u0004\b\u0000\u0010\b2\f\u0010\t\u001a\b\u0012\u0004\u0012\u0002H\b0\n2\u0006\u0010\u000b\u001a\u00020\fH\u0016¢\u0006\u0002\u0010\rJ1\u0010\u000e\u001a\u00020\u000f\"\u0004\b\u0000\u0010\b2\u0006\u0010\u0010\u001a\u00020\u00112\f\u0010\u0012\u001a\b\u0012\u0004\u0012\u0002H\b0\u00132\u0006\u0010\u0014\u001a\u0002H\bH\u0016¢\u0006\u0002\u0010\u0015R\u0014\u0010\u0002\u001a\u00020\u0003X\u0094\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0016"}, m18d2 = {"Lretrofit2/converter/kotlinx/serialization/Serializer$FromString;", "Lretrofit2/converter/kotlinx/serialization/Serializer;", "format", "Lkotlinx/serialization/StringFormat;", "(Lkotlinx/serialization/StringFormat;)V", "getFormat", "()Lkotlinx/serialization/StringFormat;", "fromResponseBody", "T", "loader", "Lkotlinx/serialization/DeserializationStrategy;", "body", "Lokhttp3/ResponseBody;", "(Lkotlinx/serialization/DeserializationStrategy;Lokhttp3/ResponseBody;)Ljava/lang/Object;", "toRequestBody", "Lokhttp3/RequestBody;", "contentType", "Lokhttp3/MediaType;", "saver", "Lkotlinx/serialization/SerializationStrategy;", "value", "(Lokhttp3/MediaType;Lkotlinx/serialization/SerializationStrategy;Ljava/lang/Object;)Lokhttp3/RequestBody;", "kotlinx-serialization"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class FromString extends Serializer {
        private final StringFormat format;

        public FromString(StringFormat format) {
            super(null);
            Intrinsics.checkNotNullParameter(format, "format");
            this.format = format;
        }

        @Override
        public StringFormat getFormat() {
            return this.format;
        }

        @Override
        public <T> T fromResponseBody(DeserializationStrategy<? extends T> loader, ResponseBody body) throws IOException {
            Intrinsics.checkNotNullParameter(loader, "loader");
            Intrinsics.checkNotNullParameter(body, "body");
            String strString = body.string();
            StringFormat format = getFormat();
            Intrinsics.checkNotNull(strString);
            return (T) format.decodeFromString(loader, strString);
        }

        @Override
        public <T> RequestBody toRequestBody(MediaType contentType, SerializationStrategy<? super T> saver, T value) {
            Intrinsics.checkNotNullParameter(contentType, "contentType");
            Intrinsics.checkNotNullParameter(saver, "saver");
            RequestBody requestBodyCreate = RequestBody.create(contentType, getFormat().encodeToString(saver, value));
            Intrinsics.checkNotNullExpressionValue(requestBodyCreate, "create(...)");
            return requestBodyCreate;
        }
    }

    @Metadata(m17d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J)\u0010\u0007\u001a\u0002H\b\"\u0004\b\u0000\u0010\b2\f\u0010\t\u001a\b\u0012\u0004\u0012\u0002H\b0\n2\u0006\u0010\u000b\u001a\u00020\fH\u0016¢\u0006\u0002\u0010\rJ1\u0010\u000e\u001a\u00020\u000f\"\u0004\b\u0000\u0010\b2\u0006\u0010\u0010\u001a\u00020\u00112\f\u0010\u0012\u001a\b\u0012\u0004\u0012\u0002H\b0\u00132\u0006\u0010\u0014\u001a\u0002H\bH\u0016¢\u0006\u0002\u0010\u0015R\u0014\u0010\u0002\u001a\u00020\u0003X\u0094\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0016"}, m18d2 = {"Lretrofit2/converter/kotlinx/serialization/Serializer$FromBytes;", "Lretrofit2/converter/kotlinx/serialization/Serializer;", "format", "Lkotlinx/serialization/BinaryFormat;", "(Lkotlinx/serialization/BinaryFormat;)V", "getFormat", "()Lkotlinx/serialization/BinaryFormat;", "fromResponseBody", "T", "loader", "Lkotlinx/serialization/DeserializationStrategy;", "body", "Lokhttp3/ResponseBody;", "(Lkotlinx/serialization/DeserializationStrategy;Lokhttp3/ResponseBody;)Ljava/lang/Object;", "toRequestBody", "Lokhttp3/RequestBody;", "contentType", "Lokhttp3/MediaType;", "saver", "Lkotlinx/serialization/SerializationStrategy;", "value", "(Lokhttp3/MediaType;Lkotlinx/serialization/SerializationStrategy;Ljava/lang/Object;)Lokhttp3/RequestBody;", "kotlinx-serialization"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class FromBytes extends Serializer {
        private final BinaryFormat format;

        public FromBytes(BinaryFormat format) {
            super(null);
            Intrinsics.checkNotNullParameter(format, "format");
            this.format = format;
        }

        @Override
        public BinaryFormat getFormat() {
            return this.format;
        }

        @Override
        public <T> T fromResponseBody(DeserializationStrategy<? extends T> loader, ResponseBody body) throws IOException {
            Intrinsics.checkNotNullParameter(loader, "loader");
            Intrinsics.checkNotNullParameter(body, "body");
            byte[] bArrBytes = body.bytes();
            BinaryFormat format = getFormat();
            Intrinsics.checkNotNull(bArrBytes);
            return (T) format.decodeFromByteArray(loader, bArrBytes);
        }

        @Override
        public <T> RequestBody toRequestBody(MediaType contentType, SerializationStrategy<? super T> saver, T value) {
            Intrinsics.checkNotNullParameter(contentType, "contentType");
            Intrinsics.checkNotNullParameter(saver, "saver");
            RequestBody requestBodyCreate = RequestBody.create(contentType, getFormat().encodeToByteArray(saver, value));
            Intrinsics.checkNotNullExpressionValue(requestBodyCreate, "create(...)");
            return requestBodyCreate;
        }
    }
}
