package com.google.android.gms.games.internal.experience;

import android.net.Uri;
import android.os.Parcelable;
import com.google.android.gms.common.data.Freezable;
import com.google.android.gms.games.Game;

public interface ExperienceEvent extends Freezable<ExperienceEvent>, Parcelable {
    @Deprecated
    String getIconImageUrl();

    String zza();

    Game zzb();

    String zzc();

    String zzd();

    Uri zze();

    long zzf();

    long zzg();

    long zzh();

    int zzi();

    int zzj();
}
