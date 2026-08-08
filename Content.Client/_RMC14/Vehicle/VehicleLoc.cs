using Content.Client._CMU14.Localizations;

namespace Content.Client._RMC14.Vehicle;

public static class VehicleLoc
{
    public static string Target(string key, string fallback, params (string, object)[] arguments)
    {
        return CMULocExtension.GetString(key, fallback, arguments);
    }

    public static string SlotName(string id)
    {
        return id switch
        {
            "armor" => Target("cmu-rmc-vehicle-slot-armor", "armor"),
            "door-gun" => Target("cmu-rmc-vehicle-slot-door-gun", "door gun"),
            "front" => Target("cmu-rmc-vehicle-slot-front", "front"),
            "launchers" => Target("cmu-rmc-vehicle-slot-launchers", "launchers"),
            "primary" => Target("cmu-rmc-vehicle-slot-primary", "primary"),
            "recon" => Target("cmu-rmc-vehicle-slot-recon", "recon"),
            "roof" => Target("cmu-rmc-vehicle-slot-roof", "roof"),
            "secondary" => Target("cmu-rmc-vehicle-slot-secondary", "secondary"),
            "sensors" => Target("cmu-rmc-vehicle-slot-sensors", "sensors"),
            "support" => Target("cmu-rmc-vehicle-slot-support", "support"),
            "thrusters" => Target("cmu-rmc-vehicle-slot-thrusters", "thrusters"),
            "turret" => Target("cmu-rmc-vehicle-slot-turret", "turret"),
            "turret-cannon" => Target("cmu-rmc-vehicle-slot-turret-cannon", "turret cannon"),
            "turret-launcher" => Target("cmu-rmc-vehicle-slot-turret-launcher", "turret launcher"),
            "wheel-1" => Target("cmu-rmc-vehicle-slot-wheel-one", "wheel 1"),
            _ => id,
        };
    }

    public static string TypeName(string id)
    {
        return id switch
        {
            "Armor" => Target("cmu-rmc-vehicle-type-armor", "Armor"),
            "Cannon" => Target("cmu-rmc-vehicle-type-cannon", "Cannon"),
            "DoorGun" => Target("cmu-rmc-vehicle-type-door-gun", "Door Gun"),
            "FrontAttachment" => Target("cmu-rmc-vehicle-type-front-attachment", "Front Attachment"),
            "Launcher" => Target("cmu-rmc-vehicle-type-launcher", "Launcher"),
            "RoofAttachment" => Target("cmu-rmc-vehicle-type-roof-attachment", "Roof Attachment"),
            "Secondary" => Target("cmu-rmc-vehicle-type-secondary", "Secondary"),
            "SensorArray" => Target("cmu-rmc-vehicle-type-sensor-array", "Sensor Array"),
            "Support" => Target("cmu-rmc-vehicle-type-support", "Support"),
            "SupportAttachment" => Target("cmu-rmc-vehicle-type-support-attachment", "Support Attachment"),
            "Thruster" => Target("cmu-rmc-vehicle-type-thruster", "Thruster"),
            "Turret" => Target("cmu-rmc-vehicle-type-turret", "Turret"),
            "Wheel" => Target("cmu-rmc-vehicle-type-wheel", "Wheel"),
            _ => id,
        };
    }
}
