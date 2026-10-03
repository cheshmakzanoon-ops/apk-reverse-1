local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local TradeStationMain = BaseClass("TradeStationMain", base)
local Localization = CS.GameEntry.Localization
local TradeCityInfoItem = require("UI.LWSeason.LWSeasonTradeStation.TradeStationMain.Component.TradeCityInfoItem")
local infoBtn_path = "Root/top/right/IntroBtn"
local rankBtn_path = "Root/top/right/rankBtn"
local name_path = "Root/top/left/Txt_ActName"
local desc_path = "Root/bot/BotMenu/TxtDesc"
local endTime_path = "Root/top/left/TimeContent/Txt_Times"
local recordBtn_path = "Root/top/right/recordBtn"
local honorBtn_path = "Root/top/right/honorBtn"
local btnCity_path = "Root/bot/Btns/BtnCity"
local btnShop_path = "Root/bot/Btns/BtnShop"
local tradeCityInfoItem_path = "Root/bot/BotMenu/TradeCityInfoItem"
local resContent_path = "Root/bot/BotMenu/RewardGroup/ScrollView/Viewport/Content"
local resItem_path = "Root/bot/BotMenu/RewardGroup/UICommonResItem"
local botMenu_path = "Root/bot/BotMenu"
local descGroup_path = "Root/bot/BotMenu/DescGroup"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.rankBtn = self:AddComponent(UIButton, rankBtn_path)
  self.name = self:AddComponent(UIText, name_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.endTime = self:AddComponent(UIText, endTime_path)
  self.recordBtn = self:AddComponent(UIButton, recordBtn_path)
  self.honorBtn = self:AddComponent(UIButton, honorBtn_path)
  self.btnCity = self:AddComponent(UIButton, btnCity_path)
  self.btnShop = self:AddComponent(UIButton, btnShop_path)
  self.tradeCityInfoItem = self:AddComponent(UIBaseContainer, tradeCityInfoItem_path)
  self.resContent = self:AddComponent(UIBaseContainer, resContent_path)
  self.resItem = self:AddComponent(UIBaseContainer, resItem_path)
  self.botMenu = self:AddComponent(UIBaseContainer, botMenu_path)
  self.descGroup = self:AddComponent(UIBaseContainer, descGroup_path)
  self.infoBtn:SetOnClick(function()
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.activityData.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
  self.rankBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.TradeStationRank, {anim = true})
  end)
  self.recordBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.TradeStationHistory, {anim = true})
  end)
  self.honorBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.TradeStationHonor, {anim = true})
  end)
  self.btnCity:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.TradeStationCity, {anim = true})
  end)
  self.btnShop:SetOnClick(function()
    DataCenter.SeasonTradeDataManager:GotoTradeStationShop()
  end)
  self.tradeCityInfoItem = self:AddComponent(TradeCityInfoItem, tradeCityInfoItem_path)
  self.ItemObj = self.resItem.gameObject
  self.ItemObj:GameObjectCreatePool()
  self.ItemObj:SetActive(false)
end

local function ComponentDestroy(self)
  self.resContent:RemoveComponents(UICommonResItem)
  self.ItemObj:GameObjectRecycleAll()
  self.infoBtn = nil
  self.rankBtn = nil
  self.name = nil
  self.desc = nil
  self.endTime = nil
  self.recordBtn = nil
  self.honorBtn = nil
  self.btnCity = nil
  self.btnShop = nil
  self.tradeCityInfoItem = nil
  self.resContent = nil
  self.resItem = nil
  self.botMenu = nil
  self.descGroup = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function TradeStationMain:OnAddListener()
  base.OnAddListener(self)
end

function TradeStationMain:OnRemoveListener()
  base.OnRemoveListener(self)
end

function TradeStationMain:SetData(activityId)
  base.SetData(self, activityId)
  local data = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if data == nil then
    return
  end
  self.activityData = data
  self.name:SetLocalText(data.name)
  self.StartTime = data.startTime
  if SeasonUtil.IsInSeasonPrepareMode() then
    self.EndTime = DataCenter.SeasonDataManager.nextSeasonStartTime
  else
    self.EndTime = data.endTime
  end
  self:RefreshView()
  self:Update1000MS()
end

function TradeStationMain:RefreshView()
  self:RefreshStation()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.descGroup.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.botMenu.rectTransform)
end

function TradeStationMain:RefreshStation()
  local tradeCityData = DataCenter.SeasonTradeDataManager:GetServerTradeStationLatestData()
  self.tradeCityInfoItem:ReInit(tradeCityData)
  self:RefreshReward(tradeCityData)
end

function TradeStationMain:RefreshReward(tradeCityData)
  self.resContent:RemoveComponents(UICommonResItem)
  self.ItemObj:GameObjectRecycleAll()
  local cityTemplate = tradeCityData and DataCenter.AllianceCityTemplateManager:GetTemplate(tradeCityData.tradeId, LuaEntry.Player:GetCurServerId())
  if not cityTemplate then
    return
  end
  local rewardStr = DataCenter.RewardManager:ParseRewardsStr(cityTemplate.show_reward)
  if not rewardStr then
    return
  end
  for i, v in ipairs(rewardStr) do
    local theItem = self.ItemObj:GameObjectSpawn(self.resContent.transform)
    theItem.name = string.format("Item_%d", i)
    theItem:SetActive(true)
    theItem = self.resContent:AddComponent(UICommonResItem, theItem.name)
    theItem:ReInit(v)
  end
end

function TradeStationMain:Update1000MS()
  if self.activityData then
    UIUtil.SetLeftTimeText(self.endTime, self.StartTime, self.EndTime)
  end
end

TradeStationMain.OnCreate = OnCreate
TradeStationMain.OnDestroy = OnDestroy
TradeStationMain.OnEnable = OnEnable
TradeStationMain.OnDisable = OnDisable
TradeStationMain.ComponentDefine = ComponentDefine
TradeStationMain.ComponentDestroy = ComponentDestroy
TradeStationMain.DataDefine = DataDefine
TradeStationMain.DataDestroy = DataDestroy
return TradeStationMain
