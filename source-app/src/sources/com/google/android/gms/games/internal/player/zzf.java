package com.google.android.gms.games.internal.player;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.SafeParcelReader;

public final class zzf implements Parcelable.Creator {
    @Override
    public final Object createFromParcel(Parcel parcel) {
        int iValidateObjectHeader = SafeParcelReader.validateObjectHeader(parcel);
        boolean z = false;
        boolean z2 = false;
        boolean z3 = false;
        boolean z4 = false;
        boolean z5 = false;
        boolean z6 = false;
        boolean z7 = false;
        boolean z8 = false;
        boolean z9 = false;
        boolean z10 = false;
        while (parcel.dataPosition() < iValidateObjectHeader) {
            int header = SafeParcelReader.readHeader(parcel);
            switch (SafeParcelReader.getFieldId(header)) {
                case 1:
                    z = SafeParcelReader.readBoolean(parcel, header);
                    break;
                case 2:
                    z2 = SafeParcelReader.readBoolean(parcel, header);
                    break;
                case 3:
                    z3 = SafeParcelReader.readBoolean(parcel, header);
                    break;
                case 4:
                    z4 = SafeParcelReader.readBoolean(parcel, header);
                    break;
                case 5:
                    z5 = SafeParcelReader.readBoolean(parcel, header);
                    break;
                case 6:
                    z6 = SafeParcelReader.readBoolean(parcel, header);
                    break;
                case 7:
                    z7 = SafeParcelReader.readBoolean(parcel, header);
                    break;
                case 8:
                    z8 = SafeParcelReader.readBoolean(parcel, header);
                    break;
                case 9:
                    z9 = SafeParcelReader.readBoolean(parcel, header);
                    break;
                case 10:
                    z10 = SafeParcelReader.readBoolean(parcel, header);
                    break;
                default:
                    SafeParcelReader.skipUnknownField(parcel, header);
                    break;
            }
        }
        SafeParcelReader.ensureAtEnd(parcel, iValidateObjectHeader);
        return new zze(z, z2, z3, z4, z5, z6, z7, z8, z9, z10);
    }

    @Override
    public final Object[] newArray(int i) {
        return new zze[i];
    }
}
