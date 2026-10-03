local UIUnLockSuccessView = BaseClass("UIUnLockSuccessView", UIBaseView)
local base = UIBaseView
local reward_title_path = "UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle"
local panel_path = "UICommonRewardPopUp/Panel"
local popUp_Path = "UICommonRewardPopUp"
local root_path = "Root"
local unlockIcon_path = "Root/UnlockIcon"
local unlockQuest_path = "Root/UnlockQuest"
local unlockLight_path = "Root/UnlockLight"
local unlockIcon_txt_path = "Root/UnlockTxt"
local flyIcon_path = "Fly/FlyIcon"
local flyQuest_path = "Fly/FlyQuest"
local min_pic_height = 180

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.textTitle = self:AddComponent(UIText, reward_title_path)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.popUp = self:AddComponent(UIAnimator, popUp_Path)
  self.root = self:AddComponent(UIBaseContainer, root_path)
  self.panel:SetOnClick(function()
    self:OnClick()
  end)
  self.unlockIcon_txt = self:AddComponent(UIText, unlockIcon_txt_path)
  self.unlockIcon = self:AddComponent(UIImage, unlockIcon_path)
  self.unlockQuest = self:AddComponent(UIBaseContainer, unlockQuest_path)
  self.unlockLight = self:AddComponent(UIBaseContainer, unlockLight_path)
  self.flyIcon = self:AddComponent(UIImage, flyIcon_path)
  self.flyQuest = self:AddComponent(UIBaseContainer, flyQuest_path)
  self.anim = self:AddComponent(UIAnimator, "")
end

local function ComponentDestroy(self)
  self.textTitle = nil
  self.panel = nil
  self.popUp = nil
  self.root = nil
  self.unlockIcon_txt = nil
  self.unlockIcon = nil
  self.unlockQuest = nil
  self.unlockLight = nil
  self.flyIcon = nil
  self.flyQuest = nil
  self.anim = nil
end

local function DataDefine(self)
  self.btnTimer = nil
  
  function self.timer_action()
    self:TimerAction()
  end
  
  self.unlockType = nil
end

local function DataDestroy(self)
  self:DeleteTimer()
  self.btnTimer = nil
  self.timer_action = nil
  self.unlockType = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  local param = self.ctrl:GetShowData()
  self:InitData(param)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function InitData(self, param)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_Unclock, false)
  self.data = param
  self.textTitle:SetText(param.title)
  self:SetIcon(param)
  self.unlockType = param.type
  self.flyIcon:SetActive(false)
  self.flyQuest:SetActive(false)
  self.panel:SetInteractable(false)
  self:DeleteTimer()
  local ret, time = self.popUp:PlayAnimationReturnTime("V_ui_jiesuan_title_anim")
  if ret then
    self:AddTimer(time - 1)
  end
  self.root:SetActive(true)
  self.popUp:SetActive(true)
  self.unlockLight:SetActive(false)
  if param.type == UnlockWindowType.Product then
    self.unlockLight:SetActive(true)
  end
  self.anim:Play("CommonPopup_movein", 0, 0)
end

local function AddTimer(self, time)
  self:DeleteTimer()
  self.btnTimer = TimerManager:GetInstance():GetTimer(time, self.timer_action, self, true, false, false)
  self.btnTimer:Start()
end

local function TimerAction(self)
  self:DeleteTimer()
  self.panel:SetInteractable(true)
end

local function DeleteTimer(self)
  if self.btnTimer then
    self.btnTimer:Stop()
    self.btnTimer = nil
  end
end

local function OnClick(self)
  self.panel:SetInteractable(false)
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.data and self.data.flyEndPos or self.data.type == UnlockWindowType.GuideBtn then
    self:MoveToEndPosAnim(function()
      self:TryShowNext()
    end)
  else
    self:TryShowNext()
  end
end

local function TryShowNext(self)
  self.ctrl:RemoveFirstData()
  local data = self.ctrl:GetShowData()
  if data ~= nil then
    self:InitData(data)
  else
    if self.data and self.data.type then
      if self.data.type == UnlockWindowType.Activity then
        EventManager:GetInstance():Broadcast(EventId.OnUnlockActivityViewClose)
      else
        EventManager:GetInstance():Broadcast(EventId.OnUnlockViewClose)
      end
    end
    self.ctrl:CloseSelf()
  end
end

local function SetIcon(self, param)
  self.unlockIcon:SetActive(false)
  self.unlockQuest:SetActive(false)
  if param.type == UnlockWindowType.Product or param.type == UnlockWindowType.Building or param.type == UnlockWindowType.Activity then
    self.unlockIcon:LoadSpriteAsyncWithCallback(param.icon, function()
      if self and self.unlockIcon then
        self.unlockIcon:SetNativeSize()
        local height = self.unlockIcon.rectTransform.sizeDelta.y
        local width = self.unlockIcon.rectTransform.sizeDelta.x
        if height < min_pic_height then
          local scale = min_pic_height / height
          self.unlockIcon.rectTransform:Set_sizeDelta(scale * width, min_pic_height)
        end
      end
    end)
    self.unlockIcon_txt:SetText(param.intro)
    self.unlockIcon:SetActive(true)
  elseif param.type == UnlockWindowType.GuideBtn then
    self.unlockIcon_txt:SetText(param.intro)
    if param.btnType == UnlockBtnType.Quest then
      TimerManager:GetInstance():DelayInvoke(function()
        self.unlockQuest:SetActive(true)
      end, 0.2)
      local cg = self.unlockIcon_txt.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
      cg.alpha = 0
      cg:DOFade(1, 0.3):SetDelay(0.5)
    end
  end
