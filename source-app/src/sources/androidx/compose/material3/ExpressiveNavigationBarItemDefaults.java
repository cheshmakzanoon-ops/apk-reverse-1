package androidx.compose.material3;

import androidx.compose.p002ui.graphics.Color;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\bÁ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\r\u0010\b\u001a\u00020\u0004H\u0007¢\u0006\u0002\u0010\tR\u0018\u0010\u0003\u001a\u00020\u0004*\u00020\u00058@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\n"}, d2 = {"Landroidx/compose/material3/ExpressiveNavigationBarItemDefaults;", "", "()V", "defaultExpressiveNavigationBarItemColors", "Landroidx/compose/material3/NavigationItemColors;", "Landroidx/compose/material3/ColorScheme;", "getDefaultExpressiveNavigationBarItemColors$material3_release", "(Landroidx/compose/material3/ColorScheme;)Landroidx/compose/material3/NavigationItemColors;", "colors", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/material3/NavigationItemColors;", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class ExpressiveNavigationBarItemDefaults {
    public static final int $stable = 0;
    public static final ExpressiveNavigationBarItemDefaults INSTANCE = new ExpressiveNavigationBarItemDefaults();

    private ExpressiveNavigationBarItemDefaults() {
    }

    public final NavigationItemColors colors(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 1959617551, "C(colors)272@11438L11:ExpressiveNavigationBar.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1959617551, i, -1, "androidx.compose.material3.ExpressiveNavigationBarItemDefaults.colors (ExpressiveNavigationBar.kt:272)");
        }
        NavigationItemColors defaultExpressiveNavigationBarItemColors$material3_release = getDefaultExpressiveNavigationBarItemColors$material3_release(MaterialTheme.INSTANCE.getColorScheme(composer, 6));
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return defaultExpressiveNavigationBarItemColors$material3_release;
    }

    public final NavigationItemColors getDefaultExpressiveNavigationBarItemColors$material3_release(ColorScheme colorScheme) {
        NavigationItemColors defaultExpressiveNavigationBarItemColorsCached = colorScheme.getDefaultExpressiveNavigationBarItemColorsCached();
        if (defaultExpressiveNavigationBarItemColorsCached != null) {
            return defaultExpressiveNavigationBarItemColorsCached;
        }
        NavigationItemColors navigationItemColors = new NavigationItemColors(ColorSchemeKt.fromToken(colorScheme, ExpressiveNavigationBarKt.ActiveIconColor), ColorSchemeKt.fromToken(colorScheme, ExpressiveNavigationBarKt.ActiveLabelTextColor), ColorSchemeKt.fromToken(colorScheme, ExpressiveNavigationBarKt.ActiveIndicatorColor), ColorSchemeKt.fromToken(colorScheme, ExpressiveNavigationBarKt.InactiveIconColor), ColorSchemeKt.fromToken(colorScheme, ExpressiveNavigationBarKt.InactiveLabelTextColor), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, ExpressiveNavigationBarKt.InactiveIconColor), 0.38f, 0.0f, 0.0f, 0.0f, 14, null), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, ExpressiveNavigationBarKt.InactiveLabelTextColor), 0.38f, 0.0f, 0.0f, 0.0f, 14, null), null);
        colorScheme.m89x8a7577ad(navigationItemColors);
        return navigationItemColors;
    }
}
