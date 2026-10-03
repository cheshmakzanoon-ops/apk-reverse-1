local UIMainActMeteoriteBtn = BaseClass("UIMainActMeteoriteBtn", UIBaseContainer)
local base = UIBaseContainer
local this_path = ""
local alCompeteRedDot_path = "RedPointNum"
local alCompeteRedNumTxt_path = "RedPointNum/Text"
local alCompeteStart_path = "TimeBg"
local alCompeteStartTime_path = "TimeBg/alCompeteOpenT"

function UIMainActMeteoriteBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.nextTime = 0
  
  function self.timer_call_back()
    self:RefreshPerSecond()
  end
end

function UIMainActMeteoriteBtn:OnDestroy()
  self:RemoveTimer()
  base.OnDestroy(self)
end

function UIMainActMeteoriteBtn:ComponentDefine()
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

function UIMainActMeteoriteBtn:ReInit()
  self:RefreshAlCompeteBtn()
end

function UIMainActMeteoriteBtn:RefreshAlCompeteBtn()
  self:RemoveTimer()
  if not RaceEntranceUtil.IsOldEntranceOpen() then
    self:SetActive(false)
    return
  end
  local mgr = DataCenter.ActMeteoriteBattleManager
  local showBtn = mgr:CheckIfActOpen()
  if showBtn then
    local actInfo = mgr:GetActInfo() or {}
    self.nextTime = actInfo.stageEndTime or 0
    local updateFlag = true
    local reqFlag = false
    local curSec = UITimeManager:GetInstance():GetServerSeconds()
    if self.nextTime - curSec <= 0 then
      if actInfo.stage == MeteoriteState.SHOW then
        updateFlag = false
      else
        reqFlag = true
      end
    end
    if updateFlag then
      self.alCompeteOpenTime:SetActive(false)
      self:SetActive(true)
      self:RefreshRedPoint()
      if reqFlag then
        mgr:ReqGetActInfo()
      else
        self:AddTimer()
      end
      return
    end
  end
  self:SetActive(false)
  UIManager.Instance:DestroyWindow(UIWindowNames.LWActMeteoriteAward)
  UIManager.Instance:DestroyWindow(UIWindowNames.LWActMeteoriteMain)
end

function UIMainActMeteoriteBtn:AddTimer()
  self:RemoveTimer()
  self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_call_back, self, false, false, false)
  self.timer:Start()
end

function UIMainActMeteoriteBtn:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIMainActMeteoriteBtn:RefreshPerSecond()
  local timeMgr = UITimeManager:GetInstance()
  local curSec = timeMgr:GetServerSeconds()
  local remainTime = self.nextTime - curSec
  if 0 < remainTime then
    self.alCompeteOpenTime:SetActive(true)
    self.alCompeteOpenTimeTxt:SetText(timeMgr:SecondToFmtString(remainTime))
  elseif self.alCompeteOpenTime:GetActive() then
    self:RemoveTimer()
    self.alCompeteOpenTimeTxt:SetText(timeMgr:SecondToFmtString(0))
    self.alCompeteOpenTime:SetActive(false)
    self:RefreshAlCompeteBtn()
  end
end

function UIMainActMeteoriteBtn:OnBtnClick()
  DataCenter.ActMeteoriteBattleManager:OpenActWindowPls()
end

function UIMainActMeteoriteBtn:RefreshRedPoint()
  local alCompeteRedCount = DataCenter.ActMeteoriteBattleManager:GetTotalRedCount()
  if 0 < alCompeteRedCount then
    self.alCompeteRedDot:SetActive(true)
    self.alCompeteRedNumN:SetText(alCompeteRedCount)
  else
    self.alCompeteRedDot:SetActive(false)
  end
end

function UIMainActMeteoriteBtn:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MeteoriteBattleScoreUpdate, self.RefreshRedPoint)
  self:AddUIListener(EventId.MeteoriteBattleRewardsRefresh, self.RefreshRedPoint)
end

function UIMainActMeteoriteBtn:OnRemoveListener()
  self:RemoveUIListener(EventId.MeteoriteBattleScoreUpdate, self.RefreshRedPoint)
  self:RemoveUIListener(EventId.MeteoriteBattleRewardsRefresh, self.RefreshRedPoint)
  base.OnRemoveListener(self)
end

return UIMainActMeteoriteBtn
