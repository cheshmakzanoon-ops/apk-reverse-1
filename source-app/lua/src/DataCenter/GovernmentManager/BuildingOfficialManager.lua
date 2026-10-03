local BuildingOfficialManager = BaseClass("BuildingOfficialManager")
local KingdomPositionInfo = require("DataCenter.GovernmentManager.KingdomPositionInfo")
local PresidentInfo = require("DataCenter.GovernmentManager.PresidentInfo")
local BuildingOfficialHistoryRecord = require("DataCenter.GovernmentManager.BuildingOfficialHistoryRecord")
local PresidentPresentInfo = require("DataCenter.GovernmentManager.PresidentPresentInfo")
local PresentRecordInfo = require("DataCenter.GovernmentManager.PresentRecordInfo")
local Localization = CS.GameEntry.Localization

function BuildingOfficialManager:__init()
  self.rewardInfo = {}
  self.rewardRecord = {}
  self.officialHistory = {}
  self.official = {}
  self.leader = {}
  self.building = {}
  self.myPositionIdList = {}
  self.ownerAllianceId = {}
end

function BuildingOfficialManager:__delete()
  self.rewardInfo = {}
  self.rewardRecord = {}
  self.officialHistory = {}
  self.myPositionIdList = {}
  self.official = {}
  self.leader = {}
  self.building = {}
end

function BuildingOfficialManager:InitData(msg)
  self:InitSelfPosition(msg)
end

function BuildingOfficialManager:InitSelfPosition(message)
  self.myPositionIdList = {}
  if message.buildingPosition and message.buildingPosition.positions then
    self.myPositionIdList = message.buildingPosition.positions
  end
  if message.centerPresidentMailInfo and message.centerPresidentMailInfo.nextCost then
    self.mailCost = message.centerPresidentMailInfo.nextCost
  end
end

function BuildingOfficialManager:GetMyBuildingPositions()
  return self.myPositionIdList
end

function BuildingOfficialManager:GetEightMailCost()
  if not self.mailCost then
    self.mailCost = LuaEntry.DataConfig:TryGetNum("center_president_mail", "k3", 1600)
  end
  return self.mailCost
end

function BuildingOfficialManager:SetEightMailCost(message)
  if message.centerPresidentMailInfo and message.centerPresidentMailInfo.nextCost then
    self.mailCost = message.centerPresidentMailInfo.nextCost
  end
end

function BuildingOfficialManager:GetAllPositionInfosByUID(uid)
  local ret = {}
  local serverOfficialInfo = DataCenter.GovernmentManager:GetPositionInfoByUID(uid)
  if serverOfficialInfo then
    table.insert(ret, serverOfficialInfo)
  end
  if SeasonUtil.InSeasonBigMapMode() then
    for serverId, server in pairs(self.official) do
      for buildingId, building in pairs(server) do
        for positionId, info in pairs(building) do
          if info and info.uid == uid then
            table.insert(ret, info)
          end
        end
      end
    end
    if 1 < #ret then
      local id2Order = DataCenter.GovernmentTemplateManager:GetUniqueOrder()
      table.sort(ret, function(a, b)
        return id2Order[a.template.id] < id2Order[b.template.id]
      end)
    end
  end
  return ret
end

