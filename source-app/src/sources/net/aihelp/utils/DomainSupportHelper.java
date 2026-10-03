package net.aihelp.utils;

import android.text.TextUtils;
import java.util.Locale;
import net.aihelp.common.API;
import net.aihelp.common.Const;
import net.aihelp.config.enums.PublishCountryOrRegion;

public class DomainSupportHelper {
    public static String getAdjustedUrl(String str) {
        if (Const.countryOrRegion == null) {
            return str;
        }
        String strSubstring = API.HOST_URL.substring(API.HOST_URL.indexOf(".") + 1);
        return !str.contains(strSubstring) ? str.replace("aihelp.net", strSubstring) : str;
    }

    public static String getOptimizedDomain(String str) {
        String strReplace = str.replace("https://", "").replace("http://", "");
        if (!strReplace.endsWith("aihelp.net")) {
            return strReplace;
        }
        if (Const.countryOrRegion == null) {
            if (isSpecificCountryOrRegion("CN")) {
                Const.countryOrRegion = PublishCountryOrRegion.CN;
            } else if (isSpecificCountryOrRegion("IN")) {
                Const.countryOrRegion = PublishCountryOrRegion.IN;
            }
        }
        if (Const.countryOrRegion == PublishCountryOrRegion.CN) {
            return strReplace + ".cn";
        }
        if (Const.countryOrRegion != PublishCountryOrRegion.IN) {
            return strReplace;
        }
        return strReplace + ".in";
    }

    private static boolean isSpecificCountryOrRegion(String str) {
        if (TextUtils.isEmpty(str)) {
            return false;
        }
        return str.equalsIgnoreCase(Locale.getDefault().getCountry()) || str.equalsIgnoreCase(DeviceInfoUtil.getInstance().getSimCountryIso());
    }
}
