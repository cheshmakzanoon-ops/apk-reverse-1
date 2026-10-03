package com.appsflyer.internal;

import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.graphics.PointF;
import android.graphics.drawable.Drawable;
import android.hardware.SensorManager;
import android.media.AudioTrack;
import android.os.Build;
import android.os.Process;
import android.os.SystemClock;
import android.text.AndroidCharacter;
import android.text.TextUtils;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewConfiguration;
import android.widget.ExpandableListView;
import com.appsflyer.AFLogger;
import com.facebook.appevents.AppEventsConstants;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

public final class AFd1qSDK extends HashMap<String, Object> {
    private static int $10 = 0;
    private static int $11 = 1;
    private static char AFInAppEventType = 0;
    private static char AFKeystoreWrapper = 0;
    private static int AFLogger = 0;

    private static byte[] f326d = null;

    private static int f327e = 0;
    private static int force = 0;
    private static char registerClient = 0;
    private static int unregisterClient = 0;

    private static short[] f328v = null;
    private static char valueOf = 0;

    private static int f329w = 1;
    private final Map<String, Object> AFInAppEventParameterName;
    private final Context values;

    static {
        AFInAppEventType();
        ViewConfiguration.getScrollDefaultDelay();
        Gravity.getAbsoluteGravity(0, 0);
        Color.red(0);
        ViewConfiguration.getFadingEdgeLength();
        TextUtils.indexOf("", "", 0, 0);
        TypedValue.complexToFraction(0, 0.0f, 0.0f);
        TextUtils.indexOf("", "", 0);
        View.resolveSize(0, 0);
        TextUtils.indexOf("", "", 0, 0);
        ExpandableListView.getPackedPositionType(0L);
        Color.red(0);
        TextUtils.indexOf((CharSequence) "", '0', 0, 0);
        Color.blue(0);
        TextUtils.indexOf("", "", 0);
        TextUtils.indexOf("", "");
        TextUtils.getOffsetAfter("", 0);
        View.resolveSize(0, 0);
        TextUtils.indexOf("", "", 0);
        TextUtils.indexOf((CharSequence) "", '0');
        int i = force + 17;
        f329w = i % 128;
        int i2 = i % 2;
    }

    static void AFInAppEventType() {
        AFKeystoreWrapper = (char) 24264;
        registerClient = (char) 63721;
        AFInAppEventType = (char) 5476;
        valueOf = (char) 64623;
        f327e = -1309634689;
        AFLogger = 1099409257;
        unregisterClient = -804683925;
        f326d = new byte[]{-56, -79, -7, 0, -5, 84, -92, 25, -13, 64, -77, 10, -13, 64, -78, -14, 6, -10, 24, -4, 30, -12, 2, 15, 68, -79, 12, -14, 8, 5, -16, 71, -92, 25, 19, 18, -47, -21, 28, 15, 68, -105, 113, -68, -73, -90, -71, -80, -69, -112, -56, -10, 101, -87, -80, -85, 4, 84, -55, -93, -16, 99, -70, -93, -16, 98, -94, -74, -90, -56, -84, -50, -92, -78, -65, -12, 97, -68, -94, -72, -75, -96, -85, -85, -85, 118, -88, -111, 29, 59, 49, -16, 41, 25, 21, 56, 57, -12, 45, 45, 37, 43, 34, 43, 34, 35, 44, -7, 30, 28, -4, 83, -49, 6, 15, 92, -50, 14, 2, -14, 20, -8, 26, -16, 30, 11, 64, -51, 8, 14, 4, 1, 12, 67, -52, -7, 30, 28, 28, 37, -19, -25, 24, 11, 53, 59, 60, 14, 103, 34, 7, 102, 62, 61, 55, -15, 54, 62, 57, 59, 61, 84, 106, 102, 116, 88, 122, 82, 100, 97, 86, -7, -73, -85, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14};
    }

    public AFd1qSDK(Map<String, Object> map, Context context) {
        this.AFInAppEventParameterName = map;
        this.values = context;
        put(valueOf(), AFInAppEventParameterName());
    }

