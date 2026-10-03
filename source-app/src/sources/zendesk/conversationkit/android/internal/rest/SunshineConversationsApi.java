package zendesk.conversationkit.android.internal.rest;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import okhttp3.MultipartBody;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.Header;
import retrofit2.http.Headers;
import retrofit2.http.Multipart;
import retrofit2.http.POST;
import retrofit2.http.PUT;
import retrofit2.http.Part;
import retrofit2.http.Path;
import retrofit2.http.Query;
import zendesk.conversationkit.android.internal.rest.model.ActivityDataRequestDto;
import zendesk.conversationkit.android.internal.rest.model.AppUserRequestDto;
import zendesk.conversationkit.android.internal.rest.model.AppUserResponseDto;
import zendesk.conversationkit.android.internal.rest.model.AuthorDto;
import zendesk.conversationkit.android.internal.rest.model.ConversationResponseDto;
import zendesk.conversationkit.android.internal.rest.model.ConversationsResponseDto;
import zendesk.conversationkit.android.internal.rest.model.CreateConversationRequestDto;
import zendesk.conversationkit.android.internal.rest.model.MessageListResponseDto;
import zendesk.conversationkit.android.internal.rest.model.MetadataDto;
import zendesk.conversationkit.android.internal.rest.model.ProactiveMessageReferralDto;
import zendesk.conversationkit.android.internal.rest.model.SendMessageRequestDto;
import zendesk.conversationkit.android.internal.rest.model.SendMessageResponseDto;
import zendesk.conversationkit.android.internal.rest.model.SendPostbackRequestDto;
import zendesk.conversationkit.android.internal.rest.model.UpdateAppUserLocaleDto;
import zendesk.conversationkit.android.internal.rest.model.UpdateConversationRequestDto;
import zendesk.conversationkit.android.internal.rest.model.UpdatePushTokenDto;
import zendesk.conversationkit.android.internal.rest.model.UploadFileResponseDto;
import zendesk.conversationkit.android.internal.rest.user.SunshineAppUserService;
import zendesk.faye.internal.Bayeux;

