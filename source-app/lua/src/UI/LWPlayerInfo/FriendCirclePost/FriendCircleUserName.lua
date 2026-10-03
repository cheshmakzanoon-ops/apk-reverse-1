local FriendCircleUserName = BaseClass("FriendCircleUserName", UIBaseContainer)
local base = UIBaseContainer
local ChatMessageHelper = require("Chat.Other.ChatMessageHelper")
local logger = require("Framework.Logger.Logger")
local compBook = {
  {
    path = "Line",
    name = "layout",
    type = nil
  },
  {
    path = "Line/VipLevelBadge",
    name = "vipBadge",
    type = UIVipLevelBadge
  },
  {
    path = "Line/UIAlOfficialPos",
    name = "nodeAlOfficial",
    type = UIBaseContainer
  },
  {
    path = "Line/UIAlOfficialPos/Name",
    name = "txtAlOfficial",
    type = UIText
  },
  {
    path = "Line/Gender",
    name = "nodeGender",
    type = nil
  },
  {
    path = "Line/Gender/Man",
    name = "iconMale",
    type = nil
  },
  {
    path = "Line/Gender/Woman",
    name = "iconFemale",
    type = nil
  },
  {
    path = "Line/Government",
    name = "nodeGover",
    type = UIBaseContainer
  },
  {
    path = "Line/Government/icon",
    name = "iconGover",
    type = UIImage
  },
  {
    path = "Line/SenderLv",
    name = "txtUserLv",
    type = UIText
  },
  {
    path = "Line/NameText",
    name = "txtUserName",
    type = UIText
  },
  {
    path = "Line/UIAI",
    name = "txtAI",
    type = UIText
  }
}

function FriendCircleUserName:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function FriendCircleUserName:HideInfo()
  self.vipBadge:SetActive(false)
  self.txtUserLv:SetActive(false)
  self.nodeGender:SetActive(false)
  self.nodeAlOfficial:SetActive(false)
end

function FriendCircleUserName:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.uid = nil
  self.chatData = nil
  self.alignToRight = false
  self.isShowGender = false
  self.isShowGover = false
  self.isShowTxtAI = false
  self.nameColor = Color32.New(0, 0, 0, 1)
  self.nameOutlineColor = Color.New(64, 23, 9, 255)
end

function FriendCircleUserName:OnDestroy()
  self:ClearCompsByBook(compBook)
  base.OnDestroy(self)
  self.chatData = nil
  self.uid = nil
  self.isShowGender = false
  self.isShowGover = false
  self.isShowTxtAI = false
  self.nameColor = nil
  self.nameOutlineColor = nil
end

function FriendCircleUserName:OnAddListener()
  self:AddUIListener(EventId.ChatUserInfoUpdate, self.OnChatUserInfoUpdate)
  self:AddUIListener(EventId.UserSkinUpdate, self.OnUserSkinUpdate)
end

function FriendCircleUserName:OnRemoveListener()
  self:RemoveUIListener(EventId.ChatUserInfoUpdate, self.OnChatUserInfoUpdate)
  self:RemoveUIListener(EventId.UserSkinUpdate, self.OnUserSkinUpdate)
end

function FriendCircleUserName:UpdateLayout()
  if self.layout then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout.transform)
  end
end

function FriendCircleUserName:OnChatUserInfoUpdate(uid)
  if self.uid and self.uid == uid and self.chatData then
    local userInfo = ChatInterface.getUserData(uid)
    if userInfo then
      self:UpdateName(userInfo, self.chatData)
    end
  end
end

function FriendCircleUserName:OnUserSkinUpdate()
  local selfUid = LuaEntry.Player.uid
  if self.uid ~= selfUid then
    return
  end
  local curNameColorId = DataCenter.DecorationDataManager:GetWearingNameColorSkinId()
  local userInfo = ChatInterface.getUserData(selfUid)
  if userInfo then
    userInfo:SetGoldNameSkinId(curNameColorId)
    self:UpdateName(userInfo, self.chatData)
  end
