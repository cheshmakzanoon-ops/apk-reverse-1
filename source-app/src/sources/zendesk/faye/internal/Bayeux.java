package zendesk.faye.internal;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.StringsKt;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import zendesk.faye.BayeuxOptionalFields;
import zendesk.logger.Logger;

@Metadata(m17d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0014\n\u0002\u0010 \n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0006\bÀ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0018\u0010\u001a\u001a\u00020\u00042\u0006\u0010\u001b\u001a\u00020\u00042\b\b\u0002\u0010\u001c\u001a\u00020\u001dJ\u0018\u0010\u001e\u001a\u00020\u00042\u0006\u0010\u001b\u001a\u00020\u00042\b\b\u0002\u0010\u001c\u001a\u00020\u001dJ \u0010\u001f\u001a\u00020\u00042\u000e\b\u0002\u0010 \u001a\b\u0012\u0004\u0012\u00020\u00040\u00192\b\b\u0002\u0010\u001c\u001a\u00020\u001dJ\u0012\u0010!\u001a\u0004\u0018\u00010\"2\u0006\u0010#\u001a\u00020\u0004H\u0002J\u0012\u0010$\u001a\u0004\u0018\u00010%2\u0006\u0010#\u001a\u00020\u0004H\u0002J,\u0010&\u001a\u00020\u00042\u0006\u0010'\u001a\u00020\u00042\u0006\u0010(\u001a\u00020\u00042\n\b\u0002\u0010\u001b\u001a\u0004\u0018\u00010\u00042\b\b\u0002\u0010\u001c\u001a\u00020\u001dJ\"\u0010)\u001a\u00020*2\u0006\u0010+\u001a\u00020%2\u0006\u0010,\u001a\u00020\u00042\b\u0010-\u001a\u0004\u0018\u00010\u0004H\u0002J \u0010.\u001a\u00020\u00042\u0006\u0010\u001b\u001a\u00020\u00042\u0006\u0010'\u001a\u00020\u00042\b\b\u0002\u0010\u001c\u001a\u00020\u001dJ \u0010/\u001a\u00020\u00042\u0006\u0010\u001b\u001a\u00020\u00042\u0006\u0010'\u001a\u00020\u00042\b\b\u0002\u0010\u001c\u001a\u00020\u001dR\u000e\u0010\u0003\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\f\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\r\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0010\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0011\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0012\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0013\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0014\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0015\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0016\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0017\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u0014\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\u00040\u0019X\u0082\u0004¢\u0006\u0002\n\u0000¨\u00060"}, m18d2 = {"Lzendesk/faye/internal/Bayeux;", "", "()V", "CONNECT_CHANNEL", "", "DISCONNECT_CHANNEL", "HANDSHAKE_CHANNEL", "KEY_CHANNEL", "KEY_CLIENT_ID", "KEY_CONNECTION_TYPE", "KEY_DATA", "KEY_EXT", "KEY_ID", "KEY_MIN_VERSION", "KEY_SUBSCRIPTION", "KEY_SUCCESS", "KEY_SUPPORT_CONNECTION_TYPES", "KEY_VERSION", "LOG_TAG", "SUBSCRIBE_CHANNEL", "UNSUBSCRIBE_CHANNEL", "VALUE_CONN_TYPE", "VALUE_MIN_VERSION", "VALUE_VERSION", "defaultConnectionTypes", "", "connect", Bayeux.KEY_CLIENT_ID, "bayeuxOptionalFields", "Lzendesk/faye/BayeuxOptionalFields;", "disconnect", "handshake", "supportedConnTypes", "isJsonArray", "Lorg/json/JSONArray;", "value", "isJsonObject", "Lorg/json/JSONObject;", "publish", Bayeux.KEY_CHANNEL, Bayeux.KEY_DATA, "putField", "", "jsonObject", "fieldName", "fieldValue", "subscribe", "unsubscribe", "zendesk.faye_faye"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class Bayeux {
    public static final String CONNECT_CHANNEL = "/meta/connect";
    public static final String DISCONNECT_CHANNEL = "/meta/disconnect";
    public static final String HANDSHAKE_CHANNEL = "/meta/handshake";
    public static final String KEY_CHANNEL = "channel";
    public static final String KEY_CLIENT_ID = "clientId";
    private static final String KEY_CONNECTION_TYPE = "connectionType";
    public static final String KEY_DATA = "data";
    private static final String KEY_EXT = "ext";
    private static final String KEY_ID = "id";
    private static final String KEY_MIN_VERSION = "minimumVersion";
    public static final String KEY_SUBSCRIPTION = "subscription";
    public static final String KEY_SUCCESS = "successful";
    private static final String KEY_SUPPORT_CONNECTION_TYPES = "supportedConnectionTypes";
    private static final String KEY_VERSION = "version";
    private static final String LOG_TAG = "Bayeux";
    public static final String SUBSCRIBE_CHANNEL = "/meta/subscribe";
    public static final String UNSUBSCRIBE_CHANNEL = "/meta/unsubscribe";
    private static final String VALUE_MIN_VERSION = "1.0beta";
    private static final String VALUE_VERSION = "1.0";
    public static final Bayeux INSTANCE = new Bayeux();
    private static final String VALUE_CONN_TYPE = "websocket";
    private static final List<String> defaultConnectionTypes = CollectionsKt.listOf((Object[]) new String[]{"long-polling", "callback-polling", "iframe", VALUE_CONN_TYPE});

    private Bayeux() {
    }

    public static String handshake$default(Bayeux bayeux, List list, BayeuxOptionalFields bayeuxOptionalFields, int i, Object obj) {
        if ((i & 1) != 0) {
            list = defaultConnectionTypes;
        }
        if ((i & 2) != 0) {
            bayeuxOptionalFields = BayeuxOptionalFields.INSTANCE.builder().build();
        }
        return bayeux.handshake(list, bayeuxOptionalFields);
    }

    public final String handshake(List<String> supportedConnTypes, BayeuxOptionalFields bayeuxOptionalFields) {
        Intrinsics.checkNotNullParameter(supportedConnTypes, "supportedConnTypes");
        Intrinsics.checkNotNullParameter(bayeuxOptionalFields, "bayeuxOptionalFields");
        try {
            JSONArray jSONArray = new JSONArray();
            if (supportedConnTypes.isEmpty()) {
                supportedConnTypes = null;
            }
            if (supportedConnTypes == null) {
                supportedConnTypes = defaultConnectionTypes;
            }
            List<String> list = supportedConnTypes;
            ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(list, 10));
            Iterator<T> it = list.iterator();
            while (it.hasNext()) {
                arrayList.add(jSONArray.put(it.next()));
            }
            JSONObject jSONObjectPut = new JSONObject().put(KEY_CHANNEL, HANDSHAKE_CHANNEL).put(KEY_MIN_VERSION, VALUE_MIN_VERSION).put("version", VALUE_VERSION).put(KEY_SUPPORT_CONNECTION_TYPES, jSONArray);
            Intrinsics.checkNotNull(jSONObjectPut);
            putField(jSONObjectPut, KEY_EXT, bayeuxOptionalFields.getExt());
            jSONObjectPut.put(KEY_ID, bayeuxOptionalFields.getId());
            String string = jSONObjectPut.toString();
            Intrinsics.checkNotNull(string);
            return string;
        } catch (JSONException unused) {
            Logger.m225w(LOG_TAG, "handshake - malformed json", new Object[0]);
            return "";
        }
    }

    public static String connect$default(Bayeux bayeux, String str, BayeuxOptionalFields bayeuxOptionalFields, int i, Object obj) {
        if ((i & 2) != 0) {
            bayeuxOptionalFields = BayeuxOptionalFields.INSTANCE.builder().build();
        }
        return bayeux.connect(str, bayeuxOptionalFields);
    }

    public final String connect(String clientId, BayeuxOptionalFields bayeuxOptionalFields) {
        Intrinsics.checkNotNullParameter(clientId, "clientId");
        Intrinsics.checkNotNullParameter(bayeuxOptionalFields, "bayeuxOptionalFields");
        try {
            JSONObject jSONObjectPut = new JSONObject().put(KEY_CHANNEL, CONNECT_CHANNEL).put(KEY_CLIENT_ID, clientId).put(KEY_CONNECTION_TYPE, VALUE_CONN_TYPE);
            Intrinsics.checkNotNull(jSONObjectPut);
            putField(jSONObjectPut, KEY_EXT, bayeuxOptionalFields.getExt());
            jSONObjectPut.put(KEY_ID, bayeuxOptionalFields.getId());
            String string = jSONObjectPut.toString();
            Intrinsics.checkNotNull(string);
            return string;
        } catch (JSONException unused) {
            Logger.m225w(LOG_TAG, "connect - malformed json", new Object[0]);
            return "";
        }
    }

    public static String disconnect$default(Bayeux bayeux, String str, BayeuxOptionalFields bayeuxOptionalFields, int i, Object obj) {
        if ((i & 2) != 0) {
            bayeuxOptionalFields = BayeuxOptionalFields.INSTANCE.builder().build();
        }
        return bayeux.disconnect(str, bayeuxOptionalFields);
    }

    public final String disconnect(String clientId, BayeuxOptionalFields bayeuxOptionalFields) {
        Intrinsics.checkNotNullParameter(clientId, "clientId");
        Intrinsics.checkNotNullParameter(bayeuxOptionalFields, "bayeuxOptionalFields");
        try {
            JSONObject jSONObjectPut = new JSONObject().put(KEY_CHANNEL, DISCONNECT_CHANNEL).put(KEY_CLIENT_ID, clientId);
            Intrinsics.checkNotNull(jSONObjectPut);
            putField(jSONObjectPut, KEY_EXT, bayeuxOptionalFields.getExt());
            jSONObjectPut.put(KEY_ID, bayeuxOptionalFields.getId());
            String string = jSONObjectPut.toString();
            Intrinsics.checkNotNull(string);
            return string;
        } catch (JSONException unused) {
            Logger.m225w(LOG_TAG, "disconnect - malformed json", new Object[0]);
            return "";
        }
    }

    public static String subscribe$default(Bayeux bayeux, String str, String str2, BayeuxOptionalFields bayeuxOptionalFields, int i, Object obj) {
        if ((i & 4) != 0) {
            bayeuxOptionalFields = BayeuxOptionalFields.INSTANCE.builder().build();
        }
        return bayeux.subscribe(str, str2, bayeuxOptionalFields);
    }

    public final String subscribe(String clientId, String channel, BayeuxOptionalFields bayeuxOptionalFields) {
        Intrinsics.checkNotNullParameter(clientId, "clientId");
        Intrinsics.checkNotNullParameter(channel, "channel");
        Intrinsics.checkNotNullParameter(bayeuxOptionalFields, "bayeuxOptionalFields");
        try {
            JSONObject jSONObjectPut = new JSONObject().put(KEY_CHANNEL, SUBSCRIBE_CHANNEL).put(KEY_CLIENT_ID, clientId).put(KEY_SUBSCRIPTION, channel);
            Intrinsics.checkNotNull(jSONObjectPut);
            putField(jSONObjectPut, KEY_EXT, bayeuxOptionalFields.getExt());
            jSONObjectPut.put(KEY_ID, bayeuxOptionalFields.getId());
            String string = jSONObjectPut.toString();
            Intrinsics.checkNotNull(string);
            return string;
        } catch (JSONException unused) {
            Logger.m225w(LOG_TAG, "subscribe - malformed json", new Object[0]);
            return "";
        }
    }

    public static String unsubscribe$default(Bayeux bayeux, String str, String str2, BayeuxOptionalFields bayeuxOptionalFields, int i, Object obj) {
        if ((i & 4) != 0) {
            bayeuxOptionalFields = BayeuxOptionalFields.INSTANCE.builder().build();
        }
        return bayeux.unsubscribe(str, str2, bayeuxOptionalFields);
    }

    public final String unsubscribe(String clientId, String channel, BayeuxOptionalFields bayeuxOptionalFields) {
        Intrinsics.checkNotNullParameter(clientId, "clientId");
        Intrinsics.checkNotNullParameter(channel, "channel");
        Intrinsics.checkNotNullParameter(bayeuxOptionalFields, "bayeuxOptionalFields");
        try {
            JSONObject jSONObjectPut = new JSONObject().put(KEY_CHANNEL, UNSUBSCRIBE_CHANNEL).put(KEY_CLIENT_ID, clientId).put(KEY_SUBSCRIPTION, channel);
            Intrinsics.checkNotNull(jSONObjectPut);
            putField(jSONObjectPut, KEY_EXT, bayeuxOptionalFields.getExt());
            jSONObjectPut.put(KEY_ID, bayeuxOptionalFields.getId());
            String string = jSONObjectPut.toString();
            Intrinsics.checkNotNull(string);
            return string;
        } catch (JSONException unused) {
            Logger.m225w(LOG_TAG, "unsubscribe - malformed json", new Object[0]);
            return "";
        }
    }

    public static String publish$default(Bayeux bayeux, String str, String str2, String str3, BayeuxOptionalFields bayeuxOptionalFields, int i, Object obj) {
        if ((i & 4) != 0) {
            str3 = null;
        }
        if ((i & 8) != 0) {
            bayeuxOptionalFields = BayeuxOptionalFields.INSTANCE.builder().build();
        }
        return bayeux.publish(str, str2, str3, bayeuxOptionalFields);
    }

    public final String publish(String channel, String data, String clientId, BayeuxOptionalFields bayeuxOptionalFields) {
        Intrinsics.checkNotNullParameter(channel, "channel");
        Intrinsics.checkNotNullParameter(data, "data");
        Intrinsics.checkNotNullParameter(bayeuxOptionalFields, "bayeuxOptionalFields");
        try {
            JSONObject jSONObjectPut = new JSONObject().put(KEY_CHANNEL, channel);
            if (clientId != null) {
                jSONObjectPut.put(KEY_CLIENT_ID, clientId);
            }
            Intrinsics.checkNotNull(jSONObjectPut);
            putField(jSONObjectPut, KEY_DATA, data);
            putField(jSONObjectPut, KEY_EXT, bayeuxOptionalFields.getExt());
            jSONObjectPut.put(KEY_ID, bayeuxOptionalFields.getId());
            String string = jSONObjectPut.toString();
            Intrinsics.checkNotNull(string);
            return string;
        } catch (JSONException unused) {
            Logger.m225w(LOG_TAG, "publish - malformed json", new Object[0]);
            return "";
        }
    }

    private final void putField(JSONObject jsonObject, String fieldName, String fieldValue) throws JSONException {
        JSONArray jSONArrayIsJsonArray;
        if (fieldValue == null) {
            Logger.m225w(LOG_TAG, "putField - value for field with name " + fieldName + " was null, skipping", new Object[0]);
            return;
        }
        JSONObject jSONObjectIsJsonObject = isJsonObject(fieldValue);
        if ((jSONObjectIsJsonObject == null || jsonObject.put(fieldName, jSONObjectIsJsonObject) == null) && (jSONArrayIsJsonArray = isJsonArray(fieldValue)) != null) {
            jsonObject.put(fieldName, jSONArrayIsJsonArray);
        }
    }

    private final JSONObject isJsonObject(String value) {
        if (StringsKt.startsWith$default(value, "{", false, 2, (Object) null)) {
            try {
                return new JSONObject(value);
            } catch (JSONException unused) {
                Logger.m225w(LOG_TAG, "isJsonObject - Invalid Json Object received: " + value, new Object[0]);
                return null;
            }
        }
        Logger.m225w(LOG_TAG, "isJsonObject - Received value is not a Json Object: " + value, new Object[0]);
        return null;
    }

    private final JSONArray isJsonArray(String value) {
        if (StringsKt.startsWith$default(value, "[", false, 2, (Object) null)) {
            try {
                return new JSONArray(value);
            } catch (JSONException unused) {
                Logger.m225w(LOG_TAG, "isJsonArray - Invalid Json Array received: " + value, new Object[0]);
                return null;
            }
        }
        Logger.m225w(LOG_TAG, "isJsonArray - Received value is not a Json Array: " + value, new Object[0]);
        return null;
    }
}
