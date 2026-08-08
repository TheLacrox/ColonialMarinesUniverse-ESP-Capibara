using System.Globalization; // CMU14
using System.Numerics;
using Content.Client.Guidebook; // CMU14
using Content.Client.Lobby.UI;
using Content.Client.Stylesheets;
using Content.Client.UserInterface.Systems.EscapeMenu;
using Content.Shared.CCVar;
using Robust.Client.UserInterface;
using Robust.Client.UserInterface.Controls;
using Robust.Client.UserInterface.CustomControls;
using Robust.Shared.ContentPack;
using Robust.Shared.Configuration;
using Robust.Shared.Localization; // CMU14
using Robust.Shared.Utility; // CMU14

namespace Content.Client.Info
{
    public sealed partial class RulesAndInfoWindow : DefaultWindow
    {
        [Dependency] private IResourceManager _resourceManager = default!;
        [Dependency] private IConfigurationManager _cfg = default!;
        [Dependency] private IStylesheetManager _stylesheetManager = default!;
        [Dependency] private ILocalizationManager _localization = default!; // CMU14

        public RulesAndInfoWindow()
        {
            IoCManager.InjectDependencies(this);
            ApplyCrtPalette();

            Title = Loc.GetString("ui-info-title");

            var panel = new PanelContainer
            {
                HorizontalExpand = true,
                VerticalExpand = true,
                StyleClasses = { StyleNano.StyleClassCrtPanel }
            };

            var rootContainer = new TabContainer
            {
                HorizontalExpand = true,
                VerticalExpand = true,
                StyleClasses = { StyleNano.StyleClassCrtTabContainer }
            };

            var rulesList = new RulesControl
            {
                Margin = new Thickness(10)
            };
            var tutorialList = new Info
            {
                Margin = new Thickness(10)
            };

            rootContainer.AddChild(rulesList);
            rootContainer.AddChild(tutorialList);

            TabContainer.SetTabTitle(rulesList, Loc.GetString("ui-info-tab-rules"));
            TabContainer.SetTabTitle(tutorialList, Loc.GetString("ui-info-tab-tutorial"));

            PopulateTutorial(tutorialList);

            panel.AddChild(rootContainer);
            Contents.AddChild(panel);
            CrtLobbyTheme.Apply(this, useCrtTypography: false);
            _cfg.OnValueChanged(CCVars.CrtUiColor, OnCrtUiColorChanged);
            _cfg.OnValueChanged(CCVars.CrtUiEnabled, OnCrtUiEnabledChanged);

            SetSize = new Vector2(650, 650);
        }

        [Obsolete("Controls should only be removed from UI tree instead of being disposed")]
        protected override void Dispose(bool disposing)
        {
            base.Dispose(disposing);

            _cfg.UnsubValueChanged(CCVars.CrtUiColor, OnCrtUiColorChanged);
            _cfg.UnsubValueChanged(CCVars.CrtUiEnabled, OnCrtUiEnabledChanged);
        }

        private void OnCrtUiColorChanged(string _)
        {
            ApplyCrtPalette();
        }

        private void OnCrtUiEnabledChanged(bool _)
        {
            ApplyCrtPalette();
            CrtLobbyTheme.Apply(this, useCrtTypography: false);
        }

        private void ApplyCrtPalette()
        {
            Stylesheet = _stylesheetManager.SheetNano;
        }

        private void PopulateTutorial(Info tutorialList)
        {
            //AddSection(tutorialList, Loc.GetString("ui-info-header-intro"), "Intro.txt");
            var infoControlSection = new InfoControlsSection();
            tutorialList.InfoContainer.AddChild(infoControlSection);
            AddSection(tutorialList, Loc.GetString("ui-info-header-gameplay"), "Gameplay.txt", true);
            AddSection(tutorialList, Loc.GetString("ui-info-header-sandbox"), "Sandbox.txt", true);

            infoControlSection.ControlsButton.OnPressed += _ => UserInterfaceManager.GetUIController<OptionsUIController>().OpenWindow();
        }

        private static void AddSection(Info info, Control control)
        {
            info.InfoContainer.AddChild(control);
        }

        private void AddSection(Info info, string title, string path, bool markup = false)
        {
            AddSection(info, MakeSection(title, path, markup, _resourceManager, _localization.DefaultCulture)); // CMU14
        }

        // CMU14 start - resolve the culture mirror, matching DocumentParsingManager.ResolveDocumentPath,
        // so /ServerInfo/<culture>/<file> overrides the English original when it exists.
        private static Control MakeSection(
            string title,
            string path,
            bool markup,
            IResourceManager res,
            CultureInfo? culture)
        {
            var resolved = GuidebookDocumentResolver.Resolve(res, new ResPath($"/ServerInfo/{path}"), culture);
            return new InfoSection(title, res.ContentFileReadAllText(resolved), markup);
        }
        // CMU14 end

    }
}
