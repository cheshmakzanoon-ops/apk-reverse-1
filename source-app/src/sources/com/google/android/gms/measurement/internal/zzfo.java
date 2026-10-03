package com.google.android.gms.measurement.internal;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteDatabaseLockedException;
import android.database.sqlite.SQLiteException;
import android.database.sqlite.SQLiteFullException;
import android.os.Parcel;
import android.os.Parcelable;
import android.os.SystemClock;
import com.google.android.gms.common.internal.safeparcel.AbstractSafeParcelable;
import com.google.android.gms.common.internal.safeparcel.SafeParcelReader;
import com.google.android.gms.common.util.Clock;
import com.ishumei.smantifraud.l11l11I1111l;
import java.util.ArrayList;
import java.util.List;
import org.checkerframework.dataflow.qual.Pure;

public final class zzfo extends zze {
    private final zzfn zza;
    private boolean zzb;

    @Override
    protected final boolean zzz() {
        return false;
    }

    private static long zza(SQLiteDatabase sQLiteDatabase) {
        Cursor cursorQuery = null;
        try {
            cursorQuery = sQLiteDatabase.query("messages", new String[]{"rowid"}, "type=?", new String[]{"3"}, null, null, "rowid desc", "1");
            if (cursorQuery.moveToFirst()) {
                return cursorQuery.getLong(0);
            }
        } finally {
            if (cursorQuery != null) {
                cursorQuery.close();
            }
        }
    }

    @Override
    @Pure
    public final Context zza() {
        return super.zza();
    }

    private final SQLiteDatabase zzad() throws SQLiteException {
        if (this.zzb) {
            return null;
        }
        SQLiteDatabase writableDatabase = this.zza.getWritableDatabase();
        if (writableDatabase != null) {
            return writableDatabase;
        }
        this.zzb = true;
        return null;
    }

    @Override
    @Pure
    public final Clock zzb() {
        return super.zzb();
    }

