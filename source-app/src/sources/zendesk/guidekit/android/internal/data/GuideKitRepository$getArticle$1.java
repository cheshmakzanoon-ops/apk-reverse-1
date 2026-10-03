package zendesk.guidekit.android.internal.data;

import kotlin.Metadata;
import kotlin.Result;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.guidekit.android.internal.data.GuideKitRepository", m37f = "GuideKitRepository.kt", m38i = {}, m39l = {118}, m40m = "getArticle-BWLJW6A", m41n = {}, m42s = {})
final class GuideKitRepository$getArticle$1 extends ContinuationImpl {
    int label;
    Object result;
    final GuideKitRepository this$0;

    GuideKitRepository$getArticle$1(GuideKitRepository guideKitRepository, Continuation<? super GuideKitRepository$getArticle$1> continuation) {
        super(continuation);
        this.this$0 = guideKitRepository;
    }

    @Override
    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        Object objM2115getArticleBWLJW6A = this.this$0.m2115getArticleBWLJW6A(0L, null, null, this);
        return objM2115getArticleBWLJW6A == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objM2115getArticleBWLJW6A : Result.m295boximpl(objM2115getArticleBWLJW6A);
    }
}
