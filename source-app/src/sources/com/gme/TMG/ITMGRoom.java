package com.gme.TMG;

public abstract class ITMGRoom {
    public abstract int ChangeRoomType(ITMGType.ITMG_ROOM_TYPE itmg_room_type);

    public abstract String GetRoomID();

    public abstract int GetRoomType();

    public abstract int SendCustomData(byte[] bArr, int i);

    public abstract int SendSEIMsg(String str, int i);

    public abstract int StartRoomSharing(String str, String str2, byte[] bArr);

    public abstract int StopRoomSharing();

    public abstract int StopSendCustomData();

    public abstract int SwitchRoom(String str, byte[] bArr);

    public abstract int UpdateAudioRecvRange(float f);

    public abstract int UpdateOtherPosition(String str, float[] fArr);

    public abstract int UpdateSelfPosition(float[] fArr, float[] fArr2, float[] fArr3, float[] fArr4);

    public abstract int UpdateSpatializerRecvRange(float f);
}
