package com.ishumei.smantifraud;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Base64;
import android.util.Pair;
import java.io.File;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.UUID;

public class l1l11I11l {
    public static final String l111l11111Il = "seq";
    public static final String l111l1111l1Il = "puuid";
    public static final String l111l1111lI1l = "ks";
    public static final String l111l1111lIl = "e";
    public static final String l111l1111llIl = "bfic";
    public static final String l11l1111I11l = ".smtfb";
    public static l1l11I11l l11l1111I1l = null;
    public static final String l11l1111lIIl = "c";
    public int l1111l111111Il = 0;
    public SharedPreferences l111l11111I1l;
    public SharedPreferences l111l11111lIl;

    public l1l11I11l() {
        Context contextL111l11111lIl = l11l11l111Il.l111l11111lIl();
        if (contextL111l11111lIl != null) {
            try {
                this.l111l11111lIl = contextL111l11111lIl.getSharedPreferences("seq", 0);
            } catch (Throwable unused) {
            }
            try {
                this.l111l11111I1l = contextL111l11111lIl.getSharedPreferences(l1l11I1l11l.l111l1111llIl, 0);
            } catch (Throwable unused2) {
            }
        }
    }

    public static synchronized l1l11I11l l111l11111Il() {
        if (l11l1111I1l == null) {
            l11l1111I1l = new l1l11I11l();
        }
        return l11l1111I1l;
    }

    public int l1111l111111Il(String str) {
        SharedPreferences sharedPreferences = this.l111l11111lIl;
        if (sharedPreferences == null) {
            return 0;
        }
        return sharedPreferences.getInt(str, 0);
    }

    public long l1111l111111Il() {
        try {
            return this.l111l11111lIl.getLong(l111l1111llIl, 0L);
        } catch (Throwable unused) {
            return 0L;
        }
    }

    public void l1111l111111Il(String str, int i) {
        SharedPreferences sharedPreferences = this.l111l11111lIl;
        if (sharedPreferences == null) {
            return;
        }
        try {
            SharedPreferences.Editor editorEdit = sharedPreferences.edit();
            editorEdit.putInt(str, i);
            editorEdit.apply();
        } catch (Throwable unused) {
        }
    }

    public void l1111l111111Il(List<byte[]> list, Pair<String, Integer> pair) {
        SharedPreferences.Editor editorEdit;
        String string;
        try {
            this.l111l11111I1l.edit().putInt(l111l1111lI1l, ((Integer) pair.second).intValue()).apply();
            String str = l111l1111lIl;
            if (list == null || list.isEmpty()) {
                editorEdit = this.l111l11111I1l.edit();
                string = (String) pair.first;
            } else {
                this.l111l11111I1l.edit().putString(l111l1111lIl, "").apply();
                StringBuilder sb = new StringBuilder();
                Iterator<byte[]> it = list.iterator();
                while (it.hasNext()) {
                    sb.append(Base64.encodeToString(it.next(), 2));
                    sb.append(" ");
                }
                editorEdit = this.l111l11111I1l.edit();
                str = "c";
                string = sb.toString();
            }
            editorEdit.putString(str, string).apply();
        } catch (Throwable unused) {
        }
    }

    public boolean l1111l111111Il(long j) {
        try {
            return this.l111l11111lIl.edit().putLong(l111l1111llIl, j).commit();
        } catch (Throwable unused) {
            return false;
        }
    }

    public boolean l1111l111111Il(Context context) {
        try {
            return new File(context.getFilesDir(), l11l1111I11l).exists();
        } catch (Throwable unused) {
            return true;
        }
    }

    public boolean l1111l111111Il(Context context, boolean z) {
        try {
            File file = new File(context.getFilesDir(), l11l1111I11l);
            if (!z && !file.exists() && file.createNewFile()) {
                return file.createNewFile();
            }
            if (z && file.exists() && !file.delete()) {
                return file.delete();
            }
            return true;
        } catch (Throwable unused) {
            return false;
        }
    }

    public synchronized String l111l11111I1l() {
        if (this.l1111l111111Il == 0) {
            String strL111l11111lIl = l111l11111lIl();
            if (!l11l11Il11l.l1111l111111Il(strL111l11111lIl)) {
                try {
                    this.l1111l111111Il = Integer.parseInt(strL111l11111lIl);
                } catch (Throwable unused) {
                }
            }
        }
        this.l1111l111111Il++;
        l111l11111lIl("" + this.l1111l111111Il);
        return "" + this.l1111l111111Il;
    }

    public final String l111l11111lIl() {
        try {
            SharedPreferences sharedPreferences = this.l111l11111lIl;
            if (sharedPreferences == null) {
                return null;
            }
            return sharedPreferences.getString("seq", null);
        } catch (Throwable unused) {
            return null;
        }
    }

    public final void l111l11111lIl(String str) {
        try {
            SharedPreferences sharedPreferences = this.l111l11111lIl;
            if (sharedPreferences == null) {
                return;
            }
            SharedPreferences.Editor editorEdit = sharedPreferences.edit();
            editorEdit.putString("seq", str);
            editorEdit.apply();
        } catch (Throwable unused) {
        }
    }

    public List<byte[]> l111l1111l1Il() {
        try {
            String string = this.l111l11111I1l.getString("c", null);
            if (string == null) {
                return null;
            }
            ArrayList arrayList = new ArrayList();
            for (String str : string.split(" ")) {
                if (!str.isEmpty()) {
                    arrayList.add(Base64.decode(str, 2));
                }
            }
            return arrayList;
        } catch (Throwable unused) {
            return null;
        }
    }

    public int l111l1111lI1l() {
        try {
            return this.l111l11111I1l.getInt(l111l1111lI1l, 0);
        } catch (Throwable unused) {
            return 0;
        }
    }

    public synchronized String l111l1111lIl() {
        try {
            String string = this.l111l11111lIl.getString(l111l1111l1Il, null);
            if (string != null) {
                return string;
            }
            String strReplaceAll = UUID.randomUUID().toString().replaceAll("-", "");
            if (this.l111l11111lIl.edit().putString(l111l1111l1Il, strReplaceAll).commit()) {
                return strReplaceAll;
            }
        } catch (Throwable unused) {
        }
        return null;
    }

    public String l111l1111llIl() {
        try {
            return this.l111l11111I1l.getString(l111l1111lIl, null);
        } catch (Throwable unused) {
            return null;
        }
    }
}
