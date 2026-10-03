local AttackCityS0AnimPoint = BaseClass("AttackCityS0AnimPoint")
local AttackCityAnimObj = require("DataCenter.AttackCityS0.AttackCityAnimObj")
local MonsterDeadAnimObj = require("DataCenter.AttackCityS0.AttackCityMonsterDeadAnimObj")

local function __init(self)
  self.freeAngle = {
    10,
    85,
    160,
    220,
    300
  }
  self.animObjs = {}
  self.center = nil
end

local function __delete(self)
  self:OnDestroy()
  self.pointUUid = nil
  self.center = nil
end

local function OnDestroy(self)
  if self.animObjs then
    for key, value in pairs(self.animObjs) do
      value:OnDestroy()
    end
  end
  self.animObjs = nil
end

local function ShowPointAnim(self, pointUUid, memberList, isStart, serverId)
  local world = CS.SceneManager.World
  if world then
    self.pointUUid = pointUUid
    local pointInfo = world:GetPointInfoByUuid(pointUUid)
    if pointInfo then
      self.poinObj = world:GetObjectByPoint(pointInfo.pointIndex)
      if self.poinObj then
        self.center = SceneUtils.TileIndexToWorld(pointInfo.pointIndex, ForceChangeScene.World)
        for index, value in ipairs(memberList) do
          if #self.freeAngle > 0 then
            local randomkey = table.randomKey(self.freeAngle)
            local angle = table.remove(self.freeAngle, randomkey)
            if self.animObjs[value] then
              self.animObjs[value]:OnDestroy()
              self.animObjs[value] = nil
            end
            local animObj = AttackCityAnimObj.New()
            local startPos = self.center
            if isStart then
              animObj:ShowAnim(pointUUid, isStart, value, angle, startPos, serverId, self.poinObj)
            else
              animObj:ShowAnim(pointUUid, isStart, value, angle, startPos, serverId, self.poinObj)
            end
            self.animObjs[value] = animObj
          end
        end
      end
    end
  end
end

local function GetCirclePosByAngle(self, radius, angle)
  local angleInRadians = angle * Mathf.Deg2Rad
  local x = self.center.x + radius * Mathf.Cos(angleInRadians)
  local z = self.center.z + radius * Mathf.Sin(angleInRadians)
  return Vector3.New(x, self.center.y, z)
end

local function RemoveOneAnimObj(self, animObj)
  if self.animObjs[animObj.keyId] then
    self.animObjs[animObj.keyId] = nil
  end
  if animObj.angle then
    local angle = animObj.angle
    if not table.hasvalue(self.freeAngle, angle) then
      table.insert(self.freeAngle, angle)
    end
  end
end

local function ShowPointDeadAnim(self, pointId, prefab)
  local world = CS.SceneManager.World
  if world then
    local animObj = MonsterDeadAnimObj.New()
    animObj:ShowPointAnim(pointId, prefab)
    self.animObjs[pointId] = animObj
  end
end

AttackCityS0AnimPoint.__init = __init
AttackCityS0AnimPoint.__delete = __delete
AttackCityS0AnimPoint.ShowPointAnim = ShowPointAnim
AttackCityS0AnimPoint.RemoveOneAnimObj = RemoveOneAnimObj
AttackCityS0AnimPoint.ShowPointDeadAnim = ShowPointDeadAnim
AttackCityS0AnimPoint.GetCirclePosByAngle = GetCirclePosByAngle
AttackCityS0AnimPoint.OnDestroy = OnDestroy
return AttackCityS0AnimPoint
