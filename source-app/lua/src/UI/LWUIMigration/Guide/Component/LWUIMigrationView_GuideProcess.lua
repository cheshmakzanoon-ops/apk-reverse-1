local LWUIMigrationView_GuideProcess = BaseClass("LWUIMigrationView_GuideProcess", UIBaseContainer)
local base = UIScrollRect
local ProcessItem = require("UI.LWUIMigration.Guide.Component.LWUIMigrationView_GuideProcessItem")
local content_path = "Viewport/content"
local progress_bg_path = "Viewport/content/progressBg"
local progress_img_path = "Viewport/content/progressBg/progressImg"
local item_content_path = "Viewport/content/itemContent"
local item_path = "Item"
local BASE_H = 275

function LWUIMigrationView_GuideProcess:OnCreate()
  base.OnCreate(self)
  self.itemList = {}
  self.scroll_rect = self:AddComponent(UIScrollRect, "")
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.content:SetAnchoredPositionXY(0, 0)
  self.progress_bg = self:AddComponent(UIImage, progress_bg_path)
  self.progress_img = self:AddComponent(UIImage, progress_img_path)
  self.item_content = self:AddComponent(UIBaseContainer, item_content_path)
  self.theItem = self.transform:Find(item_path).gameObject
  self.theItem:GameObjectCreatePool()
end

function LWUIMigrationView_GuideProcess:OnDestroy()
  self:ClearAllItem()
  base.OnDestroy(self)
end

function LWUIMigrationView_GuideProcess:ClearAllItem()
  self.item_content:RemoveComponents(ProcessItem)
  if self.itemList then
    for _, v in ipairs(self.itemList) do
      if v ~= nil then
        CS.UnityEngine.GameObject.Destroy(v.gameObject)
      end
    end
  end
  self.theItem:GameObjectRecycleAll()
  self.theItem = nil
  self.itemList = {}
end

function LWUIMigrationView_GuideProcess:SetData()
  local _, stageInfo = DataCenter.ActMigrationManager:GetCurStageInfo()
  local guideList = DataCenter.ActMigrationManager:GetGuideConfig(2)
  local maxStage = #guideList
  local curStage = maxStage
  for i, guideData in ipairs(guideList) do
    local item = self.itemList[i]
    if item == nil then
      local obj = self.theItem:GameObjectSpawn(self.item_content.transform)
      obj.name = i
      item = self.item_content:AddComponent(ProcessItem, obj.name)
      item:SetActive(true)
      self.itemList[i] = item
    end
    if stageInfo.state == guideData.state then
      curStage = i
    end
    item:SetData(guideData, i, curStage)
    item:SetActive(true)
  end
  self.progress_bg:SetAnchoredPositionXY(22, -30)
  self.progress_bg:SetSizeDeltaXY(37, BASE_H * (maxStage - 1))
  self.progress_img:SetSizeDeltaXY(37, BASE_H * (curStage - 1))
  self.scroll_rect:SetVerticalNormalizedPosition(1)
end

return LWUIMigrationView_GuideProcess
