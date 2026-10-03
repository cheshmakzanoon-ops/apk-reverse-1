local MailParseHelper = require("DataCenter.MailData.MailParseHelper")
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")
local Localization = CS.GameEntry.Localization
local ShareDecode = {}

local function Decode_PointShare(chatData, t, isFullMsg)
  local isAwait
  if t.x == nil or t.y == nil then
    return nil
  end
  local showMessage = ""
  if not string.IsNullOrEmpty(t.msg) then
    showMessage = t.msg
  else
    local uname
    if not string.IsNullOrEmpty(t.uname) then
      if string.IsNullOrEmpty(t.abbr) then
        local nameArr = string.split(t.uname, ";")
        if 1 < #nameArr then
          uname = Localization:GetString(nameArr[2])
        else
          uname = t.uname
        end
      else
        uname = "[" .. t.abbr .. "] " .. t.uname
      end
    end
    local onameParam1, onameParam2
    if t.onameParam1 then
      onameParam1 = t.onameParam1
    elseif t.onameParamKey1 then
      onameParam1 = Localization:GetString(t.onameParamKey1)
    end
    if t.onameParam2 then
      onameParam2 = t.onameParam2
    elseif t.onameParamKey2 then
      onameParam2 = Localization:GetString(t.onameParamKey2)
    end
    local oname
    if t.dispatch == 1 then
      oname = Localization:GetString("456288")
    elseif tonumber(t.oname) then
      oname = Localization:GetString(t.oname, onameParam1, onameParam2)
    elseif Localization:HasKey(t.oname) then
      oname = Localization:GetString(t.oname, onameParam1, onameParam2)
    elseif t.posType == WorldPointUIType.City and t.uid then
      local chatUserInfo = ChatManager2:GetInstance().User:getChatUserInfo(t.uid)
      if chatUserInfo and not string.IsNullOrEmpty(chatUserInfo.userName) and chatUserInfo.info_ok then
        oname = chatUserInfo:GetFomatName(false)
      else
        isAwait = true
        oname = t.oname
      end
    else
      oname = t.oname
    end
    if not string.IsNullOrEmpty(t.oname) and t.olv and t.olv ~= 0 and t.olv ~= "0" and t.oname ~= 104290 and t.oname ~= "104290" then
      oname = Localization:GetString("science_condition", t.olv, oname)
    end
    if uname ~= nil and oname ~= nil then
      showMessage = Localization:GetString(GameDialogDefine.POSITION_DESC, uname, oname)
    else
      if uname ~= nil then
        showMessage = uname
      end
      if oname ~= nil then
        showMessage = oname
      end
    end
  end
  if t.sid then
    showMessage = showMessage .. " (" .. Localization:GetString(GameDialogDefine.POSITION_COORDINATE_CROSS, t.sid, t.x, t.y) .. ")"
  else
    showMessage = showMessage .. " (" .. Localization:GetString(GameDialogDefine.SHOW_POS, t.x, t.y) .. ")"
  end
  return showMessage, isAwait
end

local function Decode_StorageShopShare(chatData, t, isFullMsg)
  local strItems = ""
  local separateSymbol = Localization:GetString("104197")
  for i, v in ipairs(t.itemIds) do
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(v)
    if template then
      local tempName = Localization:GetString(template.name)
      if i == 1 then
        strItems = tempName
      else
        strItems = strItems .. separateSymbol .. tempName
      end
    end
  end
  return Localization:GetString("141043", strItems)
end

local function Decode_AllianceTaskShare(chatData, t, isFullMsg)
  local ret = {}
  ret.taskName = Localization:GetString(t.taskName)
  ret.curProg = t.curProg
  ret.maxProg = t.maxProg
  ret.tempTime = t.tempTime or 0
  return ret.taskName
end

local function Decode_AllianceRecruitShare(chatData, t, isFullMsg)
  local strTip = t.recruitTip
  return strTip
end

local function Decode_MailScoutResultShare(chatData, t, isFullMsg)
  return Localization:GetString(310101)
end

local function Decode_LandmineShare(chatData, t, isFullMsg)
  return Localization:GetString("season_mastery_s2_UI_2")
end

local function Decode_GoldRelicShare(chatData, t, isFullMsg)
  return Localization:GetString("season_s3_coinlevel_share_text_1", t.goldCount)
end

local function Decode_DisguiseShare(chatData, t, isFullMsg)
  return Localization:GetString("season_mastery_s3_mail_1")
end

local function Decode_DefaultMarchShare(chatData, t, isFullMsg)
  if string.IsNullOrEmpty(t.key) or string.IsNullOrEmpty(t.level) or string.IsNullOrEmpty(t.name) then
    return Localization:GetString("season_wander_monster_share")
  end
  local name = string.IsNullOrEmpty(t.name) and "" or Localization:GetString(t.name, t.ownerName)
  local desc = Localization:GetString(t.key, t.level, name)
  if Localization:GetLanguage() == Language.French then
    desc = desc .. " "
  end
  if isFullMsg then
    return desc .. "<u>" .. Localization:GetString("season_wander_monster_share") .. "</u>"
  else
    return desc .. Localization:GetString("season_wander_monster_share")
  end
end

local function Decode_AllianceInvite(chatData, t, isFullMsg)
  if t.abbr and t.name then
    return "[" .. t.abbr .. "] " .. t.name .. "  " .. Localization:GetString("390157")
  end
  return Localization:GetString("390157")
end

local function Decode_GiftGiving(chatData, t, isFullMsg)
  if t.abbr and t.name then
    return "[" .. t.abbr .. "] " .. t.name .. "  " .. Localization:GetString("390157")
  end
  local str = ""
  local customJsonParam = chatData.extra and chatData.extra.customJsonParam
  if customJsonParam then
    local giftName = "???"
    local extraJson = rapidjson.decode(customJsonParam)
    local sendNum = extraJson.num
    local template = DataCenter.ItemTemplateManager:GetItemTemplate(extraJson.itemId)
    if template then
      giftName = Localization:GetString(template.name)
    end
    local sendPlayerName = extraJson.sendName
    if extraJson.isAnonymous == 1 then
      str = Localization:GetString("gift_sent_msg_des2", sendNum, giftName)
    else
      str = Localization:GetString("gift_sent_msg_des1", sendNum, sendPlayerName, giftName)
    end
    str = tostring(extraJson.targetInfo and extraJson.targetInfo.name) .. str
  end
  return str
end

local function Decode_TrainVipInvite(chatData, t, isFullMsg)
  local str = ""
  local customJsonParam = chatData.extra and chatData.extra.customJsonParam
  if customJsonParam then
    local extraJson = rapidjson.decode(customJsonParam)
    local endTime = extraJson.endTime
    local sendPlayerName = extraJson.sendName
    str = str .. ";" .. endTime
  end
  return str
end

local function Decode_ValentineRankCard(chatData, t, isFullMsg)
  local str = ""
  if t.small_msg then
    str = t.small_msg
  end
  return Localization:GetString(str)
end

local function Decode_AllianceRankChange(chatData, t, isFullMsg)
  if t.uname == nil or t.new == nil or t.old == nil or t.selfRank == nil or t.selfName == nil then
    return nil
  end
  local dlgId = "390159"
  if t.new < t.old then
    dlgId = "390160"
  end
  return Localization:GetString(dlgId, t.selfName, t.selfRank, t.uname, t.old, t.new)
end

local function Decode_AllianceMemberJoin(chatData, t, isFullMsg)
  if not t.name then
    return nil
  end
  return Localization:GetString("128132", t.name)
end

local function Decode_Abandon_AllianceCity(chatData, t, isFullMsg)
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj and jsonObj.name then
      local loginServerId = LuaEntry.Player:GetSelfServerId()
      local serverId = jsonObj.serverId or loginServerId
      local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(jsonObj.cityId, serverId)
      local user = jsonObj.name
      local tilePos = cityTemplate.pos
      local strPos = "(X:" .. tilePos.x .. ",Y:" .. tilePos.y .. ") "
      if jsonObj.serverId ~= nil then
        strPos = " #" .. jsonObj.serverId .. strPos
      elseif serverId ~= 0 and SeasonUtil.InSeasonBigMapMode() then
        local seasonInfo = SeasonUtil.GetSeasonInfo(serverId)
        local bigMapIndex = cityTemplate.bigMapIndex
        if bigMapIndex ~= 0 then
          serverId = seasonInfo:GetNinePalacesServer(bigMapIndex)
          if serverId ~= 0 then
            strPos = " #" .. serverId .. strPos
          end
        end
      end
      local l1 = jsonObj.rank
      local l2 = jsonObj.official
      local offName = ""
      if l1 ~= nil and l1 ~= nil then
        if l1 == 5 then
          offName = Localization:GetString(302336)
        elseif l1 == 4 and LWAlMemberOffcialParam[l2] then
          offName = Localization:GetString(LWAlMemberOffcialParam[l2].Text)
        end
      end
      local lv = Localization:GetString("320439", cityTemplate.level)
      local cityName = Localization:GetString(cityTemplate.name)
      return Localization:GetString("393094", offName, user, strPos, lv, cityName)
    end
  end
  return ""
end

local function Decode_AllianceMemberQuit(chatData, t, isFullMsg)
  if t.name == nil then
    return nil
  end
  return Localization:GetString("390180", t.name)
end

local function Decode_AllianceOfficialChange(chatData, t, isFullMsg)
  if t.uname == nil then
    return nil
  end
  local m = t.uname .. " " .. Localization:GetString("390068")
  return m
end

local function IsGmMode(roomId)
  local roomMgr = ChatManager2:GetInstance().Room
  local roomData = roomMgr:GetRoomData(roomId)
  if roomData ~= nil and roomData:IsGmRoom() then
    return true
  end
  return false
end

local function Decode_ChatRoomSystem(chatData, t, isFullMsg)
  local senderUid = chatData.senderUid
  local playerUid = ChatInterface.getPlayerUid()
  local isOperator = senderUid == playerUid
  local operatorName = ""
  if isOperator == true then
    operatorName = ChatInterface.getString("290018")
  else
    if string.IsNullOrEmpty(chatData.senderName) then
      local uinfo = ChatManager2:GetInstance().User:getChatUserInfo(senderUid, false)
      if uinfo then
        operatorName = uinfo.userName
      end
    else
      operatorName = chatData.senderName
    end
    if operatorName == "" then
      local custom_ai = string.find(chatData.roomId, "custom_ai_", 1, true)
      if custom_ai ~= nil and 0 < custom_ai then
        operatorName = ChatManager2:GetInstance().Room:GetRoomData(chatData.roomId):getRoomName()
      end
    end
  end
  local hintType = chatData.type
  local isInMemberArr = false
  local memberName = ""
  if not string.IsNullOrEmpty(chatData.msg) and hintType ~= 5 then
    local userList = string.split(chatData.msg, "|")
    if not table.IsNullOrEmpty(userList) then
      local username, uid
      for i = 1, #userList do
        uid = userList[i]
        if uid == playerUid then
          username = ChatInterface.getString("290018")
          isInMemberArr = true
        else
          local uinfo = ChatManager2:GetInstance().User:getChatUserInfo(uid, false)
          username = uinfo.userName
        end
        if uid ~= senderUid then
          if string.IsNullOrEmpty(memberName) then
            memberName = username
          else
            memberName = memberName .. "," .. username
          end
        end
      end
    end
  end
  local hintMsg = ""
  if hintType == ChatSystemMessageType.ROOM_OP_MEMBER_ADD then
    hintMsg = ChatInterface.getString("group_user_join_tips", memberName)
    if IsGmMode(chatData.roomId) then
      hintMsg = ChatInterface.getString("121050")
    end
  elseif hintType == ChatSystemMessageType.ROOM_OP_CREATE then
    hintMsg = ChatInterface.getString("group_create_title", operatorName)
  elseif hintType == ChatSystemMessageType.ROOM_OP_MEMBER_QUIT then
    hintMsg = ChatInterface.getString("group_user_leave_tips", operatorName)
  elseif hintType == ChatSystemMessageType.ROOM_OP_KICK_MEMBER then
    if IsGmMode(chatData.roomId) then
      hintMsg = ChatInterface.getString("121051")
    elseif isInMemberArr and not isOperator then
      hintMsg = ChatInterface.getString("290013", operatorName)
    else
      hintMsg = ChatInterface.getString("group_user_leave_tips", memberName)
    end
  elseif hintType == ChatSystemMessageType.ROOM_OP_MODIFY_NAME then
    hintMsg = chatData.msg
    hintMsg = ChatInterface.getString("group_name_changed", operatorName, hintMsg)
  elseif hintType == ChatSystemMessageType.ROOM_OP_ACCEPT_INVITE then
    hintMsg = chatData.msg
    hintMsg = ChatInterface.getString("group_user_join_tips", operatorName)
  elseif hintType == ChatSystemMessageType.ROOM_OP_CHANGE_LEADER then
    hintMsg = chatData.msg
    hintMsg = ChatInterface.getString("group_owner_trans_tips2", memberName)
  end
  return hintMsg
