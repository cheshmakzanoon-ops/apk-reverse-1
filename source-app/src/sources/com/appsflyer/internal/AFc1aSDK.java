package com.appsflyer.internal;

import com.appsflyer.AFLogger;
import com.caverock.androidsvg.SVGParser;
import java.util.ArrayList;
import java.util.Locale;
import java.util.regex.Pattern;

public final class AFc1aSDK {
    public final String[] AFKeystoreWrapper;

    public AFc1aSDK(String... strArr) {
        if (strArr == null || strArr.length == 0) {
            this.AFKeystoreWrapper = null;
            return;
        }
        Pattern patternCompile = Pattern.compile("[\\w]{1,45}");
        ArrayList arrayList = new ArrayList();
        for (String str : strArr) {
            if (str != null && patternCompile.matcher(str).matches()) {
                arrayList.add(str.toLowerCase(Locale.getDefault()));
            } else {
                AFLogger.afWarnLog("Invalid partner name: ".concat(String.valueOf(str)));
            }
        }
        if (arrayList.contains(SVGParser.XML_STYLESHEET_ATTR_MEDIA_ALL)) {
            this.AFKeystoreWrapper = new String[]{SVGParser.XML_STYLESHEET_ATTR_MEDIA_ALL};
        } else if (!arrayList.isEmpty()) {
            this.AFKeystoreWrapper = (String[]) arrayList.toArray(new String[0]);
        } else {
            this.AFKeystoreWrapper = null;
        }
    }
}
