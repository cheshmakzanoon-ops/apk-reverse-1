local UILWSeasonFactionWarSuccessCtrl = BaseClass("UILWSeasonFactionWarSuccessCtrl", UIBaseCtrl)

function UILWSeasonFactionWarSuccessCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonFactionWarSuccess)
end

return UILWSeasonFactionWarSuccessCtrl
