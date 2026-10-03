package com.google.android.gms.measurement.internal;

import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.os.Bundle;
import android.os.Parcelable;
import android.text.TextUtils;
import android.util.Pair;
import androidx.collection.ArrayMap;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.internal.measurement.zznk;
import com.google.android.gms.internal.measurement.zznp;
import com.google.android.gms.internal.measurement.zznq;
import com.google.android.gms.internal.measurement.zzpg;
import com.google.android.gms.internal.measurement.zzps;
import com.google.android.gms.internal.measurement.zzqd;
import com.google.android.gms.measurement.api.AppMeasurementSdk;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

final class zzao extends zzmo {
    private static final String[] zza = {"last_bundled_timestamp", "ALTER TABLE events ADD COLUMN last_bundled_timestamp INTEGER;", "last_bundled_day", "ALTER TABLE events ADD COLUMN last_bundled_day INTEGER;", "last_sampled_complex_event_id", "ALTER TABLE events ADD COLUMN last_sampled_complex_event_id INTEGER;", "last_sampling_rate", "ALTER TABLE events ADD COLUMN last_sampling_rate INTEGER;", "last_exempt_from_sampling", "ALTER TABLE events ADD COLUMN last_exempt_from_sampling INTEGER;", "current_session_count", "ALTER TABLE events ADD COLUMN current_session_count INTEGER;"};
    private static final String[] zzb = {"origin", "ALTER TABLE user_attributes ADD COLUMN origin TEXT;"};
    private static final String[] zzc = {"app_version", "ALTER TABLE apps ADD COLUMN app_version TEXT;", "app_store", "ALTER TABLE apps ADD COLUMN app_store TEXT;", "gmp_version", "ALTER TABLE apps ADD COLUMN gmp_version INTEGER;", "dev_cert_hash", "ALTER TABLE apps ADD COLUMN dev_cert_hash INTEGER;", "measurement_enabled", "ALTER TABLE apps ADD COLUMN measurement_enabled INTEGER;", "last_bundle_start_timestamp", "ALTER TABLE apps ADD COLUMN last_bundle_start_timestamp INTEGER;", "day", "ALTER TABLE apps ADD COLUMN day INTEGER;", "daily_public_events_count", "ALTER TABLE apps ADD COLUMN daily_public_events_count INTEGER;", "daily_events_count", "ALTER TABLE apps ADD COLUMN daily_events_count INTEGER;", "daily_conversions_count", "ALTER TABLE apps ADD COLUMN daily_conversions_count INTEGER;", "remote_config", "ALTER TABLE apps ADD COLUMN remote_config BLOB;", "config_fetched_time", "ALTER TABLE apps ADD COLUMN config_fetched_time INTEGER;", "failed_config_fetch_time", "ALTER TABLE apps ADD COLUMN failed_config_fetch_time INTEGER;", "app_version_int", "ALTER TABLE apps ADD COLUMN app_version_int INTEGER;", "firebase_instance_id", "ALTER TABLE apps ADD COLUMN firebase_instance_id TEXT;", "daily_error_events_count", "ALTER TABLE apps ADD COLUMN daily_error_events_count INTEGER;", "daily_realtime_events_count", "ALTER TABLE apps ADD COLUMN daily_realtime_events_count INTEGER;", "health_monitor_sample", "ALTER TABLE apps ADD COLUMN health_monitor_sample TEXT;", "android_id", "ALTER TABLE apps ADD COLUMN android_id INTEGER;", "adid_reporting_enabled", "ALTER TABLE apps ADD COLUMN adid_reporting_enabled INTEGER;", "ssaid_reporting_enabled", "ALTER TABLE apps ADD COLUMN ssaid_reporting_enabled INTEGER;", "admob_app_id", "ALTER TABLE apps ADD COLUMN admob_app_id TEXT;", "linked_admob_app_id", "ALTER TABLE apps ADD COLUMN linked_admob_app_id TEXT;", "dynamite_version", "ALTER TABLE apps ADD COLUMN dynamite_version INTEGER;", "safelisted_events", "ALTER TABLE apps ADD COLUMN safelisted_events TEXT;", "ga_app_id", "ALTER TABLE apps ADD COLUMN ga_app_id TEXT;", "config_last_modified_time", "ALTER TABLE apps ADD COLUMN config_last_modified_time TEXT;", "e_tag", "ALTER TABLE apps ADD COLUMN e_tag TEXT;", "session_stitching_token", "ALTER TABLE apps ADD COLUMN session_stitching_token TEXT;", "sgtm_upload_enabled", "ALTER TABLE apps ADD COLUMN sgtm_upload_enabled INTEGER;", "target_os_version", "ALTER TABLE apps ADD COLUMN target_os_version INTEGER;", "session_stitching_token_hash", "ALTER TABLE apps ADD COLUMN session_stitching_token_hash INTEGER;", "ad_services_version", "ALTER TABLE apps ADD COLUMN ad_services_version INTEGER;", "unmatched_first_open_without_ad_id", "ALTER TABLE apps ADD COLUMN unmatched_first_open_without_ad_id INTEGER;", "npa_metadata_value", "ALTER TABLE apps ADD COLUMN npa_metadata_value INTEGER;", "attribution_eligibility_status", "ALTER TABLE apps ADD COLUMN attribution_eligibility_status INTEGER;"};
    private static final String[] zzd = {"realtime", "ALTER TABLE raw_events ADD COLUMN realtime INTEGER;"};
    private static final String[] zze = {"has_realtime", "ALTER TABLE queue ADD COLUMN has_realtime INTEGER;", "retry_count", "ALTER TABLE queue ADD COLUMN retry_count INTEGER;"};
    private static final String[] zzg = {"session_scoped", "ALTER TABLE event_filters ADD COLUMN session_scoped BOOLEAN;"};
    private static final String[] zzh = {"session_scoped", "ALTER TABLE property_filters ADD COLUMN session_scoped BOOLEAN;"};
    private static final String[] zzi = {"previous_install_count", "ALTER TABLE app2 ADD COLUMN previous_install_count INTEGER;"};
    private static final String[] zzj = {"consent_source", "ALTER TABLE consent_settings ADD COLUMN consent_source INTEGER;", "dma_consent_settings", "ALTER TABLE consent_settings ADD COLUMN dma_consent_settings TEXT;"};
    private static final String[] zzk = {"idempotent", "CREATE INDEX IF NOT EXISTS trigger_uris_index ON trigger_uris (app_id);"};
    private final zzau zzl;
    private final zzmi zzm;

    public final int zza(String str, String str2) {
        Preconditions.checkNotEmpty(str);
        Preconditions.checkNotEmpty(str2);
        zzt();
        zzak();
        try {
            return m30e_().delete("conditional_properties", "app_id=? and name=?", new String[]{str, str2});
        } catch (SQLiteException e) {
            zzj().zzg().zza("Error deleting conditional property", zzfr.zza(str), zzi().zzc(str2), e);
            return 0;
        }
    }

    @Override
    protected final boolean zzc() {
        return false;
    }

    public final long zza(String str) {
        Preconditions.checkNotEmpty(str);
        zzt();
        zzak();
        try {
            return m30e_().delete("raw_events", "rowid in (select rowid from raw_events where app_id=? order by rowid desc limit -1 offset ?)", new String[]{str, String.valueOf(Math.max(0, Math.min(1000000, zze().zzb(str, zzbi.zzp))))});
        } catch (SQLiteException e) {
            zzj().zzg().zza("Error deleting over the limit events. appId", zzfr.zza(str), e);
            return 0L;
        }
    }

    public final long m27b_() {
        Cursor cursorRawQuery = null;
        try {
            cursorRawQuery = m30e_().rawQuery("select rowid from raw_events order by rowid desc limit 1;", null);
            if (cursorRawQuery.moveToFirst()) {
                return cursorRawQuery.getLong(0);
            }
            return -1L;
        } catch (SQLiteException e) {
            zzj().zzg().zza("Error querying raw events", e);
            return -1L;
        } finally {
            if (cursorRawQuery != null) {
                cursorRawQuery.close();
            }
        }
    }

    public final long zza(com.google.android.gms.internal.measurement.zzfi.zzj zzjVar) throws IOException {
        zzt();
        zzak();
        Preconditions.checkNotNull(zzjVar);
        Preconditions.checkNotEmpty(zzjVar.zzx());
        byte[] bArrZzbv = zzjVar.zzbv();
        long jZza = mo32g_().zza(bArrZzbv);
        ContentValues contentValues = new ContentValues();
        contentValues.put("app_id", zzjVar.zzx());
        contentValues.put("metadata_fingerprint", Long.valueOf(jZza));
        contentValues.put("metadata", bArrZzbv);
        try {
            m30e_().insertWithOnConflict("raw_events_metadata", null, contentValues, 4);
            return jZza;
        } catch (SQLiteException e) {
            zzj().zzg().zza("Error storing raw event metadata. appId", zzfr.zza(zzjVar.zzx()), e);
            throw e;
        }
    }

    protected final long zzb(String str, String str2) {
        Preconditions.checkNotEmpty(str);
        Preconditions.checkNotEmpty(str2);
        zzt();
        zzak();
        SQLiteDatabase sQLiteDatabaseM30e_ = m30e_();
        sQLiteDatabaseM30e_.beginTransaction();
        long j = 0;
        try {
            try {
                long jZza = zza("select " + str2 + " from app2 where app_id=?", new String[]{str}, -1L);
                if (jZza == -1) {
                    ContentValues contentValues = new ContentValues();
                    contentValues.put("app_id", str);
                    contentValues.put("first_open_count", (Integer) 0);
                    contentValues.put("previous_install_count", (Integer) 0);
                    if (sQLiteDatabaseM30e_.insertWithOnConflict("app2", null, contentValues, 5) == -1) {
                        zzj().zzg().zza("Failed to insert column (got -1). appId", zzfr.zza(str), str2);
                        return -1L;
                    }
                    jZza = 0;
                    zzj().zzg().zza("Error inserting column. appId", zzfr.zza(str), str2, e);
                    return j;
                }
                try {
                    ContentValues contentValues2 = new ContentValues();
                    contentValues2.put("app_id", str);
                    contentValues2.put(str2, Long.valueOf(1 + jZza));
                    if (sQLiteDatabaseM30e_.update("app2", contentValues2, "app_id = ?", new String[]{str}) == 0) {
                        zzj().zzg().zza("Failed to update column (got 0). appId", zzfr.zza(str), str2);
                        return -1L;
                    }
                    sQLiteDatabaseM30e_.setTransactionSuccessful();
                    return jZza;
                } catch (SQLiteException e) {
                    long j2 = jZza;
                    e = e;
                    j = j2;
                }
            } catch (SQLiteException e2) {
                e = e2;
            }
        } finally {
            sQLiteDatabaseM30e_.endTransaction();
        }
    }

    public final long m28c_() {
        return zza("select max(bundle_end_timestamp) from queue", (String[]) null, 0L);
    }

    public final long m29d_() {
        return zza("select max(timestamp) from raw_events", (String[]) null, 0L);
    }

    public final long zzb(String str) {
        Preconditions.checkNotEmpty(str);
        return zza("select count(1) from events where app_id=? and name not like '!_%' escape '!'", new String[]{str}, 0L);
    }

    private final long zzb(String str, String[] strArr) {
        Cursor cursor = null;
        try {
            try {
                Cursor cursorRawQuery = m30e_().rawQuery(str, strArr);
                if (cursorRawQuery.moveToFirst()) {
                    long j = cursorRawQuery.getLong(0);
                    if (cursorRawQuery != null) {
                        cursorRawQuery.close();
                    }
                    return j;
                }
                throw new SQLiteException("Database returned empty set");
            } catch (SQLiteException e) {
                zzj().zzg().zza("Database error", str, e);
                throw e;
            }
        } catch (Throwable th) {
            if (0 != 0) {
                cursor.close();
            }
            throw th;
        }
    }

    private final long zza(String str, String[] strArr, long j) {
        Cursor cursorRawQuery = null;
        try {
            try {
                cursorRawQuery = m30e_().rawQuery(str, strArr);
                if (!cursorRawQuery.moveToFirst()) {
                    if (cursorRawQuery != null) {
                        cursorRawQuery.close();
                    }
                    return j;
                }
                long j2 = cursorRawQuery.getLong(0);
                if (cursorRawQuery != null) {
                    cursorRawQuery.close();
                }
                return j2;
            } catch (SQLiteException e) {
                zzj().zzg().zza("Database error", str, e);
                throw e;
            }
        } catch (Throwable th) {
            if (cursorRawQuery != null) {
                cursorRawQuery.close();
            }
            throw th;
        }
    }

