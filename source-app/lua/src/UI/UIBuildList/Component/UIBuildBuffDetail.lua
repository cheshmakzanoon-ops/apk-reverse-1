local UIBuildBuffDetail = BaseClass("UIBuildBuffDetail", UIBaseContainer)
local base = UIBaseContainer
local UIBuildBuffDetailCell = require("UI.UIBuildList.Component.UIBuildBuffDetailCell")
local total_title_path = "BuildingBuffIntroAll/BuildingBuffIntroAllName"
local total_value_path = "BuildingBuffIntroAll/BuildingBuffIntroAllValue"
local scroll_view_path = "ScrollView"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.total_title = self:AddComponent(UIText, total_title_path)
  self.total_value = self:AddComponent(UIText, total_value_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.type = nil
end

local function ReInit(self, type, isSeason)
  self.type = type
  self.titleInfo, self.dataList = self.view.ctrl:GetBuffDetailInfoListData(self.type, isSeason)
  self:AddCloseDelayTime()
  self:RefreshView()
end

local function GetCurType(self)
  return self.type
end

local function ResetCurType(self)
  self.type = nil
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self:RemoveCloseDelayTime()
end

local function RefreshView(self)
  self.total_title:SetText(self.titleInfo.name)
  self.total_value:SetText(self.titleInfo.value)
  self:ShowCells()
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIBuildBuffDetailCell)
end

local function ShowCells(self)
  self:ClearScroll()
  local count = table.count(self.dataList)
  if 0 < count then
    self.scroll_view:SetTotalCount(count)
    self.scroll_view:RefillCells()
  end
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local item = self.scroll_view:AddComponent(UIBuildBuffDetailCell, itemObj)
  local data = self.dataList[index]
  item:SetData(data)
end

local function OnDeleteCell(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UIBuildBuffDetailCell)
end

local function AddCloseDelayTime(self)
  self:RemoveCloseDelayTime()
  self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.view:HideBuffDetail()
    self:RemoveCloseDelayTime()
  end, 5.0)
end

local function RemoveCloseDelayTime(self)
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

UIBuildBuffDetail.ClearScroll = ClearScroll
UIBuildBuffDetail.OnCreateCell = OnCreateCell
UIBuildBuffDetail.OnDeleteCell = OnDeleteCell
UIBuildBuffDetail.RefreshView = RefreshView
UIBuildBuffDetail.OnCreate = OnCreate
UIBuildBuffDetail.OnDestroy = OnDestroy
UIBuildBuffDetail.ComponentDefine = ComponentDefine
UIBuildBuffDetail.ComponentDestroy = ComponentDestroy
UIBuildBuffDetail.ReInit = ReInit
UIBuildBuffDetail.ShowCells = ShowCells
UIBuildBuffDetail.GetCurType = GetCurType
UIBuildBuffDetail.AddCloseDelayTime = AddCloseDelayTime
UIBuildBuffDetail.RemoveCloseDelayTime = RemoveCloseDelayTime
UIBuildBuffDetail.ResetCurType = ResetCurType
return UIBuildBuffDetail
