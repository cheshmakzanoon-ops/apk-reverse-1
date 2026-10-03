package zendesk.conversationkit.android.internal.rest;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import retrofit2.http.GET;
import retrofit2.http.Header;
import retrofit2.http.Headers;
import retrofit2.http.Path;
import zendesk.conversationkit.android.model.WaitTimeDataResponse;

@Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0004\b`\u0018\u0000 \b2\u00020\u0001:\u0001\bJ\"\u0010\u0002\u001a\u00020\u00032\b\b\u0001\u0010\u0004\u001a\u00020\u00052\b\b\u0001\u0010\u0006\u001a\u00020\u0005H§@¢\u0006\u0002\u0010\u0007¨\u0006\t"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/EndUserExpectationsApi;", "", "getWaitTimeData", "Lzendesk/conversationkit/android/model/WaitTimeDataResponse;", "authorization", "", "conversationId", "(Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface EndUserExpectationsApi {

    @Deprecated
    public static final String AUTHORIZATION_HEADER = "Authorization";

    @Deprecated
    public static final String CONVERSATION_ID_PATH = "conversationId";

    public static final Companion INSTANCE = Companion.$$INSTANCE;

    @Deprecated
    public static final String JSON_CONTENT_TYPE = "Content-Type:application/json";

    @Headers({"Content-Type:application/json"})
    @GET("api/services/end_user_connector/wait_time/conversations/{conversationId}")
    Object getWaitTimeData(@Header("Authorization") String str, @Path("conversationId") String str2, Continuation<? super WaitTimeDataResponse> continuation);

    @Metadata(m17d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0003\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000¨\u0006\u0007"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/EndUserExpectationsApi$Companion;", "", "()V", "AUTHORIZATION_HEADER", "", "CONVERSATION_ID_PATH", "JSON_CONTENT_TYPE", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        static final Companion $$INSTANCE = new Companion();
        public static final String AUTHORIZATION_HEADER = "Authorization";
        public static final String CONVERSATION_ID_PATH = "conversationId";
        public static final String JSON_CONTENT_TYPE = "Content-Type:application/json";

        private Companion() {
        }
    }
}
