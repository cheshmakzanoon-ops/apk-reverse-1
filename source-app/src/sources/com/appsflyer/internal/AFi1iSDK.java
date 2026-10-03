package com.appsflyer.internal;

import com.appsflyer.AFLogger;
import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

public final class AFi1iSDK {

    enum AFa1ySDK {
        NONE,
        FIRST,
        ALL
    }

    static List<BigDecimal> AFInAppEventParameterName(Object obj) {
        ArrayList arrayList = (ArrayList) obj;
        Float f = (Float) arrayList.get(0);
        Float f2 = (Float) arrayList.get(1);
        Float f3 = (Float) arrayList.get(2);
        ArrayList arrayList2 = new ArrayList();
        try {
            arrayList2.add(BigDecimal.valueOf(AFc1uSDK.values(f.toString())));
            arrayList2.add(BigDecimal.valueOf(AFc1uSDK.values(f2.toString())));
            arrayList2.add(BigDecimal.valueOf(AFc1uSDK.values(f3.toString())));
        } catch (ParseException e) {
            AFLogger.afErrorLogForExcManagerOnly("failed to parse string to number", e);
        }
        return arrayList2;
    }

    enum AFa1vSDK {
        UNKNOWN(0),
        ACCELEROMETER(1),
        MAGNETOMETER(2),
        RESERVED(3),
        GYROSCOPE(4);

        private int unregisterClient;

        AFa1vSDK(int i) {
            this.unregisterClient = i;
        }
    }

    enum AFa1tSDK {
        UNKNOWN("uk"),
        ACCELEROMETER("am"),
        MAGNETOMETER("mm"),
        RESERVED("rs"),
        GYROSCOPE("gs");

        String values;

        AFa1tSDK(String str) {
            this.values = str;
        }
    }
}
