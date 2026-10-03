package com.google.android.gms.auth.api.accounttransfer;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.SafeParcelReader;
import java.util.ArrayList;
import java.util.HashSet;

public final class zzm implements Parcelable.Creator<zzl> {
    @Override
    public final zzl[] newArray(int i) {
        return new zzl[i];
    }

    @Override
    public final zzl createFromParcel(Parcel parcel) {
        int iValidateObjectHeader = SafeParcelReader.validateObjectHeader(parcel);
        HashSet hashSet = new HashSet();
        int i = 0;
        ArrayList arrayListCreateTypedList = null;
        zzo zzoVar = null;
        int i2 = 0;
        while (parcel.dataPosition() < iValidateObjectHeader) {
            int header = SafeParcelReader.readHeader(parcel);
            int fieldId = SafeParcelReader.getFieldId(header);
            if (fieldId == 1) {
                i2 = SafeParcelReader.readInt(parcel, header);
                hashSet.add(1);
            } else if (fieldId == 2) {
                arrayListCreateTypedList = SafeParcelReader.createTypedList(parcel, header, zzr.CREATOR);
                hashSet.add(2);
            } else if (fieldId == 3) {
                i = SafeParcelReader.readInt(parcel, header);
                hashSet.add(3);
            } else if (fieldId == 4) {
                zzoVar = (zzo) SafeParcelReader.createParcelable(parcel, header, zzo.CREATOR);
                hashSet.add(4);
            } else {
                SafeParcelReader.skipUnknownField(parcel, header);
            }
        }
        if (parcel.dataPosition() != iValidateObjectHeader) {
            StringBuilder sb = new StringBuilder(37);
            sb.append("Overread allowed size end=");
            sb.append(iValidateObjectHeader);
            throw new SafeParcelReader.ParseException(sb.toString(), parcel);
        }
        return new zzl(hashSet, i2, arrayListCreateTypedList, i, zzoVar);
    }
}
