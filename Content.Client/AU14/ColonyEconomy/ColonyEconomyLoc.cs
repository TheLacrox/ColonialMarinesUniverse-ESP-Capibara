using Content.Client._CMU14.Localizations;

namespace Content.Client.AU14.ColonyEconomy;

internal static class ColonyEconomyLoc
{
    public static string Target(
        string key,
        string fallback,
        params (string, object)[] arguments)
    {
        return CMULocExtension.GetString(key, fallback, arguments);
    }
}
