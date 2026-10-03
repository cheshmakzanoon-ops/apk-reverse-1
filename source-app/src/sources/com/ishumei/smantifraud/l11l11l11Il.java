package com.ishumei.smantifraud;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.IBinder;
import android.os.Parcel;
import android.provider.Settings;
import android.text.TextUtils;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;

public class l11l11l11Il extends l1l11lI11l {
    public final LinkedBlockingQueue<IBinder> l111l11111I1l = new LinkedBlockingQueue<>(1);
    public final ServiceConnection l111l11111Il = new l111l11111lIl();
    public final Context l111l11111lIl;

    public class l1111l111111Il implements ServiceConnection {
        public final Context l1111l111111Il;

        public l1111l111111Il(Context context) {
            this.l1111l111111Il = context;
        }

        @Override
        public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
            try {
                this.l1111l111111Il.unbindService(this);
            } catch (Throwable unused) {
            }
        }

        @Override
        public void onServiceDisconnected(ComponentName componentName) {
        }
    }

    public class l111l11111lIl implements ServiceConnection {
        public l111l11111lIl() {
        }

        @Override
        public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
            try {
                l11l11l11Il.this.l111l11111I1l.offer(iBinder, 3000L, TimeUnit.MILLISECONDS);
            } catch (Exception unused) {
            }
        }

        @Override
        public void onServiceDisconnected(ComponentName componentName) {
        }
    }

    public l11l11l11Il(Context context) {
        this.l111l11111lIl = context;
    }

    public static boolean l1111l111111Il(Context context) {
        try {
            if (!l1111l111111Il(Settings.Global.getString(context.getContentResolver(), "pps_oaid"))) {
                return true;
            }
            Intent intent = new Intent("com.uodis.opendevice.OPENIDS_SERVICE");
            intent.setPackage(l111l11111lIl(context));
            return context.bindService(intent, new l1111l111111Il(context), 1);
        } catch (Throwable unused) {
            return false;
        }
    }

    public static boolean l1111l111111Il(Context context, String str) {
        return l111l11111lIl(context, str) != null;
    }

    public static boolean l1111l111111Il(String str) {
        if (TextUtils.isEmpty(str)) {
            return true;
        }
        return str.replaceAll("0", "").replaceAll("-", "").isEmpty();
    }

    public static PackageInfo l111l11111lIl(Context context, String str) {
        if (!TextUtils.isEmpty(str) && context != null) {
            try {
                PackageManager packageManager = context.getPackageManager();
                if (packageManager != null) {
                    return packageManager.getPackageInfo(str, 128);
                }
            } catch (Throwable unused) {
            }
        }
        return null;
    }

    public static String l111l11111lIl(Context context) {
        if (l1111l111111Il(context, "com.huawei.hwid")) {
            return "com.huawei.hwid";
        }
        String str = "com.huawei.hms";
        if (!l1111l111111Il(context, "com.huawei.hms")) {
            str = "com.huawei.hwid.tv";
            if (!l1111l111111Il(context, "com.huawei.hwid.tv")) {
                return "com.huawei.hwid";
            }
        }
        return str;
    }

    @Override
    public String l1111l111111Il() {
        String string;
        try {
            String string2 = Settings.Global.getString(this.l111l11111lIl.getContentResolver(), "pps_oaid");
            if (!l1111l111111Il(string2)) {
                return string2;
            }
            Intent intent = new Intent("com.uodis.opendevice.OPENIDS_SERVICE");
            intent.setPackage(l111l11111lIl(this.l111l11111lIl));
            if (this.l111l11111lIl.bindService(intent, this.l111l11111Il, 1)) {
                try {
                    try {
                        IBinder iBinderPoll = this.l111l11111I1l.poll(3000L, TimeUnit.MILLISECONDS);
                        if (iBinderPoll == null) {
                            this.l111l11111lIl.unbindService(this.l111l11111Il);
                            return "";
                        }
                        Parcel parcelObtain = Parcel.obtain();
                        Parcel parcelObtain2 = Parcel.obtain();
                        try {
                            parcelObtain.writeInterfaceToken("com.uodis.opendevice.aidl.OpenDeviceIdentifierService");
                            iBinderPoll.transact(1, parcelObtain, parcelObtain2, 0);
                            parcelObtain2.readException();
                            string = parcelObtain2.readString();
                            parcelObtain.recycle();
                        } catch (Throwable th) {
                            try {
                                th.printStackTrace();
                                parcelObtain.recycle();
                                string = "";
                            } catch (Throwable th2) {
                                parcelObtain.recycle();
                                parcelObtain2.recycle();
                                throw th2;
                            }
                        }
                        parcelObtain2.recycle();
                        this.l111l11111lIl.unbindService(this.l111l11111Il);
                        return string;
                    } catch (Exception unused) {
                        this.l111l11111lIl.unbindService(this.l111l11111Il);
                    }
                } catch (Throwable th3) {
                    this.l111l11111lIl.unbindService(this.l111l11111Il);
                    throw th3;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }
}
