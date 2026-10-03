package com.google.android.gms.drive;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.common.internal.ReflectedParcelable;
import com.google.android.gms.common.internal.safeparcel.AbstractSafeParcelable;
import com.google.android.gms.common.internal.safeparcel.SafeParcelWriter;

@Deprecated
public class DriveId extends AbstractSafeParcelable implements ReflectedParcelable {
    public static final Parcelable.Creator<DriveId> CREATOR = new zzb();
    final String zza;
    final long zzb;
    final long zzc;
    final int zzd;
    volatile String zze = null;

    public DriveId(String str, long j, long j2, int i) {
        this.zza = str;
        boolean z = true;
        Preconditions.checkArgument(!"".equals(str));
        if (str == null && j == -1) {
            z = false;
            j = -1;
        }
        Preconditions.checkArgument(z);
        this.zzb = j;
        this.zzc = j2;
        this.zzd = i;
    }

    public final boolean equals(Object obj) {
        String str;
        if (obj != null && obj.getClass() == DriveId.class) {
            DriveId driveId = (DriveId) obj;
            if (driveId.zzc != this.zzc) {
                return false;
            }
            long j = driveId.zzb;
            if (j == -1) {
                if (this.zzb == -1) {
                    return ((String) Preconditions.checkNotNull(driveId.zza)).equals(this.zza);
                }
                j = -1;
            }
            String str2 = this.zza;
            if (str2 != null && (str = driveId.zza) != null) {
                return j == this.zzb && str.equals(str2);
            }
            if (j == this.zzb) {
                return true;
            }
        }
        return false;
    }

    public final int hashCode() {
        long j = this.zzb;
        if (j == -1) {
            String str = this.zza;
            Preconditions.checkNotNull(str);
            return str.hashCode();
        }
        long j2 = this.zzc;
        String strValueOf = String.valueOf(j);
        StringBuilder sb = new StringBuilder(String.valueOf(j2).length() + String.valueOf(strValueOf).length());
        sb.append(j2);
        sb.append(strValueOf);
        return sb.toString().hashCode();
    }

    public final String toString() {
        return super.toString();
    }

    @Override
    public final void writeToParcel(Parcel parcel, int i) {
        String str = this.zza;
        int iBeginObjectHeader = SafeParcelWriter.beginObjectHeader(parcel);
        SafeParcelWriter.writeString(parcel, 2, str, false);
        SafeParcelWriter.writeLong(parcel, 3, this.zzb);
        SafeParcelWriter.writeLong(parcel, 4, this.zzc);
        SafeParcelWriter.writeInt(parcel, 5, this.zzd);
        SafeParcelWriter.finishObjectHeader(parcel, iBeginObjectHeader);
    }
}
