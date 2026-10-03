package com.googleplayservice;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;
import com.google.android.gms.common.GoogleApiAvailability;
import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.games.AuthenticationResult;
import com.google.android.gms.games.GamesSignInClient;
import com.google.android.gms.games.LeaderboardsClient;
import com.google.android.gms.games.PlayGames;
import com.google.android.gms.games.PlayGamesSdk;
import com.google.android.gms.games.Player;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.analytics.FirebaseAnalytics;
import com.ishumei.smantifraud.l11l11I1111l;
import com.sdkmanager.notify.LocalNotificationManager;
import java.lang.ref.WeakReference;
import org.json.JSONException;
import org.json.JSONObject;
import ru.mopsicus.common.IDataSender;

public final class PGSManager {
    private static final int RC_ACHIEVEMENTS_UI = 18257;
    private static final int RC_LEADERBOARDS_UI = 18258;
    private static final String TAG = "GooglePlayManager";
    private static WeakReference<Activity> sActivityRef = new WeakReference<>(null);
    private static volatile boolean sAuthenticated;
    private static IDataSender sDataSenderCallback;
    private static volatile boolean sInitialized;

    private PGSManager() {
    }

    private static Activity activity() {
        Activity activity = sActivityRef.get();
        if (activity == null) {
            sActivityRef = new WeakReference<>(activity);
        }
        return activity;
    }

    public static void init(Activity activity, IDataSender iDataSender) {
        Log.i(TAG, "PlayGamesSdk sdkActivity init");
        sActivityRef = new WeakReference<>(activity);
        sDataSenderCallback = iDataSender;
        playSdkInitialize();
    }

    public static void sendDataToNative(String str, String str2) {
        if (str.equals("PGS_SignIn")) {
            signIn();
            return;
        }
        if (str.equals("PGS_SignInSilently")) {
            signInSilently();
            return;
        }
        if (str.equals("PGS_ShowAchievementsUI")) {
            showAchievementsUI();
            return;
        }
        if (str.equals("PGS_IncrementAchievement")) {
            try {
                JSONObject jSONObject = new JSONObject(str2);
                incrementAchievement(jSONObject.getString("achievementId"), jSONObject.getInt("steps"));
                return;
            } catch (JSONException e) {
                Log.e(TAG, "Invalid JSON for IncrementAchievement: " + str2, e);
                return;
            }
        }
        if (str.equals("PGS_ShowLeaderboardUI")) {
            try {
                showLeaderboardUI(new JSONObject(str2).optString("leaderboardId", null));
                return;
            } catch (JSONException e2) {
                Log.e(TAG, "Invalid JSON for ShowLeaderboardUI: " + str2, e2);
                return;
            }
        }
        if (str.equals("PGS_SubmitScore")) {
            try {
                JSONObject jSONObject2 = new JSONObject(str2);
                submitScore(jSONObject2.getString("leaderboardId"), jSONObject2.getLong(FirebaseAnalytics.Param.SCORE));
                return;
            } catch (JSONException e3) {
                Log.e(TAG, "Invalid JSON for SubmitScore: " + str2, e3);
                return;
            }
        }
        if (str.equals("PGS_TestInvoke1")) {
            Log.e(TAG, "PGS_TestInvoke1 called with data: " + str2);
        }
    }

    private static void runOnUiThread(Runnable runnable) {
        Activity activity = activity();
        if (activity != null) {
            activity.runOnUiThread(runnable);
        } else {
            Log.w(TAG, "No activity available, running runnable directly.");
            runnable.run();
        }
    }

    private static boolean isPlayServicesAvailable() {
        Activity activity = activity();
        return activity != null && GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(activity) == 0;
    }

    private static int playServicesStatusCode() {
        Activity activity = activity();
        if (activity == null) {
            return 9;
        }
        return GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(activity);
    }

    public static void playSdkInitialize() {
        runOnUiThread(new Runnable() {
            @Override
            public final void run() {
                PGSManager.lambda$playSdkInitialize$0();
            }
        });
    }

    static void lambda$playSdkInitialize$0() {
        Activity activity = activity();
        if (activity == null) {
            sendError(TAG, "Unity activity is null", 0);
            return;
        }
        try {
            PlayGamesSdk.initialize(activity.getApplicationContext());
            sInitialized = true;
            Log.i(TAG, "PlayGamesSdk initialized.");
        } catch (Throwable th) {
            Log.e(TAG, "PlayGamesSdk.initialize failed", th);
            sendError("init_failed", safeMsg(th), 0);
        }
    }

