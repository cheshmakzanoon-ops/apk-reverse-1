package com.google.firebase.crashlytics.internal.common;

import android.app.ActivityManager;
import android.app.ApplicationExitInfo;
import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.StatFs;
import android.util.Base64;
import com.google.android.gms.tasks.SuccessContinuation;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;
import com.google.android.gms.tasks.Tasks;
import com.google.firebase.crashlytics.internal.CrashlyticsNativeComponent;
import com.google.firebase.crashlytics.internal.Logger;
import com.google.firebase.crashlytics.internal.NativeSessionFileProvider;
import com.google.firebase.crashlytics.internal.analytics.AnalyticsEventLogger;
import com.google.firebase.crashlytics.internal.metadata.LogFileManager;
import com.google.firebase.crashlytics.internal.metadata.UserMetadata;
import com.google.firebase.crashlytics.internal.model.CrashlyticsReport;
import com.google.firebase.crashlytics.internal.model.StaticSessionData;
import com.google.firebase.crashlytics.internal.persistence.FileStore;
import com.google.firebase.crashlytics.internal.settings.Settings;
import com.google.firebase.crashlytics.internal.settings.SettingsProvider;
import com.ishumei.smantifraud.l111l1111lI1l;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.SortedSet;
import java.util.concurrent.Callable;
import java.util.concurrent.Executor;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.TimeoutException;
import java.util.concurrent.atomic.AtomicBoolean;

class CrashlyticsController {
    static final FilenameFilter APP_EXCEPTION_MARKER_FILTER = new FilenameFilter() {
        @Override
        public final boolean accept(File file, String str) {
            return str.startsWith(CrashlyticsController.APP_EXCEPTION_MARKER_PREFIX);
        }
    };
    static final String APP_EXCEPTION_MARKER_PREFIX = ".ae";
    static final String FIREBASE_APPLICATION_EXCEPTION = "_ae";
    static final String FIREBASE_CRASH_TYPE = "fatal";
    static final int FIREBASE_CRASH_TYPE_FATAL = 1;
    static final String FIREBASE_TIMESTAMP = "timestamp";
    private static final String GENERATOR_FORMAT = "Crashlytics Android SDK/%s";
    private static final String META_INF_FOLDER = "META-INF/";
    static final String NATIVE_SESSION_DIR = "native-sessions";
    private static final String VERSION_CONTROL_INFO_FILE = "version-control-info.textproto";
    private static final String VERSION_CONTROL_INFO_KEY = "com.crashlytics.version-control-info";
    private final AnalyticsEventLogger analyticsEventLogger;
    private final AppData appData;
    private final CrashlyticsBackgroundWorker backgroundWorker;
    private final Context context;
    private CrashlyticsUncaughtExceptionHandler crashHandler;
    private final CrashlyticsFileMarker crashMarker;
    private final DataCollectionArbiter dataCollectionArbiter;
    private final FileStore fileStore;
    private final IdManager idManager;
    private final LogFileManager logFileManager;
    private final CrashlyticsNativeComponent nativeComponent;
    private final SessionReportingCoordinator reportingCoordinator;
    private final UserMetadata userMetadata;
    private SettingsProvider settingsProvider = null;
    final TaskCompletionSource<Boolean> unsentReportsAvailable = new TaskCompletionSource<>();
    final TaskCompletionSource<Boolean> reportActionProvided = new TaskCompletionSource<>();
    final TaskCompletionSource<Void> unsentReportsHandled = new TaskCompletionSource<>();
    final AtomicBoolean checkForUnsentReportsCalled = new AtomicBoolean(false);

