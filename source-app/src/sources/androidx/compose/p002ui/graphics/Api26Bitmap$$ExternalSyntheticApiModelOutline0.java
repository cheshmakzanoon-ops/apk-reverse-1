package androidx.compose.p002ui.graphics;

import android.graphics.BlendMode;
import android.graphics.BlendModeColorFilter;
import android.os.LocaleList;
import android.view.accessibility.AccessibilityManager;
import android.view.autofill.AutofillId;
import android.view.autofill.AutofillManager;
import android.view.autofill.AutofillValue;
import android.view.inputmethod.DeleteGesture;
import android.view.inputmethod.DeleteRangeGesture;
import android.view.inputmethod.HandwritingGesture;
import android.view.inputmethod.InsertGesture;
import android.view.inputmethod.SelectGesture;
import android.view.inputmethod.SelectRangeGesture;
import android.view.translation.ViewTranslationRequest;
import android.view.translation.ViewTranslationResponse;
import java.util.Locale;

public final class Api26Bitmap$$ExternalSyntheticApiModelOutline0 {
    public static BlendModeColorFilter m107m(int i, BlendMode blendMode) {
        return new BlendModeColorFilter(i, blendMode);
    }

    public static BlendModeColorFilter m108m(Object obj) {
        return (BlendModeColorFilter) obj;
    }

    public static LocaleList m115m(Locale[] localeArr) {
        return new LocaleList(localeArr);
    }

    public static AccessibilityManager.AccessibilityServicesStateChangeListener m116m(Object obj) {
        return (AccessibilityManager.AccessibilityServicesStateChangeListener) obj;
    }

    public static AutofillManager.AutofillCallback m119m(Object obj) {
        return (AutofillManager.AutofillCallback) obj;
    }

    public static AutofillManager m120m(Object obj) {
        return (AutofillManager) obj;
    }

    public static AutofillValue m121m(Object obj) {
        return (AutofillValue) obj;
    }

    public static DeleteGesture m122m(Object obj) {
        return (DeleteGesture) obj;
    }

    public static DeleteRangeGesture m123m(Object obj) {
        return (DeleteRangeGesture) obj;
    }

    public static HandwritingGesture m124m(Object obj) {
        return (HandwritingGesture) obj;
    }

    public static SelectGesture m125m(Object obj) {
        return (SelectGesture) obj;
    }

    public static SelectRangeGesture m126m(Object obj) {
        return (SelectRangeGesture) obj;
    }

    public static ViewTranslationRequest.Builder m129m(AutofillId autofillId, long j) {
        return new ViewTranslationRequest.Builder(autofillId, j);
    }

    public static ViewTranslationResponse m132m(Object obj) {
        return (ViewTranslationResponse) obj;
    }

    public static Class m135m() {
        return AutofillManager.class;
    }

    public static void m139m() {
    }

    public static boolean m150m(Object obj) {
        return obj instanceof DeleteGesture;
    }

    public static void m4497m$1() {
    }

    public static boolean m$1(Object obj) {
        return obj instanceof SelectGesture;
    }

    public static boolean m$2(Object obj) {
        return obj instanceof SelectRangeGesture;
    }

    public static boolean m$3(Object obj) {
        return obj instanceof DeleteRangeGesture;
    }

    public static boolean m$4(Object obj) {
        return obj instanceof InsertGesture;
    }

    public static boolean m$5(Object obj) {
        return obj instanceof BlendModeColorFilter;
    }
}
