package com.googleplayservice;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.util.Log;
import com.google.android.gms.ads.identifier.AdvertisingIdClient;
import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.auth.api.signin.GoogleSignInClient;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.common.GoogleApiAvailability;
import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;

public class GooglePlayManager {
    public static final int GP_RESULT_HAS_NOT_SIGNED_IN = -2;
    public static final int GP_RESULT_UNKNOWN = -1;
    public static final int GP_REVOKE_ACCESS_SUCCESS = 2;
    public static final int GP_SET_ACCOUNT_FUNC = 9002;
    public static final int GP_SIGN_IN = 9001;
    public static final int GP_SIGN_IN_SUCCESS = 0;
    public static final int GP_SIGN_OUT_SUCCESS = 1;
    public static final String GP_USERNAME = "gp_username";
    private static volatile GooglePlayManager Instance = null;
    private static final String TAG = "GooglePlayManager";
    public boolean isAvailable;
    private Activity mActivity;
    private GoogleSignInClient mGoogleSignInClient;
    private GoogleSignInAccount mSignedInAccount;

    public interface GooglePlayRevokeAccessDelegate {
        void invoke(int i);
    }

    public interface GooglePlaySignInDelegate {
        void invoke(int i);
    }

    public interface GooglePlaySignOutDelegate {
        void invoke(int i);
    }

    public static GooglePlayManager getInstance() {
        GooglePlayManager googlePlayManager = Instance;
        if (googlePlayManager == null) {
            synchronized (GooglePlayManager.class) {
                googlePlayManager = Instance;
                if (googlePlayManager == null) {
                    googlePlayManager = new GooglePlayManager();
                    Instance = googlePlayManager;
                }
            }
        }
        return googlePlayManager;
    }

    private void Log(String str) {
        Log.d(TAG, str);
    }

    public void setGoogleNameToCache(String str) {
        Activity activity = this.mActivity;
        if (activity == null) {
            return;
        }
        SharedPreferences.Editor editorEdit = activity.getSharedPreferences(GP_USERNAME, 0).edit();
        editorEdit.putString(GP_USERNAME, str);
        editorEdit.commit();
    }

    public void init(Activity activity) {
        this.mActivity = activity;
        int iIsGooglePlayServicesAvailable = GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(this.mActivity);
        if (iIsGooglePlayServicesAvailable == 0) {
            this.isAvailable = true;
            Log("isGooglePlayServicesAvailable: " + iIsGooglePlayServicesAvailable);
            return;
        }
        Log(GoogleApiAvailability.getInstance().getErrorString(iIsGooglePlayServicesAvailable));
    }

    public String getDisplayName() {
        GoogleSignInAccount googleSignInAccount = this.mSignedInAccount;
        if (googleSignInAccount == null) {
            return "";
        }
        return googleSignInAccount.getDisplayName();
    }

    public String getId() {
        GoogleSignInAccount googleSignInAccount = this.mSignedInAccount;
        if (googleSignInAccount == null) {
            return "";
        }
        return googleSignInAccount.getId();
    }

    public String getToken() {
        GoogleSignInAccount googleSignInAccount = this.mSignedInAccount;
        if (googleSignInAccount == null) {
            return "";
        }
        return googleSignInAccount.getIdToken();
    }

    public String getEmail() {
        GoogleSignInAccount googleSignInAccount = this.mSignedInAccount;
        if (googleSignInAccount == null) {
            return "";
        }
        return googleSignInAccount.getEmail();
    }

    public Uri getPhotoUri() {
        GoogleSignInAccount googleSignInAccount = this.mSignedInAccount;
        if (googleSignInAccount != null) {
            return googleSignInAccount.getPhotoUrl();
        }
        return null;
    }

    public boolean hasSignedIn() {
        if (!this.isAvailable) {
            return false;
        }
        if (this.mSignedInAccount != null) {
            return true;
        }
        GoogleSignInAccount lastSignedInAccount = GoogleSignIn.getLastSignedInAccount(this.mActivity);
        if (lastSignedInAccount == null || !GoogleSignIn.hasPermissions(lastSignedInAccount, GoogleSignInOptions.DEFAULT_SIGN_IN.getScopeArray())) {
            return false;
        }
        this.mSignedInAccount = lastSignedInAccount;
        return true;
    }