    @Override
    public final zzb zzc() {
        return super.zzc();
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
    @Pure
    public final zzba zzf() {
        return super.zzf();
    }

    @Override
    public final zzfl zzg() {
        return super.zzg();
    }

    @Override
    public final zzfo zzh() {
        return super.zzh();
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
    @Pure
    public final zzgy zzl() {
        return super.zzl();
    }

    @Override
    public final zziq zzm() {
        return super.zzm();
    }

    @Override
    public final zzkh zzn() {
        return super.zzn();
    }

    @Override
    public final zzkp zzo() {
        return super.zzo();
    }

    @Override
    public final zzlx zzp() {
        return super.zzp();
    }

    @Override
    @Pure
    public final zznd zzq() {
        return super.zzq();
    }

    public final List<AbstractSafeParcelable> zza(int i) throws Throwable {
        SQLiteDatabase sQLiteDatabase;
        Cursor cursorQuery;
        SQLiteDatabase sQLiteDatabaseZzad;
        SQLiteDatabase sQLiteDatabase2;
        String str;
        String[] strArr;
        zznc zzncVarCreateFromParcel;
        zzad zzadVarCreateFromParcel;
        zzt();
        Cursor cursor = null;
        if (this.zzb) {
            return null;
        }
        ArrayList arrayList = new ArrayList();
        if (!zzae()) {
            return arrayList;
        }
        int i2 = 5;
        int i3 = 0;
        for (int i4 = 5; i3 < i4; i4 = 5) {
            try {
                sQLiteDatabaseZzad = zzad();
                try {
                    if (sQLiteDatabaseZzad == null) {
                        this.zzb = true;
                        if (sQLiteDatabaseZzad != null) {
                            sQLiteDatabaseZzad.close();
                        }
                        return null;
                    }
                    try {
                        sQLiteDatabaseZzad.beginTransaction();
                        long jZza = zza(sQLiteDatabaseZzad);
                        long j = -1;
                        if (jZza != -1) {
                            try {
                                str = "rowid<?";
                                strArr = new String[]{String.valueOf(jZza)};
                            } catch (SQLiteFullException e) {
                                e = e;
                                cursorQuery = null;
                                zzj().zzg().zza("Error reading entries from local database", e);
                                this.zzb = true;
                                if (cursorQuery != null) {
                                    cursorQuery.close();
                                }
                                if (sQLiteDatabaseZzad != null) {
                                    sQLiteDatabaseZzad.close();
                                }
                                i3++;
                            } catch (SQLiteException e2) {
                                e = e2;
                                cursorQuery = null;
                                if (sQLiteDatabaseZzad != null) {
                                    try {
                                        if (sQLiteDatabaseZzad.inTransaction()) {
                                            sQLiteDatabaseZzad.endTransaction();
                                        }
                                    } catch (Throwable th) {
                                        th = th;
                                        cursor = cursorQuery;
                                        sQLiteDatabase = sQLiteDatabaseZzad;
                                        if (cursor != null) {
                                            cursor.close();
                                        }
                                        if (sQLiteDatabase != null) {
                                            sQLiteDatabase.close();
                                        }
                                        throw th;
                                    }
                                }
                                zzj().zzg().zza("Error reading entries from local database", e);
                                this.zzb = true;
                                if (cursorQuery != null) {
                                    cursorQuery.close();
                                }
                                if (sQLiteDatabaseZzad != null) {
                                    sQLiteDatabaseZzad.close();
                                }
                                i3++;
                            }
                        } else {
                            str = null;
                            strArr = null;
                        }
                        sQLiteDatabase = sQLiteDatabaseZzad;
                        try {
                            cursorQuery = sQLiteDatabaseZzad.query("messages", new String[]{"rowid", l11l11I1111l.l111l1111l1Il, "entry"}, str, strArr, null, null, "rowid asc", Integer.toString(100));
                            while (cursorQuery.moveToNext()) {
                                try {
                                    j = cursorQuery.getLong(0);
                                    int i5 = cursorQuery.getInt(1);
                                    byte[] blob = cursorQuery.getBlob(2);
                                    if (i5 == 0) {
                                        Parcel parcelObtain = Parcel.obtain();
                                        try {
                                            try {
                                                parcelObtain.unmarshall(blob, 0, blob.length);
                                                parcelObtain.setDataPosition(0);
                                                zzbg zzbgVarCreateFromParcel = zzbg.CREATOR.createFromParcel(parcelObtain);
                                                parcelObtain.recycle();
                                                if (zzbgVarCreateFromParcel != null) {
                                                    arrayList.add(zzbgVarCreateFromParcel);
                                                }
                                            } catch (SafeParcelReader.ParseException unused) {
                                                zzj().zzg().zza("Failed to load event from local database");
                                                parcelObtain.recycle();
                                            }
                                        } catch (Throwable th2) {
                                            parcelObtain.recycle();
                                            throw th2;
                                        }
                                    } else if (i5 == 1) {
                                        Parcel parcelObtain2 = Parcel.obtain();
                                        try {
                                            try {
                                                parcelObtain2.unmarshall(blob, 0, blob.length);
                                                parcelObtain2.setDataPosition(0);
                                                zzncVarCreateFromParcel = zznc.CREATOR.createFromParcel(parcelObtain2);
                                                parcelObtain2.recycle();
                                            } catch (SafeParcelReader.ParseException unused2) {
                                                zzj().zzg().zza("Failed to load user property from local database");
                                                parcelObtain2.recycle();
                                                zzncVarCreateFromParcel = null;
                                            }
                                            if (zzncVarCreateFromParcel != null) {
                                                arrayList.add(zzncVarCreateFromParcel);
                                            }
                                        } catch (Throwable th3) {
                                            parcelObtain2.recycle();
                                            throw th3;
                                        }
                                    } else if (i5 == 2) {
                                        Parcel parcelObtain3 = Parcel.obtain();
                                        try {
                                            try {
                                                parcelObtain3.unmarshall(blob, 0, blob.length);
                                                parcelObtain3.setDataPosition(0);
                                                zzadVarCreateFromParcel = zzad.CREATOR.createFromParcel(parcelObtain3);
                                                parcelObtain3.recycle();
                                            } catch (SafeParcelReader.ParseException unused3) {
                                                zzj().zzg().zza("Failed to load conditional user property from local database");
                                                parcelObtain3.recycle();
                                                zzadVarCreateFromParcel = null;
                                            }
                                            if (zzadVarCreateFromParcel != null) {
                                                arrayList.add(zzadVarCreateFromParcel);
                                            }
                                        } catch (Throwable th4) {
                                            parcelObtain3.recycle();
                                            throw th4;
                                        }
                                    } else if (i5 == 3) {
                                        zzj().zzu().zza("Skipping app launch break");
                                    } else {
                                        zzj().zzg().zza("Unknown record type in local database");
                                    }
                                } catch (SQLiteDatabaseLockedException unused4) {
                                    sQLiteDatabase2 = sQLiteDatabase;
                                    SystemClock.sleep(i2);
                                    i2 += 20;
                                    if (cursorQuery != null) {
                                        cursorQuery.close();
                                    }
                                    if (sQLiteDatabase2 != null) {
                                        sQLiteDatabase2.close();
                                    }
                                    i3++;
                                } catch (SQLiteFullException e3) {
                                    e = e3;
                                    sQLiteDatabaseZzad = sQLiteDatabase;
                                    zzj().zzg().zza("Error reading entries from local database", e);
                                    this.zzb = true;
                                    if (cursorQuery != null) {
                                        cursorQuery.close();
                                    }
                                    if (sQLiteDatabaseZzad != null) {
                                        sQLiteDatabaseZzad.close();
                                    }
                                    i3++;
                                } catch (SQLiteException e4) {
                                    e = e4;
                                    sQLiteDatabaseZzad = sQLiteDatabase;
                                    if (sQLiteDatabaseZzad != null) {
                                        if (sQLiteDatabaseZzad.inTransaction()) {
                                            sQLiteDatabaseZzad.endTransaction();
                                        }
                                    }
                                    zzj().zzg().zza("Error reading entries from local database", e);
                                    this.zzb = true;
                                    if (cursorQuery != null) {
                                        cursorQuery.close();
                                    }
                                    if (sQLiteDatabaseZzad != null) {
                                        sQLiteDatabaseZzad.close();
                                    }
                                    i3++;
                                } catch (Throwable th5) {
                                    th = th5;
                                    cursor = cursorQuery;
                                    if (cursor != null) {
                                        cursor.close();
                                    }
                                    if (sQLiteDatabase != null) {
                                        sQLiteDatabase.close();
                                    }
                                    throw th;
                                }
                            }
                            if (sQLiteDatabase.delete("messages", "rowid <= ?", new String[]{Long.toString(j)}) < arrayList.size()) {
                                zzj().zzg().zza("Fewer entries removed from local database than expected");
                            }
                            sQLiteDatabase.setTransactionSuccessful();
                            sQLiteDatabase.endTransaction();
                            if (cursorQuery != null) {
                                cursorQuery.close();
                            }
                            if (sQLiteDatabase != null) {
                                sQLiteDatabase.close();
                            }
                            return arrayList;
                        } catch (SQLiteDatabaseLockedException unused5) {
                            cursorQuery = null;
                            sQLiteDatabase2 = sQLiteDatabase;
                            SystemClock.sleep(i2);
                            i2 += 20;
                            if (cursorQuery != null) {
                                cursorQuery.close();
                            }
                            if (sQLiteDatabase2 != null) {
                                sQLiteDatabase2.close();
                            }
                            i3++;
                        } catch (SQLiteFullException e5) {
                            e = e5;
                            cursorQuery = null;
                        } catch (SQLiteException e6) {
                            e = e6;
                            cursorQuery = null;
                        } catch (Throwable th6) {
                            th = th6;
                        }
                    } catch (SQLiteFullException e7) {
                        e = e7;
                        cursorQuery = null;
                        zzj().zzg().zza("Error reading entries from local database", e);
                        this.zzb = true;
                        if (cursorQuery != null) {
                            cursorQuery.close();
                        }
                        if (sQLiteDatabaseZzad != null) {
                            sQLiteDatabaseZzad.close();
                        }
                        i3++;
                    } catch (SQLiteException e8) {
                        e = e8;
                        cursorQuery = null;
                        if (sQLiteDatabaseZzad != null) {
                            if (sQLiteDatabaseZzad.inTransaction()) {
                                sQLiteDatabaseZzad.endTransaction();
                            }
                        }
                        zzj().zzg().zza("Error reading entries from local database", e);
                        this.zzb = true;
                        if (cursorQuery != null) {
                            cursorQuery.close();
                        }
                        if (sQLiteDatabaseZzad != null) {
                            sQLiteDatabaseZzad.close();
                        }
                        i3++;
                    }
                } catch (SQLiteDatabaseLockedException unused6) {
                    sQLiteDatabase = sQLiteDatabaseZzad;
                } catch (Throwable th7) {
                    th = th7;
                    sQLiteDatabase = sQLiteDatabaseZzad;
                    if (cursor != null) {
                        cursor.close();
                    }
                    if (sQLiteDatabase != null) {
                        sQLiteDatabase.close();
                    }
                    throw th;
                }
            } catch (SQLiteDatabaseLockedException unused7) {
                cursorQuery = null;
                sQLiteDatabase2 = null;
            } catch (SQLiteFullException e9) {
                e = e9;
                cursorQuery = null;
                sQLiteDatabaseZzad = null;
            } catch (SQLiteException e10) {
                e = e10;
                cursorQuery = null;
                sQLiteDatabaseZzad = null;
            } catch (Throwable th8) {
                th = th8;
                sQLiteDatabase = null;
            }
        }
        zzj().zzu().zza("Failed to read events from database in reasonable time");
        return null;
    }

    zzfo(zzhf zzhfVar) {
        super(zzhfVar);
        this.zza = new zzfn(this, zza(), "google_app_measurement_local.db");
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

    public final void zzaa() {
        int iDelete;
        zzt();
        try {
            SQLiteDatabase sQLiteDatabaseZzad = zzad();
            if (sQLiteDatabaseZzad == null || (iDelete = sQLiteDatabaseZzad.delete("messages", null, null)) <= 0) {
                return;
            }
            zzj().zzp().zza("Reset local analytics data. records", Integer.valueOf(iDelete));
        } catch (SQLiteException e) {
            zzj().zzg().zza("Error resetting local analytics data. error", e);
        }
    }

    public final boolean zzab() {
        return zza(3, new byte[0]);
    }

    private final boolean zzae() {
        return zza().getDatabasePath("google_app_measurement_local.db").exists();
    }

    public final boolean zzac() {
        zzt();
        if (this.zzb || !zzae()) {
            return false;
        }
        int i = 5;
        for (int i2 = 0; i2 < 5; i2++) {
            SQLiteDatabase sQLiteDatabase = null;
            try {
                SQLiteDatabase sQLiteDatabaseZzad = zzad();
                if (sQLiteDatabaseZzad == null) {
                    this.zzb = true;
                    if (sQLiteDatabaseZzad != null) {
                        sQLiteDatabaseZzad.close();
                    }
                    return false;
                }
                sQLiteDatabaseZzad.beginTransaction();
                sQLiteDatabaseZzad.delete("messages", "type == ?", new String[]{Integer.toString(3)});
                sQLiteDatabaseZzad.setTransactionSuccessful();
                sQLiteDatabaseZzad.endTransaction();
                if (sQLiteDatabaseZzad != null) {
                    sQLiteDatabaseZzad.close();
                }
                return true;
            } catch (SQLiteDatabaseLockedException unused) {
                SystemClock.sleep(i);
                i += 20;
                if (0 != 0) {
                    sQLiteDatabase.close();
                }
            } catch (SQLiteFullException e) {
                zzj().zzg().zza("Error deleting app launch break from local database", e);
                this.zzb = true;
                if (0 != 0) {
                    sQLiteDatabase.close();
                }
            } catch (SQLiteException e2) {
                if (0 != 0) {
                    try {
                        if (sQLiteDatabase.inTransaction()) {
                            sQLiteDatabase.endTransaction();
                        }
                    } catch (Throwable th) {
                        if (0 != 0) {
                            sQLiteDatabase.close();
                        }
                        throw th;
                    }
                }
                zzj().zzg().zza("Error deleting app launch break from local database", e2);
                this.zzb = true;
                if (0 != 0) {
                    sQLiteDatabase.close();
                }
            }
        }
        zzj().zzu().zza("Error deleting app launch break from local database in reasonable time");
        return false;
    }

    public final boolean zza(zzad zzadVar) {
        zzq();
        byte[] bArrZza = zznd.zza((Parcelable) zzadVar);
        if (bArrZza.length > 131072) {
            zzj().zzm().zza("Conditional user property too long for local database. Sending directly to service");
            return false;
        }
        return zza(2, bArrZza);
    }

    private final boolean zza(int i, byte[] bArr) throws Throwable {
        SQLiteDatabase sQLiteDatabaseZzad;
        ?? RawQuery;
        long j;
        zzt();
        ?? r2 = 0;
        if (this.zzb) {
            return false;
        }
        ContentValues contentValues = new ContentValues();
        contentValues.put(l11l11I1111l.l111l1111l1Il, Integer.valueOf(i));
        contentValues.put("entry", bArr);
        int i2 = 0;
        int i3 = 5;
        for (int i4 = 5; i2 < i4; i4 = 5) {
            ?? r7 = 0;
             = 0;
            r7 = 0;
            ?? r8 = 0;
            r7 = 0;
            SQLiteDatabase sQLiteDatabase = null;
            try {
                sQLiteDatabaseZzad = zzad();
                try {
                    if (sQLiteDatabaseZzad == null) {
                        this.zzb = true;
                        if (sQLiteDatabaseZzad != null) {
                            sQLiteDatabaseZzad.close();
                        }
                        return r2;
                    }
                    sQLiteDatabaseZzad.beginTransaction();
                    RawQuery = sQLiteDatabaseZzad.rawQuery("select count(1) from messages", null);
                    if (RawQuery != 0) {
                        try {
                            if (RawQuery.moveToFirst()) {
                                j = RawQuery.getLong(r2);
                            } else {
                                j = 0;
                            }
                        } catch (SQLiteDatabaseLockedException unused) {
                            r8 = RawQuery;
                            SystemClock.sleep(i3);
                            i3 += 20;
                            if (r8 != 0) {
                                r8.close();
                            }
                            if (sQLiteDatabaseZzad != null) {
                                sQLiteDatabaseZzad.close();
                            }
                            i2++;
                            r2 = 0;
                        } catch (SQLiteFullException e) {
                            e = e;
                            r7 = RawQuery;
                            try {
                                zzj().zzg().zza("Error writing entry; local database full", e);
                                this.zzb = true;
                                if (r7 != 0) {
                                    r7.close();
                                }
                                if (sQLiteDatabaseZzad != null) {
                                    sQLiteDatabaseZzad.close();
                                }
                                i2++;
                                r2 = 0;
                            } catch (Throwable th) {
                                th = th;
                                if (r7 != 0) {
                                    r7.close();
                                }
                                if (sQLiteDatabaseZzad != null) {
                                    sQLiteDatabaseZzad.close();
                                }
                                throw th;
                            }
                        } catch (SQLiteException e2) {
                            e = e2;
                            sQLiteDatabase = sQLiteDatabaseZzad;
                            RawQuery = RawQuery;
                            if (sQLiteDatabase != null) {
                                try {
                                    if (sQLiteDatabase.inTransaction()) {
                                        sQLiteDatabase.endTransaction();
                                    }
                                } catch (Throwable th2) {
                                    th = th2;
                                    sQLiteDatabaseZzad = sQLiteDatabase;
                                    r7 = RawQuery;
                                    if (r7 != 0) {
                                        r7.close();
                                    }
                                    if (sQLiteDatabaseZzad != null) {
                                        sQLiteDatabaseZzad.close();
                                    }
                                    throw th;
                                }
                            }
                            zzj().zzg().zza("Error writing entry to local database", e);
                            this.zzb = true;
                            if (RawQuery != 0) {
                                RawQuery.close();
                            }
                            if (sQLiteDatabase != null) {
                                sQLiteDatabase.close();
                            }
                            i2++;
                            r2 = 0;
                        } catch (Throwable th3) {
                            th = th3;
                            r7 = RawQuery;
                            if (r7 != 0) {
                                r7.close();
                            }
                            if (sQLiteDatabaseZzad != null) {
                                sQLiteDatabaseZzad.close();
                            }
                            throw th;
                        }
                    } else {
                        j = 0;
                    }
                    if (j >= 100000) {
                        zzj().zzg().zza("Data loss, local db full");
                        long j2 = 100001 - j;
                        long jDelete = sQLiteDatabaseZzad.delete("messages", "rowid in (select rowid from messages order by rowid asc limit ?)", new String[]{Long.toString(j2)});
                        if (jDelete != j2) {
                            zzj().zzg().zza("Different delete count than expected in local db. expected, received, difference", Long.valueOf(j2), Long.valueOf(jDelete), Long.valueOf(j2 - jDelete));
                        }
                    }
                    sQLiteDatabaseZzad.insertOrThrow("messages", null, contentValues);
                    sQLiteDatabaseZzad.setTransactionSuccessful();
                    sQLiteDatabaseZzad.endTransaction();
                    if (RawQuery != 0) {
                        RawQuery.close();
                    }
                    if (sQLiteDatabaseZzad == null) {
                        return true;
                    }
                    sQLiteDatabaseZzad.close();
                    return true;
                } catch (SQLiteDatabaseLockedException unused2) {
                } catch (SQLiteFullException e3) {
                    e = e3;
                } catch (SQLiteException e4) {
                    e = e4;
                    RawQuery = 0;
                }
            } catch (SQLiteDatabaseLockedException unused3) {
                sQLiteDatabaseZzad = null;
            } catch (SQLiteFullException e5) {
                e = e5;
                sQLiteDatabaseZzad = null;
            } catch (SQLiteException e6) {
                e = e6;
                RawQuery = 0;
            } catch (Throwable th4) {
                th = th4;
                sQLiteDatabaseZzad = null;
                if (r7 != 0) {
                    r7.close();
                }
                if (sQLiteDatabaseZzad != null) {
                    sQLiteDatabaseZzad.close();
                }
                throw th;
            }
        }
        zzj().zzp().zza("Failed to write entry to local database");
        return false;
    }

    public final boolean zza(zzbg zzbgVar) {
        Parcel parcelObtain = Parcel.obtain();
        zzbgVar.writeToParcel(parcelObtain, 0);
        byte[] bArrMarshall = parcelObtain.marshall();
        parcelObtain.recycle();
        if (bArrMarshall.length > 131072) {
            zzj().zzm().zza("Event is too long for local database. Sending event directly to service");
            return false;
        }
        return zza(0, bArrMarshall);
    }

    public final boolean zza(zznc zzncVar) {
        Parcel parcelObtain = Parcel.obtain();
        zzncVar.writeToParcel(parcelObtain, 0);
        byte[] bArrMarshall = parcelObtain.marshall();
        parcelObtain.recycle();
        if (bArrMarshall.length > 131072) {
            zzj().zzm().zza("User property too long for local database. Sending directly to service");
            return false;
        }
        return zza(1, bArrMarshall);
    }
}
