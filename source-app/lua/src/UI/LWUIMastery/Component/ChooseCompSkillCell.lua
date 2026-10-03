local ChooseCompSkillCell = BaseClass("ChooseCompSkillCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local LWUIMasterySkillCell = require("UI.LWUIMastery.Component.LWUIMasterySkillCell")

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.masterySkillCell = self:AddComponent(LWUIMasterySkillCell, "LWUIMasterySkillCell")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClickFunc()
  end)
end

local function ComponentDestroy(self)
  self.masterySkillCell = nil
  self.btn = nil
end

local function DataDefine(self)
  self.masteryTempId = 0
end

local function DataDestroy(self)
  self.masteryTempId = nil
end

local function SetData(self, masteryTempId)
  self.masteryTempId = masteryTempId
  self:Refresh()
end

local function Refresh(self)
  local temp = DataCenter.MasteryManager:GetTempById(self.masteryTempId)
  if temp == nil then
    return
  end
  self.masterySkillCell:SetData(temp.mastery_id)
end

local function OnBtnClickFunc(self)
  local temp = DataCenter.MasteryManager:GetTempById(self.masteryTempId)
  local param = {}
  param.masteryId = temp.mastery_id
  param.isShowMaxLvl = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasteryGetSkill, {anim = true}, param)
end

ChooseCompSkillCell.OnCreate = OnCreate
ChooseCompSkillCell.OnDestroy = OnDestroy
ChooseCompSkillCell.ComponentDefine = ComponentDefine
ChooseCompSkillCell.ComponentDestroy = ComponentDestroy
ChooseCompSkillCell.DataDefine = DataDefine
ChooseCompSkillCell.DataDestroy = DataDestroy
ChooseCompSkillCell.SetData = SetData
ChooseCompSkillCell.Refresh = Refresh
ChooseCompSkillCell.OnBtnClickFunc = OnBtnClickFunc
return ChooseCompSkillCell
