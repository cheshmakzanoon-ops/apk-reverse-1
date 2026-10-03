local SeasonWorldColorTemplate = BaseClass("SeasonWorldColorTemplate")
local ColorTypeForPlayer = {
  PlayerDeclareWar = 1,
  PlayerAllianceEnemy = 2,
  PlayerSeasonCampEnemy = 3,
  PlayerZoneEnemy = 4,
  PlayerOther = 5,
  PlayerSeasonSameServer = 6,
  PlayerSeasonSameCamp = 7,
  PlayerSeasonAssist = 8,
  PlayerSameAlliance = 9,
  PlayerAllianceLeader = 10,
  PlayerSelf = 11
}
local ColorType2PlayerType = {
  CS.PlayerType.PlayerAllianceEnemy,
  CS.PlayerType.PlayerZoneEnemy,
  CS.PlayerType.PlayerSeasonEnemy,
  CS.PlayerType.PlayerOther,
  CS.PlayerType.PlayerSeasonCamp,
  CS.PlayerType.PlayerSeasonAssist,
  CS.PlayerType.PlayerAlliance,
  CS.PlayerType.PlayerAllianceLeader,
  CS.PlayerType.PlayerSelf
}

function SeasonWorldColorTemplate:__init(id, world_chess_group, chess_type, chess_name, info)
  self.id = id
  self.group = world_chess_group
  self.chess_type = chess_type
  self.chess_name = chess_name
  self.color_type = info:getIntValue("color_type", 0)
  self.color_weight = info:getIntValue("color_weight", id)
  self.color_help_weight = info:getIntValue("color_help_weight", id)
  self.chess_icon = info:getValue("chess_icon")
  self.small_chess_icon = info:getValue("small_chess_icon")
  self.scout_icon = info:getValue("scout_icon")
  self.troop_icon = info:getValue("troop_icon")
  self.assembly_icon = info:getValue("assembly_icon")
  self.color_help_icon = info:getValue("color_help_icon")
  self.color_help = info:getValue("color_help")
  local name_color = info:getValue("base_name_color")
  if name_color then
    local color_list = string.split_ss_array(tostring(name_color), ";")
    local r = tonumber(color_list[1]) or 0
    local g = tonumber(color_list[2]) or 0
    local b = tonumber(color_list[3]) or 0
    local a = tonumber(color_list[4]) or 255
    self.name_color = Color.New(r / 255, g / 255, b / 255, a / 255)
  end
  local troop_pin_color = info:getValue("troop_pin_color", name_color)
  if troop_pin_color == name_color then
    self.troop_pin_color = self.name_color
  elseif troop_pin_color then
    local color_list = string.split_ss_array(tostring(troop_pin_color), ";")
    local r = tonumber(color_list[1]) or 0
    local g = tonumber(color_list[2]) or 0
    local b = tonumber(color_list[3]) or 0
    local a = tonumber(color_list[4]) or 255
    self.troop_pin_color = Color.New(r / 255, g / 255, b / 255, a / 255)
  end
end

function SeasonWorldColorTemplate:Match(serverId, allianceId, uid, currentServerId)
  local chess_type = self.chess_type
  if uid ~= nil and uid ~= "" and LuaEntry.Player.uid == uid then
    return chess_type == ColorTypeForPlayer.PlayerSelf
  end
  if allianceId ~= nil and allianceId ~= "" then
    local myAllianceId = LuaEntry.Player.allianceId
    if myAllianceId == allianceId then
      local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      if chess_type == ColorTypeForPlayer.PlayerSameAlliance then
        return true
      elseif chess_type == ColorTypeForPlayer.PlayerAllianceLeader and baseData ~= nil and uid == baseData.leaderUid then
        return true
      end
    end
    local isMyFriendAlly = DataCenter.SeasonAllyFriendManager:IsMyFriendAlly(allianceId)
    if isMyFriendAlly then
      if chess_type == ColorTypeForPlayer.PlayerSeasonAssist then
        return true
      end
    elseif chess_type == ColorTypeForPlayer.PlayerDeclareWar and myAllianceId ~= allianceId then
      local declareInfo = DataCenter.AllianceDeclareWarManager:GetSelfDeclareWarData()
      if declareInfo then
        local cityInfo = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(toInt(declareInfo.content), toInt(declareInfo.serverId))
        if cityInfo ~= nil and (cityInfo.aId == allianceId or cityInfo.allianceId == allianceId) then
          return true
        end
      end
      local dataList = DataCenter.AllianceDeclareWarManager:GetSelfBeDeclareWarData()
      if dataList then
        for k, v in pairs(dataList) do
          if v and (v.aId == allianceId or v.allianceId == allianceId) then
            return true
          end
        end
      end
      local dict = DataCenter.AllianceWarEventDataManager:GetWarEventsDict()
      for _, v in pairs(dict) do
        if v and v.IsAllianceJoin and v:IsAllianceJoin(allianceId) and v:IsMyAllianceJoined() then
          return true
        end
      end
    end
  end
  if serverId ~= nil and serverId ~= "" and serverId ~= 0 and serverId ~= -1 and serverId == LuaEntry.Player:GetSourceServerId() and chess_type == ColorTypeForPlayer.PlayerSeasonSameServer then
    return true
  end
  local thePlayerType = CSharpCallLuaInterface.IsMyEnemy(serverId, allianceId, currentServerId)
  if chess_type == ColorTypeForPlayer.PlayerAllianceEnemy then
    return thePlayerType == CS.PlayerType.PlayerAllianceEnemy
  elseif chess_type == ColorTypeForPlayer.PlayerZoneEnemy then
    return thePlayerType == CS.PlayerType.PlayerZoneEnemy
  elseif chess_type == ColorTypeForPlayer.PlayerSeasonSameCamp then
    return thePlayerType == CS.PlayerType.PlayerSeasonCamp
  elseif chess_type == ColorTypeForPlayer.PlayerSeasonAssist then
    return thePlayerType == CS.PlayerType.PlayerSeasonAssist
  elseif chess_type == ColorTypeForPlayer.PlayerSeasonCampEnemy then
    return thePlayerType == CS.PlayerType.PlayerSeasonEnemy
  elseif chess_type == ColorTypeForPlayer.PlayerOther then
    return true
  end
  return false
end

function SeasonWorldColorTemplate:ToPlayerType()
  local thePlayerType = ColorType2PlayerType[self.color_type]
  if thePlayerType == nil then
    return CS.PlayerType.PlayerOther
  end
  return thePlayerType
end

function SeasonWorldColorTemplate:SyncToCS()
  if self.syncFlag ~= true then
    local ConfigCache = CS.GameEntry.ConfigCache
    if ConfigCache ~= nil then
      ConfigCache:UpdateTemplateData(TableName.World_Chess_Color, self.id, self)
      self.syncFlag = true
    end
  end
end

function SeasonWorldColorTemplate:__delete()
end

return SeasonWorldColorTemplate
