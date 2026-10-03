local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local TradeStationMainS5 = BaseClass("TradeStationMainS5", base)
local Localization = CS.GameEntry.Localization
local TradeCityInfoItem = require("UI.LWSeason5.TradeStationMain.Component.TradeCityInfoItemS5")
local infoBtn_path = "Root/top/right/IntroBtn"
local rankBtn_path = "Root/top/right/rankBtn"
local name_path = "Root/top/left/Txt_ActName"
local desc_path = "Root/bot/BotMenu/TxtDesc"
local endTime_path = "Root/top/left/TimeInfoItem/timeBg2/TimeText"
local recordBtn_path = "Root/top/right/recordBtn"
local honorBtn_path = "Root/top/right/honorBtn"
local btnCity_path = "Root/bot/Btns/BtnCity"
local btnShop_path = "Root/bot/Btns/BtnShop"
local scrollView_path = "Root/bot/BotMenu/Scroll View"
local cityContent_path = "Root/bot/BotMenu/Scroll View/Viewport/CityContent"
local tradeCityInfoItem_path = "Root/bot/BotMenu/Scroll View/Viewport/CityContent/TradeCityInfoItem"
local arrowLeft_path = "Root/bot/BotMenu/Scroll View/ArrowLeft"
local arrowRight_path = "Root/bot/BotMenu/Scroll View/ArrowRight"
local resContent_path = "Root/bot/BotMenu/RewardGroup/ScrollView/Viewport/Content"
local resItem_path = "Root/bot/BotMenu/RewardGroup/UICommonResItem"
local botMenu_path = "Root/bot/BotMenu"

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
  self.scrollView = self:AddComponent(UIScrollRect, scrollView_path)
  self.cityContent = self:AddComponent(UIBaseContainer, cityContent_path)
  self.tradeCityInfoItem = self:AddComponent(UIBaseContainer, tradeCityInfoItem_path)
  self.arrowLeft = self:AddComponent(UIButton, arrowLeft_path)
  self.arrowRight = self:AddComponent(UIButton, arrowRight_path)
  self.resContent = self:AddComponent(UIBaseContainer, resContent_path)
  self.resItem = self:AddComponent(UIBaseContainer, resItem_path)
  self.botMenu = self:AddComponent(UIBaseContainer, botMenu_path)
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
  self.ItemObj = self.resItem.gameObject
  self.ItemObj:GameObjectCreatePool()
  self.ItemObj:SetActive(false)
  self.CityObj = self.tradeCityInfoItem.gameObject
  self.CityObj:GameObjectCreatePool()
  self.CityObj:SetActive(false)
  self.scrollView:AddValueChangeListener(function()
    self:ScrollViewChange()
  end)
  self.arrowLeft:SetOnClick(function()
    self:OnClickArrow(-1)
  end)
  self.arrowRight:SetOnClick(function()
    self:OnClickArrow(1)
  end)
end

local function ComponentDestroy(self)
  self.cityContent:RemoveComponents(TradeCityInfoItem)
  self.CityObj:GameObjectRecycleAll()
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
  self.scrollView = nil
  self.cityContent = nil
  self.tradeCityInfoItem = nil
  self.arrowLeft = nil
  self.arrowRight = nil
  self.resContent = nil
  self.resItem = nil
  self.botMenu = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function TradeStationMainS5:OnAddListener()
  base.OnAddListener(self)
end

function TradeStationMainS5:OnRemoveListener()
  base.OnRemoveListener(self)
end

function TradeStationMainS5:SetData(activityId)
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

function TradeStationMainS5:RefreshView()
  self:RefreshStation()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.botMenu.rectTransform)
end

function TradeStationMainS5:RefreshStation()
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local curServerId = LuaEntry.Player:GetCurServerId()
  local seasonInfo = SeasonUtil.GetSeasonInfo(curServerId)
  if seasonInfo ~= nil and seasonInfo:IsInBattleServerGroupInt_IgnoreSplitServer(mySourceServerId) then
    self.cityList = DataCenter.SeasonTradeDataManager:GetServerTradeStationLatestList(curServerId)
  else
    self.cityList = DataCenter.SeasonTradeDataManager:GetServerTradeStationLatestList(mySourceServerId)
  end
  self:RefreshReward(self.cityList[1])
  self:RefreshCityInfo(self.cityList)
end

function TradeStationMainS5:RefreshReward(tradeCityData)
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

function TradeStationMainS5:RefreshCityInfo(cityList)
  self.cityContent:RemoveComponents(TradeCityInfoItem)
  self.CityObj:GameObjectRecycleAll()
  for i, v in ipairs(cityList) do
    local theItem = self.CityObj:GameObjectSpawn(self.cityContent.transform)
    theItem.name = string.format("CityInfoItem_%d", i)
    theItem:SetActive(true)
    theItem = self.cityContent:AddComponent(TradeCityInfoItem, theItem.name)
    theItem:ReInit(v)
  end
end

function TradeStationMainS5:Update1000MS()
  if self.activityData then
    UIUtil.SetLeftTimeText(self.endTime, self.StartTime, self.EndTime)
  end
end

function TradeStationMainS5:ScrollViewChange()
  local pos = self.scrollView:GetHorizontalNormalizedPosition()
  self.arrowLeft:SetActive(0.02 < pos)
  self.arrowRight:SetActive(pos < 0.98)
end

function TradeStationMainS5:OnClickArrow(delta)
  local pos = self.scrollView:GetHorizontalNormalizedPosition()
  delta = math.min(1, math.max(0, delta + pos))
  self.scrollView:AnimHorizontalNormalizedPos(delta, 0.15)
end

TradeStationMainS5.OnCreate = OnCreate
TradeStationMainS5.OnDestroy = OnDestroy
TradeStationMainS5.OnEnable = OnEnable
TradeStationMainS5.OnDisable = OnDisable
TradeStationMainS5.ComponentDefine = ComponentDefine
TradeStationMainS5.ComponentDestroy = ComponentDestroy
TradeStationMainS5.DataDefine = DataDefine
TradeStationMainS5.DataDestroy = DataDestroy
return TradeStationMainS5
