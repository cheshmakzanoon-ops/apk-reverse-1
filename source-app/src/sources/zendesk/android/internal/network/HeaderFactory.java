package zendesk.android.internal.network;

import cz.msebera.android.httpclient.HttpHeaders;
import javax.inject.Inject;
import javax.inject.Singleton;
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
import okhttp3.Interceptor;
import zendesk.android.internal.ZendeskLoggingInterceptor;
import zendesk.android.internal.p013di.ZendeskComponentConfig;
import zendesk.core.p017ui.android.internal.local.LocaleProvider;
import zendesk.okhttp.HeaderInterceptor;

@Singleton
@Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0001\u0018\u00002\u00020\u0001B\u001f\b\u0001\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ\u0006\u0010\u000b\u001a\u00020\fJ\u0006\u0010\t\u001a\u00020\rR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u000e"}, m18d2 = {"Lzendesk/android/internal/network/HeaderFactory;", "", "componentConfig", "Lzendesk/android/internal/di/ZendeskComponentConfig;", "networkData", "Lzendesk/android/internal/network/NetworkData;", "localeProvider", "Lzendesk/core/ui/android/internal/local/LocaleProvider;", "(Lzendesk/android/internal/di/ZendeskComponentConfig;Lzendesk/android/internal/network/NetworkData;Lzendesk/core/ui/android/internal/local/LocaleProvider;)V", "loggingInterceptor", "Lzendesk/android/internal/ZendeskLoggingInterceptor;", "createHeaderInterceptor", "Lzendesk/okhttp/HeaderInterceptor;", "Lokhttp3/Interceptor;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class HeaderFactory {
    private final ZendeskComponentConfig componentConfig;
    private final LocaleProvider localeProvider;
    private final ZendeskLoggingInterceptor loggingInterceptor;
    private final NetworkData networkData;

    @Inject
    public HeaderFactory(ZendeskComponentConfig componentConfig, NetworkData networkData, LocaleProvider localeProvider) {
        Intrinsics.checkNotNullParameter(componentConfig, "componentConfig");
        Intrinsics.checkNotNullParameter(networkData, "networkData");
        Intrinsics.checkNotNullParameter(localeProvider, "localeProvider");
        this.componentConfig = componentConfig;
        this.networkData = networkData;
        this.localeProvider = localeProvider;
        this.loggingInterceptor = new ZendeskLoggingInterceptor();
    }

    public final HeaderInterceptor createHeaderInterceptor() {
        return new HeaderInterceptor(SetsKt.setOf((Object[]) new Pair[]{TuplesKt.m25to(HttpHeaders.ACCEPT, new C09561(null)), TuplesKt.m25to("Content-Type", new C09572(null)), TuplesKt.m25to(HttpHeaders.ACCEPT_LANGUAGE, new C09583(null)), TuplesKt.m25to("User-Agent", new C09594(null)), TuplesKt.m25to("X-Zendesk-Client", new C09605(null)), TuplesKt.m25to("X-Zendesk-Client-Version", new C09616(null))}));
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0010\u000e\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", ""}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.internal.network.HeaderFactory$createHeaderInterceptor$1", m37f = "HeaderFactory.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C09561 extends SuspendLambda implements Function1<Continuation<? super String>, Object> {
        int label;

        C09561(Continuation<? super C09561> continuation) {
            super(1, continuation);
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return new C09561(continuation);
        }

        @Override
        public final Object invoke(Continuation<? super String> continuation) {
            return ((C09561) create(continuation)).invokeSuspend(Unit.INSTANCE);
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
    @DebugMetadata(m36c = "zendesk.android.internal.network.HeaderFactory$createHeaderInterceptor$2", m37f = "HeaderFactory.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C09572 extends SuspendLambda implements Function1<Continuation<? super String>, Object> {
        int label;

        C09572(Continuation<? super C09572> continuation) {
            super(1, continuation);
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return new C09572(continuation);
        }

        @Override
        public final Object invoke(Continuation<? super String> continuation) {
            return ((C09572) create(continuation)).invokeSuspend(Unit.INSTANCE);
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
    @DebugMetadata(m36c = "zendesk.android.internal.network.HeaderFactory$createHeaderInterceptor$3", m37f = "HeaderFactory.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C09583 extends SuspendLambda implements Function1<Continuation<? super String>, Object> {
        int label;

        C09583(Continuation<? super C09583> continuation) {
            super(1, continuation);
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return HeaderFactory.this.new C09583(continuation);
        }

        @Override
        public final Object invoke(Continuation<? super String> continuation) {
            return ((C09583) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            return HeaderFactory.this.localeProvider.getLocale().toLanguageTag();
        }
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0010\u000e\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", ""}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.internal.network.HeaderFactory$createHeaderInterceptor$4", m37f = "HeaderFactory.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C09594 extends SuspendLambda implements Function1<Continuation<? super String>, Object> {
        int label;

        C09594(Continuation<? super C09594> continuation) {
            super(1, continuation);
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return HeaderFactory.this.new C09594(continuation);
        }

        @Override
        public final Object invoke(Continuation<? super String> continuation) {
            return ((C09594) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            return HeaderFactory.this.networkData.userAgent();
        }
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0010\u000e\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", ""}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.internal.network.HeaderFactory$createHeaderInterceptor$5", m37f = "HeaderFactory.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C09605 extends SuspendLambda implements Function1<Continuation<? super String>, Object> {
        int label;

        C09605(Continuation<? super C09605> continuation) {
            super(1, continuation);
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return new C09605(continuation);
        }

        @Override
        public final Object invoke(Continuation<? super String> continuation) {
            return ((C09605) create(continuation)).invokeSuspend(Unit.INSTANCE);
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
    @DebugMetadata(m36c = "zendesk.android.internal.network.HeaderFactory$createHeaderInterceptor$6", m37f = "HeaderFactory.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C09616 extends SuspendLambda implements Function1<Continuation<? super String>, Object> {
        int label;

        C09616(Continuation<? super C09616> continuation) {
            super(1, continuation);
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return HeaderFactory.this.new C09616(continuation);
        }

        @Override
        public final Object invoke(Continuation<? super String> continuation) {
            return ((C09616) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            return HeaderFactory.this.componentConfig.getVersionName();
        }
    }

    public final Interceptor loggingInterceptor() {
        return this.loggingInterceptor;
    }
}
