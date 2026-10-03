local UIPVELoading = BaseClass("UIPVELoading", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local DEFAULT_PIC = "UIPveLoading_img01"
local yellow_path = "Yellow"
local left_text_path = "Yellow/Left/LeftText"
local right_text_path = "Yellow/Right/RightText"
local pic_path = "Yellow/Image"
local black_path = "Black"
local circle_path = "Circle"
local circle_text_path = "Circle/CircleText"
local wait_path = "Wait"
local wait_text_path = "Wait/WaitText"
local LONG_WAIT_TIME = 3

local function OnCreate(self)
  base.OnCreate(self)
  local param = self:GetUserData()
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.yellow_anim = self:AddComponent(UIAnimator, yellow_path)
  self.left_text = self:AddComponent(UIText, left_text_path)
  self.right_text = self:AddComponent(UIText, right_text_path)
  self.pic_image = self:AddComponent(UIImage, pic_path)
  self.pic_raw_image = self:AddComponent(UIRawImage, "Yellow/RawImage")
  self.bg_raw_image = self:AddComponent(UIRawImage, "Yellow/Bg_loading_Raw")
  self.loadRemoteResTips = self:AddComponent(UIText, "Yellow/loadRemoteResTips")
  self.black_anim = self:AddComponent(UIAnimator, black_path)
  self.circle_anim = self:AddComponent(UIAnimator, circle_path)
  self.circle_text = self:AddComponent(UIText, circle_text_path)
  self.wait_anim = self:AddComponent(UIAnimator, wait_path)
  self.wait_text = self:AddComponent(UIText, wait_text_path)
  self.wait_text:SetLocalText(100231)
  self:ReInit()
  self:Enter()
end

local function ComponentDestroy(self)
  self.yellow_anim = nil
  self.left_text = nil
  self.right_text = nil
  self.pic_image = nil
  self.pic_raw_image = nil
  self.black_anim = nil
  self.circle_anim = nil
  self.circle_text = nil
  self.wait_anim = nil
  self.wait_text = nil
  self.bg_raw_image = nil
end

local function DataDefine(self)
  self.animType = nil
  self.waitTimer = nil
  self.closeTimer = nil
  DataCenter.ArrowManager:RemoveArrow()
  DataCenter.ArrowManager:RemoveFingerArrow()
end

local function DataDestroy(self)
  if self.waitTimer then
    self.waitTimer:Stop()
    self.waitTimer = nil
  end
  if self.closeTimer then
    self.closeTimer:Stop()
    self.closeTimer = nil
  end
  self.animType = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UIPVELoadingQuit, self.Quit)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UIPVELoadingQuit, self.Quit)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  local param = self:GetUserData()
  local pveTemplate = DataCenter.BattleLevel.pveTemplate
  self.animType = param and param.animType
  if self.animType == nil then
    local levelType = DataCenter.BattleLevel:GetLevelType()
    local entranceType = DataCenter.BattleLevel:GetEntranceType()
    if levelType == PveLevelType.NormalLevel or levelType == PveLevelType.HeroExpLevel or levelType == PveLevelType.NormalExpLevel or levelType == PveLevelType.BattleExpLevel or levelType == PveLevelType.SkillLevel or levelType == PveLevelType.ArmyLevel then
      self.animType = PveLoadingAnimType.Yellow
    else
      self.animType = PveLoadingAnimType.Yellow
    end
    if (entranceType == PveEntrance.AdventureSetting or entranceType == PveEntrance.Adventure) and not CS.SceneManager.IsInPVE() then
      self.animType = PveLoadingAnimType.Yellow
    end
    if DataCenter.ZombieBattleManager:GetLevelType() == PveLevelType.ZombieBattle then
      self.animType = PveLoadingAnimType.Yellow
    end
  end
  if self.animType == PveLoadingAnimType.Yellow then
    self.yellow_anim:SetActive(true)
    self.black_anim:SetActive(false)
    self.circle_anim:SetActive(false)
    self.wait_anim:SetActive(false)
    local _, t = UIUtil.PlayAnimationReturnTime(self.yellow_anim.unity_animator, "V_ui_zhuanchang_idle_anim")
    TimerManager:GetInstance():DelayInvoke(function()
      if self.onEntered then
        self.onEntered()
      end
    end, 0.1)
  elseif self.animType == PveLoadingAnimType.Black then
    self.yellow_anim:SetActive(false)
    self.black_anim:SetActive(true)
    self.circle_anim:SetActive(false)
    self.wait_anim:SetActive(false)
    local _, t = UIUtil.PlayAnimationReturnTime(self.black_anim.unity_animator, "V_ui_pve_heipinmu")
    TimerManager:GetInstance():DelayInvoke(function()
      if self.onEntered then
        self.onEntered()
      end
    end, t)
  elseif self.animType == PveLoadingAnimType.Circle then
    self.yellow_anim:SetActive(false)
    self.black_anim:SetActive(false)
    self.circle_anim:SetActive(true)
    self.wait_anim:SetActive(false)
    local _, t = UIUtil.PlayAnimationReturnTime(self.circle_anim.unity_animator, "UIMoving")
    TimerManager:GetInstance():DelayInvoke(function()
      if self.onEntered then
        self.onEntered()
      end
    end, t)
  end
  local tip
  if pveTemplate ~= nil then
  end
  if param and not string.IsNullOrEmpty(param.leftText) then
    self.left_text:SetText(param.leftText)
  elseif tip and not string.IsNullOrEmpty(tip.leftText) then
    self.left_text:SetLocalText(tip.leftText)
  else
    self.left_text:SetLocalText(410000)
  end
  if param and not string.IsNullOrEmpty(param.rightText) then
    self.right_text:SetText(param.rightText)
  elseif tip and not string.IsNullOrEmpty(tip.rightText) then
    self.right_text:SetLocalText(tip.rightText)
  else
    self.right_text:SetLocalText(410100)
  end
  if param and not string.IsNullOrEmpty(param.pic) then
    self.pic_raw_image:SetActive(true)
    self.pic_raw_image:LoadSpriteAuto(param.pic)
  elseif tip and not string.IsNullOrEmpty(tip.pic) then
    self.pic_raw_image:SetActive(false)
    self.pic_image:LoadSprite(string.format(LoadPath.UIPveLoading, tip.pic))
  else
    self.pic_raw_image:SetActive(false)
    self.pic_image:LoadSprite(string.format(LoadPath.UIPveLoading, DEFAULT_PIC))
  end
  if param and not string.IsNullOrEmpty(param.circleText) then
    self.circle_text:SetText(param.circleText)
  else
    self.circle_text:SetText("")
  end
  if param and not string.IsNullOrEmpty(param.loadRemoteResTips) then
    self.loadRemoteResTips:SetText(param.loadRemoteResTips)
  else
    self.loadRemoteResTips:SetText("")
  end
  if Config.IsPC() then
    local bgPath = "Assets/Main/SingleSprites/cfm_hengban_loading"
    self.bg_raw_image:LoadSprite(bgPath)
    CS.RectTransformUtils.ApplyAnchorPreset(self.bg_raw_image.rectTransform, CS.UnityEngine.TextAnchor.MiddleCenter, true, true)
    self.bg_raw_image.transform.localScale = Vector3.one
    self.bg_raw_image.transform.localRotation = Quaternion.identity
    self.bg_raw_image:SetNativeSize()
    CS.RectTransformUtils.ApplyAutoScaling(self.bg_raw_image.rectTransform, 1.7777777777777777)
  elseif param and not string.IsNullOrEmpty(param.loadingBgRes) then
    self.bg_raw_image:LoadSpriteAuto(param.loadingBgRes)
  else
    self.bg_raw_image:LoadSpriteAuto("Assets/Main/TextureEx/Common/Eff_tex_ui_loading_01.png")
  end
