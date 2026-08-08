using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using Content.Shared._RMC14.Localizations;
using Robust.Shared;
using Robust.Shared.Configuration;
using Robust.Shared.Utility;

namespace Content.Shared.Localizations
{
    public sealed partial class ContentLocalizationManager
    {
        [Dependency] private ILocalizationManager _loc = default!;
        [Dependency] private IConfigurationManager _configuration = default!;

        public const string DefaultCultureName = "es-ES";
        private const string EnglishCultureName = "en-US";

        /// <summary>
        /// Custom format strings used for parsing and displaying minutes:seconds timespans.
        /// </summary>
        public static readonly string[] TimeSpanMinutesFormats = new[]
        {
            @"m\:ss",
            @"mm\:ss",
            @"%m",
            @"mm"
        };

        public void Initialize()
        {
            _configuration.OverrideDefault(CVars.LocCultureName, DefaultCultureName);

            var culture = CultureInfo.GetCultureInfo(
                _configuration.GetCVar(CVars.LocCultureName),
                predefinedOnly: false);
            var cultureEn = CultureInfo.GetCultureInfo(EnglishCultureName);

            RegisterCulture(cultureEn);
            if (!Equals(culture, cultureEn))
                RegisterCulture(culture);

            _loc.AddFunction(cultureEn, "MAKEPLURAL", FormatMakePlural);
            _loc.AddFunction(cultureEn, "MANY", FormatMany);

            if (culture.Name == DefaultCultureName)
            {
                _loc.AddFunction(culture, "MAKEPLURAL", FormatMakePluralSpanish);
                _loc.AddFunction(culture, "MANY", FormatManySpanish);
            }

            _loc.SetCulture(culture);
            if (Equals(culture, cultureEn))
                _loc.SetFallbackCluture();
            else
                _loc.SetFallbackCluture(cultureEn);
        }

        private void RegisterCulture(CultureInfo culture)
        {
            _loc.LoadCulture(culture);
            _loc.AddFunction(culture, "PRESSURE", FormatPressure);
            _loc.AddFunction(culture, "POWERWATTS", FormatPowerWatts);
            _loc.AddFunction(culture, "POWERJOULES", FormatPowerJoules);
            // NOTE: ENERGYWATTHOURS() still takes a value in joules, but formats as watt-hours.
            _loc.AddFunction(culture, "ENERGYWATTHOURS", FormatEnergyWattHours);
            _loc.AddFunction(culture, "UNITS", FormatUnits);
            _loc.AddFunction(culture, "TOSTRING", args => FormatToString(culture, args));
            _loc.AddFunction(culture, "LOC", FormatLoc);
            _loc.AddFunction(culture, "NATURALFIXED", args => FormatNaturalFixed(culture, args));
            _loc.AddFunction(culture, "NATURALPERCENT", args => FormatNaturalPercent(culture, args));
            _loc.AddFunction(culture, "PLAYTIME", FormatPlaytime);

            // RMC14
            IoCManager.Resolve<RMCLocalizationManager>().Initialize(culture);
        }

        private ILocValue FormatMany(LocArgs args)
        {
            var count = ((LocValueNumber) args.Args[1]).Value;

            if (Math.Abs(count - 1) < 0.0001f)
            {
                return (LocValueString) args.Args[0];
            }
            else
            {
                return (LocValueString) FormatMakePlural(args);
            }
        }

        private ILocValue FormatManySpanish(LocArgs args)
        {
            var count = ((LocValueNumber) args.Args[1]).Value;
            return Math.Abs(count - 1) < 0.0001f
                ? (LocValueString) args.Args[0]
                : FormatMakePluralSpanish(args);
        }

        private static ILocValue FormatMakePluralSpanish(LocArgs args)
        {
            var text = ((LocValueString) args.Args[0]).Value;
            return new LocValueString(MakePluralSpanish(text));
        }

        public static string MakePluralSpanish(string text)
        {
            if (string.IsNullOrEmpty(text))
                return text;

            var split = text.Split(' ', 2);
            var word = split[0];
            var lower = word.ToLowerInvariant();

            string plural;
            if (lower.EndsWith('z'))
            {
                plural = $"{word[..^1]}ces";
            }
            else if ("aeiouáéó".Contains(lower[^1]))
            {
                plural = $"{word}s";
            }
            else if (lower.EndsWith('s') || lower.EndsWith('x'))
            {
                plural = lower.Length > 1 && "áéíóú".Contains(lower[^2])
                    ? RemoveAccents(word) + "es"
                    : word;
            }
            else
            {
                plural = RemoveAccents(word) + "es";
            }

            return split.Length == 1 ? plural : $"{plural} {split[1]}";
        }

