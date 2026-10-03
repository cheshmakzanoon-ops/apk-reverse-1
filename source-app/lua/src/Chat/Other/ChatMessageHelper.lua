local ChatMessageHelper = {}
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local ShareEncode = require("Chat.Other.ShareEncode")
local ShareDecode = require("Chat.Other.ShareDecode")
local ShareExecute = require("Chat.Other.ShareExecute")

local function getColorString(self, vColorDefine, str, isFullMsg)
  if isFullMsg == false then
    return str
  end
  local colorStr = ""
  if vColorDefine == 1 then
    colorStr = "<text color=FFFFFF>"
  elseif vColorDefine == 2 then
    colorStr = "<text color=24FF00>"
  elseif vColorDefine == 3 then
    colorStr = "<text color=0084FF>"
  elseif vColorDefine == 4 then
    colorStr = "<text color=F600FF>"
  elseif vColorDefine == 5 then
    colorStr = "<text color=FF8A00>"
  elseif vColorDefine == 6 then
    colorStr = "<text color=FFFFFF>"
  elseif vColorDefine == 7 then
    colorStr = "<text color=FFFFFF>"
  elseif vColorDefine == 8 then
    colorStr = "<text color=FFFFFF>"
  elseif vColorDefine == 9 then
    colorStr = "<text color=FFFFFF>"
  elseif vColorDefine == 10 then
    colorStr = "<text color=FFFFFF>"
  elseif vColorDefine == 11 then
    colorStr = "<text color=FFFFFF>"
  else
    colorStr = "<text color=FFFFFF>"
  end
  return string.format("%s%s%s", colorStr, str, "</color>")
end

local function getAllianceGatherMessage(self)
  local name = ""
  if self.attachmentId then
    local paraArr = string.split(self.attachmentId, "|")
    if 6 <= #paraArr then
      local isBoss = paraArr[1]
      if isBoss == "1" then
        local monsterName = _lang(paraArr[5])
        local strLevel = string.format("LV%s", paraArr[6])
        name = string.format("%s\194\160%s", monsterName, strLevel)
      else
        name = paraArr[5]
        name = String.replace(name, " ", "\194\160")
      end
    end
  end
  return _lang("138199", name)
end

local function getAllianceMarkMessage(self)
  if self.attachmentId then
    local paraArr = string.split(self.attachmentId, "|")
    if 5 <= #paraArr then
      if paraArr[1] == "1" then
        return _lang("138440")
      elseif paraArr[1] == "2" then
        return _lang("138481")
      elseif paraArr[1] == "3" then
        return _lang("138482")
      end
    end
  end
  return ""
end

local function handleNewFightReportShare(self, extraData)
  if extraData.dialog and extraData.msgarr then
    local msgarr = extraData.msgarr
    if 0 < #msgarr then
      local nameString = ""
      for _, namesStr in ipairs(msgarr) do
        if nameString ~= "" then
          nameString = nameString .. "||" .. namesStr
        else
          nameString = namesStr
        end
      end
      local dialogString = extraData.dialog
      if dialogString ~= "" and nameString ~= "" then
        dialogString = dialogString .. "||" .. nameString
      end
      local attachmentID = extraData.reportUid and extraData.reportUid or ""
      if extraData.mailType then
        attachmentID = attachmentID .. "#" .. extraData.mailType
      end
      if attachmentID ~= "" then
        self.attachmentId = attachmentID .. "__" .. dialogString
      end
    end
  end
end

local function handleAllianceCommonShare(self, extraData)
  local dialogKey = extraData.dialog
  if dialogKey then
    local array = extraData.msgarr
    if array then
      local nameStr = ""
      if table.count(array) > 0 then
        for _, nameString in pairs(array) do
          if nameStr ~= "" then
            nameStr = nameStr .. "||"
          end
          nameStr = nameStr .. nameString
        end
        if dialogKey ~= "" then
          self.attachmentId = string.format("%s||%s", dialogKey, nameStr)
        end
      end
    end
  end
end

local function handleEquipShare(self, extraData)
  local equipIdString = extraData.equipId
  if equipIdString then
    local nameString = ""
    local colorString = "1"
    if extraData.dialog then
      local dialog = extraData.dialog
      if not string.IsNullOrEmpty(dialog) then
        dialog = dialog .. "||" .. colorString .. "||" .. nameString
      end
      if string.len(equipIdString) > 0 then
        self.attachmentId = equipIdString .. "__" .. dialog
      end
    end
  end
