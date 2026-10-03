local JoinAssistanceItem = BaseClass("JoinAssistanceItem", UIBaseContainer)
local base = UIBaseContainer
local join_obj = "join"
local name_path = "join/nameTxt"
local join_btn_path = "joinButton"
local state_txt_path = "stateTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self.join_obj = self:AddComponent(UIBaseContainer, join_obj)
  self.name = self:AddComponent(UIText, name_path)
  self.name:SetLocalText(GameDialogDefine.CLICK_TO_JOIN)
  self.state = self:AddComponent(UIText, state_txt_path)
  self.join_btn = self:AddComponent(UIButton, join_btn_path)
  self.join_btn:SetOnClick(function()
    self:OnJoinClick()
  end)
end

local function OnDestroy(self)
  self.join_obj = nil
  self.name = nil
  self.state = nil
  self.join_btn = nil
  base.OnDestroy(self)
end

local function SetState(self, canJoin, alreadyHave, isUnLock)
  if isUnLock then
    self.state:SetLocalText(GameDialogDefine.QUEUE_FULL)
  else
    self.state:SetLocalText(300544)
  end
  self.join_obj:SetActive(canJoin)
  self.state:SetActive(canJoin == false)
  self.join_btn:SetActive(canJoin)
  self.alreadyHave = alreadyHave
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnJoinClick(self)
  if self.alreadyHave == false then
    self.view:OnJoinClick()
  else
    UIUtil.ShowTipsId(121219)
  end
end

JoinAssistanceItem.OnCreate = OnCreate
JoinAssistanceItem.OnDestroy = OnDestroy
JoinAssistanceItem.OnEnable = OnEnable
JoinAssistanceItem.OnDisable = OnDisable
JoinAssistanceItem.SetState = SetState
JoinAssistanceItem.OnJoinClick = OnJoinClick
return JoinAssistanceItem
