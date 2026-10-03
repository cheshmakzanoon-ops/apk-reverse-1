package com.google.android.gms.measurement.internal;

import android.content.Context;
import android.net.Uri;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;
import android.text.TextUtils;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.common.internal.safeparcel.SafeParcelReader;
import com.google.android.gms.common.util.Clock;
import com.google.android.gms.internal.measurement.zznp;
import com.google.android.gms.internal.measurement.zzpg;
import com.google.android.gms.internal.measurement.zzps;
import com.google.android.gms.measurement.api.AppMeasurementSdk;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.BitSet;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.zip.GZIPInputStream;
import java.util.zip.GZIPOutputStream;
import org.checkerframework.dataflow.qual.Pure;

public final class zzmz extends zzmo {
    @Override
    protected final boolean zzc() {
        return false;
    }

    static int zza(com.google.android.gms.internal.measurement.zzfi.zzj.zza zzaVar, String str) {
        if (zzaVar == null) {
            return -1;
        }
        for (int i = 0; i < zzaVar.zzb(); i++) {
            if (str.equals(zzaVar.zzj(i).zzg())) {
                return i;
            }
        }
        return -1;
    }

    final long zza(String str) {
        if (TextUtils.isEmpty(str)) {
            return 0L;
        }
        return zza(str.getBytes(Charset.forName("UTF-8")));
    }

    final long zza(byte[] bArr) {
        Preconditions.checkNotNull(bArr);
        zzq().zzt();
        MessageDigest messageDigestZzu = zznd.zzu();
        if (messageDigestZzu == null) {
            zzj().zzg().zza("Failed to get MD5");
            return 0L;
        }
        return zznd.zza(messageDigestZzu.digest(bArr));
    }

    @Override
    @Pure
    public final Context zza() {
        return super.zza();
    }

    private final Bundle zza(Map<String, Object> map, boolean z) {
        Bundle bundle = new Bundle();
        for (String str : map.keySet()) {
            Object obj = map.get(str);
            if (obj == null) {
                bundle.putString(str, null);
            } else if (obj instanceof Long) {
                bundle.putLong(str, ((Long) obj).longValue());
            } else if (obj instanceof Double) {
                bundle.putDouble(str, ((Double) obj).doubleValue());
            } else if (!(obj instanceof ArrayList)) {
                bundle.putString(str, obj.toString());
            } else if (z) {
                ArrayList arrayList = (ArrayList) obj;
                ArrayList arrayList2 = new ArrayList();
                int size = arrayList.size();
                int i = 0;
                while (i < size) {
                    Object obj2 = arrayList.get(i);
                    i++;
                    arrayList2.add(zza((Map<String, Object>) obj2, false));
                }
                bundle.putParcelableArray(str, (Parcelable[]) arrayList2.toArray(new Parcelable[0]));
            }
        }
        return bundle;
    }

    final <T extends Parcelable> T zza(byte[] bArr, Parcelable.Creator<T> creator) {
        if (bArr == null) {
            return null;
        }
        Parcel parcelObtain = Parcel.obtain();
        try {
            parcelObtain.unmarshall(bArr, 0, bArr.length);
            parcelObtain.setDataPosition(0);
            return creator.createFromParcel(parcelObtain);
        } catch (SafeParcelReader.ParseException unused) {
            zzj().zzg().zza("Failed to load parcelable from buffer");
            return null;
        } finally {
            parcelObtain.recycle();
        }
    }

    @Override
    @Pure
    public final Clock zzb() {
        return super.zzb();
    }

    @Override
    public final zzt zzg() {
        return super.zzg();
    }

    @Override
    @Pure
    public final zzae zzd() {
        return super.zzd();
    }

    @Override
    @Pure
    public final zzaf zze() {
        return super.zze();
    }

    @Override
    public final zzao zzh() {
        return super.zzh();
    }

    @Override
    @Pure
    public final zzba zzf() {
        return super.zzf();
    }

    final zzbg zza(com.google.android.gms.internal.measurement.zzad zzadVar) {
        String string;
        Object obj;
        Bundle bundleZza = zza(zzadVar.zzc(), true);
        if (bundleZza.containsKey("_o") && (obj = bundleZza.get("_o")) != null) {
            string = obj.toString();
        } else {
            string = "app";
        }
        String str = string;
        String strZzb = zzii.zzb(zzadVar.zzb());
        if (strZzb == null) {
            strZzb = zzadVar.zzb();
        }
        return new zzbg(strZzb, new zzbb(bundleZza), str, zzadVar.zza());
    }

    @Override
    @Pure
    public final zzfq zzi() {
        return super.zzi();
    }

    @Override
    @Pure
    public final zzfr zzj() {
        return super.zzj();
    }

    @Override
    @Pure
    public final zzgd zzk() {
        return super.zzk();
    }

    @Override
    public final zzgp zzm() {
        return super.zzm();
    }

    @Override
    @Pure
    public final zzgy zzl() {
        return super.zzl();
    }

    @Override
    public final zzls zzn() {
        return super.zzn();
    }

