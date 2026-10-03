local ActMigrationServerData = BaseClass("ActMigrationServerData")
local ActMigrationPlayerData = require("DataCenter.ActMigrationManager.ActMigrationPlayerData")

function ActMigrationServerData:__init()
  self.serverId = 0
  self.serverScore = 0
  self.cfgId = ""
  self.notice = ""
  self.presidentInfo = nil
  self.firstLadyInfo = nil
  self.superLowPlayerIn = 0
  self.lowPlayerIn = 0
  self.highPlayerIn = 0
  self.playerIn = 0
  self.serverState = 0
  self.languageList = {}
  self.applyLevel = 0
  self.applyPower = 0
  self.applyAutoLevel = 0
  self.applyAutoPower = 0
  self.applyAutoSwitch = 0
  self.applyCdEndTime = 0
  self.totalFupinScore = 0
  self.curFupinScore = 0
  self.allianceList = nil
  self.honorList = nil
  self.topAllianceList = nil
  self.topPlayerList = nil
end

function ActMigrationServerData:__delete()
  self.serverId = 0
  self.serverScore = 0
  self.cfgId = ""
  self.notice = ""
  self.presidentInfo = nil
  self.firstLadyInfo = nil
  self.superLowPlayerIn = 0
  self.lowPlayerIn = 0
  self.highPlayerIn = 0
  self.playerIn = 0
  self.serverState = 0
  self.languageList = {}
  self.applyLevel = 0
  self.applyPower = 0
  self.applyAutoLevel = 0
  self.applyAutoPower = 0
  self.applyAutoSwitch = 0
  self.applyCdEndTime = 0
  self.totalFupinScore = 0
  self.curFupinScore = 0
  self.allianceList = nil
  self.honorList = nil
  self.topAllianceList = nil
  self.topPlayerList = nil
end

function ActMigrationServerData:ParseData(t)
  if t == nil then
    return
  end
  if t.serverId then
    self.serverId = t.serverId
  end
  if t.serverScore then
    self.serverScore = t.serverScore
  end
  if t.cfgId then
    self.cfgId = t.cfgId
  end
  if t.notice then
    self.notice = t.notice
  end
  local pInfo = t.presidentInfo
  if pInfo then
    if self.presidentInfo == nil then
      self.presidentInfo = ActMigrationPlayerData.New()
    end
    self.presidentInfo:ParseData(pInfo)
  end
  local peopleInfo = t.migratePeopleInfo
  if peopleInfo then
    self.superLowPlayerIn = peopleInfo.superLowPlayerIn or 0
    self.lowPlayerIn = peopleInfo.lowPlayerIn or 0
    self.highPlayerIn = peopleInfo.highPlayerIn or 0
    self.playerIn = peopleInfo.playerIn or 0
  end
  if t.serverState then
    self.serverState = t.serverState
  end
  local languageList = t.languageList
  if languageList then
    local tmpList = {}
    for _, v in pairs(languageList) do
      table.insert(tmpList, v)
    end
    self.languageList = tmpList
  end
  if t.applyLevel then
    self.applyLevel = t.applyLevel
  end
  if t.applyPower then
    self.applyPower = t.applyPower
  end
  if t.applyAutoLevel then
    self.applyAutoLevel = t.applyAutoLevel
  end
  if t.applyAutoPower then
    self.applyAutoPower = t.applyAutoPower
  end
  if t.applyAutoSwitch then
    self.applyAutoSwitch = t.applyAutoSwitch
  end
  if t.applyCdEndTime then
    self.applyCdEndTime = t.applyCdEndTime
  end
  if t.totalFupinScore ~= nil then
    self.totalFupinScore = t.totalFupinScore
  end
  if t.curFupinScore ~= nil then
    self.curFupinScore = t.curFupinScore
  end
  if t.zoneStar then
    self.zoneStar = t.zoneStar
  end
  if t.zoneStarParam then
    self.zoneStarParam = t.zoneStarParam
  end
  if t.topAlliance then
    self:UpdateDetail(t)
  end
  if t.topPlayer then
    self:UpdatePlayers(t.topPlayer)
  end
end

function ActMigrationServerData:IsFupin()
  return self.totalFupinScore and self.totalFupinScore > 0
end

function ActMigrationServerData:CloneSetting()
  local t = {
    notice = self.notice,
    languageList = {},
    applyLevel = self.applyLevel,
    applyPower = self.applyPower,
    applyAutoLevel = self.applyAutoLevel,
    applyAutoPower = self.applyAutoPower,
    applyAutoSwitch = self.applyAutoSwitch
  }
  table.insertto(t.languageList, self.languageList)
  return t
end

function ActMigrationServerData:UpdatePlayers(array)
  if not array then
    return
  end
  local tmpList = {}
  for _, v in ipairs(array) do
    table.insert(tmpList, {
      uid = v.uid,
      srcServer = v.srcServer,
      pic = v.pic,
      picVer = v.picVer,
      headSkinId = v.headSkinId,
      name = v.name,
      abbr = v.abbr,
      power = v.power
    })
  end
  self.topPlayerList = tmpList
end

function ActMigrationServerData:UpdateDetail(t)
  if t == nil then
    return
  end
  local aList = t.allianceList
  if aList then
    local tmpList = {}
    for _, v in pairs(aList) do
      table.insert(tmpList, {
        uid = v.uid,
        icon = v.icon,
        rank = v.rank,
        name = v.name,
        abbr = v.abbr,
        language = v.language
      })
    end
    self.allianceList = tmpList
  end
  aList = t.topAlliance
  if aList then
    local tmpList = {}
    for _, v in pairs(aList) do
      table.insert(tmpList, {
        uid = v.uid,
        icon = v.icon,
        rank = v.rank,
        name = v.name,
        abbr = v.abbr,
        language = v.language
      })
    end
    self.topAllianceList = tmpList
  end
  local hList = t.honorList
  if hList then
    local tmpList = {}
    for _, v in pairs(hList) do
      table.insert(tmpList, {
        id = v.honorId,
        param = v.param
      })
    end
    self.honorList = tmpList
  end
end

return ActMigrationServerData
