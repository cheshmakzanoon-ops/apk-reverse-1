local UICommonScore = require("UI.UICommonScore.UICommonScore")
local UICommonScoreGroup = BaseClass("UICommonScoreGroup", UICommonScore)
local base = UICommonScore
local Localization = CS.GameEntry.Localization

function UICommonScoreGroup:OnCreate()
  base.OnCreate(self)
  self.toggle = self:AddComponent(UIToggle, "bg/Toggle")
  self.toggle:SetIsOn(false)
  self.toggle:SetOnValueChanged(function(value)
    self:OnToggleValueChanged()
    if self.OnClickToggle then
      self.OnClickToggle(value)
    end
  end)
  self.subItemIds = nil
  self.subItems = nil
  self.subItemPrefab = nil
  self.index = 1
end

function UICommonScoreGroup:OnDestroy()
  self:RemoveComponents(UICommonScore)
  if self.subItems then
    for i, v in ipairs(self.subItems) do
      v:GameObjectRecycle()
    end
  end
  base.OnDestroy(self)
end

function UICommonScoreGroup:RefreshData(cfg)
  base.RefreshData(self, cfg)
  self._require_txt:SetSizeDeltaXY(560, 50)
  self:OnToggleValueChanged()
end

function UICommonScoreGroup:OnToggleValueChanged()
  self.index = 1
  if self.subItems then
    self:RemoveComponents(UICommonScore)
    for i, v in ipairs(self.subItems) do
      v:GameObjectRecycle()
    end
    self.subItems = nil
  end
  if not table.IsNullOrEmpty(self.subItemIds) then
    self.toggle:SetActive(true)
    self._require_txt:SetAnchoredPositionXY(60, 0)
    if self.toggle:GetIsOn() then
      self.subItems = {}
      for i, v in ipairs(self.subItemIds) do
        self:CreateItem(v)
      end
    end
  else
    self.toggle:SetActive(false)
    self._require_txt:SetAnchoredPositionXY(15, 0)
  end
  local height = 60
  if self.subItems then
    height = height + 60 * #self.subItems
  end
  self.rectTransform.sizeDelta = CS.UnityEngine.Vector2(self.rectTransform.sizeDelta.x, height)
end

function UICommonScoreGroup:AddSubItemData(id, subItemPrefab, OnClickToggle)
  if not self.subItemIds then
    self.subItemIds = {}
  end
  table.insert(self.subItemIds, id)
  self.subItemPrefab = subItemPrefab
  self.OnClickToggle = OnClickToggle
end

function UICommonScoreGroup:CreateItem(id)
  if not self.subItemPrefab then
    return
  end
  if not self.subItems then
    self.subItems = {}
  end
  local cfg = LocalController:instance():getLine(TableName.Score, id)
  local theName = "item_" .. self.index
  local goItem = self.subItemPrefab:GameObjectSpawn(self.transform)
  goItem.name = theName
  goItem:SetActive(true)
  local theItem = self:AddComponent(UICommonScore, theName)
  theItem:RefreshData(cfg)
  theItem:SetBg(self.index)
  self.subItems[self.index] = goItem
  self.index = self.index + 1
end

return UICommonScoreGroup
