local ActivitySummaryItem = BaseClass("ActivitySummaryItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_path = "Image"
local name_path = "Image/name"
local stateDesc_path = "state"
local jumpBtn_path = "jumpBtn"
local newImg_path = "NewDot"
local redDot_path = "RedDot"
local redDotNum_path = "RedDot/redNum"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DelTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.iconN = self:AddComponent(UIImage, icon_path)
  self.nameN = self:AddComponent(UIText, name_path)
  self.stateDescN = self:AddComponent(UIText, stateDesc_path)
  self.stateDescN:SetActive(false)
  self.jumpBtnN = self:AddComponent(UIButton, jumpBtn_path)
  self.jumpBtnN:SetOnClick(function()
    self:OnClickJumpBtn()
  end)
  self.newImgN = self:AddComponent(UIBaseContainer, newImg_path)
  self.newImgN:SetActive(false)
  self.redDotN = self:AddComponent(UIBaseContainer, redDot_path)
  self.redDotN:SetActive(false)
  self.redDotNumN = self:AddComponent(UIText, redDotNum_path)
end

local function ComponentDestroy(self)
  self.iconN = nil
  self.nameN = nil
  self.stateDescN = nil
end

local function DataDefine(self)
  self.activityId = nil
  self.activityStatus = 0
end

local function DataDestroy(self)
  self.activityId = nil
  self.activityStatus = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshRed()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetItem(self, activityId)
  self.activityId = activityId
  self:RefreshAll()
end

local function RefreshAll(self)
  if not self.activityId then
    return
  end
  self:DelTimer()
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if not activityInfo then
    self.activityStatus = 2
    self.iconN:SetColor(GrayColor)
    self.nameN:SetText(Localization:GetString("370100"))
  else
    local serverTime = UITimeManager:GetInstance():GetServerTime()
    if serverTime < activityInfo.startTime then
      self.iconN:SetColor(GrayColor)
      local days = math.ceil((activityInfo.startTime - serverTime) / (OneDayTime * 1000))
      self.nameN:SetText(Localization:GetString("372365", days))
      self.activityStatus = 0
      self.timerEndT = activityInfo.startTime
      self:AddTimer()
      self:SetRemainTime()
    else
      self.iconN:SetColor(WhiteColor)
      self:DelTimer()
      self.nameN:SetText(Localization:GetString(activityInfo.name))
      self.activityStatus = 1
    end
  end
  self:RefreshRed()
end

local function RefreshRed(self)
  if not self.activityId then
    return
  end
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if not activityInfo then
    self.newImgN:SetActive(false)
    self.redDotN:SetActive(false)
    return
  end
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  if serverTime >= activityInfo.startTime and serverTime < activityInfo.endTime then
    local showNew = DataCenter.ActivityListDataManager:IsActivityNew(self.activityId)
    if showNew then
      self.newImgN:SetActive(true)
      self.redDotN:SetActive(false)
      return
    end
    self.newImgN:SetActive(false)
    local moduleRed = DataCenter.ActivityListDataManager:GetRewardNumByTypeAndId(activityInfo.type, activityInfo.id)
    if 0 < moduleRed then
      self.redDotN:SetActive(true)
      self.redDotNumN:SetText(moduleRed)
    else
      self.redDotN:SetActive(false)
    end
  else
    self.newImgN:SetActive(false)
    self.redDotN:SetActive(false)
  end
end

local function AddTimer(self)
  function self.TimerAction()
    self:SetRemainTime()
  end
  
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
  end
  self.timer:Start()
end

local function SetRemainTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.timerEndT - curTime
  if 0 < remainTime then
  else
    self.nameN:SetText("")
    self:DelTimer()
    self:RefreshAll()
  end
end

local function DelTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function OnClickJumpBtn(self)
  if self.activityStatus == 1 then
    DataCenter.ThemeActivityManager:SetAsOldActivity(EnumActivity.ActivitySummary.Type, self.activityId)
    self.newImgN:SetActive(false)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, {
      anim = true,
      hideTop = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, tonumber(self.activityId))
  elseif self.activityStatus == 0 then
    UIUtil.ShowTips(Localization:GetString("E100172"))
  else
    UIUtil.ShowTips(Localization:GetString("370100"))
  end
end

ActivitySummaryItem.OnCreate = OnCreate
ActivitySummaryItem.OnDestroy = OnDestroy
ActivitySummaryItem.ComponentDefine = ComponentDefine
ActivitySummaryItem.ComponentDestroy = ComponentDestroy
ActivitySummaryItem.DataDefine = DataDefine
ActivitySummaryItem.DataDestroy = DataDestroy
ActivitySummaryItem.OnEnable = OnEnable
ActivitySummaryItem.OnDisable = OnDisable
ActivitySummaryItem.SetItem = SetItem
ActivitySummaryItem.RefreshAll = RefreshAll
ActivitySummaryItem.RefreshRed = RefreshRed
ActivitySummaryItem.AddTimer = AddTimer
ActivitySummaryItem.SetRemainTime = SetRemainTime
ActivitySummaryItem.DelTimer = DelTimer
ActivitySummaryItem.OnClickJumpBtn = OnClickJumpBtn
return ActivitySummaryItem
