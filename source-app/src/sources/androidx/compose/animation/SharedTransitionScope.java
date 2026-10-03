package androidx.compose.animation;

import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.Path;
import androidx.compose.p002ui.graphics.Shape;
import androidx.compose.p002ui.layout.ContentScale;
import androidx.compose.p002ui.layout.LookaheadScope;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.LayoutDirection;
import kotlin.Deprecated;
import kotlin.Metadata;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function2;

@Metadata(d1 = {"\u0000\u0086\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\n\bg\u0018\u00002\u00020\u0001:\u0004\u0005345J\u0010\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bH&J\u0015\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\fH'¢\u0006\u0002\u0010\rJ\u001c\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\b\b\u0002\u0010\u0012\u001a\u00020\u0013H\u0017J\u001c\u0010\u0014\u001a\u00020\u00152\b\b\u0002\u0010\u0010\u001a\u00020\u00112\b\b\u0002\u0010\u0012\u001a\u00020\u0013H\u0017JD\u0010\u0016\u001a\u00020\u0017*\u00020\u00172\u000e\b\u0002\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\u00030\u00192\b\b\u0002\u0010\u001a\u001a\u00020\u001b2\u001c\b\u0002\u0010\u001c\u001a\u0016\u0012\u0004\u0012\u00020\u001e\u0012\u0004\u0012\u00020\u001f\u0012\u0006\u0012\u0004\u0018\u00010 0\u001dH&Jl\u0010!\u001a\u00020\u0017*\u00020\u00172\u0006\u0010\"\u001a\u00020\n2\u0006\u0010#\u001a\u00020$2\b\b\u0002\u0010%\u001a\u00020\u000f2\b\b\u0002\u0010&\u001a\u00020\u00152\b\b\u0002\u0010'\u001a\u00020(2\b\b\u0002\u0010)\u001a\u00020*2\b\b\u0002\u0010+\u001a\u00020,2\b\b\u0002\u0010-\u001a\u00020\u00032\b\b\u0002\u0010\u001a\u001a\u00020\u001b2\b\b\u0002\u0010\u001c\u001a\u00020\u0006H&JN\u0010.\u001a\u00020\u0017*\u00020\u00172\u0006\u0010/\u001a\u00020\n2\u0006\u0010#\u001a\u00020$2\b\b\u0002\u0010'\u001a\u00020(2\b\b\u0002\u0010+\u001a\u00020,2\b\b\u0002\u0010-\u001a\u00020\u00032\b\b\u0002\u0010\u001a\u001a\u00020\u001b2\b\b\u0002\u0010\u001c\u001a\u00020\u0006H&JN\u00100\u001a\u00020\u0017*\u00020\u00172\u0006\u0010\"\u001a\u00020\n2\u0006\u00101\u001a\u00020\u00032\b\b\u0002\u0010'\u001a\u00020(2\b\b\u0002\u0010+\u001a\u00020,2\b\b\u0002\u0010-\u001a\u00020\u00032\b\b\u0002\u0010\u001a\u001a\u00020\u001b2\b\b\u0002\u0010\u001c\u001a\u00020\u0006H&J\f\u00102\u001a\u00020\u0017*\u00020\u0017H&R\u0012\u0010\u0002\u001a\u00020\u0003X¦\u0004¢\u0006\u0006\u001a\u0004\b\u0002\u0010\u0004ø\u0001\u0000\u0082\u0002\u0006\n\u0004\b!0\u0001¨\u00066À\u0006\u0001"}, d2 = {"Landroidx/compose/animation/SharedTransitionScope;", "Landroidx/compose/ui/layout/LookaheadScope;", "isTransitionActive", "", "()Z", "OverlayClip", "Landroidx/compose/animation/SharedTransitionScope$OverlayClip;", "clipShape", "Landroidx/compose/ui/graphics/Shape;", "rememberSharedContentState", "Landroidx/compose/animation/SharedTransitionScope$SharedContentState;", "key", "", "(Ljava/lang/Object;Landroidx/compose/runtime/Composer;I)Landroidx/compose/animation/SharedTransitionScope$SharedContentState;", "scaleInSharedContentToBounds", "Landroidx/compose/animation/EnterTransition;", "contentScale", "Landroidx/compose/ui/layout/ContentScale;", "alignment", "Landroidx/compose/ui/Alignment;", "scaleOutSharedContentToBounds", "Landroidx/compose/animation/ExitTransition;", "renderInSharedTransitionScopeOverlay", "Landroidx/compose/ui/Modifier;", "renderInOverlay", "Lkotlin/Function0;", "zIndexInOverlay", "", "clipInOverlayDuringTransition", "Lkotlin/Function2;", "Landroidx/compose/ui/unit/LayoutDirection;", "Landroidx/compose/ui/unit/Density;", "Landroidx/compose/ui/graphics/Path;", "sharedBounds", "sharedContentState", "animatedVisibilityScope", "Landroidx/compose/animation/AnimatedVisibilityScope;", "enter", "exit", "boundsTransform", "Landroidx/compose/animation/BoundsTransform;", "resizeMode", "Landroidx/compose/animation/SharedTransitionScope$ResizeMode;", "placeHolderSize", "Landroidx/compose/animation/SharedTransitionScope$PlaceHolderSize;", "renderInOverlayDuringTransition", "sharedElement", "state", "sharedElementWithCallerManagedVisibility", "visible", "skipToLookaheadSize", "PlaceHolderSize", "ResizeMode", "SharedContentState", "animation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public interface SharedTransitionScope extends LookaheadScope {

    @Metadata(d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\bf\u0018\u00002\u00020\u0001J*\u0010\u0002\u001a\u0004\u0018\u00010\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u000bH&ø\u0001\u0000\u0082\u0002\u0006\n\u0004\b!0\u0001¨\u0006\fÀ\u0006\u0001"}, d2 = {"Landroidx/compose/animation/SharedTransitionScope$OverlayClip;", "", "getClipPath", "Landroidx/compose/ui/graphics/Path;", "state", "Landroidx/compose/animation/SharedTransitionScope$SharedContentState;", "bounds", "Landroidx/compose/ui/geometry/Rect;", "layoutDirection", "Landroidx/compose/ui/unit/LayoutDirection;", "density", "Landroidx/compose/ui/unit/Density;", "animation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public interface OverlayClip {
        Path getClipPath(SharedContentState state, Rect bounds, LayoutDirection layoutDirection, Density density);
    }

    OverlayClip OverlayClip(Shape clipShape);

    boolean isTransitionActive();

    SharedContentState rememberSharedContentState(Object obj, Composer composer, int i);

    Modifier renderInSharedTransitionScopeOverlay(Modifier modifier, Function0<Boolean> function0, float f, Function2<? super LayoutDirection, ? super Density, ? extends Path> function2);

    @Deprecated(message = "This EnterTransition has been deprecated. Please replace the usage with resizeMode = ScaleToBounds(...) in sharedBounds to achieve the scale-to-bounds effect.")
    EnterTransition scaleInSharedContentToBounds(ContentScale contentScale, Alignment alignment);

    @Deprecated(message = "This ExitTransition has been deprecated.  Please replace the usage with resizeMode = ScaleToBounds(...) in sharedBounds to achieve the scale-to-bounds effect.")
    ExitTransition scaleOutSharedContentToBounds(ContentScale contentScale, Alignment alignment);

    Modifier sharedBounds(Modifier modifier, SharedContentState sharedContentState, AnimatedVisibilityScope animatedVisibilityScope, EnterTransition enterTransition, ExitTransition exitTransition, BoundsTransform boundsTransform, ResizeMode resizeMode, PlaceHolderSize placeHolderSize, boolean z, float f, OverlayClip overlayClip);

    Modifier sharedElement(Modifier modifier, SharedContentState sharedContentState, AnimatedVisibilityScope animatedVisibilityScope, BoundsTransform boundsTransform, PlaceHolderSize placeHolderSize, boolean z, float f, OverlayClip overlayClip);

    Modifier sharedElementWithCallerManagedVisibility(Modifier modifier, SharedContentState sharedContentState, boolean z, BoundsTransform boundsTransform, PlaceHolderSize placeHolderSize, boolean z2, float f, OverlayClip overlayClip);

    Modifier skipToLookaheadSize(Modifier modifier);

    @Metadata(d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\bæ\u0080\u0001\u0018\u0000 \b2\u00020\u0001:\u0001\bJ\"\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00032\u0006\u0010\u0005\u001a\u00020\u0003H&ø\u0001\u0000¢\u0006\u0004\b\u0006\u0010\u0007ø\u0001\u0001\u0082\u0002\r\n\u0005\b¡\u001e0\u0001\n\u0004\b!0\u0001¨\u0006\tÀ\u0006\u0001"}, d2 = {"Landroidx/compose/animation/SharedTransitionScope$PlaceHolderSize;", "", "calculateSize", "Landroidx/compose/ui/unit/IntSize;", "contentSize", "animatedSize", "calculateSize-JyjRU_E", "(JJ)J", "Companion", "animation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public interface PlaceHolderSize {

        public static final Companion INSTANCE = Companion.$$INSTANCE;

        long mo375calculateSizeJyjRU_E(long contentSize, long animatedSize);

        @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0011\u0010\u0003\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006R\u0011\u0010\u0007\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\u0006¨\u0006\t"}, d2 = {"Landroidx/compose/animation/SharedTransitionScope$PlaceHolderSize$Companion;", "", "()V", "animatedSize", "Landroidx/compose/animation/SharedTransitionScope$PlaceHolderSize;", "getAnimatedSize", "()Landroidx/compose/animation/SharedTransitionScope$PlaceHolderSize;", "contentSize", "getContentSize", "animation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
        public static final class Companion {
            static final Companion $$INSTANCE = new Companion();
            private static final PlaceHolderSize animatedSize = new PlaceHolderSize() {
                @Override
                public final long mo375calculateSizeJyjRU_E(long j, long j2) {
                    return j2;
                }
            };
            private static final PlaceHolderSize contentSize = new PlaceHolderSize() {
                @Override
                public final long mo375calculateSizeJyjRU_E(long j, long j2) {
                    return j;
                }
            };

            private Companion() {
            }

            public final PlaceHolderSize getAnimatedSize() {
                return animatedSize;
            }

            public final PlaceHolderSize getContentSize() {
                return contentSize;
            }
        }
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\bv\u0018\u0000 \u00022\u00020\u0001:\u0001\u0002\u0082\u0001\u0002\u0003\u0004ø\u0001\u0000\u0082\u0002\u0006\n\u0004\b!0\u0001¨\u0006\u0005À\u0006\u0001"}, d2 = {"Landroidx/compose/animation/SharedTransitionScope$ResizeMode;", "", "Companion", "Landroidx/compose/animation/RemeasureImpl;", "Landroidx/compose/animation/ScaleToBoundsImpl;", "animation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public interface ResizeMode {

        public static final Companion INSTANCE = Companion.$$INSTANCE;

        @Metadata(d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u001a\u0010\u0007\u001a\u00020\u00042\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\u000bR\u0011\u0010\u0003\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\f"}, d2 = {"Landroidx/compose/animation/SharedTransitionScope$ResizeMode$Companion;", "", "()V", "RemeasureToBounds", "Landroidx/compose/animation/SharedTransitionScope$ResizeMode;", "getRemeasureToBounds", "()Landroidx/compose/animation/SharedTransitionScope$ResizeMode;", "ScaleToBounds", "contentScale", "Landroidx/compose/ui/layout/ContentScale;", "alignment", "Landroidx/compose/ui/Alignment;", "animation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
        public static final class Companion {
            static final Companion $$INSTANCE = new Companion();
            private static final ResizeMode RemeasureToBounds = RemeasureImpl.INSTANCE;

            private Companion() {
            }

            public final ResizeMode getRemeasureToBounds() {
                return RemeasureToBounds;
            }

            public static ResizeMode ScaleToBounds$default(Companion companion, ContentScale contentScale, Alignment alignment, int i, Object obj) {
                if ((i & 1) != 0) {
                    contentScale = ContentScale.INSTANCE.getFillWidth();
                }
                if ((i & 2) != 0) {
                    alignment = Alignment.INSTANCE.getCenter();
                }
                return companion.ScaleToBounds(contentScale, alignment);
            }

            public final ResizeMode ScaleToBounds(ContentScale contentScale, Alignment alignment) {
                return SharedTransitionScopeKt.ScaleToBoundsCached(contentScale, alignment);
            }
        }
    }

    public final class CC {
        public static EnterTransition scaleInSharedContentToBounds$default(SharedTransitionScope sharedTransitionScope, ContentScale contentScale, Alignment alignment, int i, Object obj) {
            if (obj != null) {
                throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: scaleInSharedContentToBounds");
            }
            if ((i & 1) != 0) {
                contentScale = ContentScale.INSTANCE.getFit();
            }
            if ((i & 2) != 0) {
                alignment = Alignment.INSTANCE.getCenter();
            }
            return sharedTransitionScope.scaleInSharedContentToBounds(contentScale, alignment);
        }

        public static ExitTransition scaleOutSharedContentToBounds$default(SharedTransitionScope sharedTransitionScope, ContentScale contentScale, Alignment alignment, int i, Object obj) {
            if (obj != null) {
                throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: scaleOutSharedContentToBounds");
            }
            if ((i & 1) != 0) {
                contentScale = ContentScale.INSTANCE.getFit();
            }
            if ((i & 2) != 0) {
                alignment = Alignment.INSTANCE.getCenter();
            }
            return sharedTransitionScope.scaleOutSharedContentToBounds(contentScale, alignment);
        }

        public static Modifier renderInSharedTransitionScopeOverlay$default(final SharedTransitionScope sharedTransitionScope, Modifier modifier, Function0 function0, float f, Function2 function2, int i, Object obj) {
            if (obj != null) {
                throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: renderInSharedTransitionScopeOverlay");
            }
            if ((i & 1) != 0) {
                function0 = new Function0<Boolean>() {
                    {
                        super(0);
                    }

                    public final Boolean m376invoke() {
                        return Boolean.valueOf(SharedTransitionScope.this.isTransitionActive());
                    }
                };
            }
            if ((i & 2) != 0) {
                f = 0.0f;
            }
            if ((i & 4) != 0) {
                function2 = SharedTransitionScopeKt.DefaultClipInOverlayDuringTransition;
            }
            return sharedTransitionScope.renderInSharedTransitionScopeOverlay(modifier, function0, f, function2);
        }

        public static Modifier sharedElement$default(SharedTransitionScope sharedTransitionScope, Modifier modifier, SharedContentState sharedContentState, AnimatedVisibilityScope animatedVisibilityScope, BoundsTransform boundsTransform, PlaceHolderSize placeHolderSize, boolean z, float f, OverlayClip overlayClip, int i, Object obj) {
            if (obj == null) {
                return sharedTransitionScope.sharedElement(modifier, sharedContentState, animatedVisibilityScope, (i & 4) != 0 ? SharedTransitionScopeKt.DefaultBoundsTransform : boundsTransform, (i & 8) != 0 ? PlaceHolderSize.INSTANCE.getContentSize() : placeHolderSize, (i & 16) != 0 ? true : z, (i & 32) != 0 ? 0.0f : f, (i & 64) != 0 ? SharedTransitionScopeKt.ParentClip : overlayClip);
            }
            throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: sharedElement");
        }

        public static Modifier sharedBounds$default(SharedTransitionScope sharedTransitionScope, Modifier modifier, SharedContentState sharedContentState, AnimatedVisibilityScope animatedVisibilityScope, EnterTransition enterTransition, ExitTransition exitTransition, BoundsTransform boundsTransform, ResizeMode resizeMode, PlaceHolderSize placeHolderSize, boolean z, float f, OverlayClip overlayClip, int i, Object obj) {
            if (obj == null) {
                return sharedTransitionScope.sharedBounds(modifier, sharedContentState, animatedVisibilityScope, (i & 4) != 0 ? EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null) : enterTransition, (i & 8) != 0 ? EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null) : exitTransition, (i & 16) != 0 ? SharedTransitionScopeKt.DefaultBoundsTransform : boundsTransform, (i & 32) != 0 ? ResizeMode.INSTANCE.ScaleToBounds(ContentScale.INSTANCE.getFillWidth(), Alignment.INSTANCE.getCenter()) : resizeMode, (i & 64) != 0 ? PlaceHolderSize.INSTANCE.getContentSize() : placeHolderSize, (i & Fields.SpotShadowColor) != 0 ? true : z, (i & Fields.RotationX) != 0 ? 0.0f : f, (i & Fields.RotationY) != 0 ? SharedTransitionScopeKt.ParentClip : overlayClip);
            }
            throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: sharedBounds");
        }

        public static Modifier sharedElementWithCallerManagedVisibility$default(SharedTransitionScope sharedTransitionScope, Modifier modifier, SharedContentState sharedContentState, boolean z, BoundsTransform boundsTransform, PlaceHolderSize placeHolderSize, boolean z2, float f, OverlayClip overlayClip, int i, Object obj) {
            if (obj == null) {
                return sharedTransitionScope.sharedElementWithCallerManagedVisibility(modifier, sharedContentState, z, (i & 4) != 0 ? SharedTransitionScopeKt.DefaultBoundsTransform : boundsTransform, (i & 8) != 0 ? PlaceHolderSize.INSTANCE.getContentSize() : placeHolderSize, (i & 16) != 0 ? true : z2, (i & 32) != 0 ? 0.0f : f, (i & 64) != 0 ? SharedTransitionScopeKt.ParentClip : overlayClip);
            }
            throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: sharedElementWithCallerManagedVisibility");
        }
    }

    @Metadata(d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0010\u000b\n\u0002\b\t\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0000\u0012\u0006\u0010\u0002\u001a\u00020\u0001¢\u0006\u0002\u0010\u0003R\u0013\u0010\u0004\u001a\u0004\u0018\u00010\u00058F¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007R/\u0010\n\u001a\u0004\u0018\u00010\t2\b\u0010\b\u001a\u0004\u0018\u00010\t8@@@X\u0080\u008e\u0002¢\u0006\u0012\n\u0004\b\u000f\u0010\u0010\u001a\u0004\b\u000b\u0010\f\"\u0004\b\r\u0010\u000eR\u0011\u0010\u0011\u001a\u00020\u00128F¢\u0006\u0006\u001a\u0004\b\u0011\u0010\u0013R\u0011\u0010\u0002\u001a\u00020\u0001¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0015R\u0014\u0010\u0016\u001a\u00020\t8BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\u0017\u0010\fR\u0013\u0010\u0018\u001a\u0004\u0018\u00010\u00008F¢\u0006\u0006\u001a\u0004\b\u0019\u0010\u001a¨\u0006\u001b"}, d2 = {"Landroidx/compose/animation/SharedTransitionScope$SharedContentState;", "", "key", "(Ljava/lang/Object;)V", "clipPathInOverlay", "Landroidx/compose/ui/graphics/Path;", "getClipPathInOverlay", "()Landroidx/compose/ui/graphics/Path;", "<set-?>", "Landroidx/compose/animation/SharedElementInternalState;", "internalState", "getInternalState$animation_release", "()Landroidx/compose/animation/SharedElementInternalState;", "setInternalState$animation_release", "(Landroidx/compose/animation/SharedElementInternalState;)V", "internalState$delegate", "Landroidx/compose/runtime/MutableState;", "isMatchFound", "", "()Z", "getKey", "()Ljava/lang/Object;", "nonNullInternalState", "getNonNullInternalState", "parentSharedContentState", "getParentSharedContentState", "()Landroidx/compose/animation/SharedTransitionScope$SharedContentState;", "animation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class SharedContentState {
        public static final int $stable = 8;

        private final MutableState internalState = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
        private final Object key;

        public SharedContentState(Object obj) {
            this.key = obj;
        }

        public final Object getKey() {
            return this.key;
        }

        public final boolean isMatchFound() {
            SharedElement sharedElement;
            SharedElementInternalState internalState$animation_release = getInternalState$animation_release();
            if (internalState$animation_release == null || (sharedElement = internalState$animation_release.getSharedElement()) == null) {
                return false;
            }
            return sharedElement.getFoundMatch();
        }

        public final Path getClipPathInOverlay() {
            return getNonNullInternalState().getClipPathInOverlay();
        }

        public final SharedContentState getParentSharedContentState() {
            SharedElementInternalState parentState = getNonNullInternalState().getParentState();
            if (parentState != null) {
                return parentState.getUserState();
            }
            return null;
        }

        public final SharedElementInternalState getInternalState$animation_release() {
            return (SharedElementInternalState) this.internalState.getValue();
        }

        public final void setInternalState$animation_release(SharedElementInternalState sharedElementInternalState) {
            this.internalState.setValue(sharedElementInternalState);
        }

        private final SharedElementInternalState getNonNullInternalState() {
            SharedElementInternalState internalState$animation_release = getInternalState$animation_release();
            if (internalState$animation_release != null) {
                return internalState$animation_release;
            }
            throw new IllegalArgumentException("Error: SharedContentState has not been added to a sharedElement/sharedBoundsmodifier yet. Therefore the internal state has not bee initialized.".toString());
        }
    }
}
