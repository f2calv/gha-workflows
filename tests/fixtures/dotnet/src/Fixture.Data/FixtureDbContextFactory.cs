using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace Fixture.Data;

/// <summary>Design-time factory used by <c>dotnet ef</c>; no database is opened.</summary>
public sealed class FixtureDbContextFactory : IDesignTimeDbContextFactory<FixtureDbContext>
{
    /// <inheritdoc />
    public FixtureDbContext CreateDbContext(string[] args) =>
        new(new DbContextOptionsBuilder<FixtureDbContext>().UseSqlite("Data Source=fixture.db").Options);
}
