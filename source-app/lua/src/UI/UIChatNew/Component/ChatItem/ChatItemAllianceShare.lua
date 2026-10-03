local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemAllianceShare = BaseClass("ChatItemAllianceShare", IChatItem)
local base = IChatItem
local Localization = CS.GameEntry.Localization
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local ChatUserName = require("UI.UIChatNew.Component.ChatItem.ChatUserName")
local _cp_headIcon = "ChatHead"
local _cp_chatName = "ChatNameLayout"
local _cp_chatShareNode = "ChatShareAllianceNode"
local _cp_allianceImg = "ChatShareAllianceNode/alliance_icon_bg/alliance_icon"
local _cp_btnApply = "ChatShareAllianceNode/Btns/btnJump"
local _cp_txtApply = "ChatShareAllianceNode/Btns/btnJump/btnTxtJump"
local _cp_btnDetail = "ChatShareAllianceNode/Btns/btnDetail"
local _cp_txtDetail = "ChatShareAllianceNode/Btns/btnDetail/btnTxtDetail"
local _cp_imgBg = "ChatShareAllianceNode/Image"
local _cp_allianceName_path = "ChatShareAllianceNode/AllianceName"
local _cp_member_path = "ChatShareAllianceNode/Member"
local _cp_shareMsg_path = "ChatShareAllianceNode/ShareMsg"
local _cp_country_path = "ChatShareAllianceNode/country"

function ChatItemAllianceShare:ComponentDefine()
  self._chatHead = self:AddComponent(ChatHead, _cp_headIcon)
  self._chatShareNode = self:AddComponent(UIBaseContainer, _cp_chatShareNode)
  self._allianceImg = self:AddComponent(UIImage, _cp_allianceImg)
  self._btnApply = self:AddComponent(UIButton, _cp_btnApply)
  self._btnApply:SetOnClick(BindCallback(self, self.OnClickBtnJump))
  self._txtApply = self:AddComponent(UIText, _cp_txtApply)
  self._btnDetail = self:AddComponent(UIButton, _cp_btnDetail)
  self._btnDetail:SetOnClick(BindCallback(self, self.OnClickBtnDetail))
  self._txtDetail = self:AddComponent(UIText, _cp_txtDetail)
  self._allianceName = self:AddComponent(UIText, _cp_allianceName_path)
  self._member = self:AddComponent(UIText, _cp_member_path)
  self._share = self:AddComponent(UIText, _cp_shareMsg_path)
  self._imgBg = self:AddComponent(UIBaseContainer, _cp_imgBg)
  self._country = self:AddComponent(UIImage, _cp_country_path)
  if self.transform:Find(_cp_chatName) ~= nil then
    self._chatUserName = self:AddComponent(ChatUserName, _cp_chatName)
  end
end

function ChatItemAllianceShare:OnClickBtnJump()
  if not DataCenter.BuildManager:HasBuildByIdAndLevel(BuildingTypes.LW_BUILD_ALLIANCE_CENTER, 1) then
    UIUtil.ShowTipsId("alliance_err_building")
    return
  end
  if LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(393092)
    return
  end
  if self._chatData == nil then
    return
  end
  local param = self._chatData.extra
  if param then
    SFSNetwork.SendMessage(MsgDefines.AlApply, param.allianceId, 0, param.language)
  end
end

function ChatItemAllianceShare:OnClickBtnDetail()
  if self._chatData == nil then
    return
  end
  local param = self._chatData.extra
  if param then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true}, param.inviteAlliance, param.allianceId)
  end
end

function ChatItemAllianceShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemAllianceShare:UpdateUserInfo()
end

function ChatItemAllianceShare:UpdateItem(_chatdata)
  if _chatdata == nil then
    return
  end
  self._chatData = _chatdata
  local senderUid = self._chatData.senderUid
  self._userInfo = ChatManager2:GetInstance().User:getChatUserInfo(senderUid, true)
  local param = _chatdata.extra
  if param then
    if param.abbr and param.inviteAlliance then
      self._allianceName:SetText("[" .. param.abbr .. "]" .. param.inviteAlliance)
    end
    if param.curMember and param.maxMember then
      self._member:SetText(param.curMember .. "/" .. param.maxMember)
    end
    if param.country then
      local nationTemplate = DataCenter.NationTemplateManager:GetNationTemplate(param.country)
      local flagPath = nationTemplate:GetNationFlagPath()
      self._country:LoadSprite(flagPath)
    end
  end
  self._share:SetLocalText(391091)
  self._txtApply:SetLocalText(393090)
  self._txtDetail:SetLocalText(393089)
  if param.icon then
    self._allianceImg:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, param.icon))
  end
  if self._chatHead ~= nil then
    self._chatHead:UpdateHead(self._userInfo, self._chatData)
  end
  if self._chatUserName then
    self._chatUserName:UpdateName(self._userInfo, self._chatData)
  end
end

return ChatItemAllianceShare
