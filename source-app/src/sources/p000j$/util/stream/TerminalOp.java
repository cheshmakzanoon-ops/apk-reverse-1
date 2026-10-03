package p000j$.util.stream;

import p000j$.util.Spliterator;

interface TerminalOp {

    public abstract class CC {
        public static int $default$getOpFlags(TerminalOp terminalOp) {
            return 0;
        }
    }

    Object evaluateParallel(PipelineHelper pipelineHelper, Spliterator spliterator);

    Object evaluateSequential(PipelineHelper pipelineHelper, Spliterator spliterator);

    int getOpFlags();
}
