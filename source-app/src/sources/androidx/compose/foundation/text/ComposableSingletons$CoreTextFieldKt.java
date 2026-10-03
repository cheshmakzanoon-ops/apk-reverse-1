package androidx.compose.foundation.text;

import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;

@Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
public final class ComposableSingletons$CoreTextFieldKt {
    public static final ComposableSingletons$CoreTextFieldKt INSTANCE = new ComposableSingletons$CoreTextFieldKt();

    public static Function3<Function2<? super Composer, ? super Integer, Unit>, Composer, Integer, Unit> f177lambda1 = ComposableLambdaKt.composableLambdaInstance(671295101, false, new Function3<Function2<? super Composer, ? super Integer, ? extends Unit>, Composer, Integer, Unit>() {
        public Object invoke(Object obj, Object obj2, Object obj3) {
            invoke((Function2<? super Composer, ? super Integer, Unit>) obj, (Composer) obj2, ((Number) obj3).intValue());
            return Unit.INSTANCE;
        }

        public final void invoke(Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, int i) {
            ComposerKt.sourceInformation(composer, "C219@12281L16:CoreTextField.kt#423gt5");
            if ((i & 6) == 0) {
                i |= composer.changedInstance(function2) ? 4 : 2;
            }
            if ((i & 19) == 18 && composer.getSkipping()) {
                composer.skipToGroupEnd();
                return;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(671295101, i, -1, "androidx.compose.foundation.text.ComposableSingletons$CoreTextFieldKt.lambda-1.<anonymous> (CoreTextField.kt:219)");
            }
            function2.invoke(composer, Integer.valueOf(i & 14));
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
    });

    public final Function3<Function2<? super Composer, ? super Integer, Unit>, Composer, Integer, Unit> m1437getLambda1$foundation_release() {
        return f177lambda1;
    }
}
