package com.google.android.gms.common.internal;

import android.accounts.Account;
import android.os.IBinder;
import android.os.Parcel;
import android.os.RemoteException;

public final class zzt extends com.google.android.gms.internal.common.zza implements IAccountAccessor {
    zzt(IBinder iBinder) {
        super(iBinder, "com.google.android.gms.common.internal.IAccountAccessor");
    }

    @Override
    public final Account zzb() throws RemoteException {
        Parcel parcelZzB = zzB(2, zza());
        Account account = (Account) com.google.android.gms.internal.common.zzc.zzb(parcelZzB, Account.CREATOR);
        parcelZzB.recycle();
        return account;
    }
}
