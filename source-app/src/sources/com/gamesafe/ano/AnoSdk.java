package com.gamesafe.ano;

import android.content.Context;

public class AnoSdk {
    public static final int ACE_LOCALE_EN = 2;
    public static final int ACE_LOCALE_EU = 5;
    public static final int ACE_LOCALE_IN = 6;
    public static final int ACE_LOCALE_JP = 7;
    public static final int ACE_LOCALE_KR = 8;
    public static final int ACE_LOCALE_RU = 3;
    public static final int ACE_LOCALE_US = 4;
    public static final int ACE_LOCALE_VN = 10;
    public static final int ACE_LOCALE_WW = 9;
    public static final int ACE_LOCALE_ZN = 1;
    public static final int ACE_LOCAL_GLOBAL = 998;
    public static final int ACE_LOCAL_OTHERS = 999;
    public static final String ANO_SDK_VERSION = "7.4.15(2020/11/10)-jar-version";
    public static final int APP_OBJECT_ACTIVITY = 1;
    public static final int APP_OBJECT_CONTEXT = 2;
    public static final int ENTRT_ID_FACEBOOK = 3;
    public static final int ENTRY_ID_APPLE = 11;
    public static final int ENTRY_ID_CUSTOM = 21;
    public static final int ENTRY_ID_EA = 20;
    public static final int ENTRY_ID_EMAIL = 131;
    public static final int ENTRY_ID_GAMECENTER = 7;
    public static final int ENTRY_ID_GARENA = 14;
    public static final int ENTRY_ID_GOOGLEPLAY = 8;
    public static final int ENTRY_ID_HW = 15;
    public static final int ENTRY_ID_KUAISHOU = 10;
    public static final int ENTRY_ID_LINE = 5;
    public static final int ENTRY_ID_MICROSOFT = 19;
    public static final int ENTRY_ID_MM = 2;
    public static final int ENTRY_ID_NAVER = 13;
    public static final int ENTRY_ID_NEXON = 12;
    public static final int ENTRY_ID_NINTENDO = 17;
    public static final int ENTRY_ID_OTHERS = 99;
    public static final int ENTRY_ID_PSN = 18;
    public static final int ENTRY_ID_Q = 1;
    public static final int ENTRY_ID_RIOT = 16;
    public static final int ENTRY_ID_TWITTER = 4;
    public static final int ENTRY_ID_VK = 9;
    public static final int ENTRY_ID_WHATSAPP = 6;

    public interface ISendDataToSvr {
        int sendDataToSvr(byte[] bArr, int i);
    }

    static {
        System.loadLibrary("anogs");
    }

    public static String decAnoInfo(String str) {
        return ioctl(String.format("dec_tss_info:%s", str));
    }

    public static void enableGameReport() {
        ioctl("EnableGameReport");
    }

    public static byte[] getReportData() {
        AnoIOCtlResult anoIOCtlResult = new AnoIOCtlResult();
        anoIOCtlResult.cmd = C0975a.m846a("bzo_mzkjmo_yvov");
        if (getsdkantidata(anoIOCtlResult) != 0) {
            return null;
        }
        return anoIOCtlResult.data;
    }

    public static native int getsdkantidata(Object obj);

    public static native int hasMatchRate(int i);

    public static void init(Context context, int i) {
        AnoSdkInitInfo anoSdkInitInfo = new AnoSdkInitInfo();
        anoSdkInitInfo.game_id = i;
        init(anoSdkInitInfo);
    }

    public static native void init(Object obj);

    public static void initEx(int i, String str) {
        C0976b.m847a(C0975a.m846a("vkk_fzt:") + str);
        AnoSdkInitInfo anoSdkInitInfo = new AnoSdkInitInfo();
        anoSdkInitInfo.game_id = i;
        init(anoSdkInitInfo);
    }

    public static String ioctl(String str) {
        if (str == null || str.length() == 0) {
            return null;
        }
        AnoIOCtlResult anoIOCtlResult = new AnoIOCtlResult();
        anoIOCtlResult.cmd = str;
        if (getsdkantidata(anoIOCtlResult) != 0) {
            return null;
        }
        return anoIOCtlResult.response;
    }

    public static void onPause() {
        AnoSdkGameStatusInfo anoSdkGameStatusInfo = new AnoSdkGameStatusInfo();
        anoSdkGameStatusInfo.game_status = 2;
        setgamestatus(anoSdkGameStatusInfo);
    }

    public static void onRecvData(byte[] bArr) {
        senddatatosdk(bArr, bArr.length);
    }

    public static void onResume() {
        AnoSdkGameStatusInfo anoSdkGameStatusInfo = new AnoSdkGameStatusInfo();
        anoSdkGameStatusInfo.game_status = 1;
        setgamestatus(anoSdkGameStatusInfo);
    }

    public static native void onruntimeinfo(byte[] bArr, int i);

    public static void registAnoInfoReceiver(AnoInfoPublisher.AnoInfoReceiver anoInfoReceiver) {
        AnoInfoPublisher.getInstance().registAnoInfoReceiver(anoInfoReceiver);
    }

    public static native void senddatatosdk(byte[] bArr, int i);

    public static native void senddatatosvr(byte[] bArr, int i);

    public static void setAppObject(int i, Object obj) {
        C0977c.m853a(i, obj);
        setappobject(i, obj);
    }

    public static void setLocaleId(int i) {
        ioctl("SetLocaleId:" + i);
    }

    public static void setUserInfo(int i, String str) {
        AnoSdkUserInfo anoSdkUserInfo = new AnoSdkUserInfo();
        anoSdkUserInfo.entry_id = i;
        anoSdkUserInfo.uin_type = 2;
        anoSdkUserInfo.uin_str = str;
        anoSdkUserInfo.app_id_type = 2;
        anoSdkUserInfo.app_id_str = "";
        setuserinfo(anoSdkUserInfo);
    }

    public static native int setappobject(int i, Object obj);

    public static native void setgamestatus(Object obj);

    public static native void setsenddatatosvrcb(Object obj);

    public static native void setuserinfo(Object obj);

    public static native void setuserinfoex(Object obj);
}
