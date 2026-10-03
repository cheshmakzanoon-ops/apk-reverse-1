local AttackCityRankRewardContentItem = BaseClass("AttackCityRankRewardContentItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function AttackCityRankRewardContentItem:ComponentDefine()
  self.rankingTitleBg = self:AddComponent(UIImage, "RankingTitleBg")
  self.rankingTitleText = self:AddComponent(UIText, "RankingTitleBg/RankingTitleText")
  self.rewardScrollContent = self:AddComponent(UIBaseContainer, "RewardScroll/Viewport/Content")
end

function AttackCityRankRewardContentItem:ComponentDestroy()
  self.rankingTitleBg = nil
  self.rankingTitleText = nil
  self.rewardScrollContent = nil
end

function AttackCityRankRewardContentItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function AttackCityRankRewardContentItem:OnDestroy()
  self:SetAllCellDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AttackCityRankRewardContentItem:SetAllCellDestroy()
  self.rewardScrollContent:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function AttackCityRankRewardContentItem:RefreshReward(list)
  self:SetAllCellDestroy()
  self.showList = list
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
        local data = self.showList[i]
        local param = {}
        param.rewardType = data.type
        if type(data.value) == "table" then
          param.itemId = data.value.id
          param.count = data.value.num
        else
          param.count = data.value
        end
        cell:ReInit(param)
      end)
    end
  end
end

function AttackCityRankRewardContentItem:SetData(viewData)
  if not viewData then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.viewData = viewData
  if viewData.minLv ~= viewData.maxLv then
    self.rankingTitleText:SetLocalText(2000236, viewData.minLv, viewData.maxLv)
  else
    self.rankingTitleText:SetLocalText(2000235, viewData.minLv)
  end
  local showRankingBgLevel = viewData.minLv
  if viewData.minLv >= 4 then
    showRankingBgLevel = 4
  end
  self.rankingTitleBg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_jiangli_%d.png", showRankingBgLevel))
  self:RefreshReward(viewData.reward)
end

return AttackCityRankRewardContentItem
