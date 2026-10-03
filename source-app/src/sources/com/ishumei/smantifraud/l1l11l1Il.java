package com.ishumei.smantifraud;

import android.content.Context;
import android.database.Cursor;
import android.net.Uri;

public class l1l11l1Il extends l1l11lI11l {
    public final Context l111l11111lIl;

    public l1l11l1Il(Context context) {
        this.l111l11111lIl = context;
    }

    public static boolean l1111l111111Il(Context context) {
        try {
            Cursor cursorQuery = context.getContentResolver().query(Uri.parse("content://com.meizu.flyme.openidsdk/"), null, null, new String[]{l111l1111llIl.l11l111l1lll}, null);
            if (cursorQuery == null) {
                return false;
            }
            cursorQuery.close();
            return true;
        } catch (Throwable unused) {
            return false;
        }
    }

    @Override
    public String l1111l111111Il() {
        try {
            Cursor cursorQuery = this.l111l11111lIl.getContentResolver().query(Uri.parse("content://com.meizu.flyme.openidsdk/"), null, null, new String[]{l111l1111llIl.l11l111l1lll}, null);
            if (cursorQuery == null) {
                return "";
            }
            cursorQuery.moveToFirst();
            int columnIndex = cursorQuery.getColumnIndex("value");
            String string = columnIndex >= 0 ? cursorQuery.getString(columnIndex) : "";
            cursorQuery.close();
            return string;
        } catch (Throwable unused) {
            return "";
        }
    }
}
