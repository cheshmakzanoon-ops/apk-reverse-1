package androidx.compose.material3;

import androidx.compose.foundation.interaction.FocusInteractionKt;
import androidx.compose.foundation.interaction.InteractionSourceKt;
import androidx.compose.foundation.interaction.MutableInteractionSource;
import androidx.compose.foundation.layout.BoxKt;
import androidx.compose.foundation.layout.BoxScopeInstance;
import androidx.compose.foundation.layout.OffsetKt;
import androidx.compose.foundation.layout.SizeKt;
import androidx.compose.foundation.layout.WindowInsets;
import androidx.compose.foundation.layout.WindowInsets_androidKt;
import androidx.compose.foundation.text.BasicTextFieldKt;
import androidx.compose.foundation.text.KeyboardActionScope;
import androidx.compose.foundation.text.KeyboardActions;
import androidx.compose.foundation.text.KeyboardOptions;
import androidx.compose.foundation.text.selection.TextSelectionColors;
import androidx.compose.foundation.text.selection.TextSelectionColorsKt;
import androidx.compose.material3.internal.Strings;
import androidx.compose.material3.internal.Strings_androidKt;
import androidx.compose.material3.tokens.ElevationTokens;
import androidx.compose.material3.tokens.FilledTextFieldTokens;
import androidx.compose.material3.tokens.SearchBarTokens;
import androidx.compose.material3.tokens.SearchViewTokens;
import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.ComposedModifierKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.focus.FocusChangedModifierKt;
import androidx.compose.p002ui.focus.FocusManager;
import androidx.compose.p002ui.focus.FocusRequester;
import androidx.compose.p002ui.focus.FocusRequesterModifierKt;
import androidx.compose.p002ui.focus.FocusState;
import androidx.compose.p002ui.graphics.Brush;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.Shadow;
import androidx.compose.p002ui.graphics.Shape;
import androidx.compose.p002ui.graphics.SolidColor;
import androidx.compose.p002ui.graphics.drawscope.DrawStyle;
import androidx.compose.p002ui.layout.MeasurePolicy;
import androidx.compose.p002ui.node.ComposeUiNode;
import androidx.compose.p002ui.platform.CompositionLocalsKt;
import androidx.compose.p002ui.semantics.SemanticsModifierKt;
import androidx.compose.p002ui.semantics.SemanticsPropertiesKt;
import androidx.compose.p002ui.semantics.SemanticsPropertyReceiver;
import androidx.compose.runtime.Applier;
import androidx.compose.runtime.ComposablesKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocalMap;
import androidx.compose.runtime.EffectsKt;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.Updater;
import androidx.compose.runtime.internal.ComposableLambda;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.ui.text.PlatformTextStyle;
import androidx.compose.ui.text.TextLayoutResult;
import androidx.compose.ui.text.TextStyle;
import androidx.compose.ui.text.font.FontFamily;
import androidx.compose.ui.text.font.FontStyle;
import androidx.compose.ui.text.font.FontSynthesis;
import androidx.compose.ui.text.font.FontWeight;
import androidx.compose.ui.text.input.ImeAction;
import androidx.compose.ui.text.input.PlatformImeOptions;
import androidx.compose.ui.text.input.VisualTransformation;
import androidx.compose.ui.text.intl.LocaleList;
import androidx.compose.ui.text.style.BaselineShift;
import androidx.compose.ui.text.style.LineHeightStyle;
import androidx.compose.ui.text.style.TextDecoration;
import androidx.compose.ui.text.style.TextGeometricTransform;
import androidx.compose.ui.text.style.TextIndent;
import androidx.compose.ui.text.style.TextMotion;
import androidx.compose.ui.unit.Dp;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000v\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\u0011\bÇ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002JÈ\u0001\u0010\u001b\u001a\u00020\u001c2\u0006\u0010\u001d\u001a\u00020\u001e2\u0012\u0010\u001f\u001a\u000e\u0012\u0004\u0012\u00020\u001e\u0012\u0004\u0012\u00020\u001c0 2\u0012\u0010!\u001a\u000e\u0012\u0004\u0012\u00020\u001e\u0012\u0004\u0012\u00020\u001c0 2\u0006\u0010\"\u001a\u00020#2\u0012\u0010$\u001a\u000e\u0012\u0004\u0012\u00020#\u0012\u0004\u0012\u00020\u001c0 2\b\b\u0002\u0010%\u001a\u00020&2\b\b\u0002\u0010'\u001a\u00020#2\u0015\b\u0002\u0010(\u001a\u000f\u0012\u0004\u0012\u00020\u001c\u0018\u00010)¢\u0006\u0002\b*2\u0015\b\u0002\u0010+\u001a\u000f\u0012\u0004\u0012\u00020\u001c\u0018\u00010)¢\u0006\u0002\b*2\u0015\b\u0002\u0010,\u001a\u000f\u0012\u0004\u0012\u00020\u001c\u0018\u00010)¢\u0006\u0002\b*2\b\b\u0002\u0010-\u001a\u00020.2\n\b\u0002\u0010/\u001a\u0004\u0018\u000100H\u0007¢\u0006\u0002\u00101J&\u0010-\u001a\u0002022\b\b\u0002\u00103\u001a\u0002042\b\b\u0002\u00105\u001a\u000204H\u0007ø\u0001\u0000¢\u0006\u0004\b6\u00107J0\u0010-\u001a\u0002022\b\b\u0002\u00103\u001a\u0002042\b\b\u0002\u00105\u001a\u0002042\b\b\u0002\u00108\u001a\u00020.H\u0007ø\u0001\u0000¢\u0006\u0004\b9\u0010:J\u008a\u0001\u00108\u001a\u00020.2\b\b\u0002\u0010;\u001a\u0002042\b\b\u0002\u0010<\u001a\u0002042\b\b\u0002\u0010=\u001a\u0002042\b\b\u0002\u0010>\u001a\u00020?2\b\b\u0002\u0010@\u001a\u0002042\b\b\u0002\u0010A\u001a\u0002042\b\b\u0002\u0010B\u001a\u0002042\b\b\u0002\u0010C\u001a\u0002042\b\b\u0002\u0010D\u001a\u0002042\b\b\u0002\u0010E\u001a\u0002042\b\b\u0002\u0010F\u001a\u0002042\b\b\u0002\u0010G\u001a\u000204H\u0007ø\u0001\u0000¢\u0006\u0004\bH\u0010IJ\u009e\u0001\u00108\u001a\u00020.2\b\b\u0002\u0010J\u001a\u0002042\b\b\u0002\u0010K\u001a\u0002042\b\b\u0002\u0010<\u001a\u0002042\b\b\u0002\u0010=\u001a\u0002042\b\b\u0002\u0010>\u001a\u00020?2\b\b\u0002\u0010@\u001a\u0002042\b\b\u0002\u0010A\u001a\u0002042\b\b\u0002\u0010B\u001a\u0002042\b\b\u0002\u0010C\u001a\u0002042\b\b\u0002\u0010D\u001a\u0002042\b\b\u0002\u0010E\u001a\u0002042\b\b\u0002\u0010L\u001a\u0002042\b\b\u0002\u0010M\u001a\u0002042\b\b\u0002\u0010G\u001a\u000204H\u0007ø\u0001\u0000¢\u0006\u0004\bN\u0010OR$\u0010\u0003\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\u0005\u0010\u0002\u001a\u0004\b\u0006\u0010\u0007R\u0019\u0010\t\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\b\u001a\u0004\b\n\u0010\u0007R\u0019\u0010\u000b\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\b\u001a\u0004\b\f\u0010\u0007R\u0019\u0010\r\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\b\u001a\u0004\b\u000e\u0010\u0007R\u0011\u0010\u000f\u001a\u00020\u00108G¢\u0006\u0006\u001a\u0004\b\u0011\u0010\u0012R\u0011\u0010\u0013\u001a\u00020\u00108G¢\u0006\u0006\u001a\u0004\b\u0014\u0010\u0012R\u0011\u0010\u0015\u001a\u00020\u00108G¢\u0006\u0006\u001a\u0004\b\u0016\u0010\u0012R\u0011\u0010\u0017\u001a\u00020\u00188G¢\u0006\u0006\u001a\u0004\b\u0019\u0010\u001a\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006P"}, d2 = {"Landroidx/compose/material3/SearchBarDefaults;", "", "()V", "Elevation", "Landroidx/compose/ui/unit/Dp;", "getElevation-D9Ej5fM$annotations", "getElevation-D9Ej5fM", "()F", "F", "InputFieldHeight", "getInputFieldHeight-D9Ej5fM", "ShadowElevation", "getShadowElevation-D9Ej5fM", "TonalElevation", "getTonalElevation-D9Ej5fM", "dockedShape", "Landroidx/compose/ui/graphics/Shape;", "getDockedShape", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/ui/graphics/Shape;", "fullScreenShape", "getFullScreenShape", "inputFieldShape", "getInputFieldShape", "windowInsets", "Landroidx/compose/foundation/layout/WindowInsets;", "getWindowInsets", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/foundation/layout/WindowInsets;", "InputField", "", "query", "", "onQueryChange", "Lkotlin/Function1;", "onSearch", "expanded", "", "onExpandedChange", "modifier", "Landroidx/compose/ui/Modifier;", "enabled", "placeholder", "Lkotlin/Function0;", "Landroidx/compose/runtime/Composable;", "leadingIcon", "trailingIcon", "colors", "Landroidx/compose/material3/TextFieldColors;", "interactionSource", "Landroidx/compose/foundation/interaction/MutableInteractionSource;", "(Ljava/lang/String;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;ZLkotlin/jvm/functions/Function1;Landroidx/compose/ui/Modifier;ZLkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Landroidx/compose/material3/TextFieldColors;Landroidx/compose/foundation/interaction/MutableInteractionSource;Landroidx/compose/runtime/Composer;III)V", "Landroidx/compose/material3/SearchBarColors;", "containerColor", "Landroidx/compose/ui/graphics/Color;", "dividerColor", "colors-dgg9oW8", "(JJLandroidx/compose/runtime/Composer;II)Landroidx/compose/material3/SearchBarColors;", "inputFieldColors", "colors-Klgx-Pg", "(JJLandroidx/compose/material3/TextFieldColors;Landroidx/compose/runtime/Composer;II)Landroidx/compose/material3/SearchBarColors;", "textColor", "disabledTextColor", "cursorColor", "selectionColors", "Landroidx/compose/foundation/text/selection/TextSelectionColors;", "focusedLeadingIconColor", "unfocusedLeadingIconColor", "disabledLeadingIconColor", "focusedTrailingIconColor", "unfocusedTrailingIconColor", "disabledTrailingIconColor", "placeholderColor", "disabledPlaceholderColor", "inputFieldColors--u-KgnY", "(JJJLandroidx/compose/foundation/text/selection/TextSelectionColors;JJJJJJJJLandroidx/compose/runtime/Composer;III)Landroidx/compose/material3/TextFieldColors;", "focusedTextColor", "unfocusedTextColor", "focusedPlaceholderColor", "unfocusedPlaceholderColor", "inputFieldColors-ITpI4ow", "(JJJJLandroidx/compose/foundation/text/selection/TextSelectionColors;JJJJJJJJJLandroidx/compose/runtime/Composer;III)Landroidx/compose/material3/TextFieldColors;", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class SearchBarDefaults {
    public static final int $stable = 0;
    private static final float Elevation;
    public static final SearchBarDefaults INSTANCE = new SearchBarDefaults();
    private static final float InputFieldHeight;
    private static final float ShadowElevation;
    private static final float TonalElevation;

    @Deprecated(level = DeprecationLevel.WARNING, message = "Renamed to TonalElevation. Not to be confused with ShadowElevation.", replaceWith = @ReplaceWith(expression = "TonalElevation", imports = {}))
    public static void m2726getElevationD9Ej5fM$annotations() {
    }

    private SearchBarDefaults() {
    }

    static {
        float fM3537getLevel0D9Ej5fM = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
        TonalElevation = fM3537getLevel0D9Ej5fM;
        ShadowElevation = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
        Elevation = fM3537getLevel0D9Ej5fM;
        InputFieldHeight = SearchBarTokens.INSTANCE.m3838getContainerHeightD9Ej5fM();
    }

    public final float m2732getTonalElevationD9Ej5fM() {
        return TonalElevation;
    }

    public final float m2731getShadowElevationD9Ej5fM() {
        return ShadowElevation;
    }

    public final float m2729getElevationD9Ej5fM() {
        return Elevation;
    }

    public final float m2730getInputFieldHeightD9Ej5fM() {
        return InputFieldHeight;
    }

    public final Shape getInputFieldShape(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -971556142, "C349@15770L5:SearchBar.android.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-971556142, i, -1, "androidx.compose.material3.SearchBarDefaults.<get-inputFieldShape> (SearchBar.android.kt:349)");
        }
        Shape value = ShapesKt.getValue(SearchBarTokens.INSTANCE.getContainerShape(), composer, 6);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return value;
    }

    public final Shape getFullScreenShape(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 1665502056, "C353@15944L5:SearchBar.android.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1665502056, i, -1, "androidx.compose.material3.SearchBarDefaults.<get-fullScreenShape> (SearchBar.android.kt:353)");
        }
        Shape value = ShapesKt.getValue(SearchViewTokens.INSTANCE.getFullScreenContainerShape(), composer, 6);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return value;
    }

    public final Shape getDockedShape(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 1006952150, "C357@16094L5:SearchBar.android.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1006952150, i, -1, "androidx.compose.material3.SearchBarDefaults.<get-dockedShape> (SearchBar.android.kt:357)");
        }
        Shape value = ShapesKt.getValue(SearchViewTokens.INSTANCE.getDockedContainerShape(), composer, 6);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return value;
    }

    public final WindowInsets getWindowInsets(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 2112270157, "C361@16229L10:SearchBar.android.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(2112270157, i, -1, "androidx.compose.material3.SearchBarDefaults.<get-windowInsets> (SearchBar.android.kt:361)");
        }
        WindowInsets statusBars = WindowInsets_androidKt.getStatusBars(WindowInsets.INSTANCE, composer, 6);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return statusBars;
    }

    public final SearchBarColors m2728colorsdgg9oW8(long j, long j2, Composer composer, int i, int i2) {
        ComposerKt.sourceInformationMarkerStart(composer, -1507037523, "C(colors)P(0:c#ui.graphics.Color,1:c#ui.graphics.Color)375@16778L5,376@16845L5,381@17019L18:SearchBar.android.kt#uh7d8r");
        long value = (i2 & 1) != 0 ? ColorSchemeKt.getValue(SearchBarTokens.INSTANCE.getContainerColor(), composer, 6) : j;
        long value2 = (i2 & 2) != 0 ? ColorSchemeKt.getValue(SearchViewTokens.INSTANCE.getDividerColor(), composer, 6) : j2;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1507037523, i, -1, "androidx.compose.material3.SearchBarDefaults.colors (SearchBar.android.kt:378)");
        }
        SearchBarColors searchBarColors = new SearchBarColors(value, value2, m2734inputFieldColorsITpI4ow(0L, 0L, 0L, 0L, null, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, composer, 0, (i << 6) & 57344, 16383), null);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return searchBarColors;
    }

    public final TextFieldColors m2734inputFieldColorsITpI4ow(long j, long j2, long j3, long j4, TextSelectionColors textSelectionColors, long j5, long j6, long j7, long j8, long j9, long j10, long j11, long j12, long j13, Composer composer, int i, int i2, int i3) {
        TextSelectionColors textSelectionColors2;
        ComposerKt.sourceInformationMarkerStart(composer, -602148837, "C(inputFieldColors)P(7:c#ui.graphics.Color,12:c#ui.graphics.Color,3:c#ui.graphics.Color,0:c#ui.graphics.Color,9,5:c#ui.graphics.Color,10:c#ui.graphics.Color,1:c#ui.graphics.Color,8:c#ui.graphics.Color,13:c#ui.graphics.Color,4:c#ui.graphics.Color,6:c#ui.graphics.Color,11:c#ui.graphics.Color,2:c#ui.graphics.Color)410@18829L5,411@18903L5,413@18998L5,416@19154L5,417@19233L7,418@19316L5,419@19399L5,421@19507L5,424@19683L5,425@19768L5,427@19878L5,430@20056L5,431@20142L5,433@20244L5,437@20389L847:SearchBar.android.kt#uh7d8r");
        long value = (i3 & 1) != 0 ? ColorSchemeKt.getValue(SearchBarTokens.INSTANCE.getInputTextColor(), composer, 6) : j;
        long value2 = (i3 & 2) != 0 ? ColorSchemeKt.getValue(SearchBarTokens.INSTANCE.getInputTextColor(), composer, 6) : j2;
        long jM4589copywmQWz5c$default = (i3 & 4) != 0 ? Color.m4589copywmQWz5c$default(ColorSchemeKt.getValue(FilledTextFieldTokens.INSTANCE.getDisabledInputColor(), composer, 6), FilledTextFieldTokens.INSTANCE.getDisabledInputOpacity(), 0.0f, 0.0f, 0.0f, 14, null) : j3;
        long value3 = (i3 & 8) != 0 ? ColorSchemeKt.getValue(FilledTextFieldTokens.INSTANCE.getCaretColor(), composer, 6) : j4;
        if ((i3 & 16) != 0) {
            ProvidableCompositionLocal<TextSelectionColors> localTextSelectionColors = TextSelectionColorsKt.getLocalTextSelectionColors();
            ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume = composer.consume(localTextSelectionColors);
            ComposerKt.sourceInformationMarkerEnd(composer);
            textSelectionColors2 = (TextSelectionColors) objConsume;
        } else {
            textSelectionColors2 = textSelectionColors;
        }
        long value4 = (i3 & 32) != 0 ? ColorSchemeKt.getValue(SearchBarTokens.INSTANCE.getLeadingIconColor(), composer, 6) : j5;
        long value5 = (i3 & 64) != 0 ? ColorSchemeKt.getValue(SearchBarTokens.INSTANCE.getLeadingIconColor(), composer, 6) : j6;
        long jM4589copywmQWz5c$default2 = (i3 & Fields.SpotShadowColor) != 0 ? Color.m4589copywmQWz5c$default(ColorSchemeKt.getValue(FilledTextFieldTokens.INSTANCE.getDisabledLeadingIconColor(), composer, 6), FilledTextFieldTokens.INSTANCE.getDisabledLeadingIconOpacity(), 0.0f, 0.0f, 0.0f, 14, null) : j7;
        long value6 = (i3 & Fields.RotationX) != 0 ? ColorSchemeKt.getValue(SearchBarTokens.INSTANCE.getTrailingIconColor(), composer, 6) : j8;
        long value7 = (i3 & Fields.RotationY) != 0 ? ColorSchemeKt.getValue(SearchBarTokens.INSTANCE.getTrailingIconColor(), composer, 6) : j9;
        long jM4589copywmQWz5c$default3 = (i3 & Fields.RotationZ) != 0 ? Color.m4589copywmQWz5c$default(ColorSchemeKt.getValue(FilledTextFieldTokens.INSTANCE.getDisabledTrailingIconColor(), composer, 6), FilledTextFieldTokens.INSTANCE.getDisabledTrailingIconOpacity(), 0.0f, 0.0f, 0.0f, 14, null) : j10;
        long value8 = (i3 & Fields.CameraDistance) != 0 ? ColorSchemeKt.getValue(SearchBarTokens.INSTANCE.getSupportingTextColor(), composer, 6) : j11;
        long value9 = (i3 & Fields.TransformOrigin) != 0 ? ColorSchemeKt.getValue(SearchBarTokens.INSTANCE.getSupportingTextColor(), composer, 6) : j12;
        long jM4589copywmQWz5c$default4 = (i3 & Fields.Shape) != 0 ? Color.m4589copywmQWz5c$default(ColorSchemeKt.getValue(FilledTextFieldTokens.INSTANCE.getDisabledInputColor(), composer, 6), FilledTextFieldTokens.INSTANCE.getDisabledInputOpacity(), 0.0f, 0.0f, 0.0f, 14, null) : j13;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-602148837, i, i2, "androidx.compose.material3.SearchBarDefaults.inputFieldColors (SearchBar.android.kt:437)");
        }
        int i4 = i2 << 18;
        TextFieldColors textFieldColorsM3002colors0hiis_0 = TextFieldDefaults.INSTANCE.m3002colors0hiis_0(value, value2, jM4589copywmQWz5c$default, 0L, 0L, 0L, 0L, 0L, value3, 0L, textSelectionColors2, 0L, 0L, 0L, 0L, value4, value5, jM4589copywmQWz5c$default2, 0L, value6, value7, jM4589copywmQWz5c$default3, 0L, 0L, 0L, 0L, 0L, value8, value9, jM4589copywmQWz5c$default4, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, composer, (i & 1022) | ((i << 15) & 234881024), ((i >> 12) & 14) | (458752 & i) | (3670016 & i) | (i & 29360128) | ((i << 3) & 1879048192), ((i >> 27) & 14) | ((i2 << 3) & 112) | (i4 & 29360128) | (i4 & 234881024) | (i4 & 1879048192), 0, 3072, 1204058872, 4095);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return textFieldColorsM3002colors0hiis_0;
    }

    public final void InputField(final String str, final Function1<? super String, Unit> function1, final Function1<? super String, Unit> function2, final boolean z, final Function1<? super Boolean, Unit> function3, Modifier modifier, boolean z2, Function2<? super Composer, ? super Integer, Unit> function4, Function2<? super Composer, ? super Integer, Unit> function5, Function2<? super Composer, ? super Integer, Unit> function6, TextFieldColors textFieldColors, MutableInteractionSource mutableInteractionSource, Composer composer, final int i, final int i2, final int i3) {
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
        Modifier.Companion companion;
        boolean z3;
        Function2<? super Composer, ? super Integer, Unit> function7;
        Function2<? super Composer, ? super Integer, Unit> function8;
        Function2<? super Composer, ? super Integer, Unit> function9;
        TextFieldColors textFieldColorsM2734inputFieldColorsITpI4ow;
        Function2<? super Composer, ? super Integer, Unit> function10;
        MutableInteractionSource mutableInteractionSource2;
        TextFieldColors textFieldColors2;
        boolean z4;
        MutableInteractionSource mutableInteractionSource3;
        boolean zBooleanValue;
        Object objRememberedValue;
        final FocusRequester focusRequester;
        FocusManager focusManager;
        final String strM3334getString2EP1pXo;
        final String strM3334getString2EP1pXo2;
        long jM2989textColorXeAY9LY$material3_release;
        boolean z5;
        Object objRememberedValue2;
        boolean z6;
        boolean zChanged;
        Object objRememberedValue3;
        boolean z7;
        int i24;
        boolean z8;
        boolean z9;
        Object objRememberedValue4;
        boolean z10;
        Composer composer2;
        boolean zChanged2;
        Object objRememberedValue5;
        final Modifier modifier2;
        final Function2<? super Composer, ? super Integer, Unit> function11;
        final Function2<? super Composer, ? super Integer, Unit> function12;
        final Function2<? super Composer, ? super Integer, Unit> function13;
        final MutableInteractionSource mutableInteractionSource4;
        final TextFieldColors textFieldColors3;
        final boolean z11;
        Object objRememberedValue6;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(1451366815);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(InputField)P(10,7,8,2,6,5,1,9,4,11)492@23517L18,498@23776L25,499@23837L29,500@23912L7,502@23951L34,503@24030L39,*506@24122L7,521@24685L44,522@24761L378,534@25242L7,537@25496L19,540@25625L1172,510@24250L2557,566@26894L320,566@26869L345:SearchBar.android.kt#uh7d8r");
        if ((i3 & 1) != 0) {
            i4 = i | 6;
        } else if ((i & 6) == 0) {
            i4 = (composerStartRestartGroup.changed(str) ? 4 : 2) | i;
        } else {
            i4 = i;
        }
        if ((i3 & 2) == 0) {
            if ((i & 48) == 0) {
                i4 |= composerStartRestartGroup.changedInstance(function1) ? 32 : 16;
            }
            i5 = i3 & 4;
            i6 = Fields.SpotShadowColor;
            if (i5 != 0) {
                i4 |= 384;
            } else if ((i & 384) == 0) {
                if (composerStartRestartGroup.changedInstance(function2)) {
                    i7 = Fields.RotationX;
                } else {
                    i7 = 128;
                }
                i4 |= i7;
            }
            if ((i3 & 8) != 0) {
                i4 |= 3072;
            } else if ((i & 3072) == 0) {
                if (composerStartRestartGroup.changed(z)) {
                    i8 = Fields.CameraDistance;
                } else {
                    i8 = Fields.RotationZ;
                }
                i4 |= i8;
            }
            if ((i3 & 16) != 0) {
                i4 |= 24576;
            } else if ((i & 24576) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i9 = Fields.Clip;
                } else {
                    i9 = Fields.Shape;
                }
                i4 |= i9;
            }
            i10 = i3 & 32;
            if (i10 != 0) {
                i4 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changed(modifier)) {
                    i11 = Fields.RenderEffect;
                } else {
                    i11 = 65536;
                }
                i4 |= i11;
            }
            i12 = i3 & 64;
            if (i12 != 0) {
                i4 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changed(z2)) {
                    i13 = 1048576;
                } else {
                    i13 = 524288;
                }
                i4 |= i13;
            }
            i14 = i3 & Fields.SpotShadowColor;
            if (i14 != 0) {
                i4 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i15 = 8388608;
                } else {
                    i15 = 4194304;
                }
                i4 |= i15;
            }
            i16 = i3 & Fields.RotationX;
            if (i16 != 0) {
                i4 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changedInstance(function5)) {
                    i17 = 67108864;
                } else {
                    i17 = 33554432;
                }
                i4 |= i17;
            }
            i18 = i3 & Fields.RotationY;
            if (i18 != 0) {
                i4 |= 805306368;
            } else if ((i & 805306368) == 0) {
                if (composerStartRestartGroup.changedInstance(function6)) {
                    i19 = 536870912;
                } else {
                    i19 = 268435456;
                }
                i4 |= i19;
            }
            if ((i2 & 6) == 0) {
                i20 = i2 | (((i3 & Fields.RotationZ) == 0 || !composerStartRestartGroup.changed(textFieldColors)) ? 2 : 4);
            } else {
                i20 = i2;
            }
            i21 = i3 & Fields.CameraDistance;
            if (i21 != 0) {
                i20 |= 48;
            } else if ((i2 & 48) == 0) {
                if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                    i22 = 32;
                } else {
                    i22 = 16;
                }
                i20 |= i22;
            }
            i23 = i20;
            if ((i3 & Fields.TransformOrigin) != 0) {
                if ((i2 & 384) == 0) {
                    if (composerStartRestartGroup.changed(this)) {
                        i6 = Fields.RotationX;
                    }
                    i23 |= i6;
                }
                if ((i4 & 306783379) == 306783378 || (i23 & 147) != 146 || !composerStartRestartGroup.getSkipping()) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                        if (i10 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i12 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if (i14 != 0) {
                            function7 = null;
                        } else {
                            function7 = function4;
                        }
                        if (i16 != 0) {
                            function8 = null;
                        } else {
                            function8 = function5;
                        }
                        if (i18 != 0) {
                            function9 = null;
                        } else {
                            function9 = function6;
                        }
                        if ((i3 & Fields.RotationZ) != 0) {
                            textFieldColorsM2734inputFieldColorsITpI4ow = m2734inputFieldColorsITpI4ow(0L, 0L, 0L, 0L, null, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, composerStartRestartGroup, 0, (i23 << 6) & 57344, 16383);
                            i23 &= -15;
                        } else {
                            textFieldColorsM2734inputFieldColorsITpI4ow = textFieldColors;
                        }
                        function10 = function7;
                        if (i21 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                        textFieldColors2 = textFieldColorsM2734inputFieldColorsITpI4ow;
                        z4 = z3;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        if ((i3 & Fields.RotationZ) != 0) {
                            i23 &= -15;
                        }
                        companion = modifier;
                        z4 = z2;
                        function10 = function4;
                        function8 = function5;
                        function9 = function6;
                        mutableInteractionSource2 = mutableInteractionSource;
                        i23 = i23;
                        textFieldColors2 = textFieldColors;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1451366815, i4, i23, "androidx.compose.material3.SearchBarDefaults.InputField (SearchBar.android.kt:494)");
                    }
                    composerStartRestartGroup.startReplaceGroup(-320443616);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "496@23695L39");
                    if (mutableInteractionSource2 == null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320442965, "CC(remember):SearchBar.android.kt#9igjgp");
                        objRememberedValue6 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue6 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue6 = InteractionSourceKt.MutableInteractionSource();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue6);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue6;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    zBooleanValue = FocusInteractionKt.collectIsFocusedAsState(mutableInteractionSource3, composerStartRestartGroup, 0).getValue().booleanValue();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320438431, "CC(remember):SearchBar.android.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = new FocusRequester();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    focusRequester = (FocusRequester) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<FocusManager> localFocusManager = CompositionLocalsKt.getLocalFocusManager();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume = composerStartRestartGroup.consume(localFocusManager);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    focusManager = (FocusManager) objConsume;
                    Strings.Companion companion2 = Strings.INSTANCE;
                    strM3334getString2EP1pXo = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_search_bar_search), composerStartRestartGroup, 0);
                    Strings.Companion companion3 = Strings.INSTANCE;
                    strM3334getString2EP1pXo2 = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_suggestions_available), composerStartRestartGroup, 0);
                    ProvidableCompositionLocal<TextStyle> localTextStyle = TextKt.getLocalTextStyle();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume2 = composerStartRestartGroup.consume(localTextStyle);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    jM2989textColorXeAY9LY$material3_release = ((TextStyle) objConsume2).getColor-0d7_KjU();
                    if (jM2989textColorXeAY9LY$material3_release == 16) {
                        jM2989textColorXeAY9LY$material3_release = textFieldColors2.m2989textColorXeAY9LY$material3_release(z4, false, zBooleanValue);
                    }
                    long j = jM2989textColorXeAY9LY$material3_release;
                    Modifier modifierFocusRequester = FocusRequesterModifierKt.focusRequester(SizeKt.m1084sizeInqDBjuR0$default(companion, SearchBar_androidKt.getSearchBarMinWidth(), InputFieldHeight, SearchBar_androidKt.SearchBarMaxWidth, 0.0f, 8, null), focusRequester);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320411280, "CC(remember):SearchBar.android.kt#9igjgp");
                    if ((57344 & i4) == 16384) {
                        z5 = true;
                    } else {
                        z5 = false;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z5 || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = (Function1) new Function1<FocusState, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((FocusState) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(FocusState focusState) {
                                if (focusState.isFocused()) {
                                    function3.invoke(true);
                                }
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierOnFocusChanged = FocusChangedModifierKt.onFocusChanged(modifierFocusRequester, (Function1) objRememberedValue2);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320408514, "CC(remember):SearchBar.android.kt#9igjgp");
                    boolean zChanged3 = composerStartRestartGroup.changed(strM3334getString2EP1pXo);
                    if ((i4 & 7168) == 2048) {
                        z6 = true;
                    } else {
                        z6 = false;
                    }
                    zChanged = z6 | zChanged3 | composerStartRestartGroup.changed(strM3334getString2EP1pXo2);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((SemanticsPropertyReceiver) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo);
                                if (z) {
                                    SemanticsPropertiesKt.setStateDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo2);
                                }
                                final FocusRequester focusRequester2 = focusRequester;
                                SemanticsPropertiesKt.onClick$default(semanticsPropertyReceiver, null, new Function0<Boolean>() {
                                    {
                                        super(0);
                                    }

                                    public final Boolean m2735invoke() {
                                        focusRequester2.requestFocus();
                                        return true;
                                    }
                                }, 1, null);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierSemantics$default = SemanticsModifierKt.semantics$default(modifierOnFocusChanged, false, (Function1) objRememberedValue3, 1, null);
                    ProvidableCompositionLocal<TextStyle> localTextStyle2 = TextKt.getLocalTextStyle();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume3 = composerStartRestartGroup.consume(localTextStyle2);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    TextStyle textStyleMerge = ((TextStyle) objConsume3).merge(new TextStyle(j, 0L, (FontWeight) null, (FontStyle) null, (FontSynthesis) null, (FontFamily) null, (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, 0, 0, 0L, (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16777214, (DefaultConstructorMarker) null));
                    SolidColor solidColor = new SolidColor(textFieldColors2.m2939cursorColorvNxB06k$material3_release(false), null);
                    KeyboardOptions keyboardOptions = new KeyboardOptions(0, (Boolean) null, 0, ImeAction.Companion.getSearch-eUduSuo(), (PlatformImeOptions) null, (Boolean) null, (LocaleList) null, 119, (DefaultConstructorMarker) null);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320385353, "CC(remember):SearchBar.android.kt#9igjgp");
                    if ((i4 & 896) == 256) {
                        z7 = true;
                    } else {
                        z7 = false;
                    }
                    i24 = i4 & 14;
                    if (i24 == 4) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    z9 = z7 | z8;
                    objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                    if (!z9 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue4 = (Function1) new Function1<KeyboardActionScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((KeyboardActionScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(KeyboardActionScope keyboardActionScope) {
                                function2.invoke(str);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i25 = i4;
                    final boolean z12 = z4;
                    final MutableInteractionSource mutableInteractionSource5 = mutableInteractionSource3;
                    final Function2<? super Composer, ? super Integer, Unit> function14 = function10;
                    final Function2<? super Composer, ? super Integer, Unit> function15 = function8;
                    final Function2<? super Composer, ? super Integer, Unit> function16 = function9;
                    final TextFieldColors textFieldColors4 = textFieldColors2;
                    int i26 = i24 | 102236160 | (i25 & 112);
                    int i27 = i25 >> 9;
                    TextFieldColors textFieldColors5 = textFieldColors2;
                    boolean z13 = z4;
                    BasicTextFieldKt.BasicTextField(str, function1, modifierSemantics$default, z13, false, textStyleMerge, keyboardOptions, new KeyboardActions(null, null, null, null, (Function1) objRememberedValue4, null, 47, null), true, 0, 0, (VisualTransformation) null, (Function1<? super TextLayoutResult, Unit>) null, mutableInteractionSource3, (Brush) solidColor, (Function3<? super Function2<? super Composer, ? super Integer, Unit>, ? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(-2029278807, true, new Function3<Function2<? super Composer, ? super Integer, ? extends Unit>, Composer, Integer, Unit>() {
                        {
                            super(3);
                        }

                        public Object invoke(Object obj, Object obj2, Object obj3) {
                            invoke((Function2<? super Composer, ? super Integer, Unit>) obj, (Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Function2<? super Composer, ? super Integer, Unit> function17, Composer composer3, int i28) {
                            int i29;
                            ComposerKt.sourceInformation(composer3, "C557@26571L15,541@25683L1096:SearchBar.android.kt#uh7d8r");
                            if ((i28 & 6) == 0) {
                                i29 = i28 | (composer3.changedInstance(function17) ? 4 : 2);
                            } else {
                                i29 = i28;
                            }
                            if ((i29 & 19) != 18 || !composer3.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-2029278807, i29, -1, "androidx.compose.material3.SearchBarDefaults.InputField.<anonymous> (SearchBar.android.kt:541)");
                                }
                                TextFieldDefaults textFieldDefaults = TextFieldDefaults.INSTANCE;
                                String str2 = str;
                                boolean z14 = z12;
                                VisualTransformation none = VisualTransformation.Companion.getNone();
                                MutableInteractionSource mutableInteractionSource6 = mutableInteractionSource5;
                                Function2<Composer, Integer, Unit> function18 = function14;
                                final Function2<Composer, Integer, Unit> function19 = function15;
                                composer3.startReplaceGroup(-1102017390);
                                ComposerKt.sourceInformation(composer3, "*551@26196L64");
                                ComposableLambda composableLambdaRememberComposableLambda = function19 == null ? null : ComposableLambdaKt.rememberComposableLambda(-1401341985, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer4, int i30) {
                                        ComposerKt.sourceInformation(composer4, "C551@26198L60:SearchBar.android.kt#uh7d8r");
                                        if ((i30 & 3) == 2 && composer4.getSkipping()) {
                                            composer4.skipToGroupEnd();
                                            return;
                                        }
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1401341985, i30, -1, "androidx.compose.material3.SearchBarDefaults.InputField.<anonymous>.<anonymous>.<anonymous> (SearchBar.android.kt:551)");
                                        }
                                        Modifier modifierM996offsetVpY3zN4$default = OffsetKt.m996offsetVpY3zN4$default(Modifier.INSTANCE, SearchBar_androidKt.SearchBarIconOffsetX, 0.0f, 2, null);
                                        Function2<Composer, Integer, Unit> function20 = function19;
                                        ComposerKt.sourceInformationMarkerStart(composer4, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                        ComposerKt.sourceInformationMarkerStart(composer4, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer4, 0);
                                        CompositionLocalMap currentCompositionLocalMap = composer4.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer4, modifierM996offsetVpY3zN4$default);
                                        Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer4, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer4.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer4.startReusableNode();
                                        if (composer4.getInserting()) {
                                            composer4.createNode(constructor);
                                        } else {
                                            composer4.useNode();
                                        }
                                        Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer4);
                                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer4, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                        BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer4, -127763558, "C551@26247L9:SearchBar.android.kt#uh7d8r");
                                        function20.invoke(composer4, 0);
                                        ComposerKt.sourceInformationMarkerEnd(composer4);
                                        ComposerKt.sourceInformationMarkerEnd(composer4);
                                        composer4.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer4);
                                        ComposerKt.sourceInformationMarkerEnd(composer4);
                                        ComposerKt.sourceInformationMarkerEnd(composer4);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                        }
                                    }
                                }, composer3, 54);
                                composer3.endReplaceGroup();
                                final Function2<Composer, Integer, Unit> function20 = function16;
                                composer3.startReplaceGroup(-1102010155);
                                ComposerKt.sourceInformation(composer3, "*555@26423L66");
                                ComposableLambda composableLambdaRememberComposableLambda2 = function20 == null ? null : ComposableLambdaKt.rememberComposableLambda(907752083, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer4, int i30) {
                                        ComposerKt.sourceInformation(composer4, "C555@26425L62:SearchBar.android.kt#uh7d8r");
                                        if ((i30 & 3) == 2 && composer4.getSkipping()) {
                                            composer4.skipToGroupEnd();
                                            return;
                                        }
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(907752083, i30, -1, "androidx.compose.material3.SearchBarDefaults.InputField.<anonymous>.<anonymous>.<anonymous> (SearchBar.android.kt:555)");
                                        }
                                        Modifier modifierM996offsetVpY3zN4$default = OffsetKt.m996offsetVpY3zN4$default(Modifier.INSTANCE, Dp.constructor-impl(-SearchBar_androidKt.SearchBarIconOffsetX), 0.0f, 2, null);
                                        Function2<Composer, Integer, Unit> function21 = function20;
                                        ComposerKt.sourceInformationMarkerStart(composer4, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                        ComposerKt.sourceInformationMarkerStart(composer4, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer4, 0);
                                        CompositionLocalMap currentCompositionLocalMap = composer4.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer4, modifierM996offsetVpY3zN4$default);
                                        Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer4, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer4.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer4.startReusableNode();
                                        if (composer4.getInserting()) {
                                            composer4.createNode(constructor);
                                        } else {
                                            composer4.useNode();
                                        }
                                        Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer4);
                                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer4, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                        BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer4, -127537351, "C555@26475L10:SearchBar.android.kt#uh7d8r");
                                        function21.invoke(composer4, 0);
                                        ComposerKt.sourceInformationMarkerEnd(composer4);
                                        ComposerKt.sourceInformationMarkerEnd(composer4);
                                        composer4.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer4);
                                        ComposerKt.sourceInformationMarkerEnd(composer4);
                                        ComposerKt.sourceInformationMarkerEnd(composer4);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                        }
                                    }
                                }, composer3, 54);
                                composer3.endReplaceGroup();
                                textFieldDefaults.DecorationBox(str2, function17, z14, true, none, mutableInteractionSource6, false, null, function18, composableLambdaRememberComposableLambda, composableLambdaRememberComposableLambda2, null, null, null, SearchBarDefaults.INSTANCE.getInputFieldShape(composer3, 6), textFieldColors4, TextFieldDefaults.m2993contentPaddingWithoutLabela9UjIt4$default(TextFieldDefaults.INSTANCE, 0.0f, 0.0f, 0.0f, 0.0f, 15, null), ComposableSingletons$SearchBar_androidKt.INSTANCE.m2223getLambda1$material3_release(), composer3, ((i29 << 3) & 112) | 27648, 113246208, 14528);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer3.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, i26 | (i27 & 7168), 196608, 7696);
                    if (z && zBooleanValue) {
                        z10 = true;
                    } else {
                        z10 = false;
                    }
                    Boolean boolValueOf = Boolean.valueOf(z);
                    composer2 = composerStartRestartGroup;
                    ComposerKt.sourceInformationMarkerStart(composer2, -320340316, "CC(remember):SearchBar.android.kt#9igjgp");
                    zChanged2 = composer2.changed(z10) | composer2.changedInstance(focusManager);
                    objRememberedValue5 = composer2.rememberedValue();
                    if (!zChanged2 || objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue5 = (Function2) new SearchBarDefaults$InputField$5$1(z10, focusManager, null);
                        composer2.updateRememberedValue(objRememberedValue5);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    EffectsKt.LaunchedEffect(boolValueOf, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) objRememberedValue5, composer2, i27 & 14);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    function11 = function10;
                    function12 = function8;
                    function13 = function9;
                    mutableInteractionSource4 = mutableInteractionSource2;
                    textFieldColors3 = textFieldColors5;
                    z11 = z13;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    modifier2 = modifier;
                    z11 = z2;
                    function11 = function4;
                    function12 = function5;
                    function13 = function6;
                    mutableInteractionSource4 = mutableInteractionSource;
                    composer2 = composerStartRestartGroup;
                    textFieldColors3 = textFieldColors;
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

                        public final void invoke(Composer composer3, int i28) {
                            SearchBarDefaults.this.InputField(str, function1, function2, z, function3, modifier2, z11, function11, function12, function13, textFieldColors3, mutableInteractionSource4, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i23 |= 384;
            if ((i4 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i12 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if (i14 != 0) {
                        function7 = null;
                    } else {
                        function7 = function4;
                    }
                    if (i16 != 0) {
                        function8 = null;
                    } else {
                        function8 = function5;
                    }
                    if (i18 != 0) {
                        function9 = null;
                    } else {
                        function9 = function6;
                    }
                    if ((i3 & Fields.RotationZ) != 0) {
                        textFieldColorsM2734inputFieldColorsITpI4ow = m2734inputFieldColorsITpI4ow(0L, 0L, 0L, 0L, null, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, composerStartRestartGroup, 0, (i23 << 6) & 57344, 16383);
                        i23 &= -15;
                    } else {
                        textFieldColorsM2734inputFieldColorsITpI4ow = textFieldColors;
                    }
                    function10 = function7;
                    if (i21 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    textFieldColors2 = textFieldColorsM2734inputFieldColorsITpI4ow;
                    z4 = z3;
                } else {
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i12 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if (i14 != 0) {
                        function7 = null;
                    } else {
                        function7 = function4;
                    }
                    if (i16 != 0) {
                        function8 = null;
                    } else {
                        function8 = function5;
                    }
                    if (i18 != 0) {
                        function9 = null;
                    } else {
                        function9 = function6;
                    }
                    if ((i3 & Fields.RotationZ) != 0) {
                        textFieldColorsM2734inputFieldColorsITpI4ow = m2734inputFieldColorsITpI4ow(0L, 0L, 0L, 0L, null, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, composerStartRestartGroup, 0, (i23 << 6) & 57344, 16383);
                        i23 &= -15;
                    } else {
                        textFieldColorsM2734inputFieldColorsITpI4ow = textFieldColors;
                    }
                    function10 = function7;
                    if (i21 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    textFieldColors2 = textFieldColorsM2734inputFieldColorsITpI4ow;
                    z4 = z3;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1451366815, i4, i23, "androidx.compose.material3.SearchBarDefaults.InputField (SearchBar.android.kt:494)");
                }
                composerStartRestartGroup.startReplaceGroup(-320443616);
                ComposerKt.sourceInformation(composerStartRestartGroup, "496@23695L39");
                if (mutableInteractionSource2 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320442965, "CC(remember):SearchBar.android.kt#9igjgp");
                    objRememberedValue6 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue6 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue6 = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue6);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue6;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                composerStartRestartGroup.endReplaceGroup();
                zBooleanValue = FocusInteractionKt.collectIsFocusedAsState(mutableInteractionSource3, composerStartRestartGroup, 0).getValue().booleanValue();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320438431, "CC(remember):SearchBar.android.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = new FocusRequester();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                focusRequester = (FocusRequester) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<FocusManager> localFocusManager2 = CompositionLocalsKt.getLocalFocusManager();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume4 = composerStartRestartGroup.consume(localFocusManager2);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                focusManager = (FocusManager) objConsume4;
                Strings.Companion companion4 = Strings.INSTANCE;
                strM3334getString2EP1pXo = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_search_bar_search), composerStartRestartGroup, 0);
                Strings.Companion companion5 = Strings.INSTANCE;
                strM3334getString2EP1pXo2 = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_suggestions_available), composerStartRestartGroup, 0);
                ProvidableCompositionLocal<TextStyle> localTextStyle3 = TextKt.getLocalTextStyle();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume5 = composerStartRestartGroup.consume(localTextStyle3);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                jM2989textColorXeAY9LY$material3_release = ((TextStyle) objConsume5).getColor-0d7_KjU();
                if (jM2989textColorXeAY9LY$material3_release == 16) {
                    jM2989textColorXeAY9LY$material3_release = textFieldColors2.m2989textColorXeAY9LY$material3_release(z4, false, zBooleanValue);
                }
                long j2 = jM2989textColorXeAY9LY$material3_release;
                Modifier modifierFocusRequester2 = FocusRequesterModifierKt.focusRequester(SizeKt.m1084sizeInqDBjuR0$default(companion, SearchBar_androidKt.getSearchBarMinWidth(), InputFieldHeight, SearchBar_androidKt.SearchBarMaxWidth, 0.0f, 8, null), focusRequester);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320411280, "CC(remember):SearchBar.android.kt#9igjgp");
                if ((57344 & i4) == 16384) {
                    z5 = true;
                } else {
                    z5 = false;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z5) {
                    objRememberedValue2 = (Function1) new Function1<FocusState, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((FocusState) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(FocusState focusState) {
                            if (focusState.isFocused()) {
                                function3.invoke(true);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<FocusState, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((FocusState) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(FocusState focusState) {
                            if (focusState.isFocused()) {
                                function3.invoke(true);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierOnFocusChanged2 = FocusChangedModifierKt.onFocusChanged(modifierFocusRequester2, (Function1) objRememberedValue2);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320408514, "CC(remember):SearchBar.android.kt#9igjgp");
                boolean zChanged4 = composerStartRestartGroup.changed(strM3334getString2EP1pXo);
                if ((i4 & 7168) == 2048) {
                    z6 = true;
                } else {
                    z6 = false;
                }
                zChanged = z6 | zChanged4 | composerStartRestartGroup.changed(strM3334getString2EP1pXo2);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo);
                            if (z) {
                                SemanticsPropertiesKt.setStateDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo2);
                            }
                            final FocusRequester focusRequester2 = focusRequester;
                            SemanticsPropertiesKt.onClick$default(semanticsPropertyReceiver, null, new Function0<Boolean>() {
                                {
                                    super(0);
                                }

                                public final Boolean m2735invoke() {
                                    focusRequester2.requestFocus();
                                    return true;
                                }
                            }, 1, null);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo);
                            if (z) {
                                SemanticsPropertiesKt.setStateDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo2);
                            }
                            final FocusRequester focusRequester2 = focusRequester;
                            SemanticsPropertiesKt.onClick$default(semanticsPropertyReceiver, null, new Function0<Boolean>() {
                                {
                                    super(0);
                                }

                                public final Boolean m2735invoke() {
                                    focusRequester2.requestFocus();
                                    return true;
                                }
                            }, 1, null);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierSemantics$default2 = SemanticsModifierKt.semantics$default(modifierOnFocusChanged2, false, (Function1) objRememberedValue3, 1, null);
                ProvidableCompositionLocal<TextStyle> localTextStyle4 = TextKt.getLocalTextStyle();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume6 = composerStartRestartGroup.consume(localTextStyle4);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                TextStyle textStyleMerge2 = ((TextStyle) objConsume6).merge(new TextStyle(j2, 0L, (FontWeight) null, (FontStyle) null, (FontSynthesis) null, (FontFamily) null, (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, 0, 0, 0L, (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16777214, (DefaultConstructorMarker) null));
                SolidColor solidColor2 = new SolidColor(textFieldColors2.m2939cursorColorvNxB06k$material3_release(false), null);
                KeyboardOptions keyboardOptions2 = new KeyboardOptions(0, (Boolean) null, 0, ImeAction.Companion.getSearch-eUduSuo(), (PlatformImeOptions) null, (Boolean) null, (LocaleList) null, 119, (DefaultConstructorMarker) null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320385353, "CC(remember):SearchBar.android.kt#9igjgp");
                if ((i4 & 896) == 256) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                i24 = i4 & 14;
                if (i24 == 4) {
                    z8 = true;
                } else {
                    z8 = false;
                }
                z9 = z7 | z8;
                objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                if (!z9) {
                    objRememberedValue4 = (Function1) new Function1<KeyboardActionScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((KeyboardActionScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(KeyboardActionScope keyboardActionScope) {
                            function2.invoke(str);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                } else {
                    objRememberedValue4 = (Function1) new Function1<KeyboardActionScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((KeyboardActionScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(KeyboardActionScope keyboardActionScope) {
                            function2.invoke(str);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i28 = i4;
                final boolean z14 = z4;
                final MutableInteractionSource mutableInteractionSource6 = mutableInteractionSource3;
                final Function2<? super Composer, ? super Integer, Unit> function17 = function10;
                final Function2<? super Composer, ? super Integer, Unit> function18 = function8;
                final Function2<? super Composer, ? super Integer, Unit> function19 = function9;
                final TextFieldColors textFieldColors6 = textFieldColors2;
                int i29 = i24 | 102236160 | (i28 & 112);
                int i210 = i28 >> 9;
                TextFieldColors textFieldColors7 = textFieldColors2;
                boolean z15 = z4;
                BasicTextFieldKt.BasicTextField(str, function1, modifierSemantics$default2, z15, false, textStyleMerge2, keyboardOptions2, new KeyboardActions(null, null, null, null, (Function1) objRememberedValue4, null, 47, null), true, 0, 0, (VisualTransformation) null, (Function1<? super TextLayoutResult, Unit>) null, mutableInteractionSource3, (Brush) solidColor2, (Function3<? super Function2<? super Composer, ? super Integer, Unit>, ? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(-2029278807, true, new Function3<Function2<? super Composer, ? super Integer, ? extends Unit>, Composer, Integer, Unit>() {
                    {
                        super(3);
                    }

                    public Object invoke(Object obj, Object obj2, Object obj3) {
                        invoke((Function2<? super Composer, ? super Integer, Unit>) obj, (Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Function2<? super Composer, ? super Integer, Unit> function110, Composer composer3, int i211) {
                        int i212;
                        ComposerKt.sourceInformation(composer3, "C557@26571L15,541@25683L1096:SearchBar.android.kt#uh7d8r");
                        if ((i211 & 6) == 0) {
                            i212 = i211 | (composer3.changedInstance(function110) ? 4 : 2);
                        } else {
                            i212 = i211;
                        }
                        if ((i212 & 19) != 18 || !composer3.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-2029278807, i212, -1, "androidx.compose.material3.SearchBarDefaults.InputField.<anonymous> (SearchBar.android.kt:541)");
                            }
                            TextFieldDefaults textFieldDefaults = TextFieldDefaults.INSTANCE;
                            String str2 = str;
                            boolean z16 = z14;
                            VisualTransformation none = VisualTransformation.Companion.getNone();
                            MutableInteractionSource mutableInteractionSource7 = mutableInteractionSource6;
                            Function2<Composer, Integer, Unit> function111 = function17;
                            final Function2<? super Composer, ? super Integer, Unit> function112 = function18;
                            composer3.startReplaceGroup(-1102017390);
                            ComposerKt.sourceInformation(composer3, "*551@26196L64");
                            ComposableLambda composableLambdaRememberComposableLambda = function112 == null ? null : ComposableLambdaKt.rememberComposableLambda(-1401341985, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer4, int i30) {
                                    ComposerKt.sourceInformation(composer4, "C551@26198L60:SearchBar.android.kt#uh7d8r");
                                    if ((i30 & 3) == 2 && composer4.getSkipping()) {
                                        composer4.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1401341985, i30, -1, "androidx.compose.material3.SearchBarDefaults.InputField.<anonymous>.<anonymous>.<anonymous> (SearchBar.android.kt:551)");
                                    }
                                    Modifier modifierM996offsetVpY3zN4$default = OffsetKt.m996offsetVpY3zN4$default(Modifier.INSTANCE, SearchBar_androidKt.SearchBarIconOffsetX, 0.0f, 2, null);
                                    Function2<Composer, Integer, Unit> function20 = function112;
                                    ComposerKt.sourceInformationMarkerStart(composer4, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer4, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer4, 0);
                                    CompositionLocalMap currentCompositionLocalMap = composer4.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer4, modifierM996offsetVpY3zN4$default);
                                    Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer4, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer4.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer4.startReusableNode();
                                    if (composer4.getInserting()) {
                                        composer4.createNode(constructor);
                                    } else {
                                        composer4.useNode();
                                    }
                                    Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer4);
                                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer4, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer4, -127763558, "C551@26247L9:SearchBar.android.kt#uh7d8r");
                                    function20.invoke(composer4, 0);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    composer4.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composer3, 54);
                            composer3.endReplaceGroup();
                            final Function2<? super Composer, ? super Integer, Unit> function20 = function19;
                            composer3.startReplaceGroup(-1102010155);
                            ComposerKt.sourceInformation(composer3, "*555@26423L66");
                            ComposableLambda composableLambdaRememberComposableLambda2 = function20 == null ? null : ComposableLambdaKt.rememberComposableLambda(907752083, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer4, int i30) {
                                    ComposerKt.sourceInformation(composer4, "C555@26425L62:SearchBar.android.kt#uh7d8r");
                                    if ((i30 & 3) == 2 && composer4.getSkipping()) {
                                        composer4.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(907752083, i30, -1, "androidx.compose.material3.SearchBarDefaults.InputField.<anonymous>.<anonymous>.<anonymous> (SearchBar.android.kt:555)");
                                    }
                                    Modifier modifierM996offsetVpY3zN4$default = OffsetKt.m996offsetVpY3zN4$default(Modifier.INSTANCE, Dp.constructor-impl(-SearchBar_androidKt.SearchBarIconOffsetX), 0.0f, 2, null);
                                    Function2<Composer, Integer, Unit> function21 = function20;
                                    ComposerKt.sourceInformationMarkerStart(composer4, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer4, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer4, 0);
                                    CompositionLocalMap currentCompositionLocalMap = composer4.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer4, modifierM996offsetVpY3zN4$default);
                                    Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer4, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer4.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer4.startReusableNode();
                                    if (composer4.getInserting()) {
                                        composer4.createNode(constructor);
                                    } else {
                                        composer4.useNode();
                                    }
                                    Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer4);
                                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer4, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer4, -127537351, "C555@26475L10:SearchBar.android.kt#uh7d8r");
                                    function21.invoke(composer4, 0);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    composer4.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composer3, 54);
                            composer3.endReplaceGroup();
                            textFieldDefaults.DecorationBox(str2, function110, z16, true, none, mutableInteractionSource7, false, null, function111, composableLambdaRememberComposableLambda, composableLambdaRememberComposableLambda2, null, null, null, SearchBarDefaults.INSTANCE.getInputFieldShape(composer3, 6), textFieldColors6, TextFieldDefaults.m2993contentPaddingWithoutLabela9UjIt4$default(TextFieldDefaults.INSTANCE, 0.0f, 0.0f, 0.0f, 0.0f, 15, null), ComposableSingletons$SearchBar_androidKt.INSTANCE.m2223getLambda1$material3_release(), composer3, ((i212 << 3) & 112) | 27648, 113246208, 14528);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer3.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, i29 | (i210 & 7168), 196608, 7696);
                if (z) {
                    z10 = false;
                } else {
                    z10 = false;
                }
                Boolean boolValueOf2 = Boolean.valueOf(z);
                composer2 = composerStartRestartGroup;
                ComposerKt.sourceInformationMarkerStart(composer2, -320340316, "CC(remember):SearchBar.android.kt#9igjgp");
                zChanged2 = composer2.changed(z10) | composer2.changedInstance(focusManager);
                objRememberedValue5 = composer2.rememberedValue();
                if (!zChanged2) {
                    objRememberedValue5 = (Function2) new SearchBarDefaults$InputField$5$1(z10, focusManager, null);
                    composer2.updateRememberedValue(objRememberedValue5);
                } else {
                    objRememberedValue5 = (Function2) new SearchBarDefaults$InputField$5$1(z10, focusManager, null);
                    composer2.updateRememberedValue(objRememberedValue5);
                }
                ComposerKt.sourceInformationMarkerEnd(composer2);
                EffectsKt.LaunchedEffect(boolValueOf2, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) objRememberedValue5, composer2, i210 & 14);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                function11 = function10;
                function12 = function8;
                function13 = function9;
                mutableInteractionSource4 = mutableInteractionSource2;
                textFieldColors3 = textFieldColors7;
                z11 = z15;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i12 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if (i14 != 0) {
                        function7 = null;
                    } else {
                        function7 = function4;
                    }
                    if (i16 != 0) {
                        function8 = null;
                    } else {
                        function8 = function5;
                    }
                    if (i18 != 0) {
                        function9 = null;
                    } else {
                        function9 = function6;
                    }
                    if ((i3 & Fields.RotationZ) != 0) {
                        textFieldColorsM2734inputFieldColorsITpI4ow = m2734inputFieldColorsITpI4ow(0L, 0L, 0L, 0L, null, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, composerStartRestartGroup, 0, (i23 << 6) & 57344, 16383);
                        i23 &= -15;
                    } else {
                        textFieldColorsM2734inputFieldColorsITpI4ow = textFieldColors;
                    }
                    function10 = function7;
                    if (i21 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    textFieldColors2 = textFieldColorsM2734inputFieldColorsITpI4ow;
                    z4 = z3;
                } else {
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i12 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if (i14 != 0) {
                        function7 = null;
                    } else {
                        function7 = function4;
                    }
                    if (i16 != 0) {
                        function8 = null;
                    } else {
                        function8 = function5;
                    }
                    if (i18 != 0) {
                        function9 = null;
                    } else {
                        function9 = function6;
                    }
                    if ((i3 & Fields.RotationZ) != 0) {
                        textFieldColorsM2734inputFieldColorsITpI4ow = m2734inputFieldColorsITpI4ow(0L, 0L, 0L, 0L, null, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, composerStartRestartGroup, 0, (i23 << 6) & 57344, 16383);
                        i23 &= -15;
                    } else {
                        textFieldColorsM2734inputFieldColorsITpI4ow = textFieldColors;
                    }
                    function10 = function7;
                    if (i21 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    textFieldColors2 = textFieldColorsM2734inputFieldColorsITpI4ow;
                    z4 = z3;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1451366815, i4, i23, "androidx.compose.material3.SearchBarDefaults.InputField (SearchBar.android.kt:494)");
                }
                composerStartRestartGroup.startReplaceGroup(-320443616);
                ComposerKt.sourceInformation(composerStartRestartGroup, "496@23695L39");
                if (mutableInteractionSource2 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320442965, "CC(remember):SearchBar.android.kt#9igjgp");
                    objRememberedValue6 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue6 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue6 = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue6);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue6;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                composerStartRestartGroup.endReplaceGroup();
                zBooleanValue = FocusInteractionKt.collectIsFocusedAsState(mutableInteractionSource3, composerStartRestartGroup, 0).getValue().booleanValue();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320438431, "CC(remember):SearchBar.android.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = new FocusRequester();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                focusRequester = (FocusRequester) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<FocusManager> localFocusManager3 = CompositionLocalsKt.getLocalFocusManager();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume7 = composerStartRestartGroup.consume(localFocusManager3);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                focusManager = (FocusManager) objConsume7;
                Strings.Companion companion6 = Strings.INSTANCE;
                strM3334getString2EP1pXo = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_search_bar_search), composerStartRestartGroup, 0);
                Strings.Companion companion7 = Strings.INSTANCE;
                strM3334getString2EP1pXo2 = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_suggestions_available), composerStartRestartGroup, 0);
                ProvidableCompositionLocal<TextStyle> localTextStyle5 = TextKt.getLocalTextStyle();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume8 = composerStartRestartGroup.consume(localTextStyle5);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                jM2989textColorXeAY9LY$material3_release = ((TextStyle) objConsume8).getColor-0d7_KjU();
                if (jM2989textColorXeAY9LY$material3_release == 16) {
                    jM2989textColorXeAY9LY$material3_release = textFieldColors2.m2989textColorXeAY9LY$material3_release(z4, false, zBooleanValue);
                }
                long j3 = jM2989textColorXeAY9LY$material3_release;
                Modifier modifierFocusRequester3 = FocusRequesterModifierKt.focusRequester(SizeKt.m1084sizeInqDBjuR0$default(companion, SearchBar_androidKt.getSearchBarMinWidth(), InputFieldHeight, SearchBar_androidKt.SearchBarMaxWidth, 0.0f, 8, null), focusRequester);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320411280, "CC(remember):SearchBar.android.kt#9igjgp");
                if ((57344 & i4) == 16384) {
                    z5 = true;
                } else {
                    z5 = false;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z5) {
                    objRememberedValue2 = (Function1) new Function1<FocusState, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((FocusState) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(FocusState focusState) {
                            if (focusState.isFocused()) {
                                function3.invoke(true);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<FocusState, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((FocusState) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(FocusState focusState) {
                            if (focusState.isFocused()) {
                                function3.invoke(true);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierOnFocusChanged3 = FocusChangedModifierKt.onFocusChanged(modifierFocusRequester3, (Function1) objRememberedValue2);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320408514, "CC(remember):SearchBar.android.kt#9igjgp");
                boolean zChanged5 = composerStartRestartGroup.changed(strM3334getString2EP1pXo);
                if ((i4 & 7168) == 2048) {
                    z6 = true;
                } else {
                    z6 = false;
                }
                zChanged = z6 | zChanged5 | composerStartRestartGroup.changed(strM3334getString2EP1pXo2);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo);
                            if (z) {
                                SemanticsPropertiesKt.setStateDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo2);
                            }
                            final FocusRequester focusRequester2 = focusRequester;
                            SemanticsPropertiesKt.onClick$default(semanticsPropertyReceiver, null, new Function0<Boolean>() {
                                {
                                    super(0);
                                }

                                public final Boolean m2735invoke() {
                                    focusRequester2.requestFocus();
                                    return true;
                                }
                            }, 1, null);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo);
                            if (z) {
                                SemanticsPropertiesKt.setStateDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo2);
                            }
                            final FocusRequester focusRequester2 = focusRequester;
                            SemanticsPropertiesKt.onClick$default(semanticsPropertyReceiver, null, new Function0<Boolean>() {
                                {
                                    super(0);
                                }

                                public final Boolean m2735invoke() {
                                    focusRequester2.requestFocus();
                                    return true;
                                }
                            }, 1, null);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierSemantics$default3 = SemanticsModifierKt.semantics$default(modifierOnFocusChanged3, false, (Function1) objRememberedValue3, 1, null);
                ProvidableCompositionLocal<TextStyle> localTextStyle6 = TextKt.getLocalTextStyle();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume9 = composerStartRestartGroup.consume(localTextStyle6);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                TextStyle textStyleMerge3 = ((TextStyle) objConsume9).merge(new TextStyle(j3, 0L, (FontWeight) null, (FontStyle) null, (FontSynthesis) null, (FontFamily) null, (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, 0, 0, 0L, (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16777214, (DefaultConstructorMarker) null));
                SolidColor solidColor3 = new SolidColor(textFieldColors2.m2939cursorColorvNxB06k$material3_release(false), null);
                KeyboardOptions keyboardOptions3 = new KeyboardOptions(0, (Boolean) null, 0, ImeAction.Companion.getSearch-eUduSuo(), (PlatformImeOptions) null, (Boolean) null, (LocaleList) null, 119, (DefaultConstructorMarker) null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320385353, "CC(remember):SearchBar.android.kt#9igjgp");
                if ((i4 & 896) == 256) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                i24 = i4 & 14;
                if (i24 == 4) {
                    z8 = true;
                } else {
                    z8 = false;
                }
                z9 = z7 | z8;
                objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                if (!z9) {
                    objRememberedValue4 = (Function1) new Function1<KeyboardActionScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((KeyboardActionScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(KeyboardActionScope keyboardActionScope) {
                            function2.invoke(str);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                } else {
                    objRememberedValue4 = (Function1) new Function1<KeyboardActionScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((KeyboardActionScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(KeyboardActionScope keyboardActionScope) {
                            function2.invoke(str);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i211 = i4;
                final boolean z16 = z4;
                final MutableInteractionSource mutableInteractionSource7 = mutableInteractionSource3;
                final Function2<? super Composer, ? super Integer, Unit> function110 = function10;
                final Function2<? super Composer, ? super Integer, Unit> function111 = function8;
                final Function2<? super Composer, ? super Integer, Unit> function112 = function9;
                final TextFieldColors textFieldColors8 = textFieldColors2;
                int i212 = i24 | 102236160 | (i211 & 112);
                int i213 = i211 >> 9;
                TextFieldColors textFieldColors9 = textFieldColors2;
                boolean z17 = z4;
                BasicTextFieldKt.BasicTextField(str, function1, modifierSemantics$default3, z17, false, textStyleMerge3, keyboardOptions3, new KeyboardActions(null, null, null, null, (Function1) objRememberedValue4, null, 47, null), true, 0, 0, (VisualTransformation) null, (Function1<? super TextLayoutResult, Unit>) null, mutableInteractionSource3, (Brush) solidColor3, (Function3<? super Function2<? super Composer, ? super Integer, Unit>, ? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(-2029278807, true, new Function3<Function2<? super Composer, ? super Integer, ? extends Unit>, Composer, Integer, Unit>() {
                    {
                        super(3);
                    }

                    public Object invoke(Object obj, Object obj2, Object obj3) {
                        invoke((Function2<? super Composer, ? super Integer, Unit>) obj, (Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Function2<? super Composer, ? super Integer, Unit> function113, Composer composer3, int i214) {
                        int i215;
                        ComposerKt.sourceInformation(composer3, "C557@26571L15,541@25683L1096:SearchBar.android.kt#uh7d8r");
                        if ((i214 & 6) == 0) {
                            i215 = i214 | (composer3.changedInstance(function113) ? 4 : 2);
                        } else {
                            i215 = i214;
                        }
                        if ((i215 & 19) != 18 || !composer3.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-2029278807, i215, -1, "androidx.compose.material3.SearchBarDefaults.InputField.<anonymous> (SearchBar.android.kt:541)");
                            }
                            TextFieldDefaults textFieldDefaults = TextFieldDefaults.INSTANCE;
                            String str2 = str;
                            boolean z18 = z16;
                            VisualTransformation none = VisualTransformation.Companion.getNone();
                            MutableInteractionSource mutableInteractionSource8 = mutableInteractionSource7;
                            Function2<Composer, Integer, Unit> function114 = function110;
                            final Function2<? super Composer, ? super Integer, Unit> function115 = function111;
                            composer3.startReplaceGroup(-1102017390);
                            ComposerKt.sourceInformation(composer3, "*551@26196L64");
                            ComposableLambda composableLambdaRememberComposableLambda = function115 == null ? null : ComposableLambdaKt.rememberComposableLambda(-1401341985, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer4, int i30) {
                                    ComposerKt.sourceInformation(composer4, "C551@26198L60:SearchBar.android.kt#uh7d8r");
                                    if ((i30 & 3) == 2 && composer4.getSkipping()) {
                                        composer4.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1401341985, i30, -1, "androidx.compose.material3.SearchBarDefaults.InputField.<anonymous>.<anonymous>.<anonymous> (SearchBar.android.kt:551)");
                                    }
                                    Modifier modifierM996offsetVpY3zN4$default = OffsetKt.m996offsetVpY3zN4$default(Modifier.INSTANCE, SearchBar_androidKt.SearchBarIconOffsetX, 0.0f, 2, null);
                                    Function2<Composer, Integer, Unit> function20 = function115;
                                    ComposerKt.sourceInformationMarkerStart(composer4, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer4, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer4, 0);
                                    CompositionLocalMap currentCompositionLocalMap = composer4.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer4, modifierM996offsetVpY3zN4$default);
                                    Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer4, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer4.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer4.startReusableNode();
                                    if (composer4.getInserting()) {
                                        composer4.createNode(constructor);
                                    } else {
                                        composer4.useNode();
                                    }
                                    Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer4);
                                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer4, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer4, -127763558, "C551@26247L9:SearchBar.android.kt#uh7d8r");
                                    function20.invoke(composer4, 0);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    composer4.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composer3, 54);
                            composer3.endReplaceGroup();
                            final Function2<? super Composer, ? super Integer, Unit> function20 = function112;
                            composer3.startReplaceGroup(-1102010155);
                            ComposerKt.sourceInformation(composer3, "*555@26423L66");
                            ComposableLambda composableLambdaRememberComposableLambda2 = function20 == null ? null : ComposableLambdaKt.rememberComposableLambda(907752083, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer4, int i30) {
                                    ComposerKt.sourceInformation(composer4, "C555@26425L62:SearchBar.android.kt#uh7d8r");
                                    if ((i30 & 3) == 2 && composer4.getSkipping()) {
                                        composer4.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(907752083, i30, -1, "androidx.compose.material3.SearchBarDefaults.InputField.<anonymous>.<anonymous>.<anonymous> (SearchBar.android.kt:555)");
                                    }
                                    Modifier modifierM996offsetVpY3zN4$default = OffsetKt.m996offsetVpY3zN4$default(Modifier.INSTANCE, Dp.constructor-impl(-SearchBar_androidKt.SearchBarIconOffsetX), 0.0f, 2, null);
                                    Function2<Composer, Integer, Unit> function21 = function20;
                                    ComposerKt.sourceInformationMarkerStart(composer4, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer4, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer4, 0);
                                    CompositionLocalMap currentCompositionLocalMap = composer4.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer4, modifierM996offsetVpY3zN4$default);
                                    Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer4, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer4.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer4.startReusableNode();
                                    if (composer4.getInserting()) {
                                        composer4.createNode(constructor);
                                    } else {
                                        composer4.useNode();
                                    }
                                    Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer4);
                                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer4, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer4, -127537351, "C555@26475L10:SearchBar.android.kt#uh7d8r");
                                    function21.invoke(composer4, 0);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    composer4.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composer3, 54);
                            composer3.endReplaceGroup();
                            textFieldDefaults.DecorationBox(str2, function113, z18, true, none, mutableInteractionSource8, false, null, function114, composableLambdaRememberComposableLambda, composableLambdaRememberComposableLambda2, null, null, null, SearchBarDefaults.INSTANCE.getInputFieldShape(composer3, 6), textFieldColors8, TextFieldDefaults.m2993contentPaddingWithoutLabela9UjIt4$default(TextFieldDefaults.INSTANCE, 0.0f, 0.0f, 0.0f, 0.0f, 15, null), ComposableSingletons$SearchBar_androidKt.INSTANCE.m2223getLambda1$material3_release(), composer3, ((i215 << 3) & 112) | 27648, 113246208, 14528);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer3.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, i212 | (i213 & 7168), 196608, 7696);
                if (z) {
                    z10 = false;
                } else {
                    z10 = false;
                }
                Boolean boolValueOf3 = Boolean.valueOf(z);
                composer2 = composerStartRestartGroup;
                ComposerKt.sourceInformationMarkerStart(composer2, -320340316, "CC(remember):SearchBar.android.kt#9igjgp");
                zChanged2 = composer2.changed(z10) | composer2.changedInstance(focusManager);
                objRememberedValue5 = composer2.rememberedValue();
                if (!zChanged2) {
                    objRememberedValue5 = (Function2) new SearchBarDefaults$InputField$5$1(z10, focusManager, null);
                    composer2.updateRememberedValue(objRememberedValue5);
                } else {
                    objRememberedValue5 = (Function2) new SearchBarDefaults$InputField$5$1(z10, focusManager, null);
                    composer2.updateRememberedValue(objRememberedValue5);
                }
                ComposerKt.sourceInformationMarkerEnd(composer2);
                EffectsKt.LaunchedEffect(boolValueOf3, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) objRememberedValue5, composer2, i213 & 14);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                function11 = function10;
                function12 = function8;
                function13 = function9;
                mutableInteractionSource4 = mutableInteractionSource2;
                textFieldColors3 = textFieldColors9;
                z11 = z17;
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

                    public final void invoke(Composer composer3, int i214) {
                        SearchBarDefaults.this.InputField(str, function1, function2, z, function3, modifier2, z11, function11, function12, function13, textFieldColors3, mutableInteractionSource4, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                    }
                });
            }
        }
        i4 |= 48;
        i5 = i3 & 4;
        i6 = Fields.SpotShadowColor;
        if (i5 != 0) {
            i4 |= 384;
        } else if ((i & 384) == 0) {
            if (composerStartRestartGroup.changedInstance(function2)) {
                i7 = Fields.RotationX;
            } else {
                i7 = 128;
            }
            i4 |= i7;
        }
        if ((i3 & 8) != 0) {
            i4 |= 3072;
        } else if ((i & 3072) == 0) {
            if (composerStartRestartGroup.changed(z)) {
                i8 = Fields.CameraDistance;
            } else {
                i8 = Fields.RotationZ;
            }
            i4 |= i8;
        }
        if ((i3 & 16) != 0) {
            i4 |= 24576;
        } else if ((i & 24576) == 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i9 = Fields.Clip;
            } else {
                i9 = Fields.Shape;
            }
            i4 |= i9;
        }
        i10 = i3 & 32;
        if (i10 != 0) {
            i4 |= 196608;
        } else if ((i & 196608) == 0) {
            if (composerStartRestartGroup.changed(modifier)) {
                i11 = Fields.RenderEffect;
            } else {
                i11 = 65536;
            }
            i4 |= i11;
        }
        i12 = i3 & 64;
        if (i12 != 0) {
            i4 |= 1572864;
        } else if ((i & 1572864) == 0) {
            if (composerStartRestartGroup.changed(z2)) {
                i13 = 1048576;
            } else {
                i13 = 524288;
            }
            i4 |= i13;
        }
        i14 = i3 & Fields.SpotShadowColor;
        if (i14 != 0) {
            i4 |= 12582912;
        } else if ((i & 12582912) == 0) {
            if (composerStartRestartGroup.changedInstance(function4)) {
                i15 = 8388608;
            } else {
                i15 = 4194304;
            }
            i4 |= i15;
        }
        i16 = i3 & Fields.RotationX;
        if (i16 != 0) {
            i4 |= 100663296;
        } else if ((i & 100663296) == 0) {
            if (composerStartRestartGroup.changedInstance(function5)) {
                i17 = 67108864;
            } else {
                i17 = 33554432;
            }
            i4 |= i17;
        }
        i18 = i3 & Fields.RotationY;
        if (i18 != 0) {
            i4 |= 805306368;
        } else if ((i & 805306368) == 0) {
            if (composerStartRestartGroup.changedInstance(function6)) {
                i19 = 536870912;
            } else {
                i19 = 268435456;
            }
            i4 |= i19;
        }
        if ((i2 & 6) == 0) {
            i20 = i2 | (((i3 & Fields.RotationZ) == 0 || !composerStartRestartGroup.changed(textFieldColors)) ? 2 : 4);
        } else {
            i20 = i2;
        }
        i21 = i3 & Fields.CameraDistance;
        if (i21 != 0) {
            i20 |= 48;
        } else if ((i2 & 48) == 0) {
            if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                i22 = 32;
            } else {
                i22 = 16;
            }
            i20 |= i22;
        }
        i23 = i20;
        if ((i3 & Fields.TransformOrigin) != 0) {
            if ((i2 & 384) == 0) {
                if (composerStartRestartGroup.changed(this)) {
                    i6 = Fields.RotationX;
                }
                i23 |= i6;
            }
            if ((i4 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i12 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if (i14 != 0) {
                        function7 = null;
                    } else {
                        function7 = function4;
                    }
                    if (i16 != 0) {
                        function8 = null;
                    } else {
                        function8 = function5;
                    }
                    if (i18 != 0) {
                        function9 = null;
                    } else {
                        function9 = function6;
                    }
                    if ((i3 & Fields.RotationZ) != 0) {
                        textFieldColorsM2734inputFieldColorsITpI4ow = m2734inputFieldColorsITpI4ow(0L, 0L, 0L, 0L, null, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, composerStartRestartGroup, 0, (i23 << 6) & 57344, 16383);
                        i23 &= -15;
                    } else {
                        textFieldColorsM2734inputFieldColorsITpI4ow = textFieldColors;
                    }
                    function10 = function7;
                    if (i21 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    textFieldColors2 = textFieldColorsM2734inputFieldColorsITpI4ow;
                    z4 = z3;
                } else {
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i12 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if (i14 != 0) {
                        function7 = null;
                    } else {
                        function7 = function4;
                    }
                    if (i16 != 0) {
                        function8 = null;
                    } else {
                        function8 = function5;
                    }
                    if (i18 != 0) {
                        function9 = null;
                    } else {
                        function9 = function6;
                    }
                    if ((i3 & Fields.RotationZ) != 0) {
                        textFieldColorsM2734inputFieldColorsITpI4ow = m2734inputFieldColorsITpI4ow(0L, 0L, 0L, 0L, null, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, composerStartRestartGroup, 0, (i23 << 6) & 57344, 16383);
                        i23 &= -15;
                    } else {
                        textFieldColorsM2734inputFieldColorsITpI4ow = textFieldColors;
                    }
                    function10 = function7;
                    if (i21 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    textFieldColors2 = textFieldColorsM2734inputFieldColorsITpI4ow;
                    z4 = z3;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1451366815, i4, i23, "androidx.compose.material3.SearchBarDefaults.InputField (SearchBar.android.kt:494)");
                }
                composerStartRestartGroup.startReplaceGroup(-320443616);
                ComposerKt.sourceInformation(composerStartRestartGroup, "496@23695L39");
                if (mutableInteractionSource2 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320442965, "CC(remember):SearchBar.android.kt#9igjgp");
                    objRememberedValue6 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue6 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue6 = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue6);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue6;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                composerStartRestartGroup.endReplaceGroup();
                zBooleanValue = FocusInteractionKt.collectIsFocusedAsState(mutableInteractionSource3, composerStartRestartGroup, 0).getValue().booleanValue();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320438431, "CC(remember):SearchBar.android.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = new FocusRequester();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                focusRequester = (FocusRequester) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<FocusManager> localFocusManager4 = CompositionLocalsKt.getLocalFocusManager();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume10 = composerStartRestartGroup.consume(localFocusManager4);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                focusManager = (FocusManager) objConsume10;
                Strings.Companion companion8 = Strings.INSTANCE;
                strM3334getString2EP1pXo = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_search_bar_search), composerStartRestartGroup, 0);
                Strings.Companion companion9 = Strings.INSTANCE;
                strM3334getString2EP1pXo2 = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_suggestions_available), composerStartRestartGroup, 0);
                ProvidableCompositionLocal<TextStyle> localTextStyle7 = TextKt.getLocalTextStyle();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume11 = composerStartRestartGroup.consume(localTextStyle7);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                jM2989textColorXeAY9LY$material3_release = ((TextStyle) objConsume11).getColor-0d7_KjU();
                if (jM2989textColorXeAY9LY$material3_release == 16) {
                    jM2989textColorXeAY9LY$material3_release = textFieldColors2.m2989textColorXeAY9LY$material3_release(z4, false, zBooleanValue);
                }
                long j4 = jM2989textColorXeAY9LY$material3_release;
                Modifier modifierFocusRequester4 = FocusRequesterModifierKt.focusRequester(SizeKt.m1084sizeInqDBjuR0$default(companion, SearchBar_androidKt.getSearchBarMinWidth(), InputFieldHeight, SearchBar_androidKt.SearchBarMaxWidth, 0.0f, 8, null), focusRequester);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320411280, "CC(remember):SearchBar.android.kt#9igjgp");
                if ((57344 & i4) == 16384) {
                    z5 = true;
                } else {
                    z5 = false;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z5) {
                    objRememberedValue2 = (Function1) new Function1<FocusState, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((FocusState) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(FocusState focusState) {
                            if (focusState.isFocused()) {
                                function3.invoke(true);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<FocusState, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((FocusState) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(FocusState focusState) {
                            if (focusState.isFocused()) {
                                function3.invoke(true);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierOnFocusChanged4 = FocusChangedModifierKt.onFocusChanged(modifierFocusRequester4, (Function1) objRememberedValue2);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320408514, "CC(remember):SearchBar.android.kt#9igjgp");
                boolean zChanged6 = composerStartRestartGroup.changed(strM3334getString2EP1pXo);
                if ((i4 & 7168) == 2048) {
                    z6 = true;
                } else {
                    z6 = false;
                }
                zChanged = z6 | zChanged6 | composerStartRestartGroup.changed(strM3334getString2EP1pXo2);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo);
                            if (z) {
                                SemanticsPropertiesKt.setStateDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo2);
                            }
                            final FocusRequester focusRequester2 = focusRequester;
                            SemanticsPropertiesKt.onClick$default(semanticsPropertyReceiver, null, new Function0<Boolean>() {
                                {
                                    super(0);
                                }

                                public final Boolean m2735invoke() {
                                    focusRequester2.requestFocus();
                                    return true;
                                }
                            }, 1, null);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo);
                            if (z) {
                                SemanticsPropertiesKt.setStateDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo2);
                            }
                            final FocusRequester focusRequester2 = focusRequester;
                            SemanticsPropertiesKt.onClick$default(semanticsPropertyReceiver, null, new Function0<Boolean>() {
                                {
                                    super(0);
                                }

                                public final Boolean m2735invoke() {
                                    focusRequester2.requestFocus();
                                    return true;
                                }
                            }, 1, null);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierSemantics$default4 = SemanticsModifierKt.semantics$default(modifierOnFocusChanged4, false, (Function1) objRememberedValue3, 1, null);
                ProvidableCompositionLocal<TextStyle> localTextStyle8 = TextKt.getLocalTextStyle();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume12 = composerStartRestartGroup.consume(localTextStyle8);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                TextStyle textStyleMerge4 = ((TextStyle) objConsume12).merge(new TextStyle(j4, 0L, (FontWeight) null, (FontStyle) null, (FontSynthesis) null, (FontFamily) null, (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, 0, 0, 0L, (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16777214, (DefaultConstructorMarker) null));
                SolidColor solidColor4 = new SolidColor(textFieldColors2.m2939cursorColorvNxB06k$material3_release(false), null);
                KeyboardOptions keyboardOptions4 = new KeyboardOptions(0, (Boolean) null, 0, ImeAction.Companion.getSearch-eUduSuo(), (PlatformImeOptions) null, (Boolean) null, (LocaleList) null, 119, (DefaultConstructorMarker) null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320385353, "CC(remember):SearchBar.android.kt#9igjgp");
                if ((i4 & 896) == 256) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                i24 = i4 & 14;
                if (i24 == 4) {
                    z8 = true;
                } else {
                    z8 = false;
                }
                z9 = z7 | z8;
                objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                if (!z9) {
                    objRememberedValue4 = (Function1) new Function1<KeyboardActionScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((KeyboardActionScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(KeyboardActionScope keyboardActionScope) {
                            function2.invoke(str);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                } else {
                    objRememberedValue4 = (Function1) new Function1<KeyboardActionScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((KeyboardActionScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(KeyboardActionScope keyboardActionScope) {
                            function2.invoke(str);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i214 = i4;
                final boolean z18 = z4;
                final MutableInteractionSource mutableInteractionSource8 = mutableInteractionSource3;
                final Function2<? super Composer, ? super Integer, Unit> function113 = function10;
                final Function2<? super Composer, ? super Integer, Unit> function114 = function8;
                final Function2<? super Composer, ? super Integer, Unit> function115 = function9;
                final TextFieldColors textFieldColors10 = textFieldColors2;
                int i215 = i24 | 102236160 | (i214 & 112);
                int i216 = i214 >> 9;
                TextFieldColors textFieldColors11 = textFieldColors2;
                boolean z19 = z4;
                BasicTextFieldKt.BasicTextField(str, function1, modifierSemantics$default4, z19, false, textStyleMerge4, keyboardOptions4, new KeyboardActions(null, null, null, null, (Function1) objRememberedValue4, null, 47, null), true, 0, 0, (VisualTransformation) null, (Function1<? super TextLayoutResult, Unit>) null, mutableInteractionSource3, (Brush) solidColor4, (Function3<? super Function2<? super Composer, ? super Integer, Unit>, ? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(-2029278807, true, new Function3<Function2<? super Composer, ? super Integer, ? extends Unit>, Composer, Integer, Unit>() {
                    {
                        super(3);
                    }

                    public Object invoke(Object obj, Object obj2, Object obj3) {
                        invoke((Function2<? super Composer, ? super Integer, Unit>) obj, (Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Function2<? super Composer, ? super Integer, Unit> function116, Composer composer3, int i217) {
                        int i218;
                        ComposerKt.sourceInformation(composer3, "C557@26571L15,541@25683L1096:SearchBar.android.kt#uh7d8r");
                        if ((i217 & 6) == 0) {
                            i218 = i217 | (composer3.changedInstance(function116) ? 4 : 2);
                        } else {
                            i218 = i217;
                        }
                        if ((i218 & 19) != 18 || !composer3.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-2029278807, i218, -1, "androidx.compose.material3.SearchBarDefaults.InputField.<anonymous> (SearchBar.android.kt:541)");
                            }
                            TextFieldDefaults textFieldDefaults = TextFieldDefaults.INSTANCE;
                            String str2 = str;
                            boolean z110 = z18;
                            VisualTransformation none = VisualTransformation.Companion.getNone();
                            MutableInteractionSource mutableInteractionSource9 = mutableInteractionSource8;
                            Function2<Composer, Integer, Unit> function117 = function113;
                            final Function2<? super Composer, ? super Integer, Unit> function118 = function114;
                            composer3.startReplaceGroup(-1102017390);
                            ComposerKt.sourceInformation(composer3, "*551@26196L64");
                            ComposableLambda composableLambdaRememberComposableLambda = function118 == null ? null : ComposableLambdaKt.rememberComposableLambda(-1401341985, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer4, int i30) {
                                    ComposerKt.sourceInformation(composer4, "C551@26198L60:SearchBar.android.kt#uh7d8r");
                                    if ((i30 & 3) == 2 && composer4.getSkipping()) {
                                        composer4.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1401341985, i30, -1, "androidx.compose.material3.SearchBarDefaults.InputField.<anonymous>.<anonymous>.<anonymous> (SearchBar.android.kt:551)");
                                    }
                                    Modifier modifierM996offsetVpY3zN4$default = OffsetKt.m996offsetVpY3zN4$default(Modifier.INSTANCE, SearchBar_androidKt.SearchBarIconOffsetX, 0.0f, 2, null);
                                    Function2<Composer, Integer, Unit> function20 = function118;
                                    ComposerKt.sourceInformationMarkerStart(composer4, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer4, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer4, 0);
                                    CompositionLocalMap currentCompositionLocalMap = composer4.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer4, modifierM996offsetVpY3zN4$default);
                                    Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer4, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer4.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer4.startReusableNode();
                                    if (composer4.getInserting()) {
                                        composer4.createNode(constructor);
                                    } else {
                                        composer4.useNode();
                                    }
                                    Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer4);
                                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer4, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer4, -127763558, "C551@26247L9:SearchBar.android.kt#uh7d8r");
                                    function20.invoke(composer4, 0);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    composer4.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composer3, 54);
                            composer3.endReplaceGroup();
                            final Function2<? super Composer, ? super Integer, Unit> function20 = function115;
                            composer3.startReplaceGroup(-1102010155);
                            ComposerKt.sourceInformation(composer3, "*555@26423L66");
                            ComposableLambda composableLambdaRememberComposableLambda2 = function20 == null ? null : ComposableLambdaKt.rememberComposableLambda(907752083, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer4, int i30) {
                                    ComposerKt.sourceInformation(composer4, "C555@26425L62:SearchBar.android.kt#uh7d8r");
                                    if ((i30 & 3) == 2 && composer4.getSkipping()) {
                                        composer4.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(907752083, i30, -1, "androidx.compose.material3.SearchBarDefaults.InputField.<anonymous>.<anonymous>.<anonymous> (SearchBar.android.kt:555)");
                                    }
                                    Modifier modifierM996offsetVpY3zN4$default = OffsetKt.m996offsetVpY3zN4$default(Modifier.INSTANCE, Dp.constructor-impl(-SearchBar_androidKt.SearchBarIconOffsetX), 0.0f, 2, null);
                                    Function2<Composer, Integer, Unit> function21 = function20;
                                    ComposerKt.sourceInformationMarkerStart(composer4, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer4, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer4, 0);
                                    CompositionLocalMap currentCompositionLocalMap = composer4.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer4, modifierM996offsetVpY3zN4$default);
                                    Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer4, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer4.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer4.startReusableNode();
                                    if (composer4.getInserting()) {
                                        composer4.createNode(constructor);
                                    } else {
                                        composer4.useNode();
                                    }
                                    Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer4);
                                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer4, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer4, -127537351, "C555@26475L10:SearchBar.android.kt#uh7d8r");
                                    function21.invoke(composer4, 0);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    composer4.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composer3, 54);
                            composer3.endReplaceGroup();
                            textFieldDefaults.DecorationBox(str2, function116, z110, true, none, mutableInteractionSource9, false, null, function117, composableLambdaRememberComposableLambda, composableLambdaRememberComposableLambda2, null, null, null, SearchBarDefaults.INSTANCE.getInputFieldShape(composer3, 6), textFieldColors10, TextFieldDefaults.m2993contentPaddingWithoutLabela9UjIt4$default(TextFieldDefaults.INSTANCE, 0.0f, 0.0f, 0.0f, 0.0f, 15, null), ComposableSingletons$SearchBar_androidKt.INSTANCE.m2223getLambda1$material3_release(), composer3, ((i218 << 3) & 112) | 27648, 113246208, 14528);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer3.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, i215 | (i216 & 7168), 196608, 7696);
                if (z) {
                    z10 = false;
                } else {
                    z10 = false;
                }
                Boolean boolValueOf4 = Boolean.valueOf(z);
                composer2 = composerStartRestartGroup;
                ComposerKt.sourceInformationMarkerStart(composer2, -320340316, "CC(remember):SearchBar.android.kt#9igjgp");
                zChanged2 = composer2.changed(z10) | composer2.changedInstance(focusManager);
                objRememberedValue5 = composer2.rememberedValue();
                if (!zChanged2) {
                    objRememberedValue5 = (Function2) new SearchBarDefaults$InputField$5$1(z10, focusManager, null);
                    composer2.updateRememberedValue(objRememberedValue5);
                } else {
                    objRememberedValue5 = (Function2) new SearchBarDefaults$InputField$5$1(z10, focusManager, null);
                    composer2.updateRememberedValue(objRememberedValue5);
                }
                ComposerKt.sourceInformationMarkerEnd(composer2);
                EffectsKt.LaunchedEffect(boolValueOf4, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) objRememberedValue5, composer2, i216 & 14);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                function11 = function10;
                function12 = function8;
                function13 = function9;
                mutableInteractionSource4 = mutableInteractionSource2;
                textFieldColors3 = textFieldColors11;
                z11 = z19;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i12 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if (i14 != 0) {
                        function7 = null;
                    } else {
                        function7 = function4;
                    }
                    if (i16 != 0) {
                        function8 = null;
                    } else {
                        function8 = function5;
                    }
                    if (i18 != 0) {
                        function9 = null;
                    } else {
                        function9 = function6;
                    }
                    if ((i3 & Fields.RotationZ) != 0) {
                        textFieldColorsM2734inputFieldColorsITpI4ow = m2734inputFieldColorsITpI4ow(0L, 0L, 0L, 0L, null, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, composerStartRestartGroup, 0, (i23 << 6) & 57344, 16383);
                        i23 &= -15;
                    } else {
                        textFieldColorsM2734inputFieldColorsITpI4ow = textFieldColors;
                    }
                    function10 = function7;
                    if (i21 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    textFieldColors2 = textFieldColorsM2734inputFieldColorsITpI4ow;
                    z4 = z3;
                } else {
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i12 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if (i14 != 0) {
                        function7 = null;
                    } else {
                        function7 = function4;
                    }
                    if (i16 != 0) {
                        function8 = null;
                    } else {
                        function8 = function5;
                    }
                    if (i18 != 0) {
                        function9 = null;
                    } else {
                        function9 = function6;
                    }
                    if ((i3 & Fields.RotationZ) != 0) {
                        textFieldColorsM2734inputFieldColorsITpI4ow = m2734inputFieldColorsITpI4ow(0L, 0L, 0L, 0L, null, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, composerStartRestartGroup, 0, (i23 << 6) & 57344, 16383);
                        i23 &= -15;
                    } else {
                        textFieldColorsM2734inputFieldColorsITpI4ow = textFieldColors;
                    }
                    function10 = function7;
                    if (i21 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    textFieldColors2 = textFieldColorsM2734inputFieldColorsITpI4ow;
                    z4 = z3;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1451366815, i4, i23, "androidx.compose.material3.SearchBarDefaults.InputField (SearchBar.android.kt:494)");
                }
                composerStartRestartGroup.startReplaceGroup(-320443616);
                ComposerKt.sourceInformation(composerStartRestartGroup, "496@23695L39");
                if (mutableInteractionSource2 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320442965, "CC(remember):SearchBar.android.kt#9igjgp");
                    objRememberedValue6 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue6 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue6 = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue6);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue6;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                composerStartRestartGroup.endReplaceGroup();
                zBooleanValue = FocusInteractionKt.collectIsFocusedAsState(mutableInteractionSource3, composerStartRestartGroup, 0).getValue().booleanValue();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320438431, "CC(remember):SearchBar.android.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = new FocusRequester();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                focusRequester = (FocusRequester) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<FocusManager> localFocusManager5 = CompositionLocalsKt.getLocalFocusManager();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume13 = composerStartRestartGroup.consume(localFocusManager5);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                focusManager = (FocusManager) objConsume13;
                Strings.Companion companion10 = Strings.INSTANCE;
                strM3334getString2EP1pXo = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_search_bar_search), composerStartRestartGroup, 0);
                Strings.Companion companion11 = Strings.INSTANCE;
                strM3334getString2EP1pXo2 = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_suggestions_available), composerStartRestartGroup, 0);
                ProvidableCompositionLocal<TextStyle> localTextStyle9 = TextKt.getLocalTextStyle();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume14 = composerStartRestartGroup.consume(localTextStyle9);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                jM2989textColorXeAY9LY$material3_release = ((TextStyle) objConsume14).getColor-0d7_KjU();
                if (jM2989textColorXeAY9LY$material3_release == 16) {
                    jM2989textColorXeAY9LY$material3_release = textFieldColors2.m2989textColorXeAY9LY$material3_release(z4, false, zBooleanValue);
                }
                long j5 = jM2989textColorXeAY9LY$material3_release;
                Modifier modifierFocusRequester5 = FocusRequesterModifierKt.focusRequester(SizeKt.m1084sizeInqDBjuR0$default(companion, SearchBar_androidKt.getSearchBarMinWidth(), InputFieldHeight, SearchBar_androidKt.SearchBarMaxWidth, 0.0f, 8, null), focusRequester);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320411280, "CC(remember):SearchBar.android.kt#9igjgp");
                if ((57344 & i4) == 16384) {
                    z5 = true;
                } else {
                    z5 = false;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z5) {
                    objRememberedValue2 = (Function1) new Function1<FocusState, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((FocusState) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(FocusState focusState) {
                            if (focusState.isFocused()) {
                                function3.invoke(true);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<FocusState, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((FocusState) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(FocusState focusState) {
                            if (focusState.isFocused()) {
                                function3.invoke(true);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierOnFocusChanged5 = FocusChangedModifierKt.onFocusChanged(modifierFocusRequester5, (Function1) objRememberedValue2);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320408514, "CC(remember):SearchBar.android.kt#9igjgp");
                boolean zChanged7 = composerStartRestartGroup.changed(strM3334getString2EP1pXo);
                if ((i4 & 7168) == 2048) {
                    z6 = true;
                } else {
                    z6 = false;
                }
                zChanged = z6 | zChanged7 | composerStartRestartGroup.changed(strM3334getString2EP1pXo2);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo);
                            if (z) {
                                SemanticsPropertiesKt.setStateDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo2);
                            }
                            final FocusRequester focusRequester2 = focusRequester;
                            SemanticsPropertiesKt.onClick$default(semanticsPropertyReceiver, null, new Function0<Boolean>() {
                                {
                                    super(0);
                                }

                                public final Boolean m2735invoke() {
                                    focusRequester2.requestFocus();
                                    return true;
                                }
                            }, 1, null);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo);
                            if (z) {
                                SemanticsPropertiesKt.setStateDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo2);
                            }
                            final FocusRequester focusRequester2 = focusRequester;
                            SemanticsPropertiesKt.onClick$default(semanticsPropertyReceiver, null, new Function0<Boolean>() {
                                {
                                    super(0);
                                }

                                public final Boolean m2735invoke() {
                                    focusRequester2.requestFocus();
                                    return true;
                                }
                            }, 1, null);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierSemantics$default5 = SemanticsModifierKt.semantics$default(modifierOnFocusChanged5, false, (Function1) objRememberedValue3, 1, null);
                ProvidableCompositionLocal<TextStyle> localTextStyle10 = TextKt.getLocalTextStyle();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume15 = composerStartRestartGroup.consume(localTextStyle10);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                TextStyle textStyleMerge5 = ((TextStyle) objConsume15).merge(new TextStyle(j5, 0L, (FontWeight) null, (FontStyle) null, (FontSynthesis) null, (FontFamily) null, (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, 0, 0, 0L, (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16777214, (DefaultConstructorMarker) null));
                SolidColor solidColor5 = new SolidColor(textFieldColors2.m2939cursorColorvNxB06k$material3_release(false), null);
                KeyboardOptions keyboardOptions5 = new KeyboardOptions(0, (Boolean) null, 0, ImeAction.Companion.getSearch-eUduSuo(), (PlatformImeOptions) null, (Boolean) null, (LocaleList) null, 119, (DefaultConstructorMarker) null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320385353, "CC(remember):SearchBar.android.kt#9igjgp");
                if ((i4 & 896) == 256) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                i24 = i4 & 14;
                if (i24 == 4) {
                    z8 = true;
                } else {
                    z8 = false;
                }
                z9 = z7 | z8;
                objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                if (!z9) {
                    objRememberedValue4 = (Function1) new Function1<KeyboardActionScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((KeyboardActionScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(KeyboardActionScope keyboardActionScope) {
                            function2.invoke(str);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                } else {
                    objRememberedValue4 = (Function1) new Function1<KeyboardActionScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((KeyboardActionScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(KeyboardActionScope keyboardActionScope) {
                            function2.invoke(str);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i217 = i4;
                final boolean z110 = z4;
                final MutableInteractionSource mutableInteractionSource9 = mutableInteractionSource3;
                final Function2<? super Composer, ? super Integer, Unit> function116 = function10;
                final Function2<? super Composer, ? super Integer, Unit> function117 = function8;
                final Function2<? super Composer, ? super Integer, Unit> function118 = function9;
                final TextFieldColors textFieldColors12 = textFieldColors2;
                int i218 = i24 | 102236160 | (i217 & 112);
                int i219 = i217 >> 9;
                TextFieldColors textFieldColors13 = textFieldColors2;
                boolean z111 = z4;
                BasicTextFieldKt.BasicTextField(str, function1, modifierSemantics$default5, z111, false, textStyleMerge5, keyboardOptions5, new KeyboardActions(null, null, null, null, (Function1) objRememberedValue4, null, 47, null), true, 0, 0, (VisualTransformation) null, (Function1<? super TextLayoutResult, Unit>) null, mutableInteractionSource3, (Brush) solidColor5, (Function3<? super Function2<? super Composer, ? super Integer, Unit>, ? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(-2029278807, true, new Function3<Function2<? super Composer, ? super Integer, ? extends Unit>, Composer, Integer, Unit>() {
                    {
                        super(3);
                    }

                    public Object invoke(Object obj, Object obj2, Object obj3) {
                        invoke((Function2<? super Composer, ? super Integer, Unit>) obj, (Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Function2<? super Composer, ? super Integer, Unit> function119, Composer composer3, int i2110) {
                        int i2111;
                        ComposerKt.sourceInformation(composer3, "C557@26571L15,541@25683L1096:SearchBar.android.kt#uh7d8r");
                        if ((i2110 & 6) == 0) {
                            i2111 = i2110 | (composer3.changedInstance(function119) ? 4 : 2);
                        } else {
                            i2111 = i2110;
                        }
                        if ((i2111 & 19) != 18 || !composer3.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-2029278807, i2111, -1, "androidx.compose.material3.SearchBarDefaults.InputField.<anonymous> (SearchBar.android.kt:541)");
                            }
                            TextFieldDefaults textFieldDefaults = TextFieldDefaults.INSTANCE;
                            String str2 = str;
                            boolean z112 = z110;
                            VisualTransformation none = VisualTransformation.Companion.getNone();
                            MutableInteractionSource mutableInteractionSource10 = mutableInteractionSource9;
                            Function2<Composer, Integer, Unit> function1110 = function116;
                            final Function2<? super Composer, ? super Integer, Unit> function1111 = function117;
                            composer3.startReplaceGroup(-1102017390);
                            ComposerKt.sourceInformation(composer3, "*551@26196L64");
                            ComposableLambda composableLambdaRememberComposableLambda = function1111 == null ? null : ComposableLambdaKt.rememberComposableLambda(-1401341985, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer4, int i30) {
                                    ComposerKt.sourceInformation(composer4, "C551@26198L60:SearchBar.android.kt#uh7d8r");
                                    if ((i30 & 3) == 2 && composer4.getSkipping()) {
                                        composer4.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1401341985, i30, -1, "androidx.compose.material3.SearchBarDefaults.InputField.<anonymous>.<anonymous>.<anonymous> (SearchBar.android.kt:551)");
                                    }
                                    Modifier modifierM996offsetVpY3zN4$default = OffsetKt.m996offsetVpY3zN4$default(Modifier.INSTANCE, SearchBar_androidKt.SearchBarIconOffsetX, 0.0f, 2, null);
                                    Function2<Composer, Integer, Unit> function20 = function1111;
                                    ComposerKt.sourceInformationMarkerStart(composer4, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer4, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer4, 0);
                                    CompositionLocalMap currentCompositionLocalMap = composer4.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer4, modifierM996offsetVpY3zN4$default);
                                    Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer4, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer4.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer4.startReusableNode();
                                    if (composer4.getInserting()) {
                                        composer4.createNode(constructor);
                                    } else {
                                        composer4.useNode();
                                    }
                                    Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer4);
                                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer4, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer4, -127763558, "C551@26247L9:SearchBar.android.kt#uh7d8r");
                                    function20.invoke(composer4, 0);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    composer4.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composer3, 54);
                            composer3.endReplaceGroup();
                            final Function2<? super Composer, ? super Integer, Unit> function20 = function118;
                            composer3.startReplaceGroup(-1102010155);
                            ComposerKt.sourceInformation(composer3, "*555@26423L66");
                            ComposableLambda composableLambdaRememberComposableLambda2 = function20 == null ? null : ComposableLambdaKt.rememberComposableLambda(907752083, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer4, int i30) {
                                    ComposerKt.sourceInformation(composer4, "C555@26425L62:SearchBar.android.kt#uh7d8r");
                                    if ((i30 & 3) == 2 && composer4.getSkipping()) {
                                        composer4.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(907752083, i30, -1, "androidx.compose.material3.SearchBarDefaults.InputField.<anonymous>.<anonymous>.<anonymous> (SearchBar.android.kt:555)");
                                    }
                                    Modifier modifierM996offsetVpY3zN4$default = OffsetKt.m996offsetVpY3zN4$default(Modifier.INSTANCE, Dp.constructor-impl(-SearchBar_androidKt.SearchBarIconOffsetX), 0.0f, 2, null);
                                    Function2<Composer, Integer, Unit> function21 = function20;
                                    ComposerKt.sourceInformationMarkerStart(composer4, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer4, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer4, 0);
                                    CompositionLocalMap currentCompositionLocalMap = composer4.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer4, modifierM996offsetVpY3zN4$default);
                                    Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer4, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer4.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer4.startReusableNode();
                                    if (composer4.getInserting()) {
                                        composer4.createNode(constructor);
                                    } else {
                                        composer4.useNode();
                                    }
                                    Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer4);
                                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer4, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer4, -127537351, "C555@26475L10:SearchBar.android.kt#uh7d8r");
                                    function21.invoke(composer4, 0);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    composer4.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composer3, 54);
                            composer3.endReplaceGroup();
                            textFieldDefaults.DecorationBox(str2, function119, z112, true, none, mutableInteractionSource10, false, null, function1110, composableLambdaRememberComposableLambda, composableLambdaRememberComposableLambda2, null, null, null, SearchBarDefaults.INSTANCE.getInputFieldShape(composer3, 6), textFieldColors12, TextFieldDefaults.m2993contentPaddingWithoutLabela9UjIt4$default(TextFieldDefaults.INSTANCE, 0.0f, 0.0f, 0.0f, 0.0f, 15, null), ComposableSingletons$SearchBar_androidKt.INSTANCE.m2223getLambda1$material3_release(), composer3, ((i2111 << 3) & 112) | 27648, 113246208, 14528);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer3.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, i218 | (i219 & 7168), 196608, 7696);
                if (z) {
                    z10 = false;
                } else {
                    z10 = false;
                }
                Boolean boolValueOf5 = Boolean.valueOf(z);
                composer2 = composerStartRestartGroup;
                ComposerKt.sourceInformationMarkerStart(composer2, -320340316, "CC(remember):SearchBar.android.kt#9igjgp");
                zChanged2 = composer2.changed(z10) | composer2.changedInstance(focusManager);
                objRememberedValue5 = composer2.rememberedValue();
                if (!zChanged2) {
                    objRememberedValue5 = (Function2) new SearchBarDefaults$InputField$5$1(z10, focusManager, null);
                    composer2.updateRememberedValue(objRememberedValue5);
                } else {
                    objRememberedValue5 = (Function2) new SearchBarDefaults$InputField$5$1(z10, focusManager, null);
                    composer2.updateRememberedValue(objRememberedValue5);
                }
                ComposerKt.sourceInformationMarkerEnd(composer2);
                EffectsKt.LaunchedEffect(boolValueOf5, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) objRememberedValue5, composer2, i219 & 14);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                function11 = function10;
                function12 = function8;
                function13 = function9;
                mutableInteractionSource4 = mutableInteractionSource2;
                textFieldColors3 = textFieldColors13;
                z11 = z111;
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

                    public final void invoke(Composer composer3, int i2110) {
                        SearchBarDefaults.this.InputField(str, function1, function2, z, function3, modifier2, z11, function11, function12, function13, textFieldColors3, mutableInteractionSource4, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                    }
                });
            }
        }
        i23 |= 384;
        if ((i4 & 306783379) == 306783378) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i10 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i12 != 0) {
                    z3 = true;
                } else {
                    z3 = z2;
                }
                if (i14 != 0) {
                    function7 = null;
                } else {
                    function7 = function4;
                }
                if (i16 != 0) {
                    function8 = null;
                } else {
                    function8 = function5;
                }
                if (i18 != 0) {
                    function9 = null;
                } else {
                    function9 = function6;
                }
                if ((i3 & Fields.RotationZ) != 0) {
                    textFieldColorsM2734inputFieldColorsITpI4ow = m2734inputFieldColorsITpI4ow(0L, 0L, 0L, 0L, null, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, composerStartRestartGroup, 0, (i23 << 6) & 57344, 16383);
                    i23 &= -15;
                } else {
                    textFieldColorsM2734inputFieldColorsITpI4ow = textFieldColors;
                }
                function10 = function7;
                if (i21 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
                textFieldColors2 = textFieldColorsM2734inputFieldColorsITpI4ow;
                z4 = z3;
            } else {
                if (i10 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i12 != 0) {
                    z3 = true;
                } else {
                    z3 = z2;
                }
                if (i14 != 0) {
                    function7 = null;
                } else {
                    function7 = function4;
                }
                if (i16 != 0) {
                    function8 = null;
                } else {
                    function8 = function5;
                }
                if (i18 != 0) {
                    function9 = null;
                } else {
                    function9 = function6;
                }
                if ((i3 & Fields.RotationZ) != 0) {
                    textFieldColorsM2734inputFieldColorsITpI4ow = m2734inputFieldColorsITpI4ow(0L, 0L, 0L, 0L, null, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, composerStartRestartGroup, 0, (i23 << 6) & 57344, 16383);
                    i23 &= -15;
                } else {
                    textFieldColorsM2734inputFieldColorsITpI4ow = textFieldColors;
                }
                function10 = function7;
                if (i21 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
                textFieldColors2 = textFieldColorsM2734inputFieldColorsITpI4ow;
                z4 = z3;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1451366815, i4, i23, "androidx.compose.material3.SearchBarDefaults.InputField (SearchBar.android.kt:494)");
            }
            composerStartRestartGroup.startReplaceGroup(-320443616);
            ComposerKt.sourceInformation(composerStartRestartGroup, "496@23695L39");
            if (mutableInteractionSource2 == null) {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320442965, "CC(remember):SearchBar.android.kt#9igjgp");
                objRememberedValue6 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue6 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue6 = InteractionSourceKt.MutableInteractionSource();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue6);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue6;
            } else {
                mutableInteractionSource3 = mutableInteractionSource2;
            }
            composerStartRestartGroup.endReplaceGroup();
            zBooleanValue = FocusInteractionKt.collectIsFocusedAsState(mutableInteractionSource3, composerStartRestartGroup, 0).getValue().booleanValue();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320438431, "CC(remember):SearchBar.android.kt#9igjgp");
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = new FocusRequester();
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            focusRequester = (FocusRequester) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ProvidableCompositionLocal<FocusManager> localFocusManager6 = CompositionLocalsKt.getLocalFocusManager();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume16 = composerStartRestartGroup.consume(localFocusManager6);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            focusManager = (FocusManager) objConsume16;
            Strings.Companion companion12 = Strings.INSTANCE;
            strM3334getString2EP1pXo = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_search_bar_search), composerStartRestartGroup, 0);
            Strings.Companion companion13 = Strings.INSTANCE;
            strM3334getString2EP1pXo2 = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_suggestions_available), composerStartRestartGroup, 0);
            ProvidableCompositionLocal<TextStyle> localTextStyle11 = TextKt.getLocalTextStyle();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume17 = composerStartRestartGroup.consume(localTextStyle11);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            jM2989textColorXeAY9LY$material3_release = ((TextStyle) objConsume17).getColor-0d7_KjU();
            if (jM2989textColorXeAY9LY$material3_release == 16) {
                jM2989textColorXeAY9LY$material3_release = textFieldColors2.m2989textColorXeAY9LY$material3_release(z4, false, zBooleanValue);
            }
            long j6 = jM2989textColorXeAY9LY$material3_release;
            Modifier modifierFocusRequester6 = FocusRequesterModifierKt.focusRequester(SizeKt.m1084sizeInqDBjuR0$default(companion, SearchBar_androidKt.getSearchBarMinWidth(), InputFieldHeight, SearchBar_androidKt.SearchBarMaxWidth, 0.0f, 8, null), focusRequester);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320411280, "CC(remember):SearchBar.android.kt#9igjgp");
            if ((57344 & i4) == 16384) {
                z5 = true;
            } else {
                z5 = false;
            }
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!z5) {
                objRememberedValue2 = (Function1) new Function1<FocusState, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((FocusState) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(FocusState focusState) {
                        if (focusState.isFocused()) {
                            function3.invoke(true);
                        }
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            } else {
                objRememberedValue2 = (Function1) new Function1<FocusState, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((FocusState) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(FocusState focusState) {
                        if (focusState.isFocused()) {
                            function3.invoke(true);
                        }
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Modifier modifierOnFocusChanged6 = FocusChangedModifierKt.onFocusChanged(modifierFocusRequester6, (Function1) objRememberedValue2);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320408514, "CC(remember):SearchBar.android.kt#9igjgp");
            boolean zChanged8 = composerStartRestartGroup.changed(strM3334getString2EP1pXo);
            if ((i4 & 7168) == 2048) {
                z6 = true;
            } else {
                z6 = false;
            }
            zChanged = z6 | zChanged8 | composerStartRestartGroup.changed(strM3334getString2EP1pXo2);
            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((SemanticsPropertyReceiver) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo);
                        if (z) {
                            SemanticsPropertiesKt.setStateDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo2);
                        }
                        final FocusRequester focusRequester2 = focusRequester;
                        SemanticsPropertiesKt.onClick$default(semanticsPropertyReceiver, null, new Function0<Boolean>() {
                            {
                                super(0);
                            }

                            public final Boolean m2735invoke() {
                                focusRequester2.requestFocus();
                                return true;
                            }
                        }, 1, null);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            } else {
                objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((SemanticsPropertyReceiver) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo);
                        if (z) {
                            SemanticsPropertiesKt.setStateDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo2);
                        }
                        final FocusRequester focusRequester2 = focusRequester;
                        SemanticsPropertiesKt.onClick$default(semanticsPropertyReceiver, null, new Function0<Boolean>() {
                            {
                                super(0);
                            }

                            public final Boolean m2735invoke() {
                                focusRequester2.requestFocus();
                                return true;
                            }
                        }, 1, null);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Modifier modifierSemantics$default6 = SemanticsModifierKt.semantics$default(modifierOnFocusChanged6, false, (Function1) objRememberedValue3, 1, null);
            ProvidableCompositionLocal<TextStyle> localTextStyle12 = TextKt.getLocalTextStyle();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume18 = composerStartRestartGroup.consume(localTextStyle12);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            TextStyle textStyleMerge6 = ((TextStyle) objConsume18).merge(new TextStyle(j6, 0L, (FontWeight) null, (FontStyle) null, (FontSynthesis) null, (FontFamily) null, (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, 0, 0, 0L, (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16777214, (DefaultConstructorMarker) null));
            SolidColor solidColor6 = new SolidColor(textFieldColors2.m2939cursorColorvNxB06k$material3_release(false), null);
            KeyboardOptions keyboardOptions6 = new KeyboardOptions(0, (Boolean) null, 0, ImeAction.Companion.getSearch-eUduSuo(), (PlatformImeOptions) null, (Boolean) null, (LocaleList) null, 119, (DefaultConstructorMarker) null);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320385353, "CC(remember):SearchBar.android.kt#9igjgp");
            if ((i4 & 896) == 256) {
                z7 = true;
            } else {
                z7 = false;
            }
            i24 = i4 & 14;
            if (i24 == 4) {
                z8 = true;
            } else {
                z8 = false;
            }
            z9 = z7 | z8;
            objRememberedValue4 = composerStartRestartGroup.rememberedValue();
            if (!z9) {
                objRememberedValue4 = (Function1) new Function1<KeyboardActionScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((KeyboardActionScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyboardActionScope keyboardActionScope) {
                        function2.invoke(str);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
            } else {
                objRememberedValue4 = (Function1) new Function1<KeyboardActionScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((KeyboardActionScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyboardActionScope keyboardActionScope) {
                        function2.invoke(str);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            int i2110 = i4;
            final boolean z112 = z4;
            final MutableInteractionSource mutableInteractionSource10 = mutableInteractionSource3;
            final Function2<? super Composer, ? super Integer, Unit> function119 = function10;
            final Function2<? super Composer, ? super Integer, Unit> function1110 = function8;
            final Function2<? super Composer, ? super Integer, Unit> function1111 = function9;
            final TextFieldColors textFieldColors14 = textFieldColors2;
            int i2111 = i24 | 102236160 | (i2110 & 112);
            int i2112 = i2110 >> 9;
            TextFieldColors textFieldColors15 = textFieldColors2;
            boolean z113 = z4;
            BasicTextFieldKt.BasicTextField(str, function1, modifierSemantics$default6, z113, false, textStyleMerge6, keyboardOptions6, new KeyboardActions(null, null, null, null, (Function1) objRememberedValue4, null, 47, null), true, 0, 0, (VisualTransformation) null, (Function1<? super TextLayoutResult, Unit>) null, mutableInteractionSource3, (Brush) solidColor6, (Function3<? super Function2<? super Composer, ? super Integer, Unit>, ? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(-2029278807, true, new Function3<Function2<? super Composer, ? super Integer, ? extends Unit>, Composer, Integer, Unit>() {
                {
                    super(3);
                }

                public Object invoke(Object obj, Object obj2, Object obj3) {
                    invoke((Function2<? super Composer, ? super Integer, Unit>) obj, (Composer) obj2, ((Number) obj3).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Function2<? super Composer, ? super Integer, Unit> function1112, Composer composer3, int i2113) {
                    int i2114;
                    ComposerKt.sourceInformation(composer3, "C557@26571L15,541@25683L1096:SearchBar.android.kt#uh7d8r");
                    if ((i2113 & 6) == 0) {
                        i2114 = i2113 | (composer3.changedInstance(function1112) ? 4 : 2);
                    } else {
                        i2114 = i2113;
                    }
                    if ((i2114 & 19) != 18 || !composer3.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-2029278807, i2114, -1, "androidx.compose.material3.SearchBarDefaults.InputField.<anonymous> (SearchBar.android.kt:541)");
                        }
                        TextFieldDefaults textFieldDefaults = TextFieldDefaults.INSTANCE;
                        String str2 = str;
                        boolean z114 = z112;
                        VisualTransformation none = VisualTransformation.Companion.getNone();
                        MutableInteractionSource mutableInteractionSource11 = mutableInteractionSource10;
                        Function2<Composer, Integer, Unit> function1113 = function119;
                        final Function2<? super Composer, ? super Integer, Unit> function1114 = function1110;
                        composer3.startReplaceGroup(-1102017390);
                        ComposerKt.sourceInformation(composer3, "*551@26196L64");
                        ComposableLambda composableLambdaRememberComposableLambda = function1114 == null ? null : ComposableLambdaKt.rememberComposableLambda(-1401341985, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer4, int i30) {
                                ComposerKt.sourceInformation(composer4, "C551@26198L60:SearchBar.android.kt#uh7d8r");
                                if ((i30 & 3) == 2 && composer4.getSkipping()) {
                                    composer4.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1401341985, i30, -1, "androidx.compose.material3.SearchBarDefaults.InputField.<anonymous>.<anonymous>.<anonymous> (SearchBar.android.kt:551)");
                                }
                                Modifier modifierM996offsetVpY3zN4$default = OffsetKt.m996offsetVpY3zN4$default(Modifier.INSTANCE, SearchBar_androidKt.SearchBarIconOffsetX, 0.0f, 2, null);
                                Function2<Composer, Integer, Unit> function20 = function1114;
                                ComposerKt.sourceInformationMarkerStart(composer4, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer4, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer4, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer4.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer4, modifierM996offsetVpY3zN4$default);
                                Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer4, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer4.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer4.startReusableNode();
                                if (composer4.getInserting()) {
                                    composer4.createNode(constructor);
                                } else {
                                    composer4.useNode();
                                }
                                Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer4);
                                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer4, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer4, -127763558, "C551@26247L9:SearchBar.android.kt#uh7d8r");
                                function20.invoke(composer4, 0);
                                ComposerKt.sourceInformationMarkerEnd(composer4);
                                ComposerKt.sourceInformationMarkerEnd(composer4);
                                composer4.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer4);
                                ComposerKt.sourceInformationMarkerEnd(composer4);
                                ComposerKt.sourceInformationMarkerEnd(composer4);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composer3, 54);
                        composer3.endReplaceGroup();
                        final Function2<? super Composer, ? super Integer, Unit> function20 = function1111;
                        composer3.startReplaceGroup(-1102010155);
                        ComposerKt.sourceInformation(composer3, "*555@26423L66");
                        ComposableLambda composableLambdaRememberComposableLambda2 = function20 == null ? null : ComposableLambdaKt.rememberComposableLambda(907752083, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer4, int i30) {
                                ComposerKt.sourceInformation(composer4, "C555@26425L62:SearchBar.android.kt#uh7d8r");
                                if ((i30 & 3) == 2 && composer4.getSkipping()) {
                                    composer4.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(907752083, i30, -1, "androidx.compose.material3.SearchBarDefaults.InputField.<anonymous>.<anonymous>.<anonymous> (SearchBar.android.kt:555)");
                                }
                                Modifier modifierM996offsetVpY3zN4$default = OffsetKt.m996offsetVpY3zN4$default(Modifier.INSTANCE, Dp.constructor-impl(-SearchBar_androidKt.SearchBarIconOffsetX), 0.0f, 2, null);
                                Function2<Composer, Integer, Unit> function21 = function20;
                                ComposerKt.sourceInformationMarkerStart(composer4, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer4, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer4, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer4.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer4, modifierM996offsetVpY3zN4$default);
                                Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer4, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer4.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer4.startReusableNode();
                                if (composer4.getInserting()) {
                                    composer4.createNode(constructor);
                                } else {
                                    composer4.useNode();
                                }
                                Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer4);
                                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer4, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer4, -127537351, "C555@26475L10:SearchBar.android.kt#uh7d8r");
                                function21.invoke(composer4, 0);
                                ComposerKt.sourceInformationMarkerEnd(composer4);
                                ComposerKt.sourceInformationMarkerEnd(composer4);
                                composer4.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer4);
                                ComposerKt.sourceInformationMarkerEnd(composer4);
                                ComposerKt.sourceInformationMarkerEnd(composer4);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composer3, 54);
                        composer3.endReplaceGroup();
                        textFieldDefaults.DecorationBox(str2, function1112, z114, true, none, mutableInteractionSource11, false, null, function1113, composableLambdaRememberComposableLambda, composableLambdaRememberComposableLambda2, null, null, null, SearchBarDefaults.INSTANCE.getInputFieldShape(composer3, 6), textFieldColors14, TextFieldDefaults.m2993contentPaddingWithoutLabela9UjIt4$default(TextFieldDefaults.INSTANCE, 0.0f, 0.0f, 0.0f, 0.0f, 15, null), ComposableSingletons$SearchBar_androidKt.INSTANCE.m2223getLambda1$material3_release(), composer3, ((i2114 << 3) & 112) | 27648, 113246208, 14528);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer3.skipToGroupEnd();
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, i2111 | (i2112 & 7168), 196608, 7696);
            if (z) {
                z10 = false;
            } else {
                z10 = false;
            }
            Boolean boolValueOf6 = Boolean.valueOf(z);
            composer2 = composerStartRestartGroup;
            ComposerKt.sourceInformationMarkerStart(composer2, -320340316, "CC(remember):SearchBar.android.kt#9igjgp");
            zChanged2 = composer2.changed(z10) | composer2.changedInstance(focusManager);
            objRememberedValue5 = composer2.rememberedValue();
            if (!zChanged2) {
                objRememberedValue5 = (Function2) new SearchBarDefaults$InputField$5$1(z10, focusManager, null);
                composer2.updateRememberedValue(objRememberedValue5);
            } else {
                objRememberedValue5 = (Function2) new SearchBarDefaults$InputField$5$1(z10, focusManager, null);
                composer2.updateRememberedValue(objRememberedValue5);
            }
            ComposerKt.sourceInformationMarkerEnd(composer2);
            EffectsKt.LaunchedEffect(boolValueOf6, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) objRememberedValue5, composer2, i2112 & 14);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier2 = companion;
            function11 = function10;
            function12 = function8;
            function13 = function9;
            mutableInteractionSource4 = mutableInteractionSource2;
            textFieldColors3 = textFieldColors15;
            z11 = z113;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i10 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i12 != 0) {
                    z3 = true;
                } else {
                    z3 = z2;
                }
                if (i14 != 0) {
                    function7 = null;
                } else {
                    function7 = function4;
                }
                if (i16 != 0) {
                    function8 = null;
                } else {
                    function8 = function5;
                }
                if (i18 != 0) {
                    function9 = null;
                } else {
                    function9 = function6;
                }
                if ((i3 & Fields.RotationZ) != 0) {
                    textFieldColorsM2734inputFieldColorsITpI4ow = m2734inputFieldColorsITpI4ow(0L, 0L, 0L, 0L, null, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, composerStartRestartGroup, 0, (i23 << 6) & 57344, 16383);
                    i23 &= -15;
                } else {
                    textFieldColorsM2734inputFieldColorsITpI4ow = textFieldColors;
                }
                function10 = function7;
                if (i21 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
                textFieldColors2 = textFieldColorsM2734inputFieldColorsITpI4ow;
                z4 = z3;
            } else {
                if (i10 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i12 != 0) {
                    z3 = true;
                } else {
                    z3 = z2;
                }
                if (i14 != 0) {
                    function7 = null;
                } else {
                    function7 = function4;
                }
                if (i16 != 0) {
                    function8 = null;
                } else {
                    function8 = function5;
                }
                if (i18 != 0) {
                    function9 = null;
                } else {
                    function9 = function6;
                }
                if ((i3 & Fields.RotationZ) != 0) {
                    textFieldColorsM2734inputFieldColorsITpI4ow = m2734inputFieldColorsITpI4ow(0L, 0L, 0L, 0L, null, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, composerStartRestartGroup, 0, (i23 << 6) & 57344, 16383);
                    i23 &= -15;
                } else {
                    textFieldColorsM2734inputFieldColorsITpI4ow = textFieldColors;
                }
                function10 = function7;
                if (i21 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
                textFieldColors2 = textFieldColorsM2734inputFieldColorsITpI4ow;
                z4 = z3;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1451366815, i4, i23, "androidx.compose.material3.SearchBarDefaults.InputField (SearchBar.android.kt:494)");
            }
            composerStartRestartGroup.startReplaceGroup(-320443616);
            ComposerKt.sourceInformation(composerStartRestartGroup, "496@23695L39");
            if (mutableInteractionSource2 == null) {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320442965, "CC(remember):SearchBar.android.kt#9igjgp");
                objRememberedValue6 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue6 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue6 = InteractionSourceKt.MutableInteractionSource();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue6);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue6;
            } else {
                mutableInteractionSource3 = mutableInteractionSource2;
            }
            composerStartRestartGroup.endReplaceGroup();
            zBooleanValue = FocusInteractionKt.collectIsFocusedAsState(mutableInteractionSource3, composerStartRestartGroup, 0).getValue().booleanValue();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320438431, "CC(remember):SearchBar.android.kt#9igjgp");
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = new FocusRequester();
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            focusRequester = (FocusRequester) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ProvidableCompositionLocal<FocusManager> localFocusManager7 = CompositionLocalsKt.getLocalFocusManager();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume19 = composerStartRestartGroup.consume(localFocusManager7);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            focusManager = (FocusManager) objConsume19;
            Strings.Companion companion14 = Strings.INSTANCE;
            strM3334getString2EP1pXo = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_search_bar_search), composerStartRestartGroup, 0);
            Strings.Companion companion15 = Strings.INSTANCE;
            strM3334getString2EP1pXo2 = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_suggestions_available), composerStartRestartGroup, 0);
            ProvidableCompositionLocal<TextStyle> localTextStyle13 = TextKt.getLocalTextStyle();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume110 = composerStartRestartGroup.consume(localTextStyle13);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            jM2989textColorXeAY9LY$material3_release = ((TextStyle) objConsume110).getColor-0d7_KjU();
            if (jM2989textColorXeAY9LY$material3_release == 16) {
                jM2989textColorXeAY9LY$material3_release = textFieldColors2.m2989textColorXeAY9LY$material3_release(z4, false, zBooleanValue);
            }
            long j7 = jM2989textColorXeAY9LY$material3_release;
            Modifier modifierFocusRequester7 = FocusRequesterModifierKt.focusRequester(SizeKt.m1084sizeInqDBjuR0$default(companion, SearchBar_androidKt.getSearchBarMinWidth(), InputFieldHeight, SearchBar_androidKt.SearchBarMaxWidth, 0.0f, 8, null), focusRequester);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320411280, "CC(remember):SearchBar.android.kt#9igjgp");
            if ((57344 & i4) == 16384) {
                z5 = true;
            } else {
                z5 = false;
            }
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!z5) {
                objRememberedValue2 = (Function1) new Function1<FocusState, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((FocusState) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(FocusState focusState) {
                        if (focusState.isFocused()) {
                            function3.invoke(true);
                        }
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            } else {
                objRememberedValue2 = (Function1) new Function1<FocusState, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((FocusState) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(FocusState focusState) {
                        if (focusState.isFocused()) {
                            function3.invoke(true);
                        }
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Modifier modifierOnFocusChanged7 = FocusChangedModifierKt.onFocusChanged(modifierFocusRequester7, (Function1) objRememberedValue2);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320408514, "CC(remember):SearchBar.android.kt#9igjgp");
            boolean zChanged9 = composerStartRestartGroup.changed(strM3334getString2EP1pXo);
            if ((i4 & 7168) == 2048) {
                z6 = true;
            } else {
                z6 = false;
            }
            zChanged = z6 | zChanged9 | composerStartRestartGroup.changed(strM3334getString2EP1pXo2);
            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((SemanticsPropertyReceiver) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo);
                        if (z) {
                            SemanticsPropertiesKt.setStateDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo2);
                        }
                        final FocusRequester focusRequester2 = focusRequester;
                        SemanticsPropertiesKt.onClick$default(semanticsPropertyReceiver, null, new Function0<Boolean>() {
                            {
                                super(0);
                            }

                            public final Boolean m2735invoke() {
                                focusRequester2.requestFocus();
                                return true;
                            }
                        }, 1, null);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            } else {
                objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((SemanticsPropertyReceiver) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo);
                        if (z) {
                            SemanticsPropertiesKt.setStateDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo2);
                        }
                        final FocusRequester focusRequester2 = focusRequester;
                        SemanticsPropertiesKt.onClick$default(semanticsPropertyReceiver, null, new Function0<Boolean>() {
                            {
                                super(0);
                            }

                            public final Boolean m2735invoke() {
                                focusRequester2.requestFocus();
                                return true;
                            }
                        }, 1, null);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Modifier modifierSemantics$default7 = SemanticsModifierKt.semantics$default(modifierOnFocusChanged7, false, (Function1) objRememberedValue3, 1, null);
            ProvidableCompositionLocal<TextStyle> localTextStyle14 = TextKt.getLocalTextStyle();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume111 = composerStartRestartGroup.consume(localTextStyle14);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            TextStyle textStyleMerge7 = ((TextStyle) objConsume111).merge(new TextStyle(j7, 0L, (FontWeight) null, (FontStyle) null, (FontSynthesis) null, (FontFamily) null, (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (DrawStyle) null, 0, 0, 0L, (TextIndent) null, (PlatformTextStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 16777214, (DefaultConstructorMarker) null));
            SolidColor solidColor7 = new SolidColor(textFieldColors2.m2939cursorColorvNxB06k$material3_release(false), null);
            KeyboardOptions keyboardOptions7 = new KeyboardOptions(0, (Boolean) null, 0, ImeAction.Companion.getSearch-eUduSuo(), (PlatformImeOptions) null, (Boolean) null, (LocaleList) null, 119, (DefaultConstructorMarker) null);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -320385353, "CC(remember):SearchBar.android.kt#9igjgp");
            if ((i4 & 896) == 256) {
                z7 = true;
            } else {
                z7 = false;
            }
            i24 = i4 & 14;
            if (i24 == 4) {
                z8 = true;
            } else {
                z8 = false;
            }
            z9 = z7 | z8;
            objRememberedValue4 = composerStartRestartGroup.rememberedValue();
            if (!z9) {
                objRememberedValue4 = (Function1) new Function1<KeyboardActionScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((KeyboardActionScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyboardActionScope keyboardActionScope) {
                        function2.invoke(str);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
            } else {
                objRememberedValue4 = (Function1) new Function1<KeyboardActionScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((KeyboardActionScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyboardActionScope keyboardActionScope) {
                        function2.invoke(str);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            int i2113 = i4;
            final boolean z114 = z4;
            final MutableInteractionSource mutableInteractionSource11 = mutableInteractionSource3;
            final Function2<? super Composer, ? super Integer, Unit> function1112 = function10;
            final Function2<? super Composer, ? super Integer, Unit> function1113 = function8;
            final Function2<? super Composer, ? super Integer, Unit> function1114 = function9;
            final TextFieldColors textFieldColors16 = textFieldColors2;
            int i2114 = i24 | 102236160 | (i2113 & 112);
            int i2115 = i2113 >> 9;
            TextFieldColors textFieldColors17 = textFieldColors2;
            boolean z115 = z4;
            BasicTextFieldKt.BasicTextField(str, function1, modifierSemantics$default7, z115, false, textStyleMerge7, keyboardOptions7, new KeyboardActions(null, null, null, null, (Function1) objRememberedValue4, null, 47, null), true, 0, 0, (VisualTransformation) null, (Function1<? super TextLayoutResult, Unit>) null, mutableInteractionSource3, (Brush) solidColor7, (Function3<? super Function2<? super Composer, ? super Integer, Unit>, ? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(-2029278807, true, new Function3<Function2<? super Composer, ? super Integer, ? extends Unit>, Composer, Integer, Unit>() {
                {
                    super(3);
                }

                public Object invoke(Object obj, Object obj2, Object obj3) {
                    invoke((Function2<? super Composer, ? super Integer, Unit>) obj, (Composer) obj2, ((Number) obj3).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Function2<? super Composer, ? super Integer, Unit> function1115, Composer composer3, int i2116) {
                    int i2117;
                    ComposerKt.sourceInformation(composer3, "C557@26571L15,541@25683L1096:SearchBar.android.kt#uh7d8r");
                    if ((i2116 & 6) == 0) {
                        i2117 = i2116 | (composer3.changedInstance(function1115) ? 4 : 2);
                    } else {
                        i2117 = i2116;
                    }
                    if ((i2117 & 19) != 18 || !composer3.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-2029278807, i2117, -1, "androidx.compose.material3.SearchBarDefaults.InputField.<anonymous> (SearchBar.android.kt:541)");
                        }
                        TextFieldDefaults textFieldDefaults = TextFieldDefaults.INSTANCE;
                        String str2 = str;
                        boolean z116 = z114;
                        VisualTransformation none = VisualTransformation.Companion.getNone();
                        MutableInteractionSource mutableInteractionSource12 = mutableInteractionSource11;
                        Function2<Composer, Integer, Unit> function1116 = function1112;
                        final Function2<? super Composer, ? super Integer, Unit> function1117 = function1113;
                        composer3.startReplaceGroup(-1102017390);
                        ComposerKt.sourceInformation(composer3, "*551@26196L64");
                        ComposableLambda composableLambdaRememberComposableLambda = function1117 == null ? null : ComposableLambdaKt.rememberComposableLambda(-1401341985, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer4, int i30) {
                                ComposerKt.sourceInformation(composer4, "C551@26198L60:SearchBar.android.kt#uh7d8r");
                                if ((i30 & 3) == 2 && composer4.getSkipping()) {
                                    composer4.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1401341985, i30, -1, "androidx.compose.material3.SearchBarDefaults.InputField.<anonymous>.<anonymous>.<anonymous> (SearchBar.android.kt:551)");
                                }
                                Modifier modifierM996offsetVpY3zN4$default = OffsetKt.m996offsetVpY3zN4$default(Modifier.INSTANCE, SearchBar_androidKt.SearchBarIconOffsetX, 0.0f, 2, null);
                                Function2<Composer, Integer, Unit> function20 = function1117;
                                ComposerKt.sourceInformationMarkerStart(composer4, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer4, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer4, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer4.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer4, modifierM996offsetVpY3zN4$default);
                                Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer4, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer4.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer4.startReusableNode();
                                if (composer4.getInserting()) {
                                    composer4.createNode(constructor);
                                } else {
                                    composer4.useNode();
                                }
                                Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer4);
                                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer4, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer4, -127763558, "C551@26247L9:SearchBar.android.kt#uh7d8r");
                                function20.invoke(composer4, 0);
                                ComposerKt.sourceInformationMarkerEnd(composer4);
                                ComposerKt.sourceInformationMarkerEnd(composer4);
                                composer4.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer4);
                                ComposerKt.sourceInformationMarkerEnd(composer4);
                                ComposerKt.sourceInformationMarkerEnd(composer4);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composer3, 54);
                        composer3.endReplaceGroup();
                        final Function2<? super Composer, ? super Integer, Unit> function20 = function1114;
                        composer3.startReplaceGroup(-1102010155);
                        ComposerKt.sourceInformation(composer3, "*555@26423L66");
                        ComposableLambda composableLambdaRememberComposableLambda2 = function20 == null ? null : ComposableLambdaKt.rememberComposableLambda(907752083, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer4, int i30) {
                                ComposerKt.sourceInformation(composer4, "C555@26425L62:SearchBar.android.kt#uh7d8r");
                                if ((i30 & 3) == 2 && composer4.getSkipping()) {
                                    composer4.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(907752083, i30, -1, "androidx.compose.material3.SearchBarDefaults.InputField.<anonymous>.<anonymous>.<anonymous> (SearchBar.android.kt:555)");
                                }
                                Modifier modifierM996offsetVpY3zN4$default = OffsetKt.m996offsetVpY3zN4$default(Modifier.INSTANCE, Dp.constructor-impl(-SearchBar_androidKt.SearchBarIconOffsetX), 0.0f, 2, null);
                                Function2<Composer, Integer, Unit> function21 = function20;
                                ComposerKt.sourceInformationMarkerStart(composer4, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer4, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer4, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer4.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer4, modifierM996offsetVpY3zN4$default);
                                Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer4, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer4.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer4.startReusableNode();
                                if (composer4.getInserting()) {
                                    composer4.createNode(constructor);
                                } else {
                                    composer4.useNode();
                                }
                                Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer4);
                                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer4, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer4, -127537351, "C555@26475L10:SearchBar.android.kt#uh7d8r");
                                function21.invoke(composer4, 0);
                                ComposerKt.sourceInformationMarkerEnd(composer4);
                                ComposerKt.sourceInformationMarkerEnd(composer4);
                                composer4.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer4);
                                ComposerKt.sourceInformationMarkerEnd(composer4);
                                ComposerKt.sourceInformationMarkerEnd(composer4);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composer3, 54);
                        composer3.endReplaceGroup();
                        textFieldDefaults.DecorationBox(str2, function1115, z116, true, none, mutableInteractionSource12, false, null, function1116, composableLambdaRememberComposableLambda, composableLambdaRememberComposableLambda2, null, null, null, SearchBarDefaults.INSTANCE.getInputFieldShape(composer3, 6), textFieldColors16, TextFieldDefaults.m2993contentPaddingWithoutLabela9UjIt4$default(TextFieldDefaults.INSTANCE, 0.0f, 0.0f, 0.0f, 0.0f, 15, null), ComposableSingletons$SearchBar_androidKt.INSTANCE.m2223getLambda1$material3_release(), composer3, ((i2117 << 3) & 112) | 27648, 113246208, 14528);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer3.skipToGroupEnd();
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, i2114 | (i2115 & 7168), 196608, 7696);
            if (z) {
                z10 = false;
            } else {
                z10 = false;
            }
            Boolean boolValueOf7 = Boolean.valueOf(z);
            composer2 = composerStartRestartGroup;
            ComposerKt.sourceInformationMarkerStart(composer2, -320340316, "CC(remember):SearchBar.android.kt#9igjgp");
            zChanged2 = composer2.changed(z10) | composer2.changedInstance(focusManager);
            objRememberedValue5 = composer2.rememberedValue();
            if (!zChanged2) {
                objRememberedValue5 = (Function2) new SearchBarDefaults$InputField$5$1(z10, focusManager, null);
                composer2.updateRememberedValue(objRememberedValue5);
            } else {
                objRememberedValue5 = (Function2) new SearchBarDefaults$InputField$5$1(z10, focusManager, null);
                composer2.updateRememberedValue(objRememberedValue5);
            }
            ComposerKt.sourceInformationMarkerEnd(composer2);
            EffectsKt.LaunchedEffect(boolValueOf7, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) objRememberedValue5, composer2, i2115 & 14);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier2 = companion;
            function11 = function10;
            function12 = function8;
            function13 = function9;
            mutableInteractionSource4 = mutableInteractionSource2;
            textFieldColors3 = textFieldColors17;
            z11 = z115;
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

                public final void invoke(Composer composer3, int i2116) {
                    SearchBarDefaults.this.InputField(str, function1, function2, z, function3, modifier2, z11, function11, function12, function13, textFieldColors3, mutableInteractionSource4, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                }
            });
        }
    }

    @Deprecated(message = "Search bars now take the input field as a parameter. `inputFieldColors` should be passed explicitly to the input field. This parameter will be removed in a future version of the library.", replaceWith = @ReplaceWith(expression = "colors(containerColor, dividerColor)", imports = {}))
    public final SearchBarColors m2727colorsKlgxPg(long j, long j2, TextFieldColors textFieldColors, Composer composer, int i, int i2) {
        ComposerKt.sourceInformationMarkerStart(composer, -1216168196, "C(colors)P(0:c#ui.graphics.Color,1:c#ui.graphics.Color)586@27706L5,587@27773L5,588@27824L18:SearchBar.android.kt#uh7d8r");
        long value = (i2 & 1) != 0 ? ColorSchemeKt.getValue(SearchBarTokens.INSTANCE.getContainerColor(), composer, 6) : j;
        long value2 = (i2 & 2) != 0 ? ColorSchemeKt.getValue(SearchViewTokens.INSTANCE.getDividerColor(), composer, 6) : j2;
        TextFieldColors textFieldColorsM2734inputFieldColorsITpI4ow = (i2 & 4) != 0 ? m2734inputFieldColorsITpI4ow(0L, 0L, 0L, 0L, null, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, composer, 0, (i << 3) & 57344, 16383) : textFieldColors;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1216168196, i, -1, "androidx.compose.material3.SearchBarDefaults.colors (SearchBar.android.kt:590)");
        }
        SearchBarColors searchBarColors = new SearchBarColors(value, value2, textFieldColorsM2734inputFieldColorsITpI4ow, null);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return searchBarColors;
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Maintained for binary compatibility")
    public final TextFieldColors m2733inputFieldColorsuKgnY(long j, long j2, long j3, TextSelectionColors textSelectionColors, long j4, long j5, long j6, long j7, long j8, long j9, long j10, long j11, Composer composer, int i, int i2, int i3) {
        TextSelectionColors textSelectionColors2;
        ComposerKt.sourceInformationMarkerStart(composer, 355927049, "C(inputFieldColors)P(9:c#ui.graphics.Color,3:c#ui.graphics.Color,0:c#ui.graphics.Color,8,5:c#ui.graphics.Color,10:c#ui.graphics.Color,1:c#ui.graphics.Color,6:c#ui.graphics.Color,11:c#ui.graphics.Color,4:c#ui.graphics.Color,7:c#ui.graphics.Color,2:c#ui.graphics.Color)599@28228L5,601@28323L5,604@28479L5,605@28558L7,606@28641L5,607@28724L5,609@28832L5,612@29008L5,613@29093L5,615@29203L5,618@29374L5,620@29476L5,624@29586L825:SearchBar.android.kt#uh7d8r");
        long value = (i3 & 1) != 0 ? ColorSchemeKt.getValue(SearchBarTokens.INSTANCE.getInputTextColor(), composer, 6) : j;
        long jM4589copywmQWz5c$default = (i3 & 2) != 0 ? Color.m4589copywmQWz5c$default(ColorSchemeKt.getValue(FilledTextFieldTokens.INSTANCE.getDisabledInputColor(), composer, 6), FilledTextFieldTokens.INSTANCE.getDisabledInputOpacity(), 0.0f, 0.0f, 0.0f, 14, null) : j2;
        long value2 = (i3 & 4) != 0 ? ColorSchemeKt.getValue(FilledTextFieldTokens.INSTANCE.getCaretColor(), composer, 6) : j3;
        if ((i3 & 8) != 0) {
            ProvidableCompositionLocal<TextSelectionColors> localTextSelectionColors = TextSelectionColorsKt.getLocalTextSelectionColors();
            ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume = composer.consume(localTextSelectionColors);
            ComposerKt.sourceInformationMarkerEnd(composer);
            textSelectionColors2 = (TextSelectionColors) objConsume;
        } else {
            textSelectionColors2 = textSelectionColors;
        }
        long value3 = (i3 & 16) != 0 ? ColorSchemeKt.getValue(SearchBarTokens.INSTANCE.getLeadingIconColor(), composer, 6) : j4;
        long value4 = (i3 & 32) != 0 ? ColorSchemeKt.getValue(SearchBarTokens.INSTANCE.getLeadingIconColor(), composer, 6) : j5;
        long jM4589copywmQWz5c$default2 = (i3 & 64) != 0 ? Color.m4589copywmQWz5c$default(ColorSchemeKt.getValue(FilledTextFieldTokens.INSTANCE.getDisabledLeadingIconColor(), composer, 6), FilledTextFieldTokens.INSTANCE.getDisabledLeadingIconOpacity(), 0.0f, 0.0f, 0.0f, 14, null) : j6;
        long value5 = (i3 & Fields.SpotShadowColor) != 0 ? ColorSchemeKt.getValue(SearchBarTokens.INSTANCE.getTrailingIconColor(), composer, 6) : j7;
        long value6 = (i3 & Fields.RotationX) != 0 ? ColorSchemeKt.getValue(SearchBarTokens.INSTANCE.getTrailingIconColor(), composer, 6) : j8;
        long jM4589copywmQWz5c$default3 = (i3 & Fields.RotationY) != 0 ? Color.m4589copywmQWz5c$default(ColorSchemeKt.getValue(FilledTextFieldTokens.INSTANCE.getDisabledTrailingIconColor(), composer, 6), FilledTextFieldTokens.INSTANCE.getDisabledTrailingIconOpacity(), 0.0f, 0.0f, 0.0f, 14, null) : j9;
        long value7 = (i3 & Fields.RotationZ) != 0 ? ColorSchemeKt.getValue(SearchBarTokens.INSTANCE.getSupportingTextColor(), composer, 6) : j10;
        long jM4589copywmQWz5c$default4 = (i3 & Fields.CameraDistance) != 0 ? Color.m4589copywmQWz5c$default(ColorSchemeKt.getValue(FilledTextFieldTokens.INSTANCE.getDisabledInputColor(), composer, 6), FilledTextFieldTokens.INSTANCE.getDisabledInputOpacity(), 0.0f, 0.0f, 0.0f, 14, null) : j11;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(355927049, i, i2, "androidx.compose.material3.SearchBarDefaults.inputFieldColors (SearchBar.android.kt:624)");
        }
        int i4 = i << 3;
        int i5 = i2 << 6;
        TextFieldColors textFieldColorsM2734inputFieldColorsITpI4ow = m2734inputFieldColorsITpI4ow(value, value, jM4589copywmQWz5c$default, value2, textSelectionColors2, value3, value4, jM4589copywmQWz5c$default2, value5, value6, jM4589copywmQWz5c$default3, value7, value7, jM4589copywmQWz5c$default4, composer, (i & 14) | (i4 & 112) | (i4 & 896) | (i4 & 7168) | (i4 & 57344) | (458752 & i4) | (3670016 & i4) | (29360128 & i4) | (234881024 & i4) | (i4 & 1879048192), ((i >> 27) & 14) | ((i2 << 3) & 112) | (i5 & 896) | (i5 & 7168) | (i5 & 57344), 0);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return textFieldColorsM2734inputFieldColorsITpI4ow;
    }
}
