package androidx.compose.p002ui.platform;

import android.view.View;
import androidx.compose.runtime.Recomposer;
import androidx.lifecycle.LifecycleOwner;
import java.util.concurrent.CancellationException;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Ref;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineStart;
import kotlinx.coroutines.Job;
import kotlinx.coroutines.flow.StateFlow;

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.ui.platform.WindowRecomposer_androidKt$createLifecycleAwareWindowRecomposer$2$onStateChanged$1", f = "WindowRecomposer.android.kt", i = {0}, l = {396}, m = "invokeSuspend", n = {"durationScaleJob"}, s = {"L$0"})
final class C1761x149b840a extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final Recomposer $recomposer;
    final WindowRecomposer_androidKt.C17602 $self;
    final LifecycleOwner $source;
    final Ref.ObjectRef<MotionDurationScaleImpl> $systemDurationScaleSettingConsumer;
    final View $this_createLifecycleAwareWindowRecomposer;
    private Object L$0;
    int label;

    C1761x149b840a(Ref.ObjectRef<MotionDurationScaleImpl> objectRef, Recomposer recomposer, LifecycleOwner lifecycleOwner, WindowRecomposer_androidKt.C17602 c17602, View view, Continuation<? super C1761x149b840a> continuation) {
        super(2, continuation);
        this.$systemDurationScaleSettingConsumer = objectRef;
        this.$recomposer = recomposer;
        this.$source = lifecycleOwner;
        this.$self = c17602;
        this.$this_createLifecycleAwareWindowRecomposer = view;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        Continuation<Unit> c1761x149b840a = new C1761x149b840a(this.$systemDurationScaleSettingConsumer, this.$recomposer, this.$source, this.$self, this.$this_createLifecycleAwareWindowRecomposer, continuation);
        c1761x149b840a.L$0 = obj;
        return c1761x149b840a;
    }

    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
    }

    public final Object invokeSuspend(Object obj) throws Throwable {
        Job job;
        Job jobLaunch$default;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i != 0) {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            job = (Job) this.L$0;
            try {
                ResultKt.throwOnFailure(obj);
                if (job != null) {
                    Job.DefaultImpls.cancel$default(job, (CancellationException) null, 1, (Object) null);
                }
                this.$source.getLifecycle().removeObserver(this.$self);
                return Unit.INSTANCE;
            } catch (Throwable th) {
                th = th;
                if (job != null) {
                    Job.DefaultImpls.cancel$default(job, (CancellationException) null, 1, (Object) null);
                }
                this.$source.getLifecycle().removeObserver(this.$self);
                throw th;
            }
        }
        ResultKt.throwOnFailure(obj);
        CoroutineScope coroutineScope = (CoroutineScope) this.L$0;
        try {
            MotionDurationScaleImpl motionDurationScaleImpl = (MotionDurationScaleImpl) this.$systemDurationScaleSettingConsumer.element;
            if (motionDurationScaleImpl != null) {
                StateFlow animationScaleFlowFor = WindowRecomposer_androidKt.getAnimationScaleFlowFor(this.$this_createLifecycleAwareWindowRecomposer.getContext().getApplicationContext());
                motionDurationScaleImpl.setScaleFactor(((Number) animationScaleFlowFor.getValue()).floatValue());
                jobLaunch$default = BuildersKt.launch$default(coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new C1762x93d788e4(animationScaleFlowFor, motionDurationScaleImpl, null), 3, (Object) null);
            } else {
                jobLaunch$default = null;
            }
            try {
                this.L$0 = jobLaunch$default;
                this.label = 1;
                if (this.$recomposer.runRecomposeAndApplyChanges((Continuation) this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                job = jobLaunch$default;
                if (job != null) {
                    Job.DefaultImpls.cancel$default(job, (CancellationException) null, 1, (Object) null);
                }
                this.$source.getLifecycle().removeObserver(this.$self);
                return Unit.INSTANCE;
            } catch (Throwable th2) {
                job = jobLaunch$default;
                th = th2;
                if (job != null) {
                    Job.DefaultImpls.cancel$default(job, (CancellationException) null, 1, (Object) null);
                }
                this.$source.getLifecycle().removeObserver(this.$self);
                throw th;
            }
        } catch (Throwable th3) {
            th = th3;
            job = null;
        }
    }
}
