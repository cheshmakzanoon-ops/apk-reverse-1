package zendesk.messaging.android.internal.conversationslistscreen.conversation;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.List;
import javax.inject.Inject;
import javax.inject.Named;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.comparisons.ComparisonsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.collections.immutable.ExtensionsKt;
import kotlinx.collections.immutable.ImmutableList;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineDispatcher;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.conversationkit.android.ConversationKitResult;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.ConversationsPagination;
import zendesk.conversationkit.android.model.Message;
import zendesk.core.android.internal.p016di.CoroutineDispatchersModule;
import zendesk.core.p017ui.android.internal.model.ConversationEntry;
import zendesk.logger.Logger;
import zendesk.messaging.android.internal.conversationslistscreen.ConversationsListScreenState;
import zendesk.messaging.android.internal.conversationslistscreen.ConversationsListState;
import zendesk.messaging.android.internal.conversationslistscreen.CreateConversationState;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.cache.ConversationsListInMemoryCache;
import zendesk.messaging.android.internal.model.MessagingTheme;

@Metadata(m17d1 = {"\u0000 \u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010!\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0016\n\u0002\u0018\u0002\n\u0002\b\u000e\n\u0002\u0010\u001e\n\u0002\b\t\n\u0002\u0010\u0002\n\u0002\b\u0007\b\u0000\u0018\u0000 f2\u00020\u0001:\u0001fB)\b\u0007\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0001\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\nJ1\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\r0\f2\f\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\r0\f2\u0006\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u0012H\u0000¢\u0006\u0002\b\u0013J:\u0010\u0014\u001a\u00020\u00152\u0006\u0010\u0016\u001a\u00020\u00152\u0006\u0010\u0017\u001a\u00020\u00182\u000e\b\u0002\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\u001a0\u00192\b\b\u0002\u0010\u001b\u001a\u00020\u001cH\u0080@¢\u0006\u0004\b\u001d\u0010\u001eJ\u0016\u0010\u001f\u001a\b\u0012\u0004\u0012\u00020\u001a0 H\u0080@¢\u0006\u0004\b!\u0010\"J,\u0010#\u001a\b\u0012\u0004\u0012\u00020\r0\f2\f\u0010$\u001a\b\u0012\u0004\u0012\u00020\r0%2\u0006\u0010&\u001a\u00020'2\u0006\u0010(\u001a\u00020'H\u0002J\u001c\u0010)\u001a\b\u0012\u0004\u0012\u00020\u001a0 2\u0006\u0010*\u001a\u00020+H\u0082@¢\u0006\u0002\u0010,J \u0010-\u001a\b\u0012\u0004\u0012\u00020.0 2\b\b\u0002\u0010/\u001a\u000200H\u0080@¢\u0006\u0004\b1\u00102J\u001c\u00103\u001a\b\u0012\u0004\u0012\u00020\r0\u00192\f\u00104\u001a\b\u0012\u0004\u0012\u00020\r0\u0019H\u0002J,\u00105\u001a\b\u0012\u0004\u0012\u00020\r0\u00192\f\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\u001a0\u00192\u0006\u0010\u0016\u001a\u00020\u0015H\u0080@¢\u0006\u0004\b6\u00107J\u0010\u00108\u001a\u0002002\u0006\u0010*\u001a\u00020+H\u0002J\u0018\u00109\u001a\u00020\r2\u0006\u0010:\u001a\u00020\u001c2\u0006\u0010;\u001a\u00020\rH\u0002J \u0010<\u001a\u00020\u00152\u0006\u0010=\u001a\u00020\u001a2\u0006\u0010\u0016\u001a\u00020\u0015H\u0080@¢\u0006\u0004\b>\u0010?J \u0010@\u001a\u00020\u00152\u0006\u0010*\u001a\u00020+2\u0006\u0010\u0016\u001a\u00020\u0015H\u0080@¢\u0006\u0004\bA\u0010BJ \u0010C\u001a\u00020\u00152\u0006\u0010*\u001a\u00020+2\u0006\u0010\u0016\u001a\u00020\u0015H\u0080@¢\u0006\u0004\bD\u0010BJ<\u0010E\u001a\u00020\u00152\u0006\u0010*\u001a\u00020+2\u0006\u0010F\u001a\u00020G2\u0006\u0010\u0016\u001a\u00020\u00152\b\b\u0002\u0010H\u001a\u00020\u001c2\b\b\u0002\u0010:\u001a\u00020\u001cH\u0080@¢\u0006\u0004\bI\u0010JJ.\u0010K\u001a\u00020\u00152\f\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\u001a0\u00192\u0006\u0010\u0016\u001a\u00020\u00152\u0006\u0010\u001b\u001a\u00020\u001cH\u0080@¢\u0006\u0004\bL\u0010MJ*\u00104\u001a\b\u0012\u0004\u0012\u00020\r0\u00192\f\u0010N\u001a\b\u0012\u0004\u0012\u00020\r0\u00192\f\u0010O\u001a\b\u0012\u0004\u0012\u00020\r0\u0019H\u0002J,\u0010P\u001a\u00020\u00152\u0006\u0010Q\u001a\u00020\u00152\b\b\u0002\u0010R\u001a\u00020\u001c2\b\b\u0002\u0010/\u001a\u000200H\u0080@¢\u0006\u0004\bS\u0010TJ,\u0010U\u001a\b\u0012\u0004\u0012\u00020\r0\u00192\u0006\u0010*\u001a\u00020+2\f\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\r0V2\u0006\u0010\u0016\u001a\u00020\u0015H\u0002J\u0010\u0010W\u001a\u00020\r2\u0006\u0010X\u001a\u00020\rH\u0002J,\u0010Y\u001a\b\u0012\u0004\u0012\u00020\r0\u00192\f\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\r0V2\u0006\u0010Z\u001a\u00020\r2\u0006\u0010\u0016\u001a\u00020\u0015H\u0002J)\u0010[\u001a\u00020\u00152\b\b\u0002\u0010\\\u001a\u00020\u001c2\b\b\u0002\u0010]\u001a\u00020\u001c2\u0006\u0010\u0016\u001a\u00020\u0015H\u0000¢\u0006\u0002\b^J\u0016\u0010_\u001a\u00020`2\f\u00104\u001a\b\u0012\u0004\u0012\u00020\r0\u0019H\u0002J$\u0010a\u001a\b\u0012\u0004\u0012\u00020\r0\u00192\f\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\r0\u00192\u0006\u0010b\u001a\u00020\u0010H\u0002J&\u0010c\u001a\u00020\u00152\u0006\u0010d\u001a\u00020\r2\u0006\u0010\u0016\u001a\u00020\u00152\f\u0010e\u001a\b\u0012\u0004\u0012\u00020\r0VH\u0002R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006g"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/conversation/ConversationsListRepository;", "", "conversationKit", "Lzendesk/conversationkit/android/ConversationKit;", "defaultDispatcher", "Lkotlinx/coroutines/CoroutineDispatcher;", "mapper", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/ConversationLogEntryMapper;", "conversationsListInMemoryCache", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListInMemoryCache;", "(Lzendesk/conversationkit/android/ConversationKit;Lkotlinx/coroutines/CoroutineDispatcher;Lzendesk/messaging/android/internal/conversationslistscreen/conversation/ConversationLogEntryMapper;Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListInMemoryCache;)V", "addLoadMoreEntry", "Lkotlinx/collections/immutable/ImmutableList;", "Lzendesk/core/ui/android/internal/model/ConversationEntry;", "conversations", "loadMoreStatus", "Lzendesk/core/ui/android/internal/model/ConversationEntry$LoadMoreStatus;", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "addLoadMoreEntry$zendesk_messaging_messaging_android", "conversationsListStateChange", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenState;", "state", "conversationsListState", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListState;", "", "Lzendesk/conversationkit/android/model/Conversation;", "shouldLoadMore", "", "conversationsListStateChange$zendesk_messaging_messaging_android", "(Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenState;Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListState;Ljava/util/List;ZLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "createNewConversation", "Lzendesk/conversationkit/android/ConversationKitResult;", "createNewConversation$zendesk_messaging_messaging_android", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "evaluateLoadMoreStatusChange", "conversationEntries", "", "currentLoadMoreEntry", "Lzendesk/core/ui/android/internal/model/ConversationEntry$LoadMore;", "newLoadMoreEntry", "fetchConversation", "conversationId", "", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "fetchConversations", "Lzendesk/conversationkit/android/model/ConversationsPagination;", "offset", "", "fetchConversations$zendesk_messaging_messaging_android", "(ILkotlin/coroutines/Continuation;)Ljava/lang/Object;", "filterLoadMoreEntry", "mergeConversations", "getConversationsEntryList", "getConversationsEntryList$zendesk_messaging_messaging_android", "(Ljava/util/List;Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenState;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getConversationsUnreadCounterCurrentNumber", "getLatestConversationEntryUpdateWhetherShouldResetCount", "shouldResetCount", "updatedConversationEntryWithMessage", "handleConversationAdded", "conversation", "handleConversationAdded$zendesk_messaging_messaging_android", "(Lzendesk/conversationkit/android/model/Conversation;Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenState;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "handleConversationReadReceived", "handleConversationReadReceived$zendesk_messaging_messaging_android", "(Ljava/lang/String;Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenState;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "handleConversationRemoved", "handleConversationRemoved$zendesk_messaging_messaging_android", "handleMessageChanged", "message", "Lzendesk/conversationkit/android/model/Message;", "shouldIncreaseCount", "handleMessageChanged$zendesk_messaging_messaging_android", "(Ljava/lang/String;Lzendesk/conversationkit/android/model/Message;Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenState;ZZLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "handlePaginationUpdate", "handlePaginationUpdate$zendesk_messaging_messaging_android", "(Ljava/util/List;Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenState;ZLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "initialConversations", "paginatedConversations", "refreshConversationsList", "conversationsListScreenState", "updateStateIfFailed", "refreshConversationsList$zendesk_messaging_messaging_android", "(Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenState;ZILkotlin/coroutines/Continuation;)Ljava/lang/Object;", "removeExistingConversationEntryFromWebSocketEvent", "", "resetUnreadCounter", "updatedConversationEntry", "updateConversationEntriesFromWebSocketEvent", "updatedEntry", "updateCreateConversationState", "isSuccessful", "isLoading", "updateCreateConversationState$zendesk_messaging_messaging_android", "updateInMemoryConversations", "", "updateLoadMoreEntry", "status", "updateStateWithNewConversationEntryFromWebSocketEvent", "conversationEntry", "cachedConversations", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationsListRepository {
    private static final Companion Companion = new Companion(null);
    private static final String LOG_TAG = "ConversationsListRepository";
    private final ConversationKit conversationKit;
    private final ConversationsListInMemoryCache conversationsListInMemoryCache;
    private final CoroutineDispatcher defaultDispatcher;
    private final ConversationLogEntryMapper mapper;

    @Inject
    public ConversationsListRepository(ConversationKit conversationKit, @Named(CoroutineDispatchersModule.DEFAULT_DISPATCHER) CoroutineDispatcher defaultDispatcher, ConversationLogEntryMapper mapper, ConversationsListInMemoryCache conversationsListInMemoryCache) {
        Intrinsics.checkNotNullParameter(conversationKit, "conversationKit");
        Intrinsics.checkNotNullParameter(defaultDispatcher, "defaultDispatcher");
        Intrinsics.checkNotNullParameter(mapper, "mapper");
        Intrinsics.checkNotNullParameter(conversationsListInMemoryCache, "conversationsListInMemoryCache");
        this.conversationKit = conversationKit;
        this.defaultDispatcher = defaultDispatcher;
        this.mapper = mapper;
        this.conversationsListInMemoryCache = conversationsListInMemoryCache;
    }

    public final Object handleConversationRemoved$zendesk_messaging_messaging_android(String str, ConversationsListScreenState conversationsListScreenState, Continuation<? super ConversationsListScreenState> continuation) {
        Logger.m217d(LOG_TAG, "ConversationRemoved Event. Id = " + str, new Object[0]);
        return BuildersKt.withContext(this.defaultDispatcher, new ConversationsListRepository$handleConversationRemoved$2(conversationsListScreenState, this, str, null), continuation);
    }

    public final Object handleConversationAdded$zendesk_messaging_messaging_android(Conversation conversation, ConversationsListScreenState conversationsListScreenState, Continuation<? super ConversationsListScreenState> continuation) {
        Logger.m217d(LOG_TAG, "ConversationAdded Event. Id = " + conversation.getId(), new Object[0]);
        return BuildersKt.withContext(this.defaultDispatcher, new ConversationsListRepository$handleConversationAdded$2(this, conversation, conversationsListScreenState, null), continuation);
    }

    public final Object handleMessageChanged$zendesk_messaging_messaging_android(String str, Message message, ConversationsListScreenState conversationsListScreenState, boolean z, boolean z2, Continuation<? super ConversationsListScreenState> continuation) {
        Logger.m217d(LOG_TAG, "Message Changed Event received. Id = " + str, new Object[0]);
        return BuildersKt.withContext(this.defaultDispatcher, new ConversationsListRepository$handleMessageChanged$2(this, str, conversationsListScreenState, message, z, z2, null), continuation);
    }

    public final ConversationEntry getLatestConversationEntryUpdateWhetherShouldResetCount(boolean shouldResetCount, ConversationEntry updatedConversationEntryWithMessage) {
        return shouldResetCount ? resetUnreadCounter(updatedConversationEntryWithMessage) : updatedConversationEntryWithMessage;
    }

    public final int getConversationsUnreadCounterCurrentNumber(String conversationId) {
        ConversationEntry conversationById = this.conversationsListInMemoryCache.getConversationById(conversationId);
        if (conversationById == null) {
            return 0;
        }
        return ((ConversationEntry.ConversationItem) conversationById).getUnreadMessages();
    }

    public static Object m282xbcaadda2(ConversationsListRepository conversationsListRepository, ConversationsListScreenState conversationsListScreenState, boolean z, int i, Continuation continuation, int i2, Object obj) {
        if ((i2 & 2) != 0) {
            z = false;
        }
        if ((i2 & 4) != 0) {
            i = 0;
        }
        return conversationsListRepository.refreshConversationsList$zendesk_messaging_messaging_android(conversationsListScreenState, z, i, continuation);
    }

    public final Object refreshConversationsList$zendesk_messaging_messaging_android(ConversationsListScreenState conversationsListScreenState, boolean z, int i, Continuation<? super ConversationsListScreenState> continuation) throws Throwable {
        ConversationsListRepository$refreshConversationsList$1 conversationsListRepository$refreshConversationsList$1;
        ConversationsListScreenState conversationsListScreenState2;
        boolean z2;
        Object objFetchConversations$zendesk_messaging_messaging_android;
        ConversationsListRepository conversationsListRepository;
        ConversationKitResult conversationKitResult;
        ConversationsPagination conversationsPagination;
        Object objWithContext;
        ConversationsPagination conversationsPagination2;
        ConversationsListRepository conversationsListRepository2;
        if (continuation instanceof ConversationsListRepository$refreshConversationsList$1) {
            conversationsListRepository$refreshConversationsList$1 = (ConversationsListRepository$refreshConversationsList$1) continuation;
            if ((conversationsListRepository$refreshConversationsList$1.label & Integer.MIN_VALUE) != 0) {
                conversationsListRepository$refreshConversationsList$1.label -= Integer.MIN_VALUE;
            } else {
                conversationsListRepository$refreshConversationsList$1 = new ConversationsListRepository$refreshConversationsList$1(this, continuation);
            }
        } else {
            conversationsListRepository$refreshConversationsList$1 = new ConversationsListRepository$refreshConversationsList$1(this, continuation);
        }
        Object obj = conversationsListRepository$refreshConversationsList$1.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        ConversationsListScreenState conversationsListScreenState3 = conversationsListRepository$refreshConversationsList$1.label;
        try {
            if (conversationsListScreenState3 == 0) {
                ResultKt.throwOnFailure(obj);
                try {
                    conversationsListRepository$refreshConversationsList$1.L$0 = this;
                    conversationsListScreenState2 = conversationsListScreenState;
                    conversationsListRepository$refreshConversationsList$1.L$1 = conversationsListScreenState2;
                    z2 = z;
                    conversationsListRepository$refreshConversationsList$1.Z$0 = z2;
                    conversationsListRepository$refreshConversationsList$1.label = 1;
                    objFetchConversations$zendesk_messaging_messaging_android = fetchConversations$zendesk_messaging_messaging_android(i, conversationsListRepository$refreshConversationsList$1);
                    if (objFetchConversations$zendesk_messaging_messaging_android == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    conversationsListRepository = this;
                    conversationKitResult = (ConversationKitResult) objFetchConversations$zendesk_messaging_messaging_android;
                    if (conversationKitResult instanceof ConversationKitResult.Success) {
                        conversationsPagination = (ConversationsPagination) ((ConversationKitResult.Success) conversationKitResult).getValue();
                        List<Conversation> conversations = conversationsPagination.getConversations();
                        CoroutineDispatcher coroutineDispatcher = conversationsListRepository.defaultDispatcher;
                        C1492xcfd255d4 c1492xcfd255d4 = new C1492xcfd255d4(conversations, conversationsListRepository, conversationsListScreenState2, null);
                        conversationsListRepository$refreshConversationsList$1.L$0 = conversationsListRepository;
                        conversationsListRepository$refreshConversationsList$1.L$1 = conversationsListScreenState2;
                        conversationsListRepository$refreshConversationsList$1.L$2 = conversationsPagination;
                        conversationsListRepository$refreshConversationsList$1.label = 2;
                        objWithContext = BuildersKt.withContext(coroutineDispatcher, c1492xcfd255d4, conversationsListRepository$refreshConversationsList$1);
                        if (objWithContext == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        conversationsPagination2 = conversationsPagination;
                        obj = objWithContext;
                        conversationsListRepository2 = conversationsListRepository;
                    } else {
                        if (conversationKitResult instanceof ConversationKitResult.Failure) {
                            Logger.m219e(LOG_TAG, "Failure when refreshing conversations", new Object[0]);
                            if (z2) {
                                return ConversationsListStateHelperKt.errorState(((ConversationKitResult.Failure) conversationKitResult).getCause(), conversationsListScreenState2, ConversationsListState.FAILED_CONVERSATIONS);
                            }
                            return conversationsListScreenState2;
                        }
                        throw new NoWhenBranchMatchedException();
                    }
                } catch (Exception e) {
                    e = e;
                    conversationsListScreenState3 = conversationsListScreenState;
                    Logger.m219e(LOG_TAG, "Unexpected failure when refreshing conversations", new Object[0]);
                    return ConversationsListStateHelperKt.errorState(e, conversationsListScreenState3, ConversationsListState.FAILED_CONVERSATIONS);
                }
            } else if (conversationsListScreenState3 == 1) {
                boolean z3 = conversationsListRepository$refreshConversationsList$1.Z$0;
                ConversationsListScreenState conversationsListScreenState4 = (ConversationsListScreenState) conversationsListRepository$refreshConversationsList$1.L$1;
                conversationsListRepository = (ConversationsListRepository) conversationsListRepository$refreshConversationsList$1.L$0;
                try {
                    ResultKt.throwOnFailure(obj);
                    objFetchConversations$zendesk_messaging_messaging_android = obj;
                    z2 = z3;
                    conversationsListScreenState2 = conversationsListScreenState4;
                    conversationKitResult = (ConversationKitResult) objFetchConversations$zendesk_messaging_messaging_android;
                    if (conversationKitResult instanceof ConversationKitResult.Success) {
                        conversationsPagination = (ConversationsPagination) ((ConversationKitResult.Success) conversationKitResult).getValue();
                        List<Conversation> conversations2 = conversationsPagination.getConversations();
                        CoroutineDispatcher coroutineDispatcher2 = conversationsListRepository.defaultDispatcher;
                        C1492xcfd255d4 c1492xcfd255d5 = new C1492xcfd255d4(conversations2, conversationsListRepository, conversationsListScreenState2, null);
                        conversationsListRepository$refreshConversationsList$1.L$0 = conversationsListRepository;
                        conversationsListRepository$refreshConversationsList$1.L$1 = conversationsListScreenState2;
                        conversationsListRepository$refreshConversationsList$1.L$2 = conversationsPagination;
                        conversationsListRepository$refreshConversationsList$1.label = 2;
                        objWithContext = BuildersKt.withContext(coroutineDispatcher2, c1492xcfd255d5, conversationsListRepository$refreshConversationsList$1);
                        if (objWithContext == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        conversationsPagination2 = conversationsPagination;
                        obj = objWithContext;
                        conversationsListRepository2 = conversationsListRepository;
                    } else {
                        if (conversationKitResult instanceof ConversationKitResult.Failure) {
                            Logger.m219e(LOG_TAG, "Failure when refreshing conversations", new Object[0]);
                            if (z2) {
                                return ConversationsListStateHelperKt.errorState(((ConversationKitResult.Failure) conversationKitResult).getCause(), conversationsListScreenState2, ConversationsListState.FAILED_CONVERSATIONS);
                            }
                            return conversationsListScreenState2;
                        }
                        throw new NoWhenBranchMatchedException();
                    }
                } catch (Exception e2) {
                    e = e2;
                    conversationsListScreenState3 = conversationsListScreenState4;
                    Logger.m219e(LOG_TAG, "Unexpected failure when refreshing conversations", new Object[0]);
                    return ConversationsListStateHelperKt.errorState(e, conversationsListScreenState3, ConversationsListState.FAILED_CONVERSATIONS);
                }
            } else {
                if (conversationsListScreenState3 != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                conversationsPagination2 = (ConversationsPagination) conversationsListRepository$refreshConversationsList$1.L$2;
                conversationsListScreenState2 = (ConversationsListScreenState) conversationsListRepository$refreshConversationsList$1.L$1;
                conversationsListRepository2 = (ConversationsListRepository) conversationsListRepository$refreshConversationsList$1.L$0;
                ResultKt.throwOnFailure(obj);
            }
            conversationsListRepository2.updateInMemoryConversations(conversationsListRepository2.filterLoadMoreEntry(conversationsListRepository2.mergeConversations(conversationsListScreenState2.getConversations(), (List) obj)));
            return ConversationsListStateHelperKt.conversationsListWithListState$default(conversationsListScreenState2, ConversationsListState.SUCCESS, CollectionsKt.sortedWith(conversationsListRepository2.conversationsListInMemoryCache.conversations().values(), new Comparator() {
                @Override
                public final int compare(T t, T t2) {
                    return ComparisonsKt.compareValues(((ConversationEntry) t2).getDateTimeStamp(), ((ConversationEntry) t).getDateTimeStamp());
                }
            }), conversationsPagination2.getHasMore(), conversationsListRepository2.conversationsListInMemoryCache.conversations().values().size(), null, 32, null);
        } catch (Exception e3) {
            e = e3;
        }
    }

    public final Object m284x33d8f214(String str, ConversationsListScreenState conversationsListScreenState, Continuation<? super ConversationsListScreenState> continuation) {
        Logger.m217d(LOG_TAG, "Conversation Activity Read Event. Id = " + str, new Object[0]);
        return BuildersKt.withContext(this.defaultDispatcher, new ConversationsListRepository$handleConversationReadReceived$2(this, str, conversationsListScreenState, null), continuation);
    }

    public final ConversationEntry resetUnreadCounter(ConversationEntry updatedConversationEntry) {
        Intrinsics.checkNotNull(updatedConversationEntry, "null cannot be cast to non-null type zendesk.core.ui.android.internal.model.ConversationEntry.ConversationItem");
        ConversationEntry.ConversationItem conversationItem = (ConversationEntry.ConversationItem) updatedConversationEntry;
        return conversationItem.copy((1017 & 1) != 0 ? conversationItem.id : null, (1017 & 2) != 0 ? conversationItem.dateTimeStamp : null, (1017 & 4) != 0 ? conversationItem.formattedDateTimeStampString : null, (1017 & 8) != 0 ? conversationItem.participantName : null, (1017 & 16) != 0 ? conversationItem.conversationTitle : null, (1017 & 32) != 0 ? conversationItem.avatarUrl : null, (1017 & 64) != 0 ? conversationItem.latestMessage : null, (1017 & 128) != 0 ? conversationItem.latestMessageOwner : null, (1017 & 256) != 0 ? conversationItem.unreadMessages : 0, (1017 & 512) != 0 ? conversationItem.accessibilityTitle : null, (1017 & 1024) != 0 ? conversationItem.unreadMessagesColor : 0, (1017 & 2048) != 0 ? conversationItem.dateTimestampTextColor : 0, (1017 & 4096) != 0 ? conversationItem.lastMessageTextColor : 0, (1017 & 8192) != 0 ? conversationItem.conversationParticipantsTextColor : 0, (1017 & 16384) != 0 ? conversationItem.conversationTitleTextColor : 0);
    }

    public final void updateInMemoryConversations(List<? extends ConversationEntry> mergeConversations) {
        this.conversationsListInMemoryCache.clearAll();
        this.conversationsListInMemoryCache.updateConversations(mergeConversations);
    }

    private final List<ConversationEntry> updateConversationEntriesFromWebSocketEvent(Collection<? extends ConversationEntry> conversations, ConversationEntry updatedEntry, ConversationsListScreenState state) {
        ArrayList arrayList = new ArrayList();
        boolean z = false;
        for (ConversationEntry conversationEntry : conversations) {
            if (Intrinsics.areEqual(conversationEntry.getId(), updatedEntry.getId())) {
                arrayList.add(updatedEntry);
                z = true;
            } else {
                arrayList.add(this.mapper.m278x1003e355(conversationEntry, state.getMessagingTheme()));
            }
        }
        if (!z) {
            arrayList.add(updatedEntry);
        }
        if (arrayList.size() > 1) {
            CollectionsKt.sortWith(arrayList, new Comparator() {
                @Override
                public final int compare(T t, T t2) {
                    return ComparisonsKt.compareValues(((ConversationEntry) t2).getDateTimeStamp(), ((ConversationEntry) t).getDateTimeStamp());
                }
            });
        }
        return CollectionsKt.toList(arrayList);
    }

    public final List<ConversationEntry> removeExistingConversationEntryFromWebSocketEvent(String conversationId, Collection<? extends ConversationEntry> conversations, ConversationsListScreenState state) {
        ArrayList arrayList = new ArrayList();
        for (ConversationEntry conversationEntry : conversations) {
            if (!Intrinsics.areEqual(conversationEntry.getId(), conversationId)) {
                arrayList.add(this.mapper.m278x1003e355(conversationEntry, state.getMessagingTheme()));
            }
        }
        if (arrayList.size() > 1) {
            CollectionsKt.sortWith(arrayList, new Comparator() {
                @Override
                public final int compare(T t, T t2) {
                    return ComparisonsKt.compareValues(((ConversationEntry) t2).getDateTimeStamp(), ((ConversationEntry) t).getDateTimeStamp());
                }
            });
        }
        return CollectionsKt.toList(arrayList);
    }

    public final ConversationsListScreenState updateStateWithNewConversationEntryFromWebSocketEvent(ConversationEntry conversationEntry, ConversationsListScreenState state, Collection<? extends ConversationEntry> cachedConversations) {
        return ConversationsListStateHelperKt.conversationsList(state, ExtensionsKt.toImmutableList(updateConversationEntriesFromWebSocketEvent(cachedConversations, conversationEntry, state)));
    }

    public final Object fetchConversation(String str, Continuation<? super ConversationKitResult<Conversation>> continuation) {
        return this.conversationKit.getConversation(str, continuation);
    }

    public static Object fetchConversations$zendesk_messaging_messaging_android$default(ConversationsListRepository conversationsListRepository, int i, Continuation continuation, int i2, Object obj) {
        if ((i2 & 1) != 0) {
            i = 0;
        }
        return conversationsListRepository.fetchConversations$zendesk_messaging_messaging_android(i, continuation);
    }

    public final Object fetchConversations$zendesk_messaging_messaging_android(int i, Continuation<? super ConversationKitResult<ConversationsPagination>> continuation) {
        return ConversationKit.DefaultImpls.getConversations$default(this.conversationKit, i, false, continuation, 2, null);
    }

    public final Object getConversationsEntryList$zendesk_messaging_messaging_android(List<Conversation> list, ConversationsListScreenState conversationsListScreenState, Continuation<? super List<? extends ConversationEntry>> continuation) {
        return BuildersKt.withContext(this.defaultDispatcher, new ConversationsListRepository$getConversationsEntryList$2(list, this, conversationsListScreenState, null), continuation);
    }

    public final ImmutableList<ConversationEntry> addLoadMoreEntry$zendesk_messaging_messaging_android(ImmutableList<? extends ConversationEntry> conversations, ConversationEntry.LoadMoreStatus loadMoreStatus, MessagingTheme messagingTheme) {
        Intrinsics.checkNotNullParameter(conversations, "conversations");
        Intrinsics.checkNotNullParameter(loadMoreStatus, "loadMoreStatus");
        Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
        List<ConversationEntry> mutableList = CollectionsKt.toMutableList((Collection) conversations);
        ConversationEntry conversationEntryMapToLoadMoreEntry$zendesk_messaging_messaging_android = this.mapper.mapToLoadMoreEntry$zendesk_messaging_messaging_android(loadMoreStatus, messagingTheme);
        ImmutableList<? extends ConversationEntry> immutableList = conversations;
        ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(immutableList, 10));
        for (ConversationEntry conversationEntry : immutableList) {
            if (Intrinsics.areEqual(conversationEntryMapToLoadMoreEntry$zendesk_messaging_messaging_android.getId(), conversationEntry.getId()) && (conversationEntryMapToLoadMoreEntry$zendesk_messaging_messaging_android instanceof ConversationEntry.LoadMore) && (conversationEntry instanceof ConversationEntry.LoadMore)) {
                return evaluateLoadMoreStatusChange(mutableList, (ConversationEntry.LoadMore) conversationEntry, (ConversationEntry.LoadMore) conversationEntryMapToLoadMoreEntry$zendesk_messaging_messaging_android);
            }
            arrayList.add(Unit.INSTANCE);
        }
        if (loadMoreStatus != ConversationEntry.LoadMoreStatus.NONE) {
            mutableList.add(conversationEntryMapToLoadMoreEntry$zendesk_messaging_messaging_android);
        }
        return ExtensionsKt.toImmutableList(mutableList);
    }

    public final Object handlePaginationUpdate$zendesk_messaging_messaging_android(List<Conversation> list, ConversationsListScreenState conversationsListScreenState, boolean z, Continuation<? super ConversationsListScreenState> continuation) throws Throwable {
        ConversationsListRepository$handlePaginationUpdate$1 conversationsListRepository$handlePaginationUpdate$1;
        ConversationsListScreenState conversationsListScreenState2;
        boolean z2;
        ConversationsListRepository conversationsListRepository;
        if (continuation instanceof ConversationsListRepository$handlePaginationUpdate$1) {
            conversationsListRepository$handlePaginationUpdate$1 = (ConversationsListRepository$handlePaginationUpdate$1) continuation;
            if ((conversationsListRepository$handlePaginationUpdate$1.label & Integer.MIN_VALUE) != 0) {
                conversationsListRepository$handlePaginationUpdate$1.label -= Integer.MIN_VALUE;
            } else {
                conversationsListRepository$handlePaginationUpdate$1 = new ConversationsListRepository$handlePaginationUpdate$1(this, continuation);
            }
        } else {
            conversationsListRepository$handlePaginationUpdate$1 = new ConversationsListRepository$handlePaginationUpdate$1(this, continuation);
        }
        Object obj = conversationsListRepository$handlePaginationUpdate$1.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = conversationsListRepository$handlePaginationUpdate$1.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            conversationsListRepository$handlePaginationUpdate$1.L$0 = this;
            conversationsListRepository$handlePaginationUpdate$1.L$1 = conversationsListScreenState;
            conversationsListRepository$handlePaginationUpdate$1.Z$0 = z;
            conversationsListRepository$handlePaginationUpdate$1.label = 1;
            Object conversationsEntryList$zendesk_messaging_messaging_android = getConversationsEntryList$zendesk_messaging_messaging_android(list, conversationsListScreenState, conversationsListRepository$handlePaginationUpdate$1);
            if (conversationsEntryList$zendesk_messaging_messaging_android == coroutine_suspended) {
                return coroutine_suspended;
            }
            conversationsListScreenState2 = conversationsListScreenState;
            z2 = z;
            obj = conversationsEntryList$zendesk_messaging_messaging_android;
            conversationsListRepository = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            boolean z3 = conversationsListRepository$handlePaginationUpdate$1.Z$0;
            ConversationsListScreenState conversationsListScreenState3 = (ConversationsListScreenState) conversationsListRepository$handlePaginationUpdate$1.L$1;
            conversationsListRepository = (ConversationsListRepository) conversationsListRepository$handlePaginationUpdate$1.L$0;
            ResultKt.throwOnFailure(obj);
            z2 = z3;
            conversationsListScreenState2 = conversationsListScreenState3;
        }
        conversationsListRepository.conversationsListInMemoryCache.updateConversations(conversationsListRepository.filterLoadMoreEntry(conversationsListRepository.mergeConversations(conversationsListScreenState2.getConversations(), (List) obj)));
        return conversationsListScreenState2.copy((32639 & 1) != 0 ? conversationsListScreenState2.messagingTheme : null, (32639 & 2) != 0 ? conversationsListScreenState2.title : null, (32639 & 4) != 0 ? conversationsListScreenState2.description : null, (32639 & 8) != 0 ? conversationsListScreenState2.logoUrl : null, (32639 & 16) != 0 ? conversationsListScreenState2.isMultiConvoEnabled : false, (32639 & 32) != 0 ? conversationsListScreenState2.canUserCreateMoreConversations : false, (32639 & 64) != 0 ? conversationsListScreenState2.conversations : ExtensionsKt.toImmutableList(conversationsListRepository.conversationsListInMemoryCache.conversations().values()), (32639 & 128) != 0 ? conversationsListScreenState2.connectionStatus : null, (32639 & 256) != 0 ? conversationsListScreenState2.showDeniedPermission : false, (32639 & 512) != 0 ? conversationsListScreenState2.createConversationState : null, (32639 & 1024) != 0 ? conversationsListScreenState2.conversationsListState : null, (32639 & 2048) != 0 ? conversationsListScreenState2.shouldLoadMore : z2, (32639 & 4096) != 0 ? conversationsListScreenState2.currentPaginationOffset : conversationsListRepository.conversationsListInMemoryCache.conversations().size(), (32639 & 8192) != 0 ? conversationsListScreenState2.loadMoreStatus : null, (32639 & 16384) != 0 ? conversationsListScreenState2.receivedMessageAuthor : null);
    }

    private final List<ConversationEntry> mergeConversations(List<? extends ConversationEntry> initialConversations, List<? extends ConversationEntry> paginatedConversations) {
        return CollectionsKt.plus((Collection) initialConversations, (Iterable) paginatedConversations);
    }

    private final List<ConversationEntry> filterLoadMoreEntry(List<? extends ConversationEntry> mergeConversations) {
        ArrayList arrayList = new ArrayList();
        for (Object obj : mergeConversations) {
            if (!Intrinsics.areEqual(((ConversationEntry) obj).getId(), ConversationEntry.INSTANCE.getLOAD_MORE_ID())) {
                arrayList.add(obj);
            }
        }
        return arrayList;
    }

    public final Object conversationsListStateChange$zendesk_messaging_messaging_android(ConversationsListScreenState conversationsListScreenState, ConversationsListState conversationsListState, List<Conversation> list, boolean z, Continuation<? super ConversationsListScreenState> continuation) throws Throwable {
        ConversationsListRepository$conversationsListStateChange$1 conversationsListRepository$conversationsListStateChange$1;
        ConversationsListRepository conversationsListRepository;
        if (continuation instanceof ConversationsListRepository$conversationsListStateChange$1) {
            conversationsListRepository$conversationsListStateChange$1 = (ConversationsListRepository$conversationsListStateChange$1) continuation;
            if ((conversationsListRepository$conversationsListStateChange$1.label & Integer.MIN_VALUE) != 0) {
                conversationsListRepository$conversationsListStateChange$1.label -= Integer.MIN_VALUE;
            } else {
                conversationsListRepository$conversationsListStateChange$1 = new ConversationsListRepository$conversationsListStateChange$1(this, continuation);
            }
        } else {
            conversationsListRepository$conversationsListStateChange$1 = new ConversationsListRepository$conversationsListStateChange$1(this, continuation);
        }
        Object conversationsEntryList$zendesk_messaging_messaging_android = conversationsListRepository$conversationsListStateChange$1.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = conversationsListRepository$conversationsListStateChange$1.label;
        if (i == 0) {
            ResultKt.throwOnFailure(conversationsEntryList$zendesk_messaging_messaging_android);
            conversationsListRepository$conversationsListStateChange$1.L$0 = this;
            conversationsListRepository$conversationsListStateChange$1.L$1 = conversationsListScreenState;
            conversationsListRepository$conversationsListStateChange$1.L$2 = conversationsListState;
            conversationsListRepository$conversationsListStateChange$1.Z$0 = z;
            conversationsListRepository$conversationsListStateChange$1.label = 1;
            conversationsEntryList$zendesk_messaging_messaging_android = getConversationsEntryList$zendesk_messaging_messaging_android(list, conversationsListScreenState, conversationsListRepository$conversationsListStateChange$1);
            if (conversationsEntryList$zendesk_messaging_messaging_android == coroutine_suspended) {
                return coroutine_suspended;
            }
            conversationsListRepository = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            z = conversationsListRepository$conversationsListStateChange$1.Z$0;
            conversationsListState = (ConversationsListState) conversationsListRepository$conversationsListStateChange$1.L$2;
            conversationsListScreenState = (ConversationsListScreenState) conversationsListRepository$conversationsListStateChange$1.L$1;
            conversationsListRepository = (ConversationsListRepository) conversationsListRepository$conversationsListStateChange$1.L$0;
            ResultKt.throwOnFailure(conversationsEntryList$zendesk_messaging_messaging_android);
        }
        ConversationsListScreenState conversationsListScreenState2 = conversationsListScreenState;
        ConversationsListState conversationsListState2 = conversationsListState;
        boolean z2 = z;
        List<? extends ConversationEntry> list2 = (List) conversationsEntryList$zendesk_messaging_messaging_android;
        if (!list2.isEmpty()) {
            conversationsListRepository.conversationsListInMemoryCache.updateConversations(list2);
            return ConversationsListStateHelperKt.conversationsListWithListState$default(conversationsListScreenState2, conversationsListState2, list2, z2, 0, null, 48, null);
        }
        return ConversationsListStateHelperKt.listState(conversationsListScreenState2, conversationsListState2);
    }

    public static Object m281x1dfb23e2(ConversationsListRepository conversationsListRepository, ConversationsListScreenState conversationsListScreenState, ConversationsListState conversationsListState, List list, boolean z, Continuation continuation, int i, Object obj) {
        if ((i & 4) != 0) {
            list = CollectionsKt.emptyList();
        }
        List list2 = list;
        if ((i & 8) != 0) {
            z = false;
        }
        return conversationsListRepository.conversationsListStateChange$zendesk_messaging_messaging_android(conversationsListScreenState, conversationsListState, list2, z, continuation);
    }

    public final Object createNewConversation$zendesk_messaging_messaging_android(Continuation<? super ConversationKitResult<Conversation>> continuation) {
        return ConversationKit.DefaultImpls.createConversation$default(this.conversationKit, null, continuation, 1, null);
    }

    public static ConversationsListScreenState m283x91106a58(ConversationsListRepository conversationsListRepository, boolean z, boolean z2, ConversationsListScreenState conversationsListScreenState, int i, Object obj) {
        if ((i & 1) != 0) {
            z = false;
        }
        if ((i & 2) != 0) {
            z2 = false;
        }
        return conversationsListRepository.m285xeef42fbb(z, z2, conversationsListScreenState);
    }

    public final ConversationsListScreenState m285xeef42fbb(boolean isSuccessful, boolean isLoading, ConversationsListScreenState state) {
        CreateConversationState createConversationState;
        Intrinsics.checkNotNullParameter(state, "state");
        if (isSuccessful) {
            createConversationState = CreateConversationState.SUCCESS;
        } else if (isLoading) {
            createConversationState = CreateConversationState.LOADING;
        } else {
            createConversationState = CreateConversationState.FAILED;
        }
        return ConversationsListStateHelperKt.updateCreateConversationState(state, createConversationState);
    }

    private final ImmutableList<ConversationEntry> evaluateLoadMoreStatusChange(List<ConversationEntry> conversationEntries, ConversationEntry.LoadMore currentLoadMoreEntry, ConversationEntry.LoadMore newLoadMoreEntry) {
        if (newLoadMoreEntry.getStatus() != currentLoadMoreEntry.getStatus()) {
            conversationEntries = updateLoadMoreEntry(conversationEntries, newLoadMoreEntry.getStatus());
        }
        return ExtensionsKt.toImmutableList(conversationEntries);
    }

    private final List<ConversationEntry> updateLoadMoreEntry(List<? extends ConversationEntry> conversations, ConversationEntry.LoadMoreStatus status) {
        List<? extends ConversationEntry> list = conversations;
        ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(list, 10));
        for (ConversationEntry.LoadMore loadMoreCopy$default : list) {
            if (loadMoreCopy$default instanceof ConversationEntry.LoadMore) {
                loadMoreCopy$default = ConversationEntry.LoadMore.copy$default((ConversationEntry.LoadMore) loadMoreCopy$default, null, 0, 0, status, null, 23, null);
            }
            arrayList.add(loadMoreCopy$default);
        }
        return arrayList;
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0005"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/conversation/ConversationsListRepository$Companion;", "", "()V", "LOG_TAG", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
