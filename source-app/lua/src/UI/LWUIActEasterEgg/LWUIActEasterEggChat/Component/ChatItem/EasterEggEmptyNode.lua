local base = UIBaseContainer
local EasterEggEmptyNode = BaseClass("EasterEggEmptyNode", base)
local M = EasterEggEmptyNode
local Localization = CS.GameEntry.Localization
local defaultHeight = 560

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function M:OnDestroy()
  self:OnRecycleItem()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.emptyText = self:AddComponent(UIText, "Root/Empty/EmptyText")
end

function M:ComponentDestroy()
  self.emptyText = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
end

function M:OnRecycleItem()
end

function M:UpdateItem(chatData, index)
  self._chatData = chatData
  self.index = index
  local eggInfo = self.view:GetEggInfo()
  if eggInfo == nil then
    Logger.LogError("\229\164\141\230\180\187\232\138\130\226\128\148\226\128\148\226\128\148\226\128\148\231\130\185\229\135\187\229\143\145\233\128\129\232\175\132\232\174\186\230\151\182\239\188\140\228\184\187\231\149\140\233\157\162eggInfo\228\184\186\231\169\186\239\188\129")
    return
  end
  local tipText = ""
  if eggInfo:GetEggType() == ActEasterEggType.Gathering then
    tipText = Localization:GetString("activity_99144_ui_62")
  elseif eggInfo:GetEggType() == ActEasterEggType.Vote then
    if eggInfo:GetMyVoteRes() == 0 then
      tipText = Localization:GetString("activity_99144_ui_63")
    else
      tipText = Localization:GetString("activity_99144_ui_64")
    end
  end
  self.emptyText:SetText(tipText or "")
  local finalHeight = defaultHeight
  local firstItem = self._contentViewScript._scrollView:GetShownItemByIndex(0)
  if IsNotNull(firstItem) then
    local firstItemHeight = firstItem.ItemSize
    local viewPortHeight = self._contentViewScript:GetViewPortHeight()
    local remainHeight = viewPortHeight - firstItemHeight
    if remainHeight > defaultHeight then
      finalHeight = remainHeight
    end
  end
  self:SetSizeDeltaY(finalHeight)
  self._contentViewScript._scrollView:OnItemSizeChanged(self.index)
end

function M:SetContentViewScript(chatMainView)
  self._contentViewScript = chatMainView
end

return M
