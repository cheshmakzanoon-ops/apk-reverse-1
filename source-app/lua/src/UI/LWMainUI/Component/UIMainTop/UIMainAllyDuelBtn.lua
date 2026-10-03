local UIMainAllyDuelBtn = BaseClass("UIMainAllyDuelBtn", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local this_path = ""
local alCompeteStart_path = "TimeBg"
local alCompeteStartTime_path = "TimeBg/alCompeteOpenT"
local Common_red_point_path = "CommonRedPoint"

function UIMainAllyDuelBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  DataCenter.AllyDuelScoreGachaManager:SendGetGachaInfoMessage()
end

function UIMainAllyDuelBtn:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMainAllyDuelBtn:ComponentDefine()
  self.allianceCompeteBtn = self:AddComponent(UIButton, this_path)
  self.allianceCompeteBtn:SetOnClick(function()
    self.allyDuelCommonRedPoint:SetViewed()
    self:OnBtnClick()
  end)
  self.allyDuelCommonRedPoint = self:AddComponent(UICommonRedPoint, Common_red_point_path)
  self.allyDuelCommonRedPoint:SetType(CommonRedPointPriority.Level1)
  self.alCompeteOpenTime = self:AddComponent(UIBaseContainer, alCompeteStart_path)
  self.alCompeteOpenTimeTxt = self:AddComponent(UIText, alCompeteStartTime_path)
  self.btnImg = self:AddComponent(UIImage, "Image")
end

function UIMainAllyDuelBtn:ComponentDestroy()
end

function UIMainAllyDuelBtn:DataDefine()
  self.allyDuelNextTime = nil
  
  function self.timer_call_back()
    self:RefreshPerSecond()
  end
end

function UIMainAllyDuelBtn:DataDestroy()
  self:RemoveTimer()
end

function UIMainAllyDuelBtn:ReInit()
  self:RefreshAlCompeteBtn()
end

function UIMainAllyDuelBtn:Refresh()
end

function UIMainAllyDuelBtn:OnEnable()
  base.OnEnable(self)
end

function UIMainAllyDuelBtn:OnDisable()
  base.OnDisable(self)
end

function UIMainAllyDuelBtn:RefreshAlCompeteBtn()
  local showAlCompeteBtn = DataCenter.AllianceCompeteDataManager:CheckIfAllianceCompeteOpen()
  if showAlCompeteBtn then
    self:SetActive(true)
    local isSubmitting = DataCenter.LeagueMatchManager:CheckIsSubmitting()
    if isSubmitting then
      self.alCompeteOpenTime:SetActive(true)
      self.alCompeteOpenTimeTxt:SetLocalText(372118)
    else
      self:TryShowAlCompeteNoticeTime()
    end
    self:RefreshRedPoint()
    if DataCenter.LeagueMatchManager:CheckIsOpenForReward() then
      self.btnImg:LoadSprite("Assets/Main/Sprites/UI/UIMain/LWMainUI/lrb_vsjin_icon.png")
    else
      self.btnImg:LoadSprite("Assets/Main/Sprites/UI/UIMain/LWMainUI/lrb_lianmengduijue_tubiao.png")
    end
  else
    self:SetActive(false)
    UIManager.Instance:DestroyWindow(UIWindowNames.UIAllianceCompeteNew)
  end
end

function UIMainAllyDuelBtn:TryShowAlCompeteNoticeTime()
  self.allyDuelNextTime = nil
  self.alCompeteOpenTime:SetActive(false)
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if not actInfo then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local preOpen = actInfo.preOpenTime
  local start = actInfo.startTime
  local finish = actInfo.endTime
  local ready = actInfo.readyTime
  if preOpen and now < preOpen then
    self.allyDuelNextTime = preOpen
    self:AddTimer()
  elseif start and finish and now > start and now < finish then
    self.allyDuelNextTime = finish
    self:AddTimer()
  elseif start and ready and now > ready and now < start then
    self.allyDuelNextTime = start
    self:AddTimer()
  end
end

function UIMainAllyDuelBtn:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_call_back, self, false, false, false)
  end
  self.timer:Start()
end

function UIMainAllyDuelBtn:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIMainAllyDuelBtn:RefreshPerSecond()
  local needTimer = self:RefreshAlCompeteNoticeRemainT()
  if not needTimer then
    self:RemoveTimer()
  end
end

function UIMainAllyDuelBtn:RefreshAlCompeteNoticeRemainT()
  if not self.allyDuelNextTime then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.allyDuelNextTime - curTime
  if 0 < remainTime then
    self.alCompeteOpenTime:SetActive(true)
    self.alCompeteOpenTimeTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    return true
  else
    self.allyDuelNextTime = nil
    self.alCompeteOpenTime:SetActive(false)
    return false
  end
end

function UIMainAllyDuelBtn:OnBtnClick()
  DataCenter.AllianceCompeteDataManager:TryOpenAllyDuelUI()
end

function UIMainAllyDuelBtn:RefreshRedPoint()
  local alCompeteRedCount, reward, tip = DataCenter.AllianceCompeteDataManager:GetAlCompeteteTotalRedCount()
  alCompeteRedCount = alCompeteRedCount + DataCenter.AllyDuelScoreGachaManager:GetTotalRedDotNum()
  reward = reward + DataCenter.AllyDuelScoreGachaManager:GetTotalRedDotNum()
  local zeroTime = UITimeManager:GetInstance():GetTomorrowZero()
  local lastTotalRedNum = CommonUtil.PlayerPrefsGetInt(SettingKeys.ALLY_DUEL_BTN_TOTAL_LAST_RED .. zeroTime, 0)
  if 0 < alCompeteRedCount then
    local weekDayIndex = UITimeManager:GetInstance():GetNowWeekdayIndex()
    if weekDayIndex < 7 then
      if alCompeteRedCount ~= lastTotalRedNum then
        self.allyDuelCommonRedPoint:SetNum(reward, tip)
      else
        self.allyDuelCommonRedPoint:SetActive(false)
      end
    else
      self.allyDuelCommonRedPoint:SetNum(reward, tip)
    end
  else
    self.allyDuelCommonRedPoint:SetActive(false)
  end
end

function UIMainAllyDuelBtn:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllyDuelScoreRefresh, self.RefreshRedPoint)
  self:AddUIListener(EventId.OnMyLeagueMatchInfoUpdate, self.RefreshAlCompeteBtn)
  self:AddUIListener(EventId.AllyDuelScoreGachaWishClaim, self.RefreshRedPoint)
  self:AddUIListener(EventId.AllyDuelScoreGachaUpdateScore, self.RefreshRedPoint)
  self:AddUIListener(EventId.AllyDuelBtnRedPointUpdate, self.RefreshRedPoint)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
end

function UIMainAllyDuelBtn:OnRemoveListener()
  self:RemoveUIListener(EventId.AllyDuelScoreRefresh, self.RefreshRedPoint)
  self:RemoveUIListener(EventId.OnMyLeagueMatchInfoUpdate, self.RefreshAlCompeteBtn)
  self:RemoveUIListener(EventId.AllyDuelScoreGachaWishClaim, self.RefreshRedPoint)
  self:RemoveUIListener(EventId.AllyDuelScoreGachaUpdateScore, self.RefreshRedPoint)
  self:RemoveUIListener(EventId.AllyDuelBtnRedPointUpdate, self.RefreshRedPoint)
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
  base.OnRemoveListener(self)
end

function UIMainAllyDuelBtn:OnPassDay()
  DataCenter.AllyDuelScoreGachaManager:SendGetGachaInfoMessage()
end

return UIMainAllyDuelBtn
