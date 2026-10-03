package androidx.compose.material3;

import androidx.compose.foundation.layout.BoxKt;
import androidx.compose.foundation.layout.SizeKt;
import androidx.compose.material3.tokens.IconButtonTokens;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.draw.DrawModifierKt;
import androidx.compose.p002ui.draw.PainterModifierKt;
import androidx.compose.p002ui.geometry.Size;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.ColorFilter;
import androidx.compose.p002ui.graphics.ColorProducer;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.GraphicsLayerModifierKt;
import androidx.compose.p002ui.graphics.ImageBitmap;
import androidx.compose.p002ui.graphics.drawscope.DrawScope;
import androidx.compose.p002ui.graphics.painter.BitmapPainter;
import androidx.compose.p002ui.graphics.painter.Painter;
import androidx.compose.p002ui.graphics.vector.ImageVector;
import androidx.compose.p002ui.graphics.vector.VectorPainter;
import androidx.compose.p002ui.graphics.vector.VectorPainterKt;
import androidx.compose.p002ui.layout.ContentScale;
import androidx.compose.p002ui.layout.LayoutModifierKt;
import androidx.compose.p002ui.layout.Measurable;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.MeasureScope;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.p002ui.semantics.Role;
import androidx.compose.p002ui.semantics.SemanticsModifierKt;
import androidx.compose.p002ui.semantics.SemanticsPropertiesKt;
import androidx.compose.p002ui.semantics.SemanticsPropertyReceiver;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.ui.unit.Constraints;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;

