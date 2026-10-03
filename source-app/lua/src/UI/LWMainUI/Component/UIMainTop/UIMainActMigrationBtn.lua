local UIMainActMigrationBtn = BaseClass("UIMainActMigrationBtn", UIBaseContainer)
local base = UIBaseContainer
local this_path = ""
local alCompeteRedDot_path = "RedPointNum"
local alCompeteRedNumTxt_path = "RedPointNum/Text"
local alCompeteStart_path = "TimeBg"
local alCompeteStartTime_path = "TimeBg/alCompeteOpenT"

function UIMainActMigrationBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.nextTime = 0
  
  function self.timer_call_back()
    self:RefreshPerSecond()
  end
end

function UIMainActMigrationBtn:OnDestroy()
  self:RemoveTimer()
  base.OnDestroy(self)
end

function UIMainActMigrationBtn:ComponentDefine()
  self.allianceCompeteBtn = self:AddComponent(UIButton, this_path)
  self.allianceCompeteBtn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.alCompeteRedDot = self:AddComponent(UIBaseContainer, alCompeteRedDot_path)
  self.alCompeteRedNumN = self:AddComponent(UIText, alCompeteRedNumTxt_path)
  self.alCompeteOpenTime = self:AddComponent(UIBaseContainer, alCompeteStart_path)
  self.alCompeteOpenTimeTxt = self:AddComponent(UIText, alCompeteStartTime_path)
  self.btnImg = self:AddComponent(UIImage, "Image")
end

function UIMainActMigrationBtn:ReInit()
  self:RefreshAlCompeteBtn()
end

function UIMainActMigrationBtn:RefreshAlCompeteBtn()
  self:RemoveTimer()
  if not RaceEntranceUtil.IsNewMigration() then
    self:SetActive(false)
    return
  end
  local mgr = DataCenter.ActMigrationManager
  self.activityId = mgr:GetCurActId(true)
  if self.activityId == nil then
    self:SetActive(false)
    return
  end
  local actInfo = mgr:GetActInfo()
  if actInfo == nil then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self:RefreshRedPoint()
  local eTime = actInfo.endTime or 0
  self.nextTime = eTime
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if eTime - curTime <= 0 then
    self.alCompeteOpenTimeTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(0))
    mgr:ReqActInfo()
  else
    self:AddTimer()
  end
end

function UIMainActMigrationBtn:AddTimer()
  self:RemoveTimer()
  self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_call_back, self, false, false, false)
  self.timer:Start()
end

function UIMainActMigrationBtn:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIMainActMigrationBtn:RefreshPerSecond()
  local timeMgr = UITimeManager:GetInstance()
  local curSec = timeMgr:GetServerTime()
  local remainTime = self.nextTime - curSec
  if 0 < remainTime then
    self.alCompeteOpenTimeTxt:SetText(timeMgr:MilliSecondToFmtString(remainTime))
  elseif self.alCompeteOpenTime:GetActive() then
    self.alCompeteOpenTimeTxt:SetText(timeMgr:MilliSecondToFmtString(0))
    self:RefreshAlCompeteBtn()
  end
end

function UIMainActMigrationBtn:OnBtnClick()
  DataCenter.ActMigrationManager:GoToView(self.activityId)
end

function UIMainActMigrationBtn:RefreshRedPoint()
  local redCount = DataCenter.ActMigrationManager:GetRedNum()
  if 0 < redCount then
    self.alCompeteRedDot:SetActive(true)
    self.alCompeteRedNumN:SetText(redCount)
  else
    self.alCompeteRedDot:SetActive(false)
  end
end

function UIMainActMigrationBtn:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActMigrationInfoUpdate, self.RefreshRedPoint)
end

function UIMainActMigrationBtn:OnRemoveListener()
  self:RemoveUIListener(EventId.ActMigrationInfoUpdate, self.RefreshRedPoint)
  base.OnRemoveListener(self)
end

return UIMainActMigrationBtn
