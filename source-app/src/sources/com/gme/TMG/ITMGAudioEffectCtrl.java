package com.gme.TMG;

public abstract class ITMGAudioEffectCtrl {
    public abstract int EnableMusicPlayout(long j, boolean z);

    public abstract int EnableMusicPublish(long j, boolean z);

    public abstract int GetMusicCurrentPosInMS(long j);

    public abstract int GetMusicDurationInMS(long j);

    public abstract int GetMusicPlayoutVolume(long j);

    public abstract int GetMusicPublishVolume(long j);

    public abstract boolean IsMusicPlayEnd(long j);

    public abstract int PausePlayMusic(long j);

    public abstract int ResumePlayMusic(long j);

    public abstract int SeekMusicToPosInTime(long j, int i);

    public abstract int SetAllMusicVolume(int i);

    public abstract int SetKaraokeType(ITMG_KARAOKE_TYPE itmg_karaoke_type);

    public abstract int SetMusicPitch(long j, float f);

    public abstract int SetMusicPlayoutVolume(long j, int i);

    public abstract int SetMusicPublishVolume(long j, int i);

    public abstract int SetVoiceType(ITMGType.ITMG_VOICE_TYPE itmg_voice_type);

    public abstract int StartPlayMusic(long j, String str, int i);

    public abstract int StartRecord(String str, ITMG_AUDIO_RECORDING_CONTENT itmg_audio_recording_content);

    public abstract int StopPlayMusic(long j);

    public abstract int StopRecord();

    public enum ITMG_AUDIO_RECORDING_CONTENT {
        ITMG_AUDIO_RECORDING_CONTENT_ALL(0),
        ITMG_AUDIO_RECORDING_CONTENT_LOCAL(1),
        ITMG_AUDIO_RECORDING_CONTENT_REMOTE(2);

        private int nativeValue;

        ITMG_AUDIO_RECORDING_CONTENT(int i) {
            this.nativeValue = i;
        }

        public final int getNativeValue() {
            return this.nativeValue;
        }
    }

    public enum ITMG_KARAOKE_TYPE {
        ITMG_KARAOKE_TYPE_0(0),
        ITMG_KARAOKE_TYPE_1(1),
        ITMG_KARAOKE_TYPE_2(2),
        ITMG_KARAOKE_TYPE_3(3),
        ITMG_KARAOKE_TYPE_4(4),
        ITMG_KARAOKE_TYPE_5(5),
        ITMG_KARAOKE_TYPE_6(6),
        ITMG_KARAOKE_TYPE_7(7),
        ITMG_KARAOKE_TYPE_8(8),
        ITMG_KARAOKE_TYPE_9(9),
        ITMG_KARAOKE_TYPE_10(10),
        ITMG_KARAOKE_TYPE_11(11);

        private int nativeValue;

        ITMG_KARAOKE_TYPE(int i) {
            this.nativeValue = i;
        }

        public final int getNativeValue() {
            return this.nativeValue;
        }
    }
}
