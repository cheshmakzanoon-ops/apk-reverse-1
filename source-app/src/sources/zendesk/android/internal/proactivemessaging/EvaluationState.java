package zendesk.android.internal.proactivemessaging;

import java.util.List;
import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.Job;

@Metadata(m17d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\t\n\u0002\b\u0013\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0080\b\u0018\u00002\u00020\u0001B-\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0006\u0012\u0006\u0010\u0007\u001a\u00020\b\u0012\b\b\u0002\u0010\t\u001a\u00020\b¢\u0006\u0002\u0010\nJ\u000f\u0010\u0016\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\t\u0010\u0017\u001a\u00020\u0006HÆ\u0003J\t\u0010\u0018\u001a\u00020\bHÆ\u0003J\t\u0010\u0019\u001a\u00020\bHÆ\u0003J7\u0010\u001a\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00062\b\b\u0002\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\t\u001a\u00020\bHÆ\u0001J\u0013\u0010\u001b\u001a\u00020\u001c2\b\u0010\u001d\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u001e\u001a\u00020\u001fHÖ\u0001J\t\u0010 \u001a\u00020!HÖ\u0001R\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u001a\u0010\u0005\u001a\u00020\u0006X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\r\u0010\u000e\"\u0004\b\u000f\u0010\u0010R\u001a\u0010\t\u001a\u00020\bX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0011\u0010\u0012\"\u0004\b\u0013\u0010\u0014R\u0011\u0010\u0007\u001a\u00020\b¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0012¨\u0006\""}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/EvaluationState;", "", "evaluationResults", "", "Lzendesk/android/internal/proactivemessaging/EvaluationResult;", "job", "Lkotlinx/coroutines/Job;", "startTime", "", "remainingSeconds", "(Ljava/util/List;Lkotlinx/coroutines/Job;JJ)V", "getEvaluationResults", "()Ljava/util/List;", "getJob", "()Lkotlinx/coroutines/Job;", "setJob", "(Lkotlinx/coroutines/Job;)V", "getRemainingSeconds", "()J", "setRemainingSeconds", "(J)V", "getStartTime", "component1", "component2", "component3", "component4", "copy", "equals", "", "other", "hashCode", "", "toString", "", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class EvaluationState {
    private final List<EvaluationResult> evaluationResults;
    private Job job;
    private long remainingSeconds;
    private final long startTime;

    public static EvaluationState copy$default(EvaluationState evaluationState, List list, Job job, long j, long j2, int i, Object obj) {
        if ((i & 1) != 0) {
            list = evaluationState.evaluationResults;
        }
        if ((i & 2) != 0) {
            job = evaluationState.job;
        }
        Job job2 = job;
        if ((i & 4) != 0) {
            j = evaluationState.startTime;
        }
        long j3 = j;
        if ((i & 8) != 0) {
            j2 = evaluationState.remainingSeconds;
        }
        return evaluationState.copy(list, job2, j3, j2);
    }

    public final List<EvaluationResult> component1() {
        return this.evaluationResults;
    }

    public final Job getJob() {
        return this.job;
    }

    public final long getStartTime() {
        return this.startTime;
    }

    public final long getRemainingSeconds() {
        return this.remainingSeconds;
    }

    public final EvaluationState copy(List<EvaluationResult> evaluationResults, Job job, long startTime, long remainingSeconds) {
        Intrinsics.checkNotNullParameter(evaluationResults, "evaluationResults");
        Intrinsics.checkNotNullParameter(job, "job");
        return new EvaluationState(evaluationResults, job, startTime, remainingSeconds);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof EvaluationState)) {
            return false;
        }
        EvaluationState evaluationState = (EvaluationState) other;
        return Intrinsics.areEqual(this.evaluationResults, evaluationState.evaluationResults) && Intrinsics.areEqual(this.job, evaluationState.job) && this.startTime == evaluationState.startTime && this.remainingSeconds == evaluationState.remainingSeconds;
    }

    public int hashCode() {
        return (((((this.evaluationResults.hashCode() * 31) + this.job.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m27m(this.startTime)) * 31) + UByte$$ExternalSyntheticBackport0.m27m(this.remainingSeconds);
    }

    public String toString() {
        return "EvaluationState(evaluationResults=" + this.evaluationResults + ", job=" + this.job + ", startTime=" + this.startTime + ", remainingSeconds=" + this.remainingSeconds + ')';
    }

    public EvaluationState(List<EvaluationResult> evaluationResults, Job job, long j, long j2) {
        Intrinsics.checkNotNullParameter(evaluationResults, "evaluationResults");
        Intrinsics.checkNotNullParameter(job, "job");
        this.evaluationResults = evaluationResults;
        this.job = job;
        this.startTime = j;
        this.remainingSeconds = j2;
    }

    public EvaluationState(List list, Job job, long j, long j2, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(list, job, j, (i & 8) != 0 ? -1L : j2);
    }

    public final List<EvaluationResult> getEvaluationResults() {
        return this.evaluationResults;
    }

    public final Job getJob() {
        return this.job;
    }

    public final void setJob(Job job) {
        Intrinsics.checkNotNullParameter(job, "<set-?>");
        this.job = job;
    }

    public final long getStartTime() {
        return this.startTime;
    }

    public final long getRemainingSeconds() {
        return this.remainingSeconds;
    }

    public final void setRemainingSeconds(long j) {
        this.remainingSeconds = j;
    }
}
