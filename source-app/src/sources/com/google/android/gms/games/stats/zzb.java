package com.google.android.gms.games.stats;

import android.os.Bundle;
import android.os.Parcel;
import com.google.android.gms.common.data.DataBufferRef;
import com.google.android.gms.common.data.DataHolder;
import com.google.android.gms.common.internal.Asserts;

public final class zzb extends DataBufferRef implements PlayerStats {
    private Bundle zza;

    zzb(DataHolder dataHolder, int i) {
        super(dataHolder, i);
    }

    @Override
    public final int describeContents() {
        return 0;
    }

    @Override
    public final boolean equals(Object obj) {
        return PlayerStatsEntity.zzc(this, obj);
    }

    @Override
    public final PlayerStats freeze() {
        return new PlayerStatsEntity(this);
    }

    @Override
    public final float getAverageSessionLength() {
        return getFloat("ave_session_length_minutes");
    }

    @Override
    public final float getChurnProbability() {
        return getFloat("churn_probability");
    }

    @Override
    public final int getDaysSinceLastPlayed() {
        return getInteger("days_since_last_played");
    }

    @Override
    public final float getHighSpenderProbability() {
        if (hasColumn("high_spender_probability")) {
            return getFloat("high_spender_probability");
        }
        return -1.0f;
    }

    @Override
    public final int getNumberOfPurchases() {
        return getInteger("num_purchases");
    }

    @Override
    public final int getNumberOfSessions() {
        return getInteger("num_sessions");
    }

    @Override
    public final float getSessionPercentile() {
        return getFloat("num_sessions_percentile");
    }

    @Override
    public final float getSpendPercentile() {
        return getFloat("spend_percentile");
    }

    @Override
    public final float getSpendProbability() {
        if (hasColumn("spend_probability")) {
            return getFloat("spend_probability");
        }
        return -1.0f;
    }

    @Override
    public final float getTotalSpendNext28Days() {
        if (hasColumn("total_spend_next_28_days")) {
            return getFloat("total_spend_next_28_days");
        }
        return -1.0f;
    }

    @Override
    public final int hashCode() {
        return PlayerStatsEntity.zzb(this);
    }

    public final String toString() {
        return PlayerStatsEntity.zzd(this);
    }

    @Override
    public final void writeToParcel(Parcel parcel, int i) {
        zza.zza(new PlayerStatsEntity(this), parcel, i);
    }

    @Override
    public final Bundle zza() {
        Bundle bundle = this.zza;
        if (bundle != null) {
            return bundle;
        }
        this.zza = new Bundle();
        String string = getString("unknown_raw_keys");
        String string2 = getString("unknown_raw_values");
        if (string != null && string2 != null) {
            String[] strArrSplit = string.split(",");
            String[] strArrSplit2 = string2.split(",");
            Asserts.checkState(strArrSplit.length <= strArrSplit2.length, "Invalid raw arguments!");
            for (int i = 0; i < strArrSplit.length; i++) {
                this.zza.putString(strArrSplit[i], strArrSplit2[i]);
            }
        }
        return this.zza;
    }
}
