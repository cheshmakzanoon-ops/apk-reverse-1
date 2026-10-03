local PushMummyWorldSkillMessage = BaseClass("PushMummyWorldSkillMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  if not t.skillBroadInfo then
    return
  end
  DataCenter.AddSoldiersMarchManager:UpdateEventInfo(t.skillBroadInfo)
end

local function GetTestData(self, uid)
  local t = {}
  local fromUid = LuaEntry.Player.uid
  local fromPointId = LuaEntry.Player.world_main_pos
  local fromPos = SceneUtils.TileIndexToWorld(fromPointId, ForceChangeScene.World)
  local range = 25
  local now = UITimeManager:GetInstance():GetServerTime()
  local value = {}
  value.worldId = LuaEntry.Player:GetCurWorldId()
  value.targetUid = uid
  value.fromUid = fromUid
  value.fromPointId = fromPointId
  value.startTime = now
  value.baseNum = math.random(0, 10) > 5 and 30 or 0
  value.randomNum = math.random(1, 6)
  value.targetPointId = -1
  value.armyId = 12001
  local member = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(value.targetUid)
  if member and member.pointId then
    value.targetPointId = member.pointId
    local targetPos = SceneUtils.TileIndexToWorld(member.pointId, ForceChangeScene.World)
    if range >= Vector3.Distance(fromPos, targetPos) then
      table.insert(t, value)
    end
  end
  t.skillBroadInfo = value
  return t
end

PushMummyWorldSkillMessage.GetTestData = GetTestData
PushMummyWorldSkillMessage.OnCreate = OnCreate
PushMummyWorldSkillMessage.HandleMessage = HandleMessage
return PushMummyWorldSkillMessage
