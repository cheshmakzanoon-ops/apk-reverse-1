package zendesk.conversationkit.android.internal.rest;

import java.io.File;
import java.util.Iterator;
import java.util.Set;
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
import kotlin.text.StringsKt;
import okhttp3.Cache;
import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Converter;
import retrofit2.Retrofit;
import zendesk.faye.internal.Bayeux;
import zendesk.logger.Logger;
import zendesk.okhttp.HeaderInterceptor;

@Metadata(m17d1 = {"\u0000h\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\"\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0000\u0018\u0000 %2\u00020\u0001:\u0001%BO\u00120\u0010\u0002\u001a,\u0012(\u0012&\u0012\u0004\u0012\u00020\u0005\u0012\u001c\u0012\u001a\b\u0001\u0012\f\u0012\n\u0012\u0006\u0012\u0004\u0018\u00010\u00050\u0007\u0012\u0006\u0012\u0004\u0018\u00010\u00010\u00060\u00040\u0003\u0012\u0006\u0010\b\u001a\u00020\t\u0012\u0006\u0010\n\u001a\u00020\u000b\u0012\u0006\u0010\f\u001a\u00020\r¢\u0006\u0002\u0010\u000eJ\u0016\u0010\u000f\u001a\u00020\u00102\f\u0010\u0011\u001a\b\u0012\u0004\u0012\u00020\u00120\u0003H\u0002J\u0018\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u00052\u0006\u0010\u0016\u001a\u00020\u0010H\u0002J\u0016\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u00052\u0006\u0010\u0015\u001a\u00020\u0005J\u0010\u0010\u001a\u001a\u00020\u001b2\u0006\u0010\u001c\u001a\u00020\u0005H\u0002JD\u0010\u001d\u001a\u00020\u001e2\u0006\u0010\u0015\u001a\u00020\u000522\b\u0002\u0010\u001f\u001a,\u0012(\u0012&\u0012\u0004\u0012\u00020\u0005\u0012\u001c\u0012\u001a\b\u0001\u0012\f\u0012\n\u0012\u0006\u0012\u0004\u0018\u00010\u00050\u0007\u0012\u0006\u0012\u0004\u0018\u00010\u00010\u00060\u00040\u0003H\u0002J.\u0010 \u001a\u00020!2\u0006\u0010\u0019\u001a\u00020\u00052\u0006\u0010\"\u001a\u00020\u00052\u0006\u0010\u0015\u001a\u00020\u00052\u0006\u0010#\u001a\u00020\u00052\u0006\u0010$\u001a\u00020\u0005R\u000e\u0010\n\u001a\u00020\u000bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R8\u0010\u0002\u001a,\u0012(\u0012&\u0012\u0004\u0012\u00020\u0005\u0012\u001c\u0012\u001a\b\u0001\u0012\f\u0012\n\u0012\u0006\u0012\u0004\u0018\u00010\u00050\u0007\u0012\u0006\u0012\u0004\u0018\u00010\u00010\u00060\u00040\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006&"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/RestClientFactory;", "", "defaultHeaders", "", "Lkotlin/Pair;", "", "Lkotlin/Function1;", "Lkotlin/coroutines/Continuation;", "restClientFiles", "Lzendesk/conversationkit/android/internal/rest/RestClientFiles;", "cacheDir", "Ljava/io/File;", "converterFactory", "Lretrofit2/Converter$Factory;", "(Ljava/util/Set;Lzendesk/conversationkit/android/internal/rest/RestClientFiles;Ljava/io/File;Lretrofit2/Converter$Factory;)V", "buildOkHttpClient", "Lokhttp3/OkHttpClient;", "interceptors", "Lokhttp3/Interceptor;", "buildRetrofit", "Lretrofit2/Retrofit;", "baseUrl", "okHttpClient", "createAppRestClient", "Lzendesk/conversationkit/android/internal/rest/AppRestClient;", "appId", "createEndUserExpectationsApi", "Lzendesk/conversationkit/android/internal/rest/EndUserExpectationsApi;", "baseUrlWithoutPath", "createSunshineConversationsApi", "Lzendesk/conversationkit/android/internal/rest/SunshineConversationsApi;", "headers", "createUserRestClient", "Lzendesk/conversationkit/android/internal/rest/UserRestClient;", "appUserId", "settingsBaseUrl", Bayeux.KEY_CLIENT_ID, "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class RestClientFactory {
    private static final long CACHE_SIZE = 20971520;
    private final File cacheDir;
    private final Converter.Factory converterFactory;
    private final Set<Pair<String, Function1<Continuation<? super String>, Object>>> defaultHeaders;
    private final RestClientFiles restClientFiles;

    public RestClientFactory(Set<? extends Pair<String, ? extends Function1<? super Continuation<? super String>, ? extends Object>>> defaultHeaders, RestClientFiles restClientFiles, File cacheDir, Converter.Factory converterFactory) {
        Intrinsics.checkNotNullParameter(defaultHeaders, "defaultHeaders");
        Intrinsics.checkNotNullParameter(restClientFiles, "restClientFiles");
        Intrinsics.checkNotNullParameter(cacheDir, "cacheDir");
        Intrinsics.checkNotNullParameter(converterFactory, "converterFactory");
        this.defaultHeaders = defaultHeaders;
        this.restClientFiles = restClientFiles;
        this.cacheDir = cacheDir;
        this.converterFactory = converterFactory;
    }

    public final AppRestClient createAppRestClient(String appId, String baseUrl) {
        Intrinsics.checkNotNullParameter(appId, "appId");
        Intrinsics.checkNotNullParameter(baseUrl, "baseUrl");
        return new AppRestClient(appId, createSunshineConversationsApi(baseUrl, SetsKt.setOf(TuplesKt.m25to("x-smooch-appid", new C10871(appId, null)))));
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0010\u000e\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", ""}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.rest.RestClientFactory$createAppRestClient$1", m37f = "RestClientFactory.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10871 extends SuspendLambda implements Function1<Continuation<? super String>, Object> {
        final String $appId;
        int label;

        C10871(String str, Continuation<? super C10871> continuation) {
            super(1, continuation);
            this.$appId = str;
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return new C10871(this.$appId, continuation);
        }

        @Override
        public final Object invoke(Continuation<? super String> continuation) {
            return ((C10871) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            return this.$appId;
        }
    }

    public final UserRestClient createUserRestClient(String appId, String appUserId, String baseUrl, String settingsBaseUrl, String clientId) {
        Intrinsics.checkNotNullParameter(appId, "appId");
        Intrinsics.checkNotNullParameter(appUserId, "appUserId");
        Intrinsics.checkNotNullParameter(baseUrl, "baseUrl");
        Intrinsics.checkNotNullParameter(settingsBaseUrl, "settingsBaseUrl");
        Intrinsics.checkNotNullParameter(clientId, "clientId");
        return new UserRestClient(appId, appUserId, createSunshineConversationsApi(baseUrl, SetsKt.setOf((Object[]) new Pair[]{TuplesKt.m25to("x-smooch-appid", new C10881(appId, null)), TuplesKt.m25to("x-smooch-clientid", new C10892(clientId, null))})), createEndUserExpectationsApi(settingsBaseUrl), this.restClientFiles);
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0010\u000e\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", ""}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.rest.RestClientFactory$createUserRestClient$1", m37f = "RestClientFactory.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10881 extends SuspendLambda implements Function1<Continuation<? super String>, Object> {
        final String $appId;
        int label;

        C10881(String str, Continuation<? super C10881> continuation) {
            super(1, continuation);
            this.$appId = str;
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return new C10881(this.$appId, continuation);
        }

        @Override
        public final Object invoke(Continuation<? super String> continuation) {
            return ((C10881) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            return this.$appId;
        }
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0010\u000e\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", ""}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.rest.RestClientFactory$createUserRestClient$2", m37f = "RestClientFactory.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10892 extends SuspendLambda implements Function1<Continuation<? super String>, Object> {
        final String $clientId;
        int label;

        C10892(String str, Continuation<? super C10892> continuation) {
            super(1, continuation);
            this.$clientId = str;
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return new C10892(this.$clientId, continuation);
        }

        @Override
        public final Object invoke(Continuation<? super String> continuation) {
            return ((C10892) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            return this.$clientId;
        }
    }

    static SunshineConversationsApi createSunshineConversationsApi$default(RestClientFactory restClientFactory, String str, Set set, int i, Object obj) {
        if ((i & 2) != 0) {
            set = SetsKt.emptySet();
        }
        return restClientFactory.createSunshineConversationsApi(str, set);
    }

    public static final void createSunshineConversationsApi$lambda$0(String it) {
        Intrinsics.checkNotNullParameter(it, "it");
        Logger.m221i("HttpLoggingInterceptor", it, new Object[0]);
    }

    private final SunshineConversationsApi createSunshineConversationsApi(String baseUrl, Set<? extends Pair<String, ? extends Function1<? super Continuation<? super String>, ? extends Object>>> headers) {
        HttpLoggingInterceptor httpLoggingInterceptor = new HttpLoggingInterceptor(new HttpLoggingInterceptor.Logger() {
            @Override
            public final void log(String str) {
                RestClientFactory.createSunshineConversationsApi$lambda$0(str);
            }
        });
        httpLoggingInterceptor.setLevel(HttpLoggingInterceptor.Level.NONE);
        httpLoggingInterceptor.redactHeader("Authorization");
        Object objCreate = buildRetrofit(baseUrl, buildOkHttpClient(SetsKt.setOf((Object[]) new Interceptor[]{new HeaderInterceptor(SetsKt.plus((Set) this.defaultHeaders, (Iterable) headers)), httpLoggingInterceptor}))).create(SunshineConversationsApi.class);
        Intrinsics.checkNotNullExpressionValue(objCreate, "create(...)");
        return (SunshineConversationsApi) objCreate;
    }

    public static final void createEndUserExpectationsApi$lambda$2(String it) {
        Intrinsics.checkNotNullParameter(it, "it");
        Logger.m221i("HttpLoggingInterceptor", it, new Object[0]);
    }

    private final EndUserExpectationsApi createEndUserExpectationsApi(String baseUrlWithoutPath) {
        HttpLoggingInterceptor httpLoggingInterceptor = new HttpLoggingInterceptor(new HttpLoggingInterceptor.Logger() {
            @Override
            public final void log(String str) {
                RestClientFactory.createEndUserExpectationsApi$lambda$2(str);
            }
        });
        httpLoggingInterceptor.setLevel(HttpLoggingInterceptor.Level.NONE);
        httpLoggingInterceptor.redactHeader("Authorization");
        Object objCreate = buildRetrofit(baseUrlWithoutPath, buildOkHttpClient(SetsKt.setOf((Object[]) new Interceptor[]{new HeaderInterceptor(this.defaultHeaders), httpLoggingInterceptor}))).create(EndUserExpectationsApi.class);
        Intrinsics.checkNotNullExpressionValue(objCreate, "create(...)");
        return (EndUserExpectationsApi) objCreate;
    }

    private final OkHttpClient buildOkHttpClient(Set<? extends Interceptor> interceptors) {
        OkHttpClient.Builder builder = new OkHttpClient.Builder();
        Iterator<? extends Interceptor> it = interceptors.iterator();
        while (it.hasNext()) {
            builder.addInterceptor(it.next());
        }
        builder.cache(new Cache(this.cacheDir, 20971520L));
        return builder.build();
    }

    private final Retrofit buildRetrofit(String baseUrl, OkHttpClient okHttpClient) {
        if (!StringsKt.endsWith$default(baseUrl, "/", false, 2, (Object) null)) {
            baseUrl = baseUrl + '/';
        }
        Retrofit retrofitBuild = new Retrofit.Builder().baseUrl(baseUrl).client(okHttpClient).addConverterFactory(this.converterFactory).build();
        Intrinsics.checkNotNullExpressionValue(retrofitBuild, "build(...)");
        return retrofitBuild;
    }
}
