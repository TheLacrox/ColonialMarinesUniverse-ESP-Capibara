using static Content.Client.AU14.ColonyEconomy.ColonyEconomyLoc;
using Content.Shared.AU14.ColonyEconomy;
using Robust.Client.UserInterface;

namespace Content.Client.AU14.ColonyEconomy;

public sealed class ColonyAtmBui(EntityUid owner, Enum uiKey) : BoundUserInterface(owner, uiKey)
{
    private ColonyAtmWindow? _window;

    protected override void Open()
    {
        base.Open();
        _window = this.CreateWindow<ColonyAtmWindow>();

        _window.Withdraw50.OnPressed += _ => SendPredictedMessage(new ColonyAtmWithdrawBuiMsg(10));
        _window.Withdraw100.OnPressed += _ => SendPredictedMessage(new ColonyAtmWithdrawBuiMsg(25));
        _window.Withdraw250.OnPressed += _ => SendPredictedMessage(new ColonyAtmWithdrawBuiMsg(100));
        _window.Withdraw500.OnPressed += _ => SendPredictedMessage(new ColonyAtmWithdrawBuiMsg(250));
    }

    protected override void UpdateState(BoundUserInterfaceState state)
    {
        if (_window == null || state is not ColonyAtmBuiState s)
            return;

        _window.OwnerLabel.Text = Target("cmu-colony-economy-account", $"Account: {s.OwnerName}", ("owner", s.OwnerName));
        _window.BalanceLabel.Text = Target("cmu-colony-economy-balance", $"Balance: ${s.Balance}", ("balance", s.Balance));
        _window.IncomeTaxLabel.Text = s.IncomeTaxPercent > 0
            ? Target("cmu-colony-economy-atm-income-tax", $"Income Tax: {s.IncomeTaxPercent:F0}% (applied on withdrawal)", ("percent", s.IncomeTaxPercent.ToString("F0")))
            : Target("cmu-colony-economy-no-income-tax", "No income tax.");
    }
}

