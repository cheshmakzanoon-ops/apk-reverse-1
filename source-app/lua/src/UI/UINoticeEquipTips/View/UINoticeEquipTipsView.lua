local UINoticeEquipTipsView = BaseClass("UINoticeEquipTipsView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UINoticeEquipTipsView:OnCreate()
  base.OnCreate(self)
  local param, activityId = self:GetUserData()
  self.param = param
  self.activityId = activityId
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UINoticeEquipTipsView:ComponentDefine()
  self._content_txt = self:AddComponent(UIText, "Root/Rect_Top/Txt_Content")
  self.scorePoint = {}
  for i = 1, 4 do
    local point = "Root/Rect_Progress/Points" .. "/Num_" .. i
    self.scorePoint[i] = self:AddComponent(UIText, point)
  end
  self.root = self:AddComponent(UIBaseContainer, "Root")
  self.animator = self:AddComponent(UIAnimator, "")
  self.sliderGreen = self:AddComponent(UISlider, "Root/Rect_Progress/Slider")
  self.slider1 = self:AddComponent(UISlider, "Root/Rect_Progress/Slider1")
  self.slider2 = self:AddComponent(UISlider, "Root/Rect_Progress/Slider2")
  self.slider3 = self:AddComponent(UISlider, "Root/Rect_Progress/Slider3")
end

function UINoticeEquipTipsView:DataDefine()
  self.actId = false
end

function UINoticeEquipTipsView:OnDestroy()
  self.hero_rect = nil
  self.hero = nil
  self.hero_txt = nil
  self.anim = nil
  self.initSizeDeltaX = nil
  self.actId = nil
  base.OnDestroy(self)
end

function UINoticeEquipTipsView:OnEnable()
  base.OnEnable(self)
  self.active = true
end

function UINoticeEquipTipsView:OnDisable()
  self.active = false
  base.OnDisable(self)
end

function UINoticeEquipTipsView:OnAddListener()
  base.OnAddListener(self)
end

function UINoticeEquipTipsView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UINoticeEquipTipsView:SetUI(last)
  if last <= self.eventInfo.rewardScoreIndexArr[1] then
    self.slider1:SetValue(last / self.eventInfo.rewardScoreIndexArr[1])
    self.slider2:SetValue(0)
    self.slider3:SetValue(0)
  elseif last > self.eventInfo.rewardScoreIndexArr[1] and last <= self.eventInfo.rewardScoreIndexArr[2] then
    self.slider1:SetValue(1)
    self.slider2:SetValue((last - self.eventInfo.rewardScoreIndexArr[1]) / (self.eventInfo.rewardScoreIndexArr[2] - self.eventInfo.rewardScoreIndexArr[1]))
    self.slider3:SetValue(0)
  elseif last > self.eventInfo.rewardScoreIndexArr[2] and last < self.eventInfo.rewardScoreIndexArr[3] then
    self.slider1:SetValue(1)
    self.slider2:SetValue(1)
    self.slider3:SetValue((last - self.eventInfo.rewardScoreIndexArr[2]) / (self.eventInfo.rewardScoreIndexArr[3] - self.eventInfo.rewardScoreIndexArr[2]))
  elseif last >= self.eventInfo.rewardScoreIndexArr[3] then
    self.slider1:SetValue(1)
    self.slider2:SetValue(1)
    self.slider3:SetValue(1)
    TimerManager:GetInstance():DelayInvoke(function()
      if self.active then
        self.ctrl:CloseSelf()
      end
    end, 1)
    return
  end
end

function UINoticeEquipTipsView:Check(last, total)
  local threshold, newShold
  if last <= self.eventInfo.rewardScoreIndexArr[1] then
    threshold = self.eventInfo.rewardScoreIndexArr[1]
  elseif last <= self.eventInfo.rewardScoreIndexArr[2] then
    threshold = self.eventInfo.rewardScoreIndexArr[2]
  elseif last <= self.eventInfo.rewardScoreIndexArr[3] then
    threshold = self.eventInfo.rewardScoreIndexArr[3]
  elseif last > self.eventInfo.rewardScoreIndexArr[3] then
    threshold = self.eventInfo.rewardScoreIndexArr[3]
  end
  if total <= self.eventInfo.rewardScoreIndexArr[1] then
    newShold = self.eventInfo.rewardScoreIndexArr[1]
  elseif total <= self.eventInfo.rewardScoreIndexArr[2] then
    newShold = self.eventInfo.rewardScoreIndexArr[2]
  elseif total <= self.eventInfo.rewardScoreIndexArr[3] then
    newShold = self.eventInfo.rewardScoreIndexArr[3]
  elseif total > self.eventInfo.rewardScoreIndexArr[3] then
    newShold = self.eventInfo.rewardScoreIndexArr[3]
  end
  return threshold, newShold
end

function UINoticeEquipTipsView:ReInit()
  local eventInfo = DataCenter.ActPersonalArmsInfo:GetEventInfo(self.activityId)
  self.eventInfo = eventInfo
  for i = 1, 4 do
    if i == 1 then
      self.scorePoint[i]:SetText("0")
    else
      self.scorePoint[i]:SetText(string.GetFormattedSeperatorNum(self.eventInfo.rewardScoreIndexArr[i - 1]))
    end
  end
  self._content_txt:SetText(Localization:GetString("372160", self.param.addScore))
  local total = tonumber(self.param.score)
  local add = tonumber(self.param.addScore)
  local last = total - add
  self:SetUI(last)
  self.animator:Enable(true)
  local rootRt = self.root.transform
  DOTween.Kill(rootRt)
  rootRt:Set_localScale(1, 1, 1)
  local ret, time = self.animator:GetAnimationReturnTime("UIRecruitLotteryTip_show")
  local showTime = (ret and time or 0) + 0.2
  local isTwo = false
  local tempScore = self.eventInfo.rewardScoreIndexArr[2]
  local threshold, newShold = self:Check(last, total)
  if total > self.eventInfo.rewardScoreIndexArr[3] then
    total = self.eventInfo.rewardScoreIndexArr[3]
  end
  if newShold == self.eventInfo.rewardScoreIndexArr[3] and threshold == self.eventInfo.rewardScoreIndexArr[1] then
    isTwo = true
  end
  local from = last / threshold
  local to = total / threshold
  if threshold ~= newShold then
    to = 1
  end
  
  local function OnProGet()
    return from
  end
  
  local function OnProSet(x)
    if threshold == self.eventInfo.rewardScoreIndexArr[1] then
      self.slider1:SetValue(math.min(1, x))
    elseif threshold == self.eventInfo.rewardScoreIndexArr[2] then
      self.slider2:SetValue(math.min(1, x))
    elseif threshold == self.eventInfo.rewardScoreIndexArr[3] then
      self.slider3:SetValue(math.min(1, x))
    end
  end
  
  local function OnProAniEnd()
    local bFull = 1 < total / threshold
    if bFull then
      from = 0
      if isTwo then
        to = 1
        threshold = tempScore
        isTwo = false
      else
        to = total / newShold
        threshold = newShold
      end
      DOTween.To(OnProGet, OnProSet, to, 1):OnComplete(OnProAniEnd):SetDelay(0.2)
      return
    end
    local data = DataCenter.ActivityListDataManager:GetActScore(self.eventInfo.actId)
    if data then
      from = to
      total = tonumber(data.score)
      if total > self.eventInfo.rewardScoreIndexArr[3] then
        total = self.eventInfo.rewardScoreIndexArr[3]
      end
      threshold, newShold = self:Check(tonumber(self.param.score), total)
      self.param.score = tonumber(data.score)
      if newShold == self.eventInfo.rewardScoreIndexArr[3] and threshold == self.eventInfo.rewardScoreIndexArr[1] then
        isTwo = true
      end
      to = total / threshold
      if threshold ~= newShold then
        to = 1
      end
      DataCenter.ActivityListDataManager:ClearActScore()
      DOTween.To(OnProGet, OnProSet, to, 1):OnComplete(OnProAniEnd):SetDelay(0.2)
      if self.delayTime == nil then
        self:DelayInvokeHide(rootRt, true)
      end
      return
    end
    if self.delayTime == nil then
      self:DelayInvokeHide(rootRt, bFull)
    end
  end
  
  DOTween.To(OnProGet, OnProSet, to, 1):OnComplete(OnProAniEnd):SetDelay(showTime)
end

function UINoticeEquipTipsView:DelayInvokeHide(rootRt, bFull)
  local changeTime = bFull and 1.6 or 0.5
  self.delayTime = TimerManager:GetInstance():DelayInvoke(function()
    self.animator:Enable(false)
    DOTween.Kill(rootRt)
    rootRt:Set_localScale(1, 1, 1)
    rootRt:DOScale(Vector3.New(1.2, 1.2, 1.2), 0.15):OnComplete(function()
      rootRt:DOScale(Vector3.zero, 0.25):OnComplete(function()
        if self.delayTime then
          self.delayTime:Stop()
          self.delayTime = nil
        end
        self.ctrl:CloseSelf()
      end)
    end)
  end, changeTime)
end

return UINoticeEquipTipsView
