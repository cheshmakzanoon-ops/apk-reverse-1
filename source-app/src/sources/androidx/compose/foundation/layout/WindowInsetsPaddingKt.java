package androidx.compose.foundation.layout;

import androidx.autofill.HintConstants;
import androidx.compose.p002ui.ComposedModifierKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.modifier.ModifierLocalKt;
import androidx.compose.p002ui.modifier.ProvidableModifierLocal;
import androidx.compose.p002ui.platform.InspectableValueKt;
import androidx.compose.p002ui.platform.InspectorInfo;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function3;

@Metadata(d1 = {"\u00000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\u001a\u0014\u0010\u0005\u001a\u00020\u0006*\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bH\u0007\u001a\u0014\u0010\u0005\u001a\u00020\u0006*\u00020\u00062\u0006\u0010\t\u001a\u00020\u0002H\u0007\u001a/\u0010\n\u001a\u00020\u0006*\u00020\u00062!\u0010\u000b\u001a\u001d\u0012\u0013\u0012\u00110\u0002¢\u0006\f\b\r\u0012\b\b\u000e\u0012\u0004\b\b(\u000f\u0012\u0004\u0012\u00020\u00100\fH\u0007\u001a\u0014\u0010\u0011\u001a\u00020\u0006*\u00020\u00062\u0006\u0010\t\u001a\u00020\u0002H\u0007\"\u001a\u0010\u0000\u001a\b\u0012\u0004\u0012\u00020\u00020\u0001X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0003\u0010\u0004¨\u0006\u0012"}, d2 = {"ModifierLocalConsumedWindowInsets", "Landroidx/compose/ui/modifier/ProvidableModifierLocal;", "Landroidx/compose/foundation/layout/WindowInsets;", "getModifierLocalConsumedWindowInsets", "()Landroidx/compose/ui/modifier/ProvidableModifierLocal;", "consumeWindowInsets", "Landroidx/compose/ui/Modifier;", "paddingValues", "Landroidx/compose/foundation/layout/PaddingValues;", "insets", "onConsumedWindowInsetsChanged", "block", "Lkotlin/Function1;", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "consumedWindowInsets", "", "windowInsetsPadding", "foundation-layout_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class WindowInsetsPaddingKt {
    private static final ProvidableModifierLocal<WindowInsets> ModifierLocalConsumedWindowInsets = ModifierLocalKt.modifierLocalOf(new Function0<WindowInsets>() {
        public final WindowInsets m1110invoke() {
            return WindowInsetsKt.WindowInsets(0, 0, 0, 0);
        }
    });

    public static final ProvidableModifierLocal<WindowInsets> getModifierLocalConsumedWindowInsets() {
        return ModifierLocalConsumedWindowInsets;
    }

    public static final Modifier windowInsetsPadding(Modifier modifier, final WindowInsets windowInsets) {
        return ComposedModifierKt.composed(modifier, InspectableValueKt.isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((InspectorInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(InspectorInfo inspectorInfo) {
                inspectorInfo.setName("windowInsetsPadding");
                inspectorInfo.getProperties().set("insets", windowInsets);
            }
        } : InspectableValueKt.getNoInspectorInfo(), new Function3<Modifier, Composer, Integer, Modifier>() {
            {
                super(3);
            }

            public Object invoke(Object obj, Object obj2, Object obj3) {
                return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
            }

            public final Modifier invoke(Modifier modifier2, Composer composer, int i) {
                composer.startReplaceGroup(-1415685722);
                ComposerKt.sourceInformation(composer, "C61@2466L50:WindowInsetsPadding.kt#2w3rfo");
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1415685722, i, -1, "androidx.compose.foundation.layout.windowInsetsPadding.<anonymous> (WindowInsetsPadding.kt:61)");
                }
                ComposerKt.sourceInformationMarkerStart(composer, -324934766, "CC(remember):WindowInsetsPadding.kt#9igjgp");
                boolean zChanged = composer.changed(windowInsets);
                WindowInsets windowInsets2 = windowInsets;
                Object objRememberedValue = composer.rememberedValue();
                if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = new InsetsPaddingModifier(windowInsets2);
                    composer.updateRememberedValue(objRememberedValue);
                }
                InsetsPaddingModifier insetsPaddingModifier = (InsetsPaddingModifier) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composer);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                composer.endReplaceGroup();
                return insetsPaddingModifier;
            }
        });
    }

    public static final Modifier consumeWindowInsets(Modifier modifier, final WindowInsets windowInsets) {
        return ComposedModifierKt.composed(modifier, InspectableValueKt.isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((InspectorInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(InspectorInfo inspectorInfo) {
                inspectorInfo.setName("consumeWindowInsets");
                inspectorInfo.getProperties().set("insets", windowInsets);
            }
        } : InspectableValueKt.getNoInspectorInfo(), new Function3<Modifier, Composer, Integer, Modifier>() {
            {
                super(3);
            }

            public Object invoke(Object obj, Object obj2, Object obj3) {
                return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
            }

            public final Modifier invoke(Modifier modifier2, Composer composer, int i) {
                composer.startReplaceGroup(788931215);
                ComposerKt.sourceInformation(composer, "C81@3188L57:WindowInsetsPadding.kt#2w3rfo");
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(788931215, i, -1, "androidx.compose.foundation.layout.consumeWindowInsets.<anonymous> (WindowInsetsPadding.kt:81)");
                }
                ComposerKt.sourceInformationMarkerStart(composer, -261086064, "CC(remember):WindowInsetsPadding.kt#9igjgp");
                boolean zChanged = composer.changed(windowInsets);
                WindowInsets windowInsets2 = windowInsets;
                Object objRememberedValue = composer.rememberedValue();
                if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = new UnionInsetsConsumingModifier(windowInsets2);
                    composer.updateRememberedValue(objRememberedValue);
                }
                UnionInsetsConsumingModifier unionInsetsConsumingModifier = (UnionInsetsConsumingModifier) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composer);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                composer.endReplaceGroup();
                return unionInsetsConsumingModifier;
            }
        });
    }

    public static final Modifier consumeWindowInsets(Modifier modifier, final PaddingValues paddingValues) {
        return ComposedModifierKt.composed(modifier, InspectableValueKt.isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((InspectorInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(InspectorInfo inspectorInfo) {
                inspectorInfo.setName("consumeWindowInsets");
                inspectorInfo.getProperties().set("paddingValues", paddingValues);
            }
        } : InspectableValueKt.getNoInspectorInfo(), new Function3<Modifier, Composer, Integer, Modifier>() {
            {
                super(3);
            }

            public Object invoke(Object obj, Object obj2, Object obj3) {
                return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
            }

            public final Modifier invoke(Modifier modifier2, Composer composer, int i) {
                composer.startReplaceGroup(114694318);
                ComposerKt.sourceInformation(composer, "C105@4277L85:WindowInsetsPadding.kt#2w3rfo");
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(114694318, i, -1, "androidx.compose.foundation.layout.consumeWindowInsets.<anonymous> (WindowInsetsPadding.kt:105)");
                }
                ComposerKt.sourceInformationMarkerStart(composer, -261051188, "CC(remember):WindowInsetsPadding.kt#9igjgp");
                boolean zChanged = composer.changed(paddingValues);
                PaddingValues paddingValues2 = paddingValues;
                Object objRememberedValue = composer.rememberedValue();
                if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = new PaddingValuesConsumingModifier(paddingValues2);
                    composer.updateRememberedValue(objRememberedValue);
                }
                PaddingValuesConsumingModifier paddingValuesConsumingModifier = (PaddingValuesConsumingModifier) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composer);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                composer.endReplaceGroup();
                return paddingValuesConsumingModifier;
            }
        });
    }

    public static final Modifier onConsumedWindowInsetsChanged(Modifier modifier, final Function1<? super WindowInsets, Unit> function1) {
        return ComposedModifierKt.composed(modifier, InspectableValueKt.isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((InspectorInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(InspectorInfo inspectorInfo) {
                inspectorInfo.setName("onConsumedWindowInsetsChanged");
                inspectorInfo.getProperties().set("block", function1);
            }
        } : InspectableValueKt.getNoInspectorInfo(), new Function3<Modifier, Composer, Integer, Modifier>() {
            {
                super(3);
            }

            public Object invoke(Object obj, Object obj2, Object obj3) {
                return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
            }

            public final Modifier invoke(Modifier modifier2, Composer composer, int i) {
                composer.startReplaceGroup(-1608161351);
                ComposerKt.sourceInformation(composer, "C125@4856L61:WindowInsetsPadding.kt#2w3rfo");
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1608161351, i, -1, "androidx.compose.foundation.layout.onConsumedWindowInsetsChanged.<anonymous> (WindowInsetsPadding.kt:125)");
                }
                ComposerKt.sourceInformationMarkerStart(composer, 16130585, "CC(remember):WindowInsetsPadding.kt#9igjgp");
                boolean zChanged = composer.changed(function1);
                Function1<WindowInsets, Unit> function2 = function1;
                Object objRememberedValue = composer.rememberedValue();
                if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = new ConsumedInsetsModifier(function2);
                    composer.updateRememberedValue(objRememberedValue);
                }
                ConsumedInsetsModifier consumedInsetsModifier = (ConsumedInsetsModifier) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composer);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                composer.endReplaceGroup();
                return consumedInsetsModifier;
            }
        });
    }
}
