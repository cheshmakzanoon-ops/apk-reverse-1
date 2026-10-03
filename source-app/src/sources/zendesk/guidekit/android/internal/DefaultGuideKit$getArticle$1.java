package zendesk.guidekit.android.internal;

import kotlin.Metadata;
import kotlin.Result;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import net.aihelp.data.track.data.TrackType;

@Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.guidekit.android.internal.DefaultGuideKit", m37f = "DefaultGuideKit.kt", m38i = {}, m39l = {TrackType.TRACK_DURATION_HELP_CENTER}, m40m = "getArticle-BWLJW6A", m41n = {}, m42s = {})
final class DefaultGuideKit$getArticle$1 extends ContinuationImpl {
    int label;
    Object result;
    final DefaultGuideKit this$0;

    DefaultGuideKit$getArticle$1(DefaultGuideKit defaultGuideKit, Continuation<? super DefaultGuideKit$getArticle$1> continuation) {
        super(continuation);
        this.this$0 = defaultGuideKit;
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        Object objMo2111getArticleBWLJW6A = this.this$0.mo2111getArticleBWLJW6A(null, 0L, null, this);
        return objMo2111getArticleBWLJW6A == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objMo2111getArticleBWLJW6A : Result.m295boximpl(objMo2111getArticleBWLJW6A);
    }
}
