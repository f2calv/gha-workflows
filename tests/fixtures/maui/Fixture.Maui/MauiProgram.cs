namespace Fixture.Maui;

/// <summary>Creates the fixture's MAUI application.</summary>
public static class MauiProgram
{
    /// <summary>Creates the application host.</summary>
    /// <returns>The configured application.</returns>
    public static MauiApp CreateMauiApp() => MauiApp.CreateBuilder().UseMauiApp<App>().Build();
}
