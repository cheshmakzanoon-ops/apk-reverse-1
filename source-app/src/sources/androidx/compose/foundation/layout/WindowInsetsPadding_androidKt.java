package androidx.compose.foundation.layout;

import androidx.compose.p002ui.ComposedModifierKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.platform.InspectableValueKt;
import androidx.compose.p002ui.platform.InspectorInfo;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function3;

@Metadata(d1 = {"\u0000&\n\u0000\n\u0002\u0018\u0002\n\u0002\b\r\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\u001a\n\u0010\u0000\u001a\u00020\u0001*\u00020\u0001\u001a\n\u0010\u0002\u001a\u00020\u0001*\u00020\u0001\u001a\n\u0010\u0003\u001a\u00020\u0001*\u00020\u0001\u001a\n\u0010\u0004\u001a\u00020\u0001*\u00020\u0001\u001a\n\u0010\u0005\u001a\u00020\u0001*\u00020\u0001\u001a\n\u0010\u0006\u001a\u00020\u0001*\u00020\u0001\u001a\n\u0010\u0007\u001a\u00020\u0001*\u00020\u0001\u001a\n\u0010\b\u001a\u00020\u0001*\u00020\u0001\u001a\n\u0010\t\u001a\u00020\u0001*\u00020\u0001\u001a\n\u0010\n\u001a\u00020\u0001*\u00020\u0001\u001a\n\u0010\u000b\u001a\u00020\u0001*\u00020\u0001\u001a\n\u0010\f\u001a\u00020\u0001*\u00020\u0001\u001aC\u0010\r\u001a\u00020\u0001*\u00020\u00012\u0019\b\b\u0010\u000e\u001a\u0013\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\u00110\u000f¢\u0006\u0002\b\u00122\u0019\b\u0004\u0010\u0013\u001a\u0013\u0012\u0004\u0012\u00020\u0014\u0012\u0004\u0012\u00020\u00150\u000f¢\u0006\u0002\b\u0012H\u0083\b¨\u0006\u0016"}, d2 = {"captionBarPadding", "Landroidx/compose/ui/Modifier;", "displayCutoutPadding", "imePadding", "mandatorySystemGesturesPadding", "navigationBarsPadding", "safeContentPadding", "safeDrawingPadding", "safeGesturesPadding", "statusBarsPadding", "systemBarsPadding", "systemGesturesPadding", "waterfallPadding", "windowInsetsPadding", "inspectorInfo", "Lkotlin/Function1;", "Landroidx/compose/ui/platform/InspectorInfo;", "", "Lkotlin/ExtensionFunctionType;", "insetsCalculation", "Landroidx/compose/foundation/layout/WindowInsetsHolder;", "Landroidx/compose/foundation/layout/WindowInsets;", "foundation-layout_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class WindowInsetsPadding_androidKt {
    private static final Modifier windowInsetsPadding(Modifier modifier, Function1<? super InspectorInfo, Unit> function1, final Function1<? super WindowInsetsHolder, ? extends WindowInsets> function2) {
        return ComposedModifierKt.composed(modifier, function1, new Function3<Modifier, Composer, Integer, Modifier>() {
            {
                super(3);
            }

            public Object invoke(Object obj, Object obj2, Object obj3) {
                return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
            }

            public final Modifier invoke(Modifier modifier2, Composer composer, int i) {
                composer.startReplaceGroup(359872873);
                ComposerKt.sourceInformation(composer, "C249@11425L9,250@11439L124:WindowInsetsPadding.android.kt#2w3rfo");
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(359872873, i, -1, "androidx.compose.foundation.layout.windowInsetsPadding.<anonymous> (WindowInsetsPadding.android.kt:249)");
                }
                WindowInsetsHolder windowInsetsHolderCurrent = WindowInsetsHolder.INSTANCE.current(composer, 6);
                ComposerKt.sourceInformationMarkerStart(composer, -324647556, "CC(remember):WindowInsetsPadding.android.kt#9igjgp");
                boolean zChanged = composer.changed(windowInsetsHolderCurrent);
                Function1<WindowInsetsHolder, WindowInsets> function3 = function2;
                Object objRememberedValue = composer.rememberedValue();
                if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = new InsetsPaddingModifier((WindowInsets) function3.invoke(windowInsetsHolderCurrent));
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

    public static final Modifier safeDrawingPadding(Modifier modifier) {
        return ComposedModifierKt.composed(modifier, InspectableValueKt.isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
            public Object invoke(Object obj) {
                invoke((InspectorInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(InspectorInfo inspectorInfo) {
                inspectorInfo.setName("safeDrawingPadding");
            }
        } : InspectableValueKt.getNoInspectorInfo(), new Function3<Modifier, Composer, Integer, Modifier>() {
            public Object invoke(Object obj, Object obj2, Object obj3) {
                return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
            }

            public final Modifier invoke(Modifier modifier2, Composer composer, int i) {
                composer.startReplaceGroup(359872873);
                ComposerKt.sourceInformation(composer, "C249@11425L9,250@11439L124:WindowInsetsPadding.android.kt#2w3rfo");
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(359872873, i, -1, "androidx.compose.foundation.layout.windowInsetsPadding.<anonymous> (WindowInsetsPadding.android.kt:249)");
                }
                WindowInsetsHolder windowInsetsHolderCurrent = WindowInsetsHolder.INSTANCE.current(composer, 6);
                ComposerKt.sourceInformationMarkerStart(composer, -324647556, "CC(remember):WindowInsetsPadding.android.kt#9igjgp");
                boolean zChanged = composer.changed(windowInsetsHolderCurrent);
                Object objRememberedValue = composer.rememberedValue();
                if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = new InsetsPaddingModifier(windowInsetsHolderCurrent.getSafeDrawing());
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

    public static final Modifier safeGesturesPadding(Modifier modifier) {
        return ComposedModifierKt.composed(modifier, InspectableValueKt.isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
            public Object invoke(Object obj) {
                invoke((InspectorInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(InspectorInfo inspectorInfo) {
                inspectorInfo.setName("safeGesturesPadding");
            }
        } : InspectableValueKt.getNoInspectorInfo(), new Function3<Modifier, Composer, Integer, Modifier>() {
            public Object invoke(Object obj, Object obj2, Object obj3) {
                return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
            }

            public final Modifier invoke(Modifier modifier2, Composer composer, int i) {
                composer.startReplaceGroup(359872873);
                ComposerKt.sourceInformation(composer, "C249@11425L9,250@11439L124:WindowInsetsPadding.android.kt#2w3rfo");
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(359872873, i, -1, "androidx.compose.foundation.layout.windowInsetsPadding.<anonymous> (WindowInsetsPadding.android.kt:249)");
                }
                WindowInsetsHolder windowInsetsHolderCurrent = WindowInsetsHolder.INSTANCE.current(composer, 6);
                ComposerKt.sourceInformationMarkerStart(composer, -324647556, "CC(remember):WindowInsetsPadding.android.kt#9igjgp");
                boolean zChanged = composer.changed(windowInsetsHolderCurrent);
                Object objRememberedValue = composer.rememberedValue();
                if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = new InsetsPaddingModifier(windowInsetsHolderCurrent.getSafeGestures());
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

    public static final Modifier safeContentPadding(Modifier modifier) {
        return ComposedModifierKt.composed(modifier, InspectableValueKt.isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
            public Object invoke(Object obj) {
                invoke((InspectorInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(InspectorInfo inspectorInfo) {
                inspectorInfo.setName("safeContentPadding");
            }
        } : InspectableValueKt.getNoInspectorInfo(), new Function3<Modifier, Composer, Integer, Modifier>() {
            public Object invoke(Object obj, Object obj2, Object obj3) {
                return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
            }

            public final Modifier invoke(Modifier modifier2, Composer composer, int i) {
                composer.startReplaceGroup(359872873);
                ComposerKt.sourceInformation(composer, "C249@11425L9,250@11439L124:WindowInsetsPadding.android.kt#2w3rfo");
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(359872873, i, -1, "androidx.compose.foundation.layout.windowInsetsPadding.<anonymous> (WindowInsetsPadding.android.kt:249)");
                }
                WindowInsetsHolder windowInsetsHolderCurrent = WindowInsetsHolder.INSTANCE.current(composer, 6);
                ComposerKt.sourceInformationMarkerStart(composer, -324647556, "CC(remember):WindowInsetsPadding.android.kt#9igjgp");
                boolean zChanged = composer.changed(windowInsetsHolderCurrent);
                Object objRememberedValue = composer.rememberedValue();
                if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = new InsetsPaddingModifier(windowInsetsHolderCurrent.getSafeContent());
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

    public static final Modifier systemBarsPadding(Modifier modifier) {
        return ComposedModifierKt.composed(modifier, InspectableValueKt.isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
            public Object invoke(Object obj) {
                invoke((InspectorInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(InspectorInfo inspectorInfo) {
                inspectorInfo.setName("systemBarsPadding");
            }
        } : InspectableValueKt.getNoInspectorInfo(), new Function3<Modifier, Composer, Integer, Modifier>() {
            public Object invoke(Object obj, Object obj2, Object obj3) {
                return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
            }

            public final Modifier invoke(Modifier modifier2, Composer composer, int i) {
                composer.startReplaceGroup(359872873);
                ComposerKt.sourceInformation(composer, "C249@11425L9,250@11439L124:WindowInsetsPadding.android.kt#2w3rfo");
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(359872873, i, -1, "androidx.compose.foundation.layout.windowInsetsPadding.<anonymous> (WindowInsetsPadding.android.kt:249)");
                }
                WindowInsetsHolder windowInsetsHolderCurrent = WindowInsetsHolder.INSTANCE.current(composer, 6);
                ComposerKt.sourceInformationMarkerStart(composer, -324647556, "CC(remember):WindowInsetsPadding.android.kt#9igjgp");
                boolean zChanged = composer.changed(windowInsetsHolderCurrent);
                Object objRememberedValue = composer.rememberedValue();
                if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = new InsetsPaddingModifier(windowInsetsHolderCurrent.getSystemBars());
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

    public static final Modifier displayCutoutPadding(Modifier modifier) {
        return ComposedModifierKt.composed(modifier, InspectableValueKt.isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
            public Object invoke(Object obj) {
                invoke((InspectorInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(InspectorInfo inspectorInfo) {
                inspectorInfo.setName("displayCutoutPadding");
            }
        } : InspectableValueKt.getNoInspectorInfo(), new Function3<Modifier, Composer, Integer, Modifier>() {
            public Object invoke(Object obj, Object obj2, Object obj3) {
                return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
            }

            public final Modifier invoke(Modifier modifier2, Composer composer, int i) {
                composer.startReplaceGroup(359872873);
                ComposerKt.sourceInformation(composer, "C249@11425L9,250@11439L124:WindowInsetsPadding.android.kt#2w3rfo");
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(359872873, i, -1, "androidx.compose.foundation.layout.windowInsetsPadding.<anonymous> (WindowInsetsPadding.android.kt:249)");
                }
                WindowInsetsHolder windowInsetsHolderCurrent = WindowInsetsHolder.INSTANCE.current(composer, 6);
                ComposerKt.sourceInformationMarkerStart(composer, -324647556, "CC(remember):WindowInsetsPadding.android.kt#9igjgp");
                boolean zChanged = composer.changed(windowInsetsHolderCurrent);
                Object objRememberedValue = composer.rememberedValue();
                if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = new InsetsPaddingModifier(windowInsetsHolderCurrent.getDisplayCutout());
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

    public static final Modifier statusBarsPadding(Modifier modifier) {
        return ComposedModifierKt.composed(modifier, InspectableValueKt.isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
            public Object invoke(Object obj) {
                invoke((InspectorInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(InspectorInfo inspectorInfo) {
                inspectorInfo.setName("statusBarsPadding");
            }
        } : InspectableValueKt.getNoInspectorInfo(), new Function3<Modifier, Composer, Integer, Modifier>() {
            public Object invoke(Object obj, Object obj2, Object obj3) {
                return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
            }

            public final Modifier invoke(Modifier modifier2, Composer composer, int i) {
                composer.startReplaceGroup(359872873);
                ComposerKt.sourceInformation(composer, "C249@11425L9,250@11439L124:WindowInsetsPadding.android.kt#2w3rfo");
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(359872873, i, -1, "androidx.compose.foundation.layout.windowInsetsPadding.<anonymous> (WindowInsetsPadding.android.kt:249)");
                }
                WindowInsetsHolder windowInsetsHolderCurrent = WindowInsetsHolder.INSTANCE.current(composer, 6);
                ComposerKt.sourceInformationMarkerStart(composer, -324647556, "CC(remember):WindowInsetsPadding.android.kt#9igjgp");
                boolean zChanged = composer.changed(windowInsetsHolderCurrent);
                Object objRememberedValue = composer.rememberedValue();
                if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = new InsetsPaddingModifier(windowInsetsHolderCurrent.getStatusBars());
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

    public static final Modifier imePadding(Modifier modifier) {
        return ComposedModifierKt.composed(modifier, InspectableValueKt.isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
            public Object invoke(Object obj) {
                invoke((InspectorInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(InspectorInfo inspectorInfo) {
                inspectorInfo.setName("imePadding");
            }
        } : InspectableValueKt.getNoInspectorInfo(), new Function3<Modifier, Composer, Integer, Modifier>() {
            public Object invoke(Object obj, Object obj2, Object obj3) {
                return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
            }

            public final Modifier invoke(Modifier modifier2, Composer composer, int i) {
                composer.startReplaceGroup(359872873);
                ComposerKt.sourceInformation(composer, "C249@11425L9,250@11439L124:WindowInsetsPadding.android.kt#2w3rfo");
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(359872873, i, -1, "androidx.compose.foundation.layout.windowInsetsPadding.<anonymous> (WindowInsetsPadding.android.kt:249)");
                }
                WindowInsetsHolder windowInsetsHolderCurrent = WindowInsetsHolder.INSTANCE.current(composer, 6);
                ComposerKt.sourceInformationMarkerStart(composer, -324647556, "CC(remember):WindowInsetsPadding.android.kt#9igjgp");
                boolean zChanged = composer.changed(windowInsetsHolderCurrent);
                Object objRememberedValue = composer.rememberedValue();
                if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = new InsetsPaddingModifier(windowInsetsHolderCurrent.getIme());
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

    public static final Modifier navigationBarsPadding(Modifier modifier) {
        return ComposedModifierKt.composed(modifier, InspectableValueKt.isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
            public Object invoke(Object obj) {
                invoke((InspectorInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(InspectorInfo inspectorInfo) {
                inspectorInfo.setName("navigationBarsPadding");
            }
        } : InspectableValueKt.getNoInspectorInfo(), new Function3<Modifier, Composer, Integer, Modifier>() {
            public Object invoke(Object obj, Object obj2, Object obj3) {
                return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
            }

            public final Modifier invoke(Modifier modifier2, Composer composer, int i) {
                composer.startReplaceGroup(359872873);
                ComposerKt.sourceInformation(composer, "C249@11425L9,250@11439L124:WindowInsetsPadding.android.kt#2w3rfo");
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(359872873, i, -1, "androidx.compose.foundation.layout.windowInsetsPadding.<anonymous> (WindowInsetsPadding.android.kt:249)");
                }
                WindowInsetsHolder windowInsetsHolderCurrent = WindowInsetsHolder.INSTANCE.current(composer, 6);
                ComposerKt.sourceInformationMarkerStart(composer, -324647556, "CC(remember):WindowInsetsPadding.android.kt#9igjgp");
                boolean zChanged = composer.changed(windowInsetsHolderCurrent);
                Object objRememberedValue = composer.rememberedValue();
                if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = new InsetsPaddingModifier(windowInsetsHolderCurrent.getNavigationBars());
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

    public static final Modifier captionBarPadding(Modifier modifier) {
        return ComposedModifierKt.composed(modifier, InspectableValueKt.isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
            public Object invoke(Object obj) {
                invoke((InspectorInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(InspectorInfo inspectorInfo) {
                inspectorInfo.setName("captionBarPadding");
            }
        } : InspectableValueKt.getNoInspectorInfo(), new Function3<Modifier, Composer, Integer, Modifier>() {
            public Object invoke(Object obj, Object obj2, Object obj3) {
                return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
            }

            public final Modifier invoke(Modifier modifier2, Composer composer, int i) {
                composer.startReplaceGroup(359872873);
                ComposerKt.sourceInformation(composer, "C249@11425L9,250@11439L124:WindowInsetsPadding.android.kt#2w3rfo");
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(359872873, i, -1, "androidx.compose.foundation.layout.windowInsetsPadding.<anonymous> (WindowInsetsPadding.android.kt:249)");
                }
                WindowInsetsHolder windowInsetsHolderCurrent = WindowInsetsHolder.INSTANCE.current(composer, 6);
                ComposerKt.sourceInformationMarkerStart(composer, -324647556, "CC(remember):WindowInsetsPadding.android.kt#9igjgp");
                boolean zChanged = composer.changed(windowInsetsHolderCurrent);
                Object objRememberedValue = composer.rememberedValue();
                if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = new InsetsPaddingModifier(windowInsetsHolderCurrent.getCaptionBar());
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

    public static final Modifier waterfallPadding(Modifier modifier) {
        return ComposedModifierKt.composed(modifier, InspectableValueKt.isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
            public Object invoke(Object obj) {
                invoke((InspectorInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(InspectorInfo inspectorInfo) {
                inspectorInfo.setName("waterfallPadding");
            }
        } : InspectableValueKt.getNoInspectorInfo(), new Function3<Modifier, Composer, Integer, Modifier>() {
            public Object invoke(Object obj, Object obj2, Object obj3) {
                return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
            }

            public final Modifier invoke(Modifier modifier2, Composer composer, int i) {
                composer.startReplaceGroup(359872873);
                ComposerKt.sourceInformation(composer, "C249@11425L9,250@11439L124:WindowInsetsPadding.android.kt#2w3rfo");
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(359872873, i, -1, "androidx.compose.foundation.layout.windowInsetsPadding.<anonymous> (WindowInsetsPadding.android.kt:249)");
                }
                WindowInsetsHolder windowInsetsHolderCurrent = WindowInsetsHolder.INSTANCE.current(composer, 6);
                ComposerKt.sourceInformationMarkerStart(composer, -324647556, "CC(remember):WindowInsetsPadding.android.kt#9igjgp");
                boolean zChanged = composer.changed(windowInsetsHolderCurrent);
                Object objRememberedValue = composer.rememberedValue();
                if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = new InsetsPaddingModifier(windowInsetsHolderCurrent.getWaterfall());
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

    public static final Modifier systemGesturesPadding(Modifier modifier) {
        return ComposedModifierKt.composed(modifier, InspectableValueKt.isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
            public Object invoke(Object obj) {
                invoke((InspectorInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(InspectorInfo inspectorInfo) {
                inspectorInfo.setName("systemGesturesPadding");
            }
        } : InspectableValueKt.getNoInspectorInfo(), new Function3<Modifier, Composer, Integer, Modifier>() {
            public Object invoke(Object obj, Object obj2, Object obj3) {
                return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
            }

            public final Modifier invoke(Modifier modifier2, Composer composer, int i) {
                composer.startReplaceGroup(359872873);
                ComposerKt.sourceInformation(composer, "C249@11425L9,250@11439L124:WindowInsetsPadding.android.kt#2w3rfo");
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(359872873, i, -1, "androidx.compose.foundation.layout.windowInsetsPadding.<anonymous> (WindowInsetsPadding.android.kt:249)");
                }
                WindowInsetsHolder windowInsetsHolderCurrent = WindowInsetsHolder.INSTANCE.current(composer, 6);
                ComposerKt.sourceInformationMarkerStart(composer, -324647556, "CC(remember):WindowInsetsPadding.android.kt#9igjgp");
                boolean zChanged = composer.changed(windowInsetsHolderCurrent);
                Object objRememberedValue = composer.rememberedValue();
                if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = new InsetsPaddingModifier(windowInsetsHolderCurrent.getSystemGestures());
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

    public static final Modifier mandatorySystemGesturesPadding(Modifier modifier) {
        return ComposedModifierKt.composed(modifier, InspectableValueKt.isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
            public Object invoke(Object obj) {
                invoke((InspectorInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(InspectorInfo inspectorInfo) {
                inspectorInfo.setName("mandatorySystemGesturesPadding");
            }
        } : InspectableValueKt.getNoInspectorInfo(), new Function3<Modifier, Composer, Integer, Modifier>() {
            public Object invoke(Object obj, Object obj2, Object obj3) {
                return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
            }

            public final Modifier invoke(Modifier modifier2, Composer composer, int i) {
                composer.startReplaceGroup(359872873);
                ComposerKt.sourceInformation(composer, "C249@11425L9,250@11439L124:WindowInsetsPadding.android.kt#2w3rfo");
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(359872873, i, -1, "androidx.compose.foundation.layout.windowInsetsPadding.<anonymous> (WindowInsetsPadding.android.kt:249)");
                }
                WindowInsetsHolder windowInsetsHolderCurrent = WindowInsetsHolder.INSTANCE.current(composer, 6);
                ComposerKt.sourceInformationMarkerStart(composer, -324647556, "CC(remember):WindowInsetsPadding.android.kt#9igjgp");
                boolean zChanged = composer.changed(windowInsetsHolderCurrent);
                Object objRememberedValue = composer.rememberedValue();
                if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = new InsetsPaddingModifier(windowInsetsHolderCurrent.getMandatorySystemGestures());
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
}
