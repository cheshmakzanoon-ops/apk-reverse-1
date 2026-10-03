package net.aihelp.p007ui.helper;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.util.DisplayMetrics;
import android.view.View;
import net.aihelp.config.AIHelpContext;
import net.aihelp.utils.Styles;
import net.aihelp.utils.TLog;

public class BitmapHelper {
    public static int[] computeSize(int i, int i2) {
        float f;
        int iDpToPx;
        Context context = AIHelpContext.getInstance().getContext();
        if (i > i2) {
            f = i * 1.0f;
            iDpToPx = getImageMaxWidth();
        } else {
            f = i2 * 1.0f;
            iDpToPx = Styles.dpToPx(context, 200.0f);
        }
        double d = f / iDpToPx;
        if (d < 1.0d) {
            d = 1.0d;
        }
        int[] iArr = {Math.max((int) (((double) i) / d), Styles.dpToPx(context, 50.0f)), Math.max((int) (((double) i2) / d), Styles.dpToPx(context, 50.0f))};
        TLog.m138d(String.format("%s -> %s", i + "x" + i2, iArr[0] + "x" + iArr[1]));
        return iArr;
    }

    public static int[] computeSize(String str) {
        BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = true;
        BitmapFactory.decodeFile(str, options);
        return computeSize(options.outWidth, options.outHeight);
    }

    public static int getImageMaxWidth() {
        Context context = AIHelpContext.getInstance().getContext();
        return Math.min(context.getResources().getDisplayMetrics().widthPixels, context.getResources().getDisplayMetrics().heightPixels) - ((Styles.dpToPx(context, 40.0f) + Styles.dpToPx(context, 20.0f)) * 2);
    }

    public static Bitmap scaleBitmap(Bitmap bitmap, int i, int i2) {
        if (bitmap == null) {
            return null;
        }
        try {
            int width = bitmap.getWidth();
            int height = bitmap.getHeight();
            Matrix matrix = new Matrix();
            matrix.postScale(0.8f, 0.9f);
            return Bitmap.createBitmap(bitmap, 0, 0, width, height, matrix, false);
        } catch (Exception unused) {
            return bitmap;
        }
    }

    public static Bitmap scaleBitmap(Bitmap bitmap, float f) {
        if (bitmap == null) {
            return null;
        }
        int width = bitmap.getWidth();
        int height = bitmap.getHeight();
        Matrix matrix = new Matrix();
        matrix.preScale(f, f);
        Bitmap bitmapCreateBitmap = Bitmap.createBitmap(bitmap, 0, 0, width, height, matrix, false);
        bitmapCreateBitmap.equals(bitmap);
        return bitmapCreateBitmap;
    }

    public static Bitmap cropBitmap(Bitmap bitmap) {
        int width = bitmap.getWidth();
        int height = bitmap.getHeight();
        if (width < height) {
            height = width;
        }
        int i = height / 2;
        return Bitmap.createBitmap(bitmap, width / 3, 0, i, (int) (((double) i) / 1.2d), (Matrix) null, false);
    }

    public static Bitmap cropBitmap(Bitmap bitmap, int i, int i2, boolean z) {
        if (i <= 0 || i2 <= 0) {
            return bitmap;
        }
        int width = bitmap.getWidth();
        int height = bitmap.getHeight();
        int i3 = 0;
        int i4 = width > i ? (width - i) / 2 : 0;
        if (z && height > i2) {
            i3 = (height - i2) / 2;
        }
        int i5 = i3;
        return (i4 + i > width || i5 + i2 > height) ? bitmap : Bitmap.createBitmap(bitmap, i4, i5, i, i2, (Matrix) null, false);
    }

    public static Bitmap cropBitmapToFitTarget(Bitmap bitmap, View view) {
        return view == null ? bitmap : cropBitmap(bitmap, view.getWidth(), view.getHeight(), false);
    }

    public static Bitmap cropBitmapToFitDevice(Bitmap bitmap) {
        DisplayMetrics displayMetrics = AIHelpContext.getInstance().getContext().getResources().getDisplayMetrics();
        return cropBitmap(bitmap, displayMetrics.widthPixels, displayMetrics.heightPixels, false);
    }
}
