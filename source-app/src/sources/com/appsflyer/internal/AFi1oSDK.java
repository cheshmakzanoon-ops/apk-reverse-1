package com.appsflyer.internal;

import android.content.ContentResolver;
import android.content.Context;
import android.content.pm.PackageItemInfo;
import android.database.Cursor;
import android.net.Uri;
import com.appsflyer.AFLogger;
import java.util.HashMap;
import java.util.Map;

public final class AFi1oSDK extends AFi1wSDK {
    private final AFd1nSDK AFKeystoreWrapper;

    public AFi1oSDK(Runnable runnable, AFd1nSDK aFd1nSDK) {
        super("store", "samsung", runnable);
        this.AFKeystoreWrapper = aFd1nSDK;
    }

    @Override
    public final void values(Context context) {
        values(this.AFKeystoreWrapper.AFKeystoreWrapper(), new AFd1zSDK<Map<String, Object>>(context, this.AFKeystoreWrapper, "com.sec.android.app.samsungapps.referrer", "FBA3AF4E7757D9016E953FB3EE4671CA2BD9AF725F9A53D52ED4A38EAAA08901") {
            @Override
            public Map<String, Object> AFInAppEventType() {
                String string;
                Cursor cursorQuery = null;
                try {
                    try {
                        ContentResolver contentResolver = this.AFKeystoreWrapper.getContentResolver();
                        StringBuilder sb = new StringBuilder("content://");
                        sb.append(this.valueOf);
                        cursorQuery = contentResolver.query(Uri.parse(sb.toString()), null, null, null, null);
                        if (cursorQuery != null) {
                            if (!cursorQuery.moveToFirst()) {
                                AFi1oSDK.this.values.put("response", "FEATURE_NOT_SUPPORTED");
                            } else {
                                AFi1oSDK.this.values.put("response", "OK");
                                valueOf("referrer", AFi1oSDK.this.values, cursorQuery);
                                AFInAppEventParameterName("click_ts", AFi1oSDK.this.values, cursorQuery);
                                AFInAppEventParameterName("install_begin_ts", AFi1oSDK.this.values, cursorQuery);
                                AFInAppEventParameterName("install_end_ts", AFi1oSDK.this.values, cursorQuery);
                                valueOf("organic_keywords", AFi1oSDK.this.values, cursorQuery);
                                valueOf("attr_type", AFi1oSDK.this.values, cursorQuery);
                                HashMap map = new HashMap();
                                int columnIndex = cursorQuery.getColumnIndex("instant");
                                if (columnIndex != -1 && (string = cursorQuery.getString(columnIndex)) != null) {
                                    map.put("instant", Boolean.valueOf(Boolean.parseBoolean(string)));
                                }
                                AFInAppEventParameterName("click_server_ts", map, cursorQuery);
                                AFInAppEventParameterName("install_begin_server_ts", map, cursorQuery);
                                valueOf("install_version", map, cursorQuery);
                                if (!map.isEmpty()) {
                                    AFi1oSDK.this.values.put("custom", map);
                                }
                            }
                        } else {
                            AFi1oSDK.this.values.put("response", "SERVICE_UNAVAILABLE");
                        }
                        if (cursorQuery != null) {
                            cursorQuery.close();
                        }
                    } catch (Exception e) {
                        AFi1oSDK.this.values.put("response", "FEATURE_NOT_SUPPORTED");
                        AFLogger.afErrorLog(e.getMessage(), e, false, true);
                        if (0 != 0) {
                            cursorQuery.close();
                        }
                    }
                    String str = ((PackageItemInfo) this.AFKeystoreWrapper.getPackageManager().resolveContentProvider(this.valueOf, 128)).packageName;
                    AFi1oSDK.this.values.put("api_ver", Long.valueOf(AFb1qSDK.AFInAppEventParameterName(this.AFKeystoreWrapper, str)));
                    AFi1oSDK.this.values.put("api_ver_name", AFb1qSDK.AFKeystoreWrapper(this.AFKeystoreWrapper, str));
                    AFi1oSDK.this.AFInAppEventType();
                    return AFi1oSDK.this.values;
                } catch (Throwable th) {
                    if (0 != 0) {
                        cursorQuery.close();
                    }
                    throw th;
                }
            }

            private static void AFInAppEventParameterName(String str, Map<String, Object> map, Cursor cursor) {
                int columnIndex = cursor.getColumnIndex(str);
                if (columnIndex == -1) {
                    return;
                }
                long j = cursor.getLong(columnIndex);
                if (j == 0) {
                    return;
                }
                map.put(str, Long.valueOf(j));
            }

            private static void valueOf(String str, Map<String, Object> map, Cursor cursor) {
                String string;
                int columnIndex = cursor.getColumnIndex(str);
                if (columnIndex == -1 || (string = cursor.getString(columnIndex)) == null) {
                    return;
                }
                map.put(str, string);
            }
        });
    }
}
