local base = UIBaseContainer
local UIMainPower = BaseClass("UIMainPower", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonRedPoint = require("Framework.UI.Component.UICommonRedPoint")

function UIMainPower:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMainPower:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMainPower:OnEnable()
  base.OnEnable(self)
  self:RefreshPower()
end

function UIMainPower:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textPower = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.imgPowerIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.btnLWMainUIPower = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnLWMainUIPower:SetOnClick(function()
    self:OnBtnLWMainUIPowerClick()
  end)
  self.compPowerCommonRedPoint = self.viewSkin:AddComponent(self, UICommonRedPoint, 4)
  self.compPowerCommonRedPoint:SetType(CommonRedPointPriority.LevelNormal)
end

function UIMainPower:ComponentDestroy()
  self.viewSkin = nil
  self.textPower = nil
  self.imgPowerIcon = nil
  self.btnLWMainUIPower = nil
  self.compPowerCommonRedPoint = nil
end

function UIMainPower:DataDefine()
end

function UIMainPower:DataDestroy()
end

function UIMainPower:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerPowerInfoUpdated, self.RefreshPower)
  self:AddUIListener(EventId.DevelopRecommendEntranceRedUpdate, self.OnDevelopRecommendEntranceRedUpdate)
  self:AddUIListener(EventId.MainLvUp, self.OnMainLevelUp)
end

function UIMainPower:OnRemoveListener()
  self:RemoveUIListener(EventId.MainLvUp, self.OnMainLevelUp)
  self:RemoveUIListener(EventId.PlayerPowerInfoUpdated, self.RefreshPower)
  self:RemoveUIListener(EventId.DevelopRecommendEntranceRedUpdate, self.OnDevelopRecommendEntranceRedUpdate)
  base.OnRemoveListener(self)
end

function UIMainPower:OnBtnLWMainUIPowerClick()
  self.compPowerCommonRedPoint:SetViewed()
  UIUtil.OpenPowerOverviewPanel()
end

function UIMainPower:ReInit()
  self:RefreshPower()
  self:RefreshPowerRed()
end

function UIMainPower:RefreshPower()
  if LuaEntry.Player.power == self.lastCachePower then
    return
  end
  local playerPower = LuaEntry.Player.power
  if self.textPower and not IsNull(self.textPower) then
    self.textPower:SetText(string.GetFormattedSeperatorNum(math.floor(playerPower)))
  end
  self.lastCachePower = LuaEntry.Player.power
end

function UIMainPower:RefreshPowerRed()
  local seasonNum = SeasonUtil.GetSeason()
  self.compPowerCommonRedPoint:SetDefaultVisible(DataCenter.LWDevelopRecommendManager:IsShowEntranceRed() and seasonNum <= 2)
end

function UIMainPower:OnDevelopRecommendEntranceRedUpdate()
  self:RefreshPowerRed()
end

function UIMainPower:OnMainLevelUp()
  self:RefreshPowerRed()
end

return UIMainPower
