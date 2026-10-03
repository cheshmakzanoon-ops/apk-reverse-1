package com.gme.TMG;

import androidx.core.view.PointerIconCompat;
import com.gme.p007av.sdk.AVError;

public abstract class ITMGType {

    public static final class TMGAudioFrame {
        public ITMG_PCM_BITS_TYPE bits_type;
        public int channel;
        public byte[] data;
        public int sample_rate;
        public long timestamp;
    }

    public enum ITMG_LOG_LEVEL {
        ITMG_LOG_LEVEL_NONE(-1),
        ITMG_LOG_LEVEL_ERROR(1),
        ITMG_LOG_LEVEL_INFO(2),
        ITMG_LOG_LEVEL_DEBUG(3),
        ITMG_LOG_LEVEL_VERBOSE(4);

        private int nativeValue;

        ITMG_LOG_LEVEL(int i) {
            this.nativeValue = i;
        }

        public final int getNativeValue() {
            return this.nativeValue;
        }
    }

    public enum ITMG_APP_SCENE {
        ITMG_APP_SCENE_RTC(2),
        ITMG_APP_SCENE_LIVE(3);

        private int nativeValue;

        ITMG_APP_SCENE(int i) {
            this.nativeValue = i;
        }

        public final int getNativeValue() {
            return this.nativeValue;
        }
    }

    public enum ITMG_AUDIO_MEMBER_ROLE {
        ITMG_AUDIO_MEMBER_ROLE_ANCHOR(0),
        ITMG_AUDIO_MEMBER_ROLE_AUDIENCE(1);

        private int nativeValue;

        ITMG_AUDIO_MEMBER_ROLE(int i) {
            this.nativeValue = i;
        }

        public final int getNativeValue() {
            return this.nativeValue;
        }
    }

    public enum ITMG_ROOM_TYPE {
        ITMG_ROOM_TYPE_FLUENCY(1),
        ITMG_ROOM_TYPE_STANDARD(2),
        ITMG_ROOM_TYPE_HIGHQUALITY(3);

        private int nativeValue;

        ITMG_ROOM_TYPE(int i) {
            this.nativeValue = i;
        }

        public final int getNativeValue() {
            return this.nativeValue;
        }
    }

