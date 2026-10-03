package zendesk.p026ui.android.conversation.aidisclaimer;

import androidx.compose.foundation.BorderStroke;
import androidx.compose.material3.MaterialTheme;
import androidx.compose.material3.SurfaceKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.ui.Modifier;
import androidx.compose.ui.graphics.Color;
import androidx.compose.ui.graphics.Shape;
import androidx.compose.ui.res.StringResources_androidKt;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function2;
import zendesk.ui.android.R;
import zendesk.ui.android.compose.utils.ResourceUtilsKt;

@Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
public final class ComposableSingletons$AiDisclaimerKt {
    public static final ComposableSingletons$AiDisclaimerKt INSTANCE = new ComposableSingletons$AiDisclaimerKt();

    public static Function2<Composer, Integer, Unit> f247lambda1 = ComposableLambdaKt.composableLambdaInstance(-694102130, false, new Function2<Composer, Integer, Unit>() {
        @Override
        public Unit invoke(Composer composer, Integer num) {
            invoke(composer, num.intValue());
            return Unit.INSTANCE;
        }

        public final void invoke(Composer composer, int i) {
            if ((i & 11) != 2 || !composer.getSkipping()) {
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-694102130, i, -1, "zendesk.ui.android.conversation.aidisclaimer.ComposableSingletons$AiDisclaimerKt.lambda-1.<anonymous> (AiDisclaimer.kt:127)");
                }
                AiDisclaimerKt.m2129AiDisclaimervc5YOHI(Color.copy-wmQWz5c$default(MaterialTheme.INSTANCE.getColorScheme(composer, MaterialTheme.$stable).getOnBackground-0d7_KjU(), ResourceUtilsKt.floatResources(R.integer.zuia_ai_disclaimer_text_alpha, composer, 0), 0.0f, 0.0f, 0.0f, 14, (Object) null), Color.copy-wmQWz5c$default(MaterialTheme.INSTANCE.getColorScheme(composer, MaterialTheme.$stable).getOnBackground-0d7_KjU(), ResourceUtilsKt.floatResources(R.integer.zuia_ai_disclaimer_icon_alpha, composer, 0), 0.0f, 0.0f, 0.0f, 14, (Object) null), null, StringResources_androidKt.stringResource(R.string.zuia_generated_by_ai, composer, 0), null, composer, 0, 20);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                    return;
                }
                return;
            }
            composer.skipToGroupEnd();
        }
    });

    public static Function2<Composer, Integer, Unit> f248lambda2 = ComposableLambdaKt.composableLambdaInstance(1911825737, false, new Function2<Composer, Integer, Unit>() {
        @Override
        public Unit invoke(Composer composer, Integer num) {
            invoke(composer, num.intValue());
            return Unit.INSTANCE;
        }

        public final void invoke(Composer composer, int i) {
            if ((i & 11) != 2 || !composer.getSkipping()) {
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1911825737, i, -1, "zendesk.ui.android.conversation.aidisclaimer.ComposableSingletons$AiDisclaimerKt.lambda-2.<anonymous> (AiDisclaimer.kt:126)");
                }
                SurfaceKt.Surface-T9BRK9s((Modifier) null, (Shape) null, 0L, 0L, 0.0f, 0.0f, (BorderStroke) null, ComposableSingletons$AiDisclaimerKt.INSTANCE.m2131getLambda1$zendesk_ui_ui_android(), composer, 12582912, 127);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                    return;
                }
                return;
            }
            composer.skipToGroupEnd();
        }
    });

    public final Function2<Composer, Integer, Unit> m2131getLambda1$zendesk_ui_ui_android() {
        return f247lambda1;
    }

    public final Function2<Composer, Integer, Unit> m2132getLambda2$zendesk_ui_ui_android() {
        return f248lambda2;
    }
}
