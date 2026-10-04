/*
 * Patched copy of unluac 1.2.3.569's unluac/decompile/ControlFlowHandler.
 *
 * Provenance: recovered from tools/unluac-batch/unluac.jar with jadx, then
 * hand-fixed for the two things that stop a faithful javac round-trip, plus
 * the one behavioural fix this project needs (see is_break_jmp below).
 * Building it against the original unluac.jar means the patch tree stays
 * hermetic: only a JDK is required, not jadx.
 *
 * THE FIX (is_break_jmp): upstream reads `target == breakable.end` with no
 * null check on breakable, while six sibling call sites in the same file guard
 * it. When enclosing_breakable_block() returns null the original throws
 * NullPointerException and the chunk is lost. The guard below turns that into
 * "this jump is not a break", which is the correct answer: there is no block to
 * break out of. This is what recovered Common/mobdebug,
 * DataCenter/GiftPackageData/GiftPackInfoBase and
 * DataCenter/SeasonManager/SeasonUpgradeLogManager.
 *
 * JADX round-trip fixes:
 *   - Op.valuesCustom() -> Op.values()  (jadx renamed the enum accessor that
 *     the original source calls; unluac.jar still declares values()).
 */
package unluac.decompile;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import unluac.Version;
import unluac.decompile.block.AlwaysLoop;
import unluac.decompile.block.Block;
import unluac.decompile.block.Break;
import unluac.decompile.block.DoEndBlock;
import unluac.decompile.block.ElseEndBlock;
import unluac.decompile.block.ForBlock;
import unluac.decompile.block.ForBlock50;
import unluac.decompile.block.ForBlock51;
import unluac.decompile.block.Goto;
import unluac.decompile.block.IfThenElseBlock;
import unluac.decompile.block.IfThenEndBlock;
import unluac.decompile.block.OnceLoop;
import unluac.decompile.block.OuterBlock;
import unluac.decompile.block.RepeatBlock;
import unluac.decompile.block.SetBlock;
import unluac.decompile.block.TForBlock;
import unluac.decompile.block.WhileBlock50;
import unluac.decompile.block.WhileBlock51;
import unluac.decompile.condition.AndCondition;
import unluac.decompile.condition.BinaryCondition;
import unluac.decompile.condition.Condition;
import unluac.decompile.condition.ConstantCondition;
import unluac.decompile.condition.FinalSetCondition;
import unluac.decompile.condition.FixedCondition;
import unluac.decompile.condition.OrCondition;
import unluac.decompile.condition.TestCondition;
import unluac.decompile.expression.Expression;
import unluac.parse.LFloatNumber;
import unluac.parse.LFunction;
import unluac.test.TestFile;
import unluac.util.Stack;

/* JADX INFO: loaded from: unluac.jar:unluac/decompile/ControlFlowHandler.class */
public class ControlFlowHandler {
    public static boolean verbose = false;
    private static volatile /* synthetic */ int[] $SWITCH_TABLE$unluac$decompile$Op;