    public static void signIn() {
        runOnUiThread(new Runnable() {
            @Override
            public final void run() {
                PGSManager.lambda$signIn$3();
            }
        });
    }

    static void lambda$signIn$3() {
        if (!isPlayServicesAvailable()) {
            sendError("play_services_unavailable", "Google Play services not available or outdated", playServicesStatusCode());
            return;
        }
        ensureInitialized();
        final GamesSignInClient gamesSignInClient = PlayGames.getGamesSignInClient(activity());
        gamesSignInClient.isAuthenticated().addOnCompleteListener(new OnCompleteListener() {
            @Override
            public final void onComplete(Task task) {
                PGSManager.lambda$signIn$2(gamesSignInClient, task);
            }
        });
    }

    static void lambda$signIn$2(GamesSignInClient gamesSignInClient, Task task) {
        if (task.isSuccessful() && task.getResult() != null && ((AuthenticationResult) task.getResult()).isAuthenticated()) {
            sAuthenticated = true;
            fetchPlayerAndNotifyAuthSuccess();
        } else {
            gamesSignInClient.signIn().addOnCompleteListener(new OnCompleteListener() {
                @Override
                public final void onComplete(Task task2) {
                    PGSManager.lambda$signIn$1(task2);
                }
            });
        }
    }

    static void lambda$signIn$1(Task task) {
        boolean z = task.isSuccessful() && task.getResult() != null && ((AuthenticationResult) task.getResult()).isAuthenticated();
        sAuthenticated = z;
        if (z) {
            fetchPlayerAndNotifyAuthSuccess();
        } else {
            sendAuthResult(false, null, null, null, statusFromException(task.getException()), safeMsg(task.getException()));
        }
    }

    public static void signInSilently() {
        runOnUiThread(new Runnable() {
            @Override
            public final void run() {
                PGSManager.lambda$signInSilently$5();
            }
        });
    }

    static void lambda$signInSilently$5() {
        if (!isPlayServicesAvailable()) {
            sendError("play_services_unavailable", "Google Play services not available or outdated", playServicesStatusCode());
        } else {
            ensureInitialized();
            PlayGames.getGamesSignInClient(activity()).isAuthenticated().addOnCompleteListener(new OnCompleteListener() {
                @Override
                public final void onComplete(Task task) {
                    PGSManager.lambda$signInSilently$4(task);
                }
            });
        }
    }

    static void lambda$signInSilently$4(Task task) {
        boolean z = task.isSuccessful() && task.getResult() != null && ((AuthenticationResult) task.getResult()).isAuthenticated();
        sAuthenticated = z;
        if (z) {
            Log.i(TAG, "Silent sign-in successful (user was already authenticated).");
            fetchPlayerAndNotifyAuthSuccess();
        } else {
            Log.w(TAG, "Silent sign-in failed. User is not authenticated or needs to grant consent.", task.getException());
            sendAuthResult(false, null, null, null, statusFromException(task.getException()), "Silent sign-in failed.");
        }
    }

    public static void showAchievementsUI() {
        runOnUiThread(new Runnable() {
            @Override
            public final void run() {
                PGSManager.lambda$showAchievementsUI$8();
            }
        });
    }

    static void lambda$showAchievementsUI$8() {
        if (ensureAuthenticatedOrError()) {
            PlayGames.getAchievementsClient(activity()).getAchievementsIntent().addOnSuccessListener(new OnSuccessListener() {
                @Override
                public final void onSuccess(Object obj) {
                    PGSManager.lambda$showAchievementsUI$6((Intent) obj);
                }
            }).addOnFailureListener(new OnFailureListener() {
                @Override
                public final void onFailure(Exception exc) {
                    PGSManager.sendError("achievements_ui_failed", PGSManager.safeMsg(exc), PGSManager.statusFromException(exc));
                }
            });
        }
    }

    static void lambda$showAchievementsUI$6(Intent intent) {
        sendUiOpened("achievements", null);
        Activity activity = activity();
        if (activity != null) {
            activity.startActivityForResult(intent, RC_ACHIEVEMENTS_UI);
        }
    }

