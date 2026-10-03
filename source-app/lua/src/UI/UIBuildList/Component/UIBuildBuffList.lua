local UIBuildBuffList = BaseClass("UIBuildBuffList", UIBaseContainer)
local base = UIBaseContainer
local UIBuildBuffListCell = require("UI.UIBuildList.Component.UIBuildBuffListCell")
local title_path = "BuffTitle/BuffTitleText"
local buff_list_cell_prefix = "BuffList/BuffList_"
local buff_component_prefix = "buff_"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.title_text = self:AddComponent(UIText, title_path)
  self.title_text:SetLocalText(302251)
  self.buffList = {}
  for i = 1, BuildListBuffType.BuildListBuffType_Max - 1 do
    self[buff_component_prefix .. i] = self:AddComponent(UIBuildBuffListCell, buff_list_cell_prefix .. i)
  end
end

local function ReInit(self, isSeasonMode)
  self.dataList = self.view.ctrl:GetBuffListData(isSeasonMode)
  self:RefreshView()
end

local function ComponentDestroy(self)
end

local function RefreshView(self)
  self:SetActive(self.view.ctrl:NeedShowBuffList() and table.count(self.dataList) > 0)
  for i = 1, BuildListBuffType.BuildListBuffType_Max - 1 do
    if self.dataList[i] ~= nil then
      self[buff_component_prefix .. i]:SetData(self.dataList[i])
      self[buff_component_prefix .. i]:SetActive(true)
    else
      self[buff_component_prefix .. i]:SetActive(false)
    end
  end
end

UIBuildBuffList.RefreshView = RefreshView
UIBuildBuffList.OnCreate = OnCreate
UIBuildBuffList.OnDestroy = OnDestroy
UIBuildBuffList.ComponentDefine = ComponentDefine
UIBuildBuffList.ComponentDestroy = ComponentDestroy
UIBuildBuffList.ReInit = ReInit
return UIBuildBuffList
