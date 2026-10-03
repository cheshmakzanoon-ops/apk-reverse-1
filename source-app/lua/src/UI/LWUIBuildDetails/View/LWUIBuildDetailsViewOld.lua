local LWUIBuildDetailsView = BaseClass("LWUIBuildDetailsView", UIBaseView)
local BuildPropertyItem = require("UI.LWUIBuildDetails.Component.BuildPropertyItem")
local BuildDispatchingWorkerItem = require("UI.LWUIBuildDetails.Component.BuildDispatchingWorkerItem")
local base = UIBaseView

function LWUIBuildDetailsView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

function LWUIBuildDetailsView:DataDefine()
  self.curBuildIndex = nil
  self.curBuildData = nil
  self.buildCurLevelTemplate = nil
end

function LWUIBuildDetailsView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BuildingHeroDispatching, self.Refresh)
  self:AddUIListener(EventId.UpdateBuildEffect, self.RefreshPropertys)
end

function LWUIBuildDetailsView:OnRemoveListener()
  self:RemoveUIListener(EventId.BuildingHeroDispatching, self.Refresh)
  self:RemoveUIListener(EventId.UpdateBuildEffect, self.RefreshPropertys)
  base.OnRemoveListener(self)
end

function LWUIBuildDetailsView:ComponentDefine()
  self.buildIcon = self:AddComponent(UIImage, "panel/buildInfo/buildIcon")
  self.titleText = self:AddComponent(UIText, "panel/buildInfo/infoText/titleText")
  self.curLevelText = self:AddComponent(UIText, "panel/buildInfo/infoText/CurLevelText")
  self.propertys = self:AddComponent(UIBaseContainer, "panel/buildInfo/Propertys")
  self.closeBtn = self:AddComponent(UIButton, "panel/CloseBtn")
  self.workerListPlane = self:AddComponent(UIBaseContainer, "panel/WorkerListBG")
  self.planeBtn = self:AddComponent(UIButton, "PanelBtn")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.planeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

function LWUIBuildDetailsView:ReInit()
  self.curBuildIndex = tonumber(self:GetUserData())
  self.curBuildData = DataCenter.BuildManager:GetBuildingDataByPointId(self.curBuildIndex)
  self.buildCurLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.curBuildData.itemId, self.curBuildData.level)
  self.titleText:SetLocalText(self.buildCurLevelTemplate.name)
  self.buildIcon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(self.curBuildData.itemId, self.curBuildData.level))
  self.curLevelText:SetLocalText(GameDialogDefine.LEVEL_NUMBER, self.curBuildData.level)
  self:RefreshBuildPropertys()
  self:RefreshWorkerList()
end

function LWUIBuildDetailsView:RefreshPropertys(bUuid)
  if bUuid == self.curBuildData.uuid then
    self:RefreshBuildPropertys()
  end
end

function LWUIBuildDetailsView:Refresh()
  self:RefreshBuildPropertys()
  self:RefreshWorkerList()
end

function LWUIBuildDetailsView:RefreshBuildPropertys()
  local list = BuildingUtils.GetBuildingPropertyDataList(self.curBuildData)
  local item
  local param = {}
  local com
  for i = 1, 3 do
    item = self.propertys.transform:GetChild(i - 1)
    if item then
      if list and list[i] and list[i] ~= "" then
        item.gameObject:SetActive(true)
        com = self:GetComponent(item.gameObject.name, BuildPropertyItem)
        item = com and com or self:AddComponent(BuildPropertyItem, item.gameObject)
        param.property = list[i]
        param.buildData = self.curBuildData
        item:ReInit(param)
      else
        item.gameObject:SetActive(false)
      end
    end
  end
end

function LWUIBuildDetailsView:RefreshWorkerList()
  local item, param
  local workerList = self.ctrl:GetTrenchDataList(self.curBuildIndex)
  local com
  for i = 1, 4 do
    item = self.workerListPlane.transform:GetChild(i - 1)
    if item then
      if workerList[i] then
        com = nil
        item:GetChild(0).gameObject:SetActive(true)
        com = self:GetComponent(item.gameObject.name, BuildDispatchingWorkerItem)
        item = com and com or self:AddComponent(BuildDispatchingWorkerItem, item.gameObject)
        param = workerList[i]
        param.index = i
        item:ReInit(param)
      else
        item:GetChild(0).gameObject:SetActive(false)
      end
    end
  end
end

function LWUIBuildDetailsView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIBuildDetailsView:DataDestroy()
  self.curBuildIndex = nil
  self.curBuildData = nil
  self.buildCurLevelTemplate = nil
end

function LWUIBuildDetailsView:ComponentDestroy()
  self.workerIconImg = nil
  self.titleText = nil
  self.curLevelText = nil
  self.propertys = nil
  self.closeBtn = nil
  self.workerListPlane = nil
  self.planeBtn = nil
  DataCenter.ArrowManager:RemoveFingerArrow()
end

return LWUIBuildDetailsView
