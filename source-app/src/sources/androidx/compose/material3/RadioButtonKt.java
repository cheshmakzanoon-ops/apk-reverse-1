package androidx.compose.material3;

import androidx.appcompat.app.AppCompatDelegate;
import androidx.compose.animation.core.AnimateAsStateKt;
import androidx.compose.animation.core.AnimationSpecKt;
import androidx.compose.foundation.CanvasKt;
import androidx.compose.foundation.interaction.MutableInteractionSource;
import androidx.compose.foundation.layout.PaddingKt;
import androidx.compose.foundation.layout.SizeKt;
import androidx.compose.foundation.selection.SelectableKt;
import androidx.compose.material3.tokens.RadioButtonTokens;
import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.drawscope.DrawScope;
import androidx.compose.p002ui.graphics.drawscope.Fill;
import androidx.compose.p002ui.graphics.drawscope.Stroke;
import androidx.compose.p002ui.semantics.Role;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.State;
import androidx.compose.ui.unit.Dp;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;

@Metadata(d1 = {"\u00008\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\u001aO\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n2\u000e\u0010\u000b\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\f2\b\b\u0002\u0010\r\u001a\u00020\u000e2\b\b\u0002\u0010\u000f\u001a\u00020\n2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\n\b\u0002\u0010\u0012\u001a\u0004\u0018\u00010\u0013H\u0007¢\u0006\u0002\u0010\u0014\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000\"\u0010\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0004\"\u0010\u0010\u0005\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0004\"\u0010\u0010\u0006\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0004¨\u0006\u0015"}, d2 = {"RadioAnimationDuration", "", "RadioButtonDotSize", "Landroidx/compose/ui/unit/Dp;", "F", "RadioButtonPadding", "RadioStrokeWidth", "RadioButton", "", "selected", "", "onClick", "Lkotlin/Function0;", "modifier", "Landroidx/compose/ui/Modifier;", "enabled", "colors", "Landroidx/compose/material3/RadioButtonColors;", "interactionSource", "Landroidx/compose/foundation/interaction/MutableInteractionSource;", "(ZLkotlin/jvm/functions/Function0;Landroidx/compose/ui/Modifier;ZLandroidx/compose/material3/RadioButtonColors;Landroidx/compose/foundation/interaction/MutableInteractionSource;Landroidx/compose/runtime/Composer;II)V", "material3_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class RadioButtonKt {
    private static final int RadioAnimationDuration = 100;
    private static final float RadioButtonDotSize = Dp.constructor-impl(12);
    private static final float RadioButtonPadding;
    private static final float RadioStrokeWidth;

    public static final void RadioButton(final boolean z, final Function0<Unit> function0, Modifier modifier, boolean z2, RadioButtonColors radioButtonColors, MutableInteractionSource mutableInteractionSource, Composer composer, final int i, final int i2) {
        int i3;
        final Modifier modifier2;
        int i4;
        boolean z3;
        int i5;
        RadioButtonColors radioButtonColorsColors;
        int i6;
        MutableInteractionSource mutableInteractionSource2;
        int i7;
        Modifier.Companion companion;
        Modifier modifier3;
        boolean z4;
        RadioButtonColors radioButtonColors2;
        float f;
        final State<Dp> stateM401animateDpAsStateAjpBEmI;
        final State<Color> stateRadioColor$material3_release;
        boolean z5;
        Modifier.Companion companionM1362selectableO2vRcR0;
        Modifier.Companion companionMinimumInteractiveComponentSize;
        boolean zChanged;
        Object objRememberedValue;
        final RadioButtonColors radioButtonColors3;
        final boolean z6;
        final MutableInteractionSource mutableInteractionSource3;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i8;
        Composer composerStartRestartGroup = composer.startRestartGroup(408580840);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(RadioButton)P(5,4,3,1)80@3770L8,84@3868L176,88@4073L29,119@5097L415,106@4679L833:RadioButton.kt#uh7d8r");
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
        int i9 = i2 & 4;
        if (i9 == 0) {
            if ((i & 384) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? Fields.RotationX : Fields.SpotShadowColor;
            }
            i4 = i2 & 8;
            if (i4 != 0) {
                if ((i & 3072) == 0) {
                    z3 = z2;
                    if (composerStartRestartGroup.changed(z3)) {
                        i5 = Fields.CameraDistance;
                    } else {
                        i5 = Fields.RotationZ;
                    }
                    i3 |= i5;
                }
                if ((i & 24576) == 0) {
                    if ((i2 & 16) == 0) {
                        radioButtonColorsColors = radioButtonColors;
                        if (composerStartRestartGroup.changed(radioButtonColorsColors)) {
                            i8 = Fields.Clip;
                        }
                        i3 |= i8;
                    } else {
                        radioButtonColorsColors = radioButtonColors;
                    }
                    i8 = Fields.Shape;
                    i3 |= i8;
                } else {
                    radioButtonColorsColors = radioButtonColors;
                }
                i6 = i2 & 32;
                if (i6 != 0) {
                    if ((196608 & i) == 0) {
                        mutableInteractionSource2 = mutableInteractionSource;
                        if (composerStartRestartGroup.changed(mutableInteractionSource2)) {
                            i7 = Fields.RenderEffect;
                        } else {
                            i7 = 65536;
                        }
                        i3 |= i7;
                    }
                    if ((74899 & i3) == 74898 || !composerStartRestartGroup.getSkipping()) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                            if (i9 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i4 != 0) {
                                z3 = true;
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                            if (i6 != 0) {
                                modifier3 = companion;
                                z4 = z3;
                                radioButtonColors2 = radioButtonColorsColors;
                                mutableInteractionSource = null;
                            } else {
                                modifier3 = companion;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(408580840, i3, -1, "androidx.compose.material3.RadioButton (RadioButton.kt:82)");
                            }
                            if (z) {
                                f = Dp.constructor-impl(RadioButtonDotSize / 2);
                            } else {
                                f = Dp.constructor-impl(0);
                            }
                            stateM401animateDpAsStateAjpBEmI = AnimateAsStateKt.m401animateDpAsStateAjpBEmI(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composerStartRestartGroup, 48, 12);
                            stateRadioColor$material3_release = radioButtonColors2.radioColor$material3_release(z4, z, composerStartRestartGroup, ((i3 >> 6) & 896) | ((i3 >> 9) & 14) | ((i3 << 3) & 112));
                            composerStartRestartGroup.startReplaceGroup(1327106656);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "98@4448L164");
                            if (function0 != null) {
                                z5 = z4;
                                companionM1362selectableO2vRcR0 = SelectableKt.m1362selectableO2vRcR0(Modifier.INSTANCE, z, mutableInteractionSource, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3834getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z5, Role.m6604boximpl(Role.INSTANCE.m6615getRadioButtono7Vup1c()), function0);
                            } else {
                                z5 = z4;
                                companionM1362selectableO2vRcR0 = Modifier.INSTANCE;
                            }
                            composerStartRestartGroup.endReplaceGroup();
                            if (function0 != null) {
                                companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
                            } else {
                                companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
                            }
                            Modifier modifierM1072requiredSize3ABfNKs = SizeKt.m1072requiredSize3ABfNKs(PaddingKt.m1035padding3ABfNKs(SizeKt.wrapContentSize$default(modifier3.then(companionMinimumInteractiveComponentSize).then(companionM1362selectableO2vRcR0), Alignment.INSTANCE.getCenter(), r0, 2, null), RadioButtonPadding), RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM());
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1327137161, "CC(remember):RadioButton.kt#9igjgp");
                            zChanged = composerStartRestartGroup.changed(stateRadioColor$material3_release) | composerStartRestartGroup.changed(stateM401animateDpAsStateAjpBEmI);
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((DrawScope) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(DrawScope drawScope) {
                                        float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                                        float f3 = 2;
                                        float f4 = f2 / f3;
                                        DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                        if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                                            DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                        }
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            CanvasKt.Canvas(modifierM1072requiredSize3ABfNKs, (Function1) objRememberedValue, composerStartRestartGroup, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier2 = modifier3;
                            radioButtonColors3 = radioButtonColors2;
                            z6 = z5;
                            mutableInteractionSource3 = mutableInteractionSource;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                            }
                            modifier3 = modifier2;
                        }
                        z4 = z3;
                        radioButtonColors2 = radioButtonColorsColors;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(408580840, i3, -1, "androidx.compose.material3.RadioButton (RadioButton.kt:82)");
                        }
                        if (z) {
                            f = Dp.constructor-impl(RadioButtonDotSize / 2);
                        } else {
                            f = Dp.constructor-impl(0);
                        }
                        stateM401animateDpAsStateAjpBEmI = AnimateAsStateKt.m401animateDpAsStateAjpBEmI(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composerStartRestartGroup, 48, 12);
                        stateRadioColor$material3_release = radioButtonColors2.radioColor$material3_release(z4, z, composerStartRestartGroup, ((i3 >> 6) & 896) | ((i3 >> 9) & 14) | ((i3 << 3) & 112));
                        composerStartRestartGroup.startReplaceGroup(1327106656);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "98@4448L164");
                        if (function0 != null) {
                            z5 = z4;
                            companionM1362selectableO2vRcR0 = SelectableKt.m1362selectableO2vRcR0(Modifier.INSTANCE, z, mutableInteractionSource, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3834getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z5, Role.m6604boximpl(Role.INSTANCE.m6615getRadioButtono7Vup1c()), function0);
                        } else {
                            z5 = z4;
                            companionM1362selectableO2vRcR0 = Modifier.INSTANCE;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        if (function0 != null) {
                            companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
                        } else {
                            companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
                        }
                        Modifier modifierM1072requiredSize3ABfNKs2 = SizeKt.m1072requiredSize3ABfNKs(PaddingKt.m1035padding3ABfNKs(SizeKt.wrapContentSize$default(modifier3.then(companionMinimumInteractiveComponentSize).then(companionM1362selectableO2vRcR0), Alignment.INSTANCE.getCenter(), r0, 2, null), RadioButtonPadding), RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM());
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1327137161, "CC(remember):RadioButton.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(stateRadioColor$material3_release) | composerStartRestartGroup.changed(stateM401animateDpAsStateAjpBEmI);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                                    float f3 = 2;
                                    float f4 = f2 / f3;
                                    DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                    if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                                        DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                    }
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                                    float f3 = 2;
                                    float f4 = f2 / f3;
                                    DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                    if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                                        DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                    }
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CanvasKt.Canvas(modifierM1072requiredSize3ABfNKs2, (Function1) objRememberedValue, composerStartRestartGroup, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = modifier3;
                        radioButtonColors3 = radioButtonColors2;
                        z6 = z5;
                        mutableInteractionSource3 = mutableInteractionSource;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        composerStartRestartGroup = composerStartRestartGroup;
                        z6 = z3;
                        radioButtonColors3 = radioButtonColorsColors;
                        mutableInteractionSource3 = mutableInteractionSource2;
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

                            public final void invoke(Composer composer2, int i10) {
                                RadioButtonKt.RadioButton(z, function0, modifier2, z6, radioButtonColors3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                mutableInteractionSource2 = mutableInteractionSource;
                if ((74899 & i3) == 74898) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i9 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            z3 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            modifier3 = companion;
                            z4 = z3;
                            radioButtonColors2 = radioButtonColorsColors;
                            mutableInteractionSource = null;
                        } else {
                            modifier3 = companion;
                            z4 = z3;
                            radioButtonColors2 = radioButtonColorsColors;
                        }
                    } else {
                        if (i9 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            z3 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            modifier3 = companion;
                            z4 = z3;
                            radioButtonColors2 = radioButtonColorsColors;
                            mutableInteractionSource = null;
                        } else {
                            modifier3 = companion;
                            z4 = z3;
                            radioButtonColors2 = radioButtonColorsColors;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(408580840, i3, -1, "androidx.compose.material3.RadioButton (RadioButton.kt:82)");
                    }
                    if (z) {
                        f = Dp.constructor-impl(RadioButtonDotSize / 2);
                    } else {
                        f = Dp.constructor-impl(0);
                    }
                    stateM401animateDpAsStateAjpBEmI = AnimateAsStateKt.m401animateDpAsStateAjpBEmI(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composerStartRestartGroup, 48, 12);
                    stateRadioColor$material3_release = radioButtonColors2.radioColor$material3_release(z4, z, composerStartRestartGroup, ((i3 >> 6) & 896) | ((i3 >> 9) & 14) | ((i3 << 3) & 112));
                    composerStartRestartGroup.startReplaceGroup(1327106656);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "98@4448L164");
                    if (function0 != null) {
                        z5 = z4;
                        companionM1362selectableO2vRcR0 = SelectableKt.m1362selectableO2vRcR0(Modifier.INSTANCE, z, mutableInteractionSource, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3834getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z5, Role.m6604boximpl(Role.INSTANCE.m6615getRadioButtono7Vup1c()), function0);
                    } else {
                        z5 = z4;
                        companionM1362selectableO2vRcR0 = Modifier.INSTANCE;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    if (function0 != null) {
                        companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
                    } else {
                        companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
                    }
                    Modifier modifierM1072requiredSize3ABfNKs3 = SizeKt.m1072requiredSize3ABfNKs(PaddingKt.m1035padding3ABfNKs(SizeKt.wrapContentSize$default(modifier3.then(companionMinimumInteractiveComponentSize).then(companionM1362selectableO2vRcR0), Alignment.INSTANCE.getCenter(), r0, 2, null), RadioButtonPadding), RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM());
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1327137161, "CC(remember):RadioButton.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(stateRadioColor$material3_release) | composerStartRestartGroup.changed(stateM401animateDpAsStateAjpBEmI);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                                float f3 = 2;
                                float f4 = f2 / f3;
                                DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                                    DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                }
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                                float f3 = 2;
                                float f4 = f2 / f3;
                                DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                                    DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                }
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierM1072requiredSize3ABfNKs3, (Function1) objRememberedValue, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier3;
                    radioButtonColors3 = radioButtonColors2;
                    z6 = z5;
                    mutableInteractionSource3 = mutableInteractionSource;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i9 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            z3 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            modifier3 = companion;
                            z4 = z3;
                            radioButtonColors2 = radioButtonColorsColors;
                            mutableInteractionSource = null;
                        } else {
                            modifier3 = companion;
                            z4 = z3;
                            radioButtonColors2 = radioButtonColorsColors;
                        }
                    } else {
                        if (i9 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            z3 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            modifier3 = companion;
                            z4 = z3;
                            radioButtonColors2 = radioButtonColorsColors;
                            mutableInteractionSource = null;
                        } else {
                            modifier3 = companion;
                            z4 = z3;
                            radioButtonColors2 = radioButtonColorsColors;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(408580840, i3, -1, "androidx.compose.material3.RadioButton (RadioButton.kt:82)");
                    }
                    if (z) {
                        f = Dp.constructor-impl(RadioButtonDotSize / 2);
                    } else {
                        f = Dp.constructor-impl(0);
                    }
                    stateM401animateDpAsStateAjpBEmI = AnimateAsStateKt.m401animateDpAsStateAjpBEmI(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composerStartRestartGroup, 48, 12);
                    stateRadioColor$material3_release = radioButtonColors2.radioColor$material3_release(z4, z, composerStartRestartGroup, ((i3 >> 6) & 896) | ((i3 >> 9) & 14) | ((i3 << 3) & 112));
                    composerStartRestartGroup.startReplaceGroup(1327106656);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "98@4448L164");
                    if (function0 != null) {
                        z5 = z4;
                        companionM1362selectableO2vRcR0 = SelectableKt.m1362selectableO2vRcR0(Modifier.INSTANCE, z, mutableInteractionSource, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3834getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z5, Role.m6604boximpl(Role.INSTANCE.m6615getRadioButtono7Vup1c()), function0);
                    } else {
                        z5 = z4;
                        companionM1362selectableO2vRcR0 = Modifier.INSTANCE;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    if (function0 != null) {
                        companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
                    } else {
                        companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
                    }
                    Modifier modifierM1072requiredSize3ABfNKs4 = SizeKt.m1072requiredSize3ABfNKs(PaddingKt.m1035padding3ABfNKs(SizeKt.wrapContentSize$default(modifier3.then(companionMinimumInteractiveComponentSize).then(companionM1362selectableO2vRcR0), Alignment.INSTANCE.getCenter(), r0, 2, null), RadioButtonPadding), RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM());
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1327137161, "CC(remember):RadioButton.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(stateRadioColor$material3_release) | composerStartRestartGroup.changed(stateM401animateDpAsStateAjpBEmI);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                                float f3 = 2;
                                float f4 = f2 / f3;
                                DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                                    DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                }
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                                float f3 = 2;
                                float f4 = f2 / f3;
                                DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                                    DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                }
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierM1072requiredSize3ABfNKs4, (Function1) objRememberedValue, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier3;
                    radioButtonColors3 = radioButtonColors2;
                    z6 = z5;
                    mutableInteractionSource3 = mutableInteractionSource;
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

                        public final void invoke(Composer composer2, int i10) {
                            RadioButtonKt.RadioButton(z, function0, modifier2, z6, radioButtonColors3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            z3 = z2;
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    radioButtonColorsColors = radioButtonColors;
                    if (composerStartRestartGroup.changed(radioButtonColorsColors)) {
                        i8 = Fields.Clip;
                    }
                    i3 |= i8;
                } else {
                    radioButtonColorsColors = radioButtonColors;
                }
                i8 = Fields.Shape;
                i3 |= i8;
            } else {
                radioButtonColorsColors = radioButtonColors;
            }
            i6 = i2 & 32;
            if (i6 != 0) {
                if ((196608 & i) == 0) {
                    mutableInteractionSource2 = mutableInteractionSource;
                    if (composerStartRestartGroup.changed(mutableInteractionSource2)) {
                        i7 = Fields.RenderEffect;
                    } else {
                        i7 = 65536;
                    }
                    i3 |= i7;
                }
                if ((74899 & i3) == 74898) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i9 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            z3 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            modifier3 = companion;
                            z4 = z3;
                            radioButtonColors2 = radioButtonColorsColors;
                            mutableInteractionSource = null;
                        } else {
                            modifier3 = companion;
                            z4 = z3;
                            radioButtonColors2 = radioButtonColorsColors;
                        }
                    } else {
                        if (i9 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            z3 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            modifier3 = companion;
                            z4 = z3;
                            radioButtonColors2 = radioButtonColorsColors;
                            mutableInteractionSource = null;
                        } else {
                            modifier3 = companion;
                            z4 = z3;
                            radioButtonColors2 = radioButtonColorsColors;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(408580840, i3, -1, "androidx.compose.material3.RadioButton (RadioButton.kt:82)");
                    }
                    if (z) {
                        f = Dp.constructor-impl(RadioButtonDotSize / 2);
                    } else {
                        f = Dp.constructor-impl(0);
                    }
                    stateM401animateDpAsStateAjpBEmI = AnimateAsStateKt.m401animateDpAsStateAjpBEmI(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composerStartRestartGroup, 48, 12);
                    stateRadioColor$material3_release = radioButtonColors2.radioColor$material3_release(z4, z, composerStartRestartGroup, ((i3 >> 6) & 896) | ((i3 >> 9) & 14) | ((i3 << 3) & 112));
                    composerStartRestartGroup.startReplaceGroup(1327106656);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "98@4448L164");
                    if (function0 != null) {
                        z5 = z4;
                        companionM1362selectableO2vRcR0 = SelectableKt.m1362selectableO2vRcR0(Modifier.INSTANCE, z, mutableInteractionSource, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3834getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z5, Role.m6604boximpl(Role.INSTANCE.m6615getRadioButtono7Vup1c()), function0);
                    } else {
                        z5 = z4;
                        companionM1362selectableO2vRcR0 = Modifier.INSTANCE;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    if (function0 != null) {
                        companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
                    } else {
                        companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
                    }
                    Modifier modifierM1072requiredSize3ABfNKs5 = SizeKt.m1072requiredSize3ABfNKs(PaddingKt.m1035padding3ABfNKs(SizeKt.wrapContentSize$default(modifier3.then(companionMinimumInteractiveComponentSize).then(companionM1362selectableO2vRcR0), Alignment.INSTANCE.getCenter(), r0, 2, null), RadioButtonPadding), RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM());
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1327137161, "CC(remember):RadioButton.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(stateRadioColor$material3_release) | composerStartRestartGroup.changed(stateM401animateDpAsStateAjpBEmI);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                                float f3 = 2;
                                float f4 = f2 / f3;
                                DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                                    DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                }
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                                float f3 = 2;
                                float f4 = f2 / f3;
                                DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                                    DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                }
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierM1072requiredSize3ABfNKs5, (Function1) objRememberedValue, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier3;
                    radioButtonColors3 = radioButtonColors2;
                    z6 = z5;
                    mutableInteractionSource3 = mutableInteractionSource;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i9 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            z3 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            modifier3 = companion;
                            z4 = z3;
                            radioButtonColors2 = radioButtonColorsColors;
                            mutableInteractionSource = null;
                        } else {
                            modifier3 = companion;
                            z4 = z3;
                            radioButtonColors2 = radioButtonColorsColors;
                        }
                    } else {
                        if (i9 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            z3 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            modifier3 = companion;
                            z4 = z3;
                            radioButtonColors2 = radioButtonColorsColors;
                            mutableInteractionSource = null;
                        } else {
                            modifier3 = companion;
                            z4 = z3;
                            radioButtonColors2 = radioButtonColorsColors;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(408580840, i3, -1, "androidx.compose.material3.RadioButton (RadioButton.kt:82)");
                    }
                    if (z) {
                        f = Dp.constructor-impl(RadioButtonDotSize / 2);
                    } else {
                        f = Dp.constructor-impl(0);
                    }
                    stateM401animateDpAsStateAjpBEmI = AnimateAsStateKt.m401animateDpAsStateAjpBEmI(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composerStartRestartGroup, 48, 12);
                    stateRadioColor$material3_release = radioButtonColors2.radioColor$material3_release(z4, z, composerStartRestartGroup, ((i3 >> 6) & 896) | ((i3 >> 9) & 14) | ((i3 << 3) & 112));
                    composerStartRestartGroup.startReplaceGroup(1327106656);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "98@4448L164");
                    if (function0 != null) {
                        z5 = z4;
                        companionM1362selectableO2vRcR0 = SelectableKt.m1362selectableO2vRcR0(Modifier.INSTANCE, z, mutableInteractionSource, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3834getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z5, Role.m6604boximpl(Role.INSTANCE.m6615getRadioButtono7Vup1c()), function0);
                    } else {
                        z5 = z4;
                        companionM1362selectableO2vRcR0 = Modifier.INSTANCE;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    if (function0 != null) {
                        companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
                    } else {
                        companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
                    }
                    Modifier modifierM1072requiredSize3ABfNKs6 = SizeKt.m1072requiredSize3ABfNKs(PaddingKt.m1035padding3ABfNKs(SizeKt.wrapContentSize$default(modifier3.then(companionMinimumInteractiveComponentSize).then(companionM1362selectableO2vRcR0), Alignment.INSTANCE.getCenter(), r0, 2, null), RadioButtonPadding), RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM());
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1327137161, "CC(remember):RadioButton.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(stateRadioColor$material3_release) | composerStartRestartGroup.changed(stateM401animateDpAsStateAjpBEmI);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                                float f3 = 2;
                                float f4 = f2 / f3;
                                DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                                    DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                }
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                                float f3 = 2;
                                float f4 = f2 / f3;
                                DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                                    DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                }
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierM1072requiredSize3ABfNKs6, (Function1) objRememberedValue, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier3;
                    radioButtonColors3 = radioButtonColors2;
                    z6 = z5;
                    mutableInteractionSource3 = mutableInteractionSource;
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

                        public final void invoke(Composer composer2, int i10) {
                            RadioButtonKt.RadioButton(z, function0, modifier2, z6, radioButtonColors3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            mutableInteractionSource2 = mutableInteractionSource;
            if ((74899 & i3) == 74898) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        modifier3 = companion;
                        z4 = z3;
                        radioButtonColors2 = radioButtonColorsColors;
                        mutableInteractionSource = null;
                    } else {
                        modifier3 = companion;
                        z4 = z3;
                        radioButtonColors2 = radioButtonColorsColors;
                    }
                } else {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        modifier3 = companion;
                        z4 = z3;
                        radioButtonColors2 = radioButtonColorsColors;
                        mutableInteractionSource = null;
                    } else {
                        modifier3 = companion;
                        z4 = z3;
                        radioButtonColors2 = radioButtonColorsColors;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(408580840, i3, -1, "androidx.compose.material3.RadioButton (RadioButton.kt:82)");
                }
                if (z) {
                    f = Dp.constructor-impl(RadioButtonDotSize / 2);
                } else {
                    f = Dp.constructor-impl(0);
                }
                stateM401animateDpAsStateAjpBEmI = AnimateAsStateKt.m401animateDpAsStateAjpBEmI(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composerStartRestartGroup, 48, 12);
                stateRadioColor$material3_release = radioButtonColors2.radioColor$material3_release(z4, z, composerStartRestartGroup, ((i3 >> 6) & 896) | ((i3 >> 9) & 14) | ((i3 << 3) & 112));
                composerStartRestartGroup.startReplaceGroup(1327106656);
                ComposerKt.sourceInformation(composerStartRestartGroup, "98@4448L164");
                if (function0 != null) {
                    z5 = z4;
                    companionM1362selectableO2vRcR0 = SelectableKt.m1362selectableO2vRcR0(Modifier.INSTANCE, z, mutableInteractionSource, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3834getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z5, Role.m6604boximpl(Role.INSTANCE.m6615getRadioButtono7Vup1c()), function0);
                } else {
                    z5 = z4;
                    companionM1362selectableO2vRcR0 = Modifier.INSTANCE;
                }
                composerStartRestartGroup.endReplaceGroup();
                if (function0 != null) {
                    companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
                } else {
                    companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
                }
                Modifier modifierM1072requiredSize3ABfNKs7 = SizeKt.m1072requiredSize3ABfNKs(PaddingKt.m1035padding3ABfNKs(SizeKt.wrapContentSize$default(modifier3.then(companionMinimumInteractiveComponentSize).then(companionM1362selectableO2vRcR0), Alignment.INSTANCE.getCenter(), r0, 2, null), RadioButtonPadding), RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1327137161, "CC(remember):RadioButton.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(stateRadioColor$material3_release) | composerStartRestartGroup.changed(stateM401animateDpAsStateAjpBEmI);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                            float f3 = 2;
                            float f4 = f2 / f3;
                            DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                            if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                                DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                            float f3 = 2;
                            float f4 = f2 / f3;
                            DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                            if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                                DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierM1072requiredSize3ABfNKs7, (Function1) objRememberedValue, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier3;
                radioButtonColors3 = radioButtonColors2;
                z6 = z5;
                mutableInteractionSource3 = mutableInteractionSource;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        modifier3 = companion;
                        z4 = z3;
                        radioButtonColors2 = radioButtonColorsColors;
                        mutableInteractionSource = null;
                    } else {
                        modifier3 = companion;
                        z4 = z3;
                        radioButtonColors2 = radioButtonColorsColors;
                    }
                } else {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        modifier3 = companion;
                        z4 = z3;
                        radioButtonColors2 = radioButtonColorsColors;
                        mutableInteractionSource = null;
                    } else {
                        modifier3 = companion;
                        z4 = z3;
                        radioButtonColors2 = radioButtonColorsColors;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(408580840, i3, -1, "androidx.compose.material3.RadioButton (RadioButton.kt:82)");
                }
                if (z) {
                    f = Dp.constructor-impl(RadioButtonDotSize / 2);
                } else {
                    f = Dp.constructor-impl(0);
                }
                stateM401animateDpAsStateAjpBEmI = AnimateAsStateKt.m401animateDpAsStateAjpBEmI(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composerStartRestartGroup, 48, 12);
                stateRadioColor$material3_release = radioButtonColors2.radioColor$material3_release(z4, z, composerStartRestartGroup, ((i3 >> 6) & 896) | ((i3 >> 9) & 14) | ((i3 << 3) & 112));
                composerStartRestartGroup.startReplaceGroup(1327106656);
                ComposerKt.sourceInformation(composerStartRestartGroup, "98@4448L164");
                if (function0 != null) {
                    z5 = z4;
                    companionM1362selectableO2vRcR0 = SelectableKt.m1362selectableO2vRcR0(Modifier.INSTANCE, z, mutableInteractionSource, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3834getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z5, Role.m6604boximpl(Role.INSTANCE.m6615getRadioButtono7Vup1c()), function0);
                } else {
                    z5 = z4;
                    companionM1362selectableO2vRcR0 = Modifier.INSTANCE;
                }
                composerStartRestartGroup.endReplaceGroup();
                if (function0 != null) {
                    companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
                } else {
                    companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
                }
                Modifier modifierM1072requiredSize3ABfNKs8 = SizeKt.m1072requiredSize3ABfNKs(PaddingKt.m1035padding3ABfNKs(SizeKt.wrapContentSize$default(modifier3.then(companionMinimumInteractiveComponentSize).then(companionM1362selectableO2vRcR0), Alignment.INSTANCE.getCenter(), r0, 2, null), RadioButtonPadding), RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1327137161, "CC(remember):RadioButton.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(stateRadioColor$material3_release) | composerStartRestartGroup.changed(stateM401animateDpAsStateAjpBEmI);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                            float f3 = 2;
                            float f4 = f2 / f3;
                            DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                            if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                                DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                            float f3 = 2;
                            float f4 = f2 / f3;
                            DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                            if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                                DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierM1072requiredSize3ABfNKs8, (Function1) objRememberedValue, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier3;
                radioButtonColors3 = radioButtonColors2;
                z6 = z5;
                mutableInteractionSource3 = mutableInteractionSource;
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

                    public final void invoke(Composer composer2, int i10) {
                        RadioButtonKt.RadioButton(z, function0, modifier2, z6, radioButtonColors3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        modifier2 = modifier;
        i4 = i2 & 8;
        if (i4 != 0) {
            if ((i & 3072) == 0) {
                z3 = z2;
                if (composerStartRestartGroup.changed(z3)) {
                    i5 = Fields.CameraDistance;
                } else {
                    i5 = Fields.RotationZ;
                }
                i3 |= i5;
            }
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    radioButtonColorsColors = radioButtonColors;
                    if (composerStartRestartGroup.changed(radioButtonColorsColors)) {
                        i8 = Fields.Clip;
                    }
                    i3 |= i8;
                } else {
                    radioButtonColorsColors = radioButtonColors;
                }
                i8 = Fields.Shape;
                i3 |= i8;
            } else {
                radioButtonColorsColors = radioButtonColors;
            }
            i6 = i2 & 32;
            if (i6 != 0) {
                if ((196608 & i) == 0) {
                    mutableInteractionSource2 = mutableInteractionSource;
                    if (composerStartRestartGroup.changed(mutableInteractionSource2)) {
                        i7 = Fields.RenderEffect;
                    } else {
                        i7 = 65536;
                    }
                    i3 |= i7;
                }
                if ((74899 & i3) == 74898) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i9 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            z3 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            modifier3 = companion;
                            z4 = z3;
                            radioButtonColors2 = radioButtonColorsColors;
                            mutableInteractionSource = null;
                        } else {
                            modifier3 = companion;
                            z4 = z3;
                            radioButtonColors2 = radioButtonColorsColors;
                        }
                    } else {
                        if (i9 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            z3 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            modifier3 = companion;
                            z4 = z3;
                            radioButtonColors2 = radioButtonColorsColors;
                            mutableInteractionSource = null;
                        } else {
                            modifier3 = companion;
                            z4 = z3;
                            radioButtonColors2 = radioButtonColorsColors;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(408580840, i3, -1, "androidx.compose.material3.RadioButton (RadioButton.kt:82)");
                    }
                    if (z) {
                        f = Dp.constructor-impl(RadioButtonDotSize / 2);
                    } else {
                        f = Dp.constructor-impl(0);
                    }
                    stateM401animateDpAsStateAjpBEmI = AnimateAsStateKt.m401animateDpAsStateAjpBEmI(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composerStartRestartGroup, 48, 12);
                    stateRadioColor$material3_release = radioButtonColors2.radioColor$material3_release(z4, z, composerStartRestartGroup, ((i3 >> 6) & 896) | ((i3 >> 9) & 14) | ((i3 << 3) & 112));
                    composerStartRestartGroup.startReplaceGroup(1327106656);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "98@4448L164");
                    if (function0 != null) {
                        z5 = z4;
                        companionM1362selectableO2vRcR0 = SelectableKt.m1362selectableO2vRcR0(Modifier.INSTANCE, z, mutableInteractionSource, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3834getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z5, Role.m6604boximpl(Role.INSTANCE.m6615getRadioButtono7Vup1c()), function0);
                    } else {
                        z5 = z4;
                        companionM1362selectableO2vRcR0 = Modifier.INSTANCE;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    if (function0 != null) {
                        companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
                    } else {
                        companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
                    }
                    Modifier modifierM1072requiredSize3ABfNKs9 = SizeKt.m1072requiredSize3ABfNKs(PaddingKt.m1035padding3ABfNKs(SizeKt.wrapContentSize$default(modifier3.then(companionMinimumInteractiveComponentSize).then(companionM1362selectableO2vRcR0), Alignment.INSTANCE.getCenter(), r0, 2, null), RadioButtonPadding), RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM());
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1327137161, "CC(remember):RadioButton.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(stateRadioColor$material3_release) | composerStartRestartGroup.changed(stateM401animateDpAsStateAjpBEmI);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                                float f3 = 2;
                                float f4 = f2 / f3;
                                DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                                    DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                }
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                                float f3 = 2;
                                float f4 = f2 / f3;
                                DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                                    DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                }
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierM1072requiredSize3ABfNKs9, (Function1) objRememberedValue, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier3;
                    radioButtonColors3 = radioButtonColors2;
                    z6 = z5;
                    mutableInteractionSource3 = mutableInteractionSource;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i9 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            z3 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            modifier3 = companion;
                            z4 = z3;
                            radioButtonColors2 = radioButtonColorsColors;
                            mutableInteractionSource = null;
                        } else {
                            modifier3 = companion;
                            z4 = z3;
                            radioButtonColors2 = radioButtonColorsColors;
                        }
                    } else {
                        if (i9 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            z3 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            modifier3 = companion;
                            z4 = z3;
                            radioButtonColors2 = radioButtonColorsColors;
                            mutableInteractionSource = null;
                        } else {
                            modifier3 = companion;
                            z4 = z3;
                            radioButtonColors2 = radioButtonColorsColors;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(408580840, i3, -1, "androidx.compose.material3.RadioButton (RadioButton.kt:82)");
                    }
                    if (z) {
                        f = Dp.constructor-impl(RadioButtonDotSize / 2);
                    } else {
                        f = Dp.constructor-impl(0);
                    }
                    stateM401animateDpAsStateAjpBEmI = AnimateAsStateKt.m401animateDpAsStateAjpBEmI(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composerStartRestartGroup, 48, 12);
                    stateRadioColor$material3_release = radioButtonColors2.radioColor$material3_release(z4, z, composerStartRestartGroup, ((i3 >> 6) & 896) | ((i3 >> 9) & 14) | ((i3 << 3) & 112));
                    composerStartRestartGroup.startReplaceGroup(1327106656);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "98@4448L164");
                    if (function0 != null) {
                        z5 = z4;
                        companionM1362selectableO2vRcR0 = SelectableKt.m1362selectableO2vRcR0(Modifier.INSTANCE, z, mutableInteractionSource, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3834getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z5, Role.m6604boximpl(Role.INSTANCE.m6615getRadioButtono7Vup1c()), function0);
                    } else {
                        z5 = z4;
                        companionM1362selectableO2vRcR0 = Modifier.INSTANCE;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    if (function0 != null) {
                        companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
                    } else {
                        companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
                    }
                    Modifier modifierM1072requiredSize3ABfNKs10 = SizeKt.m1072requiredSize3ABfNKs(PaddingKt.m1035padding3ABfNKs(SizeKt.wrapContentSize$default(modifier3.then(companionMinimumInteractiveComponentSize).then(companionM1362selectableO2vRcR0), Alignment.INSTANCE.getCenter(), r0, 2, null), RadioButtonPadding), RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM());
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1327137161, "CC(remember):RadioButton.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(stateRadioColor$material3_release) | composerStartRestartGroup.changed(stateM401animateDpAsStateAjpBEmI);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                                float f3 = 2;
                                float f4 = f2 / f3;
                                DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                                    DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                }
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                                float f3 = 2;
                                float f4 = f2 / f3;
                                DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                                    DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                                }
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierM1072requiredSize3ABfNKs10, (Function1) objRememberedValue, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier3;
                    radioButtonColors3 = radioButtonColors2;
                    z6 = z5;
                    mutableInteractionSource3 = mutableInteractionSource;
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

                        public final void invoke(Composer composer2, int i10) {
                            RadioButtonKt.RadioButton(z, function0, modifier2, z6, radioButtonColors3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            mutableInteractionSource2 = mutableInteractionSource;
            if ((74899 & i3) == 74898) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        modifier3 = companion;
                        z4 = z3;
                        radioButtonColors2 = radioButtonColorsColors;
                        mutableInteractionSource = null;
                    } else {
                        modifier3 = companion;
                        z4 = z3;
                        radioButtonColors2 = radioButtonColorsColors;
                    }
                } else {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        modifier3 = companion;
                        z4 = z3;
                        radioButtonColors2 = radioButtonColorsColors;
                        mutableInteractionSource = null;
                    } else {
                        modifier3 = companion;
                        z4 = z3;
                        radioButtonColors2 = radioButtonColorsColors;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(408580840, i3, -1, "androidx.compose.material3.RadioButton (RadioButton.kt:82)");
                }
                if (z) {
                    f = Dp.constructor-impl(RadioButtonDotSize / 2);
                } else {
                    f = Dp.constructor-impl(0);
                }
                stateM401animateDpAsStateAjpBEmI = AnimateAsStateKt.m401animateDpAsStateAjpBEmI(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composerStartRestartGroup, 48, 12);
                stateRadioColor$material3_release = radioButtonColors2.radioColor$material3_release(z4, z, composerStartRestartGroup, ((i3 >> 6) & 896) | ((i3 >> 9) & 14) | ((i3 << 3) & 112));
                composerStartRestartGroup.startReplaceGroup(1327106656);
                ComposerKt.sourceInformation(composerStartRestartGroup, "98@4448L164");
                if (function0 != null) {
                    z5 = z4;
                    companionM1362selectableO2vRcR0 = SelectableKt.m1362selectableO2vRcR0(Modifier.INSTANCE, z, mutableInteractionSource, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3834getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z5, Role.m6604boximpl(Role.INSTANCE.m6615getRadioButtono7Vup1c()), function0);
                } else {
                    z5 = z4;
                    companionM1362selectableO2vRcR0 = Modifier.INSTANCE;
                }
                composerStartRestartGroup.endReplaceGroup();
                if (function0 != null) {
                    companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
                } else {
                    companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
                }
                Modifier modifierM1072requiredSize3ABfNKs11 = SizeKt.m1072requiredSize3ABfNKs(PaddingKt.m1035padding3ABfNKs(SizeKt.wrapContentSize$default(modifier3.then(companionMinimumInteractiveComponentSize).then(companionM1362selectableO2vRcR0), Alignment.INSTANCE.getCenter(), r0, 2, null), RadioButtonPadding), RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1327137161, "CC(remember):RadioButton.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(stateRadioColor$material3_release) | composerStartRestartGroup.changed(stateM401animateDpAsStateAjpBEmI);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                            float f3 = 2;
                            float f4 = f2 / f3;
                            DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                            if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                                DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                            float f3 = 2;
                            float f4 = f2 / f3;
                            DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                            if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                                DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierM1072requiredSize3ABfNKs11, (Function1) objRememberedValue, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier3;
                radioButtonColors3 = radioButtonColors2;
                z6 = z5;
                mutableInteractionSource3 = mutableInteractionSource;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        modifier3 = companion;
                        z4 = z3;
                        radioButtonColors2 = radioButtonColorsColors;
                        mutableInteractionSource = null;
                    } else {
                        modifier3 = companion;
                        z4 = z3;
                        radioButtonColors2 = radioButtonColorsColors;
                    }
                } else {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        modifier3 = companion;
                        z4 = z3;
                        radioButtonColors2 = radioButtonColorsColors;
                        mutableInteractionSource = null;
                    } else {
                        modifier3 = companion;
                        z4 = z3;
                        radioButtonColors2 = radioButtonColorsColors;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(408580840, i3, -1, "androidx.compose.material3.RadioButton (RadioButton.kt:82)");
                }
                if (z) {
                    f = Dp.constructor-impl(RadioButtonDotSize / 2);
                } else {
                    f = Dp.constructor-impl(0);
                }
                stateM401animateDpAsStateAjpBEmI = AnimateAsStateKt.m401animateDpAsStateAjpBEmI(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composerStartRestartGroup, 48, 12);
                stateRadioColor$material3_release = radioButtonColors2.radioColor$material3_release(z4, z, composerStartRestartGroup, ((i3 >> 6) & 896) | ((i3 >> 9) & 14) | ((i3 << 3) & 112));
                composerStartRestartGroup.startReplaceGroup(1327106656);
                ComposerKt.sourceInformation(composerStartRestartGroup, "98@4448L164");
                if (function0 != null) {
                    z5 = z4;
                    companionM1362selectableO2vRcR0 = SelectableKt.m1362selectableO2vRcR0(Modifier.INSTANCE, z, mutableInteractionSource, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3834getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z5, Role.m6604boximpl(Role.INSTANCE.m6615getRadioButtono7Vup1c()), function0);
                } else {
                    z5 = z4;
                    companionM1362selectableO2vRcR0 = Modifier.INSTANCE;
                }
                composerStartRestartGroup.endReplaceGroup();
                if (function0 != null) {
                    companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
                } else {
                    companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
                }
                Modifier modifierM1072requiredSize3ABfNKs12 = SizeKt.m1072requiredSize3ABfNKs(PaddingKt.m1035padding3ABfNKs(SizeKt.wrapContentSize$default(modifier3.then(companionMinimumInteractiveComponentSize).then(companionM1362selectableO2vRcR0), Alignment.INSTANCE.getCenter(), r0, 2, null), RadioButtonPadding), RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1327137161, "CC(remember):RadioButton.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(stateRadioColor$material3_release) | composerStartRestartGroup.changed(stateM401animateDpAsStateAjpBEmI);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                            float f3 = 2;
                            float f4 = f2 / f3;
                            DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                            if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                                DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                            float f3 = 2;
                            float f4 = f2 / f3;
                            DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                            if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                                DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierM1072requiredSize3ABfNKs12, (Function1) objRememberedValue, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier3;
                radioButtonColors3 = radioButtonColors2;
                z6 = z5;
                mutableInteractionSource3 = mutableInteractionSource;
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

                    public final void invoke(Composer composer2, int i10) {
                        RadioButtonKt.RadioButton(z, function0, modifier2, z6, radioButtonColors3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        z3 = z2;
        if ((i & 24576) == 0) {
            if ((i2 & 16) == 0) {
                radioButtonColorsColors = radioButtonColors;
                if (composerStartRestartGroup.changed(radioButtonColorsColors)) {
                    i8 = Fields.Clip;
                }
                i3 |= i8;
            } else {
                radioButtonColorsColors = radioButtonColors;
            }
            i8 = Fields.Shape;
            i3 |= i8;
        } else {
            radioButtonColorsColors = radioButtonColors;
        }
        i6 = i2 & 32;
        if (i6 != 0) {
            if ((196608 & i) == 0) {
                mutableInteractionSource2 = mutableInteractionSource;
                if (composerStartRestartGroup.changed(mutableInteractionSource2)) {
                    i7 = Fields.RenderEffect;
                } else {
                    i7 = 65536;
                }
                i3 |= i7;
            }
            if ((74899 & i3) == 74898) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        modifier3 = companion;
                        z4 = z3;
                        radioButtonColors2 = radioButtonColorsColors;
                        mutableInteractionSource = null;
                    } else {
                        modifier3 = companion;
                        z4 = z3;
                        radioButtonColors2 = radioButtonColorsColors;
                    }
                } else {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        modifier3 = companion;
                        z4 = z3;
                        radioButtonColors2 = radioButtonColorsColors;
                        mutableInteractionSource = null;
                    } else {
                        modifier3 = companion;
                        z4 = z3;
                        radioButtonColors2 = radioButtonColorsColors;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(408580840, i3, -1, "androidx.compose.material3.RadioButton (RadioButton.kt:82)");
                }
                if (z) {
                    f = Dp.constructor-impl(RadioButtonDotSize / 2);
                } else {
                    f = Dp.constructor-impl(0);
                }
                stateM401animateDpAsStateAjpBEmI = AnimateAsStateKt.m401animateDpAsStateAjpBEmI(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composerStartRestartGroup, 48, 12);
                stateRadioColor$material3_release = radioButtonColors2.radioColor$material3_release(z4, z, composerStartRestartGroup, ((i3 >> 6) & 896) | ((i3 >> 9) & 14) | ((i3 << 3) & 112));
                composerStartRestartGroup.startReplaceGroup(1327106656);
                ComposerKt.sourceInformation(composerStartRestartGroup, "98@4448L164");
                if (function0 != null) {
                    z5 = z4;
                    companionM1362selectableO2vRcR0 = SelectableKt.m1362selectableO2vRcR0(Modifier.INSTANCE, z, mutableInteractionSource, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3834getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z5, Role.m6604boximpl(Role.INSTANCE.m6615getRadioButtono7Vup1c()), function0);
                } else {
                    z5 = z4;
                    companionM1362selectableO2vRcR0 = Modifier.INSTANCE;
                }
                composerStartRestartGroup.endReplaceGroup();
                if (function0 != null) {
                    companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
                } else {
                    companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
                }
                Modifier modifierM1072requiredSize3ABfNKs13 = SizeKt.m1072requiredSize3ABfNKs(PaddingKt.m1035padding3ABfNKs(SizeKt.wrapContentSize$default(modifier3.then(companionMinimumInteractiveComponentSize).then(companionM1362selectableO2vRcR0), Alignment.INSTANCE.getCenter(), r0, 2, null), RadioButtonPadding), RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1327137161, "CC(remember):RadioButton.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(stateRadioColor$material3_release) | composerStartRestartGroup.changed(stateM401animateDpAsStateAjpBEmI);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                            float f3 = 2;
                            float f4 = f2 / f3;
                            DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                            if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                                DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                            float f3 = 2;
                            float f4 = f2 / f3;
                            DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                            if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                                DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierM1072requiredSize3ABfNKs13, (Function1) objRememberedValue, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier3;
                radioButtonColors3 = radioButtonColors2;
                z6 = z5;
                mutableInteractionSource3 = mutableInteractionSource;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        modifier3 = companion;
                        z4 = z3;
                        radioButtonColors2 = radioButtonColorsColors;
                        mutableInteractionSource = null;
                    } else {
                        modifier3 = companion;
                        z4 = z3;
                        radioButtonColors2 = radioButtonColorsColors;
                    }
                } else {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        modifier3 = companion;
                        z4 = z3;
                        radioButtonColors2 = radioButtonColorsColors;
                        mutableInteractionSource = null;
                    } else {
                        modifier3 = companion;
                        z4 = z3;
                        radioButtonColors2 = radioButtonColorsColors;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(408580840, i3, -1, "androidx.compose.material3.RadioButton (RadioButton.kt:82)");
                }
                if (z) {
                    f = Dp.constructor-impl(RadioButtonDotSize / 2);
                } else {
                    f = Dp.constructor-impl(0);
                }
                stateM401animateDpAsStateAjpBEmI = AnimateAsStateKt.m401animateDpAsStateAjpBEmI(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composerStartRestartGroup, 48, 12);
                stateRadioColor$material3_release = radioButtonColors2.radioColor$material3_release(z4, z, composerStartRestartGroup, ((i3 >> 6) & 896) | ((i3 >> 9) & 14) | ((i3 << 3) & 112));
                composerStartRestartGroup.startReplaceGroup(1327106656);
                ComposerKt.sourceInformation(composerStartRestartGroup, "98@4448L164");
                if (function0 != null) {
                    z5 = z4;
                    companionM1362selectableO2vRcR0 = SelectableKt.m1362selectableO2vRcR0(Modifier.INSTANCE, z, mutableInteractionSource, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3834getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z5, Role.m6604boximpl(Role.INSTANCE.m6615getRadioButtono7Vup1c()), function0);
                } else {
                    z5 = z4;
                    companionM1362selectableO2vRcR0 = Modifier.INSTANCE;
                }
                composerStartRestartGroup.endReplaceGroup();
                if (function0 != null) {
                    companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
                } else {
                    companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
                }
                Modifier modifierM1072requiredSize3ABfNKs14 = SizeKt.m1072requiredSize3ABfNKs(PaddingKt.m1035padding3ABfNKs(SizeKt.wrapContentSize$default(modifier3.then(companionMinimumInteractiveComponentSize).then(companionM1362selectableO2vRcR0), Alignment.INSTANCE.getCenter(), r0, 2, null), RadioButtonPadding), RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1327137161, "CC(remember):RadioButton.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(stateRadioColor$material3_release) | composerStartRestartGroup.changed(stateM401animateDpAsStateAjpBEmI);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                            float f3 = 2;
                            float f4 = f2 / f3;
                            DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                            if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                                DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                            float f3 = 2;
                            float f4 = f2 / f3;
                            DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                            if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                                DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierM1072requiredSize3ABfNKs14, (Function1) objRememberedValue, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier3;
                radioButtonColors3 = radioButtonColors2;
                z6 = z5;
                mutableInteractionSource3 = mutableInteractionSource;
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

                    public final void invoke(Composer composer2, int i10) {
                        RadioButtonKt.RadioButton(z, function0, modifier2, z6, radioButtonColors3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 196608;
        mutableInteractionSource2 = mutableInteractionSource;
        if ((74899 & i3) == 74898) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i9 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    z3 = true;
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                }
                if (i6 != 0) {
                    modifier3 = companion;
                    z4 = z3;
                    radioButtonColors2 = radioButtonColorsColors;
                    mutableInteractionSource = null;
                } else {
                    modifier3 = companion;
                    z4 = z3;
                    radioButtonColors2 = radioButtonColorsColors;
                }
            } else {
                if (i9 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    z3 = true;
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                }
                if (i6 != 0) {
                    modifier3 = companion;
                    z4 = z3;
                    radioButtonColors2 = radioButtonColorsColors;
                    mutableInteractionSource = null;
                } else {
                    modifier3 = companion;
                    z4 = z3;
                    radioButtonColors2 = radioButtonColorsColors;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(408580840, i3, -1, "androidx.compose.material3.RadioButton (RadioButton.kt:82)");
            }
            if (z) {
                f = Dp.constructor-impl(RadioButtonDotSize / 2);
            } else {
                f = Dp.constructor-impl(0);
            }
            stateM401animateDpAsStateAjpBEmI = AnimateAsStateKt.m401animateDpAsStateAjpBEmI(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composerStartRestartGroup, 48, 12);
            stateRadioColor$material3_release = radioButtonColors2.radioColor$material3_release(z4, z, composerStartRestartGroup, ((i3 >> 6) & 896) | ((i3 >> 9) & 14) | ((i3 << 3) & 112));
            composerStartRestartGroup.startReplaceGroup(1327106656);
            ComposerKt.sourceInformation(composerStartRestartGroup, "98@4448L164");
            if (function0 != null) {
                z5 = z4;
                companionM1362selectableO2vRcR0 = SelectableKt.m1362selectableO2vRcR0(Modifier.INSTANCE, z, mutableInteractionSource, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3834getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z5, Role.m6604boximpl(Role.INSTANCE.m6615getRadioButtono7Vup1c()), function0);
            } else {
                z5 = z4;
                companionM1362selectableO2vRcR0 = Modifier.INSTANCE;
            }
            composerStartRestartGroup.endReplaceGroup();
            if (function0 != null) {
                companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
            } else {
                companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
            }
            Modifier modifierM1072requiredSize3ABfNKs15 = SizeKt.m1072requiredSize3ABfNKs(PaddingKt.m1035padding3ABfNKs(SizeKt.wrapContentSize$default(modifier3.then(companionMinimumInteractiveComponentSize).then(companionM1362selectableO2vRcR0), Alignment.INSTANCE.getCenter(), r0, 2, null), RadioButtonPadding), RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM());
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1327137161, "CC(remember):RadioButton.kt#9igjgp");
            zChanged = composerStartRestartGroup.changed(stateRadioColor$material3_release) | composerStartRestartGroup.changed(stateM401animateDpAsStateAjpBEmI);
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                        float f3 = 2;
                        float f4 = f2 / f3;
                        DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                        if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                            DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                        }
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                        float f3 = 2;
                        float f4 = f2 / f3;
                        DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                        if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                            DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                        }
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            CanvasKt.Canvas(modifierM1072requiredSize3ABfNKs15, (Function1) objRememberedValue, composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier2 = modifier3;
            radioButtonColors3 = radioButtonColors2;
            z6 = z5;
            mutableInteractionSource3 = mutableInteractionSource;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i9 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    z3 = true;
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                }
                if (i6 != 0) {
                    modifier3 = companion;
                    z4 = z3;
                    radioButtonColors2 = radioButtonColorsColors;
                    mutableInteractionSource = null;
                } else {
                    modifier3 = companion;
                    z4 = z3;
                    radioButtonColors2 = radioButtonColorsColors;
                }
            } else {
                if (i9 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    z3 = true;
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    radioButtonColorsColors = RadioButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                }
                if (i6 != 0) {
                    modifier3 = companion;
                    z4 = z3;
                    radioButtonColors2 = radioButtonColorsColors;
                    mutableInteractionSource = null;
                } else {
                    modifier3 = companion;
                    z4 = z3;
                    radioButtonColors2 = radioButtonColorsColors;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(408580840, i3, -1, "androidx.compose.material3.RadioButton (RadioButton.kt:82)");
            }
            if (z) {
                f = Dp.constructor-impl(RadioButtonDotSize / 2);
            } else {
                f = Dp.constructor-impl(0);
            }
            stateM401animateDpAsStateAjpBEmI = AnimateAsStateKt.m401animateDpAsStateAjpBEmI(f, AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composerStartRestartGroup, 48, 12);
            stateRadioColor$material3_release = radioButtonColors2.radioColor$material3_release(z4, z, composerStartRestartGroup, ((i3 >> 6) & 896) | ((i3 >> 9) & 14) | ((i3 << 3) & 112));
            composerStartRestartGroup.startReplaceGroup(1327106656);
            ComposerKt.sourceInformation(composerStartRestartGroup, "98@4448L164");
            if (function0 != null) {
                z5 = z4;
                companionM1362selectableO2vRcR0 = SelectableKt.m1362selectableO2vRcR0(Modifier.INSTANCE, z, mutableInteractionSource, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3834getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z5, Role.m6604boximpl(Role.INSTANCE.m6615getRadioButtono7Vup1c()), function0);
            } else {
                z5 = z4;
                companionM1362selectableO2vRcR0 = Modifier.INSTANCE;
            }
            composerStartRestartGroup.endReplaceGroup();
            if (function0 != null) {
                companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
            } else {
                companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
            }
            Modifier modifierM1072requiredSize3ABfNKs16 = SizeKt.m1072requiredSize3ABfNKs(PaddingKt.m1035padding3ABfNKs(SizeKt.wrapContentSize$default(modifier3.then(companionMinimumInteractiveComponentSize).then(companionM1362selectableO2vRcR0), Alignment.INSTANCE.getCenter(), r0, 2, null), RadioButtonPadding), RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM());
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1327137161, "CC(remember):RadioButton.kt#9igjgp");
            zChanged = composerStartRestartGroup.changed(stateRadioColor$material3_release) | composerStartRestartGroup.changed(stateM401animateDpAsStateAjpBEmI);
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                        float f3 = 2;
                        float f4 = f2 / f3;
                        DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                        if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                            DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                        }
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        float f2 = drawScope.toPx-0680j_4(RadioButtonKt.RadioStrokeWidth);
                        float f3 = 2;
                        float f4 = f2 / f3;
                        DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(Dp.constructor-impl(RadioButtonTokens.INSTANCE.m3833getIconSizeD9Ej5fM() / f3)) - f4, 0L, 0.0f, new Stroke(f2, 0.0f, 0, 0, null, 30, null), null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                        if (Dp.compareTo-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl(), Dp.constructor-impl(0)) > 0) {
                            DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, stateRadioColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(stateM401animateDpAsStateAjpBEmI.getValue().unbox-impl()) - f4, 0L, 0.0f, Fill.INSTANCE, null, 0, AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR, null);
                        }
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            CanvasKt.Canvas(modifierM1072requiredSize3ABfNKs16, (Function1) objRememberedValue, composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier2 = modifier3;
            radioButtonColors3 = radioButtonColors2;
            z6 = z5;
            mutableInteractionSource3 = mutableInteractionSource;
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

                public final void invoke(Composer composer2, int i10) {
                    RadioButtonKt.RadioButton(z, function0, modifier2, z6, radioButtonColors3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    static {
        float f = 2;
        RadioButtonPadding = Dp.constructor-impl(f);
        RadioStrokeWidth = Dp.constructor-impl(f);
    }
}
