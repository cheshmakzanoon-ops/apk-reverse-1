package zendesk.messaging.android.internal.messagingscreen;

import java.util.List;
import javax.inject.Inject;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.ResultKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.conversationkit.android.ConversationKitResult;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.ConversationsPagination;

@Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\b\u0000\u0018\u00002\u00020\u0001B\u0017\b\u0007\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u000e\u0010\u0007\u001a\u00020\bH\u0086@¢\u0006\u0002\u0010\tJ\u000e\u0010\n\u001a\u00020\u000bH\u0086@¢\u0006\u0002\u0010\tR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\f"}, m18d2 = {"Lzendesk/messaging/android/internal/messagingscreen/BackNavigationResolver;", "", "conversationKit", "Lzendesk/conversationkit/android/ConversationKit;", "messagingSettings", "Lzendesk/android/messaging/model/MessagingSettings;", "(Lzendesk/conversationkit/android/ConversationKit;Lzendesk/android/messaging/model/MessagingSettings;)V", "resolveBackNavigation", "Lzendesk/messaging/android/internal/messagingscreen/MessagingFragmentScreen;", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "shouldGoToConversationListScreen", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class BackNavigationResolver {
    private final ConversationKit conversationKit;
    private final MessagingSettings messagingSettings;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.messagingscreen.BackNavigationResolver", m37f = "BackNavigationResolver.kt", m38i = {0, 0}, m39l = {39}, m40m = "resolveBackNavigation", m41n = {"canUserSeeConversationList", "canUserCreateMoreConversations"}, m42s = {"Z$0", "Z$1"})
    static final class C15101 extends ContinuationImpl {
        boolean Z$0;
        boolean Z$1;
        int label;
        Object result;

        C15101(Continuation<? super C15101> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return BackNavigationResolver.this.resolveBackNavigation(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.messagingscreen.BackNavigationResolver", m37f = "BackNavigationResolver.kt", m38i = {}, m39l = {26}, m40m = "shouldGoToConversationListScreen", m41n = {}, m42s = {})
    static final class C15111 extends ContinuationImpl {
        int label;
        Object result;

        C15111(Continuation<? super C15111> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return BackNavigationResolver.this.shouldGoToConversationListScreen(this);
        }
    }

    @Inject
    public BackNavigationResolver(ConversationKit conversationKit, MessagingSettings messagingSettings) {
        Intrinsics.checkNotNullParameter(conversationKit, "conversationKit");
        Intrinsics.checkNotNullParameter(messagingSettings, "messagingSettings");
        this.conversationKit = conversationKit;
        this.messagingSettings = messagingSettings;
    }

    public final Object shouldGoToConversationListScreen(Continuation<? super Boolean> continuation) throws Throwable {
        C15111 c15111;
        if (continuation instanceof C15111) {
            c15111 = (C15111) continuation;
            if ((c15111.label & Integer.MIN_VALUE) != 0) {
                c15111.label -= Integer.MIN_VALUE;
            } else {
                c15111 = new C15111(continuation);
            }
        } else {
            c15111 = new C15111(continuation);
        }
        Object objResolveBackNavigation = c15111.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c15111.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objResolveBackNavigation);
            c15111.label = 1;
            objResolveBackNavigation = resolveBackNavigation(c15111);
            if (objResolveBackNavigation == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(objResolveBackNavigation);
        }
        return Boxing.boxBoolean(Intrinsics.areEqual(objResolveBackNavigation, MessagingFragmentScreen.ConversationListFragmentScreen.INSTANCE));
    }

    public final Object resolveBackNavigation(Continuation<? super MessagingFragmentScreen> continuation) throws Throwable {
        C15101 c15101;
        boolean z;
        boolean z2;
        if (continuation instanceof C15101) {
            c15101 = (C15101) continuation;
            if ((c15101.label & Integer.MIN_VALUE) != 0) {
                c15101.label -= Integer.MIN_VALUE;
            } else {
                c15101 = new C15101(continuation);
            }
        } else {
            c15101 = new C15101(continuation);
        }
        C15101 c15102 = c15101;
        Object conversations$default = c15102.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c15102.label;
        if (i == 0) {
            ResultKt.throwOnFailure(conversations$default);
            boolean zIsMultiConversationsEnabled = this.messagingSettings.isMultiConversationsEnabled();
            boolean canUserSeeConversationList = this.messagingSettings.getCanUserSeeConversationList();
            boolean canUserCreateMoreConversations = this.messagingSettings.getCanUserCreateMoreConversations();
            if (!zIsMultiConversationsEnabled) {
                return MessagingFragmentScreen.MainAppScreen.INSTANCE;
            }
            ConversationKit conversationKit = this.conversationKit;
            c15102.Z$0 = canUserSeeConversationList;
            c15102.Z$1 = canUserCreateMoreConversations;
            c15102.label = 1;
            conversations$default = ConversationKit.DefaultImpls.getConversations$default(conversationKit, 0, true, c15102, 1, null);
            if (conversations$default == coroutine_suspended) {
                return coroutine_suspended;
            }
            z = canUserSeeConversationList;
            z2 = canUserCreateMoreConversations;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            z2 = c15102.Z$1;
            z = c15102.Z$0;
            ResultKt.throwOnFailure(conversations$default);
        }
        ConversationKitResult conversationKitResult = (ConversationKitResult) conversations$default;
        if (conversationKitResult instanceof ConversationKitResult.Success) {
            List<Conversation> conversations = ((ConversationsPagination) ((ConversationKitResult.Success) conversationKitResult).getValue()).getConversations();
            if (!z) {
                return MessagingFragmentScreen.MainAppScreen.INSTANCE;
            }
            if (z2) {
                return MessagingFragmentScreen.ConversationListFragmentScreen.INSTANCE;
            }
            return conversations.size() == 1 ? MessagingFragmentScreen.MainAppScreen.INSTANCE : MessagingFragmentScreen.ConversationListFragmentScreen.INSTANCE;
        }
        if (conversationKitResult instanceof ConversationKitResult.Failure) {
            return MessagingFragmentScreen.MainAppScreen.INSTANCE;
        }
        throw new NoWhenBranchMatchedException();
    }
}
