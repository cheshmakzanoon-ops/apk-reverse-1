package retrofit2.converter.kotlinx.serialization;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.DeserializationStrategy;
import okhttp3.ResponseBody;
import retrofit2.Converter;

@Metadata(m17d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0000\u0018\u0000*\u0004\b\u0000\u0010\u00012\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u0002H\u00010\u0002B\u001b\u0012\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00000\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ\u0015\u0010\t\u001a\u00028\u00002\u0006\u0010\n\u001a\u00020\u0003H\u0016¢\u0006\u0002\u0010\u000bR\u0014\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00000\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\f"}, m18d2 = {"Lretrofit2/converter/kotlinx/serialization/DeserializationStrategyConverter;", "T", "Lretrofit2/Converter;", "Lokhttp3/ResponseBody;", "loader", "Lkotlinx/serialization/DeserializationStrategy;", "serializer", "Lretrofit2/converter/kotlinx/serialization/Serializer;", "(Lkotlinx/serialization/DeserializationStrategy;Lretrofit2/converter/kotlinx/serialization/Serializer;)V", "convert", "value", "(Lokhttp3/ResponseBody;)Ljava/lang/Object;", "kotlinx-serialization"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class DeserializationStrategyConverter<T> implements Converter<ResponseBody, T> {
    private final DeserializationStrategy<T> loader;
    private final Serializer serializer;

    public DeserializationStrategyConverter(DeserializationStrategy<? extends T> loader, Serializer serializer) {
        Intrinsics.checkNotNullParameter(loader, "loader");
        Intrinsics.checkNotNullParameter(serializer, "serializer");
        this.loader = loader;
        this.serializer = serializer;
    }

    @Override
    public T convert(ResponseBody value) {
        Intrinsics.checkNotNullParameter(value, "value");
        return (T) this.serializer.fromResponseBody(this.loader, value);
    }
}
