package com.google.android.gms.games.internal;

import android.os.IInterface;
import android.os.RemoteException;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.common.data.DataHolder;
import com.google.android.gms.drive.Contents;
import java.util.List;

public interface zzaj extends IInterface {
    void zzb(DataHolder dataHolder) throws RemoteException;

    void zzc(DataHolder dataHolder) throws RemoteException;

    void zzd(int i, String str) throws RemoteException;

    void zze(DataHolder dataHolder) throws RemoteException;

    void zzf(DataHolder dataHolder, DataHolder dataHolder2) throws RemoteException;

    void zzg(DataHolder dataHolder) throws RemoteException;

    void zzh(DataHolder dataHolder) throws RemoteException;

    void zzi(DataHolder dataHolder) throws RemoteException;

    void zzj() throws RemoteException;

    void zzk(DataHolder dataHolder) throws RemoteException;

    void zzl(DataHolder dataHolder) throws RemoteException;

    void zzm(DataHolder dataHolder, Contents contents) throws RemoteException;

    void zzn(DataHolder dataHolder, String str, Contents contents, Contents contents2, Contents contents3) throws RemoteException;

    void zzo(DataHolder dataHolder) throws RemoteException;

    void zzp(int i, String str) throws RemoteException;

    void zzq(DataHolder dataHolder) throws RemoteException;

    void zzr(Status status, String str) throws RemoteException;

    void zzs(Status status, String str, List list) throws RemoteException;
}
