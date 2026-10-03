package androidx.compose.material3;

import androidx.compose.material.icons.Icons;
import androidx.compose.material.icons.filled.CloseKt;
import androidx.compose.material3.internal.Strings;
import androidx.compose.material3.internal.Strings_androidKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.vector.ImageVector;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function2;

@Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
public final class ComposableSingletons$SnackbarKt {
    public static final ComposableSingletons$SnackbarKt INSTANCE = new ComposableSingletons$SnackbarKt();

    public static Function2<Composer, Integer, Unit> f220lambda1 = ComposableLambdaKt.composableLambdaInstance(-505750804, false, new Function2<Composer, Integer, Unit>() {
        public Object invoke(Object obj, Object obj2) {
            invoke((Composer) obj, ((Number) obj2).intValue());
            return Unit.INSTANCE;
        }

        public final void invoke(Composer composer, int i) {
            ComposerKt.sourceInformation(composer, "C233@10795L34,231@10692L164:Snackbar.kt#uh7d8r");
            if ((i & 3) != 2 || !composer.getSkipping()) {
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-505750804, i, -1, "androidx.compose.material3.ComposableSingletons$SnackbarKt.lambda-1.<anonymous> (Snackbar.kt:231)");
                }
                ImageVector close = CloseKt.getClose(Icons.Filled.INSTANCE);
                Strings.Companion companion = Strings.INSTANCE;
                IconKt.m2433Iconww6aTOc(close, Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_snackbar_dismiss), composer, 0), (Modifier) null, 0L, composer, 0, 12);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                    return;
                }
                return;
            }
            composer.skipToGroupEnd();
        }
    });

    public final Function2<Composer, Integer, Unit> m2227getLambda1$material3_release() {
        return f220lambda1;
    }
}
