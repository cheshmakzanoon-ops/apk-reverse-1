package zendesk.guidekit.android.internal.p018di.module;

import android.content.Context;
import android.os.Build;
import cz.msebera.android.httpclient.HttpHeaders;
import dagger.Module;
import dagger.Provides;
import java.io.File;
import java.util.Arrays;
import javax.inject.Named;
import kotlin.Metadata;
import kotlin.Pair;
import kotlin.ResultKt;
import kotlin.TuplesKt;
import kotlin.Unit;
import kotlin.collections.SetsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.json.Json;
import okhttp3.Cache;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Converter;
import retrofit2.Retrofit;
import retrofit2.converter.kotlinx.serialization.KotlinSerializationConverterFactory;
import zendesk.core.p017ui.android.internal.local.LocaleProvider;
import zendesk.guidekit.android.BuildConfig;
import zendesk.guidekit.android.internal.p018di.GuideKitScope;
import zendesk.logger.Logger;
import zendesk.okhttp.HeaderInterceptor;

@Metadata(m17d1 = {"\u0000L\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0001\u0018\u0000 \u001b2\u00020\u0001:\u0001\u001bB\u0005¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0007J\u0010\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\nH\u0007J\u0010\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\u000eH\u0007J\b\u0010\u000f\u001a\u00020\u0010H\u0007J \u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u00102\u0006\u0010\u0014\u001a\u00020\f2\u0006\u0010\u0003\u001a\u00020\u0004H\u0007J\"\u0010\u0015\u001a\u00020\u00162\b\b\u0001\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u00122\u0006\u0010\u001a\u001a\u00020\bH\u0007¨\u0006\u001c"}, m18d2 = {"Lzendesk/guidekit/android/internal/di/module/NetworkModule;", "", "()V", "cacheDir", "Ljava/io/File;", "context", "Landroid/content/Context;", "provideKotlinSerialization", "Lretrofit2/Converter$Factory;", "json", "Lkotlinx/serialization/json/Json;", "providesHeaderInterceptor", "Lzendesk/okhttp/HeaderInterceptor;", "localeProvider", "Lzendesk/core/ui/android/internal/local/LocaleProvider;", "providesHttpLoggingInterceptor", "Lokhttp3/logging/HttpLoggingInterceptor;", "providesOkHttpClient", "Lokhttp3/OkHttpClient;", "loggingInterceptor", "headerInterceptor", "retrofit", "Lretrofit2/Retrofit;", "baseUrl", "", "okHttpClient", "converterFactory", "Companion", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Module
public final class NetworkModule {
    public static final String BASE_URL = "baseUrl";
    public static final String CACHE_DIR_NAME = "zendesk.guidekit.android";
    public static final long CACHE_SIZE = 20971520;
    public static final String CLIENT = "mobile/android/sdk/messaging";
    public static final String CONTENT_TYPE = "application/json";
    public static final String USER_AGENT = "Zendesk-SDK/%s Android/%s Variant/Messaging";

    @Provides
    @GuideKitScope
    public final File cacheDir(Context context) {
        Intrinsics.checkNotNullParameter(context, "context");
        return new File(context.getCacheDir(), "zendesk.guidekit.android");
    }

    public static final void providesHttpLoggingInterceptor$lambda$0(String it) {
        Intrinsics.checkNotNullParameter(it, "it");
        Logger.m221i("HttpLoggingInterceptor", it, new Object[0]);
    }

    @Provides
    @GuideKitScope
    public final HttpLoggingInterceptor providesHttpLoggingInterceptor() {
        HttpLoggingInterceptor httpLoggingInterceptor = new HttpLoggingInterceptor(new HttpLoggingInterceptor.Logger() {
            @Override
            public final void log(String str) {
                NetworkModule.providesHttpLoggingInterceptor$lambda$0(str);
            }
        });
        httpLoggingInterceptor.setLevel(HttpLoggingInterceptor.Level.NONE);
        httpLoggingInterceptor.redactHeader("Authorization");
        return httpLoggingInterceptor;
    }

    @Provides
    @GuideKitScope
    public final HeaderInterceptor providesHeaderInterceptor(LocaleProvider localeProvider) {
        Intrinsics.checkNotNullParameter(localeProvider, "localeProvider");
        return new HeaderInterceptor(SetsKt.setOf((Object[]) new Pair[]{TuplesKt.m25to(HttpHeaders.ACCEPT, new C12501(null)), TuplesKt.m25to("Content-Type", new C12512(null)), TuplesKt.m25to(HttpHeaders.ACCEPT_LANGUAGE, new C12523(localeProvider, null)), TuplesKt.m25to("User-Agent", new C12534(null)), TuplesKt.m25to("X-Zendesk-Client", new C12545(null)), TuplesKt.m25to("X-Zendesk-Client-Version", new C12556(null))}));
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0010\u000e\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", ""}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.guidekit.android.internal.di.module.NetworkModule$providesHeaderInterceptor$1", m37f = "NetworkModule.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C12501 extends SuspendLambda implements Function1<Continuation<? super String>, Object> {
        int label;

        C12501(Continuation<? super C12501> continuation) {
            super(1, continuation);
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return new C12501(continuation);
        }

        @Override
        public final Object invoke(Continuation<? super String> continuation) {
            return ((C12501) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            return "application/json";
        }
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0010\u000e\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", ""}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.guidekit.android.internal.di.module.NetworkModule$providesHeaderInterceptor$2", m37f = "NetworkModule.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C12512 extends SuspendLambda implements Function1<Continuation<? super String>, Object> {
        int label;

        C12512(Continuation<? super C12512> continuation) {
            super(1, continuation);
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return new C12512(continuation);
        }

        @Override
        public final Object invoke(Continuation<? super String> continuation) {
            return ((C12512) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            return "application/json";
        }
    }

    @Metadata(m17d1 = {"\u0000\b\n\u0000\n\u0002\u0010\u000e\n\u0000\u0010\u0000\u001a\n \u0002*\u0004\u0018\u00010\u00010\u0001H\u008a@"}, m18d2 = {"<anonymous>", "", "kotlin.jvm.PlatformType"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.guidekit.android.internal.di.module.NetworkModule$providesHeaderInterceptor$3", m37f = "NetworkModule.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C12523 extends SuspendLambda implements Function1<Continuation<? super String>, Object> {
        final LocaleProvider $localeProvider;
        int label;

        C12523(LocaleProvider localeProvider, Continuation<? super C12523> continuation) {
            super(1, continuation);
            this.$localeProvider = localeProvider;
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return new C12523(this.$localeProvider, continuation);
        }

        @Override
        public final Object invoke(Continuation<? super String> continuation) {
            return ((C12523) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            return this.$localeProvider.getLocale().toLanguageTag();
        }
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0010\u000e\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", ""}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.guidekit.android.internal.di.module.NetworkModule$providesHeaderInterceptor$4", m37f = "NetworkModule.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C12534 extends SuspendLambda implements Function1<Continuation<? super String>, Object> {
        int label;

        C12534(Continuation<? super C12534> continuation) {
            super(1, continuation);
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return new C12534(continuation);
        }

        @Override
        public final Object invoke(Continuation<? super String> continuation) {
            return ((C12534) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            String str = String.format("Zendesk-SDK/%s Android/%s Variant/Messaging", Arrays.copyOf(new Object[]{BuildConfig.VERSION_NAME, Build.VERSION.RELEASE}, 2));
            Intrinsics.checkNotNullExpressionValue(str, "format(...)");
            return str;
        }
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0010\u000e\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", ""}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.guidekit.android.internal.di.module.NetworkModule$providesHeaderInterceptor$5", m37f = "NetworkModule.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C12545 extends SuspendLambda implements Function1<Continuation<? super String>, Object> {
        int label;

        C12545(Continuation<? super C12545> continuation) {
            super(1, continuation);
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return new C12545(continuation);
        }

        @Override
        public final Object invoke(Continuation<? super String> continuation) {
            return ((C12545) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            return "mobile/android/sdk/messaging";
        }
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0010\u000e\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", ""}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.guidekit.android.internal.di.module.NetworkModule$providesHeaderInterceptor$6", m37f = "NetworkModule.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C12556 extends SuspendLambda implements Function1<Continuation<? super String>, Object> {
        int label;

        C12556(Continuation<? super C12556> continuation) {
            super(1, continuation);
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return new C12556(continuation);
        }

        @Override
        public final Object invoke(Continuation<? super String> continuation) {
            return ((C12556) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            return BuildConfig.VERSION_NAME;
        }
    }

    @Provides
    @GuideKitScope
    public final OkHttpClient providesOkHttpClient(HttpLoggingInterceptor loggingInterceptor, HeaderInterceptor headerInterceptor, File cacheDir) {
        Intrinsics.checkNotNullParameter(loggingInterceptor, "loggingInterceptor");
        Intrinsics.checkNotNullParameter(headerInterceptor, "headerInterceptor");
        Intrinsics.checkNotNullParameter(cacheDir, "cacheDir");
        return new OkHttpClient.Builder().addInterceptor(loggingInterceptor).addInterceptor(headerInterceptor).cache(new Cache(cacheDir, 20971520L)).build();
    }

    @Provides
    @GuideKitScope
    public final Converter.Factory provideKotlinSerialization(Json json) {
        Intrinsics.checkNotNullParameter(json, "json");
        return KotlinSerializationConverterFactory.create(json, MediaType.INSTANCE.get("application/json"));
    }

    @Provides
    @GuideKitScope
    public final Retrofit retrofit(@Named("baseUrl") String baseUrl, OkHttpClient okHttpClient, Converter.Factory converterFactory) {
        Intrinsics.checkNotNullParameter(baseUrl, "baseUrl");
        Intrinsics.checkNotNullParameter(okHttpClient, "okHttpClient");
        Intrinsics.checkNotNullParameter(converterFactory, "converterFactory");
        Retrofit retrofitBuild = new Retrofit.Builder().baseUrl(baseUrl).client(okHttpClient).addConverterFactory(converterFactory).build();
        Intrinsics.checkNotNullExpressionValue(retrofitBuild, "build(...)");
        return retrofitBuild;
    }
}
