local MainBuildingContent = BaseClass("MainBuildingContent", UIBaseContainer)
local base = UIBaseContainer
local MainBuildingContentSlotItem = require("UI.LWUIBuildDetails.Component.MainBuildingContentSlotItem")
local slot_scroll_content_path = "SlotContent/ScrollView/Viewport/SlotScrollContent"
local slot_item_path = "SlotContent/ScrollView/Viewport/SlotScrollContent/SlotItem"
local soltItemNum = 2

function MainBuildingContent:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function MainBuildingContent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MainBuildingContent:DataDefine()
  self.curBuildIndex = nil
  self.curBuildData = nil
  self.buildCurLevelTemplate = nil
end

function MainBuildingContent:DataDestroy()
  self.curBuildIndex = nil
  self.curBuildData = nil
  self.buildCurLevelTemplate = nil
end

function MainBuildingContent:ComponentDefine()
  self.slot_scroll_content = self:AddComponent(UIBaseContainer, slot_scroll_content_path)
  self.soltItems = {}
  for i = 1, soltItemNum do
    local soltItem = self:AddComponent(MainBuildingContentSlotItem, slot_item_path .. i)
    self.soltItems[i] = soltItem
  end
end

function MainBuildingContent:ComponentDestroy()
  self.slot_scroll_content = nil
  self.soltItems = nil
end

function MainBuildingContent:ReInit(curBuildIndex, curBuildData, buildCurLevelTemplate)
  self.curBuildIndex = curBuildIndex
  self.curBuildData = curBuildData
  self.buildCurLevelTemplate = buildCurLevelTemplate
  self.slot_scroll_content:SetAnchoredPositionXY(0, 0)
  local allWorkersForBuild = DataCenter.WorkerTemplateManager:GetAllWorkerForBuild(curBuildData.itemId)
  for i = 1, soltItemNum do
    local soltItem = self.soltItems[i]
    if soltItem then
      soltItem:SetActive(true)
      local workerTemp = allWorkersForBuild[i]
      soltItem:ReInit(i, workerTemp, self.curBuildIndex, self.curBuildData, self.buildCurLevelTemplate)
    else
      soltItem:SetActive(false)
    end
  end
end

return MainBuildingContent
