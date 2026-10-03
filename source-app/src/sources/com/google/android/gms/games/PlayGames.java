package com.google.android.gms.games;

import android.app.Activity;
import com.google.android.gms.internal.games_v2.zzaq;
import com.google.android.gms.internal.games_v2.zzay;
import com.google.android.gms.internal.games_v2.zzbw;
import com.google.android.gms.internal.games_v2.zzcj;
import com.google.android.gms.internal.games_v2.zzcq;
import com.google.android.gms.internal.games_v2.zzcv;
import com.google.android.gms.internal.games_v2.zzdq;
import com.google.android.gms.internal.games_v2.zzdt;
import com.google.android.gms.internal.games_v2.zzem;
import com.google.android.gms.internal.games_v2.zzer;
import com.google.android.gms.internal.games_v2.zzfk;

public final class PlayGames {
    private PlayGames() {
    }

    public static AchievementsClient getAchievementsClient(Activity activity) {
        zzbw.zzb();
        return new zzcj(zzaq.zza(zzbw.zzc()));
    }

    public static EventsClient getEventsClient(Activity activity) {
        zzbw.zzb();
        return new zzcq(zzaq.zza(zzbw.zzc()));
    }

    public static GamesSignInClient getGamesSignInClient(Activity activity) {
        zzbw.zzb();
        return new zzcv(zzay.zza(zzbw.zzc()), zzaq.zza(zzbw.zzc()));
    }

    public static LeaderboardsClient getLeaderboardsClient(Activity activity) {
        zzbw.zzb();
        return new zzdq(zzaq.zza(zzbw.zzc()));
    }

    public static PlayerStatsClient getPlayerStatsClient(Activity activity) {
        zzbw.zzb();
        return new zzdt(zzaq.zza(zzbw.zzc()));
    }

    public static PlayersClient getPlayersClient(Activity activity) {
        zzbw.zzb();
        return new zzem(zzaq.zza(zzbw.zzc()));
    }

    public static RecallClient getRecallClient(Activity activity) {
        zzbw.zzb();
        return new zzer(activity, zzay.zza(zzbw.zzc()));
    }

    public static SnapshotsClient getSnapshotsClient(Activity activity) {
        zzbw.zzb();
        return new zzfk(zzaq.zza(zzbw.zzc()));
    }
}
