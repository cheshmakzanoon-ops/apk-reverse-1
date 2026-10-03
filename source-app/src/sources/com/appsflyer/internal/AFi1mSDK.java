package com.appsflyer.internal;

import android.content.ContentProviderClient;
import android.content.Context;
import android.content.pm.PackageItemInfo;
import android.content.pm.ProviderInfo;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.os.DeadObjectException;
import android.os.RemoteException;
import com.appsflyer.AFLogger;

public final class AFi1mSDK extends AFi1nSDK {
    final ProviderInfo AFKeystoreWrapper;
    private final AFd1nSDK valueOf;

    public AFi1mSDK(ProviderInfo providerInfo, Runnable runnable, AFd1nSDK aFd1nSDK) {
        super("af_referrer", providerInfo.authority, runnable);
        this.valueOf = aFd1nSDK;
        this.AFKeystoreWrapper = providerInfo;
    }

    @Override
    public final void values(final Context context) {
        this.valueOf.values().execute(new Runnable() {
            @Override
            public final void run() {
                Cursor cursorQuery;
                AFi1mSDK aFi1mSDK = AFi1mSDK.this;
                aFi1mSDK.f408d = System.currentTimeMillis();
                aFi1mSDK.unregisterClient = AFi1nSDK.AFa1uSDK.STARTED;
                aFi1mSDK.addObserver(new AFi1nSDK.C08753());
                StringBuilder sb = new StringBuilder("content://");
                sb.append(AFi1mSDK.this.AFKeystoreWrapper.authority);
                sb.append("/transaction_id");
                Uri uri = Uri.parse(sb.toString());
                ContentProviderClient contentProviderClientAFInAppEventType = AFi1mSDK.AFInAppEventType(context, uri);
                if (contentProviderClientAFInAppEventType != null) {
                    try {
                        try {
                            try {
                                StringBuilder sb2 = new StringBuilder("app_id=");
                                sb2.append(context.getPackageName());
                                cursorQuery = contentProviderClientAFInAppEventType.query(uri, null, sb2.toString(), null, null);
                                if (Build.VERSION.SDK_INT >= 24) {
                                    contentProviderClientAFInAppEventType.release();
                                } else {
                                    contentProviderClientAFInAppEventType.release();
                                }
                            } catch (DeadObjectException e) {
                                AFLogger.INSTANCE.m799e(AFg1hSDK.PREINSTALL, "Failed to acquire unstable content providerClient", e, false);
                                if (Build.VERSION.SDK_INT >= 24) {
                                    contentProviderClientAFInAppEventType.release();
                                } else {
                                    contentProviderClientAFInAppEventType.release();
                                }
                                cursorQuery = null;
                            }
                        } catch (RemoteException e2) {
                            AFLogger.INSTANCE.m799e(AFg1hSDK.PREINSTALL, "Failed to query unstable content providerClient", e2, false);
                            if (Build.VERSION.SDK_INT >= 24) {
                                contentProviderClientAFInAppEventType.release();
                            } else {
                                contentProviderClientAFInAppEventType.release();
                            }
                            cursorQuery = null;
                        } catch (Throwable th) {
                            AFLogger.INSTANCE.m799e(AFg1hSDK.PREINSTALL, "Error to get data from providerClient ", th, false);
                            if (Build.VERSION.SDK_INT >= 24) {
                                contentProviderClientAFInAppEventType.release();
                            } else {
                                contentProviderClientAFInAppEventType.release();
                            }
                            cursorQuery = null;
                        }
                    } catch (Throwable th2) {
                        if (Build.VERSION.SDK_INT >= 24) {
                            contentProviderClientAFInAppEventType.release();
                        } else {
                            contentProviderClientAFInAppEventType.release();
                        }
                        throw th2;
                    }
                } else {
                    cursorQuery = null;
                }
                if (cursorQuery != null) {
                    int columnIndex = cursorQuery.getColumnIndex("transaction_id");
                    if (columnIndex == -1) {
                        AFLogger.INSTANCE.m804w(AFg1hSDK.PREINSTALL, "Wrong column name");
                        AFi1mSDK.this.values.put("response", "FEATURE_NOT_SUPPORTED");
                    } else {
                        AFi1mSDK.this.values.put("response", "OK");
                        if (cursorQuery.moveToFirst()) {
                            String string = cursorQuery.getString(columnIndex);
                            cursorQuery.close();
                            if (string != null && !string.isEmpty()) {
                                AFi1mSDK.this.values.put("referrer", string);
                            }
                        }
                    }
                    cursorQuery.close();
                } else {
                    AFLogger.INSTANCE.m804w(AFg1hSDK.PREINSTALL, "ContentProvider query failed, got null Cursor");
                    AFi1mSDK.this.values.put("response", "SERVICE_UNAVAILABLE");
                }
                AFi1mSDK.this.values.put("api_ver", Long.valueOf(AFb1qSDK.AFInAppEventParameterName(context, ((PackageItemInfo) AFi1mSDK.this.AFKeystoreWrapper).packageName)));
                AFi1mSDK.this.values.put("api_ver_name", AFb1qSDK.AFKeystoreWrapper(context, ((PackageItemInfo) AFi1mSDK.this.AFKeystoreWrapper).packageName));
                AFi1mSDK.this.AFInAppEventType();
            }
        });
    }

    public static ContentProviderClient AFInAppEventType(Context context, Uri uri) {
        try {
            return context.getContentResolver().acquireUnstableContentProviderClient(uri);
        } catch (SecurityException e) {
            AFLogger.INSTANCE.m799e(AFg1hSDK.PREINSTALL, "Failed to acquire unstable content providerClient due to SecurityException", e, false);
            return null;
        } catch (Throwable th) {
            AFLogger.INSTANCE.m799e(AFg1hSDK.PREINSTALL, "Failed to acquire unstable content providerClient due to unexpected throwable", th, false);
            return null;
        }
    }
}
