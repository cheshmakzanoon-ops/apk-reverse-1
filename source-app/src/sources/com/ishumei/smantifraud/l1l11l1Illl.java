package com.ishumei.smantifraud;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.TrafficStats;
import android.text.TextUtils;
import android.text.format.Formatter;
import java.util.HashMap;
import java.util.Map;

public class l1l11l1Illl {
    public Context l1111l111111Il;
    public Object l111l11111lIl = null;

    public l1l11l1Illl() {
        this.l1111l111111Il = null;
        try {
            this.l1111l111111Il = l11l11l111Il.l1111l111111Il;
        } catch (Exception unused) {
        }
    }

    public static String l111l11111I1l() {
        try {
            String property = System.getProperty("http.proxyHost");
            String property2 = System.getProperty("http.proxyPort");
            if (TextUtils.isEmpty(property2)) {
                property2 = "-1";
            }
            if (TextUtils.isEmpty(property)) {
                return "";
            }
            return property + ":" + property2;
        } catch (Exception unused) {
            return "";
        }
    }

    public static Map<String, Long> l111l1111l1Il() {
        HashMap map = new HashMap(5);
        map.put("mr", Long.valueOf(TrafficStats.getMobileRxBytes()));
        map.put("mt", Long.valueOf(TrafficStats.getMobileTxBytes()));
        map.put("tr", Long.valueOf(TrafficStats.getTotalRxBytes()));
        map.put("tt", Long.valueOf(TrafficStats.getTotalTxBytes()));
        return map;
    }

    public String l1111l111111Il() {
        String str;
        try {
            l111l1111lI1l();
            Object obj = this.l111l11111lIl;
            return (obj == null || (str = (String) l1l11lI1lIl.l111l11111lIl(obj, "getBSSID")) == null) ? "" : str;
        } catch (Exception unused) {
            return "";
        }
    }

    public String l111l11111Il() {
        String str;
        try {
            l111l1111lI1l();
            Object obj = this.l111l11111lIl;
            return (obj == null || (str = (String) l1l11lI1lIl.l111l11111lIl(obj, "getSSID")) == null) ? "" : str;
        } catch (Exception unused) {
            return "";
        }
    }

    public String l111l11111lIl() {
        String str = "";
        try {
            if (this.l1111l111111Il == null) {
                return "";
            }
            if (!l1l1l11Ill.l111l1111l1Il("android.permission.ACCESS_NETWORK_STATE")) {
                return "UNKNOWN";
            }
            NetworkInfo activeNetworkInfo = ((ConnectivityManager) this.l1111l111111Il.getSystemService("connectivity")).getActiveNetworkInfo();
            if (activeNetworkInfo != null && activeNetworkInfo.isAvailable() && activeNetworkInfo.isConnected()) {
                int type = activeNetworkInfo.getType();
                if (type == 1) {
                    return "WIFI";
                }
                if (type == 0) {
                    return "WAN";
                }
                str = "" + type;
                return str;
            }
            return "NOTREACHABLE";
        } catch (Exception unused) {
            return str;
        }
    }

    public final void l111l1111lI1l() {
        Object objL1111l111111Il;
        try {
            Context context = l11l11l111Il.l1111l111111Il;
            if (context != null && (objL1111l111111Il = l1l11lI1lIl.l1111l111111Il(context, "getSystemService", new Class[]{String.class}, new Object[]{"wifi"})) != null && this.l111l11111lIl == null && l1l1l11Ill.l111l1111l1Il("android.permission.ACCESS_WIFI_STATE") && l1l1l11Ill.l111l1111l1Il("android.permission.ACCESS_FINE_LOCATION")) {
                this.l111l11111lIl = l1l11lI1lIl.l111l11111lIl(objL1111l111111Il, "getConnectionInfo");
            }
        } catch (Throwable unused) {
        }
    }

    public String l111l1111llIl() {
        String ipAddress;
        try {
            l111l1111lI1l();
            Object obj = this.l111l11111lIl;
            return (obj == null || (ipAddress = Formatter.formatIpAddress(((Integer) l1l11lI1lIl.l111l11111lIl(obj, "getIpAddress")).intValue())) == null) ? "" : ipAddress;
        } catch (Exception unused) {
            return "";
        }
    }
}
