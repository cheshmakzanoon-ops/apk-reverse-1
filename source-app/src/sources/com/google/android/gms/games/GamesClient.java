package com.google.android.gms.games;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import com.google.android.gms.tasks.Task;

@Deprecated
public interface GamesClient {
    @Deprecated
    Task<Bundle> getActivationHint();

    @Deprecated
    Task<String> getAppId();

    @Deprecated
    Task<String> getCurrentAccountName();

    @Deprecated
    Task<Intent> getSettingsIntent();

    @Deprecated
    Task<Void> setGravityForPopups(int i);

    @Deprecated
    Task<Void> setViewForPopups(View view);
}
