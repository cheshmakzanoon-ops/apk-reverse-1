package com.yalantis.ucrop;

public interface UCropFragmentCallback {
    void loadingProgress(boolean z);

    void onCropFinish(UCropFragment.UCropResult uCropResult);
}
