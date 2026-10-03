package net.aihelp.utils;

import android.content.Context;
import android.text.TextUtils;
import java.util.regex.Pattern;
import net.aihelp.exception.AIHelpInitException;

public class SchemaUtil {
    private static boolean validatePlatformId(String str) {
        return !TextUtils.isEmpty(str);
    }

    private static boolean validateDomainName(String str) {
        if (TextUtils.isEmpty(str)) {
            return false;
        }
        return Pattern.matches("^.+\\.(aihelp|aihelpcn).(net|online)$", str);
    }

    private static boolean validateApiKey(String str) {
        return !TextUtils.isEmpty(str);
    }

    public static void validateInitializeCredentials(Context context, String str, String str2, String str3) throws IllegalArgumentException {
        if (context == null) {
            throw new AIHelpInitException("The application used in AIHelpSupport#init can't be null!");
        }
        if (!validateApiKey(str)) {
            throw new AIHelpInitException("The appKey used in AIHelpSupport#init should not be empty!");
        }
        if (!validateDomainName(str2)) {
            throw new AIHelpInitException("The domain used in AIHelpSupport#init should be exactly same as AIHelp Dashboard configuration.");
        }
        if (!validatePlatformId(str3)) {
            throw new AIHelpInitException("The appId used in AIHelpSupport#init should not be empty!");
        }
    }
}
