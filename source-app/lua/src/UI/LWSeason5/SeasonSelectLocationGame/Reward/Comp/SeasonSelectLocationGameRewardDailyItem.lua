local SeasonSelectLocationGameRewardDailyItem = BaseClass("SeasonSelectLocationGameRewardDailyItem", UIBaseContainer)
local base = UIBaseContainer

function SeasonSelectLocationGameRewardDailyItem:ComponentDefine()
  self.rankingTitleText = self:AddComponent(UIText, "RankingTitleText")
  self.rewardScrollContent = self:AddComponent(UIBaseContainer, "RewardScroll/Viewport/Content")
  self.p_go_check = self:AddComponent(UIBaseContainer, "p_go_check")
end

function SeasonSelectLocationGameRewardDailyItem:ComponentDestroy()
  self.rankingTitleText = nil
  self.rewardScrollContent = nil
  self.p_go_check = nil
end

function SeasonSelectLocationGameRewardDailyItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function SeasonSelectLocationGameRewardDailyItem:OnDestroy()
  self:SetAllCellDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonSelectLocationGameRewardDailyItem:SetAllCellDestroy()
  self.rewardScrollContent:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function SeasonSelectLocationGameRewardDailyItem:RefreshReward()
  local rewardId = DataCenter.SeasonSelectLocationGameManager:GetTodayRewardId()
  local rewardList = DataCenter.RewardTemplateManager:GetList(rewardId)
  self:SetAllCellDestroy()
  self.model = {}
  if rewardList ~= nil then
    for i = 1, table.length(rewardList) do
      local index = i
      self.model[index] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.rewardScrollContent.transform)
        go.transform:Set_localScale(0.78, 0.82, 1)
        go.transform:Set_sizeDelta(91, 97)
        go.transform.pivot = Vector2.New(0.5, 0.5)
        go.name = "item" .. index
        local cell = self.rewardScrollContent:AddComponent(UICommonResItem, go.name)
        cell:ReInit(rewardList[index])
      end)
    end
  end
end

function SeasonSelectLocationGameRewardDailyItem:SetData()
  self:SetActive(true)
  self.rankingTitleText:SetLocalText("zone_selection_location_UI_39")
  self:RefreshReward()
  local curIndex = DataCenter.SeasonTetrisManager:GetCurLevelIndex()
  self.p_go_check:SetActive(1 < curIndex)
end

return SeasonSelectLocationGameRewardDailyItem
