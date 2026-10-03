local UILWSeasonFactionWarDeclareDlgCtrl = BaseClass("UILWSeasonFactionWarDeclareDlgCtrl", UIBaseCtrl)

function UILWSeasonFactionWarDeclareDlgCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonFactionWarDeclareDlg)
end

return UILWSeasonFactionWarDeclareDlgCtrl