    static /* synthetic */ int[] $SWITCH_TABLE$unluac$decompile$Op() {
        int[] iArr = $SWITCH_TABLE$unluac$decompile$Op;
        if (iArr != null) {
            return iArr;
        }
        int[] iArr2 = new int[Op.values().length];
        try {
            iArr2[Op.ADD.ordinal()] = 13;
        } catch (NoSuchFieldError unused) {
        }
        try {
            iArr2[Op.ADD54.ordinal()] = 88;
        } catch (NoSuchFieldError unused2) {
        }
        try {
            iArr2[Op.ADDI.ordinal()] = 75;
        } catch (NoSuchFieldError unused3) {
        }
        try {
            iArr2[Op.ADDK.ordinal()] = 76;
        } catch (NoSuchFieldError unused4) {
        }
        try {
            iArr2[Op.BAND.ordinal()] = 54;
        } catch (NoSuchFieldError unused5) {
        }
        try {
            iArr2[Op.BAND54.ordinal()] = 95;
        } catch (NoSuchFieldError unused6) {
        }
        try {
            iArr2[Op.BANDK.ordinal()] = 83;
        } catch (NoSuchFieldError unused7) {
        }
        try {
            iArr2[Op.BNOT.ordinal()] = 59;
        } catch (NoSuchFieldError unused8) {
        }
        try {
            iArr2[Op.BOR.ordinal()] = 55;
        } catch (NoSuchFieldError unused9) {
        }
        try {
            iArr2[Op.BOR54.ordinal()] = 96;
        } catch (NoSuchFieldError unused10) {
        }
        try {
            iArr2[Op.BORK.ordinal()] = 84;
        } catch (NoSuchFieldError unused11) {
        }
        try {
            iArr2[Op.BXOR.ordinal()] = 56;
        } catch (NoSuchFieldError unused12) {
        }
        try {
            iArr2[Op.BXOR54.ordinal()] = 97;
        } catch (NoSuchFieldError unused13) {
        }
        try {
            iArr2[Op.BXORK.ordinal()] = 85;
        } catch (NoSuchFieldError unused14) {
        }
        try {
            iArr2[Op.CALL.ordinal()] = 29;
        } catch (NoSuchFieldError unused15) {
        }
        try {
            iArr2[Op.CLOSE.ordinal()] = 36;
        } catch (NoSuchFieldError unused16) {
        }
        try {
            iArr2[Op.CLOSURE.ordinal()] = 37;
        } catch (NoSuchFieldError unused17) {
        }
        try {
            iArr2[Op.CONCAT.ordinal()] = 22;
        } catch (NoSuchFieldError unused18) {
        }
        try {
            iArr2[Op.CONCAT54.ordinal()] = 103;
        } catch (NoSuchFieldError unused19) {
        }
        try {
            iArr2[Op.DEFAULT.ordinal()] = 130;
        } catch (NoSuchFieldError unused20) {
        }
        try {
            iArr2[Op.DEFAULT54.ordinal()] = 131;
        } catch (NoSuchFieldError unused21) {
        }
        try {
            iArr2[Op.DIV.ordinal()] = 16;
        } catch (NoSuchFieldError unused22) {
        }
        try {
            iArr2[Op.DIV54.ordinal()] = 93;
        } catch (NoSuchFieldError unused23) {
        }
        try {
            iArr2[Op.DIVK.ordinal()] = 81;
        } catch (NoSuchFieldError unused24) {
        }
        try {
            iArr2[Op.EQ.ordinal()] = 24;
        } catch (NoSuchFieldError unused25) {
        }
        try {
            iArr2[Op.EQ54.ordinal()] = 106;
        } catch (NoSuchFieldError unused26) {
        }
        try {
            iArr2[Op.EQI.ordinal()] = 110;
        } catch (NoSuchFieldError unused27) {
        }
        try {
            iArr2[Op.EQK.ordinal()] = 109;
        } catch (NoSuchFieldError unused28) {
        }
        try {
            iArr2[Op.EXTRAARG.ordinal()] = 47;
        } catch (NoSuchFieldError unused29) {
        }
        try {
            iArr2[Op.EXTRABYTE.ordinal()] = 129;
        } catch (NoSuchFieldError unused30) {
        }
        try {
            iArr2[Op.FORLOOP.ordinal()] = 32;
        } catch (NoSuchFieldError unused31) {
        }
        try {
            iArr2[Op.FORLOOP54.ordinal()] = 121;
        } catch (NoSuchFieldError unused32) {
        }
        try {
            iArr2[Op.FORPREP.ordinal()] = 33;
        } catch (NoSuchFieldError unused33) {
        }
        try {
            iArr2[Op.FORPREP54.ordinal()] = 122;
        } catch (NoSuchFieldError unused34) {
        }
        try {
            iArr2[Op.GEI.ordinal()] = 114;
        } catch (NoSuchFieldError unused35) {
        }
        try {
            iArr2[Op.GETFIELD.ordinal()] = 68;
        } catch (NoSuchFieldError unused36) {
        }
        try {
            iArr2[Op.GETGLOBAL.ordinal()] = 6;
        } catch (NoSuchFieldError unused37) {
        }
        try {
            iArr2[Op.GETI.ordinal()] = 67;
        } catch (NoSuchFieldError unused38) {
        }
        try {
            iArr2[Op.GETTABLE.ordinal()] = 7;
        } catch (NoSuchFieldError unused39) {
        }
        try {
            iArr2[Op.GETTABLE54.ordinal()] = 66;
        } catch (NoSuchFieldError unused40) {
        }
        try {
            iArr2[Op.GETTABUP.ordinal()] = 42;
        } catch (NoSuchFieldError unused41) {
        }
        try {
            iArr2[Op.GETTABUP54.ordinal()] = 65;
        } catch (NoSuchFieldError unused42) {
        }
        try {
            iArr2[Op.GETUPVAL.ordinal()] = 5;
        } catch (NoSuchFieldError unused43) {
        }
        try {
            iArr2[Op.GTI.ordinal()] = 113;
        } catch (NoSuchFieldError unused44) {
        }
        try {
            iArr2[Op.IDIV.ordinal()] = 53;
        } catch (NoSuchFieldError unused45) {
        }
        try {
            iArr2[Op.IDIV54.ordinal()] = 94;
        } catch (NoSuchFieldError unused46) {
        }
        try {
            iArr2[Op.IDIVK.ordinal()] = 82;
        } catch (NoSuchFieldError unused47) {
        }
        try {
            iArr2[Op.JMP.ordinal()] = 23;
        } catch (NoSuchFieldError unused48) {
        }
        try {
            iArr2[Op.JMP52.ordinal()] = 39;
        } catch (NoSuchFieldError unused49) {
        }
        try {
            iArr2[Op.JMP54.ordinal()] = 105;
        } catch (NoSuchFieldError unused50) {
        }
        try {
            iArr2[Op.LE.ordinal()] = 26;
        } catch (NoSuchFieldError unused51) {
        }
        try {
            iArr2[Op.LE54.ordinal()] = 108;
        } catch (NoSuchFieldError unused52) {
        }
        try {
            iArr2[Op.LEI.ordinal()] = 112;
        } catch (NoSuchFieldError unused53) {
        }
        try {
            iArr2[Op.LEN.ordinal()] = 21;
        } catch (NoSuchFieldError unused54) {
        }
        try {
            iArr2[Op.LFALSESKIP.ordinal()] = 63;
        } catch (NoSuchFieldError unused55) {
        }
        try {
            iArr2[Op.LOADBOOL.ordinal()] = 3;
        } catch (NoSuchFieldError unused56) {
        }
        try {
            iArr2[Op.LOADF.ordinal()] = 61;
        } catch (NoSuchFieldError unused57) {
        }
        try {
            iArr2[Op.LOADFALSE.ordinal()] = 62;
        } catch (NoSuchFieldError unused58) {
        }
        try {
            iArr2[Op.LOADI.ordinal()] = 60;
        } catch (NoSuchFieldError unused59) {
        }
        try {
            iArr2[Op.LOADK.ordinal()] = 2;
        } catch (NoSuchFieldError unused60) {
        }
        try {
            iArr2[Op.LOADKX.ordinal()] = 41;
        } catch (NoSuchFieldError unused61) {
        }
        try {
            iArr2[Op.LOADNIL.ordinal()] = 4;
        } catch (NoSuchFieldError unused62) {
        }
        try {
            iArr2[Op.LOADNIL52.ordinal()] = 40;
        } catch (NoSuchFieldError unused63) {
        }
        try {
            iArr2[Op.LOADTRUE.ordinal()] = 64;
        } catch (NoSuchFieldError unused64) {
        }
        try {
            iArr2[Op.LT.ordinal()] = 25;
        } catch (NoSuchFieldError unused65) {
        }
        try {
            iArr2[Op.LT54.ordinal()] = 107;
        } catch (NoSuchFieldError unused66) {
        }
        try {
            iArr2[Op.LTI.ordinal()] = 111;
        } catch (NoSuchFieldError unused67) {
        }
        try {
            iArr2[Op.MMBIN.ordinal()] = 100;
        } catch (NoSuchFieldError unused68) {
        }
        try {
            iArr2[Op.MMBINI.ordinal()] = 101;
        } catch (NoSuchFieldError unused69) {
        }
        try {
            iArr2[Op.MMBINK.ordinal()] = 102;
        } catch (NoSuchFieldError unused70) {
        }
        try {
            iArr2[Op.MOD.ordinal()] = 17;
        } catch (NoSuchFieldError unused71) {
        }
        try {
            iArr2[Op.MOD54.ordinal()] = 91;
        } catch (NoSuchFieldError unused72) {
        }
        try {
            iArr2[Op.MODK.ordinal()] = 79;
        } catch (NoSuchFieldError unused73) {
        }
        try {
            iArr2[Op.MOVE.ordinal()] = 1;
        } catch (NoSuchFieldError unused74) {
        }
        try {
            iArr2[Op.MUL.ordinal()] = 15;
        } catch (NoSuchFieldError unused75) {
        }
        try {
            iArr2[Op.MUL54.ordinal()] = 90;
        } catch (NoSuchFieldError unused76) {
        }
        try {
            iArr2[Op.MULK.ordinal()] = 78;
        } catch (NoSuchFieldError unused77) {
        }
        try {
            iArr2[Op.NEWTABLE.ordinal()] = 11;
        } catch (NoSuchFieldError unused78) {
        }
        try {
            iArr2[Op.NEWTABLE50.ordinal()] = 48;
        } catch (NoSuchFieldError unused79) {
        }
        try {
            iArr2[Op.NEWTABLE54.ordinal()] = 73;
        } catch (NoSuchFieldError unused80) {
        }
        try {
            iArr2[Op.NOT.ordinal()] = 20;
        } catch (NoSuchFieldError unused81) {
        }
        try {
            iArr2[Op.POW.ordinal()] = 18;
        } catch (NoSuchFieldError unused82) {
        }
        try {
            iArr2[Op.POW54.ordinal()] = 92;
        } catch (NoSuchFieldError unused83) {
        }
        try {
            iArr2[Op.POWK.ordinal()] = 80;
        } catch (NoSuchFieldError unused84) {
        }
        try {
            iArr2[Op.RETURN.ordinal()] = 31;
        } catch (NoSuchFieldError unused85) {
        }
        try {
            iArr2[Op.RETURN0.ordinal()] = 119;
        } catch (NoSuchFieldError unused86) {
        }
        try {
            iArr2[Op.RETURN1.ordinal()] = 120;
        } catch (NoSuchFieldError unused87) {
        }
        try {
            iArr2[Op.RETURN54.ordinal()] = 118;
        } catch (NoSuchFieldError unused88) {
        }
        try {
            iArr2[Op.SELF.ordinal()] = 12;
        } catch (NoSuchFieldError unused89) {
        }
        try {
            iArr2[Op.SELF54.ordinal()] = 74;
        } catch (NoSuchFieldError unused90) {
        }
        try {
            iArr2[Op.SETFIELD.ordinal()] = 72;
        } catch (NoSuchFieldError unused91) {
        }
        try {
            iArr2[Op.SETGLOBAL.ordinal()] = 8;
        } catch (NoSuchFieldError unused92) {
        }
        try {
            iArr2[Op.SETI.ordinal()] = 71;
        } catch (NoSuchFieldError unused93) {
        }
        try {
            iArr2[Op.SETLIST.ordinal()] = 35;
        } catch (NoSuchFieldError unused94) {
        }
        try {
            iArr2[Op.SETLIST50.ordinal()] = 49;
        } catch (NoSuchFieldError unused95) {
        }
        try {
            iArr2[Op.SETLIST52.ordinal()] = 44;
        } catch (NoSuchFieldError unused96) {
        }
        try {
            iArr2[Op.SETLIST54.ordinal()] = 126;
        } catch (NoSuchFieldError unused97) {
        }
        try {
            iArr2[Op.SETLISTO.ordinal()] = 50;
        } catch (NoSuchFieldError unused98) {
        }
        try {
            iArr2[Op.SETTABLE.ordinal()] = 10;
        } catch (NoSuchFieldError unused99) {
        }
        try {
            iArr2[Op.SETTABLE54.ordinal()] = 70;
        } catch (NoSuchFieldError unused100) {
        }
        try {
            iArr2[Op.SETTABUP.ordinal()] = 43;
        } catch (NoSuchFieldError unused101) {
        }
        try {
            iArr2[Op.SETTABUP54.ordinal()] = 69;
        } catch (NoSuchFieldError unused102) {
        }
        try {
            iArr2[Op.SETUPVAL.ordinal()] = 9;
        } catch (NoSuchFieldError unused103) {
        }
        try {
            iArr2[Op.SHL.ordinal()] = 57;
        } catch (NoSuchFieldError unused104) {
        }
        try {
            iArr2[Op.SHL54.ordinal()] = 98;
        } catch (NoSuchFieldError unused105) {
        }
        try {
            iArr2[Op.SHLI.ordinal()] = 87;
        } catch (NoSuchFieldError unused106) {
        }
        try {
            iArr2[Op.SHR.ordinal()] = 58;
        } catch (NoSuchFieldError unused107) {
        }
        try {
            iArr2[Op.SHR54.ordinal()] = 99;
        } catch (NoSuchFieldError unused108) {
        }
        try {
            iArr2[Op.SHRI.ordinal()] = 86;
        } catch (NoSuchFieldError unused109) {
        }
        try {
            iArr2[Op.SUB.ordinal()] = 14;
        } catch (NoSuchFieldError unused110) {
        }
        try {
            iArr2[Op.SUB54.ordinal()] = 89;
        } catch (NoSuchFieldError unused111) {
        }
        try {
            iArr2[Op.SUBK.ordinal()] = 77;
        } catch (NoSuchFieldError unused112) {
        }
        try {
            iArr2[Op.TAILCALL.ordinal()] = 30;
        } catch (NoSuchFieldError unused113) {
        }
        try {
            iArr2[Op.TAILCALL54.ordinal()] = 117;
        } catch (NoSuchFieldError unused114) {
        }
        try {
            iArr2[Op.TBC.ordinal()] = 104;
        } catch (NoSuchFieldError unused115) {
        }
        try {
            iArr2[Op.TEST.ordinal()] = 27;
        } catch (NoSuchFieldError unused116) {
        }
        try {
            iArr2[Op.TEST50.ordinal()] = 52;
        } catch (NoSuchFieldError unused117) {
        }
        try {
            iArr2[Op.TEST54.ordinal()] = 115;
        } catch (NoSuchFieldError unused118) {
        }
        try {
            iArr2[Op.TESTSET.ordinal()] = 28;
        } catch (NoSuchFieldError unused119) {
        }
        try {
            iArr2[Op.TESTSET54.ordinal()] = 116;
        } catch (NoSuchFieldError unused120) {
        }
        try {
            iArr2[Op.TFORCALL.ordinal()] = 45;
        } catch (NoSuchFieldError unused121) {
        }
        try {
            iArr2[Op.TFORCALL54.ordinal()] = 124;
        } catch (NoSuchFieldError unused122) {
        }
        try {
            iArr2[Op.TFORLOOP.ordinal()] = 34;
        } catch (NoSuchFieldError unused123) {
        }
        try {
            iArr2[Op.TFORLOOP52.ordinal()] = 46;
        } catch (NoSuchFieldError unused124) {
        }
        try {
            iArr2[Op.TFORLOOP54.ordinal()] = 125;
        } catch (NoSuchFieldError unused125) {
        }
        try {
            iArr2[Op.TFORPREP.ordinal()] = 51;
        } catch (NoSuchFieldError unused126) {
        }
        try {
            iArr2[Op.TFORPREP54.ordinal()] = 123;
        } catch (NoSuchFieldError unused127) {
        }
        try {
            iArr2[Op.UNM.ordinal()] = 19;
        } catch (NoSuchFieldError unused128) {
        }
        try {
            iArr2[Op.VARARG.ordinal()] = 38;
        } catch (NoSuchFieldError unused129) {
        }
        try {
            iArr2[Op.VARARG54.ordinal()] = 127;
        } catch (NoSuchFieldError unused130) {
        }
        try {
            iArr2[Op.VARARGPREP.ordinal()] = 128;
        } catch (NoSuchFieldError unused131) {
        }
        $SWITCH_TABLE$unluac$decompile$Op = iArr2;
        return iArr2;
    }

    /* JADX INFO: loaded from: unluac.jar:unluac/decompile/ControlFlowHandler$Branch.class */
    private static class Branch implements Comparable<Branch> {
        public Branch previous;
        public Branch next;
        public int line;
        public int line2;
        public Type type;
        public Condition cond;
        public int targetFirst;
        public int targetSecond;
        public FinalSetCondition finalset;
        public boolean inverseValue = false;
        public int target = -1;

        /* JADX INFO: loaded from: unluac.jar:unluac/decompile/ControlFlowHandler$Branch$Type.class */
        private enum Type {
            comparison,
            test,
            testset,
            finalset,
            jump;

            /* JADX INFO: renamed from: values, reason: to resolve conflict with enum method */
            public static Type[] valuesCustom() {
                Type[] typeArrValuesCustom = values();
                int length = typeArrValuesCustom.length;
                Type[] typeArr = new Type[length];
                System.arraycopy(typeArrValuesCustom, 0, typeArr, 0, length);
                return typeArr;
            }
        }

        public Branch(int line, int line2, Type type, Condition cond, int targetFirst, int targetSecond, FinalSetCondition finalset) {
            this.line = line;
            this.line2 = line2;
            this.type = type;
            this.cond = cond;
            this.targetFirst = targetFirst;
            this.targetSecond = targetSecond;
            this.finalset = finalset;
        }

        @Override // java.lang.Comparable
        public int compareTo(Branch other) {
            return this.line - other.line;
        }
    }

    /* JADX INFO: loaded from: unluac.jar:unluac/decompile/ControlFlowHandler$State.class */
    private static class State {
        public Decompiler d;
        public LFunction function;
        public Registers r;
        public Code code;
        public Branch begin_branch;
        public Branch end_branch;
        public Branch[] branches;
        public Branch[] setbranches;
        public ArrayList<List<Branch>> finalsetbranches;
        public boolean[] reverse_targets;
        public int[] resolved;
        public boolean[] labels;
        public List<Block> blocks;

        private State() {
        }

        /* synthetic */ State(State state) {
            this();
        }
    }

    /* JADX INFO: loaded from: unluac.jar:unluac/decompile/ControlFlowHandler$Result.class */
    public static class Result {
        public List<Block> blocks;
        public boolean[] labels;

        public Result(State state) {
            this.blocks = state.blocks;
            this.labels = state.labels;
        }
    }

    public static Result process(Decompiler d, Registers r) {
        State state = new State(null);
        state.d = d;
        state.function = d.function;
        state.r = r;
        state.code = d.code;
        state.labels = new boolean[d.code.length + 1];
        find_reverse_targets(state);
        find_branches(state);
        combine_branches(state);
        resolve_lines(state);
        initialize_blocks(state);
        find_fixed_blocks(state);
        find_while_loops(state, d.declList);
        find_repeat_loops(state);
        find_if_break(state, d.declList);
        find_set_blocks(state);
        find_pseudo_goto_statements(state, d.declList);
        find_do_blocks(state, d.declList);
        Collections.sort(state.blocks);
        return new Result(state);
    }

