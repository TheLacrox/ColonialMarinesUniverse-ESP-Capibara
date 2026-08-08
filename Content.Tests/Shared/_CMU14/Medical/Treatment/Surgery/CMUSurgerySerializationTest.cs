using Content.Shared._CMU14.Medical.Treatment.Surgery;
using NUnit.Framework;
using Robust.Shared.IoC;
using Robust.Shared.Serialization.Manager;

namespace Content.Tests.Shared._CMU14.Medical.Treatment.Surgery;

[TestFixture]
public sealed class CMUSurgerySerializationTest : ContentUnitTest
{
    [OneTimeSetUp]
    public void OneTimeSetUp()
    {
        IoCManager.Resolve<ISerializationManager>().Initialize();
    }

    [Test]
    public void ArmedStateIdCanBeCopiedForComponentPrototypes()
    {
        var source = new CMUSurgeryArmedStateId(42);

        var copy = IoCManager.Resolve<ISerializationManager>().CreateCopy(source);

        Assert.That(copy, Is.EqualTo(source));
    }
}
