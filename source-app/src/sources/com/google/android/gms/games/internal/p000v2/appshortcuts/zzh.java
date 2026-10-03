package com.google.android.gms.games.internal.p000v2.appshortcuts;

import android.content.pm.ShortcutInfo;
import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.SafeParcelReader;
import java.util.ArrayList;

public final class zzh implements Parcelable.Creator {
    @Override
    public final Object createFromParcel(Parcel parcel) {
        int iValidateObjectHeader = SafeParcelReader.validateObjectHeader(parcel);
        ArrayList<String> arrayListCreateStringList = null;
        ArrayList arrayListCreateTypedList = null;
        ArrayList<String> arrayListCreateStringList2 = null;
        ArrayList<String> arrayListCreateStringList3 = null;
        while (parcel.dataPosition() < iValidateObjectHeader) {
            int header = SafeParcelReader.readHeader(parcel);
            int fieldId = SafeParcelReader.getFieldId(header);
            if (fieldId == 1) {
                arrayListCreateStringList = SafeParcelReader.createStringList(parcel, header);
            } else if (fieldId == 2) {
                arrayListCreateTypedList = SafeParcelReader.createTypedList(parcel, header, ShortcutInfo.CREATOR);
            } else if (fieldId == 3) {
                arrayListCreateStringList2 = SafeParcelReader.createStringList(parcel, header);
            } else if (fieldId != 4) {
                SafeParcelReader.skipUnknownField(parcel, header);
            } else {
                arrayListCreateStringList3 = SafeParcelReader.createStringList(parcel, header);
            }
        }
        SafeParcelReader.ensureAtEnd(parcel, iValidateObjectHeader);
        return new zzg(arrayListCreateStringList, arrayListCreateTypedList, arrayListCreateStringList2, arrayListCreateStringList3);
    }

    @Override
    public final Object[] newArray(int i) {
        return new zzg[i];
    }
}
