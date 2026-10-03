local LWZoneMobilizationResourcePointsInfo = BaseClass("LWZoneMobilizationResourcePointsInfo")

function LWZoneMobilizationResourcePointsInfo:__init()
  self.pointId = 0
  self.allianceResBuildId = 0
  self.expireTime = 0
  self.remainNum = 0
  self.isInRes = false
end

function LWZoneMobilizationResourcePointsInfo:__delete()
  self.pointId = nil
  self.allianceResBuildId = nil
  self.expireTime = nil
  self.remainNum = nil
  self.isinRes = nil
end

function LWZoneMobilizationResourcePointsInfo:InitData(message)
  self.pointId = message.pointId or 0
  self.allianceResBuildId = message.allianceResBuildId or 0
  self.expireTime = message.expireTime or 0
  self.remainNum = message.remainNum or 0
  self.isInRes = message.isInRes or false
end

function LWZoneMobilizationResourcePointsInfo:IsExpired()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  return curTime >= self.expireTime
end

function LWZoneMobilizationResourcePointsInfo:GoToResourcePoints()
  if self.pointId then
    GoToUtil.CloseAllWindows()
    local sourceServerId = LuaEntry.Player:GetSourceServerId()
    local worldPosition = SceneUtils.TileIndexToWorld(self.pointId, ForceChangeScene.World, sourceServerId)
    GoToUtil.GotoWorldPos(worldPosition, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
    end, sourceServerId)
  end
end

return LWZoneMobilizationResourcePointsInfo
