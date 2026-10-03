local UISoliderGetTip = BaseClass("UISoliderGetTip", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  if self.closeTime then
    self.closeTime:Stop()
    self.closeTime = nil
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIImage, "Root/ImageItem")
  self.sliderGreen = self:AddComponent(UISlider, "Root/SliderGreen")
  self.sliderYellow = self:AddComponent(UISlider, "Root/SliderYellow")
  self.textName = self:AddComponent(UIText, "Root/TextName")
  self.textNum = self:AddComponent(UIText, "Root/TextNum")
  self.textName1 = self:AddComponent(UIText, "Root/TextName1")
  self.root = self:AddComponent(UIBaseContainer, "Root")
  self.animator = self:AddComponent(UIAnimator, "")
end

local function ComponentDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.BuildUpgradeRewardArmy, self.OnRefreshDoFly)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.BuildUpgradeRewardArmy, self.OnRefreshDoFly)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:DoAnimFunc()
end

local function DoAnimFunc(self, param)
  local rootRt = self.root.transform
  DOTween.Kill(rootRt)
  rootRt:Set_localScale(1, 1, 1)
  self.animator:Enable(true)
  local str, add, total, limitBefore, limitCurrent, amyType = self:GetUserData()
  local last = total - add
  local limitAdd = limitCurrent - limitBefore
  local reached = 1 <= last / limitBefore
  if param then
    add = param.add
    total = param.total
    limitBefore = param.max
    limitCurrent = param.max
    last = total - add
    limitAdd = limitCurrent - limitBefore
    reached = 1 <= last / limitBefore
  end
  self.textName:SetLocalText(140310)
  self.sliderGreen:SetActive(not reached)
  self.sliderYellow:SetActive(reached)
  self.textNum:SetText(last .. "/" .. limitBefore)
  self.sliderGreen:SetValue(last / limitCurrent)
  local ret, time = self.animator:GetAnimationReturnTime("UIRecruitLotteryTip_show")
  local showTime = (ret and time or 0) + 0.2
  print("showTime:" .. showTime)
  local from = last / limitBefore
  local to = total / limitCurrent
  
  local function OnProAniEnd()
    self.textNum:SetText(total .. "/" .. limitCurrent)
    local bFull = 1 <= total / limitCurrent
    if bFull then
      self.sliderGreen:SetActive(false)
      self.sliderYellow:SetActive(true)
      self.animator:SetTrigger("change")
    end
    if not param then
      local pos = self.animator.gameObject.transform.position
      local rewardTyp = RewardType.POWER
      local pic = "Assets/Main/Sprites/UI/UIMain/UIMainNew/UIMain_btn_Power.png"
      UIUtil.DoFly(tonumber(rewardTyp), 5, pic, pos, Vector3.New(0, 0, 0))
      EventManager:GetInstance():Broadcast(EventId.ShowPower, RewardType.POWER)
    end
    local changeTime = bFull and 2.6 or 1.5
    print("changeTime:" .. changeTime)
    if self.closeTime == nil then
      self.closeTime = TimerManager:GetInstance():DelayInvoke(function()
        DOTween.Kill(rootRt)
        self.animator:Enable(false)
        self.root.transform:Set_localScale(1, 1, 1)
        self.root.transform:DOScale(Vector3.New(1.2, 1.2, 1.2), 0.15):OnComplete(function()
          self.root.transform:DOScale(Vector3.zero, 0.25):OnComplete(function()
            self.ctrl:CloseSelf()
          end)
        end)
      end, changeTime)
    end
  end
  
  local function OnProGet()
    return from
  end
  
  local function OnProSet(x)
    if limitAdd == 0 then
      self.sliderGreen:SetValue(math.min(1, x))
    end
    local t = Mathf.InverseLerp(from, to, x)
    local num = math.floor(last + add * t)
    local limit = math.floor(limitBefore + limitAdd * t)
    self.textNum:SetText(num .. "/" .. limit)
  end
  
  if param then
    TimerManager:GetInstance():DelayInvoke(function()
      DOTween.To(OnProGet, OnProSet, to, 0.6):OnComplete(OnProAniEnd):SetDelay(showTime)
    end, 1)
  else
    DOTween.To(OnProGet, OnProSet, to, 0.6):OnComplete(OnProAniEnd):SetDelay(showTime)
  end
end

local function OnRefreshDoFly(self, param)
  if param and param.type == RewardType.ARM then
    self:DoAnimFunc(param)
    UIUtil.DoFly(param.type, 5, param.path, param.pos, self.icon.transform.position, 60, 60)
  end
end

UISoliderGetTip.OnCreate = OnCreate
UISoliderGetTip.OnDestroy = OnDestroy
UISoliderGetTip.OnEnable = OnEnable
UISoliderGetTip.ComponentDefine = ComponentDefine
UISoliderGetTip.ComponentDestroy = ComponentDestroy
UISoliderGetTip.OnAddListener = OnAddListener
UISoliderGetTip.OnRemoveListener = OnRemoveListener
UISoliderGetTip.DoAnimFunc = DoAnimFunc
UISoliderGetTip.OnRefreshDoFly = OnRefreshDoFly
return UISoliderGetTip
