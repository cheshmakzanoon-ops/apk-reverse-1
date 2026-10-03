local UIBuildingWorkerInfoCell = BaseClass("UIBuildingWorkerInfoCell", UIBaseContainer)
local base = UIBaseContainer
local UIWorkerShowCell = require("UI.UILWWorker.UIWorkerOverviewList.Component.UIWorkerShowCell")
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray
local soltShowCount = 4

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
  self.showData = nil
end

local function DataDestroy(self)
  self.showData = nil
end

local function ComponentDefine(self)
  self.buildingIcon = self:AddComponent(UIImage, "buildingIcon")
  self.infoTxt = self:AddComponent(UIText, "infoTxt")
  self.soltItems = {}
  for i = 1, soltShowCount do
    local soltItem = self:AddComponent(UIButton, "soltContent/soltItem" .. i)
    soltItem:SetOnClick(function()
      self:ClickSoltItem(i)
    end)
    self.soltItems[i] = {
      root = soltItem,
      uiWorkerShowCell = soltItem:AddComponent(UIWorkerShowCell, "UIWorkerShowCell"),
      uiEmptyCell = soltItem:AddComponent(UIBaseContainer, "UIEmptyCell"),
      redPoint = soltItem:AddComponent(UIBaseContainer, "redPoint")
    }
  end
end

local function ComponentDestroy(self)
  self.buildingIcon = nil
  self.infoTxt = nil
  self.soltItems = nil
end

local function SetData(self, showData)
  self.showData = showData
  self.buildingIcon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(self.showData.data.itemId, 1))
  local lvTxt = Localization:GetString(GameDialogDefine.LEVEL_NUMBER, self.showData.data.level)
  local buildingName = Localization:GetString(self.showData.oneTemp.name)
  self.infoTxt:SetText(string.format("%s %s", lvTxt, buildingName))
  for i = 1, soltShowCount do
    local data = self.showData.trenchDataList[i]
    local soltItem = self.soltItems[i]
    if data == nil then
      soltItem.root:SetActive(false)
    elseif data.type == BuildDisPatchingHeroTrenchState.LOCK then
      soltItem.root:SetActive(false)
    elseif data.type == BuildDisPatchingHeroTrenchState.ADD then
      soltItem.root:SetActive(true)
      soltItem.uiWorkerShowCell:SetActive(false)
      soltItem.uiEmptyCell:SetActive(true)
      local isOn = self.showData.data:CheckBuildingWorkerSlotRedDot(i)
      soltItem.redPoint:SetActive(isOn)
    elseif data.type == BuildDisPatchingHeroTrenchState.HERO then
      soltItem.root:SetActive(true)
      soltItem.uiWorkerShowCell:SetActive(true)
      soltItem.uiEmptyCell:SetActive(false)
      soltItem.uiWorkerShowCell:SetData(data.workerData.cfgId, data.workerData.rank)
      local isOn = self.showData.data:CheckBuildingWorkerSlotRedDot(i)
      soltItem.redPoint:SetActive(isOn)
    end
  end
end

local function ClickSoltItem(self, index)
  local data = self.showData.trenchDataList[index]
  if data == nil then
    return
  end
  UIUtil.OpenLWUIBuildDetailsView(tostring(self.showData.data.pointId))
end

UIBuildingWorkerInfoCell.OnCreate = OnCreate
UIBuildingWorkerInfoCell.OnDestroy = OnDestroy
UIBuildingWorkerInfoCell.DataDefine = DataDefine
UIBuildingWorkerInfoCell.DataDestroy = DataDestroy
UIBuildingWorkerInfoCell.ComponentDefine = ComponentDefine
UIBuildingWorkerInfoCell.ComponentDestroy = ComponentDestroy
UIBuildingWorkerInfoCell.SetData = SetData
UIBuildingWorkerInfoCell.ClickSoltItem = ClickSoltItem
return UIBuildingWorkerInfoCell
