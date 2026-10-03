local ActivityTipContent = BaseClass("ActivityTipContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local monsterInvasionTipTimeKey = "Monster_Invasion_Tip_Time_Key"

function ActivityTipContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function ActivityTipContent:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function ActivityTipContent:ComponentDefine()
  self.tip = self:AddComponent(UIButton, "")
  self.tip:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.tipBtn = self:AddComponent(UIButton, "gotoBtn")
  self.tipBtn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.tipTxt = self:AddComponent(UIText, "tipTxt")
  self.tip:SetActive(false)
end

function ActivityTipContent:ComponentDestroy()
  self.tip = nil
  self.tipBtn = nil
  self.tipTxt = nil
end

function ActivityTipContent:DataDefine()
  self.targetActId = nil
  self.targetActData = nil
  self.hideTime = 0
  
  function self.timer_call_back()
    self:RefreshPerSecond()
  end
end

function ActivityTipContent:DataDestroy()
  self.targetActId = nil
  self.targetActData = nil
  self.hideTime = nil
  self.timer_call_back = nil
  self:RemoveTimer()
end

function ActivityTipContent:ReInit()
  self:RefreshView()
end

function ActivityTipContent:RefreshView()
  local showTip = self:CheckNeedShowActTip()
  if showTip then
    self.tip:SetActive(true)
    local showStr = self:GetShowStr()
    self.tipTxt:SetText(showStr)
    self:RemoveTimer()
    self:AddTimer()
  else
    self.tip:SetActive(false)
  end
end

function ActivityTipContent:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_call_back, self, false, false, false)
  end
  self.timer:Start()
end

function ActivityTipContent:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function ActivityTipContent:RefreshPerSecond()
  local needTimer = self:RefreshTimeView()
  if not needTimer then
    self:RemoveTimer()
    self.tip:SetActive(false)
    self:RecordCurActTipTime()
  end
end

function ActivityTipContent:RefreshTimeView()
  if not self.hideTime then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.hideTime - curTime
  if 0 < remainTime then
    return true
  else
    return false
  end
end

function ActivityTipContent:OnBtnClick()
  local actData = self.targetActData
  if actData then
    GoToUtil.GotoOpenView(UIWindowNames.UIActivityCenterTable, actData.id)
  end
  self:RecordCurActTipTime()
end

function ActivityTipContent:CheckNeedShowActTip()
  self.targetActId = nil
  self.hideTime = 0
  local dataList = {}
  local lastOpenTime = 0
  local todayZero = UITimeManager:GetInstance():TodayZero()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.targetActId == nil then
    dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.MonsterInvasion.Type)
    lastOpenTime = CommonUtil.PlayerPrefsGetLong(monsterInvasionTipTimeKey, 0)
    if 0 < #dataList and todayZero > lastOpenTime then
      local activityData = dataList[1]
      self.targetActId = activityData.id
      self.targetActData = activityData
      self.hideTime = math.min(curTime + 8000, activityData.endTime)
    end
  end
  return self.targetActId ~= nil
end

function ActivityTipContent:GetShowStr()
  local actData = self.targetActData
  local showStr = ""
  if actData and actData.type == EnumActivity.MonsterInvasion.Type then
    showStr = Localization:GetString("2901001")
  end
  return showStr
end

function ActivityTipContent:RecordCurActTipTime()
  local actData = self.targetActData
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if actData and actData.type == EnumActivity.MonsterInvasion.Type then
    CommonUtil.PlayerPrefsSetLong(monsterInvasionTipTimeKey, curTime)
  end
end

return ActivityTipContent
