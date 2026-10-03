package androidx.compose.foundation.pager;

import androidx.compose.animation.core.AnimationSpec;
import androidx.compose.animation.core.AnimationSpecKt;
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
import androidx.compose.foundation.lazy.layout.LazyLayoutAnimateScrollScope;
import androidx.compose.foundation.lazy.layout.LazyLayoutBeyondBoundsInfo;
import androidx.compose.foundation.lazy.layout.LazyLayoutPinnedItemList;
import androidx.compose.foundation.lazy.layout.LazyLayoutPrefetchState;
import androidx.compose.foundation.lazy.layout.ObservableScopeInvalidator;
import androidx.compose.foundation.lazy.layout.PrefetchScheduler;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.layout.Remeasurement;
import androidx.compose.p002ui.layout.RemeasurementModifier;
import androidx.compose.runtime.MutableIntState;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.SnapshotIntStateKt;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import androidx.compose.runtime.State;
import androidx.compose.runtime.snapshots.Snapshot;
import androidx.compose.ui.unit.ConstraintsKt;
import androidx.compose.ui.unit.Density;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.math.MathKt;
import kotlin.ranges.IntRange;
import kotlin.ranges.RangesKt;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineStart;

@Metadata(d1 = {"\u0000ö\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0010\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\t\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u000f\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\f\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\f\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0011\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0002\b\f\b'\u0018\u00002\u00020\u0001B\u001b\b\u0016\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0003\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006B'\b\u0000\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0003\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\b¢\u0006\u0002\u0010\tJ7\u0010\u009f\u0001\u001a\u00030 \u00012\u0007\u0010¡\u0001\u001a\u00020\u00032\t\b\u0003\u0010¢\u0001\u001a\u00020\u00052\u0010\b\u0002\u0010£\u0001\u001a\t\u0012\u0004\u0012\u00020\u00050¤\u0001H\u0086@¢\u0006\u0003\u0010¥\u0001J$\u0010¦\u0001\u001a\u00030 \u00012\u0007\u0010§\u0001\u001a\u00020b2\t\b\u0002\u0010¨\u0001\u001a\u00020\u0016H\u0000¢\u0006\u0003\b©\u0001J\u0011\u0010ª\u0001\u001a\u00030 \u0001H\u0082@¢\u0006\u0003\u0010«\u0001J\u0013\u0010¬\u0001\u001a\u00030 \u00012\u0007\u0010\u00ad\u0001\u001a\u00020DH\u0002J\u0012\u0010®\u0001\u001a\u00020\u00052\u0007\u0010¯\u0001\u001a\u00020\u0005H\u0016J\u0010\u0010°\u0001\u001a\u00020\u00052\u0007\u0010¡\u0001\u001a\u00020\u0003J\u0012\u0010±\u0001\u001a\u00020\u00162\u0007\u0010²\u0001\u001a\u00020\u0005H\u0002J\t\u0010³\u0001\u001a\u00020\u0016H\u0002J#\u0010´\u0001\u001a\u00020\u00032\b\u0010µ\u0001\u001a\u00030¶\u00012\b\b\u0002\u0010\u0002\u001a\u00020\u0003H\u0000¢\u0006\u0003\b·\u0001J\u001c\u0010¸\u0001\u001a\u00030 \u00012\u0007\u0010¯\u0001\u001a\u00020\u00052\u0007\u0010\u00ad\u0001\u001a\u00020DH\u0002J\u0012\u0010¹\u0001\u001a\u00020\u00052\u0007\u0010¯\u0001\u001a\u00020\u0005H\u0002J\u001e\u0010º\u0001\u001a\u00030 \u00012\t\b\u0001\u0010¡\u0001\u001a\u00020\u00032\t\b\u0003\u0010¢\u0001\u001a\u00020\u0005JK\u0010»\u0001\u001a\u00030 \u00012\b\u0010¼\u0001\u001a\u00030½\u00012.\u0010¾\u0001\u001a)\b\u0001\u0012\u0005\u0012\u00030À\u0001\u0012\f\u0012\n\u0012\u0005\u0012\u00030 \u00010Á\u0001\u0012\u0007\u0012\u0005\u0018\u00010Â\u00010¿\u0001¢\u0006\u0003\bÃ\u0001H\u0096@¢\u0006\u0003\u0010Ä\u0001J%\u0010Å\u0001\u001a\u00030 \u00012\u0007\u0010¡\u0001\u001a\u00020\u00032\t\b\u0003\u0010¢\u0001\u001a\u00020\u0005H\u0086@¢\u0006\u0003\u0010Æ\u0001J+\u0010Ç\u0001\u001a\u00030 \u00012\u0007\u0010¡\u0001\u001a\u00020\u00032\u0007\u0010È\u0001\u001a\u00020\u00052\u0007\u0010É\u0001\u001a\u00020\u0016H\u0000¢\u0006\u0003\bÊ\u0001J\u0013\u0010Ë\u0001\u001a\u00030 \u00012\u0007\u0010§\u0001\u001a\u00020bH\u0002J\r\u0010Ì\u0001\u001a\u00020\u0003*\u00020\u0003H\u0002J#\u0010Í\u0001\u001a\u00030 \u0001*\u00030À\u00012\u0007\u0010¡\u0001\u001a\u00020\u00032\t\b\u0003\u0010¢\u0001\u001a\u00020\u0005H\u0007J\u0018\u0010Î\u0001\u001a\u00030 \u0001*\u00030À\u00012\u0007\u0010\u0096\u0001\u001a\u00020\u0003H\u0007R\u000e\u0010\n\u001a\u00020\u0005X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\fX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\r\u001a\u00020\u000eX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u0014\u0010\u0011\u001a\u00020\u0012X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R+\u0010\u0017\u001a\u00020\u00162\u0006\u0010\u0015\u001a\u00020\u00168F@BX\u0086\u008e\u0002¢\u0006\u0012\n\u0004\b\u001c\u0010\u001d\u001a\u0004\b\u0018\u0010\u0019\"\u0004\b\u001a\u0010\u001bR+\u0010\u001e\u001a\u00020\u00162\u0006\u0010\u0015\u001a\u00020\u00168F@BX\u0086\u008e\u0002¢\u0006\u0012\n\u0004\b!\u0010\u001d\u001a\u0004\b\u001f\u0010\u0019\"\u0004\b \u0010\u001bR\u0011\u0010\u0002\u001a\u00020\u00038F¢\u0006\u0006\u001a\u0004\b\"\u0010#R\u0011\u0010\u0004\u001a\u00020\u00058F¢\u0006\u0006\u001a\u0004\b$\u0010%R\u0010\u0010&\u001a\u0004\u0018\u00010'X\u0082\u000e¢\u0006\u0002\n\u0000R\u001a\u0010(\u001a\u00020)X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b*\u0010+\"\u0004\b,\u0010-R\u001e\u0010.\u001a\u00020\u00032\u0006\u0010\u0015\u001a\u00020\u0003@BX\u0080\u000e¢\u0006\b\n\u0000\u001a\u0004\b/\u0010#R\u001e\u00100\u001a\u00020\u00032\u0006\u0010\u0015\u001a\u00020\u0003@BX\u0080\u000e¢\u0006\b\n\u0000\u001a\u0004\b1\u0010#R\u000e\u00102\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000R\u0011\u00103\u001a\u0002048F¢\u0006\u0006\u001a\u0004\b5\u00106R\u0014\u00107\u001a\u000208X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b9\u0010:R\u0014\u0010;\u001a\b\u0012\u0004\u0012\u00020\u00160<X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010=\u001a\b\u0012\u0004\u0012\u00020\u00160<X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010>\u001a\u00020\u00168VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b>\u0010\u0019R\u0014\u0010?\u001a\u00020\u00168VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b@\u0010\u0019R\u0014\u0010A\u001a\u00020\u00168VX\u0096\u0004¢\u0006\u0006\u001a\u0004\bB\u0010\u0019R\u0011\u0010C\u001a\u00020D8F¢\u0006\u0006\u001a\u0004\bE\u0010FR\u001e\u0010G\u001a\u00020\u00032\u0006\u0010\u0015\u001a\u00020\u0003@BX\u0080\u000e¢\u0006\b\n\u0000\u001a\u0004\bH\u0010#R\u000e\u0010I\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010J\u001a\u00020KX\u0082\u000e¢\u0006\u0002\n\u0000R\u001c\u0010L\u001a\u00020MX\u0080\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u001d\u001a\u0004\bN\u0010OR\u000e\u0010P\u001a\u00020KX\u0082\u000e¢\u0006\u0002\n\u0000R\u001b\u0010Q\u001a\u00020R8@X\u0080\u0084\u0002¢\u0006\f\u001a\u0004\bU\u0010V*\u0004\bS\u0010TR\u0014\u0010W\u001a\u00020\u00038@X\u0080\u0004¢\u0006\u0006\u001a\u0004\bX\u0010#R\u0012\u0010Y\u001a\u00020\u0003X¦\u0004¢\u0006\u0006\u001a\u0004\bZ\u0010#R\u0014\u0010[\u001a\u00020\u00038@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b\\\u0010#R\u0014\u0010]\u001a\u00020\u00038@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b^\u0010#R\u0014\u0010_\u001a\u00020\u00038@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b`\u0010#R\u0014\u0010a\u001a\b\u0012\u0004\u0012\u00020b0<X\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010c\u001a\u00020dX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\be\u0010fR\u001c\u0010g\u001a\u00020MX\u0080\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u001d\u001a\u0004\bh\u0010OR\u0014\u0010i\u001a\u00020\u00058@X\u0080\u0004¢\u0006\u0006\u001a\u0004\bj\u0010%R\u0014\u0010k\u001a\u00020lX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\bm\u0010nR\u001a\u0010o\u001a\u00020\u0016X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bp\u0010\u0019\"\u0004\bq\u0010\u001bR\"\u0010r\u001a\u00020sX\u0080\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010x\u001a\u0004\bt\u0010u\"\u0004\bv\u0010wR\u000e\u0010y\u001a\u00020\u0005X\u0082\u000e¢\u0006\u0002\n\u0000R+\u0010z\u001a\u00020\u00032\u0006\u0010\u0015\u001a\u00020\u00038B@BX\u0082\u008e\u0002¢\u0006\u0012\n\u0004\b~\u0010\u007f\u001a\u0004\b{\u0010#\"\u0004\b|\u0010}R7\u0010\u0081\u0001\u001a\u0005\u0018\u00010\u0080\u00012\t\u0010\u0015\u001a\u0005\u0018\u00010\u0080\u00018@@BX\u0080\u008e\u0002¢\u0006\u0017\n\u0005\b\u0086\u0001\u0010\u001d\u001a\u0006\b\u0082\u0001\u0010\u0083\u0001\"\u0006\b\u0084\u0001\u0010\u0085\u0001R\u0018\u0010\u0087\u0001\u001a\u00030\u0088\u0001X\u0080\u0004¢\u0006\n\n\u0000\u001a\u0006\b\u0089\u0001\u0010\u008a\u0001R\u0010\u0010\u008b\u0001\u001a\u00030\u008c\u0001X\u0082\u0004¢\u0006\u0002\n\u0000R\u000f\u0010\u008d\u0001\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0002\n\u0000R\u001f\u0010\u008e\u0001\u001a\u00020\u00038FX\u0086\u0084\u0002¢\u0006\u000f\n\u0006\b\u0090\u0001\u0010\u0091\u0001\u001a\u0005\b\u008f\u0001\u0010#R/\u0010\u0092\u0001\u001a\u00020\u00032\u0006\u0010\u0015\u001a\u00020\u00038B@BX\u0082\u008e\u0002¢\u0006\u0015\n\u0005\b\u0095\u0001\u0010\u007f\u001a\u0005\b\u0093\u0001\u0010#\"\u0005\b\u0094\u0001\u0010}R\u001f\u0010\u0096\u0001\u001a\u00020\u00038FX\u0086\u0084\u0002¢\u0006\u000f\n\u0006\b\u0098\u0001\u0010\u0091\u0001\u001a\u0005\b\u0097\u0001\u0010#R7\u0010\u009a\u0001\u001a\u00030\u0099\u00012\u0007\u0010\u0015\u001a\u00030\u0099\u00018@@@X\u0080\u008e\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0015\n\u0005\b\u009d\u0001\u0010\u001d\u001a\u0005\b\u009b\u0001\u0010u\"\u0005\b\u009c\u0001\u0010wR\u000f\u0010\u009e\u0001\u001a\u00020\u0016X\u0082\u000e¢\u0006\u0002\n\u0000\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006Ï\u0001"}, d2 = {"Landroidx/compose/foundation/pager/PagerState;", "Landroidx/compose/foundation/gestures/ScrollableState;", "currentPage", "", "currentPageOffsetFraction", "", "(IF)V", "prefetchScheduler", "Landroidx/compose/foundation/lazy/layout/PrefetchScheduler;", "(IFLandroidx/compose/foundation/lazy/layout/PrefetchScheduler;)V", "accumulator", "animatedScrollScope", "Landroidx/compose/foundation/lazy/layout/LazyLayoutAnimateScrollScope;", "awaitLayoutModifier", "Landroidx/compose/foundation/lazy/layout/AwaitFirstLayoutModifier;", "getAwaitLayoutModifier$foundation_release", "()Landroidx/compose/foundation/lazy/layout/AwaitFirstLayoutModifier;", "beyondBoundsInfo", "Landroidx/compose/foundation/lazy/layout/LazyLayoutBeyondBoundsInfo;", "getBeyondBoundsInfo$foundation_release", "()Landroidx/compose/foundation/lazy/layout/LazyLayoutBeyondBoundsInfo;", "<set-?>", "", "canScrollBackward", "getCanScrollBackward", "()Z", "setCanScrollBackward", "(Z)V", "canScrollBackward$delegate", "Landroidx/compose/runtime/MutableState;", "canScrollForward", "getCanScrollForward", "setCanScrollForward", "canScrollForward$delegate", "getCurrentPage", "()I", "getCurrentPageOffsetFraction", "()F", "currentPrefetchHandle", "Landroidx/compose/foundation/lazy/layout/LazyLayoutPrefetchState$PrefetchHandle;", "density", "Landroidx/compose/ui/unit/Density;", "getDensity$foundation_release", "()Landroidx/compose/ui/unit/Density;", "setDensity$foundation_release", "(Landroidx/compose/ui/unit/Density;)V", "firstVisiblePage", "getFirstVisiblePage$foundation_release", "firstVisiblePageOffset", "getFirstVisiblePageOffset$foundation_release", "indexToPrefetch", "interactionSource", "Landroidx/compose/foundation/interaction/InteractionSource;", "getInteractionSource", "()Landroidx/compose/foundation/interaction/InteractionSource;", "internalInteractionSource", "Landroidx/compose/foundation/interaction/MutableInteractionSource;", "getInternalInteractionSource$foundation_release", "()Landroidx/compose/foundation/interaction/MutableInteractionSource;", "isLastScrollBackwardState", "Landroidx/compose/runtime/MutableState;", "isLastScrollForwardState", "isScrollInProgress", "lastScrolledBackward", "getLastScrolledBackward", "lastScrolledForward", "getLastScrolledForward", "layoutInfo", "Landroidx/compose/foundation/pager/PagerLayoutInfo;", "getLayoutInfo", "()Landroidx/compose/foundation/pager/PagerLayoutInfo;", "layoutWithMeasurement", "getLayoutWithMeasurement$foundation_release", "layoutWithoutMeasurement", "maxScrollOffset", "", "measurementScopeInvalidator", "Landroidx/compose/foundation/lazy/layout/ObservableScopeInvalidator;", "getMeasurementScopeInvalidator-zYiylxw$foundation_release", "()Landroidx/compose/runtime/MutableState;", "minScrollOffset", "nearestRange", "Lkotlin/ranges/IntRange;", "getNearestRange$foundation_release$delegate", "(Landroidx/compose/foundation/pager/PagerState;)Ljava/lang/Object;", "getNearestRange$foundation_release", "()Lkotlin/ranges/IntRange;", "numMeasurePasses", "getNumMeasurePasses$foundation_release", "pageCount", "getPageCount", "pageSize", "getPageSize$foundation_release", "pageSizeWithSpacing", "getPageSizeWithSpacing$foundation_release", "pageSpacing", "getPageSpacing$foundation_release", "pagerLayoutInfoState", "Landroidx/compose/foundation/pager/PagerMeasureResult;", "pinnedPages", "Landroidx/compose/foundation/lazy/layout/LazyLayoutPinnedItemList;", "getPinnedPages$foundation_release", "()Landroidx/compose/foundation/lazy/layout/LazyLayoutPinnedItemList;", "placementScopeInvalidator", "getPlacementScopeInvalidator-zYiylxw$foundation_release", "positionThresholdFraction", "getPositionThresholdFraction$foundation_release", "prefetchState", "Landroidx/compose/foundation/lazy/layout/LazyLayoutPrefetchState;", "getPrefetchState$foundation_release", "()Landroidx/compose/foundation/lazy/layout/LazyLayoutPrefetchState;", "prefetchingEnabled", "getPrefetchingEnabled$foundation_release", "setPrefetchingEnabled$foundation_release", "premeasureConstraints", "Landroidx/compose/ui/unit/Constraints;", "getPremeasureConstraints-msEJaDk$foundation_release", "()J", "setPremeasureConstraints-BRTryo0$foundation_release", "(J)V", "J", "previousPassDelta", "programmaticScrollTargetPage", "getProgrammaticScrollTargetPage", "setProgrammaticScrollTargetPage", "(I)V", "programmaticScrollTargetPage$delegate", "Landroidx/compose/runtime/MutableIntState;", "Landroidx/compose/ui/layout/Remeasurement;", "remeasurement", "getRemeasurement$foundation_release", "()Landroidx/compose/ui/layout/Remeasurement;", "setRemeasurement", "(Landroidx/compose/ui/layout/Remeasurement;)V", "remeasurement$delegate", "remeasurementModifier", "Landroidx/compose/ui/layout/RemeasurementModifier;", "getRemeasurementModifier$foundation_release", "()Landroidx/compose/ui/layout/RemeasurementModifier;", "scrollPosition", "Landroidx/compose/foundation/pager/PagerScrollPosition;", "scrollableState", "settledPage", "getSettledPage", "settledPage$delegate", "Landroidx/compose/runtime/State;", "settledPageState", "getSettledPageState", "setSettledPageState", "settledPageState$delegate", "targetPage", "getTargetPage", "targetPage$delegate", "Landroidx/compose/ui/geometry/Offset;", "upDownDifference", "getUpDownDifference-F1C5BW0$foundation_release", "setUpDownDifference-k-4lQ0M$foundation_release", "upDownDifference$delegate", "wasPrefetchingForward", "animateScrollToPage", "", "page", "pageOffsetFraction", "animationSpec", "Landroidx/compose/animation/core/AnimationSpec;", "(IFLandroidx/compose/animation/core/AnimationSpec;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "applyMeasureResult", "result", "visibleItemsStayedTheSame", "applyMeasureResult$foundation_release", "awaitScrollDependencies", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "cancelPrefetchIfVisibleItemsChanged", "info", "dispatchRawDelta", "delta", "getOffsetDistanceInPages", "isGestureActionMatchesScroll", "scrollDelta", "isNotGestureAction", "matchScrollPositionWithKey", "itemProvider", "Landroidx/compose/foundation/pager/PagerLazyLayoutItemProvider;", "matchScrollPositionWithKey$foundation_release", "notifyPrefetch", "performScroll", "requestScrollToPage", "scroll", "scrollPriority", "Landroidx/compose/foundation/MutatePriority;", "block", "Lkotlin/Function2;", "Landroidx/compose/foundation/gestures/ScrollScope;", "Lkotlin/coroutines/Continuation;", "", "Lkotlin/ExtensionFunctionType;", "(Landroidx/compose/foundation/MutatePriority;Lkotlin/jvm/functions/Function2;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "scrollToPage", "(IFLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "snapToItem", "offsetFraction", "forceRemeasure", "snapToItem$foundation_release", "tryRunPrefetch", "coerceInPageRange", "updateCurrentPage", "updateTargetPage", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public abstract class PagerState implements ScrollableState {
    public static final int $stable = 0;
    private float accumulator;
    private final LazyLayoutAnimateScrollScope animatedScrollScope;
    private final AwaitFirstLayoutModifier awaitLayoutModifier;
    private final LazyLayoutBeyondBoundsInfo beyondBoundsInfo;

    private final MutableState canScrollBackward;

    private final MutableState canScrollForward;
    private LazyLayoutPrefetchState.PrefetchHandle currentPrefetchHandle;
    private Density density;
    private int firstVisiblePage;
    private int firstVisiblePageOffset;
    private int indexToPrefetch;
    private final MutableInteractionSource internalInteractionSource;
    private final MutableState<Boolean> isLastScrollBackwardState;
    private final MutableState<Boolean> isLastScrollForwardState;
    private int layoutWithMeasurement;
    private int layoutWithoutMeasurement;
    private long maxScrollOffset;
    private final MutableState<Unit> measurementScopeInvalidator;
    private long minScrollOffset;
    private MutableState<PagerMeasureResult> pagerLayoutInfoState;
    private final LazyLayoutPinnedItemList pinnedPages;
    private final MutableState<Unit> placementScopeInvalidator;
    private final LazyLayoutPrefetchState prefetchState;
    private boolean prefetchingEnabled;
    private long premeasureConstraints;
    private float previousPassDelta;

    private final MutableIntState programmaticScrollTargetPage;

    private final MutableState remeasurement;
    private final RemeasurementModifier remeasurementModifier;
    private final PagerScrollPosition scrollPosition;
    private final ScrollableState scrollableState;

    private final State settledPage;

    private final MutableIntState settledPageState;

    private final State targetPage;

    private final MutableState upDownDifference;
    private boolean wasPrefetchingForward;

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.pager.PagerState", f = "PagerState.kt", i = {0, 0, 0, 0}, l = {605, 613}, m = "animateScrollToPage", n = {"this", "animationSpec", "page", "pageOffsetFraction"}, s = {"L$0", "L$1", "I$0", "F$0"})
    static final class C07551 extends ContinuationImpl {
        float F$0;
        int I$0;
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C07551(Continuation<? super C07551> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return PagerState.this.animateScrollToPage(0, 0.0f, null, (Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.pager.PagerState", f = "PagerState.kt", i = {0, 0, 0, 1}, l = {629, 634}, m = "scroll$suspendImpl", n = {"$this", "scrollPriority", "block", "$this"}, s = {"L$0", "L$1", "L$2", "L$0"})
    static final class C07581 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C07581(Continuation<? super C07581> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return PagerState.scroll$suspendImpl(PagerState.this, null, null, (Continuation) this);
        }
    }

    public PagerState() {
        this(0, 0.0f, null, 7, null);
    }

    public abstract int getPageCount();

    @Override
    public Object scroll(MutatePriority mutatePriority, Function2<? super ScrollScope, ? super Continuation<? super Unit>, ? extends Object> function2, Continuation<? super Unit> continuation) {
        return scroll$suspendImpl(this, mutatePriority, function2, continuation);
    }

    public PagerState(int i, float f, PrefetchScheduler prefetchScheduler) {
        double d = f;
        if (-0.5d <= d && d <= 0.5d) {
            this.upDownDifference = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(Offset.m4335boximpl(Offset.INSTANCE.m4362getZeroF1C5BW0()), null, 2, null);
            this.animatedScrollScope = PagerLazyAnimateScrollScopeKt.PagerLazyAnimateScrollScope(this);
            PagerScrollPosition pagerScrollPosition = new PagerScrollPosition(i, f, this);
            this.scrollPosition = pagerScrollPosition;
            this.firstVisiblePage = i;
            this.maxScrollOffset = Long.MAX_VALUE;
            this.scrollableState = ScrollableStateKt.ScrollableState(new Function1<Float, Float>() {
                {
                    super(1);
                }

                public final Float invoke(float f2) {
                    return Float.valueOf(this.this$0.performScroll(f2));
                }

                public Object invoke(Object obj) {
                    return invoke(((Number) obj).floatValue());
                }
            });
            this.prefetchingEnabled = true;
            this.indexToPrefetch = -1;
            this.pagerLayoutInfoState = SnapshotStateKt.mutableStateOf(PagerStateKt.getEmptyLayoutInfo(), SnapshotStateKt.neverEqualPolicy());
            this.density = PagerStateKt.UnitDensity;
            this.internalInteractionSource = InteractionSourceKt.MutableInteractionSource();
            this.programmaticScrollTargetPage = SnapshotIntStateKt.mutableIntStateOf(-1);
            this.settledPageState = SnapshotIntStateKt.mutableIntStateOf(i);
            this.settledPage = SnapshotStateKt.derivedStateOf(SnapshotStateKt.structuralEqualityPolicy(), new Function0<Integer>() {
                {
                    super(0);
                }

                public final Integer m1344invoke() {
                    int currentPage;
                    if (this.this$0.isScrollInProgress()) {
                        currentPage = this.this$0.getSettledPageState();
                    } else {
                        currentPage = this.this$0.getCurrentPage();
                    }
                    return Integer.valueOf(currentPage);
                }
            });
            this.targetPage = SnapshotStateKt.derivedStateOf(SnapshotStateKt.structuralEqualityPolicy(), new Function0<Integer>() {
                {
                    super(0);
                }

                public final Integer m1345invoke() {
                    int currentPage;
                    if (this.this$0.isScrollInProgress()) {
                        if (this.this$0.getProgrammaticScrollTargetPage() != -1) {
                            currentPage = this.this$0.getProgrammaticScrollTargetPage();
                        } else if (Math.abs(this.this$0.getCurrentPageOffsetFraction()) >= Math.abs(this.this$0.getPositionThresholdFraction$foundation_release())) {
                            if (this.this$0.getLastScrolledForward()) {
                                currentPage = this.this$0.getFirstVisiblePage() + 1;
                            } else {
                                currentPage = this.this$0.getFirstVisiblePage();
                            }
                        } else {
                            currentPage = this.this$0.getCurrentPage();
                        }
                    } else {
                        currentPage = this.this$0.getCurrentPage();
                    }
                    return Integer.valueOf(this.this$0.coerceInPageRange(currentPage));
                }
            });
            this.prefetchState = new LazyLayoutPrefetchState(prefetchScheduler, null, 2, null);
            this.beyondBoundsInfo = new LazyLayoutBeyondBoundsInfo();
            this.awaitLayoutModifier = new AwaitFirstLayoutModifier();
            this.remeasurement = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
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
                    this.this$0.setRemeasurement(remeasurement);
                }
            };
            this.premeasureConstraints = ConstraintsKt.Constraints$default(0, 0, 0, 0, 15, (Object) null);
            this.pinnedPages = new LazyLayoutPinnedItemList();
            pagerScrollPosition.getNearestRangeState();
            this.placementScopeInvalidator = ObservableScopeInvalidator.m1254constructorimpl$default(null, 1, null);
            this.measurementScopeInvalidator = ObservableScopeInvalidator.m1254constructorimpl$default(null, 1, null);
            this.canScrollForward = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(false, null, 2, null);
            this.canScrollBackward = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(false, null, 2, null);
            this.isLastScrollForwardState = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(false, null, 2, null);
            this.isLastScrollBackwardState = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(false, null, 2, null);
            return;
        }
        throw new IllegalArgumentException(("currentPageOffsetFraction " + f + " is not within the range -0.5 to 0.5").toString());
    }

    public PagerState(int i, float f, PrefetchScheduler prefetchScheduler, int i2, DefaultConstructorMarker defaultConstructorMarker) {
        this((i2 & 1) != 0 ? 0 : i, (i2 & 2) != 0 ? 0.0f : f, (i2 & 4) != 0 ? null : prefetchScheduler);
    }

    public PagerState(int i, float f, int i2, DefaultConstructorMarker defaultConstructorMarker) {
        this((i2 & 1) != 0 ? 0 : i, (i2 & 2) != 0 ? 0.0f : f);
    }

    public PagerState(int i, float f) {
        this(i, f, null);
    }

    public final long m1341getUpDownDifferenceF1C5BW0$foundation_release() {
        return ((Offset) this.upDownDifference.getValue()).getPackedValue();
    }

    public final void m1343setUpDownDifferencek4lQ0M$foundation_release(long j) {
        this.upDownDifference.setValue(Offset.m4335boximpl(j));
    }

    public final int getFirstVisiblePage() {
        return this.firstVisiblePage;
    }

    public final int getFirstVisiblePageOffset() {
        return this.firstVisiblePageOffset;
    }

    public final float performScroll(float delta) {
        long jCurrentAbsoluteScrollOffset = PagerScrollPositionKt.currentAbsoluteScrollOffset(this);
        float f = this.accumulator + delta;
        long jRoundToLong = MathKt.roundToLong(f);
        this.accumulator = f - jRoundToLong;
        if (Math.abs(delta) < 1.0E-4f) {
            return delta;
        }
        long j = jRoundToLong + jCurrentAbsoluteScrollOffset;
        long jCoerceIn = RangesKt.coerceIn(j, this.minScrollOffset, this.maxScrollOffset);
        boolean z = j != jCoerceIn;
        long j2 = jCoerceIn - jCurrentAbsoluteScrollOffset;
        float f2 = j2;
        this.previousPassDelta = f2;
        if (Math.abs(j2) != 0) {
            this.isLastScrollForwardState.setValue(Boolean.valueOf(f2 > 0.0f));
            this.isLastScrollBackwardState.setValue(Boolean.valueOf(f2 < 0.0f));
        }
        PagerMeasureResult value = this.pagerLayoutInfoState.getValue();
        int i = (int) j2;
        if (value.tryToApplyScrollWithoutRemeasure(-i)) {
            applyMeasureResult$foundation_release(value, true);
            ObservableScopeInvalidator.m1258invalidateScopeimpl(this.placementScopeInvalidator);
            this.layoutWithoutMeasurement++;
        } else {
            this.scrollPosition.applyScrollDelta(i);
            Remeasurement remeasurement$foundation_release = getRemeasurement$foundation_release();
            if (remeasurement$foundation_release != null) {
                remeasurement$foundation_release.forceRemeasure();
            }
            this.layoutWithMeasurement++;
        }
        return (z ? Long.valueOf(j2) : Float.valueOf(delta)).floatValue();
    }

    public final int getNumMeasurePasses$foundation_release() {
        return this.layoutWithMeasurement + this.layoutWithoutMeasurement;
    }

    public final int getLayoutWithMeasurement() {
        return this.layoutWithMeasurement;
    }

    public final boolean getPrefetchingEnabled() {
        return this.prefetchingEnabled;
    }

    public final void setPrefetchingEnabled$foundation_release(boolean z) {
        this.prefetchingEnabled = z;
    }

    public final PagerLayoutInfo getLayoutInfo() {
        return this.pagerLayoutInfoState.getValue();
    }

    public final int getPageSpacing$foundation_release() {
        return this.pagerLayoutInfoState.getValue().getPageSpacing();
    }

    public final int getPageSize$foundation_release() {
        return this.pagerLayoutInfoState.getValue().getPageSize();
    }

    public final Density getDensity() {
        return this.density;
    }

    public final void setDensity$foundation_release(Density density) {
        this.density = density;
    }

    public final int getPageSizeWithSpacing$foundation_release() {
        return getPageSize$foundation_release() + getPageSpacing$foundation_release();
    }

    public final float getPositionThresholdFraction$foundation_release() {
        return Math.min(this.density.toPx-0680j_4(PagerStateKt.getDefaultPositionThreshold()), getPageSize$foundation_release() / 2.0f) / getPageSize$foundation_release();
    }

    public final MutableInteractionSource getInternalInteractionSource() {
        return this.internalInteractionSource;
    }

    public final InteractionSource getInteractionSource() {
        return this.internalInteractionSource;
    }

    public final int getCurrentPage() {
        return this.scrollPosition.getCurrentPage();
    }

    public final int getProgrammaticScrollTargetPage() {
        return this.programmaticScrollTargetPage.getIntValue();
    }

    private final void setProgrammaticScrollTargetPage(int i) {
        this.programmaticScrollTargetPage.setIntValue(i);
    }

    public final int getSettledPageState() {
        return this.settledPageState.getIntValue();
    }

    private final void setSettledPageState(int i) {
        this.settledPageState.setIntValue(i);
    }

    public final int getSettledPage() {
        return ((Number) this.settledPage.getValue()).intValue();
    }

    public final int getTargetPage() {
        return ((Number) this.targetPage.getValue()).intValue();
    }

    public final float getCurrentPageOffsetFraction() {
        return this.scrollPosition.getCurrentPageOffsetFraction();
    }

    public final LazyLayoutPrefetchState getPrefetchState() {
        return this.prefetchState;
    }

    public final LazyLayoutBeyondBoundsInfo getBeyondBoundsInfo() {
        return this.beyondBoundsInfo;
    }

    public final AwaitFirstLayoutModifier getAwaitLayoutModifier() {
        return this.awaitLayoutModifier;
    }

    public final void setRemeasurement(Remeasurement remeasurement) {
        this.remeasurement.setValue(remeasurement);
    }

    public final Remeasurement getRemeasurement$foundation_release() {
        return (Remeasurement) this.remeasurement.getValue();
    }

    public final RemeasurementModifier getRemeasurementModifier() {
        return this.remeasurementModifier;
    }

    public final long getPremeasureConstraints() {
        return this.premeasureConstraints;
    }

    public final void m1342setPremeasureConstraintsBRTryo0$foundation_release(long j) {
        this.premeasureConstraints = j;
    }

    public final LazyLayoutPinnedItemList getPinnedPages() {
        return this.pinnedPages;
    }

    public final IntRange getNearestRange$foundation_release() {
        return this.scrollPosition.getNearestRangeState().getValue();
    }

    public final MutableState<Unit> m1339getPlacementScopeInvalidatorzYiylxw$foundation_release() {
        return this.placementScopeInvalidator;
    }

    public static Object scrollToPage$default(PagerState pagerState, int i, float f, Continuation continuation, int i2, Object obj) {
        if (obj != null) {
            throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: scrollToPage");
        }
        if ((i2 & 2) != 0) {
            f = 0.0f;
        }
        return pagerState.scrollToPage(i, f, continuation);
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/foundation/gestures/ScrollScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.pager.PagerState$scrollToPage$2", f = "PagerState.kt", i = {}, l = {498}, m = "invokeSuspend", n = {}, s = {})
    static final class C07592 extends SuspendLambda implements Function2<ScrollScope, Continuation<? super Unit>, Object> {
        final int $page;
        final float $pageOffsetFraction;
        int label;

        C07592(float f, int i, Continuation<? super C07592> continuation) {
            super(2, continuation);
            this.$pageOffsetFraction = f;
            this.$page = i;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return PagerState.this.new C07592(this.$pageOffsetFraction, this.$page, continuation);
        }

        public final Object invoke(ScrollScope scrollScope, Continuation<? super Unit> continuation) {
            return create(scrollScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (PagerState.this.awaitScrollDependencies((Continuation) this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            float f = this.$pageOffsetFraction;
            double d = f;
            boolean z = false;
            if (-0.5d <= d && d <= 0.5d) {
                z = true;
            }
            if (z) {
                PagerState.this.snapToItem$foundation_release(PagerState.this.coerceInPageRange(this.$page), this.$pageOffsetFraction, true);
                return Unit.INSTANCE;
            }
            throw new IllegalArgumentException(("pageOffsetFraction " + f + " is not within the range -0.5 to 0.5").toString());
        }
    }

    public final Object scrollToPage(int i, float f, Continuation<? super Unit> continuation) {
        Object objScroll$default = ScrollableState.CC.scroll$default(this, null, new C07592(f, i, null), continuation, 1, null);
        return objScroll$default == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objScroll$default : Unit.INSTANCE;
    }

    public static void updateCurrentPage$default(PagerState pagerState, ScrollScope scrollScope, int i, float f, int i2, Object obj) {
        if (obj != null) {
            throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: updateCurrentPage");
        }
        if ((i2 & 2) != 0) {
            f = 0.0f;
        }
        pagerState.updateCurrentPage(scrollScope, i, f);
    }

    public final void updateCurrentPage(ScrollScope scrollScope, int i, float f) {
        snapToItem$foundation_release(i, f, true);
    }

    public final void updateTargetPage(ScrollScope scrollScope, int i) {
        setProgrammaticScrollTargetPage(coerceInPageRange(i));
    }

    public final void snapToItem$foundation_release(int page, float offsetFraction, boolean forceRemeasure) {
        this.scrollPosition.requestPositionAndForgetLastKnownKey(page, offsetFraction);
        if (forceRemeasure) {
            Remeasurement remeasurement$foundation_release = getRemeasurement$foundation_release();
            if (remeasurement$foundation_release != null) {
                remeasurement$foundation_release.forceRemeasure();
                return;
            }
            return;
        }
        ObservableScopeInvalidator.m1258invalidateScopeimpl(this.measurementScopeInvalidator);
    }

    public final MutableState<Unit> m1338getMeasurementScopeInvalidatorzYiylxw$foundation_release() {
        return this.measurementScopeInvalidator;
    }

    public static void requestScrollToPage$default(PagerState pagerState, int i, float f, int i2, Object obj) {
        if (obj != null) {
            throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: requestScrollToPage");
        }
        if ((i2 & 2) != 0) {
            f = 0.0f;
        }
        pagerState.requestScrollToPage(i, f);
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.pager.PagerState$requestScrollToPage$1", f = "PagerState.kt", i = {}, l = {576}, m = "invokeSuspend", n = {}, s = {})
    static final class C07571 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C07571(Continuation<? super C07571> continuation) {
            super(2, continuation);
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return PagerState.this.new C07571(continuation);
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
                if (ScrollExtensionsKt.stopScroll$default(PagerState.this, null, (Continuation) this, 1, null) == coroutine_suspended) {
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

    public final void requestScrollToPage(int page, float pageOffsetFraction) {
        if (isScrollInProgress()) {
            BuildersKt.launch$default(this.pagerLayoutInfoState.getValue().getCoroutineScope(), (CoroutineContext) null, (CoroutineStart) null, new C07571(null), 3, (Object) null);
        }
        snapToItem$foundation_release(page, pageOffsetFraction, false);
    }

    public final Object animateScrollToPage(int i, float f, AnimationSpec<Float> animationSpec, Continuation<? super Unit> continuation) {
        C07551 c07551;
        PagerState pagerState;
        if (continuation instanceof C07551) {
            c07551 = (C07551) continuation;
            if ((c07551.label & Integer.MIN_VALUE) != 0) {
                c07551.label -= Integer.MIN_VALUE;
            } else {
                c07551 = new C07551(continuation);
            }
        } else {
            c07551 = new C07551(continuation);
        }
        C07551 c07552 = c07551;
        Object obj = c07552.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i2 = c07552.label;
        if (i2 == 0) {
            ResultKt.throwOnFailure(obj);
            if ((i == getCurrentPage() && getCurrentPageOffsetFraction() == f) || getPageCount() == 0) {
                return Unit.INSTANCE;
            }
            c07552.L$0 = this;
            c07552.L$1 = animationSpec;
            c07552.I$0 = i;
            c07552.F$0 = f;
            c07552.label = 1;
            if (awaitScrollDependencies(c07552) == coroutine_suspended) {
                return coroutine_suspended;
            }
            pagerState = this;
        } else {
            if (i2 == 1) {
                f = c07552.F$0;
                i = c07552.I$0;
                animationSpec = (AnimationSpec) c07552.L$1;
                pagerState = (PagerState) c07552.L$0;
                ResultKt.throwOnFailure(obj);
            } else {
                if (i2 != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
        AnimationSpec<Float> animationSpec2 = animationSpec;
        double d = f;
        if (-0.5d > d || d > 0.5d) {
            throw new IllegalArgumentException(("pageOffsetFraction " + f + " is not within the range -0.5 to 0.5").toString());
        }
        int iCoerceInPageRange = pagerState.coerceInPageRange(i);
        float pageSizeWithSpacing$foundation_release = f * pagerState.getPageSizeWithSpacing$foundation_release();
        LazyLayoutAnimateScrollScope lazyLayoutAnimateScrollScope = pagerState.animatedScrollScope;
        Function2<ScrollScope, Integer, Unit> function2 = new Function2<ScrollScope, Integer, Unit>() {
            {
                super(2);
            }

            public Object invoke(Object obj2, Object obj3) {
                invoke((ScrollScope) obj2, ((Number) obj3).intValue());
                return Unit.INSTANCE;
            }

            public final void invoke(ScrollScope scrollScope, int i3) {
                PagerState.this.updateTargetPage(scrollScope, i3);
            }
        };
        c07552.L$0 = null;
        c07552.L$1 = null;
        c07552.label = 2;
        if (PagerStateKt.animateScrollToPage(lazyLayoutAnimateScrollScope, iCoerceInPageRange, pageSizeWithSpacing$foundation_release, animationSpec2, function2, c07552) == coroutine_suspended) {
            return coroutine_suspended;
        }
        return Unit.INSTANCE;
    }

    public static Object animateScrollToPage$default(PagerState pagerState, int i, float f, AnimationSpec animationSpec, Continuation continuation, int i2, Object obj) {
        if (obj != null) {
            throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: animateScrollToPage");
        }
        if ((i2 & 2) != 0) {
            f = 0.0f;
        }
        if ((i2 & 4) != 0) {
            animationSpec = AnimationSpecKt.spring$default(0.0f, 0.0f, null, 7, null);
        }
        return pagerState.animateScrollToPage(i, f, animationSpec, continuation);
    }

    public final Object awaitScrollDependencies(Continuation<? super Unit> continuation) {
        Object objWaitForFirstLayout = this.awaitLayoutModifier.waitForFirstLayout(continuation);
        return objWaitForFirstLayout == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objWaitForFirstLayout : Unit.INSTANCE;
    }

    static Object scroll$suspendImpl(PagerState pagerState, MutatePriority mutatePriority, Function2<? super ScrollScope, ? super Continuation<? super Unit>, ? extends Object> function2, Continuation<? super Unit> continuation) {
        C07581 c07581;
        if (continuation instanceof C07581) {
            c07581 = (C07581) continuation;
            if ((c07581.label & Integer.MIN_VALUE) != 0) {
                c07581.label -= Integer.MIN_VALUE;
            } else {
                c07581 = pagerState.new C07581(continuation);
            }
        } else {
            c07581 = pagerState.new C07581(continuation);
        }
        Object obj = c07581.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c07581.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            c07581.L$0 = pagerState;
            c07581.L$1 = mutatePriority;
            c07581.L$2 = function2;
            c07581.label = 1;
            if (pagerState.awaitScrollDependencies(c07581) == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i == 1) {
                function2 = (Function2) c07581.L$2;
                mutatePriority = (MutatePriority) c07581.L$1;
                pagerState = (PagerState) c07581.L$0;
                ResultKt.throwOnFailure(obj);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                pagerState = (PagerState) c07581.L$0;
                ResultKt.throwOnFailure(obj);
            }
            pagerState.setProgrammaticScrollTargetPage(-1);
            return Unit.INSTANCE;
        }
        if (!pagerState.isScrollInProgress()) {
            pagerState.setSettledPageState(pagerState.getCurrentPage());
        }
        ScrollableState scrollableState = pagerState.scrollableState;
        c07581.L$0 = pagerState;
        c07581.L$1 = null;
        c07581.L$2 = null;
        c07581.label = 2;
        if (scrollableState.scroll(mutatePriority, function2, c07581) == coroutine_suspended) {
            return coroutine_suspended;
        }
        pagerState.setProgrammaticScrollTargetPage(-1);
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

    private final void setCanScrollForward(boolean z) {
        this.canScrollForward.setValue(Boolean.valueOf(z));
    }

    @Override
    public final boolean getCanScrollForward() {
        return ((Boolean) this.canScrollForward.getValue()).booleanValue();
    }

    private final void setCanScrollBackward(boolean z) {
        this.canScrollBackward.setValue(Boolean.valueOf(z));
    }

    @Override
    public final boolean getCanScrollBackward() {
        return ((Boolean) this.canScrollBackward.getValue()).booleanValue();
    }

    @Override
    public boolean getLastScrolledForward() {
        return this.isLastScrollForwardState.getValue().booleanValue();
    }

    @Override
    public boolean getLastScrolledBackward() {
        return this.isLastScrollBackwardState.getValue().booleanValue();
    }

    public static void applyMeasureResult$foundation_release$default(PagerState pagerState, PagerMeasureResult pagerMeasureResult, boolean z, int i, Object obj) {
        if (obj != null) {
            throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: applyMeasureResult");
        }
        if ((i & 2) != 0) {
            z = false;
        }
        pagerState.applyMeasureResult$foundation_release(pagerMeasureResult, z);
    }

    public final void applyMeasureResult$foundation_release(PagerMeasureResult result, boolean visibleItemsStayedTheSame) {
        if (visibleItemsStayedTheSame) {
            this.scrollPosition.updateCurrentPageOffsetFraction(result.getCurrentPageOffsetFraction());
        } else {
            this.scrollPosition.updateFromMeasureResult(result);
            cancelPrefetchIfVisibleItemsChanged(result);
        }
        this.pagerLayoutInfoState.setValue(result);
        setCanScrollForward(result.getCanScrollForward());
        setCanScrollBackward(result.getCanScrollBackward());
        MeasuredPage firstVisiblePage = result.getFirstVisiblePage();
        if (firstVisiblePage != null) {
            this.firstVisiblePage = firstVisiblePage.getIndex();
        }
        this.firstVisiblePageOffset = result.getFirstVisiblePageScrollOffset();
        tryRunPrefetch(result);
        this.maxScrollOffset = PagerStateKt.calculateNewMaxScrollOffset(result, getPageCount());
        this.minScrollOffset = PagerStateKt.calculateNewMinScrollOffset(result, getPageCount());
    }

    private final void tryRunPrefetch(PagerMeasureResult result) {
        Snapshot.Companion companion = Snapshot.INSTANCE;
        Snapshot currentThreadSnapshot = companion.getCurrentThreadSnapshot();
        Function1<Object, Unit> readObserver = currentThreadSnapshot != null ? currentThreadSnapshot.getReadObserver() : null;
        Snapshot snapshotMakeCurrentNonObservable = companion.makeCurrentNonObservable(currentThreadSnapshot);
        try {
            if (Math.abs(this.previousPassDelta) > 0.5f && this.prefetchingEnabled && isGestureActionMatchesScroll(this.previousPassDelta)) {
                notifyPrefetch(this.previousPassDelta, result);
            }
            Unit unit = Unit.INSTANCE;
        } finally {
            companion.restoreNonObservable(currentThreadSnapshot, snapshotMakeCurrentNonObservable, readObserver);
        }
    }

    public final int coerceInPageRange(int i) {
        if (getPageCount() > 0) {
            return RangesKt.coerceIn(i, 0, getPageCount() - 1);
        }
        return 0;
    }

    private final boolean isGestureActionMatchesScroll(float scrollDelta) {
        if (getLayoutInfo().getOrientation() != Orientation.Vertical ? Math.signum(scrollDelta) != Math.signum(-Offset.m4346getXimpl(m1341getUpDownDifferenceF1C5BW0$foundation_release())) : Math.signum(scrollDelta) != Math.signum(-Offset.m4347getYimpl(m1341getUpDownDifferenceF1C5BW0$foundation_release()))) {
            if (!isNotGestureAction()) {
                return false;
            }
        }
        return true;
    }

    private final boolean isNotGestureAction() {
        return ((int) Offset.m4346getXimpl(m1341getUpDownDifferenceF1C5BW0$foundation_release())) == 0 && ((int) Offset.m4347getYimpl(m1341getUpDownDifferenceF1C5BW0$foundation_release())) == 0;
    }

    private final void notifyPrefetch(float delta, PagerLayoutInfo info) {
        int index;
        LazyLayoutPrefetchState.PrefetchHandle prefetchHandle;
        LazyLayoutPrefetchState.PrefetchHandle prefetchHandle2;
        LazyLayoutPrefetchState.PrefetchHandle prefetchHandle3;
        if (this.prefetchingEnabled && !info.getVisiblePagesInfo().isEmpty()) {
            boolean z = delta > 0.0f;
            if (z) {
                index = ((PageInfo) CollectionsKt.last(info.getVisiblePagesInfo())).getIndex() + info.getBeyondViewportPageCount() + 1;
            } else {
                index = (((PageInfo) CollectionsKt.first(info.getVisiblePagesInfo())).getIndex() - info.getBeyondViewportPageCount()) - 1;
            }
            if (index < 0 || index >= getPageCount()) {
                return;
            }
            if (index != this.indexToPrefetch) {
                if (this.wasPrefetchingForward != z && (prefetchHandle3 = this.currentPrefetchHandle) != null) {
                    prefetchHandle3.cancel();
                }
                this.wasPrefetchingForward = z;
                this.indexToPrefetch = index;
                this.currentPrefetchHandle = this.prefetchState.m1243schedulePrefetch0kLqBqw(index, this.premeasureConstraints);
            }
            if (z) {
                if ((((PageInfo) CollectionsKt.last(info.getVisiblePagesInfo())).getOffset() + (info.getPageSize() + info.getPageSpacing())) - info.getViewportEndOffset() >= delta || (prefetchHandle2 = this.currentPrefetchHandle) == null) {
                    return;
                }
                prefetchHandle2.markAsUrgent();
                return;
            }
            if (info.getViewportStartOffset() - ((PageInfo) CollectionsKt.first(info.getVisiblePagesInfo())).getOffset() >= (-delta) || (prefetchHandle = this.currentPrefetchHandle) == null) {
                return;
            }
            prefetchHandle.markAsUrgent();
        }
    }

    private final void cancelPrefetchIfVisibleItemsChanged(PagerLayoutInfo info) {
        int index;
        if (this.indexToPrefetch == -1 || info.getVisiblePagesInfo().isEmpty()) {
            return;
        }
        if (this.wasPrefetchingForward) {
            index = ((PageInfo) CollectionsKt.last(info.getVisiblePagesInfo())).getIndex() + info.getBeyondViewportPageCount() + 1;
        } else {
            index = (((PageInfo) CollectionsKt.first(info.getVisiblePagesInfo())).getIndex() - info.getBeyondViewportPageCount()) - 1;
        }
        if (this.indexToPrefetch != index) {
            this.indexToPrefetch = -1;
            LazyLayoutPrefetchState.PrefetchHandle prefetchHandle = this.currentPrefetchHandle;
            if (prefetchHandle != null) {
                prefetchHandle.cancel();
            }
            this.currentPrefetchHandle = null;
        }
    }

    public final float getOffsetDistanceInPages(int page) {
        if (page < 0 || page > getPageCount()) {
            throw new IllegalArgumentException(("page " + page + " is not within the range 0 to " + getPageCount()).toString());
        }
        return (page - getCurrentPage()) - getCurrentPageOffsetFraction();
    }

    public static int matchScrollPositionWithKey$foundation_release$default(PagerState pagerState, PagerLazyLayoutItemProvider pagerLazyLayoutItemProvider, int i, int i2, Object obj) {
        if (obj != null) {
            throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: matchScrollPositionWithKey");
        }
        if ((i2 & 2) != 0) {
            Snapshot.Companion companion = Snapshot.INSTANCE;
            Snapshot currentThreadSnapshot = companion.getCurrentThreadSnapshot();
            Function1<Object, Unit> readObserver = currentThreadSnapshot != null ? currentThreadSnapshot.getReadObserver() : null;
            Snapshot snapshotMakeCurrentNonObservable = companion.makeCurrentNonObservable(currentThreadSnapshot);
            try {
                int currentPage = pagerState.scrollPosition.getCurrentPage();
                companion.restoreNonObservable(currentThreadSnapshot, snapshotMakeCurrentNonObservable, readObserver);
                i = currentPage;
            } catch (Throwable th) {
                companion.restoreNonObservable(currentThreadSnapshot, snapshotMakeCurrentNonObservable, readObserver);
                throw th;
            }
        }
        return pagerState.matchScrollPositionWithKey$foundation_release(pagerLazyLayoutItemProvider, i);
    }

    public final int matchScrollPositionWithKey$foundation_release(PagerLazyLayoutItemProvider itemProvider, int currentPage) {
        return this.scrollPosition.matchPageWithKey(itemProvider, currentPage);
    }
}
