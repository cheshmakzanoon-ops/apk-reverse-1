package androidx.compose.p002ui.input.nestedscroll;

import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.node.TraversableNode;
import androidx.compose.p002ui.node.TraversableNodeKt;
import androidx.compose.ui.unit.Velocity;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000J\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u000f\b\u0000\u0018\u00002\u00020\u00012\u00020\u00022\u00020\u0003B\u0017\u0012\u0006\u0010\u0004\u001a\u00020\u0002\u0012\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006¢\u0006\u0002\u0010\u0007J\b\u0010\u001a\u001a\u00020\u001bH\u0016J\b\u0010\u001c\u001a\u00020\u001bH\u0016J#\u0010\u001d\u001a\u00020\u001e2\u0006\u0010\u001f\u001a\u00020\u001e2\u0006\u0010 \u001a\u00020\u001eH\u0096@ø\u0001\u0000¢\u0006\u0004\b!\u0010\"J*\u0010#\u001a\u00020$2\u0006\u0010\u001f\u001a\u00020$2\u0006\u0010 \u001a\u00020$2\u0006\u0010%\u001a\u00020&H\u0016ø\u0001\u0000¢\u0006\u0004\b'\u0010(J\u001b\u0010)\u001a\u00020\u001e2\u0006\u0010 \u001a\u00020\u001eH\u0096@ø\u0001\u0000¢\u0006\u0004\b*\u0010+J\"\u0010,\u001a\u00020$2\u0006\u0010 \u001a\u00020$2\u0006\u0010%\u001a\u00020&H\u0016ø\u0001\u0000¢\u0006\u0004\b-\u0010.J\b\u0010/\u001a\u00020\u001bH\u0002J\u0012\u00100\u001a\u00020\u001b2\b\u00101\u001a\u0004\u0018\u00010\u0006H\u0002J\b\u00102\u001a\u00020\u001bH\u0002J\u001f\u00103\u001a\u00020\u001b2\u0006\u0010\u0004\u001a\u00020\u00022\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006H\u0000¢\u0006\u0002\b4R\u001a\u0010\u0004\u001a\u00020\u0002X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\b\u0010\t\"\u0004\b\n\u0010\u000bR\u0014\u0010\f\u001a\u00020\r8BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\u000e\u0010\u000fR\u0016\u0010\u0010\u001a\u0004\u0018\u00010\u00028BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\u0011\u0010\tR\u0016\u0010\u0012\u001a\u0004\u0018\u00010\u00008@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b\u0013\u0010\u0014R\u000e\u0010\u0015\u001a\u00020\u0006X\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010\u0016\u001a\u00020\u0017X\u0096D¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0019\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u00065"}, d2 = {"Landroidx/compose/ui/input/nestedscroll/NestedScrollNode;", "Landroidx/compose/ui/node/TraversableNode;", "Landroidx/compose/ui/input/nestedscroll/NestedScrollConnection;", "Landroidx/compose/ui/Modifier$Node;", "connection", "dispatcher", "Landroidx/compose/ui/input/nestedscroll/NestedScrollDispatcher;", "(Landroidx/compose/ui/input/nestedscroll/NestedScrollConnection;Landroidx/compose/ui/input/nestedscroll/NestedScrollDispatcher;)V", "getConnection", "()Landroidx/compose/ui/input/nestedscroll/NestedScrollConnection;", "setConnection", "(Landroidx/compose/ui/input/nestedscroll/NestedScrollConnection;)V", "nestedCoroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "getNestedCoroutineScope", "()Lkotlinx/coroutines/CoroutineScope;", "parentConnection", "getParentConnection", "parentNestedScrollNode", "getParentNestedScrollNode$ui_release", "()Landroidx/compose/ui/input/nestedscroll/NestedScrollNode;", "resolvedDispatcher", "traverseKey", "", "getTraverseKey", "()Ljava/lang/Object;", "onAttach", "", "onDetach", "onPostFling", "Landroidx/compose/ui/unit/Velocity;", "consumed", "available", "onPostFling-RZ2iAVY", "(JJLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "onPostScroll", "Landroidx/compose/ui/geometry/Offset;", "source", "Landroidx/compose/ui/input/nestedscroll/NestedScrollSource;", "onPostScroll-DzOQY0M", "(JJI)J", "onPreFling", "onPreFling-QWom1Mo", "(JLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "onPreScroll", "onPreScroll-OzD1aCk", "(JI)J", "resetDispatcherFields", "updateDispatcher", "newDispatcher", "updateDispatcherFields", "updateNode", "updateNode$ui_release", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class NestedScrollNode extends Modifier.Node implements TraversableNode, NestedScrollConnection {
    public static final int $stable = 8;
    private NestedScrollConnection connection;
    private NestedScrollDispatcher resolvedDispatcher;
    private final Object traverseKey;

    public final NestedScrollConnection getConnection() {
        return this.connection;
    }

    public final void setConnection(NestedScrollConnection nestedScrollConnection) {
        this.connection = nestedScrollConnection;
    }

    public NestedScrollNode(NestedScrollConnection nestedScrollConnection, NestedScrollDispatcher nestedScrollDispatcher) {
        this.connection = nestedScrollConnection;
        this.resolvedDispatcher = nestedScrollDispatcher == null ? new NestedScrollDispatcher() : nestedScrollDispatcher;
        this.traverseKey = "androidx.compose.ui.input.nestedscroll.NestedScrollNode";
    }

    public final NestedScrollNode getParentNestedScrollNode$ui_release() {
        if (getIsAttached()) {
            return (NestedScrollNode) TraversableNodeKt.findNearestAncestor(this);
        }
        return null;
    }

    private final NestedScrollConnection getParentConnection() {
        if (getIsAttached()) {
            return getParentNestedScrollNode$ui_release();
        }
        return null;
    }

    @Override
    public Object getTraverseKey() {
        return this.traverseKey;
    }

    public final CoroutineScope getNestedCoroutineScope() {
        CoroutineScope scope$ui_release;
        NestedScrollNode parentNestedScrollNode$ui_release = getParentNestedScrollNode$ui_release();
        if ((parentNestedScrollNode$ui_release == null || (scope$ui_release = parentNestedScrollNode$ui_release.getNestedCoroutineScope()) == null) && (scope$ui_release = this.resolvedDispatcher.getScope()) == null) {
            throw new IllegalStateException("in order to access nested coroutine scope you need to attach dispatcher to the `Modifier.nestedScroll` first.");
        }
        return scope$ui_release;
    }

    @Override
    public long mo831onPreScrollOzD1aCk(long available, int source) {
        NestedScrollConnection parentConnection = getParentConnection();
        long jMo831onPreScrollOzD1aCk = parentConnection != null ? parentConnection.mo831onPreScrollOzD1aCk(available, source) : Offset.INSTANCE.m4362getZeroF1C5BW0();
        return Offset.m4351plusMKHz9U(jMo831onPreScrollOzD1aCk, this.connection.mo831onPreScrollOzD1aCk(Offset.m4350minusMKHz9U(available, jMo831onPreScrollOzD1aCk), source));
    }

    @Override
    public long mo829onPostScrollDzOQY0M(long consumed, long available, int source) {
        long jM4362getZeroF1C5BW0;
        long jMo829onPostScrollDzOQY0M = this.connection.mo829onPostScrollDzOQY0M(consumed, available, source);
        NestedScrollConnection parentConnection = getParentConnection();
        if (parentConnection != null) {
            jM4362getZeroF1C5BW0 = parentConnection.mo829onPostScrollDzOQY0M(Offset.m4351plusMKHz9U(consumed, jMo829onPostScrollDzOQY0M), Offset.m4350minusMKHz9U(available, jMo829onPostScrollDzOQY0M), source);
        } else {
            jM4362getZeroF1C5BW0 = Offset.INSTANCE.m4362getZeroF1C5BW0();
        }
        return Offset.m4351plusMKHz9U(jMo829onPostScrollDzOQY0M, jM4362getZeroF1C5BW0);
    }

    @Override
    public Object mo830onPreFlingQWom1Mo(long j, Continuation<? super Velocity> continuation) {
        NestedScrollNode$onPreFling$1 nestedScrollNode$onPreFling$1;
        long j2;
        NestedScrollNode nestedScrollNode;
        long j3;
        if (continuation instanceof NestedScrollNode$onPreFling$1) {
            nestedScrollNode$onPreFling$1 = (NestedScrollNode$onPreFling$1) continuation;
            if ((nestedScrollNode$onPreFling$1.label & Integer.MIN_VALUE) != 0) {
                nestedScrollNode$onPreFling$1.label -= Integer.MIN_VALUE;
            } else {
                nestedScrollNode$onPreFling$1 = new NestedScrollNode$onPreFling$1(this, continuation);
            }
        } else {
            nestedScrollNode$onPreFling$1 = new NestedScrollNode$onPreFling$1(this, continuation);
        }
        Object objMo830onPreFlingQWom1Mo = nestedScrollNode$onPreFling$1.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = nestedScrollNode$onPreFling$1.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objMo830onPreFlingQWom1Mo);
            NestedScrollConnection parentConnection = getParentConnection();
            if (parentConnection != null) {
                nestedScrollNode$onPreFling$1.L$0 = this;
                nestedScrollNode$onPreFling$1.J$0 = j;
                nestedScrollNode$onPreFling$1.label = 1;
                objMo830onPreFlingQWom1Mo = parentConnection.mo830onPreFlingQWom1Mo(j, nestedScrollNode$onPreFling$1);
                if (objMo830onPreFlingQWom1Mo == coroutine_suspended) {
                    return coroutine_suspended;
                }
                nestedScrollNode = this;
            } else {
                j2 = Velocity.Companion.getZero-9UxMQ8M();
                nestedScrollNode = this;
            }
            long j4 = j;
            j3 = j2;
            NestedScrollConnection nestedScrollConnection = nestedScrollNode.connection;
            long j5 = Velocity.minus-AH228Gc(j4, j3);
            nestedScrollNode$onPreFling$1.L$0 = null;
            nestedScrollNode$onPreFling$1.J$0 = j3;
            nestedScrollNode$onPreFling$1.label = 2;
            objMo830onPreFlingQWom1Mo = nestedScrollConnection.mo830onPreFlingQWom1Mo(j5, nestedScrollNode$onPreFling$1);
            if (objMo830onPreFlingQWom1Mo == coroutine_suspended) {
                return coroutine_suspended;
            }
            return Velocity.box-impl(Velocity.plus-AH228Gc(j3, ((Velocity) objMo830onPreFlingQWom1Mo).unbox-impl()));
        }
        if (i == 1) {
            j = nestedScrollNode$onPreFling$1.J$0;
            nestedScrollNode = (NestedScrollNode) nestedScrollNode$onPreFling$1.L$0;
            ResultKt.throwOnFailure(objMo830onPreFlingQWom1Mo);
        } else {
            if (i != 2) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            j3 = nestedScrollNode$onPreFling$1.J$0;
            ResultKt.throwOnFailure(objMo830onPreFlingQWom1Mo);
        }
        return Velocity.box-impl(Velocity.plus-AH228Gc(j3, ((Velocity) objMo830onPreFlingQWom1Mo).unbox-impl()));
        j2 = ((Velocity) objMo830onPreFlingQWom1Mo).unbox-impl();
        long j6 = j;
        j3 = j2;
        NestedScrollConnection nestedScrollConnection2 = nestedScrollNode.connection;
        long j7 = Velocity.minus-AH228Gc(j6, j3);
        nestedScrollNode$onPreFling$1.L$0 = null;
        nestedScrollNode$onPreFling$1.J$0 = j3;
        nestedScrollNode$onPreFling$1.label = 2;
        objMo830onPreFlingQWom1Mo = nestedScrollConnection2.mo830onPreFlingQWom1Mo(j7, nestedScrollNode$onPreFling$1);
        if (objMo830onPreFlingQWom1Mo == coroutine_suspended) {
            return coroutine_suspended;
        }
        return Velocity.box-impl(Velocity.plus-AH228Gc(j3, ((Velocity) objMo830onPreFlingQWom1Mo).unbox-impl()));
    }

    @Override
    public Object mo828onPostFlingRZ2iAVY(long j, long j2, Continuation<? super Velocity> continuation) {
        NestedScrollNode$onPostFling$1 nestedScrollNode$onPostFling$1;
        long j3;
        long j4;
        NestedScrollNode nestedScrollNode;
        long j5;
        long j6;
        long j7;
        if (continuation instanceof NestedScrollNode$onPostFling$1) {
            nestedScrollNode$onPostFling$1 = (NestedScrollNode$onPostFling$1) continuation;
            if ((nestedScrollNode$onPostFling$1.label & Integer.MIN_VALUE) != 0) {
                nestedScrollNode$onPostFling$1.label -= Integer.MIN_VALUE;
            } else {
                nestedScrollNode$onPostFling$1 = new NestedScrollNode$onPostFling$1(this, continuation);
            }
        } else {
            nestedScrollNode$onPostFling$1 = new NestedScrollNode$onPostFling$1(this, continuation);
        }
        Object objMo828onPostFlingRZ2iAVY = nestedScrollNode$onPostFling$1.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = nestedScrollNode$onPostFling$1.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objMo828onPostFlingRZ2iAVY);
            NestedScrollConnection nestedScrollConnection = this.connection;
            nestedScrollNode$onPostFling$1.L$0 = this;
            j3 = j;
            nestedScrollNode$onPostFling$1.J$0 = j3;
            j4 = j2;
            nestedScrollNode$onPostFling$1.J$1 = j4;
            nestedScrollNode$onPostFling$1.label = 1;
            objMo828onPostFlingRZ2iAVY = nestedScrollConnection.mo828onPostFlingRZ2iAVY(j, j2, nestedScrollNode$onPostFling$1);
            if (objMo828onPostFlingRZ2iAVY == coroutine_suspended) {
                return coroutine_suspended;
            }
            nestedScrollNode = this;
        } else {
            if (i == 1) {
                long j8 = nestedScrollNode$onPostFling$1.J$1;
                long j9 = nestedScrollNode$onPostFling$1.J$0;
                nestedScrollNode = (NestedScrollNode) nestedScrollNode$onPostFling$1.L$0;
                ResultKt.throwOnFailure(objMo828onPostFlingRZ2iAVY);
                j4 = j8;
                j3 = j9;
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                j7 = nestedScrollNode$onPostFling$1.J$0;
                ResultKt.throwOnFailure(objMo828onPostFlingRZ2iAVY);
            }
            j6 = ((Velocity) objMo828onPostFlingRZ2iAVY).unbox-impl();
            j5 = j7;
            return Velocity.box-impl(Velocity.plus-AH228Gc(j5, j6));
        }
        long j10 = ((Velocity) objMo828onPostFlingRZ2iAVY).unbox-impl();
        NestedScrollConnection parentConnection = nestedScrollNode.getParentConnection();
        if (parentConnection != null) {
            long j11 = Velocity.plus-AH228Gc(j3, j10);
            long j12 = Velocity.minus-AH228Gc(j4, j10);
            nestedScrollNode$onPostFling$1.L$0 = null;
            nestedScrollNode$onPostFling$1.J$0 = j10;
            nestedScrollNode$onPostFling$1.label = 2;
            objMo828onPostFlingRZ2iAVY = parentConnection.mo828onPostFlingRZ2iAVY(j11, j12, nestedScrollNode$onPostFling$1);
            if (objMo828onPostFlingRZ2iAVY == coroutine_suspended) {
                return coroutine_suspended;
            }
            j7 = j10;
            j6 = ((Velocity) objMo828onPostFlingRZ2iAVY).unbox-impl();
            j5 = j7;
        } else {
            j5 = j10;
            j6 = Velocity.Companion.getZero-9UxMQ8M();
        }
        return Velocity.box-impl(Velocity.plus-AH228Gc(j5, j6));
    }

    private final void updateDispatcher(NestedScrollDispatcher newDispatcher) {
        resetDispatcherFields();
        if (newDispatcher == null) {
            this.resolvedDispatcher = new NestedScrollDispatcher();
        } else if (!Intrinsics.areEqual(newDispatcher, this.resolvedDispatcher)) {
            this.resolvedDispatcher = newDispatcher;
        }
        if (getIsAttached()) {
            updateDispatcherFields();
        }
    }

    @Override
    public void onAttach() {
        updateDispatcherFields();
    }

    @Override
    public void onDetach() {
        resetDispatcherFields();
    }

    private final void updateDispatcherFields() {
        this.resolvedDispatcher.setNestedScrollNode$ui_release(this);
        this.resolvedDispatcher.setCalculateNestedScrollScope$ui_release(new Function0<CoroutineScope>() {
            {
                super(0);
            }

            public final CoroutineScope invoke() {
                return NestedScrollNode.this.getNestedCoroutineScope();
            }
        });
        this.resolvedDispatcher.setScope$ui_release(getCoroutineScope());
    }

    private final void resetDispatcherFields() {
        if (this.resolvedDispatcher.getNestedScrollNode() == this) {
            this.resolvedDispatcher.setNestedScrollNode$ui_release(null);
        }
    }

    public final void updateNode$ui_release(NestedScrollConnection connection, NestedScrollDispatcher dispatcher) {
        this.connection = connection;
        updateDispatcher(dispatcher);
    }
}
