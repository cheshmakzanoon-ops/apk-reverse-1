package zendesk.guidekit.android.internal.data;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;
import zendesk.guidekit.android.internal.rest.HelpCenterApi;
import zendesk.guidekit.android.internal.rest.model.AttachmentResponseDto;

@Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/guidekit/android/internal/rest/model/AttachmentResponseDto;", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.guidekit.android.internal.data.GuideKitRepository$getArticle$2$attachmentsDeferred$1", m37f = "GuideKitRepository.kt", m38i = {}, m39l = {138}, m40m = "invokeSuspend", m41n = {}, m42s = {})
final class GuideKitRepository$getArticle$2$attachmentsDeferred$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super AttachmentResponseDto>, Object> {
    final String $attachmentsUrl;
    int label;
    final GuideKitRepository this$0;

    GuideKitRepository$getArticle$2$attachmentsDeferred$1(GuideKitRepository guideKitRepository, String str, Continuation<? super GuideKitRepository$getArticle$2$attachmentsDeferred$1> continuation) {
        super(2, continuation);
        this.this$0 = guideKitRepository;
        this.$attachmentsUrl = str;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new GuideKitRepository$getArticle$2$attachmentsDeferred$1(this.this$0, this.$attachmentsUrl, continuation);
    }

    @Override
    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super AttachmentResponseDto> continuation) {
        return ((GuideKitRepository$getArticle$2$attachmentsDeferred$1) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            this.label = 1;
            obj = HelpCenterApi.DefaultImpls.getAttachments$default(this.this$0.helpCenterApi, this.$attachmentsUrl, 0, this, 2, null);
            if (obj == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        return obj;
    }
}
