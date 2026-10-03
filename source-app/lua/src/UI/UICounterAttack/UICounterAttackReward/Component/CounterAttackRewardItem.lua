local CounterAttackRewardItem = BaseClass("CounterAttackRewardItem", UIBaseContainer)
local base = UIBaseContainer

function CounterAttackRewardItem:ComponentDefine()
  self.rankingTitleBg = self:AddComponent(UIImage, "RankingTitleBg")
  self.rankingTitleText = self:AddComponent(UITextMeshProUGUIEx, "RankingTitleBg/RankingTitleText")
  self.rewardScrollContent = self:AddComponent(UIBaseContainer, "RewardScroll/Viewport/Content")
end

function CounterAttackRewardItem:ComponentDestroy()
  self:SetAllCellDestroy()
  self.rankingTitleBg = nil
  self.rankingTitleText = nil
  self.rewardScrollContent = nil
end

function CounterAttackRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function CounterAttackRewardItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CounterAttackRewardItem:Refresh(data)
  if not (data and data.rank) or not data.rewards then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  local ranks = string.split(data.rank, "-")
  if #ranks == 1 then
    self.rankingTitleText:SetLocalText(2000235, ranks[1])
  elseif #ranks == 2 then
    self.rankingTitleText:SetLocalText(2000236, ranks[1], ranks[2])
  end
  local rankBgLevel = tonumber(ranks[1])
  rankBgLevel = math.min(4, rankBgLevel)
  self.rankingTitleBg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_jiangli_%d.png", rankBgLevel))
  self:RefreshReward(data.rewards)
end

function CounterAttackRewardItem:SetAllCellDestroy()
  self.rewardScrollContent:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

function CounterAttackRewardItem:RefreshReward(rewardList)
  self:SetAllCellDestroy()
  if rewardList == nil or #rewardList == 0 then
    return
  end
  for i = 1, table.length(rewardList) do
    self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.rewardScrollContent.transform)
      go.transform:Set_localScale(0.78, 0.82, 1)
      go.transform:Set_sizeDelta(91, 97)
      go.transform.pivot = Vector2.New(0.5, 0.5)
      go.name = "UICommonResItem" .. i
      local cell = self.rewardScrollContent:AddComponent(UICommonResItem, go.name)
      local data = rewardList[i]
      local param = UICommonResItem.Param.New()
      param.rewardType = data.type
      if type(data.value) == "table" then
        param.itemId = data.value.id
        param.count = data.value.num
      else
        param.itemId = data.type
        param.count = data.value
      end
      param.rewardType = data.type
      param.heroUuid = data.heroUuid
      param.isHeroBox = data.isHeroBox
      cell:ReInit(param)
    end)
  end
end

return CounterAttackRewardItem
