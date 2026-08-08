using System.Collections.Generic;
using System.Globalization;
using Content.Shared._CMU14.Localizations;
using Content.Shared._RMC14.Localizations;
using Content.Shared.Localizations;
using NUnit.Framework;

namespace Content.Tests.Shared.Localizations;

[TestFixture]
public sealed class ContentLocalizationManagerTest
{
    [TestCase("construction", "AU14BuildWallMetalRecipe", "name", "construction-AU14BuildWallMetalRecipe-name")]
    [TestCase("rmc-construction", "AU14SapperCraftTripwire", "name", "rmc-construction-AU14SapperCraftTripwire-name")]
    public void PrototypeOverrideIdIsStable(
        string prototypeType,
        string prototypeId,
        string field,
        string expected)
    {
        Assert.That(
            CMUPrototypeLocalization.GetOverrideId(prototypeType, prototypeId, field),
            Is.EqualTo(expected));
    }

    [Test]
    public void FormatListUsesSpanishConjunction()
    {
        var result = ContentLocalizationManager.FormatList(
            new List<string> { "uno", "dos", "tres" },
            CultureInfo.GetCultureInfo("es-ES"));

        Assert.That(result, Is.EqualTo("uno, dos y tres"));
    }

    [Test]
    public void FormatListToOrUsesSpanishConjunction()
    {
        var result = ContentLocalizationManager.FormatListToOr(
            new List<string> { "uno", "dos", "tres" },
            CultureInfo.GetCultureInfo("es-ES"));

        Assert.That(result, Is.EqualTo("uno, dos o tres"));
    }

    [Test]
    public void FormatListUsesSpanishEuphonicE()
    {
        var result = ContentLocalizationManager.FormatList(
            new List<string> { "madres", "padres", "hijos" },
            CultureInfo.GetCultureInfo("es-ES"));

        Assert.That(result, Is.EqualTo("madres, padres e hijos"));
    }

    [Test]
    public void FormatListToOrUsesSpanishEuphonicU()
    {
        var result = ContentLocalizationManager.FormatListToOr(
            new List<string> { "siete", "ocho" },
            CultureInfo.GetCultureInfo("es-ES"));

        Assert.That(result, Is.EqualTo("siete u ocho"));
    }

    [Test]
    public void FormatListKeepsEnglishGrammarForEnglishCulture()
    {
        var result = ContentLocalizationManager.FormatList(
            new List<string> { "one", "two", "three" },
            CultureInfo.GetCultureInfo("en-US"));

        Assert.That(result, Is.EqualTo("one, two, and three"));
    }

    [TestCase("xeno", "xenos")]
    [TestCase("luz", "luces")]
    [TestCase("capitán", "capitanes")]
    [TestCase("rey", "reyes")]
    [TestCase("virus", "virus")]
    [TestCase("autobús", "autobuses")]
    [TestCase("", "")]
    public void MakePluralSpanishUsesSpanishRules(string singular, string plural)
    {
        Assert.That(ContentLocalizationManager.MakePluralSpanish(singular), Is.EqualTo(plural));
    }

    [TestCase(false, "su")]
    [TestCase(true, "sus")]
    public void PossessiveAdjectiveSpanishAgreesWithPossessedNumber(bool plural, string expected)
    {
        Assert.That(RMCLocalizationManager.PossessiveAdjectiveSpanish(plural), Is.EqualTo(expected));
    }

    [TestCase(false, "está")]
    [TestCase(true, "es")]
    public void ConjugateBeSpanishDistinguishesStateFromCharacteristic(bool useSer, string expected)
    {
        Assert.That(RMCLocalizationManager.ConjugateBeSpanish(useSer), Is.EqualTo(expected));
    }
}
