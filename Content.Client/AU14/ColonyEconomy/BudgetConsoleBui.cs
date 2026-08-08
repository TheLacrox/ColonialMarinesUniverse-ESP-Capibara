using static Content.Client.AU14.ColonyEconomy.ColonyEconomyLoc;
using Content.Shared.AU14.ColonyEconomy;
using Robust.Client.UserInterface;
using Robust.Client.UserInterface.Controls;

namespace Content.Client.AU14.ColonyEconomy;

public sealed class BudgetConsoleBui(EntityUid owner, Enum uiKey) : BoundUserInterface(owner, uiKey)
{
    private BudgetConsoleWindow? _window;

    protected override void Open()
    {
        base.Open();
        _window = this.CreateWindow<BudgetConsoleWindow>();

        _window.Withdraw100.OnPressed += _ => SendPredictedMessage(new BudgetConsoleWithdrawBuiMsg(100));
        _window.Withdraw250.OnPressed += _ => SendPredictedMessage(new BudgetConsoleWithdrawBuiMsg(250));
        _window.Withdraw500.OnPressed += _ => SendPredictedMessage(new BudgetConsoleWithdrawBuiMsg(500));
        _window.DispenseSalariesButton.OnPressed += _ => SendPredictedMessage(new BudgetConsoleDispenseSalariesBuiMsg());
    }

    protected override void UpdateState(BoundUserInterfaceState state)
    {
        if (_window == null || state is not BudgetConsoleBuiState s)
            return;

        _window.BudgetLabel.Text = Target("cmu-colony-economy-current-budget", $"Current Budget: {s.Budget:C}", ("budget", s.Budget.ToString("C")));

        // Rebuild department list
        _window.DepartmentList.RemoveAllChildren();
        foreach (var dept in s.Departments)
        {
            var row = new BoxContainer
            {
                Orientation = BoxContainer.LayoutOrientation.Horizontal,
                SeparationOverride = 4
            };

            var label = new Label
            {
                Text = Target("cmu-colony-economy-department-budget-entry", $"{dept.Name} (Budget: ${dept.Budget:F0})", ("department", dept.Name), ("budget", dept.Budget.ToString("F0"))),
                HorizontalExpand = true,
                SizeFlagsStretchRatio = 2
            };

            var transferBtn = new Button { Text = Target("cmu-colony-economy-transfer", "Transfer") };
            var deptUidCopy = dept.Uid;
            transferBtn.OnPressed += _ =>
            {
                if (_window != null && _window.TransferAmountInput.Text is { } text && float.TryParse(text, out var amount) && amount > 0)
                    SendPredictedMessage(new BudgetConsoleTransferToDeptBuiMsg(deptUidCopy, amount));
            };

            row.AddChild(label);
            row.AddChild(transferBtn);
            _window.DepartmentList.AddChild(row);
        }

        if (s.Departments.Count == 0)
        {
            _window.DepartmentList.AddChild(new Label { Text = Target("cmu-colony-economy-no-departments", "No departments found.") });
        }
    }
}
