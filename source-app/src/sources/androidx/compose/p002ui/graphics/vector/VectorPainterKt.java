package androidx.compose.p002ui.graphics.vector;

import androidx.autofill.HintConstants;
import androidx.compose.p002ui.geometry.Size;
import androidx.compose.p002ui.geometry.SizeKt;
import androidx.compose.p002ui.graphics.BlendMode;
import androidx.compose.p002ui.graphics.Brush;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.ColorFilter;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.drawscope.DrawContext;
import androidx.compose.p002ui.graphics.drawscope.DrawScope;
import androidx.compose.p002ui.platform.CompositionLocalsKt;
import androidx.compose.runtime.ComposablesKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.Composition;
import androidx.compose.runtime.CompositionContext;
import androidx.compose.runtime.CompositionKt;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.ui.unit.Density;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import kotlin.Deprecated;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.Unit;
import kotlin.collections.MapsKt;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function4;

@Metadata(d1 = {"\u0000\u0092\u0001\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010$\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\n\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\u001a+\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0014\b\u0002\u0010\u0006\u001a\u000e\u0012\u0004\u0012\u00020\u0001\u0012\u0004\u0012\u00020\b0\u0007H\u0007¢\u0006\u0002\u0010\t\u001a$\u0010\n\u001a\u0004\u0018\u00010\u000b2\u0006\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\u000fH\u0002ø\u0001\u0000¢\u0006\u0004\b\u0010\u0010\u0011\u001a \u0010\u0012\u001a\u00020\u00132\u0006\u0010\u0014\u001a\u00020\u00152\u0006\u0010\u0016\u001a\u00020\u00172\u0006\u0010\u0018\u001a\u00020\u0019H\u0000\u001a*\u0010\u001a\u001a\u00020\u001b2\u0006\u0010\u001c\u001a\u00020\u001b2\u0006\u0010\u001d\u001a\u00020\u001e2\u0006\u0010\u001f\u001a\u00020\u001eH\u0002ø\u0001\u0000¢\u0006\u0004\b \u0010!\u001a\u0015\u0010\"\u001a\u00020\u00132\u0006\u0010#\u001a\u00020\u0017H\u0007¢\u0006\u0002\u0010$\u001a\u0096\u0001\u0010\"\u001a\u00020\u00132\u0006\u0010%\u001a\u00020&2\u0006\u0010'\u001a\u00020&2\b\b\u0002\u0010\u001d\u001a\u00020\u001e2\b\b\u0002\u0010\u001f\u001a\u00020\u001e2\b\b\u0002\u0010(\u001a\u00020\u00012\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2@\u0010)\u001a<\u0012\u0013\u0012\u00110\u001e¢\u0006\f\b+\u0012\b\b(\u0012\u0004\b\b(\u001d\u0012\u0013\u0012\u00110\u001e¢\u0006\f\b+\u0012\b\b(\u0012\u0004\b\b(\u001f\u0012\u0004\u0012\u00020\u00030*¢\u0006\u0002\b,¢\u0006\u0002\b-H\u0007ø\u0001\u0000¢\u0006\u0004\b.\u0010/\u001a \u0001\u0010\"\u001a\u00020\u00132\u0006\u0010%\u001a\u00020&2\u0006\u0010'\u001a\u00020&2\b\b\u0002\u0010\u001d\u001a\u00020\u001e2\b\b\u0002\u0010\u001f\u001a\u00020\u001e2\b\b\u0002\u0010(\u001a\u00020\u00012\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u00100\u001a\u0002012@\u0010)\u001a<\u0012\u0013\u0012\u00110\u001e¢\u0006\f\b+\u0012\b\b(\u0012\u0004\b\b(\u001d\u0012\u0013\u0012\u00110\u001e¢\u0006\f\b+\u0012\b\b(\u0012\u0004\b\b(\u001f\u0012\u0004\u0012\u00020\u00030*¢\u0006\u0002\b,¢\u0006\u0002\b-H\u0007ø\u0001\u0000¢\u0006\u0004\b2\u00103\u001aD\u00104\u001a\u00020\u0013*\u00020\u00132\u0006\u0010\u001c\u001a\u00020\u001b2\u0006\u00105\u001a\u00020\u001b2\b\b\u0002\u0010(\u001a\u00020\u00012\b\u00106\u001a\u0004\u0018\u00010\u000b2\b\b\u0002\u00100\u001a\u000201H\u0000ø\u0001\u0000¢\u0006\u0004\b7\u00108\u001a\u0014\u00109\u001a\u00020\u0019*\u00020\u00192\u0006\u0010:\u001a\u00020\u0005H\u0000\u001a&\u0010;\u001a\u00020\u0003*\u00020<2\u0017\u0010=\u001a\u0013\u0012\u0004\u0012\u00020<\u0012\u0004\u0012\u00020\u00030>¢\u0006\u0002\b?H\u0082\b\u001a&\u0010@\u001a\u00020\u001b*\u00020\u00152\u0006\u0010%\u001a\u00020&2\u0006\u0010'\u001a\u00020&H\u0002ø\u0001\u0000¢\u0006\u0004\bA\u0010B\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0086T¢\u0006\u0002\n\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006C"}, d2 = {"RootGroupName", "", "RenderVectorGroup", "", "group", "Landroidx/compose/ui/graphics/vector/VectorGroup;", "configs", "", "Landroidx/compose/ui/graphics/vector/VectorConfig;", "(Landroidx/compose/ui/graphics/vector/VectorGroup;Ljava/util/Map;Landroidx/compose/runtime/Composer;II)V", "createColorFilter", "Landroidx/compose/ui/graphics/ColorFilter;", "tintColor", "Landroidx/compose/ui/graphics/Color;", "tintBlendMode", "Landroidx/compose/ui/graphics/BlendMode;", "createColorFilter-xETnrds", "(JI)Landroidx/compose/ui/graphics/ColorFilter;", "createVectorPainterFromImageVector", "Landroidx/compose/ui/graphics/vector/VectorPainter;", "density", "Landroidx/compose/ui/unit/Density;", "imageVector", "Landroidx/compose/ui/graphics/vector/ImageVector;", "root", "Landroidx/compose/ui/graphics/vector/GroupComponent;", "obtainViewportSize", "Landroidx/compose/ui/geometry/Size;", "defaultSize", "viewportWidth", "", "viewportHeight", "obtainViewportSize-Pq9zytI", "(JFF)J", "rememberVectorPainter", "image", "(Landroidx/compose/ui/graphics/vector/ImageVector;Landroidx/compose/runtime/Composer;I)Landroidx/compose/ui/graphics/vector/VectorPainter;", "defaultWidth", "Landroidx/compose/ui/unit/Dp;", "defaultHeight", HintConstants.AUTOFILL_HINT_NAME, "content", "Lkotlin/Function2;", "Lkotlin/ParameterName;", "Landroidx/compose/runtime/Composable;", "Landroidx/compose/ui/graphics/vector/VectorComposable;", "rememberVectorPainter-mlNsNFs", "(FFFFLjava/lang/String;JILkotlin/jvm/functions/Function4;Landroidx/compose/runtime/Composer;II)Landroidx/compose/ui/graphics/vector/VectorPainter;", "autoMirror", "", "rememberVectorPainter-vIP8VLU", "(FFFFLjava/lang/String;JIZLkotlin/jvm/functions/Function4;Landroidx/compose/runtime/Composer;II)Landroidx/compose/ui/graphics/vector/VectorPainter;", "configureVectorPainter", "viewportSize", "intrinsicColorFilter", "configureVectorPainter-T4PVSW8", "(Landroidx/compose/ui/graphics/vector/VectorPainter;JJLjava/lang/String;Landroidx/compose/ui/graphics/ColorFilter;Z)Landroidx/compose/ui/graphics/vector/VectorPainter;", "createGroupComponent", "currentGroup", "mirror", "Landroidx/compose/ui/graphics/drawscope/DrawScope;", "block", "Lkotlin/Function1;", "Lkotlin/ExtensionFunctionType;", "obtainSizePx", "obtainSizePx-VpY3zN4", "(Landroidx/compose/ui/unit/Density;FF)J", "ui_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class VectorPainterKt {
    public static final String RootGroupName = "VectorRootGroup";

    @Deprecated(message = "Replace rememberVectorPainter graphicsLayer that consumes the auto mirror flag", replaceWith = @ReplaceWith(expression = "rememberVectorPainter(defaultWidth, defaultHeight, viewportWidth, viewportHeight, name, tintColor, tintBlendMode, false, content)", imports = {"androidx.compose.ui.graphics.vector"}))
    public static final VectorPainter m5351rememberVectorPaintermlNsNFs(float f, float f2, float f3, float f4, String str, long j, int i, Function4<? super Float, ? super Float, ? super Composer, ? super Integer, Unit> function4, Composer composer, int i2, int i3) {
        ComposerKt.sourceInformationMarkerStart(composer, -964365210, "C(rememberVectorPainter)P(2:c#ui.unit.Dp,1:c#ui.unit.Dp,7,6,3,5:c#ui.graphics.Color,4:c#ui.graphics.BlendMode)86@3732L207:VectorPainter.kt#huu6hf");
        float f5 = (i3 & 4) != 0 ? Float.NaN : f3;
        float f6 = (i3 & 8) != 0 ? Float.NaN : f4;
        String str2 = (i3 & 16) != 0 ? RootGroupName : str;
        long jM4626getUnspecified0d7_KjU = (i3 & 32) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j;
        int iM4530getSrcIn0nO6VwU = (i3 & 64) != 0 ? BlendMode.INSTANCE.m4530getSrcIn0nO6VwU() : i;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-964365210, i2, -1, "androidx.compose.ui.graphics.vector.rememberVectorPainter (VectorPainter.kt:86)");
        }
        VectorPainter vectorPainterM5352rememberVectorPaintervIP8VLU = m5352rememberVectorPaintervIP8VLU(f, f2, f5, f6, str2, jM4626getUnspecified0d7_KjU, iM4530getSrcIn0nO6VwU, false, function4, composer, (i2 & 14) | 12582912 | (i2 & 112) | (i2 & 896) | (i2 & 7168) | (57344 & i2) | (458752 & i2) | (3670016 & i2) | ((i2 << 3) & 234881024), 0);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return vectorPainterM5352rememberVectorPaintervIP8VLU;
    }

    public static final VectorPainter m5352rememberVectorPaintervIP8VLU(float f, float f2, float f3, float f4, String str, long j, int i, boolean z, Function4<? super Float, ? super Float, ? super Composer, ? super Integer, Unit> function4, Composer composer, int i2, int i3) {
        final Function4<? super Float, ? super Float, ? super Composer, ? super Integer, Unit> function5;
        boolean z2;
        boolean z3;
        Object objRememberedValue;
        Composition composition;
        Composition Composition;
        Object obj;
        ComposerKt.sourceInformationMarkerStart(composer, 1068590786, "C(rememberVectorPainter)P(3:c#ui.unit.Dp,2:c#ui.unit.Dp,8,7,4,6:c#ui.graphics.Color,5:c#ui.graphics.BlendMode)131@5630L7,134@5823L94:VectorPainter.kt#huu6hf");
        float f5 = (i3 & 4) != 0 ? Float.NaN : f3;
        float f6 = (i3 & 8) == 0 ? f4 : Float.NaN;
        String str2 = (i3 & 16) != 0 ? RootGroupName : str;
        long jM4626getUnspecified0d7_KjU = (i3 & 32) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j;
        int iM4530getSrcIn0nO6VwU = (i3 & 64) != 0 ? BlendMode.INSTANCE.m4530getSrcIn0nO6VwU() : i;
        boolean z4 = (i3 & Fields.SpotShadowColor) != 0 ? false : z;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1068590786, i2, -1, "androidx.compose.ui.graphics.vector.rememberVectorPainter (VectorPainter.kt:130)");
        }
        ProvidableCompositionLocal<Density> localDensity = CompositionLocalsKt.getLocalDensity();
        ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
        Object objConsume = composer.consume(localDensity);
        ComposerKt.sourceInformationMarkerEnd(composer);
        long jM5349obtainSizePxVpY3zN4 = m5349obtainSizePxVpY3zN4((Density) objConsume, f, f2);
        final long jM5350obtainViewportSizePq9zytI = m5350obtainViewportSizePq9zytI(jM5349obtainSizePxVpY3zN4, f5, f6);
        ComposerKt.sourceInformationMarkerStart(composer, -1837515400, "CC(remember):VectorPainter.kt#9igjgp");
        float f7 = f6;
        boolean z5 = ((((458752 & i2) ^ 196608) > 131072 && composer.changed(jM4626getUnspecified0d7_KjU)) || (i2 & 196608) == 131072) | ((((3670016 & i2) ^ 1572864) > 1048576 && composer.changed(iM4530getSrcIn0nO6VwU)) || (i2 & 1572864) == 1048576);
        Object objRememberedValue2 = composer.rememberedValue();
        if (z5 || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
            objRememberedValue2 = m5348createColorFilterxETnrds(jM4626getUnspecified0d7_KjU, iM4530getSrcIn0nO6VwU);
            composer.updateRememberedValue(objRememberedValue2);
        }
        ColorFilter colorFilter = (ColorFilter) objRememberedValue2;
        ComposerKt.sourceInformationMarkerEnd(composer);
        composer.startReplaceGroup(-1837510348);
        ComposerKt.sourceInformation(composer, "*137@5929L28,145@6235L28,146@6291L487");
        ComposerKt.sourceInformationMarkerStart(composer, -1837512074, "CC(remember):VectorPainter.kt#9igjgp");
        Object objRememberedValue3 = composer.rememberedValue();
        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
            objRememberedValue3 = new VectorPainter(null, 1, null);
            composer.updateRememberedValue(objRememberedValue3);
        }
        VectorPainter vectorPainter = (VectorPainter) objRememberedValue3;
        ComposerKt.sourceInformationMarkerEnd(composer);
        m5346configureVectorPainterT4PVSW8(vectorPainter, jM5349obtainSizePxVpY3zN4, jM5350obtainViewportSizePq9zytI, str2, colorFilter, z4);
        CompositionContext compositionContextRememberCompositionContext = ComposablesKt.rememberCompositionContext(composer, 0);
        ComposerKt.sourceInformationMarkerStart(composer, 904082560, "CC(remember):VectorPainter.kt#9igjgp");
        boolean z6 = ((((i2 & 896) ^ 384) > 256 && composer.changed(f5)) || (i2 & 384) == 256) | ((((i2 & 7168) ^ 3072) > 2048 && composer.changed(f7)) || (i2 & 3072) == 2048);
        if (((234881024 & i2) ^ 100663296) > 67108864) {
            function5 = function4;
            if (composer.changed(function5)) {
                z2 = true;
            }
            z3 = z6 | z2;
            objRememberedValue = composer.rememberedValue();
            if (z3 || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                obj = objRememberedValue;
                composition = vectorPainter.getComposition();
                if (composition != null || composition.getDisposed()) {
                    Composition = CompositionKt.Composition(new VectorApplier(vectorPainter.getVector().getRoot()), compositionContextRememberCompositionContext);
                } else {
                    Composition = composition;
                }
                Composition.setContent(ComposableLambdaKt.composableLambdaInstance(-824421385, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i4) {
                        ComposerKt.sourceInformation(composer2, "C157@6697L40:VectorPainter.kt#huu6hf");
                        if ((i4 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-824421385, i4, -1, "androidx.compose.ui.graphics.vector.rememberVectorPainter.<anonymous>.<anonymous>.<anonymous> (VectorPainter.kt:157)");
                        }
                        function5.invoke(Float.valueOf(Size.m4415getWidthimpl(jM5350obtainViewportSizePq9zytI)), Float.valueOf(Size.m4412getHeightimpl(jM5350obtainViewportSizePq9zytI)), composer2, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }));
                composer.updateRememberedValue(Composition);
                obj = Composition;
            }
            obj = objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composer);
            vectorPainter.setComposition$ui_release((Composition) obj);
            composer.endReplaceGroup();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            ComposerKt.sourceInformationMarkerEnd(composer);
            return vectorPainter;
        }
        function5 = function4;
        if ((i2 & 100663296) == 67108864) {
            z2 = true;
        } else {
            z2 = false;
        }
        z3 = z6 | z2;
        objRememberedValue = composer.rememberedValue();
        if (z3) {
            obj = objRememberedValue;
            composition = vectorPainter.getComposition();
            if (composition != null) {
                Composition = CompositionKt.Composition(new VectorApplier(vectorPainter.getVector().getRoot()), compositionContextRememberCompositionContext);
            } else {
                Composition = CompositionKt.Composition(new VectorApplier(vectorPainter.getVector().getRoot()), compositionContextRememberCompositionContext);
            }
            Composition.setContent(ComposableLambdaKt.composableLambdaInstance(-824421385, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj2, Object obj3) {
                    invoke((Composer) obj2, ((Number) obj3).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i4) {
                    ComposerKt.sourceInformation(composer2, "C157@6697L40:VectorPainter.kt#huu6hf");
                    if ((i4 & 3) == 2 && composer2.getSkipping()) {
                        composer2.skipToGroupEnd();
                        return;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-824421385, i4, -1, "androidx.compose.ui.graphics.vector.rememberVectorPainter.<anonymous>.<anonymous>.<anonymous> (VectorPainter.kt:157)");
                    }
                    function5.invoke(Float.valueOf(Size.m4415getWidthimpl(jM5350obtainViewportSizePq9zytI)), Float.valueOf(Size.m4412getHeightimpl(jM5350obtainViewportSizePq9zytI)), composer2, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
            }));
            composer.updateRememberedValue(Composition);
            obj = Composition;
        } else {
            obj = objRememberedValue;
            composition = vectorPainter.getComposition();
            if (composition != null) {
                Composition = CompositionKt.Composition(new VectorApplier(vectorPainter.getVector().getRoot()), compositionContextRememberCompositionContext);
            } else {
                Composition = CompositionKt.Composition(new VectorApplier(vectorPainter.getVector().getRoot()), compositionContextRememberCompositionContext);
            }
            Composition.setContent(ComposableLambdaKt.composableLambdaInstance(-824421385, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj2, Object obj3) {
                    invoke((Composer) obj2, ((Number) obj3).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i4) {
                    ComposerKt.sourceInformation(composer2, "C157@6697L40:VectorPainter.kt#huu6hf");
                    if ((i4 & 3) == 2 && composer2.getSkipping()) {
                        composer2.skipToGroupEnd();
                        return;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-824421385, i4, -1, "androidx.compose.ui.graphics.vector.rememberVectorPainter.<anonymous>.<anonymous>.<anonymous> (VectorPainter.kt:157)");
                    }
                    function5.invoke(Float.valueOf(Size.m4415getWidthimpl(jM5350obtainViewportSizePq9zytI)), Float.valueOf(Size.m4412getHeightimpl(jM5350obtainViewportSizePq9zytI)), composer2, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
            }));
            composer.updateRememberedValue(Composition);
            obj = Composition;
        }
        obj = objRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        vectorPainter.setComposition$ui_release((Composition) obj);
        composer.endReplaceGroup();
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return vectorPainter;
    }

    public static final VectorPainter rememberVectorPainter(ImageVector imageVector, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 1413834416, "C(rememberVectorPainter)172@7145L7,174@7229L215:VectorPainter.kt#huu6hf");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1413834416, i, -1, "androidx.compose.ui.graphics.vector.rememberVectorPainter (VectorPainter.kt:171)");
        }
        ProvidableCompositionLocal<Density> localDensity = CompositionLocalsKt.getLocalDensity();
        ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
        Object objConsume = composer.consume(localDensity);
        ComposerKt.sourceInformationMarkerEnd(composer);
        Density density = (Density) objConsume;
        float genId = imageVector.getGenId();
        float density2 = density.getDensity();
        long jFloatToRawIntBits = Float.floatToRawIntBits(genId);
        long jFloatToRawIntBits2 = ((long) Float.floatToRawIntBits(density2)) & 4294967295L;
        ComposerKt.sourceInformationMarkerStart(composer, -1837470287, "CC(remember):VectorPainter.kt#9igjgp");
        boolean zChanged = composer.changed(jFloatToRawIntBits2 | (jFloatToRawIntBits << 32));
        Object objRememberedValue = composer.rememberedValue();
        if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
            GroupComponent groupComponent = new GroupComponent();
            createGroupComponent(groupComponent, imageVector.getRoot());
            Unit unit = Unit.INSTANCE;
            objRememberedValue = createVectorPainterFromImageVector(density, imageVector, groupComponent);
            composer.updateRememberedValue(objRememberedValue);
        }
        VectorPainter vectorPainter = (VectorPainter) objRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return vectorPainter;
    }

    private static final long m5349obtainSizePxVpY3zN4(Density density, float f, float f2) {
        return SizeKt.Size(density.toPx-0680j_4(f), density.toPx-0680j_4(f2));
    }

    private static final long m5350obtainViewportSizePq9zytI(long j, float f, float f2) {
        if (Float.isNaN(f)) {
            f = Size.m4415getWidthimpl(j);
        }
        if (Float.isNaN(f2)) {
            f2 = Size.m4412getHeightimpl(j);
        }
        return SizeKt.Size(f, f2);
    }

    private static final ColorFilter m5348createColorFilterxETnrds(long j, int i) {
        if (j != 16) {
            return ColorFilter.INSTANCE.m4634tintxETnrds(j, i);
        }
        return null;
    }

    public static final VectorPainter m5346configureVectorPainterT4PVSW8(VectorPainter vectorPainter, long j, long j2, String str, ColorFilter colorFilter, boolean z) {
        vectorPainter.m5343setSizeuvyYCjk$ui_release(j);
        vectorPainter.setAutoMirror$ui_release(z);
        vectorPainter.setIntrinsicColorFilter$ui_release(colorFilter);
        vectorPainter.m5344setViewportSizeuvyYCjk$ui_release(j2);
        vectorPainter.setName$ui_release(str);
        return vectorPainter;
    }

    public static final VectorPainter createVectorPainterFromImageVector(Density density, ImageVector imageVector, GroupComponent groupComponent) {
        long jM5349obtainSizePxVpY3zN4 = m5349obtainSizePxVpY3zN4(density, imageVector.getDefaultWidth(), imageVector.getDefaultHeight());
        return m5346configureVectorPainterT4PVSW8(new VectorPainter(groupComponent), jM5349obtainSizePxVpY3zN4, m5350obtainViewportSizePq9zytI(jM5349obtainSizePxVpY3zN4, imageVector.getViewportWidth(), imageVector.getViewportHeight()), imageVector.getName(), m5348createColorFilterxETnrds(imageVector.getTintColor(), imageVector.getTintBlendMode()), imageVector.getAutoMirror());
    }

    public static final GroupComponent createGroupComponent(GroupComponent groupComponent, VectorGroup vectorGroup) {
        int size = vectorGroup.getSize();
        for (int i = 0; i < size; i++) {
            VectorNode vectorNode = vectorGroup.get(i);
            if (vectorNode instanceof VectorPath) {
                PathComponent pathComponent = new PathComponent();
                VectorPath vectorPath = (VectorPath) vectorNode;
                pathComponent.setPathData(vectorPath.getPathData());
                pathComponent.m5325setPathFillTypeoQ8Xj4U(vectorPath.getPathFillType());
                pathComponent.setName(vectorPath.getName());
                pathComponent.setFill(vectorPath.getFill());
                pathComponent.setFillAlpha(vectorPath.getFillAlpha());
                pathComponent.setStroke(vectorPath.getStroke());
                pathComponent.setStrokeAlpha(vectorPath.getStrokeAlpha());
                pathComponent.setStrokeLineWidth(vectorPath.getStrokeLineWidth());
                pathComponent.m5326setStrokeLineCapBeK7IIE(vectorPath.getStrokeLineCap());
                pathComponent.m5327setStrokeLineJoinWw9F2mQ(vectorPath.getStrokeLineJoin());
                pathComponent.setStrokeLineMiter(vectorPath.getStrokeLineMiter());
                pathComponent.setTrimPathStart(vectorPath.getTrimPathStart());
                pathComponent.setTrimPathEnd(vectorPath.getTrimPathEnd());
                pathComponent.setTrimPathOffset(vectorPath.getTrimPathOffset());
                groupComponent.insertAt(i, pathComponent);
            } else if (vectorNode instanceof VectorGroup) {
                GroupComponent groupComponent2 = new GroupComponent();
                VectorGroup vectorGroup2 = (VectorGroup) vectorNode;
                groupComponent2.setName(vectorGroup2.getName());
                groupComponent2.setRotation(vectorGroup2.getRotation());
                groupComponent2.setScaleX(vectorGroup2.getScaleX());
                groupComponent2.setScaleY(vectorGroup2.getScaleY());
                groupComponent2.setTranslationX(vectorGroup2.getTranslationX());
                groupComponent2.setTranslationY(vectorGroup2.getTranslationY());
                groupComponent2.setPivotX(vectorGroup2.getPivotX());
                groupComponent2.setPivotY(vectorGroup2.getPivotY());
                groupComponent2.setClipPathData(vectorGroup2.getClipPathData());
                createGroupComponent(groupComponent2, vectorGroup2);
                groupComponent.insertAt(i, groupComponent2);
            }
        }
        return groupComponent;
    }

    public static final void RenderVectorGroup(final VectorGroup vectorGroup, Map<String, ? extends VectorConfig> map, Composer composer, final int i, final int i2) {
        int i3;
        Map<String, ? extends VectorConfig> map2;
        Map<String, ? extends VectorConfig> mapEmptyMap;
        Iterator<VectorNode> it;
        final Map<String, ? extends VectorConfig> map3;
        Composer composer2;
        final VectorNode next;
        Map<String, ? extends VectorConfig> map4;
        Composer composer3;
        final Map<String, ? extends VectorConfig> map5;
        VectorConfig vectorConfig;
        VectorConfig vectorConfig2;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(-446179233);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(RenderVectorGroup)P(1):VectorPainter.kt#huu6hf");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(vectorGroup) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i4 = i2 & 2;
        if (i4 == 0) {
            if ((i & 48) == 0) {
                map2 = map;
                i3 |= composerStartRestartGroup.changedInstance(map2) ? 32 : 16;
            }
            if ((i3 & 19) == 18 || !composerStartRestartGroup.getSkipping()) {
                if (i4 != 0) {
                    mapEmptyMap = MapsKt.emptyMap();
                } else {
                    mapEmptyMap = map2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-446179233, i3, -1, "androidx.compose.ui.graphics.vector.RenderVectorGroup (VectorPainter.kt:430)");
                }
                it = vectorGroup.iterator();
                while (it.hasNext()) {
                    next = it.next();
                    if (next instanceof VectorPath) {
                        composerStartRestartGroup.startReplaceGroup(-23647808);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "434@16086L1719");
                        VectorPath vectorPath = (VectorPath) next;
                        vectorConfig2 = mapEmptyMap.get(vectorPath.getName());
                        if (vectorConfig2 == null) {
                            vectorConfig2 = new VectorConfig() {
                                @Override
                                public Object getOrDefault(VectorProperty vectorProperty, Object obj) {
                                    return VectorConfig.CC.$default$getOrDefault(this, vectorProperty, obj);
                                }
                            };
                        }
                        VectorConfig vectorConfig3 = vectorConfig2;
                        Composer composer4 = composerStartRestartGroup;
                        VectorComposeKt.m5333Path9cdaXJ4((List) vectorConfig3.getOrDefault(VectorProperty.PathData.INSTANCE, vectorPath.getPathData()), vectorPath.getPathFillType(), vectorPath.getName(), (Brush) vectorConfig3.getOrDefault(VectorProperty.Fill.INSTANCE, vectorPath.getFill()), ((Number) vectorConfig3.getOrDefault(VectorProperty.FillAlpha.INSTANCE, Float.valueOf(vectorPath.getFillAlpha()))).floatValue(), (Brush) vectorConfig3.getOrDefault(VectorProperty.Stroke.INSTANCE, vectorPath.getStroke()), ((Number) vectorConfig3.getOrDefault(VectorProperty.StrokeAlpha.INSTANCE, Float.valueOf(vectorPath.getStrokeAlpha()))).floatValue(), ((Number) vectorConfig3.getOrDefault(VectorProperty.StrokeLineWidth.INSTANCE, Float.valueOf(vectorPath.getStrokeLineWidth()))).floatValue(), vectorPath.getStrokeLineCap(), vectorPath.getStrokeLineJoin(), vectorPath.getStrokeLineMiter(), ((Number) vectorConfig3.getOrDefault(VectorProperty.TrimPathStart.INSTANCE, Float.valueOf(vectorPath.getTrimPathStart()))).floatValue(), ((Number) vectorConfig3.getOrDefault(VectorProperty.TrimPathEnd.INSTANCE, Float.valueOf(vectorPath.getTrimPathEnd()))).floatValue(), ((Number) vectorConfig3.getOrDefault(VectorProperty.TrimPathOffset.INSTANCE, Float.valueOf(vectorPath.getTrimPathOffset()))).floatValue(), composer4, 0, 0, 0);
                        composer4.endReplaceGroup();
                        it = it;
                        mapEmptyMap = mapEmptyMap;
                        composerStartRestartGroup = composer4;
                    } else {
                        Iterator<VectorNode> it2 = it;
                        map4 = mapEmptyMap;
                        composer3 = composerStartRestartGroup;
                        if (next instanceof VectorGroup) {
                            composer3.startReplaceGroup(-21815553);
                            ComposerKt.sourceInformation(composer3, "513@19224L88,479@17944L1368");
                            VectorGroup vectorGroup2 = (VectorGroup) next;
                            map5 = map4;
                            vectorConfig = map5.get(vectorGroup2.getName());
                            if (vectorConfig == null) {
                                vectorConfig = new VectorConfig() {
                                    @Override
                                    public Object getOrDefault(VectorProperty vectorProperty, Object obj) {
                                        return VectorConfig.CC.$default$getOrDefault(this, vectorProperty, obj);
                                    }
                                };
                            }
                            VectorComposeKt.Group(vectorGroup2.getName(), ((Number) vectorConfig.getOrDefault(VectorProperty.Rotation.INSTANCE, Float.valueOf(vectorGroup2.getRotation()))).floatValue(), ((Number) vectorConfig.getOrDefault(VectorProperty.PivotX.INSTANCE, Float.valueOf(vectorGroup2.getPivotX()))).floatValue(), ((Number) vectorConfig.getOrDefault(VectorProperty.PivotY.INSTANCE, Float.valueOf(vectorGroup2.getPivotY()))).floatValue(), ((Number) vectorConfig.getOrDefault(VectorProperty.ScaleX.INSTANCE, Float.valueOf(vectorGroup2.getScaleX()))).floatValue(), ((Number) vectorConfig.getOrDefault(VectorProperty.ScaleY.INSTANCE, Float.valueOf(vectorGroup2.getScaleY()))).floatValue(), ((Number) vectorConfig.getOrDefault(VectorProperty.TranslateX.INSTANCE, Float.valueOf(vectorGroup2.getTranslationX()))).floatValue(), ((Number) vectorConfig.getOrDefault(VectorProperty.TranslateY.INSTANCE, Float.valueOf(vectorGroup2.getTranslationY()))).floatValue(), (List) vectorConfig.getOrDefault(VectorProperty.PathData.INSTANCE, vectorGroup2.getClipPathData()), ComposableLambdaKt.rememberComposableLambda(1450046638, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer5, int i5) {
                                    ComposerKt.sourceInformation(composer5, "C514@19242L56:VectorPainter.kt#huu6hf");
                                    if ((i5 & 3) == 2 && composer5.getSkipping()) {
                                        composer5.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1450046638, i5, -1, "androidx.compose.ui.graphics.vector.RenderVectorGroup.<anonymous> (VectorPainter.kt:514)");
                                    }
                                    VectorPainterKt.RenderVectorGroup((VectorGroup) next, map5, composer5, 0, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composer3, 54), composer3, 805306368, 0);
                            composer3.endReplaceGroup();
                        } else {
                            map5 = map4;
                            composer3.startReplaceGroup(-20402883);
                            composer3.endReplaceGroup();
                        }
                        composerStartRestartGroup = composer3;
                        mapEmptyMap = map5;
                        it = it2;
                    }
                }
                map3 = mapEmptyMap;
                composer2 = composerStartRestartGroup;
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            } else {
                composerStartRestartGroup.skipToGroupEnd();
                map3 = map2;
                composer2 = composerStartRestartGroup;
            }
            scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer5, int i5) {
                        VectorPainterKt.RenderVectorGroup(vectorGroup, map3, composer5, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        map2 = map;
        if ((i3 & 19) == 18) {
            if (i4 != 0) {
                mapEmptyMap = MapsKt.emptyMap();
            } else {
                mapEmptyMap = map2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-446179233, i3, -1, "androidx.compose.ui.graphics.vector.RenderVectorGroup (VectorPainter.kt:430)");
            }
            it = vectorGroup.iterator();
            while (it.hasNext()) {
                next = it.next();
                if (next instanceof VectorPath) {
                    composerStartRestartGroup.startReplaceGroup(-23647808);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "434@16086L1719");
                    VectorPath vectorPath2 = (VectorPath) next;
                    vectorConfig2 = mapEmptyMap.get(vectorPath2.getName());
                    if (vectorConfig2 == null) {
                        vectorConfig2 = new VectorConfig() {
                            @Override
                            public Object getOrDefault(VectorProperty vectorProperty, Object obj) {
                                return VectorConfig.CC.$default$getOrDefault(this, vectorProperty, obj);
                            }
                        };
                    }
                    VectorConfig vectorConfig4 = vectorConfig2;
                    Composer composer5 = composerStartRestartGroup;
                    VectorComposeKt.m5333Path9cdaXJ4((List) vectorConfig4.getOrDefault(VectorProperty.PathData.INSTANCE, vectorPath2.getPathData()), vectorPath2.getPathFillType(), vectorPath2.getName(), (Brush) vectorConfig4.getOrDefault(VectorProperty.Fill.INSTANCE, vectorPath2.getFill()), ((Number) vectorConfig4.getOrDefault(VectorProperty.FillAlpha.INSTANCE, Float.valueOf(vectorPath2.getFillAlpha()))).floatValue(), (Brush) vectorConfig4.getOrDefault(VectorProperty.Stroke.INSTANCE, vectorPath2.getStroke()), ((Number) vectorConfig4.getOrDefault(VectorProperty.StrokeAlpha.INSTANCE, Float.valueOf(vectorPath2.getStrokeAlpha()))).floatValue(), ((Number) vectorConfig4.getOrDefault(VectorProperty.StrokeLineWidth.INSTANCE, Float.valueOf(vectorPath2.getStrokeLineWidth()))).floatValue(), vectorPath2.getStrokeLineCap(), vectorPath2.getStrokeLineJoin(), vectorPath2.getStrokeLineMiter(), ((Number) vectorConfig4.getOrDefault(VectorProperty.TrimPathStart.INSTANCE, Float.valueOf(vectorPath2.getTrimPathStart()))).floatValue(), ((Number) vectorConfig4.getOrDefault(VectorProperty.TrimPathEnd.INSTANCE, Float.valueOf(vectorPath2.getTrimPathEnd()))).floatValue(), ((Number) vectorConfig4.getOrDefault(VectorProperty.TrimPathOffset.INSTANCE, Float.valueOf(vectorPath2.getTrimPathOffset()))).floatValue(), composer5, 0, 0, 0);
                    composer5.endReplaceGroup();
                    it = it;
                    mapEmptyMap = mapEmptyMap;
                    composerStartRestartGroup = composer5;
                } else {
                    Iterator<VectorNode> it3 = it;
                    map4 = mapEmptyMap;
                    composer3 = composerStartRestartGroup;
                    if (next instanceof VectorGroup) {
                        composer3.startReplaceGroup(-21815553);
                        ComposerKt.sourceInformation(composer3, "513@19224L88,479@17944L1368");
                        VectorGroup vectorGroup3 = (VectorGroup) next;
                        map5 = map4;
                        vectorConfig = map5.get(vectorGroup3.getName());
                        if (vectorConfig == null) {
                            vectorConfig = new VectorConfig() {
                                @Override
                                public Object getOrDefault(VectorProperty vectorProperty, Object obj) {
                                    return VectorConfig.CC.$default$getOrDefault(this, vectorProperty, obj);
                                }
                            };
                        }
                        VectorComposeKt.Group(vectorGroup3.getName(), ((Number) vectorConfig.getOrDefault(VectorProperty.Rotation.INSTANCE, Float.valueOf(vectorGroup3.getRotation()))).floatValue(), ((Number) vectorConfig.getOrDefault(VectorProperty.PivotX.INSTANCE, Float.valueOf(vectorGroup3.getPivotX()))).floatValue(), ((Number) vectorConfig.getOrDefault(VectorProperty.PivotY.INSTANCE, Float.valueOf(vectorGroup3.getPivotY()))).floatValue(), ((Number) vectorConfig.getOrDefault(VectorProperty.ScaleX.INSTANCE, Float.valueOf(vectorGroup3.getScaleX()))).floatValue(), ((Number) vectorConfig.getOrDefault(VectorProperty.ScaleY.INSTANCE, Float.valueOf(vectorGroup3.getScaleY()))).floatValue(), ((Number) vectorConfig.getOrDefault(VectorProperty.TranslateX.INSTANCE, Float.valueOf(vectorGroup3.getTranslationX()))).floatValue(), ((Number) vectorConfig.getOrDefault(VectorProperty.TranslateY.INSTANCE, Float.valueOf(vectorGroup3.getTranslationY()))).floatValue(), (List) vectorConfig.getOrDefault(VectorProperty.PathData.INSTANCE, vectorGroup3.getClipPathData()), ComposableLambdaKt.rememberComposableLambda(1450046638, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer6, int i5) {
                                ComposerKt.sourceInformation(composer6, "C514@19242L56:VectorPainter.kt#huu6hf");
                                if ((i5 & 3) == 2 && composer6.getSkipping()) {
                                    composer6.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1450046638, i5, -1, "androidx.compose.ui.graphics.vector.RenderVectorGroup.<anonymous> (VectorPainter.kt:514)");
                                }
                                VectorPainterKt.RenderVectorGroup((VectorGroup) next, map5, composer6, 0, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composer3, 54), composer3, 805306368, 0);
                        composer3.endReplaceGroup();
                    } else {
                        map5 = map4;
                        composer3.startReplaceGroup(-20402883);
                        composer3.endReplaceGroup();
                    }
                    composerStartRestartGroup = composer3;
                    mapEmptyMap = map5;
                    it = it3;
                }
            }
            map3 = mapEmptyMap;
            composer2 = composerStartRestartGroup;
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            if (i4 != 0) {
                mapEmptyMap = MapsKt.emptyMap();
            } else {
                mapEmptyMap = map2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-446179233, i3, -1, "androidx.compose.ui.graphics.vector.RenderVectorGroup (VectorPainter.kt:430)");
            }
            it = vectorGroup.iterator();
            while (it.hasNext()) {
                next = it.next();
                if (next instanceof VectorPath) {
                    composerStartRestartGroup.startReplaceGroup(-23647808);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "434@16086L1719");
                    VectorPath vectorPath3 = (VectorPath) next;
                    vectorConfig2 = mapEmptyMap.get(vectorPath3.getName());
                    if (vectorConfig2 == null) {
                        vectorConfig2 = new VectorConfig() {
                            @Override
                            public Object getOrDefault(VectorProperty vectorProperty, Object obj) {
                                return VectorConfig.CC.$default$getOrDefault(this, vectorProperty, obj);
                            }
                        };
                    }
                    VectorConfig vectorConfig5 = vectorConfig2;
                    Composer composer6 = composerStartRestartGroup;
                    VectorComposeKt.m5333Path9cdaXJ4((List) vectorConfig5.getOrDefault(VectorProperty.PathData.INSTANCE, vectorPath3.getPathData()), vectorPath3.getPathFillType(), vectorPath3.getName(), (Brush) vectorConfig5.getOrDefault(VectorProperty.Fill.INSTANCE, vectorPath3.getFill()), ((Number) vectorConfig5.getOrDefault(VectorProperty.FillAlpha.INSTANCE, Float.valueOf(vectorPath3.getFillAlpha()))).floatValue(), (Brush) vectorConfig5.getOrDefault(VectorProperty.Stroke.INSTANCE, vectorPath3.getStroke()), ((Number) vectorConfig5.getOrDefault(VectorProperty.StrokeAlpha.INSTANCE, Float.valueOf(vectorPath3.getStrokeAlpha()))).floatValue(), ((Number) vectorConfig5.getOrDefault(VectorProperty.StrokeLineWidth.INSTANCE, Float.valueOf(vectorPath3.getStrokeLineWidth()))).floatValue(), vectorPath3.getStrokeLineCap(), vectorPath3.getStrokeLineJoin(), vectorPath3.getStrokeLineMiter(), ((Number) vectorConfig5.getOrDefault(VectorProperty.TrimPathStart.INSTANCE, Float.valueOf(vectorPath3.getTrimPathStart()))).floatValue(), ((Number) vectorConfig5.getOrDefault(VectorProperty.TrimPathEnd.INSTANCE, Float.valueOf(vectorPath3.getTrimPathEnd()))).floatValue(), ((Number) vectorConfig5.getOrDefault(VectorProperty.TrimPathOffset.INSTANCE, Float.valueOf(vectorPath3.getTrimPathOffset()))).floatValue(), composer6, 0, 0, 0);
                    composer6.endReplaceGroup();
                    it = it;
                    mapEmptyMap = mapEmptyMap;
                    composerStartRestartGroup = composer6;
                } else {
                    Iterator<VectorNode> it4 = it;
                    map4 = mapEmptyMap;
                    composer3 = composerStartRestartGroup;
                    if (next instanceof VectorGroup) {
                        composer3.startReplaceGroup(-21815553);
                        ComposerKt.sourceInformation(composer3, "513@19224L88,479@17944L1368");
                        VectorGroup vectorGroup4 = (VectorGroup) next;
                        map5 = map4;
                        vectorConfig = map5.get(vectorGroup4.getName());
                        if (vectorConfig == null) {
                            vectorConfig = new VectorConfig() {
                                @Override
                                public Object getOrDefault(VectorProperty vectorProperty, Object obj) {
                                    return VectorConfig.CC.$default$getOrDefault(this, vectorProperty, obj);
                                }
                            };
                        }
                        VectorComposeKt.Group(vectorGroup4.getName(), ((Number) vectorConfig.getOrDefault(VectorProperty.Rotation.INSTANCE, Float.valueOf(vectorGroup4.getRotation()))).floatValue(), ((Number) vectorConfig.getOrDefault(VectorProperty.PivotX.INSTANCE, Float.valueOf(vectorGroup4.getPivotX()))).floatValue(), ((Number) vectorConfig.getOrDefault(VectorProperty.PivotY.INSTANCE, Float.valueOf(vectorGroup4.getPivotY()))).floatValue(), ((Number) vectorConfig.getOrDefault(VectorProperty.ScaleX.INSTANCE, Float.valueOf(vectorGroup4.getScaleX()))).floatValue(), ((Number) vectorConfig.getOrDefault(VectorProperty.ScaleY.INSTANCE, Float.valueOf(vectorGroup4.getScaleY()))).floatValue(), ((Number) vectorConfig.getOrDefault(VectorProperty.TranslateX.INSTANCE, Float.valueOf(vectorGroup4.getTranslationX()))).floatValue(), ((Number) vectorConfig.getOrDefault(VectorProperty.TranslateY.INSTANCE, Float.valueOf(vectorGroup4.getTranslationY()))).floatValue(), (List) vectorConfig.getOrDefault(VectorProperty.PathData.INSTANCE, vectorGroup4.getClipPathData()), ComposableLambdaKt.rememberComposableLambda(1450046638, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer7, int i5) {
                                ComposerKt.sourceInformation(composer7, "C514@19242L56:VectorPainter.kt#huu6hf");
                                if ((i5 & 3) == 2 && composer7.getSkipping()) {
                                    composer7.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1450046638, i5, -1, "androidx.compose.ui.graphics.vector.RenderVectorGroup.<anonymous> (VectorPainter.kt:514)");
                                }
                                VectorPainterKt.RenderVectorGroup((VectorGroup) next, map5, composer7, 0, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composer3, 54), composer3, 805306368, 0);
                        composer3.endReplaceGroup();
                    } else {
                        map5 = map4;
                        composer3.startReplaceGroup(-20402883);
                        composer3.endReplaceGroup();
                    }
                    composerStartRestartGroup = composer3;
                    mapEmptyMap = map5;
                    it = it4;
                }
            }
            map3 = mapEmptyMap;
            composer2 = composerStartRestartGroup;
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
        scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer7, int i5) {
                    VectorPainterKt.RenderVectorGroup(vectorGroup, map3, composer7, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    private static final void mirror(DrawScope drawScope, Function1<? super DrawScope, Unit> function1) {
        long jMo5082getCenterF1C5BW0 = drawScope.mo5082getCenterF1C5BW0();
        DrawContext drawContext = drawScope.getDrawContext();
        long jMo5102getSizeNHjbRc = drawContext.mo5102getSizeNHjbRc();
        drawContext.getCanvas().save();
        try {
            drawContext.getTransform().mo5109scale0AR0LA0(-1.0f, 1.0f, jMo5082getCenterF1C5BW0);
            function1.invoke(drawScope);
        } finally {
            drawContext.getCanvas().restore();
            drawContext.mo5103setSizeuvyYCjk(jMo5102getSizeNHjbRc);
        }
    }
}
