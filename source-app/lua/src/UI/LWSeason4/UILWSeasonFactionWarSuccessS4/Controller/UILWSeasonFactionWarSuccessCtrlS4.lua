local UILWSeasonFactionWarSuccessCtrlS4 = BaseClass("UILWSeasonFactionWarSuccessCtrlS4", UIBaseCtrl)

function UILWSeasonFactionWarSuccessCtrlS4:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonFactionWarSuccessS4)
end

return UILWSeasonFactionWarSuccessCtrlS4
