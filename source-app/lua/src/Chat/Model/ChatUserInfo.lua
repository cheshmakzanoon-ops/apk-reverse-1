local ChatUserInfo = BaseClass("ChatUserInfo")
local rapidjson = require("rapidjson")
local sendDelay = 2

function ChatUserInfo:__init()
  self._id = 0
  self.userName = ""
  self.allianceSimpleName = ""
  self.allianceRank = 0
  self.headPic = ""
  self.headPicVer = 0
  self.monthCard = 0
  self.chooseState = 0
  self.uid = ""
  self.lang = ""
  self.serverId = 0
  self.srcServer = 0
  self.crossFightSrcServerId = 0
  self.allianceId = ""
  self.allianceName = ""
  self.vipLevel = 0
  self.vipframe = 0
  self.svipLevel = 0
  self.svipEndTime = 0
  self.showVipLevel = 1
  self.chatFrameId = ""
  self.vipEndTime = 0
  self.chatSkinId = 0
  self.careerId = ""
  self.monthCardEndTime = -1
  self.mainBuildingLevel = 0
  self.nation = "UN"
  self.gender = 0
  self.power = 0
  self.positionList = nil
  self.gmFlag = 0
  self.chatBantime = 0
  self.lastUpdateTime = 0
  self.customHeadImageName = ""
  self.headimageurl = ""
  self.customHeadImageFullPath = ""
  self.careerType = CareerType.None
  self.careerLv = 0
  self.title = 0
  self.info_ok = false
  self.headSkinId = nil
  self.headSkinET = nil
  self.titleSkinId = 0
  self.titleSkinET = 0
  self.chatBubbleId = nil
  self.chatBubbleET = nil
  self.goldNameSkinId = nil
  self.goldNameSkinET = nil
  self.count = 0
  self.birthday = nil
  self.birthdayDisplay = nil
  self.zodDisplay = nil
  self:UpdateSendTime()
  self:UpdateSendDelay()
end

function ChatUserInfo:__delete()
  self.positionList = nil
  self.detectorDelay = nil
  self.count = nil
end

