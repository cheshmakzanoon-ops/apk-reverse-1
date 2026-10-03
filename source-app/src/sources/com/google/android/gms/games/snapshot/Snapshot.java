package com.google.android.gms.games.snapshot;

import android.os.Parcelable;
import com.google.android.gms.common.data.Freezable;

public interface Snapshot extends Freezable<Snapshot>, Parcelable {
    SnapshotMetadata getMetadata();

    SnapshotContents getSnapshotContents();
}
