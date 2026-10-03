package androidx.compose.foundation.lazy.grid;

import androidx.compose.foundation.MutatePriority;
import androidx.compose.foundation.gestures.ScrollExtensionsKt;
import androidx.compose.foundation.gestures.ScrollScope;
import androidx.compose.foundation.gestures.ScrollableState;
import androidx.compose.foundation.gestures.ScrollableStateKt;
import androidx.compose.foundation.interaction.InteractionSource;
import androidx.compose.foundation.interaction.InteractionSourceKt;
import androidx.compose.foundation.interaction.MutableInteractionSource;
import androidx.compose.foundation.lazy.layout.AwaitFirstLayoutModifier;
import androidx.compose.foundation.lazy.layout.LazyAnimateScrollKt;
import androidx.compose.foundation.lazy.layout.LazyLayoutBeyondBoundsInfo;
import androidx.compose.foundation.lazy.layout.LazyLayoutItemAnimator;
import androidx.compose.foundation.lazy.layout.LazyLayoutPinnedItemList;
import androidx.compose.foundation.lazy.layout.LazyLayoutPrefetchState;
import androidx.compose.foundation.lazy.layout.NestedPrefetchScope;
import androidx.compose.foundation.lazy.layout.ObservableScopeInvalidator;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.layout.Remeasurement;
import androidx.compose.p002ui.layout.RemeasurementModifier;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import androidx.compose.runtime.saveable.ListSaverKt;
import androidx.compose.runtime.saveable.Saver;
import androidx.compose.runtime.saveable.SaverScope;
import androidx.compose.runtime.snapshots.Snapshot;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.Density;
import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.Pair;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.math.MathKt;
import kotlin.ranges.IntRange;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineStart;

