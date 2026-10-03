local UIRecruitCardRewardGetView = BaseClass("UIRecruitCardRewardGetView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local progress_path = "JumpBtn/Slider/SliderText"
local title_path = "JumpBtn/NameText"
local jump_btn_path = "JumpBtn"
local jump_btn_img_path = "JumpBtn/BtnImg"
local slider_path = "JumpBtn/Slider"
local fill_img_path = "JumpBtn/Slider/Fill Area/Fill"
local effect_path = "JumpBtn/Effect"
local TWEEN_TIME = 2.5
local MAX_COUNT = 10

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
  DataCenter.LWSoundManager:PlaySound(62301, false)
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.progress_txt = self:AddComponent(UIText, progress_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.fill_img = self:AddComponent(UIImage, fill_img_path)
  self.jump_btn_img = self:AddComponent(UIImage, jump_btn_img_path)
  self.jump_btn_img:SetActive(false)
  self.jump_btn = self:AddComponent(UIButton, jump_btn_path)
  self.jump_btn:SetOnClick(function()
    self:OnJumpClick()
  end)
  self.name_txt = self:AddComponent(UIText, title_path)
  self.effect_go = self:AddComponent(UIBaseContainer, effect_path)
  self.effect_go:SetActive(false)
end

local function ComponentDestroy(self)
  self.progress_txt = nil
  self.name_txt = nil
  self.jump_btn = nil
end

local function DataDefine(self)
  self.closeTimer = TimerManager:GetInstance():DelayInvoke(function()
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:Join(self.jump_btn.transform:DOScale(Vector3.New(0.1, 0.1, 0.1), 0.2))
    sequence:AppendCallback(function()
      if self.view and self.view.ctrl then
        self.view.ctrl:CloseSelf(true)
      end
    end)
  end, 2.8)
end

local function DataDestroy(self)
  if self.closeTimer then
    self.closeTimer:Stop()
    self.closeTimer = nil
  end
  if self.progressTextTimer then
    self.progressTextTimer:Stop()
    self.progressTextTimer = nil
  end
  if self.sliderTween then
    self.sliderTween:Kill()
    self.sliderTween = nil
  end
  self.curNumber = nil
  self.originTime = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  local itemInfo = self:GetUserData()
  self.progress_txt:SetText(itemInfo.preCount .. "/" .. MAX_COUNT)
  if itemInfo.count >= MAX_COUNT then
    self.jump_btn_img:SetActive(true)
    self.name_txt:SetLocalText(455147)
  else
    self.jump_btn_img:SetActive(false)
    self.name_txt:SetLocalText(181017)
  end
  if self.sliderTween then
    self.sliderTween:Kill()
  end
  self.slider:SetValue(itemInfo.preCount / MAX_COUNT)
  self:SetFillImg(itemInfo.preCount)
  self.sliderTween = self.slider:DOValue(itemInfo.count / MAX_COUNT, TWEEN_TIME, function()
    self:SetFillImg(itemInfo.count)
  end)
  self.originTime = UITimeManager:GetInstance():GetServerTime()
  local diffCount = itemInfo.count - itemInfo.preCount
  if self.progressTextTimer == nil then
    self.progressTextTimer = TimerManager:GetInstance():GetTimer(5, function()
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local diffTime = (curTime - self.originTime) / 1000
      if diffTime > TWEEN_TIME and self.progressTextTimer ~= nil then
        self.progressTextTimer:Stop()
        self.progressTextTimer = nil
        return
      end
      local curNumber = toInt(diffCount * diffTime / (TWEEN_TIME - 0.5)) + itemInfo.preCount
      if self.curNumber ~= curNumber then
        if curNumber >= itemInfo.count then
          curNumber = itemInfo.count
        end
        self.curNumber = curNumber
        self.progress_txt:SetText(self.curNumber .. "/" .. MAX_COUNT)
        self.effect_go:SetActive(itemInfo.count >= MAX_COUNT)
      end
    end, self, false, true, false)
    self.progressTextTimer:Start()
  end
end

local function SetFillImg(self, curCount)
  if curCount < MAX_COUNT then
    self.fill_img:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_jindutiao_lv.png")
  else
    self.fill_img:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_jindutiao_huang.png")
  end
end

local function OnJumpClick(self)
  if not DataCenter.BuildManager:HasBuildByIdAndLevel(BuildingTypes.LW_BUILD_PUB, 1) then
    UIUtil.ShowTips(Localization:GetString("455146"))
    return
  end
  local itemInfo = self:GetUserData()
  if itemInfo and itemInfo.count < MAX_COUNT then
    return
  end
  local sequence = CS.DG.Tweening.DOTween.Sequence()
  sequence:Join(self.jump_btn.transform:DOScale(Vector3.New(0.1, 0.1, 0.1), 0.2))
  sequence:AppendCallback(function()
    self.view.ctrl:CloseSelf(true)
  end)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit)
end

UIRecruitCardRewardGetView.OnCreate = OnCreate
UIRecruitCardRewardGetView.OnDestroy = OnDestroy
UIRecruitCardRewardGetView.OnEnable = OnEnable
UIRecruitCardRewardGetView.OnDisable = OnDisable
UIRecruitCardRewardGetView.ComponentDefine = ComponentDefine
UIRecruitCardRewardGetView.ComponentDestroy = ComponentDestroy
UIRecruitCardRewardGetView.DataDefine = DataDefine
UIRecruitCardRewardGetView.DataDestroy = DataDestroy
UIRecruitCardRewardGetView.ReInit = ReInit
UIRecruitCardRewardGetView.OnJumpClick = OnJumpClick
UIRecruitCardRewardGetView.SetFillImg = SetFillImg
return UIRecruitCardRewardGetView
