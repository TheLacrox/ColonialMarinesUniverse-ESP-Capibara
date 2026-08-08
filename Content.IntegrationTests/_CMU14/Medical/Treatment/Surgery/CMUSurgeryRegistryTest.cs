using System.Linq;
using Content.Shared._CMU14.Medical.Treatment.Surgery;
using Content.Shared.Body.Part;
using Robust.Shared.Map;
using Robust.Shared.Prototypes;

namespace Content.IntegrationTests._CMU14.Medical.Treatment.Surgery;

[TestFixture]
public sealed class CMUSurgeryRegistryTest
{
    private const string TestSurgery = "CMUTestSurgeryRegistryOrder";
    private const string LaterTestSurgery = "CMUTestSurgeryRegistryOrderAfter";

    [TestPrototypes]
    private const string Prototypes = """
        - type: entity
          parent: CMSurgeryStepBase
          id: CMUTestSurgeryRegistryStepFirst
          name: first fallback label

        - type: entity
          parent: CMSurgeryStepBase
          id: CMUTestSurgeryRegistryStepSecond
          name: second fallback label

        - type: entity
          parent: CMSurgeryBase
          id: CMUTestSurgeryRegistryOrder
          name: Registry Order Test
          components:
          - type: CMSurgery
            steps:
            - CMUTestSurgeryRegistryStepFirst
            - CMUTestSurgeryRegistryStepSecond

        - type: cmuSurgeryStepMetadata
          id: CMUTestSurgeryRegistryOrderMetadata
          surgery: CMUTestSurgeryRegistryOrder
          displayName: Registry Order Procedure
          displayNameLocId: cmu-medical-surgery-procedure-set-fracture
          validParts: [Arm]
          category: general
          steps:
          - stepId: CMUTestSurgeryRegistryStepSecond
            label: Second metadata label
            labelLocId: cmu-medical-surgery-step-close-incision-label
            toolCategory: cautery
          - stepId: CMUTestSurgeryRegistryStepFirst
            label: First metadata label
            labelLocId: cmu-medical-surgery-step-amputate-limb-label
            toolCategory: scalpel

        - type: entity
          parent: CMSurgeryBase
          id: CMUTestSurgeryRegistryOrderAfter
          name: Later Registry Order Test
          components:
          - type: CMSurgery
            steps:
            - CMUTestSurgeryRegistryStepFirst

        - type: cmuSurgeryStepMetadata
          id: CMUTestSurgeryRegistryOrderAfterMetadata
          surgery: CMUTestSurgeryRegistryOrderAfter
          validParts: [Arm]
          category: general

        - type: entity
          id: CMUTestSurgeryLocalizedArmedState
          components:
          - type: CMUSurgeryArmedStep
            surgeryId: CMUTestSurgeryRegistryOrder
            leafSurgeryId: CMUTestSurgeryRegistryOrder
            stepIndex: 0
            stepLabel: First metadata label
            stepLabelLocId: cmu-medical-surgery-step-amputate-limb-label
        """;

    [Test]
    public async Task StepMetadataResolvesByStepIdWhenMetadataOrderDiffers()
    {
        await using var pair = await PoolManager.GetServerClient();
        var server = pair.Server;

        await server.WaitAssertion(() =>
        {
            var flow = server.EntMan.System<SharedCMUSurgeryFlowSystem>();

            Assert.Multiple(() =>
            {
                Assert.That(flow.TryGetDefinition(TestSurgery, out var surgery), Is.True);
                Assert.That(surgery.DisplayName, Is.EqualTo("Registry Order Procedure"));
                Assert.That(surgery.DisplayNameLocId?.Id,
                    Is.EqualTo("cmu-medical-surgery-procedure-set-fracture"));

                Assert.That(flow.TryResolveStepAt(TestSurgery, 0, out var first), Is.True);
                Assert.That(first.StepLabel, Is.EqualTo("First metadata label"));
                Assert.That(first.StepLabelLocId?.Id,
                    Is.EqualTo("cmu-medical-surgery-step-amputate-limb-label"));
                Assert.That(first.ToolCategory, Is.EqualTo("scalpel"));

                Assert.That(flow.TryResolveStepAt(TestSurgery, 1, out var second), Is.True);
                Assert.That(second.StepLabel, Is.EqualTo("Second metadata label"));
                Assert.That(second.StepLabelLocId?.Id,
                    Is.EqualTo("cmu-medical-surgery-step-close-incision-label"));
                Assert.That(second.ToolCategory, Is.EqualTo("cautery"));
            });

            var patient = server.EntMan.SpawnEntity("CMUTestSurgeryLocalizedArmedState", MapCoordinates.Nullspace);
            try
            {
                Assert.That(server.EntMan.TryGetComponent<CMUSurgeryArmedStepComponent>(patient, out var armed),
                    Is.True);

                var state = flow.BuildBuiState(patient, "Test Patient", [], armed);
                Assert.Multiple(() =>
                {
                    Assert.That(state.CurrentArmedStep, Is.Not.Null);
                    Assert.That(state.CurrentArmedStep!.SurgeryDisplayNameLocId?.Id,
                        Is.EqualTo("cmu-medical-surgery-procedure-set-fracture"));
                    Assert.That(state.CurrentArmedStep.StepLabelLocId?.Id,
                        Is.EqualTo("cmu-medical-surgery-step-amputate-limb-label"));
                });
            }
            finally
            {
                server.EntMan.DeleteEntity(patient);
            }
        });

        await pair.CleanReturnAsync();
    }

    [Test]
    public async Task EligibilityIsPreindexedByPartAndPreservesPrototypeOrder()
    {
        await using var pair = await PoolManager.GetServerClient();
        var server = pair.Server;

        await server.WaitAssertion(() =>
        {
            var flow = server.EntMan.System<SharedCMUSurgeryFlowSystem>();
            var prototypes = server.ResolveDependency<IPrototypeManager>();
            var armSurgeries = flow.GetEligibleDefinitions(BodyPartType.Arm);
            var torsoSurgeries = flow.GetEligibleDefinitions(BodyPartType.Torso);
            var armIds = armSurgeries.Select(definition => definition.Id.Id).ToList();
            var expectedArmIds = prototypes
                .EnumeratePrototypes<CMUSurgeryStepMetadataPrototype>()
                .Where(metadata => metadata.ValidParts.Contains(BodyPartType.Arm))
                .Select(metadata => metadata.Surgery.Id)
                .ToList();

            Assert.Multiple(() =>
            {
                Assert.That(armIds, Is.EqualTo(expectedArmIds));
                Assert.That(armIds, Does.Contain(TestSurgery));
                Assert.That(armIds, Does.Contain(LaterTestSurgery));
                Assert.That(torsoSurgeries.Any(definition =>
                    definition.Id.Id is TestSurgery or LaterTestSurgery), Is.False);
            });
        });

        await pair.CleanReturnAsync();
    }
}
