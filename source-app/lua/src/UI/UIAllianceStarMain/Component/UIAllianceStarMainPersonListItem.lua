local UIAllianceStarMainPersonListItem = BaseClass("UIAllianceStarMainPersonListItem", UIBaseContainer)
local UIHeadIconShowPage = require("UI.UIHeadIconShow.Component.UIHeadIconShowPage")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

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
  self.bigIcon = self:AddComponent(UIHeadIconShowPage, "BigIcon")
  self.playerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.anim = self:AddComponent(UIAnimator, "")
end

local function ComponentDestroy(self)
  self.bigIcon = nil
  self.playerHead = nil
end

local function DataDefine(self)
  self.anim:Play("V_ui_UIAllianceStarMainPersonItem_idle")
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, playerData)
  if playerData.picVer == nil then
    playerData.picVer = playerData.picver or 0
  end
  self.playerData = playerData
  self.bigIcon:SetData(playerData)
  self.bigIcon:ShowHeadIcon()
  self.playerHead:ParseHeadInfo(playerData)
end

local function PlayStarAnim(self, starPlayerInfo, normalizedTime)
  local playerHead, time, state
  if self.playerData then
    if self.playerData.uid == starPlayerInfo.uid then
      state, time = self.anim:PlayAnimationReturnTime("V_ui_UIAllianceStarMainPersonItem_reward", nil, normalizedTime)
      playerHead = self.playerHead
    else
      self.anim:PlayAnimationReturnTime("V_ui_UIAllianceStarMainPersonItem_out", nil, normalizedTime)
    end
  end
  return playerHead, time
end

UIAllianceStarMainPersonListItem.OnCreate = OnCreate
UIAllianceStarMainPersonListItem.OnDestroy = OnDestroy
UIAllianceStarMainPersonListItem.OnEnable = OnEnable
UIAllianceStarMainPersonListItem.OnDisable = OnDisable
UIAllianceStarMainPersonListItem.ComponentDefine = ComponentDefine
UIAllianceStarMainPersonListItem.ComponentDestroy = ComponentDestroy
UIAllianceStarMainPersonListItem.DataDefine = DataDefine
UIAllianceStarMainPersonListItem.DataDestroy = DataDestroy
UIAllianceStarMainPersonListItem.OnAddListener = OnAddListener
UIAllianceStarMainPersonListItem.OnRemoveListener = OnRemoveListener
UIAllianceStarMainPersonListItem.SetData = SetData
UIAllianceStarMainPersonListItem.PlayStarAnim = PlayStarAnim
return UIAllianceStarMainPersonListItem
