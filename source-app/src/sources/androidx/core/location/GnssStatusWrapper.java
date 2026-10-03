package androidx.core.location;

import android.location.GnssStatus;
import android.os.Build;
import androidx.core.graphics.ColorKt$$ExternalSyntheticApiModelOutline0;
import androidx.core.util.Preconditions;

class GnssStatusWrapper extends GnssStatusCompat {
    private final GnssStatus mWrapped;

    GnssStatusWrapper(Object obj) {
        this.mWrapped = ColorKt$$ExternalSyntheticApiModelOutline0.m122m(Preconditions.checkNotNull(ColorKt$$ExternalSyntheticApiModelOutline0.m122m(obj)));
    }

    @Override
    public int getSatelliteCount() {
        return this.mWrapped.getSatelliteCount();
    }

    @Override
    public int getConstellationType(int i) {
        return this.mWrapped.getConstellationType(i);
    }

    @Override
    public int getSvid(int i) {
        return this.mWrapped.getSvid(i);
    }

    @Override
    public float getCn0DbHz(int i) {
        return this.mWrapped.getCn0DbHz(i);
    }

    @Override
    public float getElevationDegrees(int i) {
        return this.mWrapped.getElevationDegrees(i);
    }

    @Override
    public float getAzimuthDegrees(int i) {
        return this.mWrapped.getAzimuthDegrees(i);
    }

    @Override
    public boolean hasEphemerisData(int i) {
        return this.mWrapped.hasEphemerisData(i);
    }

    @Override
    public boolean hasAlmanacData(int i) {
        return this.mWrapped.hasAlmanacData(i);
    }

    @Override
    public boolean usedInFix(int i) {
        return this.mWrapped.usedInFix(i);
    }

    @Override
    public boolean hasCarrierFrequencyHz(int i) {
        if (Build.VERSION.SDK_INT >= 26) {
            return Api26Impl.hasCarrierFrequencyHz(this.mWrapped, i);
        }
        return false;
    }

    @Override
    public float getCarrierFrequencyHz(int i) {
        if (Build.VERSION.SDK_INT >= 26) {
            return Api26Impl.getCarrierFrequencyHz(this.mWrapped, i);
        }
        throw new UnsupportedOperationException();
    }

    @Override
    public boolean hasBasebandCn0DbHz(int i) {
        if (Build.VERSION.SDK_INT >= 30) {
            return Api30Impl.hasBasebandCn0DbHz(this.mWrapped, i);
        }
        return false;
    }

    @Override
    public float getBasebandCn0DbHz(int i) {
        if (Build.VERSION.SDK_INT >= 30) {
            return Api30Impl.getBasebandCn0DbHz(this.mWrapped, i);
        }
        throw new UnsupportedOperationException();
    }

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj instanceof GnssStatusWrapper) {
            return this.mWrapped.equals(((GnssStatusWrapper) obj).mWrapped);
        }
        return false;
    }

    public int hashCode() {
        return this.mWrapped.hashCode();
    }

    static class Api26Impl {
        private Api26Impl() {
        }

        static float getCarrierFrequencyHz(GnssStatus gnssStatus, int i) {
            return gnssStatus.getCarrierFrequencyHz(i);
        }

        static boolean hasCarrierFrequencyHz(GnssStatus gnssStatus, int i) {
            return gnssStatus.hasCarrierFrequencyHz(i);
        }
    }

    static class Api30Impl {
        private Api30Impl() {
        }

        static boolean hasBasebandCn0DbHz(GnssStatus gnssStatus, int i) {
            return gnssStatus.hasBasebandCn0DbHz(i);
        }

        static float getBasebandCn0DbHz(GnssStatus gnssStatus, int i) {
            return gnssStatus.getBasebandCn0DbHz(i);
        }
    }
}