end

function FriendCircleUserName:UpdateForAI(chatData, aiName)
  self.nodeGender:SetActive(false)
  self.isShowGender = false
  self.vipBadge:SetActive(false)
  self._careerLabel:SetActive(false)
  self.nodeAlOfficial:SetActive(false)
  if self.txtAI ~= nil then
    self.txtAI:SetActive(true)
    self.isShowTxtAI = true
    if chatData ~= nil and chatData.roomId ~= nil and chatData.roomId:find("country_") ~= nil then
      self.txtAI:SetLocalText(900512)
    else
      self.txtAI:SetLocalText(900510)
    end
  end
  if self.txtUserLv ~= nil then
    self.txtUserLv:SetActive(false)
  end
  if self.nodeGover ~= nil then
    self.nodeGover:SetActive(false)
    self.isShowGover = false
  end
  self:ComposeName(aiName, nil, nil)
  self:UpdateLayout()
  TimerManager:GetInstance():GetTimer(1, function()
    self:UpdateLayout()
  end, self, true, true):Start()
end

function FriendCircleUserName:UpdateName(userInfo, chatData)
  if userInfo == nil then
    self.txtUserName:SetText("")
    self:UpdateVIP(userInfo)
    return
  end
  self.uid = userInfo.uid
  self.chatData = chatData
  local senderName = chatData:getSenderNameWithAlliance()
  local serverId = userInfo:getServerId()
  if self.txtAI ~= nil then
    self.txtAI:SetActive(false)
    self.isShowTxtAI = false
  end
  if self.txtUserLv ~= nil then
    local senderLevel = 0
    if userInfo and userInfo.mainBuildingLevel and 0 < userInfo.mainBuildingLevel then
      senderLevel = userInfo.mainBuildingLevel
    elseif chatData and chatData.senderLevel and 0 < chatData.senderLevel then
      senderLevel = chatData.senderLevel
    end
    if senderLevel == nil then
      self.txtUserLv:SetActive(false)
    else
      self.txtUserLv:SetActive(true)
      self.txtUserLv:SetText("Lv." .. senderLevel)
      if self.txtUserLv.unity_tmpro then
        local curSkinId = userInfo:GetGoldNameSkinId() or 0
        local isGetGoldName = DataCenter.DecorationDataManager:IsGoldName(curSkinId)
        self.txtUserLv.unity_tmpro.enableVertexGradient = isGetGoldName
        self.txtUserLv.unity_tmpro.outlineWidth = isGetGoldName and 0.5 or 0
        if isGetGoldName then
          self.txtUserLv.unity_tmpro.outlineColor = self.nameOutlineColor
          self.txtUserLv:SetColor(Color32.white)
        else
          self.txtUserLv:SetColor(ChatUIThemeConfig.LevelColor[ChatInterface.GetChatTheme()])
        end
      end
    end
  end
  if self.nodeGover ~= nil then
    local governmentInfo = DataCenter.GovernmentManager:GetPositionInfoByUID(userInfo.uid)
    if governmentInfo ~= nil then
      local configData = DataCenter.GovernmentTemplateManager:GetTemplate(governmentInfo.positionId)
      if configData == nil then
        self.nodeGover:SetActive(false)
        self.isShowGover = false
      else
        self.nodeGover:SetActive(true)
        self.iconGover:LoadSprite(configData.icon)
        self.isShowGover = true
      end
    else
      self.nodeGover:SetActive(false)
      self.isShowGover = false
    end
  end
  self:ComposeName(senderName, serverId, userInfo)
  self:HideInfo()
  self:UpdateLayout()
  TimerManager:GetInstance():GetTimer(1, function()
    self:UpdateLayout()
  end, self, true, true):Start()
end

function FriendCircleUserName:SetChangeColor(isChange)
  self.isChange = isChange
end

