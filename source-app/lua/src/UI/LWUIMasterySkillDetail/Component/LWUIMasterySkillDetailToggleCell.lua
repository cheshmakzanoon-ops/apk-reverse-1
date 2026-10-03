local LWUIMasterySkillDetailToggleCell = BaseClass("LWUIMasterySkillDetailToggleCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local btn_path = ""
local beSelect_path = "beSelect"

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
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnBtnClickFunc()
  end)
  self.beSelect = self:AddComponent(UIBaseContainer, beSelect_path)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.beSelect = nil
end

local function DataDefine(self)
  self.index = nil
  self.beSelectIndex = nil
  self.callBack = nil
end

local function DataDestroy(self)
  self.index = nil
  self.beSelectIndex = nil
  self.callBack = nil
end

local function SetData(self, index, beSelectIndex, callBack)
  self.index = index
  self.beSelectIndex = beSelectIndex
  self.callBack = callBack
  self:Refresh()
end

local function SetBeSelectData(self, beSelectIndex)
  self.beSelectIndex = beSelectIndex
  self:Refresh()
end

local function Refresh(self)
  self.beSelect:SetActive(self.index == self.beSelectIndex)
end

local function OnBtnClickFunc(self)
  if self.callBack then
    self.callBack(self.index)
  end
end

LWUIMasterySkillDetailToggleCell.OnCreate = OnCreate
LWUIMasterySkillDetailToggleCell.OnDestroy = OnDestroy
LWUIMasterySkillDetailToggleCell.ComponentDefine = ComponentDefine
LWUIMasterySkillDetailToggleCell.ComponentDestroy = ComponentDestroy
LWUIMasterySkillDetailToggleCell.DataDefine = DataDefine
LWUIMasterySkillDetailToggleCell.DataDestroy = DataDestroy
LWUIMasterySkillDetailToggleCell.SetData = SetData
LWUIMasterySkillDetailToggleCell.SetBeSelectData = SetBeSelectData
LWUIMasterySkillDetailToggleCell.Refresh = Refresh
LWUIMasterySkillDetailToggleCell.OnBtnClickFunc = OnBtnClickFunc
return LWUIMasterySkillDetailToggleCell