end

local function MoveToEndPosAnim(self, callback)
  self.popUp:Play("V_ui_jiesuan_title_fade_anim", 0, 0)
  self.root:SetActive(false)
  if self.data.type == UnlockWindowType.Product or self.data.type == UnlockWindowType.Building then
    self.flyIcon:SetActive(true)
    self.flyIcon.transform:Set_localScale(1, 1, 1)
    self.flyIcon.transform.position = self.unlockIcon.transform.position
    self.flyIcon:LoadSpriteAsyncWithCallback(self.data.icon, function()
      if self and self.flyIcon then
        self.flyIcon:SetNativeSize()
        if self.data.type == UnlockWindowType.Building then
          local savePos = UIUtil.GetUIMainSavePos(UIMainSavePosType.FastBuild)
          local targetPos = Vector3.New(savePos.x, savePos.y, savePos.z)
          if CS.SceneManager:IsInCity() and LuaEntry.DataConfig:CheckSwitch("quest_early") then
            targetPos.y = targetPos.y - 133
          end
          local targetScale = 91 / self.flyIcon:GetSizeDelta().y
          local flyDir = Vector3.Normalize(targetPos - self.flyIcon.transform.position)
          local uiMain = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
          if uiMain == nil then
            return
          end
          local fastBuild = uiMain.View.bottom.fast_build_obj
          local fastBuildOriginPos = fastBuild.transform.position
          fastBuild:ShowUnlock(self.data.icon)
          fastBuild:SetActive(true)
          DOTween.Sequence():Append(self.flyIcon.transform:DOMove(self.flyIcon.transform.position - flyDir * 20, 0.3)):Append(self.flyIcon.transform:DOMove(targetPos + Vector3.New(2, 18, 0), 0.5)):Join(self.flyIcon.transform:DOScale(Vector3.New(targetScale, targetScale, 1), 0.5)):Join(fastBuild.root_go.transform:DOMove(targetPos, 0.3)):AppendCallback(function()
            fastBuild.glow_go:SetActive(true)
            self.flyIcon:SetActive(false)
          end):AppendInterval(0.4):Append(fastBuild.transform:GetComponent(typeof(CS.UnityEngine.CanvasGroup)):DOFade(0, 0.2)):AppendCallback(function()
            fastBuild.glow_go:SetActive(false)
            fastBuild:Refresh()
            fastBuild.transform.position = fastBuildOriginPos
            EventManager:GetInstance():Broadcast(EventId.UnlockBuilding)
            if callback then
              callback()
            end
          end)
        end
      end
    end)
  elseif self.data.type == UnlockWindowType.GuideBtn then
    local UIMain = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
    UIMain.View:PlayAnim(UIMainAnimType.ChangeAllShow)
    if self.data.btnType == UnlockBtnType.Quest then
      self.flyQuest:SetActive(true)
      self.flyQuest.transform:Set_position(self.unlockQuest.transform:Get_position())
      TimerManager:GetInstance():DelayInvoke(function()
        local fly = self.flyQuest.transform:GetComponent(typeof(CS.UIGoodsFly))
        local pos = UIUtil.GetUIMainSavePos(UIMainSavePosType.QuestNpc)
        fly:DoAnimForLua(50, 50, 999, nil, 1, pos, function()
          DataCenter.UnlockBtnManager:UnlockEffectComplete(self.data.btnType)
          self.flyQuest:SetActive(false)
          if callback then
            callback()
          end
        end)
      end, 0.5)
    end
  end
end

UIUnLockSuccessView.OnCreate = OnCreate
UIUnLockSuccessView.OnDestroy = OnDestroy
UIUnLockSuccessView.OnEnable = OnEnable
UIUnLockSuccessView.OnDisable = OnDisable
UIUnLockSuccessView.ComponentDefine = ComponentDefine
UIUnLockSuccessView.ComponentDestroy = ComponentDestroy
UIUnLockSuccessView.InitData = InitData
UIUnLockSuccessView.DataDefine = DataDefine
UIUnLockSuccessView.DataDestroy = DataDestroy
UIUnLockSuccessView.AddTimer = AddTimer
UIUnLockSuccessView.TimerAction = TimerAction
UIUnLockSuccessView.DeleteTimer = DeleteTimer
UIUnLockSuccessView.OnClick = OnClick
UIUnLockSuccessView.TryShowNext = TryShowNext
UIUnLockSuccessView.SetIcon = SetIcon
UIUnLockSuccessView.MoveToEndPosAnim = MoveToEndPosAnim
return UIUnLockSuccessView
