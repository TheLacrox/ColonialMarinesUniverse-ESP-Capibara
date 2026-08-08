using System;
using System.Linq;
using System.Numerics;
using Content.Client.Lobby.UI;
using Content.Client.Stylesheets;
using Content.Shared._CMU14.Localizations;
using Content.Shared._CMU14.RoundStatistics;
using Content.Shared.AU14.util;
using Robust.Client.Graphics;
using Robust.Client.UserInterface;
using Robust.Client.UserInterface.Controls;
using Robust.Client.UserInterface.CustomControls;
using Robust.Shared.Localization;
using Robust.Shared.Maths;
using Robust.Shared.Prototypes;
using static Robust.Client.UserInterface.Controls.BoxContainer;

namespace Content.Client._CMU14.RoundStatistics;

public sealed class CMURoundStatisticsWindow : DefaultWindow
{
    private const float BorderAlpha = 0.85f;
    private const int BarWidth = 650;

    private static readonly Color Background = Color.FromHex("#071311");
    private static readonly Color Card = Color.FromHex("#0d1f1c");
    private static readonly Color CardQuiet = Color.FromHex("#0a1715");
    private static readonly Color Border = Color.FromHex("#4972A1").WithAlpha(BorderAlpha);
    private static readonly Color Text = Color.FromHex("#d7f4dc");
    private static readonly Color Muted = Color.FromHex("#7ea993");
    private static readonly Color GovforBlue = Color.FromHex("#68a7d8");
    private static readonly Color XenoRed = Color.FromHex("#d66a7b");
    private static readonly Color ClfGold = Color.FromHex("#d1b85d");
    private static readonly Color ColonistGreen = Color.FromHex("#77c88e");
    private static readonly Color ThreatPurple = Color.FromHex("#c98fda");
    private static readonly Color DrawGray = Color.FromHex("#b7b7b7");
    private static readonly Color UnknownGray = Color.FromHex("#666f6b");

    private readonly BoxContainer _modes;
    private readonly BoxContainer _recent;
    private readonly Label _summary;
    private readonly Button _refresh;
    private readonly ILocalizationManager _localization;
    private readonly IPrototypeManager _prototypes;

    public event Action? OnRefresh;

    public CMURoundStatisticsWindow()
    {
        _localization = IoCManager.Resolve<ILocalizationManager>();
        _prototypes = IoCManager.Resolve<IPrototypeManager>();

        MinSize = new Vector2(900, 680);
        SetSize = new Vector2(980, 760);
        Title = Localize("cmu-round-statistics-window-title", "CMU Round Outcomes");

        var root = new BoxContainer
        {
            Orientation = LayoutOrientation.Vertical,
            SeparationOverride = 12,
            Margin = new Thickness(12),
            HorizontalExpand = true,
            VerticalExpand = true,
        };

        var header = new BoxContainer
        {
            Orientation = LayoutOrientation.Horizontal,
            SeparationOverride = 12,
            HorizontalExpand = true,
        };

        var headerText = new BoxContainer
        {
            Orientation = LayoutOrientation.Vertical,
            SeparationOverride = 2,
            HorizontalExpand = true,
        };

        headerText.AddChild(new Label
        {
            Text = Localize("cmu-round-statistics-header-title", "Operational Outcomes"),
            FontColorOverride = Text,
            StyleClasses = { StyleBase.StyleClassLabelHeading },
            ClipText = true,
            HorizontalExpand = true,
        });

        _summary = new Label
        {
            Text = Localize("cmu-round-statistics-waiting", "Waiting for data"),
            FontColorOverride = Muted,
            ClipText = true,
            HorizontalExpand = true,
        };
        headerText.AddChild(_summary);
        header.AddChild(headerText);

        _refresh = new Button
        {
            Text = Localize("cmu-round-statistics-refresh", "Refresh"),
            MinSize = new Vector2(110, 34),
            VerticalAlignment = VAlignment.Center,
        };
        _refresh.OnPressed += _ => OnRefresh?.Invoke();
        header.AddChild(_refresh);

        root.AddChild(header);

        var tabs = new TabContainer
        {
            HorizontalExpand = true,
            VerticalExpand = true,
        };

        var overviewTab = new BoxContainer
        {
            Name = Localize("cmu-round-statistics-tab-overview", "Overview"),
            Orientation = LayoutOrientation.Vertical,
            HorizontalExpand = true,
            VerticalExpand = true,
        };
        var overviewScroll = new ScrollContainer
        {
            HScrollEnabled = false,
            VerticalExpand = true,
        };
        _modes = new BoxContainer
        {
            Orientation = LayoutOrientation.Vertical,
            SeparationOverride = 12,
            HorizontalExpand = true,
        };
        overviewScroll.AddChild(_modes);
        overviewTab.AddChild(overviewScroll);

        var recentTab = new BoxContainer
        {
            Name = Localize("cmu-round-statistics-tab-recent-rounds", "Recent Rounds"),
            Orientation = LayoutOrientation.Vertical,
            HorizontalExpand = true,
            VerticalExpand = true,
        };
        var recentScroll = new ScrollContainer
        {
            HScrollEnabled = false,
            VerticalExpand = true,
        };
        _recent = new BoxContainer
        {
            Orientation = LayoutOrientation.Vertical,
            SeparationOverride = 8,
            HorizontalExpand = true,
        };
        recentScroll.AddChild(_recent);
        recentTab.AddChild(recentScroll);

        tabs.AddChild(overviewTab);
        tabs.AddChild(recentTab);
        root.AddChild(tabs);

        Contents.AddChild(root);
        CrtLobbyTheme.ApplyWindow(this, useCrtTypography: true);
    }

