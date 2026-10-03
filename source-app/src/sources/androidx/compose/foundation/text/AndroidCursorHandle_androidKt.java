package androidx.compose.foundation.text;

import androidx.compose.foundation.layout.BoxKt;
import androidx.compose.foundation.layout.BoxScopeInstance;
import androidx.compose.foundation.layout.SizeKt;
import androidx.compose.foundation.layout.SpacerKt;
import androidx.compose.foundation.text.selection.AndroidSelectionHandles_androidKt;
import androidx.compose.foundation.text.selection.OffsetProvider;
import androidx.compose.foundation.text.selection.SelectionHandleAnchor;
import androidx.compose.foundation.text.selection.SelectionHandleInfo;
import androidx.compose.foundation.text.selection.SelectionHandlesKt;
import androidx.compose.foundation.text.selection.TextSelectionColors;
import androidx.compose.foundation.text.selection.TextSelectionColorsKt;
import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.ComposedModifierKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.draw.CacheDrawScope;
import androidx.compose.p002ui.draw.DrawModifierKt;
import androidx.compose.p002ui.draw.DrawResult;
import androidx.compose.p002ui.geometry.InlineClassHelperKt;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.Size;
import androidx.compose.p002ui.graphics.ColorFilter;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.ImageBitmap;
import androidx.compose.p002ui.graphics.drawscope.ContentDrawScope;
import androidx.compose.p002ui.graphics.drawscope.DrawContext;
import androidx.compose.p002ui.graphics.drawscope.DrawScope;
import androidx.compose.p002ui.graphics.drawscope.DrawTransform;
import androidx.compose.p002ui.layout.MeasurePolicy;
import androidx.compose.p002ui.node.ComposeUiNode;
import androidx.compose.p002ui.semantics.SemanticsModifierKt;
import androidx.compose.p002ui.semantics.SemanticsPropertyReceiver;
import androidx.compose.runtime.Applier;
import androidx.compose.runtime.ComposablesKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocalMap;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.Updater;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.ui.unit.Dp;
import androidx.compose.ui.unit.DpSize;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000*\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u0007\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\u001a,\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\u000e2\b\b\u0002\u0010\u000f\u001a\u00020\u0010H\u0001ø\u0001\u0000¢\u0006\u0004\b\u0011\u0010\u0012\u001a\u0017\u0010\u0013\u001a\u00020\n2\b\b\u0002\u0010\r\u001a\u00020\u000eH\u0003¢\u0006\u0002\u0010\u0014\u001a\f\u0010\u0015\u001a\u00020\u000e*\u00020\u000eH\u0002\"\u0016\u0010\u0000\u001a\u00020\u0001X\u0080\u0004¢\u0006\n\n\u0002\u0010\u0004\u001a\u0004\b\u0002\u0010\u0003\"\u0016\u0010\u0005\u001a\u00020\u0001X\u0080\u0004¢\u0006\n\n\u0002\u0010\u0004\u001a\u0004\b\u0006\u0010\u0003\"\u000e\u0010\u0007\u001a\u00020\bX\u0082T¢\u0006\u0002\n\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u0016"}, d2 = {"CursorHandleHeight", "Landroidx/compose/ui/unit/Dp;", "getCursorHandleHeight", "()F", "F", "CursorHandleWidth", "getCursorHandleWidth", "Sqrt2", "", "CursorHandle", "", "offsetProvider", "Landroidx/compose/foundation/text/selection/OffsetProvider;", "modifier", "Landroidx/compose/ui/Modifier;", "minTouchTargetSize", "Landroidx/compose/ui/unit/DpSize;", "CursorHandle-USBMPiE", "(Landroidx/compose/foundation/text/selection/OffsetProvider;Landroidx/compose/ui/Modifier;JLandroidx/compose/runtime/Composer;II)V", "DefaultCursorHandle", "(Landroidx/compose/ui/Modifier;Landroidx/compose/runtime/Composer;II)V", "drawCursorHandle", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class AndroidCursorHandle_androidKt {
    private static final float CursorHandleHeight;
    private static final float CursorHandleWidth;
    private static final float Sqrt2 = 1.4142135f;

    public static final float getCursorHandleHeight() {
        return CursorHandleHeight;
    }

    public static final float getCursorHandleWidth() {
        return CursorHandleWidth;
    }

    public static final void m1399CursorHandleUSBMPiE(final OffsetProvider offsetProvider, final Modifier modifier, final long j, Composer composer, final int i, final int i2) {
        int i3;
        Composer composerStartRestartGroup = composer.startRestartGroup(1776202187);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(CursorHandle)P(2,1,0:c#ui.unit.DpSize)52@2192L241,63@2551L458,60@2438L571:AndroidCursorHandle.android.kt#423gt5");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = ((i & 8) == 0 ? composerStartRestartGroup.changed(offsetProvider) : composerStartRestartGroup.changedInstance(offsetProvider) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        if ((i2 & 2) != 0) {
            i3 |= 48;
        } else if ((i & 48) == 0) {
            i3 |= composerStartRestartGroup.changed(modifier) ? 32 : 16;
        }
        if ((i & 384) == 0) {
            i3 |= ((i2 & 4) == 0 && composerStartRestartGroup.changed(j)) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i3 & 147) != 146 || !composerStartRestartGroup.getSkipping()) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0 && !composerStartRestartGroup.getDefaultsInvalid()) {
                composerStartRestartGroup.skipToGroupEnd();
                if ((i2 & 4) != 0) {
                    i3 &= -897;
                }
            } else if ((i2 & 4) != 0) {
                j = DpSize.Companion.getUnspecified-MYxV2XQ();
                i3 &= -897;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1776202187, i3, -1, "androidx.compose.foundation.text.CursorHandle (AndroidCursorHandle.android.kt:51)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -533359786, "CC(remember):AndroidCursorHandle.android.kt#9igjgp");
            int i4 = i3 & 14;
            boolean z = i4 == 4 || ((i3 & 8) != 0 && composerStartRestartGroup.changedInstance(offsetProvider));
            Object objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (z || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((SemanticsPropertyReceiver) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        semanticsPropertyReceiver.set(SelectionHandlesKt.getSelectionHandleInfoKey(), new SelectionHandleInfo(Handle.Cursor, offsetProvider.mo1407provideF1C5BW0(), SelectionHandleAnchor.Middle, true, null));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            final Modifier modifierSemantics$default = SemanticsModifierKt.semantics$default(modifier, false, (Function1) objRememberedValue, 1, null);
            AndroidSelectionHandles_androidKt.HandlePopup(offsetProvider, Alignment.INSTANCE.getTopCenter(), ComposableLambdaKt.rememberComposableLambda(-1653527038, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i5) {
                    ComposerKt.sourceInformation(composer2, "C:AndroidCursorHandle.android.kt#423gt5");
                    if ((i5 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1653527038, i5, -1, "androidx.compose.foundation.text.CursorHandle.<anonymous> (AndroidCursorHandle.android.kt:64)");
                        }
                        if (j != InlineClassHelperKt.UnspecifiedPackedFloats) {
                            composer2.startReplaceGroup(1828881000);
                            ComposerKt.sourceInformation(composer2, "65@2611L318");
                            Modifier modifierM1076requiredSizeInqDBjuR0$default = SizeKt.m1076requiredSizeInqDBjuR0$default(modifierSemantics$default, DpSize.getWidth-D9Ej5fM(j), DpSize.getHeight-D9Ej5fM(j), 0.0f, 0.0f, 12, null);
                            Alignment topCenter = Alignment.INSTANCE.getTopCenter();
                            ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(topCenter, false);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1076requiredSizeInqDBjuR0$default);
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
                            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                            ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                            BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                            ComposerKt.sourceInformationMarkerStart(composer2, 1188580939, "C72@2894L21:AndroidCursorHandle.android.kt#423gt5");
                            AndroidCursorHandle_androidKt.DefaultCursorHandle(null, composer2, 0, 1);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.endReplaceGroup();
                        } else {
                            composer2.startReplaceGroup(1829217412);
                            ComposerKt.sourceInformation(composer2, "75@2959L34");
                            AndroidCursorHandle_androidKt.DefaultCursorHandle(modifierSemantics$default, composer2, 0, 0);
                            composer2.endReplaceGroup();
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer2.skipToGroupEnd();
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, i4 | 432);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.skipToGroupEnd();
        }
        final long j2 = j;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i5) {
                    AndroidCursorHandle_androidKt.m1399CursorHandleUSBMPiE(offsetProvider, modifier, j2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void DefaultCursorHandle(final Modifier modifier, Composer composer, final int i, final int i2) {
        int i3;
        Composer composerStartRestartGroup = composer.startRestartGroup(694251107);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(DefaultCursorHandle)83@3117L79:AndroidCursorHandle.android.kt#423gt5");
        int i4 = i2 & 1;
        if (i4 != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(modifier) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        if ((i3 & 3) != 2 || !composerStartRestartGroup.getSkipping()) {
            if (i4 != 0) {
                modifier = Modifier.INSTANCE;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(694251107, i3, -1, "androidx.compose.foundation.text.DefaultCursorHandle (AndroidCursorHandle.android.kt:82)");
            }
            SpacerKt.Spacer(drawCursorHandle(SizeKt.m1082sizeVpY3zN4(modifier, CursorHandleWidth, CursorHandleHeight)), composerStartRestartGroup, 0);
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

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i5) {
                    AndroidCursorHandle_androidKt.DefaultCursorHandle(modifier, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    private static final Modifier drawCursorHandle(Modifier modifier) {
        return ComposedModifierKt.composed$default(modifier, null, new Function3<Modifier, Composer, Integer, Modifier>() {
            public Object invoke(Object obj, Object obj2, Object obj3) {
                return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
            }

            public final Modifier invoke(Modifier modifier2, Composer composer, int i) {
                composer.startReplaceGroup(-2126899193);
                ComposerKt.sourceInformation(composer, "C87@3300L7,89@3366L602:AndroidCursorHandle.android.kt#423gt5");
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-2126899193, i, -1, "androidx.compose.foundation.text.drawCursorHandle.<anonymous> (AndroidCursorHandle.android.kt:87)");
                }
                ProvidableCompositionLocal<TextSelectionColors> localTextSelectionColors = TextSelectionColorsKt.getLocalTextSelectionColors();
                ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume = composer.consume(localTextSelectionColors);
                ComposerKt.sourceInformationMarkerEnd(composer);
                final long handleColor = ((TextSelectionColors) objConsume).getHandleColor();
                Modifier.Companion companion = Modifier.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composer, 1885990594, "CC(remember):AndroidCursorHandle.android.kt#9igjgp");
                boolean zChanged = composer.changed(handleColor);
                Object objRememberedValue = composer.rememberedValue();
                if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = (Function1) new Function1<CacheDrawScope, DrawResult>() {
                        {
                            super(1);
                        }

                        public final DrawResult invoke(CacheDrawScope cacheDrawScope) {
                            final float fM4415getWidthimpl = Size.m4415getWidthimpl(cacheDrawScope.m4217getSizeNHjbRc()) / 2.0f;
                            final ImageBitmap imageBitmapCreateHandleImage = AndroidSelectionHandles_androidKt.createHandleImage(cacheDrawScope, fM4415getWidthimpl);
                            final ColorFilter colorFilterM4631tintxETnrds$default = ColorFilter.Companion.m4631tintxETnrds$default(ColorFilter.INSTANCE, handleColor, 0, 2, null);
                            return cacheDrawScope.onDrawWithContent(new Function1<ContentDrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((ContentDrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(ContentDrawScope contentDrawScope) {
                                    contentDrawScope.drawContent();
                                    ContentDrawScope contentDrawScope2 = contentDrawScope;
                                    float f = fM4415getWidthimpl;
                                    ImageBitmap imageBitmap = imageBitmapCreateHandleImage;
                                    ColorFilter colorFilter = colorFilterM4631tintxETnrds$default;
                                    DrawContext drawContext = contentDrawScope2.getDrawContext();
                                    long jMo5102getSizeNHjbRc = drawContext.mo5102getSizeNHjbRc();
                                    drawContext.getCanvas().save();
                                    try {
                                        DrawTransform transform = drawContext.getTransform();
                                        DrawTransform.CC.translate$default(transform, f, 0.0f, 2, null);
                                        transform.mo5108rotateUv8p0NA(45.0f, Offset.INSTANCE.m4362getZeroF1C5BW0());
                                        DrawScope.CC.m5170drawImagegbVJVH8$default(contentDrawScope2, imageBitmap, 0L, 0.0f, null, colorFilter, 0, 46, null);
                                    } finally {
                                        drawContext.getCanvas().restore();
                                        drawContext.mo5103setSizeuvyYCjk(jMo5102getSizeNHjbRc);
                                    }
                                }
                            });
                        }
                    };
                    composer.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composer);
                Modifier modifierThen = modifier2.then(DrawModifierKt.drawWithCache(companion, (Function1) objRememberedValue));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                composer.endReplaceGroup();
                return modifierThen;
            }
        }, 1, null);
    }

    static {
        float f = Dp.constructor-impl(25);
        CursorHandleHeight = f;
        CursorHandleWidth = Dp.constructor-impl(Dp.constructor-impl(f * 2.0f) / 2.4142137f);
    }
}