end

local function handleTurnTableShare(self, extraData)
  if extraData.lotteryInfo and extraData.dialog then
    local lotteryInfoString = extraData.lotteryInfo
    local dialog = extraDic.dialog
    local attachmentID = ""
    if not string.IsNullOrEmpty(lotteryInfoString) then
      attachmentID = lotteryInfoString
      if not string.IsNullOrEmpty(dialog) then
        attachmentID = attachmentID .. "__" .. dialog
      end
      self.attachmentId = attachmentID
    end
  end
end

function ChatMessageHelper:handleFightReport(extraData)
end

function ChatMessageHelper:handleRedPacket(extraData)
  if extraData.redPackets and extraData.server then
    local redPacketsId = extraData.redPackets
    local serverId = extraData.server
    local attachmentId = redPacketsId .. "_" .. serverId
    self.attachmentId = attachmentId .. "|1"
    if extraData.dialog and extraData.msgarr then
      if extraData.redPackectSysType then
        self.attachmentId = string.format("%s|%s", self.attachmentId, extraData.redPackectSysType)
      else
        self.attachmentId = string.format("%s|1", self.attachmentId)
      end
      local name = extraData.dialog
      local msgArr = extraData.msgarr
      if table.count(msgArr) == 2 then
        self.msg = ChatInterface.getString(name, msgArr[1], msgArr[2])
      else
        self.msg = ChatInterface.getString(name)
      end
    end
  end
end

local function getFightMessage(self, isFullMsg)
  local showString = ""
  local attachmentId = self.attachmentId
  local attachmentIDArray = string.split(attachmentId, "__")
  if 1 < #attachmentIDArray then
    local dialogString = attachmentIDArray[2]
    local dialogArray = string.split(dialogString, "||")
    local dialogKey = dialogArray[1]
    if #dialogArray == 2 then
      local name1 = dialogArray[2]
      if name1 == "200637" or name1 == "200639" or name1 == "200640" then
        name1 = ChatInterface.getString(name1)
      end
      showString = ChatInterface.getString(dialogKey, name1)
    elseif #dialogArray == 3 then
      local name1 = dialogArray[2]
      local name2 = dialogArray[3]
      local n = checknumber(name2)
      if not n then
        name1 = "(" .. name1 .. ")"
        local name2Arr = string.split(name2, " ")
        local keyStr = ""
        for i = 1, #name2Arr do
          keyStr = keyStr .. name2Arr[i]
        end
        name2 = ChatInterface.getString(keyStr)
        showString = ChatInterface.getString(dialogKey, name1 .. name2)
      else
        showString = ChatInterface.getString(dialogKey, name2)
      end
    else
      showString = self:getMaskMsg()
    end
  end
  return showString
end

local function getEquipMessage(self, isFullMsg)
  local showString = ""
  local attachmentId = self.attachmentId
  local attachmentIDArray = string.split(attachmentId, "__")
  if 1 < #attachmentIDArray then
    local dialogString = attachmentIDArray[2]
    local dialogArray = string.split(dialogString, "||")
    if #dialogArray == 3 then
      local equipKey = dialogArray[3]
      local changeTextString = ChatInterface.getString(equipKey)
      changeTextString = getColorString(checknumber(dialogArray[2]), changeTextString, isFullMsg)
      local dialogKey = dialogArray[1]
      if dialogKey ~= "" then
        showString = ChatInterface.getString(dialogKey, changeTextString)
      else
        showString = ChatInterface.getString("111660", changeTextString)
      end
    else
      local equipInfo = string.split(msg, "|")
      if 2 <= #equipInfo then
        local changeTextString = equipInfo[2]
        if changeTextString ~= "" then
          changeTextString = ChatInterface.getString(changeTextString)
        end
        changeTextString = getColorString(checknumber(equipInfo[1]), changeTextString, isFullMsg)
        showString = ChatInterface.getString("111660", changeTextString)
        if isFullMsg then
          showString = showString .. "<image scale=0.55>#UI_liaotian_equip_share.png</image>"
        else
        end
      else
        showString = ChatInterface.getString("111660")
      end
    end
  end
  return showString
