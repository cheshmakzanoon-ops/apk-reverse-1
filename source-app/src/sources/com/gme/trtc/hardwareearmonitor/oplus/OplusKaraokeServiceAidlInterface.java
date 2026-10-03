package com.gme.trtc.hardwareearmonitor.oplus;

import android.os.Binder;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Parcel;
import android.os.RemoteException;
import com.gme.liteav.base.util.LiteavLog;

public interface OplusKaraokeServiceAidlInterface extends IInterface {

    public static class Default implements OplusKaraokeServiceAidlInterface {
        @Override
        public IBinder asBinder() {
            return null;
        }

        @Override
        public void setActiveClient(String str) throws RemoteException {
        }

        @Override
        public void setHeadsetState(boolean z) throws RemoteException {
        }

        @Override
        public void setPermitBits(int i, int i2, int i3, String str) throws RemoteException {
        }
    }

    void setActiveClient(String str) throws RemoteException;

    void setHeadsetState(boolean z) throws RemoteException;

    void setPermitBits(int i, int i2, int i3, String str) throws RemoteException;

    public static abstract class Stub extends Binder implements OplusKaraokeServiceAidlInterface {
        private static String DESCRIPTOR = "OplusKaraokeServiceAidlInterface";
        static final int TRANSACTION_setActiveClient = 2;
        static final int TRANSACTION_setHeadsetState = 1;
        static final int TRANSACTION_setPermitBits = 3;

        @Override
        public IBinder asBinder() {
            return this;
        }

        public static void setDESCRIPTOR(String str) {
            DESCRIPTOR = str;
        }

        public Stub() {
            attachInterface(this, DESCRIPTOR);
        }

        public static OplusKaraokeServiceAidlInterface asInterface(IBinder iBinder) {
            if (iBinder == null) {
                return null;
            }
            IInterface iInterfaceQueryLocalInterface = iBinder.queryLocalInterface(DESCRIPTOR);
            if (iInterfaceQueryLocalInterface != null && (iInterfaceQueryLocalInterface instanceof OplusKaraokeServiceAidlInterface)) {
                return (OplusKaraokeServiceAidlInterface) iInterfaceQueryLocalInterface;
            }
            return new C1092a(iBinder);
        }

        @Override
        public boolean onTransact(int i, Parcel parcel, Parcel parcel2, int i2) throws RemoteException {
            String str = DESCRIPTOR;
            if (i == 1) {
                parcel.enforceInterface(str);
                setHeadsetState(parcel.readInt() != 0);
                parcel2.writeNoException();
                return true;
            }
            if (i == 2) {
                parcel.enforceInterface(str);
                setActiveClient(parcel.readString());
                parcel2.writeNoException();
                return true;
            }
            if (i != 3) {
                if (i == 1598968902) {
                    parcel2.writeString(str);
                    return true;
                }
                return super.onTransact(i, parcel, parcel2, i2);
            }
            parcel.enforceInterface(str);
            setPermitBits(parcel.readInt(), parcel.readInt(), parcel.readInt(), parcel.readString());
            parcel2.writeNoException();
            return true;
        }

        static class C1092a implements OplusKaraokeServiceAidlInterface {

            public static OplusKaraokeServiceAidlInterface f846a;

            private IBinder f847b;

            C1092a(IBinder iBinder) {
                this.f847b = iBinder;
            }

            @Override
            public final IBinder asBinder() {
                return this.f847b;
            }

            @Override
            public final void setHeadsetState(boolean z) throws RemoteException {
                Parcel parcelObtain = Parcel.obtain();
                Parcel parcelObtain2 = Parcel.obtain();
                try {
                    parcelObtain.writeInterfaceToken(Stub.DESCRIPTOR);
                    parcelObtain.writeInt(z ? 1 : 0);
                    boolean zTransact = this.f847b.transact(1, parcelObtain, parcelObtain2, 0);
                    if (!zTransact) {
                        LiteavLog.m994e("setHeadsetState", "setHeadsetState error");
                    }
                    if (!zTransact && Stub.getDefaultImpl() != null) {
                        Stub.getDefaultImpl().setHeadsetState(z);
                    } else {
                        parcelObtain2.readException();
                    }
                } finally {
                    parcelObtain2.recycle();
                    parcelObtain.recycle();
                }
            }

            @Override
            public final void setActiveClient(String str) throws RemoteException {
                Parcel parcelObtain = Parcel.obtain();
                Parcel parcelObtain2 = Parcel.obtain();
                try {
                    parcelObtain.writeInterfaceToken(Stub.DESCRIPTOR);
                    parcelObtain.writeString(str);
                    boolean zTransact = this.f847b.transact(2, parcelObtain, parcelObtain2, 0);
                    if (!zTransact) {
                        LiteavLog.m994e("setActiveClient", "setActiveClient error");
                    }
                    if (!zTransact && Stub.getDefaultImpl() != null) {
                        Stub.getDefaultImpl().setActiveClient(str);
                    } else {
                        parcelObtain2.readException();
                    }
                } finally {
                    parcelObtain2.recycle();
                    parcelObtain.recycle();
                }
            }

            @Override
            public final void setPermitBits(int i, int i2, int i3, String str) throws RemoteException {
                Parcel parcelObtain = Parcel.obtain();
                Parcel parcelObtain2 = Parcel.obtain();
                try {
                    parcelObtain.writeInterfaceToken(Stub.DESCRIPTOR);
                    parcelObtain.writeInt(i);
                    parcelObtain.writeInt(i2);
                    parcelObtain.writeInt(i3);
                    parcelObtain.writeString(str);
                    if (!this.f847b.transact(3, parcelObtain, parcelObtain2, 0) && Stub.getDefaultImpl() != null) {
                        Stub.getDefaultImpl().setPermitBits(i, i2, i3, str);
                    } else {
                        parcelObtain2.readException();
                    }
                } finally {
                    parcelObtain2.recycle();
                    parcelObtain.recycle();
                }
            }
        }

        public static boolean setDefaultImpl(OplusKaraokeServiceAidlInterface oplusKaraokeServiceAidlInterface) {
            if (C1092a.f846a != null) {
                throw new IllegalStateException("setDefaultImpl() called twice");
            }
            if (oplusKaraokeServiceAidlInterface == null) {
                return false;
            }
            C1092a.f846a = oplusKaraokeServiceAidlInterface;
            return true;
        }

        public static OplusKaraokeServiceAidlInterface getDefaultImpl() {
            return C1092a.f846a;
        }
    }
}
