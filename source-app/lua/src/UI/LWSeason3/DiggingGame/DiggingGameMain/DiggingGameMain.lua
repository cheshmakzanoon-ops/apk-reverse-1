local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local DiggingGameMain = BaseClass("DiggingGameMain", base)
local Localization = CS.GameEntry.Localization
local DiggingInfoItem = require("UI.LWSeason3.DiggingGame.DiggingGameMain.Component.DiggingInfoItem")
local TitleText_path = "root/Rect_Top/LeftRoot/TitleText"
local TimeText_path = "root/Rect_Top/LeftRoot/TimeInfoItem/timeBg2/TimeText"
local InfoText_path = "root/Rect_Top/LeftRoot/InfoText"
local ScrollView_path = "root/Rect_Bottom/ScrollView"
local IntroBtn_path = "root/Rect_Top/InfoBtn"
local ImageBg_path = "ImageBg2"
local Item1_path = "root/Rect_Top/LeftRoot/UICommonResItem1"
local Item2_path = "root/Rect_Top/LeftRoot/UICommonResItem2"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  SFSNetwork.SendMessage(MsgDefines.SeasonDigActivityInfo)
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
  self.TitleText = self:AddComponent(UIText, TitleText_path)
  self.TimeText = self:AddComponent(UIText, TimeText_path)
  self.InfoText = self:AddComponent(UIText, InfoText_path)
  self.ScrollView = self:AddComponent(UIScrollView, ScrollView_path)
  self.IntroBtn = self:AddComponent(UIButton, IntroBtn_path)
  self.ImageBg = self:AddComponent(UIRawImage, ImageBg_path)
  self.Item1 = self:AddComponent(UIBaseContainer, Item1_path)
  self.Item2 = self:AddComponent(UIBaseContainer, Item2_path)
  self.IntroBtn:SetOnClick(function()
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.activityData.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.resItem1 = self:AddComponent(UICommonResItem, Item1_path)
  self.resItem2 = self:AddComponent(UICommonResItem, Item2_path)
  self:RefreshItem()
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.TitleText = nil
  self.TimeText = nil
  self.InfoText = nil
  self.ScrollView = nil
  self.IntroBtn = nil
  self.ImageBg = nil
  self.Item1 = nil
  self.Item2 = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function DiggingGameMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DiggingGameMapListInfo, self.RefreshView)
  self:AddUIListener(EventId.DiggingGameMapDataGetReward, self.UpdateReward)
  self:AddUIListener(EventId.UseItemSuccess, self.UseItemSuccess)
end

function DiggingGameMain:OnRemoveListener()
  self:RemoveUIListener(EventId.DiggingGameMapListInfo, self.RefreshView)
  self:RemoveUIListener(EventId.DiggingGameMapDataGetReward, self.UpdateReward)
  self:RemoveUIListener(EventId.UseItemSuccess, self.UseItemSuccess)
  base.OnRemoveListener(self)
end

function DiggingGameMain:SetData(activityId)
  base.SetData(self, activityId)
  local data = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if data == nil then
    return
  end
  self.activityData = data
  self.TitleText:SetLocalText(data.name)
  self.InfoText:SetLocalText(data.desc_info)
  self.StartTime = data.startTime
  if SeasonUtil.IsInSeasonPrepareMode() then
    self.EndTime = DataCenter.SeasonDataManager.nextSeasonStartTime
  else
    self.EndTime = data.endTime
  end
  if not string.IsNullOrEmpty(data.activity_pic) then
    self.ImageBg:LoadSprite(string.format(LoadPath.UIDiggingTex, data.activity_pic), string.format(LoadPath.UIDiggingTex, "ljq_saijis3_yindiannaqiongsi_bg_01"))
    self.ImageBg:SetNativeSize()
  end
  self:RefreshView()
  self:Update1000MS()
end

function DiggingGameMain:RefreshView()
  self.mapList = DataCenter.DiggingDataManager:GetMapList()
  if self.mapList then
    self:ClearScroll()
    self.EnableAnimation = true
    self.ScrollView:SetTotalCount(#self.mapList)
    self.ScrollView:RefillCells()
    self.EnableAnimation = nil
  end
end

function DiggingGameMain:Update1000MS()
  if self.activityData then
    UIUtil.SetLeftTimeText(self.TimeText, self.StartTime, self.EndTime)
  end
end

function DiggingGameMain:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(DiggingInfoItem)
end

function DiggingGameMain:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(DiggingInfoItem, itemObj)
  cellItem:ReInit(index, self.mapList[index])
  if self.EnableAnimation then
    cellItem:ShowFadeInEffect()
  end
end

function DiggingGameMain:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, DiggingInfoItem)
end

function DiggingGameMain:UpdateReward()
  SFSNetwork.SendMessage(MsgDefines.SeasonDigActivityInfo)
end

function DiggingGameMain:RefreshItem()
  local itemCount1 = DataCenter.ItemData:GetItemCount(650043)
  local itemCount2 = DataCenter.ItemData:GetItemCount(650044)
  local itemData1 = {
    itemId = 650043,
    rewardType = RewardType.GOODS,
    count = itemCount1,
    showUse = true
  }
  local itemData2 = {
    itemId = 650044,
    rewardType = RewardType.GOODS,
    count = itemCount2,
    showUse = true
  }
  self.resItem1:ReInit(itemData1)
  self.resItem2:ReInit(itemData2)
end

function DiggingGameMain:UseItemSuccess(itemId)
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  if not template or template.type ~= GOODS_TYPE.GOODS_TYPE_154 then
    return
  end
  self:RefreshItem()
  SFSNetwork.SendMessage(MsgDefines.SeasonDigActivityInfo)
end

DiggingGameMain.OnCreate = OnCreate
DiggingGameMain.OnDestroy = OnDestroy
DiggingGameMain.OnEnable = OnEnable
DiggingGameMain.OnDisable = OnDisable
DiggingGameMain.ComponentDefine = ComponentDefine
DiggingGameMain.ComponentDestroy = ComponentDestroy
DiggingGameMain.DataDefine = DataDefine
DiggingGameMain.DataDestroy = DataDestroy
return DiggingGameMain
