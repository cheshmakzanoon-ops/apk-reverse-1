package androidx.compose.material3;

import androidx.compose.animation.SingleValueAnimationKt;
import androidx.compose.animation.core.AnimateAsStateKt;
import androidx.compose.animation.core.AnimationSpecKt;
import androidx.compose.foundation.BackgroundKt;
import androidx.compose.foundation.IndicationKt;
import androidx.compose.foundation.interaction.InteractionSourceKt;
import androidx.compose.foundation.interaction.MutableInteractionSource;
import androidx.compose.foundation.layout.Arrangement;
import androidx.compose.foundation.layout.BoxKt;
import androidx.compose.foundation.layout.BoxScopeInstance;
import androidx.compose.foundation.layout.PaddingKt;
import androidx.compose.foundation.layout.RowKt;
import androidx.compose.foundation.layout.RowScope;
import androidx.compose.foundation.layout.RowScopeInstance;
import androidx.compose.foundation.layout.SizeKt;
import androidx.compose.foundation.layout.WindowInsets;
import androidx.compose.foundation.layout.WindowInsetsPaddingKt;
import androidx.compose.foundation.selection.SelectableGroupKt;
import androidx.compose.foundation.selection.SelectableKt;
import androidx.compose.material3.internal.MappedInteractionSource;
import androidx.compose.material3.internal.ProvideContentColorTextStyleKt;
import androidx.compose.material3.tokens.NavigationBarTokens;
import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.ComposedModifierKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.draw.ClipKt;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.GraphicsLayerModifierKt;
import androidx.compose.p002ui.graphics.GraphicsLayerScope;
import androidx.compose.p002ui.layout.IntrinsicMeasureScope;
import androidx.compose.p002ui.layout.LayoutIdKt;
import androidx.compose.p002ui.layout.Measurable;
import androidx.compose.p002ui.layout.MeasurePolicy;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.MeasureScope;
import androidx.compose.p002ui.layout.OnRemeasuredModifierKt;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.p002ui.node.ComposeUiNode;
import androidx.compose.p002ui.platform.CompositionLocalsKt;
import androidx.compose.p002ui.semantics.Role;
import androidx.compose.p002ui.semantics.SemanticsModifierKt;
import androidx.compose.p002ui.semantics.SemanticsPropertyReceiver;
import androidx.compose.runtime.Applier;
import androidx.compose.runtime.ComposablesKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocalKt;
import androidx.compose.runtime.CompositionLocalMap;
import androidx.compose.runtime.MutableIntState;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.runtime.ProvidedValue;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.SnapshotIntStateKt;
import androidx.compose.runtime.State;
import androidx.compose.runtime.Updater;
import androidx.compose.runtime.internal.ComposableLambda;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.ConstraintsKt;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.Dp;
import androidx.compose.ui.unit.IntSize;
import java.util.List;
import java.util.NoSuchElementException;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Intrinsics;
import kotlin.math.MathKt;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000\u0084\u0001\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0010\b\n\u0002\b\u0007\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\n\u001ab\u0010\u0013\u001a\u00020\u00142\b\b\u0002\u0010\u0015\u001a\u00020\u00162\b\b\u0002\u0010\u0017\u001a\u00020\u00182\b\b\u0002\u0010\u0019\u001a\u00020\u00182\b\b\u0002\u0010\u001a\u001a\u00020\u00032\b\b\u0002\u0010\u001b\u001a\u00020\u001c2\u001c\u0010\u001d\u001a\u0018\u0012\u0004\u0012\u00020\u001f\u0012\u0004\u0012\u00020\u00140\u001e¢\u0006\u0002\b ¢\u0006\u0002\b!H\u0007ø\u0001\u0000¢\u0006\u0004\b\"\u0010#\u001aq\u0010$\u001a\u00020\u00142\u0011\u0010%\u001a\r\u0012\u0004\u0012\u00020\u00140&¢\u0006\u0002\b 2\u0011\u0010'\u001a\r\u0012\u0004\u0012\u00020\u00140&¢\u0006\u0002\b 2\u0011\u0010(\u001a\r\u0012\u0004\u0012\u00020\u00140&¢\u0006\u0002\b 2\u0013\u0010)\u001a\u000f\u0012\u0004\u0012\u00020\u0014\u0018\u00010&¢\u0006\u0002\b 2\u0006\u0010*\u001a\u00020+2\f\u0010,\u001a\b\u0012\u0004\u0012\u00020-0&H\u0003¢\u0006\u0002\u0010.\u001a\u0085\u0001\u0010/\u001a\u00020\u0014*\u00020\u001f2\u0006\u00100\u001a\u00020+2\f\u00101\u001a\b\u0012\u0004\u0012\u00020\u00140&2\u0011\u0010(\u001a\r\u0012\u0004\u0012\u00020\u00140&¢\u0006\u0002\b 2\b\b\u0002\u0010\u0015\u001a\u00020\u00162\b\b\u0002\u00102\u001a\u00020+2\u0015\b\u0002\u0010)\u001a\u000f\u0012\u0004\u0012\u00020\u0014\u0018\u00010&¢\u0006\u0002\b 2\b\b\u0002\u0010*\u001a\u00020+2\b\b\u0002\u00103\u001a\u0002042\n\b\u0002\u00105\u001a\u0004\u0018\u000106H\u0007¢\u0006\u0002\u00107\u001a8\u00108\u001a\u000209*\u00020:2\u0006\u0010;\u001a\u00020<2\u0006\u0010=\u001a\u00020<2\b\u0010>\u001a\u0004\u0018\u00010<2\u0006\u0010?\u001a\u00020@H\u0002ø\u0001\u0000¢\u0006\u0004\bA\u0010B\u001aP\u0010C\u001a\u000209*\u00020:2\u0006\u0010D\u001a\u00020<2\u0006\u0010;\u001a\u00020<2\u0006\u0010=\u001a\u00020<2\b\u0010>\u001a\u0004\u0018\u00010<2\u0006\u0010?\u001a\u00020@2\u0006\u0010*\u001a\u00020+2\u0006\u0010,\u001a\u00020-H\u0002ø\u0001\u0000¢\u0006\u0004\bE\u0010F\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000\"\u0010\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0004\"\u000e\u0010\u0005\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\u0006\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000\"\u0010\u0010\u0007\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0004\"\u0016\u0010\b\u001a\u00020\u0003X\u0080\u0004¢\u0006\n\n\u0002\u0010\u0004\u001a\u0004\b\t\u0010\n\"\u000e\u0010\u000b\u001a\u00020\fX\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\r\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000\"\u0010\u0010\u000e\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0004\"\u0016\u0010\u000f\u001a\u00020\u0003X\u0080\u0004¢\u0006\n\n\u0002\u0010\u0004\u001a\u0004\b\u0010\u0010\n\"\u0016\u0010\u0011\u001a\u00020\u0003X\u0080\u0004¢\u0006\n\n\u0002\u0010\u0004\u001a\u0004\b\u0012\u0010\n\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006G²\u0006\n\u0010H\u001a\u00020\u0018X\u008a\u0084\u0002²\u0006\n\u0010I\u001a\u00020\u0018X\u008a\u0084\u0002²\u0006\n\u0010J\u001a\u00020\fX\u008a\u008e\u0002"}, d2 = {"IconLayoutIdTag", "", "IndicatorHorizontalPadding", "Landroidx/compose/ui/unit/Dp;", "F", "IndicatorLayoutIdTag", "IndicatorRippleLayoutIdTag", "IndicatorVerticalOffset", "IndicatorVerticalPadding", "getIndicatorVerticalPadding", "()F", "ItemAnimationDurationMillis", "", "LabelLayoutIdTag", "NavigationBarHeight", "NavigationBarIndicatorToLabelPadding", "getNavigationBarIndicatorToLabelPadding", "NavigationBarItemHorizontalPadding", "getNavigationBarItemHorizontalPadding", "NavigationBar", "", "modifier", "Landroidx/compose/ui/Modifier;", "containerColor", "Landroidx/compose/ui/graphics/Color;", "contentColor", "tonalElevation", "windowInsets", "Landroidx/compose/foundation/layout/WindowInsets;", "content", "Lkotlin/Function1;", "Landroidx/compose/foundation/layout/RowScope;", "Landroidx/compose/runtime/Composable;", "Lkotlin/ExtensionFunctionType;", "NavigationBar-HsRjFd4", "(Landroidx/compose/ui/Modifier;JJFLandroidx/compose/foundation/layout/WindowInsets;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "NavigationBarItemLayout", NavigationBarKt.IndicatorRippleLayoutIdTag, "Lkotlin/Function0;", NavigationBarKt.IndicatorLayoutIdTag, NavigationBarKt.IconLayoutIdTag, NavigationBarKt.LabelLayoutIdTag, "alwaysShowLabel", "", "animationProgress", "", "(Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;ZLkotlin/jvm/functions/Function0;Landroidx/compose/runtime/Composer;I)V", "NavigationBarItem", "selected", "onClick", "enabled", "colors", "Landroidx/compose/material3/NavigationBarItemColors;", "interactionSource", "Landroidx/compose/foundation/interaction/MutableInteractionSource;", "(Landroidx/compose/foundation/layout/RowScope;ZLkotlin/jvm/functions/Function0;Lkotlin/jvm/functions/Function2;Landroidx/compose/ui/Modifier;ZLkotlin/jvm/functions/Function2;ZLandroidx/compose/material3/NavigationBarItemColors;Landroidx/compose/foundation/interaction/MutableInteractionSource;Landroidx/compose/runtime/Composer;II)V", "placeIcon", "Landroidx/compose/ui/layout/MeasureResult;", "Landroidx/compose/ui/layout/MeasureScope;", "iconPlaceable", "Landroidx/compose/ui/layout/Placeable;", "indicatorRipplePlaceable", "indicatorPlaceable", "constraints", "Landroidx/compose/ui/unit/Constraints;", "placeIcon-X9ElhV4", "(Landroidx/compose/ui/layout/MeasureScope;Landroidx/compose/ui/layout/Placeable;Landroidx/compose/ui/layout/Placeable;Landroidx/compose/ui/layout/Placeable;J)Landroidx/compose/ui/layout/MeasureResult;", "placeLabelAndIcon", "labelPlaceable", "placeLabelAndIcon-zUg2_y0", "(Landroidx/compose/ui/layout/MeasureScope;Landroidx/compose/ui/layout/Placeable;Landroidx/compose/ui/layout/Placeable;Landroidx/compose/ui/layout/Placeable;Landroidx/compose/ui/layout/Placeable;JZF)Landroidx/compose/ui/layout/MeasureResult;", "material3_release", "iconColor", "textColor", "itemWidth"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class NavigationBarKt {
    private static final String IconLayoutIdTag = "icon";
    private static final float IndicatorHorizontalPadding;
    private static final String IndicatorLayoutIdTag = "indicator";
    private static final String IndicatorRippleLayoutIdTag = "indicatorRipple";
    private static final float IndicatorVerticalPadding;
    private static final int ItemAnimationDurationMillis = 100;
    private static final String LabelLayoutIdTag = "label";
    private static final float NavigationBarHeight = NavigationBarTokens.INSTANCE.m3685getContainerHeightD9Ej5fM();
    private static final float NavigationBarItemHorizontalPadding = Dp.constructor-impl(8);
    private static final float NavigationBarIndicatorToLabelPadding = Dp.constructor-impl(4);
    private static final float IndicatorVerticalOffset = Dp.constructor-impl(12);

    public static final void m2567NavigationBarHsRjFd4(Modifier modifier, long j, long j2, float f, WindowInsets windowInsets, final Function3<? super RowScope, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2) {
        Modifier modifier2;
        int i3;
        long containerColor;
        long jM2172contentColorFor4WTKRHQ;
        float fM2552getElevationD9Ej5fM;
        WindowInsets windowInsets2;
        int i4;
        Modifier.Companion companion;
        final WindowInsets windowInsets3;
        float f2;
        int i5;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i6;
        Composer composerStartRestartGroup = composer.startRestartGroup(1596802123);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(NavigationBar)P(3,0:c#ui.graphics.Color,2:c#ui.graphics.Color,4:c#ui.unit.Dp,5)111@5198L14,112@5254L11,114@5412L12,122@5632L441,117@5479L594:NavigationBar.kt#uh7d8r");
        int i7 = i2 & 1;
        if (i7 != 0) {
            i3 = i | 6;
            modifier2 = modifier;
        } else if ((i & 6) == 0) {
            modifier2 = modifier;
            i3 = (composerStartRestartGroup.changed(modifier2) ? 4 : 2) | i;
        } else {
            modifier2 = modifier;
            i3 = i;
        }
        if ((i & 48) == 0) {
            if ((i2 & 2) == 0) {
                containerColor = j;
                int i8 = composerStartRestartGroup.changed(containerColor) ? 32 : 16;
                i3 |= i8;
            } else {
                containerColor = j;
            }
            i3 |= i8;
        } else {
            containerColor = j;
        }
        if ((i & 384) == 0) {
            jM2172contentColorFor4WTKRHQ = j2;
            i3 |= ((i2 & 4) == 0 && composerStartRestartGroup.changed(jM2172contentColorFor4WTKRHQ)) ? Fields.RotationX : Fields.SpotShadowColor;
        } else {
            jM2172contentColorFor4WTKRHQ = j2;
        }
        int i9 = i2 & 8;
        if (i9 == 0) {
            if ((i & 3072) == 0) {
                fM2552getElevationD9Ej5fM = f;
                i3 |= composerStartRestartGroup.changed(fM2552getElevationD9Ej5fM) ? Fields.CameraDistance : Fields.RotationZ;
            }
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    windowInsets2 = windowInsets;
                    if (composerStartRestartGroup.changed(windowInsets2)) {
                        i6 = Fields.Clip;
                    }
                    i3 |= i6;
                } else {
                    windowInsets2 = windowInsets;
                }
                i6 = Fields.Shape;
                i3 |= i6;
            } else {
                windowInsets2 = windowInsets;
            }
            if ((i2 & 32) != 0) {
                i3 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i4 = Fields.RenderEffect;
                } else {
                    i4 = 65536;
                }
                i3 |= i4;
            }
            if ((74899 & i3) == 74898 || !composerStartRestartGroup.getSkipping()) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) == 0 && !composerStartRestartGroup.getDefaultsInvalid()) {
                    composerStartRestartGroup.skipToGroupEnd();
                    if ((i2 & 2) != 0) {
                        i3 &= -113;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                    }
                    companion = modifier2;
                } else {
                    if (i7 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 2) != 0) {
                        containerColor = NavigationBarDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i3 &= -113;
                    }
                    if ((i2 & 4) != 0) {
                        jM2172contentColorFor4WTKRHQ = ColorSchemeKt.m2172contentColorFor4WTKRHQ(MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6), containerColor);
                        i3 &= -897;
                    }
                    if (i9 != 0) {
                        fM2552getElevationD9Ej5fM = NavigationBarDefaults.INSTANCE.m2552getElevationD9Ej5fM();
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        windowInsets3 = NavigationBarDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                        f2 = fM2552getElevationD9Ej5fM;
                    }
                    long j3 = jM2172contentColorFor4WTKRHQ;
                    i5 = i3;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1596802123, i5, -1, "androidx.compose.material3.NavigationBar (NavigationBar.kt:116)");
                    }
                    int i10 = (i5 & 14) | 12582912;
                    int i11 = i5 << 3;
                    int i12 = i10 | (i11 & 896) | (i11 & 7168) | (i11 & 57344);
                    WindowInsets windowInsets4 = windowInsets3;
                    SurfaceKt.m2868SurfaceT9BRK9s(companion, null, containerColor, j3, f2, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(105663120, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i13) {
                            ComposerKt.sourceInformation(composer2, "C123@5642L425:NavigationBar.kt#uh7d8r");
                            if ((i13 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(105663120, i13, -1, "androidx.compose.material3.NavigationBar.<anonymous> (NavigationBar.kt:123)");
                                }
                                Modifier modifierSelectableGroup = SelectableGroupKt.selectableGroup(SizeKt.m1065defaultMinSizeVpY3zN4$default(WindowInsetsPaddingKt.windowInsetsPadding(SizeKt.fillMaxWidth$default(Modifier.INSTANCE, 0.0f, 1, null), windowInsets3), 0.0f, NavigationBarKt.NavigationBarHeight, 1, null));
                                Arrangement.HorizontalOrVertical horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(NavigationBarKt.getNavigationBarItemHorizontalPadding());
                                Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                                Function3<RowScope, Composer, Integer, Unit> function4 = function3;
                                ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(horizontalOrVerticalM911spacedBy0680j_4, centerVertically, composer2, 54);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierSelectableGroup);
                                Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer2.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer2.startReusableNode();
                                if (composer2.getInserting()) {
                                    composer2.createNode(constructor);
                                } else {
                                    composer2.useNode();
                                }
                                Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer2);
                                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyRowMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                function4.invoke(RowScopeInstance.INSTANCE, composer2, 6);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, i12, 98);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    windowInsets2 = windowInsets4;
                    jM2172contentColorFor4WTKRHQ = j3;
                }
                f2 = fM2552getElevationD9Ej5fM;
                windowInsets3 = windowInsets2;
                long j4 = jM2172contentColorFor4WTKRHQ;
                i5 = i3;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1596802123, i5, -1, "androidx.compose.material3.NavigationBar (NavigationBar.kt:116)");
                }
                int i13 = (i5 & 14) | 12582912;
                int i14 = i5 << 3;
                int i15 = i13 | (i14 & 896) | (i14 & 7168) | (i14 & 57344);
                WindowInsets windowInsets5 = windowInsets3;
                SurfaceKt.m2868SurfaceT9BRK9s(companion, null, containerColor, j4, f2, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(105663120, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i16) {
                        ComposerKt.sourceInformation(composer2, "C123@5642L425:NavigationBar.kt#uh7d8r");
                        if ((i16 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(105663120, i16, -1, "androidx.compose.material3.NavigationBar.<anonymous> (NavigationBar.kt:123)");
                            }
                            Modifier modifierSelectableGroup = SelectableGroupKt.selectableGroup(SizeKt.m1065defaultMinSizeVpY3zN4$default(WindowInsetsPaddingKt.windowInsetsPadding(SizeKt.fillMaxWidth$default(Modifier.INSTANCE, 0.0f, 1, null), windowInsets3), 0.0f, NavigationBarKt.NavigationBarHeight, 1, null));
                            Arrangement.HorizontalOrVertical horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(NavigationBarKt.getNavigationBarItemHorizontalPadding());
                            Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                            Function3<RowScope, Composer, Integer, Unit> function4 = function3;
                            ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                            MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(horizontalOrVerticalM911spacedBy0680j_4, centerVertically, composer2, 54);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierSelectableGroup);
                            Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                            ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                            if (!(composer2.getApplier() instanceof Applier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composer2.startReusableNode();
                            if (composer2.getInserting()) {
                                composer2.createNode(constructor);
                            } else {
                                composer2.useNode();
                            }
                            Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer2);
                            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyRowMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                            ComposerKt.sourceInformationMarkerStart(composer2, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                            function4.invoke(RowScopeInstance.INSTANCE, composer2, 6);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, i15, 98);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                windowInsets2 = windowInsets5;
                jM2172contentColorFor4WTKRHQ = j4;
            } else {
                composerStartRestartGroup.skipToGroupEnd();
                companion = modifier2;
                f2 = fM2552getElevationD9Ej5fM;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier3 = companion;
                final long j5 = containerColor;
                final long j6 = jM2172contentColorFor4WTKRHQ;
                final float f3 = f2;
                final WindowInsets windowInsets6 = windowInsets2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i16) {
                        NavigationBarKt.m2567NavigationBarHsRjFd4(modifier3, j5, j6, f3, windowInsets6, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        fM2552getElevationD9Ej5fM = f;
        if ((i & 24576) == 0) {
            if ((i2 & 16) == 0) {
                windowInsets2 = windowInsets;
                if (composerStartRestartGroup.changed(windowInsets2)) {
                    i6 = Fields.Clip;
                }
                i3 |= i6;
            } else {
                windowInsets2 = windowInsets;
            }
            i6 = Fields.Shape;
            i3 |= i6;
        } else {
            windowInsets2 = windowInsets;
        }
        if ((i2 & 32) != 0) {
            i3 |= 196608;
        } else if ((i & 196608) == 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i4 = Fields.RenderEffect;
            } else {
                i4 = 65536;
            }
            i3 |= i4;
        }
        if ((74899 & i3) == 74898) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) == 0) {
                if (i7 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 2) != 0) {
                    containerColor = NavigationBarDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    i3 &= -113;
                }
                if ((i2 & 4) != 0) {
                    jM2172contentColorFor4WTKRHQ = ColorSchemeKt.m2172contentColorFor4WTKRHQ(MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6), containerColor);
                    i3 &= -897;
                }
                if (i9 != 0) {
                    fM2552getElevationD9Ej5fM = NavigationBarDefaults.INSTANCE.m2552getElevationD9Ej5fM();
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    windowInsets3 = NavigationBarDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                    f2 = fM2552getElevationD9Ej5fM;
                } else {
                    f2 = fM2552getElevationD9Ej5fM;
                    windowInsets3 = windowInsets2;
                }
            } else {
                if (i7 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 2) != 0) {
                    containerColor = NavigationBarDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    i3 &= -113;
                }
                if ((i2 & 4) != 0) {
                    jM2172contentColorFor4WTKRHQ = ColorSchemeKt.m2172contentColorFor4WTKRHQ(MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6), containerColor);
                    i3 &= -897;
                }
                if (i9 != 0) {
                    fM2552getElevationD9Ej5fM = NavigationBarDefaults.INSTANCE.m2552getElevationD9Ej5fM();
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    windowInsets3 = NavigationBarDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                    f2 = fM2552getElevationD9Ej5fM;
                } else {
                    f2 = fM2552getElevationD9Ej5fM;
                    windowInsets3 = windowInsets2;
                }
            }
            long j7 = jM2172contentColorFor4WTKRHQ;
            i5 = i3;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1596802123, i5, -1, "androidx.compose.material3.NavigationBar (NavigationBar.kt:116)");
            }
            int i16 = (i5 & 14) | 12582912;
            int i17 = i5 << 3;
            int i18 = i16 | (i17 & 896) | (i17 & 7168) | (i17 & 57344);
            WindowInsets windowInsets7 = windowInsets3;
            SurfaceKt.m2868SurfaceT9BRK9s(companion, null, containerColor, j7, f2, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(105663120, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i19) {
                    ComposerKt.sourceInformation(composer2, "C123@5642L425:NavigationBar.kt#uh7d8r");
                    if ((i19 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(105663120, i19, -1, "androidx.compose.material3.NavigationBar.<anonymous> (NavigationBar.kt:123)");
                        }
                        Modifier modifierSelectableGroup = SelectableGroupKt.selectableGroup(SizeKt.m1065defaultMinSizeVpY3zN4$default(WindowInsetsPaddingKt.windowInsetsPadding(SizeKt.fillMaxWidth$default(Modifier.INSTANCE, 0.0f, 1, null), windowInsets3), 0.0f, NavigationBarKt.NavigationBarHeight, 1, null));
                        Arrangement.HorizontalOrVertical horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(NavigationBarKt.getNavigationBarItemHorizontalPadding());
                        Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                        Function3<RowScope, Composer, Integer, Unit> function4 = function3;
                        ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                        MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(horizontalOrVerticalM911spacedBy0680j_4, centerVertically, composer2, 54);
                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                        CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierSelectableGroup);
                        Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composer2.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composer2.startReusableNode();
                        if (composer2.getInserting()) {
                            composer2.createNode(constructor);
                        } else {
                            composer2.useNode();
                        }
                        Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer2);
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyRowMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                        ComposerKt.sourceInformationMarkerStart(composer2, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                        function4.invoke(RowScopeInstance.INSTANCE, composer2, 6);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        composer2.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer2.skipToGroupEnd();
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, i18, 98);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            windowInsets2 = windowInsets7;
            jM2172contentColorFor4WTKRHQ = j7;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) == 0) {
                if (i7 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 2) != 0) {
                    containerColor = NavigationBarDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    i3 &= -113;
                }
                if ((i2 & 4) != 0) {
                    jM2172contentColorFor4WTKRHQ = ColorSchemeKt.m2172contentColorFor4WTKRHQ(MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6), containerColor);
                    i3 &= -897;
                }
                if (i9 != 0) {
                    fM2552getElevationD9Ej5fM = NavigationBarDefaults.INSTANCE.m2552getElevationD9Ej5fM();
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    windowInsets3 = NavigationBarDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                    f2 = fM2552getElevationD9Ej5fM;
                } else {
                    f2 = fM2552getElevationD9Ej5fM;
                    windowInsets3 = windowInsets2;
                }
            } else {
                if (i7 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 2) != 0) {
                    containerColor = NavigationBarDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    i3 &= -113;
                }
                if ((i2 & 4) != 0) {
                    jM2172contentColorFor4WTKRHQ = ColorSchemeKt.m2172contentColorFor4WTKRHQ(MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6), containerColor);
                    i3 &= -897;
                }
                if (i9 != 0) {
                    fM2552getElevationD9Ej5fM = NavigationBarDefaults.INSTANCE.m2552getElevationD9Ej5fM();
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    windowInsets3 = NavigationBarDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                    f2 = fM2552getElevationD9Ej5fM;
                } else {
                    f2 = fM2552getElevationD9Ej5fM;
                    windowInsets3 = windowInsets2;
                }
            }
            long j8 = jM2172contentColorFor4WTKRHQ;
            i5 = i3;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1596802123, i5, -1, "androidx.compose.material3.NavigationBar (NavigationBar.kt:116)");
            }
            int i19 = (i5 & 14) | 12582912;
            int i110 = i5 << 3;
            int i111 = i19 | (i110 & 896) | (i110 & 7168) | (i110 & 57344);
            WindowInsets windowInsets8 = windowInsets3;
            SurfaceKt.m2868SurfaceT9BRK9s(companion, null, containerColor, j8, f2, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(105663120, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i112) {
                    ComposerKt.sourceInformation(composer2, "C123@5642L425:NavigationBar.kt#uh7d8r");
                    if ((i112 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(105663120, i112, -1, "androidx.compose.material3.NavigationBar.<anonymous> (NavigationBar.kt:123)");
                        }
                        Modifier modifierSelectableGroup = SelectableGroupKt.selectableGroup(SizeKt.m1065defaultMinSizeVpY3zN4$default(WindowInsetsPaddingKt.windowInsetsPadding(SizeKt.fillMaxWidth$default(Modifier.INSTANCE, 0.0f, 1, null), windowInsets3), 0.0f, NavigationBarKt.NavigationBarHeight, 1, null));
                        Arrangement.HorizontalOrVertical horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(NavigationBarKt.getNavigationBarItemHorizontalPadding());
                        Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                        Function3<RowScope, Composer, Integer, Unit> function4 = function3;
                        ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                        MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(horizontalOrVerticalM911spacedBy0680j_4, centerVertically, composer2, 54);
                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                        CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierSelectableGroup);
                        Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composer2.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composer2.startReusableNode();
                        if (composer2.getInserting()) {
                            composer2.createNode(constructor);
                        } else {
                            composer2.useNode();
                        }
                        Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer2);
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyRowMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                        ComposerKt.sourceInformationMarkerStart(composer2, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                        function4.invoke(RowScopeInstance.INSTANCE, composer2, 6);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        composer2.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer2.skipToGroupEnd();
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, i111, 98);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            windowInsets2 = windowInsets8;
            jM2172contentColorFor4WTKRHQ = j8;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier4 = companion;
            final long j9 = containerColor;
            final long j10 = jM2172contentColorFor4WTKRHQ;
            final float f4 = f2;
            final WindowInsets windowInsets9 = windowInsets2;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i112) {
                    NavigationBarKt.m2567NavigationBarHsRjFd4(modifier4, j9, j10, f4, windowInsets9, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void NavigationBarItem(final RowScope rowScope, final boolean z, final Function0<Unit> function0, final Function2<? super Composer, ? super Integer, Unit> function2, Modifier modifier, boolean z2, Function2<? super Composer, ? super Integer, Unit> function3, boolean z3, NavigationBarItemColors navigationBarItemColors, MutableInteractionSource mutableInteractionSource, Composer composer, final int i, final int i2) {
        int i3;
        int i4;
        int i5;
        int i6;
        Function2<? super Composer, ? super Integer, Unit> function4;
        int i7;
        int i8;
        boolean z4;
        int i9;
        int i10;
        int i11;
        Modifier.Companion companion;
        boolean z5;
        Function2<? super Composer, ? super Integer, Unit> function5;
        NavigationBarItemColors navigationBarItemColorsColors;
        MutableInteractionSource mutableInteractionSource2;
        final boolean z6;
        int i12;
        final Function2<? super Composer, ? super Integer, Unit> function6;
        final NavigationBarItemColors navigationBarItemColors2;
        MutableInteractionSource mutableInteractionSource3;
        ComposableLambda composableLambdaRememberComposableLambda;
        Object objRememberedValue;
        final MutableIntState mutableIntState;
        MutableInteractionSource mutableInteractionSource4;
        Object objRememberedValue2;
        int currentCompositeKeyHash;
        Function0<ComposeUiNode> constructor;
        Composer composerM4037constructorimpl;
        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash;
        float f;
        final State<Float> stateAnimateFloatAsState;
        long jOffset;
        boolean zChanged;
        Object objRememberedValue3;
        boolean zChanged2;
        Object objRememberedValue4;
        final NavigationBarItemColors navigationBarItemColors3;
        final boolean z7;
        final boolean z8;
        final MutableInteractionSource mutableInteractionSource5;
        final Function2<? super Composer, ? super Integer, Unit> function7;
        final Modifier modifier2;
        Object objRememberedValue5;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(-663510974);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(NavigationBarItem)P(8,7,3,6,2,5)179@8344L8,185@8576L633,215@9873L33,229@10315L24,217@9912L2687:NavigationBar.kt#uh7d8r");
        if ((Integer.MIN_VALUE & i2) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(rowScope) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        if ((i2 & 1) != 0) {
            i3 |= 48;
        } else if ((i & 48) == 0) {
            i3 |= composerStartRestartGroup.changed(z) ? 32 : 16;
        }
        if ((i2 & 2) != 0) {
            i3 |= 384;
        } else if ((i & 384) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function0) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i2 & 4) != 0) {
            i3 |= 3072;
        } else if ((i & 3072) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function2) ? Fields.CameraDistance : Fields.RotationZ;
        }
        int i13 = i2 & 8;
        if (i13 == 0) {
            if ((i & 24576) == 0) {
                i3 |= composerStartRestartGroup.changed(modifier) ? Fields.Clip : Fields.Shape;
            }
            i4 = i2 & 16;
            if (i4 != 0) {
                if ((196608 & i) == 0) {
                    if (composerStartRestartGroup.changed(z2)) {
                        i5 = Fields.RenderEffect;
                    } else {
                        i5 = 65536;
                    }
                    i3 |= i5;
                }
                i6 = i2 & 32;
                if (i6 != 0) {
                    if ((1572864 & i) == 0) {
                        function4 = function3;
                        if (composerStartRestartGroup.changedInstance(function4)) {
                            i7 = 1048576;
                        } else {
                            i7 = 524288;
                        }
                        i3 |= i7;
                    }
                    i8 = i2 & 64;
                    if (i8 != 0) {
                        i3 |= 12582912;
                        z4 = z3;
                    } else {
                        z4 = z3;
                        if ((i & 12582912) == 0) {
                            if (composerStartRestartGroup.changed(z4)) {
                                i9 = 8388608;
                            } else {
                                i9 = 4194304;
                            }
                            i3 |= i9;
                        }
                    }
                    if ((i & 100663296) != 0) {
                        i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(navigationBarItemColors)) ? 33554432 : 67108864;
                    }
                    i10 = i2 & Fields.RotationX;
                    if (i10 != 0) {
                        i3 |= 805306368;
                    } else if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                            i11 = 536870912;
                        } else {
                            i11 = 268435456;
                        }
                        i3 |= i11;
                    }
                    if ((i3 & 306783379) == 306783378 || !composerStartRestartGroup.getSkipping()) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i4 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            } else {
                                function5 = function3;
                            }
                            if (i8 != 0) {
                                z4 = true;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                                i3 &= -234881025;
                            } else {
                                navigationBarItemColorsColors = navigationBarItemColors;
                            }
                            if (i10 != 0) {
                                mutableInteractionSource2 = null;
                            } else {
                                mutableInteractionSource2 = mutableInteractionSource;
                            }
                            z6 = z5;
                            i12 = i3;
                            NavigationBarItemColors navigationBarItemColors4 = navigationBarItemColorsColors;
                            function6 = function5;
                            navigationBarItemColors2 = navigationBarItemColors4;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                i3 &= -234881025;
                            }
                            companion = modifier;
                            function6 = function3;
                            navigationBarItemColors2 = navigationBarItemColors;
                            mutableInteractionSource2 = mutableInteractionSource;
                            i12 = i3;
                            z4 = z4;
                            z6 = z2;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-663510974, i12, -1, "androidx.compose.material3.NavigationBarItem (NavigationBar.kt:181)");
                        }
                        composerStartRestartGroup.startReplaceGroup(-103235253);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "183@8495L39");
                        if (mutableInteractionSource2 == null) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103234602, "CC(remember):NavigationBar.kt#9igjgp");
                            objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue5 = InteractionSourceKt.MutableInteractionSource();
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue5;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        final NavigationBarItemColors navigationBarItemColors5 = navigationBarItemColors2;
                        final boolean z9 = z6;
                        final Function2<? super Composer, ? super Integer, Unit> function8 = function6;
                        final boolean z10 = z4;
                        int i14 = i12;
                        ComposableLambda composableLambdaRememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-1419576100, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i15) {
                                ComposerKt.sourceInformation(composer2, "C187@8623L201,193@9006L193:NavigationBar.kt#uh7d8r");
                                if ((i15 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1419576100, i15, -1, "androidx.compose.material3.NavigationBarItem.<anonymous> (NavigationBar.kt:186)");
                                    }
                                    State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors5.m2563iconColorWaAFU9c$material3_release(z, z9), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12);
                                    Modifier.Companion companionClearAndSetSemantics = (function8 == null || !(z10 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                        }

                                        public Object invoke(Object obj) {
                                            invoke((SemanticsPropertyReceiver) obj);
                                            return Unit.INSTANCE;
                                        }
                                    });
                                    Function2<Composer, Integer, Unit> function9 = function2;
                                    ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                    CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, companionClearAndSetSemantics);
                                    Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer2.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer2.startReusableNode();
                                    if (composer2.getInserting()) {
                                        composer2.createNode(constructor2);
                                    } else {
                                        composer2.useNode();
                                    }
                                    Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer2);
                                    Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                        composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                        composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer2, -1543680408, "C194@9107L78:NavigationBar.kt#uh7d8r");
                                    CompositionLocalKt.CompositionLocalProvider(ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(invoke$lambda$0(stateM387animateColorAsStateeuL9pac))), function9, composer2, ProvidedValue.$stable);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    composer2.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }

                            private static final long invoke$lambda$0(State<Color> state) {
                                return state.getValue().m4600unboximpl();
                            }
                        }, composerStartRestartGroup, 54);
                        composerStartRestartGroup.startReplaceGroup(-103209106);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9305L535");
                        if (function6 == null) {
                            composableLambdaRememberComposableLambda = null;
                        } else {
                            composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1644987592, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i15) {
                                    ComposerKt.sourceInformation(composer2, "C201@9369L5,203@9428L213,207@9658L168:NavigationBar.kt#uh7d8r");
                                    if ((i15 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(1644987592, i15, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:201)");
                                        }
                                        ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors2.m2564textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationBarTokens.INSTANCE.getLabelTextFont(), composer2, 6), function6, composer2, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }

                                private static final long invoke$lambda$0(State<Color> state) {
                                    return state.getValue().m4600unboximpl();
                                }
                            }, composerStartRestartGroup, 54);
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103190512, "CC(remember):NavigationBar.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = SnapshotIntStateKt.mutableIntStateOf(0);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableIntState = (MutableIntState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Modifier modifier3 = companion;
                        mutableInteractionSource4 = mutableInteractionSource3;
                        Modifier modifierWeight$default = RowScope.CC.weight$default(rowScope, SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationBarHeight, 1, null), 1.0f, false, 2, null);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103176377, "CC(remember):NavigationBar.kt#9igjgp");
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue2 = (Function1) new Function1<IntSize, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    m2572invokeozmzZPI(((IntSize) obj).unbox-impl());
                                    return Unit.INSTANCE;
                                }

                                public final void m2572invokeozmzZPI(long j) {
                                    mutableIntState.setIntValue(IntSize.getWidth-impl(j));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Modifier modifierOnSizeChanged = OnRemeasuredModifierKt.onSizeChanged(modifierWeight$default, (Function1) objRememberedValue2);
                        Alignment center = Alignment.INSTANCE.getCenter();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(center, true);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierOnSizeChanged);
                        constructor = ComposeUiNode.INSTANCE.getConstructor();
                        final NavigationBarItemColors navigationBarItemColors6 = navigationBarItemColors2;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(constructor);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (!composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                        BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1652122706, "C234@10492L157,*243@10933L7,249@11215L128,256@11558L293,264@11900L395,281@12555L27,275@12305L288:NavigationBar.kt#uh7d8r");
                        if (z) {
                            f = 1.0f;
                        } else {
                            f = 0.0f;
                        }
                        Function2<? super Composer, ? super Integer, Unit> function9 = function6;
                        stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
                        ProvidableCompositionLocal<Density> localDensity = CompositionLocalsKt.getLocalDensity();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume = composerStartRestartGroup.consume(localDensity);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Density density = (Density) objConsume;
                        jOffset = OffsetKt.Offset((NavigationBarItem$lambda$3(mutableIntState) - density.roundToPx-0680j_4(NavigationBarTokens.INSTANCE.m3683getActiveIndicatorWidthD9Ej5fM())) / 2, density.toPx-0680j_4(IndicatorVerticalOffset));
                        Unit unit = Unit.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024938414, "CC(remember):NavigationBar.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        final MappedInteractionSource mappedInteractionSource = (MappedInteractionSource) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposableLambda composableLambdaRememberComposableLambda3 = ComposableLambdaKt.rememberComposableLambda(691730997, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i15) {
                                ComposerKt.sourceInformation(composer2, "C259@11718L5,260@11786L32,257@11576L261:NavigationBar.kt#uh7d8r");
                                if ((i15 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(691730997, i15, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:257)");
                                    }
                                    BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), mappedInteractionSource, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        ComposableLambda composableLambdaRememberComposableLambda4 = ComposableLambdaKt.rememberComposableLambda(-474426875, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i15) {
                                ComposerKt.sourceInformation(composer2, "C267@12022L35,270@12231L5,265@11918L363:NavigationBar.kt#uh7d8r");
                                if ((i15 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-474426875, i15, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:265)");
                                    }
                                    Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1335770416, "CC(remember):NavigationBar.kt#9igjgp");
                                    boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                                    final State<Float> state = stateAnimateFloatAsState;
                                    Object objRememberedValue6 = composer2.rememberedValue();
                                    if (zChanged3 || objRememberedValue6 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue6 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
                                            {
                                                super(1);
                                            }

                                            public Object invoke(Object obj) {
                                                invoke((GraphicsLayerScope) obj);
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(GraphicsLayerScope graphicsLayerScope) {
                                                graphicsLayerScope.setAlpha(state.getValue().floatValue());
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue6);
                                    }
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue6), navigationBarItemColors6.getSelectedIndicatorColor(), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024981193, "CC(remember):NavigationBar.kt#9igjgp");
                        zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
                        objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged2 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue4 = (Function0) new Function0<Float>() {
                                {
                                    super(0);
                                }

                                public final Float m2573invoke() {
                                    return stateAnimateFloatAsState.getValue();
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        NavigationBarItemLayout(composableLambdaRememberComposableLambda3, composableLambdaRememberComposableLambda4, composableLambdaRememberComposableLambda2, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue4, composerStartRestartGroup, ((i14 >> 9) & 57344) | 438);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        navigationBarItemColors3 = navigationBarItemColors6;
                        z7 = z6;
                        z8 = z4;
                        mutableInteractionSource5 = mutableInteractionSource2;
                        function7 = function9;
                        modifier2 = modifier3;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        modifier2 = modifier;
                        z7 = z2;
                        mutableInteractionSource5 = mutableInteractionSource;
                        function7 = function4;
                        z8 = z4;
                        navigationBarItemColors3 = navigationBarItemColors;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i15) {
                                NavigationBarKt.NavigationBarItem(rowScope, z, function0, function2, modifier2, z7, function7, z8, navigationBarItemColors3, mutableInteractionSource5, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 1572864;
                function4 = function3;
                i8 = i2 & 64;
                if (i8 != 0) {
                    i3 |= 12582912;
                    z4 = z3;
                } else {
                    z4 = z3;
                    if ((i & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(z4)) {
                            i9 = 8388608;
                        } else {
                            i9 = 4194304;
                        }
                        i3 |= i9;
                    }
                }
                if ((i & 100663296) != 0) {
                    i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(navigationBarItemColors)) ? 33554432 : 67108864;
                }
                i10 = i2 & Fields.RotationX;
                if (i10 != 0) {
                    i3 |= 805306368;
                } else if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                        i11 = 536870912;
                    } else {
                        i11 = 268435456;
                    }
                    i3 |= i11;
                }
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        } else {
                            function5 = function3;
                        }
                        if (i8 != 0) {
                            z4 = true;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            i3 &= -234881025;
                        } else {
                            navigationBarItemColorsColors = navigationBarItemColors;
                        }
                        if (i10 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                        z6 = z5;
                        i12 = i3;
                        NavigationBarItemColors navigationBarItemColors7 = navigationBarItemColorsColors;
                        function6 = function5;
                        navigationBarItemColors2 = navigationBarItemColors7;
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        } else {
                            function5 = function3;
                        }
                        if (i8 != 0) {
                            z4 = true;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            i3 &= -234881025;
                        } else {
                            navigationBarItemColorsColors = navigationBarItemColors;
                        }
                        if (i10 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                        z6 = z5;
                        i12 = i3;
                        NavigationBarItemColors navigationBarItemColors8 = navigationBarItemColorsColors;
                        function6 = function5;
                        navigationBarItemColors2 = navigationBarItemColors8;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-663510974, i12, -1, "androidx.compose.material3.NavigationBarItem (NavigationBar.kt:181)");
                    }
                    composerStartRestartGroup.startReplaceGroup(-103235253);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "183@8495L39");
                    if (mutableInteractionSource2 == null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103234602, "CC(remember):NavigationBar.kt#9igjgp");
                        objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue5 = InteractionSourceKt.MutableInteractionSource();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue5;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    final NavigationBarItemColors navigationBarItemColors9 = navigationBarItemColors2;
                    final boolean z11 = z6;
                    final Function2<? super Composer, ? super Integer, Unit> function10 = function6;
                    final boolean z12 = z4;
                    int i15 = i12;
                    ComposableLambda composableLambdaRememberComposableLambda5 = ComposableLambdaKt.rememberComposableLambda(-1419576100, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i16) {
                            ComposerKt.sourceInformation(composer2, "C187@8623L201,193@9006L193:NavigationBar.kt#uh7d8r");
                            if ((i16 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1419576100, i16, -1, "androidx.compose.material3.NavigationBarItem.<anonymous> (NavigationBar.kt:186)");
                                }
                                State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors9.m2563iconColorWaAFU9c$material3_release(z, z11), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12);
                                Modifier.Companion companionClearAndSetSemantics = (function10 == null || !(z12 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((SemanticsPropertyReceiver) obj);
                                        return Unit.INSTANCE;
                                    }
                                });
                                Function2<Composer, Integer, Unit> function11 = function2;
                                ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap2 = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer2, companionClearAndSetSemantics);
                                Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer2.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer2.startReusableNode();
                                if (composer2.getInserting()) {
                                    composer2.createNode(constructor2);
                                } else {
                                    composer2.useNode();
                                }
                                Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer2);
                                Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                    composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                    composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer2, -1543680408, "C194@9107L78:NavigationBar.kt#uh7d8r");
                                CompositionLocalKt.CompositionLocalProvider(ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(invoke$lambda$0(stateM387animateColorAsStateeuL9pac))), function11, composer2, ProvidedValue.$stable);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }

                        private static final long invoke$lambda$0(State<Color> state) {
                            return state.getValue().m4600unboximpl();
                        }
                    }, composerStartRestartGroup, 54);
                    composerStartRestartGroup.startReplaceGroup(-103209106);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9305L535");
                    if (function6 == null) {
                        composableLambdaRememberComposableLambda = null;
                    } else {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1644987592, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i16) {
                                ComposerKt.sourceInformation(composer2, "C201@9369L5,203@9428L213,207@9658L168:NavigationBar.kt#uh7d8r");
                                if ((i16 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1644987592, i16, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:201)");
                                    }
                                    ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors2.m2564textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationBarTokens.INSTANCE.getLabelTextFont(), composer2, 6), function6, composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }

                            private static final long invoke$lambda$0(State<Color> state) {
                                return state.getValue().m4600unboximpl();
                            }
                        }, composerStartRestartGroup, 54);
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103190512, "CC(remember):NavigationBar.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotIntStateKt.mutableIntStateOf(0);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableIntState = (MutableIntState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifier4 = companion;
                    mutableInteractionSource4 = mutableInteractionSource3;
                    Modifier modifierWeight$default2 = RowScope.CC.weight$default(rowScope, SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationBarHeight, 1, null), 1.0f, false, 2, null);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103176377, "CC(remember):NavigationBar.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = (Function1) new Function1<IntSize, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                m2572invokeozmzZPI(((IntSize) obj).unbox-impl());
                                return Unit.INSTANCE;
                            }

                            public final void m2572invokeozmzZPI(long j) {
                                mutableIntState.setIntValue(IntSize.getWidth-impl(j));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierOnSizeChanged2 = OnRemeasuredModifierKt.onSizeChanged(modifierWeight$default2, (Function1) objRememberedValue2);
                    Alignment center2 = Alignment.INSTANCE.getCenter();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(center2, true);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap2 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierOnSizeChanged2);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    final NavigationBarItemColors navigationBarItemColors10 = navigationBarItemColors2;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                    BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1652122706, "C234@10492L157,*243@10933L7,249@11215L128,256@11558L293,264@11900L395,281@12555L27,275@12305L288:NavigationBar.kt#uh7d8r");
                    if (z) {
                        f = 1.0f;
                    } else {
                        f = 0.0f;
                    }
                    Function2<? super Composer, ? super Integer, Unit> function11 = function6;
                    stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
                    ProvidableCompositionLocal<Density> localDensity2 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume2 = composerStartRestartGroup.consume(localDensity2);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Density density2 = (Density) objConsume2;
                    jOffset = OffsetKt.Offset((NavigationBarItem$lambda$3(mutableIntState) - density2.roundToPx-0680j_4(NavigationBarTokens.INSTANCE.m3683getActiveIndicatorWidthD9Ej5fM())) / 2, density2.toPx-0680j_4(IndicatorVerticalOffset));
                    Unit unit2 = Unit.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024938414, "CC(remember):NavigationBar.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    final MappedInteractionSource mappedInteractionSource2 = (MappedInteractionSource) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposableLambda composableLambdaRememberComposableLambda6 = ComposableLambdaKt.rememberComposableLambda(691730997, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i16) {
                            ComposerKt.sourceInformation(composer2, "C259@11718L5,260@11786L32,257@11576L261:NavigationBar.kt#uh7d8r");
                            if ((i16 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(691730997, i16, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:257)");
                                }
                                BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), mappedInteractionSource2, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    ComposableLambda composableLambdaRememberComposableLambda7 = ComposableLambdaKt.rememberComposableLambda(-474426875, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i16) {
                            ComposerKt.sourceInformation(composer2, "C267@12022L35,270@12231L5,265@11918L363:NavigationBar.kt#uh7d8r");
                            if ((i16 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-474426875, i16, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:265)");
                                }
                                Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                                ComposerKt.sourceInformationMarkerStart(composer2, 1335770416, "CC(remember):NavigationBar.kt#9igjgp");
                                boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                                final State<Float> state = stateAnimateFloatAsState;
                                Object objRememberedValue6 = composer2.rememberedValue();
                                if (zChanged3 || objRememberedValue6 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue6 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            invoke((GraphicsLayerScope) obj);
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(GraphicsLayerScope graphicsLayerScope) {
                                            graphicsLayerScope.setAlpha(state.getValue().floatValue());
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue6);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue6), navigationBarItemColors10.getSelectedIndicatorColor(), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024981193, "CC(remember):NavigationBar.kt#9igjgp");
                    zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
                    objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged2) {
                        objRememberedValue4 = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2573invoke() {
                                return stateAnimateFloatAsState.getValue();
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    } else {
                        objRememberedValue4 = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2573invoke() {
                                return stateAnimateFloatAsState.getValue();
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    NavigationBarItemLayout(composableLambdaRememberComposableLambda6, composableLambdaRememberComposableLambda7, composableLambdaRememberComposableLambda5, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue4, composerStartRestartGroup, ((i15 >> 9) & 57344) | 438);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    navigationBarItemColors3 = navigationBarItemColors10;
                    z7 = z6;
                    z8 = z4;
                    mutableInteractionSource5 = mutableInteractionSource2;
                    function7 = function11;
                    modifier2 = modifier4;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        } else {
                            function5 = function3;
                        }
                        if (i8 != 0) {
                            z4 = true;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            i3 &= -234881025;
                        } else {
                            navigationBarItemColorsColors = navigationBarItemColors;
                        }
                        if (i10 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                        z6 = z5;
                        i12 = i3;
                        NavigationBarItemColors navigationBarItemColors11 = navigationBarItemColorsColors;
                        function6 = function5;
                        navigationBarItemColors2 = navigationBarItemColors11;
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        } else {
                            function5 = function3;
                        }
                        if (i8 != 0) {
                            z4 = true;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            i3 &= -234881025;
                        } else {
                            navigationBarItemColorsColors = navigationBarItemColors;
                        }
                        if (i10 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                        z6 = z5;
                        i12 = i3;
                        NavigationBarItemColors navigationBarItemColors12 = navigationBarItemColorsColors;
                        function6 = function5;
                        navigationBarItemColors2 = navigationBarItemColors12;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-663510974, i12, -1, "androidx.compose.material3.NavigationBarItem (NavigationBar.kt:181)");
                    }
                    composerStartRestartGroup.startReplaceGroup(-103235253);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "183@8495L39");
                    if (mutableInteractionSource2 == null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103234602, "CC(remember):NavigationBar.kt#9igjgp");
                        objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue5 = InteractionSourceKt.MutableInteractionSource();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue5;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    final NavigationBarItemColors navigationBarItemColors13 = navigationBarItemColors2;
                    final boolean z13 = z6;
                    final Function2<? super Composer, ? super Integer, Unit> function12 = function6;
                    final boolean z14 = z4;
                    int i16 = i12;
                    ComposableLambda composableLambdaRememberComposableLambda8 = ComposableLambdaKt.rememberComposableLambda(-1419576100, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i17) {
                            ComposerKt.sourceInformation(composer2, "C187@8623L201,193@9006L193:NavigationBar.kt#uh7d8r");
                            if ((i17 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1419576100, i17, -1, "androidx.compose.material3.NavigationBarItem.<anonymous> (NavigationBar.kt:186)");
                                }
                                State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors13.m2563iconColorWaAFU9c$material3_release(z, z13), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12);
                                Modifier.Companion companionClearAndSetSemantics = (function12 == null || !(z14 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((SemanticsPropertyReceiver) obj);
                                        return Unit.INSTANCE;
                                    }
                                });
                                Function2<Composer, Integer, Unit> function13 = function2;
                                ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy3 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap3 = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer2, companionClearAndSetSemantics);
                                Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer2.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer2.startReusableNode();
                                if (composer2.getInserting()) {
                                    composer2.createNode(constructor2);
                                } else {
                                    composer2.useNode();
                                }
                                Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer2);
                                Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy3, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                    composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                    composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance3 = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer2, -1543680408, "C194@9107L78:NavigationBar.kt#uh7d8r");
                                CompositionLocalKt.CompositionLocalProvider(ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(invoke$lambda$0(stateM387animateColorAsStateeuL9pac))), function13, composer2, ProvidedValue.$stable);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }

                        private static final long invoke$lambda$0(State<Color> state) {
                            return state.getValue().m4600unboximpl();
                        }
                    }, composerStartRestartGroup, 54);
                    composerStartRestartGroup.startReplaceGroup(-103209106);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9305L535");
                    if (function6 == null) {
                        composableLambdaRememberComposableLambda = null;
                    } else {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1644987592, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i17) {
                                ComposerKt.sourceInformation(composer2, "C201@9369L5,203@9428L213,207@9658L168:NavigationBar.kt#uh7d8r");
                                if ((i17 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1644987592, i17, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:201)");
                                    }
                                    ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors2.m2564textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationBarTokens.INSTANCE.getLabelTextFont(), composer2, 6), function6, composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }

                            private static final long invoke$lambda$0(State<Color> state) {
                                return state.getValue().m4600unboximpl();
                            }
                        }, composerStartRestartGroup, 54);
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103190512, "CC(remember):NavigationBar.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotIntStateKt.mutableIntStateOf(0);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableIntState = (MutableIntState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifier5 = companion;
                    mutableInteractionSource4 = mutableInteractionSource3;
                    Modifier modifierWeight$default3 = RowScope.CC.weight$default(rowScope, SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationBarHeight, 1, null), 1.0f, false, 2, null);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103176377, "CC(remember):NavigationBar.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = (Function1) new Function1<IntSize, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                m2572invokeozmzZPI(((IntSize) obj).unbox-impl());
                                return Unit.INSTANCE;
                            }

                            public final void m2572invokeozmzZPI(long j) {
                                mutableIntState.setIntValue(IntSize.getWidth-impl(j));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierOnSizeChanged3 = OnRemeasuredModifierKt.onSizeChanged(modifierWeight$default3, (Function1) objRememberedValue2);
                    Alignment center3 = Alignment.INSTANCE.getCenter();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy3 = BoxKt.maybeCachedBoxMeasurePolicy(center3, true);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap3 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierOnSizeChanged3);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    final NavigationBarItemColors navigationBarItemColors14 = navigationBarItemColors2;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy3, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                    BoxScopeInstance boxScopeInstance3 = BoxScopeInstance.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1652122706, "C234@10492L157,*243@10933L7,249@11215L128,256@11558L293,264@11900L395,281@12555L27,275@12305L288:NavigationBar.kt#uh7d8r");
                    if (z) {
                        f = 1.0f;
                    } else {
                        f = 0.0f;
                    }
                    Function2<? super Composer, ? super Integer, Unit> function13 = function6;
                    stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
                    ProvidableCompositionLocal<Density> localDensity3 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume3 = composerStartRestartGroup.consume(localDensity3);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Density density3 = (Density) objConsume3;
                    jOffset = OffsetKt.Offset((NavigationBarItem$lambda$3(mutableIntState) - density3.roundToPx-0680j_4(NavigationBarTokens.INSTANCE.m3683getActiveIndicatorWidthD9Ej5fM())) / 2, density3.toPx-0680j_4(IndicatorVerticalOffset));
                    Unit unit3 = Unit.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024938414, "CC(remember):NavigationBar.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    final MappedInteractionSource mappedInteractionSource3 = (MappedInteractionSource) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposableLambda composableLambdaRememberComposableLambda9 = ComposableLambdaKt.rememberComposableLambda(691730997, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i17) {
                            ComposerKt.sourceInformation(composer2, "C259@11718L5,260@11786L32,257@11576L261:NavigationBar.kt#uh7d8r");
                            if ((i17 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(691730997, i17, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:257)");
                                }
                                BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), mappedInteractionSource3, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    ComposableLambda composableLambdaRememberComposableLambda10 = ComposableLambdaKt.rememberComposableLambda(-474426875, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i17) {
                            ComposerKt.sourceInformation(composer2, "C267@12022L35,270@12231L5,265@11918L363:NavigationBar.kt#uh7d8r");
                            if ((i17 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-474426875, i17, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:265)");
                                }
                                Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                                ComposerKt.sourceInformationMarkerStart(composer2, 1335770416, "CC(remember):NavigationBar.kt#9igjgp");
                                boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                                final State<Float> state = stateAnimateFloatAsState;
                                Object objRememberedValue6 = composer2.rememberedValue();
                                if (zChanged3 || objRememberedValue6 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue6 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            invoke((GraphicsLayerScope) obj);
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(GraphicsLayerScope graphicsLayerScope) {
                                            graphicsLayerScope.setAlpha(state.getValue().floatValue());
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue6);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue6), navigationBarItemColors14.getSelectedIndicatorColor(), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024981193, "CC(remember):NavigationBar.kt#9igjgp");
                    zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
                    objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged2) {
                        objRememberedValue4 = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2573invoke() {
                                return stateAnimateFloatAsState.getValue();
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    } else {
                        objRememberedValue4 = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2573invoke() {
                                return stateAnimateFloatAsState.getValue();
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    NavigationBarItemLayout(composableLambdaRememberComposableLambda9, composableLambdaRememberComposableLambda10, composableLambdaRememberComposableLambda8, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue4, composerStartRestartGroup, ((i16 >> 9) & 57344) | 438);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    navigationBarItemColors3 = navigationBarItemColors14;
                    z7 = z6;
                    z8 = z4;
                    mutableInteractionSource5 = mutableInteractionSource2;
                    function7 = function13;
                    modifier2 = modifier5;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i17) {
                            NavigationBarKt.NavigationBarItem(rowScope, z, function0, function2, modifier2, z7, function7, z8, navigationBarItemColors3, mutableInteractionSource5, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            i6 = i2 & 32;
            if (i6 != 0) {
                if ((1572864 & i) == 0) {
                    function4 = function3;
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i7 = 1048576;
                    } else {
                        i7 = 524288;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 64;
                if (i8 != 0) {
                    i3 |= 12582912;
                    z4 = z3;
                } else {
                    z4 = z3;
                    if ((i & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(z4)) {
                            i9 = 8388608;
                        } else {
                            i9 = 4194304;
                        }
                        i3 |= i9;
                    }
                }
                if ((i & 100663296) != 0) {
                    i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(navigationBarItemColors)) ? 33554432 : 67108864;
                }
                i10 = i2 & Fields.RotationX;
                if (i10 != 0) {
                    i3 |= 805306368;
                } else if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                        i11 = 536870912;
                    } else {
                        i11 = 268435456;
                    }
                    i3 |= i11;
                }
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        } else {
                            function5 = function3;
                        }
                        if (i8 != 0) {
                            z4 = true;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            i3 &= -234881025;
                        } else {
                            navigationBarItemColorsColors = navigationBarItemColors;
                        }
                        if (i10 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                        z6 = z5;
                        i12 = i3;
                        NavigationBarItemColors navigationBarItemColors15 = navigationBarItemColorsColors;
                        function6 = function5;
                        navigationBarItemColors2 = navigationBarItemColors15;
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        } else {
                            function5 = function3;
                        }
                        if (i8 != 0) {
                            z4 = true;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            i3 &= -234881025;
                        } else {
                            navigationBarItemColorsColors = navigationBarItemColors;
                        }
                        if (i10 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                        z6 = z5;
                        i12 = i3;
                        NavigationBarItemColors navigationBarItemColors16 = navigationBarItemColorsColors;
                        function6 = function5;
                        navigationBarItemColors2 = navigationBarItemColors16;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-663510974, i12, -1, "androidx.compose.material3.NavigationBarItem (NavigationBar.kt:181)");
                    }
                    composerStartRestartGroup.startReplaceGroup(-103235253);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "183@8495L39");
                    if (mutableInteractionSource2 == null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103234602, "CC(remember):NavigationBar.kt#9igjgp");
                        objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue5 = InteractionSourceKt.MutableInteractionSource();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue5;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    final NavigationBarItemColors navigationBarItemColors17 = navigationBarItemColors2;
                    final boolean z15 = z6;
                    final Function2<? super Composer, ? super Integer, Unit> function14 = function6;
                    final boolean z16 = z4;
                    int i17 = i12;
                    ComposableLambda composableLambdaRememberComposableLambda11 = ComposableLambdaKt.rememberComposableLambda(-1419576100, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i18) {
                            ComposerKt.sourceInformation(composer2, "C187@8623L201,193@9006L193:NavigationBar.kt#uh7d8r");
                            if ((i18 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1419576100, i18, -1, "androidx.compose.material3.NavigationBarItem.<anonymous> (NavigationBar.kt:186)");
                                }
                                State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors17.m2563iconColorWaAFU9c$material3_release(z, z15), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12);
                                Modifier.Companion companionClearAndSetSemantics = (function14 == null || !(z16 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((SemanticsPropertyReceiver) obj);
                                        return Unit.INSTANCE;
                                    }
                                });
                                Function2<Composer, Integer, Unit> function15 = function2;
                                ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy4 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap4 = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier4 = ComposedModifierKt.materializeModifier(composer2, companionClearAndSetSemantics);
                                Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer2.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer2.startReusableNode();
                                if (composer2.getInserting()) {
                                    composer2.createNode(constructor2);
                                } else {
                                    composer2.useNode();
                                }
                                Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer2);
                                Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy4, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap4, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                    composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                    composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier4, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance4 = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer2, -1543680408, "C194@9107L78:NavigationBar.kt#uh7d8r");
                                CompositionLocalKt.CompositionLocalProvider(ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(invoke$lambda$0(stateM387animateColorAsStateeuL9pac))), function15, composer2, ProvidedValue.$stable);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }

                        private static final long invoke$lambda$0(State<Color> state) {
                            return state.getValue().m4600unboximpl();
                        }
                    }, composerStartRestartGroup, 54);
                    composerStartRestartGroup.startReplaceGroup(-103209106);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9305L535");
                    if (function6 == null) {
                        composableLambdaRememberComposableLambda = null;
                    } else {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1644987592, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i18) {
                                ComposerKt.sourceInformation(composer2, "C201@9369L5,203@9428L213,207@9658L168:NavigationBar.kt#uh7d8r");
                                if ((i18 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1644987592, i18, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:201)");
                                    }
                                    ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors2.m2564textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationBarTokens.INSTANCE.getLabelTextFont(), composer2, 6), function6, composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }

                            private static final long invoke$lambda$0(State<Color> state) {
                                return state.getValue().m4600unboximpl();
                            }
                        }, composerStartRestartGroup, 54);
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103190512, "CC(remember):NavigationBar.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotIntStateKt.mutableIntStateOf(0);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableIntState = (MutableIntState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifier6 = companion;
                    mutableInteractionSource4 = mutableInteractionSource3;
                    Modifier modifierWeight$default4 = RowScope.CC.weight$default(rowScope, SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationBarHeight, 1, null), 1.0f, false, 2, null);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103176377, "CC(remember):NavigationBar.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = (Function1) new Function1<IntSize, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                m2572invokeozmzZPI(((IntSize) obj).unbox-impl());
                                return Unit.INSTANCE;
                            }

                            public final void m2572invokeozmzZPI(long j) {
                                mutableIntState.setIntValue(IntSize.getWidth-impl(j));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierOnSizeChanged4 = OnRemeasuredModifierKt.onSizeChanged(modifierWeight$default4, (Function1) objRememberedValue2);
                    Alignment center4 = Alignment.INSTANCE.getCenter();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy4 = BoxKt.maybeCachedBoxMeasurePolicy(center4, true);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap4 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier4 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierOnSizeChanged4);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    final NavigationBarItemColors navigationBarItemColors18 = navigationBarItemColors2;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy4, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap4, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier4, ComposeUiNode.INSTANCE.getSetModifier());
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                    BoxScopeInstance boxScopeInstance4 = BoxScopeInstance.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1652122706, "C234@10492L157,*243@10933L7,249@11215L128,256@11558L293,264@11900L395,281@12555L27,275@12305L288:NavigationBar.kt#uh7d8r");
                    if (z) {
                        f = 1.0f;
                    } else {
                        f = 0.0f;
                    }
                    Function2<? super Composer, ? super Integer, Unit> function15 = function6;
                    stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
                    ProvidableCompositionLocal<Density> localDensity4 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume4 = composerStartRestartGroup.consume(localDensity4);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Density density4 = (Density) objConsume4;
                    jOffset = OffsetKt.Offset((NavigationBarItem$lambda$3(mutableIntState) - density4.roundToPx-0680j_4(NavigationBarTokens.INSTANCE.m3683getActiveIndicatorWidthD9Ej5fM())) / 2, density4.toPx-0680j_4(IndicatorVerticalOffset));
                    Unit unit4 = Unit.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024938414, "CC(remember):NavigationBar.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    final MappedInteractionSource mappedInteractionSource4 = (MappedInteractionSource) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposableLambda composableLambdaRememberComposableLambda12 = ComposableLambdaKt.rememberComposableLambda(691730997, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i18) {
                            ComposerKt.sourceInformation(composer2, "C259@11718L5,260@11786L32,257@11576L261:NavigationBar.kt#uh7d8r");
                            if ((i18 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(691730997, i18, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:257)");
                                }
                                BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), mappedInteractionSource4, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    ComposableLambda composableLambdaRememberComposableLambda13 = ComposableLambdaKt.rememberComposableLambda(-474426875, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i18) {
                            ComposerKt.sourceInformation(composer2, "C267@12022L35,270@12231L5,265@11918L363:NavigationBar.kt#uh7d8r");
                            if ((i18 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-474426875, i18, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:265)");
                                }
                                Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                                ComposerKt.sourceInformationMarkerStart(composer2, 1335770416, "CC(remember):NavigationBar.kt#9igjgp");
                                boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                                final State<Float> state = stateAnimateFloatAsState;
                                Object objRememberedValue6 = composer2.rememberedValue();
                                if (zChanged3 || objRememberedValue6 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue6 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            invoke((GraphicsLayerScope) obj);
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(GraphicsLayerScope graphicsLayerScope) {
                                            graphicsLayerScope.setAlpha(state.getValue().floatValue());
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue6);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue6), navigationBarItemColors18.getSelectedIndicatorColor(), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024981193, "CC(remember):NavigationBar.kt#9igjgp");
                    zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
                    objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged2) {
                        objRememberedValue4 = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2573invoke() {
                                return stateAnimateFloatAsState.getValue();
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    } else {
                        objRememberedValue4 = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2573invoke() {
                                return stateAnimateFloatAsState.getValue();
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    NavigationBarItemLayout(composableLambdaRememberComposableLambda12, composableLambdaRememberComposableLambda13, composableLambdaRememberComposableLambda11, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue4, composerStartRestartGroup, ((i17 >> 9) & 57344) | 438);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    navigationBarItemColors3 = navigationBarItemColors18;
                    z7 = z6;
                    z8 = z4;
                    mutableInteractionSource5 = mutableInteractionSource2;
                    function7 = function15;
                    modifier2 = modifier6;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        } else {
                            function5 = function3;
                        }
                        if (i8 != 0) {
                            z4 = true;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            i3 &= -234881025;
                        } else {
                            navigationBarItemColorsColors = navigationBarItemColors;
                        }
                        if (i10 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                        z6 = z5;
                        i12 = i3;
                        NavigationBarItemColors navigationBarItemColors19 = navigationBarItemColorsColors;
                        function6 = function5;
                        navigationBarItemColors2 = navigationBarItemColors19;
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        } else {
                            function5 = function3;
                        }
                        if (i8 != 0) {
                            z4 = true;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            i3 &= -234881025;
                        } else {
                            navigationBarItemColorsColors = navigationBarItemColors;
                        }
                        if (i10 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                        z6 = z5;
                        i12 = i3;
                        NavigationBarItemColors navigationBarItemColors110 = navigationBarItemColorsColors;
                        function6 = function5;
                        navigationBarItemColors2 = navigationBarItemColors110;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-663510974, i12, -1, "androidx.compose.material3.NavigationBarItem (NavigationBar.kt:181)");
                    }
                    composerStartRestartGroup.startReplaceGroup(-103235253);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "183@8495L39");
                    if (mutableInteractionSource2 == null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103234602, "CC(remember):NavigationBar.kt#9igjgp");
                        objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue5 = InteractionSourceKt.MutableInteractionSource();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue5;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    final NavigationBarItemColors navigationBarItemColors111 = navigationBarItemColors2;
                    final boolean z17 = z6;
                    final Function2<? super Composer, ? super Integer, Unit> function16 = function6;
                    final boolean z18 = z4;
                    int i18 = i12;
                    ComposableLambda composableLambdaRememberComposableLambda14 = ComposableLambdaKt.rememberComposableLambda(-1419576100, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i19) {
                            ComposerKt.sourceInformation(composer2, "C187@8623L201,193@9006L193:NavigationBar.kt#uh7d8r");
                            if ((i19 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1419576100, i19, -1, "androidx.compose.material3.NavigationBarItem.<anonymous> (NavigationBar.kt:186)");
                                }
                                State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors111.m2563iconColorWaAFU9c$material3_release(z, z17), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12);
                                Modifier.Companion companionClearAndSetSemantics = (function16 == null || !(z18 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((SemanticsPropertyReceiver) obj);
                                        return Unit.INSTANCE;
                                    }
                                });
                                Function2<Composer, Integer, Unit> function17 = function2;
                                ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy5 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap5 = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier5 = ComposedModifierKt.materializeModifier(composer2, companionClearAndSetSemantics);
                                Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer2.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer2.startReusableNode();
                                if (composer2.getInserting()) {
                                    composer2.createNode(constructor2);
                                } else {
                                    composer2.useNode();
                                }
                                Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer2);
                                Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy5, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap5, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                    composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                    composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier5, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance5 = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer2, -1543680408, "C194@9107L78:NavigationBar.kt#uh7d8r");
                                CompositionLocalKt.CompositionLocalProvider(ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(invoke$lambda$0(stateM387animateColorAsStateeuL9pac))), function17, composer2, ProvidedValue.$stable);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }

                        private static final long invoke$lambda$0(State<Color> state) {
                            return state.getValue().m4600unboximpl();
                        }
                    }, composerStartRestartGroup, 54);
                    composerStartRestartGroup.startReplaceGroup(-103209106);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9305L535");
                    if (function6 == null) {
                        composableLambdaRememberComposableLambda = null;
                    } else {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1644987592, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i19) {
                                ComposerKt.sourceInformation(composer2, "C201@9369L5,203@9428L213,207@9658L168:NavigationBar.kt#uh7d8r");
                                if ((i19 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1644987592, i19, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:201)");
                                    }
                                    ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors2.m2564textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationBarTokens.INSTANCE.getLabelTextFont(), composer2, 6), function6, composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }

                            private static final long invoke$lambda$0(State<Color> state) {
                                return state.getValue().m4600unboximpl();
                            }
                        }, composerStartRestartGroup, 54);
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103190512, "CC(remember):NavigationBar.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotIntStateKt.mutableIntStateOf(0);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableIntState = (MutableIntState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifier7 = companion;
                    mutableInteractionSource4 = mutableInteractionSource3;
                    Modifier modifierWeight$default5 = RowScope.CC.weight$default(rowScope, SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationBarHeight, 1, null), 1.0f, false, 2, null);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103176377, "CC(remember):NavigationBar.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = (Function1) new Function1<IntSize, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                m2572invokeozmzZPI(((IntSize) obj).unbox-impl());
                                return Unit.INSTANCE;
                            }

                            public final void m2572invokeozmzZPI(long j) {
                                mutableIntState.setIntValue(IntSize.getWidth-impl(j));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierOnSizeChanged5 = OnRemeasuredModifierKt.onSizeChanged(modifierWeight$default5, (Function1) objRememberedValue2);
                    Alignment center5 = Alignment.INSTANCE.getCenter();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy5 = BoxKt.maybeCachedBoxMeasurePolicy(center5, true);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap5 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier5 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierOnSizeChanged5);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    final NavigationBarItemColors navigationBarItemColors112 = navigationBarItemColors2;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy5, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap5, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier5, ComposeUiNode.INSTANCE.getSetModifier());
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                    BoxScopeInstance boxScopeInstance5 = BoxScopeInstance.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1652122706, "C234@10492L157,*243@10933L7,249@11215L128,256@11558L293,264@11900L395,281@12555L27,275@12305L288:NavigationBar.kt#uh7d8r");
                    if (z) {
                        f = 1.0f;
                    } else {
                        f = 0.0f;
                    }
                    Function2<? super Composer, ? super Integer, Unit> function17 = function6;
                    stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
                    ProvidableCompositionLocal<Density> localDensity5 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume5 = composerStartRestartGroup.consume(localDensity5);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Density density5 = (Density) objConsume5;
                    jOffset = OffsetKt.Offset((NavigationBarItem$lambda$3(mutableIntState) - density5.roundToPx-0680j_4(NavigationBarTokens.INSTANCE.m3683getActiveIndicatorWidthD9Ej5fM())) / 2, density5.toPx-0680j_4(IndicatorVerticalOffset));
                    Unit unit5 = Unit.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024938414, "CC(remember):NavigationBar.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    final MappedInteractionSource mappedInteractionSource5 = (MappedInteractionSource) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposableLambda composableLambdaRememberComposableLambda15 = ComposableLambdaKt.rememberComposableLambda(691730997, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i19) {
                            ComposerKt.sourceInformation(composer2, "C259@11718L5,260@11786L32,257@11576L261:NavigationBar.kt#uh7d8r");
                            if ((i19 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(691730997, i19, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:257)");
                                }
                                BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), mappedInteractionSource5, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    ComposableLambda composableLambdaRememberComposableLambda16 = ComposableLambdaKt.rememberComposableLambda(-474426875, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i19) {
                            ComposerKt.sourceInformation(composer2, "C267@12022L35,270@12231L5,265@11918L363:NavigationBar.kt#uh7d8r");
                            if ((i19 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-474426875, i19, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:265)");
                                }
                                Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                                ComposerKt.sourceInformationMarkerStart(composer2, 1335770416, "CC(remember):NavigationBar.kt#9igjgp");
                                boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                                final State<Float> state = stateAnimateFloatAsState;
                                Object objRememberedValue6 = composer2.rememberedValue();
                                if (zChanged3 || objRememberedValue6 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue6 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            invoke((GraphicsLayerScope) obj);
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(GraphicsLayerScope graphicsLayerScope) {
                                            graphicsLayerScope.setAlpha(state.getValue().floatValue());
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue6);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue6), navigationBarItemColors112.getSelectedIndicatorColor(), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024981193, "CC(remember):NavigationBar.kt#9igjgp");
                    zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
                    objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged2) {
                        objRememberedValue4 = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2573invoke() {
                                return stateAnimateFloatAsState.getValue();
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    } else {
                        objRememberedValue4 = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2573invoke() {
                                return stateAnimateFloatAsState.getValue();
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    NavigationBarItemLayout(composableLambdaRememberComposableLambda15, composableLambdaRememberComposableLambda16, composableLambdaRememberComposableLambda14, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue4, composerStartRestartGroup, ((i18 >> 9) & 57344) | 438);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    navigationBarItemColors3 = navigationBarItemColors112;
                    z7 = z6;
                    z8 = z4;
                    mutableInteractionSource5 = mutableInteractionSource2;
                    function7 = function17;
                    modifier2 = modifier7;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i19) {
                            NavigationBarKt.NavigationBarItem(rowScope, z, function0, function2, modifier2, z7, function7, z8, navigationBarItemColors3, mutableInteractionSource5, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 1572864;
            function4 = function3;
            i8 = i2 & 64;
            if (i8 != 0) {
                i3 |= 12582912;
                z4 = z3;
            } else {
                z4 = z3;
                if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(z4)) {
                        i9 = 8388608;
                    } else {
                        i9 = 4194304;
                    }
                    i3 |= i9;
                }
            }
            if ((i & 100663296) != 0) {
                i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(navigationBarItemColors)) ? 33554432 : 67108864;
            }
            i10 = i2 & Fields.RotationX;
            if (i10 != 0) {
                i3 |= 805306368;
            } else if ((i & 805306368) == 0) {
                if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                    i11 = 536870912;
                } else {
                    i11 = 268435456;
                }
                i3 |= i11;
            }
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    } else {
                        function5 = function3;
                    }
                    if (i8 != 0) {
                        z4 = true;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i3 &= -234881025;
                    } else {
                        navigationBarItemColorsColors = navigationBarItemColors;
                    }
                    if (i10 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    z6 = z5;
                    i12 = i3;
                    NavigationBarItemColors navigationBarItemColors113 = navigationBarItemColorsColors;
                    function6 = function5;
                    navigationBarItemColors2 = navigationBarItemColors113;
                } else {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    } else {
                        function5 = function3;
                    }
                    if (i8 != 0) {
                        z4 = true;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i3 &= -234881025;
                    } else {
                        navigationBarItemColorsColors = navigationBarItemColors;
                    }
                    if (i10 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    z6 = z5;
                    i12 = i3;
                    NavigationBarItemColors navigationBarItemColors114 = navigationBarItemColorsColors;
                    function6 = function5;
                    navigationBarItemColors2 = navigationBarItemColors114;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-663510974, i12, -1, "androidx.compose.material3.NavigationBarItem (NavigationBar.kt:181)");
                }
                composerStartRestartGroup.startReplaceGroup(-103235253);
                ComposerKt.sourceInformation(composerStartRestartGroup, "183@8495L39");
                if (mutableInteractionSource2 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103234602, "CC(remember):NavigationBar.kt#9igjgp");
                    objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue5 = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue5;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                composerStartRestartGroup.endReplaceGroup();
                final NavigationBarItemColors navigationBarItemColors115 = navigationBarItemColors2;
                final boolean z19 = z6;
                final Function2<? super Composer, ? super Integer, Unit> function18 = function6;
                final boolean z110 = z4;
                int i19 = i12;
                ComposableLambda composableLambdaRememberComposableLambda17 = ComposableLambdaKt.rememberComposableLambda(-1419576100, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i110) {
                        ComposerKt.sourceInformation(composer2, "C187@8623L201,193@9006L193:NavigationBar.kt#uh7d8r");
                        if ((i110 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1419576100, i110, -1, "androidx.compose.material3.NavigationBarItem.<anonymous> (NavigationBar.kt:186)");
                            }
                            State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors115.m2563iconColorWaAFU9c$material3_release(z, z19), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12);
                            Modifier.Companion companionClearAndSetSemantics = (function18 == null || !(z110 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                }

                                public Object invoke(Object obj) {
                                    invoke((SemanticsPropertyReceiver) obj);
                                    return Unit.INSTANCE;
                                }
                            });
                            Function2<Composer, Integer, Unit> function19 = function2;
                            ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy6 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap6 = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier6 = ComposedModifierKt.materializeModifier(composer2, companionClearAndSetSemantics);
                            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                            ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                            if (!(composer2.getApplier() instanceof Applier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composer2.startReusableNode();
                            if (composer2.getInserting()) {
                                composer2.createNode(constructor2);
                            } else {
                                composer2.useNode();
                            }
                            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer2);
                            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy6, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap6, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier6, ComposeUiNode.INSTANCE.getSetModifier());
                            ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                            BoxScopeInstance boxScopeInstance6 = BoxScopeInstance.INSTANCE;
                            ComposerKt.sourceInformationMarkerStart(composer2, -1543680408, "C194@9107L78:NavigationBar.kt#uh7d8r");
                            CompositionLocalKt.CompositionLocalProvider(ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(invoke$lambda$0(stateM387animateColorAsStateeuL9pac))), function19, composer2, ProvidedValue.$stable);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }

                    private static final long invoke$lambda$0(State<Color> state) {
                        return state.getValue().m4600unboximpl();
                    }
                }, composerStartRestartGroup, 54);
                composerStartRestartGroup.startReplaceGroup(-103209106);
                ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9305L535");
                if (function6 == null) {
                    composableLambdaRememberComposableLambda = null;
                } else {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1644987592, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i110) {
                            ComposerKt.sourceInformation(composer2, "C201@9369L5,203@9428L213,207@9658L168:NavigationBar.kt#uh7d8r");
                            if ((i110 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1644987592, i110, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:201)");
                                }
                                ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors2.m2564textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationBarTokens.INSTANCE.getLabelTextFont(), composer2, 6), function6, composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }

                        private static final long invoke$lambda$0(State<Color> state) {
                            return state.getValue().m4600unboximpl();
                        }
                    }, composerStartRestartGroup, 54);
                }
                composerStartRestartGroup.endReplaceGroup();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103190512, "CC(remember):NavigationBar.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotIntStateKt.mutableIntStateOf(0);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableIntState = (MutableIntState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifier8 = companion;
                mutableInteractionSource4 = mutableInteractionSource3;
                Modifier modifierWeight$default6 = RowScope.CC.weight$default(rowScope, SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationBarHeight, 1, null), 1.0f, false, 2, null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103176377, "CC(remember):NavigationBar.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = (Function1) new Function1<IntSize, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            m2572invokeozmzZPI(((IntSize) obj).unbox-impl());
                            return Unit.INSTANCE;
                        }

                        public final void m2572invokeozmzZPI(long j) {
                            mutableIntState.setIntValue(IntSize.getWidth-impl(j));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierOnSizeChanged6 = OnRemeasuredModifierKt.onSizeChanged(modifierWeight$default6, (Function1) objRememberedValue2);
                Alignment center6 = Alignment.INSTANCE.getCenter();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy6 = BoxKt.maybeCachedBoxMeasurePolicy(center6, true);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap6 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier6 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierOnSizeChanged6);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                final NavigationBarItemColors navigationBarItemColors116 = navigationBarItemColors2;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy6, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap6, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier6, ComposeUiNode.INSTANCE.getSetModifier());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                BoxScopeInstance boxScopeInstance6 = BoxScopeInstance.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1652122706, "C234@10492L157,*243@10933L7,249@11215L128,256@11558L293,264@11900L395,281@12555L27,275@12305L288:NavigationBar.kt#uh7d8r");
                if (z) {
                    f = 1.0f;
                } else {
                    f = 0.0f;
                }
                Function2<? super Composer, ? super Integer, Unit> function19 = function6;
                stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
                ProvidableCompositionLocal<Density> localDensity6 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume6 = composerStartRestartGroup.consume(localDensity6);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Density density6 = (Density) objConsume6;
                jOffset = OffsetKt.Offset((NavigationBarItem$lambda$3(mutableIntState) - density6.roundToPx-0680j_4(NavigationBarTokens.INSTANCE.m3683getActiveIndicatorWidthD9Ej5fM())) / 2, density6.toPx-0680j_4(IndicatorVerticalOffset));
                Unit unit6 = Unit.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024938414, "CC(remember):NavigationBar.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                final MappedInteractionSource mappedInteractionSource6 = (MappedInteractionSource) objRememberedValue3;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposableLambda composableLambdaRememberComposableLambda18 = ComposableLambdaKt.rememberComposableLambda(691730997, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i110) {
                        ComposerKt.sourceInformation(composer2, "C259@11718L5,260@11786L32,257@11576L261:NavigationBar.kt#uh7d8r");
                        if ((i110 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(691730997, i110, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:257)");
                            }
                            BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), mappedInteractionSource6, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
                ComposableLambda composableLambdaRememberComposableLambda19 = ComposableLambdaKt.rememberComposableLambda(-474426875, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i110) {
                        ComposerKt.sourceInformation(composer2, "C267@12022L35,270@12231L5,265@11918L363:NavigationBar.kt#uh7d8r");
                        if ((i110 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-474426875, i110, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:265)");
                            }
                            Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                            ComposerKt.sourceInformationMarkerStart(composer2, 1335770416, "CC(remember):NavigationBar.kt#9igjgp");
                            boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                            final State<Float> state = stateAnimateFloatAsState;
                            Object objRememberedValue6 = composer2.rememberedValue();
                            if (zChanged3 || objRememberedValue6 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue6 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((GraphicsLayerScope) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(GraphicsLayerScope graphicsLayerScope) {
                                        graphicsLayerScope.setAlpha(state.getValue().floatValue());
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue6);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue6), navigationBarItemColors116.getSelectedIndicatorColor(), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024981193, "CC(remember):NavigationBar.kt#9igjgp");
                zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
                objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                if (!zChanged2) {
                    objRememberedValue4 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2573invoke() {
                            return stateAnimateFloatAsState.getValue();
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                } else {
                    objRememberedValue4 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2573invoke() {
                            return stateAnimateFloatAsState.getValue();
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                NavigationBarItemLayout(composableLambdaRememberComposableLambda18, composableLambdaRememberComposableLambda19, composableLambdaRememberComposableLambda17, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue4, composerStartRestartGroup, ((i19 >> 9) & 57344) | 438);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                navigationBarItemColors3 = navigationBarItemColors116;
                z7 = z6;
                z8 = z4;
                mutableInteractionSource5 = mutableInteractionSource2;
                function7 = function19;
                modifier2 = modifier8;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    } else {
                        function5 = function3;
                    }
                    if (i8 != 0) {
                        z4 = true;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i3 &= -234881025;
                    } else {
                        navigationBarItemColorsColors = navigationBarItemColors;
                    }
                    if (i10 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    z6 = z5;
                    i12 = i3;
                    NavigationBarItemColors navigationBarItemColors117 = navigationBarItemColorsColors;
                    function6 = function5;
                    navigationBarItemColors2 = navigationBarItemColors117;
                } else {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    } else {
                        function5 = function3;
                    }
                    if (i8 != 0) {
                        z4 = true;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i3 &= -234881025;
                    } else {
                        navigationBarItemColorsColors = navigationBarItemColors;
                    }
                    if (i10 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    z6 = z5;
                    i12 = i3;
                    NavigationBarItemColors navigationBarItemColors118 = navigationBarItemColorsColors;
                    function6 = function5;
                    navigationBarItemColors2 = navigationBarItemColors118;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-663510974, i12, -1, "androidx.compose.material3.NavigationBarItem (NavigationBar.kt:181)");
                }
                composerStartRestartGroup.startReplaceGroup(-103235253);
                ComposerKt.sourceInformation(composerStartRestartGroup, "183@8495L39");
                if (mutableInteractionSource2 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103234602, "CC(remember):NavigationBar.kt#9igjgp");
                    objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue5 = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue5;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                composerStartRestartGroup.endReplaceGroup();
                final NavigationBarItemColors navigationBarItemColors119 = navigationBarItemColors2;
                final boolean z111 = z6;
                final Function2<? super Composer, ? super Integer, Unit> function110 = function6;
                final boolean z112 = z4;
                int i110 = i12;
                ComposableLambda composableLambdaRememberComposableLambda110 = ComposableLambdaKt.rememberComposableLambda(-1419576100, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i111) {
                        ComposerKt.sourceInformation(composer2, "C187@8623L201,193@9006L193:NavigationBar.kt#uh7d8r");
                        if ((i111 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1419576100, i111, -1, "androidx.compose.material3.NavigationBarItem.<anonymous> (NavigationBar.kt:186)");
                            }
                            State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors119.m2563iconColorWaAFU9c$material3_release(z, z111), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12);
                            Modifier.Companion companionClearAndSetSemantics = (function110 == null || !(z112 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                }

                                public Object invoke(Object obj) {
                                    invoke((SemanticsPropertyReceiver) obj);
                                    return Unit.INSTANCE;
                                }
                            });
                            Function2<Composer, Integer, Unit> function111 = function2;
                            ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy7 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap7 = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier7 = ComposedModifierKt.materializeModifier(composer2, companionClearAndSetSemantics);
                            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                            ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                            if (!(composer2.getApplier() instanceof Applier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composer2.startReusableNode();
                            if (composer2.getInserting()) {
                                composer2.createNode(constructor2);
                            } else {
                                composer2.useNode();
                            }
                            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer2);
                            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy7, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap7, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier7, ComposeUiNode.INSTANCE.getSetModifier());
                            ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                            BoxScopeInstance boxScopeInstance7 = BoxScopeInstance.INSTANCE;
                            ComposerKt.sourceInformationMarkerStart(composer2, -1543680408, "C194@9107L78:NavigationBar.kt#uh7d8r");
                            CompositionLocalKt.CompositionLocalProvider(ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(invoke$lambda$0(stateM387animateColorAsStateeuL9pac))), function111, composer2, ProvidedValue.$stable);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }

                    private static final long invoke$lambda$0(State<Color> state) {
                        return state.getValue().m4600unboximpl();
                    }
                }, composerStartRestartGroup, 54);
                composerStartRestartGroup.startReplaceGroup(-103209106);
                ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9305L535");
                if (function6 == null) {
                    composableLambdaRememberComposableLambda = null;
                } else {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1644987592, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111) {
                            ComposerKt.sourceInformation(composer2, "C201@9369L5,203@9428L213,207@9658L168:NavigationBar.kt#uh7d8r");
                            if ((i111 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1644987592, i111, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:201)");
                                }
                                ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors2.m2564textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationBarTokens.INSTANCE.getLabelTextFont(), composer2, 6), function6, composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }

                        private static final long invoke$lambda$0(State<Color> state) {
                            return state.getValue().m4600unboximpl();
                        }
                    }, composerStartRestartGroup, 54);
                }
                composerStartRestartGroup.endReplaceGroup();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103190512, "CC(remember):NavigationBar.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotIntStateKt.mutableIntStateOf(0);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableIntState = (MutableIntState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifier9 = companion;
                mutableInteractionSource4 = mutableInteractionSource3;
                Modifier modifierWeight$default7 = RowScope.CC.weight$default(rowScope, SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationBarHeight, 1, null), 1.0f, false, 2, null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103176377, "CC(remember):NavigationBar.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = (Function1) new Function1<IntSize, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            m2572invokeozmzZPI(((IntSize) obj).unbox-impl());
                            return Unit.INSTANCE;
                        }

                        public final void m2572invokeozmzZPI(long j) {
                            mutableIntState.setIntValue(IntSize.getWidth-impl(j));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierOnSizeChanged7 = OnRemeasuredModifierKt.onSizeChanged(modifierWeight$default7, (Function1) objRememberedValue2);
                Alignment center7 = Alignment.INSTANCE.getCenter();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy7 = BoxKt.maybeCachedBoxMeasurePolicy(center7, true);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap7 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier7 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierOnSizeChanged7);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                final NavigationBarItemColors navigationBarItemColors1110 = navigationBarItemColors2;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy7, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap7, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier7, ComposeUiNode.INSTANCE.getSetModifier());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                BoxScopeInstance boxScopeInstance7 = BoxScopeInstance.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1652122706, "C234@10492L157,*243@10933L7,249@11215L128,256@11558L293,264@11900L395,281@12555L27,275@12305L288:NavigationBar.kt#uh7d8r");
                if (z) {
                    f = 1.0f;
                } else {
                    f = 0.0f;
                }
                Function2<? super Composer, ? super Integer, Unit> function111 = function6;
                stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
                ProvidableCompositionLocal<Density> localDensity7 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume7 = composerStartRestartGroup.consume(localDensity7);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Density density7 = (Density) objConsume7;
                jOffset = OffsetKt.Offset((NavigationBarItem$lambda$3(mutableIntState) - density7.roundToPx-0680j_4(NavigationBarTokens.INSTANCE.m3683getActiveIndicatorWidthD9Ej5fM())) / 2, density7.toPx-0680j_4(IndicatorVerticalOffset));
                Unit unit7 = Unit.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024938414, "CC(remember):NavigationBar.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                final MappedInteractionSource mappedInteractionSource7 = (MappedInteractionSource) objRememberedValue3;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposableLambda composableLambdaRememberComposableLambda111 = ComposableLambdaKt.rememberComposableLambda(691730997, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i111) {
                        ComposerKt.sourceInformation(composer2, "C259@11718L5,260@11786L32,257@11576L261:NavigationBar.kt#uh7d8r");
                        if ((i111 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(691730997, i111, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:257)");
                            }
                            BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), mappedInteractionSource7, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
                ComposableLambda composableLambdaRememberComposableLambda112 = ComposableLambdaKt.rememberComposableLambda(-474426875, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i111) {
                        ComposerKt.sourceInformation(composer2, "C267@12022L35,270@12231L5,265@11918L363:NavigationBar.kt#uh7d8r");
                        if ((i111 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-474426875, i111, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:265)");
                            }
                            Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                            ComposerKt.sourceInformationMarkerStart(composer2, 1335770416, "CC(remember):NavigationBar.kt#9igjgp");
                            boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                            final State<Float> state = stateAnimateFloatAsState;
                            Object objRememberedValue6 = composer2.rememberedValue();
                            if (zChanged3 || objRememberedValue6 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue6 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((GraphicsLayerScope) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(GraphicsLayerScope graphicsLayerScope) {
                                        graphicsLayerScope.setAlpha(state.getValue().floatValue());
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue6);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue6), navigationBarItemColors1110.getSelectedIndicatorColor(), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024981193, "CC(remember):NavigationBar.kt#9igjgp");
                zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
                objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                if (!zChanged2) {
                    objRememberedValue4 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2573invoke() {
                            return stateAnimateFloatAsState.getValue();
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                } else {
                    objRememberedValue4 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2573invoke() {
                            return stateAnimateFloatAsState.getValue();
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                NavigationBarItemLayout(composableLambdaRememberComposableLambda111, composableLambdaRememberComposableLambda112, composableLambdaRememberComposableLambda110, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue4, composerStartRestartGroup, ((i110 >> 9) & 57344) | 438);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                navigationBarItemColors3 = navigationBarItemColors1110;
                z7 = z6;
                z8 = z4;
                mutableInteractionSource5 = mutableInteractionSource2;
                function7 = function111;
                modifier2 = modifier9;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i111) {
                        NavigationBarKt.NavigationBarItem(rowScope, z, function0, function2, modifier2, z7, function7, z8, navigationBarItemColors3, mutableInteractionSource5, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 24576;
        i4 = i2 & 16;
        if (i4 != 0) {
            if ((196608 & i) == 0) {
                if (composerStartRestartGroup.changed(z2)) {
                    i5 = Fields.RenderEffect;
                } else {
                    i5 = 65536;
                }
                i3 |= i5;
            }
            i6 = i2 & 32;
            if (i6 != 0) {
                if ((1572864 & i) == 0) {
                    function4 = function3;
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i7 = 1048576;
                    } else {
                        i7 = 524288;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 64;
                if (i8 != 0) {
                    i3 |= 12582912;
                    z4 = z3;
                } else {
                    z4 = z3;
                    if ((i & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(z4)) {
                            i9 = 8388608;
                        } else {
                            i9 = 4194304;
                        }
                        i3 |= i9;
                    }
                }
                if ((i & 100663296) != 0) {
                    i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(navigationBarItemColors)) ? 33554432 : 67108864;
                }
                i10 = i2 & Fields.RotationX;
                if (i10 != 0) {
                    i3 |= 805306368;
                } else if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                        i11 = 536870912;
                    } else {
                        i11 = 268435456;
                    }
                    i3 |= i11;
                }
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        } else {
                            function5 = function3;
                        }
                        if (i8 != 0) {
                            z4 = true;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            i3 &= -234881025;
                        } else {
                            navigationBarItemColorsColors = navigationBarItemColors;
                        }
                        if (i10 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                        z6 = z5;
                        i12 = i3;
                        NavigationBarItemColors navigationBarItemColors1111 = navigationBarItemColorsColors;
                        function6 = function5;
                        navigationBarItemColors2 = navigationBarItemColors1111;
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        } else {
                            function5 = function3;
                        }
                        if (i8 != 0) {
                            z4 = true;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            i3 &= -234881025;
                        } else {
                            navigationBarItemColorsColors = navigationBarItemColors;
                        }
                        if (i10 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                        z6 = z5;
                        i12 = i3;
                        NavigationBarItemColors navigationBarItemColors1112 = navigationBarItemColorsColors;
                        function6 = function5;
                        navigationBarItemColors2 = navigationBarItemColors1112;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-663510974, i12, -1, "androidx.compose.material3.NavigationBarItem (NavigationBar.kt:181)");
                    }
                    composerStartRestartGroup.startReplaceGroup(-103235253);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "183@8495L39");
                    if (mutableInteractionSource2 == null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103234602, "CC(remember):NavigationBar.kt#9igjgp");
                        objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue5 = InteractionSourceKt.MutableInteractionSource();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue5;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    final NavigationBarItemColors navigationBarItemColors1113 = navigationBarItemColors2;
                    final boolean z113 = z6;
                    final Function2<? super Composer, ? super Integer, Unit> function112 = function6;
                    final boolean z114 = z4;
                    int i111 = i12;
                    ComposableLambda composableLambdaRememberComposableLambda113 = ComposableLambdaKt.rememberComposableLambda(-1419576100, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i112) {
                            ComposerKt.sourceInformation(composer2, "C187@8623L201,193@9006L193:NavigationBar.kt#uh7d8r");
                            if ((i112 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1419576100, i112, -1, "androidx.compose.material3.NavigationBarItem.<anonymous> (NavigationBar.kt:186)");
                                }
                                State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors1113.m2563iconColorWaAFU9c$material3_release(z, z113), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12);
                                Modifier.Companion companionClearAndSetSemantics = (function112 == null || !(z114 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((SemanticsPropertyReceiver) obj);
                                        return Unit.INSTANCE;
                                    }
                                });
                                Function2<Composer, Integer, Unit> function113 = function2;
                                ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy8 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap8 = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier8 = ComposedModifierKt.materializeModifier(composer2, companionClearAndSetSemantics);
                                Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer2.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer2.startReusableNode();
                                if (composer2.getInserting()) {
                                    composer2.createNode(constructor2);
                                } else {
                                    composer2.useNode();
                                }
                                Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer2);
                                Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy8, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap8, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                    composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                    composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier8, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance8 = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer2, -1543680408, "C194@9107L78:NavigationBar.kt#uh7d8r");
                                CompositionLocalKt.CompositionLocalProvider(ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(invoke$lambda$0(stateM387animateColorAsStateeuL9pac))), function113, composer2, ProvidedValue.$stable);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }

                        private static final long invoke$lambda$0(State<Color> state) {
                            return state.getValue().m4600unboximpl();
                        }
                    }, composerStartRestartGroup, 54);
                    composerStartRestartGroup.startReplaceGroup(-103209106);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9305L535");
                    if (function6 == null) {
                        composableLambdaRememberComposableLambda = null;
                    } else {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1644987592, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i112) {
                                ComposerKt.sourceInformation(composer2, "C201@9369L5,203@9428L213,207@9658L168:NavigationBar.kt#uh7d8r");
                                if ((i112 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1644987592, i112, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:201)");
                                    }
                                    ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors2.m2564textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationBarTokens.INSTANCE.getLabelTextFont(), composer2, 6), function6, composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }

                            private static final long invoke$lambda$0(State<Color> state) {
                                return state.getValue().m4600unboximpl();
                            }
                        }, composerStartRestartGroup, 54);
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103190512, "CC(remember):NavigationBar.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotIntStateKt.mutableIntStateOf(0);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableIntState = (MutableIntState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifier10 = companion;
                    mutableInteractionSource4 = mutableInteractionSource3;
                    Modifier modifierWeight$default8 = RowScope.CC.weight$default(rowScope, SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationBarHeight, 1, null), 1.0f, false, 2, null);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103176377, "CC(remember):NavigationBar.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = (Function1) new Function1<IntSize, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                m2572invokeozmzZPI(((IntSize) obj).unbox-impl());
                                return Unit.INSTANCE;
                            }

                            public final void m2572invokeozmzZPI(long j) {
                                mutableIntState.setIntValue(IntSize.getWidth-impl(j));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierOnSizeChanged8 = OnRemeasuredModifierKt.onSizeChanged(modifierWeight$default8, (Function1) objRememberedValue2);
                    Alignment center8 = Alignment.INSTANCE.getCenter();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy8 = BoxKt.maybeCachedBoxMeasurePolicy(center8, true);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap8 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier8 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierOnSizeChanged8);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    final NavigationBarItemColors navigationBarItemColors1114 = navigationBarItemColors2;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy8, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap8, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier8, ComposeUiNode.INSTANCE.getSetModifier());
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                    BoxScopeInstance boxScopeInstance8 = BoxScopeInstance.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1652122706, "C234@10492L157,*243@10933L7,249@11215L128,256@11558L293,264@11900L395,281@12555L27,275@12305L288:NavigationBar.kt#uh7d8r");
                    if (z) {
                        f = 1.0f;
                    } else {
                        f = 0.0f;
                    }
                    Function2<? super Composer, ? super Integer, Unit> function113 = function6;
                    stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
                    ProvidableCompositionLocal<Density> localDensity8 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume8 = composerStartRestartGroup.consume(localDensity8);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Density density8 = (Density) objConsume8;
                    jOffset = OffsetKt.Offset((NavigationBarItem$lambda$3(mutableIntState) - density8.roundToPx-0680j_4(NavigationBarTokens.INSTANCE.m3683getActiveIndicatorWidthD9Ej5fM())) / 2, density8.toPx-0680j_4(IndicatorVerticalOffset));
                    Unit unit8 = Unit.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024938414, "CC(remember):NavigationBar.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    final MappedInteractionSource mappedInteractionSource8 = (MappedInteractionSource) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposableLambda composableLambdaRememberComposableLambda114 = ComposableLambdaKt.rememberComposableLambda(691730997, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i112) {
                            ComposerKt.sourceInformation(composer2, "C259@11718L5,260@11786L32,257@11576L261:NavigationBar.kt#uh7d8r");
                            if ((i112 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(691730997, i112, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:257)");
                                }
                                BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), mappedInteractionSource8, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    ComposableLambda composableLambdaRememberComposableLambda115 = ComposableLambdaKt.rememberComposableLambda(-474426875, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i112) {
                            ComposerKt.sourceInformation(composer2, "C267@12022L35,270@12231L5,265@11918L363:NavigationBar.kt#uh7d8r");
                            if ((i112 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-474426875, i112, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:265)");
                                }
                                Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                                ComposerKt.sourceInformationMarkerStart(composer2, 1335770416, "CC(remember):NavigationBar.kt#9igjgp");
                                boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                                final State<Float> state = stateAnimateFloatAsState;
                                Object objRememberedValue6 = composer2.rememberedValue();
                                if (zChanged3 || objRememberedValue6 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue6 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            invoke((GraphicsLayerScope) obj);
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(GraphicsLayerScope graphicsLayerScope) {
                                            graphicsLayerScope.setAlpha(state.getValue().floatValue());
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue6);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue6), navigationBarItemColors1114.getSelectedIndicatorColor(), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024981193, "CC(remember):NavigationBar.kt#9igjgp");
                    zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
                    objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged2) {
                        objRememberedValue4 = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2573invoke() {
                                return stateAnimateFloatAsState.getValue();
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    } else {
                        objRememberedValue4 = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2573invoke() {
                                return stateAnimateFloatAsState.getValue();
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    NavigationBarItemLayout(composableLambdaRememberComposableLambda114, composableLambdaRememberComposableLambda115, composableLambdaRememberComposableLambda113, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue4, composerStartRestartGroup, ((i111 >> 9) & 57344) | 438);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    navigationBarItemColors3 = navigationBarItemColors1114;
                    z7 = z6;
                    z8 = z4;
                    mutableInteractionSource5 = mutableInteractionSource2;
                    function7 = function113;
                    modifier2 = modifier10;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        } else {
                            function5 = function3;
                        }
                        if (i8 != 0) {
                            z4 = true;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            i3 &= -234881025;
                        } else {
                            navigationBarItemColorsColors = navigationBarItemColors;
                        }
                        if (i10 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                        z6 = z5;
                        i12 = i3;
                        NavigationBarItemColors navigationBarItemColors1115 = navigationBarItemColorsColors;
                        function6 = function5;
                        navigationBarItemColors2 = navigationBarItemColors1115;
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        } else {
                            function5 = function3;
                        }
                        if (i8 != 0) {
                            z4 = true;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            i3 &= -234881025;
                        } else {
                            navigationBarItemColorsColors = navigationBarItemColors;
                        }
                        if (i10 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                        z6 = z5;
                        i12 = i3;
                        NavigationBarItemColors navigationBarItemColors1116 = navigationBarItemColorsColors;
                        function6 = function5;
                        navigationBarItemColors2 = navigationBarItemColors1116;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-663510974, i12, -1, "androidx.compose.material3.NavigationBarItem (NavigationBar.kt:181)");
                    }
                    composerStartRestartGroup.startReplaceGroup(-103235253);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "183@8495L39");
                    if (mutableInteractionSource2 == null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103234602, "CC(remember):NavigationBar.kt#9igjgp");
                        objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue5 = InteractionSourceKt.MutableInteractionSource();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue5;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    final NavigationBarItemColors navigationBarItemColors1117 = navigationBarItemColors2;
                    final boolean z115 = z6;
                    final Function2<? super Composer, ? super Integer, Unit> function114 = function6;
                    final boolean z116 = z4;
                    int i112 = i12;
                    ComposableLambda composableLambdaRememberComposableLambda116 = ComposableLambdaKt.rememberComposableLambda(-1419576100, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i113) {
                            ComposerKt.sourceInformation(composer2, "C187@8623L201,193@9006L193:NavigationBar.kt#uh7d8r");
                            if ((i113 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1419576100, i113, -1, "androidx.compose.material3.NavigationBarItem.<anonymous> (NavigationBar.kt:186)");
                                }
                                State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors1117.m2563iconColorWaAFU9c$material3_release(z, z115), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12);
                                Modifier.Companion companionClearAndSetSemantics = (function114 == null || !(z116 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((SemanticsPropertyReceiver) obj);
                                        return Unit.INSTANCE;
                                    }
                                });
                                Function2<Composer, Integer, Unit> function115 = function2;
                                ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy9 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap9 = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier9 = ComposedModifierKt.materializeModifier(composer2, companionClearAndSetSemantics);
                                Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer2.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer2.startReusableNode();
                                if (composer2.getInserting()) {
                                    composer2.createNode(constructor2);
                                } else {
                                    composer2.useNode();
                                }
                                Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer2);
                                Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy9, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap9, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                    composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                    composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier9, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance9 = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer2, -1543680408, "C194@9107L78:NavigationBar.kt#uh7d8r");
                                CompositionLocalKt.CompositionLocalProvider(ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(invoke$lambda$0(stateM387animateColorAsStateeuL9pac))), function115, composer2, ProvidedValue.$stable);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }

                        private static final long invoke$lambda$0(State<Color> state) {
                            return state.getValue().m4600unboximpl();
                        }
                    }, composerStartRestartGroup, 54);
                    composerStartRestartGroup.startReplaceGroup(-103209106);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9305L535");
                    if (function6 == null) {
                        composableLambdaRememberComposableLambda = null;
                    } else {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1644987592, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i113) {
                                ComposerKt.sourceInformation(composer2, "C201@9369L5,203@9428L213,207@9658L168:NavigationBar.kt#uh7d8r");
                                if ((i113 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1644987592, i113, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:201)");
                                    }
                                    ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors2.m2564textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationBarTokens.INSTANCE.getLabelTextFont(), composer2, 6), function6, composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }

                            private static final long invoke$lambda$0(State<Color> state) {
                                return state.getValue().m4600unboximpl();
                            }
                        }, composerStartRestartGroup, 54);
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103190512, "CC(remember):NavigationBar.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotIntStateKt.mutableIntStateOf(0);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableIntState = (MutableIntState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifier11 = companion;
                    mutableInteractionSource4 = mutableInteractionSource3;
                    Modifier modifierWeight$default9 = RowScope.CC.weight$default(rowScope, SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationBarHeight, 1, null), 1.0f, false, 2, null);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103176377, "CC(remember):NavigationBar.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = (Function1) new Function1<IntSize, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                m2572invokeozmzZPI(((IntSize) obj).unbox-impl());
                                return Unit.INSTANCE;
                            }

                            public final void m2572invokeozmzZPI(long j) {
                                mutableIntState.setIntValue(IntSize.getWidth-impl(j));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierOnSizeChanged9 = OnRemeasuredModifierKt.onSizeChanged(modifierWeight$default9, (Function1) objRememberedValue2);
                    Alignment center9 = Alignment.INSTANCE.getCenter();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy9 = BoxKt.maybeCachedBoxMeasurePolicy(center9, true);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap9 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier9 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierOnSizeChanged9);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    final NavigationBarItemColors navigationBarItemColors1118 = navigationBarItemColors2;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy9, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap9, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier9, ComposeUiNode.INSTANCE.getSetModifier());
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                    BoxScopeInstance boxScopeInstance9 = BoxScopeInstance.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1652122706, "C234@10492L157,*243@10933L7,249@11215L128,256@11558L293,264@11900L395,281@12555L27,275@12305L288:NavigationBar.kt#uh7d8r");
                    if (z) {
                        f = 1.0f;
                    } else {
                        f = 0.0f;
                    }
                    Function2<? super Composer, ? super Integer, Unit> function115 = function6;
                    stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
                    ProvidableCompositionLocal<Density> localDensity9 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume9 = composerStartRestartGroup.consume(localDensity9);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Density density9 = (Density) objConsume9;
                    jOffset = OffsetKt.Offset((NavigationBarItem$lambda$3(mutableIntState) - density9.roundToPx-0680j_4(NavigationBarTokens.INSTANCE.m3683getActiveIndicatorWidthD9Ej5fM())) / 2, density9.toPx-0680j_4(IndicatorVerticalOffset));
                    Unit unit9 = Unit.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024938414, "CC(remember):NavigationBar.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    final MappedInteractionSource mappedInteractionSource9 = (MappedInteractionSource) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposableLambda composableLambdaRememberComposableLambda117 = ComposableLambdaKt.rememberComposableLambda(691730997, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i113) {
                            ComposerKt.sourceInformation(composer2, "C259@11718L5,260@11786L32,257@11576L261:NavigationBar.kt#uh7d8r");
                            if ((i113 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(691730997, i113, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:257)");
                                }
                                BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), mappedInteractionSource9, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    ComposableLambda composableLambdaRememberComposableLambda118 = ComposableLambdaKt.rememberComposableLambda(-474426875, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i113) {
                            ComposerKt.sourceInformation(composer2, "C267@12022L35,270@12231L5,265@11918L363:NavigationBar.kt#uh7d8r");
                            if ((i113 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-474426875, i113, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:265)");
                                }
                                Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                                ComposerKt.sourceInformationMarkerStart(composer2, 1335770416, "CC(remember):NavigationBar.kt#9igjgp");
                                boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                                final State<Float> state = stateAnimateFloatAsState;
                                Object objRememberedValue6 = composer2.rememberedValue();
                                if (zChanged3 || objRememberedValue6 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue6 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            invoke((GraphicsLayerScope) obj);
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(GraphicsLayerScope graphicsLayerScope) {
                                            graphicsLayerScope.setAlpha(state.getValue().floatValue());
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue6);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue6), navigationBarItemColors1118.getSelectedIndicatorColor(), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024981193, "CC(remember):NavigationBar.kt#9igjgp");
                    zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
                    objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged2) {
                        objRememberedValue4 = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2573invoke() {
                                return stateAnimateFloatAsState.getValue();
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    } else {
                        objRememberedValue4 = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2573invoke() {
                                return stateAnimateFloatAsState.getValue();
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    NavigationBarItemLayout(composableLambdaRememberComposableLambda117, composableLambdaRememberComposableLambda118, composableLambdaRememberComposableLambda116, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue4, composerStartRestartGroup, ((i112 >> 9) & 57344) | 438);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    navigationBarItemColors3 = navigationBarItemColors1118;
                    z7 = z6;
                    z8 = z4;
                    mutableInteractionSource5 = mutableInteractionSource2;
                    function7 = function115;
                    modifier2 = modifier11;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i113) {
                            NavigationBarKt.NavigationBarItem(rowScope, z, function0, function2, modifier2, z7, function7, z8, navigationBarItemColors3, mutableInteractionSource5, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 1572864;
            function4 = function3;
            i8 = i2 & 64;
            if (i8 != 0) {
                i3 |= 12582912;
                z4 = z3;
            } else {
                z4 = z3;
                if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(z4)) {
                        i9 = 8388608;
                    } else {
                        i9 = 4194304;
                    }
                    i3 |= i9;
                }
            }
            if ((i & 100663296) != 0) {
                i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(navigationBarItemColors)) ? 33554432 : 67108864;
            }
            i10 = i2 & Fields.RotationX;
            if (i10 != 0) {
                i3 |= 805306368;
            } else if ((i & 805306368) == 0) {
                if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                    i11 = 536870912;
                } else {
                    i11 = 268435456;
                }
                i3 |= i11;
            }
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    } else {
                        function5 = function3;
                    }
                    if (i8 != 0) {
                        z4 = true;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i3 &= -234881025;
                    } else {
                        navigationBarItemColorsColors = navigationBarItemColors;
                    }
                    if (i10 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    z6 = z5;
                    i12 = i3;
                    NavigationBarItemColors navigationBarItemColors1119 = navigationBarItemColorsColors;
                    function6 = function5;
                    navigationBarItemColors2 = navigationBarItemColors1119;
                } else {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    } else {
                        function5 = function3;
                    }
                    if (i8 != 0) {
                        z4 = true;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i3 &= -234881025;
                    } else {
                        navigationBarItemColorsColors = navigationBarItemColors;
                    }
                    if (i10 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    z6 = z5;
                    i12 = i3;
                    NavigationBarItemColors navigationBarItemColors11110 = navigationBarItemColorsColors;
                    function6 = function5;
                    navigationBarItemColors2 = navigationBarItemColors11110;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-663510974, i12, -1, "androidx.compose.material3.NavigationBarItem (NavigationBar.kt:181)");
                }
                composerStartRestartGroup.startReplaceGroup(-103235253);
                ComposerKt.sourceInformation(composerStartRestartGroup, "183@8495L39");
                if (mutableInteractionSource2 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103234602, "CC(remember):NavigationBar.kt#9igjgp");
                    objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue5 = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue5;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                composerStartRestartGroup.endReplaceGroup();
                final NavigationBarItemColors navigationBarItemColors11111 = navigationBarItemColors2;
                final boolean z117 = z6;
                final Function2<? super Composer, ? super Integer, Unit> function116 = function6;
                final boolean z118 = z4;
                int i113 = i12;
                ComposableLambda composableLambdaRememberComposableLambda119 = ComposableLambdaKt.rememberComposableLambda(-1419576100, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i114) {
                        ComposerKt.sourceInformation(composer2, "C187@8623L201,193@9006L193:NavigationBar.kt#uh7d8r");
                        if ((i114 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1419576100, i114, -1, "androidx.compose.material3.NavigationBarItem.<anonymous> (NavigationBar.kt:186)");
                            }
                            State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors11111.m2563iconColorWaAFU9c$material3_release(z, z117), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12);
                            Modifier.Companion companionClearAndSetSemantics = (function116 == null || !(z118 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                }

                                public Object invoke(Object obj) {
                                    invoke((SemanticsPropertyReceiver) obj);
                                    return Unit.INSTANCE;
                                }
                            });
                            Function2<Composer, Integer, Unit> function117 = function2;
                            ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy10 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap10 = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier10 = ComposedModifierKt.materializeModifier(composer2, companionClearAndSetSemantics);
                            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                            ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                            if (!(composer2.getApplier() instanceof Applier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composer2.startReusableNode();
                            if (composer2.getInserting()) {
                                composer2.createNode(constructor2);
                            } else {
                                composer2.useNode();
                            }
                            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer2);
                            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy10, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap10, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier10, ComposeUiNode.INSTANCE.getSetModifier());
                            ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                            BoxScopeInstance boxScopeInstance10 = BoxScopeInstance.INSTANCE;
                            ComposerKt.sourceInformationMarkerStart(composer2, -1543680408, "C194@9107L78:NavigationBar.kt#uh7d8r");
                            CompositionLocalKt.CompositionLocalProvider(ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(invoke$lambda$0(stateM387animateColorAsStateeuL9pac))), function117, composer2, ProvidedValue.$stable);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }

                    private static final long invoke$lambda$0(State<Color> state) {
                        return state.getValue().m4600unboximpl();
                    }
                }, composerStartRestartGroup, 54);
                composerStartRestartGroup.startReplaceGroup(-103209106);
                ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9305L535");
                if (function6 == null) {
                    composableLambdaRememberComposableLambda = null;
                } else {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1644987592, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i114) {
                            ComposerKt.sourceInformation(composer2, "C201@9369L5,203@9428L213,207@9658L168:NavigationBar.kt#uh7d8r");
                            if ((i114 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1644987592, i114, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:201)");
                                }
                                ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors2.m2564textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationBarTokens.INSTANCE.getLabelTextFont(), composer2, 6), function6, composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }

                        private static final long invoke$lambda$0(State<Color> state) {
                            return state.getValue().m4600unboximpl();
                        }
                    }, composerStartRestartGroup, 54);
                }
                composerStartRestartGroup.endReplaceGroup();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103190512, "CC(remember):NavigationBar.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotIntStateKt.mutableIntStateOf(0);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableIntState = (MutableIntState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifier12 = companion;
                mutableInteractionSource4 = mutableInteractionSource3;
                Modifier modifierWeight$default10 = RowScope.CC.weight$default(rowScope, SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationBarHeight, 1, null), 1.0f, false, 2, null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103176377, "CC(remember):NavigationBar.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = (Function1) new Function1<IntSize, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            m2572invokeozmzZPI(((IntSize) obj).unbox-impl());
                            return Unit.INSTANCE;
                        }

                        public final void m2572invokeozmzZPI(long j) {
                            mutableIntState.setIntValue(IntSize.getWidth-impl(j));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierOnSizeChanged10 = OnRemeasuredModifierKt.onSizeChanged(modifierWeight$default10, (Function1) objRememberedValue2);
                Alignment center10 = Alignment.INSTANCE.getCenter();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy10 = BoxKt.maybeCachedBoxMeasurePolicy(center10, true);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap10 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier10 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierOnSizeChanged10);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                final NavigationBarItemColors navigationBarItemColors11112 = navigationBarItemColors2;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy10, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap10, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier10, ComposeUiNode.INSTANCE.getSetModifier());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                BoxScopeInstance boxScopeInstance10 = BoxScopeInstance.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1652122706, "C234@10492L157,*243@10933L7,249@11215L128,256@11558L293,264@11900L395,281@12555L27,275@12305L288:NavigationBar.kt#uh7d8r");
                if (z) {
                    f = 1.0f;
                } else {
                    f = 0.0f;
                }
                Function2<? super Composer, ? super Integer, Unit> function117 = function6;
                stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
                ProvidableCompositionLocal<Density> localDensity10 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume10 = composerStartRestartGroup.consume(localDensity10);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Density density10 = (Density) objConsume10;
                jOffset = OffsetKt.Offset((NavigationBarItem$lambda$3(mutableIntState) - density10.roundToPx-0680j_4(NavigationBarTokens.INSTANCE.m3683getActiveIndicatorWidthD9Ej5fM())) / 2, density10.toPx-0680j_4(IndicatorVerticalOffset));
                Unit unit10 = Unit.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024938414, "CC(remember):NavigationBar.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                final MappedInteractionSource mappedInteractionSource10 = (MappedInteractionSource) objRememberedValue3;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposableLambda composableLambdaRememberComposableLambda1110 = ComposableLambdaKt.rememberComposableLambda(691730997, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i114) {
                        ComposerKt.sourceInformation(composer2, "C259@11718L5,260@11786L32,257@11576L261:NavigationBar.kt#uh7d8r");
                        if ((i114 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(691730997, i114, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:257)");
                            }
                            BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), mappedInteractionSource10, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
                ComposableLambda composableLambdaRememberComposableLambda1111 = ComposableLambdaKt.rememberComposableLambda(-474426875, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i114) {
                        ComposerKt.sourceInformation(composer2, "C267@12022L35,270@12231L5,265@11918L363:NavigationBar.kt#uh7d8r");
                        if ((i114 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-474426875, i114, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:265)");
                            }
                            Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                            ComposerKt.sourceInformationMarkerStart(composer2, 1335770416, "CC(remember):NavigationBar.kt#9igjgp");
                            boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                            final State<Float> state = stateAnimateFloatAsState;
                            Object objRememberedValue6 = composer2.rememberedValue();
                            if (zChanged3 || objRememberedValue6 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue6 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((GraphicsLayerScope) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(GraphicsLayerScope graphicsLayerScope) {
                                        graphicsLayerScope.setAlpha(state.getValue().floatValue());
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue6);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue6), navigationBarItemColors11112.getSelectedIndicatorColor(), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024981193, "CC(remember):NavigationBar.kt#9igjgp");
                zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
                objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                if (!zChanged2) {
                    objRememberedValue4 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2573invoke() {
                            return stateAnimateFloatAsState.getValue();
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                } else {
                    objRememberedValue4 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2573invoke() {
                            return stateAnimateFloatAsState.getValue();
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                NavigationBarItemLayout(composableLambdaRememberComposableLambda1110, composableLambdaRememberComposableLambda1111, composableLambdaRememberComposableLambda119, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue4, composerStartRestartGroup, ((i113 >> 9) & 57344) | 438);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                navigationBarItemColors3 = navigationBarItemColors11112;
                z7 = z6;
                z8 = z4;
                mutableInteractionSource5 = mutableInteractionSource2;
                function7 = function117;
                modifier2 = modifier12;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    } else {
                        function5 = function3;
                    }
                    if (i8 != 0) {
                        z4 = true;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i3 &= -234881025;
                    } else {
                        navigationBarItemColorsColors = navigationBarItemColors;
                    }
                    if (i10 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    z6 = z5;
                    i12 = i3;
                    NavigationBarItemColors navigationBarItemColors11113 = navigationBarItemColorsColors;
                    function6 = function5;
                    navigationBarItemColors2 = navigationBarItemColors11113;
                } else {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    } else {
                        function5 = function3;
                    }
                    if (i8 != 0) {
                        z4 = true;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i3 &= -234881025;
                    } else {
                        navigationBarItemColorsColors = navigationBarItemColors;
                    }
                    if (i10 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    z6 = z5;
                    i12 = i3;
                    NavigationBarItemColors navigationBarItemColors11114 = navigationBarItemColorsColors;
                    function6 = function5;
                    navigationBarItemColors2 = navigationBarItemColors11114;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-663510974, i12, -1, "androidx.compose.material3.NavigationBarItem (NavigationBar.kt:181)");
                }
                composerStartRestartGroup.startReplaceGroup(-103235253);
                ComposerKt.sourceInformation(composerStartRestartGroup, "183@8495L39");
                if (mutableInteractionSource2 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103234602, "CC(remember):NavigationBar.kt#9igjgp");
                    objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue5 = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue5;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                composerStartRestartGroup.endReplaceGroup();
                final NavigationBarItemColors navigationBarItemColors11115 = navigationBarItemColors2;
                final boolean z119 = z6;
                final Function2<? super Composer, ? super Integer, Unit> function118 = function6;
                final boolean z1110 = z4;
                int i114 = i12;
                ComposableLambda composableLambdaRememberComposableLambda1112 = ComposableLambdaKt.rememberComposableLambda(-1419576100, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i115) {
                        ComposerKt.sourceInformation(composer2, "C187@8623L201,193@9006L193:NavigationBar.kt#uh7d8r");
                        if ((i115 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1419576100, i115, -1, "androidx.compose.material3.NavigationBarItem.<anonymous> (NavigationBar.kt:186)");
                            }
                            State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors11115.m2563iconColorWaAFU9c$material3_release(z, z119), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12);
                            Modifier.Companion companionClearAndSetSemantics = (function118 == null || !(z1110 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                }

                                public Object invoke(Object obj) {
                                    invoke((SemanticsPropertyReceiver) obj);
                                    return Unit.INSTANCE;
                                }
                            });
                            Function2<Composer, Integer, Unit> function119 = function2;
                            ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy11 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap11 = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier11 = ComposedModifierKt.materializeModifier(composer2, companionClearAndSetSemantics);
                            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                            ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                            if (!(composer2.getApplier() instanceof Applier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composer2.startReusableNode();
                            if (composer2.getInserting()) {
                                composer2.createNode(constructor2);
                            } else {
                                composer2.useNode();
                            }
                            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer2);
                            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy11, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap11, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier11, ComposeUiNode.INSTANCE.getSetModifier());
                            ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                            BoxScopeInstance boxScopeInstance11 = BoxScopeInstance.INSTANCE;
                            ComposerKt.sourceInformationMarkerStart(composer2, -1543680408, "C194@9107L78:NavigationBar.kt#uh7d8r");
                            CompositionLocalKt.CompositionLocalProvider(ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(invoke$lambda$0(stateM387animateColorAsStateeuL9pac))), function119, composer2, ProvidedValue.$stable);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }

                    private static final long invoke$lambda$0(State<Color> state) {
                        return state.getValue().m4600unboximpl();
                    }
                }, composerStartRestartGroup, 54);
                composerStartRestartGroup.startReplaceGroup(-103209106);
                ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9305L535");
                if (function6 == null) {
                    composableLambdaRememberComposableLambda = null;
                } else {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1644987592, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i115) {
                            ComposerKt.sourceInformation(composer2, "C201@9369L5,203@9428L213,207@9658L168:NavigationBar.kt#uh7d8r");
                            if ((i115 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1644987592, i115, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:201)");
                                }
                                ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors2.m2564textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationBarTokens.INSTANCE.getLabelTextFont(), composer2, 6), function6, composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }

                        private static final long invoke$lambda$0(State<Color> state) {
                            return state.getValue().m4600unboximpl();
                        }
                    }, composerStartRestartGroup, 54);
                }
                composerStartRestartGroup.endReplaceGroup();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103190512, "CC(remember):NavigationBar.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotIntStateKt.mutableIntStateOf(0);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableIntState = (MutableIntState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifier13 = companion;
                mutableInteractionSource4 = mutableInteractionSource3;
                Modifier modifierWeight$default11 = RowScope.CC.weight$default(rowScope, SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationBarHeight, 1, null), 1.0f, false, 2, null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103176377, "CC(remember):NavigationBar.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = (Function1) new Function1<IntSize, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            m2572invokeozmzZPI(((IntSize) obj).unbox-impl());
                            return Unit.INSTANCE;
                        }

                        public final void m2572invokeozmzZPI(long j) {
                            mutableIntState.setIntValue(IntSize.getWidth-impl(j));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierOnSizeChanged11 = OnRemeasuredModifierKt.onSizeChanged(modifierWeight$default11, (Function1) objRememberedValue2);
                Alignment center11 = Alignment.INSTANCE.getCenter();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy11 = BoxKt.maybeCachedBoxMeasurePolicy(center11, true);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap11 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier11 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierOnSizeChanged11);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                final NavigationBarItemColors navigationBarItemColors11116 = navigationBarItemColors2;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy11, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap11, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier11, ComposeUiNode.INSTANCE.getSetModifier());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                BoxScopeInstance boxScopeInstance11 = BoxScopeInstance.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1652122706, "C234@10492L157,*243@10933L7,249@11215L128,256@11558L293,264@11900L395,281@12555L27,275@12305L288:NavigationBar.kt#uh7d8r");
                if (z) {
                    f = 1.0f;
                } else {
                    f = 0.0f;
                }
                Function2<? super Composer, ? super Integer, Unit> function119 = function6;
                stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
                ProvidableCompositionLocal<Density> localDensity11 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume11 = composerStartRestartGroup.consume(localDensity11);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Density density11 = (Density) objConsume11;
                jOffset = OffsetKt.Offset((NavigationBarItem$lambda$3(mutableIntState) - density11.roundToPx-0680j_4(NavigationBarTokens.INSTANCE.m3683getActiveIndicatorWidthD9Ej5fM())) / 2, density11.toPx-0680j_4(IndicatorVerticalOffset));
                Unit unit11 = Unit.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024938414, "CC(remember):NavigationBar.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                final MappedInteractionSource mappedInteractionSource11 = (MappedInteractionSource) objRememberedValue3;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposableLambda composableLambdaRememberComposableLambda1113 = ComposableLambdaKt.rememberComposableLambda(691730997, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i115) {
                        ComposerKt.sourceInformation(composer2, "C259@11718L5,260@11786L32,257@11576L261:NavigationBar.kt#uh7d8r");
                        if ((i115 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(691730997, i115, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:257)");
                            }
                            BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), mappedInteractionSource11, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
                ComposableLambda composableLambdaRememberComposableLambda1114 = ComposableLambdaKt.rememberComposableLambda(-474426875, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i115) {
                        ComposerKt.sourceInformation(composer2, "C267@12022L35,270@12231L5,265@11918L363:NavigationBar.kt#uh7d8r");
                        if ((i115 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-474426875, i115, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:265)");
                            }
                            Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                            ComposerKt.sourceInformationMarkerStart(composer2, 1335770416, "CC(remember):NavigationBar.kt#9igjgp");
                            boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                            final State<Float> state = stateAnimateFloatAsState;
                            Object objRememberedValue6 = composer2.rememberedValue();
                            if (zChanged3 || objRememberedValue6 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue6 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((GraphicsLayerScope) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(GraphicsLayerScope graphicsLayerScope) {
                                        graphicsLayerScope.setAlpha(state.getValue().floatValue());
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue6);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue6), navigationBarItemColors11116.getSelectedIndicatorColor(), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024981193, "CC(remember):NavigationBar.kt#9igjgp");
                zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
                objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                if (!zChanged2) {
                    objRememberedValue4 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2573invoke() {
                            return stateAnimateFloatAsState.getValue();
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                } else {
                    objRememberedValue4 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2573invoke() {
                            return stateAnimateFloatAsState.getValue();
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                NavigationBarItemLayout(composableLambdaRememberComposableLambda1113, composableLambdaRememberComposableLambda1114, composableLambdaRememberComposableLambda1112, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue4, composerStartRestartGroup, ((i114 >> 9) & 57344) | 438);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                navigationBarItemColors3 = navigationBarItemColors11116;
                z7 = z6;
                z8 = z4;
                mutableInteractionSource5 = mutableInteractionSource2;
                function7 = function119;
                modifier2 = modifier13;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i115) {
                        NavigationBarKt.NavigationBarItem(rowScope, z, function0, function2, modifier2, z7, function7, z8, navigationBarItemColors3, mutableInteractionSource5, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 196608;
        i6 = i2 & 32;
        if (i6 != 0) {
            if ((1572864 & i) == 0) {
                function4 = function3;
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i7 = 1048576;
                } else {
                    i7 = 524288;
                }
                i3 |= i7;
            }
            i8 = i2 & 64;
            if (i8 != 0) {
                i3 |= 12582912;
                z4 = z3;
            } else {
                z4 = z3;
                if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(z4)) {
                        i9 = 8388608;
                    } else {
                        i9 = 4194304;
                    }
                    i3 |= i9;
                }
            }
            if ((i & 100663296) != 0) {
                i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(navigationBarItemColors)) ? 33554432 : 67108864;
            }
            i10 = i2 & Fields.RotationX;
            if (i10 != 0) {
                i3 |= 805306368;
            } else if ((i & 805306368) == 0) {
                if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                    i11 = 536870912;
                } else {
                    i11 = 268435456;
                }
                i3 |= i11;
            }
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    } else {
                        function5 = function3;
                    }
                    if (i8 != 0) {
                        z4 = true;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i3 &= -234881025;
                    } else {
                        navigationBarItemColorsColors = navigationBarItemColors;
                    }
                    if (i10 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    z6 = z5;
                    i12 = i3;
                    NavigationBarItemColors navigationBarItemColors11117 = navigationBarItemColorsColors;
                    function6 = function5;
                    navigationBarItemColors2 = navigationBarItemColors11117;
                } else {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    } else {
                        function5 = function3;
                    }
                    if (i8 != 0) {
                        z4 = true;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i3 &= -234881025;
                    } else {
                        navigationBarItemColorsColors = navigationBarItemColors;
                    }
                    if (i10 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    z6 = z5;
                    i12 = i3;
                    NavigationBarItemColors navigationBarItemColors11118 = navigationBarItemColorsColors;
                    function6 = function5;
                    navigationBarItemColors2 = navigationBarItemColors11118;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-663510974, i12, -1, "androidx.compose.material3.NavigationBarItem (NavigationBar.kt:181)");
                }
                composerStartRestartGroup.startReplaceGroup(-103235253);
                ComposerKt.sourceInformation(composerStartRestartGroup, "183@8495L39");
                if (mutableInteractionSource2 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103234602, "CC(remember):NavigationBar.kt#9igjgp");
                    objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue5 = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue5;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                composerStartRestartGroup.endReplaceGroup();
                final NavigationBarItemColors navigationBarItemColors11119 = navigationBarItemColors2;
                final boolean z1111 = z6;
                final Function2<? super Composer, ? super Integer, Unit> function1110 = function6;
                final boolean z1112 = z4;
                int i115 = i12;
                ComposableLambda composableLambdaRememberComposableLambda1115 = ComposableLambdaKt.rememberComposableLambda(-1419576100, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i116) {
                        ComposerKt.sourceInformation(composer2, "C187@8623L201,193@9006L193:NavigationBar.kt#uh7d8r");
                        if ((i116 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1419576100, i116, -1, "androidx.compose.material3.NavigationBarItem.<anonymous> (NavigationBar.kt:186)");
                            }
                            State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors11119.m2563iconColorWaAFU9c$material3_release(z, z1111), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12);
                            Modifier.Companion companionClearAndSetSemantics = (function1110 == null || !(z1112 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                }

                                public Object invoke(Object obj) {
                                    invoke((SemanticsPropertyReceiver) obj);
                                    return Unit.INSTANCE;
                                }
                            });
                            Function2<Composer, Integer, Unit> function1111 = function2;
                            ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy12 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap12 = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier12 = ComposedModifierKt.materializeModifier(composer2, companionClearAndSetSemantics);
                            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                            ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                            if (!(composer2.getApplier() instanceof Applier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composer2.startReusableNode();
                            if (composer2.getInserting()) {
                                composer2.createNode(constructor2);
                            } else {
                                composer2.useNode();
                            }
                            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer2);
                            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy12, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap12, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier12, ComposeUiNode.INSTANCE.getSetModifier());
                            ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                            BoxScopeInstance boxScopeInstance12 = BoxScopeInstance.INSTANCE;
                            ComposerKt.sourceInformationMarkerStart(composer2, -1543680408, "C194@9107L78:NavigationBar.kt#uh7d8r");
                            CompositionLocalKt.CompositionLocalProvider(ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(invoke$lambda$0(stateM387animateColorAsStateeuL9pac))), function1111, composer2, ProvidedValue.$stable);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }

                    private static final long invoke$lambda$0(State<Color> state) {
                        return state.getValue().m4600unboximpl();
                    }
                }, composerStartRestartGroup, 54);
                composerStartRestartGroup.startReplaceGroup(-103209106);
                ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9305L535");
                if (function6 == null) {
                    composableLambdaRememberComposableLambda = null;
                } else {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1644987592, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i116) {
                            ComposerKt.sourceInformation(composer2, "C201@9369L5,203@9428L213,207@9658L168:NavigationBar.kt#uh7d8r");
                            if ((i116 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1644987592, i116, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:201)");
                                }
                                ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors2.m2564textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationBarTokens.INSTANCE.getLabelTextFont(), composer2, 6), function6, composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }

                        private static final long invoke$lambda$0(State<Color> state) {
                            return state.getValue().m4600unboximpl();
                        }
                    }, composerStartRestartGroup, 54);
                }
                composerStartRestartGroup.endReplaceGroup();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103190512, "CC(remember):NavigationBar.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotIntStateKt.mutableIntStateOf(0);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableIntState = (MutableIntState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifier14 = companion;
                mutableInteractionSource4 = mutableInteractionSource3;
                Modifier modifierWeight$default12 = RowScope.CC.weight$default(rowScope, SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationBarHeight, 1, null), 1.0f, false, 2, null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103176377, "CC(remember):NavigationBar.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = (Function1) new Function1<IntSize, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            m2572invokeozmzZPI(((IntSize) obj).unbox-impl());
                            return Unit.INSTANCE;
                        }

                        public final void m2572invokeozmzZPI(long j) {
                            mutableIntState.setIntValue(IntSize.getWidth-impl(j));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierOnSizeChanged12 = OnRemeasuredModifierKt.onSizeChanged(modifierWeight$default12, (Function1) objRememberedValue2);
                Alignment center12 = Alignment.INSTANCE.getCenter();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy12 = BoxKt.maybeCachedBoxMeasurePolicy(center12, true);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap12 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier12 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierOnSizeChanged12);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                final NavigationBarItemColors navigationBarItemColors111110 = navigationBarItemColors2;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy12, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap12, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier12, ComposeUiNode.INSTANCE.getSetModifier());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                BoxScopeInstance boxScopeInstance12 = BoxScopeInstance.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1652122706, "C234@10492L157,*243@10933L7,249@11215L128,256@11558L293,264@11900L395,281@12555L27,275@12305L288:NavigationBar.kt#uh7d8r");
                if (z) {
                    f = 1.0f;
                } else {
                    f = 0.0f;
                }
                Function2<? super Composer, ? super Integer, Unit> function1111 = function6;
                stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
                ProvidableCompositionLocal<Density> localDensity12 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume12 = composerStartRestartGroup.consume(localDensity12);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Density density12 = (Density) objConsume12;
                jOffset = OffsetKt.Offset((NavigationBarItem$lambda$3(mutableIntState) - density12.roundToPx-0680j_4(NavigationBarTokens.INSTANCE.m3683getActiveIndicatorWidthD9Ej5fM())) / 2, density12.toPx-0680j_4(IndicatorVerticalOffset));
                Unit unit12 = Unit.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024938414, "CC(remember):NavigationBar.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                final MappedInteractionSource mappedInteractionSource12 = (MappedInteractionSource) objRememberedValue3;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposableLambda composableLambdaRememberComposableLambda1116 = ComposableLambdaKt.rememberComposableLambda(691730997, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i116) {
                        ComposerKt.sourceInformation(composer2, "C259@11718L5,260@11786L32,257@11576L261:NavigationBar.kt#uh7d8r");
                        if ((i116 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(691730997, i116, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:257)");
                            }
                            BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), mappedInteractionSource12, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
                ComposableLambda composableLambdaRememberComposableLambda1117 = ComposableLambdaKt.rememberComposableLambda(-474426875, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i116) {
                        ComposerKt.sourceInformation(composer2, "C267@12022L35,270@12231L5,265@11918L363:NavigationBar.kt#uh7d8r");
                        if ((i116 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-474426875, i116, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:265)");
                            }
                            Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                            ComposerKt.sourceInformationMarkerStart(composer2, 1335770416, "CC(remember):NavigationBar.kt#9igjgp");
                            boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                            final State<Float> state = stateAnimateFloatAsState;
                            Object objRememberedValue6 = composer2.rememberedValue();
                            if (zChanged3 || objRememberedValue6 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue6 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((GraphicsLayerScope) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(GraphicsLayerScope graphicsLayerScope) {
                                        graphicsLayerScope.setAlpha(state.getValue().floatValue());
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue6);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue6), navigationBarItemColors111110.getSelectedIndicatorColor(), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024981193, "CC(remember):NavigationBar.kt#9igjgp");
                zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
                objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                if (!zChanged2) {
                    objRememberedValue4 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2573invoke() {
                            return stateAnimateFloatAsState.getValue();
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                } else {
                    objRememberedValue4 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2573invoke() {
                            return stateAnimateFloatAsState.getValue();
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                NavigationBarItemLayout(composableLambdaRememberComposableLambda1116, composableLambdaRememberComposableLambda1117, composableLambdaRememberComposableLambda1115, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue4, composerStartRestartGroup, ((i115 >> 9) & 57344) | 438);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                navigationBarItemColors3 = navigationBarItemColors111110;
                z7 = z6;
                z8 = z4;
                mutableInteractionSource5 = mutableInteractionSource2;
                function7 = function1111;
                modifier2 = modifier14;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    } else {
                        function5 = function3;
                    }
                    if (i8 != 0) {
                        z4 = true;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i3 &= -234881025;
                    } else {
                        navigationBarItemColorsColors = navigationBarItemColors;
                    }
                    if (i10 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    z6 = z5;
                    i12 = i3;
                    NavigationBarItemColors navigationBarItemColors111111 = navigationBarItemColorsColors;
                    function6 = function5;
                    navigationBarItemColors2 = navigationBarItemColors111111;
                } else {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    } else {
                        function5 = function3;
                    }
                    if (i8 != 0) {
                        z4 = true;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i3 &= -234881025;
                    } else {
                        navigationBarItemColorsColors = navigationBarItemColors;
                    }
                    if (i10 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    z6 = z5;
                    i12 = i3;
                    NavigationBarItemColors navigationBarItemColors111112 = navigationBarItemColorsColors;
                    function6 = function5;
                    navigationBarItemColors2 = navigationBarItemColors111112;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-663510974, i12, -1, "androidx.compose.material3.NavigationBarItem (NavigationBar.kt:181)");
                }
                composerStartRestartGroup.startReplaceGroup(-103235253);
                ComposerKt.sourceInformation(composerStartRestartGroup, "183@8495L39");
                if (mutableInteractionSource2 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103234602, "CC(remember):NavigationBar.kt#9igjgp");
                    objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue5 = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue5;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                composerStartRestartGroup.endReplaceGroup();
                final NavigationBarItemColors navigationBarItemColors111113 = navigationBarItemColors2;
                final boolean z1113 = z6;
                final Function2<? super Composer, ? super Integer, Unit> function1112 = function6;
                final boolean z1114 = z4;
                int i116 = i12;
                ComposableLambda composableLambdaRememberComposableLambda1118 = ComposableLambdaKt.rememberComposableLambda(-1419576100, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i117) {
                        ComposerKt.sourceInformation(composer2, "C187@8623L201,193@9006L193:NavigationBar.kt#uh7d8r");
                        if ((i117 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1419576100, i117, -1, "androidx.compose.material3.NavigationBarItem.<anonymous> (NavigationBar.kt:186)");
                            }
                            State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors111113.m2563iconColorWaAFU9c$material3_release(z, z1113), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12);
                            Modifier.Companion companionClearAndSetSemantics = (function1112 == null || !(z1114 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                }

                                public Object invoke(Object obj) {
                                    invoke((SemanticsPropertyReceiver) obj);
                                    return Unit.INSTANCE;
                                }
                            });
                            Function2<Composer, Integer, Unit> function1113 = function2;
                            ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy13 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap13 = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier13 = ComposedModifierKt.materializeModifier(composer2, companionClearAndSetSemantics);
                            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                            ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                            if (!(composer2.getApplier() instanceof Applier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composer2.startReusableNode();
                            if (composer2.getInserting()) {
                                composer2.createNode(constructor2);
                            } else {
                                composer2.useNode();
                            }
                            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer2);
                            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy13, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap13, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier13, ComposeUiNode.INSTANCE.getSetModifier());
                            ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                            BoxScopeInstance boxScopeInstance13 = BoxScopeInstance.INSTANCE;
                            ComposerKt.sourceInformationMarkerStart(composer2, -1543680408, "C194@9107L78:NavigationBar.kt#uh7d8r");
                            CompositionLocalKt.CompositionLocalProvider(ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(invoke$lambda$0(stateM387animateColorAsStateeuL9pac))), function1113, composer2, ProvidedValue.$stable);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }

                    private static final long invoke$lambda$0(State<Color> state) {
                        return state.getValue().m4600unboximpl();
                    }
                }, composerStartRestartGroup, 54);
                composerStartRestartGroup.startReplaceGroup(-103209106);
                ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9305L535");
                if (function6 == null) {
                    composableLambdaRememberComposableLambda = null;
                } else {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1644987592, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i117) {
                            ComposerKt.sourceInformation(composer2, "C201@9369L5,203@9428L213,207@9658L168:NavigationBar.kt#uh7d8r");
                            if ((i117 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1644987592, i117, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:201)");
                                }
                                ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors2.m2564textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationBarTokens.INSTANCE.getLabelTextFont(), composer2, 6), function6, composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }

                        private static final long invoke$lambda$0(State<Color> state) {
                            return state.getValue().m4600unboximpl();
                        }
                    }, composerStartRestartGroup, 54);
                }
                composerStartRestartGroup.endReplaceGroup();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103190512, "CC(remember):NavigationBar.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotIntStateKt.mutableIntStateOf(0);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableIntState = (MutableIntState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifier15 = companion;
                mutableInteractionSource4 = mutableInteractionSource3;
                Modifier modifierWeight$default13 = RowScope.CC.weight$default(rowScope, SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationBarHeight, 1, null), 1.0f, false, 2, null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103176377, "CC(remember):NavigationBar.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = (Function1) new Function1<IntSize, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            m2572invokeozmzZPI(((IntSize) obj).unbox-impl());
                            return Unit.INSTANCE;
                        }

                        public final void m2572invokeozmzZPI(long j) {
                            mutableIntState.setIntValue(IntSize.getWidth-impl(j));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierOnSizeChanged13 = OnRemeasuredModifierKt.onSizeChanged(modifierWeight$default13, (Function1) objRememberedValue2);
                Alignment center13 = Alignment.INSTANCE.getCenter();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy13 = BoxKt.maybeCachedBoxMeasurePolicy(center13, true);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap13 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier13 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierOnSizeChanged13);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                final NavigationBarItemColors navigationBarItemColors111114 = navigationBarItemColors2;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy13, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap13, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier13, ComposeUiNode.INSTANCE.getSetModifier());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                BoxScopeInstance boxScopeInstance13 = BoxScopeInstance.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1652122706, "C234@10492L157,*243@10933L7,249@11215L128,256@11558L293,264@11900L395,281@12555L27,275@12305L288:NavigationBar.kt#uh7d8r");
                if (z) {
                    f = 1.0f;
                } else {
                    f = 0.0f;
                }
                Function2<? super Composer, ? super Integer, Unit> function1113 = function6;
                stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
                ProvidableCompositionLocal<Density> localDensity13 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume13 = composerStartRestartGroup.consume(localDensity13);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Density density13 = (Density) objConsume13;
                jOffset = OffsetKt.Offset((NavigationBarItem$lambda$3(mutableIntState) - density13.roundToPx-0680j_4(NavigationBarTokens.INSTANCE.m3683getActiveIndicatorWidthD9Ej5fM())) / 2, density13.toPx-0680j_4(IndicatorVerticalOffset));
                Unit unit13 = Unit.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024938414, "CC(remember):NavigationBar.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                final MappedInteractionSource mappedInteractionSource13 = (MappedInteractionSource) objRememberedValue3;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposableLambda composableLambdaRememberComposableLambda1119 = ComposableLambdaKt.rememberComposableLambda(691730997, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i117) {
                        ComposerKt.sourceInformation(composer2, "C259@11718L5,260@11786L32,257@11576L261:NavigationBar.kt#uh7d8r");
                        if ((i117 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(691730997, i117, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:257)");
                            }
                            BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), mappedInteractionSource13, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
                ComposableLambda composableLambdaRememberComposableLambda11110 = ComposableLambdaKt.rememberComposableLambda(-474426875, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i117) {
                        ComposerKt.sourceInformation(composer2, "C267@12022L35,270@12231L5,265@11918L363:NavigationBar.kt#uh7d8r");
                        if ((i117 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-474426875, i117, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:265)");
                            }
                            Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                            ComposerKt.sourceInformationMarkerStart(composer2, 1335770416, "CC(remember):NavigationBar.kt#9igjgp");
                            boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                            final State<Float> state = stateAnimateFloatAsState;
                            Object objRememberedValue6 = composer2.rememberedValue();
                            if (zChanged3 || objRememberedValue6 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue6 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((GraphicsLayerScope) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(GraphicsLayerScope graphicsLayerScope) {
                                        graphicsLayerScope.setAlpha(state.getValue().floatValue());
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue6);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue6), navigationBarItemColors111114.getSelectedIndicatorColor(), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024981193, "CC(remember):NavigationBar.kt#9igjgp");
                zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
                objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                if (!zChanged2) {
                    objRememberedValue4 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2573invoke() {
                            return stateAnimateFloatAsState.getValue();
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                } else {
                    objRememberedValue4 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2573invoke() {
                            return stateAnimateFloatAsState.getValue();
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                NavigationBarItemLayout(composableLambdaRememberComposableLambda1119, composableLambdaRememberComposableLambda11110, composableLambdaRememberComposableLambda1118, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue4, composerStartRestartGroup, ((i116 >> 9) & 57344) | 438);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                navigationBarItemColors3 = navigationBarItemColors111114;
                z7 = z6;
                z8 = z4;
                mutableInteractionSource5 = mutableInteractionSource2;
                function7 = function1113;
                modifier2 = modifier15;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i117) {
                        NavigationBarKt.NavigationBarItem(rowScope, z, function0, function2, modifier2, z7, function7, z8, navigationBarItemColors3, mutableInteractionSource5, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 1572864;
        function4 = function3;
        i8 = i2 & 64;
        if (i8 != 0) {
            i3 |= 12582912;
            z4 = z3;
        } else {
            z4 = z3;
            if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changed(z4)) {
                    i9 = 8388608;
                } else {
                    i9 = 4194304;
                }
                i3 |= i9;
            }
        }
        if ((i & 100663296) != 0) {
            i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(navigationBarItemColors)) ? 33554432 : 67108864;
        }
        i10 = i2 & Fields.RotationX;
        if (i10 != 0) {
            i3 |= 805306368;
        } else if ((i & 805306368) == 0) {
            if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                i11 = 536870912;
            } else {
                i11 = 268435456;
            }
            i3 |= i11;
        }
        if ((i3 & 306783379) == 306783378) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i4 != 0) {
                    z5 = true;
                } else {
                    z5 = z2;
                }
                if (i6 != 0) {
                    function5 = null;
                } else {
                    function5 = function3;
                }
                if (i8 != 0) {
                    z4 = true;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    i3 &= -234881025;
                } else {
                    navigationBarItemColorsColors = navigationBarItemColors;
                }
                if (i10 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
                z6 = z5;
                i12 = i3;
                NavigationBarItemColors navigationBarItemColors111115 = navigationBarItemColorsColors;
                function6 = function5;
                navigationBarItemColors2 = navigationBarItemColors111115;
            } else {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i4 != 0) {
                    z5 = true;
                } else {
                    z5 = z2;
                }
                if (i6 != 0) {
                    function5 = null;
                } else {
                    function5 = function3;
                }
                if (i8 != 0) {
                    z4 = true;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    i3 &= -234881025;
                } else {
                    navigationBarItemColorsColors = navigationBarItemColors;
                }
                if (i10 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
                z6 = z5;
                i12 = i3;
                NavigationBarItemColors navigationBarItemColors111116 = navigationBarItemColorsColors;
                function6 = function5;
                navigationBarItemColors2 = navigationBarItemColors111116;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-663510974, i12, -1, "androidx.compose.material3.NavigationBarItem (NavigationBar.kt:181)");
            }
            composerStartRestartGroup.startReplaceGroup(-103235253);
            ComposerKt.sourceInformation(composerStartRestartGroup, "183@8495L39");
            if (mutableInteractionSource2 == null) {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103234602, "CC(remember):NavigationBar.kt#9igjgp");
                objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue5 = InteractionSourceKt.MutableInteractionSource();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue5;
            } else {
                mutableInteractionSource3 = mutableInteractionSource2;
            }
            composerStartRestartGroup.endReplaceGroup();
            final NavigationBarItemColors navigationBarItemColors111117 = navigationBarItemColors2;
            final boolean z1115 = z6;
            final Function2<? super Composer, ? super Integer, Unit> function1114 = function6;
            final boolean z1116 = z4;
            int i117 = i12;
            ComposableLambda composableLambdaRememberComposableLambda11111 = ComposableLambdaKt.rememberComposableLambda(-1419576100, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i118) {
                    ComposerKt.sourceInformation(composer2, "C187@8623L201,193@9006L193:NavigationBar.kt#uh7d8r");
                    if ((i118 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1419576100, i118, -1, "androidx.compose.material3.NavigationBarItem.<anonymous> (NavigationBar.kt:186)");
                        }
                        State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors111117.m2563iconColorWaAFU9c$material3_release(z, z1115), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12);
                        Modifier.Companion companionClearAndSetSemantics = (function1114 == null || !(z1116 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                            public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            }

                            public Object invoke(Object obj) {
                                invoke((SemanticsPropertyReceiver) obj);
                                return Unit.INSTANCE;
                            }
                        });
                        Function2<Composer, Integer, Unit> function1115 = function2;
                        ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy14 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                        CompositionLocalMap currentCompositionLocalMap14 = composer2.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier14 = ComposedModifierKt.materializeModifier(composer2, companionClearAndSetSemantics);
                        Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composer2.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composer2.startReusableNode();
                        if (composer2.getInserting()) {
                            composer2.createNode(constructor2);
                        } else {
                            composer2.useNode();
                        }
                        Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer2);
                        Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy14, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap14, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                            composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                            composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier14, ComposeUiNode.INSTANCE.getSetModifier());
                        ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                        BoxScopeInstance boxScopeInstance14 = BoxScopeInstance.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composer2, -1543680408, "C194@9107L78:NavigationBar.kt#uh7d8r");
                        CompositionLocalKt.CompositionLocalProvider(ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(invoke$lambda$0(stateM387animateColorAsStateeuL9pac))), function1115, composer2, ProvidedValue.$stable);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        composer2.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer2.skipToGroupEnd();
                }

                private static final long invoke$lambda$0(State<Color> state) {
                    return state.getValue().m4600unboximpl();
                }
            }, composerStartRestartGroup, 54);
            composerStartRestartGroup.startReplaceGroup(-103209106);
            ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9305L535");
            if (function6 == null) {
                composableLambdaRememberComposableLambda = null;
            } else {
                composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1644987592, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i118) {
                        ComposerKt.sourceInformation(composer2, "C201@9369L5,203@9428L213,207@9658L168:NavigationBar.kt#uh7d8r");
                        if ((i118 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1644987592, i118, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:201)");
                            }
                            ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors2.m2564textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationBarTokens.INSTANCE.getLabelTextFont(), composer2, 6), function6, composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }

                    private static final long invoke$lambda$0(State<Color> state) {
                        return state.getValue().m4600unboximpl();
                    }
                }, composerStartRestartGroup, 54);
            }
            composerStartRestartGroup.endReplaceGroup();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103190512, "CC(remember):NavigationBar.kt#9igjgp");
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = SnapshotIntStateKt.mutableIntStateOf(0);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            mutableIntState = (MutableIntState) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Modifier modifier16 = companion;
            mutableInteractionSource4 = mutableInteractionSource3;
            Modifier modifierWeight$default14 = RowScope.CC.weight$default(rowScope, SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationBarHeight, 1, null), 1.0f, false, 2, null);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103176377, "CC(remember):NavigationBar.kt#9igjgp");
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                objRememberedValue2 = (Function1) new Function1<IntSize, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        m2572invokeozmzZPI(((IntSize) obj).unbox-impl());
                        return Unit.INSTANCE;
                    }

                    public final void m2572invokeozmzZPI(long j) {
                        mutableIntState.setIntValue(IntSize.getWidth-impl(j));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Modifier modifierOnSizeChanged14 = OnRemeasuredModifierKt.onSizeChanged(modifierWeight$default14, (Function1) objRememberedValue2);
            Alignment center14 = Alignment.INSTANCE.getCenter();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy14 = BoxKt.maybeCachedBoxMeasurePolicy(center14, true);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
            currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap14 = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier14 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierOnSizeChanged14);
            constructor = ComposeUiNode.INSTANCE.getConstructor();
            final NavigationBarItemColors navigationBarItemColors111118 = navigationBarItemColors2;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
            if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                ComposablesKt.invalidApplier();
            }
            composerStartRestartGroup.startReusableNode();
            if (composerStartRestartGroup.getInserting()) {
                composerStartRestartGroup.createNode(constructor);
            } else {
                composerStartRestartGroup.useNode();
            }
            composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy14, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap14, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
            setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
            if (!composerM4037constructorimpl.getInserting()) {
                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            } else {
                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            }
            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier14, ComposeUiNode.INSTANCE.getSetModifier());
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
            BoxScopeInstance boxScopeInstance14 = BoxScopeInstance.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1652122706, "C234@10492L157,*243@10933L7,249@11215L128,256@11558L293,264@11900L395,281@12555L27,275@12305L288:NavigationBar.kt#uh7d8r");
            if (z) {
                f = 1.0f;
            } else {
                f = 0.0f;
            }
            Function2<? super Composer, ? super Integer, Unit> function1115 = function6;
            stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
            ProvidableCompositionLocal<Density> localDensity14 = CompositionLocalsKt.getLocalDensity();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume14 = composerStartRestartGroup.consume(localDensity14);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Density density14 = (Density) objConsume14;
            jOffset = OffsetKt.Offset((NavigationBarItem$lambda$3(mutableIntState) - density14.roundToPx-0680j_4(NavigationBarTokens.INSTANCE.m3683getActiveIndicatorWidthD9Ej5fM())) / 2, density14.toPx-0680j_4(IndicatorVerticalOffset));
            Unit unit14 = Unit.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024938414, "CC(remember):NavigationBar.kt#9igjgp");
            zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            } else {
                objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            }
            final MappedInteractionSource mappedInteractionSource14 = (MappedInteractionSource) objRememberedValue3;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposableLambda composableLambdaRememberComposableLambda11112 = ComposableLambdaKt.rememberComposableLambda(691730997, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i118) {
                    ComposerKt.sourceInformation(composer2, "C259@11718L5,260@11786L32,257@11576L261:NavigationBar.kt#uh7d8r");
                    if ((i118 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(691730997, i118, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:257)");
                        }
                        BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), mappedInteractionSource14, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer2.skipToGroupEnd();
                }
            }, composerStartRestartGroup, 54);
            ComposableLambda composableLambdaRememberComposableLambda11113 = ComposableLambdaKt.rememberComposableLambda(-474426875, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i118) {
                    ComposerKt.sourceInformation(composer2, "C267@12022L35,270@12231L5,265@11918L363:NavigationBar.kt#uh7d8r");
                    if ((i118 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-474426875, i118, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:265)");
                        }
                        Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                        ComposerKt.sourceInformationMarkerStart(composer2, 1335770416, "CC(remember):NavigationBar.kt#9igjgp");
                        boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                        final State<Float> state = stateAnimateFloatAsState;
                        Object objRememberedValue6 = composer2.rememberedValue();
                        if (zChanged3 || objRememberedValue6 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue6 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((GraphicsLayerScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(GraphicsLayerScope graphicsLayerScope) {
                                    graphicsLayerScope.setAlpha(state.getValue().floatValue());
                                }
                            };
                            composer2.updateRememberedValue(objRememberedValue6);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue6), navigationBarItemColors111118.getSelectedIndicatorColor(), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), composer2, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer2.skipToGroupEnd();
                }
            }, composerStartRestartGroup, 54);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024981193, "CC(remember):NavigationBar.kt#9igjgp");
            zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
            objRememberedValue4 = composerStartRestartGroup.rememberedValue();
            if (!zChanged2) {
                objRememberedValue4 = (Function0) new Function0<Float>() {
                    {
                        super(0);
                    }

                    public final Float m2573invoke() {
                        return stateAnimateFloatAsState.getValue();
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
            } else {
                objRememberedValue4 = (Function0) new Function0<Float>() {
                    {
                        super(0);
                    }

                    public final Float m2573invoke() {
                        return stateAnimateFloatAsState.getValue();
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            NavigationBarItemLayout(composableLambdaRememberComposableLambda11112, composableLambdaRememberComposableLambda11113, composableLambdaRememberComposableLambda11111, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue4, composerStartRestartGroup, ((i117 >> 9) & 57344) | 438);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            navigationBarItemColors3 = navigationBarItemColors111118;
            z7 = z6;
            z8 = z4;
            mutableInteractionSource5 = mutableInteractionSource2;
            function7 = function1115;
            modifier2 = modifier16;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i4 != 0) {
                    z5 = true;
                } else {
                    z5 = z2;
                }
                if (i6 != 0) {
                    function5 = null;
                } else {
                    function5 = function3;
                }
                if (i8 != 0) {
                    z4 = true;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    i3 &= -234881025;
                } else {
                    navigationBarItemColorsColors = navigationBarItemColors;
                }
                if (i10 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
                z6 = z5;
                i12 = i3;
                NavigationBarItemColors navigationBarItemColors111119 = navigationBarItemColorsColors;
                function6 = function5;
                navigationBarItemColors2 = navigationBarItemColors111119;
            } else {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i4 != 0) {
                    z5 = true;
                } else {
                    z5 = z2;
                }
                if (i6 != 0) {
                    function5 = null;
                } else {
                    function5 = function3;
                }
                if (i8 != 0) {
                    z4 = true;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    navigationBarItemColorsColors = NavigationBarItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    i3 &= -234881025;
                } else {
                    navigationBarItemColorsColors = navigationBarItemColors;
                }
                if (i10 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
                z6 = z5;
                i12 = i3;
                NavigationBarItemColors navigationBarItemColors1111110 = navigationBarItemColorsColors;
                function6 = function5;
                navigationBarItemColors2 = navigationBarItemColors1111110;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-663510974, i12, -1, "androidx.compose.material3.NavigationBarItem (NavigationBar.kt:181)");
            }
            composerStartRestartGroup.startReplaceGroup(-103235253);
            ComposerKt.sourceInformation(composerStartRestartGroup, "183@8495L39");
            if (mutableInteractionSource2 == null) {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103234602, "CC(remember):NavigationBar.kt#9igjgp");
                objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue5 = InteractionSourceKt.MutableInteractionSource();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue5;
            } else {
                mutableInteractionSource3 = mutableInteractionSource2;
            }
            composerStartRestartGroup.endReplaceGroup();
            final NavigationBarItemColors navigationBarItemColors1111111 = navigationBarItemColors2;
            final boolean z1117 = z6;
            final Function2<? super Composer, ? super Integer, Unit> function1116 = function6;
            final boolean z1118 = z4;
            int i118 = i12;
            ComposableLambda composableLambdaRememberComposableLambda11114 = ComposableLambdaKt.rememberComposableLambda(-1419576100, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i119) {
                    ComposerKt.sourceInformation(composer2, "C187@8623L201,193@9006L193:NavigationBar.kt#uh7d8r");
                    if ((i119 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1419576100, i119, -1, "androidx.compose.material3.NavigationBarItem.<anonymous> (NavigationBar.kt:186)");
                        }
                        State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors1111111.m2563iconColorWaAFU9c$material3_release(z, z1117), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12);
                        Modifier.Companion companionClearAndSetSemantics = (function1116 == null || !(z1118 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                            public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            }

                            public Object invoke(Object obj) {
                                invoke((SemanticsPropertyReceiver) obj);
                                return Unit.INSTANCE;
                            }
                        });
                        Function2<Composer, Integer, Unit> function1117 = function2;
                        ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy15 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                        CompositionLocalMap currentCompositionLocalMap15 = composer2.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier15 = ComposedModifierKt.materializeModifier(composer2, companionClearAndSetSemantics);
                        Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composer2.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composer2.startReusableNode();
                        if (composer2.getInserting()) {
                            composer2.createNode(constructor2);
                        } else {
                            composer2.useNode();
                        }
                        Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer2);
                        Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy15, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap15, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                            composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                            composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier15, ComposeUiNode.INSTANCE.getSetModifier());
                        ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                        BoxScopeInstance boxScopeInstance15 = BoxScopeInstance.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composer2, -1543680408, "C194@9107L78:NavigationBar.kt#uh7d8r");
                        CompositionLocalKt.CompositionLocalProvider(ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(invoke$lambda$0(stateM387animateColorAsStateeuL9pac))), function1117, composer2, ProvidedValue.$stable);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        composer2.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer2.skipToGroupEnd();
                }

                private static final long invoke$lambda$0(State<Color> state) {
                    return state.getValue().m4600unboximpl();
                }
            }, composerStartRestartGroup, 54);
            composerStartRestartGroup.startReplaceGroup(-103209106);
            ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9305L535");
            if (function6 == null) {
                composableLambdaRememberComposableLambda = null;
            } else {
                composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1644987592, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i119) {
                        ComposerKt.sourceInformation(composer2, "C201@9369L5,203@9428L213,207@9658L168:NavigationBar.kt#uh7d8r");
                        if ((i119 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1644987592, i119, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:201)");
                            }
                            ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationBarItemColors2.m2564textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationBarTokens.INSTANCE.getLabelTextFont(), composer2, 6), function6, composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }

                    private static final long invoke$lambda$0(State<Color> state) {
                        return state.getValue().m4600unboximpl();
                    }
                }, composerStartRestartGroup, 54);
            }
            composerStartRestartGroup.endReplaceGroup();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103190512, "CC(remember):NavigationBar.kt#9igjgp");
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = SnapshotIntStateKt.mutableIntStateOf(0);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            mutableIntState = (MutableIntState) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Modifier modifier17 = companion;
            mutableInteractionSource4 = mutableInteractionSource3;
            Modifier modifierWeight$default15 = RowScope.CC.weight$default(rowScope, SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationBarHeight, 1, null), 1.0f, false, 2, null);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -103176377, "CC(remember):NavigationBar.kt#9igjgp");
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                objRememberedValue2 = (Function1) new Function1<IntSize, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        m2572invokeozmzZPI(((IntSize) obj).unbox-impl());
                        return Unit.INSTANCE;
                    }

                    public final void m2572invokeozmzZPI(long j) {
                        mutableIntState.setIntValue(IntSize.getWidth-impl(j));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Modifier modifierOnSizeChanged15 = OnRemeasuredModifierKt.onSizeChanged(modifierWeight$default15, (Function1) objRememberedValue2);
            Alignment center15 = Alignment.INSTANCE.getCenter();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy15 = BoxKt.maybeCachedBoxMeasurePolicy(center15, true);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
            currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap15 = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier15 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierOnSizeChanged15);
            constructor = ComposeUiNode.INSTANCE.getConstructor();
            final NavigationBarItemColors navigationBarItemColors1111112 = navigationBarItemColors2;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
            if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                ComposablesKt.invalidApplier();
            }
            composerStartRestartGroup.startReusableNode();
            if (composerStartRestartGroup.getInserting()) {
                composerStartRestartGroup.createNode(constructor);
            } else {
                composerStartRestartGroup.useNode();
            }
            composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy15, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap15, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
            setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
            if (!composerM4037constructorimpl.getInserting()) {
                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            } else {
                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            }
            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier15, ComposeUiNode.INSTANCE.getSetModifier());
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
            BoxScopeInstance boxScopeInstance15 = BoxScopeInstance.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1652122706, "C234@10492L157,*243@10933L7,249@11215L128,256@11558L293,264@11900L395,281@12555L27,275@12305L288:NavigationBar.kt#uh7d8r");
            if (z) {
                f = 1.0f;
            } else {
                f = 0.0f;
            }
            Function2<? super Composer, ? super Integer, Unit> function1117 = function6;
            stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
            ProvidableCompositionLocal<Density> localDensity15 = CompositionLocalsKt.getLocalDensity();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume15 = composerStartRestartGroup.consume(localDensity15);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Density density15 = (Density) objConsume15;
            jOffset = OffsetKt.Offset((NavigationBarItem$lambda$3(mutableIntState) - density15.roundToPx-0680j_4(NavigationBarTokens.INSTANCE.m3683getActiveIndicatorWidthD9Ej5fM())) / 2, density15.toPx-0680j_4(IndicatorVerticalOffset));
            Unit unit15 = Unit.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024938414, "CC(remember):NavigationBar.kt#9igjgp");
            zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            } else {
                objRememberedValue3 = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            }
            final MappedInteractionSource mappedInteractionSource15 = (MappedInteractionSource) objRememberedValue3;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposableLambda composableLambdaRememberComposableLambda11115 = ComposableLambdaKt.rememberComposableLambda(691730997, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i119) {
                    ComposerKt.sourceInformation(composer2, "C259@11718L5,260@11786L32,257@11576L261:NavigationBar.kt#uh7d8r");
                    if ((i119 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(691730997, i119, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:257)");
                        }
                        BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), mappedInteractionSource15, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer2.skipToGroupEnd();
                }
            }, composerStartRestartGroup, 54);
            ComposableLambda composableLambdaRememberComposableLambda11116 = ComposableLambdaKt.rememberComposableLambda(-474426875, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i119) {
                    ComposerKt.sourceInformation(composer2, "C267@12022L35,270@12231L5,265@11918L363:NavigationBar.kt#uh7d8r");
                    if ((i119 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-474426875, i119, -1, "androidx.compose.material3.NavigationBarItem.<anonymous>.<anonymous> (NavigationBar.kt:265)");
                        }
                        Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                        ComposerKt.sourceInformationMarkerStart(composer2, 1335770416, "CC(remember):NavigationBar.kt#9igjgp");
                        boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                        final State<Float> state = stateAnimateFloatAsState;
                        Object objRememberedValue6 = composer2.rememberedValue();
                        if (zChanged3 || objRememberedValue6 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue6 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((GraphicsLayerScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(GraphicsLayerScope graphicsLayerScope) {
                                    graphicsLayerScope.setAlpha(state.getValue().floatValue());
                                }
                            };
                            composer2.updateRememberedValue(objRememberedValue6);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue6), navigationBarItemColors1111112.getSelectedIndicatorColor(), ShapesKt.getValue(NavigationBarTokens.INSTANCE.getActiveIndicatorShape(), composer2, 6)), composer2, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer2.skipToGroupEnd();
                }
            }, composerStartRestartGroup, 54);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2024981193, "CC(remember):NavigationBar.kt#9igjgp");
            zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
            objRememberedValue4 = composerStartRestartGroup.rememberedValue();
            if (!zChanged2) {
                objRememberedValue4 = (Function0) new Function0<Float>() {
                    {
                        super(0);
                    }

                    public final Float m2573invoke() {
                        return stateAnimateFloatAsState.getValue();
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
            } else {
                objRememberedValue4 = (Function0) new Function0<Float>() {
                    {
                        super(0);
                    }

                    public final Float m2573invoke() {
                        return stateAnimateFloatAsState.getValue();
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            NavigationBarItemLayout(composableLambdaRememberComposableLambda11115, composableLambdaRememberComposableLambda11116, composableLambdaRememberComposableLambda11114, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue4, composerStartRestartGroup, ((i118 >> 9) & 57344) | 438);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            navigationBarItemColors3 = navigationBarItemColors1111112;
            z7 = z6;
            z8 = z4;
            mutableInteractionSource5 = mutableInteractionSource2;
            function7 = function1117;
            modifier2 = modifier17;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i119) {
                    NavigationBarKt.NavigationBarItem(rowScope, z, function0, function2, modifier2, z7, function7, z8, navigationBarItemColors3, mutableInteractionSource5, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    private static final int NavigationBarItem$lambda$3(MutableIntState mutableIntState) {
        return mutableIntState.getIntValue();
    }

    public static final void NavigationBarItemLayout(final Function2<? super Composer, ? super Integer, Unit> function2, final Function2<? super Composer, ? super Integer, Unit> function3, final Function2<? super Composer, ? super Integer, Unit> function4, final Function2<? super Composer, ? super Integer, Unit> function5, final boolean z, final Function0<Float> function0, Composer composer, final int i) {
        int i2;
        int i3;
        boolean z2;
        int i4;
        Object obj;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1427075886);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(NavigationBarItemLayout)P(4,3,2,5)532@23467L1717,517@23004L2180:NavigationBar.kt#uh7d8r");
        if ((i & 6) == 0) {
            i2 = (composerStartRestartGroup.changedInstance(function2) ? 4 : 2) | i;
        } else {
            i2 = i;
        }
        if ((i & 48) == 0) {
            i2 |= composerStartRestartGroup.changedInstance(function3) ? 32 : 16;
        }
        if ((i & 384) == 0) {
            i2 |= composerStartRestartGroup.changedInstance(function4) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i & 3072) == 0) {
            i2 |= composerStartRestartGroup.changedInstance(function5) ? 2048 : Fields.RotationZ;
        }
        if ((i & 24576) == 0) {
            i2 |= composerStartRestartGroup.changed(z) ? 16384 : Fields.Shape;
        }
        if ((196608 & i) == 0) {
            i2 |= composerStartRestartGroup.changedInstance(function0) ? 131072 : 65536;
        }
        if ((74899 & i2) != 74898 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1427075886, i2, -1, "androidx.compose.material3.NavigationBarItemLayout (NavigationBar.kt:516)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -96239762, "CC(remember):NavigationBar.kt#9igjgp");
            int i5 = 458752 & i2;
            int i6 = 57344 & i2;
            boolean z3 = (i5 == 131072) | ((i2 & 7168) == 2048) | (i6 == 16384);
            MeasurePolicy measurePolicyRememberedValue = composerStartRestartGroup.rememberedValue();
            if (z3 || measurePolicyRememberedValue == Composer.INSTANCE.getEmpty()) {
                measurePolicyRememberedValue = new MeasurePolicy() {
                    @Override
                    public int maxIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i7) {
                        return MeasurePolicy.CC.$default$maxIntrinsicHeight(this, intrinsicMeasureScope, list, i7);
                    }

                    @Override
                    public int maxIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i7) {
                        return MeasurePolicy.CC.$default$maxIntrinsicWidth(this, intrinsicMeasureScope, list, i7);
                    }

                    @Override
                    public int minIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i7) {
                        return MeasurePolicy.CC.$default$minIntrinsicHeight(this, intrinsicMeasureScope, list, i7);
                    }

                    @Override
                    public int minIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i7) {
                        return MeasurePolicy.CC.$default$minIntrinsicWidth(this, intrinsicMeasureScope, list, i7);
                    }

                    @Override
                    public final MeasureResult mo296measure3p2s80s(MeasureScope measureScope, List<? extends Measurable> list, long j) {
                        Measurable measurable;
                        Placeable placeableMo6026measureBRTryo0;
                        float fFloatValue = ((Number) function0.invoke()).floatValue();
                        long j2 = Constraints.copy-Zbe2FdA$default(j, 0, 0, 0, 0, 10, (Object) null);
                        int size = list.size();
                        for (int i7 = 0; i7 < size; i7++) {
                            Measurable measurable2 = list.get(i7);
                            if (Intrinsics.areEqual(LayoutIdKt.getLayoutId(measurable2), "icon")) {
                                Placeable placeableMo6026measureBRTryo1 = measurable2.mo6026measureBRTryo0(j2);
                                float f = 2;
                                int width = placeableMo6026measureBRTryo1.getWidth() + measureScope.roundToPx-0680j_4(Dp.constructor-impl(NavigationBarKt.IndicatorHorizontalPadding * f));
                                int iRoundToInt = MathKt.roundToInt(width * fFloatValue);
                                int height = placeableMo6026measureBRTryo1.getHeight() + measureScope.roundToPx-0680j_4(Dp.constructor-impl(NavigationBarKt.getIndicatorVerticalPadding() * f));
                                int size2 = list.size();
                                for (int i8 = 0; i8 < size2; i8++) {
                                    Measurable measurable3 = list.get(i8);
                                    if (Intrinsics.areEqual(LayoutIdKt.getLayoutId(measurable3), "indicatorRipple")) {
                                        Placeable placeableMo6026measureBRTryo2 = measurable3.mo6026measureBRTryo0(Constraints.Companion.fixed-JhjzzOo(width, height));
                                        int size3 = list.size();
                                        int i9 = 0;
                                        while (true) {
                                            if (i9 >= size3) {
                                                measurable = null;
                                                break;
                                            }
                                            measurable = list.get(i9);
                                            if (Intrinsics.areEqual(LayoutIdKt.getLayoutId(measurable), "indicator")) {
                                                break;
                                            }
                                            i9++;
                                        }
                                        Measurable measurable4 = measurable;
                                        Placeable placeableMo6026measureBRTryo3 = measurable4 != null ? measurable4.mo6026measureBRTryo0(Constraints.Companion.fixed-JhjzzOo(iRoundToInt, height)) : null;
                                        if (function5 != null) {
                                            int size4 = list.size();
                                            int i10 = 0;
                                            while (true) {
                                                if (i10 < size4) {
                                                    Measurable measurable5 = list.get(i10);
                                                    if (Intrinsics.areEqual(LayoutIdKt.getLayoutId(measurable5), "label")) {
                                                        placeableMo6026measureBRTryo0 = measurable5.mo6026measureBRTryo0(j2);
                                                        break;
                                                    }
                                                    i10++;
                                                } else {
                                                    throw new NoSuchElementException("Collection contains no element matching the predicate.");
                                                }
                                            }
                                        } else {
                                            placeableMo6026measureBRTryo0 = null;
                                        }
                                        if (function5 == null) {
                                            return NavigationBarKt.m2570placeIconX9ElhV4(measureScope, placeableMo6026measureBRTryo1, placeableMo6026measureBRTryo2, placeableMo6026measureBRTryo3, j);
                                        }
                                        Intrinsics.checkNotNull(placeableMo6026measureBRTryo0);
                                        return NavigationBarKt.m2571placeLabelAndIconzUg2_y0(measureScope, placeableMo6026measureBRTryo0, placeableMo6026measureBRTryo1, placeableMo6026measureBRTryo2, placeableMo6026measureBRTryo3, j, z, fFloatValue);
                                    }
                                }
                                throw new NoSuchElementException("Collection contains no element matching the predicate.");
                            }
                        }
                        throw new NoSuchElementException("Collection contains no element matching the predicate.");
                    }
                };
                composerStartRestartGroup.updateRememberedValue(measurePolicyRememberedValue);
            }
            MeasurePolicy measurePolicy = (MeasurePolicy) measurePolicyRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
            Modifier.Companion companion = Modifier.INSTANCE;
            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
            Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
            if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                ComposablesKt.invalidApplier();
            }
            composerStartRestartGroup.startReusableNode();
            if (composerStartRestartGroup.getInserting()) {
                composerStartRestartGroup.createNode(constructor);
            } else {
                composerStartRestartGroup.useNode();
            }
            Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            }
            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -656695659, "C518@23021L17,519@23047L11,521@23068L50:NavigationBar.kt#uh7d8r");
            function2.invoke(composerStartRestartGroup, Integer.valueOf(i2 & 14));
            function3.invoke(composerStartRestartGroup, Integer.valueOf((i2 >> 3) & 14));
            Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, IconLayoutIdTag);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap2 = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierLayoutId);
            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
            if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                ComposablesKt.invalidApplier();
            }
            composerStartRestartGroup.startReusableNode();
            if (composerStartRestartGroup.getInserting()) {
                composerStartRestartGroup.createNode(constructor2);
            } else {
                composerStartRestartGroup.useNode();
            }
            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composerStartRestartGroup);
            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
            }
            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
            BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2034219770, "C521@23110L6:NavigationBar.kt#uh7d8r");
            function4.invoke(composerStartRestartGroup, Integer.valueOf((i2 >> 6) & 14));
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.startReplaceGroup(1087198243);
            ComposerKt.sourceInformation(composerStartRestartGroup, "526@23253L60,524@23161L288");
            if (function5 != null) {
                Modifier modifierLayoutId2 = LayoutIdKt.layoutId(Modifier.INSTANCE, LabelLayoutIdTag);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1087201972, "CC(remember):NavigationBar.kt#9igjgp");
                if (i6 == 16384) {
                    i3 = Fields.RenderEffect;
                    z2 = true;
                } else {
                    i3 = Fields.RenderEffect;
                    z2 = false;
                }
                boolean z4 = (i5 == i3) | z2;
                Object objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (z4 || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    i4 = -692256719;
                    obj = (Function1) new Function1<GraphicsLayerScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj2) {
                            invoke((GraphicsLayerScope) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(GraphicsLayerScope graphicsLayerScope) {
                            graphicsLayerScope.setAlpha(z ? 1.0f : ((Number) function0.invoke()).floatValue());
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(obj);
                } else {
                    obj = objRememberedValue;
                    i4 = -692256719;
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierM1037paddingVpY3zN4$default = PaddingKt.m1037paddingVpY3zN4$default(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId2, (Function1) obj), Dp.constructor-impl(NavigationBarItemHorizontalPadding / 2), 0.0f, 2, null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap3 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM1037paddingVpY3zN4$default);
                Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, i4, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor3);
                } else {
                    composerStartRestartGroup.useNode();
                }
                Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                    composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                    composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                }
                Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2033904283, "C529@23428L7:NavigationBar.kt#uh7d8r");
                function5.invoke(composerStartRestartGroup, Integer.valueOf((i2 >> 9) & 14));
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            }
            composerStartRestartGroup.endReplaceGroup();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.skipToGroupEnd();
        }
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj2, Object obj3) {
                    invoke((Composer) obj2, ((Number) obj3).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i7) {
                    NavigationBarKt.NavigationBarItemLayout(function2, function3, function4, function5, z, function0, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1));
                }
            });
        }
    }

    public static final MeasureResult m2570placeIconX9ElhV4(MeasureScope measureScope, final Placeable placeable, final Placeable placeable2, final Placeable placeable3, long j) {
        final int i = Constraints.getMaxWidth-impl(j);
        final int i2 = ConstraintsKt.constrainHeight-K40F9xA(j, measureScope.roundToPx-0680j_4(NavigationBarHeight));
        final int width = (i - placeable.getWidth()) / 2;
        final int height = (i2 - placeable.getHeight()) / 2;
        final int width2 = (i - placeable2.getWidth()) / 2;
        final int height2 = (i2 - placeable2.getHeight()) / 2;
        return MeasureScope.CC.layout$default(measureScope, i, i2, null, new Function1<Placeable.PlacementScope, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((Placeable.PlacementScope) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(Placeable.PlacementScope placementScope) {
                Placeable placeable4 = placeable3;
                if (placeable4 != null) {
                    Placeable.PlacementScope.placeRelative$default(placementScope, placeable4, (i - placeable4.getWidth()) / 2, (i2 - placeable4.getHeight()) / 2, 0.0f, 4, null);
                }
                Placeable.PlacementScope.placeRelative$default(placementScope, placeable, width, height, 0.0f, 4, null);
                Placeable.PlacementScope.placeRelative$default(placementScope, placeable2, width2, height2, 0.0f, 4, null);
            }
        }, 4, null);
    }

    public static final MeasureResult m2571placeLabelAndIconzUg2_y0(final MeasureScope measureScope, final Placeable placeable, final Placeable placeable2, final Placeable placeable3, final Placeable placeable4, long j, final boolean z, final float f) {
        float height = placeable2.getHeight();
        float f2 = IndicatorVerticalPadding;
        float f3 = height + measureScope.toPx-0680j_4(f2);
        float f4 = NavigationBarIndicatorToLabelPadding;
        float f5 = f3 + measureScope.toPx-0680j_4(f4) + placeable.getHeight();
        float f6 = 2;
        final float fCoerceAtLeast = RangesKt.coerceAtLeast((Constraints.getMinHeight-impl(j) - f5) / f6, measureScope.toPx-0680j_4(f2));
        float f7 = f5 + (fCoerceAtLeast * f6);
        final float height2 = ((z ? fCoerceAtLeast : (f7 - placeable2.getHeight()) / f6) - fCoerceAtLeast) * (1 - f);
        final float height3 = placeable2.getHeight() + fCoerceAtLeast + measureScope.toPx-0680j_4(f2) + measureScope.toPx-0680j_4(f4);
        final int i = Constraints.getMaxWidth-impl(j);
        final int width = (i - placeable.getWidth()) / 2;
        final int width2 = (i - placeable2.getWidth()) / 2;
        final int width3 = (i - placeable3.getWidth()) / 2;
        final float f8 = fCoerceAtLeast - measureScope.toPx-0680j_4(f2);
        return MeasureScope.CC.layout$default(measureScope, i, MathKt.roundToInt(f7), null, new Function1<Placeable.PlacementScope, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((Placeable.PlacementScope) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(Placeable.PlacementScope placementScope) {
                Placeable placeable5 = placeable4;
                if (placeable5 != null) {
                    Placeable.PlacementScope.placeRelative$default(placementScope, placeable5, (i - placeable5.getWidth()) / 2, MathKt.roundToInt((fCoerceAtLeast - measureScope.roundToPx-0680j_4(NavigationBarKt.getIndicatorVerticalPadding())) + height2), 0.0f, 4, null);
                }
                if (z || f != 0.0f) {
                    Placeable.PlacementScope.placeRelative$default(placementScope, placeable, width, MathKt.roundToInt(height3 + height2), 0.0f, 4, null);
                }
                Placeable.PlacementScope.placeRelative$default(placementScope, placeable2, width2, MathKt.roundToInt(fCoerceAtLeast + height2), 0.0f, 4, null);
                Placeable.PlacementScope.placeRelative$default(placementScope, placeable3, width3, MathKt.roundToInt(f8 + height2), 0.0f, 4, null);
            }
        }, 4, null);
    }

    static {
        float f = 2;
        IndicatorHorizontalPadding = Dp.constructor-impl(Dp.constructor-impl(NavigationBarTokens.INSTANCE.m3683getActiveIndicatorWidthD9Ej5fM() - NavigationBarTokens.INSTANCE.m3686getIconSizeD9Ej5fM()) / f);
        IndicatorVerticalPadding = Dp.constructor-impl(Dp.constructor-impl(NavigationBarTokens.INSTANCE.m3682getActiveIndicatorHeightD9Ej5fM() - NavigationBarTokens.INSTANCE.m3686getIconSizeD9Ej5fM()) / f);
    }

    public static final float getNavigationBarItemHorizontalPadding() {
        return NavigationBarItemHorizontalPadding;
    }

    public static final float getNavigationBarIndicatorToLabelPadding() {
        return NavigationBarIndicatorToLabelPadding;
    }

    public static final float getIndicatorVerticalPadding() {
        return IndicatorVerticalPadding;
    }
}
