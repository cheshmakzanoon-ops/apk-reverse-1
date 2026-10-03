package androidx.compose.material3;

import androidx.compose.material.ripple.RippleAlpha;
import androidx.compose.material.ripple.RippleTheme;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.ProvidableCompositionLocal;
import kotlin.Deprecated;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\bÁ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0015\u0010\u0003\u001a\u00020\u0004H\u0017ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b\u0005\u0010\u0006J\r\u0010\u0007\u001a\u00020\bH\u0017¢\u0006\u0002\u0010\t\u0082\u0002\u000b\n\u0002\b!\n\u0005\b¡\u001e0\u0001¨\u0006\n"}, d2 = {"Landroidx/compose/material3/CompatRippleTheme;", "Landroidx/compose/material/ripple/RippleTheme;", "()V", "defaultColor", "Landroidx/compose/ui/graphics/Color;", "defaultColor-WaAFU9c", "(Landroidx/compose/runtime/Composer;I)J", "rippleAlpha", "Landroidx/compose/material/ripple/RippleAlpha;", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/material/ripple/RippleAlpha;", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class CompatRippleTheme implements RippleTheme {
    public static final int $stable = 0;
    public static final CompatRippleTheme INSTANCE = new CompatRippleTheme();

    private CompatRippleTheme() {
    }

    @Override
    @Deprecated(message = "Super method is deprecated")
    public long mo1966defaultColorWaAFU9c(Composer composer, int i) {
        composer.startReplaceGroup(-1844533201);
        ComposerKt.sourceInformation(composer, "C(defaultColor)244@11142L7:Ripple.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1844533201, i, -1, "androidx.compose.material3.CompatRippleTheme.defaultColor (Ripple.kt:244)");
        }
        ProvidableCompositionLocal<Color> localContentColor = ContentColorKt.getLocalContentColor();
        ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
        Object objConsume = composer.consume(localContentColor);
        ComposerKt.sourceInformationMarkerEnd(composer);
        long jM4600unboximpl = ((Color) objConsume).m4600unboximpl();
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceGroup();
        return jM4600unboximpl;
    }

    @Override
    @Deprecated(message = "Super method is deprecated")
    public RippleAlpha rippleAlpha(Composer composer, int i) {
        composer.startReplaceGroup(-290975286);
        ComposerKt.sourceInformation(composer, "C(rippleAlpha):Ripple.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-290975286, i, -1, "androidx.compose.material3.CompatRippleTheme.rippleAlpha (Ripple.kt:248)");
        }
        RippleAlpha rippleAlpha = RippleDefaults.INSTANCE.getRippleAlpha();
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceGroup();
        return rippleAlpha;
    }
}