end

local eNoticeType = {
  ATTACK_NEUTRAL = 0,
  ATTACK_OTHER = 1,
  OCCUPY_FIRST_NEUTRAL = 2,
  OCCUPY_NEUTRAL = 3,
  OCCUPY_OTHER = 4,
  OCCUPY_THRONE = 5,
  BE_KING = 6,
  DARK_KNIGHT_OCCUPY = 7,
  BEHEMOTH_BOSS = 8,
  BLOODY_QUEEN_GUNNER = 9
}

local function GetCityInfo(serverId, cityId)
  local lineData = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, serverId)
  if lineData then
    local cityPos = lineData.pos
    local cityLv = lineData.level
    if cityLv ~= nil and cityPos ~= nil then
      local seasonInfo = SeasonUtil.GetSeasonInfo(serverId)
      local nameStr = Localization:GetString(lineData.name)
      local levelStr = "Lv." .. tostring(cityLv)
      local posStr = "(X:" .. cityPos.x .. ",Y:" .. cityPos.y .. ") "
      if serverId ~= 0 and SeasonUtil.InSeasonBigMapMode() then
        local bigMapIndex = lineData.bigMapIndex
        if bigMapIndex ~= 0 then
          serverId = seasonInfo:GetNinePalacesServer(bigMapIndex)
          if serverId ~= 0 then
            posStr = " #" .. serverId .. posStr
          end
        end
      elseif serverId ~= nil and serverId ~= 0 and serverId ~= -1 then
        posStr = " #" .. serverId .. posStr
      end
      return levelStr, nameStr, posStr
    end
  end
  return nil
end

local function Decode_Sub_ATTACK_NEUTRAL(tabCityInfo)
  local cityId = tabCityInfo.cityId or 0
  local alAbbr = tabCityInfo.alAbbr or ""
  local name = tabCityInfo.cityName or ""
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local levelStr, nameStr, posStr = GetCityInfo(tabCityInfo.serverId or loginServerId, cityId)
  if levelStr and nameStr and posStr then
    if name == nil or name == "" then
      name = nameStr
    end
    return Localization:GetString("121053", alAbbr, levelStr, name .. posStr)
  end
  return nil
end

local function Decode_Sub_ATTACK_OTHER(tabCityInfo)
  local cityId = tabCityInfo.cityId or 0
  local oldAlAbbr = tabCityInfo.oldAlAbbr or ""
  local alAbbr = tabCityInfo.alAbbr or ""
  local name = tabCityInfo.cityName or ""
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local levelStr, nameStr, posStr = GetCityInfo(tabCityInfo.serverId or loginServerId, cityId)
  if levelStr and nameStr and posStr then
    if name == nil or name == "" then
      name = nameStr
    end
    return Localization:GetString("121052", alAbbr, oldAlAbbr, levelStr, name .. posStr)
  end
  return nil
end

local function Decode_Sub_OCCUPY_FIRST_NEUTRAL(tabCityInfo)
  local cityId = tabCityInfo.cityId or 0
  local alAbbr = tabCityInfo.alAbbr or ""
  local name = tabCityInfo.cityName or ""
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local levelStr, nameStr, posStr = GetCityInfo(tabCityInfo.serverId or loginServerId, cityId)
  if levelStr and nameStr and posStr then
    if name == nil or name == "" then
      name = nameStr
    end
    return Localization:GetString("126000", alAbbr, levelStr, name .. posStr)
  end
  return nil
end

local function Decode_Sub_OCCUPY_NEUTRAL(tabCityInfo)
  local cityId = tabCityInfo.cityId or 0
  local alAbbr = tabCityInfo.alAbbr or ""
  local name = tabCityInfo.cityName or ""
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local levelStr, nameStr, posStr = GetCityInfo(tabCityInfo.serverId or loginServerId, cityId)
  if levelStr and nameStr and posStr then
    if name == nil or name == "" then
      name = nameStr
    end
    return Localization:GetString("121055", alAbbr, levelStr, name .. posStr)
  end
  return nil
end

local function Decode_Sub_OCCUPY_OTHER(tabCityInfo)
  local cityId = tabCityInfo.cityId or 0
  local oldAlAbbr = tabCityInfo.oldAlAbbr or ""
  local alAbbr = tabCityInfo.alAbbr or ""
  local name = tabCityInfo.cityName or ""
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local levelStr, nameStr, posStr = GetCityInfo(tabCityInfo.serverId or loginServerId, cityId)
  if levelStr and nameStr and posStr then
    if name == nil or name == "" then
      name = nameStr
    end
    return Localization:GetString("126001", alAbbr, oldAlAbbr, levelStr, name .. posStr)
  end
  return nil
end

local function Decode_Sub_BLOODY_QUEEN_GUNNER(tabCityInfo)
  local pointId = tabCityInfo.pointId
  if pointId == nil then
    return ""
  end
  local pos = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
  local monsterId = tabCityInfo.monsterId
  local monsterName = ""
  if monsterId then
    local cfg = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
    monsterName = Localization:GetString(cfg.name)
  end
  local cityId = tabCityInfo.cityId or 0
  local cityName = GetTableData(TableName.WorldCity, cityId, "name")
  cityName = Localization:GetString(cityName)
  local strPos = "(" .. "X:" .. pos.x .. "," .. "Y:" .. pos.y .. ")"
  local nameStr = monsterName .. strPos
  return Localization:GetString("s1_QueenChallenge_wc_tips1", nameStr, cityName)
end

local function Decode_NeutralAttack(chatData, t, isFullMsg)
  local extra = chatData.extra or {}
  local allianceCityInfo = extra.allianceCityInfo or ""
  local tabCityInfo = rapidjson.decode(allianceCityInfo)
  if tabCityInfo == nil then
    return nil
  end
  local noticeType = tabCityInfo.noticeType or 0
  if noticeType == eNoticeType.ATTACK_NEUTRAL then
    return Decode_Sub_ATTACK_NEUTRAL(tabCityInfo)
  elseif noticeType == eNoticeType.ATTACK_OTHER then
    return Decode_Sub_ATTACK_OTHER(tabCityInfo)
  elseif noticeType == eNoticeType.OCCUPY_FIRST_NEUTRAL then
    return Decode_Sub_OCCUPY_FIRST_NEUTRAL(tabCityInfo)
  elseif noticeType == eNoticeType.OCCUPY_NEUTRAL then
    return Decode_Sub_OCCUPY_NEUTRAL(tabCityInfo)
  elseif noticeType == eNoticeType.OCCUPY_OTHER then
    return Decode_Sub_OCCUPY_OTHER(tabCityInfo)
  elseif noticeType == eNoticeType.OCCUPY_THRONE then
    local cityId = tabCityInfo.cityId or 0
    local alAbbr = tabCityInfo.alAbbr or ""
    local name = tabCityInfo.cityName or ""
    local loginServerId = LuaEntry.Player:GetSelfServerId()
    local levelStr, nameStr, posStr = GetCityInfo(tabCityInfo.serverId or loginServerId, cityId)
    if levelStr and nameStr and posStr then
      if name == nil or name == "" then
        name = nameStr
      end
      return Localization:GetString("121055", alAbbr, levelStr, name .. posStr)
    end
  elseif noticeType == eNoticeType.BE_KING then
    local alAbbr = tabCityInfo.alAbbr
    local alName = tabCityInfo.alName
    local kingName = tabCityInfo.kingName
    if alAbbr ~= nil and alAbbr ~= "" then
      alName = "[" .. alAbbr .. "]" .. alName
    end
    if alName ~= nil and kingName ~= nil then
      return Localization:GetString("457080", alName, kingName)
    end
  elseif noticeType == eNoticeType.DARK_KNIGHT_OCCUPY then
    local cityName = DataCenter.AllianceCityTemplateManager:GetFormatName(tonumber(tabCityInfo.cityId), LuaEntry.Player:GetSourceServerId())
    if not string.IsNullOrEmpty(cityName) then
      return Localization:GetString("season_dark_knight_message01", cityName)
    end
  elseif noticeType == eNoticeType.BEHEMOTH_BOSS then
    local cityName = DataCenter.AllianceCityTemplateManager:GetFormatName(tonumber(tabCityInfo.cityId), LuaEntry.Player:GetSourceServerId())
    if not string.IsNullOrEmpty(cityName) then
      return Localization:GetString("season_s2_activity_1000047_description_20", cityName)
    end
  elseif noticeType == eNoticeType.BLOODY_QUEEN_GUNNER then
    return Decode_Sub_BLOODY_QUEEN_GUNNER(tabCityInfo)
  end
  return nil
end

local function Decode_ChampionBattle_ReportS_hare(chatData, t, isFullMsg)
  if t == nil or t.para == nil then
    return ""
  end
  if t.para.contentDialogId1 ~= nil then
    local dialogId1 = t.para.contentDialogId1
    local dialogId2 = t.para.contentDialogId2
    local dialogId3 = t.para.contentDialogId3
    local contentName1 = t.para.contentName1 or ""
    local contentName2 = t.para.contentName2 or ""
    local str = Localization:GetString(dialogId1, Localization:GetString(dialogId2)) .. "\n" .. Localization:GetString(dialogId3, contentName1, contentName2)
    return str or ""
  end
  return t.para.msg or ""
end

local function Decode_Text_Formation_Fight_Share(chatData, t, isFullMsg)
  if chatData.param ~= nil then
    return chatData.param.msg or ""
  end
  local attachmentId = chatData.attachmentId or ""
  local tabAttach = rapidjson.decode(attachmentId) or {}
  local tabParam = tabAttach.para or {}
  local dialogId = tabParam.dialogId
  if dialogId == nil then
    return ""
  end
  local param1 = tabParam.param1
  if param1 ~= nil then
    if type(param1) == "table" then
      if param1.eventId ~= nil then
        param1 = Localization:GetString(param1.name, param1.eventId)
      else
        local name = Localization:GetString(param1.name) or ""
        local level = ""
        if param1.level ~= nil then
          level = Localization:GetString("300665", param1.level)
        end
        if param1.abbr ~= nil then
          param1 = "[" .. param1.abbr .. "] " .. level .. " " .. name
        else
          param1 = level .. " " .. name
        end
      end
    end
  else
    param1 = ""
  end
  local param2 = tabParam.param2
  if param2 ~= nil then
    if type(param2) == "table" then
      if param2.eventId ~= nil then
        param2 = Localization:GetString(param2.name, param2.eventId)
      else
        local name = Localization:GetString(param2.name) or ""
        local level = ""
        if param2.level ~= nil then
          level = Localization:GetString("300665", param2.level)
        end
        if param2.abbr ~= nil then
          param2 = "[" .. param2.abbr .. "] " .. level .. " " .. name
        else
          param2 = level .. " " .. name
        end
      end
    end
  else
    param2 = ""
  end
  local a = Localization:GetString(dialogId, param1, param2)
  return Localization:GetString(dialogId, param1, param2)
end

local function Decode_SharePlayerFormation(chatData, t, isFullMsg)
  return Localization:GetString("110184")
end

local function Decode_AllianceRedPacket(chatData, t, isFullMsg)
  local buildId = GetTableData(TableName.SysRedPacket, chatData.extra.reasonId, "building")
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  local lvConfig = GetTableData(TableName.SysRedPacket, chatData.extra.reasonId, "level")
  local buildName = ""
  if buildTemplate then
    buildName = Localization:GetString(buildTemplate.name)
  end
  return Localization:GetString(chatData.msg, chatData.senderName, buildName, lvConfig)
end

local function Decode_Text_MsgShare(chatData, t, isFullMsg)
  local param = t
  if param ~= nil and param.dialogId ~= nil and param.dialogId ~= "" then
    local msgList = {}
    local num = param.dialogParamNum
    for i = 1, num do
      local a = param.unUseDialogParamList[i]
      if a ~= nil and a ~= "" then
        table.insert(msgList, a)
      else
        local b = param.useDialogParamList[i]
        if b ~= nil and b ~= "" then
          b = Localization:GetString(b)
        else
          b = ""
        end
        table.insert(msgList, b)
      end
    end
    return Localization:GetString(param.dialogId, SafeUnpack(msgList))
  else
    return ""
  end
