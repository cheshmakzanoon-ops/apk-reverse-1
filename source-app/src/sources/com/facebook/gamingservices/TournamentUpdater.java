package com.facebook.gamingservices;

import android.os.Bundle;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.AccessToken;
import com.facebook.FacebookException;
import com.facebook.FacebookRequestError;
import com.facebook.FacebookSdk;
import com.facebook.GraphRequest;
import com.facebook.GraphResponse;
import com.facebook.HttpMethod;
import com.facebook.bolts.TaskCompletionSource;
import com.facebook.internal.ServerProtocol;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import org.json.JSONObject;

@Metadata(d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0004\n\u0000\n\u0002\u0010\u000e\n\u0000\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\u001e\u0010\u0003\u001a\n\u0012\u0004\u0012\u00020\u0005\u0018\u00010\u00042\u0006\u0010\u0006\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\tJ\u001e\u0010\u0003\u001a\n\u0012\u0004\u0012\u00020\u0005\u0018\u00010\u00042\u0006\u0010\n\u001a\u00020\u000b2\u0006\u0010\b\u001a\u00020\t¨\u0006\f"}, d2 = {"Lcom/facebook/gamingservices/TournamentUpdater;", "", "()V", "update", "Lcom/facebook/bolts/TaskCompletionSource;", "", "tournament", "Lcom/facebook/gamingservices/Tournament;", "score", "", "identifier", "", "facebook-gamingservices_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class TournamentUpdater {
    public final TaskCompletionSource<Boolean> update(Tournament tournament, Number score) {
        Intrinsics.checkNotNullParameter(tournament, "tournament");
        Intrinsics.checkNotNullParameter(score, "score");
        return update(tournament.identifier, score);
    }

    public final TaskCompletionSource<Boolean> update(String identifier, Number score) {
        Intrinsics.checkNotNullParameter(identifier, "identifier");
        Intrinsics.checkNotNullParameter(score, "score");
        AccessToken currentAccessToken = AccessToken.INSTANCE.getCurrentAccessToken();
        if (currentAccessToken == null || currentAccessToken.isExpired()) {
            throw new FacebookException("Attempted to fetch tournament with an invalid access token");
        }
        if (currentAccessToken.getGraphDomain() == null || !Intrinsics.areEqual(FacebookSdk.GAMING, currentAccessToken.getGraphDomain())) {
            throw new FacebookException("User is not using gaming login");
        }
        final TaskCompletionSource<Boolean> taskCompletionSource = new TaskCompletionSource<>();
        String strStringPlus = Intrinsics.stringPlus(identifier, "/update_score");
        Bundle bundle = new Bundle();
        bundle.putInt("score", score.intValue());
        new GraphRequest(currentAccessToken, strStringPlus, bundle, HttpMethod.POST, new GraphRequest.Callback() {
            @Override
            public final void onCompleted(GraphResponse graphResponse) {
                TournamentUpdater.m2484update$lambda0(taskCompletionSource, graphResponse);
            }
        }, null, 32, null).executeAsync();
        return taskCompletionSource;
    }

    public static final void m2484update$lambda0(TaskCompletionSource taskCompletionSource, GraphResponse graphResponse) {
        Intrinsics.checkNotNullParameter(taskCompletionSource, "$task");
        Intrinsics.checkNotNullParameter(graphResponse, "response");
        if (graphResponse.getError() != null) {
            FacebookRequestError error = graphResponse.getError();
            if ((error == null ? null : error.getException()) != null) {
                FacebookRequestError error2 = graphResponse.getError();
                taskCompletionSource.setError(error2 != null ? error2.getException() : null);
                return;
            } else {
                taskCompletionSource.setError(new GraphAPIException("Graph API Error"));
                return;
            }
        }
        JSONObject graphObject = graphResponse.getGraphObject();
        String strOptString = graphObject != null ? graphObject.optString(GraphResponse.SUCCESS_KEY) : null;
        if (strOptString == null || strOptString.length() == 0) {
            taskCompletionSource.setError(new GraphAPIException("Graph API Error"));
        } else {
            taskCompletionSource.setResult(Boolean.valueOf(strOptString.equals(ServerProtocol.DIALOG_RETURN_SCOPES_TRUE)));
        }
    }
}
