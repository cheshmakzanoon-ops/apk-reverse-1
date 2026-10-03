package com.gme.p007av.impl;

import com.gme.TMG.ITMGRoom;
import com.gme.TMG.ITMGType;
import com.gme.p007av.jni.GMESDKRoomJni;

public class TMGRoom extends ITMGRoom {
    public static final String TAG = "TMGRoom";
    private final GMESDKRoomJni mNativeRoomJni;

    TMGRoom(GMESDKRoomJni gMESDKRoomJni) {
        this.mNativeRoomJni = gMESDKRoomJni;
    }

    @Override
    public String GetRoomID() {
        return this.mNativeRoomJni.getRoomID();
    }

    @Override
    public int StartRoomSharing(String str, String str2, byte[] bArr) {
        return this.mNativeRoomJni.startRoomSharing(str, str2, bArr);
    }

    @Override
    public int StopRoomSharing() {
        return this.mNativeRoomJni.stopRoomSharing();
    }

    @Override
    public int ChangeRoomType(ITMGType.ITMG_ROOM_TYPE itmg_room_type) {
        return this.mNativeRoomJni.changeRoomType(itmg_room_type.getNativeValue());
    }

    @Override
    public int GetRoomType() {
        return this.mNativeRoomJni.getRoomType();
    }

    @Override
    public int SwitchRoom(String str, byte[] bArr) {
        return this.mNativeRoomJni.switchRoom(str, bArr);
    }

    @Override
    public int SendCustomData(byte[] bArr, int i) {
        return this.mNativeRoomJni.sendCustomData(bArr, i);
    }

    @Override
    public int StopSendCustomData() {
        return this.mNativeRoomJni.stopSendCustomData();
    }

    @Override
    public int UpdateAudioRecvRange(float f) {
        return this.mNativeRoomJni.updateAudioRecvRange(f);
    }

    @Override
    public int UpdateSelfPosition(float[] fArr, float[] fArr2, float[] fArr3, float[] fArr4) {
        return this.mNativeRoomJni.updateSelfPosition(fArr, fArr2, fArr3, fArr4);
    }

    @Override
    public int UpdateSpatializerRecvRange(float f) {
        return this.mNativeRoomJni.updateSpatializerRecvRange(f);
    }

    @Override
    public int UpdateOtherPosition(String str, float[] fArr) {
        return this.mNativeRoomJni.updateOtherPosition(str, fArr);
    }

    @Override
    public int SendSEIMsg(String str, int i) {
        return this.mNativeRoomJni.sendSEIMsg(str, i);
    }
}
