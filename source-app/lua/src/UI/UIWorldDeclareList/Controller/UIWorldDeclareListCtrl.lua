local UIWorldDeclareListCtrl = BaseClass("UIWorldDeclareListCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldDeclareList)
end

UIWorldDeclareListCtrl.CloseSelf = CloseSelf
return UIWorldDeclareListCtrl
