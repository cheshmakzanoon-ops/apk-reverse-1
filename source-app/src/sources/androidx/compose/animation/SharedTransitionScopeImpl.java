package androidx.compose.animation;

import androidx.collection.MutableScatterMap;
import androidx.compose.animation.core.AnimationVector4D;
import androidx.compose.animation.core.MutableTransitionState;
import androidx.compose.animation.core.Transition;
import androidx.compose.animation.core.VectorConvertersKt;
import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.ComposedModifierKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.p002ui.graphics.AndroidPath_androidKt;
import androidx.compose.p002ui.graphics.OutlineKt;
import androidx.compose.p002ui.graphics.Path;
import androidx.compose.p002ui.graphics.Shape;
import androidx.compose.p002ui.graphics.drawscope.ContentDrawScope;
import androidx.compose.p002ui.layout.ContentScale;
import androidx.compose.p002ui.layout.LayoutCoordinates;
import androidx.compose.p002ui.layout.LookaheadScope;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import androidx.compose.runtime.snapshots.SnapshotStateList;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.LayoutDirection;
import java.util.Comparator;
import java.util.Iterator;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.comparisons.ComparisonsKt;
import kotlin.coroutines.CoroutineContext;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.TypeIntrinsics;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineStart;

@Metadata(d1 = {"\u0000à\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0007\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\t\b\u0001\u0018\u00002\u00020\u00012\u00020\u0002:\u0001uB\u0017\b\u0000\u0012\u0006\u0010\u0003\u001a\u00020\u0002\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u0010\u0010,\u001a\u00020-2\u0006\u0010.\u001a\u00020/H\u0016J\u0015\u00100\u001a\u00020\u001b2\u0006\u00101\u001a\u000202H\u0000¢\u0006\u0002\b3J\u0015\u00104\u001a\u00020\u001b2\u0006\u00105\u001a\u00020\u001eH\u0000¢\u0006\u0002\b6J\u0015\u00107\u001a\u00020\u001b2\u0006\u00105\u001a\u00020\u001eH\u0000¢\u0006\u0002\b8J\u0015\u00109\u001a\u00020\u001b2\u0006\u0010:\u001a\u00020;H\u0000¢\u0006\u0002\b<J\u0015\u0010=\u001a\u00020\u001b2\u0006\u0010:\u001a\u00020;H\u0000¢\u0006\u0002\b>J\u0015\u0010?\u001a\u00020@2\u0006\u0010A\u001a\u00020$H\u0017¢\u0006\u0002\u0010BJM\u0010C\u001a\u00020;2\u0006\u0010D\u001a\u00020%2\u0006\u0010E\u001a\u00020F2\u0006\u0010G\u001a\u00020H2\u0006\u0010I\u001a\u00020\n2\u0006\u0010J\u001a\u00020@2\u0006\u0010K\u001a\u00020-2\u0006\u0010L\u001a\u00020M2\u0006\u0010N\u001a\u00020\nH\u0003¢\u0006\u0002\u0010OJ\u0010\u0010P\u001a\u00020%2\u0006\u0010A\u001a\u00020$H\u0002J\b\u0010&\u001a\u00020\u001bH\u0002J3\u0010Q\u001a\u00020R*\u00020\u00122\u0006\u0010S\u001a\u00020\u00122\b\b\u0002\u0010T\u001a\u00020R2\b\b\u0002\u0010U\u001a\u00020\nH\u0096\u0001ø\u0001\u0000¢\u0006\u0004\bV\u0010WJ>\u0010X\u001a\u00020Y*\u00020Y2\f\u0010Z\u001a\b\u0012\u0004\u0012\u00020\n0\u001a2\u0006\u0010L\u001a\u00020M2\u001a\u0010K\u001a\u0016\u0012\u0004\u0012\u00020\\\u0012\u0004\u0012\u00020]\u0012\u0006\u0012\u0004\u0018\u00010^0[H\u0016J\\\u0010_\u001a\u00020Y*\u00020Y2\u0006\u0010J\u001a\u00020@2\u0006\u0010`\u001a\u00020a2\u0006\u0010b\u001a\u00020c2\u0006\u0010d\u001a\u00020e2\u0006\u0010f\u001a\u00020g2\u0006\u0010h\u001a\u00020i2\u0006\u0010G\u001a\u00020H2\u0006\u0010N\u001a\u00020\n2\u0006\u0010L\u001a\u00020M2\u0006\u0010K\u001a\u00020-H\u0016Jp\u0010j\u001a\u00020Y\"\u0004\b\u0000\u0010k*\u00020Y2\u0006\u0010J\u001a\u00020@2\u000e\u0010l\u001a\n\u0012\u0004\u0012\u0002Hk\u0018\u00010m2\u0012\u0010n\u001a\u000e\u0012\u0004\u0012\u0002Hk\u0012\u0004\u0012\u00020\n0'2\u0006\u0010f\u001a\u00020g2\b\b\u0002\u0010G\u001a\u00020H2\u0006\u0010I\u001a\u00020\n2\u0006\u0010N\u001a\u00020\n2\u0006\u0010L\u001a\u00020M2\u0006\u0010K\u001a\u00020-H\u0002JS\u0010o\u001a\u00020Y*\u00020Y2\u0006\u0010J\u001a\u00020@2\u0006\u0010n\u001a\u00020\n2\b\b\u0002\u0010f\u001a\u00020g2\b\b\u0002\u0010G\u001a\u00020H2\b\b\u0002\u0010N\u001a\u00020\n2\b\b\u0002\u0010L\u001a\u00020M2\b\b\u0002\u0010K\u001a\u00020-H\u0000¢\u0006\u0002\bpJD\u0010D\u001a\u00020Y*\u00020Y2\u0006\u0010q\u001a\u00020@2\u0006\u0010`\u001a\u00020a2\u0006\u0010f\u001a\u00020g2\u0006\u0010G\u001a\u00020H2\u0006\u0010N\u001a\u00020\n2\u0006\u0010L\u001a\u00020M2\u0006\u0010K\u001a\u00020-H\u0016JD\u0010r\u001a\u00020Y*\u00020Y2\u0006\u0010J\u001a\u00020@2\u0006\u0010n\u001a\u00020\n2\u0006\u0010f\u001a\u00020g2\u0006\u0010G\u001a\u00020H2\u0006\u0010N\u001a\u00020\n2\u0006\u0010L\u001a\u00020M2\u0006\u0010K\u001a\u00020-H\u0016J\f\u0010s\u001a\u00020Y*\u00020YH\u0016J\r\u0010t\u001a\u00020\u0012*\u00020\u0012H\u0096\u0001R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR+\u0010\u000b\u001a\u00020\n2\u0006\u0010\t\u001a\u00020\n8V@RX\u0096\u008e\u0002¢\u0006\u0012\n\u0004\b\u000f\u0010\u0010\u001a\u0004\b\u000b\u0010\f\"\u0004\b\r\u0010\u000eR\u0014\u0010\u0011\u001a\u00020\u00128@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b\u0013\u0010\u0014R\u001c\u0010\u0015\u001a\u0004\u0018\u00010\u0012X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0016\u0010\u0014\"\u0004\b\u0017\u0010\u0018R\u0014\u0010\u0019\u001a\b\u0012\u0004\u0012\u00020\u001b0\u001aX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u001c\u001a\b\u0012\u0004\u0012\u00020\u001e0\u001dX\u0082\u0004¢\u0006\u0002\n\u0000R\u001a\u0010\u001f\u001a\u00020\u0012X\u0080.¢\u0006\u000e\n\u0000\u001a\u0004\b \u0010\u0014\"\u0004\b!\u0010\u0018R\u001a\u0010\"\u001a\u000e\u0012\u0004\u0012\u00020$\u0012\u0004\u0012\u00020%0#X\u0082\u0004¢\u0006\u0002\n\u0000R\u001a\u0010&\u001a\u000e\u0012\u0004\u0012\u00020\u0001\u0012\u0004\u0012\u00020\u001b0'X\u0082\u0004¢\u0006\u0002\n\u0000R\u0016\u0010(\u001a\u00020\u0012*\u00020)X\u0096\u0005¢\u0006\u0006\u001a\u0004\b*\u0010+\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006v"}, d2 = {"Landroidx/compose/animation/SharedTransitionScopeImpl;", "Landroidx/compose/animation/SharedTransitionScope;", "Landroidx/compose/ui/layout/LookaheadScope;", "lookaheadScope", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "(Landroidx/compose/ui/layout/LookaheadScope;Lkotlinx/coroutines/CoroutineScope;)V", "getCoroutineScope", "()Lkotlinx/coroutines/CoroutineScope;", "<set-?>", "", "isTransitionActive", "()Z", "setTransitionActive", "(Z)V", "isTransitionActive$delegate", "Landroidx/compose/runtime/MutableState;", "lookaheadRoot", "Landroidx/compose/ui/layout/LayoutCoordinates;", "getLookaheadRoot$animation_release", "()Landroidx/compose/ui/layout/LayoutCoordinates;", "nullableLookaheadRoot", "getNullableLookaheadRoot$animation_release", "setNullableLookaheadRoot$animation_release", "(Landroidx/compose/ui/layout/LayoutCoordinates;)V", "observeAnimatingBlock", "Lkotlin/Function0;", "", "renderers", "Landroidx/compose/runtime/snapshots/SnapshotStateList;", "Landroidx/compose/animation/LayerRenderer;", "root", "getRoot$animation_release", "setRoot$animation_release", "sharedElements", "Landroidx/collection/MutableScatterMap;", "", "Landroidx/compose/animation/SharedElement;", "updateTransitionActiveness", "Lkotlin/Function1;", "lookaheadScopeCoordinates", "Landroidx/compose/ui/layout/Placeable$PlacementScope;", "getLookaheadScopeCoordinates", "(Landroidx/compose/ui/layout/Placeable$PlacementScope;)Landroidx/compose/ui/layout/LayoutCoordinates;", "OverlayClip", "Landroidx/compose/animation/SharedTransitionScope$OverlayClip;", "clipShape", "Landroidx/compose/ui/graphics/Shape;", "drawInOverlay", "scope", "Landroidx/compose/ui/graphics/drawscope/ContentDrawScope;", "drawInOverlay$animation_release", "onLayerRendererCreated", "renderer", "onLayerRendererCreated$animation_release", "onLayerRendererRemoved", "onLayerRendererRemoved$animation_release", "onStateAdded", "sharedElementState", "Landroidx/compose/animation/SharedElementInternalState;", "onStateAdded$animation_release", "onStateRemoved", "onStateRemoved$animation_release", "rememberSharedContentState", "Landroidx/compose/animation/SharedTransitionScope$SharedContentState;", "key", "(Ljava/lang/Object;Landroidx/compose/runtime/Composer;I)Landroidx/compose/animation/SharedTransitionScope$SharedContentState;", "rememberSharedElementState", "sharedElement", "boundsAnimation", "Landroidx/compose/animation/BoundsAnimation;", "placeHolderSize", "Landroidx/compose/animation/SharedTransitionScope$PlaceHolderSize;", "renderOnlyWhenVisible", "sharedContentState", "clipInOverlayDuringTransition", "zIndexInOverlay", "", "renderInOverlayDuringTransition", "(Landroidx/compose/animation/SharedElement;Landroidx/compose/animation/BoundsAnimation;Landroidx/compose/animation/SharedTransitionScope$PlaceHolderSize;ZLandroidx/compose/animation/SharedTransitionScope$SharedContentState;Landroidx/compose/animation/SharedTransitionScope$OverlayClip;FZLandroidx/compose/runtime/Composer;I)Landroidx/compose/animation/SharedElementInternalState;", "sharedElementsFor", "localLookaheadPositionOf", "Landroidx/compose/ui/geometry/Offset;", "sourceCoordinates", "relativeToSource", "includeMotionFrameOfReference", "localLookaheadPositionOf-au-aQtc", "(Landroidx/compose/ui/layout/LayoutCoordinates;Landroidx/compose/ui/layout/LayoutCoordinates;JZ)J", "renderInSharedTransitionScopeOverlay", "Landroidx/compose/ui/Modifier;", "renderInOverlay", "Lkotlin/Function2;", "Landroidx/compose/ui/unit/LayoutDirection;", "Landroidx/compose/ui/unit/Density;", "Landroidx/compose/ui/graphics/Path;", "sharedBounds", "animatedVisibilityScope", "Landroidx/compose/animation/AnimatedVisibilityScope;", "enter", "Landroidx/compose/animation/EnterTransition;", "exit", "Landroidx/compose/animation/ExitTransition;", "boundsTransform", "Landroidx/compose/animation/BoundsTransform;", "resizeMode", "Landroidx/compose/animation/SharedTransitionScope$ResizeMode;", "sharedBoundsImpl", "T", "parentTransition", "Landroidx/compose/animation/core/Transition;", "visible", "sharedBoundsWithCallerManagedVisibility", "sharedBoundsWithCallerManagedVisibility$animation_release", "state", "sharedElementWithCallerManagedVisibility", "skipToLookaheadSize", "toLookaheadCoordinates", "ShapeBasedClip", "animation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class SharedTransitionScopeImpl implements SharedTransitionScope, LookaheadScope {
    public static final int $stable = 0;
    private final LookaheadScope $$delegate_0;
    private final CoroutineScope coroutineScope;
    private LayoutCoordinates nullableLookaheadRoot;
    public LayoutCoordinates root;

    private final MutableState isTransitionActive = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(false, null, 2, null);
    private final Function0<Unit> observeAnimatingBlock = new Function0<Unit>() {
        {
            super(0);
        }

        public Object invoke() {
            m378invoke();
            return Unit.INSTANCE;
        }

        public final void m378invoke() {
            MutableScatterMap mutableScatterMap = this.this$0.sharedElements;
            Object[] objArr = mutableScatterMap.keys;
            Object[] objArr2 = mutableScatterMap.values;
            long[] jArr = mutableScatterMap.metadata;
            int length = jArr.length - 2;
            if (length < 0) {
                return;
            }
            int i = 0;
            while (true) {
                long j = jArr[i];
                if ((((~j) << 7) & j & (-9187201950435737472L)) != -9187201950435737472L) {
                    int i2 = 8 - ((~(i - length)) >>> 31);
                    for (int i3 = 0; i3 < i2; i3++) {
                        if ((255 & j) < 128) {
                            int i4 = (i << 3) + i3;
                            Object obj = objArr[i4];
                            if (((SharedElement) objArr2[i4]).isAnimating()) {
                                return;
                            }
                        }
                        j >>= 8;
                    }
                    if (i2 != 8) {
                        return;
                    }
                }
                if (i == length) {
                    return;
                } else {
                    i++;
                }
            }
        }
    };
    private final Function1<SharedTransitionScope, Unit> updateTransitionActiveness = new Function1<SharedTransitionScope, Unit>() {
        {
            super(1);
        }

        public Object invoke(Object obj) {
            invoke((SharedTransitionScope) obj);
            return Unit.INSTANCE;
        }

        public final void invoke(SharedTransitionScope sharedTransitionScope) {
            SharedTransitionScopeImpl.this.updateTransitionActiveness();
        }
    };
    private final SnapshotStateList<LayerRenderer> renderers = SnapshotStateKt.mutableStateListOf();
    private final MutableScatterMap<Object, SharedElement> sharedElements = new MutableScatterMap<>(0, 1, null);

    @Override
    public LayoutCoordinates getLookaheadScopeCoordinates(Placeable.PlacementScope placementScope) {
        return this.$$delegate_0.getLookaheadScopeCoordinates(placementScope);
    }

    @Override
    public long mo377localLookaheadPositionOfauaQtc(LayoutCoordinates layoutCoordinates, LayoutCoordinates layoutCoordinates2, long j, boolean z) {
        return this.$$delegate_0.mo377localLookaheadPositionOfauaQtc(layoutCoordinates, layoutCoordinates2, j, z);
    }

    @Override
    public EnterTransition scaleInSharedContentToBounds(ContentScale contentScale, Alignment alignment) {
        return EnterExitTransitionKt.withEffect(EnterTransition.INSTANCE.getNone(), new ContentScaleTransitionEffect(contentScale, alignment));
    }

    @Override
    public ExitTransition scaleOutSharedContentToBounds(ContentScale contentScale, Alignment alignment) {
        return EnterExitTransitionKt.withEffect(ExitTransition.INSTANCE.getNone(), new ContentScaleTransitionEffect(contentScale, alignment));
    }

    @Override
    public LayoutCoordinates toLookaheadCoordinates(LayoutCoordinates layoutCoordinates) {
        return this.$$delegate_0.toLookaheadCoordinates(layoutCoordinates);
    }

    public SharedTransitionScopeImpl(LookaheadScope lookaheadScope, CoroutineScope coroutineScope) {
        this.coroutineScope = coroutineScope;
        this.$$delegate_0 = lookaheadScope;
    }

    public final CoroutineScope getCoroutineScope() {
        return this.coroutineScope;
    }

    private void setTransitionActive(boolean z) {
        this.isTransitionActive.setValue(Boolean.valueOf(z));
    }

    @Override
    public boolean isTransitionActive() {
        return ((Boolean) this.isTransitionActive.getValue()).booleanValue();
    }

    @Override
    public Modifier skipToLookaheadSize(Modifier modifier) {
        ScaleToBoundsImpl scaleToBoundsImpl = null;
        return modifier.then(new SkipToLookaheadElement(scaleToBoundsImpl, scaleToBoundsImpl, 3, scaleToBoundsImpl));
    }

    @Override
    public Modifier renderInSharedTransitionScopeOverlay(Modifier modifier, Function0<Boolean> function0, float f, Function2<? super LayoutDirection, ? super Density, ? extends Path> function2) {
        return modifier.then(new RenderInTransitionOverlayNodeElement(this, function0, f, function2));
    }

    @Override
    public Modifier sharedElement(Modifier modifier, SharedTransitionScope.SharedContentState sharedContentState, AnimatedVisibilityScope animatedVisibilityScope, BoundsTransform boundsTransform, SharedTransitionScope.PlaceHolderSize placeHolderSize, boolean z, float f, SharedTransitionScope.OverlayClip overlayClip) {
        return sharedBoundsImpl(modifier, sharedContentState, animatedVisibilityScope.getTransition(), new Function1<EnterExitState, Boolean>() {
            public final Boolean invoke(EnterExitState enterExitState) {
                return Boolean.valueOf(enterExitState == EnterExitState.Visible);
            }
        }, boundsTransform, placeHolderSize, true, z, f, overlayClip);
    }

    @Override
    public Modifier sharedBounds(Modifier modifier, final SharedTransitionScope.SharedContentState sharedContentState, final AnimatedVisibilityScope animatedVisibilityScope, final EnterTransition enterTransition, final ExitTransition exitTransition, BoundsTransform boundsTransform, final SharedTransitionScope.ResizeMode resizeMode, SharedTransitionScope.PlaceHolderSize placeHolderSize, boolean z, float f, SharedTransitionScope.OverlayClip overlayClip) {
        return ComposedModifierKt.composed$default(sharedBoundsImpl(modifier, sharedContentState, animatedVisibilityScope.getTransition(), new Function1<EnterExitState, Boolean>() {
            public final Boolean invoke(EnterExitState enterExitState) {
                return Boolean.valueOf(enterExitState == EnterExitState.Visible);
            }
        }, boundsTransform, placeHolderSize, false, z, f, overlayClip), null, new Function3<Modifier, Composer, Integer, Modifier>() {
            {
                super(3);
            }

            public Object invoke(Object obj, Object obj2, Object obj3) {
                return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
            }

            public final Modifier invoke(Modifier modifier2, Composer composer, int i) {
                Modifier.Companion companionCreateContentScaleModifier;
                composer.startReplaceGroup(-419341573);
                ComposerKt.sourceInformation(composer, "C779@41927L35,771@41404L656:SharedTransitionScope.kt#xbi5r1");
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-419341573, i, -1, "androidx.compose.animation.SharedTransitionScopeImpl.sharedBounds.<anonymous> (SharedTransitionScope.kt:770)");
                }
                Transition<EnterExitState> transition = animatedVisibilityScope.getTransition();
                EnterTransition enterTransition2 = enterTransition;
                ExitTransition exitTransition2 = exitTransition;
                ComposerKt.sourceInformationMarkerStart(composer, -1411456741, "CC(remember):SharedTransitionScope.kt#9igjgp");
                boolean zChangedInstance = composer.changedInstance(sharedContentState);
                final SharedTransitionScope.SharedContentState sharedContentState2 = sharedContentState;
                Object objRememberedValue = composer.rememberedValue();
                if (zChangedInstance || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = (Function0) new Function0<Boolean>() {
                        {
                            super(0);
                        }

                        public final Boolean m379invoke() {
                            return Boolean.valueOf(sharedContentState2.isMatchFound());
                        }
                    };
                    composer.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composer);
                Modifier modifierCreateModifier = EnterExitTransitionKt.createModifier(transition, enterTransition2, exitTransition2, (Function0) objRememberedValue, "enter/exit for " + sharedContentState.getKey(), composer, 0, 0);
                if (resizeMode instanceof ScaleToBoundsImpl) {
                    composer.startReplaceGroup(-805247216);
                    ComposerKt.sourceInformation(composer, "784@42227L530");
                    Modifier.Companion companion = Modifier.INSTANCE;
                    ScaleToBoundsImpl scaleToBoundsImpl = (ScaleToBoundsImpl) resizeMode;
                    ComposerKt.sourceInformationMarkerStart(composer, -1411446646, "CC(remember):SharedTransitionScope.kt#9igjgp");
                    boolean zChangedInstance2 = composer.changedInstance(sharedContentState);
                    final SharedTransitionScope.SharedContentState sharedContentState3 = sharedContentState;
                    Object objRememberedValue2 = composer.rememberedValue();
                    if (zChangedInstance2 || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = (Function0) new Function0<Boolean>() {
                            {
                                super(0);
                            }

                            public final Boolean m380invoke() {
                                return Boolean.valueOf(sharedContentState3.isMatchFound());
                            }
                        };
                        composer.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composer);
                    companionCreateContentScaleModifier = SharedTransitionScopeKt.createContentScaleModifier(companion, scaleToBoundsImpl, (Function0) objRememberedValue2);
                    composer.endReplaceGroup();
                } else {
                    composer.startReplaceGroup(-804630006);
                    composer.endReplaceGroup();
                    companionCreateContentScaleModifier = Modifier.INSTANCE;
                }
                Modifier modifierThen = modifierCreateModifier.then(companionCreateContentScaleModifier);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                composer.endReplaceGroup();
                return modifierThen;
            }
        }, 1, null);
    }

    @Override
    public Modifier sharedElementWithCallerManagedVisibility(Modifier modifier, SharedTransitionScope.SharedContentState sharedContentState, final boolean z, BoundsTransform boundsTransform, SharedTransitionScope.PlaceHolderSize placeHolderSize, boolean z2, float f, SharedTransitionScope.OverlayClip overlayClip) {
        return sharedBoundsImpl(modifier, sharedContentState, null, new Function1<Unit, Boolean>() {
            {
                super(1);
            }

            public final Boolean invoke(Unit unit) {
                return Boolean.valueOf(z);
            }
        }, boundsTransform, placeHolderSize, true, z2, f, overlayClip);
    }

    public final Modifier sharedBoundsWithCallerManagedVisibility$animation_release(Modifier modifier, SharedTransitionScope.SharedContentState sharedContentState, final boolean z, BoundsTransform boundsTransform, SharedTransitionScope.PlaceHolderSize placeHolderSize, boolean z2, float f, SharedTransitionScope.OverlayClip overlayClip) {
        return sharedBoundsImpl(modifier, sharedContentState, null, new Function1<Unit, Boolean>() {
            {
                super(1);
            }

            public final Boolean invoke(Unit unit) {
                return Boolean.valueOf(z);
            }
        }, boundsTransform, placeHolderSize, false, z2, f, overlayClip);
    }

    @Override
    public SharedTransitionScope.OverlayClip OverlayClip(Shape clipShape) {
        return new ShapeBasedClip(clipShape);
    }

    @Override
    public SharedTransitionScope.SharedContentState rememberSharedContentState(Object obj, Composer composer, int i) {
        composer.startReplaceGroup(799702514);
        ComposerKt.sourceInformation(composer, "C(rememberSharedContentState)912@49465L53:SharedTransitionScope.kt#xbi5r1");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(799702514, i, -1, "androidx.compose.animation.SharedTransitionScopeImpl.rememberSharedContentState (SharedTransitionScope.kt:912)");
        }
        ComposerKt.sourceInformationMarkerStart(composer, 935469886, "CC(remember):SharedTransitionScope.kt#9igjgp");
        boolean zChanged = composer.changed(obj);
        Object objRememberedValue = composer.rememberedValue();
        if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
            objRememberedValue = new SharedTransitionScope.SharedContentState(obj);
            composer.updateRememberedValue(objRememberedValue);
        }
        SharedTransitionScope.SharedContentState sharedContentState = (SharedTransitionScope.SharedContentState) objRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceGroup();
        return sharedContentState;
    }

    public final void updateTransitionActiveness() {
        boolean z;
        MutableScatterMap<Object, SharedElement> mutableScatterMap = this.sharedElements;
        Object[] objArr = mutableScatterMap.keys;
        Object[] objArr2 = mutableScatterMap.values;
        long[] jArr = mutableScatterMap.metadata;
        int length = jArr.length - 2;
        if (length < 0) {
            z = false;
            break;
        }
        int i = 0;
        loop0: while (true) {
            long j = jArr[i];
            if ((((~j) << 7) & j & (-9187201950435737472L)) != -9187201950435737472L) {
                int i2 = 8 - ((~(i - length)) >>> 31);
                for (int i3 = 0; i3 < i2; i3++) {
                    if ((j & 255) < 128) {
                        int i4 = (i << 3) + i3;
                        Object obj = objArr[i4];
                        if (((SharedElement) objArr2[i4]).isAnimating()) {
                            z = true;
                            break loop0;
                        }
                    }
                    j >>= 8;
                }
                if (i2 == 8) {
                    if (i == length) {
                        i++;
                    }
                }
                z = false;
                break;
            }
            if (i == length) {
                z = false;
                break;
            }
            i++;
        }
        if (z != isTransitionActive()) {
            setTransitionActive(z);
            if (!z) {
                MutableScatterMap<Object, SharedElement> mutableScatterMap2 = this.sharedElements;
                Object[] objArr3 = mutableScatterMap2.keys;
                Object[] objArr4 = mutableScatterMap2.values;
                long[] jArr2 = mutableScatterMap2.metadata;
                int length2 = jArr2.length - 2;
                if (length2 >= 0) {
                    int i5 = 0;
                    while (true) {
                        long j2 = jArr2[i5];
                        if ((((~j2) << 7) & j2 & (-9187201950435737472L)) == -9187201950435737472L) {
                            if (i5 != length2) {
                                break;
                                break;
                            }
                            i5++;
                        } else {
                            int i6 = 8 - ((~(i5 - length2)) >>> 31);
                            for (int i7 = 0; i7 < i6; i7++) {
                                if ((j2 & 255) < 128) {
                                    int i8 = (i5 << 3) + i7;
                                    Object obj2 = objArr3[i8];
                                    ((SharedElement) objArr4[i8]).onSharedTransitionFinished();
                                }
                                j2 >>= 8;
                            }
                            if (i6 != 8) {
                                break;
                            } else if (i5 != length2) {
                                break;
                            } else {
                                i5++;
                            }
                        }
                    }
                }
            }
        }
        MutableScatterMap<Object, SharedElement> mutableScatterMap3 = this.sharedElements;
        Object[] objArr5 = mutableScatterMap3.keys;
        Object[] objArr6 = mutableScatterMap3.values;
        long[] jArr3 = mutableScatterMap3.metadata;
        int length3 = jArr3.length - 2;
        if (length3 >= 0) {
            int i9 = 0;
            while (true) {
                long j3 = jArr3[i9];
                if ((((~j3) << 7) & j3 & (-9187201950435737472L)) != -9187201950435737472L) {
                    int i10 = 8 - ((~(i9 - length3)) >>> 31);
                    for (int i11 = 0; i11 < i10; i11++) {
                        if ((j3 & 255) < 128) {
                            int i12 = (i9 << 3) + i11;
                            Object obj3 = objArr5[i12];
                            ((SharedElement) objArr6[i12]).updateMatch();
                        }
                        j3 >>= 8;
                    }
                    if (i10 != 8) {
                        break;
                    }
                }
                if (i9 == length3) {
                    break;
                } else {
                    i9++;
                }
            }
        }
        SharedTransitionScopeKt.getSharedTransitionObserver().observeReads(this, this.updateTransitionActiveness, this.observeAnimatingBlock);
    }

    public final <T> Modifier sharedBoundsImpl(Modifier modifier, final SharedTransitionScope.SharedContentState sharedContentState, final Transition<T> transition, final Function1<? super T, Boolean> function1, final BoundsTransform boundsTransform, final SharedTransitionScope.PlaceHolderSize placeHolderSize, final boolean z, final boolean z2, final float f, final SharedTransitionScope.OverlayClip overlayClip) {
        return ComposedModifierKt.composed$default(modifier, null, new Function3<Modifier, Composer, Integer, Modifier>() {
            {
                super(3);
            }

            public Object invoke(Object obj, Object obj2, Object obj3) {
                return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
            }

            public final Modifier invoke(Modifier modifier2, Composer composer, int i) {
                Transition transitionRememberTransition;
                composer.startReplaceGroup(-1843478929);
                ComposerKt.sourceInformation(composer, "C:SharedTransitionScope.kt#xbi5r1");
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1843478929, i, -1, "androidx.compose.animation.SharedTransitionScopeImpl.sharedBoundsImpl.<anonymous> (SharedTransitionScope.kt:968)");
                }
                Object key = sharedContentState.getKey();
                composer.startMovableGroup(-359675295, key);
                ComposerKt.sourceInformation(composer, "970@51556L35,1006@53390L522");
                ComposerKt.sourceInformationMarkerStart(composer, -359676293, "CC(remember):SharedTransitionScope.kt#9igjgp");
                SharedTransitionScopeImpl sharedTransitionScopeImpl = this;
                Object objRememberedValue = composer.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = sharedTransitionScopeImpl.sharedElementsFor(key);
                    composer.updateRememberedValue(objRememberedValue);
                }
                SharedElement sharedElement = (SharedElement) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composer);
                composer.startMovableGroup(-359672306, transition);
                ComposerKt.sourceInformation(composer, "*997@53029L278");
                boolean z3 = false;
                if (transition != null) {
                    composer.startReplaceGroup(1735101820);
                    ComposerKt.sourceInformation(composer, "974@51759L53");
                    Transition<T> transition2 = transition;
                    String string = key.toString();
                    Function1<T, Boolean> function2 = function1;
                    ComposerKt.sourceInformationMarkerStart(composer, 1215497572, "CC(createChildTransition)1813@74138L36,1814@74198L74,1815@74295L39,1816@74346L63:Transition.kt#pdpnli");
                    ComposerKt.sourceInformationMarkerStart(composer, 272027253, "CC(remember):Transition.kt#9igjgp");
                    boolean zChanged = composer.changed(transition2);
                    Object objRememberedValue2 = composer.rememberedValue();
                    if (zChanged || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = transition2.getCurrentState();
                        composer.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composer);
                    if (transition2.isSeeking()) {
                        objRememberedValue2 = transition2.getCurrentState();
                    }
                    composer.startReplaceGroup(1329676753);
                    ComposerKt.sourceInformation(composer, "C:SharedTransitionScope.kt#xbi5r1");
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1329676753, 0, -1, "androidx.compose.animation.SharedTransitionScopeImpl.sharedBoundsImpl.<anonymous>.<anonymous>.<anonymous>.<anonymous> (SharedTransitionScope.kt:974)");
                    }
                    Boolean bool = (Boolean) function2.invoke(objRememberedValue2);
                    bool.booleanValue();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    composer.endReplaceGroup();
                    Object targetState = transition2.getTargetState();
                    composer.startReplaceGroup(1329676753);
                    ComposerKt.sourceInformation(composer, "C:SharedTransitionScope.kt#xbi5r1");
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1329676753, 0, -1, "androidx.compose.animation.SharedTransitionScopeImpl.sharedBoundsImpl.<anonymous>.<anonymous>.<anonymous>.<anonymous> (SharedTransitionScope.kt:974)");
                    }
                    Boolean bool2 = (Boolean) function2.invoke(targetState);
                    bool2.booleanValue();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    composer.endReplaceGroup();
                    transitionRememberTransition = androidx.compose.animation.core.TransitionKt.createChildTransitionInternal(transition2, bool, bool2, string, composer, 0);
                    ComposerKt.sourceInformationMarkerEnd(composer);
                    composer.endReplaceGroup();
                } else {
                    composer.startReplaceGroup(1735245009);
                    ComposerKt.sourceInformation(composer, "*979@52034L707,992@52800L35");
                    Function1<T, Boolean> function3 = function1;
                    Intrinsics.checkNotNull(function3, "null cannot be cast to non-null type kotlin.Function1<kotlin.Unit, kotlin.Boolean>");
                    Boolean bool3 = (Boolean) ((Function1) TypeIntrinsics.beforeCheckcastToFunctionOfArity(function3, 1)).invoke(Unit.INSTANCE);
                    boolean zBooleanValue = bool3.booleanValue();
                    ComposerKt.sourceInformationMarkerStart(composer, -359660325, "CC(remember):SharedTransitionScope.kt#9igjgp");
                    Object objRememberedValue3 = composer.rememberedValue();
                    if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        if (sharedElement.getCurrentBounds() == null) {
                            z3 = zBooleanValue;
                        } else if (!zBooleanValue) {
                            z3 = true;
                        }
                        objRememberedValue3 = new MutableTransitionState(Boolean.valueOf(z3));
                        composer.updateRememberedValue(objRememberedValue3);
                    }
                    MutableTransitionState mutableTransitionState = (MutableTransitionState) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composer);
                    mutableTransitionState.setTargetState$animation_core_release(bool3);
                    transitionRememberTransition = androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, null, composer, MutableTransitionState.$stable, 2);
                    composer.endReplaceGroup();
                }
                Transition transition3 = transitionRememberTransition;
                composer.startMovableGroup(-359633642, Boolean.valueOf(this.isTransitionActive()));
                ComposerKt.sourceInformation(composer, "995@52949L45");
                Transition<Boolean>.DeferredAnimation<Rect, AnimationVector4D> deferredAnimationCreateDeferredAnimation = androidx.compose.animation.core.TransitionKt.createDeferredAnimation(transition3, VectorConvertersKt.getVectorConverter(Rect.INSTANCE), null, composer, 0, 2);
                composer.endMovableGroup();
                ComposerKt.sourceInformationMarkerStart(composer, -359628914, "CC(remember):SharedTransitionScope.kt#9igjgp");
                boolean zChanged2 = composer.changed(transition3);
                SharedTransitionScopeImpl sharedTransitionScopeImpl2 = this;
                BoundsTransform boundsTransform2 = boundsTransform;
                Object objRememberedValue4 = composer.rememberedValue();
                if (zChanged2 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue4 = new BoundsAnimation(sharedTransitionScopeImpl2, transition3, deferredAnimationCreateDeferredAnimation, boundsTransform2);
                    composer.updateRememberedValue(objRememberedValue4);
                }
                BoundsAnimation boundsAnimation = (BoundsAnimation) objRememberedValue4;
                ComposerKt.sourceInformationMarkerEnd(composer);
                boundsAnimation.updateAnimation(deferredAnimationCreateDeferredAnimation, boundsTransform);
                composer.endMovableGroup();
                SharedElementInternalState sharedElementInternalStateRememberSharedElementState = this.rememberSharedElementState(sharedElement, boundsAnimation, placeHolderSize, z, sharedContentState, overlayClip, f, z2, composer, 0);
                composer.endMovableGroup();
                Modifier modifierThen = modifier2.then(new SharedBoundsNodeElement(sharedElementInternalStateRememberSharedElementState));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                composer.endReplaceGroup();
                return modifierThen;
            }
        }, 1, null);
    }

    public final androidx.compose.animation.SharedElementInternalState rememberSharedElementState(

    public final LayoutCoordinates getRoot$animation_release() {
        LayoutCoordinates layoutCoordinates = this.root;
        if (layoutCoordinates != null) {
            return layoutCoordinates;
        }
        Intrinsics.throwUninitializedPropertyAccessException("root");
        return null;
    }

    public final void setRoot$animation_release(LayoutCoordinates layoutCoordinates) {
        this.root = layoutCoordinates;
    }

    public final LayoutCoordinates getLookaheadRoot$animation_release() {
        LayoutCoordinates layoutCoordinates = this.nullableLookaheadRoot;
        if (layoutCoordinates != null) {
            return layoutCoordinates;
        }
        throw new IllegalArgumentException("Error: Uninitialized LayoutCoordinates. Please make sure when using the SharedTransitionScope composable function, the modifier passed to the child content is being used, or use SharedTransitionLayout instead.".toString());
    }

    public final LayoutCoordinates getNullableLookaheadRoot() {
        return this.nullableLookaheadRoot;
    }

    public final void setNullableLookaheadRoot$animation_release(LayoutCoordinates layoutCoordinates) {
        this.nullableLookaheadRoot = layoutCoordinates;
    }

    public final SharedElement sharedElementsFor(Object key) {
        SharedElement sharedElement = this.sharedElements.get(key);
        if (sharedElement != null) {
            return sharedElement;
        }
        SharedElement sharedElement2 = new SharedElement(key, this);
        this.sharedElements.set(key, sharedElement2);
        return sharedElement2;
    }

    public final void drawInOverlay$animation_release(ContentDrawScope scope) {
        SnapshotStateList<LayerRenderer> snapshotStateList = this.renderers;
        if (snapshotStateList.size() > 1) {
            CollectionsKt.sortWith(snapshotStateList, new Comparator() {
                @Override
                public final int compare(T t, T t2) {
                    LayerRenderer layerRenderer = (LayerRenderer) t;
                    LayerRenderer layerRenderer2 = (LayerRenderer) t2;
                    return ComparisonsKt.compareValues(Float.valueOf((layerRenderer.getZIndex() == 0.0f && (layerRenderer instanceof SharedElementInternalState) && ((SharedElementInternalState) layerRenderer).getParentState() == null) ? -1.0f : layerRenderer.getZIndex()), Float.valueOf((layerRenderer2.getZIndex() == 0.0f && (layerRenderer2 instanceof SharedElementInternalState) && ((SharedElementInternalState) layerRenderer2).getParentState() == null) ? -1.0f : layerRenderer2.getZIndex()));
                }
            });
        }
        SnapshotStateList<LayerRenderer> snapshotStateList2 = this.renderers;
        int size = snapshotStateList2.size();
        for (int i = 0; i < size; i++) {
            snapshotStateList2.get(i).drawInOverlay(scope);
        }
    }

    public final void onStateRemoved$animation_release(SharedElementInternalState sharedElementState) {
        SharedElement sharedElement = sharedElementState.getSharedElement();
        sharedElement.removeState(sharedElementState);
        this.updateTransitionActiveness.invoke(this);
        SharedTransitionScopeKt.getSharedTransitionObserver().observeReads(sharedElement.getScope(), this.updateTransitionActiveness, this.observeAnimatingBlock);
        this.renderers.remove(sharedElementState);
        if (sharedElement.getStates().isEmpty()) {
            BuildersKt.launch$default(sharedElement.getScope().coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new SharedTransitionScopeImpl$onStateRemoved$1$1(sharedElement, null), 3, (Object) null);
        }
    }

    public final void onStateAdded$animation_release(SharedElementInternalState sharedElementState) {
        SharedElement sharedElement = sharedElementState.getSharedElement();
        sharedElement.addState(sharedElementState);
        this.updateTransitionActiveness.invoke(this);
        SharedTransitionScopeKt.getSharedTransitionObserver().observeReads(sharedElement.getScope(), this.updateTransitionActiveness, this.observeAnimatingBlock);
        Iterator<LayerRenderer> it = this.renderers.iterator();
        int i = 0;
        while (true) {
            if (!it.hasNext()) {
                i = -1;
                break;
            }
            LayerRenderer next = it.next();
            SharedElementInternalState sharedElementInternalState = next instanceof SharedElementInternalState ? (SharedElementInternalState) next : null;
            if (Intrinsics.areEqual(sharedElementInternalState != null ? sharedElementInternalState.getSharedElement() : null, sharedElementState.getSharedElement())) {
                break;
            } else {
                i++;
            }
        }
        if (i == this.renderers.size() - 1 || i == -1) {
            this.renderers.add(sharedElementState);
        } else {
            this.renderers.add(i + 1, sharedElementState);
        }
    }

    public final void onLayerRendererCreated$animation_release(LayerRenderer renderer) {
        this.renderers.add(renderer);
    }

    public final void onLayerRendererRemoved$animation_release(LayerRenderer renderer) {
        this.renderers.remove(renderer);
    }

    @Metadata(d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0002\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J(\u0010\t\u001a\u00020\b2\u0006\u0010\n\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u0011H\u0016R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006R\u000e\u0010\u0007\u001a\u00020\bX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0012"}, d2 = {"Landroidx/compose/animation/SharedTransitionScopeImpl$ShapeBasedClip;", "Landroidx/compose/animation/SharedTransitionScope$OverlayClip;", "clipShape", "Landroidx/compose/ui/graphics/Shape;", "(Landroidx/compose/ui/graphics/Shape;)V", "getClipShape", "()Landroidx/compose/ui/graphics/Shape;", "path", "Landroidx/compose/ui/graphics/Path;", "getClipPath", "state", "Landroidx/compose/animation/SharedTransitionScope$SharedContentState;", "bounds", "Landroidx/compose/ui/geometry/Rect;", "layoutDirection", "Landroidx/compose/ui/unit/LayoutDirection;", "density", "Landroidx/compose/ui/unit/Density;", "animation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    private static final class ShapeBasedClip implements SharedTransitionScope.OverlayClip {
        private final Shape clipShape;
        private final Path path = AndroidPath_androidKt.Path();

        public ShapeBasedClip(Shape shape) {
            this.clipShape = shape;
        }

        public final Shape getClipShape() {
            return this.clipShape;
        }

        @Override
        public Path getClipPath(SharedTransitionScope.SharedContentState state, Rect bounds, LayoutDirection layoutDirection, Density density) {
            this.path.reset();
            OutlineKt.addOutline(this.path, this.clipShape.mo572createOutlinePq9zytI(bounds.m4379getSizeNHjbRc(), layoutDirection, density));
            this.path.mo4483translatek4lQ0M(bounds.m4381getTopLeftF1C5BW0());
            return this.path;
        }
    }
}
