using System.Globalization;
using System.Linq;
using Content.Client.Guidebook;
using Content.Client.Guidebook.Richtext;
using Content.Shared.Guidebook;
using Robust.Shared.ContentPack;
using Robust.Shared.Localization;
using Robust.Shared.Prototypes;
using Robust.Shared.Utility;

namespace Content.IntegrationTests.Tests.Guidebook;

[TestFixture]
[TestOf(typeof(GuidebookDocumentResolver))]
public sealed class GuidebookDocumentLocalizationTest
{
    [Test]
    public async Task SelectsSpanishMirrorsAndFallsBackToBaseDocuments()
    {
        await using var pair = await PoolManager.GetServerClient(new PoolSettings { Connected = true });
        var client = pair.Client;
        await client.WaitIdleAsync();

        var localization = client.ResolveDependency<ILocalizationManager>();
        var parser = client.ResolveDependency<DocumentParsingManager>();
        var prototypes = client.ResolveDependency<IPrototypeManager>();
        var resources = client.ResolveDependency<IResourceManager>();

        try
        {
            await client.WaitAssertion(() =>
            {
                var originalCulture = localization.DefaultCulture;
                Assert.That(originalCulture?.Name, Is.EqualTo("es-ES"));

                try
                {
                    var entries = prototypes
                        .EnumeratePrototypes<GuideEntryPrototype>()
                        .ToList();
                    var spanishDocuments = resources
                        .ContentFindFiles(new ResPath("/ServerInfo/es-ES/Guidebook/"))
                        .Where(path => path.ToString().EndsWith(".xml", StringComparison.Ordinal))
                        .OrderBy(path => path.ToString(), StringComparer.Ordinal)
                        .ToList();

                    Assert.That(spanishDocuments, Is.Not.Empty);
                    foreach (var spanishPath in spanishDocuments)
                    {
                        var basePath = new ResPath(spanishPath.ToString().Replace(
                            "/ServerInfo/es-ES/",
                            "/ServerInfo/",
                            StringComparison.Ordinal));
                        var owners = entries.Where(entry => entry.Text == basePath).ToList();
                        Assert.That(
                            owners,
                            Is.Not.Empty,
                            $"Localized Guidebook mirror has no active GuideEntry owner: {spanishPath}");

                        var entry = owners[0];
                        Assert.That(parser.ResolveDocumentPath(entry.Text), Is.EqualTo(spanishPath));
                        Assert.That(
                            parser.TryAddMarkup(new Document(), (GuideEntry) entry),
                            Is.True,
                            $"Failed to parse Spanish Guidebook mirror: {entry.ID} at {spanishPath}");
                    }

                    localization.DefaultCulture = CultureInfo.GetCultureInfo("en-US");
                    foreach (var spanishPath in spanishDocuments)
                    {
                        var basePath = new ResPath(spanishPath.ToString().Replace(
                            "/ServerInfo/es-ES/",
                            "/ServerInfo/",
                            StringComparison.Ordinal));
                        var entry = entries.First(candidate => candidate.Text == basePath);
                        Assert.That(parser.ResolveDocumentPath(entry.Text), Is.EqualTo(basePath));
                        Assert.That(
                            parser.TryAddMarkup(new Document(), (GuideEntry) entry),
                            Is.True,
                            $"Failed to parse base Guidebook fallback: {entry.ID} at {basePath}");
                    }
                }
                finally
                {
                    if (originalCulture != null)
                        localization.DefaultCulture = originalCulture;
                }
            });
        }
        finally
        {
            await pair.CleanReturnAsync();
        }
    }
}
