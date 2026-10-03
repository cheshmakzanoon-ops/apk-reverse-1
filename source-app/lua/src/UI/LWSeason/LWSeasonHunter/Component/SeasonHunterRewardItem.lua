local SeasonHunterRewardItem = BaseClass("SeasonHunterRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function SeasonHunterRewardItem:ComponentDefine()
  self.rankingTitleBg = self:AddComponent(UIImage, "RankingTitleBg")
  self.rankingTitleText = self:AddComponent(UIText, "RankingTitleBg/RankingTitleText")
  self.rewardScrollContent = self:AddComponent(UIBaseContainer, "RewardScroll/Viewport/Content")
end

function SeasonHunterRewardItem:ComponentDestroy()
  self.rankingTitleBg = nil
  self.rankingTitleText = nil
  self.rewardScrollContent = nil
end

function SeasonHunterRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function SeasonHunterRewardItem:OnDestroy()
  self:SetAllCellDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonHunterRewardItem:SetAllCellDestroy()
  self.rewardScrollContent:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function SeasonHunterRewardItem:RefreshReward(list)
  self:SetAllCellDestroy()
  self.showList = list
  self.model = {}
  if self.showList ~= nil then
    local contentTrans = self.rewardScrollContent.transform
    for i, v in ipairs(list) do
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        local trans = go.transform
        trans:SetParent(contentTrans)
        trans:Set_localScale(0.78, 0.82, 1)
        trans:Set_sizeDelta(91, 97)
        trans.pivot = Vector2.New(0.5, 0.5)
        go.name = "item" .. i
        local cell = self.rewardScrollContent:AddComponent(UICommonResItem, go.name)
        cell:ReInit(list[i])
      end)
    end
  end
end

function SeasonHunterRewardItem:SetData(viewData)
  if not viewData then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.viewData = viewData
  if viewData.minRanking ~= viewData.maxRanking then
    self.rankingTitleText:SetLocalText(2000236, viewData.minRanking, viewData.maxRanking)
  else
    self.rankingTitleText:SetLocalText(2000235, viewData.minRanking)
  end
  local showRankingBgLevel = viewData.minRanking
  if viewData.minRanking >= 4 then
    showRankingBgLevel = 4
  end
  self.rankingTitleBg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_jiangli_%d.png", showRankingBgLevel))
  self:RefreshReward(viewData.rewards)
end

function SeasonHunterRewardItem:SetDataTime(viewData)
  if not viewData then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.viewData = viewData
  if viewData.minTime ~= viewData.maxTime then
    self.rankingTitleText:SetText(string.format("%s~%s", UITimeManager:GetInstance():SecondToFmtStringWithoutHour(viewData.minTime), UITimeManager:GetInstance():SecondToFmtStringWithoutHour(viewData.maxTime)))
  else
    self.rankingTitleText:SetText(UITimeManager:GetInstance():SecondToFmtString(viewData.minTime))
  end
  local showRankingBgLevel = viewData.rank
  if viewData.rank >= 4 then
    showRankingBgLevel = 4
  end
  self.rankingTitleBg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_jiangli_%d.png", showRankingBgLevel))
  self:RefreshReward(viewData.rewards)
end

return SeasonHunterRewardItem
