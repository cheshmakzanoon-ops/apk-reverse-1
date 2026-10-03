local UIBuildQueueUnlockCell = BaseClass("UIBuildQueueUnlockCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Param = DataClass("Param", ParamData)
local ParamData = {
  index,
  buildId,
  level,
  unlockType
}
local unlock_des_text_path = "UnlockDesText"
local goto_btn_path = "MoneyButton"
local goto_btn_name_path = "MoneyButton/btnTxt_yellow_big_new"
local icon_path = "UIbuild_icon_clock"

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
  self.unlock_des_text = self:AddComponent(UIText, unlock_des_text_path)
  self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
  self.goto_btn_name = self:AddComponent(UIText, goto_btn_name_path)
  self.goto_btn_name_shadow = self:AddComponent(UIShadow, goto_btn_name_path)
  self.unlock_des_text:SetLocalText(135215)
end

local function ComponentDestroy(self)
  self.unlock_des_text = nil
  self.goto_btn = nil
  self.goto_btn_name = nil
  self.goto_btn_name_shadow = nil
  self.icon = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
end

local function OnBtnClick(self)
end

local function SetState(self, isCanBuy)
end

UIBuildQueueUnlockCell.OnCreate = OnCreate
UIBuildQueueUnlockCell.OnDestroy = OnDestroy
UIBuildQueueUnlockCell.Param = Param
UIBuildQueueUnlockCell.OnEnable = OnEnable
UIBuildQueueUnlockCell.OnDisable = OnDisable
UIBuildQueueUnlockCell.ComponentDefine = ComponentDefine
UIBuildQueueUnlockCell.ComponentDestroy = ComponentDestroy
UIBuildQueueUnlockCell.DataDefine = DataDefine
UIBuildQueueUnlockCell.DataDestroy = DataDestroy
UIBuildQueueUnlockCell.ReInit = ReInit
UIBuildQueueUnlockCell.OnBtnClick = OnBtnClick
UIBuildQueueUnlockCell.SetState = SetState
return UIBuildQueueUnlockCell