end

local function Decode_Text_FightReport(chatData, t, isFullMsg)
  if chatData and chatData.extra and chatData.extra.isDefAssist then
    return Localization:GetString(2900034)
  else
    return Localization:GetString(310101)
  end
end

local function Decode_Alliance_CityUnderAttack(chatData, t, isFullMsg)
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj then
      if jsonObj.isAtkMonster then
        return Localization:GetString("season_alliance_system_notification_1")
      end
      if jsonObj.cityId then
        local serverId = jsonObj.serverId or LuaEntry.Player:GetSelfServerId()
        local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(jsonObj.cityId, serverId)
        if cityTemplate and cityTemplate.type == WorldAllianceCityType.Stronghold then
          return Localization:GetString("season_alliance_system_notification_2")
        end
      end
      if jsonObj.buildingId then
        return Localization:GetString("season_alliance_system_notification_3")
      end
    end
  end
  return Localization:GetString(393098)
end

local function Decode_Alliance_OfficialChange(chatData, t, isFullMsg)
  if chatData.post == PostType.Alliance_OfficialChange then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj.official and jsonObj.official > 0 then
      local name = Localization:GetString(LWAlMemberOffcialParam[jsonObj.official].Text)
      return Localization:GetString(393095, name)
    end
  elseif chatData.post == PostType.Alliance_LeaderChange then
    return Localization:GetString(393095, Localization:GetString(302336))
  end
  return ""
end

local function Decode_ChatGPT_Assistant(chatData, t, isFullMsg)
  return chatData.msg
end

local function Decode_AllianceNotice(chatData, t, isFullMsg)
  if string.IsNullOrEmpty(chatData.extraJson) then
    return chatData.msg, nil, true
  else
    local showNotice, noticeAddExtraJsonData = ChatInterface.GetShowNoticeAndAddTempData(chatData.msg, chatData.extraJsonData)
    return showNotice, nil, true
  end
end

local function Decode_DetectTreasureFinInfo(chatData, t, isFullMsg)
  local pointId = 0
  local ownerName = ""
  local eventId = ""
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj and jsonObj.pointId then
      pointId = jsonObj.pointId
    end
    if jsonObj and jsonObj.owner then
      ownerName = jsonObj.owner.name
    end
    if jsonObj and jsonObj.eventId then
      eventId = jsonObj.eventId
    end
  end
  local pos = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
  local posStr = string.format("(%d,%d)", pos.x, pos.y)
  local resultStr = ""
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(eventId)
  if template then
    if template.type == DetectEventType.TREASURE then
      if template:JudgeIsDroneTreasure() then
        resultStr = Localization:GetString("radar_tips_14", posStr, ownerName)
      else
        resultStr = Localization:GetString(801349, posStr, ownerName)
      end
    elseif template.type == DetectEventType.TREASURE_ACTIVITY or template.type == DetectEventType.OFF_SEASON_TREASURE then
      resultStr = Localization:GetString("activity_wajueji_27000_tips1", posStr, ownerName)
    end
  else
    resultStr = Localization:GetString(801349, posStr, ownerName)
  end
  return resultStr
end

local function Decode_NewAllianceRallyPoint(chatData, t, isFullMsg)
  local pointId = 0
  local name = ""
  local serverId = ""
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj and jsonObj.pointId then
      pointId = jsonObj.pointId
    end
    if jsonObj and jsonObj.name then
      name = jsonObj.name
    end
    if jsonObj and jsonObj.serverId then
      serverId = jsonObj.serverId
    end
  end
  local pos = SceneUtils.BigIndexToTilePos(pointId, ForceChangeScene.World)
  local posStr = UIUtil.FormatServerPosition(serverId, pos.x, pos.y)
  local resultStr = Localization:GetString("s5_cross_tips02", name, posStr)
  return resultStr
end

local function Decode_Train(chatData, t, isFullMsg)
  return Localization:GetString(458622)
end

local function Decode_Train_Rob(chatData, t, isFullMsg)
  local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
  local user = jsonObj.user
  local isWin = jsonObj.result or false
  local langKey = isWin and 458539 or 458540
  return Localization:GetString(langKey, UIUtil.FormatAllianceAndName(user.abbr, user.name))
end

local function Decode_Train_Departure(chatData, t, isFullMsg)
  local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
  local user = jsonObj.user
  return Localization:GetString(458512, UIUtil.FormatAllianceAndName(user.abbr, user.name))
end

local function Decode_Train_Driver(chatData, t, isFullMsg)
  local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
  local user = jsonObj.user
  return Localization:GetString(458510, UIUtil.FormatAllianceAndName(user.abbr, user.name))
end

local function Decode_BargainShop(chatData, t, isFullMsg)
  return Localization:GetString("activity_bargain_shop_desc24")
end

local function Decode_Truck_Send_Record(chatData, t, isFullMsg)
  return Localization:GetString("city_trade_tips1005")
end

local function Decode_Alliance_LeaderChange(chatData, t, isFullMsg)
  return Localization:GetString(393095, Localization:GetString(302336))
end

local function Decode_SeasonDesert(chatData, t, isFullMsg)
  return Localization:GetString("season_ui_desc036")
end

local function Decode_RedPacket(chatData)
  local userInfo = ChatManager2:GetInstance().User:getChatUserInfo(chatData.senderUid)
  local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
  local redPocketTemp
  if jsonObj.packetId then
    redPocketTemp = DataCenter.RedPacketTemplateManager:GetTemplate(jsonObj.packetId)
  else
    redPocketTemp = DataCenter.RedPacketTemplateManager:GetTemplateByGoodsId(jsonObj.goodsId)
  end
  if not redPocketTemp then
    return Localization:GetString("120035")
  end
  local str = Localization:GetString(redPocketTemp.chat_mainui_desc, userInfo.userName, Localization:GetString(redPocketTemp:GetName()))
  return str
end

local function Decode_RedPacketMsg(chatData)
  local extraJson
  local str = ""
  if chatData.extra ~= nil and chatData.extra.customJsonParam ~= nil then
    extraJson = rapidjson.decode(chatData.extra.customJsonParam)
    str = Localization:GetString("red_pocket_desc19", extraJson.senderName, extraJson.bestName)
  else
    str = Localization:GetString("120035")
  end
  return str
end

local function Decode_AllianceWar()
  return Localization:GetString("rally_share_title")
end

local function Decode_Activity_Multiple_Parkour(chatData, t, isFullMsg)
  if t then
    if t.serverRank then
      return Localization:GetString("multiply_door_tips_018", t.serverRank)
    elseif t.alncRank then
      return Localization:GetString("multiply_door_tips_019", t.alncRank)
    elseif t.passedLevel then
      return Localization:GetString("multiply_door_tips_020", t.passedLevel)
    end
  end
  return Localization:GetString("dev_multiple_stage_04")
end

local function Decode_DetectEventGetDoubleTreasure(chatData, t, isFullMsg)
  local playerName = ""
  local bigRewardMultiple
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj and jsonObj.bigRewardInfo then
      local rewardInfo = jsonObj.bigRewardInfo
      playerName = rewardInfo.name
      if jsonObj.bigRewardMultiple then
        bigRewardMultiple = jsonObj.bigRewardMultiple
      end
    end
  end
  local str = ""
  if bigRewardMultiple then
    str = Localization:GetString("activity_s1_qingdian_521003_radar_tips_11", playerName, bigRewardMultiple)
  else
    str = Localization:GetString("radar_tips_11", playerName)
  end
  return str
end

local function Decode_DispatchTreasure(chatData)
  local extraJson
  local str = ""
  if chatData.extra ~= nil and chatData.extra.customJsonParam ~= nil then
    extraJson = rapidjson.decode(chatData.extra.customJsonParam)
    local item1Id = DataCenter.ItemTemplateManager:GetName(extraJson.exchangeInfo.costFragment)
    local item2Id = DataCenter.ItemTemplateManager:GetName(extraJson.exchangeInfo.needFragment)
    str = Localization:GetString("Treasure_map_17", item1Id, item2Id)
  else
    str = Localization:GetString("120035")
  end
  return str
end

local function Decode_ZombieRush(chatData, t, isFullMsg)
  local pointId = -1
  local zombieRushMetaId = 0
  local playerName = ""
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj then
      if jsonObj.pointId then
        pointId = jsonObj.pointId
      end
      if jsonObj.zombieRushId then
        zombieRushMetaId = jsonObj.zombieRushId
      end
      if jsonObj.startName then
        playerName = jsonObj.startName
      end
    end
  end
  if 0 <= pointId then
    local pos = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
    local level = 0
    if 0 < zombieRushMetaId then
      local template = DataCenter.LWZombieRushTemplateManager:GetTemplate(zombieRushMetaId)
      if template then
        level = template.difficulty
      end
    end
    if playerName == "" then
      return Localization:GetString("zombieRush_tips_22", level, pos.x, pos.y)
    else
      return Localization:GetString("zombieRush_tips_28", level, pos.x, pos.y, playerName)
    end
  end
  return ""
end

local function Decode_FixAllianceBuilding(chatData)
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj and jsonObj.buildingId and jsonObj.uid then
      local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      local tilePos = SceneUtils.IndexToTilePos(jsonObj.pointId, ForceChangeScene.World)
      local strPos = UIUtil.FormatServerPosition(jsonObj.serverId, tilePos.x, tilePos.y)
      local name = jsonObj.name or jsonObj.uid or "???"
      local txt = Localization:GetString("season_rebuild_tips004", name, strPos)
      if data ~= nil and data.allianceName ~= "" and data.abbr then
        txt = Localization:GetString("season_rebuild_tips004", UIUtil.FormatAllianceAndName(data.abbr, name), strPos)
      end
      local link = {
        action = "Jump",
        x = tilePos.x,
        y = tilePos.y,
        server = jsonObj.serverId
      }
      local json = rapidjson.encode(link)
      local linkId = base64.encode(json)
      return string.format("<link='%s'><u>%s</u></link>", linkId, txt)
    end
  end
  return ""
end

local function Decode_BestReward(chatData)
  local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
  if jsonObj and jsonObj.senderInfo and jsonObj.senderInfo.uid then
    return Localization:GetString("red_pocket_desc38", jsonObj.senderInfo.name)
  end
end

local function Decode_SeasonCampDestroyCity(chatData)
  if not chatData then
    return ""
  end
  local jsonObj
  if chatData.extra and chatData.extra.customJsonParam then
    jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
  end
  if not jsonObj then
    return ""
  end
  local customContent = jsonObj.customContent or jsonObj
  local attackerInfo = customContent.attackerInfo
  local defenderInfo = customContent.defenderInfo
  local cityInfo = customContent.cityInfo
  local attackCampName = customContent.attackCampName or ""
  local attackerName = ""
  if attackerInfo then
    attackerName = UIUtil.FormatServerAllianceName(attackerInfo.serverId, attackerInfo.abbr, attackerInfo.name)
  end
  local posStr = ""
  if cityInfo and cityInfo.pointId then
    local serverId = cityInfo.serverId or LuaEntry.Player:GetSelfServerId()
    posStr = UIUtil.MakeJumpLink(cityInfo.pointId, serverId, 0)
  end
  local defenderName = ""
  if defenderInfo then
    defenderName = UIUtil.FormatServerAllianceName(defenderInfo.serverId, defenderInfo.abbr, defenderInfo.name)
  end
  local cityName = ""
  if cityInfo and cityInfo.cityId then
    local serverId = cityInfo.serverId or LuaEntry.Player:GetSelfServerId()
    local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityInfo.cityId, serverId)
    if cityTemplate then
      cityName = Localization:GetString("310128", cityTemplate.level, cityTemplate:GetName())
    end
  end
  local campName = Localization:GetString(attackCampName)
  return Localization:GetString("season_s6_activity_1200112_desc17", attackerName, posStr, defenderName, cityName, campName)
end

local function Decode_SeasonOccupyAltar(chatData, param)
  if table.IsNullOrEmpty(param) then
    return ""
  end
  local altarCell = DataCenter.AllianceCityTemplateManager:GetTemplate(param.cfgid, param.sid)
  if altarCell ~= nil then
    local pos = altarCell.pos
    local strPos = UIUtil.FormatServerPosition(param.sid, pos.x, pos.y)
    local altarName = string.format("%s<u>%s</u>", altarCell:GetFullName(), strPos)
    local text = CS.GameEntry.Localization:GetString("season_s6_activity_1200116_desc29", param.abbr, altarName)
    local link = {
      action = "Jump",
      x = pos.x,
      y = pos.y,
      server = param.sid
    }
    local json = rapidjson.encode(link)
    local linkId = base64.encode(json)
    return string.format("<link='%s'>%s</link>", linkId, text)
  end
  return CS.GameEntry.Localization:GetString("season_s6_activity_1200116_desc29")
