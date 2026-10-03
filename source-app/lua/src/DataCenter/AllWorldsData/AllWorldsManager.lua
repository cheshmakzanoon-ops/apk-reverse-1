local AllWorldsManager = BaseClass("AllWorldsManager")
local ServerListInfo = require("DataCenter.AllWorldsData.ServerListInfo")

function AllWorldsManager:__init()
  self.serverList = {}
end

function AllWorldsManager:GetServerListInfo(id)
  return self.serverList[id]
end

function AllWorldsManager:onServerList(message)
  if message == nil then
    return
  end
  local info = ServerListInfo.New()
  info:initFromNet(message)
  if info.serverId > 0 then
    self.serverList[info.serverId] = info
  end
end

return AllWorldsManager
