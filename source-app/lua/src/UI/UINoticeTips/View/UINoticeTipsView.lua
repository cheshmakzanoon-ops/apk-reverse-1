local UINoticeTipsView = BaseClass("UINoticeTipsView", UIBaseView)
local base = UIBaseView
local UnityRectTransform = typeof(CS.UnityEngine.RectTransform)
local Localization = CS.GameEntry.Localization
local txt_path = "SafeArea/ImgBg/Text"
local imgBg_path = "SafeArea/ImgBg"
local anim_path = ""
local UIState = {
  None = 1,
  Show = 2,
  Hide = 3,
  Notice = 4
}
local QUEST_ENTRY_WIDTH_Min = 880
local QUEST_Start_Posx = 350
local QUEST_ENTRY_ROLLING_Time = 13
local QUEST_ENTRY_ROLLING_DELAY = 0
local QUEST_ENTRY_ROLLING_HOLD = 1

local function OnCreate(self)
  base.OnCreate(self)
  self.state = UIState.Show
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function ComponentDefine(self)
  self.ImgBg = self:AddComponent(UIImage, imgBg_path)
  self.txt = self:AddComponent(UIText, txt_path)
  self.txt_rectTransform = self.transform:Find(txt_path):GetComponent(UnityRectTransform)
  self.anim = self:AddComponent(UIAnimator, anim_path)
end

local function DataDefine(self)
end

local function OnDestroy(self)
  if self.tweenSeq then
    self.tweenSeq:Kill()
  end
  self.ImgBg = nil
  self.txt = nil
  self.txt_rectTransform = nil
  self.anim = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UI_SHOWNOTICE, self.SetNewNotice)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UI_SHOWNOTICE, self.SetNewNotice)
end

local function SetNewNotice(self, noticeType)
  self.ctrl:SetNewNotice(noticeType)
end

local function ReInit(self)
  self.timer = 0
  self:ResetUI()
  self:SetState(UIState.Show)
end

local function OnUpdateUI(self)
  if self.state == UIState.None then
    self:SetState(UIState.Show)
  end
end

local function ResetUI(self)
  self.ImgBg.transform.localScale = Vector3.one
  self.ImgBg.color = Color.New(0, 0, 0, 1)
end

local function SetState(self, s, force)
  if self.state == s and not force then
    return
  end
  self.state = s
  self.timer = 0
  if s == UIState.None then
    self.txt:SetText("")
    self:ResetUI()
  elseif s == UIState.Show then
    self.txt:SetText("")
    self:Play("show")
  elseif s == UIState.Hide then
    self.txt:SetText("")
    self:Play("hide")
  elseif s == UIState.Notice then
    self:SetHorseRaceLamp()
  end
end

local function Update(self)
  if self.state == UIState.None then
    return
  end
  self.timer = self.timer + Time.deltaTime
  if self.state == UIState.Show then
    if self.timer >= 0.3 then
      local nextContent = NoticeTipsManager:GetInstance():GetNotice()
      if nextContent then
        self.txt:SetText(nextContent.content)
        self:SetState(UIState.Notice)
      else
        self:SetState(UIState.Hide)
      end
    end
  elseif self.state == UIState.Hide then
    if self.timer >= 0.3 then
      local nextContent = NoticeTipsManager:GetInstance():GetNotice()
      if nextContent then
        self:SetState(UIState.Show)
      else
        self:SetState(UIState.None)
        self.ctrl:CloseSelf()
      end
    end
  elseif self.state == UIState.Notice and self.timer >= 12 then
    local nextContent = NoticeTipsManager:GetInstance():GetNotice()
    if nextContent then
      self.txt:SetText(nextContent.content)
      self:SetState(UIState.Notice, true)
    else
      self:SetState(UIState.Hide)
    end
  end
end

local function SetHorseRaceLamp(self)
  local rawWidth = self.txt:GetWidth()
  local Difference = rawWidth - QUEST_ENTRY_WIDTH_Min
  local endPosx = (-1200 - Difference) * CommonUtil.ArabicAutoMirrorFactor()
  local startPosx = QUEST_Start_Posx * CommonUtil.ArabicAutoMirrorFactor()
  if CommonUtil.IsArabic() and CommonUtil.ArabicAutoMirrorFactor() == 1 then
    startPosx = endPosx
    endPosx = QUEST_Start_Posx
  end
  if self.tweenSeq then
    self.tweenSeq:Kill()
  end
  self.txt_rectTransform:Set_anchoredPosition(startPosx, 0)
  self.tweenSeq = DOTween.Sequence()
  self.tweenSeq:AppendInterval(QUEST_ENTRY_ROLLING_DELAY)
  self.tweenSeq:Append(self.txt.transform:DOAnchorPosX(endPosx, QUEST_ENTRY_ROLLING_Time):SetEase(CS.DG.Tweening.Ease.Linear))
  self.tweenSeq:AppendInterval(QUEST_ENTRY_ROLLING_HOLD)
end

local function Play(self, animName)
  self.anim:SetTrigger(animName)
end

UINoticeTipsView.OnCreate = OnCreate
UINoticeTipsView.OnDestroy = OnDestroy
UINoticeTipsView.OnEnable = OnEnable
UINoticeTipsView.OnDisable = OnDisable
UINoticeTipsView.ComponentDefine = ComponentDefine
UINoticeTipsView.DataDefine = DataDefine
UINoticeTipsView.OnAddListener = OnAddListener
UINoticeTipsView.OnRemoveListener = OnRemoveListener
UINoticeTipsView.ReInit = ReInit
UINoticeTipsView.Update = Update
UINoticeTipsView.ResetUI = ResetUI
UINoticeTipsView.SetNewNotice = SetNewNotice
UINoticeTipsView.OnUpdateUI = OnUpdateUI
UINoticeTipsView.SetState = SetState
UINoticeTipsView.SetHorseRaceLamp = SetHorseRaceLamp
UINoticeTipsView.Play = Play
return UINoticeTipsView
