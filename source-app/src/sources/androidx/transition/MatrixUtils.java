package androidx.transition;

import android.graphics.Matrix;
import android.graphics.RectF;

class MatrixUtils {
    static final Matrix IDENTITY_MATRIX = new Matrix() {
        void oops() {
            throw new IllegalStateException("Matrix can not be modified");
        }

        @Override
        public void set(Matrix matrix) {
            oops();
        }

        @Override
        public void reset() {
            oops();
        }

        @Override
        public void setTranslate(float f, float f2) {
            oops();
        }

        @Override
        public void setScale(float f, float f2, float f3, float f4) {
            oops();
        }

        @Override
        public void setScale(float f, float f2) {
            oops();
        }

        @Override
        public void setRotate(float f, float f2, float f3) {
            oops();
        }

        @Override
        public void setRotate(float f) {
            oops();
        }

        @Override
        public void setSinCos(float f, float f2, float f3, float f4) {
            oops();
        }

        @Override
        public void setSinCos(float f, float f2) {
            oops();
        }

        @Override
        public void setSkew(float f, float f2, float f3, float f4) {
            oops();
        }

        @Override
        public void setSkew(float f, float f2) {
            oops();
        }

        @Override
        public boolean setConcat(Matrix matrix, Matrix matrix2) {
            oops();
            return false;
        }

        @Override
        public boolean preTranslate(float f, float f2) {
            oops();
            return false;
        }

        @Override
        public boolean preScale(float f, float f2, float f3, float f4) {
            oops();
            return false;
        }

        @Override
        public boolean preScale(float f, float f2) {
            oops();
            return false;
        }

        @Override
        public boolean preRotate(float f, float f2, float f3) {
            oops();
            return false;
        }

        @Override
        public boolean preRotate(float f) {
            oops();
            return false;
        }

        @Override
        public boolean preSkew(float f, float f2, float f3, float f4) {
            oops();
            return false;
        }

        @Override
        public boolean preSkew(float f, float f2) {
            oops();
            return false;
        }

        @Override
        public boolean preConcat(Matrix matrix) {
            oops();
            return false;
        }

        @Override
        public boolean postTranslate(float f, float f2) {
            oops();
            return false;
        }

        @Override
        public boolean postScale(float f, float f2, float f3, float f4) {
            oops();
            return false;
        }

        @Override
        public boolean postScale(float f, float f2) {
            oops();
            return false;
        }

        @Override
        public boolean postRotate(float f, float f2, float f3) {
            oops();
            return false;
        }

        @Override
        public boolean postRotate(float f) {
            oops();
            return false;
        }

        @Override
        public boolean postSkew(float f, float f2, float f3, float f4) {
            oops();
            return false;
        }

        @Override
        public boolean postSkew(float f, float f2) {
            oops();
            return false;
        }

        @Override
        public boolean postConcat(Matrix matrix) {
            oops();
            return false;
        }

        @Override
        public boolean setRectToRect(RectF rectF, RectF rectF2, Matrix.ScaleToFit scaleToFit) {
            oops();
            return false;
        }

        @Override
        public boolean setPolyToPoly(float[] fArr, int i, float[] fArr2, int i2, int i3) {
            oops();
            return false;
        }

        @Override
        public void setValues(float[] fArr) {
            oops();
        }
    };

    private MatrixUtils() {
    }
}
