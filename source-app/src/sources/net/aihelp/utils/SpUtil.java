package net.aihelp.utils;

import android.content.Context;
import android.content.SharedPreferences;
import android.text.TextUtils;
import java.util.HashMap;
import java.util.Map;
import net.aihelp.config.AIHelpContext;

public class SpUtil {
    private static final String FILE_NAME = "aihelp_share_data";
    private static final String FILE_NAME_OF_SDK_VERSION_1 = "com_ab_shared_preferences";
    private static volatile SpUtil INSTANCE = null;
    public static final String KEY_DEVICE_ID_OF_SDK_VERSION_1_x = "suuid";
    public static final String KEY_DEVICE_ID_OF_SDK_VERSION_2_x = "key_device_id";
    private Context context = AIHelpContext.getInstance().getContext().getApplicationContext();

    public void init(Context context) {
        this.context = context;
    }

    private SpUtil() {
    }

    public static SpUtil getInstance() {
        if (INSTANCE == null) {
            synchronized (SpUtil.class) {
                if (INSTANCE == null) {
                    INSTANCE = new SpUtil();
                }
            }
        }
        return INSTANCE;
    }

    public void put(String str, Object obj) {
        if (isBadContext(str)) {
            return;
        }
        SharedPreferences.Editor editorEdit = this.context.getSharedPreferences(FILE_NAME, 0).edit();
        if (obj instanceof String) {
            editorEdit.putString(str, (String) obj);
        } else if (obj instanceof Integer) {
            editorEdit.putInt(str, ((Integer) obj).intValue());
        } else if (obj instanceof Boolean) {
            editorEdit.putBoolean(str, ((Boolean) obj).booleanValue());
        } else if (obj instanceof Float) {
            editorEdit.putFloat(str, ((Float) obj).floatValue());
        } else if (obj instanceof Long) {
            editorEdit.putLong(str, ((Long) obj).longValue());
        } else {
            editorEdit.putString(str, obj.toString());
        }
        editorEdit.apply();
    }

    public long getLong(String str) {
        if (isBadContext(str)) {
            return 0L;
        }
        return this.context.getSharedPreferences(FILE_NAME, 0).getLong(str, 0L);
    }

    public long getLong(String str, long j) {
        if (isBadContext(str)) {
            return 0L;
        }
        return this.context.getSharedPreferences(FILE_NAME, 0).getLong(str, j);
    }

    public float getFloat(String str) {
        if (isBadContext(str)) {
            return 0.0f;
        }
        return this.context.getSharedPreferences(FILE_NAME, 0).getFloat(str, 0.0f);
    }

    public float getFloat(String str, float f) {
        if (isBadContext(str)) {
            return 0.0f;
        }
        return this.context.getSharedPreferences(FILE_NAME, 0).getFloat(str, f);
    }

    public int getInt(String str) {
        if (isBadContext(str)) {
            return 0;
        }
        return this.context.getSharedPreferences(FILE_NAME, 0).getInt(str, 0);
    }

    public int getInt(String str, int i) {
        if (isBadContext(str)) {
            return 0;
        }
        return this.context.getSharedPreferences(FILE_NAME, 0).getInt(str, i);
    }

    public boolean getBoolean(String str) {
        if (isBadContext(str)) {
            return false;
        }
        return this.context.getSharedPreferences(FILE_NAME, 0).getBoolean(str, false);
    }

    public boolean getBoolean(String str, boolean z) {
        if (isBadContext(str)) {
            return false;
        }
        return this.context.getSharedPreferences(FILE_NAME, 0).getBoolean(str, z);
    }

    public String getString(String str, String str2) {
        return isBadContext(str) ? "" : this.context.getSharedPreferences(FILE_NAME, 0).getString(str, str2);
    }

    public String getString(String str) {
        return isBadContext(str) ? "" : this.context.getSharedPreferences(FILE_NAME, 0).getString(str, "");
    }

    public void remove(String str) {
        if (isBadContext(str)) {
            return;
        }
        this.context.getSharedPreferences(FILE_NAME, 0).edit().remove(str).apply();
    }

    public void clear() {
        if (isBadContext(null)) {
            return;
        }
        this.context.getSharedPreferences(FILE_NAME, 0).edit().clear().apply();
    }

    public boolean contains(String str) {
        if (isBadContext(str)) {
            return false;
        }
        return this.context.getSharedPreferences(FILE_NAME, 0).contains(str);
    }

    public Map<String, ?> getAll() {
        return isBadContext(null) ? new HashMap() : this.context.getSharedPreferences(FILE_NAME, 0).getAll();
    }

    public String get1_xDeviceId() {
        return isBadContext(null) ? "" : this.context.getSharedPreferences(FILE_NAME_OF_SDK_VERSION_1, 0).getString(KEY_DEVICE_ID_OF_SDK_VERSION_1_x, "");
    }

    public String get2_xDeviceId() {
        return getString(KEY_DEVICE_ID_OF_SDK_VERSION_2_x);
    }

    private boolean isBadContext(String str) {
        if (TextUtils.isEmpty(str)) {
            return true;
        }
        if (this.context != null || AIHelpContext.getInstance().getContext() == null) {
            return false;
        }
        INSTANCE = new SpUtil();
        return true;
    }
}
