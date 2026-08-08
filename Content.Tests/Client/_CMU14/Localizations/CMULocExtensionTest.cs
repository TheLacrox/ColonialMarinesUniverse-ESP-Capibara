using Content.Client._CMU14.Localizations;
using Content.Shared._CMU14.Localizations;
using Moq;
using NUnit.Framework;
using Robust.Shared.Enums;
using Robust.Shared.Localization;

namespace Content.Tests.Client._CMU14.Localizations;

[TestFixture]
public sealed class CMULocExtensionTest
{
    [Test]
    public void JobNameUsesTranslatedMessage()
    {
        var localization = new Mock<ILocalizationManager>();
        string translated = "oficial piloto";
        localization
            .Setup(manager => manager.TryGetString(
                "job-PilotOfficer-name",
                out translated,
                It.IsAny<(string, object)[]>()))
            .Returns(true);

        var result = CMUPrototypeLocalization.GetJobName(
            localization.Object,
            "PilotOfficer",
            "Pilot Officer");

        Assert.That(result, Is.EqualTo("oficial piloto"));
    }

    [Test]
    public void JobDescriptionUsesFallbackWhenMessageIsMissing()
    {
        var localization = new Mock<ILocalizationManager>();
        string missing = null;
        localization
            .Setup(manager => manager.TryGetString(
                "job-PilotOfficer-description",
                out missing,
                It.IsAny<(string, object)[]>()))
            .Returns(false);

        var result = CMUPrototypeLocalization.GetJobDescription(
            localization.Object,
            "PilotOfficer",
            "Pilota la nave de descenso.");

        Assert.That(result, Is.EqualTo("Pilota la nave de descenso."));
    }

    [Test]
    public void RankNameUsesTranslatedMessage()
    {
        var localization = new Mock<ILocalizationManager>();
        string translated = "soldado";
        localization
            .Setup(manager => manager.TryGetString(
                "rank-RMCRankPrivate",
                out translated,
                It.IsAny<(string, object)[]>()))
            .Returns(true);

        var result = CMUPrototypeLocalization.GetRankName(
            localization.Object,
            "RMCRankPrivate",
            "Private");

        Assert.That(result, Is.EqualTo("soldado"));
    }

    [Test]
    public void RankPrefixesUseTranslatedAttributesAndFallback()
    {
        var localization = new Mock<ILocalizationManager>();
        string translated = "Civ.";
        localization
            .Setup(manager => manager.TryGetString(
                "rank-RMCRankCivilian.prefix",
                out translated,
                It.IsAny<(string, object)[]>()))
            .Returns(true);
        string translatedMale = "Sr.";
        localization
            .Setup(manager => manager.TryGetString(
                "rank-RMCRankCivilian.prefix-male",
                out translatedMale,
                It.IsAny<(string, object)[]>()))
            .Returns(true);
        string translatedFemale = "Sra.";
        localization
            .Setup(manager => manager.TryGetString(
                "rank-RMCRankCivilian.prefix-female",
                out translatedFemale,
                It.IsAny<(string, object)[]>()))
            .Returns(true);

        Assert.Multiple(() =>
        {
            Assert.That(
                CMUPrototypeLocalization.GetRankPrefix(
                    localization.Object,
                    "RMCRankCivilian",
                    "Civ."),
                Is.EqualTo("Civ."));
            Assert.That(
                CMUPrototypeLocalization.GetRankPrefix(
                    localization.Object,
                    "RMCRankCivilian",
                    "Mr.",
                    Gender.Male),
                Is.EqualTo("Sr."));
            Assert.That(
                CMUPrototypeLocalization.GetRankPrefix(
                    localization.Object,
                    "RMCRankCivilian",
                    "Ms.",
                    Gender.Female),
                Is.EqualTo("Sra."));
            Assert.That(
                CMUPrototypeLocalization.GetRankPrefix(
                    localization.Object,
                    "Missing",
                    "Fallback"),
                Is.EqualTo("Fallback"));
        });
    }

    [Test]
    public void GuideEntryNameUsesTranslatedMessage()
    {
        var localization = new Mock<ILocalizationManager>();
        string translated = "medicina básica";
        localization
            .Setup(manager => manager.TryGetString(
                "guide-entry-MedicalBasics-name",
                out translated,
                It.IsAny<(string, object)[]>()))
            .Returns(true);

        var result = CMUPrototypeLocalization.GetGuideEntryName(
            localization.Object,
            "MedicalBasics",
            "Medical Basics");

        Assert.That(result, Is.EqualTo("medicina básica"));
    }