    public void UpdateDashboard(CMURoundStatisticsDashboard dashboard)
    {
        var totalRounds = dashboard.Modes.Sum(mode => mode.Total);
        var decidedRounds = dashboard.Modes.Sum(mode => mode.DecidedTotal);
        _summary.Text = Localize(
            "cmu-round-statistics-summary",
            $"{totalRounds} tracked endings, {decidedRounds} decided wins",
            ("total", totalRounds),
            ("decided", decidedRounds));

        _modes.DisposeAllChildren();
        foreach (var mode in dashboard.Modes)
            _modes.AddChild(MakeModePanel(mode));

        _recent.DisposeAllChildren();
        if (dashboard.RecentRounds.Count == 0)
        {
            _recent.AddChild(MakeEmptyPanel(Localize(
                "cmu-round-statistics-no-tracked-rounds",
                "No tracked rounds yet.")));
            return;
        }

        foreach (var record in dashboard.RecentRounds)
            _recent.AddChild(MakeRecentRoundPanel(record));
    }

    private Control MakeModePanel(CMURoundModeStatistics mode)
    {
        var panel = MakePanel(Card, Border);
        var container = new BoxContainer
        {
            Orientation = LayoutOrientation.Vertical,
            Margin = new Thickness(12),
            SeparationOverride = 10,
            HorizontalExpand = true,
        };

        container.AddChild(new Label
        {
            Text = FormatPreset(mode.Preset),
            FontColorOverride = Text,
            StyleClasses = { StyleBase.StyleClassLabelHeading },
            ClipText = true,
            HorizontalExpand = true,
        });
        container.AddChild(new Label
        {
            Text = Localize(
                "cmu-round-statistics-mode-summary",
                $"{mode.Total} tracked endings / {mode.DecidedTotal} decided wins / " +
                $"{mode.Draws} draws / {mode.Unknown} unknown",
                ("total", mode.Total),
                ("decided", mode.DecidedTotal),
                ("draws", mode.Draws),
                ("unknown", mode.Unknown)),
            FontColorOverride = Muted,
            ClipText = true,
            HorizontalExpand = true,
        });

        container.AddChild(MakeRateGrid(mode));
        container.AddChild(MakeInsightGrid(mode));
        container.AddChild(MakeRecentFormPanel(mode));
        container.AddChild(MakeOutcomeBar(mode));

        if (mode.Preset == CMURoundStatisticsPreset.DistressSignal)
            container.AddChild(MakeDistressSplit(mode));

        container.AddChild(MakeOutcomeBreakdown(mode));

        if (mode.ManualReasons.Count > 0)
            container.AddChild(MakeManualReasonBreakdown(mode));

        if (mode.Threats.Count > 0)
            container.AddChild(MakeThreatBreakdown(mode));
        if (mode.Planets.Count > 0)
            container.AddChild(MakePlanetBreakdown(mode));
        if (mode.PlatoonMatchups.Count > 0)
            container.AddChild(MakePlatoonMatchupBreakdown(mode));
        if (mode.PlayerCountBands.Count > 0)
            container.AddChild(MakePlayerCountBreakdown(mode));

        panel.AddChild(container);
        return panel;
    }

    private Control MakeRateGrid(CMURoundModeStatistics mode)
    {
        var grid = new GridContainer
        {
            Columns = 4,
            HSeparationOverride = 8,
            VSeparationOverride = 8,
            HorizontalExpand = true,
        };

        grid.AddChild(MakeMetric(
            FormatSideA(mode.Preset),
            $"{FormatRate(mode.SideAWins, mode.DecidedTotal)}",
            Localize(
                "cmu-round-statistics-wins",
                $"{mode.SideAWins} wins",
                ("count", mode.SideAWins)),
            GetSideAColor(mode.Preset)));
        grid.AddChild(MakeMetric(
            FormatSideB(mode.Preset),
            $"{FormatRate(mode.SideBWins, mode.DecidedTotal)}",
            Localize(
                "cmu-round-statistics-wins",
                $"{mode.SideBWins} wins",
                ("count", mode.SideBWins)),
            GetSideBColor(mode.Preset)));
        grid.AddChild(MakeMetric(
            Localize("cmu-round-statistics-draws", "Draws"),
            mode.Draws.ToString(),
            Localize("cmu-round-statistics-excluded", "excluded"),
            DrawGray));
        grid.AddChild(MakeMetric(
            Localize("cmu-round-statistics-unknown", "Unknown"),
            mode.Unknown.ToString(),
            Localize("cmu-round-statistics-excluded", "excluded"),
            UnknownGray));

        return grid;
    }

