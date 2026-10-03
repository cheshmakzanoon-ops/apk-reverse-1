package zendesk.conversationkit.android.internal.app;

import cz.msebera.android.httpclient.HttpStatus;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CancellationException;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.SerializationException;
import retrofit2.HttpException;
import zendesk.conversationkit.android.ConversationKitResult;
import zendesk.conversationkit.android.ConversationKitResultKt;
import zendesk.conversationkit.android.ConversationKitSettings;
import zendesk.conversationkit.android.internal.Action;
import zendesk.conversationkit.android.internal.ActionProcessor;
import zendesk.conversationkit.android.internal.ClientDtoProvider;
import zendesk.conversationkit.android.internal.ConversationKitStorage;
import zendesk.conversationkit.android.internal.Effect;
import zendesk.conversationkit.android.internal.exception.JwtIsExpiredException;
import zendesk.conversationkit.android.internal.extension.AuthenticatedUserUtilKt;
import zendesk.conversationkit.android.internal.metadata.MetadataManager;
import zendesk.conversationkit.android.internal.proactivemessaging.ProactiveMessagingStorage;
import zendesk.conversationkit.android.internal.rest.AppRestClient;
import zendesk.conversationkit.android.internal.rest.model.AppUserRequestDto;
import zendesk.conversationkit.android.internal.rest.model.AppUserResponseDto;
import zendesk.conversationkit.android.internal.rest.model.ClientDto;
import zendesk.conversationkit.android.internal.rest.model.CreateConversationRequestDto;
import zendesk.conversationkit.android.internal.rest.model.Intent;
import zendesk.conversationkit.android.internal.rest.model.PostbackDto;
import zendesk.conversationkit.android.internal.rest.user.model.LoginRequestBody;
import zendesk.conversationkit.android.internal.user.Jwt;
import zendesk.conversationkit.android.model.AuthenticationType;
import zendesk.conversationkit.android.model.Config;
import zendesk.conversationkit.android.model.ConversationType;
import zendesk.conversationkit.android.model.ProactiveMessage;
import zendesk.conversationkit.android.model.User;
import zendesk.conversationkit.android.model.UserKt;
import zendesk.conversationkit.android.model.VisitType;
import zendesk.logger.Logger;