    CrashlyticsController(Context context, CrashlyticsBackgroundWorker crashlyticsBackgroundWorker, IdManager idManager, DataCollectionArbiter dataCollectionArbiter, FileStore fileStore, CrashlyticsFileMarker crashlyticsFileMarker, AppData appData, UserMetadata userMetadata, LogFileManager logFileManager, SessionReportingCoordinator sessionReportingCoordinator, CrashlyticsNativeComponent crashlyticsNativeComponent, AnalyticsEventLogger analyticsEventLogger) {
        this.context = context;
        this.backgroundWorker = crashlyticsBackgroundWorker;
        this.idManager = idManager;
        this.dataCollectionArbiter = dataCollectionArbiter;
        this.fileStore = fileStore;
        this.crashMarker = crashlyticsFileMarker;
        this.appData = appData;
        this.userMetadata = userMetadata;
        this.logFileManager = logFileManager;
        this.nativeComponent = crashlyticsNativeComponent;
        this.analyticsEventLogger = analyticsEventLogger;
        this.reportingCoordinator = sessionReportingCoordinator;
    }

    private Context getContext() {
        return this.context;
    }

    void enableExceptionHandling(String str, Thread.UncaughtExceptionHandler uncaughtExceptionHandler, SettingsProvider settingsProvider) {
        this.settingsProvider = settingsProvider;
        openSession(str);
        CrashlyticsUncaughtExceptionHandler crashlyticsUncaughtExceptionHandler = new CrashlyticsUncaughtExceptionHandler(new CrashlyticsUncaughtExceptionHandler.CrashListener() {
            @Override
            public void onUncaughtException(SettingsProvider settingsProvider2, Thread thread, Throwable th) {
                CrashlyticsController.this.handleUncaughtException(settingsProvider2, thread, th);
            }
        }, settingsProvider, uncaughtExceptionHandler, this.nativeComponent);
        this.crashHandler = crashlyticsUncaughtExceptionHandler;
        Thread.setDefaultUncaughtExceptionHandler(crashlyticsUncaughtExceptionHandler);
    }

    void handleUncaughtException(SettingsProvider settingsProvider, Thread thread, Throwable th) {
        handleUncaughtException(settingsProvider, thread, th, false);
    }

    synchronized void handleUncaughtException(final SettingsProvider settingsProvider, final Thread thread, final Throwable th, final boolean z) {
        Logger.getLogger().m336d("Handling uncaught exception \"" + th + "\" from thread " + thread.getName());
        final long jCurrentTimeMillis = System.currentTimeMillis();
        try {
            try {
                Utils.awaitEvenIfOnMainThread(this.backgroundWorker.submitTask(new Callable<Task<Void>>() {
                    @Override
                    public Task<Void> call() throws Exception {
                        long timestampSeconds = CrashlyticsController.getTimestampSeconds(jCurrentTimeMillis);
                        final String currentSessionId = CrashlyticsController.this.getCurrentSessionId();
                        if (currentSessionId != null) {
                            CrashlyticsController.this.crashMarker.create();
                            CrashlyticsController.this.reportingCoordinator.persistFatalEvent(th, thread, currentSessionId, timestampSeconds);
                            CrashlyticsController.this.doWriteAppExceptionMarker(jCurrentTimeMillis);
                            CrashlyticsController.this.doCloseSessions(settingsProvider);
                            CrashlyticsController.this.doOpenSession(new CLSUUID(CrashlyticsController.this.idManager).toString());
                            if (CrashlyticsController.this.dataCollectionArbiter.isAutomaticDataCollectionEnabled()) {
                                final Executor executor = CrashlyticsController.this.backgroundWorker.getExecutor();
                                return settingsProvider.getSettingsAsync().onSuccessTask(executor, new SuccessContinuation<Settings, Void>() {
                                    @Override
                                    public Task<Void> then(Settings settings) throws Exception {
                                        if (settings == null) {
                                            Logger.getLogger().m344w("Received null app settings, cannot send reports at crash time.");
                                            return Tasks.forResult(null);
                                        }
                                        Task[] taskArr = new Task[2];
                                        taskArr[0] = CrashlyticsController.this.logAnalyticsAppExceptionEvents();
                                        taskArr[1] = CrashlyticsController.this.reportingCoordinator.sendReports(executor, z ? currentSessionId : null);
                                        return Tasks.whenAll((Task<?>[]) taskArr);
                                    }
                                });
                            }
                            return Tasks.forResult(null);
                        }
                        Logger.getLogger().m338e("Tried to write a fatal exception while no session was open.");
                        return Tasks.forResult(null);
                    }
                }));
            } catch (TimeoutException unused) {
                Logger.getLogger().m338e("Cannot send reports. Timed out while fetching settings.");
            }
        } catch (Exception e) {
            Logger.getLogger().m339e("Error handling uncaught exception", e);
        }
    }

