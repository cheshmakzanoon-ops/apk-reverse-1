package com.google.android.gms.games;

import com.google.android.gms.tasks.Task;

@Deprecated
public interface GamesMetadataClient {
    @Deprecated
    Task<Game> getCurrentGame();

    @Deprecated
    Task<AnnotatedData<Game>> loadGame();
}
