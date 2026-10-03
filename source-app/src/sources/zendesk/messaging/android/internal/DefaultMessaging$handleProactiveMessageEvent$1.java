package zendesk.messaging.android.internal;

import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;
import okhttp3.internal.http.StatusLine;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.conversationkit.android.ConversationKitEvent;
import zendesk.conversationkit.android.ConversationKitResult;
import zendesk.conversationkit.android.model.ProactiveMessage;
import zendesk.conversationkit.android.model.ProactiveMessageStatus;
import zendesk.logger.Logger;
import zendesk.messaging.android.internal.proactivemessaging.ProactiveMessageEvent;

@Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.messaging.android.internal.DefaultMessaging$handleProactiveMessageEvent$1", m37f = "DefaultMessaging.kt", m38i = {}, m39l = {306, StatusLine.HTTP_PERM_REDIRECT, 325}, m40m = "invokeSuspend", m41n = {}, m42s = {})
final class DefaultMessaging$handleProactiveMessageEvent$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final ProactiveMessageEvent $event;
    final Integer $proactiveMessageId;
    Object L$0;
    Object L$1;
    int label;
    final DefaultMessaging this$0;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[ProactiveMessageEvent.values().length];
            try {
                iArr[ProactiveMessageEvent.CONVERSATION_OPENED.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[ProactiveMessageEvent.REPLIED_TO.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    DefaultMessaging$handleProactiveMessageEvent$1(Integer num, DefaultMessaging defaultMessaging, ProactiveMessageEvent proactiveMessageEvent, Continuation<? super DefaultMessaging$handleProactiveMessageEvent$1> continuation) {
        super(2, continuation);
        this.$proactiveMessageId = num;
        this.this$0 = defaultMessaging;
        this.$event = proactiveMessageEvent;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new DefaultMessaging$handleProactiveMessageEvent$1(this.$proactiveMessageId, this.this$0, this.$event, continuation);
    }

    @Override
    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return ((DefaultMessaging$handleProactiveMessageEvent$1) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        ConversationKitResult conversationKitResult;
        ProactiveMessage proactiveMessage;
        ConversationKit conversationKit;
        int i;
        ConversationKitEvent.ProactiveMessageStatusChanged proactiveMessageStatusChanged;
        DefaultMessaging defaultMessaging;
        Integer num;
        ConversationKit conversationKit2;
        ConversationKitEvent.ProactiveMessageStatusChanged proactiveMessageStatusChanged2;
        ConversationKitEvent.ProactiveMessageStatusChanged proactiveMessageStatusChanged3;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i2 = this.label;
        if (i2 == 0) {
            ResultKt.throwOnFailure(obj);
            if (this.$proactiveMessageId == null) {
                this.label = 1;
                if (DefaultMessaging.clearRemainingProactiveMessages$default(this.this$0, null, this, 1, null) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                this.label = 2;
                obj = this.this$0.conversationKit.getProactiveMessage(this.$proactiveMessageId.intValue(), this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversationKitResult = (ConversationKitResult) obj;
                if (conversationKitResult instanceof ConversationKitResult.Failure) {
                    Logger.m219e(DefaultMessaging.LOG_TAG, "Failed to retrieve proactive message " + this.$proactiveMessageId + " from conversation kit", new Object[0]);
                } else if (conversationKitResult instanceof ConversationKitResult.Success) {
                    proactiveMessage = (ProactiveMessage) ((ConversationKitResult.Success) conversationKitResult).getValue();
                    conversationKit = this.this$0.conversationKit;
                    i = WhenMappings.$EnumSwitchMapping$0[this.$event.ordinal()];
                    if (i != 1) {
                        proactiveMessageStatusChanged = new ConversationKitEvent.ProactiveMessageStatusChanged(new ProactiveMessageStatus.NotificationHasBeenClicked(proactiveMessage));
                        defaultMessaging = this.this$0;
                        num = this.$proactiveMessageId;
                        this.L$0 = proactiveMessageStatusChanged;
                        this.L$1 = conversationKit;
                        this.label = 3;
                        if (defaultMessaging.clearRemainingProactiveMessages(num, this) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        conversationKit2 = conversationKit;
                        proactiveMessageStatusChanged2 = proactiveMessageStatusChanged;
                        ConversationKitEvent.ProactiveMessageStatusChanged proactiveMessageStatusChanged4 = proactiveMessageStatusChanged2;
                        conversationKit = conversationKit2;
                        proactiveMessageStatusChanged3 = proactiveMessageStatusChanged4;
                    } else {
                        if (i == 2) {
                            throw new NoWhenBranchMatchedException();
                        }
                        proactiveMessageStatusChanged3 = new ConversationKitEvent.ProactiveMessageStatusChanged(new ProactiveMessageStatus.ConversationHasBeenRepliedTo(proactiveMessage));
                    }
                    conversationKit.dispatchEvent(proactiveMessageStatusChanged3);
                }
            }
        } else if (i2 != 1) {
            if (i2 == 2) {
                ResultKt.throwOnFailure(obj);
                conversationKitResult = (ConversationKitResult) obj;
                if (conversationKitResult instanceof ConversationKitResult.Failure) {
                    Logger.m219e(DefaultMessaging.LOG_TAG, "Failed to retrieve proactive message " + this.$proactiveMessageId + " from conversation kit", new Object[0]);
                } else if (conversationKitResult instanceof ConversationKitResult.Success) {
                    proactiveMessage = (ProactiveMessage) ((ConversationKitResult.Success) conversationKitResult).getValue();
                    conversationKit = this.this$0.conversationKit;
                    i = WhenMappings.$EnumSwitchMapping$0[this.$event.ordinal()];
                    if (i != 1) {
                        proactiveMessageStatusChanged = new ConversationKitEvent.ProactiveMessageStatusChanged(new ProactiveMessageStatus.NotificationHasBeenClicked(proactiveMessage));
                        defaultMessaging = this.this$0;
                        num = this.$proactiveMessageId;
                        this.L$0 = proactiveMessageStatusChanged;
                        this.L$1 = conversationKit;
                        this.label = 3;
                        if (defaultMessaging.clearRemainingProactiveMessages(num, this) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        conversationKit2 = conversationKit;
                        proactiveMessageStatusChanged2 = proactiveMessageStatusChanged;
                    } else {
                        if (i == 2) {
                            throw new NoWhenBranchMatchedException();
                        }
                        proactiveMessageStatusChanged3 = new ConversationKitEvent.ProactiveMessageStatusChanged(new ProactiveMessageStatus.ConversationHasBeenRepliedTo(proactiveMessage));
                    }
                    conversationKit.dispatchEvent(proactiveMessageStatusChanged3);
                }
            } else {
                if (i2 != 3) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                conversationKit2 = (ConversationKit) this.L$1;
                proactiveMessageStatusChanged2 = (ConversationKitEvent.ProactiveMessageStatusChanged) this.L$0;
                ResultKt.throwOnFailure(obj);
            }
            ConversationKitEvent.ProactiveMessageStatusChanged proactiveMessageStatusChanged5 = proactiveMessageStatusChanged2;
            conversationKit = conversationKit2;
            proactiveMessageStatusChanged3 = proactiveMessageStatusChanged5;
            conversationKit.dispatchEvent(proactiveMessageStatusChanged3);
        } else {
            ResultKt.throwOnFailure(obj);
        }
        return Unit.INSTANCE;
    }
}
