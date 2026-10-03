package com.appsflyer.internal;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Looper;
import android.os.Parcel;
import android.os.RemoteException;
import com.appsflyer.AFLogger;
import java.io.IOException;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

@Deprecated
final class AFb1ySDK {
    AFb1ySDK() {
    }

    static AFa1ySDK AFKeystoreWrapper(Context context) throws Exception {
        if (Looper.myLooper() == Looper.getMainLooper()) {
            throw new IllegalStateException("Cannot be called from the main thread");
        }
        context.getPackageManager().getPackageInfo("com.android.vending", 0);
        AFa1zSDK aFa1zSDK = new AFa1zSDK((byte) 0);
        Intent intent = new Intent("com.google.android.gms.ads.identifier.service.START");
        intent.setPackage("com.google.android.gms");
        try {
            if (!context.bindService(intent, aFa1zSDK, 1)) {
                if (context != null) {
                    context.unbindService(aFa1zSDK);
                }
                throw new IOException("Google Play connection failed");
            }
            if (aFa1zSDK.AFInAppEventType) {
                throw new IllegalStateException("Cannot call get on this connection more than once");
            }
            aFa1zSDK.AFInAppEventType = true;
            IBinder iBinderPoll = aFa1zSDK.valueOf.poll(10L, TimeUnit.SECONDS);
            if (iBinderPoll != null) {
                AFa1tSDK aFa1tSDK = new AFa1tSDK(iBinderPoll);
                AFa1ySDK aFa1ySDK = new AFa1ySDK(aFa1tSDK.AFKeystoreWrapper(), aFa1tSDK.valueOf());
                if (context != null) {
                    context.unbindService(aFa1zSDK);
                }
                return aFa1ySDK;
            }
            throw new TimeoutException("Timed out waiting for the service connection");
        } catch (Throwable th) {
            if (context != null) {
                context.unbindService(aFa1zSDK);
            }
            throw th;
        }
    }

    static final class AFa1ySDK {
        final String AFInAppEventParameterName;
        private final boolean AFInAppEventType;

        AFa1ySDK(String str, boolean z) {
            this.AFInAppEventParameterName = str;
            this.AFInAppEventType = z;
        }

        final boolean AFInAppEventType() {
            return this.AFInAppEventType;
        }
    }

    static final class AFa1zSDK implements ServiceConnection {
        boolean AFInAppEventType;
        final LinkedBlockingQueue<IBinder> valueOf;

        @Override
        public final void onServiceDisconnected(ComponentName componentName) {
        }

        private AFa1zSDK() {
            this.valueOf = new LinkedBlockingQueue<>(1);
            this.AFInAppEventType = false;
        }

        AFa1zSDK(byte b) {
            this();
        }

        @Override
        public final void onServiceConnected(ComponentName componentName, IBinder iBinder) {
            try {
                this.valueOf.put(iBinder);
            } catch (InterruptedException e) {
                AFLogger.afErrorLogForExcManagerOnly("onServiceConnected Interrupted", e);
            }
        }
    }

    static final class AFa1tSDK implements IInterface {
        private final IBinder AFInAppEventParameterName;

        AFa1tSDK(IBinder iBinder) {
            this.AFInAppEventParameterName = iBinder;
        }

        @Override
        public final IBinder asBinder() {
            return this.AFInAppEventParameterName;
        }

        public final String AFKeystoreWrapper() throws RemoteException {
            Parcel parcelObtain = Parcel.obtain();
            Parcel parcelObtain2 = Parcel.obtain();
            try {
                parcelObtain.writeInterfaceToken("com.google.android.gms.ads.identifier.internal.IAdvertisingIdService");
                this.AFInAppEventParameterName.transact(1, parcelObtain, parcelObtain2, 0);
                parcelObtain2.readException();
                return parcelObtain2.readString();
            } finally {
                parcelObtain2.recycle();
                parcelObtain.recycle();
            }
        }

        final boolean valueOf() throws RemoteException {
            Parcel parcelObtain = Parcel.obtain();
            Parcel parcelObtain2 = Parcel.obtain();
            try {
                parcelObtain.writeInterfaceToken("com.google.android.gms.ads.identifier.internal.IAdvertisingIdService");
                parcelObtain.writeInt(1);
                this.AFInAppEventParameterName.transact(2, parcelObtain, parcelObtain2, 0);
                parcelObtain2.readException();
                return parcelObtain2.readInt() != 0;
            } finally {
                parcelObtain2.recycle();
                parcelObtain.recycle();
            }
        }
    }
}