function BuildingOfficialManager:TryKingdomPositionAppoint(serverId, buildingId, config, info, successCallback)
  if not LuaEntry.Player:IsDeepLeader(serverId, buildingId) then
    if config.order == 0 then
      UIUtil.ShowTipsId(120173)
      return
    end
    local leader = DataCenter.BuildingOfficialManager:GetSurfaceLeader(serverId, buildingId)
    if leader and leader.uid == info.uid then
      UIUtil.ShowTipsId(120173)
      return
    end
  end
  local positionInfo = DataCenter.BuildingOfficialManager:GetOfficial(serverId, buildingId, config.id)
  local theName = Localization:GetString(config.name)
  local newUserId = info.uid
  local newUserName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(info.uid, info.name)
  if not string.IsNullOrEmpty(info.alAbbr) then
    newUserName = "[" .. info.alAbbr .. "] " .. newUserName
  elseif not string.IsNullOrEmpty(info.abbr) then
    newUserName = "[" .. info.abbr .. "] " .. newUserName
  elseif not string.IsNullOrEmpty(info.allianceAbbr) then
    newUserName = "[" .. info.allianceAbbr .. "] " .. newUserName
  end
  if positionInfo and positionInfo.uid ~= nil and positionInfo.uid ~= "" then
    local oldUserId = positionInfo.uid
    local oldUserName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(positionInfo.uid, positionInfo.name)
    if not string.IsNullOrEmpty(positionInfo.abbr) then
      oldUserName = "[" .. positionInfo.abbr .. "] " .. oldUserName
    end
    if info.uid == positionInfo.uid then
      local message = Localization:GetString(457032, oldUserName)
      UIUtil.ShowMessage(message, 2, "110106", "110006", function()
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonMessageTip, {anim = true, playEffect = false})
      end, function()
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonMessageTip, {anim = false, playEffect = false})
        DataCenter.BuildingOfficialManager:FetchKingdomBuildingFire(serverId, buildingId, config.id, oldUserId)
        if successCallback ~= nil and type(successCallback) == "function" then
          successCallback()
        end
      end, nil, "100378")
    else
      if positionInfo ~= nil and positionInfo:IsInAppointTimeCD() then
        UIUtil.ShowTipsId(457059)
        return
      end
      do
        local message = Localization:GetString(457030, newUserName, theName, oldUserName)
        UIUtil.ShowMessage(message, 2, "110106", "110006", function()
          UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonMessageTip, {anim = true, playEffect = false})
        end, function()
          UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonMessageTip, {anim = false, playEffect = false})
          DataCenter.BuildingOfficialManager:FetchKingdomBuildingAppoint(serverId, buildingId, config.id, newUserId)
          if successCallback ~= nil and type(successCallback) == "function" then
            successCallback()
          end
        end, nil, "100378")
      end
    end
  else
    if positionInfo ~= nil and positionInfo:IsInAppointTimeCD() then
      UIUtil.ShowTipsId(457059)
      return
    end
    local message = Localization:GetString(457031, newUserName, theName)
    UIUtil.ShowMessage(message, 2, "110106", "110006", function()
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonMessageTip, {anim = true, playEffect = false})
    end, function()
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonMessageTip, {anim = false, playEffect = false})
      DataCenter.BuildingOfficialManager:FetchKingdomBuildingAppoint(serverId, buildingId, config.id, newUserId)
      if successCallback ~= nil and type(successCallback) == "function" then
        successCallback()
      end
    end, nil, "100378")
  end
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UICommonMessageTip)
  if window ~= nil and window.View ~= nil then
    window.View.btn_1_spr = "tongyong_cfm_anniu_4"
    window.View.btn_2_spr = "tongyong_cfm_anniu_5"
    if window.View.btn_1 ~= nil then
      window.View.btn_1:LoadSprite(string.format(LoadPath.LWCommonPath, window.View.btn_1_spr))
    end
    if window.View.btn_2 ~= nil then
      window.View.btn_2:LoadSprite(string.format(LoadPath.LWCommonPath, window.View.btn_2_spr))
    end
  end
end

function BuildingOfficialManager:GetOfficialPositionBuffViewData()
  local configIds = {}
  local serverPositionId = DataCenter.GovernmentManager:GetPositionId()
  if 0 < serverPositionId then
    table.insert(configIds, serverPositionId)
  end
  for _, v in ipairs(self.myPositionIdList) do
    table.insert(configIds, v.positionId)
  end
  local ret = {}
  for _, positionId in ipairs(configIds) do
    local configData = DataCenter.GovernmentTemplateManager:GetTemplate(positionId)
    if configData ~= nil then
      local statusLineData = DataCenter.StatusManager:GetTemplate(configData.status_id)
      if statusLineData ~= nil then
        local buffViewData = {}
        buffViewData.id = tonumber(configData.status_id)
        buffViewData.name = Localization:GetString(statusLineData.name)
        buffViewData.icon = statusLineData.icon
        buffViewData.desc = ""
        local descArr = string.split(statusLineData.description, "|") or {}
        if table.count(descArr) == 2 then
          local isConqueror = DataCenter.GovernmentManager:IsConqueror(LuaEntry.Player:GetSourceServerId())
          buffViewData.desc = isConqueror and descArr[2] or descArr[1]
        elseif descArr[1] then
          buffViewData.desc = descArr[1]
        end
        buffViewData.showEffectPath = UIAssets.OfficialPositionBuffEffectPath
        buffViewData.effectScale = 0.6
        local buffs = DataCenter.GovernmentManager:GetEffectBuffs(configData.id, LuaEntry.Player:GetSourceServerId())
        local descParam = {}
        for i = 1, table.count(buffs) do
          local buff = buffs[i]
          local buffDesParam = ""
          if buff.effectId == 93000 then
            buffDesParam = Localization:GetString(buff.effectName)
          else
            buffDesParam = Localization:GetString(buff.effectName) .. buff.buffAddNum
          end
          table.insert(descParam, buffDesParam)
        end
        if 0 < table.count(descParam) and buffViewData.desc ~= "" then
          buffViewData.desc = Localization:GetString(buffViewData.desc, table.unpack(descParam))
        end
        if configData.supreme_president_power then
          buffViewData.desc = string.format("%s, %s", buffViewData.desc, Localization:GetString("supreme_president_ui_25_limit_12"))
        end
        buffViewData.isOfficialPositionBuff = true
        table.insert(ret, buffViewData)
      end
    end
  end
  return ret
