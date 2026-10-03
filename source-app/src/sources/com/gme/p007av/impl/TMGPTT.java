package com.gme.p007av.impl;

import com.gme.TMG.ITMGPTT;
import com.gme.TMG.ITMGType;
import com.gme.p007av.jni.GMESDKPTTJni;

public class TMGPTT extends ITMGPTT {
    public static final String TAG = TMGAudioCtrl.TAG;
    private final GMESDKPTTJni mNativePttJni;

    TMGPTT(GMESDKPTTJni gMESDKPTTJni) {
        this.mNativePttJni = gMESDKPTTJni;
    }

    @Override
    public int ApplyPTTAuthbuffer(byte[] bArr) {
        return this.mNativePttJni.applyPTTAuthbuffer(bArr);
    }

    @Override
    public int SetMaxMessageLength(int i) {
        return this.mNativePttJni.setMaxMessageLength(i);
    }

    @Override
    public int StartRecording(String str) {
        return this.mNativePttJni.startRecording(str);
    }

    @Override
    public int StopRecording() {
        return this.mNativePttJni.stopRecording();
    }

    @Override
    public int CancelRecording() {
        return this.mNativePttJni.cancelRecording();
    }

    @Override
    public int UploadRecordedFile(String str) {
        return this.mNativePttJni.uploadRecordedFile(str);
    }

    @Override
    public int DownloadRecordedFile(String str, String str2) {
        return this.mNativePttJni.downloadRecordedFile(str, str2);
    }

    @Override
    public int PlayRecordedFile(String str) {
        return this.mNativePttJni.playRecordedFile(str, ITMGType.ITMG_VOICE_TYPE.ITMG_VOICE_TYPE_ORIGINAL_SOUND.getNativeValue());
    }

    @Override
    public int PlayRecordedFile(String str, ITMGType.ITMG_VOICE_TYPE itmg_voice_type) {
        return this.mNativePttJni.playRecordedFile(str, itmg_voice_type.getNativeValue());
    }

    @Override
    public int StopPlayFile() {
        return this.mNativePttJni.stopPlayFile();
    }

    @Override
    public int SpeechToText(String str) {
        return this.mNativePttJni.speechToText(str);
    }

    @Override
    public int SpeechToText(String str, String str2) {
        return this.mNativePttJni.speechToText(str, str2);
    }

    @Override
    public int SpeechToText(String str, String str2, String str3) {
        return this.mNativePttJni.speechToText(str, str2, str3);
    }

    @Override
    public int TranslateText(String str, String str2, String str3) {
        return this.mNativePttJni.translateText(str, str2, str3);
    }

    @Override
    public int GetFileSize(String str) {
        return this.mNativePttJni.getFileSize(str);
    }

    @Override
    public int GetVoiceFileDuration(String str) {
        return this.mNativePttJni.getVoiceFileDuration(str);
    }

    @Override
    public int StartRecordingWithStreamingRecognition(String str) {
        return this.mNativePttJni.startRecordingWithStreamingRecognition(str);
    }

    @Override
    public int StartRecordingWithStreamingRecognition(String str, String str2) {
        return this.mNativePttJni.startRecordingWithStreamingRecognition(str, str2);
    }

    @Override
    public int StartRecordingWithStreamingRecognition(String str, String str2, String str3) {
        return this.mNativePttJni.startRecordingWithStreamingRecognition(str, str2, str3);
    }

    @Override
    public int SetPTTSourceLanguage(String str) {
        return this.mNativePttJni.setPTTSourceLanguage(str);
    }

    @Override
    public int TextToSpeech(int i, String str, String str2, String str3, float f) {
        return this.mNativePttJni.textToSpeech(i, str, str2, str3, f);
    }
}
