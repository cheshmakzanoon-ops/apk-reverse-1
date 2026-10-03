local S6MilitaryRewardItem = BaseClass("S6MilitaryRewardItem", UIBaseContainer)
local base = UIBaseContainer

function S6MilitaryRewardItem:ComponentDefine()
  self.rankingTitleBg = self:AddComponent(UIImage, "RankingTitleBg")
  self.rankingTitleText = self:AddComponent(UIText, "RankingTitleBg/RankingTitleText")
  self.rewardScrollContent = self:AddComponent(UIBaseContainer, "RewardScroll/Viewport/Content")
  self.reward_scroll = self:AddComponent(UIScrollRect, "RewardScroll")
end

function S6MilitaryRewardItem:ComponentDestroy()
  self.reward_scroll = nil
  self.rankingTitleBg = nil
  self.rankingTitleText = nil
  self.rewardScrollContent = nil
end

function S6MilitaryRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function S6MilitaryRewardItem:OnDestroy()
  self:SetAllCellDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function S6MilitaryRewardItem:SetAllCellDestroy()
  self.rewardScrollContent:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function S6MilitaryRewardItem:RefreshReward(list)
  self:SetAllCellDestroy()
  self.showList = list
  self.model = {}
  local theItemList = {}
  local sortOrder = -1
  for k, v in pairs(list) do
    if v.itemId ~= nil and v.rewardType == RewardType.GOODS then
      local meta = DataCenter.ItemTemplateManager:TryGetItemTemplate(v.itemId)
      if meta ~= nil and meta.color then
        v.sortOrder = toInt(meta.color)
      else
        v.sortOrder = sortOrder
      end
    elseif v.itemId ~= nil and v.rewardType == RewardType.RESOURCE_ITEM then
      local meta = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(v.itemId)
      if meta ~= nil and meta.quality then
        v.sortOrder = toInt(meta.quality)
      else
        v.sortOrder = sortOrder
      end
    else
      v.sortOrder = sortOrder
    end
    table.insert(theItemList, v)
    sortOrder = sortOrder - 1
  end
  table.sort(theItemList, function(a, b)
    if a.sortOrder == b.sortOrder then
      return a.rewardType > b.rewardType
    end
    return a.sortOrder > b.sortOrder
  end)
  local count = #theItemList
  if self.reward_scroll ~= nil then
    self.reward_scroll:SetEnable(6 < count)
  end
  if 6 < count then
    self.rewardScrollContent:SetPivotXY(0, 0.5)
    self.rewardScrollContent:SetAnchorMinXY(0, 0.5)
    self.rewardScrollContent:SetAnchorMaxXY(0, 0.5)
  else
    self.rewardScrollContent:SetPivotXY(0.5, 0.5)
    self.rewardScrollContent:SetAnchorMinXY(0.5, 0.5)
    self.rewardScrollContent:SetAnchorMaxXY(0.5, 0.5)
  end
  self.rewardScrollContent:SetLocalPositionXYZ(0, 0, 0)
  self.rewardScrollContent:SetSizeDeltaXY(count * 110, 130)
  for i = 1, count do
    self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.rewardScrollContent.transform)
      go.transform:Set_localScale(0.78, 0.82, 1)
      go.transform:Set_sizeDelta(117, 97)
      go.transform.pivot = Vector2.New(0.5, 0.5)
      go.name = "item" .. UIUtil.GetLoopListItemIndex()
      local cell = self.rewardScrollContent:AddComponent(UICommonResItem, go.name)
      cell:ReInit(theItemList[i])
    end)
  end
end

function S6MilitaryRewardItem:ReInit(viewData)
  if not viewData then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.viewData = viewData
  self.rankingTitleText:SetText(viewData.title)
  local maxLevel = DataCenter.SeasonMilitaryManager:GetMaxLevel()
  local fixedLevel = Mathf.Clamp(maxLevel - viewData.level, 0, 3) + 1
  self.rankingTitleBg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_jiangli_%d.png", fixedLevel))
  self:RefreshReward(viewData.rewards)
end

return S6MilitaryRewardItem
