package com.appsflyer.internal;

import android.content.ContentProviderClient;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import com.appsflyer.AFLogger;
import com.facebook.AccessToken;
import com.facebook.FacebookSdk;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import kotlin.NoWhenBranchMatchedException;
import kotlin.Pair;
import kotlin.TuplesKt;
import kotlin.collections.MapsKt;
import kotlin.jvm.internal.Intrinsics;

public final class AFi1qSDK extends AFi1ySDK {
    private final ExecutorService AFKeystoreWrapper;

    private final AFi1rSDK f409e;

    private String f410i;
    private final Runnable registerClient;
    private final AFd1rSDK valueOf;

    public class AFa1vSDK {
        public static final int[] values;

        static {
            int[] iArr = new int[AFi1rSDK.values().length];
            iArr[AFi1rSDK.FACEBOOK.ordinal()] = 1;
            iArr[AFi1rSDK.INSTAGRAM.ordinal()] = 2;
            values = iArr;
        }
    }

    @Override
    public final void values(final Context context) {
        Intrinsics.checkNotNullParameter(context, "");
        if (!valueOf(context)) {
            this.registerClient.run();
        } else {
            this.AFKeystoreWrapper.execute(new Runnable() {
                @Override
                public final void run() {
                    AFi1qSDK.valueOf(this.f$0, context);
                }
            });
        }
    }

    private final boolean valueOf(Context context) {
        String str;
        if (!AFInAppEventParameterName()) {
            AFLogger.afDebugLog("[MetaReferrer]: Referrer collection disallowed by counter.");
            return false;
        }
        String strValues = this.valueOf.values(FacebookSdk.APPLICATION_ID_PROPERTY);
        String str2 = strValues;
        if (str2 == null || str2.length() == 0) {
            AFLogger.afDebugLog("[MetaReferrer]: Facebook app id Manifest metadata is not found.");
            strValues = null;
        }
        if (strValues == null) {
            strValues = this.valueOf.AFInAppEventType("facebook_application_id");
            String str3 = strValues;
            if (str3 == null || str3.length() == 0) {
                AFLogger.afDebugLog("[MetaReferrer]: Facebook app id string resource is not found.");
                strValues = null;
            }
            if (strValues == null) {
                strValues = this.valueOf.values("com.appsflyer.FacebookApplicationId");
                String str4 = strValues;
                if (str4 == null || str4.length() == 0) {
                    AFLogger.afDebugLog("[MetaReferrer]: AF Facebook app id Manifest metadata is not found.");
                    strValues = null;
                }
                str = strValues != null ? strValues : null;
            }
        }
        this.f410i = str;
        if (str == null) {
            AFLogger.afDebugLog("[MetaReferrer]: Referrer collection disallowed by missing Facebook app id.");
            return false;
        }
        if (AFInAppEventType(context)) {
            return true;
        }
        AFLogger.afDebugLog("[MetaReferrer]: Referrer collection disallowed by missing content providers.");
        return false;
    }

    private final boolean AFInAppEventType(Context context) throws NoWhenBranchMatchedException {
        int i = AFa1vSDK.values[this.f409e.ordinal()];
        if (i == 1) {
            return AFInAppEventParameterName(context);
        }
        if (i == 2) {
            return AFKeystoreWrapper(context);
        }
        throw new NoWhenBranchMatchedException();
    }

    private static boolean AFInAppEventParameterName(Context context) {
        return context.getPackageManager().resolveContentProvider("com.facebook.katana.provider.InstallReferrerProvider", 0) != null;
    }

    private static boolean AFKeystoreWrapper(Context context) {
        return context.getPackageManager().resolveContentProvider("com.instagram.contentprovider.InstallReferrerProvider", 0) != null;
    }

    public AFi1qSDK(AFd1rSDK aFd1rSDK, ExecutorService executorService, AFi1rSDK aFi1rSDK, Runnable runnable, Runnable runnable2) throws NoWhenBranchMatchedException {
        String str;
        Intrinsics.checkNotNullParameter(aFd1rSDK, "");
        Intrinsics.checkNotNullParameter(executorService, "");
        Intrinsics.checkNotNullParameter(aFi1rSDK, "");
        Intrinsics.checkNotNullParameter(runnable, "");
        Intrinsics.checkNotNullParameter(runnable2, "");
        int i = AFi1tSDK.AFa1vSDK.valueOf[aFi1rSDK.ordinal()];
        if (i == 1) {
            str = AccessToken.DEFAULT_GRAPH_DOMAIN;
        } else {
            if (i != 2) {
                throw new NoWhenBranchMatchedException();
            }
            str = FacebookSdk.INSTAGRAM;
        }
        super("app", str, aFd1rSDK, runnable);
        this.valueOf = aFd1rSDK;
        this.AFKeystoreWrapper = executorService;
        this.f409e = aFi1rSDK;
        this.registerClient = runnable2;
    }

