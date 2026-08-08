using Content.Shared._CMU14.Medical.Treatment.Surgery;
using Moq;
using NUnit.Framework;
using Robust.Shared.Localization;

namespace Content.Tests.Shared._CMU14.Medical.Treatment.Surgery;

[TestFixture]
public sealed class CMUSurgeryLocalizationTest
{
    [Test]
    public void ResolveUsesDeclaredLocalizationThenFallbackChain()
    {
        var localization = new Mock<ILocalizationManager>(MockBehavior.Strict);
        string translated = "Reducir fractura";
        localization
            .Setup(manager => manager.TryGetString(
                "cmu-medical-surgery-procedure-set-fracture",
                out translated))
            .Returns(true);
        string missing = null!;
        localization
            .Setup(manager => manager.TryGetString(
                "cmu-medical-surgery-procedure-missing",
                out missing))
            .Returns(false);

        Assert.Multiple(() =>
        {
            Assert.That(
                CMUSurgeryLocalization.Resolve(
                    localization.Object,
                    "cmu-medical-surgery-procedure-set-fracture",
                    "Set Fracture",
                    "Set fracture entity",
                    "CMUSurgerySetSimpleFracture"),
                Is.EqualTo("Reducir fractura"));
            Assert.That(
                CMUSurgeryLocalization.Resolve(
                    localization.Object,
                    "cmu-medical-surgery-procedure-missing",
                    "Set Fracture",
                    "Set fracture entity",
                    "CMUSurgerySetSimpleFracture"),
                Is.EqualTo("Set Fracture"));
            Assert.That(
                CMUSurgeryLocalization.Resolve(
                    localization.Object,
                    null,
                    "Set Fracture",
                    "Set fracture entity",
                    "CMUSurgerySetSimpleFracture"),
                Is.EqualTo("Set Fracture"));
            Assert.That(
                CMUSurgeryLocalization.Resolve(
                    localization.Object,
                    null,
                    string.Empty,
                    "Set fracture entity",
                    "CMUSurgerySetSimpleFracture"),
                Is.EqualTo("Set fracture entity"));
            Assert.That(
                CMUSurgeryLocalization.Resolve(
                    localization.Object,
                    null,
                    string.Empty,
                    string.Empty,
                    "CMUSurgerySetSimpleFracture"),
                Is.EqualTo("CMUSurgerySetSimpleFracture"));
        });
    }
}
