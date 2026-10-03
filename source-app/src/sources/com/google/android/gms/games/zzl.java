package com.google.android.gms.games;

import android.net.Uri;
import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.CommonStatusCodes;
import com.google.android.gms.common.internal.safeparcel.SafeParcelReader;
import com.google.android.gms.games.internal.player.MostRecentGameInfoEntity;
import com.google.zxing.aztec.encoder.Encoder;
import com.ishumei.smantifraud.l11l11lI1lll;

public class zzl implements Parcelable.Creator {
    @Override
    public final Object[] newArray(int i) {
        return new PlayerEntity[i];
    }

    @Override
    public PlayerEntity createFromParcel(Parcel parcel) {
        int iValidateObjectHeader = SafeParcelReader.validateObjectHeader(parcel);
        String strCreateString = null;
        String strCreateString2 = null;
        Uri uri = null;
        Uri uri2 = null;
        String strCreateString3 = null;
        String strCreateString4 = null;
        String strCreateString5 = null;
        MostRecentGameInfoEntity mostRecentGameInfoEntity = null;
        PlayerLevelInfo playerLevelInfo = null;
        String strCreateString6 = null;
        String strCreateString7 = null;
        Uri uri3 = null;
        String strCreateString8 = null;
        Uri uri4 = null;
        String strCreateString9 = null;
        zzo zzoVar = null;
        zza zzaVar = null;
        String strCreateString10 = null;
        int i = 0;
        boolean z = false;
        boolean z2 = false;
        boolean z3 = false;
        long j = -1;
        long j2 = 0;
        long j3 = 0;
        while (parcel.dataPosition() < iValidateObjectHeader) {
            int header = SafeParcelReader.readHeader(parcel);
            switch (SafeParcelReader.getFieldId(header)) {
                case 1:
                    strCreateString = SafeParcelReader.createString(parcel, header);
                    break;
                case 2:
                    strCreateString2 = SafeParcelReader.createString(parcel, header);
                    break;
                case 3:
                    uri = (Uri) SafeParcelReader.createParcelable(parcel, header, Uri.CREATOR);
                    break;
                case 4:
                    uri2 = (Uri) SafeParcelReader.createParcelable(parcel, header, Uri.CREATOR);
                    break;
                case 5:
                    j2 = SafeParcelReader.readLong(parcel, header);
                    break;
                case 6:
                    i = SafeParcelReader.readInt(parcel, header);
                    break;
                case 7:
                    j3 = SafeParcelReader.readLong(parcel, header);
                    break;
                case 8:
                    strCreateString3 = SafeParcelReader.createString(parcel, header);
                    break;
                case 9:
                    strCreateString4 = SafeParcelReader.createString(parcel, header);
                    break;
                case 10:
                case 11:
                case 12:
                case 13:
                case 17:
                case 26:
                case 27:
                case 28:
                case l11l11lI1lll.l11l1111Il1l:
                case 31:
                case 32:
                case 34:
                default:
                    SafeParcelReader.skipUnknownField(parcel, header);
                    break;
                case 14:
                    strCreateString5 = SafeParcelReader.createString(parcel, header);
                    break;
                case 15:
                    mostRecentGameInfoEntity = (MostRecentGameInfoEntity) SafeParcelReader.createParcelable(parcel, header, MostRecentGameInfoEntity.CREATOR);
                    break;
                case 16:
                    playerLevelInfo = (PlayerLevelInfo) SafeParcelReader.createParcelable(parcel, header, PlayerLevelInfo.CREATOR);
                    break;
                case 18:
                    z = SafeParcelReader.readBoolean(parcel, header);
                    break;
                case 19:
                    z2 = SafeParcelReader.readBoolean(parcel, header);
                    break;
                case 20:
                    strCreateString6 = SafeParcelReader.createString(parcel, header);
                    break;
                case CommonStatusCodes.RECONNECTION_TIMED_OUT_DURING_UPDATE:
                    strCreateString7 = SafeParcelReader.createString(parcel, header);
                    break;
                case 22:
                    uri3 = (Uri) SafeParcelReader.createParcelable(parcel, header, Uri.CREATOR);
                    break;
                case ConnectionResult.API_DISABLED:
                    strCreateString8 = SafeParcelReader.createString(parcel, header);
                    break;
                case ConnectionResult.API_DISABLED_FOR_CONNECTION:
                    uri4 = (Uri) SafeParcelReader.createParcelable(parcel, header, Uri.CREATOR);
                    break;
                case 25:
                    strCreateString9 = SafeParcelReader.createString(parcel, header);
                    break;
                case 29:
                    j = SafeParcelReader.readLong(parcel, header);
                    break;
                case Encoder.DEFAULT_EC_PERCENT:
                    zzoVar = (zzo) SafeParcelReader.createParcelable(parcel, header, zzo.CREATOR);
                    break;
                case 35:
                    zzaVar = (zza) SafeParcelReader.createParcelable(parcel, header, zza.CREATOR);
                    break;
                case 36:
                    z3 = SafeParcelReader.readBoolean(parcel, header);
                    break;
                case 37:
                    strCreateString10 = SafeParcelReader.createString(parcel, header);
                    break;
            }
        }
        SafeParcelReader.ensureAtEnd(parcel, iValidateObjectHeader);
        return new PlayerEntity(strCreateString, strCreateString2, uri, uri2, j2, i, j3, strCreateString3, strCreateString4, strCreateString5, mostRecentGameInfoEntity, playerLevelInfo, z, z2, strCreateString6, strCreateString7, uri3, strCreateString8, uri4, strCreateString9, j, zzoVar, zzaVar, z3, strCreateString10);
    }
}