    public static void incrementAchievement(final String str, final int i) {
        runOnUiThread(new Runnable() {
            @Override
            public final void run() {
                PGSManager.lambda$incrementAchievement$10(str, i);
            }
        });
    }

    static void lambda$incrementAchievement$10(final String str, int i) {
        if (ensureAuthenticatedOrError()) {
            PlayGames.getAchievementsClient(activity()).setStepsImmediate(str, i).addOnCompleteListener(new OnCompleteListener() {
                @Override
                public final void onComplete(Task task) {
                    PGSManager.sendAchievementResult("increment", str, task.isSuccessful() && task.getResult() != null && ((Boolean) task.getResult()).booleanValue(), PGSManager.statusFromException(task.getException()), PGSManager.safeMsg(task.getException()));
                }
            });
        }
    }

    public static void showLeaderboardUI(final String str) {
        runOnUiThread(new Runnable() {
            @Override
            public final void run() {
                PGSManager.lambda$showLeaderboardUI$13(str);
            }
        });
    }

    static void lambda$showLeaderboardUI$13(final String str) {
        Task<Intent> allLeaderboardsIntent;
        if (ensureAuthenticatedOrError()) {
            LeaderboardsClient leaderboardsClient = PlayGames.getLeaderboardsClient(activity());
            if (str == null || str.isEmpty()) {
                allLeaderboardsIntent = leaderboardsClient.getAllLeaderboardsIntent();
            } else {
                allLeaderboardsIntent = leaderboardsClient.getLeaderboardIntent(str);
            }
            allLeaderboardsIntent.addOnSuccessListener(new OnSuccessListener() {
                @Override
                public final void onSuccess(Object obj) {
                    PGSManager.lambda$showLeaderboardUI$11(str, (Intent) obj);
                }
            }).addOnFailureListener(new OnFailureListener() {
                @Override
                public final void onFailure(Exception exc) {
                    PGSManager.sendError("leaderboard_ui_failed", PGSManager.safeMsg(exc), PGSManager.statusFromException(exc));
                }
            });
        }
    }

    static void lambda$showLeaderboardUI$11(String str, Intent intent) {
        sendUiOpened("leaderboard", str);
        Activity activity = activity();
        if (activity != null) {
            activity.startActivityForResult(intent, RC_LEADERBOARDS_UI);
        }
    }

    public static void submitScore(final String str, final long j) {
        runOnUiThread(new Runnable() {
            @Override
            public final void run() {
                PGSManager.lambda$submitScore$15(str, j);
            }
        });
    }

    static void lambda$submitScore$15(final String str, final long j) {
        if (ensureAuthenticatedOrError()) {
            PlayGames.getLeaderboardsClient(activity()).submitScoreImmediate(str, j).addOnCompleteListener(new OnCompleteListener() {
                @Override
                public final void onComplete(Task task) {
                    PGSManager.lambda$submitScore$14(str, j, task);
                }
            });
        }
    }

