package androidx.compose.foundation.text.selection;

import androidx.compose.foundation.text.Handle;
import androidx.compose.foundation.text.LegacyTextFieldState;
import androidx.compose.foundation.text.TextDelegate;
import androidx.compose.foundation.text.TextDragObserver;
import androidx.compose.foundation.text.TextLayoutResultProxy;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.input.pointer.PointerInputScope;
import androidx.compose.p002ui.input.pointer.SuspendingPointerInputFilterKt;
import androidx.compose.p002ui.layout.LayoutCoordinates;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.ui.text.AnnotatedString;
import androidx.compose.ui.text.TextLayoutResult;
import androidx.compose.ui.text.TextRange;
import androidx.compose.ui.text.style.ResolvedTextDirection;
import androidx.compose.ui.unit.IntSize;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.jvm.functions.Function2;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000*\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\u001a%\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u0007H\u0001¢\u0006\u0002\u0010\b\u001a\"\u0010\t\u001a\u00020\n2\u0006\u0010\u0006\u001a\u00020\u00072\u0006\u0010\u000b\u001a\u00020\fH\u0000ø\u0001\u0000¢\u0006\u0004\b\r\u0010\u000e\u001a\u0014\u0010\u000f\u001a\u00020\u0003*\u00020\u00072\u0006\u0010\u0002\u001a\u00020\u0003H\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u0010"}, d2 = {"TextFieldSelectionHandle", "", "isStartHandle", "", "direction", "Landroidx/compose/ui/text/style/ResolvedTextDirection;", "manager", "Landroidx/compose/foundation/text/selection/TextFieldSelectionManager;", "(ZLandroidx/compose/ui/text/style/ResolvedTextDirection;Landroidx/compose/foundation/text/selection/TextFieldSelectionManager;Landroidx/compose/runtime/Composer;I)V", "calculateSelectionMagnifierCenterAndroid", "Landroidx/compose/ui/geometry/Offset;", "magnifierSize", "Landroidx/compose/ui/unit/IntSize;", "calculateSelectionMagnifierCenterAndroid-O0kMr_c", "(Landroidx/compose/foundation/text/selection/TextFieldSelectionManager;J)J", "isSelectionHandleInVisibleBound", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class TextFieldSelectionManagerKt {

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[Handle.values().length];
            try {
                iArr[Handle.Cursor.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[Handle.SelectionStart.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[Handle.SelectionEnd.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public static final void TextFieldSelectionHandle(final boolean z, final ResolvedTextDirection resolvedTextDirection, final TextFieldSelectionManager textFieldSelectionManager, Composer composer, final int i) {
        int i2;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1344558920);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(TextFieldSelectionHandle)P(1)1001@38955L90,1006@39093L44,1010@39319L71,1005@39051L346:TextFieldSelectionManager.kt#eksfi3");
        if ((i & 6) == 0) {
            i2 = (composerStartRestartGroup.changed(z) ? 4 : 2) | i;
        } else {
            i2 = i;
        }
        if ((i & 48) == 0) {
            i2 |= composerStartRestartGroup.changed(resolvedTextDirection) ? 32 : 16;
        }
        if ((i & 384) == 0) {
            i2 |= composerStartRestartGroup.changedInstance(textFieldSelectionManager) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i2 & 147) != 146 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1344558920, i2, -1, "androidx.compose.foundation.text.selection.TextFieldSelectionHandle (TextFieldSelectionManager.kt:1000)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 990782570, "CC(remember):TextFieldSelectionManager.kt#9igjgp");
            int i3 = i2 & 14;
            boolean zChanged = (i3 == 4) | composerStartRestartGroup.changed(textFieldSelectionManager);
            Object objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = textFieldSelectionManager.handleDragObserver$foundation_release(z);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            TextDragObserver textDragObserver = (TextDragObserver) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 990786940, "CC(remember):TextFieldSelectionManager.kt#9igjgp");
            boolean zChangedInstance = composerStartRestartGroup.changedInstance(textFieldSelectionManager) | (i3 == 4);
            OffsetProvider offsetProviderRememberedValue = composerStartRestartGroup.rememberedValue();
            if (zChangedInstance || offsetProviderRememberedValue == Composer.INSTANCE.getEmpty()) {
                offsetProviderRememberedValue = new OffsetProvider() {
                    @Override
                    public final long mo1407provideF1C5BW0() {
                        return textFieldSelectionManager.m1941getHandlePositiontuRUvjQ$foundation_release(z);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(offsetProviderRememberedValue);
            }
            OffsetProvider offsetProvider = (OffsetProvider) offsetProviderRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            boolean z2 = TextRange.getReversed-impl(textFieldSelectionManager.getValue$foundation_release().getSelection-d9O1mEE());
            Modifier.Companion companion = Modifier.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 990794199, "CC(remember):TextFieldSelectionManager.kt#9igjgp");
            boolean zChangedInstance2 = composerStartRestartGroup.changedInstance(textDragObserver);
            TextFieldSelectionManagerKt$TextFieldSelectionHandle$2$1 textFieldSelectionManagerKt$TextFieldSelectionHandle$2$1RememberedValue = composerStartRestartGroup.rememberedValue();
            if (zChangedInstance2 || textFieldSelectionManagerKt$TextFieldSelectionHandle$2$1RememberedValue == Composer.INSTANCE.getEmpty()) {
                textFieldSelectionManagerKt$TextFieldSelectionHandle$2$1RememberedValue = new TextFieldSelectionManagerKt$TextFieldSelectionHandle$2$1(textDragObserver, null);
                composerStartRestartGroup.updateRememberedValue(textFieldSelectionManagerKt$TextFieldSelectionHandle$2$1RememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            AndroidSelectionHandles_androidKt.m1849SelectionHandlepzduO1o(offsetProvider, z, resolvedTextDirection, z2, 0L, SuspendingPointerInputFilterKt.pointerInput(companion, textDragObserver, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) textFieldSelectionManagerKt$TextFieldSelectionHandle$2$1RememberedValue), composerStartRestartGroup, (i2 << 3) & 1008, 16);
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

                public final void invoke(Composer composer2, int i4) {
                    TextFieldSelectionManagerKt.TextFieldSelectionHandle(z, resolvedTextDirection, textFieldSelectionManager, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1));
                }
            });
        }
    }

    public static final boolean isSelectionHandleInVisibleBound(TextFieldSelectionManager textFieldSelectionManager, boolean z) {
        LayoutCoordinates layoutCoordinates;
        Rect rectVisibleBounds;
        LegacyTextFieldState state = textFieldSelectionManager.getState();
        if (state == null || (layoutCoordinates = state.getLayoutCoordinates()) == null || (rectVisibleBounds = SelectionManagerKt.visibleBounds(layoutCoordinates)) == null) {
            return false;
        }
        return SelectionManagerKt.m1916containsInclusiveUv8p0NA(rectVisibleBounds, textFieldSelectionManager.m1941getHandlePositiontuRUvjQ$foundation_release(z));
    }

    public static final long m1948calculateSelectionMagnifierCenterAndroidO0kMr_c(TextFieldSelectionManager textFieldSelectionManager, long j) throws NoWhenBranchMatchedException {
        int i;
        TextLayoutResultProxy layoutResult;
        TextDelegate textDelegate;
        AnnotatedString text;
        Offset offsetM1939getCurrentDragPosition_m7T9E = textFieldSelectionManager.m1939getCurrentDragPosition_m7T9E();
        if (offsetM1939getCurrentDragPosition_m7T9E == null) {
            return Offset.INSTANCE.m4361getUnspecifiedF1C5BW0();
        }
        long packedValue = offsetM1939getCurrentDragPosition_m7T9E.getPackedValue();
        CharSequence transformedText$foundation_release = textFieldSelectionManager.getTransformedText$foundation_release();
        if (transformedText$foundation_release == null || transformedText$foundation_release.length() == 0) {
            return Offset.INSTANCE.m4361getUnspecifiedF1C5BW0();
        }
        Handle draggingHandle = textFieldSelectionManager.getDraggingHandle();
        int i2 = draggingHandle == null ? -1 : WhenMappings.$EnumSwitchMapping$0[draggingHandle.ordinal()];
        if (i2 == -1) {
            return Offset.INSTANCE.m4361getUnspecifiedF1C5BW0();
        }
        if (i2 == 1 || i2 == 2) {
            i = TextRange.getStart-impl(textFieldSelectionManager.getValue$foundation_release().getSelection-d9O1mEE());
        } else {
            if (i2 != 3) {
                throw new NoWhenBranchMatchedException();
            }
            i = TextRange.getEnd-impl(textFieldSelectionManager.getValue$foundation_release().getSelection-d9O1mEE());
        }
        LegacyTextFieldState state = textFieldSelectionManager.getState();
        if (state == null || (layoutResult = state.getLayoutResult()) == null) {
            return Offset.INSTANCE.m4361getUnspecifiedF1C5BW0();
        }
        LegacyTextFieldState state2 = textFieldSelectionManager.getState();
        if (state2 == null || (textDelegate = state2.getTextDelegate()) == null || (text = textDelegate.getText()) == null) {
            return Offset.INSTANCE.m4361getUnspecifiedF1C5BW0();
        }
        int iCoerceIn = RangesKt.coerceIn(textFieldSelectionManager.getOffsetMapping().originalToTransformed(i), 0, text.length());
        float fM4346getXimpl = Offset.m4346getXimpl(layoutResult.m1560translateDecorationToInnerCoordinatesMKHz9U$foundation_release(packedValue));
        TextLayoutResult value = layoutResult.getValue();
        int lineForOffset = value.getLineForOffset(iCoerceIn);
        float lineLeft = value.getLineLeft(lineForOffset);
        float lineRight = value.getLineRight(lineForOffset);
        float fCoerceIn = RangesKt.coerceIn(fM4346getXimpl, Math.min(lineLeft, lineRight), Math.max(lineLeft, lineRight));
        if (!IntSize.equals-impl0(j, IntSize.Companion.getZero-YbymL2g()) && Math.abs(fM4346getXimpl - fCoerceIn) > IntSize.getWidth-impl(j) / 2) {
            return Offset.INSTANCE.m4361getUnspecifiedF1C5BW0();
        }
        float lineTop = value.getLineTop(lineForOffset);
        return OffsetKt.Offset(fCoerceIn, ((value.getLineBottom(lineForOffset) - lineTop) / 2) + lineTop);
    }
}
