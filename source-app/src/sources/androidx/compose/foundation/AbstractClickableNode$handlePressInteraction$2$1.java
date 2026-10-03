package androidx.compose.foundation;

import androidx.compose.foundation.gestures.PressGestureScope;
import androidx.compose.foundation.interaction.MutableInteractionSource;
import androidx.compose.foundation.interaction.PressInteraction;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineStart;
import kotlinx.coroutines.Job;
import kotlinx.coroutines.JobKt;
import zendesk.p005ui.android.BuildConfig;

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.foundation.AbstractClickableNode$handlePressInteraction$2$1", f = "Clickable.kt", i = {0, 1, 2}, l = {1139, 1141, 1148, 1149, 1158}, m = "invokeSuspend", n = {"delayJob", "success", BuildConfig.BUILD_TYPE}, s = {"L$0", "Z$0", "L$0"})
final class AbstractClickableNode$handlePressInteraction$2$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final MutableInteractionSource $interactionSource;
    final long $offset;
    final PressGestureScope $this_handlePressInteraction;
    private Object L$0;
    boolean Z$0;
    int label;
    final AbstractClickableNode this$0;

    AbstractClickableNode$handlePressInteraction$2$1(PressGestureScope pressGestureScope, long j, MutableInteractionSource mutableInteractionSource, AbstractClickableNode abstractClickableNode, Continuation<? super AbstractClickableNode$handlePressInteraction$2$1> continuation) {
        super(2, continuation);
        this.$this_handlePressInteraction = pressGestureScope;
        this.$offset = j;
        this.$interactionSource = mutableInteractionSource;
        this.this$0 = abstractClickableNode;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        Continuation<Unit> abstractClickableNode$handlePressInteraction$2$1 = new AbstractClickableNode$handlePressInteraction$2$1(this.$this_handlePressInteraction, this.$offset, this.$interactionSource, this.this$0, continuation);
        abstractClickableNode$handlePressInteraction$2$1.L$0 = obj;
        return abstractClickableNode$handlePressInteraction$2$1;
    }

    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
    }

    public final Object invokeSuspend(Object obj) {
        Job jobLaunch$default;
        Object objTryAwaitRelease;
        PressInteraction.Cancel cancel;
        boolean z;
        PressInteraction.Press press;
        PressInteraction.Release release;
        PressInteraction.Release release2;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i != 0) {
            if (i == 1) {
                jobLaunch$default = (Job) this.L$0;
                ResultKt.throwOnFailure(obj);
                objTryAwaitRelease = obj;
            } else if (i == 2) {
                z = this.Z$0;
                ResultKt.throwOnFailure(obj);
                if (z) {
                    press = new PressInteraction.Press(this.$offset, null);
                    release = new PressInteraction.Release(press);
                    this.L$0 = release;
                    this.label = 3;
                    if (this.$interactionSource.emit(press, (Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    release2 = release;
                    this.L$0 = null;
                    this.label = 4;
                    if (this.$interactionSource.emit(release2, (Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                }
            } else if (i == 3) {
                release2 = (PressInteraction.Release) this.L$0;
                ResultKt.throwOnFailure(obj);
                this.L$0 = null;
                this.label = 4;
                if (this.$interactionSource.emit(release2, (Continuation) this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 4 && i != 5) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            this.this$0.pressInteraction = null;
            return Unit.INSTANCE;
        }
        ResultKt.throwOnFailure(obj);
        jobLaunch$default = BuildersKt.launch$default((CoroutineScope) this.L$0, (CoroutineContext) null, (CoroutineStart) null, new AbstractClickableNode$handlePressInteraction$2$1$delayJob$1(this.this$0, this.$offset, this.$interactionSource, null), 3, (Object) null);
        this.L$0 = jobLaunch$default;
        this.label = 1;
        objTryAwaitRelease = this.$this_handlePressInteraction.tryAwaitRelease((Continuation) this);
        if (objTryAwaitRelease == coroutine_suspended) {
            return coroutine_suspended;
        }
        boolean zBooleanValue = ((Boolean) objTryAwaitRelease).booleanValue();
        if (!jobLaunch$default.isActive()) {
            PressInteraction.Press press2 = this.this$0.pressInteraction;
            if (press2 != null) {
                MutableInteractionSource mutableInteractionSource = this.$interactionSource;
                if (zBooleanValue) {
                    cancel = new PressInteraction.Release(press2);
                } else {
                    cancel = new PressInteraction.Cancel(press2);
                }
                this.L$0 = null;
                this.label = 5;
                if (mutableInteractionSource.emit(cancel, this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            }
        } else {
            this.L$0 = null;
            this.Z$0 = zBooleanValue;
            this.label = 2;
            if (JobKt.cancelAndJoin(jobLaunch$default, (Continuation) this) == coroutine_suspended) {
                return coroutine_suspended;
            }
            z = zBooleanValue;
            if (z) {
                press = new PressInteraction.Press(this.$offset, null);
                release = new PressInteraction.Release(press);
                this.L$0 = release;
                this.label = 3;
                if (this.$interactionSource.emit(press, (Continuation) this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                release2 = release;
                this.L$0 = null;
                this.label = 4;
                if (this.$interactionSource.emit(release2, (Continuation) this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            }
        }
        this.this$0.pressInteraction = null;
        return Unit.INSTANCE;
    }
}
