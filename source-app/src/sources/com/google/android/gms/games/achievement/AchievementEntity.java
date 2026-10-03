package com.google.android.gms.games.achievement;

import android.database.CharArrayBuffer;
import android.net.Uri;
import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.Asserts;
import com.google.android.gms.common.internal.Objects;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.common.internal.safeparcel.SafeParcelWriter;
import com.google.android.gms.common.util.DataUtils;
import com.google.android.gms.games.Player;
import com.google.android.gms.games.PlayerEntity;
import com.google.android.gms.games.internal.zzg;

public final class AchievementEntity extends zzg implements Achievement {
    public static final Parcelable.Creator<AchievementEntity> CREATOR = new zza();
    private final String zza;
    private final int zzb;
    private final String zzc;
    private final String zzd;
    private final Uri zze;
    private final String zzf;
    private final Uri zzg;
    private final String zzh;
    private final int zzi;
    private final String zzj;
    private final PlayerEntity zzk;
    private final int zzl;
    private final int zzm;
    private final String zzn;
    private final long zzo;
    private final long zzp;
    private final float zzq;
    private final String zzr;

    public AchievementEntity(Achievement achievement) {
        String achievementId = achievement.getAchievementId();
        this.zza = achievementId;
        this.zzb = achievement.getType();
        this.zzc = achievement.getName();
        String description = achievement.getDescription();
        this.zzd = description;
        this.zze = achievement.getUnlockedImageUri();
        this.zzf = achievement.getUnlockedImageUrl();
        this.zzg = achievement.getRevealedImageUri();
        this.zzh = achievement.getRevealedImageUrl();
        Player playerZzb = achievement.zzb();
        if (playerZzb != null) {
            this.zzk = new PlayerEntity(playerZzb);
        } else {
            this.zzk = null;
        }
        this.zzl = achievement.getState();
        this.zzo = achievement.getLastUpdatedTimestamp();
        this.zzp = achievement.getXpValue();
        this.zzq = achievement.zzc();
        this.zzr = achievement.zza();
        if (achievement.getType() == 1) {
            this.zzi = achievement.getTotalSteps();
            this.zzj = achievement.getFormattedTotalSteps();
            this.zzm = achievement.getCurrentSteps();
            this.zzn = achievement.getFormattedCurrentSteps();
        } else {
            this.zzi = 0;
            this.zzj = null;
            this.zzm = 0;
            this.zzn = null;
        }
        Asserts.checkNotNull(achievementId);
        Asserts.checkNotNull(description);
    }

    static int zzd(Achievement achievement) {
        int currentSteps;
        int totalSteps;
        if (achievement.getType() == 1) {
            currentSteps = achievement.getCurrentSteps();
            totalSteps = achievement.getTotalSteps();
        } else {
            currentSteps = 0;
            totalSteps = 0;
        }
        return Objects.hashCode(achievement.getAchievementId(), achievement.zza(), achievement.getName(), Integer.valueOf(achievement.getType()), achievement.getDescription(), Long.valueOf(achievement.getXpValue()), Integer.valueOf(achievement.getState()), Long.valueOf(achievement.getLastUpdatedTimestamp()), achievement.zzb(), Integer.valueOf(currentSteps), Integer.valueOf(totalSteps));
    }

    static boolean zze(Achievement achievement, Object obj) {
        if (!(obj instanceof Achievement)) {
            return false;
        }
        if (achievement == obj) {
            return true;
        }
        Achievement achievement2 = (Achievement) obj;
        if (achievement2.getType() != achievement.getType()) {
            return false;
        }
        return (achievement.getType() != 1 || (achievement2.getCurrentSteps() == achievement.getCurrentSteps() && achievement2.getTotalSteps() == achievement.getTotalSteps())) && achievement2.getXpValue() == achievement.getXpValue() && achievement2.getState() == achievement.getState() && achievement2.getLastUpdatedTimestamp() == achievement.getLastUpdatedTimestamp() && Objects.equal(achievement2.getAchievementId(), achievement.getAchievementId()) && Objects.equal(achievement2.zza(), achievement.zza()) && Objects.equal(achievement2.getName(), achievement.getName()) && Objects.equal(achievement2.getDescription(), achievement.getDescription()) && Objects.equal(achievement2.zzb(), achievement.zzb()) && achievement2.zzc() == achievement.zzc();
    }

    static String zzf(Achievement achievement) {
        Objects.ToStringHelper toStringHelperAdd = Objects.toStringHelper(achievement).add("Id", achievement.getAchievementId()).add("Game Id", achievement.zza()).add("Type", Integer.valueOf(achievement.getType())).add("Name", achievement.getName()).add("Description", achievement.getDescription()).add("Player", achievement.zzb()).add("State", Integer.valueOf(achievement.getState())).add("Rarity Percent", Float.valueOf(achievement.zzc()));
        if (achievement.getType() == 1) {
            toStringHelperAdd.add("CurrentSteps", Integer.valueOf(achievement.getCurrentSteps()));
            toStringHelperAdd.add("TotalSteps", Integer.valueOf(achievement.getTotalSteps()));
        }
        return toStringHelperAdd.toString();
    }

    public boolean equals(Object obj) {
        return zze(this, obj);
    }

