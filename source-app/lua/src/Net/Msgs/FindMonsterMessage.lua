local FindMonsterMessage = BaseClass("FindMonsterMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, pointId, level, isBoss, searchRange, monsterType)
  base.OnCreate(self)
  self.sfsObj:PutInt("pointId", pointId)
  self.sfsObj:PutInt("level", level)
  self.sfsObj:PutBool("isBoss", isBoss)
  if searchRange ~= nil then
    self.sfsObj:PutInt("searchRange", searchRange)
  end
  if SeasonUtil.IsInSeasonDarknessMode(true) and (monsterType == LWWorldMonsterType.ResMetal or monsterType == LWWorldMonsterType.ResFood or monsterType == LWWorldMonsterType.ResGold) then
    Logger.LogError("SearchNonS4MonsterInS4")
    local isBloodyNight = DataCenter.BloodyNightDataManager:IsBloodyNight(LuaEntry.Player:GetSelfServerId())
    if monsterType == LWWorldMonsterType.ResMetal then
      monsterType = isBloodyNight and LWWorldMonsterType.S4TankBN or LWWorldMonsterType.S4Tank
    elseif monsterType == LWWorldMonsterType.ResFood then
      monsterType = isBloodyNight and LWWorldMonsterType.S4AirplaneBN or LWWorldMonsterType.S4Airplane
    elseif monsterType == LWWorldMonsterType.ResGold then
      monsterType = isBloodyNight and LWWorldMonsterType.S4MissileBN or LWWorldMonsterType.S4Missile
    end
  end
  if monsterType ~= nil then
    self.sfsObj:PutInt("monsterType", monsterType)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    local errorCode = t.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(t.errorCode))
    end
  elseif t.pointId ~= nil then
    local param = {}
    param.pointId = t.pointId
    param.uuid = t.uuid
    EventManager:GetInstance():Broadcast(EventId.END_SEARCH, param)
  end
end

FindMonsterMessage.OnCreate = OnCreate
FindMonsterMessage.HandleMessage = HandleMessage
return FindMonsterMessage