    private static StringBuilder AFKeystoreWrapper(String... strArr) throws Exception {
        int i;
        int i2 = 2 % 2;
        ArrayList arrayList = new ArrayList();
        int length = strArr.length;
        for (int i3 = 0; i3 < 3; i3++) {
            arrayList.add(Integer.valueOf(strArr[i3].length()));
        }
        Collections.sort(arrayList);
        int iIntValue = ((Integer) arrayList.get(0)).intValue();
        StringBuilder sb = new StringBuilder();
        int i4 = 0;
        while (i4 < iIntValue) {
            int length2 = strArr.length;
            Integer numValueOf = null;
            for (int i5 = 0; i5 < 3; i5++) {
                int i6 = f329w + 107;
                force = i6 % 128;
                int i7 = i6 % 2;
                int iCharAt = strArr[i5].charAt(i4);
                if (numValueOf == null) {
                    i = f329w + 13;
                    force = i % 128;
                } else {
                    iCharAt ^= numValueOf.intValue();
                    i = force + 57;
                    f329w = i % 128;
                }
                int i8 = i % 2;
                numValueOf = Integer.valueOf(iCharAt);
            }
            sb.append(Integer.toHexString(numValueOf.intValue()));
            i4++;
            int i9 = f329w + 55;
            force = i9 % 128;
            if (i9 % 2 != 0) {
                int i10 = 4 % 4;
            }
        }
        return sb;
    }

    private String valueOf() {
        int i = 2 % 2;
        int i2 = force + 89;
        f329w = i2 % 128;
        int i3 = i2 % 2;
        try {
            String string = Integer.toString(Build.VERSION.SDK_INT);
            Map<String, Object> map = this.AFInAppEventParameterName;
            Object[] objArr = new Object[1];
            m788a("뷍獃㟧껳皵蘨㐬疒刊\ue36fҸ\uf739", (ViewConfiguration.getScrollFriction() > 0.0f ? 1 : (ViewConfiguration.getScrollFriction() == 0.0f ? 0 : -1)) + 11, objArr);
            String string2 = map.get(((String) objArr[0]).intern()).toString();
            Map<String, Object> map2 = this.AFInAppEventParameterName;
            Object[] objArr2 = new Object[1];
            m788a("踄\ue9ed嵨뼦瘺\uf25e", 4 - TextUtils.lastIndexOf("", '0', 0), objArr2);
            String string3 = map2.get(((String) objArr2[0]).intern()).toString();
            if (string3 == null) {
                Object[] objArr3 = new Object[1];
                m788a("庍Ͱ븅鼂稰\ueec8\ue3ac샡", 8 - ExpandableListView.getPackedPositionType(0L), objArr3);
                string3 = ((String) objArr3[0]).intern();
            }
            StringBuilder sb = new StringBuilder(string2);
            sb.reverse();
            StringBuilder sbAFKeystoreWrapper = AFKeystoreWrapper(string, string3, sb.toString());
            int length = sbAFKeystoreWrapper.length();
            if (length > 4) {
                int i4 = force + 5;
                f329w = i4 % 128;
                if (i4 % 2 == 0) {
                    sbAFKeystoreWrapper.delete(2, length);
                } else {
                    sbAFKeystoreWrapper.delete(4, length);
                }
            } else {
                while (length < 4) {
                    length++;
                    sbAFKeystoreWrapper.append('1');
                    int i5 = f329w + 25;
                    force = i5 % 128;
                    int i6 = i5 % 2;
                }
            }
            Object[] objArr4 = new Object[1];
            m789b((short) (TextUtils.getOffsetAfter("", 0) + 59), (byte) View.MeasureSpec.getSize(0), 1852909574 - (ViewConfiguration.getTouchSlop() >> 8), (-100) - (PointF.length(0.0f, 0.0f) > 0.0f ? 1 : (PointF.length(0.0f, 0.0f) == 0.0f ? 0 : -1)), 260626319 - (ViewConfiguration.getFadingEdgeLength() >> 16), objArr4);
            sbAFKeystoreWrapper.insert(0, ((String) objArr4[0]).intern());
            return sbAFKeystoreWrapper.toString();
        } catch (Exception e) {
            Object[] objArr5 = new Object[1];
            m789b((short) ((-2) - (SystemClock.elapsedRealtime() > 0L ? 1 : (SystemClock.elapsedRealtime() == 0L ? 0 : -1))), (byte) (ViewConfiguration.getPressedStateDuration() >> 16), 1852909499 + (ViewConfiguration.getScrollBarFadeDuration() >> 16), TextUtils.indexOf((CharSequence) "", '0') - 62, 260626321 - (TypedValue.complexToFloat(0) > 0.0f ? 1 : (TypedValue.complexToFloat(0) == 0.0f ? 0 : -1)), objArr5);
            AFLogger.afErrorLogForExcManagerOnly(((String) objArr5[0]).intern(), e);
            StringBuilder sb2 = new StringBuilder();
            Object[] objArr6 = new Object[1];
            m789b((short) (ExpandableListView.getPackedPositionChild(0L) + 78), (byte) (ViewConfiguration.getTouchSlop() >> 8), 1852909568 + (Process.getElapsedCpuTime() > 0L ? 1 : (Process.getElapsedCpuTime() == 0L ? 0 : -1)), (-61) - TextUtils.getTrimmedLength(""), 260626360 - TextUtils.indexOf("", "", 0), objArr6);
            sb2.append(((String) objArr6[0]).intern());
            sb2.append(e);
            AFLogger.afRDLog(sb2.toString());
            Object[] objArr7 = new Object[1];
            m789b((short) (TextUtils.indexOf((CharSequence) "", '0', 0) + 92), (byte) KeyEvent.normalizeMetaState(0), (SystemClock.elapsedRealtime() > 0L ? 1 : (SystemClock.elapsedRealtime() == 0L ? 0 : -1)) + 1852909573, (-97) - TextUtils.lastIndexOf("", '0', 0), (ViewConfiguration.getEdgeSlop() >> 16) + 260626401, objArr7);
            return ((String) objArr7[0]).intern();
        }
    }

