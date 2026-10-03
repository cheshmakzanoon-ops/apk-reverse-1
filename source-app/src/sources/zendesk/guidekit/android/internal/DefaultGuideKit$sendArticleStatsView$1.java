package zendesk.guidekit.android.internal;

import kotlin.Metadata;
import kotlin.Result;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.guidekit.android.internal.DefaultGuideKit", m37f = "DefaultGuideKit.kt", m38i = {}, m39l = {34}, m40m = "sendArticleStatsView-BWLJW6A", m41n = {}, m42s = {})
final class DefaultGuideKit$sendArticleStatsView$1 extends ContinuationImpl {
    int label;
    Object result;
    final DefaultGuideKit this$0;

    DefaultGuideKit$sendArticleStatsView$1(DefaultGuideKit defaultGuideKit, Continuation<? super DefaultGuideKit$sendArticleStatsView$1> continuation) {
        super(continuation);
        this.this$0 = defaultGuideKit;
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        Object objMo2113sendArticleStatsViewBWLJW6A = this.this$0.mo2113sendArticleStatsViewBWLJW6A(null, 0L, null, this);
        return objMo2113sendArticleStatsViewBWLJW6A == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objMo2113sendArticleStatsViewBWLJW6A : Result.m295boximpl(objMo2113sendArticleStatsViewBWLJW6A);
    }
}