    private Control MakeInsightGrid(CMURoundModeStatistics mode)
    {
        var grid = new GridContainer
        {
            Columns = 4,
            HSeparationOverride = 8,
            VSeparationOverride = 8,
            HorizontalExpand = true,
        };

        grid.AddChild(MakeMetric(
            Localize("cmu-round-statistics-recent-ten", "Recent 10"),
            FormatRecentForm(mode),
            Localize(
                "cmu-round-statistics-tracked",
                $"{mode.RecentForm.Rounds} tracked",
                ("count", mode.RecentForm.Rounds)),
            Border));
        grid.AddChild(MakeMetric(
            Localize("cmu-round-statistics-current-streak", "Current Streak"),
            FormatStreak(mode.CurrentStreak),
            Localize("cmu-round-statistics-decided-endings", "decided endings"),
            StreakColor(mode.CurrentStreak)));
        grid.AddChild(MakeMetric(
            Localize("cmu-round-statistics-longest-streak", "Longest Streak"),
            FormatStreak(mode.LongestStreak),
            Localize("cmu-round-statistics-decided-endings", "decided endings"),
            StreakColor(mode.LongestStreak)));
        grid.AddChild(MakeMetric(
            Localize("cmu-round-statistics-average-duration", "Avg Duration"),
            FormatDurationOrNone(mode.Durations.AverageSeconds),
            $"{FormatSideA(mode.Preset)} {FormatDurationOrNone(mode.Durations.SideAAverageSeconds)} / " +
            $"{FormatSideB(mode.Preset)} {FormatDurationOrNone(mode.Durations.SideBAverageSeconds)}",
            Border));

        return grid;
    }

    private Control MakeRecentFormPanel(CMURoundModeStatistics mode)
    {
        var panel = MakePanel(CardQuiet, Border);
        var box = new BoxContainer
        {
            Orientation = LayoutOrientation.Vertical,
            Margin = new Thickness(8, 6),
            SeparationOverride = 6,
            HorizontalExpand = true,
        };

        var header = new BoxContainer
        {
            Orientation = LayoutOrientation.Horizontal,
            SeparationOverride = 8,
            HorizontalExpand = true,
        };
        header.AddChild(new Label
        {
            Text = Localize("cmu-round-statistics-recent-form", "Recent Form"),
            FontColorOverride = Text,
            ClipText = true,
            HorizontalExpand = true,
        });
        header.AddChild(new Label
        {
            Text = Localize(
                "cmu-round-statistics-recent-form-record",
                $"{mode.SideA} {mode.RecentForm.SideAWins} / {mode.SideB} {mode.RecentForm.SideBWins}",
                ("sideA", FormatSideA(mode.Preset)),
                ("winsA", mode.RecentForm.SideAWins),
                ("sideB", FormatSideB(mode.Preset)),
                ("winsB", mode.RecentForm.SideBWins)),
            FontColorOverride = Muted,
            ClipText = true,
            MinWidth = 180,
        });
        box.AddChild(header);

        var pips = new BoxContainer
        {
            Orientation = LayoutOrientation.Horizontal,
            SeparationOverride = 4,
            HorizontalExpand = true,
        };

        if (mode.RecentForm.Winners.Count == 0)
        {
            pips.AddChild(new Label
            {
                Text = Localize("cmu-round-statistics-no-recent-rounds", "No recent rounds"),
                FontColorOverride = Muted,
                ClipText = true,
                HorizontalExpand = true,
            });
        }
        else
        {
            foreach (var winner in mode.RecentForm.Winners)
                pips.AddChild(MakeFormPip(WinnerColor(winner)));
        }

        box.AddChild(pips);
        panel.AddChild(box);
        return panel;
    }

    private static Control MakeFormPip(Color color)
    {
        return new PanelContainer
        {
            MinSize = new Vector2(18, 18),
            HorizontalExpand = false,
            PanelOverride = new StyleBoxFlat
            {
                BackgroundColor = color.WithAlpha(0.85f),
                BorderColor = color,
                BorderThickness = new Thickness(1),
            },
        };
    }

    private Control MakeMetric(string label, string value, string detail, Color color)
    {
        var panel = MakePanel(CardQuiet, color.WithAlpha(BorderAlpha));
        panel.MinSize = new Vector2(190, 76);

        var box = new BoxContainer
        {
            Orientation = LayoutOrientation.Vertical,
            Margin = new Thickness(10, 8),
            SeparationOverride = 2,
            HorizontalExpand = true,
        };
        box.AddChild(new Label
        {
            Text = label,
            FontColorOverride = Muted,
            ClipText = true,
            HorizontalExpand = true,
        });
        box.AddChild(new Label
        {
            Text = value,
            FontColorOverride = color,
            StyleClasses = { StyleNano.StyleClassLabelBig },
            ClipText = true,
            HorizontalExpand = true,
        });
        box.AddChild(new Label
        {
            Text = detail,
            FontColorOverride = Muted,
            ClipText = true,
            HorizontalExpand = true,
        });

        panel.AddChild(box);
        return panel;
    }

    private Control MakeOutcomeBar(CMURoundModeStatistics mode)
    {
        var panel = MakePanel(CardQuiet, UnknownGray.WithAlpha(BorderAlpha));
        panel.HorizontalExpand = false;
        panel.MinSize = new Vector2(BarWidth, 18);

        var bar = new BoxContainer
        {
            Orientation = LayoutOrientation.Horizontal,
            HorizontalExpand = false,
            MinSize = new Vector2(BarWidth, 18),
        };

        if (mode.Total <= 0)
        {
            bar.AddChild(MakeBarSegment(BarWidth, UnknownGray));
        }
        else
        {
            AddBarSegment(bar, mode.SideAWins, mode.Total, GetSideAColor(mode.Preset));
            AddBarSegment(bar, mode.Draws, mode.Total, DrawGray);
            AddBarSegment(bar, mode.Unknown, mode.Total, UnknownGray);
            AddBarSegment(bar, mode.SideBWins, mode.Total, GetSideBColor(mode.Preset));
        }

        panel.AddChild(bar);
        return panel;
    }

