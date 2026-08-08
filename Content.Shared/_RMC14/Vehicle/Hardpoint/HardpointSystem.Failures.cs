using Content.Shared.Tools;
using Robust.Shared.Prototypes;
using Robust.Shared.Random;

namespace Content.Shared._RMC14.Vehicle;

public sealed partial class HardpointSystem
{
    [Dependency] private IRobustRandom _random = default!;

    private readonly record struct VehicleHardpointFailureRepairStep(
        ProtoId<ToolQualityPrototype> Tool,
        float Time,
        string InstructionKey,
        string Instruction,
        bool RequiresWelder = false);

    private static readonly VehicleHardpointFailureRepairStep[] ArmorCompromisedRepairSteps =
    {
        new("Anchoring", 4f, "cmu-rmc-vehicle-repair-armor-tighten", "Tighten the armor fasteners and clamp the plate into alignment."),
        new("Welding", 8f, "cmu-rmc-vehicle-repair-armor-weld", "Weld and patch the breached armor seams.", true),
    };

    private static readonly VehicleHardpointFailureRepairStep[] FeedJamRepairSteps =
    {
        new("Screwing", 4f, "cmu-rmc-vehicle-repair-feed-open", "Open the feed cover and clear bent belt links."),
        new("Pulsing", 5f, "cmu-rmc-vehicle-repair-feed-cycle", "Cycle the feed actuator with a multitool."),
    };

    private static readonly VehicleHardpointFailureRepairStep[] RunawayTriggerRepairSteps =
    {
        new("Screwing", 5f, "cmu-rmc-vehicle-repair-trigger-open", "Open the trigger housing and isolate the worn sear linkage."),
        new("Pulsing", 6f, "cmu-rmc-vehicle-repair-trigger-reset", "Reset the fire-control relay with a multitool."),
        new("Anchoring", 5f, "cmu-rmc-vehicle-repair-trigger-reseat", "Re-seat and tighten the trigger linkage."),
    };

    private static readonly VehicleHardpointFailureRepairStep[] TurretTraverseRepairSteps =
    {
        new("Anchoring", 6f, "cmu-rmc-vehicle-repair-traverse-tighten", "Tighten and re-index the traverse ring."),
        new("VehicleServicing", 5f, "cmu-rmc-vehicle-repair-traverse-reseat", "Jack the turret bearing clear and re-seat the ring."),
    };

    private static readonly VehicleHardpointFailureRepairStep[] EngineMisfireRepairSteps =
    {
        new("Screwing", 4f, "cmu-rmc-vehicle-repair-misfire-open", "Open the engine access panel."),
        new("Pulsing", 6f, "cmu-rmc-vehicle-repair-misfire-pulse", "Pulse the ignition control circuit with a multitool."),
        new("Anchoring", 4f, "cmu-rmc-vehicle-repair-misfire-tighten", "Tighten the engine mounts after the circuit stabilizes."),
    };

    private static readonly VehicleHardpointFailureRepairStep[] TransmissionSlipRepairSteps =
    {
        new("VehicleServicing", 7f, "cmu-rmc-vehicle-repair-transmission-reseat", "Lift and re-seat the drivetrain with a maintenance jack."),
        new("Anchoring", 5f, "cmu-rmc-vehicle-repair-transmission-tighten", "Tighten the transmission housing bolts."),
    };

    private static readonly VehicleHardpointFailureRepairStep[] WarpedFrameRepairSteps =
    {
        new("VehicleServicing", 8f, "cmu-rmc-vehicle-repair-frame-jack", "Jack the frame and relieve pressure from the warped section."),
        new("Welding", 12f, "cmu-rmc-vehicle-repair-frame-straighten", "Heat and straighten the warped frame members with a welder.", true),
        new("Anchoring", 6f, "cmu-rmc-vehicle-repair-frame-retorque", "Re-torque the frame braces."),
    };

    private static readonly VehicleHardpointFailureRepairStep[] DamagedMountRepairSteps =
    {
        new("VehicleServicing", 6f, "cmu-rmc-vehicle-repair-mount-jack", "Jack the hardpoint clear of the damaged mount."),
        new("Anchoring", 6f, "cmu-rmc-vehicle-repair-mount-reseat", "Re-seat and tighten the mount locking hardware."),
    };

    private static readonly VehicleHardpointFailureRepairStep[] TireBlowoutRepairSteps =
    {
        new("Prying", 5f, "cmu-rmc-vehicle-repair-tire-pry", "Pry the shredded tire casing clear of the rim."),
        new("VehicleServicing", 6f, "cmu-rmc-vehicle-repair-tire-replace", "Jack the hub up and seat a replacement wheel assembly."),
        new("Anchoring", 5f, "cmu-rmc-vehicle-repair-tire-torque", "Torque the wheel lugs down in sequence."),
    };

    private static readonly VehicleHardpointFailureRepairStep[] ThrownTreadRepairSteps =
    {
        new("VehicleServicing", 8f, "cmu-rmc-vehicle-repair-tread-jack", "Jack the running gear up and take tension off the tread."),
        new("Prying", 6f, "cmu-rmc-vehicle-repair-tread-reseat", "Pry the thrown tread links back onto the road wheels."),
        new("Anchoring", 8f, "cmu-rmc-vehicle-repair-tread-lock", "Lock the tensioner and torque the tread pins."),
    };

    private static readonly VehicleHardpointFailureRepairStep[] EngineOverheatRepairSteps =
    {
        new("Screwing", 4f, "cmu-rmc-vehicle-repair-overheat-open", "Open the engine shroud and vent trapped heat."),
        new("Prying", 5f, "cmu-rmc-vehicle-repair-overheat-pry", "Pry the warped fan guard away from the radiator."),
        new("Pulsing", 6f, "cmu-rmc-vehicle-repair-overheat-pulse", "Pulse the coolant pump controller until flow stabilizes."),
    };

    private static readonly VehicleHardpointFailureRepairStep[] ElectricalShortRepairSteps =
    {
        new("Cutting", 5f, "cmu-rmc-vehicle-repair-electrical-cut", "Cut away the burned wiring from the hardpoint harness."),
        new("Pulsing", 6f, "cmu-rmc-vehicle-repair-electrical-reset", "Trace and reset the control circuit with a multitool."),
        new("Screwing", 4f, "cmu-rmc-vehicle-repair-electrical-close", "Close the access panel and secure the replacement harness."),
    };

    private static readonly VehicleHardpointFailureRepairStep[] FuelLeakRepairSteps =
    {
        new("Screwing", 4f, "cmu-rmc-vehicle-repair-fuel-open", "Open the fuel service panel and isolate the ruptured line."),
        new("Welding", 7f, "cmu-rmc-vehicle-repair-fuel-patch", "Patch the leaking fuel line.", true),
        new("Anchoring", 4f, "cmu-rmc-vehicle-repair-fuel-tighten", "Tighten the fuel line coupling."),
    };
}
