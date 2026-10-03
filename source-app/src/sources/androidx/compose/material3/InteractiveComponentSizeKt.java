package androidx.compose.material3;

import androidx.compose.p002ui.Modifier;
import androidx.compose.runtime.CompositionLocalKt;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.ui.unit.Dp;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.jvm.functions.Function0;

@Metadata(d1 = {"\u0000\u001c\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u000b\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\u001a\f\u0010\n\u001a\u00020\u000b*\u00020\u000bH\u0007\"\"\u0010\u0000\u001a\b\u0012\u0004\u0012\u00020\u00020\u00018GX\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0003\u0010\u0004\u001a\u0004\b\u0005\u0010\u0006\"\u0017\u0010\u0007\u001a\b\u0012\u0004\u0012\u00020\b0\u0001¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\u0006¨\u0006\f"}, d2 = {"LocalMinimumInteractiveComponentEnforcement", "Landroidx/compose/runtime/ProvidableCompositionLocal;", "", "getLocalMinimumInteractiveComponentEnforcement$annotations", "()V", "getLocalMinimumInteractiveComponentEnforcement", "()Landroidx/compose/runtime/ProvidableCompositionLocal;", "LocalMinimumInteractiveComponentSize", "Landroidx/compose/ui/unit/Dp;", "getLocalMinimumInteractiveComponentSize", "minimumInteractiveComponentSize", "Landroidx/compose/ui/Modifier;", "material3_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class InteractiveComponentSizeKt {
    private static final ProvidableCompositionLocal<Boolean> LocalMinimumInteractiveComponentEnforcement = CompositionLocalKt.staticCompositionLocalOf(new Function0<Boolean>() {
        public final Boolean m2460invoke() {
            return true;
        }
    });
    private static final ProvidableCompositionLocal<Dp> LocalMinimumInteractiveComponentSize = CompositionLocalKt.staticCompositionLocalOf(new Function0<Dp>() {
        public Object invoke() {
            return Dp.box-impl(m2461invokeD9Ej5fM());
        }

        public final float m2461invokeD9Ej5fM() {
            return Dp.constructor-impl(48);
        }
    });

    @Deprecated(level = DeprecationLevel.WARNING, message = "Use LocalMinimumInteractiveComponentSize with Dp.Unspecified to turn off enforcement instead.", replaceWith = @ReplaceWith(expression = "LocalMinimumInteractiveComponentSize", imports = {}))
    public static void getLocalMinimumInteractiveComponentEnforcement$annotations() {
    }

    public static final Modifier minimumInteractiveComponentSize(Modifier modifier) {
        return modifier.then(MinimumInteractiveModifier.INSTANCE);
    }

    public static final ProvidableCompositionLocal<Boolean> getLocalMinimumInteractiveComponentEnforcement() {
        return LocalMinimumInteractiveComponentEnforcement;
    }

    public static final ProvidableCompositionLocal<Dp> getLocalMinimumInteractiveComponentSize() {
        return LocalMinimumInteractiveComponentSize;
    }
}
