package com.ishumei.smantifraud;

import android.content.Context;
import android.os.Looper;
import android.text.TextUtils;
import android.util.Base64;
import android.util.Log;
import com.ishumei.smantifraud.dfp.SMSDK;
import java.util.Set;

public class SmAntiFraud {
    public static final String AREA_BJ = "bj";
    public static final String AREA_FJNY = "fjny";
    public static final String AREA_XJP = "xjp";
    public static final int SM_AF_ASYN_MODE = 1;
    public static final int SM_AF_SYN_MODE = 0;
    public static final String l1111l111111Il = "Smlog";
    public static IServerSmidCallback l111l11111lIl;
    public static SmOption option;

    public interface IDeviceIdCallback {
        void onResult(String str);
    }

    public interface IServerSmidCallback {
        void onError(int i);

        void onSuccess(String str);
    }

    public static class SmOption {
        public static final int l11l111ll1Il = 1024;
        public Set<String> l11l1111Il;
        public boolean l11l1111Il1l;
        public boolean l11l1111lIIl;
        public byte[] l11l111l11Il;
        public String l11l111l1I1l;
        public SubCollector[] l11l111l1Il;
        public long l11l111ll11l;
        public boolean l1111l111111Il = false;
        public String l111l11111lIl = "";
        public String l111l11111I1l = "";
        public boolean l111l11111Il = true;
        public boolean l111l1111l1Il = true;
        public String l111l1111llIl = null;
        public String l111l1111lI1l = null;
        public String l111l1111lIl = null;
        public boolean l11l1111I11l = false;
        public boolean l11l1111I1l = true;
        public IServerSmidCallback l11l1111I1ll = null;
        public String l11l1111Ill = "default";
        public String l11l11IlIIll = null;
        public boolean l11l111l1lll = false;
        public String l111l11IlIlIl = SmAntiFraud.AREA_BJ;

        public void addSubCollectors(SubCollector... subCollectorArr) {
            this.l11l111l1Il = subCollectorArr;
        }

        public String getAppId() {
            return this.l11l1111Ill;
        }

        public String getArea() {
            return this.l111l11IlIlIl;
        }

        public String getChannel() {
            return this.l111l11111I1l;
        }

        public String getConfUrl() {
            return this.l111l1111lIl;
        }

        public long getDisableCollection() {
            return this.l11l111ll11l;
        }

        public String getExtraInfo() {
            return this.l11l111l1I1l;
        }

        public byte[] getHttpsCrt() {
            return this.l11l111l11Il;
        }

        public Set<String> getNotCollect() {
            return this.l11l1111Il;
        }

        public String getOrganization() {
            return this.l111l11111lIl;
        }

        public String getPublicKey() {
            return this.l11l11IlIIll;
        }

        public String getRetryUrl() {
            return this.l111l1111lI1l;
        }

        public IServerSmidCallback getServerIdCallback() {
            return this.l11l1111I1ll;
        }

        public SubCollector[] getSubCollectors() {
            return this.l11l111l1Il;
        }

        public String getUrl() {
            return this.l111l1111llIl;
        }

        public boolean isCheckCrt() {
            return this.l11l111l1lll;
        }

        public boolean isCloudConf() {
            return this.l111l1111l1Il;
        }

        public boolean isFirst() {
            return this.l11l1111Il1l;
        }

        public boolean isSynMode() {
            return this.l1111l111111Il;
        }

        public boolean isTransport() {
            return this.l111l11111Il;
        }

        public boolean isUsingShortBoxData() {
            return this.l11l1111I11l;
        }

        public boolean needUsingMD5() {
            return this.l11l1111lIIl;
        }

        public void setAppId(String str) {
            this.l11l1111Ill = str;
        }

        public void setArea(String str) {
            this.l111l11IlIlIl = str;
        }

        public void setChannel(String str) {
            this.l111l11111I1l = str;
        }

        public void setCheckCrt(boolean z) {
            this.l11l111l1lll = z;
        }

        public void setCloudConf(boolean z) {
            this.l111l1111l1Il = z;
        }

        public void setConfUrl(String str) {
            this.l111l1111lIl = str;
        }

        public void setDisableCollection(long j) {
            this.l11l111ll11l = j;
        }

        public void setExtraInfo(String str) {
            if (str == null) {
                return;
            }
            if (str.length() > 1024) {
                str = str.substring(0, 1024);
            }
            this.l11l111l1I1l = str;
        }