    private static void find_reverse_targets(State state) {
        int target;
        Code code = state.code;
        boolean[] reverse_targets = new boolean[state.code.length + 1];
        state.reverse_targets = reverse_targets;
        for (int line = 1; line <= code.length; line++) {
            if (is_jmp(state, line) && (target = code.target(line)) <= line) {
                reverse_targets[target] = true;
            }
        }
    }

    private static void resolve_lines(State state) {
        int[] resolved = new int[state.code.length + 1];
        Arrays.fill(resolved, -1);
        for (int line = 1; line <= state.code.length; line++) {
            int r = line;
            Branch branch = state.branches[line];
            while (true) {
                Branch b = branch;
                if (b == null || b.type != Branch.Type.jump) {
                    break;
                }
                if (resolved[r] >= 1) {
                    r = resolved[r];
                    break;
                } else if (resolved[r] == -2) {
                    r = b.targetSecond;
                    break;
                } else {
                    resolved[r] = -2;
                    r = b.targetSecond;
                    branch = state.branches[r];
                }
            }
            if (r == line && state.code.op(line) == Op.JMP52 && is_close(state, line)) {
                r = line + 1;
            }
            resolved[line] = r;
        }
        state.resolved = resolved;
    }

    private static int find_loadboolblock(State state, int target) {
        if (target < 1) {
            return -1;
        }
        int loadboolblock = -1;
        Op op = state.code.op(target);
        if (op == Op.LOADBOOL) {
            if (state.code.C(target) != 0) {
                loadboolblock = target;
            } else if (target - 1 >= 1 && state.code.op(target - 1) == Op.LOADBOOL && state.code.C(target - 1) != 0) {
                loadboolblock = target - 1;
            }
        } else if (op == Op.LFALSESKIP) {
            loadboolblock = target;
        } else if (target - 1 >= 1 && op == Op.LOADTRUE && state.code.op(target - 1) == Op.LFALSESKIP) {
            loadboolblock = target - 1;
        }
        return loadboolblock;
    }

    private static void handle_loadboolblock(State state, boolean[] skip, int loadboolblock, Condition c, int line, int target) {
        boolean loadboolvalue;
        Branch b;
        Op op = state.code.op(target);
        if (op == Op.LOADBOOL) {
            loadboolvalue = state.code.B(target) != 0;
        } else if (op == Op.LFALSESKIP) {
            loadboolvalue = false;
        } else if (op == Op.LOADTRUE) {
            loadboolvalue = true;
        } else {
            throw new IllegalStateException();
        }
        int final_line = -1;
        if (loadboolblock - 1 >= 1 && is_jmp(state, loadboolblock - 1)) {
            int boolskip_target = state.code.target(loadboolblock - 1);
            int boolskip_target_redirected = -1;
            if (is_jmp_raw(state, loadboolblock + 2)) {
                boolskip_target_redirected = state.code.target(loadboolblock + 2);
            }
            if (boolskip_target == loadboolblock + 2 || boolskip_target == boolskip_target_redirected) {
                skip[loadboolblock - 1] = true;
                final_line = loadboolblock - 2;
            }
        }
        boolean inverse = false;
        if (loadboolvalue) {
            inverse = true;
            c = c.inverse();
        }
        boolean constant = is_jmp(state, line);
        int begin = line + 2;
        if (constant) {
            begin--;
            b = new Branch(line, line, Branch.Type.testset, c, begin, loadboolblock + 2, null);
        } else if (line + 2 == loadboolblock) {
            b = new Branch(loadboolblock, loadboolblock, Branch.Type.finalset, c, begin, loadboolblock + 2, null);
        } else {
            b = new Branch(line, line, Branch.Type.testset, c, begin, loadboolblock + 2, null);
        }
        b.target = state.code.A(loadboolblock);
        b.inverseValue = inverse;
        insert_branch(state, b);
        if (final_line != -1) {
            if (constant && final_line < begin) {
                final_line++;
            }
            FinalSetCondition finalc = new FinalSetCondition(final_line, b.target);
            Branch finalb = new Branch(final_line, final_line, Branch.Type.finalset, finalc, final_line, loadboolblock + 2, finalc);
            finalb.target = b.target;
            insert_branch(state, finalb);
            b.finalset = finalc;
        }
    }

    private static void handle_test(State state, boolean[] skip, int line, Condition c, int target, boolean invert) {
        Code code = state.code;
        int loadboolblock = find_loadboolblock(state, target);
        if (loadboolblock >= 1) {
            if (invert) {
                c = c.inverse();
            }
            handle_loadboolblock(state, skip, loadboolblock, c, line, target);
        } else {
            int ploadboolblock = target - 2 >= 1 ? find_loadboolblock(state, target - 2) : -1;
            if (ploadboolblock != -1 && ploadboolblock == target - 2 && code.A(target - 2) == c.register() && !has_statement(state, line + 2, target - 3)) {
                handle_testset(state, skip, line, c, target, c.register(), invert);
            } else {
                if (invert) {
                    c = c.inverse();
                }
                Branch b = new Branch(line, line, Branch.Type.test, c, line + 2, target, null);
                b.target = code.A(line);
                if (invert) {
                    b.inverseValue = true;
                }
                insert_branch(state, b);
            }
        }
        skip[line + 1] = true;
    }

    private static void handle_testset(State state, boolean[] skip, int line, Condition c, int target, int register, boolean invert) {
        int branch_line;
        if (state.r.isNoDebug && find_loadboolblock(state, target) == -1) {
            if (invert) {
                c = c.inverse();
            }
            Branch b = new Branch(line, line, Branch.Type.test, c, line + 2, target, null);
            b.target = state.code.A(line);
            if (invert) {
                b.inverseValue = true;
            }
            insert_branch(state, b);
            skip[line + 1] = true;
            return;
        }
        Branch b2 = new Branch(line, line, Branch.Type.testset, c, line + 2, target, null);
        b2.target = register;
        if (invert) {
            b2.inverseValue = true;
        }
        skip[line + 1] = true;
        insert_branch(state, b2);
        int final_line = target - 1;
        int loadboolblock = find_loadboolblock(state, target - 2);
        if (loadboolblock != -1 && state.code.A(loadboolblock) == register) {
            final_line = loadboolblock;
            if (loadboolblock - 2 >= 1 && is_jmp(state, loadboolblock - 1) && (state.code.target(loadboolblock - 1) == target || (is_jmp_raw(state, target) && state.code.target(loadboolblock - 1) == state.code.target(target)))) {
                final_line = loadboolblock - 2;
            }
            branch_line = final_line;
        } else {
            branch_line = Math.max(final_line, line + 2);
        }
        FinalSetCondition finalc = new FinalSetCondition(final_line, register);
        Branch finalb = new Branch(branch_line, branch_line, Branch.Type.finalset, finalc, final_line, target, finalc);
        finalb.target = register;
        insert_branch(state, finalb);
        b2.finalset = finalc;
    }

    private static void process_condition(State state, boolean[] skip, int line, Condition c, boolean invert) {
        int target = state.code.target(line + 1);
        if (invert) {
            c = c.inverse();
        }
        int loadboolblock = find_loadboolblock(state, target);
        if (loadboolblock >= 1) {
            handle_loadboolblock(state, skip, loadboolblock, c, line, target);
        } else {
            Branch b = new Branch(line, line, Branch.Type.comparison, c, line + 2, target, null);
            if (invert) {
                b.inverseValue = true;
            }
            insert_branch(state, b);
        }
        skip[line + 1] = true;
    }

    private static void find_branches(State state) {
        Condition.OperandType operandType;
        Code code = state.code;
        state.branches = new Branch[state.code.length + 1];
        state.setbranches = new Branch[state.code.length + 1];
        state.finalsetbranches = new ArrayList<>(state.code.length + 1);
        for (int i = 0; i <= state.code.length; i++) {
            state.finalsetbranches.add(null);
        }
        boolean[] skip = new boolean[code.length + 1];
        for (int line = 1; line <= code.length; line++) {
            if (!skip[line]) {
                switch ($SWITCH_TABLE$unluac$decompile$Op()[code.op(line).ordinal()]) {
                    case 23:
                    case 39:
                    case 105:
                        if (is_jmp(state, line)) {
                            int target = code.target(line);
                            int loadboolblock = find_loadboolblock(state, target);
                            if (loadboolblock >= 1) {
                                handle_loadboolblock(state, skip, loadboolblock, new ConstantCondition(-1, false), line, target);
                            } else {
                                Branch b = new Branch(line, line, Branch.Type.jump, null, target, target, null);
                                insert_branch(state, b);
                            }
                        }
                        break;
                    case 24:
                    case 25:
                    case 26:
                        BinaryCondition.Operator op = BinaryCondition.Operator.EQ;
                        if (code.op(line) == Op.LT) {
                            op = BinaryCondition.Operator.LT;
                        }
                        if (code.op(line) == Op.LE) {
                            op = BinaryCondition.Operator.LE;
                        }
                        Condition c = new BinaryCondition(op, line, new Condition.Operand(Condition.OperandType.RK, code.B(line)), new Condition.Operand(Condition.OperandType.RK, code.C(line)));
                        process_condition(state, skip, line, c, code.A(line) != 0);
                        break;
                    case 27:
                        int target2 = code.target(line + 1);
                        Condition c2 = new TestCondition(line, code.A(line));
                        handle_test(state, skip, line, c2, target2, code.C(line) != 0);
                        break;
                    case CodeExtract.BITFIELD_BX /* 28 */:
                        Condition c3 = new TestCondition(line, code.B(line));
                        handle_testset(state, skip, line, c3, code.target(line + 1), code.A(line), code.C(line) != 0);
                        break;
                    case 52:
                        Condition c4 = new TestCondition(line, code.B(line));
                        int target3 = code.target(line + 1);
                        if (code.A(line) == code.B(line)) {
                            handle_test(state, skip, line, c4, target3, code.C(line) != 0);
                        } else {
                            handle_testset(state, skip, line, c4, target3, code.A(line), code.C(line) != 0);
                        }
                        break;
                    case 106:
                    case 107:
                    case 108:
                        BinaryCondition.Operator op2 = BinaryCondition.Operator.EQ;
                        if (code.op(line) == Op.LT54) {
                            op2 = BinaryCondition.Operator.LT;
                        }
                        if (code.op(line) == Op.LE54) {
                            op2 = BinaryCondition.Operator.LE;
                        }
                        Condition c5 = new BinaryCondition(op2, line, new Condition.Operand(Condition.OperandType.R, code.A(line)), new Condition.Operand(Condition.OperandType.R, code.B(line)));
                        process_condition(state, skip, line, c5, code.k(line));
                        break;
                    case 109:
                        BinaryCondition.Operator op3 = BinaryCondition.Operator.EQ;
                        Condition c6 = new BinaryCondition(op3, line, new Condition.Operand(Condition.OperandType.K, code.B(line)), new Condition.Operand(Condition.OperandType.R, code.A(line)));
                        process_condition(state, skip, line, c6, code.k(line));
                        break;
                    case 110:
                    case 111:
                    case 112:
                    case 113:
                    case 114:
                        BinaryCondition.Operator op4 = BinaryCondition.Operator.EQ;
                        if (code.op(line) == Op.LTI) {
                            op4 = BinaryCondition.Operator.LT;
                        }
                        if (code.op(line) == Op.LEI) {
                            op4 = BinaryCondition.Operator.LE;
                        }
                        if (code.op(line) == Op.GTI) {
                            op4 = BinaryCondition.Operator.GT;
                        }
                        if (code.op(line) == Op.GEI) {
                            op4 = BinaryCondition.Operator.GE;
                        }
                        if (code.C(line) != 0) {
                            operandType = Condition.OperandType.F;
                        } else {
                            operandType = Condition.OperandType.I;
                        }
                        Condition.Operand left = new Condition.Operand(Condition.OperandType.R, code.A(line));
                        Condition.Operand right = new Condition.Operand(operandType, code.sB(line));
                        if (op4 == BinaryCondition.Operator.EQ) {
                            left = right;
                            right = left;
                        }
                        Condition c7 = new BinaryCondition(op4, line, left, right);
                        process_condition(state, skip, line, c7, code.k(line));
                        break;
                    case 115:
                        int target4 = code.target(line + 1);
                        Condition c8 = new TestCondition(line, code.A(line));
                        handle_test(state, skip, line, c8, target4, code.k(line));
                        break;
                    case 116:
                        Condition c9 = new TestCondition(line, code.B(line));
                        handle_testset(state, skip, line, c9, code.target(line + 1), code.A(line), code.k(line));
                        break;
                }
            }
        }
        link_branches(state);
    }

