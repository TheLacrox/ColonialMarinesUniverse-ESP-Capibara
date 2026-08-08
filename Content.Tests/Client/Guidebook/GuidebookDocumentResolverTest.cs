using System.Globalization;
using Content.Client.Guidebook;
using Moq;
using NUnit.Framework;
using Robust.Shared.ContentPack;
using Robust.Shared.Utility;

namespace Content.Tests.Client.Guidebook;

[TestFixture]
public sealed class GuidebookDocumentResolverTest
{
    private static readonly ResPath BasePath = new("/ServerInfo/Guidebook/_RMC14/Guides/RMCGuideNewPlayer.xml");
    private static readonly ResPath SpanishPath = new("/ServerInfo/es-ES/Guidebook/_RMC14/Guides/RMCGuideNewPlayer.xml");

    [Test]
    public void SelectsLocalizedMirrorWhenItExists()
    {
        var resources = new Mock<IResourceManager>(MockBehavior.Strict);
        resources
            .Setup(manager => manager.ContentFileExists(SpanishPath))
            .Returns(true);

        var result = GuidebookDocumentResolver.Resolve(
            resources.Object,
            BasePath,
            CultureInfo.GetCultureInfo("es-ES"));

        Assert.That(result, Is.EqualTo(SpanishPath));
        resources.VerifyAll();
    }

    [Test]
    public void FallsBackToBaseDocumentWhenMirrorIsMissing()
    {
        var resources = new Mock<IResourceManager>(MockBehavior.Strict);
        resources
            .Setup(manager => manager.ContentFileExists(SpanishPath))
            .Returns(false);

        var result = GuidebookDocumentResolver.Resolve(
            resources.Object,
            BasePath,
            CultureInfo.GetCultureInfo("es-ES"));

        Assert.That(result, Is.EqualTo(BasePath));
        resources.VerifyAll();
    }

    [Test]
    public void LeavesUnsupportedPathsAndCulturesUnchanged()
    {
        var resources = new Mock<IResourceManager>(MockBehavior.Strict);
        var outsidePath = new ResPath("/Maps/example.yml");

        Assert.Multiple(() =>
        {
            Assert.That(
                GuidebookDocumentResolver.Resolve(resources.Object, outsidePath, CultureInfo.GetCultureInfo("es-ES")),
                Is.EqualTo(outsidePath));
            Assert.That(
                GuidebookDocumentResolver.Resolve(resources.Object, BasePath, null),
                Is.EqualTo(BasePath));
            Assert.That(
                GuidebookDocumentResolver.Resolve(resources.Object, BasePath, CultureInfo.InvariantCulture),
                Is.EqualTo(BasePath));
        });
    }
}
