package zendesk.guidekit.android.internal.data;

import kotlin.Metadata;
import kotlin.Result;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.guidekit.android.internal.data.GuideKitRepository", m37f = "GuideKitRepository.kt", m38i = {}, m39l = {88}, m40m = "sendArticleStatsView-BWLJW6A", m41n = {}, m42s = {})
final class GuideKitRepository$sendArticleStatsView$1 extends ContinuationImpl {
    int label;
    Object result;
    final GuideKitRepository this$0;

    GuideKitRepository$sendArticleStatsView$1(GuideKitRepository guideKitRepository, Continuation<? super GuideKitRepository$sendArticleStatsView$1> continuation) {
        super(continuation);
        this.this$0 = guideKitRepository;
    }

    @Override
    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        Object objM2116sendArticleStatsViewBWLJW6A = this.this$0.m2116sendArticleStatsViewBWLJW6A(0L, null, null, this);
        return objM2116sendArticleStatsViewBWLJW6A == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objM2116sendArticleStatsViewBWLJW6A : Result.m295boximpl(objM2116sendArticleStatsViewBWLJW6A);
    }
}
