namespace Fixture.Maui;

/// <summary>Shows one label; the fixture exists only to be built and published.</summary>
public sealed class App : Application
{
    /// <inheritdoc/>
    protected override Window CreateWindow(IActivationState? activationState) =>
        new(new ContentPage { Content = new Label { Text = "Fixture" } });
}