    public enum ITMG_MAIN_EVENT_TYPE {
        ITMG_MAIN_EVENT_TYPE_ENTER_ROOM(1),
        ITMG_MAIN_EVENT_TYPE_EXIT_ROOM(2),
        ITMG_MAIN_EVENT_TYPE_ROOM_DISCONNECT(3),
        ITMG_MAIN_EVENT_TYPE_USER_UPDATE(4),
        ITMG_MAIN_EVENT_TYPE_NUMBER_OF_USERS_UPDATE(7),
        ITMG_MAIN_EVENT_TYPE_NUMBER_OF_AUDIOSTREAMS_UPDATE(8),
        ITMG_MAIN_EVENT_TYPE_RECONNECT_START(11),
        ITMG_MAIN_EVENT_TYPE_RECONNECT_SUCCESS(12),
        ITMG_MAIN_EVENT_TYPE_SWITCH_ROOM(13),
        ITMG_MAIN_EVENT_TYPE_SET_AUDIO_ROLE(14),
        ITMG_MAIN_EVENT_TYPE_CHANGE_ROOM_TYPE(21),
        ITMG_MAIN_EVENT_TYPE_AUDIO_DATA_EMPTY(22),
        ITMG_MAIN_EVENT_TYPE_ROOM_SHARING_START(23),
        ITMG_MAIN_EVENT_TYPE_ROOM_SHARING_STOP(24),
        ITMG_MAIN_EVENT_TYPE_RECORD_COMPLETED(30),
        ITMG_MAIN_EVENT_TYPE_IOS_MUTE_SWITCH_RESULT(34),
        ITMG_MAIN_EVENT_TYPE_SPEAKER_DEFAULT_DEVICE_CHANGED(1008),
        ITMG_MAIN_EVENT_TYPE_SPEAKER_NEW_DEVICE(1009),
        ITMG_MAIN_EVENT_TYPE_SPEAKER_LOST_DEVICE(PointerIconCompat.TYPE_ALIAS),
        ITMG_MAIN_EVENT_TYPE_MIC_NEW_DEVICE(PointerIconCompat.TYPE_COPY),
        ITMG_MAIN_EVENT_TYPE_MIC_LOST_DEVICE(PointerIconCompat.TYPE_NO_DROP),
        ITMG_MAIN_EVENT_TYPE_MIC_DEFAULT_DEVICE_CHANGED(PointerIconCompat.TYPE_ALL_SCROLL),
        ITMG_MAIN_EVENT_TYPE_SYSTEM_LOOPBACK_START_FAILED(PointerIconCompat.TYPE_HORIZONTAL_DOUBLE_ARROW),
        ITMG_MAIN_EVENT_TYPE_USER_VOLUMES(PointerIconCompat.TYPE_GRAB),
        ITMG_MAIN_EVENT_TYPE_NETWORK_QUALITY(PointerIconCompat.TYPE_GRABBING),
        ITMG_MAIN_EVENT_TYPE_CHANGE_ROOM_QUALITY(1022),
        ITMG_MAIN_EVENT_TYPE_USER_SPECTRUMS(1023),
        ITMG_MAIN_EVENT_TYPE_USER_VAD(1024),
        ITMG_MAIN_EVENT_TYPE_MUSIC_PLAY_START(1087),
        ITMG_MAIN_EVENT_TYPE_MUSIC_PLAY_PROGRESS(1088),
        ITMG_MAIN_EVENT_TYPE_MUSIC_PLAY_PAUSE(1089),
        ITMG_MAIN_EVENT_TYPE_MUSIC_PLAY_RESUME(1090),
        ITMG_MAIN_EVENT_TYPE_MUSIC_PLAY_FINISH(1091),
        ITMG_MAIN_EVENT_TYPE_CUSTOMDATA_UPDATE(1092),
        ITMG_MAIN_EVENT_TYPE_RECV_SEI_MSG(1093),
        ITMG_MAIN_EVENT_TYPE_PTT_RECORD_FIRST_FRAME(5000),
        ITMG_MAIN_EVENT_TYPE_PTT_RECORD_COMPLETE(AVError.AV_ERR_RECORD_CREATEFILE_FAILED),
        ITMG_MAIN_EVENT_TYPE_PTT_UPLOAD_COMPLETE(AVError.AV_ERR_RECORD_FILE_FORAMT_NOTSUPPORT),
        ITMG_MAIN_EVENT_TYPE_PTT_DOWNLOAD_COMPLETE(AVError.AV_ERR_RECORD_START_FAILED),
        ITMG_MAIN_EVENT_TYPE_PTT_PLAY_COMPLETE(5004),
        ITMG_MAIN_EVENT_TYPE_PTT_SPEECH2TEXT_COMPLETE(5005),
        ITMG_MAIN_EVENT_TYPE_PTT_STREAMINGRECOGNITION_COMPLETE(5006),
        ITMG_MAIN_EVENT_TYPE_PTT_STREAMINGRECOGNITION_IS_RUNNING(5007),
        ITMG_MAIN_EVENT_TYPE_PTT_TEXT2SPEECH_COMPLETE(5008),
        ITMG_MAIN_EVENT_TYPE_PTT_TRANSLATE_TEXT_COMPLETE(5009),
        ITMG_MAIN_EVENT_TYPE_ROOM_MANAGEMENT_OPERATOR(6000);

        private int nativeValue;

        ITMG_MAIN_EVENT_TYPE(int i) {
            this.nativeValue = i;
        }

        public final int getNativeValue() {
            return this.nativeValue;
        }
    }

    public enum ITMG_CUSTOMDATA_SUB_EVENT {
        ITMG_CUSTOMDATA_AV_SUB_EVENT_UPDATE(0),
        ITMG_CUSTOMDATA_AV_SUB_EVENT_AI_CONVERSATION(1);

        private int nativeValue;

        ITMG_CUSTOMDATA_SUB_EVENT(int i) {
            this.nativeValue = i;
        }

        public final int getNativeValue() {
            return this.nativeValue;
        }
    }

    public enum ITMG_RANGE_AUDIO_MODE {
        ITMG_RANGE_AUDIO_MODE_SND_ALL_REC_ALL(1),
        ITMG_RANGE_AUDIO_MODE_SND_ALL_REC_BOTH(2),
        ITMG_RANGE_AUDIO_MODE_SND_TEAM_REC_TEAM(3),
        ITMG_RANGE_AUDIO_MODE_SND_TEAM_REC_PROX(4),
        ITMG_RANGE_AUDIO_MODE_SND_TEAM_REC_BOTH(5),
        ITMG_RANGE_AUDIO_MODE_SND_PROX_REC_TEAM(6),
        ITMG_RANGE_AUDIO_MODE_SND_PROX_REC_PROX(7),
        ITMG_RANGE_AUDIO_MODE_SND_PROX_REC_BOTH(8),
        ITMG_RANGE_AUDIO_MODE_SND_BOTH_REC_TEAM(9),
        ITMG_RANGE_AUDIO_MODE_SND_BOTH_REC_PROX(10),
        ITMG_RANGE_AUDIO_MODE_SND_BOTH_REC_BOTH(11);