        private static string RemoveAccents(string text)
        {
            return text
                .Replace('á', 'a')
                .Replace('é', 'e')
                .Replace('í', 'i')
                .Replace('ó', 'o')
                .Replace('ú', 'u')
                .Replace('Á', 'A')
                .Replace('É', 'E')
                .Replace('Í', 'I')
                .Replace('Ó', 'O')
                .Replace('Ú', 'U');
        }

        private static ILocValue FormatNaturalPercent(CultureInfo culture, LocArgs args)
        {
            var number = ((LocValueNumber) args.Args[0]).Value * 100;
            var maxDecimals = (int)Math.Floor(((LocValueNumber) args.Args[1]).Value);
            var formatter = (NumberFormatInfo)NumberFormatInfo.GetInstance(culture).Clone();
            formatter.NumberDecimalDigits = maxDecimals;
            return new LocValueString(string.Format(formatter, "{0:N}", number).TrimEnd('0').TrimEnd(char.Parse(formatter.NumberDecimalSeparator)) + "%");
        }

        private static ILocValue FormatNaturalFixed(CultureInfo culture, LocArgs args)
        {
            var number = ((LocValueNumber) args.Args[0]).Value;
            var maxDecimals = (int)Math.Floor(((LocValueNumber) args.Args[1]).Value);
            var formatter = (NumberFormatInfo)NumberFormatInfo.GetInstance(culture).Clone();
            formatter.NumberDecimalDigits = maxDecimals;
            return new LocValueString(string.Format(formatter, "{0:N}", number).TrimEnd('0').TrimEnd(char.Parse(formatter.NumberDecimalSeparator)));
        }

        private static readonly Regex PluralEsRule = new("^.*(s|sh|ch|x|z)$");

        private ILocValue FormatMakePlural(LocArgs args)
        {
            var text = ((LocValueString) args.Args[0]).Value;
            var split = text.Split(" ", 1);
            var firstWord = split[0];
            if (PluralEsRule.IsMatch(firstWord))
            {
                if (split.Length == 1)
                    return new LocValueString($"{firstWord}es");
                else
                    return new LocValueString($"{firstWord}es {split[1]}");
            }
            else
            {
                if (split.Length == 1)
                    return new LocValueString($"{firstWord}s");
                else
                    return new LocValueString($"{firstWord}s {split[1]}");
            }
        }

        // TODO: allow fluent to take in lists of strings so this can be a format function like it should be.
        /// <summary>
        /// Formats a list according to the supplied culture, or the current UI culture.
        /// </summary>
        public static string FormatList(List<string> list, CultureInfo? culture = null)
        {
            culture ??= CultureInfo.CurrentUICulture;
            var spanish = culture.TwoLetterISOLanguageName.Equals("es", StringComparison.OrdinalIgnoreCase);

            return list.Count switch
            {
                <= 0 => string.Empty,
                1 => list[0],
                2 when spanish => $"{list[0]} {SpanishAndConjunction(list[1])} {list[1]}",
                2 => $"{list[0]} and {list[1]}",
                _ when spanish => $"{string.Join(", ", list.GetRange(0, list.Count - 1))} {SpanishAndConjunction(list[^1])} {list[^1]}",
                _ => $"{string.Join(", ", list.GetRange(0, list.Count - 1))}, and {list[^1]}"
            };
        }

        /// <summary>
        /// Formats a list according to the supplied culture, using a disjunctive conjunction.
        /// </summary>
        public static string FormatListToOr(List<string> list, CultureInfo? culture = null)
        {
            culture ??= CultureInfo.CurrentUICulture;
            var spanish = culture.TwoLetterISOLanguageName.Equals("es", StringComparison.OrdinalIgnoreCase);

            return list.Count switch
            {
                <= 0 => string.Empty,
                1 => list[0],
                2 when spanish => $"{list[0]} {SpanishOrConjunction(list[1])} {list[1]}",
                2 => $"{list[0]} or {list[1]}",
                _ when spanish => $"{string.Join(", ", list.GetRange(0, list.Count - 1))} {SpanishOrConjunction(list[^1])} {list[^1]}",
                _ => string.Join(" or ", list)
            };
        }

        private static string SpanishAndConjunction(string following)
        {
            var word = LeadingVisibleText(following).ToLowerInvariant();
            var vowelOffset = word.StartsWith("hi", StringComparison.Ordinal) ||
                              word.StartsWith("hí", StringComparison.Ordinal)
                ? 2
                : word.StartsWith('i') || word.StartsWith('í')
                    ? 1
                    : 0;

            if (vowelOffset == 0)
                return "y";

            return vowelOffset >= word.Length || !"aeouáéóú".Contains(word[vowelOffset])
                ? "e"
                : "y";
        }

        private static string SpanishOrConjunction(string following)
        {
            var word = LeadingVisibleText(following).ToLowerInvariant();
            return word.StartsWith('o') || word.StartsWith("ho", StringComparison.Ordinal)
                ? "u"
                : "o";
        }

