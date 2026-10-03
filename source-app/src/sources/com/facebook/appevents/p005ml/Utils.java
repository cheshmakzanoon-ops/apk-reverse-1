package com.facebook.appevents.p005ml;

import android.text.TextUtils;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.FacebookSdk;
import com.facebook.internal.instrument.crashshield.CrashShieldHandler;
import com.facebook.share.internal.ShareInternalUtility;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.Map;
import kotlin.Metadata;
import kotlin.collections.ArraysKt;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.Charsets;
import kotlin.text.Regex;
import org.json.JSONArray;
import org.json.JSONObject;

@Metadata(d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010$\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0015\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\bÇ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\n\u0010\u0005\u001a\u0004\u0018\u00010\u0006H\u0007J\u000e\u0010\u0007\u001a\u00020\u00042\u0006\u0010\b\u001a\u00020\u0004J\u001e\u0010\t\u001a\u0010\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u000b\u0018\u00010\n2\u0006\u0010\f\u001a\u00020\u0006H\u0007J\u0016\u0010\r\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u00042\u0006\u0010\u0010\u001a\u00020\u0011R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0012"}, d2 = {"Lcom/facebook/appevents/ml/Utils;", "", "()V", "DIR_NAME", "", "getMlDir", "Ljava/io/File;", "normalizeString", "str", "parseModelWeights", "", "Lcom/facebook/appevents/ml/MTensor;", ShareInternalUtility.STAGING_PARAM, "vectorize", "", "texts", "maxLen", "", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class Utils {
    private static final String DIR_NAME = "facebook_ml/";
    public static final Utils INSTANCE = new Utils();

    private Utils() {
    }

    public final int[] vectorize(String texts, int maxLen) {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return null;
        }
        try {
            Intrinsics.checkNotNullParameter(texts, "texts");
            int[] iArr = new int[maxLen];
            String strNormalizeString = normalizeString(texts);
            Charset charsetForName = Charset.forName("UTF-8");
            Intrinsics.checkNotNullExpressionValue(charsetForName, "forName(\"UTF-8\")");
            if (strNormalizeString == null) {
                throw new NullPointerException("null cannot be cast to non-null type java.lang.String");
            }
            byte[] bytes = strNormalizeString.getBytes(charsetForName);
            Intrinsics.checkNotNullExpressionValue(bytes, "(this as java.lang.String).getBytes(charset)");
            if (maxLen > 0) {
                int i = 0;
                while (true) {
                    int i2 = i + 1;
                    if (i < bytes.length) {
                        iArr[i] = bytes[i] & 255;
                    } else {
                        iArr[i] = 0;
                    }
                    if (i2 >= maxLen) {
                        break;
                    }
                    i = i2;
                }
            }
            return iArr;
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
            return null;
        }
    }

    @JvmStatic
    public static final File getMlDir() {
        if (CrashShieldHandler.isObjectCrashing(Utils.class)) {
            return null;
        }
        try {
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            File file = new File(FacebookSdk.getApplicationContext().getFilesDir(), DIR_NAME);
            if (file.exists() || file.mkdirs()) {
                return file;
            }
            return null;
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, Utils.class);
            return null;
        }
    }

    @JvmStatic
    public static final Map<String, MTensor> parseModelWeights(File file) {
        Map<String, MTensor> map;
        Map<String, MTensor> map2 = null;
        if (CrashShieldHandler.isObjectCrashing(Utils.class)) {
            return null;
        }
        try {
            Intrinsics.checkNotNullParameter(file, ShareInternalUtility.STAGING_PARAM);
            try {
                try {
                    FileInputStream fileInputStream = new FileInputStream(file);
                    int iAvailable = fileInputStream.available();
                    DataInputStream dataInputStream = new DataInputStream(fileInputStream);
                    byte[] bArr = new byte[iAvailable];
                    dataInputStream.readFully(bArr);
                    dataInputStream.close();
                    if (iAvailable < 4) {
                        return null;
                    }
                    int i = 0;
                    ByteBuffer byteBufferWrap = ByteBuffer.wrap(bArr, 0, 4);
                    byteBufferWrap.order(ByteOrder.LITTLE_ENDIAN);
                    int i2 = byteBufferWrap.getInt();
                    int i3 = i2 + 4;
                    if (iAvailable < i3) {
                        return null;
                    }
                    JSONObject jSONObject = new JSONObject(new String(bArr, 4, i2, Charsets.UTF_8));
                    JSONArray jSONArrayNames = jSONObject.names();
                    int length = jSONArrayNames.length();
                    String[] strArr = new String[length];
                    int i4 = length - 1;
                    if (i4 >= 0) {
                        int i5 = 0;
                        while (true) {
                            int i6 = i5 + 1;
                            strArr[i5] = jSONArrayNames.getString(i5);
                            if (i6 > i4) {
                                break;
                            }
                            i5 = i6;
                        }
                    }
                    ArraysKt.sort(strArr);
                    HashMap map3 = new HashMap();
                    int i7 = 0;
                    while (i7 < length) {
                        String str = strArr[i7];
                        i7++;
                        if (str != null) {
                            JSONArray jSONArray = jSONObject.getJSONArray(str);
                            int length2 = jSONArray.length();
                            int[] iArr = new int[length2];
                            int i8 = length2 - 1;
                            int i9 = 1;
                            if (i8 >= 0) {
                                while (true) {
                                    int i10 = i + 1;
                                    try {
                                        int i11 = jSONArray.getInt(i);
                                        iArr[i] = i11;
                                        i9 *= i11;
                                        if (i10 > i8) {
                                            break;
                                        }
                                        i = i10;
                                    } catch (Exception unused) {
                                        return null;
                                    }
                                }
                            }
                            int i12 = i9 * 4;
                            int i13 = i3 + i12;
                            if (i13 > iAvailable) {
                                return null;
                            }
                            ByteBuffer byteBufferWrap2 = ByteBuffer.wrap(bArr, i3, i12);
                            byteBufferWrap2.order(ByteOrder.LITTLE_ENDIAN);
                            MTensor mTensor = new MTensor(iArr);
                            byteBufferWrap2.asFloatBuffer().get(mTensor.getData(), 0, i9);
                            map3.put(str, mTensor);
                            i3 = i13;
                            i = 0;
                            map2 = null;
                        }
                    }
                    return map3;
                } catch (Exception unused2) {
                    return map2;
                }
            } catch (Throwable th) {
                th = th;
                map = null;
                CrashShieldHandler.handleThrowable(th, Utils.class);
                return map;
            }
        } catch (Throwable th2) {
            th = th2;
            map = null;
        }
    }

    public final String normalizeString(String str) {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return null;
        }
        try {
            Intrinsics.checkNotNullParameter(str, "str");
            String str2 = str;
            int length = str2.length() - 1;
            int i = 0;
            boolean z = false;
            while (i <= length) {
                boolean z2 = Intrinsics.compare(str2.charAt(!z ? i : length), 32) <= 0;
                if (z) {
                    if (!z2) {
                        break;
                    }
                    length--;
                } else if (z2) {
                    i++;
                } else {
                    z = true;
                }
            }
            Object[] array = new Regex("\\s+").split(str2.subSequence(i, length + 1).toString(), 0).toArray(new String[0]);
            if (array != null) {
                String strJoin = TextUtils.join(" ", (String[]) array);
                Intrinsics.checkNotNullExpressionValue(strJoin, "join(\" \", strArray)");
                return strJoin;
            }
            throw new NullPointerException("null cannot be cast to non-null type kotlin.Array<T>");
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
            return null;
        }
    }
}