        private int nativeValue;

        ITMG_RANGE_AUDIO_MODE(int i) {
            this.nativeValue = i;
        }

        public final int getNativeValue() {
            return this.nativeValue;
        }
    }

    public enum ITMG_EVENT_ID_USER_UPDATE {
        ITMG_EVENT_ID_USER_ENTER(1),
        ITMG_EVENT_ID_USER_EXIT(2),
        ITMG_EVENT_ID_USER_MIC_OPENED(3),
        ITMG_EVENT_ID_USER_MIC_CLOSED(4),
        ITMG_EVENT_ID_USER_HAS_AUDIO(5),
        ITMG_EVENT_ID_USER_NO_AUDIO(6);

        private int nativeValue;

        ITMG_EVENT_ID_USER_UPDATE(int i) {
            this.nativeValue = i;
        }

        public final int getNativeValue() {
            return this.nativeValue;
        }
    }

    public enum ITMG_PCM_BITS_TYPE {
        ITMG_PCM_BITS_TYPE_FIXED_16(0),
        ITMG_PCM_BITS_TYPE_FLOAT_32(1);

        private int nativeValue;

        ITMG_PCM_BITS_TYPE(int i) {
            this.nativeValue = i;
        }

        public final int getNativeValue() {
            return this.nativeValue;
        }
    }

    public enum ITMG_NETWORK_QUALITY {
        ITMG_NETWORK_QUALITY_UNKNOWN(0),
        ITMG_NETWORK_QUALITY_EXCELLENT(1),
        ITMG_NETWORK_QUALITY_GOOD(2),
        ITMG_NETWORK_QUALITY_POOR(3),
        ITMG_NETWORK_QUALITY_BAD(4),
        ITMG_NETWORK_QUALITY_VBAD(5),
        ITMG_NETWORK_QUALITY_DOWN(6);

        private int nativeValue;

        ITMG_NETWORK_QUALITY(int i) {
            this.nativeValue = i;
        }

        public final int getNativeValue() {
            return this.nativeValue;
        }
    }

    public enum ITMG_MIC_PERMISSION {
        ITMG_PERMISSION_GRANTED(0),
        ITMG_PERMISSION_Denied(1),
        ITMG_PERMISSION_NotDetermined(2);

        private int nativeValue;

        ITMG_MIC_PERMISSION(int i) {
            this.nativeValue = i;
        }

        public final int getNativeValue() {
            return this.nativeValue;
        }
    }

    public enum ITMG_AUDIO_ROUTE {
        ITMG_AUDIO_ROUTE_UNKNOWN(-1),
        ITMG_AUDIO_ROUTE_SPEAKER(0),
        ITMG_AUDIO_ROUTE_EARPIECE(1);

        private int nativeValue;

        ITMG_AUDIO_ROUTE(int i) {
            this.nativeValue = i;
        }

        public final int getNativeValue() {
            return this.nativeValue;
        }
    }

    public enum ITMG_ROOM_MANAGEMENT_OPERATOR {
        ITMG_ROOM_MANAGEMENT_MIC_OP(0),
        ITMG_ROOM_MANAGERMENT_FORBID_OP(1);

        private int nativeValue;

        ITMG_ROOM_MANAGEMENT_OPERATOR(int i) {
            this.nativeValue = i;
        }

        public final int getNativeValue() {
            return this.nativeValue;
        }
    }

    public enum ITMG_VOICE_TYPE {
        ITMG_VOICE_TYPE_ORIGINAL_SOUND(0),
        ITMG_VOICE_TYPE_KINDER_GARTEN(1),
        ITMG_VOICE_TYPE_LOLITA(2),
        ITMG_VOICE_TYPE_UNCLE(3),
        ITMG_VOICE_TYPE_HEAVY_MENTAL(4),
        ITMG_VOICE_TYPE_INFLUENZA(5),
        ITMG_VOICE_TYPE_DIALECT(6),
        ITMG_VOICE_TYPE_CAGED_ANIMAL(7),
        ITMG_VOICE_TYPE_DEAD_FATBOY(8),
        ITMG_VOICE_TYPE_STRONG_CURRENT(9),
        ITMG_VOICE_TYPE_HEAVY_MACHINE(10),
        ITMG_VOICE_TYPE_INTANGIBLE(11),
        ITMG_VOICE_TYPE_PIGSY(12),
        ITMG_VOICE_TYPE_HULK(13);

        private int nativeValue;

        ITMG_VOICE_TYPE(int i) {
            this.nativeValue = i;
        }

        public final int getNativeValue() {
            return this.nativeValue;
        }
    }
}
