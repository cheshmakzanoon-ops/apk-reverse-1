local UIFrontBreakSundayRankRewardItem = BaseClass("UIFrontBreakSundayRankRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UIFrontBreakSundayRankRewardItem:ComponentDefine()
  self.rankingTitleBg = self:AddComponent(UIImage, "RankingTitleBg")
  self.bg = self:AddComponent(UIImage, "Bg")
  self.rankingTitleText = self:AddComponent(UIText, "RankingTitleBg/RankingTitleText")
  self.rankingSpanText = self:AddComponent(UIText, "RankingSpan")
  self.rewardScrollContent = self:AddComponent(UIBaseContainer, "RewardScroll/Viewport/Content")
end

function UIFrontBreakSundayRankRewardItem:ComponentDestroy()
  self.rankingTitleBg = nil
  self.rankingTitleText = nil
  self.rewardScrollContent = nil
end

function UIFrontBreakSundayRankRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIFrontBreakSundayRankRewardItem:OnDestroy()
  self:SetAllCellDestroy()
  self:ComponentDestroy()
  self.rewardsDataList = nil
  base.OnDestroy(self)
end

function UIFrontBreakSundayRankRewardItem:SetAllCellDestroy()
  self.rewardScrollContent:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function UIFrontBreakSundayRankRewardItem:RefreshReward(rewards)
  self:SetAllCellDestroy()
  self.rewardsDataList = rewards
  self.model = {}
  if self.rewardsDataList ~= nil then
    for i = 1, table.length(self.rewardsDataList) do
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.rewardScrollContent.transform)
        go.transform:Set_localScale(0.78, 0.82, 1)
        go.transform:Set_sizeDelta(91, 97)
        go.transform.pivot = Vector2.New(0.5, 0.5)
        go.name = "item" .. i
        local cell = self.rewardScrollContent:AddComponent(UICommonResItem, go.name)
        cell:ReInit(self.rewardsDataList[i])
      end)
    end
  end
end

function UIFrontBreakSundayRankRewardItem:SetData(itemData)
  if not itemData then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.itemData = itemData
  self.rankingTitleText:SetText(itemData.rankLow)
  if itemData.rankLow == 1 then
    self.rankingTitleBg:SetActive(true)
    self.rankingSpanText:SetActive(false)
    self.rankingTitleBg:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_1.png")
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_1.png")
  elseif itemData.rankLow == 2 then
    self.rankingTitleBg:SetActive(true)
    self.rankingSpanText:SetActive(false)
    self.rankingTitleBg:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_2.png")
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_2.png")
  elseif itemData.rankLow == 3 then
    self.rankingTitleBg:SetActive(true)
    self.rankingSpanText:SetActive(false)
    self.rankingTitleBg:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_3.png")
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_3.png")
  else
    self.rankingTitleBg:SetActive(false)
    self.rankingSpanText:SetActive(true)
    self.rankingSpanText:SetText(string.format("%d~%d", itemData.rankLow, itemData.rankHigh))
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_4.png")
  end
  local reward = DataCenter.RewardManager:ReturnRewardParamForMessage(itemData.reward)
  self:RefreshReward(reward)
end

return UIFrontBreakSundayRankRewardItem
