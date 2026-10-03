local UITreasureHuntBigRewardSelectView = BaseClass("UITreasureHuntBigRewardSelectView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UITreasureHuntBigRewardSelectItem = require("UI.UIActivityTreasureHunt.UITreasureHuntBigRewardSelect.Component.UITreasureHuntBigRewardSelectItem")
local UITreasureHuntBigRewardShowItem = require("UI.UIActivityTreasureHunt.UITreasureHuntBigRewardSelect.Component.UITreasureHuntBigRewardShowItem")
local Screen = CS.UnityEngine.Screen
local ParamData = {
  position = Vector2.zero,
  deltaX = 0,
  deltaY = 0,
  rewardList = {},
  selectIndex = 0,
  activityId = 0
}
local ParamDataClass = DataClass("ParamDataClass", ParamData)

local function OnCreate(self)
  base.OnCreate(self)
  self.param = nil
  self:ComponentDefine()
  self:OnAddListener()
end

local function OnDestroy(self)
  self.param = nil
  self:ComponentDestroy()
  self:OnRemoveListener()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  local btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  btnPanel:SetOnClick(function()
    self.ctrl.CloseSelf(self.ctrl)
  end)
  self.closeBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/Common_bg_orange/CloseBtn")
  self.closeBtn:SetOnClick(function()
    self.ctrl.CloseSelf(self.ctrl)
  end)
  self.imgArrow = self:AddComponent(UIBaseContainer, "ImgArrow")
  self.content = self:AddComponent(UIBaseContainer, "content")
  self.rewardContent = self:AddComponent(UIBaseContainer, "content/ItemScroll/Viewport/rewardContent")
  self.item = self:AddComponent(UIBaseContainer, "content/ItemScroll/Item")
  self.item.gameObject:GameObjectCreatePool()
  self.showRewardContent = self:AddComponent(UIBaseContainer, "content/ShowItemScroll/Viewport/showRewardContent")
  self.showItem = self:AddComponent(UIBaseContainer, "content/ShowItemScroll/ShowItem")
  self.showItem.gameObject:GameObjectCreatePool()
  self.selectBtn = self:AddComponent(UIButton, "content/selectBtn")
  self.selectBtn:SetOnClick(function()
    self:OnSelectBtnClick()
  end)
  self.beSelect = self:AddComponent(UIBaseContainer, "content/selectBtn/beSelect")
  self.levelNum = self:AddComponent(UIText, "content/levelNum")
  self.resItem = self:AddComponent(UICommonResItem, "content/curSelectBg/UICommonResItem")
  self.selectTxt = self:AddComponent(UIText, "content/selectTxt")
  self.selectTitle = self:AddComponent(UIText, "content/selectTitle")
  self.showTitle = self:AddComponent(UIText, "content/showTitle")
  self.selectTxt:SetLocalText(2000822)
  self.selectTitle:SetLocalText(2000823)
  self.showTitle:SetLocalText(2000824)
end

local function ComponentDestroy(self)
  self.closeBtn = nil
  self.imgArrow = nil
  self.content = nil
  self.rewardContent:RemoveComponents(UITreasureHuntBigRewardSelectItem)
  self.rewardContent = nil
  self.item.gameObject:GameObjectRecycleAll()
  self.item = nil
  self.showRewardContent:RemoveComponents(UITreasureHuntBigRewardShowItem)
  self.showRewardContent = nil
  self.showItem.gameObject:GameObjectRecycleAll()
  self.showItem = nil
  self.selectBtn = nil
  self.beSelect = nil
  self.levelNum = nil
  self.resItem = nil
  self.selectTxt = nil
  self.selectTitle = nil
  self.showTitle = nil
end

local function OnEnable(self)
  self.param = self:GetUserData()
  self.digInfo = DataCenter.DigActivityManager:GetDigInfo(self.param.activityId)
  if not self.digInfo then
    return
  end
  self:SetShowData()
  self:RefreshView()
end

local function OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.DigActivityRecommendSelectChange, self.RefreshSelectContent)
  self:AddUIListener(EventId.OnDigActFinalResultUpdated, self.GetSelectItemChangeMsg)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.DigActivityRecommendSelectChange, self.RefreshSelectContent)
  self:RemoveUIListener(EventId.OnDigActFinalResultUpdated, self.GetSelectItemChangeMsg)
  base.OnRemoveListener(self)
end

local function SetShowData(self)
  self.bigRewardList = {}
  local paramTempLsi = DataCenter.DigActivityManager:GetDigParamTemplateDic(self.param.activityId)
  for i = 1, #paramTempLsi do
    local paramData = paramTempLsi[i]
    if paramData.big_reward_Preview_Arr and #paramData.big_reward_Preview_Arr == 2 then
      local data = {
        level = paramData.level,
        big_reward_Preview = tonumber(paramData.big_reward_Preview_Arr[1]),
        count = tonumber(paramData.big_reward_Preview_Arr[2])
      }
      table.insert(self.bigRewardList, data)
    end
  end
  table.sort(self.bigRewardList, function(a, b)
    return a.level < b.level
  end)