end

local function Decode_MasterySkillShare(chatData, t, isFullMsg)
  if t then
    local configId = t.configId
    local lvOneTemp = DataCenter.MasteryManager:GetTempLevelOneByMasteryGroupId(configId)
    if lvOneTemp then
      return Localization:GetString("season_mastery_tips_12", Localization:GetString(lvOneTemp.name))
    end
  end
  return nil
end

local function Decode_GhostParkourRecordShare(chatData)
  return Localization:GetString("ghost_parkour_share_chat")
end

local function Decode_GhostReconTaskTeam(chatData)
  return Localization:GetString("team_up_default_msg")
end

local function Decode_SeasonAllianceBuildShare(chatData, t, isFullMsg)
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local seasonType = SeasonUtil.GetSeasonType()
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj and jsonObj.pointId == nil then
      local theStoveCenter = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
      if theStoveCenter ~= nil and theStoveCenter.pointId ~= nil then
        jsonObj.pointId = theStoveCenter.pointId
      else
        jsonObj.pointId = 1
      end
    end
    if jsonObj and (jsonObj.buildingId == nil or jsonObj.serverId == nil) then
      local MilitaryCenterBuildingId = SeasonUtil.GetSeasonMilitaryCenterId(seasonType)
      jsonObj.buildingId = MilitaryCenterBuildingId
      jsonObj.serverId = LuaEntry.Player:GetSourceServerId()
    end
    if jsonObj and jsonObj.pointId then
      local tilePos = SceneUtils.IndexToTilePos(jsonObj.pointId, ForceChangeScene.World)
      local strPos = UIUtil.FormatServerPosition(jsonObj.serverId, tilePos.x, tilePos.y)
      local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(jsonObj.buildingId)
      if template ~= nil then
        local txt
        if jsonObj.level then
          if jsonObj.level == 1 then
            txt = Localization:GetString("season_s2_alliance_building_tips002", "<u>" .. strPos .. "</u>", template:GetName())
          else
            txt = Localization:GetString("season_s2_alliance_building_tips004", "<u>" .. strPos .. "</u>", template:GetName(), jsonObj.level)
          end
        elseif jsonObj.name then
          txt = Localization:GetString("season_s2_alliance_building_tips001", jsonObj.name, "<u>" .. strPos .. "</u>", template:GetName())
        end
        local link = {
          action = "Jump",
          x = tilePos.x,
          y = tilePos.y,
          server = jsonObj.serverId
        }
        local json = rapidjson.encode(link)
        local linkId = base64.encode(json)
        return string.format("<link='%s'>%s</link>", linkId, txt)
      end
    end
  end
  return ""
end

local function Decode_AllianceAllyAssistanceNotify(chatData, t, isFullMsg)
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj then
      local assistanceAlliance = jsonObj.assistanceAlliance
      local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(jsonObj.cityId, jsonObj.serverId)
      local name = Localization:GetString("310128", cityTemplate.level, cityTemplate:GetName())
      local fromUser = UIUtil.FormatServerAllianceName(assistanceAlliance.serverId, assistanceAlliance.abbr)
      local tilePos = SceneUtils.IndexToTilePos(jsonObj.pointId, ForceChangeScene.World)
      local strPos = UIUtil.FormatServerPosition(jsonObj.serverId, tilePos.x, tilePos.y)
      local txt = Localization:GetString("s6_alliance_ally_desc55", fromUser, "<u>" .. name .. "</u>", strPos)
      return UIUtil.MakeJumpLink(jsonObj.pointId, jsonObj.serverId, 0, txt)
    end
  end
  return ""
end

local function Decode_AllianceAllyNotify(chatData, t, isFullMsg)
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj then
      local applyUuid = jsonObj.apply_id
      local applyData = DataCenter.SeasonAllyFriendManager:GetAllyDataByApplyUuid(applyUuid)
      local fromUser = UIUtil.FormatAllianceAndName(jsonObj.userObj.abbr, jsonObj.userObj.name)
      local fromAli = UIUtil.FormatAllianceAndName(jsonObj.userObj.abbr, nil)
      local txt = Localization:GetString("s6_alliance_ally_desc54", fromUser, fromAli)
      local link = {
        action = "SeasonAllyFriend",
        applyUuid = applyUuid
      }
      local json = rapidjson.encode(link)
      local linkId = base64.encode(json)
      if applyData == nil then
        DataCenter.SeasonAllyFriendManager:GetAllyCombinedList(true, false, 7000)
      end
      return string.format("<link='%s'>%s</link>", linkId, txt)
    end
  end
  return ""
end

local function Decode_SeasonStoveCenterShare(chatData, t, isFullMsg)
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj and jsonObj.pointId == nil then
      local theStoveCenter = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
      if theStoveCenter ~= nil and theStoveCenter.pointId ~= nil then
        jsonObj.pointId = theStoveCenter.pointId
      else
        jsonObj.pointId = 1
      end
    end
    if jsonObj and jsonObj.pointId then
      if chatData.post == PostType.SeasonStoveCenterMove then
        if jsonObj and (jsonObj.buildingId == nil or jsonObj.serverId == nil) and SeasonUtil.GetSeasonType() == SeasonMapType.Snow then
          jsonObj.buildingId = BuildingTypes.SEASON_STOVE_CENTER
          jsonObj.serverId = LuaEntry.Player:GetSourceServerId()
        end
        local tilePos = SceneUtils.IndexToTilePos(jsonObj.pointId, ForceChangeScene.World)
        local strPos = UIUtil.FormatServerPosition(jsonObj.serverId, tilePos.x, tilePos.y)
        local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(jsonObj.buildingId)
        if template ~= nil then
          local txt = Localization:GetString("season_s2_alliance_building_tips011", jsonObj.name, template:GetName(), "<u>" .. strPos .. "</u>")
          local link = {
            action = "Jump",
            x = tilePos.x,
            y = tilePos.y,
            server = jsonObj.serverId
          }
          local json = rapidjson.encode(link)
          local linkId = base64.encode(json)
          return string.format("<link='%s'>%s</link>", linkId, txt)
        end
      else
        local txt
        if chatData.post == PostType.SeasonStoveCenterInterrupt then
          txt = Localization:GetString("season_s2_alliance_building_tips020", jsonObj.name)
        elseif chatData.post == PostType.SeasonStoveCenterWork then
          txt = Localization:GetString("season_s2_alliance_building_tips003", jsonObj.name)
        elseif chatData.post == PostType.SeasonStoveCenterOverload then
          txt = Localization:GetString("season_s2_alliance_building_tips005", jsonObj.name)
        elseif chatData.post == PostType.SeasonStoveCenterWillStop then
          txt = Localization:GetString("season_s2_alliance_building_tips006")
        end
        local theStoveCenter = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
        if theStoveCenter ~= nil and theStoveCenter.pointId ~= nil then
          local tilePos = SceneUtils.IndexToTilePos(theStoveCenter.pointId, ForceChangeScene.World)
          local link = {
            action = "Jump",
            x = tilePos.x,
            y = tilePos.y,
            server = LuaEntry.Player:GetSourceServerId()
          }
          local json = rapidjson.encode(link)
          local linkId = base64.encode(json)
          return string.format("<link='%s'>%s</link>", linkId, txt)
        else
          return txt
        end
      end
    end
  end
  return ""
end

local function Decode_TorchRelayCheer(chatData, t, isFullMsg)
  return Localization:GetString("activity_torch_relay_desc_39")
end

local function Decode_Stickers()
  return Localization:GetString("chat_meme_panel_stickers")
end

local function Decode_SendPhoto()
  return Localization:GetString("picture_msg_preview")
end

local function Decode_HelpStopFirePerson(chatData, t, isFullMsg)
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj then
      return Localization:GetString(jsonObj.dialogId)
    end
  end
  return ""
end

local function Decode_HelpStopFireAlliance(chatData, t, isFullMsg)
  local name = ""
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj then
      name = jsonObj.playerInfo.name
    end
  end
  return Localization:GetString("outfire_msg_announce_0", name)
end

local function Decode_ASeasonTrendsShare(chatData, t, isFullMsg)
  local name = ""
  if chatData then
    local attachInfo = chatData:getMessageParam(false)
    local trendConfig = attachInfo and LocalController:instance():getLine(TableName.LW_Season_Trends, attachInfo.config_id)
    if trendConfig then
      name = Localization:GetString(tostring(trendConfig.stage_name))
    end
  end
  return name
end

local function Decode_ActMigration(chatData, t, isFullMsg)
  return chatData and Localization:GetString("migration_activity_interface_10068") or ""
end

local function Decode_DiggingGameShare(chatData, t, isFullMsg)
  if chatData then
    local attachInfo = chatData:getMessageParam(false)
    if attachInfo then
      return Localization:GetString(attachInfo.tipText)
    end
  end
  return Localization:GetString("season_activity_1000070_desc22", "")
end

local function Decode_SummonWeather(chatData, t, isFullMsg)
  if chatData then
    local attachInfo = chatData:getMessageParam(false)
    if attachInfo and attachInfo.name then
      local name = attachInfo.name
      if string.IsNullOrEmpty(attachInfo.alAbbr) then
        name = string.format("#%s %s", attachInfo.server, name)
      else
        name = string.format("#%s [%s]%s", attachInfo.server, attachInfo.alAbbr, name)
      end
      local weatherTemp = DataCenter.SeasonWeatherManager:GetWeatherTypeInfo(attachInfo.curWeatherId or 0)
      return Localization:GetString("s1_title_skill_tips08", name, Localization:GetString(weatherTemp and weatherTemp.name or ""))
    end
  end
  return Localization:GetString("s1_title_skill_tips08", "")
end

local function Decode_SeasonPhoto(chatData, t, isFullMsg)
  if chatData then
    local attachInfo = chatData:getMessageParam(false)
    if attachInfo then
      return Localization:GetString(attachInfo.isMessage and "season_alliance_photo_UI_35" or "season_alliance_photo_UI_2")
    end
  end
  return Localization:GetString("season_alliance_photo_UI_2")
end

local function Decode_Title(chatData, t, isFullMsg)
  if chatData then
    local attachInfo = chatData:getMessageParam(false)
    if attachInfo then
      local info = DataCenter.PlayerTitleTemplateManager:GetTitleInfo(attachInfo.cfgId)
      if info then
        return Localization:GetString(info.name)
      end
    end
  end
  return Localization:GetString("lw_title_ui_1")
end

local function Decode_BankReport(chatData, t, isFullMsg)
  return Localization:GetString("s5_bank_ui04")
end

local function Decode_UseMasterySkill(chatData, t, isFullMsg)
  local showTxt = ""
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local skillId = tonumber(chatData.extra.customJsonParam.skillId) or 0
    if 0 < skillId then
      local skillTemp = DataCenter.MasteryManager:GetSkillTemplate(skillId)
      if skillTemp then
        showTxt = Localization:GetString("skill_use_msg_preview")
      end
    end
  end
  return showTxt
end

local function Decode_EasterEggChat(chatData, t, isFullMsg)
  return chatData.msg
end

local function Decode_SkillAddMummyArmy(chatData, t, isFullMsg)
  local name = ""
  if not chatData or not chatData.extra then
    return name
  end
  local dialogId, addNum = "", 0
  if chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    dialogId = jsonObj and jsonObj.dialogId or ""
  end
  addNum = chatData.extra.addNum or 0
  name = Localization:GetString(dialogId, addNum)
  return name
end

local function Decode_SkillGuardianTower(chatData, t, isFullMsg)
  local jsonObj = t
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
  end
  if jsonObj == nil or jsonObj.skillId == nil then
    return ""
  end
  local skill_flag = AlOfficialSkillType.None
  local skill_cfg = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(jsonObj.skillId)
  if skill_cfg ~= nil and skill_cfg.skill_flag ~= nil then
    skill_flag = skill_cfg.skill_flag
  end
  if chatData and jsonObj and skill_flag == AlOfficialSkillType.GuardianTower then
    if jsonObj.noticeType == 1 and jsonObj.user then
      local tilePos = SceneUtils.IndexToTilePos(jsonObj.targetPointId, ForceChangeScene.World)
      local txt = UIUtil.FormatServerPosition(jsonObj.targetServerId, tilePos.x, tilePos.y)
      if jsonObj.buildId then
        local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(jsonObj.buildId)
        if template ~= nil then
          txt = txt .. template:GetName()
        end
      end
      local strUser = UIUtil.FormatServerAllianceName(jsonObj.user.serverId, jsonObj.user.abbr, jsonObj.user.name)
      local strPos = UIUtil.MakeJumpLink(jsonObj.targetPointId, jsonObj.targetServerId, 0, txt)
      if jsonObj.startPointId then
        strUser = UIUtil.MakeJumpLink(jsonObj.startPointId, jsonObj.targetServerId, 0, strUser)
      end
      return Localization:GetString("alliance_government_10006_45", strUser, strPos)
    else
      local strPos = UIUtil.MakeJumpLink(jsonObj.targetPointId, jsonObj.targetServerId, 0)
      return Localization:GetString("alliance_government_10006_46", strPos)
    end
  end
