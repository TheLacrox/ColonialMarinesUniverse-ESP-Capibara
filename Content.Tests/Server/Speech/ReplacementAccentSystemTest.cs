using Content.Server.Speech.EntitySystems;
using NUnit.Framework;

namespace Content.Tests.Server.Speech;

[TestFixture]
public sealed class ReplacementAccentSystemTest
{
    [Test]
    public void CaseSensitiveReplacementDoesNotMatchSpanishPronoun()
    {
        var regex = ReplacementAccentSystem.CreateWordRegex("SE", caseSensitive: true);

        Assert.Multiple(() =>
        {
            Assert.That(regex.IsMatch("Avanza al SE"), Is.True);
            Assert.That(regex.IsMatch("No se puede avanzar"), Is.False);
        });
    }
}
