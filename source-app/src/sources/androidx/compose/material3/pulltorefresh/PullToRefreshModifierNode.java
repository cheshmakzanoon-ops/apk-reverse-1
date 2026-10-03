package androidx.compose.material3.pulltorefresh;

import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.input.nestedscroll.NestedScrollConnection;
import androidx.compose.p002ui.input.nestedscroll.NestedScrollNodeKt;
import androidx.compose.p002ui.input.nestedscroll.NestedScrollSource;
import androidx.compose.p002ui.node.CompositionLocalConsumerModifierNode;
import androidx.compose.p002ui.node.CompositionLocalConsumerModifierNodeKt;
import androidx.compose.p002ui.node.DelegatableNode;
import androidx.compose.p002ui.node.DelegatingNode;
import androidx.compose.p002ui.platform.CompositionLocalsKt;
import androidx.compose.runtime.MutableFloatState;
import androidx.compose.runtime.PrimitiveSnapshotStateKt;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.Velocity;
import androidx.compose.ui.unit.VelocityKt;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.ranges.RangesKt;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineStart;

@Metadata(d1 = {"\u0000b\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0002\b\u000f\n\u0002\u0018\u0002\n\u0002\b\u000e\n\u0002\u0010\b\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\n\b\u0000\u0018\u00002\u00020\u00012\u00020\u00022\u00020\u0003B3\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007\u0012\u0006\u0010\t\u001a\u00020\u0005\u0012\u0006\u0010\n\u001a\u00020\u000b\u0012\u0006\u0010\f\u001a\u00020\r¢\u0006\u0002\u0010\u000eJ\u000e\u00106\u001a\u00020\bH\u0082@¢\u0006\u0002\u00107J\u000e\u00108\u001a\u00020\bH\u0082@¢\u0006\u0002\u00107J\b\u00109\u001a\u00020\u0010H\u0002J\u001a\u0010:\u001a\u00020;2\u0006\u0010<\u001a\u00020;H\u0002ø\u0001\u0000¢\u0006\u0004\b=\u0010>J\b\u0010?\u001a\u00020\bH\u0016J*\u0010@\u001a\u00020;2\u0006\u0010A\u001a\u00020;2\u0006\u0010<\u001a\u00020;2\u0006\u0010B\u001a\u00020CH\u0016ø\u0001\u0000¢\u0006\u0004\bD\u0010EJ\u001b\u0010F\u001a\u00020G2\u0006\u0010<\u001a\u00020GH\u0096@ø\u0001\u0000¢\u0006\u0004\bH\u0010IJ\"\u0010J\u001a\u00020;2\u0006\u0010<\u001a\u00020;2\u0006\u0010B\u001a\u00020CH\u0016ø\u0001\u0000¢\u0006\u0004\bK\u0010LJ\u0016\u0010M\u001a\u00020\u00102\u0006\u0010N\u001a\u00020\u0010H\u0082@¢\u0006\u0002\u0010OJ\u0006\u0010P\u001a\u00020\bR\u0014\u0010\u000f\u001a\u00020\u00108BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\u0011\u0010\u0012R+\u0010\u0014\u001a\u00020\u00102\u0006\u0010\u0013\u001a\u00020\u00108B@BX\u0082\u008e\u0002¢\u0006\u0012\n\u0004\b\u0018\u0010\u0019\u001a\u0004\b\u0015\u0010\u0012\"\u0004\b\u0016\u0010\u0017R\u001a\u0010\t\u001a\u00020\u0005X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001a\u0010\u001b\"\u0004\b\u001c\u0010\u001dR\u001a\u0010\u0004\u001a\u00020\u0005X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0004\u0010\u001b\"\u0004\b\u001e\u0010\u001dR\u000e\u0010\u001f\u001a\u00020 X\u0082\u000e¢\u0006\u0002\n\u0000R \u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b!\u0010\"\"\u0004\b#\u0010$R\u0014\u0010%\u001a\u00020\u00108BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b&\u0010\u0012R\u001a\u0010\n\u001a\u00020\u000bX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b'\u0010(\"\u0004\b)\u0010*R\"\u0010\f\u001a\u00020\rX\u0086\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010-\u001a\u0004\b+\u0010\u0012\"\u0004\b,\u0010\u0017R\u0014\u0010.\u001a\u00020/8BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b0\u00101R+\u00102\u001a\u00020\u00102\u0006\u0010\u0013\u001a\u00020\u00108B@BX\u0082\u008e\u0002¢\u0006\u0012\n\u0004\b5\u0010\u0019\u001a\u0004\b3\u0010\u0012\"\u0004\b4\u0010\u0017\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006Q"}, d2 = {"Landroidx/compose/material3/pulltorefresh/PullToRefreshModifierNode;", "Landroidx/compose/ui/node/DelegatingNode;", "Landroidx/compose/ui/node/CompositionLocalConsumerModifierNode;", "Landroidx/compose/ui/input/nestedscroll/NestedScrollConnection;", "isRefreshing", "", "onRefresh", "Lkotlin/Function0;", "", "enabled", "state", "Landroidx/compose/material3/pulltorefresh/PullToRefreshState;", "threshold", "Landroidx/compose/ui/unit/Dp;", "(ZLkotlin/jvm/functions/Function0;ZLandroidx/compose/material3/pulltorefresh/PullToRefreshState;FLkotlin/jvm/internal/DefaultConstructorMarker;)V", "adjustedDistancePulled", "", "getAdjustedDistancePulled", "()F", "<set-?>", "distancePulled", "getDistancePulled", "setDistancePulled", "(F)V", "distancePulled$delegate", "Landroidx/compose/runtime/MutableFloatState;", "getEnabled", "()Z", "setEnabled", "(Z)V", "setRefreshing", "nestedScrollNode", "Landroidx/compose/ui/node/DelegatableNode;", "getOnRefresh", "()Lkotlin/jvm/functions/Function0;", "setOnRefresh", "(Lkotlin/jvm/functions/Function0;)V", "progress", "getProgress", "getState", "()Landroidx/compose/material3/pulltorefresh/PullToRefreshState;", "setState", "(Landroidx/compose/material3/pulltorefresh/PullToRefreshState;)V", "getThreshold-D9Ej5fM", "setThreshold-0680j_4", "F", "thresholdPx", "", "getThresholdPx", "()I", "verticalOffset", "getVerticalOffset", "setVerticalOffset", "verticalOffset$delegate", "animateToHidden", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "animateToThreshold", "calculateVerticalOffset", "consumeAvailableOffset", "Landroidx/compose/ui/geometry/Offset;", "available", "consumeAvailableOffset-MK-Hz9U", "(J)J", "onAttach", "onPostScroll", "consumed", "source", "Landroidx/compose/ui/input/nestedscroll/NestedScrollSource;", "onPostScroll-DzOQY0M", "(JJI)J", "onPreFling", "Landroidx/compose/ui/unit/Velocity;", "onPreFling-QWom1Mo", "(JLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "onPreScroll", "onPreScroll-OzD1aCk", "(JI)J", "onRelease", "velocity", "(FLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "update", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class PullToRefreshModifierNode extends DelegatingNode implements CompositionLocalConsumerModifierNode, NestedScrollConnection {
    public static final int $stable = 8;

    private final MutableFloatState distancePulled;
    private boolean enabled;
    private boolean isRefreshing;
    private DelegatableNode nestedScrollNode;
    private Function0<Unit> onRefresh;
    private PullToRefreshState state;
    private float threshold;

    private final MutableFloatState verticalOffset;

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.material3.pulltorefresh.PullToRefreshModifierNode", f = "PullToRefresh.kt", i = {0}, l = {406}, m = "animateToHidden", n = {"this"}, s = {"L$0"})
    static final class C14991 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C14991(Continuation<? super C14991> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return PullToRefreshModifierNode.this.animateToHidden((Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.material3.pulltorefresh.PullToRefreshModifierNode", f = "PullToRefresh.kt", i = {0}, l = {400}, m = "animateToThreshold", n = {"this"}, s = {"L$0"})
    static final class C15001 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C15001(Continuation<? super C15001> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return PullToRefreshModifierNode.this.animateToThreshold((Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.material3.pulltorefresh.PullToRefreshModifierNode", f = "PullToRefresh.kt", i = {0, 0, 1, 1}, l = {359, 362}, m = "onRelease", n = {"this", "velocity", "this", "velocity"}, s = {"L$0", "F$0", "L$0", "F$0"})
    static final class C15021 extends ContinuationImpl {
        float F$0;
        Object L$0;
        int label;
        Object result;

        C15021(Continuation<? super C15021> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return PullToRefreshModifierNode.this.onRelease(0.0f, (Continuation) this);
        }
    }

    public PullToRefreshModifierNode(boolean z, Function0 function0, boolean z2, PullToRefreshState pullToRefreshState, float f, DefaultConstructorMarker defaultConstructorMarker) {
        this(z, function0, z2, pullToRefreshState, f);
    }

    @Override
    public Object mo828onPostFlingRZ2iAVY(long j, long j2, Continuation continuation) {
        return NestedScrollConnection.CC.m5713onPostFlingRZ2iAVY$suspendImpl(this, j, j2, continuation);
    }

    public final boolean getIsRefreshing() {
        return this.isRefreshing;
    }

    public final void setRefreshing(boolean z) {
        this.isRefreshing = z;
    }

    public final Function0<Unit> getOnRefresh() {
        return this.onRefresh;
    }

    public final void setOnRefresh(Function0<Unit> function0) {
        this.onRefresh = function0;
    }

    public final boolean getEnabled() {
        return this.enabled;
    }

    public final void setEnabled(boolean z) {
        this.enabled = z;
    }

    public final PullToRefreshState getState() {
        return this.state;
    }

    public final void setState(PullToRefreshState pullToRefreshState) {
        this.state = pullToRefreshState;
    }

    public final float getThreshold() {
        return this.threshold;
    }

    public final void m3367setThreshold0680j_4(float f) {
        this.threshold = f;
    }

    private PullToRefreshModifierNode(boolean z, Function0<Unit> function0, boolean z2, PullToRefreshState pullToRefreshState, float f) {
        this.isRefreshing = z;
        this.onRefresh = function0;
        this.enabled = z2;
        this.state = pullToRefreshState;
        this.threshold = f;
        this.nestedScrollNode = NestedScrollNodeKt.nestedScrollModifierNode(this, null);
        this.verticalOffset = PrimitiveSnapshotStateKt.mutableFloatStateOf(0.0f);
        this.distancePulled = PrimitiveSnapshotStateKt.mutableFloatStateOf(0.0f);
    }

    public final float getVerticalOffset() {
        return this.verticalOffset.getFloatValue();
    }

    private final void setVerticalOffset(float f) {
        this.verticalOffset.setFloatValue(f);
    }

    private final float getDistancePulled() {
        return this.distancePulled.getFloatValue();
    }

    private final void setDistancePulled(float f) {
        this.distancePulled.setFloatValue(f);
    }

    private final float getAdjustedDistancePulled() {
        return getDistancePulled() * 0.5f;
    }

    public final int getThresholdPx() {
        return ((Density) CompositionLocalConsumerModifierNodeKt.currentValueOf(this, CompositionLocalsKt.getLocalDensity())).roundToPx-0680j_4(this.threshold);
    }

    private final float getProgress() {
        return getAdjustedDistancePulled() / getThresholdPx();
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.material3.pulltorefresh.PullToRefreshModifierNode$onAttach$1", f = "PullToRefresh.kt", i = {}, l = {287, 289}, m = "invokeSuspend", n = {}, s = {})
    static final class C15011 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C15011(Continuation<? super C15011> continuation) {
            super(2, continuation);
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return PullToRefreshModifierNode.this.new C15011(continuation);
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                if (PullToRefreshModifierNode.this.getIsRefreshing()) {
                    this.label = 1;
                    if (PullToRefreshModifierNode.this.getState().snapTo(1.0f, (Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    this.label = 2;
                    if (PullToRefreshModifierNode.this.getState().snapTo(0.0f, (Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                }
            } else {
                if (i != 1 && i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
    }

    @Override
    public void onAttach() {
        delegate(this.nestedScrollNode);
        BuildersKt.launch$default(getCoroutineScope(), (CoroutineContext) null, (CoroutineStart) null, new C15011(null), 3, (Object) null);
    }

    @Override
    public long mo831onPreScrollOzD1aCk(long available, int source) {
        if (!this.state.isAnimating() && this.enabled) {
            if (NestedScrollSource.m5728equalsimpl0(source, NestedScrollSource.INSTANCE.m5740getUserInputWNlRxjI()) && Offset.m4347getYimpl(available) < 0.0f) {
                return m3365consumeAvailableOffsetMKHz9U(available);
            }
            return Offset.INSTANCE.m4362getZeroF1C5BW0();
        }
        return Offset.INSTANCE.m4362getZeroF1C5BW0();
    }

    @Override
    public long mo829onPostScrollDzOQY0M(long consumed, long available, int source) {
        if (!this.state.isAnimating() && this.enabled) {
            if (NestedScrollSource.m5728equalsimpl0(source, NestedScrollSource.INSTANCE.m5740getUserInputWNlRxjI())) {
                long jM3365consumeAvailableOffsetMKHz9U = m3365consumeAvailableOffsetMKHz9U(available);
                BuildersKt.launch$default(getCoroutineScope(), (CoroutineContext) null, (CoroutineStart) null, new PullToRefreshModifierNode$onPostScroll$1(this, null), 3, (Object) null);
                return jM3365consumeAvailableOffsetMKHz9U;
            }
            return Offset.INSTANCE.m4362getZeroF1C5BW0();
        }
        return Offset.INSTANCE.m4362getZeroF1C5BW0();
    }

    @Override
    public Object mo830onPreFlingQWom1Mo(long j, Continuation<? super Velocity> continuation) {
        PullToRefreshModifierNode$onPreFling$1 pullToRefreshModifierNode$onPreFling$1;
        float f;
        if (continuation instanceof PullToRefreshModifierNode$onPreFling$1) {
            pullToRefreshModifierNode$onPreFling$1 = (PullToRefreshModifierNode$onPreFling$1) continuation;
            if ((pullToRefreshModifierNode$onPreFling$1.label & Integer.MIN_VALUE) != 0) {
                pullToRefreshModifierNode$onPreFling$1.label -= Integer.MIN_VALUE;
            } else {
                pullToRefreshModifierNode$onPreFling$1 = new PullToRefreshModifierNode$onPreFling$1(this, continuation);
            }
        } else {
            pullToRefreshModifierNode$onPreFling$1 = new PullToRefreshModifierNode$onPreFling$1(this, continuation);
        }
        Object objOnRelease = pullToRefreshModifierNode$onPreFling$1.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = pullToRefreshModifierNode$onPreFling$1.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objOnRelease);
            float f2 = Velocity.getY-impl(j);
            pullToRefreshModifierNode$onPreFling$1.F$0 = 0.0f;
            pullToRefreshModifierNode$onPreFling$1.label = 1;
            objOnRelease = onRelease(f2, pullToRefreshModifierNode$onPreFling$1);
            if (objOnRelease == coroutine_suspended) {
                return coroutine_suspended;
            }
            f = 0.0f;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            f = pullToRefreshModifierNode$onPreFling$1.F$0;
            ResultKt.throwOnFailure(objOnRelease);
        }
        return Velocity.box-impl(VelocityKt.Velocity(f, ((Number) objOnRelease).floatValue()));
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.material3.pulltorefresh.PullToRefreshModifierNode$update$1", f = "PullToRefresh.kt", i = {}, l = {333, 335}, m = "invokeSuspend", n = {}, s = {})
    static final class C15031 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C15031(Continuation<? super C15031> continuation) {
            super(2, continuation);
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return PullToRefreshModifierNode.this.new C15031(continuation);
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                if (!PullToRefreshModifierNode.this.getIsRefreshing()) {
                    this.label = 1;
                    if (PullToRefreshModifierNode.this.animateToHidden((Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    this.label = 2;
                    if (PullToRefreshModifierNode.this.animateToThreshold((Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                }
            } else {
                if (i != 1 && i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
    }

    public final void update() {
        BuildersKt.launch$default(getCoroutineScope(), (CoroutineContext) null, (CoroutineStart) null, new C15031(null), 3, (Object) null);
    }

    private final long m3365consumeAvailableOffsetMKHz9U(long available) {
        float distancePulled;
        if (this.isRefreshing) {
            distancePulled = 0.0f;
        } else {
            float fCoerceAtLeast = RangesKt.coerceAtLeast(getDistancePulled() + Offset.m4347getYimpl(available), 0.0f);
            distancePulled = fCoerceAtLeast - getDistancePulled();
            setDistancePulled(fCoerceAtLeast);
            setVerticalOffset(calculateVerticalOffset());
        }
        return OffsetKt.Offset(0.0f, distancePulled);
    }

    public final Object onRelease(float f, Continuation<? super Float> continuation) {
        C15021 c15021;
        PullToRefreshModifierNode pullToRefreshModifierNode;
        if (continuation instanceof C15021) {
            c15021 = (C15021) continuation;
            if ((c15021.label & Integer.MIN_VALUE) != 0) {
                c15021.label -= Integer.MIN_VALUE;
            } else {
                c15021 = new C15021(continuation);
            }
        } else {
            c15021 = new C15021(continuation);
        }
        Object obj = c15021.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c15021.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            if (this.isRefreshing) {
                return Boxing.boxFloat(0.0f);
            }
            if (getAdjustedDistancePulled() > getThresholdPx()) {
                c15021.L$0 = this;
                c15021.F$0 = f;
                c15021.label = 1;
                if (animateToThreshold(c15021) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                pullToRefreshModifierNode = this;
                pullToRefreshModifierNode.onRefresh.invoke();
            } else {
                c15021.L$0 = this;
                c15021.F$0 = f;
                c15021.label = 2;
                if (animateToHidden(c15021) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                pullToRefreshModifierNode = this;
            }
        } else if (i == 1) {
            f = c15021.F$0;
            pullToRefreshModifierNode = (PullToRefreshModifierNode) c15021.L$0;
            ResultKt.throwOnFailure(obj);
            pullToRefreshModifierNode.onRefresh.invoke();
        } else {
            if (i != 2) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            f = c15021.F$0;
            pullToRefreshModifierNode = (PullToRefreshModifierNode) c15021.L$0;
            ResultKt.throwOnFailure(obj);
        }
        if (pullToRefreshModifierNode.getDistancePulled() == 0.0f || f < 0.0f) {
            f = 0.0f;
        }
        pullToRefreshModifierNode.setDistancePulled(0.0f);
        return Boxing.boxFloat(f);
    }

    private final float calculateVerticalOffset() {
        if (getAdjustedDistancePulled() <= getThresholdPx()) {
            return getAdjustedDistancePulled();
        }
        float fCoerceIn = RangesKt.coerceIn(Math.abs(getProgress()) - 1.0f, 0.0f, 2.0f);
        return getThresholdPx() + (getThresholdPx() * (fCoerceIn - (((float) Math.pow(fCoerceIn, 2)) / 4)));
    }

    public final Object animateToThreshold(Continuation<? super Unit> continuation) {
        C15001 c15001;
        PullToRefreshModifierNode pullToRefreshModifierNode;
        if (continuation instanceof C15001) {
            c15001 = (C15001) continuation;
            if ((c15001.label & Integer.MIN_VALUE) != 0) {
                c15001.label -= Integer.MIN_VALUE;
            } else {
                c15001 = new C15001(continuation);
            }
        } else {
            c15001 = new C15001(continuation);
        }
        Object obj = c15001.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c15001.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            PullToRefreshState pullToRefreshState = this.state;
            c15001.L$0 = this;
            c15001.label = 1;
            if (pullToRefreshState.animateToThreshold(c15001) == coroutine_suspended) {
                return coroutine_suspended;
            }
            pullToRefreshModifierNode = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            pullToRefreshModifierNode = (PullToRefreshModifierNode) c15001.L$0;
            ResultKt.throwOnFailure(obj);
        }
        pullToRefreshModifierNode.setDistancePulled(pullToRefreshModifierNode.getThresholdPx());
        pullToRefreshModifierNode.setVerticalOffset(pullToRefreshModifierNode.getThresholdPx());
        return Unit.INSTANCE;
    }

    public final Object animateToHidden(Continuation<? super Unit> continuation) {
        C14991 c14991;
        PullToRefreshModifierNode pullToRefreshModifierNode;
        if (continuation instanceof C14991) {
            c14991 = (C14991) continuation;
            if ((c14991.label & Integer.MIN_VALUE) != 0) {
                c14991.label -= Integer.MIN_VALUE;
            } else {
                c14991 = new C14991(continuation);
            }
        } else {
            c14991 = new C14991(continuation);
        }
        Object obj = c14991.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c14991.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            PullToRefreshState pullToRefreshState = this.state;
            c14991.L$0 = this;
            c14991.label = 1;
            if (pullToRefreshState.animateToHidden(c14991) == coroutine_suspended) {
                return coroutine_suspended;
            }
            pullToRefreshModifierNode = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            pullToRefreshModifierNode = (PullToRefreshModifierNode) c14991.L$0;
            ResultKt.throwOnFailure(obj);
        }
        pullToRefreshModifierNode.setDistancePulled(0.0f);
        pullToRefreshModifierNode.setVerticalOffset(0.0f);
        return Unit.INSTANCE;
    }
}