        private static string LeadingVisibleText(string text)
        {
            var remaining = text.AsSpan().TrimStart();
            while (remaining.StartsWith("["))
            {
                var closing = remaining.IndexOf(']');
                if (closing < 0)
                    break;
                remaining = remaining[(closing + 1)..].TrimStart();
            }

            return remaining.ToString();
        }

        /// <summary>
        /// Formats a direction struct as a human-readable string.
        /// </summary>
        public static string FormatDirection(Direction dir)
        {
            return Loc.GetString($"zzzz-fmt-direction-{dir.ToString()}");
        }

        /// <summary>
        /// Formats playtime as hours and minutes.
        /// </summary>
        public static string FormatPlaytime(TimeSpan time)
        {
            time = TimeSpan.FromMinutes(Math.Ceiling(time.TotalMinutes));
            var hours = (int)time.TotalHours;
            var minutes = time.Minutes;
            return Loc.GetString($"zzzz-fmt-playtime", ("hours", hours), ("minutes", minutes));
        }

        private static ILocValue FormatLoc(LocArgs args)
        {
            var id = ((LocValueString) args.Args[0]).Value;

            return new LocValueString(Loc.GetString(id, args.Options.Select(x => (x.Key, x.Value.Value!)).ToArray()));
        }

        private static ILocValue FormatToString(CultureInfo culture, LocArgs args)
        {
            var arg = args.Args[0];
            var fmt = ((LocValueString) args.Args[1]).Value;

            var obj = arg.Value;
            if (obj is IFormattable formattable)
                return new LocValueString(formattable.ToString(fmt, culture));

            return new LocValueString(obj?.ToString() ?? "");
        }

        private static ILocValue FormatUnitsGeneric(
            LocArgs args,
            string mode,
            Func<double, double>? transformValue = null)
        {
            const int maxPlaces = 5; // Matches amount in _lib.ftl
            var pressure = ((LocValueNumber) args.Args[0]).Value;

            if (transformValue != null)
                pressure = transformValue(pressure);

            var places = 0;
            while (pressure > 1000 && places < maxPlaces)
            {
                pressure /= 1000;
                places += 1;
            }

            return new LocValueString(Loc.GetString(mode, ("divided", pressure), ("places", places)));
        }

        private static ILocValue FormatPressure(LocArgs args)
        {
            return FormatUnitsGeneric(args, "zzzz-fmt-pressure");
        }

        private static ILocValue FormatPowerWatts(LocArgs args)
        {
            return FormatUnitsGeneric(args, "zzzz-fmt-power-watts");
        }

        private static ILocValue FormatPowerJoules(LocArgs args)
        {
            return FormatUnitsGeneric(args, "zzzz-fmt-power-joules");
        }

        private static ILocValue FormatEnergyWattHours(LocArgs args)
        {
            const double joulesToWattHours = 1.0 / 3600;

            return FormatUnitsGeneric(args, "zzzz-fmt-energy-watt-hours", joules => joules * joulesToWattHours);
        }

        private static ILocValue FormatUnits(LocArgs args)
        {
            if (!Units.Types.TryGetValue(((LocValueString) args.Args[0]).Value, out var ut))
                throw new ArgumentException($"Unknown unit type {((LocValueString) args.Args[0]).Value}");

            var fmtstr = ((LocValueString) args.Args[1]).Value;

            double max = Double.NegativeInfinity;
            var iargs = new double[args.Args.Count - 1];
            for (var i = 2; i < args.Args.Count; i++)
            {
                var n = ((LocValueNumber) args.Args[i]).Value;
                if (n > max)
                    max = n;

                iargs[i - 2] = n;
            }

            if (!ut.TryGetUnit(max, out var mu))
                throw new ArgumentException("Unit out of range for type");

            var fargs = new object[iargs.Length];

            for (var i = 0; i < iargs.Length; i++)
                fargs[i] = iargs[i] * mu.Factor;

            fargs[^1] = Loc.GetString($"units-{mu.Unit.ToLower()}");

            // Before anyone complains about "{"+"${...}", at least it's better than MS's approach...
            // https://docs.microsoft.com/en-us/dotnet/standard/base-types/composite-formatting#escaping-braces
            //
            // Note that the closing brace isn't replaced so that format specifiers can be applied.
            var res = String.Format(
                fmtstr.Replace("{UNIT", "{" + $"{fargs.Length - 1}"),
                fargs
            );

            return new LocValueString(res);
        }

        private static ILocValue FormatPlaytime(LocArgs args)
        {
            var time = TimeSpan.Zero;
            if (args.Args is { Count: > 0 } && args.Args[0].Value is TimeSpan timeArg)
            {
                time = timeArg;
            }
            return new LocValueString(FormatPlaytime(time));
        }
    }
}