    private static void AddBarSegment(BoxContainer bar, int count, int total, Color color)
    {
        if (count <= 0)
            return;

        var width = Math.Max(5, (int) MathF.Round(BarWidth * count / (float) total));
        bar.AddChild(MakeBarSegment(width, color));
    }

    private static Control MakeBarSegment(int width, Color color)
    {
        return new PanelContainer
        {
            MinSize = new Vector2(width, 18),
            HorizontalExpand = false,
            PanelOverride = new StyleBoxFlat
            {
                BackgroundColor = color,
                BorderColor = color,
                BorderThickness = new Thickness(0),
            },
        };
    }

    private Control MakeOutcomeBreakdown(CMURoundModeStatistics mode)
    {
        var box = new BoxContainer
        {
            Orientation = LayoutOrientation.Vertical,
            SeparationOverride = 6,
            HorizontalExpand = true,
        };

        box.AddChild(MakeSectionLabel(Localize(
            "cmu-round-statistics-outcome-breakdown",
            "Outcome Breakdown")));

        if (mode.Outcomes.Count == 0)
        {
            box.AddChild(MakeEmptyPanel(Localize(
                "cmu-round-statistics-no-outcomes",
                "No outcomes recorded for this mode.")));
            return box;
        }

        foreach (var outcome in mode.Outcomes)
        {
            var winner = FormatWinner(outcome.Winner);
            var rate = FormatRate(outcome.Count, mode.Total);
            box.AddChild(MakeBreakdownRow(
                FormatOutcome(outcome.Outcome),
                Localize(
                    "cmu-round-statistics-outcome-detail",
                    $"{winner} / {rate} of endings",
                    ("winner", winner),
                    ("rate", rate)),
                outcome.Count,
                WinnerColor(outcome.Winner)));
        }

        return box;
    }

    private Control MakeManualReasonBreakdown(CMURoundModeStatistics mode)
    {
        var box = new BoxContainer
        {
            Orientation = LayoutOrientation.Vertical,
            SeparationOverride = 6,
            HorizontalExpand = true,
        };

        box.AddChild(MakeSectionLabel(Localize(
            "cmu-round-statistics-manual-ending-reasons",
            "Manual Ending Reasons")));

        var manualTotal = mode.ManualReasons.Sum(reason => reason.Count);
        foreach (var reason in mode.ManualReasons)
        {
            var rate = FormatRate(reason.Count, manualTotal);
            box.AddChild(MakeBreakdownRow(
                FormatOutcomeSource(reason.Reason),
                Localize(
                    "cmu-round-statistics-manual-detail",
                    $"{rate} of manual endings",
                    ("rate", rate)),
                reason.Count,
                UnknownGray));
        }

        return box;
    }

    private Control MakeDistressSplit(CMURoundModeStatistics mode)
    {
        var box = new BoxContainer
        {
            Orientation = LayoutOrientation.Vertical,
            SeparationOverride = 6,
            HorizontalExpand = true,
        };

        box.AddChild(MakeSectionLabel(Localize(
            "cmu-round-statistics-distress-split",
            "Distress Signal Major / Minor Split")));
        box.AddChild(MakeOutcomeSplitRow(
            mode,
            CMURoundStatisticsOutcome.XenoMajorHijackWin,
            XenoRed));
        box.AddChild(MakeOutcomeSplitRow(
            mode,
            CMURoundStatisticsOutcome.XenoMinorHijackLoss,
            XenoRed));
        box.AddChild(MakeOutcomeSplitRow(
            mode,
            CMURoundStatisticsOutcome.MarineMinorHiveCollapse,
            GovforBlue));
        box.AddChild(MakeOutcomeSplitRow(
            mode,
            CMURoundStatisticsOutcome.MarineMajorXenoWipe,
            GovforBlue));
        box.AddChild(MakeOutcomeSplitRow(
            mode,
            CMURoundStatisticsOutcome.DrawAlmayerAutodestruct,
            DrawGray));

        return box;
    }

    private Control MakeOutcomeSplitRow(
        CMURoundModeStatistics mode,
        CMURoundStatisticsOutcome outcome,
        Color color)
    {
        var count = mode.Outcomes
            .Where(entry => entry.Outcome == outcome)
            .Sum(entry => entry.Count);

        var rate = FormatRate(count, mode.Total);
        return MakeBreakdownRow(
            FormatOutcome(outcome),
            Localize(
                "cmu-round-statistics-share-of-endings",
                $"{rate} of endings",
                ("rate", rate)),
            count,
            color);
    }