        public void setFirst(boolean z) {
            this.l11l1111Il1l = z;
        }

        public void setHttpsCrt(byte[] bArr) {
            this.l11l111l11Il = bArr;
        }

        public void setNotCollect(Set<String> set) {
            this.l11l1111Il = set;
        }

        public void setOrganization(String str) {
            this.l111l11111lIl = str;
        }

        public void setPublicKey(String str) {
            this.l11l11IlIIll = str;
        }

        public void setRetryUrl(String str) {
            this.l111l1111lI1l = str;
        }

        public void setServerIdCallback(IServerSmidCallback iServerSmidCallback) {
            this.l11l1111I1ll = iServerSmidCallback;
        }

        public void setSynMode(boolean z) {
            this.l1111l111111Il = z;
        }

        public void setTransport(boolean z) {
            this.l111l11111Il = z;
        }

        public void setUrl(String str) {
            this.l111l1111llIl = str;
        }

        public void setUsingHttps(boolean z) {
            this.l11l1111I1l = z;
        }

        public void setUsingMD5(boolean z) {
            this.l11l1111lIIl = z;
        }

        public String status() {
            StringBuilder sb = new StringBuilder();
            sb.append(this.l111l11111Il ? "1" : "0");
            sb.append(this.l111l1111l1Il ? "1" : "0");
            sb.append(this.l11l1111lIIl ? "1" : "0");
            sb.append(this.l11l1111I1l ? "1" : "0");
            sb.append(SmAntiFraud.l111l11111lIl != null ? "1" : "0");
            Set<String> set = this.l11l1111Il;
            sb.append((set == null || set.size() <= 0) ? "0" : "1");
            sb.append(this.l11l111l1lll ? "1" : "0");
            return sb.toString();
        }

        public boolean usingHttps() {
            return this.l11l1111I1l;
        }

        public void usingShortBoxData(boolean z) {
            this.l11l1111I11l = z;
        }
    }

    public static synchronized boolean create(Context context, SmOption smOption) {
        if (!l1111l111111Il(context, smOption)) {
            return false;
        }
        try {
            l1l11l1I1Il.l111l11111I1l = null;
            l11l11l111Il.l111l1111l1Il = false;
            l11l11l111Il.l1111l111111Il = context.getApplicationContext();
            l11l11l111Il.l111l11111I1l = System.currentTimeMillis();
            if (l11l11l111Il.l111l11111lIl == null) {
                l11l11l111Il.l111l11111lIl = l11l11Il11l.l1111l111111Il();
            }
            l111l11111lIl(smOption);
        } catch (Throwable th) {
            Log.e("Smlog", "smsdk init exception!", th);
            l1l11l1I1Il.l111l11111I1l = "smsdk init exception!;" + th;
        }
        return TextUtils.isEmpty(l1l11l1I1Il.l111l11111I1l);
    }

    public static void destroy() {
        try {
            l11l11l111Il.l1111l111111Il();
            l11l11ll1ll.l1111l111111Il().l111l11111lIl();
            registerServerIdCallback(null);
            SMSDK.m370d();
        } catch (Throwable unused) {
        }
    }

    public static String getDeviceId() {
        synchronized (SmAntiFraud.class) {
            if (l11l11l111Il.l111l1111l1Il) {
                return l11l11l111Il.l111l1111llIl;
            }
            if (TextUtils.isEmpty(l1l11l1I1Il.l111l11111I1l)) {
                return l111l11I1IIIl.l111l1111l1Il().l111l11111Il();
            }
            Log.e("Smlog", l1l11l1I1Il.l111l11111I1l);
            try {
                throw new IllegalAccessException(l1l11l1I1Il.l111l11111I1l);
            } catch (Throwable th) {
                try {
                    return "D" + l1l1l11Ill.l1111l111111Il(l111l111I1l.l111l11111lIl.l1111l111111Il.l1111l111111Il(th).getBytes());
                } catch (Throwable th2) {
                    return "D" + Base64.encodeToString((l1l11l1I1Il.l111l11111I1l + ";" + th2).getBytes(), 0);
                }
            }
        }
    }

    public static void getDeviceId(IDeviceIdCallback iDeviceIdCallback) {
        if (iDeviceIdCallback == null) {
            throw new IllegalArgumentException("callback cannot be null.");
        }
        l111l11I1IIIl.l111l1111l1Il().l1111l111111Il(iDeviceIdCallback, Thread.currentThread() == Looper.getMainLooper().getThread());
    }

