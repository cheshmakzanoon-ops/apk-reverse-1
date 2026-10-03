package zendesk.guidekit.android;

import kotlin.Metadata;
import kotlin.Result;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import zendesk.guidekit.android.model.GuideArticle;
import zendesk.guidekit.android.model.GuideArticleUrl;
import zendesk.guidekit.android.model.GuideLocale;

@Metadata(m17d1 = {"\u0000>\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\t\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\bf\u0018\u00002\u00020\u0001J4\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\nH¦@ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b\u000b\u0010\fJ$\u0010\r\u001a\b\u0012\u0004\u0012\u00020\u000e0\u00032\u0006\u0010\u0005\u001a\u00020\u0006H¦@ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b\u000f\u0010\u0010J\u0016\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0005\u001a\u00020\u0006H¦@¢\u0006\u0002\u0010\u0010J4\u0010\u0013\u001a\b\u0012\u0004\u0012\u00020\u00140\u00032\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\nH¦@ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b\u0015\u0010\f\u0082\u0002\u000b\n\u0002\b!\n\u0005\b¡\u001e0\u0001¨\u0006\u0016"}, m18d2 = {"Lzendesk/guidekit/android/GuideKit;", "", "getArticle", "Lkotlin/Result;", "Lzendesk/guidekit/android/model/GuideArticle;", "url", "", "articleId", "", "guideLocale", "Lzendesk/guidekit/android/model/GuideLocale;", "getArticle-BWLJW6A", "(Ljava/lang/String;JLzendesk/guidekit/android/model/GuideLocale;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getGuideArticleLink", "Lzendesk/guidekit/android/model/GuideArticleUrl;", "getGuideArticleLink-gIAlu-s", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "isValidGuideUrl", "", "sendArticleStatsView", "", "sendArticleStatsView-BWLJW6A", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface GuideKit {
    Object mo2111getArticleBWLJW6A(String str, long j, GuideLocale guideLocale, Continuation<? super Result<GuideArticle>> continuation);

    Object mo2112getGuideArticleLinkgIAlus(String str, Continuation<? super Result<GuideArticleUrl>> continuation);

    Object isValidGuideUrl(String str, Continuation<? super Boolean> continuation);

    Object mo2113sendArticleStatsViewBWLJW6A(String str, long j, GuideLocale guideLocale, Continuation<? super Result<Unit>> continuation);
}