    private Control MakeThreatBreakdown(CMURoundModeStatistics mode)
    {
        var box = new BoxContainer
        {
            Orientation = LayoutOrientation.Vertical,
            SeparationOverride = 6,
            HorizontalExpand = true,
        };

        box.AddChild(MakeSectionLabel(Localize(
            "cmu-round-statistics-threat-breakdown",
            "Threat Breakdown")));

        foreach (var threat in mode.Threats)
        {
            var decided = threat.SideAWins + threat.SideBWins;
            var text = FormatVersusSummary(
                mode,
                threat.SideAWins,
                threat.SideBWins,
                threat.Draws,
                threat.Unknown,
                decided);

            box.AddChild(MakeBreakdownRow(
                FormatThreat(threat.ThreatId),
                text,
                threat.Total,
                Border));
        }

        return box;
    }

    private Control MakePlanetBreakdown(CMURoundModeStatistics mode)
    {
        var box = new BoxContainer
        {
            Orientation = LayoutOrientation.Vertical,
            SeparationOverride = 6,
            HorizontalExpand = true,
        };

        box.AddChild(MakeSectionLabel(Localize(
            "cmu-round-statistics-planet-breakdown",
            "Planet Breakdown")));

        foreach (var planet in mode.Planets)
        {
            var decided = planet.SideAWins + planet.SideBWins;
            var text = FormatVersusSummary(
                mode,
                planet.SideAWins,
                planet.SideBWins,
                planet.Draws,
                planet.Unknown,
                decided);
            var average = FormatDurationOrNone(planet.AverageDurationSeconds);
            text += Localize(
                "cmu-round-statistics-average-suffix",
                $" / avg {average}",
                ("duration", average));

            box.AddChild(MakeBreakdownRow(
                FormatPlanet(planet.PlanetId),
                text,
                planet.Total,
                Border));
        }

        return box;
    }

    private Control MakePlatoonMatchupBreakdown(CMURoundModeStatistics mode)
    {
        var box = new BoxContainer
        {
            Orientation = LayoutOrientation.Vertical,
            SeparationOverride = 6,
            HorizontalExpand = true,
        };

        box.AddChild(MakeSectionLabel(Localize(
            "cmu-round-statistics-platoon-matchups",
            "Platoon Matchups")));

        foreach (var matchup in mode.PlatoonMatchups)
        {
            var decided = matchup.SideAWins + matchup.SideBWins;
            var text = FormatVersusSummary(
                mode,
                matchup.SideAWins,
                matchup.SideBWins,
                matchup.Draws,
                matchup.Unknown,
                decided);
            var govfor = FormatPlatoon(matchup.GovforPlatoonId);
            var opfor = FormatPlatoon(matchup.OpforPlatoonId);

            box.AddChild(MakeBreakdownRow(
                Localize(
                    "cmu-round-statistics-matchup",
                    $"{govfor} vs {opfor}",
                    ("govfor", govfor),
                    ("opfor", opfor)),
                text,
                matchup.Total,
                Border));
        }

        return box;
    }

    private Control MakePlayerCountBreakdown(CMURoundModeStatistics mode)
    {
        var box = new BoxContainer
        {
            Orientation = LayoutOrientation.Vertical,
            SeparationOverride = 6,
            HorizontalExpand = true,
        };

        box.AddChild(MakeSectionLabel(Localize(
            "cmu-round-statistics-player-count-bands",
            "Player Count Bands")));

        foreach (var band in mode.PlayerCountBands)
        {
            var decided = band.SideAWins + band.SideBWins;
            var text = FormatVersusSummary(
                mode,
                band.SideAWins,
                band.SideBWins,
                band.Draws,
                band.Unknown,
                decided);

            box.AddChild(MakeBreakdownRow(
                Localize(
                    "cmu-round-statistics-player-band",
                    $"{band.Band} players",
                    ("band", band.Band)),
                text,
                band.Total,
                Border));
        }

        return box;
    }

    private string FormatVersusSummary(
        CMURoundModeStatistics mode,
        int sideAWins,
        int sideBWins,
        int draws,
        int unknown,
        int decided)
    {
        var sideA = FormatSideA(mode.Preset);
        var sideB = FormatSideB(mode.Preset);
        var rateA = FormatRate(sideAWins, decided);
        var rateB = FormatRate(sideBWins, decided);
        var text = Localize(
            "cmu-round-statistics-versus-summary",
            $"{sideA} {rateA} ({sideAWins}) / {sideB} {rateB} ({sideBWins})",
            ("sideA", sideA),
            ("rateA", rateA),
            ("winsA", sideAWins),
            ("sideB", sideB),
            ("rateB", rateB),
            ("winsB", sideBWins));

        if (draws > 0)
        {
            text += Localize(
                "cmu-round-statistics-draws-suffix",
                $" / draws {draws}",
                ("count", draws));
        }

        if (unknown > 0)
        {
            text += Localize(
                "cmu-round-statistics-unknown-suffix",
                $" / unknown {unknown}",
                ("count", unknown));
        }

        return text;
    }

    private Control MakeBreakdownRow(string left, string right, int count, Color color)
    {
        var panel = MakePanel(CardQuiet, color.WithAlpha(BorderAlpha));
        var row = new BoxContainer
        {
            Orientation = LayoutOrientation.Horizontal,
            Margin = new Thickness(8, 6),
            SeparationOverride = 10,
            HorizontalExpand = true,
        };

        row.AddChild(MakeBadge(count.ToString(), color));
        row.AddChild(new Label
        {
            Text = left,
            FontColorOverride = Text,
            ClipText = true,
            HorizontalExpand = true,
        });
        row.AddChild(new Label
        {
            Text = right,
            FontColorOverride = Muted,
            ClipText = true,
            MinWidth = 240,
        });

        panel.AddChild(row);
        return panel;
    }

