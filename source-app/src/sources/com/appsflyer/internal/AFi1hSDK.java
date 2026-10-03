package com.appsflyer.internal;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorManager;
import android.os.Handler;
import android.os.HandlerThread;
import com.appsflyer.AFLogger;
import j$.util.concurrent.ConcurrentHashMap;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.BitSet;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.ExecutorService;

public final class AFi1hSDK implements AFi1fSDK {
    private static final BitSet values;
    private final SensorManager AFInAppEventParameterName;
    private final Object AFInAppEventType;
    final Handler AFKeystoreWrapper;
    private final Map<AFi1gSDK, Map<String, Object>> AFLogger;
    private final Runnable afInfoLog;

    private int f402d;

    private boolean f403e;
    private final Runnable force;

    private long f404i;
    private boolean registerClient;
    private final Map<AFi1gSDK, AFi1gSDK> unregisterClient;

    private final Runnable f405v;
    private final ExecutorService valueOf;

    private final Runnable f406w;

    static boolean force(AFi1hSDK aFi1hSDK) {
        aFi1hSDK.f403e = false;
        return false;
    }

    static {
        BitSet bitSet = new BitSet(6);
        values = bitSet;
        bitSet.set(1);
        bitSet.set(2);
        bitSet.set(4);
    }

    public void registerClient() {
        synchronized (this.AFInAppEventType) {
            this.AFKeystoreWrapper.post(new RunnableC08662());
        }
    }

    private AFi1hSDK(SensorManager sensorManager, Handler handler, ExecutorService executorService) {
        this.AFInAppEventType = new Object();
        BitSet bitSet = values;
        this.unregisterClient = new HashMap(bitSet.size());
        this.AFLogger = new ConcurrentHashMap(bitSet.size());
        this.f402d = 1;
        this.f404i = 0L;
        this.afInfoLog = new Runnable() {
            @Override
            public final void run() {
                synchronized (AFi1hSDK.this.AFInAppEventType) {
                    AFi1hSDK.this.values();
                    AFi1hSDK.this.AFKeystoreWrapper.postDelayed(AFi1hSDK.this.force, 100L);
                    AFi1hSDK.this.registerClient = true;
                }
            }
        };
        this.f406w = new Runnable() {
            @Override
            public final void run() {
                this.f$0.registerClient();
            }
        };
        this.f405v = new Runnable() {
            @Override
            public final void run() {
                synchronized (AFi1hSDK.this.AFInAppEventType) {
                    if (AFi1hSDK.this.registerClient) {
                        AFi1hSDK.this.AFKeystoreWrapper.removeCallbacks(AFi1hSDK.this.afInfoLog);
                        AFi1hSDK.this.AFKeystoreWrapper.removeCallbacks(AFi1hSDK.this.f406w);
                        AFi1hSDK aFi1hSDK = AFi1hSDK.this;
                        aFi1hSDK.AFKeystoreWrapper.post(aFi1hSDK.new RunnableC08662());
                        AFi1hSDK.this.registerClient = false;
                    }
                }
            }
        };
        this.force = new Runnable() {
            @Override
            public final void run() {
                synchronized (AFi1hSDK.this.AFInAppEventType) {
                    if (AFi1hSDK.this.f402d == 0) {
                        AFi1hSDK.this.f402d = 1;
                    }
                    AFi1hSDK.this.AFKeystoreWrapper.postDelayed(AFi1hSDK.this.f406w, ((long) AFi1hSDK.this.f402d) * 500);
                }
            }
        };
        this.AFInAppEventParameterName = sensorManager;
        this.AFKeystoreWrapper = handler;
        this.valueOf = executorService;
    }

    private static boolean valueOf(int i) {
        return i >= 0 && values.get(i);
    }

    @Override
    public final void valueOf() {
        this.AFKeystoreWrapper.post(this.f405v);
        this.AFKeystoreWrapper.post(this.afInfoLog);
    }

