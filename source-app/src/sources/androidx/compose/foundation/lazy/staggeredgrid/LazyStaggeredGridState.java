package androidx.compose.foundation.lazy.staggeredgrid;

import androidx.compose.foundation.MutatePriority;
import androidx.compose.foundation.gestures.Orientation;
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
import androidx.compose.foundation.lazy.layout.LazyLayoutItemProvider;
import androidx.compose.foundation.lazy.layout.LazyLayoutPinnedItemList;
import androidx.compose.foundation.lazy.layout.LazyLayoutPrefetchState;
import androidx.compose.foundation.lazy.layout.ObservableScopeInvalidator;
import androidx.compose.foundation.lazy.layout.PrefetchScheduler;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.layout.Remeasurement;
import androidx.compose.p002ui.layout.RemeasurementModifier;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import androidx.compose.runtime.saveable.ListSaverKt;
import androidx.compose.runtime.saveable.Saver;
import androidx.compose.runtime.saveable.SaverScope;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.IntOffset;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.ArraysKt;
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

@Metadata(d1 = {"\u0000ú\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u0015\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\f\n\u0002\u0010%\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0002\b\u000b\n\u0002\u0010\"\n\u0002\b\n\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0007\u0018\u0000  \u00012\u00020\u0001:\u0002 \u0001B\u001b\b\u0016\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0003¢\u0006\u0002\u0010\u0005B!\b\u0000\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\u0007\u0012\b\u0010\t\u001a\u0004\u0018\u00010\n¢\u0006\u0002\u0010\u000bJ \u0010w\u001a\u00020x2\u0006\u0010y\u001a\u00020\u00032\b\b\u0002\u0010z\u001a\u00020\u0003H\u0086@¢\u0006\u0002\u0010{J\u001f\u0010|\u001a\u00020x2\u0006\u0010}\u001a\u00020E2\b\b\u0002\u0010~\u001a\u00020\u0017H\u0000¢\u0006\u0002\b\u007fJ\u0012\u0010\u0080\u0001\u001a\u00020x2\u0007\u0010\u0081\u0001\u001a\u00020@H\u0002J\u0019\u0010\u0082\u0001\u001a\u00020x2\u000e\u0010\u0083\u0001\u001a\t\u0012\u0004\u0012\u00020\u00030\u0084\u0001H\u0002J\u0012\u0010\u0085\u0001\u001a\u00020r2\u0007\u0010\u0086\u0001\u001a\u00020rH\u0016J\u001a\u0010\u0087\u0001\u001a\u00020\u00072\u0007\u0010\u0088\u0001\u001a\u00020\u00032\u0006\u00105\u001a\u00020\u0003H\u0002J\u001d\u0010\u0089\u0001\u001a\u00020x2\u0007\u0010\u0086\u0001\u001a\u00020r2\t\b\u0002\u0010\u0081\u0001\u001a\u00020EH\u0002J\u0012\u0010\u008a\u0001\u001a\u00020r2\u0007\u0010\u008b\u0001\u001a\u00020rH\u0002J\u001b\u0010\u008c\u0001\u001a\u00020x2\b\b\u0001\u0010y\u001a\u00020\u00032\b\b\u0002\u0010z\u001a\u00020\u0003JI\u0010\u008d\u0001\u001a\u00020x2\b\u0010\u008e\u0001\u001a\u00030\u008f\u00012-\u0010\u0090\u0001\u001a(\b\u0001\u0012\u0005\u0012\u00030\u0092\u0001\u0012\u000b\u0012\t\u0012\u0004\u0012\u00020x0\u0093\u0001\u0012\u0007\u0012\u0005\u0018\u00010\u0094\u00010\u0091\u0001¢\u0006\u0003\b\u0095\u0001H\u0096@¢\u0006\u0003\u0010\u0096\u0001J!\u0010\u0097\u0001\u001a\u00020x2\u0006\u0010y\u001a\u00020\u00032\b\b\u0002\u0010z\u001a\u00020\u0003H\u0086@¢\u0006\u0002\u0010{J(\u0010\u0098\u0001\u001a\u00020x2\u0006\u0010y\u001a\u00020\u00032\u0006\u0010z\u001a\u00020\u00032\u0007\u0010\u0099\u0001\u001a\u00020\u0017H\u0000¢\u0006\u0003\b\u009a\u0001J\"\u0010\u009b\u0001\u001a\u00020\u00072\b\u0010\u009c\u0001\u001a\u00030\u009d\u00012\u0007\u0010\u009e\u0001\u001a\u00020\u0007H\u0000¢\u0006\u0003\b\u009f\u0001R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u000e\u001a\u00020\u000fX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011R\u0014\u0010\u0012\u001a\u00020\u0013X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0015R+\u0010\u0018\u001a\u00020\u00172\u0006\u0010\u0016\u001a\u00020\u00178V@RX\u0096\u008e\u0002¢\u0006\u0012\n\u0004\b\u001d\u0010\u001e\u001a\u0004\b\u0019\u0010\u001a\"\u0004\b\u001b\u0010\u001cR+\u0010\u001f\u001a\u00020\u00172\u0006\u0010\u0016\u001a\u00020\u00178V@RX\u0096\u008e\u0002¢\u0006\u0012\n\u0004\b\"\u0010\u001e\u001a\u0004\b \u0010\u001a\"\u0004\b!\u0010\u001cR\u001a\u0010#\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020%0$X\u0082\u0004¢\u0006\u0002\n\u0000R\u0011\u0010&\u001a\u00020\u00038F¢\u0006\u0006\u001a\u0004\b'\u0010(R\u0011\u0010)\u001a\u00020\u00038F¢\u0006\u0006\u001a\u0004\b*\u0010(R\u0011\u0010+\u001a\u00020,8F¢\u0006\u0006\u001a\u0004\b-\u0010.R\u0014\u0010/\u001a\u00020\u00178VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b/\u0010\u001aR\u001a\u00100\u001a\b\u0012\u0004\u0012\u00020201X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b3\u00104R\u0014\u00105\u001a\u00020\u00038@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b6\u0010(R\u0014\u00107\u001a\u000208X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b9\u0010:R\u0014\u0010;\u001a\u00020\u00178VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b<\u0010\u001aR\u0014\u0010=\u001a\u00020\u00178VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b>\u0010\u001aR\u0011\u0010?\u001a\u00020@8F¢\u0006\u0006\u001a\u0004\bA\u0010BR\u0014\u0010C\u001a\b\u0012\u0004\u0012\u00020E0DX\u0082\u0004¢\u0006\u0002\n\u0000R\u001a\u0010F\u001a\u00020\u0003X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bG\u0010(\"\u0004\bH\u0010IR\u001c\u0010J\u001a\u00020KX\u0080\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u001e\u001a\u0004\bL\u0010MR\u0014\u0010N\u001a\u00020OX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\bP\u0010QR\u001b\u0010R\u001a\u00020S8@X\u0080\u0084\u0002¢\u0006\f\u001a\u0004\bV\u0010W*\u0004\bT\u0010UR\u0014\u0010X\u001a\u00020YX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\bZ\u0010[R\u001c\u0010\\\u001a\u00020KX\u0080\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u001e\u001a\u0004\b]\u0010MR\u000e\u0010^\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010_\u001a\u00020`X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\ba\u0010bR\u001a\u0010c\u001a\u00020\u0017X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bd\u0010\u001a\"\u0004\be\u0010\u001cR\"\u0010g\u001a\u0004\u0018\u00010f2\b\u0010\u0016\u001a\u0004\u0018\u00010f@BX\u0080\u000e¢\u0006\b\n\u0000\u001a\u0004\bh\u0010iR\u0014\u0010j\u001a\u00020kX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\bl\u0010mR\u0014\u0010n\u001a\u00020oX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\bp\u0010qR\u001e\u0010s\u001a\u00020r2\u0006\u0010\u0016\u001a\u00020r@BX\u0080\u000e¢\u0006\b\n\u0000\u001a\u0004\bt\u0010uR\u000e\u0010v\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006¡\u0001"}, d2 = {"Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridState;", "Landroidx/compose/foundation/gestures/ScrollableState;", "initialFirstVisibleItemIndex", "", "initialFirstVisibleItemOffset", "(II)V", "initialFirstVisibleItems", "", "initialFirstVisibleOffsets", "prefetchScheduler", "Landroidx/compose/foundation/lazy/layout/PrefetchScheduler;", "([I[ILandroidx/compose/foundation/lazy/layout/PrefetchScheduler;)V", "animateScrollScope", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridAnimateScrollScope;", "awaitLayoutModifier", "Landroidx/compose/foundation/lazy/layout/AwaitFirstLayoutModifier;", "getAwaitLayoutModifier$foundation_release", "()Landroidx/compose/foundation/lazy/layout/AwaitFirstLayoutModifier;", "beyondBoundsInfo", "Landroidx/compose/foundation/lazy/layout/LazyLayoutBeyondBoundsInfo;", "getBeyondBoundsInfo$foundation_release", "()Landroidx/compose/foundation/lazy/layout/LazyLayoutBeyondBoundsInfo;", "<set-?>", "", "canScrollBackward", "getCanScrollBackward", "()Z", "setCanScrollBackward", "(Z)V", "canScrollBackward$delegate", "Landroidx/compose/runtime/MutableState;", "canScrollForward", "getCanScrollForward", "setCanScrollForward", "canScrollForward$delegate", "currentItemPrefetchHandles", "", "Landroidx/compose/foundation/lazy/layout/LazyLayoutPrefetchState$PrefetchHandle;", "firstVisibleItemIndex", "getFirstVisibleItemIndex", "()I", "firstVisibleItemScrollOffset", "getFirstVisibleItemScrollOffset", "interactionSource", "Landroidx/compose/foundation/interaction/InteractionSource;", "getInteractionSource", "()Landroidx/compose/foundation/interaction/InteractionSource;", "isScrollInProgress", "itemAnimator", "Landroidx/compose/foundation/lazy/layout/LazyLayoutItemAnimator;", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridMeasuredItem;", "getItemAnimator$foundation_release", "()Landroidx/compose/foundation/lazy/layout/LazyLayoutItemAnimator;", "laneCount", "getLaneCount$foundation_release", "laneInfo", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridLaneInfo;", "getLaneInfo$foundation_release", "()Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridLaneInfo;", "lastScrolledBackward", "getLastScrolledBackward", "lastScrolledForward", "getLastScrolledForward", "layoutInfo", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridLayoutInfo;", "getLayoutInfo", "()Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridLayoutInfo;", "layoutInfoState", "Landroidx/compose/runtime/MutableState;", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridMeasureResult;", "measurePassCount", "getMeasurePassCount$foundation_release", "setMeasurePassCount$foundation_release", "(I)V", "measurementScopeInvalidator", "Landroidx/compose/foundation/lazy/layout/ObservableScopeInvalidator;", "getMeasurementScopeInvalidator-zYiylxw$foundation_release", "()Landroidx/compose/runtime/MutableState;", "mutableInteractionSource", "Landroidx/compose/foundation/interaction/MutableInteractionSource;", "getMutableInteractionSource$foundation_release", "()Landroidx/compose/foundation/interaction/MutableInteractionSource;", "nearestRange", "Lkotlin/ranges/IntRange;", "getNearestRange$foundation_release$delegate", "(Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridState;)Ljava/lang/Object;", "getNearestRange$foundation_release", "()Lkotlin/ranges/IntRange;", "pinnedItems", "Landroidx/compose/foundation/lazy/layout/LazyLayoutPinnedItemList;", "getPinnedItems$foundation_release", "()Landroidx/compose/foundation/lazy/layout/LazyLayoutPinnedItemList;", "placementScopeInvalidator", "getPlacementScopeInvalidator-zYiylxw$foundation_release", "prefetchBaseIndex", "prefetchState", "Landroidx/compose/foundation/lazy/layout/LazyLayoutPrefetchState;", "getPrefetchState$foundation_release", "()Landroidx/compose/foundation/lazy/layout/LazyLayoutPrefetchState;", "prefetchingEnabled", "getPrefetchingEnabled$foundation_release", "setPrefetchingEnabled$foundation_release", "Landroidx/compose/ui/layout/Remeasurement;", "remeasurement", "getRemeasurement$foundation_release", "()Landroidx/compose/ui/layout/Remeasurement;", "remeasurementModifier", "Landroidx/compose/ui/layout/RemeasurementModifier;", "getRemeasurementModifier$foundation_release", "()Landroidx/compose/ui/layout/RemeasurementModifier;", "scrollPosition", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridScrollPosition;", "getScrollPosition$foundation_release", "()Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridScrollPosition;", "", "scrollToBeConsumed", "getScrollToBeConsumed$foundation_release", "()F", "scrollableState", "animateScrollToItem", "", "index", "scrollOffset", "(IILkotlin/coroutines/Continuation;)Ljava/lang/Object;", "applyMeasureResult", "result", "visibleItemsStayedTheSame", "applyMeasureResult$foundation_release", "cancelPrefetchIfVisibleItemsChanged", "info", "clearLeftoverPrefetchHandles", "prefetchHandlesUsed", "", "dispatchRawDelta", "delta", "fillNearestIndices", "itemIndex", "notifyPrefetch", "onScroll", "distance", "requestScrollToItem", "scroll", "scrollPriority", "Landroidx/compose/foundation/MutatePriority;", "block", "Lkotlin/Function2;", "Landroidx/compose/foundation/gestures/ScrollScope;", "Lkotlin/coroutines/Continuation;", "", "Lkotlin/ExtensionFunctionType;", "(Landroidx/compose/foundation/MutatePriority;Lkotlin/jvm/functions/Function2;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "scrollToItem", "snapToItemInternal", "forceRemeasure", "snapToItemInternal$foundation_release", "updateScrollPositionIfTheFirstItemWasMoved", "itemProvider", "Landroidx/compose/foundation/lazy/layout/LazyLayoutItemProvider;", "firstItemIndex", "updateScrollPositionIfTheFirstItemWasMoved$foundation_release", "Companion", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class LazyStaggeredGridState implements ScrollableState {
    private final LazyStaggeredGridAnimateScrollScope animateScrollScope;
    private final AwaitFirstLayoutModifier awaitLayoutModifier;
    private final LazyLayoutBeyondBoundsInfo beyondBoundsInfo;

    private final MutableState canScrollBackward;

    private final MutableState canScrollForward;
    private final Map<Integer, LazyLayoutPrefetchState.PrefetchHandle> currentItemPrefetchHandles;
    private final LazyLayoutItemAnimator<LazyStaggeredGridMeasuredItem> itemAnimator;
    private final LazyStaggeredGridLaneInfo laneInfo;
    private final MutableState<LazyStaggeredGridMeasureResult> layoutInfoState;
    private int measurePassCount;
    private final MutableState<Unit> measurementScopeInvalidator;
    private final MutableInteractionSource mutableInteractionSource;
    private final LazyLayoutPinnedItemList pinnedItems;
    private final MutableState<Unit> placementScopeInvalidator;
    private int prefetchBaseIndex;
    private final LazyLayoutPrefetchState prefetchState;
    private boolean prefetchingEnabled;
    private Remeasurement remeasurement;
    private final RemeasurementModifier remeasurementModifier;
    private final LazyStaggeredGridScrollPosition scrollPosition;
    private float scrollToBeConsumed;
    private final ScrollableState scrollableState;

    public static final Companion INSTANCE = new Companion(null);
    public static final int $stable = 8;
    private static final Saver<LazyStaggeredGridState, Object> Saver = ListSaverKt.listSaver(new Function2<SaverScope, LazyStaggeredGridState, List<? extends int[]>>() {
        public final List<int[]> invoke(SaverScope saverScope, LazyStaggeredGridState lazyStaggeredGridState) {
            return CollectionsKt.listOf(new int[][]{lazyStaggeredGridState.getScrollPosition().getIndices(), lazyStaggeredGridState.getScrollPosition().getScrollOffsets()});
        }
    }, new Function1<List<? extends int[]>, LazyStaggeredGridState>() {
        public final LazyStaggeredGridState invoke(List<int[]> list) {
            return new LazyStaggeredGridState(list.get(0), list.get(1), null);
        }
    });

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.lazy.staggeredgrid.LazyStaggeredGridState", f = "LazyStaggeredGridState.kt", i = {0, 0, 0}, l = {235, 236}, m = "scroll", n = {"this", "scrollPriority", "block"}, s = {"L$0", "L$1", "L$2"})
    static final class C07431 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C07431(Continuation<? super C07431> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return LazyStaggeredGridState.this.scroll(null, null, (Continuation) this);
        }
    }

    public LazyStaggeredGridState(int[] iArr, int[] iArr2, PrefetchScheduler prefetchScheduler) {
        LazyStaggeredGridScrollPosition lazyStaggeredGridScrollPosition = new LazyStaggeredGridScrollPosition(iArr, iArr2, new LazyStaggeredGridState$scrollPosition$1(this));
        this.scrollPosition = lazyStaggeredGridScrollPosition;
        this.layoutInfoState = SnapshotStateKt.mutableStateOf(LazyStaggeredGridMeasureResultKt.getEmptyLazyStaggeredGridLayoutInfo(), SnapshotStateKt.neverEqualPolicy());
        this.laneInfo = new LazyStaggeredGridLaneInfo();
        this.canScrollForward = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(false, null, 2, null);
        this.canScrollBackward = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(false, null, 2, null);
        this.animateScrollScope = new LazyStaggeredGridAnimateScrollScope(this);
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
        this.beyondBoundsInfo = new LazyLayoutBeyondBoundsInfo();
        this.prefetchingEnabled = true;
        this.prefetchState = new LazyLayoutPrefetchState(prefetchScheduler, null, 2, null);
        this.scrollableState = ScrollableStateKt.ScrollableState(new Function1<Float, Float>() {
            {
                super(1);
            }

            public final Float invoke(float f) {
                return Float.valueOf(-this.this$0.onScroll(-f));
            }

            public Object invoke(Object obj) {
                return invoke(((Number) obj).floatValue());
            }
        });
        this.prefetchBaseIndex = -1;
        this.currentItemPrefetchHandles = new LinkedHashMap();
        this.mutableInteractionSource = InteractionSourceKt.MutableInteractionSource();
        this.pinnedItems = new LazyLayoutPinnedItemList();
        this.itemAnimator = new LazyLayoutItemAnimator<>();
        lazyStaggeredGridScrollPosition.getNearestRangeState();
        this.placementScopeInvalidator = ObservableScopeInvalidator.m1254constructorimpl$default(null, 1, null);
        this.measurementScopeInvalidator = ObservableScopeInvalidator.m1254constructorimpl$default(null, 1, null);
    }

    public LazyStaggeredGridState(int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this((i3 & 1) != 0 ? 0 : i, (i3 & 2) != 0 ? 0 : i2);
    }

    public LazyStaggeredGridState(int i, int i2) {
        this(new int[]{i}, new int[]{i2}, null);
    }

    public final int getFirstVisibleItemIndex() {
        return this.scrollPosition.getIndex();
    }

    public final int getFirstVisibleItemScrollOffset() {
        return this.scrollPosition.getScrollOffset();
    }

    public final LazyStaggeredGridScrollPosition getScrollPosition() {
        return this.scrollPosition;
    }

    public final LazyStaggeredGridLayoutInfo getLayoutInfo() {
        return this.layoutInfoState.getValue();
    }

    public final LazyStaggeredGridLaneInfo getLaneInfo() {
        return this.laneInfo;
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

    public final Remeasurement getRemeasurement() {
        return this.remeasurement;
    }

    public final RemeasurementModifier getRemeasurementModifier() {
        return this.remeasurementModifier;
    }

    public final AwaitFirstLayoutModifier getAwaitLayoutModifier() {
        return this.awaitLayoutModifier;
    }

    public final LazyLayoutBeyondBoundsInfo getBeyondBoundsInfo() {
        return this.beyondBoundsInfo;
    }

    public final boolean getPrefetchingEnabled() {
        return this.prefetchingEnabled;
    }

    public final void setPrefetchingEnabled$foundation_release(boolean z) {
        this.prefetchingEnabled = z;
    }

    public final LazyLayoutPrefetchState getPrefetchState() {
        return this.prefetchState;
    }

    public final float getScrollToBeConsumed() {
        return this.scrollToBeConsumed;
    }

    public final int getMeasurePassCount() {
        return this.measurePassCount;
    }

    public final void setMeasurePassCount$foundation_release(int i) {
        this.measurePassCount = i;
    }

    public final int getLaneCount$foundation_release() {
        return this.layoutInfoState.getValue().getSlots().getSizes().length;
    }

    public final InteractionSource getInteractionSource() {
        return this.mutableInteractionSource;
    }

    public final MutableInteractionSource getMutableInteractionSource() {
        return this.mutableInteractionSource;
    }

    public final LazyLayoutPinnedItemList getPinnedItems() {
        return this.pinnedItems;
    }

    public final LazyLayoutItemAnimator<LazyStaggeredGridMeasuredItem> getItemAnimator$foundation_release() {
        return this.itemAnimator;
    }

    public final IntRange getNearestRange$foundation_release() {
        return this.scrollPosition.getNearestRangeState().getValue();
    }

    public final MutableState<Unit> m1302getPlacementScopeInvalidatorzYiylxw$foundation_release() {
        return this.placementScopeInvalidator;
    }

    @Override
    public Object scroll(MutatePriority mutatePriority, Function2<? super ScrollScope, ? super Continuation<? super Unit>, ? extends Object> function2, Continuation<? super Unit> continuation) {
        C07431 c07431;
        LazyStaggeredGridState lazyStaggeredGridState;
        if (continuation instanceof C07431) {
            c07431 = (C07431) continuation;
            if ((c07431.label & Integer.MIN_VALUE) != 0) {
                c07431.label -= Integer.MIN_VALUE;
            } else {
                c07431 = new C07431(continuation);
            }
        } else {
            c07431 = new C07431(continuation);
        }
        Object obj = c07431.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c07431.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            AwaitFirstLayoutModifier awaitFirstLayoutModifier = this.awaitLayoutModifier;
            c07431.L$0 = this;
            c07431.L$1 = mutatePriority;
            c07431.L$2 = function2;
            c07431.label = 1;
            if (awaitFirstLayoutModifier.waitForFirstLayout(c07431) == coroutine_suspended) {
                return coroutine_suspended;
            }
            lazyStaggeredGridState = this;
        } else {
            if (i == 1) {
                function2 = (Function2) c07431.L$2;
                mutatePriority = (MutatePriority) c07431.L$1;
                lazyStaggeredGridState = (LazyStaggeredGridState) c07431.L$0;
                ResultKt.throwOnFailure(obj);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
        ScrollableState scrollableState = lazyStaggeredGridState.scrollableState;
        c07431.L$0 = null;
        c07431.L$1 = null;
        c07431.L$2 = null;
        c07431.label = 2;
        if (scrollableState.scroll(mutatePriority, function2, c07431) == coroutine_suspended) {
            return coroutine_suspended;
        }
        return Unit.INSTANCE;
    }

    @Override
    public boolean isScrollInProgress() {
        return this.scrollableState.isScrollInProgress();
    }

    public final float onScroll(float distance) {
        if ((distance < 0.0f && !getCanScrollForward()) || (distance > 0.0f && !getCanScrollBackward())) {
            return 0.0f;
        }
        if (Math.abs(this.scrollToBeConsumed) > 0.5f) {
            throw new IllegalStateException(("entered drag with non-zero pending scroll: " + this.scrollToBeConsumed).toString());
        }
        float f = this.scrollToBeConsumed + distance;
        this.scrollToBeConsumed = f;
        if (Math.abs(f) > 0.5f) {
            LazyStaggeredGridMeasureResult value = this.layoutInfoState.getValue();
            float f2 = this.scrollToBeConsumed;
            if (value.tryToApplyScrollWithoutRemeasure(MathKt.roundToInt(f2))) {
                applyMeasureResult$foundation_release(value, true);
                ObservableScopeInvalidator.m1258invalidateScopeimpl(this.placementScopeInvalidator);
                notifyPrefetch(f2 - this.scrollToBeConsumed, value);
            } else {
                Remeasurement remeasurement = this.remeasurement;
                if (remeasurement != null) {
                    remeasurement.forceRemeasure();
                }
                notifyPrefetch$default(this, f2 - this.scrollToBeConsumed, null, 2, null);
            }
        }
        if (Math.abs(this.scrollToBeConsumed) <= 0.5f) {
            return distance;
        }
        float f3 = distance - this.scrollToBeConsumed;
        this.scrollToBeConsumed = 0.0f;
        return f3;
    }

    public static Object scrollToItem$default(LazyStaggeredGridState lazyStaggeredGridState, int i, int i2, Continuation continuation, int i3, Object obj) {
        if ((i3 & 2) != 0) {
            i2 = 0;
        }
        return lazyStaggeredGridState.scrollToItem(i, i2, continuation);
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/foundation/gestures/ScrollScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.lazy.staggeredgrid.LazyStaggeredGridState$scrollToItem$2", f = "LazyStaggeredGridState.kt", i = {}, l = {}, m = "invokeSuspend", n = {}, s = {})
    static final class C07442 extends SuspendLambda implements Function2<ScrollScope, Continuation<? super Unit>, Object> {
        final int $index;
        final int $scrollOffset;
        int label;

        C07442(int i, int i2, Continuation<? super C07442> continuation) {
            super(2, continuation);
            this.$index = i;
            this.$scrollOffset = i2;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return LazyStaggeredGridState.this.new C07442(this.$index, this.$scrollOffset, continuation);
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
            LazyStaggeredGridState.this.snapToItemInternal$foundation_release(this.$index, this.$scrollOffset, true);
            return Unit.INSTANCE;
        }
    }

    public final Object scrollToItem(int i, int i2, Continuation<? super Unit> continuation) {
        Object objScroll$default = ScrollableState.CC.scroll$default(this, null, new C07442(i, i2, null), continuation, 1, null);
        return objScroll$default == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objScroll$default : Unit.INSTANCE;
    }

    public static Object animateScrollToItem$default(LazyStaggeredGridState lazyStaggeredGridState, int i, int i2, Continuation continuation, int i3, Object obj) {
        if ((i3 & 2) != 0) {
            i2 = 0;
        }
        return lazyStaggeredGridState.animateScrollToItem(i, i2, continuation);
    }

    public final Object animateScrollToItem(int i, int i2, Continuation<? super Unit> continuation) {
        LazyStaggeredGridMeasureResult value = this.layoutInfoState.getValue();
        Object objAnimateScrollToItem = LazyAnimateScrollKt.animateScrollToItem(this.animateScrollScope, i, i2, value.getSlots().getSizes().length * 100, value.getDensity(), continuation);
        return objAnimateScrollToItem == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objAnimateScrollToItem : Unit.INSTANCE;
    }

    public final MutableState<Unit> m1301getMeasurementScopeInvalidatorzYiylxw$foundation_release() {
        return this.measurementScopeInvalidator;
    }

    public static void requestScrollToItem$default(LazyStaggeredGridState lazyStaggeredGridState, int i, int i2, int i3, Object obj) {
        if ((i3 & 2) != 0) {
            i2 = 0;
        }
        lazyStaggeredGridState.requestScrollToItem(i, i2);
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.lazy.staggeredgrid.LazyStaggeredGridState$requestScrollToItem$1", f = "LazyStaggeredGridState.kt", i = {}, l = {360}, m = "invokeSuspend", n = {}, s = {})
    static final class C07421 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C07421(Continuation<? super C07421> continuation) {
            super(2, continuation);
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return LazyStaggeredGridState.this.new C07421(continuation);
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
                if (ScrollExtensionsKt.stopScroll$default(LazyStaggeredGridState.this, null, (Continuation) this, 1, null) == coroutine_suspended) {
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
            BuildersKt.launch$default(this.layoutInfoState.getValue().getCoroutineScope(), (CoroutineContext) null, (CoroutineStart) null, new C07421(null), 3, (Object) null);
        }
        snapToItemInternal$foundation_release(index, scrollOffset, false);
    }

    public final void snapToItemInternal$foundation_release(int index, int scrollOffset, boolean forceRemeasure) {
        int i;
        boolean z = (this.scrollPosition.getIndex() == index && this.scrollPosition.getScrollOffset() == scrollOffset) ? false : true;
        if (z) {
            this.itemAnimator.reset();
        }
        LazyStaggeredGridMeasureResult value = this.layoutInfoState.getValue();
        LazyStaggeredGridItemInfo lazyStaggeredGridItemInfoFindVisibleItem = LazyStaggeredGridMeasureResultKt.findVisibleItem(value, index);
        if (lazyStaggeredGridItemInfoFindVisibleItem != null && z) {
            if (value.getOrientation() == Orientation.Vertical) {
                i = IntOffset.getY-impl(lazyStaggeredGridItemInfoFindVisibleItem.getOffset());
            } else {
                i = IntOffset.getX-impl(lazyStaggeredGridItemInfoFindVisibleItem.getOffset());
            }
            int i2 = i + scrollOffset;
            int length = value.getFirstVisibleItemScrollOffsets().length;
            int[] iArr = new int[length];
            for (int i3 = 0; i3 < length; i3++) {
                iArr[i3] = value.getFirstVisibleItemScrollOffsets()[i3] + i2;
            }
            this.scrollPosition.updateScrollOffset(iArr);
        } else {
            this.scrollPosition.requestPositionAndForgetLastKnownKey(index, scrollOffset);
        }
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

    public final int[] updateScrollPositionIfTheFirstItemWasMoved$foundation_release(LazyLayoutItemProvider itemProvider, int[] firstItemIndex) {
        return this.scrollPosition.updateScrollPositionIfTheFirstItemWasMoved(itemProvider, firstItemIndex);
    }

    @Override
    public float dispatchRawDelta(float delta) {
        return this.scrollableState.dispatchRawDelta(delta);
    }

    static void notifyPrefetch$default(LazyStaggeredGridState lazyStaggeredGridState, float f, LazyStaggeredGridMeasureResult lazyStaggeredGridMeasureResult, int i, Object obj) {
        if ((i & 2) != 0) {
            lazyStaggeredGridMeasureResult = lazyStaggeredGridState.layoutInfoState.getValue();
        }
        lazyStaggeredGridState.notifyPrefetch(f, lazyStaggeredGridMeasureResult);
    }

    private final void notifyPrefetch(float delta, LazyStaggeredGridMeasureResult info) {
        int index;
        int i;
        long j;
        if (!this.prefetchingEnabled || info.getVisibleItemsInfo().isEmpty()) {
            return;
        }
        boolean z = delta < 0.0f;
        if (z) {
            index = ((LazyStaggeredGridMeasuredItem) CollectionsKt.last(info.getVisibleItemsInfo())).getIndex();
        } else {
            index = ((LazyStaggeredGridMeasuredItem) CollectionsKt.first(info.getVisibleItemsInfo())).getIndex();
        }
        if (index == this.prefetchBaseIndex) {
            return;
        }
        this.prefetchBaseIndex = index;
        LinkedHashSet linkedHashSet = new LinkedHashSet();
        LazyStaggeredGridSlots slots = info.getSlots();
        int length = slots.getSizes().length;
        for (int i2 = 0; i2 < length; i2++) {
            if (z) {
                index = this.laneInfo.findNextItemIndex(index, i2);
            } else {
                index = this.laneInfo.findPreviousItemIndex(index, i2);
            }
            if (index < 0 || index >= info.getTotalItemsCount() || linkedHashSet.contains(Integer.valueOf(index))) {
                break;
            }
            linkedHashSet.add(Integer.valueOf(index));
            if (!this.currentItemPrefetchHandles.containsKey(Integer.valueOf(index))) {
                boolean zIsFullSpan = info.getSpanProvider().isFullSpan(index);
                int i3 = zIsFullSpan ? 0 : i2;
                int i4 = zIsFullSpan ? length : 1;
                if (i4 == 1) {
                    i = slots.getSizes()[i3];
                } else {
                    int i5 = slots.getPositions()[i3];
                    int i6 = (i3 + i4) - 1;
                    i = (slots.getPositions()[i6] + slots.getSizes()[i6]) - i5;
                }
                if (info.getOrientation() == Orientation.Vertical) {
                    j = Constraints.Companion.fixedWidth-OenEA2s(i);
                } else {
                    j = Constraints.Companion.fixedHeight-OenEA2s(i);
                }
                this.currentItemPrefetchHandles.put(Integer.valueOf(index), this.prefetchState.m1243schedulePrefetch0kLqBqw(index, j));
            }
        }
        clearLeftoverPrefetchHandles(linkedHashSet);
    }

    private final void clearLeftoverPrefetchHandles(Set<Integer> prefetchHandlesUsed) {
        Iterator<Map.Entry<Integer, LazyLayoutPrefetchState.PrefetchHandle>> it = this.currentItemPrefetchHandles.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry<Integer, LazyLayoutPrefetchState.PrefetchHandle> next = it.next();
            if (!prefetchHandlesUsed.contains(next.getKey())) {
                next.getValue().cancel();
                it.remove();
            }
        }
    }

    private final void cancelPrefetchIfVisibleItemsChanged(LazyStaggeredGridLayoutInfo info) {
        List<LazyStaggeredGridItemInfo> visibleItemsInfo = info.getVisibleItemsInfo();
        if (this.prefetchBaseIndex == -1 || visibleItemsInfo.isEmpty()) {
            return;
        }
        int index = ((LazyStaggeredGridItemInfo) CollectionsKt.first(visibleItemsInfo)).getIndex();
        int index2 = ((LazyStaggeredGridItemInfo) CollectionsKt.last(visibleItemsInfo)).getIndex();
        int i = this.prefetchBaseIndex;
        if (index > i || i > index2) {
            this.prefetchBaseIndex = -1;
            Iterator<T> it = this.currentItemPrefetchHandles.values().iterator();
            while (it.hasNext()) {
                ((LazyLayoutPrefetchState.PrefetchHandle) it.next()).cancel();
            }
            this.currentItemPrefetchHandles.clear();
        }
    }

    public static void applyMeasureResult$foundation_release$default(LazyStaggeredGridState lazyStaggeredGridState, LazyStaggeredGridMeasureResult lazyStaggeredGridMeasureResult, boolean z, int i, Object obj) {
        if ((i & 2) != 0) {
            z = false;
        }
        lazyStaggeredGridState.applyMeasureResult$foundation_release(lazyStaggeredGridMeasureResult, z);
    }

    public final void applyMeasureResult$foundation_release(LazyStaggeredGridMeasureResult result, boolean visibleItemsStayedTheSame) {
        this.scrollToBeConsumed -= result.getConsumedScroll();
        this.layoutInfoState.setValue(result);
        if (visibleItemsStayedTheSame) {
            this.scrollPosition.updateScrollOffset(result.getFirstVisibleItemScrollOffsets());
        } else {
            this.scrollPosition.updateFromMeasureResult(result);
            cancelPrefetchIfVisibleItemsChanged(result);
        }
        setCanScrollBackward(result.getCanScrollBackward());
        setCanScrollForward(result.getCanScrollForward());
        this.measurePassCount++;
    }

    public final int[] fillNearestIndices(int itemIndex, int laneCount) {
        int iMin;
        int[] iArr = new int[laneCount];
        if (this.layoutInfoState.getValue().getSpanProvider().isFullSpan(itemIndex)) {
            ArraysKt.fill$default(iArr, itemIndex, 0, 0, 6, (Object) null);
            return iArr;
        }
        this.laneInfo.ensureValidIndex(itemIndex + laneCount);
        int lane = this.laneInfo.getLane(itemIndex);
        if (lane == -2 || lane == -1) {
            iMin = 0;
        } else {
            if (lane < 0) {
                throw new IllegalArgumentException(("Expected positive lane number, got " + lane + " instead.").toString());
            }
            iMin = Math.min(lane, laneCount);
        }
        int i = iMin;
        int iFindPreviousItemIndex = itemIndex;
        for (int i2 = i - 1; -1 < i2; i2--) {
            iFindPreviousItemIndex = this.laneInfo.findPreviousItemIndex(iFindPreviousItemIndex, i2);
            iArr[i2] = iFindPreviousItemIndex;
            if (iFindPreviousItemIndex == -1) {
                ArraysKt.fill$default(iArr, -1, 0, i2, 2, (Object) null);
                break;
            }
        }
        iArr[i] = itemIndex;
        while (true) {
            i++;
            if (i >= laneCount) {
                return iArr;
            }
            itemIndex = this.laneInfo.findNextItemIndex(itemIndex, i);
            iArr[i] = itemIndex;
        }
    }

    @Metadata(d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u001d\u0010\u0003\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00010\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\b"}, d2 = {"Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridState$Companion;", "", "()V", "Saver", "Landroidx/compose/runtime/saveable/Saver;", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridState;", "getSaver", "()Landroidx/compose/runtime/saveable/Saver;", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final Saver<LazyStaggeredGridState, Object> getSaver() {
            return LazyStaggeredGridState.Saver;
        }
    }
}
