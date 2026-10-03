package com.facebook;

import android.content.Context;
import android.graphics.Bitmap;
import android.location.Location;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Parcel;
import android.os.ParcelFileDescriptor;
import android.os.Parcelable;
import android.text.TextUtils;
import android.util.Log;
import android.util.Pair;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.appevents.internal.ViewHierarchyConstants;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import com.facebook.internal.AttributionIdentifiers;
import com.facebook.internal.InternalSettings;
import com.facebook.internal.Logger;
import com.facebook.internal.NativeProtocol;
import com.facebook.internal.ServerProtocol;
import com.facebook.internal.Utility;
import com.facebook.internal.Validate;
import com.facebook.internal.security.CertificateUtil;
import com.facebook.share.internal.ShareConstants;
import java.io.BufferedOutputStream;
import java.io.Closeable;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.security.SecureRandom;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.GZIPOutputStream;
import kotlin.Metadata;
import kotlin.collections.ArraysKt;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.StringCompanionObject;
import kotlin.text.Charsets;
import kotlin.text.StringsKt;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

@Metadata(d1 = {"\u0000j\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u000e\n\u0002\u0010\u000b\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\u001d\n\u0002\u0010\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010%\n\u0002\u0018\u0002\n\u0002\b\u000e\u0018\u0000 `2\u00020\u0001:\t^_`abcdefBO\b\u0017\u0012\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\t\u0012\n\b\u0002\u0010\n\u001a\u0004\u0018\u00010\u000b\u0012\n\b\u0002\u0010\f\u001a\u0004\u0018\u00010\u0005¢\u0006\u0002\u0010\rB\u0019\b\u0010\u0012\b\u0010\u0002\u001a\u0004\u0018\u00010\u0003\u0012\u0006\u0010\u000e\u001a\u00020\u000f¢\u0006\u0002\u0010\u0010J\b\u0010F\u001a\u00020GH\u0002J\u0018\u0010H\u001a\u00020\u00052\u0006\u0010I\u001a\u00020\u00052\u0006\u0010J\u001a\u00020\u001eH\u0002J\u0006\u0010K\u001a\u00020LJ\u0006\u0010M\u001a\u00020NJ\n\u0010O\u001a\u0004\u0018\u00010\u0005H\u0002J\n\u0010P\u001a\u0004\u0018\u00010\u0005H\u0002J\u0010\u0010Q\u001a\u00020\u00052\u0006\u0010I\u001a\u00020\u0005H\u0002J\b\u0010R\u001a\u00020\u001eH\u0002J\b\u0010S\u001a\u00020\u001eH\u0002J$\u0010T\u001a\u00020G2\u0006\u0010U\u001a\u00020V2\u0012\u0010W\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020Y0XH\u0002J\u000e\u0010Z\u001a\u00020G2\u0006\u0010[\u001a\u00020\u001eJ\b\u0010\\\u001a\u00020\u001eH\u0002J\b\u0010]\u001a\u00020\u0005H\u0016R\u001c\u0010\u0002\u001a\u0004\u0018\u00010\u0003X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0011\u0010\u0012\"\u0004\b\u0013\u0010\u0014R\u001c\u0010\u0015\u001a\u0004\u0018\u00010\u0005X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0016\u0010\u0017\"\u0004\b\u0018\u0010\u0019R\u001c\u0010\u001a\u001a\u0004\u0018\u00010\u0005X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001b\u0010\u0017\"\u0004\b\u001c\u0010\u0019R\u001a\u0010\u001d\u001a\u00020\u001eX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001f\u0010 \"\u0004\b!\u0010\"R(\u0010\n\u001a\u0004\u0018\u00010\u000b2\b\u0010\n\u001a\u0004\u0018\u00010\u000b@FX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b#\u0010$\"\u0004\b%\u0010&R\u000e\u0010'\u001a\u00020\u001eX\u0082\u000e¢\u0006\u0002\n\u0000R\u001c\u0010(\u001a\u0004\u0018\u00010)X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b*\u0010+\"\u0004\b,\u0010-R\u001c\u0010\u0004\u001a\u0004\u0018\u00010\u0005X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b.\u0010\u0017\"\u0004\b/\u0010\u0019R\u0016\u00100\u001a\u0004\u0018\u00010\u00058BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b1\u0010\u0017R(\u0010\b\u001a\u0004\u0018\u00010\t2\b\u00102\u001a\u0004\u0018\u00010\t@FX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b3\u00104\"\u0004\b5\u00106R\u0010\u0010\u000e\u001a\u0004\u0018\u00010\u0005X\u0082\u000e¢\u0006\u0002\n\u0000R\u001a\u0010\u0006\u001a\u00020\u0007X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b7\u00108\"\u0004\b9\u0010:R\u0011\u0010;\u001a\u00020\u00058F¢\u0006\u0006\u001a\u0004\b<\u0010\u0017R\u001c\u0010=\u001a\u0004\u0018\u00010\u0001X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b>\u0010?\"\u0004\b@\u0010AR\u0011\u0010B\u001a\u00020\u00058F¢\u0006\u0006\u001a\u0004\bC\u0010\u0017R\u001c\u0010\f\u001a\u0004\u0018\u00010\u0005X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bD\u0010\u0017\"\u0004\bE\u0010\u0019¨\u0006g"}, d2 = {"Lcom/facebook/GraphRequest;", "", SDKConstants.PARAM_ACCESS_TOKEN, "Lcom/facebook/AccessToken;", "graphPath", "", "parameters", "Landroid/os/Bundle;", "httpMethod", "Lcom/facebook/HttpMethod;", "callback", "Lcom/facebook/GraphRequest$Callback;", ServerProtocol.FALLBACK_DIALOG_PARAM_VERSION, "(Lcom/facebook/AccessToken;Ljava/lang/String;Landroid/os/Bundle;Lcom/facebook/HttpMethod;Lcom/facebook/GraphRequest$Callback;Ljava/lang/String;)V", "overriddenURL", "Ljava/net/URL;", "(Lcom/facebook/AccessToken;Ljava/net/URL;)V", "getAccessToken", "()Lcom/facebook/AccessToken;", "setAccessToken", "(Lcom/facebook/AccessToken;)V", "batchEntryDependsOn", "getBatchEntryDependsOn", "()Ljava/lang/String;", "setBatchEntryDependsOn", "(Ljava/lang/String;)V", "batchEntryName", "getBatchEntryName", "setBatchEntryName", "batchEntryOmitResultOnSuccess", "", "getBatchEntryOmitResultOnSuccess", "()Z", "setBatchEntryOmitResultOnSuccess", "(Z)V", "getCallback", "()Lcom/facebook/GraphRequest$Callback;", "setCallback", "(Lcom/facebook/GraphRequest$Callback;)V", "forceApplicationRequest", "graphObject", "Lorg/json/JSONObject;", "getGraphObject", "()Lorg/json/JSONObject;", "setGraphObject", "(Lorg/json/JSONObject;)V", "getGraphPath", "setGraphPath", "graphPathWithVersion", "getGraphPathWithVersion", SDKConstants.PARAM_VALUE, "getHttpMethod", "()Lcom/facebook/HttpMethod;", "setHttpMethod", "(Lcom/facebook/HttpMethod;)V", "getParameters", "()Landroid/os/Bundle;", "setParameters", "(Landroid/os/Bundle;)V", "relativeUrlForBatchedRequest", "getRelativeUrlForBatchedRequest", "tag", "getTag", "()Ljava/lang/Object;", "setTag", "(Ljava/lang/Object;)V", "urlForSingleRequest", "getUrlForSingleRequest", "getVersion", "setVersion", "addCommonParameters", "", "appendParametersToBaseUrl", "baseUrl", "isBatch", "executeAndWait", "Lcom/facebook/GraphResponse;", "executeAsync", "Lcom/facebook/GraphRequestAsyncTask;", "getAccessTokenToUseForRequest", "getClientTokenForRequest", "getUrlWithGraphPath", "isApplicationRequest", "isValidGraphRequestForDomain", "serializeToBatch", GraphRequest.BATCH_PARAM, "Lorg/json/JSONArray;", "attachments", "", "Lcom/facebook/GraphRequest$Attachment;", "setForceApplicationRequest", "forceOverride", "shouldForceClientTokenForRequest", "toString", "Attachment", "Callback", "Companion", "GraphJSONArrayCallback", "GraphJSONObjectCallback", "KeyValueSerializer", "OnProgressCallback", "ParcelableResourceWithMimeType", "Serializer", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class GraphRequest {
    private static final String ACCEPT_LANGUAGE_HEADER = "Accept-Language";
    public static final String ACCESS_TOKEN_PARAM = "access_token";
    private static final String ATTACHED_FILES_PARAM = "attached_files";
    private static final String ATTACHMENT_FILENAME_PREFIX = "file";
    private static final String BATCH_APP_ID_PARAM = "batch_app_id";
    private static final String BATCH_BODY_PARAM = "body";
    private static final String BATCH_ENTRY_DEPENDS_ON_PARAM = "depends_on";
    private static final String BATCH_ENTRY_NAME_PARAM = "name";
    private static final String BATCH_ENTRY_OMIT_RESPONSE_ON_SUCCESS_PARAM = "omit_response_on_success";
    private static final String BATCH_METHOD_PARAM = "method";
    private static final String BATCH_PARAM = "batch";
    private static final String BATCH_RELATIVE_URL_PARAM = "relative_url";
    private static final String CAPTION_PARAM = "caption";
    private static final String CONTENT_ENCODING_HEADER = "Content-Encoding";
    private static final String CONTENT_TYPE_HEADER = "Content-Type";
    private static final String DEBUG_KEY = "__debug__";
    private static final String DEBUG_MESSAGES_KEY = "messages";
    private static final String DEBUG_MESSAGE_KEY = "message";
    private static final String DEBUG_MESSAGE_LINK_KEY = "link";
    private static final String DEBUG_MESSAGE_TYPE_KEY = "type";
    private static final String DEBUG_PARAM = "debug";
    private static final String DEBUG_SEVERITY_INFO = "info";
    private static final String DEBUG_SEVERITY_WARNING = "warning";
    public static final String FIELDS_PARAM = "fields";
    private static final String FORMAT_JSON = "json";
    private static final String FORMAT_PARAM = "format";
    private static final String ISO_8601_FORMAT_STRING = "yyyy-MM-dd'T'HH:mm:ssZ";
    public static final int MAXIMUM_BATCH_SIZE = 50;

    private static final String f509ME = "me";
    private static final String MIME_BOUNDARY;
    private static final String MY_FRIENDS = "me/friends";
    private static final String MY_PHOTOS = "me/photos";
    private static final String PICTURE_PARAM = "picture";
    private static final String SDK_ANDROID = "android";
    private static final String SDK_PARAM = "sdk";
    private static final String SEARCH = "search";
    private static final String USER_AGENT_BASE = "FBAndroidSDK";
    private static final String USER_AGENT_HEADER = "User-Agent";
    private static final String VIDEOS_SUFFIX = "/videos";
    private static String defaultBatchApplicationId;
    private static volatile String userAgent;
    private static final Pattern versionPattern;
    private AccessToken accessToken;
    private String batchEntryDependsOn;
    private String batchEntryName;
    private boolean batchEntryOmitResultOnSuccess;
    private Callback callback;
    private boolean forceApplicationRequest;
    private JSONObject graphObject;
    private String graphPath;
    private HttpMethod httpMethod;
    private String overriddenURL;
    private Bundle parameters;
    private Object tag;
    private String version;

    public static final Companion INSTANCE = new Companion(null);
    public static final String TAG = "GraphRequest";

    @Metadata(d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\bæ\u0080\u0001\u0018\u00002\u00020\u0001J\u0010\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H&¨\u0006\u0006"}, d2 = {"Lcom/facebook/GraphRequest$Callback;", "", "onCompleted", "", "response", "Lcom/facebook/GraphResponse;", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public interface Callback {
        void onCompleted(GraphResponse response);
    }

    @Metadata(d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\bæ\u0080\u0001\u0018\u00002\u00020\u0001J\u001c\u0010\u0002\u001a\u00020\u00032\b\u0010\u0004\u001a\u0004\u0018\u00010\u00052\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007H&¨\u0006\b"}, d2 = {"Lcom/facebook/GraphRequest$GraphJSONArrayCallback;", "", "onCompleted", "", "objects", "Lorg/json/JSONArray;", "response", "Lcom/facebook/GraphResponse;", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public interface GraphJSONArrayCallback {
        void onCompleted(JSONArray objects, GraphResponse response);
    }

    @Metadata(d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\bæ\u0080\u0001\u0018\u00002\u00020\u0001J\u001c\u0010\u0002\u001a\u00020\u00032\b\u0010\u0004\u001a\u0004\u0018\u00010\u00052\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007H&¨\u0006\b"}, d2 = {"Lcom/facebook/GraphRequest$GraphJSONObjectCallback;", "", "onCompleted", "", "obj", "Lorg/json/JSONObject;", "response", "Lcom/facebook/GraphResponse;", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public interface GraphJSONObjectCallback {
        void onCompleted(JSONObject obj, GraphResponse response);
    }

    @Metadata(d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\bâ\u0080\u0001\u0018\u00002\u00020\u0001J\u0018\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u0005H&¨\u0006\u0007"}, d2 = {"Lcom/facebook/GraphRequest$KeyValueSerializer;", "", "writeString", "", SDKConstants.PARAM_KEY, "", SDKConstants.PARAM_VALUE, "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    private interface KeyValueSerializer {
        void writeString(String key, String value);
    }

    @Metadata(d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\t\n\u0002\b\u0002\bf\u0018\u00002\u00020\u0001J\u0018\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u0005H&¨\u0006\u0007"}, d2 = {"Lcom/facebook/GraphRequest$OnProgressCallback;", "Lcom/facebook/GraphRequest$Callback;", "onProgress", "", "current", "", "max", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public interface OnProgressCallback extends Callback {
        void onProgress(long current, long max);
    }

    public GraphRequest() {
        this(null, null, null, null, null, null, 63, null);
    }

    public GraphRequest(AccessToken accessToken) {
        this(accessToken, null, null, null, null, null, 62, null);
    }

    public GraphRequest(AccessToken accessToken, String str) {
        this(accessToken, str, null, null, null, null, 60, null);
    }

    public GraphRequest(AccessToken accessToken, String str, Bundle bundle) {
        this(accessToken, str, bundle, null, null, null, 56, null);
    }

    public GraphRequest(AccessToken accessToken, String str, Bundle bundle, HttpMethod httpMethod) {
        this(accessToken, str, bundle, httpMethod, null, null, 48, null);
    }

    public GraphRequest(AccessToken accessToken, String str, Bundle bundle, HttpMethod httpMethod, Callback callback) {
        this(accessToken, str, bundle, httpMethod, callback, null, 32, null);
    }

    @JvmStatic
    public static final GraphResponse executeAndWait(GraphRequest graphRequest) {
        return INSTANCE.executeAndWait(graphRequest);
    }

    @JvmStatic
    public static final List<GraphResponse> executeBatchAndWait(GraphRequestBatch graphRequestBatch) {
        return INSTANCE.executeBatchAndWait(graphRequestBatch);
    }

    @JvmStatic
    public static final List<GraphResponse> executeBatchAndWait(Collection<GraphRequest> collection) {
        return INSTANCE.executeBatchAndWait(collection);
    }

    @JvmStatic
    public static final List<GraphResponse> executeBatchAndWait(GraphRequest... graphRequestArr) {
        return INSTANCE.executeBatchAndWait(graphRequestArr);
    }

    @JvmStatic
    public static final GraphRequestAsyncTask executeBatchAsync(GraphRequestBatch graphRequestBatch) {
        return INSTANCE.executeBatchAsync(graphRequestBatch);
    }

    @JvmStatic
    public static final GraphRequestAsyncTask executeBatchAsync(Collection<GraphRequest> collection) {
        return INSTANCE.executeBatchAsync(collection);
    }

    @JvmStatic
    public static final GraphRequestAsyncTask executeBatchAsync(GraphRequest... graphRequestArr) {
        return INSTANCE.executeBatchAsync(graphRequestArr);
    }

    @JvmStatic
    public static final List<GraphResponse> executeConnectionAndWait(HttpURLConnection httpURLConnection, GraphRequestBatch graphRequestBatch) {
        return INSTANCE.executeConnectionAndWait(httpURLConnection, graphRequestBatch);
    }

    @JvmStatic
    public static final List<GraphResponse> executeConnectionAndWait(HttpURLConnection httpURLConnection, Collection<GraphRequest> collection) {
        return INSTANCE.executeConnectionAndWait(httpURLConnection, collection);
    }

    @JvmStatic
    public static final GraphRequestAsyncTask executeConnectionAsync(Handler handler, HttpURLConnection httpURLConnection, GraphRequestBatch graphRequestBatch) {
        return INSTANCE.executeConnectionAsync(handler, httpURLConnection, graphRequestBatch);
    }

    @JvmStatic
    public static final GraphRequestAsyncTask executeConnectionAsync(HttpURLConnection httpURLConnection, GraphRequestBatch graphRequestBatch) {
        return INSTANCE.executeConnectionAsync(httpURLConnection, graphRequestBatch);
    }

    @JvmStatic
    public static final String getDefaultBatchApplicationId() {
        return INSTANCE.getDefaultBatchApplicationId();
    }

    @JvmStatic
    public static final GraphRequest newCustomAudienceThirdPartyIdRequest(AccessToken accessToken, Context context, Callback callback) {
        return INSTANCE.newCustomAudienceThirdPartyIdRequest(accessToken, context, callback);
    }

    @JvmStatic
    public static final GraphRequest newCustomAudienceThirdPartyIdRequest(AccessToken accessToken, Context context, String str, Callback callback) {
        return INSTANCE.newCustomAudienceThirdPartyIdRequest(accessToken, context, str, callback);
    }

    @JvmStatic
    public static final GraphRequest newDeleteObjectRequest(AccessToken accessToken, String str, Callback callback) {
        return INSTANCE.newDeleteObjectRequest(accessToken, str, callback);
    }

    @JvmStatic
    public static final GraphRequest newGraphPathRequest(AccessToken accessToken, String str, Callback callback) {
        return INSTANCE.newGraphPathRequest(accessToken, str, callback);
    }

    @JvmStatic
    public static final GraphRequest newMeRequest(AccessToken accessToken, GraphJSONObjectCallback graphJSONObjectCallback) {
        return INSTANCE.newMeRequest(accessToken, graphJSONObjectCallback);
    }

    @JvmStatic
    public static final GraphRequest newMyFriendsRequest(AccessToken accessToken, GraphJSONArrayCallback graphJSONArrayCallback) {
        return INSTANCE.newMyFriendsRequest(accessToken, graphJSONArrayCallback);
    }

    @JvmStatic
    public static final GraphRequest newPlacesSearchRequest(AccessToken accessToken, Location location, int i, int i2, String str, GraphJSONArrayCallback graphJSONArrayCallback) {
        return INSTANCE.newPlacesSearchRequest(accessToken, location, i, i2, str, graphJSONArrayCallback);
    }

    @JvmStatic
    public static final GraphRequest newPostRequest(AccessToken accessToken, String str, JSONObject jSONObject, Callback callback) {
        return INSTANCE.newPostRequest(accessToken, str, jSONObject, callback);
    }

    @JvmStatic
    public static final GraphRequest newPostRequestWithBundle(AccessToken accessToken, String str, Bundle bundle, Callback callback) {
        return INSTANCE.newPostRequestWithBundle(accessToken, str, bundle, callback);
    }

    @JvmStatic
    public static final GraphRequest newUploadPhotoRequest(AccessToken accessToken, String str, Bitmap bitmap, String str2, Bundle bundle, Callback callback) {
        return INSTANCE.newUploadPhotoRequest(accessToken, str, bitmap, str2, bundle, callback);
    }

    @JvmStatic
    public static final GraphRequest newUploadPhotoRequest(AccessToken accessToken, String str, Uri uri, String str2, Bundle bundle, Callback callback) throws FacebookException, FileNotFoundException {
        return INSTANCE.newUploadPhotoRequest(accessToken, str, uri, str2, bundle, callback);
    }

    @JvmStatic
    public static final GraphRequest newUploadPhotoRequest(AccessToken accessToken, String str, File file, String str2, Bundle bundle, Callback callback) throws FileNotFoundException {
        return INSTANCE.newUploadPhotoRequest(accessToken, str, file, str2, bundle, callback);
    }

    @JvmStatic
    public static final void setDefaultBatchApplicationId(String str) {
        INSTANCE.setDefaultBatchApplicationId(str);
    }

    @JvmStatic
    public static final HttpURLConnection toHttpConnection(GraphRequestBatch graphRequestBatch) {
        return INSTANCE.toHttpConnection(graphRequestBatch);
    }

    @JvmStatic
    public static final HttpURLConnection toHttpConnection(Collection<GraphRequest> collection) {
        return INSTANCE.toHttpConnection(collection);
    }

    @JvmStatic
    public static final HttpURLConnection toHttpConnection(GraphRequest... graphRequestArr) {
        return INSTANCE.toHttpConnection(graphRequestArr);
    }

    public final AccessToken getAccessToken() {
        return this.accessToken;
    }

    public final void setAccessToken(AccessToken accessToken) {
        this.accessToken = accessToken;
    }

    public final String getGraphPath() {
        return this.graphPath;
    }

    public final void setGraphPath(String str) {
        this.graphPath = str;
    }

    public final JSONObject getGraphObject() {
        return this.graphObject;
    }

    public final void setGraphObject(JSONObject jSONObject) {
        this.graphObject = jSONObject;
    }

    public final String getBatchEntryName() {
        return this.batchEntryName;
    }

    public final void setBatchEntryName(String str) {
        this.batchEntryName = str;
    }

    public final String getBatchEntryDependsOn() {
        return this.batchEntryDependsOn;
    }

    public final void setBatchEntryDependsOn(String str) {
        this.batchEntryDependsOn = str;
    }

    public final boolean getBatchEntryOmitResultOnSuccess() {
        return this.batchEntryOmitResultOnSuccess;
    }

    public final void setBatchEntryOmitResultOnSuccess(boolean z) {
        this.batchEntryOmitResultOnSuccess = z;
    }

    public final Bundle getParameters() {
        return this.parameters;
    }

    public final void setParameters(Bundle bundle) {
        Intrinsics.checkNotNullParameter(bundle, "<set-?>");
        this.parameters = bundle;
    }

    public final Object getTag() {
        return this.tag;
    }

    public final void setTag(Object obj) {
        this.tag = obj;
    }

    public final String getVersion() {
        return this.version;
    }

    public final void setVersion(String str) {
        this.version = str;
    }

    public final Callback getCallback() {
        return this.callback;
    }

    public final void setCallback(final Callback callback) {
        FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
        if (!FacebookSdk.isLoggingBehaviorEnabled(LoggingBehavior.GRAPH_API_DEBUG_INFO)) {
            FacebookSdk facebookSdk2 = FacebookSdk.INSTANCE;
            if (!FacebookSdk.isLoggingBehaviorEnabled(LoggingBehavior.GRAPH_API_DEBUG_WARNING)) {
                this.callback = callback;
                return;
            }
        }
        this.callback = new Callback() {
            @Override
            public final void onCompleted(GraphResponse graphResponse) {
                GraphRequest.m2369_set_callback_$lambda0(callback, graphResponse);
            }
        };
    }

    public static final void m2369_set_callback_$lambda0(Callback callback, GraphResponse graphResponse) {
        int length;
        Intrinsics.checkNotNullParameter(graphResponse, "response");
        JSONObject graphObject = graphResponse.getGraphObject();
        JSONObject jSONObjectOptJSONObject = graphObject == null ? null : graphObject.optJSONObject(DEBUG_KEY);
        JSONArray jSONArrayOptJSONArray = jSONObjectOptJSONObject == null ? null : jSONObjectOptJSONObject.optJSONArray(DEBUG_MESSAGES_KEY);
        if (jSONArrayOptJSONArray != null && (length = jSONArrayOptJSONArray.length()) > 0) {
            int i = 0;
            while (true) {
                int i2 = i + 1;
                JSONObject jSONObjectOptJSONObject2 = jSONArrayOptJSONArray.optJSONObject(i);
                String strOptString = jSONObjectOptJSONObject2 == null ? null : jSONObjectOptJSONObject2.optString("message");
                String strOptString2 = jSONObjectOptJSONObject2 == null ? null : jSONObjectOptJSONObject2.optString("type");
                String strOptString3 = jSONObjectOptJSONObject2 == null ? null : jSONObjectOptJSONObject2.optString("link");
                if (strOptString != null && strOptString2 != null) {
                    LoggingBehavior loggingBehavior = LoggingBehavior.GRAPH_API_DEBUG_INFO;
                    if (Intrinsics.areEqual(strOptString2, DEBUG_SEVERITY_WARNING)) {
                        loggingBehavior = LoggingBehavior.GRAPH_API_DEBUG_WARNING;
                    }
                    Utility utility = Utility.INSTANCE;
                    if (!Utility.isNullOrEmpty(strOptString3)) {
                        strOptString = ((Object) strOptString) + " Link: " + ((Object) strOptString3);
                    }
                    Logger.Companion companion = Logger.INSTANCE;
                    String str = TAG;
                    Intrinsics.checkNotNullExpressionValue(str, "TAG");
                    companion.log(loggingBehavior, str, strOptString);
                }
                if (i2 >= length) {
                    break;
                } else {
                    i = i2;
                }
            }
        }
        if (callback == null) {
            return;
        }
        callback.onCompleted(graphResponse);
    }

    public final HttpMethod getHttpMethod() {
        return this.httpMethod;
    }

    public final void setHttpMethod(HttpMethod httpMethod) {
        if (this.overriddenURL != null && httpMethod != HttpMethod.GET) {
            throw new FacebookException("Can't change HTTP method on request with overridden URL.");
        }
        if (httpMethod == null) {
            httpMethod = HttpMethod.GET;
        }
        this.httpMethod = httpMethod;
    }

    @Metadata(d1 = {"\u0000î\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u001b\n\u0002\u0010\b\n\u0002\b\u0015\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0011\n\u0000\n\u0002\u0010\u001e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0002\b\b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010$\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010%\n\u0002\b\t\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0010\u00107\u001a\u0002082\u0006\u00109\u001a\u00020:H\u0002J\u0010\u0010;\u001a\u00020<2\u0006\u0010=\u001a\u00020>H\u0007J\u0016\u0010?\u001a\b\u0012\u0004\u0012\u00020<0@2\u0006\u0010A\u001a\u00020BH\u0007J'\u0010?\u001a\b\u0012\u0004\u0012\u00020<0@2\u0012\u0010A\u001a\n\u0012\u0006\b\u0001\u0012\u00020>0C\"\u00020>H\u0007¢\u0006\u0002\u0010DJ\u001c\u0010?\u001a\b\u0012\u0004\u0012\u00020<0@2\f\u0010A\u001a\b\u0012\u0004\u0012\u00020>0EH\u0007J\u0010\u0010F\u001a\u00020G2\u0006\u0010A\u001a\u00020BH\u0007J!\u0010F\u001a\u00020G2\u0012\u0010A\u001a\n\u0012\u0006\b\u0001\u0012\u00020>0C\"\u00020>H\u0007¢\u0006\u0002\u0010HJ\u0016\u0010F\u001a\u00020G2\f\u0010A\u001a\b\u0012\u0004\u0012\u00020>0EH\u0007J\u001e\u0010I\u001a\b\u0012\u0004\u0012\u00020<0@2\u0006\u0010J\u001a\u0002082\u0006\u0010A\u001a\u00020BH\u0007J$\u0010I\u001a\b\u0012\u0004\u0012\u00020<0@2\u0006\u0010J\u001a\u0002082\f\u0010A\u001a\b\u0012\u0004\u0012\u00020>0EH\u0007J\"\u0010K\u001a\u00020G2\b\u0010L\u001a\u0004\u0018\u00010M2\u0006\u0010J\u001a\u0002082\u0006\u0010A\u001a\u00020BH\u0007J\u0018\u0010K\u001a\u00020G2\u0006\u0010J\u001a\u0002082\u0006\u0010A\u001a\u00020BH\u0007J\u0010\u0010N\u001a\u00020\u00042\u0006\u0010O\u001a\u00020BH\u0002J\n\u0010P\u001a\u0004\u0018\u00010\u0004H\u0007J\u0012\u0010Q\u001a\u00020\u00042\b\u0010R\u001a\u0004\u0018\u00010\u0004H\u0002J\u0010\u0010S\u001a\u00020T2\u0006\u0010A\u001a\u00020BH\u0002J\u0010\u0010U\u001a\u00020T2\u0006\u0010A\u001a\u00020BH\u0002J\u0010\u0010V\u001a\u00020T2\u0006\u0010W\u001a\u00020\u0004H\u0002J\u0012\u0010X\u001a\u00020T2\b\u0010Y\u001a\u0004\u0018\u00010\u0001H\u0002J\u0012\u0010Z\u001a\u00020T2\b\u0010Y\u001a\u0004\u0018\u00010\u0001H\u0002J$\u0010[\u001a\u00020>2\b\u0010\\\u001a\u0004\u0018\u00010]2\u0006\u0010^\u001a\u00020_2\b\u0010`\u001a\u0004\u0018\u00010aH\u0007J.\u0010[\u001a\u00020>2\b\u0010\\\u001a\u0004\u0018\u00010]2\u0006\u0010^\u001a\u00020_2\b\u0010b\u001a\u0004\u0018\u00010\u00042\b\u0010`\u001a\u0004\u0018\u00010aH\u0007J&\u0010c\u001a\u00020>2\b\u0010\\\u001a\u0004\u0018\u00010]2\b\u0010d\u001a\u0004\u0018\u00010\u00042\b\u0010`\u001a\u0004\u0018\u00010aH\u0007J&\u0010e\u001a\u00020>2\b\u0010\\\u001a\u0004\u0018\u00010]2\b\u0010R\u001a\u0004\u0018\u00010\u00042\b\u0010`\u001a\u0004\u0018\u00010aH\u0007J\u001c\u0010f\u001a\u00020>2\b\u0010\\\u001a\u0004\u0018\u00010]2\b\u0010`\u001a\u0004\u0018\u00010gH\u0007J\u001c\u0010h\u001a\u00020>2\b\u0010\\\u001a\u0004\u0018\u00010]2\b\u0010`\u001a\u0004\u0018\u00010iH\u0007J@\u0010j\u001a\u00020>2\b\u0010\\\u001a\u0004\u0018\u00010]2\b\u0010k\u001a\u0004\u0018\u00010l2\u0006\u0010m\u001a\u00020 2\u0006\u0010n\u001a\u00020 2\b\u0010o\u001a\u0004\u0018\u00010\u00042\b\u0010`\u001a\u0004\u0018\u00010iH\u0007J0\u0010p\u001a\u00020>2\b\u0010\\\u001a\u0004\u0018\u00010]2\b\u0010R\u001a\u0004\u0018\u00010\u00042\b\u0010q\u001a\u0004\u0018\u00010r2\b\u0010`\u001a\u0004\u0018\u00010aH\u0007J0\u0010s\u001a\u00020>2\b\u0010\\\u001a\u0004\u0018\u00010]2\b\u0010R\u001a\u0004\u0018\u00010\u00042\b\u0010t\u001a\u0004\u0018\u00010u2\b\u0010`\u001a\u0004\u0018\u00010aH\u0007JB\u0010v\u001a\u00020>2\b\u0010\\\u001a\u0004\u0018\u00010]2\b\u0010R\u001a\u0004\u0018\u00010\u00042\u0006\u0010w\u001a\u00020x2\b\u0010y\u001a\u0004\u0018\u00010\u00042\b\u0010z\u001a\u0004\u0018\u00010u2\b\u0010`\u001a\u0004\u0018\u00010aH\u0007JB\u0010v\u001a\u00020>2\b\u0010\\\u001a\u0004\u0018\u00010]2\b\u0010R\u001a\u0004\u0018\u00010\u00042\u0006\u0010{\u001a\u00020|2\b\u0010y\u001a\u0004\u0018\u00010\u00042\b\u0010z\u001a\u0004\u0018\u00010u2\b\u0010`\u001a\u0004\u0018\u00010aH\u0007JB\u0010v\u001a\u00020>2\b\u0010\\\u001a\u0004\u0018\u00010]2\b\u0010R\u001a\u0004\u0018\u00010\u00042\u0006\u0010}\u001a\u00020~2\b\u0010y\u001a\u0004\u0018\u00010\u00042\b\u0010z\u001a\u0004\u0018\u00010u2\b\u0010`\u001a\u0004\u0018\u00010aH\u0007J\u0012\u0010\u007f\u001a\u00020\u00042\b\u0010Y\u001a\u0004\u0018\u00010\u0001H\u0002J$\u0010\u0080\u0001\u001a\u00030\u0081\u00012\u0006\u0010q\u001a\u00020r2\u0006\u0010W\u001a\u00020\u00042\b\u0010\u0082\u0001\u001a\u00030\u0083\u0001H\u0002J.\u0010\u0084\u0001\u001a\u00030\u0081\u00012\u0007\u0010\u0085\u0001\u001a\u00020\u00042\u0006\u0010Y\u001a\u00020\u00012\b\u0010\u0082\u0001\u001a\u00030\u0083\u00012\u0007\u0010\u0086\u0001\u001a\u00020TH\u0002JB\u0010\u0087\u0001\u001a\u00030\u0081\u00012\u0006\u0010A\u001a\u00020B2\n\u0010\u0088\u0001\u001a\u0005\u0018\u00010\u0089\u00012\u0007\u0010\u008a\u0001\u001a\u00020 2\u0006\u00109\u001a\u00020:2\b\u0010\u008b\u0001\u001a\u00030\u008c\u00012\u0007\u0010\u008d\u0001\u001a\u00020TH\u0002J'\u0010\u008e\u0001\u001a\u00030\u0081\u00012\u0006\u0010A\u001a\u00020B2\r\u0010\u008f\u0001\u001a\b\u0012\u0004\u0012\u00020<0@H\u0001¢\u0006\u0003\b\u0090\u0001J+\u0010\u0091\u0001\u001a\u00030\u0081\u00012\u0015\u0010\u0092\u0001\u001a\u0010\u0012\u0004\u0012\u00020\u0004\u0012\u0005\u0012\u00030\u0094\u00010\u0093\u00012\b\u0010\u0082\u0001\u001a\u00030\u0095\u0001H\u0002J%\u0010\u0096\u0001\u001a\u00030\u0081\u00012\u0007\u0010\u0097\u0001\u001a\u00020u2\b\u0010\u0082\u0001\u001a\u00030\u0095\u00012\u0006\u0010=\u001a\u00020>H\u0002J9\u0010\u0098\u0001\u001a\u00030\u0081\u00012\b\u0010\u0082\u0001\u001a\u00030\u0095\u00012\f\u0010A\u001a\b\u0012\u0004\u0012\u00020>0E2\u0015\u0010\u0092\u0001\u001a\u0010\u0012\u0004\u0012\u00020\u0004\u0012\u0005\u0012\u00030\u0094\u00010\u0099\u0001H\u0002J \u0010\u009a\u0001\u001a\u00030\u0081\u00012\u0006\u0010A\u001a\u00020B2\u0006\u0010J\u001a\u000208H\u0001¢\u0006\u0003\b\u009b\u0001J\u001b\u0010\u009c\u0001\u001a\u00030\u0081\u00012\u0006\u0010J\u001a\u0002082\u0007\u0010\u008d\u0001\u001a\u00020TH\u0002J\u0014\u0010\u009d\u0001\u001a\u00030\u0081\u00012\b\u0010b\u001a\u0004\u0018\u00010\u0004H\u0007J\u0011\u0010\u009e\u0001\u001a\u0002082\u0006\u0010A\u001a\u00020BH\u0007J#\u0010\u009e\u0001\u001a\u0002082\u0012\u0010A\u001a\n\u0012\u0006\b\u0001\u0012\u00020>0C\"\u00020>H\u0007¢\u0006\u0003\u0010\u009f\u0001J\u0017\u0010\u009e\u0001\u001a\u0002082\f\u0010A\u001a\b\u0012\u0004\u0012\u00020>0EH\u0007J\u0018\u0010 \u0001\u001a\u00030\u0081\u00012\u0006\u0010A\u001a\u00020BH\u0001¢\u0006\u0003\b¡\u0001R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\f\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\r\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0010\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0011\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0012\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0013\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0014\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0015\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0016\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0017\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0018\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0019\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u001a\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u001b\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u001c\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u001d\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u001e\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u001f\u001a\u00020 X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010!\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\"\u001a\u00020\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010#\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010$\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010%\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010&\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010'\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010(\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u001e\u0010)\u001a\n **\u0004\u0018\u00010\u00040\u00048\u0000X\u0081\u0004¢\u0006\b\n\u0000\u0012\u0004\b+\u0010\u0002R\u000e\u0010,\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010-\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010.\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u0010\u0010/\u001a\u0004\u0018\u00010\u0004X\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u00100\u001a\u00020\u00048BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b1\u00102R\u0018\u00103\u001a\u0004\u0018\u00010\u00048BX\u0082\u000e¢\u0006\b\n\u0000\u001a\u0004\b4\u00102R\u0016\u00105\u001a\n **\u0004\u0018\u00010606X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006¢\u0001"}, d2 = {"Lcom/facebook/GraphRequest$Companion;", "", "()V", "ACCEPT_LANGUAGE_HEADER", "", "ACCESS_TOKEN_PARAM", "ATTACHED_FILES_PARAM", "ATTACHMENT_FILENAME_PREFIX", "BATCH_APP_ID_PARAM", "BATCH_BODY_PARAM", "BATCH_ENTRY_DEPENDS_ON_PARAM", "BATCH_ENTRY_NAME_PARAM", "BATCH_ENTRY_OMIT_RESPONSE_ON_SUCCESS_PARAM", "BATCH_METHOD_PARAM", "BATCH_PARAM", "BATCH_RELATIVE_URL_PARAM", "CAPTION_PARAM", "CONTENT_ENCODING_HEADER", "CONTENT_TYPE_HEADER", "DEBUG_KEY", "DEBUG_MESSAGES_KEY", "DEBUG_MESSAGE_KEY", "DEBUG_MESSAGE_LINK_KEY", "DEBUG_MESSAGE_TYPE_KEY", "DEBUG_PARAM", "DEBUG_SEVERITY_INFO", "DEBUG_SEVERITY_WARNING", "FIELDS_PARAM", "FORMAT_JSON", "FORMAT_PARAM", "ISO_8601_FORMAT_STRING", "MAXIMUM_BATCH_SIZE", "", "ME", "MIME_BOUNDARY", "MY_FRIENDS", "MY_PHOTOS", "PICTURE_PARAM", "SDK_ANDROID", "SDK_PARAM", ViewHierarchyConstants.SEARCH, "TAG", "kotlin.jvm.PlatformType", "getTAG$facebook_core_release$annotations", "USER_AGENT_BASE", "USER_AGENT_HEADER", "VIDEOS_SUFFIX", "defaultBatchApplicationId", "mimeContentType", "getMimeContentType", "()Ljava/lang/String;", "userAgent", "getUserAgent", "versionPattern", "Ljava/util/regex/Pattern;", "createConnection", "Ljava/net/HttpURLConnection;", "url", "Ljava/net/URL;", "executeAndWait", "Lcom/facebook/GraphResponse;", "request", "Lcom/facebook/GraphRequest;", "executeBatchAndWait", "", "requests", "Lcom/facebook/GraphRequestBatch;", "", "([Lcom/facebook/GraphRequest;)Ljava/util/List;", "", "executeBatchAsync", "Lcom/facebook/GraphRequestAsyncTask;", "([Lcom/facebook/GraphRequest;)Lcom/facebook/GraphRequestAsyncTask;", "executeConnectionAndWait", "connection", "executeConnectionAsync", "callbackHandler", "Landroid/os/Handler;", "getBatchAppId", GraphRequest.BATCH_PARAM, "getDefaultBatchApplicationId", "getDefaultPhotoPathIfNull", "graphPath", "hasOnProgressCallbacks", "", "isGzipCompressible", "isMeRequest", "path", "isSupportedAttachmentType", SDKConstants.PARAM_VALUE, "isSupportedParameterType", "newCustomAudienceThirdPartyIdRequest", SDKConstants.PARAM_ACCESS_TOKEN, "Lcom/facebook/AccessToken;", "context", "Landroid/content/Context;", "callback", "Lcom/facebook/GraphRequest$Callback;", "applicationId", "newDeleteObjectRequest", "id", "newGraphPathRequest", "newMeRequest", "Lcom/facebook/GraphRequest$GraphJSONObjectCallback;", "newMyFriendsRequest", "Lcom/facebook/GraphRequest$GraphJSONArrayCallback;", "newPlacesSearchRequest", "location", "Landroid/location/Location;", "radiusInMeters", "resultsLimit", "searchText", "newPostRequest", "graphObject", "Lorg/json/JSONObject;", "newPostRequestWithBundle", "parameters", "Landroid/os/Bundle;", "newUploadPhotoRequest", "image", "Landroid/graphics/Bitmap;", "caption", NativeProtocol.WEB_DIALOG_PARAMS, "photoUri", "Landroid/net/Uri;", "file", "Ljava/io/File;", "parameterToString", "processGraphObject", "", "serializer", "Lcom/facebook/GraphRequest$KeyValueSerializer;", "processGraphObjectProperty", SDKConstants.PARAM_KEY, "passByValue", "processRequest", "logger", "Lcom/facebook/internal/Logger;", "numRequests", "outputStream", "Ljava/io/OutputStream;", "shouldUseGzip", "runCallbacks", "responses", "runCallbacks$facebook_core_release", "serializeAttachments", "attachments", "", "Lcom/facebook/GraphRequest$Attachment;", "Lcom/facebook/GraphRequest$Serializer;", "serializeParameters", "bundle", "serializeRequestsAsJSON", "", "serializeToUrlConnection", "serializeToUrlConnection$facebook_core_release", "setConnectionContentType", "setDefaultBatchApplicationId", "toHttpConnection", "([Lcom/facebook/GraphRequest;)Ljava/net/HttpURLConnection;", "validateFieldsParamForGetRequests", "validateFieldsParamForGetRequests$facebook_core_release", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        public static void getTAG$facebook_core_release$annotations() {
        }

        private Companion() {
        }

        @JvmStatic
        public final String getDefaultBatchApplicationId() {
            return GraphRequest.defaultBatchApplicationId;
        }

        @JvmStatic
        public final void setDefaultBatchApplicationId(String applicationId) {
            GraphRequest.defaultBatchApplicationId = applicationId;
        }

        @JvmStatic
        public final GraphRequest newDeleteObjectRequest(AccessToken accessToken, String id, Callback callback) {
            return new GraphRequest(accessToken, id, null, HttpMethod.DELETE, callback, null, 32, null);
        }

        @JvmStatic
        public final GraphRequest newMeRequest(AccessToken accessToken, final GraphJSONObjectCallback callback) {
            return new GraphRequest(accessToken, "me", null, null, new Callback() {
                @Override
                public final void onCompleted(GraphResponse graphResponse) {
                    GraphRequest.Companion.m2372newMeRequest$lambda0(callback, graphResponse);
                }
            }, null, 32, null);
        }

        public static final void m2372newMeRequest$lambda0(GraphJSONObjectCallback graphJSONObjectCallback, GraphResponse graphResponse) {
            Intrinsics.checkNotNullParameter(graphResponse, "response");
            if (graphJSONObjectCallback == null) {
                return;
            }
            graphJSONObjectCallback.onCompleted(graphResponse.getGraphObject(), graphResponse);
        }

        @JvmStatic
        public final GraphRequest newPostRequest(AccessToken accessToken, String graphPath, JSONObject graphObject, Callback callback) {
            GraphRequest graphRequest = new GraphRequest(accessToken, graphPath, null, HttpMethod.POST, callback, null, 32, null);
            graphRequest.setGraphObject(graphObject);
            return graphRequest;
        }

        @JvmStatic
        public final GraphRequest newPostRequestWithBundle(AccessToken accessToken, String graphPath, Bundle parameters, Callback callback) {
            return new GraphRequest(accessToken, graphPath, parameters, HttpMethod.POST, callback, null, 32, null);
        }

        @JvmStatic
        public final GraphRequest newMyFriendsRequest(AccessToken accessToken, final GraphJSONArrayCallback callback) {
            return new GraphRequest(accessToken, GraphRequest.MY_FRIENDS, null, null, new Callback() {
                @Override
                public void onCompleted(GraphResponse response) {
                    Intrinsics.checkNotNullParameter(response, "response");
                    if (callback != null) {
                        JSONObject graphObject = response.getGraphObject();
                        callback.onCompleted(graphObject == null ? null : graphObject.optJSONArray("data"), response);
                    }
                }
            }, null, 32, null);
        }

        @JvmStatic
        public final GraphRequest newGraphPathRequest(AccessToken accessToken, String graphPath, Callback callback) {
            return new GraphRequest(accessToken, graphPath, null, null, callback, null, 32, null);
        }

        @JvmStatic
        public final GraphRequest newPlacesSearchRequest(AccessToken accessToken, Location location, int radiusInMeters, int resultsLimit, String searchText, final GraphJSONArrayCallback callback) {
            if (location == null) {
                Utility utility = Utility.INSTANCE;
                if (Utility.isNullOrEmpty(searchText)) {
                    throw new FacebookException("Either location or searchText must be specified.");
                }
            }
            Bundle bundle = new Bundle(5);
            bundle.putString("type", "place");
            bundle.putInt("limit", resultsLimit);
            if (location != null) {
                StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
                String str = String.format(Locale.US, "%f,%f", Arrays.copyOf(new Object[]{Double.valueOf(location.getLatitude()), Double.valueOf(location.getLongitude())}, 2));
                Intrinsics.checkNotNullExpressionValue(str, "java.lang.String.format(locale, format, *args)");
                bundle.putString("center", str);
                bundle.putInt("distance", radiusInMeters);
            }
            Utility utility2 = Utility.INSTANCE;
            if (!Utility.isNullOrEmpty(searchText)) {
                bundle.putString("q", searchText);
            }
            return new GraphRequest(accessToken, GraphRequest.SEARCH, bundle, HttpMethod.GET, new Callback() {
                @Override
                public final void onCompleted(GraphResponse graphResponse) {
                    GraphRequest.Companion.m2373newPlacesSearchRequest$lambda1(callback, graphResponse);
                }
            }, null, 32, null);
        }

        public static final void m2373newPlacesSearchRequest$lambda1(GraphJSONArrayCallback graphJSONArrayCallback, GraphResponse graphResponse) {
            Intrinsics.checkNotNullParameter(graphResponse, "response");
            if (graphJSONArrayCallback != null) {
                JSONObject graphObject = graphResponse.getGraphObject();
                graphJSONArrayCallback.onCompleted(graphObject == null ? null : graphObject.optJSONArray("data"), graphResponse);
            }
        }

        @JvmStatic
        public final GraphRequest newUploadPhotoRequest(AccessToken accessToken, String graphPath, Bitmap image, String caption, Bundle params, Callback callback) {
            Intrinsics.checkNotNullParameter(image, "image");
            Bundle bundle = new Bundle();
            if (params != null) {
                bundle.putAll(params);
            }
            bundle.putParcelable("picture", image);
            if (caption != null && caption.length() > 0) {
                bundle.putString("caption", caption);
            }
            return new GraphRequest(accessToken, getDefaultPhotoPathIfNull(graphPath), bundle, HttpMethod.POST, callback, null, 32, null);
        }

        @JvmStatic
        public final GraphRequest newUploadPhotoRequest(AccessToken accessToken, String graphPath, File file, String caption, Bundle params, Callback callback) throws FileNotFoundException {
            Intrinsics.checkNotNullParameter(file, "file");
            ParcelFileDescriptor parcelFileDescriptorOpen = ParcelFileDescriptor.open(file, 268435456);
            Bundle bundle = new Bundle();
            if (params != null) {
                bundle.putAll(params);
            }
            bundle.putParcelable("picture", parcelFileDescriptorOpen);
            if (caption != null && caption.length() > 0) {
                bundle.putString("caption", caption);
            }
            return new GraphRequest(accessToken, getDefaultPhotoPathIfNull(graphPath), bundle, HttpMethod.POST, callback, null, 32, null);
        }

        @JvmStatic
        public final GraphRequest newUploadPhotoRequest(AccessToken accessToken, String graphPath, Uri photoUri, String caption, Bundle params, Callback callback) throws FacebookException, FileNotFoundException {
            Intrinsics.checkNotNullParameter(photoUri, "photoUri");
            Utility utility = Utility.INSTANCE;
            if (Utility.isFileUri(photoUri)) {
                return newUploadPhotoRequest(accessToken, graphPath, new File(photoUri.getPath()), caption, params, callback);
            }
            Utility utility2 = Utility.INSTANCE;
            if (!Utility.isContentUri(photoUri)) {
                throw new FacebookException("The photo Uri must be either a file:// or content:// Uri");
            }
            Bundle bundle = new Bundle();
            if (params != null) {
                bundle.putAll(params);
            }
            bundle.putParcelable("picture", photoUri);
            if (caption != null && caption.length() > 0) {
                bundle.putString("caption", caption);
            }
            return new GraphRequest(accessToken, getDefaultPhotoPathIfNull(graphPath), bundle, HttpMethod.POST, callback, null, 32, null);
        }

        @JvmStatic
        public final GraphRequest newCustomAudienceThirdPartyIdRequest(AccessToken accessToken, Context context, String applicationId, Callback callback) {
            Intrinsics.checkNotNullParameter(context, "context");
            if (applicationId == null && accessToken != null) {
                applicationId = accessToken.getApplicationId();
            }
            if (applicationId == null) {
                Utility utility = Utility.INSTANCE;
                applicationId = Utility.getMetadataApplicationId(context);
            }
            if (applicationId == null) {
                throw new FacebookException("Facebook App ID cannot be determined");
            }
            String strStringPlus = Intrinsics.stringPlus(applicationId, "/custom_audience_third_party_id");
            AttributionIdentifiers attributionIdentifiers = AttributionIdentifiers.INSTANCE.getAttributionIdentifiers(context);
            Bundle bundle = new Bundle();
            if (accessToken == null) {
                if (attributionIdentifiers == null) {
                    throw new FacebookException("There is no access token and attribution identifiers could not be retrieved");
                }
                String attributionId = attributionIdentifiers.getAttributionId() != null ? attributionIdentifiers.getAttributionId() : attributionIdentifiers.getAndroidAdvertiserId();
                if (attributionId != null) {
                    bundle.putString("udid", attributionId);
                }
            }
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            if (FacebookSdk.getLimitEventAndDataUsage(context) || (attributionIdentifiers != null && attributionIdentifiers.getIsTrackingLimited())) {
                bundle.putString("limit_event_usage", "1");
            }
            return new GraphRequest(accessToken, strStringPlus, bundle, HttpMethod.GET, callback, null, 32, null);
        }

        @JvmStatic
        public final GraphRequest newCustomAudienceThirdPartyIdRequest(AccessToken accessToken, Context context, Callback callback) {
            Intrinsics.checkNotNullParameter(context, "context");
            return newCustomAudienceThirdPartyIdRequest(accessToken, context, null, callback);
        }

        @JvmStatic
        public final HttpURLConnection toHttpConnection(GraphRequest... requests) {
            Intrinsics.checkNotNullParameter(requests, "requests");
            return toHttpConnection(ArraysKt.toList(requests));
        }

        @JvmStatic
        public final HttpURLConnection toHttpConnection(Collection<GraphRequest> requests) {
            Intrinsics.checkNotNullParameter(requests, "requests");
            Validate validate = Validate.INSTANCE;
            Validate.notEmpty(requests, "requests");
            return toHttpConnection(new GraphRequestBatch(requests));
        }

        @JvmStatic
        public final HttpURLConnection toHttpConnection(GraphRequestBatch requests) throws Throwable {
            URL url;
            Intrinsics.checkNotNullParameter(requests, "requests");
            validateFieldsParamForGetRequests$facebook_core_release(requests);
            try {
                if (requests.size() == 1) {
                    url = new URL(requests.get(0).getUrlForSingleRequest());
                } else {
                    ServerProtocol serverProtocol = ServerProtocol.INSTANCE;
                    url = new URL(ServerProtocol.getGraphUrlBase());
                }
                HttpURLConnection httpURLConnectionCreateConnection = null;
                try {
                    httpURLConnectionCreateConnection = createConnection(url);
                    serializeToUrlConnection$facebook_core_release(requests, httpURLConnectionCreateConnection);
                    return httpURLConnectionCreateConnection;
                } catch (IOException e) {
                    Utility utility = Utility.INSTANCE;
                    Utility.disconnectQuietly(httpURLConnectionCreateConnection);
                    throw new FacebookException("could not construct request body", e);
                } catch (JSONException e2) {
                    Utility utility2 = Utility.INSTANCE;
                    Utility.disconnectQuietly(httpURLConnectionCreateConnection);
                    throw new FacebookException("could not construct request body", e2);
                }
            } catch (MalformedURLException e3) {
                throw new FacebookException("could not construct URL for request", e3);
            }
        }

        @JvmStatic
        public final GraphResponse executeAndWait(GraphRequest request) {
            Intrinsics.checkNotNullParameter(request, "request");
            List<GraphResponse> listExecuteBatchAndWait = executeBatchAndWait(request);
            if (listExecuteBatchAndWait.size() != 1) {
                throw new FacebookException("invalid state: expected a single response");
            }
            return listExecuteBatchAndWait.get(0);
        }

        @JvmStatic
        public final List<GraphResponse> executeBatchAndWait(GraphRequest... requests) {
            Intrinsics.checkNotNullParameter(requests, "requests");
            return executeBatchAndWait(ArraysKt.toList(requests));
        }

        @JvmStatic
        public final List<GraphResponse> executeBatchAndWait(Collection<GraphRequest> requests) {
            Intrinsics.checkNotNullParameter(requests, "requests");
            return executeBatchAndWait(new GraphRequestBatch(requests));
        }

        @JvmStatic
        public final List<GraphResponse> executeBatchAndWait(GraphRequestBatch requests) throws Throwable {
            Exception exc;
            ?? httpConnection;
            List<GraphResponse> listExecuteConnectionAndWait;
            Intrinsics.checkNotNullParameter(requests, "requests");
            Validate validate = Validate.INSTANCE;
            Validate.notEmptyAndContainsNoNulls(requests, "requests");
            ?? r0 = 0;
            try {
                try {
                    exc = null;
                    httpConnection = toHttpConnection(requests);
                } catch (Exception e) {
                    exc = e;
                    httpConnection = 0;
                }
                try {
                    if (httpConnection != 0) {
                        listExecuteConnectionAndWait = executeConnectionAndWait(httpConnection, requests);
                    } else {
                        List<GraphResponse> listConstructErrorResponses = GraphResponse.INSTANCE.constructErrorResponses(requests.getRequests(), null, new FacebookException(exc));
                        runCallbacks$facebook_core_release(requests, listConstructErrorResponses);
                        listExecuteConnectionAndWait = listConstructErrorResponses;
                    }
                    Utility utility = Utility.INSTANCE;
                    httpConnection = (URLConnection) httpConnection;
                    Utility.disconnectQuietly(httpConnection);
                    return listExecuteConnectionAndWait;
                } catch (Throwable th) {
                    th = th;
                    r0 = httpConnection;
                    Utility utility2 = Utility.INSTANCE;
                    Utility.disconnectQuietly((URLConnection) r0);
                    throw th;
                }
            } catch (Throwable th2) {
                th = th2;
                Utility utility3 = Utility.INSTANCE;
                Utility.disconnectQuietly((URLConnection) r0);
                throw th;
            }
        }

        @JvmStatic
        public final GraphRequestAsyncTask executeBatchAsync(GraphRequest... requests) {
            Intrinsics.checkNotNullParameter(requests, "requests");
            return executeBatchAsync(ArraysKt.toList(requests));
        }

        @JvmStatic
        public final GraphRequestAsyncTask executeBatchAsync(Collection<GraphRequest> requests) {
            Intrinsics.checkNotNullParameter(requests, "requests");
            return executeBatchAsync(new GraphRequestBatch(requests));
        }

        @JvmStatic
        public final GraphRequestAsyncTask executeBatchAsync(GraphRequestBatch requests) {
            Intrinsics.checkNotNullParameter(requests, "requests");
            Validate validate = Validate.INSTANCE;
            Validate.notEmptyAndContainsNoNulls(requests, "requests");
            GraphRequestAsyncTask graphRequestAsyncTask = new GraphRequestAsyncTask(requests);
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            graphRequestAsyncTask.executeOnExecutor(FacebookSdk.getExecutor(), new Void[0]);
            return graphRequestAsyncTask;
        }

        @JvmStatic
        public final List<GraphResponse> executeConnectionAndWait(HttpURLConnection connection, Collection<GraphRequest> requests) {
            Intrinsics.checkNotNullParameter(connection, "connection");
            Intrinsics.checkNotNullParameter(requests, "requests");
            return executeConnectionAndWait(connection, new GraphRequestBatch(requests));
        }

        @JvmStatic
        public final List<GraphResponse> executeConnectionAndWait(HttpURLConnection connection, GraphRequestBatch requests) {
            Intrinsics.checkNotNullParameter(connection, "connection");
            Intrinsics.checkNotNullParameter(requests, "requests");
            List<GraphResponse> listFromHttpConnection$facebook_core_release = GraphResponse.INSTANCE.fromHttpConnection$facebook_core_release(connection, requests);
            Utility utility = Utility.INSTANCE;
            Utility.disconnectQuietly(connection);
            int size = requests.size();
            if (size != listFromHttpConnection$facebook_core_release.size()) {
                StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
                String str = String.format(Locale.US, "Received %d responses while expecting %d", Arrays.copyOf(new Object[]{Integer.valueOf(listFromHttpConnection$facebook_core_release.size()), Integer.valueOf(size)}, 2));
                Intrinsics.checkNotNullExpressionValue(str, "java.lang.String.format(locale, format, *args)");
                throw new FacebookException(str);
            }
            runCallbacks$facebook_core_release(requests, listFromHttpConnection$facebook_core_release);
            AccessTokenManager.INSTANCE.getInstance().extendAccessTokenIfNeeded();
            return listFromHttpConnection$facebook_core_release;
        }

        @JvmStatic
        public final GraphRequestAsyncTask executeConnectionAsync(HttpURLConnection connection, GraphRequestBatch requests) {
            Intrinsics.checkNotNullParameter(connection, "connection");
            Intrinsics.checkNotNullParameter(requests, "requests");
            return executeConnectionAsync(null, connection, requests);
        }

        @JvmStatic
        public final GraphRequestAsyncTask executeConnectionAsync(Handler callbackHandler, HttpURLConnection connection, GraphRequestBatch requests) {
            Intrinsics.checkNotNullParameter(connection, "connection");
            Intrinsics.checkNotNullParameter(requests, "requests");
            GraphRequestAsyncTask graphRequestAsyncTask = new GraphRequestAsyncTask(connection, requests);
            requests.setCallbackHandler(callbackHandler);
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            graphRequestAsyncTask.executeOnExecutor(FacebookSdk.getExecutor(), new Void[0]);
            return graphRequestAsyncTask;
        }

        @JvmStatic
        public final void runCallbacks$facebook_core_release(final GraphRequestBatch requests, List<GraphResponse> responses) {
            Intrinsics.checkNotNullParameter(requests, "requests");
            Intrinsics.checkNotNullParameter(responses, "responses");
            int size = requests.size();
            final ArrayList arrayList = new ArrayList();
            if (size > 0) {
                int i = 0;
                while (true) {
                    int i2 = i + 1;
                    GraphRequest graphRequest = requests.get(i);
                    if (graphRequest.getCallback() != null) {
                        arrayList.add(new Pair(graphRequest.getCallback(), responses.get(i)));
                    }
                    if (i2 >= size) {
                        break;
                    } else {
                        i = i2;
                    }
                }
            }
            if (arrayList.size() > 0) {
                Runnable runnable = new Runnable() {
                    @Override
                    public final void run() {
                        GraphRequest.Companion.m2374runCallbacks$lambda2(arrayList, requests);
                    }
                };
                Handler callbackHandler = requests.getCallbackHandler();
                if ((callbackHandler == null ? null : Boolean.valueOf(callbackHandler.post(runnable))) == null) {
                    runnable.run();
                }
            }
        }

        public static final void m2374runCallbacks$lambda2(ArrayList arrayList, GraphRequestBatch graphRequestBatch) {
            Intrinsics.checkNotNullParameter(arrayList, "$callbacks");
            Intrinsics.checkNotNullParameter(graphRequestBatch, "$requests");
            Iterator it = arrayList.iterator();
            while (it.hasNext()) {
                Pair pair = (Pair) it.next();
                Callback callback = (Callback) pair.first;
                Object obj = pair.second;
                Intrinsics.checkNotNullExpressionValue(obj, "pair.second");
                callback.onCompleted((GraphResponse) obj);
            }
            Iterator<GraphRequestBatch.Callback> it2 = graphRequestBatch.getCallbacks().iterator();
            while (it2.hasNext()) {
                it2.next().onBatchCompleted(graphRequestBatch);
            }
        }

        private final String getDefaultPhotoPathIfNull(String graphPath) {
            return graphPath == null ? GraphRequest.MY_PHOTOS : graphPath;
        }

        private final HttpURLConnection createConnection(URL url) throws IOException {
            URLConnection uRLConnectionOpenConnection = url.openConnection();
            if (uRLConnectionOpenConnection == null) {
                throw new NullPointerException("null cannot be cast to non-null type java.net.HttpURLConnection");
            }
            HttpURLConnection httpURLConnection = (HttpURLConnection) uRLConnectionOpenConnection;
            httpURLConnection.setRequestProperty(GraphRequest.USER_AGENT_HEADER, getUserAgent());
            httpURLConnection.setRequestProperty(GraphRequest.ACCEPT_LANGUAGE_HEADER, Locale.getDefault().toString());
            httpURLConnection.setChunkedStreamingMode(0);
            return httpURLConnection;
        }

        private final boolean hasOnProgressCallbacks(GraphRequestBatch requests) {
            Iterator<GraphRequestBatch.Callback> it = requests.getCallbacks().iterator();
            while (it.hasNext()) {
                if (it.next() instanceof GraphRequestBatch.OnProgressCallback) {
                    return true;
                }
            }
            Iterator<GraphRequest> it2 = requests.iterator();
            while (it2.hasNext()) {
                if (it2.next().getCallback() instanceof OnProgressCallback) {
                    return true;
                }
            }
            return false;
        }

        private final void setConnectionContentType(HttpURLConnection connection, boolean shouldUseGzip) {
            if (shouldUseGzip) {
                connection.setRequestProperty(GraphRequest.CONTENT_TYPE_HEADER, "application/x-www-form-urlencoded");
                connection.setRequestProperty(GraphRequest.CONTENT_ENCODING_HEADER, "gzip");
            } else {
                connection.setRequestProperty(GraphRequest.CONTENT_TYPE_HEADER, getMimeContentType());
            }
        }

        private final boolean isGzipCompressible(GraphRequestBatch requests) {
            for (GraphRequest graphRequest : requests) {
                Iterator<String> it = graphRequest.getParameters().keySet().iterator();
                while (it.hasNext()) {
                    if (isSupportedAttachmentType(graphRequest.getParameters().get(it.next()))) {
                        return false;
                    }
                }
            }
            return true;
        }

        @JvmStatic
        public final void validateFieldsParamForGetRequests$facebook_core_release(GraphRequestBatch requests) {
            Intrinsics.checkNotNullParameter(requests, "requests");
            for (GraphRequest graphRequest : requests) {
                if (HttpMethod.GET == graphRequest.getHttpMethod()) {
                    Utility utility = Utility.INSTANCE;
                    if (Utility.isNullOrEmpty(graphRequest.getParameters().getString(GraphRequest.FIELDS_PARAM))) {
                        Logger.Companion companion = Logger.INSTANCE;
                        LoggingBehavior loggingBehavior = LoggingBehavior.DEVELOPER_ERRORS;
                        StringBuilder sb = new StringBuilder("GET requests for /");
                        String graphPath = graphRequest.getGraphPath();
                        if (graphPath == null) {
                            graphPath = "";
                        }
                        sb.append(graphPath);
                        sb.append(" should contain an explicit \"fields\" parameter.");
                        companion.log(loggingBehavior, 5, "Request", sb.toString());
                    }
                }
            }
        }

        @JvmStatic
        public final void serializeToUrlConnection$facebook_core_release(GraphRequestBatch requests, HttpURLConnection connection) throws Throwable {
            ProgressOutputStream progressOutputStream;
            Intrinsics.checkNotNullParameter(requests, "requests");
            Intrinsics.checkNotNullParameter(connection, "connection");
            Logger logger = new Logger(LoggingBehavior.REQUESTS, "Request");
            int size = requests.size();
            boolean zIsGzipCompressible = isGzipCompressible(requests);
            OutputStream gZIPOutputStream = null;
            HttpMethod httpMethod = size == 1 ? requests.get(0).getHttpMethod() : null;
            if (httpMethod == null) {
                httpMethod = HttpMethod.POST;
            }
            connection.setRequestMethod(httpMethod.name());
            setConnectionContentType(connection, zIsGzipCompressible);
            URL url = connection.getURL();
            logger.append("Request:\n");
            logger.appendKeyValue("Id", requests.getId());
            Intrinsics.checkNotNullExpressionValue(url, "url");
            logger.appendKeyValue("URL", url);
            String requestMethod = connection.getRequestMethod();
            Intrinsics.checkNotNullExpressionValue(requestMethod, "connection.requestMethod");
            logger.appendKeyValue("Method", requestMethod);
            String requestProperty = connection.getRequestProperty(GraphRequest.USER_AGENT_HEADER);
            Intrinsics.checkNotNullExpressionValue(requestProperty, "connection.getRequestProperty(\"User-Agent\")");
            logger.appendKeyValue(GraphRequest.USER_AGENT_HEADER, requestProperty);
            String requestProperty2 = connection.getRequestProperty(GraphRequest.CONTENT_TYPE_HEADER);
            Intrinsics.checkNotNullExpressionValue(requestProperty2, "connection.getRequestProperty(\"Content-Type\")");
            logger.appendKeyValue(GraphRequest.CONTENT_TYPE_HEADER, requestProperty2);
            connection.setConnectTimeout(requests.getTimeoutInMilliseconds());
            connection.setReadTimeout(requests.getTimeoutInMilliseconds());
            if (httpMethod != HttpMethod.POST) {
                logger.log();
                return;
            }
            connection.setDoOutput(true);
            try {
                BufferedOutputStream bufferedOutputStream = new BufferedOutputStream(connection.getOutputStream());
                if (zIsGzipCompressible) {
                    try {
                        gZIPOutputStream = new GZIPOutputStream(bufferedOutputStream);
                    } catch (Throwable th) {
                        th = th;
                        gZIPOutputStream = bufferedOutputStream;
                        if (gZIPOutputStream != null) {
                            gZIPOutputStream.close();
                        }
                        throw th;
                    }
                } else {
                    gZIPOutputStream = bufferedOutputStream;
                }
                if (hasOnProgressCallbacks(requests)) {
                    ProgressNoopOutputStream progressNoopOutputStream = new ProgressNoopOutputStream(requests.getCallbackHandler());
                    processRequest(requests, null, size, url, progressNoopOutputStream, zIsGzipCompressible);
                    progressOutputStream = new ProgressOutputStream(gZIPOutputStream, requests, progressNoopOutputStream.getProgressMap(), progressNoopOutputStream.getMaxProgress());
                } else {
                    progressOutputStream = gZIPOutputStream;
                }
                try {
                    processRequest(requests, logger, size, url, progressOutputStream, zIsGzipCompressible);
                    progressOutputStream.close();
                    logger.log();
                } catch (Throwable th2) {
                    th = th2;
                    gZIPOutputStream = progressOutputStream;
                    if (gZIPOutputStream != null) {
                        gZIPOutputStream.close();
                    }
                    throw th;
                }
            } catch (Throwable th3) {
                th = th3;
            }
        }

        private final void processRequest(GraphRequestBatch requests, Logger logger, int numRequests, URL url, OutputStream outputStream, boolean shouldUseGzip) throws Throwable {
            Serializer serializer = new Serializer(outputStream, logger, shouldUseGzip);
            if (numRequests == 1) {
                GraphRequest graphRequest = requests.get(0);
                HashMap map = new HashMap();
                for (String str : graphRequest.getParameters().keySet()) {
                    Object obj = graphRequest.getParameters().get(str);
                    if (isSupportedAttachmentType(obj)) {
                        Intrinsics.checkNotNullExpressionValue(str, SDKConstants.PARAM_KEY);
                        map.put(str, new Attachment(graphRequest, obj));
                    }
                }
                if (logger != null) {
                    logger.append("  Parameters:\n");
                }
                serializeParameters(graphRequest.getParameters(), serializer, graphRequest);
                if (logger != null) {
                    logger.append("  Attachments:\n");
                }
                serializeAttachments(map, serializer);
                JSONObject graphObject = graphRequest.getGraphObject();
                if (graphObject != null) {
                    String path = url.getPath();
                    Intrinsics.checkNotNullExpressionValue(path, "url.path");
                    processGraphObject(graphObject, path, serializer);
                    return;
                }
                return;
            }
            String batchAppId = getBatchAppId(requests);
            if (batchAppId.length() == 0) {
                throw new FacebookException("App ID was not specified at the request or Settings.");
            }
            serializer.writeString(GraphRequest.BATCH_APP_ID_PARAM, batchAppId);
            HashMap map2 = new HashMap();
            serializeRequestsAsJSON(serializer, requests, map2);
            if (logger != null) {
                logger.append("  Attachments:\n");
            }
            serializeAttachments(map2, serializer);
        }

        private final boolean isMeRequest(String path) {
            Matcher matcher = GraphRequest.versionPattern.matcher(path);
            if (matcher.matches()) {
                path = matcher.group(1);
                Intrinsics.checkNotNullExpressionValue(path, "matcher.group(1)");
            }
            return StringsKt.startsWith$default(path, "me/", false, 2, (Object) null) || StringsKt.startsWith$default(path, "/me/", false, 2, (Object) null);
        }

        public final void processGraphObject(JSONObject graphObject, String path, KeyValueSerializer serializer) {
            boolean z;
            if (isMeRequest(path)) {
                String str = path;
                int iIndexOf$default = StringsKt.indexOf$default(str, CertificateUtil.DELIMITER, 0, false, 6, (Object) null);
                int iIndexOf$default2 = StringsKt.indexOf$default(str, "?", 0, false, 6, (Object) null);
                if (iIndexOf$default <= 3 || (iIndexOf$default2 != -1 && iIndexOf$default >= iIndexOf$default2)) {
                    z = false;
                } else {
                    z = true;
                }
            } else {
                z = false;
            }
            Iterator<String> itKeys = graphObject.keys();
            while (itKeys.hasNext()) {
                String next = itKeys.next();
                Object objOpt = graphObject.opt(next);
                boolean z2 = z && StringsKt.equals(next, "image", true);
                Intrinsics.checkNotNullExpressionValue(next, SDKConstants.PARAM_KEY);
                Intrinsics.checkNotNullExpressionValue(objOpt, SDKConstants.PARAM_VALUE);
                processGraphObjectProperty(next, objOpt, serializer, z2);
            }
        }

        private final void processGraphObjectProperty(String key, Object value, KeyValueSerializer serializer, boolean passByValue) {
            Class<?> cls = value.getClass();
            if (JSONObject.class.isAssignableFrom(cls)) {
                JSONObject jSONObject = (JSONObject) value;
                if (passByValue) {
                    Iterator<String> itKeys = jSONObject.keys();
                    while (itKeys.hasNext()) {
                        String next = itKeys.next();
                        StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
                        String str = String.format("%s[%s]", Arrays.copyOf(new Object[]{key, next}, 2));
                        Intrinsics.checkNotNullExpressionValue(str, "java.lang.String.format(format, *args)");
                        Object objOpt = jSONObject.opt(next);
                        Intrinsics.checkNotNullExpressionValue(objOpt, "jsonObject.opt(propertyName)");
                        processGraphObjectProperty(str, objOpt, serializer, passByValue);
                    }
                    return;
                }
                if (jSONObject.has("id")) {
                    String strOptString = jSONObject.optString("id");
                    Intrinsics.checkNotNullExpressionValue(strOptString, "jsonObject.optString(\"id\")");
                    processGraphObjectProperty(key, strOptString, serializer, passByValue);
                    return;
                } else if (jSONObject.has("url")) {
                    String strOptString2 = jSONObject.optString("url");
                    Intrinsics.checkNotNullExpressionValue(strOptString2, "jsonObject.optString(\"url\")");
                    processGraphObjectProperty(key, strOptString2, serializer, passByValue);
                    return;
                } else {
                    if (jSONObject.has(NativeProtocol.OPEN_GRAPH_CREATE_OBJECT_KEY)) {
                        String string = jSONObject.toString();
                        Intrinsics.checkNotNullExpressionValue(string, "jsonObject.toString()");
                        processGraphObjectProperty(key, string, serializer, passByValue);
                        return;
                    }
                    return;
                }
            }
            if (JSONArray.class.isAssignableFrom(cls)) {
                JSONArray jSONArray = (JSONArray) value;
                int length = jSONArray.length();
                if (length <= 0) {
                    return;
                }
                int i = 0;
                while (true) {
                    int i2 = i + 1;
                    StringCompanionObject stringCompanionObject2 = StringCompanionObject.INSTANCE;
                    String str2 = String.format(Locale.ROOT, "%s[%d]", Arrays.copyOf(new Object[]{key, Integer.valueOf(i)}, 2));
                    Intrinsics.checkNotNullExpressionValue(str2, "java.lang.String.format(locale, format, *args)");
                    Object objOpt2 = jSONArray.opt(i);
                    Intrinsics.checkNotNullExpressionValue(objOpt2, "jsonArray.opt(i)");
                    processGraphObjectProperty(str2, objOpt2, serializer, passByValue);
                    if (i2 >= length) {
                        return;
                    } else {
                        i = i2;
                    }
                }
            } else {
                if (String.class.isAssignableFrom(cls) || Number.class.isAssignableFrom(cls) || Boolean.class.isAssignableFrom(cls)) {
                    serializer.writeString(key, value.toString());
                    return;
                }
                if (Date.class.isAssignableFrom(cls)) {
                    String str3 = new SimpleDateFormat(GraphRequest.ISO_8601_FORMAT_STRING, Locale.US).format((Date) value);
                    Intrinsics.checkNotNullExpressionValue(str3, "iso8601DateFormat.format(date)");
                    serializer.writeString(key, str3);
                } else {
                    Utility utility = Utility.INSTANCE;
                    Utility.logd(GraphRequest.TAG, "The type of property " + key + " in the graph object is unknown. It won't be sent in the request.");
                }
            }
        }

        private final void serializeParameters(Bundle bundle, Serializer serializer, GraphRequest request) throws Throwable {
            for (String str : bundle.keySet()) {
                Object obj = bundle.get(str);
                if (isSupportedParameterType(obj)) {
                    Intrinsics.checkNotNullExpressionValue(str, SDKConstants.PARAM_KEY);
                    serializer.writeObject(str, obj, request);
                }
            }
        }

        private final void serializeRequestsAsJSON(Serializer serializer, Collection<GraphRequest> requests, Map<String, Attachment> attachments) throws JSONException, IOException {
            JSONArray jSONArray = new JSONArray();
            Iterator<GraphRequest> it = requests.iterator();
            while (it.hasNext()) {
                it.next().serializeToBatch(jSONArray, attachments);
            }
            serializer.writeRequestsAsJson(GraphRequest.BATCH_PARAM, jSONArray, requests);
        }

        private final String getMimeContentType() {
            StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
            String str = String.format("multipart/form-data; boundary=%s", Arrays.copyOf(new Object[]{GraphRequest.MIME_BOUNDARY}, 1));
            Intrinsics.checkNotNullExpressionValue(str, "java.lang.String.format(format, *args)");
            return str;
        }

        private final String getUserAgent() {
            if (GraphRequest.userAgent == null) {
                StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
                String str = String.format("%s.%s", Arrays.copyOf(new Object[]{GraphRequest.USER_AGENT_BASE, FacebookSdkVersion.BUILD}, 2));
                Intrinsics.checkNotNullExpressionValue(str, "java.lang.String.format(format, *args)");
                GraphRequest.userAgent = str;
                InternalSettings internalSettings = InternalSettings.INSTANCE;
                String customUserAgent = InternalSettings.getCustomUserAgent();
                Utility utility = Utility.INSTANCE;
                if (!Utility.isNullOrEmpty(customUserAgent)) {
                    StringCompanionObject stringCompanionObject2 = StringCompanionObject.INSTANCE;
                    String str2 = String.format(Locale.ROOT, "%s/%s", Arrays.copyOf(new Object[]{GraphRequest.userAgent, customUserAgent}, 2));
                    Intrinsics.checkNotNullExpressionValue(str2, "java.lang.String.format(locale, format, *args)");
                    GraphRequest.userAgent = str2;
                }
            }
            return GraphRequest.userAgent;
        }

        private final String getBatchAppId(GraphRequestBatch batch) {
            String batchApplicationId = batch.getBatchApplicationId();
            if (batchApplicationId != null && !batch.isEmpty()) {
                return batchApplicationId;
            }
            Iterator<GraphRequest> it = batch.iterator();
            while (it.hasNext()) {
                AccessToken accessToken = it.next().getAccessToken();
                if (accessToken != null) {
                    return accessToken.getApplicationId();
                }
            }
            String str = GraphRequest.defaultBatchApplicationId;
            if (str != null && str.length() > 0) {
                return str;
            }
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            return FacebookSdk.getApplicationId();
        }

        public final boolean isSupportedAttachmentType(Object value) {
            return (value instanceof Bitmap) || (value instanceof byte[]) || (value instanceof Uri) || (value instanceof ParcelFileDescriptor) || (value instanceof ParcelableResourceWithMimeType);
        }

        public final boolean isSupportedParameterType(Object value) {
            return (value instanceof String) || (value instanceof Boolean) || (value instanceof Number) || (value instanceof Date);
        }

        public final String parameterToString(Object value) {
            if (value instanceof String) {
                return (String) value;
            }
            if ((value instanceof Boolean) || (value instanceof Number)) {
                return value.toString();
            }
            if (value instanceof Date) {
                String str = new SimpleDateFormat(GraphRequest.ISO_8601_FORMAT_STRING, Locale.US).format((Date) value);
                Intrinsics.checkNotNullExpressionValue(str, "iso8601DateFormat.format(value)");
                return str;
            }
            throw new IllegalArgumentException("Unsupported parameter type.");
        }

        private final void serializeAttachments(Map<String, Attachment> attachments, Serializer serializer) throws Throwable {
            for (Map.Entry<String, Attachment> entry : attachments.entrySet()) {
                if (GraphRequest.INSTANCE.isSupportedAttachmentType(entry.getValue().getValue())) {
                    serializer.writeObject(entry.getKey(), entry.getValue().getValue(), entry.getValue().getRequest());
                }
            }
        }
    }

    static {
        char[] charArray = "-_1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".toCharArray();
        Intrinsics.checkNotNullExpressionValue(charArray, "(this as java.lang.String).toCharArray()");
        StringBuilder sb = new StringBuilder();
        SecureRandom secureRandom = new SecureRandom();
        int iNextInt = secureRandom.nextInt(11) + 30;
        if (iNextInt > 0) {
            int i = 0;
            do {
                i++;
                sb.append(charArray[secureRandom.nextInt(charArray.length)]);
            } while (i < iNextInt);
        }
        String string = sb.toString();
        Intrinsics.checkNotNullExpressionValue(string, "buffer.toString()");
        MIME_BOUNDARY = string;
        versionPattern = Pattern.compile("^/?v\\d+\\.\\d+/(.*)");
    }

    public GraphRequest(AccessToken accessToken, String str, Bundle bundle, HttpMethod httpMethod, Callback callback, String str2, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? null : accessToken, (i & 2) != 0 ? null : str, (i & 4) != 0 ? null : bundle, (i & 8) != 0 ? null : httpMethod, (i & 16) != 0 ? null : callback, (i & 32) != 0 ? null : str2);
    }

    public GraphRequest(AccessToken accessToken, String str, Bundle bundle, HttpMethod httpMethod, Callback callback, String str2) {
        this.batchEntryOmitResultOnSuccess = true;
        this.accessToken = accessToken;
        this.graphPath = str;
        this.version = str2;
        setCallback(callback);
        setHttpMethod(httpMethod);
        if (bundle != null) {
            this.parameters = new Bundle(bundle);
        } else {
            this.parameters = new Bundle();
        }
        if (this.version == null) {
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            this.version = FacebookSdk.getGraphApiVersion();
        }
    }

    public GraphRequest(AccessToken accessToken, URL url) {
        Intrinsics.checkNotNullParameter(url, "overriddenURL");
        this.batchEntryOmitResultOnSuccess = true;
        this.accessToken = accessToken;
        this.overriddenURL = url.toString();
        setHttpMethod(HttpMethod.GET);
        this.parameters = new Bundle();
    }

    public final void setForceApplicationRequest(boolean forceOverride) {
        this.forceApplicationRequest = forceOverride;
    }

    public final GraphResponse executeAndWait() {
        return INSTANCE.executeAndWait(this);
    }

    public final GraphRequestAsyncTask executeAsync() {
        return INSTANCE.executeBatchAsync(this);
    }

    public String toString() {
        StringBuilder sb = new StringBuilder("{Request:  accessToken: ");
        Object obj = this.accessToken;
        if (obj == null) {
            obj = "null";
        }
        sb.append(obj);
        sb.append(", graphPath: ");
        sb.append(this.graphPath);
        sb.append(", graphObject: ");
        sb.append(this.graphObject);
        sb.append(", httpMethod: ");
        sb.append(this.httpMethod);
        sb.append(", parameters: ");
        sb.append(this.parameters);
        sb.append("}");
        String string = sb.toString();
        Intrinsics.checkNotNullExpressionValue(string, "StringBuilder()\n        .append(\"{Request: \")\n        .append(\" accessToken: \")\n        .append(if (accessToken == null) \"null\" else accessToken)\n        .append(\", graphPath: \")\n        .append(graphPath)\n        .append(\", graphObject: \")\n        .append(graphObject)\n        .append(\", httpMethod: \")\n        .append(httpMethod)\n        .append(\", parameters: \")\n        .append(parameters)\n        .append(\"}\")\n        .toString()");
        return string;
    }

    private final void addCommonParameters() {
        Bundle bundle = this.parameters;
        if (shouldForceClientTokenForRequest()) {
            bundle.putString("access_token", getClientTokenForRequest());
        } else {
            String accessTokenToUseForRequest = getAccessTokenToUseForRequest();
            if (accessTokenToUseForRequest != null) {
                bundle.putString("access_token", accessTokenToUseForRequest);
            }
        }
        if (!bundle.containsKey("access_token")) {
            Utility utility = Utility.INSTANCE;
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            if (Utility.isNullOrEmpty(FacebookSdk.getClientToken())) {
                Log.w(TAG, "Starting with v13 of the SDK, a client token must be embedded in your client code before making Graph API calls. Visit https://developers.facebook.com/docs/android/getting-started#client-token to learn how to implement this change.");
            }
        }
        bundle.putString("sdk", "android");
        bundle.putString(FORMAT_PARAM, FORMAT_JSON);
        FacebookSdk facebookSdk2 = FacebookSdk.INSTANCE;
        if (FacebookSdk.isLoggingBehaviorEnabled(LoggingBehavior.GRAPH_API_DEBUG_INFO)) {
            bundle.putString(DEBUG_PARAM, DEBUG_SEVERITY_INFO);
            return;
        }
        FacebookSdk facebookSdk3 = FacebookSdk.INSTANCE;
        if (FacebookSdk.isLoggingBehaviorEnabled(LoggingBehavior.GRAPH_API_DEBUG_WARNING)) {
            bundle.putString(DEBUG_PARAM, DEBUG_SEVERITY_WARNING);
        }
    }

    private final String getAccessTokenToUseForRequest() {
        AccessToken accessToken = this.accessToken;
        if (accessToken != null) {
            if (!this.parameters.containsKey("access_token")) {
                String token = accessToken.getToken();
                Logger.INSTANCE.registerAccessToken(token);
                return token;
            }
        } else if (!this.parameters.containsKey("access_token")) {
            return getClientTokenForRequest();
        }
        return this.parameters.getString("access_token");
    }

    private final String getClientTokenForRequest() {
        FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
        String applicationId = FacebookSdk.getApplicationId();
        FacebookSdk facebookSdk2 = FacebookSdk.INSTANCE;
        String clientToken = FacebookSdk.getClientToken();
        if (applicationId.length() > 0 && clientToken.length() > 0) {
            return applicationId + '|' + clientToken;
        }
        Utility utility = Utility.INSTANCE;
        Utility.logd(TAG, "Warning: Request without access token missing application ID or client token.");
        return null;
    }

    private final String appendParametersToBaseUrl(String baseUrl, boolean isBatch) {
        if (!isBatch && this.httpMethod == HttpMethod.POST) {
            return baseUrl;
        }
        Uri.Builder builderBuildUpon = Uri.parse(baseUrl).buildUpon();
        for (String str : this.parameters.keySet()) {
            Object obj = this.parameters.get(str);
            if (obj == null) {
                obj = "";
            }
            Companion companion = INSTANCE;
            if (!companion.isSupportedParameterType(obj)) {
                if (this.httpMethod != HttpMethod.GET) {
                    StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
                    String str2 = String.format(Locale.US, "Unsupported parameter type for GET request: %s", Arrays.copyOf(new Object[]{obj.getClass().getSimpleName()}, 1));
                    Intrinsics.checkNotNullExpressionValue(str2, "java.lang.String.format(locale, format, *args)");
                    throw new IllegalArgumentException(str2);
                }
            } else {
                builderBuildUpon.appendQueryParameter(str, companion.parameterToString(obj).toString());
            }
        }
        String string = builderBuildUpon.toString();
        Intrinsics.checkNotNullExpressionValue(string, "uriBuilder.toString()");
        return string;
    }

    public final String getRelativeUrlForBatchedRequest() {
        if (this.overriddenURL != null) {
            throw new FacebookException("Can't override URL for a batch request");
        }
        ServerProtocol serverProtocol = ServerProtocol.INSTANCE;
        String urlWithGraphPath = getUrlWithGraphPath(ServerProtocol.getGraphUrlBase());
        addCommonParameters();
        Uri uri = Uri.parse(appendParametersToBaseUrl(urlWithGraphPath, true));
        StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
        String str = String.format("%s?%s", Arrays.copyOf(new Object[]{uri.getPath(), uri.getQuery()}, 2));
        Intrinsics.checkNotNullExpressionValue(str, "java.lang.String.format(format, *args)");
        return str;
    }

    public final String getUrlForSingleRequest() {
        String graphUrlBaseForSubdomain;
        String str = this.overriddenURL;
        if (str != null) {
            return String.valueOf(str);
        }
        String str2 = this.graphPath;
        if (this.httpMethod == HttpMethod.POST && str2 != null && StringsKt.endsWith$default(str2, VIDEOS_SUFFIX, false, 2, (Object) null)) {
            ServerProtocol serverProtocol = ServerProtocol.INSTANCE;
            graphUrlBaseForSubdomain = ServerProtocol.getGraphVideoUrlBase();
        } else {
            ServerProtocol serverProtocol2 = ServerProtocol.INSTANCE;
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            graphUrlBaseForSubdomain = ServerProtocol.getGraphUrlBaseForSubdomain(FacebookSdk.getGraphDomain());
        }
        String urlWithGraphPath = getUrlWithGraphPath(graphUrlBaseForSubdomain);
        addCommonParameters();
        return appendParametersToBaseUrl(urlWithGraphPath, false);
    }

    private final String getGraphPathWithVersion() {
        if (versionPattern.matcher(this.graphPath).matches()) {
            return this.graphPath;
        }
        StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
        String str = String.format("%s/%s", Arrays.copyOf(new Object[]{this.version, this.graphPath}, 2));
        Intrinsics.checkNotNullExpressionValue(str, "java.lang.String.format(format, *args)");
        return str;
    }

    private final String getUrlWithGraphPath(String baseUrl) {
        if (!isValidGraphRequestForDomain()) {
            ServerProtocol serverProtocol = ServerProtocol.INSTANCE;
            baseUrl = ServerProtocol.getFacebookGraphUrlBase();
        }
        StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
        String str = String.format("%s/%s", Arrays.copyOf(new Object[]{baseUrl, getGraphPathWithVersion()}, 2));
        Intrinsics.checkNotNullExpressionValue(str, "java.lang.String.format(format, *args)");
        return str;
    }

    private final boolean shouldForceClientTokenForRequest() {
        String accessTokenToUseForRequest = getAccessTokenToUseForRequest();
        boolean zContains$default = accessTokenToUseForRequest == null ? false : StringsKt.contains$default(accessTokenToUseForRequest, "|", false, 2, (Object) null);
        if (accessTokenToUseForRequest == null || !StringsKt.startsWith$default(accessTokenToUseForRequest, "IG", false, 2, (Object) null) || zContains$default || !isApplicationRequest()) {
            return (isValidGraphRequestForDomain() || zContains$default) ? false : true;
        }
        return true;
    }

    private final boolean isValidGraphRequestForDomain() {
        FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
        if (Intrinsics.areEqual(FacebookSdk.getGraphDomain(), FacebookSdk.INSTAGRAM_COM)) {
            return !isApplicationRequest();
        }
        return true;
    }

    private final boolean isApplicationRequest() {
        if (this.graphPath == null) {
            return false;
        }
        StringBuilder sb = new StringBuilder("^/?");
        FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
        sb.append(FacebookSdk.getApplicationId());
        sb.append("/?.*");
        return this.forceApplicationRequest || Pattern.matches(sb.toString(), this.graphPath) || Pattern.matches("^/?app/?.*", this.graphPath);
    }

    @Metadata(d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\b\u0002\u0018\u00002\u00020\u0001B\u0017\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0001¢\u0006\u0002\u0010\u0005R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007R\u0013\u0010\u0004\u001a\u0004\u0018\u00010\u0001¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\t¨\u0006\n"}, d2 = {"Lcom/facebook/GraphRequest$Attachment;", "", "request", "Lcom/facebook/GraphRequest;", SDKConstants.PARAM_VALUE, "(Lcom/facebook/GraphRequest;Ljava/lang/Object;)V", "getRequest", "()Lcom/facebook/GraphRequest;", "getValue", "()Ljava/lang/Object;", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    private static final class Attachment {
        private final GraphRequest request;
        private final Object value;

        public Attachment(GraphRequest graphRequest, Object obj) {
            Intrinsics.checkNotNullParameter(graphRequest, "request");
            this.request = graphRequest;
            this.value = obj;
        }

        public final GraphRequest getRequest() {
            return this.request;
        }

        public final Object getValue() {
            return this.value;
        }
    }

    public final void serializeToBatch(JSONArray batch, Map<String, Attachment> attachments) throws JSONException, IOException {
        JSONObject jSONObject = new JSONObject();
        String str = this.batchEntryName;
        if (str != null) {
            jSONObject.put("name", str);
            jSONObject.put(BATCH_ENTRY_OMIT_RESPONSE_ON_SUCCESS_PARAM, this.batchEntryOmitResultOnSuccess);
        }
        String str2 = this.batchEntryDependsOn;
        if (str2 != null) {
            jSONObject.put(BATCH_ENTRY_DEPENDS_ON_PARAM, str2);
        }
        String relativeUrlForBatchedRequest = getRelativeUrlForBatchedRequest();
        jSONObject.put(BATCH_RELATIVE_URL_PARAM, relativeUrlForBatchedRequest);
        jSONObject.put(BATCH_METHOD_PARAM, this.httpMethod);
        AccessToken accessToken = this.accessToken;
        if (accessToken != null) {
            Logger.INSTANCE.registerAccessToken(accessToken.getToken());
        }
        ArrayList arrayList = new ArrayList();
        Iterator<String> it = this.parameters.keySet().iterator();
        while (it.hasNext()) {
            Object obj = this.parameters.get(it.next());
            if (INSTANCE.isSupportedAttachmentType(obj)) {
                StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
                String str3 = String.format(Locale.ROOT, "%s%d", Arrays.copyOf(new Object[]{"file", Integer.valueOf(attachments.size())}, 2));
                Intrinsics.checkNotNullExpressionValue(str3, "java.lang.String.format(locale, format, *args)");
                arrayList.add(str3);
                attachments.put(str3, new Attachment(this, obj));
            }
        }
        if (!arrayList.isEmpty()) {
            jSONObject.put(ATTACHED_FILES_PARAM, TextUtils.join(",", arrayList));
        }
        JSONObject jSONObject2 = this.graphObject;
        if (jSONObject2 != null) {
            final ArrayList arrayList2 = new ArrayList();
            INSTANCE.processGraphObject(jSONObject2, relativeUrlForBatchedRequest, new KeyValueSerializer() {
                @Override
                public void writeString(String key, String value) throws IOException {
                    Intrinsics.checkNotNullParameter(key, SDKConstants.PARAM_KEY);
                    Intrinsics.checkNotNullParameter(value, SDKConstants.PARAM_VALUE);
                    ArrayList<String> arrayList3 = arrayList2;
                    StringCompanionObject stringCompanionObject2 = StringCompanionObject.INSTANCE;
                    String str4 = String.format(Locale.US, "%s=%s", Arrays.copyOf(new Object[]{key, URLEncoder.encode(value, "UTF-8")}, 2));
                    Intrinsics.checkNotNullExpressionValue(str4, "java.lang.String.format(locale, format, *args)");
                    arrayList3.add(str4);
                }
            });
            jSONObject.put("body", TextUtils.join("&", arrayList2));
        }
        batch.put(jSONObject);
    }

    @Metadata(d1 = {"\u0000x\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0011\n\u0002\u0010\u0000\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0012\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u001e\n\u0002\b\u0002\b\u0002\u0018\u00002\u00020\u0001B\u001f\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ+\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0016\u0010\u0013\u001a\f\u0012\b\b\u0001\u0012\u0004\u0018\u00010\u00150\u0014\"\u0004\u0018\u00010\u0015¢\u0006\u0002\u0010\u0016J\u0016\u0010\u0017\u001a\u00020\u00102\u0006\u0010\u0018\u001a\u00020\u00122\u0006\u0010\u0019\u001a\u00020\u001aJ\u0016\u0010\u001b\u001a\u00020\u00102\u0006\u0010\u0018\u001a\u00020\u00122\u0006\u0010\u001c\u001a\u00020\u001dJ$\u0010\u001e\u001a\u00020\u00102\b\u0010\u001f\u001a\u0004\u0018\u00010\u00122\b\u0010 \u001a\u0004\u0018\u00010\u00122\b\u0010!\u001a\u0004\u0018\u00010\u0012J \u0010\"\u001a\u00020\u00102\u0006\u0010\u0018\u001a\u00020\u00122\u0006\u0010#\u001a\u00020$2\b\u0010%\u001a\u0004\u0018\u00010\u0012J \u0010&\u001a\u00020\u00102\u0006\u0010\u0018\u001a\u00020\u00122\u0006\u0010'\u001a\u00020(2\b\u0010%\u001a\u0004\u0018\u00010\u0012J+\u0010)\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0016\u0010\u0013\u001a\f\u0012\b\b\u0001\u0012\u0004\u0018\u00010\u00150\u0014\"\u0004\u0018\u00010\u0015¢\u0006\u0002\u0010\u0016J\"\u0010*\u001a\u00020\u00102\u0006\u0010\u0018\u001a\u00020\u00122\b\u0010+\u001a\u0004\u0018\u00010\u00152\b\u0010,\u001a\u0004\u0018\u00010-J\u0006\u0010.\u001a\u00020\u0010J$\u0010/\u001a\u00020\u00102\u0006\u0010\u0018\u001a\u00020\u00122\u0006\u00100\u001a\u0002012\f\u00102\u001a\b\u0012\u0004\u0012\u00020-03J\u0018\u00104\u001a\u00020\u00102\u0006\u0010\u0018\u001a\u00020\u00122\u0006\u0010+\u001a\u00020\u0012H\u0016R\u000e\u0010\t\u001a\u00020\u0007X\u0082\u000e¢\u0006\u0002\n\u0000R\u0018\u0010\n\u001a\u00060\u000bj\u0002`\f8BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\r\u0010\u000eR\u0010\u0010\u0004\u001a\u0004\u0018\u00010\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000¨\u00065"}, d2 = {"Lcom/facebook/GraphRequest$Serializer;", "Lcom/facebook/GraphRequest$KeyValueSerializer;", "outputStream", "Ljava/io/OutputStream;", "logger", "Lcom/facebook/internal/Logger;", "useUrlEncode", "", "(Ljava/io/OutputStream;Lcom/facebook/internal/Logger;Z)V", "firstWrite", "invalidTypeError", "Ljava/lang/RuntimeException;", "Lkotlin/RuntimeException;", "getInvalidTypeError", "()Ljava/lang/RuntimeException;", "write", "", GraphRequest.FORMAT_PARAM, "", "args", "", "", "(Ljava/lang/String;[Ljava/lang/Object;)V", "writeBitmap", SDKConstants.PARAM_KEY, "bitmap", "Landroid/graphics/Bitmap;", "writeBytes", "bytes", "", "writeContentDisposition", "name", "filename", "contentType", "writeContentUri", "contentUri", "Landroid/net/Uri;", "mimeType", "writeFile", "descriptor", "Landroid/os/ParcelFileDescriptor;", "writeLine", "writeObject", SDKConstants.PARAM_VALUE, "request", "Lcom/facebook/GraphRequest;", "writeRecordBoundary", "writeRequestsAsJson", "requestJsonArray", "Lorg/json/JSONArray;", "requests", "", "writeString", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    private static final class Serializer implements KeyValueSerializer {
        private boolean firstWrite;
        private final Logger logger;
        private final OutputStream outputStream;
        private final boolean useUrlEncode;

        public Serializer(OutputStream outputStream, Logger logger, boolean z) {
            Intrinsics.checkNotNullParameter(outputStream, "outputStream");
            this.outputStream = outputStream;
            this.logger = logger;
            this.firstWrite = true;
            this.useUrlEncode = z;
        }

        public final void writeObject(String key, Object value, GraphRequest request) throws Throwable {
            Intrinsics.checkNotNullParameter(key, SDKConstants.PARAM_KEY);
            Closeable closeable = this.outputStream;
            if (closeable instanceof RequestOutputStream) {
                ((RequestOutputStream) closeable).setCurrentRequest(request);
            }
            if (GraphRequest.INSTANCE.isSupportedParameterType(value)) {
                writeString(key, GraphRequest.INSTANCE.parameterToString(value));
                return;
            }
            if (value instanceof Bitmap) {
                writeBitmap(key, (Bitmap) value);
                return;
            }
            if (value instanceof byte[]) {
                writeBytes(key, (byte[]) value);
                return;
            }
            if (value instanceof Uri) {
                writeContentUri(key, (Uri) value, null);
                return;
            }
            if (value instanceof ParcelFileDescriptor) {
                writeFile(key, (ParcelFileDescriptor) value, null);
                return;
            }
            if (value instanceof ParcelableResourceWithMimeType) {
                ParcelableResourceWithMimeType parcelableResourceWithMimeType = (ParcelableResourceWithMimeType) value;
                Parcelable resource = parcelableResourceWithMimeType.getResource();
                String mimeType = parcelableResourceWithMimeType.getMimeType();
                if (resource instanceof ParcelFileDescriptor) {
                    writeFile(key, (ParcelFileDescriptor) resource, mimeType);
                    return;
                } else {
                    if (resource instanceof Uri) {
                        writeContentUri(key, (Uri) resource, mimeType);
                        return;
                    }
                    throw getInvalidTypeError();
                }
            }
            throw getInvalidTypeError();
        }

        private final RuntimeException getInvalidTypeError() {
            return new IllegalArgumentException("value is not a supported type.");
        }

        public final void writeRequestsAsJson(String key, JSONArray requestJsonArray, Collection<GraphRequest> requests) throws JSONException, IOException {
            Intrinsics.checkNotNullParameter(key, SDKConstants.PARAM_KEY);
            Intrinsics.checkNotNullParameter(requestJsonArray, "requestJsonArray");
            Intrinsics.checkNotNullParameter(requests, "requests");
            Closeable closeable = this.outputStream;
            if (!(closeable instanceof RequestOutputStream)) {
                String string = requestJsonArray.toString();
                Intrinsics.checkNotNullExpressionValue(string, "requestJsonArray.toString()");
                writeString(key, string);
                return;
            }
            RequestOutputStream requestOutputStream = (RequestOutputStream) closeable;
            writeContentDisposition(key, null, null);
            write("[", new Object[0]);
            int i = 0;
            for (GraphRequest graphRequest : requests) {
                int i2 = i + 1;
                JSONObject jSONObject = requestJsonArray.getJSONObject(i);
                requestOutputStream.setCurrentRequest(graphRequest);
                if (i > 0) {
                    write(",%s", jSONObject.toString());
                } else {
                    write("%s", jSONObject.toString());
                }
                i = i2;
            }
            write("]", new Object[0]);
            Logger logger = this.logger;
            if (logger == null) {
                return;
            }
            String strStringPlus = Intrinsics.stringPlus("    ", key);
            String string2 = requestJsonArray.toString();
            Intrinsics.checkNotNullExpressionValue(string2, "requestJsonArray.toString()");
            logger.appendKeyValue(strStringPlus, string2);
        }

        @Override
        public void writeString(String key, String value) throws IOException {
            Intrinsics.checkNotNullParameter(key, SDKConstants.PARAM_KEY);
            Intrinsics.checkNotNullParameter(value, SDKConstants.PARAM_VALUE);
            writeContentDisposition(key, null, null);
            writeLine("%s", value);
            writeRecordBoundary();
            Logger logger = this.logger;
            if (logger == null) {
                return;
            }
            logger.appendKeyValue(Intrinsics.stringPlus("    ", key), value);
        }

        public final void writeBitmap(String key, Bitmap bitmap) throws IOException {
            Intrinsics.checkNotNullParameter(key, SDKConstants.PARAM_KEY);
            Intrinsics.checkNotNullParameter(bitmap, "bitmap");
            writeContentDisposition(key, key, "image/png");
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, this.outputStream);
            writeLine("", new Object[0]);
            writeRecordBoundary();
            Logger logger = this.logger;
            if (logger == null) {
                return;
            }
            logger.appendKeyValue(Intrinsics.stringPlus("    ", key), "<Image>");
        }

        public final void writeBytes(String key, byte[] bytes) throws IOException {
            Intrinsics.checkNotNullParameter(key, SDKConstants.PARAM_KEY);
            Intrinsics.checkNotNullParameter(bytes, "bytes");
            writeContentDisposition(key, key, "content/unknown");
            this.outputStream.write(bytes);
            writeLine("", new Object[0]);
            writeRecordBoundary();
            Logger logger = this.logger;
            if (logger == null) {
                return;
            }
            String strStringPlus = Intrinsics.stringPlus("    ", key);
            StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
            String str = String.format(Locale.ROOT, "<Data: %d>", Arrays.copyOf(new Object[]{Integer.valueOf(bytes.length)}, 1));
            Intrinsics.checkNotNullExpressionValue(str, "java.lang.String.format(locale, format, *args)");
            logger.appendKeyValue(strStringPlus, str);
        }

        public final void writeContentUri(String key, Uri contentUri, String mimeType) throws Throwable {
            int iCopyAndCloseInputStream;
            Intrinsics.checkNotNullParameter(key, SDKConstants.PARAM_KEY);
            Intrinsics.checkNotNullParameter(contentUri, "contentUri");
            if (mimeType == null) {
                mimeType = "content/unknown";
            }
            writeContentDisposition(key, key, mimeType);
            if (this.outputStream instanceof ProgressNoopOutputStream) {
                Utility utility = Utility.INSTANCE;
                ((ProgressNoopOutputStream) this.outputStream).addProgress(Utility.getContentSize(contentUri));
                iCopyAndCloseInputStream = 0;
            } else {
                FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
                InputStream inputStreamOpenInputStream = FacebookSdk.getApplicationContext().getContentResolver().openInputStream(contentUri);
                Utility utility2 = Utility.INSTANCE;
                iCopyAndCloseInputStream = Utility.copyAndCloseInputStream(inputStreamOpenInputStream, this.outputStream);
            }
            writeLine("", new Object[0]);
            writeRecordBoundary();
            Logger logger = this.logger;
            if (logger == null) {
                return;
            }
            String strStringPlus = Intrinsics.stringPlus("    ", key);
            StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
            String str = String.format(Locale.ROOT, "<Data: %d>", Arrays.copyOf(new Object[]{Integer.valueOf(iCopyAndCloseInputStream)}, 1));
            Intrinsics.checkNotNullExpressionValue(str, "java.lang.String.format(locale, format, *args)");
            logger.appendKeyValue(strStringPlus, str);
        }

        public final void writeFile(String key, ParcelFileDescriptor descriptor, String mimeType) throws Throwable {
            int iCopyAndCloseInputStream;
            Intrinsics.checkNotNullParameter(key, SDKConstants.PARAM_KEY);
            Intrinsics.checkNotNullParameter(descriptor, "descriptor");
            if (mimeType == null) {
                mimeType = "content/unknown";
            }
            writeContentDisposition(key, key, mimeType);
            OutputStream outputStream = this.outputStream;
            if (outputStream instanceof ProgressNoopOutputStream) {
                ((ProgressNoopOutputStream) outputStream).addProgress(descriptor.getStatSize());
                iCopyAndCloseInputStream = 0;
            } else {
                ParcelFileDescriptor.AutoCloseInputStream autoCloseInputStream = new ParcelFileDescriptor.AutoCloseInputStream(descriptor);
                Utility utility = Utility.INSTANCE;
                iCopyAndCloseInputStream = Utility.copyAndCloseInputStream(autoCloseInputStream, this.outputStream);
            }
            writeLine("", new Object[0]);
            writeRecordBoundary();
            Logger logger = this.logger;
            if (logger == null) {
                return;
            }
            String strStringPlus = Intrinsics.stringPlus("    ", key);
            StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
            String str = String.format(Locale.ROOT, "<Data: %d>", Arrays.copyOf(new Object[]{Integer.valueOf(iCopyAndCloseInputStream)}, 1));
            Intrinsics.checkNotNullExpressionValue(str, "java.lang.String.format(locale, format, *args)");
            logger.appendKeyValue(strStringPlus, str);
        }

        public final void writeRecordBoundary() throws IOException {
            if (!this.useUrlEncode) {
                writeLine("--%s", GraphRequest.MIME_BOUNDARY);
                return;
            }
            OutputStream outputStream = this.outputStream;
            byte[] bytes = "&".getBytes(Charsets.UTF_8);
            Intrinsics.checkNotNullExpressionValue(bytes, "(this as java.lang.String).getBytes(charset)");
            outputStream.write(bytes);
        }

        public final void writeContentDisposition(String name, String filename, String contentType) throws IOException {
            if (!this.useUrlEncode) {
                write("Content-Disposition: form-data; name=\"%s\"", name);
                if (filename != null) {
                    write("; filename=\"%s\"", filename);
                }
                writeLine("", new Object[0]);
                if (contentType != null) {
                    writeLine("%s: %s", GraphRequest.CONTENT_TYPE_HEADER, contentType);
                }
                writeLine("", new Object[0]);
                return;
            }
            OutputStream outputStream = this.outputStream;
            StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
            String str = String.format("%s=", Arrays.copyOf(new Object[]{name}, 1));
            Intrinsics.checkNotNullExpressionValue(str, "java.lang.String.format(format, *args)");
            Charset charset = Charsets.UTF_8;
            if (str == null) {
                throw new NullPointerException("null cannot be cast to non-null type java.lang.String");
            }
            byte[] bytes = str.getBytes(charset);
            Intrinsics.checkNotNullExpressionValue(bytes, "(this as java.lang.String).getBytes(charset)");
            outputStream.write(bytes);
        }

        public final void write(String format, Object... args) throws IOException {
            Intrinsics.checkNotNullParameter(format, GraphRequest.FORMAT_PARAM);
            Intrinsics.checkNotNullParameter(args, "args");
            if (!this.useUrlEncode) {
                if (this.firstWrite) {
                    OutputStream outputStream = this.outputStream;
                    byte[] bytes = "--".getBytes(Charsets.UTF_8);
                    Intrinsics.checkNotNullExpressionValue(bytes, "(this as java.lang.String).getBytes(charset)");
                    outputStream.write(bytes);
                    OutputStream outputStream2 = this.outputStream;
                    String str = GraphRequest.MIME_BOUNDARY;
                    Charset charset = Charsets.UTF_8;
                    if (str == null) {
                        throw new NullPointerException("null cannot be cast to non-null type java.lang.String");
                    }
                    byte[] bytes2 = str.getBytes(charset);
                    Intrinsics.checkNotNullExpressionValue(bytes2, "(this as java.lang.String).getBytes(charset)");
                    outputStream2.write(bytes2);
                    OutputStream outputStream3 = this.outputStream;
                    byte[] bytes3 = "\r\n".getBytes(Charsets.UTF_8);
                    Intrinsics.checkNotNullExpressionValue(bytes3, "(this as java.lang.String).getBytes(charset)");
                    outputStream3.write(bytes3);
                    this.firstWrite = false;
                }
                OutputStream outputStream4 = this.outputStream;
                StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
                Object[] objArrCopyOf = Arrays.copyOf(args, args.length);
                String str2 = String.format(format, Arrays.copyOf(objArrCopyOf, objArrCopyOf.length));
                Intrinsics.checkNotNullExpressionValue(str2, "java.lang.String.format(format, *args)");
                Charset charset2 = Charsets.UTF_8;
                if (str2 == null) {
                    throw new NullPointerException("null cannot be cast to non-null type java.lang.String");
                }
                byte[] bytes4 = str2.getBytes(charset2);
                Intrinsics.checkNotNullExpressionValue(bytes4, "(this as java.lang.String).getBytes(charset)");
                outputStream4.write(bytes4);
                return;
            }
            OutputStream outputStream5 = this.outputStream;
            StringCompanionObject stringCompanionObject2 = StringCompanionObject.INSTANCE;
            Locale locale = Locale.US;
            Object[] objArrCopyOf2 = Arrays.copyOf(args, args.length);
            String str3 = String.format(locale, format, Arrays.copyOf(objArrCopyOf2, objArrCopyOf2.length));
            Intrinsics.checkNotNullExpressionValue(str3, "java.lang.String.format(locale, format, *args)");
            String strEncode = URLEncoder.encode(str3, "UTF-8");
            Intrinsics.checkNotNullExpressionValue(strEncode, "encode(String.format(Locale.US, format, *args), \"UTF-8\")");
            byte[] bytes5 = strEncode.getBytes(Charsets.UTF_8);
            Intrinsics.checkNotNullExpressionValue(bytes5, "(this as java.lang.String).getBytes(charset)");
            outputStream5.write(bytes5);
        }

        public final void writeLine(String format, Object... args) throws IOException {
            Intrinsics.checkNotNullParameter(format, GraphRequest.FORMAT_PARAM);
            Intrinsics.checkNotNullParameter(args, "args");
            write(format, Arrays.copyOf(args, args.length));
            if (this.useUrlEncode) {
                return;
            }
            write("\r\n", new Object[0]);
        }
    }

    @Metadata(d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0004\u0018\u0000 \u0015*\n\b\u0000\u0010\u0001*\u0004\u0018\u00010\u00022\u00020\u0002:\u0001\u0015B\u0019\b\u0016\u0012\u0006\u0010\u0003\u001a\u00028\u0000\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005¢\u0006\u0002\u0010\u0006B\u000f\b\u0012\u0012\u0006\u0010\u0007\u001a\u00020\b¢\u0006\u0002\u0010\tJ\b\u0010\u000f\u001a\u00020\u0010H\u0016J\u0018\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\b2\u0006\u0010\u0014\u001a\u00020\u0010H\u0016R\u0013\u0010\u0004\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0015\u0010\u0003\u001a\u0004\u0018\u00018\u0000¢\u0006\n\n\u0002\u0010\u000e\u001a\u0004\b\f\u0010\r¨\u0006\u0016"}, d2 = {"Lcom/facebook/GraphRequest$ParcelableResourceWithMimeType;", "RESOURCE", "Landroid/os/Parcelable;", "resource", "mimeType", "", "(Landroid/os/Parcelable;Ljava/lang/String;)V", ShareConstants.FEED_SOURCE_PARAM, "Landroid/os/Parcel;", "(Landroid/os/Parcel;)V", "getMimeType", "()Ljava/lang/String;", "getResource", "()Landroid/os/Parcelable;", "Landroid/os/Parcelable;", "describeContents", "", "writeToParcel", "", "out", "flags", "Companion", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class ParcelableResourceWithMimeType<RESOURCE extends Parcelable> implements Parcelable {
        private final String mimeType;
        private final RESOURCE resource;
        public static final Parcelable.Creator<ParcelableResourceWithMimeType<?>> CREATOR = new Parcelable.Creator<ParcelableResourceWithMimeType<?>>() {
            @Override
            public GraphRequest.ParcelableResourceWithMimeType<?> createFromParcel(Parcel source) {
                Intrinsics.checkNotNullParameter(source, ShareConstants.FEED_SOURCE_PARAM);
                return new GraphRequest.ParcelableResourceWithMimeType<>(source, (DefaultConstructorMarker) null);
            }

            @Override
            public GraphRequest.ParcelableResourceWithMimeType<?>[] newArray(int size) {
                return new GraphRequest.ParcelableResourceWithMimeType[size];
            }
        };

        public ParcelableResourceWithMimeType(Parcel parcel, DefaultConstructorMarker defaultConstructorMarker) {
            this(parcel);
        }

        @Override
        public int describeContents() {
            return 1;
        }

        public final String getMimeType() {
            return this.mimeType;
        }

        public final RESOURCE getResource() {
            return this.resource;
        }

        @Override
        public void writeToParcel(Parcel out, int flags) {
            Intrinsics.checkNotNullParameter(out, "out");
            out.writeString(this.mimeType);
            out.writeParcelable(this.resource, flags);
        }

        public ParcelableResourceWithMimeType(RESOURCE resource, String str) {
            this.mimeType = str;
            this.resource = resource;
        }

        private ParcelableResourceWithMimeType(Parcel parcel) {
            this.mimeType = parcel.readString();
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            this.resource = (RESOURCE) parcel.readParcelable(FacebookSdk.getApplicationContext().getClassLoader());
        }
    }
}
