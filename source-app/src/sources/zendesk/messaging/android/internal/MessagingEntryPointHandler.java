package zendesk.messaging.android.internal;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import javax.inject.Inject;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.ResultKt;
import kotlin.collections.CollectionsKt;
import kotlin.comparisons.ComparisonsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.internal.Intrinsics;
import net.aihelp.data.model.p005cs.ConversationMsg;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.conversationkit.android.ConversationKitResult;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.ConversationStatus;
import zendesk.conversationkit.android.model.ConversationsPagination;
import zendesk.conversationkit.android.model.User;
import zendesk.messaging.android.internal.messagingscreen.MessagingFragmentScreen;

@Metadata(m17d1 = {"\u00008\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u0000 \u00142\u00020\u0001:\u0001\u0014B\u0017\b\u0007\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J&\u0010\u0007\u001a\u00020\b2\f\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u000b0\n2\u0006\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\rH\u0002J\u000e\u0010\u000f\u001a\u00020\bH\u0086@¢\u0006\u0002\u0010\u0010J\u001c\u0010\u0011\u001a\u0004\u0018\u00010\u000b*\b\u0012\u0004\u0012\u00020\u000b0\n2\u0006\u0010\u0012\u001a\u00020\u0013H\u0002R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0015"}, m18d2 = {"Lzendesk/messaging/android/internal/MessagingEntryPointHandler;", "", "conversationKit", "Lzendesk/conversationkit/android/ConversationKit;", "messagingSettings", "Lzendesk/android/messaging/model/MessagingSettings;", "(Lzendesk/conversationkit/android/ConversationKit;Lzendesk/android/messaging/model/MessagingSettings;)V", "handleSuccess", "Lzendesk/messaging/android/internal/messagingscreen/MessagingFragmentScreen;", "conversations", "", "Lzendesk/conversationkit/android/model/Conversation;", "canUserSeeConversationList", "", "canUserCreateMoreConversations", "resolveEntryPoint", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "latestUpdatedTopConversation", "status", "Lzendesk/conversationkit/android/model/ConversationStatus;", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessagingEntryPointHandler {
    public static final int ONE_CONVERSATION = 1;
    public static final int TEN_FIRST_TOP_CONVERSATIONS = 10;
    private final ConversationKit conversationKit;
    private final MessagingSettings messagingSettings;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.MessagingEntryPointHandler", m37f = "MessagingEntryPointHandler.kt", m38i = {0, 1}, m39l = {32, ConversationMsg.TYPE_TIMESTAMP}, m40m = "resolveEntryPoint", m41n = {"this", "this"}, m42s = {"L$0", "L$0"})
    static final class C12691 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C12691(Continuation<? super C12691> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return MessagingEntryPointHandler.this.resolveEntryPoint(this);
        }
    }

    @Inject
    public MessagingEntryPointHandler(ConversationKit conversationKit, MessagingSettings messagingSettings) {
        Intrinsics.checkNotNullParameter(conversationKit, "conversationKit");
        Intrinsics.checkNotNullParameter(messagingSettings, "messagingSettings");
        this.conversationKit = conversationKit;
        this.messagingSettings = messagingSettings;
    }

    public final Object resolveEntryPoint(Continuation<? super MessagingFragmentScreen> continuation) throws Throwable {
        C12691 c12691;
        MessagingEntryPointHandler messagingEntryPointHandler;
        MessagingEntryPointHandler messagingEntryPointHandler2;
        ConversationKitResult conversationKitResult;
        if (continuation instanceof C12691) {
            c12691 = (C12691) continuation;
            if ((c12691.label & Integer.MIN_VALUE) != 0) {
                c12691.label -= Integer.MIN_VALUE;
            } else {
                c12691 = new C12691(continuation);
            }
        } else {
            c12691 = new C12691(continuation);
        }
        C12691 c12692 = c12691;
        Object currentUser = c12692.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c12692.label;
        if (i != 0) {
            if (i == 1) {
                MessagingEntryPointHandler messagingEntryPointHandler3 = (MessagingEntryPointHandler) c12692.L$0;
                ResultKt.throwOnFailure(currentUser);
                messagingEntryPointHandler = messagingEntryPointHandler3;
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                messagingEntryPointHandler2 = (MessagingEntryPointHandler) c12692.L$0;
                ResultKt.throwOnFailure(currentUser);
            }
            conversationKitResult = (ConversationKitResult) currentUser;
            if (conversationKitResult instanceof ConversationKitResult.Success) {
                return messagingEntryPointHandler2.handleSuccess(((ConversationsPagination) ((ConversationKitResult.Success) conversationKitResult).getValue()).getConversations(), messagingEntryPointHandler2.messagingSettings.getCanUserSeeConversationList(), messagingEntryPointHandler2.messagingSettings.getCanUserCreateMoreConversations());
            }
            if (conversationKitResult instanceof ConversationKitResult.Failure) {
                return new MessagingFragmentScreen.FailedResolvedFragmentScreen(((ConversationKitResult.Failure) conversationKitResult).getCause());
            }
            throw new NoWhenBranchMatchedException();
        }
        ResultKt.throwOnFailure(currentUser);
        ConversationKit conversationKit = this.conversationKit;
        c12692.L$0 = this;
        c12692.label = 1;
        currentUser = conversationKit.getCurrentUser(c12692);
        if (currentUser == coroutine_suspended) {
            return coroutine_suspended;
        }
        messagingEntryPointHandler = this;
        User user = (User) currentUser;
        if (!messagingEntryPointHandler.messagingSettings.isMultiConversationsEnabled() || user == null) {
            return new MessagingFragmentScreen.ConversationFragmentScreen(null, null, 3, null);
        }
        ConversationKit conversationKit2 = messagingEntryPointHandler.conversationKit;
        c12692.L$0 = messagingEntryPointHandler;
        c12692.label = 2;
        currentUser = ConversationKit.DefaultImpls.getConversations$default(conversationKit2, 0, false, c12692, 3, null);
        if (currentUser == coroutine_suspended) {
            return coroutine_suspended;
        }
        messagingEntryPointHandler2 = messagingEntryPointHandler;
        conversationKitResult = (ConversationKitResult) currentUser;
        if (conversationKitResult instanceof ConversationKitResult.Success) {
            return messagingEntryPointHandler2.handleSuccess(((ConversationsPagination) ((ConversationKitResult.Success) conversationKitResult).getValue()).getConversations(), messagingEntryPointHandler2.messagingSettings.getCanUserSeeConversationList(), messagingEntryPointHandler2.messagingSettings.getCanUserCreateMoreConversations());
        }
        if (conversationKitResult instanceof ConversationKitResult.Failure) {
            return new MessagingFragmentScreen.FailedResolvedFragmentScreen(((ConversationKitResult.Failure) conversationKitResult).getCause());
        }
        throw new NoWhenBranchMatchedException();
    }

    private final MessagingFragmentScreen handleSuccess(List<Conversation> conversations, boolean canUserSeeConversationList, boolean canUserCreateMoreConversations) {
        if (conversations.isEmpty()) {
            return new MessagingFragmentScreen.ConversationFragmentScreen(null, null, 3, null);
        }
        Conversation conversationLatestUpdatedTopConversation = latestUpdatedTopConversation(conversations, ConversationStatus.ACTIVE);
        if (conversationLatestUpdatedTopConversation != null) {
            return new MessagingFragmentScreen.ConversationFragmentScreen(conversationLatestUpdatedTopConversation.getId(), null, 2, null);
        }
        if (!canUserSeeConversationList) {
            Conversation conversationLatestUpdatedTopConversation2 = latestUpdatedTopConversation(conversations, ConversationStatus.IDLE);
            return new MessagingFragmentScreen.ConversationFragmentScreen(conversationLatestUpdatedTopConversation2 != null ? conversationLatestUpdatedTopConversation2.getId() : null, null, 2, null);
        }
        if (canUserCreateMoreConversations) {
            return MessagingFragmentScreen.ConversationListFragmentScreen.INSTANCE;
        }
        if (conversations.size() == 1) {
            Conversation conversationLatestUpdatedTopConversation3 = latestUpdatedTopConversation(conversations, ConversationStatus.IDLE);
            return new MessagingFragmentScreen.ConversationFragmentScreen(conversationLatestUpdatedTopConversation3 != null ? conversationLatestUpdatedTopConversation3.getId() : null, null, 2, null);
        }
        return MessagingFragmentScreen.ConversationListFragmentScreen.INSTANCE;
    }

    private final Conversation latestUpdatedTopConversation(List<Conversation> list, ConversationStatus conversationStatus) {
        ArrayList arrayList = new ArrayList();
        for (Object obj : list) {
            if (((Conversation) obj).getStatus() == conversationStatus) {
                arrayList.add(obj);
            }
        }
        return (Conversation) CollectionsKt.firstOrNull(CollectionsKt.take(CollectionsKt.sortedWith(arrayList, new Comparator() {
            @Override
            public final int compare(T t, T t2) {
                return ComparisonsKt.compareValues(((Conversation) t2).getLastUpdatedAt(), ((Conversation) t).getLastUpdatedAt());
            }
        }), 10));
    }
}
