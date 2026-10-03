package androidx.compose.material3;

import androidx.compose.animation.core.AnimationSpecKt;
import androidx.compose.animation.core.AnimationVector1D;
import androidx.compose.animation.core.FiniteAnimationSpec;
import androidx.compose.animation.core.SpringSpec;
import androidx.compose.animation.core.Transition;
import androidx.compose.animation.core.TransitionKt;
import androidx.compose.animation.core.TweenSpec;
import androidx.compose.animation.core.TwoWayConverter;
import androidx.compose.animation.core.VectorConvertersKt;
import androidx.compose.foundation.CanvasKt;
import androidx.compose.foundation.interaction.MutableInteractionSource;
import androidx.compose.foundation.layout.PaddingKt;
import androidx.compose.foundation.layout.SizeKt;
import androidx.compose.foundation.selection.ToggleableKt;
import androidx.compose.material3.tokens.CheckboxTokens;
import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.geometry.CornerRadiusKt;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.geometry.Size;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.StrokeCap;
import androidx.compose.p002ui.graphics.drawscope.DrawScope;
import androidx.compose.p002ui.graphics.drawscope.Fill;
import androidx.compose.p002ui.graphics.drawscope.Stroke;
import androidx.compose.p002ui.semantics.Role;
import androidx.compose.p002ui.state.ToggleableState;
import androidx.compose.p002ui.state.ToggleableStateKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.State;
import androidx.compose.ui.unit.Dp;
import androidx.compose.ui.util.MathHelpersKt;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.FloatCompanionObject;