    public void signIn(GooglePlaySignInDelegate googlePlaySignInDelegate, int i) {
        if (this.isAvailable) {
            if (!hasSignedIn()) {
                if (this.mGoogleSignInClient == null) {
                    this.mGoogleSignInClient = GoogleSignIn.getClient(this.mActivity, new GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN).requestProfile().requestIdToken("741793687453-p6nu70mq4qv0lfohepmcbt5q5fkp9rge.apps.googleusercontent.com").requestEmail().build());
                }
                this.mActivity.startActivityForResult(this.mGoogleSignInClient.getSignInIntent(), i);
                return;
            }
            googlePlaySignInDelegate.invoke(0);
        }
    }

    public void silentSignIn(final GooglePlaySignInDelegate googlePlaySignInDelegate) {
        if (this.isAvailable) {
            if (!hasSignedIn()) {
                if (this.mGoogleSignInClient == null) {
                    this.mGoogleSignInClient = GoogleSignIn.getClient(this.mActivity, GoogleSignInOptions.DEFAULT_SIGN_IN);
                }
                this.mGoogleSignInClient.silentSignIn().addOnCompleteListener(this.mActivity, new OnCompleteListener<GoogleSignInAccount>() {
                    @Override
                    public void onComplete(Task<GoogleSignInAccount> task) {
                        if (task.isSuccessful()) {
                            GooglePlayManager.this.mSignedInAccount = task.getResult();
                            googlePlaySignInDelegate.invoke(0);
                            return;
                        }
                        GooglePlayManager.this.signIn(googlePlaySignInDelegate, GooglePlayManager.GP_SIGN_IN);
                    }
                });
                return;
            }
            googlePlaySignInDelegate.invoke(0);
        }
    }

    public void signOut(final GooglePlaySignOutDelegate googlePlaySignOutDelegate) {
        if (this.isAvailable) {
            if (hasSignedIn()) {
                if (this.mGoogleSignInClient == null) {
                    this.mGoogleSignInClient = GoogleSignIn.getClient(this.mActivity, new GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN).requestProfile().build());
                }
                this.mGoogleSignInClient.signOut().addOnCompleteListener(this.mActivity, new OnCompleteListener<Void>() {
                    @Override
                    public void onComplete(Task<Void> task) {
                        if (task.isSuccessful()) {
                            GooglePlayManager.this.mSignedInAccount = null;
                            googlePlaySignOutDelegate.invoke(1);
                        } else {
                            googlePlaySignOutDelegate.invoke(-1);
                        }
                    }
                });
                return;
            }
            Log.w(TAG, "Has not signed in");
            googlePlaySignOutDelegate.invoke(-2);
        }
    }

    public void revokeAccess(final GooglePlayRevokeAccessDelegate googlePlayRevokeAccessDelegate) {
        if (this.isAvailable) {
            if (this.mGoogleSignInClient == null) {
                this.mGoogleSignInClient = GoogleSignIn.getClient(this.mActivity, GoogleSignInOptions.DEFAULT_SIGN_IN);
            }
            this.mGoogleSignInClient.revokeAccess().addOnCompleteListener(this.mActivity, new OnCompleteListener<Void>() {
                @Override
                public void onComplete(Task<Void> task) {
                    if (task.isSuccessful()) {
                        googlePlayRevokeAccessDelegate.invoke(2);
                    } else {
                        googlePlayRevokeAccessDelegate.invoke(-1);
                    }
                }
            });
        }
    }

    public void checkSignInResultFromIntent(Intent intent, GooglePlaySignInDelegate googlePlaySignInDelegate) {
        handleSignInResult(GoogleSignIn.getSignedInAccountFromIntent(intent), googlePlaySignInDelegate);
    }

    private void handleSignInResult(Task<GoogleSignInAccount> task, GooglePlaySignInDelegate googlePlaySignInDelegate) {
        try {
            this.mSignedInAccount = task.getResult(ApiException.class);
            googlePlaySignInDelegate.invoke(0);
        } catch (ApiException e) {
            Log.e("ChangeBind!", "原生  Google返回异常：" + e.getStatusCode());
            googlePlaySignInDelegate.invoke(e.getStatusCode());
        }
    }

    public String getAdvertisingId() {
        try {
            return AdvertisingIdClient.getAdvertisingIdInfo(this.mActivity.getApplicationContext()).getId();
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    public boolean isLimitAdTrackingEnabled() {
        try {
            return AdvertisingIdClient.getAdvertisingIdInfo(this.mActivity.getApplicationContext()).isLimitAdTrackingEnabled();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
