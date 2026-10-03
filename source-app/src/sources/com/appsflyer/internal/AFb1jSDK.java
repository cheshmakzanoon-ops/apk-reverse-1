package com.appsflyer.internal;

import android.content.ContentResolver;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import com.facebook.internal.AttributionIdentifiers;

final class AFb1jSDK extends AFd1zSDK<String> {
    AFb1jSDK(Context context, AFd1nSDK aFd1nSDK) {
        super(context, aFd1nSDK, AttributionIdentifiers.ATTRIBUTION_ID_CONTENT_PROVIDER, "E3F9E1E0CF99D0E56A055BA65E241B3399F7CEA524326B0CDD6EC1327ED0FDC1");
    }

    @Override
    public String AFInAppEventType() throws Throwable {
        Cursor cursorQuery;
        Throwable th;
        try {
            ContentResolver contentResolver = this.AFKeystoreWrapper.getContentResolver();
            StringBuilder sb = new StringBuilder("content://");
            sb.append(this.valueOf);
            cursorQuery = contentResolver.query(Uri.parse(sb.toString()), new String[]{"aid"}, null, null, null);
            if (cursorQuery != null) {
                try {
                    if (cursorQuery.moveToFirst()) {
                        String string = cursorQuery.getString(cursorQuery.getColumnIndexOrThrow("aid"));
                        if (cursorQuery != null) {
                            cursorQuery.close();
                        }
                        return string;
                    }
                } catch (Throwable th2) {
                    th = th2;
                    if (cursorQuery != null) {
                        cursorQuery.close();
                    }
                    throw th;
                }
            }
            if (cursorQuery != null) {
                cursorQuery.close();
            }
            return null;
        } catch (Throwable th3) {
            cursorQuery = null;
            th = th3;
        }
    }

    public final String AFKeystoreWrapper() {
        this.AFInAppEventParameterName.values().execute(this.AFInAppEventType);
        return (String) super.valueOf();
    }

    @Override
    public final String valueOf() {
        this.AFInAppEventParameterName.values().execute(this.AFInAppEventType);
        return (String) super.valueOf();
    }
}
