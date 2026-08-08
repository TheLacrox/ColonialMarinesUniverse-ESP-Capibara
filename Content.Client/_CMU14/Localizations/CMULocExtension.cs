using Content.Shared._CMU14.Localizations;
using Robust.Shared.IoC;
using Robust.Shared.Localization;

namespace Content.Client._CMU14.Localizations;

public sealed class CMULocExtension
{
    public string Key { get; }
    public string Fallback { get; }

    public CMULocExtension(string key, string fallback)
    {
        Key = key;
        Fallback = fallback;
    }

    public object ProvideValue()
    {
        return GetString(Key, Fallback);
    }

    public static string GetString(
        string key,
        string fallback,
        params (string, object)[] arguments)
    {
        return Resolve(IoCManager.Resolve<ILocalizationManager>(), key, fallback, arguments);
    }

    public static string Resolve(
        ILocalizationManager localization,
        string key,
        string fallback,
        params (string, object)[] arguments)
    {
        return CMULocalization.GetTargetStringOrFallback(
            localization,
            key,
            fallback,
            arguments);
    }
}
