package zendesk.guidekit.android.internal.data;

import java.util.concurrent.CancellationException;
import javax.inject.Inject;
import kotlin.Metadata;
import kotlin.Result;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt__Builders_commonKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.Job;
import kotlinx.coroutines.SupervisorKt;
import zendesk.guidekit.android.exception.BrandNotFoundException;
import zendesk.guidekit.android.internal.rest.BrandsApi;
import zendesk.guidekit.android.internal.rest.HelpCenterApi;
import zendesk.guidekit.android.model.Brand;
import zendesk.guidekit.android.model.GuideArticle;
import zendesk.guidekit.android.model.GuideKitSettings;
import zendesk.guidekit.android.model.GuideLocale;

@Metadata(m17d1 = {"\u0000d\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\t\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0003\b\u0000\u0018\u0000 #2\u00020\u0001:\u0001#B7\b\u0007\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\u0006\u0010\n\u001a\u00020\u000b\u0012\u0006\u0010\f\u001a\u00020\r¢\u0006\u0002\u0010\u000eJ\u001c\u0010\u0011\u001a\b\u0012\u0004\u0012\u00020\u00130\u0012H\u0086@ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b\u0014\u0010\u0015J4\u0010\u0016\u001a\b\u0012\u0004\u0012\u00020\u00170\u00122\u0006\u0010\u0018\u001a\u00020\u00192\u0006\u0010\u001a\u001a\u00020\u001b2\u0006\u0010\u001c\u001a\u00020\u001dH\u0086@ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b\u001e\u0010\u001fJ4\u0010 \u001a\b\u0012\u0004\u0012\u00020!0\u00122\u0006\u0010\u0018\u001a\u00020\u00192\u0006\u0010\u001a\u001a\u00020\u001b2\u0006\u0010\u001c\u001a\u00020\u001dH\u0086@ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b\"\u0010\u001fR\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u000bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\u0010X\u0082\u0004¢\u0006\u0002\n\u0000\u0082\u0002\u000b\n\u0002\b!\n\u0005\b¡\u001e0\u0001¨\u0006$"}, m18d2 = {"Lzendesk/guidekit/android/internal/data/GuideKitRepository;", "", "helpCenterApi", "Lzendesk/guidekit/android/internal/rest/HelpCenterApi;", "brandsApi", "Lzendesk/guidekit/android/internal/rest/BrandsApi;", "articleInMemoryDataSource", "Lzendesk/guidekit/android/internal/data/ArticleInMemoryDataSource;", "brandsInMemoryDataSource", "Lzendesk/guidekit/android/internal/data/BrandsInMemoryDataSource;", "guideKitSettings", "Lzendesk/guidekit/android/model/GuideKitSettings;", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "(Lzendesk/guidekit/android/internal/rest/HelpCenterApi;Lzendesk/guidekit/android/internal/rest/BrandsApi;Lzendesk/guidekit/android/internal/data/ArticleInMemoryDataSource;Lzendesk/guidekit/android/internal/data/BrandsInMemoryDataSource;Lzendesk/guidekit/android/model/GuideKitSettings;Lkotlinx/coroutines/CoroutineScope;)V", "initJob", "Lkotlinx/coroutines/Job;", "fetchBrandFromInMemory", "Lkotlin/Result;", "Lzendesk/guidekit/android/model/Brand;", "fetchBrandFromInMemory-IoAF18A", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getArticle", "Lzendesk/guidekit/android/model/GuideArticle;", "articleId", "", "guideLocale", "Lzendesk/guidekit/android/model/GuideLocale;", "baseUrl", "", "getArticle-BWLJW6A", "(JLzendesk/guidekit/android/model/GuideLocale;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "sendArticleStatsView", "", "sendArticleStatsView-BWLJW6A", "Companion", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class GuideKitRepository {
    private static final String LOG_TAG = "GuideKitRepository";
    private final ArticleInMemoryDataSource articleInMemoryDataSource;
    private final BrandsApi brandsApi;
    private final BrandsInMemoryDataSource brandsInMemoryDataSource;
    private final GuideKitSettings guideKitSettings;
    private final HelpCenterApi helpCenterApi;
    private final Job initJob;

    @Inject
    public GuideKitRepository(HelpCenterApi helpCenterApi, BrandsApi brandsApi, ArticleInMemoryDataSource articleInMemoryDataSource, BrandsInMemoryDataSource brandsInMemoryDataSource, GuideKitSettings guideKitSettings, CoroutineScope coroutineScope) {
        Intrinsics.checkNotNullParameter(helpCenterApi, "helpCenterApi");
        Intrinsics.checkNotNullParameter(brandsApi, "brandsApi");
        Intrinsics.checkNotNullParameter(articleInMemoryDataSource, "articleInMemoryDataSource");
        Intrinsics.checkNotNullParameter(brandsInMemoryDataSource, "brandsInMemoryDataSource");
        Intrinsics.checkNotNullParameter(guideKitSettings, "guideKitSettings");
        Intrinsics.checkNotNullParameter(coroutineScope, "coroutineScope");
        this.helpCenterApi = helpCenterApi;
        this.brandsApi = brandsApi;
        this.articleInMemoryDataSource = articleInMemoryDataSource;
        this.brandsInMemoryDataSource = brandsInMemoryDataSource;
        this.guideKitSettings = guideKitSettings;
        this.initJob = BuildersKt__Builders_commonKt.launch$default(coroutineScope, null, null, new GuideKitRepository$initJob$1(this, null), 3, null);
    }

    public final Object m2116sendArticleStatsViewBWLJW6A(long j, GuideLocale guideLocale, String str, Continuation<? super Result<Unit>> continuation) {
        GuideKitRepository$sendArticleStatsView$1 guideKitRepository$sendArticleStatsView$1;
        if (continuation instanceof GuideKitRepository$sendArticleStatsView$1) {
            guideKitRepository$sendArticleStatsView$1 = (GuideKitRepository$sendArticleStatsView$1) continuation;
            if ((guideKitRepository$sendArticleStatsView$1.label & Integer.MIN_VALUE) != 0) {
                guideKitRepository$sendArticleStatsView$1.label -= Integer.MIN_VALUE;
            } else {
                guideKitRepository$sendArticleStatsView$1 = new GuideKitRepository$sendArticleStatsView$1(this, continuation);
            }
        } else {
            guideKitRepository$sendArticleStatsView$1 = new GuideKitRepository$sendArticleStatsView$1(this, continuation);
        }
        GuideKitRepository$sendArticleStatsView$1 guideKitRepository$sendArticleStatsView$2 = guideKitRepository$sendArticleStatsView$1;
        Object obj = guideKitRepository$sendArticleStatsView$2.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = guideKitRepository$sendArticleStatsView$2.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                String str2 = str + "/api/v2/help_center/" + guideLocale.getLocale() + "/articles/" + j + "/stats/view.json";
                HelpCenterApi helpCenterApi = this.helpCenterApi;
                guideKitRepository$sendArticleStatsView$2.label = 1;
                if (HelpCenterApi.DefaultImpls.sendArticleStatsView$default(helpCenterApi, str2, null, guideKitRepository$sendArticleStatsView$2, 2, null) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            Result.Companion companion = Result.INSTANCE;
            return Result.m296constructorimpl(Unit.INSTANCE);
        } catch (Exception e) {
            if (e instanceof CancellationException) {
                throw e;
            }
            Result.Companion companion2 = Result.INSTANCE;
            return Result.m296constructorimpl(ResultKt.createFailure(e));
        }
    }

    public final Object m2115getArticleBWLJW6A(long j, GuideLocale guideLocale, String str, Continuation<? super Result<GuideArticle>> continuation) {
        GuideKitRepository$getArticle$1 guideKitRepository$getArticle$1;
        if (continuation instanceof GuideKitRepository$getArticle$1) {
            guideKitRepository$getArticle$1 = (GuideKitRepository$getArticle$1) continuation;
            if ((guideKitRepository$getArticle$1.label & Integer.MIN_VALUE) != 0) {
                guideKitRepository$getArticle$1.label -= Integer.MIN_VALUE;
            } else {
                guideKitRepository$getArticle$1 = new GuideKitRepository$getArticle$1(this, continuation);
            }
        } else {
            guideKitRepository$getArticle$1 = new GuideKitRepository$getArticle$1(this, continuation);
        }
        Object objSupervisorScope = guideKitRepository$getArticle$1.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = guideKitRepository$getArticle$1.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objSupervisorScope);
            GuideKitRepository$getArticle$2 guideKitRepository$getArticle$2 = new GuideKitRepository$getArticle$2(this, j, guideLocale, str, null);
            guideKitRepository$getArticle$1.label = 1;
            objSupervisorScope = SupervisorKt.supervisorScope(guideKitRepository$getArticle$2, guideKitRepository$getArticle$1);
            if (objSupervisorScope == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(objSupervisorScope);
        }
        return ((Result) objSupervisorScope).getValue();
    }

    public final Object m2114fetchBrandFromInMemoryIoAF18A(Continuation<? super Result<Brand>> continuation) {
        GuideKitRepository$fetchBrandFromInMemory$1 guideKitRepository$fetchBrandFromInMemory$1;
        GuideKitRepository guideKitRepository;
        String str;
        Brand brand;
        if (continuation instanceof GuideKitRepository$fetchBrandFromInMemory$1) {
            guideKitRepository$fetchBrandFromInMemory$1 = (GuideKitRepository$fetchBrandFromInMemory$1) continuation;
            if ((guideKitRepository$fetchBrandFromInMemory$1.label & Integer.MIN_VALUE) != 0) {
                guideKitRepository$fetchBrandFromInMemory$1.label -= Integer.MIN_VALUE;
            } else {
                guideKitRepository$fetchBrandFromInMemory$1 = new GuideKitRepository$fetchBrandFromInMemory$1(this, continuation);
            }
        } else {
            guideKitRepository$fetchBrandFromInMemory$1 = new GuideKitRepository$fetchBrandFromInMemory$1(this, continuation);
        }
        Object obj = guideKitRepository$fetchBrandFromInMemory$1.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = guideKitRepository$fetchBrandFromInMemory$1.label;
        try {
            if (i != 0) {
                if (i == 1) {
                    guideKitRepository = (GuideKitRepository) guideKitRepository$fetchBrandFromInMemory$1.L$0;
                    ResultKt.throwOnFailure(obj);
                } else {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    str = (String) guideKitRepository$fetchBrandFromInMemory$1.L$0;
                    ResultKt.throwOnFailure(obj);
                }
                brand = (Brand) obj;
                if (brand != null) {
                    Result.Companion companion = Result.INSTANCE;
                    return Result.m296constructorimpl(brand);
                }
                Result.Companion companion2 = Result.INSTANCE;
                return Result.m296constructorimpl(ResultKt.createFailure(new BrandNotFoundException(str)));
            }
            ResultKt.throwOnFailure(obj);
            Job job = this.initJob;
            guideKitRepository$fetchBrandFromInMemory$1.L$0 = this;
            guideKitRepository$fetchBrandFromInMemory$1.label = 1;
            if (job.join(guideKitRepository$fetchBrandFromInMemory$1) == coroutine_suspended) {
                return coroutine_suspended;
            }
            guideKitRepository = this;
            String channelId$zendesk_guidekit_guidekit_android = guideKitRepository.guideKitSettings.getChannelId$zendesk_guidekit_guidekit_android();
            BrandsInMemoryDataSource brandsInMemoryDataSource = guideKitRepository.brandsInMemoryDataSource;
            guideKitRepository$fetchBrandFromInMemory$1.L$0 = channelId$zendesk_guidekit_guidekit_android;
            guideKitRepository$fetchBrandFromInMemory$1.label = 2;
            Object brand2 = brandsInMemoryDataSource.getBrand(channelId$zendesk_guidekit_guidekit_android, guideKitRepository$fetchBrandFromInMemory$1);
            if (brand2 == coroutine_suspended) {
                return coroutine_suspended;
            }
            str = channelId$zendesk_guidekit_guidekit_android;
            obj = brand2;
            brand = (Brand) obj;
            if (brand != null) {
                Result.Companion companion3 = Result.INSTANCE;
                return Result.m296constructorimpl(brand);
            }
            Result.Companion companion4 = Result.INSTANCE;
            return Result.m296constructorimpl(ResultKt.createFailure(new BrandNotFoundException(str)));
        } catch (Exception e) {
            if (e instanceof CancellationException) {
                throw e;
            }
            Result.Companion companion5 = Result.INSTANCE;
            return Result.m296constructorimpl(ResultKt.createFailure(e));
        }
    }
}