@Metadata(m17d1 = {"\u0000Ö\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010$\n\u0002\u0010\u000e\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0000\u0018\u0000 Q2\u00020\u0001:\u0001QBO\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\u0006\u0010\n\u001a\u00020\u000b\u0012\u0006\u0010\f\u001a\u00020\r\u0012\u0006\u0010\u000e\u001a\u00020\u000f\u0012\u0006\u0010\u0010\u001a\u00020\u0011\u0012\b\b\u0002\u0010\u0012\u001a\u00020\u0013¢\u0006\u0002\u0010\u0014J \u0010\u0015\u001a\u0004\u0018\u00010\u00162\u0006\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u001aH\u0082@¢\u0006\u0002\u0010\u001bJ8\u0010\u001c\u001a\u00020\u00162\b\b\u0002\u0010\u001d\u001a\u00020\u001e2\u0006\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u001a2\u0014\u0010\u001f\u001a\u0010\u0012\u0004\u0012\u00020!\u0012\u0004\u0012\u00020\"\u0018\u00010 H\u0002J\u0016\u0010#\u001a\u00020$2\u0006\u0010%\u001a\u00020&H\u0082@¢\u0006\u0002\u0010'J\u000e\u0010(\u001a\u00020$H\u0082@¢\u0006\u0002\u0010)J\u0016\u0010*\u001a\u00020$2\u0006\u0010%\u001a\u00020+H\u0082@¢\u0006\u0002\u0010,J\u001a\u0010-\u001a\u0004\u0018\u00010!2\b\u0010.\u001a\u0004\u0018\u00010/H\u0082@¢\u0006\u0002\u00100J\u0016\u00101\u001a\u00020$2\u0006\u0010%\u001a\u000202H\u0082@¢\u0006\u0002\u00103J\u0016\u00104\u001a\u00020$2\u0006\u0010%\u001a\u000205H\u0096@¢\u0006\u0002\u00106J\u0016\u00107\u001a\u00020$2\u0006\u0010%\u001a\u000208H\u0082@¢\u0006\u0002\u00109J\u0016\u0010:\u001a\u00020$2\u0006\u0010%\u001a\u00020;H\u0082@¢\u0006\u0002\u0010<J\u0016\u0010=\u001a\u00020$2\u0006\u0010%\u001a\u00020>H\u0082@¢\u0006\u0002\u0010?J\u000e\u0010@\u001a\u00020$H\u0082@¢\u0006\u0002\u0010)J\u0016\u0010A\u001a\u00020$2\u0006\u0010%\u001a\u00020BH\u0082@¢\u0006\u0002\u0010CJ\u000e\u0010D\u001a\u00020$H\u0082@¢\u0006\u0002\u0010)J\u0016\u0010E\u001a\u00020$2\u0006\u0010%\u001a\u00020FH\u0082@¢\u0006\u0002\u0010GJ\u000e\u0010H\u001a\u00020$H\u0082@¢\u0006\u0002\u0010)J\u0016\u0010I\u001a\u00020$2\u0006\u0010%\u001a\u00020JH\u0082@¢\u0006\u0002\u0010KJ\u0010\u0010L\u001a\u00020$2\u0006\u0010%\u001a\u00020MH\u0002J\u0016\u0010N\u001a\u00020$2\u0006\u0010%\u001a\u00020OH\u0082@¢\u0006\u0002\u0010PR\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u000bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0012\u001a\u00020\u0013X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0010\u001a\u00020\u0011X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u000fX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006R"}, m18d2 = {"Lzendesk/conversationkit/android/internal/app/AppActionProcessor;", "Lzendesk/conversationkit/android/internal/ActionProcessor;", "conversationKitSettings", "Lzendesk/conversationkit/android/ConversationKitSettings;", "config", "Lzendesk/conversationkit/android/model/Config;", "appRestClient", "Lzendesk/conversationkit/android/internal/rest/AppRestClient;", "clientDtoProvider", "Lzendesk/conversationkit/android/internal/ClientDtoProvider;", "appStorage", "Lzendesk/conversationkit/android/internal/app/AppStorage;", "conversationKitStorage", "Lzendesk/conversationkit/android/internal/ConversationKitStorage;", "proactiveMessagingStorage", "Lzendesk/conversationkit/android/internal/proactivemessaging/ProactiveMessagingStorage;", "metadataManager", "Lzendesk/conversationkit/android/internal/metadata/MetadataManager;", "jwtDecoder", "Lzendesk/conversationkit/android/internal/user/Jwt$Decoder;", "(Lzendesk/conversationkit/android/ConversationKitSettings;Lzendesk/conversationkit/android/model/Config;Lzendesk/conversationkit/android/internal/rest/AppRestClient;Lzendesk/conversationkit/android/internal/ClientDtoProvider;Lzendesk/conversationkit/android/internal/app/AppStorage;Lzendesk/conversationkit/android/internal/ConversationKitStorage;Lzendesk/conversationkit/android/internal/proactivemessaging/ProactiveMessagingStorage;Lzendesk/conversationkit/android/internal/metadata/MetadataManager;Lzendesk/conversationkit/android/internal/user/Jwt$Decoder;)V", "appendMetadataToDefaultConversation", "Lzendesk/conversationkit/android/internal/rest/model/CreateConversationRequestDto;", "client", "Lzendesk/conversationkit/android/internal/rest/model/ClientDto;", "intent", "Lzendesk/conversationkit/android/internal/rest/model/Intent;", "(Lzendesk/conversationkit/android/internal/rest/model/ClientDto;Lzendesk/conversationkit/android/internal/rest/model/Intent;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "buildCreateConversationRequestDto", "type", "Lzendesk/conversationkit/android/model/ConversationType;", "metadata", "", "", "", "cacheIntegrationId", "Lzendesk/conversationkit/android/internal/Effect;", "action", "Lzendesk/conversationkit/android/internal/Action$PushCacheIntegrationId;", "(Lzendesk/conversationkit/android/internal/Action$PushCacheIntegrationId;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "checkForPersistedUser", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "createUser", "Lzendesk/conversationkit/android/internal/Action$CreateUser;", "(Lzendesk/conversationkit/android/internal/Action$CreateUser;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getProactiveCampaignData", "proactiveMessageId", "", "(Ljava/lang/Integer;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "preparePushToken", "Lzendesk/conversationkit/android/internal/Action$PreparePushToken;", "(Lzendesk/conversationkit/android/internal/Action$PreparePushToken;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "process", "Lzendesk/conversationkit/android/internal/Action;", "(Lzendesk/conversationkit/android/internal/Action;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processAddConversationFields", "Lzendesk/conversationkit/android/internal/Action$AddConversationFields;", "(Lzendesk/conversationkit/android/internal/Action$AddConversationFields;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processAddConversationTags", "Lzendesk/conversationkit/android/internal/Action$AddConversationTags;", "(Lzendesk/conversationkit/android/internal/Action$AddConversationTags;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processAddProactiveMessage", "Lzendesk/conversationkit/android/internal/Action$AddProactiveMessage;", "(Lzendesk/conversationkit/android/internal/Action$AddProactiveMessage;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processClearConversationFields", "processClearProactiveMessage", "Lzendesk/conversationkit/android/internal/Action$ClearProactiveMessage;", "(Lzendesk/conversationkit/android/internal/Action$ClearProactiveMessage;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processClearTags", "processGetProactiveMessage", "Lzendesk/conversationkit/android/internal/Action$GetProactiveMessage;", "(Lzendesk/conversationkit/android/internal/Action$GetProactiveMessage;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processGetVisitTypeReceived", "processLoginUser", "Lzendesk/conversationkit/android/internal/Action$LoginUser;", "(Lzendesk/conversationkit/android/internal/Action$LoginUser;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processNetworkConnectionStatusUpdate", "Lzendesk/conversationkit/android/internal/Action$NetworkConnectionStatusUpdate;", "processSetVisitTypeReceived", "Lzendesk/conversationkit/android/internal/Action$SetVisitType;", "(Lzendesk/conversationkit/android/internal/Action$SetVisitType;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class AppActionProcessor implements ActionProcessor {
    private static final String LOG_TAG = "AppActionProcessor";
    private final AppRestClient appRestClient;
    private final AppStorage appStorage;
    private final ClientDtoProvider clientDtoProvider;
    private final Config config;
    private final ConversationKitSettings conversationKitSettings;
    private final ConversationKitStorage conversationKitStorage;
    private final Jwt.Decoder jwtDecoder;
    private final MetadataManager metadataManager;
    private final ProactiveMessagingStorage proactiveMessagingStorage;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.app.AppActionProcessor", m37f = "AppActionProcessor.kt", m38i = {0, 0, 0}, m39l = {HttpStatus.SC_MULTI_STATUS}, m40m = "appendMetadataToDefaultConversation", m41n = {"this", "client", "intent"}, m42s = {"L$0", "L$1", "L$2"})
    static final class C10381 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C10381(Continuation<? super C10381> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return AppActionProcessor.this.appendMetadataToDefaultConversation(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.app.AppActionProcessor", m37f = "AppActionProcessor.kt", m38i = {0}, m39l = {285}, m40m = "cacheIntegrationId", m41n = {"action"}, m42s = {"L$0"})
    static final class C10391 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C10391(Continuation<? super C10391> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return AppActionProcessor.this.cacheIntegrationId(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.app.AppActionProcessor", m37f = "AppActionProcessor.kt", m38i = {0}, m39l = {264, 265}, m40m = "checkForPersistedUser", m41n = {"this"}, m42s = {"L$0"})
    static final class C10401 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C10401(Continuation<? super C10401> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return AppActionProcessor.this.checkForPersistedUser(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.app.AppActionProcessor", m37f = "AppActionProcessor.kt", m38i = {0, 0, 1, 1, 2, 2, 3, 3, 4, 5, 5}, m39l = {120, 121, 123, 130, 137, 140, 158, 169}, m40m = "createUser", m41n = {"this", "action", "this", "action", "this", "client", "this", "client", "this", "this", "user"}, m42s = {"L$0", "L$1", "L$0", "L$1", "L$0", "L$1", "L$0", "L$1", "L$0", "L$0", "L$1"})
    static final class C10411 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        int label;
        Object result;

        C10411(Continuation<? super C10411> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return AppActionProcessor.this.createUser(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.app.AppActionProcessor", m37f = "AppActionProcessor.kt", m38i = {}, m39l = {318}, m40m = "getProactiveCampaignData", m41n = {}, m42s = {})
    static final class C10421 extends ContinuationImpl {
        int label;
        Object result;

        C10421(Continuation<? super C10421> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return AppActionProcessor.this.getProactiveCampaignData(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.app.AppActionProcessor", m37f = "AppActionProcessor.kt", m38i = {0}, m39l = {278}, m40m = "preparePushToken", m41n = {"action"}, m42s = {"L$0"})
    static final class C10431 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C10431(Continuation<? super C10431> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return AppActionProcessor.this.preparePushToken(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.app.AppActionProcessor", m37f = "AppActionProcessor.kt", m38i = {}, m39l = {335}, m40m = "processAddConversationFields", m41n = {}, m42s = {})
    static final class C10441 extends ContinuationImpl {
        int label;
        Object result;

        C10441(Continuation<? super C10441> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return AppActionProcessor.this.processAddConversationFields(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.app.AppActionProcessor", m37f = "AppActionProcessor.kt", m38i = {}, m39l = {349}, m40m = "processAddConversationTags", m41n = {}, m42s = {})
    static final class C10451 extends ContinuationImpl {
        int label;
        Object result;

        C10451(Continuation<? super C10451> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return AppActionProcessor.this.processAddConversationTags(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.app.AppActionProcessor", m37f = "AppActionProcessor.kt", m38i = {}, m39l = {299}, m40m = "processAddProactiveMessage", m41n = {}, m42s = {})
    static final class C10461 extends ContinuationImpl {
        int label;
        Object result;

        C10461(Continuation<? super C10461> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return AppActionProcessor.this.processAddProactiveMessage(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.app.AppActionProcessor", m37f = "AppActionProcessor.kt", m38i = {}, m39l = {358}, m40m = "processClearConversationFields", m41n = {}, m42s = {})
    static final class C10471 extends ContinuationImpl {
        int label;
        Object result;

        C10471(Continuation<? super C10471> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return AppActionProcessor.this.processClearConversationFields(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.app.AppActionProcessor", m37f = "AppActionProcessor.kt", m38i = {}, m39l = {322}, m40m = "processClearProactiveMessage", m41n = {}, m42s = {})
    static final class C10481 extends ContinuationImpl {
        int label;
        Object result;

        C10481(Continuation<? super C10481> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return AppActionProcessor.this.processClearProactiveMessage(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.app.AppActionProcessor", m37f = "AppActionProcessor.kt", m38i = {}, m39l = {366}, m40m = "processClearTags", m41n = {}, m42s = {})
    static final class C10491 extends ContinuationImpl {
        int label;
        Object result;

        C10491(Continuation<? super C10491> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return AppActionProcessor.this.processClearTags(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.app.AppActionProcessor", m37f = "AppActionProcessor.kt", m38i = {0}, m39l = {HttpStatus.SC_NOT_MODIFIED}, m40m = "processGetProactiveMessage", m41n = {"action"}, m42s = {"L$0"})
    static final class C10501 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C10501(Continuation<? super C10501> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return AppActionProcessor.this.processGetProactiveMessage(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.app.AppActionProcessor", m37f = "AppActionProcessor.kt", m38i = {}, m39l = {95}, m40m = "processGetVisitTypeReceived", m41n = {}, m42s = {})
    static final class C10511 extends ContinuationImpl {
        int label;
        Object result;

        C10511(Continuation<? super C10511> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return AppActionProcessor.this.processGetVisitTypeReceived(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.app.AppActionProcessor", m37f = "AppActionProcessor.kt", m38i = {0, 0, 1, 1, 2, 2}, m39l = {226, 227, 238, 240}, m40m = "processLoginUser", m41n = {"this", "action", "this", "action", "this", "action"}, m42s = {"L$0", "L$1", "L$0", "L$1", "L$0", "L$1"})
    static final class C10521 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        int label;
        Object result;

        C10521(Continuation<? super C10521> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return AppActionProcessor.this.processLoginUser(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.app.AppActionProcessor", m37f = "AppActionProcessor.kt", m38i = {}, m39l = {90}, m40m = "processSetVisitTypeReceived", m41n = {}, m42s = {})
    static final class C10531 extends ContinuationImpl {
        int label;
        Object result;

        C10531(Continuation<? super C10531> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return AppActionProcessor.this.processSetVisitTypeReceived(null, this);
        }
    }

    public AppActionProcessor(ConversationKitSettings conversationKitSettings, Config config, AppRestClient appRestClient, ClientDtoProvider clientDtoProvider, AppStorage appStorage, ConversationKitStorage conversationKitStorage, ProactiveMessagingStorage proactiveMessagingStorage, MetadataManager metadataManager, Jwt.Decoder jwtDecoder) {
        Intrinsics.checkNotNullParameter(conversationKitSettings, "conversationKitSettings");
        Intrinsics.checkNotNullParameter(config, "config");
        Intrinsics.checkNotNullParameter(appRestClient, "appRestClient");
        Intrinsics.checkNotNullParameter(clientDtoProvider, "clientDtoProvider");
        Intrinsics.checkNotNullParameter(appStorage, "appStorage");
        Intrinsics.checkNotNullParameter(conversationKitStorage, "conversationKitStorage");
        Intrinsics.checkNotNullParameter(proactiveMessagingStorage, "proactiveMessagingStorage");
        Intrinsics.checkNotNullParameter(metadataManager, "metadataManager");
        Intrinsics.checkNotNullParameter(jwtDecoder, "jwtDecoder");
        this.conversationKitSettings = conversationKitSettings;
        this.config = config;
        this.appRestClient = appRestClient;
        this.clientDtoProvider = clientDtoProvider;
        this.appStorage = appStorage;
        this.conversationKitStorage = conversationKitStorage;
        this.proactiveMessagingStorage = proactiveMessagingStorage;
        this.metadataManager = metadataManager;
        this.jwtDecoder = jwtDecoder;
    }

    public AppActionProcessor(ConversationKitSettings conversationKitSettings, Config config, AppRestClient appRestClient, ClientDtoProvider clientDtoProvider, AppStorage appStorage, ConversationKitStorage conversationKitStorage, ProactiveMessagingStorage proactiveMessagingStorage, MetadataManager metadataManager, Jwt.Decoder decoder, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(conversationKitSettings, config, appRestClient, clientDtoProvider, appStorage, conversationKitStorage, proactiveMessagingStorage, metadataManager, (i & 256) != 0 ? new Jwt.Decoder() : decoder);
    }

    @Override
    public Object process(Action action, Continuation<? super Effect> continuation) {
        if (action instanceof Action.NetworkConnectionStatusUpdate) {
            return processNetworkConnectionStatusUpdate((Action.NetworkConnectionStatusUpdate) action);
        }
        if (action instanceof Action.CreateUser) {
            return createUser((Action.CreateUser) action, continuation);
        }
        if (action instanceof Action.LoginUser) {
            return processLoginUser((Action.LoginUser) action, continuation);
        }
        if (action instanceof Action.CheckForPersistedUser) {
            return checkForPersistedUser(continuation);
        }
        if (action instanceof Action.PreparePushToken) {
            return preparePushToken((Action.PreparePushToken) action, continuation);
        }
        if (action instanceof Action.PushCacheIntegrationId) {
            return cacheIntegrationId((Action.PushCacheIntegrationId) action, continuation);
        }
        if (action instanceof Action.GetVisitType) {
            return processGetVisitTypeReceived(continuation);
        }
        if (action instanceof Action.SetVisitType) {
            return processSetVisitTypeReceived((Action.SetVisitType) action, continuation);
        }
        if (action instanceof Action.AddProactiveMessage) {
            return processAddProactiveMessage((Action.AddProactiveMessage) action, continuation);
        }
        if (action instanceof Action.GetProactiveMessage) {
            return processGetProactiveMessage((Action.GetProactiveMessage) action, continuation);
        }
        if (action instanceof Action.ClearProactiveMessage) {
            return processClearProactiveMessage((Action.ClearProactiveMessage) action, continuation);
        }
        if (action instanceof Action.AddConversationFields) {
            return processAddConversationFields((Action.AddConversationFields) action, continuation);
        }
        if (action instanceof Action.AddConversationTags) {
            return processAddConversationTags((Action.AddConversationTags) action, continuation);
        }
        if (action instanceof Action.ClearConversationFields) {
            return processClearConversationFields(continuation);
        }
        if (action instanceof Action.ClearConversationTags) {
            return processClearTags(continuation);
        }
        Logger.m225w(LOG_TAG, action + " cannot processed.", new Object[0]);
        return Effect.IncorrectAccessLevel.INSTANCE;
    }

    public final Object processSetVisitTypeReceived(Action.SetVisitType setVisitType, Continuation<? super Effect> continuation) throws Throwable {
        C10531 c10531;
        if (continuation instanceof C10531) {
            c10531 = (C10531) continuation;
            if ((c10531.label & Integer.MIN_VALUE) != 0) {
                c10531.label -= Integer.MIN_VALUE;
            } else {
                c10531 = new C10531(continuation);
            }
        } else {
            c10531 = new C10531(continuation);
        }
        Object obj = c10531.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c10531.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            ConversationKitStorage conversationKitStorage = this.conversationKitStorage;
            VisitType visitType = setVisitType.getVisitType();
            c10531.label = 1;
            if (conversationKitStorage.setVisitType(visitType, c10531) == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        return Effect.None.INSTANCE;
    }

    public final Object processGetVisitTypeReceived(Continuation<? super Effect> continuation) throws Throwable {
        C10511 c10511;
        if (continuation instanceof C10511) {
            c10511 = (C10511) continuation;
            if ((c10511.label & Integer.MIN_VALUE) != 0) {
                c10511.label -= Integer.MIN_VALUE;
            } else {
                c10511 = new C10511(continuation);
            }
        } else {
            c10511 = new C10511(continuation);
        }
        Object visitType = c10511.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c10511.label;
        if (i == 0) {
            ResultKt.throwOnFailure(visitType);
            ConversationKitStorage conversationKitStorage = this.conversationKitStorage;
            c10511.label = 1;
            visitType = conversationKitStorage.getVisitType(c10511);
            if (visitType == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(visitType);
        }
        return new Effect.GetVisitType((VisitType) visitType);
    }

    private final Effect processNetworkConnectionStatusUpdate(Action.NetworkConnectionStatusUpdate action) {
        return new Effect.NetworkConnectionChanged(action.getConnectionStatus());
    }

    public final Object createUser(Action.CreateUser createUser, Continuation<? super Effect> continuation) throws Exception {
        C10411 c10411;
        Action.CreateUser createUser2;
        AppActionProcessor appActionProcessor;
        ClientDtoProvider clientDtoProvider;
        String str;
        String str2;
        Object pushToken;
        String str3;
        Action.CreateUser createUser3;
        ClientDtoProvider clientDtoProvider2;
        ClientDto clientDtoBuildClient;
        Object proactiveCampaignData;
        AppActionProcessor appActionProcessor2;
        ClientDto clientDto;
        String str4;
        String str5;
        Intent intent;
        Object objAppendMetadataToDefaultConversation;
        String str6;
        Intent intent2;
        AppActionProcessor appActionProcessor3;
        ClientDto clientDto2;
        ClientDto clientDto3;
        AuthenticationType authenticationType;
        AppActionProcessor appActionProcessor4;
        User user$default;
        AppStorage appStorage;
        User user;
        ConversationKitResult.Failure failure;
        ConversationKitResult conversationKitResult;
        ConversationKitResult conversationKitResult2;
        if (continuation instanceof C10411) {
            c10411 = (C10411) continuation;
            if ((c10411.label & Integer.MIN_VALUE) != 0) {
                c10411.label -= Integer.MIN_VALUE;
            } else {
                c10411 = new C10411(continuation);
            }
        } else {
            c10411 = new C10411(continuation);
        }
        Object objCreateAppUser = c10411.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        String str7 = null;
        Object[] objArr = 0;
        Object[] objArr2 = 0;
        Object[] objArr3 = 0;
        Object[] objArr4 = 0;
        Object[] objArr5 = 0;
        Object[] objArr6 = 0;
        switch (c10411.label) {
            case 0:
                ResultKt.throwOnFailure(objCreateAppUser);
                ClientDtoProvider clientDtoProvider3 = this.clientDtoProvider;
                String integrationId = this.conversationKitSettings.getIntegrationId();
                ConversationKitStorage conversationKitStorage = this.conversationKitStorage;
                c10411.L$0 = this;
                createUser2 = createUser;
                c10411.L$1 = createUser2;
                c10411.L$2 = clientDtoProvider3;
                c10411.L$3 = integrationId;
                c10411.label = 1;
                Object clientId = conversationKitStorage.getClientId(c10411);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                appActionProcessor = this;
                clientDtoProvider = clientDtoProvider3;
                objCreateAppUser = clientId;
                str = integrationId;
                str2 = (String) objCreateAppUser;
                ConversationKitStorage conversationKitStorage2 = appActionProcessor.conversationKitStorage;
                c10411.L$0 = appActionProcessor;
                c10411.L$1 = createUser2;
                c10411.L$2 = clientDtoProvider;
                c10411.L$3 = str;
                c10411.L$4 = str2;
                c10411.label = 2;
                pushToken = conversationKitStorage2.getPushToken(c10411);
                if (pushToken == coroutine_suspended) {
                    return coroutine_suspended;
                }
                ClientDtoProvider clientDtoProvider4 = clientDtoProvider;
                str3 = str2;
                objCreateAppUser = pushToken;
                createUser3 = createUser2;
                clientDtoProvider2 = clientDtoProvider4;
                clientDtoBuildClient = clientDtoProvider2.buildClient(str, str3, (String) objCreateAppUser);
                Integer proactiveMessageId = createUser3.getProactiveMessageId();
                c10411.L$0 = appActionProcessor;
                c10411.L$1 = clientDtoBuildClient;
                c10411.L$2 = null;
                c10411.L$3 = null;
                c10411.L$4 = null;
                c10411.label = 3;
                proactiveCampaignData = appActionProcessor.getProactiveCampaignData(proactiveMessageId, c10411);
                if (proactiveCampaignData == coroutine_suspended) {
                    return coroutine_suspended;
                }
                appActionProcessor2 = appActionProcessor;
                clientDto = clientDtoBuildClient;
                objCreateAppUser = proactiveCampaignData;
                str4 = (String) objCreateAppUser;
                str5 = str4;
                if (str5 != null || str5.length() == 0) {
                    intent = Intent.CONVERSATION_START;
                } else {
                    intent = Intent.PROACTIVE;
                }
                c10411.L$0 = appActionProcessor2;
                c10411.L$1 = clientDto;
                c10411.L$2 = clientDto;
                c10411.L$3 = intent;
                c10411.L$4 = str4;
                c10411.label = 4;
                objAppendMetadataToDefaultConversation = appActionProcessor2.appendMetadataToDefaultConversation(clientDto, intent, c10411);
                if (objAppendMetadataToDefaultConversation == coroutine_suspended) {
                    return coroutine_suspended;
                }
                str6 = str4;
                intent2 = intent;
                appActionProcessor3 = appActionProcessor2;
                objCreateAppUser = objAppendMetadataToDefaultConversation;
                clientDto2 = clientDto;
                clientDto3 = clientDto2;
                AppUserRequestDto appUserRequestDto = new AppUserRequestDto(clientDto2, str7, (String) (objArr6 == true ? 1 : 0), (String) (objArr5 == true ? 1 : 0), (String) (objArr4 == true ? 1 : 0), (Map) (objArr3 == true ? 1 : 0), intent2, str6, (List) (objArr2 == true ? 1 : 0), (PostbackDto) (objArr == true ? 1 : 0), (CreateConversationRequestDto) objCreateAppUser, 830, (DefaultConstructorMarker) null);
                try {
                    AppRestClient appRestClient = appActionProcessor3.appRestClient;
                    String id = clientDto3.getId();
                    c10411.L$0 = appActionProcessor3;
                    authenticationType = null;
                    try {
                        c10411.L$1 = null;
                        c10411.L$2 = null;
                        c10411.L$3 = null;
                        c10411.L$4 = null;
                        c10411.label = 5;
                        objCreateAppUser = appRestClient.createAppUser(id, appUserRequestDto, c10411);
                        if (objCreateAppUser == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        user$default = UserKt.toUser$default((AppUserResponseDto) objCreateAppUser, appActionProcessor3.config.getApp().getId(), authenticationType, 2, authenticationType);
                        appStorage = appActionProcessor3.appStorage;
                        c10411.L$0 = appActionProcessor3;
                        c10411.L$1 = user$default;
                        c10411.label = 6;
                        if (appStorage.setUser(user$default, c10411) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        appActionProcessor4 = appActionProcessor3;
                        user = user$default;
                        try {
                            failure = new ConversationKitResult.Success(user);
                        } catch (SerializationException e) {
                            e = e;
                            SerializationException serializationException = e;
                            Logger.m218e(LOG_TAG, "POST request for App User Creation encountered a serialization error during JSON processing.", serializationException, new Object[0]);
                            failure = new ConversationKitResult.Failure(serializationException);
                        } catch (HttpException e2) {
                            e = e2;
                            if (e.code() != 401) {
                                break;
                            }
                            return new Effect.UserAccessRevoked(new ConversationKitResult.Failure(e));
                        } catch (Exception e3) {
                            e = e3;
                            if (e instanceof CancellationException) {
                                throw e;
                            }
                            Exception exc = e;
                            Logger.m218e(LOG_TAG, "Failed to create appUser.", exc, new Object[0]);
                            failure = new ConversationKitResult.Failure(exc);
                        }
                        ConversationKitStorage conversationKitStorage3 = appActionProcessor4.conversationKitStorage;
                        c10411.L$0 = failure;
                        c10411.L$1 = authenticationType;
                        c10411.L$2 = authenticationType;
                        c10411.L$3 = authenticationType;
                        c10411.L$4 = authenticationType;
                        c10411.label = 8;
                        objCreateAppUser = conversationKitStorage3.getPushToken(c10411);
                        if (objCreateAppUser == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        conversationKitResult2 = failure;
                        return new Effect.CreateUserResult(conversationKitResult2, (String) objCreateAppUser);
                    } catch (SerializationException e4) {
                        e = e4;
                        appActionProcessor4 = appActionProcessor3;
                        SerializationException serializationException2 = e;
                        Logger.m218e(LOG_TAG, "POST request for App User Creation encountered a serialization error during JSON processing.", serializationException2, new Object[0]);
                        failure = new ConversationKitResult.Failure(serializationException2);
                        ConversationKitStorage conversationKitStorage4 = appActionProcessor4.conversationKitStorage;
                        c10411.L$0 = failure;
                        c10411.L$1 = authenticationType;
                        c10411.L$2 = authenticationType;
                        c10411.L$3 = authenticationType;
                        c10411.L$4 = authenticationType;
                        c10411.label = 8;
                        objCreateAppUser = conversationKitStorage4.getPushToken(c10411);
                        if (objCreateAppUser == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        conversationKitResult2 = failure;
                        return new Effect.CreateUserResult(conversationKitResult2, (String) objCreateAppUser);
                    } catch (HttpException e5) {
                        e = e5;
                        appActionProcessor4 = appActionProcessor3;
                        if (e.code() != 401) {
                            break;
                        }
                        return new Effect.UserAccessRevoked(new ConversationKitResult.Failure(e));
                    } catch (Exception e6) {
                        e = e6;
                        appActionProcessor4 = appActionProcessor3;
                        if (e instanceof CancellationException) {
                            throw e;
                        }
                        Exception exc2 = e;
                        Logger.m218e(LOG_TAG, "Failed to create appUser.", exc2, new Object[0]);
                        failure = new ConversationKitResult.Failure(exc2);
                        ConversationKitStorage conversationKitStorage5 = appActionProcessor4.conversationKitStorage;
                        c10411.L$0 = failure;
                        c10411.L$1 = authenticationType;
                        c10411.L$2 = authenticationType;
                        c10411.L$3 = authenticationType;
                        c10411.L$4 = authenticationType;
                        c10411.label = 8;
                        objCreateAppUser = conversationKitStorage5.getPushToken(c10411);
                        if (objCreateAppUser == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        conversationKitResult2 = failure;
                        return new Effect.CreateUserResult(conversationKitResult2, (String) objCreateAppUser);
                    }
                } catch (SerializationException e7) {
                    e = e7;
                    authenticationType = null;
                    appActionProcessor4 = appActionProcessor3;
                    SerializationException serializationException3 = e;
                    Logger.m218e(LOG_TAG, "POST request for App User Creation encountered a serialization error during JSON processing.", serializationException3, new Object[0]);
                    failure = new ConversationKitResult.Failure(serializationException3);
                    ConversationKitStorage conversationKitStorage6 = appActionProcessor4.conversationKitStorage;
                    c10411.L$0 = failure;
                    c10411.L$1 = authenticationType;
                    c10411.L$2 = authenticationType;
                    c10411.L$3 = authenticationType;
                    c10411.L$4 = authenticationType;
                    c10411.label = 8;
                    objCreateAppUser = conversationKitStorage6.getPushToken(c10411);
                    if (objCreateAppUser == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    conversationKitResult2 = failure;
                    return new Effect.CreateUserResult(conversationKitResult2, (String) objCreateAppUser);
                } catch (HttpException e8) {
                    e = e8;
                    authenticationType = null;
                    appActionProcessor4 = appActionProcessor3;
                    if (e.code() != 401) {
                        break;
                    }
                    return new Effect.UserAccessRevoked(new ConversationKitResult.Failure(e));
                } catch (Exception e9) {
                    e = e9;
                    authenticationType = null;
                    appActionProcessor4 = appActionProcessor3;
                    if (e instanceof CancellationException) {
                        throw e;
                    }
                    Exception exc3 = e;
                    Logger.m218e(LOG_TAG, "Failed to create appUser.", exc3, new Object[0]);
                    failure = new ConversationKitResult.Failure(exc3);
                    ConversationKitStorage conversationKitStorage7 = appActionProcessor4.conversationKitStorage;
                    c10411.L$0 = failure;
                    c10411.L$1 = authenticationType;
                    c10411.L$2 = authenticationType;
                    c10411.L$3 = authenticationType;
                    c10411.L$4 = authenticationType;
                    c10411.label = 8;
                    objCreateAppUser = conversationKitStorage7.getPushToken(c10411);
                    if (objCreateAppUser == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    conversationKitResult2 = failure;
                    return new Effect.CreateUserResult(conversationKitResult2, (String) objCreateAppUser);
                }
            case 1:
                String str8 = (String) c10411.L$3;
                ClientDtoProvider clientDtoProvider5 = (ClientDtoProvider) c10411.L$2;
                createUser2 = (Action.CreateUser) c10411.L$1;
                appActionProcessor = (AppActionProcessor) c10411.L$0;
                ResultKt.throwOnFailure(objCreateAppUser);
                str = str8;
                clientDtoProvider = clientDtoProvider5;
                str2 = (String) objCreateAppUser;
                ConversationKitStorage conversationKitStorage8 = appActionProcessor.conversationKitStorage;
                c10411.L$0 = appActionProcessor;
                c10411.L$1 = createUser2;
                c10411.L$2 = clientDtoProvider;
                c10411.L$3 = str;
                c10411.L$4 = str2;
                c10411.label = 2;
                pushToken = conversationKitStorage8.getPushToken(c10411);
                if (pushToken == coroutine_suspended) {
                    return coroutine_suspended;
                }
                ClientDtoProvider clientDtoProvider6 = clientDtoProvider;
                str3 = str2;
                objCreateAppUser = pushToken;
                createUser3 = createUser2;
                clientDtoProvider2 = clientDtoProvider6;
                clientDtoBuildClient = clientDtoProvider2.buildClient(str, str3, (String) objCreateAppUser);
                Integer proactiveMessageId2 = createUser3.getProactiveMessageId();
                c10411.L$0 = appActionProcessor;
                c10411.L$1 = clientDtoBuildClient;
                c10411.L$2 = null;
                c10411.L$3 = null;
                c10411.L$4 = null;
                c10411.label = 3;
                proactiveCampaignData = appActionProcessor.getProactiveCampaignData(proactiveMessageId2, c10411);
                if (proactiveCampaignData == coroutine_suspended) {
                    return coroutine_suspended;
                }
                appActionProcessor2 = appActionProcessor;
                clientDto = clientDtoBuildClient;
                objCreateAppUser = proactiveCampaignData;
                str4 = (String) objCreateAppUser;
                str5 = str4;
                if (str5 != null) {
                    intent = Intent.CONVERSATION_START;
                } else {
                    intent = Intent.CONVERSATION_START;
                }
                c10411.L$0 = appActionProcessor2;
                c10411.L$1 = clientDto;
                c10411.L$2 = clientDto;
                c10411.L$3 = intent;
                c10411.L$4 = str4;
                c10411.label = 4;
                objAppendMetadataToDefaultConversation = appActionProcessor2.appendMetadataToDefaultConversation(clientDto, intent, c10411);
                if (objAppendMetadataToDefaultConversation == coroutine_suspended) {
                    return coroutine_suspended;
                }
                str6 = str4;
                intent2 = intent;
                appActionProcessor3 = appActionProcessor2;
                objCreateAppUser = objAppendMetadataToDefaultConversation;
                clientDto2 = clientDto;
                clientDto3 = clientDto2;
                AppUserRequestDto appUserRequestDto2 = new AppUserRequestDto(clientDto2, str7, (String) (objArr6 == true ? 1 : 0), (String) (objArr5 == true ? 1 : 0), (String) (objArr4 == true ? 1 : 0), (Map) (objArr3 == true ? 1 : 0), intent2, str6, (List) (objArr2 == true ? 1 : 0), (PostbackDto) (objArr == true ? 1 : 0), (CreateConversationRequestDto) objCreateAppUser, 830, (DefaultConstructorMarker) null);
                AppRestClient appRestClient2 = appActionProcessor3.appRestClient;
                String id2 = clientDto3.getId();
                c10411.L$0 = appActionProcessor3;
                authenticationType = null;
                c10411.L$1 = null;
                c10411.L$2 = null;
                c10411.L$3 = null;
                c10411.L$4 = null;
                c10411.label = 5;
                objCreateAppUser = appRestClient2.createAppUser(id2, appUserRequestDto2, c10411);
                if (objCreateAppUser == coroutine_suspended) {
                    return coroutine_suspended;
                }
                user$default = UserKt.toUser$default((AppUserResponseDto) objCreateAppUser, appActionProcessor3.config.getApp().getId(), authenticationType, 2, authenticationType);
                appStorage = appActionProcessor3.appStorage;
                c10411.L$0 = appActionProcessor3;
                c10411.L$1 = user$default;
                c10411.label = 6;
                if (appStorage.setUser(user$default, c10411) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                appActionProcessor4 = appActionProcessor3;
                user = user$default;
                failure = new ConversationKitResult.Success(user);
                ConversationKitStorage conversationKitStorage9 = appActionProcessor4.conversationKitStorage;
                c10411.L$0 = failure;
                c10411.L$1 = authenticationType;
                c10411.L$2 = authenticationType;
                c10411.L$3 = authenticationType;
                c10411.L$4 = authenticationType;
                c10411.label = 8;
                objCreateAppUser = conversationKitStorage9.getPushToken(c10411);
                if (objCreateAppUser == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversationKitResult2 = failure;
                return new Effect.CreateUserResult(conversationKitResult2, (String) objCreateAppUser);
            case 2:
                str3 = (String) c10411.L$4;
                str = (String) c10411.L$3;
                clientDtoProvider2 = (ClientDtoProvider) c10411.L$2;
                Action.CreateUser createUser4 = (Action.CreateUser) c10411.L$1;
                AppActionProcessor appActionProcessor5 = (AppActionProcessor) c10411.L$0;
                ResultKt.throwOnFailure(objCreateAppUser);
                createUser3 = createUser4;
                appActionProcessor = appActionProcessor5;
                clientDtoBuildClient = clientDtoProvider2.buildClient(str, str3, (String) objCreateAppUser);
                Integer proactiveMessageId3 = createUser3.getProactiveMessageId();
                c10411.L$0 = appActionProcessor;
                c10411.L$1 = clientDtoBuildClient;
                c10411.L$2 = null;
                c10411.L$3 = null;
                c10411.L$4 = null;
                c10411.label = 3;
                proactiveCampaignData = appActionProcessor.getProactiveCampaignData(proactiveMessageId3, c10411);
                if (proactiveCampaignData == coroutine_suspended) {
                    return coroutine_suspended;
                }
                appActionProcessor2 = appActionProcessor;
                clientDto = clientDtoBuildClient;
                objCreateAppUser = proactiveCampaignData;
                str4 = (String) objCreateAppUser;
                str5 = str4;
                if (str5 != null) {
                    intent = Intent.CONVERSATION_START;
                } else {
                    intent = Intent.CONVERSATION_START;
                }
                c10411.L$0 = appActionProcessor2;
                c10411.L$1 = clientDto;
                c10411.L$2 = clientDto;
                c10411.L$3 = intent;
                c10411.L$4 = str4;
                c10411.label = 4;
                objAppendMetadataToDefaultConversation = appActionProcessor2.appendMetadataToDefaultConversation(clientDto, intent, c10411);
                if (objAppendMetadataToDefaultConversation == coroutine_suspended) {
                    return coroutine_suspended;
                }
                str6 = str4;
                intent2 = intent;
                appActionProcessor3 = appActionProcessor2;
                objCreateAppUser = objAppendMetadataToDefaultConversation;
                clientDto2 = clientDto;
                clientDto3 = clientDto2;
                AppUserRequestDto appUserRequestDto3 = new AppUserRequestDto(clientDto2, str7, (String) (objArr6 == true ? 1 : 0), (String) (objArr5 == true ? 1 : 0), (String) (objArr4 == true ? 1 : 0), (Map) (objArr3 == true ? 1 : 0), intent2, str6, (List) (objArr2 == true ? 1 : 0), (PostbackDto) (objArr == true ? 1 : 0), (CreateConversationRequestDto) objCreateAppUser, 830, (DefaultConstructorMarker) null);
                AppRestClient appRestClient3 = appActionProcessor3.appRestClient;
                String id3 = clientDto3.getId();
                c10411.L$0 = appActionProcessor3;
                authenticationType = null;
                c10411.L$1 = null;
                c10411.L$2 = null;
                c10411.L$3 = null;
                c10411.L$4 = null;
                c10411.label = 5;
                objCreateAppUser = appRestClient3.createAppUser(id3, appUserRequestDto3, c10411);
                if (objCreateAppUser == coroutine_suspended) {
                    return coroutine_suspended;
                }
                user$default = UserKt.toUser$default((AppUserResponseDto) objCreateAppUser, appActionProcessor3.config.getApp().getId(), authenticationType, 2, authenticationType);
                appStorage = appActionProcessor3.appStorage;
                c10411.L$0 = appActionProcessor3;
                c10411.L$1 = user$default;
                c10411.label = 6;
                if (appStorage.setUser(user$default, c10411) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                appActionProcessor4 = appActionProcessor3;
                user = user$default;
                failure = new ConversationKitResult.Success(user);
                ConversationKitStorage conversationKitStorage10 = appActionProcessor4.conversationKitStorage;
                c10411.L$0 = failure;
                c10411.L$1 = authenticationType;
                c10411.L$2 = authenticationType;
                c10411.L$3 = authenticationType;
                c10411.L$4 = authenticationType;
                c10411.label = 8;
                objCreateAppUser = conversationKitStorage10.getPushToken(c10411);
                if (objCreateAppUser == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversationKitResult2 = failure;
                return new Effect.CreateUserResult(conversationKitResult2, (String) objCreateAppUser);
            case 3:
                ClientDto clientDto4 = (ClientDto) c10411.L$1;
                appActionProcessor2 = (AppActionProcessor) c10411.L$0;
                ResultKt.throwOnFailure(objCreateAppUser);
                clientDto = clientDto4;
                str4 = (String) objCreateAppUser;
                str5 = str4;
                if (str5 != null) {
                    intent = Intent.CONVERSATION_START;
                } else {
                    intent = Intent.CONVERSATION_START;
                }
                c10411.L$0 = appActionProcessor2;
                c10411.L$1 = clientDto;
                c10411.L$2 = clientDto;
                c10411.L$3 = intent;
                c10411.L$4 = str4;
                c10411.label = 4;
                objAppendMetadataToDefaultConversation = appActionProcessor2.appendMetadataToDefaultConversation(clientDto, intent, c10411);
                if (objAppendMetadataToDefaultConversation == coroutine_suspended) {
                    return coroutine_suspended;
                }
                str6 = str4;
                intent2 = intent;
                appActionProcessor3 = appActionProcessor2;
                objCreateAppUser = objAppendMetadataToDefaultConversation;
                clientDto2 = clientDto;
                clientDto3 = clientDto2;
                AppUserRequestDto appUserRequestDto4 = new AppUserRequestDto(clientDto2, str7, (String) (objArr6 == true ? 1 : 0), (String) (objArr5 == true ? 1 : 0), (String) (objArr4 == true ? 1 : 0), (Map) (objArr3 == true ? 1 : 0), intent2, str6, (List) (objArr2 == true ? 1 : 0), (PostbackDto) (objArr == true ? 1 : 0), (CreateConversationRequestDto) objCreateAppUser, 830, (DefaultConstructorMarker) null);
                AppRestClient appRestClient4 = appActionProcessor3.appRestClient;
                String id4 = clientDto3.getId();
                c10411.L$0 = appActionProcessor3;
                authenticationType = null;
                c10411.L$1 = null;
                c10411.L$2 = null;
                c10411.L$3 = null;
                c10411.L$4 = null;
                c10411.label = 5;
                objCreateAppUser = appRestClient4.createAppUser(id4, appUserRequestDto4, c10411);
                if (objCreateAppUser == coroutine_suspended) {
                    return coroutine_suspended;
                }
                user$default = UserKt.toUser$default((AppUserResponseDto) objCreateAppUser, appActionProcessor3.config.getApp().getId(), authenticationType, 2, authenticationType);
                appStorage = appActionProcessor3.appStorage;
                c10411.L$0 = appActionProcessor3;
                c10411.L$1 = user$default;
                c10411.label = 6;
                if (appStorage.setUser(user$default, c10411) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                appActionProcessor4 = appActionProcessor3;
                user = user$default;
                failure = new ConversationKitResult.Success(user);
                ConversationKitStorage conversationKitStorage11 = appActionProcessor4.conversationKitStorage;
                c10411.L$0 = failure;
                c10411.L$1 = authenticationType;
                c10411.L$2 = authenticationType;
                c10411.L$3 = authenticationType;
                c10411.L$4 = authenticationType;
                c10411.label = 8;
                objCreateAppUser = conversationKitStorage11.getPushToken(c10411);
                if (objCreateAppUser == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversationKitResult2 = failure;
                return new Effect.CreateUserResult(conversationKitResult2, (String) objCreateAppUser);
            case 4:
                String str9 = (String) c10411.L$4;
                Intent intent3 = (Intent) c10411.L$3;
                clientDto2 = (ClientDto) c10411.L$2;
                ClientDto clientDto5 = (ClientDto) c10411.L$1;
                AppActionProcessor appActionProcessor6 = (AppActionProcessor) c10411.L$0;
                ResultKt.throwOnFailure(objCreateAppUser);
                str6 = str9;
                intent2 = intent3;
                clientDto3 = clientDto5;
                appActionProcessor3 = appActionProcessor6;
                AppUserRequestDto appUserRequestDto5 = new AppUserRequestDto(clientDto2, str7, (String) (objArr6 == true ? 1 : 0), (String) (objArr5 == true ? 1 : 0), (String) (objArr4 == true ? 1 : 0), (Map) (objArr3 == true ? 1 : 0), intent2, str6, (List) (objArr2 == true ? 1 : 0), (PostbackDto) (objArr == true ? 1 : 0), (CreateConversationRequestDto) objCreateAppUser, 830, (DefaultConstructorMarker) null);
                AppRestClient appRestClient5 = appActionProcessor3.appRestClient;
                String id5 = clientDto3.getId();
                c10411.L$0 = appActionProcessor3;
                authenticationType = null;
                c10411.L$1 = null;
                c10411.L$2 = null;
                c10411.L$3 = null;
                c10411.L$4 = null;
                c10411.label = 5;
                objCreateAppUser = appRestClient5.createAppUser(id5, appUserRequestDto5, c10411);
                if (objCreateAppUser == coroutine_suspended) {
                    return coroutine_suspended;
                }
                user$default = UserKt.toUser$default((AppUserResponseDto) objCreateAppUser, appActionProcessor3.config.getApp().getId(), authenticationType, 2, authenticationType);
                appStorage = appActionProcessor3.appStorage;
                c10411.L$0 = appActionProcessor3;
                c10411.L$1 = user$default;
                c10411.label = 6;
                if (appStorage.setUser(user$default, c10411) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                appActionProcessor4 = appActionProcessor3;
                user = user$default;
                failure = new ConversationKitResult.Success(user);
                ConversationKitStorage conversationKitStorage12 = appActionProcessor4.conversationKitStorage;
                c10411.L$0 = failure;
                c10411.L$1 = authenticationType;
                c10411.L$2 = authenticationType;
                c10411.L$3 = authenticationType;
                c10411.L$4 = authenticationType;
                c10411.label = 8;
                objCreateAppUser = conversationKitStorage12.getPushToken(c10411);
                if (objCreateAppUser == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversationKitResult2 = failure;
                return new Effect.CreateUserResult(conversationKitResult2, (String) objCreateAppUser);
            case 5:
                appActionProcessor3 = (AppActionProcessor) c10411.L$0;
                try {
                    ResultKt.throwOnFailure(objCreateAppUser);
                    authenticationType = null;
                    user$default = UserKt.toUser$default((AppUserResponseDto) objCreateAppUser, appActionProcessor3.config.getApp().getId(), authenticationType, 2, authenticationType);
                    appStorage = appActionProcessor3.appStorage;
                    c10411.L$0 = appActionProcessor3;
                    c10411.L$1 = user$default;
                    c10411.label = 6;
                    if (appStorage.setUser(user$default, c10411) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    appActionProcessor4 = appActionProcessor3;
                    user = user$default;
                    failure = new ConversationKitResult.Success(user);
                    ConversationKitStorage conversationKitStorage13 = appActionProcessor4.conversationKitStorage;
                    c10411.L$0 = failure;
                    c10411.L$1 = authenticationType;
                    c10411.L$2 = authenticationType;
                    c10411.L$3 = authenticationType;
                    c10411.L$4 = authenticationType;
                    c10411.label = 8;
                    objCreateAppUser = conversationKitStorage13.getPushToken(c10411);
                    if (objCreateAppUser == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    conversationKitResult2 = failure;
                    return new Effect.CreateUserResult(conversationKitResult2, (String) objCreateAppUser);
                } catch (SerializationException e10) {
                    e = e10;
                    appActionProcessor4 = appActionProcessor3;
                    authenticationType = null;
                    SerializationException serializationException4 = e;
                    Logger.m218e(LOG_TAG, "POST request for App User Creation encountered a serialization error during JSON processing.", serializationException4, new Object[0]);
                    failure = new ConversationKitResult.Failure(serializationException4);
                    ConversationKitStorage conversationKitStorage14 = appActionProcessor4.conversationKitStorage;
                    c10411.L$0 = failure;
                    c10411.L$1 = authenticationType;
                    c10411.L$2 = authenticationType;
                    c10411.L$3 = authenticationType;
                    c10411.L$4 = authenticationType;
                    c10411.label = 8;
                    objCreateAppUser = conversationKitStorage14.getPushToken(c10411);
                    if (objCreateAppUser == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    conversationKitResult2 = failure;
                    return new Effect.CreateUserResult(conversationKitResult2, (String) objCreateAppUser);
                } catch (HttpException e11) {
                    e = e11;
                    appActionProcessor4 = appActionProcessor3;
                    authenticationType = null;
                    if (e.code() != 401) {
                        break;
                    }
                    return new Effect.UserAccessRevoked(new ConversationKitResult.Failure(e));
                } catch (Exception e12) {
                    e = e12;
                    appActionProcessor4 = appActionProcessor3;
                    authenticationType = null;
                    if (e instanceof CancellationException) {
                        throw e;
                    }
                    Exception exc4 = e;
                    Logger.m218e(LOG_TAG, "Failed to create appUser.", exc4, new Object[0]);
                    failure = new ConversationKitResult.Failure(exc4);
                    ConversationKitStorage conversationKitStorage15 = appActionProcessor4.conversationKitStorage;
                    c10411.L$0 = failure;
                    c10411.L$1 = authenticationType;
                    c10411.L$2 = authenticationType;
                    c10411.L$3 = authenticationType;
                    c10411.L$4 = authenticationType;
                    c10411.label = 8;
                    objCreateAppUser = conversationKitStorage15.getPushToken(c10411);
                    if (objCreateAppUser == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    conversationKitResult2 = failure;
                    return new Effect.CreateUserResult(conversationKitResult2, (String) objCreateAppUser);
                }
            case 6:
                user = (User) c10411.L$1;
                appActionProcessor4 = (AppActionProcessor) c10411.L$0;
                try {
                    ResultKt.throwOnFailure(objCreateAppUser);
                    authenticationType = null;
                    failure = new ConversationKitResult.Success(user);
                } catch (SerializationException e13) {
                    e = e13;
                    authenticationType = null;
                    SerializationException serializationException5 = e;
                    Logger.m218e(LOG_TAG, "POST request for App User Creation encountered a serialization error during JSON processing.", serializationException5, new Object[0]);
                    failure = new ConversationKitResult.Failure(serializationException5);
                    ConversationKitStorage conversationKitStorage16 = appActionProcessor4.conversationKitStorage;
                    c10411.L$0 = failure;
                    c10411.L$1 = authenticationType;
                    c10411.L$2 = authenticationType;
                    c10411.L$3 = authenticationType;
                    c10411.L$4 = authenticationType;
                    c10411.label = 8;
                    objCreateAppUser = conversationKitStorage16.getPushToken(c10411);
                    if (objCreateAppUser == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    conversationKitResult2 = failure;
                    return new Effect.CreateUserResult(conversationKitResult2, (String) objCreateAppUser);
                } catch (HttpException e14) {
                    e = e14;
                    authenticationType = null;
                    if (e.code() != 401 || e.code() == 403) {
                        return new Effect.UserAccessRevoked(new ConversationKitResult.Failure(e));
                    }
                    ConversationKitResult.Failure failure2 = new ConversationKitResult.Failure(e);
                    ConversationKitStorage conversationKitStorage17 = appActionProcessor4.conversationKitStorage;
                    c10411.L$0 = failure2;
                    c10411.L$1 = authenticationType;
                    c10411.L$2 = authenticationType;
                    c10411.L$3 = authenticationType;
                    c10411.L$4 = authenticationType;
                    c10411.label = 7;
                    Object pushToken2 = conversationKitStorage17.getPushToken(c10411);
                    if (pushToken2 == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    conversationKitResult = failure2;
                    objCreateAppUser = pushToken2;
                    return new Effect.CreateUserResult(conversationKitResult, (String) objCreateAppUser);
                } catch (Exception e15) {
                    e = e15;
                    authenticationType = null;
                    if (e instanceof CancellationException) {
                        throw e;
                    }
                    Exception exc5 = e;
                    Logger.m218e(LOG_TAG, "Failed to create appUser.", exc5, new Object[0]);
                    failure = new ConversationKitResult.Failure(exc5);
                    ConversationKitStorage conversationKitStorage18 = appActionProcessor4.conversationKitStorage;
                    c10411.L$0 = failure;
                    c10411.L$1 = authenticationType;
                    c10411.L$2 = authenticationType;
                    c10411.L$3 = authenticationType;
                    c10411.L$4 = authenticationType;
                    c10411.label = 8;
                    objCreateAppUser = conversationKitStorage18.getPushToken(c10411);
                    if (objCreateAppUser == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    conversationKitResult2 = failure;
                    return new Effect.CreateUserResult(conversationKitResult2, (String) objCreateAppUser);
                }
                ConversationKitStorage conversationKitStorage19 = appActionProcessor4.conversationKitStorage;
                c10411.L$0 = failure;
                c10411.L$1 = authenticationType;
                c10411.L$2 = authenticationType;
                c10411.L$3 = authenticationType;
                c10411.L$4 = authenticationType;
                c10411.label = 8;
                objCreateAppUser = conversationKitStorage19.getPushToken(c10411);
                if (objCreateAppUser == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversationKitResult2 = failure;
                return new Effect.CreateUserResult(conversationKitResult2, (String) objCreateAppUser);
            case 7:
                conversationKitResult = (ConversationKitResult) c10411.L$0;
                ResultKt.throwOnFailure(objCreateAppUser);
                return new Effect.CreateUserResult(conversationKitResult, (String) objCreateAppUser);
            case 8:
                conversationKitResult2 = (ConversationKitResult) c10411.L$0;
                ResultKt.throwOnFailure(objCreateAppUser);
                return new Effect.CreateUserResult(conversationKitResult2, (String) objCreateAppUser);
            default:
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    static CreateConversationRequestDto buildCreateConversationRequestDto$default(AppActionProcessor appActionProcessor, ConversationType conversationType, ClientDto clientDto, Intent intent, Map map, int i, Object obj) {
        if ((i & 1) != 0) {
            conversationType = ConversationType.PERSONAL;
        }
        return appActionProcessor.buildCreateConversationRequestDto(conversationType, clientDto, intent, map);
    }

    private final CreateConversationRequestDto buildCreateConversationRequestDto(ConversationType type, ClientDto client, Intent intent, Map<String, ? extends Object> metadata) {
        return new CreateConversationRequestDto(type, intent, client, (String) null, (List) null, (PostbackDto) null, metadata, 56, (DefaultConstructorMarker) null);
    }

    public final Object appendMetadataToDefaultConversation(ClientDto clientDto, Intent intent, Continuation<? super CreateConversationRequestDto> continuation) throws Throwable {
        C10381 c10381;
        AppActionProcessor appActionProcessor;
        ClientDto clientDto2;
        Intent intent2;
        if (continuation instanceof C10381) {
            c10381 = (C10381) continuation;
            if ((c10381.label & Integer.MIN_VALUE) != 0) {
                c10381.label -= Integer.MIN_VALUE;
            } else {
                c10381 = new C10381(continuation);
            }
        } else {
            c10381 = new C10381(continuation);
        }
        Object metadata = c10381.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c10381.label;
        if (i == 0) {
            ResultKt.throwOnFailure(metadata);
            MetadataManager metadataManager = this.metadataManager;
            c10381.L$0 = this;
            c10381.L$1 = clientDto;
            c10381.L$2 = intent;
            c10381.label = 1;
            metadata = metadataManager.getMetadata(c10381);
            if (metadata == coroutine_suspended) {
                return coroutine_suspended;
            }
            appActionProcessor = this;
            clientDto2 = clientDto;
            intent2 = intent;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            Intent intent3 = (Intent) c10381.L$2;
            ClientDto clientDto3 = (ClientDto) c10381.L$1;
            AppActionProcessor appActionProcessor2 = (AppActionProcessor) c10381.L$0;
            ResultKt.throwOnFailure(metadata);
            clientDto2 = clientDto3;
            intent2 = intent3;
            appActionProcessor = appActionProcessor2;
        }
        Map map = (Map) metadata;
        if (map == null || map.isEmpty() || intent2 != Intent.CONVERSATION_START) {
            return null;
        }
        return buildCreateConversationRequestDto$default(appActionProcessor, null, clientDto2, intent2, map, 1, null);
    }

    public final Object processLoginUser(Action.LoginUser loginUser, Continuation<? super Effect> continuation) throws Exception {
        C10521 c10521;
        String integrationId;
        Action.LoginUser loginUser2;
        AppActionProcessor appActionProcessor;
        ClientDtoProvider clientDtoProvider;
        String str;
        String str2;
        ClientDto clientDtoBuildClient;
        Jwt jwt;
        Action.LoginUser loginUser3;
        AppActionProcessor appActionProcessor2;
        User user;
        AppStorage appStorage;
        User user2;
        if (continuation instanceof C10521) {
            c10521 = (C10521) continuation;
            if ((c10521.label & Integer.MIN_VALUE) != 0) {
                c10521.label -= Integer.MIN_VALUE;
            } else {
                c10521 = new C10521(continuation);
            }
        } else {
            c10521 = new C10521(continuation);
        }
        Object objLoginAppUser = c10521.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c10521.label;
        try {
            if (i != 0) {
                if (i == 1) {
                    integrationId = (String) c10521.L$3;
                    clientDtoProvider = (ClientDtoProvider) c10521.L$2;
                    loginUser2 = (Action.LoginUser) c10521.L$1;
                    appActionProcessor = (AppActionProcessor) c10521.L$0;
                    ResultKt.throwOnFailure(objLoginAppUser);
                } else if (i == 2) {
                    str = (String) c10521.L$4;
                    str2 = (String) c10521.L$3;
                    clientDtoProvider = (ClientDtoProvider) c10521.L$2;
                    loginUser2 = (Action.LoginUser) c10521.L$1;
                    appActionProcessor = (AppActionProcessor) c10521.L$0;
                    ResultKt.throwOnFailure(objLoginAppUser);
                    clientDtoBuildClient = clientDtoProvider.buildClient(str2, str, (String) objLoginAppUser);
                    jwt = (Jwt) ConversationKitResultKt.getOrThrow(appActionProcessor.jwtDecoder.decode(loginUser2.getJwt()));
                    if (AuthenticatedUserUtilKt.isJwtExpired$default(jwt, 0L, 1, null)) {
                        return new Effect.UserAccessRevoked(new ConversationKitResult.Failure(new JwtIsExpiredException()));
                    }
                    AppRestClient appRestClient = appActionProcessor.appRestClient;
                    String jwt2 = loginUser2.getJwt();
                    LoginRequestBody loginRequestBody = new LoginRequestBody(jwt.getExternalId(), clientDtoBuildClient, (String) null, (String) null, 12, (DefaultConstructorMarker) null);
                    c10521.L$0 = appActionProcessor;
                    c10521.L$1 = loginUser2;
                    c10521.L$2 = null;
                    c10521.L$3 = null;
                    c10521.L$4 = null;
                    c10521.label = 3;
                    objLoginAppUser = appRestClient.loginAppUser(jwt2, loginRequestBody, c10521);
                    if (objLoginAppUser == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    loginUser3 = loginUser2;
                    appActionProcessor2 = appActionProcessor;
                    user = UserKt.toUser((AppUserResponseDto) objLoginAppUser, appActionProcessor2.config.getApp().getId(), new AuthenticationType.Jwt(loginUser3.getJwt()));
                    appStorage = appActionProcessor2.appStorage;
                    c10521.L$0 = user;
                    c10521.L$1 = null;
                    c10521.label = 4;
                    if (appStorage.setUser(user, c10521) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    user2 = user;
                } else if (i == 3) {
                    loginUser3 = (Action.LoginUser) c10521.L$1;
                    appActionProcessor2 = (AppActionProcessor) c10521.L$0;
                    ResultKt.throwOnFailure(objLoginAppUser);
                    user = UserKt.toUser((AppUserResponseDto) objLoginAppUser, appActionProcessor2.config.getApp().getId(), new AuthenticationType.Jwt(loginUser3.getJwt()));
                    appStorage = appActionProcessor2.appStorage;
                    c10521.L$0 = user;
                    c10521.L$1 = null;
                    c10521.label = 4;
                    if (appStorage.setUser(user, c10521) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    user2 = user;
                } else {
                    if (i != 4) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    user2 = (User) c10521.L$0;
                    ResultKt.throwOnFailure(objLoginAppUser);
                }
                return new Effect.LoginUserResult(new ConversationKitResult.Success(user2));
            }
            ResultKt.throwOnFailure(objLoginAppUser);
            ClientDtoProvider clientDtoProvider2 = this.clientDtoProvider;
            integrationId = this.conversationKitSettings.getIntegrationId();
            ConversationKitStorage conversationKitStorage = this.conversationKitStorage;
            c10521.L$0 = this;
            loginUser2 = loginUser;
            c10521.L$1 = loginUser2;
            c10521.L$2 = clientDtoProvider2;
            c10521.L$3 = integrationId;
            c10521.label = 1;
            Object clientId = conversationKitStorage.getClientId(c10521);
            if (clientId == coroutine_suspended) {
                return coroutine_suspended;
            }
            appActionProcessor = this;
            clientDtoProvider = clientDtoProvider2;
            objLoginAppUser = clientId;
            String str3 = (String) objLoginAppUser;
            ConversationKitStorage conversationKitStorage2 = appActionProcessor.conversationKitStorage;
            c10521.L$0 = appActionProcessor;
            c10521.L$1 = loginUser2;
            c10521.L$2 = clientDtoProvider;
            c10521.L$3 = integrationId;
            c10521.L$4 = str3;
            c10521.label = 2;
            Object pushToken = conversationKitStorage2.getPushToken(c10521);
            if (pushToken == coroutine_suspended) {
                return coroutine_suspended;
            }
            String str4 = integrationId;
            str = str3;
            objLoginAppUser = pushToken;
            str2 = str4;
            clientDtoBuildClient = clientDtoProvider.buildClient(str2, str, (String) objLoginAppUser);
            jwt = (Jwt) ConversationKitResultKt.getOrThrow(appActionProcessor.jwtDecoder.decode(loginUser2.getJwt()));
            if (AuthenticatedUserUtilKt.isJwtExpired$default(jwt, 0L, 1, null)) {
                return new Effect.UserAccessRevoked(new ConversationKitResult.Failure(new JwtIsExpiredException()));
            }
            AppRestClient appRestClient2 = appActionProcessor.appRestClient;
            String jwt3 = loginUser2.getJwt();
            LoginRequestBody loginRequestBody2 = new LoginRequestBody(jwt.getExternalId(), clientDtoBuildClient, (String) null, (String) null, 12, (DefaultConstructorMarker) null);
            c10521.L$0 = appActionProcessor;
            c10521.L$1 = loginUser2;
            c10521.L$2 = null;
            c10521.L$3 = null;
            c10521.L$4 = null;
            c10521.label = 3;
            objLoginAppUser = appRestClient2.loginAppUser(jwt3, loginRequestBody2, c10521);
            if (objLoginAppUser == coroutine_suspended) {
                return coroutine_suspended;
            }
            loginUser3 = loginUser2;
            appActionProcessor2 = appActionProcessor;
            user = UserKt.toUser((AppUserResponseDto) objLoginAppUser, appActionProcessor2.config.getApp().getId(), new AuthenticationType.Jwt(loginUser3.getJwt()));
            appStorage = appActionProcessor2.appStorage;
            c10521.L$0 = user;
            c10521.L$1 = null;
            c10521.label = 4;
            if (appStorage.setUser(user, c10521) == coroutine_suspended) {
                return coroutine_suspended;
            }
            user2 = user;
            return new Effect.LoginUserResult(new ConversationKitResult.Success(user2));
        } catch (HttpException e) {
            return (e.code() == 401 || e.code() == 403) ? new Effect.UserAccessRevoked(new ConversationKitResult.Failure(e)) : new Effect.LoginUserResult(new ConversationKitResult.Failure(e));
        } catch (Exception e2) {
            if (e2 instanceof CancellationException) {
                throw e2;
            }
            Exception exc = e2;
            Logger.m218e(LOG_TAG, "Failed to login", exc, new Object[0]);
            return new Effect.LoginUserResult(new ConversationKitResult.Failure(exc));
        }
    }

    public final Object checkForPersistedUser(Continuation<? super Effect> continuation) throws Throwable {
        C10401 c10401;
        AppActionProcessor appActionProcessor;
        User user;
        if (continuation instanceof C10401) {
            c10401 = (C10401) continuation;
            if ((c10401.label & Integer.MIN_VALUE) != 0) {
                c10401.label -= Integer.MIN_VALUE;
            } else {
                c10401 = new C10401(continuation);
            }
        } else {
            c10401 = new C10401(continuation);
        }
        Object user2 = c10401.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c10401.label;
        if (i == 0) {
            ResultKt.throwOnFailure(user2);
            AppStorage appStorage = this.appStorage;
            c10401.L$0 = this;
            c10401.label = 1;
            user2 = appStorage.getUser(c10401);
            if (user2 == coroutine_suspended) {
                return coroutine_suspended;
            }
            appActionProcessor = this;
        } else {
            if (i == 1) {
                appActionProcessor = (AppActionProcessor) c10401.L$0;
                ResultKt.throwOnFailure(user2);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                user = (User) c10401.L$0;
                ResultKt.throwOnFailure(user2);
            }
            return new Effect.CheckForPersistedUserResult(user, new ConversationKitResult.Success(Unit.INSTANCE), (String) user2);
        }
        User user3 = (User) user2;
        ConversationKitStorage conversationKitStorage = appActionProcessor.conversationKitStorage;
        c10401.L$0 = user3;
        c10401.label = 2;
        Object clientId = conversationKitStorage.getClientId(c10401);
        if (clientId == coroutine_suspended) {
            return coroutine_suspended;
        }
        user = user3;
        user2 = clientId;
        return new Effect.CheckForPersistedUserResult(user, new ConversationKitResult.Success(Unit.INSTANCE), (String) user2);
    }

    public final Object preparePushToken(Action.PreparePushToken preparePushToken, Continuation<? super Effect> continuation) throws Throwable {
        C10431 c10431;
        if (continuation instanceof C10431) {
            c10431 = (C10431) continuation;
            if ((c10431.label & Integer.MIN_VALUE) != 0) {
                c10431.label -= Integer.MIN_VALUE;
            } else {
                c10431 = new C10431(continuation);
            }
        } else {
            c10431 = new C10431(continuation);
        }
        Object obj = c10431.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c10431.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            ConversationKitStorage conversationKitStorage = this.conversationKitStorage;
            String pushToken = preparePushToken.getPushToken();
            c10431.L$0 = preparePushToken;
            c10431.label = 1;
            if (conversationKitStorage.setPushToken(pushToken, c10431) == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            preparePushToken = (Action.PreparePushToken) c10431.L$0;
            ResultKt.throwOnFailure(obj);
        }
        return new Effect.PushTokenPrepared(preparePushToken.getPushToken());
    }

    public final Object cacheIntegrationId(Action.PushCacheIntegrationId pushCacheIntegrationId, Continuation<? super Effect> continuation) throws Throwable {
        C10391 c10391;
        if (continuation instanceof C10391) {
            c10391 = (C10391) continuation;
            if ((c10391.label & Integer.MIN_VALUE) != 0) {
                c10391.label -= Integer.MIN_VALUE;
            } else {
                c10391 = new C10391(continuation);
            }
        } else {
            c10391 = new C10391(continuation);
        }
        Object obj = c10391.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c10391.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            ConversationKitStorage conversationKitStorage = this.conversationKitStorage;
            String integrationId = pushCacheIntegrationId.getIntegrationId();
            c10391.L$0 = pushCacheIntegrationId;
            c10391.label = 1;
            if (conversationKitStorage.setIntegrationId(integrationId, c10391) == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            pushCacheIntegrationId = (Action.PushCacheIntegrationId) c10391.L$0;
            ResultKt.throwOnFailure(obj);
        }
        return new Effect.IntegrationIdCached(pushCacheIntegrationId.getIntegrationId());
    }

    public final Object processAddProactiveMessage(Action.AddProactiveMessage addProactiveMessage, Continuation<? super Effect> continuation) throws Throwable {
        C10461 c10461;
        if (continuation instanceof C10461) {
            c10461 = (C10461) continuation;
            if ((c10461.label & Integer.MIN_VALUE) != 0) {
                c10461.label -= Integer.MIN_VALUE;
            } else {
                c10461 = new C10461(continuation);
            }
        } else {
            c10461 = new C10461(continuation);
        }
        Object obj = c10461.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c10461.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            ProactiveMessagingStorage proactiveMessagingStorage = this.proactiveMessagingStorage;
            ProactiveMessage proactiveMessage = addProactiveMessage.getProactiveMessage();
            c10461.label = 1;
            if (proactiveMessagingStorage.setProactiveMessage(proactiveMessage, c10461) == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        return Effect.None.INSTANCE;
    }

    public final Object processGetProactiveMessage(Action.GetProactiveMessage getProactiveMessage, Continuation<? super Effect> continuation) throws Throwable {
        C10501 c10501;
        ConversationKitResult.Success success;
        if (continuation instanceof C10501) {
            c10501 = (C10501) continuation;
            if ((c10501.label & Integer.MIN_VALUE) != 0) {
                c10501.label -= Integer.MIN_VALUE;
            } else {
                c10501 = new C10501(continuation);
            }
        } else {
            c10501 = new C10501(continuation);
        }
        Object proactiveMessage = c10501.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c10501.label;
        if (i == 0) {
            ResultKt.throwOnFailure(proactiveMessage);
            ProactiveMessagingStorage proactiveMessagingStorage = this.proactiveMessagingStorage;
            int proactiveMessageId = getProactiveMessage.getProactiveMessageId();
            c10501.L$0 = getProactiveMessage;
            c10501.label = 1;
            proactiveMessage = proactiveMessagingStorage.getProactiveMessage(proactiveMessageId, c10501);
            if (proactiveMessage == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            getProactiveMessage = (Action.GetProactiveMessage) c10501.L$0;
            ResultKt.throwOnFailure(proactiveMessage);
        }
        ProactiveMessage proactiveMessage2 = (ProactiveMessage) proactiveMessage;
        if (proactiveMessage2 == null) {
            success = new ConversationKitResult.Failure(new IllegalArgumentException("Couldn't find proactive message for id " + getProactiveMessage.getProactiveMessageId()));
        } else {
            success = new ConversationKitResult.Success(proactiveMessage2);
        }
        return new Effect.GetProactiveMessage(success);
    }

    public final Object getProactiveCampaignData(Integer num, Continuation<? super String> continuation) throws Throwable {
        C10421 c10421;
        if (continuation instanceof C10421) {
            c10421 = (C10421) continuation;
            if ((c10421.label & Integer.MIN_VALUE) != 0) {
                c10421.label -= Integer.MIN_VALUE;
            } else {
                c10421 = new C10421(continuation);
            }
        } else {
            c10421 = new C10421(continuation);
        }
        Object proactiveMessage = c10421.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c10421.label;
        if (i == 0) {
            ResultKt.throwOnFailure(proactiveMessage);
            if (num == null) {
                return null;
            }
            int iIntValue = num.intValue();
            ProactiveMessagingStorage proactiveMessagingStorage = this.proactiveMessagingStorage;
            c10421.label = 1;
            proactiveMessage = proactiveMessagingStorage.getProactiveMessage(iIntValue, c10421);
            if (proactiveMessage == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(proactiveMessage);
        }
        ProactiveMessage proactiveMessage2 = (ProactiveMessage) proactiveMessage;
        if (proactiveMessage2 != null) {
            return proactiveMessage2.getJwt();
        }
        return null;
    }

    public final Object processClearProactiveMessage(Action.ClearProactiveMessage clearProactiveMessage, Continuation<? super Effect> continuation) throws Throwable {
        C10481 c10481;
        if (continuation instanceof C10481) {
            c10481 = (C10481) continuation;
            if ((c10481.label & Integer.MIN_VALUE) != 0) {
                c10481.label -= Integer.MIN_VALUE;
            } else {
                c10481 = new C10481(continuation);
            }
        } else {
            c10481 = new C10481(continuation);
        }
        Object obj = c10481.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c10481.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            ProactiveMessagingStorage proactiveMessagingStorage = this.proactiveMessagingStorage;
            int proactiveMessageId = clearProactiveMessage.getProactiveMessageId();
            c10481.label = 1;
            if (proactiveMessagingStorage.clearProactiveMessage(proactiveMessageId, c10481) == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        return Effect.None.INSTANCE;
    }

    public final Object processAddConversationFields(Action.AddConversationFields addConversationFields, Continuation<? super Effect> continuation) throws Throwable {
        C10441 c10441;
        if (continuation instanceof C10441) {
            c10441 = (C10441) continuation;
            if ((c10441.label & Integer.MIN_VALUE) != 0) {
                c10441.label -= Integer.MIN_VALUE;
            } else {
                c10441 = new C10441(continuation);
            }
        } else {
            c10441 = new C10441(continuation);
        }
        Object obj = c10441.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c10441.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            if (!addConversationFields.getFields().isEmpty()) {
                MetadataManager metadataManager = this.metadataManager;
                Map<String, ? extends Object> fields = addConversationFields.getFields();
                c10441.label = 1;
                if (metadataManager.saveConversationFields(fields, c10441) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        return Effect.None.INSTANCE;
    }

    public final Object processAddConversationTags(Action.AddConversationTags addConversationTags, Continuation<? super Effect> continuation) throws Throwable {
        C10451 c10451;
        if (continuation instanceof C10451) {
            c10451 = (C10451) continuation;
            if ((c10451.label & Integer.MIN_VALUE) != 0) {
                c10451.label -= Integer.MIN_VALUE;
            } else {
                c10451 = new C10451(continuation);
            }
        } else {
            c10451 = new C10451(continuation);
        }
        Object obj = c10451.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c10451.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            if (!addConversationTags.getTags().isEmpty()) {
                MetadataManager metadataManager = this.metadataManager;
                List<String> tags = addConversationTags.getTags();
                c10451.label = 1;
                if (metadataManager.saveConversationTags(tags, c10451) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        return Effect.None.INSTANCE;
    }

    public final Object processClearConversationFields(Continuation<? super Effect> continuation) throws Throwable {
        C10471 c10471;
        if (continuation instanceof C10471) {
            c10471 = (C10471) continuation;
            if ((c10471.label & Integer.MIN_VALUE) != 0) {
                c10471.label -= Integer.MIN_VALUE;
            } else {
                c10471 = new C10471(continuation);
            }
        } else {
            c10471 = new C10471(continuation);
        }
        Object obj = c10471.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c10471.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            MetadataManager metadataManager = this.metadataManager;
            c10471.label = 1;
            if (metadataManager.clearConversationFields(c10471) == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        return Effect.None.INSTANCE;
    }

    public final Object processClearTags(Continuation<? super Effect> continuation) throws Throwable {
        C10491 c10491;
        if (continuation instanceof C10491) {
            c10491 = (C10491) continuation;
            if ((c10491.label & Integer.MIN_VALUE) != 0) {
                c10491.label -= Integer.MIN_VALUE;
            } else {
                c10491 = new C10491(continuation);
            }
        } else {
            c10491 = new C10491(continuation);
        }
        Object obj = c10491.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c10491.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            MetadataManager metadataManager = this.metadataManager;
            c10491.label = 1;
            if (metadataManager.clearConversationTags(c10491) == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        return Effect.None.INSTANCE;
    }
}
