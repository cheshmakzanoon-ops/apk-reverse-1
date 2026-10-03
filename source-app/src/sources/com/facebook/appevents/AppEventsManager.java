package com.facebook.appevents;

import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.appevents.aam.MetadataIndexer;
import com.facebook.appevents.cloudbridge.AppEventsCAPIManager;
import com.facebook.appevents.eventdeactivation.EventDeactivationManager;
import com.facebook.appevents.iap.InAppPurchaseManager;
import com.facebook.appevents.integrity.MACARuleMatchingManager;
import com.facebook.appevents.integrity.ProtectedModeManager;
import com.facebook.appevents.p005ml.ModelManager;
import com.facebook.appevents.restrictivedatafilter.RestrictiveDataManager;
import com.facebook.internal.FeatureManager;
import com.facebook.internal.FetchedAppSettings;
import com.facebook.internal.FetchedAppSettingsManager;
import com.facebook.internal.instrument.crashshield.CrashShieldHandler;
import kotlin.Metadata;
import kotlin.jvm.JvmStatic;

@Metadata(d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\bÇ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\b\u0010\u0003\u001a\u00020\u0004H\u0007¨\u0006\u0005"}, d2 = {"Lcom/facebook/appevents/AppEventsManager;", "", "()V", "start", "", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AppEventsManager {
    public static final AppEventsManager INSTANCE = new AppEventsManager();

    private AppEventsManager() {
    }

    @Metadata(d1 = {"\u0000\u0019\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000*\u0001\u0000\b\n\u0018\u00002\u00020\u0001J\b\u0010\u0002\u001a\u00020\u0003H\u0016J\u0012\u0010\u0004\u001a\u00020\u00032\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006H\u0016¨\u0006\u0007"}, d2 = {"com/facebook/appevents/AppEventsManager$start$1", "Lcom/facebook/internal/FetchedAppSettingsManager$FetchedAppSettingsCallback;", "onError", "", "onSuccess", "fetchedAppSettings", "Lcom/facebook/internal/FetchedAppSettings;", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class C08991 implements FetchedAppSettingsManager.FetchedAppSettingsCallback {
        @Override
        public void onError() {
        }

        C08991() {
        }

        @Override
        public void onSuccess(FetchedAppSettings fetchedAppSettings) {
            FeatureManager featureManager = FeatureManager.INSTANCE;
            FeatureManager.checkFeature(FeatureManager.Feature.AAM, new FeatureManager.Callback() {
                @Override
                public final void onCompleted(boolean z) {
                    AppEventsManager.C08991.m2395onSuccess$lambda0(z);
                }
            });
            FeatureManager featureManager2 = FeatureManager.INSTANCE;
            FeatureManager.checkFeature(FeatureManager.Feature.RestrictiveDataFiltering, new FeatureManager.Callback() {
                @Override
                public final void onCompleted(boolean z) {
                    AppEventsManager.C08991.m2396onSuccess$lambda1(z);
                }
            });
            FeatureManager featureManager3 = FeatureManager.INSTANCE;
            FeatureManager.checkFeature(FeatureManager.Feature.PrivacyProtection, new FeatureManager.Callback() {
                @Override
                public final void onCompleted(boolean z) {
                    AppEventsManager.C08991.m2397onSuccess$lambda2(z);
                }
            });
            FeatureManager featureManager4 = FeatureManager.INSTANCE;
            FeatureManager.checkFeature(FeatureManager.Feature.EventDeactivation, new FeatureManager.Callback() {
                @Override
                public final void onCompleted(boolean z) {
                    AppEventsManager.C08991.m2398onSuccess$lambda3(z);
                }
            });
            FeatureManager featureManager5 = FeatureManager.INSTANCE;
            FeatureManager.checkFeature(FeatureManager.Feature.IapLogging, new FeatureManager.Callback() {
                @Override
                public final void onCompleted(boolean z) {
                    AppEventsManager.C08991.m2399onSuccess$lambda4(z);
                }
            });
            FeatureManager featureManager6 = FeatureManager.INSTANCE;
            FeatureManager.checkFeature(FeatureManager.Feature.ProtectedMode, new FeatureManager.Callback() {
                @Override
                public final void onCompleted(boolean z) {
                    AppEventsManager.C08991.m2400onSuccess$lambda5(z);
                }
            });
            FeatureManager featureManager7 = FeatureManager.INSTANCE;
            FeatureManager.checkFeature(FeatureManager.Feature.MACARuleMatching, new FeatureManager.Callback() {
                @Override
                public final void onCompleted(boolean z) {
                    AppEventsManager.C08991.m2401onSuccess$lambda6(z);
                }
            });
            FeatureManager featureManager8 = FeatureManager.INSTANCE;
            FeatureManager.checkFeature(FeatureManager.Feature.CloudBridge, new FeatureManager.Callback() {
                @Override
                public final void onCompleted(boolean z) {
                    AppEventsManager.C08991.m2402onSuccess$lambda7(z);
                }
            });
        }

        public static final void m2395onSuccess$lambda0(boolean z) {
            if (z) {
                MetadataIndexer metadataIndexer = MetadataIndexer.INSTANCE;
                MetadataIndexer.enable();
            }
        }

        public static final void m2396onSuccess$lambda1(boolean z) {
            if (z) {
                RestrictiveDataManager restrictiveDataManager = RestrictiveDataManager.INSTANCE;
                RestrictiveDataManager.enable();
            }
        }

        public static final void m2397onSuccess$lambda2(boolean z) {
            if (z) {
                ModelManager modelManager = ModelManager.INSTANCE;
                ModelManager.enable();
            }
        }

        public static final void m2398onSuccess$lambda3(boolean z) {
            if (z) {
                EventDeactivationManager eventDeactivationManager = EventDeactivationManager.INSTANCE;
                EventDeactivationManager.enable();
            }
        }

        public static final void m2399onSuccess$lambda4(boolean z) {
            if (z) {
                InAppPurchaseManager inAppPurchaseManager = InAppPurchaseManager.INSTANCE;
                InAppPurchaseManager.enableAutoLogging();
            }
        }

        public static final void m2400onSuccess$lambda5(boolean z) {
            if (z) {
                ProtectedModeManager protectedModeManager = ProtectedModeManager.INSTANCE;
                ProtectedModeManager.enable();
            }
        }

        public static final void m2401onSuccess$lambda6(boolean z) {
            if (z) {
                MACARuleMatchingManager mACARuleMatchingManager = MACARuleMatchingManager.INSTANCE;
                MACARuleMatchingManager.enable();
            }
        }

        public static final void m2402onSuccess$lambda7(boolean z) {
            if (z) {
                AppEventsCAPIManager appEventsCAPIManager = AppEventsCAPIManager.INSTANCE;
                AppEventsCAPIManager.enable();
            }
        }
    }

    @JvmStatic
    public static final void start() {
        if (CrashShieldHandler.isObjectCrashing(AppEventsManager.class)) {
            return;
        }
        try {
            FetchedAppSettingsManager fetchedAppSettingsManager = FetchedAppSettingsManager.INSTANCE;
            FetchedAppSettingsManager.getAppSettingsAsync(new C08991());
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, AppEventsManager.class);
        }
    }
}
