package net.aihelp.data.model.rpa.msg.bot;

import android.os.Parcel;
import android.os.Parcelable;

public class SelfService implements Parcelable {
    public static final Parcelable.Creator<SelfService> CREATOR = new Parcelable.Creator<SelfService>() {
        @Override
        public SelfService createFromParcel(Parcel parcel) {
            return new SelfService(parcel);
        }

        @Override
        public SelfService[] newArray(int i) {
            return new SelfService[i];
        }
    };
    private final boolean enableSend;
    private final String selfServiceData;

    @Override
    public int describeContents() {
        return 0;
    }

    public SelfService(boolean z, String str) {
        this.enableSend = z;
        this.selfServiceData = str;
    }

    protected SelfService(Parcel parcel) {
        this.enableSend = parcel.readByte() != 0;
        this.selfServiceData = parcel.readString();
    }

    public boolean isEnableSend() {
        return this.enableSend;
    }

    public String getSelfServiceData() {
        return this.selfServiceData;
    }

    @Override
    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeByte(this.enableSend ? (byte) 1 : (byte) 0);
        parcel.writeString(this.selfServiceData);
    }
}
