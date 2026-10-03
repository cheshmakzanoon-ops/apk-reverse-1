package com.google.android.gms.games.internal;

import android.app.PendingIntent;
import android.content.Intent;
import android.os.Bundle;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Parcel;
import android.os.RemoteException;
import com.google.android.gms.common.data.DataHolder;
import com.google.android.gms.drive.Contents;
import com.google.android.gms.games.PlayerEntity;
import com.google.android.gms.games.snapshot.SnapshotMetadataChangeEntity;
import java.util.List;

public final class zzam extends com.google.android.gms.internal.games_v2.zza implements IInterface {
    zzam(IBinder iBinder) {
        super(iBinder, "com.google.android.gms.games.internal.IGamesService");
    }

    public final void zzA(zzaj zzajVar, boolean z) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzd(parcelZza, zzajVar);
        parcelZza.writeInt(z ? 1 : 0);
        zzc(12002, parcelZza);
    }

    public final void zzB(zzaj zzajVar, String str, SnapshotMetadataChangeEntity snapshotMetadataChangeEntity, Contents contents) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzd(parcelZza, zzajVar);
        parcelZza.writeString(str);
        com.google.android.gms.internal.games_v2.zzc.zzc(parcelZza, snapshotMetadataChangeEntity);
        com.google.android.gms.internal.games_v2.zzc.zzc(parcelZza, contents);
        zzc(12007, parcelZza);
    }

    public final void zzC(Contents contents) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzc(parcelZza, contents);
        zzc(12019, parcelZza);
    }

    public final void zzD(zzaj zzajVar, String str) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzd(parcelZza, zzajVar);
        parcelZza.writeString(str);
        zzc(12020, parcelZza);
    }

    public final void zzE(zzaj zzajVar, String str, String str2, SnapshotMetadataChangeEntity snapshotMetadataChangeEntity, Contents contents) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzd(parcelZza, zzajVar);
        parcelZza.writeString(str);
        parcelZza.writeString(str2);
        com.google.android.gms.internal.games_v2.zzc.zzc(parcelZza, snapshotMetadataChangeEntity);
        com.google.android.gms.internal.games_v2.zzc.zzc(parcelZza, contents);
        zzc(12033, parcelZza);
    }

    public final int zzF() throws RemoteException {
        Parcel parcelZzb = zzb(12035, zza());
        int i = parcelZzb.readInt();
        parcelZzb.recycle();
        return i;
    }

    public final int zzG() throws RemoteException {
        Parcel parcelZzb = zzb(12036, zza());
        int i = parcelZzb.readInt();
        parcelZzb.recycle();
        return i;
    }

    public final void zzH(zzaj zzajVar, boolean z) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzd(parcelZza, zzajVar);
        parcelZza.writeInt(z ? 1 : 0);
        zzc(12016, parcelZza);
    }

    public final void zzI(zzaj zzajVar, boolean z, String[] strArr) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzd(parcelZza, zzajVar);
        parcelZza.writeInt(z ? 1 : 0);
        parcelZza.writeStringArray(strArr);
        zzc(12031, parcelZza);
    }

    public final void zzJ(String str, int i) throws RemoteException {
        Parcel parcelZza = zza();
        parcelZza.writeString(str);
        parcelZza.writeInt(i);
        zzc(12017, parcelZza);
    }

    public final void zzK(zzaj zzajVar, String str, boolean z) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzd(parcelZza, zzajVar);
        parcelZza.writeString(str);
        parcelZza.writeInt(z ? 1 : 0);
        zzc(13006, parcelZza);
    }

    public final void zzL(zzaj zzajVar, String str, boolean z, int i) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzd(parcelZza, zzajVar);
        parcelZza.writeString(str);
        parcelZza.writeInt(z ? 1 : 0);
        parcelZza.writeInt(i);
        zzc(15001, parcelZza);
    }

    public final void zzM(zzal zzalVar, long j) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzd(parcelZza, zzalVar);
        parcelZza.writeLong(j);
        zzc(15501, parcelZza);
    }

    public final Intent zzN(PlayerEntity playerEntity) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzc(parcelZza, playerEntity);
        Parcel parcelZzb = zzb(15503, parcelZza);
        Intent intent = (Intent) com.google.android.gms.internal.games_v2.zzc.zzb(parcelZzb, Intent.CREATOR);
        parcelZzb.recycle();
        return intent;
    }

    public final void zzO(zzaj zzajVar, boolean z) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzd(parcelZza, zzajVar);
        parcelZza.writeInt(z ? 1 : 0);
        zzc(17001, parcelZza);
    }

    public final Intent zzP(String str, int i, int i2) throws RemoteException {
        Parcel parcelZza = zza();
        parcelZza.writeString(str);
        parcelZza.writeInt(i);
        parcelZza.writeInt(i2);
        Parcel parcelZzb = zzb(18001, parcelZza);
        Intent intent = (Intent) com.google.android.gms.internal.games_v2.zzc.zzb(parcelZzb, Intent.CREATOR);
        parcelZzb.recycle();
        return intent;
    }

    public final PendingIntent zzQ() throws RemoteException {
        Parcel parcelZzb = zzb(25015, zza());
        PendingIntent pendingIntent = (PendingIntent) com.google.android.gms.internal.games_v2.zzc.zzb(parcelZzb, PendingIntent.CREATOR);
        parcelZzb.recycle();
        return pendingIntent;
    }

    public final Intent zzR(String str, String str2, String str3) throws RemoteException {
        Parcel parcelZza = zza();
        parcelZza.writeString(str);
        parcelZza.writeString(str2);
        parcelZza.writeString(str3);
        Parcel parcelZzb = zzb(25016, parcelZza);
        Intent intent = (Intent) com.google.android.gms.internal.games_v2.zzc.zzb(parcelZzb, Intent.CREATOR);
        parcelZzb.recycle();
        return intent;
    }

    public final void zzS(zzaj zzajVar, String str, boolean z) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzd(parcelZza, zzajVar);
        parcelZza.writeString(str);
        parcelZza.writeInt(z ? 1 : 0);
        zzc(27003, parcelZza);
    }

    public final void zzT(zzaj zzajVar, String str, boolean z, List list) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzd(parcelZza, zzajVar);
        parcelZza.writeString(str);
        parcelZza.writeInt(z ? 1 : 0);
        parcelZza.writeStringList(list);
        zzc(27012, parcelZza);
    }

    public final void zzd(long j) throws RemoteException {
        Parcel parcelZza = zza();
        parcelZza.writeLong(j);
        zzc(5001, parcelZza);
    }

    public final void zze(zzaj zzajVar) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzd(parcelZza, zzajVar);
        zzc(5002, parcelZza);
    }

    public final void zzf(IBinder iBinder, Bundle bundle) throws RemoteException {
        Parcel parcelZza = zza();
        parcelZza.writeStrongBinder(iBinder);
        com.google.android.gms.internal.games_v2.zzc.zzc(parcelZza, bundle);
        zzc(5005, parcelZza);
    }

    public final void zzg() throws RemoteException {
        zzc(5006, zza());
    }

    public final String zzh() throws RemoteException {
        Parcel parcelZzb = zzb(5012, zza());
        String string = parcelZzb.readString();
        parcelZzb.recycle();
        return string;
    }

    public final DataHolder zzi() throws RemoteException {
        Parcel parcelZzb = zzb(5013, zza());
        DataHolder dataHolder = (DataHolder) com.google.android.gms.internal.games_v2.zzc.zzb(parcelZzb, DataHolder.CREATOR);
        parcelZzb.recycle();
        return dataHolder;
    }

    public final void zzj(zzaj zzajVar, String str, int i, int i2, int i3, boolean z) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzd(parcelZza, zzajVar);
        parcelZza.writeString(str);
        parcelZza.writeInt(i);
        parcelZza.writeInt(i2);
        parcelZza.writeInt(i3);
        parcelZza.writeInt(z ? 1 : 0);
        zzc(5019, parcelZza);
    }

    public final void zzk(zzaj zzajVar, String str, int i, int i2, int i3, boolean z) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzd(parcelZza, zzajVar);
        parcelZza.writeString(str);
        parcelZza.writeInt(i);
        parcelZza.writeInt(i2);
        parcelZza.writeInt(i3);
        parcelZza.writeInt(z ? 1 : 0);
        zzc(5020, parcelZza);
    }

    public final void zzl(zzaj zzajVar, Bundle bundle, int i, int i2) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzd(parcelZza, zzajVar);
        com.google.android.gms.internal.games_v2.zzc.zzc(parcelZza, bundle);
        parcelZza.writeInt(i);
        parcelZza.writeInt(i2);
        zzc(5021, parcelZza);
    }

    public final void zzm(zzaj zzajVar, String str, IBinder iBinder, Bundle bundle) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzd(parcelZza, zzajVar);
        parcelZza.writeString(str);
        parcelZza.writeStrongBinder(iBinder);
        com.google.android.gms.internal.games_v2.zzc.zzc(parcelZza, bundle);
        zzc(5023, parcelZza);
    }

    public final void zzn(zzaj zzajVar, String str, IBinder iBinder, Bundle bundle) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzd(parcelZza, zzajVar);
        parcelZza.writeString(str);
        parcelZza.writeStrongBinder(iBinder);
        com.google.android.gms.internal.games_v2.zzc.zzc(parcelZza, bundle);
        zzc(5024, parcelZza);
    }

    public final void zzo(zzaj zzajVar, String str, int i, IBinder iBinder, Bundle bundle) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzd(parcelZza, zzajVar);
        parcelZza.writeString(str);
        parcelZza.writeInt(i);
        parcelZza.writeStrongBinder(iBinder);
        com.google.android.gms.internal.games_v2.zzc.zzc(parcelZza, bundle);
        zzc(5025, parcelZza);
    }

    public final void zzp(zzaj zzajVar, boolean z) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzd(parcelZza, zzajVar);
        parcelZza.writeInt(z ? 1 : 0);
        zzc(6001, parcelZza);
    }

    public final void zzq(zzaj zzajVar, boolean z) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzd(parcelZza, zzajVar);
        parcelZza.writeInt(z ? 1 : 0);
        zzc(6503, parcelZza);
    }

    public final void zzr(zzaj zzajVar, String str, boolean z) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzd(parcelZza, zzajVar);
        parcelZza.writeString(str);
        parcelZza.writeInt(z ? 1 : 0);
        zzc(6504, parcelZza);
    }

    public final void zzs(zzaj zzajVar, String str, long j, String str2) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzd(parcelZza, zzajVar);
        parcelZza.writeString(str);
        parcelZza.writeLong(j);
        parcelZza.writeString(str2);
        zzc(7002, parcelZza);
    }

    public final void zzt(zzaj zzajVar, String str, int i, IBinder iBinder, Bundle bundle) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzd(parcelZza, zzajVar);
        parcelZza.writeString(str);
        parcelZza.writeInt(i);
        parcelZza.writeStrongBinder(iBinder);
        com.google.android.gms.internal.games_v2.zzc.zzc(parcelZza, bundle);
        zzc(7003, parcelZza);
    }

    public final void zzu(zzaj zzajVar, String str, String str2, int i, int i2) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzd(parcelZza, zzajVar);
        parcelZza.writeString(null);
        parcelZza.writeString(str2);
        parcelZza.writeInt(i);
        parcelZza.writeInt(i2);
        zzc(8001, parcelZza);
    }

    public final Intent zzv() throws RemoteException {
        Parcel parcelZzb = zzb(9003, zza());
        Intent intent = (Intent) com.google.android.gms.internal.games_v2.zzc.zzb(parcelZzb, Intent.CREATOR);
        parcelZzb.recycle();
        return intent;
    }

    public final Intent zzw() throws RemoteException {
        Parcel parcelZzb = zzb(9005, zza());
        Intent intent = (Intent) com.google.android.gms.internal.games_v2.zzc.zzb(parcelZzb, Intent.CREATOR);
        parcelZzb.recycle();
        return intent;
    }

    public final Intent zzx() throws RemoteException {
        Parcel parcelZzb = zzb(9010, zza());
        Intent intent = (Intent) com.google.android.gms.internal.games_v2.zzc.zzb(parcelZzb, Intent.CREATOR);
        parcelZzb.recycle();
        return intent;
    }

    public final void zzy(zzaj zzajVar, String str, int i, boolean z, boolean z2) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.games_v2.zzc.zzd(parcelZza, zzajVar);
        parcelZza.writeString(str);
        parcelZza.writeInt(i);
        parcelZza.writeInt(z ? 1 : 0);
        parcelZza.writeInt(z2 ? 1 : 0);
        zzc(9020, parcelZza);
    }

    public final Intent zzz(String str, boolean z, boolean z2, int i) throws RemoteException {
        Parcel parcelZza = zza();
        parcelZza.writeString(str);
        int i2 = com.google.android.gms.internal.games_v2.zzc.zza;
        parcelZza.writeInt(z ? 1 : 0);
        parcelZza.writeInt(z2 ? 1 : 0);
        parcelZza.writeInt(i);
        Parcel parcelZzb = zzb(12001, parcelZza);
        Intent intent = (Intent) com.google.android.gms.internal.games_v2.zzc.zzb(parcelZzb, Intent.CREATOR);
        parcelZzb.recycle();
        return intent;
    }
}
