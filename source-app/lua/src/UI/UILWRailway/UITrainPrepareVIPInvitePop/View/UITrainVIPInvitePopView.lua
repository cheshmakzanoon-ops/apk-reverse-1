local UITrainVIPInvitePopView = BaseClass("UITrainVIPInvitePopView", UIBaseView)
local UILWScienceDetailDesc = require("UI/UILWScience/UILWScienceDetail/Component/UILWScienceDetailDesc")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.closeBtn = self:AddComponent(UIButton, "black")
  self.luckyBtn = self:AddComponent(UIButton, "bg/container/LuckyCard/luckyBtn")
  self.bodyguardBtn = self:AddComponent(UIButton, "bg/container/BodyguardCard/bodyguardBtn")
  self.closeBtn:SetOnClick(function()
    self.ctrl.CloseSelf(self)
  end)
  self.luckyBtn:SetOnClick(function()
    self:OpenMemberListPop(0)
  end)
  self.bodyguardBtn:SetOnClick(function()
    self:OpenMemberListPop(1)
  end)
  self.detailBtn = self:AddComponent(UIButton, "bg/container/InfoBtn")
  self.detailBtn:SetOnClick(function()
    local param = {}
    param.activityRulesStr = Localization:GetString("alliance_train_vip_guest")
    param.hideSubTile = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetail, {anim = true}, param)
  end)
  self.luckyTitle = self:AddComponent(UILWScienceDetailDesc, "bg/container/LuckyCard/luckyTitle")
  self.bodyguardTitle = self:AddComponent(UILWScienceDetailDesc, "bg/container/BodyguardCard/bodyguardTitle")
  self.luckyTitle:SetTextAndParam(Localization:GetString("alliance_train_vip002"))
  self.bodyguardTitle:SetTextAndParam(Localization:GetString("alliance_train_vip003"))
  self.animator = self:AddComponent(UIAnimator, "")
  self.animatorTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.animator:Play("UITrainVIPInvitePopLoop", 0, 0)
  end, 0.5)
  self.bottomDesc = self:AddComponent(UIBaseComponent, "bg/bottomDesc")
  self.rewardToggle = self:AddComponent(UIToggle, "bg/rewardToggle")
  self.rewardToggleText = self:AddComponent(UITextMeshProUGUIEx, "bg/rewardToggle/rewardToggleText")
  self.rewardToggleText:SetText(Localization:GetString("alliance_train_vip052"))
  self.rewardToggle:SetOnValueChanged(function(isOn)
    self:OnRewardToggleChanged(isOn)
  end)
  local isVipSelfRewardOpen = LuaEntry.DataConfig:CheckSwitch("train_vip_reward")
  if isVipSelfRewardOpen then
    self.rewardToggle:SetActive(true)
    self.bottomDesc.rectTransform:Set_anchoredPosition(-281.39996 * CommonUtil.ArabicAutoMirrorFactor(), -354)
    self.bottomDesc.rectTransform:Set_sizeDelta(666.9003, 70)
  else
    self.rewardToggle:SetActive(false)
    self.bottomDesc.rectTransform:Set_anchoredPosition(-281.39996 * CommonUtil.ArabicAutoMirrorFactor(), -390)
    self.bottomDesc.rectTransform:Set_sizeDelta(666.9003, 100)
  end
end

local function ComponentDestroy(self)
  self.closeBtn = nil
  self.luckyBtn = nil
  self.bodyguardBtn = nil
  self.luckyTitle = nil
  self.bodyguardTitle = nil
end

local function DataDefine(self)
  SFSNetwork.SendMessage(MsgDefines.AllianceTrainVIPInviteList)
  local t = LuaEntry.Player:GetUserSetting(UserSettingKey.ALLIANCE_VIP_REWARD_SELF_SELECT)
  self.toggleOn = t ~= nil and t == "1"
  self.rewardToggle:SetIsOn(self.toggleOn)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OpenMemberListPop(self, num)
  local platformData = DataCenter.LWAllyStationDataManager:GetPlatform(1)
  if platformData.state == TrainPlatformState.TrainWithPassenger then
    UIUtil.ShowTips(Localization:GetString("alliance_train_vip028"))
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITrainVIPInviteList, {anim = true}, num)
    self.ctrl.CloseSelf(self)
  end
end

function UITrainVIPInvitePopView:OnRewardToggleChanged(isOn)
  if self.toggleOn == isOn then
    return
  end
  self.toggleOn = isOn
  if isOn then
    SFSNetwork.SendMessage(MsgDefines.UserSetting, UserSettingKey.ALLIANCE_VIP_REWARD_SELF_SELECT, "1")
  else
    SFSNetwork.SendMessage(MsgDefines.UserSetting, UserSettingKey.ALLIANCE_VIP_REWARD_SELF_SELECT, "0")
  end
end

UITrainVIPInvitePopView.OnCreate = OnCreate
UITrainVIPInvitePopView.OnDestroy = OnDestroy
UITrainVIPInvitePopView.OnEnable = OnEnable
UITrainVIPInvitePopView.OnDisable = OnDisable
UITrainVIPInvitePopView.ComponentDefine = ComponentDefine
UITrainVIPInvitePopView.ComponentDestroy = ComponentDestroy
UITrainVIPInvitePopView.DataDefine = DataDefine
UITrainVIPInvitePopView.DataDestroy = DataDestroy
UITrainVIPInvitePopView.OnAddListener = OnAddListener
UITrainVIPInvitePopView.OnRemoveListener = OnRemoveListener
UITrainVIPInvitePopView.OpenMemberListPop = OpenMemberListPop
return UITrainVIPInvitePopView
