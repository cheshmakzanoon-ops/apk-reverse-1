package com.ishumei.smantifraud;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.content.pm.Signature;
import android.os.IBinder;
import android.os.Parcel;
import com.google.common.primitives.UnsignedBytes;
import java.security.MessageDigest;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;

public class l1l11lI11Il extends l1l11lI11l {
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
                l1l11lI11Il.this.l111l11111I1l.offer(iBinder, 3000L, TimeUnit.MILLISECONDS);
            } catch (Throwable unused) {
            }
        }

        @Override
        public void onServiceDisconnected(ComponentName componentName) {
        }
    }

    public l1l11lI11Il(Context context) {
        this.l111l11111lIl = context;
    }

    public static boolean l1111l111111Il(Context context) {
        try {
            Intent intent = new Intent();
            intent.setComponent(new ComponentName("com.heytap.openid", "com.heytap.openid.IdentifyService"));
            intent.setAction("action.com.heytap.openid.OPEN_ID_SERVICE");
            return context.bindService(intent, new l1111l111111Il(context), 1);
        } catch (Throwable unused) {
            return false;
        }
    }

    @Override
    public String l1111l111111Il() {
        Intent intent = new Intent();
        intent.setComponent(new ComponentName("com.heytap.openid", "com.heytap.openid.IdentifyService"));
        intent.setAction("action.com.heytap.openid.OPEN_ID_SERVICE");
        String strL1111l111111Il = "";
        if (!this.l111l11111lIl.bindService(intent, this.l111l11111Il, 1)) {
            return "";
        }
        try {
            strL1111l111111Il = l1111l111111Il(this.l111l11111I1l.poll(3000L, TimeUnit.MILLISECONDS));
            this.l111l11111lIl.unbindService(this.l111l11111Il);
            return strL1111l111111Il;
        } catch (Throwable unused) {
            return strL1111l111111Il;
        }
    }

    public final String l1111l111111Il(Context context, String str) {
        try {
            Signature[] signatureArr = context.getPackageManager().getPackageInfo(str, 64).signatures;
            if (signatureArr == null || signatureArr.length <= 0) {
                return "";
            }
            byte[] bArrDigest = MessageDigest.getInstance("SHA1").digest(signatureArr[0].toByteArray());
            StringBuilder sb = new StringBuilder();
            for (byte b : bArrDigest) {
                sb.append(Integer.toHexString((b & UnsignedBytes.MAX_VALUE) | l1l11lI1l.l111l11111lIl).substring(1, 3));
            }
            return sb.toString();
        } catch (Exception unused) {
            return "";
        }
    }

    public final String l1111l111111Il(IBinder iBinder) {
        String string = "";
        if (iBinder == null) {
            return "";
        }
        String packageName = this.l111l11111lIl.getPackageName();
        String strL1111l111111Il = l1111l111111Il(this.l111l11111lIl, packageName);
        try {
            Parcel parcelObtain = Parcel.obtain();
            Parcel parcelObtain2 = Parcel.obtain();
            try {
                parcelObtain.writeInterfaceToken("com.heytap.openid.IOpenID");
                parcelObtain.writeString(packageName);
                parcelObtain.writeString(strL1111l111111Il);
                parcelObtain.writeString("OUID");
                iBinder.transact(1, parcelObtain, parcelObtain2, 0);
                parcelObtain2.readException();
                string = parcelObtain2.readString();
            } finally {
                parcelObtain.recycle();
                parcelObtain2.recycle();
            }
        } catch (Exception unused) {
        }
        return string;
    }
}
