package retrofit2.converter.kotlinx.serialization;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.SerializationStrategy;
import okhttp3.MediaType;
import okhttp3.RequestBody;
import retrofit2.Converter;

@Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0000\u0018\u0000*\u0004\b\u0000\u0010\u00012\u000e\u0012\u0004\u0012\u0002H\u0001\u0012\u0004\u0012\u00020\u00030\u0002B#\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00028\u00000\u0007\u0012\u0006\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\nJ\u0015\u0010\u000b\u001a\u00020\u00032\u0006\u0010\f\u001a\u00028\u0000H\u0016¢\u0006\u0002\u0010\rR\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0006\u001a\b\u0012\u0004\u0012\u00028\u00000\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u000e"}, m18d2 = {"Lretrofit2/converter/kotlinx/serialization/SerializationStrategyConverter;", "T", "Lretrofit2/Converter;", "Lokhttp3/RequestBody;", "contentType", "Lokhttp3/MediaType;", "saver", "Lkotlinx/serialization/SerializationStrategy;", "serializer", "Lretrofit2/converter/kotlinx/serialization/Serializer;", "(Lokhttp3/MediaType;Lkotlinx/serialization/SerializationStrategy;Lretrofit2/converter/kotlinx/serialization/Serializer;)V", "convert", "value", "(Ljava/lang/Object;)Lokhttp3/RequestBody;", "kotlinx-serialization"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class SerializationStrategyConverter<T> implements Converter<T, RequestBody> {
    private final MediaType contentType;
    private final SerializationStrategy<T> saver;
    private final Serializer serializer;

    public SerializationStrategyConverter(MediaType contentType, SerializationStrategy<? super T> saver, Serializer serializer) {
        Intrinsics.checkNotNullParameter(contentType, "contentType");
        Intrinsics.checkNotNullParameter(saver, "saver");
        Intrinsics.checkNotNullParameter(serializer, "serializer");
        this.contentType = contentType;
        this.saver = saver;
        this.serializer = serializer;
    }

    @Override
    public RequestBody convert(T value) {
        return this.serializer.toRequestBody(this.contentType, this.saver, value);
    }
}
