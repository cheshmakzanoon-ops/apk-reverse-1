package androidx.compose.material3;

import androidx.compose.foundation.layout.Arrangement;
import androidx.compose.foundation.layout.BoxKt;
import androidx.compose.foundation.layout.BoxScopeInstance;
import androidx.compose.foundation.layout.ColumnKt;
import androidx.compose.foundation.layout.ColumnScope;
import androidx.compose.foundation.layout.ColumnScopeInstance;
import androidx.compose.foundation.layout.PaddingKt;
import androidx.compose.foundation.layout.PaddingValues;
import androidx.compose.foundation.layout.SizeKt;
import androidx.compose.material3.internal.ProvideContentColorTextStyleKt;
import androidx.compose.material3.tokens.DatePickerModalTokens;
import androidx.compose.material3.tokens.DialogTokens;
import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.ComposedModifierKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.Shape;
import androidx.compose.p002ui.layout.MeasurePolicy;
import androidx.compose.p002ui.node.ComposeUiNode;
import androidx.compose.runtime.Applier;
import androidx.compose.runtime.ComposablesKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocalMap;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.Updater;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.ui.unit.Dp;
import androidx.compose.ui.window.DialogProperties;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000N\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\u001a\u009a\u0001\u0010\u0006\u001a\u00020\u00072\f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00070\t2\u0011\u0010\n\u001a\r\u0012\u0004\u0012\u00020\u00070\t¢\u0006\u0002\b\u000b2\b\b\u0002\u0010\f\u001a\u00020\r2\u0015\b\u0002\u0010\u000e\u001a\u000f\u0012\u0004\u0012\u00020\u0007\u0018\u00010\t¢\u0006\u0002\b\u000b2\b\b\u0002\u0010\u000f\u001a\u00020\u00102\b\b\u0002\u0010\u0011\u001a\u00020\u00012\b\b\u0002\u0010\u0012\u001a\u00020\u00132\b\b\u0002\u0010\u0014\u001a\u00020\u00152\u001c\u0010\u0016\u001a\u0018\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020\u00070\u0017¢\u0006\u0002\b\u000b¢\u0006\u0002\b\u0019H\u0007ø\u0001\u0000¢\u0006\u0004\b\u001a\u0010\u001b\"\u0010\u0010\u0000\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0002\"\u0010\u0010\u0003\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0002\"\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u001c"}, d2 = {"DialogButtonsCrossAxisSpacing", "Landroidx/compose/ui/unit/Dp;", "F", "DialogButtonsMainAxisSpacing", "DialogButtonsPadding", "Landroidx/compose/foundation/layout/PaddingValues;", "DatePickerDialog", "", "onDismissRequest", "Lkotlin/Function0;", "confirmButton", "Landroidx/compose/runtime/Composable;", "modifier", "Landroidx/compose/ui/Modifier;", "dismissButton", "shape", "Landroidx/compose/ui/graphics/Shape;", "tonalElevation", "colors", "Landroidx/compose/material3/DatePickerColors;", "properties", "Landroidx/compose/ui/window/DialogProperties;", "content", "Lkotlin/Function1;", "Landroidx/compose/foundation/layout/ColumnScope;", "Lkotlin/ExtensionFunctionType;", "DatePickerDialog-GmEhDVc", "(Lkotlin/jvm/functions/Function0;Lkotlin/jvm/functions/Function2;Landroidx/compose/ui/Modifier;Lkotlin/jvm/functions/Function2;Landroidx/compose/ui/graphics/Shape;FLandroidx/compose/material3/DatePickerColors;Landroidx/compose/ui/window/DialogProperties;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "material3_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class DatePickerDialog_androidKt {
    private static final float DialogButtonsCrossAxisSpacing = Dp.constructor-impl(12);
    private static final float DialogButtonsMainAxisSpacing;
    private static final PaddingValues DialogButtonsPadding;

    public static final void m2273DatePickerDialogGmEhDVc(final Function0<Unit> function0, final Function2<? super Composer, ? super Integer, Unit> function2, Modifier modifier, Function2<? super Composer, ? super Integer, Unit> function3, Shape shape, float f, DatePickerColors datePickerColors, DialogProperties dialogProperties, final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function4, Composer composer, final int i, final int i2) {
        int i3;
        int i4;
        Function2<? super Composer, ? super Integer, Unit> function5;
        int i5;
        Shape shape2;
        int i6;
        float fM2272getTonalElevationD9Ej5fM;
        int i7;
        DatePickerColors datePickerColorsColors;
        int i8;
        int i9;
        int i10;
        Modifier.Companion companion;
        DialogProperties dialogProperties2;
        final Modifier modifier2;
        final Function2<? super Composer, ? super Integer, Unit> function6;
        final Shape shape3;
        final float f2;
        final DatePickerColors datePickerColors2;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i11;
        Composer composerStartRestartGroup = composer.startRestartGroup(-36517340);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(DatePickerDialog)P(5,1,4,3,7,8:c#ui.unit.Dp!1,6)71@3518L5,73@3635L8,81@3937L1615,77@3787L1765:DatePickerDialog.android.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changedInstance(function0) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        if ((i2 & 2) != 0) {
            i3 |= 48;
        } else if ((i & 48) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function2) ? 32 : 16;
        }
        int i12 = i2 & 4;
        if (i12 == 0) {
            if ((i & 384) == 0) {
                i3 |= composerStartRestartGroup.changed(modifier) ? Fields.RotationX : Fields.SpotShadowColor;
            }
            i4 = i2 & 8;
            if (i4 != 0) {
                if ((i & 3072) == 0) {
                    function5 = function3;
                    if (composerStartRestartGroup.changedInstance(function5)) {
                        i5 = Fields.CameraDistance;
                    } else {
                        i5 = Fields.RotationZ;
                    }
                    i3 |= i5;
                }
                if ((i & 24576) == 0) {
                    if ((i2 & 16) == 0) {
                        shape2 = shape;
                        if (composerStartRestartGroup.changed(shape2)) {
                            i11 = Fields.Clip;
                        }
                        i3 |= i11;
                    } else {
                        shape2 = shape;
                    }
                    i11 = Fields.Shape;
                    i3 |= i11;
                } else {
                    shape2 = shape;
                }
                i6 = i2 & 32;
                if (i6 != 0) {
                    if ((196608 & i) == 0) {
                        fM2272getTonalElevationD9Ej5fM = f;
                        if (composerStartRestartGroup.changed(fM2272getTonalElevationD9Ej5fM)) {
                            i7 = Fields.RenderEffect;
                        } else {
                            i7 = 65536;
                        }
                        i3 |= i7;
                    }
                    if ((1572864 & i) == 0) {
                        if ((i2 & 64) == 0) {
                            datePickerColorsColors = datePickerColors;
                            int i13 = composerStartRestartGroup.changed(datePickerColorsColors) ? 1048576 : 524288;
                            i3 |= i13;
                        } else {
                            datePickerColorsColors = datePickerColors;
                        }
                        i3 |= i13;
                    } else {
                        datePickerColorsColors = datePickerColors;
                    }
                    i8 = i2 & Fields.SpotShadowColor;
                    if (i8 != 0) {
                        i3 |= 12582912;
                    } else if ((i & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(dialogProperties)) {
                            i9 = 8388608;
                        } else {
                            i9 = 4194304;
                        }
                        i3 |= i9;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        if ((i & 100663296) == 0) {
                            if (composerStartRestartGroup.changedInstance(function4)) {
                                i10 = 67108864;
                            } else {
                                i10 = 33554432;
                            }
                            i3 |= i10;
                        }
                        if ((i3 & 38347923) == 38347922 || !composerStartRestartGroup.getSkipping()) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) == 0 && !composerStartRestartGroup.getDefaultsInvalid()) {
                                composerStartRestartGroup.skipToGroupEnd();
                                if ((i2 & 16) != 0) {
                                    i3 &= -57345;
                                }
                                if ((i2 & 64) != 0) {
                                    i3 &= -3670017;
                                }
                                companion = modifier;
                            } else {
                                if (i12 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i4 != 0) {
                                    function5 = null;
                                }
                                if ((i2 & 16) != 0) {
                                    i3 &= -57345;
                                    shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                                }
                                if (i6 != 0) {
                                    fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                                }
                                if ((i2 & 64) != 0) {
                                    i3 &= -3670017;
                                    datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                                }
                                if (i8 != 0) {
                                    dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                                }
                                final Function2<? super Composer, ? super Integer, Unit> function7 = function5;
                                final Shape shape4 = shape2;
                                final float f3 = fM2272getTonalElevationD9Ej5fM;
                                final DatePickerColors datePickerColors3 = datePickerColorsColors;
                                composerStartRestartGroup.endDefaults();
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                                }
                                AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i14) {
                                        ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                                        if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                                            }
                                            Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                                            Shape shape5 = shape4;
                                            long containerColor = datePickerColors3.getContainerColor();
                                            float f4 = f3;
                                            final Function3<ColumnScope, Composer, Integer, Unit> function8 = function4;
                                            final Function2<Composer, Integer, Unit> function9 = function7;
                                            final Function2<Composer, Integer, Unit> function10 = function2;
                                            SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape5, containerColor, 0L, f4, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                                {
                                                    super(2);
                                                }

                                                public Object invoke(Object obj, Object obj2) {
                                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                                    return Unit.INSTANCE;
                                                }

                                                public final void invoke(Composer composer3, int i15) {
                                                    ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                                    if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                                        if (ComposerKt.isTraceInProgress()) {
                                                            ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                                        }
                                                        Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                                        Function3<ColumnScope, Composer, Integer, Unit> function11 = function8;
                                                        final Function2<Composer, Integer, Unit> function12 = function9;
                                                        final Function2<Composer, Integer, Unit> function13 = function10;
                                                        ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                                        Modifier.Companion companion2 = Modifier.INSTANCE;
                                                        MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                        CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                                        Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                        if (!(composer3.getApplier() instanceof Applier)) {
                                                            ComposablesKt.invalidApplier();
                                                        }
                                                        composer3.startReusableNode();
                                                        if (composer3.getInserting()) {
                                                            composer3.createNode(constructor);
                                                        } else {
                                                            composer3.useNode();
                                                        }
                                                        Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                        if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                                        }
                                                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                                        ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                                        ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                                        ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                                        Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                                        ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                        int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                        CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                                        Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                                        Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                        if (!(composer3.getApplier() instanceof Applier)) {
                                                            ComposablesKt.invalidApplier();
                                                        }
                                                        composer3.startReusableNode();
                                                        if (composer3.getInserting()) {
                                                            composer3.createNode(constructor2);
                                                        } else {
                                                            composer3.useNode();
                                                        }
                                                        Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                                        Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                        Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                        if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                            composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                            composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                                        }
                                                        Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                                        ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                                        BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                                        ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                                        function11.invoke(columnScopeInstance, composer3, 6);
                                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                                        composer3.endNode();
                                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                                        Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                                        ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                        int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                        CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                                        Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                                        Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                        if (!(composer3.getApplier() instanceof Applier)) {
                                                            ComposablesKt.invalidApplier();
                                                        }
                                                        composer3.startReusableNode();
                                                        if (composer3.getInserting()) {
                                                            composer3.createNode(constructor3);
                                                        } else {
                                                            composer3.useNode();
                                                        }
                                                        Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                                        Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                        Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                        if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                                            composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                                            composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                                        }
                                                        Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                                        ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                                        BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                                        ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                                        ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                                            {
                                                                super(2);
                                                            }

                                                            public Object invoke(Object obj, Object obj2) {
                                                                invoke((Composer) obj, ((Number) obj2).intValue());
                                                                return Unit.INSTANCE;
                                                            }

                                                            public final void invoke(Composer composer4, int i16) {
                                                                ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                                if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                                    if (ComposerKt.isTraceInProgress()) {
                                                                        ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                                    }
                                                                    float f5 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                                    float f6 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                                    final Function2<Composer, Integer, Unit> function14 = function12;
                                                                    final Function2<Composer, Integer, Unit> function15 = function13;
                                                                    AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f5, f6, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                                        {
                                                                            super(2);
                                                                        }

                                                                        public Object invoke(Object obj, Object obj2) {
                                                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                                                            return Unit.INSTANCE;
                                                                        }

                                                                        public final void invoke(Composer composer5, int i17) {
                                                                            ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                                            if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                                if (ComposerKt.isTraceInProgress()) {
                                                                                    ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                                }
                                                                                Function2<Composer, Integer, Unit> function16 = function14;
                                                                                composer5.startReplaceGroup(-779485335);
                                                                                ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                                if (function16 != null) {
                                                                                    function16.invoke(composer5, 0);
                                                                                    Unit unit = Unit.INSTANCE;
                                                                                }
                                                                                composer5.endReplaceGroup();
                                                                                function15.invoke(composer5, 0);
                                                                                if (ComposerKt.isTraceInProgress()) {
                                                                                    ComposerKt.traceEventEnd();
                                                                                    return;
                                                                                }
                                                                                return;
                                                                            }
                                                                            composer5.skipToGroupEnd();
                                                                        }
                                                                    }, composer4, 54), composer4, 438);
                                                                    if (ComposerKt.isTraceInProgress()) {
                                                                        ComposerKt.traceEventEnd();
                                                                        return;
                                                                    }
                                                                    return;
                                                                }
                                                                composer4.skipToGroupEnd();
                                                            }
                                                        }, composer3, 54), composer3, 384);
                                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                                        composer3.endNode();
                                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                                        composer3.endNode();
                                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                                        if (ComposerKt.isTraceInProgress()) {
                                                            ComposerKt.traceEventEnd();
                                                            return;
                                                        }
                                                        return;
                                                    }
                                                    composer3.skipToGroupEnd();
                                                }
                                            }, composer2, 54), composer2, 12582918, 104);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                                modifier2 = companion;
                                function6 = function7;
                                shape3 = shape4;
                                f2 = f3;
                                datePickerColors2 = datePickerColors3;
                            }
                            dialogProperties2 = dialogProperties;
                            final Function2<? super Composer, ? super Integer, Unit> function8 = function5;
                            final Shape shape5 = shape2;
                            final float f4 = fM2272getTonalElevationD9Ej5fM;
                            final DatePickerColors datePickerColors4 = datePickerColorsColors;
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                            }
                            AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i14) {
                                    ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                                    if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                                        }
                                        Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                                        Shape shape6 = shape5;
                                        long containerColor = datePickerColors4.getContainerColor();
                                        float f5 = f4;
                                        final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function9 = function4;
                                        final Function2<? super Composer, ? super Integer, Unit> function10 = function8;
                                        final Function2<? super Composer, ? super Integer, Unit> function11 = function2;
                                        SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape6, containerColor, 0L, f5, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                            {
                                                super(2);
                                            }

                                            public Object invoke(Object obj, Object obj2) {
                                                invoke((Composer) obj, ((Number) obj2).intValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(Composer composer3, int i15) {
                                                ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                                if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                                    if (ComposerKt.isTraceInProgress()) {
                                                        ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                                    }
                                                    Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                                    Function3<ColumnScope, Composer, Integer, Unit> function12 = function9;
                                                    final Function2<? super Composer, ? super Integer, Unit> function13 = function10;
                                                    final Function2<? super Composer, ? super Integer, Unit> function14 = function11;
                                                    ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                                    Modifier.Companion companion2 = Modifier.INSTANCE;
                                                    MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                                    ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                    CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                                    Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                                    ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                    if (!(composer3.getApplier() instanceof Applier)) {
                                                        ComposablesKt.invalidApplier();
                                                    }
                                                    composer3.startReusableNode();
                                                    if (composer3.getInserting()) {
                                                        composer3.createNode(constructor);
                                                    } else {
                                                        composer3.useNode();
                                                    }
                                                    Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                    if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                                    }
                                                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                                    ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                                    ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                                    ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                                    Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                                    ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                                    ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                    int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                    CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                                    Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                                    Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                                    ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                    if (!(composer3.getApplier() instanceof Applier)) {
                                                        ComposablesKt.invalidApplier();
                                                    }
                                                    composer3.startReusableNode();
                                                    if (composer3.getInserting()) {
                                                        composer3.createNode(constructor2);
                                                    } else {
                                                        composer3.useNode();
                                                    }
                                                    Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                                    Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                    Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                    if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                        composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                        composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                                    }
                                                    Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                                    ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                                    BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                                    ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                                    function12.invoke(columnScopeInstance, composer3, 6);
                                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                                    composer3.endNode();
                                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                                    Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                                    ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                                    ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                    int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                    CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                                    Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                                    Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                                    ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                    if (!(composer3.getApplier() instanceof Applier)) {
                                                        ComposablesKt.invalidApplier();
                                                    }
                                                    composer3.startReusableNode();
                                                    if (composer3.getInserting()) {
                                                        composer3.createNode(constructor3);
                                                    } else {
                                                        composer3.useNode();
                                                    }
                                                    Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                                    Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                    Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                    if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                                        composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                                        composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                                    }
                                                    Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                                    ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                                    BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                                    ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                                    ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                                        {
                                                            super(2);
                                                        }

                                                        public Object invoke(Object obj, Object obj2) {
                                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                                            return Unit.INSTANCE;
                                                        }

                                                        public final void invoke(Composer composer4, int i16) {
                                                            ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                            if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                                if (ComposerKt.isTraceInProgress()) {
                                                                    ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                                }
                                                                float f6 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                                float f7 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                                final Function2<? super Composer, ? super Integer, Unit> function15 = function13;
                                                                final Function2<? super Composer, ? super Integer, Unit> function16 = function14;
                                                                AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f6, f7, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                                    {
                                                                        super(2);
                                                                    }

                                                                    public Object invoke(Object obj, Object obj2) {
                                                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                                                        return Unit.INSTANCE;
                                                                    }

                                                                    public final void invoke(Composer composer5, int i17) {
                                                                        ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                                        if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                            if (ComposerKt.isTraceInProgress()) {
                                                                                ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                            }
                                                                            Function2<Composer, Integer, Unit> function17 = function15;
                                                                            composer5.startReplaceGroup(-779485335);
                                                                            ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                            if (function17 != null) {
                                                                                function17.invoke(composer5, 0);
                                                                                Unit unit = Unit.INSTANCE;
                                                                            }
                                                                            composer5.endReplaceGroup();
                                                                            function16.invoke(composer5, 0);
                                                                            if (ComposerKt.isTraceInProgress()) {
                                                                                ComposerKt.traceEventEnd();
                                                                                return;
                                                                            }
                                                                            return;
                                                                        }
                                                                        composer5.skipToGroupEnd();
                                                                    }
                                                                }, composer4, 54), composer4, 438);
                                                                if (ComposerKt.isTraceInProgress()) {
                                                                    ComposerKt.traceEventEnd();
                                                                    return;
                                                                }
                                                                return;
                                                            }
                                                            composer4.skipToGroupEnd();
                                                        }
                                                    }, composer3, 54), composer3, 384);
                                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                                    composer3.endNode();
                                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                                    composer3.endNode();
                                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                                    if (ComposerKt.isTraceInProgress()) {
                                                        ComposerKt.traceEventEnd();
                                                        return;
                                                    }
                                                    return;
                                                }
                                                composer3.skipToGroupEnd();
                                            }
                                        }, composer2, 54), composer2, 12582918, 104);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier2 = companion;
                            function6 = function8;
                            shape3 = shape5;
                            f2 = f4;
                            datePickerColors2 = datePickerColors4;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            modifier2 = modifier;
                            dialogProperties2 = dialogProperties;
                            function6 = function5;
                            shape3 = shape2;
                            f2 = fM2272getTonalElevationD9Ej5fM;
                            datePickerColors2 = datePickerColorsColors;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final DialogProperties dialogProperties3 = dialogProperties2;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i14) {
                                    DatePickerDialog_androidKt.m2273DatePickerDialogGmEhDVc(function0, function2, modifier2, function6, shape3, f2, datePickerColors2, dialogProperties3, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 100663296;
                    if ((i3 & 38347923) == 38347922) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) == 0) {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i4 != 0) {
                                function5 = null;
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            }
                            if (i6 != 0) {
                                fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                            if (i8 != 0) {
                                dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                            } else {
                                dialogProperties2 = dialogProperties;
                            }
                        } else {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i4 != 0) {
                                function5 = null;
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            }
                            if (i6 != 0) {
                                fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                            if (i8 != 0) {
                                dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                            } else {
                                dialogProperties2 = dialogProperties;
                            }
                        }
                        final Function2<? super Composer, ? super Integer, Unit> function9 = function5;
                        final Shape shape6 = shape2;
                        final float f5 = fM2272getTonalElevationD9Ej5fM;
                        final DatePickerColors datePickerColors5 = datePickerColorsColors;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                        }
                        AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i14) {
                                ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                                if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                                    }
                                    Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                                    Shape shape7 = shape6;
                                    long containerColor = datePickerColors5.getContainerColor();
                                    float f6 = f5;
                                    final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function10 = function4;
                                    final Function2<? super Composer, ? super Integer, Unit> function11 = function9;
                                    final Function2<? super Composer, ? super Integer, Unit> function12 = function2;
                                    SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape7, containerColor, 0L, f6, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer3, int i15) {
                                            ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                            if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                                }
                                                Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                                Function3<ColumnScope, Composer, Integer, Unit> function13 = function10;
                                                final Function2<? super Composer, ? super Integer, Unit> function14 = function11;
                                                final Function2<? super Composer, ? super Integer, Unit> function15 = function12;
                                                ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                                Modifier.Companion companion2 = Modifier.INSTANCE;
                                                MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                                Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                if (!(composer3.getApplier() instanceof Applier)) {
                                                    ComposablesKt.invalidApplier();
                                                }
                                                composer3.startReusableNode();
                                                if (composer3.getInserting()) {
                                                    composer3.createNode(constructor);
                                                } else {
                                                    composer3.useNode();
                                                }
                                                Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                                }
                                                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                                ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                                ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                                ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                                Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                                ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                                Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                                Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                if (!(composer3.getApplier() instanceof Applier)) {
                                                    ComposablesKt.invalidApplier();
                                                }
                                                composer3.startReusableNode();
                                                if (composer3.getInserting()) {
                                                    composer3.createNode(constructor2);
                                                } else {
                                                    composer3.useNode();
                                                }
                                                Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                                Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                    composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                    composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                                }
                                                Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                                ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                                BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                                ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                                function13.invoke(columnScopeInstance, composer3, 6);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                composer3.endNode();
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                                ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                                Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                                Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                if (!(composer3.getApplier() instanceof Applier)) {
                                                    ComposablesKt.invalidApplier();
                                                }
                                                composer3.startReusableNode();
                                                if (composer3.getInserting()) {
                                                    composer3.createNode(constructor3);
                                                } else {
                                                    composer3.useNode();
                                                }
                                                Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                                Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                                    composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                                    composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                                }
                                                Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                                ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                                BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                                ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                                ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                                    {
                                                        super(2);
                                                    }

                                                    public Object invoke(Object obj, Object obj2) {
                                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                                        return Unit.INSTANCE;
                                                    }

                                                    public final void invoke(Composer composer4, int i16) {
                                                        ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                        if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                            if (ComposerKt.isTraceInProgress()) {
                                                                ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                            }
                                                            float f7 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                            float f8 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                            final Function2<? super Composer, ? super Integer, Unit> function16 = function14;
                                                            final Function2<? super Composer, ? super Integer, Unit> function17 = function15;
                                                            AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f7, f8, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                                {
                                                                    super(2);
                                                                }

                                                                public Object invoke(Object obj, Object obj2) {
                                                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                                                    return Unit.INSTANCE;
                                                                }

                                                                public final void invoke(Composer composer5, int i17) {
                                                                    ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                                    if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                        if (ComposerKt.isTraceInProgress()) {
                                                                            ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                        }
                                                                        Function2<Composer, Integer, Unit> function18 = function16;
                                                                        composer5.startReplaceGroup(-779485335);
                                                                        ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                        if (function18 != null) {
                                                                            function18.invoke(composer5, 0);
                                                                            Unit unit = Unit.INSTANCE;
                                                                        }
                                                                        composer5.endReplaceGroup();
                                                                        function17.invoke(composer5, 0);
                                                                        if (ComposerKt.isTraceInProgress()) {
                                                                            ComposerKt.traceEventEnd();
                                                                            return;
                                                                        }
                                                                        return;
                                                                    }
                                                                    composer5.skipToGroupEnd();
                                                                }
                                                            }, composer4, 54), composer4, 438);
                                                            if (ComposerKt.isTraceInProgress()) {
                                                                ComposerKt.traceEventEnd();
                                                                return;
                                                            }
                                                            return;
                                                        }
                                                        composer4.skipToGroupEnd();
                                                    }
                                                }, composer3, 54), composer3, 384);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                composer3.endNode();
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                composer3.endNode();
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer3.skipToGroupEnd();
                                        }
                                    }, composer2, 54), composer2, 12582918, 104);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        function6 = function9;
                        shape3 = shape6;
                        f2 = f5;
                        datePickerColors2 = datePickerColors5;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) == 0) {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i4 != 0) {
                                function5 = null;
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            }
                            if (i6 != 0) {
                                fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                            if (i8 != 0) {
                                dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                            } else {
                                dialogProperties2 = dialogProperties;
                            }
                        } else {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i4 != 0) {
                                function5 = null;
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            }
                            if (i6 != 0) {
                                fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                            if (i8 != 0) {
                                dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                            } else {
                                dialogProperties2 = dialogProperties;
                            }
                        }
                        final Function2<? super Composer, ? super Integer, Unit> function10 = function5;
                        final Shape shape7 = shape2;
                        final float f6 = fM2272getTonalElevationD9Ej5fM;
                        final DatePickerColors datePickerColors6 = datePickerColorsColors;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                        }
                        AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i14) {
                                ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                                if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                                    }
                                    Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                                    Shape shape8 = shape7;
                                    long containerColor = datePickerColors6.getContainerColor();
                                    float f7 = f6;
                                    final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function11 = function4;
                                    final Function2<? super Composer, ? super Integer, Unit> function12 = function10;
                                    final Function2<? super Composer, ? super Integer, Unit> function13 = function2;
                                    SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape8, containerColor, 0L, f7, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer3, int i15) {
                                            ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                            if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                                }
                                                Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                                Function3<ColumnScope, Composer, Integer, Unit> function14 = function11;
                                                final Function2<? super Composer, ? super Integer, Unit> function15 = function12;
                                                final Function2<? super Composer, ? super Integer, Unit> function16 = function13;
                                                ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                                Modifier.Companion companion2 = Modifier.INSTANCE;
                                                MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                                Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                if (!(composer3.getApplier() instanceof Applier)) {
                                                    ComposablesKt.invalidApplier();
                                                }
                                                composer3.startReusableNode();
                                                if (composer3.getInserting()) {
                                                    composer3.createNode(constructor);
                                                } else {
                                                    composer3.useNode();
                                                }
                                                Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                                }
                                                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                                ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                                ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                                ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                                Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                                ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                                Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                                Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                if (!(composer3.getApplier() instanceof Applier)) {
                                                    ComposablesKt.invalidApplier();
                                                }
                                                composer3.startReusableNode();
                                                if (composer3.getInserting()) {
                                                    composer3.createNode(constructor2);
                                                } else {
                                                    composer3.useNode();
                                                }
                                                Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                                Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                    composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                    composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                                }
                                                Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                                ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                                BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                                ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                                function14.invoke(columnScopeInstance, composer3, 6);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                composer3.endNode();
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                                ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                                Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                                Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                if (!(composer3.getApplier() instanceof Applier)) {
                                                    ComposablesKt.invalidApplier();
                                                }
                                                composer3.startReusableNode();
                                                if (composer3.getInserting()) {
                                                    composer3.createNode(constructor3);
                                                } else {
                                                    composer3.useNode();
                                                }
                                                Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                                Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                                    composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                                    composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                                }
                                                Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                                ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                                BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                                ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                                ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                                    {
                                                        super(2);
                                                    }

                                                    public Object invoke(Object obj, Object obj2) {
                                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                                        return Unit.INSTANCE;
                                                    }

                                                    public final void invoke(Composer composer4, int i16) {
                                                        ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                        if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                            if (ComposerKt.isTraceInProgress()) {
                                                                ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                            }
                                                            float f8 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                            float f9 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                            final Function2<? super Composer, ? super Integer, Unit> function17 = function15;
                                                            final Function2<? super Composer, ? super Integer, Unit> function18 = function16;
                                                            AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f8, f9, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                                {
                                                                    super(2);
                                                                }

                                                                public Object invoke(Object obj, Object obj2) {
                                                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                                                    return Unit.INSTANCE;
                                                                }

                                                                public final void invoke(Composer composer5, int i17) {
                                                                    ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                                    if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                        if (ComposerKt.isTraceInProgress()) {
                                                                            ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                        }
                                                                        Function2<Composer, Integer, Unit> function19 = function17;
                                                                        composer5.startReplaceGroup(-779485335);
                                                                        ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                        if (function19 != null) {
                                                                            function19.invoke(composer5, 0);
                                                                            Unit unit = Unit.INSTANCE;
                                                                        }
                                                                        composer5.endReplaceGroup();
                                                                        function18.invoke(composer5, 0);
                                                                        if (ComposerKt.isTraceInProgress()) {
                                                                            ComposerKt.traceEventEnd();
                                                                            return;
                                                                        }
                                                                        return;
                                                                    }
                                                                    composer5.skipToGroupEnd();
                                                                }
                                                            }, composer4, 54), composer4, 438);
                                                            if (ComposerKt.isTraceInProgress()) {
                                                                ComposerKt.traceEventEnd();
                                                                return;
                                                            }
                                                            return;
                                                        }
                                                        composer4.skipToGroupEnd();
                                                    }
                                                }, composer3, 54), composer3, 384);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                composer3.endNode();
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                composer3.endNode();
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer3.skipToGroupEnd();
                                        }
                                    }, composer2, 54), composer2, 12582918, 104);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        function6 = function10;
                        shape3 = shape7;
                        f2 = f6;
                        datePickerColors2 = datePickerColors6;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final DialogProperties dialogProperties4 = dialogProperties2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i14) {
                                DatePickerDialog_androidKt.m2273DatePickerDialogGmEhDVc(function0, function2, modifier2, function6, shape3, f2, datePickerColors2, dialogProperties4, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                fM2272getTonalElevationD9Ej5fM = f;
                if ((1572864 & i) == 0) {
                    if ((i2 & 64) == 0) {
                        datePickerColorsColors = datePickerColors;
                        if (composerStartRestartGroup.changed(datePickerColorsColors)) {
                        }
                        i3 |= i13;
                    } else {
                        datePickerColorsColors = datePickerColors;
                    }
                    i3 |= i13;
                } else {
                    datePickerColorsColors = datePickerColors;
                }
                i8 = i2 & Fields.SpotShadowColor;
                if (i8 != 0) {
                    i3 |= 12582912;
                } else if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(dialogProperties)) {
                        i9 = 8388608;
                    } else {
                        i9 = 4194304;
                    }
                    i3 |= i9;
                }
                if ((i2 & Fields.RotationX) != 0) {
                    if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changedInstance(function4)) {
                            i10 = 67108864;
                        } else {
                            i10 = 33554432;
                        }
                        i3 |= i10;
                    }
                    if ((i3 & 38347923) == 38347922) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) == 0) {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i4 != 0) {
                                function5 = null;
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            }
                            if (i6 != 0) {
                                fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                            if (i8 != 0) {
                                dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                            } else {
                                dialogProperties2 = dialogProperties;
                            }
                        } else {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i4 != 0) {
                                function5 = null;
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            }
                            if (i6 != 0) {
                                fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                            if (i8 != 0) {
                                dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                            } else {
                                dialogProperties2 = dialogProperties;
                            }
                        }
                        final Function2<? super Composer, ? super Integer, Unit> function11 = function5;
                        final Shape shape8 = shape2;
                        final float f7 = fM2272getTonalElevationD9Ej5fM;
                        final DatePickerColors datePickerColors7 = datePickerColorsColors;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                        }
                        AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i14) {
                                ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                                if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                                    }
                                    Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                                    Shape shape9 = shape8;
                                    long containerColor = datePickerColors7.getContainerColor();
                                    float f8 = f7;
                                    final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function12 = function4;
                                    final Function2<? super Composer, ? super Integer, Unit> function13 = function11;
                                    final Function2<? super Composer, ? super Integer, Unit> function14 = function2;
                                    SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape9, containerColor, 0L, f8, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer3, int i15) {
                                            ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                            if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                                }
                                                Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                                Function3<ColumnScope, Composer, Integer, Unit> function15 = function12;
                                                final Function2<? super Composer, ? super Integer, Unit> function16 = function13;
                                                final Function2<? super Composer, ? super Integer, Unit> function17 = function14;
                                                ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                                Modifier.Companion companion2 = Modifier.INSTANCE;
                                                MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                                Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                if (!(composer3.getApplier() instanceof Applier)) {
                                                    ComposablesKt.invalidApplier();
                                                }
                                                composer3.startReusableNode();
                                                if (composer3.getInserting()) {
                                                    composer3.createNode(constructor);
                                                } else {
                                                    composer3.useNode();
                                                }
                                                Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                                }
                                                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                                ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                                ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                                ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                                Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                                ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                                Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                                Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                if (!(composer3.getApplier() instanceof Applier)) {
                                                    ComposablesKt.invalidApplier();
                                                }
                                                composer3.startReusableNode();
                                                if (composer3.getInserting()) {
                                                    composer3.createNode(constructor2);
                                                } else {
                                                    composer3.useNode();
                                                }
                                                Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                                Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                    composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                    composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                                }
                                                Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                                ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                                BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                                ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                                function15.invoke(columnScopeInstance, composer3, 6);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                composer3.endNode();
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                                ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                                Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                                Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                if (!(composer3.getApplier() instanceof Applier)) {
                                                    ComposablesKt.invalidApplier();
                                                }
                                                composer3.startReusableNode();
                                                if (composer3.getInserting()) {
                                                    composer3.createNode(constructor3);
                                                } else {
                                                    composer3.useNode();
                                                }
                                                Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                                Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                                    composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                                    composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                                }
                                                Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                                ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                                BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                                ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                                ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                                    {
                                                        super(2);
                                                    }

                                                    public Object invoke(Object obj, Object obj2) {
                                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                                        return Unit.INSTANCE;
                                                    }

                                                    public final void invoke(Composer composer4, int i16) {
                                                        ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                        if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                            if (ComposerKt.isTraceInProgress()) {
                                                                ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                            }
                                                            float f9 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                            float f10 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                            final Function2<? super Composer, ? super Integer, Unit> function18 = function16;
                                                            final Function2<? super Composer, ? super Integer, Unit> function19 = function17;
                                                            AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f9, f10, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                                {
                                                                    super(2);
                                                                }

                                                                public Object invoke(Object obj, Object obj2) {
                                                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                                                    return Unit.INSTANCE;
                                                                }

                                                                public final void invoke(Composer composer5, int i17) {
                                                                    ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                                    if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                        if (ComposerKt.isTraceInProgress()) {
                                                                            ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                        }
                                                                        Function2<Composer, Integer, Unit> function110 = function18;
                                                                        composer5.startReplaceGroup(-779485335);
                                                                        ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                        if (function110 != null) {
                                                                            function110.invoke(composer5, 0);
                                                                            Unit unit = Unit.INSTANCE;
                                                                        }
                                                                        composer5.endReplaceGroup();
                                                                        function19.invoke(composer5, 0);
                                                                        if (ComposerKt.isTraceInProgress()) {
                                                                            ComposerKt.traceEventEnd();
                                                                            return;
                                                                        }
                                                                        return;
                                                                    }
                                                                    composer5.skipToGroupEnd();
                                                                }
                                                            }, composer4, 54), composer4, 438);
                                                            if (ComposerKt.isTraceInProgress()) {
                                                                ComposerKt.traceEventEnd();
                                                                return;
                                                            }
                                                            return;
                                                        }
                                                        composer4.skipToGroupEnd();
                                                    }
                                                }, composer3, 54), composer3, 384);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                composer3.endNode();
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                composer3.endNode();
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer3.skipToGroupEnd();
                                        }
                                    }, composer2, 54), composer2, 12582918, 104);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        function6 = function11;
                        shape3 = shape8;
                        f2 = f7;
                        datePickerColors2 = datePickerColors7;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) == 0) {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i4 != 0) {
                                function5 = null;
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            }
                            if (i6 != 0) {
                                fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                            if (i8 != 0) {
                                dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                            } else {
                                dialogProperties2 = dialogProperties;
                            }
                        } else {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i4 != 0) {
                                function5 = null;
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            }
                            if (i6 != 0) {
                                fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                            if (i8 != 0) {
                                dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                            } else {
                                dialogProperties2 = dialogProperties;
                            }
                        }
                        final Function2<? super Composer, ? super Integer, Unit> function12 = function5;
                        final Shape shape9 = shape2;
                        final float f8 = fM2272getTonalElevationD9Ej5fM;
                        final DatePickerColors datePickerColors8 = datePickerColorsColors;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                        }
                        AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i14) {
                                ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                                if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                                    }
                                    Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                                    Shape shape10 = shape9;
                                    long containerColor = datePickerColors8.getContainerColor();
                                    float f9 = f8;
                                    final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function13 = function4;
                                    final Function2<? super Composer, ? super Integer, Unit> function14 = function12;
                                    final Function2<? super Composer, ? super Integer, Unit> function15 = function2;
                                    SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape10, containerColor, 0L, f9, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer3, int i15) {
                                            ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                            if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                                }
                                                Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                                Function3<ColumnScope, Composer, Integer, Unit> function16 = function13;
                                                final Function2<? super Composer, ? super Integer, Unit> function17 = function14;
                                                final Function2<? super Composer, ? super Integer, Unit> function18 = function15;
                                                ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                                Modifier.Companion companion2 = Modifier.INSTANCE;
                                                MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                                Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                if (!(composer3.getApplier() instanceof Applier)) {
                                                    ComposablesKt.invalidApplier();
                                                }
                                                composer3.startReusableNode();
                                                if (composer3.getInserting()) {
                                                    composer3.createNode(constructor);
                                                } else {
                                                    composer3.useNode();
                                                }
                                                Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                                }
                                                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                                ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                                ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                                ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                                Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                                ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                                Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                                Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                if (!(composer3.getApplier() instanceof Applier)) {
                                                    ComposablesKt.invalidApplier();
                                                }
                                                composer3.startReusableNode();
                                                if (composer3.getInserting()) {
                                                    composer3.createNode(constructor2);
                                                } else {
                                                    composer3.useNode();
                                                }
                                                Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                                Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                    composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                    composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                                }
                                                Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                                ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                                BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                                ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                                function16.invoke(columnScopeInstance, composer3, 6);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                composer3.endNode();
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                                ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                                Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                                Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                if (!(composer3.getApplier() instanceof Applier)) {
                                                    ComposablesKt.invalidApplier();
                                                }
                                                composer3.startReusableNode();
                                                if (composer3.getInserting()) {
                                                    composer3.createNode(constructor3);
                                                } else {
                                                    composer3.useNode();
                                                }
                                                Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                                Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                                    composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                                    composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                                }
                                                Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                                ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                                BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                                ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                                ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                                    {
                                                        super(2);
                                                    }

                                                    public Object invoke(Object obj, Object obj2) {
                                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                                        return Unit.INSTANCE;
                                                    }

                                                    public final void invoke(Composer composer4, int i16) {
                                                        ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                        if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                            if (ComposerKt.isTraceInProgress()) {
                                                                ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                            }
                                                            float f10 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                            float f11 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                            final Function2<? super Composer, ? super Integer, Unit> function19 = function17;
                                                            final Function2<? super Composer, ? super Integer, Unit> function110 = function18;
                                                            AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f10, f11, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                                {
                                                                    super(2);
                                                                }

                                                                public Object invoke(Object obj, Object obj2) {
                                                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                                                    return Unit.INSTANCE;
                                                                }

                                                                public final void invoke(Composer composer5, int i17) {
                                                                    ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                                    if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                        if (ComposerKt.isTraceInProgress()) {
                                                                            ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                        }
                                                                        Function2<Composer, Integer, Unit> function111 = function19;
                                                                        composer5.startReplaceGroup(-779485335);
                                                                        ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                        if (function111 != null) {
                                                                            function111.invoke(composer5, 0);
                                                                            Unit unit = Unit.INSTANCE;
                                                                        }
                                                                        composer5.endReplaceGroup();
                                                                        function110.invoke(composer5, 0);
                                                                        if (ComposerKt.isTraceInProgress()) {
                                                                            ComposerKt.traceEventEnd();
                                                                            return;
                                                                        }
                                                                        return;
                                                                    }
                                                                    composer5.skipToGroupEnd();
                                                                }
                                                            }, composer4, 54), composer4, 438);
                                                            if (ComposerKt.isTraceInProgress()) {
                                                                ComposerKt.traceEventEnd();
                                                                return;
                                                            }
                                                            return;
                                                        }
                                                        composer4.skipToGroupEnd();
                                                    }
                                                }, composer3, 54), composer3, 384);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                composer3.endNode();
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                composer3.endNode();
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer3.skipToGroupEnd();
                                        }
                                    }, composer2, 54), composer2, 12582918, 104);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        function6 = function12;
                        shape3 = shape9;
                        f2 = f8;
                        datePickerColors2 = datePickerColors8;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final DialogProperties dialogProperties5 = dialogProperties2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i14) {
                                DatePickerDialog_androidKt.m2273DatePickerDialogGmEhDVc(function0, function2, modifier2, function6, shape3, f2, datePickerColors2, dialogProperties5, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 100663296;
                if ((i3 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) == 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i8 != 0) {
                            dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                        } else {
                            dialogProperties2 = dialogProperties;
                        }
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i8 != 0) {
                            dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                        } else {
                            dialogProperties2 = dialogProperties;
                        }
                    }
                    final Function2<? super Composer, ? super Integer, Unit> function13 = function5;
                    final Shape shape10 = shape2;
                    final float f9 = fM2272getTonalElevationD9Ej5fM;
                    final DatePickerColors datePickerColors9 = datePickerColorsColors;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                    }
                    AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                            if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                                }
                                Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                                Shape shape11 = shape10;
                                long containerColor = datePickerColors9.getContainerColor();
                                float f10 = f9;
                                final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function14 = function4;
                                final Function2<? super Composer, ? super Integer, Unit> function15 = function13;
                                final Function2<? super Composer, ? super Integer, Unit> function16 = function2;
                                SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape11, containerColor, 0L, f10, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer3, int i15) {
                                        ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                        if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                            }
                                            Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                            Function3<ColumnScope, Composer, Integer, Unit> function17 = function14;
                                            final Function2<? super Composer, ? super Integer, Unit> function18 = function15;
                                            final Function2<? super Composer, ? super Integer, Unit> function19 = function16;
                                            ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                            Modifier.Companion companion2 = Modifier.INSTANCE;
                                            MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                            Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                            ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                            Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor2);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                            BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                            function17.invoke(columnScopeInstance, composer3, 6);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                            Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor3);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                                composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                                composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                            BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                            ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                                {
                                                    super(2);
                                                }

                                                public Object invoke(Object obj, Object obj2) {
                                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                                    return Unit.INSTANCE;
                                                }

                                                public final void invoke(Composer composer4, int i16) {
                                                    ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                    if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                        if (ComposerKt.isTraceInProgress()) {
                                                            ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                        }
                                                        float f11 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                        float f12 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                        final Function2<? super Composer, ? super Integer, Unit> function110 = function18;
                                                        final Function2<? super Composer, ? super Integer, Unit> function111 = function19;
                                                        AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f11, f12, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                            {
                                                                super(2);
                                                            }

                                                            public Object invoke(Object obj, Object obj2) {
                                                                invoke((Composer) obj, ((Number) obj2).intValue());
                                                                return Unit.INSTANCE;
                                                            }

                                                            public final void invoke(Composer composer5, int i17) {
                                                                ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                                if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                    if (ComposerKt.isTraceInProgress()) {
                                                                        ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                    }
                                                                    Function2<Composer, Integer, Unit> function112 = function110;
                                                                    composer5.startReplaceGroup(-779485335);
                                                                    ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                    if (function112 != null) {
                                                                        function112.invoke(composer5, 0);
                                                                        Unit unit = Unit.INSTANCE;
                                                                    }
                                                                    composer5.endReplaceGroup();
                                                                    function111.invoke(composer5, 0);
                                                                    if (ComposerKt.isTraceInProgress()) {
                                                                        ComposerKt.traceEventEnd();
                                                                        return;
                                                                    }
                                                                    return;
                                                                }
                                                                composer5.skipToGroupEnd();
                                                            }
                                                        }, composer4, 54), composer4, 438);
                                                        if (ComposerKt.isTraceInProgress()) {
                                                            ComposerKt.traceEventEnd();
                                                            return;
                                                        }
                                                        return;
                                                    }
                                                    composer4.skipToGroupEnd();
                                                }
                                            }, composer3, 54), composer3, 384);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer3.skipToGroupEnd();
                                    }
                                }, composer2, 54), composer2, 12582918, 104);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    function6 = function13;
                    shape3 = shape10;
                    f2 = f9;
                    datePickerColors2 = datePickerColors9;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) == 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i8 != 0) {
                            dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                        } else {
                            dialogProperties2 = dialogProperties;
                        }
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i8 != 0) {
                            dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                        } else {
                            dialogProperties2 = dialogProperties;
                        }
                    }
                    final Function2<? super Composer, ? super Integer, Unit> function14 = function5;
                    final Shape shape11 = shape2;
                    final float f10 = fM2272getTonalElevationD9Ej5fM;
                    final DatePickerColors datePickerColors10 = datePickerColorsColors;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                    }
                    AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                            if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                                }
                                Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                                Shape shape12 = shape11;
                                long containerColor = datePickerColors10.getContainerColor();
                                float f11 = f10;
                                final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function15 = function4;
                                final Function2<? super Composer, ? super Integer, Unit> function16 = function14;
                                final Function2<? super Composer, ? super Integer, Unit> function17 = function2;
                                SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape12, containerColor, 0L, f11, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer3, int i15) {
                                        ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                        if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                            }
                                            Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                            Function3<ColumnScope, Composer, Integer, Unit> function18 = function15;
                                            final Function2<? super Composer, ? super Integer, Unit> function19 = function16;
                                            final Function2<? super Composer, ? super Integer, Unit> function110 = function17;
                                            ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                            Modifier.Companion companion2 = Modifier.INSTANCE;
                                            MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                            Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                            ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                            Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor2);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                            BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                            function18.invoke(columnScopeInstance, composer3, 6);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                            Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor3);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                                composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                                composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                            BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                            ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                                {
                                                    super(2);
                                                }

                                                public Object invoke(Object obj, Object obj2) {
                                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                                    return Unit.INSTANCE;
                                                }

                                                public final void invoke(Composer composer4, int i16) {
                                                    ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                    if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                        if (ComposerKt.isTraceInProgress()) {
                                                            ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                        }
                                                        float f12 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                        float f13 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                        final Function2<? super Composer, ? super Integer, Unit> function111 = function19;
                                                        final Function2<? super Composer, ? super Integer, Unit> function112 = function110;
                                                        AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f12, f13, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                            {
                                                                super(2);
                                                            }

                                                            public Object invoke(Object obj, Object obj2) {
                                                                invoke((Composer) obj, ((Number) obj2).intValue());
                                                                return Unit.INSTANCE;
                                                            }

                                                            public final void invoke(Composer composer5, int i17) {
                                                                ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                                if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                    if (ComposerKt.isTraceInProgress()) {
                                                                        ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                    }
                                                                    Function2<Composer, Integer, Unit> function113 = function111;
                                                                    composer5.startReplaceGroup(-779485335);
                                                                    ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                    if (function113 != null) {
                                                                        function113.invoke(composer5, 0);
                                                                        Unit unit = Unit.INSTANCE;
                                                                    }
                                                                    composer5.endReplaceGroup();
                                                                    function112.invoke(composer5, 0);
                                                                    if (ComposerKt.isTraceInProgress()) {
                                                                        ComposerKt.traceEventEnd();
                                                                        return;
                                                                    }
                                                                    return;
                                                                }
                                                                composer5.skipToGroupEnd();
                                                            }
                                                        }, composer4, 54), composer4, 438);
                                                        if (ComposerKt.isTraceInProgress()) {
                                                            ComposerKt.traceEventEnd();
                                                            return;
                                                        }
                                                        return;
                                                    }
                                                    composer4.skipToGroupEnd();
                                                }
                                            }, composer3, 54), composer3, 384);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer3.skipToGroupEnd();
                                    }
                                }, composer2, 54), composer2, 12582918, 104);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    function6 = function14;
                    shape3 = shape11;
                    f2 = f10;
                    datePickerColors2 = datePickerColors10;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final DialogProperties dialogProperties6 = dialogProperties2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            DatePickerDialog_androidKt.m2273DatePickerDialogGmEhDVc(function0, function2, modifier2, function6, shape3, f2, datePickerColors2, dialogProperties6, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            function5 = function3;
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    shape2 = shape;
                    if (composerStartRestartGroup.changed(shape2)) {
                        i11 = Fields.Clip;
                    }
                    i3 |= i11;
                } else {
                    shape2 = shape;
                }
                i11 = Fields.Shape;
                i3 |= i11;
            } else {
                shape2 = shape;
            }
            i6 = i2 & 32;
            if (i6 != 0) {
                if ((196608 & i) == 0) {
                    fM2272getTonalElevationD9Ej5fM = f;
                    if (composerStartRestartGroup.changed(fM2272getTonalElevationD9Ej5fM)) {
                        i7 = Fields.RenderEffect;
                    } else {
                        i7 = 65536;
                    }
                    i3 |= i7;
                }
                if ((1572864 & i) == 0) {
                    if ((i2 & 64) == 0) {
                        datePickerColorsColors = datePickerColors;
                        if (composerStartRestartGroup.changed(datePickerColorsColors)) {
                        }
                        i3 |= i13;
                    } else {
                        datePickerColorsColors = datePickerColors;
                    }
                    i3 |= i13;
                } else {
                    datePickerColorsColors = datePickerColors;
                }
                i8 = i2 & Fields.SpotShadowColor;
                if (i8 != 0) {
                    i3 |= 12582912;
                } else if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(dialogProperties)) {
                        i9 = 8388608;
                    } else {
                        i9 = 4194304;
                    }
                    i3 |= i9;
                }
                if ((i2 & Fields.RotationX) != 0) {
                    if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changedInstance(function4)) {
                            i10 = 67108864;
                        } else {
                            i10 = 33554432;
                        }
                        i3 |= i10;
                    }
                    if ((i3 & 38347923) == 38347922) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) == 0) {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i4 != 0) {
                                function5 = null;
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            }
                            if (i6 != 0) {
                                fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                            if (i8 != 0) {
                                dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                            } else {
                                dialogProperties2 = dialogProperties;
                            }
                        } else {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i4 != 0) {
                                function5 = null;
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            }
                            if (i6 != 0) {
                                fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                            if (i8 != 0) {
                                dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                            } else {
                                dialogProperties2 = dialogProperties;
                            }
                        }
                        final Function2<? super Composer, ? super Integer, Unit> function15 = function5;
                        final Shape shape12 = shape2;
                        final float f11 = fM2272getTonalElevationD9Ej5fM;
                        final DatePickerColors datePickerColors11 = datePickerColorsColors;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                        }
                        AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i14) {
                                ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                                if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                                    }
                                    Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                                    Shape shape13 = shape12;
                                    long containerColor = datePickerColors11.getContainerColor();
                                    float f12 = f11;
                                    final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function16 = function4;
                                    final Function2<? super Composer, ? super Integer, Unit> function17 = function15;
                                    final Function2<? super Composer, ? super Integer, Unit> function18 = function2;
                                    SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape13, containerColor, 0L, f12, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer3, int i15) {
                                            ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                            if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                                }
                                                Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                                Function3<ColumnScope, Composer, Integer, Unit> function19 = function16;
                                                final Function2<? super Composer, ? super Integer, Unit> function110 = function17;
                                                final Function2<? super Composer, ? super Integer, Unit> function111 = function18;
                                                ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                                Modifier.Companion companion2 = Modifier.INSTANCE;
                                                MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                                Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                if (!(composer3.getApplier() instanceof Applier)) {
                                                    ComposablesKt.invalidApplier();
                                                }
                                                composer3.startReusableNode();
                                                if (composer3.getInserting()) {
                                                    composer3.createNode(constructor);
                                                } else {
                                                    composer3.useNode();
                                                }
                                                Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                                }
                                                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                                ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                                ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                                ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                                Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                                ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                                Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                                Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                if (!(composer3.getApplier() instanceof Applier)) {
                                                    ComposablesKt.invalidApplier();
                                                }
                                                composer3.startReusableNode();
                                                if (composer3.getInserting()) {
                                                    composer3.createNode(constructor2);
                                                } else {
                                                    composer3.useNode();
                                                }
                                                Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                                Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                    composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                    composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                                }
                                                Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                                ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                                BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                                ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                                function19.invoke(columnScopeInstance, composer3, 6);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                composer3.endNode();
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                                ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                                Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                                Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                if (!(composer3.getApplier() instanceof Applier)) {
                                                    ComposablesKt.invalidApplier();
                                                }
                                                composer3.startReusableNode();
                                                if (composer3.getInserting()) {
                                                    composer3.createNode(constructor3);
                                                } else {
                                                    composer3.useNode();
                                                }
                                                Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                                Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                                    composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                                    composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                                }
                                                Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                                ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                                BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                                ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                                ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                                    {
                                                        super(2);
                                                    }

                                                    public Object invoke(Object obj, Object obj2) {
                                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                                        return Unit.INSTANCE;
                                                    }

                                                    public final void invoke(Composer composer4, int i16) {
                                                        ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                        if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                            if (ComposerKt.isTraceInProgress()) {
                                                                ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                            }
                                                            float f13 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                            float f14 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                            final Function2<? super Composer, ? super Integer, Unit> function112 = function110;
                                                            final Function2<? super Composer, ? super Integer, Unit> function113 = function111;
                                                            AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f13, f14, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                                {
                                                                    super(2);
                                                                }

                                                                public Object invoke(Object obj, Object obj2) {
                                                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                                                    return Unit.INSTANCE;
                                                                }

                                                                public final void invoke(Composer composer5, int i17) {
                                                                    ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                                    if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                        if (ComposerKt.isTraceInProgress()) {
                                                                            ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                        }
                                                                        Function2<Composer, Integer, Unit> function114 = function112;
                                                                        composer5.startReplaceGroup(-779485335);
                                                                        ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                        if (function114 != null) {
                                                                            function114.invoke(composer5, 0);
                                                                            Unit unit = Unit.INSTANCE;
                                                                        }
                                                                        composer5.endReplaceGroup();
                                                                        function113.invoke(composer5, 0);
                                                                        if (ComposerKt.isTraceInProgress()) {
                                                                            ComposerKt.traceEventEnd();
                                                                            return;
                                                                        }
                                                                        return;
                                                                    }
                                                                    composer5.skipToGroupEnd();
                                                                }
                                                            }, composer4, 54), composer4, 438);
                                                            if (ComposerKt.isTraceInProgress()) {
                                                                ComposerKt.traceEventEnd();
                                                                return;
                                                            }
                                                            return;
                                                        }
                                                        composer4.skipToGroupEnd();
                                                    }
                                                }, composer3, 54), composer3, 384);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                composer3.endNode();
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                composer3.endNode();
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer3.skipToGroupEnd();
                                        }
                                    }, composer2, 54), composer2, 12582918, 104);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        function6 = function15;
                        shape3 = shape12;
                        f2 = f11;
                        datePickerColors2 = datePickerColors11;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) == 0) {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i4 != 0) {
                                function5 = null;
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            }
                            if (i6 != 0) {
                                fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                            if (i8 != 0) {
                                dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                            } else {
                                dialogProperties2 = dialogProperties;
                            }
                        } else {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i4 != 0) {
                                function5 = null;
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            }
                            if (i6 != 0) {
                                fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                            if (i8 != 0) {
                                dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                            } else {
                                dialogProperties2 = dialogProperties;
                            }
                        }
                        final Function2<? super Composer, ? super Integer, Unit> function16 = function5;
                        final Shape shape13 = shape2;
                        final float f12 = fM2272getTonalElevationD9Ej5fM;
                        final DatePickerColors datePickerColors12 = datePickerColorsColors;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                        }
                        AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i14) {
                                ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                                if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                                    }
                                    Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                                    Shape shape14 = shape13;
                                    long containerColor = datePickerColors12.getContainerColor();
                                    float f13 = f12;
                                    final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function17 = function4;
                                    final Function2<? super Composer, ? super Integer, Unit> function18 = function16;
                                    final Function2<? super Composer, ? super Integer, Unit> function19 = function2;
                                    SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape14, containerColor, 0L, f13, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer3, int i15) {
                                            ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                            if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                                }
                                                Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                                Function3<ColumnScope, Composer, Integer, Unit> function110 = function17;
                                                final Function2<? super Composer, ? super Integer, Unit> function111 = function18;
                                                final Function2<? super Composer, ? super Integer, Unit> function112 = function19;
                                                ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                                Modifier.Companion companion2 = Modifier.INSTANCE;
                                                MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                                Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                if (!(composer3.getApplier() instanceof Applier)) {
                                                    ComposablesKt.invalidApplier();
                                                }
                                                composer3.startReusableNode();
                                                if (composer3.getInserting()) {
                                                    composer3.createNode(constructor);
                                                } else {
                                                    composer3.useNode();
                                                }
                                                Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                                }
                                                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                                ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                                ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                                ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                                Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                                ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                                Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                                Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                if (!(composer3.getApplier() instanceof Applier)) {
                                                    ComposablesKt.invalidApplier();
                                                }
                                                composer3.startReusableNode();
                                                if (composer3.getInserting()) {
                                                    composer3.createNode(constructor2);
                                                } else {
                                                    composer3.useNode();
                                                }
                                                Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                                Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                    composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                    composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                                }
                                                Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                                ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                                BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                                ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                                function110.invoke(columnScopeInstance, composer3, 6);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                composer3.endNode();
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                                ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                                Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                                Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                if (!(composer3.getApplier() instanceof Applier)) {
                                                    ComposablesKt.invalidApplier();
                                                }
                                                composer3.startReusableNode();
                                                if (composer3.getInserting()) {
                                                    composer3.createNode(constructor3);
                                                } else {
                                                    composer3.useNode();
                                                }
                                                Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                                Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                                    composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                                    composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                                }
                                                Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                                ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                                BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                                ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                                ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                                    {
                                                        super(2);
                                                    }

                                                    public Object invoke(Object obj, Object obj2) {
                                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                                        return Unit.INSTANCE;
                                                    }

                                                    public final void invoke(Composer composer4, int i16) {
                                                        ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                        if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                            if (ComposerKt.isTraceInProgress()) {
                                                                ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                            }
                                                            float f14 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                            float f15 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                            final Function2<? super Composer, ? super Integer, Unit> function113 = function111;
                                                            final Function2<? super Composer, ? super Integer, Unit> function114 = function112;
                                                            AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f14, f15, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                                {
                                                                    super(2);
                                                                }

                                                                public Object invoke(Object obj, Object obj2) {
                                                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                                                    return Unit.INSTANCE;
                                                                }

                                                                public final void invoke(Composer composer5, int i17) {
                                                                    ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                                    if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                        if (ComposerKt.isTraceInProgress()) {
                                                                            ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                        }
                                                                        Function2<Composer, Integer, Unit> function115 = function113;
                                                                        composer5.startReplaceGroup(-779485335);
                                                                        ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                        if (function115 != null) {
                                                                            function115.invoke(composer5, 0);
                                                                            Unit unit = Unit.INSTANCE;
                                                                        }
                                                                        composer5.endReplaceGroup();
                                                                        function114.invoke(composer5, 0);
                                                                        if (ComposerKt.isTraceInProgress()) {
                                                                            ComposerKt.traceEventEnd();
                                                                            return;
                                                                        }
                                                                        return;
                                                                    }
                                                                    composer5.skipToGroupEnd();
                                                                }
                                                            }, composer4, 54), composer4, 438);
                                                            if (ComposerKt.isTraceInProgress()) {
                                                                ComposerKt.traceEventEnd();
                                                                return;
                                                            }
                                                            return;
                                                        }
                                                        composer4.skipToGroupEnd();
                                                    }
                                                }, composer3, 54), composer3, 384);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                composer3.endNode();
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                composer3.endNode();
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer3.skipToGroupEnd();
                                        }
                                    }, composer2, 54), composer2, 12582918, 104);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        function6 = function16;
                        shape3 = shape13;
                        f2 = f12;
                        datePickerColors2 = datePickerColors12;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final DialogProperties dialogProperties7 = dialogProperties2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i14) {
                                DatePickerDialog_androidKt.m2273DatePickerDialogGmEhDVc(function0, function2, modifier2, function6, shape3, f2, datePickerColors2, dialogProperties7, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 100663296;
                if ((i3 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) == 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i8 != 0) {
                            dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                        } else {
                            dialogProperties2 = dialogProperties;
                        }
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i8 != 0) {
                            dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                        } else {
                            dialogProperties2 = dialogProperties;
                        }
                    }
                    final Function2<? super Composer, ? super Integer, Unit> function17 = function5;
                    final Shape shape14 = shape2;
                    final float f13 = fM2272getTonalElevationD9Ej5fM;
                    final DatePickerColors datePickerColors13 = datePickerColorsColors;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                    }
                    AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                            if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                                }
                                Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                                Shape shape15 = shape14;
                                long containerColor = datePickerColors13.getContainerColor();
                                float f14 = f13;
                                final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function18 = function4;
                                final Function2<? super Composer, ? super Integer, Unit> function19 = function17;
                                final Function2<? super Composer, ? super Integer, Unit> function110 = function2;
                                SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape15, containerColor, 0L, f14, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer3, int i15) {
                                        ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                        if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                            }
                                            Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                            Function3<ColumnScope, Composer, Integer, Unit> function111 = function18;
                                            final Function2<? super Composer, ? super Integer, Unit> function112 = function19;
                                            final Function2<? super Composer, ? super Integer, Unit> function113 = function110;
                                            ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                            Modifier.Companion companion2 = Modifier.INSTANCE;
                                            MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                            Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                            ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                            Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor2);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                            BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                            function111.invoke(columnScopeInstance, composer3, 6);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                            Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor3);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                                composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                                composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                            BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                            ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                                {
                                                    super(2);
                                                }

                                                public Object invoke(Object obj, Object obj2) {
                                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                                    return Unit.INSTANCE;
                                                }

                                                public final void invoke(Composer composer4, int i16) {
                                                    ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                    if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                        if (ComposerKt.isTraceInProgress()) {
                                                            ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                        }
                                                        float f15 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                        float f16 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                        final Function2<? super Composer, ? super Integer, Unit> function114 = function112;
                                                        final Function2<? super Composer, ? super Integer, Unit> function115 = function113;
                                                        AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f15, f16, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                            {
                                                                super(2);
                                                            }

                                                            public Object invoke(Object obj, Object obj2) {
                                                                invoke((Composer) obj, ((Number) obj2).intValue());
                                                                return Unit.INSTANCE;
                                                            }

                                                            public final void invoke(Composer composer5, int i17) {
                                                                ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                                if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                    if (ComposerKt.isTraceInProgress()) {
                                                                        ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                    }
                                                                    Function2<Composer, Integer, Unit> function116 = function114;
                                                                    composer5.startReplaceGroup(-779485335);
                                                                    ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                    if (function116 != null) {
                                                                        function116.invoke(composer5, 0);
                                                                        Unit unit = Unit.INSTANCE;
                                                                    }
                                                                    composer5.endReplaceGroup();
                                                                    function115.invoke(composer5, 0);
                                                                    if (ComposerKt.isTraceInProgress()) {
                                                                        ComposerKt.traceEventEnd();
                                                                        return;
                                                                    }
                                                                    return;
                                                                }
                                                                composer5.skipToGroupEnd();
                                                            }
                                                        }, composer4, 54), composer4, 438);
                                                        if (ComposerKt.isTraceInProgress()) {
                                                            ComposerKt.traceEventEnd();
                                                            return;
                                                        }
                                                        return;
                                                    }
                                                    composer4.skipToGroupEnd();
                                                }
                                            }, composer3, 54), composer3, 384);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer3.skipToGroupEnd();
                                    }
                                }, composer2, 54), composer2, 12582918, 104);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    function6 = function17;
                    shape3 = shape14;
                    f2 = f13;
                    datePickerColors2 = datePickerColors13;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) == 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i8 != 0) {
                            dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                        } else {
                            dialogProperties2 = dialogProperties;
                        }
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i8 != 0) {
                            dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                        } else {
                            dialogProperties2 = dialogProperties;
                        }
                    }
                    final Function2<? super Composer, ? super Integer, Unit> function18 = function5;
                    final Shape shape15 = shape2;
                    final float f14 = fM2272getTonalElevationD9Ej5fM;
                    final DatePickerColors datePickerColors14 = datePickerColorsColors;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                    }
                    AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                            if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                                }
                                Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                                Shape shape16 = shape15;
                                long containerColor = datePickerColors14.getContainerColor();
                                float f15 = f14;
                                final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function19 = function4;
                                final Function2<? super Composer, ? super Integer, Unit> function110 = function18;
                                final Function2<? super Composer, ? super Integer, Unit> function111 = function2;
                                SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape16, containerColor, 0L, f15, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer3, int i15) {
                                        ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                        if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                            }
                                            Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                            Function3<ColumnScope, Composer, Integer, Unit> function112 = function19;
                                            final Function2<? super Composer, ? super Integer, Unit> function113 = function110;
                                            final Function2<? super Composer, ? super Integer, Unit> function114 = function111;
                                            ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                            Modifier.Companion companion2 = Modifier.INSTANCE;
                                            MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                            Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                            ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                            Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor2);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                            BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                            function112.invoke(columnScopeInstance, composer3, 6);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                            Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor3);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                                composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                                composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                            BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                            ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                                {
                                                    super(2);
                                                }

                                                public Object invoke(Object obj, Object obj2) {
                                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                                    return Unit.INSTANCE;
                                                }

                                                public final void invoke(Composer composer4, int i16) {
                                                    ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                    if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                        if (ComposerKt.isTraceInProgress()) {
                                                            ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                        }
                                                        float f16 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                        float f17 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                        final Function2<? super Composer, ? super Integer, Unit> function115 = function113;
                                                        final Function2<? super Composer, ? super Integer, Unit> function116 = function114;
                                                        AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f16, f17, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                            {
                                                                super(2);
                                                            }

                                                            public Object invoke(Object obj, Object obj2) {
                                                                invoke((Composer) obj, ((Number) obj2).intValue());
                                                                return Unit.INSTANCE;
                                                            }

                                                            public final void invoke(Composer composer5, int i17) {
                                                                ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                                if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                    if (ComposerKt.isTraceInProgress()) {
                                                                        ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                    }
                                                                    Function2<Composer, Integer, Unit> function117 = function115;
                                                                    composer5.startReplaceGroup(-779485335);
                                                                    ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                    if (function117 != null) {
                                                                        function117.invoke(composer5, 0);
                                                                        Unit unit = Unit.INSTANCE;
                                                                    }
                                                                    composer5.endReplaceGroup();
                                                                    function116.invoke(composer5, 0);
                                                                    if (ComposerKt.isTraceInProgress()) {
                                                                        ComposerKt.traceEventEnd();
                                                                        return;
                                                                    }
                                                                    return;
                                                                }
                                                                composer5.skipToGroupEnd();
                                                            }
                                                        }, composer4, 54), composer4, 438);
                                                        if (ComposerKt.isTraceInProgress()) {
                                                            ComposerKt.traceEventEnd();
                                                            return;
                                                        }
                                                        return;
                                                    }
                                                    composer4.skipToGroupEnd();
                                                }
                                            }, composer3, 54), composer3, 384);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer3.skipToGroupEnd();
                                    }
                                }, composer2, 54), composer2, 12582918, 104);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    function6 = function18;
                    shape3 = shape15;
                    f2 = f14;
                    datePickerColors2 = datePickerColors14;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final DialogProperties dialogProperties8 = dialogProperties2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            DatePickerDialog_androidKt.m2273DatePickerDialogGmEhDVc(function0, function2, modifier2, function6, shape3, f2, datePickerColors2, dialogProperties8, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            fM2272getTonalElevationD9Ej5fM = f;
            if ((1572864 & i) == 0) {
                if ((i2 & 64) == 0) {
                    datePickerColorsColors = datePickerColors;
                    if (composerStartRestartGroup.changed(datePickerColorsColors)) {
                    }
                    i3 |= i13;
                } else {
                    datePickerColorsColors = datePickerColors;
                }
                i3 |= i13;
            } else {
                datePickerColorsColors = datePickerColors;
            }
            i8 = i2 & Fields.SpotShadowColor;
            if (i8 != 0) {
                i3 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changed(dialogProperties)) {
                    i9 = 8388608;
                } else {
                    i9 = 4194304;
                }
                i3 |= i9;
            }
            if ((i2 & Fields.RotationX) != 0) {
                if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i10 = 67108864;
                    } else {
                        i10 = 33554432;
                    }
                    i3 |= i10;
                }
                if ((i3 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) == 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i8 != 0) {
                            dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                        } else {
                            dialogProperties2 = dialogProperties;
                        }
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i8 != 0) {
                            dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                        } else {
                            dialogProperties2 = dialogProperties;
                        }
                    }
                    final Function2<? super Composer, ? super Integer, Unit> function19 = function5;
                    final Shape shape16 = shape2;
                    final float f15 = fM2272getTonalElevationD9Ej5fM;
                    final DatePickerColors datePickerColors15 = datePickerColorsColors;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                    }
                    AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                            if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                                }
                                Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                                Shape shape17 = shape16;
                                long containerColor = datePickerColors15.getContainerColor();
                                float f16 = f15;
                                final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function110 = function4;
                                final Function2<? super Composer, ? super Integer, Unit> function111 = function19;
                                final Function2<? super Composer, ? super Integer, Unit> function112 = function2;
                                SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape17, containerColor, 0L, f16, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer3, int i15) {
                                        ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                        if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                            }
                                            Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                            Function3<ColumnScope, Composer, Integer, Unit> function113 = function110;
                                            final Function2<? super Composer, ? super Integer, Unit> function114 = function111;
                                            final Function2<? super Composer, ? super Integer, Unit> function115 = function112;
                                            ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                            Modifier.Companion companion2 = Modifier.INSTANCE;
                                            MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                            Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                            ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                            Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor2);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                            BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                            function113.invoke(columnScopeInstance, composer3, 6);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                            Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor3);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                                composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                                composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                            BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                            ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                                {
                                                    super(2);
                                                }

                                                public Object invoke(Object obj, Object obj2) {
                                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                                    return Unit.INSTANCE;
                                                }

                                                public final void invoke(Composer composer4, int i16) {
                                                    ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                    if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                        if (ComposerKt.isTraceInProgress()) {
                                                            ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                        }
                                                        float f17 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                        float f18 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                        final Function2<? super Composer, ? super Integer, Unit> function116 = function114;
                                                        final Function2<? super Composer, ? super Integer, Unit> function117 = function115;
                                                        AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f17, f18, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                            {
                                                                super(2);
                                                            }

                                                            public Object invoke(Object obj, Object obj2) {
                                                                invoke((Composer) obj, ((Number) obj2).intValue());
                                                                return Unit.INSTANCE;
                                                            }

                                                            public final void invoke(Composer composer5, int i17) {
                                                                ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                                if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                    if (ComposerKt.isTraceInProgress()) {
                                                                        ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                    }
                                                                    Function2<Composer, Integer, Unit> function118 = function116;
                                                                    composer5.startReplaceGroup(-779485335);
                                                                    ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                    if (function118 != null) {
                                                                        function118.invoke(composer5, 0);
                                                                        Unit unit = Unit.INSTANCE;
                                                                    }
                                                                    composer5.endReplaceGroup();
                                                                    function117.invoke(composer5, 0);
                                                                    if (ComposerKt.isTraceInProgress()) {
                                                                        ComposerKt.traceEventEnd();
                                                                        return;
                                                                    }
                                                                    return;
                                                                }
                                                                composer5.skipToGroupEnd();
                                                            }
                                                        }, composer4, 54), composer4, 438);
                                                        if (ComposerKt.isTraceInProgress()) {
                                                            ComposerKt.traceEventEnd();
                                                            return;
                                                        }
                                                        return;
                                                    }
                                                    composer4.skipToGroupEnd();
                                                }
                                            }, composer3, 54), composer3, 384);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer3.skipToGroupEnd();
                                    }
                                }, composer2, 54), composer2, 12582918, 104);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    function6 = function19;
                    shape3 = shape16;
                    f2 = f15;
                    datePickerColors2 = datePickerColors15;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) == 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i8 != 0) {
                            dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                        } else {
                            dialogProperties2 = dialogProperties;
                        }
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i8 != 0) {
                            dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                        } else {
                            dialogProperties2 = dialogProperties;
                        }
                    }
                    final Function2<? super Composer, ? super Integer, Unit> function110 = function5;
                    final Shape shape17 = shape2;
                    final float f16 = fM2272getTonalElevationD9Ej5fM;
                    final DatePickerColors datePickerColors16 = datePickerColorsColors;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                    }
                    AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                            if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                                }
                                Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                                Shape shape18 = shape17;
                                long containerColor = datePickerColors16.getContainerColor();
                                float f17 = f16;
                                final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function111 = function4;
                                final Function2<? super Composer, ? super Integer, Unit> function112 = function110;
                                final Function2<? super Composer, ? super Integer, Unit> function113 = function2;
                                SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape18, containerColor, 0L, f17, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer3, int i15) {
                                        ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                        if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                            }
                                            Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                            Function3<ColumnScope, Composer, Integer, Unit> function114 = function111;
                                            final Function2<? super Composer, ? super Integer, Unit> function115 = function112;
                                            final Function2<? super Composer, ? super Integer, Unit> function116 = function113;
                                            ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                            Modifier.Companion companion2 = Modifier.INSTANCE;
                                            MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                            Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                            ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                            Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor2);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                            BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                            function114.invoke(columnScopeInstance, composer3, 6);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                            Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor3);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                                composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                                composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                            BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                            ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                                {
                                                    super(2);
                                                }

                                                public Object invoke(Object obj, Object obj2) {
                                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                                    return Unit.INSTANCE;
                                                }

                                                public final void invoke(Composer composer4, int i16) {
                                                    ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                    if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                        if (ComposerKt.isTraceInProgress()) {
                                                            ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                        }
                                                        float f18 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                        float f19 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                        final Function2<? super Composer, ? super Integer, Unit> function117 = function115;
                                                        final Function2<? super Composer, ? super Integer, Unit> function118 = function116;
                                                        AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f18, f19, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                            {
                                                                super(2);
                                                            }

                                                            public Object invoke(Object obj, Object obj2) {
                                                                invoke((Composer) obj, ((Number) obj2).intValue());
                                                                return Unit.INSTANCE;
                                                            }

                                                            public final void invoke(Composer composer5, int i17) {
                                                                ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                                if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                    if (ComposerKt.isTraceInProgress()) {
                                                                        ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                    }
                                                                    Function2<Composer, Integer, Unit> function119 = function117;
                                                                    composer5.startReplaceGroup(-779485335);
                                                                    ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                    if (function119 != null) {
                                                                        function119.invoke(composer5, 0);
                                                                        Unit unit = Unit.INSTANCE;
                                                                    }
                                                                    composer5.endReplaceGroup();
                                                                    function118.invoke(composer5, 0);
                                                                    if (ComposerKt.isTraceInProgress()) {
                                                                        ComposerKt.traceEventEnd();
                                                                        return;
                                                                    }
                                                                    return;
                                                                }
                                                                composer5.skipToGroupEnd();
                                                            }
                                                        }, composer4, 54), composer4, 438);
                                                        if (ComposerKt.isTraceInProgress()) {
                                                            ComposerKt.traceEventEnd();
                                                            return;
                                                        }
                                                        return;
                                                    }
                                                    composer4.skipToGroupEnd();
                                                }
                                            }, composer3, 54), composer3, 384);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer3.skipToGroupEnd();
                                    }
                                }, composer2, 54), composer2, 12582918, 104);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    function6 = function110;
                    shape3 = shape17;
                    f2 = f16;
                    datePickerColors2 = datePickerColors16;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final DialogProperties dialogProperties9 = dialogProperties2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            DatePickerDialog_androidKt.m2273DatePickerDialogGmEhDVc(function0, function2, modifier2, function6, shape3, f2, datePickerColors2, dialogProperties9, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 100663296;
            if ((i3 & 38347923) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) == 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i8 != 0) {
                        dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                    } else {
                        dialogProperties2 = dialogProperties;
                    }
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i8 != 0) {
                        dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                    } else {
                        dialogProperties2 = dialogProperties;
                    }
                }
                final Function2<? super Composer, ? super Integer, Unit> function111 = function5;
                final Shape shape18 = shape2;
                final float f17 = fM2272getTonalElevationD9Ej5fM;
                final DatePickerColors datePickerColors17 = datePickerColorsColors;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                }
                AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i14) {
                        ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                        if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                            }
                            Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                            Shape shape19 = shape18;
                            long containerColor = datePickerColors17.getContainerColor();
                            float f18 = f17;
                            final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function112 = function4;
                            final Function2<? super Composer, ? super Integer, Unit> function113 = function111;
                            final Function2<? super Composer, ? super Integer, Unit> function114 = function2;
                            SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape19, containerColor, 0L, f18, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer3, int i15) {
                                    ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                    if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                        }
                                        Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                        Function3<ColumnScope, Composer, Integer, Unit> function115 = function112;
                                        final Function2<? super Composer, ? super Integer, Unit> function116 = function113;
                                        final Function2<? super Composer, ? super Integer, Unit> function117 = function114;
                                        ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                        Modifier.Companion companion2 = Modifier.INSTANCE;
                                        MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                        Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                        ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                        Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                        ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                        Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor2);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                            composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                            composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                        BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                        function115.invoke(columnScopeInstance, composer3, 6);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                        ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                        Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor3);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                            composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                            composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                        BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                        ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                            {
                                                super(2);
                                            }

                                            public Object invoke(Object obj, Object obj2) {
                                                invoke((Composer) obj, ((Number) obj2).intValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(Composer composer4, int i16) {
                                                ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                    if (ComposerKt.isTraceInProgress()) {
                                                        ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                    }
                                                    float f19 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                    float f110 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                    final Function2<? super Composer, ? super Integer, Unit> function118 = function116;
                                                    final Function2<? super Composer, ? super Integer, Unit> function119 = function117;
                                                    AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f19, f110, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                        {
                                                            super(2);
                                                        }

                                                        public Object invoke(Object obj, Object obj2) {
                                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                                            return Unit.INSTANCE;
                                                        }

                                                        public final void invoke(Composer composer5, int i17) {
                                                            ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                            if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                if (ComposerKt.isTraceInProgress()) {
                                                                    ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                }
                                                                Function2<Composer, Integer, Unit> function1110 = function118;
                                                                composer5.startReplaceGroup(-779485335);
                                                                ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                if (function1110 != null) {
                                                                    function1110.invoke(composer5, 0);
                                                                    Unit unit = Unit.INSTANCE;
                                                                }
                                                                composer5.endReplaceGroup();
                                                                function119.invoke(composer5, 0);
                                                                if (ComposerKt.isTraceInProgress()) {
                                                                    ComposerKt.traceEventEnd();
                                                                    return;
                                                                }
                                                                return;
                                                            }
                                                            composer5.skipToGroupEnd();
                                                        }
                                                    }, composer4, 54), composer4, 438);
                                                    if (ComposerKt.isTraceInProgress()) {
                                                        ComposerKt.traceEventEnd();
                                                        return;
                                                    }
                                                    return;
                                                }
                                                composer4.skipToGroupEnd();
                                            }
                                        }, composer3, 54), composer3, 384);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer3.skipToGroupEnd();
                                }
                            }, composer2, 54), composer2, 12582918, 104);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                function6 = function111;
                shape3 = shape18;
                f2 = f17;
                datePickerColors2 = datePickerColors17;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) == 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i8 != 0) {
                        dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                    } else {
                        dialogProperties2 = dialogProperties;
                    }
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i8 != 0) {
                        dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                    } else {
                        dialogProperties2 = dialogProperties;
                    }
                }
                final Function2<? super Composer, ? super Integer, Unit> function112 = function5;
                final Shape shape19 = shape2;
                final float f18 = fM2272getTonalElevationD9Ej5fM;
                final DatePickerColors datePickerColors18 = datePickerColorsColors;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                }
                AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i14) {
                        ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                        if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                            }
                            Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                            Shape shape110 = shape19;
                            long containerColor = datePickerColors18.getContainerColor();
                            float f19 = f18;
                            final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function113 = function4;
                            final Function2<? super Composer, ? super Integer, Unit> function114 = function112;
                            final Function2<? super Composer, ? super Integer, Unit> function115 = function2;
                            SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape110, containerColor, 0L, f19, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer3, int i15) {
                                    ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                    if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                        }
                                        Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                        Function3<ColumnScope, Composer, Integer, Unit> function116 = function113;
                                        final Function2<? super Composer, ? super Integer, Unit> function117 = function114;
                                        final Function2<? super Composer, ? super Integer, Unit> function118 = function115;
                                        ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                        Modifier.Companion companion2 = Modifier.INSTANCE;
                                        MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                        Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                        ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                        Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                        ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                        Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor2);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                            composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                            composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                        BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                        function116.invoke(columnScopeInstance, composer3, 6);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                        ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                        Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor3);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                            composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                            composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                        BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                        ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                            {
                                                super(2);
                                            }

                                            public Object invoke(Object obj, Object obj2) {
                                                invoke((Composer) obj, ((Number) obj2).intValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(Composer composer4, int i16) {
                                                ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                    if (ComposerKt.isTraceInProgress()) {
                                                        ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                    }
                                                    float f110 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                    float f111 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                    final Function2<? super Composer, ? super Integer, Unit> function119 = function117;
                                                    final Function2<? super Composer, ? super Integer, Unit> function1110 = function118;
                                                    AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f110, f111, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                        {
                                                            super(2);
                                                        }

                                                        public Object invoke(Object obj, Object obj2) {
                                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                                            return Unit.INSTANCE;
                                                        }

                                                        public final void invoke(Composer composer5, int i17) {
                                                            ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                            if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                if (ComposerKt.isTraceInProgress()) {
                                                                    ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                }
                                                                Function2<Composer, Integer, Unit> function1111 = function119;
                                                                composer5.startReplaceGroup(-779485335);
                                                                ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                if (function1111 != null) {
                                                                    function1111.invoke(composer5, 0);
                                                                    Unit unit = Unit.INSTANCE;
                                                                }
                                                                composer5.endReplaceGroup();
                                                                function1110.invoke(composer5, 0);
                                                                if (ComposerKt.isTraceInProgress()) {
                                                                    ComposerKt.traceEventEnd();
                                                                    return;
                                                                }
                                                                return;
                                                            }
                                                            composer5.skipToGroupEnd();
                                                        }
                                                    }, composer4, 54), composer4, 438);
                                                    if (ComposerKt.isTraceInProgress()) {
                                                        ComposerKt.traceEventEnd();
                                                        return;
                                                    }
                                                    return;
                                                }
                                                composer4.skipToGroupEnd();
                                            }
                                        }, composer3, 54), composer3, 384);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer3.skipToGroupEnd();
                                }
                            }, composer2, 54), composer2, 12582918, 104);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                function6 = function112;
                shape3 = shape19;
                f2 = f18;
                datePickerColors2 = datePickerColors18;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final DialogProperties dialogProperties10 = dialogProperties2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i14) {
                        DatePickerDialog_androidKt.m2273DatePickerDialogGmEhDVc(function0, function2, modifier2, function6, shape3, f2, datePickerColors2, dialogProperties10, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        i4 = i2 & 8;
        if (i4 != 0) {
            if ((i & 3072) == 0) {
                function5 = function3;
                if (composerStartRestartGroup.changedInstance(function5)) {
                    i5 = Fields.CameraDistance;
                } else {
                    i5 = Fields.RotationZ;
                }
                i3 |= i5;
            }
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    shape2 = shape;
                    if (composerStartRestartGroup.changed(shape2)) {
                        i11 = Fields.Clip;
                    }
                    i3 |= i11;
                } else {
                    shape2 = shape;
                }
                i11 = Fields.Shape;
                i3 |= i11;
            } else {
                shape2 = shape;
            }
            i6 = i2 & 32;
            if (i6 != 0) {
                if ((196608 & i) == 0) {
                    fM2272getTonalElevationD9Ej5fM = f;
                    if (composerStartRestartGroup.changed(fM2272getTonalElevationD9Ej5fM)) {
                        i7 = Fields.RenderEffect;
                    } else {
                        i7 = 65536;
                    }
                    i3 |= i7;
                }
                if ((1572864 & i) == 0) {
                    if ((i2 & 64) == 0) {
                        datePickerColorsColors = datePickerColors;
                        if (composerStartRestartGroup.changed(datePickerColorsColors)) {
                        }
                        i3 |= i13;
                    } else {
                        datePickerColorsColors = datePickerColors;
                    }
                    i3 |= i13;
                } else {
                    datePickerColorsColors = datePickerColors;
                }
                i8 = i2 & Fields.SpotShadowColor;
                if (i8 != 0) {
                    i3 |= 12582912;
                } else if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(dialogProperties)) {
                        i9 = 8388608;
                    } else {
                        i9 = 4194304;
                    }
                    i3 |= i9;
                }
                if ((i2 & Fields.RotationX) != 0) {
                    if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changedInstance(function4)) {
                            i10 = 67108864;
                        } else {
                            i10 = 33554432;
                        }
                        i3 |= i10;
                    }
                    if ((i3 & 38347923) == 38347922) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) == 0) {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i4 != 0) {
                                function5 = null;
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            }
                            if (i6 != 0) {
                                fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                            if (i8 != 0) {
                                dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                            } else {
                                dialogProperties2 = dialogProperties;
                            }
                        } else {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i4 != 0) {
                                function5 = null;
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            }
                            if (i6 != 0) {
                                fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                            if (i8 != 0) {
                                dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                            } else {
                                dialogProperties2 = dialogProperties;
                            }
                        }
                        final Function2<? super Composer, ? super Integer, Unit> function113 = function5;
                        final Shape shape110 = shape2;
                        final float f19 = fM2272getTonalElevationD9Ej5fM;
                        final DatePickerColors datePickerColors19 = datePickerColorsColors;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                        }
                        AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i14) {
                                ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                                if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                                    }
                                    Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                                    Shape shape111 = shape110;
                                    long containerColor = datePickerColors19.getContainerColor();
                                    float f110 = f19;
                                    final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function114 = function4;
                                    final Function2<? super Composer, ? super Integer, Unit> function115 = function113;
                                    final Function2<? super Composer, ? super Integer, Unit> function116 = function2;
                                    SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape111, containerColor, 0L, f110, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer3, int i15) {
                                            ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                            if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                                }
                                                Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                                Function3<ColumnScope, Composer, Integer, Unit> function117 = function114;
                                                final Function2<? super Composer, ? super Integer, Unit> function118 = function115;
                                                final Function2<? super Composer, ? super Integer, Unit> function119 = function116;
                                                ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                                Modifier.Companion companion2 = Modifier.INSTANCE;
                                                MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                                Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                if (!(composer3.getApplier() instanceof Applier)) {
                                                    ComposablesKt.invalidApplier();
                                                }
                                                composer3.startReusableNode();
                                                if (composer3.getInserting()) {
                                                    composer3.createNode(constructor);
                                                } else {
                                                    composer3.useNode();
                                                }
                                                Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                                }
                                                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                                ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                                ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                                ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                                Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                                ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                                Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                                Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                if (!(composer3.getApplier() instanceof Applier)) {
                                                    ComposablesKt.invalidApplier();
                                                }
                                                composer3.startReusableNode();
                                                if (composer3.getInserting()) {
                                                    composer3.createNode(constructor2);
                                                } else {
                                                    composer3.useNode();
                                                }
                                                Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                                Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                    composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                    composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                                }
                                                Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                                ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                                BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                                ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                                function117.invoke(columnScopeInstance, composer3, 6);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                composer3.endNode();
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                                ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                                Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                                Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                if (!(composer3.getApplier() instanceof Applier)) {
                                                    ComposablesKt.invalidApplier();
                                                }
                                                composer3.startReusableNode();
                                                if (composer3.getInserting()) {
                                                    composer3.createNode(constructor3);
                                                } else {
                                                    composer3.useNode();
                                                }
                                                Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                                Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                                    composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                                    composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                                }
                                                Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                                ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                                BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                                ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                                ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                                    {
                                                        super(2);
                                                    }

                                                    public Object invoke(Object obj, Object obj2) {
                                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                                        return Unit.INSTANCE;
                                                    }

                                                    public final void invoke(Composer composer4, int i16) {
                                                        ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                        if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                            if (ComposerKt.isTraceInProgress()) {
                                                                ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                            }
                                                            float f111 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                            float f112 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                            final Function2<? super Composer, ? super Integer, Unit> function1110 = function118;
                                                            final Function2<? super Composer, ? super Integer, Unit> function1111 = function119;
                                                            AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f111, f112, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                                {
                                                                    super(2);
                                                                }

                                                                public Object invoke(Object obj, Object obj2) {
                                                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                                                    return Unit.INSTANCE;
                                                                }

                                                                public final void invoke(Composer composer5, int i17) {
                                                                    ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                                    if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                        if (ComposerKt.isTraceInProgress()) {
                                                                            ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                        }
                                                                        Function2<Composer, Integer, Unit> function1112 = function1110;
                                                                        composer5.startReplaceGroup(-779485335);
                                                                        ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                        if (function1112 != null) {
                                                                            function1112.invoke(composer5, 0);
                                                                            Unit unit = Unit.INSTANCE;
                                                                        }
                                                                        composer5.endReplaceGroup();
                                                                        function1111.invoke(composer5, 0);
                                                                        if (ComposerKt.isTraceInProgress()) {
                                                                            ComposerKt.traceEventEnd();
                                                                            return;
                                                                        }
                                                                        return;
                                                                    }
                                                                    composer5.skipToGroupEnd();
                                                                }
                                                            }, composer4, 54), composer4, 438);
                                                            if (ComposerKt.isTraceInProgress()) {
                                                                ComposerKt.traceEventEnd();
                                                                return;
                                                            }
                                                            return;
                                                        }
                                                        composer4.skipToGroupEnd();
                                                    }
                                                }, composer3, 54), composer3, 384);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                composer3.endNode();
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                composer3.endNode();
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer3.skipToGroupEnd();
                                        }
                                    }, composer2, 54), composer2, 12582918, 104);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        function6 = function113;
                        shape3 = shape110;
                        f2 = f19;
                        datePickerColors2 = datePickerColors19;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) == 0) {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i4 != 0) {
                                function5 = null;
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            }
                            if (i6 != 0) {
                                fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                            if (i8 != 0) {
                                dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                            } else {
                                dialogProperties2 = dialogProperties;
                            }
                        } else {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i4 != 0) {
                                function5 = null;
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            }
                            if (i6 != 0) {
                                fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                            if (i8 != 0) {
                                dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                            } else {
                                dialogProperties2 = dialogProperties;
                            }
                        }
                        final Function2<? super Composer, ? super Integer, Unit> function114 = function5;
                        final Shape shape111 = shape2;
                        final float f110 = fM2272getTonalElevationD9Ej5fM;
                        final DatePickerColors datePickerColors110 = datePickerColorsColors;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                        }
                        AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i14) {
                                ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                                if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                                    }
                                    Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                                    Shape shape112 = shape111;
                                    long containerColor = datePickerColors110.getContainerColor();
                                    float f111 = f110;
                                    final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function115 = function4;
                                    final Function2<? super Composer, ? super Integer, Unit> function116 = function114;
                                    final Function2<? super Composer, ? super Integer, Unit> function117 = function2;
                                    SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape112, containerColor, 0L, f111, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer3, int i15) {
                                            ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                            if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                                }
                                                Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                                Function3<ColumnScope, Composer, Integer, Unit> function118 = function115;
                                                final Function2<? super Composer, ? super Integer, Unit> function119 = function116;
                                                final Function2<? super Composer, ? super Integer, Unit> function1110 = function117;
                                                ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                                Modifier.Companion companion2 = Modifier.INSTANCE;
                                                MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                                Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                if (!(composer3.getApplier() instanceof Applier)) {
                                                    ComposablesKt.invalidApplier();
                                                }
                                                composer3.startReusableNode();
                                                if (composer3.getInserting()) {
                                                    composer3.createNode(constructor);
                                                } else {
                                                    composer3.useNode();
                                                }
                                                Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                                }
                                                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                                ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                                ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                                ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                                Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                                ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                                Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                                Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                if (!(composer3.getApplier() instanceof Applier)) {
                                                    ComposablesKt.invalidApplier();
                                                }
                                                composer3.startReusableNode();
                                                if (composer3.getInserting()) {
                                                    composer3.createNode(constructor2);
                                                } else {
                                                    composer3.useNode();
                                                }
                                                Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                                Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                    composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                    composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                                }
                                                Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                                ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                                BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                                ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                                function118.invoke(columnScopeInstance, composer3, 6);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                composer3.endNode();
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                                ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                                Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                                Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                if (!(composer3.getApplier() instanceof Applier)) {
                                                    ComposablesKt.invalidApplier();
                                                }
                                                composer3.startReusableNode();
                                                if (composer3.getInserting()) {
                                                    composer3.createNode(constructor3);
                                                } else {
                                                    composer3.useNode();
                                                }
                                                Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                                Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                                    composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                                    composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                                }
                                                Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                                ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                                BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                                ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                                ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                                    {
                                                        super(2);
                                                    }

                                                    public Object invoke(Object obj, Object obj2) {
                                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                                        return Unit.INSTANCE;
                                                    }

                                                    public final void invoke(Composer composer4, int i16) {
                                                        ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                        if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                            if (ComposerKt.isTraceInProgress()) {
                                                                ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                            }
                                                            float f112 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                            float f113 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                            final Function2<? super Composer, ? super Integer, Unit> function1111 = function119;
                                                            final Function2<? super Composer, ? super Integer, Unit> function1112 = function1110;
                                                            AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f112, f113, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                                {
                                                                    super(2);
                                                                }

                                                                public Object invoke(Object obj, Object obj2) {
                                                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                                                    return Unit.INSTANCE;
                                                                }

                                                                public final void invoke(Composer composer5, int i17) {
                                                                    ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                                    if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                        if (ComposerKt.isTraceInProgress()) {
                                                                            ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                        }
                                                                        Function2<Composer, Integer, Unit> function1113 = function1111;
                                                                        composer5.startReplaceGroup(-779485335);
                                                                        ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                        if (function1113 != null) {
                                                                            function1113.invoke(composer5, 0);
                                                                            Unit unit = Unit.INSTANCE;
                                                                        }
                                                                        composer5.endReplaceGroup();
                                                                        function1112.invoke(composer5, 0);
                                                                        if (ComposerKt.isTraceInProgress()) {
                                                                            ComposerKt.traceEventEnd();
                                                                            return;
                                                                        }
                                                                        return;
                                                                    }
                                                                    composer5.skipToGroupEnd();
                                                                }
                                                            }, composer4, 54), composer4, 438);
                                                            if (ComposerKt.isTraceInProgress()) {
                                                                ComposerKt.traceEventEnd();
                                                                return;
                                                            }
                                                            return;
                                                        }
                                                        composer4.skipToGroupEnd();
                                                    }
                                                }, composer3, 54), composer3, 384);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                composer3.endNode();
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                composer3.endNode();
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer3.skipToGroupEnd();
                                        }
                                    }, composer2, 54), composer2, 12582918, 104);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        function6 = function114;
                        shape3 = shape111;
                        f2 = f110;
                        datePickerColors2 = datePickerColors110;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final DialogProperties dialogProperties11 = dialogProperties2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i14) {
                                DatePickerDialog_androidKt.m2273DatePickerDialogGmEhDVc(function0, function2, modifier2, function6, shape3, f2, datePickerColors2, dialogProperties11, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 100663296;
                if ((i3 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) == 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i8 != 0) {
                            dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                        } else {
                            dialogProperties2 = dialogProperties;
                        }
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i8 != 0) {
                            dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                        } else {
                            dialogProperties2 = dialogProperties;
                        }
                    }
                    final Function2<? super Composer, ? super Integer, Unit> function115 = function5;
                    final Shape shape112 = shape2;
                    final float f111 = fM2272getTonalElevationD9Ej5fM;
                    final DatePickerColors datePickerColors111 = datePickerColorsColors;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                    }
                    AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                            if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                                }
                                Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                                Shape shape113 = shape112;
                                long containerColor = datePickerColors111.getContainerColor();
                                float f112 = f111;
                                final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function116 = function4;
                                final Function2<? super Composer, ? super Integer, Unit> function117 = function115;
                                final Function2<? super Composer, ? super Integer, Unit> function118 = function2;
                                SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape113, containerColor, 0L, f112, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer3, int i15) {
                                        ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                        if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                            }
                                            Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                            Function3<ColumnScope, Composer, Integer, Unit> function119 = function116;
                                            final Function2<? super Composer, ? super Integer, Unit> function1110 = function117;
                                            final Function2<? super Composer, ? super Integer, Unit> function1111 = function118;
                                            ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                            Modifier.Companion companion2 = Modifier.INSTANCE;
                                            MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                            Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                            ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                            Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor2);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                            BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                            function119.invoke(columnScopeInstance, composer3, 6);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                            Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor3);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                                composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                                composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                            BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                            ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                                {
                                                    super(2);
                                                }

                                                public Object invoke(Object obj, Object obj2) {
                                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                                    return Unit.INSTANCE;
                                                }

                                                public final void invoke(Composer composer4, int i16) {
                                                    ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                    if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                        if (ComposerKt.isTraceInProgress()) {
                                                            ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                        }
                                                        float f113 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                        float f114 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                        final Function2<? super Composer, ? super Integer, Unit> function1112 = function1110;
                                                        final Function2<? super Composer, ? super Integer, Unit> function1113 = function1111;
                                                        AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f113, f114, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                            {
                                                                super(2);
                                                            }

                                                            public Object invoke(Object obj, Object obj2) {
                                                                invoke((Composer) obj, ((Number) obj2).intValue());
                                                                return Unit.INSTANCE;
                                                            }

                                                            public final void invoke(Composer composer5, int i17) {
                                                                ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                                if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                    if (ComposerKt.isTraceInProgress()) {
                                                                        ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                    }
                                                                    Function2<Composer, Integer, Unit> function1114 = function1112;
                                                                    composer5.startReplaceGroup(-779485335);
                                                                    ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                    if (function1114 != null) {
                                                                        function1114.invoke(composer5, 0);
                                                                        Unit unit = Unit.INSTANCE;
                                                                    }
                                                                    composer5.endReplaceGroup();
                                                                    function1113.invoke(composer5, 0);
                                                                    if (ComposerKt.isTraceInProgress()) {
                                                                        ComposerKt.traceEventEnd();
                                                                        return;
                                                                    }
                                                                    return;
                                                                }
                                                                composer5.skipToGroupEnd();
                                                            }
                                                        }, composer4, 54), composer4, 438);
                                                        if (ComposerKt.isTraceInProgress()) {
                                                            ComposerKt.traceEventEnd();
                                                            return;
                                                        }
                                                        return;
                                                    }
                                                    composer4.skipToGroupEnd();
                                                }
                                            }, composer3, 54), composer3, 384);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer3.skipToGroupEnd();
                                    }
                                }, composer2, 54), composer2, 12582918, 104);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    function6 = function115;
                    shape3 = shape112;
                    f2 = f111;
                    datePickerColors2 = datePickerColors111;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) == 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i8 != 0) {
                            dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                        } else {
                            dialogProperties2 = dialogProperties;
                        }
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i8 != 0) {
                            dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                        } else {
                            dialogProperties2 = dialogProperties;
                        }
                    }
                    final Function2<? super Composer, ? super Integer, Unit> function116 = function5;
                    final Shape shape113 = shape2;
                    final float f112 = fM2272getTonalElevationD9Ej5fM;
                    final DatePickerColors datePickerColors112 = datePickerColorsColors;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                    }
                    AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                            if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                                }
                                Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                                Shape shape114 = shape113;
                                long containerColor = datePickerColors112.getContainerColor();
                                float f113 = f112;
                                final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function117 = function4;
                                final Function2<? super Composer, ? super Integer, Unit> function118 = function116;
                                final Function2<? super Composer, ? super Integer, Unit> function119 = function2;
                                SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape114, containerColor, 0L, f113, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer3, int i15) {
                                        ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                        if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                            }
                                            Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                            Function3<ColumnScope, Composer, Integer, Unit> function1110 = function117;
                                            final Function2<? super Composer, ? super Integer, Unit> function1111 = function118;
                                            final Function2<? super Composer, ? super Integer, Unit> function1112 = function119;
                                            ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                            Modifier.Companion companion2 = Modifier.INSTANCE;
                                            MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                            Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                            ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                            Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor2);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                            BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                            function1110.invoke(columnScopeInstance, composer3, 6);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                            Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor3);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                                composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                                composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                            BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                            ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                                {
                                                    super(2);
                                                }

                                                public Object invoke(Object obj, Object obj2) {
                                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                                    return Unit.INSTANCE;
                                                }

                                                public final void invoke(Composer composer4, int i16) {
                                                    ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                    if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                        if (ComposerKt.isTraceInProgress()) {
                                                            ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                        }
                                                        float f114 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                        float f115 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                        final Function2<? super Composer, ? super Integer, Unit> function1113 = function1111;
                                                        final Function2<? super Composer, ? super Integer, Unit> function1114 = function1112;
                                                        AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f114, f115, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                            {
                                                                super(2);
                                                            }

                                                            public Object invoke(Object obj, Object obj2) {
                                                                invoke((Composer) obj, ((Number) obj2).intValue());
                                                                return Unit.INSTANCE;
                                                            }

                                                            public final void invoke(Composer composer5, int i17) {
                                                                ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                                if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                    if (ComposerKt.isTraceInProgress()) {
                                                                        ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                    }
                                                                    Function2<Composer, Integer, Unit> function1115 = function1113;
                                                                    composer5.startReplaceGroup(-779485335);
                                                                    ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                    if (function1115 != null) {
                                                                        function1115.invoke(composer5, 0);
                                                                        Unit unit = Unit.INSTANCE;
                                                                    }
                                                                    composer5.endReplaceGroup();
                                                                    function1114.invoke(composer5, 0);
                                                                    if (ComposerKt.isTraceInProgress()) {
                                                                        ComposerKt.traceEventEnd();
                                                                        return;
                                                                    }
                                                                    return;
                                                                }
                                                                composer5.skipToGroupEnd();
                                                            }
                                                        }, composer4, 54), composer4, 438);
                                                        if (ComposerKt.isTraceInProgress()) {
                                                            ComposerKt.traceEventEnd();
                                                            return;
                                                        }
                                                        return;
                                                    }
                                                    composer4.skipToGroupEnd();
                                                }
                                            }, composer3, 54), composer3, 384);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer3.skipToGroupEnd();
                                    }
                                }, composer2, 54), composer2, 12582918, 104);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    function6 = function116;
                    shape3 = shape113;
                    f2 = f112;
                    datePickerColors2 = datePickerColors112;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final DialogProperties dialogProperties12 = dialogProperties2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            DatePickerDialog_androidKt.m2273DatePickerDialogGmEhDVc(function0, function2, modifier2, function6, shape3, f2, datePickerColors2, dialogProperties12, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            fM2272getTonalElevationD9Ej5fM = f;
            if ((1572864 & i) == 0) {
                if ((i2 & 64) == 0) {
                    datePickerColorsColors = datePickerColors;
                    if (composerStartRestartGroup.changed(datePickerColorsColors)) {
                    }
                    i3 |= i13;
                } else {
                    datePickerColorsColors = datePickerColors;
                }
                i3 |= i13;
            } else {
                datePickerColorsColors = datePickerColors;
            }
            i8 = i2 & Fields.SpotShadowColor;
            if (i8 != 0) {
                i3 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changed(dialogProperties)) {
                    i9 = 8388608;
                } else {
                    i9 = 4194304;
                }
                i3 |= i9;
            }
            if ((i2 & Fields.RotationX) != 0) {
                if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i10 = 67108864;
                    } else {
                        i10 = 33554432;
                    }
                    i3 |= i10;
                }
                if ((i3 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) == 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i8 != 0) {
                            dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                        } else {
                            dialogProperties2 = dialogProperties;
                        }
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i8 != 0) {
                            dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                        } else {
                            dialogProperties2 = dialogProperties;
                        }
                    }
                    final Function2<? super Composer, ? super Integer, Unit> function117 = function5;
                    final Shape shape114 = shape2;
                    final float f113 = fM2272getTonalElevationD9Ej5fM;
                    final DatePickerColors datePickerColors113 = datePickerColorsColors;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                    }
                    AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                            if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                                }
                                Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                                Shape shape115 = shape114;
                                long containerColor = datePickerColors113.getContainerColor();
                                float f114 = f113;
                                final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function118 = function4;
                                final Function2<? super Composer, ? super Integer, Unit> function119 = function117;
                                final Function2<? super Composer, ? super Integer, Unit> function1110 = function2;
                                SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape115, containerColor, 0L, f114, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer3, int i15) {
                                        ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                        if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                            }
                                            Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                            Function3<ColumnScope, Composer, Integer, Unit> function1111 = function118;
                                            final Function2<? super Composer, ? super Integer, Unit> function1112 = function119;
                                            final Function2<? super Composer, ? super Integer, Unit> function1113 = function1110;
                                            ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                            Modifier.Companion companion2 = Modifier.INSTANCE;
                                            MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                            Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                            ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                            Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor2);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                            BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                            function1111.invoke(columnScopeInstance, composer3, 6);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                            Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor3);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                                composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                                composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                            BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                            ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                                {
                                                    super(2);
                                                }

                                                public Object invoke(Object obj, Object obj2) {
                                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                                    return Unit.INSTANCE;
                                                }

                                                public final void invoke(Composer composer4, int i16) {
                                                    ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                    if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                        if (ComposerKt.isTraceInProgress()) {
                                                            ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                        }
                                                        float f115 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                        float f116 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                        final Function2<? super Composer, ? super Integer, Unit> function1114 = function1112;
                                                        final Function2<? super Composer, ? super Integer, Unit> function1115 = function1113;
                                                        AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f115, f116, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                            {
                                                                super(2);
                                                            }

                                                            public Object invoke(Object obj, Object obj2) {
                                                                invoke((Composer) obj, ((Number) obj2).intValue());
                                                                return Unit.INSTANCE;
                                                            }

                                                            public final void invoke(Composer composer5, int i17) {
                                                                ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                                if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                    if (ComposerKt.isTraceInProgress()) {
                                                                        ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                    }
                                                                    Function2<Composer, Integer, Unit> function1116 = function1114;
                                                                    composer5.startReplaceGroup(-779485335);
                                                                    ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                    if (function1116 != null) {
                                                                        function1116.invoke(composer5, 0);
                                                                        Unit unit = Unit.INSTANCE;
                                                                    }
                                                                    composer5.endReplaceGroup();
                                                                    function1115.invoke(composer5, 0);
                                                                    if (ComposerKt.isTraceInProgress()) {
                                                                        ComposerKt.traceEventEnd();
                                                                        return;
                                                                    }
                                                                    return;
                                                                }
                                                                composer5.skipToGroupEnd();
                                                            }
                                                        }, composer4, 54), composer4, 438);
                                                        if (ComposerKt.isTraceInProgress()) {
                                                            ComposerKt.traceEventEnd();
                                                            return;
                                                        }
                                                        return;
                                                    }
                                                    composer4.skipToGroupEnd();
                                                }
                                            }, composer3, 54), composer3, 384);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer3.skipToGroupEnd();
                                    }
                                }, composer2, 54), composer2, 12582918, 104);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    function6 = function117;
                    shape3 = shape114;
                    f2 = f113;
                    datePickerColors2 = datePickerColors113;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) == 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i8 != 0) {
                            dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                        } else {
                            dialogProperties2 = dialogProperties;
                        }
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i8 != 0) {
                            dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                        } else {
                            dialogProperties2 = dialogProperties;
                        }
                    }
                    final Function2<? super Composer, ? super Integer, Unit> function118 = function5;
                    final Shape shape115 = shape2;
                    final float f114 = fM2272getTonalElevationD9Ej5fM;
                    final DatePickerColors datePickerColors114 = datePickerColorsColors;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                    }
                    AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                            if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                                }
                                Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                                Shape shape116 = shape115;
                                long containerColor = datePickerColors114.getContainerColor();
                                float f115 = f114;
                                final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function119 = function4;
                                final Function2<? super Composer, ? super Integer, Unit> function1110 = function118;
                                final Function2<? super Composer, ? super Integer, Unit> function1111 = function2;
                                SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape116, containerColor, 0L, f115, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer3, int i15) {
                                        ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                        if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                            }
                                            Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                            Function3<ColumnScope, Composer, Integer, Unit> function1112 = function119;
                                            final Function2<? super Composer, ? super Integer, Unit> function1113 = function1110;
                                            final Function2<? super Composer, ? super Integer, Unit> function1114 = function1111;
                                            ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                            Modifier.Companion companion2 = Modifier.INSTANCE;
                                            MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                            Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                            ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                            Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor2);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                            BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                            function1112.invoke(columnScopeInstance, composer3, 6);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                            Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor3);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                                composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                                composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                            BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                            ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                                {
                                                    super(2);
                                                }

                                                public Object invoke(Object obj, Object obj2) {
                                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                                    return Unit.INSTANCE;
                                                }

                                                public final void invoke(Composer composer4, int i16) {
                                                    ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                    if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                        if (ComposerKt.isTraceInProgress()) {
                                                            ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                        }
                                                        float f116 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                        float f117 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                        final Function2<? super Composer, ? super Integer, Unit> function1115 = function1113;
                                                        final Function2<? super Composer, ? super Integer, Unit> function1116 = function1114;
                                                        AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f116, f117, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                            {
                                                                super(2);
                                                            }

                                                            public Object invoke(Object obj, Object obj2) {
                                                                invoke((Composer) obj, ((Number) obj2).intValue());
                                                                return Unit.INSTANCE;
                                                            }

                                                            public final void invoke(Composer composer5, int i17) {
                                                                ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                                if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                    if (ComposerKt.isTraceInProgress()) {
                                                                        ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                    }
                                                                    Function2<Composer, Integer, Unit> function1117 = function1115;
                                                                    composer5.startReplaceGroup(-779485335);
                                                                    ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                    if (function1117 != null) {
                                                                        function1117.invoke(composer5, 0);
                                                                        Unit unit = Unit.INSTANCE;
                                                                    }
                                                                    composer5.endReplaceGroup();
                                                                    function1116.invoke(composer5, 0);
                                                                    if (ComposerKt.isTraceInProgress()) {
                                                                        ComposerKt.traceEventEnd();
                                                                        return;
                                                                    }
                                                                    return;
                                                                }
                                                                composer5.skipToGroupEnd();
                                                            }
                                                        }, composer4, 54), composer4, 438);
                                                        if (ComposerKt.isTraceInProgress()) {
                                                            ComposerKt.traceEventEnd();
                                                            return;
                                                        }
                                                        return;
                                                    }
                                                    composer4.skipToGroupEnd();
                                                }
                                            }, composer3, 54), composer3, 384);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer3.skipToGroupEnd();
                                    }
                                }, composer2, 54), composer2, 12582918, 104);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    function6 = function118;
                    shape3 = shape115;
                    f2 = f114;
                    datePickerColors2 = datePickerColors114;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final DialogProperties dialogProperties13 = dialogProperties2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            DatePickerDialog_androidKt.m2273DatePickerDialogGmEhDVc(function0, function2, modifier2, function6, shape3, f2, datePickerColors2, dialogProperties13, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 100663296;
            if ((i3 & 38347923) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) == 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i8 != 0) {
                        dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                    } else {
                        dialogProperties2 = dialogProperties;
                    }
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i8 != 0) {
                        dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                    } else {
                        dialogProperties2 = dialogProperties;
                    }
                }
                final Function2<? super Composer, ? super Integer, Unit> function119 = function5;
                final Shape shape116 = shape2;
                final float f115 = fM2272getTonalElevationD9Ej5fM;
                final DatePickerColors datePickerColors115 = datePickerColorsColors;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                }
                AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i14) {
                        ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                        if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                            }
                            Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                            Shape shape117 = shape116;
                            long containerColor = datePickerColors115.getContainerColor();
                            float f116 = f115;
                            final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function1110 = function4;
                            final Function2<? super Composer, ? super Integer, Unit> function1111 = function119;
                            final Function2<? super Composer, ? super Integer, Unit> function1112 = function2;
                            SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape117, containerColor, 0L, f116, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer3, int i15) {
                                    ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                    if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                        }
                                        Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                        Function3<ColumnScope, Composer, Integer, Unit> function1113 = function1110;
                                        final Function2<? super Composer, ? super Integer, Unit> function1114 = function1111;
                                        final Function2<? super Composer, ? super Integer, Unit> function1115 = function1112;
                                        ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                        Modifier.Companion companion2 = Modifier.INSTANCE;
                                        MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                        Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                        ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                        Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                        ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                        Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor2);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                            composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                            composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                        BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                        function1113.invoke(columnScopeInstance, composer3, 6);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                        ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                        Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor3);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                            composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                            composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                        BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                        ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                            {
                                                super(2);
                                            }

                                            public Object invoke(Object obj, Object obj2) {
                                                invoke((Composer) obj, ((Number) obj2).intValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(Composer composer4, int i16) {
                                                ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                    if (ComposerKt.isTraceInProgress()) {
                                                        ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                    }
                                                    float f117 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                    float f118 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                    final Function2<? super Composer, ? super Integer, Unit> function1116 = function1114;
                                                    final Function2<? super Composer, ? super Integer, Unit> function1117 = function1115;
                                                    AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f117, f118, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                        {
                                                            super(2);
                                                        }

                                                        public Object invoke(Object obj, Object obj2) {
                                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                                            return Unit.INSTANCE;
                                                        }

                                                        public final void invoke(Composer composer5, int i17) {
                                                            ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                            if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                if (ComposerKt.isTraceInProgress()) {
                                                                    ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                }
                                                                Function2<Composer, Integer, Unit> function1118 = function1116;
                                                                composer5.startReplaceGroup(-779485335);
                                                                ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                if (function1118 != null) {
                                                                    function1118.invoke(composer5, 0);
                                                                    Unit unit = Unit.INSTANCE;
                                                                }
                                                                composer5.endReplaceGroup();
                                                                function1117.invoke(composer5, 0);
                                                                if (ComposerKt.isTraceInProgress()) {
                                                                    ComposerKt.traceEventEnd();
                                                                    return;
                                                                }
                                                                return;
                                                            }
                                                            composer5.skipToGroupEnd();
                                                        }
                                                    }, composer4, 54), composer4, 438);
                                                    if (ComposerKt.isTraceInProgress()) {
                                                        ComposerKt.traceEventEnd();
                                                        return;
                                                    }
                                                    return;
                                                }
                                                composer4.skipToGroupEnd();
                                            }
                                        }, composer3, 54), composer3, 384);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer3.skipToGroupEnd();
                                }
                            }, composer2, 54), composer2, 12582918, 104);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                function6 = function119;
                shape3 = shape116;
                f2 = f115;
                datePickerColors2 = datePickerColors115;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) == 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i8 != 0) {
                        dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                    } else {
                        dialogProperties2 = dialogProperties;
                    }
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i8 != 0) {
                        dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                    } else {
                        dialogProperties2 = dialogProperties;
                    }
                }
                final Function2<? super Composer, ? super Integer, Unit> function1110 = function5;
                final Shape shape117 = shape2;
                final float f116 = fM2272getTonalElevationD9Ej5fM;
                final DatePickerColors datePickerColors116 = datePickerColorsColors;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                }
                AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i14) {
                        ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                        if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                            }
                            Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                            Shape shape118 = shape117;
                            long containerColor = datePickerColors116.getContainerColor();
                            float f117 = f116;
                            final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function1111 = function4;
                            final Function2<? super Composer, ? super Integer, Unit> function1112 = function1110;
                            final Function2<? super Composer, ? super Integer, Unit> function1113 = function2;
                            SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape118, containerColor, 0L, f117, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer3, int i15) {
                                    ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                    if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                        }
                                        Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                        Function3<ColumnScope, Composer, Integer, Unit> function1114 = function1111;
                                        final Function2<? super Composer, ? super Integer, Unit> function1115 = function1112;
                                        final Function2<? super Composer, ? super Integer, Unit> function1116 = function1113;
                                        ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                        Modifier.Companion companion2 = Modifier.INSTANCE;
                                        MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                        Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                        ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                        Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                        ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                        Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor2);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                            composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                            composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                        BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                        function1114.invoke(columnScopeInstance, composer3, 6);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                        ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                        Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor3);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                            composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                            composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                        BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                        ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                            {
                                                super(2);
                                            }

                                            public Object invoke(Object obj, Object obj2) {
                                                invoke((Composer) obj, ((Number) obj2).intValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(Composer composer4, int i16) {
                                                ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                    if (ComposerKt.isTraceInProgress()) {
                                                        ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                    }
                                                    float f118 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                    float f119 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                    final Function2<? super Composer, ? super Integer, Unit> function1117 = function1115;
                                                    final Function2<? super Composer, ? super Integer, Unit> function1118 = function1116;
                                                    AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f118, f119, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                        {
                                                            super(2);
                                                        }

                                                        public Object invoke(Object obj, Object obj2) {
                                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                                            return Unit.INSTANCE;
                                                        }

                                                        public final void invoke(Composer composer5, int i17) {
                                                            ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                            if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                if (ComposerKt.isTraceInProgress()) {
                                                                    ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                }
                                                                Function2<Composer, Integer, Unit> function1119 = function1117;
                                                                composer5.startReplaceGroup(-779485335);
                                                                ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                if (function1119 != null) {
                                                                    function1119.invoke(composer5, 0);
                                                                    Unit unit = Unit.INSTANCE;
                                                                }
                                                                composer5.endReplaceGroup();
                                                                function1118.invoke(composer5, 0);
                                                                if (ComposerKt.isTraceInProgress()) {
                                                                    ComposerKt.traceEventEnd();
                                                                    return;
                                                                }
                                                                return;
                                                            }
                                                            composer5.skipToGroupEnd();
                                                        }
                                                    }, composer4, 54), composer4, 438);
                                                    if (ComposerKt.isTraceInProgress()) {
                                                        ComposerKt.traceEventEnd();
                                                        return;
                                                    }
                                                    return;
                                                }
                                                composer4.skipToGroupEnd();
                                            }
                                        }, composer3, 54), composer3, 384);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer3.skipToGroupEnd();
                                }
                            }, composer2, 54), composer2, 12582918, 104);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                function6 = function1110;
                shape3 = shape117;
                f2 = f116;
                datePickerColors2 = datePickerColors116;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final DialogProperties dialogProperties14 = dialogProperties2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i14) {
                        DatePickerDialog_androidKt.m2273DatePickerDialogGmEhDVc(function0, function2, modifier2, function6, shape3, f2, datePickerColors2, dialogProperties14, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        function5 = function3;
        if ((i & 24576) == 0) {
            if ((i2 & 16) == 0) {
                shape2 = shape;
                if (composerStartRestartGroup.changed(shape2)) {
                    i11 = Fields.Clip;
                }
                i3 |= i11;
            } else {
                shape2 = shape;
            }
            i11 = Fields.Shape;
            i3 |= i11;
        } else {
            shape2 = shape;
        }
        i6 = i2 & 32;
        if (i6 != 0) {
            if ((196608 & i) == 0) {
                fM2272getTonalElevationD9Ej5fM = f;
                if (composerStartRestartGroup.changed(fM2272getTonalElevationD9Ej5fM)) {
                    i7 = Fields.RenderEffect;
                } else {
                    i7 = 65536;
                }
                i3 |= i7;
            }
            if ((1572864 & i) == 0) {
                if ((i2 & 64) == 0) {
                    datePickerColorsColors = datePickerColors;
                    if (composerStartRestartGroup.changed(datePickerColorsColors)) {
                    }
                    i3 |= i13;
                } else {
                    datePickerColorsColors = datePickerColors;
                }
                i3 |= i13;
            } else {
                datePickerColorsColors = datePickerColors;
            }
            i8 = i2 & Fields.SpotShadowColor;
            if (i8 != 0) {
                i3 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changed(dialogProperties)) {
                    i9 = 8388608;
                } else {
                    i9 = 4194304;
                }
                i3 |= i9;
            }
            if ((i2 & Fields.RotationX) != 0) {
                if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i10 = 67108864;
                    } else {
                        i10 = 33554432;
                    }
                    i3 |= i10;
                }
                if ((i3 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) == 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i8 != 0) {
                            dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                        } else {
                            dialogProperties2 = dialogProperties;
                        }
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i8 != 0) {
                            dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                        } else {
                            dialogProperties2 = dialogProperties;
                        }
                    }
                    final Function2<? super Composer, ? super Integer, Unit> function1111 = function5;
                    final Shape shape118 = shape2;
                    final float f117 = fM2272getTonalElevationD9Ej5fM;
                    final DatePickerColors datePickerColors117 = datePickerColorsColors;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                    }
                    AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                            if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                                }
                                Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                                Shape shape119 = shape118;
                                long containerColor = datePickerColors117.getContainerColor();
                                float f118 = f117;
                                final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function1112 = function4;
                                final Function2<? super Composer, ? super Integer, Unit> function1113 = function1111;
                                final Function2<? super Composer, ? super Integer, Unit> function1114 = function2;
                                SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape119, containerColor, 0L, f118, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer3, int i15) {
                                        ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                        if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                            }
                                            Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                            Function3<ColumnScope, Composer, Integer, Unit> function1115 = function1112;
                                            final Function2<? super Composer, ? super Integer, Unit> function1116 = function1113;
                                            final Function2<? super Composer, ? super Integer, Unit> function1117 = function1114;
                                            ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                            Modifier.Companion companion2 = Modifier.INSTANCE;
                                            MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                            Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                            ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                            Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor2);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                            BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                            function1115.invoke(columnScopeInstance, composer3, 6);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                            Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor3);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                                composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                                composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                            BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                            ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                                {
                                                    super(2);
                                                }

                                                public Object invoke(Object obj, Object obj2) {
                                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                                    return Unit.INSTANCE;
                                                }

                                                public final void invoke(Composer composer4, int i16) {
                                                    ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                    if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                        if (ComposerKt.isTraceInProgress()) {
                                                            ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                        }
                                                        float f119 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                        float f1110 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                        final Function2<? super Composer, ? super Integer, Unit> function1118 = function1116;
                                                        final Function2<? super Composer, ? super Integer, Unit> function1119 = function1117;
                                                        AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f119, f1110, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                            {
                                                                super(2);
                                                            }

                                                            public Object invoke(Object obj, Object obj2) {
                                                                invoke((Composer) obj, ((Number) obj2).intValue());
                                                                return Unit.INSTANCE;
                                                            }

                                                            public final void invoke(Composer composer5, int i17) {
                                                                ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                                if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                    if (ComposerKt.isTraceInProgress()) {
                                                                        ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                    }
                                                                    Function2<Composer, Integer, Unit> function11110 = function1118;
                                                                    composer5.startReplaceGroup(-779485335);
                                                                    ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                    if (function11110 != null) {
                                                                        function11110.invoke(composer5, 0);
                                                                        Unit unit = Unit.INSTANCE;
                                                                    }
                                                                    composer5.endReplaceGroup();
                                                                    function1119.invoke(composer5, 0);
                                                                    if (ComposerKt.isTraceInProgress()) {
                                                                        ComposerKt.traceEventEnd();
                                                                        return;
                                                                    }
                                                                    return;
                                                                }
                                                                composer5.skipToGroupEnd();
                                                            }
                                                        }, composer4, 54), composer4, 438);
                                                        if (ComposerKt.isTraceInProgress()) {
                                                            ComposerKt.traceEventEnd();
                                                            return;
                                                        }
                                                        return;
                                                    }
                                                    composer4.skipToGroupEnd();
                                                }
                                            }, composer3, 54), composer3, 384);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer3.skipToGroupEnd();
                                    }
                                }, composer2, 54), composer2, 12582918, 104);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    function6 = function1111;
                    shape3 = shape118;
                    f2 = f117;
                    datePickerColors2 = datePickerColors117;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) == 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i8 != 0) {
                            dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                        } else {
                            dialogProperties2 = dialogProperties;
                        }
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i8 != 0) {
                            dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                        } else {
                            dialogProperties2 = dialogProperties;
                        }
                    }
                    final Function2<? super Composer, ? super Integer, Unit> function1112 = function5;
                    final Shape shape119 = shape2;
                    final float f118 = fM2272getTonalElevationD9Ej5fM;
                    final DatePickerColors datePickerColors118 = datePickerColorsColors;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                    }
                    AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                            if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                                }
                                Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                                Shape shape1110 = shape119;
                                long containerColor = datePickerColors118.getContainerColor();
                                float f119 = f118;
                                final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function1113 = function4;
                                final Function2<? super Composer, ? super Integer, Unit> function1114 = function1112;
                                final Function2<? super Composer, ? super Integer, Unit> function1115 = function2;
                                SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape1110, containerColor, 0L, f119, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer3, int i15) {
                                        ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                        if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                            }
                                            Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                            Function3<ColumnScope, Composer, Integer, Unit> function1116 = function1113;
                                            final Function2<? super Composer, ? super Integer, Unit> function1117 = function1114;
                                            final Function2<? super Composer, ? super Integer, Unit> function1118 = function1115;
                                            ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                            Modifier.Companion companion2 = Modifier.INSTANCE;
                                            MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                            Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                            ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                            Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor2);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                            BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                            function1116.invoke(columnScopeInstance, composer3, 6);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                            Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor3);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                                composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                                composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                            BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                            ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                                {
                                                    super(2);
                                                }

                                                public Object invoke(Object obj, Object obj2) {
                                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                                    return Unit.INSTANCE;
                                                }

                                                public final void invoke(Composer composer4, int i16) {
                                                    ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                    if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                        if (ComposerKt.isTraceInProgress()) {
                                                            ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                        }
                                                        float f1110 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                        float f1111 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                        final Function2<? super Composer, ? super Integer, Unit> function1119 = function1117;
                                                        final Function2<? super Composer, ? super Integer, Unit> function11110 = function1118;
                                                        AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f1110, f1111, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                            {
                                                                super(2);
                                                            }

                                                            public Object invoke(Object obj, Object obj2) {
                                                                invoke((Composer) obj, ((Number) obj2).intValue());
                                                                return Unit.INSTANCE;
                                                            }

                                                            public final void invoke(Composer composer5, int i17) {
                                                                ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                                if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                    if (ComposerKt.isTraceInProgress()) {
                                                                        ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                    }
                                                                    Function2<Composer, Integer, Unit> function11111 = function1119;
                                                                    composer5.startReplaceGroup(-779485335);
                                                                    ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                    if (function11111 != null) {
                                                                        function11111.invoke(composer5, 0);
                                                                        Unit unit = Unit.INSTANCE;
                                                                    }
                                                                    composer5.endReplaceGroup();
                                                                    function11110.invoke(composer5, 0);
                                                                    if (ComposerKt.isTraceInProgress()) {
                                                                        ComposerKt.traceEventEnd();
                                                                        return;
                                                                    }
                                                                    return;
                                                                }
                                                                composer5.skipToGroupEnd();
                                                            }
                                                        }, composer4, 54), composer4, 438);
                                                        if (ComposerKt.isTraceInProgress()) {
                                                            ComposerKt.traceEventEnd();
                                                            return;
                                                        }
                                                        return;
                                                    }
                                                    composer4.skipToGroupEnd();
                                                }
                                            }, composer3, 54), composer3, 384);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer3.skipToGroupEnd();
                                    }
                                }, composer2, 54), composer2, 12582918, 104);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    function6 = function1112;
                    shape3 = shape119;
                    f2 = f118;
                    datePickerColors2 = datePickerColors118;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final DialogProperties dialogProperties15 = dialogProperties2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            DatePickerDialog_androidKt.m2273DatePickerDialogGmEhDVc(function0, function2, modifier2, function6, shape3, f2, datePickerColors2, dialogProperties15, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 100663296;
            if ((i3 & 38347923) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) == 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i8 != 0) {
                        dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                    } else {
                        dialogProperties2 = dialogProperties;
                    }
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i8 != 0) {
                        dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                    } else {
                        dialogProperties2 = dialogProperties;
                    }
                }
                final Function2<? super Composer, ? super Integer, Unit> function1113 = function5;
                final Shape shape1110 = shape2;
                final float f119 = fM2272getTonalElevationD9Ej5fM;
                final DatePickerColors datePickerColors119 = datePickerColorsColors;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                }
                AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i14) {
                        ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                        if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                            }
                            Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                            Shape shape1111 = shape1110;
                            long containerColor = datePickerColors119.getContainerColor();
                            float f1110 = f119;
                            final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function1114 = function4;
                            final Function2<? super Composer, ? super Integer, Unit> function1115 = function1113;
                            final Function2<? super Composer, ? super Integer, Unit> function1116 = function2;
                            SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape1111, containerColor, 0L, f1110, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer3, int i15) {
                                    ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                    if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                        }
                                        Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                        Function3<ColumnScope, Composer, Integer, Unit> function1117 = function1114;
                                        final Function2<? super Composer, ? super Integer, Unit> function1118 = function1115;
                                        final Function2<? super Composer, ? super Integer, Unit> function1119 = function1116;
                                        ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                        Modifier.Companion companion2 = Modifier.INSTANCE;
                                        MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                        Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                        ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                        Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                        ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                        Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor2);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                            composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                            composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                        BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                        function1117.invoke(columnScopeInstance, composer3, 6);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                        ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                        Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor3);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                            composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                            composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                        BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                        ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                            {
                                                super(2);
                                            }

                                            public Object invoke(Object obj, Object obj2) {
                                                invoke((Composer) obj, ((Number) obj2).intValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(Composer composer4, int i16) {
                                                ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                    if (ComposerKt.isTraceInProgress()) {
                                                        ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                    }
                                                    float f1111 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                    float f1112 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                    final Function2<? super Composer, ? super Integer, Unit> function11110 = function1118;
                                                    final Function2<? super Composer, ? super Integer, Unit> function11111 = function1119;
                                                    AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f1111, f1112, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                        {
                                                            super(2);
                                                        }

                                                        public Object invoke(Object obj, Object obj2) {
                                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                                            return Unit.INSTANCE;
                                                        }

                                                        public final void invoke(Composer composer5, int i17) {
                                                            ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                            if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                if (ComposerKt.isTraceInProgress()) {
                                                                    ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                }
                                                                Function2<Composer, Integer, Unit> function11112 = function11110;
                                                                composer5.startReplaceGroup(-779485335);
                                                                ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                if (function11112 != null) {
                                                                    function11112.invoke(composer5, 0);
                                                                    Unit unit = Unit.INSTANCE;
                                                                }
                                                                composer5.endReplaceGroup();
                                                                function11111.invoke(composer5, 0);
                                                                if (ComposerKt.isTraceInProgress()) {
                                                                    ComposerKt.traceEventEnd();
                                                                    return;
                                                                }
                                                                return;
                                                            }
                                                            composer5.skipToGroupEnd();
                                                        }
                                                    }, composer4, 54), composer4, 438);
                                                    if (ComposerKt.isTraceInProgress()) {
                                                        ComposerKt.traceEventEnd();
                                                        return;
                                                    }
                                                    return;
                                                }
                                                composer4.skipToGroupEnd();
                                            }
                                        }, composer3, 54), composer3, 384);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer3.skipToGroupEnd();
                                }
                            }, composer2, 54), composer2, 12582918, 104);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                function6 = function1113;
                shape3 = shape1110;
                f2 = f119;
                datePickerColors2 = datePickerColors119;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) == 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i8 != 0) {
                        dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                    } else {
                        dialogProperties2 = dialogProperties;
                    }
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i8 != 0) {
                        dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                    } else {
                        dialogProperties2 = dialogProperties;
                    }
                }
                final Function2<? super Composer, ? super Integer, Unit> function1114 = function5;
                final Shape shape1111 = shape2;
                final float f1110 = fM2272getTonalElevationD9Ej5fM;
                final DatePickerColors datePickerColors1110 = datePickerColorsColors;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                }
                AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i14) {
                        ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                        if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                            }
                            Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                            Shape shape1112 = shape1111;
                            long containerColor = datePickerColors1110.getContainerColor();
                            float f1111 = f1110;
                            final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function1115 = function4;
                            final Function2<? super Composer, ? super Integer, Unit> function1116 = function1114;
                            final Function2<? super Composer, ? super Integer, Unit> function1117 = function2;
                            SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape1112, containerColor, 0L, f1111, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer3, int i15) {
                                    ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                    if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                        }
                                        Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                        Function3<ColumnScope, Composer, Integer, Unit> function1118 = function1115;
                                        final Function2<? super Composer, ? super Integer, Unit> function1119 = function1116;
                                        final Function2<? super Composer, ? super Integer, Unit> function11110 = function1117;
                                        ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                        Modifier.Companion companion2 = Modifier.INSTANCE;
                                        MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                        Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                        ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                        Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                        ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                        Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor2);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                            composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                            composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                        BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                        function1118.invoke(columnScopeInstance, composer3, 6);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                        ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                        Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor3);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                            composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                            composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                        BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                        ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                            {
                                                super(2);
                                            }

                                            public Object invoke(Object obj, Object obj2) {
                                                invoke((Composer) obj, ((Number) obj2).intValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(Composer composer4, int i16) {
                                                ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                    if (ComposerKt.isTraceInProgress()) {
                                                        ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                    }
                                                    float f1112 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                    float f1113 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                    final Function2<? super Composer, ? super Integer, Unit> function11111 = function1119;
                                                    final Function2<? super Composer, ? super Integer, Unit> function11112 = function11110;
                                                    AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f1112, f1113, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                        {
                                                            super(2);
                                                        }

                                                        public Object invoke(Object obj, Object obj2) {
                                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                                            return Unit.INSTANCE;
                                                        }

                                                        public final void invoke(Composer composer5, int i17) {
                                                            ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                            if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                if (ComposerKt.isTraceInProgress()) {
                                                                    ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                }
                                                                Function2<Composer, Integer, Unit> function11113 = function11111;
                                                                composer5.startReplaceGroup(-779485335);
                                                                ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                if (function11113 != null) {
                                                                    function11113.invoke(composer5, 0);
                                                                    Unit unit = Unit.INSTANCE;
                                                                }
                                                                composer5.endReplaceGroup();
                                                                function11112.invoke(composer5, 0);
                                                                if (ComposerKt.isTraceInProgress()) {
                                                                    ComposerKt.traceEventEnd();
                                                                    return;
                                                                }
                                                                return;
                                                            }
                                                            composer5.skipToGroupEnd();
                                                        }
                                                    }, composer4, 54), composer4, 438);
                                                    if (ComposerKt.isTraceInProgress()) {
                                                        ComposerKt.traceEventEnd();
                                                        return;
                                                    }
                                                    return;
                                                }
                                                composer4.skipToGroupEnd();
                                            }
                                        }, composer3, 54), composer3, 384);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer3.skipToGroupEnd();
                                }
                            }, composer2, 54), composer2, 12582918, 104);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                function6 = function1114;
                shape3 = shape1111;
                f2 = f1110;
                datePickerColors2 = datePickerColors1110;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final DialogProperties dialogProperties16 = dialogProperties2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i14) {
                        DatePickerDialog_androidKt.m2273DatePickerDialogGmEhDVc(function0, function2, modifier2, function6, shape3, f2, datePickerColors2, dialogProperties16, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 196608;
        fM2272getTonalElevationD9Ej5fM = f;
        if ((1572864 & i) == 0) {
            if ((i2 & 64) == 0) {
                datePickerColorsColors = datePickerColors;
                if (composerStartRestartGroup.changed(datePickerColorsColors)) {
                }
                i3 |= i13;
            } else {
                datePickerColorsColors = datePickerColors;
            }
            i3 |= i13;
        } else {
            datePickerColorsColors = datePickerColors;
        }
        i8 = i2 & Fields.SpotShadowColor;
        if (i8 != 0) {
            i3 |= 12582912;
        } else if ((i & 12582912) == 0) {
            if (composerStartRestartGroup.changed(dialogProperties)) {
                i9 = 8388608;
            } else {
                i9 = 4194304;
            }
            i3 |= i9;
        }
        if ((i2 & Fields.RotationX) != 0) {
            if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i10 = 67108864;
                } else {
                    i10 = 33554432;
                }
                i3 |= i10;
            }
            if ((i3 & 38347923) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) == 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i8 != 0) {
                        dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                    } else {
                        dialogProperties2 = dialogProperties;
                    }
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i8 != 0) {
                        dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                    } else {
                        dialogProperties2 = dialogProperties;
                    }
                }
                final Function2<? super Composer, ? super Integer, Unit> function1115 = function5;
                final Shape shape1112 = shape2;
                final float f1111 = fM2272getTonalElevationD9Ej5fM;
                final DatePickerColors datePickerColors1111 = datePickerColorsColors;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                }
                AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i14) {
                        ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                        if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                            }
                            Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                            Shape shape1113 = shape1112;
                            long containerColor = datePickerColors1111.getContainerColor();
                            float f1112 = f1111;
                            final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function1116 = function4;
                            final Function2<? super Composer, ? super Integer, Unit> function1117 = function1115;
                            final Function2<? super Composer, ? super Integer, Unit> function1118 = function2;
                            SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape1113, containerColor, 0L, f1112, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer3, int i15) {
                                    ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                    if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                        }
                                        Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                        Function3<ColumnScope, Composer, Integer, Unit> function1119 = function1116;
                                        final Function2<? super Composer, ? super Integer, Unit> function11110 = function1117;
                                        final Function2<? super Composer, ? super Integer, Unit> function11111 = function1118;
                                        ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                        Modifier.Companion companion2 = Modifier.INSTANCE;
                                        MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                        Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                        ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                        Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                        ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                        Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor2);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                            composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                            composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                        BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                        function1119.invoke(columnScopeInstance, composer3, 6);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                        ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                        Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor3);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                            composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                            composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                        BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                        ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                            {
                                                super(2);
                                            }

                                            public Object invoke(Object obj, Object obj2) {
                                                invoke((Composer) obj, ((Number) obj2).intValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(Composer composer4, int i16) {
                                                ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                    if (ComposerKt.isTraceInProgress()) {
                                                        ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                    }
                                                    float f1113 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                    float f1114 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                    final Function2<? super Composer, ? super Integer, Unit> function11112 = function11110;
                                                    final Function2<? super Composer, ? super Integer, Unit> function11113 = function11111;
                                                    AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f1113, f1114, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                        {
                                                            super(2);
                                                        }

                                                        public Object invoke(Object obj, Object obj2) {
                                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                                            return Unit.INSTANCE;
                                                        }

                                                        public final void invoke(Composer composer5, int i17) {
                                                            ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                            if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                if (ComposerKt.isTraceInProgress()) {
                                                                    ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                }
                                                                Function2<Composer, Integer, Unit> function11114 = function11112;
                                                                composer5.startReplaceGroup(-779485335);
                                                                ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                if (function11114 != null) {
                                                                    function11114.invoke(composer5, 0);
                                                                    Unit unit = Unit.INSTANCE;
                                                                }
                                                                composer5.endReplaceGroup();
                                                                function11113.invoke(composer5, 0);
                                                                if (ComposerKt.isTraceInProgress()) {
                                                                    ComposerKt.traceEventEnd();
                                                                    return;
                                                                }
                                                                return;
                                                            }
                                                            composer5.skipToGroupEnd();
                                                        }
                                                    }, composer4, 54), composer4, 438);
                                                    if (ComposerKt.isTraceInProgress()) {
                                                        ComposerKt.traceEventEnd();
                                                        return;
                                                    }
                                                    return;
                                                }
                                                composer4.skipToGroupEnd();
                                            }
                                        }, composer3, 54), composer3, 384);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer3.skipToGroupEnd();
                                }
                            }, composer2, 54), composer2, 12582918, 104);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                function6 = function1115;
                shape3 = shape1112;
                f2 = f1111;
                datePickerColors2 = datePickerColors1111;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) == 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i8 != 0) {
                        dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                    } else {
                        dialogProperties2 = dialogProperties;
                    }
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i8 != 0) {
                        dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                    } else {
                        dialogProperties2 = dialogProperties;
                    }
                }
                final Function2<? super Composer, ? super Integer, Unit> function1116 = function5;
                final Shape shape1113 = shape2;
                final float f1112 = fM2272getTonalElevationD9Ej5fM;
                final DatePickerColors datePickerColors1112 = datePickerColorsColors;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
                }
                AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i14) {
                        ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                        if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                            }
                            Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                            Shape shape1114 = shape1113;
                            long containerColor = datePickerColors1112.getContainerColor();
                            float f1113 = f1112;
                            final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function1117 = function4;
                            final Function2<? super Composer, ? super Integer, Unit> function1118 = function1116;
                            final Function2<? super Composer, ? super Integer, Unit> function1119 = function2;
                            SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape1114, containerColor, 0L, f1113, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer3, int i15) {
                                    ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                    if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                        }
                                        Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                        Function3<ColumnScope, Composer, Integer, Unit> function11110 = function1117;
                                        final Function2<? super Composer, ? super Integer, Unit> function11111 = function1118;
                                        final Function2<? super Composer, ? super Integer, Unit> function11112 = function1119;
                                        ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                        Modifier.Companion companion2 = Modifier.INSTANCE;
                                        MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                        Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                        ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                        Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                        ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                        Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor2);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                            composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                            composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                        BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                        function11110.invoke(columnScopeInstance, composer3, 6);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                        ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                        Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor3);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                            composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                            composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                        BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                        ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                            {
                                                super(2);
                                            }

                                            public Object invoke(Object obj, Object obj2) {
                                                invoke((Composer) obj, ((Number) obj2).intValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(Composer composer4, int i16) {
                                                ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                                if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                    if (ComposerKt.isTraceInProgress()) {
                                                        ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                    }
                                                    float f1114 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                    float f1115 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                    final Function2<? super Composer, ? super Integer, Unit> function11113 = function11111;
                                                    final Function2<? super Composer, ? super Integer, Unit> function11114 = function11112;
                                                    AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f1114, f1115, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                        {
                                                            super(2);
                                                        }

                                                        public Object invoke(Object obj, Object obj2) {
                                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                                            return Unit.INSTANCE;
                                                        }

                                                        public final void invoke(Composer composer5, int i17) {
                                                            ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                            if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                                if (ComposerKt.isTraceInProgress()) {
                                                                    ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                                }
                                                                Function2<Composer, Integer, Unit> function11115 = function11113;
                                                                composer5.startReplaceGroup(-779485335);
                                                                ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                                if (function11115 != null) {
                                                                    function11115.invoke(composer5, 0);
                                                                    Unit unit = Unit.INSTANCE;
                                                                }
                                                                composer5.endReplaceGroup();
                                                                function11114.invoke(composer5, 0);
                                                                if (ComposerKt.isTraceInProgress()) {
                                                                    ComposerKt.traceEventEnd();
                                                                    return;
                                                                }
                                                                return;
                                                            }
                                                            composer5.skipToGroupEnd();
                                                        }
                                                    }, composer4, 54), composer4, 438);
                                                    if (ComposerKt.isTraceInProgress()) {
                                                        ComposerKt.traceEventEnd();
                                                        return;
                                                    }
                                                    return;
                                                }
                                                composer4.skipToGroupEnd();
                                            }
                                        }, composer3, 54), composer3, 384);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer3.skipToGroupEnd();
                                }
                            }, composer2, 54), composer2, 12582918, 104);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                function6 = function1116;
                shape3 = shape1113;
                f2 = f1112;
                datePickerColors2 = datePickerColors1112;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final DialogProperties dialogProperties17 = dialogProperties2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i14) {
                        DatePickerDialog_androidKt.m2273DatePickerDialogGmEhDVc(function0, function2, modifier2, function6, shape3, f2, datePickerColors2, dialogProperties17, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 100663296;
        if ((i3 & 38347923) == 38347922) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) == 0) {
                if (i12 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i4 != 0) {
                    function5 = null;
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                }
                if (i6 != 0) {
                    fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                }
                if ((i2 & 64) != 0) {
                    i3 &= -3670017;
                    datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                }
                if (i8 != 0) {
                    dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                } else {
                    dialogProperties2 = dialogProperties;
                }
            } else {
                if (i12 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i4 != 0) {
                    function5 = null;
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                }
                if (i6 != 0) {
                    fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                }
                if ((i2 & 64) != 0) {
                    i3 &= -3670017;
                    datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                }
                if (i8 != 0) {
                    dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                } else {
                    dialogProperties2 = dialogProperties;
                }
            }
            final Function2<? super Composer, ? super Integer, Unit> function1117 = function5;
            final Shape shape1114 = shape2;
            final float f1113 = fM2272getTonalElevationD9Ej5fM;
            final DatePickerColors datePickerColors1113 = datePickerColorsColors;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
            }
            AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i14) {
                    ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                    if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                        }
                        Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                        Shape shape1115 = shape1114;
                        long containerColor = datePickerColors1113.getContainerColor();
                        float f1114 = f1113;
                        final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function1118 = function4;
                        final Function2<? super Composer, ? super Integer, Unit> function1119 = function1117;
                        final Function2<? super Composer, ? super Integer, Unit> function11110 = function2;
                        SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape1115, containerColor, 0L, f1114, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer3, int i15) {
                                ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                    }
                                    Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                    Function3<ColumnScope, Composer, Integer, Unit> function11111 = function1118;
                                    final Function2<? super Composer, ? super Integer, Unit> function11112 = function1119;
                                    final Function2<? super Composer, ? super Integer, Unit> function11113 = function11110;
                                    ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                    Modifier.Companion companion2 = Modifier.INSTANCE;
                                    MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                    ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                    CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                    Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer3.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer3.startReusableNode();
                                    if (composer3.getInserting()) {
                                        composer3.createNode(constructor);
                                    } else {
                                        composer3.useNode();
                                    }
                                    Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                    ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                    Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                    ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                    CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                    Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer3.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer3.startReusableNode();
                                    if (composer3.getInserting()) {
                                        composer3.createNode(constructor2);
                                    } else {
                                        composer3.useNode();
                                    }
                                    Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                    Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                        composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                        composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                    function11111.invoke(columnScopeInstance, composer3, 6);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    composer3.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                    ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                    CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                    Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer3.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer3.startReusableNode();
                                    if (composer3.getInserting()) {
                                        composer3.createNode(constructor3);
                                    } else {
                                        composer3.useNode();
                                    }
                                    Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                    Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                        composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                        composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                    ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer4, int i16) {
                                            ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                            if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                }
                                                float f1115 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                float f1116 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                final Function2<? super Composer, ? super Integer, Unit> function11114 = function11112;
                                                final Function2<? super Composer, ? super Integer, Unit> function11115 = function11113;
                                                AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f1115, f1116, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                    {
                                                        super(2);
                                                    }

                                                    public Object invoke(Object obj, Object obj2) {
                                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                                        return Unit.INSTANCE;
                                                    }

                                                    public final void invoke(Composer composer5, int i17) {
                                                        ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                        if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                            if (ComposerKt.isTraceInProgress()) {
                                                                ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                            }
                                                            Function2<Composer, Integer, Unit> function11116 = function11114;
                                                            composer5.startReplaceGroup(-779485335);
                                                            ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                            if (function11116 != null) {
                                                                function11116.invoke(composer5, 0);
                                                                Unit unit = Unit.INSTANCE;
                                                            }
                                                            composer5.endReplaceGroup();
                                                            function11115.invoke(composer5, 0);
                                                            if (ComposerKt.isTraceInProgress()) {
                                                                ComposerKt.traceEventEnd();
                                                                return;
                                                            }
                                                            return;
                                                        }
                                                        composer5.skipToGroupEnd();
                                                    }
                                                }, composer4, 54), composer4, 438);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer4.skipToGroupEnd();
                                        }
                                    }, composer3, 54), composer3, 384);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    composer3.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    composer3.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer3.skipToGroupEnd();
                            }
                        }, composer2, 54), composer2, 12582918, 104);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer2.skipToGroupEnd();
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier2 = companion;
            function6 = function1117;
            shape3 = shape1114;
            f2 = f1113;
            datePickerColors2 = datePickerColors1113;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) == 0) {
                if (i12 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i4 != 0) {
                    function5 = null;
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                }
                if (i6 != 0) {
                    fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                }
                if ((i2 & 64) != 0) {
                    i3 &= -3670017;
                    datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                }
                if (i8 != 0) {
                    dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                } else {
                    dialogProperties2 = dialogProperties;
                }
            } else {
                if (i12 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i4 != 0) {
                    function5 = null;
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    shape2 = DatePickerDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                }
                if (i6 != 0) {
                    fM2272getTonalElevationD9Ej5fM = DatePickerDefaults.INSTANCE.m2272getTonalElevationD9Ej5fM();
                }
                if ((i2 & 64) != 0) {
                    i3 &= -3670017;
                    datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                }
                if (i8 != 0) {
                    dialogProperties2 = new DialogProperties(false, false, false, 3, (DefaultConstructorMarker) null);
                } else {
                    dialogProperties2 = dialogProperties;
                }
            }
            final Function2<? super Composer, ? super Integer, Unit> function1118 = function5;
            final Shape shape1115 = shape2;
            final float f1114 = fM2272getTonalElevationD9Ej5fM;
            final DatePickerColors datePickerColors1114 = datePickerColorsColors;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-36517340, i3, -1, "androidx.compose.material3.DatePickerDialog (DatePickerDialog.android.kt:76)");
            }
            AlertDialogKt.BasicAlertDialog(function0, SizeKt.wrapContentHeight$default(companion, null, false, 3, null), dialogProperties2, ComposableLambdaKt.rememberComposableLambda(-10625622, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i14) {
                    ComposerKt.sourceInformation(composer2, "C89@4257L1289,82@3947L1599:DatePickerDialog.android.kt#uh7d8r");
                    if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-10625622, i14, -1, "androidx.compose.material3.DatePickerDialog.<anonymous> (DatePickerDialog.android.kt:82)");
                        }
                        Modifier modifierM1068heightInVpY3zN4$default = SizeKt.m1068heightInVpY3zN4$default(SizeKt.m1077requiredWidth3ABfNKs(Modifier.INSTANCE, DatePickerModalTokens.INSTANCE.m3505getContainerWidthD9Ej5fM()), 0.0f, DatePickerModalTokens.INSTANCE.m3504getContainerHeightD9Ej5fM(), 1, null);
                        Shape shape1116 = shape1115;
                        long containerColor = datePickerColors1114.getContainerColor();
                        float f1115 = f1114;
                        final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function1119 = function4;
                        final Function2<? super Composer, ? super Integer, Unit> function11110 = function1118;
                        final Function2<? super Composer, ? super Integer, Unit> function11111 = function2;
                        SurfaceKt.m2868SurfaceT9BRK9s(modifierM1068heightInVpY3zN4$default, shape1116, containerColor, 0L, f1115, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1706202235, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer3, int i15) {
                                ComposerKt.sourceInformation(composer3, "C90@4271L1265:DatePickerDialog.android.kt#uh7d8r");
                                if ((i15 & 3) != 2 || !composer3.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1706202235, i15, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous> (DatePickerDialog.android.kt:90)");
                                    }
                                    Arrangement.HorizontalOrVertical spaceBetween = Arrangement.INSTANCE.getSpaceBetween();
                                    Function3<ColumnScope, Composer, Integer, Unit> function11112 = function1119;
                                    final Function2<? super Composer, ? super Integer, Unit> function11113 = function11110;
                                    final Function2<? super Composer, ? super Integer, Unit> function11114 = function11111;
                                    ComposerKt.sourceInformationMarkerStart(composer3, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                    Modifier.Companion companion2 = Modifier.INSTANCE;
                                    MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(spaceBetween, Alignment.INSTANCE.getStart(), composer3, 6);
                                    ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                    CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, companion2);
                                    Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer3.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer3.startReusableNode();
                                    if (composer3.getInserting()) {
                                        composer3.createNode(constructor);
                                    } else {
                                        composer3.useNode();
                                    }
                                    Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer3, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                    ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer3, -2140243970, "C96@4721L64,98@4829L693:DatePickerDialog.android.kt#uh7d8r");
                                    Modifier modifierWeight = columnScopeInstance.weight(Modifier.INSTANCE, 1.0f, false);
                                    ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                    CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierWeight);
                                    Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer3.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer3.startReusableNode();
                                    if (composer3.getInserting()) {
                                        composer3.createNode(constructor2);
                                    } else {
                                        composer3.useNode();
                                    }
                                    Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                    Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                        composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                        composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer3, 1276701771, "C96@4774L9:DatePickerDialog.android.kt#uh7d8r");
                                    function11112.invoke(columnScopeInstance, composer3, 6);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    composer3.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    Modifier modifierPadding = PaddingKt.padding(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), DatePickerDialog_androidKt.DialogButtonsPadding);
                                    ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                    CompositionLocalMap currentCompositionLocalMap3 = composer3.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer3, modifierPadding);
                                    Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer3.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer3.startReusableNode();
                                    if (composer3.getInserting()) {
                                        composer3.createNode(constructor3);
                                    } else {
                                        composer3.useNode();
                                    }
                                    Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer3);
                                    Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                        composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                        composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer3, 1276882687, "C100@5030L5,101@5106L5,102@5134L370,99@4927L577:DatePickerDialog.android.kt#uh7d8r");
                                    ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(ColorSchemeKt.getValue(DialogTokens.INSTANCE.getActionLabelTextColor(), composer3, 6), TypographyKt.getValue(DialogTokens.INSTANCE.getActionLabelTextFont(), composer3, 6), ComposableLambdaKt.rememberComposableLambda(642347978, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer4, int i16) {
                                            ComposerKt.sourceInformation(composer4, "C106@5359L123,103@5160L322:DatePickerDialog.android.kt#uh7d8r");
                                            if ((i16 & 3) != 2 || !composer4.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(642347978, i16, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:103)");
                                                }
                                                float f1116 = DatePickerDialog_androidKt.DialogButtonsMainAxisSpacing;
                                                float f1117 = DatePickerDialog_androidKt.DialogButtonsCrossAxisSpacing;
                                                final Function2<? super Composer, ? super Integer, Unit> function11115 = function11113;
                                                final Function2<? super Composer, ? super Integer, Unit> function11116 = function11114;
                                                AlertDialogKt.m1988AlertDialogFlowRowixp7dh8(f1116, f1117, ComposableLambdaKt.rememberComposableLambda(1241707635, true, new Function2<Composer, Integer, Unit>() {
                                                    {
                                                        super(2);
                                                    }

                                                    public Object invoke(Object obj, Object obj2) {
                                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                                        return Unit.INSTANCE;
                                                    }

                                                    public final void invoke(Composer composer5, int i17) {
                                                        ComposerKt.sourceInformation(composer5, "C108@5441L15:DatePickerDialog.android.kt#uh7d8r");
                                                        if ((i17 & 3) != 2 || !composer5.getSkipping()) {
                                                            if (ComposerKt.isTraceInProgress()) {
                                                                ComposerKt.traceEventStart(1241707635, i17, -1, "androidx.compose.material3.DatePickerDialog.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DatePickerDialog.android.kt:107)");
                                                            }
                                                            Function2<Composer, Integer, Unit> function11117 = function11115;
                                                            composer5.startReplaceGroup(-779485335);
                                                            ComposerKt.sourceInformation(composer5, "107@5404L8");
                                                            if (function11117 != null) {
                                                                function11117.invoke(composer5, 0);
                                                                Unit unit = Unit.INSTANCE;
                                                            }
                                                            composer5.endReplaceGroup();
                                                            function11116.invoke(composer5, 0);
                                                            if (ComposerKt.isTraceInProgress()) {
                                                                ComposerKt.traceEventEnd();
                                                                return;
                                                            }
                                                            return;
                                                        }
                                                        composer5.skipToGroupEnd();
                                                    }
                                                }, composer4, 54), composer4, 438);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer4.skipToGroupEnd();
                                        }
                                    }, composer3, 54), composer3, 384);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    composer3.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    composer3.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer3.skipToGroupEnd();
                            }
                        }, composer2, 54), composer2, 12582918, 104);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer2.skipToGroupEnd();
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i3 & 14) | 3072 | ((i3 >> 15) & 896), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier2 = companion;
            function6 = function1118;
            shape3 = shape1115;
            f2 = f1114;
            datePickerColors2 = datePickerColors1114;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final DialogProperties dialogProperties18 = dialogProperties2;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i14) {
                    DatePickerDialog_androidKt.m2273DatePickerDialogGmEhDVc(function0, function2, modifier2, function6, shape3, f2, datePickerColors2, dialogProperties18, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    static {
        float f = 8;
        DialogButtonsPadding = PaddingKt.m1032PaddingValuesa9UjIt4$default(0.0f, 0.0f, Dp.constructor-impl(6), Dp.constructor-impl(f), 3, null);
        DialogButtonsMainAxisSpacing = Dp.constructor-impl(f);
    }
}
