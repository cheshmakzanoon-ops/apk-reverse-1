local UIAllianceStarMainThumbNormalPanel = BaseClass("UIAllianceStarMainThumbNormalPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UICommonHead = require("Framework.UI.Component.UICommonHead")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.compUIPlayerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.textName = self:AddComponent(UITextMeshProUGUIEx, "NameText")
  self.textScore = self:AddComponent(UITextMeshProUGUIEx, "ScoreText")
end

local function ComponentDestroy(self)
  self.compUIPlayerHead = nil
  self.textName = nil
  self.textScore = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function Refresh(self, ceremonyInfo, roleInfo, score)
  if roleInfo then
    self.textName:SetText(roleInfo.name)
    self.compUIPlayerHead:ParseHeadInfo(roleInfo)
  end
  self.textScore:SetText(string.GetFormattedSeparatorNum(score))
end

UIAllianceStarMainThumbNormalPanel.OnCreate = OnCreate
UIAllianceStarMainThumbNormalPanel.OnDestroy = OnDestroy
UIAllianceStarMainThumbNormalPanel.OnEnable = OnEnable
UIAllianceStarMainThumbNormalPanel.OnDisable = OnDisable
UIAllianceStarMainThumbNormalPanel.ComponentDefine = ComponentDefine
UIAllianceStarMainThumbNormalPanel.ComponentDestroy = ComponentDestroy
UIAllianceStarMainThumbNormalPanel.DataDefine = DataDefine
UIAllianceStarMainThumbNormalPanel.DataDestroy = DataDestroy
UIAllianceStarMainThumbNormalPanel.OnAddListener = OnAddListener
UIAllianceStarMainThumbNormalPanel.OnRemoveListener = OnRemoveListener
UIAllianceStarMainThumbNormalPanel.Refresh = Refresh
return UIAllianceStarMainThumbNormalPanel
