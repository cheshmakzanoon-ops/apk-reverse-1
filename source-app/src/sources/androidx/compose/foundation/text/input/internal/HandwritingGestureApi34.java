package androidx.compose.foundation.text.input.internal;

import android.os.CancellationSignal;
import android.view.inputmethod.DeleteGesture;
import android.view.inputmethod.DeleteRangeGesture;
import android.view.inputmethod.HandwritingGesture;
import android.view.inputmethod.InsertGesture;
import android.view.inputmethod.JoinOrSplitGesture;
import android.view.inputmethod.PreviewableHandwritingGesture;
import android.view.inputmethod.RemoveSpaceGesture;
import android.view.inputmethod.SelectGesture;
import android.view.inputmethod.SelectRangeGesture;
import androidx.activity.ComponentDialog$$ExternalSyntheticApiModelOutline0;
import androidx.compose.foundation.text.LegacyTextFieldState;
import androidx.compose.foundation.text.TextLayoutResultProxy;
import androidx.compose.foundation.text.input.InputTransformation;
import androidx.compose.foundation.text.input.TextFieldState;
import androidx.compose.foundation.text.input.TextHighlightType;
import androidx.compose.foundation.text.input.internal.undo.TextFieldEditUndoBehavior;
import androidx.compose.foundation.text.selection.TextFieldSelectionManager;
import androidx.compose.p002ui.graphics.Api26Bitmap$$ExternalSyntheticApiModelOutline0;
import androidx.compose.p002ui.graphics.RectHelper_androidKt;
import androidx.compose.p002ui.platform.ViewConfiguration;
import androidx.compose.ui.text.AnnotatedString;
import androidx.compose.ui.text.TextGranularity;
import androidx.compose.ui.text.TextInclusionStrategy;
import androidx.compose.ui.text.TextLayoutInput;
import androidx.compose.ui.text.TextLayoutResult;
import androidx.compose.ui.text.TextRange;
import androidx.compose.ui.text.TextRangeKt;
import androidx.compose.ui.text.input.CommitTextCommand;
import androidx.compose.ui.text.input.DeleteSurroundingTextCommand;
import androidx.compose.ui.text.input.EditCommand;
import androidx.compose.ui.text.input.SetSelectionCommand;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Ref;
import kotlin.text.MatchResult;
import kotlin.text.Regex;