end

local function getAllianceRallyMsg(self)
  local showString = ""
  local attachmentId = self.attachmentId
  local attachmentIDArray = string.split(attachmentId, "__")
  if 1 < #attachmentIDArray then
    local dialogString = attachmentIDArray[2]
    local dialogArray = string.split(dialogString, "||")
    if 2 <= #dialogArray then
      local userNameString = dialogArray[2]
      local dialogKey = dialogArray[1]
      if dialogKey ~= "" then
        showString = ChatInterface.getString(dialogKey, userNameString)
      else
        showString = ChatInterface.getString("132118", changeTextString)
      end
    end
  end
  return showString
end

local function getUseItemMsg(self)
  local showString = ""
  local attachmentId = self.attachmentId
  local attachmentIDArray = string.split(attachmentId, "||")
  if 3 < #attachmentIDArray then
    local dialogKey = attachmentIDArray[1]
    local name = attachmentIDArray[2]
    local itemName = ""
    local para = attachmentIDArray[3]
    local paramsArr = string.split(para, "X")
    if #paramsArr == 2 then
      local itemNameStr = LuaCommon:getNameById(paramsArr[1])
      itemName = string.format("%s X%s", itemNameStr, paramsArr[2])
    end
    local rewardStr = LuaCommon:getUseShareRewardStr(attachmentIDArray[4])
    showString = ChatInterface.getString(dialogKey, name, itemName, rewardStr)
  end
  return showString
end

local function getSevenDayMsg(self)
  local showString = ""
  local attachmentIDArray = string.split(self.attachmentId, "||")
  if #attachmentIDArray == 2 then
    local dialogKey = attachmentIDArray[1]
    local nameStr = ChatInterface.getString(attachmentIDArray[2])
    showString = ChatInterface.getString(dialogKey, nameStr)
  elseif #attachmentIDArray == 3 then
    local dialogKey = attachmentIDArray[1]
    local nameStr = ChatInterface.getString(attachmentIDArray[3])
    showString = ChatInterface.getString(dialogKey, attachmentIDArray[2], nameStr)
  else
    showString = msg
  end
  return showString
end

local function getAllianceMissileMsg(self)
  local showString = ""
  local attachmentId = self.attachmentId
  local attachmentIDArray = string.split(attachmentId, "||")
  if #attachmentIDArray == 4 then
    local dialogKey = attachmentIDArray[1]
    local posStrArr = string.split(attachmentIDArray[4], ":")
    local posStr = ""
    for i = 1, #posStrArr do
      posStr = posStr .. posStrArr[i]
    end
    showString = ChatInterface.getString(dialogKey, attachmentIDArray[2], attachmentIDArray[3], posStr)
  else
    showString = msg
  end
  return showString
end

local function getDommsdayMissileMsg(self)
  local showString = ""
  local attachmentIDArray = string.split(self.attachmentId, "|")
  local dialogKey = attachmentIDArray[1]
  local normalStr = ""
  local count = #attachmentIDArray
  if count <= 4 then
    showString = msg
  else
    if attachmentIDArray[2] ~= "" then
      normalStr = string.format("(#%s %s:%s)", attachmentIDArray[2], attachmentIDArray[3], attachmentIDArray[4])
    else
      normalStr = string.format("(%s:%s)", attachmentIDArray[3], attachmentIDArray[4])
    end
    local nameStr = attachmentIDArray[5]
    showString = ChatInterface.getString(dialogKey, nameStr, normalStr)
  end
  return showString
end

local function getSendFlowerMsg(self)
  local showString = ""
  local attachmentIDArray = string.split(self.attachmentId, "|")
  if #attachmentIDArray == 3 then
    local dialogKey = attachmentIDArray[1]
    local p1 = attachmentIDArray[2]
    local p2 = attachmentIDArray[3]
    showString = ChatInterface.getString(dialogKey, p1, p2)
  elseif #attachmentIDArray == 2 then
    local dialogKey = attachmentIDArray[1]
    local p1 = attachmentIDArray[2]
    showString = ChatInterface.getString(dialogKey, p1)
  else
    showString = ChatInterface.getString("90823263")
  end
  return showString
end