end

local function Decode_SkillAresMissile(chatData, t, isFullMsg)
  local jsonObj = t
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
  end
  if jsonObj == nil or jsonObj.skillId == nil then
    return ""
  end
  local skill_flag = AlOfficialSkillType.None
  local skill_cfg = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(jsonObj.skillId)
  if skill_cfg ~= nil and skill_cfg.skill_flag ~= nil then
    skill_flag = skill_cfg.skill_flag
  end
  if chatData and jsonObj and jsonObj.user and (skill_flag == AlOfficialSkillType.AresMissile or skill_flag == AlOfficialSkillType.MissileFactory) then
    if jsonObj.noticeType == 1 and jsonObj.user then
      local strUser = UIUtil.FormatServerAllianceName(jsonObj.user.serverId, jsonObj.user.abbr, jsonObj.user.name)
      local strPos = UIUtil.MakeJumpLink(jsonObj.targetPointId, jsonObj.targetServerId, 0)
      if jsonObj.startPointId then
        strUser = UIUtil.MakeJumpLink(jsonObj.startPointId, jsonObj.targetServerId, 0, strUser)
      end
      if skill_flag == AlOfficialSkillType.MissileFactory then
        return Localization:GetString("season_activity_1000086_tips33", strUser, strPos)
      end
      return Localization:GetString("season_alliance_government_skill_30", strUser, strPos)
    elseif jsonObj.noticeType == 2 and jsonObj.user then
      local user = UIUtil.FormatServerAllianceName(jsonObj.user.serverId, jsonObj.user.abbr, jsonObj.user.name)
      local interruptUser = UIUtil.FormatServerAllianceName(jsonObj.interruptUser.serverId, jsonObj.interruptUser.abbr, jsonObj.interruptUser.name)
      if skill_flag == AlOfficialSkillType.MissileFactory then
        return Localization:GetString("season_activity_1000086_tips27", interruptUser, user)
      end
      return Localization:GetString("season_alliance_government_skill_31", interruptUser, user)
    elseif jsonObj.noticeType == 3 and jsonObj.user then
      local user = UIUtil.FormatServerAllianceName(jsonObj.user.serverId, jsonObj.user.abbr, jsonObj.user.name)
      if jsonObj.startPointId then
        user = UIUtil.MakeJumpLink(jsonObj.startPointId, jsonObj.targetServerId, 0, user)
      end
      if skill_flag == AlOfficialSkillType.MissileFactory then
        return Localization:GetString("season_activity_1000086_tips34", user)
      end
      return Localization:GetString("season_alliance_government_skill_32", user)
    elseif jsonObj.noticeType == 4 and jsonObj.user then
      local strUser = UIUtil.FormatServerAllianceName(jsonObj.user.serverId, jsonObj.user.abbr, jsonObj.user.name)
      if jsonObj.startPointId then
        strUser = UIUtil.MakeJumpLink(jsonObj.startPointId, jsonObj.targetServerId, 0, strUser)
      end
      if skill_flag == AlOfficialSkillType.MissileFactory then
        return Localization:GetString("season_activity_1000086_tips35", strUser, jsonObj.playerNum)
      end
      return Localization:GetString("season_alliance_government_skill_33", strUser, jsonObj.playerNum)
    end
  end
  return ""
end

local function Decode_GoddessMummy(chatData, t, isFullMsg)
  local jsonObj = t
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
  end
  if jsonObj == nil or jsonObj.skillId == nil then
    return ""
  end
  local skill_flag = AlOfficialSkillType.None
  local skill_cfg = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(jsonObj.skillId)
  if skill_cfg ~= nil and skill_cfg.skill_flag ~= nil then
    skill_flag = skill_cfg.skill_flag
  end
  if chatData and jsonObj and jsonObj.user and skill_flag == AlOfficialSkillType.GoddessMummy then
    if jsonObj.noticeType == 1 and jsonObj.user then
      local strUser = UIUtil.FormatServerAllianceName(jsonObj.user.serverId, jsonObj.user.abbr, jsonObj.user.name)
      local strPos = UIUtil.MakeJumpLink(jsonObj.targetPointId, jsonObj.targetServerId, 0)
      if jsonObj.startPointId then
        strUser = UIUtil.MakeJumpLink(jsonObj.startPointId, jsonObj.targetServerId, 0, strUser)
      end
      return Localization:GetString("season_alliance_government_skill_goddess_30", strUser, strPos)
    elseif jsonObj.noticeType == 2 and jsonObj.user then
      local user = UIUtil.FormatServerAllianceName(jsonObj.user.serverId, jsonObj.user.abbr, jsonObj.user.name)
      local interruptUser = UIUtil.FormatServerAllianceName(jsonObj.interruptUser.serverId, jsonObj.interruptUser.abbr, jsonObj.interruptUser.name)
      return Localization:GetString("season_alliance_government_skill_goddess_31", interruptUser, user)
    elseif jsonObj.noticeType == 3 and jsonObj.user then
      local user = UIUtil.FormatServerAllianceName(jsonObj.user.serverId, jsonObj.user.abbr, jsonObj.user.name)
      if jsonObj.startPointId then
        user = UIUtil.MakeJumpLink(jsonObj.startPointId, jsonObj.targetServerId, 0, user)
      end
      return Localization:GetString("season_alliance_government_skill_goddess_32", user)
    elseif jsonObj.noticeType == 4 and jsonObj.user then
      local strUser = UIUtil.FormatServerAllianceName(jsonObj.user.serverId, jsonObj.user.abbr, jsonObj.user.name)
      if jsonObj.startPointId then
        strUser = UIUtil.MakeJumpLink(jsonObj.startPointId, jsonObj.targetServerId, 0, strUser)
      end
      return Localization:GetString("season_alliance_government_skill_goddess_33", strUser, jsonObj.playerNum)
    end
  end
  return ""
end

local function Decode_HelpMeAttackCityStronghold(chatData, t, isFullMsg)
  local jsonObj = t
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
  end
  if chatData and jsonObj then
    local strPos = UIUtil.MakeJumpLink(jsonObj.point, jsonObj.server, 0)
    return Localization:GetString("season_s2_alliance_building_tips021", jsonObj.name, strPos, jsonObj.level)
  end
  return ""
end

local function Decode_CityBeDeclareWar(chatData, t, isFullMsg)
  local jsonObj = t
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
  end
  if chatData and jsonObj then
    local ali_name = "[???]"
    if jsonObj.alInfo and jsonObj.alInfo.abbr then
      ali_name = UIUtil.FormatServerAllianceName(jsonObj.alInfo.serverId, jsonObj.alInfo.abbr, jsonObj.alInfo.name)
    end
    local city_name = Localization:GetString(jsonObj.cityName)
    local link_city_name = UIUtil.MakeJumpLink(jsonObj.pointId, jsonObj.serverId, 0, city_name)
    return Localization:GetString("alliance_faction_war_city_warning", jsonObj.cityLv, link_city_name, ali_name)
  end
  return ""
end

local function Decode_CityAttachmentConvert(chatData, t, isFullMsg)
  local jsonObj = t
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
  end
  if chatData and jsonObj then
    local ali_name = "[???]"
    if jsonObj.allianceObj and jsonObj.allianceObj.abbr then
      ali_name = UIUtil.FormatAllianceAndName(jsonObj.allianceObj.abbr, jsonObj.allianceObj.name)
    end
    return Localization:GetString("season_builders_alliance_tips_19", ali_name)
  end
  return ""
end

local function Decode_CityAttachmentBuildStart(chatData, t, isFullMsg)
  local jsonObj = t
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
  end
  if chatData and jsonObj then
    local strPos = UIUtil.MakeJumpLink(jsonObj.pointId, jsonObj.serverId, 0)
    local buildData = DataCenter.SeasonFarmerTemplateManager:GetBuildTemplateById(jsonObj.buildId)
    if buildData then
      local name = Localization:GetString(buildData.name)
      return Localization:GetString("season_builders_alliance_tips_21", strPos, name)
    else
      return Localization:GetString("season_builders_alliance_tips_21", strPos, "???")
    end
  end
  return ""
end

local function Decode_CityAttachmentBuildFinish(chatData, t, isFullMsg)
  local jsonObj = t
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
  end
  if chatData and jsonObj and jsonObj.pointId then
    local strPos = UIUtil.MakeJumpLink(jsonObj.pointId, jsonObj.serverId, 0)
    local buildData = DataCenter.SeasonFarmerTemplateManager:GetBuildTemplateById(jsonObj.buildId)
    local ali_name = "[???]"
    if jsonObj.allianceObj and jsonObj.allianceObj.abbr then
      ali_name = UIUtil.FormatAllianceAndName(jsonObj.allianceObj.abbr, jsonObj.allianceObj.name)
    end
    if buildData then
      local name = Localization:GetString(buildData.name)
      return Localization:GetString("season_builders_alliance_tips_20", ali_name, strPos, name)
    else
      return Localization:GetString("season_builders_alliance_tips_20", ali_name, strPos, "???")
    end
  end
  return ""
end

local function Decode_HelpMePutAresMissile(chatData, t, isFullMsg)
  if chatData and t then
    local name = ""
    local startV2 = SceneUtils.IndexToTilePos(t.startPos, ForceChangeScene.World)
    local targetV2 = SceneUtils.IndexToTilePos(t.targetPos, ForceChangeScene.World)
    local link = {
      action = "Jump",
      x = startV2.x,
      y = startV2.y,
      s = t.sid,
      ots = toInt(toInt(t.chantOverTime) * 0.001),
      t = PostType.HelpMePutAresMissile
    }
    local json = rapidjson.encode(link)
    local linkId = base64.encode(json)
    local targetStr = string.format("<link='%s'><u>%s</u></link>", linkId, UIUtil.FormatServerPosition(t.sid, targetV2.x, targetV2.y))
    if t.skillType == AlOfficialSkillType.GoddessMummy then
      local memberInfo = DataCenter.AllianceMemberDataManager:GetMemberInfoByOfficialPos(LWAlMemberOffcialType.War_Commander)
      if memberInfo then
        name = memberInfo.name or ""
      end
      return Localization:GetString("season_alliance_government_skill_goddess_29", name, targetStr)
    elseif t.skillType == AlOfficialSkillType.AresMissile then
      local memberInfo = DataCenter.AllianceMemberDataManager:GetMemberInfoByOfficialPos(LWAlMemberOffcialType.Deputy_Al_Leader)
      if memberInfo then
        name = memberInfo.name or ""
      end
      return Localization:GetString("season_alliance_government_skill_29", name, targetStr)
    elseif t.skillType == AlOfficialSkillType.MissileFactory then
      local memberInfo = DataCenter.AllianceMemberDataManager:GetMemberInfoByOfficialPos(LWAlMemberOffcialType.Deputy_Al_Leader)
      if memberInfo then
        name = memberInfo.name or ""
      end
      return Localization:GetString("season_activity_1000086_tips32", name, targetStr)
    end
  end
  return ""
end

local function Decode_GhostReconRemindLeader(chatData, t, isFullMsg)
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj and jsonObj.dialogId then
      return Localization:GetString(jsonObj.dialogId)
    end
  end
  return ""
end

local function Decode_MessageRecall(chatData, t, isFullMsg)
  return Localization:GetString("msg_recall_default", chatData:getSenderName())
end

local function Decode_InvasionBigBossSummon(chatData, t, isFullMsg)
  local pointId = 0
  local startName = ""
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj and jsonObj.pointId then
      pointId = jsonObj.pointId
    end
    if jsonObj and jsonObj.startName then
      startName = jsonObj.startName
    end
  end
  local pos = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
  local posStr = string.format("(%d,%d)", pos.x, pos.y)
  return Localization:GetString("activity_godzilla_start_r4_chat", startName, posStr)
end

