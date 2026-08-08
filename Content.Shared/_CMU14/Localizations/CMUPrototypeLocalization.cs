using System.Text;
using Robust.Shared.Enums;
using Robust.Shared.IoC;
using Robust.Shared.Localization;

namespace Content.Shared._CMU14.Localizations;

/// <summary>
/// Resolves optional, culture-specific localization overrides for prototype fields
/// that historically contain visible literal text.
/// </summary>
public static class CMUPrototypeLocalization
{
    private static readonly uint[] Sha256Constants =
    [
        0x428a2f98u, 0x71374491u, 0xb5c0fbcfu, 0xe9b5dba5u,
        0x3956c25bu, 0x59f111f1u, 0x923f82a4u, 0xab1c5ed5u,
        0xd807aa98u, 0x12835b01u, 0x243185beu, 0x550c7dc3u,
        0x72be5d74u, 0x80deb1feu, 0x9bdc06a7u, 0xc19bf174u,
        0xe49b69c1u, 0xefbe4786u, 0x0fc19dc6u, 0x240ca1ccu,
        0x2de92c6fu, 0x4a7484aau, 0x5cb0a9dcu, 0x76f988dau,
        0x983e5152u, 0xa831c66du, 0xb00327c8u, 0xbf597fc7u,
        0xc6e00bf3u, 0xd5a79147u, 0x06ca6351u, 0x14292967u,
        0x27b70a85u, 0x2e1b2138u, 0x4d2c6dfcu, 0x53380d13u,
        0x650a7354u, 0x766a0abbu, 0x81c2c92eu, 0x92722c85u,
        0xa2bfe8a1u, 0xa81a664bu, 0xc24b8b70u, 0xc76c51a3u,
        0xd192e819u, 0xd6990624u, 0xf40e3585u, 0x106aa070u,
        0x19a4c116u, 0x1e376c08u, 0x2748774cu, 0x34b0bcb5u,
        0x391c0cb3u, 0x4ed8aa4au, 0x5b9cca4fu, 0x682e6ff3u,
        0x748f82eeu, 0x78a5636fu, 0x84c87814u, 0x8cc70208u,
        0x90befffau, 0xa4506cebu, 0xbef9a3f7u, 0xc67178f2u,
    ];

    public static string GetOptionalStringOrFallback(
        ILocalizationManager localization,
        LocId? localizationId,
        string fallback,
        params (string, object)[] args)
    {
        if (localizationId is not { } messageId)
            return fallback;

        return localization.TryGetString(messageId, out var localized, args)
            ? localized
            : fallback;
    }

    public static string GetOverrideId(string prototypeType, string prototypeId, string field)
    {
        return $"{prototypeType}-{prototypeId}-{field}";
    }

    public static string GetLiteralOverrideId(string component, string field, string configuredText)
    {
        var componentSegment = NormalizeLiteralSegment(component);
        var fieldSegment = NormalizeLiteralSegment(field);
        var textSegment = NormalizeLiteralSegment(configuredText);
        if (textSegment.Length > 48)
            textSegment = textSegment[..48].TrimEnd('-');

        var hashInput = Encoding.UTF8.GetBytes($"{component}\0{field}\0{configuredText}");
        var hash = GetSha256Prefix(hashInput);
        return $"cmu-yaml-{componentSegment}-{fieldSegment}-{textSegment}-{hash}";
    }

    public static string GetLiteralOverrideOrFallback(
        ILocalizationManager localization,
        string component,
        string field,
        string configuredText,
        params (string, object)[] args)
    {
        var overrideId = GetLiteralOverrideId(component, field, configuredText);
        return localization.TryGetString(overrideId, out var localized, args)
            ? localized
            : configuredText;
    }

    public static string GetLiteralText(
        ILocalizationManager localization,
        string component,
        string field,
        string configuredText,
        params (string, object)[] args)
    {
        var overrideId = GetLiteralOverrideId(component, field, configuredText);
        if (localization.TryGetString(overrideId, out var localized, args))
            return localized;

        return localization.TryGetString(configuredText, out localized, args)
            ? localized
            : configuredText;
    }

    public static string GetLiteralText(
        ILocalizationManager localization,
        string component,
        string field,
        string literalText,
        LocId? localizationId,
        params (string, object)[] args)
    {
        var overrideId = GetLiteralOverrideId(component, field, literalText);
        if (localization.TryGetString(overrideId, out var localized, args))
            return localized;

        if (localizationId is { } messageId && localization.TryGetString(messageId, out localized, args))
            return localized;

        return localization.TryGetString(literalText, out localized, args)
            ? localized
            : literalText;
    }

