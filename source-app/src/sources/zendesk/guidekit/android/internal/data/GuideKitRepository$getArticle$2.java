package zendesk.guidekit.android.internal.data;

import java.util.concurrent.CancellationException;
import kotlin.Metadata;
import kotlin.Result;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt__Builders_commonKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.Deferred;
import retrofit2.HttpException;
import zendesk.guidekit.android.exception.ArticleNotFoundException;
import zendesk.guidekit.android.exception.RestrictedArticleException;
import zendesk.guidekit.android.internal.data.mapper.GuideArticleMapperKt;
import zendesk.guidekit.android.internal.rest.model.ArticleResponseDto;
import zendesk.guidekit.android.internal.rest.model.AttachmentResponseDto;
import zendesk.guidekit.android.model.GuideArticle;
import zendesk.guidekit.android.model.GuideLocale;

@Metadata(m17d1 = {"\u0000\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\b\u0012\u0004\u0012\u00020\u00020\u0001*\u00020\u0003H\u008a@"}, m18d2 = {"<anonymous>", "Lkotlin/Result;", "Lzendesk/guidekit/android/model/GuideArticle;", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.guidekit.android.internal.data.GuideKitRepository$getArticle$2", m37f = "GuideKitRepository.kt", m38i = {0, 1, 2, 3}, m39l = {120, 143, 144, 147}, m40m = "invokeSuspend", m41n = {"$this$supervisorScope", "attachmentsDeferred", "articleResponse", "guideArticle"}, m42s = {"L$0", "L$0", "L$0", "L$0"})
final class GuideKitRepository$getArticle$2 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Result<? extends GuideArticle>>, Object> {
    final long $articleId;
    final String $baseUrl;
    final GuideLocale $guideLocale;
    private Object L$0;
    int label;
    final GuideKitRepository this$0;

    GuideKitRepository$getArticle$2(GuideKitRepository guideKitRepository, long j, GuideLocale guideLocale, String str, Continuation<? super GuideKitRepository$getArticle$2> continuation) {
        super(2, continuation);
        this.this$0 = guideKitRepository;
        this.$articleId = j;
        this.$guideLocale = guideLocale;
        this.$baseUrl = str;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        GuideKitRepository$getArticle$2 guideKitRepository$getArticle$2 = new GuideKitRepository$getArticle$2(this.this$0, this.$articleId, this.$guideLocale, this.$baseUrl, continuation);
        guideKitRepository$getArticle$2.L$0 = obj;
        return guideKitRepository$getArticle$2;
    }

    @Override
    public Object invoke(CoroutineScope coroutineScope, Continuation<? super Result<? extends GuideArticle>> continuation) {
        return invoke2(coroutineScope, (Continuation<? super Result<GuideArticle>>) continuation);
    }

    public final Object invoke2(CoroutineScope coroutineScope, Continuation<? super Result<GuideArticle>> continuation) {
        return ((GuideKitRepository$getArticle$2) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Exception {
        Object objM296constructorimpl;
        CoroutineScope coroutineScope;
        Deferred deferredAsync$default;
        ArticleResponseDto articleResponseDto;
        Object objAwait;
        ArticleResponseDto articleResponseDto2;
        GuideArticle guideArticle;
        GuideArticle guideArticle2;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        try {
            if (i != 0) {
                if (i == 1) {
                    coroutineScope = (CoroutineScope) this.L$0;
                    ResultKt.throwOnFailure(obj);
                } else if (i == 2) {
                    deferredAsync$default = (Deferred) this.L$0;
                    ResultKt.throwOnFailure(obj);
                    articleResponseDto = (ArticleResponseDto) obj;
                    this.L$0 = articleResponseDto;
                    this.label = 3;
                    objAwait = deferredAsync$default.await(this);
                    if (objAwait == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    articleResponseDto2 = articleResponseDto;
                    obj = objAwait;
                    guideArticle = GuideArticleMapperKt.toGuideArticle(articleResponseDto2, GuideArticleMapperKt.toGuideAttachment((AttachmentResponseDto) obj));
                    this.L$0 = guideArticle;
                    this.label = 4;
                    if (this.this$0.articleInMemoryDataSource.saveArticle(guideArticle, this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    guideArticle2 = guideArticle;
                } else if (i == 3) {
                    articleResponseDto2 = (ArticleResponseDto) this.L$0;
                    ResultKt.throwOnFailure(obj);
                    guideArticle = GuideArticleMapperKt.toGuideArticle(articleResponseDto2, GuideArticleMapperKt.toGuideAttachment((AttachmentResponseDto) obj));
                    this.L$0 = guideArticle;
                    this.label = 4;
                    if (this.this$0.articleInMemoryDataSource.saveArticle(guideArticle, this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    guideArticle2 = guideArticle;
                } else {
                    if (i != 4) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    guideArticle2 = (GuideArticle) this.L$0;
                    ResultKt.throwOnFailure(obj);
                }
                Result.Companion companion = Result.INSTANCE;
                objM296constructorimpl = Result.m296constructorimpl(guideArticle2);
                return Result.m295boximpl(objM296constructorimpl);
            }
            ResultKt.throwOnFailure(obj);
            coroutineScope = (CoroutineScope) this.L$0;
            this.L$0 = coroutineScope;
            this.label = 1;
            obj = this.this$0.articleInMemoryDataSource.getArticle(this.$articleId, this);
            if (obj == coroutine_suspended) {
                return coroutine_suspended;
            }
            GuideArticle guideArticle3 = (GuideArticle) obj;
            if (guideArticle3 != null && Intrinsics.areEqual(this.$guideLocale.getLocale(), guideArticle3.getLocale())) {
                Result.Companion companion2 = Result.INSTANCE;
                return Result.m295boximpl(Result.m296constructorimpl(guideArticle3));
            }
            String str = this.$baseUrl + "/api/v2/help_center/" + this.$guideLocale.getLocale() + "/articles/" + this.$articleId + ".json";
            String str2 = this.$baseUrl + "/api/v2/help_center/" + this.$guideLocale.getLocale() + "/articles/" + this.$articleId + "/attachments/block.json";
            Deferred deferredAsync$default2 = BuildersKt__Builders_commonKt.async$default(coroutineScope, null, null, new GuideKitRepository$getArticle$2$articleDeferred$1(this.this$0, str, null), 3, null);
            deferredAsync$default = BuildersKt__Builders_commonKt.async$default(coroutineScope, null, null, new GuideKitRepository$getArticle$2$attachmentsDeferred$1(this.this$0, str2, null), 3, null);
            this.L$0 = deferredAsync$default;
            this.label = 2;
            obj = deferredAsync$default2.await(this);
            if (obj == coroutine_suspended) {
                return coroutine_suspended;
            }
            articleResponseDto = (ArticleResponseDto) obj;
            this.L$0 = articleResponseDto;
            this.label = 3;
            objAwait = deferredAsync$default.await(this);
            if (objAwait == coroutine_suspended) {
                return coroutine_suspended;
            }
            articleResponseDto2 = articleResponseDto;
            obj = objAwait;
            guideArticle = GuideArticleMapperKt.toGuideArticle(articleResponseDto2, GuideArticleMapperKt.toGuideAttachment((AttachmentResponseDto) obj));
            this.L$0 = guideArticle;
            this.label = 4;
            if (this.this$0.articleInMemoryDataSource.saveArticle(guideArticle, this) == coroutine_suspended) {
                return coroutine_suspended;
            }
            guideArticle2 = guideArticle;
            Result.Companion companion3 = Result.INSTANCE;
            objM296constructorimpl = Result.m296constructorimpl(guideArticle2);
            return Result.m295boximpl(objM296constructorimpl);
        } catch (HttpException e) {
            if (e.code() == 404) {
                Result.Companion companion4 = Result.INSTANCE;
                objM296constructorimpl = Result.m296constructorimpl(ResultKt.createFailure(new ArticleNotFoundException(this.$guideLocale.getLocale(), this.$articleId)));
            } else if (e.code() == 401) {
                Result.Companion companion5 = Result.INSTANCE;
                objM296constructorimpl = Result.m296constructorimpl(ResultKt.createFailure(new RestrictedArticleException(this.$guideLocale.getLocale(), this.$articleId)));
            } else {
                Result.Companion companion6 = Result.INSTANCE;
                objM296constructorimpl = Result.m296constructorimpl(ResultKt.createFailure(e));
            }
        } catch (Exception e2) {
            if (e2 instanceof CancellationException) {
                throw e2;
            }
            Result.Companion companion7 = Result.INSTANCE;
            objM296constructorimpl = Result.m296constructorimpl(ResultKt.createFailure(e2));
        }
    }
}
