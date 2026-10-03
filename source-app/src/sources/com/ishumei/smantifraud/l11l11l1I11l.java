package com.ishumei.smantifraud;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.os.Parcel;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;

public class l11l11l1I11l extends l1l11lI11l {
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
                l11l11l1I11l.this.l111l11111I1l.offer(iBinder, 3000L, TimeUnit.MILLISECONDS);
            } catch (InterruptedException unused) {
            }
        }

        @Override
        public void onServiceDisconnected(ComponentName componentName) {
        }
    }

    public l11l11l1I11l(Context context) {
        this.l111l11111lIl = context;
    }

    public static boolean l1111l111111Il(Context context) {
        try {
            Intent intent = new Intent();
            intent.setClassName("com.zui.deviceidservice", "com.zui.deviceidservice.DeviceidService");
            return context.bindService(intent, new l1111l111111Il(context), 1);
        } catch (Throwable unused) {
            return false;
        }
    }

    @Override
    public String l1111l111111Il() {
        Intent intent = new Intent();
        intent.setClassName("com.zui.deviceidservice", "com.zui.deviceidservice.DeviceidService");
        String string = "";
        if (this.l111l11111lIl.bindService(intent, this.l111l11111Il, 1)) {
            Parcel parcelObtain = Parcel.obtain();
            Parcel parcelObtain2 = Parcel.obtain();
            try {
                IBinder iBinderPoll = this.l111l11111I1l.poll(3000L, TimeUnit.MILLISECONDS);
                if (iBinderPoll == null) {
                    return "";
                }
                parcelObtain.writeInterfaceToken("com.zui.deviceidservice.IDeviceidInterface");
                iBinderPoll.transact(1, parcelObtain, parcelObtain2, 0);
                parcelObtain2.readException();
                string = parcelObtain2.readString();
            } catch (Exception unused) {
            } finally {
                parcelObtain2.recycle();
                parcelObtain.recycle();
                this.l111l11111lIl.unbindService(this.l111l11111Il);
            }
        }
        return string;
    }
}
