package com.gme.p007av.impl;

import android.app.Activity;
import android.content.Context;
import com.gme.TMG.ITMGAudioCtrl;
import com.gme.TMG.ITMGAudioEffectCtrl;
import com.gme.TMG.ITMGContext;
import com.gme.TMG.ITMGPTT;
import com.gme.TMG.ITMGRoom;
import com.gme.TMG.ITMGType;
import com.gme.liteav.base.ContextUtils;
import com.gme.liteav.base.util.C1053e;
import com.gme.p007av.jni.GMESDKJni;
import com.gme.p007av.utils.QLog;

public class TMGContext extends ITMGContext {
    public static final String TAG = "TMGContext";
    private TMGAudioCtrl mAudioCtrl;
    private TMGAudioEffectCtrl mAudioEffectCtrl;
    private Context mContext;
    private ITMGContext.ITMGDelegate mDelegate;
    private GMESDKJni mNativeSDKJni;
    private TMGPTT mPTT;
    private TMGRoom mRoom;

    public TMGContext(Context context) {
        Context applicationContext = context == null ? null : context.getApplicationContext();
        this.mContext = applicationContext;
        ContextUtils.initApplicationContext(applicationContext);
        ContextUtils.setDataDirectorySuffix("gme");
        initCloud();
        if (context instanceof Activity) {
            C1053e.m1011a().m1017a((Activity) context);
        }
    }

    private void initCloud() {
        this.mNativeSDKJni = new GMESDKJni();
        this.mRoom = new TMGRoom(this.mNativeSDKJni.getRoomJni());
        this.mAudioCtrl = new TMGAudioCtrl(this.mNativeSDKJni.getAudioJni());
        this.mAudioEffectCtrl = new TMGAudioEffectCtrl(this.mNativeSDKJni.getAudioEffectJni());
        this.mPTT = new TMGPTT(this.mNativeSDKJni.getPTTJni());
    }

    @Override
    public int Poll() {
        return this.mNativeSDKJni.poll();
    }

    @Override
    public int Pause() {
        return this.mNativeSDKJni.pause();
    }

    @Override
    public int Resume() {
        return this.mNativeSDKJni.resume();
    }

    @Override
    public int SetLogLevel(ITMGType.ITMG_LOG_LEVEL itmg_log_level, ITMGType.ITMG_LOG_LEVEL itmg_log_level2) {
        return this.mNativeSDKJni.setLogLevel(itmg_log_level.getNativeValue(), itmg_log_level2.getNativeValue());
    }

    @Override
    public int SetLogPath(String str) {
        return this.mNativeSDKJni.setLogPath(str);
    }

    @Override
    public String GetLogPath() {
        return this.mNativeSDKJni.getLogPath();
    }

    @Override
    public void SetRegion(String str) {
        this.mNativeSDKJni.setRegion(str);
    }

    @Override
    public int Init(String str, String str2) {
        return this.mNativeSDKJni.init(str, str2);
    }

    @Override
    public int Uninit() {
        return this.mNativeSDKJni.unInit();
    }

    @Override
    public int ShowDebugView(boolean z) {
        return this.mNativeSDKJni.showDebugView(z);
    }

    @Override
    public int SetTMGDelegate(ITMGContext.ITMGDelegate iTMGDelegate) {
        QLog.m911i(TAG, String.format("SetTMGDelegate.delegate=%s", iTMGDelegate));
        this.mDelegate = iTMGDelegate;
        GMESDKJni gMESDKJni = this.mNativeSDKJni;
        if (gMESDKJni != null) {
            gMESDKJni.setDelegate(iTMGDelegate);
        }
        return 0;
    }

    @Override
    public ITMGRoom GetRoom() {
        return this.mRoom;
    }

    @Override
    public ITMGAudioCtrl GetAudioCtrl() {
        return this.mAudioCtrl;
    }

    @Override
    public ITMGAudioEffectCtrl GetAudioEffectCtrl() {
        return this.mAudioEffectCtrl;
    }

    @Override
    public ITMGPTT GetPTT() {
        return this.mPTT;
    }

    @Override
    public String GetSDKVersion() {
        return this.mNativeSDKJni.getSDKVersion();
    }

    @Override
    public void SetAppVersion(String str) {
        this.mNativeSDKJni.setAppVersion(str);
    }

    @Override
    public int SetScene(ITMGType.ITMG_APP_SCENE itmg_app_scene) {
        return this.mNativeSDKJni.setScene(itmg_app_scene.getNativeValue());
    }

    @Override
    public int SetAdvanceParams(String str, String str2) {
        return this.mNativeSDKJni.setAdvanceParams(str, str2);
    }

    @Override
    public String GetAdvanceParams(String str) {
        return this.mNativeSDKJni.getAdvanceParam(str);
    }

    @Override
    public int EnterRoom(String str, ITMGType.ITMG_ROOM_TYPE itmg_room_type, byte[] bArr) {
        return this.mNativeSDKJni.enterRoom(str, itmg_room_type.getNativeValue(), bArr);
    }

    @Override
    public int ExitRoom() {
        return this.mNativeSDKJni.exitRoom();
    }

    @Override
    public boolean IsRoomEntered() {
        return this.mNativeSDKJni.isRoomEntered();
    }

    @Override
    public int SetAudioRole(ITMGType.ITMG_AUDIO_MEMBER_ROLE itmg_audio_member_role) {
        return this.mNativeSDKJni.setAudioRole(itmg_audio_member_role.getNativeValue());
    }

    @Override
    public int SetRangeAudioMode(ITMGType.ITMG_RANGE_AUDIO_MODE itmg_range_audio_mode) {
        return this.mNativeSDKJni.setRangeAudioMode(itmg_range_audio_mode.getNativeValue());
    }

    @Override
    public int SetRangeAudioTeamID(int i) {
        return this.mNativeSDKJni.setRangeAudioTeamID(i);
    }

    @Override
    public int SetRecvMixStreamCount(int i) {
        return this.mNativeSDKJni.setRecvMixStreamCount(i);
    }

    @Override
    public ITMGType.ITMG_MIC_PERMISSION CheckMicPermission() {
        return ITMGType.ITMG_MIC_PERMISSION.values()[this.mNativeSDKJni.checkMicPermission()];
    }
}
