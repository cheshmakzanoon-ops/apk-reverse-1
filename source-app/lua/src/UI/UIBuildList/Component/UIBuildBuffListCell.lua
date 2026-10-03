local UIBuildBuffListCell = BaseClass("UIBuildBuffListCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local btn_path = "BuffList_Btn"
local name_text_path = "BuffList_Name"
local value_text_path = "BuffList_Value"

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
  self.btn = self:AddComponent(UIButton, btn_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.value_text = self:AddComponent(UIText, value_text_path)
  self.btn:SetOnClick(function()
    self:InfoClick()
  end)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, data)
  self.data = data
  self:RefreshView()
end

local function RefreshView(self)
  self.name_text:SetText(self.data.name)
  self.value_text:SetText(self.data.num)
end

local function InfoClick(self)
  self.view:SetBuffDetailActive(self.data.type, self.btn.transform.position)
end

UIBuildBuffListCell.OnCreate = OnCreate
UIBuildBuffListCell.OnDestroy = OnDestroy
UIBuildBuffListCell.OnEnable = OnEnable
UIBuildBuffListCell.OnDisable = OnDisable
UIBuildBuffListCell.ComponentDefine = ComponentDefine
UIBuildBuffListCell.ComponentDestroy = ComponentDestroy
UIBuildBuffListCell.DataDefine = DataDefine
UIBuildBuffListCell.DataDestroy = DataDestroy
UIBuildBuffListCell.SetData = SetData
UIBuildBuffListCell.RefreshView = RefreshView
UIBuildBuffListCell.InfoClick = InfoClick
return UIBuildBuffListCell
