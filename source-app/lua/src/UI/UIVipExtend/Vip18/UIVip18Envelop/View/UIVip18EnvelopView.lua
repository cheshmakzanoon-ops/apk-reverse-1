local UIVip18EnvelopView = BaseClass("UIVip18EnvelopView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local UnityEngine = CS.UnityEngine
local STATE_MOVEIN_NAME = "UIVip18Envelop_movein"
local STATE_IDLE_NAME = "UIVip18Envelop_idle"
local STATE_OPEN_NAME = "UIVip18Envelop_open"
local STATE_OPEN_IDLE_NAME = "UIVip18Envelop_open_idle"
local STATE_MOVEOUT_NAME = "UIVip18Envelop_moveout"
local STATE_MOVEIN_HASH = 0
local STATE_IDLE_HASH = 0
local STATE_OPEN_HASH = 0
local STATE_OPEN_IDLE_HASH = 0
local STATE_MOVEOUT_HASH = 0
local TRIGGER_OPEN = "PlayOpen"
local TRIGGER_CLOSE = "PlayClose"
local EnvelopState = {
  MovingIn = 1,
  ClosedIdle = 2,
  Opening = 3,
  OpenIdle = 4,
  MovingOut = 5
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  STATE_MOVEIN_HASH = UnityEngine.Animator.StringToHash(STATE_MOVEIN_NAME)
  STATE_IDLE_HASH = UnityEngine.Animator.StringToHash(STATE_IDLE_NAME)
  STATE_OPEN_HASH = UnityEngine.Animator.StringToHash(STATE_OPEN_NAME)
  STATE_OPEN_IDLE_HASH = UnityEngine.Animator.StringToHash(STATE_OPEN_IDLE_NAME)
  STATE_MOVEOUT_HASH = UnityEngine.Animator.StringToHash(STATE_MOVEOUT_NAME)
  self.currState = EnvelopState.MovingIn
  self.textDearTMP:SetLocalText("vip18_envelop_dear", LuaEntry.Player.name)
  self.reward_btn:SetActive(false)
  local envelopItemId = LuaEntry.DataConfig:TryGetNum("vip_letter", "k2")
  local item = DataCenter.ItemData:GetItemById(envelopItemId)
  if item == nil then
    return
  end
  if item.otherParam == nil then
    return
  end
  local serverData = rapidjson.decode(item.otherParam)
  if serverData == nil then
    return
  end
  local isExistReward = serverData.state == nil or toInt(serverData.state) == 0
  if isExistReward then
    self.reward_btn:SetActive(true)
  else
    self.reward_btn:SetActive(false)
  end
end

function UIVip18EnvelopView:Update()
  if self.mainAnimator == nil then
    return
  end
  local stateInfo = self.mainAnimator:GetCurrentAnimatorStateInfo(0)
  local currentHash = stateInfo.shortNameHash
  if self.currState == EnvelopState.MovingIn and currentHash == STATE_IDLE_HASH then
    self.currState = EnvelopState.ClosedIdle
  end
  if self.currState == EnvelopState.Opening and currentHash == STATE_OPEN_IDLE_HASH then
    self.currState = EnvelopState.OpenIdle
  end
  if self.currState == EnvelopState.MovingOut and currentHash == STATE_MOVEOUT_HASH and stateInfo.normalizedTime >= 0.95 then
    self:RealCloseWindow()
  end
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
  self.mainAnimator = self.transform:GetComponent(typeof(UnityEngine.Animator))
  self.btnBlack = self:AddComponent(UIButton, "black")
  self.btnBlack:SetOnClick(function()
    self:OnBtnBlackClick()
  end)
  self.btnConfirm = self:AddComponent(UIButton, "PartLetter/canvasGroup/Scroll View/Viewport/Content/BlockToGet/ConfirmBtn")
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.btnLWClose = self:AddComponent(UIButton, "PartLetter/canvasGroup/LW_Btn_Close")
  self.btnLWClose:SetOnClick(function()
    self:OnBtnLWCloseClick()
  end)
  self.textDearTMP = self:AddComponent(UITextMeshProUGUIEx, "PartLetter/canvasGroup/Scroll View/Viewport/Content/DearTMP")
  self.reward_btn = self:AddComponent(UIButton, "PartLetter/canvasGroup/RewardBtn")
  self.reward_btn:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
end

local function ComponentDestroy(self)
  self.animatorPartLetter = nil
  self.btnBlack = nil
  self.btnConfirm = nil
  self.btnLWClose = nil
  self.textDearTMP = nil
  self.reward_btn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self:OnBtnRewardClick()
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIVipPurchase) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIVipPurchase)
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UICapacityTable) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UICapacityTable)
  end
  if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIVip) then
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIVip)
    if window ~= nil and window.View ~= nil then
      window.View:RefreshVipContentIndex()
    end
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnBlackClick(self)
  if (self.currState == EnvelopState.MovingIn or self.currState == EnvelopState.ClosedIdle) and self.mainAnimator then
    self.mainAnimator:SetTrigger(TRIGGER_OPEN)
    self.currState = EnvelopState.Opening
  end
end

local function OnBtnRewardClick(self)
  local envelopItemId = LuaEntry.DataConfig:TryGetNum("vip_letter", "k2")
  local item = DataCenter.ItemData:GetItemById(envelopItemId)
  if item == nil then
    return
  end
  if item.otherParam == nil then
    return
  end
  local serverData = rapidjson.decode(item.otherParam)
  if serverData == nil then
    return
  end
  local isExistReward = serverData.state == nil or toInt(serverData.state) == 0
  if isExistReward then
    SFSNetwork.SendMessage(MsgDefines.PostCardReceiveMessage, tostring(envelopItemId))
    self.reward_btn:SetActive(false)
  end
end

local function OnBtnConfirmClick(self)
  self:RealCloseWindow()
  PostEventLog.Track(PostEventLog.Defines.Vip18SkinPageEnter, {
    source = "invitation_letter"
  })
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIVipExtend, {anim = true})
end

local function OnBtnLWCloseClick(self)
  if (self.currState == EnvelopState.OpenIdle or self.currState == EnvelopState.Opening) and self.mainAnimator then
    self.mainAnimator:SetTrigger(TRIGGER_CLOSE)
    self.currState = EnvelopState.MovingOut
  end
end

function UIVip18EnvelopView:RealCloseWindow()
  self.ctrl.CloseSelf()
end

UIVip18EnvelopView.OnCreate = OnCreate
UIVip18EnvelopView.OnDestroy = OnDestroy
UIVip18EnvelopView.OnEnable = OnEnable
UIVip18EnvelopView.OnDisable = OnDisable
UIVip18EnvelopView.ComponentDefine = ComponentDefine
UIVip18EnvelopView.ComponentDestroy = ComponentDestroy
UIVip18EnvelopView.DataDefine = DataDefine
UIVip18EnvelopView.DataDestroy = DataDestroy
UIVip18EnvelopView.OnAddListener = OnAddListener
UIVip18EnvelopView.OnRemoveListener = OnRemoveListener
UIVip18EnvelopView.OnBtnBlackClick = OnBtnBlackClick
UIVip18EnvelopView.OnBtnConfirmClick = OnBtnConfirmClick
UIVip18EnvelopView.OnBtnRewardClick = OnBtnRewardClick
UIVip18EnvelopView.OnBtnLWCloseClick = OnBtnLWCloseClick
return UIVip18EnvelopView
