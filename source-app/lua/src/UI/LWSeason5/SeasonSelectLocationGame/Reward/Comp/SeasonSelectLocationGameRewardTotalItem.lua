local SeasonSelectLocationGameRewardTotalItem = BaseClass("SeasonSelectLocationGameRewardTotalItem", UIBaseContainer)
local base = UIBaseContainer

function SeasonSelectLocationGameRewardTotalItem:ComponentDefine()
  self.rankingTitleBg = self:AddComponent(UIImage, "RankingTitleBg")
  self.rankingTitleText = self:AddComponent(UIText, "RankingTitleText")
  self.bg = self:AddComponent(UIImage, "Bg")
  self.rewardScrollContent = self:AddComponent(UIBaseContainer, "RewardScroll/Viewport/Content")
end

function SeasonSelectLocationGameRewardTotalItem:ComponentDestroy()
  self.rankingTitleBg = nil
  self.rankingTitleText = nil
  self.bg = nil
  self.rewardScrollContent = nil
end

function SeasonSelectLocationGameRewardTotalItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function SeasonSelectLocationGameRewardTotalItem:OnDestroy()
  self:SetAllCellDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonSelectLocationGameRewardTotalItem:SetAllCellDestroy()
  self.rewardScrollContent:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function SeasonSelectLocationGameRewardTotalItem:RefreshReward(rewardId)
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

function SeasonSelectLocationGameRewardTotalItem:SetData(viewData)
  if not viewData then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.viewData = viewData
  if viewData.minRank ~= viewData.maxRank then
    self.rankingTitleText:SetText(string.format("%d-%d", viewData.minRank, viewData.maxRank))
  else
    self.rankingTitleText:SetText(viewData.minRank)
  end
  local showRankingBgLevel = viewData.minRank
  if viewData.minRank >= 4 then
    showRankingBgLevel = 4
  end
  self.rankingTitleBg:SetActive(true)
  if showRankingBgLevel == 1 then
    self.rankingTitleBg:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_1.png")
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_jinsetiao.png")
  elseif showRankingBgLevel == 2 then
    self.rankingTitleBg:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_2.png")
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_yinsetiao.png")
  elseif showRankingBgLevel == 3 then
    self.rankingTitleBg:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_3.png")
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_tongsetiao.png")
  else
    self.rankingTitleBg:SetActive(false)
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_huisetiao.png")
  end
  self:RefreshReward(viewData.rewardId)
end

return SeasonSelectLocationGameRewardTotalItem
