package zendesk.messaging.android.internal.rest;

import dagger.Module;
import dagger.Provides;
import javax.inject.Named;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.json.Json;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import retrofit2.Converter;
import retrofit2.Retrofit;
import retrofit2.converter.kotlinx.serialization.KotlinSerializationConverterFactory;
import zendesk.messaging.android.internal.p023di.MessagingScope;
import zendesk.okhttp.NetworkExtKt;

@Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\b\u0001\u0018\u0000 \u00102\u00020\u0001:\u0001\u0010B\u0005¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0007J\u0010\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\nH\u0007J\"\u0010\u000b\u001a\u00020\f2\b\b\u0001\u0010\r\u001a\u00020\u000e2\u0006\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u000f\u001a\u00020\bH\u0007¨\u0006\u0011"}, m18d2 = {"Lzendesk/messaging/android/internal/rest/NetworkModule;", "", "()V", "okHttpClient", "Lokhttp3/OkHttpClient;", "headerFactory", "Lzendesk/messaging/android/internal/rest/HeaderFactory;", "provideKotlinSerialization", "Lretrofit2/Converter$Factory;", "json", "Lkotlinx/serialization/json/Json;", "retrofit", "Lretrofit2/Retrofit;", "baseUrl", "", "converterFactory", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Module
public final class NetworkModule {
    public static final String CONTENT_TYPE = "application/json";

    @Provides
    @MessagingScope
    public final OkHttpClient okHttpClient(HeaderFactory headerFactory) {
        Intrinsics.checkNotNullParameter(headerFactory, "headerFactory");
        return NetworkExtKt.addInterceptors(new OkHttpClient.Builder(), headerFactory.createHeaderInterceptor(), headerFactory.loggingInterceptor()).build();
    }

    @Provides
    @MessagingScope
    public final Retrofit retrofit(@Named("baseUrl") String baseUrl, OkHttpClient okHttpClient, Converter.Factory converterFactory) {
        Intrinsics.checkNotNullParameter(baseUrl, "baseUrl");
        Intrinsics.checkNotNullParameter(okHttpClient, "okHttpClient");
        Intrinsics.checkNotNullParameter(converterFactory, "converterFactory");
        Retrofit retrofitBuild = new Retrofit.Builder().baseUrl(baseUrl).client(okHttpClient).addConverterFactory(converterFactory).build();
        Intrinsics.checkNotNullExpressionValue(retrofitBuild, "build(...)");
        return retrofitBuild;
    }

    @Provides
    @MessagingScope
    public final Converter.Factory provideKotlinSerialization(Json json) {
        Intrinsics.checkNotNullParameter(json, "json");
        return KotlinSerializationConverterFactory.create(json, MediaType.INSTANCE.get("application/json"));
    }
}
