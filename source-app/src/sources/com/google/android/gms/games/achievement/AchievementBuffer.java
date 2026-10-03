package com.google.android.gms.games.achievement;

import com.google.android.gms.common.data.AbstractDataBuffer;
import com.google.android.gms.common.data.DataHolder;

public class AchievementBuffer extends AbstractDataBuffer<Achievement> {
    public AchievementBuffer(DataHolder dataHolder) {
        super(dataHolder);
    }

    @Override
    public Achievement get(int i) {
        return new AchievementRef(this.mDataHolder, i);
    }
}
