package zendesk.conversationkit.android.internal.rest;

import java.io.File;
import java.io.IOException;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.internal.Intrinsics;
import kotlin.p002io.CloseableKt;
import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.RequestBody;
import okio.BufferedSink;
import okio.Okio;
import okio.Source;
import zendesk.conversationkit.android.internal.rest.model.ActivityDataRequestDto;
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
import zendesk.conversationkit.android.internal.rest.model.UploadFileDto;
import zendesk.conversationkit.android.internal.rest.model.UploadFileResponseDto;
import zendesk.conversationkit.android.internal.rest.user.model.LoginRequestBody;
import zendesk.conversationkit.android.internal.rest.user.model.LogoutRequestBody;
import zendesk.conversationkit.android.model.WaitTimeDataResponse;
import zendesk.faye.internal.Bayeux;

@Metadata(m17d1 = {"\u0000Ä\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0006\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u00002\u00020\u0001B-\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0006\u0012\u0006\u0010\u0007\u001a\u00020\b\u0012\u0006\u0010\t\u001a\u00020\n¢\u0006\u0002\u0010\u000bJ\u001e\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\u00032\u0006\u0010\u000f\u001a\u00020\u0010H\u0086@¢\u0006\u0002\u0010\u0011J\u0016\u0010\u0012\u001a\u00020\u00132\u0006\u0010\u000e\u001a\u00020\u0003H\u0086@¢\u0006\u0002\u0010\u0014J\u001e\u0010\u0015\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\u00032\u0006\u0010\u0016\u001a\u00020\u0003H\u0086@¢\u0006\u0002\u0010\u0017J&\u0010\u0018\u001a\u00020\u00192\u0006\u0010\u000e\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00032\u0006\u0010\u001a\u001a\u00020\u001bH\u0086@¢\u0006\u0002\u0010\u001cJ&\u0010\u001d\u001a\u00020\u001e2\u0006\u0010\u000e\u001a\u00020\u00032\u0006\u0010\u0016\u001a\u00020\u00032\u0006\u0010\u001f\u001a\u00020 H\u0086@¢\u0006\u0002\u0010!J\u001e\u0010\"\u001a\u00020#2\u0006\u0010\u000e\u001a\u00020\u00032\u0006\u0010\u0016\u001a\u00020\u0003H\u0086@¢\u0006\u0002\u0010\u0017J\u001e\u0010$\u001a\u00020\u00132\u0006\u0010%\u001a\u00020\u00032\u0006\u0010&\u001a\u00020'H\u0086@¢\u0006\u0002\u0010(J&\u0010)\u001a\u00020*2\u0006\u0010%\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00032\u0006\u0010+\u001a\u00020,H\u0086@¢\u0006\u0002\u0010-J&\u0010.\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\u00032\u0006\u0010\u0016\u001a\u00020\u00032\u0006\u0010/\u001a\u000200H\u0086@¢\u0006\u0002\u00101J&\u00102\u001a\u00020*2\u0006\u0010\u000e\u001a\u00020\u00032\u0006\u0010\u0016\u001a\u00020\u00032\u0006\u00103\u001a\u000204H\u0086@¢\u0006\u0002\u00105J&\u00106\u001a\u0002072\u0006\u0010\u000e\u001a\u00020\u00032\u0006\u0010\u0016\u001a\u00020\u00032\u0006\u00108\u001a\u000209H\u0086@¢\u0006\u0002\u0010:J&\u0010;\u001a\u00020*2\u0006\u0010\u000e\u001a\u00020\u00032\u0006\u0010\u0016\u001a\u00020\u00032\u0006\u0010<\u001a\u00020=H\u0086@¢\u0006\u0002\u0010>J\u001e\u0010?\u001a\u00020*2\u0006\u0010\u000e\u001a\u00020\u00032\u0006\u0010@\u001a\u00020AH\u0086@¢\u0006\u0002\u0010BJ&\u0010C\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\u00032\u0006\u0010\u0016\u001a\u00020\u00032\u0006\u0010D\u001a\u00020EH\u0086@¢\u0006\u0002\u0010FJ&\u0010G\u001a\u00020*2\u0006\u0010\u000e\u001a\u00020\u00032\u0006\u0010H\u001a\u00020\u00032\u0006\u0010I\u001a\u00020JH\u0086@¢\u0006\u0002\u0010KJ&\u0010L\u001a\u00020M2\u0006\u0010\u000e\u001a\u00020\u00032\u0006\u0010\u0016\u001a\u00020\u00032\u0006\u0010N\u001a\u00020OH\u0086@¢\u0006\u0002\u0010PR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006Q"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/UserRestClient;", "", "appId", "", "appUserId", "sunshineConversationsApi", "Lzendesk/conversationkit/android/internal/rest/SunshineConversationsApi;", "endUserExpectationsApi", "Lzendesk/conversationkit/android/internal/rest/EndUserExpectationsApi;", "restClientFiles", "Lzendesk/conversationkit/android/internal/rest/RestClientFiles;", "(Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/SunshineConversationsApi;Lzendesk/conversationkit/android/internal/rest/EndUserExpectationsApi;Lzendesk/conversationkit/android/internal/rest/RestClientFiles;)V", "createConversation", "Lzendesk/conversationkit/android/internal/rest/model/ConversationResponseDto;", "authorization", "createConversationRequestDto", "Lzendesk/conversationkit/android/internal/rest/model/CreateConversationRequestDto;", "(Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/CreateConversationRequestDto;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getAppUser", "Lzendesk/conversationkit/android/internal/rest/model/AppUserResponseDto;", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getConversation", "conversationId", "(Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getConversations", "Lzendesk/conversationkit/android/internal/rest/model/ConversationsResponseDto;", "offset", "", "(Ljava/lang/String;Ljava/lang/String;ILkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getMessages", "Lzendesk/conversationkit/android/internal/rest/model/MessageListResponseDto;", "beforeTimestamp", "", "(Ljava/lang/String;Ljava/lang/String;DLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getWaitTimeData", "Lzendesk/conversationkit/android/model/WaitTimeDataResponse;", "loginAppUser", "jwt", "loginRequestBody", "Lzendesk/conversationkit/android/internal/rest/user/model/LoginRequestBody;", "(Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/user/model/LoginRequestBody;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "logoutAppUser", "", "logoutRequestBody", "Lzendesk/conversationkit/android/internal/rest/user/model/LogoutRequestBody;", "(Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/user/model/LogoutRequestBody;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "proactiveMessageReferral", "proactiveMessageReferralDto", "Lzendesk/conversationkit/android/internal/rest/model/ProactiveMessageReferralDto;", "(Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/ProactiveMessageReferralDto;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "sendActivityData", "activityDataDto", "Lzendesk/conversationkit/android/internal/rest/model/ActivityDataRequestDto;", "(Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/ActivityDataRequestDto;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "sendMessage", "Lzendesk/conversationkit/android/internal/rest/model/SendMessageResponseDto;", "sendMessageRequestDto", "Lzendesk/conversationkit/android/internal/rest/model/SendMessageRequestDto;", "(Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/SendMessageRequestDto;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "sendPostbackAction", "sendPostbackRequestDto", "Lzendesk/conversationkit/android/internal/rest/model/SendPostbackRequestDto;", "(Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/SendPostbackRequestDto;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "updateAppUserLocale", "updateAppUserLocaleDto", "Lzendesk/conversationkit/android/internal/rest/model/UpdateAppUserLocaleDto;", "(Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/UpdateAppUserLocaleDto;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "updateConversation", "updateConversationRequestDto", "Lzendesk/conversationkit/android/internal/rest/model/UpdateConversationRequestDto;", "(Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/UpdateConversationRequestDto;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "updatePushToken", Bayeux.KEY_CLIENT_ID, "updatePushTokenDto", "Lzendesk/conversationkit/android/internal/rest/model/UpdatePushTokenDto;", "(Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/UpdatePushTokenDto;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "uploadFile", "Lzendesk/conversationkit/android/internal/rest/model/UploadFileResponseDto;", "uploadFileDto", "Lzendesk/conversationkit/android/internal/rest/model/UploadFileDto;", "(Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/UploadFileDto;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class UserRestClient {
    private final String appId;
    private final String appUserId;
    private final EndUserExpectationsApi endUserExpectationsApi;
    private final RestClientFiles restClientFiles;
    private final SunshineConversationsApi sunshineConversationsApi;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.rest.UserRestClient", m37f = "UserRestClient.kt", m38i = {0, 0}, m39l = {211}, m40m = "uploadFile", m41n = {"this", "uploadFileDto"}, m42s = {"L$0", "L$1"})
    static final class C10901 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C10901(Continuation<? super C10901> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserRestClient.this.uploadFile(null, null, null, this);
        }
    }

    public UserRestClient(String appId, String appUserId, SunshineConversationsApi sunshineConversationsApi, EndUserExpectationsApi endUserExpectationsApi, RestClientFiles restClientFiles) {
        Intrinsics.checkNotNullParameter(appId, "appId");
        Intrinsics.checkNotNullParameter(appUserId, "appUserId");
        Intrinsics.checkNotNullParameter(sunshineConversationsApi, "sunshineConversationsApi");
        Intrinsics.checkNotNullParameter(endUserExpectationsApi, "endUserExpectationsApi");
        Intrinsics.checkNotNullParameter(restClientFiles, "restClientFiles");
        this.appId = appId;
        this.appUserId = appUserId;
        this.sunshineConversationsApi = sunshineConversationsApi;
        this.endUserExpectationsApi = endUserExpectationsApi;
        this.restClientFiles = restClientFiles;
    }

    public final Object getAppUser(String str, Continuation<? super AppUserResponseDto> continuation) {
        return this.sunshineConversationsApi.getAppUser(str, this.appId, this.appUserId, continuation);
    }

    public final Object createConversation(String str, CreateConversationRequestDto createConversationRequestDto, Continuation<? super ConversationResponseDto> continuation) {
        return this.sunshineConversationsApi.createConversation(str, this.appId, this.appUserId, createConversationRequestDto, continuation);
    }

    public final Object getConversation(String str, String str2, Continuation<? super ConversationResponseDto> continuation) {
        return this.sunshineConversationsApi.getConversation(str, this.appId, str2, continuation);
    }

    public final Object updateConversation(String str, String str2, UpdateConversationRequestDto updateConversationRequestDto, Continuation<? super ConversationResponseDto> continuation) {
        return this.sunshineConversationsApi.updateConversation(str, this.appId, str2, updateConversationRequestDto, continuation);
    }

    public final Object proactiveMessageReferral(String str, String str2, ProactiveMessageReferralDto proactiveMessageReferralDto, Continuation<? super ConversationResponseDto> continuation) {
        return this.sunshineConversationsApi.proactiveMessageReferral(str, this.appId, str2, proactiveMessageReferralDto, continuation);
    }

    public final Object getMessages(String str, String str2, double d, Continuation<? super MessageListResponseDto> continuation) {
        return this.sunshineConversationsApi.getMessages(str, this.appId, str2, d, continuation);
    }

    public final Object sendMessage(String str, String str2, SendMessageRequestDto sendMessageRequestDto, Continuation<? super SendMessageResponseDto> continuation) {
        return this.sunshineConversationsApi.sendMessage(str, this.appId, str2, sendMessageRequestDto, continuation);
    }

    public final Object uploadFile(String str, String str2, UploadFileDto uploadFileDto, Continuation<? super UploadFileResponseDto> continuation) throws Throwable {
        C10901 c10901;
        UserRestClient userRestClient;
        if (continuation instanceof C10901) {
            c10901 = (C10901) continuation;
            if ((c10901.label & Integer.MIN_VALUE) != 0) {
                c10901.label -= Integer.MIN_VALUE;
            } else {
                c10901 = new C10901(continuation);
            }
        } else {
            c10901 = new C10901(continuation);
        }
        C10901 c10902 = c10901;
        Object objUploadFile = c10902.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c10902.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objUploadFile);
            final File uploadFileForUri = this.restClientFiles.getUploadFileForUri(uploadFileDto.getUpload().getUri(), uploadFileDto.getUpload().getName());
            final MediaType mediaType = MediaType.INSTANCE.parse(uploadFileDto.getUpload().getMimeType());
            RequestBody requestBody = new RequestBody(uploadFileForUri, mediaType) {
                final MediaType $mediaType;
                final File $sourceFile;
                private final byte[] emptyArray = {0};
                private final long fileLength;

                {
                    this.$sourceFile = uploadFileForUri;
                    this.$mediaType = mediaType;
                    this.fileLength = uploadFileForUri.length();
                }

                @Override
                public MediaType get$mediaType() {
                    return this.$mediaType;
                }

                @Override
                public long contentLength() {
                    long j = this.fileLength;
                    return j > 0 ? j : this.emptyArray.length;
                }

                @Override
                public void writeTo(BufferedSink sink) throws IOException {
                    Intrinsics.checkNotNullParameter(sink, "sink");
                    if (this.fileLength > 0) {
                        Source source = Okio.source(this.$sourceFile);
                        try {
                            sink.writeAll(source);
                            CloseableKt.closeFinally(source, null);
                            return;
                        } catch (Throwable th) {
                            try {
                                throw th;
                            } catch (Throwable th2) {
                                CloseableKt.closeFinally(source, th);
                                throw th2;
                            }
                        }
                    }
                    sink.write(this.emptyArray);
                }
            };
            SunshineConversationsApi sunshineConversationsApi = this.sunshineConversationsApi;
            String str3 = this.appId;
            AuthorDto author = uploadFileDto.getAuthor();
            MetadataDto metadata = uploadFileDto.getMetadata();
            MultipartBody.Part partCreateFormData = MultipartBody.Part.INSTANCE.createFormData("source", uploadFileDto.getUpload().getName(), requestBody);
            c10902.L$0 = this;
            c10902.L$1 = uploadFileDto;
            c10902.label = 1;
            objUploadFile = sunshineConversationsApi.uploadFile(str, str3, str2, author, metadata, partCreateFormData, c10902);
            if (objUploadFile == coroutine_suspended) {
                return coroutine_suspended;
            }
            userRestClient = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            uploadFileDto = (UploadFileDto) c10902.L$1;
            userRestClient = (UserRestClient) c10902.L$0;
            ResultKt.throwOnFailure(objUploadFile);
        }
        UploadFileResponseDto uploadFileResponseDto = (UploadFileResponseDto) objUploadFile;
        userRestClient.restClientFiles.cleanUpUpload(uploadFileDto.getUpload().getName());
        return uploadFileResponseDto;
    }

    public final Object updatePushToken(String str, String str2, UpdatePushTokenDto updatePushTokenDto, Continuation<? super Unit> continuation) {
        Object objUpdatePushToken = this.sunshineConversationsApi.updatePushToken(str, this.appId, this.appUserId, str2, updatePushTokenDto, continuation);
        return objUpdatePushToken == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objUpdatePushToken : Unit.INSTANCE;
    }

    public final Object sendActivityData(String str, String str2, ActivityDataRequestDto activityDataRequestDto, Continuation<? super Unit> continuation) {
        Object objSendActivityData = this.sunshineConversationsApi.sendActivityData(str, this.appId, str2, activityDataRequestDto, continuation);
        return objSendActivityData == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objSendActivityData : Unit.INSTANCE;
    }

    public final Object updateAppUserLocale(String str, UpdateAppUserLocaleDto updateAppUserLocaleDto, Continuation<? super Unit> continuation) {
        Object objUpdateAppUserLocale = this.sunshineConversationsApi.updateAppUserLocale(str, this.appId, this.appUserId, updateAppUserLocaleDto, continuation);
        return objUpdateAppUserLocale == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objUpdateAppUserLocale : Unit.INSTANCE;
    }

    public final Object loginAppUser(String str, LoginRequestBody loginRequestBody, Continuation<? super AppUserResponseDto> continuation) {
        return this.sunshineConversationsApi.loginAppUser(this.appId, "Bearer " + str, loginRequestBody, continuation);
    }

    public final Object logoutAppUser(String str, String str2, LogoutRequestBody logoutRequestBody, Continuation<? super Unit> continuation) {
        Object objLogoutAppUser = this.sunshineConversationsApi.logoutAppUser(this.appId, str2, "Bearer " + str, logoutRequestBody, continuation);
        return objLogoutAppUser == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objLogoutAppUser : Unit.INSTANCE;
    }

    public final Object getConversations(String str, String str2, int i, Continuation<? super ConversationsResponseDto> continuation) {
        return this.sunshineConversationsApi.getConversations(str, this.appId, str2, i, continuation);
    }

    public final Object sendPostbackAction(String str, String str2, SendPostbackRequestDto sendPostbackRequestDto, Continuation<? super Unit> continuation) {
        Object objSendPostbackAction = this.sunshineConversationsApi.sendPostbackAction(str, this.appId, str2, sendPostbackRequestDto, continuation);
        return objSendPostbackAction == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objSendPostbackAction : Unit.INSTANCE;
    }

    public final Object getWaitTimeData(String str, String str2, Continuation<? super WaitTimeDataResponse> continuation) {
        return this.endUserExpectationsApi.getWaitTimeData(str, str2, continuation);
    }
}