@Metadata(d1 = {"\u0000D\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0002\b\u0003\u001a8\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\b\u0010\u0006\u001a\u0004\u0018\u00010\u00072\b\b\u0002\u0010\b\u001a\u00020\u00012\b\b\u0002\u0010\t\u001a\u00020\nH\u0007ø\u0001\u0000¢\u0006\u0004\b\u000b\u0010\f\u001a3\u0010\u0002\u001a\u00020\u00032\u0006\u0010\r\u001a\u00020\u000e2\b\u0010\t\u001a\u0004\u0018\u00010\u000f2\b\u0010\u0006\u001a\u0004\u0018\u00010\u00072\b\b\u0002\u0010\b\u001a\u00020\u0001H\u0007¢\u0006\u0002\u0010\u0010\u001a8\u0010\u0002\u001a\u00020\u00032\u0006\u0010\r\u001a\u00020\u000e2\b\u0010\u0006\u001a\u0004\u0018\u00010\u00072\b\b\u0002\u0010\b\u001a\u00020\u00012\b\b\u0002\u0010\t\u001a\u00020\nH\u0007ø\u0001\u0000¢\u0006\u0004\b\u000b\u0010\u0011\u001a8\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0012\u001a\u00020\u00132\b\u0010\u0006\u001a\u0004\u0018\u00010\u00072\b\b\u0002\u0010\b\u001a\u00020\u00012\b\b\u0002\u0010\t\u001a\u00020\nH\u0007ø\u0001\u0000¢\u0006\u0004\b\u000b\u0010\u0014\u001a\u0014\u0010\u0015\u001a\u00020\u0001*\u00020\u00012\u0006\u0010\r\u001a\u00020\u000eH\u0002\u001a\u0014\u0010\u0016\u001a\u00020\u0001*\u00020\u00012\u0006\u0010\r\u001a\u00020\u000eH\u0002\u001a\u0016\u0010\u0017\u001a\u00020\u0018*\u00020\u0019H\u0002ø\u0001\u0000¢\u0006\u0004\b\u001a\u0010\u001b\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u001c"}, d2 = {"DefaultIconSizeModifier", "Landroidx/compose/ui/Modifier;", "Icon", "", "bitmap", "Landroidx/compose/ui/graphics/ImageBitmap;", "contentDescription", "", "modifier", "tint", "Landroidx/compose/ui/graphics/Color;", "Icon-ww6aTOc", "(Landroidx/compose/ui/graphics/ImageBitmap;Ljava/lang/String;Landroidx/compose/ui/Modifier;JLandroidx/compose/runtime/Composer;II)V", "painter", "Landroidx/compose/ui/graphics/painter/Painter;", "Landroidx/compose/ui/graphics/ColorProducer;", "(Landroidx/compose/ui/graphics/painter/Painter;Landroidx/compose/ui/graphics/ColorProducer;Ljava/lang/String;Landroidx/compose/ui/Modifier;Landroidx/compose/runtime/Composer;II)V", "(Landroidx/compose/ui/graphics/painter/Painter;Ljava/lang/String;Landroidx/compose/ui/Modifier;JLandroidx/compose/runtime/Composer;II)V", "imageVector", "Landroidx/compose/ui/graphics/vector/ImageVector;", "(Landroidx/compose/ui/graphics/vector/ImageVector;Ljava/lang/String;Landroidx/compose/ui/Modifier;JLandroidx/compose/runtime/Composer;II)V", "defaultSizeFor", "defaultSizeForColorProducer", "isInfinite", "", "Landroidx/compose/ui/geometry/Size;", "isInfinite-uvyYCjk", "(J)Z", "material3_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class IconKt {
    private static final Modifier DefaultIconSizeModifier = SizeKt.m1080size3ABfNKs(Modifier.INSTANCE, IconButtonTokens.INSTANCE.m3654getIconSizeD9Ej5fM());

    public static final void m2433Iconww6aTOc(final ImageVector imageVector, final String str, Modifier modifier, long j, Composer composer, final int i, final int i2) {
        int i3;
        int i4;
        Modifier modifier2;
        int i5;
        long j2;
        Modifier.Companion companion;
        long jM4600unboximpl;
        final Modifier modifier3;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i6;
        Composer composerStartRestartGroup = composer.startRestartGroup(-126890956);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(Icon)P(1!,3:c#ui.graphics.Color)69@3394L7,72@3434L34,71@3410L163:Icon.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(imageVector) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        if ((i2 & 2) == 0) {
            if ((i & 48) == 0) {
                i3 |= composerStartRestartGroup.changed(str) ? 32 : 16;
            }
            i4 = i2 & 4;
            if (i4 != 0) {
                if ((i & 384) == 0) {
                    modifier2 = modifier;
                    if (composerStartRestartGroup.changed(modifier2)) {
                        i5 = Fields.RotationX;
                    } else {
                        i5 = Fields.SpotShadowColor;
                    }
                    i3 |= i5;
                }
                if ((i & 3072) == 0) {
                    if ((i2 & 8) == 0) {
                        j2 = j;
                        if (composerStartRestartGroup.changed(j2)) {
                            i6 = Fields.CameraDistance;
                        }
                        i3 |= i6;
                    } else {
                        j2 = j;
                    }
                    i6 = Fields.RotationZ;
                    i3 |= i6;
                } else {
                    j2 = j;
                }
                if ((i3 & 1171) == 1170 || !composerStartRestartGroup.getSkipping()) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i2 & 8) != 0) {
                            ProvidableCompositionLocal<Color> localContentColor = ContentColorKt.getLocalContentColor();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume = composerStartRestartGroup.consume(localContentColor);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -7169;
                            jM4600unboximpl = ((Color) objConsume).m4600unboximpl();
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-126890956, i3, -1, "androidx.compose.material3.Icon (Icon.kt:70)");
                        }
                        m2432Iconww6aTOc(VectorPainterKt.rememberVectorPainter(imageVector, composerStartRestartGroup, i3 & 14), str, companion, jM4600unboximpl, composerStartRestartGroup, VectorPainter.$stable | (i3 & 112) | (i3 & 896) | (i3 & 7168), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        j2 = jM4600unboximpl;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                        }
                        companion = modifier2;
                    }
                    jM4600unboximpl = j2;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-126890956, i3, -1, "androidx.compose.material3.Icon (Icon.kt:70)");
                    }
                    m2432Iconww6aTOc(VectorPainterKt.rememberVectorPainter(imageVector, composerStartRestartGroup, i3 & 14), str, companion, jM4600unboximpl, composerStartRestartGroup, VectorPainter.$stable | (i3 & 112) | (i3 & 896) | (i3 & 7168), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    j2 = jM4600unboximpl;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    modifier3 = modifier2;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final long j3 = j2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i7) {
                            IconKt.m2433Iconww6aTOc(imageVector, str, modifier3, j3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 384;
            modifier2 = modifier;
            if ((i & 3072) == 0) {
                if ((i2 & 8) == 0) {
                    j2 = j;
                    if (composerStartRestartGroup.changed(j2)) {
                        i6 = Fields.CameraDistance;
                    }
                    i3 |= i6;
                } else {
                    j2 = j;
                }
                i6 = Fields.RotationZ;
                i3 |= i6;
            } else {
                j2 = j;
            }
            if ((i3 & 1171) == 1170) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        ProvidableCompositionLocal<Color> localContentColor2 = ContentColorKt.getLocalContentColor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume2 = composerStartRestartGroup.consume(localContentColor2);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -7169;
                        jM4600unboximpl = ((Color) objConsume2).m4600unboximpl();
                    } else {
                        jM4600unboximpl = j2;
                    }
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        ProvidableCompositionLocal<Color> localContentColor3 = ContentColorKt.getLocalContentColor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume3 = composerStartRestartGroup.consume(localContentColor3);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -7169;
                        jM4600unboximpl = ((Color) objConsume3).m4600unboximpl();
                    } else {
                        jM4600unboximpl = j2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-126890956, i3, -1, "androidx.compose.material3.Icon (Icon.kt:70)");
                }
                m2432Iconww6aTOc(VectorPainterKt.rememberVectorPainter(imageVector, composerStartRestartGroup, i3 & 14), str, companion, jM4600unboximpl, composerStartRestartGroup, VectorPainter.$stable | (i3 & 112) | (i3 & 896) | (i3 & 7168), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                j2 = jM4600unboximpl;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        ProvidableCompositionLocal<Color> localContentColor4 = ContentColorKt.getLocalContentColor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume4 = composerStartRestartGroup.consume(localContentColor4);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -7169;
                        jM4600unboximpl = ((Color) objConsume4).m4600unboximpl();
                    } else {
                        jM4600unboximpl = j2;
                    }
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        ProvidableCompositionLocal<Color> localContentColor5 = ContentColorKt.getLocalContentColor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume5 = composerStartRestartGroup.consume(localContentColor5);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -7169;
                        jM4600unboximpl = ((Color) objConsume5).m4600unboximpl();
                    } else {
                        jM4600unboximpl = j2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-126890956, i3, -1, "androidx.compose.material3.Icon (Icon.kt:70)");
                }
                m2432Iconww6aTOc(VectorPainterKt.rememberVectorPainter(imageVector, composerStartRestartGroup, i3 & 14), str, companion, jM4600unboximpl, composerStartRestartGroup, VectorPainter.$stable | (i3 & 112) | (i3 & 896) | (i3 & 7168), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                j2 = jM4600unboximpl;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final long j4 = j2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i7) {
                        IconKt.m2433Iconww6aTOc(imageVector, str, modifier3, j4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        i4 = i2 & 4;
        if (i4 != 0) {
            if ((i & 384) == 0) {
                modifier2 = modifier;
                if (composerStartRestartGroup.changed(modifier2)) {
                    i5 = Fields.RotationX;
                } else {
                    i5 = Fields.SpotShadowColor;
                }
                i3 |= i5;
            }
            if ((i & 3072) == 0) {
                if ((i2 & 8) == 0) {
                    j2 = j;
                    if (composerStartRestartGroup.changed(j2)) {
                        i6 = Fields.CameraDistance;
                    }
                    i3 |= i6;
                } else {
                    j2 = j;
                }
                i6 = Fields.RotationZ;
                i3 |= i6;
            } else {
                j2 = j;
            }
            if ((i3 & 1171) == 1170) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        ProvidableCompositionLocal<Color> localContentColor6 = ContentColorKt.getLocalContentColor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume6 = composerStartRestartGroup.consume(localContentColor6);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -7169;
                        jM4600unboximpl = ((Color) objConsume6).m4600unboximpl();
                    } else {
                        jM4600unboximpl = j2;
                    }
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        ProvidableCompositionLocal<Color> localContentColor7 = ContentColorKt.getLocalContentColor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume7 = composerStartRestartGroup.consume(localContentColor7);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -7169;
                        jM4600unboximpl = ((Color) objConsume7).m4600unboximpl();
                    } else {
                        jM4600unboximpl = j2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-126890956, i3, -1, "androidx.compose.material3.Icon (Icon.kt:70)");
                }
                m2432Iconww6aTOc(VectorPainterKt.rememberVectorPainter(imageVector, composerStartRestartGroup, i3 & 14), str, companion, jM4600unboximpl, composerStartRestartGroup, VectorPainter.$stable | (i3 & 112) | (i3 & 896) | (i3 & 7168), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                j2 = jM4600unboximpl;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        ProvidableCompositionLocal<Color> localContentColor8 = ContentColorKt.getLocalContentColor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume8 = composerStartRestartGroup.consume(localContentColor8);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -7169;
                        jM4600unboximpl = ((Color) objConsume8).m4600unboximpl();
                    } else {
                        jM4600unboximpl = j2;
                    }
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        ProvidableCompositionLocal<Color> localContentColor9 = ContentColorKt.getLocalContentColor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume9 = composerStartRestartGroup.consume(localContentColor9);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -7169;
                        jM4600unboximpl = ((Color) objConsume9).m4600unboximpl();
                    } else {
                        jM4600unboximpl = j2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-126890956, i3, -1, "androidx.compose.material3.Icon (Icon.kt:70)");
                }
                m2432Iconww6aTOc(VectorPainterKt.rememberVectorPainter(imageVector, composerStartRestartGroup, i3 & 14), str, companion, jM4600unboximpl, composerStartRestartGroup, VectorPainter.$stable | (i3 & 112) | (i3 & 896) | (i3 & 7168), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                j2 = jM4600unboximpl;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final long j5 = j2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i7) {
                        IconKt.m2433Iconww6aTOc(imageVector, str, modifier3, j5, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        modifier2 = modifier;
        if ((i & 3072) == 0) {
            if ((i2 & 8) == 0) {
                j2 = j;
                if (composerStartRestartGroup.changed(j2)) {
                    i6 = Fields.CameraDistance;
                }
                i3 |= i6;
            } else {
                j2 = j;
            }
            i6 = Fields.RotationZ;
            i3 |= i6;
        } else {
            j2 = j;
        }
        if ((i3 & 1171) == 1170) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i4 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 8) != 0) {
                    ProvidableCompositionLocal<Color> localContentColor10 = ContentColorKt.getLocalContentColor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume10 = composerStartRestartGroup.consume(localContentColor10);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i3 &= -7169;
                    jM4600unboximpl = ((Color) objConsume10).m4600unboximpl();
                } else {
                    jM4600unboximpl = j2;
                }
            } else {
                if (i4 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 8) != 0) {
                    ProvidableCompositionLocal<Color> localContentColor11 = ContentColorKt.getLocalContentColor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11 = composerStartRestartGroup.consume(localContentColor11);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i3 &= -7169;
                    jM4600unboximpl = ((Color) objConsume11).m4600unboximpl();
                } else {
                    jM4600unboximpl = j2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-126890956, i3, -1, "androidx.compose.material3.Icon (Icon.kt:70)");
            }
            m2432Iconww6aTOc(VectorPainterKt.rememberVectorPainter(imageVector, composerStartRestartGroup, i3 & 14), str, companion, jM4600unboximpl, composerStartRestartGroup, VectorPainter.$stable | (i3 & 112) | (i3 & 896) | (i3 & 7168), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier3 = companion;
            j2 = jM4600unboximpl;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i4 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 8) != 0) {
                    ProvidableCompositionLocal<Color> localContentColor12 = ContentColorKt.getLocalContentColor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume12 = composerStartRestartGroup.consume(localContentColor12);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i3 &= -7169;
                    jM4600unboximpl = ((Color) objConsume12).m4600unboximpl();
                } else {
                    jM4600unboximpl = j2;
                }
            } else {
                if (i4 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 8) != 0) {
                    ProvidableCompositionLocal<Color> localContentColor13 = ContentColorKt.getLocalContentColor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume13 = composerStartRestartGroup.consume(localContentColor13);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i3 &= -7169;
                    jM4600unboximpl = ((Color) objConsume13).m4600unboximpl();
                } else {
                    jM4600unboximpl = j2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-126890956, i3, -1, "androidx.compose.material3.Icon (Icon.kt:70)");
            }
            m2432Iconww6aTOc(VectorPainterKt.rememberVectorPainter(imageVector, composerStartRestartGroup, i3 & 14), str, companion, jM4600unboximpl, composerStartRestartGroup, VectorPainter.$stable | (i3 & 112) | (i3 & 896) | (i3 & 7168), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier3 = companion;
            j2 = jM4600unboximpl;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final long j6 = j2;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i7) {
                    IconKt.m2433Iconww6aTOc(imageVector, str, modifier3, j6, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void m2431Iconww6aTOc(final ImageBitmap imageBitmap, final String str, Modifier modifier, long j, Composer composer, final int i, final int i2) {
        int i3;
        final Modifier modifier2;
        final long j2;
        Modifier.Companion companion;
        int i4;
        Modifier modifier3;
        long jM4600unboximpl;
        boolean zChanged;
        Object objRememberedValue;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i5;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1092052280);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(Icon)P(!,3:c#ui.graphics.Color)105@5106L7,107@5136L42,108@5183L136:Icon.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changedInstance(imageBitmap) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        if ((i2 & 2) != 0) {
            i3 |= 48;
        } else if ((i & 48) == 0) {
            i3 |= composerStartRestartGroup.changed(str) ? 32 : 16;
        }
        int i6 = i2 & 4;
        if (i6 == 0) {
            if ((i & 384) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? Fields.RotationX : Fields.SpotShadowColor;
            }
            if ((i & 3072) == 0) {
                if ((i2 & 8) == 0) {
                    j2 = j;
                    if (composerStartRestartGroup.changed(j2)) {
                        i5 = Fields.CameraDistance;
                    }
                    i3 |= i5;
                } else {
                    j2 = j;
                }
                i5 = Fields.RotationZ;
                i3 |= i5;
            } else {
                j2 = j;
            }
            if ((i3 & 1171) == 1170 || !composerStartRestartGroup.getSkipping()) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                    if (i6 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        ProvidableCompositionLocal<Color> localContentColor = ContentColorKt.getLocalContentColor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume = composerStartRestartGroup.consume(localContentColor);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i4 = i3 & (-7169);
                        modifier3 = companion;
                        jM4600unboximpl = ((Color) objConsume).m4600unboximpl();
                    } else {
                        i4 = i3;
                        modifier3 = companion;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1092052280, i4, -1, "androidx.compose.material3.Icon (Icon.kt:106)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2144951290, "CC(remember):Icon.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(imageBitmap);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        BitmapPainter bitmapPainter = new BitmapPainter(imageBitmap, 0L, 0L, 6, null);
                        composerStartRestartGroup.updateRememberedValue(bitmapPainter);
                        objRememberedValue = bitmapPainter;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    m2432Iconww6aTOc((BitmapPainter) objRememberedValue, str, modifier3, jM4600unboximpl, composerStartRestartGroup, i4 & 8176, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier3;
                    j2 = jM4600unboximpl;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                    }
                    i4 = i3;
                    modifier3 = modifier2;
                }
                jM4600unboximpl = j2;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1092052280, i4, -1, "androidx.compose.material3.Icon (Icon.kt:106)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2144951290, "CC(remember):Icon.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(imageBitmap);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    BitmapPainter bitmapPainter2 = new BitmapPainter(imageBitmap, 0L, 0L, 6, null);
                    composerStartRestartGroup.updateRememberedValue(bitmapPainter2);
                    objRememberedValue = bitmapPainter2;
                } else {
                    BitmapPainter bitmapPainter3 = new BitmapPainter(imageBitmap, 0L, 0L, 6, null);
                    composerStartRestartGroup.updateRememberedValue(bitmapPainter3);
                    objRememberedValue = bitmapPainter3;
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                m2432Iconww6aTOc((BitmapPainter) objRememberedValue, str, modifier3, jM4600unboximpl, composerStartRestartGroup, i4 & 8176, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier3;
                j2 = jM4600unboximpl;
            } else {
                composerStartRestartGroup.skipToGroupEnd();
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

                    public final void invoke(Composer composer2, int i7) {
                        IconKt.m2431Iconww6aTOc(imageBitmap, str, modifier2, j2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        modifier2 = modifier;
        if ((i & 3072) == 0) {
            if ((i2 & 8) == 0) {
                j2 = j;
                if (composerStartRestartGroup.changed(j2)) {
                    i5 = Fields.CameraDistance;
                }
                i3 |= i5;
            } else {
                j2 = j;
            }
            i5 = Fields.RotationZ;
            i3 |= i5;
        } else {
            j2 = j;
        }
        if ((i3 & 1171) == 1170) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i6 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 8) != 0) {
                    ProvidableCompositionLocal<Color> localContentColor2 = ContentColorKt.getLocalContentColor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume2 = composerStartRestartGroup.consume(localContentColor2);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i4 = i3 & (-7169);
                    modifier3 = companion;
                    jM4600unboximpl = ((Color) objConsume2).m4600unboximpl();
                } else {
                    i4 = i3;
                    modifier3 = companion;
                    jM4600unboximpl = j2;
                }
            } else {
                if (i6 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 8) != 0) {
                    ProvidableCompositionLocal<Color> localContentColor3 = ContentColorKt.getLocalContentColor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume3 = composerStartRestartGroup.consume(localContentColor3);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i4 = i3 & (-7169);
                    modifier3 = companion;
                    jM4600unboximpl = ((Color) objConsume3).m4600unboximpl();
                } else {
                    i4 = i3;
                    modifier3 = companion;
                    jM4600unboximpl = j2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1092052280, i4, -1, "androidx.compose.material3.Icon (Icon.kt:106)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2144951290, "CC(remember):Icon.kt#9igjgp");
            zChanged = composerStartRestartGroup.changed(imageBitmap);
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                BitmapPainter bitmapPainter4 = new BitmapPainter(imageBitmap, 0L, 0L, 6, null);
                composerStartRestartGroup.updateRememberedValue(bitmapPainter4);
                objRememberedValue = bitmapPainter4;
            } else {
                BitmapPainter bitmapPainter5 = new BitmapPainter(imageBitmap, 0L, 0L, 6, null);
                composerStartRestartGroup.updateRememberedValue(bitmapPainter5);
                objRememberedValue = bitmapPainter5;
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            m2432Iconww6aTOc((BitmapPainter) objRememberedValue, str, modifier3, jM4600unboximpl, composerStartRestartGroup, i4 & 8176, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier2 = modifier3;
            j2 = jM4600unboximpl;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i6 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 8) != 0) {
                    ProvidableCompositionLocal<Color> localContentColor4 = ContentColorKt.getLocalContentColor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume4 = composerStartRestartGroup.consume(localContentColor4);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i4 = i3 & (-7169);
                    modifier3 = companion;
                    jM4600unboximpl = ((Color) objConsume4).m4600unboximpl();
                } else {
                    i4 = i3;
                    modifier3 = companion;
                    jM4600unboximpl = j2;
                }
            } else {
                if (i6 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 8) != 0) {
                    ProvidableCompositionLocal<Color> localContentColor5 = ContentColorKt.getLocalContentColor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume5 = composerStartRestartGroup.consume(localContentColor5);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i4 = i3 & (-7169);
                    modifier3 = companion;
                    jM4600unboximpl = ((Color) objConsume5).m4600unboximpl();
                } else {
                    i4 = i3;
                    modifier3 = companion;
                    jM4600unboximpl = j2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1092052280, i4, -1, "androidx.compose.material3.Icon (Icon.kt:106)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2144951290, "CC(remember):Icon.kt#9igjgp");
            zChanged = composerStartRestartGroup.changed(imageBitmap);
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                BitmapPainter bitmapPainter6 = new BitmapPainter(imageBitmap, 0L, 0L, 6, null);
                composerStartRestartGroup.updateRememberedValue(bitmapPainter6);
                objRememberedValue = bitmapPainter6;
            } else {
                BitmapPainter bitmapPainter7 = new BitmapPainter(imageBitmap, 0L, 0L, 6, null);
                composerStartRestartGroup.updateRememberedValue(bitmapPainter7);
                objRememberedValue = bitmapPainter7;
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            m2432Iconww6aTOc((BitmapPainter) objRememberedValue, str, modifier3, jM4600unboximpl, composerStartRestartGroup, i4 & 8176, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier2 = modifier3;
            j2 = jM4600unboximpl;
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

                public final void invoke(Composer composer2, int i7) {
                    IconKt.m2431Iconww6aTOc(imageBitmap, str, modifier2, j2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void m2432Iconww6aTOc(final Painter painter, final String str, Modifier modifier, long j, Composer composer, final int i, final int i2) {
        int i3;
        Modifier modifier2;
        long jM4600unboximpl;
        Modifier.Companion companion;
        Modifier modifier3;
        boolean z;
        Object objRememberedValue;
        Object obj;
        Modifier.Companion companionSemantics$default;
        final Modifier modifier4;
        final long j2;
        boolean z2;
        Object objRememberedValue2;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i4;
        Composer composerStartRestartGroup = composer.startRestartGroup(-2142239481);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(Icon)P(2!,3:c#ui.graphics.Color)142@6849L7,145@6891L82,155@7235L217:Icon.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changedInstance(painter) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        if ((i2 & 2) != 0) {
            i3 |= 48;
        } else if ((i & 48) == 0) {
            i3 |= composerStartRestartGroup.changed(str) ? 32 : 16;
        }
        int i5 = i2 & 4;
        if (i5 == 0) {
            if ((i & 384) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? Fields.RotationX : Fields.SpotShadowColor;
            }
            if ((i & 3072) == 0) {
                jM4600unboximpl = j;
                if ((i2 & 8) == 0 || !composerStartRestartGroup.changed(jM4600unboximpl)) {
                    i4 = Fields.RotationZ;
                } else {
                    i4 = 2048;
                }
                i3 |= i4;
            } else {
                jM4600unboximpl = j;
            }
            if ((i3 & 1171) == 1170 || !composerStartRestartGroup.getSkipping()) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        ProvidableCompositionLocal<Color> localContentColor = ContentColorKt.getLocalContentColor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume = composerStartRestartGroup.consume(localContentColor);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -7169;
                        modifier3 = companion;
                        jM4600unboximpl = ((Color) objConsume).m4600unboximpl();
                    } else {
                        modifier3 = companion;
                    }
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                    }
                    modifier3 = modifier2;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-2142239481, i3, -1, "androidx.compose.material3.Icon (Icon.kt:143)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2144895090, "CC(remember):Icon.kt#9igjgp");
                z = (((i3 & 7168) ^ 3072) <= 2048 && composerStartRestartGroup.changed(jM4600unboximpl)) || (i3 & 3072) == 2048;
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    if (Color.m4591equalsimpl0(jM4600unboximpl, Color.INSTANCE.m4626getUnspecified0d7_KjU())) {
                        obj = null;
                        objRememberedValue = null;
                    } else {
                        obj = null;
                        objRememberedValue = ColorFilter.Companion.m4631tintxETnrds$default(ColorFilter.INSTANCE, jM4600unboximpl, 0, 2, null);
                    }
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    obj = null;
                }
                ColorFilter colorFilter = (ColorFilter) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.startReplaceGroup(-2144891392);
                ComposerKt.sourceInformation(composerStartRestartGroup, "148@7067L115");
                if (str != null) {
                    Modifier.Companion companion2 = Modifier.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2144889425, "CC(remember):Icon.kt#9igjgp");
                    if ((i3 & 112) == 32) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z2 || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj2) {
                                invoke((SemanticsPropertyReceiver) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, str);
                                SemanticsPropertiesKt.m6630setRolekuIjeqM(semanticsPropertyReceiver, Role.INSTANCE.m6614getImageo7Vup1c());
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    companionSemantics$default = SemanticsModifierKt.semantics$default(companion2, false, (Function1) objRememberedValue2, 1, obj);
                } else {
                    companionSemantics$default = Modifier.INSTANCE;
                }
                composerStartRestartGroup.endReplaceGroup();
                long j3 = jM4600unboximpl;
                BoxKt.Box(PainterModifierKt.paint$default(defaultSizeFor(GraphicsLayerModifierKt.toolingGraphicsLayer(modifier3), painter), painter, false, null, ContentScale.INSTANCE.getFit(), 0.0f, colorFilter, 22, null).then(companionSemantics$default), composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier4 = modifier3;
                j2 = j3;
            } else {
                composerStartRestartGroup.skipToGroupEnd();
                modifier4 = modifier2;
                j2 = jM4600unboximpl;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i6) {
                        IconKt.m2432Iconww6aTOc(painter, str, modifier4, j2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        modifier2 = modifier;
        if ((i & 3072) == 0) {
            jM4600unboximpl = j;
            if ((i2 & 8) == 0) {
                i4 = Fields.RotationZ;
            } else {
                i4 = Fields.RotationZ;
            }
            i3 |= i4;
        } else {
            jM4600unboximpl = j;
        }
        if ((i3 & 1171) == 1170) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i5 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 8) != 0) {
                    ProvidableCompositionLocal<Color> localContentColor2 = ContentColorKt.getLocalContentColor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume2 = composerStartRestartGroup.consume(localContentColor2);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i3 &= -7169;
                    modifier3 = companion;
                    jM4600unboximpl = ((Color) objConsume2).m4600unboximpl();
                } else {
                    modifier3 = companion;
                }
            } else {
                if (i5 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 8) != 0) {
                    ProvidableCompositionLocal<Color> localContentColor3 = ContentColorKt.getLocalContentColor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume3 = composerStartRestartGroup.consume(localContentColor3);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i3 &= -7169;
                    modifier3 = companion;
                    jM4600unboximpl = ((Color) objConsume3).m4600unboximpl();
                } else {
                    modifier3 = companion;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-2142239481, i3, -1, "androidx.compose.material3.Icon (Icon.kt:143)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2144895090, "CC(remember):Icon.kt#9igjgp");
            if (((i3 & 7168) ^ 3072) <= 2048) {
            }
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (z) {
                if (Color.m4591equalsimpl0(jM4600unboximpl, Color.INSTANCE.m4626getUnspecified0d7_KjU())) {
                    obj = null;
                    objRememberedValue = null;
                } else {
                    obj = null;
                    objRememberedValue = ColorFilter.Companion.m4631tintxETnrds$default(ColorFilter.INSTANCE, jM4600unboximpl, 0, 2, null);
                }
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                if (Color.m4591equalsimpl0(jM4600unboximpl, Color.INSTANCE.m4626getUnspecified0d7_KjU())) {
                    obj = null;
                    objRememberedValue = null;
                } else {
                    obj = null;
                    objRememberedValue = ColorFilter.Companion.m4631tintxETnrds$default(ColorFilter.INSTANCE, jM4600unboximpl, 0, 2, null);
                }
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            ColorFilter colorFilter2 = (ColorFilter) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.startReplaceGroup(-2144891392);
            ComposerKt.sourceInformation(composerStartRestartGroup, "148@7067L115");
            if (str != null) {
                Modifier.Companion companion3 = Modifier.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2144889425, "CC(remember):Icon.kt#9igjgp");
                if ((i3 & 112) == 32) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    objRememberedValue2 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj2) {
                            invoke((SemanticsPropertyReceiver) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, str);
                            SemanticsPropertiesKt.m6630setRolekuIjeqM(semanticsPropertyReceiver, Role.INSTANCE.m6614getImageo7Vup1c());
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj2) {
                            invoke((SemanticsPropertyReceiver) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, str);
                            SemanticsPropertiesKt.m6630setRolekuIjeqM(semanticsPropertyReceiver, Role.INSTANCE.m6614getImageo7Vup1c());
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                companionSemantics$default = SemanticsModifierKt.semantics$default(companion3, false, (Function1) objRememberedValue2, 1, obj);
            } else {
                companionSemantics$default = Modifier.INSTANCE;
            }
            composerStartRestartGroup.endReplaceGroup();
            long j4 = jM4600unboximpl;
            BoxKt.Box(PainterModifierKt.paint$default(defaultSizeFor(GraphicsLayerModifierKt.toolingGraphicsLayer(modifier3), painter), painter, false, null, ContentScale.INSTANCE.getFit(), 0.0f, colorFilter2, 22, null).then(companionSemantics$default), composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier4 = modifier3;
            j2 = j4;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i5 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 8) != 0) {
                    ProvidableCompositionLocal<Color> localContentColor4 = ContentColorKt.getLocalContentColor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume4 = composerStartRestartGroup.consume(localContentColor4);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i3 &= -7169;
                    modifier3 = companion;
                    jM4600unboximpl = ((Color) objConsume4).m4600unboximpl();
                } else {
                    modifier3 = companion;
                }
            } else {
                if (i5 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 8) != 0) {
                    ProvidableCompositionLocal<Color> localContentColor5 = ContentColorKt.getLocalContentColor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume5 = composerStartRestartGroup.consume(localContentColor5);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i3 &= -7169;
                    modifier3 = companion;
                    jM4600unboximpl = ((Color) objConsume5).m4600unboximpl();
                } else {
                    modifier3 = companion;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-2142239481, i3, -1, "androidx.compose.material3.Icon (Icon.kt:143)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2144895090, "CC(remember):Icon.kt#9igjgp");
            if (((i3 & 7168) ^ 3072) <= 2048) {
            }
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (z) {
                if (Color.m4591equalsimpl0(jM4600unboximpl, Color.INSTANCE.m4626getUnspecified0d7_KjU())) {
                    obj = null;
                    objRememberedValue = null;
                } else {
                    obj = null;
                    objRememberedValue = ColorFilter.Companion.m4631tintxETnrds$default(ColorFilter.INSTANCE, jM4600unboximpl, 0, 2, null);
                }
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                if (Color.m4591equalsimpl0(jM4600unboximpl, Color.INSTANCE.m4626getUnspecified0d7_KjU())) {
                    obj = null;
                    objRememberedValue = null;
                } else {
                    obj = null;
                    objRememberedValue = ColorFilter.Companion.m4631tintxETnrds$default(ColorFilter.INSTANCE, jM4600unboximpl, 0, 2, null);
                }
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            ColorFilter colorFilter3 = (ColorFilter) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.startReplaceGroup(-2144891392);
            ComposerKt.sourceInformation(composerStartRestartGroup, "148@7067L115");
            if (str != null) {
                Modifier.Companion companion4 = Modifier.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2144889425, "CC(remember):Icon.kt#9igjgp");
                if ((i3 & 112) == 32) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    objRememberedValue2 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj2) {
                            invoke((SemanticsPropertyReceiver) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, str);
                            SemanticsPropertiesKt.m6630setRolekuIjeqM(semanticsPropertyReceiver, Role.INSTANCE.m6614getImageo7Vup1c());
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj2) {
                            invoke((SemanticsPropertyReceiver) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, str);
                            SemanticsPropertiesKt.m6630setRolekuIjeqM(semanticsPropertyReceiver, Role.INSTANCE.m6614getImageo7Vup1c());
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                companionSemantics$default = SemanticsModifierKt.semantics$default(companion4, false, (Function1) objRememberedValue2, 1, obj);
            } else {
                companionSemantics$default = Modifier.INSTANCE;
            }
            composerStartRestartGroup.endReplaceGroup();
            long j5 = jM4600unboximpl;
            BoxKt.Box(PainterModifierKt.paint$default(defaultSizeFor(GraphicsLayerModifierKt.toolingGraphicsLayer(modifier3), painter), painter, false, null, ContentScale.INSTANCE.getFit(), 0.0f, colorFilter3, 22, null).then(companionSemantics$default), composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier4 = modifier3;
            j2 = j5;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj2, Object obj3) {
                    invoke((Composer) obj2, ((Number) obj3).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i6) {
                    IconKt.m2432Iconww6aTOc(painter, str, modifier4, j2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void Icon(final Painter painter, final ColorProducer colorProducer, final String str, Modifier modifier, Composer composer, final int i, final int i2) {
        int i3;
        Modifier.Companion companionSemantics$default;
        Composer composerStartRestartGroup = composer.startRestartGroup(1755070997);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(Icon)P(2,3)206@9303L163,202@9171L330:Icon.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changedInstance(painter) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        if ((i2 & 2) != 0) {
            i3 |= 48;
        } else if ((i & 48) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(colorProducer) ? 32 : 16;
        }
        if ((i2 & 4) != 0) {
            i3 |= 384;
        } else if ((i & 384) == 0) {
            i3 |= composerStartRestartGroup.changed(str) ? 256 : Fields.SpotShadowColor;
        }
        int i4 = i2 & 8;
        if (i4 != 0) {
            i3 |= 3072;
        } else if ((i & 3072) == 0) {
            i3 |= composerStartRestartGroup.changed(modifier) ? Fields.CameraDistance : Fields.RotationZ;
        }
        if ((i3 & 1171) != 1170 || !composerStartRestartGroup.getSkipping()) {
            if (i4 != 0) {
                modifier = Modifier.INSTANCE;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1755070997, i3, -1, "androidx.compose.material3.Icon (Icon.kt:191)");
            }
            composerStartRestartGroup.startReplaceGroup(-2144829472);
            ComposerKt.sourceInformation(composerStartRestartGroup, "194@9002L115");
            if (str != null) {
                Modifier.Companion companion = Modifier.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2144827505, "CC(remember):Icon.kt#9igjgp");
                boolean z = (i3 & 896) == 256;
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
                            SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, str);
                            SemanticsPropertiesKt.m6630setRolekuIjeqM(semanticsPropertyReceiver, Role.INSTANCE.m6614getImageo7Vup1c());
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                companionSemantics$default = SemanticsModifierKt.semantics$default(companion, false, (Function1) objRememberedValue, 1, null);
            } else {
                companionSemantics$default = Modifier.INSTANCE;
            }
            composerStartRestartGroup.endReplaceGroup();
            Modifier modifierDefaultSizeForColorProducer = defaultSizeForColorProducer(GraphicsLayerModifierKt.toolingGraphicsLayer(modifier), painter);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2144817825, "CC(remember):Icon.kt#9igjgp");
            boolean zChangedInstance = composerStartRestartGroup.changedInstance(painter) | composerStartRestartGroup.changedInstance(colorProducer);
            Object objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (zChangedInstance || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        ColorFilter colorFilterM4631tintxETnrds$default;
                        Painter painter2 = painter;
                        ColorProducer colorProducer2 = colorProducer;
                        long jMo5083getSizeNHjbRc = drawScope.mo5083getSizeNHjbRc();
                        if (colorProducer2 != null) {
                            colorFilterM4631tintxETnrds$default = ColorFilter.Companion.m4631tintxETnrds$default(ColorFilter.INSTANCE, colorProducer2.mo2330invoke0d7_KjU(), 0, 2, null);
                        } else {
                            colorFilterM4631tintxETnrds$default = null;
                        }
                        Painter.m5309drawx_KDEd0$default(painter2, drawScope, jMo5083getSizeNHjbRc, 0.0f, colorFilterM4631tintxETnrds$default, 2, null);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            BoxKt.Box(DrawModifierKt.drawBehind(modifierDefaultSizeForColorProducer, (Function1) objRememberedValue2).then(companionSemantics$default), composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.skipToGroupEnd();
        }
        final Modifier modifier2 = modifier;
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
                    IconKt.Icon(painter, colorProducer, str, modifier2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    private static final Modifier defaultSizeForColorProducer(Modifier modifier, Painter painter) {
        Modifier modifierLayout;
        if (Size.m4411equalsimpl0(painter.getIntrinsicSize(), Size.INSTANCE.m4423getUnspecifiedNHjbRc()) || m2434isInfiniteuvyYCjk(painter.getIntrinsicSize())) {
            modifierLayout = DefaultIconSizeModifier;
        } else {
            long intrinsicSize = painter.getIntrinsicSize();
            final float fM4415getWidthimpl = Size.m4415getWidthimpl(intrinsicSize);
            final float fM4412getHeightimpl = Size.m4412getHeightimpl(intrinsicSize);
            modifierLayout = LayoutModifierKt.layout(Modifier.INSTANCE, new Function3<MeasureScope, Measurable, Constraints, MeasureResult>() {
                {
                    super(3);
                }

                public Object invoke(Object obj, Object obj2, Object obj3) {
                    return m2435invoke3p2s80s((MeasureScope) obj, (Measurable) obj2, ((Constraints) obj3).unbox-impl());
                }

                public final MeasureResult m2435invoke3p2s80s(MeasureScope measureScope, Measurable measurable, long j) {
                    final Placeable placeableMo6026measureBRTryo0 = measurable.mo6026measureBRTryo0(Constraints.Companion.fixed-JhjzzOo((int) fM4415getWidthimpl, (int) fM4412getHeightimpl));
                    return MeasureScope.CC.layout$default(measureScope, placeableMo6026measureBRTryo0.getWidth(), placeableMo6026measureBRTryo0.getHeight(), null, new Function1<Placeable.PlacementScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((Placeable.PlacementScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Placeable.PlacementScope placementScope) {
                            Placeable.PlacementScope.place$default(placementScope, placeableMo6026measureBRTryo0, 0, 0, 0.0f, 4, null);
                        }
                    }, 4, null);
                }
            });
        }
        return modifier.then(modifierLayout);
    }

    private static final Modifier defaultSizeFor(Modifier modifier, Painter painter) {
        Modifier.Companion companion;
        if (Size.m4411equalsimpl0(painter.getIntrinsicSize(), Size.INSTANCE.m4423getUnspecifiedNHjbRc()) || m2434isInfiniteuvyYCjk(painter.getIntrinsicSize())) {
            companion = DefaultIconSizeModifier;
        } else {
            companion = Modifier.INSTANCE;
        }
        return modifier.then(companion);
    }

    private static final boolean m2434isInfiniteuvyYCjk(long j) {
        return Float.isInfinite(Size.m4415getWidthimpl(j)) && Float.isInfinite(Size.m4412getHeightimpl(j));
    }
}