    private Control MakeRecentRoundPanel(CMURoundOutcomeRecord record)
    {
        var color = WinnerColor(record.Winner);
        var preset = FormatPreset(record.Preset);
        var winner = FormatWinner(record.Winner);
        var outcome = FormatOutcome(record.Outcome);
        var sourceLabel = record.Outcome == CMURoundStatisticsOutcome.Unknown
            ? Localize("cmu-round-statistics-manual-reason", "Manual reason")
            : Localize("cmu-round-statistics-recorded-source", "Recorded source");
        var source = FormatOutcomeSource(record.Source);
        var panel = MakePanel(CardQuiet, color.WithAlpha(BorderAlpha));
        var box = new BoxContainer
        {
            Orientation = LayoutOrientation.Vertical,
            Margin = new Thickness(10, 8),
            SeparationOverride = 4,
            HorizontalExpand = true,
        };

        box.AddChild(new Label
        {
            Text = Localize(
                "cmu-round-statistics-round-title",
                $"Round {record.RoundId} - {preset} - {winner}",
                ("round", record.RoundId),
                ("preset", preset),
                ("winner", winner)),
            FontColorOverride = color,
            ClipText = true,
            HorizontalExpand = true,
        });
        box.AddChild(new Label
        {
            Text = outcome,
            FontColorOverride = Text,
            ClipText = true,
            HorizontalExpand = true,
        });
        box.AddChild(new Label
        {
            Text = Localize(
                "cmu-round-statistics-source-detail",
                $"{sourceLabel}: {source}",
                ("label", sourceLabel),
                ("source", source)),
            FontColorOverride = Muted,
            ClipText = true,
            HorizontalExpand = true,
        });

        var threat = string.IsNullOrWhiteSpace(record.SelectedThreatId)
            ? Localize("cmu-round-statistics-no-threat", "no threat")
            : FormatThreat(record.SelectedThreatId);
        var planet = string.IsNullOrWhiteSpace(record.PlanetId)
            ? Localize("cmu-round-statistics-no-planet", "no planet")
            : FormatPlanet(record.PlanetId);
        var duration = FormatDuration(record.DurationSeconds);
        var recordedAt = record.RecordedAt.ToUniversalTime().ToString("yyyy-MM-dd HH:mm");

        box.AddChild(new Label
        {
            Text = Localize(
                "cmu-round-statistics-round-metadata",
                $"{record.PlayerCount} players / {duration} / {threat} / {planet} / {recordedAt} UTC",
                ("players", record.PlayerCount),
                ("duration", duration),
                ("threat", threat),
                ("planet", planet),
                ("time", recordedAt)),
            FontColorOverride = Muted,
            ClipText = true,
            HorizontalExpand = true,
        });

        panel.AddChild(box);
        return panel;
    }

    private Control MakeEmptyPanel(string text)
    {
        var panel = MakePanel(CardQuiet, UnknownGray.WithAlpha(BorderAlpha));
        panel.AddChild(new Label
        {
            Text = text,
            FontColorOverride = Muted,
            Margin = new Thickness(10, 8),
            ClipText = true,
            HorizontalExpand = true,
        });
        return panel;
    }

    private static Label MakeSectionLabel(string text)
    {
        return new Label
        {
            Text = text,
            FontColorOverride = Text,
            StyleClasses = { StyleBase.StyleClassLabelSubText },
            ClipText = true,
            HorizontalExpand = true,
        };
    }

    private static Control MakeBadge(string label, Color color)
    {
        var panel = MakePanel(Background, color.WithAlpha(BorderAlpha));
        panel.HorizontalExpand = false;
        panel.MinSize = new Vector2(Math.Max(28, label.Length * 8 + 14), 20);
        panel.AddChild(new Label
        {
            Text = label,
            FontColorOverride = color,
            Margin = new Thickness(7, 2),
            ClipText = true,
        });
        return panel;
    }

    private static PanelContainer MakePanel(Color background, Color border)
    {
        return new PanelContainer
        {
            HorizontalExpand = true,
            PanelOverride = new StyleBoxFlat
            {
                BackgroundColor = background,
                BorderColor = border,
                BorderThickness = new Thickness(1),
            },
        };
    }

    private string Localize(
        string messageId,
        string fallback,
        params (string, object)[] args)
    {
        return CMULocalization.GetTargetStringOrFallback(
            _localization,
            messageId,
            fallback,
            args);
    }

    private static string FormatRate(int wins, int decided)
    {
        return decided <= 0
            ? "0.0%"
            : $"{wins * 100f / decided:0.0}%";
    }

    private string FormatRecentForm(CMURoundModeStatistics mode)
    {
        if (mode.RecentForm.Rounds == 0)
            return Localize("cmu-round-statistics-no-data", "No data");

        return $"{mode.RecentForm.SideAWins}-{mode.RecentForm.SideBWins}";
    }

    private string FormatStreak(CMURoundStreak streak)
    {
        if (streak.Count <= 0)
            return Localize("cmu-round-statistics-none", "None");

        var winner = FormatWinner(streak.Winner);
        return Localize(
            "cmu-round-statistics-streak",
            $"{winner} x{streak.Count}",
            ("winner", winner),
            ("count", streak.Count));
    }

