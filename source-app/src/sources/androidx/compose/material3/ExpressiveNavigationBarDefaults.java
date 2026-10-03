package androidx.compose.material3;

import androidx.compose.foundation.layout.WindowInsets;
import androidx.compose.foundation.layout.WindowInsetsKt;
import androidx.compose.foundation.layout.WindowInsetsSides;
import androidx.compose.material3.internal.SystemBarsDefaultInsets_androidKt;
import androidx.compose.material3.tokens.ColorSchemeKeyTokens;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0003\bÁ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0017\u0010\u0003\u001a\u00020\u00048Fø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u0005\u0010\u0006R\u0017\u0010\u0007\u001a\u00020\b8Gø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\t\u0010\nR\u0017\u0010\u000b\u001a\u00020\b8Gø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\f\u0010\nR\u0011\u0010\r\u001a\u00020\u000e8G¢\u0006\u0006\u001a\u0004\b\u000f\u0010\u0010\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u0011"}, d2 = {"Landroidx/compose/material3/ExpressiveNavigationBarDefaults;", "", "()V", "arrangement", "Landroidx/compose/material3/NavigationBarArrangement;", "getArrangement-Ebr7WPU", "()I", "containerColor", "Landroidx/compose/ui/graphics/Color;", "getContainerColor", "(Landroidx/compose/runtime/Composer;I)J", "contentColor", "getContentColor", "windowInsets", "Landroidx/compose/foundation/layout/WindowInsets;", "getWindowInsets", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/foundation/layout/WindowInsets;", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class ExpressiveNavigationBarDefaults {
    public static final int $stable = 0;
    public static final ExpressiveNavigationBarDefaults INSTANCE = new ExpressiveNavigationBarDefaults();

    private ExpressiveNavigationBarDefaults() {
    }

    public final long getContainerColor(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 1666471887, "C244@10416L5:ExpressiveNavigationBar.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1666471887, i, -1, "androidx.compose.material3.ExpressiveNavigationBarDefaults.<get-containerColor> (ExpressiveNavigationBar.kt:244)");
        }
        long value = ColorSchemeKt.getValue(ColorSchemeKeyTokens.SurfaceContainer, composer, 6);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return value;
    }

    public final long getContentColor(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 190518351, "C249@10617L5:ExpressiveNavigationBar.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(190518351, i, -1, "androidx.compose.material3.ExpressiveNavigationBarDefaults.<get-contentColor> (ExpressiveNavigationBar.kt:249)");
        }
        long value = ColorSchemeKt.getValue(ColorSchemeKeyTokens.OnSurfaceVariant, composer, 6);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return value;
    }

    public final int m2377getArrangementEbr7WPU() {
        return NavigationBarArrangement.INSTANCE.m2551getEqualWeightEbr7WPU();
    }

    public final WindowInsets getWindowInsets(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -1317880490, "C259@10976L29:ExpressiveNavigationBar.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1317880490, i, -1, "androidx.compose.material3.ExpressiveNavigationBarDefaults.<get-windowInsets> (ExpressiveNavigationBar.kt:259)");
        }
        WindowInsets windowInsetsM1106onlybOOhFvg = WindowInsetsKt.m1106onlybOOhFvg(SystemBarsDefaultInsets_androidKt.getSystemBarsForVisualComponents(WindowInsets.INSTANCE, composer, 6), WindowInsetsSides.m1117plusgK_yJZ4(WindowInsetsSides.INSTANCE.m1127getHorizontalJoeWqyM(), WindowInsetsSides.INSTANCE.m1125getBottomJoeWqyM()));
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return windowInsetsM1106onlybOOhFvg;
    }
}
