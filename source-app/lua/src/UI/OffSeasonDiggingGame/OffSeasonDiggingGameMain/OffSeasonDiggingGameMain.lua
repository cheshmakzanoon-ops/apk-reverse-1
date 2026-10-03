local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local OffSeasonDiggingGameMain = BaseClass("OffSeasonDiggingGameMain", base)
local Localization = CS.GameEntry.Localization
local DiggingInfoItem = require("UI.OffSeasonDiggingGame.OffSeasonDiggingGameMain.Component.OffSeasonDiggingInfoItem")
local TitleText_path = "root/Rect_Top/LeftRoot/TitleText"
local TimeText_path = "root/Rect_Top/LeftRoot/TimeInfoItem/timeBg2/TimeText"
local InfoText_path = "root/Rect_Top/LeftRoot/InfoText"
local ScrollView_path = "root/Rect_Bottom/ScrollView"
local IntroBtn_path = "root/Rect_Top/InfoBtn"
local ImageBg_path = "mask/ImageBg2"
local Item1_path = "root/Rect_Top/LeftRoot/UICommonResItem1"
local Item2_path = "root/Rect_Top/LeftRoot/UICommonResItem2"
local useBtn_path = "root/Rect_Top/LeftRoot/UICommonResItem1/UseBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.rootAni:Play("V_ui_DiggingGameMain_in")
  SFSNetwork.SendMessage(MsgDefines.OffSeasonDigActivityInfo)
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
  self.useBtn = self:AddComponent(UIButton, useBtn_path)
  self.useBtn:SetOnClick(function()
    self:OnClickUseBtn()
  end)
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
  self.rootAni = self:AddComponent(UIAnimator, "")
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
  if self.Timer then
    self.Timer:Stop()
    self.Timer = nil
  end
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function OffSeasonDiggingGameMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DiggingGameMapListInfo, self.RefreshView)
  self:AddUIListener(EventId.DiggingGameMapDataGetReward, self.UpdateReward)
  self:AddUIListener(EventId.UseItemSuccess, self.UseItemSuccess)
  self:AddUIListener(EventId.DiggingLevelAllianceClose, self.OnDiggingLevelAllianceClose)
end

function OffSeasonDiggingGameMain:OnRemoveListener()
  self:RemoveUIListener(EventId.DiggingGameMapListInfo, self.RefreshView)
  self:RemoveUIListener(EventId.DiggingGameMapDataGetReward, self.UpdateReward)
  self:RemoveUIListener(EventId.UseItemSuccess, self.UseItemSuccess)
  self:RemoveUIListener(EventId.DiggingLevelAllianceClose, self.OnDiggingLevelAllianceClose)
  base.OnRemoveListener(self)
end

function OffSeasonDiggingGameMain:SetData(activityId)
  base.SetData(self, activityId)
  local data = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if data == nil then
    return
  end
  self.activityData = data
  self.TitleText:SetLocalText(data.name)
  self.InfoText:SetLocalText(data.desc_info)
  self.StartTime = data.startTime
  self.EndTime = data.endTime
  if not string.IsNullOrEmpty(data.activity_pic) then
    self.ImageBg:LoadSprite(string.format(LoadPath.UIDiggingTex, data.activity_pic), string.format(LoadPath.UIDiggingTex, "ljq_saijis3_yindiannaqiongsi_bg_01"))
    self.ImageBg:SetNativeSize()
  end
  self:RefreshView()
  self:Update1000MS()
end

function OffSeasonDiggingGameMain:RefreshView()
  self.mapList = DataCenter.OffSeasonDiggingDataManager:GetMapList()
  if self.mapList then
    self:ClearScroll()
    self.EnableAnimation = true
    self.ScrollView:SetTotalCount(#self.mapList)
    self.ScrollView:RefillCells()
    self.EnableAnimation = nil
  end
  self:RefreshItem()
end

function OffSeasonDiggingGameMain:Update1000MS()
  if self.activityData then
    UIUtil.SetLeftTimeText(self.TimeText, self.StartTime, self.EndTime)
  end
end

function OffSeasonDiggingGameMain:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(DiggingInfoItem)
end

function OffSeasonDiggingGameMain:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(DiggingInfoItem, itemObj)
  cellItem:ReInit(index, self.mapList[index], self)
  if self.EnableAnimation then
    cellItem:ShowFadeInEffect()
  end
end

function OffSeasonDiggingGameMain:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, DiggingInfoItem)
end

function OffSeasonDiggingGameMain:UpdateReward()
  SFSNetwork.SendMessage(MsgDefines.OffSeasonDigActivityInfo)
end

function OffSeasonDiggingGameMain:RefreshItem()
  local itemId = self:GetUseItemId()
  local itemCount1 = DataCenter.ItemData:GetItemCount(itemId)
  local itemData1 = {
    itemId = itemId,
    rewardType = RewardType.GOODS,
    count = itemCount1
  }
  self.resItem1:ReInit(itemData1)
end

function OffSeasonDiggingGameMain:UseItemSuccess(itemId)
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  if not template or template.type ~= GOODS_TYPE.GOODS_TYPE_178 then
    return
  end
  self:RefreshItem()
  SFSNetwork.SendMessage(MsgDefines.OffSeasonDigActivityInfo)
end

function OffSeasonDiggingGameMain:OnClickUseBtn()
  local itemId = self:GetUseItemId()
  local itemData = DataCenter.ItemData:GetItemById(itemId)
  if not (itemData and itemData.count) or itemData.count <= 0 then
    UIUtil.ShowTipsId("parkour_not_enough_treasure_tips")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ItemUse, {
    uuid = itemData.uuid,
    num = 1
  })
end

function OffSeasonDiggingGameMain:GetUseItemId()
  if not self.itemId then
    local data = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    if data then
      self.itemId = tonumber(data.para_1)
    end
  end
  return self.itemId
end

function OffSeasonDiggingGameMain:PlayOpenMapAnimation(callback)
  if self.Timer then
    return
  end
  self.rootAni:Play("V_ui_DiggingGameMain_out")
  self.Timer = TimerManager:GetInstance():DelayInvoke(function()
    self.Timer = nil
    callback()
  end, 0.5)
end

function OffSeasonDiggingGameMain:OnDiggingLevelAllianceClose()
  self.rootAni:Play("V_ui_DiggingGameMain_switch")
end

OffSeasonDiggingGameMain.OnCreate = OnCreate
OffSeasonDiggingGameMain.OnDestroy = OnDestroy
OffSeasonDiggingGameMain.OnEnable = OnEnable
OffSeasonDiggingGameMain.OnDisable = OnDisable
OffSeasonDiggingGameMain.ComponentDefine = ComponentDefine
OffSeasonDiggingGameMain.ComponentDestroy = ComponentDestroy
OffSeasonDiggingGameMain.DataDefine = DataDefine
OffSeasonDiggingGameMain.DataDestroy = DataDestroy
return OffSeasonDiggingGameMain
