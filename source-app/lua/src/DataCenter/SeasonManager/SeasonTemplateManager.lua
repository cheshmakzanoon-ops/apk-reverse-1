local SeasonTemplateManager = BaseClass("SeasonTemplateManager")
local SeasonTemplateData = require("DataCenter.SeasonManager.SeasonTemplateData")

function SeasonTemplateManager:__init()
  self.map = nil
  self.all = nil
end

function SeasonTemplateManager:__delete()
end

function SeasonTemplateManager:Startup()
end

function SeasonTemplateManager:GetConfigData(configId)
  if self.map == nil then
    self.map = {}
  end
  if not self.map[configId] then
    local config = LocalController:instance():getLine(TableName.LW_Season, configId)
    if config then
      local serverDate = os.date("!*t", math.modf(UITimeManager:GetInstance():GetServerTime() / 1000))
      local serverTime = SafeLocalOsTime(serverDate)
      local meta = SeasonTemplateData.New()
      meta:InitData(config, serverDate, serverTime)
      self.map[configId] = meta
    else
      return nil
    end
  end
  return self.map[configId]
end

function SeasonTemplateManager:GetConfigDataByServerId(serverId)
  if serverId == nil or serverId == 0 or serverId == "" then
    return nil
  end
  if self.all == nil then
    local all = {}
    local serverDate = os.date("!*t", math.modf(UITimeManager:GetInstance():GetServerTime() / 1000))
    local serverTime = SafeLocalOsTime(serverDate)
    if ChatInterface.isDebug() or ChatInterface.isPressureTestURL() then
      LocalController:instance():visitTable(TableName.LW_Season, function(id, lineData)
        if lineData == nil or lineData["local"] == "close" or tostring(lineData.is_close) ~= "0" then
          return
        end
        local meta = SeasonTemplateData.New()
        meta:InitData(lineData, serverDate, serverTime)
        if meta.isAlive and meta.start_time ~= nil then
          all[id] = meta
        end
      end)
    else
      LocalController:instance():visitTable(TableName.LW_Season, function(id, lineData)
        if lineData == nil or lineData.online == "close" or tostring(lineData.is_close) ~= "0" then
          return
        end
        local meta = SeasonTemplateData.New()
        meta:InitData(lineData, serverDate, serverTime)
        if meta.isAlive and meta.start_time ~= nil then
          all[id] = meta
        end
      end)
    end
    self.all = all
  end
  local ret
  if self.all then
    for k, v in pairs(self.all) do
      if v and v.start_time ~= nil and v:IsMember(serverId) and (ret == nil or ret.start_time < v.start_time) then
        ret = v
      end
    end
  end
  return ret
end

return SeasonTemplateManager
