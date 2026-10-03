package zendesk.messaging.android.internal.rest;

import android.os.Build;
import cz.msebera.android.httpclient.HttpHeaders;
import java.util.Arrays;
import javax.inject.Inject;
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
import okhttp3.logging.HttpLoggingInterceptor;
import zendesk.core.p017ui.android.internal.local.LocaleProvider;
import zendesk.messaging.BuildConfig;
import zendesk.okhttp.HeaderInterceptor;

@Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u0000 \r2\u00020\u0001:\u0001\rB\u000f\b\u0001\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u0006\u0010\n\u001a\u00020\u000bJ\u0006\u0010\b\u001a\u00020\fR\u0016\u0010\u0005\u001a\n \u0007*\u0004\u0018\u00010\u00060\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u000e"}, m18d2 = {"Lzendesk/messaging/android/internal/rest/HeaderFactory;", "", "localeProvider", "Lzendesk/core/ui/android/internal/local/LocaleProvider;", "(Lzendesk/core/ui/android/internal/local/LocaleProvider;)V", "localeString", "", "kotlin.jvm.PlatformType", "loggingInterceptor", "Lokhttp3/logging/HttpLoggingInterceptor;", "createHeaderInterceptor", "Lzendesk/okhttp/HeaderInterceptor;", "Lokhttp3/Interceptor;", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class HeaderFactory {
    public static final String CLIENT = "mobile/android/sdk/messaging";
    public static final String CONTENT_TYPE = "application/json";
    public static final String USER_AGENT = "Zendesk-SDK/%s Android/%s Variant/Messaging";
    private final String localeString;
    private final HttpLoggingInterceptor loggingInterceptor;

    @Inject
    public HeaderFactory(LocaleProvider localeProvider) {
        Intrinsics.checkNotNullParameter(localeProvider, "localeProvider");
        this.localeString = localeProvider.getLocale().toLanguageTag();
        HttpLoggingInterceptor httpLoggingInterceptor = new HttpLoggingInterceptor(null, 1, 0 == true ? 1 : 0);
        httpLoggingInterceptor.setLevel(HttpLoggingInterceptor.Level.NONE);
        httpLoggingInterceptor.redactHeader("Authorization");
        this.loggingInterceptor = httpLoggingInterceptor;
    }

    public final HeaderInterceptor createHeaderInterceptor() {
        return new HeaderInterceptor(SetsKt.setOf((Object[]) new Pair[]{TuplesKt.m25to(HttpHeaders.ACCEPT, new C15201(null)), TuplesKt.m25to("Content-Type", new C15212(null)), TuplesKt.m25to(HttpHeaders.ACCEPT_LANGUAGE, new C15223(null)), TuplesKt.m25to("User-Agent", new C15234(null)), TuplesKt.m25to("X-Zendesk-Client", new C15245(null)), TuplesKt.m25to("X-Zendesk-Client-Version", new C15256(null))}));
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0010\u000e\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", ""}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.rest.HeaderFactory$createHeaderInterceptor$1", m37f = "HeaderFactory.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C15201 extends SuspendLambda implements Function1<Continuation<? super String>, Object> {
        int label;

        C15201(Continuation<? super C15201> continuation) {
            super(1, continuation);
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return new C15201(continuation);
        }

        @Override
        public final Object invoke(Continuation<? super String> continuation) {
            return ((C15201) create(continuation)).invokeSuspend(Unit.INSTANCE);
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
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.rest.HeaderFactory$createHeaderInterceptor$2", m37f = "HeaderFactory.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C15212 extends SuspendLambda implements Function1<Continuation<? super String>, Object> {
        int label;

        C15212(Continuation<? super C15212> continuation) {
            super(1, continuation);
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return new C15212(continuation);
        }

        @Override
        public final Object invoke(Continuation<? super String> continuation) {
            return ((C15212) create(continuation)).invokeSuspend(Unit.INSTANCE);
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
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.rest.HeaderFactory$createHeaderInterceptor$3", m37f = "HeaderFactory.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C15223 extends SuspendLambda implements Function1<Continuation<? super String>, Object> {
        int label;

        C15223(Continuation<? super C15223> continuation) {
            super(1, continuation);
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return HeaderFactory.this.new C15223(continuation);
        }

        @Override
        public final Object invoke(Continuation<? super String> continuation) {
            return ((C15223) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            return HeaderFactory.this.localeString;
        }
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0010\u000e\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", ""}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.rest.HeaderFactory$createHeaderInterceptor$4", m37f = "HeaderFactory.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C15234 extends SuspendLambda implements Function1<Continuation<? super String>, Object> {
        int label;

        C15234(Continuation<? super C15234> continuation) {
            super(1, continuation);
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return new C15234(continuation);
        }

        @Override
        public final Object invoke(Continuation<? super String> continuation) {
            return ((C15234) create(continuation)).invokeSuspend(Unit.INSTANCE);
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
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.rest.HeaderFactory$createHeaderInterceptor$5", m37f = "HeaderFactory.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C15245 extends SuspendLambda implements Function1<Continuation<? super String>, Object> {
        int label;

        C15245(Continuation<? super C15245> continuation) {
            super(1, continuation);
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return new C15245(continuation);
        }

        @Override
        public final Object invoke(Continuation<? super String> continuation) {
            return ((C15245) create(continuation)).invokeSuspend(Unit.INSTANCE);
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
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.rest.HeaderFactory$createHeaderInterceptor$6", m37f = "HeaderFactory.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C15256 extends SuspendLambda implements Function1<Continuation<? super String>, Object> {
        int label;

        C15256(Continuation<? super C15256> continuation) {
            super(1, continuation);
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return new C15256(continuation);
        }

        @Override
        public final Object invoke(Continuation<? super String> continuation) {
            return ((C15256) create(continuation)).invokeSuspend(Unit.INSTANCE);
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

    public final Interceptor loggingInterceptor() {
        return this.loggingInterceptor;
    }
}
