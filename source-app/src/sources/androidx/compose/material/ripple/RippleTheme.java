package androidx.compose.material.ripple;

import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.ColorKt;
import androidx.compose.runtime.Composer;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;

@Deprecated(level = DeprecationLevel.ERROR, message = "RippleTheme and LocalRippleTheme have been deprecated - they are not compatible with the new ripple implementation using the new Indication APIs that provide notable performance improvements. For a migration guide and background information, please visit developer.android.com")
@Metadata(d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\bg\u0018\u0000 \t2\u00020\u0001:\u0001\tJ\u0015\u0010\u0002\u001a\u00020\u0003H'ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b\u0004\u0010\u0005J\r\u0010\u0006\u001a\u00020\u0007H'¢\u0006\u0002\u0010\bø\u0001\u0002\u0082\u0002\u0011\n\u0002\b!\n\u0005\b¡\u001e0\u0001\n\u0004\b!0\u0001¨\u0006\nÀ\u0006\u0001"}, d2 = {"Landroidx/compose/material/ripple/RippleTheme;", "", "defaultColor", "Landroidx/compose/ui/graphics/Color;", "defaultColor-WaAFU9c", "(Landroidx/compose/runtime/Composer;I)J", "rippleAlpha", "Landroidx/compose/material/ripple/RippleAlpha;", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/material/ripple/RippleAlpha;", "Companion", "material-ripple_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public interface RippleTheme {

    public static final Companion INSTANCE = Companion.$$INSTANCE;

    @Deprecated(level = DeprecationLevel.ERROR, message = "RippleTheme and LocalRippleTheme have been deprecated - they are not compatible with the new ripple implementation using the new Indication APIs that provide notable performance improvements. For a migration guide and background information, please visit developer.android.com")
    long mo1966defaultColorWaAFU9c(Composer composer, int i);

    @Deprecated(level = DeprecationLevel.ERROR, message = "RippleTheme and LocalRippleTheme have been deprecated - they are not compatible with the new ripple implementation using the new Indication APIs that provide notable performance improvements. For a migration guide and background information, please visit developer.android.com")
    RippleAlpha rippleAlpha(Composer composer, int i);

    @Metadata(d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0006\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\"\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bH\u0007ø\u0001\u0000¢\u0006\u0004\b\t\u0010\nJ\"\u0010\u000b\u001a\u00020\u00062\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bH\u0007ø\u0001\u0000¢\u0006\u0004\b\f\u0010\r\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u000e"}, d2 = {"Landroidx/compose/material/ripple/RippleTheme$Companion;", "", "()V", "defaultRippleAlpha", "Landroidx/compose/material/ripple/RippleAlpha;", "contentColor", "Landroidx/compose/ui/graphics/Color;", "lightTheme", "", "defaultRippleAlpha-DxMtmZc", "(JZ)Landroidx/compose/material/ripple/RippleAlpha;", "defaultRippleColor", "defaultRippleColor-5vOe2sY", "(JZ)J", "material-ripple_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        static final Companion $$INSTANCE = new Companion();

        private Companion() {
        }

        @Deprecated(level = DeprecationLevel.WARNING, message = "The default ripple color varies between design system versions: this function technically implements the default used by the material library, but is not used by the material3 library. To remove confusion and link the defaults more strongly to the design system library, these default values have been moved to the material and material3 libraries. For material, use MaterialRippleThemeDefaults#rippleColor. For material3, use content color directly.")
        public final long m1980defaultRippleColor5vOe2sY(long contentColor, boolean lightTheme) {
            return (lightTheme || ((double) ColorKt.m4642luminance8_81llA(contentColor)) >= 0.5d) ? contentColor : Color.INSTANCE.m4627getWhite0d7_KjU();
        }

        @Deprecated(level = DeprecationLevel.WARNING, message = "The default ripple alpha varies between design system versions: this function technically implements the default used by the material library, but is not used by the material3 library. To remove confusion and link the defaults more strongly to the design system library, these default values have been moved to the material and material3 libraries. For material, use MaterialRippleThemeDefaults#rippleAlpha. For material3, use MaterialRippleThemeDefaults#RippleAlpha.")
        public final RippleAlpha m1979defaultRippleAlphaDxMtmZc(long contentColor, boolean lightTheme) {
            if (lightTheme) {
                return ((double) ColorKt.m4642luminance8_81llA(contentColor)) > 0.5d ? RippleThemeKt.LightThemeHighContrastRippleAlpha : RippleThemeKt.LightThemeLowContrastRippleAlpha;
            }
            return RippleThemeKt.DarkThemeRippleAlpha;
        }
    }
}
