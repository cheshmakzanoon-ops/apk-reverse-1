local UIActCrazyRockGameCtrl = BaseClass("UIActCrazyRockGameCtrl", UIBaseCtrl)

function UIActCrazyRockGameCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.CrazyRockGame)
end

function UIActCrazyRockGameCtrl:OnCustomKeyCodeEscape()
end

return UIActCrazyRockGameCtrl
