package zendesk.conversationkit.android.internal.user.data;

import j$.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.collections.MapsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import net.aihelp.common.API;
import zendesk.conversationkit.android.ConversationKitResultKt;
import zendesk.conversationkit.android.ConversationKitSettings;
import zendesk.conversationkit.android.internal.ClientDtoProvider;
import zendesk.conversationkit.android.internal.faye.SunCoFayeClient;
import zendesk.conversationkit.android.internal.rest.UserRestClient;
import zendesk.conversationkit.android.internal.rest.model.ActivityDataDto;
import zendesk.conversationkit.android.internal.rest.model.ActivityDataRequestDto;
import zendesk.conversationkit.android.internal.rest.model.AppUserResponseDto;
import zendesk.conversationkit.android.internal.rest.model.AuthorDto;
import zendesk.conversationkit.android.internal.rest.model.ClientDto;
import zendesk.conversationkit.android.internal.rest.model.ConversationResponseDto;
import zendesk.conversationkit.android.internal.rest.model.ConversationsResponseDto;
import zendesk.conversationkit.android.internal.rest.model.ConversationsResponseDtoKt;
import zendesk.conversationkit.android.internal.rest.model.CreateConversationRequestDto;
import zendesk.conversationkit.android.internal.rest.model.Intent;
import zendesk.conversationkit.android.internal.rest.model.MessageDto;
import zendesk.conversationkit.android.internal.rest.model.MessageListResponseDto;
import zendesk.conversationkit.android.internal.rest.model.MetadataDto;
import zendesk.conversationkit.android.internal.rest.model.PostbackDto;
import zendesk.conversationkit.android.internal.rest.model.ProactiveMessageReferralDto;
import zendesk.conversationkit.android.internal.rest.model.SendMessageRequestDto;
import zendesk.conversationkit.android.internal.rest.model.SendMessageResponseDto;
import zendesk.conversationkit.android.internal.rest.model.SendPostbackRequestDto;
import zendesk.conversationkit.android.internal.rest.model.UpdateAppUserLocaleDto;
import zendesk.conversationkit.android.internal.rest.model.UpdateConversationRequestDto;
import zendesk.conversationkit.android.internal.rest.model.UpdatePushTokenDto;
import zendesk.conversationkit.android.internal.rest.model.Upload;
import zendesk.conversationkit.android.internal.rest.model.UploadFileDto;
import zendesk.conversationkit.android.internal.rest.model.UploadFileResponseDto;
import zendesk.conversationkit.android.internal.rest.user.model.LoginRequestBody;
import zendesk.conversationkit.android.internal.rest.user.model.LogoutRequestBody;
import zendesk.conversationkit.android.internal.user.Jwt;
import zendesk.conversationkit.android.model.AuthenticationType;
import zendesk.conversationkit.android.model.AuthorType;
import zendesk.conversationkit.android.model.Config;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.ConversationKt;
import zendesk.conversationkit.android.model.ConversationType;
import zendesk.conversationkit.android.model.ConversationsPagination;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.MessageContent;
import zendesk.conversationkit.android.model.MessageKt;
import zendesk.conversationkit.android.model.MessageList;
import zendesk.conversationkit.android.model.MessageStatus;
import zendesk.conversationkit.android.model.User;
import zendesk.conversationkit.android.model.UserKt;
import zendesk.conversationkit.android.model.WaitTimeDataResponse;
import zendesk.faye.internal.Bayeux;
import zendesk.logger.Logger;