local function Decode_Stage_Feature_Chapter(chatData, t, isFullMsg)
  if chatData and chatData.attachmentIdJsonObj then
    local extraJson = chatData.attachmentIdJsonObj
    if extraJson.fromChapter then
      local stageName = Localization:GetString(GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), extraJson.stageId, "name"), extraJson.stageOrder or 0)
      return Localization:GetString("breakthough_tips_04", stageName, extraJson.score or 0, extraJson.rank or "")
    elseif extraJson.fromActFrontBreakSunday then
      local serRankNew = extraJson.ActFrontBreakSerRankNew or 0
      local serRankOld = extraJson.ActFrontBreakSerRankOld or 0
      local alRankNew = extraJson.ActFrontBreakAlRankNew or 0
      local alRankOld = extraJson.ActFrontBreakAlRankOld or 0
      local topRankNew = extraJson.ActFrontBreakTopRankNew or 0
      local topRankOld = extraJson.ActFrontBreakTopRankOld or 0
      local totalLeft = extraJson.totalLeft or 0
      if 0 < topRankNew and (topRankOld == 0 or topRankNew < topRankOld) then
        return Localization:GetString("activity_breakthrough_tips_44", topRankNew)
      elseif 0 < serRankNew and serRankNew < serRankOld then
        return Localization:GetString("activity_breakthrough_tips_31", serRankNew)
      elseif 0 < alRankNew and alRankNew < alRankOld then
        local allianceAbbr = LuaEntry.Player:GetAllianceAbbr()
        return Localization:GetString("activity_breakthrough_tips_32", allianceAbbr, alRankNew)
      else
        local stageId = extraJson.stageId or 0
        local actId = extraJson.frontBreakSundayActId or 0
        local win = extraJson.win or false
        local index = DataCenter.ActFrontBreakSundayDataManager:GetActData(actId):GetStageIndex(stageId) or 0
        index = win and index or math.max(index - 1, 0)
        return Localization:GetString("activity_breakthrough_tips_33", index, totalLeft)
      end
    else
      return ""
    end
  else
    return ""
  end
end

local function Decode_SeasonTradeShopRefresh(chatData, t, isFullMsg)
  local resultStr = ""
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj then
      local pointId = jsonObj.pointId or 0
      local serverId = jsonObj.serverId or 0
      local pos = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
      local posStr = UIUtil.MakeJumpLink(pointId, serverId)
      local ownerName = jsonObj.cityOwnerName or ""
      local lv = jsonObj.tradeLevel or 1
      resultStr = Localization:GetString("season_s3_trading_post_desc09", ownerName, posStr, lv)
    end
  end
  return resultStr
end

local function Decode_CaptureHugeSandWorm(chatData, t, isFullMsg)
  local resultStr = ""
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj then
      resultStr = Localization:GetString("season_s3_scrollling_dialog_05", jsonObj.playerName, jsonObj.level)
      if jsonObj.serverId and jsonObj.pointId then
        resultStr = resultStr .. UIUtil.MakeJumpLink(jsonObj.pointId, jsonObj.serverId)
      end
    end
  end
  return resultStr
end

local function Decode_SeasonTradeBattleStart(chatData, t, isFullMsg)
  local resultStr = ""
  if chatData and chatData.extra and chatData.extra.cityLevel then
    resultStr = Localization:GetString("season_s3_trade_city037", chatData.extra.cityLevel)
  end
  return resultStr
end

local function Decode_SeasonTradeLordChange(chatData, t, isFullMsg)
  local resultStr = ""
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj then
      local pointId = jsonObj.pointId or 0
      local serverId = jsonObj.serverId or 669
      local pos = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
      local linkPos = UIUtil.MakeJumpLink(pointId, serverId)
      local tradeId = jsonObj.tradeId or 1
      local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(tradeId, serverId)
      if cityTemplate then
        resultStr = Localization:GetString("season_s3_trade_city049", linkPos, cityTemplate.level)
      end
    end
  end
  return resultStr
end

local function Decode_ZombieRushEliteAlterBossReward(chatData)
  local context = ""
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj and jsonObj.monsterId then
      local name = GetTableData(TableName.Monster, jsonObj.monsterId, "name")
      name = Localization:GetString(name)
      return Localization:GetString("zombierush_eliteBoss_alter_succeed_short", name)
    end
  end
  return context
end

local function Decode_ZombieRushAttack(chatData)
  local context = ""
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local data = rapidjson.decode(chatData.extra.customJsonParam)
    local monsterId = data.monsterId
    if monsterId then
      local name = GetTableData(TableName.Monster, monsterId, "name")
      name = Localization:GetString(name)
      context = Localization:GetString("zombierush_eliteBoss_alarm", name)
    end
  end
  return context
end

local function Decode_MadCowRush(chatData)
  return Localization:GetString("activity_military_exercises_limit_23")
end

local function Decode_ZombieRushEliteAlterBossAttack(chatData)
  local context = ""
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local data = rapidjson.decode(chatData.extra.customJsonParam)
    local monsterId = data.monsterId
    if monsterId then
      local name = GetTableData(TableName.Monster, monsterId, "name")
      name = Localization:GetString(name)
      context = Localization:GetString("zombierush_eliteBoss_alter_appear_short", name)
    end
  end
  return context
end

local function Decode_ZoneMobilizationAlRes(chatData)
  return Localization:GetString("zone_mobilization_donated_resource_chat_short")
end

local function Decode_ZoneMobilizationSupplies(chatData)
  return Localization:GetString("zone_mobilization_donated_supplies_chat_short")
end

local function Decode_ZoneMobilizationSuppliesRed(chatData)
  return Localization:GetString("zone_mobilization_supplies_red_share")
end

local function Decode_DigTreasure(chatData)
  return Localization:GetString("treasure_map_help_01")
end

local function Decode_KillZombieBoxShare(chatData)
  return Localization:GetString("challenge_zombie_alliance_share_short")
end

local function Decode_KillZombieStartChallenge(chatData)
  local pointId = 0
  local startName = ""
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj and jsonObj.pointId then
      pointId = jsonObj.pointId
    end
    if jsonObj and jsonObj.startName then
      startName = jsonObj.startName
    end
  end
  local pos = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
  local posStr = string.format("(%d,%d)", pos.x, pos.y)
  return Localization:GetString("challenge_zombie_start_r4_chat", startName, posStr)
end

local function Decode_TacticalCardShare(chatData, t, isFullMsg)
  local cardName = ""
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj and jsonObj.battleCards and jsonObj.battleCards[1] then
      local cardId = jsonObj.battleCards[1].cardId
      local cardTemplate = DataCenter.TacticalCardDataManager:GetTemplateData(cardId)
      if cardTemplate then
        cardName = Localization:GetString(cardTemplate.name)
      end
    end
  end
  return Localization:GetString("battle_card_share_single_info", cardName)
end

local function Decode_TacticalCardDeckShare(chatData, t, isFullMsg)
  local m = Localization:GetString("battle_card_share_title")
  return m
end

local function Decode_GroupChatInviter(chatData, t, isFullMsg)
  return Localization:GetString("group_invite_text")
end

local function Decode_Electrician_Gather(chatData, t, isFullMsg)
  return Localization:GetString("season_mastery_s4_name_8")
end

local function Decode_CityBattleBuffRefresh(chatData, t, isFullMsg)
  local jsonObj = t
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
  end
  if chatData and jsonObj and jsonObj.monsterLv and jsonObj.serverId and jsonObj.buffId then
    local monsterLv = jsonObj.monsterLv
    local serverId = jsonObj.serverId
    local buffId = jsonObj.buffId
    local cfg = LocalController:instance():getLine(TableName.StatusTab, buffId)
    local buffStr = string.format("<link=\"EffectId:%s\"><u>%s</u></link>", buffId, Localization:GetString(cfg.name))
    return Localization:GetString("s1_offseason_activity_recapture_buffActived", monsterLv, buffStr)
  end
  return ""
end

local function Decode_BloodyQueenBattleStart(chatData, t, isFullMsg)
  return Localization:GetString("s1_QueenChallenge_wc_tips2")
end

local function Decode_BloodyQueenBattleGunnerLastBlood(chatData, t, isFullMsg)
  local jsonObj = t
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
  end
  if chatData and jsonObj and jsonObj.allianceAbbr and jsonObj.serverId and jsonObj.userName then
    return Localization:GetString("s1_QueenChallenge_wc_tips3", "[" .. jsonObj.allianceAbbr .. "] " .. jsonObj.userName, "#" .. jsonObj.serverId)
  end
  return ""
end

local function Decode_MusicFestival2025_ScoreRank()
  return Localization:GetString("music_gameshare_desc")
end

local function Decode_FirstJoinAlliance(chatData, t, isFullMsg)
  return chatData:getMaskMsg()
end

local function Decode_ActConcertRewardShare(chatData, t, isFullMsg)
  local attachmentId = chatData.attachmentId
  if attachmentId then
    local extraJson = rapidjson.decode(attachmentId)
    local playerName = extraJson.playerName or ""
    local pos = SceneUtils.IndexToTilePos(extraJson.pointId)
    local posStr = string.format("(%d,%d)", pos.x, pos.y)
    local str = Localization:GetString("activity_concert_6", playerName, posStr)
    return str
  end
  return ""
end

local function Decode_FireworkReward(chatData)
  local str = Localization:GetString("firework_tips_1006")
  return str
end

local function Decode_FireworkRewardDouble(chatData)
  local str = Localization:GetString("firework_tips_1007")
  return str
end

local function Decode_OffSeasonDiggingGameShare(chatData, t, isFullMsg)
  if chatData then
    local attachInfo = chatData:getMessageParam(false)
    if attachInfo then
      return Localization:GetString(attachInfo.tipText)
    end
  end
  return Localization:GetString("season_activity_1000070_desc22", "")
end

local function Decode_SurfingInviteAllyShare(chatData)
  return Localization:GetString("parkour_help_title")
end

local function Decode_SurfingBattleResultShare(chatData)
  local context = ""
  if chatData then
    local attachmentId = chatData.attachmentId
    if not string.IsNullOrEmpty(attachmentId) then
      local param = rapidjson.decode(attachmentId)
      if param then
        context = param.context
        if context == nil or context == "" then
          local contextId = param.contextId
          if contextId == nil or contextId == "" then
            return ""
          else
            local para = param.para or ""
            local paraArr = string.split(para, "|")
            return Localization:GetString(contextId, table.unpack(paraArr))
          end
        end
      end
    end
  end
  return context
end

local function Decode_PostT11IdleGameAllianceHelp()
  return Localization:GetString("t11_idle_game_desc_51")
end

local function Decode_PostAlliance_Feature_Invite()
  return Localization:GetString("alliance_invite_title_joinus")
end

local function Decode_Season_BiuBiuInvite()
  local m = Localization:GetString("season_s5_activity_1200045_desc41")
  return m
end

local function Decode_Season_BiuBiuResult()
  local m = Localization:GetString("season_s5_activity_1200045_desc61")
  return m
end

local function Decode_Season_GGGoShare()
  local m = Localization:GetString("season_s6_minigame_pvp_limit2")
  return m
end

local function Decode_Season_LittleGame_Result()
  local m = Localization:GetString("s6_cave_exploration_record_title")
  return m
end

local function Decode_FlowerTrainShare()
  return Localization:GetString("2025halloween_chat_share_desc1")
end

local function Decode_FlowerTrainPositionShare(chatData)
  local name = ""
  if chatData and chatData.extra and chatData.extra.attachmentId then
    local jsonObj = rapidjson.decode(chatData.extra.attachmentId)
    if jsonObj then
      local itemId = jsonObj.goodsId
      local template = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
      if template then
        name = Localization:GetString(template.name)
      end
    end
  end
  return Localization:GetString("treasure_chat_share_desc_2", name)
end

local function Decode_FlowerTrainUseShare(chatData)
  local name = ""
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj then
      local itemId = jsonObj.itemId
      local template = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
      if template then
        name = Localization:GetString(template.name)
      end
    end
  end
  return Localization:GetString("treasure_chat_share_desc_1", name)
end

local function Decode_PostAllianceCongratulation(chatData)
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj then
      local configId = jsonObj.configId
      if jsonObj and configId then
        local lineData = LocalController:instance():getLine(TableName.LW_Alliance_Congratulation, configId)
        if lineData then
          return Localization:GetString(lineData.mainui_msg_key)
        end
      end
    end
  end
  return ""
end

local function Decode_NewsCenterLink()
  return "[" .. Localization:GetString("news_center_share_default") .. "]"
end