@Metadata(d1 = {"\u0000²\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\bÁ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J$\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0012\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\n0\bH\u0003J>\u0010\u000b\u001a\u00020\n2\u0006\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u00112\u0012\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\n0\bH\u0003ø\u0001\u0000¢\u0006\u0004\b\u0012\u0010\u0013J,\u0010\u0014\u001a\u00020\n2\u0006\u0010\u0015\u001a\u00020\u00042\u0006\u0010\u000e\u001a\u00020\u00162\u0012\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\n0\bH\u0003J8\u0010\u0017\u001a\u00020\n2\u0006\u0010\f\u001a\u00020\r2\b\u0010\u0018\u001a\u0004\u0018\u00010\u00192\u0012\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\n0\bH\u0003ø\u0001\u0000¢\u0006\u0004\b\u001a\u0010\u001bJ\u0014\u0010\u001c\u001a\u00020\u0004*\u00020\u001d2\u0006\u0010\u0005\u001a\u00020\u0006H\u0003J&\u0010\u001e\u001a\u00020\n*\u00020\u001d2\u0006\u0010\f\u001a\u00020\r2\u0006\u0010\u001f\u001a\u00020 H\u0002ø\u0001\u0000¢\u0006\u0004\b!\u0010\"J0\u0010#\u001a\u00020\u0004*\u00020$2\u0006\u0010\u0005\u001a\u00020%2\u0006\u0010\u000e\u001a\u00020\u000f2\u0012\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\n0\bH\u0003J\u001c\u0010#\u001a\u00020\u0004*\u00020\u001d2\u0006\u0010\u0005\u001a\u00020%2\u0006\u0010&\u001a\u00020'H\u0003J0\u0010(\u001a\u00020\u0004*\u00020$2\u0006\u0010\u0005\u001a\u00020)2\u0006\u0010\u000e\u001a\u00020\u000f2\u0012\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\n0\bH\u0003J\u001c\u0010(\u001a\u00020\u0004*\u00020\u001d2\u0006\u0010\u0005\u001a\u00020)2\u0006\u0010&\u001a\u00020'H\u0003J&\u0010*\u001a\u00020\n*\u00020\u001d2\u0006\u0010+\u001a\u00020\r2\u0006\u0010\u0010\u001a\u00020\u0011H\u0003ø\u0001\u0000¢\u0006\u0004\b,\u0010-JA\u0010.\u001a\u00020\u0004*\u00020$2\u0006\u0010\u0005\u001a\u00020\u00062\b\u0010/\u001a\u0004\u0018\u00010\u00192\b\u00100\u001a\u0004\u0018\u0001012\u0012\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\n0\bH\u0001¢\u0006\u0002\b2J+\u0010.\u001a\u00020\u0004*\u00020\u001d2\u0006\u00103\u001a\u00020\u00062\u0006\u0010&\u001a\u00020'2\b\u00100\u001a\u0004\u0018\u000101H\u0001¢\u0006\u0002\b2J2\u00104\u001a\u00020\u0004*\u00020$2\u0006\u0010\u0005\u001a\u0002052\b\u00100\u001a\u0004\u0018\u0001012\u0012\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\n0\bH\u0003J&\u00104\u001a\u00020\u0004*\u00020\u001d2\u0006\u0010\u0005\u001a\u0002052\u0006\u0010&\u001a\u00020'2\b\u00100\u001a\u0004\u0018\u000101H\u0003J:\u00106\u001a\u00020\u0004*\u00020$2\u0006\u0010\u0005\u001a\u0002072\u0006\u0010\u000e\u001a\u00020\u000f2\b\u00100\u001a\u0004\u0018\u0001012\u0012\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\n0\bH\u0003J&\u00106\u001a\u00020\u0004*\u00020\u001d2\u0006\u0010\u0005\u001a\u0002072\u0006\u0010&\u001a\u00020'2\b\u00100\u001a\u0004\u0018\u000101H\u0003J:\u00108\u001a\u00020\u0004*\u00020$2\u0006\u0010\u0005\u001a\u0002092\u0006\u0010\u000e\u001a\u00020\u000f2\b\u00100\u001a\u0004\u0018\u0001012\u0012\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\n0\bH\u0003J&\u00108\u001a\u00020\u0004*\u00020\u001d2\u0006\u0010\u0005\u001a\u0002092\u0006\u0010&\u001a\u00020'2\b\u00100\u001a\u0004\u0018\u000101H\u0003J2\u0010:\u001a\u00020\u0004*\u00020$2\u0006\u0010\u0005\u001a\u00020;2\b\u0010\u0018\u001a\u0004\u0018\u00010\u00192\u0012\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\n0\bH\u0003J\u001c\u0010:\u001a\u00020\u0004*\u00020\u001d2\u0006\u0010\u0005\u001a\u00020;2\u0006\u0010&\u001a\u00020'H\u0003J2\u0010<\u001a\u00020\u0004*\u00020$2\u0006\u0010\u0005\u001a\u00020=2\b\u0010\u0018\u001a\u0004\u0018\u00010\u00192\u0012\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\n0\bH\u0003J\u001c\u0010<\u001a\u00020\u0004*\u00020\u001d2\u0006\u0010\u0005\u001a\u00020=2\u0006\u0010&\u001a\u00020'H\u0003J\u001e\u0010>\u001a\u00020\n*\u00020$2\u0006\u0010\u0005\u001a\u00020%2\b\u0010/\u001a\u0004\u0018\u00010\u0019H\u0003J\u001c\u0010>\u001a\u00020\n*\u00020\u001d2\u0006\u0010\u0005\u001a\u00020%2\u0006\u0010&\u001a\u00020'H\u0003J\u001e\u0010?\u001a\u00020\n*\u00020$2\u0006\u0010\u0005\u001a\u00020)2\b\u0010/\u001a\u0004\u0018\u00010\u0019H\u0003J\u001c\u0010?\u001a\u00020\n*\u00020\u001d2\u0006\u0010\u0005\u001a\u00020)2\u0006\u0010&\u001a\u00020'H\u0003J-\u0010@\u001a\u00020\u0011*\u00020$2\u0006\u0010\u0005\u001a\u00020A2\b\u0010/\u001a\u0004\u0018\u00010\u00192\b\u0010B\u001a\u0004\u0018\u00010CH\u0001¢\u0006\u0002\bDJ+\u0010@\u001a\u00020\u0011*\u00020\u001d2\u0006\u00103\u001a\u00020A2\u0006\u0010&\u001a\u00020'2\b\u0010B\u001a\u0004\u0018\u00010CH\u0001¢\u0006\u0002\bDJ\u001e\u0010E\u001a\u00020\n*\u00020$2\u0006\u0010\u0005\u001a\u00020;2\b\u0010/\u001a\u0004\u0018\u00010\u0019H\u0003J\u001c\u0010E\u001a\u00020\n*\u00020\u001d2\u0006\u0010\u0005\u001a\u00020;2\u0006\u0010&\u001a\u00020'H\u0003J\u001e\u0010F\u001a\u00020\n*\u00020$2\u0006\u0010\u0005\u001a\u00020=2\b\u0010/\u001a\u0004\u0018\u00010\u0019H\u0003J\u001c\u0010F\u001a\u00020\n*\u00020\u001d2\u0006\u0010\u0005\u001a\u00020=2\u0006\u0010&\u001a\u00020'H\u0003J\u0019\u0010G\u001a\u00020H*\u00020\u0004H\u0003ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\bI\u0010J\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006K"}, d2 = {"Landroidx/compose/foundation/text/input/internal/HandwritingGestureApi34;", "", "()V", "fallbackOnLegacyTextField", "", "gesture", "Landroid/view/inputmethod/HandwritingGesture;", "editCommandConsumer", "Lkotlin/Function1;", "Landroidx/compose/ui/text/input/EditCommand;", "", "performDeletionOnLegacyTextField", "range", "Landroidx/compose/ui/text/TextRange;", "text", "Landroidx/compose/ui/text/AnnotatedString;", "adjustRange", "", "performDeletionOnLegacyTextField-vJH6DeI", "(JLandroidx/compose/ui/text/AnnotatedString;ZLkotlin/jvm/functions/Function1;)V", "performInsertionOnLegacyTextField", "offset", "", "performSelectionOnLegacyTextField", "textSelectionManager", "Landroidx/compose/foundation/text/selection/TextFieldSelectionManager;", "performSelectionOnLegacyTextField-8ffj60Q", "(JLandroidx/compose/foundation/text/selection/TextFieldSelectionManager;Lkotlin/jvm/functions/Function1;)V", "fallback", "Landroidx/compose/foundation/text/input/internal/TransformedTextFieldState;", "highlightRange", "type", "Landroidx/compose/foundation/text/input/TextHighlightType;", "highlightRange-XJREzCE", "(Landroidx/compose/foundation/text/input/internal/TransformedTextFieldState;JI)V", "performDeleteGesture", "Landroidx/compose/foundation/text/LegacyTextFieldState;", "Landroid/view/inputmethod/DeleteGesture;", "layoutState", "Landroidx/compose/foundation/text/input/internal/TextLayoutState;", "performDeleteRangeGesture", "Landroid/view/inputmethod/DeleteRangeGesture;", "performDeletion", "rangeInTransformedText", "performDeletion-Sb-Bc2M", "(Landroidx/compose/foundation/text/input/internal/TransformedTextFieldState;JZ)V", "performHandwritingGesture", "textFieldSelectionManager", "viewConfiguration", "Landroidx/compose/ui/platform/ViewConfiguration;", "performHandwritingGesture$foundation_release", "handwritingGesture", "performInsertGesture", "Landroid/view/inputmethod/InsertGesture;", "performJoinOrSplitGesture", "Landroid/view/inputmethod/JoinOrSplitGesture;", "performRemoveSpaceGesture", "Landroid/view/inputmethod/RemoveSpaceGesture;", "performSelectGesture", "Landroid/view/inputmethod/SelectGesture;", "performSelectRangeGesture", "Landroid/view/inputmethod/SelectRangeGesture;", "previewDeleteGesture", "previewDeleteRangeGesture", "previewHandwritingGesture", "Landroid/view/inputmethod/PreviewableHandwritingGesture;", "cancellationSignal", "Landroid/os/CancellationSignal;", "previewHandwritingGesture$foundation_release", "previewSelectGesture", "previewSelectRangeGesture", "toTextGranularity", "Landroidx/compose/ui/text/TextGranularity;", "toTextGranularity-NUwxegE", "(I)I", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class HandwritingGestureApi34 {
    public static final int $stable = 0;
    public static final HandwritingGestureApi34 INSTANCE = new HandwritingGestureApi34();

    private HandwritingGestureApi34() {
    }

    public final int performHandwritingGesture$foundation_release(TransformedTextFieldState transformedTextFieldState, HandwritingGesture handwritingGesture, TextLayoutState textLayoutState, ViewConfiguration viewConfiguration) {
        if (Api26Bitmap$$ExternalSyntheticApiModelOutline0.m$1(handwritingGesture)) {
            return performSelectGesture(transformedTextFieldState, Api26Bitmap$$ExternalSyntheticApiModelOutline0.m125m((Object) handwritingGesture), textLayoutState);
        }
        if (Api26Bitmap$$ExternalSyntheticApiModelOutline0.m150m((Object) handwritingGesture)) {
            return performDeleteGesture(transformedTextFieldState, Api26Bitmap$$ExternalSyntheticApiModelOutline0.m122m((Object) handwritingGesture), textLayoutState);
        }
        if (Api26Bitmap$$ExternalSyntheticApiModelOutline0.m$2(handwritingGesture)) {
            return performSelectRangeGesture(transformedTextFieldState, Api26Bitmap$$ExternalSyntheticApiModelOutline0.m126m((Object) handwritingGesture), textLayoutState);
        }
        if (Api26Bitmap$$ExternalSyntheticApiModelOutline0.m$3(handwritingGesture)) {
            return performDeleteRangeGesture(transformedTextFieldState, Api26Bitmap$$ExternalSyntheticApiModelOutline0.m123m((Object) handwritingGesture), textLayoutState);
        }
        if (ComponentDialog$$ExternalSyntheticApiModelOutline0.m$1(handwritingGesture)) {
            return performJoinOrSplitGesture(transformedTextFieldState, ComponentDialog$$ExternalSyntheticApiModelOutline0.m27m((Object) handwritingGesture), textLayoutState, viewConfiguration);
        }
        if (Api26Bitmap$$ExternalSyntheticApiModelOutline0.m$4(handwritingGesture)) {
            return performInsertGesture(transformedTextFieldState, ComponentDialog$$ExternalSyntheticApiModelOutline0.m26m((Object) handwritingGesture), textLayoutState, viewConfiguration);
        }
        if (ComponentDialog$$ExternalSyntheticApiModelOutline0.m70m((Object) handwritingGesture)) {
            return performRemoveSpaceGesture(transformedTextFieldState, ComponentDialog$$ExternalSyntheticApiModelOutline0.m28m((Object) handwritingGesture), textLayoutState, viewConfiguration);
        }
        return 2;
    }

    public final boolean previewHandwritingGesture$foundation_release(final TransformedTextFieldState transformedTextFieldState, PreviewableHandwritingGesture previewableHandwritingGesture, TextLayoutState textLayoutState, CancellationSignal cancellationSignal) {
        if (Api26Bitmap$$ExternalSyntheticApiModelOutline0.m$1(previewableHandwritingGesture)) {
            previewSelectGesture(transformedTextFieldState, Api26Bitmap$$ExternalSyntheticApiModelOutline0.m125m((Object) previewableHandwritingGesture), textLayoutState);
        } else if (Api26Bitmap$$ExternalSyntheticApiModelOutline0.m150m((Object) previewableHandwritingGesture)) {
            previewDeleteGesture(transformedTextFieldState, Api26Bitmap$$ExternalSyntheticApiModelOutline0.m122m((Object) previewableHandwritingGesture), textLayoutState);
        } else if (Api26Bitmap$$ExternalSyntheticApiModelOutline0.m$2(previewableHandwritingGesture)) {
            previewSelectRangeGesture(transformedTextFieldState, Api26Bitmap$$ExternalSyntheticApiModelOutline0.m126m((Object) previewableHandwritingGesture), textLayoutState);
        } else {
            if (!Api26Bitmap$$ExternalSyntheticApiModelOutline0.m$3(previewableHandwritingGesture)) {
                return false;
            }
            previewDeleteRangeGesture(transformedTextFieldState, Api26Bitmap$$ExternalSyntheticApiModelOutline0.m123m((Object) previewableHandwritingGesture), textLayoutState);
        }
        if (cancellationSignal == null) {
            return true;
        }
        cancellationSignal.setOnCancelListener(new CancellationSignal.OnCancelListener() {
            @Override
            public final void onCancel() {
                HandwritingGestureApi34.previewHandwritingGesture$lambda$1(transformedTextFieldState);
            }
        });
        return true;
    }

    private final int performSelectGesture(TransformedTextFieldState transformedTextFieldState, SelectGesture selectGesture, TextLayoutState textLayoutState) {
        long jM1645getRangeForScreenRectOH9lIzo = HandwritingGesture_androidKt.m1645getRangeForScreenRectOH9lIzo(textLayoutState, RectHelper_androidKt.toComposeRect(selectGesture.getSelectionArea()), m1627toTextGranularityNUwxegE(selectGesture.getGranularity()), TextInclusionStrategy.Companion.getContainsCenter());
        if (TextRange.getCollapsed-impl(jM1645getRangeForScreenRectOH9lIzo)) {
            return INSTANCE.fallback(transformedTextFieldState, Api26Bitmap$$ExternalSyntheticApiModelOutline0.m124m((Object) selectGesture));
        }
        transformedTextFieldState.m1726selectCharsIn5zctL8(jM1645getRangeForScreenRectOH9lIzo);
        return 1;
    }

    private final void previewSelectGesture(TransformedTextFieldState transformedTextFieldState, SelectGesture selectGesture, TextLayoutState textLayoutState) {
        m1623highlightRangeXJREzCE(transformedTextFieldState, HandwritingGesture_androidKt.m1645getRangeForScreenRectOH9lIzo(textLayoutState, RectHelper_androidKt.toComposeRect(selectGesture.getSelectionArea()), m1627toTextGranularityNUwxegE(selectGesture.getGranularity()), TextInclusionStrategy.Companion.getContainsCenter()), TextHighlightType.INSTANCE.m1594getHandwritingSelectPreviewsxJuwY());
    }

    private final int performDeleteGesture(TransformedTextFieldState transformedTextFieldState, DeleteGesture deleteGesture, TextLayoutState textLayoutState) {
        int iM1627toTextGranularityNUwxegE = m1627toTextGranularityNUwxegE(deleteGesture.getGranularity());
        long jM1645getRangeForScreenRectOH9lIzo = HandwritingGesture_androidKt.m1645getRangeForScreenRectOH9lIzo(textLayoutState, RectHelper_androidKt.toComposeRect(deleteGesture.getDeletionArea()), iM1627toTextGranularityNUwxegE, TextInclusionStrategy.Companion.getContainsCenter());
        if (TextRange.getCollapsed-impl(jM1645getRangeForScreenRectOH9lIzo)) {
            return INSTANCE.fallback(transformedTextFieldState, Api26Bitmap$$ExternalSyntheticApiModelOutline0.m124m((Object) deleteGesture));
        }
        m1624performDeletionSbBc2M(transformedTextFieldState, jM1645getRangeForScreenRectOH9lIzo, TextGranularity.equals-impl0(iM1627toTextGranularityNUwxegE, TextGranularity.Companion.getWord-DRrd7Zo()));
        return 1;
    }

    private final void previewDeleteGesture(TransformedTextFieldState transformedTextFieldState, DeleteGesture deleteGesture, TextLayoutState textLayoutState) {
        m1623highlightRangeXJREzCE(transformedTextFieldState, HandwritingGesture_androidKt.m1645getRangeForScreenRectOH9lIzo(textLayoutState, RectHelper_androidKt.toComposeRect(deleteGesture.getDeletionArea()), m1627toTextGranularityNUwxegE(deleteGesture.getGranularity()), TextInclusionStrategy.Companion.getContainsCenter()), TextHighlightType.INSTANCE.m1593getHandwritingDeletePreviewsxJuwY());
    }

    private final int performSelectRangeGesture(TransformedTextFieldState transformedTextFieldState, SelectRangeGesture selectRangeGesture, TextLayoutState textLayoutState) {
        long jM1647getRangeForScreenRectsO048IG0 = HandwritingGesture_androidKt.m1647getRangeForScreenRectsO048IG0(textLayoutState, RectHelper_androidKt.toComposeRect(selectRangeGesture.getSelectionStartArea()), RectHelper_androidKt.toComposeRect(selectRangeGesture.getSelectionEndArea()), m1627toTextGranularityNUwxegE(selectRangeGesture.getGranularity()), TextInclusionStrategy.Companion.getContainsCenter());
        if (TextRange.getCollapsed-impl(jM1647getRangeForScreenRectsO048IG0)) {
            return INSTANCE.fallback(transformedTextFieldState, Api26Bitmap$$ExternalSyntheticApiModelOutline0.m124m((Object) selectRangeGesture));
        }
        transformedTextFieldState.m1726selectCharsIn5zctL8(jM1647getRangeForScreenRectsO048IG0);
        return 1;
    }

    private final void previewSelectRangeGesture(TransformedTextFieldState transformedTextFieldState, SelectRangeGesture selectRangeGesture, TextLayoutState textLayoutState) {
        m1623highlightRangeXJREzCE(transformedTextFieldState, HandwritingGesture_androidKt.m1647getRangeForScreenRectsO048IG0(textLayoutState, RectHelper_androidKt.toComposeRect(selectRangeGesture.getSelectionStartArea()), RectHelper_androidKt.toComposeRect(selectRangeGesture.getSelectionEndArea()), m1627toTextGranularityNUwxegE(selectRangeGesture.getGranularity()), TextInclusionStrategy.Companion.getContainsCenter()), TextHighlightType.INSTANCE.m1594getHandwritingSelectPreviewsxJuwY());
    }

    private final int performDeleteRangeGesture(TransformedTextFieldState transformedTextFieldState, DeleteRangeGesture deleteRangeGesture, TextLayoutState textLayoutState) {
        int iM1627toTextGranularityNUwxegE = m1627toTextGranularityNUwxegE(deleteRangeGesture.getGranularity());
        long jM1647getRangeForScreenRectsO048IG0 = HandwritingGesture_androidKt.m1647getRangeForScreenRectsO048IG0(textLayoutState, RectHelper_androidKt.toComposeRect(deleteRangeGesture.getDeletionStartArea()), RectHelper_androidKt.toComposeRect(deleteRangeGesture.getDeletionEndArea()), iM1627toTextGranularityNUwxegE, TextInclusionStrategy.Companion.getContainsCenter());
        if (TextRange.getCollapsed-impl(jM1647getRangeForScreenRectsO048IG0)) {
            return INSTANCE.fallback(transformedTextFieldState, Api26Bitmap$$ExternalSyntheticApiModelOutline0.m124m((Object) deleteRangeGesture));
        }
        m1624performDeletionSbBc2M(transformedTextFieldState, jM1647getRangeForScreenRectsO048IG0, TextGranularity.equals-impl0(iM1627toTextGranularityNUwxegE, TextGranularity.Companion.getWord-DRrd7Zo()));
        return 1;
    }

    private final void previewDeleteRangeGesture(TransformedTextFieldState transformedTextFieldState, DeleteRangeGesture deleteRangeGesture, TextLayoutState textLayoutState) {
        m1623highlightRangeXJREzCE(transformedTextFieldState, HandwritingGesture_androidKt.m1647getRangeForScreenRectsO048IG0(textLayoutState, RectHelper_androidKt.toComposeRect(deleteRangeGesture.getDeletionStartArea()), RectHelper_androidKt.toComposeRect(deleteRangeGesture.getDeletionEndArea()), m1627toTextGranularityNUwxegE(deleteRangeGesture.getGranularity()), TextInclusionStrategy.Companion.getContainsCenter()), TextHighlightType.INSTANCE.m1593getHandwritingDeletePreviewsxJuwY());
    }

    private final int performJoinOrSplitGesture(TransformedTextFieldState transformedTextFieldState, JoinOrSplitGesture joinOrSplitGesture, TextLayoutState textLayoutState, ViewConfiguration viewConfiguration) {
        TextLayoutResult layoutResult;
        if (transformedTextFieldState.getOutputText() != transformedTextFieldState.getUntransformedText()) {
            return 3;
        }
        int iM1640getOffsetForHandwritingGestured4ec7I = HandwritingGesture_androidKt.m1640getOffsetForHandwritingGestured4ec7I(textLayoutState, HandwritingGesture_androidKt.toOffset(joinOrSplitGesture.getJoinOrSplitPoint()), viewConfiguration);
        if (iM1640getOffsetForHandwritingGestured4ec7I != -1 && ((layoutResult = textLayoutState.getLayoutResult()) == null || !HandwritingGesture_androidKt.isBiDiBoundary(layoutResult, iM1640getOffsetForHandwritingGestured4ec7I))) {
            long jRangeOfWhitespaces = HandwritingGesture_androidKt.rangeOfWhitespaces(transformedTextFieldState.getVisualText(), iM1640getOffsetForHandwritingGestured4ec7I);
            if (TextRange.getCollapsed-impl(jRangeOfWhitespaces)) {
                TransformedTextFieldState.m1719replaceTextM8tDOmk$default(transformedTextFieldState, " ", jRangeOfWhitespaces, null, false, 12, null);
            } else {
                m1624performDeletionSbBc2M(transformedTextFieldState, jRangeOfWhitespaces, false);
            }
            return 1;
        }
        return fallback(transformedTextFieldState, Api26Bitmap$$ExternalSyntheticApiModelOutline0.m124m((Object) joinOrSplitGesture));
    }

    private final int performInsertGesture(TransformedTextFieldState transformedTextFieldState, InsertGesture insertGesture, TextLayoutState textLayoutState, ViewConfiguration viewConfiguration) {
        int iM1640getOffsetForHandwritingGestured4ec7I = HandwritingGesture_androidKt.m1640getOffsetForHandwritingGestured4ec7I(textLayoutState, HandwritingGesture_androidKt.toOffset(insertGesture.getInsertionPoint()), viewConfiguration);
        if (iM1640getOffsetForHandwritingGestured4ec7I == -1) {
            return fallback(transformedTextFieldState, Api26Bitmap$$ExternalSyntheticApiModelOutline0.m124m((Object) insertGesture));
        }
        TransformedTextFieldState.m1719replaceTextM8tDOmk$default(transformedTextFieldState, insertGesture.getTextToInsert(), TextRangeKt.TextRange(iM1640getOffsetForHandwritingGestured4ec7I), null, false, 12, null);
        return 1;
    }

    private final int performRemoveSpaceGesture(TransformedTextFieldState transformedTextFieldState, RemoveSpaceGesture removeSpaceGesture, TextLayoutState textLayoutState, ViewConfiguration viewConfiguration) {
        long jM1642getRangeForRemoveSpaceGesture5iVPX68 = HandwritingGesture_androidKt.m1642getRangeForRemoveSpaceGesture5iVPX68(textLayoutState.getLayoutResult(), HandwritingGesture_androidKt.toOffset(removeSpaceGesture.getStartPoint()), HandwritingGesture_androidKt.toOffset(removeSpaceGesture.getEndPoint()), textLayoutState.getTextLayoutNodeCoordinates(), viewConfiguration);
        if (TextRange.getCollapsed-impl(jM1642getRangeForRemoveSpaceGesture5iVPX68)) {
            return INSTANCE.fallback(transformedTextFieldState, Api26Bitmap$$ExternalSyntheticApiModelOutline0.m124m((Object) removeSpaceGesture));
        }
        final Ref.IntRef intRef = new Ref.IntRef();
        intRef.element = -1;
        final Ref.IntRef intRef2 = new Ref.IntRef();
        intRef2.element = -1;
        String strReplace = new Regex("\\s+").replace(TextRangeKt.substring-FDrldGo(transformedTextFieldState.getVisualText(), jM1642getRangeForRemoveSpaceGesture5iVPX68), new Function1<MatchResult, CharSequence>() {
            {
                super(1);
            }

            public final CharSequence invoke(MatchResult matchResult) {
                if (intRef.element == -1) {
                    intRef.element = matchResult.getRange().getFirst();
                }
                intRef2.element = matchResult.getRange().getLast() + 1;
                return "";
            }
        });
        if (intRef.element == -1 || intRef2.element == -1) {
            return fallback(transformedTextFieldState, Api26Bitmap$$ExternalSyntheticApiModelOutline0.m124m((Object) removeSpaceGesture));
        }
        long jTextRange = TextRangeKt.TextRange(TextRange.getStart-impl(jM1642getRangeForRemoveSpaceGesture5iVPX68) + intRef.element, TextRange.getStart-impl(jM1642getRangeForRemoveSpaceGesture5iVPX68) + intRef2.element);
        String strSubstring = strReplace.substring(intRef.element, strReplace.length() - (TextRange.getLength-impl(jM1642getRangeForRemoveSpaceGesture5iVPX68) - intRef2.element));
        Intrinsics.checkNotNullExpressionValue(strSubstring, "this as java.lang.String…ing(startIndex, endIndex)");
        TransformedTextFieldState.m1719replaceTextM8tDOmk$default(transformedTextFieldState, strSubstring, jTextRange, null, false, 12, null);
        return 1;
    }

    private final void m1624performDeletionSbBc2M(TransformedTextFieldState transformedTextFieldState, long j, boolean z) {
        if (z) {
            j = HandwritingGesture_androidKt.m1636adjustHandwritingDeleteGestureRange72CqOWE(j, transformedTextFieldState.getVisualText());
        }
        TransformedTextFieldState.m1719replaceTextM8tDOmk$default(transformedTextFieldState, "", j, null, false, 12, null);
    }

    private final void m1623highlightRangeXJREzCE(TransformedTextFieldState transformedTextFieldState, long j, int i) {
        if (TextRange.getCollapsed-impl(j)) {
            TextFieldState textFieldState = transformedTextFieldState.textFieldState;
            InputTransformation inputTransformation = transformedTextFieldState.inputTransformation;
            TextFieldEditUndoBehavior textFieldEditUndoBehavior = TextFieldEditUndoBehavior.MergeIfPossible;
            textFieldState.getMainBuffer().getChangeTracker().clearChanges();
            textFieldState.getMainBuffer().clearHighlight();
            textFieldState.commitEditAsUser(inputTransformation, true, textFieldEditUndoBehavior);
            return;
        }
        transformedTextFieldState.m1720highlightCharsIn7RAjNK8(i, j);
    }

    public final int performHandwritingGesture$foundation_release(LegacyTextFieldState legacyTextFieldState, HandwritingGesture handwritingGesture, TextFieldSelectionManager textFieldSelectionManager, ViewConfiguration viewConfiguration, Function1<? super EditCommand, Unit> function1) {
        TextLayoutResult value;
        TextLayoutInput layoutInput;
        AnnotatedString untransformedText = legacyTextFieldState.getUntransformedText();
        if (untransformedText == null) {
            return 3;
        }
        TextLayoutResultProxy layoutResult = legacyTextFieldState.getLayoutResult();
        if (!Intrinsics.areEqual(untransformedText, (layoutResult == null || (value = layoutResult.getValue()) == null || (layoutInput = value.getLayoutInput()) == null) ? null : layoutInput.getText())) {
            return 3;
        }
        if (Api26Bitmap$$ExternalSyntheticApiModelOutline0.m$1(handwritingGesture)) {
            return performSelectGesture(legacyTextFieldState, Api26Bitmap$$ExternalSyntheticApiModelOutline0.m125m((Object) handwritingGesture), textFieldSelectionManager, function1);
        }
        if (Api26Bitmap$$ExternalSyntheticApiModelOutline0.m150m((Object) handwritingGesture)) {
            return performDeleteGesture(legacyTextFieldState, Api26Bitmap$$ExternalSyntheticApiModelOutline0.m122m((Object) handwritingGesture), untransformedText, function1);
        }
        if (Api26Bitmap$$ExternalSyntheticApiModelOutline0.m$2(handwritingGesture)) {
            return performSelectRangeGesture(legacyTextFieldState, Api26Bitmap$$ExternalSyntheticApiModelOutline0.m126m((Object) handwritingGesture), textFieldSelectionManager, function1);
        }
        if (Api26Bitmap$$ExternalSyntheticApiModelOutline0.m$3(handwritingGesture)) {
            return performDeleteRangeGesture(legacyTextFieldState, Api26Bitmap$$ExternalSyntheticApiModelOutline0.m123m((Object) handwritingGesture), untransformedText, function1);
        }
        if (ComponentDialog$$ExternalSyntheticApiModelOutline0.m$1(handwritingGesture)) {
            return performJoinOrSplitGesture(legacyTextFieldState, ComponentDialog$$ExternalSyntheticApiModelOutline0.m27m((Object) handwritingGesture), untransformedText, viewConfiguration, function1);
        }
        if (Api26Bitmap$$ExternalSyntheticApiModelOutline0.m$4(handwritingGesture)) {
            return performInsertGesture(legacyTextFieldState, ComponentDialog$$ExternalSyntheticApiModelOutline0.m26m((Object) handwritingGesture), viewConfiguration, function1);
        }
        if (ComponentDialog$$ExternalSyntheticApiModelOutline0.m70m((Object) handwritingGesture)) {
            return performRemoveSpaceGesture(legacyTextFieldState, ComponentDialog$$ExternalSyntheticApiModelOutline0.m28m((Object) handwritingGesture), untransformedText, viewConfiguration, function1);
        }
        return 2;
    }

    public final boolean previewHandwritingGesture$foundation_release(LegacyTextFieldState legacyTextFieldState, PreviewableHandwritingGesture previewableHandwritingGesture, final TextFieldSelectionManager textFieldSelectionManager, CancellationSignal cancellationSignal) {
        TextLayoutResult value;
        TextLayoutInput layoutInput;
        AnnotatedString untransformedText = legacyTextFieldState.getUntransformedText();
        if (untransformedText == null) {
            return false;
        }
        TextLayoutResultProxy layoutResult = legacyTextFieldState.getLayoutResult();
        if (!Intrinsics.areEqual(untransformedText, (layoutResult == null || (value = layoutResult.getValue()) == null || (layoutInput = value.getLayoutInput()) == null) ? null : layoutInput.getText())) {
            return false;
        }
        if (Api26Bitmap$$ExternalSyntheticApiModelOutline0.m$1(previewableHandwritingGesture)) {
            previewSelectGesture(legacyTextFieldState, Api26Bitmap$$ExternalSyntheticApiModelOutline0.m125m((Object) previewableHandwritingGesture), textFieldSelectionManager);
        } else if (Api26Bitmap$$ExternalSyntheticApiModelOutline0.m150m((Object) previewableHandwritingGesture)) {
            previewDeleteGesture(legacyTextFieldState, Api26Bitmap$$ExternalSyntheticApiModelOutline0.m122m((Object) previewableHandwritingGesture), textFieldSelectionManager);
        } else if (Api26Bitmap$$ExternalSyntheticApiModelOutline0.m$2(previewableHandwritingGesture)) {
            previewSelectRangeGesture(legacyTextFieldState, Api26Bitmap$$ExternalSyntheticApiModelOutline0.m126m((Object) previewableHandwritingGesture), textFieldSelectionManager);
        } else {
            if (!Api26Bitmap$$ExternalSyntheticApiModelOutline0.m$3(previewableHandwritingGesture)) {
                return false;
            }
            previewDeleteRangeGesture(legacyTextFieldState, Api26Bitmap$$ExternalSyntheticApiModelOutline0.m123m((Object) previewableHandwritingGesture), textFieldSelectionManager);
        }
        if (cancellationSignal == null) {
            return true;
        }
        cancellationSignal.setOnCancelListener(new CancellationSignal.OnCancelListener() {
            @Override
            public final void onCancel() {
                HandwritingGestureApi34.previewHandwritingGesture$lambda$9(textFieldSelectionManager);
            }
        });
        return true;
    }

    public static final void previewHandwritingGesture$lambda$9(TextFieldSelectionManager textFieldSelectionManager) {
        if (textFieldSelectionManager != null) {
            textFieldSelectionManager.clearPreviewHighlight$foundation_release();
        }
    }

    private final int performSelectGesture(LegacyTextFieldState legacyTextFieldState, SelectGesture selectGesture, TextFieldSelectionManager textFieldSelectionManager, Function1<? super EditCommand, Unit> function1) {
        long jM1644getRangeForScreenRectOH9lIzo = HandwritingGesture_androidKt.m1644getRangeForScreenRectOH9lIzo(legacyTextFieldState, RectHelper_androidKt.toComposeRect(selectGesture.getSelectionArea()), m1627toTextGranularityNUwxegE(selectGesture.getGranularity()), TextInclusionStrategy.Companion.getContainsCenter());
        if (TextRange.getCollapsed-impl(jM1644getRangeForScreenRectOH9lIzo)) {
            return INSTANCE.fallbackOnLegacyTextField(Api26Bitmap$$ExternalSyntheticApiModelOutline0.m124m((Object) selectGesture), function1);
        }
        m1626performSelectionOnLegacyTextField8ffj60Q(jM1644getRangeForScreenRectOH9lIzo, textFieldSelectionManager, function1);
        return 1;
    }

    private final void previewSelectGesture(LegacyTextFieldState legacyTextFieldState, SelectGesture selectGesture, TextFieldSelectionManager textFieldSelectionManager) {
        if (textFieldSelectionManager != null) {
            textFieldSelectionManager.m1943setSelectionPreviewHighlight5zctL8$foundation_release(HandwritingGesture_androidKt.m1644getRangeForScreenRectOH9lIzo(legacyTextFieldState, RectHelper_androidKt.toComposeRect(selectGesture.getSelectionArea()), m1627toTextGranularityNUwxegE(selectGesture.getGranularity()), TextInclusionStrategy.Companion.getContainsCenter()));
        }
    }

    private final int performDeleteGesture(LegacyTextFieldState legacyTextFieldState, DeleteGesture deleteGesture, AnnotatedString annotatedString, Function1<? super EditCommand, Unit> function1) {
        int iM1627toTextGranularityNUwxegE = m1627toTextGranularityNUwxegE(deleteGesture.getGranularity());
        long jM1644getRangeForScreenRectOH9lIzo = HandwritingGesture_androidKt.m1644getRangeForScreenRectOH9lIzo(legacyTextFieldState, RectHelper_androidKt.toComposeRect(deleteGesture.getDeletionArea()), iM1627toTextGranularityNUwxegE, TextInclusionStrategy.Companion.getContainsCenter());
        if (TextRange.getCollapsed-impl(jM1644getRangeForScreenRectOH9lIzo)) {
            return INSTANCE.fallbackOnLegacyTextField(Api26Bitmap$$ExternalSyntheticApiModelOutline0.m124m((Object) deleteGesture), function1);
        }
        m1625performDeletionOnLegacyTextFieldvJH6DeI(jM1644getRangeForScreenRectOH9lIzo, annotatedString, TextGranularity.equals-impl0(iM1627toTextGranularityNUwxegE, TextGranularity.Companion.getWord-DRrd7Zo()), function1);
        return 1;
    }

    private final void previewDeleteGesture(LegacyTextFieldState legacyTextFieldState, DeleteGesture deleteGesture, TextFieldSelectionManager textFieldSelectionManager) {
        if (textFieldSelectionManager != null) {
            textFieldSelectionManager.m1942setDeletionPreviewHighlight5zctL8$foundation_release(HandwritingGesture_androidKt.m1644getRangeForScreenRectOH9lIzo(legacyTextFieldState, RectHelper_androidKt.toComposeRect(deleteGesture.getDeletionArea()), m1627toTextGranularityNUwxegE(deleteGesture.getGranularity()), TextInclusionStrategy.Companion.getContainsCenter()));
        }
    }

    private final int performSelectRangeGesture(LegacyTextFieldState legacyTextFieldState, SelectRangeGesture selectRangeGesture, TextFieldSelectionManager textFieldSelectionManager, Function1<? super EditCommand, Unit> function1) {
        long jM1646getRangeForScreenRectsO048IG0 = HandwritingGesture_androidKt.m1646getRangeForScreenRectsO048IG0(legacyTextFieldState, RectHelper_androidKt.toComposeRect(selectRangeGesture.getSelectionStartArea()), RectHelper_androidKt.toComposeRect(selectRangeGesture.getSelectionEndArea()), m1627toTextGranularityNUwxegE(selectRangeGesture.getGranularity()), TextInclusionStrategy.Companion.getContainsCenter());
        if (TextRange.getCollapsed-impl(jM1646getRangeForScreenRectsO048IG0)) {
            return INSTANCE.fallbackOnLegacyTextField(Api26Bitmap$$ExternalSyntheticApiModelOutline0.m124m((Object) selectRangeGesture), function1);
        }
        m1626performSelectionOnLegacyTextField8ffj60Q(jM1646getRangeForScreenRectsO048IG0, textFieldSelectionManager, function1);
        return 1;
    }

    private final void previewSelectRangeGesture(LegacyTextFieldState legacyTextFieldState, SelectRangeGesture selectRangeGesture, TextFieldSelectionManager textFieldSelectionManager) {
        if (textFieldSelectionManager != null) {
            textFieldSelectionManager.m1943setSelectionPreviewHighlight5zctL8$foundation_release(HandwritingGesture_androidKt.m1646getRangeForScreenRectsO048IG0(legacyTextFieldState, RectHelper_androidKt.toComposeRect(selectRangeGesture.getSelectionStartArea()), RectHelper_androidKt.toComposeRect(selectRangeGesture.getSelectionEndArea()), m1627toTextGranularityNUwxegE(selectRangeGesture.getGranularity()), TextInclusionStrategy.Companion.getContainsCenter()));
        }
    }

    private final int performDeleteRangeGesture(LegacyTextFieldState legacyTextFieldState, DeleteRangeGesture deleteRangeGesture, AnnotatedString annotatedString, Function1<? super EditCommand, Unit> function1) {
        int iM1627toTextGranularityNUwxegE = m1627toTextGranularityNUwxegE(deleteRangeGesture.getGranularity());
        long jM1646getRangeForScreenRectsO048IG0 = HandwritingGesture_androidKt.m1646getRangeForScreenRectsO048IG0(legacyTextFieldState, RectHelper_androidKt.toComposeRect(deleteRangeGesture.getDeletionStartArea()), RectHelper_androidKt.toComposeRect(deleteRangeGesture.getDeletionEndArea()), iM1627toTextGranularityNUwxegE, TextInclusionStrategy.Companion.getContainsCenter());
        if (TextRange.getCollapsed-impl(jM1646getRangeForScreenRectsO048IG0)) {
            return INSTANCE.fallbackOnLegacyTextField(Api26Bitmap$$ExternalSyntheticApiModelOutline0.m124m((Object) deleteRangeGesture), function1);
        }
        m1625performDeletionOnLegacyTextFieldvJH6DeI(jM1646getRangeForScreenRectsO048IG0, annotatedString, TextGranularity.equals-impl0(iM1627toTextGranularityNUwxegE, TextGranularity.Companion.getWord-DRrd7Zo()), function1);
        return 1;
    }

    private final void previewDeleteRangeGesture(LegacyTextFieldState legacyTextFieldState, DeleteRangeGesture deleteRangeGesture, TextFieldSelectionManager textFieldSelectionManager) {
        if (textFieldSelectionManager != null) {
            textFieldSelectionManager.m1942setDeletionPreviewHighlight5zctL8$foundation_release(HandwritingGesture_androidKt.m1646getRangeForScreenRectsO048IG0(legacyTextFieldState, RectHelper_androidKt.toComposeRect(deleteRangeGesture.getDeletionStartArea()), RectHelper_androidKt.toComposeRect(deleteRangeGesture.getDeletionEndArea()), m1627toTextGranularityNUwxegE(deleteRangeGesture.getGranularity()), TextInclusionStrategy.Companion.getContainsCenter()));
        }
    }

    private final int performJoinOrSplitGesture(LegacyTextFieldState legacyTextFieldState, JoinOrSplitGesture joinOrSplitGesture, AnnotatedString annotatedString, ViewConfiguration viewConfiguration, Function1<? super EditCommand, Unit> function1) {
        TextLayoutResultProxy layoutResult;
        TextLayoutResult value;
        if (viewConfiguration != null) {
            int iM1639getOffsetForHandwritingGestured4ec7I = HandwritingGesture_androidKt.m1639getOffsetForHandwritingGestured4ec7I(legacyTextFieldState, HandwritingGesture_androidKt.toOffset(joinOrSplitGesture.getJoinOrSplitPoint()), viewConfiguration);
            if (iM1639getOffsetForHandwritingGestured4ec7I != -1 && ((layoutResult = legacyTextFieldState.getLayoutResult()) == null || (value = layoutResult.getValue()) == null || !HandwritingGesture_androidKt.isBiDiBoundary(value, iM1639getOffsetForHandwritingGestured4ec7I))) {
                long jRangeOfWhitespaces = HandwritingGesture_androidKt.rangeOfWhitespaces((CharSequence) annotatedString, iM1639getOffsetForHandwritingGestured4ec7I);
                if (TextRange.getCollapsed-impl(jRangeOfWhitespaces)) {
                    performInsertionOnLegacyTextField(TextRange.getStart-impl(jRangeOfWhitespaces), " ", function1);
                } else {
                    m1625performDeletionOnLegacyTextFieldvJH6DeI(jRangeOfWhitespaces, annotatedString, false, function1);
                }
                return 1;
            }
            return fallbackOnLegacyTextField(Api26Bitmap$$ExternalSyntheticApiModelOutline0.m124m((Object) joinOrSplitGesture), function1);
        }
        return fallbackOnLegacyTextField(Api26Bitmap$$ExternalSyntheticApiModelOutline0.m124m((Object) joinOrSplitGesture), function1);
    }

    private final int performInsertGesture(LegacyTextFieldState legacyTextFieldState, InsertGesture insertGesture, ViewConfiguration viewConfiguration, Function1<? super EditCommand, Unit> function1) {
        TextLayoutResultProxy layoutResult;
        TextLayoutResult value;
        if (viewConfiguration != null) {
            int iM1639getOffsetForHandwritingGestured4ec7I = HandwritingGesture_androidKt.m1639getOffsetForHandwritingGestured4ec7I(legacyTextFieldState, HandwritingGesture_androidKt.toOffset(insertGesture.getInsertionPoint()), viewConfiguration);
            if (iM1639getOffsetForHandwritingGestured4ec7I == -1 || ((layoutResult = legacyTextFieldState.getLayoutResult()) != null && (value = layoutResult.getValue()) != null && HandwritingGesture_androidKt.isBiDiBoundary(value, iM1639getOffsetForHandwritingGestured4ec7I))) {
                return fallbackOnLegacyTextField(Api26Bitmap$$ExternalSyntheticApiModelOutline0.m124m((Object) insertGesture), function1);
            }
            performInsertionOnLegacyTextField(iM1639getOffsetForHandwritingGestured4ec7I, insertGesture.getTextToInsert(), function1);
            return 1;
        }
        return fallbackOnLegacyTextField(Api26Bitmap$$ExternalSyntheticApiModelOutline0.m124m((Object) insertGesture), function1);
    }

    private final int performRemoveSpaceGesture(LegacyTextFieldState legacyTextFieldState, RemoveSpaceGesture removeSpaceGesture, AnnotatedString annotatedString, ViewConfiguration viewConfiguration, Function1<? super EditCommand, Unit> function1) {
        TextLayoutResultProxy layoutResult = legacyTextFieldState.getLayoutResult();
        long jM1642getRangeForRemoveSpaceGesture5iVPX68 = HandwritingGesture_androidKt.m1642getRangeForRemoveSpaceGesture5iVPX68(layoutResult != null ? layoutResult.getValue() : null, HandwritingGesture_androidKt.toOffset(removeSpaceGesture.getStartPoint()), HandwritingGesture_androidKt.toOffset(removeSpaceGesture.getEndPoint()), legacyTextFieldState.getLayoutCoordinates(), viewConfiguration);
        if (TextRange.getCollapsed-impl(jM1642getRangeForRemoveSpaceGesture5iVPX68)) {
            return INSTANCE.fallbackOnLegacyTextField(Api26Bitmap$$ExternalSyntheticApiModelOutline0.m124m((Object) removeSpaceGesture), function1);
        }
        final Ref.IntRef intRef = new Ref.IntRef();
        intRef.element = -1;
        final Ref.IntRef intRef2 = new Ref.IntRef();
        intRef2.element = -1;
        String strReplace = new Regex("\\s+").replace(TextRangeKt.substring-FDrldGo((CharSequence) annotatedString, jM1642getRangeForRemoveSpaceGesture5iVPX68), new Function1<MatchResult, CharSequence>() {
            {
                super(1);
            }

            public final CharSequence invoke(MatchResult matchResult) {
                if (intRef.element == -1) {
                    intRef.element = matchResult.getRange().getFirst();
                }
                intRef2.element = matchResult.getRange().getLast() + 1;
                return "";
            }
        });
        if (intRef.element == -1 || intRef2.element == -1) {
            return fallbackOnLegacyTextField(Api26Bitmap$$ExternalSyntheticApiModelOutline0.m124m((Object) removeSpaceGesture), function1);
        }
        int i = TextRange.getStart-impl(jM1642getRangeForRemoveSpaceGesture5iVPX68) + intRef.element;
        int i2 = TextRange.getStart-impl(jM1642getRangeForRemoveSpaceGesture5iVPX68) + intRef2.element;
        String strSubstring = strReplace.substring(intRef.element, strReplace.length() - (TextRange.getLength-impl(jM1642getRangeForRemoveSpaceGesture5iVPX68) - intRef2.element));
        Intrinsics.checkNotNullExpressionValue(strSubstring, "this as java.lang.String…ing(startIndex, endIndex)");
        function1.invoke(HandwritingGesture_androidKt.compoundEditCommand(new SetSelectionCommand(i, i2), new CommitTextCommand(strSubstring, 1)));
        return 1;
    }

    private final void performInsertionOnLegacyTextField(int offset, String text, Function1<? super EditCommand, Unit> editCommandConsumer) {
        editCommandConsumer.invoke(HandwritingGesture_androidKt.compoundEditCommand(new SetSelectionCommand(offset, offset), new CommitTextCommand(text, 1)));
    }

    private final void m1626performSelectionOnLegacyTextField8ffj60Q(long range, TextFieldSelectionManager textSelectionManager, Function1<? super EditCommand, Unit> editCommandConsumer) {
        editCommandConsumer.invoke(new SetSelectionCommand(TextRange.getStart-impl(range), TextRange.getEnd-impl(range)));
        if (textSelectionManager != null) {
            textSelectionManager.enterSelectionMode$foundation_release(true);
        }
    }

    private final void m1625performDeletionOnLegacyTextFieldvJH6DeI(long range, AnnotatedString text, boolean adjustRange, Function1<? super EditCommand, Unit> editCommandConsumer) {
        if (adjustRange) {
            range = HandwritingGesture_androidKt.m1636adjustHandwritingDeleteGestureRange72CqOWE(range, (CharSequence) text);
        }
        editCommandConsumer.invoke(HandwritingGesture_androidKt.compoundEditCommand(new SetSelectionCommand(TextRange.getEnd-impl(range), TextRange.getEnd-impl(range)), new DeleteSurroundingTextCommand(TextRange.getLength-impl(range), 0)));
    }

    private final int fallbackOnLegacyTextField(HandwritingGesture gesture, Function1<? super EditCommand, Unit> editCommandConsumer) {
        String fallbackText = gesture.getFallbackText();
        if (fallbackText == null) {
            return 3;
        }
        editCommandConsumer.invoke(new CommitTextCommand(fallbackText, 1));
        return 5;
    }

    private final int m1627toTextGranularityNUwxegE(int i) {
        if (i == 1) {
            return TextGranularity.Companion.getWord-DRrd7Zo();
        }
        if (i == 2) {
            return TextGranularity.Companion.getCharacter-DRrd7Zo();
        }
        return TextGranularity.Companion.getCharacter-DRrd7Zo();
    }

    private final int fallback(TransformedTextFieldState transformedTextFieldState, HandwritingGesture handwritingGesture) {
        TextFieldState textFieldState = transformedTextFieldState.textFieldState;
        InputTransformation inputTransformation = transformedTextFieldState.inputTransformation;
        TextFieldEditUndoBehavior textFieldEditUndoBehavior = TextFieldEditUndoBehavior.MergeIfPossible;
        textFieldState.getMainBuffer().getChangeTracker().clearChanges();
        textFieldState.getMainBuffer().clearHighlight();
        textFieldState.commitEditAsUser(inputTransformation, true, textFieldEditUndoBehavior);
        String fallbackText = handwritingGesture.getFallbackText();
        if (fallbackText == null) {
            return 3;
        }
        TransformedTextFieldState.replaceSelectedText$default(transformedTextFieldState, fallbackText, true, null, 4, null);
        return 5;
    }

    public static final void previewHandwritingGesture$lambda$1(TransformedTextFieldState transformedTextFieldState) {
        TextFieldState textFieldState = transformedTextFieldState.textFieldState;
        InputTransformation inputTransformation = transformedTextFieldState.inputTransformation;
        TextFieldEditUndoBehavior textFieldEditUndoBehavior = TextFieldEditUndoBehavior.MergeIfPossible;
        textFieldState.getMainBuffer().getChangeTracker().clearChanges();
        textFieldState.getMainBuffer().clearHighlight();
        textFieldState.commitEditAsUser(inputTransformation, true, textFieldEditUndoBehavior);
    }
}
