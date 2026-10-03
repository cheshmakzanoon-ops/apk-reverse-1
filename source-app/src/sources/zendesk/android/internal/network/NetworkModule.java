package zendesk.android.internal.network;

import android.content.Context;
import dagger.Module;
import dagger.Provides;
import j$.time.LocalDateTime;
import java.io.File;
import java.util.Date;
import javax.inject.Singleton;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Reflection;
import kotlinx.serialization.json.Json;
import kotlinx.serialization.json.JsonBuilder;
import kotlinx.serialization.json.JsonKt;
import kotlinx.serialization.modules.SerializersModuleBuilder;
import okhttp3.Cache;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import retrofit2.Converter;
import retrofit2.Retrofit;
import retrofit2.converter.kotlinx.serialization.KotlinSerializationConverterFactory;
import zendesk.android.internal.p013di.ZendeskComponentConfig;
import zendesk.android.internal.proactivemessaging.model.Expression;
import zendesk.android.internal.proactivemessaging.model.serializer.ExpressionSerializer;
import zendesk.core.android.internal.serializer.AnySerializer;
import zendesk.core.android.internal.serializer.DateSerializer;
import zendesk.core.android.internal.serializer.LocalDateTimeSerializer;
import zendesk.okhttp.NetworkExtKt;

@Metadata(m17d1 = {"\u0000@\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0001\u0018\u0000 \u00152\u00020\u0001:\u0001\u0015B\u0005¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0007J\u0018\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n2\u0006\u0010\u0003\u001a\u00020\u0004H\u0007J\b\u0010\u000b\u001a\u00020\fH\u0007J\u0010\u0010\r\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\fH\u0007J \u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u00132\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\u0014\u001a\u00020\u000eH\u0007¨\u0006\u0016"}, m18d2 = {"Lzendesk/android/internal/network/NetworkModule;", "", "()V", "cacheDir", "Ljava/io/File;", "context", "Landroid/content/Context;", "okHttpClient", "Lokhttp3/OkHttpClient;", "headerFactory", "Lzendesk/android/internal/network/HeaderFactory;", "provideJson", "Lkotlinx/serialization/json/Json;", "provideKotlinSerialization", "Lretrofit2/Converter$Factory;", "json", "retrofit", "Lretrofit2/Retrofit;", "componentConfig", "Lzendesk/android/internal/di/ZendeskComponentConfig;", "converterFactory", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Module
public final class NetworkModule {
    public static final long CACHE_SIZE = 20971520;
    public static final String CONTENT_TYPE = "application/json";
    public static final String ZENDESK_ANDROID_DIR_NAME = "zendesk.android";

    @Provides
    @Singleton
    public final File cacheDir(Context context) {
        Intrinsics.checkNotNullParameter(context, "context");
        return new File(context.getCacheDir(), "zendesk.android");
    }

    @Provides
    @Singleton
    public final OkHttpClient okHttpClient(HeaderFactory headerFactory, File cacheDir) {
        Intrinsics.checkNotNullParameter(headerFactory, "headerFactory");
        Intrinsics.checkNotNullParameter(cacheDir, "cacheDir");
        return NetworkExtKt.addInterceptors(new OkHttpClient.Builder(), headerFactory.createHeaderInterceptor(), headerFactory.loggingInterceptor()).cache(new Cache(cacheDir, 20971520L)).build();
    }

    @Provides
    @Singleton
    public final Retrofit retrofit(ZendeskComponentConfig componentConfig, OkHttpClient okHttpClient, Converter.Factory converterFactory) {
        Intrinsics.checkNotNullParameter(componentConfig, "componentConfig");
        Intrinsics.checkNotNullParameter(okHttpClient, "okHttpClient");
        Intrinsics.checkNotNullParameter(converterFactory, "converterFactory");
        Retrofit retrofitBuild = new Retrofit.Builder().baseUrl(componentConfig.getBaseUrl()).client(okHttpClient).addConverterFactory(converterFactory).build();
        Intrinsics.checkNotNullExpressionValue(retrofitBuild, "build(...)");
        return retrofitBuild;
    }

    @Provides
    @Singleton
    public final Converter.Factory provideKotlinSerialization(Json json) {
        Intrinsics.checkNotNullParameter(json, "json");
        return KotlinSerializationConverterFactory.create(json, MediaType.INSTANCE.get("application/json"));
    }

    @Provides
    @Singleton
    public final Json provideJson() {
        return JsonKt.Json$default(null, new Function1<JsonBuilder, Unit>() {
            @Override
            public Unit invoke(JsonBuilder jsonBuilder) {
                invoke2(jsonBuilder);
                return Unit.INSTANCE;
            }

            public final void invoke2(JsonBuilder Json) {
                Intrinsics.checkNotNullParameter(Json, "$this$Json");
                Json.setEncodeDefaults(true);
                Json.setIgnoreUnknownKeys(true);
                Json.setExplicitNulls(false);
                Json.setLenient(true);
                SerializersModuleBuilder serializersModuleBuilder = new SerializersModuleBuilder();
                serializersModuleBuilder.contextual(Reflection.getOrCreateKotlinClass(LocalDateTime.class), LocalDateTimeSerializer.INSTANCE);
                serializersModuleBuilder.contextual(Reflection.getOrCreateKotlinClass(Date.class), DateSerializer.INSTANCE);
                serializersModuleBuilder.contextual(Reflection.getOrCreateKotlinClass(Object.class), AnySerializer.INSTANCE);
                serializersModuleBuilder.contextual(Reflection.getOrCreateKotlinClass(Expression.class), ExpressionSerializer.INSTANCE);
                Json.setSerializersModule(serializersModuleBuilder.build());
            }
        }, 1, null);
    }
}
