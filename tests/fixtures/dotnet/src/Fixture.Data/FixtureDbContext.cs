using Microsoft.EntityFrameworkCore;

namespace Fixture.Data;

/// <summary>Model-less context that lets CI exercise the migration drift workflow.</summary>
public sealed class FixtureDbContext(DbContextOptions<FixtureDbContext> options) : DbContext(options);
