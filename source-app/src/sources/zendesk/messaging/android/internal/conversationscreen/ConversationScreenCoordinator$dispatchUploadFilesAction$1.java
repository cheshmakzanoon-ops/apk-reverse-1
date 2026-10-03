package zendesk.messaging.android.internal.conversationscreen;

import java.util.List;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;
import zendesk.messaging.android.internal.model.UploadFile;

@Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenCoordinator$dispatchUploadFilesAction$1", m37f = "ConversationScreenCoordinator.kt", m38i = {}, m39l = {444}, m40m = "invokeSuspend", m41n = {}, m42s = {})
final class ConversationScreenCoordinator$dispatchUploadFilesAction$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final List<UploadFile> $uploads;
    Object L$0;
    int label;
    final ConversationScreenCoordinator this$0;

    ConversationScreenCoordinator$dispatchUploadFilesAction$1(List<UploadFile> list, ConversationScreenCoordinator conversationScreenCoordinator, Continuation<? super ConversationScreenCoordinator$dispatchUploadFilesAction$1> continuation) {
        super(2, continuation);
        this.$uploads = list;
        this.this$0 = conversationScreenCoordinator;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new ConversationScreenCoordinator$dispatchUploadFilesAction$1(this.$uploads, this.this$0, continuation);
    }

    @Override
    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return ((ConversationScreenCoordinator$dispatchUploadFilesAction$1) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        List<UploadFile> list;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            List<UploadFile> list2 = this.$uploads;
            this.L$0 = list2;
            this.label = 1;
            Object objConversationId$zendesk_messaging_messaging_android = this.this$0.conversationScreenViewModel.conversationId$zendesk_messaging_messaging_android(this);
            if (objConversationId$zendesk_messaging_messaging_android == coroutine_suspended) {
                return coroutine_suspended;
            }
            list = list2;
            obj = objConversationId$zendesk_messaging_messaging_android;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            list = (List) this.L$0;
            ResultKt.throwOnFailure(obj);
        }
        this.this$0.conversationScreenViewModel.dispatchAction(new ConversationScreenAction.UploadFiles(list, (String) obj));
        return Unit.INSTANCE;
    }
}
