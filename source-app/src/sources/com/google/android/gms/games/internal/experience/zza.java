package com.google.android.gms.games.internal.experience;

import android.net.Uri;
import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.SafeParcelReader;
import com.google.android.gms.games.GameEntity;

public final class zza implements Parcelable.Creator {
    @Override
    public final Object createFromParcel(Parcel parcel) {
        int iValidateObjectHeader = SafeParcelReader.validateObjectHeader(parcel);
        int i = 0;
        int i2 = 0;
        long j = 0;
        long j2 = 0;
        long j3 = 0;
        String strCreateString = null;
        GameEntity gameEntity = null;
        String strCreateString2 = null;
        String strCreateString3 = null;
        String strCreateString4 = null;
        Uri uri = null;
        while (parcel.dataPosition() < iValidateObjectHeader) {
            int header = SafeParcelReader.readHeader(parcel);
            switch (SafeParcelReader.getFieldId(header)) {
                case 1:
                    strCreateString = SafeParcelReader.createString(parcel, header);
                    break;
                case 2:
                    gameEntity = (GameEntity) SafeParcelReader.createParcelable(parcel, header, GameEntity.CREATOR);
                    break;
                case 3:
                    strCreateString2 = SafeParcelReader.createString(parcel, header);
                    break;
                case 4:
                    strCreateString3 = SafeParcelReader.createString(parcel, header);
                    break;
                case 5:
                    strCreateString4 = SafeParcelReader.createString(parcel, header);
                    break;
                case 6:
                    uri = (Uri) SafeParcelReader.createParcelable(parcel, header, Uri.CREATOR);
                    break;
                case 7:
                    j = SafeParcelReader.readLong(parcel, header);
                    break;
                case 8:
                    j2 = SafeParcelReader.readLong(parcel, header);
                    break;
                case 9:
                    j3 = SafeParcelReader.readLong(parcel, header);
                    break;
                case 10:
                    i = SafeParcelReader.readInt(parcel, header);
                    break;
                case 11:
                    i2 = SafeParcelReader.readInt(parcel, header);
                    break;
                default:
                    SafeParcelReader.skipUnknownField(parcel, header);
                    break;
            }
        }
        SafeParcelReader.ensureAtEnd(parcel, iValidateObjectHeader);
        return new ExperienceEventEntity(strCreateString, gameEntity, strCreateString2, strCreateString3, strCreateString4, uri, j, j2, j3, i, i2);
    }

    @Override
    public final Object[] newArray(int i) {
        return new ExperienceEventEntity[i];
    }
}
