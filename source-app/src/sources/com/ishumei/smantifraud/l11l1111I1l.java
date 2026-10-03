package com.ishumei.smantifraud;

import android.content.Context;
import android.content.SharedPreferences;
import android.text.TextUtils;

public abstract class l11l1111I1l extends l11l1111I11l {
    public final SharedPreferences l111l11111I1l(String str) {
        try {
            Context context = l11l11l111Il.l1111l111111Il;
            if (context == null) {
                return null;
            }
            return context.getSharedPreferences(str, 0);
        } catch (Throwable unused) {
            return null;
        }
    }

    public abstract String l111l11111I1l();

    public abstract String l111l11111Il();

    @Override
    public String l111l11111lIl() {
        SharedPreferences sharedPreferencesL111l11111I1l;
        try {
            String strL111l11111I1l = l111l11111I1l();
            String strL111l11111Il = l111l11111Il();
            if (TextUtils.isEmpty(strL111l11111I1l) || TextUtils.isEmpty(strL111l11111Il) || (sharedPreferencesL111l11111I1l = l111l11111I1l(strL111l11111I1l)) == null) {
                return null;
            }
            return sharedPreferencesL111l11111I1l.getString(strL111l11111Il, "");
        } catch (Throwable unused) {
            return "";
        }
    }

    @Override
    public void l111l11111lIl(String str) {
        SharedPreferences sharedPreferencesL111l11111I1l;
        try {
            String strL111l11111I1l = l111l11111I1l();
            String strL111l11111Il = l111l11111Il();
            if (TextUtils.isEmpty(strL111l11111I1l) || TextUtils.isEmpty(strL111l11111Il) || (sharedPreferencesL111l11111I1l = l111l11111I1l(strL111l11111I1l)) == null) {
                return;
            }
            SharedPreferences.Editor editorEdit = sharedPreferencesL111l11111I1l.edit();
            editorEdit.putString(strL111l11111Il, str);
            editorEdit.commit();
        } catch (Throwable unused) {
        }
    }
}
