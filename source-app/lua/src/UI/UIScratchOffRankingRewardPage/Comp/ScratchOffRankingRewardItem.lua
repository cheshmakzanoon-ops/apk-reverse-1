local ScratchOffRankingRewardItem = BaseClass("ScratchOffRankingRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function ScratchOffRankingRewardItem:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function ScratchOffRankingRewardItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function ScratchOffRankingRewardItem:DataDefine()
  self.rewardItems = {}
end

function ScratchOffRankingRewardItem:DataDestroy()
end

function ScratchOffRankingRewardItem:ComponentDefine()
  self.rankingBg = self:AddComponent(UIImage, "RankingBg")
  self.rankingText = self:AddComponent(UIText, "RankingText")
  self.rewardContent = self:AddComponent(UIBaseContainer, "RewardsScroll/Viewport/Content")
  self.bg = self:AddComponent(UIImage, "")
end

function ScratchOffRankingRewardItem:ClearScroll()
  if self.rewardItems ~= nil then
    for i, v in pairs(self.rewardItems) do
      self:GameObjectDestroy(v)
    end
    self.rewardItems = {}
  end
end

function ScratchOffRankingRewardItem:ComponentDestroy()
  self:ClearScroll()
  self.rankingBg = nil
  self.rankingText = nil
  self.rewardContent = nil
  self.bg = nil
end

function ScratchOffRankingRewardItem:SetData(rankInfo)
  if rankInfo == nil then
    return
  end
  local rankMin = rankInfo.startN
  local rankMax = rankInfo.endN
  local rewardList = rankInfo.reward
  if rankMin == rankMax then
    self.rankingBg:SetActive(rankMin <= 3)
    if rankMin <= 3 then
      self.rankingBg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_%d.png", rankMin))
    end
    self.rankingText:SetText(rankMin)
  else
    self.rankingBg:SetActive(false)
    self.rankingText:SetText(string.format("%d-%d", rankMin, rankMax))
  end
  if rankMin == rankMax then
    if rankMin == 1 then
      self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_jinsetiao.png")
    elseif rankMin == 2 then
      self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_yinsetiao.png")
    elseif rankMin == 3 then
      self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_tongsetiao.png")
    end
  else
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_huisetiao.png")
  end
  self:ClearScroll()
  for i, v in pairs(rewardList) do
    self.rewardItems[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.rewardContent.transform)
      go.transform:Set_localScale(0.75, 0.75, 0.75)
      go.transform:Set_sizeDelta(92, 95)
      go.transform.pivot = Vector2.New(0.5, 0.5)
      go.transform:SetAsLastSibling()
      go.name = tostring(i)
      local rewardItem = self.rewardContent:AddComponent(UICommonResItem, go.name)
      rewardItem:ReInit(v)
    end)
  end
end

return ScratchOffRankingRewardItem
