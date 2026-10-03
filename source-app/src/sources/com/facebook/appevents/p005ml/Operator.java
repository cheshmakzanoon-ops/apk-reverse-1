package com.facebook.appevents.p005ml;

import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.internal.instrument.crashshield.CrashShieldHandler;
import kotlin.Metadata;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\b\n\u0002\b\u000b\bÁ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0018\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\u0006H\u0007J\u001b\u0010\b\u001a\u00020\u00062\f\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u00060\nH\u0007¢\u0006\u0002\u0010\u000bJ\u0018\u0010\f\u001a\u00020\u00062\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\r\u001a\u00020\u0006H\u0007J \u0010\u000e\u001a\u00020\u00062\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\r\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\u0006H\u0007J+\u0010\u000f\u001a\u00020\u00062\f\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\u00110\n2\u0006\u0010\u0012\u001a\u00020\u00132\u0006\u0010\r\u001a\u00020\u0006H\u0007¢\u0006\u0002\u0010\u0014J\u0018\u0010\u0015\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0016\u001a\u00020\u0013H\u0007J\u0018\u0010\u0017\u001a\u00020\u00062\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0018\u001a\u00020\u0013H\u0007J\u0018\u0010\u0019\u001a\u00020\u00062\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\r\u001a\u00020\u0006H\u0007J\u0010\u0010\u001a\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0007J\u0010\u0010\u001b\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0007J\u0010\u0010\u001c\u001a\u00020\u00062\u0006\u0010\u0005\u001a\u00020\u0006H\u0007J\u0010\u0010\u001d\u001a\u00020\u00062\u0006\u0010\u0005\u001a\u00020\u0006H\u0007¨\u0006\u001e"}, d2 = {"Lcom/facebook/appevents/ml/Operator;", "", "()V", "addmv", "", "x", "Lcom/facebook/appevents/ml/MTensor;", "b", "concatenate", "tensors", "", "([Lcom/facebook/appevents/ml/MTensor;)Lcom/facebook/appevents/ml/MTensor;", "conv1D", "w", "dense", "embedding", "texts", "", "seqLength", "", "([Ljava/lang/String;ILcom/facebook/appevents/ml/MTensor;)Lcom/facebook/appevents/ml/MTensor;", "flatten", "startDim", "maxPool1D", "poolSize", "mul", "relu", "softmax", "transpose2D", "transpose3D", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class Operator {
    public static final Operator INSTANCE = new Operator();

    private Operator() {
    }

    @JvmStatic
    public static final void addmv(MTensor x, MTensor b) {
        if (CrashShieldHandler.isObjectCrashing(Operator.class)) {
            return;
        }
        try {
            Intrinsics.checkNotNullParameter(x, "x");
            Intrinsics.checkNotNullParameter(b, "b");
            int shape = x.getShape(0);
            int shape2 = x.getShape(1);
            int shape3 = x.getShape(2);
            float[] data = x.getData();
            float[] data2 = b.getData();
            if (shape <= 0) {
                return;
            }
            int i = 0;
            while (true) {
                int i2 = i + 1;
                if (shape2 > 0) {
                    int i3 = 0;
                    while (true) {
                        int i4 = i3 + 1;
                        if (shape3 > 0) {
                            int i5 = 0;
                            while (true) {
                                int i6 = i5 + 1;
                                int i7 = (i * shape2 * shape3) + (i3 * shape3) + i5;
                                data[i7] = data[i7] + data2[i5];
                                if (i6 >= shape3) {
                                    break;
                                } else {
                                    i5 = i6;
                                }
                            }
                        }
                        if (i4 >= shape2) {
                            break;
                        } else {
                            i3 = i4;
                        }
                    }
                }
                if (i2 >= shape) {
                    return;
                } else {
                    i = i2;
                }
            }
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, Operator.class);
        }
    }

    @JvmStatic
    public static final MTensor mul(MTensor x, MTensor w) {
        if (CrashShieldHandler.isObjectCrashing(Operator.class)) {
            return null;
        }
        try {
            Intrinsics.checkNotNullParameter(x, "x");
            Intrinsics.checkNotNullParameter(w, "w");
            int i = 0;
            int shape = x.getShape(0);
            int shape2 = w.getShape(0);
            int shape3 = w.getShape(1);
            MTensor mTensor = new MTensor(new int[]{shape, shape3});
            float[] data = x.getData();
            float[] data2 = w.getData();
            float[] data3 = mTensor.getData();
            if (shape > 0) {
                int i2 = 0;
                while (true) {
                    int i3 = i2 + 1;
                    if (shape3 > 0) {
                        int i4 = i;
                        while (true) {
                            int i5 = i4 + 1;
                            int i6 = (i2 * shape3) + i4;
                            data3[i6] = 0.0f;
                            if (shape2 > 0) {
                                int i7 = i;
                                while (true) {
                                    int i8 = i7 + 1;
                                    data3[i6] = data3[i6] + (data[(i2 * shape2) + i7] * data2[(i7 * shape3) + i4]);
                                    if (i8 >= shape2) {
                                        break;
                                    }
                                    i7 = i8;
                                }
                            }
                            if (i5 >= shape3) {
                                break;
                            }
                            i4 = i5;
                            i = 0;
                        }
                    }
                    if (i3 >= shape) {
                        break;
                    }
                    i2 = i3;
                    i = 0;
                }
            }
            return mTensor;
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, Operator.class);
            return null;
        }
    }

    @JvmStatic
    public static final void relu(MTensor x) {
        if (CrashShieldHandler.isObjectCrashing(Operator.class)) {
            return;
        }
        try {
            Intrinsics.checkNotNullParameter(x, "x");
            float[] data = x.getData();
            int length = data.length - 1;
            if (length < 0) {
                return;
            }
            int i = 0;
            while (true) {
                int i2 = i + 1;
                if (data[i] < 0.0f) {
                    data[i] = 0.0f;
                }
                if (i2 > length) {
                    return;
                } else {
                    i = i2;
                }
            }
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, Operator.class);
        }
    }

    @JvmStatic
    public static final void flatten(MTensor x, int startDim) {
        if (CrashShieldHandler.isObjectCrashing(Operator.class)) {
            return;
        }
        try {
            Intrinsics.checkNotNullParameter(x, "x");
            if (startDim >= x.getShapeSize()) {
                return;
            }
            int shapeSize = x.getShapeSize();
            int shape = 1;
            if (startDim < shapeSize) {
                int i = startDim;
                while (true) {
                    int i2 = i + 1;
                    shape *= x.getShape(i);
                    if (i2 >= shapeSize) {
                        break;
                    } else {
                        i = i2;
                    }
                }
            }
            int[] iArr = new int[startDim + 1];
            if (startDim > 0) {
                int i3 = 0;
                while (true) {
                    int i4 = i3 + 1;
                    iArr[i3] = x.getShape(i3);
                    if (i4 >= startDim) {
                        break;
                    } else {
                        i3 = i4;
                    }
                }
            }
            iArr[startDim] = shape;
            x.reshape(iArr);
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, Operator.class);
        }
    }

    @JvmStatic
    public static final MTensor concatenate(MTensor[] tensors) {
        int shape;
        if (CrashShieldHandler.isObjectCrashing(Operator.class)) {
            return null;
        }
        try {
            Intrinsics.checkNotNullParameter(tensors, "tensors");
            int i = 0;
            int shape2 = tensors[0].getShape(0);
            int length = tensors.length - 1;
            if (length >= 0) {
                int i2 = 0;
                shape = 0;
                while (true) {
                    int i3 = i2 + 1;
                    shape += tensors[i2].getShape(1);
                    if (i3 > length) {
                        break;
                    }
                    i2 = i3;
                }
            } else {
                shape = 0;
            }
            MTensor mTensor = new MTensor(new int[]{shape2, shape});
            float[] data = mTensor.getData();
            if (shape2 > 0) {
                int i4 = 0;
                while (true) {
                    int i5 = i4 + 1;
                    int i6 = i4 * shape;
                    int length2 = tensors.length - 1;
                    if (length2 >= 0) {
                        int i7 = i;
                        while (true) {
                            int i8 = i7 + 1;
                            float[] data2 = tensors[i7].getData();
                            int shape3 = tensors[i7].getShape(1);
                            System.arraycopy(data2, i4 * shape3, data, i6, shape3);
                            i6 += shape3;
                            if (i8 > length2) {
                                break;
                            }
                            i7 = i8;
                        }
                    }
                    if (i5 >= shape2) {
                        break;
                    }
                    i4 = i5;
                    i = 0;
                }
            }
            return mTensor;
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, Operator.class);
            return null;
        }
    }

    @JvmStatic
    public static final void softmax(MTensor x) {
        if (CrashShieldHandler.isObjectCrashing(Operator.class)) {
            return;
        }
        try {
            Intrinsics.checkNotNullParameter(x, "x");
            int i = 0;
            int shape = x.getShape(0);
            int shape2 = x.getShape(1);
            float[] data = x.getData();
            if (shape <= 0) {
                return;
            }
            while (true) {
                int i2 = i + 1;
                int i3 = i * shape2;
                int i4 = i3 + shape2;
                float f = Float.MIN_VALUE;
                if (i3 < i4) {
                    int i5 = i3;
                    while (true) {
                        int i6 = i5 + 1;
                        float f2 = data[i5];
                        if (f2 > f) {
                            f = f2;
                        }
                        if (i6 >= i4) {
                            break;
                        } else {
                            i5 = i6;
                        }
                    }
                }
                float f3 = 0.0f;
                if (i3 < i4) {
                    int i7 = i3;
                    while (true) {
                        int i8 = i7 + 1;
                        float fExp = (float) Math.exp(data[i7] - f);
                        data[i7] = fExp;
                        f3 += fExp;
                        if (i8 >= i4) {
                            break;
                        } else {
                            i7 = i8;
                        }
                    }
                }
                if (i3 < i4) {
                    while (true) {
                        int i9 = i3 + 1;
                        data[i3] = data[i3] / f3;
                        if (i9 >= i4) {
                            break;
                        } else {
                            i3 = i9;
                        }
                    }
                }
                if (i2 >= shape) {
                    return;
                } else {
                    i = i2;
                }
            }
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, Operator.class);
        }
    }

    @JvmStatic
    public static final MTensor dense(MTensor x, MTensor w, MTensor b) {
        if (CrashShieldHandler.isObjectCrashing(Operator.class)) {
            return null;
        }
        try {
            Intrinsics.checkNotNullParameter(x, "x");
            Intrinsics.checkNotNullParameter(w, "w");
            Intrinsics.checkNotNullParameter(b, "b");
            int shape = x.getShape(0);
            int shape2 = b.getShape(0);
            MTensor mTensorMul = mul(x, w);
            float[] data = b.getData();
            float[] data2 = mTensorMul.getData();
            if (shape > 0) {
                int i = 0;
                while (true) {
                    int i2 = i + 1;
                    if (shape2 > 0) {
                        int i3 = 0;
                        while (true) {
                            int i4 = i3 + 1;
                            int i5 = (i * shape2) + i3;
                            data2[i5] = data2[i5] + data[i3];
                            if (i4 >= shape2) {
                                break;
                            }
                            i3 = i4;
                        }
                    }
                    if (i2 >= shape) {
                        break;
                    }
                    i = i2;
                }
            }
            return mTensorMul;
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, Operator.class);
            return null;
        }
    }

    @JvmStatic
    public static final MTensor embedding(String[] texts, int seqLength, MTensor w) {
        if (CrashShieldHandler.isObjectCrashing(Operator.class)) {
            return null;
        }
        try {
            Intrinsics.checkNotNullParameter(texts, "texts");
            Intrinsics.checkNotNullParameter(w, "w");
            int length = texts.length;
            int shape = w.getShape(1);
            MTensor mTensor = new MTensor(new int[]{length, seqLength, shape});
            float[] data = mTensor.getData();
            float[] data2 = w.getData();
            if (length > 0) {
                int i = 0;
                while (true) {
                    int i2 = i + 1;
                    int[] iArrVectorize = Utils.INSTANCE.vectorize(texts[i], seqLength);
                    if (seqLength > 0) {
                        int i3 = 0;
                        while (true) {
                            int i4 = i3 + 1;
                            System.arraycopy(data2, iArrVectorize[i3] * shape, data, (shape * seqLength * i) + (i3 * shape), shape);
                            if (i4 >= seqLength) {
                                break;
                            }
                            i3 = i4;
                        }
                    }
                    if (i2 >= length) {
                        break;
                    }
                    i = i2;
                }
            }
            return mTensor;
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, Operator.class);
            return null;
        }
    }

    @JvmStatic
    public static final MTensor transpose2D(MTensor x) {
        if (CrashShieldHandler.isObjectCrashing(Operator.class)) {
            return null;
        }
        try {
            Intrinsics.checkNotNullParameter(x, "x");
            int shape = x.getShape(0);
            int shape2 = x.getShape(1);
            MTensor mTensor = new MTensor(new int[]{shape2, shape});
            float[] data = x.getData();
            float[] data2 = mTensor.getData();
            if (shape > 0) {
                int i = 0;
                while (true) {
                    int i2 = i + 1;
                    if (shape2 > 0) {
                        int i3 = 0;
                        while (true) {
                            int i4 = i3 + 1;
                            data2[(i3 * shape) + i] = data[(i * shape2) + i3];
                            if (i4 >= shape2) {
                                break;
                            }
                            i3 = i4;
                        }
                    }
                    if (i2 >= shape) {
                        break;
                    }
                    i = i2;
                }
            }
            return mTensor;
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, Operator.class);
            return null;
        }
    }

    @JvmStatic
    public static final MTensor transpose3D(MTensor x) {
        if (CrashShieldHandler.isObjectCrashing(Operator.class)) {
            return null;
        }
        try {
            Intrinsics.checkNotNullParameter(x, "x");
            int shape = x.getShape(0);
            int shape2 = x.getShape(1);
            int shape3 = x.getShape(2);
            MTensor mTensor = new MTensor(new int[]{shape3, shape2, shape});
            float[] data = x.getData();
            float[] data2 = mTensor.getData();
            if (shape > 0) {
                int i = 0;
                while (true) {
                    int i2 = i + 1;
                    if (shape2 > 0) {
                        int i3 = 0;
                        while (true) {
                            int i4 = i3 + 1;
                            if (shape3 > 0) {
                                int i5 = 0;
                                while (true) {
                                    int i6 = i5 + 1;
                                    data2[(i5 * shape * shape2) + (i3 * shape) + i] = data[(i * shape2 * shape3) + (i3 * shape3) + i5];
                                    if (i6 >= shape3) {
                                        break;
                                    }
                                    i5 = i6;
                                }
                            }
                            if (i4 >= shape2) {
                                break;
                            }
                            i3 = i4;
                        }
                    }
                    if (i2 >= shape) {
                        break;
                    }
                    i = i2;
                }
            }
            return mTensor;
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, Operator.class);
            return null;
        }
    }

    @JvmStatic
    public static final MTensor conv1D(MTensor x, MTensor w) {
        Class<Operator> cls;
        MTensor mTensor;
        Class<Operator> cls2 = Operator.class;
        if (CrashShieldHandler.isObjectCrashing(cls2)) {
            return null;
        }
        try {
            Intrinsics.checkNotNullParameter(x, "x");
            Intrinsics.checkNotNullParameter(w, "w");
            int i = 0;
            int shape = x.getShape(0);
            int shape2 = x.getShape(1);
            int shape3 = x.getShape(2);
            int shape4 = w.getShape(0);
            int i2 = (shape2 - shape4) + 1;
            int shape5 = w.getShape(2);
            MTensor mTensor2 = new MTensor(new int[]{shape, i2, shape5});
            float[] data = x.getData();
            float[] data2 = mTensor2.getData();
            float[] data3 = w.getData();
            if (shape <= 0) {
                return mTensor2;
            }
            int i3 = 0;
            while (true) {
                int i4 = i3 + 1;
                if (shape5 > 0) {
                    int i5 = i;
                    while (true) {
                        int i6 = i5 + 1;
                        if (i2 > 0) {
                            int i7 = 0;
                            while (true) {
                                int i8 = i7 + 1;
                                float f = 0.0f;
                                if (shape4 > 0) {
                                    int i9 = 0;
                                    while (true) {
                                        cls = cls2;
                                        int i10 = i9 + 1;
                                        if (shape3 > 0) {
                                            int i11 = 0;
                                            while (true) {
                                                mTensor = mTensor2;
                                                int i12 = i11 + 1;
                                                try {
                                                    f += data[(shape2 * shape3 * i3) + ((i9 + i7) * shape3) + i11] * data3[(((i9 * shape3) + i11) * shape5) + i5];
                                                    if (i12 >= shape3) {
                                                        break;
                                                    }
                                                    i11 = i12;
                                                    mTensor2 = mTensor;
                                                } catch (Throwable th) {
                                                    th = th;
                                                    CrashShieldHandler.handleThrowable(th, cls);
                                                    return null;
                                                }
                                            }
                                        } else {
                                            mTensor = mTensor2;
                                        }
                                        if (i10 >= shape4) {
                                            break;
                                        }
                                        i9 = i10;
                                        cls2 = cls;
                                        mTensor2 = mTensor;
                                    }
                                } else {
                                    cls = cls2;
                                    mTensor = mTensor2;
                                }
                                data2[(i2 * shape5 * i3) + (i7 * shape5) + i5] = f;
                                if (i8 >= i2) {
                                    break;
                                }
                                i7 = i8;
                                cls2 = cls;
                                mTensor2 = mTensor;
                            }
                        } else {
                            cls = cls2;
                            mTensor = mTensor2;
                        }
                        if (i6 >= shape5) {
                            break;
                        }
                        i5 = i6;
                        cls2 = cls;
                        mTensor2 = mTensor;
                    }
                } else {
                    cls = cls2;
                    mTensor = mTensor2;
                }
                if (i4 >= shape) {
                    return mTensor;
                }
                i3 = i4;
                cls2 = cls;
                mTensor2 = mTensor;
                i = 0;
            }
        } catch (Throwable th2) {
            th = th2;
            cls = cls2;
        }
    }

    @JvmStatic
    public static final MTensor maxPool1D(MTensor x, int poolSize) {
        int i;
        if (CrashShieldHandler.isObjectCrashing(Operator.class)) {
            return null;
        }
        try {
            Intrinsics.checkNotNullParameter(x, "x");
            int i2 = 0;
            int shape = x.getShape(0);
            int shape2 = x.getShape(1);
            int shape3 = x.getShape(2);
            int i3 = (shape2 - poolSize) + 1;
            MTensor mTensor = new MTensor(new int[]{shape, i3, shape3});
            float[] data = x.getData();
            float[] data2 = mTensor.getData();
            if (shape > 0) {
                int i4 = 0;
                while (true) {
                    int i5 = i4 + 1;
                    if (shape3 > 0) {
                        int i6 = i2;
                        while (true) {
                            int i7 = i6 + 1;
                            if (i3 > 0) {
                                int i8 = i2;
                                while (true) {
                                    int i9 = i8 + 1;
                                    int i10 = i8 * shape3;
                                    int i11 = (i4 * i3 * shape3) + i10 + i6;
                                    int i12 = (i4 * shape2 * shape3) + i10 + i6;
                                    data2[i11] = Float.MIN_VALUE;
                                    if (poolSize > 0) {
                                        int i13 = 0;
                                        while (true) {
                                            int i14 = i13 + 1;
                                            i = shape2;
                                            data2[i11] = Math.max(data2[i11], data[i12 + (i13 * shape3)]);
                                            if (i14 >= poolSize) {
                                                break;
                                            }
                                            i13 = i14;
                                            shape2 = i;
                                        }
                                    } else {
                                        i = shape2;
                                    }
                                    if (i9 >= i3) {
                                        break;
                                    }
                                    i8 = i9;
                                    shape2 = i;
                                }
                            } else {
                                i = shape2;
                            }
                            if (i7 >= shape3) {
                                break;
                            }
                            i6 = i7;
                            shape2 = i;
                            i2 = 0;
                        }
                    } else {
                        i = shape2;
                    }
                    if (i5 >= shape) {
                        break;
                    }
                    i4 = i5;
                    shape2 = i;
                    i2 = 0;
                }
            }
            return mTensor;
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, Operator.class);
            return null;
        }
    }
}