@Metadata(m17d1 = {"\u0000¤\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010$\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0010\u0006\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\t\b\u0000\u0018\u0000 Z2\u00020\u0001:\u0001ZB9\u0012\u0006\u0010\u0003\u001a\u00020\u0002\u0012\u0006\u0010\u0005\u001a\u00020\u0004\u0012\u0006\u0010\u0007\u001a\u00020\u0006\u0012\u0006\u0010\t\u001a\u00020\b\u0012\u0006\u0010\u000b\u001a\u00020\n\u0012\b\b\u0002\u0010\r\u001a\u00020\f¢\u0006\u0004\b\u000e\u0010\u000fJ!\u0010\u0014\u001a\u00020\u00132\u0006\u0010\u0011\u001a\u00020\u00102\b\u0010\u0012\u001a\u0004\u0018\u00010\u0010H\u0002¢\u0006\u0004\b\u0014\u0010\u0015J>\u0010\u001a\u001a\u00020\u00192\u0006\u0010\u0016\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00102\b\u0010\u0017\u001a\u0004\u0018\u00010\u00102\b\u0010\u0012\u001a\u0004\u0018\u00010\u00102\b\u0010\u0018\u001a\u0004\u0018\u00010\u0010H\u0086@¢\u0006\u0004\b\u001a\u0010\u001bJ \u0010\u001f\u001a\u00020\u00192\u0006\u0010\u001c\u001a\u00020\u00102\u0006\u0010\u001e\u001a\u00020\u001dH\u0086@¢\u0006\u0004\b\u001f\u0010 JB\u0010$\u001a\u00020#2\u0006\u0010\u001c\u001a\u00020\u00102\u0006\u0010!\u001a\u00020\u00102\u0006\u0010\u0017\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00102\b\u0010\u0012\u001a\u0004\u0018\u00010\u00102\u0006\u0010\"\u001a\u00020\u0010H\u0086@¢\u0006\u0004\b$\u0010%JP\u0010*\u001a\u00020)2\u0006\u0010\u0011\u001a\u00020\u00102\b\u0010\u0012\u001a\u0004\u0018\u00010\u00102\u0006\u0010\u001c\u001a\u00020\u00102\u0006\u0010!\u001a\u00020\u00102\u0014\u0010'\u001a\u0010\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\u0001\u0018\u00010&2\u0006\u0010(\u001a\u00020\u0010H\u0086@¢\u0006\u0004\b*\u0010+J(\u0010-\u001a\u00020#2\u0006\u0010\u001c\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00102\u0006\u0010,\u001a\u00020\u0010H\u0086@¢\u0006\u0004\b-\u0010.JB\u00100\u001a\u00020#2\u0006\u0010\u001c\u001a\u00020\u00102\u0006\u0010!\u001a\u00020\u00102\u0006\u0010\u0017\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00102\b\u0010\u0012\u001a\u0004\u0018\u00010\u00102\u0006\u0010/\u001a\u00020\u0010H\u0086@¢\u0006\u0004\b0\u0010%J\\\u00108\u001a\u0002062\u0006\u0010\u001c\u001a\u00020\u00102\u0006\u0010!\u001a\u00020\u00102\u0006\u0010\u0017\u001a\u00020\u00102\b\u00102\u001a\u0004\u0018\u0001012\u0006\u00103\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00102\b\u0010\u0012\u001a\u0004\u0018\u00010\u00102\u0006\u00105\u001a\u0002042\u0006\u00107\u001a\u000206H\u0086@¢\u0006\u0004\b8\u00109JT\u0010:\u001a\u0002062\u0006\u0010\u001c\u001a\u00020\u00102\u0006\u0010!\u001a\u00020\u00102\b\u00102\u001a\u0004\u0018\u0001012\u0006\u00103\u001a\u00020\u00102\u0006\u00107\u001a\u0002062\u0006\u0010\u0017\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00102\b\u0010\u0012\u001a\u0004\u0018\u00010\u0010H\u0086@¢\u0006\u0004\b:\u0010;JZ\u0010?\u001a\u00020)2\u0006\u0010\u001c\u001a\u00020\u00102\u0006\u0010=\u001a\u00020<2\b\u0010>\u001a\u0004\u0018\u00010\u00102\u0014\u0010'\u001a\u0010\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\u0001\u0018\u00010&2\u0006\u0010\u0011\u001a\u00020\u00102\b\u0010\u0012\u001a\u0004\u0018\u00010\u00102\u0006\u0010\u0017\u001a\u00020\u0010H\u0086@¢\u0006\u0004\b?\u0010@JD\u0010A\u001a\u00020)2\u0006\u0010\u001c\u001a\u00020\u00102\u0006\u0010!\u001a\u00020\u00102\b\u0010>\u001a\u0004\u0018\u00010\u00102\u0006\u0010\u0017\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00102\b\u0010\u0012\u001a\u0004\u0018\u00010\u0010H\u0086@¢\u0006\u0004\bA\u0010%J2\u0010B\u001a\u00020#2\u0006\u0010\u0016\u001a\u00020\u00102\u0006\u0010\u0017\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00102\b\u0010\u0012\u001a\u0004\u0018\u00010\u0010H\u0086@¢\u0006\u0004\bB\u0010CJ \u0010E\u001a\u00020#2\u0006\u0010\u001c\u001a\u00020\u00102\u0006\u0010D\u001a\u00020\u0010H\u0086@¢\u0006\u0004\bE\u0010FJ(\u0010G\u001a\u00020)2\u0006\u0010\u001c\u001a\u00020\u00102\u0006\u0010!\u001a\u00020\u00102\u0006\u0010\u0017\u001a\u00020\u0010H\u0086@¢\u0006\u0004\bG\u0010.J(\u0010K\u001a\u00020J2\u0006\u0010\u001c\u001a\u00020\u00102\u0006\u0010!\u001a\u00020\u00102\u0006\u0010I\u001a\u00020HH\u0086@¢\u0006\u0004\bK\u0010LJ(\u0010P\u001a\u00020O2\u0006\u0010\u001c\u001a\u00020\u00102\u0006\u0010\u0017\u001a\u00020\u00102\u0006\u0010N\u001a\u00020MH\u0086@¢\u0006\u0004\bP\u0010QJ \u0010S\u001a\u00020R2\u0006\u0010\u001c\u001a\u00020\u00102\u0006\u0010!\u001a\u00020\u0010H\u0086@¢\u0006\u0004\bS\u0010FR\u0014\u0010\u0003\u001a\u00020\u00028\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u0003\u0010TR\u0014\u0010\u0005\u001a\u00020\u00048\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u0005\u0010UR\u0014\u0010\u0007\u001a\u00020\u00068\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u0007\u0010VR\u0014\u0010\t\u001a\u00020\b8\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\t\u0010WR\u0014\u0010\u000b\u001a\u00020\n8\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u000b\u0010XR\u0014\u0010\r\u001a\u00020\f8\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\r\u0010Y¨\u0006["}, m18d2 = {"Lzendesk/conversationkit/android/internal/user/data/UserActionProcessorRemoteDataSource;", "", "Lzendesk/conversationkit/android/ConversationKitSettings;", "conversationKitSettings", "Lzendesk/conversationkit/android/model/Config;", "config", "Lzendesk/conversationkit/android/internal/faye/SunCoFayeClient;", "sunCoFayeClient", "Lzendesk/conversationkit/android/internal/rest/UserRestClient;", "userRestClient", "Lzendesk/conversationkit/android/internal/ClientDtoProvider;", "clientDtoProvider", "Lzendesk/conversationkit/android/internal/user/Jwt$Decoder;", "jwtDecoder", "<init>", "(Lzendesk/conversationkit/android/ConversationKitSettings;Lzendesk/conversationkit/android/model/Config;Lzendesk/conversationkit/android/internal/faye/SunCoFayeClient;Lzendesk/conversationkit/android/internal/rest/UserRestClient;Lzendesk/conversationkit/android/internal/ClientDtoProvider;Lzendesk/conversationkit/android/internal/user/Jwt$Decoder;)V", "", Bayeux.KEY_CLIENT_ID, "pushToken", "Lzendesk/conversationkit/android/internal/rest/model/ClientDto;", "buildClient", "(Ljava/lang/String;Ljava/lang/String;)Lzendesk/conversationkit/android/internal/rest/model/ClientDto;", "jwt", "appUserId", "sessionToken", "Lzendesk/conversationkit/android/model/User;", API.TOPIC_LOGIN, "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "authorization", "Lzendesk/conversationkit/android/model/AuthenticationType;", "authenticationType", "getAppUser", "(Ljava/lang/String;Lzendesk/conversationkit/android/model/AuthenticationType;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "conversationId", "actionId", "", "sendPostbackAction", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "", "metadata", "userId", "Lzendesk/conversationkit/android/model/Conversation;", "updateConversation", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "pushNotificationToken", "updatePushToken", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "activityType", "sendActivityData", "j$/time/LocalDateTime", "created", "localId", "Lzendesk/conversationkit/android/model/MessageContent$FileUpload;", "messageContent", "Lzendesk/conversationkit/android/model/Message;", "message", "uploadFile", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lj$/time/LocalDateTime;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/model/MessageContent$FileUpload;Lzendesk/conversationkit/android/model/Message;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "sendMessage", "(Ljava/lang/String;Ljava/lang/String;Lj$/time/LocalDateTime;Ljava/lang/String;Lzendesk/conversationkit/android/model/Message;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Lzendesk/conversationkit/android/model/ConversationType;", "conversationType", "signedCampaignData", "createConversation", "(Ljava/lang/String;Lzendesk/conversationkit/android/model/ConversationType;Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "proactiveMessageReferral", API.TOPIC_LOGOUT, "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "deviceLocale", "updateAppUserLocale", "(Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getConversation", "", "beforeTimestamp", "Lzendesk/conversationkit/android/model/MessageList;", "getMessages", "(Ljava/lang/String;Ljava/lang/String;DLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "", "offset", "Lzendesk/conversationkit/android/model/ConversationsPagination;", "getConversations", "(Ljava/lang/String;Ljava/lang/String;ILkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Lzendesk/conversationkit/android/model/WaitTimeDataResponse;", "fetchWaitTimeData", "Lzendesk/conversationkit/android/ConversationKitSettings;", "Lzendesk/conversationkit/android/model/Config;", "Lzendesk/conversationkit/android/internal/faye/SunCoFayeClient;", "Lzendesk/conversationkit/android/internal/rest/UserRestClient;", "Lzendesk/conversationkit/android/internal/ClientDtoProvider;", "Lzendesk/conversationkit/android/internal/user/Jwt$Decoder;", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class UserActionProcessorRemoteDataSource {
    private static final Companion Companion = new Companion(null);

    @Deprecated
    public static final String LOG_TAG = "UserActionProcessorRemoteDataSource";
    private final ClientDtoProvider clientDtoProvider;
    private final Config config;
    private final ConversationKitSettings conversationKitSettings;
    private final Jwt.Decoder jwtDecoder;
    private final SunCoFayeClient sunCoFayeClient;
    private final UserRestClient userRestClient;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRemoteDataSource", m37f = "UserActionProcessorRemoteDataSource.kt", m38i = {0}, m39l = {480}, m40m = "createConversation", m41n = {"appUserId"}, m42s = {"L$0"})
    static final class C11781 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C11781(Continuation<? super C11781> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRemoteDataSource.this.createConversation(null, null, null, null, null, null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRemoteDataSource", m37f = "UserActionProcessorRemoteDataSource.kt", m38i = {0, 0}, m39l = {146}, m40m = "getAppUser", m41n = {"this", "authenticationType"}, m42s = {"L$0", "L$1"})
    static final class C11791 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C11791(Continuation<? super C11791> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRemoteDataSource.this.getAppUser(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRemoteDataSource", m37f = "UserActionProcessorRemoteDataSource.kt", m38i = {0}, m39l = {605}, m40m = "getConversation", m41n = {"appUserId"}, m42s = {"L$0"})
    static final class C11801 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C11801(Continuation<? super C11801> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRemoteDataSource.this.getConversation(null, null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRemoteDataSource", m37f = "UserActionProcessorRemoteDataSource.kt", m38i = {0}, m39l = {664}, m40m = "getConversations", m41n = {"appUserId"}, m42s = {"L$0"})
    static final class C11811 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C11811(Continuation<? super C11811> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRemoteDataSource.this.getConversations(null, null, 0, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRemoteDataSource", m37f = "UserActionProcessorRemoteDataSource.kt", m38i = {}, m39l = {635}, m40m = "getMessages", m41n = {}, m42s = {})
    static final class C11821 extends ContinuationImpl {
        int label;
        Object result;

        C11821(Continuation<? super C11821> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRemoteDataSource.this.getMessages(null, null, 0.0d, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRemoteDataSource", m37f = "UserActionProcessorRemoteDataSource.kt", m38i = {0, 0}, m39l = {122}, m40m = API.TOPIC_LOGIN, m41n = {"this", "jwt"}, m42s = {"L$0", "L$1"})
    static final class C11831 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C11831(Continuation<? super C11831> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRemoteDataSource.this.login(null, null, null, null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRemoteDataSource", m37f = "UserActionProcessorRemoteDataSource.kt", m38i = {0}, m39l = {525}, m40m = "proactiveMessageReferral", m41n = {"appUserId"}, m42s = {"L$0"})
    static final class C11841 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C11841(Continuation<? super C11841> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRemoteDataSource.this.proactiveMessageReferral(null, null, null, null, null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRemoteDataSource", m37f = "UserActionProcessorRemoteDataSource.kt", m38i = {0, 0}, m39l = {430}, m40m = "sendMessage", m41n = {"created", "localId"}, m42s = {"L$0", "L$1"})
    static final class C11851 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C11851(Continuation<? super C11851> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRemoteDataSource.this.sendMessage(null, null, null, null, null, null, null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRemoteDataSource", m37f = "UserActionProcessorRemoteDataSource.kt", m38i = {0}, m39l = {223}, m40m = "updateConversation", m41n = {"userId"}, m42s = {"L$0"})
    static final class C11861 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C11861(Continuation<? super C11861> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRemoteDataSource.this.updateConversation(null, null, null, null, null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRemoteDataSource", m37f = "UserActionProcessorRemoteDataSource.kt", m38i = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2}, m39l = {361, 362, 383}, m40m = "uploadFile", m41n = {"this", "authorization", "conversationId", "appUserId", "created", "localId", Bayeux.KEY_CLIENT_ID, "pushToken", "messageContent", "message", "this", "created", "localId", "message", "created", "localId", "message", "uploadFileResponse"}, m42s = {"L$0", "L$1", "L$2", "L$3", "L$4", "L$5", "L$6", "L$7", "L$8", "L$9", "L$0", "L$1", "L$2", "L$3", "L$0", "L$1", "L$2", "L$3"})
    static final class C11871 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        Object L$5;
        Object L$6;
        Object L$7;
        Object L$8;
        Object L$9;
        int label;
        Object result;

        C11871(Continuation<? super C11871> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRemoteDataSource.this.uploadFile(null, null, null, null, null, null, null, null, null, this);
        }
    }

    public UserActionProcessorRemoteDataSource(ConversationKitSettings conversationKitSettings, Config config, SunCoFayeClient sunCoFayeClient, UserRestClient userRestClient, ClientDtoProvider clientDtoProvider, Jwt.Decoder jwtDecoder) {
        Intrinsics.checkNotNullParameter(conversationKitSettings, "conversationKitSettings");
        Intrinsics.checkNotNullParameter(config, "config");
        Intrinsics.checkNotNullParameter(sunCoFayeClient, "sunCoFayeClient");
        Intrinsics.checkNotNullParameter(userRestClient, "userRestClient");
        Intrinsics.checkNotNullParameter(clientDtoProvider, "clientDtoProvider");
        Intrinsics.checkNotNullParameter(jwtDecoder, "jwtDecoder");
        this.conversationKitSettings = conversationKitSettings;
        this.config = config;
        this.sunCoFayeClient = sunCoFayeClient;
        this.userRestClient = userRestClient;
        this.clientDtoProvider = clientDtoProvider;
        this.jwtDecoder = jwtDecoder;
    }

    public UserActionProcessorRemoteDataSource(ConversationKitSettings conversationKitSettings, Config config, SunCoFayeClient sunCoFayeClient, UserRestClient userRestClient, ClientDtoProvider clientDtoProvider, Jwt.Decoder decoder, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(conversationKitSettings, config, sunCoFayeClient, userRestClient, clientDtoProvider, (i & 32) != 0 ? new Jwt.Decoder() : decoder);
    }

    public final Object login(String str, String str2, String str3, String str4, String str5, Continuation<? super User> continuation) throws Throwable {
        C11831 c11831;
        LoginRequestBody loginRequestBody;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource;
        String str6 = str;
        if (continuation instanceof C11831) {
            c11831 = (C11831) continuation;
            if ((c11831.label & Integer.MIN_VALUE) != 0) {
                c11831.label -= Integer.MIN_VALUE;
            } else {
                c11831 = new C11831(continuation);
            }
        } else {
            c11831 = new C11831(continuation);
        }
        Object objLoginAppUser = c11831.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11831.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objLoginAppUser);
            ClientDto clientDtoBuildClient = buildClient(str2, str4);
            if (str5 == null) {
                Logger.m217d(LOG_TAG, "Building login request... [merge=false]", new Object[0]);
                loginRequestBody = new LoginRequestBody(((Jwt) ConversationKitResultKt.getOrThrow(this.jwtDecoder.decode(str6))).getExternalId(), clientDtoBuildClient, (String) null, (String) null, 12, (DefaultConstructorMarker) null);
            } else {
                Logger.m217d(LOG_TAG, "Building login request... [merge=true]", new Object[0]);
                loginRequestBody = new LoginRequestBody(((Jwt) ConversationKitResultKt.getOrThrow(this.jwtDecoder.decode(str6))).getExternalId(), clientDtoBuildClient, str3, str5);
            }
            UserRestClient userRestClient = this.userRestClient;
            c11831.L$0 = this;
            c11831.L$1 = str6;
            c11831.label = 1;
            objLoginAppUser = userRestClient.loginAppUser(str6, loginRequestBody, c11831);
            if (objLoginAppUser == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessorRemoteDataSource = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            str6 = (String) c11831.L$1;
            userActionProcessorRemoteDataSource = (UserActionProcessorRemoteDataSource) c11831.L$0;
            ResultKt.throwOnFailure(objLoginAppUser);
        }
        return UserKt.toUser((AppUserResponseDto) objLoginAppUser, userActionProcessorRemoteDataSource.config.getApp().getId(), new AuthenticationType.Jwt(str6));
    }

    public final Object getAppUser(String str, AuthenticationType authenticationType, Continuation<? super User> continuation) throws Throwable {
        C11791 c11791;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource;
        if (continuation instanceof C11791) {
            c11791 = (C11791) continuation;
            if ((c11791.label & Integer.MIN_VALUE) != 0) {
                c11791.label -= Integer.MIN_VALUE;
            } else {
                c11791 = new C11791(continuation);
            }
        } else {
            c11791 = new C11791(continuation);
        }
        Object appUser = c11791.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11791.label;
        if (i == 0) {
            ResultKt.throwOnFailure(appUser);
            UserRestClient userRestClient = this.userRestClient;
            c11791.L$0 = this;
            c11791.L$1 = authenticationType;
            c11791.label = 1;
            appUser = userRestClient.getAppUser(str, c11791);
            if (appUser == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessorRemoteDataSource = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            authenticationType = (AuthenticationType) c11791.L$1;
            userActionProcessorRemoteDataSource = (UserActionProcessorRemoteDataSource) c11791.L$0;
            ResultKt.throwOnFailure(appUser);
        }
        return UserKt.toUser((AppUserResponseDto) appUser, userActionProcessorRemoteDataSource.config.getApp().getId(), authenticationType);
    }

    public final Object sendPostbackAction(String str, String str2, String str3, String str4, String str5, String str6, Continuation<? super Unit> continuation) {
        Object objSendPostbackAction = this.userRestClient.sendPostbackAction(str, str2, new SendPostbackRequestDto(new AuthorDto(str3, AuthorType.USER.getValue(), buildClient(str4, str5), (String) null, 8, (DefaultConstructorMarker) null), new PostbackDto(str6)), continuation);
        return objSendPostbackAction == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objSendPostbackAction : Unit.INSTANCE;
    }

    public final Object updateConversation(String str, String str2, String str3, String str4, Map<String, ? extends Object> map, String str5, Continuation<? super Conversation> continuation) {
        C11861 c11861;
        if (continuation instanceof C11861) {
            c11861 = (C11861) continuation;
            if ((c11861.label & Integer.MIN_VALUE) != 0) {
                c11861.label -= Integer.MIN_VALUE;
            } else {
                c11861 = new C11861(continuation);
            }
        } else {
            c11861 = new C11861(continuation);
        }
        Object objUpdateConversation = c11861.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11861.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objUpdateConversation);
            UserRestClient userRestClient = this.userRestClient;
            UpdateConversationRequestDto updateConversationRequestDto = new UpdateConversationRequestDto(buildClient(str, str2), map);
            c11861.L$0 = str5;
            c11861.label = 1;
            objUpdateConversation = userRestClient.updateConversation(str3, str4, updateConversationRequestDto, c11861);
            if (objUpdateConversation == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            str5 = (String) c11861.L$0;
            ResultKt.throwOnFailure(objUpdateConversation);
        }
        return ConversationKt.enrichFormResponseFields(ConversationKt.toConversation((ConversationResponseDto) objUpdateConversation, str5));
    }

    private final ClientDto buildClient(String clientId, String pushToken) {
        return this.clientDtoProvider.buildClient(this.conversationKitSettings.getIntegrationId(), clientId, pushToken);
    }

    public final Object updatePushToken(String str, String str2, String str3, Continuation<? super Unit> continuation) {
        Object objUpdatePushToken = this.userRestClient.updatePushToken(str, str2, new UpdatePushTokenDto(str3, this.conversationKitSettings.getIntegrationId()), continuation);
        return objUpdatePushToken == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objUpdatePushToken : Unit.INSTANCE;
    }

    public final Object sendActivityData(String str, String str2, String str3, String str4, String str5, String str6, Continuation<? super Unit> continuation) {
        Object objSendActivityData = this.userRestClient.sendActivityData(str, str2, new ActivityDataRequestDto(new AuthorDto(str3, AuthorType.USER.getValue(), buildClient(str4, str5), (String) null, 8, (DefaultConstructorMarker) null), new ActivityDataDto(str6)), continuation);
        return objSendActivityData == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objSendActivityData : Unit.INSTANCE;
    }

    public final Object uploadFile(String str, String str2, String str3, LocalDateTime localDateTime, String str4, String str5, String str6, MessageContent.FileUpload fileUpload, Message message, Continuation<? super Message> continuation) {
        C11871 c11871;
        String str7;
        String str8;
        LocalDateTime localDateTime2;
        String str9;
        String str10;
        String str11;
        Message message2;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource;
        MessageContent.FileUpload fileUpload2;
        String str12;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource2;
        LocalDateTime localDateTime3;
        String str13;
        Message message3;
        UploadFileResponseDto uploadFileResponseDto;
        UploadFileResponseDto uploadFileResponseDto2;
        Object objAwaitFileUploadResult;
        UploadFileResponseDto uploadFileResponseDto3;
        Message message4;
        String str14;
        LocalDateTime localDateTime4;
        if (continuation instanceof C11871) {
            c11871 = (C11871) continuation;
            if ((c11871.label & Integer.MIN_VALUE) != 0) {
                c11871.label -= Integer.MIN_VALUE;
            } else {
                c11871 = new C11871(continuation);
            }
        } else {
            c11871 = new C11871(continuation);
        }
        Object obj = c11871.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11871.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                SunCoFayeClient sunCoFayeClient = this.sunCoFayeClient;
                c11871.L$0 = this;
                c11871.L$1 = str;
                str7 = str2;
                c11871.L$2 = str7;
                str8 = str3;
                c11871.L$3 = str8;
                localDateTime2 = localDateTime;
                c11871.L$4 = localDateTime2;
                str9 = str4;
                c11871.L$5 = str9;
                str10 = str5;
                c11871.L$6 = str10;
                str11 = str6;
                c11871.L$7 = str11;
                c11871.L$8 = fileUpload;
                message2 = message;
                c11871.L$9 = message2;
                c11871.label = 1;
                if (sunCoFayeClient.awaitClientConnected(c11871) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRemoteDataSource = this;
                fileUpload2 = fileUpload;
                str12 = str;
            } else {
                if (i != 1) {
                    if (i != 2) {
                        if (i != 3) {
                            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                        }
                        uploadFileResponseDto2 = (UploadFileResponseDto) c11871.L$3;
                        message3 = (Message) c11871.L$2;
                        String str15 = (String) c11871.L$1;
                        LocalDateTime localDateTime5 = (LocalDateTime) c11871.L$0;
                        try {
                            ResultKt.throwOnFailure(obj);
                            uploadFileResponseDto3 = uploadFileResponseDto2;
                            message4 = message3;
                            str14 = str15;
                            localDateTime4 = localDateTime5;
                            try {
                                Message message5 = (Message) obj;
                                return message5.copy((2021 & 1) != 0 ? message5.id : null, (2021 & 2) != 0 ? message5.author : null, (2021 & 4) != 0 ? message5.status : null, (2021 & 8) != 0 ? message5.created : localDateTime4, (2021 & 16) != 0 ? message5.received : null, (2021 & 32) != 0 ? message5.beforeTimestamp : 0.0d, (2021 & 64) != 0 ? message5.content : null, (2021 & 128) != 0 ? message5.metadata : null, (2021 & 256) != 0 ? message5.sourceId : null, (2021 & 512) != 0 ? message5.localId : str14, (2021 & 1024) != 0 ? message5.payload : null);
                            } catch (Exception unused) {
                                uploadFileResponseDto2 = uploadFileResponseDto3;
                                message3 = message4;
                                return message3.copy((2021 & 1) != 0 ? message3.id : uploadFileResponseDto2.getMessageId(), (2021 & 2) != 0 ? message3.author : null, (2021 & 4) != 0 ? message3.status : null, (2021 & 8) != 0 ? message3.created : null, (2021 & 16) != 0 ? message3.received : null, (2021 & 32) != 0 ? message3.beforeTimestamp : 0.0d, (2021 & 64) != 0 ? message3.content : null, (2021 & 128) != 0 ? message3.metadata : null, (2021 & 256) != 0 ? message3.sourceId : null, (2021 & 512) != 0 ? message3.localId : null, (2021 & 1024) != 0 ? message3.payload : null);
                            }
                        } catch (Exception unused2) {
                            return message3.copy((2021 & 1) != 0 ? message3.id : uploadFileResponseDto2.getMessageId(), (2021 & 2) != 0 ? message3.author : null, (2021 & 4) != 0 ? message3.status : null, (2021 & 8) != 0 ? message3.created : null, (2021 & 16) != 0 ? message3.received : null, (2021 & 32) != 0 ? message3.beforeTimestamp : 0.0d, (2021 & 64) != 0 ? message3.content : null, (2021 & 128) != 0 ? message3.metadata : null, (2021 & 256) != 0 ? message3.sourceId : null, (2021 & 512) != 0 ? message3.localId : null, (2021 & 1024) != 0 ? message3.payload : null);
                        }
                    }
                    message3 = (Message) c11871.L$3;
                    String str16 = (String) c11871.L$2;
                    localDateTime3 = (LocalDateTime) c11871.L$1;
                    userActionProcessorRemoteDataSource2 = (UserActionProcessorRemoteDataSource) c11871.L$0;
                    ResultKt.throwOnFailure(obj);
                    str13 = str16;
                    uploadFileResponseDto = (UploadFileResponseDto) obj;
                    try {
                        SunCoFayeClient sunCoFayeClient2 = userActionProcessorRemoteDataSource2.sunCoFayeClient;
                        String messageId = uploadFileResponseDto.getMessageId();
                        c11871.L$0 = localDateTime3;
                        c11871.L$1 = str13;
                        c11871.L$2 = message3;
                        c11871.L$3 = uploadFileResponseDto;
                        c11871.label = 3;
                        objAwaitFileUploadResult = sunCoFayeClient2.awaitFileUploadResult(messageId, c11871);
                        if (objAwaitFileUploadResult == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        uploadFileResponseDto3 = uploadFileResponseDto;
                        obj = objAwaitFileUploadResult;
                        message4 = message3;
                        str14 = str13;
                        localDateTime4 = localDateTime3;
                        Message message6 = (Message) obj;
                        return message6.copy((2021 & 1) != 0 ? message6.id : null, (2021 & 2) != 0 ? message6.author : null, (2021 & 4) != 0 ? message6.status : null, (2021 & 8) != 0 ? message6.created : localDateTime4, (2021 & 16) != 0 ? message6.received : null, (2021 & 32) != 0 ? message6.beforeTimestamp : 0.0d, (2021 & 64) != 0 ? message6.content : null, (2021 & 128) != 0 ? message6.metadata : null, (2021 & 256) != 0 ? message6.sourceId : null, (2021 & 512) != 0 ? message6.localId : str14, (2021 & 1024) != 0 ? message6.payload : null);
                    } catch (Exception unused3) {
                        uploadFileResponseDto2 = uploadFileResponseDto;
                        return message3.copy((2021 & 1) != 0 ? message3.id : uploadFileResponseDto2.getMessageId(), (2021 & 2) != 0 ? message3.author : null, (2021 & 4) != 0 ? message3.status : null, (2021 & 8) != 0 ? message3.created : null, (2021 & 16) != 0 ? message3.received : null, (2021 & 32) != 0 ? message3.beforeTimestamp : 0.0d, (2021 & 64) != 0 ? message3.content : null, (2021 & 128) != 0 ? message3.metadata : null, (2021 & 256) != 0 ? message3.sourceId : null, (2021 & 512) != 0 ? message3.localId : null, (2021 & 1024) != 0 ? message3.payload : null);
                    }
                }
                Message message7 = (Message) c11871.L$9;
                fileUpload2 = (MessageContent.FileUpload) c11871.L$8;
                String str17 = (String) c11871.L$7;
                String str18 = (String) c11871.L$6;
                String str19 = (String) c11871.L$5;
                LocalDateTime localDateTime6 = (LocalDateTime) c11871.L$4;
                String str20 = (String) c11871.L$3;
                String str21 = (String) c11871.L$2;
                str12 = (String) c11871.L$1;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource3 = (UserActionProcessorRemoteDataSource) c11871.L$0;
                ResultKt.throwOnFailure(obj);
                userActionProcessorRemoteDataSource = userActionProcessorRemoteDataSource3;
                message2 = message7;
                str11 = str17;
                str7 = str21;
                str10 = str18;
                str8 = str20;
                str9 = str19;
                localDateTime2 = localDateTime6;
            }
            UserRestClient userRestClient = userActionProcessorRemoteDataSource.userRestClient;
            UploadFileDto uploadFileDto = new UploadFileDto(new AuthorDto(str8, AuthorType.USER.getValue(), userActionProcessorRemoteDataSource.buildClient(str10, str11), str9), new MetadataDto(MapsKt.emptyMap()), new Upload(fileUpload2.getUri(), fileUpload2.getName(), fileUpload2.getSize(), fileUpload2.getMimeType()));
            c11871.L$0 = userActionProcessorRemoteDataSource;
            c11871.L$1 = localDateTime2;
            c11871.L$2 = str9;
            c11871.L$3 = message2;
            c11871.L$4 = null;
            c11871.L$5 = null;
            c11871.L$6 = null;
            c11871.L$7 = null;
            c11871.L$8 = null;
            c11871.L$9 = null;
            c11871.label = 2;
            Object objUploadFile = userRestClient.uploadFile(str12, str7, uploadFileDto, c11871);
            if (objUploadFile == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource;
            obj = objUploadFile;
            localDateTime3 = localDateTime2;
            str13 = str9;
            message3 = message2;
            uploadFileResponseDto = (UploadFileResponseDto) obj;
            SunCoFayeClient sunCoFayeClient3 = userActionProcessorRemoteDataSource2.sunCoFayeClient;
            String messageId2 = uploadFileResponseDto.getMessageId();
            c11871.L$0 = localDateTime3;
            c11871.L$1 = str13;
            c11871.L$2 = message3;
            c11871.L$3 = uploadFileResponseDto;
            c11871.label = 3;
            objAwaitFileUploadResult = sunCoFayeClient3.awaitFileUploadResult(messageId2, c11871);
            if (objAwaitFileUploadResult == coroutine_suspended) {
                return coroutine_suspended;
            }
            uploadFileResponseDto3 = uploadFileResponseDto;
            obj = objAwaitFileUploadResult;
            message4 = message3;
            str14 = str13;
            localDateTime4 = localDateTime3;
            Message message8 = (Message) obj;
            return message8.copy((2021 & 1) != 0 ? message8.id : null, (2021 & 2) != 0 ? message8.author : null, (2021 & 4) != 0 ? message8.status : null, (2021 & 8) != 0 ? message8.created : localDateTime4, (2021 & 16) != 0 ? message8.received : null, (2021 & 32) != 0 ? message8.beforeTimestamp : 0.0d, (2021 & 64) != 0 ? message8.content : null, (2021 & 128) != 0 ? message8.metadata : null, (2021 & 256) != 0 ? message8.sourceId : null, (2021 & 512) != 0 ? message8.localId : str14, (2021 & 1024) != 0 ? message8.payload : null);
        } catch (UnsupportedOperationException e) {
            throw e;
        }
    }

    public final Object sendMessage(String str, String str2, LocalDateTime localDateTime, String str3, Message message, String str4, String str5, String str6, Continuation<? super Message> continuation) {
        C11851 c11851;
        LocalDateTime localDateTime2;
        String str7;
        if (continuation instanceof C11851) {
            c11851 = (C11851) continuation;
            if ((c11851.label & Integer.MIN_VALUE) != 0) {
                c11851.label -= Integer.MIN_VALUE;
            } else {
                c11851 = new C11851(continuation);
            }
        } else {
            c11851 = new C11851(continuation);
        }
        Object objSendMessage = c11851.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11851.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objSendMessage);
            UserRestClient userRestClient = this.userRestClient;
            SendMessageRequestDto sendMessageRequestDto = new SendMessageRequestDto(new AuthorDto(str4, AuthorType.USER.getValue(), buildClient(str5, str6), message.getLocalId()), MessageKt.toSendMessageDto(message));
            localDateTime2 = localDateTime;
            c11851.L$0 = localDateTime2;
            str7 = str3;
            c11851.L$1 = str7;
            c11851.label = 1;
            objSendMessage = userRestClient.sendMessage(str, str2, sendMessageRequestDto, c11851);
            if (objSendMessage == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            String str8 = (String) c11851.L$1;
            LocalDateTime localDateTime3 = (LocalDateTime) c11851.L$0;
            ResultKt.throwOnFailure(objSendMessage);
            localDateTime2 = localDateTime3;
            str7 = str8;
        }
        Message message2 = MessageKt.toMessage((MessageDto) CollectionsKt.first((List) ((SendMessageResponseDto) objSendMessage).getMessages()), localDateTime2, str7);
        return message2.copy((2021 & 1) != 0 ? message2.id : null, (2021 & 2) != 0 ? message2.author : null, (2021 & 4) != 0 ? message2.status : new MessageStatus.Sent(null, 1, null), (2021 & 8) != 0 ? message2.created : null, (2021 & 16) != 0 ? message2.received : null, (2021 & 32) != 0 ? message2.beforeTimestamp : 0.0d, (2021 & 64) != 0 ? message2.content : null, (2021 & 128) != 0 ? message2.metadata : null, (2021 & 256) != 0 ? message2.sourceId : null, (2021 & 512) != 0 ? message2.localId : null, (2021 & 1024) != 0 ? message2.payload : null);
    }

    public final Object createConversation(String str, ConversationType conversationType, String str2, Map<String, ? extends Object> map, String str3, String str4, String str5, Continuation<? super Conversation> continuation) {
        C11781 c11781;
        String str6;
        if (continuation instanceof C11781) {
            c11781 = (C11781) continuation;
            if ((c11781.label & Integer.MIN_VALUE) != 0) {
                c11781.label -= Integer.MIN_VALUE;
            } else {
                c11781 = new C11781(continuation);
            }
        } else {
            c11781 = new C11781(continuation);
        }
        Object objCreateConversation = c11781.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11781.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objCreateConversation);
            UserRestClient userRestClient = this.userRestClient;
            String str7 = str2;
            CreateConversationRequestDto createConversationRequestDto = new CreateConversationRequestDto(conversationType, (str7 == null || str7.length() == 0) ? Intent.CONVERSATION_START : Intent.PROACTIVE, buildClient(str3, str4), str2, (List) null, (PostbackDto) null, map, 48, (DefaultConstructorMarker) null);
            c11781.L$0 = str5;
            c11781.label = 1;
            objCreateConversation = userRestClient.createConversation(str, createConversationRequestDto, c11781);
            if (objCreateConversation == coroutine_suspended) {
                return coroutine_suspended;
            }
            str6 = str5;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            str6 = (String) c11781.L$0;
            ResultKt.throwOnFailure(objCreateConversation);
        }
        return ConversationKt.enrichFormResponseFields(ConversationKt.toConversation((ConversationResponseDto) objCreateConversation, str6));
    }

    public final Object proactiveMessageReferral(String str, String str2, String str3, String str4, String str5, String str6, Continuation<? super Conversation> continuation) throws Throwable {
        C11841 c11841;
        String str7;
        if (continuation instanceof C11841) {
            c11841 = (C11841) continuation;
            if ((c11841.label & Integer.MIN_VALUE) != 0) {
                c11841.label -= Integer.MIN_VALUE;
            } else {
                c11841 = new C11841(continuation);
            }
        } else {
            c11841 = new C11841(continuation);
        }
        Object objProactiveMessageReferral = c11841.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11841.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objProactiveMessageReferral);
            UserRestClient userRestClient = this.userRestClient;
            ProactiveMessageReferralDto proactiveMessageReferralDto = new ProactiveMessageReferralDto(str3, (List) null, (PostbackDto) null, new AuthorDto(str4, AuthorType.USER.getValue(), buildClient(str5, str6), (String) null, 8, (DefaultConstructorMarker) null), (Intent) null, 22, (DefaultConstructorMarker) null);
            c11841.L$0 = str4;
            c11841.label = 1;
            objProactiveMessageReferral = userRestClient.proactiveMessageReferral(str, str2, proactiveMessageReferralDto, c11841);
            if (objProactiveMessageReferral == coroutine_suspended) {
                return coroutine_suspended;
            }
            str7 = str4;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            str7 = (String) c11841.L$0;
            ResultKt.throwOnFailure(objProactiveMessageReferral);
        }
        return ConversationKt.enrichFormResponseFields(ConversationKt.toConversation((ConversationResponseDto) objProactiveMessageReferral, str7));
    }

    public final Object logout(String str, String str2, String str3, String str4, Continuation<? super Unit> continuation) {
        Object objLogoutAppUser = this.userRestClient.logoutAppUser(str, str2, new LogoutRequestBody(buildClient(str3, str4)), continuation);
        return objLogoutAppUser == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objLogoutAppUser : Unit.INSTANCE;
    }

    public final Object updateAppUserLocale(String str, String str2, Continuation<? super Unit> continuation) {
        Object objUpdateAppUserLocale = this.userRestClient.updateAppUserLocale(str, new UpdateAppUserLocaleDto(str2), continuation);
        return objUpdateAppUserLocale == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objUpdateAppUserLocale : Unit.INSTANCE;
    }

    public final Object getConversation(String str, String str2, String str3, Continuation<? super Conversation> continuation) throws Throwable {
        C11801 c11801;
        if (continuation instanceof C11801) {
            c11801 = (C11801) continuation;
            if ((c11801.label & Integer.MIN_VALUE) != 0) {
                c11801.label -= Integer.MIN_VALUE;
            } else {
                c11801 = new C11801(continuation);
            }
        } else {
            c11801 = new C11801(continuation);
        }
        Object conversation = c11801.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11801.label;
        if (i == 0) {
            ResultKt.throwOnFailure(conversation);
            UserRestClient userRestClient = this.userRestClient;
            c11801.L$0 = str3;
            c11801.label = 1;
            conversation = userRestClient.getConversation(str, str2, c11801);
            if (conversation == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            str3 = (String) c11801.L$0;
            ResultKt.throwOnFailure(conversation);
        }
        return ConversationKt.enrichFormResponseFields(ConversationKt.toConversation((ConversationResponseDto) conversation, str3));
    }

    public final Object getMessages(String str, String str2, double d, Continuation<? super MessageList> continuation) throws Throwable {
        C11821 c11821;
        if (continuation instanceof C11821) {
            c11821 = (C11821) continuation;
            if ((c11821.label & Integer.MIN_VALUE) != 0) {
                c11821.label -= Integer.MIN_VALUE;
            } else {
                c11821 = new C11821(continuation);
            }
        } else {
            c11821 = new C11821(continuation);
        }
        C11821 c11822 = c11821;
        Object messages = c11822.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11822.label;
        if (i == 0) {
            ResultKt.throwOnFailure(messages);
            UserRestClient userRestClient = this.userRestClient;
            c11822.label = 1;
            messages = userRestClient.getMessages(str, str2, d, c11822);
            if (messages == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(messages);
        }
        return MessageKt.toMessageList((MessageListResponseDto) messages);
    }

    public final Object getConversations(String str, String str2, int i, Continuation<? super ConversationsPagination> continuation) throws Throwable {
        C11811 c11811;
        if (continuation instanceof C11811) {
            c11811 = (C11811) continuation;
            if ((c11811.label & Integer.MIN_VALUE) != 0) {
                c11811.label -= Integer.MIN_VALUE;
            } else {
                c11811 = new C11811(continuation);
            }
        } else {
            c11811 = new C11811(continuation);
        }
        Object conversations = c11811.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i2 = c11811.label;
        if (i2 == 0) {
            ResultKt.throwOnFailure(conversations);
            UserRestClient userRestClient = this.userRestClient;
            c11811.L$0 = str2;
            c11811.label = 1;
            conversations = userRestClient.getConversations(str, str2, i, c11811);
            if (conversations == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i2 != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            str2 = (String) c11811.L$0;
            ResultKt.throwOnFailure(conversations);
        }
        return ConversationsResponseDtoKt.toConversationsPagination((ConversationsResponseDto) conversations, str2);
    }

    public final Object fetchWaitTimeData(String str, String str2, Continuation<? super WaitTimeDataResponse> continuation) {
        return this.userRestClient.getWaitTimeData(str, str2, continuation);
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000¨\u0006\u0005"}, m18d2 = {"Lzendesk/conversationkit/android/internal/user/data/UserActionProcessorRemoteDataSource$Companion;", "", "()V", "LOG_TAG", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
