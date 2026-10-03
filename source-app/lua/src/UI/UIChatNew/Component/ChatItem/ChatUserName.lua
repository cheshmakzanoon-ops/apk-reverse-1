local ChatUserName = BaseClass("ChatUserName", UIBaseContainer)
local base = UIBaseContainer
local ChatMessageHelper = require("Chat.Other.ChatMessageHelper")
local logger = require("Framework.Logger.Logger")
local Gov_Icon_Path = "Assets/Main/Prefabs/UI/ChatNew/ChatItemObj/ChatGovIcon.prefab"
local ChatGovIcon = require("UI.UIChatNew.Component.ChatItem.ChatGovIcon")
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
    type = UIGameObjectWrap
  },
  {
    path = "Line/Gender/Man",
    name = "iconMale",
    type = UIGameObjectWrap
  },
  {
    path = "Line/Gender/Woman",
    name = "iconFemale",
    type = UIGameObjectWrap
  },
  {
    path = "Line/Government",
    name = "nodeGover",
    type = UIBaseContainer
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
  },
  {
    path = "Line/PlayerTitle",
    name = "nodePlayerTitle",
    type = UIBaseContainer,
    active = false
  },
  {
    path = "Line/PlayerTitle/TitleIcon",
    name = "iconPlayerTitle",
    type = UIImage
  },
  {
    path = "Line/PlayerTitle/TitleBtn",
    name = "btnPlayerTitle",
    type = UIButton,
    onClick = function(self)
      self:OnPlayerTitleIconClick()
    end
  },
  {
    path = "Line/NameClickBtn",
    name = "btnPlayerName",
    type = UIButton,
    onClick = function(self)
      self:OnPlayerNameClick()
    end
  }
}

function ChatUserName:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function ChatUserName:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.uid = nil
  self.chatData = nil
  self.alignToRight = false
  self.isShowGender = false
  self.isShowGover = false
  self.isShowTxtAI = false
  self.nameColor = Color32.New(0.3176470588235294, 0.3176470588235294, 0.3176470588235294, 1)
  self.nameOutlineColor = Color.New(64, 23, 9, 255)
end

function ChatUserName:OnDestroy()
  self:ClearAllGovIcons()
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

function ChatUserName:OnAddListener()
  self:AddUIListener(EventId.ChatUserInfoUpdate, self.OnChatUserInfoUpdate)
  self:AddUIListener(EventId.UserSkinUpdate, self.OnUserSkinUpdate)
end

function ChatUserName:OnRemoveListener()
  self:RemoveUIListener(EventId.ChatUserInfoUpdate, self.OnChatUserInfoUpdate)
  self:RemoveUIListener(EventId.UserSkinUpdate, self.OnUserSkinUpdate)
end

function ChatUserName:UpdateLayout()
  if self.layout then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout.transform)
  end
end

function ChatUserName:OnChatUserInfoUpdate(uid)
  if self.uid and self.uid == uid and self.chatData then
    local userInfo = ChatInterface.getUserData(uid)
    if userInfo then
      self:UpdateName(userInfo, self.chatData)
    end
  end
end

function ChatUserName:OnUserSkinUpdate()
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

function ChatUserName:UpdateForAI(chatData, aiName)
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

