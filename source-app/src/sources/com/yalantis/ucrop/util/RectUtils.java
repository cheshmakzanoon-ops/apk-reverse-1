package com.yalantis.ucrop.util;

import android.graphics.RectF;

public class RectUtils {
    public static float[] getCornersFromRect(RectF rectF) {
        return new float[]{rectF.left, rectF.top, rectF.right, rectF.top, rectF.right, rectF.bottom, rectF.left, rectF.bottom};
    }

    public static float[] getRectSidesFromCorners(float[] fArr) {
        return new float[]{(float) Math.sqrt(Math.pow(fArr[0] - fArr[2], 2.0d) + Math.pow(fArr[1] - fArr[3], 2.0d)), (float) Math.sqrt(Math.pow(fArr[2] - fArr[4], 2.0d) + Math.pow(fArr[3] - fArr[5], 2.0d))};
    }

    public static float[] getCenterFromRect(RectF rectF) {
        return new float[]{rectF.centerX(), rectF.centerY()};
    }

    public static RectF trapToRect(float[] fArr) {
        RectF rectF = new RectF(Float.POSITIVE_INFINITY, Float.POSITIVE_INFINITY, Float.NEGATIVE_INFINITY, Float.NEGATIVE_INFINITY);
        for (int i = 1; i < fArr.length; i += 2) {
            float fRound = Math.round(fArr[i - 1] * 10.0f) / 10.0f;
            float fRound2 = Math.round(fArr[i] * 10.0f) / 10.0f;
            rectF.left = fRound < rectF.left ? fRound : rectF.left;
            rectF.top = fRound2 < rectF.top ? fRound2 : rectF.top;
            if (fRound <= rectF.right) {
                fRound = rectF.right;
            }
            rectF.right = fRound;
            if (fRound2 <= rectF.bottom) {
                fRound2 = rectF.bottom;
            }
            rectF.bottom = fRound2;
        }
        rectF.sort();
        return rectF;
    }
}