    [Test]
    public void TileNameUsesTranslatedMessage()
    {
        var localization = new Mock<ILocalizationManager>();
        string translated = "suelo Yautja";
        localization
            .Setup(manager => manager.TryGetString(
                "tile-HunterFloor-name",
                out translated,
                It.IsAny<(string, object)[]>()))
            .Returns(true);

        var result = CMUPrototypeLocalization.GetTileName(
            localization.Object,
            "HunterFloor",
            "hunter floor");

        Assert.That(result, Is.EqualTo("suelo Yautja"));
    }

    [Test]
    public void ConstructionStepNameUsesTranslatedMessageAndFallback()
    {
        var localization = new Mock<ILocalizationManager>();
        string translated = "piezas de estantería";
        localization
            .Setup(manager => manager.TryGetString(
                "construction-step-rack-parts-name",
                out translated,
                It.IsAny<(string, object)[]>()))
            .Returns(true);
        string missing = null;
        localization
            .Setup(manager => manager.TryGetString(
                "construction-step-unknown-part-name",
                out missing,
                It.IsAny<(string, object)[]>()))
            .Returns(false);

        Assert.Multiple(() =>
        {
            Assert.That(
                CMUPrototypeLocalization.GetConstructionStepName(
                    localization.Object,
                    "rack parts"),
                Is.EqualTo("piezas de estantería"));
            Assert.That(
                CMUPrototypeLocalization.GetConstructionStepName(
                    localization.Object,
                    "unknown part"),
                Is.EqualTo("unknown part"));
        });
    }

    [Test]
    public void PrototypeTextUsesOverrideThenConfiguredLocalizationThenLiteral()
    {
        var localization = new Mock<ILocalizationManager>();
        string translatedOverride = "Alerta de evacuación";
        localization
            .Setup(manager => manager.TryGetString(
                "announcement-preset-MarineAlertLevel-name",
                out translatedOverride,
                It.IsAny<(string, object)[]>()))
            .Returns(true);
        string translatedConfigured = "Nombre configurado";
        localization
            .Setup(manager => manager.TryGetString(
                "configured-preset-name",
                out translatedConfigured,
                It.IsAny<(string, object)[]>()))
            .Returns(true);

        Assert.Multiple(() =>
        {
            Assert.That(
                CMUPrototypeLocalization.GetPrototypeText(
                    localization.Object,
                    "announcement-preset",
                    "MarineAlertLevel",
                    "name",
                    "Evacuation Alert"),
                Is.EqualTo("Alerta de evacuación"));
            Assert.That(
                CMUPrototypeLocalization.GetPrototypeText(
                    localization.Object,
                    "announcement-preset",
                    "UntranslatedPreset",
                    "name",
                    "configured-preset-name"),
                Is.EqualTo("Nombre configurado"));
            Assert.That(
                CMUPrototypeLocalization.GetPrototypeText(
                    localization.Object,
                    "announcement-preset",
                    "LiteralPreset",
                    "name",
                    "Literal fallback"),
                Is.EqualTo("Literal fallback"));
        });
    }

    [Test]
    public void LiteralOverrideIdIsStable()
    {
        Assert.That(
            CMUPrototypeLocalization.GetLiteralOverrideId(
                "CMAutomatedVendor",
                "name",
                "Munición médica"),
            Is.EqualTo("cmu-yaml-cmautomatedvendor-name-municion-medica-1068e4035f"));
    }

    [Test]
    public void LiteralTextUsesOverrideThenConfiguredLocalizationThenLiteral()
    {
        var localization = new Mock<ILocalizationManager>();
        var overrideId = CMUPrototypeLocalization.GetLiteralOverrideId(
            "CMAutomatedVendor",
            "name",
            "Building materials");
        string translatedOverride = "Materiales de construcción";
        localization
            .Setup(manager => manager.TryGetString(
                overrideId,
                out translatedOverride,
                It.IsAny<(string, object)[]>()))
            .Returns(true);
        string translatedConfigured = "Nombre configurado";
        localization
            .Setup(manager => manager.TryGetString(
                "configured-vendor-name",
                out translatedConfigured,
                It.IsAny<(string, object)[]>()))
            .Returns(true);

        Assert.Multiple(() =>
        {
            Assert.That(
                CMUPrototypeLocalization.GetLiteralText(
                    localization.Object,
                    "CMAutomatedVendor",
                    "name",
                    "Building materials"),
                Is.EqualTo("Materiales de construcción"));
            Assert.That(
                CMUPrototypeLocalization.GetLiteralText(
                    localization.Object,
                    "CMAutomatedVendor",
                    "name",
                    "configured-vendor-name"),
                Is.EqualTo("Nombre configurado"));
            Assert.That(
                CMUPrototypeLocalization.GetLiteralText(
                    localization.Object,
                    "CMAutomatedVendor",
                    "name",
                    "Literal fallback"),
                Is.EqualTo("Literal fallback"));
        });
    }