    private static void combine_branches(State state) {
        Branch branch = state.end_branch;
        while (true) {
            Branch b = branch;
            if (b != null) {
                branch = combine_left(state, b).previous;
            } else {
                return;
            }
        }
    }

    private static void initialize_blocks(State state) {
        state.blocks = new LinkedList();
    }

    private static void find_fixed_blocks(State state) {
        List<Block> blocks = state.blocks;
        Registers r = state.r;
        Code code = state.code;
        Op tforTarget = state.function.header.version.tfortarget.get();
        Op forTarget = state.function.header.version.fortarget.get();
        blocks.add(new OuterBlock(state.function, state.code.length));
        boolean[] loop = new boolean[state.code.length + 1];
        Branch branch = state.begin_branch;
        while (true) {
            Branch b = branch;
            if (b != null) {
                if (b.type == Branch.Type.jump) {
                    int line = b.line;
                    int target = b.targetFirst;
                    if (code.op(target) == tforTarget && !loop[target]) {
                        loop[target] = true;
                        int A = code.A(target);
                        int C = code.C(target);
                        if (C == 0) {
                            throw new IllegalStateException();
                        }
                        remove_branch(state, state.branches[line]);
                        if (state.branches[target + 1] != null) {
                            remove_branch(state, state.branches[target + 1]);
                        }
                        boolean forvarClose = false;
                        boolean innerClose = false;
                        int close = target - 1;
                        if (close >= line + 1 && is_close(state, close) && get_close_value(state, close) == A + 3) {
                            forvarClose = true;
                            close--;
                        }
                        if (close >= line + 1 && is_close(state, close) && get_close_value(state, close) <= A + 3 + C) {
                            innerClose = true;
                        }
                        TForBlock block = TForBlock.make51(state.function, line + 1, target + 2, A, C, forvarClose, innerClose);
                        block.handleVariableDeclarations(r);
                        blocks.add(block);
                    } else if (code.op(target) == forTarget && !loop[target]) {
                        loop[target] = true;
                        ForBlock block2 = new ForBlock50(state.function, line + 1, target + 1, code.A(target), get_close_type(state, target - 1), target - 1);
                        block2.handleVariableDeclarations(r);
                        blocks.add(block2);
                        remove_branch(state, b);
                    }
                }
                branch = b.next;
            } else {
                for (int line2 = 1; line2 <= code.length; line2++) {
                    switch ($SWITCH_TABLE$unluac$decompile$Op()[code.op(line2).ordinal()]) {
                        case 33:
                        case 122:
                            int A2 = code.A(line2);
                            int target2 = code.target(line2);
                            int begin = line2 + 1;
                            int end = target2 + 1;
                            boolean forvarPreClose = false;
                            boolean forvarPostClose = false;
                            boolean closeIsInScope = false;
                            int closeLine = target2 - 1;
                            if (closeLine >= line2 + 1 && is_close(state, closeLine) && get_close_value(state, closeLine) == A2 + 3) {
                                forvarPreClose = true;
                                if (!state.r.isNoDebug) {
                                    int declScopeEnd = r.getDeclaration(A2 + 3, line2).end;
                                    if (get_close_type(state, closeLine) == CloseType.CLOSE54 && declScopeEnd == closeLine) {
                                        closeIsInScope = true;
                                    }
                                }
                                closeLine--;
                            } else if (end <= code.length && is_close(state, end) && get_close_value(state, end) == A2 + 3) {
                                forvarPostClose = true;
                            }
                            ForBlock block3 = new ForBlock51(state.function, begin, end, A2, get_close_type(state, closeLine), closeLine, forvarPreClose, forvarPostClose, closeIsInScope);
                            block3.handleVariableDeclarations(r);
                            blocks.add(block3);
                            break;
                        case 51:
                            int target3 = code.target(line2);
                            int A3 = code.A(target3);
                            int C2 = code.C(target3);
                            boolean innerClose2 = false;
                            int close2 = target3 - 1;
                            if (close2 >= line2 + 1 && is_close(state, close2) && get_close_value(state, close2) == A3 + 3 + C2) {
                                innerClose2 = true;
                            }
                            TForBlock block4 = TForBlock.make50(state.function, line2 + 1, target3 + 2, A3, C2 + 1, innerClose2);
                            block4.handleVariableDeclarations(r);
                            blocks.add(block4);
                            remove_branch(state, state.branches[target3 + 1]);
                            break;
                        case 123:
                            int target4 = code.target(line2);
                            int A4 = code.A(line2);
                            int C3 = code.C(target4);
                            boolean forvarClose2 = false;
                            int close3 = target4 - 1;
                            if (close3 >= line2 + 1 && is_close(state, close3) && get_close_value(state, close3) == A4 + 4) {
                                forvarClose2 = true;
                                close3--;
                            }
                            boolean closeIsInScope2 = false;
                            if (!state.r.isNoDebug && target4 + 2 <= code.length && is_close(state, target4 + 2)) {
                                closeIsInScope2 = r.getDeclaration(A4, target4).end == target4 + 2;
                            }
                            TForBlock block5 = TForBlock.make54(state.function, line2 + 1, target4 + 2, A4, C3, get_close_type(state, close3), close3, forvarClose2, closeIsInScope2);
                            block5.handleVariableDeclarations(r);
                            blocks.add(block5);
                            break;
                    }
                }
                return;
            }
        }
    }

    private static void unredirect(State state, int begin, int end, int line, int target) {
        Branch branch = state.begin_branch;
        while (true) {
            Branch b = branch;
            if (b != null) {
                if (b.line >= begin && b.line < end && b.targetSecond == target) {
                    if (b.type == Branch.Type.finalset) {
                        b.targetFirst = line - 1;
                        b.targetSecond = line;
                        if (b.finalset != null) {
                            b.finalset.line = line - 1;
                        }
                    } else {
                        b.targetSecond = line;
                        if (b.targetFirst == target) {
                            b.targetFirst = line;
                        }
                    }
                }
                branch = b.next;
            } else {
                return;
            }
        }
    }

    private static void find_while_loops(State state, Declaration[] declList) {
        Branch b;
        List<Block> blocks = state.blocks;
        Branch branch = state.end_branch;
        while (true) {
            Branch j = branch;
            if (j != null) {
                if (j.type == Branch.Type.jump && j.targetFirst <= j.line && !splits_decl(j.targetFirst, j.targetFirst, j.line + 1, declList)) {
                    int line = j.targetFirst;
                    int end = j.line + 1;
                    Branch b2 = state.begin_branch;
                    int extent = -1;
                    while (b2 != null && (!is_conditional(b2) || b2.line < line || b2.line >= j.line || state.resolved[b2.targetSecond] != state.resolved[end] || extent > b2.line)) {
                        if (b2.line >= line) {
                            extent = Math.max(extent, b2.targetSecond);
                        }
                        b2 = b2.next;
                    }
                    if (b2 != null) {
                        boolean reverse = state.reverse_targets[line];
                        state.reverse_targets[line] = false;
                        if (has_statement(state, line, b2.line - 1)) {
                            b2 = null;
                        }
                        state.reverse_targets[line] = reverse;
                    }
                    if (state.function.header.version.whileformat.get() == Version.WhileFormat.BOTTOM_CONDITION) {
                        b2 = null;
                    }
                    Block loop = null;
                    if (b2 != null) {
                        b2.targetSecond = end;
                        remove_branch(state, b2);
                        loop = new WhileBlock51(state.function, b2.cond, b2.targetFirst, b2.targetSecond, line, get_close_type(state, end - 2), end - 2);
                        unredirect(state, line, end, j.line, line);
                    }
                    if (loop == null && j.line - 5 >= 1 && state.code.op(j.line - 3) == Op.CLOSE && is_jmp_raw(state, j.line - 2) && state.code.target(j.line - 2) == end && state.code.op(j.line - 1) == Op.CLOSE) {
                        Branch branch2 = j.previous;
                        while (true) {
                            b = branch2;
                            if (b == null || (is_conditional(b) && b.line2 == j.line - 5)) {
                                break;
                            } else {
                                branch2 = b.previous;
                            }
                        }
                        if (b != null) {
                            Branch skip = state.branches[j.line - 2];
                            if (skip == null) {
                                throw new IllegalStateException();
                            }
                            int closeLine = state.function.header.version.closesemantics.get() == Version.CloseSemantics.LUA54 ? j.line - 3 : j.line - 1;
                            loop = new RepeatBlock(state.function, b.cond, j.targetFirst, j.line + 1, get_close_type(state, closeLine), closeLine, false, -1);
                            remove_branch(state, b);
                            remove_branch(state, skip);
                        }
                    }
                    if (loop == null) {
                        boolean repeat = false;
                        if (state.function.header.version.whileformat.get() == Version.WhileFormat.BOTTOM_CONDITION) {
                            repeat = true;
                            if (line - 1 >= 1 && state.branches[line - 1] != null) {
                                Branch head = state.branches[line - 1];
                                if (head.type == Branch.Type.jump && head.targetFirst == j.line) {
                                    remove_branch(state, head);
                                    repeat = false;
                                }
                            }
                        }
                        boolean gotoheuristic = false;
                        if (state.function.header.version.usegoto.get().booleanValue()) {
                            Branch branch3 = j.previous;
                            while (true) {
                                Branch k = branch3;
                                if (k == null || k.line < line) {
                                    break;
                                }
                                if ((k.type == Branch.Type.jump || ((k.type == Branch.Type.test || k.type == Branch.Type.comparison) && state.function.header.version.useifgotorewrite.get() != Version.Maybe.NO)) && (k.targetFirst < line || k.targetSecond > end)) {
                                    gotoheuristic = true;
                                }
                                branch3 = k.previous;
                            }
                        }
                        if (!gotoheuristic) {
                            loop = new AlwaysLoop(state.function, line, end, get_close_type(state, end - 2), end - 2, repeat);
                            unredirect(state, line, end, j.line, line);
                        }
                    }
                    if (loop != null) {
                        remove_branch(state, j);
                        blocks.add(loop);
                    }
                }
                branch = j.previous;
            } else {
                return;
            }
        }
    }