    final zzmh zza(String str, com.google.android.gms.internal.measurement.zzfi.zzj zzjVar, com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar, String str2) throws Throwable {
        int iIndexOf;
        if (!zzpg.zza() || !zze().zze(str, zzbi.zzcf)) {
            return null;
        }
        long jCurrentTimeMillis = zzb().currentTimeMillis();
        String[] strArrSplit = zze().zzd(str, zzbi.zzbb).split(",");
        HashSet hashSet = new HashSet(strArrSplit.length);
        for (String str3 : strArrSplit) {
            str3.getClass();
            if (!hashSet.add(str3)) {
                throw new IllegalArgumentException("duplicate element: " + ((Object) str3));
            }
        }
        Set setUnmodifiableSet = Collections.unmodifiableSet(hashSet);
        zzmn zzmnVarZzo = zzo();
        String strZzf = zzmnVarZzo.zzm().zzf(str);
        Uri.Builder builder = new Uri.Builder();
        builder.scheme(zzmnVarZzo.zze().zzd(str, zzbi.zzav));
        if (!TextUtils.isEmpty(strZzf)) {
            builder.authority(strZzf + "." + zzmnVarZzo.zze().zzd(str, zzbi.zzaw));
        } else {
            builder.authority(zzmnVarZzo.zze().zzd(str, zzbi.zzaw));
        }
        builder.path(zzmnVarZzo.zze().zzd(str, zzbi.zzax));
        zza(builder, "gmp_app_id", zzjVar.zzah(), (Set<String>) setUnmodifiableSet);
        zza(builder, "gmp_version", "82001", (Set<String>) setUnmodifiableSet);
        String strZzy = zzjVar.zzy();
        String str4 = "";
        if (zze().zze(str, zzbi.zzci) && zzm().zzp(str)) {
            strZzy = "";
        }
        zza(builder, "app_instance_id", strZzy, (Set<String>) setUnmodifiableSet);
        zza(builder, "rdid", zzjVar.zzal(), (Set<String>) setUnmodifiableSet);
        zza(builder, "bundle_id", zzjVar.zzx(), (Set<String>) setUnmodifiableSet);
        String strZze = zzaVar.zze();
        String strZza = zzii.zza(strZze);
        if (!TextUtils.isEmpty(strZza)) {
            strZze = strZza;
        }
        zza(builder, "app_event_name", strZze, (Set<String>) setUnmodifiableSet);
        zza(builder, "app_version", String.valueOf(zzjVar.zzb()), (Set<String>) setUnmodifiableSet);
        String strZzaj = zzjVar.zzaj();
        if (!zze().zze(str, zzbi.zzci) || !zzm().zzt(str)) {
            str4 = strZzaj;
        } else if (zze().zze(str, zzbi.zzbv)) {
            if (!TextUtils.isEmpty(strZzaj) && (iIndexOf = strZzaj.indexOf(".")) != -1) {
                strZzaj = strZzaj.substring(0, iIndexOf);
            }
            str4 = strZzaj;
        }
        zza(builder, "os_version", str4, (Set<String>) setUnmodifiableSet);
        zza(builder, "timestamp", String.valueOf(zzaVar.zzc()), (Set<String>) setUnmodifiableSet);
        if (zzjVar.zzat()) {
            zza(builder, "lat", "1", (Set<String>) setUnmodifiableSet);
        }
        zza(builder, "privacy_sandbox_version", String.valueOf(zzjVar.zza()), (Set<String>) setUnmodifiableSet);
        zza(builder, "trigger_uri_source", "1", (Set<String>) setUnmodifiableSet);
        zza(builder, "trigger_uri_timestamp", String.valueOf(jCurrentTimeMillis), (Set<String>) setUnmodifiableSet);
        if (str2 != null) {
            zza(builder, "request_uuid", str2, (Set<String>) setUnmodifiableSet);
        }
        List<com.google.android.gms.internal.measurement.zzfi.zzg> listZzf = zzaVar.zzf();
        Bundle bundle = new Bundle();
        for (com.google.android.gms.internal.measurement.zzfi.zzg zzgVar : listZzf) {
            String strZzg = zzgVar.zzg();
            if (zzgVar.zzj()) {
                bundle.putString(strZzg, String.valueOf(zzgVar.zza()));
            } else if (zzgVar.zzk()) {
                bundle.putString(strZzg, String.valueOf(zzgVar.zzb()));
            } else if (zzgVar.zzn()) {
                bundle.putString(strZzg, zzgVar.zzh());
            } else if (zzgVar.zzl()) {
                bundle.putString(strZzg, String.valueOf(zzgVar.zzd()));
            }
        }
        zza(builder, zze().zzd(str, zzbi.zzba).split("\\|"), bundle, (Set<String>) setUnmodifiableSet);
        List<com.google.android.gms.internal.measurement.zzfi.zzn> listZzaq = zzjVar.zzaq();
        Bundle bundle2 = new Bundle();
        for (com.google.android.gms.internal.measurement.zzfi.zzn zznVar : listZzaq) {
            String strZzg2 = zznVar.zzg();
            if (zznVar.zzi()) {
                bundle2.putString(strZzg2, String.valueOf(zznVar.zza()));
            } else if (zznVar.zzj()) {
                bundle2.putString(strZzg2, String.valueOf(zznVar.zzb()));
            } else if (zznVar.zzm()) {
                bundle2.putString(strZzg2, zznVar.zzh());
            } else if (zznVar.zzk()) {
                bundle2.putString(strZzg2, String.valueOf(zznVar.zzc()));
            }
        }
        zza(builder, zze().zzd(str, zzbi.zzaz).split("\\|"), bundle2, (Set<String>) setUnmodifiableSet);
        if (zznp.zza() && zze().zza(zzbi.zzcm)) {
            zza(builder, "dma", zzjVar.zzas() ? "1" : "0", (Set<String>) setUnmodifiableSet);
            if (!zzjVar.zzad().isEmpty()) {
                zza(builder, "dma_cps", zzjVar.zzad(), (Set<String>) setUnmodifiableSet);
            }
        }
        return new zzmh(builder.build().toString(), jCurrentTimeMillis, 1);
    }

    @Override
    public final zzmn zzo() {
        return super.zzo();
    }