    private Task<Boolean> waitForReportAction() {
        if (this.dataCollectionArbiter.isAutomaticDataCollectionEnabled()) {
            Logger.getLogger().m336d("Automatic data collection is enabled. Allowing upload.");
            this.unsentReportsAvailable.trySetResult(false);
            return Tasks.forResult(true);
        }
        Logger.getLogger().m336d("Automatic data collection is disabled.");
        Logger.getLogger().m342v("Notifying that unsent reports are available.");
        this.unsentReportsAvailable.trySetResult(true);
        Task<TContinuationResult> taskOnSuccessTask = this.dataCollectionArbiter.waitForAutomaticDataCollectionEnabled().onSuccessTask(new SuccessContinuation<Void, Boolean>() {
            @Override
            public Task<Boolean> then(Void r1) throws Exception {
                return Tasks.forResult(true);
            }
        });
        Logger.getLogger().m336d("Waiting for send/deleteUnsentReports to be called.");
        return Utils.race(taskOnSuccessTask, this.reportActionProvided.getTask());
    }

    boolean didCrashOnPreviousExecution() {
        if (!this.crashMarker.isPresent()) {
            String currentSessionId = getCurrentSessionId();
            return currentSessionId != null && this.nativeComponent.hasCrashDataForSession(currentSessionId);
        }
        Logger.getLogger().m342v("Found previous crash marker.");
        this.crashMarker.remove();
        return Boolean.TRUE.booleanValue();
    }

    Task<Boolean> checkForUnsentReports() {
        if (!this.checkForUnsentReportsCalled.compareAndSet(false, true)) {
            Logger.getLogger().m344w("checkForUnsentReports should only be called once per execution.");
            return Tasks.forResult(false);
        }
        return this.unsentReportsAvailable.getTask();
    }

    Task<Void> sendUnsentReports() {
        this.reportActionProvided.trySetResult(true);
        return this.unsentReportsHandled.getTask();
    }

    Task<Void> deleteUnsentReports() {
        this.reportActionProvided.trySetResult(false);
        return this.unsentReportsHandled.getTask();
    }

    Task<Void> submitAllReports(Task<Settings> task) {
        if (!this.reportingCoordinator.hasReportsToSend()) {
            Logger.getLogger().m342v("No crash reports are available to be sent.");
            this.unsentReportsAvailable.trySetResult(false);
            return Tasks.forResult(null);
        }
        Logger.getLogger().m342v("Crash reports are available to be sent.");
        return waitForReportAction().onSuccessTask(new C08254(task));
    }

    class C08254 implements SuccessContinuation<Boolean, Void> {
        final Task val$settingsDataTask;

        C08254(Task task) {
            this.val$settingsDataTask = task;
        }

        @Override
        public Task<Void> then(final Boolean bool) throws Exception {
            return CrashlyticsController.this.backgroundWorker.submitTask(new Callable<Task<Void>>() {
                @Override
                public Task<Void> call() throws Exception {
                    if (!bool.booleanValue()) {
                        Logger.getLogger().m342v("Deleting cached crash reports...");
                        CrashlyticsController.deleteFiles(CrashlyticsController.this.listAppExceptionMarkerFiles());
                        CrashlyticsController.this.reportingCoordinator.removeAllReports();
                        CrashlyticsController.this.unsentReportsHandled.trySetResult(null);
                        return Tasks.forResult(null);
                    }
                    Logger.getLogger().m336d("Sending cached crash reports...");
                    CrashlyticsController.this.dataCollectionArbiter.grantDataCollectionPermission(bool.booleanValue());
                    final Executor executor = CrashlyticsController.this.backgroundWorker.getExecutor();
                    return C08254.this.val$settingsDataTask.onSuccessTask(executor, new SuccessContinuation<Settings, Void>() {
                        @Override
                        public Task<Void> then(Settings settings) throws Exception {
                            if (settings != null) {
                                CrashlyticsController.this.logAnalyticsAppExceptionEvents();
                                CrashlyticsController.this.reportingCoordinator.sendReports(executor);
                                CrashlyticsController.this.unsentReportsHandled.trySetResult(null);
                                return Tasks.forResult(null);
                            }
                            Logger.getLogger().m344w("Received null app settings at app startup. Cannot send cached reports");
                            return Tasks.forResult(null);
                        }
                    });
                }
            });
        }
    }

