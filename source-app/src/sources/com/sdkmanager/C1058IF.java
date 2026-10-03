package com.sdkmanager;

import android.app.Activity;
import android.content.Context;

public class C1058IF {
    private static volatile C1058IF Instance;
    private Activity mActivity;
    private String m_userGameUid = "";

    public static C1058IF getInstance() {
        if (Instance == null) {
            synchronized (C1058IF.class) {
                if (Instance == null) {
                    Instance = new C1058IF();
                }
            }
        }
        return Instance;
    }

    public Context getContext() {
        return this.mActivity;
    }

    public Activity getActivity() {
        return this.mActivity;
    }

    public void init(Activity activity) {
        this.mActivity = activity;
    }

    public void SetGameuid(String str) {
        this.m_userGameUid = str;
    }

    public String GetGameUid() {
        return this.m_userGameUid;
    }
}
