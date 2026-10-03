local UIHeroEquipDetailPanelCtrl = BaseClass("UIHeroEquipDetailPanelCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  if self.closeCallBack ~= nil then
    self.closeCallBack()
    self.closeCallBack = nil
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroEquipDetailPanel)
end

local function SetCloseCallBack(self, callBack)
  self.closeCallBack = callBack
end

local function OnCustomKeyCodeEscape(self)
  self:CloseSelf()
end

UIHeroEquipDetailPanelCtrl.CloseSelf = CloseSelf
UIHeroEquipDetailPanelCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
UIHeroEquipDetailPanelCtrl.SetCloseCallBack = SetCloseCallBack
return UIHeroEquipDetailPanelCtrl