    void writeToLog(final long j, final String str) {
        this.backgroundWorker.submit(new Callable<Void>() {
            @Override
            public Void call() throws Exception {
                if (CrashlyticsController.this.isHandlingException()) {
                    return null;
                }
                CrashlyticsController.this.logFileManager.writeToLog(j, str);
                return null;
            }
        });
    }

    void writeNonFatalException(final Thread thread, final Throwable th) {
        final long jCurrentTimeMillis = System.currentTimeMillis();
        this.backgroundWorker.submit(new Runnable() {
            @Override
            public void run() {
                if (CrashlyticsController.this.isHandlingException()) {
                    return;
                }
                long timestampSeconds = CrashlyticsController.getTimestampSeconds(jCurrentTimeMillis);
                String currentSessionId = CrashlyticsController.this.getCurrentSessionId();
                if (currentSessionId != null) {
                    CrashlyticsController.this.reportingCoordinator.persistNonFatalEvent(th, thread, currentSessionId, timestampSeconds);
                } else {
                    Logger.getLogger().m344w("Tried to write a non-fatal exception while no session was open.");
                }
            }
        });
    }

    void logFatalException(Thread thread, Throwable th) {
        SettingsProvider settingsProvider = this.settingsProvider;
        if (settingsProvider == null) {
            Logger.getLogger().m344w("settingsProvider not set");
        } else {
            handleUncaughtException(settingsProvider, thread, th, true);
        }
    }

    void setUserId(String str) {
        this.userMetadata.setUserId(str);
    }

    void setCustomKey(String str, String str2) {
        try {
            this.userMetadata.setCustomKey(str, str2);
        } catch (IllegalArgumentException e) {
            Context context = this.context;
            if (context != null && CommonUtils.isAppDebuggable(context)) {
                throw e;
            }
            Logger.getLogger().m338e("Attempting to set custom attribute with null key, ignoring.");
        }
    }

    void setCustomKeys(Map<String, String> map) {
        this.userMetadata.setCustomKeys(map);
    }

    void setInternalKey(String str, String str2) {
        try {
            this.userMetadata.setInternalKey(str, str2);
        } catch (IllegalArgumentException e) {
            Context context = this.context;
            if (context != null && CommonUtils.isAppDebuggable(context)) {
                throw e;
            }
            Logger.getLogger().m338e("Attempting to set custom attribute with null key, ignoring.");
        }
    }

    void openSession(final String str) {
        this.backgroundWorker.submit(new Callable<Void>() {
            @Override
            public Void call() throws Exception {
                CrashlyticsController.this.doOpenSession(str);
                return null;
            }
        });
    }

    public String getCurrentSessionId() {
        SortedSet<String> sortedSetListSortedOpenSessionIds = this.reportingCoordinator.listSortedOpenSessionIds();
        if (sortedSetListSortedOpenSessionIds.isEmpty()) {
            return null;
        }
        return sortedSetListSortedOpenSessionIds.first();
    }

    boolean finalizeSessions(SettingsProvider settingsProvider) {
        this.backgroundWorker.checkRunningOnThread();
        if (isHandlingException()) {
            Logger.getLogger().m344w("Skipping session finalization because a crash has already occurred.");
            return Boolean.FALSE.booleanValue();
        }
        Logger.getLogger().m342v("Finalizing previously open sessions.");
        try {
            doCloseSessions(true, settingsProvider);
            Logger.getLogger().m342v("Closed all previously open sessions.");
            return true;
        } catch (Exception e) {
            Logger.getLogger().m339e("Unable to finalize previously open sessions.", e);
            return false;
        }
    }

