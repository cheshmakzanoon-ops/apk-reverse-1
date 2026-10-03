package com.google.android.gms.games.stats;

import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.Objects;
import com.google.android.gms.games.internal.zzg;

public class PlayerStatsEntity extends zzg implements PlayerStats {
    public static final Parcelable.Creator<PlayerStatsEntity> CREATOR = new zza();
    private final float zza;
    private final float zzb;
    private final int zzc;
    private final int zzd;
    private final int zze;
    private final float zzf;
    private final float zzg;
    private final Bundle zzh;
    private final float zzi;
    private final float zzj;
    private final float zzk;

    PlayerStatsEntity(float f, float f2, int i, int i2, int i3, float f3, float f4, Bundle bundle, float f5, float f6, float f7) {
        this.zza = f;
        this.zzb = f2;
        this.zzc = i;
        this.zzd = i2;
        this.zze = i3;
        this.zzf = f3;
        this.zzg = f4;
        this.zzh = bundle;
        this.zzi = f5;
        this.zzj = f6;
        this.zzk = f7;
    }

    static int zzb(PlayerStats playerStats) {
        return Objects.hashCode(Float.valueOf(playerStats.getAverageSessionLength()), Float.valueOf(playerStats.getChurnProbability()), Integer.valueOf(playerStats.getDaysSinceLastPlayed()), Integer.valueOf(playerStats.getNumberOfPurchases()), Integer.valueOf(playerStats.getNumberOfSessions()), Float.valueOf(playerStats.getSessionPercentile()), Float.valueOf(playerStats.getSpendPercentile()), Float.valueOf(playerStats.getSpendProbability()), Float.valueOf(playerStats.getHighSpenderProbability()), Float.valueOf(playerStats.getTotalSpendNext28Days()));
    }

    static boolean zzc(PlayerStats playerStats, Object obj) {
        if (!(obj instanceof PlayerStats)) {
            return false;
        }
        if (playerStats == obj) {
            return true;
        }
        PlayerStats playerStats2 = (PlayerStats) obj;
        return Objects.equal(Float.valueOf(playerStats2.getAverageSessionLength()), Float.valueOf(playerStats.getAverageSessionLength())) && Objects.equal(Float.valueOf(playerStats2.getChurnProbability()), Float.valueOf(playerStats.getChurnProbability())) && Objects.equal(Integer.valueOf(playerStats2.getDaysSinceLastPlayed()), Integer.valueOf(playerStats.getDaysSinceLastPlayed())) && Objects.equal(Integer.valueOf(playerStats2.getNumberOfPurchases()), Integer.valueOf(playerStats.getNumberOfPurchases())) && Objects.equal(Integer.valueOf(playerStats2.getNumberOfSessions()), Integer.valueOf(playerStats.getNumberOfSessions())) && Objects.equal(Float.valueOf(playerStats2.getSessionPercentile()), Float.valueOf(playerStats.getSessionPercentile())) && Objects.equal(Float.valueOf(playerStats2.getSpendPercentile()), Float.valueOf(playerStats.getSpendPercentile())) && Objects.equal(Float.valueOf(playerStats2.getSpendProbability()), Float.valueOf(playerStats.getSpendProbability())) && Objects.equal(Float.valueOf(playerStats2.getHighSpenderProbability()), Float.valueOf(playerStats.getHighSpenderProbability())) && Objects.equal(Float.valueOf(playerStats2.getTotalSpendNext28Days()), Float.valueOf(playerStats.getTotalSpendNext28Days()));
    }

    static String zzd(PlayerStats playerStats) {
        return Objects.toStringHelper(playerStats).add("AverageSessionLength", Float.valueOf(playerStats.getAverageSessionLength())).add("ChurnProbability", Float.valueOf(playerStats.getChurnProbability())).add("DaysSinceLastPlayed", Integer.valueOf(playerStats.getDaysSinceLastPlayed())).add("NumberOfPurchases", Integer.valueOf(playerStats.getNumberOfPurchases())).add("NumberOfSessions", Integer.valueOf(playerStats.getNumberOfSessions())).add("SessionPercentile", Float.valueOf(playerStats.getSessionPercentile())).add("SpendPercentile", Float.valueOf(playerStats.getSpendPercentile())).add("SpendProbability", Float.valueOf(playerStats.getSpendProbability())).add("HighSpenderProbability", Float.valueOf(playerStats.getHighSpenderProbability())).add("TotalSpendNext28Days", Float.valueOf(playerStats.getTotalSpendNext28Days())).toString();
    }

    public final boolean equals(Object obj) {
        return zzc(this, obj);
    }

    @Override
    public final PlayerStats freeze() {
        return this;
    }

    @Override
    public final float getAverageSessionLength() {
        return this.zza;
    }

    @Override
    public final float getChurnProbability() {
        return this.zzb;
    }

    @Override
    public final int getDaysSinceLastPlayed() {
        return this.zzc;
    }

    @Override
    public final float getHighSpenderProbability() {
        return this.zzj;
    }

    @Override
    public final int getNumberOfPurchases() {
        return this.zzd;
    }

    @Override
    public final int getNumberOfSessions() {
        return this.zze;
    }

    @Override
    public final float getSessionPercentile() {
        return this.zzf;
    }

    @Override
    public final float getSpendPercentile() {
        return this.zzg;
    }

    @Override
    public final float getSpendProbability() {
        return this.zzi;
    }

    @Override
    public final float getTotalSpendNext28Days() {
        return this.zzk;
    }

    public final int hashCode() {
        return zzb(this);
    }

    @Override
    public final boolean isDataValid() {
        return true;
    }

    public final String toString() {
        return zzd(this);
    }

    @Override
    public final void writeToParcel(Parcel parcel, int i) {
        zza.zza(this, parcel, i);
    }

    @Override
    public final Bundle zza() {
        return this.zzh;
    }

    public PlayerStatsEntity(PlayerStats playerStats) {
        this.zza = playerStats.getAverageSessionLength();
        this.zzb = playerStats.getChurnProbability();
        this.zzc = playerStats.getDaysSinceLastPlayed();
        this.zzd = playerStats.getNumberOfPurchases();
        this.zze = playerStats.getNumberOfSessions();
        this.zzf = playerStats.getSessionPercentile();
        this.zzg = playerStats.getSpendPercentile();
        this.zzi = playerStats.getSpendProbability();
        this.zzj = playerStats.getHighSpenderProbability();
        this.zzk = playerStats.getTotalSpendNext28Days();
        this.zzh = playerStats.zza();
    }
}
