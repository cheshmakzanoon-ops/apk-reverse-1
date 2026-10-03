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
import androidx.compose.foundation.layout.ColumnKt;
import androidx.compose.foundation.layout.ColumnScope;
import androidx.compose.foundation.layout.ColumnScopeInstance;
import androidx.compose.foundation.layout.PaddingKt;
import androidx.compose.foundation.layout.SizeKt;
import androidx.compose.foundation.layout.SpacerKt;
import androidx.compose.foundation.layout.WindowInsets;
import androidx.compose.foundation.layout.WindowInsetsPaddingKt;
import androidx.compose.foundation.selection.SelectableGroupKt;
import androidx.compose.foundation.selection.SelectableKt;
import androidx.compose.material3.internal.MappedInteractionSource;
import androidx.compose.material3.internal.ProvideContentColorTextStyleKt;
import androidx.compose.material3.tokens.NavigationRailTokens;
import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.ComposedModifierKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.draw.ClipKt;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.GraphicsLayerModifierKt;
import androidx.compose.p002ui.graphics.GraphicsLayerScope;
import androidx.compose.p002ui.graphics.Shape;
import androidx.compose.p002ui.layout.IntrinsicMeasureScope;
import androidx.compose.p002ui.layout.LayoutIdKt;
import androidx.compose.p002ui.layout.Measurable;
import androidx.compose.p002ui.layout.MeasurePolicy;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.MeasureScope;
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
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.runtime.ProvidedValue;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.State;
import androidx.compose.runtime.Updater;
import androidx.compose.runtime.internal.ComposableLambda;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.ConstraintsKt;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.Dp;
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