    public void doOpenSession(String str) {
        long currentTimestampSeconds = getCurrentTimestampSeconds();
        Logger.getLogger().m336d("Opening a new session with ID " + str);
        this.nativeComponent.prepareNativeSession(str, String.format(Locale.US, GENERATOR_FORMAT, CrashlyticsCore.getVersion()), currentTimestampSeconds, StaticSessionData.create(createAppData(this.idManager, this.appData), createOsData(), createDeviceData()));
        this.logFileManager.setCurrentSession(str);
        this.reportingCoordinator.onBeginSession(str, currentTimestampSeconds);
    }

    void doCloseSessions(SettingsProvider settingsProvider) {
        doCloseSessions(false, settingsProvider);
    }

    private void doCloseSessions(boolean z, SettingsProvider settingsProvider) {
        ArrayList arrayList = new ArrayList(this.reportingCoordinator.listSortedOpenSessionIds());
        if (arrayList.size() <= z) {
            Logger.getLogger().m342v("No open sessions to be closed.");
            return;
        }
        String str = (String) arrayList.get(z ? 1 : 0);
        if (settingsProvider.getSettingsSync().featureFlagData.collectAnrs) {
            writeApplicationExitInfoEventIfRelevant(str);
        } else {
            Logger.getLogger().m342v("ANR feature disabled.");
        }
        if (this.nativeComponent.hasCrashDataForSession(str)) {
            finalizePreviousNativeSession(str);
        }
        this.reportingCoordinator.finalizeSessions(getCurrentTimestampSeconds(), z != 0 ? (String) arrayList.get(0) : null);
    }

    List<File> listAppExceptionMarkerFiles() {
        return this.fileStore.getCommonFiles(APP_EXCEPTION_MARKER_FILTER);
    }

    void saveVersionControlInfo() {
        try {
            String versionControlInfo = getVersionControlInfo();
            if (versionControlInfo != null) {
                setInternalKey(VERSION_CONTROL_INFO_KEY, versionControlInfo);
                Logger.getLogger().m340i("Saved version control info");
            }
        } catch (IOException e) {
            Logger.getLogger().m345w("Unable to save version control info", e);
        }
    }

    String getVersionControlInfo() throws IOException {
        InputStream resourceAsStream = getResourceAsStream("META-INF/version-control-info.textproto");
        if (resourceAsStream == null) {
            return null;
        }
        Logger.getLogger().m336d("Read version control info");
        return Base64.encodeToString(readResource(resourceAsStream), 0);
    }

    private InputStream getResourceAsStream(String str) {
        ClassLoader classLoader = getClass().getClassLoader();
        if (classLoader == null) {
            Logger.getLogger().m344w("Couldn't get Class Loader");
            return null;
        }
        InputStream resourceAsStream = classLoader.getResourceAsStream(str);
        if (resourceAsStream != null) {
            return resourceAsStream;
        }
        Logger.getLogger().m340i("No version control information found");
        return null;
    }

    private static byte[] readResource(InputStream inputStream) throws IOException {
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        byte[] bArr = new byte[1024];
        while (true) {
            int i = inputStream.read(bArr);
            if (i != -1) {
                byteArrayOutputStream.write(bArr, 0, i);
            } else {
                return byteArrayOutputStream.toByteArray();
            }
        }
    }

