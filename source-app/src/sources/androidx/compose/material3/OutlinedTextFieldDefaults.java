package androidx.compose.material3;

import androidx.compose.animation.SingleValueAnimationKt;
import androidx.compose.animation.core.AnimationSpecKt;
import androidx.compose.foundation.BorderKt;
import androidx.compose.foundation.BorderStroke;
import androidx.compose.foundation.interaction.FocusInteractionKt;
import androidx.compose.foundation.interaction.InteractionSource;
import androidx.compose.foundation.layout.BoxKt;
import androidx.compose.foundation.layout.PaddingKt;
import androidx.compose.foundation.layout.PaddingValues;
import androidx.compose.foundation.text.selection.TextSelectionColors;
import androidx.compose.foundation.text.selection.TextSelectionColorsKt;
import androidx.compose.material3.internal.TextFieldImplKt;
import androidx.compose.material3.internal.TextFieldType;
import androidx.compose.material3.tokens.OutlinedTextFieldTokens;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.Shape;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.State;
import androidx.compose.runtime.internal.ComposableLambda;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.ui.text.input.VisualTransformation;
import androidx.compose.ui.unit.Dp;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.Unit;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.PropertyReference0Impl;

@Metadata(d1 = {"\u0000v\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b)\bÇ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\\\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u001a2\u0006\u0010\u001b\u001a\u00020\u001a2\u0006\u0010\u001c\u001a\u00020\u001d2\b\b\u0002\u0010\u001e\u001a\u00020\u001f2\b\b\u0002\u0010 \u001a\u00020\u00132\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010!\u001a\u00020\u00042\b\b\u0002\u0010\"\u001a\u00020\u0004H\u0007ø\u0001\u0000¢\u0006\u0004\b#\u0010$JR\u0010%\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u001a2\u0006\u0010\u001b\u001a\u00020\u001a2\u0006\u0010\u001c\u001a\u00020\u001d2\b\b\u0002\u0010 \u001a\u00020\u00132\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010!\u001a\u00020\u00042\b\b\u0002\u0010\"\u001a\u00020\u0004H\u0007ø\u0001\u0000¢\u0006\u0004\b&\u0010'J\u009c\u0002\u0010(\u001a\u00020\u00182\u0006\u0010)\u001a\u00020*2\u0011\u0010+\u001a\r\u0012\u0004\u0012\u00020\u00180,¢\u0006\u0002\b-2\u0006\u0010\u0019\u001a\u00020\u001a2\u0006\u0010.\u001a\u00020\u001a2\u0006\u0010/\u001a\u0002002\u0006\u0010\u001c\u001a\u00020\u001d2\b\b\u0002\u0010\u001b\u001a\u00020\u001a2\u0015\b\u0002\u00101\u001a\u000f\u0012\u0004\u0012\u00020\u0018\u0018\u00010,¢\u0006\u0002\b-2\u0015\b\u0002\u00102\u001a\u000f\u0012\u0004\u0012\u00020\u0018\u0018\u00010,¢\u0006\u0002\b-2\u0015\b\u0002\u00103\u001a\u000f\u0012\u0004\u0012\u00020\u0018\u0018\u00010,¢\u0006\u0002\b-2\u0015\b\u0002\u00104\u001a\u000f\u0012\u0004\u0012\u00020\u0018\u0018\u00010,¢\u0006\u0002\b-2\u0015\b\u0002\u00105\u001a\u000f\u0012\u0004\u0012\u00020\u0018\u0018\u00010,¢\u0006\u0002\b-2\u0015\b\u0002\u00106\u001a\u000f\u0012\u0004\u0012\u00020\u0018\u0018\u00010,¢\u0006\u0002\b-2\u0015\b\u0002\u00107\u001a\u000f\u0012\u0004\u0012\u00020\u0018\u0018\u00010,¢\u0006\u0002\b-2\b\b\u0002\u0010 \u001a\u00020\u00132\b\b\u0002\u00108\u001a\u0002092\u0013\b\u0002\u0010:\u001a\r\u0012\u0004\u0012\u00020\u00180,¢\u0006\u0002\b-H\u0007¢\u0006\u0002\u0010;J\r\u0010 \u001a\u00020\u0013H\u0007¢\u0006\u0002\u0010<JÂ\u0003\u0010 \u001a\u00020\u00132\b\b\u0002\u0010=\u001a\u00020>2\b\b\u0002\u0010?\u001a\u00020>2\b\b\u0002\u0010@\u001a\u00020>2\b\b\u0002\u0010A\u001a\u00020>2\b\b\u0002\u0010B\u001a\u00020>2\b\b\u0002\u0010C\u001a\u00020>2\b\b\u0002\u0010D\u001a\u00020>2\b\b\u0002\u0010E\u001a\u00020>2\b\b\u0002\u0010F\u001a\u00020>2\b\b\u0002\u0010G\u001a\u00020>2\n\b\u0002\u0010H\u001a\u0004\u0018\u00010I2\b\b\u0002\u0010J\u001a\u00020>2\b\b\u0002\u0010K\u001a\u00020>2\b\b\u0002\u0010L\u001a\u00020>2\b\b\u0002\u0010M\u001a\u00020>2\b\b\u0002\u0010N\u001a\u00020>2\b\b\u0002\u0010O\u001a\u00020>2\b\b\u0002\u0010P\u001a\u00020>2\b\b\u0002\u0010Q\u001a\u00020>2\b\b\u0002\u0010R\u001a\u00020>2\b\b\u0002\u0010S\u001a\u00020>2\b\b\u0002\u0010T\u001a\u00020>2\b\b\u0002\u0010U\u001a\u00020>2\b\b\u0002\u0010V\u001a\u00020>2\b\b\u0002\u0010W\u001a\u00020>2\b\b\u0002\u0010X\u001a\u00020>2\b\b\u0002\u0010Y\u001a\u00020>2\b\b\u0002\u0010Z\u001a\u00020>2\b\b\u0002\u0010[\u001a\u00020>2\b\b\u0002\u0010\\\u001a\u00020>2\b\b\u0002\u0010]\u001a\u00020>2\b\b\u0002\u0010^\u001a\u00020>2\b\b\u0002\u0010_\u001a\u00020>2\b\b\u0002\u0010`\u001a\u00020>2\b\b\u0002\u0010a\u001a\u00020>2\b\b\u0002\u0010b\u001a\u00020>2\b\b\u0002\u0010c\u001a\u00020>2\b\b\u0002\u0010d\u001a\u00020>2\b\b\u0002\u0010e\u001a\u00020>2\b\b\u0002\u0010f\u001a\u00020>2\b\b\u0002\u0010g\u001a\u00020>2\b\b\u0002\u0010h\u001a\u00020>2\b\b\u0002\u0010i\u001a\u00020>H\u0007ø\u0001\u0000¢\u0006\u0004\bj\u0010kJ8\u00108\u001a\u0002092\b\b\u0002\u0010l\u001a\u00020\u00042\b\b\u0002\u0010m\u001a\u00020\u00042\b\b\u0002\u0010n\u001a\u00020\u00042\b\b\u0002\u0010o\u001a\u00020\u0004ø\u0001\u0000¢\u0006\u0004\bp\u0010qR\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R\u0019\u0010\b\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\t\u0010\u0006R\u0019\u0010\n\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000b\u0010\u0006R\u0019\u0010\f\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\r\u0010\u0006R\u0011\u0010\u000e\u001a\u00020\u000f8G¢\u0006\u0006\u001a\u0004\b\u0010\u0010\u0011R\u0018\u0010\u0012\u001a\u00020\u0013*\u00020\u00148AX\u0080\u0004¢\u0006\u0006\u001a\u0004\b\u0015\u0010\u0016\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006r"}, d2 = {"Landroidx/compose/material3/OutlinedTextFieldDefaults;", "", "()V", "FocusedBorderThickness", "Landroidx/compose/ui/unit/Dp;", "getFocusedBorderThickness-D9Ej5fM", "()F", "F", "MinHeight", "getMinHeight-D9Ej5fM", "MinWidth", "getMinWidth-D9Ej5fM", "UnfocusedBorderThickness", "getUnfocusedBorderThickness-D9Ej5fM", "shape", "Landroidx/compose/ui/graphics/Shape;", "getShape", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/ui/graphics/Shape;", "defaultOutlinedTextFieldColors", "Landroidx/compose/material3/TextFieldColors;", "Landroidx/compose/material3/ColorScheme;", "getDefaultOutlinedTextFieldColors", "(Landroidx/compose/material3/ColorScheme;Landroidx/compose/runtime/Composer;I)Landroidx/compose/material3/TextFieldColors;", TextFieldImplKt.ContainerId, "", "enabled", "", "isError", "interactionSource", "Landroidx/compose/foundation/interaction/InteractionSource;", "modifier", "Landroidx/compose/ui/Modifier;", "colors", "focusedBorderThickness", "unfocusedBorderThickness", "Container-4EFweAY", "(ZZLandroidx/compose/foundation/interaction/InteractionSource;Landroidx/compose/ui/Modifier;Landroidx/compose/material3/TextFieldColors;Landroidx/compose/ui/graphics/Shape;FFLandroidx/compose/runtime/Composer;II)V", "ContainerBox", "ContainerBox-nbWgWpA", "(ZZLandroidx/compose/foundation/interaction/InteractionSource;Landroidx/compose/material3/TextFieldColors;Landroidx/compose/ui/graphics/Shape;FFLandroidx/compose/runtime/Composer;II)V", "DecorationBox", "value", "", "innerTextField", "Lkotlin/Function0;", "Landroidx/compose/runtime/Composable;", "singleLine", "visualTransformation", "Landroidx/compose/ui/text/input/VisualTransformation;", "label", "placeholder", "leadingIcon", "trailingIcon", "prefix", "suffix", "supportingText", "contentPadding", "Landroidx/compose/foundation/layout/PaddingValues;", "container", "(Ljava/lang/String;Lkotlin/jvm/functions/Function2;ZZLandroidx/compose/ui/text/input/VisualTransformation;Landroidx/compose/foundation/interaction/InteractionSource;ZLkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Landroidx/compose/material3/TextFieldColors;Landroidx/compose/foundation/layout/PaddingValues;Lkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;III)V", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/material3/TextFieldColors;", "focusedTextColor", "Landroidx/compose/ui/graphics/Color;", "unfocusedTextColor", "disabledTextColor", "errorTextColor", "focusedContainerColor", "unfocusedContainerColor", "disabledContainerColor", "errorContainerColor", "cursorColor", "errorCursorColor", "selectionColors", "Landroidx/compose/foundation/text/selection/TextSelectionColors;", "focusedBorderColor", "unfocusedBorderColor", "disabledBorderColor", "errorBorderColor", "focusedLeadingIconColor", "unfocusedLeadingIconColor", "disabledLeadingIconColor", "errorLeadingIconColor", "focusedTrailingIconColor", "unfocusedTrailingIconColor", "disabledTrailingIconColor", "errorTrailingIconColor", "focusedLabelColor", "unfocusedLabelColor", "disabledLabelColor", "errorLabelColor", "focusedPlaceholderColor", "unfocusedPlaceholderColor", "disabledPlaceholderColor", "errorPlaceholderColor", "focusedSupportingTextColor", "unfocusedSupportingTextColor", "disabledSupportingTextColor", "errorSupportingTextColor", "focusedPrefixColor", "unfocusedPrefixColor", "disabledPrefixColor", "errorPrefixColor", "focusedSuffixColor", "unfocusedSuffixColor", "disabledSuffixColor", "errorSuffixColor", "colors-0hiis_0", "(JJJJJJJJJJLandroidx/compose/foundation/text/selection/TextSelectionColors;JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJLandroidx/compose/runtime/Composer;IIIIIII)Landroidx/compose/material3/TextFieldColors;", "start", "top", "end", "bottom", "contentPadding-a9UjIt4", "(FFFF)Landroidx/compose/foundation/layout/PaddingValues;", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class OutlinedTextFieldDefaults {
    public static final int $stable = 0;
    public static final OutlinedTextFieldDefaults INSTANCE = new OutlinedTextFieldDefaults();
    private static final float MinHeight = Dp.constructor-impl(56);
    private static final float MinWidth = Dp.constructor-impl(280);
    private static final float UnfocusedBorderThickness = Dp.constructor-impl(1);
    private static final float FocusedBorderThickness = Dp.constructor-impl(2);

    private OutlinedTextFieldDefaults() {
    }

    public final Shape getShape(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -1066756961, "C729@37132L5:TextFieldDefaults.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1066756961, i, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.<get-shape> (TextFieldDefaults.kt:729)");
        }
        Shape value = ShapesKt.getValue(OutlinedTextFieldTokens.INSTANCE.getContainerShape(), composer, 6);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return value;
    }

    public final float m2651getMinHeightD9Ej5fM() {
        return MinHeight;
    }

    public final float m2652getMinWidthD9Ej5fM() {
        return MinWidth;
    }

    public final float m2653getUnfocusedBorderThicknessD9Ej5fM() {
        return UnfocusedBorderThickness;
    }

    public final float m2650getFocusedBorderThicknessD9Ej5fM() {
        return FocusedBorderThickness;
    }

    public final void m2646Container4EFweAY(final boolean z, final boolean z2, final InteractionSource interactionSource, Modifier modifier, TextFieldColors textFieldColors, Shape shape, float f, float f2, Composer composer, final int i, final int i2) {
        int i3;
        Modifier modifier2;
        TextFieldColors textFieldColors2;
        Shape shape2;
        float f3;
        float f4;
        int i4;
        Modifier.Companion companion;
        float f5;
        float f6;
        Modifier modifier3;
        Composer composer2;
        final Shape shape3;
        final TextFieldColors textFieldColors3;
        final Modifier modifier4;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i5;
        Composer composerStartRestartGroup = composer.startRestartGroup(1035477640);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(Container)P(1,4,3,5!1,6,2:c#ui.unit.Dp,7:c#ui.unit.Dp)772@39024L8,773@39083L5,777@39264L25,779@39335L222,788@39599L198,792@39806L153:TextFieldDefaults.kt#uh7d8r");
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
            i3 |= composerStartRestartGroup.changed(z2) ? 32 : 16;
        }
        if ((i2 & 4) != 0) {
            i3 |= 384;
        } else if ((i & 384) == 0) {
            i3 |= composerStartRestartGroup.changed(interactionSource) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        int i6 = i2 & 8;
        if (i6 == 0) {
            if ((i & 3072) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? Fields.CameraDistance : Fields.RotationZ;
            }
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    textFieldColors2 = textFieldColors;
                    if (composerStartRestartGroup.changed(textFieldColors2)) {
                        i5 = Fields.Clip;
                    }
                    i3 |= i5;
                } else {
                    textFieldColors2 = textFieldColors;
                }
                i5 = Fields.Shape;
                i3 |= i5;
            } else {
                textFieldColors2 = textFieldColors;
            }
            if ((196608 & i) == 0) {
                if ((i2 & 32) == 0) {
                    shape2 = shape;
                    int i7 = composerStartRestartGroup.changed(shape2) ? Fields.RenderEffect : 65536;
                    i3 |= i7;
                } else {
                    shape2 = shape;
                }
                i3 |= i7;
            } else {
                shape2 = shape;
            }
            if ((1572864 & i) == 0) {
                if ((i2 & 64) == 0) {
                    f3 = f;
                    int i8 = composerStartRestartGroup.changed(f3) ? 1048576 : 524288;
                    i3 |= i8;
                } else {
                    f3 = f;
                }
                i3 |= i8;
            } else {
                f3 = f;
            }
            if ((12582912 & i) == 0) {
                if ((i2 & Fields.SpotShadowColor) == 0) {
                    f4 = f2;
                    int i9 = composerStartRestartGroup.changed(f4) ? 8388608 : 4194304;
                    i3 |= i9;
                } else {
                    f4 = f2;
                }
                i3 |= i9;
            } else {
                f4 = f2;
            }
            if ((i2 & Fields.RotationX) != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(this)) {
                    i4 = 67108864;
                } else {
                    i4 = 33554432;
                }
                i3 |= i4;
            }
            if ((38347923 & i3) == 38347922 || !composerStartRestartGroup.getSkipping()) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                    if (i6 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 16) != 0) {
                        TextFieldColors textFieldColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                        i3 &= -57345;
                        textFieldColors2 = textFieldColorsColors;
                    }
                    if ((i2 & 32) != 0) {
                        i3 &= -458753;
                        shape2 = INSTANCE.getShape(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        f3 = FocusedBorderThickness;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        i3 &= -29360129;
                        modifier3 = companion;
                        f6 = UnfocusedBorderThickness;
                        f5 = f3;
                    } else {
                        f5 = f3;
                        f6 = f4;
                        modifier3 = companion;
                    }
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                    }
                    if ((i2 & 32) != 0) {
                        i3 &= -458753;
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        i3 &= -29360129;
                    }
                    f5 = f3;
                    f6 = f4;
                    modifier3 = modifier2;
                }
                TextFieldColors textFieldColors4 = textFieldColors2;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1035477640, i3, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.Container (TextFieldDefaults.kt:776)");
                }
                int i10 = i3 >> 6;
                boolean zBooleanValue = FocusInteractionKt.collectIsFocusedAsState(interactionSource, composerStartRestartGroup, i10 & 14).getValue().booleanValue();
                Shape shape4 = shape2;
                Modifier modifier5 = modifier3;
                State<BorderStroke> stateM3341animateBorderStrokeAsStateNuRrP5Q = TextFieldImplKt.m3341animateBorderStrokeAsStateNuRrP5Q(z, z2, zBooleanValue, textFieldColors4, f5, f6, composerStartRestartGroup, ((i3 >> 3) & 7168) | (i3 & 126) | (57344 & i10) | (i10 & 458752));
                composer2 = composerStartRestartGroup;
                final State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(textFieldColors4.m2937containerColorXeAY9LY$material3_release(z, z2, zBooleanValue), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12);
                BoxKt.Box(TextFieldImplKt.textFieldBackground(BorderKt.border(modifier5, stateM3341animateBorderStrokeAsStateNuRrP5Q.getValue(), shape4), new C1403x758e63df(new PropertyReference0Impl(stateM387animateColorAsStateeuL9pac) {
                    public Object get() {
                        return ((State) this.receiver).getValue();
                    }
                }), shape4), composer2, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                shape3 = shape4;
                textFieldColors3 = textFieldColors4;
                modifier4 = modifier5;
            } else {
                composerStartRestartGroup.skipToGroupEnd();
                f5 = f3;
                f6 = f4;
                textFieldColors3 = textFieldColors2;
                shape3 = shape2;
                modifier4 = modifier2;
                composer2 = composerStartRestartGroup;
            }
            scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final float f7 = f5;
                final float f8 = f6;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer3, int i11) {
                        this.$tmp0_rcvr.m2646Container4EFweAY(z, z2, interactionSource, modifier4, textFieldColors3, shape3, f7, f8, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        modifier2 = modifier;
        if ((i & 24576) == 0) {
            if ((i2 & 16) == 0) {
                textFieldColors2 = textFieldColors;
                if (composerStartRestartGroup.changed(textFieldColors2)) {
                    i5 = Fields.Clip;
                }
                i3 |= i5;
            } else {
                textFieldColors2 = textFieldColors;
            }
            i5 = Fields.Shape;
            i3 |= i5;
        } else {
            textFieldColors2 = textFieldColors;
        }
        if ((196608 & i) == 0) {
            if ((i2 & 32) == 0) {
                shape2 = shape;
                if (composerStartRestartGroup.changed(shape2)) {
                }
                i3 |= i7;
            } else {
                shape2 = shape;
            }
            i3 |= i7;
        } else {
            shape2 = shape;
        }
        if ((1572864 & i) == 0) {
            if ((i2 & 64) == 0) {
                f3 = f;
                if (composerStartRestartGroup.changed(f3)) {
                }
                i3 |= i8;
            } else {
                f3 = f;
            }
            i3 |= i8;
        } else {
            f3 = f;
        }
        if ((12582912 & i) == 0) {
            if ((i2 & Fields.SpotShadowColor) == 0) {
                f4 = f2;
                if (composerStartRestartGroup.changed(f4)) {
                }
                i3 |= i9;
            } else {
                f4 = f2;
            }
            i3 |= i9;
        } else {
            f4 = f2;
        }
        if ((i2 & Fields.RotationX) != 0) {
            i3 |= 100663296;
        } else if ((i & 100663296) == 0) {
            if (composerStartRestartGroup.changed(this)) {
                i4 = 67108864;
            } else {
                i4 = 33554432;
            }
            i3 |= i4;
        }
        if ((38347923 & i3) == 38347922) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i6 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 16) != 0) {
                    TextFieldColors textFieldColorsColors2 = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                    i3 &= -57345;
                    textFieldColors2 = textFieldColorsColors2;
                }
                if ((i2 & 32) != 0) {
                    i3 &= -458753;
                    shape2 = INSTANCE.getShape(composerStartRestartGroup, 6);
                }
                if ((i2 & 64) != 0) {
                    i3 &= -3670017;
                    f3 = FocusedBorderThickness;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    i3 &= -29360129;
                    modifier3 = companion;
                    f6 = UnfocusedBorderThickness;
                    f5 = f3;
                } else {
                    f5 = f3;
                    f6 = f4;
                    modifier3 = companion;
                }
            } else {
                if (i6 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 16) != 0) {
                    TextFieldColors textFieldColorsColors3 = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                    i3 &= -57345;
                    textFieldColors2 = textFieldColorsColors3;
                }
                if ((i2 & 32) != 0) {
                    i3 &= -458753;
                    shape2 = INSTANCE.getShape(composerStartRestartGroup, 6);
                }
                if ((i2 & 64) != 0) {
                    i3 &= -3670017;
                    f3 = FocusedBorderThickness;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    i3 &= -29360129;
                    modifier3 = companion;
                    f6 = UnfocusedBorderThickness;
                    f5 = f3;
                } else {
                    f5 = f3;
                    f6 = f4;
                    modifier3 = companion;
                }
            }
            TextFieldColors textFieldColors5 = textFieldColors2;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1035477640, i3, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.Container (TextFieldDefaults.kt:776)");
            }
            int i11 = i3 >> 6;
            boolean zBooleanValue2 = FocusInteractionKt.collectIsFocusedAsState(interactionSource, composerStartRestartGroup, i11 & 14).getValue().booleanValue();
            Shape shape5 = shape2;
            Modifier modifier6 = modifier3;
            State<BorderStroke> stateM3341animateBorderStrokeAsStateNuRrP5Q2 = TextFieldImplKt.m3341animateBorderStrokeAsStateNuRrP5Q(z, z2, zBooleanValue2, textFieldColors5, f5, f6, composerStartRestartGroup, ((i3 >> 3) & 7168) | (i3 & 126) | (57344 & i11) | (i11 & 458752));
            composer2 = composerStartRestartGroup;
            final Object stateM387animateColorAsStateeuL9pac2 = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(textFieldColors5.m2937containerColorXeAY9LY$material3_release(z, z2, zBooleanValue2), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12);
            BoxKt.Box(TextFieldImplKt.textFieldBackground(BorderKt.border(modifier6, stateM3341animateBorderStrokeAsStateNuRrP5Q2.getValue(), shape5), new C1403x758e63df(new PropertyReference0Impl(stateM387animateColorAsStateeuL9pac2) {
                public Object get() {
                    return ((State) this.receiver).getValue();
                }
            }), shape5), composer2, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            shape3 = shape5;
            textFieldColors3 = textFieldColors5;
            modifier4 = modifier6;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i6 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 16) != 0) {
                    TextFieldColors textFieldColorsColors4 = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                    i3 &= -57345;
                    textFieldColors2 = textFieldColorsColors4;
                }
                if ((i2 & 32) != 0) {
                    i3 &= -458753;
                    shape2 = INSTANCE.getShape(composerStartRestartGroup, 6);
                }
                if ((i2 & 64) != 0) {
                    i3 &= -3670017;
                    f3 = FocusedBorderThickness;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    i3 &= -29360129;
                    modifier3 = companion;
                    f6 = UnfocusedBorderThickness;
                    f5 = f3;
                } else {
                    f5 = f3;
                    f6 = f4;
                    modifier3 = companion;
                }
            } else {
                if (i6 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 16) != 0) {
                    TextFieldColors textFieldColorsColors5 = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                    i3 &= -57345;
                    textFieldColors2 = textFieldColorsColors5;
                }
                if ((i2 & 32) != 0) {
                    i3 &= -458753;
                    shape2 = INSTANCE.getShape(composerStartRestartGroup, 6);
                }
                if ((i2 & 64) != 0) {
                    i3 &= -3670017;
                    f3 = FocusedBorderThickness;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    i3 &= -29360129;
                    modifier3 = companion;
                    f6 = UnfocusedBorderThickness;
                    f5 = f3;
                } else {
                    f5 = f3;
                    f6 = f4;
                    modifier3 = companion;
                }
            }
            TextFieldColors textFieldColors6 = textFieldColors2;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1035477640, i3, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.Container (TextFieldDefaults.kt:776)");
            }
            int i12 = i3 >> 6;
            boolean zBooleanValue3 = FocusInteractionKt.collectIsFocusedAsState(interactionSource, composerStartRestartGroup, i12 & 14).getValue().booleanValue();
            Shape shape6 = shape2;
            Modifier modifier7 = modifier3;
            State<BorderStroke> stateM3341animateBorderStrokeAsStateNuRrP5Q3 = TextFieldImplKt.m3341animateBorderStrokeAsStateNuRrP5Q(z, z2, zBooleanValue3, textFieldColors6, f5, f6, composerStartRestartGroup, ((i3 >> 3) & 7168) | (i3 & 126) | (57344 & i12) | (i12 & 458752));
            composer2 = composerStartRestartGroup;
            final Object stateM387animateColorAsStateeuL9pac3 = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(textFieldColors6.m2937containerColorXeAY9LY$material3_release(z, z2, zBooleanValue3), AnimationSpecKt.tween$default(150, 0, null, 6, null), null, null, composer2, 48, 12);
            BoxKt.Box(TextFieldImplKt.textFieldBackground(BorderKt.border(modifier7, stateM3341animateBorderStrokeAsStateNuRrP5Q3.getValue(), shape6), new C1403x758e63df(new PropertyReference0Impl(stateM387animateColorAsStateeuL9pac3) {
                public Object get() {
                    return ((State) this.receiver).getValue();
                }
            }), shape6), composer2, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            shape3 = shape6;
            textFieldColors3 = textFieldColors6;
            modifier4 = modifier7;
        }
        scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final float f9 = f5;
            final float f10 = f6;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer3, int i13) {
                    this.$tmp0_rcvr.m2646Container4EFweAY(z, z2, interactionSource, modifier4, textFieldColors3, shape3, f9, f10, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public final void DecorationBox(final String str, final Function2<? super Composer, ? super Integer, Unit> function2, final boolean z, final boolean z2, final VisualTransformation visualTransformation, final InteractionSource interactionSource, boolean z3, Function2<? super Composer, ? super Integer, Unit> function3, Function2<? super Composer, ? super Integer, Unit> function4, Function2<? super Composer, ? super Integer, Unit> function5, Function2<? super Composer, ? super Integer, Unit> function6, Function2<? super Composer, ? super Integer, Unit> function7, Function2<? super Composer, ? super Integer, Unit> function8, Function2<? super Composer, ? super Integer, Unit> function9, TextFieldColors textFieldColors, PaddingValues paddingValues, Function2<? super Composer, ? super Integer, Unit> function10, Composer composer, final int i, final int i2, final int i3) {
        int i4;
        int i5;
        int i6;
        int i7;
        int i8;
        int i9;
        int i10;
        int i11;
        int i12;
        int i13;
        int i14;
        int i15;
        int i16;
        int i17;
        int i18;
        int i19;
        int i20;
        int i21;
        int i22;
        int i23;
        int i24;
        int i25;
        int i26;
        int i27;
        int i28;
        int i29;
        int i30;
        int i31;
        int i32;
        final boolean z4;
        Function2<? super Composer, ? super Integer, Unit> function11;
        Function2<? super Composer, ? super Integer, Unit> function12;
        Function2<? super Composer, ? super Integer, Unit> function13;
        Function2<? super Composer, ? super Integer, Unit> function14;
        Function2<? super Composer, ? super Integer, Unit> function15;
        Function2<? super Composer, ? super Integer, Unit> function16;
        Function2<? super Composer, ? super Integer, Unit> function17;
        final TextFieldColors textFieldColorsColors;
        PaddingValues paddingValuesM2645contentPaddinga9UjIt4$default;
        Function2<? super Composer, ? super Integer, Unit> function18;
        Function2<? super Composer, ? super Integer, Unit> function19;
        Function2<? super Composer, ? super Integer, Unit> function20;
        int i33;
        boolean z5;
        PaddingValues paddingValues2;
        final Function2<? super Composer, ? super Integer, Unit> function21;
        final PaddingValues paddingValues3;
        final Function2<? super Composer, ? super Integer, Unit> function22;
        final TextFieldColors textFieldColors2;
        final Function2<? super Composer, ? super Integer, Unit> function23;
        final Function2<? super Composer, ? super Integer, Unit> function24;
        final Function2<? super Composer, ? super Integer, Unit> function25;
        final Function2<? super Composer, ? super Integer, Unit> function26;
        final Function2<? super Composer, ? super Integer, Unit> function27;
        final Function2<? super Composer, ? super Integer, Unit> function28;
        final boolean z6;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i34;
        Composer composerStartRestartGroup = composer.startRestartGroup(-350442135);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(DecorationBox)P(15,4,3,11,16,5,6,7,9,8,14,10,12,13!1,2)870@44562L8,872@44674L408,885@45099L709:TextFieldDefaults.kt#uh7d8r");
        if ((i3 & 1) != 0) {
            i4 = i | 6;
        } else if ((i & 6) == 0) {
            i4 = (composerStartRestartGroup.changed(str) ? 4 : 2) | i;
        } else {
            i4 = i;
        }
        if ((i3 & 2) == 0) {
            if ((i & 48) == 0) {
                i4 |= composerStartRestartGroup.changedInstance(function2) ? 32 : 16;
            }
            if ((i3 & 4) != 0) {
                i4 |= 384;
            } else if ((i & 384) == 0) {
                if (composerStartRestartGroup.changed(z)) {
                    i5 = Fields.RotationX;
                } else {
                    i5 = 128;
                }
                i4 |= i5;
            }
            i6 = i3 & 8;
            i7 = Fields.CameraDistance;
            if (i6 != 0) {
                if ((i & 3072) == 0) {
                    if (composerStartRestartGroup.changed(z2)) {
                        i8 = 2048;
                    } else {
                        i8 = 1024;
                    }
                    i4 |= i8;
                }
                i9 = i3 & 16;
                i10 = Fields.Shape;
                if (i9 != 0) {
                    if ((i & 24576) == 0) {
                        if (composerStartRestartGroup.changed(visualTransformation)) {
                            i11 = 16384;
                        } else {
                            i11 = 8192;
                        }
                        i4 |= i11;
                    }
                    if ((i3 & 32) != 0) {
                        i4 |= 196608;
                    } else if ((i & 196608) == 0) {
                        if (composerStartRestartGroup.changed(interactionSource)) {
                            i12 = 131072;
                        } else {
                            i12 = 65536;
                        }
                        i4 |= i12;
                    }
                    i13 = i3 & 64;
                    if (i13 != 0) {
                        i4 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(z3)) {
                            i14 = 1048576;
                        } else {
                            i14 = 524288;
                        }
                        i4 |= i14;
                    }
                    i15 = i3 & Fields.SpotShadowColor;
                    if (i15 != 0) {
                        i4 |= 12582912;
                    } else if ((i & 12582912) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i16 = 8388608;
                        } else {
                            i16 = 4194304;
                        }
                        i4 |= i16;
                    }
                    i17 = i3 & Fields.RotationX;
                    if (i17 != 0) {
                        i4 |= 100663296;
                    } else if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changedInstance(function4)) {
                            i18 = 67108864;
                        } else {
                            i18 = 33554432;
                        }
                        i4 |= i18;
                    }
                    i19 = i3 & Fields.RotationY;
                    if (i19 != 0) {
                        i4 |= 805306368;
                    } else if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function5)) {
                            i20 = 536870912;
                        } else {
                            i20 = 268435456;
                        }
                        i4 |= i20;
                    }
                    i21 = i3 & Fields.RotationZ;
                    if (i21 != 0) {
                        i22 = i2 | 6;
                    } else if ((i2 & 6) == 0) {
                        if (composerStartRestartGroup.changedInstance(function6)) {
                            i23 = 4;
                        } else {
                            i23 = 2;
                        }
                        i22 = i2 | i23;
                    } else {
                        i22 = i2;
                    }
                    i24 = i3 & Fields.CameraDistance;
                    if (i24 != 0) {
                        i22 |= 48;
                    } else if ((i2 & 48) == 0) {
                        if (composerStartRestartGroup.changedInstance(function7)) {
                            i25 = 32;
                        } else {
                            i25 = 16;
                        }
                        i22 |= i25;
                    }
                    i26 = i22;
                    i27 = i3 & Fields.TransformOrigin;
                    if (i27 != 0) {
                        if ((i2 & 384) == 0) {
                            if (composerStartRestartGroup.changedInstance(function8)) {
                                i28 = Fields.RotationX;
                            } else {
                                i28 = 128;
                            }
                            i26 |= i28;
                        }
                        i29 = i3 & Fields.Shape;
                        if (i29 != 0) {
                            if ((i2 & 3072) == 0) {
                                if (!composerStartRestartGroup.changedInstance(function9)) {
                                    i7 = 1024;
                                }
                                i26 |= i7;
                            }
                            if ((i2 & 24576) != 0) {
                                if ((i3 & Fields.Clip) == 0 && composerStartRestartGroup.changed(textFieldColors)) {
                                    i10 = 16384;
                                }
                                i26 |= i10;
                            }
                            if ((i2 & 196608) != 0) {
                                if ((i3 & Fields.CompositingStrategy) == 0 || !composerStartRestartGroup.changed(paddingValues)) {
                                    i34 = 65536;
                                } else {
                                    i34 = 131072;
                                }
                                i26 |= i34;
                            }
                            i30 = i3 & 65536;
                            if (i30 != 0) {
                                i26 |= 1572864;
                            } else if ((i2 & 1572864) == 0) {
                                if (composerStartRestartGroup.changedInstance(function10)) {
                                    i31 = 1048576;
                                } else {
                                    i31 = 524288;
                                }
                                i26 |= i31;
                            }
                            if ((i3 & Fields.RenderEffect) != 0) {
                                i26 |= 12582912;
                            } else if ((i2 & 12582912) == 0) {
                                if (composerStartRestartGroup.changed(this)) {
                                    i32 = 8388608;
                                } else {
                                    i32 = 4194304;
                                }
                                i26 |= i32;
                            }
                            if ((i4 & 306783379) == 306783378 || (4793491 & i26) != 4793490 || !composerStartRestartGroup.getSkipping()) {
                                composerStartRestartGroup.startDefaults();
                                if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                                    if (i13 != 0) {
                                        z4 = false;
                                    } else {
                                        z4 = z3;
                                    }
                                    if (i15 != 0) {
                                        function11 = null;
                                    } else {
                                        function11 = function3;
                                    }
                                    if (i17 != 0) {
                                        function12 = null;
                                    } else {
                                        function12 = function4;
                                    }
                                    if (i19 != 0) {
                                        function13 = null;
                                    } else {
                                        function13 = function5;
                                    }
                                    if (i21 != 0) {
                                        function14 = null;
                                    } else {
                                        function14 = function6;
                                    }
                                    if (i24 != 0) {
                                        function15 = null;
                                    } else {
                                        function15 = function7;
                                    }
                                    if (i27 != 0) {
                                        function16 = null;
                                    } else {
                                        function16 = function8;
                                    }
                                    function17 = i29 == 0 ? function9 : null;
                                    if ((i3 & Fields.Clip) != 0) {
                                        textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                        i26 &= -57345;
                                    } else {
                                        textFieldColorsColors = textFieldColors;
                                    }
                                    if ((i3 & Fields.CompositingStrategy) != 0) {
                                        paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                        i26 &= -458753;
                                    } else {
                                        paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                                    }
                                    function18 = function13;
                                    if (i30 != 0) {
                                        ComposableLambda composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                            {
                                                super(2);
                                            }

                                            public Object invoke(Object obj, Object obj2) {
                                                invoke((Composer) obj, ((Number) obj2).intValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(Composer composer2, int i35) {
                                                ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                                if ((i35 & 3) != 2 || !composer2.getSkipping()) {
                                                    if (ComposerKt.isTraceInProgress()) {
                                                        ComposerKt.traceEventStart(-1448570018, i35, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                                    }
                                                    OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                                    if (ComposerKt.isTraceInProgress()) {
                                                        ComposerKt.traceEventEnd();
                                                        return;
                                                    }
                                                    return;
                                                }
                                                composer2.skipToGroupEnd();
                                            }
                                        }, composerStartRestartGroup, 54);
                                        function15 = function15;
                                        function19 = function14;
                                        function20 = composableLambdaRememberComposableLambda;
                                    } else {
                                        function19 = function14;
                                        function20 = function10;
                                    }
                                    i33 = i26;
                                    z5 = z4;
                                    paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                                } else {
                                    composerStartRestartGroup.skipToGroupEnd();
                                    if ((i3 & Fields.Clip) != 0) {
                                        i26 &= -57345;
                                    }
                                    if ((32768 & i3) != 0) {
                                        i26 &= -458753;
                                    }
                                    z5 = z3;
                                    function11 = function3;
                                    function12 = function4;
                                    function18 = function5;
                                    function19 = function6;
                                    function15 = function7;
                                    function16 = function8;
                                    function17 = function9;
                                    textFieldColorsColors = textFieldColors;
                                    function20 = function10;
                                    i33 = i26;
                                    paddingValues2 = paddingValues;
                                }
                                composerStartRestartGroup.endDefaults();
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                                }
                                int i35 = i4 << 3;
                                int i36 = i4 >> 3;
                                int i37 = i4 >> 9;
                                int i38 = i33 << 21;
                                TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i35 & 896) | (i35 & 112) | 6 | (i36 & 7168) | (i37 & 57344) | (i37 & 458752) | (i37 & 3670016) | (i38 & 29360128) | (i38 & 234881024) | (i38 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i37 & 7168) | (57344 & i36) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                                function21 = function19;
                                paddingValues3 = paddingValues2;
                                function22 = function16;
                                textFieldColors2 = textFieldColorsColors;
                                function23 = function12;
                                function24 = function17;
                                function25 = function20;
                                function26 = function18;
                                function27 = function15;
                                function28 = function11;
                                z6 = z5;
                            } else {
                                composerStartRestartGroup.skipToGroupEnd();
                                z6 = z3;
                                function28 = function3;
                                function23 = function4;
                                function26 = function5;
                                function21 = function6;
                                function27 = function7;
                                function22 = function8;
                                function24 = function9;
                                textFieldColors2 = textFieldColors;
                                paddingValues3 = paddingValues;
                                function25 = function10;
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

                                    public final void invoke(Composer composer2, int i39) {
                                        OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                                    }
                                });
                            }
                        }
                        i26 |= 3072;
                        if ((i2 & 24576) != 0) {
                            if ((i3 & Fields.Clip) == 0) {
                                i10 = 16384;
                            }
                            i26 |= i10;
                        }
                        if ((i2 & 196608) != 0) {
                            if ((i3 & Fields.CompositingStrategy) == 0) {
                                i34 = 65536;
                            } else {
                                i34 = 65536;
                            }
                            i26 |= i34;
                        }
                        i30 = i3 & 65536;
                        if (i30 != 0) {
                            i26 |= 1572864;
                        } else if ((i2 & 1572864) == 0) {
                            if (composerStartRestartGroup.changedInstance(function10)) {
                                i31 = 1048576;
                            } else {
                                i31 = 524288;
                            }
                            i26 |= i31;
                        }
                        if ((i3 & Fields.RenderEffect) != 0) {
                            i26 |= 12582912;
                        } else if ((i2 & 12582912) == 0) {
                            if (composerStartRestartGroup.changed(this)) {
                                i32 = 8388608;
                            } else {
                                i32 = 4194304;
                            }
                            i26 |= i32;
                        }
                        if ((i4 & 306783379) == 306783378) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i13 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z3;
                                }
                                if (i15 != 0) {
                                    function11 = null;
                                } else {
                                    function11 = function3;
                                }
                                if (i17 != 0) {
                                    function12 = null;
                                } else {
                                    function12 = function4;
                                }
                                if (i19 != 0) {
                                    function13 = null;
                                } else {
                                    function13 = function5;
                                }
                                if (i21 != 0) {
                                    function14 = null;
                                } else {
                                    function14 = function6;
                                }
                                if (i24 != 0) {
                                    function15 = null;
                                } else {
                                    function15 = function7;
                                }
                                if (i27 != 0) {
                                    function16 = null;
                                } else {
                                    function16 = function8;
                                }
                                if (i29 == 0) {
                                }
                                if ((i3 & Fields.Clip) != 0) {
                                    textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                    i26 &= -57345;
                                } else {
                                    textFieldColorsColors = textFieldColors;
                                }
                                if ((i3 & Fields.CompositingStrategy) != 0) {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                    i26 &= -458753;
                                } else {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                                }
                                function18 = function13;
                                if (i30 != 0) {
                                    ComposableLambda composableLambdaRememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer2, int i39) {
                                            ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                            if ((i39 & 3) != 2 || !composer2.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1448570018, i39, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                                }
                                                OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer2.skipToGroupEnd();
                                        }
                                    }, composerStartRestartGroup, 54);
                                    function15 = function15;
                                    function19 = function14;
                                    function20 = composableLambdaRememberComposableLambda2;
                                } else {
                                    function19 = function14;
                                    function20 = function10;
                                }
                                i33 = i26;
                                z5 = z4;
                                paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                            } else {
                                if (i13 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z3;
                                }
                                if (i15 != 0) {
                                    function11 = null;
                                } else {
                                    function11 = function3;
                                }
                                if (i17 != 0) {
                                    function12 = null;
                                } else {
                                    function12 = function4;
                                }
                                if (i19 != 0) {
                                    function13 = null;
                                } else {
                                    function13 = function5;
                                }
                                if (i21 != 0) {
                                    function14 = null;
                                } else {
                                    function14 = function6;
                                }
                                if (i24 != 0) {
                                    function15 = null;
                                } else {
                                    function15 = function7;
                                }
                                if (i27 != 0) {
                                    function16 = null;
                                } else {
                                    function16 = function8;
                                }
                                if (i29 == 0) {
                                }
                                if ((i3 & Fields.Clip) != 0) {
                                    textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                    i26 &= -57345;
                                } else {
                                    textFieldColorsColors = textFieldColors;
                                }
                                if ((i3 & Fields.CompositingStrategy) != 0) {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                    i26 &= -458753;
                                } else {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                                }
                                function18 = function13;
                                if (i30 != 0) {
                                    ComposableLambda composableLambdaRememberComposableLambda3 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer2, int i39) {
                                            ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                            if ((i39 & 3) != 2 || !composer2.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1448570018, i39, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                                }
                                                OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer2.skipToGroupEnd();
                                        }
                                    }, composerStartRestartGroup, 54);
                                    function15 = function15;
                                    function19 = function14;
                                    function20 = composableLambdaRememberComposableLambda3;
                                } else {
                                    function19 = function14;
                                    function20 = function10;
                                }
                                i33 = i26;
                                z5 = z4;
                                paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                            }
                            int i39 = i4 << 3;
                            int i310 = i4 >> 3;
                            int i311 = i4 >> 9;
                            int i312 = i33 << 21;
                            TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i39 & 896) | (i39 & 112) | 6 | (i310 & 7168) | (i311 & 57344) | (i311 & 458752) | (i311 & 3670016) | (i312 & 29360128) | (i312 & 234881024) | (i312 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i311 & 7168) | (57344 & i310) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            function21 = function19;
                            paddingValues3 = paddingValues2;
                            function22 = function16;
                            textFieldColors2 = textFieldColorsColors;
                            function23 = function12;
                            function24 = function17;
                            function25 = function20;
                            function26 = function18;
                            function27 = function15;
                            function28 = function11;
                            z6 = z5;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i13 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z3;
                                }
                                if (i15 != 0) {
                                    function11 = null;
                                } else {
                                    function11 = function3;
                                }
                                if (i17 != 0) {
                                    function12 = null;
                                } else {
                                    function12 = function4;
                                }
                                if (i19 != 0) {
                                    function13 = null;
                                } else {
                                    function13 = function5;
                                }
                                if (i21 != 0) {
                                    function14 = null;
                                } else {
                                    function14 = function6;
                                }
                                if (i24 != 0) {
                                    function15 = null;
                                } else {
                                    function15 = function7;
                                }
                                if (i27 != 0) {
                                    function16 = null;
                                } else {
                                    function16 = function8;
                                }
                                if (i29 == 0) {
                                }
                                if ((i3 & Fields.Clip) != 0) {
                                    textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                    i26 &= -57345;
                                } else {
                                    textFieldColorsColors = textFieldColors;
                                }
                                if ((i3 & Fields.CompositingStrategy) != 0) {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                    i26 &= -458753;
                                } else {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                                }
                                function18 = function13;
                                if (i30 != 0) {
                                    ComposableLambda composableLambdaRememberComposableLambda4 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer2, int i313) {
                                            ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                            if ((i313 & 3) != 2 || !composer2.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1448570018, i313, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                                }
                                                OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer2.skipToGroupEnd();
                                        }
                                    }, composerStartRestartGroup, 54);
                                    function15 = function15;
                                    function19 = function14;
                                    function20 = composableLambdaRememberComposableLambda4;
                                } else {
                                    function19 = function14;
                                    function20 = function10;
                                }
                                i33 = i26;
                                z5 = z4;
                                paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                            } else {
                                if (i13 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z3;
                                }
                                if (i15 != 0) {
                                    function11 = null;
                                } else {
                                    function11 = function3;
                                }
                                if (i17 != 0) {
                                    function12 = null;
                                } else {
                                    function12 = function4;
                                }
                                if (i19 != 0) {
                                    function13 = null;
                                } else {
                                    function13 = function5;
                                }
                                if (i21 != 0) {
                                    function14 = null;
                                } else {
                                    function14 = function6;
                                }
                                if (i24 != 0) {
                                    function15 = null;
                                } else {
                                    function15 = function7;
                                }
                                if (i27 != 0) {
                                    function16 = null;
                                } else {
                                    function16 = function8;
                                }
                                if (i29 == 0) {
                                }
                                if ((i3 & Fields.Clip) != 0) {
                                    textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                    i26 &= -57345;
                                } else {
                                    textFieldColorsColors = textFieldColors;
                                }
                                if ((i3 & Fields.CompositingStrategy) != 0) {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                    i26 &= -458753;
                                } else {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                                }
                                function18 = function13;
                                if (i30 != 0) {
                                    ComposableLambda composableLambdaRememberComposableLambda5 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer2, int i313) {
                                            ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                            if ((i313 & 3) != 2 || !composer2.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1448570018, i313, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                                }
                                                OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer2.skipToGroupEnd();
                                        }
                                    }, composerStartRestartGroup, 54);
                                    function15 = function15;
                                    function19 = function14;
                                    function20 = composableLambdaRememberComposableLambda5;
                                } else {
                                    function19 = function14;
                                    function20 = function10;
                                }
                                i33 = i26;
                                z5 = z4;
                                paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                            }
                            int i313 = i4 << 3;
                            int i314 = i4 >> 3;
                            int i315 = i4 >> 9;
                            int i316 = i33 << 21;
                            TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i313 & 896) | (i313 & 112) | 6 | (i314 & 7168) | (i315 & 57344) | (i315 & 458752) | (i315 & 3670016) | (i316 & 29360128) | (i316 & 234881024) | (i316 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i315 & 7168) | (57344 & i314) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            function21 = function19;
                            paddingValues3 = paddingValues2;
                            function22 = function16;
                            textFieldColors2 = textFieldColorsColors;
                            function23 = function12;
                            function24 = function17;
                            function25 = function20;
                            function26 = function18;
                            function27 = function15;
                            function28 = function11;
                            z6 = z5;
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

                                public final void invoke(Composer composer2, int i317) {
                                    OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                                }
                            });
                        }
                    }
                    i26 |= 384;
                    i29 = i3 & Fields.Shape;
                    if (i29 != 0) {
                        if ((i2 & 3072) == 0) {
                            if (!composerStartRestartGroup.changedInstance(function9)) {
                                i7 = 1024;
                            }
                            i26 |= i7;
                        }
                        if ((i2 & 24576) != 0) {
                            if ((i3 & Fields.Clip) == 0) {
                                i10 = 16384;
                            }
                            i26 |= i10;
                        }
                        if ((i2 & 196608) != 0) {
                            if ((i3 & Fields.CompositingStrategy) == 0) {
                                i34 = 65536;
                            } else {
                                i34 = 65536;
                            }
                            i26 |= i34;
                        }
                        i30 = i3 & 65536;
                        if (i30 != 0) {
                            i26 |= 1572864;
                        } else if ((i2 & 1572864) == 0) {
                            if (composerStartRestartGroup.changedInstance(function10)) {
                                i31 = 1048576;
                            } else {
                                i31 = 524288;
                            }
                            i26 |= i31;
                        }
                        if ((i3 & Fields.RenderEffect) != 0) {
                            i26 |= 12582912;
                        } else if ((i2 & 12582912) == 0) {
                            if (composerStartRestartGroup.changed(this)) {
                                i32 = 8388608;
                            } else {
                                i32 = 4194304;
                            }
                            i26 |= i32;
                        }
                        if ((i4 & 306783379) == 306783378) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i13 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z3;
                                }
                                if (i15 != 0) {
                                    function11 = null;
                                } else {
                                    function11 = function3;
                                }
                                if (i17 != 0) {
                                    function12 = null;
                                } else {
                                    function12 = function4;
                                }
                                if (i19 != 0) {
                                    function13 = null;
                                } else {
                                    function13 = function5;
                                }
                                if (i21 != 0) {
                                    function14 = null;
                                } else {
                                    function14 = function6;
                                }
                                if (i24 != 0) {
                                    function15 = null;
                                } else {
                                    function15 = function7;
                                }
                                if (i27 != 0) {
                                    function16 = null;
                                } else {
                                    function16 = function8;
                                }
                                if (i29 == 0) {
                                }
                                if ((i3 & Fields.Clip) != 0) {
                                    textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                    i26 &= -57345;
                                } else {
                                    textFieldColorsColors = textFieldColors;
                                }
                                if ((i3 & Fields.CompositingStrategy) != 0) {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                    i26 &= -458753;
                                } else {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                                }
                                function18 = function13;
                                if (i30 != 0) {
                                    ComposableLambda composableLambdaRememberComposableLambda6 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer2, int i317) {
                                            ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                            if ((i317 & 3) != 2 || !composer2.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1448570018, i317, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                                }
                                                OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer2.skipToGroupEnd();
                                        }
                                    }, composerStartRestartGroup, 54);
                                    function15 = function15;
                                    function19 = function14;
                                    function20 = composableLambdaRememberComposableLambda6;
                                } else {
                                    function19 = function14;
                                    function20 = function10;
                                }
                                i33 = i26;
                                z5 = z4;
                                paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                            } else {
                                if (i13 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z3;
                                }
                                if (i15 != 0) {
                                    function11 = null;
                                } else {
                                    function11 = function3;
                                }
                                if (i17 != 0) {
                                    function12 = null;
                                } else {
                                    function12 = function4;
                                }
                                if (i19 != 0) {
                                    function13 = null;
                                } else {
                                    function13 = function5;
                                }
                                if (i21 != 0) {
                                    function14 = null;
                                } else {
                                    function14 = function6;
                                }
                                if (i24 != 0) {
                                    function15 = null;
                                } else {
                                    function15 = function7;
                                }
                                if (i27 != 0) {
                                    function16 = null;
                                } else {
                                    function16 = function8;
                                }
                                if (i29 == 0) {
                                }
                                if ((i3 & Fields.Clip) != 0) {
                                    textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                    i26 &= -57345;
                                } else {
                                    textFieldColorsColors = textFieldColors;
                                }
                                if ((i3 & Fields.CompositingStrategy) != 0) {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                    i26 &= -458753;
                                } else {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                                }
                                function18 = function13;
                                if (i30 != 0) {
                                    ComposableLambda composableLambdaRememberComposableLambda7 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer2, int i317) {
                                            ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                            if ((i317 & 3) != 2 || !composer2.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1448570018, i317, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                                }
                                                OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer2.skipToGroupEnd();
                                        }
                                    }, composerStartRestartGroup, 54);
                                    function15 = function15;
                                    function19 = function14;
                                    function20 = composableLambdaRememberComposableLambda7;
                                } else {
                                    function19 = function14;
                                    function20 = function10;
                                }
                                i33 = i26;
                                z5 = z4;
                                paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                            }
                            int i317 = i4 << 3;
                            int i318 = i4 >> 3;
                            int i319 = i4 >> 9;
                            int i3110 = i33 << 21;
                            TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i317 & 896) | (i317 & 112) | 6 | (i318 & 7168) | (i319 & 57344) | (i319 & 458752) | (i319 & 3670016) | (i3110 & 29360128) | (i3110 & 234881024) | (i3110 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i319 & 7168) | (57344 & i318) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            function21 = function19;
                            paddingValues3 = paddingValues2;
                            function22 = function16;
                            textFieldColors2 = textFieldColorsColors;
                            function23 = function12;
                            function24 = function17;
                            function25 = function20;
                            function26 = function18;
                            function27 = function15;
                            function28 = function11;
                            z6 = z5;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i13 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z3;
                                }
                                if (i15 != 0) {
                                    function11 = null;
                                } else {
                                    function11 = function3;
                                }
                                if (i17 != 0) {
                                    function12 = null;
                                } else {
                                    function12 = function4;
                                }
                                if (i19 != 0) {
                                    function13 = null;
                                } else {
                                    function13 = function5;
                                }
                                if (i21 != 0) {
                                    function14 = null;
                                } else {
                                    function14 = function6;
                                }
                                if (i24 != 0) {
                                    function15 = null;
                                } else {
                                    function15 = function7;
                                }
                                if (i27 != 0) {
                                    function16 = null;
                                } else {
                                    function16 = function8;
                                }
                                if (i29 == 0) {
                                }
                                if ((i3 & Fields.Clip) != 0) {
                                    textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                    i26 &= -57345;
                                } else {
                                    textFieldColorsColors = textFieldColors;
                                }
                                if ((i3 & Fields.CompositingStrategy) != 0) {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                    i26 &= -458753;
                                } else {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                                }
                                function18 = function13;
                                if (i30 != 0) {
                                    ComposableLambda composableLambdaRememberComposableLambda8 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer2, int i3111) {
                                            ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                            if ((i3111 & 3) != 2 || !composer2.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1448570018, i3111, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                                }
                                                OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer2.skipToGroupEnd();
                                        }
                                    }, composerStartRestartGroup, 54);
                                    function15 = function15;
                                    function19 = function14;
                                    function20 = composableLambdaRememberComposableLambda8;
                                } else {
                                    function19 = function14;
                                    function20 = function10;
                                }
                                i33 = i26;
                                z5 = z4;
                                paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                            } else {
                                if (i13 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z3;
                                }
                                if (i15 != 0) {
                                    function11 = null;
                                } else {
                                    function11 = function3;
                                }
                                if (i17 != 0) {
                                    function12 = null;
                                } else {
                                    function12 = function4;
                                }
                                if (i19 != 0) {
                                    function13 = null;
                                } else {
                                    function13 = function5;
                                }
                                if (i21 != 0) {
                                    function14 = null;
                                } else {
                                    function14 = function6;
                                }
                                if (i24 != 0) {
                                    function15 = null;
                                } else {
                                    function15 = function7;
                                }
                                if (i27 != 0) {
                                    function16 = null;
                                } else {
                                    function16 = function8;
                                }
                                if (i29 == 0) {
                                }
                                if ((i3 & Fields.Clip) != 0) {
                                    textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                    i26 &= -57345;
                                } else {
                                    textFieldColorsColors = textFieldColors;
                                }
                                if ((i3 & Fields.CompositingStrategy) != 0) {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                    i26 &= -458753;
                                } else {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                                }
                                function18 = function13;
                                if (i30 != 0) {
                                    ComposableLambda composableLambdaRememberComposableLambda9 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer2, int i3111) {
                                            ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                            if ((i3111 & 3) != 2 || !composer2.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1448570018, i3111, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                                }
                                                OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer2.skipToGroupEnd();
                                        }
                                    }, composerStartRestartGroup, 54);
                                    function15 = function15;
                                    function19 = function14;
                                    function20 = composableLambdaRememberComposableLambda9;
                                } else {
                                    function19 = function14;
                                    function20 = function10;
                                }
                                i33 = i26;
                                z5 = z4;
                                paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                            }
                            int i3111 = i4 << 3;
                            int i3112 = i4 >> 3;
                            int i3113 = i4 >> 9;
                            int i3114 = i33 << 21;
                            TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i3111 & 896) | (i3111 & 112) | 6 | (i3112 & 7168) | (i3113 & 57344) | (i3113 & 458752) | (i3113 & 3670016) | (i3114 & 29360128) | (i3114 & 234881024) | (i3114 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i3113 & 7168) | (57344 & i3112) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            function21 = function19;
                            paddingValues3 = paddingValues2;
                            function22 = function16;
                            textFieldColors2 = textFieldColorsColors;
                            function23 = function12;
                            function24 = function17;
                            function25 = function20;
                            function26 = function18;
                            function27 = function15;
                            function28 = function11;
                            z6 = z5;
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

                                public final void invoke(Composer composer2, int i3115) {
                                    OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                                }
                            });
                        }
                    }
                    i26 |= 3072;
                    if ((i2 & 24576) != 0) {
                        if ((i3 & Fields.Clip) == 0) {
                            i10 = 16384;
                        }
                        i26 |= i10;
                    }
                    if ((i2 & 196608) != 0) {
                        if ((i3 & Fields.CompositingStrategy) == 0) {
                            i34 = 65536;
                        } else {
                            i34 = 65536;
                        }
                        i26 |= i34;
                    }
                    i30 = i3 & 65536;
                    if (i30 != 0) {
                        i26 |= 1572864;
                    } else if ((i2 & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function10)) {
                            i31 = 1048576;
                        } else {
                            i31 = 524288;
                        }
                        i26 |= i31;
                    }
                    if ((i3 & Fields.RenderEffect) != 0) {
                        i26 |= 12582912;
                    } else if ((i2 & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(this)) {
                            i32 = 8388608;
                        } else {
                            i32 = 4194304;
                        }
                        i26 |= i32;
                    }
                    if ((i4 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda10 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i3115) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i3115 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i3115, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda10;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        } else {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda11 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i3115) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i3115 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i3115, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda11;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                        }
                        int i3115 = i4 << 3;
                        int i3116 = i4 >> 3;
                        int i3117 = i4 >> 9;
                        int i3118 = i33 << 21;
                        TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i3115 & 896) | (i3115 & 112) | 6 | (i3116 & 7168) | (i3117 & 57344) | (i3117 & 458752) | (i3117 & 3670016) | (i3118 & 29360128) | (i3118 & 234881024) | (i3118 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i3117 & 7168) | (57344 & i3116) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function21 = function19;
                        paddingValues3 = paddingValues2;
                        function22 = function16;
                        textFieldColors2 = textFieldColorsColors;
                        function23 = function12;
                        function24 = function17;
                        function25 = function20;
                        function26 = function18;
                        function27 = function15;
                        function28 = function11;
                        z6 = z5;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda12 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i3119) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i3119 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i3119, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda12;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        } else {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda13 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i3119) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i3119 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i3119, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda13;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                        }
                        int i3119 = i4 << 3;
                        int i31110 = i4 >> 3;
                        int i31111 = i4 >> 9;
                        int i31112 = i33 << 21;
                        TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i3119 & 896) | (i3119 & 112) | 6 | (i31110 & 7168) | (i31111 & 57344) | (i31111 & 458752) | (i31111 & 3670016) | (i31112 & 29360128) | (i31112 & 234881024) | (i31112 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i31111 & 7168) | (57344 & i31110) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function21 = function19;
                        paddingValues3 = paddingValues2;
                        function22 = function16;
                        textFieldColors2 = textFieldColorsColors;
                        function23 = function12;
                        function24 = function17;
                        function25 = function20;
                        function26 = function18;
                        function27 = function15;
                        function28 = function11;
                        z6 = z5;
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

                            public final void invoke(Composer composer2, int i31113) {
                                OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                            }
                        });
                    }
                }
                i4 |= 24576;
                if ((i3 & 32) != 0) {
                    i4 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changed(interactionSource)) {
                        i12 = 131072;
                    } else {
                        i12 = 65536;
                    }
                    i4 |= i12;
                }
                i13 = i3 & 64;
                if (i13 != 0) {
                    i4 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(z3)) {
                        i14 = 1048576;
                    } else {
                        i14 = 524288;
                    }
                    i4 |= i14;
                }
                i15 = i3 & Fields.SpotShadowColor;
                if (i15 != 0) {
                    i4 |= 12582912;
                } else if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i16 = 8388608;
                    } else {
                        i16 = 4194304;
                    }
                    i4 |= i16;
                }
                i17 = i3 & Fields.RotationX;
                if (i17 != 0) {
                    i4 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i18 = 67108864;
                    } else {
                        i18 = 33554432;
                    }
                    i4 |= i18;
                }
                i19 = i3 & Fields.RotationY;
                if (i19 != 0) {
                    i4 |= 805306368;
                } else if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function5)) {
                        i20 = 536870912;
                    } else {
                        i20 = 268435456;
                    }
                    i4 |= i20;
                }
                i21 = i3 & Fields.RotationZ;
                if (i21 != 0) {
                    i22 = i2 | 6;
                } else if ((i2 & 6) == 0) {
                    if (composerStartRestartGroup.changedInstance(function6)) {
                        i23 = 4;
                    } else {
                        i23 = 2;
                    }
                    i22 = i2 | i23;
                } else {
                    i22 = i2;
                }
                i24 = i3 & Fields.CameraDistance;
                if (i24 != 0) {
                    i22 |= 48;
                } else if ((i2 & 48) == 0) {
                    if (composerStartRestartGroup.changedInstance(function7)) {
                        i25 = 32;
                    } else {
                        i25 = 16;
                    }
                    i22 |= i25;
                }
                i26 = i22;
                i27 = i3 & Fields.TransformOrigin;
                if (i27 != 0) {
                    if ((i2 & 384) == 0) {
                        if (composerStartRestartGroup.changedInstance(function8)) {
                            i28 = Fields.RotationX;
                        } else {
                            i28 = 128;
                        }
                        i26 |= i28;
                    }
                    i29 = i3 & Fields.Shape;
                    if (i29 != 0) {
                        if ((i2 & 3072) == 0) {
                            if (!composerStartRestartGroup.changedInstance(function9)) {
                                i7 = 1024;
                            }
                            i26 |= i7;
                        }
                        if ((i2 & 24576) != 0) {
                            if ((i3 & Fields.Clip) == 0) {
                                i10 = 16384;
                            }
                            i26 |= i10;
                        }
                        if ((i2 & 196608) != 0) {
                            if ((i3 & Fields.CompositingStrategy) == 0) {
                                i34 = 65536;
                            } else {
                                i34 = 65536;
                            }
                            i26 |= i34;
                        }
                        i30 = i3 & 65536;
                        if (i30 != 0) {
                            i26 |= 1572864;
                        } else if ((i2 & 1572864) == 0) {
                            if (composerStartRestartGroup.changedInstance(function10)) {
                                i31 = 1048576;
                            } else {
                                i31 = 524288;
                            }
                            i26 |= i31;
                        }
                        if ((i3 & Fields.RenderEffect) != 0) {
                            i26 |= 12582912;
                        } else if ((i2 & 12582912) == 0) {
                            if (composerStartRestartGroup.changed(this)) {
                                i32 = 8388608;
                            } else {
                                i32 = 4194304;
                            }
                            i26 |= i32;
                        }
                        if ((i4 & 306783379) == 306783378) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i13 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z3;
                                }
                                if (i15 != 0) {
                                    function11 = null;
                                } else {
                                    function11 = function3;
                                }
                                if (i17 != 0) {
                                    function12 = null;
                                } else {
                                    function12 = function4;
                                }
                                if (i19 != 0) {
                                    function13 = null;
                                } else {
                                    function13 = function5;
                                }
                                if (i21 != 0) {
                                    function14 = null;
                                } else {
                                    function14 = function6;
                                }
                                if (i24 != 0) {
                                    function15 = null;
                                } else {
                                    function15 = function7;
                                }
                                if (i27 != 0) {
                                    function16 = null;
                                } else {
                                    function16 = function8;
                                }
                                if (i29 == 0) {
                                }
                                if ((i3 & Fields.Clip) != 0) {
                                    textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                    i26 &= -57345;
                                } else {
                                    textFieldColorsColors = textFieldColors;
                                }
                                if ((i3 & Fields.CompositingStrategy) != 0) {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                    i26 &= -458753;
                                } else {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                                }
                                function18 = function13;
                                if (i30 != 0) {
                                    ComposableLambda composableLambdaRememberComposableLambda14 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer2, int i31113) {
                                            ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                            if ((i31113 & 3) != 2 || !composer2.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1448570018, i31113, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                                }
                                                OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer2.skipToGroupEnd();
                                        }
                                    }, composerStartRestartGroup, 54);
                                    function15 = function15;
                                    function19 = function14;
                                    function20 = composableLambdaRememberComposableLambda14;
                                } else {
                                    function19 = function14;
                                    function20 = function10;
                                }
                                i33 = i26;
                                z5 = z4;
                                paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                            } else {
                                if (i13 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z3;
                                }
                                if (i15 != 0) {
                                    function11 = null;
                                } else {
                                    function11 = function3;
                                }
                                if (i17 != 0) {
                                    function12 = null;
                                } else {
                                    function12 = function4;
                                }
                                if (i19 != 0) {
                                    function13 = null;
                                } else {
                                    function13 = function5;
                                }
                                if (i21 != 0) {
                                    function14 = null;
                                } else {
                                    function14 = function6;
                                }
                                if (i24 != 0) {
                                    function15 = null;
                                } else {
                                    function15 = function7;
                                }
                                if (i27 != 0) {
                                    function16 = null;
                                } else {
                                    function16 = function8;
                                }
                                if (i29 == 0) {
                                }
                                if ((i3 & Fields.Clip) != 0) {
                                    textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                    i26 &= -57345;
                                } else {
                                    textFieldColorsColors = textFieldColors;
                                }
                                if ((i3 & Fields.CompositingStrategy) != 0) {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                    i26 &= -458753;
                                } else {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                                }
                                function18 = function13;
                                if (i30 != 0) {
                                    ComposableLambda composableLambdaRememberComposableLambda15 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer2, int i31113) {
                                            ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                            if ((i31113 & 3) != 2 || !composer2.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1448570018, i31113, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                                }
                                                OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer2.skipToGroupEnd();
                                        }
                                    }, composerStartRestartGroup, 54);
                                    function15 = function15;
                                    function19 = function14;
                                    function20 = composableLambdaRememberComposableLambda15;
                                } else {
                                    function19 = function14;
                                    function20 = function10;
                                }
                                i33 = i26;
                                z5 = z4;
                                paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                            }
                            int i31113 = i4 << 3;
                            int i31114 = i4 >> 3;
                            int i31115 = i4 >> 9;
                            int i31116 = i33 << 21;
                            TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i31113 & 896) | (i31113 & 112) | 6 | (i31114 & 7168) | (i31115 & 57344) | (i31115 & 458752) | (i31115 & 3670016) | (i31116 & 29360128) | (i31116 & 234881024) | (i31116 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i31115 & 7168) | (57344 & i31114) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            function21 = function19;
                            paddingValues3 = paddingValues2;
                            function22 = function16;
                            textFieldColors2 = textFieldColorsColors;
                            function23 = function12;
                            function24 = function17;
                            function25 = function20;
                            function26 = function18;
                            function27 = function15;
                            function28 = function11;
                            z6 = z5;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i13 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z3;
                                }
                                if (i15 != 0) {
                                    function11 = null;
                                } else {
                                    function11 = function3;
                                }
                                if (i17 != 0) {
                                    function12 = null;
                                } else {
                                    function12 = function4;
                                }
                                if (i19 != 0) {
                                    function13 = null;
                                } else {
                                    function13 = function5;
                                }
                                if (i21 != 0) {
                                    function14 = null;
                                } else {
                                    function14 = function6;
                                }
                                if (i24 != 0) {
                                    function15 = null;
                                } else {
                                    function15 = function7;
                                }
                                if (i27 != 0) {
                                    function16 = null;
                                } else {
                                    function16 = function8;
                                }
                                if (i29 == 0) {
                                }
                                if ((i3 & Fields.Clip) != 0) {
                                    textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                    i26 &= -57345;
                                } else {
                                    textFieldColorsColors = textFieldColors;
                                }
                                if ((i3 & Fields.CompositingStrategy) != 0) {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                    i26 &= -458753;
                                } else {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                                }
                                function18 = function13;
                                if (i30 != 0) {
                                    ComposableLambda composableLambdaRememberComposableLambda16 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer2, int i31117) {
                                            ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                            if ((i31117 & 3) != 2 || !composer2.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1448570018, i31117, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                                }
                                                OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer2.skipToGroupEnd();
                                        }
                                    }, composerStartRestartGroup, 54);
                                    function15 = function15;
                                    function19 = function14;
                                    function20 = composableLambdaRememberComposableLambda16;
                                } else {
                                    function19 = function14;
                                    function20 = function10;
                                }
                                i33 = i26;
                                z5 = z4;
                                paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                            } else {
                                if (i13 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z3;
                                }
                                if (i15 != 0) {
                                    function11 = null;
                                } else {
                                    function11 = function3;
                                }
                                if (i17 != 0) {
                                    function12 = null;
                                } else {
                                    function12 = function4;
                                }
                                if (i19 != 0) {
                                    function13 = null;
                                } else {
                                    function13 = function5;
                                }
                                if (i21 != 0) {
                                    function14 = null;
                                } else {
                                    function14 = function6;
                                }
                                if (i24 != 0) {
                                    function15 = null;
                                } else {
                                    function15 = function7;
                                }
                                if (i27 != 0) {
                                    function16 = null;
                                } else {
                                    function16 = function8;
                                }
                                if (i29 == 0) {
                                }
                                if ((i3 & Fields.Clip) != 0) {
                                    textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                    i26 &= -57345;
                                } else {
                                    textFieldColorsColors = textFieldColors;
                                }
                                if ((i3 & Fields.CompositingStrategy) != 0) {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                    i26 &= -458753;
                                } else {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                                }
                                function18 = function13;
                                if (i30 != 0) {
                                    ComposableLambda composableLambdaRememberComposableLambda17 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer2, int i31117) {
                                            ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                            if ((i31117 & 3) != 2 || !composer2.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1448570018, i31117, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                                }
                                                OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer2.skipToGroupEnd();
                                        }
                                    }, composerStartRestartGroup, 54);
                                    function15 = function15;
                                    function19 = function14;
                                    function20 = composableLambdaRememberComposableLambda17;
                                } else {
                                    function19 = function14;
                                    function20 = function10;
                                }
                                i33 = i26;
                                z5 = z4;
                                paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                            }
                            int i31117 = i4 << 3;
                            int i31118 = i4 >> 3;
                            int i31119 = i4 >> 9;
                            int i311110 = i33 << 21;
                            TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i31117 & 896) | (i31117 & 112) | 6 | (i31118 & 7168) | (i31119 & 57344) | (i31119 & 458752) | (i31119 & 3670016) | (i311110 & 29360128) | (i311110 & 234881024) | (i311110 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i31119 & 7168) | (57344 & i31118) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            function21 = function19;
                            paddingValues3 = paddingValues2;
                            function22 = function16;
                            textFieldColors2 = textFieldColorsColors;
                            function23 = function12;
                            function24 = function17;
                            function25 = function20;
                            function26 = function18;
                            function27 = function15;
                            function28 = function11;
                            z6 = z5;
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

                                public final void invoke(Composer composer2, int i311111) {
                                    OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                                }
                            });
                        }
                    }
                    i26 |= 3072;
                    if ((i2 & 24576) != 0) {
                        if ((i3 & Fields.Clip) == 0) {
                            i10 = 16384;
                        }
                        i26 |= i10;
                    }
                    if ((i2 & 196608) != 0) {
                        if ((i3 & Fields.CompositingStrategy) == 0) {
                            i34 = 65536;
                        } else {
                            i34 = 65536;
                        }
                        i26 |= i34;
                    }
                    i30 = i3 & 65536;
                    if (i30 != 0) {
                        i26 |= 1572864;
                    } else if ((i2 & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function10)) {
                            i31 = 1048576;
                        } else {
                            i31 = 524288;
                        }
                        i26 |= i31;
                    }
                    if ((i3 & Fields.RenderEffect) != 0) {
                        i26 |= 12582912;
                    } else if ((i2 & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(this)) {
                            i32 = 8388608;
                        } else {
                            i32 = 4194304;
                        }
                        i26 |= i32;
                    }
                    if ((i4 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda18 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i311111) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i311111 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i311111, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda18;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        } else {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda19 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i311111) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i311111 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i311111, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda19;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                        }
                        int i311111 = i4 << 3;
                        int i311112 = i4 >> 3;
                        int i311113 = i4 >> 9;
                        int i311114 = i33 << 21;
                        TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i311111 & 896) | (i311111 & 112) | 6 | (i311112 & 7168) | (i311113 & 57344) | (i311113 & 458752) | (i311113 & 3670016) | (i311114 & 29360128) | (i311114 & 234881024) | (i311114 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i311113 & 7168) | (57344 & i311112) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function21 = function19;
                        paddingValues3 = paddingValues2;
                        function22 = function16;
                        textFieldColors2 = textFieldColorsColors;
                        function23 = function12;
                        function24 = function17;
                        function25 = function20;
                        function26 = function18;
                        function27 = function15;
                        function28 = function11;
                        z6 = z5;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda110 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i311115) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i311115 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i311115, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda110;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        } else {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda111 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i311115) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i311115 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i311115, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda111;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                        }
                        int i311115 = i4 << 3;
                        int i311116 = i4 >> 3;
                        int i311117 = i4 >> 9;
                        int i311118 = i33 << 21;
                        TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i311115 & 896) | (i311115 & 112) | 6 | (i311116 & 7168) | (i311117 & 57344) | (i311117 & 458752) | (i311117 & 3670016) | (i311118 & 29360128) | (i311118 & 234881024) | (i311118 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i311117 & 7168) | (57344 & i311116) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function21 = function19;
                        paddingValues3 = paddingValues2;
                        function22 = function16;
                        textFieldColors2 = textFieldColorsColors;
                        function23 = function12;
                        function24 = function17;
                        function25 = function20;
                        function26 = function18;
                        function27 = function15;
                        function28 = function11;
                        z6 = z5;
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

                            public final void invoke(Composer composer2, int i311119) {
                                OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                            }
                        });
                    }
                }
                i26 |= 384;
                i29 = i3 & Fields.Shape;
                if (i29 != 0) {
                    if ((i2 & 3072) == 0) {
                        if (!composerStartRestartGroup.changedInstance(function9)) {
                            i7 = 1024;
                        }
                        i26 |= i7;
                    }
                    if ((i2 & 24576) != 0) {
                        if ((i3 & Fields.Clip) == 0) {
                            i10 = 16384;
                        }
                        i26 |= i10;
                    }
                    if ((i2 & 196608) != 0) {
                        if ((i3 & Fields.CompositingStrategy) == 0) {
                            i34 = 65536;
                        } else {
                            i34 = 65536;
                        }
                        i26 |= i34;
                    }
                    i30 = i3 & 65536;
                    if (i30 != 0) {
                        i26 |= 1572864;
                    } else if ((i2 & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function10)) {
                            i31 = 1048576;
                        } else {
                            i31 = 524288;
                        }
                        i26 |= i31;
                    }
                    if ((i3 & Fields.RenderEffect) != 0) {
                        i26 |= 12582912;
                    } else if ((i2 & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(this)) {
                            i32 = 8388608;
                        } else {
                            i32 = 4194304;
                        }
                        i26 |= i32;
                    }
                    if ((i4 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda112 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i311119) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i311119 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i311119, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda112;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        } else {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda113 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i311119) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i311119 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i311119, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda113;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                        }
                        int i311119 = i4 << 3;
                        int i3111110 = i4 >> 3;
                        int i3111111 = i4 >> 9;
                        int i3111112 = i33 << 21;
                        TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i311119 & 896) | (i311119 & 112) | 6 | (i3111110 & 7168) | (i3111111 & 57344) | (i3111111 & 458752) | (i3111111 & 3670016) | (i3111112 & 29360128) | (i3111112 & 234881024) | (i3111112 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i3111111 & 7168) | (57344 & i3111110) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function21 = function19;
                        paddingValues3 = paddingValues2;
                        function22 = function16;
                        textFieldColors2 = textFieldColorsColors;
                        function23 = function12;
                        function24 = function17;
                        function25 = function20;
                        function26 = function18;
                        function27 = function15;
                        function28 = function11;
                        z6 = z5;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda114 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i3111113) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i3111113 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i3111113, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda114;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        } else {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda115 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i3111113) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i3111113 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i3111113, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda115;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                        }
                        int i3111113 = i4 << 3;
                        int i3111114 = i4 >> 3;
                        int i3111115 = i4 >> 9;
                        int i3111116 = i33 << 21;
                        TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i3111113 & 896) | (i3111113 & 112) | 6 | (i3111114 & 7168) | (i3111115 & 57344) | (i3111115 & 458752) | (i3111115 & 3670016) | (i3111116 & 29360128) | (i3111116 & 234881024) | (i3111116 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i3111115 & 7168) | (57344 & i3111114) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function21 = function19;
                        paddingValues3 = paddingValues2;
                        function22 = function16;
                        textFieldColors2 = textFieldColorsColors;
                        function23 = function12;
                        function24 = function17;
                        function25 = function20;
                        function26 = function18;
                        function27 = function15;
                        function28 = function11;
                        z6 = z5;
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

                            public final void invoke(Composer composer2, int i3111117) {
                                OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                            }
                        });
                    }
                }
                i26 |= 3072;
                if ((i2 & 24576) != 0) {
                    if ((i3 & Fields.Clip) == 0) {
                        i10 = 16384;
                    }
                    i26 |= i10;
                }
                if ((i2 & 196608) != 0) {
                    if ((i3 & Fields.CompositingStrategy) == 0) {
                        i34 = 65536;
                    } else {
                        i34 = 65536;
                    }
                    i26 |= i34;
                }
                i30 = i3 & 65536;
                if (i30 != 0) {
                    i26 |= 1572864;
                } else if ((i2 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function10)) {
                        i31 = 1048576;
                    } else {
                        i31 = 524288;
                    }
                    i26 |= i31;
                }
                if ((i3 & Fields.RenderEffect) != 0) {
                    i26 |= 12582912;
                } else if ((i2 & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(this)) {
                        i32 = 8388608;
                    } else {
                        i32 = 4194304;
                    }
                    i26 |= i32;
                }
                if ((i4 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda116 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i3111117) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i3111117 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i3111117, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda116;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    } else {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda117 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i3111117) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i3111117 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i3111117, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda117;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                    }
                    int i3111117 = i4 << 3;
                    int i3111118 = i4 >> 3;
                    int i3111119 = i4 >> 9;
                    int i31111110 = i33 << 21;
                    TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i3111117 & 896) | (i3111117 & 112) | 6 | (i3111118 & 7168) | (i3111119 & 57344) | (i3111119 & 458752) | (i3111119 & 3670016) | (i31111110 & 29360128) | (i31111110 & 234881024) | (i31111110 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i3111119 & 7168) | (57344 & i3111118) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function21 = function19;
                    paddingValues3 = paddingValues2;
                    function22 = function16;
                    textFieldColors2 = textFieldColorsColors;
                    function23 = function12;
                    function24 = function17;
                    function25 = function20;
                    function26 = function18;
                    function27 = function15;
                    function28 = function11;
                    z6 = z5;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda118 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i31111111) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i31111111 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i31111111, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda118;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    } else {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda119 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i31111111) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i31111111 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i31111111, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda119;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                    }
                    int i31111111 = i4 << 3;
                    int i31111112 = i4 >> 3;
                    int i31111113 = i4 >> 9;
                    int i31111114 = i33 << 21;
                    TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i31111111 & 896) | (i31111111 & 112) | 6 | (i31111112 & 7168) | (i31111113 & 57344) | (i31111113 & 458752) | (i31111113 & 3670016) | (i31111114 & 29360128) | (i31111114 & 234881024) | (i31111114 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i31111113 & 7168) | (57344 & i31111112) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function21 = function19;
                    paddingValues3 = paddingValues2;
                    function22 = function16;
                    textFieldColors2 = textFieldColorsColors;
                    function23 = function12;
                    function24 = function17;
                    function25 = function20;
                    function26 = function18;
                    function27 = function15;
                    function28 = function11;
                    z6 = z5;
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

                        public final void invoke(Composer composer2, int i31111115) {
                            OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i4 |= 3072;
            i9 = i3 & 16;
            i10 = Fields.Shape;
            if (i9 != 0) {
                if ((i & 24576) == 0) {
                    if (composerStartRestartGroup.changed(visualTransformation)) {
                        i11 = 16384;
                    } else {
                        i11 = 8192;
                    }
                    i4 |= i11;
                }
                if ((i3 & 32) != 0) {
                    i4 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changed(interactionSource)) {
                        i12 = 131072;
                    } else {
                        i12 = 65536;
                    }
                    i4 |= i12;
                }
                i13 = i3 & 64;
                if (i13 != 0) {
                    i4 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(z3)) {
                        i14 = 1048576;
                    } else {
                        i14 = 524288;
                    }
                    i4 |= i14;
                }
                i15 = i3 & Fields.SpotShadowColor;
                if (i15 != 0) {
                    i4 |= 12582912;
                } else if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i16 = 8388608;
                    } else {
                        i16 = 4194304;
                    }
                    i4 |= i16;
                }
                i17 = i3 & Fields.RotationX;
                if (i17 != 0) {
                    i4 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i18 = 67108864;
                    } else {
                        i18 = 33554432;
                    }
                    i4 |= i18;
                }
                i19 = i3 & Fields.RotationY;
                if (i19 != 0) {
                    i4 |= 805306368;
                } else if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function5)) {
                        i20 = 536870912;
                    } else {
                        i20 = 268435456;
                    }
                    i4 |= i20;
                }
                i21 = i3 & Fields.RotationZ;
                if (i21 != 0) {
                    i22 = i2 | 6;
                } else if ((i2 & 6) == 0) {
                    if (composerStartRestartGroup.changedInstance(function6)) {
                        i23 = 4;
                    } else {
                        i23 = 2;
                    }
                    i22 = i2 | i23;
                } else {
                    i22 = i2;
                }
                i24 = i3 & Fields.CameraDistance;
                if (i24 != 0) {
                    i22 |= 48;
                } else if ((i2 & 48) == 0) {
                    if (composerStartRestartGroup.changedInstance(function7)) {
                        i25 = 32;
                    } else {
                        i25 = 16;
                    }
                    i22 |= i25;
                }
                i26 = i22;
                i27 = i3 & Fields.TransformOrigin;
                if (i27 != 0) {
                    if ((i2 & 384) == 0) {
                        if (composerStartRestartGroup.changedInstance(function8)) {
                            i28 = Fields.RotationX;
                        } else {
                            i28 = 128;
                        }
                        i26 |= i28;
                    }
                    i29 = i3 & Fields.Shape;
                    if (i29 != 0) {
                        if ((i2 & 3072) == 0) {
                            if (!composerStartRestartGroup.changedInstance(function9)) {
                                i7 = 1024;
                            }
                            i26 |= i7;
                        }
                        if ((i2 & 24576) != 0) {
                            if ((i3 & Fields.Clip) == 0) {
                                i10 = 16384;
                            }
                            i26 |= i10;
                        }
                        if ((i2 & 196608) != 0) {
                            if ((i3 & Fields.CompositingStrategy) == 0) {
                                i34 = 65536;
                            } else {
                                i34 = 65536;
                            }
                            i26 |= i34;
                        }
                        i30 = i3 & 65536;
                        if (i30 != 0) {
                            i26 |= 1572864;
                        } else if ((i2 & 1572864) == 0) {
                            if (composerStartRestartGroup.changedInstance(function10)) {
                                i31 = 1048576;
                            } else {
                                i31 = 524288;
                            }
                            i26 |= i31;
                        }
                        if ((i3 & Fields.RenderEffect) != 0) {
                            i26 |= 12582912;
                        } else if ((i2 & 12582912) == 0) {
                            if (composerStartRestartGroup.changed(this)) {
                                i32 = 8388608;
                            } else {
                                i32 = 4194304;
                            }
                            i26 |= i32;
                        }
                        if ((i4 & 306783379) == 306783378) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i13 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z3;
                                }
                                if (i15 != 0) {
                                    function11 = null;
                                } else {
                                    function11 = function3;
                                }
                                if (i17 != 0) {
                                    function12 = null;
                                } else {
                                    function12 = function4;
                                }
                                if (i19 != 0) {
                                    function13 = null;
                                } else {
                                    function13 = function5;
                                }
                                if (i21 != 0) {
                                    function14 = null;
                                } else {
                                    function14 = function6;
                                }
                                if (i24 != 0) {
                                    function15 = null;
                                } else {
                                    function15 = function7;
                                }
                                if (i27 != 0) {
                                    function16 = null;
                                } else {
                                    function16 = function8;
                                }
                                if (i29 == 0) {
                                }
                                if ((i3 & Fields.Clip) != 0) {
                                    textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                    i26 &= -57345;
                                } else {
                                    textFieldColorsColors = textFieldColors;
                                }
                                if ((i3 & Fields.CompositingStrategy) != 0) {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                    i26 &= -458753;
                                } else {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                                }
                                function18 = function13;
                                if (i30 != 0) {
                                    ComposableLambda composableLambdaRememberComposableLambda1110 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer2, int i31111115) {
                                            ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                            if ((i31111115 & 3) != 2 || !composer2.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1448570018, i31111115, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                                }
                                                OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer2.skipToGroupEnd();
                                        }
                                    }, composerStartRestartGroup, 54);
                                    function15 = function15;
                                    function19 = function14;
                                    function20 = composableLambdaRememberComposableLambda1110;
                                } else {
                                    function19 = function14;
                                    function20 = function10;
                                }
                                i33 = i26;
                                z5 = z4;
                                paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                            } else {
                                if (i13 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z3;
                                }
                                if (i15 != 0) {
                                    function11 = null;
                                } else {
                                    function11 = function3;
                                }
                                if (i17 != 0) {
                                    function12 = null;
                                } else {
                                    function12 = function4;
                                }
                                if (i19 != 0) {
                                    function13 = null;
                                } else {
                                    function13 = function5;
                                }
                                if (i21 != 0) {
                                    function14 = null;
                                } else {
                                    function14 = function6;
                                }
                                if (i24 != 0) {
                                    function15 = null;
                                } else {
                                    function15 = function7;
                                }
                                if (i27 != 0) {
                                    function16 = null;
                                } else {
                                    function16 = function8;
                                }
                                if (i29 == 0) {
                                }
                                if ((i3 & Fields.Clip) != 0) {
                                    textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                    i26 &= -57345;
                                } else {
                                    textFieldColorsColors = textFieldColors;
                                }
                                if ((i3 & Fields.CompositingStrategy) != 0) {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                    i26 &= -458753;
                                } else {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                                }
                                function18 = function13;
                                if (i30 != 0) {
                                    ComposableLambda composableLambdaRememberComposableLambda1111 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer2, int i31111115) {
                                            ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                            if ((i31111115 & 3) != 2 || !composer2.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1448570018, i31111115, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                                }
                                                OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer2.skipToGroupEnd();
                                        }
                                    }, composerStartRestartGroup, 54);
                                    function15 = function15;
                                    function19 = function14;
                                    function20 = composableLambdaRememberComposableLambda1111;
                                } else {
                                    function19 = function14;
                                    function20 = function10;
                                }
                                i33 = i26;
                                z5 = z4;
                                paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                            }
                            int i31111115 = i4 << 3;
                            int i31111116 = i4 >> 3;
                            int i31111117 = i4 >> 9;
                            int i31111118 = i33 << 21;
                            TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i31111115 & 896) | (i31111115 & 112) | 6 | (i31111116 & 7168) | (i31111117 & 57344) | (i31111117 & 458752) | (i31111117 & 3670016) | (i31111118 & 29360128) | (i31111118 & 234881024) | (i31111118 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i31111117 & 7168) | (57344 & i31111116) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            function21 = function19;
                            paddingValues3 = paddingValues2;
                            function22 = function16;
                            textFieldColors2 = textFieldColorsColors;
                            function23 = function12;
                            function24 = function17;
                            function25 = function20;
                            function26 = function18;
                            function27 = function15;
                            function28 = function11;
                            z6 = z5;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i13 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z3;
                                }
                                if (i15 != 0) {
                                    function11 = null;
                                } else {
                                    function11 = function3;
                                }
                                if (i17 != 0) {
                                    function12 = null;
                                } else {
                                    function12 = function4;
                                }
                                if (i19 != 0) {
                                    function13 = null;
                                } else {
                                    function13 = function5;
                                }
                                if (i21 != 0) {
                                    function14 = null;
                                } else {
                                    function14 = function6;
                                }
                                if (i24 != 0) {
                                    function15 = null;
                                } else {
                                    function15 = function7;
                                }
                                if (i27 != 0) {
                                    function16 = null;
                                } else {
                                    function16 = function8;
                                }
                                if (i29 == 0) {
                                }
                                if ((i3 & Fields.Clip) != 0) {
                                    textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                    i26 &= -57345;
                                } else {
                                    textFieldColorsColors = textFieldColors;
                                }
                                if ((i3 & Fields.CompositingStrategy) != 0) {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                    i26 &= -458753;
                                } else {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                                }
                                function18 = function13;
                                if (i30 != 0) {
                                    ComposableLambda composableLambdaRememberComposableLambda1112 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer2, int i31111119) {
                                            ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                            if ((i31111119 & 3) != 2 || !composer2.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1448570018, i31111119, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                                }
                                                OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer2.skipToGroupEnd();
                                        }
                                    }, composerStartRestartGroup, 54);
                                    function15 = function15;
                                    function19 = function14;
                                    function20 = composableLambdaRememberComposableLambda1112;
                                } else {
                                    function19 = function14;
                                    function20 = function10;
                                }
                                i33 = i26;
                                z5 = z4;
                                paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                            } else {
                                if (i13 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z3;
                                }
                                if (i15 != 0) {
                                    function11 = null;
                                } else {
                                    function11 = function3;
                                }
                                if (i17 != 0) {
                                    function12 = null;
                                } else {
                                    function12 = function4;
                                }
                                if (i19 != 0) {
                                    function13 = null;
                                } else {
                                    function13 = function5;
                                }
                                if (i21 != 0) {
                                    function14 = null;
                                } else {
                                    function14 = function6;
                                }
                                if (i24 != 0) {
                                    function15 = null;
                                } else {
                                    function15 = function7;
                                }
                                if (i27 != 0) {
                                    function16 = null;
                                } else {
                                    function16 = function8;
                                }
                                if (i29 == 0) {
                                }
                                if ((i3 & Fields.Clip) != 0) {
                                    textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                    i26 &= -57345;
                                } else {
                                    textFieldColorsColors = textFieldColors;
                                }
                                if ((i3 & Fields.CompositingStrategy) != 0) {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                    i26 &= -458753;
                                } else {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                                }
                                function18 = function13;
                                if (i30 != 0) {
                                    ComposableLambda composableLambdaRememberComposableLambda1113 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer2, int i31111119) {
                                            ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                            if ((i31111119 & 3) != 2 || !composer2.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1448570018, i31111119, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                                }
                                                OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer2.skipToGroupEnd();
                                        }
                                    }, composerStartRestartGroup, 54);
                                    function15 = function15;
                                    function19 = function14;
                                    function20 = composableLambdaRememberComposableLambda1113;
                                } else {
                                    function19 = function14;
                                    function20 = function10;
                                }
                                i33 = i26;
                                z5 = z4;
                                paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                            }
                            int i31111119 = i4 << 3;
                            int i311111110 = i4 >> 3;
                            int i311111111 = i4 >> 9;
                            int i311111112 = i33 << 21;
                            TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i31111119 & 896) | (i31111119 & 112) | 6 | (i311111110 & 7168) | (i311111111 & 57344) | (i311111111 & 458752) | (i311111111 & 3670016) | (i311111112 & 29360128) | (i311111112 & 234881024) | (i311111112 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i311111111 & 7168) | (57344 & i311111110) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            function21 = function19;
                            paddingValues3 = paddingValues2;
                            function22 = function16;
                            textFieldColors2 = textFieldColorsColors;
                            function23 = function12;
                            function24 = function17;
                            function25 = function20;
                            function26 = function18;
                            function27 = function15;
                            function28 = function11;
                            z6 = z5;
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

                                public final void invoke(Composer composer2, int i311111113) {
                                    OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                                }
                            });
                        }
                    }
                    i26 |= 3072;
                    if ((i2 & 24576) != 0) {
                        if ((i3 & Fields.Clip) == 0) {
                            i10 = 16384;
                        }
                        i26 |= i10;
                    }
                    if ((i2 & 196608) != 0) {
                        if ((i3 & Fields.CompositingStrategy) == 0) {
                            i34 = 65536;
                        } else {
                            i34 = 65536;
                        }
                        i26 |= i34;
                    }
                    i30 = i3 & 65536;
                    if (i30 != 0) {
                        i26 |= 1572864;
                    } else if ((i2 & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function10)) {
                            i31 = 1048576;
                        } else {
                            i31 = 524288;
                        }
                        i26 |= i31;
                    }
                    if ((i3 & Fields.RenderEffect) != 0) {
                        i26 |= 12582912;
                    } else if ((i2 & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(this)) {
                            i32 = 8388608;
                        } else {
                            i32 = 4194304;
                        }
                        i26 |= i32;
                    }
                    if ((i4 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda1114 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i311111113) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i311111113 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i311111113, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda1114;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        } else {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda1115 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i311111113) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i311111113 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i311111113, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda1115;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                        }
                        int i311111113 = i4 << 3;
                        int i311111114 = i4 >> 3;
                        int i311111115 = i4 >> 9;
                        int i311111116 = i33 << 21;
                        TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i311111113 & 896) | (i311111113 & 112) | 6 | (i311111114 & 7168) | (i311111115 & 57344) | (i311111115 & 458752) | (i311111115 & 3670016) | (i311111116 & 29360128) | (i311111116 & 234881024) | (i311111116 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i311111115 & 7168) | (57344 & i311111114) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function21 = function19;
                        paddingValues3 = paddingValues2;
                        function22 = function16;
                        textFieldColors2 = textFieldColorsColors;
                        function23 = function12;
                        function24 = function17;
                        function25 = function20;
                        function26 = function18;
                        function27 = function15;
                        function28 = function11;
                        z6 = z5;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda1116 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i311111117) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i311111117 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i311111117, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda1116;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        } else {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda1117 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i311111117) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i311111117 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i311111117, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda1117;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                        }
                        int i311111117 = i4 << 3;
                        int i311111118 = i4 >> 3;
                        int i311111119 = i4 >> 9;
                        int i3111111110 = i33 << 21;
                        TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i311111117 & 896) | (i311111117 & 112) | 6 | (i311111118 & 7168) | (i311111119 & 57344) | (i311111119 & 458752) | (i311111119 & 3670016) | (i3111111110 & 29360128) | (i3111111110 & 234881024) | (i3111111110 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i311111119 & 7168) | (57344 & i311111118) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function21 = function19;
                        paddingValues3 = paddingValues2;
                        function22 = function16;
                        textFieldColors2 = textFieldColorsColors;
                        function23 = function12;
                        function24 = function17;
                        function25 = function20;
                        function26 = function18;
                        function27 = function15;
                        function28 = function11;
                        z6 = z5;
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

                            public final void invoke(Composer composer2, int i3111111111) {
                                OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                            }
                        });
                    }
                }
                i26 |= 384;
                i29 = i3 & Fields.Shape;
                if (i29 != 0) {
                    if ((i2 & 3072) == 0) {
                        if (!composerStartRestartGroup.changedInstance(function9)) {
                            i7 = 1024;
                        }
                        i26 |= i7;
                    }
                    if ((i2 & 24576) != 0) {
                        if ((i3 & Fields.Clip) == 0) {
                            i10 = 16384;
                        }
                        i26 |= i10;
                    }
                    if ((i2 & 196608) != 0) {
                        if ((i3 & Fields.CompositingStrategy) == 0) {
                            i34 = 65536;
                        } else {
                            i34 = 65536;
                        }
                        i26 |= i34;
                    }
                    i30 = i3 & 65536;
                    if (i30 != 0) {
                        i26 |= 1572864;
                    } else if ((i2 & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function10)) {
                            i31 = 1048576;
                        } else {
                            i31 = 524288;
                        }
                        i26 |= i31;
                    }
                    if ((i3 & Fields.RenderEffect) != 0) {
                        i26 |= 12582912;
                    } else if ((i2 & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(this)) {
                            i32 = 8388608;
                        } else {
                            i32 = 4194304;
                        }
                        i26 |= i32;
                    }
                    if ((i4 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda1118 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i3111111111) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i3111111111 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i3111111111, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda1118;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        } else {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda1119 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i3111111111) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i3111111111 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i3111111111, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda1119;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                        }
                        int i3111111111 = i4 << 3;
                        int i3111111112 = i4 >> 3;
                        int i3111111113 = i4 >> 9;
                        int i3111111114 = i33 << 21;
                        TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i3111111111 & 896) | (i3111111111 & 112) | 6 | (i3111111112 & 7168) | (i3111111113 & 57344) | (i3111111113 & 458752) | (i3111111113 & 3670016) | (i3111111114 & 29360128) | (i3111111114 & 234881024) | (i3111111114 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i3111111113 & 7168) | (57344 & i3111111112) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function21 = function19;
                        paddingValues3 = paddingValues2;
                        function22 = function16;
                        textFieldColors2 = textFieldColorsColors;
                        function23 = function12;
                        function24 = function17;
                        function25 = function20;
                        function26 = function18;
                        function27 = function15;
                        function28 = function11;
                        z6 = z5;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda11110 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i3111111115) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i3111111115 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i3111111115, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda11110;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        } else {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda11111 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i3111111115) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i3111111115 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i3111111115, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda11111;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                        }
                        int i3111111115 = i4 << 3;
                        int i3111111116 = i4 >> 3;
                        int i3111111117 = i4 >> 9;
                        int i3111111118 = i33 << 21;
                        TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i3111111115 & 896) | (i3111111115 & 112) | 6 | (i3111111116 & 7168) | (i3111111117 & 57344) | (i3111111117 & 458752) | (i3111111117 & 3670016) | (i3111111118 & 29360128) | (i3111111118 & 234881024) | (i3111111118 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i3111111117 & 7168) | (57344 & i3111111116) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function21 = function19;
                        paddingValues3 = paddingValues2;
                        function22 = function16;
                        textFieldColors2 = textFieldColorsColors;
                        function23 = function12;
                        function24 = function17;
                        function25 = function20;
                        function26 = function18;
                        function27 = function15;
                        function28 = function11;
                        z6 = z5;
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

                            public final void invoke(Composer composer2, int i3111111119) {
                                OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                            }
                        });
                    }
                }
                i26 |= 3072;
                if ((i2 & 24576) != 0) {
                    if ((i3 & Fields.Clip) == 0) {
                        i10 = 16384;
                    }
                    i26 |= i10;
                }
                if ((i2 & 196608) != 0) {
                    if ((i3 & Fields.CompositingStrategy) == 0) {
                        i34 = 65536;
                    } else {
                        i34 = 65536;
                    }
                    i26 |= i34;
                }
                i30 = i3 & 65536;
                if (i30 != 0) {
                    i26 |= 1572864;
                } else if ((i2 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function10)) {
                        i31 = 1048576;
                    } else {
                        i31 = 524288;
                    }
                    i26 |= i31;
                }
                if ((i3 & Fields.RenderEffect) != 0) {
                    i26 |= 12582912;
                } else if ((i2 & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(this)) {
                        i32 = 8388608;
                    } else {
                        i32 = 4194304;
                    }
                    i26 |= i32;
                }
                if ((i4 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda11112 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i3111111119) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i3111111119 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i3111111119, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda11112;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    } else {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda11113 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i3111111119) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i3111111119 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i3111111119, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda11113;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                    }
                    int i3111111119 = i4 << 3;
                    int i31111111110 = i4 >> 3;
                    int i31111111111 = i4 >> 9;
                    int i31111111112 = i33 << 21;
                    TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i3111111119 & 896) | (i3111111119 & 112) | 6 | (i31111111110 & 7168) | (i31111111111 & 57344) | (i31111111111 & 458752) | (i31111111111 & 3670016) | (i31111111112 & 29360128) | (i31111111112 & 234881024) | (i31111111112 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i31111111111 & 7168) | (57344 & i31111111110) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function21 = function19;
                    paddingValues3 = paddingValues2;
                    function22 = function16;
                    textFieldColors2 = textFieldColorsColors;
                    function23 = function12;
                    function24 = function17;
                    function25 = function20;
                    function26 = function18;
                    function27 = function15;
                    function28 = function11;
                    z6 = z5;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda11114 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i31111111113) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i31111111113 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i31111111113, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda11114;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    } else {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda11115 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i31111111113) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i31111111113 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i31111111113, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda11115;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                    }
                    int i31111111113 = i4 << 3;
                    int i31111111114 = i4 >> 3;
                    int i31111111115 = i4 >> 9;
                    int i31111111116 = i33 << 21;
                    TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i31111111113 & 896) | (i31111111113 & 112) | 6 | (i31111111114 & 7168) | (i31111111115 & 57344) | (i31111111115 & 458752) | (i31111111115 & 3670016) | (i31111111116 & 29360128) | (i31111111116 & 234881024) | (i31111111116 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i31111111115 & 7168) | (57344 & i31111111114) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function21 = function19;
                    paddingValues3 = paddingValues2;
                    function22 = function16;
                    textFieldColors2 = textFieldColorsColors;
                    function23 = function12;
                    function24 = function17;
                    function25 = function20;
                    function26 = function18;
                    function27 = function15;
                    function28 = function11;
                    z6 = z5;
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

                        public final void invoke(Composer composer2, int i31111111117) {
                            OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i4 |= 24576;
            if ((i3 & 32) != 0) {
                i4 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changed(interactionSource)) {
                    i12 = 131072;
                } else {
                    i12 = 65536;
                }
                i4 |= i12;
            }
            i13 = i3 & 64;
            if (i13 != 0) {
                i4 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changed(z3)) {
                    i14 = 1048576;
                } else {
                    i14 = 524288;
                }
                i4 |= i14;
            }
            i15 = i3 & Fields.SpotShadowColor;
            if (i15 != 0) {
                i4 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i16 = 8388608;
                } else {
                    i16 = 4194304;
                }
                i4 |= i16;
            }
            i17 = i3 & Fields.RotationX;
            if (i17 != 0) {
                i4 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i18 = 67108864;
                } else {
                    i18 = 33554432;
                }
                i4 |= i18;
            }
            i19 = i3 & Fields.RotationY;
            if (i19 != 0) {
                i4 |= 805306368;
            } else if ((i & 805306368) == 0) {
                if (composerStartRestartGroup.changedInstance(function5)) {
                    i20 = 536870912;
                } else {
                    i20 = 268435456;
                }
                i4 |= i20;
            }
            i21 = i3 & Fields.RotationZ;
            if (i21 != 0) {
                i22 = i2 | 6;
            } else if ((i2 & 6) == 0) {
                if (composerStartRestartGroup.changedInstance(function6)) {
                    i23 = 4;
                } else {
                    i23 = 2;
                }
                i22 = i2 | i23;
            } else {
                i22 = i2;
            }
            i24 = i3 & Fields.CameraDistance;
            if (i24 != 0) {
                i22 |= 48;
            } else if ((i2 & 48) == 0) {
                if (composerStartRestartGroup.changedInstance(function7)) {
                    i25 = 32;
                } else {
                    i25 = 16;
                }
                i22 |= i25;
            }
            i26 = i22;
            i27 = i3 & Fields.TransformOrigin;
            if (i27 != 0) {
                if ((i2 & 384) == 0) {
                    if (composerStartRestartGroup.changedInstance(function8)) {
                        i28 = Fields.RotationX;
                    } else {
                        i28 = 128;
                    }
                    i26 |= i28;
                }
                i29 = i3 & Fields.Shape;
                if (i29 != 0) {
                    if ((i2 & 3072) == 0) {
                        if (!composerStartRestartGroup.changedInstance(function9)) {
                            i7 = 1024;
                        }
                        i26 |= i7;
                    }
                    if ((i2 & 24576) != 0) {
                        if ((i3 & Fields.Clip) == 0) {
                            i10 = 16384;
                        }
                        i26 |= i10;
                    }
                    if ((i2 & 196608) != 0) {
                        if ((i3 & Fields.CompositingStrategy) == 0) {
                            i34 = 65536;
                        } else {
                            i34 = 65536;
                        }
                        i26 |= i34;
                    }
                    i30 = i3 & 65536;
                    if (i30 != 0) {
                        i26 |= 1572864;
                    } else if ((i2 & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function10)) {
                            i31 = 1048576;
                        } else {
                            i31 = 524288;
                        }
                        i26 |= i31;
                    }
                    if ((i3 & Fields.RenderEffect) != 0) {
                        i26 |= 12582912;
                    } else if ((i2 & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(this)) {
                            i32 = 8388608;
                        } else {
                            i32 = 4194304;
                        }
                        i26 |= i32;
                    }
                    if ((i4 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda11116 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i31111111117) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i31111111117 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i31111111117, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda11116;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        } else {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda11117 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i31111111117) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i31111111117 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i31111111117, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda11117;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                        }
                        int i31111111117 = i4 << 3;
                        int i31111111118 = i4 >> 3;
                        int i31111111119 = i4 >> 9;
                        int i311111111110 = i33 << 21;
                        TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i31111111117 & 896) | (i31111111117 & 112) | 6 | (i31111111118 & 7168) | (i31111111119 & 57344) | (i31111111119 & 458752) | (i31111111119 & 3670016) | (i311111111110 & 29360128) | (i311111111110 & 234881024) | (i311111111110 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i31111111119 & 7168) | (57344 & i31111111118) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function21 = function19;
                        paddingValues3 = paddingValues2;
                        function22 = function16;
                        textFieldColors2 = textFieldColorsColors;
                        function23 = function12;
                        function24 = function17;
                        function25 = function20;
                        function26 = function18;
                        function27 = function15;
                        function28 = function11;
                        z6 = z5;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda11118 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i311111111111) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i311111111111 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i311111111111, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda11118;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        } else {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda11119 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i311111111111) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i311111111111 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i311111111111, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda11119;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                        }
                        int i311111111111 = i4 << 3;
                        int i311111111112 = i4 >> 3;
                        int i311111111113 = i4 >> 9;
                        int i311111111114 = i33 << 21;
                        TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i311111111111 & 896) | (i311111111111 & 112) | 6 | (i311111111112 & 7168) | (i311111111113 & 57344) | (i311111111113 & 458752) | (i311111111113 & 3670016) | (i311111111114 & 29360128) | (i311111111114 & 234881024) | (i311111111114 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i311111111113 & 7168) | (57344 & i311111111112) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function21 = function19;
                        paddingValues3 = paddingValues2;
                        function22 = function16;
                        textFieldColors2 = textFieldColorsColors;
                        function23 = function12;
                        function24 = function17;
                        function25 = function20;
                        function26 = function18;
                        function27 = function15;
                        function28 = function11;
                        z6 = z5;
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

                            public final void invoke(Composer composer2, int i311111111115) {
                                OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                            }
                        });
                    }
                }
                i26 |= 3072;
                if ((i2 & 24576) != 0) {
                    if ((i3 & Fields.Clip) == 0) {
                        i10 = 16384;
                    }
                    i26 |= i10;
                }
                if ((i2 & 196608) != 0) {
                    if ((i3 & Fields.CompositingStrategy) == 0) {
                        i34 = 65536;
                    } else {
                        i34 = 65536;
                    }
                    i26 |= i34;
                }
                i30 = i3 & 65536;
                if (i30 != 0) {
                    i26 |= 1572864;
                } else if ((i2 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function10)) {
                        i31 = 1048576;
                    } else {
                        i31 = 524288;
                    }
                    i26 |= i31;
                }
                if ((i3 & Fields.RenderEffect) != 0) {
                    i26 |= 12582912;
                } else if ((i2 & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(this)) {
                        i32 = 8388608;
                    } else {
                        i32 = 4194304;
                    }
                    i26 |= i32;
                }
                if ((i4 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda111110 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i311111111115) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i311111111115 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i311111111115, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda111110;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    } else {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda111111 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i311111111115) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i311111111115 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i311111111115, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda111111;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                    }
                    int i311111111115 = i4 << 3;
                    int i311111111116 = i4 >> 3;
                    int i311111111117 = i4 >> 9;
                    int i311111111118 = i33 << 21;
                    TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i311111111115 & 896) | (i311111111115 & 112) | 6 | (i311111111116 & 7168) | (i311111111117 & 57344) | (i311111111117 & 458752) | (i311111111117 & 3670016) | (i311111111118 & 29360128) | (i311111111118 & 234881024) | (i311111111118 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i311111111117 & 7168) | (57344 & i311111111116) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function21 = function19;
                    paddingValues3 = paddingValues2;
                    function22 = function16;
                    textFieldColors2 = textFieldColorsColors;
                    function23 = function12;
                    function24 = function17;
                    function25 = function20;
                    function26 = function18;
                    function27 = function15;
                    function28 = function11;
                    z6 = z5;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda111112 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i311111111119) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i311111111119 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i311111111119, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda111112;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    } else {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda111113 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i311111111119) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i311111111119 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i311111111119, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda111113;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                    }
                    int i311111111119 = i4 << 3;
                    int i3111111111110 = i4 >> 3;
                    int i3111111111111 = i4 >> 9;
                    int i3111111111112 = i33 << 21;
                    TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i311111111119 & 896) | (i311111111119 & 112) | 6 | (i3111111111110 & 7168) | (i3111111111111 & 57344) | (i3111111111111 & 458752) | (i3111111111111 & 3670016) | (i3111111111112 & 29360128) | (i3111111111112 & 234881024) | (i3111111111112 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i3111111111111 & 7168) | (57344 & i3111111111110) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function21 = function19;
                    paddingValues3 = paddingValues2;
                    function22 = function16;
                    textFieldColors2 = textFieldColorsColors;
                    function23 = function12;
                    function24 = function17;
                    function25 = function20;
                    function26 = function18;
                    function27 = function15;
                    function28 = function11;
                    z6 = z5;
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

                        public final void invoke(Composer composer2, int i3111111111113) {
                            OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i26 |= 384;
            i29 = i3 & Fields.Shape;
            if (i29 != 0) {
                if ((i2 & 3072) == 0) {
                    if (!composerStartRestartGroup.changedInstance(function9)) {
                        i7 = 1024;
                    }
                    i26 |= i7;
                }
                if ((i2 & 24576) != 0) {
                    if ((i3 & Fields.Clip) == 0) {
                        i10 = 16384;
                    }
                    i26 |= i10;
                }
                if ((i2 & 196608) != 0) {
                    if ((i3 & Fields.CompositingStrategy) == 0) {
                        i34 = 65536;
                    } else {
                        i34 = 65536;
                    }
                    i26 |= i34;
                }
                i30 = i3 & 65536;
                if (i30 != 0) {
                    i26 |= 1572864;
                } else if ((i2 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function10)) {
                        i31 = 1048576;
                    } else {
                        i31 = 524288;
                    }
                    i26 |= i31;
                }
                if ((i3 & Fields.RenderEffect) != 0) {
                    i26 |= 12582912;
                } else if ((i2 & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(this)) {
                        i32 = 8388608;
                    } else {
                        i32 = 4194304;
                    }
                    i26 |= i32;
                }
                if ((i4 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda111114 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i3111111111113) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i3111111111113 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i3111111111113, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda111114;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    } else {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda111115 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i3111111111113) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i3111111111113 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i3111111111113, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda111115;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                    }
                    int i3111111111113 = i4 << 3;
                    int i3111111111114 = i4 >> 3;
                    int i3111111111115 = i4 >> 9;
                    int i3111111111116 = i33 << 21;
                    TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i3111111111113 & 896) | (i3111111111113 & 112) | 6 | (i3111111111114 & 7168) | (i3111111111115 & 57344) | (i3111111111115 & 458752) | (i3111111111115 & 3670016) | (i3111111111116 & 29360128) | (i3111111111116 & 234881024) | (i3111111111116 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i3111111111115 & 7168) | (57344 & i3111111111114) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function21 = function19;
                    paddingValues3 = paddingValues2;
                    function22 = function16;
                    textFieldColors2 = textFieldColorsColors;
                    function23 = function12;
                    function24 = function17;
                    function25 = function20;
                    function26 = function18;
                    function27 = function15;
                    function28 = function11;
                    z6 = z5;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda111116 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i3111111111117) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i3111111111117 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i3111111111117, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda111116;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    } else {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda111117 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i3111111111117) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i3111111111117 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i3111111111117, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda111117;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                    }
                    int i3111111111117 = i4 << 3;
                    int i3111111111118 = i4 >> 3;
                    int i3111111111119 = i4 >> 9;
                    int i31111111111110 = i33 << 21;
                    TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i3111111111117 & 896) | (i3111111111117 & 112) | 6 | (i3111111111118 & 7168) | (i3111111111119 & 57344) | (i3111111111119 & 458752) | (i3111111111119 & 3670016) | (i31111111111110 & 29360128) | (i31111111111110 & 234881024) | (i31111111111110 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i3111111111119 & 7168) | (57344 & i3111111111118) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function21 = function19;
                    paddingValues3 = paddingValues2;
                    function22 = function16;
                    textFieldColors2 = textFieldColorsColors;
                    function23 = function12;
                    function24 = function17;
                    function25 = function20;
                    function26 = function18;
                    function27 = function15;
                    function28 = function11;
                    z6 = z5;
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

                        public final void invoke(Composer composer2, int i31111111111111) {
                            OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i26 |= 3072;
            if ((i2 & 24576) != 0) {
                if ((i3 & Fields.Clip) == 0) {
                    i10 = 16384;
                }
                i26 |= i10;
            }
            if ((i2 & 196608) != 0) {
                if ((i3 & Fields.CompositingStrategy) == 0) {
                    i34 = 65536;
                } else {
                    i34 = 65536;
                }
                i26 |= i34;
            }
            i30 = i3 & 65536;
            if (i30 != 0) {
                i26 |= 1572864;
            } else if ((i2 & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function10)) {
                    i31 = 1048576;
                } else {
                    i31 = 524288;
                }
                i26 |= i31;
            }
            if ((i3 & Fields.RenderEffect) != 0) {
                i26 |= 12582912;
            } else if ((i2 & 12582912) == 0) {
                if (composerStartRestartGroup.changed(this)) {
                    i32 = 8388608;
                } else {
                    i32 = 4194304;
                }
                i26 |= i32;
            }
            if ((i4 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        z4 = false;
                    } else {
                        z4 = z3;
                    }
                    if (i15 != 0) {
                        function11 = null;
                    } else {
                        function11 = function3;
                    }
                    if (i17 != 0) {
                        function12 = null;
                    } else {
                        function12 = function4;
                    }
                    if (i19 != 0) {
                        function13 = null;
                    } else {
                        function13 = function5;
                    }
                    if (i21 != 0) {
                        function14 = null;
                    } else {
                        function14 = function6;
                    }
                    if (i24 != 0) {
                        function15 = null;
                    } else {
                        function15 = function7;
                    }
                    if (i27 != 0) {
                        function16 = null;
                    } else {
                        function16 = function8;
                    }
                    if (i29 == 0) {
                    }
                    if ((i3 & Fields.Clip) != 0) {
                        textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                        i26 &= -57345;
                    } else {
                        textFieldColorsColors = textFieldColors;
                    }
                    if ((i3 & Fields.CompositingStrategy) != 0) {
                        paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                        i26 &= -458753;
                    } else {
                        paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                    }
                    function18 = function13;
                    if (i30 != 0) {
                        ComposableLambda composableLambdaRememberComposableLambda111118 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i31111111111111) {
                                ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                if ((i31111111111111 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1448570018, i31111111111111, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                    }
                                    OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        function15 = function15;
                        function19 = function14;
                        function20 = composableLambdaRememberComposableLambda111118;
                    } else {
                        function19 = function14;
                        function20 = function10;
                    }
                    i33 = i26;
                    z5 = z4;
                    paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                } else {
                    if (i13 != 0) {
                        z4 = false;
                    } else {
                        z4 = z3;
                    }
                    if (i15 != 0) {
                        function11 = null;
                    } else {
                        function11 = function3;
                    }
                    if (i17 != 0) {
                        function12 = null;
                    } else {
                        function12 = function4;
                    }
                    if (i19 != 0) {
                        function13 = null;
                    } else {
                        function13 = function5;
                    }
                    if (i21 != 0) {
                        function14 = null;
                    } else {
                        function14 = function6;
                    }
                    if (i24 != 0) {
                        function15 = null;
                    } else {
                        function15 = function7;
                    }
                    if (i27 != 0) {
                        function16 = null;
                    } else {
                        function16 = function8;
                    }
                    if (i29 == 0) {
                    }
                    if ((i3 & Fields.Clip) != 0) {
                        textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                        i26 &= -57345;
                    } else {
                        textFieldColorsColors = textFieldColors;
                    }
                    if ((i3 & Fields.CompositingStrategy) != 0) {
                        paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                        i26 &= -458753;
                    } else {
                        paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                    }
                    function18 = function13;
                    if (i30 != 0) {
                        ComposableLambda composableLambdaRememberComposableLambda111119 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i31111111111111) {
                                ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                if ((i31111111111111 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1448570018, i31111111111111, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                    }
                                    OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        function15 = function15;
                        function19 = function14;
                        function20 = composableLambdaRememberComposableLambda111119;
                    } else {
                        function19 = function14;
                        function20 = function10;
                    }
                    i33 = i26;
                    z5 = z4;
                    paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                }
                int i31111111111111 = i4 << 3;
                int i31111111111112 = i4 >> 3;
                int i31111111111113 = i4 >> 9;
                int i31111111111114 = i33 << 21;
                TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i31111111111111 & 896) | (i31111111111111 & 112) | 6 | (i31111111111112 & 7168) | (i31111111111113 & 57344) | (i31111111111113 & 458752) | (i31111111111113 & 3670016) | (i31111111111114 & 29360128) | (i31111111111114 & 234881024) | (i31111111111114 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i31111111111113 & 7168) | (57344 & i31111111111112) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function21 = function19;
                paddingValues3 = paddingValues2;
                function22 = function16;
                textFieldColors2 = textFieldColorsColors;
                function23 = function12;
                function24 = function17;
                function25 = function20;
                function26 = function18;
                function27 = function15;
                function28 = function11;
                z6 = z5;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        z4 = false;
                    } else {
                        z4 = z3;
                    }
                    if (i15 != 0) {
                        function11 = null;
                    } else {
                        function11 = function3;
                    }
                    if (i17 != 0) {
                        function12 = null;
                    } else {
                        function12 = function4;
                    }
                    if (i19 != 0) {
                        function13 = null;
                    } else {
                        function13 = function5;
                    }
                    if (i21 != 0) {
                        function14 = null;
                    } else {
                        function14 = function6;
                    }
                    if (i24 != 0) {
                        function15 = null;
                    } else {
                        function15 = function7;
                    }
                    if (i27 != 0) {
                        function16 = null;
                    } else {
                        function16 = function8;
                    }
                    if (i29 == 0) {
                    }
                    if ((i3 & Fields.Clip) != 0) {
                        textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                        i26 &= -57345;
                    } else {
                        textFieldColorsColors = textFieldColors;
                    }
                    if ((i3 & Fields.CompositingStrategy) != 0) {
                        paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                        i26 &= -458753;
                    } else {
                        paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                    }
                    function18 = function13;
                    if (i30 != 0) {
                        ComposableLambda composableLambdaRememberComposableLambda1111110 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i31111111111115) {
                                ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                if ((i31111111111115 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1448570018, i31111111111115, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                    }
                                    OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        function15 = function15;
                        function19 = function14;
                        function20 = composableLambdaRememberComposableLambda1111110;
                    } else {
                        function19 = function14;
                        function20 = function10;
                    }
                    i33 = i26;
                    z5 = z4;
                    paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                } else {
                    if (i13 != 0) {
                        z4 = false;
                    } else {
                        z4 = z3;
                    }
                    if (i15 != 0) {
                        function11 = null;
                    } else {
                        function11 = function3;
                    }
                    if (i17 != 0) {
                        function12 = null;
                    } else {
                        function12 = function4;
                    }
                    if (i19 != 0) {
                        function13 = null;
                    } else {
                        function13 = function5;
                    }
                    if (i21 != 0) {
                        function14 = null;
                    } else {
                        function14 = function6;
                    }
                    if (i24 != 0) {
                        function15 = null;
                    } else {
                        function15 = function7;
                    }
                    if (i27 != 0) {
                        function16 = null;
                    } else {
                        function16 = function8;
                    }
                    if (i29 == 0) {
                    }
                    if ((i3 & Fields.Clip) != 0) {
                        textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                        i26 &= -57345;
                    } else {
                        textFieldColorsColors = textFieldColors;
                    }
                    if ((i3 & Fields.CompositingStrategy) != 0) {
                        paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                        i26 &= -458753;
                    } else {
                        paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                    }
                    function18 = function13;
                    if (i30 != 0) {
                        ComposableLambda composableLambdaRememberComposableLambda1111111 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i31111111111115) {
                                ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                if ((i31111111111115 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1448570018, i31111111111115, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                    }
                                    OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        function15 = function15;
                        function19 = function14;
                        function20 = composableLambdaRememberComposableLambda1111111;
                    } else {
                        function19 = function14;
                        function20 = function10;
                    }
                    i33 = i26;
                    z5 = z4;
                    paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                }
                int i31111111111115 = i4 << 3;
                int i31111111111116 = i4 >> 3;
                int i31111111111117 = i4 >> 9;
                int i31111111111118 = i33 << 21;
                TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i31111111111115 & 896) | (i31111111111115 & 112) | 6 | (i31111111111116 & 7168) | (i31111111111117 & 57344) | (i31111111111117 & 458752) | (i31111111111117 & 3670016) | (i31111111111118 & 29360128) | (i31111111111118 & 234881024) | (i31111111111118 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i31111111111117 & 7168) | (57344 & i31111111111116) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function21 = function19;
                paddingValues3 = paddingValues2;
                function22 = function16;
                textFieldColors2 = textFieldColorsColors;
                function23 = function12;
                function24 = function17;
                function25 = function20;
                function26 = function18;
                function27 = function15;
                function28 = function11;
                z6 = z5;
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

                    public final void invoke(Composer composer2, int i31111111111119) {
                        OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                    }
                });
            }
        }
        i4 |= 48;
        if ((i3 & 4) != 0) {
            i4 |= 384;
        } else if ((i & 384) == 0) {
            if (composerStartRestartGroup.changed(z)) {
                i5 = Fields.RotationX;
            } else {
                i5 = 128;
            }
            i4 |= i5;
        }
        i6 = i3 & 8;
        i7 = Fields.CameraDistance;
        if (i6 != 0) {
            if ((i & 3072) == 0) {
                if (composerStartRestartGroup.changed(z2)) {
                    i8 = 2048;
                } else {
                    i8 = 1024;
                }
                i4 |= i8;
            }
            i9 = i3 & 16;
            i10 = Fields.Shape;
            if (i9 != 0) {
                if ((i & 24576) == 0) {
                    if (composerStartRestartGroup.changed(visualTransformation)) {
                        i11 = 16384;
                    } else {
                        i11 = 8192;
                    }
                    i4 |= i11;
                }
                if ((i3 & 32) != 0) {
                    i4 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changed(interactionSource)) {
                        i12 = 131072;
                    } else {
                        i12 = 65536;
                    }
                    i4 |= i12;
                }
                i13 = i3 & 64;
                if (i13 != 0) {
                    i4 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(z3)) {
                        i14 = 1048576;
                    } else {
                        i14 = 524288;
                    }
                    i4 |= i14;
                }
                i15 = i3 & Fields.SpotShadowColor;
                if (i15 != 0) {
                    i4 |= 12582912;
                } else if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i16 = 8388608;
                    } else {
                        i16 = 4194304;
                    }
                    i4 |= i16;
                }
                i17 = i3 & Fields.RotationX;
                if (i17 != 0) {
                    i4 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i18 = 67108864;
                    } else {
                        i18 = 33554432;
                    }
                    i4 |= i18;
                }
                i19 = i3 & Fields.RotationY;
                if (i19 != 0) {
                    i4 |= 805306368;
                } else if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function5)) {
                        i20 = 536870912;
                    } else {
                        i20 = 268435456;
                    }
                    i4 |= i20;
                }
                i21 = i3 & Fields.RotationZ;
                if (i21 != 0) {
                    i22 = i2 | 6;
                } else if ((i2 & 6) == 0) {
                    if (composerStartRestartGroup.changedInstance(function6)) {
                        i23 = 4;
                    } else {
                        i23 = 2;
                    }
                    i22 = i2 | i23;
                } else {
                    i22 = i2;
                }
                i24 = i3 & Fields.CameraDistance;
                if (i24 != 0) {
                    i22 |= 48;
                } else if ((i2 & 48) == 0) {
                    if (composerStartRestartGroup.changedInstance(function7)) {
                        i25 = 32;
                    } else {
                        i25 = 16;
                    }
                    i22 |= i25;
                }
                i26 = i22;
                i27 = i3 & Fields.TransformOrigin;
                if (i27 != 0) {
                    if ((i2 & 384) == 0) {
                        if (composerStartRestartGroup.changedInstance(function8)) {
                            i28 = Fields.RotationX;
                        } else {
                            i28 = 128;
                        }
                        i26 |= i28;
                    }
                    i29 = i3 & Fields.Shape;
                    if (i29 != 0) {
                        if ((i2 & 3072) == 0) {
                            if (!composerStartRestartGroup.changedInstance(function9)) {
                                i7 = 1024;
                            }
                            i26 |= i7;
                        }
                        if ((i2 & 24576) != 0) {
                            if ((i3 & Fields.Clip) == 0) {
                                i10 = 16384;
                            }
                            i26 |= i10;
                        }
                        if ((i2 & 196608) != 0) {
                            if ((i3 & Fields.CompositingStrategy) == 0) {
                                i34 = 65536;
                            } else {
                                i34 = 65536;
                            }
                            i26 |= i34;
                        }
                        i30 = i3 & 65536;
                        if (i30 != 0) {
                            i26 |= 1572864;
                        } else if ((i2 & 1572864) == 0) {
                            if (composerStartRestartGroup.changedInstance(function10)) {
                                i31 = 1048576;
                            } else {
                                i31 = 524288;
                            }
                            i26 |= i31;
                        }
                        if ((i3 & Fields.RenderEffect) != 0) {
                            i26 |= 12582912;
                        } else if ((i2 & 12582912) == 0) {
                            if (composerStartRestartGroup.changed(this)) {
                                i32 = 8388608;
                            } else {
                                i32 = 4194304;
                            }
                            i26 |= i32;
                        }
                        if ((i4 & 306783379) == 306783378) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i13 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z3;
                                }
                                if (i15 != 0) {
                                    function11 = null;
                                } else {
                                    function11 = function3;
                                }
                                if (i17 != 0) {
                                    function12 = null;
                                } else {
                                    function12 = function4;
                                }
                                if (i19 != 0) {
                                    function13 = null;
                                } else {
                                    function13 = function5;
                                }
                                if (i21 != 0) {
                                    function14 = null;
                                } else {
                                    function14 = function6;
                                }
                                if (i24 != 0) {
                                    function15 = null;
                                } else {
                                    function15 = function7;
                                }
                                if (i27 != 0) {
                                    function16 = null;
                                } else {
                                    function16 = function8;
                                }
                                if (i29 == 0) {
                                }
                                if ((i3 & Fields.Clip) != 0) {
                                    textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                    i26 &= -57345;
                                } else {
                                    textFieldColorsColors = textFieldColors;
                                }
                                if ((i3 & Fields.CompositingStrategy) != 0) {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                    i26 &= -458753;
                                } else {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                                }
                                function18 = function13;
                                if (i30 != 0) {
                                    ComposableLambda composableLambdaRememberComposableLambda1111112 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer2, int i31111111111119) {
                                            ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                            if ((i31111111111119 & 3) != 2 || !composer2.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1448570018, i31111111111119, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                                }
                                                OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer2.skipToGroupEnd();
                                        }
                                    }, composerStartRestartGroup, 54);
                                    function15 = function15;
                                    function19 = function14;
                                    function20 = composableLambdaRememberComposableLambda1111112;
                                } else {
                                    function19 = function14;
                                    function20 = function10;
                                }
                                i33 = i26;
                                z5 = z4;
                                paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                            } else {
                                if (i13 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z3;
                                }
                                if (i15 != 0) {
                                    function11 = null;
                                } else {
                                    function11 = function3;
                                }
                                if (i17 != 0) {
                                    function12 = null;
                                } else {
                                    function12 = function4;
                                }
                                if (i19 != 0) {
                                    function13 = null;
                                } else {
                                    function13 = function5;
                                }
                                if (i21 != 0) {
                                    function14 = null;
                                } else {
                                    function14 = function6;
                                }
                                if (i24 != 0) {
                                    function15 = null;
                                } else {
                                    function15 = function7;
                                }
                                if (i27 != 0) {
                                    function16 = null;
                                } else {
                                    function16 = function8;
                                }
                                if (i29 == 0) {
                                }
                                if ((i3 & Fields.Clip) != 0) {
                                    textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                    i26 &= -57345;
                                } else {
                                    textFieldColorsColors = textFieldColors;
                                }
                                if ((i3 & Fields.CompositingStrategy) != 0) {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                    i26 &= -458753;
                                } else {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                                }
                                function18 = function13;
                                if (i30 != 0) {
                                    ComposableLambda composableLambdaRememberComposableLambda1111113 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer2, int i31111111111119) {
                                            ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                            if ((i31111111111119 & 3) != 2 || !composer2.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1448570018, i31111111111119, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                                }
                                                OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer2.skipToGroupEnd();
                                        }
                                    }, composerStartRestartGroup, 54);
                                    function15 = function15;
                                    function19 = function14;
                                    function20 = composableLambdaRememberComposableLambda1111113;
                                } else {
                                    function19 = function14;
                                    function20 = function10;
                                }
                                i33 = i26;
                                z5 = z4;
                                paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                            }
                            int i31111111111119 = i4 << 3;
                            int i311111111111110 = i4 >> 3;
                            int i311111111111111 = i4 >> 9;
                            int i311111111111112 = i33 << 21;
                            TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i31111111111119 & 896) | (i31111111111119 & 112) | 6 | (i311111111111110 & 7168) | (i311111111111111 & 57344) | (i311111111111111 & 458752) | (i311111111111111 & 3670016) | (i311111111111112 & 29360128) | (i311111111111112 & 234881024) | (i311111111111112 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i311111111111111 & 7168) | (57344 & i311111111111110) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            function21 = function19;
                            paddingValues3 = paddingValues2;
                            function22 = function16;
                            textFieldColors2 = textFieldColorsColors;
                            function23 = function12;
                            function24 = function17;
                            function25 = function20;
                            function26 = function18;
                            function27 = function15;
                            function28 = function11;
                            z6 = z5;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i13 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z3;
                                }
                                if (i15 != 0) {
                                    function11 = null;
                                } else {
                                    function11 = function3;
                                }
                                if (i17 != 0) {
                                    function12 = null;
                                } else {
                                    function12 = function4;
                                }
                                if (i19 != 0) {
                                    function13 = null;
                                } else {
                                    function13 = function5;
                                }
                                if (i21 != 0) {
                                    function14 = null;
                                } else {
                                    function14 = function6;
                                }
                                if (i24 != 0) {
                                    function15 = null;
                                } else {
                                    function15 = function7;
                                }
                                if (i27 != 0) {
                                    function16 = null;
                                } else {
                                    function16 = function8;
                                }
                                if (i29 == 0) {
                                }
                                if ((i3 & Fields.Clip) != 0) {
                                    textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                    i26 &= -57345;
                                } else {
                                    textFieldColorsColors = textFieldColors;
                                }
                                if ((i3 & Fields.CompositingStrategy) != 0) {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                    i26 &= -458753;
                                } else {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                                }
                                function18 = function13;
                                if (i30 != 0) {
                                    ComposableLambda composableLambdaRememberComposableLambda1111114 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer2, int i311111111111113) {
                                            ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                            if ((i311111111111113 & 3) != 2 || !composer2.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1448570018, i311111111111113, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                                }
                                                OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer2.skipToGroupEnd();
                                        }
                                    }, composerStartRestartGroup, 54);
                                    function15 = function15;
                                    function19 = function14;
                                    function20 = composableLambdaRememberComposableLambda1111114;
                                } else {
                                    function19 = function14;
                                    function20 = function10;
                                }
                                i33 = i26;
                                z5 = z4;
                                paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                            } else {
                                if (i13 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z3;
                                }
                                if (i15 != 0) {
                                    function11 = null;
                                } else {
                                    function11 = function3;
                                }
                                if (i17 != 0) {
                                    function12 = null;
                                } else {
                                    function12 = function4;
                                }
                                if (i19 != 0) {
                                    function13 = null;
                                } else {
                                    function13 = function5;
                                }
                                if (i21 != 0) {
                                    function14 = null;
                                } else {
                                    function14 = function6;
                                }
                                if (i24 != 0) {
                                    function15 = null;
                                } else {
                                    function15 = function7;
                                }
                                if (i27 != 0) {
                                    function16 = null;
                                } else {
                                    function16 = function8;
                                }
                                if (i29 == 0) {
                                }
                                if ((i3 & Fields.Clip) != 0) {
                                    textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                    i26 &= -57345;
                                } else {
                                    textFieldColorsColors = textFieldColors;
                                }
                                if ((i3 & Fields.CompositingStrategy) != 0) {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                    i26 &= -458753;
                                } else {
                                    paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                                }
                                function18 = function13;
                                if (i30 != 0) {
                                    ComposableLambda composableLambdaRememberComposableLambda1111115 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer2, int i311111111111113) {
                                            ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                            if ((i311111111111113 & 3) != 2 || !composer2.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1448570018, i311111111111113, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                                }
                                                OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer2.skipToGroupEnd();
                                        }
                                    }, composerStartRestartGroup, 54);
                                    function15 = function15;
                                    function19 = function14;
                                    function20 = composableLambdaRememberComposableLambda1111115;
                                } else {
                                    function19 = function14;
                                    function20 = function10;
                                }
                                i33 = i26;
                                z5 = z4;
                                paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                            }
                            int i311111111111113 = i4 << 3;
                            int i311111111111114 = i4 >> 3;
                            int i311111111111115 = i4 >> 9;
                            int i311111111111116 = i33 << 21;
                            TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i311111111111113 & 896) | (i311111111111113 & 112) | 6 | (i311111111111114 & 7168) | (i311111111111115 & 57344) | (i311111111111115 & 458752) | (i311111111111115 & 3670016) | (i311111111111116 & 29360128) | (i311111111111116 & 234881024) | (i311111111111116 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i311111111111115 & 7168) | (57344 & i311111111111114) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            function21 = function19;
                            paddingValues3 = paddingValues2;
                            function22 = function16;
                            textFieldColors2 = textFieldColorsColors;
                            function23 = function12;
                            function24 = function17;
                            function25 = function20;
                            function26 = function18;
                            function27 = function15;
                            function28 = function11;
                            z6 = z5;
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

                                public final void invoke(Composer composer2, int i311111111111117) {
                                    OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                                }
                            });
                        }
                    }
                    i26 |= 3072;
                    if ((i2 & 24576) != 0) {
                        if ((i3 & Fields.Clip) == 0) {
                            i10 = 16384;
                        }
                        i26 |= i10;
                    }
                    if ((i2 & 196608) != 0) {
                        if ((i3 & Fields.CompositingStrategy) == 0) {
                            i34 = 65536;
                        } else {
                            i34 = 65536;
                        }
                        i26 |= i34;
                    }
                    i30 = i3 & 65536;
                    if (i30 != 0) {
                        i26 |= 1572864;
                    } else if ((i2 & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function10)) {
                            i31 = 1048576;
                        } else {
                            i31 = 524288;
                        }
                        i26 |= i31;
                    }
                    if ((i3 & Fields.RenderEffect) != 0) {
                        i26 |= 12582912;
                    } else if ((i2 & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(this)) {
                            i32 = 8388608;
                        } else {
                            i32 = 4194304;
                        }
                        i26 |= i32;
                    }
                    if ((i4 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda1111116 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i311111111111117) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i311111111111117 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i311111111111117, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda1111116;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        } else {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda1111117 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i311111111111117) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i311111111111117 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i311111111111117, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda1111117;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                        }
                        int i311111111111117 = i4 << 3;
                        int i311111111111118 = i4 >> 3;
                        int i311111111111119 = i4 >> 9;
                        int i3111111111111110 = i33 << 21;
                        TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i311111111111117 & 896) | (i311111111111117 & 112) | 6 | (i311111111111118 & 7168) | (i311111111111119 & 57344) | (i311111111111119 & 458752) | (i311111111111119 & 3670016) | (i3111111111111110 & 29360128) | (i3111111111111110 & 234881024) | (i3111111111111110 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i311111111111119 & 7168) | (57344 & i311111111111118) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function21 = function19;
                        paddingValues3 = paddingValues2;
                        function22 = function16;
                        textFieldColors2 = textFieldColorsColors;
                        function23 = function12;
                        function24 = function17;
                        function25 = function20;
                        function26 = function18;
                        function27 = function15;
                        function28 = function11;
                        z6 = z5;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda1111118 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i3111111111111111) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i3111111111111111 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i3111111111111111, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda1111118;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        } else {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda1111119 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i3111111111111111) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i3111111111111111 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i3111111111111111, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda1111119;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                        }
                        int i3111111111111111 = i4 << 3;
                        int i3111111111111112 = i4 >> 3;
                        int i3111111111111113 = i4 >> 9;
                        int i3111111111111114 = i33 << 21;
                        TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i3111111111111111 & 896) | (i3111111111111111 & 112) | 6 | (i3111111111111112 & 7168) | (i3111111111111113 & 57344) | (i3111111111111113 & 458752) | (i3111111111111113 & 3670016) | (i3111111111111114 & 29360128) | (i3111111111111114 & 234881024) | (i3111111111111114 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i3111111111111113 & 7168) | (57344 & i3111111111111112) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function21 = function19;
                        paddingValues3 = paddingValues2;
                        function22 = function16;
                        textFieldColors2 = textFieldColorsColors;
                        function23 = function12;
                        function24 = function17;
                        function25 = function20;
                        function26 = function18;
                        function27 = function15;
                        function28 = function11;
                        z6 = z5;
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

                            public final void invoke(Composer composer2, int i3111111111111115) {
                                OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                            }
                        });
                    }
                }
                i26 |= 384;
                i29 = i3 & Fields.Shape;
                if (i29 != 0) {
                    if ((i2 & 3072) == 0) {
                        if (!composerStartRestartGroup.changedInstance(function9)) {
                            i7 = 1024;
                        }
                        i26 |= i7;
                    }
                    if ((i2 & 24576) != 0) {
                        if ((i3 & Fields.Clip) == 0) {
                            i10 = 16384;
                        }
                        i26 |= i10;
                    }
                    if ((i2 & 196608) != 0) {
                        if ((i3 & Fields.CompositingStrategy) == 0) {
                            i34 = 65536;
                        } else {
                            i34 = 65536;
                        }
                        i26 |= i34;
                    }
                    i30 = i3 & 65536;
                    if (i30 != 0) {
                        i26 |= 1572864;
                    } else if ((i2 & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function10)) {
                            i31 = 1048576;
                        } else {
                            i31 = 524288;
                        }
                        i26 |= i31;
                    }
                    if ((i3 & Fields.RenderEffect) != 0) {
                        i26 |= 12582912;
                    } else if ((i2 & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(this)) {
                            i32 = 8388608;
                        } else {
                            i32 = 4194304;
                        }
                        i26 |= i32;
                    }
                    if ((i4 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda11111110 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i3111111111111115) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i3111111111111115 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i3111111111111115, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda11111110;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        } else {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda11111111 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i3111111111111115) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i3111111111111115 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i3111111111111115, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda11111111;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                        }
                        int i3111111111111115 = i4 << 3;
                        int i3111111111111116 = i4 >> 3;
                        int i3111111111111117 = i4 >> 9;
                        int i3111111111111118 = i33 << 21;
                        TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i3111111111111115 & 896) | (i3111111111111115 & 112) | 6 | (i3111111111111116 & 7168) | (i3111111111111117 & 57344) | (i3111111111111117 & 458752) | (i3111111111111117 & 3670016) | (i3111111111111118 & 29360128) | (i3111111111111118 & 234881024) | (i3111111111111118 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i3111111111111117 & 7168) | (57344 & i3111111111111116) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function21 = function19;
                        paddingValues3 = paddingValues2;
                        function22 = function16;
                        textFieldColors2 = textFieldColorsColors;
                        function23 = function12;
                        function24 = function17;
                        function25 = function20;
                        function26 = function18;
                        function27 = function15;
                        function28 = function11;
                        z6 = z5;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda11111112 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i3111111111111119) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i3111111111111119 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i3111111111111119, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda11111112;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        } else {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda11111113 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i3111111111111119) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i3111111111111119 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i3111111111111119, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda11111113;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                        }
                        int i3111111111111119 = i4 << 3;
                        int i31111111111111110 = i4 >> 3;
                        int i31111111111111111 = i4 >> 9;
                        int i31111111111111112 = i33 << 21;
                        TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i3111111111111119 & 896) | (i3111111111111119 & 112) | 6 | (i31111111111111110 & 7168) | (i31111111111111111 & 57344) | (i31111111111111111 & 458752) | (i31111111111111111 & 3670016) | (i31111111111111112 & 29360128) | (i31111111111111112 & 234881024) | (i31111111111111112 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i31111111111111111 & 7168) | (57344 & i31111111111111110) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function21 = function19;
                        paddingValues3 = paddingValues2;
                        function22 = function16;
                        textFieldColors2 = textFieldColorsColors;
                        function23 = function12;
                        function24 = function17;
                        function25 = function20;
                        function26 = function18;
                        function27 = function15;
                        function28 = function11;
                        z6 = z5;
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

                            public final void invoke(Composer composer2, int i31111111111111113) {
                                OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                            }
                        });
                    }
                }
                i26 |= 3072;
                if ((i2 & 24576) != 0) {
                    if ((i3 & Fields.Clip) == 0) {
                        i10 = 16384;
                    }
                    i26 |= i10;
                }
                if ((i2 & 196608) != 0) {
                    if ((i3 & Fields.CompositingStrategy) == 0) {
                        i34 = 65536;
                    } else {
                        i34 = 65536;
                    }
                    i26 |= i34;
                }
                i30 = i3 & 65536;
                if (i30 != 0) {
                    i26 |= 1572864;
                } else if ((i2 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function10)) {
                        i31 = 1048576;
                    } else {
                        i31 = 524288;
                    }
                    i26 |= i31;
                }
                if ((i3 & Fields.RenderEffect) != 0) {
                    i26 |= 12582912;
                } else if ((i2 & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(this)) {
                        i32 = 8388608;
                    } else {
                        i32 = 4194304;
                    }
                    i26 |= i32;
                }
                if ((i4 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda11111114 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i31111111111111113) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i31111111111111113 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i31111111111111113, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda11111114;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    } else {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda11111115 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i31111111111111113) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i31111111111111113 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i31111111111111113, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda11111115;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                    }
                    int i31111111111111113 = i4 << 3;
                    int i31111111111111114 = i4 >> 3;
                    int i31111111111111115 = i4 >> 9;
                    int i31111111111111116 = i33 << 21;
                    TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i31111111111111113 & 896) | (i31111111111111113 & 112) | 6 | (i31111111111111114 & 7168) | (i31111111111111115 & 57344) | (i31111111111111115 & 458752) | (i31111111111111115 & 3670016) | (i31111111111111116 & 29360128) | (i31111111111111116 & 234881024) | (i31111111111111116 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i31111111111111115 & 7168) | (57344 & i31111111111111114) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function21 = function19;
                    paddingValues3 = paddingValues2;
                    function22 = function16;
                    textFieldColors2 = textFieldColorsColors;
                    function23 = function12;
                    function24 = function17;
                    function25 = function20;
                    function26 = function18;
                    function27 = function15;
                    function28 = function11;
                    z6 = z5;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda11111116 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i31111111111111117) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i31111111111111117 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i31111111111111117, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda11111116;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    } else {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda11111117 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i31111111111111117) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i31111111111111117 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i31111111111111117, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda11111117;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                    }
                    int i31111111111111117 = i4 << 3;
                    int i31111111111111118 = i4 >> 3;
                    int i31111111111111119 = i4 >> 9;
                    int i311111111111111110 = i33 << 21;
                    TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i31111111111111117 & 896) | (i31111111111111117 & 112) | 6 | (i31111111111111118 & 7168) | (i31111111111111119 & 57344) | (i31111111111111119 & 458752) | (i31111111111111119 & 3670016) | (i311111111111111110 & 29360128) | (i311111111111111110 & 234881024) | (i311111111111111110 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i31111111111111119 & 7168) | (57344 & i31111111111111118) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function21 = function19;
                    paddingValues3 = paddingValues2;
                    function22 = function16;
                    textFieldColors2 = textFieldColorsColors;
                    function23 = function12;
                    function24 = function17;
                    function25 = function20;
                    function26 = function18;
                    function27 = function15;
                    function28 = function11;
                    z6 = z5;
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

                        public final void invoke(Composer composer2, int i311111111111111111) {
                            OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i4 |= 24576;
            if ((i3 & 32) != 0) {
                i4 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changed(interactionSource)) {
                    i12 = 131072;
                } else {
                    i12 = 65536;
                }
                i4 |= i12;
            }
            i13 = i3 & 64;
            if (i13 != 0) {
                i4 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changed(z3)) {
                    i14 = 1048576;
                } else {
                    i14 = 524288;
                }
                i4 |= i14;
            }
            i15 = i3 & Fields.SpotShadowColor;
            if (i15 != 0) {
                i4 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i16 = 8388608;
                } else {
                    i16 = 4194304;
                }
                i4 |= i16;
            }
            i17 = i3 & Fields.RotationX;
            if (i17 != 0) {
                i4 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i18 = 67108864;
                } else {
                    i18 = 33554432;
                }
                i4 |= i18;
            }
            i19 = i3 & Fields.RotationY;
            if (i19 != 0) {
                i4 |= 805306368;
            } else if ((i & 805306368) == 0) {
                if (composerStartRestartGroup.changedInstance(function5)) {
                    i20 = 536870912;
                } else {
                    i20 = 268435456;
                }
                i4 |= i20;
            }
            i21 = i3 & Fields.RotationZ;
            if (i21 != 0) {
                i22 = i2 | 6;
            } else if ((i2 & 6) == 0) {
                if (composerStartRestartGroup.changedInstance(function6)) {
                    i23 = 4;
                } else {
                    i23 = 2;
                }
                i22 = i2 | i23;
            } else {
                i22 = i2;
            }
            i24 = i3 & Fields.CameraDistance;
            if (i24 != 0) {
                i22 |= 48;
            } else if ((i2 & 48) == 0) {
                if (composerStartRestartGroup.changedInstance(function7)) {
                    i25 = 32;
                } else {
                    i25 = 16;
                }
                i22 |= i25;
            }
            i26 = i22;
            i27 = i3 & Fields.TransformOrigin;
            if (i27 != 0) {
                if ((i2 & 384) == 0) {
                    if (composerStartRestartGroup.changedInstance(function8)) {
                        i28 = Fields.RotationX;
                    } else {
                        i28 = 128;
                    }
                    i26 |= i28;
                }
                i29 = i3 & Fields.Shape;
                if (i29 != 0) {
                    if ((i2 & 3072) == 0) {
                        if (!composerStartRestartGroup.changedInstance(function9)) {
                            i7 = 1024;
                        }
                        i26 |= i7;
                    }
                    if ((i2 & 24576) != 0) {
                        if ((i3 & Fields.Clip) == 0) {
                            i10 = 16384;
                        }
                        i26 |= i10;
                    }
                    if ((i2 & 196608) != 0) {
                        if ((i3 & Fields.CompositingStrategy) == 0) {
                            i34 = 65536;
                        } else {
                            i34 = 65536;
                        }
                        i26 |= i34;
                    }
                    i30 = i3 & 65536;
                    if (i30 != 0) {
                        i26 |= 1572864;
                    } else if ((i2 & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function10)) {
                            i31 = 1048576;
                        } else {
                            i31 = 524288;
                        }
                        i26 |= i31;
                    }
                    if ((i3 & Fields.RenderEffect) != 0) {
                        i26 |= 12582912;
                    } else if ((i2 & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(this)) {
                            i32 = 8388608;
                        } else {
                            i32 = 4194304;
                        }
                        i26 |= i32;
                    }
                    if ((i4 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda11111118 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i311111111111111111) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i311111111111111111 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i311111111111111111, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda11111118;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        } else {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda11111119 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i311111111111111111) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i311111111111111111 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i311111111111111111, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda11111119;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                        }
                        int i311111111111111111 = i4 << 3;
                        int i311111111111111112 = i4 >> 3;
                        int i311111111111111113 = i4 >> 9;
                        int i311111111111111114 = i33 << 21;
                        TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i311111111111111111 & 896) | (i311111111111111111 & 112) | 6 | (i311111111111111112 & 7168) | (i311111111111111113 & 57344) | (i311111111111111113 & 458752) | (i311111111111111113 & 3670016) | (i311111111111111114 & 29360128) | (i311111111111111114 & 234881024) | (i311111111111111114 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i311111111111111113 & 7168) | (57344 & i311111111111111112) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function21 = function19;
                        paddingValues3 = paddingValues2;
                        function22 = function16;
                        textFieldColors2 = textFieldColorsColors;
                        function23 = function12;
                        function24 = function17;
                        function25 = function20;
                        function26 = function18;
                        function27 = function15;
                        function28 = function11;
                        z6 = z5;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda111111110 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i311111111111111115) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i311111111111111115 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i311111111111111115, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda111111110;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        } else {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda111111111 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i311111111111111115) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i311111111111111115 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i311111111111111115, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda111111111;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                        }
                        int i311111111111111115 = i4 << 3;
                        int i311111111111111116 = i4 >> 3;
                        int i311111111111111117 = i4 >> 9;
                        int i311111111111111118 = i33 << 21;
                        TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i311111111111111115 & 896) | (i311111111111111115 & 112) | 6 | (i311111111111111116 & 7168) | (i311111111111111117 & 57344) | (i311111111111111117 & 458752) | (i311111111111111117 & 3670016) | (i311111111111111118 & 29360128) | (i311111111111111118 & 234881024) | (i311111111111111118 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i311111111111111117 & 7168) | (57344 & i311111111111111116) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function21 = function19;
                        paddingValues3 = paddingValues2;
                        function22 = function16;
                        textFieldColors2 = textFieldColorsColors;
                        function23 = function12;
                        function24 = function17;
                        function25 = function20;
                        function26 = function18;
                        function27 = function15;
                        function28 = function11;
                        z6 = z5;
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

                            public final void invoke(Composer composer2, int i311111111111111119) {
                                OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                            }
                        });
                    }
                }
                i26 |= 3072;
                if ((i2 & 24576) != 0) {
                    if ((i3 & Fields.Clip) == 0) {
                        i10 = 16384;
                    }
                    i26 |= i10;
                }
                if ((i2 & 196608) != 0) {
                    if ((i3 & Fields.CompositingStrategy) == 0) {
                        i34 = 65536;
                    } else {
                        i34 = 65536;
                    }
                    i26 |= i34;
                }
                i30 = i3 & 65536;
                if (i30 != 0) {
                    i26 |= 1572864;
                } else if ((i2 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function10)) {
                        i31 = 1048576;
                    } else {
                        i31 = 524288;
                    }
                    i26 |= i31;
                }
                if ((i3 & Fields.RenderEffect) != 0) {
                    i26 |= 12582912;
                } else if ((i2 & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(this)) {
                        i32 = 8388608;
                    } else {
                        i32 = 4194304;
                    }
                    i26 |= i32;
                }
                if ((i4 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda111111112 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i311111111111111119) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i311111111111111119 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i311111111111111119, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda111111112;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    } else {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda111111113 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i311111111111111119) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i311111111111111119 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i311111111111111119, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda111111113;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                    }
                    int i311111111111111119 = i4 << 3;
                    int i3111111111111111110 = i4 >> 3;
                    int i3111111111111111111 = i4 >> 9;
                    int i3111111111111111112 = i33 << 21;
                    TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i311111111111111119 & 896) | (i311111111111111119 & 112) | 6 | (i3111111111111111110 & 7168) | (i3111111111111111111 & 57344) | (i3111111111111111111 & 458752) | (i3111111111111111111 & 3670016) | (i3111111111111111112 & 29360128) | (i3111111111111111112 & 234881024) | (i3111111111111111112 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i3111111111111111111 & 7168) | (57344 & i3111111111111111110) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function21 = function19;
                    paddingValues3 = paddingValues2;
                    function22 = function16;
                    textFieldColors2 = textFieldColorsColors;
                    function23 = function12;
                    function24 = function17;
                    function25 = function20;
                    function26 = function18;
                    function27 = function15;
                    function28 = function11;
                    z6 = z5;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda111111114 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i3111111111111111113) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i3111111111111111113 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i3111111111111111113, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda111111114;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    } else {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda111111115 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i3111111111111111113) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i3111111111111111113 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i3111111111111111113, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda111111115;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                    }
                    int i3111111111111111113 = i4 << 3;
                    int i3111111111111111114 = i4 >> 3;
                    int i3111111111111111115 = i4 >> 9;
                    int i3111111111111111116 = i33 << 21;
                    TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i3111111111111111113 & 896) | (i3111111111111111113 & 112) | 6 | (i3111111111111111114 & 7168) | (i3111111111111111115 & 57344) | (i3111111111111111115 & 458752) | (i3111111111111111115 & 3670016) | (i3111111111111111116 & 29360128) | (i3111111111111111116 & 234881024) | (i3111111111111111116 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i3111111111111111115 & 7168) | (57344 & i3111111111111111114) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function21 = function19;
                    paddingValues3 = paddingValues2;
                    function22 = function16;
                    textFieldColors2 = textFieldColorsColors;
                    function23 = function12;
                    function24 = function17;
                    function25 = function20;
                    function26 = function18;
                    function27 = function15;
                    function28 = function11;
                    z6 = z5;
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

                        public final void invoke(Composer composer2, int i3111111111111111117) {
                            OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i26 |= 384;
            i29 = i3 & Fields.Shape;
            if (i29 != 0) {
                if ((i2 & 3072) == 0) {
                    if (!composerStartRestartGroup.changedInstance(function9)) {
                        i7 = 1024;
                    }
                    i26 |= i7;
                }
                if ((i2 & 24576) != 0) {
                    if ((i3 & Fields.Clip) == 0) {
                        i10 = 16384;
                    }
                    i26 |= i10;
                }
                if ((i2 & 196608) != 0) {
                    if ((i3 & Fields.CompositingStrategy) == 0) {
                        i34 = 65536;
                    } else {
                        i34 = 65536;
                    }
                    i26 |= i34;
                }
                i30 = i3 & 65536;
                if (i30 != 0) {
                    i26 |= 1572864;
                } else if ((i2 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function10)) {
                        i31 = 1048576;
                    } else {
                        i31 = 524288;
                    }
                    i26 |= i31;
                }
                if ((i3 & Fields.RenderEffect) != 0) {
                    i26 |= 12582912;
                } else if ((i2 & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(this)) {
                        i32 = 8388608;
                    } else {
                        i32 = 4194304;
                    }
                    i26 |= i32;
                }
                if ((i4 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda111111116 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i3111111111111111117) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i3111111111111111117 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i3111111111111111117, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda111111116;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    } else {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda111111117 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i3111111111111111117) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i3111111111111111117 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i3111111111111111117, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda111111117;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                    }
                    int i3111111111111111117 = i4 << 3;
                    int i3111111111111111118 = i4 >> 3;
                    int i3111111111111111119 = i4 >> 9;
                    int i31111111111111111110 = i33 << 21;
                    TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i3111111111111111117 & 896) | (i3111111111111111117 & 112) | 6 | (i3111111111111111118 & 7168) | (i3111111111111111119 & 57344) | (i3111111111111111119 & 458752) | (i3111111111111111119 & 3670016) | (i31111111111111111110 & 29360128) | (i31111111111111111110 & 234881024) | (i31111111111111111110 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i3111111111111111119 & 7168) | (57344 & i3111111111111111118) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function21 = function19;
                    paddingValues3 = paddingValues2;
                    function22 = function16;
                    textFieldColors2 = textFieldColorsColors;
                    function23 = function12;
                    function24 = function17;
                    function25 = function20;
                    function26 = function18;
                    function27 = function15;
                    function28 = function11;
                    z6 = z5;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda111111118 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i31111111111111111111) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i31111111111111111111 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i31111111111111111111, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda111111118;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    } else {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda111111119 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i31111111111111111111) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i31111111111111111111 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i31111111111111111111, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda111111119;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                    }
                    int i31111111111111111111 = i4 << 3;
                    int i31111111111111111112 = i4 >> 3;
                    int i31111111111111111113 = i4 >> 9;
                    int i31111111111111111114 = i33 << 21;
                    TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i31111111111111111111 & 896) | (i31111111111111111111 & 112) | 6 | (i31111111111111111112 & 7168) | (i31111111111111111113 & 57344) | (i31111111111111111113 & 458752) | (i31111111111111111113 & 3670016) | (i31111111111111111114 & 29360128) | (i31111111111111111114 & 234881024) | (i31111111111111111114 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i31111111111111111113 & 7168) | (57344 & i31111111111111111112) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function21 = function19;
                    paddingValues3 = paddingValues2;
                    function22 = function16;
                    textFieldColors2 = textFieldColorsColors;
                    function23 = function12;
                    function24 = function17;
                    function25 = function20;
                    function26 = function18;
                    function27 = function15;
                    function28 = function11;
                    z6 = z5;
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

                        public final void invoke(Composer composer2, int i31111111111111111115) {
                            OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i26 |= 3072;
            if ((i2 & 24576) != 0) {
                if ((i3 & Fields.Clip) == 0) {
                    i10 = 16384;
                }
                i26 |= i10;
            }
            if ((i2 & 196608) != 0) {
                if ((i3 & Fields.CompositingStrategy) == 0) {
                    i34 = 65536;
                } else {
                    i34 = 65536;
                }
                i26 |= i34;
            }
            i30 = i3 & 65536;
            if (i30 != 0) {
                i26 |= 1572864;
            } else if ((i2 & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function10)) {
                    i31 = 1048576;
                } else {
                    i31 = 524288;
                }
                i26 |= i31;
            }
            if ((i3 & Fields.RenderEffect) != 0) {
                i26 |= 12582912;
            } else if ((i2 & 12582912) == 0) {
                if (composerStartRestartGroup.changed(this)) {
                    i32 = 8388608;
                } else {
                    i32 = 4194304;
                }
                i26 |= i32;
            }
            if ((i4 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        z4 = false;
                    } else {
                        z4 = z3;
                    }
                    if (i15 != 0) {
                        function11 = null;
                    } else {
                        function11 = function3;
                    }
                    if (i17 != 0) {
                        function12 = null;
                    } else {
                        function12 = function4;
                    }
                    if (i19 != 0) {
                        function13 = null;
                    } else {
                        function13 = function5;
                    }
                    if (i21 != 0) {
                        function14 = null;
                    } else {
                        function14 = function6;
                    }
                    if (i24 != 0) {
                        function15 = null;
                    } else {
                        function15 = function7;
                    }
                    if (i27 != 0) {
                        function16 = null;
                    } else {
                        function16 = function8;
                    }
                    if (i29 == 0) {
                    }
                    if ((i3 & Fields.Clip) != 0) {
                        textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                        i26 &= -57345;
                    } else {
                        textFieldColorsColors = textFieldColors;
                    }
                    if ((i3 & Fields.CompositingStrategy) != 0) {
                        paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                        i26 &= -458753;
                    } else {
                        paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                    }
                    function18 = function13;
                    if (i30 != 0) {
                        ComposableLambda composableLambdaRememberComposableLambda1111111110 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i31111111111111111115) {
                                ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                if ((i31111111111111111115 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1448570018, i31111111111111111115, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                    }
                                    OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        function15 = function15;
                        function19 = function14;
                        function20 = composableLambdaRememberComposableLambda1111111110;
                    } else {
                        function19 = function14;
                        function20 = function10;
                    }
                    i33 = i26;
                    z5 = z4;
                    paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                } else {
                    if (i13 != 0) {
                        z4 = false;
                    } else {
                        z4 = z3;
                    }
                    if (i15 != 0) {
                        function11 = null;
                    } else {
                        function11 = function3;
                    }
                    if (i17 != 0) {
                        function12 = null;
                    } else {
                        function12 = function4;
                    }
                    if (i19 != 0) {
                        function13 = null;
                    } else {
                        function13 = function5;
                    }
                    if (i21 != 0) {
                        function14 = null;
                    } else {
                        function14 = function6;
                    }
                    if (i24 != 0) {
                        function15 = null;
                    } else {
                        function15 = function7;
                    }
                    if (i27 != 0) {
                        function16 = null;
                    } else {
                        function16 = function8;
                    }
                    if (i29 == 0) {
                    }
                    if ((i3 & Fields.Clip) != 0) {
                        textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                        i26 &= -57345;
                    } else {
                        textFieldColorsColors = textFieldColors;
                    }
                    if ((i3 & Fields.CompositingStrategy) != 0) {
                        paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                        i26 &= -458753;
                    } else {
                        paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                    }
                    function18 = function13;
                    if (i30 != 0) {
                        ComposableLambda composableLambdaRememberComposableLambda1111111111 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i31111111111111111115) {
                                ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                if ((i31111111111111111115 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1448570018, i31111111111111111115, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                    }
                                    OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        function15 = function15;
                        function19 = function14;
                        function20 = composableLambdaRememberComposableLambda1111111111;
                    } else {
                        function19 = function14;
                        function20 = function10;
                    }
                    i33 = i26;
                    z5 = z4;
                    paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                }
                int i31111111111111111115 = i4 << 3;
                int i31111111111111111116 = i4 >> 3;
                int i31111111111111111117 = i4 >> 9;
                int i31111111111111111118 = i33 << 21;
                TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i31111111111111111115 & 896) | (i31111111111111111115 & 112) | 6 | (i31111111111111111116 & 7168) | (i31111111111111111117 & 57344) | (i31111111111111111117 & 458752) | (i31111111111111111117 & 3670016) | (i31111111111111111118 & 29360128) | (i31111111111111111118 & 234881024) | (i31111111111111111118 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i31111111111111111117 & 7168) | (57344 & i31111111111111111116) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function21 = function19;
                paddingValues3 = paddingValues2;
                function22 = function16;
                textFieldColors2 = textFieldColorsColors;
                function23 = function12;
                function24 = function17;
                function25 = function20;
                function26 = function18;
                function27 = function15;
                function28 = function11;
                z6 = z5;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        z4 = false;
                    } else {
                        z4 = z3;
                    }
                    if (i15 != 0) {
                        function11 = null;
                    } else {
                        function11 = function3;
                    }
                    if (i17 != 0) {
                        function12 = null;
                    } else {
                        function12 = function4;
                    }
                    if (i19 != 0) {
                        function13 = null;
                    } else {
                        function13 = function5;
                    }
                    if (i21 != 0) {
                        function14 = null;
                    } else {
                        function14 = function6;
                    }
                    if (i24 != 0) {
                        function15 = null;
                    } else {
                        function15 = function7;
                    }
                    if (i27 != 0) {
                        function16 = null;
                    } else {
                        function16 = function8;
                    }
                    if (i29 == 0) {
                    }
                    if ((i3 & Fields.Clip) != 0) {
                        textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                        i26 &= -57345;
                    } else {
                        textFieldColorsColors = textFieldColors;
                    }
                    if ((i3 & Fields.CompositingStrategy) != 0) {
                        paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                        i26 &= -458753;
                    } else {
                        paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                    }
                    function18 = function13;
                    if (i30 != 0) {
                        ComposableLambda composableLambdaRememberComposableLambda1111111112 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i31111111111111111119) {
                                ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                if ((i31111111111111111119 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1448570018, i31111111111111111119, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                    }
                                    OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        function15 = function15;
                        function19 = function14;
                        function20 = composableLambdaRememberComposableLambda1111111112;
                    } else {
                        function19 = function14;
                        function20 = function10;
                    }
                    i33 = i26;
                    z5 = z4;
                    paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                } else {
                    if (i13 != 0) {
                        z4 = false;
                    } else {
                        z4 = z3;
                    }
                    if (i15 != 0) {
                        function11 = null;
                    } else {
                        function11 = function3;
                    }
                    if (i17 != 0) {
                        function12 = null;
                    } else {
                        function12 = function4;
                    }
                    if (i19 != 0) {
                        function13 = null;
                    } else {
                        function13 = function5;
                    }
                    if (i21 != 0) {
                        function14 = null;
                    } else {
                        function14 = function6;
                    }
                    if (i24 != 0) {
                        function15 = null;
                    } else {
                        function15 = function7;
                    }
                    if (i27 != 0) {
                        function16 = null;
                    } else {
                        function16 = function8;
                    }
                    if (i29 == 0) {
                    }
                    if ((i3 & Fields.Clip) != 0) {
                        textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                        i26 &= -57345;
                    } else {
                        textFieldColorsColors = textFieldColors;
                    }
                    if ((i3 & Fields.CompositingStrategy) != 0) {
                        paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                        i26 &= -458753;
                    } else {
                        paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                    }
                    function18 = function13;
                    if (i30 != 0) {
                        ComposableLambda composableLambdaRememberComposableLambda1111111113 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i31111111111111111119) {
                                ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                if ((i31111111111111111119 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1448570018, i31111111111111111119, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                    }
                                    OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        function15 = function15;
                        function19 = function14;
                        function20 = composableLambdaRememberComposableLambda1111111113;
                    } else {
                        function19 = function14;
                        function20 = function10;
                    }
                    i33 = i26;
                    z5 = z4;
                    paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                }
                int i31111111111111111119 = i4 << 3;
                int i311111111111111111110 = i4 >> 3;
                int i311111111111111111111 = i4 >> 9;
                int i311111111111111111112 = i33 << 21;
                TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i31111111111111111119 & 896) | (i31111111111111111119 & 112) | 6 | (i311111111111111111110 & 7168) | (i311111111111111111111 & 57344) | (i311111111111111111111 & 458752) | (i311111111111111111111 & 3670016) | (i311111111111111111112 & 29360128) | (i311111111111111111112 & 234881024) | (i311111111111111111112 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i311111111111111111111 & 7168) | (57344 & i311111111111111111110) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function21 = function19;
                paddingValues3 = paddingValues2;
                function22 = function16;
                textFieldColors2 = textFieldColorsColors;
                function23 = function12;
                function24 = function17;
                function25 = function20;
                function26 = function18;
                function27 = function15;
                function28 = function11;
                z6 = z5;
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

                    public final void invoke(Composer composer2, int i311111111111111111113) {
                        OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                    }
                });
            }
        }
        i4 |= 3072;
        i9 = i3 & 16;
        i10 = Fields.Shape;
        if (i9 != 0) {
            if ((i & 24576) == 0) {
                if (composerStartRestartGroup.changed(visualTransformation)) {
                    i11 = 16384;
                } else {
                    i11 = 8192;
                }
                i4 |= i11;
            }
            if ((i3 & 32) != 0) {
                i4 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changed(interactionSource)) {
                    i12 = 131072;
                } else {
                    i12 = 65536;
                }
                i4 |= i12;
            }
            i13 = i3 & 64;
            if (i13 != 0) {
                i4 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changed(z3)) {
                    i14 = 1048576;
                } else {
                    i14 = 524288;
                }
                i4 |= i14;
            }
            i15 = i3 & Fields.SpotShadowColor;
            if (i15 != 0) {
                i4 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i16 = 8388608;
                } else {
                    i16 = 4194304;
                }
                i4 |= i16;
            }
            i17 = i3 & Fields.RotationX;
            if (i17 != 0) {
                i4 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i18 = 67108864;
                } else {
                    i18 = 33554432;
                }
                i4 |= i18;
            }
            i19 = i3 & Fields.RotationY;
            if (i19 != 0) {
                i4 |= 805306368;
            } else if ((i & 805306368) == 0) {
                if (composerStartRestartGroup.changedInstance(function5)) {
                    i20 = 536870912;
                } else {
                    i20 = 268435456;
                }
                i4 |= i20;
            }
            i21 = i3 & Fields.RotationZ;
            if (i21 != 0) {
                i22 = i2 | 6;
            } else if ((i2 & 6) == 0) {
                if (composerStartRestartGroup.changedInstance(function6)) {
                    i23 = 4;
                } else {
                    i23 = 2;
                }
                i22 = i2 | i23;
            } else {
                i22 = i2;
            }
            i24 = i3 & Fields.CameraDistance;
            if (i24 != 0) {
                i22 |= 48;
            } else if ((i2 & 48) == 0) {
                if (composerStartRestartGroup.changedInstance(function7)) {
                    i25 = 32;
                } else {
                    i25 = 16;
                }
                i22 |= i25;
            }
            i26 = i22;
            i27 = i3 & Fields.TransformOrigin;
            if (i27 != 0) {
                if ((i2 & 384) == 0) {
                    if (composerStartRestartGroup.changedInstance(function8)) {
                        i28 = Fields.RotationX;
                    } else {
                        i28 = 128;
                    }
                    i26 |= i28;
                }
                i29 = i3 & Fields.Shape;
                if (i29 != 0) {
                    if ((i2 & 3072) == 0) {
                        if (!composerStartRestartGroup.changedInstance(function9)) {
                            i7 = 1024;
                        }
                        i26 |= i7;
                    }
                    if ((i2 & 24576) != 0) {
                        if ((i3 & Fields.Clip) == 0) {
                            i10 = 16384;
                        }
                        i26 |= i10;
                    }
                    if ((i2 & 196608) != 0) {
                        if ((i3 & Fields.CompositingStrategy) == 0) {
                            i34 = 65536;
                        } else {
                            i34 = 65536;
                        }
                        i26 |= i34;
                    }
                    i30 = i3 & 65536;
                    if (i30 != 0) {
                        i26 |= 1572864;
                    } else if ((i2 & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function10)) {
                            i31 = 1048576;
                        } else {
                            i31 = 524288;
                        }
                        i26 |= i31;
                    }
                    if ((i3 & Fields.RenderEffect) != 0) {
                        i26 |= 12582912;
                    } else if ((i2 & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(this)) {
                            i32 = 8388608;
                        } else {
                            i32 = 4194304;
                        }
                        i26 |= i32;
                    }
                    if ((i4 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda1111111114 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i311111111111111111113) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i311111111111111111113 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i311111111111111111113, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda1111111114;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        } else {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda1111111115 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i311111111111111111113) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i311111111111111111113 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i311111111111111111113, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda1111111115;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                        }
                        int i311111111111111111113 = i4 << 3;
                        int i311111111111111111114 = i4 >> 3;
                        int i311111111111111111115 = i4 >> 9;
                        int i311111111111111111116 = i33 << 21;
                        TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i311111111111111111113 & 896) | (i311111111111111111113 & 112) | 6 | (i311111111111111111114 & 7168) | (i311111111111111111115 & 57344) | (i311111111111111111115 & 458752) | (i311111111111111111115 & 3670016) | (i311111111111111111116 & 29360128) | (i311111111111111111116 & 234881024) | (i311111111111111111116 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i311111111111111111115 & 7168) | (57344 & i311111111111111111114) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function21 = function19;
                        paddingValues3 = paddingValues2;
                        function22 = function16;
                        textFieldColors2 = textFieldColorsColors;
                        function23 = function12;
                        function24 = function17;
                        function25 = function20;
                        function26 = function18;
                        function27 = function15;
                        function28 = function11;
                        z6 = z5;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda1111111116 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i311111111111111111117) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i311111111111111111117 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i311111111111111111117, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda1111111116;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        } else {
                            if (i13 != 0) {
                                z4 = false;
                            } else {
                                z4 = z3;
                            }
                            if (i15 != 0) {
                                function11 = null;
                            } else {
                                function11 = function3;
                            }
                            if (i17 != 0) {
                                function12 = null;
                            } else {
                                function12 = function4;
                            }
                            if (i19 != 0) {
                                function13 = null;
                            } else {
                                function13 = function5;
                            }
                            if (i21 != 0) {
                                function14 = null;
                            } else {
                                function14 = function6;
                            }
                            if (i24 != 0) {
                                function15 = null;
                            } else {
                                function15 = function7;
                            }
                            if (i27 != 0) {
                                function16 = null;
                            } else {
                                function16 = function8;
                            }
                            if (i29 == 0) {
                            }
                            if ((i3 & Fields.Clip) != 0) {
                                textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                                i26 &= -57345;
                            } else {
                                textFieldColorsColors = textFieldColors;
                            }
                            if ((i3 & Fields.CompositingStrategy) != 0) {
                                paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                                i26 &= -458753;
                            } else {
                                paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                            }
                            function18 = function13;
                            if (i30 != 0) {
                                ComposableLambda composableLambdaRememberComposableLambda1111111117 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i311111111111111111117) {
                                        ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                        if ((i311111111111111111117 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1448570018, i311111111111111111117, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                            }
                                            OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                function15 = function15;
                                function19 = function14;
                                function20 = composableLambdaRememberComposableLambda1111111117;
                            } else {
                                function19 = function14;
                                function20 = function10;
                            }
                            i33 = i26;
                            z5 = z4;
                            paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                        }
                        int i311111111111111111117 = i4 << 3;
                        int i311111111111111111118 = i4 >> 3;
                        int i311111111111111111119 = i4 >> 9;
                        int i3111111111111111111110 = i33 << 21;
                        TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i311111111111111111117 & 896) | (i311111111111111111117 & 112) | 6 | (i311111111111111111118 & 7168) | (i311111111111111111119 & 57344) | (i311111111111111111119 & 458752) | (i311111111111111111119 & 3670016) | (i3111111111111111111110 & 29360128) | (i3111111111111111111110 & 234881024) | (i3111111111111111111110 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i311111111111111111119 & 7168) | (57344 & i311111111111111111118) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function21 = function19;
                        paddingValues3 = paddingValues2;
                        function22 = function16;
                        textFieldColors2 = textFieldColorsColors;
                        function23 = function12;
                        function24 = function17;
                        function25 = function20;
                        function26 = function18;
                        function27 = function15;
                        function28 = function11;
                        z6 = z5;
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

                            public final void invoke(Composer composer2, int i3111111111111111111111) {
                                OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                            }
                        });
                    }
                }
                i26 |= 3072;
                if ((i2 & 24576) != 0) {
                    if ((i3 & Fields.Clip) == 0) {
                        i10 = 16384;
                    }
                    i26 |= i10;
                }
                if ((i2 & 196608) != 0) {
                    if ((i3 & Fields.CompositingStrategy) == 0) {
                        i34 = 65536;
                    } else {
                        i34 = 65536;
                    }
                    i26 |= i34;
                }
                i30 = i3 & 65536;
                if (i30 != 0) {
                    i26 |= 1572864;
                } else if ((i2 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function10)) {
                        i31 = 1048576;
                    } else {
                        i31 = 524288;
                    }
                    i26 |= i31;
                }
                if ((i3 & Fields.RenderEffect) != 0) {
                    i26 |= 12582912;
                } else if ((i2 & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(this)) {
                        i32 = 8388608;
                    } else {
                        i32 = 4194304;
                    }
                    i26 |= i32;
                }
                if ((i4 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda1111111118 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i3111111111111111111111) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i3111111111111111111111 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i3111111111111111111111, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda1111111118;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    } else {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda1111111119 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i3111111111111111111111) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i3111111111111111111111 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i3111111111111111111111, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda1111111119;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                    }
                    int i3111111111111111111111 = i4 << 3;
                    int i3111111111111111111112 = i4 >> 3;
                    int i3111111111111111111113 = i4 >> 9;
                    int i3111111111111111111114 = i33 << 21;
                    TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i3111111111111111111111 & 896) | (i3111111111111111111111 & 112) | 6 | (i3111111111111111111112 & 7168) | (i3111111111111111111113 & 57344) | (i3111111111111111111113 & 458752) | (i3111111111111111111113 & 3670016) | (i3111111111111111111114 & 29360128) | (i3111111111111111111114 & 234881024) | (i3111111111111111111114 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i3111111111111111111113 & 7168) | (57344 & i3111111111111111111112) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function21 = function19;
                    paddingValues3 = paddingValues2;
                    function22 = function16;
                    textFieldColors2 = textFieldColorsColors;
                    function23 = function12;
                    function24 = function17;
                    function25 = function20;
                    function26 = function18;
                    function27 = function15;
                    function28 = function11;
                    z6 = z5;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda11111111110 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i3111111111111111111115) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i3111111111111111111115 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i3111111111111111111115, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda11111111110;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    } else {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda11111111111 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i3111111111111111111115) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i3111111111111111111115 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i3111111111111111111115, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda11111111111;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                    }
                    int i3111111111111111111115 = i4 << 3;
                    int i3111111111111111111116 = i4 >> 3;
                    int i3111111111111111111117 = i4 >> 9;
                    int i3111111111111111111118 = i33 << 21;
                    TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i3111111111111111111115 & 896) | (i3111111111111111111115 & 112) | 6 | (i3111111111111111111116 & 7168) | (i3111111111111111111117 & 57344) | (i3111111111111111111117 & 458752) | (i3111111111111111111117 & 3670016) | (i3111111111111111111118 & 29360128) | (i3111111111111111111118 & 234881024) | (i3111111111111111111118 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i3111111111111111111117 & 7168) | (57344 & i3111111111111111111116) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function21 = function19;
                    paddingValues3 = paddingValues2;
                    function22 = function16;
                    textFieldColors2 = textFieldColorsColors;
                    function23 = function12;
                    function24 = function17;
                    function25 = function20;
                    function26 = function18;
                    function27 = function15;
                    function28 = function11;
                    z6 = z5;
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

                        public final void invoke(Composer composer2, int i3111111111111111111119) {
                            OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i26 |= 384;
            i29 = i3 & Fields.Shape;
            if (i29 != 0) {
                if ((i2 & 3072) == 0) {
                    if (!composerStartRestartGroup.changedInstance(function9)) {
                        i7 = 1024;
                    }
                    i26 |= i7;
                }
                if ((i2 & 24576) != 0) {
                    if ((i3 & Fields.Clip) == 0) {
                        i10 = 16384;
                    }
                    i26 |= i10;
                }
                if ((i2 & 196608) != 0) {
                    if ((i3 & Fields.CompositingStrategy) == 0) {
                        i34 = 65536;
                    } else {
                        i34 = 65536;
                    }
                    i26 |= i34;
                }
                i30 = i3 & 65536;
                if (i30 != 0) {
                    i26 |= 1572864;
                } else if ((i2 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function10)) {
                        i31 = 1048576;
                    } else {
                        i31 = 524288;
                    }
                    i26 |= i31;
                }
                if ((i3 & Fields.RenderEffect) != 0) {
                    i26 |= 12582912;
                } else if ((i2 & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(this)) {
                        i32 = 8388608;
                    } else {
                        i32 = 4194304;
                    }
                    i26 |= i32;
                }
                if ((i4 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda11111111112 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i3111111111111111111119) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i3111111111111111111119 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i3111111111111111111119, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda11111111112;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    } else {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda11111111113 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i3111111111111111111119) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i3111111111111111111119 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i3111111111111111111119, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda11111111113;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                    }
                    int i3111111111111111111119 = i4 << 3;
                    int i31111111111111111111110 = i4 >> 3;
                    int i31111111111111111111111 = i4 >> 9;
                    int i31111111111111111111112 = i33 << 21;
                    TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i3111111111111111111119 & 896) | (i3111111111111111111119 & 112) | 6 | (i31111111111111111111110 & 7168) | (i31111111111111111111111 & 57344) | (i31111111111111111111111 & 458752) | (i31111111111111111111111 & 3670016) | (i31111111111111111111112 & 29360128) | (i31111111111111111111112 & 234881024) | (i31111111111111111111112 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i31111111111111111111111 & 7168) | (57344 & i31111111111111111111110) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function21 = function19;
                    paddingValues3 = paddingValues2;
                    function22 = function16;
                    textFieldColors2 = textFieldColorsColors;
                    function23 = function12;
                    function24 = function17;
                    function25 = function20;
                    function26 = function18;
                    function27 = function15;
                    function28 = function11;
                    z6 = z5;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda11111111114 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i31111111111111111111113) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i31111111111111111111113 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i31111111111111111111113, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda11111111114;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    } else {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda11111111115 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i31111111111111111111113) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i31111111111111111111113 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i31111111111111111111113, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda11111111115;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                    }
                    int i31111111111111111111113 = i4 << 3;
                    int i31111111111111111111114 = i4 >> 3;
                    int i31111111111111111111115 = i4 >> 9;
                    int i31111111111111111111116 = i33 << 21;
                    TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i31111111111111111111113 & 896) | (i31111111111111111111113 & 112) | 6 | (i31111111111111111111114 & 7168) | (i31111111111111111111115 & 57344) | (i31111111111111111111115 & 458752) | (i31111111111111111111115 & 3670016) | (i31111111111111111111116 & 29360128) | (i31111111111111111111116 & 234881024) | (i31111111111111111111116 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i31111111111111111111115 & 7168) | (57344 & i31111111111111111111114) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function21 = function19;
                    paddingValues3 = paddingValues2;
                    function22 = function16;
                    textFieldColors2 = textFieldColorsColors;
                    function23 = function12;
                    function24 = function17;
                    function25 = function20;
                    function26 = function18;
                    function27 = function15;
                    function28 = function11;
                    z6 = z5;
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

                        public final void invoke(Composer composer2, int i31111111111111111111117) {
                            OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i26 |= 3072;
            if ((i2 & 24576) != 0) {
                if ((i3 & Fields.Clip) == 0) {
                    i10 = 16384;
                }
                i26 |= i10;
            }
            if ((i2 & 196608) != 0) {
                if ((i3 & Fields.CompositingStrategy) == 0) {
                    i34 = 65536;
                } else {
                    i34 = 65536;
                }
                i26 |= i34;
            }
            i30 = i3 & 65536;
            if (i30 != 0) {
                i26 |= 1572864;
            } else if ((i2 & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function10)) {
                    i31 = 1048576;
                } else {
                    i31 = 524288;
                }
                i26 |= i31;
            }
            if ((i3 & Fields.RenderEffect) != 0) {
                i26 |= 12582912;
            } else if ((i2 & 12582912) == 0) {
                if (composerStartRestartGroup.changed(this)) {
                    i32 = 8388608;
                } else {
                    i32 = 4194304;
                }
                i26 |= i32;
            }
            if ((i4 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        z4 = false;
                    } else {
                        z4 = z3;
                    }
                    if (i15 != 0) {
                        function11 = null;
                    } else {
                        function11 = function3;
                    }
                    if (i17 != 0) {
                        function12 = null;
                    } else {
                        function12 = function4;
                    }
                    if (i19 != 0) {
                        function13 = null;
                    } else {
                        function13 = function5;
                    }
                    if (i21 != 0) {
                        function14 = null;
                    } else {
                        function14 = function6;
                    }
                    if (i24 != 0) {
                        function15 = null;
                    } else {
                        function15 = function7;
                    }
                    if (i27 != 0) {
                        function16 = null;
                    } else {
                        function16 = function8;
                    }
                    if (i29 == 0) {
                    }
                    if ((i3 & Fields.Clip) != 0) {
                        textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                        i26 &= -57345;
                    } else {
                        textFieldColorsColors = textFieldColors;
                    }
                    if ((i3 & Fields.CompositingStrategy) != 0) {
                        paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                        i26 &= -458753;
                    } else {
                        paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                    }
                    function18 = function13;
                    if (i30 != 0) {
                        ComposableLambda composableLambdaRememberComposableLambda11111111116 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i31111111111111111111117) {
                                ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                if ((i31111111111111111111117 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1448570018, i31111111111111111111117, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                    }
                                    OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        function15 = function15;
                        function19 = function14;
                        function20 = composableLambdaRememberComposableLambda11111111116;
                    } else {
                        function19 = function14;
                        function20 = function10;
                    }
                    i33 = i26;
                    z5 = z4;
                    paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                } else {
                    if (i13 != 0) {
                        z4 = false;
                    } else {
                        z4 = z3;
                    }
                    if (i15 != 0) {
                        function11 = null;
                    } else {
                        function11 = function3;
                    }
                    if (i17 != 0) {
                        function12 = null;
                    } else {
                        function12 = function4;
                    }
                    if (i19 != 0) {
                        function13 = null;
                    } else {
                        function13 = function5;
                    }
                    if (i21 != 0) {
                        function14 = null;
                    } else {
                        function14 = function6;
                    }
                    if (i24 != 0) {
                        function15 = null;
                    } else {
                        function15 = function7;
                    }
                    if (i27 != 0) {
                        function16 = null;
                    } else {
                        function16 = function8;
                    }
                    if (i29 == 0) {
                    }
                    if ((i3 & Fields.Clip) != 0) {
                        textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                        i26 &= -57345;
                    } else {
                        textFieldColorsColors = textFieldColors;
                    }
                    if ((i3 & Fields.CompositingStrategy) != 0) {
                        paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                        i26 &= -458753;
                    } else {
                        paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                    }
                    function18 = function13;
                    if (i30 != 0) {
                        ComposableLambda composableLambdaRememberComposableLambda11111111117 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i31111111111111111111117) {
                                ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                if ((i31111111111111111111117 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1448570018, i31111111111111111111117, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                    }
                                    OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        function15 = function15;
                        function19 = function14;
                        function20 = composableLambdaRememberComposableLambda11111111117;
                    } else {
                        function19 = function14;
                        function20 = function10;
                    }
                    i33 = i26;
                    z5 = z4;
                    paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                }
                int i31111111111111111111117 = i4 << 3;
                int i31111111111111111111118 = i4 >> 3;
                int i31111111111111111111119 = i4 >> 9;
                int i311111111111111111111110 = i33 << 21;
                TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i31111111111111111111117 & 896) | (i31111111111111111111117 & 112) | 6 | (i31111111111111111111118 & 7168) | (i31111111111111111111119 & 57344) | (i31111111111111111111119 & 458752) | (i31111111111111111111119 & 3670016) | (i311111111111111111111110 & 29360128) | (i311111111111111111111110 & 234881024) | (i311111111111111111111110 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i31111111111111111111119 & 7168) | (57344 & i31111111111111111111118) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function21 = function19;
                paddingValues3 = paddingValues2;
                function22 = function16;
                textFieldColors2 = textFieldColorsColors;
                function23 = function12;
                function24 = function17;
                function25 = function20;
                function26 = function18;
                function27 = function15;
                function28 = function11;
                z6 = z5;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        z4 = false;
                    } else {
                        z4 = z3;
                    }
                    if (i15 != 0) {
                        function11 = null;
                    } else {
                        function11 = function3;
                    }
                    if (i17 != 0) {
                        function12 = null;
                    } else {
                        function12 = function4;
                    }
                    if (i19 != 0) {
                        function13 = null;
                    } else {
                        function13 = function5;
                    }
                    if (i21 != 0) {
                        function14 = null;
                    } else {
                        function14 = function6;
                    }
                    if (i24 != 0) {
                        function15 = null;
                    } else {
                        function15 = function7;
                    }
                    if (i27 != 0) {
                        function16 = null;
                    } else {
                        function16 = function8;
                    }
                    if (i29 == 0) {
                    }
                    if ((i3 & Fields.Clip) != 0) {
                        textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                        i26 &= -57345;
                    } else {
                        textFieldColorsColors = textFieldColors;
                    }
                    if ((i3 & Fields.CompositingStrategy) != 0) {
                        paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                        i26 &= -458753;
                    } else {
                        paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                    }
                    function18 = function13;
                    if (i30 != 0) {
                        ComposableLambda composableLambdaRememberComposableLambda11111111118 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i311111111111111111111111) {
                                ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                if ((i311111111111111111111111 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1448570018, i311111111111111111111111, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                    }
                                    OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        function15 = function15;
                        function19 = function14;
                        function20 = composableLambdaRememberComposableLambda11111111118;
                    } else {
                        function19 = function14;
                        function20 = function10;
                    }
                    i33 = i26;
                    z5 = z4;
                    paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                } else {
                    if (i13 != 0) {
                        z4 = false;
                    } else {
                        z4 = z3;
                    }
                    if (i15 != 0) {
                        function11 = null;
                    } else {
                        function11 = function3;
                    }
                    if (i17 != 0) {
                        function12 = null;
                    } else {
                        function12 = function4;
                    }
                    if (i19 != 0) {
                        function13 = null;
                    } else {
                        function13 = function5;
                    }
                    if (i21 != 0) {
                        function14 = null;
                    } else {
                        function14 = function6;
                    }
                    if (i24 != 0) {
                        function15 = null;
                    } else {
                        function15 = function7;
                    }
                    if (i27 != 0) {
                        function16 = null;
                    } else {
                        function16 = function8;
                    }
                    if (i29 == 0) {
                    }
                    if ((i3 & Fields.Clip) != 0) {
                        textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                        i26 &= -57345;
                    } else {
                        textFieldColorsColors = textFieldColors;
                    }
                    if ((i3 & Fields.CompositingStrategy) != 0) {
                        paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                        i26 &= -458753;
                    } else {
                        paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                    }
                    function18 = function13;
                    if (i30 != 0) {
                        ComposableLambda composableLambdaRememberComposableLambda11111111119 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i311111111111111111111111) {
                                ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                if ((i311111111111111111111111 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1448570018, i311111111111111111111111, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                    }
                                    OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        function15 = function15;
                        function19 = function14;
                        function20 = composableLambdaRememberComposableLambda11111111119;
                    } else {
                        function19 = function14;
                        function20 = function10;
                    }
                    i33 = i26;
                    z5 = z4;
                    paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                }
                int i311111111111111111111111 = i4 << 3;
                int i311111111111111111111112 = i4 >> 3;
                int i311111111111111111111113 = i4 >> 9;
                int i311111111111111111111114 = i33 << 21;
                TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i311111111111111111111111 & 896) | (i311111111111111111111111 & 112) | 6 | (i311111111111111111111112 & 7168) | (i311111111111111111111113 & 57344) | (i311111111111111111111113 & 458752) | (i311111111111111111111113 & 3670016) | (i311111111111111111111114 & 29360128) | (i311111111111111111111114 & 234881024) | (i311111111111111111111114 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i311111111111111111111113 & 7168) | (57344 & i311111111111111111111112) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function21 = function19;
                paddingValues3 = paddingValues2;
                function22 = function16;
                textFieldColors2 = textFieldColorsColors;
                function23 = function12;
                function24 = function17;
                function25 = function20;
                function26 = function18;
                function27 = function15;
                function28 = function11;
                z6 = z5;
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

                    public final void invoke(Composer composer2, int i311111111111111111111115) {
                        OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                    }
                });
            }
        }
        i4 |= 24576;
        if ((i3 & 32) != 0) {
            i4 |= 196608;
        } else if ((i & 196608) == 0) {
            if (composerStartRestartGroup.changed(interactionSource)) {
                i12 = 131072;
            } else {
                i12 = 65536;
            }
            i4 |= i12;
        }
        i13 = i3 & 64;
        if (i13 != 0) {
            i4 |= 1572864;
        } else if ((i & 1572864) == 0) {
            if (composerStartRestartGroup.changed(z3)) {
                i14 = 1048576;
            } else {
                i14 = 524288;
            }
            i4 |= i14;
        }
        i15 = i3 & Fields.SpotShadowColor;
        if (i15 != 0) {
            i4 |= 12582912;
        } else if ((i & 12582912) == 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i16 = 8388608;
            } else {
                i16 = 4194304;
            }
            i4 |= i16;
        }
        i17 = i3 & Fields.RotationX;
        if (i17 != 0) {
            i4 |= 100663296;
        } else if ((i & 100663296) == 0) {
            if (composerStartRestartGroup.changedInstance(function4)) {
                i18 = 67108864;
            } else {
                i18 = 33554432;
            }
            i4 |= i18;
        }
        i19 = i3 & Fields.RotationY;
        if (i19 != 0) {
            i4 |= 805306368;
        } else if ((i & 805306368) == 0) {
            if (composerStartRestartGroup.changedInstance(function5)) {
                i20 = 536870912;
            } else {
                i20 = 268435456;
            }
            i4 |= i20;
        }
        i21 = i3 & Fields.RotationZ;
        if (i21 != 0) {
            i22 = i2 | 6;
        } else if ((i2 & 6) == 0) {
            if (composerStartRestartGroup.changedInstance(function6)) {
                i23 = 4;
            } else {
                i23 = 2;
            }
            i22 = i2 | i23;
        } else {
            i22 = i2;
        }
        i24 = i3 & Fields.CameraDistance;
        if (i24 != 0) {
            i22 |= 48;
        } else if ((i2 & 48) == 0) {
            if (composerStartRestartGroup.changedInstance(function7)) {
                i25 = 32;
            } else {
                i25 = 16;
            }
            i22 |= i25;
        }
        i26 = i22;
        i27 = i3 & Fields.TransformOrigin;
        if (i27 != 0) {
            if ((i2 & 384) == 0) {
                if (composerStartRestartGroup.changedInstance(function8)) {
                    i28 = Fields.RotationX;
                } else {
                    i28 = 128;
                }
                i26 |= i28;
            }
            i29 = i3 & Fields.Shape;
            if (i29 != 0) {
                if ((i2 & 3072) == 0) {
                    if (!composerStartRestartGroup.changedInstance(function9)) {
                        i7 = 1024;
                    }
                    i26 |= i7;
                }
                if ((i2 & 24576) != 0) {
                    if ((i3 & Fields.Clip) == 0) {
                        i10 = 16384;
                    }
                    i26 |= i10;
                }
                if ((i2 & 196608) != 0) {
                    if ((i3 & Fields.CompositingStrategy) == 0) {
                        i34 = 65536;
                    } else {
                        i34 = 65536;
                    }
                    i26 |= i34;
                }
                i30 = i3 & 65536;
                if (i30 != 0) {
                    i26 |= 1572864;
                } else if ((i2 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function10)) {
                        i31 = 1048576;
                    } else {
                        i31 = 524288;
                    }
                    i26 |= i31;
                }
                if ((i3 & Fields.RenderEffect) != 0) {
                    i26 |= 12582912;
                } else if ((i2 & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(this)) {
                        i32 = 8388608;
                    } else {
                        i32 = 4194304;
                    }
                    i26 |= i32;
                }
                if ((i4 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda111111111110 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i311111111111111111111115) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i311111111111111111111115 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i311111111111111111111115, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda111111111110;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    } else {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda111111111111 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i311111111111111111111115) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i311111111111111111111115 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i311111111111111111111115, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda111111111111;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                    }
                    int i311111111111111111111115 = i4 << 3;
                    int i311111111111111111111116 = i4 >> 3;
                    int i311111111111111111111117 = i4 >> 9;
                    int i311111111111111111111118 = i33 << 21;
                    TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i311111111111111111111115 & 896) | (i311111111111111111111115 & 112) | 6 | (i311111111111111111111116 & 7168) | (i311111111111111111111117 & 57344) | (i311111111111111111111117 & 458752) | (i311111111111111111111117 & 3670016) | (i311111111111111111111118 & 29360128) | (i311111111111111111111118 & 234881024) | (i311111111111111111111118 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i311111111111111111111117 & 7168) | (57344 & i311111111111111111111116) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function21 = function19;
                    paddingValues3 = paddingValues2;
                    function22 = function16;
                    textFieldColors2 = textFieldColorsColors;
                    function23 = function12;
                    function24 = function17;
                    function25 = function20;
                    function26 = function18;
                    function27 = function15;
                    function28 = function11;
                    z6 = z5;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda111111111112 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i311111111111111111111119) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i311111111111111111111119 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i311111111111111111111119, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda111111111112;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    } else {
                        if (i13 != 0) {
                            z4 = false;
                        } else {
                            z4 = z3;
                        }
                        if (i15 != 0) {
                            function11 = null;
                        } else {
                            function11 = function3;
                        }
                        if (i17 != 0) {
                            function12 = null;
                        } else {
                            function12 = function4;
                        }
                        if (i19 != 0) {
                            function13 = null;
                        } else {
                            function13 = function5;
                        }
                        if (i21 != 0) {
                            function14 = null;
                        } else {
                            function14 = function6;
                        }
                        if (i24 != 0) {
                            function15 = null;
                        } else {
                            function15 = function7;
                        }
                        if (i27 != 0) {
                            function16 = null;
                        } else {
                            function16 = function8;
                        }
                        if (i29 == 0) {
                        }
                        if ((i3 & Fields.Clip) != 0) {
                            textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                            i26 &= -57345;
                        } else {
                            textFieldColorsColors = textFieldColors;
                        }
                        if ((i3 & Fields.CompositingStrategy) != 0) {
                            paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                            i26 &= -458753;
                        } else {
                            paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                        }
                        function18 = function13;
                        if (i30 != 0) {
                            ComposableLambda composableLambdaRememberComposableLambda111111111113 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i311111111111111111111119) {
                                    ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                    if ((i311111111111111111111119 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1448570018, i311111111111111111111119, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                        }
                                        OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            function15 = function15;
                            function19 = function14;
                            function20 = composableLambdaRememberComposableLambda111111111113;
                        } else {
                            function19 = function14;
                            function20 = function10;
                        }
                        i33 = i26;
                        z5 = z4;
                        paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                    }
                    int i311111111111111111111119 = i4 << 3;
                    int i3111111111111111111111110 = i4 >> 3;
                    int i3111111111111111111111111 = i4 >> 9;
                    int i3111111111111111111111112 = i33 << 21;
                    TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i311111111111111111111119 & 896) | (i311111111111111111111119 & 112) | 6 | (i3111111111111111111111110 & 7168) | (i3111111111111111111111111 & 57344) | (i3111111111111111111111111 & 458752) | (i3111111111111111111111111 & 3670016) | (i3111111111111111111111112 & 29360128) | (i3111111111111111111111112 & 234881024) | (i3111111111111111111111112 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i3111111111111111111111111 & 7168) | (57344 & i3111111111111111111111110) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function21 = function19;
                    paddingValues3 = paddingValues2;
                    function22 = function16;
                    textFieldColors2 = textFieldColorsColors;
                    function23 = function12;
                    function24 = function17;
                    function25 = function20;
                    function26 = function18;
                    function27 = function15;
                    function28 = function11;
                    z6 = z5;
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

                        public final void invoke(Composer composer2, int i3111111111111111111111113) {
                            OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i26 |= 3072;
            if ((i2 & 24576) != 0) {
                if ((i3 & Fields.Clip) == 0) {
                    i10 = 16384;
                }
                i26 |= i10;
            }
            if ((i2 & 196608) != 0) {
                if ((i3 & Fields.CompositingStrategy) == 0) {
                    i34 = 65536;
                } else {
                    i34 = 65536;
                }
                i26 |= i34;
            }
            i30 = i3 & 65536;
            if (i30 != 0) {
                i26 |= 1572864;
            } else if ((i2 & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function10)) {
                    i31 = 1048576;
                } else {
                    i31 = 524288;
                }
                i26 |= i31;
            }
            if ((i3 & Fields.RenderEffect) != 0) {
                i26 |= 12582912;
            } else if ((i2 & 12582912) == 0) {
                if (composerStartRestartGroup.changed(this)) {
                    i32 = 8388608;
                } else {
                    i32 = 4194304;
                }
                i26 |= i32;
            }
            if ((i4 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        z4 = false;
                    } else {
                        z4 = z3;
                    }
                    if (i15 != 0) {
                        function11 = null;
                    } else {
                        function11 = function3;
                    }
                    if (i17 != 0) {
                        function12 = null;
                    } else {
                        function12 = function4;
                    }
                    if (i19 != 0) {
                        function13 = null;
                    } else {
                        function13 = function5;
                    }
                    if (i21 != 0) {
                        function14 = null;
                    } else {
                        function14 = function6;
                    }
                    if (i24 != 0) {
                        function15 = null;
                    } else {
                        function15 = function7;
                    }
                    if (i27 != 0) {
                        function16 = null;
                    } else {
                        function16 = function8;
                    }
                    if (i29 == 0) {
                    }
                    if ((i3 & Fields.Clip) != 0) {
                        textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                        i26 &= -57345;
                    } else {
                        textFieldColorsColors = textFieldColors;
                    }
                    if ((i3 & Fields.CompositingStrategy) != 0) {
                        paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                        i26 &= -458753;
                    } else {
                        paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                    }
                    function18 = function13;
                    if (i30 != 0) {
                        ComposableLambda composableLambdaRememberComposableLambda111111111114 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i3111111111111111111111113) {
                                ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                if ((i3111111111111111111111113 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1448570018, i3111111111111111111111113, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                    }
                                    OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        function15 = function15;
                        function19 = function14;
                        function20 = composableLambdaRememberComposableLambda111111111114;
                    } else {
                        function19 = function14;
                        function20 = function10;
                    }
                    i33 = i26;
                    z5 = z4;
                    paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                } else {
                    if (i13 != 0) {
                        z4 = false;
                    } else {
                        z4 = z3;
                    }
                    if (i15 != 0) {
                        function11 = null;
                    } else {
                        function11 = function3;
                    }
                    if (i17 != 0) {
                        function12 = null;
                    } else {
                        function12 = function4;
                    }
                    if (i19 != 0) {
                        function13 = null;
                    } else {
                        function13 = function5;
                    }
                    if (i21 != 0) {
                        function14 = null;
                    } else {
                        function14 = function6;
                    }
                    if (i24 != 0) {
                        function15 = null;
                    } else {
                        function15 = function7;
                    }
                    if (i27 != 0) {
                        function16 = null;
                    } else {
                        function16 = function8;
                    }
                    if (i29 == 0) {
                    }
                    if ((i3 & Fields.Clip) != 0) {
                        textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                        i26 &= -57345;
                    } else {
                        textFieldColorsColors = textFieldColors;
                    }
                    if ((i3 & Fields.CompositingStrategy) != 0) {
                        paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                        i26 &= -458753;
                    } else {
                        paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                    }
                    function18 = function13;
                    if (i30 != 0) {
                        ComposableLambda composableLambdaRememberComposableLambda111111111115 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i3111111111111111111111113) {
                                ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                if ((i3111111111111111111111113 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1448570018, i3111111111111111111111113, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                    }
                                    OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        function15 = function15;
                        function19 = function14;
                        function20 = composableLambdaRememberComposableLambda111111111115;
                    } else {
                        function19 = function14;
                        function20 = function10;
                    }
                    i33 = i26;
                    z5 = z4;
                    paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                }
                int i3111111111111111111111113 = i4 << 3;
                int i3111111111111111111111114 = i4 >> 3;
                int i3111111111111111111111115 = i4 >> 9;
                int i3111111111111111111111116 = i33 << 21;
                TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i3111111111111111111111113 & 896) | (i3111111111111111111111113 & 112) | 6 | (i3111111111111111111111114 & 7168) | (i3111111111111111111111115 & 57344) | (i3111111111111111111111115 & 458752) | (i3111111111111111111111115 & 3670016) | (i3111111111111111111111116 & 29360128) | (i3111111111111111111111116 & 234881024) | (i3111111111111111111111116 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i3111111111111111111111115 & 7168) | (57344 & i3111111111111111111111114) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function21 = function19;
                paddingValues3 = paddingValues2;
                function22 = function16;
                textFieldColors2 = textFieldColorsColors;
                function23 = function12;
                function24 = function17;
                function25 = function20;
                function26 = function18;
                function27 = function15;
                function28 = function11;
                z6 = z5;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        z4 = false;
                    } else {
                        z4 = z3;
                    }
                    if (i15 != 0) {
                        function11 = null;
                    } else {
                        function11 = function3;
                    }
                    if (i17 != 0) {
                        function12 = null;
                    } else {
                        function12 = function4;
                    }
                    if (i19 != 0) {
                        function13 = null;
                    } else {
                        function13 = function5;
                    }
                    if (i21 != 0) {
                        function14 = null;
                    } else {
                        function14 = function6;
                    }
                    if (i24 != 0) {
                        function15 = null;
                    } else {
                        function15 = function7;
                    }
                    if (i27 != 0) {
                        function16 = null;
                    } else {
                        function16 = function8;
                    }
                    if (i29 == 0) {
                    }
                    if ((i3 & Fields.Clip) != 0) {
                        textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                        i26 &= -57345;
                    } else {
                        textFieldColorsColors = textFieldColors;
                    }
                    if ((i3 & Fields.CompositingStrategy) != 0) {
                        paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                        i26 &= -458753;
                    } else {
                        paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                    }
                    function18 = function13;
                    if (i30 != 0) {
                        ComposableLambda composableLambdaRememberComposableLambda111111111116 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i3111111111111111111111117) {
                                ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                if ((i3111111111111111111111117 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1448570018, i3111111111111111111111117, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                    }
                                    OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        function15 = function15;
                        function19 = function14;
                        function20 = composableLambdaRememberComposableLambda111111111116;
                    } else {
                        function19 = function14;
                        function20 = function10;
                    }
                    i33 = i26;
                    z5 = z4;
                    paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                } else {
                    if (i13 != 0) {
                        z4 = false;
                    } else {
                        z4 = z3;
                    }
                    if (i15 != 0) {
                        function11 = null;
                    } else {
                        function11 = function3;
                    }
                    if (i17 != 0) {
                        function12 = null;
                    } else {
                        function12 = function4;
                    }
                    if (i19 != 0) {
                        function13 = null;
                    } else {
                        function13 = function5;
                    }
                    if (i21 != 0) {
                        function14 = null;
                    } else {
                        function14 = function6;
                    }
                    if (i24 != 0) {
                        function15 = null;
                    } else {
                        function15 = function7;
                    }
                    if (i27 != 0) {
                        function16 = null;
                    } else {
                        function16 = function8;
                    }
                    if (i29 == 0) {
                    }
                    if ((i3 & Fields.Clip) != 0) {
                        textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                        i26 &= -57345;
                    } else {
                        textFieldColorsColors = textFieldColors;
                    }
                    if ((i3 & Fields.CompositingStrategy) != 0) {
                        paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                        i26 &= -458753;
                    } else {
                        paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                    }
                    function18 = function13;
                    if (i30 != 0) {
                        ComposableLambda composableLambdaRememberComposableLambda111111111117 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i3111111111111111111111117) {
                                ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                if ((i3111111111111111111111117 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1448570018, i3111111111111111111111117, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                    }
                                    OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        function15 = function15;
                        function19 = function14;
                        function20 = composableLambdaRememberComposableLambda111111111117;
                    } else {
                        function19 = function14;
                        function20 = function10;
                    }
                    i33 = i26;
                    z5 = z4;
                    paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                }
                int i3111111111111111111111117 = i4 << 3;
                int i3111111111111111111111118 = i4 >> 3;
                int i3111111111111111111111119 = i4 >> 9;
                int i31111111111111111111111110 = i33 << 21;
                TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i3111111111111111111111117 & 896) | (i3111111111111111111111117 & 112) | 6 | (i3111111111111111111111118 & 7168) | (i3111111111111111111111119 & 57344) | (i3111111111111111111111119 & 458752) | (i3111111111111111111111119 & 3670016) | (i31111111111111111111111110 & 29360128) | (i31111111111111111111111110 & 234881024) | (i31111111111111111111111110 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i3111111111111111111111119 & 7168) | (57344 & i3111111111111111111111118) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function21 = function19;
                paddingValues3 = paddingValues2;
                function22 = function16;
                textFieldColors2 = textFieldColorsColors;
                function23 = function12;
                function24 = function17;
                function25 = function20;
                function26 = function18;
                function27 = function15;
                function28 = function11;
                z6 = z5;
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

                    public final void invoke(Composer composer2, int i31111111111111111111111111) {
                        OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                    }
                });
            }
        }
        i26 |= 384;
        i29 = i3 & Fields.Shape;
        if (i29 != 0) {
            if ((i2 & 3072) == 0) {
                if (!composerStartRestartGroup.changedInstance(function9)) {
                    i7 = 1024;
                }
                i26 |= i7;
            }
            if ((i2 & 24576) != 0) {
                if ((i3 & Fields.Clip) == 0) {
                    i10 = 16384;
                }
                i26 |= i10;
            }
            if ((i2 & 196608) != 0) {
                if ((i3 & Fields.CompositingStrategy) == 0) {
                    i34 = 65536;
                } else {
                    i34 = 65536;
                }
                i26 |= i34;
            }
            i30 = i3 & 65536;
            if (i30 != 0) {
                i26 |= 1572864;
            } else if ((i2 & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function10)) {
                    i31 = 1048576;
                } else {
                    i31 = 524288;
                }
                i26 |= i31;
            }
            if ((i3 & Fields.RenderEffect) != 0) {
                i26 |= 12582912;
            } else if ((i2 & 12582912) == 0) {
                if (composerStartRestartGroup.changed(this)) {
                    i32 = 8388608;
                } else {
                    i32 = 4194304;
                }
                i26 |= i32;
            }
            if ((i4 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        z4 = false;
                    } else {
                        z4 = z3;
                    }
                    if (i15 != 0) {
                        function11 = null;
                    } else {
                        function11 = function3;
                    }
                    if (i17 != 0) {
                        function12 = null;
                    } else {
                        function12 = function4;
                    }
                    if (i19 != 0) {
                        function13 = null;
                    } else {
                        function13 = function5;
                    }
                    if (i21 != 0) {
                        function14 = null;
                    } else {
                        function14 = function6;
                    }
                    if (i24 != 0) {
                        function15 = null;
                    } else {
                        function15 = function7;
                    }
                    if (i27 != 0) {
                        function16 = null;
                    } else {
                        function16 = function8;
                    }
                    if (i29 == 0) {
                    }
                    if ((i3 & Fields.Clip) != 0) {
                        textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                        i26 &= -57345;
                    } else {
                        textFieldColorsColors = textFieldColors;
                    }
                    if ((i3 & Fields.CompositingStrategy) != 0) {
                        paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                        i26 &= -458753;
                    } else {
                        paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                    }
                    function18 = function13;
                    if (i30 != 0) {
                        ComposableLambda composableLambdaRememberComposableLambda111111111118 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i31111111111111111111111111) {
                                ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                if ((i31111111111111111111111111 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1448570018, i31111111111111111111111111, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                    }
                                    OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        function15 = function15;
                        function19 = function14;
                        function20 = composableLambdaRememberComposableLambda111111111118;
                    } else {
                        function19 = function14;
                        function20 = function10;
                    }
                    i33 = i26;
                    z5 = z4;
                    paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                } else {
                    if (i13 != 0) {
                        z4 = false;
                    } else {
                        z4 = z3;
                    }
                    if (i15 != 0) {
                        function11 = null;
                    } else {
                        function11 = function3;
                    }
                    if (i17 != 0) {
                        function12 = null;
                    } else {
                        function12 = function4;
                    }
                    if (i19 != 0) {
                        function13 = null;
                    } else {
                        function13 = function5;
                    }
                    if (i21 != 0) {
                        function14 = null;
                    } else {
                        function14 = function6;
                    }
                    if (i24 != 0) {
                        function15 = null;
                    } else {
                        function15 = function7;
                    }
                    if (i27 != 0) {
                        function16 = null;
                    } else {
                        function16 = function8;
                    }
                    if (i29 == 0) {
                    }
                    if ((i3 & Fields.Clip) != 0) {
                        textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                        i26 &= -57345;
                    } else {
                        textFieldColorsColors = textFieldColors;
                    }
                    if ((i3 & Fields.CompositingStrategy) != 0) {
                        paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                        i26 &= -458753;
                    } else {
                        paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                    }
                    function18 = function13;
                    if (i30 != 0) {
                        ComposableLambda composableLambdaRememberComposableLambda111111111119 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i31111111111111111111111111) {
                                ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                if ((i31111111111111111111111111 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1448570018, i31111111111111111111111111, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                    }
                                    OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        function15 = function15;
                        function19 = function14;
                        function20 = composableLambdaRememberComposableLambda111111111119;
                    } else {
                        function19 = function14;
                        function20 = function10;
                    }
                    i33 = i26;
                    z5 = z4;
                    paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                }
                int i31111111111111111111111111 = i4 << 3;
                int i31111111111111111111111112 = i4 >> 3;
                int i31111111111111111111111113 = i4 >> 9;
                int i31111111111111111111111114 = i33 << 21;
                TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i31111111111111111111111111 & 896) | (i31111111111111111111111111 & 112) | 6 | (i31111111111111111111111112 & 7168) | (i31111111111111111111111113 & 57344) | (i31111111111111111111111113 & 458752) | (i31111111111111111111111113 & 3670016) | (i31111111111111111111111114 & 29360128) | (i31111111111111111111111114 & 234881024) | (i31111111111111111111111114 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i31111111111111111111111113 & 7168) | (57344 & i31111111111111111111111112) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function21 = function19;
                paddingValues3 = paddingValues2;
                function22 = function16;
                textFieldColors2 = textFieldColorsColors;
                function23 = function12;
                function24 = function17;
                function25 = function20;
                function26 = function18;
                function27 = function15;
                function28 = function11;
                z6 = z5;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        z4 = false;
                    } else {
                        z4 = z3;
                    }
                    if (i15 != 0) {
                        function11 = null;
                    } else {
                        function11 = function3;
                    }
                    if (i17 != 0) {
                        function12 = null;
                    } else {
                        function12 = function4;
                    }
                    if (i19 != 0) {
                        function13 = null;
                    } else {
                        function13 = function5;
                    }
                    if (i21 != 0) {
                        function14 = null;
                    } else {
                        function14 = function6;
                    }
                    if (i24 != 0) {
                        function15 = null;
                    } else {
                        function15 = function7;
                    }
                    if (i27 != 0) {
                        function16 = null;
                    } else {
                        function16 = function8;
                    }
                    if (i29 == 0) {
                    }
                    if ((i3 & Fields.Clip) != 0) {
                        textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                        i26 &= -57345;
                    } else {
                        textFieldColorsColors = textFieldColors;
                    }
                    if ((i3 & Fields.CompositingStrategy) != 0) {
                        paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                        i26 &= -458753;
                    } else {
                        paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                    }
                    function18 = function13;
                    if (i30 != 0) {
                        ComposableLambda composableLambdaRememberComposableLambda1111111111110 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i31111111111111111111111115) {
                                ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                if ((i31111111111111111111111115 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1448570018, i31111111111111111111111115, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                    }
                                    OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        function15 = function15;
                        function19 = function14;
                        function20 = composableLambdaRememberComposableLambda1111111111110;
                    } else {
                        function19 = function14;
                        function20 = function10;
                    }
                    i33 = i26;
                    z5 = z4;
                    paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                } else {
                    if (i13 != 0) {
                        z4 = false;
                    } else {
                        z4 = z3;
                    }
                    if (i15 != 0) {
                        function11 = null;
                    } else {
                        function11 = function3;
                    }
                    if (i17 != 0) {
                        function12 = null;
                    } else {
                        function12 = function4;
                    }
                    if (i19 != 0) {
                        function13 = null;
                    } else {
                        function13 = function5;
                    }
                    if (i21 != 0) {
                        function14 = null;
                    } else {
                        function14 = function6;
                    }
                    if (i24 != 0) {
                        function15 = null;
                    } else {
                        function15 = function7;
                    }
                    if (i27 != 0) {
                        function16 = null;
                    } else {
                        function16 = function8;
                    }
                    if (i29 == 0) {
                    }
                    if ((i3 & Fields.Clip) != 0) {
                        textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                        i26 &= -57345;
                    } else {
                        textFieldColorsColors = textFieldColors;
                    }
                    if ((i3 & Fields.CompositingStrategy) != 0) {
                        paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                        i26 &= -458753;
                    } else {
                        paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                    }
                    function18 = function13;
                    if (i30 != 0) {
                        ComposableLambda composableLambdaRememberComposableLambda1111111111111 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i31111111111111111111111115) {
                                ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                                if ((i31111111111111111111111115 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1448570018, i31111111111111111111111115, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                    }
                                    OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        function15 = function15;
                        function19 = function14;
                        function20 = composableLambdaRememberComposableLambda1111111111111;
                    } else {
                        function19 = function14;
                        function20 = function10;
                    }
                    i33 = i26;
                    z5 = z4;
                    paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
                }
                int i31111111111111111111111115 = i4 << 3;
                int i31111111111111111111111116 = i4 >> 3;
                int i31111111111111111111111117 = i4 >> 9;
                int i31111111111111111111111118 = i33 << 21;
                TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i31111111111111111111111115 & 896) | (i31111111111111111111111115 & 112) | 6 | (i31111111111111111111111116 & 7168) | (i31111111111111111111111117 & 57344) | (i31111111111111111111111117 & 458752) | (i31111111111111111111111117 & 3670016) | (i31111111111111111111111118 & 29360128) | (i31111111111111111111111118 & 234881024) | (i31111111111111111111111118 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i31111111111111111111111117 & 7168) | (57344 & i31111111111111111111111116) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function21 = function19;
                paddingValues3 = paddingValues2;
                function22 = function16;
                textFieldColors2 = textFieldColorsColors;
                function23 = function12;
                function24 = function17;
                function25 = function20;
                function26 = function18;
                function27 = function15;
                function28 = function11;
                z6 = z5;
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

                    public final void invoke(Composer composer2, int i31111111111111111111111119) {
                        OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                    }
                });
            }
        }
        i26 |= 3072;
        if ((i2 & 24576) != 0) {
            if ((i3 & Fields.Clip) == 0) {
                i10 = 16384;
            }
            i26 |= i10;
        }
        if ((i2 & 196608) != 0) {
            if ((i3 & Fields.CompositingStrategy) == 0) {
                i34 = 65536;
            } else {
                i34 = 65536;
            }
            i26 |= i34;
        }
        i30 = i3 & 65536;
        if (i30 != 0) {
            i26 |= 1572864;
        } else if ((i2 & 1572864) == 0) {
            if (composerStartRestartGroup.changedInstance(function10)) {
                i31 = 1048576;
            } else {
                i31 = 524288;
            }
            i26 |= i31;
        }
        if ((i3 & Fields.RenderEffect) != 0) {
            i26 |= 12582912;
        } else if ((i2 & 12582912) == 0) {
            if (composerStartRestartGroup.changed(this)) {
                i32 = 8388608;
            } else {
                i32 = 4194304;
            }
            i26 |= i32;
        }
        if ((i4 & 306783379) == 306783378) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i13 != 0) {
                    z4 = false;
                } else {
                    z4 = z3;
                }
                if (i15 != 0) {
                    function11 = null;
                } else {
                    function11 = function3;
                }
                if (i17 != 0) {
                    function12 = null;
                } else {
                    function12 = function4;
                }
                if (i19 != 0) {
                    function13 = null;
                } else {
                    function13 = function5;
                }
                if (i21 != 0) {
                    function14 = null;
                } else {
                    function14 = function6;
                }
                if (i24 != 0) {
                    function15 = null;
                } else {
                    function15 = function7;
                }
                if (i27 != 0) {
                    function16 = null;
                } else {
                    function16 = function8;
                }
                if (i29 == 0) {
                }
                if ((i3 & Fields.Clip) != 0) {
                    textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                    i26 &= -57345;
                } else {
                    textFieldColorsColors = textFieldColors;
                }
                if ((i3 & Fields.CompositingStrategy) != 0) {
                    paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                    i26 &= -458753;
                } else {
                    paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                }
                function18 = function13;
                if (i30 != 0) {
                    ComposableLambda composableLambdaRememberComposableLambda1111111111112 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i31111111111111111111111119) {
                            ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                            if ((i31111111111111111111111119 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1448570018, i31111111111111111111111119, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                }
                                OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    function15 = function15;
                    function19 = function14;
                    function20 = composableLambdaRememberComposableLambda1111111111112;
                } else {
                    function19 = function14;
                    function20 = function10;
                }
                i33 = i26;
                z5 = z4;
                paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
            } else {
                if (i13 != 0) {
                    z4 = false;
                } else {
                    z4 = z3;
                }
                if (i15 != 0) {
                    function11 = null;
                } else {
                    function11 = function3;
                }
                if (i17 != 0) {
                    function12 = null;
                } else {
                    function12 = function4;
                }
                if (i19 != 0) {
                    function13 = null;
                } else {
                    function13 = function5;
                }
                if (i21 != 0) {
                    function14 = null;
                } else {
                    function14 = function6;
                }
                if (i24 != 0) {
                    function15 = null;
                } else {
                    function15 = function7;
                }
                if (i27 != 0) {
                    function16 = null;
                } else {
                    function16 = function8;
                }
                if (i29 == 0) {
                }
                if ((i3 & Fields.Clip) != 0) {
                    textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                    i26 &= -57345;
                } else {
                    textFieldColorsColors = textFieldColors;
                }
                if ((i3 & Fields.CompositingStrategy) != 0) {
                    paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                    i26 &= -458753;
                } else {
                    paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                }
                function18 = function13;
                if (i30 != 0) {
                    ComposableLambda composableLambdaRememberComposableLambda1111111111113 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i31111111111111111111111119) {
                            ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                            if ((i31111111111111111111111119 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1448570018, i31111111111111111111111119, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                }
                                OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    function15 = function15;
                    function19 = function14;
                    function20 = composableLambdaRememberComposableLambda1111111111113;
                } else {
                    function19 = function14;
                    function20 = function10;
                }
                i33 = i26;
                z5 = z4;
                paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
            }
            int i31111111111111111111111119 = i4 << 3;
            int i311111111111111111111111110 = i4 >> 3;
            int i311111111111111111111111111 = i4 >> 9;
            int i311111111111111111111111112 = i33 << 21;
            TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i31111111111111111111111119 & 896) | (i31111111111111111111111119 & 112) | 6 | (i311111111111111111111111110 & 7168) | (i311111111111111111111111111 & 57344) | (i311111111111111111111111111 & 458752) | (i311111111111111111111111111 & 3670016) | (i311111111111111111111111112 & 29360128) | (i311111111111111111111111112 & 234881024) | (i311111111111111111111111112 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i311111111111111111111111111 & 7168) | (57344 & i311111111111111111111111110) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            function21 = function19;
            paddingValues3 = paddingValues2;
            function22 = function16;
            textFieldColors2 = textFieldColorsColors;
            function23 = function12;
            function24 = function17;
            function25 = function20;
            function26 = function18;
            function27 = function15;
            function28 = function11;
            z6 = z5;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i13 != 0) {
                    z4 = false;
                } else {
                    z4 = z3;
                }
                if (i15 != 0) {
                    function11 = null;
                } else {
                    function11 = function3;
                }
                if (i17 != 0) {
                    function12 = null;
                } else {
                    function12 = function4;
                }
                if (i19 != 0) {
                    function13 = null;
                } else {
                    function13 = function5;
                }
                if (i21 != 0) {
                    function14 = null;
                } else {
                    function14 = function6;
                }
                if (i24 != 0) {
                    function15 = null;
                } else {
                    function15 = function7;
                }
                if (i27 != 0) {
                    function16 = null;
                } else {
                    function16 = function8;
                }
                if (i29 == 0) {
                }
                if ((i3 & Fields.Clip) != 0) {
                    textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                    i26 &= -57345;
                } else {
                    textFieldColorsColors = textFieldColors;
                }
                if ((i3 & Fields.CompositingStrategy) != 0) {
                    paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                    i26 &= -458753;
                } else {
                    paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                }
                function18 = function13;
                if (i30 != 0) {
                    ComposableLambda composableLambdaRememberComposableLambda1111111111114 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i311111111111111111111111113) {
                            ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                            if ((i311111111111111111111111113 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1448570018, i311111111111111111111111113, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                }
                                OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    function15 = function15;
                    function19 = function14;
                    function20 = composableLambdaRememberComposableLambda1111111111114;
                } else {
                    function19 = function14;
                    function20 = function10;
                }
                i33 = i26;
                z5 = z4;
                paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
            } else {
                if (i13 != 0) {
                    z4 = false;
                } else {
                    z4 = z3;
                }
                if (i15 != 0) {
                    function11 = null;
                } else {
                    function11 = function3;
                }
                if (i17 != 0) {
                    function12 = null;
                } else {
                    function12 = function4;
                }
                if (i19 != 0) {
                    function13 = null;
                } else {
                    function13 = function5;
                }
                if (i21 != 0) {
                    function14 = null;
                } else {
                    function14 = function6;
                }
                if (i24 != 0) {
                    function15 = null;
                } else {
                    function15 = function7;
                }
                if (i27 != 0) {
                    function16 = null;
                } else {
                    function16 = function8;
                }
                if (i29 == 0) {
                }
                if ((i3 & Fields.Clip) != 0) {
                    textFieldColorsColors = colors(composerStartRestartGroup, (i26 >> 21) & 14);
                    i26 &= -57345;
                } else {
                    textFieldColorsColors = textFieldColors;
                }
                if ((i3 & Fields.CompositingStrategy) != 0) {
                    paddingValuesM2645contentPaddinga9UjIt4$default = m2645contentPaddinga9UjIt4$default(this, 0.0f, 0.0f, 0.0f, 0.0f, 15, null);
                    i26 &= -458753;
                } else {
                    paddingValuesM2645contentPaddinga9UjIt4$default = paddingValues;
                }
                function18 = function13;
                if (i30 != 0) {
                    ComposableLambda composableLambdaRememberComposableLambda1111111111115 = ComposableLambdaKt.rememberComposableLambda(-1448570018, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i311111111111111111111111113) {
                            ComposerKt.sourceInformation(composer2, "C879@44918L5,873@44688L384:TextFieldDefaults.kt#uh7d8r");
                            if ((i311111111111111111111111113 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1448570018, i311111111111111111111111113, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox.<anonymous> (TextFieldDefaults.kt:873)");
                                }
                                OutlinedTextFieldDefaults.INSTANCE.m2646Container4EFweAY(z, z4, interactionSource, Modifier.INSTANCE, textFieldColorsColors, OutlinedTextFieldDefaults.INSTANCE.getShape(composer2, 6), OutlinedTextFieldDefaults.INSTANCE.m2650getFocusedBorderThicknessD9Ej5fM(), OutlinedTextFieldDefaults.INSTANCE.m2653getUnfocusedBorderThicknessD9Ej5fM(), composer2, 114822144, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    function15 = function15;
                    function19 = function14;
                    function20 = composableLambdaRememberComposableLambda1111111111115;
                } else {
                    function19 = function14;
                    function20 = function10;
                }
                i33 = i26;
                z5 = z4;
                paddingValues2 = paddingValuesM2645contentPaddinga9UjIt4$default;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-350442135, i4, i33, "androidx.compose.material3.OutlinedTextFieldDefaults.DecorationBox (TextFieldDefaults.kt:884)");
            }
            int i311111111111111111111111113 = i4 << 3;
            int i311111111111111111111111114 = i4 >> 3;
            int i311111111111111111111111115 = i4 >> 9;
            int i311111111111111111111111116 = i33 << 21;
            TextFieldImplKt.CommonDecorationBox(TextFieldType.Outlined, str, function2, visualTransformation, function11, function12, function18, function19, function15, function16, function17, z2, z, z5, interactionSource, paddingValues2, textFieldColorsColors, function20, composerStartRestartGroup, (i311111111111111111111111113 & 896) | (i311111111111111111111111113 & 112) | 6 | (i311111111111111111111111114 & 7168) | (i311111111111111111111111115 & 57344) | (i311111111111111111111111115 & 458752) | (i311111111111111111111111115 & 3670016) | (i311111111111111111111111116 & 29360128) | (i311111111111111111111111116 & 234881024) | (i311111111111111111111111116 & 1879048192), (i4 & 896) | ((i33 >> 9) & 14) | ((i4 >> 6) & 112) | (i311111111111111111111111115 & 7168) | (57344 & i311111111111111111111111114) | (458752 & i33) | ((i33 << 6) & 3670016) | ((i33 << 3) & 29360128), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            function21 = function19;
            paddingValues3 = paddingValues2;
            function22 = function16;
            textFieldColors2 = textFieldColorsColors;
            function23 = function12;
            function24 = function17;
            function25 = function20;
            function26 = function18;
            function27 = function15;
            function28 = function11;
            z6 = z5;
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

                public final void invoke(Composer composer2, int i311111111111111111111111117) {
                    OutlinedTextFieldDefaults.this.DecorationBox(str, function2, z, z2, visualTransformation, interactionSource, z6, function28, function23, function26, function21, function27, function22, function24, textFieldColors2, paddingValues3, function25, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                }
            });
        }
    }

    public static PaddingValues m2645contentPaddinga9UjIt4$default(OutlinedTextFieldDefaults outlinedTextFieldDefaults, float f, float f2, float f3, float f4, int i, Object obj) {
        if ((i & 1) != 0) {
            f = TextFieldImplKt.getTextFieldPadding();
        }
        if ((i & 2) != 0) {
            f2 = TextFieldImplKt.getTextFieldPadding();
        }
        if ((i & 4) != 0) {
            f3 = TextFieldImplKt.getTextFieldPadding();
        }
        if ((i & 8) != 0) {
            f4 = TextFieldImplKt.getTextFieldPadding();
        }
        return outlinedTextFieldDefaults.m2649contentPaddinga9UjIt4(f, f2, f3, f4);
    }

    public final PaddingValues m2649contentPaddinga9UjIt4(float start, float top, float end, float bottom) {
        return PaddingKt.m1031PaddingValuesa9UjIt4(start, top, end, bottom);
    }

    public final TextFieldColors colors(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -471651810, "C(colors)921@46417L11,921@46429L30:TextFieldDefaults.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-471651810, i, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.colors (TextFieldDefaults.kt:921)");
        }
        TextFieldColors defaultOutlinedTextFieldColors = getDefaultOutlinedTextFieldColors(MaterialTheme.INSTANCE.getColorScheme(composer, 6), composer, (i << 3) & 112);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return defaultOutlinedTextFieldColors;
    }

    public final TextFieldColors m2648colors0hiis_0(long j, long j2, long j3, long j4, long j5, long j6, long j7, long j8, long j9, long j10, TextSelectionColors textSelectionColors, long j11, long j12, long j13, long j14, long j15, long j16, long j17, long j18, long j19, long j20, long j21, long j22, long j23, long j24, long j25, long j26, long j27, long j28, long j29, long j30, long j31, long j32, long j33, long j34, long j35, long j36, long j37, long j38, long j39, long j40, long j41, long j42, Composer composer, int i, int i2, int i3, int i4, int i5, int i6, int i7) {
        ComposerKt.sourceInformationMarkerStart(composer, 1767617725, "C(colors)P(30:c#ui.graphics.Color,41:c#ui.graphics.Color,9:c#ui.graphics.Color,20:c#ui.graphics.Color,23:c#ui.graphics.Color,34:c#ui.graphics.Color,2:c#ui.graphics.Color,12:c#ui.graphics.Color,0:c#ui.graphics.Color,13:c#ui.graphics.Color,32,22:c#ui.graphics.Color,33:c#ui.graphics.Color,1:c#ui.graphics.Color,11:c#ui.graphics.Color,25:c#ui.graphics.Color,36:c#ui.graphics.Color,4:c#ui.graphics.Color,15:c#ui.graphics.Color,31:c#ui.graphics.Color,42:c#ui.graphics.Color,10:c#ui.graphics.Color,21:c#ui.graphics.Color,24:c#ui.graphics.Color,35:c#ui.graphics.Color,3:c#ui.graphics.Color,14:c#ui.graphics.Color,26:c#ui.graphics.Color,37:c#ui.graphics.Color,5:c#ui.graphics.Color,16:c#ui.graphics.Color,29:c#ui.graphics.Color,40:c#ui.graphics.Color,8:c#ui.graphics.Color,19:c#ui.graphics.Color,27:c#ui.graphics.Color,38:c#ui.graphics.Color,6:c#ui.graphics.Color,17:c#ui.graphics.Color,28:c#ui.graphics.Color,39:c#ui.graphics.Color,7:c#ui.graphics.Color,18:c#ui.graphics.Color)1023@53240L11,1023@53252L30:TextFieldDefaults.kt#uh7d8r");
        long jM4626getUnspecified0d7_KjU = (i6 & 1) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j;
        long jM4626getUnspecified0d7_KjU2 = (i6 & 2) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j2;
        long jM4626getUnspecified0d7_KjU3 = (i6 & 4) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j3;
        long jM4626getUnspecified0d7_KjU4 = (i6 & 8) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j4;
        long jM4626getUnspecified0d7_KjU5 = (i6 & 16) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j5;
        long jM4626getUnspecified0d7_KjU6 = (i6 & 32) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j6;
        long jM4626getUnspecified0d7_KjU7 = (i6 & 64) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j7;
        long jM4626getUnspecified0d7_KjU8 = (i6 & Fields.SpotShadowColor) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j8;
        long jM4626getUnspecified0d7_KjU9 = (i6 & Fields.RotationX) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j9;
        long jM4626getUnspecified0d7_KjU10 = (i6 & Fields.RotationY) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j10;
        TextSelectionColors textSelectionColors2 = (i6 & Fields.RotationZ) != 0 ? null : textSelectionColors;
        long jM4626getUnspecified0d7_KjU11 = (i6 & Fields.CameraDistance) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j11;
        long jM4626getUnspecified0d7_KjU12 = (i6 & Fields.TransformOrigin) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j12;
        long jM4626getUnspecified0d7_KjU13 = (i6 & Fields.Shape) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j13;
        long jM4626getUnspecified0d7_KjU14 = (i6 & Fields.Clip) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j14;
        long jM4626getUnspecified0d7_KjU15 = (32768 & i6) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j15;
        long jM4626getUnspecified0d7_KjU16 = (65536 & i6) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j16;
        long jM4626getUnspecified0d7_KjU17 = (131072 & i6) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j17;
        long jM4626getUnspecified0d7_KjU18 = (262144 & i6) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j18;
        long jM4626getUnspecified0d7_KjU19 = (524288 & i6) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j19;
        long jM4626getUnspecified0d7_KjU20 = (1048576 & i6) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j20;
        long jM4626getUnspecified0d7_KjU21 = (2097152 & i6) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j21;
        long jM4626getUnspecified0d7_KjU22 = (4194304 & i6) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j22;
        long jM4626getUnspecified0d7_KjU23 = (8388608 & i6) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j23;
        long jM4626getUnspecified0d7_KjU24 = (16777216 & i6) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j24;
        long jM4626getUnspecified0d7_KjU25 = (33554432 & i6) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j25;
        long jM4626getUnspecified0d7_KjU26 = (67108864 & i6) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j26;
        long jM4626getUnspecified0d7_KjU27 = (134217728 & i6) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j27;
        long jM4626getUnspecified0d7_KjU28 = (268435456 & i6) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j28;
        long jM4626getUnspecified0d7_KjU29 = (536870912 & i6) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j29;
        long jM4626getUnspecified0d7_KjU30 = (i6 & 1073741824) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j30;
        long jM4626getUnspecified0d7_KjU31 = (i7 & 1) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j31;
        long jM4626getUnspecified0d7_KjU32 = (i7 & 2) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j32;
        long jM4626getUnspecified0d7_KjU33 = (i7 & 4) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j33;
        long jM4626getUnspecified0d7_KjU34 = (i7 & 8) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j34;
        long jM4626getUnspecified0d7_KjU35 = (i7 & 16) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j35;
        long jM4626getUnspecified0d7_KjU36 = (i7 & 32) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j36;
        long jM4626getUnspecified0d7_KjU37 = (i7 & 64) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j37;
        long jM4626getUnspecified0d7_KjU38 = (i7 & Fields.SpotShadowColor) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j38;
        long jM4626getUnspecified0d7_KjU39 = (i7 & Fields.RotationX) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j39;
        long jM4626getUnspecified0d7_KjU40 = (i7 & Fields.RotationY) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j40;
        long jM4626getUnspecified0d7_KjU41 = (i7 & Fields.RotationZ) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j41;
        long jM4626getUnspecified0d7_KjU42 = (i7 & Fields.CameraDistance) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j42;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1767617725, i, i2, "androidx.compose.material3.OutlinedTextFieldDefaults.colors (TextFieldDefaults.kt:1023)");
        }
        TextFieldColors textFieldColorsM2938copyejIjP34 = getDefaultOutlinedTextFieldColors(MaterialTheme.INSTANCE.getColorScheme(composer, 6), composer, (i5 >> 6) & 112).m2938copyejIjP34(jM4626getUnspecified0d7_KjU, jM4626getUnspecified0d7_KjU2, jM4626getUnspecified0d7_KjU3, jM4626getUnspecified0d7_KjU4, jM4626getUnspecified0d7_KjU5, jM4626getUnspecified0d7_KjU6, jM4626getUnspecified0d7_KjU7, jM4626getUnspecified0d7_KjU8, jM4626getUnspecified0d7_KjU9, jM4626getUnspecified0d7_KjU10, textSelectionColors2, jM4626getUnspecified0d7_KjU11, jM4626getUnspecified0d7_KjU12, jM4626getUnspecified0d7_KjU13, jM4626getUnspecified0d7_KjU14, jM4626getUnspecified0d7_KjU15, jM4626getUnspecified0d7_KjU16, jM4626getUnspecified0d7_KjU17, jM4626getUnspecified0d7_KjU18, jM4626getUnspecified0d7_KjU19, jM4626getUnspecified0d7_KjU20, jM4626getUnspecified0d7_KjU21, jM4626getUnspecified0d7_KjU22, jM4626getUnspecified0d7_KjU23, jM4626getUnspecified0d7_KjU24, jM4626getUnspecified0d7_KjU25, jM4626getUnspecified0d7_KjU26, jM4626getUnspecified0d7_KjU27, jM4626getUnspecified0d7_KjU28, jM4626getUnspecified0d7_KjU29, jM4626getUnspecified0d7_KjU30, jM4626getUnspecified0d7_KjU31, jM4626getUnspecified0d7_KjU32, jM4626getUnspecified0d7_KjU33, jM4626getUnspecified0d7_KjU34, jM4626getUnspecified0d7_KjU35, jM4626getUnspecified0d7_KjU36, jM4626getUnspecified0d7_KjU37, jM4626getUnspecified0d7_KjU38, jM4626getUnspecified0d7_KjU39, jM4626getUnspecified0d7_KjU40, jM4626getUnspecified0d7_KjU41, jM4626getUnspecified0d7_KjU42);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return textFieldColorsM2938copyejIjP34;
    }

    public final TextFieldColors getDefaultOutlinedTextFieldColors(ColorScheme colorScheme, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -292363577, "C:TextFieldDefaults.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-292363577, i, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.<get-defaultOutlinedTextFieldColors> (TextFieldDefaults.kt:1071)");
        }
        TextFieldColors defaultOutlinedTextFieldColorsCached = colorScheme.getDefaultOutlinedTextFieldColorsCached();
        composer.startReplaceGroup(1540400102);
        ComposerKt.sourceInformation(composer, "*1086@57012L7");
        if (defaultOutlinedTextFieldColorsCached == null) {
            long jFromToken = ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getFocusInputColor());
            long jFromToken2 = ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getInputColor());
            long jM4589copywmQWz5c$default = Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getDisabledInputColor()), 0.38f, 0.0f, 0.0f, 0.0f, 14, null);
            long jFromToken3 = ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getErrorInputColor());
            long jM4625getTransparent0d7_KjU = Color.INSTANCE.m4625getTransparent0d7_KjU();
            long jM4625getTransparent0d7_KjU2 = Color.INSTANCE.m4625getTransparent0d7_KjU();
            long jM4625getTransparent0d7_KjU3 = Color.INSTANCE.m4625getTransparent0d7_KjU();
            long jM4625getTransparent0d7_KjU4 = Color.INSTANCE.m4625getTransparent0d7_KjU();
            long jFromToken4 = ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getCaretColor());
            long jFromToken5 = ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getErrorFocusCaretColor());
            ProvidableCompositionLocal<TextSelectionColors> localTextSelectionColors = TextSelectionColorsKt.getLocalTextSelectionColors();
            ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume = composer.consume(localTextSelectionColors);
            ComposerKt.sourceInformationMarkerEnd(composer);
            defaultOutlinedTextFieldColorsCached = new TextFieldColors(jFromToken, jFromToken2, jM4589copywmQWz5c$default, jFromToken3, jM4625getTransparent0d7_KjU, jM4625getTransparent0d7_KjU2, jM4625getTransparent0d7_KjU3, jM4625getTransparent0d7_KjU4, jFromToken4, jFromToken5, (TextSelectionColors) objConsume, ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getFocusOutlineColor()), ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getOutlineColor()), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getDisabledOutlineColor()), 0.12f, 0.0f, 0.0f, 0.0f, 14, null), ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getErrorOutlineColor()), ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getFocusLeadingIconColor()), ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getLeadingIconColor()), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getDisabledLeadingIconColor()), 0.38f, 0.0f, 0.0f, 0.0f, 14, null), ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getErrorLeadingIconColor()), ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getFocusTrailingIconColor()), ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getTrailingIconColor()), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getDisabledTrailingIconColor()), 0.38f, 0.0f, 0.0f, 0.0f, 14, null), ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getErrorTrailingIconColor()), ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getFocusLabelColor()), ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getLabelColor()), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getDisabledLabelColor()), 0.38f, 0.0f, 0.0f, 0.0f, 14, null), ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getErrorLabelColor()), ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getInputPlaceholderColor()), ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getInputPlaceholderColor()), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getDisabledInputColor()), 0.38f, 0.0f, 0.0f, 0.0f, 14, null), ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getInputPlaceholderColor()), ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getFocusSupportingColor()), ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getSupportingColor()), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getDisabledSupportingColor()), 0.38f, 0.0f, 0.0f, 0.0f, 14, null), ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getErrorSupportingColor()), ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getInputPrefixColor()), ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getInputPrefixColor()), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getInputPrefixColor()), 0.38f, 0.0f, 0.0f, 0.0f, 14, null), ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getInputPrefixColor()), ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getInputSuffixColor()), ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getInputSuffixColor()), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getInputSuffixColor()), 0.38f, 0.0f, 0.0f, 0.0f, 14, null), ColorSchemeKt.fromToken(colorScheme, OutlinedTextFieldTokens.INSTANCE.getInputSuffixColor()), null);
            colorScheme.setDefaultOutlinedTextFieldColorsCached$material3_release(defaultOutlinedTextFieldColorsCached);
        }
        composer.endReplaceGroup();
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return defaultOutlinedTextFieldColorsCached;
    }

    @Deprecated(level = DeprecationLevel.WARNING, message = "Renamed to OutlinedTextFieldDefaults.Container", replaceWith = @ReplaceWith(expression = "Container(\n    enabled = enabled,\n    isError = isError,\n    interactionSource = interactionSource,\n    colors = colors,\n    shape = shape,\n    focusedBorderThickness = focusedBorderThickness,\n    unfocusedBorderThickness = unfocusedBorderThickness,\n)", imports = {}))
    public final void m2647ContainerBoxnbWgWpA(final boolean z, final boolean z2, final InteractionSource interactionSource, TextFieldColors textFieldColors, Shape shape, float f, float f2, Composer composer, final int i, final int i2) {
        int i3;
        TextFieldColors textFieldColorsColors;
        Shape shape2;
        float f3;
        float f4;
        final TextFieldColors textFieldColors2;
        final Shape shape3;
        final float f5;
        final float f6;
        int i4;
        int i5;
        Composer composerStartRestartGroup = composer.startRestartGroup(1461761386);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(ContainerBox)P(1,4,3!1,5,2:c#ui.unit.Dp,6:c#ui.unit.Dp)1174@62656L8,1175@62715L5,1179@62864L348:TextFieldDefaults.kt#uh7d8r");
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
            i3 |= composerStartRestartGroup.changed(z2) ? 32 : 16;
        }
        if ((i2 & 4) != 0) {
            i3 |= 384;
        } else if ((i & 384) == 0) {
            i3 |= composerStartRestartGroup.changed(interactionSource) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i & 3072) == 0) {
            if ((i2 & 8) == 0) {
                textFieldColorsColors = textFieldColors;
                if (composerStartRestartGroup.changed(textFieldColorsColors)) {
                    i5 = Fields.CameraDistance;
                }
                i3 |= i5;
            } else {
                textFieldColorsColors = textFieldColors;
            }
            i5 = Fields.RotationZ;
            i3 |= i5;
        } else {
            textFieldColorsColors = textFieldColors;
        }
        if ((i & 24576) == 0) {
            if ((i2 & 16) == 0) {
                shape2 = shape;
                if (composerStartRestartGroup.changed(shape2)) {
                    i4 = Fields.Clip;
                }
                i3 |= i4;
            } else {
                shape2 = shape;
            }
            i4 = Fields.Shape;
            i3 |= i4;
        } else {
            shape2 = shape;
        }
        if ((196608 & i) == 0) {
            if ((i2 & 32) == 0) {
                f3 = f;
                int i6 = composerStartRestartGroup.changed(f3) ? Fields.RenderEffect : 65536;
                i3 |= i6;
            } else {
                f3 = f;
            }
            i3 |= i6;
        } else {
            f3 = f;
        }
        if ((1572864 & i) == 0) {
            if ((i2 & 64) == 0) {
                f4 = f2;
                int i7 = composerStartRestartGroup.changed(f4) ? 1048576 : 524288;
                i3 |= i7;
            } else {
                f4 = f2;
            }
            i3 |= i7;
        } else {
            f4 = f2;
        }
        if ((i2 & Fields.SpotShadowColor) != 0) {
            i3 |= 12582912;
        } else if ((i & 12582912) == 0) {
            i3 |= composerStartRestartGroup.changed(this) ? 8388608 : 4194304;
        }
        if ((4793491 & i3) == 4793490 && composerStartRestartGroup.getSkipping()) {
            composerStartRestartGroup.skipToGroupEnd();
            shape3 = shape2;
            f5 = f3;
            f6 = f4;
            textFieldColors2 = textFieldColorsColors;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) == 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                if ((i2 & 8) != 0) {
                    textFieldColorsColors = colors(composerStartRestartGroup, (i3 >> 21) & 14);
                    i3 &= -7169;
                }
                if ((i2 & 16) != 0) {
                    shape2 = INSTANCE.getShape(composerStartRestartGroup, 6);
                    i3 &= -57345;
                }
                if ((i2 & 32) != 0) {
                    f3 = FocusedBorderThickness;
                    i3 &= -458753;
                }
                if ((i2 & 64) != 0) {
                    f4 = UnfocusedBorderThickness;
                    i3 &= -3670017;
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
            }
            TextFieldColors textFieldColors3 = textFieldColorsColors;
            Shape shape4 = shape2;
            float f7 = f3;
            float f8 = f4;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1461761386, i3, -1, "androidx.compose.material3.OutlinedTextFieldDefaults.ContainerBox (TextFieldDefaults.kt:1179)");
            }
            int i8 = (i3 & 14) | 3072 | (i3 & 112) | (i3 & 896);
            int i9 = i3 << 3;
            m2646Container4EFweAY(z, z2, interactionSource, Modifier.INSTANCE, textFieldColors3, shape4, f7, f8, composerStartRestartGroup, i8 | (57344 & i9) | (458752 & i9) | (3670016 & i9) | (29360128 & i9) | (i9 & 234881024), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            textFieldColors2 = textFieldColors3;
            shape3 = shape4;
            f5 = f7;
            f6 = f8;
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

                public final void invoke(Composer composer2, int i10) {
                    this.$tmp0_rcvr.m2647ContainerBoxnbWgWpA(z, z2, interactionSource, textFieldColors2, shape3, f5, f6, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }
}
