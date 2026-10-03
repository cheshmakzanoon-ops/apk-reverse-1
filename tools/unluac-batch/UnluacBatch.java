import unluac.Configuration;
import unluac.Main;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.charset.StandardCharsets;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Batch-decompiles the game's Lua bytecode with unluac inside one JVM.
 *
 * Spawning a JVM per chunk for 18,300 files would cost far more in startup than
 * in decompilation, so this driver loops in-process. It is resumable: a chunk
 * whose .lua already exists is skipped, which lets the run be split across
 * several bounded invocations without losing or repeating work.
 *
 * Header normalisation lives here rather than in a separate pass over the disk.
 * The studio's luac emits a 4-size-byte header and a 0x01 format byte; upstream
 * Lua 5.3 (and unluac's LHeaderType53) expects a 0x00 format byte followed by
 * five size bytes [int][size_t][instruction][integer][float]. Converting in
 * memory avoids writing a second ~100 MB copy of the bytecode tree.
 *
 * Usage: java -cp unluac.jar:. UnluacBatch <luacRoot> <luaOutRoot> [--force]
 */
public class UnluacBatch {

    private static final byte[] LUA_SIG = {0x1b, 'L', 'u', 'a'};
    private static final byte[] LUAC_DATA = {0x19, (byte) 0x93, '\r', '\n', 0x1a, '\n'};

    /**
     * Rewrites the studio chunk header into the standard Lua 5.3 layout.
     *
     * studio: sig(4) ver(1) fmt=01(1) DATA(6) 04 04 08 08  LUAC_INT(8) LUAC_NUM(8)
     * std   : sig(4) ver(1) fmt=00(1) DATA(6) 04    04 04 08 08 LUAC_INT LUAC_NUM
     *                       int  size_t ins int flo
     *
     * Only the header changes; every byte of prototype, code, constants and
     * debug info is passed through untouched.
     */
    static byte[] normalise(byte[] b) {
        if (b.length < 32
                || b[0] != LUA_SIG[0] || b[1] != LUA_SIG[1]
                || b[2] != LUA_SIG[2] || b[3] != LUA_SIG[3]
                || b[5] != 0x01
                || b[6] != LUAC_DATA[0] || b[7] != LUAC_DATA[1]
                || b[8] != LUAC_DATA[2] || b[9] != LUAC_DATA[3]
                || b[10] != LUAC_DATA[4] || b[11] != LUAC_DATA[5]) {
            return b; // already standard, or not a chunk we recognise
        }
        ByteArrayOutputStream out = new ByteArrayOutputStream(b.length + 1);
        out.write(b, 0, 5);        // signature + version
        out.write(0x00);           // format byte
        out.write(b, 6, 6);        // LUAC_DATA
        out.write(0x04);           // sizeof(int)
        out.write(b, 12, 4);       // size_t, instruction, integer, number
        out.write(b, 16, b.length - 16);  // LUAC_INT, LUAC_NUM, body
        return out.toByteArray();
    }

    public static void main(String[] args) throws Exception {
        if (args.length < 2) {
            System.err.println("usage: UnluacBatch <luacRoot> <luaOutRoot> [--force]");
            System.exit(2);
        }
        Path rootIn = Paths.get(args[0]);
        Path rootOut = Paths.get(args[1]);
        boolean force = args.length > 2 && "--force".equals(args[2]);

        if (!Files.isDirectory(rootIn)) {
            System.err.println("error: not a directory: " + rootIn);
            System.exit(1);
        }

        List<Path> files = new ArrayList<>();
        // Not just *.luac: the game's data tables (assets/table/*.data) are the
        // same studio bytecode but stored without an extension, so select by
        // magic instead of by name.
        Files.walk(rootIn).filter(Files::isRegularFile).forEach(files::add);
        Collections.sort(files);

        int ok = 0, skipped = 0, failed = 0, empty = 0;
        long start = System.currentTimeMillis();
        // Written fresh each run, not appended: a chunk that failed on an early
        // attempt but succeeded later (bigger heap, say) must not stay listed.
        List<String> failures = new ArrayList<>();

        for (Path p : files) {
            String rel = rootIn.relativize(p).toString();
            String relLua = rel.endsWith(".luac")
                    ? rel.substring(0, rel.length() - 5) + ".lua"
                    : rel + ".lua";
            Path out = rootOut.resolve(relLua);

            if (!force && Files.exists(out) && Files.size(out) > 0) {
                skipped++;
                continue;
            }
            Files.createDirectories(out.getParent());

            // Skip anything that is not a Lua chunk rather than reporting it.
            byte[] probe = new byte[5];
            try (java.io.InputStream in = Files.newInputStream(p)) {
                if (in.read(probe) < 5 || probe[0] != (byte) 0x1b
                        || probe[1] != 'L' || probe[2] != 'u' || probe[3] != 'a') {
                    skipped++;
                    continue;
                }
            } catch (IOException e) {
                failed++;
                failures.add(rel + "\t" + e.toString());
                continue;
            }

            // unluac reads from a path, so stage through a temp file and move
            // into place atomically: a killed run must not leave a half-written
            // .lua that the next (skip-if-exists) pass would treat as done.
            Path tmp = Files.createTempFile("chunk", ".luac");
            Path tmpOut = Files.createTempFile("chunk", ".lua");
            try {
                Files.write(tmp, normalise(Files.readAllBytes(p)));
                Main.decompile(tmp.toString(), tmpOut.toString(), new Configuration());
                long sz = Files.size(tmpOut);
                if (sz == 0) {
                    // Not a decompiler failure: some shipped modules really are
                    // empty. The disassembly of such a chunk is a lone `return`
                    // with no constants or code, i.e. the original .lua held
                    // nothing but comments. Keep the empty file, count it
                    // separately, and do not report it as a failure.
                    Files.write(out, new byte[0]);
                    empty++;
                    continue;
                }
                Files.move(tmpOut, out, StandardCopyOption.REPLACE_EXISTING);
                ok++;
            } catch (Throwable t) {
                // Real unluac limitation (e.g. its known NPE on some loop
                // shapes). Don't drop the chunk: keep the bytecode listing so
                // the logic is still recoverable by hand.
                failed++;
                failures.add(rel + "\t" + t.toString().replace('\n', ' '));
                try {
                    Path dis = out.resolveSibling(
                            out.getFileName().toString().replaceAll("\\.lua$", ".disasm.txt"));
                    Main.disassemble(tmp.toString(), dis.toString());
                } catch (Throwable ignored) {
                    // listing unavailable; the failure is already logged
                }
            } finally {
                Files.deleteIfExists(tmp);
                Files.deleteIfExists(tmpOut);
            }

            if ((ok + empty + failed) % 2000 == 0) {
                System.out.printf("  %d/%d  ok=%d empty=%d fail=%d skip=%d  %.0fs%n",
                        ok + empty + failed, files.size(), ok, empty, failed, skipped,
                        (System.currentTimeMillis() - start) / 1000.0);
                System.out.flush();
            }
        }

        Path flog = Paths.get(System.getProperty("unluac.failures", "unluac-failures.tsv"));
        if (failures.isEmpty()) {
            Files.deleteIfExists(flog);
        } else {
            Files.write(flog, failures, StandardCharsets.UTF_8);
        }

        System.out.printf(
                "done: %d files, ok=%d empty-source=%d fail=%d skipped=%d in %.0fs%n",
                files.size(), ok, empty, failed, skipped,
                (System.currentTimeMillis() - start) / 1000.0);
        if (!failures.isEmpty()) {
            System.out.printf("   %d chunk(s) unluac could not decompile; each has a"
                    + " .disasm.txt listing. Listed in %s%n", failed, flog);
        }

        // Per-chunk failures are data, not a process failure: unluac has known
        // gaps (e.g. an NPE on some loop shapes) and those chunks are preserved
        // as bytecode listings, so the run still did its job. Exiting non-zero
        // for them would abort the calling pipeline under `set -e` and strand
        // every later stage.
        //
        // What must still fail loudly is a *systemic* breakage - wrong inputs,
        // a broken tool - where most chunks could not be read at all.
        int attempted = ok + empty + failed;
        boolean systemic = attempted > 0 && failed > attempted / 2;
        if (systemic) {
            System.err.printf("error: %d of %d attempted chunks failed to decompile;"
                    + " this looks systemic, not a per-chunk limitation%n",
                    failed, attempted);
        }
        System.exit(systemic ? 1 : 0);
    }

    private static void recordFailure(String rel, String err) throws IOException {
        Path log = Paths.get(System.getProperty("unluac.failures", "unluac-failures.tsv"));
        Files.createDirectories(log.toAbsolutePath().getParent());
        try (PrintStream ps = new PrintStream(Files.newOutputStream(log,
                java.nio.file.StandardOpenOption.CREATE,
                java.nio.file.StandardOpenOption.APPEND), true, "UTF-8")) {
            ps.println(rel + "\t" + err.replace('\n', ' '));
        }
    }
}