    static void lambda$submitScore$14(String str, long j, Task task) {
        boolean zIsSuccessful = task.isSuccessful();
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("action", "submit");
            jSONObject.put("leaderboardId", str);
            jSONObject.put(FirebaseAnalytics.Param.SCORE, j);
            jSONObject.put(FirebaseAnalytics.Param.SUCCESS, zIsSuccessful);
            if (!zIsSuccessful) {
                jSONObject.put("code", statusFromException(task.getException()));
                jSONObject.put("error", safeMsg(task.getException()));
            }
        } catch (JSONException unused) {
        }
        sendToUnity("OnPGSLeaderboardResult", jSONObject.toString());
    }

    public static boolean isAuthenticated() {
        return sAuthenticated;
    }

    private static void ensureInitialized() {
        if (sInitialized) {
            return;
        }
        try {
            Activity activity = activity();
            if (activity != null) {
                PlayGamesSdk.initialize(activity.getApplicationContext());
                sInitialized = true;
            }
        } catch (Throwable th) {
            Log.e(TAG, "ensureInitialized failed", th);
        }
    }

    private static boolean ensureAuthenticatedOrError() {
        if (!isPlayServicesAvailable()) {
            sendError("play_services_unavailable", "Google Play services not available or outdated", playServicesStatusCode());
            return false;
        }
        if (sAuthenticated) {
            return true;
        }
        sendError("not_signed_in", "Call signIn() first", 0);
        return false;
    }

    private static void fetchPlayerAndNotifyAuthSuccess() {
        PlayGames.getPlayersClient(activity()).getCurrentPlayer().addOnSuccessListener(new OnSuccessListener() {
            @Override
            public final void onSuccess(Object obj) {
                PGSManager.lambda$fetchPlayerAndNotifyAuthSuccess$16((Player) obj);
            }
        }).addOnFailureListener(new OnFailureListener() {
            @Override
            public final void onFailure(Exception exc) {
                PGSManager.sendAuthResult(false, null, null, null, PGSManager.statusFromException(exc), "Failed to fetch player info: " + PGSManager.safeMsg(exc));
            }
        });
    }

    static void lambda$fetchPlayerAndNotifyAuthSuccess$16(Player player) {
        String strSafe = safe(player.getPlayerId());
        String strSafe2 = safe(player.getDisplayName());
        Log.i(TAG, "Player signed in: " + strSafe2 + " (" + strSafe + ")");
        StringBuilder sb = new StringBuilder("Player signed in: ");
        sb.append(player.toString());
        Log.i(TAG, sb.toString());
        sendAuthResult(true, null, strSafe, strSafe2, 0, null);
    }

    public static void sendAuthResult(boolean z, String str, String str2, String str3, int i, String str4) {
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put(FirebaseAnalytics.Param.SUCCESS, z);
            if (str != null) {
                jSONObject.put("authCode", str);
            }
            if (str2 != null) {
                jSONObject.put("playerId", str2);
            }
            if (str3 != null) {
                jSONObject.put("displayName", str3);
            }
            if (!z) {
                jSONObject.put("code", i);
                if (str4 != null) {
                    jSONObject.put("error", str4);
                }
            }
        } catch (JSONException unused) {
        }
        if (!z) {
            Log.e(TAG, "Authentication failed: " + jSONObject.toString());
        } else {
            Log.i(TAG, "Authentication succeeded: " + jSONObject.toString());
        }
        sendToUnity("OnPGSAuthResult", jSONObject.toString());
    }

    public static void sendAchievementResult(String str, String str2, boolean z, int i, String str3) {
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("action", str);
            jSONObject.put("achievementId", str2);
            jSONObject.put(FirebaseAnalytics.Param.SUCCESS, z);
            if (!z) {
                jSONObject.put("code", i);
                if (str3 != null) {
                    jSONObject.put("error", str3);
                }
            }
        } catch (JSONException unused) {
        }
        sendToUnity("OnPGSAchievementResult", jSONObject.toString());
    }

    private static void sendUiOpened(String str, String str2) {
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put(l11l11I1111l.l111l1111l1Il, str);
            if (str2 != null) {
                jSONObject.put("leaderboardId", str2);
            }
        } catch (JSONException unused) {
        }
        sendToUnity("OnPGSUiOpened", jSONObject.toString());
    }

    public static void sendError(String str, String str2, int i) {
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put(LocalNotificationManager.PUSH_TAG, str);
            if (str2 == null) {
                str2 = "";
            }
            jSONObject.put("message", str2);
            jSONObject.put("code", i);
        } catch (JSONException unused) {
        }
        sendToUnity("OnPGSError", jSONObject.toString());
    }

    private static void sendToUnity(String str, String str2) {
        String str3 = "PGS_" + str;
        try {
            IDataSender iDataSender = sDataSenderCallback;
            if (iDataSender != null) {
                iDataSender.SendDataToGame(str3, str2 == null ? "" : str2);
                Log.d(TAG, "Data sent via callback: " + str3 + " | " + str2);
            } else {
                Log.e(TAG, "sDataSenderCallback is not set. Cannot send message to game: " + str3);
            }
        } catch (Throwable th) {
            Log.e(TAG, "Error while sending data via callback: " + str3, th);
        }
    }

    private static int statusFromException(Exception exc) {
        if (exc instanceof ApiException) {
            return ((ApiException) exc).getStatusCode();
        }
        return 0;
    }

    private static String safeMsg(Throwable th) {
        if (th == null) {
            return "";
        }
        String message = th.getMessage();
        return message == null ? th.getClass().getSimpleName() : message;
    }

    private static String safe(String str) {
        return str == null ? "" : str;
    }
}
