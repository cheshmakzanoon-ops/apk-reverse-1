local SeasonRainforestKingBattleManager = BaseClass("SeasonRainforestKingBattleManager")
local FetchHeroEventCfgInfo = require("Net.Msgs.FetchHeroEventCfgInfoMessage")

function SeasonRainforestKingBattleManager:__init()
  self.theBattleInfo = nil
end

function SeasonRainforestKingBattleManager:__delete()
  self.theBattleInfo = nil
end

function SeasonRainforestKingBattleManager:TryGetNum(key, default)
  return LuaEntry.DataConfig:TryGetNum("s6_wonder_zone_war", key, default)
end

function SeasonRainforestKingBattleManager:TryGetStr(key, default)
  return LuaEntry.DataConfig:TryGetStr("s6_wonder_zone_war", key, default)
end

function SeasonRainforestKingBattleManager:GetBattleStartTime()
  local str = self:TryGetStr("k4", "6|12")
  if str ~= nil and str ~= "" then
    local day, time = string.split_ii(str, "|")
    if day and time then
      return day, time * 3600 * 1000
    end
  end
  return 6, 43200000
end

function SeasonRainforestKingBattleManager:SetBattleInfo(data)
  self.theBattleInfo = data
  EventManager:GetInstance():Broadcast(EventId.RainforestKingBattleInfoUpdate, data)
end

function SeasonRainforestKingBattleManager:GetBattleInfo(fetchWhenNotExist, forceRequest)
  local data = self.theBattleInfo
  local actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonRainforestKingBattle.Type)
  if actData == nil then
    return data
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if forceRequest or fetchWhenNotExist and data == nil or data ~= nil and data.now ~= nil and now - data.now > 5000 then
    SFSNetwork.SendMessage(MsgDefines.FetchRainforestKingBattleActivityInfo)
  end
  return data
end

function SeasonRainforestKingBattleManager:IsFighting()
  local actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonRainforestKingBattle.Type)
  if actData == nil then
    return false
  end
  if self.theBattleInfo == nil then
    return false
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local weekShieldInfo = self.theBattleInfo.weekShieldInfo
  if weekShieldInfo == nil then
    return false
  end
  local battleMaxTime = self:TryGetNum("k1", 14400) * 1000
  for _, v in ipairs(weekShieldInfo) do
    if now > v.breakShieldTime and now < v.breakShieldTime + battleMaxTime then
      return true
    end
  end
  return false
end

function SeasonRainforestKingBattleManager:GetFightingEndTime()
  local actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonRainforestKingBattle.Type)
  if actData == nil then
    return 0
  end
  if self.theBattleInfo == nil then
    return 0
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local weekShieldInfo = self.theBattleInfo.weekShieldInfo
  if weekShieldInfo == nil then
    return 0
  end
  local battleMaxTime = self:TryGetNum("k1", 14400) * 1000
  for _, v in ipairs(weekShieldInfo) do
    if now >= v.breakShieldTime and now <= v.breakShieldTime + battleMaxTime then
      return v.breakShieldTime + battleMaxTime
    end
  end
  return 0
end

return SeasonRainforestKingBattleManager