    private static void find_repeat_loops(State state) {
        int head;
        List<Block> blocks = state.blocks;
        Branch branch = state.begin_branch;
        while (true) {
            Branch b = branch;
            if (b != null) {
                if (is_conditional(b) && b.targetSecond < b.targetFirst) {
                    Block block = null;
                    if (state.function.header.version.whileformat.get() == Version.WhileFormat.BOTTOM_CONDITION && (head = b.targetSecond - 1) >= 1 && state.branches[head] != null && state.branches[head].type == Branch.Type.jump) {
                        Branch headb = state.branches[head];
                        if (headb.targetSecond <= b.line) {
                            if (has_statement(state, headb.targetSecond, b.line - 1)) {
                                headb = null;
                            }
                            if (headb != null) {
                                block = new WhileBlock50(state.function, b.cond.inverse(), head + 1, b.targetFirst, headb.targetFirst, get_close_type(state, headb.targetFirst - 1), headb.targetFirst - 1);
                                remove_branch(state, headb);
                                unredirect(state, 1, headb.line, headb.line, headb.targetSecond);
                            }
                        }
                    }
                    if (block == null) {
                        if (state.function.header.version.extendedrepeatscope.get().booleanValue()) {
                            int statementLine = b.line - 1;
                            while (statementLine >= 1 && !is_statement(state, statementLine)) {
                                statementLine--;
                            }
                            block = new RepeatBlock(state.function, b.cond, b.targetSecond, b.targetFirst, get_close_type(state, statementLine), statementLine, true, statementLine);
                        } else if (state.function.header.version.closesemantics.get() == Version.CloseSemantics.JUMP && is_close(state, b.targetFirst)) {
                            block = new RepeatBlock(state.function, b.cond, b.targetSecond, b.targetFirst + 1, get_close_type(state, b.targetFirst), b.targetFirst, false, -1);
                        } else {
                            block = new RepeatBlock(state.function, b.cond, b.targetSecond, b.targetFirst, CloseType.NONE, -1, false, -1);
                        }
                    }
                    remove_branch(state, b);
                    blocks.add(block);
                }
                branch = b.next;
            } else {
                return;
            }
        }
    }

    private static boolean splits_decl(int line, int begin, int end, Declaration[] declList) {
        for (Declaration decl : declList) {
            if (decl.isSplitBy(line, begin, end)) {
                return true;
            }
        }
        return false;
    }

    private static int stack_reach(State state, Stack<Branch> stack) {
        for (int i = 0; i < stack.size(); i++) {
            Branch b = stack.peek(i);
            Block breakable = enclosing_breakable_block(state, b.line);
            if (breakable == null || breakable.end != b.targetSecond) {
                return b.targetSecond;
            }
        }
        return Integer.MAX_VALUE;
    }

    private static Block resolve_if_stack(State state, Stack<Branch> stack, int line) {
        Block block = null;
        if (!stack.isEmpty() && stack_reach(state, stack) <= line) {
            Branch top = stack.pop();
            int literalEnd = state.code.target(top.targetFirst - 1);
            if (state.function.header.version.useifgotorewrite.get() != Version.Maybe.NO && top.targetFirst + 1 == top.targetSecond && is_jmp(state, top.targetFirst)) {
                boolean isbreakrewrite = state.function.header.version.useifbreakrewrite.get().booleanValue() && is_break_jmp(state, top.targetFirst);
                boolean isgotorewrite = !isbreakrewrite && state.function.header.version.useifgotorewrite.get() == Version.Maybe.YES;
                if (isbreakrewrite || isgotorewrite) {
                    block = new IfThenEndBlock(state.function, state.r, top.cond.inverse(), top.targetFirst - 1, top.targetFirst - 1);
                    block.addStatement(new Goto(state.function, top.targetFirst - 1, top.targetSecond));
                    state.labels[top.targetSecond] = true;
                }
            }
            if (block == null) {
                block = new IfThenEndBlock(state.function, state.r, top.cond, top.targetFirst, top.targetSecond, get_close_type(state, top.targetSecond - 1), top.targetSecond - 1, literalEnd != top.targetSecond);
            }
            state.blocks.add(block);
            remove_branch(state, top);
        }
        return block;
    }

    private static void resolve_else(State state, Stack<Branch> stack, Stack<Branch> hanging, Stack<ElseEndBlock> elseStack, Branch top, Branch b, int tailTargetSecond) {
        while (!elseStack.isEmpty() && elseStack.peek().end == tailTargetSecond && elseStack.peek().begin >= top.targetFirst) {
            elseStack.pop().end = b.line;
        }
        Stack<Branch> replace = new Stack<>();
        while (!hanging.isEmpty() && hanging.peek().targetSecond == tailTargetSecond && hanging.peek().line > top.line) {
            Branch hanger = hanging.pop();
            hanger.targetSecond = b.line;
            Block breakable = enclosing_breakable_block(state, hanger.line);
            if (breakable != null && hanger.targetSecond >= breakable.end) {
                replace.push(hanger);
            } else {
                stack.push(hanger);
                Block if_block = resolve_if_stack(state, stack, b.line);
                if (if_block == null) {
                    throw new IllegalStateException();
                }
            }
        }
        while (!replace.isEmpty()) {
            hanging.push(replace.pop());
        }
        unredirect_finalsets(state, tailTargetSecond, b.line, top.targetFirst);
        Stack<Branch> restore = new Stack<>();
        while (!stack.isEmpty() && stack.peek().line > top.line && stack.peek().targetSecond == b.targetSecond) {
            stack.peek().targetSecond = b.line;
            restore.push(stack.pop());
        }
        while (!restore.isEmpty()) {
            stack.push(restore.pop());
        }
        b.targetSecond = tailTargetSecond;
        state.blocks.add(new IfThenElseBlock(state.function, top.cond, top.targetFirst, top.targetSecond, b.targetSecond, get_close_type(state, top.targetSecond - 2), top.targetSecond - 2));
        ElseEndBlock elseBlock = new ElseEndBlock(state.function, top.targetSecond, b.targetSecond, get_close_type(state, b.targetSecond - 1), b.targetSecond - 1);
        state.blocks.add(elseBlock);
        elseStack.push(elseBlock);
        remove_branch(state, b);
    }

    private static boolean is_hanger_resolvable(State state, Declaration[] declList, Branch hanging, Branch resolver) {
        if (hanging.targetSecond == resolver.targetFirst && enclosing_block(state, hanging.line) == enclosing_block(state, resolver.line) && !splits_decl(hanging.line, hanging.targetFirst, resolver.line, declList)) {
            if (!state.function.header.version.useifbreakrewrite.get().booleanValue() || hanging.targetFirst != resolver.line - 1 || !is_break_jmp(state, resolver.line - 1)) {
                if (state.function.header.version.useifgotorewrite.get() != Version.Maybe.YES || hanging.targetFirst != resolver.line - 1 || !is_jmp(state, resolver.line - 1)) {
                    return true;
                }
                return false;
            }
            return false;
        }
        return false;
    }

    private static boolean is_hanger_resolvable(State state, Declaration[] declList, Branch hanging, Stack<Branch> resolvers) {
        for (int i = 0; i < resolvers.size(); i++) {
            if (is_hanger_resolvable(state, declList, hanging, resolvers.peek(i))) {
                return true;
            }
        }
        return false;
    }

    private static void resolve_hanger(State state, Declaration[] declList, Stack<Branch> stack, Branch hanger, Branch b) {
        hanger.targetSecond = b.line;
        stack.push(hanger);
        Block if_block = resolve_if_stack(state, stack, b.line);
        if (if_block == null) {
            throw new IllegalStateException();
        }
    }

    private static void resolve_hangers(State state, Declaration[] declList, Stack<Branch> stack, Stack<Branch> hanging, Branch b) {
        while (!hanging.isEmpty() && is_hanger_resolvable(state, declList, hanging.peek(), b)) {
            resolve_hanger(state, declList, stack, hanging.pop(), b);
        }
    }

