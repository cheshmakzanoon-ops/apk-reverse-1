package androidx.compose.p002ui.scrollcapture;

import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.internal.InlineClassHelperKt;
import androidx.compose.p002ui.semantics.ScrollAxisRange;
import androidx.compose.p002ui.semantics.SemanticsProperties;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;

@Metadata(d1 = {"\u0000\b\n\u0000\n\u0002\u0010\u0007\n\u0000\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u0001H\u008a@"}, d2 = {"<anonymous>", "", "delta"}, k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.ui.scrollcapture.ComposeScrollCaptureCallback$scrollTracker$1", f = "ComposeScrollCaptureCallback.android.kt", i = {0}, l = {85}, m = "invokeSuspend", n = {"reverseScrolling"}, s = {"Z$0"})
final class ComposeScrollCaptureCallback$scrollTracker$1 extends SuspendLambda implements Function2<Float, Continuation<? super Float>, Object> {
    float F$0;
    boolean Z$0;
    int label;
    final ComposeScrollCaptureCallback this$0;

    ComposeScrollCaptureCallback$scrollTracker$1(ComposeScrollCaptureCallback composeScrollCaptureCallback, Continuation<? super ComposeScrollCaptureCallback$scrollTracker$1> continuation) {
        super(2, continuation);
        this.this$0 = composeScrollCaptureCallback;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        Continuation<Unit> composeScrollCaptureCallback$scrollTracker$1 = new ComposeScrollCaptureCallback$scrollTracker$1(this.this$0, continuation);
        composeScrollCaptureCallback$scrollTracker$1.F$0 = ((Number) obj).floatValue();
        return composeScrollCaptureCallback$scrollTracker$1;
    }

    public final Object invoke(float f, Continuation<? super Float> continuation) {
        return create(Float.valueOf(f), continuation).invokeSuspend(Unit.INSTANCE);
    }

    public Object invoke(Object obj, Object obj2) {
        return invoke(((Number) obj).floatValue(), (Continuation<? super Float>) obj2);
    }

    public final Object invokeSuspend(Object obj) throws KotlinNothingValueException {
        boolean z;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            float f = this.F$0;
            Function2<Offset, Continuation<? super Offset>, Object> scrollCaptureScrollByAction = ScrollCapture_androidKt.getScrollCaptureScrollByAction(this.this$0.node);
            if (scrollCaptureScrollByAction != null) {
                boolean reverseScrolling = ((ScrollAxisRange) this.this$0.node.getUnmergedConfig().get(SemanticsProperties.INSTANCE.getVerticalScrollAxisRange())).getReverseScrolling();
                if (reverseScrolling) {
                    f = -f;
                }
                Offset offsetM4335boximpl = Offset.m4335boximpl(OffsetKt.Offset(0.0f, f));
                this.Z$0 = reverseScrolling;
                this.label = 1;
                obj = scrollCaptureScrollByAction.invoke(offsetM4335boximpl, this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
                z = reverseScrolling;
            } else {
                InlineClassHelperKt.throwIllegalStateExceptionForNullCheck("Required value was null.");
                throw new KotlinNothingValueException();
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            z = this.Z$0;
            ResultKt.throwOnFailure(obj);
        }
        float fM4347getYimpl = Offset.m4347getYimpl(((Offset) obj).getPackedValue());
        if (z) {
            fM4347getYimpl = -fM4347getYimpl;
        }
        return Boxing.boxFloat(fM4347getYimpl);
    }
}
