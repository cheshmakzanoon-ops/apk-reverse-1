local GoldTreeRewardItem = BaseClass("GoldTreeRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function GoldTreeRewardItem:ComponentDefine()
  self.rankingTitleBg = self:AddComponent(UIImage, "RankingTitleBg")
  self.rankingTitleText = self:AddComponent(UIText, "RankingTitleBg/RankingTitleText")
  self.rewardScrollContent = self:AddComponent(UIBaseContainer, "RewardScroll/Viewport/Content")
end

function GoldTreeRewardItem:ComponentDestroy()
  self.rankingTitleBg = nil
  self.rankingTitleText = nil
  self.rewardScrollContent = nil
end

function GoldTreeRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function GoldTreeRewardItem:OnDestroy()
  self:SetAllCellDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function GoldTreeRewardItem:SetAllCellDestroy()
  self.rewardScrollContent:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function GoldTreeRewardItem:RefreshReward(list)
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

function GoldTreeRewardItem:SetData(viewData, index)
  if not viewData then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.viewData = viewData
  local titleText
  if viewData.min ~= viewData.max then
    titleText = Localization:GetString(2000236, viewData.min, viewData.max)
  else
    titleText = Localization:GetString(2000235, viewData.min)
  end
  self.rankingTitleText:SetLocalText("season_s4_golden_tree_UI_47", titleText)
  local showRankingBgLevel = index or viewData.min
  if 4 <= showRankingBgLevel then
    showRankingBgLevel = 4
  end
  self.rankingTitleBg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_jiangli_%d.png", showRankingBgLevel))
  self:RefreshReward(DataCenter.RewardManager:ReturnRewardParamForMessage(viewData.reward))
end

return GoldTreeRewardItem