end

function BuildingOfficialManager:FetchKingdomBuildingPositionList(serverId, buildingId)
  SFSNetwork.SendMessage(MsgDefines.KingdomBuildingPositionList, buildingId, serverId)
end

function BuildingOfficialManager:HandleOfficialList(msg)
  if not msg.serverId or not msg.buildingId then
    return
  end
  if not self.building[msg.serverId] then
    self.building[msg.serverId] = {}
  end
  if not self.building[msg.serverId][msg.buildingId] then
    self.building[msg.serverId][msg.buildingId] = {}
  end
  self.building[msg.serverId][msg.buildingId].autoReject = msg.autoReject
  local positions = msg.positions or {}
  if not self.official[msg.serverId] then
    self.official[msg.serverId] = {}
  end
  local building = self.official[msg.serverId][msg.buildingId]
  if building then
    for _, positionInfo in pairs(building) do
      positionInfo:Delete()
    end
  end
  building = {}
  self.official[msg.serverId][msg.buildingId] = building
  for _, position in ipairs(positions) do
    local positionId = toInt(position.positionId)
    building[positionId] = KingdomPositionInfo.New()
    building[positionId]:ParseBuildingOfficialData(position)
    if DataCenter.GovernmentTemplateManager:IsLeader(positionId) then
      if not self.leader[msg.serverId] then
        self.leader[msg.serverId] = {}
      end
      self.leader[msg.serverId][msg.buildingId] = building[positionId]
    end
  end
  EventManager:GetInstance():Broadcast(EventId.KingdomBuildingPositionList, msg.serverId, msg.buildingId)
  EventManager:GetInstance():Broadcast(EventId.BuildingOfficialAutoRejectRefresh, msg.serverId, msg.buildingId)
end

function BuildingOfficialManager:HandleSetAutoReject(msg)
  if not self.building[msg.serverId] then
    self.building[msg.serverId] = {}
  end
  if not self.building[msg.serverId][msg.buildingId] then
    self.building[msg.serverId][msg.buildingId] = {}
  end
  self.building[msg.serverId][msg.buildingId].autoReject = msg.autoReject
  if msg.autoReject then
    UIUtil.ShowTipsId("outpost_commander_tips_27")
  else
    UIUtil.ShowTipsId("outpost_commander_tips_28")
  end
  EventManager:GetInstance():Broadcast(EventId.BuildingOfficialAutoRejectRefresh, msg.serverId, msg.buildingId)
end

function BuildingOfficialManager:GetBuilding(serverId, buildingId)
  if self.building[serverId] then
    return self.building[serverId][buildingId]
  end
end

function BuildingOfficialManager:FetchKingdomBuildingAppoint(serverId, buildingId, positionId, targetUid)
  SFSNetwork.SendMessage(MsgDefines.KingdomBuildingAppoint, targetUid, buildingId, positionId, serverId)
end

function BuildingOfficialManager:HandleBuildingAppoint(msg)
  self:FetchKingdomBuildingPositionList(msg.serverId, msg.buildingId)
end

function BuildingOfficialManager:FetchKingdomBuildingFire(serverId, buildingId, positionId, targetUid)
  SFSNetwork.SendMessage(MsgDefines.KingdomBuildingFire, targetUid, buildingId, positionId, serverId)
end

