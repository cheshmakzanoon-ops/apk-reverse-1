local UIMainAllianceCompeteBtn = BaseClass("UIMainAllianceCompeteBtn", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local this_path = ""
local alCompeteRedDot_path = "RedPointNum"
local alCompeteRedNumTxt_path = "RedPointNum/Text"
local alCompeteStart_path = "TimeBg"
local alCompeteStartTime_path = "TimeBg/alCompeteOpenT"

function UIMainAllianceCompeteBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMainAllianceCompeteBtn:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMainAllianceCompeteBtn:ComponentDefine()
  self.allianceCompeteBtn = self:AddComponent(UIButton, this_path)
  self.allianceCompeteBtn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.alCompeteRedDot = self:AddComponent(UIBaseContainer, alCompeteRedDot_path)
  self.alCompeteRedNumN = self:AddComponent(UIText, alCompeteRedNumTxt_path)
  self.alCompeteOpenTime = self:AddComponent(UIBaseContainer, alCompeteStart_path)
  self.alCompeteOpenTimeTxt = self:AddComponent(UIText, alCompeteStartTime_path)
end

function UIMainAllianceCompeteBtn:ComponentDestroy()
end

function UIMainAllianceCompeteBtn:DataDefine()
  self.alCompeteNoticeEndT = nil
  
  function self.timer_call_back()
    self:RefreshPerSecond()
  end
end

function UIMainAllianceCompeteBtn:DataDestroy()
  self:RemoveTimer()
end

function UIMainAllianceCompeteBtn:ReInit()
  self:RefreshAlCompeteBtn()
end

function UIMainAllianceCompeteBtn:Refresh()
end

function UIMainAllianceCompeteBtn:OnEnable()
  base.OnEnable(self)
end

function UIMainAllianceCompeteBtn:OnDisable()
  base.OnDisable(self)
end

function UIMainAllianceCompeteBtn:RefreshAlCompeteBtn()
  local showAlCompeteBtn = DataCenter.AllianceCompeteDataManager:CheckIfAllianceCompeteOpen()
  if showAlCompeteBtn then
    self.allianceCompeteBtn:SetActive(true)
    local alCompeteRedCount = DataCenter.AllianceCompeteDataManager:GetAlCompeteteTotalRedCount()
    local isSubmitting = DataCenter.LeagueMatchManager:CheckIsSubmitting()
    if isSubmitting then
      self.alCompeteOpenTime:SetActive(true)
      self.alCompeteOpenTimeTxt:SetLocalText(372118)
      local serverT = UITimeManager:GetInstance():GetServerTime()
      local strToday = UITimeManager:GetInstance():TimeStampToDayForLocal(serverT)
      local strKey = "AlCompeteResult_" .. LuaEntry.Player.uid .. "_" .. strToday
      local isFirstEnter = Setting:GetInt(strKey, 0)
      if not isSubmitting and isFirstEnter == 0 then
        alCompeteRedCount = alCompeteRedCount + 1
      end
    else
      self:TryShowAlCompeteNoticeTime()
    end
    if 0 < alCompeteRedCount then
      self.alCompeteRedDot:SetActive(true)
      self.alCompeteRedNumN:SetText(alCompeteRedCount)
    else
      self.alCompeteRedDot:SetActive(false)
    end
  else
    self.allianceCompeteBtn:SetActive(false)
    UIManager.Instance:DestroyWindow(UIWindowNames.UIAllianceCompeteNew)
  end
end

function UIMainAllianceCompeteBtn:TryShowAlCompeteNoticeTime()
  self.alCompeteNoticeEndT = nil
  self.alCompeteOpenTime:SetActive(false)
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if not actInfo then
    return
  end
  if actInfo.preOpenTime then
    self.alCompeteNoticeEndT = actInfo.preOpenTime
    self:AddTimer()
  end
end

function UIMainAllianceCompeteBtn:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_call_back, self, false, false, false)
  end
  self.timer:Start()
end

function UIMainAllianceCompeteBtn:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIMainAllianceCompeteBtn:RefreshPerSecond()
  local needTimer = self:RefreshAlCompeteNoticeRemainT()
  if not needTimer then
    self:RemoveTimer()
  end
end

function UIMainAllianceCompeteBtn:RefreshAlCompeteNoticeRemainT()
  if not self.alCompeteNoticeEndT then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.alCompeteNoticeEndT - curTime
  if 0 < remainTime then
    self.alCompeteOpenTime:SetActive(true)
    self.alCompeteOpenTimeTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    return true
  else
    self.alCompeteNoticeEndT = nil
    self.alCompeteOpenTime:SetActive(false)
    return false
  end
end

function UIMainAllianceCompeteBtn:OnBtnClick()
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if not actInfo then
    return
  end
  if actInfo.preOpenTime then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAlCompeteNotice, {anim = true})
  else
    if DataCenter.LeagueMatchManager:CheckIsSubmitting() then
      UIUtil.ShowTipsId("372118")
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCompeteNew, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  end
end

return UIMainAllianceCompeteBtn
