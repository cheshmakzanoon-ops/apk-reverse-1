local UIFirstChargeBtn = BaseClass("UIFirstChargeBtn", UIBaseContainer)
local base = UIBaseContainer

local function AddTimer(self)
  if self.timer then
    return
  end
  self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  self.timer:Start()
end

local function RemoveTimer(self)
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

local function RefreshTime(self)
  local endTime = DataCenter.FirstPayManager:GetFixEndTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local time = endTime - curTime
  if 0 < time then
    self.nameText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(time))
  else
    self.nameText:SetLocalText(2000327)
    RemoveTimer(self)
  end
end

local function CheckCanShow(self)
  local isNew = DataCenter.FirstPayManager:IsNewFirstPay()
  if isNew then
    local firstChargePack = DataCenter.FirstPayManager:GetFirstPayPack()
    if firstChargePack then
      return true, firstChargePack
    end
  else
    local firstPayState = DataCenter.FirstPayManager:GetState()
    if firstPayState > FirstPayState.DontHaveBuilding and firstPayState <= FirstPayState.Repairing then
      return true
    end
  end
  return false
end

local function RefreshShowState(self)
  local unlocked = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_FirstPay)
  local canShow, firstPayPack = CheckCanShow(self)
  local isNewFirstPay = DataCenter.FirstPayManager:IsNewFirstPay()
  if canShow and unlocked then
    self:SetActive(true)
    if isNewFirstPay then
      self.nameText:SetLocalText(2000327)
    else
      local state = DataCenter.FirstPayManager:GetState()
      if state == FirstPayState.Repairing then
        AddTimer(self)
      else
        self.nameText:SetLocalText(2000327)
        RemoveTimer(self)
      end
    end
  else
    if not isNewFirstPay then
      RemoveTimer(self)
    end
    self:SetActive(false)
  end
end

local function OnBtnClick(self)
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIFirstPay) then
    local todayShow = DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.FirstPayShowHero)
    GoToUtil.GotoOpenView(UIWindowNames.UIFirstPay, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    }, {delay = 0.5, todayShow = todayShow})
    if todayShow then
      DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.FirstPayShowHero, false)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroExhibitPanel, {anim = false}, 50009, {50009}, nil, true)
      PostEventLog.Track(PostEventLog.Defines.PlayFirstPayTimeline, {
        param1 = tostring(DataCenter.MonopolyManager.player.curId)
      })
    end
  end
end

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  
  function self.OnShowByEvent()
    OnBtnClick(self)
  end
  
  self.timer_action = BindCallback(self, RefreshTime)
  EventManager:GetInstance():AddListener(EventId.ShowFirstPayUI, self.OnShowByEvent)
end

local function OnDestroy(self)
  RemoveTimer(self)
  self.timer_action = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
  EventManager:GetInstance():RemoveListener(EventId.ShowFirstPayUI, self.OnShowByEvent)
  self.OnShowByEvent = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.nameText = self:AddComponent(UIText, "NameText")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    OnBtnClick(self)
  end)
  self.icon = self:AddComponent(UIImage, "firstPayBg/Bg")
  if CommonUtil.IsJapanABTest() then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UIMain/LWMainUI/cfm_zhujiemian_libao_tubiao_1_B.png")
  else
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UIMain/LWMainUI/cfm_zhujiemian_libao_tubiao_1.png")
  end
end

local function ComponentDestroy(self)
  self.nameText = nil
  self.btn = nil
end

UIFirstChargeBtn.OnCreate = OnCreate
UIFirstChargeBtn.OnDestroy = OnDestroy
UIFirstChargeBtn.OnEnable = OnEnable
UIFirstChargeBtn.OnDisable = OnDisable
UIFirstChargeBtn.ComponentDefine = ComponentDefine
UIFirstChargeBtn.ComponentDestroy = ComponentDestroy
UIFirstChargeBtn.RefreshShowState = RefreshShowState
return UIFirstChargeBtn
