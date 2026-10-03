using System;
using System.IO;
using System.Linq;
using System.Reflection.Metadata;
using System.Reflection.PortableExecutable;
using System.Text;

class Program
{
    static int Main(string[] args)
    {
        foreach (var path in args)
        {
            Console.WriteLine($"== {path} ({new FileInfo(path).Length} bytes)");
            try
            {
                using var fs = File.OpenRead(path);
                using var pe = new PEReader(fs);
                var headers = pe.PEHeaders;
                Console.WriteLine($"   magic={headers.PEHeader.Magic} machine={headers.CoffHeader.Machine} " +
                                  $"sections={headers.SectionHeaders.Length} corHeader={(headers.CorHeader is null ? "null" : "present")}");
                if (headers.CorHeader is not null)
                {
                    var dir = headers.CorHeader.MetadataDirectory;
                    Console.WriteLine($"   md rva={dir.RelativeVirtualAddress:#x} size={dir.Size:#x}");
                    var block = pe.GetMetadata();
                    var image = new byte[block.Length];
                    unsafe
                    {
                        for (var i = 0; i < block.Length; i++)
                            image[i] = block.Pointer[i];
                    }
                    Console.WriteLine($"   metadata block len={image.Length} sig={Encoding.ASCII.GetString(image, 0, 4)}");
                    using var provider = MetadataReaderProvider.FromMetadataImage(System.Collections.Immutable.ImmutableArray.Create(image));
                    var reader = provider.GetMetadataReader();
                    Console.WriteLine($"   version={reader.MetadataVersion} types={reader.TypeDefinitions.Count} methods={reader.MethodDefinitions.Count}");
                    foreach (var handle in reader.TypeDefinitions.Take(5))
                        Console.WriteLine("   type: " + reader.GetString(reader.GetTypeDefinition(handle).Name));
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("   EXCEPTION: " + ex.GetType().Name + ": " + ex.Message);
                Console.WriteLine("   " + (ex.StackTrace ?? "").Replace("\n", "\n   "));
            }
        }
        return 0;
    }
}