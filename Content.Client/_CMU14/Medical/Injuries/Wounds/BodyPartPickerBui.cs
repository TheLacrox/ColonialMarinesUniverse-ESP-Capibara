using Content.Client._CMU14.Localizations;
using Content.Shared._CMU14.Medical.Injuries.Wounds;
using Content.Shared.Body.Part;
using JetBrains.Annotations;
using Robust.Client.UserInterface;
using Robust.Client.UserInterface.Controls;

namespace Content.Client._CMU14.Medical.Injuries.Wounds;

[UsedImplicitly]
public sealed class BodyPartPickerBui : BoundUserInterface
{
    [ViewVariables]
    private BodyPartPickerWindow? _window;

    public BodyPartPickerBui(EntityUid owner, Enum uiKey) : base(owner, uiKey)
    {
    }

    protected override void Open()
    {
        base.Open();
        _window = this.CreateWindow<BodyPartPickerWindow>();
        if (State is BodyPartPickerBuiState s)
            Refresh(s);
    }

    protected override void UpdateState(BoundUserInterfaceState state)
    {
        base.UpdateState(state);
        if (state is BodyPartPickerBuiState s)
            Refresh(s);
    }

    private void Refresh(BodyPartPickerBuiState state)
    {
        if (_window is null)
            return;

        _window.PartList.DisposeAllChildren();

        if (state.Available.Count == 0)
        {
            var empty = new Label { Text = Loc.GetString("cmu-medical-bandage-no-wounds") };
            _window.PartList.AddChild(empty);
            return;
        }

        foreach (var entry in state.Available)
        {
            var part = FormatPart(entry.Type, entry.Symmetry);
            var count = entry.UntreatedWounds;
            var fallback = $"{part} — {count} wound{(count == 1 ? string.Empty : "s")}";
            var label = CMULocExtension.GetString(
                "cmu-body-part-picker-entry",
                fallback,
                ("part", part),
                ("count", count));
            var button = new Button
            {
                Text = label,
                HorizontalExpand = true,
                Margin = new Thickness(0, 0, 0, 4),
            };
            var captured = entry.Part;
            button.OnPressed += _ => SendMessage(new BodyPartPickerSelectMessage(captured));
            _window.PartList.AddChild(button);
        }
    }

    private static string FormatPart(BodyPartType type, BodyPartSymmetry symmetry)
    {
        var key = (type, symmetry) switch
        {
            (BodyPartType.Head, _) => "rmc-armor-zone-head",
            (BodyPartType.Torso, _) => "rmc-armor-zone-chest",
            (BodyPartType.Arm, BodyPartSymmetry.Left) => "rmc-armor-zone-left-arm",
            (BodyPartType.Arm, BodyPartSymmetry.Right) => "rmc-armor-zone-right-arm",
            (BodyPartType.Hand, BodyPartSymmetry.Left) => "rmc-armor-zone-left-hand",
            (BodyPartType.Hand, BodyPartSymmetry.Right) => "rmc-armor-zone-right-hand",
            (BodyPartType.Leg, BodyPartSymmetry.Left) => "rmc-armor-zone-left-leg",
            (BodyPartType.Leg, BodyPartSymmetry.Right) => "rmc-armor-zone-right-leg",
            (BodyPartType.Foot, BodyPartSymmetry.Left) => "rmc-armor-zone-left-foot",
            (BodyPartType.Foot, BodyPartSymmetry.Right) => "rmc-armor-zone-right-foot",
            (BodyPartType.Tail, _) => "markings-category-Tail",
            _ => null,
        };

        return key is null ? type.ToString() : Loc.GetString(key);
    }
}