local function GetHeroQuality(quality)
  if quality then
    local qualityStrs = {
      "150534",
      "150535",
      "150536",
      "150537",
      "150538",
      "150539",
      "150540",
      "150541",
      "150542"
    }
    quality = tonumber(quality)
    local qStr = qualityStrs[quality - 1]
    if qStr then
      return _lang(qStr)
    end
  end
  return ""
end

local function getAllianceRedPackMessage(chatMessage)
  if chatMessage.params_al == nil then
    return ""
  end
  local ret = ""
  local userName = chatMessage.userName
  userName = String.replace(userName, " ", "\194\160")
  if chatMessage.typ == RedPackageType.LevelUp then
    if #chatMessage.params_al >= 1 then
      local level = chatMessage.params_al[1]
      ret = _lang("138205", userName, level)
    end
  elseif chatMessage.typ == RedPackageType.Hero_Quality_4 then
    if #chatMessage.params_al >= 1 then
      local heroId = chatMessage.params_al[1]
      local config = CS.LF.LuaHelper.Table:GetDataRow(TableName.Heroes, heroId)
      if config then
        local nameKey = config:GetString("name")
        local nameStr = _lang(nameKey)
        local colorStr = CS.LF.LuaHelper.Table:GetString(CS.LFDefines.TableName.HeroQuality, 4, "color")
        nameStr = CS.HeroListUtil.AddColor(nameStr, colorStr)
        ret = _lang("138206", userName, nameStr)
      end
    end
  elseif chatMessage.typ == RedPackageType.Hero_Quality_7 and #chatMessage.params_al >= 1 then
    local heroId = chatMessage.params_al[1]
    local config = CS.LF.LuaHelper.Table:GetDataRow(TableName.Heroes, heroId)
    if config then
      local nameKey = config:GetString("name")
      local nameStr = _lang(nameKey)
      local colorStr = CS.LF.LuaHelper.Table:GetString(CS.LFDefines.TableName.HeroQuality, 7, "color")
      nameStr = CS.HeroListUtil.AddColor(nameStr, colorStr)
      ret = _lang("138207", userName, nameStr, chatMessage:GetHeroQuality(7))
    end
  end
  return ret
end

local function getShareHeroTenGetMessage(chatMessage)
  local ret = ""
  if chatMessage.attachmentId then
    local paraArr = string.split(chatMessage.attachmentId, "|")
    if 1 <= #paraArr then
      local recruitName = paraArr[1]
      local names = ""
      for i = 2, #paraArr do
        local config = CS.LF.LuaHelper.Table:GetDataRow(TableName.Heroes, paraArr[i])
        if config ~= nil and config:GetInt("quality_min") >= 4 then
          local nameKey = config:GetString("name")
          local nameStr = _lang(nameKey)
          local colorStr = CS.LF.LuaHelper.Table:GetString(CS.LFDefines.TableName.HeroQuality, 4, "color")
          nameStr = CS.HeroListUtil.AddColor(nameStr, colorStr)
          if names ~= "" then
            names = names .. ", "
          end
          names = names .. nameStr
        end
      end
      if chatMessage.msg == "0" then
        ret = _lang("162164", recruitName) .. names
      else
        ret = _lang("162164", _lang(chatMessage.msg)) .. names
      end
    end
  end
  return ret
end

function ChatMessageHelper:handleAllianceRedPacket(chatMessage, extraData)
  local redPackInfo = extraData.redPackAllianceInfo
  if redPackInfo then
    chatMessage.coinType = redPackInfo.coinType
    chatMessage.coinNum = redPackInfo.coinNum
    chatMessage.remain = redPackInfo.remain
    chatMessage.params_al = redPackInfo.params
    chatMessage.typ = redPackInfo.type
    chatMessage.userName = redPackInfo.userName
    chatMessage.uuid = redPackInfo.uuid
    chatMessage.allianceId = redPackInfo.allianceId
    chatMessage.total = redPackInfo.total
    chatMessage.name = redPackInfo.name
    chatMessage.startTime = redPackInfo.startTime
    chatMessage.endTime = redPackInfo.endTime
    chatMessage.desc = redPackInfo.desc
    chatMessage.senderServerId = redPackInfo.serverId
  end
  chatMessage.userLang = extraData.userLang
end

