local ActMigrationStarList = BaseClass("ActMigrationStarList")
local ActMigrationStarListItem = require("DataCenter.ActMigrationManager.ActMigrationStarListItem")
local ActMigrationServerData = require("DataCenter.ActMigrationManager.ActMigrationServerData")

function ActMigrationStarList:__init()
  self.starList = {}
  self.starDic = {}
  self.serverInfoDic = {}
end

function ActMigrationStarList:__delete()
  self.starList = nil
  self.starDic = nil
  self.serverInfoDic = nil
end

function ActMigrationStarList:ParseData(msg)
  if not msg.list then
    return
  end
  local list = msg.list
  for k, v in ipairs(list) do
    if v.servers and #v.servers > 0 then
      local starInfo = ActMigrationStarListItem.New(v)
      table.insert(self.starList, starInfo)
      self.starDic[v.id] = starInfo
    end
  end
  table.sort(self.starList, function(a, b)
    return a.id < b.id
  end)
  for k, v in ipairs(self.starList) do
    v.index = k
  end
end

function ActMigrationStarList:ParseServerData(msg)
  if not msg then
    return
  end
  local data = self.serverInfoDic[msg.serverId]
  if not data then
    data = ActMigrationServerData.New()
    self.serverInfoDic[msg.serverId] = data
  end
  data:ParseData(msg)
  return data
end

function ActMigrationStarList:GetMyStarIndex()
  return self.starList and #self.starList > 0 and 1 or 0
end

function ActMigrationStarList:GetStarInfoByIndex(index)
  return self.starList and self.starList[index]
end

function ActMigrationStarList:GetStarCount()
  return self.starList and #self.starList or 0
end

function ActMigrationStarList:TryGetServerInfo(starIndex, serverIndex)
  local star = self:GetStarInfoByIndex(starIndex)
  if not star then
    return
  end
  local serverId = star:GetServerIDByIndex(serverIndex)
  if not serverId then
    return
  end
  local serverInfo = self.serverInfoDic[serverId]
  if serverInfo then
    return serverInfo, serverId
  end
  DataCenter.ActMigrationManager:SendServerStarDetailRequest(serverId)
  return serverInfo, serverId
end

function ActMigrationStarList:Description()
  local sb = StringBuilder.New()
  sb:AppendFormatLine("count:%s", #self.starList)
  for k, v in ipairs(self.starList) do
    sb:AppendFormatLine("%s", v:Description())
  end
  return sb:ToString()
end

return ActMigrationStarList