local function maskMsg(text, set, repl)
  if #text <= 0 then
    return text
  end
  
  local function maskor(str)
    return repl or string.rep("*", #str)
  end
  
  for k, str in pairs(set) do
    text = string.gsub(text, str, maskor(str))
  end
  return text
end

function ChatUserInfo:setUid(uid)
  self.uid = uid
end

function ChatUserInfo:getUid()
  return self.uid
end

function ChatUserInfo:getServerId()
  return self.crossFightSrcServerId < 0 and self.serverId or self.crossFightSrcServerId
end

function ChatUserInfo:IsGmUser()
  local userId = tonumber(self.uid)
  for i = 0, ChatGMUserCnt do
    local tmpUserId = tonumber(ChatGMUserId) + i
    if userId == tmpUserId then
      return true
    end
  end
  return false
end

function ChatUserInfo:GetGMIcon()
  return ChatGMUserIcon
end

function ChatUserInfo:UpdateSendTime()
  self.sendTime = UITimeManager:GetInstance():GetServerTime()
end

function ChatUserInfo:UpdateSendDelay()
  if not self.detectorDelay and self.uid ~= "system" and self.count < 3 then
    self.count = self.count + 1
    self.detectorDelay = TimerManager:GetInstance():DelayInvoke(function()
      self.detectorDelay = nil
      if not self:GetIsBack() then
        ChatManager2:GetInstance().User:getChatUserInfo(self.uid, true)
      end
    end, sendDelay + 0.5)
  end
end

function ChatUserInfo:GetIsBack()
  if self.uid == "system" then
    return true
  end
  if self.info_ok then
    return true
  else
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local time = (curTime - self.sendTime) / 1000
    if time >= sendDelay then
      return false
    end
    return true
  end
end

function ChatUserInfo:onParseServerData(tabData)
  if type(tabData) ~= "table" then
    return
  end
  if tabData.uid then
    self.uid = tabData.uid
  end
  if tabData.name then
    self.userName = tabData.name
  end
  if tabData.careerId then
    self.careerId = tabData.careerId
  end
  if tabData.monthCardEndTime then
    self.monthCardEndTime = checknumber(tabData.monthCardEndTime)
  end
  if tabData.baseLevel then
    self.mainBuildingLevel = checknumber(tabData.baseLevel)
  end
  if tabData.mainBuildingLevel then
    self.mainBuildingLevel = checknumber(tabData.mainBuildingLevel)
  end
  if tabData.countryflag then
    self.nation = tabData.countryflag
  end
  if tabData.serverId then
    self.serverId = checknumber(tabData.serverId)
  end
  if tabData.srcServer then
    self.srcServer = checknumber(tabData.srcServer)
  end
  if tabData.crossFightSrcServerId then
    self.crossFightSrcServerId = checknumber(tabData.crossFightSrcServerId)
  end
  if tabData.server then
    self.crossFightSrcServerId = checknumber(tabData.server)
  end
  if tabData.gmFlag then
    self.gmFlag = checknumber(tabData.gmFlag)
  end
  if tabData.pic then
    self.headPic = tabData.pic
  end
  if tabData.picVer then
    self.headPicVer = checknumber(tabData.picVer)
  end
  if tabData.lastUpdateTime then
    self.lastUpdateTime = checknumber(tabData.lastUpdateTime)
  end
  if tabData.power then
    self.power = checknumber(tabData.power)
  end
  if tabData.lang then
    self.lang = tabData.lang
  end
  if tabData.gender then
    self.gender = tabData.gender
  end
  if tabData.allianceId then
    self.allianceId = tabData.allianceId
  else
    self.allianceId = ""
    self.allianceSimpleName = ""
    self.allianceName = ""
  end
  if tabData.abbr then
    self.allianceSimpleName = tabData.abbr
  end
  if tabData.allianceAbbrName then
    self.allianceSimpleName = tabData.allianceAbbrName
  end
  if tabData.allianceName then
    self.allianceName = tabData.allianceName
  end
  if tabData.rank then
    self.allianceRank = checknumber(tabData.rank)
  end
  local chatBantime = checknumber(tabData.chatBantm)
  if chatBantime then
    if chatBantime == 9223372036854775807 or chatBantime == -1 then
      chatBantime = -1
    else
      chatBantime = math.floor(chatBantime / 1000)
    end
    self.chatBantime = chatBantime
    ChatManager2:GetInstance().Restrict:chatBanOrUnBan(tabData.uid, tabData.banGMName, self.chatBantime, 1)
    ChatManager2:GetInstance().User:updateBanTime(tabData.uid, self.chatBantime)
  end
  if tabData.chatSkinId then
    self.chatSkinId = checknumber(tabData.chatSkinId)
  end
  if tabData.chatFrameId then
    self.chatFrameId = tabData.chatFrameId
  end
  if tabData.bubble then
    self.monthCard = checknumber(tabData.bubble)
  end
  if tabData.vipLevel then
    self.vipLevel = checknumber(tabData.vipLevel)
  end
  if tabData.vipframe then
    self.vipframe = checknumber(tabData.vipframe)
  end
  if tabData.vipEndTime then
    self.vipEndTime = checknumber(tabData.vipEndTime)
  end
  if tabData.svipLevel then
    self.svipLevel = checknumber(tabData.svipLevel)
  end
  if tabData.svipEndTime then
    self.svipEndTime = checknumber(tabData.svipEndTime)
  end
  if tabData.isVipShow then
    self.showVipLevel = checknumber(tabData.isVipShow)
    if ChatInterface.GetisTestUid(tabData.uid) then
      Logger.LogError("vipShow Change  ---->  isVipShow:  " .. checknumber(tabData.isVipShow))
    end
  end
  self.positionList = tabData.positionList
  if tabData.careerType then
    self.careerType = checknumber(tabData.careerType)
  end
  if tabData.careerLv then
    self.careerLv = checknumber(tabData.careerLv)
  end
  if tabData.headSkinId then
    self.headSkinId = checknumber(tabData.headSkinId)
  end
  if tabData.headSkinET then
    self.headSkinET = checknumber(tabData.headSkinET)
  end
  if tabData.titleSkinId then
    self.titleSkinId = checknumber(tabData.titleSkinId)
  end
  if tabData.titleSkinET then
    self.titleSkinET = checknumber(tabData.titleSkinET)
  end
  if tabData.chatBubbleId then
    self.chatBubbleId = checknumber(tabData.chatBubbleId)
  end
  if tabData.chatBubbleET then
    self.chatBubbleET = checknumber(tabData.chatBubbleET)
  end
  if tabData.goldNameSkinId then
    self.goldNameSkinId = checknumber(tabData.goldNameSkinId)
  end
  if tabData.goldNameSkinET then
    self.goldNameSkinET = checknumber(tabData.goldNameSkinET)
  end
  if tabData.title then
    self.title = checknumber(tabData.title)
  end
  if tabData.curAnonymousHead then
    self.curAnonymousHead = tabData.curAnonymousHead
  end
  if tabData.birthday then
    self.birthday = tabData.birthday
  end
  if tabData.birthdayDisplay then
    self.birthdayDisplay = tabData.birthdayDisplay
  end
  if tabData.zodDisplay then
    self.zodDisplay = tabData.zodDisplay
  end
  if tabData.uid == LuaEntry.Player.uid then
    EventManager:GetInstance():Broadcast(EventId.ChatUserInfoUpdate, self.uid)
  end
  self.info_ok = true
  if self.detectorDelay then
    self.detectorDelay:Stop()
    self.detectorDelay = nil
  end
end

function ChatUserInfo:GetHeadBgImg()
  local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(self.headSkinId, self.headSkinET, false)
  return headBgImg
end

function ChatUserInfo:CheckIfShowStorageBtn()
  if self.uid == LuaEntry.Player.uid then
    return false
  end
  local minLv = LuaEntry.DataConfig:TryGetNum("tradingbank_para", "k17")
  return minLv <= self.mainBuildingLevel
end

function ChatUserInfo:setChatBantime(banTime)
  self.chatBantime = banTime
end

function ChatUserInfo:SetInfoOK()
  self.info_ok = true
end

function ChatUserInfo:GetUserName()
  if self.info_ok then
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.uid, self.userName)
    return showName
  end
  if self.userName ~= "" then
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.uid, self.userName)
    return showName
  end
  local msgOwner = ""
  if self.uid == "system" then
    msgOwner = CS.GameEntry.Localization:GetString("310002")
  end
  return msgOwner
end

function ChatUserInfo:GetGoldNameSkinId()
  return self.goldNameSkinId
end

function ChatUserInfo:SetGoldNameSkinId(goldNameSkinId)
  self.goldNameSkinId = goldNameSkinId
end

local formatName = "[%s]%s"

function ChatUserInfo:GetFomatName(useRemark)
  if useRemark == nil then
    useRemark = true
  end
  local showName = self.userName
  if useRemark then
    showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.uid, self.userName)
  end
  if not string.IsNullOrEmpty(self.allianceSimpleName) then
    return string.format(formatName, self.allianceSimpleName, showName)
  else
    return showName
  end
end

function ChatUserInfo:SetLastUpdateTime(time, name)
  if tonumber(time) > tonumber(self.lastUpdateTime) then
    ChatPrint("time update!!")
    self.info_ok = false
  end
  if type(name) == "string" and name ~= "" then
    self.userName = name
  end
end

return ChatUserInfo
