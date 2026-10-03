package com.gme.TMG;

import android.content.Context;
import android.content.Intent;
import com.gme.p007av.impl.TMGContext;

public abstract class ITMGContext {
    private static ITMGContext mSelf;

    public static abstract class ITMGDelegate {
        public void OnEvent(ITMGType.ITMG_MAIN_EVENT_TYPE itmg_main_event_type, Intent intent) {
        }
    }

    public abstract ITMGType.ITMG_MIC_PERMISSION CheckMicPermission();

    public abstract int EnterRoom(String str, ITMGType.ITMG_ROOM_TYPE itmg_room_type, byte[] bArr);

    public abstract int ExitRoom();

    public abstract String GetAdvanceParams(String str);

    public abstract ITMGAudioCtrl GetAudioCtrl();

    public abstract ITMGAudioEffectCtrl GetAudioEffectCtrl();

    public abstract String GetLogPath();

    public abstract ITMGPTT GetPTT();

    public abstract ITMGRoom GetRoom();

    public abstract String GetSDKVersion();

    public abstract int Init(String str, String str2);

    public abstract boolean IsRoomEntered();

    public abstract int Pause();

    public abstract int Poll();

    public abstract int Resume();

    public abstract int SetAdvanceParams(String str, String str2);

    public abstract void SetAppVersion(String str);

    public abstract int SetAudioRole(ITMGType.ITMG_AUDIO_MEMBER_ROLE itmg_audio_member_role);

    public abstract int SetLogLevel(ITMGType.ITMG_LOG_LEVEL itmg_log_level, ITMGType.ITMG_LOG_LEVEL itmg_log_level2);

    public abstract int SetLogPath(String str);

    public abstract int SetRangeAudioMode(ITMGType.ITMG_RANGE_AUDIO_MODE itmg_range_audio_mode);

    public abstract int SetRangeAudioTeamID(int i);

    public abstract int SetRecvMixStreamCount(int i);

    public abstract void SetRegion(String str);

    public abstract int SetScene(ITMGType.ITMG_APP_SCENE itmg_app_scene);

    public abstract int SetTMGDelegate(ITMGDelegate iTMGDelegate);

    public abstract int ShowDebugView(boolean z);

    public abstract int Uninit();

    public static ITMGContext GetInstance(Context context) {
        if (mSelf == null && context != null) {
            mSelf = new TMGContext(context);
        }
        return mSelf;
    }
}
