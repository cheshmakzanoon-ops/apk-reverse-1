local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_SeasonPhoto = BaseClass("SeasonPhoto", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")
local _cp_chatShareNode = ""
local _cp_allianceImg = "alliance_icon_bg/alliance_icon"
local _cp_btnDetail = "btnDetail"
local _cp_txtDetail = "btnDetail/btnTxtDetail"
local _cp_imgBg = "Image"
local _cp_allianceName_path = "AllianceName"
local _cp_shareMsg_path = "ShareMsg"

function ChatItemPost_SeasonPhoto:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_SeasonPhoto:ComponentDefine()
  self._chatShareNode = self:AddComponent(UIBaseContainer, _cp_chatShareNode)
  self._allianceImg = self:AddComponent(UIImage, _cp_allianceImg)
  self._btnDetail = self:AddComponent(UIButton, _cp_btnDetail)
  self._btnDetail:SetOnClick(BindCallback(self, self.OnClickBtnDetail))
  self._txtDetail = self:AddComponent(UIText, _cp_txtDetail)
  self._allianceName = self:AddComponent(UIText, _cp_allianceName_path)
  self._share = self:AddComponent(UIText, _cp_shareMsg_path)
  self._imgBg = self:AddComponent(UIImage, _cp_imgBg)
end

function ChatItemPost_SeasonPhoto:UpdateUserInfo()
end

function ChatItemPost_SeasonPhoto:OnClickBtnDetail()
  if self._chatData == nil then
    return
  end
  local param = self._chatData.extra or self.attachmentData
  if param then
    local season = param.season or self.attachmentData.season
    local allianceId = param.allianceId or self.attachmentData.allianceId
    local isMessage = param.isMessage or self.attachmentData.isMessage
    if isMessage then
      UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonPhotoMessageShare, {anim = true}, season, allianceId)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonPhotoCanvaShare, {anim = true}, season, allianceId)
    end
  end
end

function ChatItemPost_SeasonPhoto:OnLoaded()
  local _chatdata = self:ChatData()
  if _chatdata == nil then
    return
  end
  self._chatData = _chatdata
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
    local serverId = param.serverId or self.attachmentData.serverId or 0
    local abbr = param.abbr or self.attachmentData.abbr
    local allianceName = param.allianceName or self.attachmentData.allianceName
    if abbr and allianceName then
      self._allianceName:SetText(string.format("#%d[%s]%s", serverId, abbr, allianceName))
      self._allianceName:SetActive(true)
    else
      self._allianceName:SetActive(false)
    end
    local icon = param.icon or self.attachmentData.icon
    if icon then
      self._allianceImg:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, icon))
      self._allianceImg:SetActive(true)
    else
      self._allianceImg:SetActive(false)
    end
    local isMessage = param.isMessage or self.attachmentData.isMessage
    self._share:SetLocalText(isMessage and "season_alliance_photo_UI_35" or "season_alliance_photo_UI_2")
    self._txtDetail:SetLocalText(isMessage and "season_alliance_photo_UI_36" or "season_alliance_photo_UI_34")
  else
    self._allianceName:SetActive(false)
    self._allianceImg:SetActive(false)
  end
  if self._chatHead ~= nil then
    self._chatHead:UpdateHead(self._userInfo, self._chatData)
  end
  if self._chatUserName then
    self._chatUserName:UpdateName(self._userInfo, self._chatData)
  end
end

function ChatItemPost_SeasonPhoto:OnRecycle()
end

return ChatItemPost_SeasonPhoto
