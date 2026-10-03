local UIRankingRewardItem = BaseClass("UIRankingRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function DataDefine(self)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.dataList then
    return nil
  end
  local data = self.dataList[index]
  local item = loopScroll:NewListViewItem("MethodItem")
  local script = self.methodScrollContent:GetComponent(item.gameObject.name, UICommonResItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.methodScrollContent:AddComponent(UICommonResItem, objectName)
  end
  script:SetActive(true)
  script:SetData(data.name, data.gotoType, data.gotoPara)
  return item
end

local function ComponentDefine(self)
  self.rankingTitleBg = self:AddComponent(UIImage, "RankingTitleBg")
  self.rankingTitleText = self:AddComponent(UIText, "RankingTitleText")
  self.rewardScrollContent = self:AddComponent(UIBaseContainer, "RewardScroll/Viewport/Content")
end

local function DataDestroy(self)
end

local function ComponentDestroy(self)
  self.rankingTitleBg = nil
  self.rankingTitleText = nil
  self.rewardScrollContent = nil
end

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function SetAllCellDestroy(self)
  self.rewardScrollContent:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

local function RefreshReward(self, list)
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
        cell:ReInit(self.showList[i])
        self.showList[i].iconImg = go.transform:Find("clickBtn/ItemIcon")
      end)
    end
  end
end

local function SetData(self, viewData)
  if not viewData then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.viewData = viewData
  if viewData.minRank ~= viewData.maxRank then
    self.rankingTitleText:SetText(string.format("%s-%s", tostring(viewData.minRank), tostring(viewData.maxRank)))
  else
    self.rankingTitleText:SetText(viewData.minRank)
  end
  local showRankingBgLevel = viewData.minRank
  if viewData.minRank >= 4 then
    showRankingBgLevel = 4
  end
  if viewData.minRank == 1 then
    self.rankingTitleBg:SetActive(true)
    self.rankingTitleBg:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_1.png")
  elseif viewData.minRank == 2 then
    self.rankingTitleBg:SetActive(true)
    self.rankingTitleBg:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_2.png")
  elseif viewData.minRank == 3 then
    self.rankingTitleBg:SetActive(true)
    self.rankingTitleBg:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_3.png")
  else
    self.rankingTitleBg:SetActive(false)
  end
  self.rewardScrollContent:SetAnchoredPositionXY(0, 0)
  local reward = DataCenter.RewardManager:ReturnRewardParamForView(viewData.reward)
  RefreshReward(self, reward)
end

UIRankingRewardItem.OnCreate = OnCreate
UIRankingRewardItem.OnDestroy = OnDestroy
UIRankingRewardItem.DataDefine = DataDefine
UIRankingRewardItem.ComponentDefine = ComponentDefine
UIRankingRewardItem.DataDestroy = DataDestroy
UIRankingRewardItem.ComponentDestroy = ComponentDestroy
UIRankingRewardItem.SetData = SetData
UIRankingRewardItem.RefreshReward = RefreshReward
UIRankingRewardItem.SetAllCellDestroy = SetAllCellDestroy
return UIRankingRewardItem