function ChatUserName:UpdateName(userInfo, chatData)
  self:ClearAllGovIcons()
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
    local positionConfigs
    local positionIdList = userInfo.positionList
    if positionIdList and 0 < #positionIdList then
      positionConfigs = {}
      for _, positionId in ipairs(positionIdList) do
        if positionId then
          for _, v in ipairs(positionId) do
            local template = DataCenter.GovernmentTemplateManager:GetTemplate(v)
            if template then
              table.insert(positionConfigs, template)
            end
          end
        end
      end
    else
      local info = DataCenter.GovernmentManager:GetPositionInfoByUID(userInfo.uid)
      if info and info.template then
        positionConfigs = {
          info.template
        }
      end
    end
    if positionConfigs and 0 < #positionConfigs then
      self.nodeGover:SetActive(true)
      self.isShowGover = true
      for _, v in ipairs(positionConfigs) do
        local item = self.nodeGover:LoadComponentAsync(ChatGovIcon, Gov_Icon_Path)
        item:SetData(ChatInterface.GetChatUIPath("ChatItems/" .. tostring(v.iconName)))
        table.insert(self.govIcons, item)
      end
    else
      self.nodeGover:SetActive(false)
      self.isShowGover = false
    end
  end
  self:UpdatePlayerTitle(userInfo)
  self:UpdateVIP(userInfo)
  self:UpdateGender(userInfo)
  self:UpdateAlOfficialPos(userInfo, chatData)
  self:ComposeName(senderName, serverId, userInfo)
  self:UpdateLayout()
  TimerManager:GetInstance():GetTimer(1, function()
    self:UpdateLayout()
  end, self, true, true):Start()
end

function ChatUserName:ClearAllGovIcons()
  if self.nodeGover and self.govIcons then
    for _, v in pairs(self.govIcons) do
      self.nodeGover:RemoveAsyncComponent(v)
    end
  end
  self.govIcons = {}
end

function ChatUserName:ComposeName(senderName, serverId, userInfo)
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
    elseif serverId ~= myServerId and serverId ~= nil and 0 < serverId then
      senderName = "#" .. serverId .. senderName
      self.txtUserName:SetColor(ChatUIThemeConfig.NameColor[ChatInterface.GetChatTheme()])
    else
      self.txtUserName:SetColor(ChatUIThemeConfig.ChatNameColor[ChatInterface.GetChatTheme()])
    end
  end
  if not self.isShowGender and not self.isShowGover and not self.isShowTxtAI then
    senderName = " " .. senderName
  end
  self.txtUserName:SetText(senderName)
end

function ChatUserName:UpdatePlayerTitle(userInfo)
  if not userInfo then
    self.nodePlayerTitle:SetActive(false)
    return
  end
  local info = DataCenter.PlayerTitleTemplateManager:GetTitleInfo(userInfo.title)
  if info == nil then
    self.nodePlayerTitle:SetActive(false)
    return
  end
  self.nodePlayerTitle:SetActive(true)
  self.iconPlayerTitle:LoadSpriteAsyncEx(info.message_show_icon)
end

function ChatUserName:UpdateVIP(userInfo)
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

function ChatUserName:UpdateGender(userInfo)
  if not self.nodeGender then
    self.isShowGender = false
    return
  end
  if not (userInfo ~= nil and userInfo.gender) or userInfo.gender == 0 or userInfo.gender == 3 then
    self.nodeGender:SetActive(false)
    self.isShowGender = false
    return
  end
  self.nodeGender:SetActive(true)
  self.isShowGender = true
  local isMan = userInfo.gender == 1
  self.iconMale:SetActive(isMan)
  self.iconFemale:SetActive(not isMan)
end

function ChatUserName:UpdateAlOfficialPos(userInfo, chatData)
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
    local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if baseData and baseData.leaderUid and baseData.leaderUid == userInfo.uid then
      self.nodeAlOfficial:SetActive(true)
      self.txtAlOfficial:SetLocalText("393028")
    elseif DataCenter.AllianceMemberDataManager:IsOurR4MemberByUid(userInfo.uid) then
      self.nodeAlOfficial:SetActive(true)
      self.txtAlOfficial:SetText("R4")
    else
      self.nodeAlOfficial:SetActive(false)
    end
  end
end

function ChatUserName:OnPlayerTitleIconClick()
  if self.uid == nil then
    return
  end
  local userInfo = ChatInterface.getUserData(self.uid)
  if userInfo.title == 0 then
    return
  end
  DataCenter.PlayerInfoDataManager:ShowTitleDetail(userInfo.title, self.uid)
end

function ChatUserName:OnPlayerNameClick()
  self:OnPlayerTitleIconClick()
end

return ChatUserName
