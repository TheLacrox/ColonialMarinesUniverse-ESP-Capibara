using Robust.Shared.GameObjects;
using Robust.Shared.Localization;
using Robust.Shared.Map;

namespace Content.IntegrationTests.Tests.Localization;

[TestFixture]
public sealed class SpanishLocalizationTest
{
    [TestPrototypes]
    private const string Prototypes = """
        - type: entity
          id: SpanishGrammarFeminine
          name: puerta
          components:
          - type: Grammar
            attributes:
              gender: female
        """;

    [Test]
    public async Task SpanishIsTheDefaultCultureAndFallsBackToEnglish()
    {
        await using var pair = await PoolManager.GetServerClient();
        var localization = pair.Server.ResolveDependency<ILocalizationManager>();
        var entities = pair.Server.ResolveDependency<IEntityManager>();

        try
        {
            Assert.Multiple(() =>
            {
                Assert.That(localization.DefaultCulture?.Name, Is.EqualTo("es-ES"));
                Assert.That(localization.GetString("access-reader-unknown-id"), Is.EqualTo("Desconocida"));

                // Personal-name datasets deliberately remain in English and exercise the fallback bundle.
                Assert.That(localization.GetString("names-first-dataset-1"), Is.EqualTo("Aaden"));
            });

            await pair.Server.WaitAssertion(() =>
            {
                var entity = entities.SpawnEntity("SpanishGrammarFeminine", MapCoordinates.Nullspace);
                try
                {
                    Assert.Multiple(() =>
                    {
                        Assert.That(
                            localization.GetString("agent-id-new", ("number", 1), ("card", entity)),
                            Is.EqualTo("Se obtuvo un acceso nuevo de la puerta."));
                        Assert.That(
                            localization.GetString("comp-hands-examine-wrapper", ("item", entity)),
                            Is.EqualTo("una [color=paleturquoise]puerta[/color]"));
                        Assert.That(
                            localization.GetString(
                                "cuffable-component-start-uncuffing-self-observer",
                                ("user", entity),
                                ("target", entity)),
                            Does.Contain("sí misma"));
                        Assert.That(
                            localization.GetString("chat-emote-msg-clap-single", ("entity", entity)),
                            Does.Contain("sus manos"));
                        Assert.That(
                            localization.GetString("petting-failure-bat", ("target", entity)),
                            Does.Contain("es demasiado difícil"));
                    });
                }
                finally
                {
                    entities.DeleteEntity(entity);
                }
            });
        }
        finally
        {
            await pair.CleanReturnAsync();
        }
    }
}
