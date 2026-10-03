local MainMiniMapMeteoriteNoticeItem = BaseClass("MainMiniMapMeteoriteNoticeItem", UIAsyncContainer)
local base = UIAsyncContainer
local meteorite_notice_icon_path = "animRoot/meteoriteNoticeIcon"
local meteorite_notice_name_path = "animRoot/meteoriteNoticeName"
local meteorite_notice_background_path = "animRoot/meteoriteNoticeBackground"
local anim_root_path = "animRoot"
local STATE_SHOW = 1
local STATE_HIDE = 2
local STATE_MOVE_IN = 3
local STATE_MOVE_OUT = 4

local function OnCreate(self, holder)
  base.OnCreate(self)
  self.meteorite_notice_icon = self:AddComponent(UIImage, meteorite_notice_icon_path)
  self.meteorite_notice_name = self:AddComponent(UITextMeshProUGUIEx, meteorite_notice_name_path)
  self.meteorite_notice_background = self:AddComponent(UIRawImage, meteorite_notice_background_path)
  self.tranAnimRoot = self.transform:Find(anim_root_path)
  self.animStartPos = Vector2.New(300, 0)
  self.animEndPos = Vector2.New(0, 0)
  self.state = STATE_HIDE
  self.goHolder = holder
  self.inited = true
  self:Close()
end

local function OnDestroy(self)
  self:Close()
  base.OnDestroy(self)
  self.goHolder = nil
  self.inited = false
end

function MainMiniMapMeteoriteNoticeItem:Refresh(tips)
  if not self.inited then
    return
  end
  if not tips then
    self:CloseCountdown()
    return false
  end
  self.currentTips = tips
  self.meteorite_notice_icon:LoadSprite(tips.icon)
  self:RefreshCurrentNotification()
end

function MainMiniMapMeteoriteNoticeItem:RefreshCurrentNotification()
  if not self.currentTips then
    self:Close()
    return
  end
  local battleInfo = DataCenter.ActMeteoriteBattleManager:GetBattleWorldInfo()
  if not battleInfo then
    self:Close()
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local noticeStartTime = battleInfo.startTime + self.currentTips.trigger_time - self.currentTips.alert_time
  if curTime < noticeStartTime then
    self:Close()
    return
  end
  local noticeEndTime = noticeStartTime + self.currentTips.alert_time
  local ms = noticeEndTime * 1000
  local curTimeMs = UITimeManager:GetInstance():GetServerTime()
  local remainMs = ms - curTimeMs
  if remainMs < 0 then
    self:CloseCountdown()
    return
  end
  if not self.isShowed then
    self:TryMoveIn()
  end
  self.meteorite_notice_name:SetText(Mathf.Round(remainMs / 1000, 0))
  if self.goHolder then
    self.goHolder:SetActive(true)
  else
    self:SetActive(true)
  end
  if not self.cdTimer then
    self.cdTimer = TimerManager:GetInstance():GetTimer(0.5, self.RefreshCurrentNotification, self, false, false, false)
    self.cdTimer:Start()
  end
end

function MainMiniMapMeteoriteNoticeItem:TryMoveIn()
  if self.state == STATE_HIDE then
    self.state = STATE_MOVE_IN
    local sequence = DOTween.Sequence()
    sequence:Append(self.tranAnimRoot:DOAnchorPos(self.animEndPos, 0.5)):AppendCallback(function()
      self.state = STATE_SHOW
    end)
  elseif self.state == STATE_SHOW then
  elseif self.state == STATE_MOVE_IN then
  elseif self.state == STATE_MOVE_OUT then
    DOTween.Kill(self.tranAnimRoot)
    self.state = STATE_MOVE_IN
    local sequence = DOTween.Sequence()
    sequence:Append(self.tranAnimRoot:DOAnchorPos(self.animEndPos, 0.5)):AppendCallback(function()
      self.state = STATE_SHOW
    end)
  end
end

function MainMiniMapMeteoriteNoticeItem:TryMoveOut()
  if self.state == STATE_HIDE then
  elseif self.state == STATE_SHOW then
    self.state = STATE_MOVE_OUT
    local sequence = DOTween.Sequence()
    sequence:Append(self.tranAnimRoot:DOAnchorPos(self.animStartPos, 0.5)):AppendCallback(function()
      self.state = STATE_HIDE
      self:RefreshCurrentNotification()
    end)
  elseif self.state == STATE_MOVE_IN then
    DOTween.Kill(self.tranAnimRoot)
    self.state = STATE_MOVE_OUT
    local sequence = DOTween.Sequence()
    sequence:Append(self.tranAnimRoot:DOAnchorPos(self.animStartPos, 0.5)):AppendCallback(function()
      self.state = STATE_HIDE
      self:RefreshCurrentNotification()
    end)
  elseif self.state == STATE_MOVE_OUT then
  end
end

function MainMiniMapMeteoriteNoticeItem:CloseCountdown()
  self.remainSec = nil
  self.currentTips = nil
  if self.cdTimer then
    self.cdTimer:Stop()
    self.cdTimer = nil
  end
  self:TryMoveOut()
end

function MainMiniMapMeteoriteNoticeItem:Close()
  if not self.inited then
    return
  end
  if self.goHolder then
    self.goHolder:SetActive(false)
  else
    self:SetActive(false)
  end
  if self.tranAnimRoot then
    DOTween.Kill(self.tranAnimRoot)
  end
  self.tranAnimRoot.anchoredPosition = self.animStartPos
  self.state = STATE_HIDE
end

MainMiniMapMeteoriteNoticeItem.OnCreate = OnCreate
MainMiniMapMeteoriteNoticeItem.OnDestroy = OnDestroy
return MainMiniMapMeteoriteNoticeItem
