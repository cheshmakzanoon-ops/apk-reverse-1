package com.google.android.gms.games;

import com.google.android.gms.games.gamessignin.AuthResponse;
import com.google.android.gms.games.gamessignin.AuthScope;
import com.google.android.gms.tasks.Task;
import java.util.List;

public interface GamesSignInClient {
    Task<AuthenticationResult> isAuthenticated();

    Task<String> requestServerSideAccess(String str, boolean z);

    Task<AuthResponse> requestServerSideAccess(String str, boolean z, List<AuthScope> list);

    Task<AuthenticationResult> signIn();
}