    private static Color StreakColor(CMURoundStreak streak)
    {
        return streak.Count <= 0
            ? UnknownGray
            : WinnerColor(streak.Winner);
    }

    private static string FormatDuration(int seconds)
    {
        var duration = TimeSpan.FromSeconds(Math.Max(0, seconds));
        return $"{(int) duration.TotalHours:00}:{duration.Minutes:00}:{duration.Seconds:00}";
    }

    private string FormatDurationOrNone(int seconds)
    {
        return seconds <= 0
            ? Localize("cmu-round-statistics-no-data", "No data")
            : FormatDuration(seconds);
    }

    private string FormatOutcomeSource(string source)
    {
        if (string.IsNullOrWhiteSpace(source))
            return Localize(
                "cmu-round-statistics-source",
                "Unknown source",
                ("source", "Unknown"));

        source = source.Trim();

        const string withdrawPrefix = "WithdrawConsole:";
        if (source.StartsWith(withdrawPrefix, StringComparison.OrdinalIgnoreCase))
        {
            var faction = FormatFaction(source[withdrawPrefix.Length..]);
            return Localize(
                "cmu-round-statistics-source-withdrawal",
                $"Withdraw console: {faction}",
                ("faction", faction));
        }

        const string objectivePrefix = "AuObjective:";
        if (source.StartsWith(objectivePrefix, StringComparison.OrdinalIgnoreCase))
        {
            var faction = FormatFaction(source[objectivePrefix.Length..]);
            return Localize(
                "cmu-round-statistics-source-objective",
                $"AU objective: {faction}",
                ("faction", faction));
        }

        var sourceKey = source.ToLowerInvariant() switch
        {
            "majorxenovictory" => "MajorXenoVictory",
            "minorxenovictory" => "MinorXenoVictory",
            "minormarinevictory" => "MinorMarineVictory",
            "majormarinevictory" => "MajorMarineVictory",
            "alldied" => "AllDied",
            "killallgovforrule" => "KillAllGovforRule",
            "killallclfrule" => "KillAllClfRule",
            "killallcolonistrule" => "KillAllColonistRule",
            "killallhumanrule" => "KillAllHumanRule",
            "threatsurviverule" => "ThreatSurviveRule",
            "hivecollapserule" => "HiveCollapseRule",
            "killallabominationsrule" => "KillAllAbominationsRule",
            "killallaperule" => "KillAllApeRule",
            "killalltriberule" => "KillAllTribeRule",
            "killallxenorule" => "KillAllXenoRule",
            "killallyautjarule" => "KillAllYautjaRule",
            "withdrawconsolestalemate" => "WithdrawConsoleStalemate",
            "nopendingoutcome" or "roundendmessageevent" => "NoPendingOutcome",
            "unknown" => "Unknown",
            _ => "Other",
        };

        return Localize(
            "cmu-round-statistics-source",
            sourceKey == "Other" ? source : sourceKey,
            ("source", sourceKey));
    }

    private string FormatFaction(string faction)
    {
        var factionKey = faction.Trim().ToLowerInvariant() switch
        {
            "govfor" => "govfor",
            "opfor" => "opfor",
            "clf" => "clf",
            "colony" or "colonist" => "colony",
            "threat" => "threat",
            "xeno" => "xeno",
            _ => "unknown",
        };

        var fallback = factionKey switch
        {
            "govfor" => "Govfor",
            "opfor" => "Opfor",
            "clf" => "CLF",
            "colony" => "Colonists",
            "threat" => "Threat",
            "xeno" => "Xeno",
            _ => "unknown faction",
        };

        return Localize(
            "cmu-round-statistics-faction",
            fallback,
            ("faction", factionKey));
    }

    private string FormatPreset(CMURoundStatisticsPreset preset)
    {
        var fallback = preset switch
        {
            CMURoundStatisticsPreset.DistressSignal => "Distress Signal",
            CMURoundStatisticsPreset.Insurgency => "Insurgency",
            CMURoundStatisticsPreset.ColonyFall => "Colony Fall",
            _ => "Unknown mode",
        };

        return Localize(
            "cmu-round-statistics-preset",
            fallback,
            ("preset", preset.ToString()));
    }

    private string FormatSideA(CMURoundStatisticsPreset preset)
    {
        return FormatWinner(preset switch
        {
            CMURoundStatisticsPreset.DistressSignal => CMURoundStatisticsWinner.Xeno,
            CMURoundStatisticsPreset.Insurgency => CMURoundStatisticsWinner.Govfor,
            CMURoundStatisticsPreset.ColonyFall => CMURoundStatisticsWinner.Colonists,
            _ => CMURoundStatisticsWinner.Unknown,
        });
    }

    private string FormatSideB(CMURoundStatisticsPreset preset)
    {
        return FormatWinner(preset switch
        {
            CMURoundStatisticsPreset.DistressSignal => CMURoundStatisticsWinner.Govfor,
            CMURoundStatisticsPreset.Insurgency => CMURoundStatisticsWinner.Clf,
            CMURoundStatisticsPreset.ColonyFall => CMURoundStatisticsWinner.Threat,
            _ => CMURoundStatisticsWinner.Unknown,
        });
    }

