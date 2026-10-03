package androidx.compose.foundation.lazy.layout;

import androidx.compose.foundation.gestures.Orientation;
import androidx.compose.p002ui.Modifier;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.ui.unit.LayoutDirection;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000.\n\u0000\n\u0002\u0010\u0001\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\u001a\b\u0010\u0000\u001a\u00020\u0001H\u0002\u001aA\u0010\u0002\u001a\u00020\u0003*\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\tH\u0001¢\u0006\u0002\u0010\u000f¨\u0006\u0010"}, d2 = {"unsupportedDirection", "", "lazyLayoutBeyondBoundsModifier", "Landroidx/compose/ui/Modifier;", "state", "Landroidx/compose/foundation/lazy/layout/LazyLayoutBeyondBoundsState;", "beyondBoundsInfo", "Landroidx/compose/foundation/lazy/layout/LazyLayoutBeyondBoundsInfo;", "reverseLayout", "", "layoutDirection", "Landroidx/compose/ui/unit/LayoutDirection;", "orientation", "Landroidx/compose/foundation/gestures/Orientation;", "enabled", "(Landroidx/compose/ui/Modifier;Landroidx/compose/foundation/lazy/layout/LazyLayoutBeyondBoundsState;Landroidx/compose/foundation/lazy/layout/LazyLayoutBeyondBoundsInfo;ZLandroidx/compose/ui/unit/LayoutDirection;Landroidx/compose/foundation/gestures/Orientation;ZLandroidx/compose/runtime/Composer;I)Landroidx/compose/ui/Modifier;", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class LazyLayoutBeyondBoundsModifierLocalKt {
    public static final Modifier lazyLayoutBeyondBoundsModifier(Modifier modifier, LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsState, LazyLayoutBeyondBoundsInfo lazyLayoutBeyondBoundsInfo, boolean z, LayoutDirection layoutDirection, Orientation orientation, boolean z2, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 1331498025, "C(lazyLayoutBeyondBoundsModifier)P(5!1,4,2,3):LazyLayoutBeyondBoundsModifierLocal.kt#wow0x6");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1331498025, i, -1, "androidx.compose.foundation.lazy.layout.lazyLayoutBeyondBoundsModifier (LazyLayoutBeyondBoundsModifierLocal.kt:51)");
        }
        if (z2) {
            composer.startReplaceGroup(-1890632411);
            ComposerKt.sourceInformation(composer, "54@2427L270");
            ComposerKt.sourceInformationMarkerStart(composer, -753724309, "CC(remember):LazyLayoutBeyondBoundsModifierLocal.kt#9igjgp");
            boolean z3 = ((((i & 112) ^ 48) > 32 && composer.changed(lazyLayoutBeyondBoundsState)) || (i & 48) == 32) | ((((i & 896) ^ 384) > 256 && composer.changed(lazyLayoutBeyondBoundsInfo)) || (i & 384) == 256) | ((((i & 7168) ^ 3072) > 2048 && composer.changed(z)) || (i & 3072) == 2048) | ((((57344 & i) ^ 24576) > 16384 && composer.changed(layoutDirection)) || (i & 24576) == 16384) | ((((458752 & i) ^ 196608) > 131072 && composer.changed(orientation)) || (i & 196608) == 131072);
            Object objRememberedValue = composer.rememberedValue();
            if (z3 || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = new LazyLayoutBeyondBoundsModifierLocal(lazyLayoutBeyondBoundsState, lazyLayoutBeyondBoundsInfo, z, layoutDirection, orientation);
                composer.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composer);
            modifier = modifier.then((LazyLayoutBeyondBoundsModifierLocal) objRememberedValue);
            composer.endReplaceGroup();
        } else {
            composer.startReplaceGroup(-1890658823);
            composer.endReplaceGroup();
        }
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return modifier;
    }

    public static final Void unsupportedDirection() {
        throw new IllegalStateException("Lazy list does not support beyond bounds layout for the specified direction".toString());
    }
}
