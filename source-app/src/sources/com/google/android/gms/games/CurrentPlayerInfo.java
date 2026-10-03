package com.google.android.gms.games;

import android.os.Parcelable;
import com.google.android.gms.common.data.Freezable;

public interface CurrentPlayerInfo extends Freezable<CurrentPlayerInfo>, Parcelable {
    int getFriendsListVisibilityStatus();
}
