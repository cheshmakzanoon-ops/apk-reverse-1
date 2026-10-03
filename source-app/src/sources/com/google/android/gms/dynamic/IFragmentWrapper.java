package com.google.android.gms.dynamic;

import android.content.Intent;
import android.os.Bundle;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Parcel;
import android.os.RemoteException;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.CommonStatusCodes;
import com.google.android.gms.internal.common.zzc;

public interface IFragmentWrapper extends IInterface {

    public static abstract class Stub extends com.google.android.gms.internal.common.zzb implements IFragmentWrapper {
        public Stub() {
            super("com.google.android.gms.dynamic.IFragmentWrapper");
        }

        public static IFragmentWrapper asInterface(IBinder iBinder) {
            if (iBinder == null) {
                return null;
            }
            IInterface iInterfaceQueryLocalInterface = iBinder.queryLocalInterface("com.google.android.gms.dynamic.IFragmentWrapper");
            return iInterfaceQueryLocalInterface instanceof IFragmentWrapper ? (IFragmentWrapper) iInterfaceQueryLocalInterface : new zza(iBinder);
        }

        @Override
        protected final boolean zza(int i, Parcel parcel, Parcel parcel2, int i2) throws RemoteException {
            switch (i) {
                case 2:
                    IObjectWrapper iObjectWrapperZzb = zzb();
                    parcel2.writeNoException();
                    zzc.zze(parcel2, iObjectWrapperZzb);
                    return true;
                case 3:
                    Bundle bundleZzc = zzc();
                    parcel2.writeNoException();
                    zzc.zzd(parcel2, bundleZzc);
                    return true;
                case 4:
                    int iZzd = zzd();
                    parcel2.writeNoException();
                    parcel2.writeInt(iZzd);
                    return true;
                case 5:
                    IFragmentWrapper iFragmentWrapperZze = zze();
                    parcel2.writeNoException();
                    zzc.zze(parcel2, iFragmentWrapperZze);
                    return true;
                case 6:
                    IObjectWrapper iObjectWrapperZzf = zzf();
                    parcel2.writeNoException();
                    zzc.zze(parcel2, iObjectWrapperZzf);
                    return true;
                case 7:
                    boolean zZzg = zzg();
                    parcel2.writeNoException();
                    int i3 = zzc.zza;
                    parcel2.writeInt(zZzg ? 1 : 0);
                    return true;
                case 8:
                    String strZzh = zzh();
                    parcel2.writeNoException();
                    parcel2.writeString(strZzh);
                    return true;
                case 9:
                    IFragmentWrapper iFragmentWrapperZzi = zzi();
                    parcel2.writeNoException();
                    zzc.zze(parcel2, iFragmentWrapperZzi);
                    return true;
                case 10:
                    int iZzj = zzj();
                    parcel2.writeNoException();
                    parcel2.writeInt(iZzj);
                    return true;
                case 11:
                    boolean zZzk = zzk();
                    parcel2.writeNoException();
                    int i4 = zzc.zza;
                    parcel2.writeInt(zZzk ? 1 : 0);
                    return true;
                case 12:
                    IObjectWrapper iObjectWrapperZzl = zzl();
                    parcel2.writeNoException();
                    zzc.zze(parcel2, iObjectWrapperZzl);
                    return true;
                case 13:
                    boolean zZzm = zzm();
                    parcel2.writeNoException();
                    int i5 = zzc.zza;
                    parcel2.writeInt(zZzm ? 1 : 0);
                    return true;
                case 14:
                    boolean zZzn = zzn();
                    parcel2.writeNoException();
                    int i6 = zzc.zza;
                    parcel2.writeInt(zZzn ? 1 : 0);
                    return true;
                case 15:
                    boolean zZzo = zzo();
                    parcel2.writeNoException();
                    int i7 = zzc.zza;
                    parcel2.writeInt(zZzo ? 1 : 0);
                    return true;
                case 16:
                    boolean zZzp = zzp();
                    parcel2.writeNoException();
                    int i8 = zzc.zza;
                    parcel2.writeInt(zZzp ? 1 : 0);
                    return true;
                case 17:
                    boolean zZzq = zzq();
                    parcel2.writeNoException();
                    int i9 = zzc.zza;
                    parcel2.writeInt(zZzq ? 1 : 0);
                    return true;
                case 18:
                    boolean zZzr = zzr();
                    parcel2.writeNoException();
                    int i10 = zzc.zza;
                    parcel2.writeInt(zZzr ? 1 : 0);
                    return true;
                case 19:
                    boolean zZzs = zzs();
                    parcel2.writeNoException();
                    int i11 = zzc.zza;
                    parcel2.writeInt(zZzs ? 1 : 0);
                    return true;
                case 20:
                    IObjectWrapper iObjectWrapperAsInterface = IObjectWrapper.Stub.asInterface(parcel.readStrongBinder());
                    zzc.zzf(parcel);
                    zzt(iObjectWrapperAsInterface);
                    parcel2.writeNoException();
                    return true;
                case CommonStatusCodes.RECONNECTION_TIMED_OUT_DURING_UPDATE:
                    boolean zZza = zzc.zza(parcel);
                    zzc.zzf(parcel);
                    zzu(zZza);
                    parcel2.writeNoException();
                    return true;
                case 22:
                    boolean zZza2 = zzc.zza(parcel);
                    zzc.zzf(parcel);
                    zzv(zZza2);
                    parcel2.writeNoException();
                    return true;
                case ConnectionResult.API_DISABLED:
                    boolean zZza3 = zzc.zza(parcel);
                    zzc.zzf(parcel);
                    zzw(zZza3);
                    parcel2.writeNoException();
                    return true;
                case ConnectionResult.API_DISABLED_FOR_CONNECTION:
                    boolean zZza4 = zzc.zza(parcel);
                    zzc.zzf(parcel);
                    zzx(zZza4);
                    parcel2.writeNoException();
                    return true;
                case 25:
                    Intent intent = (Intent) zzc.zzb(parcel, Intent.CREATOR);
                    zzc.zzf(parcel);
                    zzy(intent);
                    parcel2.writeNoException();
                    return true;
                case 26:
                    Intent intent2 = (Intent) zzc.zzb(parcel, Intent.CREATOR);
                    int i12 = parcel.readInt();
                    zzc.zzf(parcel);
                    zzz(intent2, i12);
                    parcel2.writeNoException();
                    return true;
                case 27:
                    IObjectWrapper iObjectWrapperAsInterface2 = IObjectWrapper.Stub.asInterface(parcel.readStrongBinder());
                    zzc.zzf(parcel);
                    zzA(iObjectWrapperAsInterface2);
                    parcel2.writeNoException();
                    return true;
                default:
                    return false;
            }
        }
    }

