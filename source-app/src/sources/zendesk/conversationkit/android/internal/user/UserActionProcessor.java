package zendesk.conversationkit.android.internal.user;

import cz.msebera.android.httpclient.HttpStatus;
import cz.msebera.android.httpclient.conn.params.ConnManagerParams;
import cz.msebera.android.httpclient.extras.Base64;
import cz.msebera.android.httpclient.util.LangUtils;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CancellationException;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.collections.immutable.implementations.immutableList.UtilsKt;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.serialization.SerializationException;
import net.aihelp.data.model.p005cs.ConversationMsg;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.data.track.data.TrackType;
import okhttp3.internal.p011ws.WebSocketProtocol;
import zendesk.conversationkit.android.ConversationKitError;
import zendesk.conversationkit.android.ConversationKitResult;
import zendesk.conversationkit.android.internal.Action;
import zendesk.conversationkit.android.internal.ActionProcessor;
import zendesk.conversationkit.android.internal.ConnectivityObserver;
import zendesk.conversationkit.android.internal.ConversationKitDispatchers;
import zendesk.conversationkit.android.internal.DefaultConversationKitDispatchers;
import zendesk.conversationkit.android.internal.Effect;
import zendesk.conversationkit.android.internal.attachments.AttachmentDownloader;
import zendesk.conversationkit.android.internal.exception.CantCreateConversationException;
import zendesk.conversationkit.android.internal.exception.ConversationHasNoPreviousMessagesException;
import zendesk.conversationkit.android.internal.exception.ConversationNotFoundException;
import zendesk.conversationkit.android.internal.exception.MessageAlreadyInConversationException;
import zendesk.conversationkit.android.internal.exception.MessageContentIsBlankException;
import zendesk.conversationkit.android.internal.exception.MultiConvoDisabledException;
import zendesk.conversationkit.android.internal.exception.ProactiveMessageNotFoundException;
import zendesk.conversationkit.android.internal.exception.UserAlreadyLoggedInException;
import zendesk.conversationkit.android.internal.extension.PrivateAttachmentUtilKt;
import zendesk.conversationkit.android.internal.faye.SunCoFayeClient;
import zendesk.conversationkit.android.internal.metadata.MetadataManager;
import zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository;
import zendesk.conversationkit.android.model.ActivityEvent;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.ConversationStatus;
import zendesk.conversationkit.android.model.ConversationsPagination;
import zendesk.conversationkit.android.model.MessageContent;
import zendesk.conversationkit.android.model.MessageKt;
import zendesk.conversationkit.android.model.MessageList;
import zendesk.conversationkit.android.model.MessageStatus;
import zendesk.conversationkit.android.model.ProactiveMessage;
import zendesk.conversationkit.android.model.User;
import zendesk.conversationkit.android.model.VisitType;
import zendesk.conversationkit.android.model.WaitTimeDataResponse;
import zendesk.conversationkit.android.model.attachments.DownloadAttachmentStatus;
import zendesk.conversationkit.android.model.attachments.ProcessAttachmentStatus;
import zendesk.logger.Logger;

