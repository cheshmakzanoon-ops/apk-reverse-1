local AllianceWarJoinItem = BaseClass("AllianceWarJoinItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local join_obj = "join"
local name_path = "join/nameTxt"
local join_btn_path = "joinButton"
local state_txt_path = "stateTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self.join_obj = self:AddComponent(UIBaseContainer, join_obj)
  self.name = self:AddComponent(UIText, name_path)
  self.state = self:AddComponent(UIText, state_txt_path)
  self.state:SetLocalText(GameDialogDefine.QUEUE_FULL)
  self.join_btn = self:AddComponent(UIButton, join_btn_path)
  self.join_btn:SetOnClick(function()
    self:OnJoinClick()
  end)
end

local function OnDestroy(self)
  self.join_obj = nil
  self.name = nilarmyContent
  self.state = nil
  self.join_btn = nil
  self.helpData = nil
  base.OnDestroy(self)
end

local function SetState(self, canJoin, helpData)
  self.join_obj:SetActive(canJoin)
  self.state:SetActive(canJoin == false)
  self.join_btn:SetActive(canJoin)
  self.join_btn:SetAnchoredPosition(Vector2.New(0, 0))
  if helpData then
    self.name:SetLocalText(141019)
  else
    self.name:SetLocalText(110007)
  end
  self.helpData = helpData
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnJoinClick(self)
  self.view.ctrl:OnJoinClick(self.view.ctrl:GetSelfUuid(), self.helpData)
end

AllianceWarJoinItem.OnCreate = OnCreate
AllianceWarJoinItem.OnDestroy = OnDestroy
AllianceWarJoinItem.OnEnable = OnEnable
AllianceWarJoinItem.OnDisable = OnDisable
AllianceWarJoinItem.SetState = SetState
AllianceWarJoinItem.OnJoinClick = OnJoinClick
return AllianceWarJoinItem
