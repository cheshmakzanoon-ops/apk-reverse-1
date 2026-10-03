package com.google.android.gms.games;

import com.google.android.gms.tasks.Task;

public interface RecallClient {
    Task<RecallAccess> requestRecallAccess();
}
