package com.ishumei.smantifraud;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorManager;
import java.util.ArrayList;
import java.util.List;

public class l1l11I111l {
    public static List<String> l1111l111111Il() {
        ArrayList arrayList = new ArrayList();
        try {
            Context context = l11l11l111Il.l1111l111111Il;
            if (context != null) {
                for (Sensor sensor : ((SensorManager) context.getSystemService(l111l1111llIl.l11l111ll11l)).getSensorList(-1)) {
                    arrayList.add(sensor.getType() + "," + sensor.getVendor());
                }
            }
        } catch (Exception unused) {
        }
        return arrayList;
    }
}