function BuildingOfficialManager:HandleBuildingFire(msg)
  local positionId = toInt(msg.positionId)
  if not self.official[msg.serverId] then
    self.official[msg.serverId] = {}
  end
  if not self.official[msg.serverId][msg.buildingId] then
    self.official[msg.serverId][msg.buildingId] = {}
  end
  if self.official[msg.serverId][msg.buildingId][positionId] then
    self.official[msg.serverId][msg.buildingId][positionId]:Deposition()
  end
  EventManager:GetInstance():Broadcast(EventId.KingdomBuildingPositionList, msg.serverId, msg.buildingId)
end

function BuildingOfficialManager:FetchKingdomBuildingPositionRecord(serverId, buildingId, positionId)
  SFSNetwork.SendMessage(MsgDefines.KingdomBuildingPositionRecord, serverId, buildingId, positionId)
end

function BuildingOfficialManager:HandleBuildingPositionRecord(msg)
  if not msg.records or #msg.records <= 0 then
    return
  end
  local serverId = msg.records[1].serverId
  local buildingId = msg.records[1].buildingId
  local positionId = toInt(msg.records[1].positionId)
  if not self.officialHistory[serverId] then
    self.officialHistory[serverId] = {}
  end
  if not self.officialHistory[serverId][buildingId] then
    self.officialHistory[serverId][buildingId] = {}
  end
  local historyList = self.officialHistory[serverId][buildingId][positionId]
  if historyList then
    for _, his in pairs(historyList) do
      his:Delete()
    end
  end
  historyList = {}
  self.officialHistory[serverId][buildingId][positionId] = historyList
  local recordsCount = #msg.records
  for i, record in ipairs(msg.records) do
    if 0 < record.fireTime or i == recordsCount then
      local positionInfo = BuildingOfficialHistoryRecord.New()
      positionInfo:ParseData(record)
      table.insert(historyList, positionInfo)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.KingdomBuildingPositionHistory, serverId, buildingId, positionId)
end

function BuildingOfficialManager:FetchKingdomBuildingGetPresentInfo(group, serverId, buildingId)
  SFSNetwork.SendMessage(MsgDefines.KingdomBuildingGetPresentInfo, group, buildingId, serverId)
end

function BuildingOfficialManager:HandleBuildingGetPresentInfo(msg)
  if not self.rewardInfo[msg.serverId] then
    self.rewardInfo[msg.serverId] = {}
  end
  if self.rewardInfo[msg.serverId][msg.buildingId] then
    self.rewardInfo[msg.serverId][msg.buildingId]:Delete()
  else
    self.rewardInfo[msg.serverId][msg.buildingId] = PresidentPresentInfo.New()
  end
  self.rewardInfo[msg.serverId][msg.buildingId]:ParseData(msg)
  EventManager:GetInstance():Broadcast(EventId.KingdomBuildingPositionRewardUpdate, msg.serverId, msg.buildingId)
end

function BuildingOfficialManager:FetchKingdomBuildingSendPresent(groupId, serverId, buildingId, presentId, targetUidArr)
  SFSNetwork.SendMessage(MsgDefines.KingdomBuildingSendPresent, targetUidArr, groupId, buildingId, presentId, serverId)
end

function BuildingOfficialManager:HandleBuildingSendPresent(msg)
  if not self.rewardInfo[msg.serverId] then
    self.rewardInfo[msg.serverId] = {}
  end
  if not self.rewardInfo[msg.serverId][msg.buildingId] then
    self.rewardInfo[msg.serverId][msg.buildingId] = PresidentPresentInfo.New()
  end
  self.rewardInfo[msg.serverId][msg.buildingId]:RefreshUidArr(msg)
  UIUtil.ShowTipsId(457089)
  EventManager:GetInstance():Broadcast(EventId.KingdomBuildingPositionRewardUpdate, msg.serverId, msg.buildingId)
end

function BuildingOfficialManager:FetchKingdomBuildingGetPresentRecord(groupId, serverId, buildingId)
  SFSNetwork.SendMessage(MsgDefines.KingdomBuildingGetPresentRecord, groupId, buildingId, serverId)
end

