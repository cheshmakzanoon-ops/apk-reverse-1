package zendesk.p026ui.android.conversation.waittimebanner;

import androidx.compose.foundation.BorderStroke;
import androidx.compose.foundation.layout.Arrangement;
import androidx.compose.foundation.layout.ColumnKt;
import androidx.compose.foundation.layout.ColumnScope;
import androidx.compose.foundation.layout.ColumnScopeInstance;
import androidx.compose.material3.MaterialTheme;
import androidx.compose.material3.SurfaceKt;
import androidx.compose.runtime.Applier;
import androidx.compose.runtime.ComposablesKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocalMap;
import androidx.compose.runtime.Updater;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.ui.Alignment;
import androidx.compose.ui.ComposedModifierKt;
import androidx.compose.ui.Modifier;
import androidx.compose.ui.graphics.Color;
import androidx.compose.ui.graphics.Shape;
import androidx.compose.ui.layout.MeasurePolicy;
import androidx.compose.ui.node.ComposeUiNode;
import androidx.compose.ui.unit.Dp;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
public final class ComposableSingletons$WaitTimeBannerKt {
    public static final ComposableSingletons$WaitTimeBannerKt INSTANCE = new ComposableSingletons$WaitTimeBannerKt();

    public static Function2<Composer, Integer, Unit> f249lambda1 = ComposableLambdaKt.composableLambdaInstance(1458536225, false, new Function2<Composer, Integer, Unit>() {
        @Override
        public Unit invoke(Composer composer, Integer num) {
            invoke(composer, num.intValue());
            return Unit.INSTANCE;
        }

        public final void invoke(Composer composer, int i) {
            if ((i & 11) != 2 || !composer.getSkipping()) {
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1458536225, i, -1, "zendesk.ui.android.conversation.waittimebanner.ComposableSingletons$WaitTimeBannerKt.lambda-1.<anonymous> (WaitTimeBanner.kt:266)");
                }
                Arrangement.Vertical vertical = Arrangement.INSTANCE.spacedBy-0680j_4(Dp.constructor-impl(20));
                ComposerKt.sourceInformationMarkerStart(composer, -483455358, "CC(Column)P(2,3,1)86@4330L61,87@4396L133:Column.kt#2w3rfo");
                Modifier modifier = Modifier.Companion;
                MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(vertical, Alignment.Companion.getStart(), composer, 6);
                ComposerKt.sourceInformationMarkerStart(composer, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer, 0);
                CompositionLocalMap currentCompositionLocalMap = composer.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer, modifier);
                Function0 constructor = ComposeUiNode.Companion.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composer, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composer.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composer.startReusableNode();
                if (composer.getInserting()) {
                    composer.createNode(constructor);
                } else {
                    composer.useNode();
                }
                Composer composer2 = Updater.constructor-impl(composer);
                Updater.set-impl(composer2, measurePolicyColumnMeasurePolicy, ComposeUiNode.Companion.getSetMeasurePolicy());
                Updater.set-impl(composer2, currentCompositionLocalMap, ComposeUiNode.Companion.getSetResolvedCompositionLocals());
                Function2 setCompositeKeyHash = ComposeUiNode.Companion.getSetCompositeKeyHash();
                if (composer2.getInserting() || !Intrinsics.areEqual(composer2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                    composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.set-impl(composer2, modifierMaterializeModifier, ComposeUiNode.Companion.getSetModifier());
                ComposerKt.sourceInformationMarkerStart(composer, -384784025, "C88@4444L9:Column.kt#2w3rfo");
                ColumnScope columnScope = ColumnScopeInstance.INSTANCE;
                WaitTimeBannerKt.m2150WaitTimeBannerfB7ZVRg(WaitTimeBannerType.Assigned.INSTANCE, MaterialTheme.INSTANCE.getColorScheme(composer, MaterialTheme.$stable).getOnBackground-0d7_KjU(), MaterialTheme.INSTANCE.getColorScheme(composer, MaterialTheme.$stable).getOnBackground-0d7_KjU(), Color.Companion.getGreen-0d7_KjU(), MaterialTheme.INSTANCE.getColorScheme(composer, MaterialTheme.$stable).getOnBackground-0d7_KjU(), MaterialTheme.INSTANCE.getColorScheme(composer, MaterialTheme.$stable).getOnBackground-0d7_KjU(), false, new Function1<Boolean, Unit>() {
                    public final void invoke(boolean z) {
                    }

                    @Override
                    public Unit invoke(Boolean bool) {
                        invoke(bool.booleanValue());
                        return Unit.INSTANCE;
                    }
                }, null, composer, 14158854, 256);
                WaitTimeBannerKt.m2150WaitTimeBannerfB7ZVRg(new WaitTimeBannerType.Queued(true, new ResponseTime(1800000004532567453L, 9000000674532536754L), false, 0, 0, 24, null), MaterialTheme.INSTANCE.getColorScheme(composer, MaterialTheme.$stable).getOnBackground-0d7_KjU(), MaterialTheme.INSTANCE.getColorScheme(composer, MaterialTheme.$stable).getOnBackground-0d7_KjU(), Color.Companion.getGreen-0d7_KjU(), MaterialTheme.INSTANCE.getColorScheme(composer, MaterialTheme.$stable).getOnBackground-0d7_KjU(), MaterialTheme.INSTANCE.getColorScheme(composer, MaterialTheme.$stable).getOnBackground-0d7_KjU(), false, new Function1<Boolean, Unit>() {
                    public final void invoke(boolean z) {
                    }

                    @Override
                    public Unit invoke(Boolean bool) {
                        invoke(bool.booleanValue());
                        return Unit.INSTANCE;
                    }
                }, null, composer, 14158848, 256);
                WaitTimeBannerKt.m2150WaitTimeBannerfB7ZVRg(new WaitTimeBannerType.Queued(true, new ResponseTime(1800000004532567453L, 9000000674532536754L), true, 50, 50), MaterialTheme.INSTANCE.getColorScheme(composer, MaterialTheme.$stable).getOnBackground-0d7_KjU(), MaterialTheme.INSTANCE.getColorScheme(composer, MaterialTheme.$stable).getOnBackground-0d7_KjU(), Color.Companion.getGreen-0d7_KjU(), MaterialTheme.INSTANCE.getColorScheme(composer, MaterialTheme.$stable).getOnBackground-0d7_KjU(), MaterialTheme.INSTANCE.getColorScheme(composer, MaterialTheme.$stable).getOnBackground-0d7_KjU(), false, new Function1<Boolean, Unit>() {
                    public final void invoke(boolean z) {
                    }

                    @Override
                    public Unit invoke(Boolean bool) {
                        invoke(bool.booleanValue());
                        return Unit.INSTANCE;
                    }
                }, null, composer, 14158848, 256);
                WaitTimeBannerKt.m2150WaitTimeBannerfB7ZVRg(new WaitTimeBannerType.Queued(false, new ResponseTime(0L, 0L, 3, null), true, 11, 11), MaterialTheme.INSTANCE.getColorScheme(composer, MaterialTheme.$stable).getOnBackground-0d7_KjU(), MaterialTheme.INSTANCE.getColorScheme(composer, MaterialTheme.$stable).getOnBackground-0d7_KjU(), Color.Companion.getGreen-0d7_KjU(), MaterialTheme.INSTANCE.getColorScheme(composer, MaterialTheme.$stable).getOnBackground-0d7_KjU(), MaterialTheme.INSTANCE.getColorScheme(composer, MaterialTheme.$stable).getOnBackground-0d7_KjU(), false, new Function1<Boolean, Unit>() {
                    public final void invoke(boolean z) {
                    }

                    @Override
                    public Unit invoke(Boolean bool) {
                        invoke(bool.booleanValue());
                        return Unit.INSTANCE;
                    }
                }, null, composer, 14158848, 256);
                ComposerKt.sourceInformationMarkerEnd(composer);
                composer.endNode();
                ComposerKt.sourceInformationMarkerEnd(composer);
                ComposerKt.sourceInformationMarkerEnd(composer);
                ComposerKt.sourceInformationMarkerEnd(composer);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                    return;
                }
                return;
            }
            composer.skipToGroupEnd();
        }
    });

    public static Function2<Composer, Integer, Unit> f250lambda2 = ComposableLambdaKt.composableLambdaInstance(-1734279268, false, new Function2<Composer, Integer, Unit>() {
        @Override
        public Unit invoke(Composer composer, Integer num) {
            invoke(composer, num.intValue());
            return Unit.INSTANCE;
        }

        public final void invoke(Composer composer, int i) {
            if ((i & 11) != 2 || !composer.getSkipping()) {
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1734279268, i, -1, "zendesk.ui.android.conversation.waittimebanner.ComposableSingletons$WaitTimeBannerKt.lambda-2.<anonymous> (WaitTimeBanner.kt:265)");
                }
                SurfaceKt.Surface-T9BRK9s((Modifier) null, (Shape) null, 0L, 0L, 0.0f, 0.0f, (BorderStroke) null, ComposableSingletons$WaitTimeBannerKt.INSTANCE.m2145getLambda1$zendesk_ui_ui_android(), composer, 12582912, 127);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                    return;
                }
                return;
            }
            composer.skipToGroupEnd();
        }
    });

    public static Function2<Composer, Integer, Unit> f251lambda3 = ComposableLambdaKt.composableLambdaInstance(-505691145, false, new Function2<Composer, Integer, Unit>() {
        @Override
        public Unit invoke(Composer composer, Integer num) {
            invoke(composer, num.intValue());
            return Unit.INSTANCE;
        }

        public final void invoke(Composer composer, int i) {
            if ((i & 11) != 2 || !composer.getSkipping()) {
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-505691145, i, -1, "zendesk.ui.android.conversation.waittimebanner.ComposableSingletons$WaitTimeBannerKt.lambda-3.<anonymous> (WaitTimeBanner.kt:344)");
                }
                Arrangement.Vertical vertical = Arrangement.INSTANCE.spacedBy-0680j_4(Dp.constructor-impl(20));
                ComposerKt.sourceInformationMarkerStart(composer, -483455358, "CC(Column)P(2,3,1)86@4330L61,87@4396L133:Column.kt#2w3rfo");
                Modifier modifier = Modifier.Companion;
                MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(vertical, Alignment.Companion.getStart(), composer, 6);
                ComposerKt.sourceInformationMarkerStart(composer, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer, 0);
                CompositionLocalMap currentCompositionLocalMap = composer.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer, modifier);
                Function0 constructor = ComposeUiNode.Companion.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composer, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composer.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composer.startReusableNode();
                if (composer.getInserting()) {
                    composer.createNode(constructor);
                } else {
                    composer.useNode();
                }
                Composer composer2 = Updater.constructor-impl(composer);
                Updater.set-impl(composer2, measurePolicyColumnMeasurePolicy, ComposeUiNode.Companion.getSetMeasurePolicy());
                Updater.set-impl(composer2, currentCompositionLocalMap, ComposeUiNode.Companion.getSetResolvedCompositionLocals());
                Function2 setCompositeKeyHash = ComposeUiNode.Companion.getSetCompositeKeyHash();
                if (composer2.getInserting() || !Intrinsics.areEqual(composer2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                    composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.set-impl(composer2, modifierMaterializeModifier, ComposeUiNode.Companion.getSetModifier());
                ComposerKt.sourceInformationMarkerStart(composer, -384784025, "C88@4444L9:Column.kt#2w3rfo");
                ColumnScope columnScope = ColumnScopeInstance.INSTANCE;
                WaitTimeBannerKt.m2150WaitTimeBannerfB7ZVRg(WaitTimeBannerType.Cleared.INSTANCE, MaterialTheme.INSTANCE.getColorScheme(composer, MaterialTheme.$stable).getOnBackground-0d7_KjU(), MaterialTheme.INSTANCE.getColorScheme(composer, MaterialTheme.$stable).getOnBackground-0d7_KjU(), Color.Companion.getGreen-0d7_KjU(), MaterialTheme.INSTANCE.getColorScheme(composer, MaterialTheme.$stable).getOnBackground-0d7_KjU(), MaterialTheme.INSTANCE.getColorScheme(composer, MaterialTheme.$stable).getOnBackground-0d7_KjU(), false, new Function1<Boolean, Unit>() {
                    public final void invoke(boolean z) {
                    }

                    @Override
                    public Unit invoke(Boolean bool) {
                        invoke(bool.booleanValue());
                        return Unit.INSTANCE;
                    }
                }, null, composer, 14158854, 256);
                ComposerKt.sourceInformationMarkerEnd(composer);
                composer.endNode();
                ComposerKt.sourceInformationMarkerEnd(composer);
                ComposerKt.sourceInformationMarkerEnd(composer);
                ComposerKt.sourceInformationMarkerEnd(composer);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                    return;
                }
                return;
            }
            composer.skipToGroupEnd();
        }
    });

    public static Function2<Composer, Integer, Unit> f252lambda4 = ComposableLambdaKt.composableLambdaInstance(111858460, false, new Function2<Composer, Integer, Unit>() {
        @Override
        public Unit invoke(Composer composer, Integer num) {
            invoke(composer, num.intValue());
            return Unit.INSTANCE;
        }

        public final void invoke(Composer composer, int i) {
            if ((i & 11) != 2 || !composer.getSkipping()) {
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(111858460, i, -1, "zendesk.ui.android.conversation.waittimebanner.ComposableSingletons$WaitTimeBannerKt.lambda-4.<anonymous> (WaitTimeBanner.kt:343)");
                }
                SurfaceKt.Surface-T9BRK9s((Modifier) null, (Shape) null, 0L, 0L, 0.0f, 0.0f, (BorderStroke) null, ComposableSingletons$WaitTimeBannerKt.INSTANCE.m2147getLambda3$zendesk_ui_ui_android(), composer, 12582912, 127);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                    return;
                }
                return;
            }
            composer.skipToGroupEnd();
        }
    });

    public final Function2<Composer, Integer, Unit> m2145getLambda1$zendesk_ui_ui_android() {
        return f249lambda1;
    }

    public final Function2<Composer, Integer, Unit> m2146getLambda2$zendesk_ui_ui_android() {
        return f250lambda2;
    }

    public final Function2<Composer, Integer, Unit> m2147getLambda3$zendesk_ui_ui_android() {
        return f251lambda3;
    }

    public final Function2<Composer, Integer, Unit> m2148getLambda4$zendesk_ui_ui_android() {
        return f252lambda4;
    }
}
