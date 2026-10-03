package com.google.android.gms.games;

import android.net.Uri;
import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.CommonStatusCodes;
import com.google.android.gms.common.internal.safeparcel.SafeParcelReader;

public class zzf implements Parcelable.Creator {
    @Override
    public final Object[] newArray(int i) {
        return new GameEntity[i];
    }

    @Override
    public GameEntity createFromParcel(Parcel parcel) {
        int iValidateObjectHeader = SafeParcelReader.validateObjectHeader(parcel);
        boolean z = false;
        boolean z2 = false;
        int i = 0;
        int i2 = 0;
        int i3 = 0;
        boolean z3 = false;
        boolean z4 = false;
        boolean z5 = false;
        boolean z6 = false;
        boolean z7 = false;
        boolean z8 = false;
        boolean z9 = false;
        String strCreateString = null;
        String strCreateString2 = null;
        String strCreateString3 = null;
        String strCreateString4 = null;
        String strCreateString5 = null;
        String strCreateString6 = null;
        Uri uri = null;
        Uri uri2 = null;
        Uri uri3 = null;
        String strCreateString7 = null;
        String strCreateString8 = null;
        String strCreateString9 = null;
        String strCreateString10 = null;
        String strCreateString11 = null;
        while (parcel.dataPosition() < iValidateObjectHeader) {
            int header = SafeParcelReader.readHeader(parcel);
            int fieldId = SafeParcelReader.getFieldId(header);
            if (fieldId != 28) {
                switch (fieldId) {
                    case 1:
                        strCreateString = SafeParcelReader.createString(parcel, header);
                        break;
                    case 2:
                        strCreateString2 = SafeParcelReader.createString(parcel, header);
                        break;
                    case 3:
                        strCreateString3 = SafeParcelReader.createString(parcel, header);
                        break;
                    case 4:
                        strCreateString4 = SafeParcelReader.createString(parcel, header);
                        break;
                    case 5:
                        strCreateString5 = SafeParcelReader.createString(parcel, header);
                        break;
                    case 6:
                        strCreateString6 = SafeParcelReader.createString(parcel, header);
                        break;
                    case 7:
                        uri = (Uri) SafeParcelReader.createParcelable(parcel, header, Uri.CREATOR);
                        break;
                    case 8:
                        uri2 = (Uri) SafeParcelReader.createParcelable(parcel, header, Uri.CREATOR);
                        break;
                    case 9:
                        uri3 = (Uri) SafeParcelReader.createParcelable(parcel, header, Uri.CREATOR);
                        break;
                    case 10:
                        z = SafeParcelReader.readBoolean(parcel, header);
                        break;
                    case 11:
                        z2 = SafeParcelReader.readBoolean(parcel, header);
                        break;
                    case 12:
                        strCreateString7 = SafeParcelReader.createString(parcel, header);
                        break;
                    case 13:
                        i = SafeParcelReader.readInt(parcel, header);
                        break;
                    case 14:
                        i2 = SafeParcelReader.readInt(parcel, header);
                        break;
                    case 15:
                        i3 = SafeParcelReader.readInt(parcel, header);
                        break;
                    case 16:
                        z3 = SafeParcelReader.readBoolean(parcel, header);
                        break;
                    case 17:
                        z4 = SafeParcelReader.readBoolean(parcel, header);
                        break;
                    case 18:
                        strCreateString8 = SafeParcelReader.createString(parcel, header);
                        break;
                    case 19:
                        strCreateString9 = SafeParcelReader.createString(parcel, header);
                        break;
                    case 20:
                        strCreateString10 = SafeParcelReader.createString(parcel, header);
                        break;
                    case CommonStatusCodes.RECONNECTION_TIMED_OUT_DURING_UPDATE:
                        z5 = SafeParcelReader.readBoolean(parcel, header);
                        break;
                    case 22:
                        z6 = SafeParcelReader.readBoolean(parcel, header);
                        break;
                    case ConnectionResult.API_DISABLED:
                        z7 = SafeParcelReader.readBoolean(parcel, header);
                        break;
                    case ConnectionResult.API_DISABLED_FOR_CONNECTION:
                        strCreateString11 = SafeParcelReader.createString(parcel, header);
                        break;
                    case 25:
                        z8 = SafeParcelReader.readBoolean(parcel, header);
                        break;
                    default:
                        SafeParcelReader.skipUnknownField(parcel, header);
                        break;
                }
            } else {
                z9 = SafeParcelReader.readBoolean(parcel, header);
            }
        }
        SafeParcelReader.ensureAtEnd(parcel, iValidateObjectHeader);
        return new GameEntity(strCreateString, strCreateString2, strCreateString3, strCreateString4, strCreateString5, strCreateString6, uri, uri2, uri3, z, z2, strCreateString7, i, i2, i3, z3, z4, strCreateString8, strCreateString9, strCreateString10, z5, z6, z7, strCreateString11, z8, z9);
    }
}
