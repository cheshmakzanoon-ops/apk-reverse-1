local UIAllianceStarMainJumpPanel = BaseClass("UIAllianceStarMainJumpPanel", UIBaseContainer)
local base = UIBaseContainer

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.jumpBtn = self:AddComponent(UIButton, "JumpBtn")
  self.jumpBtnText = self:AddComponent(UIText, "JumpBtn/JumpBtnText")
  self.jumpBtn:SetOnClick(function()
    DataCenter.AllianceStarManager:ChangeCurStageInnerStage(AlStarCeremonyInnerState[AlStarCeremonyState.ReadPersonReward].State5)
  end)
  self.jumpBtnText:SetLocalText("alliance_weeklyStar_btn_skip")
end

local function ComponentDestroy(self)
  self.jumpBtn = nil
  self.jumpBtnText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

UIAllianceStarMainJumpPanel.OnCreate = OnCreate
UIAllianceStarMainJumpPanel.OnDestroy = OnDestroy
UIAllianceStarMainJumpPanel.OnEnable = OnEnable
UIAllianceStarMainJumpPanel.OnDisable = OnDisable
UIAllianceStarMainJumpPanel.ComponentDefine = ComponentDefine
UIAllianceStarMainJumpPanel.ComponentDestroy = ComponentDestroy
UIAllianceStarMainJumpPanel.DataDefine = DataDefine
UIAllianceStarMainJumpPanel.DataDestroy = DataDestroy
UIAllianceStarMainJumpPanel.OnAddListener = OnAddListener
UIAllianceStarMainJumpPanel.OnRemoveListener = OnRemoveListener
return UIAllianceStarMainJumpPanel