function BuildingOfficialManager:HandleBuildingGetPresentRecord(msg)
  if not self.rewardRecord[msg.serverId] then
    self.rewardRecord[msg.serverId] = {}
  end
  if self.rewardRecord[msg.serverId][msg.buildingId] then
    self.rewardRecord[msg.serverId][msg.buildingId]:Delete()
  else
    self.rewardRecord[msg.serverId][msg.buildingId] = PresentRecordInfo.New()
  end
  self.rewardRecord[msg.serverId][msg.buildingId]:ParseData(msg)
  EventManager:GetInstance():Broadcast(EventId.KingdomBuildingPositionRewardHistory, msg.serverId, msg.buildingId)
end

function BuildingOfficialManager:HandlePushBuildingPositionUpdate(msg)
  ChatManager2:GetInstance().User:ForcePullMyUserInfoFromNet()
  self:InitSelfPosition(msg)
  EventManager:GetInstance():Broadcast(EventId.MyPositionRefresh)
end

function BuildingOfficialManager:FetchKingdomBuildingPositionDeclarationUpdate(serverId, buildingId, declaration)
  SFSNetwork.SendMessage(MsgDefines.KingdomBuildingPositionDeclarationUpdate, serverId, buildingId, declaration)
end

function BuildingOfficialManager:HandleDeclarationUpdate(msg)
  if self.leader[msg.serverId] and self.leader[msg.serverId][msg.buildingId] then
    self.leader[msg.serverId][msg.buildingId]:SetDeclaration(msg.declaration)
    UIUtil.ShowTipsId(120094)
    EventManager:GetInstance():Broadcast(EventId.KingdomBuildingPositionDeclarationUpdate, msg.serverId, msg.buildingId)
  end
end

function BuildingOfficialManager:GetOfficial(serverId, buildingId, positionId)
  if not serverId then
    return self.official
  elseif not buildingId then
    return self.official[serverId]
  elseif not positionId and self.official[serverId] then
    return self.official[serverId][buildingId]
  end
  if self.official[serverId] and self.official[serverId][buildingId] then
    return self.official[serverId][buildingId][toInt(positionId)]
  end
end

function BuildingOfficialManager:GetSurfaceLeader(serverId, buildingId)
  local curPresident
  if self.leader[serverId] then
    curPresident = self.leader[serverId][buildingId]
  end
  return curPresident
end

function BuildingOfficialManager:ImVicePresident(serverId, buildingId)
  local vicePresidents = DataCenter.GovernmentTemplateManager:GetVicePresidents()
  for _, v in pairs(self.myPositionIdList) do
    if v.serverId == serverId and v.buildingId == buildingId then
      for _, presidentMeta in pairs(vicePresidents) do
        if presidentMeta.id == toInt(v.positionId) then
          return true
        end
      end
    end
  end
  return false
end

function BuildingOfficialManager:GetBuildingAllianceId(serverId, buildingId)
  if self.ownerAllianceId[serverId] then
    return self.ownerAllianceId[serverId][buildingId]
  end
end

function BuildingOfficialManager:GetOfficialHistory(serverId, buildingId, positionId)
  if self.officialHistory[serverId] and self.officialHistory[serverId][buildingId] then
    return self.officialHistory[serverId][buildingId][toInt(positionId)]
  end
end

function BuildingOfficialManager:GetRewardRecord(serverId, buildingId)
  if self.rewardRecord[serverId] then
    return self.rewardRecord[serverId][buildingId]
  end
end

function BuildingOfficialManager:GetRewardInfo(serverId, buildingId)
  if self.rewardInfo[serverId] then
    return self.rewardInfo[serverId][buildingId]
  end
end

function BuildingOfficialManager:IsGetReward(serverId, buildingId, uid)
  local presidentPresentInfo = self:GetRewardInfo(serverId, buildingId)
  if presidentPresentInfo then
    return presidentPresentInfo:IsGetReward(uid)
  end
  return false
end

function BuildingOfficialManager:GetPresentByRewardType(rewardType, serverId, buildingId)
  local presidentPresentInfo = self:GetRewardInfo(serverId, buildingId)
  if presidentPresentInfo then
    return presidentPresentInfo:GetPresentByRewardType(rewardType)
  end
  return nil
end

function BuildingOfficialManager:SetOwnerAllianceId(serverId, buildingId, ownerAllianceId)
  if not self.ownerAllianceId[serverId] then
    self.ownerAllianceId[serverId] = {}
  end
  self.ownerAllianceId[serverId][buildingId] = ownerAllianceId
end

return BuildingOfficialManager
