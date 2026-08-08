using Robust.Shared.Localization;

namespace Content.Shared._CMU14.Localizations;

/// <summary>
/// Resolves messages that exist only in the target locale while preserving a
/// literal fallback for every other culture.
/// </summary>
public static class CMULocalization
{
    public static string GetTargetStringOrFallback(
        ILocalizationManager localization,
        string key,
        string fallback,
        params (string, object)[] arguments)
    {
        var found = arguments.Length == 0
            ? localization.TryGetString(key, out var translated)
            : localization.TryGetString(key, out translated, arguments);

        return found && translated != null
            ? translated
            : fallback;
    }
}