    private String AFInAppEventParameterName() {
        String string;
        int i;
        int i2 = 2 % 2;
        try {
            Map<String, Object> map = this.AFInAppEventParameterName;
            Object[] objArr = new Object[1];
            m788a("뷍獃㟧껳皵蘨㐬疒刊\ue36fҸ\uf739", 12 - View.getDefaultSize(0, 0), objArr);
            String string2 = map.get(((String) objArr[0]).intern()).toString();
            Map<String, Object> map2 = this.AFInAppEventParameterName;
            Object[] objArr2 = new Object[1];
            m789b((short) (Color.argb(0, 0, 0, 0) - 34), (byte) View.MeasureSpec.makeMeasureSpec(0, 0), 1852909569 - Color.red(0), (-87) - (SystemClock.currentThreadTimeMillis() > (-1L) ? 1 : (SystemClock.currentThreadTimeMillis() == (-1L) ? 0 : -1)), Gravity.getAbsoluteGravity(0, 0) + 260626407, objArr2);
            String string3 = map2.get(((String) objArr2[0]).intern()).toString();
            Object[] objArr3 = new Object[1];
            m789b((short) ((-43) - TextUtils.indexOf((CharSequence) "", '0', 0, 0)), (byte) (PointF.length(0.0f, 0.0f) > 0.0f ? 1 : (PointF.length(0.0f, 0.0f) == 0.0f ? 0 : -1)), View.resolveSizeAndState(0, 0, 0) + 1852909521, (ExpandableListView.getPackedPositionForChild(0, 0) > 0L ? 1 : (ExpandableListView.getPackedPositionForChild(0, 0) == 0L ? 0 : -1)) - 96, 260626421 - View.MeasureSpec.makeMeasureSpec(0, 0), objArr3);
            String strIntern = ((String) objArr3[0]).intern();
            Object[] objArr4 = new Object[1];
            m788a("툸班롚뷜찻憕", AndroidCharacter.getMirror('0') - '+', objArr4);
            String strReplaceAll = strIntern.replaceAll(((String) objArr4[0]).intern(), "");
            StringBuilder sb = new StringBuilder();
            sb.append(string2);
            sb.append(string3);
            sb.append(strReplaceAll);
            String strAFInAppEventType = AFb1mSDK.AFInAppEventType(sb.toString());
            StringBuilder sb2 = new StringBuilder("");
            sb2.append(strAFInAppEventType.substring(0, 16));
            string = sb2.toString();
        } catch (Exception e) {
            Object[] objArr5 = new Object[1];
            m789b((short) ((-7) - (ViewConfiguration.getKeyRepeatDelay() >> 16)), (byte) (PointF.length(0.0f, 0.0f) > 0.0f ? 1 : (PointF.length(0.0f, 0.0f) == 0.0f ? 0 : -1)), 1852909570 - (ViewConfiguration.getKeyRepeatDelay() >> 16), (-65) - View.getDefaultSize(0, 0), ((Process.getThreadPriority(0) + 20) >> 6) + 260626426, objArr5);
            AFLogger.afErrorLogForExcManagerOnly(((String) objArr5[0]).intern(), e);
            StringBuilder sb3 = new StringBuilder();
            Object[] objArr6 = new Object[1];
            m788a("ᅍ\udb2b\ue21f\u2d74Ⱀ㪼\uee37モ\ue460ᑱ㴸酎킂䓓棘ᐵ幉㓒梑鋺겗裘ॐ얋穏濛甘ꪘⴸ娯ퟺ믚㵗絻噬\uf367䮓빴슆鯋窩㝡孚ﵟ", TextUtils.indexOf("", "") + 44, objArr6);
            sb3.append(((String) objArr6[0]).intern());
            sb3.append(e);
            AFLogger.afRDLog(sb3.toString());
            StringBuilder sb4 = new StringBuilder("");
            Object[] objArr7 = new Object[1];
            m789b((short) ((-52) - (ViewConfiguration.getKeyRepeatDelay() >> 16)), (byte) (TextUtils.lastIndexOf("", '0') + 1), 1852909565 - (ViewConfiguration.getScrollBarSize() >> 8), (ViewConfiguration.getDoubleTapTimeout() >> 16) - 85, 260626462 - TextUtils.indexOf((CharSequence) "", '0', 0, 0), objArr7);
            sb4.append(((String) objArr7[0]).intern());
            string = sb4.toString();
        }
        String str = string;
        try {
            Context context = this.values;
            Object[] objArr8 = new Object[1];
            m788a("嵨뼦嚛䞔\u0d45梒㛖ఒ棘ᐵ\u1cce켻\u12c1콂尣\u0ff7䈧焥섍兪譵\uedc0偟찚嘽丢\ue950ᔢ\ue27f靚쓛塰蓐沨ꧏꛘ褏\uec5b", (ViewConfiguration.getTapTimeout() >> 16) + 37, objArr8);
            Intent intentRegisterReceiver = context.registerReceiver(null, new IntentFilter(((String) objArr8[0]).intern()));
            int intExtra = -2700;
            if (intentRegisterReceiver != null) {
                int i3 = force + 57;
                f329w = i3 % 128;
                int i4 = i3 % 2;
                Object[] objArr9 = new Object[1];
                m789b((short) ((-103) - (ViewConfiguration.getPressedStateDuration() >> 16)), (byte) Drawable.resolveOpacity(0, 0), (Process.myPid() >> 22) + 1852909583, (ExpandableListView.getPackedPositionForChild(0, 0) > 0L ? 1 : (ExpandableListView.getPackedPositionForChild(0, 0) == 0L ? 0 : -1)) - 91, 260626480 - (ViewConfiguration.getMaximumDrawingCacheSize() >> 24), objArr9);
                intExtra = intentRegisterReceiver.getIntExtra(((String) objArr9[0]).intern(), -2700);
            }
            String str2 = this.values.getApplicationInfo().nativeLibraryDir;
            if (str2 != null) {
                Object[] objArr10 = new Object[1];
                m789b((short) ((AudioTrack.getMinVolume() > 0.0f ? 1 : (AudioTrack.getMinVolume() == 0.0f ? 0 : -1)) + 7), (byte) ((-1) - TextUtils.indexOf((CharSequence) "", '0')), ((Process.getThreadPriority(0) + 20) >> 6) + 1852909587, (AudioTrack.getMinVolume() > 0.0f ? 1 : (AudioTrack.getMinVolume() == 0.0f ? 0 : -1)) - 100, (Process.myPid() >> 22) + 260626490, objArr10);
                if (!str2.contains(((String) objArr10[0]).intern())) {
                    i = 0;
                } else {
                    int i5 = force + 19;
                    f329w = i5 % 128;
                    int i6 = i5 % 2;
                    i = 1;
                }
            } else {
                i = 0;
            }
            Context context2 = this.values;
            Object[] objArr11 = new Object[1];
            m788a("⏺㷱ᖇ\u0b8c흀ẅ", (TypedValue.complexToFraction(0, 0.0f, 0.0f) > 0.0f ? 1 : (TypedValue.complexToFraction(0, 0.0f, 0.0f) == 0.0f ? 0 : -1)) + 6, objArr11);
            int size = ((SensorManager) context2.getSystemService(((String) objArr11[0]).intern())).getSensorList(-1).size();
            StringBuilder sb5 = new StringBuilder();
            Object[] objArr12 = new Object[1];
            m788a("䷈䦏", (ViewConfiguration.getTapTimeout() >> 16) + 1, objArr12);
            sb5.append(((String) objArr12[0]).intern());
            sb5.append(intExtra);
            Object[] objArr13 = new Object[1];
            m789b((short) (Gravity.getAbsoluteGravity(0, 0) - 83), (byte) (ExpandableListView.getPackedPositionChild(0L) + 1), 1852909505 - TextUtils.getOffsetBefore("", 0), (-101) - TextUtils.getCapsMode("", 0, 0), TextUtils.indexOf("", "") + 260626492, objArr13);
            sb5.append(((String) objArr13[0]).intern());
            sb5.append(i);
            Object[] objArr14 = new Object[1];
            m788a("ß㝖", 1 - (ExpandableListView.getPackedPositionForChild(0, 0) > 0L ? 1 : (ExpandableListView.getPackedPositionForChild(0, 0) == 0L ? 0 : -1)), objArr14);
            sb5.append(((String) objArr14[0]).intern());
            sb5.append(size);
            Object[] objArr15 = new Object[1];
            m788a("ᶹ㽵", 2 - View.MeasureSpec.getSize(0), objArr15);
            sb5.append(((String) objArr15[0]).intern());
            sb5.append(this.AFInAppEventParameterName.size());
            String string4 = sb5.toString();
            StringBuilder sb6 = new StringBuilder();
            sb6.append(str);
            byte[] bArrValues = AFa1ySDK.values(AFa1ySDK.AFKeystoreWrapper(string4));
            StringBuilder sb7 = new StringBuilder();
            for (byte b : bArrValues) {
                String hexString = Integer.toHexString(b);
                if (hexString.length() == 1) {
                    hexString = AppEventsConstants.EVENT_PARAM_VALUE_NO.concat(String.valueOf(hexString));
                }
                sb7.append(hexString);
            }
            sb6.append(sb7.toString());
            String string5 = sb6.toString();
            int i7 = force + 9;
            f329w = i7 % 128;
            int i8 = i7 % 2;
            return string5;
        } catch (Exception e2) {
            Object[] objArr16 = new Object[1];
            m788a("걠\ue0a1䖂\ueeac\ueff2Ѿ鯥\ueaf3\ue575鹋㵗絻꒶頙흀ẅ", KeyEvent.normalizeMetaState(0) + 16, objArr16);
            AFLogger.afErrorLogForExcManagerOnly(((String) objArr16[0]).intern(), e2);
            StringBuilder sb8 = new StringBuilder();
            Object[] objArr17 = new Object[1];
            m788a("ᅍ\udb2b\ue21f\u2d74Ⱀ㪼\uee37モ\ue460ᑱ㴸酎킂䓓棘ᐵ幉㓒梑鋺겗裘ॐ얋穏濛甘ꪘⴸ娯ퟺ믚㵗絻噬\uf367䮓빴슆鯋窩㝡孚ﵟ", 44 - (ViewConfiguration.getTouchSlop() >> 8), objArr17);
            sb8.append(((String) objArr17[0]).intern());
            sb8.append(e2);
            AFLogger.afRDLog(sb8.toString());
            StringBuilder sb9 = new StringBuilder();
            sb9.append(str);
            Object[] objArr18 = new Object[1];
            m788a("揄⇕䓏錨\uf8cf瓆㡡冔自馷(㺣頶⥓炯䍄", 16 - (ViewConfiguration.getScrollBarSize() >> 8), objArr18);
            sb9.append(((String) objArr18[0]).intern());
            return sb9.toString();
        }
    }

