package com.appsflyer.internal;

import android.content.ContentResolver;
import android.content.Context;
import android.content.pm.PackageItemInfo;
import android.database.Cursor;
import android.net.Uri;
import com.appsflyer.AFLogger;
import java.util.HashMap;
import java.util.Map;

public final class AFi1sSDK extends AFi1wSDK {
    private final AFd1nSDK AFKeystoreWrapper;

    public AFi1sSDK(Runnable runnable, AFd1nSDK aFd1nSDK) {
        super("store", "huawei", runnable);
        this.AFKeystoreWrapper = aFd1nSDK;
    }

    @Override
    public final void values(Context context) {
        values(this.AFKeystoreWrapper.AFKeystoreWrapper(), new AFd1zSDK<Map<String, Object>>(context, this.AFKeystoreWrapper, "com.huawei.appmarket.commondata", "FFE391E0EA186D0734ED601E4E70E3224B7309D48E2075BAC46D8C667EAE7212", "3BAF59A2E5331C30675FAB35FF5FFF0D116142D3D4664F1C3CB804068B40614F") {
            @Override
            public Map<String, Object> AFInAppEventType() {
                String str = ((PackageItemInfo) this.AFKeystoreWrapper.getPackageManager().resolveContentProvider(this.valueOf, 128)).packageName;
                AFi1sSDK.this.values.put("api_ver", Long.valueOf(AFb1qSDK.AFInAppEventParameterName(this.AFKeystoreWrapper, str)));
                AFi1sSDK.this.values.put("api_ver_name", AFb1qSDK.AFKeystoreWrapper(this.AFKeystoreWrapper, str));
                Cursor cursorQuery = null;
                try {
                    try {
                        ContentResolver contentResolver = this.AFKeystoreWrapper.getContentResolver();
                        StringBuilder sb = new StringBuilder("content://");
                        sb.append(this.valueOf);
                        sb.append("/item/5");
                        cursorQuery = contentResolver.query(Uri.parse(sb.toString()), null, null, new String[]{this.AFKeystoreWrapper.getPackageName()}, null);
                        if (cursorQuery != null) {
                            if (!cursorQuery.moveToFirst()) {
                                AFi1sSDK.this.values.put("response", "FEATURE_NOT_SUPPORTED");
                            } else {
                                AFi1sSDK.this.values.put("response", "OK");
                                AFi1sSDK.this.values.put("referrer", cursorQuery.getString(0));
                                AFi1sSDK.this.values.put("click_ts", Long.valueOf(cursorQuery.getLong(1)));
                                AFi1sSDK.this.values.put("install_end_ts", Long.valueOf(cursorQuery.getLong(2)));
                                if (cursorQuery.getColumnCount() > 3) {
                                    AFi1sSDK.this.values.put("install_begin_ts", Long.valueOf(cursorQuery.getLong(3)));
                                    HashMap map = new HashMap();
                                    String string = cursorQuery.getString(4);
                                    if (string != null) {
                                        map.put("track_id", string);
                                    }
                                    map.put("referrer_ex", cursorQuery.getString(5));
                                    AFi1sSDK.this.values.put("huawei_custom", map);
                                }
                            }
                        } else {
                            AFi1sSDK.this.values.put("response", "SERVICE_UNAVAILABLE");
                        }
                        if (cursorQuery != null) {
                            cursorQuery.close();
                        }
                    } catch (Exception e) {
                        AFi1sSDK.this.values.put("response", "FEATURE_NOT_SUPPORTED");
                        AFLogger.afErrorLog(e.getMessage(), e, false, true);
                        if (0 != 0) {
                            cursorQuery.close();
                        }
                    }
                    AFi1sSDK.this.AFInAppEventType();
                    return AFi1sSDK.this.values;
                } catch (Throwable th) {
                    if (0 != 0) {
                        cursorQuery.close();
                    }
                    throw th;
                }
            }
        });
    }
}