    public static String getSDKVersion() {
        return "3.14.3_build1";
    }

    public static IServerSmidCallback getServerIdCallback() {
        return l111l11111lIl;
    }

    public static String getVData() {
        if (option == null) {
            Log.e("Smlog", "SmOption is null.");
            return "DU21PcHRpb24gaXMgbnVsbC4=";
        }
        try {
            return "D" + l1l1l11Ill.l1111l111111Il(l1l1l11Il.l111l11111I1l().l111l11111Il().getBytes());
        } catch (Throwable th) {
            return "D" + l111l111I1l.l111l11111lIl.l1111l111111Il.l1111l111111Il(th);
        }
    }

    public static void l1111l111111Il(SmOption smOption) {
        boolean z;
        SmOption smOption2;
        String url;
        option = smOption;
        if (TextUtils.isEmpty(smOption.getUrl())) {
            SmOption smOption3 = option;
            smOption3.setUrl(l11l11lI1lll.l111l11111Il(smOption3.getArea(), option.usingHttps()));
            z = true;
        } else {
            z = false;
        }
        if (TextUtils.isEmpty(option.getRetryUrl())) {
            if (z) {
                smOption2 = option;
                url = l11l11lI1lll.l111l11111I1l(smOption2.getArea(), option.usingHttps());
            } else {
                smOption2 = option;
                url = smOption2.getUrl();
            }
            smOption2.setRetryUrl(url);
        }
        if (TextUtils.isEmpty(option.getConfUrl())) {
            SmOption smOption4 = option;
            smOption4.setConfUrl(l11l11lI1lll.l1111l111111Il(smOption4.getArea(), option.l11l1111I1l));
        }
        l111l11I1IIIl.l111l1111l1Il().l1111l111111Il(l11l11lI1lll.l1111l111111Il(option.getArea()), option.getOrganization());
        if (option.getServerIdCallback() != null) {
            l111l11111lIl = option.getServerIdCallback();
        }
    }

    public static boolean l1111l111111Il(Context context, SmOption smOption) {
        String str;
        if (context == null) {
            str = "context is null!";
        } else if (smOption == null) {
            str = "SmOption is null!";
        } else if (TextUtils.isEmpty(smOption.getOrganization())) {
            str = "SmOption.organization is null!";
        } else {
            if (!TextUtils.isEmpty(smOption.getPublicKey())) {
                return true;
            }
            str = "SmOption.publicKey is null!";
        }
        l1l11l1I1Il.l111l11111I1l = str;
        Log.e("Smlog", str);
        return false;
    }

    public static void l111l11111lIl() {
        IServerSmidCallback iServerSmidCallback;
        String strL1111l111111Il = l111l11I1IIIl.l111l1111l1Il().l1111l111111Il();
        if (!TextUtils.isEmpty(strL1111l111111Il) && (iServerSmidCallback = l111l11111lIl) != null) {
            iServerSmidCallback.onSuccess("B" + strL1111l111111Il);
        }
        l111l11111I1l.l1111l111111Il(l11l11l111Il.l1111l111111Il);
        if (l11l111ll1Il.l1111l111111Il(l11l11l111Il.l1111l111111Il, option) && l11IIIlIll.l111l11111lIl().l111l1111l1Il() && option.isTransport()) {
            if (option.isCloudConf()) {
                l11l111l1lll.l1111l111111Il().l1111l111111Il(option);
            }
            l11l111lll.l111l11111lIl().l1111l111111Il(option.getUrl(), option.getRetryUrl());
        }
    }

    public static void l111l11111lIl(SmOption smOption) {
        l1111l111111Il(smOption);
        l1l11I1l1l.l1111l111111Il.execute(new Runnable() {
            @Override
            public final void run() {
                SmAntiFraud.l111l11111lIl();
            }
        });
    }

    public static synchronized void registerServerIdCallback(IServerSmidCallback iServerSmidCallback) {
        l111l11111lIl = iServerSmidCallback;
    }

    public static void startDetector(AbsDetector absDetector) {
        if (option == null) {
            Log.e("Smlog", "SmOption is null.");
        } else {
            l1l1l11Il.l111l11111I1l().l1111l111111Il(absDetector);
        }
    }

    public static void stopDetector(AbsDetector absDetector) {
        if (option == null) {
            Log.e("Smlog", "SmOption is null.");
        } else {
            l1l1l11Il.l111l11111I1l().l111l11111lIl(absDetector);
        }
    }
}
