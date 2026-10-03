package androidx.compose.p002ui.layout;

import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.p002ui.internal.InlineClassHelperKt;
import androidx.compose.p002ui.node.LayoutNode;
import androidx.compose.p002ui.node.LayoutNodeKt;
import androidx.compose.p002ui.node.LayoutNodeLayoutDelegate;
import androidx.compose.p002ui.node.LookaheadDelegate;
import androidx.compose.p002ui.node.NodeChain;
import androidx.compose.p002ui.node.TraversableNode;
import androidx.compose.p002ui.node.TraversableNodeKt;
import androidx.compose.p002ui.platform.Wrapper_androidKt;
import androidx.compose.runtime.ComposeNodeLifecycleCallback;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionContext;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.ReusableComposition;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import androidx.compose.runtime.collection.MutableVector;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.runtime.snapshots.Snapshot;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.DpRect;
import androidx.compose.ui.unit.FontScaling;
import androidx.compose.ui.unit.LayoutDirection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000´\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010%\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\f\n\u0002\u0010\u000b\n\u0002\b\b\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\f\b\u0000\u0018\u00002\u00020\u0001:\u0003cdeB\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J%\u0010+\u001a\u00020,2\u001d\u0010-\u001a\u0019\u0012\u0004\u0012\u00020/\u0012\u0004\u0012\u000200\u0012\u0004\u0012\u0002010.¢\u0006\u0002\b2J!\u00103\u001a\u0002012\u0006\u00104\u001a\u0002012\u000e\b\u0004\u00105\u001a\b\u0012\u0004\u0012\u00020706H\u0082\bJ\u0010\u00108\u001a\u00020\u00032\u0006\u00109\u001a\u00020\u0010H\u0002J\b\u0010:\u001a\u000207H\u0002J\u000e\u0010;\u001a\u0002072\u0006\u0010<\u001a\u00020\u0010J\b\u0010=\u001a\u000207H\u0002J\u0006\u0010>\u001a\u000207J\u0012\u0010?\u001a\u0004\u0018\u00010\u00182\u0006\u00109\u001a\u00020\u0010H\u0002J\u0017\u0010@\u001a\u0002072\f\u0010-\u001a\b\u0012\u0004\u0012\u00020706H\u0082\bJ\u0006\u0010A\u001a\u000207J\u0010\u0010B\u001a\u0002072\u0006\u0010C\u001a\u00020DH\u0002J\"\u0010E\u001a\u0002072\u0006\u0010F\u001a\u00020\u00102\u0006\u0010G\u001a\u00020\u00102\b\b\u0002\u0010H\u001a\u00020\u0010H\u0002J\b\u0010I\u001a\u000207H\u0016J\b\u0010J\u001a\u000207H\u0016J\b\u0010K\u001a\u000207H\u0016J0\u0010L\u001a\b\u0012\u0004\u0012\u00020N0M2\b\u0010O\u001a\u0004\u0018\u00010\u00182\u0011\u0010P\u001a\r\u0012\u0004\u0012\u00020706¢\u0006\u0002\bQH\u0002¢\u0006\u0002\u0010RJ(\u0010S\u001a\u00020\u001d2\b\u0010O\u001a\u0004\u0018\u00010\u00182\u0011\u0010P\u001a\r\u0012\u0004\u0012\u00020706¢\u0006\u0002\bQ¢\u0006\u0002\u0010TJ\u0018\u0010U\u001a\u0002072\u0006\u0010V\u001a\u00020\u00032\u0006\u0010W\u001a\u00020\u0014H\u0002J2\u0010U\u001a\u0002072\u0006\u0010V\u001a\u00020\u00032\b\u0010O\u001a\u0004\u0018\u00010\u00182\u0011\u0010P\u001a\r\u0012\u0004\u0012\u00020706¢\u0006\u0002\bQH\u0002¢\u0006\u0002\u0010XJ.\u0010U\u001a\b\u0012\u0004\u0012\u00020N0M2\b\u0010O\u001a\u0004\u0018\u00010\u00182\u0011\u0010P\u001a\r\u0012\u0004\u0012\u00020706¢\u0006\u0002\bQ¢\u0006\u0002\u0010RJB\u0010Y\u001a\u00020Z2\b\u0010[\u001a\u0004\u0018\u00010Z2\u0006\u0010\\\u001a\u00020\u00032\u0006\u0010]\u001a\u00020D2\u0006\u0010^\u001a\u00020\n2\u0011\u0010_\u001a\r\u0012\u0004\u0012\u00020706¢\u0006\u0002\bQH\u0002¢\u0006\u0002\u0010`J\u0014\u0010a\u001a\u0004\u0018\u00010\u00032\b\u0010O\u001a\u0004\u0018\u00010\u0018H\u0002J\f\u0010b\u001a\u000207*\u00020\u0003H\u0002R\u000e\u0010\u0007\u001a\u00020\bX\u0082D¢\u0006\u0002\n\u0000R\u001c\u0010\t\u001a\u0004\u0018\u00010\nX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000b\u0010\f\"\u0004\b\r\u0010\u000eR\u000e\u0010\u000f\u001a\u00020\u0010X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0011\u001a\u00020\u0010X\u0082\u000e¢\u0006\u0002\n\u0000R*\u0010\u0012\u001a\u001e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00140\u0013j\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u0014`\u0015X\u0082\u0004¢\u0006\u0002\n\u0000R\u0016\u0010\u0016\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00180\u0017X\u0082\u0004¢\u0006\u0002\n\u0000R\u0012\u0010\u0019\u001a\u00060\u001aR\u00020\u0000X\u0082\u0004¢\u0006\u0002\n\u0000R\u001c\u0010\u001b\u001a\u0010\u0012\u0006\u0012\u0004\u0018\u00010\u0018\u0012\u0004\u0012\u00020\u001d0\u001cX\u0082\u0004¢\u0006\u0002\n\u0000R.\u0010\u001e\u001a\"\u0012\u0006\u0012\u0004\u0018\u00010\u0018\u0012\u0004\u0012\u00020\u00030\u0013j\u0010\u0012\u0006\u0012\u0004\u0018\u00010\u0018\u0012\u0004\u0012\u00020\u0003`\u0015X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u001f\u001a\u00020\u0010X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010 \u001a\u00020\u0010X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010!\u001a\u00020\"X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u0012\u0010#\u001a\u00060$R\u00020\u0000X\u0082\u0004¢\u0006\u0002\n\u0000R.\u0010%\u001a\"\u0012\u0006\u0012\u0004\u0018\u00010\u0018\u0012\u0004\u0012\u00020\u00030\u0013j\u0010\u0012\u0006\u0012\u0004\u0018\u00010\u0018\u0012\u0004\u0012\u00020\u0003`\u0015X\u0082\u0004¢\u0006\u0002\n\u0000R$\u0010\u0004\u001a\u00020\u00052\u0006\u0010&\u001a\u00020\u0005@FX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b'\u0010(\"\u0004\b)\u0010*¨\u0006f"}, d2 = {"Landroidx/compose/ui/layout/LayoutNodeSubcompositionsState;", "Landroidx/compose/runtime/ComposeNodeLifecycleCallback;", "root", "Landroidx/compose/ui/node/LayoutNode;", "slotReusePolicy", "Landroidx/compose/ui/layout/SubcomposeSlotReusePolicy;", "(Landroidx/compose/ui/node/LayoutNode;Landroidx/compose/ui/layout/SubcomposeSlotReusePolicy;)V", "NoIntrinsicsMessage", "", "compositionContext", "Landroidx/compose/runtime/CompositionContext;", "getCompositionContext", "()Landroidx/compose/runtime/CompositionContext;", "setCompositionContext", "(Landroidx/compose/runtime/CompositionContext;)V", "currentIndex", "", "currentPostLookaheadIndex", "nodeToNodeState", "Ljava/util/HashMap;", "Landroidx/compose/ui/layout/LayoutNodeSubcompositionsState$NodeState;", "Lkotlin/collections/HashMap;", "postLookaheadComposedSlotIds", "Landroidx/compose/runtime/collection/MutableVector;", "", "postLookaheadMeasureScope", "Landroidx/compose/ui/layout/LayoutNodeSubcompositionsState$PostLookaheadMeasureScopeImpl;", "postLookaheadPrecomposeSlotHandleMap", "", "Landroidx/compose/ui/layout/SubcomposeLayoutState$PrecomposedSlotHandle;", "precomposeMap", "precomposedCount", "reusableCount", "reusableSlotIdsSet", "Landroidx/compose/ui/layout/SubcomposeSlotReusePolicy$SlotIdsSet;", "scope", "Landroidx/compose/ui/layout/LayoutNodeSubcompositionsState$Scope;", "slotIdToNode", "value", "getSlotReusePolicy", "()Landroidx/compose/ui/layout/SubcomposeSlotReusePolicy;", "setSlotReusePolicy", "(Landroidx/compose/ui/layout/SubcomposeSlotReusePolicy;)V", "createMeasurePolicy", "Landroidx/compose/ui/layout/MeasurePolicy;", "block", "Lkotlin/Function2;", "Landroidx/compose/ui/layout/SubcomposeMeasureScope;", "Landroidx/compose/ui/unit/Constraints;", "Landroidx/compose/ui/layout/MeasureResult;", "Lkotlin/ExtensionFunctionType;", "createMeasureResult", "result", "placeChildrenBlock", "Lkotlin/Function0;", "", "createNodeAt", "index", "disposeCurrentNodes", "disposeOrReuseStartingFromIndex", "startIndex", "disposeUnusedSlotsInPostLookahead", "forceRecomposeChildren", "getSlotIdAtIndex", "ignoreRemeasureRequests", "makeSureStateIsConsistent", "markActiveNodesAsReused", "deactivate", "", "move", "from", "to", "count", "onDeactivate", "onRelease", "onReuse", "postLookaheadSubcompose", "", "Landroidx/compose/ui/layout/Measurable;", "slotId", "content", "Landroidx/compose/runtime/Composable;", "(Ljava/lang/Object;Lkotlin/jvm/functions/Function2;)Ljava/util/List;", "precompose", "(Ljava/lang/Object;Lkotlin/jvm/functions/Function2;)Landroidx/compose/ui/layout/SubcomposeLayoutState$PrecomposedSlotHandle;", "subcompose", "node", "nodeState", "(Landroidx/compose/ui/node/LayoutNode;Ljava/lang/Object;Lkotlin/jvm/functions/Function2;)V", "subcomposeInto", "Landroidx/compose/runtime/ReusableComposition;", "existing", "container", "reuseContent", "parent", "composable", "(Landroidx/compose/runtime/ReusableComposition;Landroidx/compose/ui/node/LayoutNode;ZLandroidx/compose/runtime/CompositionContext;Lkotlin/jvm/functions/Function2;)Landroidx/compose/runtime/ReusableComposition;", "takeNodeFromReusables", "resetLayoutState", "NodeState", "PostLookaheadMeasureScopeImpl", "Scope", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class LayoutNodeSubcompositionsState implements ComposeNodeLifecycleCallback {
    public static final int $stable = 8;
    private CompositionContext compositionContext;
    private int currentIndex;
    private int currentPostLookaheadIndex;
    private int precomposedCount;
    private int reusableCount;
    private final LayoutNode root;
    private SubcomposeSlotReusePolicy slotReusePolicy;
    private final HashMap<LayoutNode, NodeState> nodeToNodeState = new HashMap<>();
    private final HashMap<Object, LayoutNode> slotIdToNode = new HashMap<>();
    private final Scope scope = new Scope();
    private final PostLookaheadMeasureScopeImpl postLookaheadMeasureScope = new PostLookaheadMeasureScopeImpl();
    private final HashMap<Object, LayoutNode> precomposeMap = new HashMap<>();
    private final SubcomposeSlotReusePolicy.SlotIdsSet reusableSlotIdsSet = new SubcomposeSlotReusePolicy.SlotIdsSet(null, 1, null);
    private final Map<Object, SubcomposeLayoutState.PrecomposedSlotHandle> postLookaheadPrecomposeSlotHandleMap = new LinkedHashMap();
    private final MutableVector<Object> postLookaheadComposedSlotIds = new MutableVector<>(new Object[16], 0);
    private final String NoIntrinsicsMessage = "Asking for intrinsic measurements of SubcomposeLayout layouts is not supported. This includes components that are built on top of SubcomposeLayout, such as lazy lists, BoxWithConstraints, TabRow, etc. To mitigate this:\n- if intrinsic measurements are used to achieve 'match parent' sizing, consider replacing the parent of the component with a custom layout which controls the order in which children are measured, making intrinsic measurement not needed\n- adding a size modifier to the component, in order to fast return the queried intrinsic measurement.";

    public LayoutNodeSubcompositionsState(LayoutNode layoutNode, SubcomposeSlotReusePolicy subcomposeSlotReusePolicy) {
        this.root = layoutNode;
        this.slotReusePolicy = subcomposeSlotReusePolicy;
    }

    public final CompositionContext getCompositionContext() {
        return this.compositionContext;
    }

    public final void setCompositionContext(CompositionContext compositionContext) {
        this.compositionContext = compositionContext;
    }

    public final SubcomposeSlotReusePolicy getSlotReusePolicy() {
        return this.slotReusePolicy;
    }

    public final void setSlotReusePolicy(SubcomposeSlotReusePolicy subcomposeSlotReusePolicy) {
        if (this.slotReusePolicy != subcomposeSlotReusePolicy) {
            this.slotReusePolicy = subcomposeSlotReusePolicy;
            markActiveNodesAsReused(false);
            LayoutNode.requestRemeasure$ui_release$default(this.root, false, false, false, 7, null);
        }
    }

    @Override
    public void onReuse() {
        markActiveNodesAsReused(false);
    }

    @Override
    public void onDeactivate() {
        markActiveNodesAsReused(true);
    }

    @Override
    public void onRelease() {
        disposeCurrentNodes();
    }

    public final List<Measurable> subcompose(Object slotId, Function2<? super Composer, ? super Integer, Unit> content) throws KotlinNothingValueException {
        makeSureStateIsConsistent();
        LayoutNode.LayoutState layoutState$ui_release = this.root.getLayoutState$ui_release();
        if (!(layoutState$ui_release == LayoutNode.LayoutState.Measuring || layoutState$ui_release == LayoutNode.LayoutState.LayingOut || layoutState$ui_release == LayoutNode.LayoutState.LookaheadMeasuring || layoutState$ui_release == LayoutNode.LayoutState.LookaheadLayingOut)) {
            InlineClassHelperKt.throwIllegalStateException("subcompose can only be used inside the measure or layout blocks");
        }
        HashMap<Object, LayoutNode> map = this.slotIdToNode;
        LayoutNode layoutNodeRemove = map.get(slotId);
        if (layoutNodeRemove == null) {
            layoutNodeRemove = this.precomposeMap.remove(slotId);
            if (layoutNodeRemove != null) {
                if (!(this.precomposedCount > 0)) {
                    InlineClassHelperKt.throwIllegalStateException("Check failed.");
                }
                this.precomposedCount--;
            } else {
                LayoutNode layoutNodeTakeNodeFromReusables = takeNodeFromReusables(slotId);
                if (layoutNodeTakeNodeFromReusables == null) {
                    layoutNodeTakeNodeFromReusables = createNodeAt(this.currentIndex);
                }
                layoutNodeRemove = layoutNodeTakeNodeFromReusables;
            }
            map.put(slotId, layoutNodeRemove);
        }
        LayoutNode layoutNode = layoutNodeRemove;
        if (CollectionsKt.getOrNull(this.root.getFoldedChildren$ui_release(), this.currentIndex) != layoutNode) {
            int iIndexOf = this.root.getFoldedChildren$ui_release().indexOf(layoutNode);
            int i = this.currentIndex;
            if (iIndexOf < i) {
                throw new IllegalArgumentException(("Key \"" + slotId + "\" was already used. If you are using LazyColumn/Row please make sure you provide a unique key for each item.").toString());
            }
            if (i != iIndexOf) {
                move$default(this, iIndexOf, i, 0, 4, null);
            }
        }
        this.currentIndex++;
        subcompose(layoutNode, slotId, content);
        if (layoutState$ui_release == LayoutNode.LayoutState.Measuring || layoutState$ui_release == LayoutNode.LayoutState.LayingOut) {
            return layoutNode.getChildMeasurables$ui_release();
        }
        return layoutNode.getChildLookaheadMeasurables$ui_release();
    }

    private final void subcompose(LayoutNode node, Object slotId, Function2<? super Composer, ? super Integer, Unit> content) {
        HashMap<LayoutNode, NodeState> map = this.nodeToNodeState;
        NodeState nodeState = map.get(node);
        if (nodeState == null) {
            nodeState = new NodeState(slotId, ComposableSingletons$SubcomposeLayoutKt.INSTANCE.m6016getLambda1$ui_release(), null, 4, null);
            map.put(node, nodeState);
        }
        NodeState nodeState2 = nodeState;
        ReusableComposition composition = nodeState2.getComposition();
        boolean hasInvalidations = composition != null ? composition.getHasInvalidations() : true;
        if (nodeState2.getContent() != content || hasInvalidations || nodeState2.getForceRecompose()) {
            nodeState2.setContent(content);
            subcompose(node, nodeState2);
            nodeState2.setForceRecompose(false);
        }
    }

    private final void subcompose(LayoutNode node, final NodeState nodeState) {
        Snapshot.Companion companion = Snapshot.INSTANCE;
        Snapshot currentThreadSnapshot = companion.getCurrentThreadSnapshot();
        Function1<Object, Unit> readObserver = currentThreadSnapshot != null ? currentThreadSnapshot.getReadObserver() : null;
        Snapshot snapshotMakeCurrentNonObservable = companion.makeCurrentNonObservable(currentThreadSnapshot);
        try {
            LayoutNode layoutNode = this.root;
            layoutNode.ignoreRemeasureRequests = true;
            final Function2<Composer, Integer, Unit> content = nodeState.getContent();
            ReusableComposition composition = nodeState.getComposition();
            CompositionContext compositionContext = this.compositionContext;
            if (compositionContext != null) {
                nodeState.setComposition(subcomposeInto(composition, node, nodeState.getForceReuse(), compositionContext, ComposableLambdaKt.composableLambdaInstance(-1750409193, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer, int i) {
                        ComposerKt.sourceInformation(composer, "C493@21310L46:SubcomposeLayout.kt#80mrfh");
                        if ((i & 3) == 2 && composer.getSkipping()) {
                            composer.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1750409193, i, -1, "androidx.compose.ui.layout.LayoutNodeSubcompositionsState.subcompose.<anonymous>.<anonymous>.<anonymous> (SubcomposeLayout.kt:493)");
                        }
                        boolean active = nodeState.getActive();
                        Function2<Composer, Integer, Unit> function2 = content;
                        composer.startReusableGroup(ComposerKt.reuseKey, Boolean.valueOf(active));
                        boolean zChanged = composer.changed(active);
                        composer.startReplaceGroup(-869707859);
                        ComposerKt.sourceInformation(composer, "175@6712L9");
                        if (active) {
                            function2.invoke(composer, 0);
                        } else {
                            composer.deactivateToEndGroup(zChanged);
                        }
                        composer.endReplaceGroup();
                        composer.endReusableGroup();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                })));
                nodeState.setForceReuse(false);
                layoutNode.ignoreRemeasureRequests = false;
                Unit unit = Unit.INSTANCE;
                companion.restoreNonObservable(currentThreadSnapshot, snapshotMakeCurrentNonObservable, readObserver);
                return;
            }
            throw new IllegalStateException("parent composition reference not set".toString());
        } catch (Throwable th) {
            companion.restoreNonObservable(currentThreadSnapshot, snapshotMakeCurrentNonObservable, readObserver);
            throw th;
        }
    }

    private final ReusableComposition subcomposeInto(ReusableComposition existing, LayoutNode container, boolean reuseContent, CompositionContext parent, Function2<? super Composer, ? super Integer, Unit> composable) {
        if (existing == null || existing.getDisposed()) {
            existing = Wrapper_androidKt.createSubcomposition(container, parent);
        }
        if (!reuseContent) {
            existing.setContent(composable);
        } else {
            existing.setContentWithReuse(composable);
        }
        return existing;
    }

    private final Object getSlotIdAtIndex(int index) {
        NodeState nodeState = this.nodeToNodeState.get(this.root.getFoldedChildren$ui_release().get(index));
        Intrinsics.checkNotNull(nodeState);
        return nodeState.getSlotId();
    }

    public final void disposeOrReuseStartingFromIndex(int startIndex) {
        boolean z = false;
        this.reusableCount = 0;
        int size = (this.root.getFoldedChildren$ui_release().size() - this.precomposedCount) - 1;
        if (startIndex <= size) {
            this.reusableSlotIdsSet.clear();
            if (startIndex <= size) {
                int i = startIndex;
                while (true) {
                    this.reusableSlotIdsSet.add(getSlotIdAtIndex(i));
                    if (i == size) {
                        break;
                    } else {
                        i++;
                    }
                }
            }
            this.slotReusePolicy.getSlotsToRetain(this.reusableSlotIdsSet);
            Snapshot.Companion companion = Snapshot.INSTANCE;
            Snapshot currentThreadSnapshot = companion.getCurrentThreadSnapshot();
            Function1<Object, Unit> readObserver = currentThreadSnapshot != null ? currentThreadSnapshot.getReadObserver() : null;
            Snapshot snapshotMakeCurrentNonObservable = companion.makeCurrentNonObservable(currentThreadSnapshot);
            boolean z2 = false;
            while (size >= startIndex) {
                try {
                    LayoutNode layoutNode = this.root.getFoldedChildren$ui_release().get(size);
                    NodeState nodeState = this.nodeToNodeState.get(layoutNode);
                    Intrinsics.checkNotNull(nodeState);
                    NodeState nodeState2 = nodeState;
                    Object slotId = nodeState2.getSlotId();
                    if (this.reusableSlotIdsSet.contains(slotId)) {
                        this.reusableCount++;
                        if (nodeState2.getActive()) {
                            resetLayoutState(layoutNode);
                            nodeState2.setActive(false);
                            z2 = true;
                        }
                    } else {
                        LayoutNode layoutNode2 = this.root;
                        layoutNode2.ignoreRemeasureRequests = true;
                        this.nodeToNodeState.remove(layoutNode);
                        ReusableComposition composition = nodeState2.getComposition();
                        if (composition != null) {
                            composition.dispose();
                        }
                        this.root.removeAt$ui_release(size, 1);
                        layoutNode2.ignoreRemeasureRequests = false;
                    }
                    this.slotIdToNode.remove(slotId);
                    size--;
                } catch (Throwable th) {
                    companion.restoreNonObservable(currentThreadSnapshot, snapshotMakeCurrentNonObservable, readObserver);
                    throw th;
                }
            }
            Unit unit = Unit.INSTANCE;
            companion.restoreNonObservable(currentThreadSnapshot, snapshotMakeCurrentNonObservable, readObserver);
            z = z2;
        }
        if (z) {
            Snapshot.INSTANCE.sendApplyNotifications();
        }
        makeSureStateIsConsistent();
    }

    private final void markActiveNodesAsReused(boolean deactivate) {
        this.precomposedCount = 0;
        this.precomposeMap.clear();
        int size = this.root.getFoldedChildren$ui_release().size();
        if (this.reusableCount != size) {
            this.reusableCount = size;
            Snapshot.Companion companion = Snapshot.INSTANCE;
            Snapshot currentThreadSnapshot = companion.getCurrentThreadSnapshot();
            Function1<Object, Unit> readObserver = currentThreadSnapshot != null ? currentThreadSnapshot.getReadObserver() : null;
            Snapshot snapshotMakeCurrentNonObservable = companion.makeCurrentNonObservable(currentThreadSnapshot);
            for (int i = 0; i < size; i++) {
                try {
                    LayoutNode layoutNode = this.root.getFoldedChildren$ui_release().get(i);
                    NodeState nodeState = this.nodeToNodeState.get(layoutNode);
                    if (nodeState != null && nodeState.getActive()) {
                        resetLayoutState(layoutNode);
                        if (deactivate) {
                            ReusableComposition composition = nodeState.getComposition();
                            if (composition != null) {
                                composition.deactivate();
                            }
                            nodeState.setActiveState(SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(false, null, 2, null));
                        } else {
                            nodeState.setActive(false);
                        }
                        nodeState.setSlotId(SubcomposeLayoutKt.ReusedSlotId);
                    }
                } catch (Throwable th) {
                    companion.restoreNonObservable(currentThreadSnapshot, snapshotMakeCurrentNonObservable, readObserver);
                    throw th;
                }
            }
            Unit unit = Unit.INSTANCE;
            companion.restoreNonObservable(currentThreadSnapshot, snapshotMakeCurrentNonObservable, readObserver);
            this.slotIdToNode.clear();
        }
        makeSureStateIsConsistent();
    }

    private final void disposeCurrentNodes() throws KotlinNothingValueException {
        LayoutNode layoutNode = this.root;
        layoutNode.ignoreRemeasureRequests = true;
        Iterator<T> it = this.nodeToNodeState.values().iterator();
        while (it.hasNext()) {
            ReusableComposition composition = ((NodeState) it.next()).getComposition();
            if (composition != null) {
                composition.dispose();
            }
        }
        this.root.removeAll$ui_release();
        layoutNode.ignoreRemeasureRequests = false;
        this.nodeToNodeState.clear();
        this.slotIdToNode.clear();
        this.precomposedCount = 0;
        this.reusableCount = 0;
        this.precomposeMap.clear();
        makeSureStateIsConsistent();
    }

    public final void makeSureStateIsConsistent() {
        int size = this.root.getFoldedChildren$ui_release().size();
        if (this.nodeToNodeState.size() != size) {
            throw new IllegalArgumentException(("Inconsistency between the count of nodes tracked by the state (" + this.nodeToNodeState.size() + ") and the children count on the SubcomposeLayout (" + size + "). Are you trying to use the state of the disposed SubcomposeLayout?").toString());
        }
        if ((size - this.reusableCount) - this.precomposedCount >= 0) {
            if (this.precomposeMap.size() == this.precomposedCount) {
                return;
            }
            throw new IllegalArgumentException(("Incorrect state. Precomposed children " + this.precomposedCount + ". Map size " + this.precomposeMap.size()).toString());
        }
        throw new IllegalArgumentException(("Incorrect state. Total children " + size + ". Reusable children " + this.reusableCount + ". Precomposed children " + this.precomposedCount).toString());
    }

    private final void resetLayoutState(LayoutNode layoutNode) {
        layoutNode.getMeasurePassDelegate$ui_release().setMeasuredByParent$ui_release(LayoutNode.UsageByParent.NotUsed);
        LayoutNodeLayoutDelegate.LookaheadPassDelegate lookaheadPassDelegate$ui_release = layoutNode.getLookaheadPassDelegate$ui_release();
        if (lookaheadPassDelegate$ui_release != null) {
            lookaheadPassDelegate$ui_release.setMeasuredByParent$ui_release(LayoutNode.UsageByParent.NotUsed);
        }
    }

    private final LayoutNode takeNodeFromReusables(Object slotId) {
        int i;
        if (this.reusableCount == 0) {
            return null;
        }
        int size = this.root.getFoldedChildren$ui_release().size() - this.precomposedCount;
        int i2 = size - this.reusableCount;
        int i3 = size - 1;
        int i4 = i3;
        while (true) {
            if (i4 < i2) {
                i = -1;
                break;
            }
            if (Intrinsics.areEqual(getSlotIdAtIndex(i4), slotId)) {
                i = i4;
                break;
            }
            i4--;
        }
        if (i == -1) {
            while (true) {
                if (i3 < i2) {
                    i4 = i3;
                    break;
                }
                NodeState nodeState = this.nodeToNodeState.get(this.root.getFoldedChildren$ui_release().get(i3));
                Intrinsics.checkNotNull(nodeState);
                NodeState nodeState2 = nodeState;
                if (nodeState2.getSlotId() == SubcomposeLayoutKt.ReusedSlotId || this.slotReusePolicy.areCompatible(slotId, nodeState2.getSlotId())) {
                    nodeState2.setSlotId(slotId);
                    i4 = i3;
                    i = i4;
                    break;
                }
                i3--;
            }
        }
        if (i == -1) {
            return null;
        }
        if (i4 != i2) {
            move(i4, i2, 1);
        }
        this.reusableCount--;
        LayoutNode layoutNode = this.root.getFoldedChildren$ui_release().get(i2);
        NodeState nodeState3 = this.nodeToNodeState.get(layoutNode);
        Intrinsics.checkNotNull(nodeState3);
        NodeState nodeState4 = nodeState3;
        nodeState4.setActiveState(SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(true, null, 2, null));
        nodeState4.setForceReuse(true);
        nodeState4.setForceRecompose(true);
        return layoutNode;
    }

    public final MeasurePolicy createMeasurePolicy(final Function2<? super SubcomposeMeasureScope, ? super Constraints, ? extends MeasureResult> block) {
        return new LayoutNode.NoIntrinsicsMeasurePolicy(this.NoIntrinsicsMessage) {
            @Override
            public MeasureResult mo296measure3p2s80s(MeasureScope measureScope, List<? extends Measurable> list, long j) {
                LayoutNodeSubcompositionsState.this.scope.setLayoutDirection(measureScope.getLayoutDirection());
                LayoutNodeSubcompositionsState.this.scope.setDensity(measureScope.getDensity());
                LayoutNodeSubcompositionsState.this.scope.setFontScale(measureScope.getFontScale());
                if (measureScope.isLookingAhead() || LayoutNodeSubcompositionsState.this.root.getLookaheadRoot() == null) {
                    LayoutNodeSubcompositionsState.this.currentIndex = 0;
                    final MeasureResult measureResult = (MeasureResult) block.invoke(LayoutNodeSubcompositionsState.this.scope, Constraints.box-impl(j));
                    final int i = LayoutNodeSubcompositionsState.this.currentIndex;
                    final LayoutNodeSubcompositionsState layoutNodeSubcompositionsState = LayoutNodeSubcompositionsState.this;
                    return new MeasureResult() {
                        @Override
                        public Map<AlignmentLine, Integer> getAlignmentLines() {
                            return measureResult.getAlignmentLines();
                        }

                        @Override
                        public int get$height() {
                            return measureResult.get$height();
                        }

                        @Override
                        public Function1<RulerScope, Unit> getRulers() {
                            return measureResult.getRulers();
                        }

                        @Override
                        public int get$width() {
                            return measureResult.get$width();
                        }

                        @Override
                        public void placeChildren() {
                            layoutNodeSubcompositionsState.currentIndex = i;
                            measureResult.placeChildren();
                            LayoutNodeSubcompositionsState layoutNodeSubcompositionsState2 = layoutNodeSubcompositionsState;
                            layoutNodeSubcompositionsState2.disposeOrReuseStartingFromIndex(layoutNodeSubcompositionsState2.currentIndex);
                        }
                    };
                }
                LayoutNodeSubcompositionsState.this.currentPostLookaheadIndex = 0;
                final MeasureResult measureResult2 = (MeasureResult) block.invoke(LayoutNodeSubcompositionsState.this.postLookaheadMeasureScope, Constraints.box-impl(j));
                final int i2 = LayoutNodeSubcompositionsState.this.currentPostLookaheadIndex;
                final LayoutNodeSubcompositionsState layoutNodeSubcompositionsState2 = LayoutNodeSubcompositionsState.this;
                return new MeasureResult() {
                    @Override
                    public Map<AlignmentLine, Integer> getAlignmentLines() {
                        return measureResult2.getAlignmentLines();
                    }

                    @Override
                    public int get$height() {
                        return measureResult2.get$height();
                    }

                    @Override
                    public Function1<RulerScope, Unit> getRulers() {
                        return measureResult2.getRulers();
                    }

                    @Override
                    public int get$width() {
                        return measureResult2.get$width();
                    }

                    @Override
                    public void placeChildren() {
                        layoutNodeSubcompositionsState2.currentPostLookaheadIndex = i2;
                        measureResult2.placeChildren();
                        layoutNodeSubcompositionsState2.disposeUnusedSlotsInPostLookahead();
                    }
                };
            }
        };
    }

    public final void disposeUnusedSlotsInPostLookahead() {
        CollectionsKt.removeAll(this.postLookaheadPrecomposeSlotHandleMap.entrySet(), new Function1<Map.Entry<Object, SubcomposeLayoutState.PrecomposedSlotHandle>, Boolean>() {
            {
                super(1);
            }

            public final Boolean invoke(Map.Entry<Object, SubcomposeLayoutState.PrecomposedSlotHandle> entry) {
                boolean z;
                Object key = entry.getKey();
                SubcomposeLayoutState.PrecomposedSlotHandle value = entry.getValue();
                int iIndexOf = LayoutNodeSubcompositionsState.this.postLookaheadComposedSlotIds.indexOf(key);
                if (iIndexOf < 0 || iIndexOf >= LayoutNodeSubcompositionsState.this.currentPostLookaheadIndex) {
                    value.dispose();
                    z = true;
                } else {
                    z = false;
                }
                return Boolean.valueOf(z);
            }
        });
    }

    private final MeasureResult createMeasureResult(final MeasureResult result, final Function0<Unit> placeChildrenBlock) {
        return new MeasureResult() {
            @Override
            public Map<AlignmentLine, Integer> getAlignmentLines() {
                return result.getAlignmentLines();
            }

            @Override
            public int get$height() {
                return result.get$height();
            }

            @Override
            public Function1<RulerScope, Unit> getRulers() {
                return result.getRulers();
            }

            @Override
            public int get$width() {
                return result.get$width();
            }

            @Override
            public void placeChildren() {
                placeChildrenBlock.invoke();
            }
        };
    }

    public final SubcomposeLayoutState.PrecomposedSlotHandle precompose(final Object slotId, Function2<? super Composer, ? super Integer, Unit> content) throws KotlinNothingValueException {
        if (!this.root.isAttached()) {
            return new SubcomposeLayoutState.PrecomposedSlotHandle() {
                @Override
                public void dispose() {
                }

                @Override
                public int getPlaceablesCount() {
                    return SubcomposeLayoutState.PrecomposedSlotHandle.CC.$default$getPlaceablesCount(this);
                }

                @Override
                public void mo6093premeasure0kLqBqw(int i, long j) {
                    SubcomposeLayoutState.PrecomposedSlotHandle.CC.m6178$default$premeasure0kLqBqw(this, i, j);
                }

                @Override
                public void traverseDescendants(Object obj, Function1 function1) {
                    SubcomposeLayoutState.PrecomposedSlotHandle.CC.$default$traverseDescendants(this, obj, function1);
                }
            };
        }
        makeSureStateIsConsistent();
        if (!this.slotIdToNode.containsKey(slotId)) {
            this.postLookaheadPrecomposeSlotHandleMap.remove(slotId);
            HashMap<Object, LayoutNode> map = this.precomposeMap;
            LayoutNode layoutNodeTakeNodeFromReusables = map.get(slotId);
            if (layoutNodeTakeNodeFromReusables == null) {
                layoutNodeTakeNodeFromReusables = takeNodeFromReusables(slotId);
                if (layoutNodeTakeNodeFromReusables != null) {
                    move(this.root.getFoldedChildren$ui_release().indexOf(layoutNodeTakeNodeFromReusables), this.root.getFoldedChildren$ui_release().size(), 1);
                    this.precomposedCount++;
                } else {
                    layoutNodeTakeNodeFromReusables = createNodeAt(this.root.getFoldedChildren$ui_release().size());
                    this.precomposedCount++;
                }
                map.put(slotId, layoutNodeTakeNodeFromReusables);
            }
            subcompose(layoutNodeTakeNodeFromReusables, slotId, content);
        }
        return new SubcomposeLayoutState.PrecomposedSlotHandle() {
            @Override
            public void dispose() {
                LayoutNodeSubcompositionsState.this.makeSureStateIsConsistent();
                LayoutNode layoutNode = (LayoutNode) LayoutNodeSubcompositionsState.this.precomposeMap.remove(slotId);
                if (layoutNode != null) {
                    if (LayoutNodeSubcompositionsState.this.precomposedCount > 0) {
                        int iIndexOf = LayoutNodeSubcompositionsState.this.root.getFoldedChildren$ui_release().indexOf(layoutNode);
                        if (iIndexOf < LayoutNodeSubcompositionsState.this.root.getFoldedChildren$ui_release().size() - LayoutNodeSubcompositionsState.this.precomposedCount) {
                            throw new IllegalStateException("Item is not in pre-composed item range".toString());
                        }
                        LayoutNodeSubcompositionsState.this.reusableCount++;
                        LayoutNodeSubcompositionsState.this.precomposedCount--;
                        int size = (LayoutNodeSubcompositionsState.this.root.getFoldedChildren$ui_release().size() - LayoutNodeSubcompositionsState.this.precomposedCount) - LayoutNodeSubcompositionsState.this.reusableCount;
                        LayoutNodeSubcompositionsState.this.move(iIndexOf, size, 1);
                        LayoutNodeSubcompositionsState.this.disposeOrReuseStartingFromIndex(size);
                        return;
                    }
                    throw new IllegalStateException("No pre-composed items to dispose".toString());
                }
            }

            @Override
            public int getPlaceablesCount() {
                List<LayoutNode> children$ui_release;
                LayoutNode layoutNode = (LayoutNode) LayoutNodeSubcompositionsState.this.precomposeMap.get(slotId);
                if (layoutNode == null || (children$ui_release = layoutNode.getChildren$ui_release()) == null) {
                    return 0;
                }
                return children$ui_release.size();
            }

            @Override
            public void mo6093premeasure0kLqBqw(int index, long constraints) {
                LayoutNode layoutNode = (LayoutNode) LayoutNodeSubcompositionsState.this.precomposeMap.get(slotId);
                if (layoutNode == null || !layoutNode.isAttached()) {
                    return;
                }
                int size = layoutNode.getChildren$ui_release().size();
                if (index < 0 || index >= size) {
                    throw new IndexOutOfBoundsException("Index (" + index + ") is out of bound of [0, " + size + ')');
                }
                if (!layoutNode.isPlaced()) {
                    LayoutNode layoutNode2 = LayoutNodeSubcompositionsState.this.root;
                    layoutNode2.ignoreRemeasureRequests = true;
                    LayoutNodeKt.requireOwner(layoutNode).mo6423measureAndLayout0kLqBqw(layoutNode.getChildren$ui_release().get(index), constraints);
                    layoutNode2.ignoreRemeasureRequests = false;
                    return;
                }
                throw new IllegalArgumentException("Pre-measure called on node that is not placed".toString());
            }

            @Override
            public void traverseDescendants(Object key, Function1<? super TraversableNode, ? extends TraversableNode.Companion.TraverseDescendantsAction> block) {
                NodeChain nodes;
                Modifier.Node head;
                LayoutNode layoutNode = (LayoutNode) LayoutNodeSubcompositionsState.this.precomposeMap.get(slotId);
                if (layoutNode == null || (nodes = layoutNode.getNodes()) == null || (head = nodes.getHead()) == null) {
                    return;
                }
                TraversableNodeKt.traverseDescendants(head, key, block);
            }
        };
    }

    public final void forceRecomposeChildren() {
        if (this.reusableCount != this.root.getFoldedChildren$ui_release().size()) {
            Iterator<Map.Entry<LayoutNode, NodeState>> it = this.nodeToNodeState.entrySet().iterator();
            while (it.hasNext()) {
                it.next().getValue().setForceRecompose(true);
            }
            if (this.root.getMeasurePending$ui_release()) {
                return;
            }
            LayoutNode.requestRemeasure$ui_release$default(this.root, false, false, false, 7, null);
        }
    }

    private final LayoutNode createNodeAt(int index) throws KotlinNothingValueException {
        LayoutNode layoutNode = new LayoutNode(true, 0, 2, null);
        LayoutNode layoutNode2 = this.root;
        layoutNode2.ignoreRemeasureRequests = true;
        this.root.insertAt$ui_release(index, layoutNode);
        layoutNode2.ignoreRemeasureRequests = false;
        return layoutNode;
    }

    static void move$default(LayoutNodeSubcompositionsState layoutNodeSubcompositionsState, int i, int i2, int i3, int i4, Object obj) {
        if ((i4 & 4) != 0) {
            i3 = 1;
        }
        layoutNodeSubcompositionsState.move(i, i2, i3);
    }

    private final void ignoreRemeasureRequests(Function0<Unit> block) {
        LayoutNode layoutNode = this.root;
        layoutNode.ignoreRemeasureRequests = true;
        block.invoke();
        layoutNode.ignoreRemeasureRequests = false;
    }

    @Metadata(d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0018\b\u0002\u0018\u00002\u00020\u0001B.\u0012\b\u0010\u0002\u001a\u0004\u0018\u00010\u0001\u0012\u0011\u0010\u0003\u001a\r\u0012\u0004\u0012\u00020\u00050\u0004¢\u0006\u0002\b\u0006\u0012\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\b¢\u0006\u0002\u0010\tR$\u0010\f\u001a\u00020\u000b2\u0006\u0010\n\u001a\u00020\u000b8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\b\r\u0010\u000e\"\u0004\b\u000f\u0010\u0010R \u0010\u0011\u001a\b\u0012\u0004\u0012\u00020\u000b0\u0012X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0013\u0010\u0014\"\u0004\b\u0015\u0010\u0016R\u001c\u0010\u0007\u001a\u0004\u0018\u00010\bX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0017\u0010\u0018\"\u0004\b\u0019\u0010\u001aR'\u0010\u0003\u001a\r\u0012\u0004\u0012\u00020\u00050\u0004¢\u0006\u0002\b\u0006X\u0086\u000e¢\u0006\u0010\n\u0002\u0010\u001f\u001a\u0004\b\u001b\u0010\u001c\"\u0004\b\u001d\u0010\u001eR\u001a\u0010 \u001a\u00020\u000bX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b!\u0010\u000e\"\u0004\b\"\u0010\u0010R\u001a\u0010#\u001a\u00020\u000bX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b$\u0010\u000e\"\u0004\b%\u0010\u0010R\u001c\u0010\u0002\u001a\u0004\u0018\u00010\u0001X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b&\u0010'\"\u0004\b(\u0010)¨\u0006*"}, d2 = {"Landroidx/compose/ui/layout/LayoutNodeSubcompositionsState$NodeState;", "", "slotId", "content", "Lkotlin/Function0;", "", "Landroidx/compose/runtime/Composable;", "composition", "Landroidx/compose/runtime/ReusableComposition;", "(Ljava/lang/Object;Lkotlin/jvm/functions/Function2;Landroidx/compose/runtime/ReusableComposition;)V", "value", "", "active", "getActive", "()Z", "setActive", "(Z)V", "activeState", "Landroidx/compose/runtime/MutableState;", "getActiveState", "()Landroidx/compose/runtime/MutableState;", "setActiveState", "(Landroidx/compose/runtime/MutableState;)V", "getComposition", "()Landroidx/compose/runtime/ReusableComposition;", "setComposition", "(Landroidx/compose/runtime/ReusableComposition;)V", "getContent", "()Lkotlin/jvm/functions/Function2;", "setContent", "(Lkotlin/jvm/functions/Function2;)V", "Lkotlin/jvm/functions/Function2;", "forceRecompose", "getForceRecompose", "setForceRecompose", "forceReuse", "getForceReuse", "setForceReuse", "getSlotId", "()Ljava/lang/Object;", "setSlotId", "(Ljava/lang/Object;)V", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    static final class NodeState {
        private MutableState<Boolean> activeState;
        private ReusableComposition composition;
        private Function2<? super Composer, ? super Integer, Unit> content;
        private boolean forceRecompose;
        private boolean forceReuse;
        private Object slotId;

        public NodeState(Object obj, Function2<? super Composer, ? super Integer, Unit> function2, ReusableComposition reusableComposition) {
            this.slotId = obj;
            this.content = function2;
            this.composition = reusableComposition;
            this.activeState = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(true, null, 2, null);
        }

        public NodeState(Object obj, Function2 function2, ReusableComposition reusableComposition, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this(obj, function2, (i & 4) != 0 ? null : reusableComposition);
        }

        public final Object getSlotId() {
            return this.slotId;
        }

        public final void setSlotId(Object obj) {
            this.slotId = obj;
        }

        public final Function2<Composer, Integer, Unit> getContent() {
            return this.content;
        }

        public final void setContent(Function2<? super Composer, ? super Integer, Unit> function2) {
            this.content = function2;
        }

        public final ReusableComposition getComposition() {
            return this.composition;
        }

        public final void setComposition(ReusableComposition reusableComposition) {
            this.composition = reusableComposition;
        }

        public final boolean getForceRecompose() {
            return this.forceRecompose;
        }

        public final void setForceRecompose(boolean z) {
            this.forceRecompose = z;
        }

        public final boolean getForceReuse() {
            return this.forceReuse;
        }

        public final void setForceReuse(boolean z) {
            this.forceReuse = z;
        }

        public final MutableState<Boolean> getActiveState() {
            return this.activeState;
        }

        public final void setActiveState(MutableState<Boolean> mutableState) {
            this.activeState = mutableState;
        }

        public final boolean getActive() {
            return this.activeState.getValue().booleanValue();
        }

        public final void setActive(boolean z) {
            this.activeState.setValue(Boolean.valueOf(z));
        }
    }

    @Metadata(d1 = {"\u0000p\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0002\b\b\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010$\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0082\u0004\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J`\u0010\u0015\u001a\u00020\u00162\u0006\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u00182\u0012\u0010\u001a\u001a\u000e\u0012\u0004\u0012\u00020\u001c\u0012\u0004\u0012\u00020\u00180\u001b2\u0019\u0010\u001d\u001a\u0015\u0012\u0004\u0012\u00020\u001f\u0012\u0004\u0012\u00020 \u0018\u00010\u001e¢\u0006\u0002\b!2\u0017\u0010\"\u001a\u0013\u0012\u0004\u0012\u00020#\u0012\u0004\u0012\u00020 0\u001e¢\u0006\u0002\b!H\u0016J0\u0010$\u001a\b\u0012\u0004\u0012\u00020&0%2\b\u0010'\u001a\u0004\u0018\u00010(2\u0011\u0010)\u001a\r\u0012\u0004\u0012\u00020 0*¢\u0006\u0002\b+H\u0016¢\u0006\u0002\u0010,R\u001a\u0010\u0003\u001a\u00020\u0004X\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0005\u0010\u0006\"\u0004\b\u0007\u0010\bR\u001a\u0010\t\u001a\u00020\u0004X\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\n\u0010\u0006\"\u0004\b\u000b\u0010\bR\u0014\u0010\f\u001a\u00020\r8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\f\u0010\u000eR\u001a\u0010\u000f\u001a\u00020\u0010X\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0011\u0010\u0012\"\u0004\b\u0013\u0010\u0014¨\u0006-"}, d2 = {"Landroidx/compose/ui/layout/LayoutNodeSubcompositionsState$Scope;", "Landroidx/compose/ui/layout/SubcomposeMeasureScope;", "(Landroidx/compose/ui/layout/LayoutNodeSubcompositionsState;)V", "density", "", "getDensity", "()F", "setDensity", "(F)V", "fontScale", "getFontScale", "setFontScale", "isLookingAhead", "", "()Z", "layoutDirection", "Landroidx/compose/ui/unit/LayoutDirection;", "getLayoutDirection", "()Landroidx/compose/ui/unit/LayoutDirection;", "setLayoutDirection", "(Landroidx/compose/ui/unit/LayoutDirection;)V", "layout", "Landroidx/compose/ui/layout/MeasureResult;", "width", "", "height", "alignmentLines", "", "Landroidx/compose/ui/layout/AlignmentLine;", "rulers", "Lkotlin/Function1;", "Landroidx/compose/ui/layout/RulerScope;", "", "Lkotlin/ExtensionFunctionType;", "placementBlock", "Landroidx/compose/ui/layout/Placeable$PlacementScope;", "subcompose", "", "Landroidx/compose/ui/layout/Measurable;", "slotId", "", "content", "Lkotlin/Function0;", "Landroidx/compose/runtime/Composable;", "(Ljava/lang/Object;Lkotlin/jvm/functions/Function2;)Ljava/util/List;", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    final class Scope implements SubcomposeMeasureScope {
        private float density;
        private float fontScale;
        private LayoutDirection layoutDirection = LayoutDirection.Rtl;

        @Override
        public MeasureResult layout(int i, int i2, Map map, Function1 function1) {
            return MeasureScope.CC.$default$layout(this, i, i2, map, function1);
        }

        public int m6081roundToPxR2X_6o(long j) {
            return Density.-CC.$default$roundToPx--R2X_6o(this, j);
        }

        public int m6082roundToPx0680j_4(float f) {
            return Density.-CC.$default$roundToPx-0680j_4(this, f);
        }

        public float m6083toDpGaN1DYA(long j) {
            return FontScaling.-CC.$default$toDp-GaN1DYA(this, j);
        }

        public float m6084toDpu2uoSUM(float f) {
            return Density.-CC.$default$toDp-u2uoSUM(this, f);
        }

        public float m6085toDpu2uoSUM(int i) {
            return Density.-CC.$default$toDp-u2uoSUM(this, i);
        }

        public long m6086toDpSizekrfVVM(long j) {
            return Density.-CC.$default$toDpSize-k-rfVVM(this, j);
        }

        public float m6087toPxR2X_6o(long j) {
            return Density.-CC.$default$toPx--R2X_6o(this, j);
        }

        public float m6088toPx0680j_4(float f) {
            return Density.-CC.$default$toPx-0680j_4(this, f);
        }

        public Rect toRect(DpRect dpRect) {
            return Density.-CC.$default$toRect(this, dpRect);
        }

        public long m6089toSizeXkaWNTQ(long j) {
            return Density.-CC.$default$toSize-XkaWNTQ(this, j);
        }

        public long m6090toSp0xMU5do(float f) {
            return FontScaling.-CC.$default$toSp-0xMU5do(this, f);
        }

        public long m6091toSpkPz2Gy4(float f) {
            return Density.-CC.$default$toSp-kPz2Gy4(this, f);
        }

        public long m6092toSpkPz2Gy4(int i) {
            return Density.-CC.$default$toSp-kPz2Gy4(this, i);
        }

        public Scope() {
        }

        @Override
        public LayoutDirection getLayoutDirection() {
            return this.layoutDirection;
        }

        public void setLayoutDirection(LayoutDirection layoutDirection) {
            this.layoutDirection = layoutDirection;
        }

        public float getDensity() {
            return this.density;
        }

        public void setDensity(float f) {
            this.density = f;
        }

        public float getFontScale() {
            return this.fontScale;
        }

        public void setFontScale(float f) {
            this.fontScale = f;
        }

        @Override
        public boolean isLookingAhead() {
            return LayoutNodeSubcompositionsState.this.root.getLayoutState$ui_release() == LayoutNode.LayoutState.LookaheadLayingOut || LayoutNodeSubcompositionsState.this.root.getLayoutState$ui_release() == LayoutNode.LayoutState.LookaheadMeasuring;
        }

        @Override
        public List<Measurable> subcompose(Object slotId, Function2<? super Composer, ? super Integer, Unit> content) {
            return LayoutNodeSubcompositionsState.this.subcompose(slotId, content);
        }

        @Override
        public MeasureResult layout(final int width, final int height, final Map<AlignmentLine, Integer> alignmentLines, final Function1<? super RulerScope, Unit> rulers, final Function1<? super Placeable.PlacementScope, Unit> placementBlock) {
            if (!((width & (-16777216)) == 0 && ((-16777216) & height) == 0)) {
                InlineClassHelperKt.throwIllegalStateException("Size(" + width + " x " + height + ") is out of range. Each dimension must be between 0 and 16777215.");
            }
            final LayoutNodeSubcompositionsState layoutNodeSubcompositionsState = LayoutNodeSubcompositionsState.this;
            return new MeasureResult() {
                @Override
                public int get$width() {
                    return width;
                }

                @Override
                public int get$height() {
                    return height;
                }

                @Override
                public Map<AlignmentLine, Integer> getAlignmentLines() {
                    return alignmentLines;
                }

                @Override
                public Function1<RulerScope, Unit> getRulers() {
                    return rulers;
                }

                @Override
                public void placeChildren() {
                    LookaheadDelegate lookaheadDelegate;
                    if (!this.isLookingAhead() || (lookaheadDelegate = layoutNodeSubcompositionsState.root.getInnerCoordinator$ui_release().getLookaheadDelegate()) == null) {
                        placementBlock.invoke(layoutNodeSubcompositionsState.root.getInnerCoordinator$ui_release().getPlacementScope());
                    } else {
                        placementBlock.invoke(lookaheadDelegate.getPlacementScope());
                    }
                }
            };
        }
    }

    @Metadata(d1 = {"\u0000\u009c\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010$\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\b\b\u0082\u0004\u0018\u00002\u00020\u00012\u00020\u0002B\u0005¢\u0006\u0002\u0010\u0003Je\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u00142\u0014\b\u0002\u0010\u0016\u001a\u000e\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020\u00140\u00172\u001b\b\u0002\u0010\u0019\u001a\u0015\u0012\u0004\u0012\u00020\u001b\u0012\u0004\u0012\u00020\u001c\u0018\u00010\u001a¢\u0006\u0002\b\u001d2\u0017\u0010\u001e\u001a\u0013\u0012\u0004\u0012\u00020\u001f\u0012\u0004\u0012\u00020\u001c0\u001a¢\u0006\u0002\b\u001dH\u0096\u0001JH\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u00142\u0014\b\u0002\u0010\u0016\u001a\u000e\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020\u00140\u00172\u0017\u0010\u001e\u001a\u0013\u0012\u0004\u0012\u00020\u001f\u0012\u0004\u0012\u00020\u001c0\u001a¢\u0006\u0002\b\u001dH\u0096\u0001J0\u0010 \u001a\b\u0012\u0004\u0012\u00020\"0!2\b\u0010#\u001a\u0004\u0018\u00010$2\u0011\u0010%\u001a\r\u0012\u0004\u0012\u00020\u001c0&¢\u0006\u0002\b'H\u0016¢\u0006\u0002\u0010(J\u0017\u0010)\u001a\u00020\u0014*\u00020*H\u0097\u0001ø\u0001\u0000¢\u0006\u0004\b+\u0010,J\u0017\u0010)\u001a\u00020\u0014*\u00020-H\u0097\u0001ø\u0001\u0000¢\u0006\u0004\b.\u0010/J\u0017\u00100\u001a\u00020**\u00020-H\u0097\u0001ø\u0001\u0000¢\u0006\u0004\b1\u00102J\u001a\u00100\u001a\u00020**\u00020\u0005H\u0097\u0001ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b3\u00104J\u001a\u00100\u001a\u00020**\u00020\u0014H\u0097\u0001ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b3\u00105J\u0017\u00106\u001a\u000207*\u000208H\u0097\u0001ø\u0001\u0000¢\u0006\u0004\b9\u0010:J\u0017\u0010;\u001a\u00020\u0005*\u00020*H\u0097\u0001ø\u0001\u0000¢\u0006\u0004\b<\u00104J\u0017\u0010;\u001a\u00020\u0005*\u00020-H\u0097\u0001ø\u0001\u0000¢\u0006\u0004\b=\u00102J\r\u0010>\u001a\u00020?*\u00020@H\u0097\u0001J\u0017\u0010A\u001a\u000208*\u000207H\u0097\u0001ø\u0001\u0000¢\u0006\u0004\bB\u0010:J\u0017\u0010C\u001a\u00020-*\u00020*H\u0097\u0001ø\u0001\u0000¢\u0006\u0004\bD\u0010EJ\u001a\u0010C\u001a\u00020-*\u00020\u0005H\u0097\u0001ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\bF\u0010EJ\u001a\u0010C\u001a\u00020-*\u00020\u0014H\u0097\u0001ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\bF\u0010GR\u0014\u0010\u0004\u001a\u00020\u00058\u0016X\u0097\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007R\u0014\u0010\b\u001a\u00020\u00058\u0016X\u0097\u0005¢\u0006\u0006\u001a\u0004\b\t\u0010\u0007R\u0014\u0010\n\u001a\u00020\u000b8VX\u0096\u0005¢\u0006\u0006\u001a\u0004\b\n\u0010\fR\u0012\u0010\r\u001a\u00020\u000eX\u0096\u0005¢\u0006\u0006\u001a\u0004\b\u000f\u0010\u0010\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006H"}, d2 = {"Landroidx/compose/ui/layout/LayoutNodeSubcompositionsState$PostLookaheadMeasureScopeImpl;", "Landroidx/compose/ui/layout/SubcomposeMeasureScope;", "Landroidx/compose/ui/layout/MeasureScope;", "(Landroidx/compose/ui/layout/LayoutNodeSubcompositionsState;)V", "density", "", "getDensity", "()F", "fontScale", "getFontScale", "isLookingAhead", "", "()Z", "layoutDirection", "Landroidx/compose/ui/unit/LayoutDirection;", "getLayoutDirection", "()Landroidx/compose/ui/unit/LayoutDirection;", "layout", "Landroidx/compose/ui/layout/MeasureResult;", "width", "", "height", "alignmentLines", "", "Landroidx/compose/ui/layout/AlignmentLine;", "rulers", "Lkotlin/Function1;", "Landroidx/compose/ui/layout/RulerScope;", "", "Lkotlin/ExtensionFunctionType;", "placementBlock", "Landroidx/compose/ui/layout/Placeable$PlacementScope;", "subcompose", "", "Landroidx/compose/ui/layout/Measurable;", "slotId", "", "content", "Lkotlin/Function0;", "Landroidx/compose/runtime/Composable;", "(Ljava/lang/Object;Lkotlin/jvm/functions/Function2;)Ljava/util/List;", "roundToPx", "Landroidx/compose/ui/unit/Dp;", "roundToPx-0680j_4", "(F)I", "Landroidx/compose/ui/unit/TextUnit;", "roundToPx--R2X_6o", "(J)I", "toDp", "toDp-GaN1DYA", "(J)F", "toDp-u2uoSUM", "(F)F", "(I)F", "toDpSize", "Landroidx/compose/ui/unit/DpSize;", "Landroidx/compose/ui/geometry/Size;", "toDpSize-k-rfVVM", "(J)J", "toPx", "toPx-0680j_4", "toPx--R2X_6o", "toRect", "Landroidx/compose/ui/geometry/Rect;", "Landroidx/compose/ui/unit/DpRect;", "toSize", "toSize-XkaWNTQ", "toSp", "toSp-0xMU5do", "(F)J", "toSp-kPz2Gy4", "(I)J", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    private final class PostLookaheadMeasureScopeImpl implements SubcomposeMeasureScope, MeasureScope {
        private final Scope $$delegate_0;

        public float getDensity() {
            return this.$$delegate_0.getDensity();
        }

        public float getFontScale() {
            return this.$$delegate_0.getFontScale();
        }

        @Override
        public LayoutDirection getLayoutDirection() {
            return this.$$delegate_0.getLayoutDirection();
        }

        @Override
        public boolean isLookingAhead() {
            return this.$$delegate_0.isLookingAhead();
        }

        @Override
        public MeasureResult layout(int width, int height, Map<AlignmentLine, Integer> alignmentLines, Function1<? super Placeable.PlacementScope, Unit> placementBlock) {
            return this.$$delegate_0.layout(width, height, alignmentLines, placementBlock);
        }

        @Override
        public MeasureResult layout(int width, int height, Map<AlignmentLine, Integer> alignmentLines, Function1<? super RulerScope, Unit> rulers, Function1<? super Placeable.PlacementScope, Unit> placementBlock) {
            return this.$$delegate_0.layout(width, height, alignmentLines, rulers, placementBlock);
        }

        public int m6069roundToPxR2X_6o(long j) {
            return this.$$delegate_0.m6081roundToPxR2X_6o(j);
        }

        public int m6070roundToPx0680j_4(float f) {
            return this.$$delegate_0.m6082roundToPx0680j_4(f);
        }

        public float m6071toDpGaN1DYA(long j) {
            return this.$$delegate_0.m6083toDpGaN1DYA(j);
        }

        public float m6072toDpu2uoSUM(float f) {
            return this.$$delegate_0.m6084toDpu2uoSUM(f);
        }

        public float m6073toDpu2uoSUM(int i) {
            return this.$$delegate_0.m6085toDpu2uoSUM(i);
        }

        public long m6074toDpSizekrfVVM(long j) {
            return this.$$delegate_0.m6086toDpSizekrfVVM(j);
        }

        public float m6075toPxR2X_6o(long j) {
            return this.$$delegate_0.m6087toPxR2X_6o(j);
        }

        public float m6076toPx0680j_4(float f) {
            return this.$$delegate_0.m6088toPx0680j_4(f);
        }

        public Rect toRect(DpRect dpRect) {
            return this.$$delegate_0.toRect(dpRect);
        }

        public long m6077toSizeXkaWNTQ(long j) {
            return this.$$delegate_0.m6089toSizeXkaWNTQ(j);
        }

        public long m6078toSp0xMU5do(float f) {
            return this.$$delegate_0.m6090toSp0xMU5do(f);
        }

        public long m6079toSpkPz2Gy4(float f) {
            return this.$$delegate_0.m6091toSpkPz2Gy4(f);
        }

        public long m6080toSpkPz2Gy4(int i) {
            return this.$$delegate_0.m6092toSpkPz2Gy4(i);
        }

        public PostLookaheadMeasureScopeImpl() {
            this.$$delegate_0 = LayoutNodeSubcompositionsState.this.scope;
        }

        @Override
        public List<Measurable> subcompose(Object slotId, Function2<? super Composer, ? super Integer, Unit> content) {
            LayoutNode layoutNode = (LayoutNode) LayoutNodeSubcompositionsState.this.slotIdToNode.get(slotId);
            List<Measurable> childMeasurables$ui_release = layoutNode != null ? layoutNode.getChildMeasurables$ui_release() : null;
            return childMeasurables$ui_release != null ? childMeasurables$ui_release : LayoutNodeSubcompositionsState.this.postLookaheadSubcompose(slotId, content);
        }
    }

    public final List<Measurable> postLookaheadSubcompose(Object slotId, Function2<? super Composer, ? super Integer, Unit> content) throws KotlinNothingValueException {
        if (this.postLookaheadComposedSlotIds.getSize() < this.currentPostLookaheadIndex) {
            throw new IllegalArgumentException("Error: currentPostLookaheadIndex cannot be greater than the size of thepostLookaheadComposedSlotIds list.".toString());
        }
        int size = this.postLookaheadComposedSlotIds.getSize();
        int i = this.currentPostLookaheadIndex;
        if (size == i) {
            this.postLookaheadComposedSlotIds.add(slotId);
        } else {
            this.postLookaheadComposedSlotIds.set(i, slotId);
        }
        this.currentPostLookaheadIndex++;
        if (!this.precomposeMap.containsKey(slotId)) {
            this.postLookaheadPrecomposeSlotHandleMap.put(slotId, precompose(slotId, content));
            if (this.root.getLayoutState$ui_release() == LayoutNode.LayoutState.LayingOut) {
                this.root.requestLookaheadRelayout$ui_release(true);
            } else {
                LayoutNode.requestLookaheadRemeasure$ui_release$default(this.root, true, false, false, 6, null);
            }
        }
        LayoutNode layoutNode = this.precomposeMap.get(slotId);
        if (layoutNode != null) {
            List<LayoutNodeLayoutDelegate.MeasurePassDelegate> childDelegates$ui_release = layoutNode.getMeasurePassDelegate$ui_release().getChildDelegates$ui_release();
            int size2 = childDelegates$ui_release.size();
            for (int i2 = 0; i2 < size2; i2++) {
                childDelegates$ui_release.get(i2).markDetachedFromParentLookaheadPass$ui_release();
            }
            if (childDelegates$ui_release != null) {
                return childDelegates$ui_release;
            }
        }
        return CollectionsKt.emptyList();
    }

    public final void move(int from, int to, int count) {
        LayoutNode layoutNode = this.root;
        layoutNode.ignoreRemeasureRequests = true;
        this.root.move$ui_release(from, to, count);
        layoutNode.ignoreRemeasureRequests = false;
    }
}
