local TroopLine = require("DataCenter.WorldTroopLine.TroopLine")
local WorldTroopColor = {
  [WorldCamp.Self] = {
    [WorldTroopColorType.name] = Color.New(188, 249, 54, 255),
    [WorldTroopColorType.line] = Color.New(0.46, 0.93, 0.18, 1),
    [WorldTroopColorType.light] = Color.New(0.46, 0.93, 0.18, 0.5)
  },
  [WorldCamp.Ally] = {
    [WorldTroopColorType.name] = Color.New(73, 201, 248, 255),
    [WorldTroopColorType.line] = Color.New(0.2, 0.78, 0.81, 1),
    [WorldTroopColorType.light] = Color.New(0.2, 0.78, 0.81, 0.5)
  },
  [WorldCamp.Enemy] = {
    [WorldTroopColorType.name] = Color.New(249, 112, 119, 255),
    [WorldTroopColorType.line] = Color.New(0.89, 0.23, 0.2, 1),
    [WorldTroopColorType.light] = Color.New(0.89, 0.23, 0.2, 0.5)
  },
  [WorldCamp.Neutral] = {
    [WorldTroopColorType.name] = Color.New(227, 227, 227, 255),
    [WorldTroopColorType.line] = Color.New(0.89, 0.89, 0.89, 1),
    [WorldTroopColorType.light] = Color.New(0.89, 0.89, 0.89, 0.5)
  },
  [WorldCamp.WsTeammate] = {
    [WorldTroopColorType.name] = Color.New(0, 201, 231, 255),
    [WorldTroopColorType.line] = Color.New(0.2, 0.78, 0.81, 1),
    [WorldTroopColorType.light] = Color.New(0.2, 0.78, 0.81, 0.5)
  },
  [WorldCamp.WsEnemy] = {
    [WorldTroopColorType.name] = Color.New(230, 56, 63, 255),
    [WorldTroopColorType.line] = Color.New(0.89, 0.23, 0.2, 1),
    [WorldTroopColorType.light] = Color.New(0.89, 0.23, 0.2, 0.5)
  }
}
local WorldTroopLineManager = BaseClass("WorldTroopLineManager")

function WorldTroopLineManager:__init()
  self._troopLines = {}
end

function WorldTroopLineManager:__delete()
  self:Destroy()
end

function WorldTroopLineManager:Destroy()
  for _, v in pairs(self._troopLines) do
    v:Destroy()
  end
  self._troopLines = {}
end

function WorldTroopLineManager:CreateTroopLine(march)
  if march:GetMarchTargetType() == MarchTargetType.TRAIN_MOVE then
    return
  end
  local uuid = march.uuid
  if self._troopLines[uuid] then
    self._troopLines[uuid]:SetData(march)
  else
    self._troopLines[uuid] = TroopLine.New(march)
  end
end

function WorldTroopLineManager:DestroyTroopLine(uuid)
  if self._troopLines[uuid] then
    self._troopLines[uuid]:Destroy()
    self._troopLines[uuid] = nil
  end
end

function WorldTroopLineManager:IsTroopLineCreate(uuid)
  return self._troopLines[uuid] and true or false
end

function WorldTroopLineManager:UpdateTroopLineNew(march, curPos)
  if march.pathList and march.pathList.Length > 0 and self._troopLines[march.uuid] then
    self._troopLines[march.uuid]:SetCurPos(march, curPos)
  end
end

function WorldTroopLineManager:GetCamp(march)
  local camp = WorldCamp.Neutral
  if march.ownerUid == LuaEntry.Player.uid then
    camp = WorldCamp.Self
  elseif BattleFieldUtil.InBattleField(BattleFieldType.WinterStorm) then
    camp = DataCenter.ActWinterStormManager:GetWorldCampInWinterStorm(march.ownerUid)
  else
    local myAllianceId = LuaEntry.Player:GetAllianceUid()
    local marchType = march:GetMarchTargetType()
    if marchType == MarchTargetType.ATTACK_CITY or marchType == MarchTargetType.ATTACK_WINTER_STORM_CITY or marchType == MarchTargetType.ATTACK_EPIDEMIC_CITY or marchType == MarchTargetType.RALLY_FOR_CITY or marchType == MarchTargetType.RALLY_EPIDEMIC_CITY or marchType == MarchTargetType.SCOUT_CITY or marchType == MarchTargetType.SCOUT_WINTER_STORM_CITY or marchType == MarchTargetType.SCOUT_EPIDEMIC_CITY then
      local targetPos = march.targetPos
      if targetPos == LuaEntry.Player:GetMainWorldPos() then
        return WorldCamp.Enemy
      end
      if LuaEntry.Player:IsInAlliance() then
        if myAllianceId == march.allianceUid then
          return WorldCamp.Ally
        end
        local pointInfo = CS.SceneManager.World:GetPointInfo(targetPos)
        if pointInfo ~= nil then
          if pointInfo.PointType == WorldPointType.PlayerBuilding then
            if DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(pointInfo.ownerUid) ~= nil then
              return WorldCamp.Enemy
            end
          else
            return WorldCamp.Neutral
          end
        end
        if DataCenter.AllianceMemberDataManager:IsMemberHouse(targetPos) then
          return WorldCamp.Enemy
        end
      end
      return WorldCamp.Neutral
    end
    if not string.IsNullOrEmpty(myAllianceId) then
      if myAllianceId == march.allianceUid then
        camp = WorldCamp.Ally
      elseif CS.SceneManager.World:IsTargetForMine(march) then
        camp = WorldCamp.Enemy
      elseif CS.SceneManager.World:IsTargetForAlly(march) then
        camp = WorldCamp.Enemy
      end
    elseif CS.SceneManager.World:IsTargetForMine(march) then
      camp = WorldCamp.Enemy
    end
  end
  return camp
end

function WorldTroopLineManager:GetColor(camp, type)
  return WorldTroopColor[camp][type]
end

return WorldTroopLineManager
