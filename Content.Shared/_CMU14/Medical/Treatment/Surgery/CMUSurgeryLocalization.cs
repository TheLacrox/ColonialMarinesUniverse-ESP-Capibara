using Robust.Shared.Localization;

namespace Content.Shared._CMU14.Medical.Treatment.Surgery;

/// <summary>
/// Resolves prototype-owned surgery text without discarding its authored fallback chain.
/// </summary>
public static class CMUSurgeryLocalization
{
    public static string Resolve(
        ILocalizationManager localization,
        LocId? localizationId,
        string? literalFallback,
        string? entityFallback = null,
        string? technicalFallback = null)
    {
        if (localizationId is { } id &&
            localization.TryGetString(id, out var localized) &&
            !string.IsNullOrWhiteSpace(localized))
        {
            return localized;
        }

        if (!string.IsNullOrWhiteSpace(literalFallback))
            return literalFallback;

        if (!string.IsNullOrWhiteSpace(entityFallback))
            return entityFallback;

        return technicalFallback ?? string.Empty;
    }
}