function FriendCircleUserName:ComposeName(senderName, serverId, userInfo)
  local myServerId = ChatInterface.getSelfServerId()
  if self.txtUserName.unity_tmpro then
    local curSkinId = 0
    if userInfo then
      curSkinId = userInfo:GetGoldNameSkinId() or 0
    end
    local isGetGoldName = DataCenter.DecorationDataManager:IsGoldName(curSkinId)
    self.txtUserName.unity_tmpro.enableVertexGradient = isGetGoldName
    self.txtUserName.unity_tmpro.outlineWidth = isGetGoldName and 0.5 or 0
    if isGetGoldName then
      self.txtUserName.unity_tmpro.outlineColor = self.nameOutlineColor
      self.txtUserName:SetColor(Color32.white)
    elseif self.isChange then
      if serverId ~= myServerId and serverId ~= nil and 0 < serverId then
        senderName = "#" .. serverId .. senderName
        self.txtUserName:SetColor(ChatUIThemeConfig.NameColor[ChatInterface.GetChatTheme()])
      else
        self.txtUserName:SetColor(ChatUIThemeConfig.ChatNameColor[ChatInterface.GetChatTheme()])
      end
    elseif serverId ~= myServerId and serverId ~= nil and 0 < serverId then
      senderName = "#" .. serverId .. senderName
      self.txtUserName:SetColor(Color32.red)
    else
      self.txtUserName:SetColor(self.nameColor)
    end
  end
  if not self.isShowGender and not self.isShowGover and not self.isShowTxtAI then
    senderName = " " .. senderName
  end
  self.txtUserName:SetText(senderName)
end

function FriendCircleUserName:UpdateVIP(userInfo)
  if not userInfo then
    self.vipBadge:SetGlowEnable(false)
    self.vipBadge:SetActive(false)
    return
  end
  local svipLevel = tonumber(userInfo.svipLevel)
  local svipEndTime = tonumber(userInfo.svipEndTime) * 1000
  local showPass = userInfo.showVipLevel and userInfo.showVipLevel > 0
  local levelPass = 3 <= svipLevel
  local timePass = 0 < svipEndTime and svipEndTime > UITimeManager:GetInstance():GetServerTime()
  if not self.vipBadge then
    return
  end
  if showPass and levelPass and timePass then
    self.vipBadge:SetActive(true)
    self.vipBadge:SetVipLevel(svipLevel)
    self.vipBadge:SetGlowEnable(true)
  else
    self.vipBadge:SetGlowEnable(false)
    self.vipBadge:SetActive(false)
  end
end

function FriendCircleUserName:UpdateGender(userInfo)
  if not self.nodeGender then
    self.isShowGender = false
    return
  end
  self.nodeGender:SetActive(false)
  self.isShowGender = false
  if not (userInfo ~= nil and userInfo.gender) or userInfo.gender == 0 or userInfo.gender == 3 then
    return
  end
  self.nodeGender:SetActive(true)
  self.isShowGender = true
  local isMan = userInfo.gender == 1
  self.iconMale:SetActive(isMan)
  self.iconFemale:SetActive(not isMan)
end

function FriendCircleUserName:UpdateAlOfficialPos(userInfo, chatData)
  local channelType = ChatMessageHelper.getChannelFromRoomId(chatData.roomId, chatData.post)
  if channelType ~= ChatShareChannel.TO_ALLIANCE then
    self.nodeAlOfficial:SetActive(false)
    return
  end
  if not userInfo then
    self.nodeAlOfficial:SetActive(false)
    return
  end
  local officialPos = DataCenter.AllianceMemberDataManager:GetOfficialPosByUid(userInfo.uid)
  if officialPos then
    self.nodeAlOfficial:SetActive(true)
    self.txtAlOfficial:SetLocalText(AllianceOfficialPosConf[officialPos].name)
  else
    self.nodeAlOfficial:SetActive(false)
  end
end

return FriendCircleUserName