    private void finalizePreviousNativeSession(String str) {
        Logger.getLogger().m342v("Finalizing native report for session " + str);
        NativeSessionFileProvider sessionFileProvider = this.nativeComponent.getSessionFileProvider(str);
        File minidumpFile = sessionFileProvider.getMinidumpFile();
        CrashlyticsReport.ApplicationExitInfo applicationExitInto = sessionFileProvider.getApplicationExitInto();
        if (nativeCoreAbsent(str, minidumpFile, applicationExitInto)) {
            Logger.getLogger().m344w("No native core present");
            return;
        }
        long jLastModified = minidumpFile.lastModified();
        LogFileManager logFileManager = new LogFileManager(this.fileStore, str);
        File nativeSessionDir = this.fileStore.getNativeSessionDir(str);
        if (!nativeSessionDir.isDirectory()) {
            Logger.getLogger().m344w("Couldn't create directory to store native session files, aborting.");
            return;
        }
        doWriteAppExceptionMarker(jLastModified);
        List<NativeSessionFile> nativeSessionFiles = getNativeSessionFiles(sessionFileProvider, str, this.fileStore, logFileManager.getBytesForLog());
        NativeSessionFileGzipper.processNativeSessions(nativeSessionDir, nativeSessionFiles);
        Logger.getLogger().m336d("CrashlyticsController#finalizePreviousNativeSession");
        this.reportingCoordinator.finalizeSessionWithNativeEvent(str, nativeSessionFiles, applicationExitInto);
        logFileManager.clearLog();
    }

    private static boolean nativeCoreAbsent(String str, File file, CrashlyticsReport.ApplicationExitInfo applicationExitInfo) {
        if (file == null || !file.exists()) {
            Logger.getLogger().m344w("No minidump data found for session " + str);
        }
        if (applicationExitInfo == null) {
            Logger.getLogger().m340i("No Tombstones data found for session " + str);
        }
        return (file == null || !file.exists()) && applicationExitInfo == null;
    }

    private static long getCurrentTimestampSeconds() {
        return getTimestampSeconds(System.currentTimeMillis());
    }

    public static long getTimestampSeconds(long j) {
        return j / 1000;
    }

    public void doWriteAppExceptionMarker(long j) {
        try {
            if (this.fileStore.getCommonFile(APP_EXCEPTION_MARKER_PREFIX + j).createNewFile()) {
            } else {
                throw new IOException("Create new file failed.");
            }
        } catch (IOException e) {
            Logger.getLogger().m345w("Could not create app exception marker file.", e);
        }
    }

    private static StaticSessionData.AppData createAppData(IdManager idManager, AppData appData) {
        return StaticSessionData.AppData.create(idManager.getAppIdentifier(), appData.versionCode, appData.versionName, idManager.getInstallIds().getCrashlyticsInstallId(), DeliveryMechanism.determineFrom(appData.installerPackageName).getId(), appData.developmentPlatformProvider);
    }

    private static StaticSessionData.OsData createOsData() {
        return StaticSessionData.OsData.create(Build.VERSION.RELEASE, Build.VERSION.CODENAME, CommonUtils.isRooted());
    }

    private static StaticSessionData.DeviceData createDeviceData() {
        StatFs statFs = new StatFs(Environment.getDataDirectory().getPath());
        return StaticSessionData.DeviceData.create(CommonUtils.getCpuArchitectureInt(), Build.MODEL, Runtime.getRuntime().availableProcessors(), CommonUtils.getTotalRamInBytes(), ((long) statFs.getBlockCount()) * ((long) statFs.getBlockSize()), CommonUtils.isEmulator(), CommonUtils.getDeviceState(), Build.MANUFACTURER, Build.PRODUCT);
    }

    UserMetadata getUserMetadata() {
        return this.userMetadata;
    }

    boolean isHandlingException() {
        CrashlyticsUncaughtExceptionHandler crashlyticsUncaughtExceptionHandler = this.crashHandler;
        return crashlyticsUncaughtExceptionHandler != null && crashlyticsUncaughtExceptionHandler.isHandlingException();
    }

    public Task<Void> logAnalyticsAppExceptionEvents() {
        ArrayList arrayList = new ArrayList();
        for (File file : listAppExceptionMarkerFiles()) {
            try {
                arrayList.add(logAnalyticsAppExceptionEvent(Long.parseLong(file.getName().substring(3))));
            } catch (NumberFormatException unused) {
                Logger.getLogger().m344w("Could not parse app exception timestamp from file " + file.getName());
            }
            file.delete();
        }
        return Tasks.whenAll(arrayList);
    }

