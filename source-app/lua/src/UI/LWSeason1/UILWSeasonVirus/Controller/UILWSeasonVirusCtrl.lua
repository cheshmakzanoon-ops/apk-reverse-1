local UILWSeasonVirusCtrl = BaseClass("UILWSeasonVirusCtrl", UIBaseCtrl)

function UILWSeasonVirusCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonVirus)
end

return UILWSeasonVirusCtrl