@Metadata(m17d1 = {"\u0000Î\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0000\u0018\u0000 \u0080\u00012\u00020\u0001:\u0002\u0080\u0001B?\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\u0006\u0010\n\u001a\u00020\u000b\u0012\b\b\u0002\u0010\f\u001a\u00020\r\u0012\u0006\u0010\u000e\u001a\u00020\u000f¢\u0006\u0002\u0010\u0010J\u0016\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0014H\u0082@¢\u0006\u0002\u0010\u0015J\u000e\u0010\u0016\u001a\u00020\u0017H\u0086@¢\u0006\u0002\u0010\u0018J\u0016\u0010\u0019\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u001aH\u0082@¢\u0006\u0002\u0010\u001bJ\u0016\u0010\u001c\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u001dH\u0096@¢\u0006\u0002\u0010\u001eJ\u0016\u0010\u001f\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020 H\u0082@¢\u0006\u0002\u0010!J\u0016\u0010\"\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020#H\u0082@¢\u0006\u0002\u0010$J\u0016\u0010%\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020&H\u0082@¢\u0006\u0002\u0010'J\u0016\u0010(\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020)H\u0082@¢\u0006\u0002\u0010*J\u000e\u0010+\u001a\u00020\u0012H\u0082@¢\u0006\u0002\u0010\u0018J\u0016\u0010,\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020-H\u0082@¢\u0006\u0002\u0010.J\u000e\u0010/\u001a\u00020\u0012H\u0082@¢\u0006\u0002\u0010\u0018J\u0016\u00100\u001a\u00020\u00122\u0006\u00101\u001a\u000202H\u0082@¢\u0006\u0002\u00103J\u0016\u00104\u001a\u00020\u00122\u0006\u00101\u001a\u000202H\u0082@¢\u0006\u0002\u00103J\u0016\u00105\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u000206H\u0082@¢\u0006\u0002\u00107J\u0016\u00108\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u000209H\u0082@¢\u0006\u0002\u0010:J\b\u0010;\u001a\u00020<H\u0002J\u0016\u0010=\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020>H\u0082@¢\u0006\u0002\u0010?J\u0016\u0010@\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020AH\u0082@¢\u0006\u0002\u0010BJ\u0016\u0010C\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020DH\u0082@¢\u0006\u0002\u0010EJ\u0016\u0010F\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020GH\u0082@¢\u0006\u0002\u0010HJ\u000e\u0010I\u001a\u00020\u0012H\u0082@¢\u0006\u0002\u0010\u0018J\u0016\u0010J\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020KH\u0082@¢\u0006\u0002\u0010LJ\u0016\u0010M\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020NH\u0082@¢\u0006\u0002\u0010OJ\u0016\u0010P\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020QH\u0082@¢\u0006\u0002\u0010RJ\u000e\u0010S\u001a\u00020\u0012H\u0082@¢\u0006\u0002\u0010\u0018J\u0016\u0010T\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020UH\u0082@¢\u0006\u0002\u0010VJ\u0010\u0010W\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020XH\u0002J\u0010\u0010Y\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020ZH\u0002J\u0016\u0010[\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\\H\u0082@¢\u0006\u0002\u0010]J\u0016\u0010^\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020_H\u0082@¢\u0006\u0002\u0010`J\u0016\u0010a\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020bH\u0082@¢\u0006\u0002\u0010cJ\u000e\u0010d\u001a\u00020\u0012H\u0082@¢\u0006\u0002\u0010\u0018J\u0016\u0010e\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020fH\u0082@¢\u0006\u0002\u0010gJ\u0016\u0010h\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020iH\u0082@¢\u0006\u0002\u0010jJ\u0016\u0010k\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020lH\u0082@¢\u0006\u0002\u0010mJ\u0016\u0010n\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020oH\u0082@¢\u0006\u0002\u0010pJ\u0016\u0010q\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020rH\u0082@¢\u0006\u0002\u0010sJ\u0016\u0010t\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020uH\u0082@¢\u0006\u0002\u0010vJ\u0016\u0010w\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020xH\u0082@¢\u0006\u0002\u0010yJ\u0016\u0010z\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020{H\u0082@¢\u0006\u0002\u0010|J\u0016\u0010}\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020~H\u0082@¢\u0006\u0002\u0010\u007fR\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u000bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0081\u0001"}, m18d2 = {"Lzendesk/conversationkit/android/internal/user/UserActionProcessor;", "Lzendesk/conversationkit/android/internal/ActionProcessor;", "userActionProcessorRepository", "Lzendesk/conversationkit/android/internal/user/data/UserActionProcessorRepository;", "sunCoFayeClient", "Lzendesk/conversationkit/android/internal/faye/SunCoFayeClient;", "metadataManager", "Lzendesk/conversationkit/android/internal/metadata/MetadataManager;", "attachmentDownloader", "Lzendesk/conversationkit/android/internal/attachments/AttachmentDownloader;", "authenticationErrorHandler", "Lzendesk/conversationkit/android/internal/user/AuthenticationErrorHandler;", "conversationKitDispatchers", "Lzendesk/conversationkit/android/internal/ConversationKitDispatchers;", "connectivityObserver", "Lzendesk/conversationkit/android/internal/ConnectivityObserver;", "(Lzendesk/conversationkit/android/internal/user/data/UserActionProcessorRepository;Lzendesk/conversationkit/android/internal/faye/SunCoFayeClient;Lzendesk/conversationkit/android/internal/metadata/MetadataManager;Lzendesk/conversationkit/android/internal/attachments/AttachmentDownloader;Lzendesk/conversationkit/android/internal/user/AuthenticationErrorHandler;Lzendesk/conversationkit/android/internal/ConversationKitDispatchers;Lzendesk/conversationkit/android/internal/ConnectivityObserver;)V", "cacheIntegrationId", "Lzendesk/conversationkit/android/internal/Effect;", "action", "Lzendesk/conversationkit/android/internal/Action$PushCacheIntegrationId;", "(Lzendesk/conversationkit/android/internal/Action$PushCacheIntegrationId;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getUser", "Lzendesk/conversationkit/android/model/User;", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "preparePushToken", "Lzendesk/conversationkit/android/internal/Action$PreparePushToken;", "(Lzendesk/conversationkit/android/internal/Action$PreparePushToken;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "process", "Lzendesk/conversationkit/android/internal/Action;", "(Lzendesk/conversationkit/android/internal/Action;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processActivityEventReceived", "Lzendesk/conversationkit/android/internal/Action$ActivityEventReceived;", "(Lzendesk/conversationkit/android/internal/Action$ActivityEventReceived;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processAddConversationFields", "Lzendesk/conversationkit/android/internal/Action$AddConversationFields;", "(Lzendesk/conversationkit/android/internal/Action$AddConversationFields;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processAddConversationTags", "Lzendesk/conversationkit/android/internal/Action$AddConversationTags;", "(Lzendesk/conversationkit/android/internal/Action$AddConversationTags;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processAddProactiveMessage", "Lzendesk/conversationkit/android/internal/Action$AddProactiveMessage;", "(Lzendesk/conversationkit/android/internal/Action$AddProactiveMessage;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processClearConversationFields", "processClearProactiveMessage", "Lzendesk/conversationkit/android/internal/Action$ClearProactiveMessage;", "(Lzendesk/conversationkit/android/internal/Action$ClearProactiveMessage;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processClearTags", "processConversationAdded", "conversationId", "", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processConversationRemoved", "processConversationUpdate", "Lzendesk/conversationkit/android/internal/Action$ConversationUpdate;", "(Lzendesk/conversationkit/android/internal/Action$ConversationUpdate;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processCreateConversation", "Lzendesk/conversationkit/android/internal/Action$CreateConversation;", "(Lzendesk/conversationkit/android/internal/Action$CreateConversation;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processCreateUser", "Lzendesk/conversationkit/android/internal/Effect$CreateUserResult;", "processDownloadAttachmentAction", "Lzendesk/conversationkit/android/internal/Action$DownloadAttachmentAction;", "(Lzendesk/conversationkit/android/internal/Action$DownloadAttachmentAction;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processGetConversation", "Lzendesk/conversationkit/android/internal/Action$GetConversation;", "(Lzendesk/conversationkit/android/internal/Action$GetConversation;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processGetConversations", "Lzendesk/conversationkit/android/internal/Action$GetConversations;", "(Lzendesk/conversationkit/android/internal/Action$GetConversations;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processGetProactiveMessage", "Lzendesk/conversationkit/android/internal/Action$GetProactiveMessage;", "(Lzendesk/conversationkit/android/internal/Action$GetProactiveMessage;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processGetVisitTypeReceived", "processGetWaitTimeForConversation", "Lzendesk/conversationkit/android/internal/Action$GetWaitTimeForConversation;", "(Lzendesk/conversationkit/android/internal/Action$GetWaitTimeForConversation;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processLoadMoreMessages", "Lzendesk/conversationkit/android/internal/Action$LoadMoreMessages;", "(Lzendesk/conversationkit/android/internal/Action$LoadMoreMessages;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processLoginUser", "Lzendesk/conversationkit/android/internal/Action$LoginUser;", "(Lzendesk/conversationkit/android/internal/Action$LoginUser;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processLogoutUser", "processMessageReceived", "Lzendesk/conversationkit/android/internal/Action$MessageReceived;", "(Lzendesk/conversationkit/android/internal/Action$MessageReceived;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processNetworkConnectionStatusUpdate", "Lzendesk/conversationkit/android/internal/Action$NetworkConnectionStatusUpdate;", "processPersistedUserRetrieved", "Lzendesk/conversationkit/android/internal/Action$PersistedUserRetrieve;", "processPrepareMessage", "Lzendesk/conversationkit/android/internal/Action$PrepareMessage;", "(Lzendesk/conversationkit/android/internal/Action$PrepareMessage;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processProactiveMessageReferral", "Lzendesk/conversationkit/android/internal/Action$ProactiveMessageReferral;", "(Lzendesk/conversationkit/android/internal/Action$ProactiveMessageReferral;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processRefreshConversation", "Lzendesk/conversationkit/android/internal/Action$RefreshConversation;", "(Lzendesk/conversationkit/android/internal/Action$RefreshConversation;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processRefreshUser", "processSendMessage", "Lzendesk/conversationkit/android/internal/Action$SendMessage;", "(Lzendesk/conversationkit/android/internal/Action$SendMessage;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processSendPostbackAction", "Lzendesk/conversationkit/android/internal/Action$SendPostbackAction;", "(Lzendesk/conversationkit/android/internal/Action$SendPostbackAction;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processSetVisitTypeReceived", "Lzendesk/conversationkit/android/internal/Action$SetVisitType;", "(Lzendesk/conversationkit/android/internal/Action$SetVisitType;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processUpdateAppUserLocale", "Lzendesk/conversationkit/android/internal/Action$UpdateAppUserLocale;", "(Lzendesk/conversationkit/android/internal/Action$UpdateAppUserLocale;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processUpdateConversationMetadata", "Lzendesk/conversationkit/android/internal/Action$UpdateConversationMetadata;", "(Lzendesk/conversationkit/android/internal/Action$UpdateConversationMetadata;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processUpdateDownloadStatusAction", "Lzendesk/conversationkit/android/internal/Action$UpdateDownloadStatusAction;", "(Lzendesk/conversationkit/android/internal/Action$UpdateDownloadStatusAction;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processUserMerge", "Lzendesk/conversationkit/android/internal/Action$UserMergeReceived;", "(Lzendesk/conversationkit/android/internal/Action$UserMergeReceived;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "sendActivityData", "Lzendesk/conversationkit/android/internal/Action$SendActivityData;", "(Lzendesk/conversationkit/android/internal/Action$SendActivityData;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "updatePushToken", "Lzendesk/conversationkit/android/internal/Action$UpdatePushToken;", "(Lzendesk/conversationkit/android/internal/Action$UpdatePushToken;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class UserActionProcessor implements ActionProcessor {
    private static final double BEFORE_TIMESTAMP = 0.0d;
    private static final String GET_CONVERSATION_SERIALIZATION_EXCEPTION_LOG_MESSAGE = "GET request for Conversation failed to decode malformed JSON response.";
    private static final String LOG_TAG = "UserActionProcessor";
    private final AttachmentDownloader attachmentDownloader;
    private final AuthenticationErrorHandler authenticationErrorHandler;
    private final ConnectivityObserver connectivityObserver;
    private final ConversationKitDispatchers conversationKitDispatchers;
    private final MetadataManager metadataManager;
    private final SunCoFayeClient sunCoFayeClient;
    private final UserActionProcessorRepository userActionProcessorRepository;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {0}, m39l = {627}, m40m = "cacheIntegrationId", m41n = {"action"}, m42s = {"L$0"})
    static final class C10971 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C10971(Continuation<? super C10971> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.cacheIntegrationId(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {0}, m39l = {622}, m40m = "preparePushToken", m41n = {"action"}, m42s = {"L$0"})
    static final class C10981 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C10981(Continuation<? super C10981> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.preparePushToken(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {0}, m39l = {709}, m40m = "processActivityEventReceived", m41n = {"action"}, m42s = {"L$0"})
    static final class C11001 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C11001(Continuation<? super C11001> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processActivityEventReceived(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {881}, m40m = "processAddConversationFields", m41n = {}, m42s = {})
    static final class C11011 extends ContinuationImpl {
        int label;
        Object result;

        C11011(Continuation<? super C11011> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processAddConversationFields(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {895}, m40m = "processAddConversationTags", m41n = {}, m42s = {})
    static final class C11021 extends ContinuationImpl {
        int label;
        Object result;

        C11021(Continuation<? super C11021> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processAddConversationTags(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {740}, m40m = "processAddProactiveMessage", m41n = {}, m42s = {})
    static final class C11031 extends ContinuationImpl {
        int label;
        Object result;

        C11031(Continuation<? super C11031> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processAddProactiveMessage(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {904}, m40m = "processClearConversationFields", m41n = {}, m42s = {})
    static final class C11041 extends ContinuationImpl {
        int label;
        Object result;

        C11041(Continuation<? super C11041> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processClearConversationFields(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {759}, m40m = "processClearProactiveMessage", m41n = {}, m42s = {})
    static final class C11051 extends ContinuationImpl {
        int label;
        Object result;

        C11051(Continuation<? super C11051> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processClearProactiveMessage(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {912}, m40m = "processClearTags", m41n = {}, m42s = {})
    static final class C11061 extends ContinuationImpl {
        int label;
        Object result;

        C11061(Continuation<? super C11061> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processClearTags(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {773}, m40m = "processConversationAdded", m41n = {}, m42s = {})
    static final class C11071 extends ContinuationImpl {
        int label;
        Object result;

        C11071(Continuation<? super C11071> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processConversationAdded(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {0}, m39l = {796}, m40m = "processConversationRemoved", m41n = {"conversationId"}, m42s = {"L$0"})
    static final class C11091 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C11091(Continuation<? super C11091> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processConversationRemoved(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {816}, m40m = "processConversationUpdate", m41n = {}, m42s = {})
    static final class C11101 extends ContinuationImpl {
        int label;
        Object result;

        C11101(Continuation<? super C11101> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processConversationUpdate(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {0}, m39l = {293, TrackType.TRACK_FAQ_CHECKED_IN_ANSWER_BOT, 323, 333, 340}, m40m = "processCreateConversation", m41n = {"this"}, m42s = {"L$0"})
    static final class C11111 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C11111(Continuation<? super C11111> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processCreateConversation(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {0, 0}, m39l = {986, 996}, m40m = "processDownloadAttachmentAction", m41n = {"this", "action"}, m42s = {"L$0", "L$1"})
    static final class C11131 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        int label;
        Object result;

        C11131(Continuation<? super C11131> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processDownloadAttachmentAction(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {0, 0}, m39l = {354, 361}, m40m = "processGetConversation", m41n = {"this", "action"}, m42s = {"L$0", "L$1"})
    static final class C11141 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C11141(Continuation<? super C11141> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processGetConversation(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {842}, m40m = "processGetConversations", m41n = {}, m42s = {})
    static final class C11161 extends ContinuationImpl {
        int label;
        Object result;

        C11161(Continuation<? super C11161> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processGetConversations(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {0}, m39l = {748}, m40m = "processGetProactiveMessage", m41n = {"action"}, m42s = {"L$0"})
    static final class C11181 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C11181(Continuation<? super C11181> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processGetProactiveMessage(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {TrackType.TRACK_FAQ_MARKED_HELPFUL}, m40m = "processGetVisitTypeReceived", m41n = {}, m42s = {})
    static final class C11191 extends ContinuationImpl {
        int label;
        Object result;

        C11191(Continuation<? super C11191> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processGetVisitTypeReceived(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {0}, m39l = {1065}, m40m = "processGetWaitTimeForConversation", m41n = {"action"}, m42s = {"L$0"})
    static final class C11201 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C11201(Continuation<? super C11201> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processGetWaitTimeForConversation(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {0, 0, 1, 2}, m39l = {478, HttpStatus.SC_INSUFFICIENT_STORAGE, 516}, m40m = "processLoadMoreMessages", m41n = {"this", "action", "serializationException", "e"}, m42s = {"L$0", "L$1", "L$0", "L$0"})
    static final class C11221 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C11221(Continuation<? super C11221> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processLoadMoreMessages(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {0}, m39l = {187, 197}, m40m = "processLoginUser", m41n = {"this"}, m42s = {"L$0"})
    static final class C11241 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C11241(Continuation<? super C11241> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processLoginUser(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {217}, m40m = "processLogoutUser", m41n = {}, m42s = {})
    static final class C11261 extends ContinuationImpl {
        int label;
        Object result;

        C11261(Continuation<? super C11261> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processLogoutUser(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {0}, m39l = {451}, m40m = "processMessageReceived", m41n = {"action"}, m42s = {"L$0"})
    static final class C11281 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C11281(Continuation<? super C11281> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processMessageReceived(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {0, 0, 1, 1, 1, 2}, m39l = {542, 546, 551, 552}, m40m = "processPrepareMessage", m41n = {"this", "action", "this", "action", "pendingMessage", "this"}, m42s = {"L$0", "L$1", "L$0", "L$1", "L$2", "L$0"})
    static final class C11291 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        boolean Z$0;
        int label;
        Object result;

        C11291(Continuation<? super C11291> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processPrepareMessage(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {389}, m40m = "processProactiveMessageReferral", m41n = {}, m42s = {})
    static final class C11301 extends ContinuationImpl {
        int label;
        Object result;

        C11301(Continuation<? super C11301> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processProactiveMessageReferral(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {428}, m40m = "processRefreshConversation", m41n = {}, m42s = {})
    static final class C11321 extends ContinuationImpl {
        int label;
        Object result;

        C11321(Continuation<? super C11321> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processRefreshConversation(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {239}, m40m = "processRefreshUser", m41n = {}, m42s = {})
    static final class C11341 extends ContinuationImpl {
        int label;
        Object result;

        C11341(Continuation<? super C11341> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processRefreshUser(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {0, 0}, m39l = {575, 597, 609}, m40m = "processSendMessage", m41n = {"this", "action"}, m42s = {"L$0", "L$1"})
    static final class C11361 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C11361(Continuation<? super C11361> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processSendMessage(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {955}, m40m = "processSendPostbackAction", m41n = {}, m42s = {})
    static final class C11381 extends ContinuationImpl {
        int label;
        Object result;

        C11381(Continuation<? super C11381> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processSendPostbackAction(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {147}, m40m = "processSetVisitTypeReceived", m41n = {}, m42s = {})
    static final class C11401 extends ContinuationImpl {
        int label;
        Object result;

        C11401(Continuation<? super C11401> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processSetVisitTypeReceived(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {270}, m40m = "processUpdateAppUserLocale", m41n = {}, m42s = {})
    static final class C11411 extends ContinuationImpl {
        int label;
        Object result;

        C11411(Continuation<? super C11411> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processUpdateAppUserLocale(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {0}, m39l = {925}, m40m = "processUpdateConversationMetadata", m41n = {"action"}, m42s = {"L$0"})
    static final class C11431 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C11431(Continuation<? super C11431> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processUpdateConversationMetadata(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {1029, 1039}, m40m = "processUpdateDownloadStatusAction", m41n = {}, m42s = {})
    static final class C11451 extends ContinuationImpl {
        int label;
        Object result;

        C11451(Continuation<? super C11451> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processUpdateDownloadStatusAction(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {0, 0, 1}, m39l = {864, 865, 866}, m40m = "processUserMerge", m41n = {"this", "action", "this"}, m42s = {"L$0", "L$1", "L$0"})
    static final class C11481 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C11481(Continuation<? super C11481> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.processUserMerge(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {678}, m40m = "sendActivityData", m41n = {}, m42s = {})
    static final class C11491 extends ContinuationImpl {
        int label;
        Object result;

        C11491(Continuation<? super C11491> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.sendActivityData(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor", m37f = "UserActionProcessor.kt", m38i = {0}, m39l = {642}, m40m = "updatePushToken", m41n = {"pushToken"}, m42s = {"L$0"})
    static final class C11511 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C11511(Continuation<? super C11511> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessor.this.updatePushToken(null, this);
        }
    }

    public UserActionProcessor(UserActionProcessorRepository userActionProcessorRepository, SunCoFayeClient sunCoFayeClient, MetadataManager metadataManager, AttachmentDownloader attachmentDownloader, AuthenticationErrorHandler authenticationErrorHandler, ConversationKitDispatchers conversationKitDispatchers, ConnectivityObserver connectivityObserver) {
        Intrinsics.checkNotNullParameter(userActionProcessorRepository, "userActionProcessorRepository");
        Intrinsics.checkNotNullParameter(sunCoFayeClient, "sunCoFayeClient");
        Intrinsics.checkNotNullParameter(metadataManager, "metadataManager");
        Intrinsics.checkNotNullParameter(attachmentDownloader, "attachmentDownloader");
        Intrinsics.checkNotNullParameter(authenticationErrorHandler, "authenticationErrorHandler");
        Intrinsics.checkNotNullParameter(conversationKitDispatchers, "conversationKitDispatchers");
        Intrinsics.checkNotNullParameter(connectivityObserver, "connectivityObserver");
        this.userActionProcessorRepository = userActionProcessorRepository;
        this.sunCoFayeClient = sunCoFayeClient;
        this.metadataManager = metadataManager;
        this.attachmentDownloader = attachmentDownloader;
        this.authenticationErrorHandler = authenticationErrorHandler;
        this.conversationKitDispatchers = conversationKitDispatchers;
        this.connectivityObserver = connectivityObserver;
    }

    public UserActionProcessor(UserActionProcessorRepository userActionProcessorRepository, SunCoFayeClient sunCoFayeClient, MetadataManager metadataManager, AttachmentDownloader attachmentDownloader, AuthenticationErrorHandler authenticationErrorHandler, ConversationKitDispatchers conversationKitDispatchers, ConnectivityObserver connectivityObserver, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(userActionProcessorRepository, sunCoFayeClient, metadataManager, attachmentDownloader, authenticationErrorHandler, (i & 32) != 0 ? new DefaultConversationKitDispatchers() : conversationKitDispatchers, connectivityObserver);
    }

    public final Object getUser(Continuation<? super User> continuation) {
        return this.userActionProcessorRepository.getUser(continuation);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/conversationkit/android/internal/Effect;", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor$process$2", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {84, 85, 86, 87, 88, ConversationMsg.TYPE_ADMIN_VIDEO, 92, 93, 94, 95, 96, 97, 98, 101, 102, 103, 104, 107, 108, 109, 112, 113, 116, 117, 120, 121, 122, 123, WebSocketProtocol.PAYLOAD_SHORT, 127, 128, 129, 132, 135, 136, 138}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10992 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Effect>, Object> {
        final Action $action;
        int label;
        final UserActionProcessor this$0;

        C10992(Action action, UserActionProcessor userActionProcessor, Continuation<? super C10992> continuation) {
            super(2, continuation);
            this.$action = action;
            this.this$0 = userActionProcessor;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return new C10992(this.$action, this.this$0, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Effect> continuation) {
            return ((C10992) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Exception {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            switch (this.label) {
                case 0:
                    ResultKt.throwOnFailure(obj);
                    Action action = this.$action;
                    if (action instanceof Action.NetworkConnectionStatusUpdate) {
                        return this.this$0.processNetworkConnectionStatusUpdate((Action.NetworkConnectionStatusUpdate) action);
                    }
                    if (action instanceof Action.StartRealtimeConnection) {
                        this.this$0.connectivityObserver.connect();
                        this.this$0.sunCoFayeClient.connect();
                        return Effect.None.INSTANCE;
                    }
                    if (action instanceof Action.PauseRealtimeConnection) {
                        this.this$0.connectivityObserver.disconnect();
                        this.this$0.sunCoFayeClient.disconnect();
                        return Effect.None.INSTANCE;
                    }
                    if (action instanceof Action.RealtimeConnectionStatusUpdate) {
                        return new Effect.RealtimeConnectionChanged(((Action.RealtimeConnectionStatusUpdate) this.$action).getConnectionStatus());
                    }
                    if (action instanceof Action.CreateUser) {
                        return this.this$0.processCreateUser();
                    }
                    if (action instanceof Action.RefreshUser) {
                        this.label = 1;
                        obj = this.this$0.processRefreshUser(this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.LoginUser) {
                        this.label = 2;
                        obj = this.this$0.processLoginUser((Action.LoginUser) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.LogoutUser) {
                        this.label = 3;
                        obj = this.this$0.processLogoutUser(this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.UpdateAppUserLocale) {
                        this.label = 4;
                        obj = this.this$0.processUpdateAppUserLocale((Action.UpdateAppUserLocale) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.UserMergeReceived) {
                        this.label = 5;
                        obj = this.this$0.processUserMerge((Action.UserMergeReceived) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.ConversationAdded) {
                        this.label = 6;
                        obj = this.this$0.processConversationAdded(((Action.ConversationAdded) action).getConversationId(), this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.ConversationRemoved) {
                        this.label = 7;
                        obj = this.this$0.processConversationRemoved(((Action.ConversationRemoved) action).getConversationId(), this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.ConversationUpdate) {
                        this.label = 8;
                        obj = this.this$0.processConversationUpdate((Action.ConversationUpdate) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.CreateConversation) {
                        this.label = 9;
                        obj = this.this$0.processCreateConversation((Action.CreateConversation) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.GetConversation) {
                        this.label = 10;
                        obj = this.this$0.processGetConversation((Action.GetConversation) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.UpdateConversationMetadata) {
                        this.label = 11;
                        obj = this.this$0.processUpdateConversationMetadata((Action.UpdateConversationMetadata) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.RefreshConversation) {
                        this.label = 12;
                        obj = this.this$0.processRefreshConversation((Action.RefreshConversation) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.GetConversations) {
                        this.label = 13;
                        obj = this.this$0.processGetConversations((Action.GetConversations) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.MessageReceived) {
                        this.label = 14;
                        obj = this.this$0.processMessageReceived((Action.MessageReceived) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.LoadMoreMessages) {
                        this.label = 15;
                        obj = this.this$0.processLoadMoreMessages((Action.LoadMoreMessages) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.PrepareMessage) {
                        this.label = 16;
                        obj = this.this$0.processPrepareMessage((Action.PrepareMessage) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.SendMessage) {
                        this.label = 17;
                        obj = this.this$0.processSendMessage((Action.SendMessage) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.PreparePushToken) {
                        this.label = 18;
                        obj = this.this$0.preparePushToken((Action.PreparePushToken) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.UpdatePushToken) {
                        this.label = 19;
                        obj = this.this$0.updatePushToken((Action.UpdatePushToken) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.PushCacheIntegrationId) {
                        this.label = 20;
                        obj = this.this$0.cacheIntegrationId((Action.PushCacheIntegrationId) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.SendActivityData) {
                        this.label = 21;
                        obj = this.this$0.sendActivityData((Action.SendActivityData) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.ActivityEventReceived) {
                        this.label = 22;
                        obj = this.this$0.processActivityEventReceived((Action.ActivityEventReceived) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.PersistedUserRetrieve) {
                        return this.this$0.processPersistedUserRetrieved((Action.PersistedUserRetrieve) action);
                    }
                    if (action instanceof Action.GetVisitType) {
                        this.label = 23;
                        obj = this.this$0.processGetVisitTypeReceived(this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.SetVisitType) {
                        this.label = 24;
                        obj = this.this$0.processSetVisitTypeReceived((Action.SetVisitType) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.AddProactiveMessage) {
                        this.label = 25;
                        obj = this.this$0.processAddProactiveMessage((Action.AddProactiveMessage) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.GetProactiveMessage) {
                        this.label = 26;
                        obj = this.this$0.processGetProactiveMessage((Action.GetProactiveMessage) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.ProactiveMessageReferral) {
                        this.label = 27;
                        obj = this.this$0.processProactiveMessageReferral((Action.ProactiveMessageReferral) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.ClearProactiveMessage) {
                        this.label = 28;
                        obj = this.this$0.processClearProactiveMessage((Action.ClearProactiveMessage) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.AddConversationFields) {
                        this.label = 29;
                        obj = this.this$0.processAddConversationFields((Action.AddConversationFields) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.AddConversationTags) {
                        this.label = 30;
                        obj = this.this$0.processAddConversationTags((Action.AddConversationTags) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.ClearConversationFields) {
                        this.label = 31;
                        obj = this.this$0.processClearConversationFields(this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.ClearConversationTags) {
                        this.label = 32;
                        obj = this.this$0.processClearTags(this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.SendPostbackAction) {
                        this.label = 33;
                        obj = this.this$0.processSendPostbackAction((Action.SendPostbackAction) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.DownloadAttachmentAction) {
                        this.label = 34;
                        obj = this.this$0.processDownloadAttachmentAction((Action.DownloadAttachmentAction) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.UpdateDownloadStatusAction) {
                        this.label = 35;
                        obj = this.this$0.processUpdateDownloadStatusAction((Action.UpdateDownloadStatusAction) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    if (action instanceof Action.GetWaitTimeForConversation) {
                        this.label = 36;
                        obj = this.this$0.processGetWaitTimeForConversation((Action.GetWaitTimeForConversation) action, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) obj;
                    }
                    Logger.m225w(UserActionProcessor.LOG_TAG, this.$action + " cannot be processed.", new Object[0]);
                    return Effect.IncorrectAccessLevel.INSTANCE;
                case 1:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case 2:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case 3:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case 4:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case 5:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case 6:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case 7:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case 8:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case 9:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case 10:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case 11:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case Message.TYPE_USER_VIDEO:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case 13:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case Message.TYPE_USER_FILE:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case WebSocketProtocol.B0_MASK_OPCODE:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case 16:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case LangUtils.HASH_SEED:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case 18:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case Base64.Encoder.LINE_GROUPS:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case ConnManagerParams.DEFAULT_MAX_TOTAL_CONNECTIONS:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case ConversationMsg.TYPE_USER_TEXT:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case 22:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case 23:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case 24:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case 25:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case 26:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case 27:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case 28:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case 29:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case 30:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case 31:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case 32:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case UtilsKt.MUTABLE_BUFFER_SIZE:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case 34:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case 35:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                case 36:
                    ResultKt.throwOnFailure(obj);
                    return (Effect) obj;
                default:
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
        }
    }

    @Override
    public Object process(Action action, Continuation<? super Effect> continuation) {
        return BuildersKt.withContext(this.conversationKitDispatchers.mo201io(), new C10992(action, this, null), continuation);
    }

    public final Object processSetVisitTypeReceived(Action.SetVisitType setVisitType, Continuation<? super Effect> continuation) throws Throwable {
        C11401 c11401;
        if (continuation instanceof C11401) {
            c11401 = (C11401) continuation;
            if ((c11401.label & Integer.MIN_VALUE) != 0) {
                c11401.label -= Integer.MIN_VALUE;
            } else {
                c11401 = new C11401(continuation);
            }
        } else {
            c11401 = new C11401(continuation);
        }
        Object obj = c11401.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11401.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            UserActionProcessorRepository userActionProcessorRepository = this.userActionProcessorRepository;
            VisitType visitType = setVisitType.getVisitType();
            c11401.label = 1;
            if (userActionProcessorRepository.setVisitType(visitType, c11401) == coroutine_suspended) {
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
        C11191 c11191;
        if (continuation instanceof C11191) {
            c11191 = (C11191) continuation;
            if ((c11191.label & Integer.MIN_VALUE) != 0) {
                c11191.label -= Integer.MIN_VALUE;
            } else {
                c11191 = new C11191(continuation);
            }
        } else {
            c11191 = new C11191(continuation);
        }
        Object visitType = c11191.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11191.label;
        if (i == 0) {
            ResultKt.throwOnFailure(visitType);
            UserActionProcessorRepository userActionProcessorRepository = this.userActionProcessorRepository;
            c11191.label = 1;
            visitType = userActionProcessorRepository.getVisitType(c11191);
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

    public final Effect processNetworkConnectionStatusUpdate(Action.NetworkConnectionStatusUpdate action) {
        return new Effect.NetworkConnectionChanged(action.getConnectionStatus());
    }

    public final Effect.CreateUserResult processCreateUser() {
        return new Effect.CreateUserResult(new ConversationKitResult.Failure(ConversationKitError.UserAlreadyExists.INSTANCE), null, 2, null);
    }

    public final Object processLoginUser(Action.LoginUser loginUser, Continuation<? super Effect> continuation) throws Exception {
        C11241 c11241;
        UserActionProcessor userActionProcessor;
        if (continuation instanceof C11241) {
            c11241 = (C11241) continuation;
            if ((c11241.label & Integer.MIN_VALUE) != 0) {
                c11241.label -= Integer.MIN_VALUE;
            } else {
                c11241 = new C11241(continuation);
            }
        } else {
            c11241 = new C11241(continuation);
        }
        Object objExecuteWithAuthErrorHandling = c11241.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11241.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling);
                try {
                    AuthenticationErrorHandler authenticationErrorHandler = this.authenticationErrorHandler;
                    String jwt = loginUser.getJwt();
                    C11252 c11252 = new C11252(loginUser, null);
                    c11241.L$0 = this;
                    c11241.label = 1;
                    objExecuteWithAuthErrorHandling = authenticationErrorHandler.executeWithAuthErrorHandling(jwt, c11252, c11241);
                    if (objExecuteWithAuthErrorHandling == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    userActionProcessor = this;
                } catch (UserAlreadyLoggedInException unused) {
                    userActionProcessor = this;
                    Logger.m225w(LOG_TAG, "Login skipped: user with this JWT already logged in.", new Object[0]);
                    UserActionProcessorRepository userActionProcessorRepository = userActionProcessor.userActionProcessorRepository;
                    c11241.L$0 = null;
                    c11241.label = 2;
                    objExecuteWithAuthErrorHandling = userActionProcessorRepository.getUser(c11241);
                    if (objExecuteWithAuthErrorHandling == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    return new Effect.AlreadyLoggedInResult(new ConversationKitResult.Success(objExecuteWithAuthErrorHandling));
                }
            } else {
                if (i != 1) {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling);
                    return new Effect.AlreadyLoggedInResult(new ConversationKitResult.Success(objExecuteWithAuthErrorHandling));
                }
                userActionProcessor = (UserActionProcessor) c11241.L$0;
                try {
                    ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling);
                } catch (UserAlreadyLoggedInException unused2) {
                    Logger.m225w(LOG_TAG, "Login skipped: user with this JWT already logged in.", new Object[0]);
                    UserActionProcessorRepository userActionProcessorRepository2 = userActionProcessor.userActionProcessorRepository;
                    c11241.L$0 = null;
                    c11241.label = 2;
                    objExecuteWithAuthErrorHandling = userActionProcessorRepository2.getUser(c11241);
                    if (objExecuteWithAuthErrorHandling == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    return new Effect.AlreadyLoggedInResult(new ConversationKitResult.Success(objExecuteWithAuthErrorHandling));
                }
            }
            return (Effect) objExecuteWithAuthErrorHandling;
        } catch (Exception e) {
            if (e instanceof CancellationException) {
                throw e;
            }
            Exception exc = e;
            Logger.m218e(LOG_TAG, "Failed to login.", exc, new Object[0]);
            return new Effect.LoginUserResult(new ConversationKitResult.Failure(exc));
        }
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/conversationkit/android/internal/Effect;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor$processLoginUser$2", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {188}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C11252 extends SuspendLambda implements Function1<Continuation<? super Effect>, Object> {
        final Action.LoginUser $action;
        int label;

        C11252(Action.LoginUser loginUser, Continuation<? super C11252> continuation) {
            super(1, continuation);
            this.$action = loginUser;
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return UserActionProcessor.this.new C11252(this.$action, continuation);
        }

        @Override
        public final Object invoke(Continuation<? super Effect> continuation) {
            return ((C11252) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                obj = UserActionProcessor.this.userActionProcessorRepository.login(this.$action.getJwt(), this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            UserActionProcessor.this.sunCoFayeClient.disconnect();
            return new Effect.LoginUserResult(new ConversationKitResult.Success((User) obj));
        }
    }

    public final Object processLogoutUser(Continuation<? super Effect> continuation) throws Exception {
        C11261 c11261;
        if (continuation instanceof C11261) {
            c11261 = (C11261) continuation;
            if ((c11261.label & Integer.MIN_VALUE) != 0) {
                c11261.label -= Integer.MIN_VALUE;
            } else {
                c11261 = new C11261(continuation);
            }
        } else {
            c11261 = new C11261(continuation);
        }
        C11261 c11262 = c11261;
        Object objExecuteWithAuthErrorHandling$default = c11262.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11262.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
                AuthenticationErrorHandler authenticationErrorHandler = this.authenticationErrorHandler;
                C11272 c11272 = new C11272(null);
                c11262.label = 1;
                objExecuteWithAuthErrorHandling$default = AuthenticationErrorHandler.executeWithAuthErrorHandling$default(authenticationErrorHandler, null, c11272, c11262, 1, null);
                if (objExecuteWithAuthErrorHandling$default == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
            }
            return (Effect) objExecuteWithAuthErrorHandling$default;
        } catch (Exception e) {
            if (e instanceof CancellationException) {
                throw e;
            }
            Exception exc = e;
            Logger.m218e(LOG_TAG, "Failed to logout the user.", exc, new Object[0]);
            return new Effect.LoginUserResult(new ConversationKitResult.Failure(exc));
        }
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/conversationkit/android/internal/Effect;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor$processLogoutUser$2", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {218, 219}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C11272 extends SuspendLambda implements Function1<Continuation<? super Effect>, Object> {
        int label;

        C11272(Continuation<? super C11272> continuation) {
            super(1, continuation);
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return UserActionProcessor.this.new C11272(continuation);
        }

        @Override
        public final Object invoke(Continuation<? super Effect> continuation) {
            return ((C11272) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (UserActionProcessor.this.userActionProcessorRepository.logout(this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i == 1) {
                    ResultKt.throwOnFailure(obj);
                } else {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                return new Effect.LogoutUserResult(((Effect.UserAccessRevoked) obj).getResult());
            }
            this.label = 2;
            obj = AuthenticationErrorHandler.revokeUser$default(UserActionProcessor.this.authenticationErrorHandler, null, this, 1, null);
            if (obj == coroutine_suspended) {
                return coroutine_suspended;
            }
            return new Effect.LogoutUserResult(((Effect.UserAccessRevoked) obj).getResult());
        }
    }

    public final Object processRefreshUser(Continuation<? super Effect> continuation) throws Exception {
        C11341 c11341;
        if (continuation instanceof C11341) {
            c11341 = (C11341) continuation;
            if ((c11341.label & Integer.MIN_VALUE) != 0) {
                c11341.label -= Integer.MIN_VALUE;
            } else {
                c11341 = new C11341(continuation);
            }
        } else {
            c11341 = new C11341(continuation);
        }
        C11341 c11342 = c11341;
        Object objExecuteWithAuthErrorHandling$default = c11342.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11342.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
                AuthenticationErrorHandler authenticationErrorHandler = this.authenticationErrorHandler;
                C11352 c11352 = new C11352(null);
                c11342.label = 1;
                objExecuteWithAuthErrorHandling$default = AuthenticationErrorHandler.executeWithAuthErrorHandling$default(authenticationErrorHandler, null, c11352, c11342, 1, null);
                if (objExecuteWithAuthErrorHandling$default == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
            }
            return (Effect) objExecuteWithAuthErrorHandling$default;
        } catch (SerializationException e) {
            SerializationException serializationException = e;
            Logger.m218e(LOG_TAG, "GET request for AppUser failed to decode malformed JSON response.", serializationException, new Object[0]);
            return new Effect.RefreshUserResult(new ConversationKitResult.Failure(serializationException), null, 2, null);
        } catch (Exception e2) {
            if (e2 instanceof CancellationException) {
                throw e2;
            }
            Exception exc = e2;
            Logger.m218e(LOG_TAG, "Failed to get appUser.", exc, new Object[0]);
            return new Effect.RefreshUserResult(new ConversationKitResult.Failure(exc), null, 2, null);
        }
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/conversationkit/android/internal/Effect;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor$processRefreshUser$2", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {240, 243}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C11352 extends SuspendLambda implements Function1<Continuation<? super Effect>, Object> {
        Object L$0;
        int label;

        C11352(Continuation<? super C11352> continuation) {
            super(1, continuation);
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return UserActionProcessor.this.new C11352(continuation);
        }

        @Override
        public final Object invoke(Continuation<? super Effect> continuation) {
            return ((C11352) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            ConversationKitResult conversationKitResult;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                obj = UserActionProcessor.this.userActionProcessorRepository.refreshUser(this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i == 1) {
                    ResultKt.throwOnFailure(obj);
                } else {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    conversationKitResult = (ConversationKitResult) this.L$0;
                    ResultKt.throwOnFailure(obj);
                }
                return new Effect.RefreshUserResult(conversationKitResult, (Conversation) obj);
            }
            User user = (User) obj;
            ConversationKitResult.Success success = new ConversationKitResult.Success(user);
            this.L$0 = success;
            this.label = 2;
            obj = UserActionProcessor.this.userActionProcessorRepository.getPersistedConversation(UserExtensionsKt.getDefaultConversationId(user), this);
            if (obj == coroutine_suspended) {
                return coroutine_suspended;
            }
            conversationKitResult = success;
            return new Effect.RefreshUserResult(conversationKitResult, (Conversation) obj);
        }
    }

    public final Object processUpdateAppUserLocale(Action.UpdateAppUserLocale updateAppUserLocale, Continuation<? super Effect> continuation) throws Exception {
        C11411 c11411;
        if (continuation instanceof C11411) {
            c11411 = (C11411) continuation;
            if ((c11411.label & Integer.MIN_VALUE) != 0) {
                c11411.label -= Integer.MIN_VALUE;
            } else {
                c11411 = new C11411(continuation);
            }
        } else {
            c11411 = new C11411(continuation);
        }
        C11411 c11412 = c11411;
        Object objExecuteWithAuthErrorHandling$default = c11412.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11412.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
                AuthenticationErrorHandler authenticationErrorHandler = this.authenticationErrorHandler;
                C11422 c11422 = new C11422(updateAppUserLocale, null);
                c11412.label = 1;
                objExecuteWithAuthErrorHandling$default = AuthenticationErrorHandler.executeWithAuthErrorHandling$default(authenticationErrorHandler, null, c11422, c11412, 1, null);
                if (objExecuteWithAuthErrorHandling$default == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
            }
            return (Effect) objExecuteWithAuthErrorHandling$default;
        } catch (SerializationException e) {
            Logger.m218e(LOG_TAG, "PUT request for AppUser failed to decode malformed JSON response.", e, new Object[0]);
            return Effect.None.INSTANCE;
        } catch (Exception e2) {
            if (e2 instanceof CancellationException) {
                throw e2;
            }
            Logger.m218e(LOG_TAG, "Failed to update app user locale.", e2, new Object[0]);
            return Effect.None.INSTANCE;
        }
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/conversationkit/android/internal/Effect;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor$processUpdateAppUserLocale$2", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {271}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C11422 extends SuspendLambda implements Function1<Continuation<? super Effect>, Object> {
        final Action.UpdateAppUserLocale $action;
        int label;

        C11422(Action.UpdateAppUserLocale updateAppUserLocale, Continuation<? super C11422> continuation) {
            super(1, continuation);
            this.$action = updateAppUserLocale;
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return UserActionProcessor.this.new C11422(this.$action, continuation);
        }

        @Override
        public final Object invoke(Continuation<? super Effect> continuation) {
            return ((C11422) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (UserActionProcessor.this.userActionProcessorRepository.updateAppUserLocale(this.$action.getDeviceLocale(), this) == coroutine_suspended) {
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

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/conversationkit/android/internal/Effect;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor$processCreateConversation$2", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {296, 294, 300}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C11122 extends SuspendLambda implements Function1<Continuation<? super Effect>, Object> {
        final Action.CreateConversation $action;
        Object L$0;
        Object L$1;
        int label;

        C11122(Action.CreateConversation createConversation, Continuation<? super C11122> continuation) {
            super(1, continuation);
            this.$action = createConversation;
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return UserActionProcessor.this.new C11122(this.$action, continuation);
        }

        @Override
        public final Object invoke(Continuation<? super Effect> continuation) {
            return ((C11122) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Integer proactiveMessageId;
            UserActionProcessorRepository userActionProcessorRepository;
            ConversationKitResult.Success success;
            Object user;
            ConversationKitResult conversationKitResult;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i != 0) {
                if (i == 1) {
                    proactiveMessageId = (Integer) this.L$1;
                    userActionProcessorRepository = (UserActionProcessorRepository) this.L$0;
                    ResultKt.throwOnFailure(obj);
                } else if (i == 2) {
                    ResultKt.throwOnFailure(obj);
                    success = new ConversationKitResult.Success((Conversation) obj);
                    this.L$0 = success;
                    this.label = 3;
                    user = UserActionProcessor.this.userActionProcessorRepository.getUser(this);
                    if (user == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    conversationKitResult = success;
                    obj = user;
                } else {
                    if (i != 3) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    conversationKitResult = (ConversationKitResult) this.L$0;
                    ResultKt.throwOnFailure(obj);
                }
                return new Effect.CreateConversationResult(conversationKitResult, (User) obj);
            }
            ResultKt.throwOnFailure(obj);
            UserActionProcessorRepository userActionProcessorRepository2 = UserActionProcessor.this.userActionProcessorRepository;
            proactiveMessageId = this.$action.getProactiveMessageId();
            this.L$0 = userActionProcessorRepository2;
            this.L$1 = proactiveMessageId;
            this.label = 1;
            Object metadata = UserActionProcessor.this.metadataManager.getMetadata(this);
            if (metadata == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessorRepository = userActionProcessorRepository2;
            obj = metadata;
            this.L$0 = null;
            this.L$1 = null;
            this.label = 2;
            obj = userActionProcessorRepository.createConversation(proactiveMessageId, (Map) obj, this);
            if (obj == coroutine_suspended) {
                return coroutine_suspended;
            }
            success = new ConversationKitResult.Success((Conversation) obj);
            this.L$0 = success;
            this.label = 3;
            user = UserActionProcessor.this.userActionProcessorRepository.getUser(this);
            if (user == coroutine_suspended) {
                return coroutine_suspended;
            }
            conversationKitResult = success;
            obj = user;
            return new Effect.CreateConversationResult(conversationKitResult, (User) obj);
        }
    }

    public final Object processCreateConversation(Action.CreateConversation createConversation, Continuation<? super Effect> continuation) throws Exception {
        C11111 c11111;
        UserActionProcessor userActionProcessor;
        ConversationKitResult.Failure failure;
        Object user;
        ConversationKitResult conversationKitResult;
        ConversationKitResult.Failure failure2;
        Object user2;
        ConversationKitResult conversationKitResult2;
        ConversationKitResult.Failure failure3;
        Object user3;
        ConversationKitResult conversationKitResult3;
        ConversationKitResult.Failure failure4;
        Object user4;
        ConversationKitResult conversationKitResult4;
        if (continuation instanceof C11111) {
            c11111 = (C11111) continuation;
            if ((c11111.label & Integer.MIN_VALUE) != 0) {
                c11111.label -= Integer.MIN_VALUE;
            } else {
                c11111 = new C11111(continuation);
            }
        } else {
            c11111 = new C11111(continuation);
        }
        Object objExecuteWithAuthErrorHandling$default = c11111.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11111.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
            try {
                AuthenticationErrorHandler authenticationErrorHandler = this.authenticationErrorHandler;
                C11122 c11122 = new C11122(createConversation, null);
                c11111.L$0 = this;
                c11111.label = 1;
                objExecuteWithAuthErrorHandling$default = AuthenticationErrorHandler.executeWithAuthErrorHandling$default(authenticationErrorHandler, null, c11122, c11111, 1, null);
                if (objExecuteWithAuthErrorHandling$default == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessor = this;
            } catch (SerializationException e) {
                e = e;
                userActionProcessor = this;
                SerializationException serializationException = e;
                Logger.m218e(LOG_TAG, "POST request to create conversation failed to decode malformed JSON response.", serializationException, new Object[0]);
                failure4 = new ConversationKitResult.Failure(serializationException);
                UserActionProcessorRepository userActionProcessorRepository = userActionProcessor.userActionProcessorRepository;
                c11111.L$0 = failure4;
                c11111.label = 4;
                user4 = userActionProcessorRepository.getUser(c11111);
                if (user4 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversationKitResult4 = failure4;
                objExecuteWithAuthErrorHandling$default = user4;
                return new Effect.CreateConversationResult(conversationKitResult4, (User) objExecuteWithAuthErrorHandling$default);
            } catch (CantCreateConversationException e2) {
                e = e2;
                userActionProcessor = this;
                CantCreateConversationException cantCreateConversationException = e;
                Logger.m218e(LOG_TAG, "User cannot create more conversations.", cantCreateConversationException, new Object[0]);
                failure3 = new ConversationKitResult.Failure(cantCreateConversationException);
                UserActionProcessorRepository userActionProcessorRepository2 = userActionProcessor.userActionProcessorRepository;
                c11111.L$0 = failure3;
                c11111.label = 3;
                user3 = userActionProcessorRepository2.getUser(c11111);
                if (user3 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversationKitResult3 = failure3;
                objExecuteWithAuthErrorHandling$default = user3;
                return new Effect.CreateConversationResult(conversationKitResult3, (User) objExecuteWithAuthErrorHandling$default);
            } catch (MultiConvoDisabledException e3) {
                e = e3;
                userActionProcessor = this;
                MultiConvoDisabledException multiConvoDisabledException = e;
                Logger.m218e(LOG_TAG, "Multi conversations is not enabled.", multiConvoDisabledException, new Object[0]);
                failure2 = new ConversationKitResult.Failure(multiConvoDisabledException);
                UserActionProcessorRepository userActionProcessorRepository3 = userActionProcessor.userActionProcessorRepository;
                c11111.L$0 = failure2;
                c11111.label = 2;
                user2 = userActionProcessorRepository3.getUser(c11111);
                if (user2 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversationKitResult2 = failure2;
                objExecuteWithAuthErrorHandling$default = user2;
                return new Effect.CreateConversationResult(conversationKitResult2, (User) objExecuteWithAuthErrorHandling$default);
            } catch (Exception e4) {
                e = e4;
                userActionProcessor = this;
                if (!(e instanceof CancellationException)) {
                    throw e;
                }
                Exception exc = e;
                Logger.m218e(LOG_TAG, "Failed to create conversation.", exc, new Object[0]);
                failure = new ConversationKitResult.Failure(exc);
                UserActionProcessorRepository userActionProcessorRepository4 = userActionProcessor.userActionProcessorRepository;
                c11111.L$0 = failure;
                c11111.label = 5;
                user = userActionProcessorRepository4.getUser(c11111);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversationKitResult = failure;
                objExecuteWithAuthErrorHandling$default = user;
                return new Effect.CreateConversationResult(conversationKitResult, (User) objExecuteWithAuthErrorHandling$default);
            }
        } else {
            if (i != 1) {
                if (i == 2) {
                    conversationKitResult2 = (ConversationKitResult) c11111.L$0;
                    ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
                    return new Effect.CreateConversationResult(conversationKitResult2, (User) objExecuteWithAuthErrorHandling$default);
                }
                if (i == 3) {
                    conversationKitResult3 = (ConversationKitResult) c11111.L$0;
                    ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
                    return new Effect.CreateConversationResult(conversationKitResult3, (User) objExecuteWithAuthErrorHandling$default);
                }
                if (i == 4) {
                    conversationKitResult4 = (ConversationKitResult) c11111.L$0;
                    ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
                    return new Effect.CreateConversationResult(conversationKitResult4, (User) objExecuteWithAuthErrorHandling$default);
                }
                if (i != 5) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                conversationKitResult = (ConversationKitResult) c11111.L$0;
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
                return new Effect.CreateConversationResult(conversationKitResult, (User) objExecuteWithAuthErrorHandling$default);
            }
            userActionProcessor = (UserActionProcessor) c11111.L$0;
            try {
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
            } catch (SerializationException e5) {
                e = e5;
                SerializationException serializationException2 = e;
                Logger.m218e(LOG_TAG, "POST request to create conversation failed to decode malformed JSON response.", serializationException2, new Object[0]);
                failure4 = new ConversationKitResult.Failure(serializationException2);
                UserActionProcessorRepository userActionProcessorRepository5 = userActionProcessor.userActionProcessorRepository;
                c11111.L$0 = failure4;
                c11111.label = 4;
                user4 = userActionProcessorRepository5.getUser(c11111);
                if (user4 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversationKitResult4 = failure4;
                objExecuteWithAuthErrorHandling$default = user4;
                return new Effect.CreateConversationResult(conversationKitResult4, (User) objExecuteWithAuthErrorHandling$default);
            } catch (CantCreateConversationException e6) {
                e = e6;
                CantCreateConversationException cantCreateConversationException2 = e;
                Logger.m218e(LOG_TAG, "User cannot create more conversations.", cantCreateConversationException2, new Object[0]);
                failure3 = new ConversationKitResult.Failure(cantCreateConversationException2);
                UserActionProcessorRepository userActionProcessorRepository6 = userActionProcessor.userActionProcessorRepository;
                c11111.L$0 = failure3;
                c11111.label = 3;
                user3 = userActionProcessorRepository6.getUser(c11111);
                if (user3 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversationKitResult3 = failure3;
                objExecuteWithAuthErrorHandling$default = user3;
                return new Effect.CreateConversationResult(conversationKitResult3, (User) objExecuteWithAuthErrorHandling$default);
            } catch (MultiConvoDisabledException e7) {
                e = e7;
                MultiConvoDisabledException multiConvoDisabledException2 = e;
                Logger.m218e(LOG_TAG, "Multi conversations is not enabled.", multiConvoDisabledException2, new Object[0]);
                failure2 = new ConversationKitResult.Failure(multiConvoDisabledException2);
                UserActionProcessorRepository userActionProcessorRepository7 = userActionProcessor.userActionProcessorRepository;
                c11111.L$0 = failure2;
                c11111.label = 2;
                user2 = userActionProcessorRepository7.getUser(c11111);
                if (user2 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversationKitResult2 = failure2;
                objExecuteWithAuthErrorHandling$default = user2;
                return new Effect.CreateConversationResult(conversationKitResult2, (User) objExecuteWithAuthErrorHandling$default);
            } catch (Exception e8) {
                e = e8;
                if (!(e instanceof CancellationException)) {
                    throw e;
                }
                Exception exc2 = e;
                Logger.m218e(LOG_TAG, "Failed to create conversation.", exc2, new Object[0]);
                failure = new ConversationKitResult.Failure(exc2);
                UserActionProcessorRepository userActionProcessorRepository8 = userActionProcessor.userActionProcessorRepository;
                c11111.L$0 = failure;
                c11111.label = 5;
                user = userActionProcessorRepository8.getUser(c11111);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversationKitResult = failure;
                objExecuteWithAuthErrorHandling$default = user;
                return new Effect.CreateConversationResult(conversationKitResult, (User) objExecuteWithAuthErrorHandling$default);
            }
        }
        return (Effect) objExecuteWithAuthErrorHandling$default;
    }

    public final Object processGetConversation(Action.GetConversation getConversation, Continuation<? super Effect> continuation) throws Exception {
        C11141 c11141;
        UserActionProcessor userActionProcessor;
        if (continuation instanceof C11141) {
            c11141 = (C11141) continuation;
            if ((c11141.label & Integer.MIN_VALUE) != 0) {
                c11141.label -= Integer.MIN_VALUE;
            } else {
                c11141 = new C11141(continuation);
            }
        } else {
            c11141 = new C11141(continuation);
        }
        C11141 c11142 = c11141;
        Object persistedConversation = c11142.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11142.label;
        try {
            if (i != 0) {
                if (i == 1) {
                    getConversation = (Action.GetConversation) c11142.L$1;
                    userActionProcessor = (UserActionProcessor) c11142.L$0;
                    ResultKt.throwOnFailure(persistedConversation);
                } else {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(persistedConversation);
                }
                return (Effect) persistedConversation;
            }
            ResultKt.throwOnFailure(persistedConversation);
            UserActionProcessorRepository userActionProcessorRepository = this.userActionProcessorRepository;
            String conversationId = getConversation.getConversationId();
            c11142.L$0 = this;
            c11142.L$1 = getConversation;
            c11142.label = 1;
            persistedConversation = userActionProcessorRepository.getPersistedConversation(conversationId, c11142);
            if (persistedConversation == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessor = this;
            Conversation conversation = (Conversation) persistedConversation;
            if (conversation != null) {
                return new Effect.GetConversationResult(new ConversationKitResult.Success(conversation), true);
            }
            AuthenticationErrorHandler authenticationErrorHandler = userActionProcessor.authenticationErrorHandler;
            C11152 c11152 = userActionProcessor.new C11152(getConversation, null);
            c11142.L$0 = null;
            c11142.L$1 = null;
            c11142.label = 2;
            persistedConversation = AuthenticationErrorHandler.executeWithAuthErrorHandling$default(authenticationErrorHandler, null, c11152, c11142, 1, null);
            if (persistedConversation == coroutine_suspended) {
                return coroutine_suspended;
            }
            return (Effect) persistedConversation;
        } catch (SerializationException e) {
            SerializationException serializationException = e;
            Logger.m218e(LOG_TAG, GET_CONVERSATION_SERIALIZATION_EXCEPTION_LOG_MESSAGE, serializationException, new Object[0]);
            return new Effect.GetConversationResult(new ConversationKitResult.Failure(serializationException), false);
        } catch (Exception e2) {
            if (e2 instanceof CancellationException) {
                throw e2;
            }
            Exception exc = e2;
            Logger.m218e(LOG_TAG, "Failed to create conversation.", exc, new Object[0]);
            return new Effect.GetConversationResult(new ConversationKitResult.Failure(exc), false);
        }
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/conversationkit/android/internal/Effect;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor$processGetConversation$2", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {364}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C11152 extends SuspendLambda implements Function1<Continuation<? super Effect>, Object> {
        final Action.GetConversation $action;
        int label;

        C11152(Action.GetConversation getConversation, Continuation<? super C11152> continuation) {
            super(1, continuation);
            this.$action = getConversation;
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return UserActionProcessor.this.new C11152(this.$action, continuation);
        }

        @Override
        public final Object invoke(Continuation<? super Effect> continuation) {
            return ((C11152) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                obj = UserActionProcessor.this.userActionProcessorRepository.getConversationRemotely(this.$action.getConversationId(), this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return new Effect.GetConversationResult(new ConversationKitResult.Success(obj), false);
        }
    }

    public final Object processProactiveMessageReferral(Action.ProactiveMessageReferral proactiveMessageReferral, Continuation<? super Effect> continuation) throws Exception {
        C11301 c11301;
        if (continuation instanceof C11301) {
            c11301 = (C11301) continuation;
            if ((c11301.label & Integer.MIN_VALUE) != 0) {
                c11301.label -= Integer.MIN_VALUE;
            } else {
                c11301 = new C11301(continuation);
            }
        } else {
            c11301 = new C11301(continuation);
        }
        C11301 c11302 = c11301;
        Object objExecuteWithAuthErrorHandling$default = c11302.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11302.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
                AuthenticationErrorHandler authenticationErrorHandler = this.authenticationErrorHandler;
                C11312 c11312 = new C11312(proactiveMessageReferral, null);
                c11302.label = 1;
                objExecuteWithAuthErrorHandling$default = AuthenticationErrorHandler.executeWithAuthErrorHandling$default(authenticationErrorHandler, null, c11312, c11302, 1, null);
                if (objExecuteWithAuthErrorHandling$default == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
            }
            return (Effect) objExecuteWithAuthErrorHandling$default;
        } catch (SerializationException e) {
            SerializationException serializationException = e;
            Logger.m218e(LOG_TAG, "POST request for proactive message referral failed to decode malformed JSON response.", serializationException, new Object[0]);
            return new Effect.ProactiveMessageReferral(new ConversationKitResult.Failure(serializationException), false);
        } catch (Exception e2) {
            if (e2 instanceof CancellationException) {
                throw e2;
            }
            Exception exc = e2;
            Logger.m218e(LOG_TAG, "Failed to process proactive message referral.", exc, new Object[0]);
            return new Effect.ProactiveMessageReferral(new ConversationKitResult.Failure(exc), false);
        }
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/conversationkit/android/internal/Effect;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor$processProactiveMessageReferral$2", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {390}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C11312 extends SuspendLambda implements Function1<Continuation<? super Effect>, Object> {
        final Action.ProactiveMessageReferral $action;
        int label;

        C11312(Action.ProactiveMessageReferral proactiveMessageReferral, Continuation<? super C11312> continuation) {
            super(1, continuation);
            this.$action = proactiveMessageReferral;
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return UserActionProcessor.this.new C11312(this.$action, continuation);
        }

        @Override
        public final Object invoke(Continuation<? super Effect> continuation) {
            return ((C11312) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                obj = UserActionProcessor.this.userActionProcessorRepository.getProactiveMessageConversation(this.$action.getProactiveMessageId(), this.$action.getConversationId(), this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return new Effect.ProactiveMessageReferral(new ConversationKitResult.Success((Conversation) obj), false);
        }
    }

    public final Object processRefreshConversation(Action.RefreshConversation refreshConversation, Continuation<? super Effect> continuation) throws Exception {
        C11321 c11321;
        if (continuation instanceof C11321) {
            c11321 = (C11321) continuation;
            if ((c11321.label & Integer.MIN_VALUE) != 0) {
                c11321.label -= Integer.MIN_VALUE;
            } else {
                c11321 = new C11321(continuation);
            }
        } else {
            c11321 = new C11321(continuation);
        }
        C11321 c11322 = c11321;
        Object objExecuteWithAuthErrorHandling$default = c11322.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11322.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
                AuthenticationErrorHandler authenticationErrorHandler = this.authenticationErrorHandler;
                C11332 c11332 = new C11332(refreshConversation, null);
                c11322.label = 1;
                objExecuteWithAuthErrorHandling$default = AuthenticationErrorHandler.executeWithAuthErrorHandling$default(authenticationErrorHandler, null, c11332, c11322, 1, null);
                if (objExecuteWithAuthErrorHandling$default == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
            }
            return (Effect) objExecuteWithAuthErrorHandling$default;
        } catch (SerializationException e) {
            SerializationException serializationException = e;
            Logger.m218e(LOG_TAG, GET_CONVERSATION_SERIALIZATION_EXCEPTION_LOG_MESSAGE, serializationException, new Object[0]);
            return new Effect.RefreshConversationResult(new ConversationKitResult.Failure(serializationException));
        } catch (Exception e2) {
            if (e2 instanceof CancellationException) {
                throw e2;
            }
            Exception exc = e2;
            Logger.m218e(LOG_TAG, "Failed to refresh conversation.", exc, new Object[0]);
            return new Effect.RefreshConversationResult(new ConversationKitResult.Failure(exc));
        }
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/conversationkit/android/internal/Effect;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor$processRefreshConversation$2", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {430}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C11332 extends SuspendLambda implements Function1<Continuation<? super Effect>, Object> {
        final Action.RefreshConversation $action;
        int label;

        C11332(Action.RefreshConversation refreshConversation, Continuation<? super C11332> continuation) {
            super(1, continuation);
            this.$action = refreshConversation;
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return UserActionProcessor.this.new C11332(this.$action, continuation);
        }

        @Override
        public final Object invoke(Continuation<? super Effect> continuation) {
            return ((C11332) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                obj = UserActionProcessor.this.userActionProcessorRepository.refreshConversation(this.$action.getConversationId(), this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return new Effect.RefreshConversationResult(new ConversationKitResult.Success((Conversation) obj));
        }
    }

    public final Object processMessageReceived(Action.MessageReceived messageReceived, Continuation<? super Effect> continuation) throws Throwable {
        C11281 c11281;
        if (continuation instanceof C11281) {
            c11281 = (C11281) continuation;
            if ((c11281.label & Integer.MIN_VALUE) != 0) {
                c11281.label -= Integer.MIN_VALUE;
            } else {
                c11281 = new C11281(continuation);
            }
        } else {
            c11281 = new C11281(continuation);
        }
        Object objUpdateConversation = c11281.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11281.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(objUpdateConversation);
                UserActionProcessorRepository userActionProcessorRepository = this.userActionProcessorRepository;
                String conversationId = messageReceived.getConversationId();
                zendesk.conversationkit.android.model.Message message = messageReceived.getMessage();
                c11281.L$0 = messageReceived;
                c11281.label = 1;
                objUpdateConversation = userActionProcessorRepository.updateConversation(conversationId, message, c11281);
                if (objUpdateConversation == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                messageReceived = (Action.MessageReceived) c11281.L$0;
                ResultKt.throwOnFailure(objUpdateConversation);
            }
            Conversation conversation = (Conversation) objUpdateConversation;
            return new Effect.MessageReceived(MessageKt.enrichFormResponseFields(messageReceived.getMessage(), conversation), messageReceived.getConversationId(), conversation);
        } catch (ConversationNotFoundException e) {
            Logger.m218e(LOG_TAG, e.getMessage(), e, new Object[0]);
            return Effect.None.INSTANCE;
        } catch (MessageAlreadyInConversationException e2) {
            Logger.m218e(LOG_TAG, e2.getMessage(), e2, new Object[0]);
            return Effect.None.INSTANCE;
        }
    }

    public final Object processLoadMoreMessages(Action.LoadMoreMessages loadMoreMessages, Continuation<? super Effect> continuation) throws Exception {
        C11221 c11221;
        UserActionProcessor userActionProcessor;
        String conversationId;
        Object persistedConversation;
        String str;
        Exception exc;
        String conversationId2;
        Object persistedConversation2;
        String str2;
        SerializationException serializationException;
        Action.LoadMoreMessages loadMoreMessages2 = loadMoreMessages;
        if (continuation instanceof C11221) {
            c11221 = (C11221) continuation;
            if ((c11221.label & Integer.MIN_VALUE) != 0) {
                c11221.label -= Integer.MIN_VALUE;
            } else {
                c11221 = new C11221(continuation);
            }
        } else {
            c11221 = new C11221(continuation);
        }
        Object objExecuteWithAuthErrorHandling$default = c11221.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11221.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
                try {
                    AuthenticationErrorHandler authenticationErrorHandler = this.authenticationErrorHandler;
                    C11232 c11232 = new C11232(loadMoreMessages2, null);
                    c11221.L$0 = this;
                    c11221.L$1 = loadMoreMessages2;
                    c11221.label = 1;
                    objExecuteWithAuthErrorHandling$default = AuthenticationErrorHandler.executeWithAuthErrorHandling$default(authenticationErrorHandler, null, c11232, c11221, 1, null);
                    if (objExecuteWithAuthErrorHandling$default == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    userActionProcessor = this;
                } catch (SerializationException e) {
                    e = e;
                    userActionProcessor = this;
                    Logger.m218e(LOG_TAG, "GET request for Messages failed to decode malformed JSON response.", e, new Object[0]);
                    conversationId2 = loadMoreMessages2.getConversationId();
                    UserActionProcessorRepository userActionProcessorRepository = userActionProcessor.userActionProcessorRepository;
                    String conversationId3 = loadMoreMessages2.getConversationId();
                    c11221.L$0 = e;
                    c11221.L$1 = conversationId2;
                    c11221.label = 2;
                    persistedConversation2 = userActionProcessorRepository.getPersistedConversation(conversationId3, c11221);
                    if (persistedConversation2 == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    str2 = conversationId2;
                    serializationException = e;
                    objExecuteWithAuthErrorHandling$default = persistedConversation2;
                    return new Effect.LoadMoreMessages(str2, (Conversation) objExecuteWithAuthErrorHandling$default, BEFORE_TIMESTAMP, new ConversationKitResult.Failure(serializationException));
                } catch (Exception e2) {
                    e = e2;
                    userActionProcessor = this;
                    if (!(e instanceof CancellationException)) {
                        throw e;
                    }
                    Logger.m218e(LOG_TAG, "Failed to get messages.", e, new Object[0]);
                    conversationId = loadMoreMessages2.getConversationId();
                    UserActionProcessorRepository userActionProcessorRepository2 = userActionProcessor.userActionProcessorRepository;
                    String conversationId4 = loadMoreMessages2.getConversationId();
                    c11221.L$0 = e;
                    c11221.L$1 = conversationId;
                    c11221.label = 3;
                    persistedConversation = userActionProcessorRepository2.getPersistedConversation(conversationId4, c11221);
                    if (persistedConversation == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    str = conversationId;
                    exc = e;
                    objExecuteWithAuthErrorHandling$default = persistedConversation;
                    return new Effect.LoadMoreMessages(str, (Conversation) objExecuteWithAuthErrorHandling$default, BEFORE_TIMESTAMP, new ConversationKitResult.Failure(exc));
                }
            } else {
                if (i != 1) {
                    if (i == 2) {
                        String str3 = (String) c11221.L$1;
                        SerializationException serializationException2 = (SerializationException) c11221.L$0;
                        ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
                        str2 = str3;
                        serializationException = serializationException2;
                        return new Effect.LoadMoreMessages(str2, (Conversation) objExecuteWithAuthErrorHandling$default, BEFORE_TIMESTAMP, new ConversationKitResult.Failure(serializationException));
                    }
                    if (i != 3) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    String str4 = (String) c11221.L$1;
                    Exception exc2 = (Exception) c11221.L$0;
                    ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
                    str = str4;
                    exc = exc2;
                    return new Effect.LoadMoreMessages(str, (Conversation) objExecuteWithAuthErrorHandling$default, BEFORE_TIMESTAMP, new ConversationKitResult.Failure(exc));
                }
                loadMoreMessages2 = (Action.LoadMoreMessages) c11221.L$1;
                userActionProcessor = (UserActionProcessor) c11221.L$0;
                try {
                    ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
                } catch (SerializationException e3) {
                    e = e3;
                    Logger.m218e(LOG_TAG, "GET request for Messages failed to decode malformed JSON response.", e, new Object[0]);
                    conversationId2 = loadMoreMessages2.getConversationId();
                    UserActionProcessorRepository userActionProcessorRepository3 = userActionProcessor.userActionProcessorRepository;
                    String conversationId5 = loadMoreMessages2.getConversationId();
                    c11221.L$0 = e;
                    c11221.L$1 = conversationId2;
                    c11221.label = 2;
                    persistedConversation2 = userActionProcessorRepository3.getPersistedConversation(conversationId5, c11221);
                    if (persistedConversation2 == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    str2 = conversationId2;
                    serializationException = e;
                    objExecuteWithAuthErrorHandling$default = persistedConversation2;
                    return new Effect.LoadMoreMessages(str2, (Conversation) objExecuteWithAuthErrorHandling$default, BEFORE_TIMESTAMP, new ConversationKitResult.Failure(serializationException));
                } catch (Exception e4) {
                    e = e4;
                    if (!(e instanceof CancellationException)) {
                        throw e;
                    }
                    Logger.m218e(LOG_TAG, "Failed to get messages.", e, new Object[0]);
                    conversationId = loadMoreMessages2.getConversationId();
                    UserActionProcessorRepository userActionProcessorRepository4 = userActionProcessor.userActionProcessorRepository;
                    String conversationId6 = loadMoreMessages2.getConversationId();
                    c11221.L$0 = e;
                    c11221.L$1 = conversationId;
                    c11221.label = 3;
                    persistedConversation = userActionProcessorRepository4.getPersistedConversation(conversationId6, c11221);
                    if (persistedConversation == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    str = conversationId;
                    exc = e;
                    objExecuteWithAuthErrorHandling$default = persistedConversation;
                    return new Effect.LoadMoreMessages(str, (Conversation) objExecuteWithAuthErrorHandling$default, BEFORE_TIMESTAMP, new ConversationKitResult.Failure(exc));
                }
            }
            return (Effect) objExecuteWithAuthErrorHandling$default;
        } catch (ConversationHasNoPreviousMessagesException e5) {
            Logger.m218e(LOG_TAG, e5.getMessage(), e5, new Object[0]);
            return Effect.None.INSTANCE;
        } catch (ConversationNotFoundException e6) {
            Logger.m218e(LOG_TAG, e6.getMessage(), e6, new Object[0]);
            return Effect.None.INSTANCE;
        } catch (MessageAlreadyInConversationException e7) {
            Logger.m218e(LOG_TAG, e7.getMessage(), e7, new Object[0]);
            return Effect.None.INSTANCE;
        }
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/conversationkit/android/internal/Effect;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor$processLoadMoreMessages$2", m37f = "UserActionProcessor.kt", m38i = {1}, m39l = {479, 485}, m40m = "invokeSuspend", m41n = {"listOfLoadedMessages"}, m42s = {"L$0"})
    static final class C11232 extends SuspendLambda implements Function1<Continuation<? super Effect>, Object> {
        final Action.LoadMoreMessages $action;
        Object L$0;
        Object L$1;
        int label;

        C11232(Action.LoadMoreMessages loadMoreMessages, Continuation<? super C11232> continuation) {
            super(1, continuation);
            this.$action = loadMoreMessages;
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return UserActionProcessor.this.new C11232(this.$action, continuation);
        }

        @Override
        public final Object invoke(Continuation<? super Effect> continuation) {
            return ((C11232) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            MessageList messageList;
            String str;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                obj = UserActionProcessor.this.userActionProcessorRepository.loadMoreMessages(this.$action.getConversationId(), this.$action.getBeforeTimestamp(), this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i == 1) {
                    ResultKt.throwOnFailure(obj);
                } else {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    String str2 = (String) this.L$1;
                    MessageList messageList2 = (MessageList) this.L$0;
                    ResultKt.throwOnFailure(obj);
                    str = str2;
                    messageList = messageList2;
                }
                return new Effect.LoadMoreMessages(str, (Conversation) obj, ((zendesk.conversationkit.android.model.Message) CollectionsKt.first((List) messageList.getMessages())).getBeforeTimestamp(), new ConversationKitResult.Success(messageList.getMessages()));
            }
            MessageList messageList3 = (MessageList) obj;
            String conversationId = this.$action.getConversationId();
            this.L$0 = messageList3;
            this.L$1 = conversationId;
            this.label = 2;
            Object persistedConversation = UserActionProcessor.this.userActionProcessorRepository.getPersistedConversation(this.$action.getConversationId(), this);
            if (persistedConversation == coroutine_suspended) {
                return coroutine_suspended;
            }
            messageList = messageList3;
            str = conversationId;
            obj = persistedConversation;
            return new Effect.LoadMoreMessages(str, (Conversation) obj, ((zendesk.conversationkit.android.model.Message) CollectionsKt.first((List) messageList.getMessages())).getBeforeTimestamp(), new ConversationKitResult.Success(messageList.getMessages()));
        }
    }

    public final Object processPrepareMessage(Action.PrepareMessage prepareMessage, Continuation<? super Effect> continuation) throws Throwable {
        C11291 c11291;
        Action.PrepareMessage prepareMessage2;
        UserActionProcessor userActionProcessor;
        zendesk.conversationkit.android.model.Message message;
        Action.PrepareMessage prepareMessage3;
        Conversation conversation;
        String conversationId;
        Map<String, ? extends Object> metadata;
        Object objShouldUpdateMetadata;
        Conversation conversation2;
        boolean zBooleanValue;
        Object metadata2;
        boolean z;
        zendesk.conversationkit.android.model.Message message2;
        Conversation conversation3;
        String str;
        if (continuation instanceof C11291) {
            c11291 = (C11291) continuation;
            if ((c11291.label & Integer.MIN_VALUE) != 0) {
                c11291.label -= Integer.MIN_VALUE;
            } else {
                c11291 = new C11291(continuation);
            }
        } else {
            c11291 = new C11291(continuation);
        }
        Object objCreatePendingMessage = c11291.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11291.label;
        try {
            if (i != 0) {
                if (i == 1) {
                    Action.PrepareMessage prepareMessage4 = (Action.PrepareMessage) c11291.L$1;
                    userActionProcessor = (UserActionProcessor) c11291.L$0;
                    ResultKt.throwOnFailure(objCreatePendingMessage);
                    prepareMessage2 = prepareMessage4;
                } else if (i == 2) {
                    message = (zendesk.conversationkit.android.model.Message) c11291.L$2;
                    prepareMessage3 = (Action.PrepareMessage) c11291.L$1;
                    userActionProcessor = (UserActionProcessor) c11291.L$0;
                    ResultKt.throwOnFailure(objCreatePendingMessage);
                    conversation = (Conversation) objCreatePendingMessage;
                    conversationId = prepareMessage3.getConversationId();
                    MetadataManager metadataManager = userActionProcessor.metadataManager;
                    if (conversation != null) {
                        metadata = conversation.getMetadata();
                    } else {
                        metadata = null;
                    }
                    c11291.L$0 = userActionProcessor;
                    c11291.L$1 = message;
                    c11291.L$2 = conversationId;
                    c11291.L$3 = conversation;
                    c11291.label = 3;
                    objShouldUpdateMetadata = metadataManager.shouldUpdateMetadata(metadata, c11291);
                    if (objShouldUpdateMetadata == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    conversation2 = conversation;
                    objCreatePendingMessage = objShouldUpdateMetadata;
                    zBooleanValue = ((Boolean) objCreatePendingMessage).booleanValue();
                    MetadataManager metadataManager2 = userActionProcessor.metadataManager;
                    c11291.L$0 = message;
                    c11291.L$1 = conversationId;
                    c11291.L$2 = conversation2;
                    c11291.L$3 = null;
                    c11291.Z$0 = zBooleanValue;
                    c11291.label = 4;
                    metadata2 = metadataManager2.getMetadata(c11291);
                    if (metadata2 == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    z = zBooleanValue;
                    objCreatePendingMessage = metadata2;
                    message2 = message;
                    conversation3 = conversation2;
                    str = conversationId;
                } else if (i == 3) {
                    Conversation conversation4 = (Conversation) c11291.L$3;
                    String str2 = (String) c11291.L$2;
                    zendesk.conversationkit.android.model.Message message3 = (zendesk.conversationkit.android.model.Message) c11291.L$1;
                    userActionProcessor = (UserActionProcessor) c11291.L$0;
                    ResultKt.throwOnFailure(objCreatePendingMessage);
                    conversation2 = conversation4;
                    message = message3;
                    conversationId = str2;
                    zBooleanValue = ((Boolean) objCreatePendingMessage).booleanValue();
                    MetadataManager metadataManager3 = userActionProcessor.metadataManager;
                    c11291.L$0 = message;
                    c11291.L$1 = conversationId;
                    c11291.L$2 = conversation2;
                    c11291.L$3 = null;
                    c11291.Z$0 = zBooleanValue;
                    c11291.label = 4;
                    metadata2 = metadataManager3.getMetadata(c11291);
                    if (metadata2 == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    z = zBooleanValue;
                    objCreatePendingMessage = metadata2;
                    message2 = message;
                    conversation3 = conversation2;
                    str = conversationId;
                } else {
                    if (i != 4) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    boolean z2 = c11291.Z$0;
                    Conversation conversation5 = (Conversation) c11291.L$2;
                    String str3 = (String) c11291.L$1;
                    zendesk.conversationkit.android.model.Message message4 = (zendesk.conversationkit.android.model.Message) c11291.L$0;
                    ResultKt.throwOnFailure(objCreatePendingMessage);
                    z = z2;
                    message2 = message4;
                    conversation3 = conversation5;
                    str = str3;
                }
                return new Effect.MessagePrepared(message2, str, conversation3, z, (Map) objCreatePendingMessage);
            }
            ResultKt.throwOnFailure(objCreatePendingMessage);
            UserActionProcessorRepository userActionProcessorRepository = this.userActionProcessorRepository;
            String conversationId2 = prepareMessage.getConversationId();
            zendesk.conversationkit.android.model.Message message5 = prepareMessage.getMessage();
            c11291.L$0 = this;
            prepareMessage2 = prepareMessage;
            c11291.L$1 = prepareMessage2;
            c11291.label = 1;
            objCreatePendingMessage = userActionProcessorRepository.createPendingMessage(conversationId2, message5, c11291);
            if (objCreatePendingMessage == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessor = this;
            message = (zendesk.conversationkit.android.model.Message) objCreatePendingMessage;
            UserActionProcessorRepository userActionProcessorRepository2 = userActionProcessor.userActionProcessorRepository;
            String conversationId3 = prepareMessage2.getConversationId();
            c11291.L$0 = userActionProcessor;
            c11291.L$1 = prepareMessage2;
            c11291.L$2 = message;
            c11291.label = 2;
            objCreatePendingMessage = userActionProcessorRepository2.getPersistedConversation(conversationId3, c11291);
            if (objCreatePendingMessage == coroutine_suspended) {
                return coroutine_suspended;
            }
            prepareMessage3 = prepareMessage2;
            conversation = (Conversation) objCreatePendingMessage;
            conversationId = prepareMessage3.getConversationId();
            MetadataManager metadataManager4 = userActionProcessor.metadataManager;
            if (conversation != null) {
                metadata = conversation.getMetadata();
            } else {
                metadata = null;
            }
            c11291.L$0 = userActionProcessor;
            c11291.L$1 = message;
            c11291.L$2 = conversationId;
            c11291.L$3 = conversation;
            c11291.label = 3;
            objShouldUpdateMetadata = metadataManager4.shouldUpdateMetadata(metadata, c11291);
            if (objShouldUpdateMetadata == coroutine_suspended) {
                return coroutine_suspended;
            }
            conversation2 = conversation;
            objCreatePendingMessage = objShouldUpdateMetadata;
            zBooleanValue = ((Boolean) objCreatePendingMessage).booleanValue();
            MetadataManager metadataManager5 = userActionProcessor.metadataManager;
            c11291.L$0 = message;
            c11291.L$1 = conversationId;
            c11291.L$2 = conversation2;
            c11291.L$3 = null;
            c11291.Z$0 = zBooleanValue;
            c11291.label = 4;
            metadata2 = metadataManager5.getMetadata(c11291);
            if (metadata2 == coroutine_suspended) {
                return coroutine_suspended;
            }
            z = zBooleanValue;
            objCreatePendingMessage = metadata2;
            message2 = message;
            conversation3 = conversation2;
            str = conversationId;
            return new Effect.MessagePrepared(message2, str, conversation3, z, (Map) objCreatePendingMessage);
        } catch (ConversationNotFoundException e) {
            Logger.m218e(LOG_TAG, "Unable to find conversation.", e, new Object[0]);
            return Effect.None.INSTANCE;
        } catch (MessageAlreadyInConversationException e2) {
            Logger.m218e(LOG_TAG, "Message already in conversation.", e2, new Object[0]);
            return Effect.None.INSTANCE;
        } catch (MessageContentIsBlankException e3) {
            Logger.m218e(LOG_TAG, "Message content is blank.", e3, new Object[0]);
            return Effect.None.INSTANCE;
        }
    }

    public final Object processSendMessage(Action.SendMessage sendMessage, Continuation<? super Effect> continuation) throws Exception {
        C11361 c11361;
        UserActionProcessor userActionProcessor;
        ConversationKitResult.Failure failure;
        String conversationId;
        zendesk.conversationkit.android.model.Message messageCopy;
        Object persistedConversation;
        ConversationKitResult conversationKitResult;
        String str;
        zendesk.conversationkit.android.model.Message message;
        ConversationKitResult.Failure failure2;
        String conversationId2;
        zendesk.conversationkit.android.model.Message messageCopy2;
        Object persistedConversation2;
        ConversationKitResult conversationKitResult2;
        String str2;
        zendesk.conversationkit.android.model.Message message2;
        Action.SendMessage sendMessage2 = sendMessage;
        if (continuation instanceof C11361) {
            c11361 = (C11361) continuation;
            if ((c11361.label & Integer.MIN_VALUE) != 0) {
                c11361.label -= Integer.MIN_VALUE;
            } else {
                c11361 = new C11361(continuation);
            }
        } else {
            c11361 = new C11361(continuation);
        }
        Object objExecuteWithAuthErrorHandling$default = c11361.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11361.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
                try {
                    AuthenticationErrorHandler authenticationErrorHandler = this.authenticationErrorHandler;
                    C11372 c11372 = new C11372(sendMessage2, null);
                    c11361.L$0 = this;
                    c11361.L$1 = sendMessage2;
                    c11361.label = 1;
                    objExecuteWithAuthErrorHandling$default = AuthenticationErrorHandler.executeWithAuthErrorHandling$default(authenticationErrorHandler, null, c11372, c11361, 1, null);
                    if (objExecuteWithAuthErrorHandling$default == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    userActionProcessor = this;
                } catch (SerializationException e) {
                    e = e;
                    userActionProcessor = this;
                    SerializationException serializationException = e;
                    Logger.m218e(LOG_TAG, "POST request for Sending Message failed to decode malformed JSON response.", serializationException, new Object[0]);
                    failure2 = new ConversationKitResult.Failure(serializationException);
                    conversationId2 = sendMessage2.getConversationId();
                    zendesk.conversationkit.android.model.Message message3 = sendMessage2.getMessage();
                    messageCopy2 = message3.copy((2021 & 1) != 0 ? message3.id : null, (2021 & 2) != 0 ? message3.author : null, (2021 & 4) != 0 ? message3.status : MessageStatus.INSTANCE.failed(serializationException), (2021 & 8) != 0 ? message3.created : null, (2021 & 16) != 0 ? message3.received : null, (2021 & 32) != 0 ? message3.beforeTimestamp : BEFORE_TIMESTAMP, (2021 & 64) != 0 ? message3.content : null, (2021 & 128) != 0 ? message3.metadata : null, (2021 & 256) != 0 ? message3.sourceId : null, (2021 & 512) != 0 ? message3.localId : null, (2021 & 1024) != 0 ? message3.payload : null);
                    UserActionProcessorRepository userActionProcessorRepository = userActionProcessor.userActionProcessorRepository;
                    String conversationId3 = sendMessage2.getConversationId();
                    c11361.L$0 = failure2;
                    c11361.L$1 = conversationId2;
                    c11361.L$2 = messageCopy2;
                    c11361.label = 2;
                    persistedConversation2 = userActionProcessorRepository.getPersistedConversation(conversationId3, c11361);
                    if (persistedConversation2 == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    conversationKitResult2 = failure2;
                    str2 = conversationId2;
                    message2 = messageCopy2;
                    objExecuteWithAuthErrorHandling$default = persistedConversation2;
                    return new Effect.SendMessageResult(conversationKitResult2, str2, message2, (Conversation) objExecuteWithAuthErrorHandling$default);
                } catch (Exception e2) {
                    e = e2;
                    userActionProcessor = this;
                    if (!(e instanceof CancellationException)) {
                        throw e;
                    }
                    Exception exc = e;
                    Logger.m218e(LOG_TAG, "Failed to send message.", exc, new Object[0]);
                    failure = new ConversationKitResult.Failure(exc);
                    conversationId = sendMessage2.getConversationId();
                    zendesk.conversationkit.android.model.Message message4 = sendMessage2.getMessage();
                    messageCopy = message4.copy((2021 & 1) != 0 ? message4.id : null, (2021 & 2) != 0 ? message4.author : null, (2021 & 4) != 0 ? message4.status : MessageStatus.INSTANCE.failed(exc), (2021 & 8) != 0 ? message4.created : null, (2021 & 16) != 0 ? message4.received : null, (2021 & 32) != 0 ? message4.beforeTimestamp : BEFORE_TIMESTAMP, (2021 & 64) != 0 ? message4.content : null, (2021 & 128) != 0 ? message4.metadata : null, (2021 & 256) != 0 ? message4.sourceId : null, (2021 & 512) != 0 ? message4.localId : null, (2021 & 1024) != 0 ? message4.payload : null);
                    UserActionProcessorRepository userActionProcessorRepository2 = userActionProcessor.userActionProcessorRepository;
                    String conversationId4 = sendMessage2.getConversationId();
                    c11361.L$0 = failure;
                    c11361.L$1 = conversationId;
                    c11361.L$2 = messageCopy;
                    c11361.label = 3;
                    persistedConversation = userActionProcessorRepository2.getPersistedConversation(conversationId4, c11361);
                    if (persistedConversation == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    conversationKitResult = failure;
                    str = conversationId;
                    message = messageCopy;
                    objExecuteWithAuthErrorHandling$default = persistedConversation;
                    return new Effect.SendMessageResult(conversationKitResult, str, message, (Conversation) objExecuteWithAuthErrorHandling$default);
                }
            } else {
                if (i != 1) {
                    if (i == 2) {
                        message2 = (zendesk.conversationkit.android.model.Message) c11361.L$2;
                        str2 = (String) c11361.L$1;
                        conversationKitResult2 = (ConversationKitResult) c11361.L$0;
                        ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
                        return new Effect.SendMessageResult(conversationKitResult2, str2, message2, (Conversation) objExecuteWithAuthErrorHandling$default);
                    }
                    if (i != 3) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    message = (zendesk.conversationkit.android.model.Message) c11361.L$2;
                    str = (String) c11361.L$1;
                    conversationKitResult = (ConversationKitResult) c11361.L$0;
                    ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
                    return new Effect.SendMessageResult(conversationKitResult, str, message, (Conversation) objExecuteWithAuthErrorHandling$default);
                }
                sendMessage2 = (Action.SendMessage) c11361.L$1;
                userActionProcessor = (UserActionProcessor) c11361.L$0;
                try {
                    ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
                } catch (SerializationException e3) {
                    e = e3;
                    SerializationException serializationException2 = e;
                    Logger.m218e(LOG_TAG, "POST request for Sending Message failed to decode malformed JSON response.", serializationException2, new Object[0]);
                    failure2 = new ConversationKitResult.Failure(serializationException2);
                    conversationId2 = sendMessage2.getConversationId();
                    zendesk.conversationkit.android.model.Message message5 = sendMessage2.getMessage();
                    messageCopy2 = message5.copy((2021 & 1) != 0 ? message5.id : null, (2021 & 2) != 0 ? message5.author : null, (2021 & 4) != 0 ? message5.status : MessageStatus.INSTANCE.failed(serializationException2), (2021 & 8) != 0 ? message5.created : null, (2021 & 16) != 0 ? message5.received : null, (2021 & 32) != 0 ? message5.beforeTimestamp : BEFORE_TIMESTAMP, (2021 & 64) != 0 ? message5.content : null, (2021 & 128) != 0 ? message5.metadata : null, (2021 & 256) != 0 ? message5.sourceId : null, (2021 & 512) != 0 ? message5.localId : null, (2021 & 1024) != 0 ? message5.payload : null);
                    UserActionProcessorRepository userActionProcessorRepository3 = userActionProcessor.userActionProcessorRepository;
                    String conversationId5 = sendMessage2.getConversationId();
                    c11361.L$0 = failure2;
                    c11361.L$1 = conversationId2;
                    c11361.L$2 = messageCopy2;
                    c11361.label = 2;
                    persistedConversation2 = userActionProcessorRepository3.getPersistedConversation(conversationId5, c11361);
                    if (persistedConversation2 == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    conversationKitResult2 = failure2;
                    str2 = conversationId2;
                    message2 = messageCopy2;
                    objExecuteWithAuthErrorHandling$default = persistedConversation2;
                    return new Effect.SendMessageResult(conversationKitResult2, str2, message2, (Conversation) objExecuteWithAuthErrorHandling$default);
                } catch (Exception e4) {
                    e = e4;
                    if (!(e instanceof CancellationException)) {
                        throw e;
                    }
                    Exception exc2 = e;
                    Logger.m218e(LOG_TAG, "Failed to send message.", exc2, new Object[0]);
                    failure = new ConversationKitResult.Failure(exc2);
                    conversationId = sendMessage2.getConversationId();
                    zendesk.conversationkit.android.model.Message message6 = sendMessage2.getMessage();
                    messageCopy = message6.copy((2021 & 1) != 0 ? message6.id : null, (2021 & 2) != 0 ? message6.author : null, (2021 & 4) != 0 ? message6.status : MessageStatus.INSTANCE.failed(exc2), (2021 & 8) != 0 ? message6.created : null, (2021 & 16) != 0 ? message6.received : null, (2021 & 32) != 0 ? message6.beforeTimestamp : BEFORE_TIMESTAMP, (2021 & 64) != 0 ? message6.content : null, (2021 & 128) != 0 ? message6.metadata : null, (2021 & 256) != 0 ? message6.sourceId : null, (2021 & 512) != 0 ? message6.localId : null, (2021 & 1024) != 0 ? message6.payload : null);
                    UserActionProcessorRepository userActionProcessorRepository4 = userActionProcessor.userActionProcessorRepository;
                    String conversationId6 = sendMessage2.getConversationId();
                    c11361.L$0 = failure;
                    c11361.L$1 = conversationId;
                    c11361.L$2 = messageCopy;
                    c11361.label = 3;
                    persistedConversation = userActionProcessorRepository4.getPersistedConversation(conversationId6, c11361);
                    if (persistedConversation == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    conversationKitResult = failure;
                    str = conversationId;
                    message = messageCopy;
                    objExecuteWithAuthErrorHandling$default = persistedConversation;
                    return new Effect.SendMessageResult(conversationKitResult, str, message, (Conversation) objExecuteWithAuthErrorHandling$default);
                }
            }
            return (Effect) objExecuteWithAuthErrorHandling$default;
        } catch (MessageAlreadyInConversationException e5) {
            Logger.m218e(LOG_TAG, "Message already in conversation.", e5, new Object[0]);
            return Effect.None.INSTANCE;
        }
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/conversationkit/android/internal/Effect;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor$processSendMessage$2", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {576, 584}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C11372 extends SuspendLambda implements Function1<Continuation<? super Effect>, Object> {
        final Action.SendMessage $action;
        Object L$0;
        Object L$1;
        Object L$2;
        int label;

        C11372(Action.SendMessage sendMessage, Continuation<? super C11372> continuation) {
            super(1, continuation);
            this.$action = sendMessage;
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return UserActionProcessor.this.new C11372(this.$action, continuation);
        }

        @Override
        public final Object invoke(Continuation<? super Effect> continuation) {
            return ((C11372) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            zendesk.conversationkit.android.model.Message message;
            ConversationKitResult conversationKitResult;
            String str;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                obj = UserActionProcessor.this.userActionProcessorRepository.sendMessage(this.$action.getMessage(), this.$action.getConversationId(), this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i == 1) {
                    ResultKt.throwOnFailure(obj);
                } else {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    message = (zendesk.conversationkit.android.model.Message) this.L$2;
                    str = (String) this.L$1;
                    conversationKitResult = (ConversationKitResult) this.L$0;
                    ResultKt.throwOnFailure(obj);
                }
                return new Effect.SendMessageResult(conversationKitResult, str, message, (Conversation) obj);
            }
            zendesk.conversationkit.android.model.Message message2 = (zendesk.conversationkit.android.model.Message) obj;
            ConversationKitResult.Success success = new ConversationKitResult.Success(message2);
            String conversationId = this.$action.getConversationId();
            this.L$0 = success;
            this.L$1 = conversationId;
            this.L$2 = message2;
            this.label = 2;
            Object persistedConversation = UserActionProcessor.this.userActionProcessorRepository.getPersistedConversation(this.$action.getConversationId(), this);
            if (persistedConversation == coroutine_suspended) {
                return coroutine_suspended;
            }
            message = message2;
            obj = persistedConversation;
            conversationKitResult = success;
            str = conversationId;
            return new Effect.SendMessageResult(conversationKitResult, str, message, (Conversation) obj);
        }
    }

    public final Object preparePushToken(Action.PreparePushToken preparePushToken, Continuation<? super Effect> continuation) throws Throwable {
        C10981 c10981;
        if (continuation instanceof C10981) {
            c10981 = (C10981) continuation;
            if ((c10981.label & Integer.MIN_VALUE) != 0) {
                c10981.label -= Integer.MIN_VALUE;
            } else {
                c10981 = new C10981(continuation);
            }
        } else {
            c10981 = new C10981(continuation);
        }
        Object obj = c10981.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c10981.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            UserActionProcessorRepository userActionProcessorRepository = this.userActionProcessorRepository;
            String pushToken = preparePushToken.getPushToken();
            c10981.L$0 = preparePushToken;
            c10981.label = 1;
            if (userActionProcessorRepository.setPushToken(pushToken, c10981) == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            preparePushToken = (Action.PreparePushToken) c10981.L$0;
            ResultKt.throwOnFailure(obj);
        }
        return new Effect.PushTokenPrepared(preparePushToken.getPushToken());
    }

    public final Object cacheIntegrationId(Action.PushCacheIntegrationId pushCacheIntegrationId, Continuation<? super Effect> continuation) throws Throwable {
        C10971 c10971;
        if (continuation instanceof C10971) {
            c10971 = (C10971) continuation;
            if ((c10971.label & Integer.MIN_VALUE) != 0) {
                c10971.label -= Integer.MIN_VALUE;
            } else {
                c10971 = new C10971(continuation);
            }
        } else {
            c10971 = new C10971(continuation);
        }
        Object obj = c10971.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c10971.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            UserActionProcessorRepository userActionProcessorRepository = this.userActionProcessorRepository;
            String integrationId = pushCacheIntegrationId.getIntegrationId();
            c10971.L$0 = pushCacheIntegrationId;
            c10971.label = 1;
            if (userActionProcessorRepository.setIntegrationId(integrationId, c10971) == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            pushCacheIntegrationId = (Action.PushCacheIntegrationId) c10971.L$0;
            ResultKt.throwOnFailure(obj);
        }
        return new Effect.IntegrationIdCached(pushCacheIntegrationId.getIntegrationId());
    }

    public final Object updatePushToken(Action.UpdatePushToken updatePushToken, Continuation<? super Effect> continuation) throws Exception {
        C11511 c11511;
        if (continuation instanceof C11511) {
            c11511 = (C11511) continuation;
            if ((c11511.label & Integer.MIN_VALUE) != 0) {
                c11511.label -= Integer.MIN_VALUE;
            } else {
                c11511 = new C11511(continuation);
            }
        } else {
            c11511 = new C11511(continuation);
        }
        C11511 c11512 = c11511;
        Object objExecuteWithAuthErrorHandling$default = c11512.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11512.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
                String pushToken = updatePushToken.getPushToken();
                AuthenticationErrorHandler authenticationErrorHandler = this.authenticationErrorHandler;
                C11522 c11522 = new C11522(pushToken, null);
                c11512.L$0 = pushToken;
                c11512.label = 1;
                objExecuteWithAuthErrorHandling$default = AuthenticationErrorHandler.executeWithAuthErrorHandling$default(authenticationErrorHandler, null, c11522, c11512, 1, null);
                updatePushToken = pushToken;
                if (objExecuteWithAuthErrorHandling$default == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                String str = (String) c11512.L$0;
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
                updatePushToken = str;
            }
            return (Effect) objExecuteWithAuthErrorHandling$default;
        } catch (SerializationException e) {
            SerializationException serializationException = e;
            Logger.m218e(LOG_TAG, "PUT request for Updating Push Token failed to decode malformed JSON response.", serializationException, new Object[0]);
            return new Effect.PushTokenUpdateResult(new ConversationKitResult.Failure(serializationException), updatePushToken);
        } catch (Exception e2) {
            if (e2 instanceof CancellationException) {
                throw e2;
            }
            Exception exc = e2;
            Logger.m218e(LOG_TAG, "Failed to update push token.", exc, new Object[0]);
            return new Effect.PushTokenUpdateResult(new ConversationKitResult.Failure(exc), updatePushToken);
        }
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/conversationkit/android/internal/Effect;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor$updatePushToken$2", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {643}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C11522 extends SuspendLambda implements Function1<Continuation<? super Effect>, Object> {
        final String $pushToken;
        int label;

        C11522(String str, Continuation<? super C11522> continuation) {
            super(1, continuation);
            this.$pushToken = str;
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return UserActionProcessor.this.new C11522(this.$pushToken, continuation);
        }

        @Override
        public final Object invoke(Continuation<? super Effect> continuation) {
            return ((C11522) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (UserActionProcessor.this.userActionProcessorRepository.updatePushToken(this.$pushToken, this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return new Effect.PushTokenUpdateResult(new ConversationKitResult.Success(Unit.INSTANCE), this.$pushToken);
        }
    }

    public final Object sendActivityData(Action.SendActivityData sendActivityData, Continuation<? super Effect> continuation) throws Exception {
        C11491 c11491;
        if (continuation instanceof C11491) {
            c11491 = (C11491) continuation;
            if ((c11491.label & Integer.MIN_VALUE) != 0) {
                c11491.label -= Integer.MIN_VALUE;
            } else {
                c11491 = new C11491(continuation);
            }
        } else {
            c11491 = new C11491(continuation);
        }
        C11491 c11492 = c11491;
        Object objExecuteWithAuthErrorHandling$default = c11492.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11492.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
                AuthenticationErrorHandler authenticationErrorHandler = this.authenticationErrorHandler;
                C11502 c11502 = new C11502(sendActivityData, null);
                c11492.label = 1;
                objExecuteWithAuthErrorHandling$default = AuthenticationErrorHandler.executeWithAuthErrorHandling$default(authenticationErrorHandler, null, c11502, c11492, 1, null);
                if (objExecuteWithAuthErrorHandling$default == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
            }
            return (Effect) objExecuteWithAuthErrorHandling$default;
        } catch (SerializationException e) {
            Logger.m218e(LOG_TAG, "POST request for Sending Activity Data failed to decode malformed JSON response.", e, new Object[0]);
            return Effect.None.INSTANCE;
        } catch (Exception e2) {
            if (e2 instanceof CancellationException) {
                throw e2;
            }
            Logger.m218e(LOG_TAG, "Failed to send activity data.", e2, new Object[0]);
            return Effect.None.INSTANCE;
        }
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/conversationkit/android/internal/Effect;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor$sendActivityData$2", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {679}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C11502 extends SuspendLambda implements Function1<Continuation<? super Effect>, Object> {
        final Action.SendActivityData $action;
        int label;

        C11502(Action.SendActivityData sendActivityData, Continuation<? super C11502> continuation) {
            super(1, continuation);
            this.$action = sendActivityData;
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return UserActionProcessor.this.new C11502(this.$action, continuation);
        }

        @Override
        public final Object invoke(Continuation<? super Effect> continuation) {
            return ((C11502) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (UserActionProcessor.this.userActionProcessorRepository.sendActivityData(this.$action.getActivityData(), this.$action.getConversationId(), this) == coroutine_suspended) {
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

    public final Object processActivityEventReceived(Action.ActivityEventReceived activityEventReceived, Continuation<? super Effect> continuation) throws Exception {
        C11001 c11001;
        if (continuation instanceof C11001) {
            c11001 = (C11001) continuation;
            if ((c11001.label & Integer.MIN_VALUE) != 0) {
                c11001.label -= Integer.MIN_VALUE;
            } else {
                c11001 = new C11001(continuation);
            }
        } else {
            c11001 = new C11001(continuation);
        }
        Object objProcessActivityEventReceived = c11001.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11001.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(objProcessActivityEventReceived);
                UserActionProcessorRepository userActionProcessorRepository = this.userActionProcessorRepository;
                ActivityEvent activityEvent = activityEventReceived.getActivityEvent();
                c11001.L$0 = activityEventReceived;
                c11001.label = 1;
                objProcessActivityEventReceived = userActionProcessorRepository.processActivityEventReceived(activityEvent, c11001);
                if (objProcessActivityEventReceived == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                activityEventReceived = (Action.ActivityEventReceived) c11001.L$0;
                ResultKt.throwOnFailure(objProcessActivityEventReceived);
            }
            return new Effect.ActivityEventReceived(activityEventReceived.getActivityEvent(), (Conversation) objProcessActivityEventReceived);
        } catch (Exception e) {
            if (e instanceof CancellationException) {
                throw e;
            }
            Logger.m218e(LOG_TAG, String.valueOf(e.getMessage()), e, new Object[0]);
            return Effect.None.INSTANCE;
        }
    }

    public final Effect processPersistedUserRetrieved(Action.PersistedUserRetrieve action) {
        return new Effect.PersistedUserReceived(action.getUser());
    }

    public final Object processAddProactiveMessage(Action.AddProactiveMessage addProactiveMessage, Continuation<? super Effect> continuation) throws Throwable {
        C11031 c11031;
        if (continuation instanceof C11031) {
            c11031 = (C11031) continuation;
            if ((c11031.label & Integer.MIN_VALUE) != 0) {
                c11031.label -= Integer.MIN_VALUE;
            } else {
                c11031 = new C11031(continuation);
            }
        } else {
            c11031 = new C11031(continuation);
        }
        Object obj = c11031.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11031.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            UserActionProcessorRepository userActionProcessorRepository = this.userActionProcessorRepository;
            ProactiveMessage proactiveMessage = addProactiveMessage.getProactiveMessage();
            c11031.label = 1;
            if (userActionProcessorRepository.setProactiveMessage(proactiveMessage, c11031) == coroutine_suspended) {
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
        C11181 c11181;
        ConversationKitResult.Failure failure;
        if (continuation instanceof C11181) {
            c11181 = (C11181) continuation;
            if ((c11181.label & Integer.MIN_VALUE) != 0) {
                c11181.label -= Integer.MIN_VALUE;
            } else {
                c11181 = new C11181(continuation);
            }
        } else {
            c11181 = new C11181(continuation);
        }
        Object proactiveMessage = c11181.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11181.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(proactiveMessage);
                UserActionProcessorRepository userActionProcessorRepository = this.userActionProcessorRepository;
                int proactiveMessageId = getProactiveMessage.getProactiveMessageId();
                c11181.L$0 = getProactiveMessage;
                c11181.label = 1;
                proactiveMessage = userActionProcessorRepository.getProactiveMessage(proactiveMessageId, c11181);
                if (proactiveMessage == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                getProactiveMessage = (Action.GetProactiveMessage) c11181.L$0;
                ResultKt.throwOnFailure(proactiveMessage);
            }
            failure = new ConversationKitResult.Success(proactiveMessage);
        } catch (ProactiveMessageNotFoundException unused) {
            failure = new ConversationKitResult.Failure(new IllegalArgumentException("Couldn't find proactive message for id " + getProactiveMessage.getProactiveMessageId()));
        }
        return new Effect.GetProactiveMessage(failure);
    }

    public final Object processClearProactiveMessage(Action.ClearProactiveMessage clearProactiveMessage, Continuation<? super Effect> continuation) throws Throwable {
        C11051 c11051;
        if (continuation instanceof C11051) {
            c11051 = (C11051) continuation;
            if ((c11051.label & Integer.MIN_VALUE) != 0) {
                c11051.label -= Integer.MIN_VALUE;
            } else {
                c11051 = new C11051(continuation);
            }
        } else {
            c11051 = new C11051(continuation);
        }
        Object obj = c11051.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11051.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            UserActionProcessorRepository userActionProcessorRepository = this.userActionProcessorRepository;
            int proactiveMessageId = clearProactiveMessage.getProactiveMessageId();
            c11051.label = 1;
            if (userActionProcessorRepository.clearProactiveMessage(proactiveMessageId, c11051) == coroutine_suspended) {
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

    public final Object processConversationAdded(String str, Continuation<? super Effect> continuation) throws Exception {
        C11071 c11071;
        if (continuation instanceof C11071) {
            c11071 = (C11071) continuation;
            if ((c11071.label & Integer.MIN_VALUE) != 0) {
                c11071.label -= Integer.MIN_VALUE;
            } else {
                c11071 = new C11071(continuation);
            }
        } else {
            c11071 = new C11071(continuation);
        }
        C11071 c11072 = c11071;
        Object objExecuteWithAuthErrorHandling$default = c11072.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11072.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
                AuthenticationErrorHandler authenticationErrorHandler = this.authenticationErrorHandler;
                C11082 c11082 = new C11082(str, null);
                c11072.label = 1;
                objExecuteWithAuthErrorHandling$default = AuthenticationErrorHandler.executeWithAuthErrorHandling$default(authenticationErrorHandler, null, c11082, c11072, 1, null);
                if (objExecuteWithAuthErrorHandling$default == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
            }
            return (Effect) objExecuteWithAuthErrorHandling$default;
        } catch (SerializationException e) {
            SerializationException serializationException = e;
            Logger.m218e(LOG_TAG, GET_CONVERSATION_SERIALIZATION_EXCEPTION_LOG_MESSAGE, serializationException, new Object[0]);
            return new Effect.ConversationAddedResult(new ConversationKitResult.Failure(serializationException));
        } catch (Exception e2) {
            if (e2 instanceof CancellationException) {
                throw e2;
            }
            Exception exc = e2;
            Logger.m218e(LOG_TAG, "Failed to get added conversation.", exc, new Object[0]);
            return new Effect.ConversationAddedResult(new ConversationKitResult.Failure(exc));
        }
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/conversationkit/android/internal/Effect;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor$processConversationAdded$2", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {775}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C11082 extends SuspendLambda implements Function1<Continuation<? super Effect>, Object> {
        final String $conversationId;
        int label;

        C11082(String str, Continuation<? super C11082> continuation) {
            super(1, continuation);
            this.$conversationId = str;
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return UserActionProcessor.this.new C11082(this.$conversationId, continuation);
        }

        @Override
        public final Object invoke(Continuation<? super Effect> continuation) {
            return ((C11082) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                obj = UserActionProcessor.this.userActionProcessorRepository.getConversationRemotely(this.$conversationId, this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return new Effect.ConversationAddedResult(new ConversationKitResult.Success((Conversation) obj));
        }
    }

    public final Object processConversationRemoved(String str, Continuation<? super Effect> continuation) throws Exception {
        C11091 c11091;
        if (continuation instanceof C11091) {
            c11091 = (C11091) continuation;
            if ((c11091.label & Integer.MIN_VALUE) != 0) {
                c11091.label -= Integer.MIN_VALUE;
            } else {
                c11091 = new C11091(continuation);
            }
        } else {
            c11091 = new C11091(continuation);
        }
        Object obj = c11091.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11091.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                UserActionProcessorRepository userActionProcessorRepository = this.userActionProcessorRepository;
                c11091.L$0 = str;
                c11091.label = 1;
                if (userActionProcessorRepository.removeConversationById(str, c11091) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                str = (String) c11091.L$0;
                ResultKt.throwOnFailure(obj);
            }
            return new Effect.ConversationRemovedResult(new ConversationKitResult.Success(str));
        } catch (ConversationNotFoundException e) {
            ConversationNotFoundException conversationNotFoundException = e;
            Logger.m218e(LOG_TAG, "Unable to find conversation", conversationNotFoundException, new Object[0]);
            return new Effect.ConversationRemovedResult(new ConversationKitResult.Failure(conversationNotFoundException));
        } catch (Exception e2) {
            if (e2 instanceof CancellationException) {
                throw e2;
            }
            Exception exc = e2;
            Logger.m218e(LOG_TAG, "Failed to remove conversation.", exc, new Object[0]);
            return new Effect.ConversationRemovedResult(new ConversationKitResult.Failure(exc));
        }
    }

    public final Object processConversationUpdate(Action.ConversationUpdate conversationUpdate, Continuation<? super Effect> continuation) throws Exception {
        C11101 c11101;
        if (continuation instanceof C11101) {
            c11101 = (C11101) continuation;
            if ((c11101.label & Integer.MIN_VALUE) != 0) {
                c11101.label -= Integer.MIN_VALUE;
            } else {
                c11101 = new C11101(continuation);
            }
        } else {
            c11101 = new C11101(continuation);
        }
        Object objUpdateConversationById = c11101.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11101.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(objUpdateConversationById);
                UserActionProcessorRepository userActionProcessorRepository = this.userActionProcessorRepository;
                String conversationId = conversationUpdate.getConversationId();
                ConversationStatus status = conversationUpdate.getStatus();
                Map<String, ? extends Object> metadata = conversationUpdate.getMetadata();
                c11101.label = 1;
                objUpdateConversationById = userActionProcessorRepository.updateConversationById(conversationId, status, metadata, c11101);
                if (objUpdateConversationById == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(objUpdateConversationById);
            }
            return new Effect.ConversationUpdatedResult(new ConversationKitResult.Success((Conversation) objUpdateConversationById));
        } catch (ConversationNotFoundException e) {
            String message = e.getMessage();
            ConversationNotFoundException conversationNotFoundException = e;
            Logger.m218e(LOG_TAG, message, conversationNotFoundException, new Object[0]);
            return new Effect.ConversationUpdatedResult(new ConversationKitResult.Failure(conversationNotFoundException));
        } catch (Exception e2) {
            if (e2 instanceof CancellationException) {
                throw e2;
            }
            Exception exc = e2;
            Logger.m218e(LOG_TAG, "Failed to update conversation.", exc, new Object[0]);
            return new Effect.ConversationUpdatedResult(new ConversationKitResult.Failure(exc));
        }
    }

    public final Object processGetConversations(Action.GetConversations getConversations, Continuation<? super Effect> continuation) throws Exception {
        C11161 c11161;
        if (continuation instanceof C11161) {
            c11161 = (C11161) continuation;
            if ((c11161.label & Integer.MIN_VALUE) != 0) {
                c11161.label -= Integer.MIN_VALUE;
            } else {
                c11161 = new C11161(continuation);
            }
        } else {
            c11161 = new C11161(continuation);
        }
        C11161 c11162 = c11161;
        Object objExecuteWithAuthErrorHandling$default = c11162.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11162.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
                AuthenticationErrorHandler authenticationErrorHandler = this.authenticationErrorHandler;
                C11172 c11172 = new C11172(getConversations, null);
                c11162.label = 1;
                objExecuteWithAuthErrorHandling$default = AuthenticationErrorHandler.executeWithAuthErrorHandling$default(authenticationErrorHandler, null, c11172, c11162, 1, null);
                if (objExecuteWithAuthErrorHandling$default == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
            }
            return (Effect) objExecuteWithAuthErrorHandling$default;
        } catch (Exception e) {
            if (e instanceof CancellationException) {
                throw e;
            }
            Exception exc = e;
            Logger.m218e(LOG_TAG, "Failed to update conversation.", exc, new Object[0]);
            return new Effect.GetConversationsResult(new ConversationKitResult.Failure(exc));
        }
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/conversationkit/android/internal/Effect;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor$processGetConversations$2", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {844}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C11172 extends SuspendLambda implements Function1<Continuation<? super Effect>, Object> {
        final Action.GetConversations $action;
        int label;

        C11172(Action.GetConversations getConversations, Continuation<? super C11172> continuation) {
            super(1, continuation);
            this.$action = getConversations;
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return UserActionProcessor.this.new C11172(this.$action, continuation);
        }

        @Override
        public final Object invoke(Continuation<? super Effect> continuation) {
            return ((C11172) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                obj = UserActionProcessor.this.userActionProcessorRepository.getConversations(this.$action.getOffset(), this.$action.getFromCache(), this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return new Effect.GetConversationsResult(new ConversationKitResult.Success((ConversationsPagination) obj));
        }
    }

    public final Object processUserMerge(Action.UserMergeReceived userMergeReceived, Continuation<? super Effect> continuation) throws Throwable {
        C11481 c11481;
        UserActionProcessor userActionProcessor;
        UserActionProcessor userActionProcessor2;
        if (continuation instanceof C11481) {
            c11481 = (C11481) continuation;
            if ((c11481.label & Integer.MIN_VALUE) != 0) {
                c11481.label -= Integer.MIN_VALUE;
            } else {
                c11481 = new C11481(continuation);
            }
        } else {
            c11481 = new C11481(continuation);
        }
        Object user = c11481.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11481.label;
        if (i != 0) {
            if (i == 1) {
                userMergeReceived = (Action.UserMergeReceived) c11481.L$1;
                userActionProcessor = (UserActionProcessor) c11481.L$0;
                ResultKt.throwOnFailure(user);
            } else if (i == 2) {
                userActionProcessor2 = (UserActionProcessor) c11481.L$0;
                ResultKt.throwOnFailure(user);
                UserActionProcessorRepository userActionProcessorRepository = userActionProcessor2.userActionProcessorRepository;
                c11481.L$0 = null;
                c11481.label = 3;
                user = userActionProcessorRepository.getUser(c11481);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 3) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(user);
            }
            String jwt$zendesk_conversationkit_conversationkit_android = ((User) user).getJwt$zendesk_conversationkit_conversationkit_android();
            return jwt$zendesk_conversationkit_conversationkit_android != null ? new Effect.ReAuthenticateUser(jwt$zendesk_conversationkit_conversationkit_android) : Effect.None.INSTANCE;
        }
        ResultKt.throwOnFailure(user);
        UserActionProcessorRepository userActionProcessorRepository2 = this.userActionProcessorRepository;
        c11481.L$0 = this;
        c11481.L$1 = userMergeReceived;
        c11481.label = 1;
        user = userActionProcessorRepository2.getUser(c11481);
        if (user == coroutine_suspended) {
            return coroutine_suspended;
        }
        userActionProcessor = this;
        if (!Intrinsics.areEqual(((User) user).getId(), userMergeReceived.getData().getSurvivingAppUserId())) {
            UserActionProcessorRepository userActionProcessorRepository3 = userActionProcessor.userActionProcessorRepository;
            c11481.L$0 = userActionProcessor;
            c11481.L$1 = null;
            c11481.label = 2;
            if (userActionProcessorRepository3.updateReAuthenticateUser(true, c11481) == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessor2 = userActionProcessor;
            UserActionProcessorRepository userActionProcessorRepository4 = userActionProcessor2.userActionProcessorRepository;
            c11481.L$0 = null;
            c11481.label = 3;
            user = userActionProcessorRepository4.getUser(c11481);
            if (user == coroutine_suspended) {
                return coroutine_suspended;
            }
            String jwt$zendesk_conversationkit_conversationkit_android2 = ((User) user).getJwt$zendesk_conversationkit_conversationkit_android();
            if (jwt$zendesk_conversationkit_conversationkit_android2 != null) {
            }
        }
        return Effect.None.INSTANCE;
    }

    public final Object processAddConversationFields(Action.AddConversationFields addConversationFields, Continuation<? super Effect> continuation) throws Throwable {
        C11011 c11011;
        if (continuation instanceof C11011) {
            c11011 = (C11011) continuation;
            if ((c11011.label & Integer.MIN_VALUE) != 0) {
                c11011.label -= Integer.MIN_VALUE;
            } else {
                c11011 = new C11011(continuation);
            }
        } else {
            c11011 = new C11011(continuation);
        }
        Object obj = c11011.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11011.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            if (!addConversationFields.getFields().isEmpty()) {
                MetadataManager metadataManager = this.metadataManager;
                Map<String, ? extends Object> fields = addConversationFields.getFields();
                c11011.label = 1;
                if (metadataManager.saveConversationFields(fields, c11011) == coroutine_suspended) {
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
        C11021 c11021;
        if (continuation instanceof C11021) {
            c11021 = (C11021) continuation;
            if ((c11021.label & Integer.MIN_VALUE) != 0) {
                c11021.label -= Integer.MIN_VALUE;
            } else {
                c11021 = new C11021(continuation);
            }
        } else {
            c11021 = new C11021(continuation);
        }
        Object obj = c11021.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11021.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            if (!addConversationTags.getTags().isEmpty()) {
                MetadataManager metadataManager = this.metadataManager;
                List<String> tags = addConversationTags.getTags();
                c11021.label = 1;
                if (metadataManager.saveConversationTags(tags, c11021) == coroutine_suspended) {
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
        C11041 c11041;
        if (continuation instanceof C11041) {
            c11041 = (C11041) continuation;
            if ((c11041.label & Integer.MIN_VALUE) != 0) {
                c11041.label -= Integer.MIN_VALUE;
            } else {
                c11041 = new C11041(continuation);
            }
        } else {
            c11041 = new C11041(continuation);
        }
        Object obj = c11041.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11041.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            MetadataManager metadataManager = this.metadataManager;
            c11041.label = 1;
            if (metadataManager.clearConversationFields(c11041) == coroutine_suspended) {
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
        C11061 c11061;
        if (continuation instanceof C11061) {
            c11061 = (C11061) continuation;
            if ((c11061.label & Integer.MIN_VALUE) != 0) {
                c11061.label -= Integer.MIN_VALUE;
            } else {
                c11061 = new C11061(continuation);
            }
        } else {
            c11061 = new C11061(continuation);
        }
        Object obj = c11061.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11061.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            MetadataManager metadataManager = this.metadataManager;
            c11061.label = 1;
            if (metadataManager.clearConversationTags(c11061) == coroutine_suspended) {
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

    public final Object processUpdateConversationMetadata(Action.UpdateConversationMetadata updateConversationMetadata, Continuation<? super Effect> continuation) throws Exception {
        C11431 c11431;
        if (continuation instanceof C11431) {
            c11431 = (C11431) continuation;
            if ((c11431.label & Integer.MIN_VALUE) != 0) {
                c11431.label -= Integer.MIN_VALUE;
            } else {
                c11431 = new C11431(continuation);
            }
        } else {
            c11431 = new C11431(continuation);
        }
        C11431 c11432 = c11431;
        Object objExecuteWithAuthErrorHandling$default = c11432.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11432.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
                AuthenticationErrorHandler authenticationErrorHandler = this.authenticationErrorHandler;
                C11442 c11442 = new C11442(updateConversationMetadata, null);
                c11432.L$0 = updateConversationMetadata;
                c11432.label = 1;
                objExecuteWithAuthErrorHandling$default = AuthenticationErrorHandler.executeWithAuthErrorHandling$default(authenticationErrorHandler, null, c11442, c11432, 1, null);
                if (objExecuteWithAuthErrorHandling$default == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                updateConversationMetadata = (Action.UpdateConversationMetadata) c11432.L$0;
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
            }
            return (Effect) objExecuteWithAuthErrorHandling$default;
        } catch (SerializationException e) {
            Logger.m218e(LOG_TAG, "PUT request to update Conversation failed to decode malformed JSON response.", e, new Object[0]);
            return Effect.None.INSTANCE;
        } catch (Exception e2) {
            if (e2 instanceof CancellationException) {
                throw e2;
            }
            Logger.m218e(LOG_TAG, "Failed updating Conversation with id = " + updateConversationMetadata.getConversationId(), e2, new Object[0]);
            return Effect.None.INSTANCE;
        }
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/conversationkit/android/internal/Effect;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor$processUpdateConversationMetadata$2", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {926}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C11442 extends SuspendLambda implements Function1<Continuation<? super Effect>, Object> {
        final Action.UpdateConversationMetadata $action;
        int label;

        C11442(Action.UpdateConversationMetadata updateConversationMetadata, Continuation<? super C11442> continuation) {
            super(1, continuation);
            this.$action = updateConversationMetadata;
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return UserActionProcessor.this.new C11442(this.$action, continuation);
        }

        @Override
        public final Object invoke(Continuation<? super Effect> continuation) {
            return ((C11442) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (UserActionProcessor.this.userActionProcessorRepository.updateConversationMetadata(this.$action.getConversationId(), this.$action.getMetadata(), this) == coroutine_suspended) {
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

    public final Object processSendPostbackAction(Action.SendPostbackAction sendPostbackAction, Continuation<? super Effect> continuation) throws Exception {
        C11381 c11381;
        if (continuation instanceof C11381) {
            c11381 = (C11381) continuation;
            if ((c11381.label & Integer.MIN_VALUE) != 0) {
                c11381.label -= Integer.MIN_VALUE;
            } else {
                c11381 = new C11381(continuation);
            }
        } else {
            c11381 = new C11381(continuation);
        }
        C11381 c11382 = c11381;
        Object objExecuteWithAuthErrorHandling$default = c11382.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11382.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
                AuthenticationErrorHandler authenticationErrorHandler = this.authenticationErrorHandler;
                C11392 c11392 = new C11392(sendPostbackAction, null);
                c11382.label = 1;
                objExecuteWithAuthErrorHandling$default = AuthenticationErrorHandler.executeWithAuthErrorHandling$default(authenticationErrorHandler, null, c11392, c11382, 1, null);
                if (objExecuteWithAuthErrorHandling$default == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
            }
            return (Effect) objExecuteWithAuthErrorHandling$default;
        } catch (Exception e) {
            if (e instanceof CancellationException) {
                throw e;
            }
            Exception exc = e;
            Logger.m218e(LOG_TAG, "POST request to send a Postback failed.", exc, new Object[0]);
            return new Effect.SendPostbackResult(new ConversationKitResult.Failure(exc));
        }
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/conversationkit/android/internal/Effect;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor$processSendPostbackAction$2", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {956}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C11392 extends SuspendLambda implements Function1<Continuation<? super Effect>, Object> {
        final Action.SendPostbackAction $action;
        int label;

        C11392(Action.SendPostbackAction sendPostbackAction, Continuation<? super C11392> continuation) {
            super(1, continuation);
            this.$action = sendPostbackAction;
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return UserActionProcessor.this.new C11392(this.$action, continuation);
        }

        @Override
        public final Object invoke(Continuation<? super Effect> continuation) {
            return ((C11392) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (UserActionProcessor.this.userActionProcessorRepository.sendPostbackAction(this.$action.getConversationId(), this.$action.getActionId(), this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return new Effect.SendPostbackResult(new ConversationKitResult.Success(this.$action.getActionId()));
        }
    }

    public final Object processDownloadAttachmentAction(Action.DownloadAttachmentAction downloadAttachmentAction, Continuation<? super Effect> continuation) throws Throwable {
        C11131 c11131;
        AttachmentDownloader attachmentDownloader;
        String str;
        String str2;
        UserActionProcessor userActionProcessor;
        if (continuation instanceof C11131) {
            c11131 = (C11131) continuation;
            if ((c11131.label & Integer.MIN_VALUE) != 0) {
                c11131.label -= Integer.MIN_VALUE;
            } else {
                c11131 = new C11131(continuation);
            }
        } else {
            c11131 = new C11131(continuation);
        }
        Object objUpdateDownloadingAttachment = c11131.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11131.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(objUpdateDownloadingAttachment);
                if (!(downloadAttachmentAction.getMessage().getContent() instanceof MessageContent.File)) {
                    return Effect.None.INSTANCE;
                }
                AttachmentDownloader attachmentDownloader2 = this.attachmentDownloader;
                String mediaUrl = ((MessageContent.File) downloadAttachmentAction.getMessage().getContent()).getMediaUrl();
                String altText = ((MessageContent.File) downloadAttachmentAction.getMessage().getContent()).getAltText();
                c11131.L$0 = this;
                c11131.L$1 = downloadAttachmentAction;
                c11131.L$2 = attachmentDownloader2;
                c11131.L$3 = mediaUrl;
                c11131.L$4 = altText;
                c11131.label = 1;
                Object user = getUser(c11131);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
                attachmentDownloader = attachmentDownloader2;
                str = mediaUrl;
                objUpdateDownloadingAttachment = user;
                str2 = altText;
                userActionProcessor = this;
            } else {
                if (i == 1) {
                    String str3 = (String) c11131.L$4;
                    String str4 = (String) c11131.L$3;
                    AttachmentDownloader attachmentDownloader3 = (AttachmentDownloader) c11131.L$2;
                    Action.DownloadAttachmentAction downloadAttachmentAction2 = (Action.DownloadAttachmentAction) c11131.L$1;
                    UserActionProcessor userActionProcessor2 = (UserActionProcessor) c11131.L$0;
                    ResultKt.throwOnFailure(objUpdateDownloadingAttachment);
                    str2 = str3;
                    str = str4;
                    downloadAttachmentAction = downloadAttachmentAction2;
                    userActionProcessor = userActionProcessor2;
                    attachmentDownloader = attachmentDownloader3;
                } else {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(objUpdateDownloadingAttachment);
                }
                return new Effect.AttachmentDownloadStarted((Conversation) objUpdateDownloadingAttachment);
            }
            ProcessAttachmentStatus processAttachmentStatusM210xd0b463a2 = attachmentDownloader.m210xd0b463a2(str, str2, PrivateAttachmentUtilKt.resolveAuthTokenForPrivateAttachment(UserExtensionsKt.getAuthorization((User) objUpdateDownloadingAttachment), MessageKt.isPrivateAttachment(downloadAttachmentAction.getMessage().getContent())), downloadAttachmentAction.getMessage().getId(), downloadAttachmentAction.getConversationId());
            if (processAttachmentStatusM210xd0b463a2 instanceof ProcessAttachmentStatus.AttachmentToBeDownloaded) {
                UserActionProcessorRepository userActionProcessorRepository = userActionProcessor.userActionProcessorRepository;
                String conversationId = downloadAttachmentAction.getConversationId();
                zendesk.conversationkit.android.model.Message message = downloadAttachmentAction.getMessage();
                c11131.L$0 = null;
                c11131.L$1 = null;
                c11131.L$2 = null;
                c11131.L$3 = null;
                c11131.L$4 = null;
                c11131.label = 2;
                objUpdateDownloadingAttachment = userActionProcessorRepository.updateDownloadingAttachment(conversationId, message, c11131);
                if (objUpdateDownloadingAttachment == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return new Effect.AttachmentDownloadStarted((Conversation) objUpdateDownloadingAttachment);
            }
            if (processAttachmentStatusM210xd0b463a2 instanceof ProcessAttachmentStatus.AttachmentAvailableInStorage) {
                return new Effect.OpenAttachmentFromFile(((ProcessAttachmentStatus.AttachmentAvailableInStorage) processAttachmentStatusM210xd0b463a2).getFile(), downloadAttachmentAction.getConversationId());
            }
            throw new NoWhenBranchMatchedException();
        } catch (ConversationNotFoundException e) {
            Logger.m218e(LOG_TAG, e.getMessage(), e, new Object[0]);
            return Effect.None.INSTANCE;
        }
    }

    public final Object processUpdateDownloadStatusAction(Action.UpdateDownloadStatusAction updateDownloadStatusAction, Continuation<? super Effect> continuation) throws Throwable {
        C11451 c11451;
        if (continuation instanceof C11451) {
            c11451 = (C11451) continuation;
            if ((c11451.label & Integer.MIN_VALUE) != 0) {
                c11451.label -= Integer.MIN_VALUE;
            } else {
                c11451 = new C11451(continuation);
            }
        } else {
            c11451 = new C11451(continuation);
        }
        C11451 c11452 = c11451;
        Object objExecuteWithAuthErrorHandling$default = c11452.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11452.label;
        try {
            if (i != 0) {
                if (i == 1) {
                    ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
                    return (Effect) objExecuteWithAuthErrorHandling$default;
                }
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
                return (Effect) objExecuteWithAuthErrorHandling$default;
            }
            ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
            if (updateDownloadStatusAction.getStatus() instanceof DownloadAttachmentStatus.DownloadAttachmentSuccess) {
                AuthenticationErrorHandler authenticationErrorHandler = this.authenticationErrorHandler;
                C11462 c11462 = new C11462(updateDownloadStatusAction, null);
                c11452.label = 1;
                objExecuteWithAuthErrorHandling$default = AuthenticationErrorHandler.executeWithAuthErrorHandling$default(authenticationErrorHandler, null, c11462, c11452, 1, null);
                if (objExecuteWithAuthErrorHandling$default == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return (Effect) objExecuteWithAuthErrorHandling$default;
            }
            AuthenticationErrorHandler authenticationErrorHandler2 = this.authenticationErrorHandler;
            C11473 c11473 = new C11473(updateDownloadStatusAction, null);
            c11452.label = 2;
            objExecuteWithAuthErrorHandling$default = AuthenticationErrorHandler.executeWithAuthErrorHandling$default(authenticationErrorHandler2, null, c11473, c11452, 1, null);
            if (objExecuteWithAuthErrorHandling$default == coroutine_suspended) {
                return coroutine_suspended;
            }
            return (Effect) objExecuteWithAuthErrorHandling$default;
        } catch (ConversationNotFoundException e) {
            Logger.m218e(LOG_TAG, e.getMessage(), e, new Object[0]);
            return Effect.None.INSTANCE;
        }
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/conversationkit/android/internal/Effect;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor$processUpdateDownloadStatusAction$2", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {1031}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C11462 extends SuspendLambda implements Function1<Continuation<? super Effect>, Object> {
        final Action.UpdateDownloadStatusAction $action;
        int label;

        C11462(Action.UpdateDownloadStatusAction updateDownloadStatusAction, Continuation<? super C11462> continuation) {
            super(1, continuation);
            this.$action = updateDownloadStatusAction;
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return UserActionProcessor.this.new C11462(this.$action, continuation);
        }

        @Override
        public final Object invoke(Continuation<? super Effect> continuation) {
            return ((C11462) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                obj = UserActionProcessor.this.userActionProcessorRepository.updateDownloadingStatusSuccess(((DownloadAttachmentStatus.DownloadAttachmentSuccess) this.$action.getStatus()).getFileName(), ((DownloadAttachmentStatus.DownloadAttachmentSuccess) this.$action.getStatus()).getMessageId(), ((DownloadAttachmentStatus.DownloadAttachmentSuccess) this.$action.getStatus()).getConversationId(), this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return new Effect.OpenAttachmentFromFile(((DownloadAttachmentStatus.DownloadAttachmentSuccess) this.$action.getStatus()).getFile(), ((Conversation) obj).getId());
        }
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/conversationkit/android/internal/Effect;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor$processUpdateDownloadStatusAction$3", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {1040}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C11473 extends SuspendLambda implements Function1<Continuation<? super Effect>, Object> {
        final Action.UpdateDownloadStatusAction $action;
        int label;

        C11473(Action.UpdateDownloadStatusAction updateDownloadStatusAction, Continuation<? super C11473> continuation) {
            super(1, continuation);
            this.$action = updateDownloadStatusAction;
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return UserActionProcessor.this.new C11473(this.$action, continuation);
        }

        @Override
        public final Object invoke(Continuation<? super Effect> continuation) {
            return ((C11473) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                UserActionProcessorRepository userActionProcessorRepository = UserActionProcessor.this.userActionProcessorRepository;
                DownloadAttachmentStatus status = this.$action.getStatus();
                Intrinsics.checkNotNull(status, "null cannot be cast to non-null type zendesk.conversationkit.android.model.attachments.DownloadAttachmentStatus.DownloadAttachmentFailed");
                this.label = 1;
                obj = userActionProcessorRepository.updateDownloadingStatusFailed(((DownloadAttachmentStatus.DownloadAttachmentFailed) status).getFileName(), ((DownloadAttachmentStatus.DownloadAttachmentFailed) this.$action.getStatus()).getMessageId(), ((DownloadAttachmentStatus.DownloadAttachmentFailed) this.$action.getStatus()).getConversationId(), this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return new Effect.RefreshConversationResult(new ConversationKitResult.Success((Conversation) obj));
        }
    }

    public final Object processGetWaitTimeForConversation(Action.GetWaitTimeForConversation getWaitTimeForConversation, Continuation<? super Effect> continuation) throws Exception {
        C11201 c11201;
        if (continuation instanceof C11201) {
            c11201 = (C11201) continuation;
            if ((c11201.label & Integer.MIN_VALUE) != 0) {
                c11201.label -= Integer.MIN_VALUE;
            } else {
                c11201 = new C11201(continuation);
            }
        } else {
            c11201 = new C11201(continuation);
        }
        C11201 c11202 = c11201;
        Object objExecuteWithAuthErrorHandling$default = c11202.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11202.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
                AuthenticationErrorHandler authenticationErrorHandler = this.authenticationErrorHandler;
                C11212 c11212 = new C11212(getWaitTimeForConversation, null);
                c11202.L$0 = getWaitTimeForConversation;
                c11202.label = 1;
                objExecuteWithAuthErrorHandling$default = AuthenticationErrorHandler.executeWithAuthErrorHandling$default(authenticationErrorHandler, null, c11212, c11202, 1, null);
                if (objExecuteWithAuthErrorHandling$default == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                getWaitTimeForConversation = (Action.GetWaitTimeForConversation) c11202.L$0;
                ResultKt.throwOnFailure(objExecuteWithAuthErrorHandling$default);
            }
            return (Effect) objExecuteWithAuthErrorHandling$default;
        } catch (SerializationException e) {
            SerializationException serializationException = e;
            Logger.m218e(LOG_TAG, "Failed to decode wait time data for conversation " + getWaitTimeForConversation.getConversationId() + " due to malformed JSON response.", serializationException, new Object[0]);
            return new Effect.FetchWaitTimeResult(new ConversationKitResult.Failure(serializationException));
        } catch (Exception e2) {
            if (e2 instanceof CancellationException) {
                throw e2;
            }
            Exception exc = e2;
            Logger.m218e(LOG_TAG, "Failed to fetch wait time for conversation " + getWaitTimeForConversation.getConversationId(), exc, new Object[0]);
            return new Effect.FetchWaitTimeResult(new ConversationKitResult.Failure(exc));
        }
    }

    @Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/conversationkit/android/internal/Effect;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.UserActionProcessor$processGetWaitTimeForConversation$2", m37f = "UserActionProcessor.kt", m38i = {}, m39l = {1067}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C11212 extends SuspendLambda implements Function1<Continuation<? super Effect>, Object> {
        final Action.GetWaitTimeForConversation $action;
        int label;

        C11212(Action.GetWaitTimeForConversation getWaitTimeForConversation, Continuation<? super C11212> continuation) {
            super(1, continuation);
            this.$action = getWaitTimeForConversation;
        }

        @Override
        public final Continuation<Unit> create(Continuation<?> continuation) {
            return UserActionProcessor.this.new C11212(this.$action, continuation);
        }

        @Override
        public final Object invoke(Continuation<? super Effect> continuation) {
            return ((C11212) create(continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                obj = UserActionProcessor.this.userActionProcessorRepository.getWaitTimeForConversation(this.$action.getConversationId(), this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return new Effect.FetchWaitTimeResult(new ConversationKitResult.Success(((WaitTimeDataResponse) obj).getWaitTimeData()));
        }
    }
}
