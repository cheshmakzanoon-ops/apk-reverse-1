local UIHeroExhibitPanelCtrl = BaseClass("UIHeroExhibitPanelCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local heroUuid = 0

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroExhibitPanel)
  EventManager:GetInstance():Broadcast(EventId.CloseHeroExhibit, heroUuid)
end

local function OnCustomKeyCodeEscape(self)
  self.view:OnBtnCloseClick()
end

local function SetHeroUuid(self, uuid)
  heroUuid = uuid
end

UIHeroExhibitPanelCtrl.CloseSelf = CloseSelf
UIHeroExhibitPanelCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
UIHeroExhibitPanelCtrl.SetHeroUuid = SetHeroUuid
return UIHeroExhibitPanelCtrl
