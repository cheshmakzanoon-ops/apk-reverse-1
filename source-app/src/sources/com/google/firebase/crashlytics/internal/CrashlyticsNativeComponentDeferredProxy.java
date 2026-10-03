package com.google.firebase.crashlytics.internal;

import com.google.firebase.crashlytics.internal.model.CrashlyticsReport;
import com.google.firebase.crashlytics.internal.model.StaticSessionData;
import com.google.firebase.inject.Deferred;
import com.google.firebase.inject.Provider;
import java.io.File;
import java.util.concurrent.atomic.AtomicReference;

public final class CrashlyticsNativeComponentDeferredProxy implements CrashlyticsNativeComponent {
    private static final NativeSessionFileProvider MISSING_NATIVE_SESSION_FILE_PROVIDER = new MissingNativeSessionFileProvider();
    private final AtomicReference<CrashlyticsNativeComponent> availableNativeComponent = new AtomicReference<>(null);
    private final Deferred<CrashlyticsNativeComponent> deferredNativeComponent;

    public CrashlyticsNativeComponentDeferredProxy(Deferred<CrashlyticsNativeComponent> deferred) {
        this.deferredNativeComponent = deferred;
        deferred.whenAvailable(new Deferred.DeferredHandler() {
            @Override
            public final void handle(Provider provider) {
                this.f$0.m335x5c12a4b9(provider);
            }
        });
    }

    void m335x5c12a4b9(Provider provider) {
        Logger.getLogger().m336d("Crashlytics native component now available.");
        this.availableNativeComponent.set((CrashlyticsNativeComponent) provider.get());
    }

    @Override
    public boolean hasCrashDataForCurrentSession() {
        CrashlyticsNativeComponent crashlyticsNativeComponent = this.availableNativeComponent.get();
        return crashlyticsNativeComponent != null && crashlyticsNativeComponent.hasCrashDataForCurrentSession();
    }

    @Override
    public boolean hasCrashDataForSession(String str) {
        CrashlyticsNativeComponent crashlyticsNativeComponent = this.availableNativeComponent.get();
        return crashlyticsNativeComponent != null && crashlyticsNativeComponent.hasCrashDataForSession(str);
    }

    @Override
    public void prepareNativeSession(final String str, final String str2, final long j, final StaticSessionData staticSessionData) {
        Logger.getLogger().m342v("Deferring native open session: " + str);
        this.deferredNativeComponent.whenAvailable(new Deferred.DeferredHandler() {
            @Override
            public final void handle(Provider provider) {
                ((CrashlyticsNativeComponent) provider.get()).prepareNativeSession(str, str2, j, staticSessionData);
            }
        });
    }

    @Override
    public NativeSessionFileProvider getSessionFileProvider(String str) {
        CrashlyticsNativeComponent crashlyticsNativeComponent = this.availableNativeComponent.get();
        if (crashlyticsNativeComponent == null) {
            return MISSING_NATIVE_SESSION_FILE_PROVIDER;
        }
        return crashlyticsNativeComponent.getSessionFileProvider(str);
    }

    private static final class MissingNativeSessionFileProvider implements NativeSessionFileProvider {
        @Override
        public File getAppFile() {
            return null;
        }

        @Override
        public CrashlyticsReport.ApplicationExitInfo getApplicationExitInto() {
            return null;
        }

        @Override
        public File getBinaryImagesFile() {
            return null;
        }

        @Override
        public File getDeviceFile() {
            return null;
        }

        @Override
        public File getMetadataFile() {
            return null;
        }

        @Override
        public File getMinidumpFile() {
            return null;
        }

        @Override
        public File getOsFile() {
            return null;
        }

        @Override
        public File getSessionFile() {
            return null;
        }

        private MissingNativeSessionFileProvider() {
        }
    }
}
