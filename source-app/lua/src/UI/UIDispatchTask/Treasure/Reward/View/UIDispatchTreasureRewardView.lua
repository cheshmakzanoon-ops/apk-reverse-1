local base = UIBaseView
local UIDispatchTreasureRewardView = BaseClass("UIDispatchTreasureRewardView", base)
local anim_Path = "Root/Eff_ui_ymjdbox_ani"
local effect1_Path = "Root/Eff_ui_ymjdbox_ani/Eff_ui_ymjd_baoxiangkaiqi2"
local effect2_Path = "Root/Eff_ui_ymjdbox_ani/Eff_ui_ymjd_baoxiangkaiqi1"
local effect3_Path = "Root/Eff_ui_ymjdbox_ani/Eff_ui_ymjd_baoxiangkaiqi3"
local path = "Assets/Main/TextureEx/UIDispatchTreasure/%s.png"
local animClips = {
  "Eff_ui_ymjddbox2",
  "Eff_ui_ymjddbox1",
  "Eff_ui_ymjddbox3"
}

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

local function OnEnable(self)
  base.OnEnable(self)
  self:ShowAnim()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.Anim = self:AddComponent(UIAnimator, anim_Path)
  self.Effect1 = self:AddComponent(UIBaseContainer, effect1_Path)
  self.Effect2 = self:AddComponent(UIBaseContainer, effect2_Path)
  self.Effect3 = self:AddComponent(UIBaseContainer, effect3_Path)
end

local function ComponentDestroy(self)
  self.Anim = nil
  self.Effect1 = nil
  self.Effect2 = nil
  self.Effect3 = nil
end

local function DataDefine(self)
  self.message, self.closeCallback = self:GetUserData()
  self.timer = nil
  local msg = self.message
  
  function self.timer_action(temp)
    self.ctrl:ShowReward(msg, self.closeCallback)
  end
  
  self.ctrl:SetView(self)
end

local function DataDestroy(self)
  self:DeleteTimer()
  self.message = nil
  self.closeCallback = nil
  self.timer = nil
  self.timer_action = nil
end

local function ShowAnim(self)
  if self.message.boxArray and self.message.boxArray[1] then
    local type = self.message.boxArray[1].type + 1
    self.Effect1:SetActive(false)
    self.Effect2:SetActive(false)
    self.Effect3:SetActive(false)
    self.Anim:Play(animClips[type])
    self["Effect" .. type]:SetActive(true)
    self:AddTimer(1.5)
  end
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self, time)
  self:DeleteTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(time, self.timer_action, self, true, false, false)
  end
  self.timer:Start()
end

UIDispatchTreasureRewardView.OnCreate = OnCreate
UIDispatchTreasureRewardView.OnDestroy = OnDestroy
UIDispatchTreasureRewardView.OnEnable = OnEnable
UIDispatchTreasureRewardView.OnDisable = OnDisable
UIDispatchTreasureRewardView.ComponentDefine = ComponentDefine
UIDispatchTreasureRewardView.ComponentDestroy = ComponentDestroy
UIDispatchTreasureRewardView.DataDefine = DataDefine
UIDispatchTreasureRewardView.DataDestroy = DataDestroy
UIDispatchTreasureRewardView.ShowAnim = ShowAnim
UIDispatchTreasureRewardView.AddTimer = AddTimer
UIDispatchTreasureRewardView.DeleteTimer = DeleteTimer
return UIDispatchTreasureRewardView
