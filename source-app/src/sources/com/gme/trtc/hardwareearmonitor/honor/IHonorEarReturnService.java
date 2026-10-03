package com.gme.trtc.hardwareearmonitor.honor;

import android.os.Binder;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Parcel;
import android.os.RemoteException;

public interface IHonorEarReturnService extends IInterface {

    public static class Default implements IHonorEarReturnService {
        @Override
        public IBinder asBinder() {
            return null;
        }

        @Override
        public void destroy() throws RemoteException {
        }

        @Override
        public int enableEarReturn(boolean z) throws RemoteException {
            return 0;
        }

        @Override
        public int getEarReturnLatency() throws RemoteException {
            return 0;
        }

        @Override
        public void init(String str) throws RemoteException {
        }

        @Override
        public boolean isSupported(int i) throws RemoteException {
            return false;
        }

        @Override
        public int setParameter(String str, int i) throws RemoteException {
            return 0;
        }
    }

    void destroy() throws RemoteException;

    int enableEarReturn(boolean z) throws RemoteException;

    int getEarReturnLatency() throws RemoteException;

    void init(String str) throws RemoteException;

    boolean isSupported(int i) throws RemoteException;

    int setParameter(String str, int i) throws RemoteException;

    public static abstract class Stub extends Binder implements IHonorEarReturnService {
        private static final String DESCRIPTOR = "com.hihonor.android.magicx.media.audioengine.IHnEarReturnService";
        static final int TRANSACTION_destroy = 6;
        static final int TRANSACTION_enableEarReturn = 2;
        static final int TRANSACTION_getEarReturnLatency = 3;
        static final int TRANSACTION_init = 5;
        static final int TRANSACTION_isSupported = 1;
        static final int TRANSACTION_setParameter = 4;

        @Override
        public IBinder asBinder() {
            return this;
        }

        public Stub() {
            attachInterface(this, DESCRIPTOR);
        }

        public static IHonorEarReturnService asInterface(IBinder iBinder) {
            if (iBinder == null) {
                return null;
            }
            IInterface iInterfaceQueryLocalInterface = iBinder.queryLocalInterface(DESCRIPTOR);
            if (iInterfaceQueryLocalInterface != null && (iInterfaceQueryLocalInterface instanceof IHonorEarReturnService)) {
                return (IHonorEarReturnService) iInterfaceQueryLocalInterface;
            }
            return new Proxy(iBinder);
        }

        @Override
        public boolean onTransact(int i, Parcel parcel, Parcel parcel2, int i2) throws RemoteException {
            if (i != 1598968902) {
                switch (i) {
                    case 1:
                        parcel.enforceInterface(DESCRIPTOR);
                        boolean zIsSupported = isSupported(parcel.readInt());
                        parcel2.writeNoException();
                        parcel2.writeInt(zIsSupported ? 1 : 0);
                        return true;
                    case 2:
                        parcel.enforceInterface(DESCRIPTOR);
                        int iEnableEarReturn = enableEarReturn(parcel.readInt() != 0);
                        parcel2.writeNoException();
                        parcel2.writeInt(iEnableEarReturn);
                        return true;
                    case 3:
                        parcel.enforceInterface(DESCRIPTOR);
                        int earReturnLatency = getEarReturnLatency();
                        parcel2.writeNoException();
                        parcel2.writeInt(earReturnLatency);
                        return true;
                    case 4:
                        parcel.enforceInterface(DESCRIPTOR);
                        int parameter = setParameter(parcel.readString(), parcel.readInt());
                        parcel2.writeNoException();
                        parcel2.writeInt(parameter);
                        return true;
                    case 5:
                        parcel.enforceInterface(DESCRIPTOR);
                        init(parcel.readString());
                        parcel2.writeNoException();
                        return true;
                    case 6:
                        parcel.enforceInterface(DESCRIPTOR);
                        destroy();
                        parcel2.writeNoException();
                        return true;
                    default:
                        return super.onTransact(i, parcel, parcel2, i2);
                }
            }
            parcel2.writeString(DESCRIPTOR);
            return true;
        }

        public static class Proxy implements IHonorEarReturnService {
            public static IHonorEarReturnService sDefaultImpl;
            private IBinder mRemote;

            Proxy(IBinder iBinder) {
                this.mRemote = iBinder;
            }

            @Override
            public IBinder asBinder() {
                return this.mRemote;
            }

            public String getInterfaceDescriptor() {
                return Stub.DESCRIPTOR;
            }

