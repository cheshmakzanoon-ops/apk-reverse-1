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
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import kotlin.Metadata;
import kotlin.collections.ArraysKt;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.StringCompanionObject;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

@Metadata(d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\u0012\u0010\u0003\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00060\u00050\u0004¨\u0006\u0007"}, d2 = {"Lcom/facebook/gamingservices/TournamentFetcher;", "", "()V", "fetchTournaments", "Lcom/facebook/bolts/TaskCompletionSource;", "", "Lcom/facebook/gamingservices/Tournament;", "facebook-gamingservices_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class TournamentFetcher {
    public final TaskCompletionSource<List<Tournament>> fetchTournaments() {
        final TaskCompletionSource<List<Tournament>> taskCompletionSource = new TaskCompletionSource<>();
        Bundle bundle = new Bundle();
        AccessToken currentAccessToken = AccessToken.INSTANCE.getCurrentAccessToken();
        if (currentAccessToken == null || currentAccessToken.isExpired()) {
            throw new FacebookException("Attempted to fetch tournament with an invalid access token");
        }
        if (currentAccessToken.getGraphDomain() == null || !Intrinsics.areEqual(FacebookSdk.GAMING, currentAccessToken.getGraphDomain())) {
            throw new FacebookException("User is not using gaming login");
        }
        GraphRequest graphRequest = new GraphRequest(AccessToken.INSTANCE.getCurrentAccessToken(), "me/tournaments", bundle, HttpMethod.GET, new GraphRequest.Callback() {
            @Override
            public final void onCompleted(GraphResponse graphResponse) {
                TournamentFetcher.m2480fetchTournaments$lambda1(taskCompletionSource, graphResponse);
            }
        }, null, 32, null);
        graphRequest.setParameters(bundle);
        graphRequest.executeAsync();
        return taskCompletionSource;
    }

    public static final void m2480fetchTournaments$lambda1(TaskCompletionSource taskCompletionSource, GraphResponse graphResponse) {
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
        try {
            JSONObject graphObject = graphResponse.getGraphObject();
            if (graphObject == null) {
                taskCompletionSource.setError(new GraphAPIException("Failed to get response"));
                return;
            }
            JSONArray jSONArray = graphObject.getJSONArray("data");
            if (jSONArray != null && jSONArray.length() >= 1) {
                Gson gsonCreate = new GsonBuilder().create();
                String string = jSONArray.toString();
                Intrinsics.checkNotNullExpressionValue(string, "data.toString()");
                Object objFromJson = gsonCreate.fromJson(string, Tournament[].class);
                Intrinsics.checkNotNullExpressionValue(objFromJson, "gson.fromJson(dataString, Array<Tournament>::class.java)");
                taskCompletionSource.setResult(ArraysKt.toList((Object[]) objFromJson));
                return;
            }
            StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
            String str = String.format(Locale.ROOT, "No tournament found", Arrays.copyOf(new Object[]{Integer.valueOf(jSONArray.length()), 1}, 2));
            Intrinsics.checkNotNullExpressionValue(str, "java.lang.String.format(locale, format, *args)");
            taskCompletionSource.setError(new GraphAPIException(str));
        } catch (JSONException e) {
            taskCompletionSource.setError(e);
        }
    }
}
