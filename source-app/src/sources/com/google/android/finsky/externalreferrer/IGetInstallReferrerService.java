package com.google.android.finsky.externalreferrer;

import android.os.Bundle;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Parcel;
import android.os.RemoteException;
import com.google.android.a.a;
import com.google.android.a.b;
import com.google.android.a.c;

public interface IGetInstallReferrerService extends IInterface {

    public static abstract class Stub extends b implements IGetInstallReferrerService {

        public static class Proxy extends a implements IGetInstallReferrerService {
            Proxy(IBinder iBinder) {
                super(iBinder);
            }

            @Override
            public final Bundle mo1094c(Bundle bundle) throws RemoteException {
                Parcel parcelA = a();
                c.b(parcelA, bundle);
                Parcel parcelB = b(parcelA);
                Bundle bundle2 = (Bundle) c.a(parcelB, Bundle.CREATOR);
                parcelB.recycle();
                return bundle2;
            }
        }

        public static IGetInstallReferrerService m1095b(IBinder iBinder) {
            if (iBinder == null) {
                return null;
            }
            IInterface iInterfaceQueryLocalInterface = iBinder.queryLocalInterface("com.google.android.finsky.externalreferrer.IGetInstallReferrerService");
            return iInterfaceQueryLocalInterface instanceof IGetInstallReferrerService ? (IGetInstallReferrerService) iInterfaceQueryLocalInterface : new Proxy(iBinder);
        }

        protected final boolean m1096a(int i, Parcel parcel, Parcel parcel2) throws RemoteException {
            if (i != 1) {
                return false;
            }
            Bundle bundleC = mo1094c((Bundle) c.a(parcel, Bundle.CREATOR));
            parcel2.writeNoException();
            c.c(parcel2, bundleC);
            return true;
        }
    }

    Bundle mo1094c(Bundle bundle) throws RemoteException;
}
