package androidx.activity;

import android.graphics.RenderNode;
import android.view.WindowInsetsAnimationControlListener;
import android.view.WindowInsetsAnimationController;
import android.view.inputmethod.DeleteGesture;
import android.view.inputmethod.DeleteRangeGesture;
import android.view.inputmethod.EditorBoundsInfo;
import android.view.inputmethod.InsertGesture;
import android.view.inputmethod.JoinOrSplitGesture;
import android.view.inputmethod.RemoveSpaceGesture;
import android.view.inputmethod.SelectGesture;
import android.view.inputmethod.SelectRangeGesture;
import android.view.inspector.InspectionCompanion;
import android.window.OnBackInvokedCallback;
import android.window.OnBackInvokedDispatcher;

public final class ComponentDialog$$ExternalSyntheticApiModelOutline0 {
    public static RenderNode m13m(String str) {
        return new RenderNode(str);
    }

    public static WindowInsetsAnimationControlListener m18m(Object obj) {
        return (WindowInsetsAnimationControlListener) obj;
    }

    public static WindowInsetsAnimationController m19m(Object obj) {
        return (WindowInsetsAnimationController) obj;
    }

    public static EditorBoundsInfo.Builder m23m() {
        return new EditorBoundsInfo.Builder();
    }

    public static InsertGesture m26m(Object obj) {
        return (InsertGesture) obj;
    }

    public static JoinOrSplitGesture m27m(Object obj) {
        return (JoinOrSplitGesture) obj;
    }

    public static RemoveSpaceGesture m28m(Object obj) {
        return (RemoveSpaceGesture) obj;
    }

    public static InspectionCompanion.UninitializedPropertyMapException m29m() {
        return new InspectionCompanion.UninitializedPropertyMapException();
    }

    public static OnBackInvokedCallback m30m(Object obj) {
        return (OnBackInvokedCallback) obj;
    }

    public static OnBackInvokedDispatcher m33m(Object obj) {
        return (OnBackInvokedDispatcher) obj;
    }

    public static Class m34m() {
        return SelectGesture.class;
    }

    public static boolean m70m(Object obj) {
        return obj instanceof RemoveSpaceGesture;
    }

    public static Class m$1() {
        return SelectRangeGesture.class;
    }

    public static boolean m$1(Object obj) {
        return obj instanceof JoinOrSplitGesture;
    }

    public static Class m$2() {
        return DeleteRangeGesture.class;
    }

    public static Class m$3() {
        return DeleteGesture.class;
    }

    public static Class m$4() {
        return JoinOrSplitGesture.class;
    }

    public static Class m$5() {
        return InsertGesture.class;
    }

    public static Class m$6() {
        return RemoveSpaceGesture.class;
    }
}
