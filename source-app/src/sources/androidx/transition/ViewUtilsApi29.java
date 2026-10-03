package androidx.transition;

import android.graphics.Matrix;
import android.view.View;
import androidx.compose.ui.platform.AndroidComposeView$;

class ViewUtilsApi29 extends ViewUtilsApi23 {
    ViewUtilsApi29() {
    }

    @Override
    public void setTransitionAlpha(View view, float f) {
        view.setTransitionAlpha(f);
    }

    @Override
    public float getTransitionAlpha(View view) {
        return view.getTransitionAlpha();
    }

    @Override
    public void setTransitionVisibility(View view, int i) {
        view.setTransitionVisibility(i);
    }

    @Override
    public void setLeftTopRightBottom(View view, int i, int i2, int i3, int i4) {
        view.setLeftTopRightBottom(i, i2, i3, i4);
    }

    @Override
    public void transformMatrixToGlobal(View view, Matrix matrix) {
        AndroidComposeView$.ExternalSyntheticApiModelOutline0.m(view, matrix);
    }

    @Override
    public void transformMatrixToLocal(View view, Matrix matrix) {
        view.transformMatrixToLocal(matrix);
    }

    @Override
    public void setAnimationMatrix(View view, Matrix matrix) {
        view.setAnimationMatrix(matrix);
    }
}