    private string FormatWinner(CMURoundStatisticsWinner winner)
    {
        var fallback = winner switch
        {
            CMURoundStatisticsWinner.Xeno => "Xeno",
            CMURoundStatisticsWinner.Govfor => "Govfor",
            CMURoundStatisticsWinner.Clf => "CLF",
            CMURoundStatisticsWinner.Colonists => "Colonists",
            CMURoundStatisticsWinner.Threat => "Threat",
            CMURoundStatisticsWinner.Draw => "Draw",
            CMURoundStatisticsWinner.Unknown => "Unknown",
            _ => "Unknown",
        };

        return Localize(
            "cmu-round-statistics-winner",
            fallback,
            ("winner", winner.ToString()));
    }

    private string FormatOutcome(CMURoundStatisticsOutcome outcome)
    {
        var fallback = outcome switch
        {
            CMURoundStatisticsOutcome.XenoMajorHijackWin => "Xeno major - hijack win",
            CMURoundStatisticsOutcome.XenoMinorHijackLoss => "Xeno minor - hijack loss / xenowipe",
            CMURoundStatisticsOutcome.MarineMinorHiveCollapse => "Marine minor - hive collapse",
            CMURoundStatisticsOutcome.MarineMajorXenoWipe => "Marine major - pre-hijack xeno wipe",
            CMURoundStatisticsOutcome.DrawAlmayerAutodestruct => "Draw - Almayer autodestruct",
            CMURoundStatisticsOutcome.InsurgencyClfVictory => "CLF victory",
            CMURoundStatisticsOutcome.InsurgencyGovforVictory => "Govfor victory",
            CMURoundStatisticsOutcome.ColonyFallThreatVictory => "Threat victory",
            CMURoundStatisticsOutcome.ColonyFallSurvivorVictory => "Colonist victory",
            CMURoundStatisticsOutcome.Stalemate => "Stalemate",
            CMURoundStatisticsOutcome.ObjectiveVictory => "Objective victory",
            CMURoundStatisticsOutcome.Unknown => "Unknown / manual ending",
            _ => "Unknown / manual ending",
        };

        return Localize(
            "cmu-round-statistics-outcome",
            fallback,
            ("outcome", outcome.ToString()));
    }

    private string FormatThreat(string threatId)
    {
        string? messageId = null;
        if (threatId.Contains("cultist", StringComparison.OrdinalIgnoreCase))
            messageId = "au14-threat-vote-option-cultist-xeno";
        else if (threatId.Contains("tribal", StringComparison.OrdinalIgnoreCase))
            messageId = "au14-threat-vote-option-tribal";
        else if (threatId.Contains("abomination", StringComparison.OrdinalIgnoreCase))
            messageId = "au14-threat-vote-option-abominations";
        else if (threatId.Contains("xeno", StringComparison.OrdinalIgnoreCase))
            messageId = "au14-threat-vote-option-xeno";
        else if (threatId.Contains("ape", StringComparison.OrdinalIgnoreCase))
            messageId = "au14-threat-vote-option-ape";
        else if (threatId.Contains("wendigo", StringComparison.OrdinalIgnoreCase))
            messageId = "au14-threat-vote-option-wendigo";

        return messageId != null
            ? _localization.GetString(messageId)
            : Localize("cmu-round-statistics-threat-unknown", "Unknown threat");
    }

    private string FormatPlanet(string planetId)
    {
        return _prototypes.TryIndex<EntityPrototype>(planetId, out var prototype) &&
               !string.IsNullOrWhiteSpace(prototype.Name)
            ? prototype.Name
            : Localize("cmu-round-statistics-planet-unknown", "Unknown planet");
    }

    private string FormatPlatoon(string platoonId)
    {
        if (!_prototypes.TryIndex<PlatoonPrototype>(platoonId, out var prototype) ||
            string.IsNullOrWhiteSpace(prototype.Name))
        {
            return Localize("cmu-round-statistics-platoon-unknown", "Unknown platoon");
        }

        return CMUPrototypeLocalization.GetPrototypeText(
            _localization,
            "platoon",
            prototype.ID,
            "name",
            prototype.Name);
    }

    private static Color WinnerColor(CMURoundStatisticsWinner winner)
    {
        return winner switch
        {
            CMURoundStatisticsWinner.Xeno => XenoRed,
            CMURoundStatisticsWinner.Govfor => GovforBlue,
            CMURoundStatisticsWinner.Clf => ClfGold,
            CMURoundStatisticsWinner.Colonists => ColonistGreen,
            CMURoundStatisticsWinner.Threat => ThreatPurple,
            CMURoundStatisticsWinner.Draw => DrawGray,
            CMURoundStatisticsWinner.Unknown => UnknownGray,
            _ => Text,
        };
    }

    private static Color GetSideAColor(CMURoundStatisticsPreset preset)
    {
        return preset switch
        {
            CMURoundStatisticsPreset.DistressSignal => XenoRed,
            CMURoundStatisticsPreset.Insurgency => GovforBlue,
            CMURoundStatisticsPreset.ColonyFall => ColonistGreen,
            _ => Text,
        };
    }

    private static Color GetSideBColor(CMURoundStatisticsPreset preset)
    {
        return preset switch
        {
            CMURoundStatisticsPreset.DistressSignal => GovforBlue,
            CMURoundStatisticsPreset.Insurgency => ClfGold,
            CMURoundStatisticsPreset.ColonyFall => ThreatPurple,
            _ => Text,
        };
    }
}
