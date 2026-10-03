package zendesk.p026ui.android.conversation.aidisclaimer;

import androidx.compose.foundation.FocusableKt;
import androidx.compose.foundation.ImageKt;
import androidx.compose.foundation.interaction.MutableInteractionSource;
import androidx.compose.foundation.layout.Arrangement;
import androidx.compose.foundation.layout.PaddingKt;
import androidx.compose.foundation.layout.RowKt;
import androidx.compose.foundation.layout.RowScope;
import androidx.compose.foundation.layout.RowScopeInstance;
import androidx.compose.material3.TextKt;
import androidx.compose.runtime.Applier;
import androidx.compose.runtime.ComposablesKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocal;
import androidx.compose.runtime.CompositionLocalMap;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.State;
import androidx.compose.runtime.Updater;
import androidx.compose.ui.Alignment;
import androidx.compose.ui.ComposedModifierKt;
import androidx.compose.ui.Modifier;
import androidx.compose.ui.graphics.ColorFilter;
import androidx.compose.ui.graphics.Shadow;
import androidx.compose.ui.graphics.drawscope.DrawStyle;
import androidx.compose.ui.layout.ContentScale;
import androidx.compose.ui.layout.LayoutModifierKt;
import androidx.compose.ui.layout.Measurable;
import androidx.compose.ui.layout.MeasurePolicy;
import androidx.compose.ui.layout.MeasureResult;
import androidx.compose.ui.layout.MeasureScope;
import androidx.compose.ui.layout.Placeable;
import androidx.compose.ui.node.ComposeUiNode;
import androidx.compose.ui.platform.CompositionLocalsKt;
import androidx.compose.ui.platform.TestTagKt;
import androidx.compose.ui.res.PainterResources_androidKt;
import androidx.compose.ui.res.PrimitiveResources_androidKt;
import androidx.compose.ui.res.StringResources_androidKt;
import androidx.compose.ui.text.PlatformTextStyle;
import androidx.compose.ui.text.TextMeasurer;
import androidx.compose.ui.text.TextMeasurerHelperKt;
import androidx.compose.ui.text.TextStyle;
import androidx.compose.ui.text.font.FontFamily;
import androidx.compose.ui.text.font.FontStyle;
import androidx.compose.ui.text.font.FontSynthesis;
import androidx.compose.ui.text.font.FontWeight;
import androidx.compose.ui.text.intl.LocaleList;
import androidx.compose.ui.text.style.BaselineShift;
import androidx.compose.ui.text.style.LineHeightStyle;
import androidx.compose.ui.text.style.TextAlign;
import androidx.compose.ui.text.style.TextDecoration;
import androidx.compose.ui.text.style.TextGeometricTransform;
import androidx.compose.ui.text.style.TextIndent;
import androidx.compose.ui.text.style.TextMotion;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.IntSize;
import androidx.compose.ui.unit.LayoutDirection;
import androidx.compose.ui.unit.TextUnitKt;
import java.util.Map;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Intrinsics;
import zendesk.ui.android.R;
import zendesk.ui.android.compose.theme.ThemeKt;
import zendesk.ui.android.compose.utils.FontUtilsKt;
import zendesk.ui.android.compose.utils.PreviewThemes;

