package com.facebook.appevents.integrity;

import android.os.Bundle;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.FacebookSdk;
import com.facebook.appevents.AppEventsConstants;
import com.facebook.appevents.internal.Constants;
import com.facebook.internal.FetchedAppSettings;
import com.facebook.internal.FetchedAppSettingsManager;
import com.facebook.internal.instrument.crashshield.CrashShieldHandler;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;
import kotlin.Lazy;
import kotlin.LazyKt;
import kotlin.Metadata;
import kotlin.collections.SetsKt;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.Intrinsics;
import org.json.JSONArray;

@Metadata(d1 = {"\u00008\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\bÇ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J&\u0010\u000e\u001a\u0016\u0012\u0004\u0012\u00020\u0005\u0018\u00010\u0004j\n\u0012\u0004\u0012\u00020\u0005\u0018\u0001`\u00062\b\u0010\u000f\u001a\u0004\u0018\u00010\u0010H\u0002J\b\u0010\u0011\u001a\u00020\u0012H\u0007J\b\u0010\u0013\u001a\u00020\u0012H\u0007J\b\u0010\u0014\u001a\u00020\u0012H\u0002J\u0012\u0010\u0015\u001a\u00020\u00122\b\u0010\u0016\u001a\u0004\u0018\u00010\u0017H\u0007R+\u0010\u0003\u001a\u0012\u0012\u0004\u0012\u00020\u00050\u0004j\b\u0012\u0004\u0012\u00020\u0005`\u00068FX\u0086\u0084\u0002¢\u0006\f\n\u0004\b\t\u0010\n\u001a\u0004\b\u0007\u0010\bR\u000e\u0010\u000b\u001a\u00020\fX\u0082\u000e¢\u0006\u0002\n\u0000R\"\u0010\r\u001a\u0016\u0012\u0004\u0012\u00020\u0005\u0018\u00010\u0004j\n\u0012\u0004\u0012\u00020\u0005\u0018\u0001`\u0006X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0018"}, d2 = {"Lcom/facebook/appevents/integrity/ProtectedModeManager;", "", "()V", "defaultStandardParameterNames", "Ljava/util/HashSet;", "", "Lkotlin/collections/HashSet;", "getDefaultStandardParameterNames", "()Ljava/util/HashSet;", "defaultStandardParameterNames$delegate", "Lkotlin/Lazy;", "enabled", "", "standardParams", "convertJSONArrayToHashSet", "jsonArray", "Lorg/json/JSONArray;", "disable", "", "enable", "loadStandardParams", "processParametersForProtectedMode", "parameters", "Landroid/os/Bundle;", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class ProtectedModeManager {
    public static final ProtectedModeManager INSTANCE = new ProtectedModeManager();

    private static final Lazy defaultStandardParameterNames = LazyKt.lazy(new Function0<HashSet<String>>() {
        public final HashSet<String> invoke() {
            return SetsKt.hashSetOf(new String[]{"_currency", AppEventsConstants.EVENT_PARAM_VALUE_TO_SUM, "fb_availability", "fb_body_style", "fb_checkin_date", "fb_checkout_date", "fb_city", "fb_condition_of_vehicle", "fb_content_category", "fb_content_ids", "fb_content_name", AppEventsConstants.EVENT_PARAM_CONTENT_TYPE, "fb_contents", "fb_country", AppEventsConstants.EVENT_PARAM_CURRENCY, "fb_delivery_category", "fb_departing_arrival_date", "fb_departing_departure_date", "fb_destination_airport", "fb_destination_ids", "fb_dma_code", "fb_drivetrain", "fb_exterior_color", "fb_fuel_type", "fb_hotel_score", "fb_interior_color", "fb_lease_end_date", "fb_lease_start_date", "fb_listing_type", "fb_make", "fb_mileage.unit", "fb_mileage.value", "fb_model", "fb_neighborhood", "fb_num_adults", "fb_num_children", "fb_num_infants", AppEventsConstants.EVENT_PARAM_NUM_ITEMS, AppEventsConstants.EVENT_PARAM_ORDER_ID, "fb_origin_airport", "fb_postal_code", "fb_predicted_ltv", "fb_preferred_baths_range", "fb_preferred_beds_range", "fb_preferred_neighborhoods", "fb_preferred_num_stops", "fb_preferred_price_range", "fb_preferred_star_ratings", "fb_price", "fb_property_type", "fb_region", "fb_returning_arrival_date", "fb_returning_departure_date", AppEventsConstants.EVENT_PARAM_SEARCH_STRING, "fb_state_of_vehicle", "fb_status", "fb_suggested_destinations", "fb_suggested_home_listings", "fb_suggested_hotels", "fb_suggested_jobs", "fb_suggested_local_service_businesses", "fb_suggested_location_based_items", "fb_suggested_vehicles", "fb_transmission", "fb_travel_class", "fb_travel_end", "fb_travel_start", "fb_trim", "fb_user_bucket", "fb_value", "fb_vin", "fb_year", "lead_event_source", "predicted_ltv", "product_catalog_id", "app_user_id", "appVersion", Constants.EVENT_NAME_EVENT_KEY, Constants.EVENT_NAME_MD5_EVENT_KEY, "_implicitlyLogged", "_inBackground", "_isTimedEvent", Constants.LOG_TIME_APP_EVENT_KEY, "_session_id", "_ui", "_valueToUpdate", com.facebook.appevents.codeless.internal.Constants.IS_CODELESS_EVENT_KEY, "_is_suggested_event", "_fb_pixel_referral_id", "fb_pixel_id", "trace_id", "subscription_id", "event_id", "_restrictedParams", "_onDeviceParams", "purchase_valid_result_type", "core_lib_included", "login_lib_included", "share_lib_included", "place_lib_included", "messenger_lib_included", "applinks_lib_included", "marketing_lib_included", "_codeless_action", "sdk_initialized", "billing_client_lib_included", "billing_service_lib_included", "user_data_keys", "device_push_token", AppEventsConstants.EVENT_PARAM_PACKAGE_FP, AppEventsConstants.EVENT_PARAM_APP_CERT_HASH, "aggregate_id", "anonymous_id", "campaign_ids", "fb_post_attachment", "receipt_data", AppEventsConstants.EVENT_PARAM_AD_TYPE, AppEventsConstants.EVENT_PARAM_CONTENT, AppEventsConstants.EVENT_PARAM_CONTENT_ID, AppEventsConstants.EVENT_PARAM_DESCRIPTION, AppEventsConstants.EVENT_PARAM_LEVEL, AppEventsConstants.EVENT_PARAM_MAX_RATING_VALUE, AppEventsConstants.EVENT_PARAM_PAYMENT_INFO_AVAILABLE, AppEventsConstants.EVENT_PARAM_REGISTRATION_METHOD, AppEventsConstants.EVENT_PARAM_SUCCESS, "pm", "_audiencePropertyIds", "cs_maca"});
        }
    });
    private static boolean enabled;
    private static HashSet<String> standardParams;

    private ProtectedModeManager() {
    }

    public final HashSet<String> getDefaultStandardParameterNames() {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return null;
        }
        try {
            return (HashSet) defaultStandardParameterNames.getValue();
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
            return null;
        }
    }

    @JvmStatic
    public static final void enable() {
        if (CrashShieldHandler.isObjectCrashing(ProtectedModeManager.class)) {
            return;
        }
        try {
            ProtectedModeManager protectedModeManager = INSTANCE;
            enabled = true;
            protectedModeManager.loadStandardParams();
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, ProtectedModeManager.class);
        }
    }

    @JvmStatic
    public static final void disable() {
        if (CrashShieldHandler.isObjectCrashing(ProtectedModeManager.class)) {
            return;
        }
        try {
            enabled = false;
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, ProtectedModeManager.class);
        }
    }

    private final void loadStandardParams() {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            FetchedAppSettingsManager fetchedAppSettingsManager = FetchedAppSettingsManager.INSTANCE;
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            FetchedAppSettings fetchedAppSettingsQueryAppSettings = FetchedAppSettingsManager.queryAppSettings(FacebookSdk.getApplicationId(), false);
            if (fetchedAppSettingsQueryAppSettings == null) {
                return;
            }
            HashSet<String> hashSetConvertJSONArrayToHashSet = convertJSONArrayToHashSet(fetchedAppSettingsQueryAppSettings.getProtectedModeStandardParamsSetting());
            if (hashSetConvertJSONArrayToHashSet == null) {
                hashSetConvertJSONArrayToHashSet = getDefaultStandardParameterNames();
            }
            standardParams = hashSetConvertJSONArrayToHashSet;
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    private final HashSet<String> convertJSONArrayToHashSet(JSONArray jsonArray) {
        if (!CrashShieldHandler.isObjectCrashing(this) && jsonArray != null) {
            try {
                if (jsonArray.length() != 0) {
                    HashSet<String> hashSet = new HashSet<>();
                    int length = jsonArray.length();
                    if (length > 0) {
                        int i = 0;
                        while (true) {
                            int i2 = i + 1;
                            String string = jsonArray.getString(i);
                            Intrinsics.checkNotNullExpressionValue(string, "jsonArray.getString(i)");
                            hashSet.add(string);
                            if (i2 >= length) {
                                break;
                            }
                            i = i2;
                        }
                    }
                    return hashSet;
                }
            } catch (Throwable th) {
                CrashShieldHandler.handleThrowable(th, this);
            }
        }
        return null;
    }

    @JvmStatic
    public static final void processParametersForProtectedMode(Bundle parameters) {
        if (CrashShieldHandler.isObjectCrashing(ProtectedModeManager.class)) {
            return;
        }
        try {
            if (enabled && parameters != null && !parameters.isEmpty() && standardParams != null) {
                ArrayList arrayList = new ArrayList();
                Set<String> setKeySet = parameters.keySet();
                Intrinsics.checkNotNullExpressionValue(setKeySet, "parameters.keySet()");
                for (String str : setKeySet) {
                    HashSet<String> hashSet = standardParams;
                    Intrinsics.checkNotNull(hashSet);
                    if (!hashSet.contains(str)) {
                        Intrinsics.checkNotNullExpressionValue(str, "param");
                        arrayList.add(str);
                    }
                }
                Iterator it = arrayList.iterator();
                while (it.hasNext()) {
                    parameters.remove((String) it.next());
                }
                parameters.putString("pm", "1");
            }
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, ProtectedModeManager.class);
        }
    }
}
