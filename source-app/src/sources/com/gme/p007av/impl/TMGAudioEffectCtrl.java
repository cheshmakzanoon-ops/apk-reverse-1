package com.gme.p007av.impl;

import com.gme.TMG.ITMGAudioEffectCtrl;
import com.gme.TMG.ITMGType;
import com.gme.p007av.jni.GMESDKAudioEffectJni;

public class TMGAudioEffectCtrl extends ITMGAudioEffectCtrl {
    public static final String TAG = "TMGAudioEffectCtrl";
    private final GMESDKAudioEffectJni mAudioEffectJni;

    TMGAudioEffectCtrl(GMESDKAudioEffectJni gMESDKAudioEffectJni) {
        this.mAudioEffectJni = gMESDKAudioEffectJni;
    }

    @Override
    public int SetMusicPitch(long j, float f) {
        return this.mAudioEffectJni.setMusicPitch(j, f);
    }

    @Override
    public int StartPlayMusic(long j, String str, int i) {
        return this.mAudioEffectJni.startPlayMusic(j, str, i);
    }

    @Override
    public int PausePlayMusic(long j) {
        return this.mAudioEffectJni.pausePlayMusic(j);
    }

    @Override
    public int ResumePlayMusic(long j) {
        return this.mAudioEffectJni.resumePlayMusic(j);
    }

    @Override
    public int StopPlayMusic(long j) {
        return this.mAudioEffectJni.stopPlayMusic(j);
    }

    @Override
    public boolean IsMusicPlayEnd(long j) {
        return this.mAudioEffectJni.isMusicPlayEnd(j);
    }

    @Override
    public int SetMusicPublishVolume(long j, int i) {
        return this.mAudioEffectJni.setMusicPublishVolume(j, i);
    }

    @Override
    public int GetMusicPublishVolume(long j) {
        return this.mAudioEffectJni.getMusicPublishVolume(j);
    }

    @Override
    public int SetMusicPlayoutVolume(long j, int i) {
        return this.mAudioEffectJni.setMusicPlayoutVolume(j, i);
    }

    @Override
    public int GetMusicPlayoutVolume(long j) {
        return this.mAudioEffectJni.getMusicPlayoutVolume(j);
    }

    @Override
    public int GetMusicDurationInMS(long j) {
        return this.mAudioEffectJni.getMusicDurationInMS(j);
    }

    @Override
    public int GetMusicCurrentPosInMS(long j) {
        return this.mAudioEffectJni.getMusicCurrentPosInMS(j);
    }

    @Override
    public int SetAllMusicVolume(int i) {
        return this.mAudioEffectJni.setAllMusicVolume(i);
    }

    @Override
    public int SeekMusicToPosInTime(long j, int i) {
        return this.mAudioEffectJni.seekMusicToPosInTime(j, i);
    }

    @Override
    public int EnableMusicPublish(long j, boolean z) {
        return this.mAudioEffectJni.enableMusicPublish(j, z);
    }

    @Override
    public int EnableMusicPlayout(long j, boolean z) {
        return this.mAudioEffectJni.enableMusicPlayout(j, z);
    }

    @Override
    public int StartRecord(String str, ITMGAudioEffectCtrl.ITMG_AUDIO_RECORDING_CONTENT itmg_audio_recording_content) {
        return this.mAudioEffectJni.startRecord(str, itmg_audio_recording_content.ordinal());
    }

    @Override
    public int StopRecord() {
        return this.mAudioEffectJni.stopRecord();
    }

    @Override
    public int SetVoiceType(ITMGType.ITMG_VOICE_TYPE itmg_voice_type) {
        return this.mAudioEffectJni.setVoiceType(itmg_voice_type.getNativeValue());
    }

    @Override
    public int SetKaraokeType(ITMGAudioEffectCtrl.ITMG_KARAOKE_TYPE itmg_karaoke_type) {
        return this.mAudioEffectJni.setKaraokeType(itmg_karaoke_type.getNativeValue());
    }
}
