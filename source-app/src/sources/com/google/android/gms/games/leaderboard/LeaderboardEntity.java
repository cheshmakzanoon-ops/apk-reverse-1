package com.google.android.gms.games.leaderboard;

import android.database.CharArrayBuffer;
import android.net.Uri;
import com.google.android.gms.common.internal.Objects;
import com.google.android.gms.common.util.DataUtils;
import com.google.android.gms.games.Game;
import com.google.android.gms.games.GameEntity;
import java.util.ArrayList;

public final class LeaderboardEntity implements Leaderboard {
    private final String zza;
    private final String zzb;
    private final Uri zzc;
    private final int zzd;
    private final ArrayList zze;
    private final String zzf;

    public LeaderboardEntity(Leaderboard leaderboard) {
        this.zza = leaderboard.getLeaderboardId();
        this.zzb = leaderboard.getDisplayName();
        this.zzc = leaderboard.getIconImageUri();
        this.zzf = leaderboard.getIconImageUrl();
        this.zzd = leaderboard.getScoreOrder();
        Game gameZza = leaderboard.zza();
        if (gameZza != null) {
            new GameEntity(gameZza);
        }
        ArrayList<LeaderboardVariant> variants = leaderboard.getVariants();
        int size = variants.size();
        this.zze = new ArrayList(size);
        for (int i = 0; i < size; i++) {
            this.zze.add((LeaderboardVariantEntity) variants.get(i).freeze());
        }
    }

    static int zzb(Leaderboard leaderboard) {
        return Objects.hashCode(leaderboard.getLeaderboardId(), leaderboard.getDisplayName(), leaderboard.getIconImageUri(), Integer.valueOf(leaderboard.getScoreOrder()), leaderboard.getVariants());
    }

    static boolean zzc(Leaderboard leaderboard, Object obj) {
        if (!(obj instanceof Leaderboard)) {
            return false;
        }
        if (leaderboard == obj) {
            return true;
        }
        Leaderboard leaderboard2 = (Leaderboard) obj;
        return Objects.equal(leaderboard2.getLeaderboardId(), leaderboard.getLeaderboardId()) && Objects.equal(leaderboard2.getDisplayName(), leaderboard.getDisplayName()) && Objects.equal(leaderboard2.getIconImageUri(), leaderboard.getIconImageUri()) && Objects.equal(Integer.valueOf(leaderboard2.getScoreOrder()), Integer.valueOf(leaderboard.getScoreOrder())) && Objects.equal(leaderboard2.getVariants(), leaderboard.getVariants());
    }

    static String zzd(Leaderboard leaderboard) {
        return Objects.toStringHelper(leaderboard).add("LeaderboardId", leaderboard.getLeaderboardId()).add("DisplayName", leaderboard.getDisplayName()).add("IconImageUri", leaderboard.getIconImageUri()).add("IconImageUrl", leaderboard.getIconImageUrl()).add("ScoreOrder", Integer.valueOf(leaderboard.getScoreOrder())).add("Variants", leaderboard.getVariants()).toString();
    }

    public final boolean equals(Object obj) {
        return zzc(this, obj);
    }

    @Override
    public final Leaderboard freeze() {
        return this;
    }

    @Override
    public final String getDisplayName() {
        return this.zzb;
    }

    @Override
    public final void getDisplayName(CharArrayBuffer charArrayBuffer) {
        DataUtils.copyStringToBuffer(this.zzb, charArrayBuffer);
    }

    @Override
    public final Uri getIconImageUri() {
        return this.zzc;
    }

    @Override
    public String getIconImageUrl() {
        return this.zzf;
    }

    @Override
    public final String getLeaderboardId() {
        return this.zza;
    }

    @Override
    public final int getScoreOrder() {
        return this.zzd;
    }

    @Override
    public final ArrayList<LeaderboardVariant> getVariants() {
        return new ArrayList<>(this.zze);
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
    public final Game zza() {
        throw null;
    }
}
