local UIAllianceStarMainPersonAwardPanel = BaseClass("UIAllianceStarMainPersonAwardPanel", UIBaseContainer)
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
  self.textTitle = self:AddComponent(UIText, "TitleText")
  self.compUIPlayerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.compUIPlayerHead:SetEnableClickShowInfo(true, true)
  self.textName = self:AddComponent(UIText, "NameText")
  self.anim = self:AddComponent(UISimpleAnimation, "")
  self.textTip = self:AddComponent(UIText, "TipText")
end

local function ComponentDestroy(self)
  self.textTitle = nil
  self.compUIPlayerHead = nil
  self.textName = nil
  self.anim = nil
  self.textTip = nil
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

local function Refresh(self, param)
  self.textTitle:SetText(param.tipText)
  self.textTip:SetText(param.dialogText)
  if param.playerInfo then
    self.textName:SetText(param.playerInfo.name)
    self.compUIPlayerHead:ParseHeadInfo(param.playerInfo)
  end
  if param.showAnim then
    self.anim:SampleAnimationAtTime("in", 0)
    self.anim:Play("in")
  elseif param.showAnim == false then
    self.anim:SampleAnimationAtTime("in", 1)
  else
    self.anim:SampleAnimationAtTime("in", 1)
  end
end

UIAllianceStarMainPersonAwardPanel.OnCreate = OnCreate
UIAllianceStarMainPersonAwardPanel.OnDestroy = OnDestroy
UIAllianceStarMainPersonAwardPanel.OnEnable = OnEnable
UIAllianceStarMainPersonAwardPanel.OnDisable = OnDisable
UIAllianceStarMainPersonAwardPanel.ComponentDefine = ComponentDefine
UIAllianceStarMainPersonAwardPanel.ComponentDestroy = ComponentDestroy
UIAllianceStarMainPersonAwardPanel.DataDefine = DataDefine
UIAllianceStarMainPersonAwardPanel.DataDestroy = DataDestroy
UIAllianceStarMainPersonAwardPanel.OnAddListener = OnAddListener
UIAllianceStarMainPersonAwardPanel.OnRemoveListener = OnRemoveListener
UIAllianceStarMainPersonAwardPanel.Refresh = Refresh
return UIAllianceStarMainPersonAwardPanel
