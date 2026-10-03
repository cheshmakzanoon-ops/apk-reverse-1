package com.ishumei.smantifraud;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.os.Parcel;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;

public class l1l1l1I1ll extends l1l11lI11l {
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
                l1l1l1I1ll.this.l111l11111I1l.offer(iBinder, 3000L, TimeUnit.MILLISECONDS);
            } catch (InterruptedException unused) {
            }
        }

        @Override
        public void onServiceDisconnected(ComponentName componentName) {
        }
    }

    public l1l1l1I1ll(Context context) {
        this.l111l11111lIl = context;
    }

    public static boolean l1111l111111Il(Context context) {
        try {
            Intent intent = new Intent();
            intent.setClassName("com.mdid.msa", "com.mdid.msa.service.MsaIdService");
            intent.setAction("com.bun.msa.action.bindto.service");
            intent.putExtra("com.bun.msa.param.pkgname", context.getPackageName());
            return context.bindService(intent, new l1111l111111Il(context), 1);
        } catch (Throwable unused) {
            return false;
        }
    }

    @Override
    public String l1111l111111Il() {
        Intent intent = new Intent();
        intent.setClassName("com.mdid.msa", "com.mdid.msa.service.MsaIdService");
        intent.setAction("com.bun.msa.action.bindto.service");
        intent.putExtra("com.bun.msa.param.pkgname", this.l111l11111lIl.getPackageName());
        if (this.l111l11111lIl.bindService(intent, this.l111l11111Il, 1)) {
            try {
                IBinder iBinderPoll = this.l111l11111I1l.poll(3000L, TimeUnit.MILLISECONDS);
                if (iBinderPoll == null) {
                    return "";
                }
                Parcel parcelObtain = Parcel.obtain();
                Parcel parcelObtain2 = Parcel.obtain();
                try {
                    parcelObtain.writeInterfaceToken("com.bun.lib.MsaIdInterface");
                    iBinderPoll.transact(3, parcelObtain, parcelObtain2, 0);
                    parcelObtain2.readException();
                    String string = parcelObtain2.readString();
                    parcelObtain.recycle();
                    parcelObtain2.recycle();
                    return string;
                } catch (Throwable unused) {
                    parcelObtain.recycle();
                    parcelObtain2.recycle();
                    this.l111l11111lIl.unbindService(this.l111l11111Il);
                }
            } catch (Exception unused2) {
            }
        }
        return "";
    }
}
