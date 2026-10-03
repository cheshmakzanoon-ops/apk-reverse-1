local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_AllianceShare = BaseClass("AllianceShare", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")
local _cp_chatShareNode = ""
local _cp_allianceImg = "alliance_icon_bg/alliance_icon"
local _cp_btnApply = "Btns/btnJump"
local _cp_txtApply = "Btns/btnJump/btnTxtJump"
local _cp_btnDetail = "Btns/btnDetail"
local _cp_txtDetail = "Btns/btnDetail/btnTxtDetail"
local _cp_imgBg = "Image"
local _cp_allianceName_path = "AllianceName"
local _cp_member_path = "Member"
local _cp_shareMsg_path = "ShareMsg"
local _cp_country_path = "country"

function ChatItemPost_AllianceShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_AllianceShare:ComponentDefine()
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
  self._imgBg = self:AddComponent(UIImage, _cp_imgBg)
  self._country = self:AddComponent(UIImage, _cp_country_path)
end

function ChatItemPost_AllianceShare:OnClickBtnJump()
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
  local param = self._chatData.extra or self.attachmentData
  if param then
    local allianceId = param.allianceId or self.attachmentData.allianceId
    local language = param.language or self.attachmentData.language
    SFSNetwork.SendMessage(MsgDefines.AlApply, allianceId, 0, language)
  end
end

function ChatItemPost_AllianceShare:UpdateUserInfo()
end

function ChatItemPost_AllianceShare:OnClickBtnDetail()
  if self._chatData == nil then
    return
  end
  local param = self._chatData.extra or self.attachmentData
  if param then
    local inviteAlliance = param.inviteAlliance or self.attachmentData.inviteAlliance
    local allianceId = param.allianceId or self.attachmentData.allianceId
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true}, inviteAlliance, allianceId)
  end
end

function ChatItemPost_AllianceShare:OnLoaded()
  local _chatdata = self:ChatData()
  if _chatdata == nil then
    return
  end
  self._chatData = _chatdata
  self._btnApply:SetActive(not self._chatData:isMyChat())
  if self._chatData:isMyChat() then
    self._imgBg:LoadSprite(ChatInterface.GetChatUIPath(UIAssets.ChatItemBg_right))
  else
    self._imgBg:LoadSprite(ChatInterface.GetChatUIPath(UIAssets.ChatItemBg_left))
  end
  local senderUid = self._chatData.senderUid
  self._userInfo = ChatManager2:GetInstance().User:getChatUserInfo(senderUid, true)
  if string.IsNullOrEmpty(_chatdata.attachmentId) then
    self.attachmentData = {}
  else
    self.attachmentData = rapidjson.decode(_chatdata.attachmentId)
  end
  local param = _chatdata.extra or self.attachmentData
  if param then
    local abbr = param.abbr or self.attachmentData.abbr
    local inviteAlliance = param.inviteAlliance or self.attachmentData.inviteAlliance
    if abbr and inviteAlliance then
      self._allianceName:SetText("[" .. abbr .. "]" .. inviteAlliance)
      self._allianceName:SetActive(true)
    else
      self._allianceName:SetActive(false)
    end
    local curMember = param.curMember or self.attachmentData.curMember
    local maxMember = param.maxMember or self.attachmentData.maxMember
    if curMember and maxMember then
      self._member:SetText(curMember .. "/" .. maxMember)
      self._member:SetActive(true)
    else
      self._member:SetActive(false)
    end
    local country = param.country or self.attachmentData.country
    if country then
      local nationTemplate = DataCenter.NationTemplateManager:GetNationTemplate(country)
      local flagPath = nationTemplate:GetNationFlagPath()
      self._country:LoadSprite(flagPath)
      self._country:SetActive(true)
    else
      self._country:SetActive(false)
    end
    local icon = param.icon or self.attachmentData.icon
    if icon then
      self._allianceImg:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, icon))
      self._allianceImg:SetActive(true)
    else
      self._allianceImg:SetActive(false)
    end
  else
    self._allianceName:SetActive(false)
    self._member:SetActive(false)
    self._country:SetActive(false)
    self._allianceImg:SetActive(false)
  end
  self._share:SetLocalText(391091)
  self._txtApply:SetLocalText(393090)
  self._txtDetail:SetLocalText(393089)
  if self._chatHead ~= nil then
    self._chatHead:UpdateHead(self._userInfo, self._chatData)
  end
  if self._chatUserName then
    self._chatUserName:UpdateName(self._userInfo, self._chatData)
  end
end

function ChatItemPost_AllianceShare:OnRecycle()
end

return ChatItemPost_AllianceShare
