package zendesk.conversationkit.android.internal.attachments;

import java.io.File;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;
import zendesk.conversationkit.android.internal.Action;
import zendesk.conversationkit.android.model.attachments.DownloadAttachmentStatus;

@Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.conversationkit.android.internal.attachments.AttachmentsDownloadReceiver$dispatchDownloadSuccessful$1$1", m37f = "AttachmentsDownloadReceiver.kt", m38i = {}, m39l = {125}, m40m = "invokeSuspend", m41n = {}, m42s = {})
final class AttachmentsDownloadReceiver$dispatchDownloadSuccessful$1$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final String $conversationId;
    final File $file;
    final String $filePath;
    final String $messageId;
    int label;
    final AttachmentsDownloadReceiver this$0;

    AttachmentsDownloadReceiver$dispatchDownloadSuccessful$1$1(AttachmentsDownloadReceiver attachmentsDownloadReceiver, File file, String str, String str2, String str3, Continuation<? super AttachmentsDownloadReceiver$dispatchDownloadSuccessful$1$1> continuation) {
        super(2, continuation);
        this.this$0 = attachmentsDownloadReceiver;
        this.$file = file;
        this.$filePath = str;
        this.$messageId = str2;
        this.$conversationId = str3;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new AttachmentsDownloadReceiver$dispatchDownloadSuccessful$1$1(this.this$0, this.$file, this.$filePath, this.$messageId, this.$conversationId, continuation);
    }

    @Override
    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return ((AttachmentsDownloadReceiver$dispatchDownloadSuccessful$1$1) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            this.label = 1;
            if (this.this$0._attachmentChannel.send(new Action.UpdateDownloadStatusAction(new DownloadAttachmentStatus.DownloadAttachmentSuccess(this.$file, this.this$0.retrieveFilename(this.$filePath), this.$messageId, this.$conversationId)), this) == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        return Unit.INSTANCE;
    }
}