    [Test]
    public void LiteralTextWithSeparateLocalizationIdUsesOverrideLocalizationThenLiteral()
    {
        var localization = new Mock<ILocalizationManager>();
        var overrideId = CMUPrototypeLocalization.GetLiteralOverrideId("ItemSlots", "name", "helmet slot");
        var hasOverride = true;
        var hasConfigured = true;
        string translatedOverride = "Ranura de casco sobrescrita";
        localization
            .Setup(manager => manager.TryGetString(
                overrideId,
                out translatedOverride,
                It.IsAny<(string, object)[]>()))
            .Returns(() => hasOverride);
        string translatedConfigured = "Ranura de casco configurada";
        localization
            .Setup(manager => manager.TryGetString(
                "item-slot-helmet",
                out translatedConfigured,
                It.IsAny<(string, object)[]>()))
            .Returns(() => hasConfigured);

        Assert.That(
            CMUPrototypeLocalization.GetLiteralText(
                localization.Object,
                "ItemSlots",
                "name",
                "helmet slot",
                "item-slot-helmet"),
            Is.EqualTo("Ranura de casco sobrescrita"));

        hasOverride = false;
        Assert.That(
            CMUPrototypeLocalization.GetLiteralText(
                localization.Object,
                "ItemSlots",
                "name",
                "helmet slot",
                "item-slot-helmet"),
            Is.EqualTo("Ranura de casco configurada"));

        hasConfigured = false;
        Assert.That(
            CMUPrototypeLocalization.GetLiteralText(
                localization.Object,
                "ItemSlots",
                "name",
                "helmet slot",
                "item-slot-helmet"),
            Is.EqualTo("helmet slot"));
    }

    [Test]
    public void LiteralOverrideOnlyDoesNotTreatFallbackAsLocalizationId()
    {
        var localization = new Mock<ILocalizationManager>();
        var overrideId = CMUPrototypeLocalization.GetLiteralOverrideId(
            "ANPRCRadio",
            "label",
            "CELL");
        string translatedOverride = "CÉLULA";
        localization
            .Setup(manager => manager.TryGetString(
                overrideId,
                out translatedOverride,
                It.IsAny<(string, object)[]>()))
            .Returns(true);
        string unrelatedLocalization = "No debe usarse";
        localization
            .Setup(manager => manager.TryGetString(
                "player-label",
                out unrelatedLocalization,
                It.IsAny<(string, object)[]>()))
            .Returns(true);

        Assert.Multiple(() =>
        {
            Assert.That(
                CMUPrototypeLocalization.GetLiteralOverrideOrFallback(
                    localization.Object,
                    "ANPRCRadio",
                    "label",
                    "CELL"),
                Is.EqualTo("CÉLULA"));
            Assert.That(
                CMUPrototypeLocalization.GetLiteralOverrideOrFallback(
                    localization.Object,
                    "ANPRCRadio",
                    "label",
                    "player-label"),
                Is.EqualTo("player-label"));
        });
    }

    [Test]
    public void OptionalStringUsesTranslatedMessageAndArguments()
    {
        var localization = new Mock<ILocalizationManager>();
        string translated = "Cuchillo 3";
        localization
            .Setup(manager => manager.TryGetString(
                "rmc-item-slot-knife",
                out translated,
                It.IsAny<(string, object)[]>()))
            .Returns(true);

        var result = CMUPrototypeLocalization.GetOptionalStringOrFallback(
            localization.Object,
            "rmc-item-slot-knife",
            "Knife 3",
            ("index", 3));

        Assert.That(result, Is.EqualTo("Cuchillo 3"));
    }

    [Test]
    public void OptionalStringUsesFallbackWithoutLocalizationId()
    {
        var localization = new Mock<ILocalizationManager>(MockBehavior.Strict);

        var result = CMUPrototypeLocalization.GetOptionalStringOrFallback(
            localization.Object,
            null,
            "Knife 3");

        Assert.That(result, Is.EqualTo("Knife 3"));
    }

    [Test]
    public void ResolveUsesTranslatedMessageWhenPresent()
    {
        var localization = new Mock<ILocalizationManager>();
        string translated = "Cerrar";
        localization
            .Setup(manager => manager.TryGetString("cmu-close", out translated))
            .Returns(true);

        var result = CMULocExtension.Resolve(localization.Object, "cmu-close", "Close");

        Assert.That(result, Is.EqualTo("Cerrar"));
    }