    void zzA(IObjectWrapper iObjectWrapper) throws RemoteException;

    IObjectWrapper zzb() throws RemoteException;

    Bundle zzc() throws RemoteException;

    int zzd() throws RemoteException;

    IFragmentWrapper zze() throws RemoteException;

    IObjectWrapper zzf() throws RemoteException;

    boolean zzg() throws RemoteException;

    String zzh() throws RemoteException;

    IFragmentWrapper zzi() throws RemoteException;

    int zzj() throws RemoteException;

    boolean zzk() throws RemoteException;

    IObjectWrapper zzl() throws RemoteException;

    boolean zzm() throws RemoteException;

    boolean zzn() throws RemoteException;

    boolean zzo() throws RemoteException;

    boolean zzp() throws RemoteException;

    boolean zzq() throws RemoteException;

    boolean zzr() throws RemoteException;

    boolean zzs() throws RemoteException;

    void zzt(IObjectWrapper iObjectWrapper) throws RemoteException;

    void zzu(boolean z) throws RemoteException;

    void zzv(boolean z) throws RemoteException;

    void zzw(boolean z) throws RemoteException;

    void zzx(boolean z) throws RemoteException;

    void zzy(Intent intent) throws RemoteException;

    void zzz(Intent intent, int i) throws RemoteException;
}
