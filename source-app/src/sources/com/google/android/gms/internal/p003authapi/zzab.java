package com.google.android.gms.internal.p003authapi;

import android.os.IInterface;
import android.os.RemoteException;
import com.google.android.gms.auth.api.identity.BeginSignInResult;
import com.google.android.gms.common.api.Status;

public interface zzab extends IInterface {
    void zzc(Status status, BeginSignInResult beginSignInResult) throws RemoteException;
}