@Metadata(m17d1 = {"\u0000,\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\b\u001a@\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\u00072\b\b\u0002\u0010\t\u001a\u00020\n2\b\b\u0002\u0010\u000b\u001a\u00020\u00012\b\b\u0002\u0010\f\u001a\u00020\rH\u0007ø\u0001\u0000¢\u0006\u0004\b\u000e\u0010\u000f\u001a\r\u0010\u0010\u001a\u00020\u0005H\u0003¢\u0006\u0002\u0010\u0011\"\u0014\u0010\u0000\u001a\u00020\u0001X\u0080T¢\u0006\b\n\u0000\u0012\u0004\b\u0002\u0010\u0003\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u0012²\u0006\n\u0010\u0013\u001a\u00020\u0014X\u008a\u0084\u0002"}, m18d2 = {AiDisclaimerKt.ZuicIcAiTag, "", "getZuicIcAiTag$annotations", "()V", "AiDisclaimer", "", "textColor", "Landroidx/compose/ui/graphics/Color;", "imageColor", "modifier", "Landroidx/compose/ui/Modifier;", "textDisclaimer", "textStyle", "Landroidx/compose/ui/text/TextStyle;", "AiDisclaimer-vc5YOHI", "(JJLandroidx/compose/ui/Modifier;Ljava/lang/String;Landroidx/compose/ui/text/TextStyle;Landroidx/compose/runtime/Composer;II)V", "PreviewAiDisclaimer", "(Landroidx/compose/runtime/Composer;I)V", "zendesk.ui_ui-android", "textHeight", ""}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class AiDisclaimerKt {
    public static final String ZuicIcAiTag = "ZuicIcAiTag";

    public static void getZuicIcAiTag$annotations() {
    }

    public static final void m2129AiDisclaimervc5YOHI(final long j, final long j2, Modifier modifier, String str, TextStyle textStyle, Composer composer, final int i, final int i2) {
        int i3;
        int i4;
        Modifier modifier2;
        int i5;
        String str2;
        TextStyle textStyle2;
        Modifier modifier3;
        String strStringResource;
        final TextStyle textStyle3;
        int i6;
        final String str3;
        int currentCompositeKeyHash;
        Function0 constructor;
        Composer composer2;
        Function2 setCompositeKeyHash;
        final TextMeasurer textMeasurerRememberTextMeasurer;
        boolean zChanged;
        Object objRememberedValue;
        final float f;
        boolean zChanged2;
        Object objRememberedValue2;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1154118573);
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 14) == 0) {
            i3 = (composerStartRestartGroup.changed(j) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        if ((i2 & 2) == 0) {
            if ((i & 112) == 0) {
                i3 |= composerStartRestartGroup.changed(j2) ? 32 : 16;
            }
            i4 = i2 & 4;
            if (i4 != 0) {
                if ((i & 896) == 0) {
                    modifier2 = modifier;
                    if (composerStartRestartGroup.changed(modifier2)) {
                        i5 = 256;
                    } else {
                        i5 = 128;
                    }
                    i3 |= i5;
                }
                if ((i & 7168) == 0) {
                    if ((i2 & 8) == 0) {
                        str2 = str;
                        int i7 = composerStartRestartGroup.changed(str2) ? 2048 : 1024;
                        i3 |= i7;
                    } else {
                        str2 = str;
                    }
                    i3 |= i7;
                } else {
                    str2 = str;
                }
                if ((i & 57344) == 0) {
                    if ((i2 & 16) == 0) {
                        textStyle2 = textStyle;
                        int i8 = composerStartRestartGroup.changed(textStyle2) ? 16384 : 8192;
                        i3 |= i8;
                    } else {
                        textStyle2 = textStyle;
                    }
                    i3 |= i8;
                } else {
                    textStyle2 = textStyle;
                }
                if ((46811 & i3) == 9362 || !composerStartRestartGroup.getSkipping()) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                        if (i4 != 0) {
                            modifier3 = (Modifier) Modifier.Companion;
                        } else {
                            modifier3 = modifier2;
                        }
                        if ((i2 & 8) != 0) {
                            strStringResource = StringResources_androidKt.stringResource(R.string.zuia_generated_by_ai, composerStartRestartGroup, 0);
                            i3 &= -7169;
                        } else {
                            strStringResource = str2;
                        }
                        if ((i2 & 16) != 0) {
                            textStyle3 = TextStyle.copy-p1EtxEg$default(TextStyle.Companion.getDefault(), 0L, TextUnitKt.getSp(12), FontWeight.Companion.getW400(), (FontStyle) null, (FontSynthesis) null, FontFamily.Companion.getSansSerif(), (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, 0, 0, TextUnitKt.getSp(14.32d), (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16646105, (Object) null);
                            i3 &= -57345;
                        } else {
                            textStyle3 = textStyle;
                        }
                        String str4 = strStringResource;
                        i6 = i3;
                        str3 = str4;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                        }
                        modifier3 = modifier2;
                        i6 = i3;
                        str3 = str2;
                        textStyle3 = textStyle;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1154118573, i6, -1, "zendesk.ui.android.conversation.aidisclaimer.AiDisclaimer (AiDisclaimer.kt:55)");
                    }
                    Modifier modifier4 = PaddingKt.padding-qDBjuR0$default(modifier3, PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_horizontal_message_padding, composerStartRestartGroup, 0), 0.0f, 0.0f, 0.0f, 14, (Object) null);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 693286680, "CC(Row)P(2,1,3)99@5018L58,100@5081L130:Row.kt#2w3rfo");
                    MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.Companion.getTop(), composerStartRestartGroup, 0);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifier4);
                    constructor = ComposeUiNode.Companion.getConstructor();
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
                    composer2 = Updater.constructor-impl(composerStartRestartGroup);
                    Updater.set-impl(composer2, measurePolicyRowMeasurePolicy, ComposeUiNode.Companion.getSetMeasurePolicy());
                    Updater.set-impl(composer2, currentCompositionLocalMap, ComposeUiNode.Companion.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.Companion.getSetCompositeKeyHash();
                    if (!composer2.getInserting() || !Intrinsics.areEqual(composer2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                        composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.set-impl(composer2, modifierMaterializeModifier, ComposeUiNode.Companion.getSetModifier());
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -407840262, "C101@5126L9:Row.kt#2w3rfo");
                    RowScope rowScope = RowScopeInstance.INSTANCE;
                    boolean z = true;
                    textMeasurerRememberTextMeasurer = TextMeasurerHelperKt.rememberTextMeasurer(0, composerStartRestartGroup, 0, 1);
                    composerStartRestartGroup.startReplaceGroup(1606704269);
                    if ((((57344 & i6) ^ 24576) > 16384 || !composerStartRestartGroup.changed(textStyle3)) && (i6 & 24576) != 16384) {
                    }
                    zChanged = z | composerStartRestartGroup.changed(textMeasurerRememberTextMeasurer);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChanged || objRememberedValue == Composer.Companion.getEmpty()) {
                        objRememberedValue = SnapshotStateKt.derivedStateOf(new Function0<Integer>() {
                            {
                                super(0);
                            }

                            @Override
                            public final Integer invoke() {
                                return Integer.valueOf(IntSize.getHeight-impl(TextMeasurer.measure-wNUYSr0$default(textMeasurerRememberTextMeasurer, str3, FontUtilsKt.applyFontPadding(TextStyle.copy-p1EtxEg$default(textStyle3, 0L, 0L, (FontWeight) null, (FontStyle) null, (FontSynthesis) null, (FontFamily) null, (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, TextAlign.Companion.getCenter-e0LSkKk(), 0, 0L, (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16744447, (Object) null)), 0, false, 0, 0L, (LayoutDirection) null, (Density) null, (FontFamily.Resolver) null, false, 1020, (Object) null).getSize-YbymL2g()));
                            }
                        });
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    CompositionLocal localDensity = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume = composerStartRestartGroup.consume(localDensity);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    f = ((Density) objConsume).toDp-u2uoSUM(AiDisclaimer_vc5YOHI$lambda$4$lambda$1((State) objRememberedValue));
                    Modifier modifierTestTag = TestTagKt.testTag(PaddingKt.padding-qDBjuR0$default(Modifier.Companion, 0.0f, PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_vertical_message_padding, composerStartRestartGroup, 0), 0.0f, 0.0f, 13, (Object) null), ZuicIcAiTag);
                    composerStartRestartGroup.startReplaceGroup(1606726765);
                    zChanged2 = composerStartRestartGroup.changed(f);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged2 || objRememberedValue2 == Composer.Companion.getEmpty()) {
                        objRememberedValue2 = (Function3) new Function3<MeasureScope, Measurable, Constraints, MeasureResult>() {
                            {
                                super(3);
                            }

                            @Override
                            public MeasureResult invoke(MeasureScope measureScope, Measurable measurable, Constraints constraints) {
                                return m2130invoke3p2s80s(measureScope, measurable, constraints.unbox-impl());
                            }

                            public final MeasureResult m2130invoke3p2s80s(MeasureScope layout, Measurable measurable, long j3) {
                                Intrinsics.checkNotNullParameter(layout, "$this$layout");
                                Intrinsics.checkNotNullParameter(measurable, "measurable");
                                final Placeable placeable = measurable.measure-BRTryo0(Constraints.copy-Zbe2FdA$default(j3, ((int) layout.toPx-0680j_4(f)) / 2, 0, 0, 0, 14, (Object) null));
                                final int i9 = (((int) layout.toPx-0680j_4(f)) / 2) - (placeable.getHeight() / 2);
                                return MeasureScope.-CC.layout$default(layout, placeable.getWidth(), placeable.getHeight(), (Map) null, new Function1<Placeable.PlacementScope, Unit>() {
                                    {
                                        super(1);
                                    }

                                    @Override
                                    public Unit invoke(Placeable.PlacementScope placementScope) {
                                        invoke2(placementScope);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke2(Placeable.PlacementScope layout2) {
                                        Intrinsics.checkNotNullParameter(layout2, "$this$layout");
                                        Placeable.PlacementScope.placeRelative$default(layout2, placeable, 0, i9, 0.0f, 4, (Object) null);
                                    }
                                }, 4, (Object) null);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    int i9 = i6;
                    TextStyle textStyle4 = textStyle3;
                    ImageKt.Image(PainterResources_androidKt.painterResource(R.drawable.zuia_ic_ai_sparkles, composerStartRestartGroup, 0), (String) null, LayoutModifierKt.layout(modifierTestTag, (Function3) objRememberedValue2), (Alignment) null, (ContentScale) null, 0.0f, ColorFilter.Companion.tint-xETnrds$default(ColorFilter.Companion, j2, 0, 2, (Object) null), composerStartRestartGroup, 56, 56);
                    TextKt.Text--4IGK_g(str3, PaddingKt.padding-qDBjuR0(FocusableKt.focusable$default(Modifier.Companion, false, (MutableInteractionSource) null, 3, (Object) null), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_horizontal_spacing_xxsmall, composerStartRestartGroup, 0), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_vertical_message_padding, composerStartRestartGroup, 0), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_horizontal_message_padding, composerStartRestartGroup, 0), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_vertical_message_padding, composerStartRestartGroup, 0)), j, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1) null, FontUtilsKt.applyFontPadding(textStyle4), composerStartRestartGroup, ((i9 >> 9) & 14) | ((i9 << 6) & 896), 0, 65528);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    str2 = str3;
                    textStyle2 = textStyle4;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    modifier3 = modifier2;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier5 = modifier3;
                    final String str5 = str2;
                    final TextStyle textStyle5 = textStyle2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        @Override
                        public Unit invoke(Composer composer3, Integer num) {
                            invoke(composer3, num.intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer3, int i10) {
                            AiDisclaimerKt.m2129AiDisclaimervc5YOHI(j, j2, modifier5, str5, textStyle5, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 384;
            modifier2 = modifier;
            if ((i & 7168) == 0) {
                if ((i2 & 8) == 0) {
                    str2 = str;
                    if (composerStartRestartGroup.changed(str2)) {
                    }
                    i3 |= i7;
                } else {
                    str2 = str;
                }
                i3 |= i7;
            } else {
                str2 = str;
            }
            if ((i & 57344) == 0) {
                if ((i2 & 16) == 0) {
                    textStyle2 = textStyle;
                    if (composerStartRestartGroup.changed(textStyle2)) {
                    }
                    i3 |= i8;
                } else {
                    textStyle2 = textStyle;
                }
                i3 |= i8;
            } else {
                textStyle2 = textStyle;
            }
            if ((46811 & i3) == 9362) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        modifier3 = (Modifier) Modifier.Companion;
                    } else {
                        modifier3 = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        strStringResource = StringResources_androidKt.stringResource(R.string.zuia_generated_by_ai, composerStartRestartGroup, 0);
                        i3 &= -7169;
                    } else {
                        strStringResource = str2;
                    }
                    if ((i2 & 16) != 0) {
                        textStyle3 = TextStyle.copy-p1EtxEg$default(TextStyle.Companion.getDefault(), 0L, TextUnitKt.getSp(12), FontWeight.Companion.getW400(), (FontStyle) null, (FontSynthesis) null, FontFamily.Companion.getSansSerif(), (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, 0, 0, TextUnitKt.getSp(14.32d), (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16646105, (Object) null);
                        i3 &= -57345;
                    } else {
                        textStyle3 = textStyle;
                    }
                    String str6 = strStringResource;
                    i6 = i3;
                    str3 = str6;
                } else {
                    if (i4 != 0) {
                        modifier3 = (Modifier) Modifier.Companion;
                    } else {
                        modifier3 = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        strStringResource = StringResources_androidKt.stringResource(R.string.zuia_generated_by_ai, composerStartRestartGroup, 0);
                        i3 &= -7169;
                    } else {
                        strStringResource = str2;
                    }
                    if ((i2 & 16) != 0) {
                        textStyle3 = TextStyle.copy-p1EtxEg$default(TextStyle.Companion.getDefault(), 0L, TextUnitKt.getSp(12), FontWeight.Companion.getW400(), (FontStyle) null, (FontSynthesis) null, FontFamily.Companion.getSansSerif(), (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, 0, 0, TextUnitKt.getSp(14.32d), (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16646105, (Object) null);
                        i3 &= -57345;
                    } else {
                        textStyle3 = textStyle;
                    }
                    String str7 = strStringResource;
                    i6 = i3;
                    str3 = str7;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1154118573, i6, -1, "zendesk.ui.android.conversation.aidisclaimer.AiDisclaimer (AiDisclaimer.kt:55)");
                }
                Modifier modifier6 = PaddingKt.padding-qDBjuR0$default(modifier3, PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_horizontal_message_padding, composerStartRestartGroup, 0), 0.0f, 0.0f, 0.0f, 14, (Object) null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 693286680, "CC(Row)P(2,1,3)99@5018L58,100@5081L130:Row.kt#2w3rfo");
                MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.Companion.getTop(), composerStartRestartGroup, 0);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap2 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifier6);
                constructor = ComposeUiNode.Companion.getConstructor();
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
                composer2 = Updater.constructor-impl(composerStartRestartGroup);
                Updater.set-impl(composer2, measurePolicyRowMeasurePolicy2, ComposeUiNode.Companion.getSetMeasurePolicy());
                Updater.set-impl(composer2, currentCompositionLocalMap2, ComposeUiNode.Companion.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.Companion.getSetCompositeKeyHash();
                if (!composer2.getInserting()) {
                    composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.set-impl(composer2, modifierMaterializeModifier2, ComposeUiNode.Companion.getSetModifier());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -407840262, "C101@5126L9:Row.kt#2w3rfo");
                RowScope rowScope2 = RowScopeInstance.INSTANCE;
                boolean z2 = true;
                textMeasurerRememberTextMeasurer = TextMeasurerHelperKt.rememberTextMeasurer(0, composerStartRestartGroup, 0, 1);
                composerStartRestartGroup.startReplaceGroup(1606704269);
                z2 = ((57344 & i6) ^ 24576) > 16384 ? false : false;
                zChanged = z2 | composerStartRestartGroup.changed(textMeasurerRememberTextMeasurer);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue = SnapshotStateKt.derivedStateOf(new Function0<Integer>() {
                        {
                            super(0);
                        }

                        @Override
                        public final Integer invoke() {
                            return Integer.valueOf(IntSize.getHeight-impl(TextMeasurer.measure-wNUYSr0$default(textMeasurerRememberTextMeasurer, str3, FontUtilsKt.applyFontPadding(TextStyle.copy-p1EtxEg$default(textStyle3, 0L, 0L, (FontWeight) null, (FontStyle) null, (FontSynthesis) null, (FontFamily) null, (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, TextAlign.Companion.getCenter-e0LSkKk(), 0, 0L, (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16744447, (Object) null)), 0, false, 0, 0L, (LayoutDirection) null, (Density) null, (FontFamily.Resolver) null, false, 1020, (Object) null).getSize-YbymL2g()));
                        }
                    });
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = SnapshotStateKt.derivedStateOf(new Function0<Integer>() {
                        {
                            super(0);
                        }

                        @Override
                        public final Integer invoke() {
                            return Integer.valueOf(IntSize.getHeight-impl(TextMeasurer.measure-wNUYSr0$default(textMeasurerRememberTextMeasurer, str3, FontUtilsKt.applyFontPadding(TextStyle.copy-p1EtxEg$default(textStyle3, 0L, 0L, (FontWeight) null, (FontStyle) null, (FontSynthesis) null, (FontFamily) null, (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, TextAlign.Companion.getCenter-e0LSkKk(), 0, 0L, (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16744447, (Object) null)), 0, false, 0, 0L, (LayoutDirection) null, (Density) null, (FontFamily.Resolver) null, false, 1020, (Object) null).getSize-YbymL2g()));
                        }
                    });
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                composerStartRestartGroup.endReplaceGroup();
                CompositionLocal localDensity2 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume2 = composerStartRestartGroup.consume(localDensity2);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                f = ((Density) objConsume2).toDp-u2uoSUM(AiDisclaimer_vc5YOHI$lambda$4$lambda$1((State) objRememberedValue));
                Modifier modifierTestTag2 = TestTagKt.testTag(PaddingKt.padding-qDBjuR0$default(Modifier.Companion, 0.0f, PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_vertical_message_padding, composerStartRestartGroup, 0), 0.0f, 0.0f, 13, (Object) null), ZuicIcAiTag);
                composerStartRestartGroup.startReplaceGroup(1606726765);
                zChanged2 = composerStartRestartGroup.changed(f);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged2) {
                    objRememberedValue2 = (Function3) new Function3<MeasureScope, Measurable, Constraints, MeasureResult>() {
                        {
                            super(3);
                        }

                        @Override
                        public MeasureResult invoke(MeasureScope measureScope, Measurable measurable, Constraints constraints) {
                            return m2130invoke3p2s80s(measureScope, measurable, constraints.unbox-impl());
                        }

                        public final MeasureResult m2130invoke3p2s80s(MeasureScope layout, Measurable measurable, long j3) {
                            Intrinsics.checkNotNullParameter(layout, "$this$layout");
                            Intrinsics.checkNotNullParameter(measurable, "measurable");
                            final Placeable placeable = measurable.measure-BRTryo0(Constraints.copy-Zbe2FdA$default(j3, ((int) layout.toPx-0680j_4(f)) / 2, 0, 0, 0, 14, (Object) null));
                            final int i10 = (((int) layout.toPx-0680j_4(f)) / 2) - (placeable.getHeight() / 2);
                            return MeasureScope.-CC.layout$default(layout, placeable.getWidth(), placeable.getHeight(), (Map) null, new Function1<Placeable.PlacementScope, Unit>() {
                                {
                                    super(1);
                                }

                                @Override
                                public Unit invoke(Placeable.PlacementScope placementScope) {
                                    invoke2(placementScope);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke2(Placeable.PlacementScope layout2) {
                                    Intrinsics.checkNotNullParameter(layout2, "$this$layout");
                                    Placeable.PlacementScope.placeRelative$default(layout2, placeable, 0, i10, 0.0f, 4, (Object) null);
                                }
                            }, 4, (Object) null);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function3) new Function3<MeasureScope, Measurable, Constraints, MeasureResult>() {
                        {
                            super(3);
                        }

                        @Override
                        public MeasureResult invoke(MeasureScope measureScope, Measurable measurable, Constraints constraints) {
                            return m2130invoke3p2s80s(measureScope, measurable, constraints.unbox-impl());
                        }

                        public final MeasureResult m2130invoke3p2s80s(MeasureScope layout, Measurable measurable, long j3) {
                            Intrinsics.checkNotNullParameter(layout, "$this$layout");
                            Intrinsics.checkNotNullParameter(measurable, "measurable");
                            final Placeable placeable = measurable.measure-BRTryo0(Constraints.copy-Zbe2FdA$default(j3, ((int) layout.toPx-0680j_4(f)) / 2, 0, 0, 0, 14, (Object) null));
                            final int i10 = (((int) layout.toPx-0680j_4(f)) / 2) - (placeable.getHeight() / 2);
                            return MeasureScope.-CC.layout$default(layout, placeable.getWidth(), placeable.getHeight(), (Map) null, new Function1<Placeable.PlacementScope, Unit>() {
                                {
                                    super(1);
                                }

                                @Override
                                public Unit invoke(Placeable.PlacementScope placementScope) {
                                    invoke2(placementScope);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke2(Placeable.PlacementScope layout2) {
                                    Intrinsics.checkNotNullParameter(layout2, "$this$layout");
                                    Placeable.PlacementScope.placeRelative$default(layout2, placeable, 0, i10, 0.0f, 4, (Object) null);
                                }
                            }, 4, (Object) null);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                composerStartRestartGroup.endReplaceGroup();
                int i10 = i6;
                TextStyle textStyle6 = textStyle3;
                ImageKt.Image(PainterResources_androidKt.painterResource(R.drawable.zuia_ic_ai_sparkles, composerStartRestartGroup, 0), (String) null, LayoutModifierKt.layout(modifierTestTag2, (Function3) objRememberedValue2), (Alignment) null, (ContentScale) null, 0.0f, ColorFilter.Companion.tint-xETnrds$default(ColorFilter.Companion, j2, 0, 2, (Object) null), composerStartRestartGroup, 56, 56);
                TextKt.Text--4IGK_g(str3, PaddingKt.padding-qDBjuR0(FocusableKt.focusable$default(Modifier.Companion, false, (MutableInteractionSource) null, 3, (Object) null), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_horizontal_spacing_xxsmall, composerStartRestartGroup, 0), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_vertical_message_padding, composerStartRestartGroup, 0), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_horizontal_message_padding, composerStartRestartGroup, 0), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_vertical_message_padding, composerStartRestartGroup, 0)), j, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1) null, FontUtilsKt.applyFontPadding(textStyle6), composerStartRestartGroup, ((i10 >> 9) & 14) | ((i10 << 6) & 896), 0, 65528);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                str2 = str3;
                textStyle2 = textStyle6;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        modifier3 = (Modifier) Modifier.Companion;
                    } else {
                        modifier3 = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        strStringResource = StringResources_androidKt.stringResource(R.string.zuia_generated_by_ai, composerStartRestartGroup, 0);
                        i3 &= -7169;
                    } else {
                        strStringResource = str2;
                    }
                    if ((i2 & 16) != 0) {
                        textStyle3 = TextStyle.copy-p1EtxEg$default(TextStyle.Companion.getDefault(), 0L, TextUnitKt.getSp(12), FontWeight.Companion.getW400(), (FontStyle) null, (FontSynthesis) null, FontFamily.Companion.getSansSerif(), (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, 0, 0, TextUnitKt.getSp(14.32d), (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16646105, (Object) null);
                        i3 &= -57345;
                    } else {
                        textStyle3 = textStyle;
                    }
                    String str8 = strStringResource;
                    i6 = i3;
                    str3 = str8;
                } else {
                    if (i4 != 0) {
                        modifier3 = (Modifier) Modifier.Companion;
                    } else {
                        modifier3 = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        strStringResource = StringResources_androidKt.stringResource(R.string.zuia_generated_by_ai, composerStartRestartGroup, 0);
                        i3 &= -7169;
                    } else {
                        strStringResource = str2;
                    }
                    if ((i2 & 16) != 0) {
                        textStyle3 = TextStyle.copy-p1EtxEg$default(TextStyle.Companion.getDefault(), 0L, TextUnitKt.getSp(12), FontWeight.Companion.getW400(), (FontStyle) null, (FontSynthesis) null, FontFamily.Companion.getSansSerif(), (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, 0, 0, TextUnitKt.getSp(14.32d), (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16646105, (Object) null);
                        i3 &= -57345;
                    } else {
                        textStyle3 = textStyle;
                    }
                    String str9 = strStringResource;
                    i6 = i3;
                    str3 = str9;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1154118573, i6, -1, "zendesk.ui.android.conversation.aidisclaimer.AiDisclaimer (AiDisclaimer.kt:55)");
                }
                Modifier modifier7 = PaddingKt.padding-qDBjuR0$default(modifier3, PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_horizontal_message_padding, composerStartRestartGroup, 0), 0.0f, 0.0f, 0.0f, 14, (Object) null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 693286680, "CC(Row)P(2,1,3)99@5018L58,100@5081L130:Row.kt#2w3rfo");
                MeasurePolicy measurePolicyRowMeasurePolicy3 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.Companion.getTop(), composerStartRestartGroup, 0);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap3 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifier7);
                constructor = ComposeUiNode.Companion.getConstructor();
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
                composer2 = Updater.constructor-impl(composerStartRestartGroup);
                Updater.set-impl(composer2, measurePolicyRowMeasurePolicy3, ComposeUiNode.Companion.getSetMeasurePolicy());
                Updater.set-impl(composer2, currentCompositionLocalMap3, ComposeUiNode.Companion.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.Companion.getSetCompositeKeyHash();
                if (!composer2.getInserting()) {
                    composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.set-impl(composer2, modifierMaterializeModifier3, ComposeUiNode.Companion.getSetModifier());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -407840262, "C101@5126L9:Row.kt#2w3rfo");
                RowScope rowScope3 = RowScopeInstance.INSTANCE;
                boolean z3 = true;
                textMeasurerRememberTextMeasurer = TextMeasurerHelperKt.rememberTextMeasurer(0, composerStartRestartGroup, 0, 1);
                composerStartRestartGroup.startReplaceGroup(1606704269);
                if (((57344 & i6) ^ 24576) > 16384) {
                }
                zChanged = z3 | composerStartRestartGroup.changed(textMeasurerRememberTextMeasurer);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue = SnapshotStateKt.derivedStateOf(new Function0<Integer>() {
                        {
                            super(0);
                        }

                        @Override
                        public final Integer invoke() {
                            return Integer.valueOf(IntSize.getHeight-impl(TextMeasurer.measure-wNUYSr0$default(textMeasurerRememberTextMeasurer, str3, FontUtilsKt.applyFontPadding(TextStyle.copy-p1EtxEg$default(textStyle3, 0L, 0L, (FontWeight) null, (FontStyle) null, (FontSynthesis) null, (FontFamily) null, (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, TextAlign.Companion.getCenter-e0LSkKk(), 0, 0L, (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16744447, (Object) null)), 0, false, 0, 0L, (LayoutDirection) null, (Density) null, (FontFamily.Resolver) null, false, 1020, (Object) null).getSize-YbymL2g()));
                        }
                    });
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = SnapshotStateKt.derivedStateOf(new Function0<Integer>() {
                        {
                            super(0);
                        }

                        @Override
                        public final Integer invoke() {
                            return Integer.valueOf(IntSize.getHeight-impl(TextMeasurer.measure-wNUYSr0$default(textMeasurerRememberTextMeasurer, str3, FontUtilsKt.applyFontPadding(TextStyle.copy-p1EtxEg$default(textStyle3, 0L, 0L, (FontWeight) null, (FontStyle) null, (FontSynthesis) null, (FontFamily) null, (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, TextAlign.Companion.getCenter-e0LSkKk(), 0, 0L, (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16744447, (Object) null)), 0, false, 0, 0L, (LayoutDirection) null, (Density) null, (FontFamily.Resolver) null, false, 1020, (Object) null).getSize-YbymL2g()));
                        }
                    });
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                composerStartRestartGroup.endReplaceGroup();
                CompositionLocal localDensity3 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume3 = composerStartRestartGroup.consume(localDensity3);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                f = ((Density) objConsume3).toDp-u2uoSUM(AiDisclaimer_vc5YOHI$lambda$4$lambda$1((State) objRememberedValue));
                Modifier modifierTestTag3 = TestTagKt.testTag(PaddingKt.padding-qDBjuR0$default(Modifier.Companion, 0.0f, PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_vertical_message_padding, composerStartRestartGroup, 0), 0.0f, 0.0f, 13, (Object) null), ZuicIcAiTag);
                composerStartRestartGroup.startReplaceGroup(1606726765);
                zChanged2 = composerStartRestartGroup.changed(f);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged2) {
                    objRememberedValue2 = (Function3) new Function3<MeasureScope, Measurable, Constraints, MeasureResult>() {
                        {
                            super(3);
                        }

                        @Override
                        public MeasureResult invoke(MeasureScope measureScope, Measurable measurable, Constraints constraints) {
                            return m2130invoke3p2s80s(measureScope, measurable, constraints.unbox-impl());
                        }

                        public final MeasureResult m2130invoke3p2s80s(MeasureScope layout, Measurable measurable, long j3) {
                            Intrinsics.checkNotNullParameter(layout, "$this$layout");
                            Intrinsics.checkNotNullParameter(measurable, "measurable");
                            final Placeable placeable = measurable.measure-BRTryo0(Constraints.copy-Zbe2FdA$default(j3, ((int) layout.toPx-0680j_4(f)) / 2, 0, 0, 0, 14, (Object) null));
                            final int i11 = (((int) layout.toPx-0680j_4(f)) / 2) - (placeable.getHeight() / 2);
                            return MeasureScope.-CC.layout$default(layout, placeable.getWidth(), placeable.getHeight(), (Map) null, new Function1<Placeable.PlacementScope, Unit>() {
                                {
                                    super(1);
                                }

                                @Override
                                public Unit invoke(Placeable.PlacementScope placementScope) {
                                    invoke2(placementScope);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke2(Placeable.PlacementScope layout2) {
                                    Intrinsics.checkNotNullParameter(layout2, "$this$layout");
                                    Placeable.PlacementScope.placeRelative$default(layout2, placeable, 0, i11, 0.0f, 4, (Object) null);
                                }
                            }, 4, (Object) null);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function3) new Function3<MeasureScope, Measurable, Constraints, MeasureResult>() {
                        {
                            super(3);
                        }

                        @Override
                        public MeasureResult invoke(MeasureScope measureScope, Measurable measurable, Constraints constraints) {
                            return m2130invoke3p2s80s(measureScope, measurable, constraints.unbox-impl());
                        }

                        public final MeasureResult m2130invoke3p2s80s(MeasureScope layout, Measurable measurable, long j3) {
                            Intrinsics.checkNotNullParameter(layout, "$this$layout");
                            Intrinsics.checkNotNullParameter(measurable, "measurable");
                            final Placeable placeable = measurable.measure-BRTryo0(Constraints.copy-Zbe2FdA$default(j3, ((int) layout.toPx-0680j_4(f)) / 2, 0, 0, 0, 14, (Object) null));
                            final int i11 = (((int) layout.toPx-0680j_4(f)) / 2) - (placeable.getHeight() / 2);
                            return MeasureScope.-CC.layout$default(layout, placeable.getWidth(), placeable.getHeight(), (Map) null, new Function1<Placeable.PlacementScope, Unit>() {
                                {
                                    super(1);
                                }

                                @Override
                                public Unit invoke(Placeable.PlacementScope placementScope) {
                                    invoke2(placementScope);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke2(Placeable.PlacementScope layout2) {
                                    Intrinsics.checkNotNullParameter(layout2, "$this$layout");
                                    Placeable.PlacementScope.placeRelative$default(layout2, placeable, 0, i11, 0.0f, 4, (Object) null);
                                }
                            }, 4, (Object) null);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                composerStartRestartGroup.endReplaceGroup();
                int i11 = i6;
                TextStyle textStyle7 = textStyle3;
                ImageKt.Image(PainterResources_androidKt.painterResource(R.drawable.zuia_ic_ai_sparkles, composerStartRestartGroup, 0), (String) null, LayoutModifierKt.layout(modifierTestTag3, (Function3) objRememberedValue2), (Alignment) null, (ContentScale) null, 0.0f, ColorFilter.Companion.tint-xETnrds$default(ColorFilter.Companion, j2, 0, 2, (Object) null), composerStartRestartGroup, 56, 56);
                TextKt.Text--4IGK_g(str3, PaddingKt.padding-qDBjuR0(FocusableKt.focusable$default(Modifier.Companion, false, (MutableInteractionSource) null, 3, (Object) null), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_horizontal_spacing_xxsmall, composerStartRestartGroup, 0), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_vertical_message_padding, composerStartRestartGroup, 0), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_horizontal_message_padding, composerStartRestartGroup, 0), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_vertical_message_padding, composerStartRestartGroup, 0)), j, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1) null, FontUtilsKt.applyFontPadding(textStyle7), composerStartRestartGroup, ((i11 >> 9) & 14) | ((i11 << 6) & 896), 0, 65528);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                str2 = str3;
                textStyle2 = textStyle7;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier8 = modifier3;
                final String str10 = str2;
                final TextStyle textStyle8 = textStyle2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    @Override
                    public Unit invoke(Composer composer3, Integer num) {
                        invoke(composer3, num.intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer3, int i12) {
                        AiDisclaimerKt.m2129AiDisclaimervc5YOHI(j, j2, modifier8, str10, textStyle8, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        i4 = i2 & 4;
        if (i4 != 0) {
            if ((i & 896) == 0) {
                modifier2 = modifier;
                if (composerStartRestartGroup.changed(modifier2)) {
                    i5 = 256;
                } else {
                    i5 = 128;
                }
                i3 |= i5;
            }
            if ((i & 7168) == 0) {
                if ((i2 & 8) == 0) {
                    str2 = str;
                    if (composerStartRestartGroup.changed(str2)) {
                    }
                    i3 |= i7;
                } else {
                    str2 = str;
                }
                i3 |= i7;
            } else {
                str2 = str;
            }
            if ((i & 57344) == 0) {
                if ((i2 & 16) == 0) {
                    textStyle2 = textStyle;
                    if (composerStartRestartGroup.changed(textStyle2)) {
                    }
                    i3 |= i8;
                } else {
                    textStyle2 = textStyle;
                }
                i3 |= i8;
            } else {
                textStyle2 = textStyle;
            }
            if ((46811 & i3) == 9362) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        modifier3 = (Modifier) Modifier.Companion;
                    } else {
                        modifier3 = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        strStringResource = StringResources_androidKt.stringResource(R.string.zuia_generated_by_ai, composerStartRestartGroup, 0);
                        i3 &= -7169;
                    } else {
                        strStringResource = str2;
                    }
                    if ((i2 & 16) != 0) {
                        textStyle3 = TextStyle.copy-p1EtxEg$default(TextStyle.Companion.getDefault(), 0L, TextUnitKt.getSp(12), FontWeight.Companion.getW400(), (FontStyle) null, (FontSynthesis) null, FontFamily.Companion.getSansSerif(), (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, 0, 0, TextUnitKt.getSp(14.32d), (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16646105, (Object) null);
                        i3 &= -57345;
                    } else {
                        textStyle3 = textStyle;
                    }
                    String str11 = strStringResource;
                    i6 = i3;
                    str3 = str11;
                } else {
                    if (i4 != 0) {
                        modifier3 = (Modifier) Modifier.Companion;
                    } else {
                        modifier3 = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        strStringResource = StringResources_androidKt.stringResource(R.string.zuia_generated_by_ai, composerStartRestartGroup, 0);
                        i3 &= -7169;
                    } else {
                        strStringResource = str2;
                    }
                    if ((i2 & 16) != 0) {
                        textStyle3 = TextStyle.copy-p1EtxEg$default(TextStyle.Companion.getDefault(), 0L, TextUnitKt.getSp(12), FontWeight.Companion.getW400(), (FontStyle) null, (FontSynthesis) null, FontFamily.Companion.getSansSerif(), (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, 0, 0, TextUnitKt.getSp(14.32d), (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16646105, (Object) null);
                        i3 &= -57345;
                    } else {
                        textStyle3 = textStyle;
                    }
                    String str12 = strStringResource;
                    i6 = i3;
                    str3 = str12;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1154118573, i6, -1, "zendesk.ui.android.conversation.aidisclaimer.AiDisclaimer (AiDisclaimer.kt:55)");
                }
                Modifier modifier9 = PaddingKt.padding-qDBjuR0$default(modifier3, PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_horizontal_message_padding, composerStartRestartGroup, 0), 0.0f, 0.0f, 0.0f, 14, (Object) null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 693286680, "CC(Row)P(2,1,3)99@5018L58,100@5081L130:Row.kt#2w3rfo");
                MeasurePolicy measurePolicyRowMeasurePolicy4 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.Companion.getTop(), composerStartRestartGroup, 0);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap4 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier4 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifier9);
                constructor = ComposeUiNode.Companion.getConstructor();
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
                composer2 = Updater.constructor-impl(composerStartRestartGroup);
                Updater.set-impl(composer2, measurePolicyRowMeasurePolicy4, ComposeUiNode.Companion.getSetMeasurePolicy());
                Updater.set-impl(composer2, currentCompositionLocalMap4, ComposeUiNode.Companion.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.Companion.getSetCompositeKeyHash();
                if (!composer2.getInserting()) {
                    composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.set-impl(composer2, modifierMaterializeModifier4, ComposeUiNode.Companion.getSetModifier());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -407840262, "C101@5126L9:Row.kt#2w3rfo");
                RowScope rowScope4 = RowScopeInstance.INSTANCE;
                boolean z4 = true;
                textMeasurerRememberTextMeasurer = TextMeasurerHelperKt.rememberTextMeasurer(0, composerStartRestartGroup, 0, 1);
                composerStartRestartGroup.startReplaceGroup(1606704269);
                if (((57344 & i6) ^ 24576) > 16384) {
                }
                zChanged = z4 | composerStartRestartGroup.changed(textMeasurerRememberTextMeasurer);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue = SnapshotStateKt.derivedStateOf(new Function0<Integer>() {
                        {
                            super(0);
                        }

                        @Override
                        public final Integer invoke() {
                            return Integer.valueOf(IntSize.getHeight-impl(TextMeasurer.measure-wNUYSr0$default(textMeasurerRememberTextMeasurer, str3, FontUtilsKt.applyFontPadding(TextStyle.copy-p1EtxEg$default(textStyle3, 0L, 0L, (FontWeight) null, (FontStyle) null, (FontSynthesis) null, (FontFamily) null, (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, TextAlign.Companion.getCenter-e0LSkKk(), 0, 0L, (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16744447, (Object) null)), 0, false, 0, 0L, (LayoutDirection) null, (Density) null, (FontFamily.Resolver) null, false, 1020, (Object) null).getSize-YbymL2g()));
                        }
                    });
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = SnapshotStateKt.derivedStateOf(new Function0<Integer>() {
                        {
                            super(0);
                        }

                        @Override
                        public final Integer invoke() {
                            return Integer.valueOf(IntSize.getHeight-impl(TextMeasurer.measure-wNUYSr0$default(textMeasurerRememberTextMeasurer, str3, FontUtilsKt.applyFontPadding(TextStyle.copy-p1EtxEg$default(textStyle3, 0L, 0L, (FontWeight) null, (FontStyle) null, (FontSynthesis) null, (FontFamily) null, (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, TextAlign.Companion.getCenter-e0LSkKk(), 0, 0L, (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16744447, (Object) null)), 0, false, 0, 0L, (LayoutDirection) null, (Density) null, (FontFamily.Resolver) null, false, 1020, (Object) null).getSize-YbymL2g()));
                        }
                    });
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                composerStartRestartGroup.endReplaceGroup();
                CompositionLocal localDensity4 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume4 = composerStartRestartGroup.consume(localDensity4);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                f = ((Density) objConsume4).toDp-u2uoSUM(AiDisclaimer_vc5YOHI$lambda$4$lambda$1((State) objRememberedValue));
                Modifier modifierTestTag4 = TestTagKt.testTag(PaddingKt.padding-qDBjuR0$default(Modifier.Companion, 0.0f, PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_vertical_message_padding, composerStartRestartGroup, 0), 0.0f, 0.0f, 13, (Object) null), ZuicIcAiTag);
                composerStartRestartGroup.startReplaceGroup(1606726765);
                zChanged2 = composerStartRestartGroup.changed(f);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged2) {
                    objRememberedValue2 = (Function3) new Function3<MeasureScope, Measurable, Constraints, MeasureResult>() {
                        {
                            super(3);
                        }

                        @Override
                        public MeasureResult invoke(MeasureScope measureScope, Measurable measurable, Constraints constraints) {
                            return m2130invoke3p2s80s(measureScope, measurable, constraints.unbox-impl());
                        }

                        public final MeasureResult m2130invoke3p2s80s(MeasureScope layout, Measurable measurable, long j3) {
                            Intrinsics.checkNotNullParameter(layout, "$this$layout");
                            Intrinsics.checkNotNullParameter(measurable, "measurable");
                            final Placeable placeable = measurable.measure-BRTryo0(Constraints.copy-Zbe2FdA$default(j3, ((int) layout.toPx-0680j_4(f)) / 2, 0, 0, 0, 14, (Object) null));
                            final int i12 = (((int) layout.toPx-0680j_4(f)) / 2) - (placeable.getHeight() / 2);
                            return MeasureScope.-CC.layout$default(layout, placeable.getWidth(), placeable.getHeight(), (Map) null, new Function1<Placeable.PlacementScope, Unit>() {
                                {
                                    super(1);
                                }

                                @Override
                                public Unit invoke(Placeable.PlacementScope placementScope) {
                                    invoke2(placementScope);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke2(Placeable.PlacementScope layout2) {
                                    Intrinsics.checkNotNullParameter(layout2, "$this$layout");
                                    Placeable.PlacementScope.placeRelative$default(layout2, placeable, 0, i12, 0.0f, 4, (Object) null);
                                }
                            }, 4, (Object) null);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function3) new Function3<MeasureScope, Measurable, Constraints, MeasureResult>() {
                        {
                            super(3);
                        }

                        @Override
                        public MeasureResult invoke(MeasureScope measureScope, Measurable measurable, Constraints constraints) {
                            return m2130invoke3p2s80s(measureScope, measurable, constraints.unbox-impl());
                        }

                        public final MeasureResult m2130invoke3p2s80s(MeasureScope layout, Measurable measurable, long j3) {
                            Intrinsics.checkNotNullParameter(layout, "$this$layout");
                            Intrinsics.checkNotNullParameter(measurable, "measurable");
                            final Placeable placeable = measurable.measure-BRTryo0(Constraints.copy-Zbe2FdA$default(j3, ((int) layout.toPx-0680j_4(f)) / 2, 0, 0, 0, 14, (Object) null));
                            final int i12 = (((int) layout.toPx-0680j_4(f)) / 2) - (placeable.getHeight() / 2);
                            return MeasureScope.-CC.layout$default(layout, placeable.getWidth(), placeable.getHeight(), (Map) null, new Function1<Placeable.PlacementScope, Unit>() {
                                {
                                    super(1);
                                }

                                @Override
                                public Unit invoke(Placeable.PlacementScope placementScope) {
                                    invoke2(placementScope);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke2(Placeable.PlacementScope layout2) {
                                    Intrinsics.checkNotNullParameter(layout2, "$this$layout");
                                    Placeable.PlacementScope.placeRelative$default(layout2, placeable, 0, i12, 0.0f, 4, (Object) null);
                                }
                            }, 4, (Object) null);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                composerStartRestartGroup.endReplaceGroup();
                int i12 = i6;
                TextStyle textStyle9 = textStyle3;
                ImageKt.Image(PainterResources_androidKt.painterResource(R.drawable.zuia_ic_ai_sparkles, composerStartRestartGroup, 0), (String) null, LayoutModifierKt.layout(modifierTestTag4, (Function3) objRememberedValue2), (Alignment) null, (ContentScale) null, 0.0f, ColorFilter.Companion.tint-xETnrds$default(ColorFilter.Companion, j2, 0, 2, (Object) null), composerStartRestartGroup, 56, 56);
                TextKt.Text--4IGK_g(str3, PaddingKt.padding-qDBjuR0(FocusableKt.focusable$default(Modifier.Companion, false, (MutableInteractionSource) null, 3, (Object) null), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_horizontal_spacing_xxsmall, composerStartRestartGroup, 0), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_vertical_message_padding, composerStartRestartGroup, 0), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_horizontal_message_padding, composerStartRestartGroup, 0), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_vertical_message_padding, composerStartRestartGroup, 0)), j, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1) null, FontUtilsKt.applyFontPadding(textStyle9), composerStartRestartGroup, ((i12 >> 9) & 14) | ((i12 << 6) & 896), 0, 65528);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                str2 = str3;
                textStyle2 = textStyle9;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        modifier3 = (Modifier) Modifier.Companion;
                    } else {
                        modifier3 = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        strStringResource = StringResources_androidKt.stringResource(R.string.zuia_generated_by_ai, composerStartRestartGroup, 0);
                        i3 &= -7169;
                    } else {
                        strStringResource = str2;
                    }
                    if ((i2 & 16) != 0) {
                        textStyle3 = TextStyle.copy-p1EtxEg$default(TextStyle.Companion.getDefault(), 0L, TextUnitKt.getSp(12), FontWeight.Companion.getW400(), (FontStyle) null, (FontSynthesis) null, FontFamily.Companion.getSansSerif(), (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, 0, 0, TextUnitKt.getSp(14.32d), (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16646105, (Object) null);
                        i3 &= -57345;
                    } else {
                        textStyle3 = textStyle;
                    }
                    String str13 = strStringResource;
                    i6 = i3;
                    str3 = str13;
                } else {
                    if (i4 != 0) {
                        modifier3 = (Modifier) Modifier.Companion;
                    } else {
                        modifier3 = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        strStringResource = StringResources_androidKt.stringResource(R.string.zuia_generated_by_ai, composerStartRestartGroup, 0);
                        i3 &= -7169;
                    } else {
                        strStringResource = str2;
                    }
                    if ((i2 & 16) != 0) {
                        textStyle3 = TextStyle.copy-p1EtxEg$default(TextStyle.Companion.getDefault(), 0L, TextUnitKt.getSp(12), FontWeight.Companion.getW400(), (FontStyle) null, (FontSynthesis) null, FontFamily.Companion.getSansSerif(), (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, 0, 0, TextUnitKt.getSp(14.32d), (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16646105, (Object) null);
                        i3 &= -57345;
                    } else {
                        textStyle3 = textStyle;
                    }
                    String str14 = strStringResource;
                    i6 = i3;
                    str3 = str14;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1154118573, i6, -1, "zendesk.ui.android.conversation.aidisclaimer.AiDisclaimer (AiDisclaimer.kt:55)");
                }
                Modifier modifier10 = PaddingKt.padding-qDBjuR0$default(modifier3, PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_horizontal_message_padding, composerStartRestartGroup, 0), 0.0f, 0.0f, 0.0f, 14, (Object) null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 693286680, "CC(Row)P(2,1,3)99@5018L58,100@5081L130:Row.kt#2w3rfo");
                MeasurePolicy measurePolicyRowMeasurePolicy5 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.Companion.getTop(), composerStartRestartGroup, 0);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap5 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier5 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifier10);
                constructor = ComposeUiNode.Companion.getConstructor();
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
                composer2 = Updater.constructor-impl(composerStartRestartGroup);
                Updater.set-impl(composer2, measurePolicyRowMeasurePolicy5, ComposeUiNode.Companion.getSetMeasurePolicy());
                Updater.set-impl(composer2, currentCompositionLocalMap5, ComposeUiNode.Companion.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.Companion.getSetCompositeKeyHash();
                if (!composer2.getInserting()) {
                    composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.set-impl(composer2, modifierMaterializeModifier5, ComposeUiNode.Companion.getSetModifier());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -407840262, "C101@5126L9:Row.kt#2w3rfo");
                RowScope rowScope5 = RowScopeInstance.INSTANCE;
                boolean z5 = true;
                textMeasurerRememberTextMeasurer = TextMeasurerHelperKt.rememberTextMeasurer(0, composerStartRestartGroup, 0, 1);
                composerStartRestartGroup.startReplaceGroup(1606704269);
                if (((57344 & i6) ^ 24576) > 16384) {
                }
                zChanged = z5 | composerStartRestartGroup.changed(textMeasurerRememberTextMeasurer);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue = SnapshotStateKt.derivedStateOf(new Function0<Integer>() {
                        {
                            super(0);
                        }

                        @Override
                        public final Integer invoke() {
                            return Integer.valueOf(IntSize.getHeight-impl(TextMeasurer.measure-wNUYSr0$default(textMeasurerRememberTextMeasurer, str3, FontUtilsKt.applyFontPadding(TextStyle.copy-p1EtxEg$default(textStyle3, 0L, 0L, (FontWeight) null, (FontStyle) null, (FontSynthesis) null, (FontFamily) null, (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, TextAlign.Companion.getCenter-e0LSkKk(), 0, 0L, (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16744447, (Object) null)), 0, false, 0, 0L, (LayoutDirection) null, (Density) null, (FontFamily.Resolver) null, false, 1020, (Object) null).getSize-YbymL2g()));
                        }
                    });
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = SnapshotStateKt.derivedStateOf(new Function0<Integer>() {
                        {
                            super(0);
                        }

                        @Override
                        public final Integer invoke() {
                            return Integer.valueOf(IntSize.getHeight-impl(TextMeasurer.measure-wNUYSr0$default(textMeasurerRememberTextMeasurer, str3, FontUtilsKt.applyFontPadding(TextStyle.copy-p1EtxEg$default(textStyle3, 0L, 0L, (FontWeight) null, (FontStyle) null, (FontSynthesis) null, (FontFamily) null, (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, TextAlign.Companion.getCenter-e0LSkKk(), 0, 0L, (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16744447, (Object) null)), 0, false, 0, 0L, (LayoutDirection) null, (Density) null, (FontFamily.Resolver) null, false, 1020, (Object) null).getSize-YbymL2g()));
                        }
                    });
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                composerStartRestartGroup.endReplaceGroup();
                CompositionLocal localDensity5 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume5 = composerStartRestartGroup.consume(localDensity5);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                f = ((Density) objConsume5).toDp-u2uoSUM(AiDisclaimer_vc5YOHI$lambda$4$lambda$1((State) objRememberedValue));
                Modifier modifierTestTag5 = TestTagKt.testTag(PaddingKt.padding-qDBjuR0$default(Modifier.Companion, 0.0f, PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_vertical_message_padding, composerStartRestartGroup, 0), 0.0f, 0.0f, 13, (Object) null), ZuicIcAiTag);
                composerStartRestartGroup.startReplaceGroup(1606726765);
                zChanged2 = composerStartRestartGroup.changed(f);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged2) {
                    objRememberedValue2 = (Function3) new Function3<MeasureScope, Measurable, Constraints, MeasureResult>() {
                        {
                            super(3);
                        }

                        @Override
                        public MeasureResult invoke(MeasureScope measureScope, Measurable measurable, Constraints constraints) {
                            return m2130invoke3p2s80s(measureScope, measurable, constraints.unbox-impl());
                        }

                        public final MeasureResult m2130invoke3p2s80s(MeasureScope layout, Measurable measurable, long j3) {
                            Intrinsics.checkNotNullParameter(layout, "$this$layout");
                            Intrinsics.checkNotNullParameter(measurable, "measurable");
                            final Placeable placeable = measurable.measure-BRTryo0(Constraints.copy-Zbe2FdA$default(j3, ((int) layout.toPx-0680j_4(f)) / 2, 0, 0, 0, 14, (Object) null));
                            final int i13 = (((int) layout.toPx-0680j_4(f)) / 2) - (placeable.getHeight() / 2);
                            return MeasureScope.-CC.layout$default(layout, placeable.getWidth(), placeable.getHeight(), (Map) null, new Function1<Placeable.PlacementScope, Unit>() {
                                {
                                    super(1);
                                }

                                @Override
                                public Unit invoke(Placeable.PlacementScope placementScope) {
                                    invoke2(placementScope);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke2(Placeable.PlacementScope layout2) {
                                    Intrinsics.checkNotNullParameter(layout2, "$this$layout");
                                    Placeable.PlacementScope.placeRelative$default(layout2, placeable, 0, i13, 0.0f, 4, (Object) null);
                                }
                            }, 4, (Object) null);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function3) new Function3<MeasureScope, Measurable, Constraints, MeasureResult>() {
                        {
                            super(3);
                        }

                        @Override
                        public MeasureResult invoke(MeasureScope measureScope, Measurable measurable, Constraints constraints) {
                            return m2130invoke3p2s80s(measureScope, measurable, constraints.unbox-impl());
                        }

                        public final MeasureResult m2130invoke3p2s80s(MeasureScope layout, Measurable measurable, long j3) {
                            Intrinsics.checkNotNullParameter(layout, "$this$layout");
                            Intrinsics.checkNotNullParameter(measurable, "measurable");
                            final Placeable placeable = measurable.measure-BRTryo0(Constraints.copy-Zbe2FdA$default(j3, ((int) layout.toPx-0680j_4(f)) / 2, 0, 0, 0, 14, (Object) null));
                            final int i13 = (((int) layout.toPx-0680j_4(f)) / 2) - (placeable.getHeight() / 2);
                            return MeasureScope.-CC.layout$default(layout, placeable.getWidth(), placeable.getHeight(), (Map) null, new Function1<Placeable.PlacementScope, Unit>() {
                                {
                                    super(1);
                                }

                                @Override
                                public Unit invoke(Placeable.PlacementScope placementScope) {
                                    invoke2(placementScope);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke2(Placeable.PlacementScope layout2) {
                                    Intrinsics.checkNotNullParameter(layout2, "$this$layout");
                                    Placeable.PlacementScope.placeRelative$default(layout2, placeable, 0, i13, 0.0f, 4, (Object) null);
                                }
                            }, 4, (Object) null);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                composerStartRestartGroup.endReplaceGroup();
                int i13 = i6;
                TextStyle textStyle10 = textStyle3;
                ImageKt.Image(PainterResources_androidKt.painterResource(R.drawable.zuia_ic_ai_sparkles, composerStartRestartGroup, 0), (String) null, LayoutModifierKt.layout(modifierTestTag5, (Function3) objRememberedValue2), (Alignment) null, (ContentScale) null, 0.0f, ColorFilter.Companion.tint-xETnrds$default(ColorFilter.Companion, j2, 0, 2, (Object) null), composerStartRestartGroup, 56, 56);
                TextKt.Text--4IGK_g(str3, PaddingKt.padding-qDBjuR0(FocusableKt.focusable$default(Modifier.Companion, false, (MutableInteractionSource) null, 3, (Object) null), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_horizontal_spacing_xxsmall, composerStartRestartGroup, 0), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_vertical_message_padding, composerStartRestartGroup, 0), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_horizontal_message_padding, composerStartRestartGroup, 0), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_vertical_message_padding, composerStartRestartGroup, 0)), j, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1) null, FontUtilsKt.applyFontPadding(textStyle10), composerStartRestartGroup, ((i13 >> 9) & 14) | ((i13 << 6) & 896), 0, 65528);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                str2 = str3;
                textStyle2 = textStyle10;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier11 = modifier3;
                final String str15 = str2;
                final TextStyle textStyle11 = textStyle2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    @Override
                    public Unit invoke(Composer composer3, Integer num) {
                        invoke(composer3, num.intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer3, int i14) {
                        AiDisclaimerKt.m2129AiDisclaimervc5YOHI(j, j2, modifier11, str15, textStyle11, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        modifier2 = modifier;
        if ((i & 7168) == 0) {
            if ((i2 & 8) == 0) {
                str2 = str;
                if (composerStartRestartGroup.changed(str2)) {
                }
                i3 |= i7;
            } else {
                str2 = str;
            }
            i3 |= i7;
        } else {
            str2 = str;
        }
        if ((i & 57344) == 0) {
            if ((i2 & 16) == 0) {
                textStyle2 = textStyle;
                if (composerStartRestartGroup.changed(textStyle2)) {
                }
                i3 |= i8;
            } else {
                textStyle2 = textStyle;
            }
            i3 |= i8;
        } else {
            textStyle2 = textStyle;
        }
        if ((46811 & i3) == 9362) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i4 != 0) {
                    modifier3 = (Modifier) Modifier.Companion;
                } else {
                    modifier3 = modifier2;
                }
                if ((i2 & 8) != 0) {
                    strStringResource = StringResources_androidKt.stringResource(R.string.zuia_generated_by_ai, composerStartRestartGroup, 0);
                    i3 &= -7169;
                } else {
                    strStringResource = str2;
                }
                if ((i2 & 16) != 0) {
                    textStyle3 = TextStyle.copy-p1EtxEg$default(TextStyle.Companion.getDefault(), 0L, TextUnitKt.getSp(12), FontWeight.Companion.getW400(), (FontStyle) null, (FontSynthesis) null, FontFamily.Companion.getSansSerif(), (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, 0, 0, TextUnitKt.getSp(14.32d), (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16646105, (Object) null);
                    i3 &= -57345;
                } else {
                    textStyle3 = textStyle;
                }
                String str16 = strStringResource;
                i6 = i3;
                str3 = str16;
            } else {
                if (i4 != 0) {
                    modifier3 = (Modifier) Modifier.Companion;
                } else {
                    modifier3 = modifier2;
                }
                if ((i2 & 8) != 0) {
                    strStringResource = StringResources_androidKt.stringResource(R.string.zuia_generated_by_ai, composerStartRestartGroup, 0);
                    i3 &= -7169;
                } else {
                    strStringResource = str2;
                }
                if ((i2 & 16) != 0) {
                    textStyle3 = TextStyle.copy-p1EtxEg$default(TextStyle.Companion.getDefault(), 0L, TextUnitKt.getSp(12), FontWeight.Companion.getW400(), (FontStyle) null, (FontSynthesis) null, FontFamily.Companion.getSansSerif(), (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, 0, 0, TextUnitKt.getSp(14.32d), (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16646105, (Object) null);
                    i3 &= -57345;
                } else {
                    textStyle3 = textStyle;
                }
                String str17 = strStringResource;
                i6 = i3;
                str3 = str17;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1154118573, i6, -1, "zendesk.ui.android.conversation.aidisclaimer.AiDisclaimer (AiDisclaimer.kt:55)");
            }
            Modifier modifier12 = PaddingKt.padding-qDBjuR0$default(modifier3, PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_horizontal_message_padding, composerStartRestartGroup, 0), 0.0f, 0.0f, 0.0f, 14, (Object) null);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 693286680, "CC(Row)P(2,1,3)99@5018L58,100@5081L130:Row.kt#2w3rfo");
            MeasurePolicy measurePolicyRowMeasurePolicy6 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.Companion.getTop(), composerStartRestartGroup, 0);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
            currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap6 = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier6 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifier12);
            constructor = ComposeUiNode.Companion.getConstructor();
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
            composer2 = Updater.constructor-impl(composerStartRestartGroup);
            Updater.set-impl(composer2, measurePolicyRowMeasurePolicy6, ComposeUiNode.Companion.getSetMeasurePolicy());
            Updater.set-impl(composer2, currentCompositionLocalMap6, ComposeUiNode.Companion.getSetResolvedCompositionLocals());
            setCompositeKeyHash = ComposeUiNode.Companion.getSetCompositeKeyHash();
            if (!composer2.getInserting()) {
                composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            } else {
                composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            }
            Updater.set-impl(composer2, modifierMaterializeModifier6, ComposeUiNode.Companion.getSetModifier());
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -407840262, "C101@5126L9:Row.kt#2w3rfo");
            RowScope rowScope6 = RowScopeInstance.INSTANCE;
            boolean z6 = true;
            textMeasurerRememberTextMeasurer = TextMeasurerHelperKt.rememberTextMeasurer(0, composerStartRestartGroup, 0, 1);
            composerStartRestartGroup.startReplaceGroup(1606704269);
            if (((57344 & i6) ^ 24576) > 16384) {
            }
            zChanged = z6 | composerStartRestartGroup.changed(textMeasurerRememberTextMeasurer);
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                objRememberedValue = SnapshotStateKt.derivedStateOf(new Function0<Integer>() {
                    {
                        super(0);
                    }

                    @Override
                    public final Integer invoke() {
                        return Integer.valueOf(IntSize.getHeight-impl(TextMeasurer.measure-wNUYSr0$default(textMeasurerRememberTextMeasurer, str3, FontUtilsKt.applyFontPadding(TextStyle.copy-p1EtxEg$default(textStyle3, 0L, 0L, (FontWeight) null, (FontStyle) null, (FontSynthesis) null, (FontFamily) null, (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, TextAlign.Companion.getCenter-e0LSkKk(), 0, 0L, (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16744447, (Object) null)), 0, false, 0, 0L, (LayoutDirection) null, (Density) null, (FontFamily.Resolver) null, false, 1020, (Object) null).getSize-YbymL2g()));
                    }
                });
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = SnapshotStateKt.derivedStateOf(new Function0<Integer>() {
                    {
                        super(0);
                    }

                    @Override
                    public final Integer invoke() {
                        return Integer.valueOf(IntSize.getHeight-impl(TextMeasurer.measure-wNUYSr0$default(textMeasurerRememberTextMeasurer, str3, FontUtilsKt.applyFontPadding(TextStyle.copy-p1EtxEg$default(textStyle3, 0L, 0L, (FontWeight) null, (FontStyle) null, (FontSynthesis) null, (FontFamily) null, (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, TextAlign.Companion.getCenter-e0LSkKk(), 0, 0L, (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16744447, (Object) null)), 0, false, 0, 0L, (LayoutDirection) null, (Density) null, (FontFamily.Resolver) null, false, 1020, (Object) null).getSize-YbymL2g()));
                    }
                });
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            composerStartRestartGroup.endReplaceGroup();
            CompositionLocal localDensity6 = CompositionLocalsKt.getLocalDensity();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume6 = composerStartRestartGroup.consume(localDensity6);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            f = ((Density) objConsume6).toDp-u2uoSUM(AiDisclaimer_vc5YOHI$lambda$4$lambda$1((State) objRememberedValue));
            Modifier modifierTestTag6 = TestTagKt.testTag(PaddingKt.padding-qDBjuR0$default(Modifier.Companion, 0.0f, PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_vertical_message_padding, composerStartRestartGroup, 0), 0.0f, 0.0f, 13, (Object) null), ZuicIcAiTag);
            composerStartRestartGroup.startReplaceGroup(1606726765);
            zChanged2 = composerStartRestartGroup.changed(f);
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!zChanged2) {
                objRememberedValue2 = (Function3) new Function3<MeasureScope, Measurable, Constraints, MeasureResult>() {
                    {
                        super(3);
                    }

                    @Override
                    public MeasureResult invoke(MeasureScope measureScope, Measurable measurable, Constraints constraints) {
                        return m2130invoke3p2s80s(measureScope, measurable, constraints.unbox-impl());
                    }

                    public final MeasureResult m2130invoke3p2s80s(MeasureScope layout, Measurable measurable, long j3) {
                        Intrinsics.checkNotNullParameter(layout, "$this$layout");
                        Intrinsics.checkNotNullParameter(measurable, "measurable");
                        final Placeable placeable = measurable.measure-BRTryo0(Constraints.copy-Zbe2FdA$default(j3, ((int) layout.toPx-0680j_4(f)) / 2, 0, 0, 0, 14, (Object) null));
                        final int i14 = (((int) layout.toPx-0680j_4(f)) / 2) - (placeable.getHeight() / 2);
                        return MeasureScope.-CC.layout$default(layout, placeable.getWidth(), placeable.getHeight(), (Map) null, new Function1<Placeable.PlacementScope, Unit>() {
                            {
                                super(1);
                            }

                            @Override
                            public Unit invoke(Placeable.PlacementScope placementScope) {
                                invoke2(placementScope);
                                return Unit.INSTANCE;
                            }

                            public final void invoke2(Placeable.PlacementScope layout2) {
                                Intrinsics.checkNotNullParameter(layout2, "$this$layout");
                                Placeable.PlacementScope.placeRelative$default(layout2, placeable, 0, i14, 0.0f, 4, (Object) null);
                            }
                        }, 4, (Object) null);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            } else {
                objRememberedValue2 = (Function3) new Function3<MeasureScope, Measurable, Constraints, MeasureResult>() {
                    {
                        super(3);
                    }

                    @Override
                    public MeasureResult invoke(MeasureScope measureScope, Measurable measurable, Constraints constraints) {
                        return m2130invoke3p2s80s(measureScope, measurable, constraints.unbox-impl());
                    }

                    public final MeasureResult m2130invoke3p2s80s(MeasureScope layout, Measurable measurable, long j3) {
                        Intrinsics.checkNotNullParameter(layout, "$this$layout");
                        Intrinsics.checkNotNullParameter(measurable, "measurable");
                        final Placeable placeable = measurable.measure-BRTryo0(Constraints.copy-Zbe2FdA$default(j3, ((int) layout.toPx-0680j_4(f)) / 2, 0, 0, 0, 14, (Object) null));
                        final int i14 = (((int) layout.toPx-0680j_4(f)) / 2) - (placeable.getHeight() / 2);
                        return MeasureScope.-CC.layout$default(layout, placeable.getWidth(), placeable.getHeight(), (Map) null, new Function1<Placeable.PlacementScope, Unit>() {
                            {
                                super(1);
                            }

                            @Override
                            public Unit invoke(Placeable.PlacementScope placementScope) {
                                invoke2(placementScope);
                                return Unit.INSTANCE;
                            }

                            public final void invoke2(Placeable.PlacementScope layout2) {
                                Intrinsics.checkNotNullParameter(layout2, "$this$layout");
                                Placeable.PlacementScope.placeRelative$default(layout2, placeable, 0, i14, 0.0f, 4, (Object) null);
                            }
                        }, 4, (Object) null);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            composerStartRestartGroup.endReplaceGroup();
            int i14 = i6;
            TextStyle textStyle12 = textStyle3;
            ImageKt.Image(PainterResources_androidKt.painterResource(R.drawable.zuia_ic_ai_sparkles, composerStartRestartGroup, 0), (String) null, LayoutModifierKt.layout(modifierTestTag6, (Function3) objRememberedValue2), (Alignment) null, (ContentScale) null, 0.0f, ColorFilter.Companion.tint-xETnrds$default(ColorFilter.Companion, j2, 0, 2, (Object) null), composerStartRestartGroup, 56, 56);
            TextKt.Text--4IGK_g(str3, PaddingKt.padding-qDBjuR0(FocusableKt.focusable$default(Modifier.Companion, false, (MutableInteractionSource) null, 3, (Object) null), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_horizontal_spacing_xxsmall, composerStartRestartGroup, 0), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_vertical_message_padding, composerStartRestartGroup, 0), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_horizontal_message_padding, composerStartRestartGroup, 0), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_vertical_message_padding, composerStartRestartGroup, 0)), j, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1) null, FontUtilsKt.applyFontPadding(textStyle12), composerStartRestartGroup, ((i14 >> 9) & 14) | ((i14 << 6) & 896), 0, 65528);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            str2 = str3;
            textStyle2 = textStyle12;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i4 != 0) {
                    modifier3 = (Modifier) Modifier.Companion;
                } else {
                    modifier3 = modifier2;
                }
                if ((i2 & 8) != 0) {
                    strStringResource = StringResources_androidKt.stringResource(R.string.zuia_generated_by_ai, composerStartRestartGroup, 0);
                    i3 &= -7169;
                } else {
                    strStringResource = str2;
                }
                if ((i2 & 16) != 0) {
                    textStyle3 = TextStyle.copy-p1EtxEg$default(TextStyle.Companion.getDefault(), 0L, TextUnitKt.getSp(12), FontWeight.Companion.getW400(), (FontStyle) null, (FontSynthesis) null, FontFamily.Companion.getSansSerif(), (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, 0, 0, TextUnitKt.getSp(14.32d), (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16646105, (Object) null);
                    i3 &= -57345;
                } else {
                    textStyle3 = textStyle;
                }
                String str18 = strStringResource;
                i6 = i3;
                str3 = str18;
            } else {
                if (i4 != 0) {
                    modifier3 = (Modifier) Modifier.Companion;
                } else {
                    modifier3 = modifier2;
                }
                if ((i2 & 8) != 0) {
                    strStringResource = StringResources_androidKt.stringResource(R.string.zuia_generated_by_ai, composerStartRestartGroup, 0);
                    i3 &= -7169;
                } else {
                    strStringResource = str2;
                }
                if ((i2 & 16) != 0) {
                    textStyle3 = TextStyle.copy-p1EtxEg$default(TextStyle.Companion.getDefault(), 0L, TextUnitKt.getSp(12), FontWeight.Companion.getW400(), (FontStyle) null, (FontSynthesis) null, FontFamily.Companion.getSansSerif(), (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, 0, 0, TextUnitKt.getSp(14.32d), (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16646105, (Object) null);
                    i3 &= -57345;
                } else {
                    textStyle3 = textStyle;
                }
                String str19 = strStringResource;
                i6 = i3;
                str3 = str19;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1154118573, i6, -1, "zendesk.ui.android.conversation.aidisclaimer.AiDisclaimer (AiDisclaimer.kt:55)");
            }
            Modifier modifier13 = PaddingKt.padding-qDBjuR0$default(modifier3, PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_horizontal_message_padding, composerStartRestartGroup, 0), 0.0f, 0.0f, 0.0f, 14, (Object) null);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 693286680, "CC(Row)P(2,1,3)99@5018L58,100@5081L130:Row.kt#2w3rfo");
            MeasurePolicy measurePolicyRowMeasurePolicy7 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.Companion.getTop(), composerStartRestartGroup, 0);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
            currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap7 = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier7 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifier13);
            constructor = ComposeUiNode.Companion.getConstructor();
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
            composer2 = Updater.constructor-impl(composerStartRestartGroup);
            Updater.set-impl(composer2, measurePolicyRowMeasurePolicy7, ComposeUiNode.Companion.getSetMeasurePolicy());
            Updater.set-impl(composer2, currentCompositionLocalMap7, ComposeUiNode.Companion.getSetResolvedCompositionLocals());
            setCompositeKeyHash = ComposeUiNode.Companion.getSetCompositeKeyHash();
            if (!composer2.getInserting()) {
                composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            } else {
                composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            }
            Updater.set-impl(composer2, modifierMaterializeModifier7, ComposeUiNode.Companion.getSetModifier());
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -407840262, "C101@5126L9:Row.kt#2w3rfo");
            RowScope rowScope7 = RowScopeInstance.INSTANCE;
            boolean z7 = true;
            textMeasurerRememberTextMeasurer = TextMeasurerHelperKt.rememberTextMeasurer(0, composerStartRestartGroup, 0, 1);
            composerStartRestartGroup.startReplaceGroup(1606704269);
            if (((57344 & i6) ^ 24576) > 16384) {
            }
            zChanged = z7 | composerStartRestartGroup.changed(textMeasurerRememberTextMeasurer);
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                objRememberedValue = SnapshotStateKt.derivedStateOf(new Function0<Integer>() {
                    {
                        super(0);
                    }

                    @Override
                    public final Integer invoke() {
                        return Integer.valueOf(IntSize.getHeight-impl(TextMeasurer.measure-wNUYSr0$default(textMeasurerRememberTextMeasurer, str3, FontUtilsKt.applyFontPadding(TextStyle.copy-p1EtxEg$default(textStyle3, 0L, 0L, (FontWeight) null, (FontStyle) null, (FontSynthesis) null, (FontFamily) null, (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, TextAlign.Companion.getCenter-e0LSkKk(), 0, 0L, (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16744447, (Object) null)), 0, false, 0, 0L, (LayoutDirection) null, (Density) null, (FontFamily.Resolver) null, false, 1020, (Object) null).getSize-YbymL2g()));
                    }
                });
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = SnapshotStateKt.derivedStateOf(new Function0<Integer>() {
                    {
                        super(0);
                    }

                    @Override
                    public final Integer invoke() {
                        return Integer.valueOf(IntSize.getHeight-impl(TextMeasurer.measure-wNUYSr0$default(textMeasurerRememberTextMeasurer, str3, FontUtilsKt.applyFontPadding(TextStyle.copy-p1EtxEg$default(textStyle3, 0L, 0L, (FontWeight) null, (FontStyle) null, (FontSynthesis) null, (FontFamily) null, (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, TextAlign.Companion.getCenter-e0LSkKk(), 0, 0L, (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16744447, (Object) null)), 0, false, 0, 0L, (LayoutDirection) null, (Density) null, (FontFamily.Resolver) null, false, 1020, (Object) null).getSize-YbymL2g()));
                    }
                });
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            composerStartRestartGroup.endReplaceGroup();
            CompositionLocal localDensity7 = CompositionLocalsKt.getLocalDensity();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume7 = composerStartRestartGroup.consume(localDensity7);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            f = ((Density) objConsume7).toDp-u2uoSUM(AiDisclaimer_vc5YOHI$lambda$4$lambda$1((State) objRememberedValue));
            Modifier modifierTestTag7 = TestTagKt.testTag(PaddingKt.padding-qDBjuR0$default(Modifier.Companion, 0.0f, PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_vertical_message_padding, composerStartRestartGroup, 0), 0.0f, 0.0f, 13, (Object) null), ZuicIcAiTag);
            composerStartRestartGroup.startReplaceGroup(1606726765);
            zChanged2 = composerStartRestartGroup.changed(f);
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!zChanged2) {
                objRememberedValue2 = (Function3) new Function3<MeasureScope, Measurable, Constraints, MeasureResult>() {
                    {
                        super(3);
                    }

                    @Override
                    public MeasureResult invoke(MeasureScope measureScope, Measurable measurable, Constraints constraints) {
                        return m2130invoke3p2s80s(measureScope, measurable, constraints.unbox-impl());
                    }

                    public final MeasureResult m2130invoke3p2s80s(MeasureScope layout, Measurable measurable, long j3) {
                        Intrinsics.checkNotNullParameter(layout, "$this$layout");
                        Intrinsics.checkNotNullParameter(measurable, "measurable");
                        final Placeable placeable = measurable.measure-BRTryo0(Constraints.copy-Zbe2FdA$default(j3, ((int) layout.toPx-0680j_4(f)) / 2, 0, 0, 0, 14, (Object) null));
                        final int i15 = (((int) layout.toPx-0680j_4(f)) / 2) - (placeable.getHeight() / 2);
                        return MeasureScope.-CC.layout$default(layout, placeable.getWidth(), placeable.getHeight(), (Map) null, new Function1<Placeable.PlacementScope, Unit>() {
                            {
                                super(1);
                            }

                            @Override
                            public Unit invoke(Placeable.PlacementScope placementScope) {
                                invoke2(placementScope);
                                return Unit.INSTANCE;
                            }

                            public final void invoke2(Placeable.PlacementScope layout2) {
                                Intrinsics.checkNotNullParameter(layout2, "$this$layout");
                                Placeable.PlacementScope.placeRelative$default(layout2, placeable, 0, i15, 0.0f, 4, (Object) null);
                            }
                        }, 4, (Object) null);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            } else {
                objRememberedValue2 = (Function3) new Function3<MeasureScope, Measurable, Constraints, MeasureResult>() {
                    {
                        super(3);
                    }

                    @Override
                    public MeasureResult invoke(MeasureScope measureScope, Measurable measurable, Constraints constraints) {
                        return m2130invoke3p2s80s(measureScope, measurable, constraints.unbox-impl());
                    }

                    public final MeasureResult m2130invoke3p2s80s(MeasureScope layout, Measurable measurable, long j3) {
                        Intrinsics.checkNotNullParameter(layout, "$this$layout");
                        Intrinsics.checkNotNullParameter(measurable, "measurable");
                        final Placeable placeable = measurable.measure-BRTryo0(Constraints.copy-Zbe2FdA$default(j3, ((int) layout.toPx-0680j_4(f)) / 2, 0, 0, 0, 14, (Object) null));
                        final int i15 = (((int) layout.toPx-0680j_4(f)) / 2) - (placeable.getHeight() / 2);
                        return MeasureScope.-CC.layout$default(layout, placeable.getWidth(), placeable.getHeight(), (Map) null, new Function1<Placeable.PlacementScope, Unit>() {
                            {
                                super(1);
                            }

                            @Override
                            public Unit invoke(Placeable.PlacementScope placementScope) {
                                invoke2(placementScope);
                                return Unit.INSTANCE;
                            }

                            public final void invoke2(Placeable.PlacementScope layout2) {
                                Intrinsics.checkNotNullParameter(layout2, "$this$layout");
                                Placeable.PlacementScope.placeRelative$default(layout2, placeable, 0, i15, 0.0f, 4, (Object) null);
                            }
                        }, 4, (Object) null);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            composerStartRestartGroup.endReplaceGroup();
            int i15 = i6;
            TextStyle textStyle13 = textStyle3;
            ImageKt.Image(PainterResources_androidKt.painterResource(R.drawable.zuia_ic_ai_sparkles, composerStartRestartGroup, 0), (String) null, LayoutModifierKt.layout(modifierTestTag7, (Function3) objRememberedValue2), (Alignment) null, (ContentScale) null, 0.0f, ColorFilter.Companion.tint-xETnrds$default(ColorFilter.Companion, j2, 0, 2, (Object) null), composerStartRestartGroup, 56, 56);
            TextKt.Text--4IGK_g(str3, PaddingKt.padding-qDBjuR0(FocusableKt.focusable$default(Modifier.Companion, false, (MutableInteractionSource) null, 3, (Object) null), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_horizontal_spacing_xxsmall, composerStartRestartGroup, 0), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_vertical_message_padding, composerStartRestartGroup, 0), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_horizontal_message_padding, composerStartRestartGroup, 0), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_vertical_message_padding, composerStartRestartGroup, 0)), j, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1) null, FontUtilsKt.applyFontPadding(textStyle13), composerStartRestartGroup, ((i15 >> 9) & 14) | ((i15 << 6) & 896), 0, 65528);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            str2 = str3;
            textStyle2 = textStyle13;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier14 = modifier3;
            final String str110 = str2;
            final TextStyle textStyle14 = textStyle2;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                @Override
                public Unit invoke(Composer composer3, Integer num) {
                    invoke(composer3, num.intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer3, int i16) {
                    AiDisclaimerKt.m2129AiDisclaimervc5YOHI(j, j2, modifier14, str110, textStyle14, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    @PreviewThemes
    public static final void PreviewAiDisclaimer(Composer composer, final int i) {
        Composer composerStartRestartGroup = composer.startRestartGroup(2014565885);
        if (i != 0 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(2014565885, i, -1, "zendesk.ui.android.conversation.aidisclaimer.PreviewAiDisclaimer (AiDisclaimer.kt:124)");
            }
            ThemeKt.UiComposeAndroidTheme(false, ComposableSingletons$AiDisclaimerKt.INSTANCE.m2132getLambda2$zendesk_ui_ui_android(), composerStartRestartGroup, 48, 1);
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

                @Override
                public Unit invoke(Composer composer2, Integer num) {
                    invoke(composer2, num.intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i2) {
                    AiDisclaimerKt.PreviewAiDisclaimer(composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1));
                }
            });
        }
    }

    private static final int AiDisclaimer_vc5YOHI$lambda$4$lambda$1(State<Integer> state) {
        return ((Number) state.getValue()).intValue();
    }
}