end

local function Enter(self)
  local duration = 1
  if self.animType == PveLoadingAnimType.Yellow then
    duration = 0.1
  elseif self.animType == PveLoadingAnimType.Black then
    duration = 1
  elseif self.animType == PveLoadingAnimType.Circle then
    duration = 1
  end
  self.finished = false
  self.quited = false
  TimerManager:GetInstance():DelayInvoke(function()
    self.finished = true
    self:TryClose()
  end, duration)
  if self.animType == PveLoadingAnimType.Black then
    self.waitTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.wait_anim:SetActive(true)
      self.wait_anim:Play("UIMoving", 0, 0)
    end, duration + LONG_WAIT_TIME)
  end
end

local function Quit(self)
  self.quited = true
  self:TryClose()
end

local function TryClose(self)
  if self.finished and self.quited then
    if self.waitTimer then
      self.wait_anim:SetActive(false)
      self.waitTimer:Stop()
      self.waitTimer = nil
    end
    if self.closeTimer then
      self.closeTimer:Stop()
      self.closeTimer = nil
    end
    if self.animType == PveLoadingAnimType.Yellow then
      local _, t = UIUtil.PlayAnimationReturnTime(self.yellow_anim.unity_animator, "V_ui_zhuanchang_close_anim")
      self.closeTimer = TimerManager:GetInstance():DelayInvoke(function()
        self:Close()
      end, t - 0.5)
    elseif self.animType == PveLoadingAnimType.Black then
      local _, t = UIUtil.PlayAnimationReturnTime(self.black_anim.unity_animator, "V_ui_pve_heipinmu_xiaoshi")
      self.closeTimer = TimerManager:GetInstance():DelayInvoke(function()
        self:Close()
      end, t)
    elseif self.animType == PveLoadingAnimType.Circle then
      self:Close()
    end
  end
end

local function Close(self)
  if self.onClosed then
    self.onClosed()
    self.onClosed = nil
  end
  DataCenter.BattleLevel:AfterLoading()
  DataCenter.BattleLevel:AfterLoadingDoGuide()
  self.yellow_anim:SetActive(false)
  self.black_anim:SetActive(false)
  self.circle_anim:SetActive(false)
  self.wait_anim:SetActive(false)
  self.ctrl:CloseSelf()
end

local function SetOnEntered(self, onEntered)
  self.onEntered = onEntered
end

local function SetOnClosed(self, onClosed)
  self.onClosed = onClosed
end

UIPVELoading.OnCreate = OnCreate
UIPVELoading.OnDestroy = OnDestroy
UIPVELoading.ComponentDefine = ComponentDefine
UIPVELoading.ComponentDestroy = ComponentDestroy
UIPVELoading.DataDefine = DataDefine
UIPVELoading.DataDestroy = DataDestroy
UIPVELoading.OnEnable = OnEnable
UIPVELoading.OnDisable = OnDisable
UIPVELoading.OnAddListener = OnAddListener
UIPVELoading.OnRemoveListener = OnRemoveListener
UIPVELoading.ReInit = ReInit
UIPVELoading.Enter = Enter
UIPVELoading.Quit = Quit
UIPVELoading.TryClose = TryClose
UIPVELoading.Close = Close
UIPVELoading.SetOnEntered = SetOnEntered
UIPVELoading.SetOnClosed = SetOnClosed
return UIPVELoading