@Metadata(d1 = {"\u0000h\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\b\u0003\u001aU\u0010\n\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\r2\u0014\u0010\u000e\u001a\u0010\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\u000b\u0018\u00010\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\b\b\u0002\u0010\u0012\u001a\u00020\r2\b\b\u0002\u0010\u0013\u001a\u00020\u00142\n\b\u0002\u0010\u0015\u001a\u0004\u0018\u00010\u0016H\u0007¢\u0006\u0002\u0010\u0017\u001a-\u0010\u0018\u001a\u00020\u000b2\u0006\u0010\u0012\u001a\u00020\r2\u0006\u0010\u0019\u001a\u00020\u001a2\u0006\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0013\u001a\u00020\u0014H\u0003¢\u0006\u0002\u0010\u001b\u001aO\u0010\u001c\u001a\u00020\u000b2\u0006\u0010\u001d\u001a\u00020\u001a2\u000e\u0010\u001e\u001a\n\u0012\u0004\u0012\u00020\u000b\u0018\u00010\u001f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\b\b\u0002\u0010\u0012\u001a\u00020\r2\b\b\u0002\u0010\u0013\u001a\u00020\u00142\n\b\u0002\u0010\u0015\u001a\u0004\u0018\u00010\u0016H\u0007¢\u0006\u0002\u0010 \u001a6\u0010!\u001a\u00020\u000b*\u00020\"2\u0006\u0010#\u001a\u00020$2\u0006\u0010%\u001a\u00020$2\u0006\u0010&\u001a\u00020'2\u0006\u0010(\u001a\u00020'H\u0002ø\u0001\u0000¢\u0006\u0004\b)\u0010*\u001a>\u0010+\u001a\u00020\u000b*\u00020\"2\u0006\u0010,\u001a\u00020$2\u0006\u0010-\u001a\u00020'2\u0006\u0010.\u001a\u00020'2\u0006\u0010/\u001a\u00020'2\u0006\u00100\u001a\u000201H\u0002ø\u0001\u0000¢\u0006\u0004\b2\u00103\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\u0002\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\u0003\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000\"\u0010\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0006\"\u0010\u0010\u0007\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0006\"\u0010\u0010\b\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0006\"\u0010\u0010\t\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0006\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u00064"}, d2 = {"BoxInDuration", "", "BoxOutDuration", "CheckAnimationDuration", "CheckboxDefaultPadding", "Landroidx/compose/ui/unit/Dp;", "F", "CheckboxSize", "RadiusSize", "StrokeWidth", "Checkbox", "", "checked", "", "onCheckedChange", "Lkotlin/Function1;", "modifier", "Landroidx/compose/ui/Modifier;", "enabled", "colors", "Landroidx/compose/material3/CheckboxColors;", "interactionSource", "Landroidx/compose/foundation/interaction/MutableInteractionSource;", "(ZLkotlin/jvm/functions/Function1;Landroidx/compose/ui/Modifier;ZLandroidx/compose/material3/CheckboxColors;Landroidx/compose/foundation/interaction/MutableInteractionSource;Landroidx/compose/runtime/Composer;II)V", "CheckboxImpl", "value", "Landroidx/compose/ui/state/ToggleableState;", "(ZLandroidx/compose/ui/state/ToggleableState;Landroidx/compose/ui/Modifier;Landroidx/compose/material3/CheckboxColors;Landroidx/compose/runtime/Composer;I)V", "TriStateCheckbox", "state", "onClick", "Lkotlin/Function0;", "(Landroidx/compose/ui/state/ToggleableState;Lkotlin/jvm/functions/Function0;Landroidx/compose/ui/Modifier;ZLandroidx/compose/material3/CheckboxColors;Landroidx/compose/foundation/interaction/MutableInteractionSource;Landroidx/compose/runtime/Composer;II)V", "drawBox", "Landroidx/compose/ui/graphics/drawscope/DrawScope;", "boxColor", "Landroidx/compose/ui/graphics/Color;", "borderColor", "radius", "", "strokeWidth", "drawBox-1wkBAMs", "(Landroidx/compose/ui/graphics/drawscope/DrawScope;JJFF)V", "drawCheck", "checkColor", "checkFraction", "crossCenterGravitation", "strokeWidthPx", "drawingCache", "Landroidx/compose/material3/CheckDrawingCache;", "drawCheck-3IgeMak", "(Landroidx/compose/ui/graphics/drawscope/DrawScope;JFFFLandroidx/compose/material3/CheckDrawingCache;)V", "material3_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class CheckboxKt {
    private static final int BoxInDuration = 50;
    private static final int BoxOutDuration = 100;
    private static final int CheckAnimationDuration = 100;
    private static final float CheckboxDefaultPadding;
    private static final float CheckboxSize = Dp.constructor-impl(20);
    private static final float RadiusSize;
    private static final float StrokeWidth;

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[ToggleableState.values().length];
            try {
                iArr[ToggleableState.On.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[ToggleableState.Off.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[ToggleableState.Indeterminate.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public static final void Checkbox(final boolean z, final Function1<? super Boolean, Unit> function1, Modifier modifier, boolean z2, CheckboxColors checkboxColors, MutableInteractionSource mutableInteractionSource, Composer composer, final int i, final int i2) throws NoWhenBranchMatchedException {
        int i3;
        Modifier modifier2;
        int i4;
        boolean z3;
        int i5;
        CheckboxColors checkboxColorsColors;
        int i6;
        MutableInteractionSource mutableInteractionSource2;
        int i7;
        boolean z4;
        CheckboxColors checkboxColors2;
        MutableInteractionSource mutableInteractionSource3;
        int i8;
        Function0 function0;
        final boolean z5;
        final CheckboxColors checkboxColors3;
        final MutableInteractionSource mutableInteractionSource4;
        boolean z6;
        boolean z7;
        Object objRememberedValue;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i9;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1406741137);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(Checkbox)P(!1,5,4,2)96@4296L8,99@4370L356:Checkbox.kt#uh7d8r");
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
            i3 |= composerStartRestartGroup.changedInstance(function1) ? 32 : 16;
        }
        int i10 = i2 & 4;
        if (i10 == 0) {
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
                        checkboxColorsColors = checkboxColors;
                        if (composerStartRestartGroup.changed(checkboxColorsColors)) {
                            i9 = Fields.Clip;
                        }
                        i3 |= i9;
                    } else {
                        checkboxColorsColors = checkboxColors;
                    }
                    i9 = Fields.Shape;
                    i3 |= i9;
                } else {
                    checkboxColorsColors = checkboxColors;
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
                            if (i10 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if (i4 != 0) {
                                z3 = true;
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                            if (i6 != 0) {
                                z4 = z3;
                                checkboxColors2 = checkboxColorsColors;
                                mutableInteractionSource3 = null;
                            }
                            Modifier modifier3 = modifier2;
                            i8 = i3;
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1406741137, i8, -1, "androidx.compose.material3.Checkbox (Checkbox.kt:98)");
                            }
                            ToggleableState ToggleableState = ToggleableStateKt.ToggleableState(z);
                            composerStartRestartGroup.startReplaceGroup(1046936362);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "103@4507L29");
                            if (function1 != null) {
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1046937763, "CC(remember):Checkbox.kt#9igjgp");
                                if ((i8 & 112) == 32) {
                                    z6 = true;
                                } else {
                                    z6 = false;
                                }
                                z7 = z6 | ((i8 & 14) == 4);
                                objRememberedValue = composerStartRestartGroup.rememberedValue();
                                if (!z7 || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = (Function0) new Function0<Unit>() {
                                        {
                                            super(0);
                                        }

                                        public Object invoke() {
                                            m2095invoke();
                                            return Unit.INSTANCE;
                                        }

                                        public final void m2095invoke() {
                                            function1.invoke(Boolean.valueOf(!z));
                                        }
                                    };
                                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                                }
                                function0 = (Function0) objRememberedValue;
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            } else {
                                function0 = null;
                            }
                            composerStartRestartGroup.endReplaceGroup();
                            TriStateCheckbox(ToggleableState, function0, modifier3, z4, checkboxColors2, mutableInteractionSource3, composerStartRestartGroup, i8 & 524160, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier2 = modifier3;
                            z5 = z4;
                            checkboxColors3 = checkboxColors2;
                            mutableInteractionSource4 = mutableInteractionSource3;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                            }
                        }
                        z4 = z3;
                        checkboxColors2 = checkboxColorsColors;
                        mutableInteractionSource3 = mutableInteractionSource2;
                        Modifier modifier4 = modifier2;
                        i8 = i3;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1406741137, i8, -1, "androidx.compose.material3.Checkbox (Checkbox.kt:98)");
                        }
                        ToggleableState ToggleableState2 = ToggleableStateKt.ToggleableState(z);
                        composerStartRestartGroup.startReplaceGroup(1046936362);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "103@4507L29");
                        if (function1 != null) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1046937763, "CC(remember):Checkbox.kt#9igjgp");
                            if ((i8 & 112) == 32) {
                                z6 = true;
                            } else {
                                z6 = false;
                            }
                            z7 = z6 | ((i8 & 14) == 4);
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z7) {
                                objRememberedValue = (Function0) new Function0<Unit>() {
                                    {
                                        super(0);
                                    }

                                    public Object invoke() {
                                        m2095invoke();
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2095invoke() {
                                        function1.invoke(Boolean.valueOf(!z));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = (Function0) new Function0<Unit>() {
                                    {
                                        super(0);
                                    }

                                    public Object invoke() {
                                        m2095invoke();
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2095invoke() {
                                        function1.invoke(Boolean.valueOf(!z));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            function0 = (Function0) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        } else {
                            function0 = null;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        TriStateCheckbox(ToggleableState2, function0, modifier4, z4, checkboxColors2, mutableInteractionSource3, composerStartRestartGroup, i8 & 524160, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = modifier4;
                        z5 = z4;
                        checkboxColors3 = checkboxColors2;
                        mutableInteractionSource4 = mutableInteractionSource3;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        z5 = z3;
                        checkboxColors3 = checkboxColorsColors;
                        mutableInteractionSource4 = mutableInteractionSource2;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier5 = modifier2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) throws NoWhenBranchMatchedException {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11) throws NoWhenBranchMatchedException {
                                CheckboxKt.Checkbox(z, function1, modifier5, z5, checkboxColors3, mutableInteractionSource4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                mutableInteractionSource2 = mutableInteractionSource;
                if ((74899 & i3) == 74898) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i10 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z3 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            z4 = z3;
                            checkboxColors2 = checkboxColorsColors;
                            mutableInteractionSource3 = null;
                        } else {
                            z4 = z3;
                            checkboxColors2 = checkboxColorsColors;
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                    } else {
                        if (i10 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z3 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            z4 = z3;
                            checkboxColors2 = checkboxColorsColors;
                            mutableInteractionSource3 = null;
                        } else {
                            z4 = z3;
                            checkboxColors2 = checkboxColorsColors;
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                    }
                    Modifier modifier6 = modifier2;
                    i8 = i3;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1406741137, i8, -1, "androidx.compose.material3.Checkbox (Checkbox.kt:98)");
                    }
                    ToggleableState ToggleableState3 = ToggleableStateKt.ToggleableState(z);
                    composerStartRestartGroup.startReplaceGroup(1046936362);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "103@4507L29");
                    if (function1 != null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1046937763, "CC(remember):Checkbox.kt#9igjgp");
                        if ((i8 & 112) == 32) {
                            z6 = true;
                        } else {
                            z6 = false;
                        }
                        z7 = z6 | ((i8 & 14) == 4);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z7) {
                            objRememberedValue = (Function0) new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                public Object invoke() {
                                    m2095invoke();
                                    return Unit.INSTANCE;
                                }

                                public final void m2095invoke() {
                                    function1.invoke(Boolean.valueOf(!z));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function0) new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                public Object invoke() {
                                    m2095invoke();
                                    return Unit.INSTANCE;
                                }

                                public final void m2095invoke() {
                                    function1.invoke(Boolean.valueOf(!z));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function0 = (Function0) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    } else {
                        function0 = null;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    TriStateCheckbox(ToggleableState3, function0, modifier6, z4, checkboxColors2, mutableInteractionSource3, composerStartRestartGroup, i8 & 524160, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier6;
                    z5 = z4;
                    checkboxColors3 = checkboxColors2;
                    mutableInteractionSource4 = mutableInteractionSource3;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i10 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z3 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            z4 = z3;
                            checkboxColors2 = checkboxColorsColors;
                            mutableInteractionSource3 = null;
                        } else {
                            z4 = z3;
                            checkboxColors2 = checkboxColorsColors;
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                    } else {
                        if (i10 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z3 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            z4 = z3;
                            checkboxColors2 = checkboxColorsColors;
                            mutableInteractionSource3 = null;
                        } else {
                            z4 = z3;
                            checkboxColors2 = checkboxColorsColors;
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                    }
                    Modifier modifier7 = modifier2;
                    i8 = i3;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1406741137, i8, -1, "androidx.compose.material3.Checkbox (Checkbox.kt:98)");
                    }
                    ToggleableState ToggleableState4 = ToggleableStateKt.ToggleableState(z);
                    composerStartRestartGroup.startReplaceGroup(1046936362);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "103@4507L29");
                    if (function1 != null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1046937763, "CC(remember):Checkbox.kt#9igjgp");
                        if ((i8 & 112) == 32) {
                            z6 = true;
                        } else {
                            z6 = false;
                        }
                        z7 = z6 | ((i8 & 14) == 4);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z7) {
                            objRememberedValue = (Function0) new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                public Object invoke() {
                                    m2095invoke();
                                    return Unit.INSTANCE;
                                }

                                public final void m2095invoke() {
                                    function1.invoke(Boolean.valueOf(!z));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function0) new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                public Object invoke() {
                                    m2095invoke();
                                    return Unit.INSTANCE;
                                }

                                public final void m2095invoke() {
                                    function1.invoke(Boolean.valueOf(!z));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function0 = (Function0) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    } else {
                        function0 = null;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    TriStateCheckbox(ToggleableState4, function0, modifier7, z4, checkboxColors2, mutableInteractionSource3, composerStartRestartGroup, i8 & 524160, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier7;
                    z5 = z4;
                    checkboxColors3 = checkboxColors2;
                    mutableInteractionSource4 = mutableInteractionSource3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier8 = modifier2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) throws NoWhenBranchMatchedException {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) throws NoWhenBranchMatchedException {
                            CheckboxKt.Checkbox(z, function1, modifier8, z5, checkboxColors3, mutableInteractionSource4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            z3 = z2;
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    checkboxColorsColors = checkboxColors;
                    if (composerStartRestartGroup.changed(checkboxColorsColors)) {
                        i9 = Fields.Clip;
                    }
                    i3 |= i9;
                } else {
                    checkboxColorsColors = checkboxColors;
                }
                i9 = Fields.Shape;
                i3 |= i9;
            } else {
                checkboxColorsColors = checkboxColors;
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
                        if (i10 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z3 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            z4 = z3;
                            checkboxColors2 = checkboxColorsColors;
                            mutableInteractionSource3 = null;
                        } else {
                            z4 = z3;
                            checkboxColors2 = checkboxColorsColors;
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                    } else {
                        if (i10 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z3 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            z4 = z3;
                            checkboxColors2 = checkboxColorsColors;
                            mutableInteractionSource3 = null;
                        } else {
                            z4 = z3;
                            checkboxColors2 = checkboxColorsColors;
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                    }
                    Modifier modifier9 = modifier2;
                    i8 = i3;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1406741137, i8, -1, "androidx.compose.material3.Checkbox (Checkbox.kt:98)");
                    }
                    ToggleableState ToggleableState5 = ToggleableStateKt.ToggleableState(z);
                    composerStartRestartGroup.startReplaceGroup(1046936362);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "103@4507L29");
                    if (function1 != null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1046937763, "CC(remember):Checkbox.kt#9igjgp");
                        if ((i8 & 112) == 32) {
                            z6 = true;
                        } else {
                            z6 = false;
                        }
                        z7 = z6 | ((i8 & 14) == 4);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z7) {
                            objRememberedValue = (Function0) new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                public Object invoke() {
                                    m2095invoke();
                                    return Unit.INSTANCE;
                                }

                                public final void m2095invoke() {
                                    function1.invoke(Boolean.valueOf(!z));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function0) new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                public Object invoke() {
                                    m2095invoke();
                                    return Unit.INSTANCE;
                                }

                                public final void m2095invoke() {
                                    function1.invoke(Boolean.valueOf(!z));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function0 = (Function0) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    } else {
                        function0 = null;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    TriStateCheckbox(ToggleableState5, function0, modifier9, z4, checkboxColors2, mutableInteractionSource3, composerStartRestartGroup, i8 & 524160, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier9;
                    z5 = z4;
                    checkboxColors3 = checkboxColors2;
                    mutableInteractionSource4 = mutableInteractionSource3;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i10 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z3 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            z4 = z3;
                            checkboxColors2 = checkboxColorsColors;
                            mutableInteractionSource3 = null;
                        } else {
                            z4 = z3;
                            checkboxColors2 = checkboxColorsColors;
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                    } else {
                        if (i10 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z3 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            z4 = z3;
                            checkboxColors2 = checkboxColorsColors;
                            mutableInteractionSource3 = null;
                        } else {
                            z4 = z3;
                            checkboxColors2 = checkboxColorsColors;
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                    }
                    Modifier modifier10 = modifier2;
                    i8 = i3;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1406741137, i8, -1, "androidx.compose.material3.Checkbox (Checkbox.kt:98)");
                    }
                    ToggleableState ToggleableState6 = ToggleableStateKt.ToggleableState(z);
                    composerStartRestartGroup.startReplaceGroup(1046936362);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "103@4507L29");
                    if (function1 != null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1046937763, "CC(remember):Checkbox.kt#9igjgp");
                        if ((i8 & 112) == 32) {
                            z6 = true;
                        } else {
                            z6 = false;
                        }
                        z7 = z6 | ((i8 & 14) == 4);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z7) {
                            objRememberedValue = (Function0) new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                public Object invoke() {
                                    m2095invoke();
                                    return Unit.INSTANCE;
                                }

                                public final void m2095invoke() {
                                    function1.invoke(Boolean.valueOf(!z));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function0) new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                public Object invoke() {
                                    m2095invoke();
                                    return Unit.INSTANCE;
                                }

                                public final void m2095invoke() {
                                    function1.invoke(Boolean.valueOf(!z));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function0 = (Function0) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    } else {
                        function0 = null;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    TriStateCheckbox(ToggleableState6, function0, modifier10, z4, checkboxColors2, mutableInteractionSource3, composerStartRestartGroup, i8 & 524160, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier10;
                    z5 = z4;
                    checkboxColors3 = checkboxColors2;
                    mutableInteractionSource4 = mutableInteractionSource3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier11 = modifier2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) throws NoWhenBranchMatchedException {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) throws NoWhenBranchMatchedException {
                            CheckboxKt.Checkbox(z, function1, modifier11, z5, checkboxColors3, mutableInteractionSource4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            mutableInteractionSource2 = mutableInteractionSource;
            if ((74899 & i3) == 74898) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i10 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        z4 = z3;
                        checkboxColors2 = checkboxColorsColors;
                        mutableInteractionSource3 = null;
                    } else {
                        z4 = z3;
                        checkboxColors2 = checkboxColorsColors;
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                } else {
                    if (i10 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        z4 = z3;
                        checkboxColors2 = checkboxColorsColors;
                        mutableInteractionSource3 = null;
                    } else {
                        z4 = z3;
                        checkboxColors2 = checkboxColorsColors;
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                }
                Modifier modifier12 = modifier2;
                i8 = i3;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1406741137, i8, -1, "androidx.compose.material3.Checkbox (Checkbox.kt:98)");
                }
                ToggleableState ToggleableState7 = ToggleableStateKt.ToggleableState(z);
                composerStartRestartGroup.startReplaceGroup(1046936362);
                ComposerKt.sourceInformation(composerStartRestartGroup, "103@4507L29");
                if (function1 != null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1046937763, "CC(remember):Checkbox.kt#9igjgp");
                    if ((i8 & 112) == 32) {
                        z6 = true;
                    } else {
                        z6 = false;
                    }
                    z7 = z6 | ((i8 & 14) == 4);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z7) {
                        objRememberedValue = (Function0) new Function0<Unit>() {
                            {
                                super(0);
                            }

                            public Object invoke() {
                                m2095invoke();
                                return Unit.INSTANCE;
                            }

                            public final void m2095invoke() {
                                function1.invoke(Boolean.valueOf(!z));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function0) new Function0<Unit>() {
                            {
                                super(0);
                            }

                            public Object invoke() {
                                m2095invoke();
                                return Unit.INSTANCE;
                            }

                            public final void m2095invoke() {
                                function1.invoke(Boolean.valueOf(!z));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    function0 = (Function0) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                } else {
                    function0 = null;
                }
                composerStartRestartGroup.endReplaceGroup();
                TriStateCheckbox(ToggleableState7, function0, modifier12, z4, checkboxColors2, mutableInteractionSource3, composerStartRestartGroup, i8 & 524160, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier12;
                z5 = z4;
                checkboxColors3 = checkboxColors2;
                mutableInteractionSource4 = mutableInteractionSource3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i10 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        z4 = z3;
                        checkboxColors2 = checkboxColorsColors;
                        mutableInteractionSource3 = null;
                    } else {
                        z4 = z3;
                        checkboxColors2 = checkboxColorsColors;
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                } else {
                    if (i10 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        z4 = z3;
                        checkboxColors2 = checkboxColorsColors;
                        mutableInteractionSource3 = null;
                    } else {
                        z4 = z3;
                        checkboxColors2 = checkboxColorsColors;
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                }
                Modifier modifier13 = modifier2;
                i8 = i3;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1406741137, i8, -1, "androidx.compose.material3.Checkbox (Checkbox.kt:98)");
                }
                ToggleableState ToggleableState8 = ToggleableStateKt.ToggleableState(z);
                composerStartRestartGroup.startReplaceGroup(1046936362);
                ComposerKt.sourceInformation(composerStartRestartGroup, "103@4507L29");
                if (function1 != null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1046937763, "CC(remember):Checkbox.kt#9igjgp");
                    if ((i8 & 112) == 32) {
                        z6 = true;
                    } else {
                        z6 = false;
                    }
                    z7 = z6 | ((i8 & 14) == 4);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z7) {
                        objRememberedValue = (Function0) new Function0<Unit>() {
                            {
                                super(0);
                            }

                            public Object invoke() {
                                m2095invoke();
                                return Unit.INSTANCE;
                            }

                            public final void m2095invoke() {
                                function1.invoke(Boolean.valueOf(!z));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function0) new Function0<Unit>() {
                            {
                                super(0);
                            }

                            public Object invoke() {
                                m2095invoke();
                                return Unit.INSTANCE;
                            }

                            public final void m2095invoke() {
                                function1.invoke(Boolean.valueOf(!z));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    function0 = (Function0) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                } else {
                    function0 = null;
                }
                composerStartRestartGroup.endReplaceGroup();
                TriStateCheckbox(ToggleableState8, function0, modifier13, z4, checkboxColors2, mutableInteractionSource3, composerStartRestartGroup, i8 & 524160, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier13;
                z5 = z4;
                checkboxColors3 = checkboxColors2;
                mutableInteractionSource4 = mutableInteractionSource3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier14 = modifier2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) throws NoWhenBranchMatchedException {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11) throws NoWhenBranchMatchedException {
                        CheckboxKt.Checkbox(z, function1, modifier14, z5, checkboxColors3, mutableInteractionSource4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
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
                    checkboxColorsColors = checkboxColors;
                    if (composerStartRestartGroup.changed(checkboxColorsColors)) {
                        i9 = Fields.Clip;
                    }
                    i3 |= i9;
                } else {
                    checkboxColorsColors = checkboxColors;
                }
                i9 = Fields.Shape;
                i3 |= i9;
            } else {
                checkboxColorsColors = checkboxColors;
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
                        if (i10 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z3 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            z4 = z3;
                            checkboxColors2 = checkboxColorsColors;
                            mutableInteractionSource3 = null;
                        } else {
                            z4 = z3;
                            checkboxColors2 = checkboxColorsColors;
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                    } else {
                        if (i10 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z3 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            z4 = z3;
                            checkboxColors2 = checkboxColorsColors;
                            mutableInteractionSource3 = null;
                        } else {
                            z4 = z3;
                            checkboxColors2 = checkboxColorsColors;
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                    }
                    Modifier modifier15 = modifier2;
                    i8 = i3;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1406741137, i8, -1, "androidx.compose.material3.Checkbox (Checkbox.kt:98)");
                    }
                    ToggleableState ToggleableState9 = ToggleableStateKt.ToggleableState(z);
                    composerStartRestartGroup.startReplaceGroup(1046936362);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "103@4507L29");
                    if (function1 != null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1046937763, "CC(remember):Checkbox.kt#9igjgp");
                        if ((i8 & 112) == 32) {
                            z6 = true;
                        } else {
                            z6 = false;
                        }
                        z7 = z6 | ((i8 & 14) == 4);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z7) {
                            objRememberedValue = (Function0) new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                public Object invoke() {
                                    m2095invoke();
                                    return Unit.INSTANCE;
                                }

                                public final void m2095invoke() {
                                    function1.invoke(Boolean.valueOf(!z));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function0) new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                public Object invoke() {
                                    m2095invoke();
                                    return Unit.INSTANCE;
                                }

                                public final void m2095invoke() {
                                    function1.invoke(Boolean.valueOf(!z));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function0 = (Function0) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    } else {
                        function0 = null;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    TriStateCheckbox(ToggleableState9, function0, modifier15, z4, checkboxColors2, mutableInteractionSource3, composerStartRestartGroup, i8 & 524160, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier15;
                    z5 = z4;
                    checkboxColors3 = checkboxColors2;
                    mutableInteractionSource4 = mutableInteractionSource3;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i10 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z3 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            z4 = z3;
                            checkboxColors2 = checkboxColorsColors;
                            mutableInteractionSource3 = null;
                        } else {
                            z4 = z3;
                            checkboxColors2 = checkboxColorsColors;
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                    } else {
                        if (i10 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            z3 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            z4 = z3;
                            checkboxColors2 = checkboxColorsColors;
                            mutableInteractionSource3 = null;
                        } else {
                            z4 = z3;
                            checkboxColors2 = checkboxColorsColors;
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                    }
                    Modifier modifier16 = modifier2;
                    i8 = i3;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1406741137, i8, -1, "androidx.compose.material3.Checkbox (Checkbox.kt:98)");
                    }
                    ToggleableState ToggleableState10 = ToggleableStateKt.ToggleableState(z);
                    composerStartRestartGroup.startReplaceGroup(1046936362);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "103@4507L29");
                    if (function1 != null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1046937763, "CC(remember):Checkbox.kt#9igjgp");
                        if ((i8 & 112) == 32) {
                            z6 = true;
                        } else {
                            z6 = false;
                        }
                        z7 = z6 | ((i8 & 14) == 4);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z7) {
                            objRememberedValue = (Function0) new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                public Object invoke() {
                                    m2095invoke();
                                    return Unit.INSTANCE;
                                }

                                public final void m2095invoke() {
                                    function1.invoke(Boolean.valueOf(!z));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function0) new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                public Object invoke() {
                                    m2095invoke();
                                    return Unit.INSTANCE;
                                }

                                public final void m2095invoke() {
                                    function1.invoke(Boolean.valueOf(!z));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function0 = (Function0) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    } else {
                        function0 = null;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    TriStateCheckbox(ToggleableState10, function0, modifier16, z4, checkboxColors2, mutableInteractionSource3, composerStartRestartGroup, i8 & 524160, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier16;
                    z5 = z4;
                    checkboxColors3 = checkboxColors2;
                    mutableInteractionSource4 = mutableInteractionSource3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier17 = modifier2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) throws NoWhenBranchMatchedException {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) throws NoWhenBranchMatchedException {
                            CheckboxKt.Checkbox(z, function1, modifier17, z5, checkboxColors3, mutableInteractionSource4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            mutableInteractionSource2 = mutableInteractionSource;
            if ((74899 & i3) == 74898) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i10 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        z4 = z3;
                        checkboxColors2 = checkboxColorsColors;
                        mutableInteractionSource3 = null;
                    } else {
                        z4 = z3;
                        checkboxColors2 = checkboxColorsColors;
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                } else {
                    if (i10 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        z4 = z3;
                        checkboxColors2 = checkboxColorsColors;
                        mutableInteractionSource3 = null;
                    } else {
                        z4 = z3;
                        checkboxColors2 = checkboxColorsColors;
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                }
                Modifier modifier18 = modifier2;
                i8 = i3;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1406741137, i8, -1, "androidx.compose.material3.Checkbox (Checkbox.kt:98)");
                }
                ToggleableState ToggleableState11 = ToggleableStateKt.ToggleableState(z);
                composerStartRestartGroup.startReplaceGroup(1046936362);
                ComposerKt.sourceInformation(composerStartRestartGroup, "103@4507L29");
                if (function1 != null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1046937763, "CC(remember):Checkbox.kt#9igjgp");
                    if ((i8 & 112) == 32) {
                        z6 = true;
                    } else {
                        z6 = false;
                    }
                    z7 = z6 | ((i8 & 14) == 4);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z7) {
                        objRememberedValue = (Function0) new Function0<Unit>() {
                            {
                                super(0);
                            }

                            public Object invoke() {
                                m2095invoke();
                                return Unit.INSTANCE;
                            }

                            public final void m2095invoke() {
                                function1.invoke(Boolean.valueOf(!z));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function0) new Function0<Unit>() {
                            {
                                super(0);
                            }

                            public Object invoke() {
                                m2095invoke();
                                return Unit.INSTANCE;
                            }

                            public final void m2095invoke() {
                                function1.invoke(Boolean.valueOf(!z));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    function0 = (Function0) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                } else {
                    function0 = null;
                }
                composerStartRestartGroup.endReplaceGroup();
                TriStateCheckbox(ToggleableState11, function0, modifier18, z4, checkboxColors2, mutableInteractionSource3, composerStartRestartGroup, i8 & 524160, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier18;
                z5 = z4;
                checkboxColors3 = checkboxColors2;
                mutableInteractionSource4 = mutableInteractionSource3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i10 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        z4 = z3;
                        checkboxColors2 = checkboxColorsColors;
                        mutableInteractionSource3 = null;
                    } else {
                        z4 = z3;
                        checkboxColors2 = checkboxColorsColors;
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                } else {
                    if (i10 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        z4 = z3;
                        checkboxColors2 = checkboxColorsColors;
                        mutableInteractionSource3 = null;
                    } else {
                        z4 = z3;
                        checkboxColors2 = checkboxColorsColors;
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                }
                Modifier modifier19 = modifier2;
                i8 = i3;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1406741137, i8, -1, "androidx.compose.material3.Checkbox (Checkbox.kt:98)");
                }
                ToggleableState ToggleableState12 = ToggleableStateKt.ToggleableState(z);
                composerStartRestartGroup.startReplaceGroup(1046936362);
                ComposerKt.sourceInformation(composerStartRestartGroup, "103@4507L29");
                if (function1 != null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1046937763, "CC(remember):Checkbox.kt#9igjgp");
                    if ((i8 & 112) == 32) {
                        z6 = true;
                    } else {
                        z6 = false;
                    }
                    z7 = z6 | ((i8 & 14) == 4);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z7) {
                        objRememberedValue = (Function0) new Function0<Unit>() {
                            {
                                super(0);
                            }

                            public Object invoke() {
                                m2095invoke();
                                return Unit.INSTANCE;
                            }

                            public final void m2095invoke() {
                                function1.invoke(Boolean.valueOf(!z));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function0) new Function0<Unit>() {
                            {
                                super(0);
                            }

                            public Object invoke() {
                                m2095invoke();
                                return Unit.INSTANCE;
                            }

                            public final void m2095invoke() {
                                function1.invoke(Boolean.valueOf(!z));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    function0 = (Function0) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                } else {
                    function0 = null;
                }
                composerStartRestartGroup.endReplaceGroup();
                TriStateCheckbox(ToggleableState12, function0, modifier19, z4, checkboxColors2, mutableInteractionSource3, composerStartRestartGroup, i8 & 524160, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier19;
                z5 = z4;
                checkboxColors3 = checkboxColors2;
                mutableInteractionSource4 = mutableInteractionSource3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier110 = modifier2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) throws NoWhenBranchMatchedException {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11) throws NoWhenBranchMatchedException {
                        CheckboxKt.Checkbox(z, function1, modifier110, z5, checkboxColors3, mutableInteractionSource4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        z3 = z2;
        if ((i & 24576) == 0) {
            if ((i2 & 16) == 0) {
                checkboxColorsColors = checkboxColors;
                if (composerStartRestartGroup.changed(checkboxColorsColors)) {
                    i9 = Fields.Clip;
                }
                i3 |= i9;
            } else {
                checkboxColorsColors = checkboxColors;
            }
            i9 = Fields.Shape;
            i3 |= i9;
        } else {
            checkboxColorsColors = checkboxColors;
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
                    if (i10 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        z4 = z3;
                        checkboxColors2 = checkboxColorsColors;
                        mutableInteractionSource3 = null;
                    } else {
                        z4 = z3;
                        checkboxColors2 = checkboxColorsColors;
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                } else {
                    if (i10 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        z4 = z3;
                        checkboxColors2 = checkboxColorsColors;
                        mutableInteractionSource3 = null;
                    } else {
                        z4 = z3;
                        checkboxColors2 = checkboxColorsColors;
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                }
                Modifier modifier111 = modifier2;
                i8 = i3;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1406741137, i8, -1, "androidx.compose.material3.Checkbox (Checkbox.kt:98)");
                }
                ToggleableState ToggleableState13 = ToggleableStateKt.ToggleableState(z);
                composerStartRestartGroup.startReplaceGroup(1046936362);
                ComposerKt.sourceInformation(composerStartRestartGroup, "103@4507L29");
                if (function1 != null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1046937763, "CC(remember):Checkbox.kt#9igjgp");
                    if ((i8 & 112) == 32) {
                        z6 = true;
                    } else {
                        z6 = false;
                    }
                    z7 = z6 | ((i8 & 14) == 4);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z7) {
                        objRememberedValue = (Function0) new Function0<Unit>() {
                            {
                                super(0);
                            }

                            public Object invoke() {
                                m2095invoke();
                                return Unit.INSTANCE;
                            }

                            public final void m2095invoke() {
                                function1.invoke(Boolean.valueOf(!z));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function0) new Function0<Unit>() {
                            {
                                super(0);
                            }

                            public Object invoke() {
                                m2095invoke();
                                return Unit.INSTANCE;
                            }

                            public final void m2095invoke() {
                                function1.invoke(Boolean.valueOf(!z));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    function0 = (Function0) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                } else {
                    function0 = null;
                }
                composerStartRestartGroup.endReplaceGroup();
                TriStateCheckbox(ToggleableState13, function0, modifier111, z4, checkboxColors2, mutableInteractionSource3, composerStartRestartGroup, i8 & 524160, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier111;
                z5 = z4;
                checkboxColors3 = checkboxColors2;
                mutableInteractionSource4 = mutableInteractionSource3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i10 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        z4 = z3;
                        checkboxColors2 = checkboxColorsColors;
                        mutableInteractionSource3 = null;
                    } else {
                        z4 = z3;
                        checkboxColors2 = checkboxColorsColors;
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                } else {
                    if (i10 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        z4 = z3;
                        checkboxColors2 = checkboxColorsColors;
                        mutableInteractionSource3 = null;
                    } else {
                        z4 = z3;
                        checkboxColors2 = checkboxColorsColors;
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                }
                Modifier modifier112 = modifier2;
                i8 = i3;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1406741137, i8, -1, "androidx.compose.material3.Checkbox (Checkbox.kt:98)");
                }
                ToggleableState ToggleableState14 = ToggleableStateKt.ToggleableState(z);
                composerStartRestartGroup.startReplaceGroup(1046936362);
                ComposerKt.sourceInformation(composerStartRestartGroup, "103@4507L29");
                if (function1 != null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1046937763, "CC(remember):Checkbox.kt#9igjgp");
                    if ((i8 & 112) == 32) {
                        z6 = true;
                    } else {
                        z6 = false;
                    }
                    z7 = z6 | ((i8 & 14) == 4);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z7) {
                        objRememberedValue = (Function0) new Function0<Unit>() {
                            {
                                super(0);
                            }

                            public Object invoke() {
                                m2095invoke();
                                return Unit.INSTANCE;
                            }

                            public final void m2095invoke() {
                                function1.invoke(Boolean.valueOf(!z));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function0) new Function0<Unit>() {
                            {
                                super(0);
                            }

                            public Object invoke() {
                                m2095invoke();
                                return Unit.INSTANCE;
                            }

                            public final void m2095invoke() {
                                function1.invoke(Boolean.valueOf(!z));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    function0 = (Function0) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                } else {
                    function0 = null;
                }
                composerStartRestartGroup.endReplaceGroup();
                TriStateCheckbox(ToggleableState14, function0, modifier112, z4, checkboxColors2, mutableInteractionSource3, composerStartRestartGroup, i8 & 524160, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier112;
                z5 = z4;
                checkboxColors3 = checkboxColors2;
                mutableInteractionSource4 = mutableInteractionSource3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier113 = modifier2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) throws NoWhenBranchMatchedException {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11) throws NoWhenBranchMatchedException {
                        CheckboxKt.Checkbox(z, function1, modifier113, z5, checkboxColors3, mutableInteractionSource4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 196608;
        mutableInteractionSource2 = mutableInteractionSource;
        if ((74899 & i3) == 74898) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i10 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i4 != 0) {
                    z3 = true;
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                }
                if (i6 != 0) {
                    z4 = z3;
                    checkboxColors2 = checkboxColorsColors;
                    mutableInteractionSource3 = null;
                } else {
                    z4 = z3;
                    checkboxColors2 = checkboxColorsColors;
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
            } else {
                if (i10 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i4 != 0) {
                    z3 = true;
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                }
                if (i6 != 0) {
                    z4 = z3;
                    checkboxColors2 = checkboxColorsColors;
                    mutableInteractionSource3 = null;
                } else {
                    z4 = z3;
                    checkboxColors2 = checkboxColorsColors;
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
            }
            Modifier modifier114 = modifier2;
            i8 = i3;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1406741137, i8, -1, "androidx.compose.material3.Checkbox (Checkbox.kt:98)");
            }
            ToggleableState ToggleableState15 = ToggleableStateKt.ToggleableState(z);
            composerStartRestartGroup.startReplaceGroup(1046936362);
            ComposerKt.sourceInformation(composerStartRestartGroup, "103@4507L29");
            if (function1 != null) {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1046937763, "CC(remember):Checkbox.kt#9igjgp");
                if ((i8 & 112) == 32) {
                    z6 = true;
                } else {
                    z6 = false;
                }
                z7 = z6 | ((i8 & 14) == 4);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z7) {
                    objRememberedValue = (Function0) new Function0<Unit>() {
                        {
                            super(0);
                        }

                        public Object invoke() {
                            m2095invoke();
                            return Unit.INSTANCE;
                        }

                        public final void m2095invoke() {
                            function1.invoke(Boolean.valueOf(!z));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function0) new Function0<Unit>() {
                        {
                            super(0);
                        }

                        public Object invoke() {
                            m2095invoke();
                            return Unit.INSTANCE;
                        }

                        public final void m2095invoke() {
                            function1.invoke(Boolean.valueOf(!z));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                function0 = (Function0) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            } else {
                function0 = null;
            }
            composerStartRestartGroup.endReplaceGroup();
            TriStateCheckbox(ToggleableState15, function0, modifier114, z4, checkboxColors2, mutableInteractionSource3, composerStartRestartGroup, i8 & 524160, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier2 = modifier114;
            z5 = z4;
            checkboxColors3 = checkboxColors2;
            mutableInteractionSource4 = mutableInteractionSource3;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i10 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i4 != 0) {
                    z3 = true;
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                }
                if (i6 != 0) {
                    z4 = z3;
                    checkboxColors2 = checkboxColorsColors;
                    mutableInteractionSource3 = null;
                } else {
                    z4 = z3;
                    checkboxColors2 = checkboxColorsColors;
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
            } else {
                if (i10 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i4 != 0) {
                    z3 = true;
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                }
                if (i6 != 0) {
                    z4 = z3;
                    checkboxColors2 = checkboxColorsColors;
                    mutableInteractionSource3 = null;
                } else {
                    z4 = z3;
                    checkboxColors2 = checkboxColorsColors;
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
            }
            Modifier modifier115 = modifier2;
            i8 = i3;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1406741137, i8, -1, "androidx.compose.material3.Checkbox (Checkbox.kt:98)");
            }
            ToggleableState ToggleableState16 = ToggleableStateKt.ToggleableState(z);
            composerStartRestartGroup.startReplaceGroup(1046936362);
            ComposerKt.sourceInformation(composerStartRestartGroup, "103@4507L29");
            if (function1 != null) {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1046937763, "CC(remember):Checkbox.kt#9igjgp");
                if ((i8 & 112) == 32) {
                    z6 = true;
                } else {
                    z6 = false;
                }
                z7 = z6 | ((i8 & 14) == 4);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z7) {
                    objRememberedValue = (Function0) new Function0<Unit>() {
                        {
                            super(0);
                        }

                        public Object invoke() {
                            m2095invoke();
                            return Unit.INSTANCE;
                        }

                        public final void m2095invoke() {
                            function1.invoke(Boolean.valueOf(!z));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function0) new Function0<Unit>() {
                        {
                            super(0);
                        }

                        public Object invoke() {
                            m2095invoke();
                            return Unit.INSTANCE;
                        }

                        public final void m2095invoke() {
                            function1.invoke(Boolean.valueOf(!z));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                function0 = (Function0) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            } else {
                function0 = null;
            }
            composerStartRestartGroup.endReplaceGroup();
            TriStateCheckbox(ToggleableState16, function0, modifier115, z4, checkboxColors2, mutableInteractionSource3, composerStartRestartGroup, i8 & 524160, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier2 = modifier115;
            z5 = z4;
            checkboxColors3 = checkboxColors2;
            mutableInteractionSource4 = mutableInteractionSource3;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier116 = modifier2;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) throws NoWhenBranchMatchedException {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i11) throws NoWhenBranchMatchedException {
                    CheckboxKt.Checkbox(z, function1, modifier116, z5, checkboxColors3, mutableInteractionSource4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void TriStateCheckbox(final ToggleableState toggleableState, final Function0<Unit> function0, Modifier modifier, boolean z, CheckboxColors checkboxColors, MutableInteractionSource mutableInteractionSource, Composer composer, final int i, final int i2) throws NoWhenBranchMatchedException {
        int i3;
        Modifier.Companion companion;
        int i4;
        boolean z2;
        int i5;
        CheckboxColors checkboxColorsColors;
        int i6;
        MutableInteractionSource mutableInteractionSource2;
        int i7;
        MutableInteractionSource mutableInteractionSource3;
        int i8;
        Modifier.Companion companionM1371triStateToggleableO2vRcR0;
        Modifier.Companion companionMinimumInteractiveComponentSize;
        final Modifier modifier2;
        final boolean z3;
        final CheckboxColors checkboxColors2;
        final MutableInteractionSource mutableInteractionSource4;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i9;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1608358065);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(TriStateCheckbox)P(5,4,3,1)149@6731L8,169@7373L460:Checkbox.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(toggleableState) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        if ((i2 & 2) != 0) {
            i3 |= 48;
        } else if ((i & 48) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function0) ? 32 : 16;
        }
        int i10 = i2 & 4;
        if (i10 == 0) {
            if ((i & 384) == 0) {
                companion = modifier;
                i3 |= composerStartRestartGroup.changed(companion) ? Fields.RotationX : Fields.SpotShadowColor;
            }
            i4 = i2 & 8;
            if (i4 != 0) {
                if ((i & 3072) == 0) {
                    z2 = z;
                    if (composerStartRestartGroup.changed(z2)) {
                        i5 = Fields.CameraDistance;
                    } else {
                        i5 = Fields.RotationZ;
                    }
                    i3 |= i5;
                }
                if ((i & 24576) == 0) {
                    if ((i2 & 16) == 0) {
                        checkboxColorsColors = checkboxColors;
                        if (composerStartRestartGroup.changed(checkboxColorsColors)) {
                            i9 = Fields.Clip;
                        }
                        i3 |= i9;
                    } else {
                        checkboxColorsColors = checkboxColors;
                    }
                    i9 = Fields.Shape;
                    i3 |= i9;
                } else {
                    checkboxColorsColors = checkboxColors;
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
                            if (i10 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = companion;
                            }
                            if (i4 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                            if (i6 != 0) {
                                mutableInteractionSource3 = null;
                            } else {
                                mutableInteractionSource3 = mutableInteractionSource2;
                            }
                            i8 = i3;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                            }
                            i8 = i3;
                            z2 = z2;
                            checkboxColorsColors = checkboxColorsColors;
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1608358065, i8, -1, "androidx.compose.material3.TriStateCheckbox (Checkbox.kt:151)");
                        }
                        composerStartRestartGroup.startReplaceGroup(-97239746);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "161@7145L161");
                        if (function0 != null) {
                            companionM1371triStateToggleableO2vRcR0 = ToggleableKt.m1371triStateToggleableO2vRcR0(Modifier.INSTANCE, toggleableState, mutableInteractionSource3, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(CheckboxTokens.INSTANCE.m3393getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z2, Role.m6604boximpl(Role.INSTANCE.m6612getCheckboxo7Vup1c()), function0);
                        } else {
                            companionM1371triStateToggleableO2vRcR0 = Modifier.INSTANCE;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        if (function0 != null) {
                            companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
                        } else {
                            companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
                        }
                        CheckboxImpl(z2, toggleableState, PaddingKt.m1035padding3ABfNKs(companion.then(companionMinimumInteractiveComponentSize).then(companionM1371triStateToggleableO2vRcR0), CheckboxDefaultPadding), checkboxColorsColors, composerStartRestartGroup, ((i8 >> 9) & 14) | ((i8 << 3) & 112) | ((i8 >> 3) & 7168));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        z3 = z2;
                        checkboxColors2 = checkboxColorsColors;
                        mutableInteractionSource4 = mutableInteractionSource3;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        modifier2 = companion;
                        z3 = z2;
                        checkboxColors2 = checkboxColorsColors;
                        composerStartRestartGroup = composerStartRestartGroup;
                        mutableInteractionSource4 = mutableInteractionSource2;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) throws NoWhenBranchMatchedException {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11) throws NoWhenBranchMatchedException {
                                CheckboxKt.TriStateCheckbox(toggleableState, function0, modifier2, z3, checkboxColors2, mutableInteractionSource4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                mutableInteractionSource2 = mutableInteractionSource;
                if ((74899 & i3) == 74898) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i10 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = companion;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        i8 = i3;
                    } else {
                        if (i10 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = companion;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        i8 = i3;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1608358065, i8, -1, "androidx.compose.material3.TriStateCheckbox (Checkbox.kt:151)");
                    }
                    composerStartRestartGroup.startReplaceGroup(-97239746);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "161@7145L161");
                    if (function0 != null) {
                        companionM1371triStateToggleableO2vRcR0 = ToggleableKt.m1371triStateToggleableO2vRcR0(Modifier.INSTANCE, toggleableState, mutableInteractionSource3, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(CheckboxTokens.INSTANCE.m3393getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z2, Role.m6604boximpl(Role.INSTANCE.m6612getCheckboxo7Vup1c()), function0);
                    } else {
                        companionM1371triStateToggleableO2vRcR0 = Modifier.INSTANCE;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    if (function0 != null) {
                        companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
                    } else {
                        companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
                    }
                    CheckboxImpl(z2, toggleableState, PaddingKt.m1035padding3ABfNKs(companion.then(companionMinimumInteractiveComponentSize).then(companionM1371triStateToggleableO2vRcR0), CheckboxDefaultPadding), checkboxColorsColors, composerStartRestartGroup, ((i8 >> 9) & 14) | ((i8 << 3) & 112) | ((i8 >> 3) & 7168));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    z3 = z2;
                    checkboxColors2 = checkboxColorsColors;
                    mutableInteractionSource4 = mutableInteractionSource3;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i10 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = companion;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        i8 = i3;
                    } else {
                        if (i10 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = companion;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        i8 = i3;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1608358065, i8, -1, "androidx.compose.material3.TriStateCheckbox (Checkbox.kt:151)");
                    }
                    composerStartRestartGroup.startReplaceGroup(-97239746);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "161@7145L161");
                    if (function0 != null) {
                        companionM1371triStateToggleableO2vRcR0 = ToggleableKt.m1371triStateToggleableO2vRcR0(Modifier.INSTANCE, toggleableState, mutableInteractionSource3, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(CheckboxTokens.INSTANCE.m3393getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z2, Role.m6604boximpl(Role.INSTANCE.m6612getCheckboxo7Vup1c()), function0);
                    } else {
                        companionM1371triStateToggleableO2vRcR0 = Modifier.INSTANCE;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    if (function0 != null) {
                        companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
                    } else {
                        companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
                    }
                    CheckboxImpl(z2, toggleableState, PaddingKt.m1035padding3ABfNKs(companion.then(companionMinimumInteractiveComponentSize).then(companionM1371triStateToggleableO2vRcR0), CheckboxDefaultPadding), checkboxColorsColors, composerStartRestartGroup, ((i8 >> 9) & 14) | ((i8 << 3) & 112) | ((i8 >> 3) & 7168));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    z3 = z2;
                    checkboxColors2 = checkboxColorsColors;
                    mutableInteractionSource4 = mutableInteractionSource3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) throws NoWhenBranchMatchedException {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) throws NoWhenBranchMatchedException {
                            CheckboxKt.TriStateCheckbox(toggleableState, function0, modifier2, z3, checkboxColors2, mutableInteractionSource4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            z2 = z;
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    checkboxColorsColors = checkboxColors;
                    if (composerStartRestartGroup.changed(checkboxColorsColors)) {
                        i9 = Fields.Clip;
                    }
                    i3 |= i9;
                } else {
                    checkboxColorsColors = checkboxColors;
                }
                i9 = Fields.Shape;
                i3 |= i9;
            } else {
                checkboxColorsColors = checkboxColors;
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
                        if (i10 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = companion;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        i8 = i3;
                    } else {
                        if (i10 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = companion;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        i8 = i3;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1608358065, i8, -1, "androidx.compose.material3.TriStateCheckbox (Checkbox.kt:151)");
                    }
                    composerStartRestartGroup.startReplaceGroup(-97239746);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "161@7145L161");
                    if (function0 != null) {
                        companionM1371triStateToggleableO2vRcR0 = ToggleableKt.m1371triStateToggleableO2vRcR0(Modifier.INSTANCE, toggleableState, mutableInteractionSource3, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(CheckboxTokens.INSTANCE.m3393getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z2, Role.m6604boximpl(Role.INSTANCE.m6612getCheckboxo7Vup1c()), function0);
                    } else {
                        companionM1371triStateToggleableO2vRcR0 = Modifier.INSTANCE;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    if (function0 != null) {
                        companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
                    } else {
                        companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
                    }
                    CheckboxImpl(z2, toggleableState, PaddingKt.m1035padding3ABfNKs(companion.then(companionMinimumInteractiveComponentSize).then(companionM1371triStateToggleableO2vRcR0), CheckboxDefaultPadding), checkboxColorsColors, composerStartRestartGroup, ((i8 >> 9) & 14) | ((i8 << 3) & 112) | ((i8 >> 3) & 7168));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    z3 = z2;
                    checkboxColors2 = checkboxColorsColors;
                    mutableInteractionSource4 = mutableInteractionSource3;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i10 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = companion;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        i8 = i3;
                    } else {
                        if (i10 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = companion;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        i8 = i3;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1608358065, i8, -1, "androidx.compose.material3.TriStateCheckbox (Checkbox.kt:151)");
                    }
                    composerStartRestartGroup.startReplaceGroup(-97239746);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "161@7145L161");
                    if (function0 != null) {
                        companionM1371triStateToggleableO2vRcR0 = ToggleableKt.m1371triStateToggleableO2vRcR0(Modifier.INSTANCE, toggleableState, mutableInteractionSource3, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(CheckboxTokens.INSTANCE.m3393getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z2, Role.m6604boximpl(Role.INSTANCE.m6612getCheckboxo7Vup1c()), function0);
                    } else {
                        companionM1371triStateToggleableO2vRcR0 = Modifier.INSTANCE;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    if (function0 != null) {
                        companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
                    } else {
                        companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
                    }
                    CheckboxImpl(z2, toggleableState, PaddingKt.m1035padding3ABfNKs(companion.then(companionMinimumInteractiveComponentSize).then(companionM1371triStateToggleableO2vRcR0), CheckboxDefaultPadding), checkboxColorsColors, composerStartRestartGroup, ((i8 >> 9) & 14) | ((i8 << 3) & 112) | ((i8 >> 3) & 7168));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    z3 = z2;
                    checkboxColors2 = checkboxColorsColors;
                    mutableInteractionSource4 = mutableInteractionSource3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) throws NoWhenBranchMatchedException {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) throws NoWhenBranchMatchedException {
                            CheckboxKt.TriStateCheckbox(toggleableState, function0, modifier2, z3, checkboxColors2, mutableInteractionSource4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            mutableInteractionSource2 = mutableInteractionSource;
            if ((74899 & i3) == 74898) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = companion;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    i8 = i3;
                } else {
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = companion;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    i8 = i3;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1608358065, i8, -1, "androidx.compose.material3.TriStateCheckbox (Checkbox.kt:151)");
                }
                composerStartRestartGroup.startReplaceGroup(-97239746);
                ComposerKt.sourceInformation(composerStartRestartGroup, "161@7145L161");
                if (function0 != null) {
                    companionM1371triStateToggleableO2vRcR0 = ToggleableKt.m1371triStateToggleableO2vRcR0(Modifier.INSTANCE, toggleableState, mutableInteractionSource3, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(CheckboxTokens.INSTANCE.m3393getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z2, Role.m6604boximpl(Role.INSTANCE.m6612getCheckboxo7Vup1c()), function0);
                } else {
                    companionM1371triStateToggleableO2vRcR0 = Modifier.INSTANCE;
                }
                composerStartRestartGroup.endReplaceGroup();
                if (function0 != null) {
                    companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
                } else {
                    companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
                }
                CheckboxImpl(z2, toggleableState, PaddingKt.m1035padding3ABfNKs(companion.then(companionMinimumInteractiveComponentSize).then(companionM1371triStateToggleableO2vRcR0), CheckboxDefaultPadding), checkboxColorsColors, composerStartRestartGroup, ((i8 >> 9) & 14) | ((i8 << 3) & 112) | ((i8 >> 3) & 7168));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                z3 = z2;
                checkboxColors2 = checkboxColorsColors;
                mutableInteractionSource4 = mutableInteractionSource3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = companion;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    i8 = i3;
                } else {
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = companion;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    i8 = i3;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1608358065, i8, -1, "androidx.compose.material3.TriStateCheckbox (Checkbox.kt:151)");
                }
                composerStartRestartGroup.startReplaceGroup(-97239746);
                ComposerKt.sourceInformation(composerStartRestartGroup, "161@7145L161");
                if (function0 != null) {
                    companionM1371triStateToggleableO2vRcR0 = ToggleableKt.m1371triStateToggleableO2vRcR0(Modifier.INSTANCE, toggleableState, mutableInteractionSource3, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(CheckboxTokens.INSTANCE.m3393getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z2, Role.m6604boximpl(Role.INSTANCE.m6612getCheckboxo7Vup1c()), function0);
                } else {
                    companionM1371triStateToggleableO2vRcR0 = Modifier.INSTANCE;
                }
                composerStartRestartGroup.endReplaceGroup();
                if (function0 != null) {
                    companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
                } else {
                    companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
                }
                CheckboxImpl(z2, toggleableState, PaddingKt.m1035padding3ABfNKs(companion.then(companionMinimumInteractiveComponentSize).then(companionM1371triStateToggleableO2vRcR0), CheckboxDefaultPadding), checkboxColorsColors, composerStartRestartGroup, ((i8 >> 9) & 14) | ((i8 << 3) & 112) | ((i8 >> 3) & 7168));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                z3 = z2;
                checkboxColors2 = checkboxColorsColors;
                mutableInteractionSource4 = mutableInteractionSource3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) throws NoWhenBranchMatchedException {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11) throws NoWhenBranchMatchedException {
                        CheckboxKt.TriStateCheckbox(toggleableState, function0, modifier2, z3, checkboxColors2, mutableInteractionSource4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        companion = modifier;
        i4 = i2 & 8;
        if (i4 != 0) {
            if ((i & 3072) == 0) {
                z2 = z;
                if (composerStartRestartGroup.changed(z2)) {
                    i5 = Fields.CameraDistance;
                } else {
                    i5 = Fields.RotationZ;
                }
                i3 |= i5;
            }
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    checkboxColorsColors = checkboxColors;
                    if (composerStartRestartGroup.changed(checkboxColorsColors)) {
                        i9 = Fields.Clip;
                    }
                    i3 |= i9;
                } else {
                    checkboxColorsColors = checkboxColors;
                }
                i9 = Fields.Shape;
                i3 |= i9;
            } else {
                checkboxColorsColors = checkboxColors;
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
                        if (i10 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = companion;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        i8 = i3;
                    } else {
                        if (i10 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = companion;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        i8 = i3;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1608358065, i8, -1, "androidx.compose.material3.TriStateCheckbox (Checkbox.kt:151)");
                    }
                    composerStartRestartGroup.startReplaceGroup(-97239746);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "161@7145L161");
                    if (function0 != null) {
                        companionM1371triStateToggleableO2vRcR0 = ToggleableKt.m1371triStateToggleableO2vRcR0(Modifier.INSTANCE, toggleableState, mutableInteractionSource3, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(CheckboxTokens.INSTANCE.m3393getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z2, Role.m6604boximpl(Role.INSTANCE.m6612getCheckboxo7Vup1c()), function0);
                    } else {
                        companionM1371triStateToggleableO2vRcR0 = Modifier.INSTANCE;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    if (function0 != null) {
                        companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
                    } else {
                        companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
                    }
                    CheckboxImpl(z2, toggleableState, PaddingKt.m1035padding3ABfNKs(companion.then(companionMinimumInteractiveComponentSize).then(companionM1371triStateToggleableO2vRcR0), CheckboxDefaultPadding), checkboxColorsColors, composerStartRestartGroup, ((i8 >> 9) & 14) | ((i8 << 3) & 112) | ((i8 >> 3) & 7168));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    z3 = z2;
                    checkboxColors2 = checkboxColorsColors;
                    mutableInteractionSource4 = mutableInteractionSource3;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i10 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = companion;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        i8 = i3;
                    } else {
                        if (i10 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = companion;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                        if (i6 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        i8 = i3;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1608358065, i8, -1, "androidx.compose.material3.TriStateCheckbox (Checkbox.kt:151)");
                    }
                    composerStartRestartGroup.startReplaceGroup(-97239746);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "161@7145L161");
                    if (function0 != null) {
                        companionM1371triStateToggleableO2vRcR0 = ToggleableKt.m1371triStateToggleableO2vRcR0(Modifier.INSTANCE, toggleableState, mutableInteractionSource3, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(CheckboxTokens.INSTANCE.m3393getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z2, Role.m6604boximpl(Role.INSTANCE.m6612getCheckboxo7Vup1c()), function0);
                    } else {
                        companionM1371triStateToggleableO2vRcR0 = Modifier.INSTANCE;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    if (function0 != null) {
                        companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
                    } else {
                        companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
                    }
                    CheckboxImpl(z2, toggleableState, PaddingKt.m1035padding3ABfNKs(companion.then(companionMinimumInteractiveComponentSize).then(companionM1371triStateToggleableO2vRcR0), CheckboxDefaultPadding), checkboxColorsColors, composerStartRestartGroup, ((i8 >> 9) & 14) | ((i8 << 3) & 112) | ((i8 >> 3) & 7168));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    z3 = z2;
                    checkboxColors2 = checkboxColorsColors;
                    mutableInteractionSource4 = mutableInteractionSource3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) throws NoWhenBranchMatchedException {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) throws NoWhenBranchMatchedException {
                            CheckboxKt.TriStateCheckbox(toggleableState, function0, modifier2, z3, checkboxColors2, mutableInteractionSource4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            mutableInteractionSource2 = mutableInteractionSource;
            if ((74899 & i3) == 74898) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = companion;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    i8 = i3;
                } else {
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = companion;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    i8 = i3;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1608358065, i8, -1, "androidx.compose.material3.TriStateCheckbox (Checkbox.kt:151)");
                }
                composerStartRestartGroup.startReplaceGroup(-97239746);
                ComposerKt.sourceInformation(composerStartRestartGroup, "161@7145L161");
                if (function0 != null) {
                    companionM1371triStateToggleableO2vRcR0 = ToggleableKt.m1371triStateToggleableO2vRcR0(Modifier.INSTANCE, toggleableState, mutableInteractionSource3, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(CheckboxTokens.INSTANCE.m3393getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z2, Role.m6604boximpl(Role.INSTANCE.m6612getCheckboxo7Vup1c()), function0);
                } else {
                    companionM1371triStateToggleableO2vRcR0 = Modifier.INSTANCE;
                }
                composerStartRestartGroup.endReplaceGroup();
                if (function0 != null) {
                    companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
                } else {
                    companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
                }
                CheckboxImpl(z2, toggleableState, PaddingKt.m1035padding3ABfNKs(companion.then(companionMinimumInteractiveComponentSize).then(companionM1371triStateToggleableO2vRcR0), CheckboxDefaultPadding), checkboxColorsColors, composerStartRestartGroup, ((i8 >> 9) & 14) | ((i8 << 3) & 112) | ((i8 >> 3) & 7168));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                z3 = z2;
                checkboxColors2 = checkboxColorsColors;
                mutableInteractionSource4 = mutableInteractionSource3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = companion;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    i8 = i3;
                } else {
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = companion;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    i8 = i3;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1608358065, i8, -1, "androidx.compose.material3.TriStateCheckbox (Checkbox.kt:151)");
                }
                composerStartRestartGroup.startReplaceGroup(-97239746);
                ComposerKt.sourceInformation(composerStartRestartGroup, "161@7145L161");
                if (function0 != null) {
                    companionM1371triStateToggleableO2vRcR0 = ToggleableKt.m1371triStateToggleableO2vRcR0(Modifier.INSTANCE, toggleableState, mutableInteractionSource3, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(CheckboxTokens.INSTANCE.m3393getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z2, Role.m6604boximpl(Role.INSTANCE.m6612getCheckboxo7Vup1c()), function0);
                } else {
                    companionM1371triStateToggleableO2vRcR0 = Modifier.INSTANCE;
                }
                composerStartRestartGroup.endReplaceGroup();
                if (function0 != null) {
                    companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
                } else {
                    companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
                }
                CheckboxImpl(z2, toggleableState, PaddingKt.m1035padding3ABfNKs(companion.then(companionMinimumInteractiveComponentSize).then(companionM1371triStateToggleableO2vRcR0), CheckboxDefaultPadding), checkboxColorsColors, composerStartRestartGroup, ((i8 >> 9) & 14) | ((i8 << 3) & 112) | ((i8 >> 3) & 7168));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                z3 = z2;
                checkboxColors2 = checkboxColorsColors;
                mutableInteractionSource4 = mutableInteractionSource3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) throws NoWhenBranchMatchedException {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11) throws NoWhenBranchMatchedException {
                        CheckboxKt.TriStateCheckbox(toggleableState, function0, modifier2, z3, checkboxColors2, mutableInteractionSource4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        z2 = z;
        if ((i & 24576) == 0) {
            if ((i2 & 16) == 0) {
                checkboxColorsColors = checkboxColors;
                if (composerStartRestartGroup.changed(checkboxColorsColors)) {
                    i9 = Fields.Clip;
                }
                i3 |= i9;
            } else {
                checkboxColorsColors = checkboxColors;
            }
            i9 = Fields.Shape;
            i3 |= i9;
        } else {
            checkboxColorsColors = checkboxColors;
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
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = companion;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    i8 = i3;
                } else {
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = companion;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    i8 = i3;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1608358065, i8, -1, "androidx.compose.material3.TriStateCheckbox (Checkbox.kt:151)");
                }
                composerStartRestartGroup.startReplaceGroup(-97239746);
                ComposerKt.sourceInformation(composerStartRestartGroup, "161@7145L161");
                if (function0 != null) {
                    companionM1371triStateToggleableO2vRcR0 = ToggleableKt.m1371triStateToggleableO2vRcR0(Modifier.INSTANCE, toggleableState, mutableInteractionSource3, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(CheckboxTokens.INSTANCE.m3393getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z2, Role.m6604boximpl(Role.INSTANCE.m6612getCheckboxo7Vup1c()), function0);
                } else {
                    companionM1371triStateToggleableO2vRcR0 = Modifier.INSTANCE;
                }
                composerStartRestartGroup.endReplaceGroup();
                if (function0 != null) {
                    companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
                } else {
                    companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
                }
                CheckboxImpl(z2, toggleableState, PaddingKt.m1035padding3ABfNKs(companion.then(companionMinimumInteractiveComponentSize).then(companionM1371triStateToggleableO2vRcR0), CheckboxDefaultPadding), checkboxColorsColors, composerStartRestartGroup, ((i8 >> 9) & 14) | ((i8 << 3) & 112) | ((i8 >> 3) & 7168));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                z3 = z2;
                checkboxColors2 = checkboxColorsColors;
                mutableInteractionSource4 = mutableInteractionSource3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = companion;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    i8 = i3;
                } else {
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = companion;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                    if (i6 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    i8 = i3;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1608358065, i8, -1, "androidx.compose.material3.TriStateCheckbox (Checkbox.kt:151)");
                }
                composerStartRestartGroup.startReplaceGroup(-97239746);
                ComposerKt.sourceInformation(composerStartRestartGroup, "161@7145L161");
                if (function0 != null) {
                    companionM1371triStateToggleableO2vRcR0 = ToggleableKt.m1371triStateToggleableO2vRcR0(Modifier.INSTANCE, toggleableState, mutableInteractionSource3, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(CheckboxTokens.INSTANCE.m3393getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z2, Role.m6604boximpl(Role.INSTANCE.m6612getCheckboxo7Vup1c()), function0);
                } else {
                    companionM1371triStateToggleableO2vRcR0 = Modifier.INSTANCE;
                }
                composerStartRestartGroup.endReplaceGroup();
                if (function0 != null) {
                    companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
                } else {
                    companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
                }
                CheckboxImpl(z2, toggleableState, PaddingKt.m1035padding3ABfNKs(companion.then(companionMinimumInteractiveComponentSize).then(companionM1371triStateToggleableO2vRcR0), CheckboxDefaultPadding), checkboxColorsColors, composerStartRestartGroup, ((i8 >> 9) & 14) | ((i8 << 3) & 112) | ((i8 >> 3) & 7168));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                z3 = z2;
                checkboxColors2 = checkboxColorsColors;
                mutableInteractionSource4 = mutableInteractionSource3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) throws NoWhenBranchMatchedException {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11) throws NoWhenBranchMatchedException {
                        CheckboxKt.TriStateCheckbox(toggleableState, function0, modifier2, z3, checkboxColors2, mutableInteractionSource4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 196608;
        mutableInteractionSource2 = mutableInteractionSource;
        if ((74899 & i3) == 74898) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i10 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = companion;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                }
                if (i6 != 0) {
                    mutableInteractionSource3 = null;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                i8 = i3;
            } else {
                if (i10 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = companion;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                }
                if (i6 != 0) {
                    mutableInteractionSource3 = null;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                i8 = i3;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1608358065, i8, -1, "androidx.compose.material3.TriStateCheckbox (Checkbox.kt:151)");
            }
            composerStartRestartGroup.startReplaceGroup(-97239746);
            ComposerKt.sourceInformation(composerStartRestartGroup, "161@7145L161");
            if (function0 != null) {
                companionM1371triStateToggleableO2vRcR0 = ToggleableKt.m1371triStateToggleableO2vRcR0(Modifier.INSTANCE, toggleableState, mutableInteractionSource3, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(CheckboxTokens.INSTANCE.m3393getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z2, Role.m6604boximpl(Role.INSTANCE.m6612getCheckboxo7Vup1c()), function0);
            } else {
                companionM1371triStateToggleableO2vRcR0 = Modifier.INSTANCE;
            }
            composerStartRestartGroup.endReplaceGroup();
            if (function0 != null) {
                companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
            } else {
                companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
            }
            CheckboxImpl(z2, toggleableState, PaddingKt.m1035padding3ABfNKs(companion.then(companionMinimumInteractiveComponentSize).then(companionM1371triStateToggleableO2vRcR0), CheckboxDefaultPadding), checkboxColorsColors, composerStartRestartGroup, ((i8 >> 9) & 14) | ((i8 << 3) & 112) | ((i8 >> 3) & 7168));
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier2 = companion;
            z3 = z2;
            checkboxColors2 = checkboxColorsColors;
            mutableInteractionSource4 = mutableInteractionSource3;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i10 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = companion;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                }
                if (i6 != 0) {
                    mutableInteractionSource3 = null;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                i8 = i3;
            } else {
                if (i10 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = companion;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    checkboxColorsColors = CheckboxDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                }
                if (i6 != 0) {
                    mutableInteractionSource3 = null;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                i8 = i3;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1608358065, i8, -1, "androidx.compose.material3.TriStateCheckbox (Checkbox.kt:151)");
            }
            composerStartRestartGroup.startReplaceGroup(-97239746);
            ComposerKt.sourceInformation(composerStartRestartGroup, "161@7145L161");
            if (function0 != null) {
                companionM1371triStateToggleableO2vRcR0 = ToggleableKt.m1371triStateToggleableO2vRcR0(Modifier.INSTANCE, toggleableState, mutableInteractionSource3, RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, Dp.constructor-impl(CheckboxTokens.INSTANCE.m3393getStateLayerSizeD9Ej5fM() / 2), 0L, composerStartRestartGroup, 54, 4), z2, Role.m6604boximpl(Role.INSTANCE.m6612getCheckboxo7Vup1c()), function0);
            } else {
                companionM1371triStateToggleableO2vRcR0 = Modifier.INSTANCE;
            }
            composerStartRestartGroup.endReplaceGroup();
            if (function0 != null) {
                companionMinimumInteractiveComponentSize = InteractiveComponentSizeKt.minimumInteractiveComponentSize(Modifier.INSTANCE);
            } else {
                companionMinimumInteractiveComponentSize = Modifier.INSTANCE;
            }
            CheckboxImpl(z2, toggleableState, PaddingKt.m1035padding3ABfNKs(companion.then(companionMinimumInteractiveComponentSize).then(companionM1371triStateToggleableO2vRcR0), CheckboxDefaultPadding), checkboxColorsColors, composerStartRestartGroup, ((i8 >> 9) & 14) | ((i8 << 3) & 112) | ((i8 >> 3) & 7168));
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier2 = companion;
            z3 = z2;
            checkboxColors2 = checkboxColorsColors;
            mutableInteractionSource4 = mutableInteractionSource3;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) throws NoWhenBranchMatchedException {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i11) throws NoWhenBranchMatchedException {
                    CheckboxKt.TriStateCheckbox(toggleableState, function0, modifier2, z3, checkboxColors2, mutableInteractionSource4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void CheckboxImpl(final boolean z, final ToggleableState toggleableState, final Modifier modifier, final CheckboxColors checkboxColors, Composer composer, final int i) throws NoWhenBranchMatchedException {
        int i2;
        float f;
        float f2;
        float f3;
        Composer composerStartRestartGroup = composer.startRestartGroup(2007131616);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(CheckboxImpl)P(1,3,2)272@12420L23,274@12491L499,291@13057L514,306@13593L32,307@13654L21,308@13702L24,309@13756L27,310@13866L538,310@13788L616:Checkbox.kt#uh7d8r");
        if ((i & 6) == 0) {
            i2 = (composerStartRestartGroup.changed(z) ? 4 : 2) | i;
        } else {
            i2 = i;
        }
        if ((i & 48) == 0) {
            i2 |= composerStartRestartGroup.changed(toggleableState) ? 32 : 16;
        }
        if ((i & 384) == 0) {
            i2 |= composerStartRestartGroup.changed(modifier) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i & 3072) == 0) {
            i2 |= composerStartRestartGroup.changed(checkboxColors) ? Fields.CameraDistance : Fields.RotationZ;
        }
        int i3 = i2;
        if ((i3 & 1171) == 1170 && composerStartRestartGroup.getSkipping()) {
            composerStartRestartGroup.skipToGroupEnd();
        } else {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(2007131616, i3, -1, "androidx.compose.material3.CheckboxImpl (Checkbox.kt:271)");
            }
            int i4 = i3 >> 3;
            int i5 = i4 & 14;
            Transition transitionUpdateTransition = TransitionKt.updateTransition(toggleableState, (String) null, composerStartRestartGroup, i5, 2);
            CheckboxKt$CheckboxImpl$checkDrawFraction$1 checkboxKt$CheckboxImpl$checkDrawFraction$1 = new Function3<Transition.Segment<ToggleableState>, Composer, Integer, FiniteAnimationSpec<Float>>() {
                public Object invoke(Object obj, Object obj2, Object obj3) {
                    return invoke((Transition.Segment<ToggleableState>) obj, (Composer) obj2, ((Number) obj3).intValue());
                }

                public final FiniteAnimationSpec<Float> invoke(Transition.Segment<ToggleableState> segment, Composer composer2, int i6) {
                    SpringSpec springSpecSnap;
                    composer2.startReplaceGroup(1373301606);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1373301606, i6, -1, "androidx.compose.material3.CheckboxImpl.<anonymous> (Checkbox.kt:276)");
                    }
                    if (segment.getInitialState() == ToggleableState.Off) {
                        springSpecSnap = AnimationSpecKt.tween$default(100, 0, null, 6, null);
                    } else {
                        springSpecSnap = segment.getTargetState() == ToggleableState.Off ? AnimationSpecKt.snap(100) : AnimationSpecKt.spring$default(0.0f, 0.0f, null, 7, null);
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    composer2.endReplaceGroup();
                    return springSpecSnap;
                }
            };
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1338768149, "CC(animateFloat)P(2)1966@80444L78:Transition.kt#pdpnli");
            TwoWayConverter<Float, AnimationVector1D> vectorConverter = VectorConvertersKt.getVectorConverter(FloatCompanionObject.INSTANCE);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -142660079, "CC(animateValue)P(3,2)1883@77007L32,1884@77062L31,1885@77118L23,1887@77154L89:Transition.kt#pdpnli");
            ToggleableState toggleableState2 = (ToggleableState) transitionUpdateTransition.getCurrentState();
            composerStartRestartGroup.startReplaceGroup(1800065638);
            ComposerKt.sourceInformation(composerStartRestartGroup, "C:Checkbox.kt#uh7d8r");
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1800065638, 0, -1, "androidx.compose.material3.CheckboxImpl.<anonymous> (Checkbox.kt:283)");
            }
            int i6 = WhenMappings.$EnumSwitchMapping$0[toggleableState2.ordinal()];
            float f4 = 0.0f;
            if (i6 == 1) {
                f = 1.0f;
            } else if (i6 != 2) {
                if (i6 != 3) {
                    throw new NoWhenBranchMatchedException();
                }
                f = 1.0f;
            } else {
                f = 0.0f;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            composerStartRestartGroup.endReplaceGroup();
            Float fValueOf = Float.valueOf(f);
            ToggleableState toggleableState3 = (ToggleableState) transitionUpdateTransition.getTargetState();
            composerStartRestartGroup.startReplaceGroup(1800065638);
            ComposerKt.sourceInformation(composerStartRestartGroup, "C:Checkbox.kt#uh7d8r");
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1800065638, 0, -1, "androidx.compose.material3.CheckboxImpl.<anonymous> (Checkbox.kt:283)");
            }
            int i7 = WhenMappings.$EnumSwitchMapping$0[toggleableState3.ordinal()];
            if (i7 == 1) {
                f2 = 1.0f;
            } else if (i7 != 2) {
                if (i7 != 3) {
                    throw new NoWhenBranchMatchedException();
                }
                f2 = 1.0f;
            } else {
                f2 = 0.0f;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            composerStartRestartGroup.endReplaceGroup();
            final State stateCreateTransitionAnimation = TransitionKt.createTransitionAnimation(transitionUpdateTransition, fValueOf, Float.valueOf(f2), (FiniteAnimationSpec) checkboxKt$CheckboxImpl$checkDrawFraction$1.invoke(transitionUpdateTransition.getSegment(), composerStartRestartGroup, 0), vectorConverter, "FloatAnimation", composerStartRestartGroup, 0);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            CheckboxKt$CheckboxImpl$checkCenterGravitationShiftFraction$1 checkboxKt$CheckboxImpl$checkCenterGravitationShiftFraction$1 = new Function3<Transition.Segment<ToggleableState>, Composer, Integer, FiniteAnimationSpec<Float>>() {
                public Object invoke(Object obj, Object obj2, Object obj3) {
                    return invoke((Transition.Segment<ToggleableState>) obj, (Composer) obj2, ((Number) obj3).intValue());
                }

                public final FiniteAnimationSpec<Float> invoke(Transition.Segment<ToggleableState> segment, Composer composer2, int i8) {
                    TweenSpec tweenSpecSnap;
                    composer2.startReplaceGroup(-1324481169);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1324481169, i8, -1, "androidx.compose.material3.CheckboxImpl.<anonymous> (Checkbox.kt:293)");
                    }
                    if (segment.getInitialState() == ToggleableState.Off) {
                        tweenSpecSnap = AnimationSpecKt.snap$default(0, 1, null);
                    } else {
                        tweenSpecSnap = segment.getTargetState() == ToggleableState.Off ? AnimationSpecKt.snap(100) : AnimationSpecKt.tween$default(100, 0, null, 6, null);
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    composer2.endReplaceGroup();
                    return tweenSpecSnap;
                }
            };
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1338768149, "CC(animateFloat)P(2)1966@80444L78:Transition.kt#pdpnli");
            TwoWayConverter<Float, AnimationVector1D> vectorConverter2 = VectorConvertersKt.getVectorConverter(FloatCompanionObject.INSTANCE);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -142660079, "CC(animateValue)P(3,2)1883@77007L32,1884@77062L31,1885@77118L23,1887@77154L89:Transition.kt#pdpnli");
            ToggleableState toggleableState4 = (ToggleableState) transitionUpdateTransition.getCurrentState();
            composerStartRestartGroup.startReplaceGroup(-1426969489);
            ComposerKt.sourceInformation(composerStartRestartGroup, "C:Checkbox.kt#uh7d8r");
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1426969489, 0, -1, "androidx.compose.material3.CheckboxImpl.<anonymous> (Checkbox.kt:300)");
            }
            int i8 = WhenMappings.$EnumSwitchMapping$0[toggleableState4.ordinal()];
            if (i8 == 1 || i8 == 2) {
                f3 = 0.0f;
            } else {
                if (i8 != 3) {
                    throw new NoWhenBranchMatchedException();
                }
                f3 = 1.0f;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            composerStartRestartGroup.endReplaceGroup();
            Float fValueOf2 = Float.valueOf(f3);
            ToggleableState toggleableState5 = (ToggleableState) transitionUpdateTransition.getTargetState();
            composerStartRestartGroup.startReplaceGroup(-1426969489);
            ComposerKt.sourceInformation(composerStartRestartGroup, "C:Checkbox.kt#uh7d8r");
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1426969489, 0, -1, "androidx.compose.material3.CheckboxImpl.<anonymous> (Checkbox.kt:300)");
            }
            int i9 = WhenMappings.$EnumSwitchMapping$0[toggleableState5.ordinal()];
            if (i9 != 1 && i9 != 2) {
                if (i9 != 3) {
                    throw new NoWhenBranchMatchedException();
                }
                f4 = 1.0f;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            composerStartRestartGroup.endReplaceGroup();
            final State stateCreateTransitionAnimation2 = TransitionKt.createTransitionAnimation(transitionUpdateTransition, fValueOf2, Float.valueOf(f4), (FiniteAnimationSpec) checkboxKt$CheckboxImpl$checkCenterGravitationShiftFraction$1.invoke(transitionUpdateTransition.getSegment(), composerStartRestartGroup, 0), vectorConverter2, "FloatAnimation", composerStartRestartGroup, 0);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 974828454, "CC(remember):Checkbox.kt#9igjgp");
            Object objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = new CheckDrawingCache(null, null, null, 7, null);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            final CheckDrawingCache checkDrawingCache = (CheckDrawingCache) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            final State<Color> stateCheckmarkColor$material3_release = checkboxColors.checkmarkColor$material3_release(toggleableState, composerStartRestartGroup, i5 | ((i3 >> 6) & 112));
            int i10 = (i4 & 896) | (i3 & 126);
            final State<Color> stateBoxColor$material3_release = checkboxColors.boxColor$material3_release(z, toggleableState, composerStartRestartGroup, i10);
            final State<Color> stateBorderColor$material3_release = checkboxColors.borderColor$material3_release(z, toggleableState, composerStartRestartGroup, i10);
            Modifier modifierM1072requiredSize3ABfNKs = SizeKt.m1072requiredSize3ABfNKs(SizeKt.wrapContentSize$default(modifier, Alignment.INSTANCE.getCenter(), false, 2, null), CheckboxSize);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 974837696, "CC(remember):Checkbox.kt#9igjgp");
            boolean zChanged = composerStartRestartGroup.changed(stateBoxColor$material3_release) | composerStartRestartGroup.changed(stateBorderColor$material3_release) | composerStartRestartGroup.changed(stateCheckmarkColor$material3_release) | composerStartRestartGroup.changed(stateCreateTransitionAnimation) | composerStartRestartGroup.changed(stateCreateTransitionAnimation2);
            Object objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (zChanged || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        float fFloor = (float) Math.floor(drawScope.toPx-0680j_4(CheckboxKt.StrokeWidth));
                        CheckboxKt.m2093drawBox1wkBAMs(drawScope, stateBoxColor$material3_release.getValue().m4600unboximpl(), stateBorderColor$material3_release.getValue().m4600unboximpl(), drawScope.toPx-0680j_4(CheckboxKt.RadiusSize), fFloor);
                        CheckboxKt.m2094drawCheck3IgeMak(drawScope, stateCheckmarkColor$material3_release.getValue().m4600unboximpl(), stateCreateTransitionAnimation.getValue().floatValue(), stateCreateTransitionAnimation2.getValue().floatValue(), fFloor, checkDrawingCache);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            CanvasKt.Canvas(modifierM1072requiredSize3ABfNKs, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) throws NoWhenBranchMatchedException {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i11) throws NoWhenBranchMatchedException {
                    CheckboxKt.CheckboxImpl(z, toggleableState, modifier, checkboxColors, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1));
                }
            });
        }
    }

    public static final void m2093drawBox1wkBAMs(DrawScope drawScope, long j, long j2, float f, float f2) {
        float f3 = f2 / 2.0f;
        Stroke stroke = new Stroke(f2, 0.0f, 0, 0, null, 30, null);
        float fM4415getWidthimpl = Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc());
        if (Color.m4591equalsimpl0(j, j2)) {
            DrawScope.CC.m5182drawRoundRectuAw5IA$default(drawScope, j, 0L, androidx.compose.p002ui.geometry.SizeKt.Size(fM4415getWidthimpl, fM4415getWidthimpl), CornerRadiusKt.CornerRadius$default(f, 0.0f, 2, null), Fill.INSTANCE, 0.0f, null, 0, 226, null);
            return;
        }
        float f4 = fM4415getWidthimpl - (2 * f2);
        DrawScope.CC.m5182drawRoundRectuAw5IA$default(drawScope, j, OffsetKt.Offset(f2, f2), androidx.compose.p002ui.geometry.SizeKt.Size(f4, f4), CornerRadiusKt.CornerRadius$default(Math.max(0.0f, f - f2), 0.0f, 2, null), Fill.INSTANCE, 0.0f, null, 0, 224, null);
        float f5 = fM4415getWidthimpl - f2;
        DrawScope.CC.m5182drawRoundRectuAw5IA$default(drawScope, j2, OffsetKt.Offset(f3, f3), androidx.compose.p002ui.geometry.SizeKt.Size(f5, f5), CornerRadiusKt.CornerRadius$default(f - f3, 0.0f, 2, null), stroke, 0.0f, null, 0, 224, null);
    }

    public static final void m2094drawCheck3IgeMak(DrawScope drawScope, long j, float f, float f2, float f3, CheckDrawingCache checkDrawingCache) {
        Stroke stroke = new Stroke(f3, 0.0f, StrokeCap.INSTANCE.m4965getSquareKaPHkGw(), 0, null, 26, null);
        float fM4415getWidthimpl = Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc());
        float fLerp = MathHelpersKt.lerp(0.4f, 0.5f, f2);
        float fLerp2 = MathHelpersKt.lerp(0.7f, 0.5f, f2);
        float fLerp3 = MathHelpersKt.lerp(0.5f, 0.5f, f2);
        float fLerp4 = MathHelpersKt.lerp(0.3f, 0.5f, f2);
        checkDrawingCache.getCheckPath().reset();
        checkDrawingCache.getCheckPath().moveTo(0.2f * fM4415getWidthimpl, fLerp3 * fM4415getWidthimpl);
        checkDrawingCache.getCheckPath().lineTo(fLerp * fM4415getWidthimpl, fLerp2 * fM4415getWidthimpl);
        checkDrawingCache.getCheckPath().lineTo(0.8f * fM4415getWidthimpl, fM4415getWidthimpl * fLerp4);
        checkDrawingCache.getPathMeasure().setPath(checkDrawingCache.getCheckPath(), false);
        checkDrawingCache.getPathToDraw().reset();
        checkDrawingCache.getPathMeasure().getSegment(0.0f, checkDrawingCache.getPathMeasure().getLength() * f, checkDrawingCache.getPathToDraw(), true);
        DrawScope.CC.m5176drawPathLG529CI$default(drawScope, checkDrawingCache.getPathToDraw(), j, 0.0f, stroke, null, 0, 52, null);
    }

    static {
        float f = 2;
        CheckboxDefaultPadding = Dp.constructor-impl(f);
        StrokeWidth = Dp.constructor-impl(f);
        RadiusSize = Dp.constructor-impl(f);
    }
}
