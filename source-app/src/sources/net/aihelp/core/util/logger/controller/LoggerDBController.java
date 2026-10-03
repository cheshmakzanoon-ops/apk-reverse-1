package net.aihelp.core.util.logger.controller;

import android.content.Context;
import android.util.Log;
import java.io.File;
import java.io.FileOutputStream;
import net.aihelp.config.AIHelpContext;
import net.aihelp.utils.FileUtil;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class LoggerDBController {
    private static final String TAG = "LoggerDBController";
    private JSONArray jsonArray = new JSONArray();

    public void saveCrashInfoFile(int i, String str, String str2, long j) {
        try {
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("level", getLogLevel(i));
            jSONObject.put("message", str);
            jSONObject.put("stacktrace", str2);
            jSONObject.put("timeStamp", j);
            this.jsonArray.put(jSONObject);
            File file = new File(getCrashFilePath(AIHelpContext.getInstance().getContext()));
            if (file.exists()) {
                file.delete();
            }
            FileOutputStream fileOutputStream = new FileOutputStream(file.getAbsoluteFile(), true);
            fileOutputStream.write(this.jsonArray.toString().getBytes());
            fileOutputStream.flush();
            fileOutputStream.close();
        } catch (Exception e) {
            Log.e(TAG, "an error occured while writing file...", e);
        }
    }

    public static String getCrashFilePath(Context context) {
        String str;
        File filesDir = context.getFilesDir();
        if (filesDir == null) {
            str = "";
        } else {
            str = filesDir.getAbsolutePath() + "/AIHelp/crash";
            File file = new File(str);
            if (!file.exists() && file.mkdirs()) {
                return file.getAbsolutePath() + File.separator + "CrashLog.txt";
            }
        }
        return str + File.separator + "CrashLog.txt";
    }

    public JSONArray getCrashLog() {
        try {
            return new JSONArray(FileUtil.getContentFromFile(getCrashFilePath(AIHelpContext.getInstance().getContext())));
        } catch (JSONException unused) {
            return new JSONArray();
        }
    }

    public void reset() {
        this.jsonArray = new JSONArray();
    }

    private static final class LazyHolder {
        static final LoggerDBController INSTANCE = new LoggerDBController();

        private LazyHolder() {
        }
    }

    public static LoggerDBController getInstance() {
        return LazyHolder.INSTANCE;
    }

    private String getLogLevel(int i) {
        if (i == 1) {
            return "fatal";
        }
        if (i == 2) {
            return "error";
        }
        return "warn";
    }
}
