package cn.thinkingdata.android;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteCursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.database.sqlite.SQLiteOpenHelper;
import android.text.TextUtils;
import cn.thinkingdata.android.encrypt.C0726c;
import cn.thinkingdata.android.encrypt.C0728e;
import cn.thinkingdata.android.utils.TDLog;
import java.io.File;
import java.util.HashMap;
import java.util.Map;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class C0721c {

    private static final String f170b = "CREATE TABLE " + c.EVENTS.m498a() + " (_id INTEGER PRIMARY KEY AUTOINCREMENT, clickdata TEXT NOT NULL, creattime INTEGER NOT NULL, token TEXT NOT NULL DEFAULT '')";

    private static final String f171c = "CREATE INDEX IF NOT EXISTS time_idx ON " + c.EVENTS.m498a() + " (creattime);";

    private static final Map<Context, C0721c> f172d = new HashMap();

    private final a f173a;

    private static class a extends SQLiteOpenHelper {

        private final File f174a;

        private final int f175b;

        public a(Context context, String str) {
            super(context, str, (SQLiteDatabase.CursorFactory) null, 1);
            this.f174a = context.getDatabasePath(str);
            this.f175b = C0735l.m656a(context).m659c();
        }

        boolean m494a() {
            return !this.f174a.exists() || m495b() < this.f175b;
        }

        int m495b() {
            int i = 0;
            Cursor cursorRawQuery = null;
            try {
                try {
                    cursorRawQuery = getReadableDatabase().rawQuery("SELECT count(*) FROM " + c.EVENTS.m498a(), null);
                    i = cursorRawQuery.moveToNext() ? cursorRawQuery.getInt(cursorRawQuery.getColumnIndex("count(*)")) : 0;
                } catch (Exception e) {
                    e.printStackTrace();
                }
                return i;
            } finally {
                if (cursorRawQuery != null) {
                    cursorRawQuery.close();
                }
            }
        }

        void m496c() {
            close();
            this.f174a.delete();
        }

        @Override
        public void onCreate(SQLiteDatabase sQLiteDatabase) {
            TDLog.m679d("ThinkingAnalytics.DatabaseAdapter", "Creating a new ThinkingData events database");
            sQLiteDatabase.execSQL(C0721c.f170b);
            sQLiteDatabase.execSQL(C0721c.f171c);
        }

        @Override
        public void onUpgrade(SQLiteDatabase sQLiteDatabase, int i, int i2) {
            TDLog.m679d("ThinkingAnalytics.DatabaseAdapter", "Upgrading ThinkingData events database");
            sQLiteDatabase.execSQL("DROP TABLE IF EXISTS " + c.EVENTS.m498a());
            sQLiteDatabase.execSQL(C0721c.f170b);
            sQLiteDatabase.execSQL(C0721c.f171c);
        }
    }

    private class b extends SQLiteOpenHelper {
        b(C0721c c0721c, Context context, String str) {
            super(context, str, (SQLiteDatabase.CursorFactory) null, 1);
        }

        JSONArray m497a() {
            JSONArray jSONArray = new JSONArray();
            Cursor cursorRawQuery = null;
            try {
                cursorRawQuery = getReadableDatabase().rawQuery("SELECT * FROM " + c.EVENTS + " ORDER BY creattime", null);
                while (cursorRawQuery.moveToNext()) {
                    JSONObject jSONObject = new JSONObject();
                    jSONObject.put("creattime", cursorRawQuery.getString(cursorRawQuery.getColumnIndex("creattime")));
                    jSONObject.put("clickdata", cursorRawQuery.getString(cursorRawQuery.getColumnIndex("clickdata")));
                    jSONArray.put(jSONObject);
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                close();
                if (cursorRawQuery != null) {
                    cursorRawQuery.close();
                }
            }
            return jSONArray;
        }

        @Override
        public void onCreate(SQLiteDatabase sQLiteDatabase) {
        }

        @Override
        public void onUpgrade(SQLiteDatabase sQLiteDatabase, int i, int i2) {
        }
    }

    public enum c {
        EVENTS("events");


        private final String f178a;

        c(String str) {
            this.f178a = str;
        }

        public String m498a() {
            return this.f178a;
        }
    }

    C0721c(Context context) {
        this(context, "thinkingdata");
    }

    C0721c(Context context, String str) {
        this.f173a = new a(context, str);
        try {
            File databasePath = context.getDatabasePath(context.getPackageName());
            if (databasePath.exists()) {
                JSONArray jSONArrayM497a = new b(this, context, context.getPackageName()).m497a();
                for (int i = 0; i < jSONArrayM497a.length(); i++) {
                    try {
                        JSONObject jSONObject = jSONArrayM497a.getJSONObject(i);
                        ContentValues contentValues = new ContentValues();
                        contentValues.put("clickdata", jSONObject.getString("clickdata"));
                        contentValues.put("creattime", jSONObject.getString("creattime"));
                        TDLog.m679d("ThinkingAnalytics.DatabaseAdapter", contentValues.toString());
                        this.f173a.getWritableDatabase().insert(c.EVENTS.m498a(), null, contentValues);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                databasePath.delete();
            }
        } catch (Exception e2) {
            e2.printStackTrace();
        }
    }

    static boolean m485a(Context context) {
        return (context.getDatabasePath("thinkingdata").exists() || context.getDatabasePath(context.getPackageName()).exists()) ? false : true;
    }

    static C0721c m486b(Context context) {
        C0721c c0721c;
        Map<Context, C0721c> map = f172d;
        synchronized (map) {
            Context applicationContext = context.getApplicationContext();
            if (map.containsKey(applicationContext)) {
                c0721c = map.get(applicationContext);
            } else {
                c0721c = new C0721c(applicationContext);
                map.put(applicationContext, c0721c);
            }
        }
        return c0721c;
    }

    private boolean m488c() {
        return this.f173a.m494a();
    }

    public int m489a(String str, c cVar, String str2) {
        int i;
        String strM498a = cVar.m498a();
        Cursor cursorRawQuery = null;
        try {
            SQLiteDatabase writableDatabase = this.f173a.getWritableDatabase();
            StringBuilder sb = new StringBuilder("_id <= ");
            sb.append(str);
            if (str2 != null) {
                sb.append(" AND token = '");
                sb.append(str2);
                sb.append("'");
            }
            writableDatabase.delete(strM498a, sb.toString(), null);
            StringBuilder sb2 = new StringBuilder("SELECT COUNT(*) FROM " + strM498a);
            if (str2 != null) {
                sb2.append(" WHERE token='");
                sb2.append(str2);
                sb2.append("'");
            }
            cursorRawQuery = writableDatabase.rawQuery(sb2.toString(), null);
            cursorRawQuery.moveToFirst();
            i = cursorRawQuery.getInt(0);
        } catch (SQLiteException e) {
            TDLog.m681e("ThinkingAnalytics.DatabaseAdapter", "could not clean data from " + strM498a, e);
            if (cursorRawQuery != null) {
                cursorRawQuery.close();
            }
            this.f173a.m496c();
            i = -1;
        } finally {
            if (cursorRawQuery != null) {
                cursorRawQuery.close();
            }
        }
        return i;
    }

    public int m490a(JSONObject jSONObject, c cVar, String str) throws Throwable {
        int i;
        Cursor cursorRawQuery = null;
        if (!m488c()) {
            TDLog.m679d("ThinkingAnalytics.DatabaseAdapter", "The data has reached the limit, oldest data will be deleted");
            String[] strArrM493a = m493a(cVar, (String) null, 100);
            if (strArrM493a == null || m489a(strArrM493a[0], c.EVENTS, (String) null) <= 0) {
                return -2;
            }
        }
        String strM498a = cVar.m498a();
        try {
            SQLiteDatabase writableDatabase = this.f173a.getWritableDatabase();
            ContentValues contentValues = new ContentValues();
            if (C0728e.m519a(str) != null) {
                jSONObject = C0728e.m519a(str).m524a(jSONObject);
            }
            contentValues.put("clickdata", jSONObject.toString() + "#td#" + jSONObject.toString().hashCode());
            contentValues.put("creattime", Long.valueOf(System.currentTimeMillis()));
            contentValues.put("token", str);
            writableDatabase.insert(strM498a, null, contentValues);
            cursorRawQuery = writableDatabase.rawQuery("SELECT COUNT(*) FROM " + strM498a + " WHERE token='" + str + "'", null);
            cursorRawQuery.moveToFirst();
            i = cursorRawQuery.getInt(0);
        } catch (SQLiteException e) {
            TDLog.m681e("ThinkingAnalytics.DatabaseAdapter", "could not add data to table " + strM498a + ". Re-initializing database.", e);
            if (cursorRawQuery != null) {
                cursorRawQuery.close();
            }
            this.f173a.m496c();
            i = -1;
        } finally {
            if (cursorRawQuery != null) {
                cursorRawQuery.close();
            }
        }
        return i;
    }

    public void m491a(long j, c cVar) {
        String strM498a = cVar.m498a();
        try {
            this.f173a.getWritableDatabase().delete(strM498a, "creattime <= " + j, null);
        } catch (SQLiteException e) {
            TDLog.m681e("ThinkingAnalytics.DatabaseAdapter", "Could not clean timed-out records. Re-initializing database.", e);
            this.f173a.m496c();
        }
    }

    public void m492a(c cVar, String str) {
        String strM498a = cVar.m498a();
        try {
            this.f173a.getWritableDatabase().delete(strM498a, "token = '" + str + "'", null);
        } catch (SQLiteException e) {
            TDLog.m681e("ThinkingAnalytics.DatabaseAdapter", "Could not clean records. Re-initializing database.", e);
            this.f173a.m496c();
        }
    }

    public String[] m493a(c cVar, String str, int i) throws Throwable {
        Cursor cursorRawQuery;
        String string;
        String string2;
        String strM498a = cVar.m498a();
        SQLiteCursor sQLiteCursor = 0;
        try {
            try {
                SQLiteDatabase readableDatabase = this.f173a.getReadableDatabase();
                StringBuilder sb = new StringBuilder("SELECT * FROM ");
                sb.append(strM498a);
                if (str != null) {
                    sb.append(" WHERE token = '");
                    sb.append(str);
                    sb.append("'");
                }
                sb.append(" ORDER BY creattime ASC LIMIT ");
                sb.append(i);
                JSONArray jSONArray = new JSONArray();
                cursorRawQuery = readableDatabase.rawQuery(sb.toString(), null);
                if (cursorRawQuery != null) {
                    string2 = null;
                    while (cursorRawQuery.moveToNext()) {
                        try {
                            if (cursorRawQuery.isLast()) {
                                string2 = cursorRawQuery.getString(cursorRawQuery.getColumnIndex("_id"));
                            }
                            try {
                                String string3 = cursorRawQuery.getString(cursorRawQuery.getColumnIndex("clickdata"));
                                if (!TextUtils.isEmpty(string3)) {
                                    int iLastIndexOf = string3.lastIndexOf("#td#");
                                    if (iLastIndexOf > -1) {
                                        String strReplaceFirst = string3.substring(iLastIndexOf).replaceFirst("#td#", "");
                                        string3 = string3.substring(0, iLastIndexOf);
                                        if (!TextUtils.isEmpty(string3) && !TextUtils.isEmpty(strReplaceFirst) && strReplaceFirst.equals(String.valueOf(string3.hashCode()))) {
                                        }
                                    }
                                    JSONObject jSONObject = new JSONObject(string3);
                                    C0728e c0728eM519a = C0728e.m519a(str);
                                    if (c0728eM519a != null && !C0726c.m517a(jSONObject)) {
                                        jSONObject = c0728eM519a.m524a(jSONObject);
                                    }
                                    jSONArray.put(jSONObject);
                                }
                            } catch (JSONException unused) {
                            }
                        } catch (SQLiteException e) {
                            e = e;
                            TDLog.m681e("ThinkingAnalytics.DatabaseAdapter", "Could not pull records out of database " + strM498a, e);
                            string = null;
                            string2 = null;
                            if (cursorRawQuery != null) {
                                cursorRawQuery.close();
                            }
                        }
                    }
                    string = jSONArray.length() > 0 ? jSONArray.toString() : null;
                } else {
                    string = null;
                    string2 = null;
                }
                if (cursorRawQuery != null) {
                    cursorRawQuery.close();
                }
            } catch (Throwable th) {
                th = th;
                sQLiteCursor = " WHERE token = '";
                if (sQLiteCursor != 0) {
                    sQLiteCursor.close();
                }
                throw th;
            }
        } catch (SQLiteException e2) {
            e = e2;
            cursorRawQuery = null;
        } catch (Throwable th2) {
            th = th2;
            if (sQLiteCursor != 0) {
                sQLiteCursor.close();
            }
            throw th;
        }
        if (string2 == null || string == null) {
            return null;
        }
        return new String[]{string2, string};
    }
}