function ChatMessageHelper:onParseExtraData(chatMessage, extraData)
  if not extraData then
    return
  end
  chatMessage.extra = extraData
  chatMessage.seqId = extraData.seqId
  if extraData.post then
    chatMessage.post = checknumber(extraData.post)
  end
  if extraData.senderLevel ~= nil then
    chatMessage.senderLevel = extraData.senderLevel
  end
  if extraData.allianceId then
    chatMessage.attachmentId = extraData.allianceId
  elseif extraData.reportUid then
    chatMessage.attachmentId = extraData.reportUid
  elseif extraData.detectReportUid then
    chatMessage.attachmentId = extraData.detectReportUid
  elseif extraData.equipId then
    chatMessage.attachmentId = extraData.equipId
  elseif extraData.teamUuid then
    chatMessage.attachmentId = extraData.teamUuid
  elseif extraData.lotteryInfo then
    chatMessage.attachmentId = extraData.lotteryInfo
  elseif extraData.attachmentId then
    chatMessage.attachmentId = extraData.attachmentId
  elseif extraData.shamoInfo then
    chatMessage.attachmentId = extraData.shamoInfo
  elseif extraData.media then
    chatMessage.media = extraData.media
  end
  if chatMessage.post == PostType.RedPackge then
    self:handleRedPacket(extraData)
  elseif chatMessage.post == PostType.Text_FightReport then
    self:handleFightReport(extraData)
  elseif chatMessage.post == PostType.Text_Formation_Fight_Share then
  elseif chatMessage.post == PostType.Text_Formation_Share then
  elseif chatMessage.post == PostType.Text_MsgShare then
  elseif chatMessage.post == PostType.Text_ChampionBattleReportShare then
  elseif chatMessage.post == PostType.Text_TurntableShare then
    chatMessage:handleTurnTableShare(extraData)
  elseif chatMessage.post == PostType.Text_EquipShare then
    chatMessage:handleEquipShare(extraData)
  elseif chatMessage.post == PostType.Text_PointShare or chatMessage.post == PostType.Text_PointShare_Alliance or chatMessage.post == PostType.Text_Favour_Point_Share or chatMessage.post == PostType.March or chatMessage.post == PostType.SuppliesPositionShare then
    if extraData.attachmentId then
      chatMessage.attachmentId = extraData.attachmentId
    end
  elseif chatMessage.post == PostType.Text_AllianceTaskHelper then
    if extraData.attachmentId then
      chatMessage.attachmentId = extraData.attachmentId
    end
  elseif chatMessage.post == PostType.Text_AllianceCreated or chatMessage.post == PostType.Text_AllianceAdded or chatMessage.post == PostType.Text_AllianceInvite or chatMessage.post == PostType.MIGRATE_INVITE then
    chatMessage.attachmentId = extraData.attachmentId
  elseif chatMessage.post == PostType.Text_Media then
    if extraData.media then
      chatMessage.media = extraData.media
    end
  elseif chatMessage.post == PostType.Text_ScienceMaxShare then
    if extraData.scienceType then
      local dialogKey = extraData.dialog and extraData.dialog or "79010354"
      chatMessage.attachmentId = string.format("%s__%s", extraData.scienceType, dialogKey)
    end
  elseif chatMessage.post == PostType.Text_AllianceCommonShare or chatMessage.post == PostType.Text_SevenDayNewShare or chatMessage.post == PostType.Text_AllianceAttackMonsterShare then
    chatMessage:handleAllianceCommonShare(extraData)
  elseif chatMessage.post == PostType.Text_StartWar or chatMessage.post == PostType.Text_EndWar then
    chatMessage.cityId = extraData.cityId
    chatMessage.alAbbr = extraData.alAbbr
  elseif chatMessage.post == PostType.Text_AllianceRedPack then
    self:handleAllianceRedPacket(chatMessage, extraData)
  elseif chatMessage.post == PostType.Text_AllianceWelcome then
    chatMessage.extraContent = extraData.msgarr
  elseif chatMessage.post == PostType.Text_AllianceTransfer then
    chatMessage.extraContent = extraData.msgarr
  elseif chatMessage.post == PostType.Text_AllianceMemberInOut then
    local tmp = {}
    tmp.typ = tostring(extraData.smallType)
    tmp.msgarr = extraData.msgarr
    chatMessage.extraContent = tmp
  elseif chatMessage.post == PostType.Text_Normal or ChatInterface.getMoment():GetIsMomentData(chatMessage.post) then
    chatMessage.isNormalMsg = extraData.isNormalMsg
  elseif chatMessage.post == PostType.SummonWeather then
    chatMessage.attachmentId = extraData.summonWeatherInfo
    chatMessage.extra.customJsonParam = chatMessage.attachmentId
  else
    local attachMentID = ""
    local dialogKey = extraData.dialog
    if dialogKey then
      local array = extraData.msgarr
      local nameStr = ""
      if array then
        for _, nameString in pairs(array) do
          if nameStr ~= "" then
            nameStr = nameStr .. "||"
          end
          nameStr = nameStr .. nameString
        end
      end
      if dialogKey ~= "" and nameStr ~= "" then
        attachMentID = string.format("%s||%s", dialogKey, nameStr)
      else
        attachMentID = dialogKey
      end
    end
    if string.len(chatMessage.attachmentId) > 0 then
      if attachMentID ~= "" then
        chatMessage.attachmentId = string.format("%s__%s", chatMessage.attachmentId, attachMentID)
      end
    else
      chatMessage.attachmentId = attachMentID
    end
  end