    public static class AFa1ySDK {
        static byte[] AFKeystoreWrapper(String str) throws Exception {
            return str.getBytes(Charset.defaultCharset());
        }

        static byte[] values(byte[] bArr) throws Exception {
            for (int i = 0; i < bArr.length; i++) {
                bArr[i] = (byte) (bArr[i] ^ ((i % 2) + 42));
            }
            return bArr;
        }
    }

    private static void m788a(String str, int i, Object[] objArr) {
        char[] charArray;
        int i2 = 2 % 2;
        if (str != null) {
            charArray = str.toCharArray();
            int i3 = $10 + 109;
            $11 = i3 % 128;
            int i4 = i3 % 2;
        } else {
            charArray = str;
        }
        char[] cArr = charArray;
        AFj1pSDK aFj1pSDK = new AFj1pSDK();
        char[] cArr2 = new char[cArr.length];
        aFj1pSDK.AFKeystoreWrapper = 0;
        char[] cArr3 = new char[2];
        int i5 = $10 + 65;
        $11 = i5 % 128;
        int i6 = i5 % 2;
        while (aFj1pSDK.AFKeystoreWrapper < cArr.length) {
            cArr3[0] = cArr[aFj1pSDK.AFKeystoreWrapper];
            cArr3[1] = cArr[aFj1pSDK.AFKeystoreWrapper + 1];
            int i7 = 58224;
            int i8 = 0;
            while (i8 < 16) {
                int i9 = $11;
                int i10 = i9 + 1;
                $10 = i10 % 128;
                int i11 = i10 % 2;
                char c = cArr3[1];
                char c2 = cArr3[0];
                char c3 = (char) (c - (((c2 + i7) ^ ((c2 << 4) + ((char) (((long) valueOf) ^ (-153834358171198606L))))) ^ ((c2 >>> 5) + ((char) (((long) registerClient) ^ (-153834358171198606L))))));
                cArr3[1] = c3;
                cArr3[0] = (char) (c2 - (((c3 >>> 5) + ((char) (((long) AFKeystoreWrapper) ^ (-153834358171198606L)))) ^ ((c3 + i7) ^ ((c3 << 4) + ((char) (((long) AFInAppEventType) ^ (-153834358171198606L)))))));
                i7 -= 40503;
                i8++;
                int i12 = i9 + 31;
                $10 = i12 % 128;
                int i13 = i12 % 2;
            }
            cArr2[aFj1pSDK.AFKeystoreWrapper] = cArr3[0];
            cArr2[aFj1pSDK.AFKeystoreWrapper + 1] = cArr3[1];
            aFj1pSDK.AFKeystoreWrapper += 2;
        }
        objArr[0] = new String(cArr2, 0, i);
    }

