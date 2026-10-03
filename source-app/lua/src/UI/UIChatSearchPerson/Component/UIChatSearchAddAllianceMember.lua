local UIChatSearchAllianceRankItem = require("UI.UIChatSearchPerson.Component.UIChatSearchAllianceRankItem")
local UIChatSearchAddAllianceMember = BaseClass("UIChatSearchAddAllianceMember", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local _cp_txtLeaderName = "leader/leaderNameTxt"
local _cp_txtPower = "leader/power"
local _cp_objRankItem4 = "ScrollView/Viewport/Content/AllianceMemberBtnItem4"
local _cp_objRankItem3 = "ScrollView/Viewport/Content/AllianceMemberBtnItem3"
local _cp_objRankItem2 = "ScrollView/Viewport/Content/AllianceMemberBtnItem2"
local _cp_objRankItem1 = "ScrollView/Viewport/Content/AllianceMemberBtnItem1"
local _cp_btnAllianceInvite = "btnAllianceInvite"
local _cp_txtAllianceInvite = "btnAllianceInvite/txtAllianceInvite"
local _cp_leaderToggleBtn = "leader/leaderToggleBtn"

function UIChatSearchAddAllianceMember:ComponentDefine()
  self._txtLeaderName = self:AddComponent(UIText, _cp_txtLeaderName)
  self._txtPower = self:AddComponent(UIText, _cp_txtPower)
  self._objRankItem = {}
  self._objRankItem[1] = self:AddComponent(UIChatSearchAllianceRankItem, _cp_objRankItem1)
  self._objRankItem[2] = self:AddComponent(UIChatSearchAllianceRankItem, _cp_objRankItem2)
  self._objRankItem[3] = self:AddComponent(UIChatSearchAllianceRankItem, _cp_objRankItem3)
  self._objRankItem[4] = self:AddComponent(UIChatSearchAllianceRankItem, _cp_objRankItem4)
  self._btnAllianceInvite = self:AddComponent(UIButton, _cp_btnAllianceInvite)
  self._btnAllianceInvite:SetOnClick(BindCallback(self, self.OnClickBtnInvite))
  self._txtAllianceInvite = self:AddComponent(UIText, _cp_txtAllianceInvite)
  self._leaderToggleBtn = self:AddComponent(UIToggle, _cp_leaderToggleBtn)
end

function UIChatSearchAddAllianceMember:DataInit()
end

function UIChatSearchAddAllianceMember:OnCreate()
  base.OnCreate(self)
  self:DataInit()
  self:ComponentDefine()
  self._txtAllianceInvite:SetLocalText(GameDialogDefine.CONFIRM)
end

function UIChatSearchAddAllianceMember:OnEnable()
  base.OnEnable(self)
end

function UIChatSearchAddAllianceMember:OnDisable()
  base.OnDisable(self)
end

function UIChatSearchAddAllianceMember:ReInit()
  self.view.ctrl:InitAllianceMemberData()
  self.uidArr = {}
end

function UIChatSearchAddAllianceMember:OnAddListener()
  self:AddUIListener(EventId.AllianceMember, self.OnRefresh)
end

function UIChatSearchAddAllianceMember:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceMember, self.OnRefresh)
end

function UIChatSearchAddAllianceMember:OnRefresh()
  local leaderData = self.view.ctrl:GetLeaderInfo()
  if leaderData == nil then
    return
  end
  self:InitAllianceLeaderState()
  self._txtLeaderName:SetText(leaderData.name)
  self._txtPower:SetText(leaderData.power)
  for k, v in pairs(self._objRankItem) do
    v:RefreshData(k)
  end
end

function UIChatSearchAddAllianceMember:InitAllianceLeaderState()
  local leaderInfo = self.view.ctrl:GetLeaderInfo()
  if leaderInfo and leaderInfo.uid ~= "" and self.view.ctrl:IsUserInChatRoom(leaderInfo.uid) then
    self._leaderToggleBtn:SetIsOn(true)
    self._leaderToggleBtn:SetEnabled(false)
  else
    self._leaderToggleBtn:SetIsOn(false)
  end
end

function UIChatSearchAddAllianceMember:OnClickBtnInvite()
  local userinfolist = {}
  for k, v in pairs(self._objRankItem) do
    table.insertto(userinfolist, v:GetUserInfoList())
  end
  if self._leaderToggleBtn:GetIsOn() then
    local leaderUserInfo = self.view.ctrl:GetLeaderInfo()
    if leaderUserInfo and not self.view.ctrl:IsUserInChatRoom(leaderUserInfo.uid) then
      userinfolist[#userinfolist + 1] = {
        name = leaderUserInfo.name,
        uid = leaderUserInfo.uid
      }
    end
  end
  self.uidArr = {}
  self.roomName = ""
  local str = ""
  local spaceStr = ","
  local myName = ChatInterface.getPlayerName()
  for _, userInfo in pairs(userinfolist) do
    local memberName = ""
    if userInfo.name then
      memberName = userInfo.name
      table.insert(self.uidArr, userInfo.uid)
    elseif userInfo.learderName then
      memberName = userInfo.learderName
      table.insert(self.uidArr, userInfo.learderUid)
    end
    if myName ~= memberName then
      if str ~= "" then
        str = str .. spaceStr .. memberName
      else
        str = memberName
      end
    end
  end
  if str == "" then
    self.roomName = myName
    self:CreateRoom()
  else
    self.roomName = myName .. spaceStr .. str
    local endStr = Localization:GetString("290025", str)
    self:GotoAlterView(endStr)
  end
end

function UIChatSearchAddAllianceMember:CreateRoom()
  if self.view.ctrl.chatRoomdId ~= nil then
    self:AddMemberToChatRoom()
  else
    self:CreateNewRoom()
  end
  self.view.ctrl:CloseSelf()
end

function UIChatSearchAddAllianceMember:CreateNewRoom()
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_CREATE_COMMAND, {
    name = self.roomName,
    memberList = self.uidArr
  })
end

function UIChatSearchAddAllianceMember:AddMemberToChatRoom()
  local roomData = self.view.ctrl:GetRoomData()
  if not roomData then
    return
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.ROOM_INVITE_COMMAND, {
    roomId = roomData.roomId,
    uidArr = self.uidArr
  })
end

function UIChatSearchAddAllianceMember:GotoAlterView(message)
  UIUtil.ShowMessage(message, 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    self:CreateRoom()
  end)
end

return UIChatSearchAddAllianceMember