@Metadata(d1 = {"\u0000\u0084\u0001\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\b\n\u0002\b\f\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0007\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\t\u001az\u0010\u0016\u001a\u00020\u00172\b\b\u0002\u0010\u0018\u001a\u00020\u00192\b\b\u0002\u0010\u001a\u001a\u00020\u001b2\b\b\u0002\u0010\u001c\u001a\u00020\u001b2 \b\u0002\u0010\u001d\u001a\u001a\u0012\u0004\u0012\u00020\u001f\u0012\u0004\u0012\u00020\u0017\u0018\u00010\u001e¢\u0006\u0002\b ¢\u0006\u0002\b!2\b\b\u0002\u0010\"\u001a\u00020#2\u001c\u0010$\u001a\u0018\u0012\u0004\u0012\u00020\u001f\u0012\u0004\u0012\u00020\u00170\u001e¢\u0006\u0002\b ¢\u0006\u0002\b!H\u0007ø\u0001\u0000¢\u0006\u0004\b%\u0010&\u001a\u0081\u0001\u0010'\u001a\u00020\u00172\u0006\u0010(\u001a\u00020)2\f\u0010*\u001a\b\u0012\u0004\u0012\u00020\u00170+2\u0011\u0010,\u001a\r\u0012\u0004\u0012\u00020\u00170+¢\u0006\u0002\b 2\b\b\u0002\u0010\u0018\u001a\u00020\u00192\b\b\u0002\u0010-\u001a\u00020)2\u0015\b\u0002\u0010.\u001a\u000f\u0012\u0004\u0012\u00020\u0017\u0018\u00010+¢\u0006\u0002\b 2\b\b\u0002\u0010/\u001a\u00020)2\b\b\u0002\u00100\u001a\u0002012\n\b\u0002\u00102\u001a\u0004\u0018\u000103H\u0007¢\u0006\u0002\u00104\u001aq\u00105\u001a\u00020\u00172\u0011\u00106\u001a\r\u0012\u0004\u0012\u00020\u00170+¢\u0006\u0002\b 2\u0011\u00107\u001a\r\u0012\u0004\u0012\u00020\u00170+¢\u0006\u0002\b 2\u0011\u0010,\u001a\r\u0012\u0004\u0012\u00020\u00170+¢\u0006\u0002\b 2\u0013\u0010.\u001a\u000f\u0012\u0004\u0012\u00020\u0017\u0018\u00010+¢\u0006\u0002\b 2\u0006\u0010/\u001a\u00020)2\f\u00108\u001a\b\u0012\u0004\u0012\u0002090+H\u0003¢\u0006\u0002\u0010:\u001a8\u0010;\u001a\u00020<*\u00020=2\u0006\u0010>\u001a\u00020?2\u0006\u0010@\u001a\u00020?2\b\u0010A\u001a\u0004\u0018\u00010?2\u0006\u0010B\u001a\u00020CH\u0002ø\u0001\u0000¢\u0006\u0004\bD\u0010E\u001aP\u0010F\u001a\u00020<*\u00020=2\u0006\u0010G\u001a\u00020?2\u0006\u0010>\u001a\u00020?2\u0006\u0010@\u001a\u00020?2\b\u0010A\u001a\u0004\u0018\u00010?2\u0006\u0010B\u001a\u00020C2\u0006\u0010/\u001a\u00020)2\u0006\u00108\u001a\u000209H\u0002ø\u0001\u0000¢\u0006\u0004\bH\u0010I\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000\"\u0010\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0004\"\u000e\u0010\u0005\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\u0006\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000\"\u0010\u0010\u0007\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0004\"\u0010\u0010\b\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0004\"\u000e\u0010\t\u001a\u00020\nX\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\u000b\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000\"\u0010\u0010\f\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0004\"\u0016\u0010\r\u001a\u00020\u0003X\u0080\u0004¢\u0006\n\n\u0002\u0010\u0004\u001a\u0004\b\u000e\u0010\u000f\"\u0016\u0010\u0010\u001a\u00020\u0003X\u0080\u0004¢\u0006\n\n\u0002\u0010\u0004\u001a\u0004\b\u0011\u0010\u000f\"\u0016\u0010\u0012\u001a\u00020\u0003X\u0080\u0004¢\u0006\n\n\u0002\u0010\u0004\u001a\u0004\b\u0013\u0010\u000f\"\u0016\u0010\u0014\u001a\u00020\u0003X\u0080\u0004¢\u0006\n\n\u0002\u0010\u0004\u001a\u0004\b\u0015\u0010\u000f\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006J²\u0006\n\u0010K\u001a\u00020\u001bX\u008a\u0084\u0002²\u0006\n\u0010L\u001a\u00020\u001bX\u008a\u0084\u0002"}, d2 = {"IconLayoutIdTag", "", "IndicatorHorizontalPadding", "Landroidx/compose/ui/unit/Dp;", "F", "IndicatorLayoutIdTag", "IndicatorRippleLayoutIdTag", "IndicatorVerticalPaddingNoLabel", "IndicatorVerticalPaddingWithLabel", "ItemAnimationDurationMillis", "", "LabelLayoutIdTag", "NavigationRailHeaderPadding", "NavigationRailItemHeight", "getNavigationRailItemHeight", "()F", "NavigationRailItemVerticalPadding", "getNavigationRailItemVerticalPadding", "NavigationRailItemWidth", "getNavigationRailItemWidth", "NavigationRailVerticalPadding", "getNavigationRailVerticalPadding", "NavigationRail", "", "modifier", "Landroidx/compose/ui/Modifier;", "containerColor", "Landroidx/compose/ui/graphics/Color;", "contentColor", "header", "Lkotlin/Function1;", "Landroidx/compose/foundation/layout/ColumnScope;", "Landroidx/compose/runtime/Composable;", "Lkotlin/ExtensionFunctionType;", "windowInsets", "Landroidx/compose/foundation/layout/WindowInsets;", "content", "NavigationRail-qi6gXK8", "(Landroidx/compose/ui/Modifier;JJLkotlin/jvm/functions/Function3;Landroidx/compose/foundation/layout/WindowInsets;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "NavigationRailItem", "selected", "", "onClick", "Lkotlin/Function0;", NavigationRailKt.IconLayoutIdTag, "enabled", NavigationRailKt.LabelLayoutIdTag, "alwaysShowLabel", "colors", "Landroidx/compose/material3/NavigationRailItemColors;", "interactionSource", "Landroidx/compose/foundation/interaction/MutableInteractionSource;", "(ZLkotlin/jvm/functions/Function0;Lkotlin/jvm/functions/Function2;Landroidx/compose/ui/Modifier;ZLkotlin/jvm/functions/Function2;ZLandroidx/compose/material3/NavigationRailItemColors;Landroidx/compose/foundation/interaction/MutableInteractionSource;Landroidx/compose/runtime/Composer;II)V", "NavigationRailItemLayout", NavigationRailKt.IndicatorRippleLayoutIdTag, NavigationRailKt.IndicatorLayoutIdTag, "animationProgress", "", "(Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;ZLkotlin/jvm/functions/Function0;Landroidx/compose/runtime/Composer;I)V", "placeIcon", "Landroidx/compose/ui/layout/MeasureResult;", "Landroidx/compose/ui/layout/MeasureScope;", "iconPlaceable", "Landroidx/compose/ui/layout/Placeable;", "indicatorRipplePlaceable", "indicatorPlaceable", "constraints", "Landroidx/compose/ui/unit/Constraints;", "placeIcon-X9ElhV4", "(Landroidx/compose/ui/layout/MeasureScope;Landroidx/compose/ui/layout/Placeable;Landroidx/compose/ui/layout/Placeable;Landroidx/compose/ui/layout/Placeable;J)Landroidx/compose/ui/layout/MeasureResult;", "placeLabelAndIcon", "labelPlaceable", "placeLabelAndIcon-zUg2_y0", "(Landroidx/compose/ui/layout/MeasureScope;Landroidx/compose/ui/layout/Placeable;Landroidx/compose/ui/layout/Placeable;Landroidx/compose/ui/layout/Placeable;Landroidx/compose/ui/layout/Placeable;JZF)Landroidx/compose/ui/layout/MeasureResult;", "material3_release", "iconColor", "textColor"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class NavigationRailKt {
    private static final String IconLayoutIdTag = "icon";
    private static final float IndicatorHorizontalPadding;
    private static final String IndicatorLayoutIdTag = "indicator";
    private static final String IndicatorRippleLayoutIdTag = "indicatorRipple";
    private static final float IndicatorVerticalPaddingNoLabel;
    private static final float IndicatorVerticalPaddingWithLabel;
    private static final int ItemAnimationDurationMillis = 150;
    private static final String LabelLayoutIdTag = "label";
    private static final float NavigationRailItemVerticalPadding;
    private static final float NavigationRailVerticalPadding;
    private static final float NavigationRailHeaderPadding = Dp.constructor-impl(8);
    private static final float NavigationRailItemWidth = NavigationRailTokens.INSTANCE.m3696getContainerWidthD9Ej5fM();
    private static final float NavigationRailItemHeight = NavigationRailTokens.INSTANCE.m3699getNoLabelActiveIndicatorHeightD9Ej5fM();

    public static final void m2639NavigationRailqi6gXK8(Modifier modifier, long j, long j2, Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function3, WindowInsets windowInsets, final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function4, Composer composer, final int i, final int i2) {
        Modifier modifier2;
        int i3;
        long containerColor;
        long jM2173contentColorForek8zF_U;
        Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function5;
        WindowInsets windowInsets2;
        int i4;
        Modifier.Companion companion;
        final WindowInsets windowInsets3;
        final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function6;
        int i5;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i6;
        Composer composerStartRestartGroup = composer.startRestartGroup(118552648);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(NavigationRail)P(4,0:c#ui.graphics.Color,2:c#ui.graphics.Color,3,5)113@5242L14,114@5284L31,116@5431L12,123@5614L618,119@5501L731:NavigationRail.kt#uh7d8r");
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
            jM2173contentColorForek8zF_U = j2;
            i3 |= ((i2 & 4) == 0 && composerStartRestartGroup.changed(jM2173contentColorForek8zF_U)) ? Fields.RotationX : Fields.SpotShadowColor;
        } else {
            jM2173contentColorForek8zF_U = j2;
        }
        int i9 = i2 & 8;
        if (i9 == 0) {
            if ((i & 3072) == 0) {
                function5 = function3;
                i3 |= composerStartRestartGroup.changedInstance(function5) ? Fields.CameraDistance : Fields.RotationZ;
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
                if (composerStartRestartGroup.changedInstance(function4)) {
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
                        containerColor = NavigationRailDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i3 &= -113;
                    }
                    if ((i2 & 4) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 3) & 14);
                        i3 &= -897;
                    }
                    if (i9 != 0) {
                        function5 = null;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        windowInsets3 = NavigationRailDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                        function6 = function5;
                    }
                    long j3 = jM2173contentColorForek8zF_U;
                    i5 = i3;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(118552648, i5, -1, "androidx.compose.material3.NavigationRail (NavigationRail.kt:118)");
                    }
                    int i10 = (i5 & 14) | 12582912;
                    int i11 = i5 << 3;
                    int i12 = i10 | (i11 & 896) | (i11 & 7168);
                    WindowInsets windowInsets4 = windowInsets3;
                    SurfaceKt.m2868SurfaceT9BRK9s(companion, null, containerColor, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-2092683357, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i13) {
                            ComposerKt.sourceInformation(composer2, "C124@5624L602:NavigationRail.kt#uh7d8r");
                            if ((i13 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-2092683357, i13, -1, "androidx.compose.material3.NavigationRail.<anonymous> (NavigationRail.kt:124)");
                                }
                                Modifier modifierSelectableGroup = SelectableGroupKt.selectableGroup(PaddingKt.m1037paddingVpY3zN4$default(SizeKt.m1087widthInVpY3zN4$default(WindowInsetsPaddingKt.windowInsetsPadding(SizeKt.fillMaxHeight$default(Modifier.INSTANCE, 0.0f, 1, null), windowInsets3), NavigationRailTokens.INSTANCE.m3696getContainerWidthD9Ej5fM(), 0.0f, 2, null), 0.0f, NavigationRailKt.getNavigationRailVerticalPadding(), 1, null));
                                Alignment.Horizontal centerHorizontally = Alignment.INSTANCE.getCenterHorizontally();
                                Arrangement.HorizontalOrVertical horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(NavigationRailKt.getNavigationRailVerticalPadding());
                                Function3<ColumnScope, Composer, Integer, Unit> function7 = function6;
                                Function3<ColumnScope, Composer, Integer, Unit> function8 = function4;
                                ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(horizontalOrVerticalM911spacedBy0680j_4, centerHorizontally, composer2, 54);
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
                                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer2, 933375077, "C137@6207L9:NavigationRail.kt#uh7d8r");
                                composer2.startReplaceGroup(722845512);
                                ComposerKt.sourceInformation(composer2, "134@6103L8,135@6128L52");
                                if (function7 != null) {
                                    function7.invoke(columnScopeInstance, composer2, 6);
                                    SpacerKt.Spacer(SizeKt.m1066height3ABfNKs(Modifier.INSTANCE, NavigationRailKt.NavigationRailHeaderPadding), composer2, 6);
                                }
                                composer2.endReplaceGroup();
                                function8.invoke(columnScopeInstance, composer2, 6);
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
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, i12, 114);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    windowInsets2 = windowInsets4;
                    jM2173contentColorForek8zF_U = j3;
                }
                function6 = function5;
                windowInsets3 = windowInsets2;
                long j4 = jM2173contentColorForek8zF_U;
                i5 = i3;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(118552648, i5, -1, "androidx.compose.material3.NavigationRail (NavigationRail.kt:118)");
                }
                int i13 = (i5 & 14) | 12582912;
                int i14 = i5 << 3;
                int i15 = i13 | (i14 & 896) | (i14 & 7168);
                WindowInsets windowInsets5 = windowInsets3;
                SurfaceKt.m2868SurfaceT9BRK9s(companion, null, containerColor, j4, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-2092683357, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i16) {
                        ComposerKt.sourceInformation(composer2, "C124@5624L602:NavigationRail.kt#uh7d8r");
                        if ((i16 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-2092683357, i16, -1, "androidx.compose.material3.NavigationRail.<anonymous> (NavigationRail.kt:124)");
                            }
                            Modifier modifierSelectableGroup = SelectableGroupKt.selectableGroup(PaddingKt.m1037paddingVpY3zN4$default(SizeKt.m1087widthInVpY3zN4$default(WindowInsetsPaddingKt.windowInsetsPadding(SizeKt.fillMaxHeight$default(Modifier.INSTANCE, 0.0f, 1, null), windowInsets3), NavigationRailTokens.INSTANCE.m3696getContainerWidthD9Ej5fM(), 0.0f, 2, null), 0.0f, NavigationRailKt.getNavigationRailVerticalPadding(), 1, null));
                            Alignment.Horizontal centerHorizontally = Alignment.INSTANCE.getCenterHorizontally();
                            Arrangement.HorizontalOrVertical horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(NavigationRailKt.getNavigationRailVerticalPadding());
                            Function3<ColumnScope, Composer, Integer, Unit> function7 = function6;
                            Function3<ColumnScope, Composer, Integer, Unit> function8 = function4;
                            ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                            MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(horizontalOrVerticalM911spacedBy0680j_4, centerHorizontally, composer2, 54);
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
                            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                            ComposerKt.sourceInformationMarkerStart(composer2, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                            ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                            ComposerKt.sourceInformationMarkerStart(composer2, 933375077, "C137@6207L9:NavigationRail.kt#uh7d8r");
                            composer2.startReplaceGroup(722845512);
                            ComposerKt.sourceInformation(composer2, "134@6103L8,135@6128L52");
                            if (function7 != null) {
                                function7.invoke(columnScopeInstance, composer2, 6);
                                SpacerKt.Spacer(SizeKt.m1066height3ABfNKs(Modifier.INSTANCE, NavigationRailKt.NavigationRailHeaderPadding), composer2, 6);
                            }
                            composer2.endReplaceGroup();
                            function8.invoke(columnScopeInstance, composer2, 6);
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
                }, composerStartRestartGroup, 54), composerStartRestartGroup, i15, 114);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                windowInsets2 = windowInsets5;
                jM2173contentColorForek8zF_U = j4;
            } else {
                composerStartRestartGroup.skipToGroupEnd();
                companion = modifier2;
                function6 = function5;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier3 = companion;
                final long j5 = containerColor;
                final long j6 = jM2173contentColorForek8zF_U;
                final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function7 = function6;
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
                        NavigationRailKt.m2639NavigationRailqi6gXK8(modifier3, j5, j6, function7, windowInsets6, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        function5 = function3;
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
            if (composerStartRestartGroup.changedInstance(function4)) {
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
                    containerColor = NavigationRailDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    i3 &= -113;
                }
                if ((i2 & 4) != 0) {
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 3) & 14);
                    i3 &= -897;
                }
                if (i9 != 0) {
                    function5 = null;
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    windowInsets3 = NavigationRailDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                    function6 = function5;
                } else {
                    function6 = function5;
                    windowInsets3 = windowInsets2;
                }
            } else {
                if (i7 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 2) != 0) {
                    containerColor = NavigationRailDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    i3 &= -113;
                }
                if ((i2 & 4) != 0) {
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 3) & 14);
                    i3 &= -897;
                }
                if (i9 != 0) {
                    function5 = null;
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    windowInsets3 = NavigationRailDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                    function6 = function5;
                } else {
                    function6 = function5;
                    windowInsets3 = windowInsets2;
                }
            }
            long j7 = jM2173contentColorForek8zF_U;
            i5 = i3;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(118552648, i5, -1, "androidx.compose.material3.NavigationRail (NavigationRail.kt:118)");
            }
            int i16 = (i5 & 14) | 12582912;
            int i17 = i5 << 3;
            int i18 = i16 | (i17 & 896) | (i17 & 7168);
            WindowInsets windowInsets7 = windowInsets3;
            SurfaceKt.m2868SurfaceT9BRK9s(companion, null, containerColor, j7, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-2092683357, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i19) {
                    ComposerKt.sourceInformation(composer2, "C124@5624L602:NavigationRail.kt#uh7d8r");
                    if ((i19 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-2092683357, i19, -1, "androidx.compose.material3.NavigationRail.<anonymous> (NavigationRail.kt:124)");
                        }
                        Modifier modifierSelectableGroup = SelectableGroupKt.selectableGroup(PaddingKt.m1037paddingVpY3zN4$default(SizeKt.m1087widthInVpY3zN4$default(WindowInsetsPaddingKt.windowInsetsPadding(SizeKt.fillMaxHeight$default(Modifier.INSTANCE, 0.0f, 1, null), windowInsets3), NavigationRailTokens.INSTANCE.m3696getContainerWidthD9Ej5fM(), 0.0f, 2, null), 0.0f, NavigationRailKt.getNavigationRailVerticalPadding(), 1, null));
                        Alignment.Horizontal centerHorizontally = Alignment.INSTANCE.getCenterHorizontally();
                        Arrangement.HorizontalOrVertical horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(NavigationRailKt.getNavigationRailVerticalPadding());
                        Function3<ColumnScope, Composer, Integer, Unit> function8 = function6;
                        Function3<ColumnScope, Composer, Integer, Unit> function9 = function4;
                        ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                        MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(horizontalOrVerticalM911spacedBy0680j_4, centerHorizontally, composer2, 54);
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
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                        ComposerKt.sourceInformationMarkerStart(composer2, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                        ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composer2, 933375077, "C137@6207L9:NavigationRail.kt#uh7d8r");
                        composer2.startReplaceGroup(722845512);
                        ComposerKt.sourceInformation(composer2, "134@6103L8,135@6128L52");
                        if (function8 != null) {
                            function8.invoke(columnScopeInstance, composer2, 6);
                            SpacerKt.Spacer(SizeKt.m1066height3ABfNKs(Modifier.INSTANCE, NavigationRailKt.NavigationRailHeaderPadding), composer2, 6);
                        }
                        composer2.endReplaceGroup();
                        function9.invoke(columnScopeInstance, composer2, 6);
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
            }, composerStartRestartGroup, 54), composerStartRestartGroup, i18, 114);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            windowInsets2 = windowInsets7;
            jM2173contentColorForek8zF_U = j7;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) == 0) {
                if (i7 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 2) != 0) {
                    containerColor = NavigationRailDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    i3 &= -113;
                }
                if ((i2 & 4) != 0) {
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 3) & 14);
                    i3 &= -897;
                }
                if (i9 != 0) {
                    function5 = null;
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    windowInsets3 = NavigationRailDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                    function6 = function5;
                } else {
                    function6 = function5;
                    windowInsets3 = windowInsets2;
                }
            } else {
                if (i7 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 2) != 0) {
                    containerColor = NavigationRailDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    i3 &= -113;
                }
                if ((i2 & 4) != 0) {
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 3) & 14);
                    i3 &= -897;
                }
                if (i9 != 0) {
                    function5 = null;
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    windowInsets3 = NavigationRailDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                    function6 = function5;
                } else {
                    function6 = function5;
                    windowInsets3 = windowInsets2;
                }
            }
            long j8 = jM2173contentColorForek8zF_U;
            i5 = i3;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(118552648, i5, -1, "androidx.compose.material3.NavigationRail (NavigationRail.kt:118)");
            }
            int i19 = (i5 & 14) | 12582912;
            int i110 = i5 << 3;
            int i111 = i19 | (i110 & 896) | (i110 & 7168);
            WindowInsets windowInsets8 = windowInsets3;
            SurfaceKt.m2868SurfaceT9BRK9s(companion, null, containerColor, j8, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-2092683357, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i112) {
                    ComposerKt.sourceInformation(composer2, "C124@5624L602:NavigationRail.kt#uh7d8r");
                    if ((i112 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-2092683357, i112, -1, "androidx.compose.material3.NavigationRail.<anonymous> (NavigationRail.kt:124)");
                        }
                        Modifier modifierSelectableGroup = SelectableGroupKt.selectableGroup(PaddingKt.m1037paddingVpY3zN4$default(SizeKt.m1087widthInVpY3zN4$default(WindowInsetsPaddingKt.windowInsetsPadding(SizeKt.fillMaxHeight$default(Modifier.INSTANCE, 0.0f, 1, null), windowInsets3), NavigationRailTokens.INSTANCE.m3696getContainerWidthD9Ej5fM(), 0.0f, 2, null), 0.0f, NavigationRailKt.getNavigationRailVerticalPadding(), 1, null));
                        Alignment.Horizontal centerHorizontally = Alignment.INSTANCE.getCenterHorizontally();
                        Arrangement.HorizontalOrVertical horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(NavigationRailKt.getNavigationRailVerticalPadding());
                        Function3<ColumnScope, Composer, Integer, Unit> function8 = function6;
                        Function3<ColumnScope, Composer, Integer, Unit> function9 = function4;
                        ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                        MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(horizontalOrVerticalM911spacedBy0680j_4, centerHorizontally, composer2, 54);
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
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                        ComposerKt.sourceInformationMarkerStart(composer2, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                        ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composer2, 933375077, "C137@6207L9:NavigationRail.kt#uh7d8r");
                        composer2.startReplaceGroup(722845512);
                        ComposerKt.sourceInformation(composer2, "134@6103L8,135@6128L52");
                        if (function8 != null) {
                            function8.invoke(columnScopeInstance, composer2, 6);
                            SpacerKt.Spacer(SizeKt.m1066height3ABfNKs(Modifier.INSTANCE, NavigationRailKt.NavigationRailHeaderPadding), composer2, 6);
                        }
                        composer2.endReplaceGroup();
                        function9.invoke(columnScopeInstance, composer2, 6);
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
            }, composerStartRestartGroup, 54), composerStartRestartGroup, i111, 114);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            windowInsets2 = windowInsets8;
            jM2173contentColorForek8zF_U = j8;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier4 = companion;
            final long j9 = containerColor;
            final long j10 = jM2173contentColorForek8zF_U;
            final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function8 = function6;
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
                    NavigationRailKt.m2639NavigationRailqi6gXK8(modifier4, j9, j10, function8, windowInsets9, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void NavigationRailItem(final boolean z, final Function0<Unit> function0, final Function2<? super Composer, ? super Integer, Unit> function2, Modifier modifier, boolean z2, Function2<? super Composer, ? super Integer, Unit> function3, boolean z3, NavigationRailItemColors navigationRailItemColors, MutableInteractionSource mutableInteractionSource, Composer composer, final int i, final int i2) {
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
        final Function2<? super Composer, ? super Integer, Unit> function5;
        final NavigationRailItemColors navigationRailItemColorsColors;
        MutableInteractionSource mutableInteractionSource2;
        final boolean z6;
        MutableInteractionSource mutableInteractionSource3;
        ComposableLambda composableLambdaRememberComposableLambda;
        Function2<? super Composer, ? super Integer, Unit> function6;
        int currentCompositeKeyHash;
        Function0<ComposeUiNode> constructor;
        MutableInteractionSource mutableInteractionSource4;
        Composer composerM4037constructorimpl;
        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash;
        float f;
        final State<Float> stateAnimateFloatAsState;
        long jOffset;
        boolean zChanged;
        Object objRememberedValue;
        final Shape value;
        boolean zChanged2;
        Object objRememberedValue2;
        final Modifier modifier2;
        final Function2<? super Composer, ? super Integer, Unit> function7;
        final boolean z7;
        final NavigationRailItemColors navigationRailItemColors2;
        final boolean z8;
        final MutableInteractionSource mutableInteractionSource5;
        Object objRememberedValue3;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1533971045);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(NavigationRailItem)P(8,7,3,6,2,5)179@8055L8,185@8288L633,215@9569L2776:NavigationRail.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(z) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        if ((i2 & 2) != 0) {
            i3 |= 48;
        } else if ((i & 48) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function0) ? 32 : 16;
        }
        if ((i2 & 4) != 0) {
            i3 |= 384;
        } else if ((i & 384) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function2) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        int i12 = i2 & 8;
        if (i12 == 0) {
            if ((i & 3072) == 0) {
                i3 |= composerStartRestartGroup.changed(modifier) ? Fields.CameraDistance : Fields.RotationZ;
            }
            i4 = i2 & 16;
            if (i4 != 0) {
                if ((i & 24576) == 0) {
                    if (composerStartRestartGroup.changed(z2)) {
                        i5 = Fields.Clip;
                    } else {
                        i5 = Fields.Shape;
                    }
                    i3 |= i5;
                }
                i6 = i2 & 32;
                if (i6 != 0) {
                    if ((196608 & i) == 0) {
                        function4 = function3;
                        if (composerStartRestartGroup.changedInstance(function4)) {
                            i7 = Fields.RenderEffect;
                        } else {
                            i7 = 65536;
                        }
                        i3 |= i7;
                    }
                    i8 = i2 & 64;
                    if (i8 != 0) {
                        i3 |= 1572864;
                        z4 = z3;
                    } else {
                        z4 = z3;
                        if ((i & 1572864) == 0) {
                            if (composerStartRestartGroup.changed(z4)) {
                                i9 = 1048576;
                            } else {
                                i9 = 524288;
                            }
                            i3 |= i9;
                        }
                    }
                    if ((i & 12582912) != 0) {
                        i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(navigationRailItemColors)) ? 4194304 : 8388608;
                    }
                    i10 = i2 & Fields.RotationX;
                    if (i10 != 0) {
                        i3 |= 100663296;
                    } else if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                            i11 = 67108864;
                        } else {
                            i11 = 33554432;
                        }
                        i3 |= i11;
                    }
                    if ((i3 & 38347923) == 38347922 || !composerStartRestartGroup.getSkipping()) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                            if (i12 != 0) {
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
                                navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                navigationRailItemColorsColors = navigationRailItemColors;
                            }
                            if (i10 != 0) {
                                mutableInteractionSource2 = null;
                            } else {
                                mutableInteractionSource2 = mutableInteractionSource;
                            }
                            z6 = z5;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                i3 &= -29360129;
                            }
                            companion = modifier;
                            function5 = function3;
                            navigationRailItemColorsColors = navigationRailItemColors;
                            mutableInteractionSource2 = mutableInteractionSource;
                            i3 = i3;
                            z4 = z4;
                            z6 = z2;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1533971045, i3, -1, "androidx.compose.material3.NavigationRailItem (NavigationRail.kt:181)");
                        }
                        composerStartRestartGroup.startReplaceGroup(-782588008);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "183@8207L39");
                        if (mutableInteractionSource2 == null) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -782587357, "CC(remember):NavigationRail.kt#9igjgp");
                            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue3 = InteractionSourceKt.MutableInteractionSource();
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue3;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        final NavigationRailItemColors navigationRailItemColors3 = navigationRailItemColorsColors;
                        final boolean z9 = z6;
                        final Function2<? super Composer, ? super Integer, Unit> function8 = function5;
                        final boolean z10 = z4;
                        int i13 = i3;
                        ComposableLambda composableLambdaRememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-1023357515, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i14) {
                                ComposerKt.sourceInformation(composer2, "C187@8335L201,193@8718L193:NavigationRail.kt#uh7d8r");
                                if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1023357515, i14, -1, "androidx.compose.material3.NavigationRailItem.<anonymous> (NavigationRail.kt:186)");
                                    }
                                    State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColors3.m2635iconColorWaAFU9c$material3_release(z, z9), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12);
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
                                    ComposerKt.sourceInformationMarkerStart(composer2, -296474437, "C194@8819L78:NavigationRail.kt#uh7d8r");
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
                        composerStartRestartGroup.startReplaceGroup(-782561860);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9017L536");
                        if (function5 == null) {
                            composableLambdaRememberComposableLambda = null;
                        } else {
                            composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-105269599, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i14) {
                                    ComposerKt.sourceInformation(composer2, "C201@9082L5,203@9141L213,207@9371L168:NavigationRail.kt#uh7d8r");
                                    if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-105269599, i14, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:201)");
                                        }
                                        ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColorsColors.m2636textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationRailTokens.INSTANCE.getLabelTextFont(), composer2, 6), function5, composer2, 0);
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
                        function6 = function5;
                        Modifier modifierM1065defaultMinSizeVpY3zN4$default = SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationRailItemHeight, 1, null);
                        float f2 = NavigationRailItemWidth;
                        Modifier modifierM1087widthInVpY3zN4$default = SizeKt.m1087widthInVpY3zN4$default(modifierM1065defaultMinSizeVpY3zN4$default, f2, 0.0f, 2, null);
                        Alignment center = Alignment.INSTANCE.getCenter();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(center, true);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM1087widthInVpY3zN4$default);
                        Modifier modifier3 = companion;
                        constructor = ComposeUiNode.INSTANCE.getConstructor();
                        mutableInteractionSource4 = mutableInteractionSource3;
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
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 584386773, "C231@10130L157,*240@10571L7,246@10874L128,260@11450L261,268@11760L280,282@12301L27,276@12050L289:NavigationRail.kt#uh7d8r");
                        if (z) {
                            f = 1.0f;
                        } else {
                            f = 0.0f;
                        }
                        final NavigationRailItemColors navigationRailItemColors4 = navigationRailItemColorsColors;
                        stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(150, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
                        ProvidableCompositionLocal<Density> localDensity = CompositionLocalsKt.getLocalDensity();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume = composerStartRestartGroup.consume(localDensity);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Density density = (Density) objConsume;
                        jOffset = OffsetKt.Offset((density.roundToPx-0680j_4(f2) - density.roundToPx-0680j_4(NavigationRailTokens.INSTANCE.m3694getActiveIndicatorWidthD9Ej5fM())) / 2, 0.0f);
                        Unit unit = Unit.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119672869, "CC(remember):NavigationRail.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        final MappedInteractionSource mappedInteractionSource = (MappedInteractionSource) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        if (function6 != null) {
                            composerStartRestartGroup.startReplaceGroup(585295320);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "252@11124L5");
                            value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getActiveIndicatorShape(), composerStartRestartGroup, 6);
                            composerStartRestartGroup.endReplaceGroup();
                        } else {
                            composerStartRestartGroup.startReplaceGroup(585379857);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "254@11216L5");
                            value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getNoLabelActiveIndicatorShape(), composerStartRestartGroup, 6);
                            composerStartRestartGroup.endReplaceGroup();
                        }
                        ComposableLambda composableLambdaRememberComposableLambda3 = ComposableLambdaKt.rememberComposableLambda(211026382, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i14) {
                                ComposerKt.sourceInformation(composer2, "C264@11646L32,261@11468L229:NavigationRail.kt#uh7d8r");
                                if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(211026382, i14, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:261)");
                                    }
                                    BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), value), mappedInteractionSource, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        ComposableLambda composableLambdaRememberComposableLambda4 = ComposableLambdaKt.rememberComposableLambda(-1862011490, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i14) {
                                ComposerKt.sourceInformation(composer2, "C271@11882L35,269@11778L248:NavigationRail.kt#uh7d8r");
                                if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1862011490, i14, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:269)");
                                    }
                                    Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                                    ComposerKt.sourceInformationMarkerStart(composer2, -425107715, "CC(remember):NavigationRail.kt#9igjgp");
                                    boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                                    final State<Float> state = stateAnimateFloatAsState;
                                    Object objRememberedValue4 = composer2.rememberedValue();
                                    if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue4 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
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
                                        composer2.updateRememberedValue(objRememberedValue4);
                                    }
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue4), navigationRailItemColors4.getSelectedIndicatorColor(), value), composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119627306, "CC(remember):NavigationRail.kt#9igjgp");
                        zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged2 || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue2 = (Function0) new Function0<Float>() {
                                {
                                    super(0);
                                }

                                public final Float m2644invoke() {
                                    return stateAnimateFloatAsState.getValue();
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        NavigationRailItemLayout(composableLambdaRememberComposableLambda3, composableLambdaRememberComposableLambda4, composableLambdaRememberComposableLambda2, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue2, composerStartRestartGroup, (57344 & (i13 >> 6)) | 438);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = modifier3;
                        function7 = function6;
                        z7 = z6;
                        navigationRailItemColors2 = navigationRailItemColors4;
                        z8 = z4;
                        mutableInteractionSource5 = mutableInteractionSource2;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        modifier2 = modifier;
                        z7 = z2;
                        mutableInteractionSource5 = mutableInteractionSource;
                        function7 = function4;
                        z8 = z4;
                        navigationRailItemColors2 = navigationRailItemColors;
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

                            public final void invoke(Composer composer2, int i14) {
                                NavigationRailKt.NavigationRailItem(z, function0, function2, modifier2, z7, function7, z8, navigationRailItemColors2, mutableInteractionSource5, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                function4 = function3;
                i8 = i2 & 64;
                if (i8 != 0) {
                    i3 |= 1572864;
                    z4 = z3;
                } else {
                    z4 = z3;
                    if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(z4)) {
                            i9 = 1048576;
                        } else {
                            i9 = 524288;
                        }
                        i3 |= i9;
                    }
                }
                if ((i & 12582912) != 0) {
                    i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(navigationRailItemColors)) ? 4194304 : 8388608;
                }
                i10 = i2 & Fields.RotationX;
                if (i10 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                        i11 = 67108864;
                    } else {
                        i11 = 33554432;
                    }
                    i3 |= i11;
                }
                if ((i3 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
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
                            navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            navigationRailItemColorsColors = navigationRailItemColors;
                        }
                        if (i10 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                        z6 = z5;
                    } else {
                        if (i12 != 0) {
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
                            navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            navigationRailItemColorsColors = navigationRailItemColors;
                        }
                        if (i10 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                        z6 = z5;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1533971045, i3, -1, "androidx.compose.material3.NavigationRailItem (NavigationRail.kt:181)");
                    }
                    composerStartRestartGroup.startReplaceGroup(-782588008);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "183@8207L39");
                    if (mutableInteractionSource2 == null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -782587357, "CC(remember):NavigationRail.kt#9igjgp");
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = InteractionSourceKt.MutableInteractionSource();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue3;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    final NavigationRailItemColors navigationRailItemColors5 = navigationRailItemColorsColors;
                    final boolean z11 = z6;
                    final Function2<? super Composer, ? super Integer, Unit> function9 = function5;
                    final boolean z12 = z4;
                    int i14 = i3;
                    ComposableLambda composableLambdaRememberComposableLambda5 = ComposableLambdaKt.rememberComposableLambda(-1023357515, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i15) {
                            ComposerKt.sourceInformation(composer2, "C187@8335L201,193@8718L193:NavigationRail.kt#uh7d8r");
                            if ((i15 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1023357515, i15, -1, "androidx.compose.material3.NavigationRailItem.<anonymous> (NavigationRail.kt:186)");
                                }
                                State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColors5.m2635iconColorWaAFU9c$material3_release(z, z11), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12);
                                Modifier.Companion companionClearAndSetSemantics = (function9 == null || !(z12 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((SemanticsPropertyReceiver) obj);
                                        return Unit.INSTANCE;
                                    }
                                });
                                Function2<Composer, Integer, Unit> function10 = function2;
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
                                ComposerKt.sourceInformationMarkerStart(composer2, -296474437, "C194@8819L78:NavigationRail.kt#uh7d8r");
                                CompositionLocalKt.CompositionLocalProvider(ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(invoke$lambda$0(stateM387animateColorAsStateeuL9pac))), function10, composer2, ProvidedValue.$stable);
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
                    composerStartRestartGroup.startReplaceGroup(-782561860);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9017L536");
                    if (function5 == null) {
                        composableLambdaRememberComposableLambda = null;
                    } else {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-105269599, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i15) {
                                ComposerKt.sourceInformation(composer2, "C201@9082L5,203@9141L213,207@9371L168:NavigationRail.kt#uh7d8r");
                                if ((i15 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-105269599, i15, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:201)");
                                    }
                                    ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColorsColors.m2636textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationRailTokens.INSTANCE.getLabelTextFont(), composer2, 6), function5, composer2, 0);
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
                    function6 = function5;
                    Modifier modifierM1065defaultMinSizeVpY3zN4$default2 = SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationRailItemHeight, 1, null);
                    float f3 = NavigationRailItemWidth;
                    Modifier modifierM1087widthInVpY3zN4$default2 = SizeKt.m1087widthInVpY3zN4$default(modifierM1065defaultMinSizeVpY3zN4$default2, f3, 0.0f, 2, null);
                    Alignment center2 = Alignment.INSTANCE.getCenter();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(center2, true);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap2 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM1087widthInVpY3zN4$default2);
                    Modifier modifier4 = companion;
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    mutableInteractionSource4 = mutableInteractionSource3;
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 584386773, "C231@10130L157,*240@10571L7,246@10874L128,260@11450L261,268@11760L280,282@12301L27,276@12050L289:NavigationRail.kt#uh7d8r");
                    if (z) {
                        f = 1.0f;
                    } else {
                        f = 0.0f;
                    }
                    final NavigationRailItemColors navigationRailItemColors6 = navigationRailItemColorsColors;
                    stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(150, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
                    ProvidableCompositionLocal<Density> localDensity2 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume2 = composerStartRestartGroup.consume(localDensity2);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Density density2 = (Density) objConsume2;
                    jOffset = OffsetKt.Offset((density2.roundToPx-0680j_4(f3) - density2.roundToPx-0680j_4(NavigationRailTokens.INSTANCE.m3694getActiveIndicatorWidthD9Ej5fM())) / 2, 0.0f);
                    Unit unit2 = Unit.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119672869, "CC(remember):NavigationRail.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    final MappedInteractionSource mappedInteractionSource2 = (MappedInteractionSource) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (function6 != null) {
                        composerStartRestartGroup.startReplaceGroup(585295320);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "252@11124L5");
                        value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getActiveIndicatorShape(), composerStartRestartGroup, 6);
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(585379857);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "254@11216L5");
                        value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getNoLabelActiveIndicatorShape(), composerStartRestartGroup, 6);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    ComposableLambda composableLambdaRememberComposableLambda6 = ComposableLambdaKt.rememberComposableLambda(211026382, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i15) {
                            ComposerKt.sourceInformation(composer2, "C264@11646L32,261@11468L229:NavigationRail.kt#uh7d8r");
                            if ((i15 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(211026382, i15, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:261)");
                                }
                                BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), value), mappedInteractionSource2, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    ComposableLambda composableLambdaRememberComposableLambda7 = ComposableLambdaKt.rememberComposableLambda(-1862011490, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i15) {
                            ComposerKt.sourceInformation(composer2, "C271@11882L35,269@11778L248:NavigationRail.kt#uh7d8r");
                            if ((i15 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1862011490, i15, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:269)");
                                }
                                Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                                ComposerKt.sourceInformationMarkerStart(composer2, -425107715, "CC(remember):NavigationRail.kt#9igjgp");
                                boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                                final State<Float> state = stateAnimateFloatAsState;
                                Object objRememberedValue4 = composer2.rememberedValue();
                                if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue4 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
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
                                    composer2.updateRememberedValue(objRememberedValue4);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue4), navigationRailItemColors6.getSelectedIndicatorColor(), value), composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119627306, "CC(remember):NavigationRail.kt#9igjgp");
                    zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged2) {
                        objRememberedValue2 = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2644invoke() {
                                return stateAnimateFloatAsState.getValue();
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2644invoke() {
                                return stateAnimateFloatAsState.getValue();
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    NavigationRailItemLayout(composableLambdaRememberComposableLambda6, composableLambdaRememberComposableLambda7, composableLambdaRememberComposableLambda5, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue2, composerStartRestartGroup, (57344 & (i14 >> 6)) | 438);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier4;
                    function7 = function6;
                    z7 = z6;
                    navigationRailItemColors2 = navigationRailItemColors6;
                    z8 = z4;
                    mutableInteractionSource5 = mutableInteractionSource2;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
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
                            navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            navigationRailItemColorsColors = navigationRailItemColors;
                        }
                        if (i10 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                        z6 = z5;
                    } else {
                        if (i12 != 0) {
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
                            navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            navigationRailItemColorsColors = navigationRailItemColors;
                        }
                        if (i10 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                        z6 = z5;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1533971045, i3, -1, "androidx.compose.material3.NavigationRailItem (NavigationRail.kt:181)");
                    }
                    composerStartRestartGroup.startReplaceGroup(-782588008);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "183@8207L39");
                    if (mutableInteractionSource2 == null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -782587357, "CC(remember):NavigationRail.kt#9igjgp");
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = InteractionSourceKt.MutableInteractionSource();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue3;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    final NavigationRailItemColors navigationRailItemColors7 = navigationRailItemColorsColors;
                    final boolean z13 = z6;
                    final Function2<? super Composer, ? super Integer, Unit> function10 = function5;
                    final boolean z14 = z4;
                    int i15 = i3;
                    ComposableLambda composableLambdaRememberComposableLambda8 = ComposableLambdaKt.rememberComposableLambda(-1023357515, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i16) {
                            ComposerKt.sourceInformation(composer2, "C187@8335L201,193@8718L193:NavigationRail.kt#uh7d8r");
                            if ((i16 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1023357515, i16, -1, "androidx.compose.material3.NavigationRailItem.<anonymous> (NavigationRail.kt:186)");
                                }
                                State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColors7.m2635iconColorWaAFU9c$material3_release(z, z13), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12);
                                Modifier.Companion companionClearAndSetSemantics = (function10 == null || !(z14 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((SemanticsPropertyReceiver) obj);
                                        return Unit.INSTANCE;
                                    }
                                });
                                Function2<Composer, Integer, Unit> function11 = function2;
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
                                ComposerKt.sourceInformationMarkerStart(composer2, -296474437, "C194@8819L78:NavigationRail.kt#uh7d8r");
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
                    composerStartRestartGroup.startReplaceGroup(-782561860);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9017L536");
                    if (function5 == null) {
                        composableLambdaRememberComposableLambda = null;
                    } else {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-105269599, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i16) {
                                ComposerKt.sourceInformation(composer2, "C201@9082L5,203@9141L213,207@9371L168:NavigationRail.kt#uh7d8r");
                                if ((i16 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-105269599, i16, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:201)");
                                    }
                                    ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColorsColors.m2636textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationRailTokens.INSTANCE.getLabelTextFont(), composer2, 6), function5, composer2, 0);
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
                    function6 = function5;
                    Modifier modifierM1065defaultMinSizeVpY3zN4$default3 = SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationRailItemHeight, 1, null);
                    float f4 = NavigationRailItemWidth;
                    Modifier modifierM1087widthInVpY3zN4$default3 = SizeKt.m1087widthInVpY3zN4$default(modifierM1065defaultMinSizeVpY3zN4$default3, f4, 0.0f, 2, null);
                    Alignment center3 = Alignment.INSTANCE.getCenter();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy3 = BoxKt.maybeCachedBoxMeasurePolicy(center3, true);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap3 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM1087widthInVpY3zN4$default3);
                    Modifier modifier5 = companion;
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    mutableInteractionSource4 = mutableInteractionSource3;
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 584386773, "C231@10130L157,*240@10571L7,246@10874L128,260@11450L261,268@11760L280,282@12301L27,276@12050L289:NavigationRail.kt#uh7d8r");
                    if (z) {
                        f = 1.0f;
                    } else {
                        f = 0.0f;
                    }
                    final NavigationRailItemColors navigationRailItemColors8 = navigationRailItemColorsColors;
                    stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(150, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
                    ProvidableCompositionLocal<Density> localDensity3 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume3 = composerStartRestartGroup.consume(localDensity3);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Density density3 = (Density) objConsume3;
                    jOffset = OffsetKt.Offset((density3.roundToPx-0680j_4(f4) - density3.roundToPx-0680j_4(NavigationRailTokens.INSTANCE.m3694getActiveIndicatorWidthD9Ej5fM())) / 2, 0.0f);
                    Unit unit3 = Unit.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119672869, "CC(remember):NavigationRail.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    final MappedInteractionSource mappedInteractionSource3 = (MappedInteractionSource) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (function6 != null) {
                        composerStartRestartGroup.startReplaceGroup(585295320);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "252@11124L5");
                        value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getActiveIndicatorShape(), composerStartRestartGroup, 6);
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(585379857);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "254@11216L5");
                        value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getNoLabelActiveIndicatorShape(), composerStartRestartGroup, 6);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    ComposableLambda composableLambdaRememberComposableLambda9 = ComposableLambdaKt.rememberComposableLambda(211026382, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i16) {
                            ComposerKt.sourceInformation(composer2, "C264@11646L32,261@11468L229:NavigationRail.kt#uh7d8r");
                            if ((i16 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(211026382, i16, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:261)");
                                }
                                BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), value), mappedInteractionSource3, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    ComposableLambda composableLambdaRememberComposableLambda10 = ComposableLambdaKt.rememberComposableLambda(-1862011490, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i16) {
                            ComposerKt.sourceInformation(composer2, "C271@11882L35,269@11778L248:NavigationRail.kt#uh7d8r");
                            if ((i16 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1862011490, i16, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:269)");
                                }
                                Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                                ComposerKt.sourceInformationMarkerStart(composer2, -425107715, "CC(remember):NavigationRail.kt#9igjgp");
                                boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                                final State<Float> state = stateAnimateFloatAsState;
                                Object objRememberedValue4 = composer2.rememberedValue();
                                if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue4 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
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
                                    composer2.updateRememberedValue(objRememberedValue4);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue4), navigationRailItemColors8.getSelectedIndicatorColor(), value), composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119627306, "CC(remember):NavigationRail.kt#9igjgp");
                    zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged2) {
                        objRememberedValue2 = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2644invoke() {
                                return stateAnimateFloatAsState.getValue();
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2644invoke() {
                                return stateAnimateFloatAsState.getValue();
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    NavigationRailItemLayout(composableLambdaRememberComposableLambda9, composableLambdaRememberComposableLambda10, composableLambdaRememberComposableLambda8, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue2, composerStartRestartGroup, (57344 & (i15 >> 6)) | 438);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier5;
                    function7 = function6;
                    z7 = z6;
                    navigationRailItemColors2 = navigationRailItemColors8;
                    z8 = z4;
                    mutableInteractionSource5 = mutableInteractionSource2;
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

                        public final void invoke(Composer composer2, int i16) {
                            NavigationRailKt.NavigationRailItem(z, function0, function2, modifier2, z7, function7, z8, navigationRailItemColors2, mutableInteractionSource5, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            i6 = i2 & 32;
            if (i6 != 0) {
                if ((196608 & i) == 0) {
                    function4 = function3;
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i7 = Fields.RenderEffect;
                    } else {
                        i7 = 65536;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 64;
                if (i8 != 0) {
                    i3 |= 1572864;
                    z4 = z3;
                } else {
                    z4 = z3;
                    if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(z4)) {
                            i9 = 1048576;
                        } else {
                            i9 = 524288;
                        }
                        i3 |= i9;
                    }
                }
                if ((i & 12582912) != 0) {
                    i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(navigationRailItemColors)) ? 4194304 : 8388608;
                }
                i10 = i2 & Fields.RotationX;
                if (i10 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                        i11 = 67108864;
                    } else {
                        i11 = 33554432;
                    }
                    i3 |= i11;
                }
                if ((i3 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
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
                            navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            navigationRailItemColorsColors = navigationRailItemColors;
                        }
                        if (i10 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                        z6 = z5;
                    } else {
                        if (i12 != 0) {
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
                            navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            navigationRailItemColorsColors = navigationRailItemColors;
                        }
                        if (i10 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                        z6 = z5;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1533971045, i3, -1, "androidx.compose.material3.NavigationRailItem (NavigationRail.kt:181)");
                    }
                    composerStartRestartGroup.startReplaceGroup(-782588008);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "183@8207L39");
                    if (mutableInteractionSource2 == null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -782587357, "CC(remember):NavigationRail.kt#9igjgp");
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = InteractionSourceKt.MutableInteractionSource();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue3;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    final NavigationRailItemColors navigationRailItemColors9 = navigationRailItemColorsColors;
                    final boolean z15 = z6;
                    final Function2<? super Composer, ? super Integer, Unit> function11 = function5;
                    final boolean z16 = z4;
                    int i16 = i3;
                    ComposableLambda composableLambdaRememberComposableLambda11 = ComposableLambdaKt.rememberComposableLambda(-1023357515, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i17) {
                            ComposerKt.sourceInformation(composer2, "C187@8335L201,193@8718L193:NavigationRail.kt#uh7d8r");
                            if ((i17 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1023357515, i17, -1, "androidx.compose.material3.NavigationRailItem.<anonymous> (NavigationRail.kt:186)");
                                }
                                State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColors9.m2635iconColorWaAFU9c$material3_release(z, z15), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12);
                                Modifier.Companion companionClearAndSetSemantics = (function11 == null || !(z16 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((SemanticsPropertyReceiver) obj);
                                        return Unit.INSTANCE;
                                    }
                                });
                                Function2<Composer, Integer, Unit> function12 = function2;
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
                                ComposerKt.sourceInformationMarkerStart(composer2, -296474437, "C194@8819L78:NavigationRail.kt#uh7d8r");
                                CompositionLocalKt.CompositionLocalProvider(ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(invoke$lambda$0(stateM387animateColorAsStateeuL9pac))), function12, composer2, ProvidedValue.$stable);
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
                    composerStartRestartGroup.startReplaceGroup(-782561860);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9017L536");
                    if (function5 == null) {
                        composableLambdaRememberComposableLambda = null;
                    } else {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-105269599, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i17) {
                                ComposerKt.sourceInformation(composer2, "C201@9082L5,203@9141L213,207@9371L168:NavigationRail.kt#uh7d8r");
                                if ((i17 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-105269599, i17, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:201)");
                                    }
                                    ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColorsColors.m2636textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationRailTokens.INSTANCE.getLabelTextFont(), composer2, 6), function5, composer2, 0);
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
                    function6 = function5;
                    Modifier modifierM1065defaultMinSizeVpY3zN4$default4 = SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationRailItemHeight, 1, null);
                    float f5 = NavigationRailItemWidth;
                    Modifier modifierM1087widthInVpY3zN4$default4 = SizeKt.m1087widthInVpY3zN4$default(modifierM1065defaultMinSizeVpY3zN4$default4, f5, 0.0f, 2, null);
                    Alignment center4 = Alignment.INSTANCE.getCenter();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy4 = BoxKt.maybeCachedBoxMeasurePolicy(center4, true);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap4 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier4 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM1087widthInVpY3zN4$default4);
                    Modifier modifier6 = companion;
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    mutableInteractionSource4 = mutableInteractionSource3;
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 584386773, "C231@10130L157,*240@10571L7,246@10874L128,260@11450L261,268@11760L280,282@12301L27,276@12050L289:NavigationRail.kt#uh7d8r");
                    if (z) {
                        f = 1.0f;
                    } else {
                        f = 0.0f;
                    }
                    final NavigationRailItemColors navigationRailItemColors10 = navigationRailItemColorsColors;
                    stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(150, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
                    ProvidableCompositionLocal<Density> localDensity4 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume4 = composerStartRestartGroup.consume(localDensity4);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Density density4 = (Density) objConsume4;
                    jOffset = OffsetKt.Offset((density4.roundToPx-0680j_4(f5) - density4.roundToPx-0680j_4(NavigationRailTokens.INSTANCE.m3694getActiveIndicatorWidthD9Ej5fM())) / 2, 0.0f);
                    Unit unit4 = Unit.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119672869, "CC(remember):NavigationRail.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    final MappedInteractionSource mappedInteractionSource4 = (MappedInteractionSource) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (function6 != null) {
                        composerStartRestartGroup.startReplaceGroup(585295320);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "252@11124L5");
                        value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getActiveIndicatorShape(), composerStartRestartGroup, 6);
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(585379857);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "254@11216L5");
                        value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getNoLabelActiveIndicatorShape(), composerStartRestartGroup, 6);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    ComposableLambda composableLambdaRememberComposableLambda12 = ComposableLambdaKt.rememberComposableLambda(211026382, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i17) {
                            ComposerKt.sourceInformation(composer2, "C264@11646L32,261@11468L229:NavigationRail.kt#uh7d8r");
                            if ((i17 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(211026382, i17, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:261)");
                                }
                                BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), value), mappedInteractionSource4, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    ComposableLambda composableLambdaRememberComposableLambda13 = ComposableLambdaKt.rememberComposableLambda(-1862011490, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i17) {
                            ComposerKt.sourceInformation(composer2, "C271@11882L35,269@11778L248:NavigationRail.kt#uh7d8r");
                            if ((i17 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1862011490, i17, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:269)");
                                }
                                Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                                ComposerKt.sourceInformationMarkerStart(composer2, -425107715, "CC(remember):NavigationRail.kt#9igjgp");
                                boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                                final State<Float> state = stateAnimateFloatAsState;
                                Object objRememberedValue4 = composer2.rememberedValue();
                                if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue4 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
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
                                    composer2.updateRememberedValue(objRememberedValue4);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue4), navigationRailItemColors10.getSelectedIndicatorColor(), value), composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119627306, "CC(remember):NavigationRail.kt#9igjgp");
                    zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged2) {
                        objRememberedValue2 = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2644invoke() {
                                return stateAnimateFloatAsState.getValue();
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2644invoke() {
                                return stateAnimateFloatAsState.getValue();
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    NavigationRailItemLayout(composableLambdaRememberComposableLambda12, composableLambdaRememberComposableLambda13, composableLambdaRememberComposableLambda11, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue2, composerStartRestartGroup, (57344 & (i16 >> 6)) | 438);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier6;
                    function7 = function6;
                    z7 = z6;
                    navigationRailItemColors2 = navigationRailItemColors10;
                    z8 = z4;
                    mutableInteractionSource5 = mutableInteractionSource2;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
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
                            navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            navigationRailItemColorsColors = navigationRailItemColors;
                        }
                        if (i10 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                        z6 = z5;
                    } else {
                        if (i12 != 0) {
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
                            navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            navigationRailItemColorsColors = navigationRailItemColors;
                        }
                        if (i10 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                        z6 = z5;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1533971045, i3, -1, "androidx.compose.material3.NavigationRailItem (NavigationRail.kt:181)");
                    }
                    composerStartRestartGroup.startReplaceGroup(-782588008);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "183@8207L39");
                    if (mutableInteractionSource2 == null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -782587357, "CC(remember):NavigationRail.kt#9igjgp");
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = InteractionSourceKt.MutableInteractionSource();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue3;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    final NavigationRailItemColors navigationRailItemColors11 = navigationRailItemColorsColors;
                    final boolean z17 = z6;
                    final Function2<? super Composer, ? super Integer, Unit> function12 = function5;
                    final boolean z18 = z4;
                    int i17 = i3;
                    ComposableLambda composableLambdaRememberComposableLambda14 = ComposableLambdaKt.rememberComposableLambda(-1023357515, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i18) {
                            ComposerKt.sourceInformation(composer2, "C187@8335L201,193@8718L193:NavigationRail.kt#uh7d8r");
                            if ((i18 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1023357515, i18, -1, "androidx.compose.material3.NavigationRailItem.<anonymous> (NavigationRail.kt:186)");
                                }
                                State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColors11.m2635iconColorWaAFU9c$material3_release(z, z17), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12);
                                Modifier.Companion companionClearAndSetSemantics = (function12 == null || !(z18 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((SemanticsPropertyReceiver) obj);
                                        return Unit.INSTANCE;
                                    }
                                });
                                Function2<Composer, Integer, Unit> function13 = function2;
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
                                ComposerKt.sourceInformationMarkerStart(composer2, -296474437, "C194@8819L78:NavigationRail.kt#uh7d8r");
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
                    composerStartRestartGroup.startReplaceGroup(-782561860);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9017L536");
                    if (function5 == null) {
                        composableLambdaRememberComposableLambda = null;
                    } else {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-105269599, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i18) {
                                ComposerKt.sourceInformation(composer2, "C201@9082L5,203@9141L213,207@9371L168:NavigationRail.kt#uh7d8r");
                                if ((i18 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-105269599, i18, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:201)");
                                    }
                                    ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColorsColors.m2636textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationRailTokens.INSTANCE.getLabelTextFont(), composer2, 6), function5, composer2, 0);
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
                    function6 = function5;
                    Modifier modifierM1065defaultMinSizeVpY3zN4$default5 = SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationRailItemHeight, 1, null);
                    float f6 = NavigationRailItemWidth;
                    Modifier modifierM1087widthInVpY3zN4$default5 = SizeKt.m1087widthInVpY3zN4$default(modifierM1065defaultMinSizeVpY3zN4$default5, f6, 0.0f, 2, null);
                    Alignment center5 = Alignment.INSTANCE.getCenter();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy5 = BoxKt.maybeCachedBoxMeasurePolicy(center5, true);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap5 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier5 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM1087widthInVpY3zN4$default5);
                    Modifier modifier7 = companion;
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    mutableInteractionSource4 = mutableInteractionSource3;
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 584386773, "C231@10130L157,*240@10571L7,246@10874L128,260@11450L261,268@11760L280,282@12301L27,276@12050L289:NavigationRail.kt#uh7d8r");
                    if (z) {
                        f = 1.0f;
                    } else {
                        f = 0.0f;
                    }
                    final NavigationRailItemColors navigationRailItemColors12 = navigationRailItemColorsColors;
                    stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(150, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
                    ProvidableCompositionLocal<Density> localDensity5 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume5 = composerStartRestartGroup.consume(localDensity5);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Density density5 = (Density) objConsume5;
                    jOffset = OffsetKt.Offset((density5.roundToPx-0680j_4(f6) - density5.roundToPx-0680j_4(NavigationRailTokens.INSTANCE.m3694getActiveIndicatorWidthD9Ej5fM())) / 2, 0.0f);
                    Unit unit5 = Unit.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119672869, "CC(remember):NavigationRail.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    final MappedInteractionSource mappedInteractionSource5 = (MappedInteractionSource) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (function6 != null) {
                        composerStartRestartGroup.startReplaceGroup(585295320);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "252@11124L5");
                        value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getActiveIndicatorShape(), composerStartRestartGroup, 6);
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(585379857);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "254@11216L5");
                        value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getNoLabelActiveIndicatorShape(), composerStartRestartGroup, 6);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    ComposableLambda composableLambdaRememberComposableLambda15 = ComposableLambdaKt.rememberComposableLambda(211026382, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i18) {
                            ComposerKt.sourceInformation(composer2, "C264@11646L32,261@11468L229:NavigationRail.kt#uh7d8r");
                            if ((i18 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(211026382, i18, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:261)");
                                }
                                BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), value), mappedInteractionSource5, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    ComposableLambda composableLambdaRememberComposableLambda16 = ComposableLambdaKt.rememberComposableLambda(-1862011490, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i18) {
                            ComposerKt.sourceInformation(composer2, "C271@11882L35,269@11778L248:NavigationRail.kt#uh7d8r");
                            if ((i18 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1862011490, i18, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:269)");
                                }
                                Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                                ComposerKt.sourceInformationMarkerStart(composer2, -425107715, "CC(remember):NavigationRail.kt#9igjgp");
                                boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                                final State<Float> state = stateAnimateFloatAsState;
                                Object objRememberedValue4 = composer2.rememberedValue();
                                if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue4 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
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
                                    composer2.updateRememberedValue(objRememberedValue4);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue4), navigationRailItemColors12.getSelectedIndicatorColor(), value), composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119627306, "CC(remember):NavigationRail.kt#9igjgp");
                    zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged2) {
                        objRememberedValue2 = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2644invoke() {
                                return stateAnimateFloatAsState.getValue();
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2644invoke() {
                                return stateAnimateFloatAsState.getValue();
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    NavigationRailItemLayout(composableLambdaRememberComposableLambda15, composableLambdaRememberComposableLambda16, composableLambdaRememberComposableLambda14, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue2, composerStartRestartGroup, (57344 & (i17 >> 6)) | 438);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier7;
                    function7 = function6;
                    z7 = z6;
                    navigationRailItemColors2 = navigationRailItemColors12;
                    z8 = z4;
                    mutableInteractionSource5 = mutableInteractionSource2;
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

                        public final void invoke(Composer composer2, int i18) {
                            NavigationRailKt.NavigationRailItem(z, function0, function2, modifier2, z7, function7, z8, navigationRailItemColors2, mutableInteractionSource5, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            function4 = function3;
            i8 = i2 & 64;
            if (i8 != 0) {
                i3 |= 1572864;
                z4 = z3;
            } else {
                z4 = z3;
                if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(z4)) {
                        i9 = 1048576;
                    } else {
                        i9 = 524288;
                    }
                    i3 |= i9;
                }
            }
            if ((i & 12582912) != 0) {
                i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(navigationRailItemColors)) ? 4194304 : 8388608;
            }
            i10 = i2 & Fields.RotationX;
            if (i10 != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                    i11 = 67108864;
                } else {
                    i11 = 33554432;
                }
                i3 |= i11;
            }
            if ((i3 & 38347923) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
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
                        navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        navigationRailItemColorsColors = navigationRailItemColors;
                    }
                    if (i10 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    z6 = z5;
                } else {
                    if (i12 != 0) {
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
                        navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        navigationRailItemColorsColors = navigationRailItemColors;
                    }
                    if (i10 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    z6 = z5;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1533971045, i3, -1, "androidx.compose.material3.NavigationRailItem (NavigationRail.kt:181)");
                }
                composerStartRestartGroup.startReplaceGroup(-782588008);
                ComposerKt.sourceInformation(composerStartRestartGroup, "183@8207L39");
                if (mutableInteractionSource2 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -782587357, "CC(remember):NavigationRail.kt#9igjgp");
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue3 = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue3;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                composerStartRestartGroup.endReplaceGroup();
                final NavigationRailItemColors navigationRailItemColors13 = navigationRailItemColorsColors;
                final boolean z19 = z6;
                final Function2<? super Composer, ? super Integer, Unit> function13 = function5;
                final boolean z110 = z4;
                int i18 = i3;
                ComposableLambda composableLambdaRememberComposableLambda17 = ComposableLambdaKt.rememberComposableLambda(-1023357515, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i19) {
                        ComposerKt.sourceInformation(composer2, "C187@8335L201,193@8718L193:NavigationRail.kt#uh7d8r");
                        if ((i19 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1023357515, i19, -1, "androidx.compose.material3.NavigationRailItem.<anonymous> (NavigationRail.kt:186)");
                            }
                            State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColors13.m2635iconColorWaAFU9c$material3_release(z, z19), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12);
                            Modifier.Companion companionClearAndSetSemantics = (function13 == null || !(z110 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                }

                                public Object invoke(Object obj) {
                                    invoke((SemanticsPropertyReceiver) obj);
                                    return Unit.INSTANCE;
                                }
                            });
                            Function2<Composer, Integer, Unit> function14 = function2;
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
                            ComposerKt.sourceInformationMarkerStart(composer2, -296474437, "C194@8819L78:NavigationRail.kt#uh7d8r");
                            CompositionLocalKt.CompositionLocalProvider(ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(invoke$lambda$0(stateM387animateColorAsStateeuL9pac))), function14, composer2, ProvidedValue.$stable);
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
                composerStartRestartGroup.startReplaceGroup(-782561860);
                ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9017L536");
                if (function5 == null) {
                    composableLambdaRememberComposableLambda = null;
                } else {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-105269599, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i19) {
                            ComposerKt.sourceInformation(composer2, "C201@9082L5,203@9141L213,207@9371L168:NavigationRail.kt#uh7d8r");
                            if ((i19 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-105269599, i19, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:201)");
                                }
                                ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColorsColors.m2636textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationRailTokens.INSTANCE.getLabelTextFont(), composer2, 6), function5, composer2, 0);
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
                function6 = function5;
                Modifier modifierM1065defaultMinSizeVpY3zN4$default6 = SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationRailItemHeight, 1, null);
                float f7 = NavigationRailItemWidth;
                Modifier modifierM1087widthInVpY3zN4$default6 = SizeKt.m1087widthInVpY3zN4$default(modifierM1065defaultMinSizeVpY3zN4$default6, f7, 0.0f, 2, null);
                Alignment center6 = Alignment.INSTANCE.getCenter();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy6 = BoxKt.maybeCachedBoxMeasurePolicy(center6, true);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap6 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier6 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM1087widthInVpY3zN4$default6);
                Modifier modifier8 = companion;
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                mutableInteractionSource4 = mutableInteractionSource3;
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 584386773, "C231@10130L157,*240@10571L7,246@10874L128,260@11450L261,268@11760L280,282@12301L27,276@12050L289:NavigationRail.kt#uh7d8r");
                if (z) {
                    f = 1.0f;
                } else {
                    f = 0.0f;
                }
                final NavigationRailItemColors navigationRailItemColors14 = navigationRailItemColorsColors;
                stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(150, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
                ProvidableCompositionLocal<Density> localDensity6 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume6 = composerStartRestartGroup.consume(localDensity6);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Density density6 = (Density) objConsume6;
                jOffset = OffsetKt.Offset((density6.roundToPx-0680j_4(f7) - density6.roundToPx-0680j_4(NavigationRailTokens.INSTANCE.m3694getActiveIndicatorWidthD9Ej5fM())) / 2, 0.0f);
                Unit unit6 = Unit.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119672869, "CC(remember):NavigationRail.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                final MappedInteractionSource mappedInteractionSource6 = (MappedInteractionSource) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (function6 != null) {
                    composerStartRestartGroup.startReplaceGroup(585295320);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "252@11124L5");
                    value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getActiveIndicatorShape(), composerStartRestartGroup, 6);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(585379857);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "254@11216L5");
                    value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getNoLabelActiveIndicatorShape(), composerStartRestartGroup, 6);
                    composerStartRestartGroup.endReplaceGroup();
                }
                ComposableLambda composableLambdaRememberComposableLambda18 = ComposableLambdaKt.rememberComposableLambda(211026382, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i19) {
                        ComposerKt.sourceInformation(composer2, "C264@11646L32,261@11468L229:NavigationRail.kt#uh7d8r");
                        if ((i19 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(211026382, i19, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:261)");
                            }
                            BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), value), mappedInteractionSource6, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
                ComposableLambda composableLambdaRememberComposableLambda19 = ComposableLambdaKt.rememberComposableLambda(-1862011490, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i19) {
                        ComposerKt.sourceInformation(composer2, "C271@11882L35,269@11778L248:NavigationRail.kt#uh7d8r");
                        if ((i19 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1862011490, i19, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:269)");
                            }
                            Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                            ComposerKt.sourceInformationMarkerStart(composer2, -425107715, "CC(remember):NavigationRail.kt#9igjgp");
                            boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                            final State<Float> state = stateAnimateFloatAsState;
                            Object objRememberedValue4 = composer2.rememberedValue();
                            if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue4 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
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
                                composer2.updateRememberedValue(objRememberedValue4);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue4), navigationRailItemColors14.getSelectedIndicatorColor(), value), composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119627306, "CC(remember):NavigationRail.kt#9igjgp");
                zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged2) {
                    objRememberedValue2 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2644invoke() {
                            return stateAnimateFloatAsState.getValue();
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2644invoke() {
                            return stateAnimateFloatAsState.getValue();
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                NavigationRailItemLayout(composableLambdaRememberComposableLambda18, composableLambdaRememberComposableLambda19, composableLambdaRememberComposableLambda17, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue2, composerStartRestartGroup, (57344 & (i18 >> 6)) | 438);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier8;
                function7 = function6;
                z7 = z6;
                navigationRailItemColors2 = navigationRailItemColors14;
                z8 = z4;
                mutableInteractionSource5 = mutableInteractionSource2;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
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
                        navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        navigationRailItemColorsColors = navigationRailItemColors;
                    }
                    if (i10 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    z6 = z5;
                } else {
                    if (i12 != 0) {
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
                        navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        navigationRailItemColorsColors = navigationRailItemColors;
                    }
                    if (i10 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    z6 = z5;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1533971045, i3, -1, "androidx.compose.material3.NavigationRailItem (NavigationRail.kt:181)");
                }
                composerStartRestartGroup.startReplaceGroup(-782588008);
                ComposerKt.sourceInformation(composerStartRestartGroup, "183@8207L39");
                if (mutableInteractionSource2 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -782587357, "CC(remember):NavigationRail.kt#9igjgp");
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue3 = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue3;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                composerStartRestartGroup.endReplaceGroup();
                final NavigationRailItemColors navigationRailItemColors15 = navigationRailItemColorsColors;
                final boolean z111 = z6;
                final Function2<? super Composer, ? super Integer, Unit> function14 = function5;
                final boolean z112 = z4;
                int i19 = i3;
                ComposableLambda composableLambdaRememberComposableLambda110 = ComposableLambdaKt.rememberComposableLambda(-1023357515, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i110) {
                        ComposerKt.sourceInformation(composer2, "C187@8335L201,193@8718L193:NavigationRail.kt#uh7d8r");
                        if ((i110 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1023357515, i110, -1, "androidx.compose.material3.NavigationRailItem.<anonymous> (NavigationRail.kt:186)");
                            }
                            State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColors15.m2635iconColorWaAFU9c$material3_release(z, z111), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12);
                            Modifier.Companion companionClearAndSetSemantics = (function14 == null || !(z112 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                }

                                public Object invoke(Object obj) {
                                    invoke((SemanticsPropertyReceiver) obj);
                                    return Unit.INSTANCE;
                                }
                            });
                            Function2<Composer, Integer, Unit> function15 = function2;
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
                            ComposerKt.sourceInformationMarkerStart(composer2, -296474437, "C194@8819L78:NavigationRail.kt#uh7d8r");
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
                composerStartRestartGroup.startReplaceGroup(-782561860);
                ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9017L536");
                if (function5 == null) {
                    composableLambdaRememberComposableLambda = null;
                } else {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-105269599, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i110) {
                            ComposerKt.sourceInformation(composer2, "C201@9082L5,203@9141L213,207@9371L168:NavigationRail.kt#uh7d8r");
                            if ((i110 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-105269599, i110, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:201)");
                                }
                                ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColorsColors.m2636textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationRailTokens.INSTANCE.getLabelTextFont(), composer2, 6), function5, composer2, 0);
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
                function6 = function5;
                Modifier modifierM1065defaultMinSizeVpY3zN4$default7 = SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationRailItemHeight, 1, null);
                float f8 = NavigationRailItemWidth;
                Modifier modifierM1087widthInVpY3zN4$default7 = SizeKt.m1087widthInVpY3zN4$default(modifierM1065defaultMinSizeVpY3zN4$default7, f8, 0.0f, 2, null);
                Alignment center7 = Alignment.INSTANCE.getCenter();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy7 = BoxKt.maybeCachedBoxMeasurePolicy(center7, true);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap7 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier7 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM1087widthInVpY3zN4$default7);
                Modifier modifier9 = companion;
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                mutableInteractionSource4 = mutableInteractionSource3;
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 584386773, "C231@10130L157,*240@10571L7,246@10874L128,260@11450L261,268@11760L280,282@12301L27,276@12050L289:NavigationRail.kt#uh7d8r");
                if (z) {
                    f = 1.0f;
                } else {
                    f = 0.0f;
                }
                final NavigationRailItemColors navigationRailItemColors16 = navigationRailItemColorsColors;
                stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(150, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
                ProvidableCompositionLocal<Density> localDensity7 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume7 = composerStartRestartGroup.consume(localDensity7);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Density density7 = (Density) objConsume7;
                jOffset = OffsetKt.Offset((density7.roundToPx-0680j_4(f8) - density7.roundToPx-0680j_4(NavigationRailTokens.INSTANCE.m3694getActiveIndicatorWidthD9Ej5fM())) / 2, 0.0f);
                Unit unit7 = Unit.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119672869, "CC(remember):NavigationRail.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                final MappedInteractionSource mappedInteractionSource7 = (MappedInteractionSource) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (function6 != null) {
                    composerStartRestartGroup.startReplaceGroup(585295320);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "252@11124L5");
                    value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getActiveIndicatorShape(), composerStartRestartGroup, 6);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(585379857);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "254@11216L5");
                    value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getNoLabelActiveIndicatorShape(), composerStartRestartGroup, 6);
                    composerStartRestartGroup.endReplaceGroup();
                }
                ComposableLambda composableLambdaRememberComposableLambda111 = ComposableLambdaKt.rememberComposableLambda(211026382, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i110) {
                        ComposerKt.sourceInformation(composer2, "C264@11646L32,261@11468L229:NavigationRail.kt#uh7d8r");
                        if ((i110 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(211026382, i110, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:261)");
                            }
                            BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), value), mappedInteractionSource7, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
                ComposableLambda composableLambdaRememberComposableLambda112 = ComposableLambdaKt.rememberComposableLambda(-1862011490, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i110) {
                        ComposerKt.sourceInformation(composer2, "C271@11882L35,269@11778L248:NavigationRail.kt#uh7d8r");
                        if ((i110 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1862011490, i110, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:269)");
                            }
                            Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                            ComposerKt.sourceInformationMarkerStart(composer2, -425107715, "CC(remember):NavigationRail.kt#9igjgp");
                            boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                            final State<Float> state = stateAnimateFloatAsState;
                            Object objRememberedValue4 = composer2.rememberedValue();
                            if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue4 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
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
                                composer2.updateRememberedValue(objRememberedValue4);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue4), navigationRailItemColors16.getSelectedIndicatorColor(), value), composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119627306, "CC(remember):NavigationRail.kt#9igjgp");
                zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged2) {
                    objRememberedValue2 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2644invoke() {
                            return stateAnimateFloatAsState.getValue();
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2644invoke() {
                            return stateAnimateFloatAsState.getValue();
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                NavigationRailItemLayout(composableLambdaRememberComposableLambda111, composableLambdaRememberComposableLambda112, composableLambdaRememberComposableLambda110, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue2, composerStartRestartGroup, (57344 & (i19 >> 6)) | 438);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier9;
                function7 = function6;
                z7 = z6;
                navigationRailItemColors2 = navigationRailItemColors16;
                z8 = z4;
                mutableInteractionSource5 = mutableInteractionSource2;
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

                    public final void invoke(Composer composer2, int i110) {
                        NavigationRailKt.NavigationRailItem(z, function0, function2, modifier2, z7, function7, z8, navigationRailItemColors2, mutableInteractionSource5, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        i4 = i2 & 16;
        if (i4 != 0) {
            if ((i & 24576) == 0) {
                if (composerStartRestartGroup.changed(z2)) {
                    i5 = Fields.Clip;
                } else {
                    i5 = Fields.Shape;
                }
                i3 |= i5;
            }
            i6 = i2 & 32;
            if (i6 != 0) {
                if ((196608 & i) == 0) {
                    function4 = function3;
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i7 = Fields.RenderEffect;
                    } else {
                        i7 = 65536;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 64;
                if (i8 != 0) {
                    i3 |= 1572864;
                    z4 = z3;
                } else {
                    z4 = z3;
                    if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(z4)) {
                            i9 = 1048576;
                        } else {
                            i9 = 524288;
                        }
                        i3 |= i9;
                    }
                }
                if ((i & 12582912) != 0) {
                    i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(navigationRailItemColors)) ? 4194304 : 8388608;
                }
                i10 = i2 & Fields.RotationX;
                if (i10 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                        i11 = 67108864;
                    } else {
                        i11 = 33554432;
                    }
                    i3 |= i11;
                }
                if ((i3 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
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
                            navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            navigationRailItemColorsColors = navigationRailItemColors;
                        }
                        if (i10 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                        z6 = z5;
                    } else {
                        if (i12 != 0) {
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
                            navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            navigationRailItemColorsColors = navigationRailItemColors;
                        }
                        if (i10 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                        z6 = z5;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1533971045, i3, -1, "androidx.compose.material3.NavigationRailItem (NavigationRail.kt:181)");
                    }
                    composerStartRestartGroup.startReplaceGroup(-782588008);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "183@8207L39");
                    if (mutableInteractionSource2 == null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -782587357, "CC(remember):NavigationRail.kt#9igjgp");
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = InteractionSourceKt.MutableInteractionSource();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue3;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    final NavigationRailItemColors navigationRailItemColors17 = navigationRailItemColorsColors;
                    final boolean z113 = z6;
                    final Function2<? super Composer, ? super Integer, Unit> function15 = function5;
                    final boolean z114 = z4;
                    int i110 = i3;
                    ComposableLambda composableLambdaRememberComposableLambda113 = ComposableLambdaKt.rememberComposableLambda(-1023357515, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111) {
                            ComposerKt.sourceInformation(composer2, "C187@8335L201,193@8718L193:NavigationRail.kt#uh7d8r");
                            if ((i111 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1023357515, i111, -1, "androidx.compose.material3.NavigationRailItem.<anonymous> (NavigationRail.kt:186)");
                                }
                                State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColors17.m2635iconColorWaAFU9c$material3_release(z, z113), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12);
                                Modifier.Companion companionClearAndSetSemantics = (function15 == null || !(z114 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((SemanticsPropertyReceiver) obj);
                                        return Unit.INSTANCE;
                                    }
                                });
                                Function2<Composer, Integer, Unit> function16 = function2;
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
                                ComposerKt.sourceInformationMarkerStart(composer2, -296474437, "C194@8819L78:NavigationRail.kt#uh7d8r");
                                CompositionLocalKt.CompositionLocalProvider(ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(invoke$lambda$0(stateM387animateColorAsStateeuL9pac))), function16, composer2, ProvidedValue.$stable);
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
                    composerStartRestartGroup.startReplaceGroup(-782561860);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9017L536");
                    if (function5 == null) {
                        composableLambdaRememberComposableLambda = null;
                    } else {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-105269599, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i111) {
                                ComposerKt.sourceInformation(composer2, "C201@9082L5,203@9141L213,207@9371L168:NavigationRail.kt#uh7d8r");
                                if ((i111 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-105269599, i111, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:201)");
                                    }
                                    ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColorsColors.m2636textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationRailTokens.INSTANCE.getLabelTextFont(), composer2, 6), function5, composer2, 0);
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
                    function6 = function5;
                    Modifier modifierM1065defaultMinSizeVpY3zN4$default8 = SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationRailItemHeight, 1, null);
                    float f9 = NavigationRailItemWidth;
                    Modifier modifierM1087widthInVpY3zN4$default8 = SizeKt.m1087widthInVpY3zN4$default(modifierM1065defaultMinSizeVpY3zN4$default8, f9, 0.0f, 2, null);
                    Alignment center8 = Alignment.INSTANCE.getCenter();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy8 = BoxKt.maybeCachedBoxMeasurePolicy(center8, true);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap8 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier8 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM1087widthInVpY3zN4$default8);
                    Modifier modifier10 = companion;
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    mutableInteractionSource4 = mutableInteractionSource3;
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 584386773, "C231@10130L157,*240@10571L7,246@10874L128,260@11450L261,268@11760L280,282@12301L27,276@12050L289:NavigationRail.kt#uh7d8r");
                    if (z) {
                        f = 1.0f;
                    } else {
                        f = 0.0f;
                    }
                    final NavigationRailItemColors navigationRailItemColors18 = navigationRailItemColorsColors;
                    stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(150, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
                    ProvidableCompositionLocal<Density> localDensity8 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume8 = composerStartRestartGroup.consume(localDensity8);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Density density8 = (Density) objConsume8;
                    jOffset = OffsetKt.Offset((density8.roundToPx-0680j_4(f9) - density8.roundToPx-0680j_4(NavigationRailTokens.INSTANCE.m3694getActiveIndicatorWidthD9Ej5fM())) / 2, 0.0f);
                    Unit unit8 = Unit.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119672869, "CC(remember):NavigationRail.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    final MappedInteractionSource mappedInteractionSource8 = (MappedInteractionSource) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (function6 != null) {
                        composerStartRestartGroup.startReplaceGroup(585295320);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "252@11124L5");
                        value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getActiveIndicatorShape(), composerStartRestartGroup, 6);
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(585379857);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "254@11216L5");
                        value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getNoLabelActiveIndicatorShape(), composerStartRestartGroup, 6);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    ComposableLambda composableLambdaRememberComposableLambda114 = ComposableLambdaKt.rememberComposableLambda(211026382, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111) {
                            ComposerKt.sourceInformation(composer2, "C264@11646L32,261@11468L229:NavigationRail.kt#uh7d8r");
                            if ((i111 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(211026382, i111, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:261)");
                                }
                                BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), value), mappedInteractionSource8, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    ComposableLambda composableLambdaRememberComposableLambda115 = ComposableLambdaKt.rememberComposableLambda(-1862011490, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111) {
                            ComposerKt.sourceInformation(composer2, "C271@11882L35,269@11778L248:NavigationRail.kt#uh7d8r");
                            if ((i111 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1862011490, i111, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:269)");
                                }
                                Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                                ComposerKt.sourceInformationMarkerStart(composer2, -425107715, "CC(remember):NavigationRail.kt#9igjgp");
                                boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                                final State<Float> state = stateAnimateFloatAsState;
                                Object objRememberedValue4 = composer2.rememberedValue();
                                if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue4 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
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
                                    composer2.updateRememberedValue(objRememberedValue4);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue4), navigationRailItemColors18.getSelectedIndicatorColor(), value), composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119627306, "CC(remember):NavigationRail.kt#9igjgp");
                    zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged2) {
                        objRememberedValue2 = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2644invoke() {
                                return stateAnimateFloatAsState.getValue();
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2644invoke() {
                                return stateAnimateFloatAsState.getValue();
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    NavigationRailItemLayout(composableLambdaRememberComposableLambda114, composableLambdaRememberComposableLambda115, composableLambdaRememberComposableLambda113, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue2, composerStartRestartGroup, (57344 & (i110 >> 6)) | 438);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier10;
                    function7 = function6;
                    z7 = z6;
                    navigationRailItemColors2 = navigationRailItemColors18;
                    z8 = z4;
                    mutableInteractionSource5 = mutableInteractionSource2;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
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
                            navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            navigationRailItemColorsColors = navigationRailItemColors;
                        }
                        if (i10 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                        z6 = z5;
                    } else {
                        if (i12 != 0) {
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
                            navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            navigationRailItemColorsColors = navigationRailItemColors;
                        }
                        if (i10 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                        z6 = z5;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1533971045, i3, -1, "androidx.compose.material3.NavigationRailItem (NavigationRail.kt:181)");
                    }
                    composerStartRestartGroup.startReplaceGroup(-782588008);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "183@8207L39");
                    if (mutableInteractionSource2 == null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -782587357, "CC(remember):NavigationRail.kt#9igjgp");
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = InteractionSourceKt.MutableInteractionSource();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue3;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    final NavigationRailItemColors navigationRailItemColors19 = navigationRailItemColorsColors;
                    final boolean z115 = z6;
                    final Function2<? super Composer, ? super Integer, Unit> function16 = function5;
                    final boolean z116 = z4;
                    int i111 = i3;
                    ComposableLambda composableLambdaRememberComposableLambda116 = ComposableLambdaKt.rememberComposableLambda(-1023357515, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i112) {
                            ComposerKt.sourceInformation(composer2, "C187@8335L201,193@8718L193:NavigationRail.kt#uh7d8r");
                            if ((i112 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1023357515, i112, -1, "androidx.compose.material3.NavigationRailItem.<anonymous> (NavigationRail.kt:186)");
                                }
                                State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColors19.m2635iconColorWaAFU9c$material3_release(z, z115), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12);
                                Modifier.Companion companionClearAndSetSemantics = (function16 == null || !(z116 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((SemanticsPropertyReceiver) obj);
                                        return Unit.INSTANCE;
                                    }
                                });
                                Function2<Composer, Integer, Unit> function17 = function2;
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
                                ComposerKt.sourceInformationMarkerStart(composer2, -296474437, "C194@8819L78:NavigationRail.kt#uh7d8r");
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
                    composerStartRestartGroup.startReplaceGroup(-782561860);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9017L536");
                    if (function5 == null) {
                        composableLambdaRememberComposableLambda = null;
                    } else {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-105269599, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i112) {
                                ComposerKt.sourceInformation(composer2, "C201@9082L5,203@9141L213,207@9371L168:NavigationRail.kt#uh7d8r");
                                if ((i112 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-105269599, i112, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:201)");
                                    }
                                    ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColorsColors.m2636textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationRailTokens.INSTANCE.getLabelTextFont(), composer2, 6), function5, composer2, 0);
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
                    function6 = function5;
                    Modifier modifierM1065defaultMinSizeVpY3zN4$default9 = SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationRailItemHeight, 1, null);
                    float f10 = NavigationRailItemWidth;
                    Modifier modifierM1087widthInVpY3zN4$default9 = SizeKt.m1087widthInVpY3zN4$default(modifierM1065defaultMinSizeVpY3zN4$default9, f10, 0.0f, 2, null);
                    Alignment center9 = Alignment.INSTANCE.getCenter();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy9 = BoxKt.maybeCachedBoxMeasurePolicy(center9, true);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap9 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier9 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM1087widthInVpY3zN4$default9);
                    Modifier modifier11 = companion;
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    mutableInteractionSource4 = mutableInteractionSource3;
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 584386773, "C231@10130L157,*240@10571L7,246@10874L128,260@11450L261,268@11760L280,282@12301L27,276@12050L289:NavigationRail.kt#uh7d8r");
                    if (z) {
                        f = 1.0f;
                    } else {
                        f = 0.0f;
                    }
                    final NavigationRailItemColors navigationRailItemColors110 = navigationRailItemColorsColors;
                    stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(150, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
                    ProvidableCompositionLocal<Density> localDensity9 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume9 = composerStartRestartGroup.consume(localDensity9);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Density density9 = (Density) objConsume9;
                    jOffset = OffsetKt.Offset((density9.roundToPx-0680j_4(f10) - density9.roundToPx-0680j_4(NavigationRailTokens.INSTANCE.m3694getActiveIndicatorWidthD9Ej5fM())) / 2, 0.0f);
                    Unit unit9 = Unit.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119672869, "CC(remember):NavigationRail.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    final MappedInteractionSource mappedInteractionSource9 = (MappedInteractionSource) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (function6 != null) {
                        composerStartRestartGroup.startReplaceGroup(585295320);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "252@11124L5");
                        value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getActiveIndicatorShape(), composerStartRestartGroup, 6);
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(585379857);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "254@11216L5");
                        value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getNoLabelActiveIndicatorShape(), composerStartRestartGroup, 6);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    ComposableLambda composableLambdaRememberComposableLambda117 = ComposableLambdaKt.rememberComposableLambda(211026382, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i112) {
                            ComposerKt.sourceInformation(composer2, "C264@11646L32,261@11468L229:NavigationRail.kt#uh7d8r");
                            if ((i112 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(211026382, i112, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:261)");
                                }
                                BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), value), mappedInteractionSource9, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    ComposableLambda composableLambdaRememberComposableLambda118 = ComposableLambdaKt.rememberComposableLambda(-1862011490, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i112) {
                            ComposerKt.sourceInformation(composer2, "C271@11882L35,269@11778L248:NavigationRail.kt#uh7d8r");
                            if ((i112 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1862011490, i112, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:269)");
                                }
                                Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                                ComposerKt.sourceInformationMarkerStart(composer2, -425107715, "CC(remember):NavigationRail.kt#9igjgp");
                                boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                                final State<Float> state = stateAnimateFloatAsState;
                                Object objRememberedValue4 = composer2.rememberedValue();
                                if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue4 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
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
                                    composer2.updateRememberedValue(objRememberedValue4);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue4), navigationRailItemColors110.getSelectedIndicatorColor(), value), composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119627306, "CC(remember):NavigationRail.kt#9igjgp");
                    zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged2) {
                        objRememberedValue2 = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2644invoke() {
                                return stateAnimateFloatAsState.getValue();
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2644invoke() {
                                return stateAnimateFloatAsState.getValue();
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    NavigationRailItemLayout(composableLambdaRememberComposableLambda117, composableLambdaRememberComposableLambda118, composableLambdaRememberComposableLambda116, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue2, composerStartRestartGroup, (57344 & (i111 >> 6)) | 438);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier11;
                    function7 = function6;
                    z7 = z6;
                    navigationRailItemColors2 = navigationRailItemColors110;
                    z8 = z4;
                    mutableInteractionSource5 = mutableInteractionSource2;
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

                        public final void invoke(Composer composer2, int i112) {
                            NavigationRailKt.NavigationRailItem(z, function0, function2, modifier2, z7, function7, z8, navigationRailItemColors2, mutableInteractionSource5, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            function4 = function3;
            i8 = i2 & 64;
            if (i8 != 0) {
                i3 |= 1572864;
                z4 = z3;
            } else {
                z4 = z3;
                if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(z4)) {
                        i9 = 1048576;
                    } else {
                        i9 = 524288;
                    }
                    i3 |= i9;
                }
            }
            if ((i & 12582912) != 0) {
                i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(navigationRailItemColors)) ? 4194304 : 8388608;
            }
            i10 = i2 & Fields.RotationX;
            if (i10 != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                    i11 = 67108864;
                } else {
                    i11 = 33554432;
                }
                i3 |= i11;
            }
            if ((i3 & 38347923) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
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
                        navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        navigationRailItemColorsColors = navigationRailItemColors;
                    }
                    if (i10 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    z6 = z5;
                } else {
                    if (i12 != 0) {
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
                        navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        navigationRailItemColorsColors = navigationRailItemColors;
                    }
                    if (i10 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    z6 = z5;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1533971045, i3, -1, "androidx.compose.material3.NavigationRailItem (NavigationRail.kt:181)");
                }
                composerStartRestartGroup.startReplaceGroup(-782588008);
                ComposerKt.sourceInformation(composerStartRestartGroup, "183@8207L39");
                if (mutableInteractionSource2 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -782587357, "CC(remember):NavigationRail.kt#9igjgp");
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue3 = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue3;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                composerStartRestartGroup.endReplaceGroup();
                final NavigationRailItemColors navigationRailItemColors111 = navigationRailItemColorsColors;
                final boolean z117 = z6;
                final Function2<? super Composer, ? super Integer, Unit> function17 = function5;
                final boolean z118 = z4;
                int i112 = i3;
                ComposableLambda composableLambdaRememberComposableLambda119 = ComposableLambdaKt.rememberComposableLambda(-1023357515, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i113) {
                        ComposerKt.sourceInformation(composer2, "C187@8335L201,193@8718L193:NavigationRail.kt#uh7d8r");
                        if ((i113 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1023357515, i113, -1, "androidx.compose.material3.NavigationRailItem.<anonymous> (NavigationRail.kt:186)");
                            }
                            State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColors111.m2635iconColorWaAFU9c$material3_release(z, z117), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12);
                            Modifier.Companion companionClearAndSetSemantics = (function17 == null || !(z118 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                }

                                public Object invoke(Object obj) {
                                    invoke((SemanticsPropertyReceiver) obj);
                                    return Unit.INSTANCE;
                                }
                            });
                            Function2<Composer, Integer, Unit> function18 = function2;
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
                            ComposerKt.sourceInformationMarkerStart(composer2, -296474437, "C194@8819L78:NavigationRail.kt#uh7d8r");
                            CompositionLocalKt.CompositionLocalProvider(ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(invoke$lambda$0(stateM387animateColorAsStateeuL9pac))), function18, composer2, ProvidedValue.$stable);
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
                composerStartRestartGroup.startReplaceGroup(-782561860);
                ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9017L536");
                if (function5 == null) {
                    composableLambdaRememberComposableLambda = null;
                } else {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-105269599, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i113) {
                            ComposerKt.sourceInformation(composer2, "C201@9082L5,203@9141L213,207@9371L168:NavigationRail.kt#uh7d8r");
                            if ((i113 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-105269599, i113, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:201)");
                                }
                                ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColorsColors.m2636textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationRailTokens.INSTANCE.getLabelTextFont(), composer2, 6), function5, composer2, 0);
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
                function6 = function5;
                Modifier modifierM1065defaultMinSizeVpY3zN4$default10 = SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationRailItemHeight, 1, null);
                float f11 = NavigationRailItemWidth;
                Modifier modifierM1087widthInVpY3zN4$default10 = SizeKt.m1087widthInVpY3zN4$default(modifierM1065defaultMinSizeVpY3zN4$default10, f11, 0.0f, 2, null);
                Alignment center10 = Alignment.INSTANCE.getCenter();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy10 = BoxKt.maybeCachedBoxMeasurePolicy(center10, true);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap10 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier10 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM1087widthInVpY3zN4$default10);
                Modifier modifier12 = companion;
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                mutableInteractionSource4 = mutableInteractionSource3;
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 584386773, "C231@10130L157,*240@10571L7,246@10874L128,260@11450L261,268@11760L280,282@12301L27,276@12050L289:NavigationRail.kt#uh7d8r");
                if (z) {
                    f = 1.0f;
                } else {
                    f = 0.0f;
                }
                final NavigationRailItemColors navigationRailItemColors112 = navigationRailItemColorsColors;
                stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(150, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
                ProvidableCompositionLocal<Density> localDensity10 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume10 = composerStartRestartGroup.consume(localDensity10);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Density density10 = (Density) objConsume10;
                jOffset = OffsetKt.Offset((density10.roundToPx-0680j_4(f11) - density10.roundToPx-0680j_4(NavigationRailTokens.INSTANCE.m3694getActiveIndicatorWidthD9Ej5fM())) / 2, 0.0f);
                Unit unit10 = Unit.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119672869, "CC(remember):NavigationRail.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                final MappedInteractionSource mappedInteractionSource10 = (MappedInteractionSource) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (function6 != null) {
                    composerStartRestartGroup.startReplaceGroup(585295320);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "252@11124L5");
                    value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getActiveIndicatorShape(), composerStartRestartGroup, 6);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(585379857);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "254@11216L5");
                    value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getNoLabelActiveIndicatorShape(), composerStartRestartGroup, 6);
                    composerStartRestartGroup.endReplaceGroup();
                }
                ComposableLambda composableLambdaRememberComposableLambda1110 = ComposableLambdaKt.rememberComposableLambda(211026382, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i113) {
                        ComposerKt.sourceInformation(composer2, "C264@11646L32,261@11468L229:NavigationRail.kt#uh7d8r");
                        if ((i113 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(211026382, i113, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:261)");
                            }
                            BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), value), mappedInteractionSource10, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
                ComposableLambda composableLambdaRememberComposableLambda1111 = ComposableLambdaKt.rememberComposableLambda(-1862011490, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i113) {
                        ComposerKt.sourceInformation(composer2, "C271@11882L35,269@11778L248:NavigationRail.kt#uh7d8r");
                        if ((i113 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1862011490, i113, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:269)");
                            }
                            Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                            ComposerKt.sourceInformationMarkerStart(composer2, -425107715, "CC(remember):NavigationRail.kt#9igjgp");
                            boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                            final State<Float> state = stateAnimateFloatAsState;
                            Object objRememberedValue4 = composer2.rememberedValue();
                            if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue4 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
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
                                composer2.updateRememberedValue(objRememberedValue4);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue4), navigationRailItemColors112.getSelectedIndicatorColor(), value), composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119627306, "CC(remember):NavigationRail.kt#9igjgp");
                zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged2) {
                    objRememberedValue2 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2644invoke() {
                            return stateAnimateFloatAsState.getValue();
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2644invoke() {
                            return stateAnimateFloatAsState.getValue();
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                NavigationRailItemLayout(composableLambdaRememberComposableLambda1110, composableLambdaRememberComposableLambda1111, composableLambdaRememberComposableLambda119, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue2, composerStartRestartGroup, (57344 & (i112 >> 6)) | 438);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier12;
                function7 = function6;
                z7 = z6;
                navigationRailItemColors2 = navigationRailItemColors112;
                z8 = z4;
                mutableInteractionSource5 = mutableInteractionSource2;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
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
                        navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        navigationRailItemColorsColors = navigationRailItemColors;
                    }
                    if (i10 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    z6 = z5;
                } else {
                    if (i12 != 0) {
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
                        navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        navigationRailItemColorsColors = navigationRailItemColors;
                    }
                    if (i10 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    z6 = z5;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1533971045, i3, -1, "androidx.compose.material3.NavigationRailItem (NavigationRail.kt:181)");
                }
                composerStartRestartGroup.startReplaceGroup(-782588008);
                ComposerKt.sourceInformation(composerStartRestartGroup, "183@8207L39");
                if (mutableInteractionSource2 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -782587357, "CC(remember):NavigationRail.kt#9igjgp");
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue3 = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue3;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                composerStartRestartGroup.endReplaceGroup();
                final NavigationRailItemColors navigationRailItemColors113 = navigationRailItemColorsColors;
                final boolean z119 = z6;
                final Function2<? super Composer, ? super Integer, Unit> function18 = function5;
                final boolean z1110 = z4;
                int i113 = i3;
                ComposableLambda composableLambdaRememberComposableLambda1112 = ComposableLambdaKt.rememberComposableLambda(-1023357515, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i114) {
                        ComposerKt.sourceInformation(composer2, "C187@8335L201,193@8718L193:NavigationRail.kt#uh7d8r");
                        if ((i114 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1023357515, i114, -1, "androidx.compose.material3.NavigationRailItem.<anonymous> (NavigationRail.kt:186)");
                            }
                            State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColors113.m2635iconColorWaAFU9c$material3_release(z, z119), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12);
                            Modifier.Companion companionClearAndSetSemantics = (function18 == null || !(z1110 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                }

                                public Object invoke(Object obj) {
                                    invoke((SemanticsPropertyReceiver) obj);
                                    return Unit.INSTANCE;
                                }
                            });
                            Function2<Composer, Integer, Unit> function19 = function2;
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
                            ComposerKt.sourceInformationMarkerStart(composer2, -296474437, "C194@8819L78:NavigationRail.kt#uh7d8r");
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
                composerStartRestartGroup.startReplaceGroup(-782561860);
                ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9017L536");
                if (function5 == null) {
                    composableLambdaRememberComposableLambda = null;
                } else {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-105269599, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i114) {
                            ComposerKt.sourceInformation(composer2, "C201@9082L5,203@9141L213,207@9371L168:NavigationRail.kt#uh7d8r");
                            if ((i114 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-105269599, i114, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:201)");
                                }
                                ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColorsColors.m2636textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationRailTokens.INSTANCE.getLabelTextFont(), composer2, 6), function5, composer2, 0);
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
                function6 = function5;
                Modifier modifierM1065defaultMinSizeVpY3zN4$default11 = SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationRailItemHeight, 1, null);
                float f12 = NavigationRailItemWidth;
                Modifier modifierM1087widthInVpY3zN4$default11 = SizeKt.m1087widthInVpY3zN4$default(modifierM1065defaultMinSizeVpY3zN4$default11, f12, 0.0f, 2, null);
                Alignment center11 = Alignment.INSTANCE.getCenter();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy11 = BoxKt.maybeCachedBoxMeasurePolicy(center11, true);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap11 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier11 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM1087widthInVpY3zN4$default11);
                Modifier modifier13 = companion;
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                mutableInteractionSource4 = mutableInteractionSource3;
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 584386773, "C231@10130L157,*240@10571L7,246@10874L128,260@11450L261,268@11760L280,282@12301L27,276@12050L289:NavigationRail.kt#uh7d8r");
                if (z) {
                    f = 1.0f;
                } else {
                    f = 0.0f;
                }
                final NavigationRailItemColors navigationRailItemColors114 = navigationRailItemColorsColors;
                stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(150, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
                ProvidableCompositionLocal<Density> localDensity11 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume11 = composerStartRestartGroup.consume(localDensity11);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Density density11 = (Density) objConsume11;
                jOffset = OffsetKt.Offset((density11.roundToPx-0680j_4(f12) - density11.roundToPx-0680j_4(NavigationRailTokens.INSTANCE.m3694getActiveIndicatorWidthD9Ej5fM())) / 2, 0.0f);
                Unit unit11 = Unit.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119672869, "CC(remember):NavigationRail.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                final MappedInteractionSource mappedInteractionSource11 = (MappedInteractionSource) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (function6 != null) {
                    composerStartRestartGroup.startReplaceGroup(585295320);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "252@11124L5");
                    value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getActiveIndicatorShape(), composerStartRestartGroup, 6);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(585379857);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "254@11216L5");
                    value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getNoLabelActiveIndicatorShape(), composerStartRestartGroup, 6);
                    composerStartRestartGroup.endReplaceGroup();
                }
                ComposableLambda composableLambdaRememberComposableLambda1113 = ComposableLambdaKt.rememberComposableLambda(211026382, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i114) {
                        ComposerKt.sourceInformation(composer2, "C264@11646L32,261@11468L229:NavigationRail.kt#uh7d8r");
                        if ((i114 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(211026382, i114, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:261)");
                            }
                            BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), value), mappedInteractionSource11, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
                ComposableLambda composableLambdaRememberComposableLambda1114 = ComposableLambdaKt.rememberComposableLambda(-1862011490, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i114) {
                        ComposerKt.sourceInformation(composer2, "C271@11882L35,269@11778L248:NavigationRail.kt#uh7d8r");
                        if ((i114 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1862011490, i114, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:269)");
                            }
                            Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                            ComposerKt.sourceInformationMarkerStart(composer2, -425107715, "CC(remember):NavigationRail.kt#9igjgp");
                            boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                            final State<Float> state = stateAnimateFloatAsState;
                            Object objRememberedValue4 = composer2.rememberedValue();
                            if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue4 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
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
                                composer2.updateRememberedValue(objRememberedValue4);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue4), navigationRailItemColors114.getSelectedIndicatorColor(), value), composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119627306, "CC(remember):NavigationRail.kt#9igjgp");
                zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged2) {
                    objRememberedValue2 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2644invoke() {
                            return stateAnimateFloatAsState.getValue();
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2644invoke() {
                            return stateAnimateFloatAsState.getValue();
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                NavigationRailItemLayout(composableLambdaRememberComposableLambda1113, composableLambdaRememberComposableLambda1114, composableLambdaRememberComposableLambda1112, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue2, composerStartRestartGroup, (57344 & (i113 >> 6)) | 438);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier13;
                function7 = function6;
                z7 = z6;
                navigationRailItemColors2 = navigationRailItemColors114;
                z8 = z4;
                mutableInteractionSource5 = mutableInteractionSource2;
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

                    public final void invoke(Composer composer2, int i114) {
                        NavigationRailKt.NavigationRailItem(z, function0, function2, modifier2, z7, function7, z8, navigationRailItemColors2, mutableInteractionSource5, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 24576;
        i6 = i2 & 32;
        if (i6 != 0) {
            if ((196608 & i) == 0) {
                function4 = function3;
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i7 = Fields.RenderEffect;
                } else {
                    i7 = 65536;
                }
                i3 |= i7;
            }
            i8 = i2 & 64;
            if (i8 != 0) {
                i3 |= 1572864;
                z4 = z3;
            } else {
                z4 = z3;
                if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(z4)) {
                        i9 = 1048576;
                    } else {
                        i9 = 524288;
                    }
                    i3 |= i9;
                }
            }
            if ((i & 12582912) != 0) {
                i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(navigationRailItemColors)) ? 4194304 : 8388608;
            }
            i10 = i2 & Fields.RotationX;
            if (i10 != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                    i11 = 67108864;
                } else {
                    i11 = 33554432;
                }
                i3 |= i11;
            }
            if ((i3 & 38347923) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
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
                        navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        navigationRailItemColorsColors = navigationRailItemColors;
                    }
                    if (i10 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    z6 = z5;
                } else {
                    if (i12 != 0) {
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
                        navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        navigationRailItemColorsColors = navigationRailItemColors;
                    }
                    if (i10 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    z6 = z5;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1533971045, i3, -1, "androidx.compose.material3.NavigationRailItem (NavigationRail.kt:181)");
                }
                composerStartRestartGroup.startReplaceGroup(-782588008);
                ComposerKt.sourceInformation(composerStartRestartGroup, "183@8207L39");
                if (mutableInteractionSource2 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -782587357, "CC(remember):NavigationRail.kt#9igjgp");
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue3 = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue3;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                composerStartRestartGroup.endReplaceGroup();
                final NavigationRailItemColors navigationRailItemColors115 = navigationRailItemColorsColors;
                final boolean z1111 = z6;
                final Function2<? super Composer, ? super Integer, Unit> function19 = function5;
                final boolean z1112 = z4;
                int i114 = i3;
                ComposableLambda composableLambdaRememberComposableLambda1115 = ComposableLambdaKt.rememberComposableLambda(-1023357515, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i115) {
                        ComposerKt.sourceInformation(composer2, "C187@8335L201,193@8718L193:NavigationRail.kt#uh7d8r");
                        if ((i115 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1023357515, i115, -1, "androidx.compose.material3.NavigationRailItem.<anonymous> (NavigationRail.kt:186)");
                            }
                            State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColors115.m2635iconColorWaAFU9c$material3_release(z, z1111), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12);
                            Modifier.Companion companionClearAndSetSemantics = (function19 == null || !(z1112 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                }

                                public Object invoke(Object obj) {
                                    invoke((SemanticsPropertyReceiver) obj);
                                    return Unit.INSTANCE;
                                }
                            });
                            Function2<Composer, Integer, Unit> function110 = function2;
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
                            ComposerKt.sourceInformationMarkerStart(composer2, -296474437, "C194@8819L78:NavigationRail.kt#uh7d8r");
                            CompositionLocalKt.CompositionLocalProvider(ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(invoke$lambda$0(stateM387animateColorAsStateeuL9pac))), function110, composer2, ProvidedValue.$stable);
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
                composerStartRestartGroup.startReplaceGroup(-782561860);
                ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9017L536");
                if (function5 == null) {
                    composableLambdaRememberComposableLambda = null;
                } else {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-105269599, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i115) {
                            ComposerKt.sourceInformation(composer2, "C201@9082L5,203@9141L213,207@9371L168:NavigationRail.kt#uh7d8r");
                            if ((i115 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-105269599, i115, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:201)");
                                }
                                ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColorsColors.m2636textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationRailTokens.INSTANCE.getLabelTextFont(), composer2, 6), function5, composer2, 0);
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
                function6 = function5;
                Modifier modifierM1065defaultMinSizeVpY3zN4$default12 = SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationRailItemHeight, 1, null);
                float f13 = NavigationRailItemWidth;
                Modifier modifierM1087widthInVpY3zN4$default12 = SizeKt.m1087widthInVpY3zN4$default(modifierM1065defaultMinSizeVpY3zN4$default12, f13, 0.0f, 2, null);
                Alignment center12 = Alignment.INSTANCE.getCenter();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy12 = BoxKt.maybeCachedBoxMeasurePolicy(center12, true);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap12 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier12 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM1087widthInVpY3zN4$default12);
                Modifier modifier14 = companion;
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                mutableInteractionSource4 = mutableInteractionSource3;
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 584386773, "C231@10130L157,*240@10571L7,246@10874L128,260@11450L261,268@11760L280,282@12301L27,276@12050L289:NavigationRail.kt#uh7d8r");
                if (z) {
                    f = 1.0f;
                } else {
                    f = 0.0f;
                }
                final NavigationRailItemColors navigationRailItemColors116 = navigationRailItemColorsColors;
                stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(150, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
                ProvidableCompositionLocal<Density> localDensity12 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume12 = composerStartRestartGroup.consume(localDensity12);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Density density12 = (Density) objConsume12;
                jOffset = OffsetKt.Offset((density12.roundToPx-0680j_4(f13) - density12.roundToPx-0680j_4(NavigationRailTokens.INSTANCE.m3694getActiveIndicatorWidthD9Ej5fM())) / 2, 0.0f);
                Unit unit12 = Unit.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119672869, "CC(remember):NavigationRail.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                final MappedInteractionSource mappedInteractionSource12 = (MappedInteractionSource) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (function6 != null) {
                    composerStartRestartGroup.startReplaceGroup(585295320);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "252@11124L5");
                    value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getActiveIndicatorShape(), composerStartRestartGroup, 6);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(585379857);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "254@11216L5");
                    value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getNoLabelActiveIndicatorShape(), composerStartRestartGroup, 6);
                    composerStartRestartGroup.endReplaceGroup();
                }
                ComposableLambda composableLambdaRememberComposableLambda1116 = ComposableLambdaKt.rememberComposableLambda(211026382, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i115) {
                        ComposerKt.sourceInformation(composer2, "C264@11646L32,261@11468L229:NavigationRail.kt#uh7d8r");
                        if ((i115 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(211026382, i115, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:261)");
                            }
                            BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), value), mappedInteractionSource12, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
                ComposableLambda composableLambdaRememberComposableLambda1117 = ComposableLambdaKt.rememberComposableLambda(-1862011490, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i115) {
                        ComposerKt.sourceInformation(composer2, "C271@11882L35,269@11778L248:NavigationRail.kt#uh7d8r");
                        if ((i115 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1862011490, i115, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:269)");
                            }
                            Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                            ComposerKt.sourceInformationMarkerStart(composer2, -425107715, "CC(remember):NavigationRail.kt#9igjgp");
                            boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                            final State<Float> state = stateAnimateFloatAsState;
                            Object objRememberedValue4 = composer2.rememberedValue();
                            if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue4 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
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
                                composer2.updateRememberedValue(objRememberedValue4);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue4), navigationRailItemColors116.getSelectedIndicatorColor(), value), composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119627306, "CC(remember):NavigationRail.kt#9igjgp");
                zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged2) {
                    objRememberedValue2 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2644invoke() {
                            return stateAnimateFloatAsState.getValue();
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2644invoke() {
                            return stateAnimateFloatAsState.getValue();
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                NavigationRailItemLayout(composableLambdaRememberComposableLambda1116, composableLambdaRememberComposableLambda1117, composableLambdaRememberComposableLambda1115, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue2, composerStartRestartGroup, (57344 & (i114 >> 6)) | 438);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier14;
                function7 = function6;
                z7 = z6;
                navigationRailItemColors2 = navigationRailItemColors116;
                z8 = z4;
                mutableInteractionSource5 = mutableInteractionSource2;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
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
                        navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        navigationRailItemColorsColors = navigationRailItemColors;
                    }
                    if (i10 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    z6 = z5;
                } else {
                    if (i12 != 0) {
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
                        navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        navigationRailItemColorsColors = navigationRailItemColors;
                    }
                    if (i10 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    z6 = z5;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1533971045, i3, -1, "androidx.compose.material3.NavigationRailItem (NavigationRail.kt:181)");
                }
                composerStartRestartGroup.startReplaceGroup(-782588008);
                ComposerKt.sourceInformation(composerStartRestartGroup, "183@8207L39");
                if (mutableInteractionSource2 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -782587357, "CC(remember):NavigationRail.kt#9igjgp");
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue3 = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue3;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                composerStartRestartGroup.endReplaceGroup();
                final NavigationRailItemColors navigationRailItemColors117 = navigationRailItemColorsColors;
                final boolean z1113 = z6;
                final Function2<? super Composer, ? super Integer, Unit> function110 = function5;
                final boolean z1114 = z4;
                int i115 = i3;
                ComposableLambda composableLambdaRememberComposableLambda1118 = ComposableLambdaKt.rememberComposableLambda(-1023357515, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i116) {
                        ComposerKt.sourceInformation(composer2, "C187@8335L201,193@8718L193:NavigationRail.kt#uh7d8r");
                        if ((i116 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1023357515, i116, -1, "androidx.compose.material3.NavigationRailItem.<anonymous> (NavigationRail.kt:186)");
                            }
                            State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColors117.m2635iconColorWaAFU9c$material3_release(z, z1113), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12);
                            Modifier.Companion companionClearAndSetSemantics = (function110 == null || !(z1114 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                }

                                public Object invoke(Object obj) {
                                    invoke((SemanticsPropertyReceiver) obj);
                                    return Unit.INSTANCE;
                                }
                            });
                            Function2<Composer, Integer, Unit> function111 = function2;
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
                            ComposerKt.sourceInformationMarkerStart(composer2, -296474437, "C194@8819L78:NavigationRail.kt#uh7d8r");
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
                composerStartRestartGroup.startReplaceGroup(-782561860);
                ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9017L536");
                if (function5 == null) {
                    composableLambdaRememberComposableLambda = null;
                } else {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-105269599, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i116) {
                            ComposerKt.sourceInformation(composer2, "C201@9082L5,203@9141L213,207@9371L168:NavigationRail.kt#uh7d8r");
                            if ((i116 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-105269599, i116, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:201)");
                                }
                                ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColorsColors.m2636textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationRailTokens.INSTANCE.getLabelTextFont(), composer2, 6), function5, composer2, 0);
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
                function6 = function5;
                Modifier modifierM1065defaultMinSizeVpY3zN4$default13 = SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationRailItemHeight, 1, null);
                float f14 = NavigationRailItemWidth;
                Modifier modifierM1087widthInVpY3zN4$default13 = SizeKt.m1087widthInVpY3zN4$default(modifierM1065defaultMinSizeVpY3zN4$default13, f14, 0.0f, 2, null);
                Alignment center13 = Alignment.INSTANCE.getCenter();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy13 = BoxKt.maybeCachedBoxMeasurePolicy(center13, true);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap13 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier13 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM1087widthInVpY3zN4$default13);
                Modifier modifier15 = companion;
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                mutableInteractionSource4 = mutableInteractionSource3;
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 584386773, "C231@10130L157,*240@10571L7,246@10874L128,260@11450L261,268@11760L280,282@12301L27,276@12050L289:NavigationRail.kt#uh7d8r");
                if (z) {
                    f = 1.0f;
                } else {
                    f = 0.0f;
                }
                final NavigationRailItemColors navigationRailItemColors118 = navigationRailItemColorsColors;
                stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(150, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
                ProvidableCompositionLocal<Density> localDensity13 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume13 = composerStartRestartGroup.consume(localDensity13);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Density density13 = (Density) objConsume13;
                jOffset = OffsetKt.Offset((density13.roundToPx-0680j_4(f14) - density13.roundToPx-0680j_4(NavigationRailTokens.INSTANCE.m3694getActiveIndicatorWidthD9Ej5fM())) / 2, 0.0f);
                Unit unit13 = Unit.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119672869, "CC(remember):NavigationRail.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                final MappedInteractionSource mappedInteractionSource13 = (MappedInteractionSource) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (function6 != null) {
                    composerStartRestartGroup.startReplaceGroup(585295320);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "252@11124L5");
                    value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getActiveIndicatorShape(), composerStartRestartGroup, 6);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(585379857);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "254@11216L5");
                    value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getNoLabelActiveIndicatorShape(), composerStartRestartGroup, 6);
                    composerStartRestartGroup.endReplaceGroup();
                }
                ComposableLambda composableLambdaRememberComposableLambda1119 = ComposableLambdaKt.rememberComposableLambda(211026382, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i116) {
                        ComposerKt.sourceInformation(composer2, "C264@11646L32,261@11468L229:NavigationRail.kt#uh7d8r");
                        if ((i116 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(211026382, i116, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:261)");
                            }
                            BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), value), mappedInteractionSource13, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
                ComposableLambda composableLambdaRememberComposableLambda11110 = ComposableLambdaKt.rememberComposableLambda(-1862011490, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i116) {
                        ComposerKt.sourceInformation(composer2, "C271@11882L35,269@11778L248:NavigationRail.kt#uh7d8r");
                        if ((i116 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1862011490, i116, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:269)");
                            }
                            Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                            ComposerKt.sourceInformationMarkerStart(composer2, -425107715, "CC(remember):NavigationRail.kt#9igjgp");
                            boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                            final State<Float> state = stateAnimateFloatAsState;
                            Object objRememberedValue4 = composer2.rememberedValue();
                            if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue4 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
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
                                composer2.updateRememberedValue(objRememberedValue4);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue4), navigationRailItemColors118.getSelectedIndicatorColor(), value), composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119627306, "CC(remember):NavigationRail.kt#9igjgp");
                zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged2) {
                    objRememberedValue2 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2644invoke() {
                            return stateAnimateFloatAsState.getValue();
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2644invoke() {
                            return stateAnimateFloatAsState.getValue();
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                NavigationRailItemLayout(composableLambdaRememberComposableLambda1119, composableLambdaRememberComposableLambda11110, composableLambdaRememberComposableLambda1118, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue2, composerStartRestartGroup, (57344 & (i115 >> 6)) | 438);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier15;
                function7 = function6;
                z7 = z6;
                navigationRailItemColors2 = navigationRailItemColors118;
                z8 = z4;
                mutableInteractionSource5 = mutableInteractionSource2;
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

                    public final void invoke(Composer composer2, int i116) {
                        NavigationRailKt.NavigationRailItem(z, function0, function2, modifier2, z7, function7, z8, navigationRailItemColors2, mutableInteractionSource5, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 196608;
        function4 = function3;
        i8 = i2 & 64;
        if (i8 != 0) {
            i3 |= 1572864;
            z4 = z3;
        } else {
            z4 = z3;
            if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changed(z4)) {
                    i9 = 1048576;
                } else {
                    i9 = 524288;
                }
                i3 |= i9;
            }
        }
        if ((i & 12582912) != 0) {
            i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(navigationRailItemColors)) ? 4194304 : 8388608;
        }
        i10 = i2 & Fields.RotationX;
        if (i10 != 0) {
            i3 |= 100663296;
        } else if ((i & 100663296) == 0) {
            if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                i11 = 67108864;
            } else {
                i11 = 33554432;
            }
            i3 |= i11;
        }
        if ((i3 & 38347923) == 38347922) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i12 != 0) {
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
                    navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    navigationRailItemColorsColors = navigationRailItemColors;
                }
                if (i10 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
                z6 = z5;
            } else {
                if (i12 != 0) {
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
                    navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    navigationRailItemColorsColors = navigationRailItemColors;
                }
                if (i10 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
                z6 = z5;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1533971045, i3, -1, "androidx.compose.material3.NavigationRailItem (NavigationRail.kt:181)");
            }
            composerStartRestartGroup.startReplaceGroup(-782588008);
            ComposerKt.sourceInformation(composerStartRestartGroup, "183@8207L39");
            if (mutableInteractionSource2 == null) {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -782587357, "CC(remember):NavigationRail.kt#9igjgp");
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue3 = InteractionSourceKt.MutableInteractionSource();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue3;
            } else {
                mutableInteractionSource3 = mutableInteractionSource2;
            }
            composerStartRestartGroup.endReplaceGroup();
            final NavigationRailItemColors navigationRailItemColors119 = navigationRailItemColorsColors;
            final boolean z1115 = z6;
            final Function2<? super Composer, ? super Integer, Unit> function111 = function5;
            final boolean z1116 = z4;
            int i116 = i3;
            ComposableLambda composableLambdaRememberComposableLambda11111 = ComposableLambdaKt.rememberComposableLambda(-1023357515, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i117) {
                    ComposerKt.sourceInformation(composer2, "C187@8335L201,193@8718L193:NavigationRail.kt#uh7d8r");
                    if ((i117 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1023357515, i117, -1, "androidx.compose.material3.NavigationRailItem.<anonymous> (NavigationRail.kt:186)");
                        }
                        State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColors119.m2635iconColorWaAFU9c$material3_release(z, z1115), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12);
                        Modifier.Companion companionClearAndSetSemantics = (function111 == null || !(z1116 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                            public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            }

                            public Object invoke(Object obj) {
                                invoke((SemanticsPropertyReceiver) obj);
                                return Unit.INSTANCE;
                            }
                        });
                        Function2<Composer, Integer, Unit> function112 = function2;
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
                        ComposerKt.sourceInformationMarkerStart(composer2, -296474437, "C194@8819L78:NavigationRail.kt#uh7d8r");
                        CompositionLocalKt.CompositionLocalProvider(ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(invoke$lambda$0(stateM387animateColorAsStateeuL9pac))), function112, composer2, ProvidedValue.$stable);
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
            composerStartRestartGroup.startReplaceGroup(-782561860);
            ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9017L536");
            if (function5 == null) {
                composableLambdaRememberComposableLambda = null;
            } else {
                composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-105269599, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i117) {
                        ComposerKt.sourceInformation(composer2, "C201@9082L5,203@9141L213,207@9371L168:NavigationRail.kt#uh7d8r");
                        if ((i117 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-105269599, i117, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:201)");
                            }
                            ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColorsColors.m2636textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationRailTokens.INSTANCE.getLabelTextFont(), composer2, 6), function5, composer2, 0);
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
            function6 = function5;
            Modifier modifierM1065defaultMinSizeVpY3zN4$default14 = SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationRailItemHeight, 1, null);
            float f15 = NavigationRailItemWidth;
            Modifier modifierM1087widthInVpY3zN4$default14 = SizeKt.m1087widthInVpY3zN4$default(modifierM1065defaultMinSizeVpY3zN4$default14, f15, 0.0f, 2, null);
            Alignment center14 = Alignment.INSTANCE.getCenter();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy14 = BoxKt.maybeCachedBoxMeasurePolicy(center14, true);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
            currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap14 = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier14 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM1087widthInVpY3zN4$default14);
            Modifier modifier16 = companion;
            constructor = ComposeUiNode.INSTANCE.getConstructor();
            mutableInteractionSource4 = mutableInteractionSource3;
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
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 584386773, "C231@10130L157,*240@10571L7,246@10874L128,260@11450L261,268@11760L280,282@12301L27,276@12050L289:NavigationRail.kt#uh7d8r");
            if (z) {
                f = 1.0f;
            } else {
                f = 0.0f;
            }
            final NavigationRailItemColors navigationRailItemColors1110 = navigationRailItemColorsColors;
            stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(150, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
            ProvidableCompositionLocal<Density> localDensity14 = CompositionLocalsKt.getLocalDensity();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume14 = composerStartRestartGroup.consume(localDensity14);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Density density14 = (Density) objConsume14;
            jOffset = OffsetKt.Offset((density14.roundToPx-0680j_4(f15) - density14.roundToPx-0680j_4(NavigationRailTokens.INSTANCE.m3694getActiveIndicatorWidthD9Ej5fM())) / 2, 0.0f);
            Unit unit14 = Unit.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119672869, "CC(remember):NavigationRail.kt#9igjgp");
            zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            final MappedInteractionSource mappedInteractionSource14 = (MappedInteractionSource) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (function6 != null) {
                composerStartRestartGroup.startReplaceGroup(585295320);
                ComposerKt.sourceInformation(composerStartRestartGroup, "252@11124L5");
                value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getActiveIndicatorShape(), composerStartRestartGroup, 6);
                composerStartRestartGroup.endReplaceGroup();
            } else {
                composerStartRestartGroup.startReplaceGroup(585379857);
                ComposerKt.sourceInformation(composerStartRestartGroup, "254@11216L5");
                value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getNoLabelActiveIndicatorShape(), composerStartRestartGroup, 6);
                composerStartRestartGroup.endReplaceGroup();
            }
            ComposableLambda composableLambdaRememberComposableLambda11112 = ComposableLambdaKt.rememberComposableLambda(211026382, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i117) {
                    ComposerKt.sourceInformation(composer2, "C264@11646L32,261@11468L229:NavigationRail.kt#uh7d8r");
                    if ((i117 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(211026382, i117, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:261)");
                        }
                        BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), value), mappedInteractionSource14, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer2.skipToGroupEnd();
                }
            }, composerStartRestartGroup, 54);
            ComposableLambda composableLambdaRememberComposableLambda11113 = ComposableLambdaKt.rememberComposableLambda(-1862011490, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i117) {
                    ComposerKt.sourceInformation(composer2, "C271@11882L35,269@11778L248:NavigationRail.kt#uh7d8r");
                    if ((i117 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1862011490, i117, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:269)");
                        }
                        Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                        ComposerKt.sourceInformationMarkerStart(composer2, -425107715, "CC(remember):NavigationRail.kt#9igjgp");
                        boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                        final State<Float> state = stateAnimateFloatAsState;
                        Object objRememberedValue4 = composer2.rememberedValue();
                        if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue4 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
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
                            composer2.updateRememberedValue(objRememberedValue4);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue4), navigationRailItemColors1110.getSelectedIndicatorColor(), value), composer2, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer2.skipToGroupEnd();
                }
            }, composerStartRestartGroup, 54);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119627306, "CC(remember):NavigationRail.kt#9igjgp");
            zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!zChanged2) {
                objRememberedValue2 = (Function0) new Function0<Float>() {
                    {
                        super(0);
                    }

                    public final Float m2644invoke() {
                        return stateAnimateFloatAsState.getValue();
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            } else {
                objRememberedValue2 = (Function0) new Function0<Float>() {
                    {
                        super(0);
                    }

                    public final Float m2644invoke() {
                        return stateAnimateFloatAsState.getValue();
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            NavigationRailItemLayout(composableLambdaRememberComposableLambda11112, composableLambdaRememberComposableLambda11113, composableLambdaRememberComposableLambda11111, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue2, composerStartRestartGroup, (57344 & (i116 >> 6)) | 438);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier2 = modifier16;
            function7 = function6;
            z7 = z6;
            navigationRailItemColors2 = navigationRailItemColors1110;
            z8 = z4;
            mutableInteractionSource5 = mutableInteractionSource2;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i12 != 0) {
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
                    navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    navigationRailItemColorsColors = navigationRailItemColors;
                }
                if (i10 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
                z6 = z5;
            } else {
                if (i12 != 0) {
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
                    navigationRailItemColorsColors = NavigationRailItemDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    navigationRailItemColorsColors = navigationRailItemColors;
                }
                if (i10 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
                z6 = z5;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1533971045, i3, -1, "androidx.compose.material3.NavigationRailItem (NavigationRail.kt:181)");
            }
            composerStartRestartGroup.startReplaceGroup(-782588008);
            ComposerKt.sourceInformation(composerStartRestartGroup, "183@8207L39");
            if (mutableInteractionSource2 == null) {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -782587357, "CC(remember):NavigationRail.kt#9igjgp");
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue3 = InteractionSourceKt.MutableInteractionSource();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue3;
            } else {
                mutableInteractionSource3 = mutableInteractionSource2;
            }
            composerStartRestartGroup.endReplaceGroup();
            final NavigationRailItemColors navigationRailItemColors1111 = navigationRailItemColorsColors;
            final boolean z1117 = z6;
            final Function2<? super Composer, ? super Integer, Unit> function112 = function5;
            final boolean z1118 = z4;
            int i117 = i3;
            ComposableLambda composableLambdaRememberComposableLambda11114 = ComposableLambdaKt.rememberComposableLambda(-1023357515, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i118) {
                    ComposerKt.sourceInformation(composer2, "C187@8335L201,193@8718L193:NavigationRail.kt#uh7d8r");
                    if ((i118 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1023357515, i118, -1, "androidx.compose.material3.NavigationRailItem.<anonymous> (NavigationRail.kt:186)");
                        }
                        State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColors1111.m2635iconColorWaAFU9c$material3_release(z, z1117), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12);
                        Modifier.Companion companionClearAndSetSemantics = (function112 == null || !(z1118 || z)) ? Modifier.INSTANCE : SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                            public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            }

                            public Object invoke(Object obj) {
                                invoke((SemanticsPropertyReceiver) obj);
                                return Unit.INSTANCE;
                            }
                        });
                        Function2<Composer, Integer, Unit> function113 = function2;
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
                        ComposerKt.sourceInformationMarkerStart(composer2, -296474437, "C194@8819L78:NavigationRail.kt#uh7d8r");
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
            composerStartRestartGroup.startReplaceGroup(-782561860);
            ComposerKt.sourceInformation(composerStartRestartGroup, "*200@9017L536");
            if (function5 == null) {
                composableLambdaRememberComposableLambda = null;
            } else {
                composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-105269599, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i118) {
                        ComposerKt.sourceInformation(composer2, "C201@9082L5,203@9141L213,207@9371L168:NavigationRail.kt#uh7d8r");
                        if ((i118 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-105269599, i118, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:201)");
                            }
                            ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(invoke$lambda$0(SingleValueAnimationKt.m387animateColorAsStateeuL9pac(navigationRailItemColorsColors.m2636textColorWaAFU9c$material3_release(z, z6), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12)), TypographyKt.getValue(NavigationRailTokens.INSTANCE.getLabelTextFont(), composer2, 6), function5, composer2, 0);
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
            function6 = function5;
            Modifier modifierM1065defaultMinSizeVpY3zN4$default15 = SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableKt.m1362selectableO2vRcR0(companion, z, mutableInteractionSource3, null, z6, Role.m6604boximpl(Role.INSTANCE.m6617getTabo7Vup1c()), function0), 0.0f, NavigationRailItemHeight, 1, null);
            float f16 = NavigationRailItemWidth;
            Modifier modifierM1087widthInVpY3zN4$default15 = SizeKt.m1087widthInVpY3zN4$default(modifierM1065defaultMinSizeVpY3zN4$default15, f16, 0.0f, 2, null);
            Alignment center15 = Alignment.INSTANCE.getCenter();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy15 = BoxKt.maybeCachedBoxMeasurePolicy(center15, true);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
            currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap15 = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier15 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM1087widthInVpY3zN4$default15);
            Modifier modifier17 = companion;
            constructor = ComposeUiNode.INSTANCE.getConstructor();
            mutableInteractionSource4 = mutableInteractionSource3;
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
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 584386773, "C231@10130L157,*240@10571L7,246@10874L128,260@11450L261,268@11760L280,282@12301L27,276@12050L289:NavigationRail.kt#uh7d8r");
            if (z) {
                f = 1.0f;
            } else {
                f = 0.0f;
            }
            final NavigationRailItemColors navigationRailItemColors1112 = navigationRailItemColorsColors;
            stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(f, AnimationSpecKt.tween$default(150, 0, null, 6, null), 0.0f, null, null, composerStartRestartGroup, 48, 28);
            ProvidableCompositionLocal<Density> localDensity15 = CompositionLocalsKt.getLocalDensity();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume15 = composerStartRestartGroup.consume(localDensity15);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Density density15 = (Density) objConsume15;
            jOffset = OffsetKt.Offset((density15.roundToPx-0680j_4(f16) - density15.roundToPx-0680j_4(NavigationRailTokens.INSTANCE.m3694getActiveIndicatorWidthD9Ej5fM())) / 2, 0.0f);
            Unit unit15 = Unit.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119672869, "CC(remember):NavigationRail.kt#9igjgp");
            zChanged = composerStartRestartGroup.changed(mutableInteractionSource4) | composerStartRestartGroup.changed(jOffset);
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = new MappedInteractionSource(mutableInteractionSource4, jOffset, null);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            final MappedInteractionSource mappedInteractionSource15 = (MappedInteractionSource) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (function6 != null) {
                composerStartRestartGroup.startReplaceGroup(585295320);
                ComposerKt.sourceInformation(composerStartRestartGroup, "252@11124L5");
                value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getActiveIndicatorShape(), composerStartRestartGroup, 6);
                composerStartRestartGroup.endReplaceGroup();
            } else {
                composerStartRestartGroup.startReplaceGroup(585379857);
                ComposerKt.sourceInformation(composerStartRestartGroup, "254@11216L5");
                value = ShapesKt.getValue(NavigationRailTokens.INSTANCE.getNoLabelActiveIndicatorShape(), composerStartRestartGroup, 6);
                composerStartRestartGroup.endReplaceGroup();
            }
            ComposableLambda composableLambdaRememberComposableLambda11115 = ComposableLambdaKt.rememberComposableLambda(211026382, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i118) {
                    ComposerKt.sourceInformation(composer2, "C264@11646L32,261@11468L229:NavigationRail.kt#uh7d8r");
                    if ((i118 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(211026382, i118, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:261)");
                        }
                        BoxKt.Box(IndicationKt.indication(ClipKt.clip(LayoutIdKt.layoutId(Modifier.INSTANCE, "indicatorRipple"), value), mappedInteractionSource15, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composer2, 0, 7)), composer2, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer2.skipToGroupEnd();
                }
            }, composerStartRestartGroup, 54);
            ComposableLambda composableLambdaRememberComposableLambda11116 = ComposableLambdaKt.rememberComposableLambda(-1862011490, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i118) {
                    ComposerKt.sourceInformation(composer2, "C271@11882L35,269@11778L248:NavigationRail.kt#uh7d8r");
                    if ((i118 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1862011490, i118, -1, "androidx.compose.material3.NavigationRailItem.<anonymous>.<anonymous> (NavigationRail.kt:269)");
                        }
                        Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "indicator");
                        ComposerKt.sourceInformationMarkerStart(composer2, -425107715, "CC(remember):NavigationRail.kt#9igjgp");
                        boolean zChanged3 = composer2.changed(stateAnimateFloatAsState);
                        final State<Float> state = stateAnimateFloatAsState;
                        Object objRememberedValue4 = composer2.rememberedValue();
                        if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue4 = (Function1) new Function1<GraphicsLayerScope, Unit>() {
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
                            composer2.updateRememberedValue(objRememberedValue4);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        BoxKt.Box(BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId, (Function1) objRememberedValue4), navigationRailItemColors1112.getSelectedIndicatorColor(), value), composer2, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer2.skipToGroupEnd();
                }
            }, composerStartRestartGroup, 54);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -119627306, "CC(remember):NavigationRail.kt#9igjgp");
            zChanged2 = composerStartRestartGroup.changed(stateAnimateFloatAsState);
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!zChanged2) {
                objRememberedValue2 = (Function0) new Function0<Float>() {
                    {
                        super(0);
                    }

                    public final Float m2644invoke() {
                        return stateAnimateFloatAsState.getValue();
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            } else {
                objRememberedValue2 = (Function0) new Function0<Float>() {
                    {
                        super(0);
                    }

                    public final Float m2644invoke() {
                        return stateAnimateFloatAsState.getValue();
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            NavigationRailItemLayout(composableLambdaRememberComposableLambda11115, composableLambdaRememberComposableLambda11116, composableLambdaRememberComposableLambda11114, composableLambdaRememberComposableLambda, z4, (Function0) objRememberedValue2, composerStartRestartGroup, (57344 & (i117 >> 6)) | 438);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier2 = modifier17;
            function7 = function6;
            z7 = z6;
            navigationRailItemColors2 = navigationRailItemColors1112;
            z8 = z4;
            mutableInteractionSource5 = mutableInteractionSource2;
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

                public final void invoke(Composer composer2, int i118) {
                    NavigationRailKt.NavigationRailItem(z, function0, function2, modifier2, z7, function7, z8, navigationRailItemColors2, mutableInteractionSource5, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void NavigationRailItemLayout(final Function2<? super Composer, ? super Integer, Unit> function2, final Function2<? super Composer, ? super Integer, Unit> function3, final Function2<? super Composer, ? super Integer, Unit> function4, final Function2<? super Composer, ? super Integer, Unit> function5, final boolean z, final Function0<Float> function0, Composer composer, final int i) {
        int i2;
        int i3;
        boolean z2;
        int i4;
        Object obj;
        Composer composerStartRestartGroup = composer.startRestartGroup(1498399348);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(NavigationRailItemLayout)P(4,3,2,5)530@23300L1924,515@22904L2320:NavigationRail.kt#uh7d8r");
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
                ComposerKt.traceEventStart(1498399348, i2, -1, "androidx.compose.material3.NavigationRailItemLayout (NavigationRail.kt:514)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1881815062, "CC(remember):NavigationRail.kt#9igjgp");
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
                                int width = placeableMo6026measureBRTryo1.getWidth() + measureScope.roundToPx-0680j_4(Dp.constructor-impl(NavigationRailKt.IndicatorHorizontalPadding * f));
                                int iRoundToInt = MathKt.roundToInt(width * fFloatValue);
                                int height = placeableMo6026measureBRTryo1.getHeight() + measureScope.roundToPx-0680j_4(Dp.constructor-impl((function5 == null ? NavigationRailKt.IndicatorVerticalPaddingNoLabel : NavigationRailKt.IndicatorVerticalPaddingWithLabel) * f));
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
                                            return NavigationRailKt.m2642placeIconX9ElhV4(measureScope, placeableMo6026measureBRTryo1, placeableMo6026measureBRTryo2, placeableMo6026measureBRTryo3, j);
                                        }
                                        Intrinsics.checkNotNull(placeableMo6026measureBRTryo0);
                                        return NavigationRailKt.m2643placeLabelAndIconzUg2_y0(measureScope, placeableMo6026measureBRTryo0, placeableMo6026measureBRTryo1, placeableMo6026measureBRTryo2, placeableMo6026measureBRTryo3, j, z, fFloatValue);
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
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2082816907, "C516@22921L17,517@22947L11,519@22968L50:NavigationRail.kt#uh7d8r");
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
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 402566553, "C519@23010L6:NavigationRail.kt#uh7d8r");
            function4.invoke(composerStartRestartGroup, Integer.valueOf((i2 >> 6) & 14));
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.startReplaceGroup(2145400941);
            ComposerKt.sourceInformation(composerStartRestartGroup, "523@23132L96,522@23061L221");
            if (function5 != null) {
                Modifier modifierLayoutId2 = LayoutIdKt.layoutId(Modifier.INSTANCE, LabelLayoutIdTag);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2145404101, "CC(remember):NavigationRail.kt#9igjgp");
                if (i6 == 16384) {
                    i3 = Fields.RenderEffect;
                    z2 = true;
                } else {
                    i3 = Fields.RenderEffect;
                    z2 = false;
                }
                boolean z4 = z2 | (i5 == i3);
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
                Modifier modifierGraphicsLayer = GraphicsLayerModifierKt.graphicsLayer(modifierLayoutId2, (Function1) obj);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap3 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierGraphicsLayer);
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 402815576, "C527@23261L7:NavigationRail.kt#uh7d8r");
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
                    NavigationRailKt.NavigationRailItemLayout(function2, function3, function4, function5, z, function0, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1));
                }
            });
        }
    }

    public static final MeasureResult m2642placeIconX9ElhV4(MeasureScope measureScope, final Placeable placeable, final Placeable placeable2, final Placeable placeable3, long j) {
        final int i = ConstraintsKt.constrainWidth-K40F9xA(j, Math.max(placeable.getWidth(), Math.max(placeable2.getWidth(), placeable3 != null ? placeable3.getWidth() : 0)));
        final int i2 = ConstraintsKt.constrainHeight-K40F9xA(j, measureScope.roundToPx-0680j_4(NavigationRailItemHeight));
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

    public static final MeasureResult m2643placeLabelAndIconzUg2_y0(final MeasureScope measureScope, final Placeable placeable, final Placeable placeable2, final Placeable placeable3, final Placeable placeable4, long j, final boolean z, final float f) {
        float height = placeable2.getHeight();
        float f2 = IndicatorVerticalPaddingWithLabel;
        float f3 = height + measureScope.toPx-0680j_4(f2);
        float f4 = NavigationRailItemVerticalPadding;
        float f5 = f3 + measureScope.toPx-0680j_4(f4) + placeable.getHeight();
        float f6 = 2;
        final float fCoerceAtLeast = RangesKt.coerceAtLeast((Constraints.getMinHeight-impl(j) - f5) / f6, measureScope.toPx-0680j_4(f2));
        float f7 = f5 + (fCoerceAtLeast * f6);
        final float height2 = ((z ? fCoerceAtLeast : (f7 - placeable2.getHeight()) / f6) - fCoerceAtLeast) * (1 - f);
        final float height3 = placeable2.getHeight() + fCoerceAtLeast + measureScope.toPx-0680j_4(f2) + measureScope.toPx-0680j_4(f4);
        final int i = ConstraintsKt.constrainWidth-K40F9xA(j, Math.max(placeable2.getWidth(), Math.max(placeable.getWidth(), placeable4 != null ? placeable4.getWidth() : 0)));
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
                    int i2 = i;
                    float f9 = fCoerceAtLeast;
                    MeasureScope measureScope2 = measureScope;
                    Placeable.PlacementScope.placeRelative$default(placementScope, placeable5, (i2 - placeable5.getWidth()) / 2, MathKt.roundToInt((f9 - measureScope2.toPx-0680j_4(NavigationRailKt.IndicatorVerticalPaddingWithLabel)) + height2), 0.0f, 4, null);
                }
                if (z || f != 0.0f) {
                    Placeable.PlacementScope.placeRelative$default(placementScope, placeable, width, MathKt.roundToInt(height3 + height2), 0.0f, 4, null);
                }
                Placeable.PlacementScope.placeRelative$default(placementScope, placeable2, width2, MathKt.roundToInt(fCoerceAtLeast + height2), 0.0f, 4, null);
                Placeable.PlacementScope.placeRelative$default(placementScope, placeable3, width3, MathKt.roundToInt(f8 + height2), 0.0f, 4, null);
            }
        }, 4, null);
    }

    public static final float getNavigationRailVerticalPadding() {
        return NavigationRailVerticalPadding;
    }

    public static final float getNavigationRailItemWidth() {
        return NavigationRailItemWidth;
    }

    public static final float getNavigationRailItemHeight() {
        return NavigationRailItemHeight;
    }

    public static final float getNavigationRailItemVerticalPadding() {
        return NavigationRailItemVerticalPadding;
    }

    static {
        float f = 4;
        NavigationRailVerticalPadding = Dp.constructor-impl(f);
        NavigationRailItemVerticalPadding = Dp.constructor-impl(f);
        float f2 = 2;
        IndicatorHorizontalPadding = Dp.constructor-impl(Dp.constructor-impl(NavigationRailTokens.INSTANCE.m3694getActiveIndicatorWidthD9Ej5fM() - NavigationRailTokens.INSTANCE.m3697getIconSizeD9Ej5fM()) / f2);
        IndicatorVerticalPaddingWithLabel = Dp.constructor-impl(Dp.constructor-impl(NavigationRailTokens.INSTANCE.m3693getActiveIndicatorHeightD9Ej5fM() - NavigationRailTokens.INSTANCE.m3697getIconSizeD9Ej5fM()) / f2);
        IndicatorVerticalPaddingNoLabel = Dp.constructor-impl(Dp.constructor-impl(NavigationRailTokens.INSTANCE.m3699getNoLabelActiveIndicatorHeightD9Ej5fM() - NavigationRailTokens.INSTANCE.m3697getIconSizeD9Ej5fM()) / f2);
    }
}
