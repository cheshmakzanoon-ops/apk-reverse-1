package zendesk.guidekit.android.internal;

import javax.inject.Inject;
import kotlin.Metadata;
import kotlin.Result;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.android.internal.StringKtxKt;
import zendesk.guidekit.android.GuideKit;
import zendesk.guidekit.android.internal.data.GuideKitRepository;
import zendesk.guidekit.android.model.Brand;
import zendesk.guidekit.android.model.GuideArticle;
import zendesk.guidekit.android.model.GuideArticleUrl;
import zendesk.guidekit.android.model.GuideLocale;

@Metadata(m17d1 = {"\u0000F\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\t\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\b\u0000\u0018\u00002\u00020\u0001B\u000f\b\u0007\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J4\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00070\u00062\u0006\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\rH\u0096@ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b\u000e\u0010\u000fJ$\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\u00110\u00062\u0006\u0010\b\u001a\u00020\tH\u0096@ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b\u0012\u0010\u0013J\u0016\u0010\u0014\u001a\u00020\u00152\u0006\u0010\b\u001a\u00020\tH\u0096@¢\u0006\u0002\u0010\u0013J4\u0010\u0016\u001a\b\u0012\u0004\u0012\u00020\u00170\u00062\u0006\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\rH\u0096@ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b\u0018\u0010\u000fR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000\u0082\u0002\u000b\n\u0002\b!\n\u0005\b¡\u001e0\u0001¨\u0006\u0019"}, m18d2 = {"Lzendesk/guidekit/android/internal/DefaultGuideKit;", "Lzendesk/guidekit/android/GuideKit;", "guideKitRepository", "Lzendesk/guidekit/android/internal/data/GuideKitRepository;", "(Lzendesk/guidekit/android/internal/data/GuideKitRepository;)V", "getArticle", "Lkotlin/Result;", "Lzendesk/guidekit/android/model/GuideArticle;", "url", "", "articleId", "", "guideLocale", "Lzendesk/guidekit/android/model/GuideLocale;", "getArticle-BWLJW6A", "(Ljava/lang/String;JLzendesk/guidekit/android/model/GuideLocale;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getGuideArticleLink", "Lzendesk/guidekit/android/model/GuideArticleUrl;", "getGuideArticleLink-gIAlu-s", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "isValidGuideUrl", "", "sendArticleStatsView", "", "sendArticleStatsView-BWLJW6A", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class DefaultGuideKit implements GuideKit {
    private final GuideKitRepository guideKitRepository;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.guidekit.android.internal.DefaultGuideKit", m37f = "DefaultGuideKit.kt", m38i = {0}, m39l = {86}, m40m = "isValidGuideUrl", m41n = {"url"}, m42s = {"L$0"})
    static final class C12441 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C12441(Continuation<? super C12441> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return DefaultGuideKit.this.isValidGuideUrl(null, this);
        }
    }

    @Inject
    public DefaultGuideKit(GuideKitRepository guideKitRepository) {
        Intrinsics.checkNotNullParameter(guideKitRepository, "guideKitRepository");
        this.guideKitRepository = guideKitRepository;
    }

    @Override
    public Object mo2113sendArticleStatsViewBWLJW6A(String str, long j, GuideLocale guideLocale, Continuation<? super Result<Unit>> continuation) throws Throwable {
        DefaultGuideKit$sendArticleStatsView$1 defaultGuideKit$sendArticleStatsView$1;
        if (continuation instanceof DefaultGuideKit$sendArticleStatsView$1) {
            defaultGuideKit$sendArticleStatsView$1 = (DefaultGuideKit$sendArticleStatsView$1) continuation;
            if ((defaultGuideKit$sendArticleStatsView$1.label & Integer.MIN_VALUE) != 0) {
                defaultGuideKit$sendArticleStatsView$1.label -= Integer.MIN_VALUE;
            } else {
                defaultGuideKit$sendArticleStatsView$1 = new DefaultGuideKit$sendArticleStatsView$1(this, continuation);
            }
        } else {
            defaultGuideKit$sendArticleStatsView$1 = new DefaultGuideKit$sendArticleStatsView$1(this, continuation);
        }
        DefaultGuideKit$sendArticleStatsView$1 defaultGuideKit$sendArticleStatsView$2 = defaultGuideKit$sendArticleStatsView$1;
        Object obj = defaultGuideKit$sendArticleStatsView$2.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = defaultGuideKit$sendArticleStatsView$2.label;
        if (i != 0) {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            return ((Result) obj).getValue();
        }
        ResultKt.throwOnFailure(obj);
        String url = StringKtxKt.parseUrl(str);
        GuideKitRepository guideKitRepository = this.guideKitRepository;
        defaultGuideKit$sendArticleStatsView$2.label = 1;
        Object objM2116sendArticleStatsViewBWLJW6A = guideKitRepository.m2116sendArticleStatsViewBWLJW6A(j, guideLocale, url, defaultGuideKit$sendArticleStatsView$2);
        return objM2116sendArticleStatsViewBWLJW6A == coroutine_suspended ? coroutine_suspended : objM2116sendArticleStatsViewBWLJW6A;
    }

    @Override
    public Object mo2111getArticleBWLJW6A(String str, long j, GuideLocale guideLocale, Continuation<? super Result<GuideArticle>> continuation) throws Throwable {
        DefaultGuideKit$getArticle$1 defaultGuideKit$getArticle$1;
        if (continuation instanceof DefaultGuideKit$getArticle$1) {
            defaultGuideKit$getArticle$1 = (DefaultGuideKit$getArticle$1) continuation;
            if ((defaultGuideKit$getArticle$1.label & Integer.MIN_VALUE) != 0) {
                defaultGuideKit$getArticle$1.label -= Integer.MIN_VALUE;
            } else {
                defaultGuideKit$getArticle$1 = new DefaultGuideKit$getArticle$1(this, continuation);
            }
        } else {
            defaultGuideKit$getArticle$1 = new DefaultGuideKit$getArticle$1(this, continuation);
        }
        DefaultGuideKit$getArticle$1 defaultGuideKit$getArticle$2 = defaultGuideKit$getArticle$1;
        Object obj = defaultGuideKit$getArticle$2.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = defaultGuideKit$getArticle$2.label;
        if (i != 0) {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            return ((Result) obj).getValue();
        }
        ResultKt.throwOnFailure(obj);
        String url = StringKtxKt.parseUrl(str);
        GuideKitRepository guideKitRepository = this.guideKitRepository;
        defaultGuideKit$getArticle$2.label = 1;
        Object objM2115getArticleBWLJW6A = guideKitRepository.m2115getArticleBWLJW6A(j, guideLocale, url, defaultGuideKit$getArticle$2);
        return objM2115getArticleBWLJW6A == coroutine_suspended ? coroutine_suspended : objM2115getArticleBWLJW6A;
    }

    @Override
    public Object mo2112getGuideArticleLinkgIAlus(String str, Continuation<? super Result<GuideArticleUrl>> continuation) {
        try {
            Result.Companion companion = Result.INSTANCE;
            return Result.m296constructorimpl(GuideArticleUrl.INSTANCE.from(str));
        } catch (Exception e) {
            Result.Companion companion2 = Result.INSTANCE;
            return Result.m296constructorimpl(ResultKt.createFailure(e));
        }
    }

    @Override
    public Object isValidGuideUrl(String str, Continuation<? super Boolean> continuation) throws Throwable {
        C12441 c12441;
        Object objM2114fetchBrandFromInMemoryIoAF18A;
        if (continuation instanceof C12441) {
            c12441 = (C12441) continuation;
            if ((c12441.label & Integer.MIN_VALUE) != 0) {
                c12441.label -= Integer.MIN_VALUE;
            } else {
                c12441 = new C12441(continuation);
            }
        } else {
            c12441 = new C12441(continuation);
        }
        Object obj = c12441.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c12441.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            GuideKitRepository guideKitRepository = this.guideKitRepository;
            c12441.L$0 = str;
            c12441.label = 1;
            objM2114fetchBrandFromInMemoryIoAF18A = guideKitRepository.m2114fetchBrandFromInMemoryIoAF18A(c12441);
            if (objM2114fetchBrandFromInMemoryIoAF18A == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            str = (String) c12441.L$0;
            ResultKt.throwOnFailure(obj);
            objM2114fetchBrandFromInMemoryIoAF18A = ((Result) obj).getValue();
        }
        if (Result.m299exceptionOrNullimpl(objM2114fetchBrandFromInMemoryIoAF18A) != null) {
            return Boxing.boxBoolean(false);
        }
        return Boxing.boxBoolean(GuideArticleUrl.INSTANCE.isValidGuideUrl(str, ((Brand) objM2114fetchBrandFromInMemoryIoAF18A).getHostMapping()));
    }
}
