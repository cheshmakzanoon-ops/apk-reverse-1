local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local SeasonCallback = BaseClass("SeasonCallback", base)
local Localization = CS.GameEntry.Localization
local SeasonCallbackItem = require("UI.LWSeason.LWSeasonMain.Component.SeasonCallback.SeasonCallbackItem")
local TitleText_path = "RightView/Rect_Top/TitleText"
local TimeText_path = "RightView/Rect_Top/TimeInfoItem/timeBg2/TimeText"
local InfoText_path = "RightView/Rect_Top/InfoText"
local ScrollView_path = "RightView/Rect_Bottom/ScrollView"
local IntroBtn_path = "RightView/Rect_Top/InfoBtn"
local ImageBg_path = "ImageBg2"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  DataCenter.SeasonCallbackManager:SetView()
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
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.TitleText = nil
  self.TimeText = nil
  self.InfoText = nil
  self.ScrollView = nil
  self.IntroBtn = nil
  self.ImageBg = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonCallback:SetData(activityId)
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
  local path
  if not string.IsNullOrEmpty(data.activity_pic_full) then
    path = data.activity_pic_full
  elseif not string.IsNullOrEmpty(data.activity_pic) then
    path = string.format("Assets/Main/TextureEx/Season/S2/SeasonCallback/%s.png", data.activity_pic)
  end
  if path then
    self.ImageBg:LoadSpriteAuto(path, "Assets/Main/TextureEx/Season/S2/SeasonCallback/zyf_s2_liandong_bg.png")
  end
  self:RefreshView()
  self:Update1000MS()
  DataCenter.SeasonCallbackManager:TryQueryCallbackValue()
end

function SeasonCallback:RefreshView()
  self.listData, self.nextTime = DataCenter.SeasonCallbackManager:GetSeasonCallbackList(self.activityId)
  self:ClearScroll()
  self.EnableAnimation = true
  self.ScrollView:SetTotalCount(#self.listData)
  self.ScrollView:RefillCells()
  self.EnableAnimation = nil
end

function SeasonCallback:Update1000MS()
  if self.activityData ~= nil then
    local deltaTime = 0
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < self.StartTime then
      deltaTime = self.StartTime - curTime
    elseif curTime < self.EndTime then
      deltaTime = self.EndTime - curTime
    end
    if 0 < deltaTime then
      local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      self.TimeText:SetText(showTime)
      if self.nextTime ~= nil and 0 < self.nextTime and curTime > self.nextTime then
        self:RefreshView()
      end
    else
      self.TimeText:SetText("00:00:00")
    end
  end
end

local function ClearScroll(self)
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(SeasonCallbackItem)
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(SeasonCallbackItem, itemObj)
  cellItem:ReInit(index, self.listData[index])
  if self.EnableAnimation then
    cellItem:ShowFadeInEffect()
  end
end

local function OnItemMoveOut(self, itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, SeasonCallbackItem)
end

SeasonCallback.OnCreate = OnCreate
SeasonCallback.OnDestroy = OnDestroy
SeasonCallback.OnEnable = OnEnable
SeasonCallback.OnDisable = OnDisable
SeasonCallback.ComponentDefine = ComponentDefine
SeasonCallback.ComponentDestroy = ComponentDestroy
SeasonCallback.DataDefine = DataDefine
SeasonCallback.DataDestroy = DataDestroy
SeasonCallback.ClearScroll = ClearScroll
SeasonCallback.OnItemMoveIn = OnItemMoveIn
SeasonCallback.OnItemMoveOut = OnItemMoveOut
return SeasonCallback
