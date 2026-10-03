package com.gme.TMG;

public abstract class ITMGAudioCtrl {

    public interface ITMGAudioFrameCallback {
        void OnCapturedAudioFrame(ITMGType.TMGAudioFrame tMGAudioFrame);

        void OnLocalProcessedAudioFrame(ITMGType.TMGAudioFrame tMGAudioFrame);

        void OnMixedAllAudioFrame(ITMGType.TMGAudioFrame tMGAudioFrame);

        void OnMixedPlayAudioFrame(ITMGType.TMGAudioFrame tMGAudioFrame);

        void OnPlayAudioFrame(ITMGType.TMGAudioFrame tMGAudioFrame, String str);
    }

    public abstract int AddAudioBlackList(String str);

    public abstract int EnableAudioCaptureDevice(boolean z);

    public abstract int EnableAudioPlayDevice(boolean z);

    public abstract int EnableAudioRecv(boolean z);

    public abstract int EnableAudioSend(boolean z);

    public abstract int EnableCustomAudioCapture(boolean z);

    public abstract int EnableCustomAudioRendering(boolean z);

    public abstract int EnableLoopBack(boolean z);

    public abstract int EnableMic(boolean z);

    public abstract int EnableSpatializer(boolean z);

    public abstract int EnableSpeaker(boolean z);

    public abstract int GetCustomAudioRenderingFrame(ITMGType.TMGAudioFrame tMGAudioFrame);

    public abstract int GetMicLevel();

    public abstract int GetMicState();

    public abstract int GetMicVolume();

    public abstract int GetRecvStreamLevel(String str);

    public abstract int GetSendStreamLevel();

    public abstract int GetSpeakerLevel();

    public abstract int GetSpeakerState();

    public abstract int GetSpeakerVolume();

    public abstract int GetSpeakerVolumeByUserID(String str);

    public abstract int InitSpatializer(String str);

    public abstract boolean IsAudioCaptureDeviceEnabled();

    public abstract boolean IsAudioPlayDeviceEnabled();

    public abstract boolean IsAudioRecvEnabled();

    public abstract boolean IsAudioSendEnabled();

    public abstract boolean IsEnableSpatializer();

    public abstract boolean IsUserIDInAudioBlackList(String str);

    public abstract int RemoveAudioBlackList(String str);

    public abstract int SendCustomAudioData(ITMGType.TMGAudioFrame tMGAudioFrame);

    public abstract void SetAudioFrameCallback(ITMGAudioFrameCallback iTMGAudioFrameCallback);

    public abstract int SetAudioRoute(ITMGType.ITMG_AUDIO_ROUTE itmg_audio_route);

    public abstract int SetLoopBackVolume(int i);

    public abstract int SetMicVolume(int i);

    public abstract int SetSpeakerVolume(int i);

    public abstract int SetSpeakerVolumeByUserID(String str, int i);

    public abstract int StopTrackingVolume();

    public abstract int TrackingVolume(float f);
}