    @Override
    public final zzmz mo32g_() {
        return super.mo32g_();
    }

    @Override
    @Pure
    public final zznd zzq() {
        return super.zzq();
    }

    final com.google.android.gms.internal.measurement.zzfi.zze zza(zzaz zzazVar) {
        com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVarZza = com.google.android.gms.internal.measurement.zzfi.zze.zze().zza(zzazVar.zzd);
        for (String str : zzazVar.zze) {
            com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVarZza2 = com.google.android.gms.internal.measurement.zzfi.zzg.zze().zza(str);
            Object objZzc = zzazVar.zze.zzc(str);
            Preconditions.checkNotNull(objZzc);
            zza(zzaVarZza2, objZzc);
            zzaVarZza.zza(zzaVarZza2);
        }
        return (com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) zzaVarZza.zzab());
    }

    static com.google.android.gms.internal.measurement.zzfi.zzg zza(com.google.android.gms.internal.measurement.zzfi.zze zzeVar, String str) {
        for (com.google.android.gms.internal.measurement.zzfi.zzg zzgVar : zzeVar.zzh()) {
            if (zzgVar.zzg().equals(str)) {
                return zzgVar;
            }
        }
        return null;
    }

    static <BuilderT extends com.google.android.gms.internal.measurement.zzkm> BuilderT zza(BuilderT buildert, byte[] bArr) throws com.google.android.gms.internal.measurement.zzji {
        com.google.android.gms.internal.measurement.zzik zzikVarZza = com.google.android.gms.internal.measurement.zzik.zza();
        if (zzikVarZza != null) {
            return (BuilderT) buildert.zza(bArr, zzikVarZza);
        }
        return (BuilderT) buildert.zza(bArr);
    }

    static Object zzb(com.google.android.gms.internal.measurement.zzfi.zze zzeVar, String str) {
        com.google.android.gms.internal.measurement.zzfi.zzg zzgVarZza = zza(zzeVar, str);
        if (zzgVarZza == null) {
            return null;
        }
        if (zzgVarZza.zzn()) {
            return zzgVarZza.zzh();
        }
        if (zzgVarZza.zzl()) {
            return Long.valueOf(zzgVarZza.zzd());
        }
        if (zzgVarZza.zzj()) {
            return Double.valueOf(zzgVarZza.zza());
        }
        if (zzgVarZza.zzc() <= 0) {
            return null;
        }
        List<com.google.android.gms.internal.measurement.zzfi.zzg> listZzi = zzgVarZza.zzi();
        ArrayList arrayList = new ArrayList();
        for (com.google.android.gms.internal.measurement.zzfi.zzg zzgVar : listZzi) {
            if (zzgVar != null) {
                Bundle bundle = new Bundle();
                for (com.google.android.gms.internal.measurement.zzfi.zzg zzgVar2 : zzgVar.zzi()) {
                    if (zzgVar2.zzn()) {
                        bundle.putString(zzgVar2.zzg(), zzgVar2.zzh());
                    } else if (zzgVar2.zzl()) {
                        bundle.putLong(zzgVar2.zzg(), zzgVar2.zzd());
                    } else if (zzgVar2.zzj()) {
                        bundle.putDouble(zzgVar2.zzg(), zzgVar2.zza());
                    }
                }
                if (!bundle.isEmpty()) {
                    arrayList.add(bundle);
                }
            }
        }
        return (Bundle[]) arrayList.toArray(new Bundle[arrayList.size()]);
    }

    final String zza(com.google.android.gms.internal.measurement.zzfi.zzi zziVar) {
        com.google.android.gms.internal.measurement.zzfi.zzb zzbVarZzt;
        if (zziVar == null) {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        sb.append("\nbatch {\n");
        for (com.google.android.gms.internal.measurement.zzfi.zzj zzjVar : zziVar.zzd()) {
            if (zzjVar != null) {
                zza(sb, 1);
                sb.append("bundle {\n");
                if (zzjVar.zzbk()) {
                    zza(sb, 1, "protocol_version", Integer.valueOf(zzjVar.zze()));
                }
                if (zzps.zza() && zze().zze(zzjVar.zzx(), zzbi.zzbt) && zzjVar.zzbn()) {
                    zza(sb, 1, "session_stitching_token", zzjVar.zzam());
                }
                zza(sb, 1, "platform", zzjVar.zzak());
                if (zzjVar.zzbf()) {
                    zza(sb, 1, "gmp_version", Long.valueOf(zzjVar.zzm()));
                }
                if (zzjVar.zzbs()) {
                    zza(sb, 1, "uploading_gmp_version", Long.valueOf(zzjVar.zzs()));
                }
                if (zzjVar.zzbd()) {
                    zza(sb, 1, "dynamite_version", Long.valueOf(zzjVar.zzk()));
                }
                if (zzjVar.zzay()) {
                    zza(sb, 1, "config_version", Long.valueOf(zzjVar.zzi()));
                }
                zza(sb, 1, "gmp_app_id", zzjVar.zzah());
                zza(sb, 1, "admob_app_id", zzjVar.zzw());
                zza(sb, 1, "app_id", zzjVar.zzx());
                zza(sb, 1, "app_version", zzjVar.zzaa());
                if (zzjVar.zzav()) {
                    zza(sb, 1, "app_version_major", Integer.valueOf(zzjVar.zzb()));
                }
                zza(sb, 1, "firebase_instance_id", zzjVar.zzag());
                if (zzjVar.zzbc()) {
                    zza(sb, 1, "dev_cert_hash", Long.valueOf(zzjVar.zzj()));
                }
                zza(sb, 1, "app_store", zzjVar.zzz());
                if (zzjVar.zzbr()) {
                    zza(sb, 1, "upload_timestamp_millis", Long.valueOf(zzjVar.zzr()));
                }
                if (zzjVar.zzbo()) {
                    zza(sb, 1, "start_timestamp_millis", Long.valueOf(zzjVar.zzp()));
                }
                if (zzjVar.zzbe()) {
                    zza(sb, 1, "end_timestamp_millis", Long.valueOf(zzjVar.zzl()));
                }
                if (zzjVar.zzbj()) {
                    zza(sb, 1, "previous_bundle_start_timestamp_millis", Long.valueOf(zzjVar.zzo()));
                }
                if (zzjVar.zzbi()) {
                    zza(sb, 1, "previous_bundle_end_timestamp_millis", Long.valueOf(zzjVar.zzn()));
                }
                zza(sb, 1, "app_instance_id", zzjVar.zzy());
                zza(sb, 1, "resettable_device_id", zzjVar.zzal());
                zza(sb, 1, "ds_id", zzjVar.zzaf());
                if (zzjVar.zzbh()) {
                    zza(sb, 1, "limited_ad_tracking", Boolean.valueOf(zzjVar.zzat()));
                }
                zza(sb, 1, "os_version", zzjVar.zzaj());
                zza(sb, 1, "device_model", zzjVar.zzae());
                zza(sb, 1, "user_default_language", zzjVar.zzan());
                if (zzjVar.zzbq()) {
                    zza(sb, 1, "time_zone_offset_minutes", Integer.valueOf(zzjVar.zzg()));
                }
                if (zzjVar.zzax()) {
                    zza(sb, 1, "bundle_sequential_index", Integer.valueOf(zzjVar.zzc()));
                }
                if (zzjVar.zzbm()) {
                    zza(sb, 1, "service_upload", Boolean.valueOf(zzjVar.zzau()));
                }
                zza(sb, 1, "health_monitor", zzjVar.zzai());
                if (zzjVar.zzbl()) {
                    zza(sb, 1, "retry_counter", Integer.valueOf(zzjVar.zzf()));
                }
                if (zzjVar.zzba()) {
                    zza(sb, 1, "consent_signals", zzjVar.zzac());
                }
                if (zzjVar.zzbg()) {
                    zza(sb, 1, "is_dma_region", Boolean.valueOf(zzjVar.zzas()));
                }
                if (zzjVar.zzbb()) {
                    zza(sb, 1, "core_platform_services", zzjVar.zzad());
                }
                if (zzjVar.zzaz()) {
                    zza(sb, 1, "consent_diagnostics", zzjVar.zzab());
                }
                if (zzjVar.zzbp()) {
                    zza(sb, 1, "target_os_version", Long.valueOf(zzjVar.zzq()));
                }
                if (zzpg.zza() && zze().zze(zzjVar.zzx(), zzbi.zzcf)) {
                    zza(sb, 1, "ad_services_version", Integer.valueOf(zzjVar.zza()));
                    if (zzjVar.zzaw() && (zzbVarZzt = zzjVar.zzt()) != null) {
                        zza(sb, 2);
                        sb.append("attribution_eligibility_status {\n");
                        zza(sb, 2, "eligible", Boolean.valueOf(zzbVarZzt.zzf()));
                        zza(sb, 2, "no_access_adservices_attribution_permission", Boolean.valueOf(zzbVarZzt.zzh()));
                        zza(sb, 2, "pre_r", Boolean.valueOf(zzbVarZzt.zzi()));
                        zza(sb, 2, "r_extensions_too_old", Boolean.valueOf(zzbVarZzt.zzj()));
                        zza(sb, 2, "adservices_extension_too_old", Boolean.valueOf(zzbVarZzt.zze()));
                        zza(sb, 2, "ad_storage_not_allowed", Boolean.valueOf(zzbVarZzt.zzd()));
                        zza(sb, 2, "measurement_manager_disabled", Boolean.valueOf(zzbVarZzt.zzg()));
                        zza(sb, 2);
                        sb.append("}\n");
                    }
                }
                List<com.google.android.gms.internal.measurement.zzfi.zzn> listZzaq = zzjVar.zzaq();
                if (listZzaq != null) {
                    for (com.google.android.gms.internal.measurement.zzfi.zzn zznVar : listZzaq) {
                        if (zznVar != null) {
                            zza(sb, 2);
                            sb.append("user_property {\n");
                            zza(sb, 2, "set_timestamp_millis", zznVar.zzl() ? Long.valueOf(zznVar.zzd()) : null);
                            zza(sb, 2, AppMeasurementSdk.ConditionalUserProperty.NAME, zzi().zzc(zznVar.zzg()));
                            zza(sb, 2, "string_value", zznVar.zzh());
                            zza(sb, 2, "int_value", zznVar.zzk() ? Long.valueOf(zznVar.zzc()) : null);
                            zza(sb, 2, "double_value", zznVar.zzi() ? Double.valueOf(zznVar.zza()) : null);
                            zza(sb, 2);
                            sb.append("}\n");
                        }
                    }
                }
                List<com.google.android.gms.internal.measurement.zzfi.zzc> listZzao = zzjVar.zzao();
                zzjVar.zzx();
                if (listZzao != null) {
                    for (com.google.android.gms.internal.measurement.zzfi.zzc zzcVar : listZzao) {
                        if (zzcVar != null) {
                            zza(sb, 2);
                            sb.append("audience_membership {\n");
                            if (zzcVar.zzg()) {
                                zza(sb, 2, "audience_id", Integer.valueOf(zzcVar.zza()));
                            }
                            if (zzcVar.zzh()) {
                                zza(sb, 2, "new_audience", Boolean.valueOf(zzcVar.zzf()));
                            }
                            zza(sb, 2, "current_data", zzcVar.zzd());
                            if (zzcVar.zzi()) {
                                zza(sb, 2, "previous_data", zzcVar.zze());
                            }
                            zza(sb, 2);
                            sb.append("}\n");
                        }
                    }
                }
                List<com.google.android.gms.internal.measurement.zzfi.zze> listZzap = zzjVar.zzap();
                if (listZzap != null) {
                    for (com.google.android.gms.internal.measurement.zzfi.zze zzeVar : listZzap) {
                        if (zzeVar != null) {
                            zza(sb, 2);
                            sb.append("event {\n");
                            zza(sb, 2, AppMeasurementSdk.ConditionalUserProperty.NAME, zzi().zza(zzeVar.zzg()));
                            if (zzeVar.zzk()) {
                                zza(sb, 2, "timestamp_millis", Long.valueOf(zzeVar.zzd()));
                            }
                            if (zzeVar.zzj()) {
                                zza(sb, 2, "previous_timestamp_millis", Long.valueOf(zzeVar.zzc()));
                            }
                            if (zzeVar.zzi()) {
                                zza(sb, 2, "count", Integer.valueOf(zzeVar.zza()));
                            }
                            if (zzeVar.zzb() != 0) {
                                zza(sb, 2, zzeVar.zzh());
                            }
                            zza(sb, 2);
                            sb.append("}\n");
                        }
                    }
                }
                zza(sb, 1);
                sb.append("}\n");
            }
        }
        sb.append("}\n");
        return sb.toString();
    }

    final String zza(com.google.android.gms.internal.measurement.zzew.zzb zzbVar) {
        if (zzbVar == null) {
            return "null";
        }
        StringBuilder sb = new StringBuilder();
        sb.append("\nevent_filter {\n");
        if (zzbVar.zzl()) {
            zza(sb, 0, "filter_id", Integer.valueOf(zzbVar.zzb()));
        }
        zza(sb, 0, "event_name", zzi().zza(zzbVar.zzf()));
        String strZza = zza(zzbVar.zzh(), zzbVar.zzi(), zzbVar.zzj());
        if (!strZza.isEmpty()) {
            zza(sb, 0, "filter_type", strZza);
        }
        if (zzbVar.zzk()) {
            zza(sb, 1, "event_count_filter", zzbVar.zze());
        }
        if (zzbVar.zza() > 0) {
            sb.append("  filters {\n");
            Iterator<com.google.android.gms.internal.measurement.zzew.zzc> it = zzbVar.zzg().iterator();
            while (it.hasNext()) {
                zza(sb, 2, it.next());
            }
        }
        zza(sb, 1);
        sb.append("}\n}\n");
        return sb.toString();
    }

    private static String zza(boolean z, boolean z2, boolean z3) {
        StringBuilder sb = new StringBuilder();
        if (z) {
            sb.append("Dynamic ");
        }
        if (z2) {
            sb.append("Sequence ");
        }
        if (z3) {
            sb.append("Session-Scoped ");
        }
        return sb.toString();
    }

    final String zza(com.google.android.gms.internal.measurement.zzew.zze zzeVar) {
        if (zzeVar == null) {
            return "null";
        }
        StringBuilder sb = new StringBuilder();
        sb.append("\nproperty_filter {\n");
        if (zzeVar.zzi()) {
            zza(sb, 0, "filter_id", Integer.valueOf(zzeVar.zza()));
        }
        zza(sb, 0, "property_name", zzi().zzc(zzeVar.zze()));
        String strZza = zza(zzeVar.zzf(), zzeVar.zzg(), zzeVar.zzh());
        if (!strZza.isEmpty()) {
            zza(sb, 0, "filter_type", strZza);
        }
        zza(sb, 1, zzeVar.zzb());
        sb.append("}\n");
        return sb.toString();
    }

    final List<Long> zza(List<Long> list, List<Integer> list2) {
        int i;
        ArrayList arrayList = new ArrayList(list);
        for (Integer num : list2) {
            if (num.intValue() < 0) {
                zzj().zzu().zza("Ignoring negative bit index to be cleared", num);
            } else {
                int iIntValue = num.intValue() / 64;
                if (iIntValue >= arrayList.size()) {
                    zzj().zzu().zza("Ignoring bit index greater than bitSet size", num, Integer.valueOf(arrayList.size()));
                } else {
                    arrayList.set(iIntValue, Long.valueOf(((Long) arrayList.get(iIntValue)).longValue() & (~(1 << (num.intValue() % 64)))));
                }
            }
        }
        int size = arrayList.size();
        int size2 = arrayList.size() - 1;
        while (true) {
            int i2 = size2;
            i = size;
            size = i2;
            if (size < 0 || ((Long) arrayList.get(size)).longValue() != 0) {
                break;
            }
            size2 = size - 1;
        }
        return arrayList.subList(0, i);
    }

    final List<Integer> zzu() {
        Map<String, String> mapZza = zzbi.zza(this.zzf.zza());
        if (mapZza == null || mapZza.isEmpty()) {
            return null;
        }
        ArrayList arrayList = new ArrayList();
        int iIntValue = zzbi.zzap.zza(null).intValue();
        for (Map.Entry<String, String> entry : mapZza.entrySet()) {
            if (entry.getKey().startsWith("measurement.id.")) {
                try {
                    int i = Integer.parseInt(entry.getValue());
                    if (i != 0) {
                        arrayList.add(Integer.valueOf(i));
                        if (arrayList.size() >= iIntValue) {
                            zzj().zzu().zza("Too many experiment IDs. Number of IDs", Integer.valueOf(arrayList.size()));
                            break;
                        }
                        continue;
                    } else {
                        continue;
                    }
                } catch (NumberFormatException e) {
                    zzj().zzu().zza("Experiment ID NumberFormatException", e);
                }
            }
        }
        if (arrayList.isEmpty()) {
            return null;
        }
        return arrayList;
    }

    static List<Long> zza(BitSet bitSet) {
        int length = (bitSet.length() + 63) / 64;
        ArrayList arrayList = new ArrayList(length);
        for (int i = 0; i < length; i++) {
            long j = 0;
            for (int i2 = 0; i2 < 64; i2++) {
                int i3 = (i << 6) + i2;
                if (i3 >= bitSet.length()) {
                    break;
                }
                if (bitSet.get(i3)) {
                    j |= 1 << i2;
                }
            }
            arrayList.add(Long.valueOf(j));
        }
        return arrayList;
    }

    final Map<String, Object> zza(Bundle bundle, boolean z) {
        HashMap map = new HashMap();
        for (String str : bundle.keySet()) {
            Object obj = bundle.get(str);
            boolean z2 = obj instanceof Parcelable[];
            if (z2 || (obj instanceof ArrayList) || (obj instanceof Bundle)) {
                if (z) {
                    ArrayList arrayList = new ArrayList();
                    if (z2) {
                        for (Parcelable parcelable : (Parcelable[]) obj) {
                            if (parcelable instanceof Bundle) {
                                arrayList.add(zza((Bundle) parcelable, false));
                            }
                        }
                    } else if (obj instanceof ArrayList) {
                        ArrayList arrayList2 = (ArrayList) obj;
                        int size = arrayList2.size();
                        int i = 0;
                        while (i < size) {
                            Object obj2 = arrayList2.get(i);
                            i++;
                            if (obj2 instanceof Bundle) {
                                arrayList.add(zza((Bundle) obj2, false));
                            }
                        }
                    } else if (obj instanceof Bundle) {
                        arrayList.add(zza((Bundle) obj, false));
                    }
                    map.put(str, arrayList);
                }
            } else if (obj != null) {
                map.put(str, obj);
            }
        }
        return map;
    }

    zzmz(zzmp zzmpVar) {
        super(zzmpVar);
    }

    static void zza(com.google.android.gms.internal.measurement.zzfi.zze.zza zzaVar, String str, Object obj) {
        List<com.google.android.gms.internal.measurement.zzfi.zzg> listZzf = zzaVar.zzf();
        int i = 0;
        while (true) {
            if (i >= listZzf.size()) {
                i = -1;
                break;
            } else if (str.equals(listZzf.get(i).zzg())) {
                break;
            } else {
                i++;
            }
        }
        com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVarZza = com.google.android.gms.internal.measurement.zzfi.zzg.zze().zza(str);
        if (obj instanceof Long) {
            zzaVarZza.zza(((Long) obj).longValue());
        } else if (obj instanceof String) {
            zzaVarZza.zzb((String) obj);
        } else if (obj instanceof Double) {
            zzaVarZza.zza(((Double) obj).doubleValue());
        }
        if (i >= 0) {
            zzaVar.zza(i, zzaVarZza);
        } else {
            zzaVar.zza(zzaVarZza);
        }
    }

    private static void zza(Uri.Builder builder, String[] strArr, Bundle bundle, Set<String> set) {
        for (String str : strArr) {
            String[] strArrSplit = str.split(",");
            String str2 = strArrSplit[0];
            String str3 = strArrSplit[strArrSplit.length - 1];
            String string = bundle.getString(str2);
            if (string != null) {
                zza(builder, str3, string, set);
            }
        }
    }

    private static void zza(StringBuilder sb, int i, String str, com.google.android.gms.internal.measurement.zzfi.zzl zzlVar) {
        if (zzlVar == null) {
            return;
        }
        zza(sb, 3);
        sb.append(str);
        sb.append(" {\n");
        if (zzlVar.zzb() != 0) {
            zza(sb, 4);
            sb.append("results: ");
            int i2 = 0;
            for (Long l : zzlVar.zzi()) {
                int i3 = i2 + 1;
                if (i2 != 0) {
                    sb.append(", ");
                }
                sb.append(l);
                i2 = i3;
            }
            sb.append('\n');
        }
        if (zzlVar.zzd() != 0) {
            zza(sb, 4);
            sb.append("status: ");
            int i4 = 0;
            for (Long l2 : zzlVar.zzk()) {
                int i5 = i4 + 1;
                if (i4 != 0) {
                    sb.append(", ");
                }
                sb.append(l2);
                i4 = i5;
            }
            sb.append('\n');
        }
        if (zzlVar.zza() != 0) {
            zza(sb, 4);
            sb.append("dynamic_filter_timestamps: {");
            int i6 = 0;
            for (com.google.android.gms.internal.measurement.zzfi.zzd zzdVar : zzlVar.zzh()) {
                int i7 = i6 + 1;
                if (i6 != 0) {
                    sb.append(", ");
                }
                sb.append(zzdVar.zzf() ? Integer.valueOf(zzdVar.zza()) : null);
                sb.append(":");
                sb.append(zzdVar.zze() ? Long.valueOf(zzdVar.zzb()) : null);
                i6 = i7;
            }
            sb.append("}\n");
        }
        if (zzlVar.zzc() != 0) {
            zza(sb, 4);
            sb.append("sequence_filter_timestamps: {");
            int i8 = 0;
            for (com.google.android.gms.internal.measurement.zzfi.zzm zzmVar : zzlVar.zzj()) {
                int i9 = i8 + 1;
                if (i8 != 0) {
                    sb.append(", ");
                }
                sb.append(zzmVar.zzf() ? Integer.valueOf(zzmVar.zzb()) : null);
                sb.append(": [");
                Iterator<Long> it = zzmVar.zze().iterator();
                int i10 = 0;
                while (it.hasNext()) {
                    long jLongValue = it.next().longValue();
                    int i11 = i10 + 1;
                    if (i10 != 0) {
                        sb.append(", ");
                    }
                    sb.append(jLongValue);
                    i10 = i11;
                }
                sb.append("]");
                i8 = i9;
            }
            sb.append("}\n");
        }
        zza(sb, 3);
        sb.append("}\n");
    }

    private final void zza(StringBuilder sb, int i, List<com.google.android.gms.internal.measurement.zzfi.zzg> list) {
        if (list == null) {
            return;
        }
        int i2 = i + 1;
        for (com.google.android.gms.internal.measurement.zzfi.zzg zzgVar : list) {
            if (zzgVar != null) {
                zza(sb, i2);
                sb.append("param {\n");
                zza(sb, i2, AppMeasurementSdk.ConditionalUserProperty.NAME, zzgVar.zzm() ? zzi().zzb(zzgVar.zzg()) : null);
                zza(sb, i2, "string_value", zzgVar.zzn() ? zzgVar.zzh() : null);
                zza(sb, i2, "int_value", zzgVar.zzl() ? Long.valueOf(zzgVar.zzd()) : null);
                zza(sb, i2, "double_value", zzgVar.zzj() ? Double.valueOf(zzgVar.zza()) : null);
                if (zzgVar.zzc() > 0) {
                    zza(sb, i2, zzgVar.zzi());
                }
                zza(sb, i2);
                sb.append("}\n");
            }
        }
    }

    private final void zza(StringBuilder sb, int i, com.google.android.gms.internal.measurement.zzew.zzc zzcVar) {
        if (zzcVar == null) {
            return;
        }
        zza(sb, i);
        sb.append("filter {\n");
        if (zzcVar.zzg()) {
            zza(sb, i, "complement", Boolean.valueOf(zzcVar.zzf()));
        }
        if (zzcVar.zzi()) {
            zza(sb, i, "param_name", zzi().zzb(zzcVar.zze()));
        }
        if (zzcVar.zzj()) {
            int i2 = i + 1;
            com.google.android.gms.internal.measurement.zzew.zzf zzfVarZzd = zzcVar.zzd();
            if (zzfVarZzd != null) {
                zza(sb, i2);
                sb.append("string_filter");
                sb.append(" {\n");
                if (zzfVarZzd.zzj()) {
                    zza(sb, i2, "match_type", zzfVarZzd.zzb().name());
                }
                if (zzfVarZzd.zzi()) {
                    zza(sb, i2, "expression", zzfVarZzd.zze());
                }
                if (zzfVarZzd.zzh()) {
                    zza(sb, i2, "case_sensitive", Boolean.valueOf(zzfVarZzd.zzg()));
                }
                if (zzfVarZzd.zza() > 0) {
                    zza(sb, i + 2);
                    sb.append("expression_list {\n");
                    for (String str : zzfVarZzd.zzf()) {
                        zza(sb, i + 3);
                        sb.append(str);
                        sb.append("\n");
                    }
                    sb.append("}\n");
                }
                zza(sb, i2);
                sb.append("}\n");
            }
        }
        if (zzcVar.zzh()) {
            zza(sb, i + 1, "number_filter", zzcVar.zzc());
        }
        zza(sb, i);
        sb.append("}\n");
    }

    private static void zza(StringBuilder sb, int i) {
        for (int i2 = 0; i2 < i; i2++) {
            sb.append("  ");
        }
    }

    private static void zza(StringBuilder sb, int i, String str, com.google.android.gms.internal.measurement.zzew.zzd zzdVar) {
        if (zzdVar == null) {
            return;
        }
        zza(sb, i);
        sb.append(str);
        sb.append(" {\n");
        if (zzdVar.zzh()) {
            zza(sb, i, "comparison_type", zzdVar.zza().name());
        }
        if (zzdVar.zzj()) {
            zza(sb, i, "match_as_float", Boolean.valueOf(zzdVar.zzg()));
        }
        if (zzdVar.zzi()) {
            zza(sb, i, "comparison_value", zzdVar.zzd());
        }
        if (zzdVar.zzl()) {
            zza(sb, i, "min_comparison_value", zzdVar.zzf());
        }
        if (zzdVar.zzk()) {
            zza(sb, i, "max_comparison_value", zzdVar.zze());
        }
        zza(sb, i);
        sb.append("}\n");
    }

    private static void zza(Uri.Builder builder, String str, String str2, Set<String> set) {
        if (set.contains(str) || TextUtils.isEmpty(str2)) {
            return;
        }
        builder.appendQueryParameter(str, str2);
    }

    private static void zza(StringBuilder sb, int i, String str, Object obj) {
        if (obj == null) {
            return;
        }
        zza(sb, i + 1);
        sb.append(str);
        sb.append(": ");
        sb.append(obj);
        sb.append('\n');
    }

    @Override
    public final void zzr() {
        super.zzr();
    }

    @Override
    public final void zzs() {
        super.zzs();
    }

    @Override
    public final void zzt() {
        super.zzt();
    }

    final void zza(com.google.android.gms.internal.measurement.zzfi.zzj.zza zzaVar) {
        zzj().zzp().zza("Checking account type status for ad personalization signals");
        if (zzc(zzaVar.zzr())) {
            zzj().zzc().zza("Turning off ad personalization due to account type");
            com.google.android.gms.internal.measurement.zzfi.zzn zznVar = (com.google.android.gms.internal.measurement.zzfi.zzn) ((com.google.android.gms.internal.measurement.zzix) com.google.android.gms.internal.measurement.zzfi.zzn.zze().zza("_npa").zzb(zzf().zzc()).zza(1L).zzab());
            int i = 0;
            while (true) {
                if (i < zzaVar.zzb()) {
                    if ("_npa".equals(zzaVar.zzj(i).zzg())) {
                        zzaVar.zza(i, zznVar);
                        break;
                    }
                    i++;
                } else {
                    zzaVar.zza(zznVar);
                    break;
                }
            }
            if (zznp.zza() && zze().zza(zzbi.zzcm)) {
                zzak zzakVarZza = zzak.zza(zzaVar.zzs());
                zzakVarZza.zza(zzih.zza.AD_PERSONALIZATION, zzaj.CHILD_ACCOUNT);
                zzaVar.zzf(zzakVarZza.toString());
            }
        }
    }

    final void zza(com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVar, Object obj) {
        Preconditions.checkNotNull(obj);
        zzaVar.zze().zzc().zzb().zzd();
        if (obj instanceof String) {
            zzaVar.zzb((String) obj);
            return;
        }
        if (obj instanceof Long) {
            zzaVar.zza(((Long) obj).longValue());
            return;
        }
        if (obj instanceof Double) {
            zzaVar.zza(((Double) obj).doubleValue());
            return;
        }
        if (obj instanceof Bundle[]) {
            ArrayList arrayList = new ArrayList();
            for (Bundle bundle : (Bundle[]) obj) {
                if (bundle != null) {
                    com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVarZze = com.google.android.gms.internal.measurement.zzfi.zzg.zze();
                    for (String str : bundle.keySet()) {
                        com.google.android.gms.internal.measurement.zzfi.zzg.zza zzaVarZza = com.google.android.gms.internal.measurement.zzfi.zzg.zze().zza(str);
                        Object obj2 = bundle.get(str);
                        if (obj2 instanceof Long) {
                            zzaVarZza.zza(((Long) obj2).longValue());
                        } else if (obj2 instanceof String) {
                            zzaVarZza.zzb((String) obj2);
                        } else if (obj2 instanceof Double) {
                            zzaVarZza.zza(((Double) obj2).doubleValue());
                        }
                        zzaVarZze.zza(zzaVarZza);
                    }
                    if (zzaVarZze.zza() > 0) {
                        arrayList.add((com.google.android.gms.internal.measurement.zzfi.zzg) ((com.google.android.gms.internal.measurement.zzix) zzaVarZze.zzab()));
                    }
                }
            }
            zzaVar.zza(arrayList);
            return;
        }
        zzj().zzg().zza("Ignoring invalid (type) event param value", obj);
    }

    final void zza(com.google.android.gms.internal.measurement.zzfi.zzn.zza zzaVar, Object obj) {
        Preconditions.checkNotNull(obj);
        zzaVar.zzc().zzb().zza();
        if (obj instanceof String) {
            zzaVar.zzb((String) obj);
            return;
        }
        if (obj instanceof Long) {
            zzaVar.zza(((Long) obj).longValue());
        } else if (obj instanceof Double) {
            zzaVar.zza(((Double) obj).doubleValue());
        } else {
            zzj().zzg().zza("Ignoring invalid (type) user attribute value", obj);
        }
    }

    static boolean zza(zzbg zzbgVar, zzo zzoVar) {
        Preconditions.checkNotNull(zzbgVar);
        Preconditions.checkNotNull(zzoVar);
        return (TextUtils.isEmpty(zzoVar.zzb) && TextUtils.isEmpty(zzoVar.zzp)) ? false : true;
    }

    static boolean zza(List<Long> list, int i) {
        if (i < (list.size() << 6)) {
            return ((1 << (i % 64)) & list.get(i / 64).longValue()) != 0;
        }
        return false;
    }

    final boolean zza(long j, long j2) {
        return j == 0 || j2 <= 0 || Math.abs(zzb().currentTimeMillis() - j) > j2;
    }

    static boolean zzb(String str) {
        return str != null && str.matches("([+-])?([0-9]+\\.?[0-9]*|[0-9]*\\.?[0-9]+)") && str.length() <= 310;
    }

    final boolean zzc(String str) {
        Preconditions.checkNotNull(str);
        zzh zzhVarZzd = zzh().zzd(str);
        return zzhVarZzd != null && zzf().zzn() && zzhVarZzd.zzaj() && zzm().zzk(str);
    }

    final byte[] zzb(byte[] bArr) throws IOException {
        try {
            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            GZIPOutputStream gZIPOutputStream = new GZIPOutputStream(byteArrayOutputStream);
            gZIPOutputStream.write(bArr);
            gZIPOutputStream.close();
            byteArrayOutputStream.close();
            return byteArrayOutputStream.toByteArray();
        } catch (IOException e) {
            zzj().zzg().zza("Failed to gzip content", e);
            throw e;
        }
    }

    final byte[] zzc(byte[] bArr) throws IOException {
        try {
            ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(bArr);
            GZIPInputStream gZIPInputStream = new GZIPInputStream(byteArrayInputStream);
            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            byte[] bArr2 = new byte[1024];
            while (true) {
                int i = gZIPInputStream.read(bArr2);
                if (i > 0) {
                    byteArrayOutputStream.write(bArr2, 0, i);
                } else {
                    gZIPInputStream.close();
                    byteArrayInputStream.close();
                    return byteArrayOutputStream.toByteArray();
                }
            }
        } catch (IOException e) {
            zzj().zzg().zza("Failed to ungzip content", e);
            throw e;
        }
    }
}