@Metadata(d1 = {"\u0000Þ\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\f\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0002\b\u0007\n\u0002\u0010\u0002\n\u0002\b\u0010\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0007\u0018\u0000 \u0091\u00012\u00020\u0001:\u0002\u0091\u0001B\u001b\b\u0016\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0003¢\u0006\u0002\u0010\u0005B%\b\u0007\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ\"\u0010n\u001a\u00020o2\b\b\u0001\u0010p\u001a\u00020\u00032\b\b\u0002\u0010q\u001a\u00020\u0003H\u0086@¢\u0006\u0002\u0010rJ\u001f\u0010s\u001a\u00020o2\u0006\u0010t\u001a\u00020?2\b\b\u0002\u0010u\u001a\u00020\u0014H\u0000¢\u0006\u0002\bvJ\u0010\u0010w\u001a\u00020g2\u0006\u0010x\u001a\u00020gH\u0016J\u0018\u0010y\u001a\u00020o2\u0006\u0010x\u001a\u00020g2\u0006\u00109\u001a\u00020:H\u0002J\u0015\u0010z\u001a\u00020g2\u0006\u0010{\u001a\u00020gH\u0000¢\u0006\u0002\b|J\u001a\u0010}\u001a\u00020o2\b\b\u0001\u0010p\u001a\u00020\u00032\b\b\u0002\u0010q\u001a\u00020\u0003JG\u0010~\u001a\u00020o2\u0007\u0010\u007f\u001a\u00030\u0080\u00012-\u0010\u0081\u0001\u001a(\b\u0001\u0012\u0005\u0012\u00030\u0083\u0001\u0012\u000b\u0012\t\u0012\u0004\u0012\u00020o0\u0084\u0001\u0012\u0007\u0012\u0005\u0018\u00010\u0085\u00010\u0082\u0001¢\u0006\u0003\b\u0086\u0001H\u0096@¢\u0006\u0003\u0010\u0087\u0001J#\u0010\u0088\u0001\u001a\u00020o2\b\b\u0001\u0010p\u001a\u00020\u00032\b\b\u0002\u0010q\u001a\u00020\u0003H\u0086@¢\u0006\u0002\u0010rJ(\u0010\u0089\u0001\u001a\u00020o2\u0006\u0010p\u001a\u00020\u00032\u0006\u0010q\u001a\u00020\u00032\u0007\u0010\u008a\u0001\u001a\u00020\u0014H\u0000¢\u0006\u0003\b\u008b\u0001J\"\u0010\u008c\u0001\u001a\u00020\u00032\b\u0010\u008d\u0001\u001a\u00030\u008e\u00012\u0007\u0010\u008f\u0001\u001a\u00020\u0003H\u0000¢\u0006\u0003\b\u0090\u0001R\u000e\u0010\t\u001a\u00020\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u000b\u001a\u00020\fX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0014\u0010\u000f\u001a\u00020\u0010X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012R+\u0010\u0015\u001a\u00020\u00142\u0006\u0010\u0013\u001a\u00020\u00148V@RX\u0096\u008e\u0002¢\u0006\u0012\n\u0004\b\u001a\u0010\u001b\u001a\u0004\b\u0016\u0010\u0017\"\u0004\b\u0018\u0010\u0019R+\u0010\u001c\u001a\u00020\u00142\u0006\u0010\u0013\u001a\u00020\u00148V@RX\u0096\u008e\u0002¢\u0006\u0012\n\u0004\b\u001f\u0010\u001b\u001a\u0004\b\u001d\u0010\u0017\"\u0004\b\u001e\u0010\u0019R\u0014\u0010 \u001a\u00020!8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b\"\u0010#R\u0011\u0010\u0002\u001a\u00020\u00038F¢\u0006\u0006\u001a\u0004\b$\u0010%R\u0011\u0010\u0004\u001a\u00020\u00038F¢\u0006\u0006\u001a\u0004\b&\u0010%R\u0011\u0010'\u001a\u00020(8F¢\u0006\u0006\u001a\u0004\b)\u0010*R\u0014\u0010+\u001a\u00020,X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b-\u0010.R\u0014\u0010/\u001a\u00020\u00148VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b/\u0010\u0017R\u001a\u00100\u001a\b\u0012\u0004\u0012\u00020201X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b3\u00104R\u0014\u00105\u001a\u00020\u00148VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b6\u0010\u0017R\u0014\u00107\u001a\u00020\u00148VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b8\u0010\u0017R\u0011\u00109\u001a\u00020:8F¢\u0006\u0006\u001a\u0004\b;\u0010<R\u0014\u0010=\u001a\b\u0012\u0004\u0012\u00020?0>X\u0082\u0004¢\u0006\u0002\n\u0000R\u001c\u0010@\u001a\u00020AX\u0080\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u001b\u001a\u0004\bB\u0010CR\u001b\u0010D\u001a\u00020E8@X\u0080\u0084\u0002¢\u0006\f\u001a\u0004\bH\u0010I*\u0004\bF\u0010GR\u001e\u0010J\u001a\u00020\u00032\u0006\u0010\u0013\u001a\u00020\u0003@BX\u0080\u000e¢\u0006\b\n\u0000\u001a\u0004\bK\u0010%R\u0014\u0010L\u001a\u00020\u00038BX\u0082\u0004¢\u0006\u0006\u001a\u0004\bM\u0010%R\u0014\u0010N\u001a\u00020OX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\bP\u0010QR\u001c\u0010R\u001a\u00020AX\u0080\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u001b\u001a\u0004\bS\u0010CR\u000e\u0010T\u001a\u00020UX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010V\u001a\u00020WX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\bX\u0010YR\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u001a\u0010Z\u001a\u00020\u0014X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b[\u0010\u0017\"\u0004\b\\\u0010\u0019R\"\u0010^\u001a\u0004\u0018\u00010]2\b\u0010\u0013\u001a\u0004\u0018\u00010]@BX\u0080\u000e¢\u0006\b\n\u0000\u001a\u0004\b_\u0010`R\u0014\u0010a\u001a\u00020bX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\bc\u0010dR\u000e\u0010e\u001a\u00020fX\u0082\u0004¢\u0006\u0002\n\u0000R\u001e\u0010h\u001a\u00020g2\u0006\u0010\u0013\u001a\u00020g@BX\u0080\u000e¢\u0006\b\n\u0000\u001a\u0004\bi\u0010jR\u000e\u0010k\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010l\u001a\u00020\u00038@X\u0080\u0004¢\u0006\u0006\u001a\u0004\bm\u0010%\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u0092\u0001"}, d2 = {"Landroidx/compose/foundation/lazy/grid/LazyGridState;", "Landroidx/compose/foundation/gestures/ScrollableState;", "firstVisibleItemIndex", "", "firstVisibleItemScrollOffset", "(II)V", "prefetchStrategy", "Landroidx/compose/foundation/lazy/grid/LazyGridPrefetchStrategy;", "(IILandroidx/compose/foundation/lazy/grid/LazyGridPrefetchStrategy;)V", "animateScrollScope", "Landroidx/compose/foundation/lazy/grid/LazyGridAnimateScrollScope;", "awaitLayoutModifier", "Landroidx/compose/foundation/lazy/layout/AwaitFirstLayoutModifier;", "getAwaitLayoutModifier$foundation_release", "()Landroidx/compose/foundation/lazy/layout/AwaitFirstLayoutModifier;", "beyondBoundsInfo", "Landroidx/compose/foundation/lazy/layout/LazyLayoutBeyondBoundsInfo;", "getBeyondBoundsInfo$foundation_release", "()Landroidx/compose/foundation/lazy/layout/LazyLayoutBeyondBoundsInfo;", "<set-?>", "", "canScrollBackward", "getCanScrollBackward", "()Z", "setCanScrollBackward", "(Z)V", "canScrollBackward$delegate", "Landroidx/compose/runtime/MutableState;", "canScrollForward", "getCanScrollForward", "setCanScrollForward", "canScrollForward$delegate", "density", "Landroidx/compose/ui/unit/Density;", "getDensity$foundation_release", "()Landroidx/compose/ui/unit/Density;", "getFirstVisibleItemIndex", "()I", "getFirstVisibleItemScrollOffset", "interactionSource", "Landroidx/compose/foundation/interaction/InteractionSource;", "getInteractionSource", "()Landroidx/compose/foundation/interaction/InteractionSource;", "internalInteractionSource", "Landroidx/compose/foundation/interaction/MutableInteractionSource;", "getInternalInteractionSource$foundation_release", "()Landroidx/compose/foundation/interaction/MutableInteractionSource;", "isScrollInProgress", "itemAnimator", "Landroidx/compose/foundation/lazy/layout/LazyLayoutItemAnimator;", "Landroidx/compose/foundation/lazy/grid/LazyGridMeasuredItem;", "getItemAnimator$foundation_release", "()Landroidx/compose/foundation/lazy/layout/LazyLayoutItemAnimator;", "lastScrolledBackward", "getLastScrolledBackward", "lastScrolledForward", "getLastScrolledForward", "layoutInfo", "Landroidx/compose/foundation/lazy/grid/LazyGridLayoutInfo;", "getLayoutInfo", "()Landroidx/compose/foundation/lazy/grid/LazyGridLayoutInfo;", "layoutInfoState", "Landroidx/compose/runtime/MutableState;", "Landroidx/compose/foundation/lazy/grid/LazyGridMeasureResult;", "measurementScopeInvalidator", "Landroidx/compose/foundation/lazy/layout/ObservableScopeInvalidator;", "getMeasurementScopeInvalidator-zYiylxw$foundation_release", "()Landroidx/compose/runtime/MutableState;", "nearestRange", "Lkotlin/ranges/IntRange;", "getNearestRange$foundation_release$delegate", "(Landroidx/compose/foundation/lazy/grid/LazyGridState;)Ljava/lang/Object;", "getNearestRange$foundation_release", "()Lkotlin/ranges/IntRange;", "numMeasurePasses", "getNumMeasurePasses$foundation_release", "numOfItemsToTeleport", "getNumOfItemsToTeleport", "pinnedItems", "Landroidx/compose/foundation/lazy/layout/LazyLayoutPinnedItemList;", "getPinnedItems$foundation_release", "()Landroidx/compose/foundation/lazy/layout/LazyLayoutPinnedItemList;", "placementScopeInvalidator", "getPlacementScopeInvalidator-zYiylxw$foundation_release", "prefetchScope", "Landroidx/compose/foundation/lazy/grid/LazyGridPrefetchScope;", "prefetchState", "Landroidx/compose/foundation/lazy/layout/LazyLayoutPrefetchState;", "getPrefetchState$foundation_release", "()Landroidx/compose/foundation/lazy/layout/LazyLayoutPrefetchState;", "prefetchingEnabled", "getPrefetchingEnabled$foundation_release", "setPrefetchingEnabled$foundation_release", "Landroidx/compose/ui/layout/Remeasurement;", "remeasurement", "getRemeasurement$foundation_release", "()Landroidx/compose/ui/layout/Remeasurement;", "remeasurementModifier", "Landroidx/compose/ui/layout/RemeasurementModifier;", "getRemeasurementModifier$foundation_release", "()Landroidx/compose/ui/layout/RemeasurementModifier;", "scrollPosition", "Landroidx/compose/foundation/lazy/grid/LazyGridScrollPosition;", "", "scrollToBeConsumed", "getScrollToBeConsumed$foundation_release", "()F", "scrollableState", "slotsPerLine", "getSlotsPerLine$foundation_release", "animateScrollToItem", "", "index", "scrollOffset", "(IILkotlin/coroutines/Continuation;)Ljava/lang/Object;", "applyMeasureResult", "result", "visibleItemsStayedTheSame", "applyMeasureResult$foundation_release", "dispatchRawDelta", "delta", "notifyPrefetchOnScroll", "onScroll", "distance", "onScroll$foundation_release", "requestScrollToItem", "scroll", "scrollPriority", "Landroidx/compose/foundation/MutatePriority;", "block", "Lkotlin/Function2;", "Landroidx/compose/foundation/gestures/ScrollScope;", "Lkotlin/coroutines/Continuation;", "", "Lkotlin/ExtensionFunctionType;", "(Landroidx/compose/foundation/MutatePriority;Lkotlin/jvm/functions/Function2;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "scrollToItem", "snapToItemIndexInternal", "forceRemeasure", "snapToItemIndexInternal$foundation_release", "updateScrollPositionIfTheFirstItemWasMoved", "itemProvider", "Landroidx/compose/foundation/lazy/grid/LazyGridItemProvider;", "firstItemIndex", "updateScrollPositionIfTheFirstItemWasMoved$foundation_release", "Companion", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class LazyGridState implements ScrollableState {
    public static final int $stable = 0;

    public static final Companion INSTANCE = new Companion(null);
    private static final Saver<LazyGridState, ?> Saver = ListSaverKt.listSaver(new Function2<SaverScope, LazyGridState, List<? extends Integer>>() {
        public final List<Integer> invoke(SaverScope saverScope, LazyGridState lazyGridState) {
            return CollectionsKt.listOf(new Integer[]{Integer.valueOf(lazyGridState.getFirstVisibleItemIndex()), Integer.valueOf(lazyGridState.getFirstVisibleItemScrollOffset())});
        }
    }, new Function1<List<? extends Integer>, LazyGridState>() {
        public final LazyGridState invoke(List<Integer> list) {
            return new LazyGridState(list.get(0).intValue(), list.get(1).intValue());
        }
    });
    private final LazyGridAnimateScrollScope animateScrollScope;
    private final AwaitFirstLayoutModifier awaitLayoutModifier;
    private final LazyLayoutBeyondBoundsInfo beyondBoundsInfo;

    private final MutableState canScrollBackward;

    private final MutableState canScrollForward;
    private final MutableInteractionSource internalInteractionSource;
    private final LazyLayoutItemAnimator<LazyGridMeasuredItem> itemAnimator;
    private final MutableState<LazyGridMeasureResult> layoutInfoState;
    private final MutableState<Unit> measurementScopeInvalidator;
    private int numMeasurePasses;
    private final LazyLayoutPinnedItemList pinnedItems;
    private final MutableState<Unit> placementScopeInvalidator;
    private final LazyGridPrefetchScope prefetchScope;
    private final LazyLayoutPrefetchState prefetchState;
    private final LazyGridPrefetchStrategy prefetchStrategy;
    private boolean prefetchingEnabled;
    private Remeasurement remeasurement;
    private final RemeasurementModifier remeasurementModifier;
    private final LazyGridScrollPosition scrollPosition;
    private float scrollToBeConsumed;
    private final ScrollableState scrollableState;

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.lazy.grid.LazyGridState", f = "LazyGridState.kt", i = {0, 0, 0}, l = {370, 371}, m = "scroll", n = {"this", "scrollPriority", "block"}, s = {"L$0", "L$1", "L$2"})
    static final class C06841 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C06841(Continuation<? super C06841> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return LazyGridState.this.scroll(null, null, (Continuation) this);
        }
    }

    public LazyGridState() {
        this(0, 0, null, 7, null);
    }

    public LazyGridState(final int i, int i2, LazyGridPrefetchStrategy lazyGridPrefetchStrategy) {
        this.prefetchStrategy = lazyGridPrefetchStrategy;
        LazyGridScrollPosition lazyGridScrollPosition = new LazyGridScrollPosition(i, i2);
        this.scrollPosition = lazyGridScrollPosition;
        this.layoutInfoState = SnapshotStateKt.mutableStateOf(LazyGridStateKt.EmptyLazyGridLayoutInfo, SnapshotStateKt.neverEqualPolicy());
        this.internalInteractionSource = InteractionSourceKt.MutableInteractionSource();
        this.scrollableState = ScrollableStateKt.ScrollableState(new Function1<Float, Float>() {
            {
                super(1);
            }

            public final Float invoke(float f) {
                return Float.valueOf(-this.this$0.onScroll$foundation_release(-f));
            }

            public Object invoke(Object obj) {
                return invoke(((Number) obj).floatValue());
            }
        });
        this.prefetchingEnabled = true;
        this.remeasurementModifier = new RemeasurementModifier() {
            @Override
            public boolean all(Function1 function1) {
                return Modifier.Element.CC.$default$all(this, function1);
            }

            @Override
            public boolean any(Function1 function1) {
                return Modifier.Element.CC.$default$any(this, function1);
            }

            @Override
            public Object foldIn(Object obj, Function2 function2) {
                return Modifier.Element.CC.$default$foldIn(this, obj, function2);
            }

            @Override
            public Object foldOut(Object obj, Function2 function2) {
                return Modifier.Element.CC.$default$foldOut(this, obj, function2);
            }

            @Override
            public Modifier then(Modifier modifier) {
                return Modifier.CC.$default$then(this, modifier);
            }

            @Override
            public void onRemeasurementAvailable(Remeasurement remeasurement) {
                this.this$0.remeasurement = remeasurement;
            }
        };
        this.awaitLayoutModifier = new AwaitFirstLayoutModifier();
        this.itemAnimator = new LazyLayoutItemAnimator<>();
        this.beyondBoundsInfo = new LazyLayoutBeyondBoundsInfo();
        this.prefetchState = new LazyLayoutPrefetchState(lazyGridPrefetchStrategy.getPrefetchScheduler(), new Function1<NestedPrefetchScope, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((NestedPrefetchScope) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(NestedPrefetchScope nestedPrefetchScope) {
                LazyGridPrefetchStrategy lazyGridPrefetchStrategy2 = this.this$0.prefetchStrategy;
                int i3 = i;
                Snapshot.Companion companion = Snapshot.INSTANCE;
                Snapshot currentThreadSnapshot = companion.getCurrentThreadSnapshot();
                companion.restoreNonObservable(currentThreadSnapshot, companion.makeCurrentNonObservable(currentThreadSnapshot), currentThreadSnapshot != null ? currentThreadSnapshot.getReadObserver() : null);
                lazyGridPrefetchStrategy2.onNestedPrefetch(nestedPrefetchScope, i3);
            }
        });
        this.prefetchScope = new LazyGridPrefetchScope() {
            @Override
            public List<LazyLayoutPrefetchState.PrefetchHandle> scheduleLinePrefetch(int lineIndex) {
                ArrayList arrayList = new ArrayList();
                Snapshot.Companion companion = Snapshot.INSTANCE;
                LazyGridState lazyGridState = this.this$0;
                Snapshot currentThreadSnapshot = companion.getCurrentThreadSnapshot();
                Function1<Object, Unit> readObserver = currentThreadSnapshot != null ? currentThreadSnapshot.getReadObserver() : null;
                Snapshot snapshotMakeCurrentNonObservable = companion.makeCurrentNonObservable(currentThreadSnapshot);
                try {
                    List list = (List) ((LazyGridMeasureResult) lazyGridState.layoutInfoState.getValue()).getPrefetchInfoRetriever().invoke(Integer.valueOf(lineIndex));
                    int size = list.size();
                    for (int i3 = 0; i3 < size; i3++) {
                        Pair pair = (Pair) list.get(i3);
                        arrayList.add(lazyGridState.getPrefetchState().m1243schedulePrefetch0kLqBqw(((Number) pair.getFirst()).intValue(), ((Constraints) pair.getSecond()).unbox-impl()));
                    }
                    Unit unit = Unit.INSTANCE;
                    return arrayList;
                } finally {
                    companion.restoreNonObservable(currentThreadSnapshot, snapshotMakeCurrentNonObservable, readObserver);
                }
            }
        };
        this.animateScrollScope = new LazyGridAnimateScrollScope(this);
        this.pinnedItems = new LazyLayoutPinnedItemList();
        lazyGridScrollPosition.getNearestRangeState();
        this.placementScopeInvalidator = ObservableScopeInvalidator.m1254constructorimpl$default(null, 1, null);
        this.measurementScopeInvalidator = ObservableScopeInvalidator.m1254constructorimpl$default(null, 1, null);
        this.canScrollForward = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(false, null, 2, null);
        this.canScrollBackward = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(false, null, 2, null);
    }

    public LazyGridState(int i, int i2, LazyGridPrefetchStrategy lazyGridPrefetchStrategy, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this((i3 & 1) != 0 ? 0 : i, (i3 & 2) != 0 ? 0 : i2, (i3 & 4) != 0 ? LazyGridPrefetchStrategyKt.LazyGridPrefetchStrategy$default(0, 1, null) : lazyGridPrefetchStrategy);
    }

    public LazyGridState(int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this((i3 & 1) != 0 ? 0 : i, (i3 & 2) != 0 ? 0 : i2);
    }

    public LazyGridState(int i, int i2) {
        this(i, i2, LazyGridPrefetchStrategyKt.LazyGridPrefetchStrategy$default(0, 1, null));
    }

    public final int getFirstVisibleItemIndex() {
        return this.scrollPosition.getIndex();
    }

    public final int getFirstVisibleItemScrollOffset() {
        return this.scrollPosition.getScrollOffset();
    }

    public final LazyGridLayoutInfo getLayoutInfo() {
        return this.layoutInfoState.getValue();
    }

    public final InteractionSource getInteractionSource() {
        return this.internalInteractionSource;
    }

    public final MutableInteractionSource getInternalInteractionSource() {
        return this.internalInteractionSource;
    }

    public final float getScrollToBeConsumed() {
        return this.scrollToBeConsumed;
    }

    public final int getSlotsPerLine$foundation_release() {
        return this.layoutInfoState.getValue().getSlotsPerLine();
    }

    public final Density getDensity$foundation_release() {
        return this.layoutInfoState.getValue().getDensity();
    }

    public final int getNumMeasurePasses() {
        return this.numMeasurePasses;
    }

    public final boolean getPrefetchingEnabled() {
        return this.prefetchingEnabled;
    }

    public final void setPrefetchingEnabled$foundation_release(boolean z) {
        this.prefetchingEnabled = z;
    }

    public final Remeasurement getRemeasurement() {
        return this.remeasurement;
    }

    public final RemeasurementModifier getRemeasurementModifier() {
        return this.remeasurementModifier;
    }

    public final AwaitFirstLayoutModifier getAwaitLayoutModifier() {
        return this.awaitLayoutModifier;
    }

    public final LazyLayoutItemAnimator<LazyGridMeasuredItem> getItemAnimator$foundation_release() {
        return this.itemAnimator;
    }

    public final LazyLayoutBeyondBoundsInfo getBeyondBoundsInfo() {
        return this.beyondBoundsInfo;
    }

    public final LazyLayoutPrefetchState getPrefetchState() {
        return this.prefetchState;
    }

    public final LazyLayoutPinnedItemList getPinnedItems() {
        return this.pinnedItems;
    }

    public final IntRange getNearestRange$foundation_release() {
        return this.scrollPosition.getNearestRangeState().getValue();
    }

    public final MutableState<Unit> m1192getPlacementScopeInvalidatorzYiylxw$foundation_release() {
        return this.placementScopeInvalidator;
    }

    public static Object scrollToItem$default(LazyGridState lazyGridState, int i, int i2, Continuation continuation, int i3, Object obj) {
        if ((i3 & 2) != 0) {
            i2 = 0;
        }
        return lazyGridState.scrollToItem(i, i2, continuation);
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/foundation/gestures/ScrollScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.lazy.grid.LazyGridState$scrollToItem$2", f = "LazyGridState.kt", i = {}, l = {}, m = "invokeSuspend", n = {}, s = {})
    static final class C06852 extends SuspendLambda implements Function2<ScrollScope, Continuation<? super Unit>, Object> {
        final int $index;
        final int $scrollOffset;
        int label;

        C06852(int i, int i2, Continuation<? super C06852> continuation) {
            super(2, continuation);
            this.$index = i;
            this.$scrollOffset = i2;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return LazyGridState.this.new C06852(this.$index, this.$scrollOffset, continuation);
        }

        public final Object invoke(ScrollScope scrollScope, Continuation<? super Unit> continuation) {
            return create(scrollScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            LazyGridState.this.snapToItemIndexInternal$foundation_release(this.$index, this.$scrollOffset, true);
            return Unit.INSTANCE;
        }
    }

    public final Object scrollToItem(int i, int i2, Continuation<? super Unit> continuation) {
        Object objScroll$default = ScrollableState.CC.scroll$default(this, null, new C06852(i, i2, null), continuation, 1, null);
        return objScroll$default == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objScroll$default : Unit.INSTANCE;
    }

    public final MutableState<Unit> m1191getMeasurementScopeInvalidatorzYiylxw$foundation_release() {
        return this.measurementScopeInvalidator;
    }

    public static void requestScrollToItem$default(LazyGridState lazyGridState, int i, int i2, int i3, Object obj) {
        if ((i3 & 2) != 0) {
            i2 = 0;
        }
        lazyGridState.requestScrollToItem(i, i2);
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.lazy.grid.LazyGridState$requestScrollToItem$1", f = "LazyGridState.kt", i = {}, l = {330}, m = "invokeSuspend", n = {}, s = {})
    static final class C06831 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C06831(Continuation<? super C06831> continuation) {
            super(2, continuation);
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return LazyGridState.this.new C06831(continuation);
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (ScrollExtensionsKt.stopScroll$default(LazyGridState.this, null, (Continuation) this, 1, null) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
    }

    public final void requestScrollToItem(int index, int scrollOffset) {
        if (isScrollInProgress()) {
            BuildersKt.launch$default(this.layoutInfoState.getValue().getCoroutineScope(), (CoroutineContext) null, (CoroutineStart) null, new C06831(null), 3, (Object) null);
        }
        snapToItemIndexInternal$foundation_release(index, scrollOffset, false);
    }

    public final void snapToItemIndexInternal$foundation_release(int index, int scrollOffset, boolean forceRemeasure) {
        if (this.scrollPosition.getIndex() != index || this.scrollPosition.getScrollOffset() != scrollOffset) {
            this.itemAnimator.reset();
        }
        this.scrollPosition.requestPositionAndForgetLastKnownKey(index, scrollOffset);
        if (forceRemeasure) {
            Remeasurement remeasurement = this.remeasurement;
            if (remeasurement != null) {
                remeasurement.forceRemeasure();
                return;
            }
            return;
        }
        ObservableScopeInvalidator.m1258invalidateScopeimpl(this.measurementScopeInvalidator);
    }

    @Override
    public Object scroll(MutatePriority mutatePriority, Function2<? super ScrollScope, ? super Continuation<? super Unit>, ? extends Object> function2, Continuation<? super Unit> continuation) {
        C06841 c06841;
        LazyGridState lazyGridState;
        if (continuation instanceof C06841) {
            c06841 = (C06841) continuation;
            if ((c06841.label & Integer.MIN_VALUE) != 0) {
                c06841.label -= Integer.MIN_VALUE;
            } else {
                c06841 = new C06841(continuation);
            }
        } else {
            c06841 = new C06841(continuation);
        }
        Object obj = c06841.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c06841.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            AwaitFirstLayoutModifier awaitFirstLayoutModifier = this.awaitLayoutModifier;
            c06841.L$0 = this;
            c06841.L$1 = mutatePriority;
            c06841.L$2 = function2;
            c06841.label = 1;
            if (awaitFirstLayoutModifier.waitForFirstLayout(c06841) == coroutine_suspended) {
                return coroutine_suspended;
            }
            lazyGridState = this;
        } else {
            if (i == 1) {
                function2 = (Function2) c06841.L$2;
                mutatePriority = (MutatePriority) c06841.L$1;
                lazyGridState = (LazyGridState) c06841.L$0;
                ResultKt.throwOnFailure(obj);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
        ScrollableState scrollableState = lazyGridState.scrollableState;
        c06841.L$0 = null;
        c06841.L$1 = null;
        c06841.L$2 = null;
        c06841.label = 2;
        if (scrollableState.scroll(mutatePriority, function2, c06841) == coroutine_suspended) {
            return coroutine_suspended;
        }
        return Unit.INSTANCE;
    }

    @Override
    public float dispatchRawDelta(float delta) {
        return this.scrollableState.dispatchRawDelta(delta);
    }

    @Override
    public boolean isScrollInProgress() {
        return this.scrollableState.isScrollInProgress();
    }

    private void setCanScrollForward(boolean z) {
        this.canScrollForward.setValue(Boolean.valueOf(z));
    }

    @Override
    public boolean getCanScrollForward() {
        return ((Boolean) this.canScrollForward.getValue()).booleanValue();
    }

    private void setCanScrollBackward(boolean z) {
        this.canScrollBackward.setValue(Boolean.valueOf(z));
    }

    @Override
    public boolean getCanScrollBackward() {
        return ((Boolean) this.canScrollBackward.getValue()).booleanValue();
    }

    @Override
    public boolean getLastScrolledForward() {
        return this.scrollableState.getLastScrolledForward();
    }

    @Override
    public boolean getLastScrolledBackward() {
        return this.scrollableState.getLastScrolledBackward();
    }

    public final float onScroll$foundation_release(float distance) {
        if ((distance < 0.0f && !getCanScrollForward()) || (distance > 0.0f && !getCanScrollBackward())) {
            return 0.0f;
        }
        if (Math.abs(this.scrollToBeConsumed) > 0.5f) {
            throw new IllegalStateException(("entered drag with non-zero pending scroll: " + this.scrollToBeConsumed).toString());
        }
        float f = this.scrollToBeConsumed + distance;
        this.scrollToBeConsumed = f;
        if (Math.abs(f) > 0.5f) {
            LazyGridMeasureResult value = this.layoutInfoState.getValue();
            float f2 = this.scrollToBeConsumed;
            if (value.tryToApplyScrollWithoutRemeasure(MathKt.roundToInt(f2))) {
                applyMeasureResult$foundation_release(value, true);
                ObservableScopeInvalidator.m1258invalidateScopeimpl(this.placementScopeInvalidator);
                notifyPrefetchOnScroll(f2 - this.scrollToBeConsumed, value);
            } else {
                Remeasurement remeasurement = this.remeasurement;
                if (remeasurement != null) {
                    remeasurement.forceRemeasure();
                }
                notifyPrefetchOnScroll(f2 - this.scrollToBeConsumed, getLayoutInfo());
            }
        }
        if (Math.abs(this.scrollToBeConsumed) <= 0.5f) {
            return distance;
        }
        float f3 = distance - this.scrollToBeConsumed;
        this.scrollToBeConsumed = 0.0f;
        return f3;
    }

    private final void notifyPrefetchOnScroll(float delta, LazyGridLayoutInfo layoutInfo) {
        if (this.prefetchingEnabled) {
            this.prefetchStrategy.onScroll(this.prefetchScope, delta, layoutInfo);
        }
    }

    private final int getNumOfItemsToTeleport() {
        return getSlotsPerLine$foundation_release() * 100;
    }

    public static Object animateScrollToItem$default(LazyGridState lazyGridState, int i, int i2, Continuation continuation, int i3, Object obj) {
        if ((i3 & 2) != 0) {
            i2 = 0;
        }
        return lazyGridState.animateScrollToItem(i, i2, continuation);
    }

    public final Object animateScrollToItem(int i, int i2, Continuation<? super Unit> continuation) {
        Object objAnimateScrollToItem = LazyAnimateScrollKt.animateScrollToItem(this.animateScrollScope, i, i2, getNumOfItemsToTeleport(), getDensity$foundation_release(), continuation);
        return objAnimateScrollToItem == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objAnimateScrollToItem : Unit.INSTANCE;
    }

    public static void applyMeasureResult$foundation_release$default(LazyGridState lazyGridState, LazyGridMeasureResult lazyGridMeasureResult, boolean z, int i, Object obj) {
        if ((i & 2) != 0) {
            z = false;
        }
        lazyGridState.applyMeasureResult$foundation_release(lazyGridMeasureResult, z);
    }

    public final void applyMeasureResult$foundation_release(LazyGridMeasureResult result, boolean visibleItemsStayedTheSame) {
        this.scrollToBeConsumed -= result.getConsumedScroll();
        this.layoutInfoState.setValue(result);
        setCanScrollBackward(result.getCanScrollBackward());
        setCanScrollForward(result.getCanScrollForward());
        if (visibleItemsStayedTheSame) {
            this.scrollPosition.updateScrollOffset(result.getFirstVisibleLineScrollOffset());
        } else {
            this.scrollPosition.updateFromMeasureResult(result);
            if (this.prefetchingEnabled) {
                this.prefetchStrategy.onVisibleItemsUpdated(this.prefetchScope, result);
            }
        }
        this.numMeasurePasses++;
    }

    public final int updateScrollPositionIfTheFirstItemWasMoved$foundation_release(LazyGridItemProvider itemProvider, int firstItemIndex) {
        return this.scrollPosition.updateScrollPositionIfTheFirstItemWasMoved(itemProvider, firstItemIndex);
    }

    @Metadata(d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u001f\u0010\b\u001a\f\u0012\u0004\u0012\u00020\u0005\u0012\u0002\b\u00030\u00042\u0006\u0010\t\u001a\u00020\nH\u0001¢\u0006\u0002\b\u000bR\u001b\u0010\u0003\u001a\f\u0012\u0004\u0012\u00020\u0005\u0012\u0002\b\u00030\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\f"}, d2 = {"Landroidx/compose/foundation/lazy/grid/LazyGridState$Companion;", "", "()V", "Saver", "Landroidx/compose/runtime/saveable/Saver;", "Landroidx/compose/foundation/lazy/grid/LazyGridState;", "getSaver", "()Landroidx/compose/runtime/saveable/Saver;", "saver", "prefetchStrategy", "Landroidx/compose/foundation/lazy/grid/LazyGridPrefetchStrategy;", "saver$foundation_release", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final Saver<LazyGridState, ?> getSaver() {
            return LazyGridState.Saver;
        }

        public final Saver<LazyGridState, ?> saver$foundation_release(final LazyGridPrefetchStrategy prefetchStrategy) {
            return ListSaverKt.listSaver(new Function2<SaverScope, LazyGridState, List<? extends Integer>>() {
                public final List<Integer> invoke(SaverScope saverScope, LazyGridState lazyGridState) {
                    return CollectionsKt.listOf(new Integer[]{Integer.valueOf(lazyGridState.getFirstVisibleItemIndex()), Integer.valueOf(lazyGridState.getFirstVisibleItemScrollOffset())});
                }
            }, new Function1<List<? extends Integer>, LazyGridState>() {
                {
                    super(1);
                }

                public final LazyGridState invoke(List<Integer> list) {
                    return new LazyGridState(list.get(0).intValue(), list.get(1).intValue(), prefetchStrategy);
                }
            });
        }
    }
}
