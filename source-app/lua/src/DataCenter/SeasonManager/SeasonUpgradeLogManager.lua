local SeasonUpgradeLogManager = BaseClass("SeasonUpgradeLogManager")
local SeasonUpgradeLogTemplate = require("DataCenter.SeasonManager.SeasonUpgradeLogTemplate")

function SeasonUpgradeLogManager:__init()
  self.configDic = {}
end

function SeasonUpgradeLogManager:__delete()
  self.configDic = nil
end

local function GetKey(server, season)
  return string.format("season_%s_server_%s", season, server)
end

local function GetSaveKey(server, season)
  server = server or 0
  season = season or 0
  return string.format("%s_%s", SettingKeys.SEASON_UPGRADE_LOG_DATE, GetKey(server, season))
end

local function SortLogs(a, b)
  return (a.sort or 0) > (b.sort or 0)
end

function SeasonUpgradeLogManager:GetUpgradeLog(server, season)
  local key = GetKey(server, season)
  if not self.configDic[key] then
    self:LoadConfigBySeason(server, season, key)
  end
  return self.configDic[key] or {}
end

function SeasonUpgradeLogManager:GetCurrentUpgradeLog()
  local curServer, curSeason = self:GetCurrentServerAndSeason()
  return self:GetUpgradeLog(curServer, curSeason)
end

function SeasonUpgradeLogManager:LoadConfigBySeason(server, season, key)
  local _table = {}
  self.configDic[key] = _table
  local targetSeason = toInt(season)
  local targetServer = toInt(server)
  local timeNow = UITimeManager:GetInstance():GetServerSeconds()
  LocalController:instance():visitTable(TableName.LW_UPGRADE_LOG, function(id, lineData)
    local curSeason = tonumber(lineData.season_group) or 0
    if targetSeason == curSeason then
      local update_time = lineData.update_time
      if string.IsNullOrEmpty(update_time) then
        local year_show, month_show, day_show = string.match(update_time, "(%d+)|(%d+)|(%d+)")
        local _sec = UITimeManager:GetInstance():ServerYMD2Sec(toInt(year_show), toInt(month_show), toInt(day_show))
        if _sec <= timeNow then
          return
        end
      end
      local paramServer = tostring(lineData.sever)
      local args_0 = string.split(paramServer, ";")
      if args_0 and 0 < #args_0 then
        for k, v in ipairs(args_0) do
          local curServer = toInt(v) or 0
          if 0 < curServer then
            if curServer == targetServer then
              local template = SeasonUpgradeLogTemplate.New(curSeason, lineData)
              table.insert(_table, template)
            end
          else
            local serverGroup = tostring(v) or ""
            if 3 <= #serverGroup then
              local args = string.split(serverGroup, "-")
              if #args == 2 then
                local _start = toInt(args[1])
                local _end = toInt(args[2])
                if _start and _end and _start <= targetServer and _end >= targetServer then
                  local template = SeasonUpgradeLogTemplate.New(curSeason, lineData)
                  table.insert(_table, template)
                end
              end
            end
          end
        end
      end
    end
  end)
  if 0 < #_table then
    table.sort(_table, SortLogs)
  end
end

function SeasonUpgradeLogManager:RecordReadState(server, season)
  local key = GetSaveKey(server, season)
  local logs = self:GetUpgradeLog(server, season)
  local date = 0
  if logs ~= nil and 0 < #logs then
    date = logs[1].sort
  end
  CommonUtil.PlayerPrefsSetInt(key, date)
end

function SeasonUpgradeLogManager:ClearReadState(server, season)
  local key = GetSaveKey(server, season)
  CommonUtil.PlayerPrefsSetInt(key, 0)
  if CS.CommonUtils.IsDebug() then
    UIUtil.ShowTips(string.format("[Debug]\230\184\133\233\153\164\230\181\143\232\167\136\230\160\135\232\174\176"))
  end
end

function SeasonUpgradeLogManager:GetCurrentServerAndSeason()
  return LuaEntry.Player:GetSelfServerId() or 0, SeasonUtil.GetSeason() or 0
end

function SeasonUpgradeLogManager:GetCurrentReadDate()
  local key = GetSaveKey(self:GetCurrentServerAndSeason())
  return CommonUtil.PlayerPrefsGetInt(key, 0)
end

function SeasonUpgradeLogManager:CheckHasNew()
  local curServer, curSeason = self:GetCurrentServerAndSeason()
  local logs = self:GetUpgradeLog(curServer, curSeason)
  local newSort
  if logs ~= nil and 0 < #logs then
    newSort = logs[1].sort
  end
  if newSort then
    local key = GetSaveKey(curServer, curSeason)
    local current = CommonUtil.PlayerPrefsGetInt(key, 0)
    return newSort > current
  else
    return false
  end
end

function SeasonUpgradeLogManager:Description()
  local sb = StringBuilder.New()
  local curServer, curSeason = self:GetCurrentServerAndSeason()
  sb:AppendLine(string.format("---SeasonUpgradeLogManager---"))
  sb:AppendLine(string.format("\229\189\147\229\137\141\232\181\155\229\173\163:%s", curSeason))
  sb:AppendLine(string.format("\229\189\147\229\137\141\230\156\141\229\138\161\229\153\168:%s", curServer))
  sb:AppendLine(string.format("\229\189\147\229\137\141\232\181\155\229\173\163\227\128\129\230\156\141\230\181\143\232\167\136\232\174\176\229\189\149:%s", self:GetCurrentReadDate()))
  sb:AppendLine(string.format("\230\152\175\229\144\166\230\156\137\230\150\176\231\154\132\232\174\176\229\189\149\233\156\128:%s", self:CheckHasNew()))
  sb:AppendLine(string.format("\229\183\178\231\188\147\229\173\152\232\181\155\229\173\163\233\133\141\231\189\174\230\149\176\233\135\143%s", table.count(self.configDic)))
  for k, v in pairs(self.configDic) do
    sb:AppendLine(string.format("key:%s, log\230\149\176\233\135\143%s", k, #v))
  end
  return sb:ToString()
end

return SeasonUpgradeLogManager