    final SQLiteDatabase m30e_() {
        zzt();
        try {
            return this.zzl.getWritableDatabase();
        } catch (SQLiteException e) {
            zzj().zzu().zza("Error opening database", e);
            throw e;
        }
    }

    public final Bundle zzc(String str) throws Throwable {
        Cursor cursorRawQuery;
        Cursor cursor;
        zzt();
        zzak();
        Cursor cursor2 = null;
        try {
            try {
                cursorRawQuery = m30e_().rawQuery("select parameters from default_event_params where app_id=?", new String[]{str});
                try {
                    if (!cursorRawQuery.moveToFirst()) {
                        zzj().zzp().zza("Default event parameters not found");
                        if (cursorRawQuery != null) {
                            cursorRawQuery.close();
                        }
                        return null;
                    }
                    try {
                        com.google.android.gms.internal.measurement.zzfi.zze zzeVar = (com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) ((com.google.android.gms.internal.measurement.zzfi.zze.zza) zzmz.zza(com.google.android.gms.internal.measurement.zzfi.zze.zze(), cursorRawQuery.getBlob(0))).zzab());
                        mo32g_();
                        List<com.google.android.gms.internal.measurement.zzfi.zzg> listZzh = zzeVar.zzh();
                        Bundle bundle = new Bundle();
                        for (com.google.android.gms.internal.measurement.zzfi.zzg zzgVar : listZzh) {
                            String strZzg = zzgVar.zzg();
                            if (zzgVar.zzj()) {
                                bundle.putDouble(strZzg, zzgVar.zza());
                            } else if (zzgVar.zzk()) {
                                bundle.putFloat(strZzg, zzgVar.zzb());
                            } else if (zzgVar.zzn()) {
                                bundle.putString(strZzg, zzgVar.zzh());
                            } else if (zzgVar.zzl()) {
                                bundle.putLong(strZzg, zzgVar.zzd());
                            }
                        }
                        if (cursorRawQuery != null) {
                            cursorRawQuery.close();
                        }
                        return bundle;
                    } catch (IOException e) {
                        zzj().zzg().zza("Failed to retrieve default event parameters. appId", zzfr.zza(str), e);
                        if (cursorRawQuery != null) {
                            cursorRawQuery.close();
                        }
                        return null;
                    }
                } catch (SQLiteException e2) {
                    e = e2;
                    zzj().zzg().zza("Error selecting default event parameters", e);
                    if (cursorRawQuery != null) {
                        cursorRawQuery.close();
                    }
                    return null;
                }
            } catch (Throwable th) {
                th = th;
                cursor2 = cursor;
                if (cursor2 != null) {
                    cursor2.close();
                }
                throw th;
            }
        } catch (SQLiteException e3) {
            e = e3;
            cursorRawQuery = null;
        } catch (Throwable th2) {
            th = th2;
            if (cursor2 != null) {
                cursor2.close();
            }
            throw th;
        }
    }

    public final Pair<com.google.android.gms.internal.measurement.zzfi.zze, Long> zza(String str, Long l) throws Throwable {
        Cursor cursorRawQuery;
        Cursor cursor;
        zzt();
        zzak();
        Cursor cursor2 = null;
        try {
            try {
                cursorRawQuery = m30e_().rawQuery("select main_event, children_to_process from main_event_params where app_id=? and event_id=?", new String[]{str, String.valueOf(l)});
                try {
                    if (!cursorRawQuery.moveToFirst()) {
                        zzj().zzp().zza("Main event not found");
                        if (cursorRawQuery != null) {
                            cursorRawQuery.close();
                        }
                        return null;
                    }
                    try {
                        Pair<com.google.android.gms.internal.measurement.zzfi.zze, Long> pairCreate = Pair.create((com.google.android.gms.internal.measurement.zzfi.zze) ((com.google.android.gms.internal.measurement.zzix) ((com.google.android.gms.internal.measurement.zzfi.zze.zza) zzmz.zza(com.google.android.gms.internal.measurement.zzfi.zze.zze(), cursorRawQuery.getBlob(0))).zzab()), Long.valueOf(cursorRawQuery.getLong(1)));
                        if (cursorRawQuery != null) {
                            cursorRawQuery.close();
                        }
                        return pairCreate;
                    } catch (IOException e) {
                        zzj().zzg().zza("Failed to merge main event. appId, eventId", zzfr.zza(str), l, e);
                        if (cursorRawQuery != null) {
                            cursorRawQuery.close();
                        }
                        return null;
                    }
                } catch (SQLiteException e2) {
                    e = e2;
                    zzj().zzg().zza("Error selecting main event", e);
                    if (cursorRawQuery != null) {
                        cursorRawQuery.close();
                    }
                    return null;
                }
            } catch (Throwable th) {
                th = th;
                cursor2 = cursor;
                if (cursor2 != null) {
                    cursor2.close();
                }
                throw th;
            }
        } catch (SQLiteException e3) {
            e = e3;
            cursorRawQuery = null;
        } catch (Throwable th2) {
            th = th2;
            if (cursor2 != null) {
                cursor2.close();
            }
            throw th;
        }
    }

    public final zzh zzd(String str) {
        Cursor cursorQuery;
        Boolean boolValueOf;
        Preconditions.checkNotEmpty(str);
        zzt();
        zzak();
        Cursor cursor = null;
        try {
            cursorQuery = m30e_().query("apps", new String[]{"app_instance_id", "gmp_app_id", "resettable_device_id_hash", "last_bundle_index", "last_bundle_start_timestamp", "last_bundle_end_timestamp", "app_version", "app_store", "gmp_version", "dev_cert_hash", "measurement_enabled", "day", "daily_public_events_count", "daily_events_count", "daily_conversions_count", "config_fetched_time", "failed_config_fetch_time", "app_version_int", "firebase_instance_id", "daily_error_events_count", "daily_realtime_events_count", "health_monitor_sample", "android_id", "adid_reporting_enabled", "admob_app_id", "dynamite_version", "safelisted_events", "ga_app_id", "session_stitching_token", "sgtm_upload_enabled", "target_os_version", "session_stitching_token_hash", "ad_services_version", "unmatched_first_open_without_ad_id", "npa_metadata_value", "attribution_eligibility_status"}, "app_id=?", new String[]{str}, null, null, null);
            try {
                if (!cursorQuery.moveToFirst()) {
                    if (cursorQuery != null) {
                        cursorQuery.close();
                    }
                    return null;
                }
                try {
                    try {
                        zzh zzhVar = new zzh(this.zzf.zzk(), str);
                        zzhVar.zzb(cursorQuery.getString(0));
                        zzhVar.zzf(cursorQuery.getString(1));
                        zzhVar.zzh(cursorQuery.getString(2));
                        zzhVar.zzo(cursorQuery.getLong(3));
                        zzhVar.zzp(cursorQuery.getLong(4));
                        zzhVar.zzn(cursorQuery.getLong(5));
                        zzhVar.zzd(cursorQuery.getString(6));
                        zzhVar.zzc(cursorQuery.getString(7));
                        zzhVar.zzm(cursorQuery.getLong(8));
                        zzhVar.zzj(cursorQuery.getLong(9));
                        zzhVar.zzb(cursorQuery.isNull(10) || cursorQuery.getInt(10) != 0);
                        zzhVar.zzi(cursorQuery.getLong(11));
                        zzhVar.zzg(cursorQuery.getLong(12));
                        zzhVar.zzf(cursorQuery.getLong(13));
                        zzhVar.zzd(cursorQuery.getLong(14));
                        zzhVar.zzc(cursorQuery.getLong(15));
                        zzhVar.zzl(cursorQuery.getLong(16));
                        zzhVar.zza(cursorQuery.isNull(17) ? -2147483648L : cursorQuery.getInt(17));
                        zzhVar.zze(cursorQuery.getString(18));
                        zzhVar.zze(cursorQuery.getLong(19));
                        zzhVar.zzh(cursorQuery.getLong(20));
                        zzhVar.zzg(cursorQuery.getString(21));
                        zzhVar.zza(cursorQuery.isNull(23) || cursorQuery.getInt(23) != 0);
                        zzhVar.zza(cursorQuery.getString(24));
                        zzhVar.zzk(cursorQuery.isNull(25) ? 0L : cursorQuery.getLong(25));
                        if (!cursorQuery.isNull(26)) {
                            zzhVar.zza(Arrays.asList(cursorQuery.getString(26).split(",", -1)));
                        }
                        if (zzps.zza() && (zze().zze(str, zzbi.zzbt) || zze().zza(zzbi.zzbr))) {
                            zzhVar.zzi(cursorQuery.getString(28));
                        }
                        if (zzqd.zza() && zze().zza(zzbi.zzbu)) {
                            zzhVar.zzc((cursorQuery.isNull(29) || cursorQuery.getInt(29) == 0) ? false : true);
                        }
                        zzhVar.zzr(cursorQuery.getLong(30));
                        zzhVar.zzq(cursorQuery.getLong(31));
                        if (zzpg.zza() && zze().zze(str, zzbi.zzcf)) {
                            zzhVar.zza(cursorQuery.getInt(32));
                            zzhVar.zzb(cursorQuery.getLong(35));
                        }
                        if (zznk.zza() && zze().zze(str, zzbi.zzcr)) {
                            zzhVar.zzd((cursorQuery.isNull(33) || cursorQuery.getInt(33) == 0) ? false : true);
                        }
                        if (zznp.zza() && zze().zze(str, zzbi.zzcm)) {
                            if (cursorQuery.isNull(34)) {
                                boolValueOf = null;
                            } else {
                                boolValueOf = Boolean.valueOf(cursorQuery.getInt(34) != 0);
                            }
                            zzhVar.zza(boolValueOf);
                        }
                        zzhVar.zzah();
                        if (cursorQuery.moveToNext()) {
                            zzj().zzg().zza("Got multiple records for app, expected one. appId", zzfr.zza(str));
                        }
                        if (cursorQuery != null) {
                            cursorQuery.close();
                        }
                        return zzhVar;
                    } catch (SQLiteException e) {
                        e = e;
                        zzj().zzg().zza("Error querying app. appId", zzfr.zza(str), e);
                        if (cursorQuery != null) {
                            cursorQuery.close();
                        }
                        return null;
                    }
                } catch (Throwable th) {
                    th = th;
                    cursor = cursorQuery;
                    if (cursor != null) {
                        cursor.close();
                    }
                    throw th;
                }
            } catch (SQLiteException e2) {
                e = e2;
            } catch (Throwable th2) {
                th = th2;
                cursor = cursorQuery;
                if (cursor != null) {
                    cursor.close();
                }
                throw th;
            }
        } catch (SQLiteException e3) {
            e = e3;
            cursorQuery = null;
        } catch (Throwable th3) {
            th = th3;
            if (cursor != null) {
                cursor.close();
            }
            throw th;
        }
        zzj().zzg().zza("Error querying app. appId", zzfr.zza(str), e);
        if (cursorQuery != null) {
            cursorQuery.close();
        }
        return null;
    }

    public final zzad zzc(String str, String str2) throws Throwable {
        Cursor cursorQuery;
        Preconditions.checkNotEmpty(str);
        Preconditions.checkNotEmpty(str2);
        zzt();
        zzak();
        Cursor cursor = null;
        try {
            cursorQuery = m30e_().query("conditional_properties", new String[]{"origin", "value", AppMeasurementSdk.ConditionalUserProperty.ACTIVE, AppMeasurementSdk.ConditionalUserProperty.TRIGGER_EVENT_NAME, AppMeasurementSdk.ConditionalUserProperty.TRIGGER_TIMEOUT, "timed_out_event", AppMeasurementSdk.ConditionalUserProperty.CREATION_TIMESTAMP, "triggered_event", AppMeasurementSdk.ConditionalUserProperty.TRIGGERED_TIMESTAMP, AppMeasurementSdk.ConditionalUserProperty.TIME_TO_LIVE, "expired_event"}, "app_id=? and name=?", new String[]{str, str2}, null, null, null);
            try {
                try {
                    if (!cursorQuery.moveToFirst()) {
                        if (cursorQuery != null) {
                            cursorQuery.close();
                        }
                        return null;
                    }
                    String string = cursorQuery.getString(0);
                    if (string == null) {
                        string = "";
                    }
                    String str3 = string;
                    Object objZza = zza(cursorQuery, 1);
                    boolean z = cursorQuery.getInt(2) != 0;
                    String string2 = cursorQuery.getString(3);
                    long j = cursorQuery.getLong(4);
                    zzad zzadVar = new zzad(str, str3, new zznc(str2, cursorQuery.getLong(8), objZza, str3), cursorQuery.getLong(6), z, string2, (zzbg) mo32g_().zza(cursorQuery.getBlob(5), zzbg.CREATOR), j, (zzbg) mo32g_().zza(cursorQuery.getBlob(7), zzbg.CREATOR), cursorQuery.getLong(9), (zzbg) mo32g_().zza(cursorQuery.getBlob(10), zzbg.CREATOR));
                    if (cursorQuery.moveToNext()) {
                        zzj().zzg().zza("Got multiple records for conditional property, expected one", zzfr.zza(str), zzi().zzc(str2));
                    }
                    if (cursorQuery != null) {
                        cursorQuery.close();
                    }
                    return zzadVar;
                } catch (SQLiteException e) {
                    e = e;
                    zzj().zzg().zza("Error querying conditional property", zzfr.zza(str), zzi().zzc(str2), e);
                    if (cursorQuery != null) {
                        cursorQuery.close();
                    }
                    return null;
                }
            } catch (Throwable th) {
                th = th;
                cursor = cursorQuery;
            }
        } catch (SQLiteException e2) {
            e = e2;
            cursorQuery = null;
        } catch (Throwable th2) {
            th = th2;
        }
        th = th;
        cursor = cursorQuery;
        if (cursor != null) {
            cursor.close();
        }
        throw th;
    }

    public final zzaq zze(String str) throws Throwable {
        Cursor cursorQuery;
        Cursor cursor;
        Preconditions.checkNotEmpty(str);
        zzt();
        zzak();
        Cursor cursor2 = null;
        try {
            try {
                cursorQuery = m30e_().query("apps", new String[]{"remote_config", "config_last_modified_time", "e_tag"}, "app_id=?", new String[]{str}, null, null, null);
                try {
                    if (!cursorQuery.moveToFirst()) {
                        if (cursorQuery != null) {
                            cursorQuery.close();
                        }
                        return null;
                    }
                    byte[] blob = cursorQuery.getBlob(0);
                    String string = cursorQuery.getString(1);
                    String string2 = cursorQuery.getString(2);
                    if (cursorQuery.moveToNext()) {
                        zzj().zzg().zza("Got multiple records for app config, expected one. appId", zzfr.zza(str));
                    }
                    if (blob == null) {
                        if (cursorQuery != null) {
                            cursorQuery.close();
                        }
                        return null;
                    }
                    zzaq zzaqVar = new zzaq(blob, string, string2);
                    if (cursorQuery != null) {
                        cursorQuery.close();
                    }
                    return zzaqVar;
                } catch (SQLiteException e) {
                    e = e;
                    zzj().zzg().zza("Error querying remote config. appId", zzfr.zza(str), e);
                    if (cursorQuery != null) {
                        cursorQuery.close();
                    }
                    return null;
                }
            } catch (Throwable th) {
                th = th;
                cursor2 = cursor;
                if (cursor2 != null) {
                    cursor2.close();
                }
                throw th;
            }
        } catch (SQLiteException e2) {
            e = e2;
            cursorQuery = null;
        } catch (Throwable th2) {
            th = th2;
            if (cursor2 != null) {
                cursor2.close();
            }
            throw th;
        }
    }

    public final zzap zza(long j, String str, boolean z, boolean z2, boolean z3, boolean z4, boolean z5) {
        return zza(j, str, 1L, false, false, z3, false, z5);
    }

    public final zzap zza(long j, String str, long j2, boolean z, boolean z2, boolean z3, boolean z4, boolean z5) {
        Preconditions.checkNotEmpty(str);
        zzt();
        zzak();
        String[] strArr = {str};
        zzap zzapVar = new zzap();
        Cursor cursor = null;
        try {
            try {
                SQLiteDatabase sQLiteDatabaseM30e_ = m30e_();
                Cursor cursorQuery = sQLiteDatabaseM30e_.query("apps", new String[]{"day", "daily_events_count", "daily_public_events_count", "daily_conversions_count", "daily_error_events_count", "daily_realtime_events_count"}, "app_id=?", new String[]{str}, null, null, null);
                if (!cursorQuery.moveToFirst()) {
                    zzj().zzu().zza("Not updating daily counts, app is not known. appId", zzfr.zza(str));
                    if (cursorQuery != null) {
                        cursorQuery.close();
                    }
                    return zzapVar;
                }
                if (cursorQuery.getLong(0) == j) {
                    zzapVar.zzb = cursorQuery.getLong(1);
                    zzapVar.zza = cursorQuery.getLong(2);
                    zzapVar.zzc = cursorQuery.getLong(3);
                    zzapVar.zzd = cursorQuery.getLong(4);
                    zzapVar.zze = cursorQuery.getLong(5);
                }
                if (z) {
                    zzapVar.zzb += j2;
                }
                if (z2) {
                    zzapVar.zza += j2;
                }
                if (z3) {
                    zzapVar.zzc += j2;
                }
                if (z4) {
                    zzapVar.zzd += j2;
                }
                if (z5) {
                    zzapVar.zze += j2;
                }
                ContentValues contentValues = new ContentValues();
                contentValues.put("day", Long.valueOf(j));
                contentValues.put("daily_public_events_count", Long.valueOf(zzapVar.zza));
                contentValues.put("daily_events_count", Long.valueOf(zzapVar.zzb));
                contentValues.put("daily_conversions_count", Long.valueOf(zzapVar.zzc));
                contentValues.put("daily_error_events_count", Long.valueOf(zzapVar.zzd));
                contentValues.put("daily_realtime_events_count", Long.valueOf(zzapVar.zze));
                sQLiteDatabaseM30e_.update("apps", contentValues, "app_id=?", strArr);
                if (cursorQuery != null) {
                    cursorQuery.close();
                }
                return zzapVar;
            } catch (SQLiteException e) {
                zzj().zzg().zza("Error updating daily counts. appId", zzfr.zza(str), e);
                if (0 != 0) {
                    cursor.close();
                }
                return zzapVar;
            }
        } catch (Throwable th) {
            if (0 != 0) {
                cursor.close();
            }
            throw th;
        }
    }

    public final zzay zzf(String str) {
        if (!zznp.zza() || !zze().zza(zzbi.zzcm)) {
            return zzay.zza;
        }
        Preconditions.checkNotNull(str);
        zzt();
        zzak();
        return zzay.zza(zza("select dma_consent_settings from consent_settings where app_id=? limit 1;", new String[]{str}, ""));
    }

    public final zzbc zzd(String str, String str2) {
        Cursor cursorQuery;
        Boolean boolValueOf;
        Preconditions.checkNotEmpty(str);
        Preconditions.checkNotEmpty(str2);
        zzt();
        zzak();
        Cursor cursor = null;
        try {
            cursorQuery = m30e_().query("events", (String[]) new ArrayList(Arrays.asList("lifetime_count", "current_bundle_count", "last_fire_timestamp", "last_bundled_timestamp", "last_bundled_day", "last_sampled_complex_event_id", "last_sampling_rate", "last_exempt_from_sampling", "current_session_count")).toArray(new String[0]), "app_id=? and name=?", new String[]{str, str2}, null, null, null);
            try {
                try {
                    if (!cursorQuery.moveToFirst()) {
                        if (cursorQuery != null) {
                            cursorQuery.close();
                        }
                        return null;
                    }
                    long j = cursorQuery.getLong(0);
                    long j2 = cursorQuery.getLong(1);
                    long j3 = cursorQuery.getLong(2);
                    long j4 = cursorQuery.isNull(3) ? 0L : cursorQuery.getLong(3);
                    Long lValueOf = cursorQuery.isNull(4) ? null : Long.valueOf(cursorQuery.getLong(4));
                    Long lValueOf2 = cursorQuery.isNull(5) ? null : Long.valueOf(cursorQuery.getLong(5));
                    Long lValueOf3 = cursorQuery.isNull(6) ? null : Long.valueOf(cursorQuery.getLong(6));
                    if (cursorQuery.isNull(7)) {
                        boolValueOf = null;
                    } else {
                        boolValueOf = Boolean.valueOf(cursorQuery.getLong(7) == 1);
                    }
                    zzbc zzbcVar = new zzbc(str, str2, j, j2, cursorQuery.isNull(8) ? 0L : cursorQuery.getLong(8), j3, j4, lValueOf, lValueOf2, lValueOf3, boolValueOf);
                    if (cursorQuery.moveToNext()) {
                        zzj().zzg().zza("Got multiple records for event aggregates, expected one. appId", zzfr.zza(str));
                    }
                    if (cursorQuery != null) {
                        cursorQuery.close();
                    }
                    return zzbcVar;
                } catch (SQLiteException e) {
                    e = e;
                    zzj().zzg().zza("Error querying events. appId", zzfr.zza(str), zzi().zza(str2), e);
                    if (cursorQuery != null) {
                        cursorQuery.close();
                    }
                    return null;
                }
            } catch (Throwable th) {
                th = th;
                cursor = cursorQuery;
            }
        } catch (SQLiteException e2) {
            e = e2;
            cursorQuery = null;
        } catch (Throwable th2) {
            th = th2;
        }
        th = th;
        cursor = cursorQuery;
        if (cursor != null) {
            cursor.close();
        }
        throw th;
    }

    public final zzih zzg(String str) {
        Preconditions.checkNotNull(str);
        zzt();
        zzak();
        if (zznp.zza() && zze().zza(zzbi.zzcm)) {
            zzih zzihVar = (zzih) zza("select consent_state, consent_source from consent_settings where app_id=? limit 1;", new String[]{str}, new zzar() {
                @Override
                public final Object zza(Cursor cursor) {
                    return zzih.zza(cursor.getString(0), cursor.getInt(1));
                }
            });
            return zzihVar == null ? zzih.zza : zzihVar;
        }
        return zzih.zza(zza("select consent_state from consent_settings where app_id=? limit 1;", new String[]{str}, "G1"));
    }

    public final zzne zze(String str, String str2) {
        Cursor cursorQuery;
        Cursor cursor;
        Preconditions.checkNotEmpty(str);
        Preconditions.checkNotEmpty(str2);
        zzt();
        zzak();
        Cursor cursor2 = null;
        try {
            try {
                cursorQuery = m30e_().query("user_attributes", new String[]{"set_timestamp", "value", "origin"}, "app_id=? and name=?", new String[]{str, str2}, null, null, null);
                try {
                    if (!cursorQuery.moveToFirst()) {
                        if (cursorQuery != null) {
                            cursorQuery.close();
                        }
                        return null;
                    }
                    long j = cursorQuery.getLong(0);
                    Object objZza = zza(cursorQuery, 1);
                    if (objZza == null) {
                        if (cursorQuery != null) {
                            cursorQuery.close();
                        }
                        return null;
                    }
                    zzne zzneVar = new zzne(str, cursorQuery.getString(2), str2, j, objZza);
                    if (cursorQuery.moveToNext()) {
                        zzj().zzg().zza("Got multiple records for user property, expected one. appId", zzfr.zza(str));
                    }
                    if (cursorQuery != null) {
                        cursorQuery.close();
                    }
                    return zzneVar;
                } catch (SQLiteException e) {
                    e = e;
                    zzj().zzg().zza("Error querying user property. appId", zzfr.zza(str), zzi().zzc(str2), e);
                    if (cursorQuery != null) {
                        cursorQuery.close();
                    }
                    return null;
                }
            } catch (Throwable th) {
                th = th;
                cursor2 = cursor;
                if (cursor2 != null) {
                    cursor2.close();
                }
                throw th;
            }
        } catch (SQLiteException e2) {
            e = e2;
            cursorQuery = null;
        } catch (Throwable th2) {
            th = th2;
            if (cursor2 != null) {
                cursor2.close();
            }
            throw th;
        }
    }

    private final Object zza(Cursor cursor, int i) {
        int type = cursor.getType(i);
        if (type == 0) {
            zzj().zzg().zza("Loaded invalid null value from database");
            return null;
        }
        if (type == 1) {
            return Long.valueOf(cursor.getLong(i));
        }
        if (type == 2) {
            return Double.valueOf(cursor.getDouble(i));
        }
        if (type == 3) {
            return cursor.getString(i);
        }
        if (type == 4) {
            zzj().zzg().zza("Loaded invalid blob type value, ignoring it");
            return null;
        }
        zzj().zzg().zza("Loaded invalid unknown value type, ignoring it", Integer.valueOf(type));
        return null;
    }

    private final <T> T zza(String str, String[] strArr, zzar<T> zzarVar) throws Throwable {
        Cursor cursorRawQuery;
        ?? r0 = 0;
        try {
            try {
                cursorRawQuery = m30e_().rawQuery(str, strArr);
                try {
                    if (!cursorRawQuery.moveToFirst()) {
                        zzj().zzp().zza("No data found");
                        if (cursorRawQuery != null) {
                            cursorRawQuery.close();
                        }
                        return null;
                    }
                    T tZza = zzarVar.zza(cursorRawQuery);
                    if (cursorRawQuery != null) {
                        cursorRawQuery.close();
                    }
                    return tZza;
                } catch (SQLiteException e) {
                    e = e;
                    zzj().zzg().zza("Error querying database.", e);
                    if (cursorRawQuery != null) {
                        cursorRawQuery.close();
                    }
                    return null;
                }
            } catch (Throwable th) {
                th = th;
                r0 = str;
                if (r0 != 0) {
                    r0.close();
                }
                throw th;
            }
        } catch (SQLiteException e2) {
            e = e2;
            cursorRawQuery = null;
        } catch (Throwable th2) {
            th = th2;
            if (r0 != 0) {
                r0.close();
            }
            throw th;
        }
    }

    public final String zza(long j) throws Throwable {
        Cursor cursorRawQuery;
        zzt();
        zzak();
        ?? r0 = 0;
        try {
            try {
                cursorRawQuery = m30e_().rawQuery("select app_id from apps where app_id in (select distinct app_id from raw_events) and config_fetched_time < ? order by failed_config_fetch_time limit 1;", new String[]{String.valueOf((long) j)});
                try {
                    if (!cursorRawQuery.moveToFirst()) {
                        zzj().zzp().zza("No expired configs for apps with pending events");
                        if (cursorRawQuery != null) {
                            cursorRawQuery.close();
                        }
                        return null;
                    }
                    String string = cursorRawQuery.getString(0);
                    if (cursorRawQuery != null) {
                        cursorRawQuery.close();
                    }
                    return string;
                } catch (SQLiteException e) {
                    e = e;
                    zzj().zzg().zza("Error selecting expired configs", e);
                    if (cursorRawQuery != null) {
                        cursorRawQuery.close();
                    }
                    return null;
                }
            } catch (Throwable th) {
                th = th;
                r0 = j;
                if (r0 != 0) {
                    r0.close();
                }
                throw th;
            }
        } catch (SQLiteException e2) {
            e = e2;
            cursorRawQuery = null;
        } catch (Throwable th2) {
            th = th2;
            if (r0 != 0) {
                r0.close();
            }
            throw th;
        }
    }

    public final String m31f_() throws Throwable {
        Throwable th;
        Cursor cursorRawQuery;
        try {
            cursorRawQuery = m30e_().rawQuery("select app_id from queue order by has_realtime desc, rowid asc limit 1;", null);
            try {
                try {
                    if (!cursorRawQuery.moveToFirst()) {
                        if (cursorRawQuery != null) {
                            cursorRawQuery.close();
                        }
                        return null;
                    }
                    String string = cursorRawQuery.getString(0);
                    if (cursorRawQuery != null) {
                        cursorRawQuery.close();
                    }
                    return string;
                } catch (SQLiteException e) {
                    e = e;
                    zzj().zzg().zza("Database error getting next bundle app id", e);
                    if (cursorRawQuery != null) {
                        cursorRawQuery.close();
                    }
                    return null;
                }
            } catch (Throwable th2) {
                th = th2;
            }
        } catch (SQLiteException e2) {
            e = e2;
            cursorRawQuery = null;
        } catch (Throwable th3) {
            th = th3;
            cursorRawQuery = null;
        }
        th = th2;
        if (cursorRawQuery != null) {
            cursorRawQuery.close();
        }
        throw th;
    }

    private final String zza(String str, String[] strArr, String str2) {
        Cursor cursorRawQuery = null;
        try {
            try {
                cursorRawQuery = m30e_().rawQuery(str, strArr);
                if (!cursorRawQuery.moveToFirst()) {
                    if (cursorRawQuery != null) {
                        cursorRawQuery.close();
                    }
                    return str2;
                }
                String string = cursorRawQuery.getString(0);
                if (cursorRawQuery != null) {
                    cursorRawQuery.close();
                }
                return string;
            } catch (SQLiteException e) {
                zzj().zzg().zza("Database error", str, e);
                throw e;
            }
        } catch (Throwable th) {
            if (cursorRawQuery != null) {
                cursorRawQuery.close();
            }
            throw th;
        }
    }

    public final List<Pair<com.google.android.gms.internal.measurement.zzfi.zzj, Long>> zza(String str, int i, int i2) {
        long jZzc;
        long jZzc2;
        zzt();
        zzak();
        int i3 = 1;
        Preconditions.checkArgument(i > 0);
        Preconditions.checkArgument(i2 > 0);
        Preconditions.checkNotEmpty(str);
        Cursor cursor = null;
        try {
            try {
                Cursor cursorQuery = m30e_().query("queue", new String[]{"rowid", "data", "retry_count"}, "app_id=?", new String[]{str}, null, null, "rowid", String.valueOf(i));
                if (!cursorQuery.moveToFirst()) {
                    List<Pair<com.google.android.gms.internal.measurement.zzfi.zzj, Long>> listEmptyList = Collections.emptyList();
                    if (cursorQuery != null) {
                        cursorQuery.close();
                    }
                    return listEmptyList;
                }
                ArrayList arrayList = new ArrayList();
                int length = 0;
                while (true) {
                    long j = cursorQuery.getLong(0);
                    try {
                        byte[] bArrZzc = mo32g_().zzc(cursorQuery.getBlob(i3));
                        if (!arrayList.isEmpty() && bArrZzc.length + length > i2) {
                            break;
                        }
                        try {
                            com.google.android.gms.internal.measurement.zzfi.zzj.zza zzaVar = (com.google.android.gms.internal.measurement.zzfi.zzj.zza) zzmz.zza(com.google.android.gms.internal.measurement.zzfi.zzj.zzu(), bArrZzc);
                            if (zznp.zza() && zze().zza(zzbi.zzcq) && !arrayList.isEmpty()) {
                                com.google.android.gms.internal.measurement.zzfi.zzj zzjVar = (com.google.android.gms.internal.measurement.zzfi.zzj) ((Pair) arrayList.get(0)).first;
                                com.google.android.gms.internal.measurement.zzfi.zzj zzjVar2 = (com.google.android.gms.internal.measurement.zzfi.zzj) ((com.google.android.gms.internal.measurement.zzix) zzaVar.zzab());
                                if (!zzjVar.zzac().equals(zzjVar2.zzac()) || !zzjVar.zzab().equals(zzjVar2.zzab()) || zzjVar.zzas() != zzjVar2.zzas() || !zzjVar.zzad().equals(zzjVar2.zzad())) {
                                    break;
                                }
                                Iterator<com.google.android.gms.internal.measurement.zzfi.zzn> it = zzjVar.zzaq().iterator();
                                while (true) {
                                    jZzc = -1;
                                    if (!it.hasNext()) {
                                        jZzc2 = -1;
                                        break;
                                    }
                                    com.google.android.gms.internal.measurement.zzfi.zzn next = it.next();
                                    if ("_npa".equals(next.zzg())) {
                                        jZzc2 = next.zzc();
                                        break;
                                    }
                                }
                                for (com.google.android.gms.internal.measurement.zzfi.zzn zznVar : zzjVar2.zzaq()) {
                                    if ("_npa".equals(zznVar.zzg())) {
                                        jZzc = zznVar.zzc();
                                        break;
                                    }
                                }
                                if (jZzc2 != jZzc) {
                                    break;
                                }
                            }
                            if (!cursorQuery.isNull(2)) {
                                zzaVar.zzh(cursorQuery.getInt(2));
                            }
                            length += bArrZzc.length;
                            arrayList.add(Pair.create((com.google.android.gms.internal.measurement.zzfi.zzj) ((com.google.android.gms.internal.measurement.zzix) zzaVar.zzab()), Long.valueOf(j)));
                        } catch (IOException e) {
                            zzj().zzg().zza("Failed to merge queued bundle. appId", zzfr.zza(str), e);
                        }
                        if (!cursorQuery.moveToNext() || length > i2) {
                            break;
                        }
                        i3 = 1;
                    } catch (IOException e2) {
                        zzj().zzg().zza("Failed to unzip queued bundle. appId", zzfr.zza(str), e2);
                    }
                }
                if (cursorQuery != null) {
                    cursorQuery.close();
                }
                return arrayList;
            } catch (SQLiteException e3) {
                zzj().zzg().zza("Error querying bundles. appId", zzfr.zza(str), e3);
                List<Pair<com.google.android.gms.internal.measurement.zzfi.zzj, Long>> listEmptyList2 = Collections.emptyList();
                if (0 != 0) {
                    cursor.close();
                }
                return listEmptyList2;
            }
        } catch (Throwable th) {
            if (0 != 0) {
                cursor.close();
            }
            throw th;
        }
    }

    public final List<zzad> zza(String str, String str2, String str3) {
        Preconditions.checkNotEmpty(str);
        zzt();
        zzak();
        ArrayList arrayList = new ArrayList(3);
        arrayList.add(str);
        StringBuilder sb = new StringBuilder("app_id=?");
        if (!TextUtils.isEmpty(str2)) {
            arrayList.add(str2);
            sb.append(" and origin=?");
        }
        if (!TextUtils.isEmpty(str3)) {
            arrayList.add(str3 + "*");
            sb.append(" and name glob ?");
        }
        return zza(sb.toString(), (String[]) arrayList.toArray(new String[arrayList.size()]));
    }

    public final List<zzad> zza(String str, String[] strArr) {
        zzt();
        zzak();
        ArrayList arrayList = new ArrayList();
        Cursor cursorQuery = null;
        try {
            try {
                cursorQuery = m30e_().query("conditional_properties", new String[]{"app_id", "origin", AppMeasurementSdk.ConditionalUserProperty.NAME, "value", AppMeasurementSdk.ConditionalUserProperty.ACTIVE, AppMeasurementSdk.ConditionalUserProperty.TRIGGER_EVENT_NAME, AppMeasurementSdk.ConditionalUserProperty.TRIGGER_TIMEOUT, "timed_out_event", AppMeasurementSdk.ConditionalUserProperty.CREATION_TIMESTAMP, "triggered_event", AppMeasurementSdk.ConditionalUserProperty.TRIGGERED_TIMESTAMP, AppMeasurementSdk.ConditionalUserProperty.TIME_TO_LIVE, "expired_event"}, str, strArr, null, null, "rowid", "1001");
                if (!cursorQuery.moveToFirst()) {
                    return arrayList;
                }
                do {
                    if (arrayList.size() >= 1000) {
                        zzj().zzg().zza("Read more than the max allowed conditional properties, ignoring extra", 1000);
                        break;
                    }
                    String string = cursorQuery.getString(0);
                    String string2 = cursorQuery.getString(1);
                    String string3 = cursorQuery.getString(2);
                    Object objZza = zza(cursorQuery, 3);
                    boolean z = cursorQuery.getInt(4) != 0;
                    String string4 = cursorQuery.getString(5);
                    long j = cursorQuery.getLong(6);
                    zzbg zzbgVar = (zzbg) mo32g_().zza(cursorQuery.getBlob(7), zzbg.CREATOR);
                    arrayList.add(new zzad(string, string2, new zznc(string3, cursorQuery.getLong(10), objZza, string2), cursorQuery.getLong(8), z, string4, zzbgVar, j, (zzbg) mo32g_().zza(cursorQuery.getBlob(9), zzbg.CREATOR), cursorQuery.getLong(11), (zzbg) mo32g_().zza(cursorQuery.getBlob(12), zzbg.CREATOR)));
                } while (cursorQuery.moveToNext());
                return arrayList;
            } catch (SQLiteException e) {
                zzj().zzg().zza("Error querying conditional user property value", e);
                return Collections.emptyList();
            }
        } finally {
            if (cursorQuery != null) {
                cursorQuery.close();
            }
        }
        if (cursorQuery != null) {
            cursorQuery.close();
        }
    }

    public final List<zzmh> zzh(String str) {
        Preconditions.checkNotEmpty(str);
        zzt();
        zzak();
        ArrayList arrayList = new ArrayList();
        Cursor cursorQuery = null;
        try {
            cursorQuery = m30e_().query("trigger_uris", new String[]{"trigger_uri", "timestamp_millis", "source"}, "app_id=?", new String[]{str}, null, null, "rowid", null);
            if (!cursorQuery.moveToFirst()) {
                return arrayList;
            }
            do {
                String string = cursorQuery.getString(0);
                if (string == null) {
                    string = "";
                }
                arrayList.add(new zzmh(string, cursorQuery.getLong(1), cursorQuery.getInt(2)));
            } while (cursorQuery.moveToNext());
            return arrayList;
        } catch (SQLiteException e) {
            zzj().zzg().zza("Error querying trigger uris. appId", zzfr.zza(str), e);
            return Collections.emptyList();
        } finally {
            if (cursorQuery != null) {
                cursorQuery.close();
            }
        }
    }

    public final List<zzne> zzi(String str) {
        Preconditions.checkNotEmpty(str);
        zzt();
        zzak();
        ArrayList arrayList = new ArrayList();
        Cursor cursorQuery = null;
        try {
            cursorQuery = m30e_().query("user_attributes", new String[]{AppMeasurementSdk.ConditionalUserProperty.NAME, "origin", "set_timestamp", "value"}, "app_id=?", new String[]{str}, null, null, "rowid", "1000");
            if (!cursorQuery.moveToFirst()) {
                return arrayList;
            }
            do {
                String string = cursorQuery.getString(0);
                String string2 = cursorQuery.getString(1);
                if (string2 == null) {
                    string2 = "";
                }
                String str2 = string2;
                long j = cursorQuery.getLong(2);
                Object objZza = zza(cursorQuery, 3);
                if (objZza == null) {
                    zzj().zzg().zza("Read invalid user property value, ignoring it. appId", zzfr.zza(str));
                } else {
                    arrayList.add(new zzne(str, str2, string, j, objZza));
                }
            } while (cursorQuery.moveToNext());
            return arrayList;
        } catch (SQLiteException e) {
            zzj().zzg().zza("Error querying user properties. appId", zzfr.zza(str), e);
            return Collections.emptyList();
        } finally {
            if (cursorQuery != null) {
                cursorQuery.close();
            }
        }
    }

    public final List<zzne> zzb(String str, String str2, String str3) throws Throwable {
        String str4;
        Preconditions.checkNotEmpty(str);
        zzt();
        zzak();
        ArrayList arrayList = new ArrayList();
        Cursor cursorQuery = null;
        try {
            try {
                try {
                    ArrayList arrayList2 = new ArrayList(3);
                    try {
                        arrayList2.add(str);
                        StringBuilder sb = new StringBuilder("app_id=?");
                        if (TextUtils.isEmpty(str2)) {
                            str4 = str2;
                        } else {
                            str4 = str2;
                            try {
                                arrayList2.add(str4);
                                sb.append(" and origin=?");
                            } catch (SQLiteException e) {
                                e = e;
                                zzj().zzg().zza("(2)Error querying user properties", zzfr.zza(str), str4, e);
                                List<zzne> listEmptyList = Collections.emptyList();
                                if (cursorQuery != null) {
                                    cursorQuery.close();
                                }
                                return listEmptyList;
                            }
                        }
                        if (!TextUtils.isEmpty(str3)) {
                            arrayList2.add(str3 + "*");
                            sb.append(" and name glob ?");
                        }
                        cursorQuery = m30e_().query("user_attributes", new String[]{AppMeasurementSdk.ConditionalUserProperty.NAME, "set_timestamp", "value", "origin"}, sb.toString(), (String[]) arrayList2.toArray(new String[arrayList2.size()]), null, null, "rowid", "1001");
                        if (!cursorQuery.moveToFirst()) {
                            if (cursorQuery != null) {
                                cursorQuery.close();
                            }
                            return arrayList;
                        }
                        while (true) {
                            if (arrayList.size() >= 1000) {
                                zzj().zzg().zza("Read more than the max allowed user properties, ignoring excess", 1000);
                                break;
                            }
                            String string = cursorQuery.getString(0);
                            long j = cursorQuery.getLong(1);
                            try {
                                Object objZza = zza(cursorQuery, 2);
                                String string2 = cursorQuery.getString(3);
                                if (objZza == null) {
                                    try {
                                        zzj().zzg().zza("(2)Read invalid user property value, ignoring it", zzfr.zza(str), string2, str3);
                                    } catch (SQLiteException e2) {
                                        e = e2;
                                        str4 = string2;
                                        zzj().zzg().zza("(2)Error querying user properties", zzfr.zza(str), str4, e);
                                        List<zzne> listEmptyList2 = Collections.emptyList();
                                        if (cursorQuery != null) {
                                            cursorQuery.close();
                                        }
                                        return listEmptyList2;
                                    }
                                } else {
                                    arrayList.add(new zzne(str, string2, string, j, objZza));
                                }
                                if (!cursorQuery.moveToNext()) {
                                    break;
                                }
                                str4 = string2;
                            } catch (SQLiteException e3) {
                                e = e3;
                            }
                        }
                        if (cursorQuery != null) {
                            cursorQuery.close();
                        }
                        return arrayList;
                    } catch (SQLiteException e4) {
                        e = e4;
                        str4 = str2;
                        zzj().zzg().zza("(2)Error querying user properties", zzfr.zza(str), str4, e);
                        List<zzne> listEmptyList3 = Collections.emptyList();
                        if (cursorQuery != null) {
                            cursorQuery.close();
                        }
                        return listEmptyList3;
                    }
                } catch (Throwable th) {
                    th = th;
                    if (cursorQuery != null) {
                        cursorQuery.close();
                    }
                    throw th;
                }
            } catch (SQLiteException e5) {
                e = e5;
            }
        } catch (Throwable th2) {
            th = th2;
            if (cursorQuery != null) {
                cursorQuery.close();
            }
            throw th;
        }
    }

    final Map<Integer, com.google.android.gms.internal.measurement.zzfi.zzl> zzj(String str) {
        zzak();
        zzt();
        Preconditions.checkNotEmpty(str);
        Cursor cursor = null;
        try {
            try {
                Cursor cursorQuery = m30e_().query("audience_filter_values", new String[]{"audience_id", "current_results"}, "app_id=?", new String[]{str}, null, null, null);
                if (!cursorQuery.moveToFirst()) {
                    Map<Integer, com.google.android.gms.internal.measurement.zzfi.zzl> mapEmptyMap = Collections.emptyMap();
                    if (cursorQuery != null) {
                        cursorQuery.close();
                    }
                    return mapEmptyMap;
                }
                ArrayMap arrayMap = new ArrayMap();
                do {
                    int i = cursorQuery.getInt(0);
                    try {
                        arrayMap.put(Integer.valueOf(i), (com.google.android.gms.internal.measurement.zzfi.zzl) ((com.google.android.gms.internal.measurement.zzix) ((com.google.android.gms.internal.measurement.zzfi.zzl.zza) zzmz.zza(com.google.android.gms.internal.measurement.zzfi.zzl.zze(), cursorQuery.getBlob(1))).zzab()));
                    } catch (IOException e) {
                        zzj().zzg().zza("Failed to merge filter results. appId, audienceId, error", zzfr.zza(str), Integer.valueOf(i), e);
                    }
                } while (cursorQuery.moveToNext());
                if (cursorQuery != null) {
                    cursorQuery.close();
                }
                return arrayMap;
            } catch (SQLiteException e2) {
                zzj().zzg().zza("Database error querying filter results. appId", zzfr.zza(str), e2);
                Map<Integer, com.google.android.gms.internal.measurement.zzfi.zzl> mapEmptyMap2 = Collections.emptyMap();
                if (0 != 0) {
                    cursor.close();
                }
                return mapEmptyMap2;
            }
        } catch (Throwable th) {
            if (0 != 0) {
                cursor.close();
            }
            throw th;
        }
    }

    final Map<Integer, List<com.google.android.gms.internal.measurement.zzew.zzb>> zzk(String str) {
        Preconditions.checkNotEmpty(str);
        ArrayMap arrayMap = new ArrayMap();
        Cursor cursor = null;
        try {
            try {
                Cursor cursorQuery = m30e_().query("event_filters", new String[]{"audience_id", "data"}, "app_id=?", new String[]{str}, null, null, null);
                if (!cursorQuery.moveToFirst()) {
                    Map<Integer, List<com.google.android.gms.internal.measurement.zzew.zzb>> mapEmptyMap = Collections.emptyMap();
                    if (cursorQuery != null) {
                        cursorQuery.close();
                    }
                    return mapEmptyMap;
                }
                do {
                    try {
                        com.google.android.gms.internal.measurement.zzew.zzb zzbVar = (com.google.android.gms.internal.measurement.zzew.zzb) ((com.google.android.gms.internal.measurement.zzix) ((com.google.android.gms.internal.measurement.zzew.zzb.zza) zzmz.zza(com.google.android.gms.internal.measurement.zzew.zzb.zzc(), cursorQuery.getBlob(1))).zzab());
                        if (zzbVar.zzk()) {
                            int i = cursorQuery.getInt(0);
                            List arrayList = (List) arrayMap.get(Integer.valueOf(i));
                            if (arrayList == null) {
                                arrayList = new ArrayList();
                                arrayMap.put(Integer.valueOf(i), arrayList);
                            }
                            arrayList.add(zzbVar);
                        }
                    } catch (IOException e) {
                        zzj().zzg().zza("Failed to merge filter. appId", zzfr.zza(str), e);
                    }
                } while (cursorQuery.moveToNext());
                if (cursorQuery != null) {
                    cursorQuery.close();
                }
                return arrayMap;
            } catch (Throwable th) {
                if (0 != 0) {
                    cursor.close();
                }
                throw th;
            }
        } catch (SQLiteException e2) {
            zzj().zzg().zza("Database error querying filters. appId", zzfr.zza(str), e2);
            Map<Integer, List<com.google.android.gms.internal.measurement.zzew.zzb>> mapEmptyMap2 = Collections.emptyMap();
            if (0 != 0) {
                cursor.close();
            }
            return mapEmptyMap2;
        }
    }

    final Map<Integer, List<com.google.android.gms.internal.measurement.zzew.zzb>> zzf(String str, String str2) {
        zzak();
        zzt();
        Preconditions.checkNotEmpty(str);
        Preconditions.checkNotEmpty(str2);
        ArrayMap arrayMap = new ArrayMap();
        Cursor cursor = null;
        try {
            try {
                Cursor cursorQuery = m30e_().query("event_filters", new String[]{"audience_id", "data"}, "app_id=? AND event_name=?", new String[]{str, str2}, null, null, null);
                if (!cursorQuery.moveToFirst()) {
                    Map<Integer, List<com.google.android.gms.internal.measurement.zzew.zzb>> mapEmptyMap = Collections.emptyMap();
                    if (cursorQuery != null) {
                        cursorQuery.close();
                    }
                    return mapEmptyMap;
                }
                do {
                    try {
                        com.google.android.gms.internal.measurement.zzew.zzb zzbVar = (com.google.android.gms.internal.measurement.zzew.zzb) ((com.google.android.gms.internal.measurement.zzix) ((com.google.android.gms.internal.measurement.zzew.zzb.zza) zzmz.zza(com.google.android.gms.internal.measurement.zzew.zzb.zzc(), cursorQuery.getBlob(1))).zzab());
                        int i = cursorQuery.getInt(0);
                        List arrayList = (List) arrayMap.get(Integer.valueOf(i));
                        if (arrayList == null) {
                            arrayList = new ArrayList();
                            arrayMap.put(Integer.valueOf(i), arrayList);
                        }
                        arrayList.add(zzbVar);
                    } catch (IOException e) {
                        zzj().zzg().zza("Failed to merge filter. appId", zzfr.zza(str), e);
                    }
                } while (cursorQuery.moveToNext());
                if (cursorQuery != null) {
                    cursorQuery.close();
                }
                return arrayMap;
            } catch (Throwable th) {
                if (0 != 0) {
                    cursor.close();
                }
                throw th;
            }
        } catch (SQLiteException e2) {
            zzj().zzg().zza("Database error querying filters. appId", zzfr.zza(str), e2);
            Map<Integer, List<com.google.android.gms.internal.measurement.zzew.zzb>> mapEmptyMap2 = Collections.emptyMap();
            if (0 != 0) {
                cursor.close();
            }
            return mapEmptyMap2;
        }
    }

    final Map<Integer, List<com.google.android.gms.internal.measurement.zzew.zze>> zzg(String str, String str2) {
        zzak();
        zzt();
        Preconditions.checkNotEmpty(str);
        Preconditions.checkNotEmpty(str2);
        ArrayMap arrayMap = new ArrayMap();
        Cursor cursor = null;
        try {
            try {
                Cursor cursorQuery = m30e_().query("property_filters", new String[]{"audience_id", "data"}, "app_id=? AND property_name=?", new String[]{str, str2}, null, null, null);
                if (!cursorQuery.moveToFirst()) {
                    Map<Integer, List<com.google.android.gms.internal.measurement.zzew.zze>> mapEmptyMap = Collections.emptyMap();
                    if (cursorQuery != null) {
                        cursorQuery.close();
                    }
                    return mapEmptyMap;
                }
                do {
                    try {
                        com.google.android.gms.internal.measurement.zzew.zze zzeVar = (com.google.android.gms.internal.measurement.zzew.zze) ((com.google.android.gms.internal.measurement.zzix) ((com.google.android.gms.internal.measurement.zzew.zze.zza) zzmz.zza(com.google.android.gms.internal.measurement.zzew.zze.zzc(), cursorQuery.getBlob(1))).zzab());
                        int i = cursorQuery.getInt(0);
                        List arrayList = (List) arrayMap.get(Integer.valueOf(i));
                        if (arrayList == null) {
                            arrayList = new ArrayList();
                            arrayMap.put(Integer.valueOf(i), arrayList);
                        }
                        arrayList.add(zzeVar);
                    } catch (IOException e) {
                        zzj().zzg().zza("Failed to merge filter", zzfr.zza(str), e);
                    }
                } while (cursorQuery.moveToNext());
                if (cursorQuery != null) {
                    cursorQuery.close();
                }
                return arrayMap;
            } catch (Throwable th) {
                if (0 != 0) {
                    cursor.close();
                }
                throw th;
            }
        } catch (SQLiteException e2) {
            zzj().zzg().zza("Database error querying filters. appId", zzfr.zza(str), e2);
            Map<Integer, List<com.google.android.gms.internal.measurement.zzew.zze>> mapEmptyMap2 = Collections.emptyMap();
            if (0 != 0) {
                cursor.close();
            }
            return mapEmptyMap2;
        }
    }

    final Map<Integer, List<Integer>> zzl(String str) {
        zzak();
        zzt();
        Preconditions.checkNotEmpty(str);
        ArrayMap arrayMap = new ArrayMap();
        Cursor cursor = null;
        try {
            try {
                Cursor cursorRawQuery = m30e_().rawQuery("select audience_id, filter_id from event_filters where app_id = ? and session_scoped = 1 UNION select audience_id, filter_id from property_filters where app_id = ? and session_scoped = 1;", new String[]{str, str});
                if (!cursorRawQuery.moveToFirst()) {
                    Map<Integer, List<Integer>> mapEmptyMap = Collections.emptyMap();
                    if (cursorRawQuery != null) {
                        cursorRawQuery.close();
                    }
                    return mapEmptyMap;
                }
                do {
                    int i = cursorRawQuery.getInt(0);
                    List arrayList = (List) arrayMap.get(Integer.valueOf(i));
                    if (arrayList == null) {
                        arrayList = new ArrayList();
                        arrayMap.put(Integer.valueOf(i), arrayList);
                    }
                    arrayList.add(Integer.valueOf(cursorRawQuery.getInt(1)));
                } while (cursorRawQuery.moveToNext());
                if (cursorRawQuery != null) {
                    cursorRawQuery.close();
                }
                return arrayMap;
            } catch (SQLiteException e) {
                zzj().zzg().zza("Database error querying scoped filters. appId", zzfr.zza(str), e);
                Map<Integer, List<Integer>> mapEmptyMap2 = Collections.emptyMap();
                if (0 != 0) {
                    cursor.close();
                }
                return mapEmptyMap2;
            }
        } catch (Throwable th) {
            if (0 != 0) {
                cursor.close();
            }
            throw th;
        }
    }

    zzao(zzmp zzmpVar) {
        super(zzmpVar);
        this.zzm = new zzmi(zzb());
        this.zzl = new zzau(this, zza(), "google_app_measurement.db");
    }

    public final void zzp() {
        zzak();
        m30e_().beginTransaction();
    }

    public final void zzu() {
        zzak();
        m30e_().endTransaction();
    }

    final void zza(List<Long> list) {
        zzt();
        zzak();
        Preconditions.checkNotNull(list);
        Preconditions.checkNotZero(list.size());
        if (zzan()) {
            String str = "(" + TextUtils.join(",", list) + ")";
            if (zzb("SELECT COUNT(1) FROM queue WHERE rowid IN " + str + " AND retry_count =  2147483647 LIMIT 1", (String[]) null) > 0) {
                zzj().zzu().zza("The number of upload retries exceeds the limit. Will remain unchanged.");
            }
            try {
                m30e_().execSQL("UPDATE queue SET retry_count = IFNULL(retry_count, 0) + 1 WHERE rowid IN " + str + " AND (retry_count IS NULL OR retry_count < 2147483647)");
            } catch (SQLiteException e) {
                zzj().zzg().zza("Error incrementing retry count. error", e);
            }
        }
    }

    final void zzv() {
        int iDelete;
        zzt();
        zzak();
        if (zzan()) {
            long jZza = zzn().zza.zza();
            long jElapsedRealtime = zzb().elapsedRealtime();
            if (Math.abs(jElapsedRealtime - jZza) > zzbi.zzy.zza(null).longValue()) {
                zzn().zza.zza(jElapsedRealtime);
                zzt();
                zzak();
                if (!zzan() || (iDelete = m30e_().delete("queue", "abs(bundle_end_timestamp - ?) > cast(? as integer)", new String[]{String.valueOf(zzb().currentTimeMillis()), String.valueOf(zzaf.zzm())})) <= 0) {
                    return;
                }
                zzj().zzp().zza("Deleted stale rows. rowsDeleted", Integer.valueOf(iDelete));
            }
        }
    }

    public final void zzh(String str, String str2) {
        Preconditions.checkNotEmpty(str);
        Preconditions.checkNotEmpty(str2);
        zzt();
        zzak();
        try {
            m30e_().delete("user_attributes", "app_id=? and name=?", new String[]{str, str2});
        } catch (SQLiteException e) {
            zzj().zzg().zza("Error deleting user property. appId", zzfr.zza(str), zzi().zzc(str2), e);
        }
    }

    private static void zza(ContentValues contentValues, String str, Object obj) {
        Preconditions.checkNotEmpty(str);
        Preconditions.checkNotNull(obj);
        if (obj instanceof String) {
            contentValues.put(str, (String) obj);
        } else if (obj instanceof Long) {
            contentValues.put(str, (Long) obj);
        } else {
            if (obj instanceof Double) {
                contentValues.put(str, (Double) obj);
                return;
            }
            throw new IllegalArgumentException("Invalid value type");
        }
    }

    final void zza(String str, List<com.google.android.gms.internal.measurement.zzew.zza> list) {
        boolean z;
        boolean z2;
        Preconditions.checkNotNull(list);
        for (int i = 0; i < list.size(); i++) {
            com.google.android.gms.internal.measurement.zzew.zza.C1168zza c1168zzaZzby = list.get(i).zzby();
            if (c1168zzaZzby.zza() != 0) {
                for (int i2 = 0; i2 < c1168zzaZzby.zza(); i2++) {
                    com.google.android.gms.internal.measurement.zzew.zzb.zza zzaVarZzby = c1168zzaZzby.zza(i2).zzby();
                    com.google.android.gms.internal.measurement.zzew.zzb.zza zzaVar = (com.google.android.gms.internal.measurement.zzew.zzb.zza) ((com.google.android.gms.internal.measurement.zzix.zzb) zzaVarZzby.clone());
                    String strZzb = zzii.zzb(zzaVarZzby.zzb());
                    if (strZzb != null) {
                        zzaVar.zza(strZzb);
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    for (int i3 = 0; i3 < zzaVarZzby.zza(); i3++) {
                        com.google.android.gms.internal.measurement.zzew.zzc zzcVarZza = zzaVarZzby.zza(i3);
                        String strZza = zzik.zza(zzcVarZza.zze());
                        if (strZza != null) {
                            zzaVar.zza(i3, (com.google.android.gms.internal.measurement.zzew.zzc) ((com.google.android.gms.internal.measurement.zzix) zzcVarZza.zzby().zza(strZza).zzab()));
                            z2 = true;
                        }
                    }
                    if (z2) {
                        c1168zzaZzby = c1168zzaZzby.zza(i2, zzaVar);
                        list.set(i, (com.google.android.gms.internal.measurement.zzew.zza) ((com.google.android.gms.internal.measurement.zzix) c1168zzaZzby.zzab()));
                    }
                }
            }
            if (c1168zzaZzby.zzb() != 0) {
                for (int i4 = 0; i4 < c1168zzaZzby.zzb(); i4++) {
                    com.google.android.gms.internal.measurement.zzew.zze zzeVarZzb = c1168zzaZzby.zzb(i4);
                    String strZza2 = zzij.zza(zzeVarZzb.zze());
                    if (strZza2 != null) {
                        c1168zzaZzby = c1168zzaZzby.zza(i4, zzeVarZzb.zzby().zza(strZza2));
                        list.set(i, (com.google.android.gms.internal.measurement.zzew.zza) ((com.google.android.gms.internal.measurement.zzix) c1168zzaZzby.zzab()));
                    }
                }
            }
        }
        zzak();
        zzt();
        Preconditions.checkNotEmpty(str);
        Preconditions.checkNotNull(list);
        SQLiteDatabase sQLiteDatabaseM30e_ = m30e_();
        sQLiteDatabaseM30e_.beginTransaction();
        try {
            zzak();
            zzt();
            Preconditions.checkNotEmpty(str);
            SQLiteDatabase sQLiteDatabaseM30e_2 = m30e_();
            sQLiteDatabaseM30e_2.delete("property_filters", "app_id=?", new String[]{str});
            sQLiteDatabaseM30e_2.delete("event_filters", "app_id=?", new String[]{str});
            for (com.google.android.gms.internal.measurement.zzew.zza zzaVar2 : list) {
                zzak();
                zzt();
                Preconditions.checkNotEmpty(str);
                Preconditions.checkNotNull(zzaVar2);
                if (!zzaVar2.zzg()) {
                    zzj().zzu().zza("Audience with no ID. appId", zzfr.zza(str));
                } else {
                    int iZza = zzaVar2.zza();
                    Iterator<com.google.android.gms.internal.measurement.zzew.zzb> it = zzaVar2.zze().iterator();
                    while (true) {
                        if (it.hasNext()) {
                            if (!it.next().zzl()) {
                                zzj().zzu().zza("Event filter with no ID. Audience definition ignored. appId, audienceId", zzfr.zza(str), Integer.valueOf(iZza));
                                break;
                            }
                        } else {
                            Iterator<com.google.android.gms.internal.measurement.zzew.zze> it2 = zzaVar2.zzf().iterator();
                            while (true) {
                                if (it2.hasNext()) {
                                    if (!it2.next().zzi()) {
                                        zzj().zzu().zza("Property filter with no ID. Audience definition ignored. appId, audienceId", zzfr.zza(str), Integer.valueOf(iZza));
                                        break;
                                    }
                                } else {
                                    Iterator<com.google.android.gms.internal.measurement.zzew.zzb> it3 = zzaVar2.zze().iterator();
                                    while (true) {
                                        if (it3.hasNext()) {
                                            if (!zza(str, iZza, it3.next())) {
                                                z = false;
                                                break;
                                            }
                                        } else {
                                            z = true;
                                            break;
                                        }
                                    }
                                    if (z) {
                                        Iterator<com.google.android.gms.internal.measurement.zzew.zze> it4 = zzaVar2.zzf().iterator();
                                        while (it4.hasNext()) {
                                            if (!zza(str, iZza, it4.next())) {
                                                z = false;
                                                break;
                                            }
                                        }
                                    }
                                    if (!z) {
                                        zzak();
                                        zzt();
                                        Preconditions.checkNotEmpty(str);
                                        SQLiteDatabase sQLiteDatabaseM30e_3 = m30e_();
                                        sQLiteDatabaseM30e_3.delete("property_filters", "app_id=? and audience_id=?", new String[]{str, String.valueOf(iZza)});
                                        sQLiteDatabaseM30e_3.delete("event_filters", "app_id=? and audience_id=?", new String[]{str, String.valueOf(iZza)});
                                        break;
                                    }
                                    break;
                                }
                            }
                        }
                    }
                }
            }
            ArrayList arrayList = new ArrayList();
            for (com.google.android.gms.internal.measurement.zzew.zza zzaVar3 : list) {
                arrayList.add(zzaVar3.zzg() ? Integer.valueOf(zzaVar3.zza()) : null);
            }
            zzb(str, arrayList);
            sQLiteDatabaseM30e_.setTransactionSuccessful();
        } finally {
            sQLiteDatabaseM30e_.endTransaction();
        }
    }

    public final void zzw() {
        zzak();
        m30e_().setTransactionSuccessful();
    }

    public final void zza(zzh zzhVar) {
        Preconditions.checkNotNull(zzhVar);
        zzt();
        zzak();
        String strZzx = zzhVar.zzx();
        Preconditions.checkNotNull(strZzx);
        ContentValues contentValues = new ContentValues();
        contentValues.put("app_id", strZzx);
        contentValues.put("app_instance_id", zzhVar.zzy());
        contentValues.put("gmp_app_id", zzhVar.zzac());
        contentValues.put("resettable_device_id_hash", zzhVar.zzae());
        contentValues.put("last_bundle_index", Long.valueOf(zzhVar.zzq()));
        contentValues.put("last_bundle_start_timestamp", Long.valueOf(zzhVar.zzr()));
        contentValues.put("last_bundle_end_timestamp", Long.valueOf(zzhVar.zzp()));
        contentValues.put("app_version", zzhVar.zzaa());
        contentValues.put("app_store", zzhVar.zzz());
        contentValues.put("gmp_version", Long.valueOf(zzhVar.zzo()));
        contentValues.put("dev_cert_hash", Long.valueOf(zzhVar.zzl()));
        contentValues.put("measurement_enabled", Boolean.valueOf(zzhVar.zzak()));
        contentValues.put("day", Long.valueOf(zzhVar.zzk()));
        contentValues.put("daily_public_events_count", Long.valueOf(zzhVar.zzi()));
        contentValues.put("daily_events_count", Long.valueOf(zzhVar.zzh()));
        contentValues.put("daily_conversions_count", Long.valueOf(zzhVar.zzf()));
        contentValues.put("config_fetched_time", Long.valueOf(zzhVar.zze()));
        contentValues.put("failed_config_fetch_time", Long.valueOf(zzhVar.zzn()));
        contentValues.put("app_version_int", Long.valueOf(zzhVar.zzc()));
        contentValues.put("firebase_instance_id", zzhVar.zzab());
        contentValues.put("daily_error_events_count", Long.valueOf(zzhVar.zzg()));
        contentValues.put("daily_realtime_events_count", Long.valueOf(zzhVar.zzj()));
        contentValues.put("health_monitor_sample", zzhVar.zzad());
        contentValues.put("android_id", Long.valueOf(zzhVar.zzb()));
        contentValues.put("adid_reporting_enabled", Boolean.valueOf(zzhVar.zzaj()));
        contentValues.put("admob_app_id", zzhVar.zzv());
        contentValues.put("dynamite_version", Long.valueOf(zzhVar.zzm()));
        contentValues.put("session_stitching_token", zzhVar.zzaf());
        contentValues.put("sgtm_upload_enabled", Boolean.valueOf(zzhVar.zzam()));
        contentValues.put("target_os_version", Long.valueOf(zzhVar.zzt()));
        contentValues.put("session_stitching_token_hash", Long.valueOf(zzhVar.zzs()));
        if (zzpg.zza() && zze().zze(strZzx, zzbi.zzcf)) {
            contentValues.put("ad_services_version", Integer.valueOf(zzhVar.zza()));
            contentValues.put("attribution_eligibility_status", Long.valueOf(zzhVar.zzd()));
        }
        if (zznk.zza() && zze().zze(strZzx, zzbi.zzcr)) {
            contentValues.put("unmatched_first_open_without_ad_id", Boolean.valueOf(zzhVar.zzan()));
        }
        List<String> listZzag = zzhVar.zzag();
        if (listZzag != null) {
            if (listZzag.isEmpty()) {
                zzj().zzu().zza("Safelisted events should not be an empty list. appId", strZzx);
            } else {
                contentValues.put("safelisted_events", TextUtils.join(",", listZzag));
            }
        }
        if (zznq.zza() && zze().zza(zzbi.zzbp) && !contentValues.containsKey("safelisted_events")) {
            contentValues.put("safelisted_events", (String) null);
        }
        if (zznp.zza() && zze().zze(strZzx, zzbi.zzcm)) {
            contentValues.put("npa_metadata_value", zzhVar.zzu());
        }
        try {
            SQLiteDatabase sQLiteDatabaseM30e_ = m30e_();
            if (sQLiteDatabaseM30e_.update("apps", contentValues, "app_id = ?", new String[]{strZzx}) == 0 && sQLiteDatabaseM30e_.insertWithOnConflict("apps", null, contentValues, 5) == -1) {
                zzj().zzg().zza("Failed to insert/update app (got -1). appId", zzfr.zza(strZzx));
            }
        } catch (SQLiteException e) {
            zzj().zzg().zza("Error storing app. appId", zzfr.zza(strZzx), e);
        }
    }

    public final void zza(String str, zzih zzihVar) {
        Preconditions.checkNotNull(str);
        Preconditions.checkNotNull(zzihVar);
        zzt();
        zzak();
        ContentValues contentValues = new ContentValues();
        contentValues.put("app_id", str);
        contentValues.put("consent_state", zzihVar.zze());
        if (zznp.zza() && zze().zza(zzbi.zzcm)) {
            contentValues.put("consent_source", Integer.valueOf(zzihVar.zza()));
            zza("consent_settings", "app_id", contentValues);
            return;
        }
        try {
            if (m30e_().insertWithOnConflict("consent_settings", null, contentValues, 5) == -1) {
                zzj().zzg().zza("Failed to insert/update consent setting (got -1). appId", zzfr.zza(str));
            }
        } catch (SQLiteException e) {
            zzj().zzg().zza("Error storing consent setting. appId, error", zzfr.zza(str), e);
        }
    }

    public final void zza(String str, zzay zzayVar) {
        if (zznp.zza() && zze().zza(zzbi.zzcm)) {
            Preconditions.checkNotNull(str);
            Preconditions.checkNotNull(zzayVar);
            zzt();
            zzak();
            ContentValues contentValues = new ContentValues();
            contentValues.put("app_id", str);
            contentValues.put("dma_consent_settings", zzayVar.zzf());
            zza("consent_settings", "app_id", contentValues);
        }
    }

    public final void zza(zzbc zzbcVar) {
        Preconditions.checkNotNull(zzbcVar);
        zzt();
        zzak();
        ContentValues contentValues = new ContentValues();
        contentValues.put("app_id", zzbcVar.zza);
        contentValues.put(AppMeasurementSdk.ConditionalUserProperty.NAME, zzbcVar.zzb);
        contentValues.put("lifetime_count", Long.valueOf(zzbcVar.zzc));
        contentValues.put("current_bundle_count", Long.valueOf(zzbcVar.zzd));
        contentValues.put("last_fire_timestamp", Long.valueOf(zzbcVar.zzf));
        contentValues.put("last_bundled_timestamp", Long.valueOf(zzbcVar.zzg));
        contentValues.put("last_bundled_day", zzbcVar.zzh);
        contentValues.put("last_sampled_complex_event_id", zzbcVar.zzi);
        contentValues.put("last_sampling_rate", zzbcVar.zzj);
        contentValues.put("current_session_count", Long.valueOf(zzbcVar.zze));
        contentValues.put("last_exempt_from_sampling", (zzbcVar.zzk == null || !zzbcVar.zzk.booleanValue()) ? null : 1L);
        try {
            if (m30e_().insertWithOnConflict("events", null, contentValues, 5) == -1) {
                zzj().zzg().zza("Failed to insert/update event aggregates (got -1). appId", zzfr.zza(zzbcVar.zza));
            }
        } catch (SQLiteException e) {
            zzj().zzg().zza("Error storing event aggregates. appId", zzfr.zza(zzbcVar.zza), e);
        }
    }

    private final void zza(String str, String str2, ContentValues contentValues) {
        try {
            SQLiteDatabase sQLiteDatabaseM30e_ = m30e_();
            String asString = contentValues.getAsString(str2);
            if (asString == null) {
                zzj().zzh().zza("Value of the primary key is not set.", zzfr.zza(str2));
                return;
            }
            if (sQLiteDatabaseM30e_.update(str, contentValues, str2 + " = ?", new String[]{asString}) == 0 && sQLiteDatabaseM30e_.insertWithOnConflict(str, null, contentValues, 5) == -1) {
                zzj().zzg().zza("Failed to insert/update table (got -1). key", zzfr.zza(str), zzfr.zza(str2));
            }
        } catch (SQLiteException e) {
            zzj().zzg().zza("Error storing into table. key", zzfr.zza(str), zzfr.zza(str2), e);
        }
    }

    private final boolean zzb(String str, List<Integer> list) {
        Preconditions.checkNotEmpty(str);
        zzak();
        zzt();
        SQLiteDatabase sQLiteDatabaseM30e_ = m30e_();
        try {
            long jZzb = zzb("select count(1) from audience_filter_values where app_id=?", new String[]{str});
            int iMax = Math.max(0, Math.min(2000, zze().zzb(str, zzbi.zzaf)));
            if (jZzb <= iMax) {
                return false;
            }
            ArrayList arrayList = new ArrayList();
            for (int i = 0; i < list.size(); i++) {
                Integer num = list.get(i);
                if (num == null) {
                    return false;
                }
                arrayList.add(Integer.toString(num.intValue()));
            }
            String str2 = "(" + TextUtils.join(",", arrayList) + ")";
            StringBuilder sb = new StringBuilder("audience_id in (select audience_id from audience_filter_values where app_id=? and audience_id not in ");
            sb.append(str2);
            sb.append(" order by rowid desc limit -1 offset ?)");
            return sQLiteDatabaseM30e_.delete("audience_filter_values", sb.toString(), new String[]{str, Integer.toString(iMax)}) > 0;
        } catch (SQLiteException e) {
            zzj().zzg().zza("Database error querying filters. appId", zzfr.zza(str), e);
            return false;
        }
    }

    public final boolean zzx() {
        return zzb("select count(1) > 0 from raw_events", (String[]) null) != 0;
    }

    public final boolean zzy() {
        return zzb("select count(1) > 0 from queue where has_realtime = 1", (String[]) null) != 0;
    }

    public final boolean zzz() {
        return zzb("select count(1) > 0 from raw_events where realtime = 1", (String[]) null) != 0;
    }

    public final boolean zza(com.google.android.gms.internal.measurement.zzfi.zzj zzjVar, boolean z) {
        zzt();
        zzak();
        Preconditions.checkNotNull(zzjVar);
        Preconditions.checkNotEmpty(zzjVar.zzx());
        Preconditions.checkState(zzjVar.zzbe());
        zzv();
        long jCurrentTimeMillis = zzb().currentTimeMillis();
        if (zzjVar.zzl() < jCurrentTimeMillis - zzaf.zzm() || zzjVar.zzl() > zzaf.zzm() + jCurrentTimeMillis) {
            zzj().zzu().zza("Storing bundle outside of the max uploading time span. appId, now, timestamp", zzfr.zza(zzjVar.zzx()), Long.valueOf(jCurrentTimeMillis), Long.valueOf(zzjVar.zzl()));
        }
        try {
            byte[] bArrZzb = mo32g_().zzb(zzjVar.zzbv());
            zzj().zzp().zza("Saving bundle, size", Integer.valueOf(bArrZzb.length));
            ContentValues contentValues = new ContentValues();
            contentValues.put("app_id", zzjVar.zzx());
            contentValues.put("bundle_end_timestamp", Long.valueOf(zzjVar.zzl()));
            contentValues.put("data", bArrZzb);
            contentValues.put("has_realtime", Integer.valueOf(z ? 1 : 0));
            if (zzjVar.zzbl()) {
                contentValues.put("retry_count", Integer.valueOf(zzjVar.zzf()));
            }
            try {
                if (m30e_().insert("queue", null, contentValues) != -1) {
                    return true;
                }
                zzj().zzg().zza("Failed to insert bundle (got -1). appId", zzfr.zza(zzjVar.zzx()));
                return false;
            } catch (SQLiteException e) {
                zzj().zzg().zza("Error storing bundle. appId", zzfr.zza(zzjVar.zzx()), e);
                return false;
            }
        } catch (IOException e2) {
            zzj().zzg().zza("Data loss. Failed to serialize bundle. appId", zzfr.zza(zzjVar.zzx()), e2);
            return false;
        }
    }

    private final boolean zza(String str, int i, com.google.android.gms.internal.measurement.zzew.zzb zzbVar) {
        zzak();
        zzt();
        Preconditions.checkNotEmpty(str);
        Preconditions.checkNotNull(zzbVar);
        if (zzbVar.zzf().isEmpty()) {
            zzj().zzu().zza("Event filter had no event name. Audience definition ignored. appId, audienceId, filterId", zzfr.zza(str), Integer.valueOf(i), String.valueOf(zzbVar.zzl() ? Integer.valueOf(zzbVar.zzb()) : null));
            return false;
        }
        byte[] bArrZzbv = zzbVar.zzbv();
        ContentValues contentValues = new ContentValues();
        contentValues.put("app_id", str);
        contentValues.put("audience_id", Integer.valueOf(i));
        contentValues.put("filter_id", zzbVar.zzl() ? Integer.valueOf(zzbVar.zzb()) : null);
        contentValues.put("event_name", zzbVar.zzf());
        contentValues.put("session_scoped", zzbVar.zzm() ? Boolean.valueOf(zzbVar.zzj()) : null);
        contentValues.put("data", bArrZzbv);
        try {
            if (m30e_().insertWithOnConflict("event_filters", null, contentValues, 5) != -1) {
                return true;
            }
            zzj().zzg().zza("Failed to insert event filter (got -1). appId", zzfr.zza(str));
            return true;
        } catch (SQLiteException e) {
            zzj().zzg().zza("Error storing event filter. appId", zzfr.zza(str), e);
            return false;
        }
    }

    private final boolean zza(String str, int i, com.google.android.gms.internal.measurement.zzew.zze zzeVar) {
        zzak();
        zzt();
        Preconditions.checkNotEmpty(str);
        Preconditions.checkNotNull(zzeVar);
        if (zzeVar.zze().isEmpty()) {
            zzj().zzu().zza("Property filter had no property name. Audience definition ignored. appId, audienceId, filterId", zzfr.zza(str), Integer.valueOf(i), String.valueOf(zzeVar.zzi() ? Integer.valueOf(zzeVar.zza()) : null));
            return false;
        }
        byte[] bArrZzbv = zzeVar.zzbv();
        ContentValues contentValues = new ContentValues();
        contentValues.put("app_id", str);
        contentValues.put("audience_id", Integer.valueOf(i));
        contentValues.put("filter_id", zzeVar.zzi() ? Integer.valueOf(zzeVar.zza()) : null);
        contentValues.put("property_name", zzeVar.zze());
        contentValues.put("session_scoped", zzeVar.zzj() ? Boolean.valueOf(zzeVar.zzh()) : null);
        contentValues.put("data", bArrZzbv);
        try {
            if (m30e_().insertWithOnConflict("property_filters", null, contentValues, 5) != -1) {
                return true;
            }
            zzj().zzg().zza("Failed to insert property filter (got -1). appId", zzfr.zza(str));
            return false;
        } catch (SQLiteException e) {
            zzj().zzg().zza("Error storing property filter. appId", zzfr.zza(str), e);
            return false;
        }
    }

    public final boolean zza(zzaz zzazVar, long j, boolean z) {
        zzt();
        zzak();
        Preconditions.checkNotNull(zzazVar);
        Preconditions.checkNotEmpty(zzazVar.zza);
        byte[] bArrZzbv = mo32g_().zza(zzazVar).zzbv();
        ContentValues contentValues = new ContentValues();
        contentValues.put("app_id", zzazVar.zza);
        contentValues.put(AppMeasurementSdk.ConditionalUserProperty.NAME, zzazVar.zzb);
        contentValues.put("timestamp", Long.valueOf(zzazVar.zzc));
        contentValues.put("metadata_fingerprint", Long.valueOf(j));
        contentValues.put("data", bArrZzbv);
        contentValues.put("realtime", Integer.valueOf(z ? 1 : 0));
        try {
            if (m30e_().insert("raw_events", null, contentValues) != -1) {
                return true;
            }
            zzj().zzg().zza("Failed to insert raw event (got -1). appId", zzfr.zza(zzazVar.zza));
            return false;
        } catch (SQLiteException e) {
            zzj().zzg().zza("Error storing raw event. appId", zzfr.zza(zzazVar.zza), e);
            return false;
        }
    }

    public final boolean zza(String str, zzmh zzmhVar) {
        zzt();
        zzak();
        Preconditions.checkNotNull(zzmhVar);
        Preconditions.checkNotEmpty(str);
        long jCurrentTimeMillis = zzb().currentTimeMillis();
        if (zzmhVar.zzb < jCurrentTimeMillis - zzaf.zzm() || zzmhVar.zzb > zzaf.zzm() + jCurrentTimeMillis) {
            zzj().zzu().zza("Storing trigger URI outside of the max retention time span. appId, now, timestamp", zzfr.zza(str), Long.valueOf(jCurrentTimeMillis), Long.valueOf(zzmhVar.zzb));
        }
        zzj().zzp().zza("Saving trigger URI");
        ContentValues contentValues = new ContentValues();
        contentValues.put("app_id", str);
        contentValues.put("trigger_uri", zzmhVar.zza);
        contentValues.put("source", Integer.valueOf(zzmhVar.zzc));
        contentValues.put("timestamp_millis", Long.valueOf(zzmhVar.zzb));
        try {
            if (m30e_().insert("trigger_uris", null, contentValues) != -1) {
                return true;
            }
            zzj().zzg().zza("Failed to insert trigger URI (got -1). appId", zzfr.zza(str));
            return false;
        } catch (SQLiteException e) {
            zzj().zzg().zza("Error storing trigger URI. appId", zzfr.zza(str), e);
            return false;
        }
    }

    private final boolean zzan() {
        return zza().getDatabasePath("google_app_measurement.db").exists();
    }

    public final boolean zza(String str, Long l, long j, com.google.android.gms.internal.measurement.zzfi.zze zzeVar) {
        zzt();
        zzak();
        Preconditions.checkNotNull(zzeVar);
        Preconditions.checkNotEmpty(str);
        Preconditions.checkNotNull(l);
        byte[] bArrZzbv = zzeVar.zzbv();
        zzj().zzp().zza("Saving complex main event, appId, data size", zzi().zza(str), Integer.valueOf(bArrZzbv.length));
        ContentValues contentValues = new ContentValues();
        contentValues.put("app_id", str);
        contentValues.put("event_id", l);
        contentValues.put("children_to_process", Long.valueOf(j));
        contentValues.put("main_event", bArrZzbv);
        try {
            if (m30e_().insertWithOnConflict("main_event_params", null, contentValues, 5) != -1) {
                return true;
            }
            zzj().zzg().zza("Failed to insert complex main event (got -1). appId", zzfr.zza(str));
            return false;
        } catch (SQLiteException e) {
            zzj().zzg().zza("Error storing complex main event. appId", zzfr.zza(str), e);
            return false;
        }
    }

    public final boolean zza(zzad zzadVar) {
        Preconditions.checkNotNull(zzadVar);
        zzt();
        zzak();
        String str = zzadVar.zza;
        Preconditions.checkNotNull(str);
        if (zze(str, zzadVar.zzc.zza) == null && zzb("SELECT COUNT(1) FROM conditional_properties WHERE app_id=?", new String[]{str}) >= 1000) {
            return false;
        }
        ContentValues contentValues = new ContentValues();
        contentValues.put("app_id", str);
        contentValues.put("origin", zzadVar.zzb);
        contentValues.put(AppMeasurementSdk.ConditionalUserProperty.NAME, zzadVar.zzc.zza);
        zza(contentValues, "value", Preconditions.checkNotNull(zzadVar.zzc.zza()));
        contentValues.put(AppMeasurementSdk.ConditionalUserProperty.ACTIVE, Boolean.valueOf(zzadVar.zze));
        contentValues.put(AppMeasurementSdk.ConditionalUserProperty.TRIGGER_EVENT_NAME, zzadVar.zzf);
        contentValues.put(AppMeasurementSdk.ConditionalUserProperty.TRIGGER_TIMEOUT, Long.valueOf(zzadVar.zzh));
        zzq();
        contentValues.put("timed_out_event", zznd.zza((Parcelable) zzadVar.zzg));
        contentValues.put(AppMeasurementSdk.ConditionalUserProperty.CREATION_TIMESTAMP, Long.valueOf(zzadVar.zzd));
        zzq();
        contentValues.put("triggered_event", zznd.zza((Parcelable) zzadVar.zzi));
        contentValues.put(AppMeasurementSdk.ConditionalUserProperty.TRIGGERED_TIMESTAMP, Long.valueOf(zzadVar.zzc.zzb));
        contentValues.put(AppMeasurementSdk.ConditionalUserProperty.TIME_TO_LIVE, Long.valueOf(zzadVar.zzj));
        zzq();
        contentValues.put("expired_event", zznd.zza((Parcelable) zzadVar.zzk));
        try {
            if (m30e_().insertWithOnConflict("conditional_properties", null, contentValues, 5) != -1) {
                return true;
            }
            zzj().zzg().zza("Failed to insert/update conditional user property (got -1)", zzfr.zza(str));
            return true;
        } catch (SQLiteException e) {
            zzj().zzg().zza("Error storing conditional user property", zzfr.zza(str), e);
            return true;
        }
    }

    final boolean zza(String str, Bundle bundle) {
        zzt();
        zzak();
        byte[] bArrZzbv = mo32g_().zza(new zzaz(this.zzu, "", str, "dep", 0L, 0L, bundle)).zzbv();
        zzj().zzp().zza("Saving default event parameters, appId, data size", zzi().zza(str), Integer.valueOf(bArrZzbv.length));
        ContentValues contentValues = new ContentValues();
        contentValues.put("app_id", str);
        contentValues.put("parameters", bArrZzbv);
        try {
            if (m30e_().insertWithOnConflict("default_event_params", null, contentValues, 5) != -1) {
                return true;
            }
            zzj().zzg().zza("Failed to insert default event parameters (got -1). appId", zzfr.zza(str));
            return false;
        } catch (SQLiteException e) {
            zzj().zzg().zza("Error storing default event parameters. appId", zzfr.zza(str), e);
            return false;
        }
    }

    public final boolean zza(zzne zzneVar) {
        Preconditions.checkNotNull(zzneVar);
        zzt();
        zzak();
        if (zze(zzneVar.zza, zzneVar.zzc) == null) {
            if (zznd.zzh(zzneVar.zzc)) {
                if (zzb("select count(1) from user_attributes where app_id=? and name not like '!_%' escape '!'", new String[]{zzneVar.zza}) >= zze().zza(zzneVar.zza, zzbi.zzag, 25, 100)) {
                    return false;
                }
            } else if (!"_npa".equals(zzneVar.zzc) && zzb("select count(1) from user_attributes where app_id=? and origin=? AND name like '!_%' escape '!'", new String[]{zzneVar.zza, zzneVar.zzb}) >= 25) {
                return false;
            }
        }
        ContentValues contentValues = new ContentValues();
        contentValues.put("app_id", zzneVar.zza);
        contentValues.put("origin", zzneVar.zzb);
        contentValues.put(AppMeasurementSdk.ConditionalUserProperty.NAME, zzneVar.zzc);
        contentValues.put("set_timestamp", Long.valueOf(zzneVar.zzd));
        zza(contentValues, "value", zzneVar.zze);
        try {
            if (m30e_().insertWithOnConflict("user_attributes", null, contentValues, 5) != -1) {
                return true;
            }
            zzj().zzg().zza("Failed to insert/update user property (got -1). appId", zzfr.zza(zzneVar.zza));
            return true;
        } catch (SQLiteException e) {
            zzj().zzg().zza("Error storing user property. appId", zzfr.zza(zzneVar.zza), e);
            return true;
        }
    }
}
