package com.google.android.gms.games.internal;

import android.os.Parcel;
import android.os.RemoteException;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.common.data.DataHolder;
import com.google.android.gms.drive.Contents;
import com.google.android.gms.games.GamesActivityResultCodes;
import com.google.firebase.FirebaseError;
import com.googleplayservice.GooglePlayManager;
import java.util.ArrayList;

public abstract class zzai extends com.google.android.gms.internal.games_v2.zzb implements zzaj {
    public zzai() {
        super("com.google.android.gms.games.internal.IGamesCallbacks");
    }

    @Override
    protected final boolean zza(int i, Parcel parcel, Parcel parcel2, int i2) throws RemoteException {
        if (i == 6001 || i == 6002) {
            parcel.readString();
            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
        } else if (i == 12011) {
            DataHolder dataHolder = (DataHolder) com.google.android.gms.internal.games_v2.zzc.zzb(parcel, DataHolder.CREATOR);
            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
            zzc(dataHolder);
        } else if (i == 12012) {
            int i3 = parcel.readInt();
            String string = parcel.readString();
            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
            zzp(i3, string);
        } else if (i == 13001) {
            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
        } else if (i == 13002) {
            parcel.readInt();
            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
        } else if (i == 19001) {
            parcel.readInt();
            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
        } else if (i != 19002) {
            switch (i) {
                case 5001:
                    parcel.readInt();
                    parcel.readString();
                    com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                    break;
                case 5002:
                    DataHolder dataHolder2 = (DataHolder) com.google.android.gms.internal.games_v2.zzc.zzb(parcel, DataHolder.CREATOR);
                    com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                    zzb(dataHolder2);
                    break;
                case 5003:
                    int i4 = parcel.readInt();
                    String string2 = parcel.readString();
                    com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                    zzd(i4, string2);
                    break;
                case 5004:
                    DataHolder dataHolder3 = (DataHolder) com.google.android.gms.internal.games_v2.zzc.zzb(parcel, DataHolder.CREATOR);
                    com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                    zze(dataHolder3);
                    break;
                case 5005:
                    DataHolder dataHolder4 = (DataHolder) com.google.android.gms.internal.games_v2.zzc.zzb(parcel, DataHolder.CREATOR);
                    DataHolder dataHolder5 = (DataHolder) com.google.android.gms.internal.games_v2.zzc.zzb(parcel, DataHolder.CREATOR);
                    com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                    zzf(dataHolder4, dataHolder5);
                    break;
                case 5006:
                    DataHolder dataHolder6 = (DataHolder) com.google.android.gms.internal.games_v2.zzc.zzb(parcel, DataHolder.CREATOR);
                    com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                    zzg(dataHolder6);
                    break;
                case 5007:
                    DataHolder dataHolder7 = (DataHolder) com.google.android.gms.internal.games_v2.zzc.zzb(parcel, DataHolder.CREATOR);
                    com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                    zzh(dataHolder7);
                    break;
                case 5008:
                    DataHolder dataHolder8 = (DataHolder) com.google.android.gms.internal.games_v2.zzc.zzb(parcel, DataHolder.CREATOR);
                    com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                    zzi(dataHolder8);
                    break;
                case 5009:
                    com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                    break;
                case 5010:
                    com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                    break;
                case 5011:
                    com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                    break;
                default:
                    switch (i) {
                        case 5016:
                            zzj();
                            break;
                        case 5017:
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 5018:
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 5019:
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 5020:
                            parcel.readInt();
                            parcel.readString();
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 5021:
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 5022:
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 5023:
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 5024:
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 5025:
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 5026:
                            parcel.createStringArray();
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 5027:
                            parcel.createStringArray();
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 5028:
                            parcel.createStringArray();
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 5029:
                            parcel.createStringArray();
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 5030:
                            parcel.createStringArray();
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 5031:
                            parcel.createStringArray();
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 5032:
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 5033:
                            parcel.readInt();
                            parcel.readInt();
                            parcel.readString();
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 5034:
                            parcel.readInt();
                            parcel.readString();
                            com.google.android.gms.internal.games_v2.zzc.zza(parcel);
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 5035:
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 5036:
                            parcel.readInt();
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 5037:
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 5038:
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 5039:
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 5040:
                            parcel.readInt();
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case GooglePlayManager.GP_SIGN_IN:
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 11001:
                            parcel.readInt();
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 12001:
                            DataHolder dataHolder9 = (DataHolder) com.google.android.gms.internal.games_v2.zzc.zzb(parcel, DataHolder.CREATOR);
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            zzl(dataHolder9);
                            break;
                        case 14001:
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 15001:
                            DataHolder dataHolder10 = (DataHolder) com.google.android.gms.internal.games_v2.zzc.zzb(parcel, DataHolder.CREATOR);
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            zzq(dataHolder10);
                            break;
                        case FirebaseError.ERROR_CUSTOM_TOKEN_MISMATCH:
                            parcel.readInt();
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 19008:
                            parcel.readInt();
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 19009:
                            parcel.readInt();
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 19010:
                            parcel.readInt();
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 20001:
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 20002:
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 20003:
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 20004:
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 20005:
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 20006:
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 20007:
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 20008:
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 20009:
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 20012:
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 20019:
                            parcel.readInt();
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 20020:
                            parcel.readInt();
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 23001:
                            parcel.readInt();
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 23002:
                            parcel.readInt();
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 23003:
                            parcel.readInt();
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 23004:
                            parcel.readInt();
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 23005:
                            parcel.readInt();
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 24002:
                            com.google.android.gms.internal.games_v2.zzc.zza(parcel);
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 25002:
                            parcel.readString();
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 25003:
                            Status status = (Status) com.google.android.gms.internal.games_v2.zzc.zzb(parcel, Status.CREATOR);
                            String string3 = parcel.readString();
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            zzr(status, string3);
                            break;
                        case 25004:
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 25005:
                            parcel.readInt();
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 25006:
                            parcel.readInt();
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            break;
                        case 25007:
                            Status status2 = (Status) com.google.android.gms.internal.games_v2.zzc.zzb(parcel, Status.CREATOR);
                            String string4 = parcel.readString();
                            ArrayList<String> arrayListCreateStringArrayList = parcel.createStringArrayList();
                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                            zzs(status2, string4, arrayListCreateStringArrayList);
                            break;
                        default:
                            switch (i) {
                                case 8001:
                                    DataHolder dataHolder11 = (DataHolder) com.google.android.gms.internal.games_v2.zzc.zzb(parcel, DataHolder.CREATOR);
                                    com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                                    zzk(dataHolder11);
                                    break;
                                case 8002:
                                    parcel.readInt();
                                    com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                                    break;
                                case 8003:
                                    com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                                    break;
                                case 8004:
                                    com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                                    break;
                                case 8005:
                                    com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                                    break;
                                case 8006:
                                    com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                                    break;
                                case 8007:
                                    parcel.readInt();
                                    parcel.readString();
                                    com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                                    break;
                                case 8008:
                                    com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                                    break;
                                case 8009:
                                    parcel.readString();
                                    com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                                    break;
                                case 8010:
                                    parcel.readString();
                                    com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                                    break;
                                default:
                                    switch (i) {
                                        case GamesActivityResultCodes.RESULT_RECONNECT_REQUIRED:
                                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                                            break;
                                        case GamesActivityResultCodes.RESULT_SIGN_IN_FAILED:
                                            parcel.readString();
                                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                                            break;
                                        case GamesActivityResultCodes.RESULT_LICENSE_FAILED:
                                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                                            break;
                                        case GamesActivityResultCodes.RESULT_APP_MISCONFIGURED:
                                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                                            break;
                                        case 10005:
                                            parcel.readInt();
                                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                                            break;
                                        case GamesActivityResultCodes.RESULT_NETWORK_FAILURE:
                                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                                            break;
                                        default:
                                            switch (i) {
                                                case 12004:
                                                    DataHolder dataHolder12 = (DataHolder) com.google.android.gms.internal.games_v2.zzc.zzb(parcel, DataHolder.CREATOR);
                                                    Contents contents = (Contents) com.google.android.gms.internal.games_v2.zzc.zzb(parcel, Contents.CREATOR);
                                                    com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                                                    zzm(dataHolder12, contents);
                                                    break;
                                                case 12005:
                                                    DataHolder dataHolder13 = (DataHolder) com.google.android.gms.internal.games_v2.zzc.zzb(parcel, DataHolder.CREATOR);
                                                    com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                                                    zzo(dataHolder13);
                                                    break;
                                                case 12006:
                                                    com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                                                    break;
                                                case 12007:
                                                    com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                                                    break;
                                                case 12008:
                                                    com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                                                    break;
                                                default:
                                                    switch (i) {
                                                        case 12014:
                                                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                                                            break;
                                                        case 12015:
                                                            parcel.readInt();
                                                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                                                            break;
                                                        case 12016:
                                                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                                                            break;
                                                        case 12017:
                                                            DataHolder dataHolder14 = (DataHolder) com.google.android.gms.internal.games_v2.zzc.zzb(parcel, DataHolder.CREATOR);
                                                            String string5 = parcel.readString();
                                                            Contents contents2 = (Contents) com.google.android.gms.internal.games_v2.zzc.zzb(parcel, Contents.CREATOR);
                                                            Contents contents3 = (Contents) com.google.android.gms.internal.games_v2.zzc.zzb(parcel, Contents.CREATOR);
                                                            Contents contents4 = (Contents) com.google.android.gms.internal.games_v2.zzc.zzb(parcel, Contents.CREATOR);
                                                            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
                                                            zzn(dataHolder14, string5, contents2, contents3, contents4);
                                                            break;
                                                        default:
                                                            return false;
                                                    }
                                                    break;
                                            }
                                            break;
                                    }
                                    break;
                            }
                            break;
                    }
                    break;
            }
        } else {
            parcel.readInt();
            com.google.android.gms.internal.games_v2.zzc.zza(parcel);
            com.google.android.gms.internal.games_v2.zzc.zze(parcel);
        }
        parcel2.writeNoException();
        return true;
    }
}
