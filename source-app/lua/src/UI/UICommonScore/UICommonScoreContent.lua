local UICommonScore = require("UI.UICommonScore.UICommonScore")
local UICommonScoreGroup = require("UI.UICommonScore.UICommonScoreGroup")
local UICommonScoreContent = BaseClass("UICommonScoreContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UICommonScoreContent:OnCreate()
  base.OnCreate(self)
  self.scoreItem = self.transform:Find("UICommonScore").gameObject
  self.scoreItem:GameObjectCreatePool()
  self.scoreGroup = self.transform:Find("UICommonScoreGroup").gameObject
  self.scoreGroup:GameObjectCreatePool()
end

function UICommonScoreContent:OnDestroy()
  self:RemoveComponents(UICommonScore)
  self:RemoveComponents(UICommonScoreGroup)
  self.scoreItem:GameObjectRecycleAll()
  self.scoreGroup:GameObjectRecycleAll()
  base.OnDestroy(self)
end

function UICommonScoreContent:RefreshData(scoreIds, ...)
  self.parentRects = {
    ...
  }
  self:SetAnchoredPositionXY(0, 0)
  self:RemoveComponents(UICommonScore)
  self:RemoveComponents(UICommonScoreGroup)
  self.scoreItem:GameObjectRecycleAll()
  self.scoreGroup:GameObjectRecycleAll()
  if not scoreIds then
    return
  end
  self.itemGroup = {}
  local goItem, theItem
  local indexAdd = 0
  for i = 1, table.length(scoreIds) do
    local cfg = LocalController:instance():getLine(TableName.Score, scoreIds[i])
    if cfg then
      local theName = "item_" .. i
      if string.IsNullOrEmpty(cfg.group) then
        goItem = self.scoreGroup:GameObjectSpawn(self.transform)
        goItem.name = theName
        goItem:SetActive(true)
        theItem = self:AddComponent(UICommonScoreGroup, theName)
        theItem:RefreshData(cfg)
        indexAdd = indexAdd + 1
        theItem:SetBg(indexAdd)
        self.itemGroup[cfg.id] = theItem
      end
    end
  end
  
  local function OnClickToggle()
    self:ResetLayout()
  end
  
  for i = 1, table.length(scoreIds) do
    local cfg = LocalController:instance():getLine(TableName.Score, scoreIds[i])
    if cfg then
      local theName = "item_" .. i
      if not string.IsNullOrEmpty(cfg.group) then
        local parentId = cfg.group and tonumber(cfg.group)
        local parent = parentId and self.itemGroup[parentId]
        if parent then
          parent:AddSubItemData(cfg.id, self.scoreItem, OnClickToggle)
        else
          goItem = self.scoreItem:GameObjectSpawn(self.transform)
          goItem.name = theName
          goItem:SetActive(true)
          theItem = self:AddComponent(UICommonScore, theName)
          theItem:RefreshData(cfg)
          indexAdd = indexAdd + 1
          theItem:SetBg(indexAdd)
        end
      end
    end
  end
  for k, v in pairs(self.itemGroup) do
    v:OnToggleValueChanged()
  end
  self:ResetLayout()
end

function UICommonScoreContent:ResetLayout()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
  if self.parentRects then
    for i = 1, table.length(self.parentRects) do
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.parentRects[i])
    end
  end
end

return UICommonScoreContent
