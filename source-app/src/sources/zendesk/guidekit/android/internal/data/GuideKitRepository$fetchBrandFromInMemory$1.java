package zendesk.guidekit.android.internal.data;

import kotlin.Metadata;
import kotlin.Result;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.guidekit.android.internal.data.GuideKitRepository", m37f = "GuideKitRepository.kt", m38i = {0, 1}, m39l = {190, 192}, m40m = "fetchBrandFromInMemory-IoAF18A", m41n = {"this", "channelId"}, m42s = {"L$0", "L$0"})
final class GuideKitRepository$fetchBrandFromInMemory$1 extends ContinuationImpl {
    Object L$0;
    int label;
    Object result;
    final GuideKitRepository this$0;

    GuideKitRepository$fetchBrandFromInMemory$1(GuideKitRepository guideKitRepository, Continuation<? super GuideKitRepository$fetchBrandFromInMemory$1> continuation) {
        super(continuation);
        this.this$0 = guideKitRepository;
    }

    @Override
    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        Object objM2114fetchBrandFromInMemoryIoAF18A = this.this$0.m2114fetchBrandFromInMemoryIoAF18A(this);
        return objM2114fetchBrandFromInMemoryIoAF18A == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objM2114fetchBrandFromInMemoryIoAF18A : Result.m295boximpl(objM2114fetchBrandFromInMemoryIoAF18A);
    }
}