    private static void m789b(short s, byte b, int i, int i2, int i3, Object[] objArr) {
        int i4;
        int length;
        byte[] bArr;
        int i5;
        int i6 = 2 % 2;
        AFj1nSDK aFj1nSDK = new AFj1nSDK();
        StringBuilder sb = new StringBuilder();
        int i7 = i2 + ((int) (((long) AFLogger) ^ 7817788349036865294L));
        if (i7 == -1) {
            int i8 = $11 + 29;
            $10 = i8 % 128;
            int i9 = i8 % 2;
            i4 = 1;
        } else {
            i4 = 0;
        }
        if (i4 == 1) {
            byte[] bArr2 = f326d;
            if (bArr2 != null) {
                int i10 = $11 + 1;
                $10 = i10 % 128;
                if (i10 % 2 != 0) {
                    length = bArr2.length;
                    bArr = new byte[length];
                    i5 = 1;
                } else {
                    length = bArr2.length;
                    bArr = new byte[length];
                    i5 = 0;
                }
                while (i5 < length) {
                    bArr[i5] = (byte) (((long) bArr2[i5]) ^ 7817788349036865294L);
                    i5++;
                }
                bArr2 = bArr;
            }
            if (bArr2 != null) {
                i7 = (byte) (((byte) (((long) f326d[i3 + ((int) (((long) f327e) ^ 7817788349036865294L))]) ^ 7817788349036865294L)) + ((int) (((long) AFLogger) ^ 7817788349036865294L)));
            } else {
                i7 = (short) (((short) (((long) f328v[i3 + ((int) (((long) f327e) ^ 7817788349036865294L))]) ^ 7817788349036865294L)) + ((int) (((long) AFLogger) ^ 7817788349036865294L)));
                int i11 = $10 + 35;
                $11 = i11 % 128;
                int i12 = i11 % 2;
            }
        }
        if (i7 > 0) {
            int i13 = $11 + 125;
            $10 = i13 % 128;
            int i14 = i13 % 2;
            aFj1nSDK.AFInAppEventParameterName = ((i3 + i7) - 2) + ((int) (((long) f327e) ^ 7817788349036865294L)) + i4;
            aFj1nSDK.valueOf = (char) (i + ((int) (((long) unregisterClient) ^ 7817788349036865294L)));
            sb.append(aFj1nSDK.valueOf);
            aFj1nSDK.values = aFj1nSDK.valueOf;
            byte[] bArr3 = f326d;
            if (bArr3 != null) {
                int length2 = bArr3.length;
                byte[] bArr4 = new byte[length2];
                for (int i15 = 0; i15 < length2; i15++) {
                    bArr4[i15] = (byte) (((long) bArr3[i15]) ^ 7817788349036865294L);
                }
                bArr3 = bArr4;
            }
            boolean z = bArr3 != null;
            aFj1nSDK.AFKeystoreWrapper = 1;
            while (aFj1nSDK.AFKeystoreWrapper < i7) {
                if (z) {
                    byte[] bArr5 = f326d;
                    int i16 = aFj1nSDK.AFInAppEventParameterName;
                    aFj1nSDK.AFInAppEventParameterName = i16 - 1;
                    aFj1nSDK.valueOf = (char) (aFj1nSDK.values + (((byte) (((byte) (((long) bArr5[i16]) ^ 7817788349036865294L)) + s)) ^ b));
                } else {
                    short[] sArr = f328v;
                    int i17 = aFj1nSDK.AFInAppEventParameterName;
                    aFj1nSDK.AFInAppEventParameterName = i17 - 1;
                    aFj1nSDK.valueOf = (char) (aFj1nSDK.values + (((short) (((short) (((long) sArr[i17]) ^ 7817788349036865294L)) + s)) ^ b));
                }
                sb.append(aFj1nSDK.valueOf);
                aFj1nSDK.values = aFj1nSDK.valueOf;
                aFj1nSDK.AFKeystoreWrapper++;
            }
        }
        objArr[0] = sb.toString();
    }
}
