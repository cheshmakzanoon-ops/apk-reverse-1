package com.gme.p007av.impl;

import com.gme.TMG.ITMGAudioCtrl;
import com.gme.TMG.ITMGType;
import com.gme.p007av.jni.GMESDKAudioJni;

public class TMGAudioCtrl extends ITMGAudioCtrl {
    public static final String TAG = "TMGAudioCtrl";
    private final GMESDKAudioJni mNativeAudioJni;

    TMGAudioCtrl(GMESDKAudioJni gMESDKAudioJni) {
        this.mNativeAudioJni = gMESDKAudioJni;
    }

    @Override
    public int EnableMic(boolean z) {
        int iEnableAudioCaptureDevice = EnableAudioCaptureDevice(z);
        int iEnableAudioSend = EnableAudioSend(z);
        if (iEnableAudioCaptureDevice == 0 && iEnableAudioSend == 0) {
            return 0;
        }
        return iEnableAudioCaptureDevice != 0 ? iEnableAudioCaptureDevice : iEnableAudioSend;
    }

    @Override
    public int GetMicState() {
        return (IsAudioCaptureDeviceEnabled() && IsAudioSendEnabled()) ? 1 : 0;
    }

    @Override
    public int EnableSpeaker(boolean z) {
        int iEnableAudioPlayDevice = EnableAudioPlayDevice(z);
        int iEnableAudioRecv = EnableAudioRecv(z);
        if (iEnableAudioPlayDevice == 0 && iEnableAudioRecv == 0) {
            return 0;
        }
        return iEnableAudioPlayDevice != 0 ? iEnableAudioPlayDevice : iEnableAudioRecv;
    }

    @Override
    public int GetSpeakerState() {
        return (IsAudioPlayDeviceEnabled() && IsAudioRecvEnabled()) ? 1 : 0;
    }

    @Override
    public int EnableAudioCaptureDevice(boolean z) {
        return this.mNativeAudioJni.enableAudioCaptureDevice(z);
    }

    @Override
    public boolean IsAudioCaptureDeviceEnabled() {
        return this.mNativeAudioJni.isAudioCaptureDeviceEnabled();
    }

    @Override
    public int EnableAudioPlayDevice(boolean z) {
        return this.mNativeAudioJni.enableAudioPlayDevice(z);
    }

    @Override
    public boolean IsAudioPlayDeviceEnabled() {
        return this.mNativeAudioJni.isAudioPlayDeviceEnabled();
    }

    @Override
    public int GetSpeakerVolumeByUserID(String str) {
        return this.mNativeAudioJni.getSpeakerVolumeByUserID(str);
    }

    @Override
    public int EnableAudioSend(boolean z) {
        return this.mNativeAudioJni.enableAudioSend(z);
    }

    @Override
    public int SetSpeakerVolumeByUserID(String str, int i) {
        return this.mNativeAudioJni.setSpeakerVolumeByUserID(str, i);
    }

    @Override
    public boolean IsAudioSendEnabled() {
        return this.mNativeAudioJni.isAudioSendEnabled();
    }

    @Override
    public int EnableAudioRecv(boolean z) {
        return this.mNativeAudioJni.enableAudioRecv(z);
    }

    @Override
    public boolean IsAudioRecvEnabled() {
        return this.mNativeAudioJni.isAudioRecvEnabled();
    }

    @Override
    public int GetMicVolume() {
        return this.mNativeAudioJni.getMicVolume();
    }

    @Override
    public int SetMicVolume(int i) {
        return this.mNativeAudioJni.setMicVolume(i);
    }

    @Override
    public int GetSpeakerVolume() {
        return this.mNativeAudioJni.getSpeakerVolume();
    }

    @Override
    public int SetSpeakerVolume(int i) {
        return this.mNativeAudioJni.setSpeakerVolume(i);
    }

    @Override
    public int EnableLoopBack(boolean z) {
        return this.mNativeAudioJni.enableLoopBack(z);
    }

    @Override
    public int SetLoopBackVolume(int i) {
        return this.mNativeAudioJni.setLoopBackVolume(i);
    }

    @Override
    public int AddAudioBlackList(String str) {
        return this.mNativeAudioJni.addAudioBlackList(str);
    }

    @Override
    public int RemoveAudioBlackList(String str) {
        return this.mNativeAudioJni.removeAudioBlackList(str);
    }

    @Override
    public boolean IsUserIDInAudioBlackList(String str) {
        return this.mNativeAudioJni.isUserIDInAudioBlackList(str);
    }

    @Override
    public int EnableCustomAudioCapture(boolean z) {
        return this.mNativeAudioJni.EnableCustomAudioCapture(z);
    }

    @Override
    public int SetAudioRoute(ITMGType.ITMG_AUDIO_ROUTE itmg_audio_route) {
        return this.mNativeAudioJni.SetAudioRoute(itmg_audio_route.getNativeValue());
    }

    @Override
    public int SendCustomAudioData(ITMGType.TMGAudioFrame tMGAudioFrame) {
        return this.mNativeAudioJni.SendCustomAudioData(tMGAudioFrame);
    }

    @Override
    public int EnableCustomAudioRendering(boolean z) {
        return this.mNativeAudioJni.EnableCustomAudioRendering(z);
    }

    @Override
    public int GetCustomAudioRenderingFrame(ITMGType.TMGAudioFrame tMGAudioFrame) {
        return this.mNativeAudioJni.GetCustomAudioRenderingFrame(tMGAudioFrame);
    }

    @Override
    public int TrackingVolume(float f) {
        return this.mNativeAudioJni.TrackingVolume(f);
    }

    @Override
    public int StopTrackingVolume() {
        return this.mNativeAudioJni.StopTrackingVolume();
    }

    @Override
    public int GetMicLevel() {
        return this.mNativeAudioJni.GetMicLevel();
    }

    @Override
    public int GetSpeakerLevel() {
        return this.mNativeAudioJni.GetSpeakerLevel();
    }

    @Override
    public int GetSendStreamLevel() {
        return this.mNativeAudioJni.GetSendStreamLevel();
    }

    @Override
    public int GetRecvStreamLevel(String str) {
        return this.mNativeAudioJni.GetRecvStreamLevel(str);
    }

    @Override
    public int InitSpatializer(String str) {
        return this.mNativeAudioJni.InitSpatializer(str);
    }

    @Override
    public int EnableSpatializer(boolean z) {
        return this.mNativeAudioJni.EnableSpatializer(z);
    }

    @Override
    public boolean IsEnableSpatializer() {
        return this.mNativeAudioJni.IsEnableSpatializer();
    }

    @Override
    public void SetAudioFrameCallback(ITMGAudioCtrl.ITMGAudioFrameCallback iTMGAudioFrameCallback) {
        this.mNativeAudioJni.setAudioFrameCallback(iTMGAudioFrameCallback);
    }
}
