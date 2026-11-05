using Android.App;
using Android.Runtime;

namespace Fixture.Maui;

/// <summary>Android application that hosts MAUI.</summary>
/// <param name="handle">The Java object handle.</param>
/// <param name="ownership">The handle ownership.</param>
[Application]
public sealed class MainApplication(IntPtr handle, JniHandleOwnership ownership) : MauiApplication(handle, ownership)
{
    /// <inheritdoc/>
    protected override MauiApp CreateMauiApp() => MauiProgram.CreateMauiApp();
}