    private static void find_if_break(State state, Declaration[] declList) {
        Branch top;
        Stack<Branch> stack = new Stack<>();
        Stack<Branch> hanging = new Stack<>();
        Stack<ElseEndBlock> elseStack = new Stack<>();
        Stack<Branch> hangingResolver = new Stack<>();
        for (Branch b = state.begin_branch; b != null; b = b.next) {
            while (resolve_if_stack(state, stack, b.line2) != null) {
            }
            while (!elseStack.isEmpty() && elseStack.peek().end <= b.line) {
                elseStack.pop();
            }
            while (!hangingResolver.isEmpty() && !enclosing_block(state, hangingResolver.peek().line).contains(b.line)) {
                resolve_hangers(state, declList, stack, hanging, hangingResolver.pop());
            }
            if (is_conditional(b)) {
                Block unprotected = enclosing_unprotected_block(state, b.line);
                if (b.targetFirst > b.targetSecond) {
                    throw new IllegalStateException();
                }
                if (unprotected != null && !unprotected.contains(b.targetSecond) && b.targetSecond == unprotected.getUnprotectedTarget()) {
                    b.targetSecond = unprotected.getUnprotectedLine();
                }
                Block breakable = enclosing_breakable_block(state, b.line);
                if ((!stack.isEmpty() && stack.peek().targetSecond < b.targetSecond) || (breakable != null && !breakable.contains(b.targetSecond))) {
                    hanging.push(b);
                } else {
                    stack.push(b);
                }
            } else if (b.type == Branch.Type.jump) {
                int line = b.line;
                Block enclosing = enclosing_block(state, b.line);
                int tailTargetSecond = b.targetSecond;
                Block unprotected2 = enclosing_unprotected_block(state, b.line);
                if (unprotected2 != null && !unprotected2.contains(b.targetSecond) && tailTargetSecond == state.resolved[unprotected2.getUnprotectedTarget()]) {
                    tailTargetSecond = unprotected2.getUnprotectedLine();
                }
                boolean handled = false;
                Block breakable2 = enclosing_breakable_block(state, line);
                if (breakable2 != null && (b.targetFirst == breakable2.end || b.targetFirst == state.resolved[breakable2.end])) {
                    Break block = new Break(state.function, b.line, b.targetFirst);
                    if (!hanging.isEmpty() && hanging.peek().targetSecond == b.targetFirst && enclosing_block(state, hanging.peek().line) == enclosing && (stack.isEmpty() || stack.peek().line < hanging.peek().line || hanging.peek().line > stack.peek().line)) {
                        hangingResolver.push(b);
                    }
                    unredirect_finalsets(state, b.targetFirst, line, breakable2.begin);
                    state.blocks.add(block);
                    remove_branch(state, b);
                    handled = true;
                }
                if (!handled && state.function.header.version.usegoto.get().booleanValue() && breakable2 != null && !breakable2.contains(b.targetFirst) && state.resolved[b.targetFirst] != state.resolved[breakable2.end]) {
                    Goto block2 = new Goto(state.function, b.line, b.targetFirst);
                    if (!hanging.isEmpty() && hanging.peek().targetSecond == b.targetFirst && enclosing_block(state, hanging.peek().line) == enclosing && (stack.isEmpty() || hanging.peek().line > stack.peek().line)) {
                        hangingResolver.push(b);
                    }
                    unredirect_finalsets(state, b.targetFirst, line, 1);
                    state.blocks.add(block2);
                    state.labels[b.targetFirst] = true;
                    remove_branch(state, b);
                    handled = true;
                }
                if (!handled && !stack.isEmpty() && stack.peek().targetSecond - 1 == b.line && enclosing.contains(b.line, b.targetSecond) && b.targetSecond > b.line) {
                    Branch branchPeek = stack.peek();
                    while (true) {
                        top = branchPeek;
                        if (top == null || top.targetSecond - 1 != b.line || !splits_decl(top.line, top.targetFirst, top.targetSecond, declList)) {
                            break;
                        }
                        Block if_block = resolve_if_stack(state, stack, top.targetSecond);
                        if (if_block == null) {
                            throw new IllegalStateException();
                        }
                        branchPeek = stack.isEmpty() ? null : stack.peek();
                    }
                    if (top != null && top.targetSecond - 1 == b.line) {
                        if (top.targetSecond != b.targetSecond) {
                            while (!hangingResolver.isEmpty() && !hanging.isEmpty() && is_hanger_resolvable(state, declList, hanging.peek(), hangingResolver.peek())) {
                                resolve_hanger(state, declList, stack, hanging.pop(), hangingResolver.peek());
                            }
                            resolve_else(state, stack, hanging, elseStack, top, b, tailTargetSecond);
                            stack.pop();
                        } else if (!splits_decl(top.line, top.targetFirst, top.targetSecond - 1, declList)) {
                            b.targetSecond = tailTargetSecond;
                            state.blocks.add(new IfThenElseBlock(state.function, top.cond, top.targetFirst, top.targetSecond, b.targetSecond, get_close_type(state, top.targetSecond - 2), top.targetSecond - 2));
                            remove_branch(state, b);
                            stack.pop();
                        }
                    }
                    handled = true;
                }
                if (!handled && breakable2 != null && line + 1 < state.branches.length && state.branches[line + 1] != null && state.branches[line + 1].type == Branch.Type.jump) {
                    for (int i = 0; i < hanging.size(); i++) {
                        Branch hanger = hanging.peek(i);
                        if ((state.resolved[hanger.targetSecond] == state.resolved[breakable2.end] || (state.function.header.version.usegoto.get().booleanValue() && !breakable2.contains(hanger.targetSecond))) && line + 1 < state.branches.length && state.branches[line + 1] != null && state.branches[line + 1].targetFirst == hanger.targetSecond && !splits_decl(hanger.line, hanger.targetFirst, b.line, declList) && !splits_decl(b.line, b.line + 1, b.line + 2, declList) && !splits_decl(hanger.line, hanger.targetFirst, b.line + 2, declList)) {
                            for (int j = i; j > 0; j--) {
                                while (!is_hanger_resolvable(state, declList, hanging.peek(), hangingResolver.peek())) {
                                    hangingResolver.pop();
                                }
                                resolve_hanger(state, declList, stack, hanging.pop(), hangingResolver.peek());
                            }
                            Branch top2 = hanging.pop();
                            if (!hangingResolver.isEmpty() && hangingResolver.peek().targetFirst == top2.targetSecond) {
                                hangingResolver.pop();
                            }
                            top2.targetSecond = line + 1;
                            resolve_else(state, stack, hanging, elseStack, top2, b, tailTargetSecond);
                            handled = true;
                            break;
                        }
                        if (!is_hanger_resolvable(state, declList, hanger, hangingResolver)) {
                            break;
                        }
                    }
                }
                if (!handled && breakable2 != null && breakable2.isSplitable() && state.resolved[b.targetFirst] == breakable2.getUnprotectedTarget() && line + 1 < state.branches.length && state.branches[line + 1] != null && state.branches[line + 1].type == Branch.Type.jump && state.resolved[state.branches[line + 1].targetFirst] == state.resolved[breakable2.end]) {
                    Block[] split = breakable2.split(b.line, get_close_type(state, b.line - 1));
                    for (Block block3 : split) {
                        state.blocks.add(block3);
                    }
                    remove_branch(state, b);
                    handled = true;
                }
                if (!handled && !stack.isEmpty() && stack.peek().targetSecond == b.targetFirst && line + 1 < state.branches.length && state.branches[line + 1] != null && state.branches[line + 1].type == Branch.Type.jump && state.branches[line + 1].targetFirst == b.targetFirst) {
                    Branch top3 = stack.peek();
                    if (!splits_decl(top3.line, top3.targetFirst, b.line, declList)) {
                        top3.targetSecond = line + 1;
                        b.targetSecond = line + 1;
                        state.blocks.add(new IfThenElseBlock(state.function, top3.cond, top3.targetFirst, top3.targetSecond, b.targetSecond, get_close_type(state, line - 1), line - 1));
                        remove_branch(state, b);
                        stack.pop();
                    }
                    handled = true;
                }
                if (!handled && !hanging.isEmpty() && hanging.peek().targetSecond == b.targetFirst && line + 1 < state.branches.length && state.branches[line + 1] != null && state.branches[line + 1].type == Branch.Type.jump && state.branches[line + 1].targetFirst == b.targetFirst) {
                    Branch top4 = hanging.peek();
                    if (!splits_decl(top4.line, top4.targetFirst, b.line, declList)) {
                        if (!hangingResolver.isEmpty() && hangingResolver.peek().targetFirst == top4.targetSecond) {
                            hangingResolver.pop();
                        }
                        top4.targetSecond = line + 1;
                        b.targetSecond = line + 1;
                        state.blocks.add(new IfThenElseBlock(state.function, top4.cond, top4.targetFirst, top4.targetSecond, b.targetSecond, get_close_type(state, line - 1), line - 1));
                        remove_branch(state, b);
                        hanging.pop();
                    }
                    handled = true;
                }
                if (!handled && (state.function.header.version.usegoto.get().booleanValue() || state.r.isNoDebug)) {
                    Goto block4 = new Goto(state.function, b.line, b.targetFirst);
                    if (!hanging.isEmpty() && hanging.peek().targetSecond == b.targetFirst && enclosing_block(state, hanging.peek().line) == enclosing) {
                        hangingResolver.push(b);
                    }
                    state.blocks.add(block4);
                    state.labels[b.targetFirst] = true;
                    remove_branch(state, b);
                }
            } else {
                continue;
            }
        }
        while (!hangingResolver.isEmpty()) {
            resolve_hangers(state, declList, stack, hanging, hangingResolver.pop());
        }
        while (!hanging.isEmpty()) {
            Branch top5 = hanging.pop();
            Block breakable3 = enclosing_breakable_block(state, top5.line);
            if (breakable3 != null && breakable3.end == top5.targetSecond) {
                if (state.function.header.version.useifbreakrewrite.get().booleanValue() || state.r.isNoDebug) {
                    Block block5 = new IfThenEndBlock(state.function, state.r, top5.cond.inverse(), top5.targetFirst - 1, top5.targetFirst - 1);
                    block5.addStatement(new Break(state.function, top5.targetFirst - 1, top5.targetSecond));
                    state.blocks.add(block5);
                } else {
                    throw new IllegalStateException();
                }
            } else if (state.function.header.version.usegoto.get().booleanValue() || state.r.isNoDebug) {
                if (state.function.header.version.useifgotorewrite.get() != Version.Maybe.NO || state.r.isNoDebug) {
                    Block block6 = new IfThenEndBlock(state.function, state.r, top5.cond.inverse(), top5.targetFirst - 1, top5.targetFirst - 1);
                    block6.addStatement(new Goto(state.function, top5.targetFirst - 1, top5.targetSecond));
                    state.blocks.add(block6);
                    state.labels[top5.targetSecond] = true;
                } else {
                    throw new IllegalStateException();
                }
            } else {
                throw new IllegalStateException();
            }
            remove_branch(state, top5);
        }
        while (resolve_if_stack(state, stack, Integer.MAX_VALUE) != null) {
        }
    }

    private static void unredirect_finalsets(State state, int target, int line, int begin) {
        Branch branch = state.begin_branch;
        while (true) {
            Branch b = branch;
            if (b != null) {
                if (b.type == Branch.Type.finalset && b.targetSecond == target && b.line < line && b.line >= begin) {
                    b.targetFirst = line - 1;
                    b.targetSecond = line;
                    if (b.finalset != null) {
                        b.finalset.line = line - 1;
                    }
                }
                branch = b.next;
            } else {
                return;
            }
        }
    }

    private static void find_set_blocks(State state) {
        List<Block> blocks = state.blocks;
        Branch branch = state.begin_branch;
        while (true) {
            Branch b = branch;
            if (b != null) {
                if (is_assignment(b) || b.type == Branch.Type.finalset) {
                    if (b.finalset != null) {
                        FinalSetCondition c = b.finalset;
                        Op op = state.code.op(c.line);
                        if (c.line >= 2 && (op == Op.MMBIN || op == Op.MMBINI || op == Op.MMBINK || op == Op.EXTRAARG)) {
                            c.line--;
                            if (b.targetFirst == c.line + 1) {
                                b.targetFirst = c.line;
                            }
                        }
                        while (state.code.isUpvalueDeclaration(c.line)) {
                            c.line--;
                            if (b.targetFirst == c.line + 1) {
                                b.targetFirst = c.line;
                            }
                        }
                        if (is_jmp_raw(state, c.line)) {
                            c.type = FinalSetCondition.Type.REGISTER;
                        } else {
                            c.type = FinalSetCondition.Type.VALUE;
                        }
                    }
                    if (b.cond == b.finalset) {
                        remove_branch(state, b);
                    } else {
                        Block block = new SetBlock(state.function, b.cond, b.target, b.line, b.targetFirst, b.targetSecond, state.r);
                        blocks.add(block);
                        remove_branch(state, b);
                    }
                }
                branch = b.next;
            } else {
                return;
            }
        }
    }

    private static Block enclosing_block(State state, int line) {
        Block enclosing = null;
        for (Block block : state.blocks) {
            if (block.contains(line) && (enclosing == null || enclosing.contains(block))) {
                enclosing = block;
            }
        }
        return enclosing;
    }

    private static Block enclosing_breakable_block(State state, int line) {
        Block enclosing = null;
        for (Block block : state.blocks) {
            if (block.contains(line) && block.breakable() && (enclosing == null || enclosing.contains(block))) {
                enclosing = block;
            }
        }
        return enclosing;
    }

    private static Block enclosing_unprotected_block(State state, int line) {
        Block enclosing = null;
        for (Block block : state.blocks) {
            if (block.contains(line) && block.isUnprotected() && (enclosing == null || enclosing.contains(block))) {
                enclosing = block;
            }
        }
        return enclosing;
    }

