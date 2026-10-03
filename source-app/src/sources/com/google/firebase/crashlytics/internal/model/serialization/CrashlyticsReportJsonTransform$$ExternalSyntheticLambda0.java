package com.google.firebase.crashlytics.internal.model.serialization;

import android.util.JsonReader;

public final class CrashlyticsReportJsonTransform$$ExternalSyntheticLambda0 implements CrashlyticsReportJsonTransform.ObjectParser {
    @Override
    public final Object parse(JsonReader jsonReader) {
        return CrashlyticsReportJsonTransform.parseEventFrame(jsonReader);
    }
}
