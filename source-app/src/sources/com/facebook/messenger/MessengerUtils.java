package com.facebook.messenger;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.FacebookSdk;
import com.facebook.bolts.AppLinks;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import com.facebook.internal.FacebookSignatureValidator;
import com.facebook.internal.ServerProtocol;
import com.facebook.internal.instrument.crashshield.CrashShieldHandler;
import com.facebook.share.internal.ShareConstants;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.io.CloseableKt;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.StringsKt;

@Metadata(d1 = {"\u0000V\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u000b\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\"\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\b\u0007\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0016\u0010\u0012\u001a\u00020\u00132\u0006\u0010\u0014\u001a\u00020\u00152\u0006\u0010\u0016\u001a\u00020\u0017J\u0016\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\u00100\u00192\u0006\u0010\u001a\u001a\u00020\u001bH\u0002J\u0012\u0010\u001c\u001a\u0004\u0018\u00010\u001d2\u0006\u0010\u001e\u001a\u00020\u001fH\u0007J\u000e\u0010 \u001a\u00020!2\u0006\u0010\u001a\u001a\u00020\u001bJ\u0010\u0010\"\u001a\u00020\u00132\u0006\u0010\u001a\u001a\u00020\u001bH\u0007J\u0018\u0010#\u001a\b\u0012\u0004\u0012\u00020\u00040$2\b\u0010%\u001a\u0004\u0018\u00010\u0004H\u0002J \u0010&\u001a\u00020\u00132\u0006\u0010\u0014\u001a\u00020\u00152\u0006\u0010'\u001a\u00020\u00102\u0006\u0010\u0016\u001a\u00020\u0017H\u0007J \u0010(\u001a\u00020\u00132\u0006\u0010\u0014\u001a\u00020\u00152\u0006\u0010'\u001a\u00020\u00102\u0006\u0010\u0016\u001a\u00020\u0017H\u0002J\u0018\u0010)\u001a\u00020\u00132\u0006\u0010\u001a\u001a\u00020\u001b2\u0006\u0010*\u001a\u00020\u0004H\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\f\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\r\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\u0010X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0011\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006+"}, d2 = {"Lcom/facebook/messenger/MessengerUtils;", "", "()V", "EXTRA_APP_ID", "", "EXTRA_EXTERNAL_URI", "EXTRA_IS_COMPOSE", "EXTRA_IS_REPLY", "EXTRA_METADATA", "EXTRA_PARTICIPANTS", "EXTRA_PROTOCOL_VERSION", "EXTRA_REPLY_TOKEN_KEY", "EXTRA_THREAD_TOKEN_KEY", "ORCA_THREAD_CATEGORY_20150314", "PACKAGE_NAME", "PROTOCOL_VERSION_20150314", "", "TAG", "finishShareToMessenger", "", "activity", "Landroid/app/Activity;", "shareToMessengerParams", "Lcom/facebook/messenger/ShareToMessengerParams;", "getAllAvailableProtocolVersions", "", "context", "Landroid/content/Context;", "getMessengerThreadParamsForIntent", "Lcom/facebook/messenger/MessengerThreadParams;", SDKConstants.PARAM_INTENT, "Landroid/content/Intent;", "hasMessengerInstalled", "", "openMessengerInPlayStore", "parseParticipants", "", "s", "shareToMessenger", "requestCode", "shareToMessenger20150314", "startViewUri", ShareConstants.MEDIA_URI, "facebook-messenger_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class MessengerUtils {
    public static final String EXTRA_APP_ID = "com.facebook.orca.extra.APPLICATION_ID";
    public static final String EXTRA_EXTERNAL_URI = "com.facebook.orca.extra.EXTERNAL_URI";
    public static final String EXTRA_IS_COMPOSE = "com.facebook.orca.extra.IS_COMPOSE";
    public static final String EXTRA_IS_REPLY = "com.facebook.orca.extra.IS_REPLY";
    public static final String EXTRA_METADATA = "com.facebook.orca.extra.METADATA";
    public static final String EXTRA_PARTICIPANTS = "com.facebook.orca.extra.PARTICIPANTS";
    public static final String EXTRA_PROTOCOL_VERSION = "com.facebook.orca.extra.PROTOCOL_VERSION";
    public static final String EXTRA_REPLY_TOKEN_KEY = "com.facebook.orca.extra.REPLY_TOKEN";
    public static final String EXTRA_THREAD_TOKEN_KEY = "com.facebook.orca.extra.THREAD_TOKEN";
    public static final MessengerUtils INSTANCE = new MessengerUtils();
    public static final String ORCA_THREAD_CATEGORY_20150314 = "com.facebook.orca.category.PLATFORM_THREAD_20150314";
    public static final String PACKAGE_NAME = "com.facebook.orca";
    public static final int PROTOCOL_VERSION_20150314 = 20150314;
    private static final String TAG = "MessengerUtils";

    private MessengerUtils() {
    }

    public final void shareToMessenger(Activity activity, int requestCode, ShareToMessengerParams shareToMessengerParams) {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            Intrinsics.checkNotNullParameter(activity, "activity");
            Intrinsics.checkNotNullParameter(shareToMessengerParams, "shareToMessengerParams");
            if (!hasMessengerInstalled(activity)) {
                openMessengerInPlayStore(activity);
            } else if (getAllAvailableProtocolVersions(activity).contains(Integer.valueOf(PROTOCOL_VERSION_20150314))) {
                shareToMessenger20150314(activity, requestCode, shareToMessengerParams);
            } else {
                openMessengerInPlayStore(activity);
            }
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    private final void shareToMessenger20150314(Activity activity, int requestCode, ShareToMessengerParams shareToMessengerParams) {
        try {
            Intent intent = new Intent("android.intent.action.SEND");
            intent.setFlags(1);
            intent.setPackage(PACKAGE_NAME);
            intent.putExtra("android.intent.extra.STREAM", shareToMessengerParams.getUri());
            intent.setType(shareToMessengerParams.getMimeType());
            intent.putExtra(EXTRA_PROTOCOL_VERSION, PROTOCOL_VERSION_20150314);
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            intent.putExtra(EXTRA_APP_ID, FacebookSdk.getApplicationId());
            intent.putExtra(EXTRA_METADATA, shareToMessengerParams.getMetaData());
            intent.putExtra(EXTRA_EXTERNAL_URI, shareToMessengerParams.getExternalUri());
            activity.startActivityForResult(intent, requestCode);
        } catch (ActivityNotFoundException unused) {
            activity.startActivity(activity.getPackageManager().getLaunchIntentForPackage(PACKAGE_NAME));
        }
    }

    public final MessengerThreadParams getMessengerThreadParamsForIntent(Intent intent) {
        MessengerThreadParams.Origin origin;
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return null;
        }
        try {
            Intrinsics.checkNotNullParameter(intent, SDKConstants.PARAM_INTENT);
            Set<String> categories = intent.getCategories();
            if (categories != null && categories.contains(ORCA_THREAD_CATEGORY_20150314)) {
                AppLinks appLinks = AppLinks.INSTANCE;
                Bundle appLinkExtras = AppLinks.getAppLinkExtras(intent);
                String string = appLinkExtras == null ? null : appLinkExtras.getString(EXTRA_THREAD_TOKEN_KEY);
                String string2 = appLinkExtras == null ? null : appLinkExtras.getString(EXTRA_METADATA);
                String string3 = appLinkExtras == null ? null : appLinkExtras.getString(EXTRA_PARTICIPANTS);
                Boolean boolValueOf = appLinkExtras == null ? null : Boolean.valueOf(appLinkExtras.getBoolean(EXTRA_IS_REPLY));
                Boolean boolValueOf2 = appLinkExtras == null ? null : Boolean.valueOf(appLinkExtras.getBoolean(EXTRA_IS_COMPOSE));
                if (Intrinsics.areEqual(boolValueOf, true)) {
                    origin = MessengerThreadParams.Origin.REPLY_FLOW;
                } else if (Intrinsics.areEqual(boolValueOf2, true)) {
                    origin = MessengerThreadParams.Origin.COMPOSE_FLOW;
                } else {
                    origin = MessengerThreadParams.Origin.UNKNOWN;
                }
                if (string != null && string2 != null) {
                    return new MessengerThreadParams(origin, string, string2, parseParticipants(string3));
                }
            }
            return null;
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
            return null;
        }
    }

    public final void finishShareToMessenger(Activity activity, ShareToMessengerParams shareToMessengerParams) {
        Intrinsics.checkNotNullParameter(activity, "activity");
        Intrinsics.checkNotNullParameter(shareToMessengerParams, "shareToMessengerParams");
        Intent intent = activity.getIntent();
        Set<String> categories = intent.getCategories();
        if (categories == null) {
            activity.setResult(0, null);
            activity.finish();
            return;
        }
        if (categories.contains(ORCA_THREAD_CATEGORY_20150314)) {
            AppLinks appLinks = AppLinks.INSTANCE;
            Intrinsics.checkNotNullExpressionValue(intent, "originalIntent");
            Bundle appLinkExtras = AppLinks.getAppLinkExtras(intent);
            Intent intent2 = new Intent();
            if (appLinkExtras != null && categories.contains(ORCA_THREAD_CATEGORY_20150314)) {
                intent2.putExtra(EXTRA_PROTOCOL_VERSION, PROTOCOL_VERSION_20150314);
                intent2.putExtra(EXTRA_THREAD_TOKEN_KEY, appLinkExtras.getString(EXTRA_THREAD_TOKEN_KEY));
                intent2.setDataAndType(shareToMessengerParams.getUri(), shareToMessengerParams.getMimeType());
                intent2.setFlags(1);
                FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
                intent2.putExtra(EXTRA_APP_ID, FacebookSdk.getApplicationId());
                intent2.putExtra(EXTRA_METADATA, shareToMessengerParams.getMetaData());
                intent2.putExtra(EXTRA_EXTERNAL_URI, shareToMessengerParams.getExternalUri());
                activity.setResult(-1, intent2);
                activity.finish();
                return;
            }
            throw new RuntimeException();
        }
        activity.setResult(0, null);
        activity.finish();
    }

    public final boolean hasMessengerInstalled(Context context) {
        Intrinsics.checkNotNullParameter(context, "context");
        FacebookSignatureValidator facebookSignatureValidator = FacebookSignatureValidator.INSTANCE;
        return FacebookSignatureValidator.validateSignature(context, PACKAGE_NAME);
    }

    public final void openMessengerInPlayStore(Context context) {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            Intrinsics.checkNotNullParameter(context, "context");
            try {
                startViewUri(context, "market://details?id=com.facebook.orca");
            } catch (ActivityNotFoundException unused) {
                startViewUri(context, "http://play.google.com/store/apps/details?id=com.facebook.orca");
            }
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    private final Set<Integer> getAllAvailableProtocolVersions(Context context) {
        ContentResolver contentResolver = context.getContentResolver();
        HashSet hashSet = new HashSet();
        Cursor cursorQuery = contentResolver.query(Uri.parse("content://com.facebook.orca.provider.MessengerPlatformProvider/versions"), new String[]{ServerProtocol.FALLBACK_DIALOG_PARAM_VERSION}, null, null, null);
        if (cursorQuery != null) {
            Cursor cursor = cursorQuery;
            try {
                Cursor cursor2 = cursor;
                int columnIndex = cursor2.getColumnIndex(ServerProtocol.FALLBACK_DIALOG_PARAM_VERSION);
                while (cursor2.moveToNext()) {
                    hashSet.add(Integer.valueOf(cursor2.getInt(columnIndex)));
                }
                Unit unit = Unit.INSTANCE;
                CloseableKt.closeFinally(cursor, (Throwable) null);
            } catch (Throwable th) {
                try {
                    throw th;
                } catch (Throwable th2) {
                    CloseableKt.closeFinally(cursor, th);
                    throw th2;
                }
            }
        }
        return hashSet;
    }

    private final void startViewUri(Context context, String uri) {
        context.startActivity(new Intent("android.intent.action.VIEW", Uri.parse(uri)));
    }

    private final List<String> parseParticipants(String s) {
        String str = s;
        if (str == null || str.length() == 0) {
            return CollectionsKt.emptyList();
        }
        Object[] array = StringsKt.split$default(str, new String[]{","}, false, 0, 6, (Object) null).toArray(new String[0]);
        if (array != null) {
            String[] strArr = (String[]) array;
            ArrayList arrayList = new ArrayList(strArr.length);
            for (String str2 : strArr) {
                int length = str2.length() - 1;
                int i = 0;
                boolean z = false;
                while (i <= length) {
                    boolean z2 = Intrinsics.compare(str2.charAt(!z ? i : length), 32) <= 0;
                    if (z) {
                        if (!z2) {
                            break;
                        }
                        length--;
                    } else if (z2) {
                        i++;
                    } else {
                        z = true;
                    }
                }
                arrayList.add(str2.subSequence(i, length + 1).toString());
            }
            return arrayList;
        }
        throw new NullPointerException("null cannot be cast to non-null type kotlin.Array<T>");
    }
}