    @Override
    public final synchronized void AFInAppEventParameterName() {
        this.AFKeystoreWrapper.post(this.f405v);
    }

    final void values() {
        this.AFKeystoreWrapper.post(new Runnable() {
            @Override
            public final void run() {
                this.f$0.m822e();
            }
        });
    }

    public void m822e() {
        try {
            for (Sensor sensor : this.AFInAppEventParameterName.getSensorList(-1)) {
                if (valueOf(sensor.getType())) {
                    AFi1gSDK aFi1gSDK = new AFi1gSDK(sensor, this.valueOf);
                    if (!this.unregisterClient.containsKey(aFi1gSDK)) {
                        this.unregisterClient.put(aFi1gSDK, aFi1gSDK);
                    }
                    this.AFInAppEventParameterName.registerListener(this.unregisterClient.get(aFi1gSDK), sensor, 0, this.AFKeystoreWrapper);
                }
            }
        } catch (Throwable th) {
            AFLogger.afErrorLogForExcManagerOnly("registerListeners error", th);
        }
        this.f403e = true;
    }

    final class RunnableC08662 implements Runnable {
        RunnableC08662() {
        }

        @Override
        public final void run() {
            try {
                if (!AFi1hSDK.this.unregisterClient.isEmpty()) {
                    for (AFi1gSDK aFi1gSDK : AFi1hSDK.this.unregisterClient.values()) {
                        AFi1hSDK.this.AFInAppEventParameterName.unregisterListener(aFi1gSDK);
                        aFi1gSDK.AFInAppEventType(AFi1hSDK.this.AFLogger, true);
                    }
                }
            } catch (Throwable th) {
                AFLogger.afErrorLogForExcManagerOnly("error while unregistering listeners", th);
            }
            AFi1hSDK.this.f402d = 0;
            AFi1hSDK.force(AFi1hSDK.this);
        }
    }

    private List<Map<String, Object>> m819d() {
        synchronized (this.AFInAppEventType) {
            Iterator<AFi1gSDK> it = this.unregisterClient.values().iterator();
            while (it.hasNext()) {
                it.next().AFInAppEventType(this.AFLogger, true);
            }
            Map<AFi1gSDK, Map<String, Object>> map = this.AFLogger;
            if (map != null && !map.isEmpty()) {
                return new CopyOnWriteArrayList(this.AFLogger.values());
            }
            return new CopyOnWriteArrayList(Collections.emptyList());
        }
    }

    private List<Map<String, Object>> unregisterClient() {
        synchronized (this.AFInAppEventType) {
            if (!this.unregisterClient.isEmpty() && this.f403e) {
                Iterator<AFi1gSDK> it = this.unregisterClient.values().iterator();
                while (it.hasNext()) {
                    it.next().AFInAppEventType(this.AFLogger, false);
                }
            }
            if (this.AFLogger.isEmpty()) {
                return new CopyOnWriteArrayList(Collections.emptyList());
            }
            return new CopyOnWriteArrayList(this.AFLogger.values());
        }
    }