    [Test]
    public void ResolveUsesFallbackWhenMessageIsMissing()
    {
        var localization = new Mock<ILocalizationManager>();
        string missing = null;
        localization
            .Setup(manager => manager.TryGetString("cmu-close", out missing))
            .Returns(false);

        var result = CMULocExtension.Resolve(localization.Object, "cmu-close", "Close");

        Assert.That(result, Is.EqualTo("Close"));
    }

    [Test]
    public void ResolveFormatsTranslatedMessageWithArguments()
    {
        var localization = new Mock<ILocalizationManager>();
        string translated = "Vale 3 puntos";
        localization
            .Setup(manager => manager.TryGetString(
                "cmu-objective-worth-points",
                out translated,
                It.IsAny<(string, object)[]>()))
            .Returns(true);

        var result = CMULocExtension.Resolve(
            localization.Object,
            "cmu-objective-worth-points",
            "Worth 3 points",
            ("points", 3));

        Assert.That(result, Is.EqualTo("Vale 3 puntos"));
    }

    [Test]
    public void SharedTargetOnlyStringUsesTranslationOrFallback()
    {
        var spanish = new Mock<ILocalizationManager>();
        string translated = "Cerrar";
        spanish
            .Setup(manager => manager.TryGetString("cmu-close", out translated))
            .Returns(true);

        var english = new Mock<ILocalizationManager>();
        string missing = null;
        english
            .Setup(manager => manager.TryGetString("cmu-close", out missing))
            .Returns(false);

        Assert.Multiple(() =>
        {
            Assert.That(
                CMULocalization.GetTargetStringOrFallback(spanish.Object, "cmu-close", "Close"),
                Is.EqualTo("Cerrar"));
            Assert.That(
                CMULocalization.GetTargetStringOrFallback(english.Object, "cmu-close", "Close"),
                Is.EqualTo("Close"));
        });
    }

    [Test]
    public void AlertFieldsUseTranslatedMessagesAndFallback()
    {
        var localization = new Mock<ILocalizationManager>();
        string translatedName = "Oxígeno bajo";
        localization
            .Setup(loc => loc.TryGetString(
                "alert-LowOxygen-name",
                out translatedName,
                It.IsAny<(string, object)[]>()))
            .Returns(true);
        string translatedDescription = "No puedes respirar.";
        localization
            .Setup(loc => loc.TryGetString(
                "alert-LowOxygen-description",
                out translatedDescription,
                It.IsAny<(string, object)[]>()))
            .Returns(true);

        var name = CMUPrototypeLocalization.GetAlertName(
            localization.Object,
            "LowOxygen",
            "Low oxygen");
        var description = CMUPrototypeLocalization.GetAlertDescription(
            localization.Object,
            "LowOxygen",
            "You cannot breathe.");
        var fallback = CMUPrototypeLocalization.GetAlertName(
            localization.Object,
            "Unknown",
            "Unknown alert");

        Assert.Multiple(() =>
        {
            Assert.That(name, Is.EqualTo("Oxígeno bajo"));
            Assert.That(description, Is.EqualTo("No puedes respirar."));
            Assert.That(fallback, Is.EqualTo("Unknown alert"));
        });
    }

    [Test]
    public void AccessNamesUseTranslatedMessagesAndFallback()
    {
        var localization = new Mock<ILocalizationManager>();
        string translatedLevel = "Mando";
        localization
            .Setup(loc => loc.TryGetString(
                "access-level-Command-name",
                out translatedLevel,
                It.IsAny<(string, object)[]>()))
            .Returns(true);
        string translatedGroup = "Marines";
        localization
            .Setup(loc => loc.TryGetString(
                "access-group-MarineMain-name",
                out translatedGroup,
                It.IsAny<(string, object)[]>()))
            .Returns(true);

        var level = CMUPrototypeLocalization.GetAccessLevelName(
            localization.Object,
            "Command",
            "Command");
        var group = CMUPrototypeLocalization.GetAccessGroupName(
            localization.Object,
            "MarineMain",
            "Marines");
        var fallback = CMUPrototypeLocalization.GetAccessLevelName(
            localization.Object,
            "Unknown",
            "Unknown access");

        Assert.Multiple(() =>
        {
            Assert.That(level, Is.EqualTo("Mando"));
            Assert.That(group, Is.EqualTo("Marines"));
            Assert.That(fallback, Is.EqualTo("Unknown access"));
        });
    }
}
