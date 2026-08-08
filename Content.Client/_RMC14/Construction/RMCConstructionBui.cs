using Content.Client._RMC14.UserInterface;
using Content.Client.Message;
using Content.Shared._CMU14.Localizations;
using Content.Shared._RMC14.Construction;
using Content.Shared._RMC14.Construction.Prototypes;
using Content.Shared.FixedPoint;
using Content.Shared.Stacks;
using JetBrains.Annotations;
using Robust.Client.GameObjects;
using Robust.Client.UserInterface;
using Robust.Client.UserInterface.Controls;
using Robust.Shared.Localization;
using Robust.Shared.Prototypes;

namespace Content.Client._RMC14.Construction;

[UsedImplicitly]
public sealed partial class RMCConstructionBui : BoundUserInterface
{
    [Dependency] private IComponentFactory _compFactory = default!;
    [Dependency] private ILocalizationManager _localization = default!;
    [Dependency] private IPrototypeManager _prototype = default!;

    [ViewVariables]
    private RMCConstructionWindow? _window;

    public RMCConstructionBui(EntityUid owner, Enum uiKey) : base(owner, uiKey)
    {
    }

    protected override void Open()
    {
        base.Open();

        _window = this.CreateWindow<RMCConstructionWindow>();
        var titlePrefix = CMUPrototypeLocalization.GetStringOrFallback(
            _localization,
            "rmc-construction-ui",
            "window",
            "title",
            "Construction using the");
        _window.Title = $"{titlePrefix} {EntMan.GetComponent<MetaDataComponent>(Owner).EntityName}";

        if (!EntMan.TryGetComponent(Owner, out RMCConstructionItemComponent? constructionItem))
            return;

        if (constructionItem.Buildable is not { } entries)
            return;

        Refresh(entries);
    }

    protected override void UpdateState(BoundUserInterfaceState state)
    {
        base.UpdateState(state);

        if (State is RMCConstructionBuiState s)
            RefreshStackAmount();
    }

    private void AddEntry(ProtoId<RMCConstructionPrototype> prototypeId)
    {
        if (!_prototype.TryIndex(prototypeId, out var build))
            return;

        if (build.IsDivider)
        {
            var divider = new BlueHorizontalSeparator();
            divider.Margin = new Thickness(5);

            _window?.ConstructionContainer.AddChild(divider);
            return;
        }

        if (build.Listed != null)
        {
            AddListButton(build);
            return;
        }

        var buildName = LocalizeBuildName(build);
        var nameString = Loc.GetString("rmc-construction-list", ("name", buildName));

        if (build.MaterialCost != null)
            nameString = Loc.GetString("rmc-construction-entry", ("name", buildName), ("amount", build.MaterialCost), ("material", Owner));

        var control = new RMCBuildChoiceControl();
        control.Set(nameString);

        if (build.StackAmounts is { } stackAmounts)
        {
            foreach (var stack in stackAmounts)
            {
                var button = new Button()
                {
                    Text = "x" + stack,
                    StyleClasses = { "OpenBoth" },
                    SetWidth = 45,
                    Margin = new Thickness(0, 0, 0, 3),
                    HorizontalAlignment = Control.HAlignment.Right
                };

                control.StackAmountContainer.AddChild(button);

                button.OnPressed += _ =>
                {
                    SendPredictedMessage(new RMCConstructionBuiMsg(build, stack));
                };

                control.Button.SetWidth = 250;
                control.Button.HorizontalAlignment = Control.HAlignment.Left;
            }
        }

        control.Button.OnPressed += _ =>
        {
            SendPredictedMessage(new RMCConstructionBuiMsg(build, build.Amount));
        };

        _window?.ConstructionContainer.AddChild(control);
    }

    private void AddListButton(RMCConstructionPrototype build)
    {
        if (build.Listed is not { } listed)
            return;

        var control = new RMCBuildChoiceControl();
        control.Set(LocalizeBuildName(build));

        control.Button.OnPressed += _ =>
        {
            _window?.ConstructionContainer.Children.Clear();
            Refresh(listed);
        };

        _window?.ConstructionContainer.AddChild(control);
    }

    public void Refresh(ProtoId<RMCConstructionPrototype>[] entries)
    {
        if (_window == null)
            return;

        RefreshStackAmount();

        foreach (var entry in entries)
        {
            AddEntry(entry);
        }
    }

    public void RefreshStackAmount()
    {
        if (_window == null)
            return;

        if (EntMan.TryGetComponent(Owner, out StackComponent? stack))
        {
            var amountPrefix = CMUPrototypeLocalization.GetStringOrFallback(
                _localization,
                "rmc-construction-ui",
                "stack",
                "amount",
                "Amount Left:");
            _window.MaterialLabel.Text = $"{amountPrefix} {stack.Count}";
        }
    }

    private string LocalizeBuildName(RMCConstructionPrototype prototype)
    {
        return CMUPrototypeLocalization.GetStringOrFallback(
            _localization,
            "rmc-construction",
            prototype.ID,
            "name",
            prototype.Name);
    }
}
