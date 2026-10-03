package androidx.compose.material3;

import androidx.compose.foundation.BorderStroke;
import androidx.compose.foundation.interaction.InteractionSourceKt;
import androidx.compose.foundation.interaction.MutableInteractionSource;
import androidx.compose.foundation.layout.Arrangement;
import androidx.compose.foundation.layout.ColumnKt;
import androidx.compose.foundation.layout.ColumnScope;
import androidx.compose.foundation.layout.ColumnScopeInstance;
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
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000L\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0007\u001a\u0083\u0001\u0010\u0000\u001a\u00020\u00012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00010\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\r2\n\b\u0002\u0010\u000e\u001a\u0004\u0018\u00010\u000f2\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u00112\u001c\u0010\u0012\u001a\u0018\u0012\u0004\u0012\u00020\u0014\u0012\u0004\u0012\u00020\u00010\u0013¢\u0006\u0002\b\u0015¢\u0006\u0002\b\u0016H\u0007¢\u0006\u0002\u0010\u0017\u001a_\u0010\u0000\u001a\u00020\u00012\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\r2\n\b\u0002\u0010\u000e\u001a\u0004\u0018\u00010\u000f2\u001c\u0010\u0012\u001a\u0018\u0012\u0004\u0012\u00020\u0014\u0012\u0004\u0012\u00020\u00010\u0013¢\u0006\u0002\b\u0015¢\u0006\u0002\b\u0016H\u0007¢\u0006\u0002\u0010\u0018\u001aw\u0010\u0019\u001a\u00020\u00012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00010\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\r2\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u00112\u001c\u0010\u0012\u001a\u0018\u0012\u0004\u0012\u00020\u0014\u0012\u0004\u0012\u00020\u00010\u0013¢\u0006\u0002\b\u0015¢\u0006\u0002\b\u0016H\u0007¢\u0006\u0002\u0010\u001a\u001aS\u0010\u0019\u001a\u00020\u00012\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\r2\u001c\u0010\u0012\u001a\u0018\u0012\u0004\u0012\u00020\u0014\u0012\u0004\u0012\u00020\u00010\u0013¢\u0006\u0002\b\u0015¢\u0006\u0002\b\u0016H\u0007¢\u0006\u0002\u0010\u001b\u001a\u0081\u0001\u0010\u001c\u001a\u00020\u00012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00010\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u00112\u001c\u0010\u0012\u001a\u0018\u0012\u0004\u0012\u00020\u0014\u0012\u0004\u0012\u00020\u00010\u0013¢\u0006\u0002\b\u0015¢\u0006\u0002\b\u0016H\u0007¢\u0006\u0002\u0010\u0017\u001a]\u0010\u001c\u001a\u00020\u00012\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\u001c\u0010\u0012\u001a\u0018\u0012\u0004\u0012\u00020\u0014\u0012\u0004\u0012\u00020\u00010\u0013¢\u0006\u0002\b\u0015¢\u0006\u0002\b\u0016H\u0007¢\u0006\u0002\u0010\u0018¨\u0006\u001d"}, d2 = {"Card", "", "onClick", "Lkotlin/Function0;", "modifier", "Landroidx/compose/ui/Modifier;", "enabled", "", "shape", "Landroidx/compose/ui/graphics/Shape;", "colors", "Landroidx/compose/material3/CardColors;", "elevation", "Landroidx/compose/material3/CardElevation;", "border", "Landroidx/compose/foundation/BorderStroke;", "interactionSource", "Landroidx/compose/foundation/interaction/MutableInteractionSource;", "content", "Lkotlin/Function1;", "Landroidx/compose/foundation/layout/ColumnScope;", "Landroidx/compose/runtime/Composable;", "Lkotlin/ExtensionFunctionType;", "(Lkotlin/jvm/functions/Function0;Landroidx/compose/ui/Modifier;ZLandroidx/compose/ui/graphics/Shape;Landroidx/compose/material3/CardColors;Landroidx/compose/material3/CardElevation;Landroidx/compose/foundation/BorderStroke;Landroidx/compose/foundation/interaction/MutableInteractionSource;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "(Landroidx/compose/ui/Modifier;Landroidx/compose/ui/graphics/Shape;Landroidx/compose/material3/CardColors;Landroidx/compose/material3/CardElevation;Landroidx/compose/foundation/BorderStroke;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "ElevatedCard", "(Lkotlin/jvm/functions/Function0;Landroidx/compose/ui/Modifier;ZLandroidx/compose/ui/graphics/Shape;Landroidx/compose/material3/CardColors;Landroidx/compose/material3/CardElevation;Landroidx/compose/foundation/interaction/MutableInteractionSource;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "(Landroidx/compose/ui/Modifier;Landroidx/compose/ui/graphics/Shape;Landroidx/compose/material3/CardColors;Landroidx/compose/material3/CardElevation;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "OutlinedCard", "material3_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class CardKt {
    public static final void Card(Modifier modifier, Shape shape, CardColors cardColors, CardElevation cardElevation, BorderStroke borderStroke, final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2) {
        Modifier modifier2;
        int i3;
        Shape shape2;
        CardColors cardColors2;
        CardElevation cardElevation2;
        BorderStroke borderStroke2;
        Modifier.Companion companion;
        Shape shape3;
        CardColors cardColors3;
        CardElevation cardElevationM2071cardElevationaqJV_2Y;
        BorderStroke borderStroke3;
        int i4;
        CardElevation cardElevation3;
        final CardElevation cardElevation4;
        final BorderStroke borderStroke4;
        int i5;
        int i6;
        Composer composerStartRestartGroup = composer.startRestartGroup(1179621553);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(Card)P(4,5,1,3)82@3741L5,83@3786L12,84@3844L15,93@4163L57,95@4259L41,88@3951L349:Card.kt#uh7d8r");
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
                shape2 = shape;
                int i8 = composerStartRestartGroup.changed(shape2) ? 32 : 16;
                i3 |= i8;
            } else {
                shape2 = shape;
            }
            i3 |= i8;
        } else {
            shape2 = shape;
        }
        if ((i & 384) == 0) {
            if ((i2 & 4) == 0) {
                cardColors2 = cardColors;
                if (composerStartRestartGroup.changed(cardColors2)) {
                    i6 = Fields.RotationX;
                }
                i3 |= i6;
            } else {
                cardColors2 = cardColors;
            }
            i6 = Fields.SpotShadowColor;
            i3 |= i6;
        } else {
            cardColors2 = cardColors;
        }
        if ((i & 3072) == 0) {
            if ((i2 & 8) == 0) {
                cardElevation2 = cardElevation;
                if (composerStartRestartGroup.changed(cardElevation2)) {
                    i5 = Fields.CameraDistance;
                }
                i3 |= i5;
            } else {
                cardElevation2 = cardElevation;
            }
            i5 = Fields.RotationZ;
            i3 |= i5;
        } else {
            cardElevation2 = cardElevation;
        }
        int i9 = i2 & 16;
        if (i9 != 0) {
            i3 |= 24576;
            borderStroke2 = borderStroke;
        } else {
            borderStroke2 = borderStroke;
            if ((i & 24576) == 0) {
                i3 |= composerStartRestartGroup.changed(borderStroke2) ? Fields.Clip : Fields.Shape;
            }
        }
        if ((i2 & 32) != 0) {
            i3 |= 196608;
        } else if ((i & 196608) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function3) ? Fields.RenderEffect : 65536;
        }
        if ((74899 & i3) != 74898 || !composerStartRestartGroup.getSkipping()) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) == 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                companion = i7 != 0 ? Modifier.INSTANCE : modifier2;
                if ((i2 & 2) != 0) {
                    shape3 = CardDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    i3 &= -113;
                } else {
                    shape3 = shape2;
                }
                if ((i2 & 4) != 0) {
                    cardColors3 = CardDefaults.INSTANCE.cardColors(composerStartRestartGroup, 6);
                    i3 &= -897;
                } else {
                    cardColors3 = cardColors2;
                }
                if ((i2 & 8) != 0) {
                    cardElevationM2071cardElevationaqJV_2Y = CardDefaults.INSTANCE.m2071cardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                    i3 &= -7169;
                } else {
                    cardElevationM2071cardElevationaqJV_2Y = cardElevation2;
                }
                borderStroke3 = i9 != 0 ? null : borderStroke;
                CardElevation cardElevation5 = cardElevationM2071cardElevationaqJV_2Y;
                i4 = i3;
                cardElevation3 = cardElevation5;
            } else {
                composerStartRestartGroup.skipToGroupEnd();
                if ((i2 & 2) != 0) {
                    i3 &= -113;
                }
                if ((i2 & 4) != 0) {
                    i3 &= -897;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                }
                companion = modifier2;
                shape3 = shape2;
                cardColors3 = cardColors2;
                borderStroke3 = borderStroke2;
                i4 = i3;
                cardElevation3 = cardElevation2;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1179621553, i4, -1, "androidx.compose.material3.Card (Card.kt:87)");
            }
            CardElevation cardElevation6 = cardElevation3;
            SurfaceKt.m2868SurfaceT9BRK9s(companion, shape3, cardColors3.m2063containerColorvNxB06k$material3_release(true), cardColors3.m2064contentColorvNxB06k$material3_release(true), 0.0f, cardElevation3.shadowElevation$material3_release(true, null, composerStartRestartGroup, ((i4 >> 3) & 896) | 54).getValue().unbox-impl(), borderStroke3, ComposableLambdaKt.rememberComposableLambda(664103990, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i10) {
                    ComposerKt.sourceInformation(composer2, "C96@4269L25:Card.kt#uh7d8r");
                    if ((i10 & 3) == 2 && composer2.getSkipping()) {
                        composer2.skipToGroupEnd();
                        return;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(664103990, i10, -1, "androidx.compose.material3.Card.<anonymous> (Card.kt:96)");
                    }
                    Function3<ColumnScope, Composer, Integer, Unit> function4 = function3;
                    ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                    Modifier.Companion companion2 = Modifier.INSTANCE;
                    MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.INSTANCE.getStart(), composer2, 0);
                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                    CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, companion2);
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
                    function4.invoke(ColumnScopeInstance.INSTANCE, composer2, 6);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    composer2.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i4 & 14) | 12582912 | (i4 & 112) | (3670016 & (i4 << 6)), 16);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            cardColors2 = cardColors3;
            cardElevation4 = cardElevation6;
            borderStroke4 = borderStroke3;
        } else {
            composerStartRestartGroup.skipToGroupEnd();
            companion = modifier2;
            shape3 = shape2;
            cardElevation4 = cardElevation2;
            borderStroke4 = borderStroke2;
        }
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier3 = companion;
            final Shape shape4 = shape3;
            final CardColors cardColors4 = cardColors2;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i10) {
                    CardKt.Card(modifier3, shape4, cardColors4, cardElevation4, borderStroke4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void Card(final Function0<Unit> function0, Modifier modifier, boolean z, Shape shape, CardColors cardColors, CardElevation cardElevation, BorderStroke borderStroke, MutableInteractionSource mutableInteractionSource, final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2) {
        int i3;
        Modifier modifier2;
        int i4;
        boolean z2;
        int i5;
        Shape shape2;
        CardColors cardColors2;
        CardElevation cardElevation2;
        int i6;
        BorderStroke borderStroke2;
        int i7;
        int i8;
        int i9;
        int i10;
        CardColors cardColors3;
        final CardElevation cardElevationM2071cardElevationaqJV_2Y;
        BorderStroke borderStroke3;
        BorderStroke borderStroke4;
        MutableInteractionSource mutableInteractionSource2;
        int i11;
        MutableInteractionSource mutableInteractionSource3;
        final Shape shape3;
        final MutableInteractionSource mutableInteractionSource4;
        final boolean z3;
        final BorderStroke borderStroke5;
        final Modifier modifier3;
        final CardColors cardColors4;
        Object objRememberedValue;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i12;
        int i13;
        Composer composerStartRestartGroup = composer.startRestartGroup(-2024281376);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(Card)P(7,6,4,8,1,3!1,5)141@6394L5,142@6439L12,143@6497L15,157@7034L43,160@7163L41,150@6782L422:Card.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changedInstance(function0) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i14 = i2 & 2;
        if (i14 == 0) {
            if ((i & 48) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            i4 = i2 & 4;
            if (i4 != 0) {
                if ((i & 384) == 0) {
                    z2 = z;
                    if (composerStartRestartGroup.changed(z2)) {
                        i5 = Fields.RotationX;
                    } else {
                        i5 = Fields.SpotShadowColor;
                    }
                    i3 |= i5;
                }
                if ((i & 3072) == 0) {
                    if ((i2 & 8) == 0) {
                        shape2 = shape;
                        if (composerStartRestartGroup.changed(shape2)) {
                            i13 = Fields.CameraDistance;
                        }
                        i3 |= i13;
                    } else {
                        shape2 = shape;
                    }
                    i13 = Fields.RotationZ;
                    i3 |= i13;
                } else {
                    shape2 = shape;
                }
                if ((i & 24576) == 0) {
                    if ((i2 & 16) == 0) {
                        cardColors2 = cardColors;
                        if (composerStartRestartGroup.changed(cardColors2)) {
                            i12 = Fields.Clip;
                        }
                        i3 |= i12;
                    } else {
                        cardColors2 = cardColors;
                    }
                    i12 = Fields.Shape;
                    i3 |= i12;
                } else {
                    cardColors2 = cardColors;
                }
                if ((196608 & i) == 0) {
                    if ((i2 & 32) == 0) {
                        cardElevation2 = cardElevation;
                        int i15 = composerStartRestartGroup.changed(cardElevation2) ? Fields.RenderEffect : 65536;
                        i3 |= i15;
                    } else {
                        cardElevation2 = cardElevation;
                    }
                    i3 |= i15;
                } else {
                    cardElevation2 = cardElevation;
                }
                i6 = i2 & 64;
                if (i6 != 0) {
                    i3 |= 1572864;
                    borderStroke2 = borderStroke;
                } else {
                    borderStroke2 = borderStroke;
                    if ((1572864 & i) == 0) {
                        if (composerStartRestartGroup.changed(borderStroke2)) {
                            i7 = 1048576;
                        } else {
                            i7 = 524288;
                        }
                        i3 |= i7;
                    }
                }
                i8 = i2 & Fields.SpotShadowColor;
                if (i8 != 0) {
                    i3 |= 12582912;
                } else if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                        i9 = 8388608;
                    } else {
                        i9 = 4194304;
                    }
                    i3 |= i9;
                }
                if ((i2 & Fields.RotationX) != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 67108864;
                    } else {
                        i10 = 33554432;
                    }
                    i3 |= i10;
                }
                if ((38347923 & i3) == 38347922 || !composerStartRestartGroup.getSkipping()) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                        if (i14 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            shape2 = CardDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            cardColors3 = CardDefaults.INSTANCE.cardColors(composerStartRestartGroup, 6);
                            i3 &= -57345;
                        } else {
                            cardColors3 = cardColors2;
                        }
                        if ((i2 & 32) != 0) {
                            cardElevationM2071cardElevationaqJV_2Y = CardDefaults.INSTANCE.m2071cardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                            i3 = (-458753) & i3;
                        } else {
                            cardElevationM2071cardElevationaqJV_2Y = cardElevation2;
                        }
                        if (i6 != 0) {
                            borderStroke3 = null;
                        } else {
                            borderStroke3 = borderStroke;
                        }
                        if (i8 != 0) {
                            int i16 = i3;
                            mutableInteractionSource2 = null;
                            borderStroke4 = borderStroke3;
                            i11 = i16;
                        } else {
                            borderStroke4 = borderStroke3;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-2024281376, i11, -1, "androidx.compose.material3.Card (Card.kt:147)");
                        }
                        composerStartRestartGroup.startReplaceGroup(1976524431);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "149@6738L39");
                        if (mutableInteractionSource2 == null) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1976525082, "CC(remember):Card.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        SurfaceKt.m2871Surfaceo_FOJdg(function0, modifier2, z2, shape2, cardColors3.m2063containerColorvNxB06k$material3_release(z2), cardColors3.m2064contentColorvNxB06k$material3_release(z2), 0.0f, cardElevationM2071cardElevationaqJV_2Y.shadowElevation$material3_release(z2, mutableInteractionSource3, composerStartRestartGroup, ((i11 >> 6) & 14) | ((i11 >> 9) & 896)).getValue().unbox-impl(), borderStroke4, mutableInteractionSource3, ComposableLambdaKt.rememberComposableLambda(776921067, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i17) {
                                ComposerKt.sourceInformation(composer2, "C161@7173L25:Card.kt#uh7d8r");
                                if ((i17 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(776921067, i17, -1, "androidx.compose.material3.Card.<anonymous> (Card.kt:161)");
                                }
                                Function3<ColumnScope, Composer, Integer, Unit> function4 = function3;
                                ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                Modifier.Companion companion = Modifier.INSTANCE;
                                MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.INSTANCE.getStart(), composer2, 0);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, companion);
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
                                function4.invoke(ColumnScopeInstance.INSTANCE, composer2, 6);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i11 & 8190) | ((i11 << 6) & 234881024), 6, 64);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        shape3 = shape2;
                        mutableInteractionSource4 = mutableInteractionSource2;
                        z3 = z2;
                        borderStroke5 = borderStroke4;
                        modifier3 = modifier2;
                        cardColors4 = cardColors3;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                        }
                        if ((i2 & 32) != 0) {
                            i3 &= -458753;
                        }
                        borderStroke4 = borderStroke;
                        cardColors3 = cardColors2;
                        cardElevationM2071cardElevationaqJV_2Y = cardElevation2;
                    }
                    i11 = i3;
                    mutableInteractionSource2 = mutableInteractionSource;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-2024281376, i11, -1, "androidx.compose.material3.Card (Card.kt:147)");
                    }
                    composerStartRestartGroup.startReplaceGroup(1976524431);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "149@6738L39");
                    if (mutableInteractionSource2 == null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1976525082, "CC(remember):Card.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    SurfaceKt.m2871Surfaceo_FOJdg(function0, modifier2, z2, shape2, cardColors3.m2063containerColorvNxB06k$material3_release(z2), cardColors3.m2064contentColorvNxB06k$material3_release(z2), 0.0f, cardElevationM2071cardElevationaqJV_2Y.shadowElevation$material3_release(z2, mutableInteractionSource3, composerStartRestartGroup, ((i11 >> 6) & 14) | ((i11 >> 9) & 896)).getValue().unbox-impl(), borderStroke4, mutableInteractionSource3, ComposableLambdaKt.rememberComposableLambda(776921067, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i17) {
                            ComposerKt.sourceInformation(composer2, "C161@7173L25:Card.kt#uh7d8r");
                            if ((i17 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(776921067, i17, -1, "androidx.compose.material3.Card.<anonymous> (Card.kt:161)");
                            }
                            Function3<ColumnScope, Composer, Integer, Unit> function4 = function3;
                            ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                            Modifier.Companion companion = Modifier.INSTANCE;
                            MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.INSTANCE.getStart(), composer2, 0);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, companion);
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
                            function4.invoke(ColumnScopeInstance.INSTANCE, composer2, 6);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i11 & 8190) | ((i11 << 6) & 234881024), 6, 64);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    shape3 = shape2;
                    mutableInteractionSource4 = mutableInteractionSource2;
                    z3 = z2;
                    borderStroke5 = borderStroke4;
                    modifier3 = modifier2;
                    cardColors4 = cardColors3;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    modifier3 = modifier2;
                    z3 = z2;
                    shape3 = shape2;
                    cardColors4 = cardColors2;
                    cardElevationM2071cardElevationaqJV_2Y = cardElevation2;
                    borderStroke5 = borderStroke2;
                    mutableInteractionSource4 = mutableInteractionSource;
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
                            CardKt.Card(function0, modifier3, z3, shape3, cardColors4, cardElevationM2071cardElevationaqJV_2Y, borderStroke5, mutableInteractionSource4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 384;
            z2 = z;
            if ((i & 3072) == 0) {
                if ((i2 & 8) == 0) {
                    shape2 = shape;
                    if (composerStartRestartGroup.changed(shape2)) {
                        i13 = Fields.CameraDistance;
                    }
                    i3 |= i13;
                } else {
                    shape2 = shape;
                }
                i13 = Fields.RotationZ;
                i3 |= i13;
            } else {
                shape2 = shape;
            }
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    cardColors2 = cardColors;
                    if (composerStartRestartGroup.changed(cardColors2)) {
                        i12 = Fields.Clip;
                    }
                    i3 |= i12;
                } else {
                    cardColors2 = cardColors;
                }
                i12 = Fields.Shape;
                i3 |= i12;
            } else {
                cardColors2 = cardColors;
            }
            if ((196608 & i) == 0) {
                if ((i2 & 32) == 0) {
                    cardElevation2 = cardElevation;
                    if (composerStartRestartGroup.changed(cardElevation2)) {
                    }
                    i3 |= i15;
                } else {
                    cardElevation2 = cardElevation;
                }
                i3 |= i15;
            } else {
                cardElevation2 = cardElevation;
            }
            i6 = i2 & 64;
            if (i6 != 0) {
                i3 |= 1572864;
                borderStroke2 = borderStroke;
            } else {
                borderStroke2 = borderStroke;
                if ((1572864 & i) == 0) {
                    if (composerStartRestartGroup.changed(borderStroke2)) {
                        i7 = 1048576;
                    } else {
                        i7 = 524288;
                    }
                    i3 |= i7;
                }
            }
            i8 = i2 & Fields.SpotShadowColor;
            if (i8 != 0) {
                i3 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                    i9 = 8388608;
                } else {
                    i9 = 4194304;
                }
                i3 |= i9;
            }
            if ((i2 & Fields.RotationX) != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = 67108864;
                } else {
                    i10 = 33554432;
                }
                i3 |= i10;
            }
            if ((38347923 & i3) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i14 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        shape2 = CardDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        cardColors3 = CardDefaults.INSTANCE.cardColors(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        cardColors3 = cardColors2;
                    }
                    if ((i2 & 32) != 0) {
                        cardElevationM2071cardElevationaqJV_2Y = CardDefaults.INSTANCE.m2071cardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                        i3 = (-458753) & i3;
                    } else {
                        cardElevationM2071cardElevationaqJV_2Y = cardElevation2;
                    }
                    if (i6 != 0) {
                        borderStroke3 = null;
                    } else {
                        borderStroke3 = borderStroke;
                    }
                    if (i8 != 0) {
                        int i17 = i3;
                        mutableInteractionSource2 = null;
                        borderStroke4 = borderStroke3;
                        i11 = i17;
                    } else {
                        borderStroke4 = borderStroke3;
                        i11 = i3;
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                } else {
                    if (i14 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        shape2 = CardDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        cardColors3 = CardDefaults.INSTANCE.cardColors(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        cardColors3 = cardColors2;
                    }
                    if ((i2 & 32) != 0) {
                        cardElevationM2071cardElevationaqJV_2Y = CardDefaults.INSTANCE.m2071cardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                        i3 = (-458753) & i3;
                    } else {
                        cardElevationM2071cardElevationaqJV_2Y = cardElevation2;
                    }
                    if (i6 != 0) {
                        borderStroke3 = null;
                    } else {
                        borderStroke3 = borderStroke;
                    }
                    if (i8 != 0) {
                        int i18 = i3;
                        mutableInteractionSource2 = null;
                        borderStroke4 = borderStroke3;
                        i11 = i18;
                    } else {
                        borderStroke4 = borderStroke3;
                        i11 = i3;
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-2024281376, i11, -1, "androidx.compose.material3.Card (Card.kt:147)");
                }
                composerStartRestartGroup.startReplaceGroup(1976524431);
                ComposerKt.sourceInformation(composerStartRestartGroup, "149@6738L39");
                if (mutableInteractionSource2 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1976525082, "CC(remember):Card.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                composerStartRestartGroup.endReplaceGroup();
                SurfaceKt.m2871Surfaceo_FOJdg(function0, modifier2, z2, shape2, cardColors3.m2063containerColorvNxB06k$material3_release(z2), cardColors3.m2064contentColorvNxB06k$material3_release(z2), 0.0f, cardElevationM2071cardElevationaqJV_2Y.shadowElevation$material3_release(z2, mutableInteractionSource3, composerStartRestartGroup, ((i11 >> 6) & 14) | ((i11 >> 9) & 896)).getValue().unbox-impl(), borderStroke4, mutableInteractionSource3, ComposableLambdaKt.rememberComposableLambda(776921067, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i19) {
                        ComposerKt.sourceInformation(composer2, "C161@7173L25:Card.kt#uh7d8r");
                        if ((i19 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(776921067, i19, -1, "androidx.compose.material3.Card.<anonymous> (Card.kt:161)");
                        }
                        Function3<ColumnScope, Composer, Integer, Unit> function4 = function3;
                        ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                        Modifier.Companion companion = Modifier.INSTANCE;
                        MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.INSTANCE.getStart(), composer2, 0);
                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                        CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, companion);
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
                        function4.invoke(ColumnScopeInstance.INSTANCE, composer2, 6);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        composer2.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i11 & 8190) | ((i11 << 6) & 234881024), 6, 64);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                shape3 = shape2;
                mutableInteractionSource4 = mutableInteractionSource2;
                z3 = z2;
                borderStroke5 = borderStroke4;
                modifier3 = modifier2;
                cardColors4 = cardColors3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i14 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        shape2 = CardDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        cardColors3 = CardDefaults.INSTANCE.cardColors(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        cardColors3 = cardColors2;
                    }
                    if ((i2 & 32) != 0) {
                        cardElevationM2071cardElevationaqJV_2Y = CardDefaults.INSTANCE.m2071cardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                        i3 = (-458753) & i3;
                    } else {
                        cardElevationM2071cardElevationaqJV_2Y = cardElevation2;
                    }
                    if (i6 != 0) {
                        borderStroke3 = null;
                    } else {
                        borderStroke3 = borderStroke;
                    }
                    if (i8 != 0) {
                        int i19 = i3;
                        mutableInteractionSource2 = null;
                        borderStroke4 = borderStroke3;
                        i11 = i19;
                    } else {
                        borderStroke4 = borderStroke3;
                        i11 = i3;
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                } else {
                    if (i14 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        shape2 = CardDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        cardColors3 = CardDefaults.INSTANCE.cardColors(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        cardColors3 = cardColors2;
                    }
                    if ((i2 & 32) != 0) {
                        cardElevationM2071cardElevationaqJV_2Y = CardDefaults.INSTANCE.m2071cardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                        i3 = (-458753) & i3;
                    } else {
                        cardElevationM2071cardElevationaqJV_2Y = cardElevation2;
                    }
                    if (i6 != 0) {
                        borderStroke3 = null;
                    } else {
                        borderStroke3 = borderStroke;
                    }
                    if (i8 != 0) {
                        int i110 = i3;
                        mutableInteractionSource2 = null;
                        borderStroke4 = borderStroke3;
                        i11 = i110;
                    } else {
                        borderStroke4 = borderStroke3;
                        i11 = i3;
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-2024281376, i11, -1, "androidx.compose.material3.Card (Card.kt:147)");
                }
                composerStartRestartGroup.startReplaceGroup(1976524431);
                ComposerKt.sourceInformation(composerStartRestartGroup, "149@6738L39");
                if (mutableInteractionSource2 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1976525082, "CC(remember):Card.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                composerStartRestartGroup.endReplaceGroup();
                SurfaceKt.m2871Surfaceo_FOJdg(function0, modifier2, z2, shape2, cardColors3.m2063containerColorvNxB06k$material3_release(z2), cardColors3.m2064contentColorvNxB06k$material3_release(z2), 0.0f, cardElevationM2071cardElevationaqJV_2Y.shadowElevation$material3_release(z2, mutableInteractionSource3, composerStartRestartGroup, ((i11 >> 6) & 14) | ((i11 >> 9) & 896)).getValue().unbox-impl(), borderStroke4, mutableInteractionSource3, ComposableLambdaKt.rememberComposableLambda(776921067, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i111) {
                        ComposerKt.sourceInformation(composer2, "C161@7173L25:Card.kt#uh7d8r");
                        if ((i111 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(776921067, i111, -1, "androidx.compose.material3.Card.<anonymous> (Card.kt:161)");
                        }
                        Function3<ColumnScope, Composer, Integer, Unit> function4 = function3;
                        ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                        Modifier.Companion companion = Modifier.INSTANCE;
                        MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.INSTANCE.getStart(), composer2, 0);
                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                        CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, companion);
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
                        function4.invoke(ColumnScopeInstance.INSTANCE, composer2, 6);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        composer2.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i11 & 8190) | ((i11 << 6) & 234881024), 6, 64);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                shape3 = shape2;
                mutableInteractionSource4 = mutableInteractionSource2;
                z3 = z2;
                borderStroke5 = borderStroke4;
                modifier3 = modifier2;
                cardColors4 = cardColors3;
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
                        CardKt.Card(function0, modifier3, z3, shape3, cardColors4, cardElevationM2071cardElevationaqJV_2Y, borderStroke5, mutableInteractionSource4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        modifier2 = modifier;
        i4 = i2 & 4;
        if (i4 != 0) {
            if ((i & 384) == 0) {
                z2 = z;
                if (composerStartRestartGroup.changed(z2)) {
                    i5 = Fields.RotationX;
                } else {
                    i5 = Fields.SpotShadowColor;
                }
                i3 |= i5;
            }
            if ((i & 3072) == 0) {
                if ((i2 & 8) == 0) {
                    shape2 = shape;
                    if (composerStartRestartGroup.changed(shape2)) {
                        i13 = Fields.CameraDistance;
                    }
                    i3 |= i13;
                } else {
                    shape2 = shape;
                }
                i13 = Fields.RotationZ;
                i3 |= i13;
            } else {
                shape2 = shape;
            }
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    cardColors2 = cardColors;
                    if (composerStartRestartGroup.changed(cardColors2)) {
                        i12 = Fields.Clip;
                    }
                    i3 |= i12;
                } else {
                    cardColors2 = cardColors;
                }
                i12 = Fields.Shape;
                i3 |= i12;
            } else {
                cardColors2 = cardColors;
            }
            if ((196608 & i) == 0) {
                if ((i2 & 32) == 0) {
                    cardElevation2 = cardElevation;
                    if (composerStartRestartGroup.changed(cardElevation2)) {
                    }
                    i3 |= i15;
                } else {
                    cardElevation2 = cardElevation;
                }
                i3 |= i15;
            } else {
                cardElevation2 = cardElevation;
            }
            i6 = i2 & 64;
            if (i6 != 0) {
                i3 |= 1572864;
                borderStroke2 = borderStroke;
            } else {
                borderStroke2 = borderStroke;
                if ((1572864 & i) == 0) {
                    if (composerStartRestartGroup.changed(borderStroke2)) {
                        i7 = 1048576;
                    } else {
                        i7 = 524288;
                    }
                    i3 |= i7;
                }
            }
            i8 = i2 & Fields.SpotShadowColor;
            if (i8 != 0) {
                i3 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                    i9 = 8388608;
                } else {
                    i9 = 4194304;
                }
                i3 |= i9;
            }
            if ((i2 & Fields.RotationX) != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = 67108864;
                } else {
                    i10 = 33554432;
                }
                i3 |= i10;
            }
            if ((38347923 & i3) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i14 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        shape2 = CardDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        cardColors3 = CardDefaults.INSTANCE.cardColors(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        cardColors3 = cardColors2;
                    }
                    if ((i2 & 32) != 0) {
                        cardElevationM2071cardElevationaqJV_2Y = CardDefaults.INSTANCE.m2071cardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                        i3 = (-458753) & i3;
                    } else {
                        cardElevationM2071cardElevationaqJV_2Y = cardElevation2;
                    }
                    if (i6 != 0) {
                        borderStroke3 = null;
                    } else {
                        borderStroke3 = borderStroke;
                    }
                    if (i8 != 0) {
                        int i111 = i3;
                        mutableInteractionSource2 = null;
                        borderStroke4 = borderStroke3;
                        i11 = i111;
                    } else {
                        borderStroke4 = borderStroke3;
                        i11 = i3;
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                } else {
                    if (i14 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        shape2 = CardDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        cardColors3 = CardDefaults.INSTANCE.cardColors(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        cardColors3 = cardColors2;
                    }
                    if ((i2 & 32) != 0) {
                        cardElevationM2071cardElevationaqJV_2Y = CardDefaults.INSTANCE.m2071cardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                        i3 = (-458753) & i3;
                    } else {
                        cardElevationM2071cardElevationaqJV_2Y = cardElevation2;
                    }
                    if (i6 != 0) {
                        borderStroke3 = null;
                    } else {
                        borderStroke3 = borderStroke;
                    }
                    if (i8 != 0) {
                        int i112 = i3;
                        mutableInteractionSource2 = null;
                        borderStroke4 = borderStroke3;
                        i11 = i112;
                    } else {
                        borderStroke4 = borderStroke3;
                        i11 = i3;
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-2024281376, i11, -1, "androidx.compose.material3.Card (Card.kt:147)");
                }
                composerStartRestartGroup.startReplaceGroup(1976524431);
                ComposerKt.sourceInformation(composerStartRestartGroup, "149@6738L39");
                if (mutableInteractionSource2 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1976525082, "CC(remember):Card.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                composerStartRestartGroup.endReplaceGroup();
                SurfaceKt.m2871Surfaceo_FOJdg(function0, modifier2, z2, shape2, cardColors3.m2063containerColorvNxB06k$material3_release(z2), cardColors3.m2064contentColorvNxB06k$material3_release(z2), 0.0f, cardElevationM2071cardElevationaqJV_2Y.shadowElevation$material3_release(z2, mutableInteractionSource3, composerStartRestartGroup, ((i11 >> 6) & 14) | ((i11 >> 9) & 896)).getValue().unbox-impl(), borderStroke4, mutableInteractionSource3, ComposableLambdaKt.rememberComposableLambda(776921067, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i113) {
                        ComposerKt.sourceInformation(composer2, "C161@7173L25:Card.kt#uh7d8r");
                        if ((i113 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(776921067, i113, -1, "androidx.compose.material3.Card.<anonymous> (Card.kt:161)");
                        }
                        Function3<ColumnScope, Composer, Integer, Unit> function4 = function3;
                        ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                        Modifier.Companion companion = Modifier.INSTANCE;
                        MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.INSTANCE.getStart(), composer2, 0);
                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                        CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, companion);
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
                        function4.invoke(ColumnScopeInstance.INSTANCE, composer2, 6);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        composer2.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i11 & 8190) | ((i11 << 6) & 234881024), 6, 64);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                shape3 = shape2;
                mutableInteractionSource4 = mutableInteractionSource2;
                z3 = z2;
                borderStroke5 = borderStroke4;
                modifier3 = modifier2;
                cardColors4 = cardColors3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i14 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        shape2 = CardDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        cardColors3 = CardDefaults.INSTANCE.cardColors(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        cardColors3 = cardColors2;
                    }
                    if ((i2 & 32) != 0) {
                        cardElevationM2071cardElevationaqJV_2Y = CardDefaults.INSTANCE.m2071cardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                        i3 = (-458753) & i3;
                    } else {
                        cardElevationM2071cardElevationaqJV_2Y = cardElevation2;
                    }
                    if (i6 != 0) {
                        borderStroke3 = null;
                    } else {
                        borderStroke3 = borderStroke;
                    }
                    if (i8 != 0) {
                        int i113 = i3;
                        mutableInteractionSource2 = null;
                        borderStroke4 = borderStroke3;
                        i11 = i113;
                    } else {
                        borderStroke4 = borderStroke3;
                        i11 = i3;
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                } else {
                    if (i14 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        shape2 = CardDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        cardColors3 = CardDefaults.INSTANCE.cardColors(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        cardColors3 = cardColors2;
                    }
                    if ((i2 & 32) != 0) {
                        cardElevationM2071cardElevationaqJV_2Y = CardDefaults.INSTANCE.m2071cardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                        i3 = (-458753) & i3;
                    } else {
                        cardElevationM2071cardElevationaqJV_2Y = cardElevation2;
                    }
                    if (i6 != 0) {
                        borderStroke3 = null;
                    } else {
                        borderStroke3 = borderStroke;
                    }
                    if (i8 != 0) {
                        int i114 = i3;
                        mutableInteractionSource2 = null;
                        borderStroke4 = borderStroke3;
                        i11 = i114;
                    } else {
                        borderStroke4 = borderStroke3;
                        i11 = i3;
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-2024281376, i11, -1, "androidx.compose.material3.Card (Card.kt:147)");
                }
                composerStartRestartGroup.startReplaceGroup(1976524431);
                ComposerKt.sourceInformation(composerStartRestartGroup, "149@6738L39");
                if (mutableInteractionSource2 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1976525082, "CC(remember):Card.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                composerStartRestartGroup.endReplaceGroup();
                SurfaceKt.m2871Surfaceo_FOJdg(function0, modifier2, z2, shape2, cardColors3.m2063containerColorvNxB06k$material3_release(z2), cardColors3.m2064contentColorvNxB06k$material3_release(z2), 0.0f, cardElevationM2071cardElevationaqJV_2Y.shadowElevation$material3_release(z2, mutableInteractionSource3, composerStartRestartGroup, ((i11 >> 6) & 14) | ((i11 >> 9) & 896)).getValue().unbox-impl(), borderStroke4, mutableInteractionSource3, ComposableLambdaKt.rememberComposableLambda(776921067, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i115) {
                        ComposerKt.sourceInformation(composer2, "C161@7173L25:Card.kt#uh7d8r");
                        if ((i115 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(776921067, i115, -1, "androidx.compose.material3.Card.<anonymous> (Card.kt:161)");
                        }
                        Function3<ColumnScope, Composer, Integer, Unit> function4 = function3;
                        ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                        Modifier.Companion companion = Modifier.INSTANCE;
                        MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.INSTANCE.getStart(), composer2, 0);
                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                        CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, companion);
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
                        function4.invoke(ColumnScopeInstance.INSTANCE, composer2, 6);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        composer2.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i11 & 8190) | ((i11 << 6) & 234881024), 6, 64);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                shape3 = shape2;
                mutableInteractionSource4 = mutableInteractionSource2;
                z3 = z2;
                borderStroke5 = borderStroke4;
                modifier3 = modifier2;
                cardColors4 = cardColors3;
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
                        CardKt.Card(function0, modifier3, z3, shape3, cardColors4, cardElevationM2071cardElevationaqJV_2Y, borderStroke5, mutableInteractionSource4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        z2 = z;
        if ((i & 3072) == 0) {
            if ((i2 & 8) == 0) {
                shape2 = shape;
                if (composerStartRestartGroup.changed(shape2)) {
                    i13 = Fields.CameraDistance;
                }
                i3 |= i13;
            } else {
                shape2 = shape;
            }
            i13 = Fields.RotationZ;
            i3 |= i13;
        } else {
            shape2 = shape;
        }
        if ((i & 24576) == 0) {
            if ((i2 & 16) == 0) {
                cardColors2 = cardColors;
                if (composerStartRestartGroup.changed(cardColors2)) {
                    i12 = Fields.Clip;
                }
                i3 |= i12;
            } else {
                cardColors2 = cardColors;
            }
            i12 = Fields.Shape;
            i3 |= i12;
        } else {
            cardColors2 = cardColors;
        }
        if ((196608 & i) == 0) {
            if ((i2 & 32) == 0) {
                cardElevation2 = cardElevation;
                if (composerStartRestartGroup.changed(cardElevation2)) {
                }
                i3 |= i15;
            } else {
                cardElevation2 = cardElevation;
            }
            i3 |= i15;
        } else {
            cardElevation2 = cardElevation;
        }
        i6 = i2 & 64;
        if (i6 != 0) {
            i3 |= 1572864;
            borderStroke2 = borderStroke;
        } else {
            borderStroke2 = borderStroke;
            if ((1572864 & i) == 0) {
                if (composerStartRestartGroup.changed(borderStroke2)) {
                    i7 = 1048576;
                } else {
                    i7 = 524288;
                }
                i3 |= i7;
            }
        }
        i8 = i2 & Fields.SpotShadowColor;
        if (i8 != 0) {
            i3 |= 12582912;
        } else if ((i & 12582912) == 0) {
            if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                i9 = 8388608;
            } else {
                i9 = 4194304;
            }
            i3 |= i9;
        }
        if ((i2 & Fields.RotationX) != 0) {
            i3 |= 100663296;
        } else if ((i & 100663296) == 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i10 = 67108864;
            } else {
                i10 = 33554432;
            }
            i3 |= i10;
        }
        if ((38347923 & i3) == 38347922) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i14 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    shape2 = CardDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    cardColors3 = CardDefaults.INSTANCE.cardColors(composerStartRestartGroup, 6);
                    i3 &= -57345;
                } else {
                    cardColors3 = cardColors2;
                }
                if ((i2 & 32) != 0) {
                    cardElevationM2071cardElevationaqJV_2Y = CardDefaults.INSTANCE.m2071cardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                    i3 = (-458753) & i3;
                } else {
                    cardElevationM2071cardElevationaqJV_2Y = cardElevation2;
                }
                if (i6 != 0) {
                    borderStroke3 = null;
                } else {
                    borderStroke3 = borderStroke;
                }
                if (i8 != 0) {
                    int i115 = i3;
                    mutableInteractionSource2 = null;
                    borderStroke4 = borderStroke3;
                    i11 = i115;
                } else {
                    borderStroke4 = borderStroke3;
                    i11 = i3;
                    mutableInteractionSource2 = mutableInteractionSource;
                }
            } else {
                if (i14 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    shape2 = CardDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    cardColors3 = CardDefaults.INSTANCE.cardColors(composerStartRestartGroup, 6);
                    i3 &= -57345;
                } else {
                    cardColors3 = cardColors2;
                }
                if ((i2 & 32) != 0) {
                    cardElevationM2071cardElevationaqJV_2Y = CardDefaults.INSTANCE.m2071cardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                    i3 = (-458753) & i3;
                } else {
                    cardElevationM2071cardElevationaqJV_2Y = cardElevation2;
                }
                if (i6 != 0) {
                    borderStroke3 = null;
                } else {
                    borderStroke3 = borderStroke;
                }
                if (i8 != 0) {
                    int i116 = i3;
                    mutableInteractionSource2 = null;
                    borderStroke4 = borderStroke3;
                    i11 = i116;
                } else {
                    borderStroke4 = borderStroke3;
                    i11 = i3;
                    mutableInteractionSource2 = mutableInteractionSource;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-2024281376, i11, -1, "androidx.compose.material3.Card (Card.kt:147)");
            }
            composerStartRestartGroup.startReplaceGroup(1976524431);
            ComposerKt.sourceInformation(composerStartRestartGroup, "149@6738L39");
            if (mutableInteractionSource2 == null) {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1976525082, "CC(remember):Card.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue;
            } else {
                mutableInteractionSource3 = mutableInteractionSource2;
            }
            composerStartRestartGroup.endReplaceGroup();
            SurfaceKt.m2871Surfaceo_FOJdg(function0, modifier2, z2, shape2, cardColors3.m2063containerColorvNxB06k$material3_release(z2), cardColors3.m2064contentColorvNxB06k$material3_release(z2), 0.0f, cardElevationM2071cardElevationaqJV_2Y.shadowElevation$material3_release(z2, mutableInteractionSource3, composerStartRestartGroup, ((i11 >> 6) & 14) | ((i11 >> 9) & 896)).getValue().unbox-impl(), borderStroke4, mutableInteractionSource3, ComposableLambdaKt.rememberComposableLambda(776921067, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i117) {
                    ComposerKt.sourceInformation(composer2, "C161@7173L25:Card.kt#uh7d8r");
                    if ((i117 & 3) == 2 && composer2.getSkipping()) {
                        composer2.skipToGroupEnd();
                        return;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(776921067, i117, -1, "androidx.compose.material3.Card.<anonymous> (Card.kt:161)");
                    }
                    Function3<ColumnScope, Composer, Integer, Unit> function4 = function3;
                    ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                    Modifier.Companion companion = Modifier.INSTANCE;
                    MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.INSTANCE.getStart(), composer2, 0);
                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                    CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, companion);
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
                    function4.invoke(ColumnScopeInstance.INSTANCE, composer2, 6);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    composer2.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i11 & 8190) | ((i11 << 6) & 234881024), 6, 64);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            shape3 = shape2;
            mutableInteractionSource4 = mutableInteractionSource2;
            z3 = z2;
            borderStroke5 = borderStroke4;
            modifier3 = modifier2;
            cardColors4 = cardColors3;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i14 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    shape2 = CardDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    cardColors3 = CardDefaults.INSTANCE.cardColors(composerStartRestartGroup, 6);
                    i3 &= -57345;
                } else {
                    cardColors3 = cardColors2;
                }
                if ((i2 & 32) != 0) {
                    cardElevationM2071cardElevationaqJV_2Y = CardDefaults.INSTANCE.m2071cardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                    i3 = (-458753) & i3;
                } else {
                    cardElevationM2071cardElevationaqJV_2Y = cardElevation2;
                }
                if (i6 != 0) {
                    borderStroke3 = null;
                } else {
                    borderStroke3 = borderStroke;
                }
                if (i8 != 0) {
                    int i117 = i3;
                    mutableInteractionSource2 = null;
                    borderStroke4 = borderStroke3;
                    i11 = i117;
                } else {
                    borderStroke4 = borderStroke3;
                    i11 = i3;
                    mutableInteractionSource2 = mutableInteractionSource;
                }
            } else {
                if (i14 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    shape2 = CardDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    cardColors3 = CardDefaults.INSTANCE.cardColors(composerStartRestartGroup, 6);
                    i3 &= -57345;
                } else {
                    cardColors3 = cardColors2;
                }
                if ((i2 & 32) != 0) {
                    cardElevationM2071cardElevationaqJV_2Y = CardDefaults.INSTANCE.m2071cardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                    i3 = (-458753) & i3;
                } else {
                    cardElevationM2071cardElevationaqJV_2Y = cardElevation2;
                }
                if (i6 != 0) {
                    borderStroke3 = null;
                } else {
                    borderStroke3 = borderStroke;
                }
                if (i8 != 0) {
                    int i118 = i3;
                    mutableInteractionSource2 = null;
                    borderStroke4 = borderStroke3;
                    i11 = i118;
                } else {
                    borderStroke4 = borderStroke3;
                    i11 = i3;
                    mutableInteractionSource2 = mutableInteractionSource;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-2024281376, i11, -1, "androidx.compose.material3.Card (Card.kt:147)");
            }
            composerStartRestartGroup.startReplaceGroup(1976524431);
            ComposerKt.sourceInformation(composerStartRestartGroup, "149@6738L39");
            if (mutableInteractionSource2 == null) {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1976525082, "CC(remember):Card.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue;
            } else {
                mutableInteractionSource3 = mutableInteractionSource2;
            }
            composerStartRestartGroup.endReplaceGroup();
            SurfaceKt.m2871Surfaceo_FOJdg(function0, modifier2, z2, shape2, cardColors3.m2063containerColorvNxB06k$material3_release(z2), cardColors3.m2064contentColorvNxB06k$material3_release(z2), 0.0f, cardElevationM2071cardElevationaqJV_2Y.shadowElevation$material3_release(z2, mutableInteractionSource3, composerStartRestartGroup, ((i11 >> 6) & 14) | ((i11 >> 9) & 896)).getValue().unbox-impl(), borderStroke4, mutableInteractionSource3, ComposableLambdaKt.rememberComposableLambda(776921067, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i119) {
                    ComposerKt.sourceInformation(composer2, "C161@7173L25:Card.kt#uh7d8r");
                    if ((i119 & 3) == 2 && composer2.getSkipping()) {
                        composer2.skipToGroupEnd();
                        return;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(776921067, i119, -1, "androidx.compose.material3.Card.<anonymous> (Card.kt:161)");
                    }
                    Function3<ColumnScope, Composer, Integer, Unit> function4 = function3;
                    ComposerKt.sourceInformationMarkerStart(composer2, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                    Modifier.Companion companion = Modifier.INSTANCE;
                    MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.INSTANCE.getStart(), composer2, 0);
                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                    CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, companion);
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
                    function4.invoke(ColumnScopeInstance.INSTANCE, composer2, 6);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    composer2.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i11 & 8190) | ((i11 << 6) & 234881024), 6, 64);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            shape3 = shape2;
            mutableInteractionSource4 = mutableInteractionSource2;
            z3 = z2;
            borderStroke5 = borderStroke4;
            modifier3 = modifier2;
            cardColors4 = cardColors3;
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
                    CardKt.Card(function0, modifier3, z3, shape3, cardColors4, cardElevationM2071cardElevationaqJV_2Y, borderStroke5, mutableInteractionSource4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void ElevatedCard(Modifier modifier, Shape shape, CardColors cardColors, CardElevation cardElevation, final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2) {
        Modifier modifier2;
        int i3;
        Shape shape2;
        CardColors cardColors2;
        CardElevation cardElevation2;
        Modifier.Companion companion;
        Shape elevatedShape;
        CardColors cardColorsElevatedCardColors;
        int i4;
        final CardElevation cardElevationM2073elevatedCardElevationaqJV_2Y;
        int i5;
        int i6;
        Composer composerStartRestartGroup = composer.startRestartGroup(895940201);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(ElevatedCard)P(3,4!1,2)195@8668L13,196@8721L20,197@8787L23,200@8868L168:Card.kt#uh7d8r");
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
                shape2 = shape;
                int i8 = composerStartRestartGroup.changed(shape2) ? 32 : 16;
                i3 |= i8;
            } else {
                shape2 = shape;
            }
            i3 |= i8;
        } else {
            shape2 = shape;
        }
        if ((i & 384) == 0) {
            if ((i2 & 4) == 0) {
                cardColors2 = cardColors;
                if (composerStartRestartGroup.changed(cardColors2)) {
                    i6 = Fields.RotationX;
                }
                i3 |= i6;
            } else {
                cardColors2 = cardColors;
            }
            i6 = Fields.SpotShadowColor;
            i3 |= i6;
        } else {
            cardColors2 = cardColors;
        }
        if ((i & 3072) == 0) {
            if ((i2 & 8) == 0) {
                cardElevation2 = cardElevation;
                if (composerStartRestartGroup.changed(cardElevation2)) {
                    i5 = Fields.CameraDistance;
                }
                i3 |= i5;
            } else {
                cardElevation2 = cardElevation;
            }
            i5 = Fields.RotationZ;
            i3 |= i5;
        } else {
            cardElevation2 = cardElevation;
        }
        if ((i2 & 16) != 0) {
            i3 |= 24576;
        } else if ((i & 24576) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function3) ? Fields.Clip : Fields.Shape;
        }
        if ((i3 & 9363) != 9362 || !composerStartRestartGroup.getSkipping()) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) == 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                companion = i7 != 0 ? Modifier.INSTANCE : modifier2;
                if ((i2 & 2) != 0) {
                    elevatedShape = CardDefaults.INSTANCE.getElevatedShape(composerStartRestartGroup, 6);
                    i3 &= -113;
                } else {
                    elevatedShape = shape2;
                }
                if ((i2 & 4) != 0) {
                    cardColorsElevatedCardColors = CardDefaults.INSTANCE.elevatedCardColors(composerStartRestartGroup, 6);
                    i3 &= -897;
                } else {
                    cardColorsElevatedCardColors = cardColors2;
                }
                if ((i2 & 8) != 0) {
                    i4 = i3 & (-7169);
                    cardElevationM2073elevatedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2073elevatedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(895940201, i4, -1, "androidx.compose.material3.ElevatedCard (Card.kt:200)");
                }
                Card(companion, elevatedShape, cardColorsElevatedCardColors, cardElevationM2073elevatedCardElevationaqJV_2Y, null, function3, composerStartRestartGroup, (i4 & 14) | 24576 | (i4 & 112) | (i4 & 896) | (i4 & 7168) | ((i4 << 3) & 458752), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            } else {
                composerStartRestartGroup.skipToGroupEnd();
                if ((i2 & 2) != 0) {
                    i3 &= -113;
                }
                if ((i2 & 4) != 0) {
                    i3 &= -897;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                }
                companion = modifier2;
                elevatedShape = shape2;
                cardColorsElevatedCardColors = cardColors2;
            }
            i4 = i3;
            cardElevationM2073elevatedCardElevationaqJV_2Y = cardElevation2;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(895940201, i4, -1, "androidx.compose.material3.ElevatedCard (Card.kt:200)");
            }
            Card(companion, elevatedShape, cardColorsElevatedCardColors, cardElevationM2073elevatedCardElevationaqJV_2Y, null, function3, composerStartRestartGroup, (i4 & 14) | 24576 | (i4 & 112) | (i4 & 896) | (i4 & 7168) | ((i4 << 3) & 458752), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.skipToGroupEnd();
            companion = modifier2;
            elevatedShape = shape2;
            cardColorsElevatedCardColors = cardColors2;
            cardElevationM2073elevatedCardElevationaqJV_2Y = cardElevation2;
        }
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier3 = companion;
            final Shape shape3 = elevatedShape;
            final CardColors cardColors3 = cardColorsElevatedCardColors;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i9) {
                    CardKt.ElevatedCard(modifier3, shape3, cardColors3, cardElevationM2073elevatedCardElevationaqJV_2Y, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void ElevatedCard(final Function0<Unit> function0, Modifier modifier, boolean z, Shape shape, CardColors cardColors, CardElevation cardElevation, MutableInteractionSource mutableInteractionSource, final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2) {
        int i3;
        Modifier modifier2;
        int i4;
        boolean z2;
        int i5;
        Shape elevatedShape;
        CardColors cardColors2;
        CardElevation cardElevationM2073elevatedCardElevationaqJV_2Y;
        int i6;
        MutableInteractionSource mutableInteractionSource2;
        int i7;
        int i8;
        CardColors cardColorsElevatedCardColors;
        MutableInteractionSource mutableInteractionSource3;
        int i9;
        CardElevation cardElevation2;
        final CardElevation cardElevation3;
        final boolean z3;
        final MutableInteractionSource mutableInteractionSource4;
        final Shape shape2;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i10;
        int i11;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1850977784);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(ElevatedCard)P(6,5,3,7!1,2,4)248@11071L13,249@11124L20,250@11190L23,254@11328L269:Card.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changedInstance(function0) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i12 = i2 & 2;
        if (i12 == 0) {
            if ((i & 48) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            i4 = i2 & 4;
            if (i4 != 0) {
                if ((i & 384) == 0) {
                    z2 = z;
                    if (composerStartRestartGroup.changed(z2)) {
                        i5 = Fields.RotationX;
                    } else {
                        i5 = Fields.SpotShadowColor;
                    }
                    i3 |= i5;
                }
                if ((i & 3072) == 0) {
                    if ((i2 & 8) == 0) {
                        elevatedShape = shape;
                        if (composerStartRestartGroup.changed(elevatedShape)) {
                            i11 = Fields.CameraDistance;
                        }
                        i3 |= i11;
                    } else {
                        elevatedShape = shape;
                    }
                    i11 = Fields.RotationZ;
                    i3 |= i11;
                } else {
                    elevatedShape = shape;
                }
                if ((i & 24576) == 0) {
                    if ((i2 & 16) == 0) {
                        cardColors2 = cardColors;
                        if (composerStartRestartGroup.changed(cardColors2)) {
                            i10 = Fields.Clip;
                        }
                        i3 |= i10;
                    } else {
                        cardColors2 = cardColors;
                    }
                    i10 = Fields.Shape;
                    i3 |= i10;
                } else {
                    cardColors2 = cardColors;
                }
                if ((196608 & i) == 0) {
                    if ((i2 & 32) == 0) {
                        cardElevationM2073elevatedCardElevationaqJV_2Y = cardElevation;
                        int i13 = composerStartRestartGroup.changed(cardElevationM2073elevatedCardElevationaqJV_2Y) ? Fields.RenderEffect : 65536;
                        i3 |= i13;
                    } else {
                        cardElevationM2073elevatedCardElevationaqJV_2Y = cardElevation;
                    }
                    i3 |= i13;
                } else {
                    cardElevationM2073elevatedCardElevationaqJV_2Y = cardElevation;
                }
                i6 = i2 & 64;
                if (i6 != 0) {
                    i3 |= 1572864;
                    mutableInteractionSource2 = mutableInteractionSource;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                    if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(mutableInteractionSource2)) {
                            i7 = 1048576;
                        } else {
                            i7 = 524288;
                        }
                        i3 |= i7;
                    }
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    i3 |= 12582912;
                } else if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i8 = 8388608;
                    } else {
                        i8 = 4194304;
                    }
                    i3 |= i8;
                }
                if ((4793491 & i3) == 4793490 || !composerStartRestartGroup.getSkipping()) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                        if (i12 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            elevatedShape = CardDefaults.INSTANCE.getElevatedShape(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            cardColorsElevatedCardColors = CardDefaults.INSTANCE.elevatedCardColors(composerStartRestartGroup, 6);
                            i3 &= -57345;
                        } else {
                            cardColorsElevatedCardColors = cardColors2;
                        }
                        if ((i2 & 32) != 0) {
                            i3 &= -458753;
                            cardElevationM2073elevatedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2073elevatedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource;
                        }
                        i9 = i3;
                        cardElevation2 = cardElevationM2073elevatedCardElevationaqJV_2Y;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                        }
                        if ((i2 & 32) != 0) {
                            i3 &= -458753;
                        }
                        i9 = i3;
                        cardColorsElevatedCardColors = cardColors2;
                        cardElevation2 = cardElevationM2073elevatedCardElevationaqJV_2Y;
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1850977784, i9, -1, "androidx.compose.material3.ElevatedCard (Card.kt:254)");
                    }
                    int i14 = (i9 & 14) | 1572864 | (i9 & 112) | (i9 & 896) | (i9 & 7168) | (57344 & i9) | (458752 & i9);
                    int i15 = i9 << 3;
                    Card(function0, modifier2, z2, elevatedShape, cardColorsElevatedCardColors, cardElevation2, null, mutableInteractionSource3, function3, composerStartRestartGroup, i14 | (29360128 & i15) | (i15 & 234881024), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    cardColors2 = cardColorsElevatedCardColors;
                    cardElevation3 = cardElevation2;
                    z3 = z2;
                    mutableInteractionSource4 = mutableInteractionSource3;
                    shape2 = elevatedShape;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    z3 = z2;
                    shape2 = elevatedShape;
                    cardElevation3 = cardElevationM2073elevatedCardElevationaqJV_2Y;
                    mutableInteractionSource4 = mutableInteractionSource2;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier3 = modifier2;
                    final CardColors cardColors3 = cardColors2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i16) {
                            CardKt.ElevatedCard(function0, modifier3, z3, shape2, cardColors3, cardElevation3, mutableInteractionSource4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 384;
            z2 = z;
            if ((i & 3072) == 0) {
                if ((i2 & 8) == 0) {
                    elevatedShape = shape;
                    if (composerStartRestartGroup.changed(elevatedShape)) {
                        i11 = Fields.CameraDistance;
                    }
                    i3 |= i11;
                } else {
                    elevatedShape = shape;
                }
                i11 = Fields.RotationZ;
                i3 |= i11;
            } else {
                elevatedShape = shape;
            }
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    cardColors2 = cardColors;
                    if (composerStartRestartGroup.changed(cardColors2)) {
                        i10 = Fields.Clip;
                    }
                    i3 |= i10;
                } else {
                    cardColors2 = cardColors;
                }
                i10 = Fields.Shape;
                i3 |= i10;
            } else {
                cardColors2 = cardColors;
            }
            if ((196608 & i) == 0) {
                if ((i2 & 32) == 0) {
                    cardElevationM2073elevatedCardElevationaqJV_2Y = cardElevation;
                    if (composerStartRestartGroup.changed(cardElevationM2073elevatedCardElevationaqJV_2Y)) {
                    }
                    i3 |= i13;
                } else {
                    cardElevationM2073elevatedCardElevationaqJV_2Y = cardElevation;
                }
                i3 |= i13;
            } else {
                cardElevationM2073elevatedCardElevationaqJV_2Y = cardElevation;
            }
            i6 = i2 & 64;
            if (i6 != 0) {
                i3 |= 1572864;
                mutableInteractionSource2 = mutableInteractionSource;
            } else {
                mutableInteractionSource2 = mutableInteractionSource;
                if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(mutableInteractionSource2)) {
                        i7 = 1048576;
                    } else {
                        i7 = 524288;
                    }
                    i3 |= i7;
                }
            }
            if ((i2 & Fields.SpotShadowColor) != 0) {
                i3 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i8 = 8388608;
                } else {
                    i8 = 4194304;
                }
                i3 |= i8;
            }
            if ((4793491 & i3) == 4793490) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        elevatedShape = CardDefaults.INSTANCE.getElevatedShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        cardColorsElevatedCardColors = CardDefaults.INSTANCE.elevatedCardColors(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        cardColorsElevatedCardColors = cardColors2;
                    }
                    if ((i2 & 32) != 0) {
                        i3 &= -458753;
                        cardElevationM2073elevatedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2073elevatedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource;
                    }
                    i9 = i3;
                    cardElevation2 = cardElevationM2073elevatedCardElevationaqJV_2Y;
                } else {
                    if (i12 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        elevatedShape = CardDefaults.INSTANCE.getElevatedShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        cardColorsElevatedCardColors = CardDefaults.INSTANCE.elevatedCardColors(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        cardColorsElevatedCardColors = cardColors2;
                    }
                    if ((i2 & 32) != 0) {
                        i3 &= -458753;
                        cardElevationM2073elevatedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2073elevatedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource;
                    }
                    i9 = i3;
                    cardElevation2 = cardElevationM2073elevatedCardElevationaqJV_2Y;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1850977784, i9, -1, "androidx.compose.material3.ElevatedCard (Card.kt:254)");
                }
                int i16 = (i9 & 14) | 1572864 | (i9 & 112) | (i9 & 896) | (i9 & 7168) | (57344 & i9) | (458752 & i9);
                int i17 = i9 << 3;
                Card(function0, modifier2, z2, elevatedShape, cardColorsElevatedCardColors, cardElevation2, null, mutableInteractionSource3, function3, composerStartRestartGroup, i16 | (29360128 & i17) | (i17 & 234881024), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                cardColors2 = cardColorsElevatedCardColors;
                cardElevation3 = cardElevation2;
                z3 = z2;
                mutableInteractionSource4 = mutableInteractionSource3;
                shape2 = elevatedShape;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        elevatedShape = CardDefaults.INSTANCE.getElevatedShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        cardColorsElevatedCardColors = CardDefaults.INSTANCE.elevatedCardColors(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        cardColorsElevatedCardColors = cardColors2;
                    }
                    if ((i2 & 32) != 0) {
                        i3 &= -458753;
                        cardElevationM2073elevatedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2073elevatedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource;
                    }
                    i9 = i3;
                    cardElevation2 = cardElevationM2073elevatedCardElevationaqJV_2Y;
                } else {
                    if (i12 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        elevatedShape = CardDefaults.INSTANCE.getElevatedShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        cardColorsElevatedCardColors = CardDefaults.INSTANCE.elevatedCardColors(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        cardColorsElevatedCardColors = cardColors2;
                    }
                    if ((i2 & 32) != 0) {
                        i3 &= -458753;
                        cardElevationM2073elevatedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2073elevatedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource;
                    }
                    i9 = i3;
                    cardElevation2 = cardElevationM2073elevatedCardElevationaqJV_2Y;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1850977784, i9, -1, "androidx.compose.material3.ElevatedCard (Card.kt:254)");
                }
                int i18 = (i9 & 14) | 1572864 | (i9 & 112) | (i9 & 896) | (i9 & 7168) | (57344 & i9) | (458752 & i9);
                int i19 = i9 << 3;
                Card(function0, modifier2, z2, elevatedShape, cardColorsElevatedCardColors, cardElevation2, null, mutableInteractionSource3, function3, composerStartRestartGroup, i18 | (29360128 & i19) | (i19 & 234881024), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                cardColors2 = cardColorsElevatedCardColors;
                cardElevation3 = cardElevation2;
                z3 = z2;
                mutableInteractionSource4 = mutableInteractionSource3;
                shape2 = elevatedShape;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier4 = modifier2;
                final CardColors cardColors4 = cardColors2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i110) {
                        CardKt.ElevatedCard(function0, modifier4, z3, shape2, cardColors4, cardElevation3, mutableInteractionSource4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        modifier2 = modifier;
        i4 = i2 & 4;
        if (i4 != 0) {
            if ((i & 384) == 0) {
                z2 = z;
                if (composerStartRestartGroup.changed(z2)) {
                    i5 = Fields.RotationX;
                } else {
                    i5 = Fields.SpotShadowColor;
                }
                i3 |= i5;
            }
            if ((i & 3072) == 0) {
                if ((i2 & 8) == 0) {
                    elevatedShape = shape;
                    if (composerStartRestartGroup.changed(elevatedShape)) {
                        i11 = Fields.CameraDistance;
                    }
                    i3 |= i11;
                } else {
                    elevatedShape = shape;
                }
                i11 = Fields.RotationZ;
                i3 |= i11;
            } else {
                elevatedShape = shape;
            }
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    cardColors2 = cardColors;
                    if (composerStartRestartGroup.changed(cardColors2)) {
                        i10 = Fields.Clip;
                    }
                    i3 |= i10;
                } else {
                    cardColors2 = cardColors;
                }
                i10 = Fields.Shape;
                i3 |= i10;
            } else {
                cardColors2 = cardColors;
            }
            if ((196608 & i) == 0) {
                if ((i2 & 32) == 0) {
                    cardElevationM2073elevatedCardElevationaqJV_2Y = cardElevation;
                    if (composerStartRestartGroup.changed(cardElevationM2073elevatedCardElevationaqJV_2Y)) {
                    }
                    i3 |= i13;
                } else {
                    cardElevationM2073elevatedCardElevationaqJV_2Y = cardElevation;
                }
                i3 |= i13;
            } else {
                cardElevationM2073elevatedCardElevationaqJV_2Y = cardElevation;
            }
            i6 = i2 & 64;
            if (i6 != 0) {
                i3 |= 1572864;
                mutableInteractionSource2 = mutableInteractionSource;
            } else {
                mutableInteractionSource2 = mutableInteractionSource;
                if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(mutableInteractionSource2)) {
                        i7 = 1048576;
                    } else {
                        i7 = 524288;
                    }
                    i3 |= i7;
                }
            }
            if ((i2 & Fields.SpotShadowColor) != 0) {
                i3 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i8 = 8388608;
                } else {
                    i8 = 4194304;
                }
                i3 |= i8;
            }
            if ((4793491 & i3) == 4793490) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        elevatedShape = CardDefaults.INSTANCE.getElevatedShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        cardColorsElevatedCardColors = CardDefaults.INSTANCE.elevatedCardColors(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        cardColorsElevatedCardColors = cardColors2;
                    }
                    if ((i2 & 32) != 0) {
                        i3 &= -458753;
                        cardElevationM2073elevatedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2073elevatedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource;
                    }
                    i9 = i3;
                    cardElevation2 = cardElevationM2073elevatedCardElevationaqJV_2Y;
                } else {
                    if (i12 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        elevatedShape = CardDefaults.INSTANCE.getElevatedShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        cardColorsElevatedCardColors = CardDefaults.INSTANCE.elevatedCardColors(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        cardColorsElevatedCardColors = cardColors2;
                    }
                    if ((i2 & 32) != 0) {
                        i3 &= -458753;
                        cardElevationM2073elevatedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2073elevatedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource;
                    }
                    i9 = i3;
                    cardElevation2 = cardElevationM2073elevatedCardElevationaqJV_2Y;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1850977784, i9, -1, "androidx.compose.material3.ElevatedCard (Card.kt:254)");
                }
                int i110 = (i9 & 14) | 1572864 | (i9 & 112) | (i9 & 896) | (i9 & 7168) | (57344 & i9) | (458752 & i9);
                int i111 = i9 << 3;
                Card(function0, modifier2, z2, elevatedShape, cardColorsElevatedCardColors, cardElevation2, null, mutableInteractionSource3, function3, composerStartRestartGroup, i110 | (29360128 & i111) | (i111 & 234881024), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                cardColors2 = cardColorsElevatedCardColors;
                cardElevation3 = cardElevation2;
                z3 = z2;
                mutableInteractionSource4 = mutableInteractionSource3;
                shape2 = elevatedShape;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        elevatedShape = CardDefaults.INSTANCE.getElevatedShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        cardColorsElevatedCardColors = CardDefaults.INSTANCE.elevatedCardColors(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        cardColorsElevatedCardColors = cardColors2;
                    }
                    if ((i2 & 32) != 0) {
                        i3 &= -458753;
                        cardElevationM2073elevatedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2073elevatedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource;
                    }
                    i9 = i3;
                    cardElevation2 = cardElevationM2073elevatedCardElevationaqJV_2Y;
                } else {
                    if (i12 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        elevatedShape = CardDefaults.INSTANCE.getElevatedShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        cardColorsElevatedCardColors = CardDefaults.INSTANCE.elevatedCardColors(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        cardColorsElevatedCardColors = cardColors2;
                    }
                    if ((i2 & 32) != 0) {
                        i3 &= -458753;
                        cardElevationM2073elevatedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2073elevatedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource;
                    }
                    i9 = i3;
                    cardElevation2 = cardElevationM2073elevatedCardElevationaqJV_2Y;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1850977784, i9, -1, "androidx.compose.material3.ElevatedCard (Card.kt:254)");
                }
                int i112 = (i9 & 14) | 1572864 | (i9 & 112) | (i9 & 896) | (i9 & 7168) | (57344 & i9) | (458752 & i9);
                int i113 = i9 << 3;
                Card(function0, modifier2, z2, elevatedShape, cardColorsElevatedCardColors, cardElevation2, null, mutableInteractionSource3, function3, composerStartRestartGroup, i112 | (29360128 & i113) | (i113 & 234881024), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                cardColors2 = cardColorsElevatedCardColors;
                cardElevation3 = cardElevation2;
                z3 = z2;
                mutableInteractionSource4 = mutableInteractionSource3;
                shape2 = elevatedShape;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier5 = modifier2;
                final CardColors cardColors5 = cardColors2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i114) {
                        CardKt.ElevatedCard(function0, modifier5, z3, shape2, cardColors5, cardElevation3, mutableInteractionSource4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        z2 = z;
        if ((i & 3072) == 0) {
            if ((i2 & 8) == 0) {
                elevatedShape = shape;
                if (composerStartRestartGroup.changed(elevatedShape)) {
                    i11 = Fields.CameraDistance;
                }
                i3 |= i11;
            } else {
                elevatedShape = shape;
            }
            i11 = Fields.RotationZ;
            i3 |= i11;
        } else {
            elevatedShape = shape;
        }
        if ((i & 24576) == 0) {
            if ((i2 & 16) == 0) {
                cardColors2 = cardColors;
                if (composerStartRestartGroup.changed(cardColors2)) {
                    i10 = Fields.Clip;
                }
                i3 |= i10;
            } else {
                cardColors2 = cardColors;
            }
            i10 = Fields.Shape;
            i3 |= i10;
        } else {
            cardColors2 = cardColors;
        }
        if ((196608 & i) == 0) {
            if ((i2 & 32) == 0) {
                cardElevationM2073elevatedCardElevationaqJV_2Y = cardElevation;
                if (composerStartRestartGroup.changed(cardElevationM2073elevatedCardElevationaqJV_2Y)) {
                }
                i3 |= i13;
            } else {
                cardElevationM2073elevatedCardElevationaqJV_2Y = cardElevation;
            }
            i3 |= i13;
        } else {
            cardElevationM2073elevatedCardElevationaqJV_2Y = cardElevation;
        }
        i6 = i2 & 64;
        if (i6 != 0) {
            i3 |= 1572864;
            mutableInteractionSource2 = mutableInteractionSource;
        } else {
            mutableInteractionSource2 = mutableInteractionSource;
            if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changed(mutableInteractionSource2)) {
                    i7 = 1048576;
                } else {
                    i7 = 524288;
                }
                i3 |= i7;
            }
        }
        if ((i2 & Fields.SpotShadowColor) != 0) {
            i3 |= 12582912;
        } else if ((i & 12582912) == 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i8 = 8388608;
            } else {
                i8 = 4194304;
            }
            i3 |= i8;
        }
        if ((4793491 & i3) == 4793490) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i12 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    elevatedShape = CardDefaults.INSTANCE.getElevatedShape(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    cardColorsElevatedCardColors = CardDefaults.INSTANCE.elevatedCardColors(composerStartRestartGroup, 6);
                    i3 &= -57345;
                } else {
                    cardColorsElevatedCardColors = cardColors2;
                }
                if ((i2 & 32) != 0) {
                    i3 &= -458753;
                    cardElevationM2073elevatedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2073elevatedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                }
                if (i6 != 0) {
                    mutableInteractionSource3 = null;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource;
                }
                i9 = i3;
                cardElevation2 = cardElevationM2073elevatedCardElevationaqJV_2Y;
            } else {
                if (i12 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    elevatedShape = CardDefaults.INSTANCE.getElevatedShape(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    cardColorsElevatedCardColors = CardDefaults.INSTANCE.elevatedCardColors(composerStartRestartGroup, 6);
                    i3 &= -57345;
                } else {
                    cardColorsElevatedCardColors = cardColors2;
                }
                if ((i2 & 32) != 0) {
                    i3 &= -458753;
                    cardElevationM2073elevatedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2073elevatedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                }
                if (i6 != 0) {
                    mutableInteractionSource3 = null;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource;
                }
                i9 = i3;
                cardElevation2 = cardElevationM2073elevatedCardElevationaqJV_2Y;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1850977784, i9, -1, "androidx.compose.material3.ElevatedCard (Card.kt:254)");
            }
            int i114 = (i9 & 14) | 1572864 | (i9 & 112) | (i9 & 896) | (i9 & 7168) | (57344 & i9) | (458752 & i9);
            int i115 = i9 << 3;
            Card(function0, modifier2, z2, elevatedShape, cardColorsElevatedCardColors, cardElevation2, null, mutableInteractionSource3, function3, composerStartRestartGroup, i114 | (29360128 & i115) | (i115 & 234881024), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            cardColors2 = cardColorsElevatedCardColors;
            cardElevation3 = cardElevation2;
            z3 = z2;
            mutableInteractionSource4 = mutableInteractionSource3;
            shape2 = elevatedShape;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i12 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    elevatedShape = CardDefaults.INSTANCE.getElevatedShape(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    cardColorsElevatedCardColors = CardDefaults.INSTANCE.elevatedCardColors(composerStartRestartGroup, 6);
                    i3 &= -57345;
                } else {
                    cardColorsElevatedCardColors = cardColors2;
                }
                if ((i2 & 32) != 0) {
                    i3 &= -458753;
                    cardElevationM2073elevatedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2073elevatedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                }
                if (i6 != 0) {
                    mutableInteractionSource3 = null;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource;
                }
                i9 = i3;
                cardElevation2 = cardElevationM2073elevatedCardElevationaqJV_2Y;
            } else {
                if (i12 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    elevatedShape = CardDefaults.INSTANCE.getElevatedShape(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    cardColorsElevatedCardColors = CardDefaults.INSTANCE.elevatedCardColors(composerStartRestartGroup, 6);
                    i3 &= -57345;
                } else {
                    cardColorsElevatedCardColors = cardColors2;
                }
                if ((i2 & 32) != 0) {
                    i3 &= -458753;
                    cardElevationM2073elevatedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2073elevatedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                }
                if (i6 != 0) {
                    mutableInteractionSource3 = null;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource;
                }
                i9 = i3;
                cardElevation2 = cardElevationM2073elevatedCardElevationaqJV_2Y;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1850977784, i9, -1, "androidx.compose.material3.ElevatedCard (Card.kt:254)");
            }
            int i116 = (i9 & 14) | 1572864 | (i9 & 112) | (i9 & 896) | (i9 & 7168) | (57344 & i9) | (458752 & i9);
            int i117 = i9 << 3;
            Card(function0, modifier2, z2, elevatedShape, cardColorsElevatedCardColors, cardElevation2, null, mutableInteractionSource3, function3, composerStartRestartGroup, i116 | (29360128 & i117) | (i117 & 234881024), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            cardColors2 = cardColorsElevatedCardColors;
            cardElevation3 = cardElevation2;
            z3 = z2;
            mutableInteractionSource4 = mutableInteractionSource3;
            shape2 = elevatedShape;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier6 = modifier2;
            final CardColors cardColors6 = cardColors2;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i118) {
                    CardKt.ElevatedCard(function0, modifier6, z3, shape2, cardColors6, cardElevation3, mutableInteractionSource4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void OutlinedCard(Modifier modifier, Shape shape, CardColors cardColors, CardElevation cardElevation, BorderStroke borderStroke, final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2) {
        Modifier modifier2;
        int i3;
        Shape shape2;
        CardColors cardColors2;
        CardElevation cardElevationM2075outlinedCardElevationaqJV_2Y;
        BorderStroke borderStroke2;
        Modifier.Companion companion;
        Shape outlinedShape;
        CardColors cardColorsOutlinedCardColors;
        BorderStroke borderStrokeOutlinedCardBorder;
        final CardElevation cardElevation2;
        int i4;
        int i5;
        Composer composerStartRestartGroup = composer.startRestartGroup(740336179);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(OutlinedCard)P(4,5,1,3)297@13151L13,298@13204L20,299@13270L23,300@13335L20,303@13413L170:Card.kt#uh7d8r");
        int i6 = i2 & 1;
        if (i6 != 0) {
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
                shape2 = shape;
                int i7 = composerStartRestartGroup.changed(shape2) ? 32 : 16;
                i3 |= i7;
            } else {
                shape2 = shape;
            }
            i3 |= i7;
        } else {
            shape2 = shape;
        }
        if ((i & 384) == 0) {
            if ((i2 & 4) == 0) {
                cardColors2 = cardColors;
                if (composerStartRestartGroup.changed(cardColors2)) {
                    i5 = Fields.RotationX;
                }
                i3 |= i5;
            } else {
                cardColors2 = cardColors;
            }
            i5 = Fields.SpotShadowColor;
            i3 |= i5;
        } else {
            cardColors2 = cardColors;
        }
        if ((i & 3072) == 0) {
            if ((i2 & 8) == 0) {
                cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation;
                if (composerStartRestartGroup.changed(cardElevationM2075outlinedCardElevationaqJV_2Y)) {
                    i4 = Fields.CameraDistance;
                }
                i3 |= i4;
            } else {
                cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation;
            }
            i4 = Fields.RotationZ;
            i3 |= i4;
        } else {
            cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation;
        }
        if ((i & 24576) == 0) {
            borderStroke2 = borderStroke;
            i3 |= ((i2 & 16) == 0 && composerStartRestartGroup.changed(borderStroke2)) ? Fields.Clip : Fields.Shape;
        } else {
            borderStroke2 = borderStroke;
        }
        if ((i2 & 32) != 0) {
            i3 |= 196608;
        } else if ((i & 196608) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function3) ? Fields.RenderEffect : 65536;
        }
        if ((74899 & i3) != 74898 || !composerStartRestartGroup.getSkipping()) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) == 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                companion = i6 != 0 ? Modifier.INSTANCE : modifier2;
                if ((i2 & 2) != 0) {
                    outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                    i3 &= -113;
                } else {
                    outlinedShape = shape2;
                }
                if ((i2 & 4) != 0) {
                    cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                    i3 &= -897;
                } else {
                    cardColorsOutlinedCardColors = cardColors2;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                }
                if ((i2 & 16) != 0) {
                    borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(false, composerStartRestartGroup, 48, 1);
                    i3 &= -57345;
                } else {
                    borderStrokeOutlinedCardBorder = borderStroke;
                }
            } else {
                composerStartRestartGroup.skipToGroupEnd();
                if ((i2 & 2) != 0) {
                    i3 &= -113;
                }
                if ((i2 & 4) != 0) {
                    i3 &= -897;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                }
                companion = modifier2;
                outlinedShape = shape2;
                cardColorsOutlinedCardColors = cardColors2;
                borderStrokeOutlinedCardBorder = borderStroke2;
            }
            CardElevation cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
            int i8 = i3;
            cardElevation2 = cardElevation3;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(740336179, i8, -1, "androidx.compose.material3.OutlinedCard (Card.kt:303)");
            }
            Card(companion, outlinedShape, cardColorsOutlinedCardColors, cardElevation2, borderStrokeOutlinedCardBorder, function3, composerStartRestartGroup, i8 & 524286, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            borderStroke2 = borderStrokeOutlinedCardBorder;
        } else {
            composerStartRestartGroup.skipToGroupEnd();
            companion = modifier2;
            outlinedShape = shape2;
            cardColorsOutlinedCardColors = cardColors2;
            cardElevation2 = cardElevationM2075outlinedCardElevationaqJV_2Y;
        }
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier3 = companion;
            final Shape shape3 = outlinedShape;
            final CardColors cardColors3 = cardColorsOutlinedCardColors;
            final BorderStroke borderStroke3 = borderStroke2;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i9) {
                    CardKt.OutlinedCard(modifier3, shape3, cardColors3, cardElevation2, borderStroke3, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void OutlinedCard(final Function0<Unit> function0, Modifier modifier, boolean z, Shape shape, CardColors cardColors, CardElevation cardElevation, BorderStroke borderStroke, MutableInteractionSource mutableInteractionSource, final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2) {
        int i3;
        Modifier modifier2;
        int i4;
        boolean z2;
        int i5;
        Shape outlinedShape;
        CardColors cardColorsOutlinedCardColors;
        CardElevation cardElevation2;
        BorderStroke borderStroke2;
        int i6;
        MutableInteractionSource mutableInteractionSource2;
        int i7;
        int i8;
        CardElevation cardElevationM2075outlinedCardElevationaqJV_2Y;
        BorderStroke borderStrokeOutlinedCardBorder;
        MutableInteractionSource mutableInteractionSource3;
        final Modifier modifier3;
        final boolean z3;
        final CardColors cardColors2;
        final BorderStroke borderStroke3;
        final CardElevation cardElevation3;
        final Shape shape2;
        final MutableInteractionSource mutableInteractionSource4;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i9;
        int i10;
        int i11;
        Composer composerStartRestartGroup = composer.startRestartGroup(-727137250);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(OutlinedCard)P(7,6,4,8,1,3!1,5)352@15710L13,353@15763L20,354@15829L23,355@15894L27,359@16036L271:Card.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changedInstance(function0) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i12 = i2 & 2;
        if (i12 == 0) {
            if ((i & 48) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            i4 = i2 & 4;
            if (i4 != 0) {
                if ((i & 384) == 0) {
                    z2 = z;
                    if (composerStartRestartGroup.changed(z2)) {
                        i5 = Fields.RotationX;
                    } else {
                        i5 = Fields.SpotShadowColor;
                    }
                    i3 |= i5;
                }
                if ((i & 3072) == 0) {
                    if ((i2 & 8) == 0) {
                        outlinedShape = shape;
                        if (composerStartRestartGroup.changed(outlinedShape)) {
                            i11 = Fields.CameraDistance;
                        }
                        i3 |= i11;
                    } else {
                        outlinedShape = shape;
                    }
                    i11 = Fields.RotationZ;
                    i3 |= i11;
                } else {
                    outlinedShape = shape;
                }
                if ((i & 24576) == 0) {
                    if ((i2 & 16) == 0) {
                        cardColorsOutlinedCardColors = cardColors;
                        if (composerStartRestartGroup.changed(cardColorsOutlinedCardColors)) {
                            i10 = Fields.Clip;
                        }
                        i3 |= i10;
                    } else {
                        cardColorsOutlinedCardColors = cardColors;
                    }
                    i10 = Fields.Shape;
                    i3 |= i10;
                } else {
                    cardColorsOutlinedCardColors = cardColors;
                }
                if ((196608 & i) == 0) {
                    if ((i2 & 32) == 0) {
                        cardElevation2 = cardElevation;
                        int i13 = composerStartRestartGroup.changed(cardElevation2) ? Fields.RenderEffect : 65536;
                        i3 |= i13;
                    } else {
                        cardElevation2 = cardElevation;
                    }
                    i3 |= i13;
                } else {
                    cardElevation2 = cardElevation;
                }
                if ((1572864 & i) == 0) {
                    borderStroke2 = borderStroke;
                    if ((i2 & 64) == 0 || !composerStartRestartGroup.changed(borderStroke2)) {
                        i9 = 524288;
                    } else {
                        i9 = 1048576;
                    }
                    i3 |= i9;
                } else {
                    borderStroke2 = borderStroke;
                }
                i6 = i2 & Fields.SpotShadowColor;
                if (i6 != 0) {
                    if ((12582912 & i) == 0) {
                        mutableInteractionSource2 = mutableInteractionSource;
                        if (composerStartRestartGroup.changed(mutableInteractionSource2)) {
                            i7 = 8388608;
                        } else {
                            i7 = 4194304;
                        }
                        i3 |= i7;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        if ((i & 100663296) == 0) {
                            if (composerStartRestartGroup.changedInstance(function3)) {
                                i8 = 67108864;
                            } else {
                                i8 = 33554432;
                            }
                            i3 |= i8;
                        }
                        if ((i3 & 38347923) == 38347922 || !composerStartRestartGroup.getSkipping()) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                                if (i12 != 0) {
                                    modifier2 = Modifier.INSTANCE;
                                }
                                if (i4 != 0) {
                                    z2 = true;
                                }
                                if ((i2 & 8) != 0) {
                                    i3 &= -7169;
                                    outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                                }
                                if ((i2 & 16) != 0) {
                                    i3 &= -57345;
                                    cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                                }
                                if ((i2 & 32) != 0) {
                                    cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                                    i3 &= -458753;
                                } else {
                                    cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                                }
                                if ((i2 & 64) != 0) {
                                    borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                                    i3 = (-3670017) & i3;
                                } else {
                                    borderStrokeOutlinedCardBorder = borderStroke;
                                }
                                if (i6 != 0) {
                                    mutableInteractionSource3 = null;
                                } else {
                                    mutableInteractionSource3 = mutableInteractionSource;
                                }
                            } else {
                                composerStartRestartGroup.skipToGroupEnd();
                                if ((i2 & 8) != 0) {
                                    i3 &= -7169;
                                }
                                if ((i2 & 16) != 0) {
                                    i3 &= -57345;
                                }
                                if ((i2 & 32) != 0) {
                                    i3 &= -458753;
                                }
                                if ((i2 & 64) != 0) {
                                    i3 &= -3670017;
                                }
                                cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                                mutableInteractionSource3 = mutableInteractionSource2;
                                borderStrokeOutlinedCardBorder = borderStroke2;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                            }
                            Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier3 = modifier2;
                            z3 = z2;
                            cardColors2 = cardColorsOutlinedCardColors;
                            borderStroke3 = borderStrokeOutlinedCardBorder;
                            cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                            shape2 = outlinedShape;
                            mutableInteractionSource4 = mutableInteractionSource3;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            modifier3 = modifier2;
                            z3 = z2;
                            shape2 = outlinedShape;
                            cardColors2 = cardColorsOutlinedCardColors;
                            cardElevation3 = cardElevation2;
                            mutableInteractionSource4 = mutableInteractionSource2;
                            borderStroke3 = borderStroke2;
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
                                    CardKt.OutlinedCard(function0, modifier3, z3, shape2, cardColors2, cardElevation3, borderStroke3, mutableInteractionSource4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 100663296;
                    if ((i3 & 38347923) == 38347922) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i12 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if (i4 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 8) != 0) {
                                i3 &= -7169;
                                outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 32) != 0) {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                                i3 &= -458753;
                            } else {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                            }
                            if ((i2 & 64) != 0) {
                                borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                                i3 = (-3670017) & i3;
                            } else {
                                borderStrokeOutlinedCardBorder = borderStroke;
                            }
                            if (i6 != 0) {
                                mutableInteractionSource3 = null;
                            } else {
                                mutableInteractionSource3 = mutableInteractionSource;
                            }
                        } else {
                            if (i12 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if (i4 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 8) != 0) {
                                i3 &= -7169;
                                outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 32) != 0) {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                                i3 &= -458753;
                            } else {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                            }
                            if ((i2 & 64) != 0) {
                                borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                                i3 = (-3670017) & i3;
                            } else {
                                borderStrokeOutlinedCardBorder = borderStroke;
                            }
                            if (i6 != 0) {
                                mutableInteractionSource3 = null;
                            } else {
                                mutableInteractionSource3 = mutableInteractionSource;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                        }
                        Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier2;
                        z3 = z2;
                        cardColors2 = cardColorsOutlinedCardColors;
                        borderStroke3 = borderStrokeOutlinedCardBorder;
                        cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                        shape2 = outlinedShape;
                        mutableInteractionSource4 = mutableInteractionSource3;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i12 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if (i4 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 8) != 0) {
                                i3 &= -7169;
                                outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 32) != 0) {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                                i3 &= -458753;
                            } else {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                            }
                            if ((i2 & 64) != 0) {
                                borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                                i3 = (-3670017) & i3;
                            } else {
                                borderStrokeOutlinedCardBorder = borderStroke;
                            }
                            if (i6 != 0) {
                                mutableInteractionSource3 = null;
                            } else {
                                mutableInteractionSource3 = mutableInteractionSource;
                            }
                        } else {
                            if (i12 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if (i4 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 8) != 0) {
                                i3 &= -7169;
                                outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 32) != 0) {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                                i3 &= -458753;
                            } else {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                            }
                            if ((i2 & 64) != 0) {
                                borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                                i3 = (-3670017) & i3;
                            } else {
                                borderStrokeOutlinedCardBorder = borderStroke;
                            }
                            if (i6 != 0) {
                                mutableInteractionSource3 = null;
                            } else {
                                mutableInteractionSource3 = mutableInteractionSource;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                        }
                        Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier2;
                        z3 = z2;
                        cardColors2 = cardColorsOutlinedCardColors;
                        borderStroke3 = borderStrokeOutlinedCardBorder;
                        cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                        shape2 = outlinedShape;
                        mutableInteractionSource4 = mutableInteractionSource3;
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
                                CardKt.OutlinedCard(function0, modifier3, z3, shape2, cardColors2, cardElevation3, borderStroke3, mutableInteractionSource4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 12582912;
                mutableInteractionSource2 = mutableInteractionSource;
                if ((i2 & Fields.RotationX) != 0) {
                    if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i8 = 67108864;
                        } else {
                            i8 = 33554432;
                        }
                        i3 |= i8;
                    }
                    if ((i3 & 38347923) == 38347922) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i12 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if (i4 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 8) != 0) {
                                i3 &= -7169;
                                outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 32) != 0) {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                                i3 &= -458753;
                            } else {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                            }
                            if ((i2 & 64) != 0) {
                                borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                                i3 = (-3670017) & i3;
                            } else {
                                borderStrokeOutlinedCardBorder = borderStroke;
                            }
                            if (i6 != 0) {
                                mutableInteractionSource3 = null;
                            } else {
                                mutableInteractionSource3 = mutableInteractionSource;
                            }
                        } else {
                            if (i12 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if (i4 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 8) != 0) {
                                i3 &= -7169;
                                outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 32) != 0) {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                                i3 &= -458753;
                            } else {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                            }
                            if ((i2 & 64) != 0) {
                                borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                                i3 = (-3670017) & i3;
                            } else {
                                borderStrokeOutlinedCardBorder = borderStroke;
                            }
                            if (i6 != 0) {
                                mutableInteractionSource3 = null;
                            } else {
                                mutableInteractionSource3 = mutableInteractionSource;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                        }
                        Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier2;
                        z3 = z2;
                        cardColors2 = cardColorsOutlinedCardColors;
                        borderStroke3 = borderStrokeOutlinedCardBorder;
                        cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                        shape2 = outlinedShape;
                        mutableInteractionSource4 = mutableInteractionSource3;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i12 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if (i4 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 8) != 0) {
                                i3 &= -7169;
                                outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 32) != 0) {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                                i3 &= -458753;
                            } else {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                            }
                            if ((i2 & 64) != 0) {
                                borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                                i3 = (-3670017) & i3;
                            } else {
                                borderStrokeOutlinedCardBorder = borderStroke;
                            }
                            if (i6 != 0) {
                                mutableInteractionSource3 = null;
                            } else {
                                mutableInteractionSource3 = mutableInteractionSource;
                            }
                        } else {
                            if (i12 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if (i4 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 8) != 0) {
                                i3 &= -7169;
                                outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 32) != 0) {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                                i3 &= -458753;
                            } else {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                            }
                            if ((i2 & 64) != 0) {
                                borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                                i3 = (-3670017) & i3;
                            } else {
                                borderStrokeOutlinedCardBorder = borderStroke;
                            }
                            if (i6 != 0) {
                                mutableInteractionSource3 = null;
                            } else {
                                mutableInteractionSource3 = mutableInteractionSource;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                        }
                        Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier2;
                        z3 = z2;
                        cardColors2 = cardColorsOutlinedCardColors;
                        borderStroke3 = borderStrokeOutlinedCardBorder;
                        cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                        shape2 = outlinedShape;
                        mutableInteractionSource4 = mutableInteractionSource3;
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
                                CardKt.OutlinedCard(function0, modifier3, z3, shape2, cardColors2, cardElevation3, borderStroke3, mutableInteractionSource4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 100663296;
                if ((i3 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 32) != 0) {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                            i3 &= -458753;
                        } else {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                        }
                        if ((i2 & 64) != 0) {
                            borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                            i3 = (-3670017) & i3;
                        } else {
                            borderStrokeOutlinedCardBorder = borderStroke;
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource;
                        }
                    } else {
                        if (i12 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 32) != 0) {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                            i3 &= -458753;
                        } else {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                        }
                        if ((i2 & 64) != 0) {
                            borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                            i3 = (-3670017) & i3;
                        } else {
                            borderStrokeOutlinedCardBorder = borderStroke;
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                    }
                    Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier2;
                    z3 = z2;
                    cardColors2 = cardColorsOutlinedCardColors;
                    borderStroke3 = borderStrokeOutlinedCardBorder;
                    cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                    shape2 = outlinedShape;
                    mutableInteractionSource4 = mutableInteractionSource3;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 32) != 0) {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                            i3 &= -458753;
                        } else {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                        }
                        if ((i2 & 64) != 0) {
                            borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                            i3 = (-3670017) & i3;
                        } else {
                            borderStrokeOutlinedCardBorder = borderStroke;
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource;
                        }
                    } else {
                        if (i12 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 32) != 0) {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                            i3 &= -458753;
                        } else {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                        }
                        if ((i2 & 64) != 0) {
                            borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                            i3 = (-3670017) & i3;
                        } else {
                            borderStrokeOutlinedCardBorder = borderStroke;
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                    }
                    Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier2;
                    z3 = z2;
                    cardColors2 = cardColorsOutlinedCardColors;
                    borderStroke3 = borderStrokeOutlinedCardBorder;
                    cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                    shape2 = outlinedShape;
                    mutableInteractionSource4 = mutableInteractionSource3;
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
                            CardKt.OutlinedCard(function0, modifier3, z3, shape2, cardColors2, cardElevation3, borderStroke3, mutableInteractionSource4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 384;
            z2 = z;
            if ((i & 3072) == 0) {
                if ((i2 & 8) == 0) {
                    outlinedShape = shape;
                    if (composerStartRestartGroup.changed(outlinedShape)) {
                        i11 = Fields.CameraDistance;
                    }
                    i3 |= i11;
                } else {
                    outlinedShape = shape;
                }
                i11 = Fields.RotationZ;
                i3 |= i11;
            } else {
                outlinedShape = shape;
            }
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    cardColorsOutlinedCardColors = cardColors;
                    if (composerStartRestartGroup.changed(cardColorsOutlinedCardColors)) {
                        i10 = Fields.Clip;
                    }
                    i3 |= i10;
                } else {
                    cardColorsOutlinedCardColors = cardColors;
                }
                i10 = Fields.Shape;
                i3 |= i10;
            } else {
                cardColorsOutlinedCardColors = cardColors;
            }
            if ((196608 & i) == 0) {
                if ((i2 & 32) == 0) {
                    cardElevation2 = cardElevation;
                    if (composerStartRestartGroup.changed(cardElevation2)) {
                    }
                    i3 |= i13;
                } else {
                    cardElevation2 = cardElevation;
                }
                i3 |= i13;
            } else {
                cardElevation2 = cardElevation;
            }
            if ((1572864 & i) == 0) {
                borderStroke2 = borderStroke;
                if ((i2 & 64) == 0) {
                    i9 = 524288;
                } else {
                    i9 = 524288;
                }
                i3 |= i9;
            } else {
                borderStroke2 = borderStroke;
            }
            i6 = i2 & Fields.SpotShadowColor;
            if (i6 != 0) {
                if ((12582912 & i) == 0) {
                    mutableInteractionSource2 = mutableInteractionSource;
                    if (composerStartRestartGroup.changed(mutableInteractionSource2)) {
                        i7 = 8388608;
                    } else {
                        i7 = 4194304;
                    }
                    i3 |= i7;
                }
                if ((i2 & Fields.RotationX) != 0) {
                    if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i8 = 67108864;
                        } else {
                            i8 = 33554432;
                        }
                        i3 |= i8;
                    }
                    if ((i3 & 38347923) == 38347922) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i12 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if (i4 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 8) != 0) {
                                i3 &= -7169;
                                outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 32) != 0) {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                                i3 &= -458753;
                            } else {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                            }
                            if ((i2 & 64) != 0) {
                                borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                                i3 = (-3670017) & i3;
                            } else {
                                borderStrokeOutlinedCardBorder = borderStroke;
                            }
                            if (i6 != 0) {
                                mutableInteractionSource3 = null;
                            } else {
                                mutableInteractionSource3 = mutableInteractionSource;
                            }
                        } else {
                            if (i12 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if (i4 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 8) != 0) {
                                i3 &= -7169;
                                outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 32) != 0) {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                                i3 &= -458753;
                            } else {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                            }
                            if ((i2 & 64) != 0) {
                                borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                                i3 = (-3670017) & i3;
                            } else {
                                borderStrokeOutlinedCardBorder = borderStroke;
                            }
                            if (i6 != 0) {
                                mutableInteractionSource3 = null;
                            } else {
                                mutableInteractionSource3 = mutableInteractionSource;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                        }
                        Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier2;
                        z3 = z2;
                        cardColors2 = cardColorsOutlinedCardColors;
                        borderStroke3 = borderStrokeOutlinedCardBorder;
                        cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                        shape2 = outlinedShape;
                        mutableInteractionSource4 = mutableInteractionSource3;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i12 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if (i4 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 8) != 0) {
                                i3 &= -7169;
                                outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 32) != 0) {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                                i3 &= -458753;
                            } else {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                            }
                            if ((i2 & 64) != 0) {
                                borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                                i3 = (-3670017) & i3;
                            } else {
                                borderStrokeOutlinedCardBorder = borderStroke;
                            }
                            if (i6 != 0) {
                                mutableInteractionSource3 = null;
                            } else {
                                mutableInteractionSource3 = mutableInteractionSource;
                            }
                        } else {
                            if (i12 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if (i4 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 8) != 0) {
                                i3 &= -7169;
                                outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 32) != 0) {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                                i3 &= -458753;
                            } else {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                            }
                            if ((i2 & 64) != 0) {
                                borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                                i3 = (-3670017) & i3;
                            } else {
                                borderStrokeOutlinedCardBorder = borderStroke;
                            }
                            if (i6 != 0) {
                                mutableInteractionSource3 = null;
                            } else {
                                mutableInteractionSource3 = mutableInteractionSource;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                        }
                        Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier2;
                        z3 = z2;
                        cardColors2 = cardColorsOutlinedCardColors;
                        borderStroke3 = borderStrokeOutlinedCardBorder;
                        cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                        shape2 = outlinedShape;
                        mutableInteractionSource4 = mutableInteractionSource3;
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
                                CardKt.OutlinedCard(function0, modifier3, z3, shape2, cardColors2, cardElevation3, borderStroke3, mutableInteractionSource4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 100663296;
                if ((i3 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 32) != 0) {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                            i3 &= -458753;
                        } else {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                        }
                        if ((i2 & 64) != 0) {
                            borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                            i3 = (-3670017) & i3;
                        } else {
                            borderStrokeOutlinedCardBorder = borderStroke;
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource;
                        }
                    } else {
                        if (i12 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 32) != 0) {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                            i3 &= -458753;
                        } else {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                        }
                        if ((i2 & 64) != 0) {
                            borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                            i3 = (-3670017) & i3;
                        } else {
                            borderStrokeOutlinedCardBorder = borderStroke;
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                    }
                    Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier2;
                    z3 = z2;
                    cardColors2 = cardColorsOutlinedCardColors;
                    borderStroke3 = borderStrokeOutlinedCardBorder;
                    cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                    shape2 = outlinedShape;
                    mutableInteractionSource4 = mutableInteractionSource3;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 32) != 0) {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                            i3 &= -458753;
                        } else {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                        }
                        if ((i2 & 64) != 0) {
                            borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                            i3 = (-3670017) & i3;
                        } else {
                            borderStrokeOutlinedCardBorder = borderStroke;
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource;
                        }
                    } else {
                        if (i12 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 32) != 0) {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                            i3 &= -458753;
                        } else {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                        }
                        if ((i2 & 64) != 0) {
                            borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                            i3 = (-3670017) & i3;
                        } else {
                            borderStrokeOutlinedCardBorder = borderStroke;
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                    }
                    Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier2;
                    z3 = z2;
                    cardColors2 = cardColorsOutlinedCardColors;
                    borderStroke3 = borderStrokeOutlinedCardBorder;
                    cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                    shape2 = outlinedShape;
                    mutableInteractionSource4 = mutableInteractionSource3;
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
                            CardKt.OutlinedCard(function0, modifier3, z3, shape2, cardColors2, cardElevation3, borderStroke3, mutableInteractionSource4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 12582912;
            mutableInteractionSource2 = mutableInteractionSource;
            if ((i2 & Fields.RotationX) != 0) {
                if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i8 = 67108864;
                    } else {
                        i8 = 33554432;
                    }
                    i3 |= i8;
                }
                if ((i3 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 32) != 0) {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                            i3 &= -458753;
                        } else {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                        }
                        if ((i2 & 64) != 0) {
                            borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                            i3 = (-3670017) & i3;
                        } else {
                            borderStrokeOutlinedCardBorder = borderStroke;
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource;
                        }
                    } else {
                        if (i12 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 32) != 0) {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                            i3 &= -458753;
                        } else {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                        }
                        if ((i2 & 64) != 0) {
                            borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                            i3 = (-3670017) & i3;
                        } else {
                            borderStrokeOutlinedCardBorder = borderStroke;
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                    }
                    Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier2;
                    z3 = z2;
                    cardColors2 = cardColorsOutlinedCardColors;
                    borderStroke3 = borderStrokeOutlinedCardBorder;
                    cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                    shape2 = outlinedShape;
                    mutableInteractionSource4 = mutableInteractionSource3;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 32) != 0) {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                            i3 &= -458753;
                        } else {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                        }
                        if ((i2 & 64) != 0) {
                            borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                            i3 = (-3670017) & i3;
                        } else {
                            borderStrokeOutlinedCardBorder = borderStroke;
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource;
                        }
                    } else {
                        if (i12 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 32) != 0) {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                            i3 &= -458753;
                        } else {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                        }
                        if ((i2 & 64) != 0) {
                            borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                            i3 = (-3670017) & i3;
                        } else {
                            borderStrokeOutlinedCardBorder = borderStroke;
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                    }
                    Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier2;
                    z3 = z2;
                    cardColors2 = cardColorsOutlinedCardColors;
                    borderStroke3 = borderStrokeOutlinedCardBorder;
                    cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                    shape2 = outlinedShape;
                    mutableInteractionSource4 = mutableInteractionSource3;
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
                            CardKt.OutlinedCard(function0, modifier3, z3, shape2, cardColors2, cardElevation3, borderStroke3, mutableInteractionSource4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 100663296;
            if ((i3 & 38347923) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 32) != 0) {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                        i3 &= -458753;
                    } else {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                    }
                    if ((i2 & 64) != 0) {
                        borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                        i3 = (-3670017) & i3;
                    } else {
                        borderStrokeOutlinedCardBorder = borderStroke;
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource;
                    }
                } else {
                    if (i12 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 32) != 0) {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                        i3 &= -458753;
                    } else {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                    }
                    if ((i2 & 64) != 0) {
                        borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                        i3 = (-3670017) & i3;
                    } else {
                        borderStrokeOutlinedCardBorder = borderStroke;
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                }
                Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = modifier2;
                z3 = z2;
                cardColors2 = cardColorsOutlinedCardColors;
                borderStroke3 = borderStrokeOutlinedCardBorder;
                cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                shape2 = outlinedShape;
                mutableInteractionSource4 = mutableInteractionSource3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 32) != 0) {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                        i3 &= -458753;
                    } else {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                    }
                    if ((i2 & 64) != 0) {
                        borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                        i3 = (-3670017) & i3;
                    } else {
                        borderStrokeOutlinedCardBorder = borderStroke;
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource;
                    }
                } else {
                    if (i12 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 32) != 0) {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                        i3 &= -458753;
                    } else {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                    }
                    if ((i2 & 64) != 0) {
                        borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                        i3 = (-3670017) & i3;
                    } else {
                        borderStrokeOutlinedCardBorder = borderStroke;
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                }
                Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = modifier2;
                z3 = z2;
                cardColors2 = cardColorsOutlinedCardColors;
                borderStroke3 = borderStrokeOutlinedCardBorder;
                cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                shape2 = outlinedShape;
                mutableInteractionSource4 = mutableInteractionSource3;
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
                        CardKt.OutlinedCard(function0, modifier3, z3, shape2, cardColors2, cardElevation3, borderStroke3, mutableInteractionSource4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        modifier2 = modifier;
        i4 = i2 & 4;
        if (i4 != 0) {
            if ((i & 384) == 0) {
                z2 = z;
                if (composerStartRestartGroup.changed(z2)) {
                    i5 = Fields.RotationX;
                } else {
                    i5 = Fields.SpotShadowColor;
                }
                i3 |= i5;
            }
            if ((i & 3072) == 0) {
                if ((i2 & 8) == 0) {
                    outlinedShape = shape;
                    if (composerStartRestartGroup.changed(outlinedShape)) {
                        i11 = Fields.CameraDistance;
                    }
                    i3 |= i11;
                } else {
                    outlinedShape = shape;
                }
                i11 = Fields.RotationZ;
                i3 |= i11;
            } else {
                outlinedShape = shape;
            }
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    cardColorsOutlinedCardColors = cardColors;
                    if (composerStartRestartGroup.changed(cardColorsOutlinedCardColors)) {
                        i10 = Fields.Clip;
                    }
                    i3 |= i10;
                } else {
                    cardColorsOutlinedCardColors = cardColors;
                }
                i10 = Fields.Shape;
                i3 |= i10;
            } else {
                cardColorsOutlinedCardColors = cardColors;
            }
            if ((196608 & i) == 0) {
                if ((i2 & 32) == 0) {
                    cardElevation2 = cardElevation;
                    if (composerStartRestartGroup.changed(cardElevation2)) {
                    }
                    i3 |= i13;
                } else {
                    cardElevation2 = cardElevation;
                }
                i3 |= i13;
            } else {
                cardElevation2 = cardElevation;
            }
            if ((1572864 & i) == 0) {
                borderStroke2 = borderStroke;
                if ((i2 & 64) == 0) {
                    i9 = 524288;
                } else {
                    i9 = 524288;
                }
                i3 |= i9;
            } else {
                borderStroke2 = borderStroke;
            }
            i6 = i2 & Fields.SpotShadowColor;
            if (i6 != 0) {
                if ((12582912 & i) == 0) {
                    mutableInteractionSource2 = mutableInteractionSource;
                    if (composerStartRestartGroup.changed(mutableInteractionSource2)) {
                        i7 = 8388608;
                    } else {
                        i7 = 4194304;
                    }
                    i3 |= i7;
                }
                if ((i2 & Fields.RotationX) != 0) {
                    if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i8 = 67108864;
                        } else {
                            i8 = 33554432;
                        }
                        i3 |= i8;
                    }
                    if ((i3 & 38347923) == 38347922) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i12 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if (i4 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 8) != 0) {
                                i3 &= -7169;
                                outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 32) != 0) {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                                i3 &= -458753;
                            } else {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                            }
                            if ((i2 & 64) != 0) {
                                borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                                i3 = (-3670017) & i3;
                            } else {
                                borderStrokeOutlinedCardBorder = borderStroke;
                            }
                            if (i6 != 0) {
                                mutableInteractionSource3 = null;
                            } else {
                                mutableInteractionSource3 = mutableInteractionSource;
                            }
                        } else {
                            if (i12 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if (i4 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 8) != 0) {
                                i3 &= -7169;
                                outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 32) != 0) {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                                i3 &= -458753;
                            } else {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                            }
                            if ((i2 & 64) != 0) {
                                borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                                i3 = (-3670017) & i3;
                            } else {
                                borderStrokeOutlinedCardBorder = borderStroke;
                            }
                            if (i6 != 0) {
                                mutableInteractionSource3 = null;
                            } else {
                                mutableInteractionSource3 = mutableInteractionSource;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                        }
                        Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier2;
                        z3 = z2;
                        cardColors2 = cardColorsOutlinedCardColors;
                        borderStroke3 = borderStrokeOutlinedCardBorder;
                        cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                        shape2 = outlinedShape;
                        mutableInteractionSource4 = mutableInteractionSource3;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i12 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if (i4 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 8) != 0) {
                                i3 &= -7169;
                                outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 32) != 0) {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                                i3 &= -458753;
                            } else {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                            }
                            if ((i2 & 64) != 0) {
                                borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                                i3 = (-3670017) & i3;
                            } else {
                                borderStrokeOutlinedCardBorder = borderStroke;
                            }
                            if (i6 != 0) {
                                mutableInteractionSource3 = null;
                            } else {
                                mutableInteractionSource3 = mutableInteractionSource;
                            }
                        } else {
                            if (i12 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if (i4 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 8) != 0) {
                                i3 &= -7169;
                                outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 32) != 0) {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                                i3 &= -458753;
                            } else {
                                cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                            }
                            if ((i2 & 64) != 0) {
                                borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                                i3 = (-3670017) & i3;
                            } else {
                                borderStrokeOutlinedCardBorder = borderStroke;
                            }
                            if (i6 != 0) {
                                mutableInteractionSource3 = null;
                            } else {
                                mutableInteractionSource3 = mutableInteractionSource;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                        }
                        Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier2;
                        z3 = z2;
                        cardColors2 = cardColorsOutlinedCardColors;
                        borderStroke3 = borderStrokeOutlinedCardBorder;
                        cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                        shape2 = outlinedShape;
                        mutableInteractionSource4 = mutableInteractionSource3;
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
                                CardKt.OutlinedCard(function0, modifier3, z3, shape2, cardColors2, cardElevation3, borderStroke3, mutableInteractionSource4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 100663296;
                if ((i3 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 32) != 0) {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                            i3 &= -458753;
                        } else {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                        }
                        if ((i2 & 64) != 0) {
                            borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                            i3 = (-3670017) & i3;
                        } else {
                            borderStrokeOutlinedCardBorder = borderStroke;
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource;
                        }
                    } else {
                        if (i12 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 32) != 0) {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                            i3 &= -458753;
                        } else {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                        }
                        if ((i2 & 64) != 0) {
                            borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                            i3 = (-3670017) & i3;
                        } else {
                            borderStrokeOutlinedCardBorder = borderStroke;
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                    }
                    Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier2;
                    z3 = z2;
                    cardColors2 = cardColorsOutlinedCardColors;
                    borderStroke3 = borderStrokeOutlinedCardBorder;
                    cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                    shape2 = outlinedShape;
                    mutableInteractionSource4 = mutableInteractionSource3;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 32) != 0) {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                            i3 &= -458753;
                        } else {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                        }
                        if ((i2 & 64) != 0) {
                            borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                            i3 = (-3670017) & i3;
                        } else {
                            borderStrokeOutlinedCardBorder = borderStroke;
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource;
                        }
                    } else {
                        if (i12 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 32) != 0) {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                            i3 &= -458753;
                        } else {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                        }
                        if ((i2 & 64) != 0) {
                            borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                            i3 = (-3670017) & i3;
                        } else {
                            borderStrokeOutlinedCardBorder = borderStroke;
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                    }
                    Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier2;
                    z3 = z2;
                    cardColors2 = cardColorsOutlinedCardColors;
                    borderStroke3 = borderStrokeOutlinedCardBorder;
                    cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                    shape2 = outlinedShape;
                    mutableInteractionSource4 = mutableInteractionSource3;
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
                            CardKt.OutlinedCard(function0, modifier3, z3, shape2, cardColors2, cardElevation3, borderStroke3, mutableInteractionSource4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 12582912;
            mutableInteractionSource2 = mutableInteractionSource;
            if ((i2 & Fields.RotationX) != 0) {
                if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i8 = 67108864;
                    } else {
                        i8 = 33554432;
                    }
                    i3 |= i8;
                }
                if ((i3 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 32) != 0) {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                            i3 &= -458753;
                        } else {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                        }
                        if ((i2 & 64) != 0) {
                            borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                            i3 = (-3670017) & i3;
                        } else {
                            borderStrokeOutlinedCardBorder = borderStroke;
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource;
                        }
                    } else {
                        if (i12 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 32) != 0) {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                            i3 &= -458753;
                        } else {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                        }
                        if ((i2 & 64) != 0) {
                            borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                            i3 = (-3670017) & i3;
                        } else {
                            borderStrokeOutlinedCardBorder = borderStroke;
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                    }
                    Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier2;
                    z3 = z2;
                    cardColors2 = cardColorsOutlinedCardColors;
                    borderStroke3 = borderStrokeOutlinedCardBorder;
                    cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                    shape2 = outlinedShape;
                    mutableInteractionSource4 = mutableInteractionSource3;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 32) != 0) {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                            i3 &= -458753;
                        } else {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                        }
                        if ((i2 & 64) != 0) {
                            borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                            i3 = (-3670017) & i3;
                        } else {
                            borderStrokeOutlinedCardBorder = borderStroke;
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource;
                        }
                    } else {
                        if (i12 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 32) != 0) {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                            i3 &= -458753;
                        } else {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                        }
                        if ((i2 & 64) != 0) {
                            borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                            i3 = (-3670017) & i3;
                        } else {
                            borderStrokeOutlinedCardBorder = borderStroke;
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                    }
                    Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier2;
                    z3 = z2;
                    cardColors2 = cardColorsOutlinedCardColors;
                    borderStroke3 = borderStrokeOutlinedCardBorder;
                    cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                    shape2 = outlinedShape;
                    mutableInteractionSource4 = mutableInteractionSource3;
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
                            CardKt.OutlinedCard(function0, modifier3, z3, shape2, cardColors2, cardElevation3, borderStroke3, mutableInteractionSource4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 100663296;
            if ((i3 & 38347923) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 32) != 0) {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                        i3 &= -458753;
                    } else {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                    }
                    if ((i2 & 64) != 0) {
                        borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                        i3 = (-3670017) & i3;
                    } else {
                        borderStrokeOutlinedCardBorder = borderStroke;
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource;
                    }
                } else {
                    if (i12 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 32) != 0) {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                        i3 &= -458753;
                    } else {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                    }
                    if ((i2 & 64) != 0) {
                        borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                        i3 = (-3670017) & i3;
                    } else {
                        borderStrokeOutlinedCardBorder = borderStroke;
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                }
                Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = modifier2;
                z3 = z2;
                cardColors2 = cardColorsOutlinedCardColors;
                borderStroke3 = borderStrokeOutlinedCardBorder;
                cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                shape2 = outlinedShape;
                mutableInteractionSource4 = mutableInteractionSource3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 32) != 0) {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                        i3 &= -458753;
                    } else {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                    }
                    if ((i2 & 64) != 0) {
                        borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                        i3 = (-3670017) & i3;
                    } else {
                        borderStrokeOutlinedCardBorder = borderStroke;
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource;
                    }
                } else {
                    if (i12 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 32) != 0) {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                        i3 &= -458753;
                    } else {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                    }
                    if ((i2 & 64) != 0) {
                        borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                        i3 = (-3670017) & i3;
                    } else {
                        borderStrokeOutlinedCardBorder = borderStroke;
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                }
                Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = modifier2;
                z3 = z2;
                cardColors2 = cardColorsOutlinedCardColors;
                borderStroke3 = borderStrokeOutlinedCardBorder;
                cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                shape2 = outlinedShape;
                mutableInteractionSource4 = mutableInteractionSource3;
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
                        CardKt.OutlinedCard(function0, modifier3, z3, shape2, cardColors2, cardElevation3, borderStroke3, mutableInteractionSource4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        z2 = z;
        if ((i & 3072) == 0) {
            if ((i2 & 8) == 0) {
                outlinedShape = shape;
                if (composerStartRestartGroup.changed(outlinedShape)) {
                    i11 = Fields.CameraDistance;
                }
                i3 |= i11;
            } else {
                outlinedShape = shape;
            }
            i11 = Fields.RotationZ;
            i3 |= i11;
        } else {
            outlinedShape = shape;
        }
        if ((i & 24576) == 0) {
            if ((i2 & 16) == 0) {
                cardColorsOutlinedCardColors = cardColors;
                if (composerStartRestartGroup.changed(cardColorsOutlinedCardColors)) {
                    i10 = Fields.Clip;
                }
                i3 |= i10;
            } else {
                cardColorsOutlinedCardColors = cardColors;
            }
            i10 = Fields.Shape;
            i3 |= i10;
        } else {
            cardColorsOutlinedCardColors = cardColors;
        }
        if ((196608 & i) == 0) {
            if ((i2 & 32) == 0) {
                cardElevation2 = cardElevation;
                if (composerStartRestartGroup.changed(cardElevation2)) {
                }
                i3 |= i13;
            } else {
                cardElevation2 = cardElevation;
            }
            i3 |= i13;
        } else {
            cardElevation2 = cardElevation;
        }
        if ((1572864 & i) == 0) {
            borderStroke2 = borderStroke;
            if ((i2 & 64) == 0) {
                i9 = 524288;
            } else {
                i9 = 524288;
            }
            i3 |= i9;
        } else {
            borderStroke2 = borderStroke;
        }
        i6 = i2 & Fields.SpotShadowColor;
        if (i6 != 0) {
            if ((12582912 & i) == 0) {
                mutableInteractionSource2 = mutableInteractionSource;
                if (composerStartRestartGroup.changed(mutableInteractionSource2)) {
                    i7 = 8388608;
                } else {
                    i7 = 4194304;
                }
                i3 |= i7;
            }
            if ((i2 & Fields.RotationX) != 0) {
                if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i8 = 67108864;
                    } else {
                        i8 = 33554432;
                    }
                    i3 |= i8;
                }
                if ((i3 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 32) != 0) {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                            i3 &= -458753;
                        } else {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                        }
                        if ((i2 & 64) != 0) {
                            borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                            i3 = (-3670017) & i3;
                        } else {
                            borderStrokeOutlinedCardBorder = borderStroke;
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource;
                        }
                    } else {
                        if (i12 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 32) != 0) {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                            i3 &= -458753;
                        } else {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                        }
                        if ((i2 & 64) != 0) {
                            borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                            i3 = (-3670017) & i3;
                        } else {
                            borderStrokeOutlinedCardBorder = borderStroke;
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                    }
                    Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier2;
                    z3 = z2;
                    cardColors2 = cardColorsOutlinedCardColors;
                    borderStroke3 = borderStrokeOutlinedCardBorder;
                    cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                    shape2 = outlinedShape;
                    mutableInteractionSource4 = mutableInteractionSource3;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 32) != 0) {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                            i3 &= -458753;
                        } else {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                        }
                        if ((i2 & 64) != 0) {
                            borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                            i3 = (-3670017) & i3;
                        } else {
                            borderStrokeOutlinedCardBorder = borderStroke;
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource;
                        }
                    } else {
                        if (i12 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 32) != 0) {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                            i3 &= -458753;
                        } else {
                            cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                        }
                        if ((i2 & 64) != 0) {
                            borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                            i3 = (-3670017) & i3;
                        } else {
                            borderStrokeOutlinedCardBorder = borderStroke;
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                    }
                    Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier2;
                    z3 = z2;
                    cardColors2 = cardColorsOutlinedCardColors;
                    borderStroke3 = borderStrokeOutlinedCardBorder;
                    cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                    shape2 = outlinedShape;
                    mutableInteractionSource4 = mutableInteractionSource3;
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
                            CardKt.OutlinedCard(function0, modifier3, z3, shape2, cardColors2, cardElevation3, borderStroke3, mutableInteractionSource4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 100663296;
            if ((i3 & 38347923) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 32) != 0) {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                        i3 &= -458753;
                    } else {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                    }
                    if ((i2 & 64) != 0) {
                        borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                        i3 = (-3670017) & i3;
                    } else {
                        borderStrokeOutlinedCardBorder = borderStroke;
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource;
                    }
                } else {
                    if (i12 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 32) != 0) {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                        i3 &= -458753;
                    } else {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                    }
                    if ((i2 & 64) != 0) {
                        borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                        i3 = (-3670017) & i3;
                    } else {
                        borderStrokeOutlinedCardBorder = borderStroke;
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                }
                Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = modifier2;
                z3 = z2;
                cardColors2 = cardColorsOutlinedCardColors;
                borderStroke3 = borderStrokeOutlinedCardBorder;
                cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                shape2 = outlinedShape;
                mutableInteractionSource4 = mutableInteractionSource3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 32) != 0) {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                        i3 &= -458753;
                    } else {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                    }
                    if ((i2 & 64) != 0) {
                        borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                        i3 = (-3670017) & i3;
                    } else {
                        borderStrokeOutlinedCardBorder = borderStroke;
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource;
                    }
                } else {
                    if (i12 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 32) != 0) {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                        i3 &= -458753;
                    } else {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                    }
                    if ((i2 & 64) != 0) {
                        borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                        i3 = (-3670017) & i3;
                    } else {
                        borderStrokeOutlinedCardBorder = borderStroke;
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                }
                Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = modifier2;
                z3 = z2;
                cardColors2 = cardColorsOutlinedCardColors;
                borderStroke3 = borderStrokeOutlinedCardBorder;
                cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                shape2 = outlinedShape;
                mutableInteractionSource4 = mutableInteractionSource3;
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
                        CardKt.OutlinedCard(function0, modifier3, z3, shape2, cardColors2, cardElevation3, borderStroke3, mutableInteractionSource4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 12582912;
        mutableInteractionSource2 = mutableInteractionSource;
        if ((i2 & Fields.RotationX) != 0) {
            if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i8 = 67108864;
                } else {
                    i8 = 33554432;
                }
                i3 |= i8;
            }
            if ((i3 & 38347923) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 32) != 0) {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                        i3 &= -458753;
                    } else {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                    }
                    if ((i2 & 64) != 0) {
                        borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                        i3 = (-3670017) & i3;
                    } else {
                        borderStrokeOutlinedCardBorder = borderStroke;
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource;
                    }
                } else {
                    if (i12 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 32) != 0) {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                        i3 &= -458753;
                    } else {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                    }
                    if ((i2 & 64) != 0) {
                        borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                        i3 = (-3670017) & i3;
                    } else {
                        borderStrokeOutlinedCardBorder = borderStroke;
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                }
                Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = modifier2;
                z3 = z2;
                cardColors2 = cardColorsOutlinedCardColors;
                borderStroke3 = borderStrokeOutlinedCardBorder;
                cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                shape2 = outlinedShape;
                mutableInteractionSource4 = mutableInteractionSource3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 32) != 0) {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                        i3 &= -458753;
                    } else {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                    }
                    if ((i2 & 64) != 0) {
                        borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                        i3 = (-3670017) & i3;
                    } else {
                        borderStrokeOutlinedCardBorder = borderStroke;
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource;
                    }
                } else {
                    if (i12 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 32) != 0) {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                        i3 &= -458753;
                    } else {
                        cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                    }
                    if ((i2 & 64) != 0) {
                        borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                        i3 = (-3670017) & i3;
                    } else {
                        borderStrokeOutlinedCardBorder = borderStroke;
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
                }
                Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = modifier2;
                z3 = z2;
                cardColors2 = cardColorsOutlinedCardColors;
                borderStroke3 = borderStrokeOutlinedCardBorder;
                cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
                shape2 = outlinedShape;
                mutableInteractionSource4 = mutableInteractionSource3;
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
                        CardKt.OutlinedCard(function0, modifier3, z3, shape2, cardColors2, cardElevation3, borderStroke3, mutableInteractionSource4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 100663296;
        if ((i3 & 38347923) == 38347922) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i12 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                }
                if ((i2 & 32) != 0) {
                    cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                    i3 &= -458753;
                } else {
                    cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                }
                if ((i2 & 64) != 0) {
                    borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                    i3 = (-3670017) & i3;
                } else {
                    borderStrokeOutlinedCardBorder = borderStroke;
                }
                if (i6 != 0) {
                    mutableInteractionSource3 = null;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource;
                }
            } else {
                if (i12 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                }
                if ((i2 & 32) != 0) {
                    cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                    i3 &= -458753;
                } else {
                    cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                }
                if ((i2 & 64) != 0) {
                    borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                    i3 = (-3670017) & i3;
                } else {
                    borderStrokeOutlinedCardBorder = borderStroke;
                }
                if (i6 != 0) {
                    mutableInteractionSource3 = null;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
            }
            Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier3 = modifier2;
            z3 = z2;
            cardColors2 = cardColorsOutlinedCardColors;
            borderStroke3 = borderStrokeOutlinedCardBorder;
            cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
            shape2 = outlinedShape;
            mutableInteractionSource4 = mutableInteractionSource3;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i12 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                }
                if ((i2 & 32) != 0) {
                    cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                    i3 &= -458753;
                } else {
                    cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                }
                if ((i2 & 64) != 0) {
                    borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                    i3 = (-3670017) & i3;
                } else {
                    borderStrokeOutlinedCardBorder = borderStroke;
                }
                if (i6 != 0) {
                    mutableInteractionSource3 = null;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource;
                }
            } else {
                if (i12 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    outlinedShape = CardDefaults.INSTANCE.getOutlinedShape(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    cardColorsOutlinedCardColors = CardDefaults.INSTANCE.outlinedCardColors(composerStartRestartGroup, 6);
                }
                if ((i2 & 32) != 0) {
                    cardElevationM2075outlinedCardElevationaqJV_2Y = CardDefaults.INSTANCE.m2075outlinedCardElevationaqJV_2Y(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 1572864, 63);
                    i3 &= -458753;
                } else {
                    cardElevationM2075outlinedCardElevationaqJV_2Y = cardElevation2;
                }
                if ((i2 & 64) != 0) {
                    borderStrokeOutlinedCardBorder = CardDefaults.INSTANCE.outlinedCardBorder(z2, composerStartRestartGroup, ((i3 >> 6) & 14) | 48, 0);
                    i3 = (-3670017) & i3;
                } else {
                    borderStrokeOutlinedCardBorder = borderStroke;
                }
                if (i6 != 0) {
                    mutableInteractionSource3 = null;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-727137250, i3, -1, "androidx.compose.material3.OutlinedCard (Card.kt:359)");
            }
            Card(function0, modifier2, z2, outlinedShape, cardColorsOutlinedCardColors, cardElevationM2075outlinedCardElevationaqJV_2Y, borderStrokeOutlinedCardBorder, mutableInteractionSource3, function3, composerStartRestartGroup, i3 & 268435454, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier3 = modifier2;
            z3 = z2;
            cardColors2 = cardColorsOutlinedCardColors;
            borderStroke3 = borderStrokeOutlinedCardBorder;
            cardElevation3 = cardElevationM2075outlinedCardElevationaqJV_2Y;
            shape2 = outlinedShape;
            mutableInteractionSource4 = mutableInteractionSource3;
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
                    CardKt.OutlinedCard(function0, modifier3, z3, shape2, cardColors2, cardElevation3, borderStroke3, mutableInteractionSource4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }
}
