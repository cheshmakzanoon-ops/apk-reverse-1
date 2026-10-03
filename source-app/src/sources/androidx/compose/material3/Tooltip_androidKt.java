package androidx.compose.material3;

import android.content.res.Configuration;
import androidx.compose.foundation.layout.AlignmentLineKt;
import androidx.compose.foundation.layout.Arrangement;
import androidx.compose.foundation.layout.BoxKt;
import androidx.compose.foundation.layout.BoxScopeInstance;
import androidx.compose.foundation.layout.ColumnKt;
import androidx.compose.foundation.layout.ColumnScopeInstance;
import androidx.compose.foundation.layout.PaddingKt;
import androidx.compose.foundation.layout.SizeKt;
import androidx.compose.material3.tokens.ElevationTokens;
import androidx.compose.material3.tokens.PlainTooltipTokens;
import androidx.compose.material3.tokens.RichTooltipTokens;
import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.ComposedModifierKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.draw.CacheDrawScope;
import androidx.compose.p002ui.draw.DrawResult;
import androidx.compose.p002ui.geometry.InlineClassHelperKt;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.p002ui.geometry.Size;
import androidx.compose.p002ui.graphics.AndroidPath_androidKt;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.Path;
import androidx.compose.p002ui.graphics.Shape;
import androidx.compose.p002ui.graphics.drawscope.ContentDrawScope;
import androidx.compose.p002ui.graphics.drawscope.DrawScope;
import androidx.compose.p002ui.layout.LayoutCoordinates;
import androidx.compose.p002ui.layout.LayoutCoordinatesKt;
import androidx.compose.p002ui.layout.MeasurePolicy;
import androidx.compose.p002ui.node.ComposeUiNode;
import androidx.compose.p002ui.platform.AndroidCompositionLocals_androidKt;
import androidx.compose.p002ui.platform.CompositionLocalsKt;
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
import androidx.compose.runtime.Updater;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.ui.text.TextStyle;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.Dp;
import androidx.compose.ui.unit.DpSize;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000f\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\u001ao\u0010\u0000\u001a\u00020\u0001*\u00020\u00022\b\b\u0002\u0010\u0003\u001a\u00020\u00042\b\b\u0002\u0010\u0005\u001a\u00020\u00062\b\b\u0002\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\t\u001a\u00020\n2\b\b\u0002\u0010\u000b\u001a\u00020\n2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\r2\u0011\u0010\u000f\u001a\r\u0012\u0004\u0012\u00020\u00010\u0010¢\u0006\u0002\b\u0011H\u0007ø\u0001\u0000¢\u0006\u0004\b\u0012\u0010\u0013\u001a\u0093\u0001\u0010\u0014\u001a\u00020\u0001*\u00020\u00022\b\b\u0002\u0010\u0003\u001a\u00020\u00042\u0015\b\u0002\u0010\u0015\u001a\u000f\u0012\u0004\u0012\u00020\u0001\u0018\u00010\u0010¢\u0006\u0002\b\u00112\u0015\b\u0002\u0010\u0016\u001a\u000f\u0012\u0004\u0012\u00020\u0001\u0018\u00010\u0010¢\u0006\u0002\b\u00112\b\b\u0002\u0010\u0005\u001a\u00020\u00062\b\b\u0002\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\u0017\u001a\u00020\u00182\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\r2\u0011\u0010\u0019\u001a\r\u0012\u0004\u0012\u00020\u00010\u0010¢\u0006\u0002\b\u0011H\u0007ø\u0001\u0000¢\u0006\u0004\b\u001a\u0010\u001b\u001aH\u0010\u001c\u001a\u00020\u001d*\u00020\u001e2\u0006\u0010\u001f\u001a\u00020 2\u0006\u0010!\u001a\u00020\"2\u0006\u0010#\u001a\u00020$2\u0006\u0010\u000b\u001a\u00020\n2\u0006\u0010\u0005\u001a\u00020\u00062\b\u0010%\u001a\u0004\u0018\u00010&H\u0003ø\u0001\u0000¢\u0006\u0004\b'\u0010(\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006)"}, d2 = {"PlainTooltip", "", "Landroidx/compose/material3/TooltipScope;", "modifier", "Landroidx/compose/ui/Modifier;", "caretSize", "Landroidx/compose/ui/unit/DpSize;", "shape", "Landroidx/compose/ui/graphics/Shape;", "contentColor", "Landroidx/compose/ui/graphics/Color;", "containerColor", "tonalElevation", "Landroidx/compose/ui/unit/Dp;", "shadowElevation", "content", "Lkotlin/Function0;", "Landroidx/compose/runtime/Composable;", "PlainTooltip-7QI4Sbk", "(Landroidx/compose/material3/TooltipScope;Landroidx/compose/ui/Modifier;JLandroidx/compose/ui/graphics/Shape;JJFFLkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;II)V", "RichTooltip", "title", "action", "colors", "Landroidx/compose/material3/RichTooltipColors;", "text", "RichTooltip-yDvdmqw", "(Landroidx/compose/material3/TooltipScope;Landroidx/compose/ui/Modifier;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;JLandroidx/compose/ui/graphics/Shape;Landroidx/compose/material3/RichTooltipColors;FFLkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;II)V", "drawCaretWithPath", "Landroidx/compose/ui/draw/DrawResult;", "Landroidx/compose/ui/draw/CacheDrawScope;", "caretType", "Landroidx/compose/material3/CaretType;", "density", "Landroidx/compose/ui/unit/Density;", "configuration", "Landroid/content/res/Configuration;", "anchorLayoutCoordinates", "Landroidx/compose/ui/layout/LayoutCoordinates;", "drawCaretWithPath-JKu-mZY", "(Landroidx/compose/ui/draw/CacheDrawScope;Landroidx/compose/material3/CaretType;Landroidx/compose/ui/unit/Density;Landroid/content/res/Configuration;JJLandroidx/compose/ui/layout/LayoutCoordinates;)Landroidx/compose/ui/draw/DrawResult;", "material3_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class Tooltip_androidKt {
    public static final void m3183PlainTooltip7QI4Sbk(final TooltipScope tooltipScope, Modifier modifier, long j, Shape shape, long j2, long j3, float f, float f2, final Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, final int i, final int i2) {
        int i3;
        Shape shape2;
        final long plainTooltipContentColor;
        long j4;
        int i4;
        float f3;
        int i5;
        int i6;
        float f4;
        int i7;
        int i8;
        Modifier.Companion companion;
        long j5;
        Shape plainTooltipContainerShape;
        long plainTooltipContainerColor;
        float f5;
        float f6;
        float f7;
        long j6;
        final long j7;
        boolean z;
        Modifier modifierThen;
        float f8;
        long j8;
        Modifier modifier2;
        final Density density;
        final Configuration configuration;
        boolean zChanged;
        Object objRememberedValue;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i9;
        int i10;
        int i11;
        int i12;
        Composer composerStartRestartGroup = composer.startRestartGroup(1407069716);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(PlainTooltip)P(4,0:c#ui.unit.DpSize,6,3:c#ui.graphics.Color,1:c#ui.graphics.Color,7:c#ui.unit.Dp,5:c#ui.unit.Dp)208@8412L26,209@8482L24,211@8552L26,96@3876L606,90@3685L797:Tooltip.android.kt#uh7d8r");
        if ((Integer.MIN_VALUE & i2) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = ((i & 8) == 0 ? composerStartRestartGroup.changed(tooltipScope) : composerStartRestartGroup.changedInstance(tooltipScope) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i13 = i2 & 1;
        if (i13 == 0) {
            if ((i & 48) == 0) {
                i3 |= composerStartRestartGroup.changed(modifier) ? 32 : 16;
            }
            if ((i & 384) != 0) {
                if ((i2 & 2) == 0 || !composerStartRestartGroup.changed(j)) {
                    i12 = Fields.SpotShadowColor;
                } else {
                    i12 = Fields.RotationX;
                }
                i3 |= i12;
            }
            if ((i & 3072) == 0) {
                if ((i2 & 4) == 0) {
                    shape2 = shape;
                    if (composerStartRestartGroup.changed(shape2)) {
                        i11 = Fields.CameraDistance;
                    }
                    i3 |= i11;
                } else {
                    shape2 = shape;
                }
                i11 = Fields.RotationZ;
                i3 |= i11;
            } else {
                shape2 = shape;
            }
            if ((i & 24576) == 0) {
                if ((i2 & 8) == 0) {
                    plainTooltipContentColor = j2;
                    if (composerStartRestartGroup.changed(plainTooltipContentColor)) {
                        i10 = Fields.Clip;
                    }
                    i3 |= i10;
                } else {
                    plainTooltipContentColor = j2;
                }
                i10 = Fields.Shape;
                i3 |= i10;
            } else {
                plainTooltipContentColor = j2;
            }
            if ((i & 196608) == 0) {
                j4 = j3;
                if ((i2 & 16) == 0 || !composerStartRestartGroup.changed(j4)) {
                    i9 = 65536;
                } else {
                    i9 = Fields.RenderEffect;
                }
                i3 |= i9;
            } else {
                j4 = j3;
            }
            i4 = i2 & 32;
            if (i4 != 0) {
                i3 |= 1572864;
                f3 = f;
            } else {
                f3 = f;
                if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(f3)) {
                        i5 = 1048576;
                    } else {
                        i5 = 524288;
                    }
                    i3 |= i5;
                }
            }
            i6 = i2 & 64;
            if (i6 != 0) {
                i3 |= 12582912;
                f4 = f2;
            } else {
                f4 = f2;
                if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(f4)) {
                        i7 = 8388608;
                    } else {
                        i7 = 4194304;
                    }
                    i3 |= i7;
                }
            }
            if ((i2 & Fields.SpotShadowColor) != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changedInstance(function2)) {
                    i8 = 67108864;
                } else {
                    i8 = 33554432;
                }
                i3 |= i8;
            }
            if ((38347923 & i3) == 38347922 || !composerStartRestartGroup.getSkipping()) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 2) != 0) {
                        j5 = DpSize.Companion.getUnspecified-MYxV2XQ();
                        i3 &= -897;
                    } else {
                        j5 = j;
                    }
                    if ((i2 & 4) != 0) {
                        plainTooltipContainerShape = TooltipDefaults.INSTANCE.getPlainTooltipContainerShape(composerStartRestartGroup, 6);
                        i3 &= -7169;
                    } else {
                        plainTooltipContainerShape = shape2;
                    }
                    if ((i2 & 8) != 0) {
                        plainTooltipContentColor = TooltipDefaults.INSTANCE.getPlainTooltipContentColor(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    }
                    if ((i2 & 16) != 0) {
                        plainTooltipContainerColor = TooltipDefaults.INSTANCE.getPlainTooltipContainerColor(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    } else {
                        plainTooltipContainerColor = j4;
                    }
                    if (i4 != 0) {
                        f5 = Dp.constructor-impl(0);
                    } else {
                        f5 = f3;
                    }
                    if (i6 != 0) {
                        f6 = Dp.constructor-impl(0);
                    } else {
                        f6 = f4;
                    }
                    long j9 = plainTooltipContainerColor;
                    shape2 = plainTooltipContainerShape;
                    f7 = f5;
                    j6 = j5;
                    j7 = j9;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    if ((i2 & 2) != 0) {
                        i3 &= -897;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -7169;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -57345;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -458753;
                    }
                    companion = modifier;
                    f7 = f3;
                    f6 = f4;
                    i3 = i3;
                    j7 = j4;
                    j6 = j;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1407069716, i3, -1, "androidx.compose.material3.PlainTooltip (Tooltip.android.kt:73)");
                }
                composerStartRestartGroup.startReplaceGroup(-333850415);
                ComposerKt.sourceInformation(composerStartRestartGroup, "76@3183L7,77@3242L7,78@3281L343");
                if (j6 != InlineClassHelperKt.UnspecifiedPackedFloats) {
                    z = true;
                } else {
                    z = false;
                }
                if (z) {
                    ProvidableCompositionLocal<Density> localDensity = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume = composerStartRestartGroup.consume(localDensity);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume;
                    ProvidableCompositionLocal<Configuration> localConfiguration = AndroidCompositionLocals_androidKt.getLocalConfiguration();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume2 = composerStartRestartGroup.consume(localConfiguration);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    configuration = (Configuration) objConsume2;
                    Modifier.Companion companion2 = Modifier.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -333845325, "CC(remember):Tooltip.android.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changedInstance(configuration) | ((((458752 & i3) ^ 196608) <= 131072 && composerStartRestartGroup.changed(j7)) || (i3 & 196608) == 131072) | ((((i3 & 896) ^ 384) <= 256 && composerStartRestartGroup.changed(j6)) || (i3 & 384) == 256);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        final long j10 = j7;
                        final long j11 = j6;
                        objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                            {
                                super(2);
                            }

                            public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                                return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Plain, density, configuration, j10, j11, layoutCoordinates);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    modifierThen = tooltipScope.drawCaret(companion2, (Function2) objRememberedValue).then(companion);
                } else {
                    modifierThen = companion;
                }
                composerStartRestartGroup.endReplaceGroup();
                plainTooltipContentColor = plainTooltipContentColor;
                int i14 = i3 >> 6;
                SurfaceKt.m2868SurfaceT9BRK9s(modifierThen, shape2, j7, 0L, f7, f6, null, ComposableLambdaKt.rememberComposableLambda(1430116975, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i15) {
                        ComposerKt.sourceInformation(composer2, "C97@3886L590:Tooltip.android.kt#uh7d8r");
                        if ((i15 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1430116975, i15, -1, "androidx.compose.material3.PlainTooltip.<anonymous> (Tooltip.android.kt:97)");
                            }
                            Modifier modifierPadding = PaddingKt.padding(SizeKt.m1084sizeInqDBjuR0$default(Modifier.INSTANCE, TooltipKt.getTooltipMinWidth(), TooltipKt.getTooltipMinHeight(), TooltipKt.getPlainTooltipMaxWidth(), 0.0f, 8, null), TooltipKt.getPlainTooltipContentPadding());
                            long j12 = plainTooltipContentColor;
                            Function2<Composer, Integer, Unit> function3 = function2;
                            ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierPadding);
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
                            ComposerKt.sourceInformationMarkerStart(composer2, 1903647947, "C106@4266L5,108@4285L181:Tooltip.android.kt#uh7d8r");
                            CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(j12)), TextKt.getLocalTextStyle().provides(TypographyKt.getValue(PlainTooltipTokens.INSTANCE.getSupportingTextFont(), composer2, 6))}, function3, composer2, ProvidedValue.$stable);
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
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i14 & 112) | 12582912 | ((i3 >> 9) & 896) | (57344 & i14) | (i14 & 458752), 72);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                f8 = f7;
                shape2 = shape2;
                j8 = j6;
                modifier2 = companion;
            } else {
                composerStartRestartGroup.skipToGroupEnd();
                modifier2 = modifier;
                j8 = j;
                f8 = f3;
                f6 = f4;
                j7 = j4;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier3 = modifier2;
                final long j12 = j8;
                final Shape shape3 = shape2;
                final long j13 = plainTooltipContentColor;
                final float f9 = f8;
                final float f10 = f6;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i15) {
                        Tooltip_androidKt.m3183PlainTooltip7QI4Sbk(tooltipScope, modifier3, j12, shape3, j13, j7, f9, f10, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        if ((i & 384) != 0) {
            if ((i2 & 2) == 0) {
                i12 = Fields.SpotShadowColor;
            } else {
                i12 = Fields.SpotShadowColor;
            }
            i3 |= i12;
        }
        if ((i & 3072) == 0) {
            if ((i2 & 4) == 0) {
                shape2 = shape;
                if (composerStartRestartGroup.changed(shape2)) {
                    i11 = Fields.CameraDistance;
                }
                i3 |= i11;
            } else {
                shape2 = shape;
            }
            i11 = Fields.RotationZ;
            i3 |= i11;
        } else {
            shape2 = shape;
        }
        if ((i & 24576) == 0) {
            if ((i2 & 8) == 0) {
                plainTooltipContentColor = j2;
                if (composerStartRestartGroup.changed(plainTooltipContentColor)) {
                    i10 = Fields.Clip;
                }
                i3 |= i10;
            } else {
                plainTooltipContentColor = j2;
            }
            i10 = Fields.Shape;
            i3 |= i10;
        } else {
            plainTooltipContentColor = j2;
        }
        if ((i & 196608) == 0) {
            j4 = j3;
            if ((i2 & 16) == 0) {
                i9 = 65536;
            } else {
                i9 = 65536;
            }
            i3 |= i9;
        } else {
            j4 = j3;
        }
        i4 = i2 & 32;
        if (i4 != 0) {
            i3 |= 1572864;
            f3 = f;
        } else {
            f3 = f;
            if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changed(f3)) {
                    i5 = 1048576;
                } else {
                    i5 = 524288;
                }
                i3 |= i5;
            }
        }
        i6 = i2 & 64;
        if (i6 != 0) {
            i3 |= 12582912;
            f4 = f2;
        } else {
            f4 = f2;
            if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changed(f4)) {
                    i7 = 8388608;
                } else {
                    i7 = 4194304;
                }
                i3 |= i7;
            }
        }
        if ((i2 & Fields.SpotShadowColor) != 0) {
            i3 |= 100663296;
        } else if ((i & 100663296) == 0) {
            if (composerStartRestartGroup.changedInstance(function2)) {
                i8 = 67108864;
            } else {
                i8 = 33554432;
            }
            i3 |= i8;
        }
        if ((38347923 & i3) == 38347922) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 2) != 0) {
                    j5 = DpSize.Companion.getUnspecified-MYxV2XQ();
                    i3 &= -897;
                } else {
                    j5 = j;
                }
                if ((i2 & 4) != 0) {
                    plainTooltipContainerShape = TooltipDefaults.INSTANCE.getPlainTooltipContainerShape(composerStartRestartGroup, 6);
                    i3 &= -7169;
                } else {
                    plainTooltipContainerShape = shape2;
                }
                if ((i2 & 8) != 0) {
                    plainTooltipContentColor = TooltipDefaults.INSTANCE.getPlainTooltipContentColor(composerStartRestartGroup, 6);
                    i3 &= -57345;
                }
                if ((i2 & 16) != 0) {
                    plainTooltipContainerColor = TooltipDefaults.INSTANCE.getPlainTooltipContainerColor(composerStartRestartGroup, 6);
                    i3 &= -458753;
                } else {
                    plainTooltipContainerColor = j4;
                }
                if (i4 != 0) {
                    f5 = Dp.constructor-impl(0);
                } else {
                    f5 = f3;
                }
                if (i6 != 0) {
                    f6 = Dp.constructor-impl(0);
                } else {
                    f6 = f4;
                }
                long j14 = plainTooltipContainerColor;
                shape2 = plainTooltipContainerShape;
                f7 = f5;
                j6 = j5;
                j7 = j14;
            } else {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 2) != 0) {
                    j5 = DpSize.Companion.getUnspecified-MYxV2XQ();
                    i3 &= -897;
                } else {
                    j5 = j;
                }
                if ((i2 & 4) != 0) {
                    plainTooltipContainerShape = TooltipDefaults.INSTANCE.getPlainTooltipContainerShape(composerStartRestartGroup, 6);
                    i3 &= -7169;
                } else {
                    plainTooltipContainerShape = shape2;
                }
                if ((i2 & 8) != 0) {
                    plainTooltipContentColor = TooltipDefaults.INSTANCE.getPlainTooltipContentColor(composerStartRestartGroup, 6);
                    i3 &= -57345;
                }
                if ((i2 & 16) != 0) {
                    plainTooltipContainerColor = TooltipDefaults.INSTANCE.getPlainTooltipContainerColor(composerStartRestartGroup, 6);
                    i3 &= -458753;
                } else {
                    plainTooltipContainerColor = j4;
                }
                if (i4 != 0) {
                    f5 = Dp.constructor-impl(0);
                } else {
                    f5 = f3;
                }
                if (i6 != 0) {
                    f6 = Dp.constructor-impl(0);
                } else {
                    f6 = f4;
                }
                long j15 = plainTooltipContainerColor;
                shape2 = plainTooltipContainerShape;
                f7 = f5;
                j6 = j5;
                j7 = j15;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1407069716, i3, -1, "androidx.compose.material3.PlainTooltip (Tooltip.android.kt:73)");
            }
            composerStartRestartGroup.startReplaceGroup(-333850415);
            ComposerKt.sourceInformation(composerStartRestartGroup, "76@3183L7,77@3242L7,78@3281L343");
            if (j6 != InlineClassHelperKt.UnspecifiedPackedFloats) {
                z = true;
            } else {
                z = false;
            }
            if (z) {
                ProvidableCompositionLocal<Density> localDensity2 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume3 = composerStartRestartGroup.consume(localDensity2);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume3;
                ProvidableCompositionLocal<Configuration> localConfiguration2 = AndroidCompositionLocals_androidKt.getLocalConfiguration();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume4 = composerStartRestartGroup.consume(localConfiguration2);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                configuration = (Configuration) objConsume4;
                Modifier.Companion companion3 = Modifier.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -333845325, "CC(remember):Tooltip.android.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changedInstance(configuration) | ((((458752 & i3) ^ 196608) <= 131072 && composerStartRestartGroup.changed(j7)) || (i3 & 196608) == 131072) | ((((i3 & 896) ^ 384) <= 256 && composerStartRestartGroup.changed(j6)) || (i3 & 384) == 256);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    final long j16 = j7;
                    final long j17 = j6;
                    objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                        {
                            super(2);
                        }

                        public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                            return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Plain, density, configuration, j16, j17, layoutCoordinates);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    final long j18 = j7;
                    final long j19 = j6;
                    objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                        {
                            super(2);
                        }

                        public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                            return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Plain, density, configuration, j18, j19, layoutCoordinates);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                modifierThen = tooltipScope.drawCaret(companion3, (Function2) objRememberedValue).then(companion);
            } else {
                modifierThen = companion;
            }
            composerStartRestartGroup.endReplaceGroup();
            plainTooltipContentColor = plainTooltipContentColor;
            int i15 = i3 >> 6;
            SurfaceKt.m2868SurfaceT9BRK9s(modifierThen, shape2, j7, 0L, f7, f6, null, ComposableLambdaKt.rememberComposableLambda(1430116975, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i16) {
                    ComposerKt.sourceInformation(composer2, "C97@3886L590:Tooltip.android.kt#uh7d8r");
                    if ((i16 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1430116975, i16, -1, "androidx.compose.material3.PlainTooltip.<anonymous> (Tooltip.android.kt:97)");
                        }
                        Modifier modifierPadding = PaddingKt.padding(SizeKt.m1084sizeInqDBjuR0$default(Modifier.INSTANCE, TooltipKt.getTooltipMinWidth(), TooltipKt.getTooltipMinHeight(), TooltipKt.getPlainTooltipMaxWidth(), 0.0f, 8, null), TooltipKt.getPlainTooltipContentPadding());
                        long j110 = plainTooltipContentColor;
                        Function2<Composer, Integer, Unit> function3 = function2;
                        ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                        CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierPadding);
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
                        ComposerKt.sourceInformationMarkerStart(composer2, 1903647947, "C106@4266L5,108@4285L181:Tooltip.android.kt#uh7d8r");
                        CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(j110)), TextKt.getLocalTextStyle().provides(TypographyKt.getValue(PlainTooltipTokens.INSTANCE.getSupportingTextFont(), composer2, 6))}, function3, composer2, ProvidedValue.$stable);
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
            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i15 & 112) | 12582912 | ((i3 >> 9) & 896) | (57344 & i15) | (i15 & 458752), 72);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            f8 = f7;
            shape2 = shape2;
            j8 = j6;
            modifier2 = companion;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 2) != 0) {
                    j5 = DpSize.Companion.getUnspecified-MYxV2XQ();
                    i3 &= -897;
                } else {
                    j5 = j;
                }
                if ((i2 & 4) != 0) {
                    plainTooltipContainerShape = TooltipDefaults.INSTANCE.getPlainTooltipContainerShape(composerStartRestartGroup, 6);
                    i3 &= -7169;
                } else {
                    plainTooltipContainerShape = shape2;
                }
                if ((i2 & 8) != 0) {
                    plainTooltipContentColor = TooltipDefaults.INSTANCE.getPlainTooltipContentColor(composerStartRestartGroup, 6);
                    i3 &= -57345;
                }
                if ((i2 & 16) != 0) {
                    plainTooltipContainerColor = TooltipDefaults.INSTANCE.getPlainTooltipContainerColor(composerStartRestartGroup, 6);
                    i3 &= -458753;
                } else {
                    plainTooltipContainerColor = j4;
                }
                if (i4 != 0) {
                    f5 = Dp.constructor-impl(0);
                } else {
                    f5 = f3;
                }
                if (i6 != 0) {
                    f6 = Dp.constructor-impl(0);
                } else {
                    f6 = f4;
                }
                long j110 = plainTooltipContainerColor;
                shape2 = plainTooltipContainerShape;
                f7 = f5;
                j6 = j5;
                j7 = j110;
            } else {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 2) != 0) {
                    j5 = DpSize.Companion.getUnspecified-MYxV2XQ();
                    i3 &= -897;
                } else {
                    j5 = j;
                }
                if ((i2 & 4) != 0) {
                    plainTooltipContainerShape = TooltipDefaults.INSTANCE.getPlainTooltipContainerShape(composerStartRestartGroup, 6);
                    i3 &= -7169;
                } else {
                    plainTooltipContainerShape = shape2;
                }
                if ((i2 & 8) != 0) {
                    plainTooltipContentColor = TooltipDefaults.INSTANCE.getPlainTooltipContentColor(composerStartRestartGroup, 6);
                    i3 &= -57345;
                }
                if ((i2 & 16) != 0) {
                    plainTooltipContainerColor = TooltipDefaults.INSTANCE.getPlainTooltipContainerColor(composerStartRestartGroup, 6);
                    i3 &= -458753;
                } else {
                    plainTooltipContainerColor = j4;
                }
                if (i4 != 0) {
                    f5 = Dp.constructor-impl(0);
                } else {
                    f5 = f3;
                }
                if (i6 != 0) {
                    f6 = Dp.constructor-impl(0);
                } else {
                    f6 = f4;
                }
                long j111 = plainTooltipContainerColor;
                shape2 = plainTooltipContainerShape;
                f7 = f5;
                j6 = j5;
                j7 = j111;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1407069716, i3, -1, "androidx.compose.material3.PlainTooltip (Tooltip.android.kt:73)");
            }
            composerStartRestartGroup.startReplaceGroup(-333850415);
            ComposerKt.sourceInformation(composerStartRestartGroup, "76@3183L7,77@3242L7,78@3281L343");
            if (j6 != InlineClassHelperKt.UnspecifiedPackedFloats) {
                z = true;
            } else {
                z = false;
            }
            if (z) {
                ProvidableCompositionLocal<Density> localDensity3 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume5 = composerStartRestartGroup.consume(localDensity3);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume5;
                ProvidableCompositionLocal<Configuration> localConfiguration3 = AndroidCompositionLocals_androidKt.getLocalConfiguration();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume6 = composerStartRestartGroup.consume(localConfiguration3);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                configuration = (Configuration) objConsume6;
                Modifier.Companion companion4 = Modifier.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -333845325, "CC(remember):Tooltip.android.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changedInstance(configuration) | ((((458752 & i3) ^ 196608) <= 131072 && composerStartRestartGroup.changed(j7)) || (i3 & 196608) == 131072) | ((((i3 & 896) ^ 384) <= 256 && composerStartRestartGroup.changed(j6)) || (i3 & 384) == 256);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    final long j112 = j7;
                    final long j113 = j6;
                    objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                        {
                            super(2);
                        }

                        public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                            return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Plain, density, configuration, j112, j113, layoutCoordinates);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    final long j114 = j7;
                    final long j115 = j6;
                    objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                        {
                            super(2);
                        }

                        public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                            return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Plain, density, configuration, j114, j115, layoutCoordinates);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                modifierThen = tooltipScope.drawCaret(companion4, (Function2) objRememberedValue).then(companion);
            } else {
                modifierThen = companion;
            }
            composerStartRestartGroup.endReplaceGroup();
            plainTooltipContentColor = plainTooltipContentColor;
            int i16 = i3 >> 6;
            SurfaceKt.m2868SurfaceT9BRK9s(modifierThen, shape2, j7, 0L, f7, f6, null, ComposableLambdaKt.rememberComposableLambda(1430116975, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i17) {
                    ComposerKt.sourceInformation(composer2, "C97@3886L590:Tooltip.android.kt#uh7d8r");
                    if ((i17 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1430116975, i17, -1, "androidx.compose.material3.PlainTooltip.<anonymous> (Tooltip.android.kt:97)");
                        }
                        Modifier modifierPadding = PaddingKt.padding(SizeKt.m1084sizeInqDBjuR0$default(Modifier.INSTANCE, TooltipKt.getTooltipMinWidth(), TooltipKt.getTooltipMinHeight(), TooltipKt.getPlainTooltipMaxWidth(), 0.0f, 8, null), TooltipKt.getPlainTooltipContentPadding());
                        long j116 = plainTooltipContentColor;
                        Function2<Composer, Integer, Unit> function3 = function2;
                        ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                        CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierPadding);
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
                        ComposerKt.sourceInformationMarkerStart(composer2, 1903647947, "C106@4266L5,108@4285L181:Tooltip.android.kt#uh7d8r");
                        CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(j116)), TextKt.getLocalTextStyle().provides(TypographyKt.getValue(PlainTooltipTokens.INSTANCE.getSupportingTextFont(), composer2, 6))}, function3, composer2, ProvidedValue.$stable);
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
            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i16 & 112) | 12582912 | ((i3 >> 9) & 896) | (57344 & i16) | (i16 & 458752), 72);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            f8 = f7;
            shape2 = shape2;
            j8 = j6;
            modifier2 = companion;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier4 = modifier2;
            final long j116 = j8;
            final Shape shape4 = shape2;
            final long j117 = plainTooltipContentColor;
            final float f11 = f8;
            final float f12 = f6;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i17) {
                    Tooltip_androidKt.m3183PlainTooltip7QI4Sbk(tooltipScope, modifier4, j116, shape4, j117, j7, f11, f12, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void m3184RichTooltipyDvdmqw(final TooltipScope tooltipScope, Modifier modifier, Function2<? super Composer, ? super Integer, Unit> function2, Function2<? super Composer, ? super Integer, Unit> function3, long j, Shape shape, RichTooltipColors richTooltipColors, float f, float f2, final Function2<? super Composer, ? super Integer, Unit> function4, Composer composer, final int i, final int i2) {
        int i3;
        int i4;
        int i5;
        int i6;
        Function2<? super Composer, ? super Integer, Unit> function5;
        int i7;
        long j2;
        Shape richTooltipContainerShape;
        int i8;
        int i9;
        int i10;
        int i11;
        int i12;
        Modifier.Companion companion;
        Function2<? super Composer, ? super Integer, Unit> function6;
        Function2<? super Composer, ? super Integer, Unit> function7;
        long j3;
        RichTooltipColors richTooltipColors2;
        float fM3537getLevel0D9Ej5fM;
        float fM3835getContainerElevationD9Ej5fM;
        final RichTooltipColors richTooltipColors3;
        int i13;
        float f3;
        final long jM2171applyTonalElevationRFCenO8;
        boolean z;
        Modifier modifierThen;
        final Function2<? super Composer, ? super Integer, Unit> function8;
        final Function2<? super Composer, ? super Integer, Unit> function9;
        final long j4;
        final float f4;
        final RichTooltipColors richTooltipColors4;
        final Density density;
        final Configuration configuration;
        boolean zChanged;
        Object objRememberedValue;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i14;
        int i15;
        Composer composerStartRestartGroup = composer.startRestartGroup(1867454921);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(RichTooltip)P(3,7!1,1:c#ui.unit.DpSize,5!1,8:c#ui.unit.Dp,4:c#ui.unit.Dp)255@9959L25,257@10034L19,*148@5873L7,150@5944L11,150@5956L61,178@6991L1595,167@6622L1964:Tooltip.android.kt#uh7d8r");
        if ((Integer.MIN_VALUE & i2) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = ((i & 8) == 0 ? composerStartRestartGroup.changed(tooltipScope) : composerStartRestartGroup.changedInstance(tooltipScope) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i16 = i2 & 1;
        if (i16 == 0) {
            if ((i & 48) == 0) {
                i3 |= composerStartRestartGroup.changed(modifier) ? 32 : 16;
            }
            i4 = i2 & 2;
            if (i4 != 0) {
                if ((i & 384) == 0) {
                    if (composerStartRestartGroup.changedInstance(function2)) {
                        i5 = Fields.RotationX;
                    } else {
                        i5 = Fields.SpotShadowColor;
                    }
                    i3 |= i5;
                }
                i6 = i2 & 4;
                if (i6 != 0) {
                    if ((i & 3072) == 0) {
                        function5 = function3;
                        if (composerStartRestartGroup.changedInstance(function5)) {
                            i7 = Fields.CameraDistance;
                        } else {
                            i7 = Fields.RotationZ;
                        }
                        i3 |= i7;
                    }
                    if ((i & 24576) == 0) {
                        j2 = j;
                        if ((i2 & 8) == 0 || !composerStartRestartGroup.changed(j2)) {
                            i15 = Fields.Shape;
                        } else {
                            i15 = Fields.Clip;
                        }
                        i3 |= i15;
                    } else {
                        j2 = j;
                    }
                    if ((196608 & i) == 0) {
                        if ((i2 & 16) == 0) {
                            richTooltipContainerShape = shape;
                            int i17 = composerStartRestartGroup.changed(richTooltipContainerShape) ? Fields.RenderEffect : 65536;
                            i3 |= i17;
                        } else {
                            richTooltipContainerShape = shape;
                        }
                        i3 |= i17;
                    } else {
                        richTooltipContainerShape = shape;
                    }
                    if ((i & 1572864) != 0) {
                        if ((i2 & 32) == 0 || !composerStartRestartGroup.changed(richTooltipColors)) {
                            i14 = 524288;
                        } else {
                            i14 = 1048576;
                        }
                        i3 |= i14;
                    }
                    i8 = i2 & 64;
                    if (i8 != 0) {
                        i3 |= 12582912;
                    } else if ((i & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(f)) {
                            i9 = 8388608;
                        } else {
                            i9 = 4194304;
                        }
                        i3 |= i9;
                    }
                    i10 = i2 & Fields.SpotShadowColor;
                    if (i10 != 0) {
                        i3 |= 100663296;
                    } else if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changed(f2)) {
                            i11 = 67108864;
                        } else {
                            i11 = 33554432;
                        }
                        i3 |= i11;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        i3 |= 805306368;
                    } else if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function4)) {
                            i12 = 536870912;
                        } else {
                            i12 = 268435456;
                        }
                        i3 |= i12;
                    }
                    if ((306783379 & i3) == 306783378 || !composerStartRestartGroup.getSkipping()) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                            if (i16 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i4 != 0) {
                                function6 = null;
                            } else {
                                function6 = function2;
                            }
                            function7 = i6 == 0 ? function5 : null;
                            if ((i2 & 8) != 0) {
                                j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                                i3 &= -57345;
                            } else {
                                j3 = j2;
                            }
                            if ((i2 & 16) != 0) {
                                richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            }
                            if ((i2 & 32) != 0) {
                                richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                richTooltipColors2 = richTooltipColors;
                            }
                            if (i8 != 0) {
                                fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                            } else {
                                fM3537getLevel0D9Ej5fM = f;
                            }
                            if (i10 != 0) {
                                fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                            } else {
                                fM3835getContainerElevationD9Ej5fM = f2;
                            }
                            richTooltipColors3 = richTooltipColors2;
                            i13 = i3;
                            f3 = fM3537getLevel0D9Ej5fM;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            if ((i2 & 8) != 0) {
                                i3 &= -57345;
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -458753;
                            }
                            if ((i2 & 32) != 0) {
                                i3 &= -3670017;
                            }
                            companion = modifier;
                            function6 = function2;
                            richTooltipColors3 = richTooltipColors;
                            fM3835getContainerElevationD9Ej5fM = f2;
                            function7 = function5;
                            j3 = j2;
                            i13 = i3;
                            f3 = f;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1867454921, i13, -1, "androidx.compose.material3.RichTooltip (Tooltip.android.kt:147)");
                        }
                        ProvidableCompositionLocal<Dp> localAbsoluteTonalElevation = SurfaceKt.getLocalAbsoluteTonalElevation();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume = composerStartRestartGroup.consume(localAbsoluteTonalElevation);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        jM2171applyTonalElevationRFCenO8 = ColorSchemeKt.m2171applyTonalElevationRFCenO8(MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6), richTooltipColors3.getContainerColor(), Dp.constructor-impl(((Dp) objConsume).unbox-impl() + f3), composerStartRestartGroup, 0);
                        composerStartRestartGroup.startReplaceGroup(1472746423);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "153@6122L7,154@6181L7,155@6220L341");
                        float f5 = f3;
                        if (j3 != InlineClassHelperKt.UnspecifiedPackedFloats) {
                            z = true;
                        } else {
                            z = false;
                        }
                        if (z) {
                            ProvidableCompositionLocal<Density> localDensity = CompositionLocalsKt.getLocalDensity();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume2 = composerStartRestartGroup.consume(localDensity);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            density = (Density) objConsume2;
                            ProvidableCompositionLocal<Configuration> localConfiguration = AndroidCompositionLocals_androidKt.getLocalConfiguration();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume3 = composerStartRestartGroup.consume(localConfiguration);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            configuration = (Configuration) objConsume3;
                            Modifier.Companion companion2 = Modifier.INSTANCE;
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1472751513, "CC(remember):Tooltip.android.kt#9igjgp");
                            zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changedInstance(configuration) | composerStartRestartGroup.changed(jM2171applyTonalElevationRFCenO8) | ((((57344 & i13) ^ 24576) <= 16384 && composerStartRestartGroup.changed(j3)) || (i13 & 24576) == 16384);
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                final long j5 = j3;
                                objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                                    {
                                        super(2);
                                    }

                                    public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                                        return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j5, layoutCoordinates);
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            modifierThen = tooltipScope.drawCaret(companion2, (Function2) objRememberedValue).then(companion);
                        } else {
                            modifierThen = companion;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        function8 = function7;
                        final Function2<? super Composer, ? super Integer, Unit> function10 = function6;
                        int i18 = i13 >> 9;
                        SurfaceKt.m2868SurfaceT9BRK9s(SizeKt.m1084sizeInqDBjuR0$default(modifierThen, TooltipKt.getTooltipMinWidth(), TooltipKt.getTooltipMinHeight(), TooltipKt.getRichTooltipMaxWidth(), 0.0f, 8, null), richTooltipContainerShape, richTooltipColors3.getContainerColor(), 0L, f5, fM3835getContainerElevationD9Ej5fM, null, ComposableLambdaKt.rememberComposableLambda(317290958, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i19) {
                                ComposerKt.sourceInformation(composer2, "C179@7066L5,180@7133L5,181@7210L5,183@7225L1355:Tooltip.android.kt#uh7d8r");
                                if ((i19 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(317290958, i19, -1, "androidx.compose.material3.RichTooltip.<anonymous> (Tooltip.android.kt:179)");
                                    }
                                    TextStyle value = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                    TextStyle value2 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSubheadFont(), composer2, 6);
                                    TextStyle value3 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                    Modifier modifierM1037paddingVpY3zN4$default = PaddingKt.m1037paddingVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getRichTooltipHorizontalPadding(), 0.0f, 2, null);
                                    Function2<Composer, Integer, Unit> function11 = function10;
                                    Function2<Composer, Integer, Unit> function12 = function8;
                                    RichTooltipColors richTooltipColors5 = richTooltipColors3;
                                    Function2<Composer, Integer, Unit> function13 = function4;
                                    ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                    MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.INSTANCE.getStart(), composer2, 0);
                                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                    CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1037paddingVpY3zN4$default);
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
                                    ComposerKt.sourceInformationMarkerStart(composer2, -459254051, "C193@7718L319:Tooltip.android.kt#uh7d8r");
                                    composer2.startReplaceGroup(955016030);
                                    ComposerKt.sourceInformation(composer2, "*185@7347L344");
                                    if (function11 != null) {
                                        Modifier modifierM886paddingFromBaselineVpY3zN4$default = AlignmentLineKt.m886paddingFromBaselineVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getHeightToSubheadFirstLine(), 0.0f, 2, null);
                                        ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                        CompositionLocalMap currentCompositionLocalMap2 = composer2.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer2, modifierM886paddingFromBaselineVpY3zN4$default);
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
                                        Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                            composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                            composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                        BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer2, 1468424960, "C186@7446L227:Tooltip.android.kt#uh7d8r");
                                        CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getTitleContentColor())), TextKt.getLocalTextStyle().provides(value2)}, function11, composer2, ProvidedValue.$stable);
                                        ComposerKt.sourceInformationMarkerEnd(composer2);
                                        ComposerKt.sourceInformationMarkerEnd(composer2);
                                        composer2.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer2);
                                        ComposerKt.sourceInformationMarkerEnd(composer2);
                                        ComposerKt.sourceInformationMarkerEnd(composer2);
                                        Unit unit = Unit.INSTANCE;
                                        Unit unit2 = Unit.INSTANCE;
                                    }
                                    composer2.endReplaceGroup();
                                    Modifier modifierTextVerticalPadding = TooltipKt.textVerticalPadding(Modifier.INSTANCE, function11 != null, function12 != null);
                                    ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                    CompositionLocalMap currentCompositionLocalMap3 = composer2.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer2, modifierTextVerticalPadding);
                                    Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer2.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer2.startReusableNode();
                                    if (composer2.getInserting()) {
                                        composer2.createNode(constructor3);
                                    } else {
                                        composer2.useNode();
                                    }
                                    Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer2);
                                    Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                        composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                        composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer2, -1959181329, "C194@7812L211:Tooltip.android.kt#uh7d8r");
                                    CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getContentColor())), TextKt.getLocalTextStyle().provides(value3)}, function13, composer2, ProvidedValue.$stable);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    composer2.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    composer2.startReplaceGroup(955039618);
                                    ComposerKt.sourceInformation(composer2, "*201@8080L476");
                                    if (function12 != null) {
                                        Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1071requiredHeightInVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getActionLabelMinHeight(), 0.0f, 2, null), 0.0f, 0.0f, 0.0f, TooltipKt.getActionLabelBottomPadding(), 7, null);
                                        ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy3 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash4 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                        CompositionLocalMap currentCompositionLocalMap4 = composer2.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier4 = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
                                        Function0<ComposeUiNode> constructor4 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer2.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer2.startReusableNode();
                                        if (composer2.getInserting()) {
                                            composer2.createNode(constructor4);
                                        } else {
                                            composer2.useNode();
                                        }
                                        Composer composerM4037constructorimpl4 = Updater.m4037constructorimpl(composer2);
                                        Updater.m4044setimpl(composerM4037constructorimpl4, measurePolicyMaybeCachedBoxMeasurePolicy3, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl4, currentCompositionLocalMap4, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash4 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl4.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl4.rememberedValue(), Integer.valueOf(currentCompositeKeyHash4))) {
                                            composerM4037constructorimpl4.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash4));
                                            composerM4037constructorimpl4.apply(Integer.valueOf(currentCompositeKeyHash4), setCompositeKeyHash4);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl4, modifierMaterializeModifier4, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                        BoxScopeInstance boxScopeInstance3 = BoxScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer2, 1469278235, "C206@8306L232:Tooltip.android.kt#uh7d8r");
                                        CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getActionContentColor())), TextKt.getLocalTextStyle().provides(value)}, function12, composer2, ProvidedValue.$stable);
                                        ComposerKt.sourceInformationMarkerEnd(composer2);
                                        ComposerKt.sourceInformationMarkerEnd(composer2);
                                        composer2.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer2);
                                        ComposerKt.sourceInformationMarkerEnd(composer2);
                                        ComposerKt.sourceInformationMarkerEnd(composer2);
                                        Unit unit3 = Unit.INSTANCE;
                                        Unit unit4 = Unit.INSTANCE;
                                    }
                                    composer2.endReplaceGroup();
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
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i13 >> 12) & 112) | 12582912 | (57344 & i18) | (i18 & 458752), 72);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function9 = function10;
                        j4 = j3;
                        richTooltipContainerShape = richTooltipContainerShape;
                        f4 = f5;
                        richTooltipColors4 = richTooltipColors3;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        companion = modifier;
                        function9 = function2;
                        richTooltipColors4 = richTooltipColors;
                        fM3835getContainerElevationD9Ej5fM = f2;
                        function8 = function5;
                        j4 = j2;
                        f4 = f;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier2 = companion;
                        final Function2<? super Composer, ? super Integer, Unit> function11 = function8;
                        final Shape shape2 = richTooltipContainerShape;
                        final float f6 = fM3835getContainerElevationD9Ej5fM;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i19) {
                                Tooltip_androidKt.m3184RichTooltipyDvdmqw(tooltipScope, modifier2, function9, function11, j4, shape2, richTooltipColors4, f4, f6, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 3072;
                function5 = function3;
                if ((i & 24576) == 0) {
                    j2 = j;
                    if ((i2 & 8) == 0) {
                        i15 = Fields.Shape;
                    } else {
                        i15 = Fields.Shape;
                    }
                    i3 |= i15;
                } else {
                    j2 = j;
                }
                if ((196608 & i) == 0) {
                    if ((i2 & 16) == 0) {
                        richTooltipContainerShape = shape;
                        if (composerStartRestartGroup.changed(richTooltipContainerShape)) {
                        }
                        i3 |= i17;
                    } else {
                        richTooltipContainerShape = shape;
                    }
                    i3 |= i17;
                } else {
                    richTooltipContainerShape = shape;
                }
                if ((i & 1572864) != 0) {
                    if ((i2 & 32) == 0) {
                        i14 = 524288;
                    } else {
                        i14 = 524288;
                    }
                    i3 |= i14;
                }
                i8 = i2 & 64;
                if (i8 != 0) {
                    i3 |= 12582912;
                } else if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(f)) {
                        i9 = 8388608;
                    } else {
                        i9 = 4194304;
                    }
                    i3 |= i9;
                }
                i10 = i2 & Fields.SpotShadowColor;
                if (i10 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(f2)) {
                        i11 = 67108864;
                    } else {
                        i11 = 33554432;
                    }
                    i3 |= i11;
                }
                if ((i2 & Fields.RotationX) != 0) {
                    i3 |= 805306368;
                } else if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i12 = 536870912;
                    } else {
                        i12 = 268435456;
                    }
                    i3 |= i12;
                }
                if ((306783379 & i3) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function6 = null;
                        } else {
                            function6 = function2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 8) != 0) {
                            j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                            i3 &= -57345;
                        } else {
                            j3 = j2;
                        }
                        if ((i2 & 16) != 0) {
                            richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 32) != 0) {
                            richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            richTooltipColors2 = richTooltipColors;
                        }
                        if (i8 != 0) {
                            fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                        } else {
                            fM3537getLevel0D9Ej5fM = f;
                        }
                        if (i10 != 0) {
                            fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                        } else {
                            fM3835getContainerElevationD9Ej5fM = f2;
                        }
                        richTooltipColors3 = richTooltipColors2;
                        i13 = i3;
                        f3 = fM3537getLevel0D9Ej5fM;
                    } else {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function6 = null;
                        } else {
                            function6 = function2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 8) != 0) {
                            j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                            i3 &= -57345;
                        } else {
                            j3 = j2;
                        }
                        if ((i2 & 16) != 0) {
                            richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 32) != 0) {
                            richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            richTooltipColors2 = richTooltipColors;
                        }
                        if (i8 != 0) {
                            fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                        } else {
                            fM3537getLevel0D9Ej5fM = f;
                        }
                        if (i10 != 0) {
                            fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                        } else {
                            fM3835getContainerElevationD9Ej5fM = f2;
                        }
                        richTooltipColors3 = richTooltipColors2;
                        i13 = i3;
                        f3 = fM3537getLevel0D9Ej5fM;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1867454921, i13, -1, "androidx.compose.material3.RichTooltip (Tooltip.android.kt:147)");
                    }
                    ProvidableCompositionLocal<Dp> localAbsoluteTonalElevation2 = SurfaceKt.getLocalAbsoluteTonalElevation();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume4 = composerStartRestartGroup.consume(localAbsoluteTonalElevation2);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    jM2171applyTonalElevationRFCenO8 = ColorSchemeKt.m2171applyTonalElevationRFCenO8(MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6), richTooltipColors3.getContainerColor(), Dp.constructor-impl(((Dp) objConsume4).unbox-impl() + f3), composerStartRestartGroup, 0);
                    composerStartRestartGroup.startReplaceGroup(1472746423);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "153@6122L7,154@6181L7,155@6220L341");
                    float f7 = f3;
                    if (j3 != InlineClassHelperKt.UnspecifiedPackedFloats) {
                        z = true;
                    } else {
                        z = false;
                    }
                    if (z) {
                        ProvidableCompositionLocal<Density> localDensity2 = CompositionLocalsKt.getLocalDensity();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume5 = composerStartRestartGroup.consume(localDensity2);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        density = (Density) objConsume5;
                        ProvidableCompositionLocal<Configuration> localConfiguration2 = AndroidCompositionLocals_androidKt.getLocalConfiguration();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume6 = composerStartRestartGroup.consume(localConfiguration2);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        configuration = (Configuration) objConsume6;
                        Modifier.Companion companion3 = Modifier.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1472751513, "CC(remember):Tooltip.android.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changedInstance(configuration) | composerStartRestartGroup.changed(jM2171applyTonalElevationRFCenO8) | ((((57344 & i13) ^ 24576) <= 16384 && composerStartRestartGroup.changed(j3)) || (i13 & 24576) == 16384);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            final long j6 = j3;
                            objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                                {
                                    super(2);
                                }

                                public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                                    return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j6, layoutCoordinates);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            final long j7 = j3;
                            objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                                {
                                    super(2);
                                }

                                public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                                    return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j7, layoutCoordinates);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        modifierThen = tooltipScope.drawCaret(companion3, (Function2) objRememberedValue).then(companion);
                    } else {
                        modifierThen = companion;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    function8 = function7;
                    final Function2<? super Composer, ? super Integer, Unit> function12 = function6;
                    int i19 = i13 >> 9;
                    SurfaceKt.m2868SurfaceT9BRK9s(SizeKt.m1084sizeInqDBjuR0$default(modifierThen, TooltipKt.getTooltipMinWidth(), TooltipKt.getTooltipMinHeight(), TooltipKt.getRichTooltipMaxWidth(), 0.0f, 8, null), richTooltipContainerShape, richTooltipColors3.getContainerColor(), 0L, f7, fM3835getContainerElevationD9Ej5fM, null, ComposableLambdaKt.rememberComposableLambda(317290958, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i110) {
                            ComposerKt.sourceInformation(composer2, "C179@7066L5,180@7133L5,181@7210L5,183@7225L1355:Tooltip.android.kt#uh7d8r");
                            if ((i110 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(317290958, i110, -1, "androidx.compose.material3.RichTooltip.<anonymous> (Tooltip.android.kt:179)");
                                }
                                TextStyle value = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                TextStyle value2 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSubheadFont(), composer2, 6);
                                TextStyle value3 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                Modifier modifierM1037paddingVpY3zN4$default = PaddingKt.m1037paddingVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getRichTooltipHorizontalPadding(), 0.0f, 2, null);
                                Function2<Composer, Integer, Unit> function13 = function12;
                                Function2<Composer, Integer, Unit> function14 = function8;
                                RichTooltipColors richTooltipColors5 = richTooltipColors3;
                                Function2<Composer, Integer, Unit> function15 = function4;
                                ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.INSTANCE.getStart(), composer2, 0);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1037paddingVpY3zN4$default);
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
                                ComposerKt.sourceInformationMarkerStart(composer2, -459254051, "C193@7718L319:Tooltip.android.kt#uh7d8r");
                                composer2.startReplaceGroup(955016030);
                                ComposerKt.sourceInformation(composer2, "*185@7347L344");
                                if (function13 != null) {
                                    Modifier modifierM886paddingFromBaselineVpY3zN4$default = AlignmentLineKt.m886paddingFromBaselineVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getHeightToSubheadFirstLine(), 0.0f, 2, null);
                                    ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                    CompositionLocalMap currentCompositionLocalMap2 = composer2.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer2, modifierM886paddingFromBaselineVpY3zN4$default);
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
                                    Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                        composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                        composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1468424960, "C186@7446L227:Tooltip.android.kt#uh7d8r");
                                    CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getTitleContentColor())), TextKt.getLocalTextStyle().provides(value2)}, function13, composer2, ProvidedValue.$stable);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    composer2.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    Unit unit = Unit.INSTANCE;
                                    Unit unit2 = Unit.INSTANCE;
                                }
                                composer2.endReplaceGroup();
                                Modifier modifierTextVerticalPadding = TooltipKt.textVerticalPadding(Modifier.INSTANCE, function13 != null, function14 != null);
                                ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap3 = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer2, modifierTextVerticalPadding);
                                Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer2.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer2.startReusableNode();
                                if (composer2.getInserting()) {
                                    composer2.createNode(constructor3);
                                } else {
                                    composer2.useNode();
                                }
                                Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer2);
                                Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                    composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                    composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer2, -1959181329, "C194@7812L211:Tooltip.android.kt#uh7d8r");
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getContentColor())), TextKt.getLocalTextStyle().provides(value3)}, function15, composer2, ProvidedValue.$stable);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.startReplaceGroup(955039618);
                                ComposerKt.sourceInformation(composer2, "*201@8080L476");
                                if (function14 != null) {
                                    Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1071requiredHeightInVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getActionLabelMinHeight(), 0.0f, 2, null), 0.0f, 0.0f, 0.0f, TooltipKt.getActionLabelBottomPadding(), 7, null);
                                    ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy3 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash4 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                    CompositionLocalMap currentCompositionLocalMap4 = composer2.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier4 = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
                                    Function0<ComposeUiNode> constructor4 = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer2.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer2.startReusableNode();
                                    if (composer2.getInserting()) {
                                        composer2.createNode(constructor4);
                                    } else {
                                        composer2.useNode();
                                    }
                                    Composer composerM4037constructorimpl4 = Updater.m4037constructorimpl(composer2);
                                    Updater.m4044setimpl(composerM4037constructorimpl4, measurePolicyMaybeCachedBoxMeasurePolicy3, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl4, currentCompositionLocalMap4, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash4 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl4.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl4.rememberedValue(), Integer.valueOf(currentCompositeKeyHash4))) {
                                        composerM4037constructorimpl4.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash4));
                                        composerM4037constructorimpl4.apply(Integer.valueOf(currentCompositeKeyHash4), setCompositeKeyHash4);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl4, modifierMaterializeModifier4, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance3 = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1469278235, "C206@8306L232:Tooltip.android.kt#uh7d8r");
                                    CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getActionContentColor())), TextKt.getLocalTextStyle().provides(value)}, function14, composer2, ProvidedValue.$stable);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    composer2.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    Unit unit3 = Unit.INSTANCE;
                                    Unit unit4 = Unit.INSTANCE;
                                }
                                composer2.endReplaceGroup();
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
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i13 >> 12) & 112) | 12582912 | (57344 & i19) | (i19 & 458752), 72);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function9 = function12;
                    j4 = j3;
                    richTooltipContainerShape = richTooltipContainerShape;
                    f4 = f7;
                    richTooltipColors4 = richTooltipColors3;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function6 = null;
                        } else {
                            function6 = function2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 8) != 0) {
                            j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                            i3 &= -57345;
                        } else {
                            j3 = j2;
                        }
                        if ((i2 & 16) != 0) {
                            richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 32) != 0) {
                            richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            richTooltipColors2 = richTooltipColors;
                        }
                        if (i8 != 0) {
                            fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                        } else {
                            fM3537getLevel0D9Ej5fM = f;
                        }
                        if (i10 != 0) {
                            fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                        } else {
                            fM3835getContainerElevationD9Ej5fM = f2;
                        }
                        richTooltipColors3 = richTooltipColors2;
                        i13 = i3;
                        f3 = fM3537getLevel0D9Ej5fM;
                    } else {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function6 = null;
                        } else {
                            function6 = function2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 8) != 0) {
                            j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                            i3 &= -57345;
                        } else {
                            j3 = j2;
                        }
                        if ((i2 & 16) != 0) {
                            richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 32) != 0) {
                            richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            richTooltipColors2 = richTooltipColors;
                        }
                        if (i8 != 0) {
                            fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                        } else {
                            fM3537getLevel0D9Ej5fM = f;
                        }
                        if (i10 != 0) {
                            fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                        } else {
                            fM3835getContainerElevationD9Ej5fM = f2;
                        }
                        richTooltipColors3 = richTooltipColors2;
                        i13 = i3;
                        f3 = fM3537getLevel0D9Ej5fM;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1867454921, i13, -1, "androidx.compose.material3.RichTooltip (Tooltip.android.kt:147)");
                    }
                    ProvidableCompositionLocal<Dp> localAbsoluteTonalElevation3 = SurfaceKt.getLocalAbsoluteTonalElevation();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume7 = composerStartRestartGroup.consume(localAbsoluteTonalElevation3);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    jM2171applyTonalElevationRFCenO8 = ColorSchemeKt.m2171applyTonalElevationRFCenO8(MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6), richTooltipColors3.getContainerColor(), Dp.constructor-impl(((Dp) objConsume7).unbox-impl() + f3), composerStartRestartGroup, 0);
                    composerStartRestartGroup.startReplaceGroup(1472746423);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "153@6122L7,154@6181L7,155@6220L341");
                    float f8 = f3;
                    if (j3 != InlineClassHelperKt.UnspecifiedPackedFloats) {
                        z = true;
                    } else {
                        z = false;
                    }
                    if (z) {
                        ProvidableCompositionLocal<Density> localDensity3 = CompositionLocalsKt.getLocalDensity();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume8 = composerStartRestartGroup.consume(localDensity3);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        density = (Density) objConsume8;
                        ProvidableCompositionLocal<Configuration> localConfiguration3 = AndroidCompositionLocals_androidKt.getLocalConfiguration();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume9 = composerStartRestartGroup.consume(localConfiguration3);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        configuration = (Configuration) objConsume9;
                        Modifier.Companion companion4 = Modifier.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1472751513, "CC(remember):Tooltip.android.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changedInstance(configuration) | composerStartRestartGroup.changed(jM2171applyTonalElevationRFCenO8) | ((((57344 & i13) ^ 24576) <= 16384 && composerStartRestartGroup.changed(j3)) || (i13 & 24576) == 16384);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            final long j8 = j3;
                            objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                                {
                                    super(2);
                                }

                                public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                                    return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j8, layoutCoordinates);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            final long j9 = j3;
                            objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                                {
                                    super(2);
                                }

                                public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                                    return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j9, layoutCoordinates);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        modifierThen = tooltipScope.drawCaret(companion4, (Function2) objRememberedValue).then(companion);
                    } else {
                        modifierThen = companion;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    function8 = function7;
                    final Function2<? super Composer, ? super Integer, Unit> function13 = function6;
                    int i110 = i13 >> 9;
                    SurfaceKt.m2868SurfaceT9BRK9s(SizeKt.m1084sizeInqDBjuR0$default(modifierThen, TooltipKt.getTooltipMinWidth(), TooltipKt.getTooltipMinHeight(), TooltipKt.getRichTooltipMaxWidth(), 0.0f, 8, null), richTooltipContainerShape, richTooltipColors3.getContainerColor(), 0L, f8, fM3835getContainerElevationD9Ej5fM, null, ComposableLambdaKt.rememberComposableLambda(317290958, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111) {
                            ComposerKt.sourceInformation(composer2, "C179@7066L5,180@7133L5,181@7210L5,183@7225L1355:Tooltip.android.kt#uh7d8r");
                            if ((i111 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(317290958, i111, -1, "androidx.compose.material3.RichTooltip.<anonymous> (Tooltip.android.kt:179)");
                                }
                                TextStyle value = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                TextStyle value2 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSubheadFont(), composer2, 6);
                                TextStyle value3 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                Modifier modifierM1037paddingVpY3zN4$default = PaddingKt.m1037paddingVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getRichTooltipHorizontalPadding(), 0.0f, 2, null);
                                Function2<Composer, Integer, Unit> function14 = function13;
                                Function2<Composer, Integer, Unit> function15 = function8;
                                RichTooltipColors richTooltipColors5 = richTooltipColors3;
                                Function2<Composer, Integer, Unit> function16 = function4;
                                ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.INSTANCE.getStart(), composer2, 0);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1037paddingVpY3zN4$default);
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
                                ComposerKt.sourceInformationMarkerStart(composer2, -459254051, "C193@7718L319:Tooltip.android.kt#uh7d8r");
                                composer2.startReplaceGroup(955016030);
                                ComposerKt.sourceInformation(composer2, "*185@7347L344");
                                if (function14 != null) {
                                    Modifier modifierM886paddingFromBaselineVpY3zN4$default = AlignmentLineKt.m886paddingFromBaselineVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getHeightToSubheadFirstLine(), 0.0f, 2, null);
                                    ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                    CompositionLocalMap currentCompositionLocalMap2 = composer2.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer2, modifierM886paddingFromBaselineVpY3zN4$default);
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
                                    Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                        composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                        composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1468424960, "C186@7446L227:Tooltip.android.kt#uh7d8r");
                                    CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getTitleContentColor())), TextKt.getLocalTextStyle().provides(value2)}, function14, composer2, ProvidedValue.$stable);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    composer2.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    Unit unit = Unit.INSTANCE;
                                    Unit unit2 = Unit.INSTANCE;
                                }
                                composer2.endReplaceGroup();
                                Modifier modifierTextVerticalPadding = TooltipKt.textVerticalPadding(Modifier.INSTANCE, function14 != null, function15 != null);
                                ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap3 = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer2, modifierTextVerticalPadding);
                                Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer2.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer2.startReusableNode();
                                if (composer2.getInserting()) {
                                    composer2.createNode(constructor3);
                                } else {
                                    composer2.useNode();
                                }
                                Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer2);
                                Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                    composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                    composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer2, -1959181329, "C194@7812L211:Tooltip.android.kt#uh7d8r");
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getContentColor())), TextKt.getLocalTextStyle().provides(value3)}, function16, composer2, ProvidedValue.$stable);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.startReplaceGroup(955039618);
                                ComposerKt.sourceInformation(composer2, "*201@8080L476");
                                if (function15 != null) {
                                    Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1071requiredHeightInVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getActionLabelMinHeight(), 0.0f, 2, null), 0.0f, 0.0f, 0.0f, TooltipKt.getActionLabelBottomPadding(), 7, null);
                                    ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy3 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash4 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                    CompositionLocalMap currentCompositionLocalMap4 = composer2.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier4 = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
                                    Function0<ComposeUiNode> constructor4 = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer2.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer2.startReusableNode();
                                    if (composer2.getInserting()) {
                                        composer2.createNode(constructor4);
                                    } else {
                                        composer2.useNode();
                                    }
                                    Composer composerM4037constructorimpl4 = Updater.m4037constructorimpl(composer2);
                                    Updater.m4044setimpl(composerM4037constructorimpl4, measurePolicyMaybeCachedBoxMeasurePolicy3, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl4, currentCompositionLocalMap4, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash4 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl4.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl4.rememberedValue(), Integer.valueOf(currentCompositeKeyHash4))) {
                                        composerM4037constructorimpl4.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash4));
                                        composerM4037constructorimpl4.apply(Integer.valueOf(currentCompositeKeyHash4), setCompositeKeyHash4);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl4, modifierMaterializeModifier4, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance3 = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1469278235, "C206@8306L232:Tooltip.android.kt#uh7d8r");
                                    CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getActionContentColor())), TextKt.getLocalTextStyle().provides(value)}, function15, composer2, ProvidedValue.$stable);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    composer2.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    Unit unit3 = Unit.INSTANCE;
                                    Unit unit4 = Unit.INSTANCE;
                                }
                                composer2.endReplaceGroup();
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
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i13 >> 12) & 112) | 12582912 | (57344 & i110) | (i110 & 458752), 72);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function9 = function13;
                    j4 = j3;
                    richTooltipContainerShape = richTooltipContainerShape;
                    f4 = f8;
                    richTooltipColors4 = richTooltipColors3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier3 = companion;
                    final Function2<? super Composer, ? super Integer, Unit> function14 = function8;
                    final Shape shape3 = richTooltipContainerShape;
                    final float f9 = fM3835getContainerElevationD9Ej5fM;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111) {
                            Tooltip_androidKt.m3184RichTooltipyDvdmqw(tooltipScope, modifier3, function9, function14, j4, shape3, richTooltipColors4, f4, f9, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 384;
            i6 = i2 & 4;
            if (i6 != 0) {
                if ((i & 3072) == 0) {
                    function5 = function3;
                    if (composerStartRestartGroup.changedInstance(function5)) {
                        i7 = Fields.CameraDistance;
                    } else {
                        i7 = Fields.RotationZ;
                    }
                    i3 |= i7;
                }
                if ((i & 24576) == 0) {
                    j2 = j;
                    if ((i2 & 8) == 0) {
                        i15 = Fields.Shape;
                    } else {
                        i15 = Fields.Shape;
                    }
                    i3 |= i15;
                } else {
                    j2 = j;
                }
                if ((196608 & i) == 0) {
                    if ((i2 & 16) == 0) {
                        richTooltipContainerShape = shape;
                        if (composerStartRestartGroup.changed(richTooltipContainerShape)) {
                        }
                        i3 |= i17;
                    } else {
                        richTooltipContainerShape = shape;
                    }
                    i3 |= i17;
                } else {
                    richTooltipContainerShape = shape;
                }
                if ((i & 1572864) != 0) {
                    if ((i2 & 32) == 0) {
                        i14 = 524288;
                    } else {
                        i14 = 524288;
                    }
                    i3 |= i14;
                }
                i8 = i2 & 64;
                if (i8 != 0) {
                    i3 |= 12582912;
                } else if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(f)) {
                        i9 = 8388608;
                    } else {
                        i9 = 4194304;
                    }
                    i3 |= i9;
                }
                i10 = i2 & Fields.SpotShadowColor;
                if (i10 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(f2)) {
                        i11 = 67108864;
                    } else {
                        i11 = 33554432;
                    }
                    i3 |= i11;
                }
                if ((i2 & Fields.RotationX) != 0) {
                    i3 |= 805306368;
                } else if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i12 = 536870912;
                    } else {
                        i12 = 268435456;
                    }
                    i3 |= i12;
                }
                if ((306783379 & i3) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function6 = null;
                        } else {
                            function6 = function2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 8) != 0) {
                            j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                            i3 &= -57345;
                        } else {
                            j3 = j2;
                        }
                        if ((i2 & 16) != 0) {
                            richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 32) != 0) {
                            richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            richTooltipColors2 = richTooltipColors;
                        }
                        if (i8 != 0) {
                            fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                        } else {
                            fM3537getLevel0D9Ej5fM = f;
                        }
                        if (i10 != 0) {
                            fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                        } else {
                            fM3835getContainerElevationD9Ej5fM = f2;
                        }
                        richTooltipColors3 = richTooltipColors2;
                        i13 = i3;
                        f3 = fM3537getLevel0D9Ej5fM;
                    } else {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function6 = null;
                        } else {
                            function6 = function2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 8) != 0) {
                            j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                            i3 &= -57345;
                        } else {
                            j3 = j2;
                        }
                        if ((i2 & 16) != 0) {
                            richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 32) != 0) {
                            richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            richTooltipColors2 = richTooltipColors;
                        }
                        if (i8 != 0) {
                            fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                        } else {
                            fM3537getLevel0D9Ej5fM = f;
                        }
                        if (i10 != 0) {
                            fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                        } else {
                            fM3835getContainerElevationD9Ej5fM = f2;
                        }
                        richTooltipColors3 = richTooltipColors2;
                        i13 = i3;
                        f3 = fM3537getLevel0D9Ej5fM;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1867454921, i13, -1, "androidx.compose.material3.RichTooltip (Tooltip.android.kt:147)");
                    }
                    ProvidableCompositionLocal<Dp> localAbsoluteTonalElevation4 = SurfaceKt.getLocalAbsoluteTonalElevation();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume10 = composerStartRestartGroup.consume(localAbsoluteTonalElevation4);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    jM2171applyTonalElevationRFCenO8 = ColorSchemeKt.m2171applyTonalElevationRFCenO8(MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6), richTooltipColors3.getContainerColor(), Dp.constructor-impl(((Dp) objConsume10).unbox-impl() + f3), composerStartRestartGroup, 0);
                    composerStartRestartGroup.startReplaceGroup(1472746423);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "153@6122L7,154@6181L7,155@6220L341");
                    float f10 = f3;
                    if (j3 != InlineClassHelperKt.UnspecifiedPackedFloats) {
                        z = true;
                    } else {
                        z = false;
                    }
                    if (z) {
                        ProvidableCompositionLocal<Density> localDensity4 = CompositionLocalsKt.getLocalDensity();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume11 = composerStartRestartGroup.consume(localDensity4);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        density = (Density) objConsume11;
                        ProvidableCompositionLocal<Configuration> localConfiguration4 = AndroidCompositionLocals_androidKt.getLocalConfiguration();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume12 = composerStartRestartGroup.consume(localConfiguration4);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        configuration = (Configuration) objConsume12;
                        Modifier.Companion companion5 = Modifier.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1472751513, "CC(remember):Tooltip.android.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changedInstance(configuration) | composerStartRestartGroup.changed(jM2171applyTonalElevationRFCenO8) | ((((57344 & i13) ^ 24576) <= 16384 && composerStartRestartGroup.changed(j3)) || (i13 & 24576) == 16384);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            final long j10 = j3;
                            objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                                {
                                    super(2);
                                }

                                public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                                    return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j10, layoutCoordinates);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            final long j11 = j3;
                            objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                                {
                                    super(2);
                                }

                                public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                                    return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j11, layoutCoordinates);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        modifierThen = tooltipScope.drawCaret(companion5, (Function2) objRememberedValue).then(companion);
                    } else {
                        modifierThen = companion;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    function8 = function7;
                    final Function2<? super Composer, ? super Integer, Unit> function15 = function6;
                    int i111 = i13 >> 9;
                    SurfaceKt.m2868SurfaceT9BRK9s(SizeKt.m1084sizeInqDBjuR0$default(modifierThen, TooltipKt.getTooltipMinWidth(), TooltipKt.getTooltipMinHeight(), TooltipKt.getRichTooltipMaxWidth(), 0.0f, 8, null), richTooltipContainerShape, richTooltipColors3.getContainerColor(), 0L, f10, fM3835getContainerElevationD9Ej5fM, null, ComposableLambdaKt.rememberComposableLambda(317290958, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i112) {
                            ComposerKt.sourceInformation(composer2, "C179@7066L5,180@7133L5,181@7210L5,183@7225L1355:Tooltip.android.kt#uh7d8r");
                            if ((i112 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(317290958, i112, -1, "androidx.compose.material3.RichTooltip.<anonymous> (Tooltip.android.kt:179)");
                                }
                                TextStyle value = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                TextStyle value2 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSubheadFont(), composer2, 6);
                                TextStyle value3 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                Modifier modifierM1037paddingVpY3zN4$default = PaddingKt.m1037paddingVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getRichTooltipHorizontalPadding(), 0.0f, 2, null);
                                Function2<Composer, Integer, Unit> function16 = function15;
                                Function2<Composer, Integer, Unit> function17 = function8;
                                RichTooltipColors richTooltipColors5 = richTooltipColors3;
                                Function2<Composer, Integer, Unit> function18 = function4;
                                ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.INSTANCE.getStart(), composer2, 0);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1037paddingVpY3zN4$default);
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
                                ComposerKt.sourceInformationMarkerStart(composer2, -459254051, "C193@7718L319:Tooltip.android.kt#uh7d8r");
                                composer2.startReplaceGroup(955016030);
                                ComposerKt.sourceInformation(composer2, "*185@7347L344");
                                if (function16 != null) {
                                    Modifier modifierM886paddingFromBaselineVpY3zN4$default = AlignmentLineKt.m886paddingFromBaselineVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getHeightToSubheadFirstLine(), 0.0f, 2, null);
                                    ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                    CompositionLocalMap currentCompositionLocalMap2 = composer2.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer2, modifierM886paddingFromBaselineVpY3zN4$default);
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
                                    Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                        composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                        composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1468424960, "C186@7446L227:Tooltip.android.kt#uh7d8r");
                                    CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getTitleContentColor())), TextKt.getLocalTextStyle().provides(value2)}, function16, composer2, ProvidedValue.$stable);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    composer2.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    Unit unit = Unit.INSTANCE;
                                    Unit unit2 = Unit.INSTANCE;
                                }
                                composer2.endReplaceGroup();
                                Modifier modifierTextVerticalPadding = TooltipKt.textVerticalPadding(Modifier.INSTANCE, function16 != null, function17 != null);
                                ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap3 = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer2, modifierTextVerticalPadding);
                                Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer2.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer2.startReusableNode();
                                if (composer2.getInserting()) {
                                    composer2.createNode(constructor3);
                                } else {
                                    composer2.useNode();
                                }
                                Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer2);
                                Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                    composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                    composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer2, -1959181329, "C194@7812L211:Tooltip.android.kt#uh7d8r");
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getContentColor())), TextKt.getLocalTextStyle().provides(value3)}, function18, composer2, ProvidedValue.$stable);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.startReplaceGroup(955039618);
                                ComposerKt.sourceInformation(composer2, "*201@8080L476");
                                if (function17 != null) {
                                    Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1071requiredHeightInVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getActionLabelMinHeight(), 0.0f, 2, null), 0.0f, 0.0f, 0.0f, TooltipKt.getActionLabelBottomPadding(), 7, null);
                                    ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy3 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash4 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                    CompositionLocalMap currentCompositionLocalMap4 = composer2.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier4 = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
                                    Function0<ComposeUiNode> constructor4 = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer2.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer2.startReusableNode();
                                    if (composer2.getInserting()) {
                                        composer2.createNode(constructor4);
                                    } else {
                                        composer2.useNode();
                                    }
                                    Composer composerM4037constructorimpl4 = Updater.m4037constructorimpl(composer2);
                                    Updater.m4044setimpl(composerM4037constructorimpl4, measurePolicyMaybeCachedBoxMeasurePolicy3, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl4, currentCompositionLocalMap4, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash4 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl4.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl4.rememberedValue(), Integer.valueOf(currentCompositeKeyHash4))) {
                                        composerM4037constructorimpl4.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash4));
                                        composerM4037constructorimpl4.apply(Integer.valueOf(currentCompositeKeyHash4), setCompositeKeyHash4);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl4, modifierMaterializeModifier4, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance3 = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1469278235, "C206@8306L232:Tooltip.android.kt#uh7d8r");
                                    CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getActionContentColor())), TextKt.getLocalTextStyle().provides(value)}, function17, composer2, ProvidedValue.$stable);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    composer2.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    Unit unit3 = Unit.INSTANCE;
                                    Unit unit4 = Unit.INSTANCE;
                                }
                                composer2.endReplaceGroup();
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
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i13 >> 12) & 112) | 12582912 | (57344 & i111) | (i111 & 458752), 72);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function9 = function15;
                    j4 = j3;
                    richTooltipContainerShape = richTooltipContainerShape;
                    f4 = f10;
                    richTooltipColors4 = richTooltipColors3;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function6 = null;
                        } else {
                            function6 = function2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 8) != 0) {
                            j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                            i3 &= -57345;
                        } else {
                            j3 = j2;
                        }
                        if ((i2 & 16) != 0) {
                            richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 32) != 0) {
                            richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            richTooltipColors2 = richTooltipColors;
                        }
                        if (i8 != 0) {
                            fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                        } else {
                            fM3537getLevel0D9Ej5fM = f;
                        }
                        if (i10 != 0) {
                            fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                        } else {
                            fM3835getContainerElevationD9Ej5fM = f2;
                        }
                        richTooltipColors3 = richTooltipColors2;
                        i13 = i3;
                        f3 = fM3537getLevel0D9Ej5fM;
                    } else {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function6 = null;
                        } else {
                            function6 = function2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 8) != 0) {
                            j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                            i3 &= -57345;
                        } else {
                            j3 = j2;
                        }
                        if ((i2 & 16) != 0) {
                            richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 32) != 0) {
                            richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            richTooltipColors2 = richTooltipColors;
                        }
                        if (i8 != 0) {
                            fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                        } else {
                            fM3537getLevel0D9Ej5fM = f;
                        }
                        if (i10 != 0) {
                            fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                        } else {
                            fM3835getContainerElevationD9Ej5fM = f2;
                        }
                        richTooltipColors3 = richTooltipColors2;
                        i13 = i3;
                        f3 = fM3537getLevel0D9Ej5fM;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1867454921, i13, -1, "androidx.compose.material3.RichTooltip (Tooltip.android.kt:147)");
                    }
                    ProvidableCompositionLocal<Dp> localAbsoluteTonalElevation5 = SurfaceKt.getLocalAbsoluteTonalElevation();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume13 = composerStartRestartGroup.consume(localAbsoluteTonalElevation5);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    jM2171applyTonalElevationRFCenO8 = ColorSchemeKt.m2171applyTonalElevationRFCenO8(MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6), richTooltipColors3.getContainerColor(), Dp.constructor-impl(((Dp) objConsume13).unbox-impl() + f3), composerStartRestartGroup, 0);
                    composerStartRestartGroup.startReplaceGroup(1472746423);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "153@6122L7,154@6181L7,155@6220L341");
                    float f11 = f3;
                    if (j3 != InlineClassHelperKt.UnspecifiedPackedFloats) {
                        z = true;
                    } else {
                        z = false;
                    }
                    if (z) {
                        ProvidableCompositionLocal<Density> localDensity5 = CompositionLocalsKt.getLocalDensity();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume14 = composerStartRestartGroup.consume(localDensity5);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        density = (Density) objConsume14;
                        ProvidableCompositionLocal<Configuration> localConfiguration5 = AndroidCompositionLocals_androidKt.getLocalConfiguration();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume15 = composerStartRestartGroup.consume(localConfiguration5);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        configuration = (Configuration) objConsume15;
                        Modifier.Companion companion6 = Modifier.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1472751513, "CC(remember):Tooltip.android.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changedInstance(configuration) | composerStartRestartGroup.changed(jM2171applyTonalElevationRFCenO8) | ((((57344 & i13) ^ 24576) <= 16384 && composerStartRestartGroup.changed(j3)) || (i13 & 24576) == 16384);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            final long j12 = j3;
                            objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                                {
                                    super(2);
                                }

                                public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                                    return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j12, layoutCoordinates);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            final long j13 = j3;
                            objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                                {
                                    super(2);
                                }

                                public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                                    return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j13, layoutCoordinates);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        modifierThen = tooltipScope.drawCaret(companion6, (Function2) objRememberedValue).then(companion);
                    } else {
                        modifierThen = companion;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    function8 = function7;
                    final Function2<? super Composer, ? super Integer, Unit> function16 = function6;
                    int i112 = i13 >> 9;
                    SurfaceKt.m2868SurfaceT9BRK9s(SizeKt.m1084sizeInqDBjuR0$default(modifierThen, TooltipKt.getTooltipMinWidth(), TooltipKt.getTooltipMinHeight(), TooltipKt.getRichTooltipMaxWidth(), 0.0f, 8, null), richTooltipContainerShape, richTooltipColors3.getContainerColor(), 0L, f11, fM3835getContainerElevationD9Ej5fM, null, ComposableLambdaKt.rememberComposableLambda(317290958, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i113) {
                            ComposerKt.sourceInformation(composer2, "C179@7066L5,180@7133L5,181@7210L5,183@7225L1355:Tooltip.android.kt#uh7d8r");
                            if ((i113 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(317290958, i113, -1, "androidx.compose.material3.RichTooltip.<anonymous> (Tooltip.android.kt:179)");
                                }
                                TextStyle value = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                TextStyle value2 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSubheadFont(), composer2, 6);
                                TextStyle value3 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                Modifier modifierM1037paddingVpY3zN4$default = PaddingKt.m1037paddingVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getRichTooltipHorizontalPadding(), 0.0f, 2, null);
                                Function2<Composer, Integer, Unit> function17 = function16;
                                Function2<Composer, Integer, Unit> function18 = function8;
                                RichTooltipColors richTooltipColors5 = richTooltipColors3;
                                Function2<Composer, Integer, Unit> function19 = function4;
                                ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.INSTANCE.getStart(), composer2, 0);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1037paddingVpY3zN4$default);
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
                                ComposerKt.sourceInformationMarkerStart(composer2, -459254051, "C193@7718L319:Tooltip.android.kt#uh7d8r");
                                composer2.startReplaceGroup(955016030);
                                ComposerKt.sourceInformation(composer2, "*185@7347L344");
                                if (function17 != null) {
                                    Modifier modifierM886paddingFromBaselineVpY3zN4$default = AlignmentLineKt.m886paddingFromBaselineVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getHeightToSubheadFirstLine(), 0.0f, 2, null);
                                    ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                    CompositionLocalMap currentCompositionLocalMap2 = composer2.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer2, modifierM886paddingFromBaselineVpY3zN4$default);
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
                                    Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                        composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                        composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1468424960, "C186@7446L227:Tooltip.android.kt#uh7d8r");
                                    CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getTitleContentColor())), TextKt.getLocalTextStyle().provides(value2)}, function17, composer2, ProvidedValue.$stable);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    composer2.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    Unit unit = Unit.INSTANCE;
                                    Unit unit2 = Unit.INSTANCE;
                                }
                                composer2.endReplaceGroup();
                                Modifier modifierTextVerticalPadding = TooltipKt.textVerticalPadding(Modifier.INSTANCE, function17 != null, function18 != null);
                                ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap3 = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer2, modifierTextVerticalPadding);
                                Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer2.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer2.startReusableNode();
                                if (composer2.getInserting()) {
                                    composer2.createNode(constructor3);
                                } else {
                                    composer2.useNode();
                                }
                                Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer2);
                                Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                    composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                    composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer2, -1959181329, "C194@7812L211:Tooltip.android.kt#uh7d8r");
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getContentColor())), TextKt.getLocalTextStyle().provides(value3)}, function19, composer2, ProvidedValue.$stable);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.startReplaceGroup(955039618);
                                ComposerKt.sourceInformation(composer2, "*201@8080L476");
                                if (function18 != null) {
                                    Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1071requiredHeightInVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getActionLabelMinHeight(), 0.0f, 2, null), 0.0f, 0.0f, 0.0f, TooltipKt.getActionLabelBottomPadding(), 7, null);
                                    ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy3 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash4 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                    CompositionLocalMap currentCompositionLocalMap4 = composer2.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier4 = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
                                    Function0<ComposeUiNode> constructor4 = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer2.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer2.startReusableNode();
                                    if (composer2.getInserting()) {
                                        composer2.createNode(constructor4);
                                    } else {
                                        composer2.useNode();
                                    }
                                    Composer composerM4037constructorimpl4 = Updater.m4037constructorimpl(composer2);
                                    Updater.m4044setimpl(composerM4037constructorimpl4, measurePolicyMaybeCachedBoxMeasurePolicy3, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl4, currentCompositionLocalMap4, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash4 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl4.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl4.rememberedValue(), Integer.valueOf(currentCompositeKeyHash4))) {
                                        composerM4037constructorimpl4.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash4));
                                        composerM4037constructorimpl4.apply(Integer.valueOf(currentCompositeKeyHash4), setCompositeKeyHash4);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl4, modifierMaterializeModifier4, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance3 = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1469278235, "C206@8306L232:Tooltip.android.kt#uh7d8r");
                                    CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getActionContentColor())), TextKt.getLocalTextStyle().provides(value)}, function18, composer2, ProvidedValue.$stable);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    composer2.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    Unit unit3 = Unit.INSTANCE;
                                    Unit unit4 = Unit.INSTANCE;
                                }
                                composer2.endReplaceGroup();
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
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i13 >> 12) & 112) | 12582912 | (57344 & i112) | (i112 & 458752), 72);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function9 = function16;
                    j4 = j3;
                    richTooltipContainerShape = richTooltipContainerShape;
                    f4 = f11;
                    richTooltipColors4 = richTooltipColors3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier4 = companion;
                    final Function2<? super Composer, ? super Integer, Unit> function17 = function8;
                    final Shape shape4 = richTooltipContainerShape;
                    final float f12 = fM3835getContainerElevationD9Ej5fM;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i113) {
                            Tooltip_androidKt.m3184RichTooltipyDvdmqw(tooltipScope, modifier4, function9, function17, j4, shape4, richTooltipColors4, f4, f12, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            function5 = function3;
            if ((i & 24576) == 0) {
                j2 = j;
                if ((i2 & 8) == 0) {
                    i15 = Fields.Shape;
                } else {
                    i15 = Fields.Shape;
                }
                i3 |= i15;
            } else {
                j2 = j;
            }
            if ((196608 & i) == 0) {
                if ((i2 & 16) == 0) {
                    richTooltipContainerShape = shape;
                    if (composerStartRestartGroup.changed(richTooltipContainerShape)) {
                    }
                    i3 |= i17;
                } else {
                    richTooltipContainerShape = shape;
                }
                i3 |= i17;
            } else {
                richTooltipContainerShape = shape;
            }
            if ((i & 1572864) != 0) {
                if ((i2 & 32) == 0) {
                    i14 = 524288;
                } else {
                    i14 = 524288;
                }
                i3 |= i14;
            }
            i8 = i2 & 64;
            if (i8 != 0) {
                i3 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changed(f)) {
                    i9 = 8388608;
                } else {
                    i9 = 4194304;
                }
                i3 |= i9;
            }
            i10 = i2 & Fields.SpotShadowColor;
            if (i10 != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(f2)) {
                    i11 = 67108864;
                } else {
                    i11 = 33554432;
                }
                i3 |= i11;
            }
            if ((i2 & Fields.RotationX) != 0) {
                i3 |= 805306368;
            } else if ((i & 805306368) == 0) {
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i12 = 536870912;
                } else {
                    i12 = 268435456;
                }
                i3 |= i12;
            }
            if ((306783379 & i3) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function6 = null;
                    } else {
                        function6 = function2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 8) != 0) {
                        j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                        i3 &= -57345;
                    } else {
                        j3 = j2;
                    }
                    if ((i2 & 16) != 0) {
                        richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 32) != 0) {
                        richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        richTooltipColors2 = richTooltipColors;
                    }
                    if (i8 != 0) {
                        fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                    } else {
                        fM3537getLevel0D9Ej5fM = f;
                    }
                    if (i10 != 0) {
                        fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                    } else {
                        fM3835getContainerElevationD9Ej5fM = f2;
                    }
                    richTooltipColors3 = richTooltipColors2;
                    i13 = i3;
                    f3 = fM3537getLevel0D9Ej5fM;
                } else {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function6 = null;
                    } else {
                        function6 = function2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 8) != 0) {
                        j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                        i3 &= -57345;
                    } else {
                        j3 = j2;
                    }
                    if ((i2 & 16) != 0) {
                        richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 32) != 0) {
                        richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        richTooltipColors2 = richTooltipColors;
                    }
                    if (i8 != 0) {
                        fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                    } else {
                        fM3537getLevel0D9Ej5fM = f;
                    }
                    if (i10 != 0) {
                        fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                    } else {
                        fM3835getContainerElevationD9Ej5fM = f2;
                    }
                    richTooltipColors3 = richTooltipColors2;
                    i13 = i3;
                    f3 = fM3537getLevel0D9Ej5fM;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1867454921, i13, -1, "androidx.compose.material3.RichTooltip (Tooltip.android.kt:147)");
                }
                ProvidableCompositionLocal<Dp> localAbsoluteTonalElevation6 = SurfaceKt.getLocalAbsoluteTonalElevation();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume16 = composerStartRestartGroup.consume(localAbsoluteTonalElevation6);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                jM2171applyTonalElevationRFCenO8 = ColorSchemeKt.m2171applyTonalElevationRFCenO8(MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6), richTooltipColors3.getContainerColor(), Dp.constructor-impl(((Dp) objConsume16).unbox-impl() + f3), composerStartRestartGroup, 0);
                composerStartRestartGroup.startReplaceGroup(1472746423);
                ComposerKt.sourceInformation(composerStartRestartGroup, "153@6122L7,154@6181L7,155@6220L341");
                float f13 = f3;
                if (j3 != InlineClassHelperKt.UnspecifiedPackedFloats) {
                    z = true;
                } else {
                    z = false;
                }
                if (z) {
                    ProvidableCompositionLocal<Density> localDensity6 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume17 = composerStartRestartGroup.consume(localDensity6);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume17;
                    ProvidableCompositionLocal<Configuration> localConfiguration6 = AndroidCompositionLocals_androidKt.getLocalConfiguration();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume18 = composerStartRestartGroup.consume(localConfiguration6);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    configuration = (Configuration) objConsume18;
                    Modifier.Companion companion7 = Modifier.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1472751513, "CC(remember):Tooltip.android.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changedInstance(configuration) | composerStartRestartGroup.changed(jM2171applyTonalElevationRFCenO8) | ((((57344 & i13) ^ 24576) <= 16384 && composerStartRestartGroup.changed(j3)) || (i13 & 24576) == 16384);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        final long j14 = j3;
                        objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                            {
                                super(2);
                            }

                            public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                                return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j14, layoutCoordinates);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        final long j15 = j3;
                        objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                            {
                                super(2);
                            }

                            public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                                return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j15, layoutCoordinates);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    modifierThen = tooltipScope.drawCaret(companion7, (Function2) objRememberedValue).then(companion);
                } else {
                    modifierThen = companion;
                }
                composerStartRestartGroup.endReplaceGroup();
                function8 = function7;
                final Function2<? super Composer, ? super Integer, Unit> function18 = function6;
                int i113 = i13 >> 9;
                SurfaceKt.m2868SurfaceT9BRK9s(SizeKt.m1084sizeInqDBjuR0$default(modifierThen, TooltipKt.getTooltipMinWidth(), TooltipKt.getTooltipMinHeight(), TooltipKt.getRichTooltipMaxWidth(), 0.0f, 8, null), richTooltipContainerShape, richTooltipColors3.getContainerColor(), 0L, f13, fM3835getContainerElevationD9Ej5fM, null, ComposableLambdaKt.rememberComposableLambda(317290958, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i114) {
                        ComposerKt.sourceInformation(composer2, "C179@7066L5,180@7133L5,181@7210L5,183@7225L1355:Tooltip.android.kt#uh7d8r");
                        if ((i114 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(317290958, i114, -1, "androidx.compose.material3.RichTooltip.<anonymous> (Tooltip.android.kt:179)");
                            }
                            TextStyle value = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                            TextStyle value2 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSubheadFont(), composer2, 6);
                            TextStyle value3 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                            Modifier modifierM1037paddingVpY3zN4$default = PaddingKt.m1037paddingVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getRichTooltipHorizontalPadding(), 0.0f, 2, null);
                            Function2<Composer, Integer, Unit> function19 = function18;
                            Function2<Composer, Integer, Unit> function110 = function8;
                            RichTooltipColors richTooltipColors5 = richTooltipColors3;
                            Function2<Composer, Integer, Unit> function111 = function4;
                            ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                            MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.INSTANCE.getStart(), composer2, 0);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1037paddingVpY3zN4$default);
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
                            ComposerKt.sourceInformationMarkerStart(composer2, -459254051, "C193@7718L319:Tooltip.android.kt#uh7d8r");
                            composer2.startReplaceGroup(955016030);
                            ComposerKt.sourceInformation(composer2, "*185@7347L344");
                            if (function19 != null) {
                                Modifier modifierM886paddingFromBaselineVpY3zN4$default = AlignmentLineKt.m886paddingFromBaselineVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getHeightToSubheadFirstLine(), 0.0f, 2, null);
                                ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap2 = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer2, modifierM886paddingFromBaselineVpY3zN4$default);
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
                                Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                    composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                    composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer2, 1468424960, "C186@7446L227:Tooltip.android.kt#uh7d8r");
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getTitleContentColor())), TextKt.getLocalTextStyle().provides(value2)}, function19, composer2, ProvidedValue.$stable);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                Unit unit = Unit.INSTANCE;
                                Unit unit2 = Unit.INSTANCE;
                            }
                            composer2.endReplaceGroup();
                            Modifier modifierTextVerticalPadding = TooltipKt.textVerticalPadding(Modifier.INSTANCE, function19 != null, function110 != null);
                            ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap3 = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer2, modifierTextVerticalPadding);
                            Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                            ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                            if (!(composer2.getApplier() instanceof Applier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composer2.startReusableNode();
                            if (composer2.getInserting()) {
                                composer2.createNode(constructor3);
                            } else {
                                composer2.useNode();
                            }
                            Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer2);
                            Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                            Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                            ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                            BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                            ComposerKt.sourceInformationMarkerStart(composer2, -1959181329, "C194@7812L211:Tooltip.android.kt#uh7d8r");
                            CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getContentColor())), TextKt.getLocalTextStyle().provides(value3)}, function111, composer2, ProvidedValue.$stable);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.startReplaceGroup(955039618);
                            ComposerKt.sourceInformation(composer2, "*201@8080L476");
                            if (function110 != null) {
                                Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1071requiredHeightInVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getActionLabelMinHeight(), 0.0f, 2, null), 0.0f, 0.0f, 0.0f, TooltipKt.getActionLabelBottomPadding(), 7, null);
                                ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy3 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash4 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap4 = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier4 = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
                                Function0<ComposeUiNode> constructor4 = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer2.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer2.startReusableNode();
                                if (composer2.getInserting()) {
                                    composer2.createNode(constructor4);
                                } else {
                                    composer2.useNode();
                                }
                                Composer composerM4037constructorimpl4 = Updater.m4037constructorimpl(composer2);
                                Updater.m4044setimpl(composerM4037constructorimpl4, measurePolicyMaybeCachedBoxMeasurePolicy3, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl4, currentCompositionLocalMap4, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash4 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl4.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl4.rememberedValue(), Integer.valueOf(currentCompositeKeyHash4))) {
                                    composerM4037constructorimpl4.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash4));
                                    composerM4037constructorimpl4.apply(Integer.valueOf(currentCompositeKeyHash4), setCompositeKeyHash4);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl4, modifierMaterializeModifier4, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance3 = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer2, 1469278235, "C206@8306L232:Tooltip.android.kt#uh7d8r");
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getActionContentColor())), TextKt.getLocalTextStyle().provides(value)}, function110, composer2, ProvidedValue.$stable);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                Unit unit3 = Unit.INSTANCE;
                                Unit unit4 = Unit.INSTANCE;
                            }
                            composer2.endReplaceGroup();
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
                }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i13 >> 12) & 112) | 12582912 | (57344 & i113) | (i113 & 458752), 72);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function9 = function18;
                j4 = j3;
                richTooltipContainerShape = richTooltipContainerShape;
                f4 = f13;
                richTooltipColors4 = richTooltipColors3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function6 = null;
                    } else {
                        function6 = function2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 8) != 0) {
                        j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                        i3 &= -57345;
                    } else {
                        j3 = j2;
                    }
                    if ((i2 & 16) != 0) {
                        richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 32) != 0) {
                        richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        richTooltipColors2 = richTooltipColors;
                    }
                    if (i8 != 0) {
                        fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                    } else {
                        fM3537getLevel0D9Ej5fM = f;
                    }
                    if (i10 != 0) {
                        fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                    } else {
                        fM3835getContainerElevationD9Ej5fM = f2;
                    }
                    richTooltipColors3 = richTooltipColors2;
                    i13 = i3;
                    f3 = fM3537getLevel0D9Ej5fM;
                } else {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function6 = null;
                    } else {
                        function6 = function2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 8) != 0) {
                        j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                        i3 &= -57345;
                    } else {
                        j3 = j2;
                    }
                    if ((i2 & 16) != 0) {
                        richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 32) != 0) {
                        richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        richTooltipColors2 = richTooltipColors;
                    }
                    if (i8 != 0) {
                        fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                    } else {
                        fM3537getLevel0D9Ej5fM = f;
                    }
                    if (i10 != 0) {
                        fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                    } else {
                        fM3835getContainerElevationD9Ej5fM = f2;
                    }
                    richTooltipColors3 = richTooltipColors2;
                    i13 = i3;
                    f3 = fM3537getLevel0D9Ej5fM;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1867454921, i13, -1, "androidx.compose.material3.RichTooltip (Tooltip.android.kt:147)");
                }
                ProvidableCompositionLocal<Dp> localAbsoluteTonalElevation7 = SurfaceKt.getLocalAbsoluteTonalElevation();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume19 = composerStartRestartGroup.consume(localAbsoluteTonalElevation7);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                jM2171applyTonalElevationRFCenO8 = ColorSchemeKt.m2171applyTonalElevationRFCenO8(MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6), richTooltipColors3.getContainerColor(), Dp.constructor-impl(((Dp) objConsume19).unbox-impl() + f3), composerStartRestartGroup, 0);
                composerStartRestartGroup.startReplaceGroup(1472746423);
                ComposerKt.sourceInformation(composerStartRestartGroup, "153@6122L7,154@6181L7,155@6220L341");
                float f14 = f3;
                if (j3 != InlineClassHelperKt.UnspecifiedPackedFloats) {
                    z = true;
                } else {
                    z = false;
                }
                if (z) {
                    ProvidableCompositionLocal<Density> localDensity7 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume110 = composerStartRestartGroup.consume(localDensity7);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume110;
                    ProvidableCompositionLocal<Configuration> localConfiguration7 = AndroidCompositionLocals_androidKt.getLocalConfiguration();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111 = composerStartRestartGroup.consume(localConfiguration7);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    configuration = (Configuration) objConsume111;
                    Modifier.Companion companion8 = Modifier.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1472751513, "CC(remember):Tooltip.android.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changedInstance(configuration) | composerStartRestartGroup.changed(jM2171applyTonalElevationRFCenO8) | ((((57344 & i13) ^ 24576) <= 16384 && composerStartRestartGroup.changed(j3)) || (i13 & 24576) == 16384);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        final long j16 = j3;
                        objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                            {
                                super(2);
                            }

                            public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                                return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j16, layoutCoordinates);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        final long j17 = j3;
                        objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                            {
                                super(2);
                            }

                            public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                                return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j17, layoutCoordinates);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    modifierThen = tooltipScope.drawCaret(companion8, (Function2) objRememberedValue).then(companion);
                } else {
                    modifierThen = companion;
                }
                composerStartRestartGroup.endReplaceGroup();
                function8 = function7;
                final Function2<? super Composer, ? super Integer, Unit> function19 = function6;
                int i114 = i13 >> 9;
                SurfaceKt.m2868SurfaceT9BRK9s(SizeKt.m1084sizeInqDBjuR0$default(modifierThen, TooltipKt.getTooltipMinWidth(), TooltipKt.getTooltipMinHeight(), TooltipKt.getRichTooltipMaxWidth(), 0.0f, 8, null), richTooltipContainerShape, richTooltipColors3.getContainerColor(), 0L, f14, fM3835getContainerElevationD9Ej5fM, null, ComposableLambdaKt.rememberComposableLambda(317290958, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i115) {
                        ComposerKt.sourceInformation(composer2, "C179@7066L5,180@7133L5,181@7210L5,183@7225L1355:Tooltip.android.kt#uh7d8r");
                        if ((i115 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(317290958, i115, -1, "androidx.compose.material3.RichTooltip.<anonymous> (Tooltip.android.kt:179)");
                            }
                            TextStyle value = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                            TextStyle value2 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSubheadFont(), composer2, 6);
                            TextStyle value3 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                            Modifier modifierM1037paddingVpY3zN4$default = PaddingKt.m1037paddingVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getRichTooltipHorizontalPadding(), 0.0f, 2, null);
                            Function2<Composer, Integer, Unit> function110 = function19;
                            Function2<Composer, Integer, Unit> function111 = function8;
                            RichTooltipColors richTooltipColors5 = richTooltipColors3;
                            Function2<Composer, Integer, Unit> function112 = function4;
                            ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                            MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.INSTANCE.getStart(), composer2, 0);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1037paddingVpY3zN4$default);
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
                            ComposerKt.sourceInformationMarkerStart(composer2, -459254051, "C193@7718L319:Tooltip.android.kt#uh7d8r");
                            composer2.startReplaceGroup(955016030);
                            ComposerKt.sourceInformation(composer2, "*185@7347L344");
                            if (function110 != null) {
                                Modifier modifierM886paddingFromBaselineVpY3zN4$default = AlignmentLineKt.m886paddingFromBaselineVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getHeightToSubheadFirstLine(), 0.0f, 2, null);
                                ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap2 = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer2, modifierM886paddingFromBaselineVpY3zN4$default);
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
                                Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                    composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                    composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer2, 1468424960, "C186@7446L227:Tooltip.android.kt#uh7d8r");
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getTitleContentColor())), TextKt.getLocalTextStyle().provides(value2)}, function110, composer2, ProvidedValue.$stable);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                Unit unit = Unit.INSTANCE;
                                Unit unit2 = Unit.INSTANCE;
                            }
                            composer2.endReplaceGroup();
                            Modifier modifierTextVerticalPadding = TooltipKt.textVerticalPadding(Modifier.INSTANCE, function110 != null, function111 != null);
                            ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap3 = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer2, modifierTextVerticalPadding);
                            Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                            ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                            if (!(composer2.getApplier() instanceof Applier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composer2.startReusableNode();
                            if (composer2.getInserting()) {
                                composer2.createNode(constructor3);
                            } else {
                                composer2.useNode();
                            }
                            Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer2);
                            Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                            Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                            ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                            BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                            ComposerKt.sourceInformationMarkerStart(composer2, -1959181329, "C194@7812L211:Tooltip.android.kt#uh7d8r");
                            CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getContentColor())), TextKt.getLocalTextStyle().provides(value3)}, function112, composer2, ProvidedValue.$stable);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.startReplaceGroup(955039618);
                            ComposerKt.sourceInformation(composer2, "*201@8080L476");
                            if (function111 != null) {
                                Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1071requiredHeightInVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getActionLabelMinHeight(), 0.0f, 2, null), 0.0f, 0.0f, 0.0f, TooltipKt.getActionLabelBottomPadding(), 7, null);
                                ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy3 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash4 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap4 = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier4 = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
                                Function0<ComposeUiNode> constructor4 = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer2.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer2.startReusableNode();
                                if (composer2.getInserting()) {
                                    composer2.createNode(constructor4);
                                } else {
                                    composer2.useNode();
                                }
                                Composer composerM4037constructorimpl4 = Updater.m4037constructorimpl(composer2);
                                Updater.m4044setimpl(composerM4037constructorimpl4, measurePolicyMaybeCachedBoxMeasurePolicy3, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl4, currentCompositionLocalMap4, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash4 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl4.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl4.rememberedValue(), Integer.valueOf(currentCompositeKeyHash4))) {
                                    composerM4037constructorimpl4.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash4));
                                    composerM4037constructorimpl4.apply(Integer.valueOf(currentCompositeKeyHash4), setCompositeKeyHash4);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl4, modifierMaterializeModifier4, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance3 = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer2, 1469278235, "C206@8306L232:Tooltip.android.kt#uh7d8r");
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getActionContentColor())), TextKt.getLocalTextStyle().provides(value)}, function111, composer2, ProvidedValue.$stable);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                Unit unit3 = Unit.INSTANCE;
                                Unit unit4 = Unit.INSTANCE;
                            }
                            composer2.endReplaceGroup();
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
                }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i13 >> 12) & 112) | 12582912 | (57344 & i114) | (i114 & 458752), 72);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function9 = function19;
                j4 = j3;
                richTooltipContainerShape = richTooltipContainerShape;
                f4 = f14;
                richTooltipColors4 = richTooltipColors3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier5 = companion;
                final Function2<? super Composer, ? super Integer, Unit> function110 = function8;
                final Shape shape5 = richTooltipContainerShape;
                final float f15 = fM3835getContainerElevationD9Ej5fM;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i115) {
                        Tooltip_androidKt.m3184RichTooltipyDvdmqw(tooltipScope, modifier5, function9, function110, j4, shape5, richTooltipColors4, f4, f15, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        i4 = i2 & 2;
        if (i4 != 0) {
            if ((i & 384) == 0) {
                if (composerStartRestartGroup.changedInstance(function2)) {
                    i5 = Fields.RotationX;
                } else {
                    i5 = Fields.SpotShadowColor;
                }
                i3 |= i5;
            }
            i6 = i2 & 4;
            if (i6 != 0) {
                if ((i & 3072) == 0) {
                    function5 = function3;
                    if (composerStartRestartGroup.changedInstance(function5)) {
                        i7 = Fields.CameraDistance;
                    } else {
                        i7 = Fields.RotationZ;
                    }
                    i3 |= i7;
                }
                if ((i & 24576) == 0) {
                    j2 = j;
                    if ((i2 & 8) == 0) {
                        i15 = Fields.Shape;
                    } else {
                        i15 = Fields.Shape;
                    }
                    i3 |= i15;
                } else {
                    j2 = j;
                }
                if ((196608 & i) == 0) {
                    if ((i2 & 16) == 0) {
                        richTooltipContainerShape = shape;
                        if (composerStartRestartGroup.changed(richTooltipContainerShape)) {
                        }
                        i3 |= i17;
                    } else {
                        richTooltipContainerShape = shape;
                    }
                    i3 |= i17;
                } else {
                    richTooltipContainerShape = shape;
                }
                if ((i & 1572864) != 0) {
                    if ((i2 & 32) == 0) {
                        i14 = 524288;
                    } else {
                        i14 = 524288;
                    }
                    i3 |= i14;
                }
                i8 = i2 & 64;
                if (i8 != 0) {
                    i3 |= 12582912;
                } else if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(f)) {
                        i9 = 8388608;
                    } else {
                        i9 = 4194304;
                    }
                    i3 |= i9;
                }
                i10 = i2 & Fields.SpotShadowColor;
                if (i10 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(f2)) {
                        i11 = 67108864;
                    } else {
                        i11 = 33554432;
                    }
                    i3 |= i11;
                }
                if ((i2 & Fields.RotationX) != 0) {
                    i3 |= 805306368;
                } else if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i12 = 536870912;
                    } else {
                        i12 = 268435456;
                    }
                    i3 |= i12;
                }
                if ((306783379 & i3) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function6 = null;
                        } else {
                            function6 = function2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 8) != 0) {
                            j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                            i3 &= -57345;
                        } else {
                            j3 = j2;
                        }
                        if ((i2 & 16) != 0) {
                            richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 32) != 0) {
                            richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            richTooltipColors2 = richTooltipColors;
                        }
                        if (i8 != 0) {
                            fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                        } else {
                            fM3537getLevel0D9Ej5fM = f;
                        }
                        if (i10 != 0) {
                            fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                        } else {
                            fM3835getContainerElevationD9Ej5fM = f2;
                        }
                        richTooltipColors3 = richTooltipColors2;
                        i13 = i3;
                        f3 = fM3537getLevel0D9Ej5fM;
                    } else {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function6 = null;
                        } else {
                            function6 = function2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 8) != 0) {
                            j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                            i3 &= -57345;
                        } else {
                            j3 = j2;
                        }
                        if ((i2 & 16) != 0) {
                            richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 32) != 0) {
                            richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            richTooltipColors2 = richTooltipColors;
                        }
                        if (i8 != 0) {
                            fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                        } else {
                            fM3537getLevel0D9Ej5fM = f;
                        }
                        if (i10 != 0) {
                            fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                        } else {
                            fM3835getContainerElevationD9Ej5fM = f2;
                        }
                        richTooltipColors3 = richTooltipColors2;
                        i13 = i3;
                        f3 = fM3537getLevel0D9Ej5fM;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1867454921, i13, -1, "androidx.compose.material3.RichTooltip (Tooltip.android.kt:147)");
                    }
                    ProvidableCompositionLocal<Dp> localAbsoluteTonalElevation8 = SurfaceKt.getLocalAbsoluteTonalElevation();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume112 = composerStartRestartGroup.consume(localAbsoluteTonalElevation8);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    jM2171applyTonalElevationRFCenO8 = ColorSchemeKt.m2171applyTonalElevationRFCenO8(MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6), richTooltipColors3.getContainerColor(), Dp.constructor-impl(((Dp) objConsume112).unbox-impl() + f3), composerStartRestartGroup, 0);
                    composerStartRestartGroup.startReplaceGroup(1472746423);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "153@6122L7,154@6181L7,155@6220L341");
                    float f16 = f3;
                    if (j3 != InlineClassHelperKt.UnspecifiedPackedFloats) {
                        z = true;
                    } else {
                        z = false;
                    }
                    if (z) {
                        ProvidableCompositionLocal<Density> localDensity8 = CompositionLocalsKt.getLocalDensity();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume113 = composerStartRestartGroup.consume(localDensity8);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        density = (Density) objConsume113;
                        ProvidableCompositionLocal<Configuration> localConfiguration8 = AndroidCompositionLocals_androidKt.getLocalConfiguration();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume114 = composerStartRestartGroup.consume(localConfiguration8);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        configuration = (Configuration) objConsume114;
                        Modifier.Companion companion9 = Modifier.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1472751513, "CC(remember):Tooltip.android.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changedInstance(configuration) | composerStartRestartGroup.changed(jM2171applyTonalElevationRFCenO8) | ((((57344 & i13) ^ 24576) <= 16384 && composerStartRestartGroup.changed(j3)) || (i13 & 24576) == 16384);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            final long j18 = j3;
                            objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                                {
                                    super(2);
                                }

                                public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                                    return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j18, layoutCoordinates);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            final long j19 = j3;
                            objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                                {
                                    super(2);
                                }

                                public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                                    return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j19, layoutCoordinates);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        modifierThen = tooltipScope.drawCaret(companion9, (Function2) objRememberedValue).then(companion);
                    } else {
                        modifierThen = companion;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    function8 = function7;
                    final Function2<? super Composer, ? super Integer, Unit> function111 = function6;
                    int i115 = i13 >> 9;
                    SurfaceKt.m2868SurfaceT9BRK9s(SizeKt.m1084sizeInqDBjuR0$default(modifierThen, TooltipKt.getTooltipMinWidth(), TooltipKt.getTooltipMinHeight(), TooltipKt.getRichTooltipMaxWidth(), 0.0f, 8, null), richTooltipContainerShape, richTooltipColors3.getContainerColor(), 0L, f16, fM3835getContainerElevationD9Ej5fM, null, ComposableLambdaKt.rememberComposableLambda(317290958, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i116) {
                            ComposerKt.sourceInformation(composer2, "C179@7066L5,180@7133L5,181@7210L5,183@7225L1355:Tooltip.android.kt#uh7d8r");
                            if ((i116 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(317290958, i116, -1, "androidx.compose.material3.RichTooltip.<anonymous> (Tooltip.android.kt:179)");
                                }
                                TextStyle value = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                TextStyle value2 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSubheadFont(), composer2, 6);
                                TextStyle value3 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                Modifier modifierM1037paddingVpY3zN4$default = PaddingKt.m1037paddingVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getRichTooltipHorizontalPadding(), 0.0f, 2, null);
                                Function2<Composer, Integer, Unit> function112 = function111;
                                Function2<Composer, Integer, Unit> function113 = function8;
                                RichTooltipColors richTooltipColors5 = richTooltipColors3;
                                Function2<Composer, Integer, Unit> function114 = function4;
                                ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.INSTANCE.getStart(), composer2, 0);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1037paddingVpY3zN4$default);
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
                                ComposerKt.sourceInformationMarkerStart(composer2, -459254051, "C193@7718L319:Tooltip.android.kt#uh7d8r");
                                composer2.startReplaceGroup(955016030);
                                ComposerKt.sourceInformation(composer2, "*185@7347L344");
                                if (function112 != null) {
                                    Modifier modifierM886paddingFromBaselineVpY3zN4$default = AlignmentLineKt.m886paddingFromBaselineVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getHeightToSubheadFirstLine(), 0.0f, 2, null);
                                    ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                    CompositionLocalMap currentCompositionLocalMap2 = composer2.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer2, modifierM886paddingFromBaselineVpY3zN4$default);
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
                                    Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                        composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                        composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1468424960, "C186@7446L227:Tooltip.android.kt#uh7d8r");
                                    CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getTitleContentColor())), TextKt.getLocalTextStyle().provides(value2)}, function112, composer2, ProvidedValue.$stable);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    composer2.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    Unit unit = Unit.INSTANCE;
                                    Unit unit2 = Unit.INSTANCE;
                                }
                                composer2.endReplaceGroup();
                                Modifier modifierTextVerticalPadding = TooltipKt.textVerticalPadding(Modifier.INSTANCE, function112 != null, function113 != null);
                                ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap3 = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer2, modifierTextVerticalPadding);
                                Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer2.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer2.startReusableNode();
                                if (composer2.getInserting()) {
                                    composer2.createNode(constructor3);
                                } else {
                                    composer2.useNode();
                                }
                                Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer2);
                                Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                    composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                    composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer2, -1959181329, "C194@7812L211:Tooltip.android.kt#uh7d8r");
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getContentColor())), TextKt.getLocalTextStyle().provides(value3)}, function114, composer2, ProvidedValue.$stable);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.startReplaceGroup(955039618);
                                ComposerKt.sourceInformation(composer2, "*201@8080L476");
                                if (function113 != null) {
                                    Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1071requiredHeightInVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getActionLabelMinHeight(), 0.0f, 2, null), 0.0f, 0.0f, 0.0f, TooltipKt.getActionLabelBottomPadding(), 7, null);
                                    ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy3 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash4 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                    CompositionLocalMap currentCompositionLocalMap4 = composer2.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier4 = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
                                    Function0<ComposeUiNode> constructor4 = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer2.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer2.startReusableNode();
                                    if (composer2.getInserting()) {
                                        composer2.createNode(constructor4);
                                    } else {
                                        composer2.useNode();
                                    }
                                    Composer composerM4037constructorimpl4 = Updater.m4037constructorimpl(composer2);
                                    Updater.m4044setimpl(composerM4037constructorimpl4, measurePolicyMaybeCachedBoxMeasurePolicy3, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl4, currentCompositionLocalMap4, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash4 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl4.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl4.rememberedValue(), Integer.valueOf(currentCompositeKeyHash4))) {
                                        composerM4037constructorimpl4.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash4));
                                        composerM4037constructorimpl4.apply(Integer.valueOf(currentCompositeKeyHash4), setCompositeKeyHash4);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl4, modifierMaterializeModifier4, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance3 = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1469278235, "C206@8306L232:Tooltip.android.kt#uh7d8r");
                                    CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getActionContentColor())), TextKt.getLocalTextStyle().provides(value)}, function113, composer2, ProvidedValue.$stable);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    composer2.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    Unit unit3 = Unit.INSTANCE;
                                    Unit unit4 = Unit.INSTANCE;
                                }
                                composer2.endReplaceGroup();
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
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i13 >> 12) & 112) | 12582912 | (57344 & i115) | (i115 & 458752), 72);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function9 = function111;
                    j4 = j3;
                    richTooltipContainerShape = richTooltipContainerShape;
                    f4 = f16;
                    richTooltipColors4 = richTooltipColors3;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function6 = null;
                        } else {
                            function6 = function2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 8) != 0) {
                            j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                            i3 &= -57345;
                        } else {
                            j3 = j2;
                        }
                        if ((i2 & 16) != 0) {
                            richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 32) != 0) {
                            richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            richTooltipColors2 = richTooltipColors;
                        }
                        if (i8 != 0) {
                            fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                        } else {
                            fM3537getLevel0D9Ej5fM = f;
                        }
                        if (i10 != 0) {
                            fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                        } else {
                            fM3835getContainerElevationD9Ej5fM = f2;
                        }
                        richTooltipColors3 = richTooltipColors2;
                        i13 = i3;
                        f3 = fM3537getLevel0D9Ej5fM;
                    } else {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            function6 = null;
                        } else {
                            function6 = function2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 8) != 0) {
                            j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                            i3 &= -57345;
                        } else {
                            j3 = j2;
                        }
                        if ((i2 & 16) != 0) {
                            richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 32) != 0) {
                            richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            richTooltipColors2 = richTooltipColors;
                        }
                        if (i8 != 0) {
                            fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                        } else {
                            fM3537getLevel0D9Ej5fM = f;
                        }
                        if (i10 != 0) {
                            fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                        } else {
                            fM3835getContainerElevationD9Ej5fM = f2;
                        }
                        richTooltipColors3 = richTooltipColors2;
                        i13 = i3;
                        f3 = fM3537getLevel0D9Ej5fM;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1867454921, i13, -1, "androidx.compose.material3.RichTooltip (Tooltip.android.kt:147)");
                    }
                    ProvidableCompositionLocal<Dp> localAbsoluteTonalElevation9 = SurfaceKt.getLocalAbsoluteTonalElevation();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume115 = composerStartRestartGroup.consume(localAbsoluteTonalElevation9);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    jM2171applyTonalElevationRFCenO8 = ColorSchemeKt.m2171applyTonalElevationRFCenO8(MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6), richTooltipColors3.getContainerColor(), Dp.constructor-impl(((Dp) objConsume115).unbox-impl() + f3), composerStartRestartGroup, 0);
                    composerStartRestartGroup.startReplaceGroup(1472746423);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "153@6122L7,154@6181L7,155@6220L341");
                    float f17 = f3;
                    if (j3 != InlineClassHelperKt.UnspecifiedPackedFloats) {
                        z = true;
                    } else {
                        z = false;
                    }
                    if (z) {
                        ProvidableCompositionLocal<Density> localDensity9 = CompositionLocalsKt.getLocalDensity();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume116 = composerStartRestartGroup.consume(localDensity9);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        density = (Density) objConsume116;
                        ProvidableCompositionLocal<Configuration> localConfiguration9 = AndroidCompositionLocals_androidKt.getLocalConfiguration();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume117 = composerStartRestartGroup.consume(localConfiguration9);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        configuration = (Configuration) objConsume117;
                        Modifier.Companion companion10 = Modifier.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1472751513, "CC(remember):Tooltip.android.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changedInstance(configuration) | composerStartRestartGroup.changed(jM2171applyTonalElevationRFCenO8) | ((((57344 & i13) ^ 24576) <= 16384 && composerStartRestartGroup.changed(j3)) || (i13 & 24576) == 16384);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            final long j110 = j3;
                            objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                                {
                                    super(2);
                                }

                                public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                                    return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j110, layoutCoordinates);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            final long j111 = j3;
                            objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                                {
                                    super(2);
                                }

                                public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                                    return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j111, layoutCoordinates);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        modifierThen = tooltipScope.drawCaret(companion10, (Function2) objRememberedValue).then(companion);
                    } else {
                        modifierThen = companion;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    function8 = function7;
                    final Function2<? super Composer, ? super Integer, Unit> function112 = function6;
                    int i116 = i13 >> 9;
                    SurfaceKt.m2868SurfaceT9BRK9s(SizeKt.m1084sizeInqDBjuR0$default(modifierThen, TooltipKt.getTooltipMinWidth(), TooltipKt.getTooltipMinHeight(), TooltipKt.getRichTooltipMaxWidth(), 0.0f, 8, null), richTooltipContainerShape, richTooltipColors3.getContainerColor(), 0L, f17, fM3835getContainerElevationD9Ej5fM, null, ComposableLambdaKt.rememberComposableLambda(317290958, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i117) {
                            ComposerKt.sourceInformation(composer2, "C179@7066L5,180@7133L5,181@7210L5,183@7225L1355:Tooltip.android.kt#uh7d8r");
                            if ((i117 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(317290958, i117, -1, "androidx.compose.material3.RichTooltip.<anonymous> (Tooltip.android.kt:179)");
                                }
                                TextStyle value = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                TextStyle value2 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSubheadFont(), composer2, 6);
                                TextStyle value3 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                Modifier modifierM1037paddingVpY3zN4$default = PaddingKt.m1037paddingVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getRichTooltipHorizontalPadding(), 0.0f, 2, null);
                                Function2<Composer, Integer, Unit> function113 = function112;
                                Function2<Composer, Integer, Unit> function114 = function8;
                                RichTooltipColors richTooltipColors5 = richTooltipColors3;
                                Function2<Composer, Integer, Unit> function115 = function4;
                                ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.INSTANCE.getStart(), composer2, 0);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1037paddingVpY3zN4$default);
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
                                ComposerKt.sourceInformationMarkerStart(composer2, -459254051, "C193@7718L319:Tooltip.android.kt#uh7d8r");
                                composer2.startReplaceGroup(955016030);
                                ComposerKt.sourceInformation(composer2, "*185@7347L344");
                                if (function113 != null) {
                                    Modifier modifierM886paddingFromBaselineVpY3zN4$default = AlignmentLineKt.m886paddingFromBaselineVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getHeightToSubheadFirstLine(), 0.0f, 2, null);
                                    ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                    CompositionLocalMap currentCompositionLocalMap2 = composer2.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer2, modifierM886paddingFromBaselineVpY3zN4$default);
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
                                    Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                        composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                        composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1468424960, "C186@7446L227:Tooltip.android.kt#uh7d8r");
                                    CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getTitleContentColor())), TextKt.getLocalTextStyle().provides(value2)}, function113, composer2, ProvidedValue.$stable);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    composer2.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    Unit unit = Unit.INSTANCE;
                                    Unit unit2 = Unit.INSTANCE;
                                }
                                composer2.endReplaceGroup();
                                Modifier modifierTextVerticalPadding = TooltipKt.textVerticalPadding(Modifier.INSTANCE, function113 != null, function114 != null);
                                ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap3 = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer2, modifierTextVerticalPadding);
                                Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer2.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer2.startReusableNode();
                                if (composer2.getInserting()) {
                                    composer2.createNode(constructor3);
                                } else {
                                    composer2.useNode();
                                }
                                Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer2);
                                Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                    composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                    composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer2, -1959181329, "C194@7812L211:Tooltip.android.kt#uh7d8r");
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getContentColor())), TextKt.getLocalTextStyle().provides(value3)}, function115, composer2, ProvidedValue.$stable);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.startReplaceGroup(955039618);
                                ComposerKt.sourceInformation(composer2, "*201@8080L476");
                                if (function114 != null) {
                                    Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1071requiredHeightInVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getActionLabelMinHeight(), 0.0f, 2, null), 0.0f, 0.0f, 0.0f, TooltipKt.getActionLabelBottomPadding(), 7, null);
                                    ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy3 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash4 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                    CompositionLocalMap currentCompositionLocalMap4 = composer2.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier4 = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
                                    Function0<ComposeUiNode> constructor4 = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer2.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer2.startReusableNode();
                                    if (composer2.getInserting()) {
                                        composer2.createNode(constructor4);
                                    } else {
                                        composer2.useNode();
                                    }
                                    Composer composerM4037constructorimpl4 = Updater.m4037constructorimpl(composer2);
                                    Updater.m4044setimpl(composerM4037constructorimpl4, measurePolicyMaybeCachedBoxMeasurePolicy3, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl4, currentCompositionLocalMap4, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash4 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl4.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl4.rememberedValue(), Integer.valueOf(currentCompositeKeyHash4))) {
                                        composerM4037constructorimpl4.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash4));
                                        composerM4037constructorimpl4.apply(Integer.valueOf(currentCompositeKeyHash4), setCompositeKeyHash4);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl4, modifierMaterializeModifier4, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance3 = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1469278235, "C206@8306L232:Tooltip.android.kt#uh7d8r");
                                    CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getActionContentColor())), TextKt.getLocalTextStyle().provides(value)}, function114, composer2, ProvidedValue.$stable);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    composer2.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    Unit unit3 = Unit.INSTANCE;
                                    Unit unit4 = Unit.INSTANCE;
                                }
                                composer2.endReplaceGroup();
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
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i13 >> 12) & 112) | 12582912 | (57344 & i116) | (i116 & 458752), 72);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function9 = function112;
                    j4 = j3;
                    richTooltipContainerShape = richTooltipContainerShape;
                    f4 = f17;
                    richTooltipColors4 = richTooltipColors3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier6 = companion;
                    final Function2<? super Composer, ? super Integer, Unit> function113 = function8;
                    final Shape shape6 = richTooltipContainerShape;
                    final float f18 = fM3835getContainerElevationD9Ej5fM;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i117) {
                            Tooltip_androidKt.m3184RichTooltipyDvdmqw(tooltipScope, modifier6, function9, function113, j4, shape6, richTooltipColors4, f4, f18, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            function5 = function3;
            if ((i & 24576) == 0) {
                j2 = j;
                if ((i2 & 8) == 0) {
                    i15 = Fields.Shape;
                } else {
                    i15 = Fields.Shape;
                }
                i3 |= i15;
            } else {
                j2 = j;
            }
            if ((196608 & i) == 0) {
                if ((i2 & 16) == 0) {
                    richTooltipContainerShape = shape;
                    if (composerStartRestartGroup.changed(richTooltipContainerShape)) {
                    }
                    i3 |= i17;
                } else {
                    richTooltipContainerShape = shape;
                }
                i3 |= i17;
            } else {
                richTooltipContainerShape = shape;
            }
            if ((i & 1572864) != 0) {
                if ((i2 & 32) == 0) {
                    i14 = 524288;
                } else {
                    i14 = 524288;
                }
                i3 |= i14;
            }
            i8 = i2 & 64;
            if (i8 != 0) {
                i3 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changed(f)) {
                    i9 = 8388608;
                } else {
                    i9 = 4194304;
                }
                i3 |= i9;
            }
            i10 = i2 & Fields.SpotShadowColor;
            if (i10 != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(f2)) {
                    i11 = 67108864;
                } else {
                    i11 = 33554432;
                }
                i3 |= i11;
            }
            if ((i2 & Fields.RotationX) != 0) {
                i3 |= 805306368;
            } else if ((i & 805306368) == 0) {
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i12 = 536870912;
                } else {
                    i12 = 268435456;
                }
                i3 |= i12;
            }
            if ((306783379 & i3) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function6 = null;
                    } else {
                        function6 = function2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 8) != 0) {
                        j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                        i3 &= -57345;
                    } else {
                        j3 = j2;
                    }
                    if ((i2 & 16) != 0) {
                        richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 32) != 0) {
                        richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        richTooltipColors2 = richTooltipColors;
                    }
                    if (i8 != 0) {
                        fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                    } else {
                        fM3537getLevel0D9Ej5fM = f;
                    }
                    if (i10 != 0) {
                        fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                    } else {
                        fM3835getContainerElevationD9Ej5fM = f2;
                    }
                    richTooltipColors3 = richTooltipColors2;
                    i13 = i3;
                    f3 = fM3537getLevel0D9Ej5fM;
                } else {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function6 = null;
                    } else {
                        function6 = function2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 8) != 0) {
                        j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                        i3 &= -57345;
                    } else {
                        j3 = j2;
                    }
                    if ((i2 & 16) != 0) {
                        richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 32) != 0) {
                        richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        richTooltipColors2 = richTooltipColors;
                    }
                    if (i8 != 0) {
                        fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                    } else {
                        fM3537getLevel0D9Ej5fM = f;
                    }
                    if (i10 != 0) {
                        fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                    } else {
                        fM3835getContainerElevationD9Ej5fM = f2;
                    }
                    richTooltipColors3 = richTooltipColors2;
                    i13 = i3;
                    f3 = fM3537getLevel0D9Ej5fM;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1867454921, i13, -1, "androidx.compose.material3.RichTooltip (Tooltip.android.kt:147)");
                }
                ProvidableCompositionLocal<Dp> localAbsoluteTonalElevation10 = SurfaceKt.getLocalAbsoluteTonalElevation();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume118 = composerStartRestartGroup.consume(localAbsoluteTonalElevation10);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                jM2171applyTonalElevationRFCenO8 = ColorSchemeKt.m2171applyTonalElevationRFCenO8(MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6), richTooltipColors3.getContainerColor(), Dp.constructor-impl(((Dp) objConsume118).unbox-impl() + f3), composerStartRestartGroup, 0);
                composerStartRestartGroup.startReplaceGroup(1472746423);
                ComposerKt.sourceInformation(composerStartRestartGroup, "153@6122L7,154@6181L7,155@6220L341");
                float f19 = f3;
                if (j3 != InlineClassHelperKt.UnspecifiedPackedFloats) {
                    z = true;
                } else {
                    z = false;
                }
                if (z) {
                    ProvidableCompositionLocal<Density> localDensity10 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume119 = composerStartRestartGroup.consume(localDensity10);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume119;
                    ProvidableCompositionLocal<Configuration> localConfiguration10 = AndroidCompositionLocals_androidKt.getLocalConfiguration();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume1110 = composerStartRestartGroup.consume(localConfiguration10);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    configuration = (Configuration) objConsume1110;
                    Modifier.Companion companion11 = Modifier.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1472751513, "CC(remember):Tooltip.android.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changedInstance(configuration) | composerStartRestartGroup.changed(jM2171applyTonalElevationRFCenO8) | ((((57344 & i13) ^ 24576) <= 16384 && composerStartRestartGroup.changed(j3)) || (i13 & 24576) == 16384);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        final long j112 = j3;
                        objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                            {
                                super(2);
                            }

                            public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                                return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j112, layoutCoordinates);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        final long j113 = j3;
                        objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                            {
                                super(2);
                            }

                            public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                                return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j113, layoutCoordinates);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    modifierThen = tooltipScope.drawCaret(companion11, (Function2) objRememberedValue).then(companion);
                } else {
                    modifierThen = companion;
                }
                composerStartRestartGroup.endReplaceGroup();
                function8 = function7;
                final Function2<? super Composer, ? super Integer, Unit> function114 = function6;
                int i117 = i13 >> 9;
                SurfaceKt.m2868SurfaceT9BRK9s(SizeKt.m1084sizeInqDBjuR0$default(modifierThen, TooltipKt.getTooltipMinWidth(), TooltipKt.getTooltipMinHeight(), TooltipKt.getRichTooltipMaxWidth(), 0.0f, 8, null), richTooltipContainerShape, richTooltipColors3.getContainerColor(), 0L, f19, fM3835getContainerElevationD9Ej5fM, null, ComposableLambdaKt.rememberComposableLambda(317290958, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i118) {
                        ComposerKt.sourceInformation(composer2, "C179@7066L5,180@7133L5,181@7210L5,183@7225L1355:Tooltip.android.kt#uh7d8r");
                        if ((i118 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(317290958, i118, -1, "androidx.compose.material3.RichTooltip.<anonymous> (Tooltip.android.kt:179)");
                            }
                            TextStyle value = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                            TextStyle value2 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSubheadFont(), composer2, 6);
                            TextStyle value3 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                            Modifier modifierM1037paddingVpY3zN4$default = PaddingKt.m1037paddingVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getRichTooltipHorizontalPadding(), 0.0f, 2, null);
                            Function2<Composer, Integer, Unit> function115 = function114;
                            Function2<Composer, Integer, Unit> function116 = function8;
                            RichTooltipColors richTooltipColors5 = richTooltipColors3;
                            Function2<Composer, Integer, Unit> function117 = function4;
                            ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                            MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.INSTANCE.getStart(), composer2, 0);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1037paddingVpY3zN4$default);
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
                            ComposerKt.sourceInformationMarkerStart(composer2, -459254051, "C193@7718L319:Tooltip.android.kt#uh7d8r");
                            composer2.startReplaceGroup(955016030);
                            ComposerKt.sourceInformation(composer2, "*185@7347L344");
                            if (function115 != null) {
                                Modifier modifierM886paddingFromBaselineVpY3zN4$default = AlignmentLineKt.m886paddingFromBaselineVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getHeightToSubheadFirstLine(), 0.0f, 2, null);
                                ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap2 = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer2, modifierM886paddingFromBaselineVpY3zN4$default);
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
                                Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                    composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                    composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer2, 1468424960, "C186@7446L227:Tooltip.android.kt#uh7d8r");
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getTitleContentColor())), TextKt.getLocalTextStyle().provides(value2)}, function115, composer2, ProvidedValue.$stable);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                Unit unit = Unit.INSTANCE;
                                Unit unit2 = Unit.INSTANCE;
                            }
                            composer2.endReplaceGroup();
                            Modifier modifierTextVerticalPadding = TooltipKt.textVerticalPadding(Modifier.INSTANCE, function115 != null, function116 != null);
                            ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap3 = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer2, modifierTextVerticalPadding);
                            Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                            ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                            if (!(composer2.getApplier() instanceof Applier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composer2.startReusableNode();
                            if (composer2.getInserting()) {
                                composer2.createNode(constructor3);
                            } else {
                                composer2.useNode();
                            }
                            Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer2);
                            Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                            Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                            ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                            BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                            ComposerKt.sourceInformationMarkerStart(composer2, -1959181329, "C194@7812L211:Tooltip.android.kt#uh7d8r");
                            CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getContentColor())), TextKt.getLocalTextStyle().provides(value3)}, function117, composer2, ProvidedValue.$stable);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.startReplaceGroup(955039618);
                            ComposerKt.sourceInformation(composer2, "*201@8080L476");
                            if (function116 != null) {
                                Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1071requiredHeightInVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getActionLabelMinHeight(), 0.0f, 2, null), 0.0f, 0.0f, 0.0f, TooltipKt.getActionLabelBottomPadding(), 7, null);
                                ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy3 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash4 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap4 = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier4 = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
                                Function0<ComposeUiNode> constructor4 = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer2.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer2.startReusableNode();
                                if (composer2.getInserting()) {
                                    composer2.createNode(constructor4);
                                } else {
                                    composer2.useNode();
                                }
                                Composer composerM4037constructorimpl4 = Updater.m4037constructorimpl(composer2);
                                Updater.m4044setimpl(composerM4037constructorimpl4, measurePolicyMaybeCachedBoxMeasurePolicy3, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl4, currentCompositionLocalMap4, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash4 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl4.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl4.rememberedValue(), Integer.valueOf(currentCompositeKeyHash4))) {
                                    composerM4037constructorimpl4.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash4));
                                    composerM4037constructorimpl4.apply(Integer.valueOf(currentCompositeKeyHash4), setCompositeKeyHash4);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl4, modifierMaterializeModifier4, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance3 = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer2, 1469278235, "C206@8306L232:Tooltip.android.kt#uh7d8r");
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getActionContentColor())), TextKt.getLocalTextStyle().provides(value)}, function116, composer2, ProvidedValue.$stable);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                Unit unit3 = Unit.INSTANCE;
                                Unit unit4 = Unit.INSTANCE;
                            }
                            composer2.endReplaceGroup();
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
                }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i13 >> 12) & 112) | 12582912 | (57344 & i117) | (i117 & 458752), 72);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function9 = function114;
                j4 = j3;
                richTooltipContainerShape = richTooltipContainerShape;
                f4 = f19;
                richTooltipColors4 = richTooltipColors3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function6 = null;
                    } else {
                        function6 = function2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 8) != 0) {
                        j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                        i3 &= -57345;
                    } else {
                        j3 = j2;
                    }
                    if ((i2 & 16) != 0) {
                        richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 32) != 0) {
                        richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        richTooltipColors2 = richTooltipColors;
                    }
                    if (i8 != 0) {
                        fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                    } else {
                        fM3537getLevel0D9Ej5fM = f;
                    }
                    if (i10 != 0) {
                        fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                    } else {
                        fM3835getContainerElevationD9Ej5fM = f2;
                    }
                    richTooltipColors3 = richTooltipColors2;
                    i13 = i3;
                    f3 = fM3537getLevel0D9Ej5fM;
                } else {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function6 = null;
                    } else {
                        function6 = function2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 8) != 0) {
                        j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                        i3 &= -57345;
                    } else {
                        j3 = j2;
                    }
                    if ((i2 & 16) != 0) {
                        richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 32) != 0) {
                        richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        richTooltipColors2 = richTooltipColors;
                    }
                    if (i8 != 0) {
                        fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                    } else {
                        fM3537getLevel0D9Ej5fM = f;
                    }
                    if (i10 != 0) {
                        fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                    } else {
                        fM3835getContainerElevationD9Ej5fM = f2;
                    }
                    richTooltipColors3 = richTooltipColors2;
                    i13 = i3;
                    f3 = fM3537getLevel0D9Ej5fM;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1867454921, i13, -1, "androidx.compose.material3.RichTooltip (Tooltip.android.kt:147)");
                }
                ProvidableCompositionLocal<Dp> localAbsoluteTonalElevation11 = SurfaceKt.getLocalAbsoluteTonalElevation();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume1111 = composerStartRestartGroup.consume(localAbsoluteTonalElevation11);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                jM2171applyTonalElevationRFCenO8 = ColorSchemeKt.m2171applyTonalElevationRFCenO8(MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6), richTooltipColors3.getContainerColor(), Dp.constructor-impl(((Dp) objConsume1111).unbox-impl() + f3), composerStartRestartGroup, 0);
                composerStartRestartGroup.startReplaceGroup(1472746423);
                ComposerKt.sourceInformation(composerStartRestartGroup, "153@6122L7,154@6181L7,155@6220L341");
                float f110 = f3;
                if (j3 != InlineClassHelperKt.UnspecifiedPackedFloats) {
                    z = true;
                } else {
                    z = false;
                }
                if (z) {
                    ProvidableCompositionLocal<Density> localDensity11 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume1112 = composerStartRestartGroup.consume(localDensity11);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume1112;
                    ProvidableCompositionLocal<Configuration> localConfiguration11 = AndroidCompositionLocals_androidKt.getLocalConfiguration();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume1113 = composerStartRestartGroup.consume(localConfiguration11);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    configuration = (Configuration) objConsume1113;
                    Modifier.Companion companion12 = Modifier.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1472751513, "CC(remember):Tooltip.android.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changedInstance(configuration) | composerStartRestartGroup.changed(jM2171applyTonalElevationRFCenO8) | ((((57344 & i13) ^ 24576) <= 16384 && composerStartRestartGroup.changed(j3)) || (i13 & 24576) == 16384);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        final long j114 = j3;
                        objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                            {
                                super(2);
                            }

                            public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                                return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j114, layoutCoordinates);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        final long j115 = j3;
                        objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                            {
                                super(2);
                            }

                            public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                                return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j115, layoutCoordinates);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    modifierThen = tooltipScope.drawCaret(companion12, (Function2) objRememberedValue).then(companion);
                } else {
                    modifierThen = companion;
                }
                composerStartRestartGroup.endReplaceGroup();
                function8 = function7;
                final Function2<? super Composer, ? super Integer, Unit> function115 = function6;
                int i118 = i13 >> 9;
                SurfaceKt.m2868SurfaceT9BRK9s(SizeKt.m1084sizeInqDBjuR0$default(modifierThen, TooltipKt.getTooltipMinWidth(), TooltipKt.getTooltipMinHeight(), TooltipKt.getRichTooltipMaxWidth(), 0.0f, 8, null), richTooltipContainerShape, richTooltipColors3.getContainerColor(), 0L, f110, fM3835getContainerElevationD9Ej5fM, null, ComposableLambdaKt.rememberComposableLambda(317290958, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i119) {
                        ComposerKt.sourceInformation(composer2, "C179@7066L5,180@7133L5,181@7210L5,183@7225L1355:Tooltip.android.kt#uh7d8r");
                        if ((i119 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(317290958, i119, -1, "androidx.compose.material3.RichTooltip.<anonymous> (Tooltip.android.kt:179)");
                            }
                            TextStyle value = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                            TextStyle value2 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSubheadFont(), composer2, 6);
                            TextStyle value3 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                            Modifier modifierM1037paddingVpY3zN4$default = PaddingKt.m1037paddingVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getRichTooltipHorizontalPadding(), 0.0f, 2, null);
                            Function2<Composer, Integer, Unit> function116 = function115;
                            Function2<Composer, Integer, Unit> function117 = function8;
                            RichTooltipColors richTooltipColors5 = richTooltipColors3;
                            Function2<Composer, Integer, Unit> function118 = function4;
                            ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                            MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.INSTANCE.getStart(), composer2, 0);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1037paddingVpY3zN4$default);
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
                            ComposerKt.sourceInformationMarkerStart(composer2, -459254051, "C193@7718L319:Tooltip.android.kt#uh7d8r");
                            composer2.startReplaceGroup(955016030);
                            ComposerKt.sourceInformation(composer2, "*185@7347L344");
                            if (function116 != null) {
                                Modifier modifierM886paddingFromBaselineVpY3zN4$default = AlignmentLineKt.m886paddingFromBaselineVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getHeightToSubheadFirstLine(), 0.0f, 2, null);
                                ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap2 = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer2, modifierM886paddingFromBaselineVpY3zN4$default);
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
                                Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                    composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                    composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer2, 1468424960, "C186@7446L227:Tooltip.android.kt#uh7d8r");
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getTitleContentColor())), TextKt.getLocalTextStyle().provides(value2)}, function116, composer2, ProvidedValue.$stable);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                Unit unit = Unit.INSTANCE;
                                Unit unit2 = Unit.INSTANCE;
                            }
                            composer2.endReplaceGroup();
                            Modifier modifierTextVerticalPadding = TooltipKt.textVerticalPadding(Modifier.INSTANCE, function116 != null, function117 != null);
                            ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap3 = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer2, modifierTextVerticalPadding);
                            Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                            ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                            if (!(composer2.getApplier() instanceof Applier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composer2.startReusableNode();
                            if (composer2.getInserting()) {
                                composer2.createNode(constructor3);
                            } else {
                                composer2.useNode();
                            }
                            Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer2);
                            Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                            Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                            ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                            BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                            ComposerKt.sourceInformationMarkerStart(composer2, -1959181329, "C194@7812L211:Tooltip.android.kt#uh7d8r");
                            CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getContentColor())), TextKt.getLocalTextStyle().provides(value3)}, function118, composer2, ProvidedValue.$stable);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.startReplaceGroup(955039618);
                            ComposerKt.sourceInformation(composer2, "*201@8080L476");
                            if (function117 != null) {
                                Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1071requiredHeightInVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getActionLabelMinHeight(), 0.0f, 2, null), 0.0f, 0.0f, 0.0f, TooltipKt.getActionLabelBottomPadding(), 7, null);
                                ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy3 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash4 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap4 = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier4 = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
                                Function0<ComposeUiNode> constructor4 = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer2.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer2.startReusableNode();
                                if (composer2.getInserting()) {
                                    composer2.createNode(constructor4);
                                } else {
                                    composer2.useNode();
                                }
                                Composer composerM4037constructorimpl4 = Updater.m4037constructorimpl(composer2);
                                Updater.m4044setimpl(composerM4037constructorimpl4, measurePolicyMaybeCachedBoxMeasurePolicy3, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl4, currentCompositionLocalMap4, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash4 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl4.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl4.rememberedValue(), Integer.valueOf(currentCompositeKeyHash4))) {
                                    composerM4037constructorimpl4.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash4));
                                    composerM4037constructorimpl4.apply(Integer.valueOf(currentCompositeKeyHash4), setCompositeKeyHash4);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl4, modifierMaterializeModifier4, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance3 = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer2, 1469278235, "C206@8306L232:Tooltip.android.kt#uh7d8r");
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getActionContentColor())), TextKt.getLocalTextStyle().provides(value)}, function117, composer2, ProvidedValue.$stable);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                Unit unit3 = Unit.INSTANCE;
                                Unit unit4 = Unit.INSTANCE;
                            }
                            composer2.endReplaceGroup();
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
                }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i13 >> 12) & 112) | 12582912 | (57344 & i118) | (i118 & 458752), 72);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function9 = function115;
                j4 = j3;
                richTooltipContainerShape = richTooltipContainerShape;
                f4 = f110;
                richTooltipColors4 = richTooltipColors3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier7 = companion;
                final Function2<? super Composer, ? super Integer, Unit> function116 = function8;
                final Shape shape7 = richTooltipContainerShape;
                final float f111 = fM3835getContainerElevationD9Ej5fM;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i119) {
                        Tooltip_androidKt.m3184RichTooltipyDvdmqw(tooltipScope, modifier7, function9, function116, j4, shape7, richTooltipColors4, f4, f111, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        i6 = i2 & 4;
        if (i6 != 0) {
            if ((i & 3072) == 0) {
                function5 = function3;
                if (composerStartRestartGroup.changedInstance(function5)) {
                    i7 = Fields.CameraDistance;
                } else {
                    i7 = Fields.RotationZ;
                }
                i3 |= i7;
            }
            if ((i & 24576) == 0) {
                j2 = j;
                if ((i2 & 8) == 0) {
                    i15 = Fields.Shape;
                } else {
                    i15 = Fields.Shape;
                }
                i3 |= i15;
            } else {
                j2 = j;
            }
            if ((196608 & i) == 0) {
                if ((i2 & 16) == 0) {
                    richTooltipContainerShape = shape;
                    if (composerStartRestartGroup.changed(richTooltipContainerShape)) {
                    }
                    i3 |= i17;
                } else {
                    richTooltipContainerShape = shape;
                }
                i3 |= i17;
            } else {
                richTooltipContainerShape = shape;
            }
            if ((i & 1572864) != 0) {
                if ((i2 & 32) == 0) {
                    i14 = 524288;
                } else {
                    i14 = 524288;
                }
                i3 |= i14;
            }
            i8 = i2 & 64;
            if (i8 != 0) {
                i3 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changed(f)) {
                    i9 = 8388608;
                } else {
                    i9 = 4194304;
                }
                i3 |= i9;
            }
            i10 = i2 & Fields.SpotShadowColor;
            if (i10 != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(f2)) {
                    i11 = 67108864;
                } else {
                    i11 = 33554432;
                }
                i3 |= i11;
            }
            if ((i2 & Fields.RotationX) != 0) {
                i3 |= 805306368;
            } else if ((i & 805306368) == 0) {
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i12 = 536870912;
                } else {
                    i12 = 268435456;
                }
                i3 |= i12;
            }
            if ((306783379 & i3) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function6 = null;
                    } else {
                        function6 = function2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 8) != 0) {
                        j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                        i3 &= -57345;
                    } else {
                        j3 = j2;
                    }
                    if ((i2 & 16) != 0) {
                        richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 32) != 0) {
                        richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        richTooltipColors2 = richTooltipColors;
                    }
                    if (i8 != 0) {
                        fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                    } else {
                        fM3537getLevel0D9Ej5fM = f;
                    }
                    if (i10 != 0) {
                        fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                    } else {
                        fM3835getContainerElevationD9Ej5fM = f2;
                    }
                    richTooltipColors3 = richTooltipColors2;
                    i13 = i3;
                    f3 = fM3537getLevel0D9Ej5fM;
                } else {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function6 = null;
                    } else {
                        function6 = function2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 8) != 0) {
                        j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                        i3 &= -57345;
                    } else {
                        j3 = j2;
                    }
                    if ((i2 & 16) != 0) {
                        richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 32) != 0) {
                        richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        richTooltipColors2 = richTooltipColors;
                    }
                    if (i8 != 0) {
                        fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                    } else {
                        fM3537getLevel0D9Ej5fM = f;
                    }
                    if (i10 != 0) {
                        fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                    } else {
                        fM3835getContainerElevationD9Ej5fM = f2;
                    }
                    richTooltipColors3 = richTooltipColors2;
                    i13 = i3;
                    f3 = fM3537getLevel0D9Ej5fM;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1867454921, i13, -1, "androidx.compose.material3.RichTooltip (Tooltip.android.kt:147)");
                }
                ProvidableCompositionLocal<Dp> localAbsoluteTonalElevation12 = SurfaceKt.getLocalAbsoluteTonalElevation();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume1114 = composerStartRestartGroup.consume(localAbsoluteTonalElevation12);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                jM2171applyTonalElevationRFCenO8 = ColorSchemeKt.m2171applyTonalElevationRFCenO8(MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6), richTooltipColors3.getContainerColor(), Dp.constructor-impl(((Dp) objConsume1114).unbox-impl() + f3), composerStartRestartGroup, 0);
                composerStartRestartGroup.startReplaceGroup(1472746423);
                ComposerKt.sourceInformation(composerStartRestartGroup, "153@6122L7,154@6181L7,155@6220L341");
                float f112 = f3;
                if (j3 != InlineClassHelperKt.UnspecifiedPackedFloats) {
                    z = true;
                } else {
                    z = false;
                }
                if (z) {
                    ProvidableCompositionLocal<Density> localDensity12 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume1115 = composerStartRestartGroup.consume(localDensity12);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume1115;
                    ProvidableCompositionLocal<Configuration> localConfiguration12 = AndroidCompositionLocals_androidKt.getLocalConfiguration();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume1116 = composerStartRestartGroup.consume(localConfiguration12);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    configuration = (Configuration) objConsume1116;
                    Modifier.Companion companion13 = Modifier.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1472751513, "CC(remember):Tooltip.android.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changedInstance(configuration) | composerStartRestartGroup.changed(jM2171applyTonalElevationRFCenO8) | ((((57344 & i13) ^ 24576) <= 16384 && composerStartRestartGroup.changed(j3)) || (i13 & 24576) == 16384);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        final long j116 = j3;
                        objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                            {
                                super(2);
                            }

                            public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                                return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j116, layoutCoordinates);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        final long j117 = j3;
                        objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                            {
                                super(2);
                            }

                            public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                                return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j117, layoutCoordinates);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    modifierThen = tooltipScope.drawCaret(companion13, (Function2) objRememberedValue).then(companion);
                } else {
                    modifierThen = companion;
                }
                composerStartRestartGroup.endReplaceGroup();
                function8 = function7;
                final Function2<? super Composer, ? super Integer, Unit> function117 = function6;
                int i119 = i13 >> 9;
                SurfaceKt.m2868SurfaceT9BRK9s(SizeKt.m1084sizeInqDBjuR0$default(modifierThen, TooltipKt.getTooltipMinWidth(), TooltipKt.getTooltipMinHeight(), TooltipKt.getRichTooltipMaxWidth(), 0.0f, 8, null), richTooltipContainerShape, richTooltipColors3.getContainerColor(), 0L, f112, fM3835getContainerElevationD9Ej5fM, null, ComposableLambdaKt.rememberComposableLambda(317290958, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1110) {
                        ComposerKt.sourceInformation(composer2, "C179@7066L5,180@7133L5,181@7210L5,183@7225L1355:Tooltip.android.kt#uh7d8r");
                        if ((i1110 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(317290958, i1110, -1, "androidx.compose.material3.RichTooltip.<anonymous> (Tooltip.android.kt:179)");
                            }
                            TextStyle value = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                            TextStyle value2 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSubheadFont(), composer2, 6);
                            TextStyle value3 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                            Modifier modifierM1037paddingVpY3zN4$default = PaddingKt.m1037paddingVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getRichTooltipHorizontalPadding(), 0.0f, 2, null);
                            Function2<Composer, Integer, Unit> function118 = function117;
                            Function2<Composer, Integer, Unit> function119 = function8;
                            RichTooltipColors richTooltipColors5 = richTooltipColors3;
                            Function2<Composer, Integer, Unit> function1110 = function4;
                            ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                            MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.INSTANCE.getStart(), composer2, 0);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1037paddingVpY3zN4$default);
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
                            ComposerKt.sourceInformationMarkerStart(composer2, -459254051, "C193@7718L319:Tooltip.android.kt#uh7d8r");
                            composer2.startReplaceGroup(955016030);
                            ComposerKt.sourceInformation(composer2, "*185@7347L344");
                            if (function118 != null) {
                                Modifier modifierM886paddingFromBaselineVpY3zN4$default = AlignmentLineKt.m886paddingFromBaselineVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getHeightToSubheadFirstLine(), 0.0f, 2, null);
                                ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap2 = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer2, modifierM886paddingFromBaselineVpY3zN4$default);
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
                                Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                    composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                    composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer2, 1468424960, "C186@7446L227:Tooltip.android.kt#uh7d8r");
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getTitleContentColor())), TextKt.getLocalTextStyle().provides(value2)}, function118, composer2, ProvidedValue.$stable);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                Unit unit = Unit.INSTANCE;
                                Unit unit2 = Unit.INSTANCE;
                            }
                            composer2.endReplaceGroup();
                            Modifier modifierTextVerticalPadding = TooltipKt.textVerticalPadding(Modifier.INSTANCE, function118 != null, function119 != null);
                            ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap3 = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer2, modifierTextVerticalPadding);
                            Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                            ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                            if (!(composer2.getApplier() instanceof Applier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composer2.startReusableNode();
                            if (composer2.getInserting()) {
                                composer2.createNode(constructor3);
                            } else {
                                composer2.useNode();
                            }
                            Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer2);
                            Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                            Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                            ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                            BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                            ComposerKt.sourceInformationMarkerStart(composer2, -1959181329, "C194@7812L211:Tooltip.android.kt#uh7d8r");
                            CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getContentColor())), TextKt.getLocalTextStyle().provides(value3)}, function1110, composer2, ProvidedValue.$stable);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.startReplaceGroup(955039618);
                            ComposerKt.sourceInformation(composer2, "*201@8080L476");
                            if (function119 != null) {
                                Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1071requiredHeightInVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getActionLabelMinHeight(), 0.0f, 2, null), 0.0f, 0.0f, 0.0f, TooltipKt.getActionLabelBottomPadding(), 7, null);
                                ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy3 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash4 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap4 = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier4 = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
                                Function0<ComposeUiNode> constructor4 = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer2.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer2.startReusableNode();
                                if (composer2.getInserting()) {
                                    composer2.createNode(constructor4);
                                } else {
                                    composer2.useNode();
                                }
                                Composer composerM4037constructorimpl4 = Updater.m4037constructorimpl(composer2);
                                Updater.m4044setimpl(composerM4037constructorimpl4, measurePolicyMaybeCachedBoxMeasurePolicy3, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl4, currentCompositionLocalMap4, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash4 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl4.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl4.rememberedValue(), Integer.valueOf(currentCompositeKeyHash4))) {
                                    composerM4037constructorimpl4.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash4));
                                    composerM4037constructorimpl4.apply(Integer.valueOf(currentCompositeKeyHash4), setCompositeKeyHash4);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl4, modifierMaterializeModifier4, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance3 = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer2, 1469278235, "C206@8306L232:Tooltip.android.kt#uh7d8r");
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getActionContentColor())), TextKt.getLocalTextStyle().provides(value)}, function119, composer2, ProvidedValue.$stable);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                Unit unit3 = Unit.INSTANCE;
                                Unit unit4 = Unit.INSTANCE;
                            }
                            composer2.endReplaceGroup();
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
                }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i13 >> 12) & 112) | 12582912 | (57344 & i119) | (i119 & 458752), 72);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function9 = function117;
                j4 = j3;
                richTooltipContainerShape = richTooltipContainerShape;
                f4 = f112;
                richTooltipColors4 = richTooltipColors3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function6 = null;
                    } else {
                        function6 = function2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 8) != 0) {
                        j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                        i3 &= -57345;
                    } else {
                        j3 = j2;
                    }
                    if ((i2 & 16) != 0) {
                        richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 32) != 0) {
                        richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        richTooltipColors2 = richTooltipColors;
                    }
                    if (i8 != 0) {
                        fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                    } else {
                        fM3537getLevel0D9Ej5fM = f;
                    }
                    if (i10 != 0) {
                        fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                    } else {
                        fM3835getContainerElevationD9Ej5fM = f2;
                    }
                    richTooltipColors3 = richTooltipColors2;
                    i13 = i3;
                    f3 = fM3537getLevel0D9Ej5fM;
                } else {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        function6 = null;
                    } else {
                        function6 = function2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 8) != 0) {
                        j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                        i3 &= -57345;
                    } else {
                        j3 = j2;
                    }
                    if ((i2 & 16) != 0) {
                        richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 32) != 0) {
                        richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        richTooltipColors2 = richTooltipColors;
                    }
                    if (i8 != 0) {
                        fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                    } else {
                        fM3537getLevel0D9Ej5fM = f;
                    }
                    if (i10 != 0) {
                        fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                    } else {
                        fM3835getContainerElevationD9Ej5fM = f2;
                    }
                    richTooltipColors3 = richTooltipColors2;
                    i13 = i3;
                    f3 = fM3537getLevel0D9Ej5fM;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1867454921, i13, -1, "androidx.compose.material3.RichTooltip (Tooltip.android.kt:147)");
                }
                ProvidableCompositionLocal<Dp> localAbsoluteTonalElevation13 = SurfaceKt.getLocalAbsoluteTonalElevation();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume1117 = composerStartRestartGroup.consume(localAbsoluteTonalElevation13);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                jM2171applyTonalElevationRFCenO8 = ColorSchemeKt.m2171applyTonalElevationRFCenO8(MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6), richTooltipColors3.getContainerColor(), Dp.constructor-impl(((Dp) objConsume1117).unbox-impl() + f3), composerStartRestartGroup, 0);
                composerStartRestartGroup.startReplaceGroup(1472746423);
                ComposerKt.sourceInformation(composerStartRestartGroup, "153@6122L7,154@6181L7,155@6220L341");
                float f113 = f3;
                if (j3 != InlineClassHelperKt.UnspecifiedPackedFloats) {
                    z = true;
                } else {
                    z = false;
                }
                if (z) {
                    ProvidableCompositionLocal<Density> localDensity13 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume1118 = composerStartRestartGroup.consume(localDensity13);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume1118;
                    ProvidableCompositionLocal<Configuration> localConfiguration13 = AndroidCompositionLocals_androidKt.getLocalConfiguration();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume1119 = composerStartRestartGroup.consume(localConfiguration13);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    configuration = (Configuration) objConsume1119;
                    Modifier.Companion companion14 = Modifier.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1472751513, "CC(remember):Tooltip.android.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changedInstance(configuration) | composerStartRestartGroup.changed(jM2171applyTonalElevationRFCenO8) | ((((57344 & i13) ^ 24576) <= 16384 && composerStartRestartGroup.changed(j3)) || (i13 & 24576) == 16384);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        final long j118 = j3;
                        objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                            {
                                super(2);
                            }

                            public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                                return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j118, layoutCoordinates);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        final long j119 = j3;
                        objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                            {
                                super(2);
                            }

                            public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                                return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j119, layoutCoordinates);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    modifierThen = tooltipScope.drawCaret(companion14, (Function2) objRememberedValue).then(companion);
                } else {
                    modifierThen = companion;
                }
                composerStartRestartGroup.endReplaceGroup();
                function8 = function7;
                final Function2<? super Composer, ? super Integer, Unit> function118 = function6;
                int i1110 = i13 >> 9;
                SurfaceKt.m2868SurfaceT9BRK9s(SizeKt.m1084sizeInqDBjuR0$default(modifierThen, TooltipKt.getTooltipMinWidth(), TooltipKt.getTooltipMinHeight(), TooltipKt.getRichTooltipMaxWidth(), 0.0f, 8, null), richTooltipContainerShape, richTooltipColors3.getContainerColor(), 0L, f113, fM3835getContainerElevationD9Ej5fM, null, ComposableLambdaKt.rememberComposableLambda(317290958, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1111) {
                        ComposerKt.sourceInformation(composer2, "C179@7066L5,180@7133L5,181@7210L5,183@7225L1355:Tooltip.android.kt#uh7d8r");
                        if ((i1111 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(317290958, i1111, -1, "androidx.compose.material3.RichTooltip.<anonymous> (Tooltip.android.kt:179)");
                            }
                            TextStyle value = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                            TextStyle value2 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSubheadFont(), composer2, 6);
                            TextStyle value3 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                            Modifier modifierM1037paddingVpY3zN4$default = PaddingKt.m1037paddingVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getRichTooltipHorizontalPadding(), 0.0f, 2, null);
                            Function2<Composer, Integer, Unit> function119 = function118;
                            Function2<Composer, Integer, Unit> function1110 = function8;
                            RichTooltipColors richTooltipColors5 = richTooltipColors3;
                            Function2<Composer, Integer, Unit> function1111 = function4;
                            ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                            MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.INSTANCE.getStart(), composer2, 0);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1037paddingVpY3zN4$default);
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
                            ComposerKt.sourceInformationMarkerStart(composer2, -459254051, "C193@7718L319:Tooltip.android.kt#uh7d8r");
                            composer2.startReplaceGroup(955016030);
                            ComposerKt.sourceInformation(composer2, "*185@7347L344");
                            if (function119 != null) {
                                Modifier modifierM886paddingFromBaselineVpY3zN4$default = AlignmentLineKt.m886paddingFromBaselineVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getHeightToSubheadFirstLine(), 0.0f, 2, null);
                                ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap2 = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer2, modifierM886paddingFromBaselineVpY3zN4$default);
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
                                Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                    composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                    composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer2, 1468424960, "C186@7446L227:Tooltip.android.kt#uh7d8r");
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getTitleContentColor())), TextKt.getLocalTextStyle().provides(value2)}, function119, composer2, ProvidedValue.$stable);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                Unit unit = Unit.INSTANCE;
                                Unit unit2 = Unit.INSTANCE;
                            }
                            composer2.endReplaceGroup();
                            Modifier modifierTextVerticalPadding = TooltipKt.textVerticalPadding(Modifier.INSTANCE, function119 != null, function1110 != null);
                            ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap3 = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer2, modifierTextVerticalPadding);
                            Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                            ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                            if (!(composer2.getApplier() instanceof Applier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composer2.startReusableNode();
                            if (composer2.getInserting()) {
                                composer2.createNode(constructor3);
                            } else {
                                composer2.useNode();
                            }
                            Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer2);
                            Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                            Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                                composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                                composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                            ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                            BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                            ComposerKt.sourceInformationMarkerStart(composer2, -1959181329, "C194@7812L211:Tooltip.android.kt#uh7d8r");
                            CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getContentColor())), TextKt.getLocalTextStyle().provides(value3)}, function1111, composer2, ProvidedValue.$stable);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.startReplaceGroup(955039618);
                            ComposerKt.sourceInformation(composer2, "*201@8080L476");
                            if (function1110 != null) {
                                Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1071requiredHeightInVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getActionLabelMinHeight(), 0.0f, 2, null), 0.0f, 0.0f, 0.0f, TooltipKt.getActionLabelBottomPadding(), 7, null);
                                ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy3 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash4 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap4 = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier4 = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
                                Function0<ComposeUiNode> constructor4 = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer2.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer2.startReusableNode();
                                if (composer2.getInserting()) {
                                    composer2.createNode(constructor4);
                                } else {
                                    composer2.useNode();
                                }
                                Composer composerM4037constructorimpl4 = Updater.m4037constructorimpl(composer2);
                                Updater.m4044setimpl(composerM4037constructorimpl4, measurePolicyMaybeCachedBoxMeasurePolicy3, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl4, currentCompositionLocalMap4, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash4 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl4.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl4.rememberedValue(), Integer.valueOf(currentCompositeKeyHash4))) {
                                    composerM4037constructorimpl4.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash4));
                                    composerM4037constructorimpl4.apply(Integer.valueOf(currentCompositeKeyHash4), setCompositeKeyHash4);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl4, modifierMaterializeModifier4, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance3 = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer2, 1469278235, "C206@8306L232:Tooltip.android.kt#uh7d8r");
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getActionContentColor())), TextKt.getLocalTextStyle().provides(value)}, function1110, composer2, ProvidedValue.$stable);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                Unit unit3 = Unit.INSTANCE;
                                Unit unit4 = Unit.INSTANCE;
                            }
                            composer2.endReplaceGroup();
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
                }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i13 >> 12) & 112) | 12582912 | (57344 & i1110) | (i1110 & 458752), 72);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function9 = function118;
                j4 = j3;
                richTooltipContainerShape = richTooltipContainerShape;
                f4 = f113;
                richTooltipColors4 = richTooltipColors3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier8 = companion;
                final Function2<? super Composer, ? super Integer, Unit> function119 = function8;
                final Shape shape8 = richTooltipContainerShape;
                final float f114 = fM3835getContainerElevationD9Ej5fM;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1111) {
                        Tooltip_androidKt.m3184RichTooltipyDvdmqw(tooltipScope, modifier8, function9, function119, j4, shape8, richTooltipColors4, f4, f114, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        function5 = function3;
        if ((i & 24576) == 0) {
            j2 = j;
            if ((i2 & 8) == 0) {
                i15 = Fields.Shape;
            } else {
                i15 = Fields.Shape;
            }
            i3 |= i15;
        } else {
            j2 = j;
        }
        if ((196608 & i) == 0) {
            if ((i2 & 16) == 0) {
                richTooltipContainerShape = shape;
                if (composerStartRestartGroup.changed(richTooltipContainerShape)) {
                }
                i3 |= i17;
            } else {
                richTooltipContainerShape = shape;
            }
            i3 |= i17;
        } else {
            richTooltipContainerShape = shape;
        }
        if ((i & 1572864) != 0) {
            if ((i2 & 32) == 0) {
                i14 = 524288;
            } else {
                i14 = 524288;
            }
            i3 |= i14;
        }
        i8 = i2 & 64;
        if (i8 != 0) {
            i3 |= 12582912;
        } else if ((i & 12582912) == 0) {
            if (composerStartRestartGroup.changed(f)) {
                i9 = 8388608;
            } else {
                i9 = 4194304;
            }
            i3 |= i9;
        }
        i10 = i2 & Fields.SpotShadowColor;
        if (i10 != 0) {
            i3 |= 100663296;
        } else if ((i & 100663296) == 0) {
            if (composerStartRestartGroup.changed(f2)) {
                i11 = 67108864;
            } else {
                i11 = 33554432;
            }
            i3 |= i11;
        }
        if ((i2 & Fields.RotationX) != 0) {
            i3 |= 805306368;
        } else if ((i & 805306368) == 0) {
            if (composerStartRestartGroup.changedInstance(function4)) {
                i12 = 536870912;
            } else {
                i12 = 268435456;
            }
            i3 |= i12;
        }
        if ((306783379 & i3) == 306783378) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i16 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i4 != 0) {
                    function6 = null;
                } else {
                    function6 = function2;
                }
                if (i6 == 0) {
                }
                if ((i2 & 8) != 0) {
                    j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                    i3 &= -57345;
                } else {
                    j3 = j2;
                }
                if ((i2 & 16) != 0) {
                    richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                    i3 &= -458753;
                }
                if ((i2 & 32) != 0) {
                    richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                    i3 &= -3670017;
                } else {
                    richTooltipColors2 = richTooltipColors;
                }
                if (i8 != 0) {
                    fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                } else {
                    fM3537getLevel0D9Ej5fM = f;
                }
                if (i10 != 0) {
                    fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                } else {
                    fM3835getContainerElevationD9Ej5fM = f2;
                }
                richTooltipColors3 = richTooltipColors2;
                i13 = i3;
                f3 = fM3537getLevel0D9Ej5fM;
            } else {
                if (i16 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i4 != 0) {
                    function6 = null;
                } else {
                    function6 = function2;
                }
                if (i6 == 0) {
                }
                if ((i2 & 8) != 0) {
                    j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                    i3 &= -57345;
                } else {
                    j3 = j2;
                }
                if ((i2 & 16) != 0) {
                    richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                    i3 &= -458753;
                }
                if ((i2 & 32) != 0) {
                    richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                    i3 &= -3670017;
                } else {
                    richTooltipColors2 = richTooltipColors;
                }
                if (i8 != 0) {
                    fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                } else {
                    fM3537getLevel0D9Ej5fM = f;
                }
                if (i10 != 0) {
                    fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                } else {
                    fM3835getContainerElevationD9Ej5fM = f2;
                }
                richTooltipColors3 = richTooltipColors2;
                i13 = i3;
                f3 = fM3537getLevel0D9Ej5fM;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1867454921, i13, -1, "androidx.compose.material3.RichTooltip (Tooltip.android.kt:147)");
            }
            ProvidableCompositionLocal<Dp> localAbsoluteTonalElevation14 = SurfaceKt.getLocalAbsoluteTonalElevation();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume11110 = composerStartRestartGroup.consume(localAbsoluteTonalElevation14);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            jM2171applyTonalElevationRFCenO8 = ColorSchemeKt.m2171applyTonalElevationRFCenO8(MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6), richTooltipColors3.getContainerColor(), Dp.constructor-impl(((Dp) objConsume11110).unbox-impl() + f3), composerStartRestartGroup, 0);
            composerStartRestartGroup.startReplaceGroup(1472746423);
            ComposerKt.sourceInformation(composerStartRestartGroup, "153@6122L7,154@6181L7,155@6220L341");
            float f115 = f3;
            if (j3 != InlineClassHelperKt.UnspecifiedPackedFloats) {
                z = true;
            } else {
                z = false;
            }
            if (z) {
                ProvidableCompositionLocal<Density> localDensity14 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume11111 = composerStartRestartGroup.consume(localDensity14);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume11111;
                ProvidableCompositionLocal<Configuration> localConfiguration14 = AndroidCompositionLocals_androidKt.getLocalConfiguration();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume11112 = composerStartRestartGroup.consume(localConfiguration14);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                configuration = (Configuration) objConsume11112;
                Modifier.Companion companion15 = Modifier.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1472751513, "CC(remember):Tooltip.android.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changedInstance(configuration) | composerStartRestartGroup.changed(jM2171applyTonalElevationRFCenO8) | ((((57344 & i13) ^ 24576) <= 16384 && composerStartRestartGroup.changed(j3)) || (i13 & 24576) == 16384);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    final long j1110 = j3;
                    objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                        {
                            super(2);
                        }

                        public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                            return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j1110, layoutCoordinates);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    final long j1111 = j3;
                    objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                        {
                            super(2);
                        }

                        public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                            return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j1111, layoutCoordinates);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                modifierThen = tooltipScope.drawCaret(companion15, (Function2) objRememberedValue).then(companion);
            } else {
                modifierThen = companion;
            }
            composerStartRestartGroup.endReplaceGroup();
            function8 = function7;
            final Function2<? super Composer, ? super Integer, Unit> function1110 = function6;
            int i1111 = i13 >> 9;
            SurfaceKt.m2868SurfaceT9BRK9s(SizeKt.m1084sizeInqDBjuR0$default(modifierThen, TooltipKt.getTooltipMinWidth(), TooltipKt.getTooltipMinHeight(), TooltipKt.getRichTooltipMaxWidth(), 0.0f, 8, null), richTooltipContainerShape, richTooltipColors3.getContainerColor(), 0L, f115, fM3835getContainerElevationD9Ej5fM, null, ComposableLambdaKt.rememberComposableLambda(317290958, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i1112) {
                    ComposerKt.sourceInformation(composer2, "C179@7066L5,180@7133L5,181@7210L5,183@7225L1355:Tooltip.android.kt#uh7d8r");
                    if ((i1112 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(317290958, i1112, -1, "androidx.compose.material3.RichTooltip.<anonymous> (Tooltip.android.kt:179)");
                        }
                        TextStyle value = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                        TextStyle value2 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSubheadFont(), composer2, 6);
                        TextStyle value3 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                        Modifier modifierM1037paddingVpY3zN4$default = PaddingKt.m1037paddingVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getRichTooltipHorizontalPadding(), 0.0f, 2, null);
                        Function2<Composer, Integer, Unit> function1111 = function1110;
                        Function2<Composer, Integer, Unit> function1112 = function8;
                        RichTooltipColors richTooltipColors5 = richTooltipColors3;
                        Function2<Composer, Integer, Unit> function1113 = function4;
                        ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                        MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.INSTANCE.getStart(), composer2, 0);
                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                        CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1037paddingVpY3zN4$default);
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
                        ComposerKt.sourceInformationMarkerStart(composer2, -459254051, "C193@7718L319:Tooltip.android.kt#uh7d8r");
                        composer2.startReplaceGroup(955016030);
                        ComposerKt.sourceInformation(composer2, "*185@7347L344");
                        if (function1111 != null) {
                            Modifier modifierM886paddingFromBaselineVpY3zN4$default = AlignmentLineKt.m886paddingFromBaselineVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getHeightToSubheadFirstLine(), 0.0f, 2, null);
                            ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap2 = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer2, modifierM886paddingFromBaselineVpY3zN4$default);
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
                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                            ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                            BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                            ComposerKt.sourceInformationMarkerStart(composer2, 1468424960, "C186@7446L227:Tooltip.android.kt#uh7d8r");
                            CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getTitleContentColor())), TextKt.getLocalTextStyle().provides(value2)}, function1111, composer2, ProvidedValue.$stable);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            Unit unit = Unit.INSTANCE;
                            Unit unit2 = Unit.INSTANCE;
                        }
                        composer2.endReplaceGroup();
                        Modifier modifierTextVerticalPadding = TooltipKt.textVerticalPadding(Modifier.INSTANCE, function1111 != null, function1112 != null);
                        ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                        CompositionLocalMap currentCompositionLocalMap3 = composer2.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer2, modifierTextVerticalPadding);
                        Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composer2.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composer2.startReusableNode();
                        if (composer2.getInserting()) {
                            composer2.createNode(constructor3);
                        } else {
                            composer2.useNode();
                        }
                        Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer2);
                        Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                            composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                            composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                        ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                        BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composer2, -1959181329, "C194@7812L211:Tooltip.android.kt#uh7d8r");
                        CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getContentColor())), TextKt.getLocalTextStyle().provides(value3)}, function1113, composer2, ProvidedValue.$stable);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        composer2.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        composer2.startReplaceGroup(955039618);
                        ComposerKt.sourceInformation(composer2, "*201@8080L476");
                        if (function1112 != null) {
                            Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1071requiredHeightInVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getActionLabelMinHeight(), 0.0f, 2, null), 0.0f, 0.0f, 0.0f, TooltipKt.getActionLabelBottomPadding(), 7, null);
                            ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy3 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash4 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap4 = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier4 = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
                            Function0<ComposeUiNode> constructor4 = ComposeUiNode.INSTANCE.getConstructor();
                            ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                            if (!(composer2.getApplier() instanceof Applier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composer2.startReusableNode();
                            if (composer2.getInserting()) {
                                composer2.createNode(constructor4);
                            } else {
                                composer2.useNode();
                            }
                            Composer composerM4037constructorimpl4 = Updater.m4037constructorimpl(composer2);
                            Updater.m4044setimpl(composerM4037constructorimpl4, measurePolicyMaybeCachedBoxMeasurePolicy3, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                            Updater.m4044setimpl(composerM4037constructorimpl4, currentCompositionLocalMap4, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash4 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (composerM4037constructorimpl4.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl4.rememberedValue(), Integer.valueOf(currentCompositeKeyHash4))) {
                                composerM4037constructorimpl4.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash4));
                                composerM4037constructorimpl4.apply(Integer.valueOf(currentCompositeKeyHash4), setCompositeKeyHash4);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl4, modifierMaterializeModifier4, ComposeUiNode.INSTANCE.getSetModifier());
                            ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                            BoxScopeInstance boxScopeInstance3 = BoxScopeInstance.INSTANCE;
                            ComposerKt.sourceInformationMarkerStart(composer2, 1469278235, "C206@8306L232:Tooltip.android.kt#uh7d8r");
                            CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getActionContentColor())), TextKt.getLocalTextStyle().provides(value)}, function1112, composer2, ProvidedValue.$stable);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            Unit unit3 = Unit.INSTANCE;
                            Unit unit4 = Unit.INSTANCE;
                        }
                        composer2.endReplaceGroup();
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
            }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i13 >> 12) & 112) | 12582912 | (57344 & i1111) | (i1111 & 458752), 72);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            function9 = function1110;
            j4 = j3;
            richTooltipContainerShape = richTooltipContainerShape;
            f4 = f115;
            richTooltipColors4 = richTooltipColors3;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i16 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i4 != 0) {
                    function6 = null;
                } else {
                    function6 = function2;
                }
                if (i6 == 0) {
                }
                if ((i2 & 8) != 0) {
                    j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                    i3 &= -57345;
                } else {
                    j3 = j2;
                }
                if ((i2 & 16) != 0) {
                    richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                    i3 &= -458753;
                }
                if ((i2 & 32) != 0) {
                    richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                    i3 &= -3670017;
                } else {
                    richTooltipColors2 = richTooltipColors;
                }
                if (i8 != 0) {
                    fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                } else {
                    fM3537getLevel0D9Ej5fM = f;
                }
                if (i10 != 0) {
                    fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                } else {
                    fM3835getContainerElevationD9Ej5fM = f2;
                }
                richTooltipColors3 = richTooltipColors2;
                i13 = i3;
                f3 = fM3537getLevel0D9Ej5fM;
            } else {
                if (i16 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i4 != 0) {
                    function6 = null;
                } else {
                    function6 = function2;
                }
                if (i6 == 0) {
                }
                if ((i2 & 8) != 0) {
                    j3 = DpSize.Companion.getUnspecified-MYxV2XQ();
                    i3 &= -57345;
                } else {
                    j3 = j2;
                }
                if ((i2 & 16) != 0) {
                    richTooltipContainerShape = TooltipDefaults.INSTANCE.getRichTooltipContainerShape(composerStartRestartGroup, 6);
                    i3 &= -458753;
                }
                if ((i2 & 32) != 0) {
                    richTooltipColors2 = TooltipDefaults.INSTANCE.richTooltipColors(composerStartRestartGroup, 6);
                    i3 &= -3670017;
                } else {
                    richTooltipColors2 = richTooltipColors;
                }
                if (i8 != 0) {
                    fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
                } else {
                    fM3537getLevel0D9Ej5fM = f;
                }
                if (i10 != 0) {
                    fM3835getContainerElevationD9Ej5fM = RichTooltipTokens.INSTANCE.m3835getContainerElevationD9Ej5fM();
                } else {
                    fM3835getContainerElevationD9Ej5fM = f2;
                }
                richTooltipColors3 = richTooltipColors2;
                i13 = i3;
                f3 = fM3537getLevel0D9Ej5fM;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1867454921, i13, -1, "androidx.compose.material3.RichTooltip (Tooltip.android.kt:147)");
            }
            ProvidableCompositionLocal<Dp> localAbsoluteTonalElevation15 = SurfaceKt.getLocalAbsoluteTonalElevation();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume11113 = composerStartRestartGroup.consume(localAbsoluteTonalElevation15);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            jM2171applyTonalElevationRFCenO8 = ColorSchemeKt.m2171applyTonalElevationRFCenO8(MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6), richTooltipColors3.getContainerColor(), Dp.constructor-impl(((Dp) objConsume11113).unbox-impl() + f3), composerStartRestartGroup, 0);
            composerStartRestartGroup.startReplaceGroup(1472746423);
            ComposerKt.sourceInformation(composerStartRestartGroup, "153@6122L7,154@6181L7,155@6220L341");
            float f116 = f3;
            if (j3 != InlineClassHelperKt.UnspecifiedPackedFloats) {
                z = true;
            } else {
                z = false;
            }
            if (z) {
                ProvidableCompositionLocal<Density> localDensity15 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume11114 = composerStartRestartGroup.consume(localDensity15);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume11114;
                ProvidableCompositionLocal<Configuration> localConfiguration15 = AndroidCompositionLocals_androidKt.getLocalConfiguration();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume11115 = composerStartRestartGroup.consume(localConfiguration15);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                configuration = (Configuration) objConsume11115;
                Modifier.Companion companion16 = Modifier.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1472751513, "CC(remember):Tooltip.android.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changedInstance(configuration) | composerStartRestartGroup.changed(jM2171applyTonalElevationRFCenO8) | ((((57344 & i13) ^ 24576) <= 16384 && composerStartRestartGroup.changed(j3)) || (i13 & 24576) == 16384);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    final long j1112 = j3;
                    objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                        {
                            super(2);
                        }

                        public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                            return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j1112, layoutCoordinates);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    final long j1113 = j3;
                    objRememberedValue = (Function2) new Function2<CacheDrawScope, LayoutCoordinates, DrawResult>() {
                        {
                            super(2);
                        }

                        public final DrawResult invoke(CacheDrawScope cacheDrawScope, LayoutCoordinates layoutCoordinates) {
                            return Tooltip_androidKt.m3186drawCaretWithPathJKumZY(cacheDrawScope, CaretType.Rich, density, configuration, jM2171applyTonalElevationRFCenO8, j1113, layoutCoordinates);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                modifierThen = tooltipScope.drawCaret(companion16, (Function2) objRememberedValue).then(companion);
            } else {
                modifierThen = companion;
            }
            composerStartRestartGroup.endReplaceGroup();
            function8 = function7;
            final Function2<? super Composer, ? super Integer, Unit> function1111 = function6;
            int i1112 = i13 >> 9;
            SurfaceKt.m2868SurfaceT9BRK9s(SizeKt.m1084sizeInqDBjuR0$default(modifierThen, TooltipKt.getTooltipMinWidth(), TooltipKt.getTooltipMinHeight(), TooltipKt.getRichTooltipMaxWidth(), 0.0f, 8, null), richTooltipContainerShape, richTooltipColors3.getContainerColor(), 0L, f116, fM3835getContainerElevationD9Ej5fM, null, ComposableLambdaKt.rememberComposableLambda(317290958, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i1113) {
                    ComposerKt.sourceInformation(composer2, "C179@7066L5,180@7133L5,181@7210L5,183@7225L1355:Tooltip.android.kt#uh7d8r");
                    if ((i1113 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(317290958, i1113, -1, "androidx.compose.material3.RichTooltip.<anonymous> (Tooltip.android.kt:179)");
                        }
                        TextStyle value = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                        TextStyle value2 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSubheadFont(), composer2, 6);
                        TextStyle value3 = TypographyKt.getValue(RichTooltipTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                        Modifier modifierM1037paddingVpY3zN4$default = PaddingKt.m1037paddingVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getRichTooltipHorizontalPadding(), 0.0f, 2, null);
                        Function2<Composer, Integer, Unit> function1112 = function1111;
                        Function2<Composer, Integer, Unit> function1113 = function8;
                        RichTooltipColors richTooltipColors5 = richTooltipColors3;
                        Function2<Composer, Integer, Unit> function1114 = function4;
                        ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                        MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.INSTANCE.getStart(), composer2, 0);
                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                        CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1037paddingVpY3zN4$default);
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
                        ComposerKt.sourceInformationMarkerStart(composer2, -459254051, "C193@7718L319:Tooltip.android.kt#uh7d8r");
                        composer2.startReplaceGroup(955016030);
                        ComposerKt.sourceInformation(composer2, "*185@7347L344");
                        if (function1112 != null) {
                            Modifier modifierM886paddingFromBaselineVpY3zN4$default = AlignmentLineKt.m886paddingFromBaselineVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getHeightToSubheadFirstLine(), 0.0f, 2, null);
                            ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap2 = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer2, modifierM886paddingFromBaselineVpY3zN4$default);
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
                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                            ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                            BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                            ComposerKt.sourceInformationMarkerStart(composer2, 1468424960, "C186@7446L227:Tooltip.android.kt#uh7d8r");
                            CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getTitleContentColor())), TextKt.getLocalTextStyle().provides(value2)}, function1112, composer2, ProvidedValue.$stable);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            Unit unit = Unit.INSTANCE;
                            Unit unit2 = Unit.INSTANCE;
                        }
                        composer2.endReplaceGroup();
                        Modifier modifierTextVerticalPadding = TooltipKt.textVerticalPadding(Modifier.INSTANCE, function1112 != null, function1113 != null);
                        ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                        CompositionLocalMap currentCompositionLocalMap3 = composer2.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer2, modifierTextVerticalPadding);
                        Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composer2.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composer2.startReusableNode();
                        if (composer2.getInserting()) {
                            composer2.createNode(constructor3);
                        } else {
                            composer2.useNode();
                        }
                        Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composer2);
                        Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                            composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                            composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                        ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                        BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composer2, -1959181329, "C194@7812L211:Tooltip.android.kt#uh7d8r");
                        CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getContentColor())), TextKt.getLocalTextStyle().provides(value3)}, function1114, composer2, ProvidedValue.$stable);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        composer2.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        composer2.startReplaceGroup(955039618);
                        ComposerKt.sourceInformation(composer2, "*201@8080L476");
                        if (function1113 != null) {
                            Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1071requiredHeightInVpY3zN4$default(Modifier.INSTANCE, TooltipKt.getActionLabelMinHeight(), 0.0f, 2, null), 0.0f, 0.0f, 0.0f, TooltipKt.getActionLabelBottomPadding(), 7, null);
                            ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy3 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash4 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap4 = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier4 = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
                            Function0<ComposeUiNode> constructor4 = ComposeUiNode.INSTANCE.getConstructor();
                            ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                            if (!(composer2.getApplier() instanceof Applier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composer2.startReusableNode();
                            if (composer2.getInserting()) {
                                composer2.createNode(constructor4);
                            } else {
                                composer2.useNode();
                            }
                            Composer composerM4037constructorimpl4 = Updater.m4037constructorimpl(composer2);
                            Updater.m4044setimpl(composerM4037constructorimpl4, measurePolicyMaybeCachedBoxMeasurePolicy3, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                            Updater.m4044setimpl(composerM4037constructorimpl4, currentCompositionLocalMap4, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash4 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (composerM4037constructorimpl4.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl4.rememberedValue(), Integer.valueOf(currentCompositeKeyHash4))) {
                                composerM4037constructorimpl4.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash4));
                                composerM4037constructorimpl4.apply(Integer.valueOf(currentCompositeKeyHash4), setCompositeKeyHash4);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl4, modifierMaterializeModifier4, ComposeUiNode.INSTANCE.getSetModifier());
                            ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                            BoxScopeInstance boxScopeInstance3 = BoxScopeInstance.INSTANCE;
                            ComposerKt.sourceInformationMarkerStart(composer2, 1469278235, "C206@8306L232:Tooltip.android.kt#uh7d8r");
                            CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(richTooltipColors5.getActionContentColor())), TextKt.getLocalTextStyle().provides(value)}, function1113, composer2, ProvidedValue.$stable);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            Unit unit3 = Unit.INSTANCE;
                            Unit unit4 = Unit.INSTANCE;
                        }
                        composer2.endReplaceGroup();
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
            }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i13 >> 12) & 112) | 12582912 | (57344 & i1112) | (i1112 & 458752), 72);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            function9 = function1111;
            j4 = j3;
            richTooltipContainerShape = richTooltipContainerShape;
            f4 = f116;
            richTooltipColors4 = richTooltipColors3;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier9 = companion;
            final Function2<? super Composer, ? super Integer, Unit> function1112 = function8;
            final Shape shape9 = richTooltipContainerShape;
            final float f117 = fM3835getContainerElevationD9Ej5fM;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i1113) {
                    Tooltip_androidKt.m3184RichTooltipyDvdmqw(tooltipScope, modifier9, function9, function1112, j4, shape9, richTooltipColors4, f4, f117, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final DrawResult m3186drawCaretWithPathJKumZY(CacheDrawScope cacheDrawScope, CaretType caretType, Density density, Configuration configuration, final long j, long j2, final LayoutCoordinates layoutCoordinates) {
        long jOffset;
        final Path Path = AndroidPath_androidKt.Path();
        if (layoutCoordinates != null) {
            int i = density.roundToPx-0680j_4(DpSize.getHeight-D9Ej5fM(j2));
            int i2 = density.roundToPx-0680j_4(DpSize.getWidth-D9Ej5fM(j2));
            int i3 = density.roundToPx-0680j_4(Dp.constructor-impl(configuration.screenWidthDp));
            int i4 = density.roundToPx-0680j_4(TooltipKt.getSpacingBetweenTooltipAndAnchor());
            Rect rectBoundsInWindow = LayoutCoordinatesKt.boundsInWindow(layoutCoordinates);
            float left = rectBoundsInWindow.getLeft();
            float right = rectBoundsInWindow.getRight();
            float top = rectBoundsInWindow.getTop();
            float f = 2;
            float f2 = (right + left) / f;
            float f3 = right - left;
            float fM4415getWidthimpl = Size.m4415getWidthimpl(cacheDrawScope.m4217getSizeNHjbRc());
            float fM4412getHeightimpl = Size.m4412getHeightimpl(cacheDrawScope.m4217getSizeNHjbRc());
            boolean z = (top - fM4412getHeightimpl) - ((float) i4) < 0.0f;
            if (z) {
                fM4412getHeightimpl = 0.0f;
            }
            if (caretType == CaretType.Plain) {
                float f4 = i3;
                if ((fM4415getWidthimpl / f) + f2 > f4) {
                    jOffset = OffsetKt.Offset(fM4415getWidthimpl - (f4 - f2), fM4412getHeightimpl);
                } else {
                    jOffset = OffsetKt.Offset(f2 - Math.max(left - ((Size.m4415getWidthimpl(cacheDrawScope.m4217getSizeNHjbRc()) / f) - (f3 / f)), 0.0f), fM4412getHeightimpl);
                }
            } else {
                long jOffset2 = OffsetKt.Offset(f2 - left, fM4412getHeightimpl);
                float f5 = i3;
                if (left + fM4415getWidthimpl > f5) {
                    float f6 = right - fM4415getWidthimpl;
                    jOffset2 = OffsetKt.Offset(f2 - f6, fM4412getHeightimpl);
                    if (f6 < 0.0f) {
                        float f7 = fM4415getWidthimpl / f;
                        float f8 = f3 / f;
                        if ((left - f7) + f8 <= 0.0f) {
                            jOffset = OffsetKt.Offset(f2, fM4412getHeightimpl);
                        } else if ((right + f7) - f8 >= f5) {
                            jOffset = OffsetKt.Offset(fM4415getWidthimpl - (f5 - f2), fM4412getHeightimpl);
                        } else {
                            jOffset = OffsetKt.Offset(f7, fM4412getHeightimpl);
                        }
                    } else {
                        jOffset = jOffset2;
                    }
                } else {
                    jOffset = jOffset2;
                }
            }
            if (z) {
                Path.moveTo(Offset.m4346getXimpl(jOffset), Offset.m4347getYimpl(jOffset));
                float f9 = i2 / 2;
                Path.lineTo(Offset.m4346getXimpl(jOffset) + f9, Offset.m4347getYimpl(jOffset));
                Path.lineTo(Offset.m4346getXimpl(jOffset), Offset.m4347getYimpl(jOffset) - i);
                Path.lineTo(Offset.m4346getXimpl(jOffset) - f9, Offset.m4347getYimpl(jOffset));
                Path.close();
            } else {
                Path.moveTo(Offset.m4346getXimpl(jOffset), Offset.m4347getYimpl(jOffset));
                float f10 = i2 / 2;
                Path.lineTo(Offset.m4346getXimpl(jOffset) + f10, Offset.m4347getYimpl(jOffset));
                Path.lineTo(Offset.m4346getXimpl(jOffset), Offset.m4347getYimpl(jOffset) + i);
                Path.lineTo(Offset.m4346getXimpl(jOffset) - f10, Offset.m4347getYimpl(jOffset));
                Path.close();
            }
        }
        return cacheDrawScope.onDrawWithContent(new Function1<ContentDrawScope, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((ContentDrawScope) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(ContentDrawScope contentDrawScope) {
                if (layoutCoordinates != null) {
                    contentDrawScope.drawContent();
                    DrawScope.CC.m5176drawPathLG529CI$default(contentDrawScope, Path, j, 0.0f, null, null, 0, 60, null);
                }
            }
        });
    }
}
