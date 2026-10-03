package com.google.android.gms.internal.location;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.ClientIdentity;
import com.google.android.gms.common.internal.safeparcel.SafeParcelReader;
import java.util.List;

public final class zzk implements Parcelable.Creator<zzj> {
    @Override
    public final zzj createFromParcel(Parcel parcel) {
        int iValidateObjectHeader = SafeParcelReader.validateObjectHeader(parcel);
        com.google.android.gms.location.zzs zzsVar = zzj.zzb;
        List<ClientIdentity> listCreateTypedList = zzj.zza;
        String strCreateString = null;
        while (parcel.dataPosition() < iValidateObjectHeader) {
            int header = SafeParcelReader.readHeader(parcel);
            int fieldId = SafeParcelReader.getFieldId(header);
            if (fieldId == 1) {
                zzsVar = (com.google.android.gms.location.zzs) SafeParcelReader.createParcelable(parcel, header, com.google.android.gms.location.zzs.CREATOR);
            } else if (fieldId == 2) {
                listCreateTypedList = SafeParcelReader.createTypedList(parcel, header, ClientIdentity.CREATOR);
            } else if (fieldId != 3) {
                SafeParcelReader.skipUnknownField(parcel, header);
            } else {
                strCreateString = SafeParcelReader.createString(parcel, header);
            }
        }
        SafeParcelReader.ensureAtEnd(parcel, iValidateObjectHeader);
        return new zzj(zzsVar, listCreateTypedList, strCreateString);
    }

    @Override
    public final zzj[] newArray(int i) {
        return new zzj[i];
    }
}
