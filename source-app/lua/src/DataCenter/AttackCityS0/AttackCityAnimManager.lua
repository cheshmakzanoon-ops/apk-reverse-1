local AttackCityAnimManager = BaseClass("AttackCityAnimManager", CEventable)
local AttackCityS0AnimPoint = require("DataCenter.AttackCityS0.AttackCityS0AnimPoint")

local function __init(self)
  self.animPoints = {}
  self.pointId = nil
  self.prefabPath = nil
  self:AddListener()
end

local function __delete(self)
  self.animPoints = nil
  self.pointId = nil
  self.prefabPath = nil
  self:RemoveAllPoint()
end

local function AddListener(self)
  self:RegisterEvent(EventId.OnEnterCity, self.RemoveAllPoint)
  self:RegisterEvent(EventId.WORLD_BUILD_OUT_VIEW, self.RemovePointAnim)
end

local function ShowPointAnim(self, pointUUid, memberList, isStart, serverId)
  if self.animPoints[pointUUid] == nil then
    self.animPoints[pointUUid] = AttackCityS0AnimPoint.New()
  end
  self.animPoints[pointUUid]:ShowPointAnim(pointUUid, memberList, isStart, serverId)
end

local function RemovePointAnim(self, pointUUid)
  pointUUid = tonumber(pointUUid)
  if self.animPoints[pointUUid] then
    self.animPoints[pointUUid]:OnDestroy()
    self.animPoints[pointUUid] = nil
  end
end

local function RemovePointOneAnimObj(self, animObj)
  if animObj and animObj.pointUUid and self.animPoints[animObj.pointUUid] then
    self.animPoints[animObj.pointUUid]:RemoveOneAnimObj(animObj)
  end
end

local function RemoveAllPoint(self)
  if self.animPoints then
    for key, value in pairs(self.animPoints) do
      value:OnDestroy()
    end
    self.animPoints = {}
  end
end

local function RemoveWorldFingerArrow(self)
  if self.fingerArrowObj then
    self.fingerArrowObj:Destroy()
    self.fingerArrowObj = nil
  end
end

local function RemoveWorldFingerArrowByUUid(self, uuid)
  if self.fingerArrowObj and self.fingerUUid == uuid then
    self.fingerArrowObj:Destroy()
    self.fingerArrowObj = nil
  end
end

local function AddWorldFingerArrowTimer(self, closeTime)
  if self.worldFingerArrow_timer == nil and closeTime then
    self.worldFingerArrow_timer = TimerManager:GetInstance():GetTimer(closeTime, function()
      self:RemoveWorldFingerArrow()
    end, self, true, false, false)
    self.worldFingerArrow_timer:Start()
  end
end

local function DeleteWorldFingerArrowTimer(self)
  if self.worldFingerArrow_timer then
    self.worldFingerArrow_timer:Stop()
    self.worldFingerArrow_timer = nil
  end
end

local function ShowPointDeadAnim(self, pointId, prefab)
  if self.animPoints[pointId] == nil then
    self.animPoints[pointId] = AttackCityS0AnimPoint.New()
  end
  self.animPoints[pointId]:ShowPointDeadAnim(pointId, prefab)
end

function AttackCityAnimManager:SaveMonsterRadarPointIdAndPrefab(pointId, prefab)
  self.pointId = pointId
  self.prefabPath = prefab
end

function AttackCityAnimManager:GetMonsterRadarPointIdAndPrefab()
  return self.pointId, self.prefabPath
end

AttackCityAnimManager.__init = __init
AttackCityAnimManager.__delete = __delete
AttackCityAnimManager.AddListener = AddListener
AttackCityAnimManager.ShowPointAnim = ShowPointAnim
AttackCityAnimManager.RemovePointAnim = RemovePointAnim
AttackCityAnimManager.RemovePointOneAnimObj = RemovePointOneAnimObj
AttackCityAnimManager.RemoveAllPoint = RemoveAllPoint
AttackCityAnimManager.RemoveWorldFingerArrow = RemoveWorldFingerArrow
AttackCityAnimManager.RemoveWorldFingerArrowByUUid = RemoveWorldFingerArrowByUUid
AttackCityAnimManager.AddWorldFingerArrowTimer = AddWorldFingerArrowTimer
AttackCityAnimManager.DeleteWorldFingerArrowTimer = DeleteWorldFingerArrowTimer
AttackCityAnimManager.ShowPointDeadAnim = ShowPointDeadAnim
return AttackCityAnimManager
