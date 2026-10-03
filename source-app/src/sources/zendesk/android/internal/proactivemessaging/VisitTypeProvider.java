package zendesk.android.internal.proactivemessaging;

import javax.inject.Inject;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt__Builders_commonKt;
import kotlinx.coroutines.CoroutineScope;
import zendesk.android.internal.p013di.ZendeskInitializedComponentScope;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.conversationkit.android.ConversationKitResult;
import zendesk.conversationkit.android.model.VisitType;
import zendesk.logger.Logger;

@ZendeskInitializedComponentScope
@Metadata(m17d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0001\u0018\u0000 \f2\u00020\u0001:\u0001\fB\u0017\b\u0001\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006R\u001e\u0010\t\u001a\u00020\b2\u0006\u0010\u0007\u001a\u00020\b@BX\u0080.¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000b¨\u0006\r"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/VisitTypeProvider;", "", "conversationKit", "Lzendesk/conversationkit/android/ConversationKit;", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "(Lzendesk/conversationkit/android/ConversationKit;Lkotlinx/coroutines/CoroutineScope;)V", "<set-?>", "Lzendesk/conversationkit/android/model/VisitType;", "visitType", "getVisitType$zendesk_zendesk_android", "()Lzendesk/conversationkit/android/model/VisitType;", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class VisitTypeProvider {
    public static final String LOG_TAG = "VisitTypeRepository";
    private VisitType visitType;

    @Inject
    public VisitTypeProvider(ConversationKit conversationKit, CoroutineScope coroutineScope) {
        Intrinsics.checkNotNullParameter(conversationKit, "conversationKit");
        Intrinsics.checkNotNullParameter(coroutineScope, "coroutineScope");
        BuildersKt__Builders_commonKt.launch$default(coroutineScope, null, null, new C09741(conversationKit, null), 3, null);
    }

    public final VisitType getVisitType$zendesk_zendesk_android() {
        VisitType visitType = this.visitType;
        if (visitType != null) {
            return visitType;
        }
        Intrinsics.throwUninitializedPropertyAccessException("visitType");
        return null;
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.internal.proactivemessaging.VisitTypeProvider$1", m37f = "VisitTypeProvider.kt", m38i = {}, m39l = {40, 48}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C09741 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final ConversationKit $conversationKit;
        Object L$0;
        int label;

        C09741(ConversationKit conversationKit, Continuation<? super C09741> continuation) {
            super(2, continuation);
            this.$conversationKit = conversationKit;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return VisitTypeProvider.this.new C09741(this.$conversationKit, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C09741) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            VisitTypeProvider visitTypeProvider;
            VisitType visitType;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                visitTypeProvider = VisitTypeProvider.this;
                this.L$0 = visitTypeProvider;
                this.label = 1;
                obj = this.$conversationKit.getVisitType(this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i == 1) {
                    visitTypeProvider = (VisitTypeProvider) this.L$0;
                    ResultKt.throwOnFailure(obj);
                } else {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                return Unit.INSTANCE;
            }
            ConversationKitResult conversationKitResult = (ConversationKitResult) obj;
            if (conversationKitResult instanceof ConversationKitResult.Failure) {
                Logger.m218e(VisitTypeProvider.LOG_TAG, "Failure getting visit type ", ((ConversationKitResult.Failure) conversationKitResult).getCause(), new Object[0]);
                visitType = VisitType.NEW;
            } else {
                if (!(conversationKitResult instanceof ConversationKitResult.Success)) {
                    throw new NoWhenBranchMatchedException();
                }
                visitType = (VisitType) ((ConversationKitResult.Success) conversationKitResult).getValue();
            }
            visitTypeProvider.visitType = visitType;
            this.L$0 = null;
            this.label = 2;
            if (this.$conversationKit.setVisitType(VisitType.REPEAT, this) == coroutine_suspended) {
                return coroutine_suspended;
            }
            return Unit.INSTANCE;
        }
    }
}
