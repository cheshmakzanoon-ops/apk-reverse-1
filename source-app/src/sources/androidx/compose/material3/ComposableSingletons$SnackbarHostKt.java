package androidx.compose.material3;

import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function3;

@Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
public final class ComposableSingletons$SnackbarHostKt {
    public static final ComposableSingletons$SnackbarHostKt INSTANCE = new ComposableSingletons$SnackbarHostKt();

    public static Function3<SnackbarData, Composer, Integer, Unit> f219lambda1 = ComposableLambdaKt.composableLambdaInstance(818736383, false, new Function3<SnackbarData, Composer, Integer, Unit>() {
        public Object invoke(Object obj, Object obj2, Object obj3) {
            invoke((SnackbarData) obj, (Composer) obj2, ((Number) obj3).intValue());
            return Unit.INSTANCE;
        }

        public final void invoke(SnackbarData snackbarData, Composer composer, int i) {
            int i2;
            ComposerKt.sourceInformation(composer, "C220@9332L12:SnackbarHost.kt#uh7d8r");
            if ((i & 6) == 0) {
                i2 = i | (composer.changed(snackbarData) ? 4 : 2);
            } else {
                i2 = i;
            }
            if ((i2 & 19) == 18 && composer.getSkipping()) {
                composer.skipToGroupEnd();
                return;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(818736383, i2, -1, "androidx.compose.material3.ComposableSingletons$SnackbarHostKt.lambda-1.<anonymous> (SnackbarHost.kt:220)");
            }
            SnackbarKt.m2852SnackbarsDKtq54(snackbarData, null, false, null, 0L, 0L, 0L, 0L, 0L, composer, i2 & 14, 510);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
    });

    public final Function3<SnackbarData, Composer, Integer, Unit> m2226getLambda1$material3_release() {
        return f219lambda1;
    }
}
