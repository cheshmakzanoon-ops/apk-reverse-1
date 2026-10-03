package com.google.android.gms.common.data;

import android.content.ContentValues;
import java.util.HashMap;

final class zab extends DataHolder.Builder {
    zab(String[] strArr, String str) {
        super(strArr, null, null);
    }

    @Override
    public final DataHolder.Builder withRow(ContentValues contentValues) {
        throw new UnsupportedOperationException("Cannot add data to empty builder");
    }

    @Override
    public final DataHolder.Builder zaa(HashMap map) {
        throw new UnsupportedOperationException("Cannot add data to empty builder");
    }
}
