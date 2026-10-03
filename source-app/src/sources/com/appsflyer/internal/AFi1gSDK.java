package com.appsflyer.internal;

import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.os.Looper;
import j$.util.concurrent.ConcurrentHashMap;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Executor;
import java.util.concurrent.ExecutorService;

public final class AFi1gSDK implements SensorEventListener {
    private final String AFInAppEventParameterName;
    private final int AFInAppEventType;
    private double AFKeystoreWrapper;
    private final Executor AFLogger;

    private final float[][] f401e = new float[2][];
    private final long[] registerClient = new long[2];
    private long unregisterClient;
    private final int valueOf;
    private final String values;

    @Override
    public final void onAccuracyChanged(Sensor sensor, int i) {
    }

    AFi1gSDK(Sensor sensor, ExecutorService executorService) {
        int type = sensor.getType();
        this.valueOf = type;
        String name = sensor.getName();
        name = name == null ? "" : name;
        this.values = name;
        String vendor = sensor.getVendor();
        String str = vendor != null ? vendor : "";
        this.AFInAppEventParameterName = str;
        this.AFInAppEventType = ((((type + 31) * 31) + name.hashCode()) * 31) + str.hashCode();
        this.AFLogger = executorService;
    }

    private static double AFKeystoreWrapper(float[] fArr, float[] fArr2) {
        int iMin = Math.min(fArr.length, fArr2.length);
        double dPow = 0.0d;
        for (int i = 0; i < iMin; i++) {
            dPow += StrictMath.pow(fArr[i] - fArr2[i], 2.0d);
        }
        return Math.sqrt(dPow);
    }

    private static List<Float> AFInAppEventParameterName(float[] fArr) {
        ArrayList arrayList = new ArrayList(fArr.length);
        for (float f : fArr) {
            arrayList.add(Float.valueOf(f));
        }
        return arrayList;
    }

    @Override
    public final void onSensorChanged(final SensorEvent sensorEvent) {
        if (Looper.myLooper() == Looper.getMainLooper()) {
            this.AFLogger.execute(new Runnable() {
                @Override
                public final void run() {
                    this.f$0.values(sensorEvent);
                }
            });
        } else {
            values(sensorEvent);
        }
    }

    public void values(SensorEvent sensorEvent) {
        long j = sensorEvent.timestamp;
        float[] fArr = sensorEvent.values;
        long jCurrentTimeMillis = System.currentTimeMillis();
        float[][] fArr2 = this.f401e;
        float[] fArr3 = fArr2[0];
        if (fArr3 == null) {
            fArr2[0] = Arrays.copyOf(fArr, fArr.length);
            this.registerClient[0] = jCurrentTimeMillis;
            return;
        }
        float[] fArr4 = fArr2[1];
        if (fArr4 == null) {
            float[] fArrCopyOf = Arrays.copyOf(fArr, fArr.length);
            this.f401e[1] = fArrCopyOf;
            this.registerClient[1] = jCurrentTimeMillis;
            this.AFKeystoreWrapper = AFKeystoreWrapper(fArr3, fArrCopyOf);
            return;
        }
        if (50000000 <= j - this.unregisterClient) {
            this.unregisterClient = j;
            if (Arrays.equals(fArr4, fArr)) {
                this.registerClient[1] = jCurrentTimeMillis;
                return;
            }
            double dAFKeystoreWrapper = AFKeystoreWrapper(fArr3, fArr);
            if (dAFKeystoreWrapper > this.AFKeystoreWrapper) {
                this.f401e[1] = Arrays.copyOf(fArr, fArr.length);
                this.registerClient[1] = jCurrentTimeMillis;
                this.AFKeystoreWrapper = dAFKeystoreWrapper;
            }
        }
    }

    final void AFInAppEventType(Map<AFi1gSDK, Map<String, Object>> map, boolean z) {
        if (AFInAppEventParameterName()) {
            map.put(this, valueOf());
            if (z) {
                int length = this.f401e.length;
                for (int i = 0; i < length; i++) {
                    this.f401e[i] = null;
                }
                int length2 = this.registerClient.length;
                for (int i2 = 0; i2 < length2; i2++) {
                    this.registerClient[i2] = 0;
                }
                this.AFKeystoreWrapper = 0.0d;
                this.unregisterClient = 0L;
                return;
            }
            return;
        }
        if (map.containsKey(this)) {
            return;
        }
        map.put(this, valueOf());
    }

    private boolean AFInAppEventType(int i, String str, String str2) {
        return this.valueOf == i && this.values.equals(str) && this.AFInAppEventParameterName.equals(str2);
    }

    private Map<String, Object> valueOf() {
        ConcurrentHashMap concurrentHashMap = new ConcurrentHashMap(7);
        concurrentHashMap.put("sT", Integer.valueOf(this.valueOf));
        concurrentHashMap.put("sN", this.values);
        concurrentHashMap.put("sV", this.AFInAppEventParameterName);
        float[] fArr = this.f401e[0];
        if (fArr != null) {
            concurrentHashMap.put("sVS", AFInAppEventParameterName(fArr));
        }
        float[] fArr2 = this.f401e[1];
        if (fArr2 != null) {
            concurrentHashMap.put("sVE", AFInAppEventParameterName(fArr2));
        }
        return concurrentHashMap;
    }

    private boolean AFInAppEventParameterName() {
        return this.f401e[0] != null;
    }

    public final int hashCode() {
        return this.AFInAppEventType;
    }

    public final boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        if (!(obj instanceof AFi1gSDK)) {
            return false;
        }
        AFi1gSDK aFi1gSDK = (AFi1gSDK) obj;
        return AFInAppEventType(aFi1gSDK.valueOf, aFi1gSDK.values, aFi1gSDK.AFInAppEventParameterName);
    }
}