    public static final void valueOf(AFi1qSDK aFi1qSDK, Context context) {
        ContentProviderClient contentProviderClientAcquireUnstableContentProviderClient;
        Uri uri;
        Uri uri2;
        String string;
        String str;
        Intrinsics.checkNotNullParameter(aFi1qSDK, "");
        Intrinsics.checkNotNullParameter(context, "");
        aFi1qSDK.f408d = System.currentTimeMillis();
        aFi1qSDK.unregisterClient = AFi1nSDK.AFa1uSDK.STARTED;
        aFi1qSDK.addObserver(new AFi1nSDK.C08753());
        String str2 = aFi1qSDK.f410i;
        Intrinsics.checkNotNull(str2);
        Cursor cursor = null;
        cursor = null;
        try {
            int i = AFa1vSDK.values[aFi1qSDK.f409e.ordinal()];
            if (i != 1) {
                if (i != 2) {
                    throw new NoWhenBranchMatchedException();
                }
                if (AFKeystoreWrapper(context)) {
                    AFLogger.afDebugLog("[MetaReferrer]: Found Instagram content provider");
                    uri = Uri.parse("content://com.instagram.contentprovider.InstallReferrerProvider/".concat(String.valueOf(str2)));
                    uri2 = uri;
                } else {
                    AFLogger.afDebugLog("[MetaReferrer]: Instagram content provider not found");
                    uri2 = null;
                }
            } else if (AFInAppEventParameterName(context)) {
                AFLogger.afDebugLog("[MetaReferrer]: Found Facebook content provider");
                uri = Uri.parse("content://com.facebook.katana.provider.InstallReferrerProvider/".concat(String.valueOf(str2)));
                uri2 = uri;
            } else {
                AFLogger.afDebugLog("[MetaReferrer]: Facebook content provider noy found");
                uri2 = null;
            }
            if (uri2 != null) {
                contentProviderClientAcquireUnstableContentProviderClient = context.getContentResolver().acquireUnstableContentProviderClient(uri2);
                try {
                    Cursor cursorQuery = contentProviderClientAcquireUnstableContentProviderClient != null ? contentProviderClientAcquireUnstableContentProviderClient.query(uri2, new String[]{"install_referrer", "is_ct", "actual_timestamp"}, null, null, null) : null;
                    if (cursorQuery != null) {
                        try {
                            if (cursorQuery.moveToFirst()) {
                                int columnIndex = cursorQuery.getColumnIndex("install_referrer");
                                if (columnIndex != -1) {
                                    string = cursorQuery.getString(columnIndex);
                                } else {
                                    StringBuilder sb = new StringBuilder("[MetaReferrer]: No such column, ");
                                    sb.append(aFi1qSDK.f409e);
                                    sb.append(" provider");
                                    AFLogger.afDebugLog(sb.toString());
                                    string = null;
                                }
                                if (string != null) {
                                    StringBuilder sb2 = new StringBuilder("[MetaReferrer]: Collected ");
                                    sb2.append(aFi1qSDK.f409e);
                                    sb2.append(" attribution data.");
                                    AFLogger.afDebugLog(sb2.toString());
                                    Map<String, Object> map = aFi1qSDK.values;
                                    Intrinsics.checkNotNullExpressionValue(map, "");
                                    map.put("response", "OK");
                                    Map<String, Object> map2 = aFi1qSDK.values;
                                    Intrinsics.checkNotNullExpressionValue(map2, "");
                                    map2.put("referrer", string);
                                    int columnIndex2 = cursorQuery.getColumnIndex("actual_timestamp");
                                    Long lValueOf = columnIndex2 != -1 ? Long.valueOf(cursorQuery.getLong(columnIndex2)) : null;
                                    if (lValueOf != null) {
                                        aFi1qSDK.values.put("click_ts", Long.valueOf(lValueOf.longValue()));
                                    }
                                    int columnIndex3 = cursorQuery.getColumnIndex("is_ct");
                                    Integer numValueOf = columnIndex3 != -1 ? Integer.valueOf(cursorQuery.getInt(columnIndex3)) : null;
                                    if (numValueOf != null) {
                                        aFi1qSDK.values.put("meta_custom", MapsKt.mutableMapOf(new Pair[]{TuplesKt.to("is_ct", Integer.valueOf(numValueOf.intValue()))}));
                                    }
                                    int i2 = AFa1vSDK.values[aFi1qSDK.f409e.ordinal()];
                                    if (i2 == 1) {
                                        str = "com.facebook.katana";
                                    } else {
                                        if (i2 != 2) {
                                            throw new NoWhenBranchMatchedException();
                                        }
                                        str = "com.instagram.android";
                                    }
                                    Map<String, Object> map3 = aFi1qSDK.values;
                                    Intrinsics.checkNotNullExpressionValue(map3, "");
                                    map3.put("api_ver", Long.valueOf(AFb1qSDK.AFInAppEventParameterName(context, str)));
                                    Map<String, Object> map4 = aFi1qSDK.values;
                                    Intrinsics.checkNotNullExpressionValue(map4, "");
                                    map4.put("api_ver_name", AFb1qSDK.AFKeystoreWrapper(context, str));
                                }
                                cursorQuery.close();
                                if (Build.VERSION.SDK_INT >= 24) {
                                    if (contentProviderClientAcquireUnstableContentProviderClient != null) {
                                        contentProviderClientAcquireUnstableContentProviderClient.release();
                                    }
                                } else if (contentProviderClientAcquireUnstableContentProviderClient != null) {
                                    contentProviderClientAcquireUnstableContentProviderClient.release();
                                }
                            } else {
                                AFLogger.afDebugLog("[MetaReferrer]: Content provider returned no data");
                                if (cursorQuery != null) {
                                    cursorQuery.close();
                                }
                                if (Build.VERSION.SDK_INT >= 24) {
                                    if (contentProviderClientAcquireUnstableContentProviderClient != null) {
                                        contentProviderClientAcquireUnstableContentProviderClient.release();
                                    }
                                } else if (contentProviderClientAcquireUnstableContentProviderClient != null) {
                                    contentProviderClientAcquireUnstableContentProviderClient.release();
                                }
                            }
                        } catch (Throwable th) {
                            th = th;
                            cursor = cursorQuery;
                            try {
                                AFLogger.afErrorLog("[MetaReferrer]: Error while collecting Meta Install Referrer", th);
                                if (cursor != null) {
                                    cursor.close();
                                }
                                if (Build.VERSION.SDK_INT >= 24) {
                                    if (contentProviderClientAcquireUnstableContentProviderClient != null) {
                                        contentProviderClientAcquireUnstableContentProviderClient.release();
                                    }
                                } else if (contentProviderClientAcquireUnstableContentProviderClient != null) {
                                    contentProviderClientAcquireUnstableContentProviderClient.release();
                                }
                            } catch (Throwable th2) {
                                if (cursor != null) {
                                    cursor.close();
                                }
                                if (Build.VERSION.SDK_INT >= 24) {
                                    if (contentProviderClientAcquireUnstableContentProviderClient != null) {
                                        contentProviderClientAcquireUnstableContentProviderClient.release();
                                    }
                                } else if (contentProviderClientAcquireUnstableContentProviderClient != null) {
                                    contentProviderClientAcquireUnstableContentProviderClient.release();
                                }
                                throw th2;
                            }
                        }
                    } else {
                        AFLogger.afDebugLog("[MetaReferrer]: Content provider returned no data");
                        if (cursorQuery != null) {
                            cursorQuery.close();
                        }
                        if (Build.VERSION.SDK_INT >= 24) {
                            if (contentProviderClientAcquireUnstableContentProviderClient != null) {
                                contentProviderClientAcquireUnstableContentProviderClient.release();
                            }
                        } else if (contentProviderClientAcquireUnstableContentProviderClient != null) {
                            contentProviderClientAcquireUnstableContentProviderClient.release();
                        }
                    }
                } catch (Throwable th3) {
                    th = th3;
                }
            }
        } catch (Throwable th4) {
            th = th4;
            contentProviderClientAcquireUnstableContentProviderClient = null;
        }
        aFi1qSDK.AFInAppEventType();
        aFi1qSDK.registerClient.run();
    }
}
