local UISeasonTowerRankRewardItem = BaseClass("UISeasonTowerRankRewardItem", UIBaseContainer)
local base = UIBaseContainer
local bgDict = {
  [1] = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_1.png",
  [2] = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_2.png",
  [3] = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_3.png"
}
local Localization = CS.GameEntry.Localization

function UISeasonTowerRankRewardItem:ComponentDefine()
  self.rankingTitleBg = self:AddComponent(UIImage, "RankingTitleBg")
  self.rankingTitleText = self:AddComponent(UIText, "RankingTitleText")
  self.bg = self:AddComponent(UIImage, "Bg")
  self.rewardScrollContent = self:AddComponent(UIBaseContainer, "RewardScroll/Viewport/Content")
end

function UISeasonTowerRankRewardItem:ComponentDestroy()
  self.rankingTitleBg = nil
  self.rankingTitleText = nil
  self.bg = nil
  self.rewardScrollContent = nil
end

function UISeasonTowerRankRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UISeasonTowerRankRewardItem:OnDestroy()
  self:SetAllCellDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISeasonTowerRankRewardItem:SetAllCellDestroy()
  self.rewardScrollContent:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function UISeasonTowerRankRewardItem:RefreshReward(list, title)
  self:SetAllCellDestroy()
  self.showList = DeepCopy(list)
  if not string.IsNullOrEmpty(title) and tostring(title) ~= "0" then
    local titleCell = LocalController:instance():tryGetLine(TableName.LW_TITLE, title)
    if titleCell ~= nil then
      table.insert(self.showList, 1, {
        rewardType = RewardType.RESOURCE_ITEM,
        itemId = titleCell.connect_resource_item,
        count = 1
      })
    end
  end
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

function UISeasonTowerRankRewardItem:SetData(viewData)
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
  if showRankingBgLevel <= 3 then
    self.rankingTitleBg:LoadSprite(NewRankIconPath[showRankingBgLevel])
    self.rankingTitleBg:SetNativeSize()
    self.bg:LoadSprite(bgDict[showRankingBgLevel])
  else
    self.rankingTitleBg:SetActive(false)
    self.bg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_common_diban_bai.png")
  end
  self:RefreshReward(viewData.rewards, viewData.title_reward)
end

return UISeasonTowerRankRewardItem