    private Task<Void> logAnalyticsAppExceptionEvent(final long j) {
        if (firebaseCrashExists()) {
            Logger.getLogger().m344w("Skipping logging Crashlytics event to Firebase, FirebaseCrash exists");
            return Tasks.forResult(null);
        }
        Logger.getLogger().m336d("Logging app exception event to Firebase Analytics");
        return Tasks.call(new ScheduledThreadPoolExecutor(1), new Callable<Void>() {
            @Override
            public Void call() throws Exception {
                Bundle bundle = new Bundle();
                bundle.putInt(CrashlyticsController.FIREBASE_CRASH_TYPE, 1);
                bundle.putLong(CrashlyticsController.FIREBASE_TIMESTAMP, j);
                CrashlyticsController.this.analyticsEventLogger.logEvent(CrashlyticsController.FIREBASE_APPLICATION_EXCEPTION, bundle);
                return null;
            }
        });
    }

    public static void deleteFiles(List<File> list) {
        Iterator<File> it = list.iterator();
        while (it.hasNext()) {
            it.next().delete();
        }
    }

    private static boolean firebaseCrashExists() {
        try {
            Class.forName("com.google.firebase.crash.FirebaseCrash");
            return true;
        } catch (ClassNotFoundException unused) {
            return false;
        }
    }

    static List<NativeSessionFile> getNativeSessionFiles(NativeSessionFileProvider nativeSessionFileProvider, String str, FileStore fileStore, byte[] bArr) {
        File sessionFile = fileStore.getSessionFile(str, UserMetadata.USERDATA_FILENAME);
        File sessionFile2 = fileStore.getSessionFile(str, UserMetadata.KEYDATA_FILENAME);
        ArrayList arrayList = new ArrayList();
        arrayList.add(new BytesBackedNativeSessionFile("logs_file", "logs", bArr));
        arrayList.add(new FileBackedNativeSessionFile("crash_meta_file", "metadata", nativeSessionFileProvider.getMetadataFile()));
        arrayList.add(new FileBackedNativeSessionFile("session_meta_file", "session", nativeSessionFileProvider.getSessionFile()));
        arrayList.add(new FileBackedNativeSessionFile("app_meta_file", "app", nativeSessionFileProvider.getAppFile()));
        arrayList.add(new FileBackedNativeSessionFile("device_meta_file", "device", nativeSessionFileProvider.getDeviceFile()));
        arrayList.add(new FileBackedNativeSessionFile("os_meta_file", l111l1111lI1l.l111l11111I1l, nativeSessionFileProvider.getOsFile()));
        arrayList.add(nativeCoreFile(nativeSessionFileProvider));
        arrayList.add(new FileBackedNativeSessionFile("user_meta_file", "user", sessionFile));
        arrayList.add(new FileBackedNativeSessionFile("keys_file", UserMetadata.KEYDATA_FILENAME, sessionFile2));
        return arrayList;
    }

    private static NativeSessionFile nativeCoreFile(NativeSessionFileProvider nativeSessionFileProvider) {
        File minidumpFile = nativeSessionFileProvider.getMinidumpFile();
        if (minidumpFile == null || !minidumpFile.exists()) {
            return new BytesBackedNativeSessionFile("minidump_file", "minidump", new byte[]{0});
        }
        return new FileBackedNativeSessionFile("minidump_file", "minidump", minidumpFile);
    }

    private void writeApplicationExitInfoEventIfRelevant(String str) {
        if (Build.VERSION.SDK_INT >= 30) {
            List<ApplicationExitInfo> historicalProcessExitReasons = ((ActivityManager) this.context.getSystemService("activity")).getHistoricalProcessExitReasons(null, 0, 0);
            if (historicalProcessExitReasons.size() != 0) {
                this.reportingCoordinator.persistRelevantAppExitInfoEvent(str, historicalProcessExitReasons, new LogFileManager(this.fileStore, str), UserMetadata.loadFromExistingSession(str, this.fileStore, this.backgroundWorker));
                return;
            } else {
                Logger.getLogger().m342v("No ApplicationExitInfo available. Session: " + str);
                return;
            }
        }
        Logger.getLogger().m342v("ANR feature enabled, but device is API " + Build.VERSION.SDK_INT);
    }
}
