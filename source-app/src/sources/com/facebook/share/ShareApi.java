package com.facebook.share;

import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import com.facebook.AccessToken;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookGraphResponseException;
import com.facebook.FacebookRequestError;
import com.facebook.GraphRequest;
import com.facebook.GraphResponse;
import com.facebook.HttpMethod;
import com.facebook.internal.CollectionMapper;
import com.facebook.internal.Mutable;
import com.facebook.internal.NativeProtocol;
import com.facebook.internal.Utility;
import com.facebook.internal.instrument.crashshield.CrashShieldHandler;
import com.facebook.share.internal.ShareConstants;
import com.facebook.share.internal.ShareContentValidation;
import com.facebook.share.internal.ShareInternalUtility;
import com.facebook.share.internal.VideoUploader;
import com.facebook.share.model.ShareContent;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.model.SharePhoto;
import com.facebook.share.model.SharePhotoContent;
import com.facebook.share.model.ShareVideoContent;
import java.io.FileNotFoundException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public final class ShareApi {
    private static final String DEFAULT_CHARSET = "UTF-8";
    private static final String DEFAULT_GRAPH_NODE = "me";
    private static final String GRAPH_PATH_FORMAT = "%s/%s";
    private static final String PHOTOS_EDGE = "photos";
    private static final String TAG = "ShareApi";
    private String graphNode = "me";
    private String message;
    private final ShareContent shareContent;

    static void access$000(ShareApi shareApi, ArrayList arrayList, CollectionMapper.OnMapValueCompleteListener onMapValueCompleteListener) {
        if (CrashShieldHandler.isObjectCrashing(ShareApi.class)) {
            return;
        }
        try {
            shareApi.stageArrayList(arrayList, onMapValueCompleteListener);
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, ShareApi.class);
        }
    }

    static void access$100(ShareApi shareApi, SharePhoto sharePhoto, CollectionMapper.OnMapValueCompleteListener onMapValueCompleteListener) {
        if (CrashShieldHandler.isObjectCrashing(ShareApi.class)) {
            return;
        }
        try {
            shareApi.stagePhoto(sharePhoto, onMapValueCompleteListener);
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, ShareApi.class);
        }
    }

    public static void share(final ShareContent shareContent, final FacebookCallback<Sharer.Result> callback) {
        if (CrashShieldHandler.isObjectCrashing(ShareApi.class)) {
            return;
        }
        try {
            new ShareApi(shareContent).share(callback);
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, ShareApi.class);
        }
    }

    public ShareApi(final ShareContent shareContent) {
        this.shareContent = shareContent;
    }

    public String getMessage() {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return null;
        }
        try {
            return this.message;
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
            return null;
        }
    }

    public void setMessage(final String message) {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            this.message = message;
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    public String getGraphNode() {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return null;
        }
        try {
            return this.graphNode;
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
            return null;
        }
    }

    public void setGraphNode(final String graphNode) {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            this.graphNode = graphNode;
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    public ShareContent getShareContent() {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return null;
        }
        try {
            return this.shareContent;
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
            return null;
        }
    }

    public boolean canShare() {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return false;
        }
        try {
            if (getShareContent() == null) {
                return false;
            }
            AccessToken currentAccessToken = AccessToken.getCurrentAccessToken();
            if (!AccessToken.isCurrentAccessTokenActive()) {
                return false;
            }
            Set<String> permissions = currentAccessToken.getPermissions();
            if (permissions != null && permissions.contains("publish_actions")) {
                return true;
            }
            Log.w(TAG, "The publish_actions permissions are missing, the share will fail unless this app was authorized to publish in another installation.");
            return true;
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
            return false;
        }
    }

    public void share(FacebookCallback<Sharer.Result> callback) {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            if (!canShare()) {
                ShareInternalUtility.invokeCallbackWithError(callback, "Insufficient permissions for sharing content via Api.");
                return;
            }
            ShareContent shareContent = getShareContent();
            try {
                ShareContentValidation.validateForApiShare(shareContent);
                if (shareContent instanceof ShareLinkContent) {
                    shareLinkContent((ShareLinkContent) shareContent, callback);
                } else if (shareContent instanceof SharePhotoContent) {
                    sharePhotoContent((SharePhotoContent) shareContent, callback);
                } else if (shareContent instanceof ShareVideoContent) {
                    shareVideoContent((ShareVideoContent) shareContent, callback);
                }
            } catch (FacebookException e) {
                ShareInternalUtility.invokeCallbackWithException(callback, e);
            }
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    private String getGraphPath(final String pathAfterGraphNode) {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return null;
        }
        try {
            return String.format(Locale.ROOT, GRAPH_PATH_FORMAT, URLEncoder.encode(getGraphNode(), DEFAULT_CHARSET), pathAfterGraphNode);
        } catch (UnsupportedEncodingException unused) {
            return null;
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
            return null;
        }
    }

    private void addCommonParameters(final Bundle bundle, ShareContent shareContent) {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            List<String> peopleIds = shareContent.getPeopleIds();
            if (!Utility.isNullOrEmpty(peopleIds)) {
                bundle.putString("tags", TextUtils.join(", ", peopleIds));
            }
            if (!Utility.isNullOrEmpty(shareContent.getPlaceId())) {
                bundle.putString("place", shareContent.getPlaceId());
            }
            if (!Utility.isNullOrEmpty(shareContent.getPageId())) {
                bundle.putString("page", shareContent.getPageId());
            }
            if (Utility.isNullOrEmpty(shareContent.getRef())) {
                return;
            }
            bundle.putString("ref", shareContent.getRef());
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    private static void handleImagesOnAction(Bundle parameters) {
        if (CrashShieldHandler.isObjectCrashing(ShareApi.class)) {
            return;
        }
        try {
            String string = parameters.getString("image");
            if (string != null) {
                try {
                    try {
                        JSONArray jSONArray = new JSONArray(string);
                        for (int i = 0; i < jSONArray.length(); i++) {
                            JSONObject jSONObjectOptJSONObject = jSONArray.optJSONObject(i);
                            if (jSONObjectOptJSONObject != null) {
                                putImageInBundleWithArrayFormat(parameters, i, jSONObjectOptJSONObject);
                            } else {
                                parameters.putString(String.format(Locale.ROOT, "image[%d][url]", Integer.valueOf(i)), jSONArray.getString(i));
                            }
                        }
                        parameters.remove("image");
                    } catch (JSONException unused) {
                    }
                } catch (JSONException unused2) {
                    putImageInBundleWithArrayFormat(parameters, 0, new JSONObject(string));
                    parameters.remove("image");
                }
            }
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, ShareApi.class);
        }
    }

    private static void putImageInBundleWithArrayFormat(Bundle parameters, int index, JSONObject image) throws JSONException {
        if (CrashShieldHandler.isObjectCrashing(ShareApi.class)) {
            return;
        }
        try {
            Iterator<String> itKeys = image.keys();
            while (itKeys.hasNext()) {
                String next = itKeys.next();
                parameters.putString(String.format(Locale.ROOT, "image[%d][%s]", Integer.valueOf(index), next), image.get(next).toString());
            }
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, ShareApi.class);
        }
    }

    private void sharePhotoContent(final SharePhotoContent photoContent, final FacebookCallback<Sharer.Result> callback) {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            final Mutable mutable = new Mutable(0);
            AccessToken currentAccessToken = AccessToken.getCurrentAccessToken();
            ArrayList arrayList = new ArrayList();
            final ArrayList arrayList2 = new ArrayList();
            final ArrayList arrayList3 = new ArrayList();
            GraphRequest.Callback callback2 = new GraphRequest.Callback() {
                @Override
                public void onCompleted(GraphResponse response) {
                    JSONObject graphObject = response.getGraphObject();
                    if (graphObject != null) {
                        arrayList2.add(graphObject);
                    }
                    if (response.getError() != null) {
                        arrayList3.add(response);
                    }
                    Mutable mutable2 = mutable;
                    mutable2.value = Integer.valueOf(((Integer) mutable2.value).intValue() - 1);
                    if (((Integer) mutable.value).intValue() == 0) {
                        if (!arrayList3.isEmpty()) {
                            ShareInternalUtility.invokeCallbackWithResults(callback, null, (GraphResponse) arrayList3.get(0));
                        } else {
                            if (arrayList2.isEmpty()) {
                                return;
                            }
                            ShareInternalUtility.invokeCallbackWithResults(callback, ((JSONObject) arrayList2.get(0)).optString("id"), response);
                        }
                    }
                }
            };
            try {
                for (SharePhoto sharePhoto : photoContent.getPhotos()) {
                    try {
                        Bundle sharePhotoCommonParameters = getSharePhotoCommonParameters(sharePhoto, photoContent);
                        Bitmap bitmap = sharePhoto.getBitmap();
                        Uri imageUrl = sharePhoto.getImageUrl();
                        String caption = sharePhoto.getCaption();
                        if (caption == null) {
                            caption = getMessage();
                        }
                        String str = caption;
                        if (bitmap != null) {
                            arrayList.add(GraphRequest.newUploadPhotoRequest(currentAccessToken, getGraphPath(PHOTOS_EDGE), bitmap, str, sharePhotoCommonParameters, callback2));
                        } else if (imageUrl != null) {
                            arrayList.add(GraphRequest.newUploadPhotoRequest(currentAccessToken, getGraphPath(PHOTOS_EDGE), imageUrl, str, sharePhotoCommonParameters, callback2));
                        }
                    } catch (JSONException e) {
                        ShareInternalUtility.invokeCallbackWithException(callback, e);
                        return;
                    }
                }
                mutable.value = Integer.valueOf(((Integer) mutable.value).intValue() + arrayList.size());
                Iterator it = arrayList.iterator();
                while (it.hasNext()) {
                    ((GraphRequest) it.next()).executeAsync();
                }
            } catch (FileNotFoundException e2) {
                ShareInternalUtility.invokeCallbackWithException(callback, e2);
            }
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    private void shareLinkContent(final ShareLinkContent linkContent, final FacebookCallback<Sharer.Result> callback) {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            GraphRequest.Callback callback2 = new GraphRequest.Callback() {
                @Override
                public void onCompleted(GraphResponse response) {
                    JSONObject graphObject = response.getGraphObject();
                    ShareInternalUtility.invokeCallbackWithResults(callback, graphObject == null ? null : graphObject.optString("id"), response);
                }
            };
            Bundle bundle = new Bundle();
            addCommonParameters(bundle, linkContent);
            bundle.putString("message", getMessage());
            bundle.putString("link", Utility.getUriString(linkContent.getContentUrl()));
            bundle.putString("ref", linkContent.getRef());
            new GraphRequest(AccessToken.getCurrentAccessToken(), getGraphPath("feed"), bundle, HttpMethod.POST, callback2).executeAsync();
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    private void shareVideoContent(final ShareVideoContent videoContent, final FacebookCallback<Sharer.Result> callback) {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            try {
                VideoUploader.uploadAsync(videoContent, getGraphNode(), callback);
            } catch (FileNotFoundException e) {
                ShareInternalUtility.invokeCallbackWithException(callback, e);
            }
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    private Bundle getSharePhotoCommonParameters(SharePhoto photo, SharePhotoContent photoContent) throws JSONException {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return null;
        }
        try {
            Bundle parameters = photo.getParameters();
            if (!parameters.containsKey("place") && !Utility.isNullOrEmpty(photoContent.getPlaceId())) {
                parameters.putString("place", photoContent.getPlaceId());
            }
            if (!parameters.containsKey("tags") && !Utility.isNullOrEmpty(photoContent.getPeopleIds())) {
                List<String> peopleIds = photoContent.getPeopleIds();
                if (!Utility.isNullOrEmpty(peopleIds)) {
                    JSONArray jSONArray = new JSONArray();
                    for (String str : peopleIds) {
                        JSONObject jSONObject = new JSONObject();
                        jSONObject.put("tag_uid", str);
                        jSONArray.put(jSONObject);
                    }
                    parameters.putString("tags", jSONArray.toString());
                }
            }
            if (!parameters.containsKey("ref") && !Utility.isNullOrEmpty(photoContent.getRef())) {
                parameters.putString("ref", photoContent.getRef());
            }
            return parameters;
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
            return null;
        }
    }

    private void stageArrayList(final ArrayList arrayList, final CollectionMapper.OnMapValueCompleteListener onArrayListStagedListener) {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            final JSONArray jSONArray = new JSONArray();
            stageCollectionValues(new CollectionMapper.Collection<Integer>() {
                @Override
                public Iterator<Integer> keyIterator() {
                    final int size = arrayList.size();
                    final Mutable mutable = new Mutable(0);
                    return new Iterator<Integer>() {
                        @Override
                        public void remove() {
                        }

                        @Override
                        public boolean hasNext() {
                            return ((Integer) mutable.value).intValue() < size;
                        }

                        @Override
                        public Integer next() {
                            Integer num = (Integer) mutable.value;
                            Mutable mutable2 = mutable;
                            mutable2.value = Integer.valueOf(((Integer) mutable2.value).intValue() + 1);
                            return num;
                        }
                    };
                }

                @Override
                public Object get(Integer key) {
                    return arrayList.get(key.intValue());
                }

                @Override
                public void set(Integer key, Object value, CollectionMapper.OnErrorListener onErrorListener) {
                    try {
                        jSONArray.put(key.intValue(), value);
                    } catch (JSONException e) {
                        String localizedMessage = e.getLocalizedMessage();
                        if (localizedMessage == null) {
                            localizedMessage = "Error staging object.";
                        }
                        onErrorListener.onError(new FacebookException(localizedMessage));
                    }
                }
            }, new CollectionMapper.OnMapperCompleteListener() {
                @Override
                public void onComplete() {
                    onArrayListStagedListener.onComplete(jSONArray);
                }

                @Override
                public void onError(FacebookException exception) {
                    onArrayListStagedListener.onError(exception);
                }
            });
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    private <T> void stageCollectionValues(final CollectionMapper.Collection<T> collection, final CollectionMapper.OnMapperCompleteListener onCollectionValuesStagedListener) {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            CollectionMapper.iterate(collection, new CollectionMapper.ValueMapper() {
                @Override
                public void mapValue(Object value, CollectionMapper.OnMapValueCompleteListener onMapValueCompleteListener) {
                    if (value instanceof ArrayList) {
                        ShareApi.access$000(ShareApi.this, (ArrayList) value, onMapValueCompleteListener);
                    } else if (value instanceof SharePhoto) {
                        ShareApi.access$100(ShareApi.this, (SharePhoto) value, onMapValueCompleteListener);
                    } else {
                        onMapValueCompleteListener.onComplete(value);
                    }
                }
            }, onCollectionValuesStagedListener);
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    private void stagePhoto(final SharePhoto photo, final CollectionMapper.OnMapValueCompleteListener onPhotoStagedListener) {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            Bitmap bitmap = photo.getBitmap();
            Uri imageUrl = photo.getImageUrl();
            if (bitmap == null && imageUrl == null) {
                onPhotoStagedListener.onError(new FacebookException("Photos must have an imageURL or bitmap."));
                return;
            }
            GraphRequest.Callback callback = new GraphRequest.Callback() {
                @Override
                public void onCompleted(GraphResponse response) {
                    FacebookRequestError error = response.getError();
                    if (error != null) {
                        String errorMessage = error.getErrorMessage();
                        onPhotoStagedListener.onError(new FacebookGraphResponseException(response, errorMessage != null ? errorMessage : "Error staging photo."));
                        return;
                    }
                    JSONObject graphObject = response.getGraphObject();
                    if (graphObject == null) {
                        onPhotoStagedListener.onError(new FacebookException("Error staging photo."));
                        return;
                    }
                    String strOptString = graphObject.optString(ShareConstants.MEDIA_URI);
                    if (strOptString == null) {
                        onPhotoStagedListener.onError(new FacebookException("Error staging photo."));
                        return;
                    }
                    JSONObject jSONObject = new JSONObject();
                    try {
                        jSONObject.put("url", strOptString);
                        jSONObject.put(NativeProtocol.IMAGE_USER_GENERATED_KEY, photo.getUserGenerated());
                        onPhotoStagedListener.onComplete(jSONObject);
                    } catch (JSONException e) {
                        String localizedMessage = e.getLocalizedMessage();
                        onPhotoStagedListener.onError(new FacebookException(localizedMessage != null ? localizedMessage : "Error staging photo."));
                    }
                }
            };
            if (bitmap != null) {
                ShareInternalUtility.newUploadStagingResourceWithImageRequest(AccessToken.getCurrentAccessToken(), bitmap, callback).executeAsync();
                return;
            }
            try {
                ShareInternalUtility.newUploadStagingResourceWithImageRequest(AccessToken.getCurrentAccessToken(), imageUrl, callback).executeAsync();
            } catch (FileNotFoundException e) {
                String localizedMessage = e.getLocalizedMessage();
                if (localizedMessage == null) {
                    localizedMessage = "Error staging photo.";
                }
                onPhotoStagedListener.onError(new FacebookException(localizedMessage));
            }
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }
}
