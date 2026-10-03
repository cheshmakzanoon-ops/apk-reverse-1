package zendesk.p009ui.android.compose.utils;

import androidx.compose.p000ui.unit.LayoutDirection;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocal;
import androidx.compose.ui.ComposedModifierKt;
import androidx.compose.ui.Modifier;
import androidx.compose.ui.draw.ScaleKt;
import androidx.compose.ui.platform.CompositionLocalsKt;
import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000\b\n\u0000\n\u0002\u0018\u0002\n\u0000\u001a\f\u0010\u0000\u001a\u00020\u0001*\u00020\u0001H\u0007¨\u0006\u0002"}, d2 = {"mirror", "Landroidx/compose/ui/Modifier;", "zendesk.ui_ui-android"}, k = 2, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class ModifierExtensionsKt {
    public static final Modifier mirror(Modifier modifier) {
        Intrinsics.checkNotNullParameter(modifier, "<this>");
        return ComposedModifierKt.composed$default(modifier, (Function1) null, new Function3<Modifier, Composer, Integer, Modifier>() {
            public Object invoke(Object obj, Object obj2, Object obj3) {
                return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
            }

            public final Modifier invoke(Modifier modifier2, Composer composer, int i) {
                Intrinsics.checkNotNullParameter(modifier2, "$this$composed");
                composer.startReplaceGroup(-728381788);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-728381788, i, -1, "zendesk.ui.android.compose.utils.mirror.<anonymous> (ModifierExtensions.kt:34)");
                }
                CompositionLocal localLayoutDirection = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume = composer.consume(localLayoutDirection);
                ComposerKt.sourceInformationMarkerEnd(composer);
                if (objConsume == LayoutDirection.Rtl) {
                    modifier2 = ScaleKt.scale(modifier2, -1.0f, 1.0f);
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                composer.endReplaceGroup();
                return modifier2;
            }
        }, 1, (Object) null);
    }
}
