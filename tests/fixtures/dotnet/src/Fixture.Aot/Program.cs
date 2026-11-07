using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

Console.Out.WriteLine($"{Environment.GetEnvironmentVariable("GIT_TAG")}|{RuntimeInformation.ProcessArchitecture}|{RuntimeFeature.IsDynamicCodeSupported}");