local function Decode_ZombieAttackCityAssistanceDefend(chatData)
  if chatData and chatData.extra and chatData.extra.monsterId then
    local monsterId = chatData.extra.monsterId
    if monsterId then
      local cfg = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
      if cfg then
        return Localization:GetString("gift_tips_2", cfg.level)
      end
    end
  end
  return ""
end

local function Decode_Stage_Feature_Help_Invite()
  return Localization:GetString("special_stage_name")
end

local function Decode_BF_Winter_History_Share()
  local m = Localization:GetString("winter_s0_tips_13")
  return m
end

local function Decode_GhostBattleResultShare(chatData)
  local context = ""
  if chatData then
    local attachmentId = chatData.attachmentId
    if not string.IsNullOrEmpty(attachmentId) then
      local param = rapidjson.decode(attachmentId)
      if param then
        local contextId = param.contextId
        local para = param.para or ""
        local paraArr = string.split(para, "|")
        return Localization:GetString(contextId, table.unpack(paraArr))
      end
    end
  end
  return context
end

local function Decode_MilitaryPayShare()
  return Localization:GetString("alliance_pay_desc_daily")
end

local function Decode_FrontBreakSundayRank(chatData)
  if chatData and chatData.attachmentIdJsonObj then
    local extraJson = chatData.attachmentIdJsonObj
    local serRankNew = extraJson.ActFrontBreakSerRankNew or 0
    local serRankOld = extraJson.ActFrontBreakSerRankOld or 0
    local alRankNew = extraJson.ActFrontBreakAlRankNew or 0
    local alRankOld = extraJson.ActFrontBreakAlRankOld or 0
    local topRankNew = extraJson.ActFrontBreakTopRankNew or 0
    local topRankOld = extraJson.ActFrontBreakTopRankOld or 0
    local totalLeft = extraJson.totalLeft or 0
    if 0 < topRankNew and (topRankOld == 0 or topRankNew < topRankOld) then
      return Localization:GetString("activity_breakthrough_tips_44", topRankNew)
    elseif 0 < serRankNew and serRankNew < serRankOld then
      return Localization:GetString("activity_breakthrough_tips_31", serRankNew)
    elseif 0 < alRankNew and alRankNew < alRankOld then
      local allianceAbbr = LuaEntry.Player:GetAllianceAbbr()
      return Localization:GetString("activity_breakthrough_tips_32", allianceAbbr, alRankNew)
    else
      local stageId = extraJson.stageId or 0
      local actId = extraJson.frontBreakSundayActId or 0
      local win = extraJson.win or false
      local index = DataCenter.ActFrontBreakSundayDataManager:GetActData(actId):GetStageIndex(stageId) or 0
      index = win and index or math.max(index - 1, 0)
      return Localization:GetString("activity_breakthrough_tips_33", index, totalLeft)
    end
  else
    return ""
  end
end

local function Decode_WorldBossNewRecordShare()
  return Localization:GetString(456014)
end

local function Decode_AllianceTeslaCoil(chatData, t, isFullMsg)
  local jsonObj = t
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
  end
  if jsonObj == nil or jsonObj.skillId == nil then
    return ""
  end
  local skill_flag = AlOfficialSkillType.None
  local skill_cfg = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(jsonObj.skillId)
  if skill_cfg ~= nil and skill_cfg.skill_flag ~= nil then
    skill_flag = skill_cfg.skill_flag
  end
  if chatData and jsonObj and jsonObj.user and skill_flag == AlOfficialSkillType.TeslaCoil then
    if jsonObj.noticeType == 4 and jsonObj.user then
      local strUser = UIUtil.FormatServerAllianceName(jsonObj.user.serverId, jsonObj.user.abbr, jsonObj.user.name)
      local strPos = ""
      if jsonObj.startPointId then
        strPos = UIUtil.MakeJumpLink(jsonObj.startPointId, jsonObj.targetServerId, 0, strUser)
      end
      local skillName = CS.GameEntry.Localization:GetString(skill_cfg.name)
      return CS.GameEntry.Localization:GetString("season_s6_government_skill_desc70", strUser, strPos, skillName)
    end
    if jsonObj.noticeType == 2 and jsonObj.user and jsonObj.interruptUser then
      local user = UIUtil.FormatServerAllianceName(jsonObj.user.serverId, jsonObj.user.abbr, jsonObj.user.name)
      local interruptUser = UIUtil.FormatServerAllianceName(jsonObj.interruptUser.serverId, jsonObj.interruptUser.abbr, jsonObj.interruptUser.name)
      local skillName = CS.GameEntry.Localization:GetString(skill_cfg.name)
      return CS.GameEntry.Localization:GetString("season_s6_government_skill_desc71", interruptUser, user, skillName)
    end
    if jsonObj.noticeType == 3 and jsonObj.user then
      local strUser = UIUtil.FormatServerAllianceName(jsonObj.user.serverId, jsonObj.user.abbr, jsonObj.user.name)
      return CS.GameEntry.Localization:GetString("season_s6_alliance_skill_60001_desc06", strUser)
    end
  end
  return ""
end

local function Decode_AllianceAbundantHarvest(chatData, t, isFullMsg)
  local jsonObj = t
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
  end
  if jsonObj == nil or jsonObj.skillId == nil then
    return ""
  end
  local skill_flag = AlOfficialSkillType.None
  local skill_cfg = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(jsonObj.skillId)
  if skill_cfg ~= nil and skill_cfg.skill_flag ~= nil then
    skill_flag = skill_cfg.skill_flag
  end
  if chatData and jsonObj and jsonObj.user and skill_flag == AlOfficialSkillType.AbundantHarvest and jsonObj.noticeType == 4 and jsonObj.user then
    local strUser = UIUtil.FormatServerAllianceName(jsonObj.user.serverId, jsonObj.user.abbr, jsonObj.user.name)
    return CS.GameEntry.Localization:GetString("season_s6_government_skill_desc69", strUser)
  end
  return ""
end

local function Decode_AllianceReinforcement(chatData, t, isFullMsg)
  local jsonObj = t
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
  end
  if jsonObj == nil or jsonObj.skillId == nil then
    return ""
  end
  local skill_flag = AlOfficialSkillType.None
  local skill_cfg = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(jsonObj.skillId)
  if skill_cfg ~= nil and skill_cfg.skill_flag ~= nil then
    skill_flag = skill_cfg.skill_flag
  end
  if chatData and jsonObj and jsonObj.user and skill_flag == AlOfficialSkillType.Reinforcement then
    if jsonObj.noticeType == 2 and jsonObj.user then
      local strUser = UIUtil.FormatServerAllianceName(jsonObj.user.serverId, jsonObj.user.abbr, jsonObj.user.name)
      local strPos = ""
      if jsonObj.targetPointId then
        local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(jsonObj.cityId)
        local cityName = cityMeta:GetName()
        strPos = UIUtil.MakeJumpLink(jsonObj.targetPointId, jsonObj.targetServerId, 0, cityName)
      end
      return CS.GameEntry.Localization:GetString("season_s6_alliance_skill_60001_desc05", strUser, strPos)
    elseif jsonObj.noticeType == 4 and jsonObj.user then
      local strUser = UIUtil.FormatServerAllianceName(jsonObj.user.serverId, jsonObj.user.abbr, jsonObj.user.name)
      local strPos = ""
      if jsonObj.targetPointId then
        local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(jsonObj.cityId)
        local cityName = cityMeta:GetName()
        strPos = UIUtil.MakeJumpLink(jsonObj.targetPointId, jsonObj.targetServerId, 0, cityName)
      end
      return CS.GameEntry.Localization:GetString("season_s6_alliance_skill_60001_desc01", strUser, strPos)
    elseif jsonObj.noticeType == 5 and jsonObj.user then
      local strPos = ""
      if jsonObj.targetPointId then
        local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(jsonObj.cityId)
        local cityName = cityMeta:GetName()
        strPos = UIUtil.MakeJumpLink(jsonObj.targetPointId, jsonObj.targetServerId, 0, cityName)
      end
      return CS.GameEntry.Localization:GetString("season_s6_alliance_skill_60001_desc02", strPos)
    end
  end
  return ""
end

local function Decode_AllianceRefreshBall(chatData, t, isFullMsg)
  local jsonObj = t
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
  end
  if jsonObj == nil or jsonObj.skillId == nil then
    return ""
  end
  local skill_flag = AlOfficialSkillType.None
  local skill_cfg = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(jsonObj.skillId)
  if skill_cfg ~= nil and skill_cfg.skill_flag ~= nil then
    skill_flag = skill_cfg.skill_flag
  end
  if chatData and jsonObj and jsonObj.user and skill_flag == AlOfficialSkillType.RefreshBall and jsonObj.noticeType == 4 and jsonObj.user then
    local strUser = UIUtil.FormatServerAllianceName(jsonObj.user.serverId, jsonObj.user.abbr, jsonObj.user.name)
    return CS.GameEntry.Localization:GetString("season_s6_government_skill_desc78", strUser)
  end
  return ""
end

local function Decode_Alliance_Lucky_Siphon(chatData)
  local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
  if jsonObj and jsonObj.senderInfo and jsonObj.packetId then
    local red_packet_temp = DataCenter.RedPacketTemplateManager:GetTemplate(jsonObj.packetId)
    if red_packet_temp.type == RedPacketType.LuckyBuff or red_packet_temp.type == RedPacketType.LuckyWithoutBuff then
      local red_packet_name = red_packet_temp:GetName()
      local red_packet_sender_name = jsonObj.senderInfo.name
      return Localization:GetString("red_pocket_desc41", red_packet_sender_name, Localization:GetString(red_packet_name))
    end
  end
end

local function Decode_S0AllianceBossReward(chatData)
  return Localization:GetString("s0_alliance_boss_fireworks_desc")
end