            @Override
            public boolean isSupported(int i) throws RemoteException {
                Parcel parcelObtain = Parcel.obtain();
                Parcel parcelObtain2 = Parcel.obtain();
                try {
                    parcelObtain.writeInterfaceToken(Stub.DESCRIPTOR);
                    parcelObtain.writeInt(i);
                    if (!this.mRemote.transact(1, parcelObtain, parcelObtain2, 0) && Stub.getDefaultImpl() != null) {
                        boolean zIsSupported = Stub.getDefaultImpl().isSupported(i);
                        parcelObtain2.recycle();
                        parcelObtain.recycle();
                        return zIsSupported;
                    }
                    parcelObtain2.readException();
                    return parcelObtain2.readInt() != 0;
                } finally {
                    parcelObtain2.recycle();
                    parcelObtain.recycle();
                }
            }

            @Override
            public int enableEarReturn(boolean z) throws RemoteException {
                Parcel parcelObtain = Parcel.obtain();
                Parcel parcelObtain2 = Parcel.obtain();
                try {
                    parcelObtain.writeInterfaceToken(Stub.DESCRIPTOR);
                    parcelObtain.writeInt(z ? 1 : 0);
                    if (!this.mRemote.transact(2, parcelObtain, parcelObtain2, 0) && Stub.getDefaultImpl() != null) {
                        return Stub.getDefaultImpl().enableEarReturn(z);
                    }
                    parcelObtain2.readException();
                    return parcelObtain2.readInt();
                } finally {
                    parcelObtain2.recycle();
                    parcelObtain.recycle();
                }
            }

            @Override
            public int getEarReturnLatency() throws RemoteException {
                Parcel parcelObtain = Parcel.obtain();
                Parcel parcelObtain2 = Parcel.obtain();
                try {
                    parcelObtain.writeInterfaceToken(Stub.DESCRIPTOR);
                    if (!this.mRemote.transact(3, parcelObtain, parcelObtain2, 0) && Stub.getDefaultImpl() != null) {
                        return Stub.getDefaultImpl().getEarReturnLatency();
                    }
                    parcelObtain2.readException();
                    return parcelObtain2.readInt();
                } finally {
                    parcelObtain2.recycle();
                    parcelObtain.recycle();
                }
            }

            @Override
            public int setParameter(String str, int i) throws RemoteException {
                Parcel parcelObtain = Parcel.obtain();
                Parcel parcelObtain2 = Parcel.obtain();
                try {
                    parcelObtain.writeInterfaceToken(Stub.DESCRIPTOR);
                    parcelObtain.writeString(str);
                    parcelObtain.writeInt(i);
                    if (!this.mRemote.transact(4, parcelObtain, parcelObtain2, 0) && Stub.getDefaultImpl() != null) {
                        return Stub.getDefaultImpl().setParameter(str, i);
                    }
                    parcelObtain2.readException();
                    return parcelObtain2.readInt();
                } finally {
                    parcelObtain2.recycle();
                    parcelObtain.recycle();
                }
            }

            @Override
            public void init(String str) throws RemoteException {
                Parcel parcelObtain = Parcel.obtain();
                Parcel parcelObtain2 = Parcel.obtain();
                try {
                    parcelObtain.writeInterfaceToken(Stub.DESCRIPTOR);
                    parcelObtain.writeString(str);
                    if (!this.mRemote.transact(5, parcelObtain, parcelObtain2, 0) && Stub.getDefaultImpl() != null) {
                        Stub.getDefaultImpl().init(str);
                    } else {
                        parcelObtain2.readException();
                    }
                } finally {
                    parcelObtain2.recycle();
                    parcelObtain.recycle();
                }
            }

            @Override
            public void destroy() throws RemoteException {
                Parcel parcelObtain = Parcel.obtain();
                Parcel parcelObtain2 = Parcel.obtain();
                try {
                    parcelObtain.writeInterfaceToken(Stub.DESCRIPTOR);
                    if (!this.mRemote.transact(6, parcelObtain, parcelObtain2, 0) && Stub.getDefaultImpl() != null) {
                        Stub.getDefaultImpl().destroy();
                    } else {
                        parcelObtain2.readException();
                    }
                } finally {
                    parcelObtain2.recycle();
                    parcelObtain.recycle();
                }
            }
        }

        public static boolean setDefaultImpl(IHonorEarReturnService iHonorEarReturnService) {
            if (Proxy.sDefaultImpl != null) {
                throw new IllegalStateException("setDefaultImpl() called twice");
            }
            if (iHonorEarReturnService == null) {
                return false;
            }
            Proxy.sDefaultImpl = iHonorEarReturnService;
            return true;
        }

        public static IHonorEarReturnService getDefaultImpl() {
            return Proxy.sDefaultImpl;
        }
    }
}