    public static string GetTileName(
        ILocalizationManager localization,
        string prototypeId,
        string fallback)
    {
        return GetStringOrFallback(localization, "tile", prototypeId, "name", fallback);
    }

    public static string GetConstructionStepName(
        ILocalizationManager localization,
        string fallback)
    {
        var segment = NormalizeOverrideSegment(fallback);
        if (segment.Length == 0)
            return fallback;

        return GetStringOrFallback(
            localization,
            "construction-step",
            segment,
            "name",
            fallback);
    }

    public static string GetConstructionStepName(string fallback)
    {
        return GetConstructionStepName(
            IoCManager.Resolve<ILocalizationManager>(),
            fallback);
    }

    public static string GetJobName(
        ILocalizationManager localization,
        string prototypeId,
        string fallback)
    {
        return GetStringOrFallback(localization, "job", prototypeId, "name", fallback);
    }

    public static string GetJobDescription(
        ILocalizationManager localization,
        string prototypeId,
        string fallback)
    {
        return GetStringOrFallback(localization, "job", prototypeId, "description", fallback);
    }

    public static string GetRankName(
        ILocalizationManager localization,
        string prototypeId,
        string fallback)
    {
        var overrideId = $"rank-{prototypeId}";
        return localization.TryGetString(overrideId, out var localized, [])
            ? localized
            : fallback;
    }

    public static string GetRankPrefix(
        ILocalizationManager localization,
        string prototypeId,
        string fallback,
        Gender? gender = null)
    {
        var attribute = gender switch
        {
            Gender.Male => "prefix-male",
            Gender.Female => "prefix-female",
            _ => "prefix",
        };
        var overrideId = $"rank-{prototypeId}.{attribute}";
        return localization.TryGetString(overrideId, out var localized, [])
            ? localized
            : fallback;
    }

    public static string GetGuideEntryName(
        ILocalizationManager localization,
        string prototypeId,
        string fallback)
    {
        return GetStringOrFallback(localization, "guide-entry", prototypeId, "name", fallback);
    }

    public static string GetAlertName(
        ILocalizationManager localization,
        string prototypeId,
        string fallback)
    {
        return GetStringOrFallback(localization, "alert", prototypeId, "name", fallback);
    }

    public static string GetAlertDescription(
        ILocalizationManager localization,
        string prototypeId,
        string fallback)
    {
        return GetStringOrFallback(localization, "alert", prototypeId, "description", fallback);
    }

    public static string GetAccessLevelName(
        ILocalizationManager localization,
        string prototypeId,
        string fallback)
    {
        return GetStringOrFallback(localization, "access-level", prototypeId, "name", fallback);
    }

    public static string GetAccessLevelName(string prototypeId, string fallback)
    {
        return GetAccessLevelName(
            IoCManager.Resolve<ILocalizationManager>(),
            prototypeId,
            fallback);
    }

    public static string GetAccessGroupName(
        ILocalizationManager localization,
        string prototypeId,
        string fallback)
    {
        return GetStringOrFallback(localization, "access-group", prototypeId, "name", fallback);
    }

    public static string GetAccessGroupName(string prototypeId, string fallback)
    {
        return GetAccessGroupName(
            IoCManager.Resolve<ILocalizationManager>(),
            prototypeId,
            fallback);
    }

    public static string GetStringOrFallback(
        ILocalizationManager localization,
        string prototypeType,
        string prototypeId,
        string field,
        string fallback,
        params (string, object)[] args)
    {
        var overrideId = GetOverrideId(prototypeType, prototypeId, field);
        return localization.TryGetString(overrideId, out var localized, args)
            ? localized
            : fallback;
    }

    public static string GetPrototypeText(
        ILocalizationManager localization,
        string prototypeType,
        string prototypeId,
        string field,
        string configuredText,
        params (string, object)[] args)
    {
        var overrideId = GetOverrideId(prototypeType, prototypeId, field);
        if (localization.TryGetString(overrideId, out var localized, args))
            return localized;

        return localization.TryGetString(configuredText, out localized, args)
            ? localized
            : configuredText;
    }

    public static string GetPrototypeText(
        string prototypeType,
        string prototypeId,
        string field,
        string configuredText,
        params (string, object)[] args)
    {
        return GetPrototypeText(
            IoCManager.Resolve<ILocalizationManager>(),
            prototypeType,
            prototypeId,
            field,
            configuredText,
            args);
    }

