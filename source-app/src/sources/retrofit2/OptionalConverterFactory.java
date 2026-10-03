package retrofit2;

import j$.util.Optional;
import java.io.IOException;
import java.lang.annotation.Annotation;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import javax.annotation.Nullable;
import okhttp3.ResponseBody;

public final class OptionalConverterFactory extends Converter.Factory {
    public static OptionalConverterFactory create() {
        return new OptionalConverterFactory();
    }

    OptionalConverterFactory() {
    }

    @Override
    @Nullable
    public Converter<ResponseBody, ?> responseBodyConverter(Type type, Annotation[] annotationArr, Retrofit retrofit) {
        if (getRawType(type) != Optional.class) {
            return null;
        }
        return new OptionalConverter(retrofit.responseBodyConverter(getParameterUpperBound(0, (ParameterizedType) type), annotationArr));
    }

    static final class OptionalConverter<T> implements Converter<ResponseBody, Optional<T>> {
        private final Converter<ResponseBody, T> delegate;

        OptionalConverter(Converter<ResponseBody, T> converter) {
            this.delegate = converter;
        }

        @Override
        public Optional<T> convert(ResponseBody responseBody) throws IOException {
            return Optional.ofNullable(this.delegate.convert(responseBody));
        }
    }
}