local DecodeTable = {
  [PostType.Text_PointShare] = Decode_PointShare,
  [PostType.Text_PointShare_Alliance] = Decode_PointShare,
  [PostType.Activity_BargainShop] = Decode_BargainShop,
  [PostType.Text_AllianceInvite] = Decode_AllianceInvite,
  [PostType.Text_AllianceRankChange] = Decode_AllianceRankChange,
  [PostType.Text_AllianceOfficialChange] = Decode_AllianceOfficialChange,
  [PostType.Text_MemberJoin] = Decode_AllianceMemberJoin,
  [PostType.Text_MemberQuit] = Decode_AllianceMemberQuit,
  [PostType.Abandon_AllianceCity] = Decode_Abandon_AllianceCity,
  [PostType.Text_FBAlliance_missile_share] = Decode_NeutralAttack,
  [PostType.Detect_Treasure_Fin_Info] = Decode_DetectTreasureFinInfo,
  [PostType.ActDetectTreasureItemUse] = Decode_DetectTreasureFinInfo,
  [PostType.NewAllianceRallyPoint] = Decode_NewAllianceRallyPoint,
  [PostType.Text_StorageShopShare] = Decode_StorageShopShare,
  [PostType.Text_AllianceTaskShare] = Decode_AllianceTaskShare,
  [PostType.Text_AllianceRecruitShare] = Decode_AllianceRecruitShare,
  [PostType.Text_Formation_Fight_Share] = Decode_Text_Formation_Fight_Share,
  [PostType.Text_ChampionBattleReportShare] = Decode_ChampionBattle_ReportS_hare,
  [PostType.Text_ChatRoomSystemMsg] = Decode_ChatRoomSystem,
  [PostType.Text_Formation_Share] = Decode_SharePlayerFormation,
  [PostType.RedPackge] = Decode_AllianceRedPacket,
  [PostType.Text_ScoutReport] = Decode_MailScoutResultShare,
  [PostType.Landmine] = Decode_LandmineShare,
  [PostType.GoldRelic] = Decode_GoldRelicShare,
  [PostType.Disguise] = Decode_DisguiseShare,
  [PostType.DefaultMarch] = Decode_DefaultMarchShare,
  [PostType.Text_MsgShare] = Decode_Text_MsgShare,
  [PostType.Alliance_OfficialChange] = Decode_Alliance_OfficialChange,
  [PostType.Alliance_CityUnderAttack] = Decode_Alliance_CityUnderAttack,
  [PostType.Text_FightReport] = Decode_Text_FightReport,
  [PostType.ChatGPT_Assistant] = Decode_ChatGPT_Assistant,
  [PostType.ChatGPT_Assistant_Private] = Decode_ChatGPT_Assistant,
  [PostType.Text_AllianceNotice] = Decode_AllianceNotice,
  [PostType.March] = Decode_PointShare,
  [PostType.Train_Rob] = Decode_Train_Rob,
  [PostType.Train_Departure] = Decode_Train_Departure,
  [PostType.Train_Driver] = Decode_Train_Driver,
  [PostType.Train] = Decode_Train,
  [PostType.Truck_Send_Record] = Decode_Truck_Send_Record,
  [PostType.Truck_Rob_Record] = Decode_Truck_Send_Record,
  [PostType.SeasonDesert] = Decode_SeasonDesert,
  [PostType.FixAllianceBuilding] = Decode_FixAllianceBuilding,
  [PostType.Alliance_War] = Decode_AllianceWar,
  [PostType.Activity_MultipleParkour] = Decode_Activity_Multiple_Parkour,
  [PostType.RedPackge_New] = Decode_RedPacket,
  [PostType.RedPacket_MSG] = Decode_RedPacketMsg,
  [PostType.DetectEventGetDoubleTreasure] = Decode_DetectEventGetDoubleTreasure,
  [PostType.Dispatch_Treasure] = Decode_DispatchTreasure,
  [PostType.Alliance_LeaderChange] = Decode_Alliance_LeaderChange,
  [PostType.ZombieRush] = Decode_ZombieRush,
  [PostType.MasterySkillShare] = Decode_MasterySkillShare,
  [PostType.BestReward] = Decode_BestReward,
  [PostType.PutSeasonAllianceBuild] = Decode_SeasonAllianceBuildShare,
  [PostType.SeasonAllianceBuildFinish] = Decode_SeasonAllianceBuildShare,
  [PostType.SeasonAllianceBuildLevelUp] = Decode_SeasonAllianceBuildShare,
  [PostType.SeasonStoveCenterOverload] = Decode_SeasonStoveCenterShare,
  [PostType.SeasonStoveCenterWillStop] = Decode_SeasonStoveCenterShare,
  [PostType.SeasonStoveCenterWork] = Decode_SeasonStoveCenterShare,
  [PostType.SeasonStoveCenterMove] = Decode_SeasonStoveCenterShare,
  [PostType.SeasonStoveCenterInterrupt] = Decode_SeasonStoveCenterShare,
  [PostType.HelpMePutAresMissile] = Decode_HelpMePutAresMissile,
  [PostType.SkillAresMissile] = Decode_SkillAresMissile,
  [PostType.SkillGuardianTower] = Decode_SkillGuardianTower,
  [PostType.GoddessMummy] = Decode_GoddessMummy,
  [PostType.HelpMeAttackCityStronghold] = Decode_HelpMeAttackCityStronghold,
  [PostType.ALLIANCE_INVITE_FRIEND] = Decode_AllianceAllyNotify,
  [PostType.ALLIANCE_ASSISTANCE_FRIEND] = Decode_AllianceAllyAssistanceNotify,
  [PostType.CityBeDeclareWar] = Decode_CityBeDeclareWar,
  [PostType.CityAttachmentConvert] = Decode_CityAttachmentConvert,
  [PostType.CityAttachmentBuildStart] = Decode_CityAttachmentBuildStart,
  [PostType.CityAttachmentBuildFinish] = Decode_CityAttachmentBuildFinish,
  [PostType.SuppliesPositionShare] = Decode_PointShare,
  [PostType.HELP_STOP_FIRE] = Decode_PointShare,
  [PostType.TorchRelayCheer] = Decode_TorchRelayCheer,
  [PostType.GHOST_RECON_TASK_TEAM] = Decode_GhostReconTaskTeam,
  [PostType.GHOST_RECON_SHARE_POINT] = Decode_PointShare,
  [PostType.Chat_Stickers] = Decode_Stickers,
  [PostType.Chat_SendPhoto] = Decode_SendPhoto,
  [PostType.HELP_STOP_FIRE_PERSION] = Decode_HelpStopFirePerson,
  [PostType.HELP_STOP_FIRE_ALLIANCEE] = Decode_HelpStopFireAlliance,
  [PostType.SeasonTrendsShare] = Decode_ASeasonTrendsShare,
  [PostType.GHOST_RECON_REMIND_LEADER] = Decode_GhostReconRemindLeader,
  [PostType.ActMigration] = Decode_ActMigration,
  [PostType.MessageRecall] = Decode_MessageRecall,
  [PostType.MONSTER_INVASION_BIG_BOSS] = Decode_InvasionBigBossSummon,
  [PostType.SKILL_ADD_MUMMY_ARMY] = Decode_SkillAddMummyArmy,
  [PostType.STAGE_FEATURE_CHAPTER] = Decode_Stage_Feature_Chapter,
  [PostType.DiggingGameShareSingle] = Decode_DiggingGameShare,
  [PostType.DiggingGameShareAlliance] = Decode_DiggingGameShare,
  [PostType.SeasonTradeShopRefresh] = Decode_SeasonTradeShopRefresh,
  [PostType.CaptureHugeSandWorm] = Decode_CaptureHugeSandWorm,
  [PostType.MONSTER_INVASION_BOSS_SELF_PROTECTED] = Decode_PointShare,
  [PostType.INVASION_BOSS_SHARE] = Decode_PointShare,
  [PostType.TradeOpenLevel] = Decode_SeasonTradeBattleStart,
  [PostType.OccupyTradePlayer] = Decode_SeasonTradeLordChange,
  [PostType.MIGRATE_INVITE] = Decode_AllianceInvite,
  [PostType.GiftGiving] = Decode_GiftGiving,
  [PostType.ValentineRankCard] = Decode_ValentineRankCard,
  [PostType.ZONE_MOBILIZATION_AL_RES_CREATE] = Decode_ZoneMobilizationAlRes,
  [PostType.ZONE_MOBILIZATION_SUPPLIES_CREATE] = Decode_ZoneMobilizationSupplies,
  [PostType.ZONE_MOBILIZATION_SUPPLIES_TRIGGER_RED] = Decode_ZoneMobilizationSuppliesRed,
  [PostType.ZOMBIE_RUSH_ELITE_ALTER_BOSS_REWARD] = Decode_ZombieRushEliteAlterBossReward,
  [PostType.ZOMBIE_RUSH_ELITE_BOSS_ATTACK] = Decode_ZombieRushAttack,
  [PostType.MAD_COW_RUSH] = Decode_MadCowRush,
  [PostType.ZOMBIE_RUSH_ELITE_ALTER_BOSS_ATTACK] = Decode_ZombieRushEliteAlterBossAttack,
  [PostType.SeasonPhoto] = Decode_SeasonPhoto,
  [PostType.Title] = Decode_Title,
  [PostType.UseMasterySkill] = Decode_UseMasterySkill,
  [PostType.EasterEggChat] = Decode_EasterEggChat,
  [PostType.DigTreasure] = Decode_DigTreasure,
  [PostType.TrainVipInvite] = Decode_TrainVipInvite,
  [PostType.ALLIANCE_MONSTER_CHALLENGE_NEW_REWARD] = Decode_KillZombieBoxShare,
  [PostType.ALLIANCE_MONSTER_CHALLENGE_NEW_BATTLE] = Decode_KillZombieStartChallenge,
  [PostType.TacticalCard] = Decode_TacticalCardShare,
  [PostType.TacticalCard_Deck] = Decode_TacticalCardDeckShare,
  [PostType.TacticalCard_EquipPlan] = Decode_TacticalCardDeckShare,
  [PostType.Electrician_Gather] = Decode_Electrician_Gather,
  [PostType.CityBattleBuffRefresh] = Decode_CityBattleBuffRefresh,
  [PostType.GroupChatInviter] = Decode_GroupChatInviter,
  [PostType.ActConcertReward] = Decode_ActConcertRewardShare,
  [PostType.MusicFestival2025_Share] = Decode_MusicFestival2025_ScoreRank,
  [PostType.FIREWORK_GIFT_REWARD] = Decode_FireworkReward,
  [PostType.FIREWORK_GIFT_REWARD_DOUBLE] = Decode_FireworkRewardDouble,
  [PostType.BloodyQueenBattleStart] = Decode_BloodyQueenBattleStart,
  [PostType.BloodyQueenBattleGunnerLastBlood] = Decode_BloodyQueenBattleGunnerLastBlood,
  [PostType.FirstJoinAlliance] = Decode_FirstJoinAlliance,
  [PostType.NewBattleReportShare] = Decode_Text_FightReport,
  [PostType.OffSeasonDiggingGameShareAlliance] = Decode_OffSeasonDiggingGameShare,
  [PostType.SeasonBankReport] = Decode_BankReport,
  [PostType.SurfingInviteShare] = Decode_SurfingInviteAllyShare,
  [PostType.SurfingBattleResultShare] = Decode_SurfingBattleResultShare,
  [PostType.T11IdleGameAllianceHelp] = Decode_PostT11IdleGameAllianceHelp,
  [PostType.FLOWER_TRAIN_SHARE] = Decode_FlowerTrainShare,
  [PostType.FLOWER_TRAIN_POSITION_SHARE] = Decode_FlowerTrainPositionShare,
  [PostType.FLOWER_TRAIN_USE_SHARE] = Decode_FlowerTrainUseShare,
  [PostType.SummonWeather] = Decode_SummonWeather,
  [PostType.Alliance_Feature_Invite] = Decode_PostAlliance_Feature_Invite,
  [PostType.Season_BiuBiuInvite] = Decode_Season_BiuBiuInvite,
  [PostType.ALLIANCE_CONGRATULATION] = Decode_PostAllianceCongratulation,
  [PostType.NewsCenterLink] = Decode_NewsCenterLink,
  [PostType.Season_BiuBiuResult] = Decode_Season_BiuBiuResult,
  [PostType.ZOMBIE_ATTACK_CITY_ASSISTANCE_DEFEND] = Decode_ZombieAttackCityAssistanceDefend,
  [PostType.StageFeatureHelpInvite] = Decode_Stage_Feature_Help_Invite,
  [PostType.StageFeatureHelpAccept] = Decode_Stage_Feature_Help_Invite,
  [PostType.StageFeatureComplete] = Decode_Stage_Feature_Help_Invite,
  [PostType.StageFeatureHelpInviteAlliance] = Decode_Stage_Feature_Help_Invite,
  [PostType.BF_WINTER_HISTORY_SHARE] = Decode_BF_Winter_History_Share,
  [PostType.GhostBattleResultShare] = Decode_GhostBattleResultShare,
  [PostType.GhostParkourRecordType] = Decode_GhostParkourRecordShare,
  [PostType.MilitaryPayShare] = Decode_MilitaryPayShare,
  [PostType.FrontBreakSunday] = Decode_FrontBreakSundayRank,
  [PostType.WorldBossNewRecord] = Decode_WorldBossNewRecordShare,
  [PostType.ALLIANCE_INVITE_SHARE_NEW] = Decode_AllianceInvite,
  [PostType.Season_LittleGame_Invite] = Decode_Season_GGGoShare,
  [PostType.Season_LittleGame_Result] = Decode_Season_LittleGame_Result,
  [PostType.ALLIANCE_SKILL_TESLACOIL_TIP] = Decode_AllianceTeslaCoil,
  [PostType.ALLIANCE_SKILL_ABUNDANT_HARVEST_TIP] = Decode_AllianceAbundantHarvest,
  [PostType.ALLIANCE_SKILL_REINFORCEMENT_TIP] = Decode_AllianceReinforcement,
  [PostType.ALLIANCE_SKILL_REFRESH_BALL_TIP] = Decode_AllianceRefreshBall,
  [PostType.ALLIANCE_LUCK_SIPHON_BUFF] = Decode_BestReward,
  [PostType.ALLIANCE_LUCK_SIPHON_NORMAL] = Decode_Alliance_Lucky_Siphon,
  [PostType.SeasonCampDestroyCity] = Decode_SeasonCampDestroyCity,
  [PostType.SeasonOccupyAltar] = Decode_SeasonOccupyAltar,
  [PostType.S0_ALLIANCE_BOSS_GIFT_REWARD] = Decode_S0AllianceBossReward
}

function ShareDecode.Decode(chatData, param, isFullMsg)
  local f = DecodeTable[chatData.post]
  local showMessage, isAwait, isSkipCheckEmpty
  if f then
    showMessage, isAwait, isSkipCheckEmpty = f(chatData, param, isFullMsg)
  else
    ChatPrint("share decode not found! type : " .. chatData.post)
  end
  if isSkipCheckEmpty ~= true and string.IsNullOrEmpty(showMessage) then
    showMessage = Localization:GetString("120035")
    local postId = "PostType:" .. chatData.post
    print(">>>\231\137\136\230\156\172\228\184\141\230\148\175\230\140\129: " .. tostring(postId))
  end
  return showMessage, isAwait
end

return ShareDecode
