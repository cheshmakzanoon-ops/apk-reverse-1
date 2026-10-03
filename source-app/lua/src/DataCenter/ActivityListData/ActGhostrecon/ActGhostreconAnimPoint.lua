local ActGhostreconAnimPoint = BaseClass("ActGhostreconAnimPoint")
local ActGhostreconAnimObj = require("DataCenter.ActivityListData.ActGhostrecon.ActGhostreconAnimObj")
local startRadius = 5
local endRadius = 15
local flyTime = 1.5

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
      value:OnDestory()
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
            if self.animObjs[value.uid] then
              self.animObjs[value.uid]:OnDestory()
              self.animObjs[value.uid] = nil
            end
            local animObj = ActGhostreconAnimObj.New()
            local startPos = self.center
            if isStart then
              animObj:ShowAnim(pointUUid, isStart, value, angle, startPos, serverId)
            else
              animObj:ShowAnim(pointUUid, isStart, value, angle, startPos, serverId)
            end
            self.animObjs[value.uid] = animObj
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
  if self.animObjs[animObj.memberInfo.uid] then
    self.animObjs[animObj.memberInfo.uid] = nil
  end
  local angle = animObj.angle
  if not table.hasvalue(self.freeAngle, angle) then
    table.insert(self.freeAngle, angle)
  end
end

ActGhostreconAnimPoint.__init = __init
ActGhostreconAnimPoint.__delete = __delete
ActGhostreconAnimPoint.ShowPointAnim = ShowPointAnim
ActGhostreconAnimPoint.RemoveOneAnimObj = RemoveOneAnimObj
ActGhostreconAnimPoint.GetCirclePosByAngle = GetCirclePosByAngle
ActGhostreconAnimPoint.OnDestroy = OnDestroy
return ActGhostreconAnimPoint