end

function ChatMessageHelper:getMessageWithExtra(chatMessage, isFullMsg)
  local post = chatMessage.post or 0
  local showMessage = ""
  local isAwait
  if 0 < post and not ChatInterface.getMoment():GetIsMomentData(post) then
    if isFullMsg then
      if not string.IsNullOrEmpty(chatMessage.fulltext) then
        showMessage = chatMessage.fulltext
      end
    elseif not string.IsNullOrEmpty(chatMessage.attachmentMsg) then
      showMessage = chatMessage.attachmentMsg
    end
    if string.IsNullOrEmpty(showMessage) then
      local param = {}
      if not string.IsNullOrEmpty(chatMessage.attachmentId) then
        param = rapidjson.decode(chatMessage.attachmentId)
      end
      showMessage, isAwait = ShareDecode.Decode(chatMessage, param or {}, isFullMsg)
      if not isAwait then
        if isFullMsg then
          chatMessage.fulltext = showMessage
        else
          chatMessage.attachmentMsg = showMessage
        end
      end
      if param and param.dispatch == 1 then
        local task_star = GetTableData(TableName.LwDispatchTask, param.cfgId, "task_star")
        local task_color = GetTableData(TableName.LwDispatchTask, param.cfgId, "color")
        local is_special = GetTableData(TableName.LwDispatchTask, param.cfgId, "is_special")
        chatMessage.dispatchTaskStar = toInt(task_star)
        chatMessage.dispatchTaskColor = toInt(task_color)
        if not string.IsNullOrEmpty(is_special) then
          chatMessage.dispatchTaskIsSpecial = toInt(is_special) == 1
        end
      elseif param and param.ghostrecon == 1 then
        chatMessage.cfgId = param.cfgId
      end
    end
  else
    showMessage = chatMessage:getMaskMsg()
  end
  return showMessage
end

function ChatMessageHelper.getChannelFromRoomId(roomId, post, group)
  if not roomId then
    return
  end
  if post == PostType.MIGRATE_INVITE then
    return ChatShareChannel.TO_PERSON
  end
  if group and group == ChatGroupType.GROUP_TMPRoom then
    return ChatShareChannel.TO_PERSON
  end
  local chatData = ChatManager2:GetInstance().Room:GetRoomData(roomId)
  if chatData then
    if chatData:isWorldRoom() then
      return ChatShareChannel.TO_COUNTRY
    elseif chatData:isAllianceRoom() then
      return ChatShareChannel.TO_ALLIANCE
    elseif chatData:isLanguageRoom() then
      return ChatShareChannel.TO_LANGUAGE
    else
      return ChatShareChannel.TO_PERSON
    end
  end
end

function ChatMessageHelper.getAttachmentId(param)
  return ShareEncode.Encode(param)
end

function ChatMessageHelper.getShowParam(chatData)
  local param = rapidjson.decode(chatData.attachmentId)
  return param
end

function ChatMessageHelper.executeChatData(chatData)
  local param = rapidjson.decode(chatData.attachmentId)
  ShareExecute.Execute(chatData, param)
end

return ChatMessageHelper
