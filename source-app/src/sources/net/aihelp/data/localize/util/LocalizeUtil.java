package net.aihelp.data.localize.util;

import android.text.TextUtils;
import java.io.File;
import net.aihelp.common.API;
import net.aihelp.common.Const;
import net.aihelp.common.IntentValues;
import net.aihelp.config.AIHelpContext;
import net.aihelp.data.localize.LocalizeHelper;
import net.aihelp.utils.TLog;

public class LocalizeUtil {
    public static boolean isFallbackUrl(int i, String str) {
        return i == 1001 && str.endsWith(String.format("%s-from-api.json", Const.CORRECT_LANGUAGE));
    }

    public static String getFileLocation(int i, String str) {
        String str2;
        File filesDir = AIHelpContext.getInstance().getContext().getFilesDir();
        if (filesDir == null) {
            str2 = "";
        } else {
            str2 = filesDir.getAbsolutePath() + "/AIHelp" + getFolderName(i) + Const.CORRECT_LANGUAGE;
            File file = new File(str2);
            if (!file.exists() && file.mkdirs()) {
                return file.getAbsolutePath() + File.separator + str;
            }
        }
        return str2 + File.separator + str;
    }

    public static String getFileLocation(int i) {
        return getFileLocation(i, getFileName(i));
    }

    public static String getUrl(int i) {
        switch (i) {
            case 1005:
                return API.LOCALE_FILE_URL;
            case 1006:
                return API.CONFIG_STYLE_SHEET_URL;
            case 1007:
                return API.CONFIG_BUSINESS_LOGIC_URL;
            case IntentValues.PAGE_HOPPING_CONVERSATION:
            default:
                return API.CDN_URL + getFolderName(i) + Const.APP_ID + File.separator + getFileName(i);
            case 1009:
                return API.CONFIG_FAQ_HOT_TOPIC_URL;
            case LocalizeHelper.FLAG_PROCESS:
                return API.CONFIG_PROCESS_URL;
            case LocalizeHelper.FLAG_TEXT:
                return API.CONFIG_TEXT_URL;
            case LocalizeHelper.FLAG_UPLOAD_LIMIT:
                return API.CONFIG_UPLOAD_LIMIT_URL;
        }
    }

    public static boolean isAlreadyLocalized(int i) {
        File[] fileArrListFiles;
        try {
            File file = new File(getFileLocation(i));
            if (file.exists()) {
                return true;
            }
            File parentFile = file.getParentFile();
            if (parentFile != null && (fileArrListFiles = parentFile.listFiles()) != null && fileArrListFiles.length > 0) {
                int length = fileArrListFiles.length;
                for (int i2 = 0; i2 < length && !fileArrListFiles[i2].delete(); i2++) {
                }
                return false;
            }
        } catch (Exception unused) {
            TLog.m138d("LocalizeHelper check localize status failed.");
        }
        return false;
    }

    public static String getFolderName(int i) {
        switch (i) {
            case 1001:
                return "/FAQ/";
            case 1002:
            case 1003:
            case 1004:
            case IntentValues.PAGE_HOPPING_CONVERSATION:
            default:
                return "";
            case 1005:
                return "/locale/";
            case 1006:
                return "/stylesheet/";
            case 1007:
                return "/toggle/";
            case 1009:
                return "/hotTopic/";
            case LocalizeHelper.FLAG_PROCESS:
                return "/process/";
            case LocalizeHelper.FLAG_TEXT:
                return "/text/";
            case LocalizeHelper.FLAG_UPLOAD_LIMIT:
                return "/upload/";
        }
    }

    public static String getFileName(int i) {
        switch (i) {
            case 1001:
                return getLocalizeFileName(Const.FAQ_FILE);
            case 1002:
            case 1003:
            case 1004:
            case IntentValues.PAGE_HOPPING_CONVERSATION:
            default:
                return "";
            case 1005:
                return getLocalizeFileName(API.LOCALE_FILE_URL);
            case 1006:
                return getLocalizeFileName(API.CONFIG_STYLE_SHEET_URL);
            case 1007:
                return getLocalizeFileName(API.CONFIG_BUSINESS_LOGIC_URL);
            case 1009:
                return getLocalizeFileName(API.CONFIG_FAQ_HOT_TOPIC_URL);
            case LocalizeHelper.FLAG_PROCESS:
                return getLocalizeFileName(API.CONFIG_PROCESS_URL);
            case LocalizeHelper.FLAG_TEXT:
                return getLocalizeFileName(API.CONFIG_TEXT_URL);
            case LocalizeHelper.FLAG_UPLOAD_LIMIT:
                return getLocalizeFileName(API.CONFIG_UPLOAD_LIMIT_URL);
        }
    }

    private static String getLocalizeFileName(String str) {
        if (!TextUtils.isEmpty(str)) {
            String[] strArrSplit = str.split("/");
            if (strArrSplit.length > 0) {
                return strArrSplit[strArrSplit.length - 1];
            }
        }
        return String.format("%s-from-api.json", Const.CORRECT_LANGUAGE);
    }
}