    private static void find_pseudo_goto_statements(State state, Declaration[] declList) {
        Branch branch = state.begin_branch;
        while (true) {
            Branch b = branch;
            if (b != null) {
                if (b.type == Branch.Type.jump && b.targetFirst > b.line) {
                    int end = b.targetFirst;
                    Block smallestEnclosing = null;
                    for (Block block : state.blocks) {
                        if (block.contains(b.line) && block.contains(end - 1) && (smallestEnclosing == null || smallestEnclosing.contains(block))) {
                            smallestEnclosing = block;
                        }
                    }
                    if (smallestEnclosing != null) {
                        Block wrapping = null;
                        for (Block block2 : state.blocks) {
                            if (block2 != smallestEnclosing && smallestEnclosing.contains(block2) && block2.contains(b.line) && (wrapping == null || block2.contains(wrapping))) {
                                wrapping = block2;
                            }
                        }
                        int begin = smallestEnclosing.begin;
                        if (wrapping != null) {
                            begin = Math.max(wrapping.begin - 1, smallestEnclosing.begin);
                        }
                        int lowerBound = Integer.MIN_VALUE;
                        int upperBound = Integer.MAX_VALUE;
                        for (Declaration decl : declList) {
                            if (decl.end >= begin && decl.end <= end - 1 && decl.begin < begin) {
                                upperBound = Math.min(decl.begin, upperBound);
                            }
                            if (decl.begin >= begin && decl.begin <= end - 1 && decl.end > end - 1) {
                                lowerBound = Math.max(decl.begin + 1, lowerBound);
                                begin = decl.begin + 1;
                            }
                        }
                        if (lowerBound > upperBound) {
                            throw new IllegalStateException();
                        }
                        int begin2 = Math.min(upperBound, Math.max(lowerBound, begin));
                        Block breakable = enclosing_breakable_block(state, b.line);
                        if (breakable != null) {
                            begin2 = Math.max(breakable.begin, begin2);
                        }
                        boolean containsBreak = false;
                        OnceLoop loop = new OnceLoop(state.function, begin2, end);
                        for (Block block3 : state.blocks) {
                            if (loop.contains(block3) && (block3 instanceof Break)) {
                                containsBreak = true;
                                break;
                            }
                        }
                        if (containsBreak) {
                            state.blocks.add(new IfThenElseBlock(state.function, FixedCondition.TRUE, begin2, b.line + 1, end, CloseType.NONE, -1));
                            state.blocks.add(new ElseEndBlock(state.function, b.line + 1, end, CloseType.NONE, -1));
                            remove_branch(state, b);
                        } else {
                            state.blocks.add(loop);
                            Branch branch2 = b;
                            while (true) {
                                Branch b2 = branch2;
                                if (b2 == null) {
                                    break;
                                }
                                if (b2.type == Branch.Type.jump && b2.targetFirst > b2.line && b2.targetFirst == b.targetFirst) {
                                    Break breakStatement = new Break(state.function, b2.line, b2.targetFirst);
                                    state.blocks.add(breakStatement);
                                    breakStatement.comment = "pseudo-goto";
                                    remove_branch(state, b2);
                                    if (b.next == b2) {
                                        b = b2;
                                    }
                                }
                                branch2 = b2.next;
                            }
                        }
                    } else {
                        continue;
                    }
                }
                branch = b.next;
            } else {
                return;
            }
        }
    }

    private static void find_do_blocks(State state, Declaration[] declList) {
        int closeLine;
        Block enclosing;
        List<Block> newBlocks = new ArrayList<>();
        for (Block block : state.blocks) {
            if (block.hasCloseLine() && block.getCloseLine() >= 1 && ((enclosing = enclosing_block(state, (closeLine = block.getCloseLine()))) == block || enclosing.contains(block))) {
                if (is_close(state, closeLine)) {
                    int register = get_close_value(state, closeLine);
                    boolean close = true;
                    Declaration closeDecl = null;
                    for (Declaration decl : declList) {
                        if (!decl.forLoop && !decl.forLoopExplicit && block.contains(decl.begin)) {
                            if (decl.register < register) {
                                close = false;
                            } else if (decl.register == register) {
                                closeDecl = decl;
                            }
                        }
                    }
                    if (close) {
                        block.useClose();
                    } else if (closeDecl != null) {
                        Block inner = new DoEndBlock(state.function, closeDecl.begin, closeDecl.end + 1);
                        inner.closeRegister = register;
                        newBlocks.add(inner);
                        strictScopeCheck(state);
                    }
                }
            }
        }
        state.blocks.addAll(newBlocks);
        for (Declaration decl2 : declList) {
            int begin = decl2.begin;
            if (!decl2.forLoop && !decl2.forLoopExplicit) {
                boolean needsDoEnd = true;
                for (Block block2 : state.blocks) {
                    if (block2.contains(decl2.begin)) {
                        int scopeEnd = block2.scopeEnd();
                        if (block2.hasCloseLine()) {
                            int closeLine2 = block2.getCloseLine();
                            int closeRegister = get_close_value(state, closeLine2);
                            if (closeRegister <= decl2.register) {
                                CloseType closeType = block2.getCloseType();
                                if (closeType == CloseType.CLOSE) {
                                    scopeEnd = closeLine2 - 1;
                                } else if (closeType == CloseType.CLOSE54) {
                                    scopeEnd = closeLine2 - 1;
                                    if (decl2.end == closeLine2) {
                                        scopeEnd = closeLine2;
                                    }
                                }
                            }
                        }
                        if (scopeEnd == decl2.end) {
                            block2.useScope();
                            needsDoEnd = false;
                            break;
                        } else if (block2.scopeEnd() < decl2.end) {
                            begin = Math.min(begin, block2.begin);
                        }
                    }
                }
                if (needsDoEnd) {
                    state.blocks.add(new DoEndBlock(state.function, begin, decl2.end + 1));
                    strictScopeCheck(state);
                }
            }
        }
    }

    private static void strictScopeCheck(State state) {
        if (state.function.header.config.strict_scope) {
            throw new RuntimeException("Violation of strict scope rule");
        }
    }

    private static boolean is_conditional(Branch b) {
        return b.type == Branch.Type.comparison || b.type == Branch.Type.test;
    }

    private static boolean is_assignment(Branch b) {
        return b.type == Branch.Type.testset;
    }

    private static boolean is_assignment(Branch b, int r) {
        if (b.type != Branch.Type.testset) {
            return b.type == Branch.Type.test && b.target == r;
        }
        return true;
    }

    private static boolean adjacent(State state, Branch branch0, Branch branch1) {
        if (branch1.finalset != null && branch0.finalset == branch1.finalset) {
            return true;
        }
        if (branch0 == null || branch1 == null) {
            return false;
        }
        boolean adjacent = branch0.targetFirst <= branch1.line;
        if (adjacent) {
            adjacent = (!has_statement(state, branch0.targetFirst, branch1.line - 1)) && !state.reverse_targets[branch1.line];
        }
        return adjacent;
    }

    private static Branch combine_left(State state, Branch branch1) {
        if (is_conditional(branch1)) {
            return combine_conditional(state, branch1);
        }
        if (is_assignment(branch1) || branch1.type == Branch.Type.finalset) {
            return combine_assignment(state, branch1);
        }
        return branch1;
    }

    private static Branch combine_conditional(State state, Branch branch1) {
        Branch branch0 = branch1.previous;
        Branch branchn = branch1;
        while (branch0 != null && branch0.line > branch1.line) {
            branch0 = branch0.previous;
        }
        while (branch0 != null && branchn == branch1 && adjacent(state, branch0, branch1)) {
            branchn = combine_conditional_helper(state, branch0, branch1);
            if (branch0.targetSecond > branch1.targetFirst) {
                break;
            }
            branch0 = branch0.previous;
        }
        return branchn;
    }

    private static Branch combine_conditional_helper(State state, Branch branch0, Branch branch1) {
        if (is_conditional(branch0) && is_conditional(branch1)) {
            int branch0TargetSecond = branch0.targetSecond;
            if (is_jmp(state, branch1.targetFirst) && state.code.target(branch1.targetFirst) == branch0TargetSecond) {
                branch0TargetSecond = branch1.targetFirst;
            }
            if (branch0TargetSecond == branch1.targetFirst) {
                Branch branch2 = combine_conditional(state, branch0);
                Condition c = new OrCondition(branch2.cond.inverse(), branch1.cond);
                Branch branchn = new Branch(branch2.line, branch1.line2, Branch.Type.comparison, c, branch1.targetFirst, branch1.targetSecond, branch1.finalset);
                branchn.inverseValue = branch1.inverseValue;
                if (verbose) {
                    System.err.println("conditional or " + branchn.line);
                }
                replace_branch(state, branch2, branch1, branchn);
                return combine_conditional(state, branchn);
            }
            if (branch0TargetSecond == branch1.targetSecond) {
                Branch branch3 = combine_conditional(state, branch0);
                Condition c2 = new AndCondition(branch3.cond, branch1.cond);
                Branch branchn2 = new Branch(branch3.line, branch1.line2, Branch.Type.comparison, c2, branch1.targetFirst, branch1.targetSecond, branch1.finalset);
                branchn2.inverseValue = branch1.inverseValue;
                if (verbose) {
                    System.err.println("conditional and " + branchn2.line);
                }
                replace_branch(state, branch3, branch1, branchn2);
                return combine_conditional(state, branchn2);
            }
        }
        return branch1;
    }

    private static Branch combine_assignment(State state, Branch branch1) {
        Branch branchn = branch1;
        for (Branch branch0 = branch1.previous; branch0 != null && branchn == branch1; branch0 = branch0.previous) {
            branchn = combine_assignment_helper(state, branch0, branch1);
            if (branch1.cond != branch1.finalset && branch0.cond != branch0.finalset && branch0.targetSecond > branch1.targetFirst) {
                break;
            }
        }
        return branchn;
    }

    private static Branch combine_assignment_helper(State state, Branch branch0, Branch branch1) {
        Branch branch2;
        Condition c;
        Branch branch3;
        Condition c2;
        Condition c3;
        if (adjacent(state, branch0, branch1)) {
            int register = branch1.target;
            if (branch1.target == -1) {
                throw new IllegalStateException();
            }
            if (is_conditional(branch0) && is_assignment(branch1)) {
                if (branch0.targetSecond == branch1.targetFirst) {
                    boolean inverse = branch0.inverseValue;
                    if (verbose) {
                        System.err.println("bridge " + (inverse ? "or" : "and") + " " + branch1.line + " " + branch0.line);
                    }
                    Branch branch4 = combine_conditional(state, branch0);
                    if (inverse != branch4.inverseValue) {
                        throw new IllegalStateException();
                    }
                    if (!branch1.inverseValue) {
                        c3 = new OrCondition(branch4.cond.inverse(), branch1.cond);
                    } else {
                        c3 = new AndCondition(branch4.cond, branch1.cond);
                    }
                    Branch branchn = new Branch(branch4.line, branch1.line2, branch1.type, c3, branch1.targetFirst, branch1.targetSecond, branch1.finalset);
                    branchn.inverseValue = branch1.inverseValue;
                    branchn.target = register;
                    replace_branch(state, branch4, branch1, branchn);
                    return combine_assignment(state, branchn);
                }
                int i = branch0.targetSecond;
                int i2 = branch1.targetSecond;
            }
            if (is_assignment(branch0, register) && is_assignment(branch1) && branch0.inverseValue == branch1.inverseValue && branch0.targetSecond == branch1.targetSecond) {
                if (verbose) {
                    System.err.println("assign " + (branch0.inverseValue ? "or" : "and") + " " + branch1.line + " " + branch0.line);
                }
                if (is_conditional(branch0)) {
                    branch3 = combine_conditional(state, branch0);
                    if (branch3.inverseValue) {
                        branch3.cond = branch3.cond.inverse();
                    }
                } else {
                    boolean inverse2 = branch0.inverseValue;
                    branch3 = combine_assignment(state, branch0);
                    if (inverse2 != branch3.inverseValue) {
                        throw new IllegalStateException();
                    }
                }
                if (branch3.inverseValue) {
                    c2 = new OrCondition(branch3.cond, branch1.cond);
                } else {
                    c2 = new AndCondition(branch3.cond, branch1.cond);
                }
                Branch branchn2 = new Branch(branch3.line, branch1.line2, branch1.type, c2, branch1.targetFirst, branch1.targetSecond, branch1.finalset);
                branchn2.inverseValue = branch1.inverseValue;
                branchn2.target = register;
                replace_branch(state, branch3, branch1, branchn2);
                return combine_assignment(state, branchn2);
            }
            if (is_assignment(branch0, register) && branch1.type == Branch.Type.finalset && branch0.targetSecond == branch1.targetSecond) {
                if (branch0.finalset != null && branch0.finalset != branch1.finalset) {
                    Branch branch = branch0.next;
                    while (true) {
                        Branch b = branch;
                        if (b == null) {
                            break;
                        }
                        if (b.cond == branch0.finalset) {
                            remove_branch(state, b);
                            break;
                        }
                        branch = b.next;
                    }
                }
                if (is_conditional(branch0)) {
                    branch2 = combine_conditional(state, branch0);
                    if (branch2.inverseValue) {
                        branch2.cond = branch2.cond.inverse();
                    }
                } else {
                    boolean inverse3 = branch0.inverseValue;
                    branch2 = combine_assignment(state, branch0);
                    if (inverse3 != branch2.inverseValue) {
                        throw new IllegalStateException();
                    }
                }
                if (verbose) {
                    System.err.println("final assign " + (branch2.inverseValue ? "or" : "and") + " " + branch1.line + " " + branch2.line);
                }
                if (branch2.inverseValue) {
                    c = new OrCondition(branch2.cond, branch1.cond);
                } else {
                    c = new AndCondition(branch2.cond, branch1.cond);
                }
                Branch branchn3 = new Branch(branch2.line, branch1.line2, Branch.Type.finalset, c, branch1.targetFirst, branch1.targetSecond, branch1.finalset);
                branchn3.target = register;
                replace_branch(state, branch2, branch1, branchn3);
                return combine_assignment(state, branchn3);
            }
        }
        return branch1;
    }

