import unluac.Main;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

/**
 * Disassembles one chunk, reusing UnluacBatch's header normalisation.
 *
 * Exists because UnluacBatch only writes a .disasm.txt listing when unluac
 * *throws*. A chunk that decompiles cleanly but emits control flow unluac's
 * own Lua parser rejects (a goto whose label sits inside a block) is reported
 * as a success, so reconstructing it needs a way to ask for the listing
 * directly.
 *
 * Usage: java -cp classes:unluac.jar DisasmOne <chunk> <out.disasm.txt>
 */
public class DisasmOne {

    public static void main(String[] args) throws Exception {
        if (args.length != 2) {
            System.err.println("usage: DisasmOne <chunk> <out.disasm.txt>");
            System.exit(2);
        }
        Path chunk = Paths.get(args[0]);
        Path out = Paths.get(args[1]);

        // Stage through a temp file so the normalised header never overwrites
        // the recovered bytecode tree.
        Path tmp = Files.createTempFile("disasm", ".luac");
        try {
            Files.write(tmp, UnluacBatch.normalise(Files.readAllBytes(chunk)));
            Main.disassemble(tmp.toString(), out.toString());
        } finally {
            Files.deleteIfExists(tmp);
        }
        System.out.printf("%s -> %s (%d bytes)%n", chunk, out, Files.size(out));
    }
}