@Metadata(m17d1 = {"\u0000ª\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0006\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\b`\u0018\u0000 F2\u00020\u0001:\u0001FJ,\u0010\u0002\u001a\u00020\u00032\b\b\u0001\u0010\u0004\u001a\u00020\u00052\b\b\u0001\u0010\u0006\u001a\u00020\u00052\b\b\u0001\u0010\u0007\u001a\u00020\bH§@¢\u0006\u0002\u0010\tJ6\u0010\n\u001a\u00020\u000b2\b\b\u0001\u0010\f\u001a\u00020\u00052\b\b\u0001\u0010\u0004\u001a\u00020\u00052\b\b\u0001\u0010\r\u001a\u00020\u00052\b\b\u0001\u0010\u000e\u001a\u00020\u000fH§@¢\u0006\u0002\u0010\u0010J,\u0010\u0011\u001a\u00020\u00032\b\b\u0001\u0010\f\u001a\u00020\u00052\b\b\u0001\u0010\u0004\u001a\u00020\u00052\b\b\u0001\u0010\r\u001a\u00020\u0005H§@¢\u0006\u0002\u0010\u0012J,\u0010\u0013\u001a\u00020\u000b2\b\b\u0001\u0010\f\u001a\u00020\u00052\b\b\u0001\u0010\u0004\u001a\u00020\u00052\b\b\u0001\u0010\u0014\u001a\u00020\u0005H§@¢\u0006\u0002\u0010\u0012J6\u0010\u0015\u001a\u00020\u00162\b\b\u0001\u0010\f\u001a\u00020\u00052\b\b\u0001\u0010\u0004\u001a\u00020\u00052\b\b\u0001\u0010\r\u001a\u00020\u00052\b\b\u0001\u0010\u0017\u001a\u00020\u0018H§@¢\u0006\u0002\u0010\u0019J6\u0010\u001a\u001a\u00020\u001b2\b\b\u0001\u0010\f\u001a\u00020\u00052\b\b\u0001\u0010\u0004\u001a\u00020\u00052\b\b\u0001\u0010\u0014\u001a\u00020\u00052\b\b\u0001\u0010\u001c\u001a\u00020\u001dH§@¢\u0006\u0002\u0010\u001eJ6\u0010\u001f\u001a\u00020\u000b2\b\b\u0001\u0010\f\u001a\u00020\u00052\b\b\u0001\u0010\u0004\u001a\u00020\u00052\b\b\u0001\u0010\u0014\u001a\u00020\u00052\b\b\u0001\u0010 \u001a\u00020!H§@¢\u0006\u0002\u0010\"J6\u0010#\u001a\u00020$2\b\b\u0001\u0010\f\u001a\u00020\u00052\b\b\u0001\u0010\u0004\u001a\u00020\u00052\b\b\u0001\u0010\u0014\u001a\u00020\u00052\b\b\u0001\u0010%\u001a\u00020&H§@¢\u0006\u0002\u0010'J6\u0010(\u001a\u00020)2\b\b\u0001\u0010\f\u001a\u00020\u00052\b\b\u0001\u0010\u0004\u001a\u00020\u00052\b\b\u0001\u0010\u0014\u001a\u00020\u00052\b\b\u0001\u0010*\u001a\u00020+H§@¢\u0006\u0002\u0010,J6\u0010-\u001a\u00020$2\b\b\u0001\u0010\f\u001a\u00020\u00052\b\b\u0001\u0010\u0004\u001a\u00020\u00052\b\b\u0001\u0010\u0014\u001a\u00020\u00052\b\b\u0001\u0010.\u001a\u00020/H§@¢\u0006\u0002\u00100J6\u00101\u001a\u00020$2\b\b\u0001\u0010\f\u001a\u00020\u00052\b\b\u0001\u0010\u0004\u001a\u00020\u00052\b\b\u0001\u0010\r\u001a\u00020\u00052\b\b\u0001\u00102\u001a\u000203H§@¢\u0006\u0002\u00104J6\u00105\u001a\u00020\u000b2\b\b\u0001\u0010\f\u001a\u00020\u00052\b\b\u0001\u0010\u0004\u001a\u00020\u00052\b\b\u0001\u0010\u0014\u001a\u00020\u00052\b\b\u0001\u00106\u001a\u000207H§@¢\u0006\u0002\u00108J@\u00109\u001a\u00020$2\b\b\u0001\u0010\f\u001a\u00020\u00052\b\b\u0001\u0010\u0004\u001a\u00020\u00052\b\b\u0001\u0010\r\u001a\u00020\u00052\b\b\u0001\u0010\u0006\u001a\u00020\u00052\b\b\u0001\u0010:\u001a\u00020;H§@¢\u0006\u0002\u0010<JJ\u0010=\u001a\u00020>2\b\b\u0001\u0010\f\u001a\u00020\u00052\b\b\u0001\u0010\u0004\u001a\u00020\u00052\b\b\u0001\u0010\u0014\u001a\u00020\u00052\b\b\u0001\u0010?\u001a\u00020@2\b\b\u0001\u0010A\u001a\u00020B2\b\b\u0001\u0010C\u001a\u00020DH§@¢\u0006\u0002\u0010E¨\u0006G"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/SunshineConversationsApi;", "Lzendesk/conversationkit/android/internal/rest/user/SunshineAppUserService;", "createAppUser", "Lzendesk/conversationkit/android/internal/rest/model/AppUserResponseDto;", "appId", "", Bayeux.KEY_CLIENT_ID, "appUserRequestDto", "Lzendesk/conversationkit/android/internal/rest/model/AppUserRequestDto;", "(Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/AppUserRequestDto;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "createConversation", "Lzendesk/conversationkit/android/internal/rest/model/ConversationResponseDto;", "authorization", "appUserId", "createConversationRequestDto", "Lzendesk/conversationkit/android/internal/rest/model/CreateConversationRequestDto;", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/CreateConversationRequestDto;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getAppUser", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getConversation", "conversationId", "getConversations", "Lzendesk/conversationkit/android/internal/rest/model/ConversationsResponseDto;", "offset", "", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ILkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getMessages", "Lzendesk/conversationkit/android/internal/rest/model/MessageListResponseDto;", "beforeTimestamp", "", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;DLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "proactiveMessageReferral", "proactiveMessageReferralDto", "Lzendesk/conversationkit/android/internal/rest/model/ProactiveMessageReferralDto;", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/ProactiveMessageReferralDto;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "sendActivityData", "", "activityDataDto", "Lzendesk/conversationkit/android/internal/rest/model/ActivityDataRequestDto;", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/ActivityDataRequestDto;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "sendMessage", "Lzendesk/conversationkit/android/internal/rest/model/SendMessageResponseDto;", "sendMessageRequestDto", "Lzendesk/conversationkit/android/internal/rest/model/SendMessageRequestDto;", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/SendMessageRequestDto;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "sendPostbackAction", "sendPostbackRequestDto", "Lzendesk/conversationkit/android/internal/rest/model/SendPostbackRequestDto;", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/SendPostbackRequestDto;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "updateAppUserLocale", "updateAppUserLocaleDto", "Lzendesk/conversationkit/android/internal/rest/model/UpdateAppUserLocaleDto;", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/UpdateAppUserLocaleDto;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "updateConversation", "updateConversationRequestDto", "Lzendesk/conversationkit/android/internal/rest/model/UpdateConversationRequestDto;", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/UpdateConversationRequestDto;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "updatePushToken", "updatePushTokenDto", "Lzendesk/conversationkit/android/internal/rest/model/UpdatePushTokenDto;", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/UpdatePushTokenDto;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "uploadFile", "Lzendesk/conversationkit/android/internal/rest/model/UploadFileResponseDto;", "authorDto", "Lzendesk/conversationkit/android/internal/rest/model/AuthorDto;", "metadataDto", "Lzendesk/conversationkit/android/internal/rest/model/MetadataDto;", "file", "Lokhttp3/MultipartBody$Part;", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/AuthorDto;Lzendesk/conversationkit/android/internal/rest/model/MetadataDto;Lokhttp3/MultipartBody$Part;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface SunshineConversationsApi extends SunshineAppUserService {

    @Deprecated
    public static final String APP_ID_PATH = "appId";

    @Deprecated
    public static final String APP_USER_ID_PATH = "appUserId";

    @Deprecated
    public static final String AUTHORIZATION_HEADER = "Authorization";

    @Deprecated
    public static final String CONVERSATION_ID_PATH = "conversationId";

    public static final Companion INSTANCE = Companion.$$INSTANCE;

    @Deprecated
    public static final String JSON_CONTENT_TYPE = "Content-Type:application/json";

    @Deprecated
    public static final String OFFSET = "offset";

    @Headers({"Content-Type:application/json"})
    @POST("v2/apps/{appId}/appusers")
    Object createAppUser(@Path("appId") String str, @Header("x-smooch-clientid") String str2, @Body AppUserRequestDto appUserRequestDto, Continuation<? super AppUserResponseDto> continuation);

    @Headers({"Content-Type:application/json"})
    @POST("v2/apps/{appId}/appusers/{appUserId}/conversations")
    Object createConversation(@Header("Authorization") String str, @Path("appId") String str2, @Path("appUserId") String str3, @Body CreateConversationRequestDto createConversationRequestDto, Continuation<? super ConversationResponseDto> continuation);

    @Headers({"Content-Type:application/json"})
    @GET("v2/apps/{appId}/appusers/{appUserId}")
    Object getAppUser(@Header("Authorization") String str, @Path("appId") String str2, @Path("appUserId") String str3, Continuation<? super AppUserResponseDto> continuation);

    @Headers({"Content-Type:application/json"})
    @GET("v2/apps/{appId}/conversations/{conversationId}")
    Object getConversation(@Header("Authorization") String str, @Path("appId") String str2, @Path("conversationId") String str3, Continuation<? super ConversationResponseDto> continuation);

    @Headers({"Content-Type:application/json"})
    @GET("v2/apps/{appId}/appusers/{appUserId}/conversations")
    Object getConversations(@Header("Authorization") String str, @Path("appId") String str2, @Path("appUserId") String str3, @Query("offset") int i, Continuation<? super ConversationsResponseDto> continuation);

    @Headers({"Content-Type:application/json"})
    @GET("v2/apps/{appId}/conversations/{conversationId}/messages")
    Object getMessages(@Header("Authorization") String str, @Path("appId") String str2, @Path("conversationId") String str3, @Query("before") double d, Continuation<? super MessageListResponseDto> continuation);

    @Headers({"Content-Type:application/json"})
    @POST("v2/apps/{appId}/conversations/{conversationId}/referral")
    Object proactiveMessageReferral(@Header("Authorization") String str, @Path("appId") String str2, @Path("conversationId") String str3, @Body ProactiveMessageReferralDto proactiveMessageReferralDto, Continuation<? super ConversationResponseDto> continuation);

    @Headers({"Content-Type:application/json"})
    @POST("v2/apps/{appId}/conversations/{conversationId}/activity")
    Object sendActivityData(@Header("Authorization") String str, @Path("appId") String str2, @Path("conversationId") String str3, @Body ActivityDataRequestDto activityDataRequestDto, Continuation<? super Unit> continuation);

    @Headers({"Content-Type:application/json"})
    @POST("v2/apps/{appId}/conversations/{conversationId}/messages")
    Object sendMessage(@Header("Authorization") String str, @Path("appId") String str2, @Path("conversationId") String str3, @Body SendMessageRequestDto sendMessageRequestDto, Continuation<? super SendMessageResponseDto> continuation);

    @Headers({"Content-Type:application/json"})
    @POST("v2/apps/{appId}/conversations/{conversationId}/postback")
    Object sendPostbackAction(@Header("Authorization") String str, @Path("appId") String str2, @Path("conversationId") String str3, @Body SendPostbackRequestDto sendPostbackRequestDto, Continuation<? super Unit> continuation);

    @Headers({"Content-Type:application/json"})
    @PUT("v2/apps/{appId}/appusers/{appUserId}")
    Object updateAppUserLocale(@Header("Authorization") String str, @Path("appId") String str2, @Path("appUserId") String str3, @Body UpdateAppUserLocaleDto updateAppUserLocaleDto, Continuation<? super Unit> continuation);

    @Headers({"Content-Type:application/json"})
    @PUT("v2/apps/{appId}/conversations/{conversationId}")
    Object updateConversation(@Header("Authorization") String str, @Path("appId") String str2, @Path("conversationId") String str3, @Body UpdateConversationRequestDto updateConversationRequestDto, Continuation<? super ConversationResponseDto> continuation);

    @Headers({"Content-Type:application/json"})
    @PUT("v2/apps/{appId}/appusers/{appUserId}/clients/{clientId}")
    Object updatePushToken(@Header("Authorization") String str, @Path("appId") String str2, @Path("appUserId") String str3, @Path(Bayeux.KEY_CLIENT_ID) String str4, @Body UpdatePushTokenDto updatePushTokenDto, Continuation<? super Unit> continuation);

    @POST("v2/apps/{appId}/conversations/{conversationId}/files")
    @Multipart
    Object uploadFile(@Header("Authorization") String str, @Path("appId") String str2, @Path("conversationId") String str3, @Part("author") AuthorDto authorDto, @Part("message") MetadataDto metadataDto, @Part MultipartBody.Part part, Continuation<? super UploadFileResponseDto> continuation);

    @Metadata(m17d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0006\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000¨\u0006\n"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/SunshineConversationsApi$Companion;", "", "()V", "APP_ID_PATH", "", "APP_USER_ID_PATH", "AUTHORIZATION_HEADER", "CONVERSATION_ID_PATH", "JSON_CONTENT_TYPE", "OFFSET", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        static final Companion $$INSTANCE = new Companion();
        public static final String APP_ID_PATH = "appId";
        public static final String APP_USER_ID_PATH = "appUserId";
        public static final String AUTHORIZATION_HEADER = "Authorization";
        public static final String CONVERSATION_ID_PATH = "conversationId";
        public static final String JSON_CONTENT_TYPE = "Content-Type:application/json";
        public static final String OFFSET = "offset";

        private Companion() {
        }
    }
}
