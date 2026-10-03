package com.gme.TMG;

public abstract class ITMGPTT {
    public abstract int ApplyPTTAuthbuffer(byte[] bArr);

    public abstract int CancelRecording();

    public abstract int DownloadRecordedFile(String str, String str2);

    public abstract int GetFileSize(String str);

    public abstract int GetVoiceFileDuration(String str);

    public abstract int PlayRecordedFile(String str);

    public abstract int PlayRecordedFile(String str, ITMGType.ITMG_VOICE_TYPE itmg_voice_type);

    public abstract int SetMaxMessageLength(int i);

    public abstract int SetPTTSourceLanguage(String str);

    public abstract int SpeechToText(String str);

    public abstract int SpeechToText(String str, String str2);

    public abstract int SpeechToText(String str, String str2, String str3);

    public abstract int StartRecording(String str);

    public abstract int StartRecordingWithStreamingRecognition(String str);

    public abstract int StartRecordingWithStreamingRecognition(String str, String str2);

    public abstract int StartRecordingWithStreamingRecognition(String str, String str2, String str3);

    public abstract int StopPlayFile();

    public abstract int StopRecording();

    public abstract int TextToSpeech(int i, String str, String str2, String str3, float f);

    public abstract int TranslateText(String str, String str2, String str3);

    public abstract int UploadRecordedFile(String str);
}