    private static string NormalizeOverrideSegment(string value)
    {
        var normalized = new StringBuilder(value.Length);
        var pendingSeparator = false;

        foreach (var character in value)
        {
            var isAsciiLetter = character is >= 'A' and <= 'Z' or >= 'a' and <= 'z';
            var isDigit = character is >= '0' and <= '9';
            if (!isAsciiLetter && !isDigit)
            {
                pendingSeparator = normalized.Length > 0;
                continue;
            }

            if (pendingSeparator)
                normalized.Append('-');

            normalized.Append(char.ToLowerInvariant(character));
            pendingSeparator = false;
        }

        return normalized.ToString();
    }

    private static string NormalizeLiteralSegment(string value)
    {
        var decomposed = value.Normalize(NormalizationForm.FormD);
        var normalized = new StringBuilder(decomposed.Length);
        var pendingSeparator = false;

        foreach (var character in decomposed)
        {
            if (IsCombiningMark(character))
                continue;

            var isAsciiLetter = character is >= 'A' and <= 'Z' or >= 'a' and <= 'z';
            var isDigit = character is >= '0' and <= '9';
            if (!isAsciiLetter && !isDigit)
            {
                pendingSeparator = normalized.Length > 0;
                continue;
            }

            if (pendingSeparator)
                normalized.Append('-');

            normalized.Append(char.ToLowerInvariant(character));
            pendingSeparator = false;
        }

        return normalized.Length == 0 ? "text" : normalized.ToString();
    }

    private static bool IsCombiningMark(char character)
    {
        return character is >= '\u0300' and <= '\u036f'
            or >= '\u1ab0' and <= '\u1aff'
            or >= '\u1dc0' and <= '\u1dff'
            or >= '\u20d0' and <= '\u20ff'
            or >= '\ufe20' and <= '\ufe2f';
    }

    private static string GetSha256Prefix(byte[] input)
    {
        var paddedLength = ((input.Length + 9 + 63) / 64) * 64;
        var padded = new byte[paddedLength];
        for (var i = 0; i < input.Length; i++)
        {
            padded[i] = input[i];
        }

        padded[input.Length] = 0x80;
        var bitLength = (ulong) input.Length * 8;
        for (var i = 0; i < 8; i++)
        {
            padded[^ (i + 1)] = (byte) (bitLength >> (i * 8));
        }

        uint h0 = 0x6a09e667u;
        uint h1 = 0xbb67ae85u;
        uint h2 = 0x3c6ef372u;
        uint h3 = 0xa54ff53au;
        uint h4 = 0x510e527fu;
        uint h5 = 0x9b05688cu;
        uint h6 = 0x1f83d9abu;
        uint h7 = 0x5be0cd19u;
        var words = new uint[64];

        for (var offset = 0; offset < padded.Length; offset += 64)
        {
            for (var i = 0; i < 16; i++)
            {
                var index = offset + i * 4;
                words[i] = (uint) (padded[index] << 24)
                    | (uint) (padded[index + 1] << 16)
                    | (uint) (padded[index + 2] << 8)
                    | padded[index + 3];
            }

            for (var i = 16; i < words.Length; i++)
            {
                var s0 = RotateRight(words[i - 15], 7)
                    ^ RotateRight(words[i - 15], 18)
                    ^ words[i - 15] >> 3;
                var s1 = RotateRight(words[i - 2], 17)
                    ^ RotateRight(words[i - 2], 19)
                    ^ words[i - 2] >> 10;
                words[i] = unchecked(words[i - 16] + s0 + words[i - 7] + s1);
            }

            var a = h0;
            var b = h1;
            var c = h2;
            var d = h3;
            var e = h4;
            var f = h5;
            var g = h6;
            var h = h7;

            for (var i = 0; i < words.Length; i++)
            {
                var sum1 = RotateRight(e, 6) ^ RotateRight(e, 11) ^ RotateRight(e, 25);
                var choice = (e & f) ^ (~e & g);
                var temp1 = unchecked(h + sum1 + choice + Sha256Constants[i] + words[i]);
                var sum0 = RotateRight(a, 2) ^ RotateRight(a, 13) ^ RotateRight(a, 22);
                var majority = (a & b) ^ (a & c) ^ (b & c);
                var temp2 = unchecked(sum0 + majority);

                h = g;
                g = f;
                f = e;
                e = unchecked(d + temp1);
                d = c;
                c = b;
                b = a;
                a = unchecked(temp1 + temp2);
            }

            h0 = unchecked(h0 + a);
            h1 = unchecked(h1 + b);
            h2 = unchecked(h2 + c);
            h3 = unchecked(h3 + d);
            h4 = unchecked(h4 + e);
            h5 = unchecked(h5 + f);
            h6 = unchecked(h6 + g);
            h7 = unchecked(h7 + h);
        }

        return $"{h0:x8}{h1:x8}"[..10];
    }

    private static uint RotateRight(uint value, int count)
    {
        return value >> count | value << 32 - count;
    }
}