    @Override
    public final Map<String, Object> AFKeystoreWrapper() throws ParseException {
        AFi1iSDK.AFa1ySDK aFa1ySDK;
        ArrayList arrayList;
        Map<String, Object> concurrentHashMap = new ConcurrentHashMap<>();
        List<Map<String, Object>> listM819d = m819d();
        if (!listM819d.isEmpty()) {
            new AFi1iSDK();
            HashMap map = new HashMap();
            Iterator<Map<String, Object>> it = listM819d.iterator();
            while (it.hasNext()) {
                Map<String, Object> next = it.next();
                HashMap map2 = new HashMap();
                boolean z = next.get("sVS") != null;
                boolean z2 = next.get("sVE") != null;
                if (z && z2) {
                    aFa1ySDK = AFi1iSDK.AFa1ySDK.ALL;
                } else if (z) {
                    aFa1ySDK = AFi1iSDK.AFa1ySDK.FIRST;
                } else {
                    aFa1ySDK = AFi1iSDK.AFa1ySDK.NONE;
                }
                if (aFa1ySDK != AFi1iSDK.AFa1ySDK.NONE) {
                    Integer num = (Integer) next.get("sT");
                    String str = (String) next.get("sN");
                    if (str == null) {
                        map2.put("n", "uk");
                    } else {
                        map2.put("n", str);
                    }
                    AFi1iSDK.AFa1vSDK aFa1vSDK = AFi1iSDK.AFa1vSDK.values()[num.intValue()];
                    ArrayList arrayList2 = new ArrayList(AFi1iSDK.AFInAppEventParameterName(next.get("sVS")));
                    if (aFa1ySDK == AFi1iSDK.AFa1ySDK.ALL) {
                        arrayList2.addAll(AFi1iSDK.AFInAppEventParameterName(next.get("sVE")));
                    }
                    if (aFa1vSDK == AFi1iSDK.AFa1vSDK.MAGNETOMETER) {
                        ArrayList arrayList3 = new ArrayList();
                        BigDecimal bigDecimal = (BigDecimal) arrayList2.get(0);
                        BigDecimal bigDecimalValueOf = BigDecimal.valueOf(Math.atan2(((BigDecimal) arrayList2.get(1)).doubleValue(), bigDecimal.doubleValue()) * 57.29577951308232d);
                        DecimalFormat decimalFormat = new DecimalFormat("##.#");
                        decimalFormat.setRoundingMode(RoundingMode.DOWN);
                        arrayList3.add(Double.valueOf(AFc1uSDK.values(decimalFormat.format(bigDecimalValueOf))));
                        BigDecimal bigDecimal2 = (BigDecimal) arrayList2.get(2);
                        DecimalFormat decimalFormat2 = new DecimalFormat("##.#");
                        decimalFormat2.setRoundingMode(RoundingMode.DOWN);
                        arrayList3.add(Double.valueOf(AFc1uSDK.values(decimalFormat2.format(bigDecimal2))));
                        ArrayList arrayList4 = new ArrayList();
                        if (arrayList2.size() > 5) {
                            BigDecimal bigDecimal3 = (BigDecimal) arrayList2.get(3);
                            BigDecimal bigDecimalSubtract = BigDecimal.valueOf(Math.atan2(((BigDecimal) arrayList2.get(4)).doubleValue(), bigDecimal3.doubleValue()) * 57.29577951308232d).subtract(bigDecimalValueOf);
                            DecimalFormat decimalFormat3 = new DecimalFormat("##.#");
                            decimalFormat3.setRoundingMode(RoundingMode.DOWN);
                            arrayList4.add(Double.valueOf(AFc1uSDK.values(decimalFormat3.format(bigDecimalSubtract))));
                            BigDecimal bigDecimalSubtract2 = ((BigDecimal) arrayList2.get(5)).subtract((BigDecimal) arrayList2.get(2));
                            DecimalFormat decimalFormat4 = new DecimalFormat("##.#");
                            decimalFormat4.setRoundingMode(RoundingMode.DOWN);
                            arrayList4.add(Double.valueOf(AFc1uSDK.values(decimalFormat4.format(bigDecimalSubtract2))));
                        }
                        arrayList = new ArrayList();
                        arrayList.add(arrayList3);
                        arrayList.add(arrayList4);
                    } else {
                        concurrentHashMap = concurrentHashMap;
                        it = it;
                        ArrayList arrayList5 = new ArrayList();
                        if (arrayList2.size() > 5) {
                            BigDecimal bigDecimalSubtract3 = ((BigDecimal) arrayList2.get(3)).subtract((BigDecimal) arrayList2.get(0));
                            DecimalFormat decimalFormat5 = new DecimalFormat("##.#");
                            decimalFormat5.setRoundingMode(RoundingMode.DOWN);
                            arrayList5.add(Double.valueOf(AFc1uSDK.values(decimalFormat5.format(bigDecimalSubtract3))));
                            BigDecimal bigDecimalSubtract4 = ((BigDecimal) arrayList2.get(4)).subtract((BigDecimal) arrayList2.get(1));
                            DecimalFormat decimalFormat6 = new DecimalFormat("##.#");
                            decimalFormat6.setRoundingMode(RoundingMode.DOWN);
                            arrayList5.add(Double.valueOf(AFc1uSDK.values(decimalFormat6.format(bigDecimalSubtract4))));
                            BigDecimal bigDecimalSubtract5 = ((BigDecimal) arrayList2.get(5)).subtract((BigDecimal) arrayList2.get(2));
                            DecimalFormat decimalFormat7 = new DecimalFormat("##.#");
                            decimalFormat7.setRoundingMode(RoundingMode.DOWN);
                            arrayList5.add(Double.valueOf(AFc1uSDK.values(decimalFormat7.format(bigDecimalSubtract5))));
                        }
                        ArrayList arrayList6 = new ArrayList();
                        BigDecimal bigDecimal4 = (BigDecimal) arrayList2.get(0);
                        DecimalFormat decimalFormat8 = new DecimalFormat("##.#");
                        decimalFormat8.setRoundingMode(RoundingMode.DOWN);
                        arrayList6.add(Double.valueOf(AFc1uSDK.values(decimalFormat8.format(bigDecimal4))));
                        BigDecimal bigDecimal5 = (BigDecimal) arrayList2.get(1);
                        DecimalFormat decimalFormat9 = new DecimalFormat("##.#");
                        decimalFormat9.setRoundingMode(RoundingMode.DOWN);
                        arrayList6.add(Double.valueOf(AFc1uSDK.values(decimalFormat9.format(bigDecimal5))));
                        BigDecimal bigDecimal6 = (BigDecimal) arrayList2.get(2);
                        DecimalFormat decimalFormat10 = new DecimalFormat("##.#");
                        decimalFormat10.setRoundingMode(RoundingMode.DOWN);
                        arrayList6.add(Double.valueOf(AFc1uSDK.values(decimalFormat10.format(bigDecimal6))));
                        ArrayList arrayList7 = new ArrayList();
                        arrayList7.add(arrayList6);
                        arrayList7.add(arrayList5);
                        arrayList = arrayList7;
                    }
                    map2.put("v", arrayList);
                    map.put(AFi1iSDK.AFa1tSDK.values()[num.intValue()].values, map2);
                    if (aFa1ySDK == AFi1iSDK.AFa1ySDK.FIRST) {
                        map.put("er", "no_svs");
                    }
                    concurrentHashMap = concurrentHashMap;
                    it = it;
                } else {
                    map = new HashMap();
                    map.put("er", "na");
                    break;
                }
            }
            concurrentHashMap.put("sensors", map);
        } else {
            concurrentHashMap.put("sensors", "na");
        }
        return concurrentHashMap;
    }

    @Override
    public final Map<String, Object> AFInAppEventType() {
        ConcurrentHashMap concurrentHashMap = new ConcurrentHashMap();
        List<Map<String, Object>> listUnregisterClient = unregisterClient();
        if (!listUnregisterClient.isEmpty()) {
            concurrentHashMap.put("sensors", listUnregisterClient);
        } else {
            List<Map<String, Object>> listM819d = m819d();
            if (!listM819d.isEmpty()) {
                concurrentHashMap.put("sensors", listM819d);
            }
        }
        return concurrentHashMap;
    }

    public AFi1hSDK(Context context, ExecutorService executorService) {
        SensorManager sensorManager = (SensorManager) context.getApplicationContext().getSystemService("sensor");
        HandlerThread handlerThread = new HandlerThread("internal");
        handlerThread.start();
        this(sensorManager, new Handler(handlerThread.getLooper()), executorService);
    }
}