    private static void raw_add_branch(State state, Branch b) {
        if (b.type != Branch.Type.finalset) {
            if (b.type == Branch.Type.testset) {
                state.setbranches[b.line] = b;
                return;
            } else {
                state.branches[b.line] = b;
                return;
            }
        }
        List<Branch> list = state.finalsetbranches.get(b.line);
        if (list == null) {
            list = new LinkedList();
            state.finalsetbranches.set(b.line, list);
        }
        list.add(b);
    }

    private static void raw_remove_branch(State state, Branch b) {
        if (b.type == Branch.Type.finalset) {
            List<Branch> list = state.finalsetbranches.get(b.line);
            if (list == null) {
                throw new IllegalStateException();
            }
            list.remove(b);
            return;
        }
        if (b.type == Branch.Type.testset) {
            state.setbranches[b.line] = null;
        } else {
            state.branches[b.line] = null;
        }
    }

    private static void replace_branch(State state, Branch branch0, Branch branch1, Branch branchn) {
        remove_branch(state, branch0);
        raw_remove_branch(state, branch1);
        branchn.previous = branch1.previous;
        if (branchn.previous == null) {
            state.begin_branch = branchn;
        } else {
            branchn.previous.next = branchn;
        }
        branchn.next = branch1.next;
        if (branchn.next == null) {
            state.end_branch = branchn;
        } else {
            branchn.next.previous = branchn;
        }
        raw_add_branch(state, branchn);
    }

    private static void remove_branch(State state, Branch b) {
        raw_remove_branch(state, b);
        Branch prev = b.previous;
        Branch next = b.next;
        if (prev != null) {
            prev.next = next;
        } else {
            state.begin_branch = next;
        }
        if (next != null) {
            next.previous = prev;
        } else {
            state.end_branch = prev;
        }
    }

    private static void insert_branch(State state, Branch b) {
        raw_add_branch(state, b);
    }

    private static void link_branches(State state) {
        Branch[] branches;
        Branch previous = null;
        for (int index = 0; index < state.branches.length; index++) {
            for (int array = 0; array < 3; array++) {
                if (array == 0) {
                    List<Branch> list = state.finalsetbranches.get(index);
                    if (list != null) {
                        for (Branch b : list) {
                            b.previous = previous;
                            if (previous != null) {
                                previous.next = b;
                            } else {
                                state.begin_branch = b;
                            }
                            previous = b;
                        }
                    }
                } else {
                    if (array == 1) {
                        branches = state.setbranches;
                    } else {
                        branches = state.branches;
                    }
                    Branch b2 = branches[index];
                    if (b2 != null) {
                        b2.previous = previous;
                        if (previous != null) {
                            previous.next = b2;
                        } else {
                            state.begin_branch = b2;
                        }
                        previous = b2;
                    }
                }
            }
        }
        state.end_branch = previous;
    }

    private static boolean is_jmp_raw(State state, int line) {
        Op op = state.code.op(line);
        return op == Op.JMP || op == Op.JMP52 || op == Op.JMP54;
    }

    private static boolean is_jmp(State state, int line) {
        Code code = state.code;
        Op op = code.op(line);
        if (op == Op.JMP || op == Op.JMP54) {
            return true;
        }
        return op == Op.JMP52 && !is_close(state, line);
    }

    private static boolean is_break_jmp(State state, int line) {
        if (is_jmp(state, line)) {
            int target = state.code.target(line);
            Block breakable = enclosing_breakable_block(state, line);
            return breakable != null
                && (target == breakable.end || target == state.resolved[breakable.end]);
        }
        return false;
    }

    private static boolean is_close(State state, int line) {
        Code code = state.code;
        Op op = code.op(line);
        if (op == Op.CLOSE) {
            return true;
        }
        if (op == Op.JMP52) {
            int target = code.target(line);
            if (target == line + 1) {
                return code.A(line) != 0;
            }
            return line + 1 <= code.length && code.op(line + 1) == Op.JMP52 && target == code.target(line + 1) && code.A(line) != 0;
        }
        return false;
    }

    private static int get_close_value(State state, int line) {
        Code code = state.code;
        Op op = code.op(line);
        if (op == Op.CLOSE) {
            return code.A(line);
        }
        if (op == Op.JMP52) {
            return code.A(line) - 1;
        }
        throw new IllegalStateException();
    }

    private static CloseType get_close_type(State state, int line) {
        if (line < 1 || !is_close(state, line)) {
            return CloseType.NONE;
        }
        Op op = state.code.op(line);
        if (op == Op.CLOSE) {
            return state.function.header.version.closesemantics.get() == Version.CloseSemantics.LUA54 ? CloseType.CLOSE54 : CloseType.CLOSE;
        }
        return CloseType.JMP;
    }

    private static boolean has_statement(State state, int begin, int end) {
        for (int line = begin; line <= end; line++) {
            if (is_statement(state, line)) {
                return true;
            }
        }
        return state.d.hasStatement(begin, end);
    }

    private static boolean is_statement(State state, int line) {
        if (state.reverse_targets[line]) {
            return true;
        }
        Registers r = state.r;
        if (!r.getNewLocals(line).isEmpty()) {
            return true;
        }
        Code code = state.code;
        if (code.isUpvalueDeclaration(line)) {
            return false;
        }
        switch ($SWITCH_TABLE$unluac$decompile$Op()[code.op(line).ordinal()]) {
            case 1:
            case 2:
            case Expression.PRECEDENCE_COMPARE /* 3 */:
            case Expression.PRECEDENCE_BXOR /* 5 */:
            case Expression.PRECEDENCE_BAND /* 6 */:
            case Expression.PRECEDENCE_SHIFT /* 7 */:
            case Expression.PRECEDENCE_UNARY /* 11 */:
            case Expression.PRECEDENCE_ATOMIC /* 13 */:
            case 14:
            case 15:
            case 16:
            case 17:
            case 18:
            case 19:
            case 20:
            case 21:
            case 22:
            case CodeExtract.BITFIELD_BX /* 28 */:
            case 37:
            case 41:
            case 42:
            case 48:
            case 53:
            case 54:
            case 55:
            case 56:
            case 57:
            case 58:
            case 59:
            case 60:
            case 61:
            case 62:
            case 63:
            case 64:
            case 65:
            case 66:
            case 67:
            case 68:
            case 73:
            case 103:
            case 116:
                return r.isLocal(code.A(line), line);
            case 4:
                for (int register = code.A(line); register <= code.B(line); register++) {
                    if (r.isLocal(register, line)) {
                        return true;
                    }
                }
                return false;
            case 8:
            case Expression.PRECEDENCE_ADD /* 9 */:
            case CodeExtract.BITFIELD_AX /* 30 */:
            case CodeExtract.BITFIELD_X /* 31 */:
            case 32:
            case 33:
            case 34:
            case 36:
            case 43:
            case 45:
            case 46:
            case 51:
            case 69:
            case 104:
            case 117:
            case 118:
            case 119:
            case 120:
            case 121:
            case 122:
            case 123:
            case 124:
            case 125:
                return true;
            case Expression.PRECEDENCE_MUL /* 10 */:
            case 70:
            case 71:
            case 72:
                return false;
            case Expression.PRECEDENCE_POW /* 12 */:
            case 74:
                return r.isLocal(code.A(line), line) || r.isLocal(code.A(line) + 1, line);
            case 23:
            case 39:
            case 105:
                if (line == 1) {
                    return true;
                }
                Op prev = line >= 2 ? code.op(line - 1) : null;
                Op next = line + 1 <= code.length ? code.op(line + 1) : null;
                if (prev == Op.EQ || prev == Op.LT || prev == Op.LE || prev == Op.EQ54 || prev == Op.LT54 || prev == Op.LE54 || prev == Op.EQK || prev == Op.EQI || prev == Op.LTI || prev == Op.LEI || prev == Op.GTI || prev == Op.GEI || prev == Op.TEST50 || prev == Op.TEST || prev == Op.TEST54 || prev == Op.TESTSET || prev == Op.TESTSET54) {
                    return false;
                }
                return (next != Op.LOADBOOL || code.C(line + 1) == 0) && next != Op.LFALSESKIP;
            case 24:
            case 25:
            case 26:
            case 27:
            case 35:
            case 44:
            case 47:
            case 49:
            case 50:
            case 106:
            case 107:
            case 108:
            case 109:
            case 110:
            case 111:
            case 112:
            case 113:
            case 114:
            case 115:
            case 126:
            case 128:
            case 129:
                return false;
            case LFloatNumber.NAN_SHIFT_OFFSET /* 29 */:
                int a = code.A(line);
                int c = code.C(line);
                if (c == 1) {
                    return true;
                }
                if (c == 0) {
                    c = (r.registers - a) + 1;
                }
                for (int register2 = a; register2 < (a + c) - 1; register2++) {
                    if (r.isLocal(register2, line)) {
                        return true;
                    }
                }
                return false;
            case 38:
                int a2 = code.A(line);
                int b = code.B(line);
                if (b == 0) {
                    b = (r.registers - a2) + 1;
                }
                for (int register3 = a2; register3 < (a2 + b) - 1; register3++) {
                    if (r.isLocal(register3, line)) {
                        return true;
                    }
                }
                return false;
            case 40:
                for (int register4 = code.A(line); register4 <= code.A(line) + code.B(line); register4++) {
                    if (r.isLocal(register4, line)) {
                        return true;
                    }
                }
                return false;
            case 52:
                return code.A(line) != code.B(line) && r.isLocal(code.A(line), line);
            case 75:
            case 76:
            case 77:
            case 78:
            case 79:
            case TestFile.DEFAULT_VERSION /* 80 */:
            case 81:
            case 82:
            case 83:
            case 84:
            case 85:
            case 86:
            case 87:
            case 88:
            case 89:
            case 90:
            case 91:
            case 92:
            case 93:
            case 94:
            case 95:
            case 96:
            case 97:
            case 98:
            case 99:
                return false;
            case 100:
            case 101:
            case 102:
                if (line <= 1) {
                    throw new IllegalStateException();
                }
                return r.isLocal(code.A(line - 1), line - 1);
            case 127:
                int a3 = code.A(line);
                int c2 = code.C(line);
                if (c2 == 0) {
                    c2 = (r.registers - a3) + 1;
                }
                for (int register5 = a3; register5 < (a3 + c2) - 1; register5++) {
                    if (r.isLocal(register5, line)) {
                        return true;
                    }
                }
                return false;
            case 130:
            case 131:
                throw new IllegalStateException();
            default:
                throw new IllegalStateException("Illegal opcode: " + code.op(line));
        }
    }

    private ControlFlowHandler() {
    }
}
