package com.google.zxing.multi;

import com.google.zxing.BinaryBitmap;
import com.google.zxing.DecodeHintType;
import com.google.zxing.NotFoundException;
import com.google.zxing.Reader;
import com.google.zxing.ReaderException;
import com.google.zxing.Result;
import com.google.zxing.ResultPoint;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public final class GenericMultipleBarcodeReader implements MultipleBarcodeReader {
    private static final int MAX_DEPTH = 4;
    private static final int MIN_DIMENSION_TO_RECUR = 100;
    private final Reader delegate;

    public GenericMultipleBarcodeReader(Reader reader) {
        this.delegate = reader;
    }

    @Override
    public Result[] decodeMultiple(BinaryBitmap binaryBitmap) throws NotFoundException {
        return decodeMultiple(binaryBitmap, null);
    }

    @Override
    public Result[] decodeMultiple(BinaryBitmap binaryBitmap, Map<DecodeHintType, ?> map) throws NotFoundException {
        ArrayList arrayList = new ArrayList();
        doDecodeMultiple(binaryBitmap, map, arrayList, 0, 0, 0);
        if (arrayList.isEmpty()) {
            throw NotFoundException.getNotFoundInstance();
        }
        return (Result[]) arrayList.toArray(new Result[arrayList.size()]);
    }

    private void doDecodeMultiple(BinaryBitmap binaryBitmap, Map<DecodeHintType, ?> map, List<Result> list, int i, int i2, int i3) {
        float f;
        int i4;
        if (i3 > 4) {
            return;
        }
        try {
            Result resultDecode = this.delegate.decode(binaryBitmap, map);
            Iterator<Result> it = list.iterator();
            do {
                if (!it.hasNext()) {
                    list.add(translateResultPoints(resultDecode, i, i2));
                    break;
                }
            } while (!it.next().getText().equals(resultDecode.getText()));
            ResultPoint[] resultPoints = resultDecode.getResultPoints();
            if (resultPoints == null || resultPoints.length == 0) {
                return;
            }
            int width = binaryBitmap.getWidth();
            int height = binaryBitmap.getHeight();
            float f2 = width;
            float f3 = 0.0f;
            float f4 = height;
            float f5 = 0.0f;
            for (ResultPoint resultPoint : resultPoints) {
                if (resultPoint != null) {
                    float x = resultPoint.getX();
                    float y = resultPoint.getY();
                    if (x < f2) {
                        f2 = x;
                    }
                    if (y < f4) {
                        f4 = y;
                    }
                    if (x > f3) {
                        f3 = x;
                    }
                    if (y > f5) {
                        f5 = y;
                    }
                }
            }
            if (f2 > 100.0f) {
                f = f5;
                i4 = 0;
                doDecodeMultiple(binaryBitmap.crop(0, 0, (int) f2, height), map, list, i, i2, i3 + 1);
            } else {
                f = f5;
                i4 = 0;
            }
            if (f4 > 100.0f) {
                doDecodeMultiple(binaryBitmap.crop(i4, i4, width, (int) f4), map, list, i, i2, i3 + 1);
            }
            if (f3 < width - 100) {
                int i5 = (int) f3;
                doDecodeMultiple(binaryBitmap.crop(i5, i4, width - i5, height), map, list, i + i5, i2, i3 + 1);
            }
            if (f < height - 100) {
                int i6 = (int) f;
                doDecodeMultiple(binaryBitmap.crop(i4, i6, width, height - i6), map, list, i, i2 + i6, i3 + 1);
            }
        } catch (ReaderException unused) {
        }
    }

    private static Result translateResultPoints(Result result, int i, int i2) {
        ResultPoint[] resultPoints = result.getResultPoints();
        if (resultPoints == null) {
            return result;
        }
        ResultPoint[] resultPointArr = new ResultPoint[resultPoints.length];
        for (int i3 = 0; i3 < resultPoints.length; i3++) {
            ResultPoint resultPoint = resultPoints[i3];
            if (resultPoint != null) {
                resultPointArr[i3] = new ResultPoint(resultPoint.getX() + i, resultPoint.getY() + i2);
            }
        }
        Result result2 = new Result(result.getText(), result.getRawBytes(), result.getNumBits(), resultPointArr, result.getBarcodeFormat(), result.getTimestamp());
        result2.putAllMetadata(result.getResultMetadata());
        return result2;
    }
}
