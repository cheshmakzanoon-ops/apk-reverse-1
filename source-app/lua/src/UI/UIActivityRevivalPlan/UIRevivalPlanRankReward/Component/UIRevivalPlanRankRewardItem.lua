local UIRevivalPlanRankRewardItem = BaseClass("UIRevivalPlanRankRewardItem", UIBaseContainer)
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
  self.rankingTitleText = self:AddComponent(UIText, "RankingTitleBg/RankingTitleText")
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
  RefreshReward(self, viewData.rewards)
end

UIRevivalPlanRankRewardItem.OnCreate = OnCreate
UIRevivalPlanRankRewardItem.OnDestroy = OnDestroy
UIRevivalPlanRankRewardItem.DataDefine = DataDefine
UIRevivalPlanRankRewardItem.ComponentDefine = ComponentDefine
UIRevivalPlanRankRewardItem.DataDestroy = DataDestroy
UIRevivalPlanRankRewardItem.ComponentDestroy = ComponentDestroy
UIRevivalPlanRankRewardItem.SetData = SetData
UIRevivalPlanRankRewardItem.RefreshReward = RefreshReward
UIRevivalPlanRankRewardItem.SetAllCellDestroy = SetAllCellDestroy
return UIRevivalPlanRankRewardItem
