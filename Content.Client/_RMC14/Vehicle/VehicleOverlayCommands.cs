using Content.Client.Administration.Managers;
using Content.Client._RMC14.Vehicle;
using Robust.Shared.Console;

namespace Content.Client.Vehicle;

public sealed partial class VehicleOverlayCommands : EntitySystem
{
    [Dependency] private IClientAdminManager _adminManager = default!;
    [Dependency] private IConsoleHost _console = default!;
    [Dependency] private GridVehicleMoverSystem _vehicleMover = default!;

    public override void Initialize()
    {
        _console.RegisterCommand("rmc_vehicle_debug", ToggleDebug);
        _console.RegisterCommand("rmc_vehicle_hardpoints", ToggleHardpoints);
        _console.RegisterCommand("rmc_vehicle_collision", ToggleCollision);
        _console.RegisterCommand("rmc_vehicle_movement", ToggleMovement);
    }

    public override void Shutdown()
    {
        _console.UnregisterCommand("rmc_vehicle_debug");
        _console.UnregisterCommand("rmc_vehicle_hardpoints");
        _console.UnregisterCommand("rmc_vehicle_collision");
        _console.UnregisterCommand("rmc_vehicle_movement");
    }

    private bool CheckAdmin(IConsoleShell shell)
    {
        if (_adminManager.IsAdmin())
            return true;

        shell.WriteError(VehicleLoc.Target(
            "cmu-rmc-vehicle-overlay-admin-required",
            "You must be an admin to use this command."));
        return false;
    }

    private void ToggleDebug(IConsoleShell shell, string argstr, string[] args)
    {
        if (!CheckAdmin(shell))
            return;

        var enabled = _vehicleMover.ToggleDebugOverlay();
        var state = GetState(enabled);
        shell.WriteLine(VehicleLoc.Target(
            "cmu-rmc-vehicle-overlay-debug-state",
            $"Vehicle debug overlay {state}.",
            ("state", state)));
    }

    private void ToggleHardpoints(IConsoleShell shell, string argstr, string[] args)
    {
        if (!CheckAdmin(shell))
            return;

        var enabled = _vehicleMover.ToggleHardpointOverlay();
        var state = GetState(enabled);
        shell.WriteLine(VehicleLoc.Target(
            "cmu-rmc-vehicle-overlay-hardpoint-state",
            $"Vehicle hardpoint overlay {state}.",
            ("state", state)));
    }

    private void ToggleCollision(IConsoleShell shell, string argstr, string[] args)
    {
        if (!CheckAdmin(shell))
            return;

        var enabled = _vehicleMover.ToggleCollisionOverlay();
        var state = GetState(enabled);
        shell.WriteLine(VehicleLoc.Target(
            "cmu-rmc-vehicle-overlay-collision-state",
            $"Vehicle collision overlay {state}.",
            ("state", state)));
    }

    private void ToggleMovement(IConsoleShell shell, string argstr, string[] args)
    {
        if (!CheckAdmin(shell))
            return;

        var enabled = _vehicleMover.ToggleMovementOverlay();
        var state = GetState(enabled);
        shell.WriteLine(VehicleLoc.Target(
            "cmu-rmc-vehicle-overlay-movement-state",
            $"Vehicle movement overlay {state}.",
            ("state", state)));
    }

    private static string GetState(bool enabled)
    {
        return enabled
            ? VehicleLoc.Target("cmu-rmc-vehicle-overlay-enabled", "enabled")
            : VehicleLoc.Target("cmu-rmc-vehicle-overlay-disabled", "disabled");
    }
}