    @Override
    public Achievement freeze() {
        return this;
    }

    @Override
    public final Achievement freeze() {
        return this;
    }

    @Override
    public String getAchievementId() {
        return this.zza;
    }

    @Override
    public int getCurrentSteps() {
        Asserts.checkState(getType() == 1);
        return this.zzm;
    }

    @Override
    public String getDescription() {
        return this.zzd;
    }

    @Override
    public void getDescription(CharArrayBuffer charArrayBuffer) {
        DataUtils.copyStringToBuffer(this.zzd, charArrayBuffer);
    }

    @Override
    public String getFormattedCurrentSteps() {
        Asserts.checkState(getType() == 1);
        return this.zzn;
    }

    @Override
    public String getFormattedTotalSteps() {
        Asserts.checkState(getType() == 1);
        return this.zzj;
    }

    @Override
    public long getLastUpdatedTimestamp() {
        return this.zzo;
    }

    @Override
    public String getName() {
        return this.zzc;
    }

    @Override
    public void getName(CharArrayBuffer charArrayBuffer) {
        DataUtils.copyStringToBuffer(this.zzc, charArrayBuffer);
    }

    @Override
    public Player getPlayer() {
        return (Player) Preconditions.checkNotNull(this.zzk);
    }

    @Override
    public Uri getRevealedImageUri() {
        return this.zzg;
    }

    @Override
    public String getRevealedImageUrl() {
        return this.zzh;
    }

    @Override
    public int getState() {
        return this.zzl;
    }

    @Override
    public int getTotalSteps() {
        Asserts.checkState(getType() == 1);
        return this.zzi;
    }

    @Override
    public int getType() {
        return this.zzb;
    }

    @Override
    public Uri getUnlockedImageUri() {
        return this.zze;
    }

    @Override
    public String getUnlockedImageUrl() {
        return this.zzf;
    }

    @Override
    public long getXpValue() {
        return this.zzp;
    }

    public int hashCode() {
        return zzd(this);
    }

    @Override
    public boolean isDataValid() {
        return true;
    }

    public String toString() {
        return zzf(this);
    }

    @Override
    public void writeToParcel(Parcel parcel, int i) {
        int iBeginObjectHeader = SafeParcelWriter.beginObjectHeader(parcel);
        SafeParcelWriter.writeString(parcel, 1, getAchievementId(), false);
        SafeParcelWriter.writeInt(parcel, 2, getType());
        SafeParcelWriter.writeString(parcel, 3, getName(), false);
        SafeParcelWriter.writeString(parcel, 4, getDescription(), false);
        SafeParcelWriter.writeParcelable(parcel, 5, getUnlockedImageUri(), i, false);
        SafeParcelWriter.writeString(parcel, 6, getUnlockedImageUrl(), false);
        SafeParcelWriter.writeParcelable(parcel, 7, getRevealedImageUri(), i, false);
        SafeParcelWriter.writeString(parcel, 8, getRevealedImageUrl(), false);
        SafeParcelWriter.writeInt(parcel, 9, this.zzi);
        SafeParcelWriter.writeString(parcel, 10, this.zzj, false);
        SafeParcelWriter.writeParcelable(parcel, 11, this.zzk, i, false);
        SafeParcelWriter.writeInt(parcel, 12, getState());
        SafeParcelWriter.writeInt(parcel, 13, this.zzm);
        SafeParcelWriter.writeString(parcel, 14, this.zzn, false);
        SafeParcelWriter.writeLong(parcel, 15, getLastUpdatedTimestamp());
        SafeParcelWriter.writeLong(parcel, 16, getXpValue());
        SafeParcelWriter.writeFloat(parcel, 17, this.zzq);
        SafeParcelWriter.writeString(parcel, 18, this.zzr, false);
        SafeParcelWriter.finishObjectHeader(parcel, iBeginObjectHeader);
    }

    @Override
    public final String zza() {
        return this.zzr;
    }

    @Override
    public final Player zzb() {
        return this.zzk;
    }

    @Override
    public final float zzc() {
        return this.zzq;
    }

    @Override
    public void getFormattedCurrentSteps(CharArrayBuffer charArrayBuffer) {
        Asserts.checkState(getType() == 1);
        DataUtils.copyStringToBuffer(this.zzn, charArrayBuffer);
    }

    @Override
    public void getFormattedTotalSteps(CharArrayBuffer charArrayBuffer) {
        Asserts.checkState(getType() == 1);
        DataUtils.copyStringToBuffer(this.zzj, charArrayBuffer);
    }

    AchievementEntity(String str, int i, String str2, String str3, Uri uri, String str4, Uri uri2, String str5, int i2, String str6, PlayerEntity playerEntity, int i3, int i4, String str7, long j, long j2, float f, String str8) {
        this.zza = str;
        this.zzb = i;
        this.zzc = str2;
        this.zzd = str3;
        this.zze = uri;
        this.zzf = str4;
        this.zzg = uri2;
        this.zzh = str5;
        this.zzi = i2;
        this.zzj = str6;
        this.zzk = playerEntity;
        this.zzl = i3;
        this.zzm = i4;
        this.zzn = str7;
        this.zzo = j;
        this.zzp = j2;
        this.zzq = f;
        this.zzr = str8;
    }
}