end

local function RefreshView(self)
  local curLevel = self.digInfo.finishedLv + 1
  self.showRewardContent:RemoveComponents(UITreasureHuntBigRewardShowItem)
  self.showItem.gameObject:GameObjectRecycleAll()
  local showList = {}
  for k, v in ipairs(self.bigRewardList) do
    if curLevel <= v.level then
      table.insert(showList, v)
    end
  end
  if showList ~= nil then
    for i = 1, table.length(showList) do
      local item = self.showItem.gameObject:GameObjectSpawn(self.showRewardContent.transform)
      item.name = tostring(i)
      local cell = self.showRewardContent:AddComponent(UITreasureHuntBigRewardShowItem, item.name)
      cell:SetData(showList[i], self.digInfo)
    end
  end
  local maxLevel = DataCenter.DigActivityManager:GetMaxLvCount(self.param.activityId)
  self.levelNum:SetLocalText(2000821, curLevel)
  self:RefreshSelectItemContent()
  self:RefreshSelectContent()
  self:RefreshCurSelectContent()
end

local function RefreshSelectItemContent(self)
  self.rewardContent:RemoveComponents(UITreasureHuntBigRewardSelectItem)
  self.item.gameObject:GameObjectRecycleAll()
  local list = self.param.rewardList
  if list ~= nil then
    for i = 1, table.length(list) do
      local item = self.item.gameObject:GameObjectSpawn(self.rewardContent.transform)
      item.name = tostring(i)
      local cell = self.rewardContent:AddComponent(UITreasureHuntBigRewardSelectItem, item.name, list[i])
      cell:SetData(list[i], self.param.activityId, i, self.param.selectIndex)
      local selectIndex = self.digInfo.finalRewardIndex
      cell:SetBeSelectData(selectIndex)
    end
  end
end

local function RefreshSelectContent(self)
  self.beSelect:SetActive(self.digInfo.recommend > 0)
end

local function RefreshCurSelectContent(self)
  local reward
  if self.digInfo and self.digInfo.finalRewardIndex > 0 then
    local template = DataCenter.DigActivityManager:GetDigTemplate(self.param.activityId)
    if template then
      local curLevel = self.digInfo.finishedLv + 1
      reward = template:GetFinalReward(curLevel, self.digInfo.finalRewardIndex)
    else
      reward = nil
    end
  end
  if reward then
    self.resItem:SetActive(true)
    local rewardData = {
      rewardType = RewardType.GOODS,
      itemId = reward.itemId,
      count = reward.count
    }
    self.resItem:ReInit(rewardData)
  else
    self.resItem:SetActive(false)
  end
end

local function GetSelectItemChangeMsg(self)
  self:RefreshSelectItemContent()
  self:RefreshCurSelectContent()
end

local function OnSelectBtnClick(self)
  local targetSelect = self.digInfo.recommend == 0 and 1 or 0
  SFSNetwork.SendMessage(MsgDefines.RecommendSelect, self.param.activityId, targetSelect)
end

UITreasureHuntBigRewardSelectView.ParamDataClass = ParamDataClass
UITreasureHuntBigRewardSelectView.OnCreate = OnCreate
UITreasureHuntBigRewardSelectView.OnDestroy = OnDestroy
UITreasureHuntBigRewardSelectView.OnEnable = OnEnable
UITreasureHuntBigRewardSelectView.OnDisable = OnDisable
UITreasureHuntBigRewardSelectView.ComponentDefine = ComponentDefine
UITreasureHuntBigRewardSelectView.ComponentDestroy = ComponentDestroy
UITreasureHuntBigRewardSelectView.RefreshView = RefreshView
UITreasureHuntBigRewardSelectView.OnSelectBtnClick = OnSelectBtnClick
UITreasureHuntBigRewardSelectView.OnAddListener = OnAddListener
UITreasureHuntBigRewardSelectView.OnRemoveListener = OnRemoveListener
UITreasureHuntBigRewardSelectView.SetShowData = SetShowData
UITreasureHuntBigRewardSelectView.RefreshSelectContent = RefreshSelectContent
UITreasureHuntBigRewardSelectView.RefreshSelectItemContent = RefreshSelectItemContent
UITreasureHuntBigRewardSelectView.RefreshCurSelectContent = RefreshCurSelectContent
UITreasureHuntBigRewardSelectView.GetSelectItemChangeMsg = GetSelectItemChangeMsg
return UITreasureHuntBigRewardSelectView
