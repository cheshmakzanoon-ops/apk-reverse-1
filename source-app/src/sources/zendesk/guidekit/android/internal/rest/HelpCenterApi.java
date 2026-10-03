package zendesk.guidekit.android.internal.rest;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.Query;
import retrofit2.http.Url;
import zendesk.guidekit.android.internal.rest.model.ArticleResponseDto;
import zendesk.guidekit.android.internal.rest.model.AttachmentResponseDto;

@Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0004\b`\u0018\u0000 \u00102\u00020\u0001:\u0001\u0010J\u0018\u0010\u0002\u001a\u00020\u00032\b\b\u0001\u0010\u0004\u001a\u00020\u0005H§@¢\u0006\u0002\u0010\u0006J\"\u0010\u0007\u001a\u00020\b2\b\b\u0001\u0010\u0004\u001a\u00020\u00052\b\b\u0003\u0010\t\u001a\u00020\nH§@¢\u0006\u0002\u0010\u000bJ\"\u0010\f\u001a\u00020\r2\b\b\u0001\u0010\u0004\u001a\u00020\u00052\b\b\u0003\u0010\u000e\u001a\u00020\u0005H§@¢\u0006\u0002\u0010\u000f¨\u0006\u0011"}, m18d2 = {"Lzendesk/guidekit/android/internal/rest/HelpCenterApi;", "", "getArticle", "Lzendesk/guidekit/android/internal/rest/model/ArticleResponseDto;", "url", "", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getAttachments", "Lzendesk/guidekit/android/internal/rest/model/AttachmentResponseDto;", "perPage", "", "(Ljava/lang/String;ILkotlin/coroutines/Continuation;)Ljava/lang/Object;", "sendArticleStatsView", "", "origin", "(Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Companion", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface HelpCenterApi {

    public static final Companion INSTANCE = Companion.$$INSTANCE;

    @Deprecated
    public static final String ORIGIN = "mobile_sdk";

    @GET
    Object getArticle(@Url String str, Continuation<? super ArticleResponseDto> continuation);

    @GET
    Object getAttachments(@Url String str, @Query("per_page") int i, Continuation<? super AttachmentResponseDto> continuation);

    @POST
    Object sendArticleStatsView(@Url String str, @Query("origin") String str2, Continuation<? super Unit> continuation);

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class DefaultImpls {
        public static Object getAttachments$default(HelpCenterApi helpCenterApi, String str, int i, Continuation continuation, int i2, Object obj) {
            if (obj != null) {
                throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: getAttachments");
            }
            if ((i2 & 2) != 0) {
                i = 100;
            }
            return helpCenterApi.getAttachments(str, i, continuation);
        }

        public static Object sendArticleStatsView$default(HelpCenterApi helpCenterApi, String str, String str2, Continuation continuation, int i, Object obj) {
            if (obj != null) {
                throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: sendArticleStatsView");
            }
            if ((i & 2) != 0) {
                str2 = "mobile_sdk";
            }
            return helpCenterApi.sendArticleStatsView(str, str2, continuation);
        }
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000¨\u0006\u0005"}, m18d2 = {"Lzendesk/guidekit/android/internal/rest/HelpCenterApi$Companion;", "", "()V", "ORIGIN", "", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        static final Companion $$INSTANCE = new Companion();
        public static final String ORIGIN = "mobile_sdk";

        private Companion() {
        }
    }
}
