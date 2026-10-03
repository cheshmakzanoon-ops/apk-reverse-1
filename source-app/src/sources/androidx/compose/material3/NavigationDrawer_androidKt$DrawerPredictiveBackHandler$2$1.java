package androidx.compose.material3;

import androidx.activity.BackEventCompat;
import androidx.compose.animation.core.SuspendAnimationKt;
import androidx.compose.material3.internal.PredictiveBack;
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
import kotlinx.coroutines.flow.Flow;
import kotlinx.coroutines.flow.FlowCollector;

@Metadata(d1 = {"\u0000\u0014\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u00012\u0011\u0010\u0002\u001a\r\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\u0002\b\u0005H\u008a@"}, d2 = {"<anonymous>", "", "progress", "Lkotlinx/coroutines/flow/Flow;", "Landroidx/activity/BackEventCompat;", "Lkotlin/jvm/JvmSuppressWildcards;"}, k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.material3.NavigationDrawer_androidKt$DrawerPredictiveBackHandler$2$1", f = "NavigationDrawer.android.kt", i = {}, l = {60, 86, 86, 86}, m = "invokeSuspend", n = {}, s = {})
final class NavigationDrawer_androidKt$DrawerPredictiveBackHandler$2$1 extends SuspendLambda implements Function2<Flow<BackEventCompat>, Continuation<? super Unit>, Object> {
    final DrawerPredictiveBackState $drawerPredictiveBackState;
    final DrawerState $drawerState;
    final boolean $isRtl;
    final Ref.FloatRef $maxScaleXDistanceGrow;
    final Ref.FloatRef $maxScaleXDistanceShrink;
    final Ref.FloatRef $maxScaleYDistance;
    final CoroutineScope $scope;
    Object L$0;
    int label;

    NavigationDrawer_androidKt$DrawerPredictiveBackHandler$2$1(DrawerPredictiveBackState drawerPredictiveBackState, CoroutineScope coroutineScope, DrawerState drawerState, boolean z, Ref.FloatRef floatRef, Ref.FloatRef floatRef2, Ref.FloatRef floatRef3, Continuation<? super NavigationDrawer_androidKt$DrawerPredictiveBackHandler$2$1> continuation) {
        super(2, continuation);
        this.$drawerPredictiveBackState = drawerPredictiveBackState;
        this.$scope = coroutineScope;
        this.$drawerState = drawerState;
        this.$isRtl = z;
        this.$maxScaleXDistanceGrow = floatRef;
        this.$maxScaleXDistanceShrink = floatRef2;
        this.$maxScaleYDistance = floatRef3;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        Continuation<Unit> navigationDrawer_androidKt$DrawerPredictiveBackHandler$2$1 = new NavigationDrawer_androidKt$DrawerPredictiveBackHandler$2$1(this.$drawerPredictiveBackState, this.$scope, this.$drawerState, this.$isRtl, this.$maxScaleXDistanceGrow, this.$maxScaleXDistanceShrink, this.$maxScaleYDistance, continuation);
        navigationDrawer_androidKt$DrawerPredictiveBackHandler$2$1.L$0 = obj;
        return navigationDrawer_androidKt$DrawerPredictiveBackHandler$2$1;
    }

    public final Object invoke(Flow<BackEventCompat> flow, Continuation<? super Unit> continuation) {
        return create(flow, continuation).invokeSuspend(Unit.INSTANCE);
    }

    public final Object invokeSuspend(Object obj) throws Throwable {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        try {
            try {
                if (i == 0) {
                    ResultKt.throwOnFailure(obj);
                    Flow flow = (Flow) this.L$0;
                    final DrawerPredictiveBackState drawerPredictiveBackState = this.$drawerPredictiveBackState;
                    final boolean z = this.$isRtl;
                    final Ref.FloatRef floatRef = this.$maxScaleXDistanceGrow;
                    final Ref.FloatRef floatRef2 = this.$maxScaleXDistanceShrink;
                    final Ref.FloatRef floatRef3 = this.$maxScaleYDistance;
                    this.label = 1;
                    if (flow.collect(new FlowCollector() {
                        public Object emit(Object obj2, Continuation continuation) {
                            return emit((BackEventCompat) obj2, (Continuation<? super Unit>) continuation);
                        }

                        public final Object emit(BackEventCompat backEventCompat, Continuation<? super Unit> continuation) {
                            drawerPredictiveBackState.update(PredictiveBack.INSTANCE.transform$material3_release(backEventCompat.getProgress()), backEventCompat.getSwipeEdge() == 0, z, floatRef.element, floatRef2.element, floatRef3.element);
                            return Unit.INSTANCE;
                        }
                    }, (Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    if (i == 1) {
                        ResultKt.throwOnFailure(obj);
                    } else {
                        if (i != 2 && i != 3) {
                            if (i != 4) {
                                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                            }
                            Throwable th = (Throwable) this.L$0;
                            ResultKt.throwOnFailure(obj);
                            throw th;
                        }
                        ResultKt.throwOnFailure(obj);
                    }
                    return Unit.INSTANCE;
                }
                if (this.$drawerPredictiveBackState.getSwipeEdgeMatchesDrawer()) {
                    BuildersKt.launch$default(this.$scope, (CoroutineContext) null, (CoroutineStart) null, new C12822(this.$drawerPredictiveBackState, null), 3, (Object) null);
                }
                this.label = 2;
                if (this.$drawerState.close((Continuation) this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } catch (CancellationException unused) {
                this.$drawerPredictiveBackState.clear();
                if (this.$drawerPredictiveBackState.getSwipeEdgeMatchesDrawer()) {
                    BuildersKt.launch$default(this.$scope, (CoroutineContext) null, (CoroutineStart) null, new C12822(this.$drawerPredictiveBackState, null), 3, (Object) null);
                }
                this.label = 3;
                if (this.$drawerState.close((Continuation) this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            }
            return Unit.INSTANCE;
        } catch (Throwable th2) {
            if (this.$drawerPredictiveBackState.getSwipeEdgeMatchesDrawer()) {
                BuildersKt.launch$default(this.$scope, (CoroutineContext) null, (CoroutineStart) null, new C12822(this.$drawerPredictiveBackState, null), 3, (Object) null);
            }
            this.L$0 = th2;
            this.label = 4;
            if (this.$drawerState.close((Continuation) this) == coroutine_suspended) {
                return coroutine_suspended;
            }
            throw th2;
        }
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.material3.NavigationDrawer_androidKt$DrawerPredictiveBackHandler$2$1$2", f = "NavigationDrawer.android.kt", i = {}, l = {77}, m = "invokeSuspend", n = {}, s = {})
    static final class C12822 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final DrawerPredictiveBackState $drawerPredictiveBackState;
        int label;

        C12822(DrawerPredictiveBackState drawerPredictiveBackState, Continuation<? super C12822> continuation) {
            super(2, continuation);
            this.$drawerPredictiveBackState = drawerPredictiveBackState;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return new C12822(this.$drawerPredictiveBackState, continuation);
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                float scaleXDistance = this.$drawerPredictiveBackState.getScaleXDistance();
                final DrawerPredictiveBackState drawerPredictiveBackState = this.$drawerPredictiveBackState;
                this.label = 1;
                if (SuspendAnimationKt.animate$default(scaleXDistance, 0.0f, 0.0f, null, new Function2<Float, Float, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke(((Number) obj2).floatValue(), ((Number) obj3).floatValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(float f, float f2) {
                        drawerPredictiveBackState.setScaleXDistance(f);
                    }
                }, (Continuation) this, 12, null) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            this.$drawerPredictiveBackState.clear();
            return Unit.INSTANCE;
        }
    }
}
