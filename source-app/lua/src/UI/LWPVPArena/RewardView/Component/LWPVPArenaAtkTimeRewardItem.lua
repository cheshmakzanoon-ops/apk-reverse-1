local LWPVPArenaAtkTimeRewardItem = BaseClass("LWPVPArenaAtkTimeRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function LWPVPArenaAtkTimeRewardItem:ComponentDefine()
  self.rankingTitleText = self:AddComponent(UIText, "RankingTitleText")
  self.rewardScrollContent = self:AddComponent(UIBaseContainer, "RewardScroll/Viewport/Content")
end

function LWPVPArenaAtkTimeRewardItem:ComponentDestroy()
  self.rankingTitleText = nil
  self.rewardScrollContent = nil
end

function LWPVPArenaAtkTimeRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWPVPArenaAtkTimeRewardItem:OnDestroy()
  self:SetAllCellDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWPVPArenaAtkTimeRewardItem:SetAllCellDestroy()
  self.rewardScrollContent:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function LWPVPArenaAtkTimeRewardItem:RefreshReward(list)
  self:SetAllCellDestroy()
  self.showList = DataCenter.RewardManager:ReturnRewardParamForView(list)
  self.model = {}
  if self.showList ~= nil then
    for i = 1, table.length(self.showList) do
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.rewardScrollContent.transform)
        go.transform:Set_localScale(0.78, 0.82, 1)
        go.transform:Set_sizeDelta(91, 97)
        go.transform.pivot = Vector2.New(0.5, 0.5)
        go.name = "item" .. i
        local cell = self.rewardScrollContent:AddComponent(UICommonResItem, go.name)
        cell:ReInit(self.showList[i])
      end)
    end
  end
end

function LWPVPArenaAtkTimeRewardItem:SetData(viewData)
  if not viewData then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.viewData = viewData
  self.rankingTitleText:SetLocalText("500233", self.viewData.times, DataCenter.ActBossDataManager.bossName)
  self:RefreshReward(viewData.reward)
end

return LWPVPArenaAtkTimeRewardItem
