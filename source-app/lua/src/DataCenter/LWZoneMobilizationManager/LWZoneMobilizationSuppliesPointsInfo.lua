local LWZoneMobilizationSuppliesPointsInfo = BaseClass("LWZoneMobilizationSuppliesPointsInfo")
local Localization = CS.GameEntry.Localization

function LWZoneMobilizationSuppliesPointsInfo:__init()
  self.discovererInfo = {}
  self.pointId = 0
  self.rewardNum = 0
  self.rewarded = false
  self.expireTime = 0
  self.cfgId = 0
end

function LWZoneMobilizationSuppliesPointsInfo:__delete()
  self.discovererInfo = nil
  self.pointId = nil
  self.rewardNum = nil
  self.rewarded = nil
  self.expireTime = nil
  self.cfgId = nil
end

function LWZoneMobilizationSuppliesPointsInfo:InitData(message)
  self.pointId = message.pointId or 0
  self.rewardNum = message.rewardNum or 0
  self.rewarded = message.rewarded or false
  self.expireTime = message.expireTime or 0
  self.cfgId = message.cfgId or 0
  if message.discovererInfo then
    message.discovererInfo.pic = message.discovererInfo.headPic
    message.discovererInfo.picVer = message.discovererInfo.headPicVer
    self.discovererInfo = BasePlayerInfo.New()
    self.discovererInfo:ParseData(message.discovererInfo)
  end
end

function LWZoneMobilizationSuppliesPointsInfo:IsExpired()
  if self.expireTime == 0 then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  return curTime >= self.expireTime
end

function LWZoneMobilizationSuppliesPointsInfo:GoToSuppliesPoints()
  if self.pointId then
    GoToUtil.CloseAllWindows()
    local sourceServerId = LuaEntry.Player:GetSourceServerId()
    local worldPosition = SceneUtils.TileIndexToWorld(self.pointId, ForceChangeScene.World, sourceServerId)
    GoToUtil.GotoWorldPos(worldPosition, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
    end, sourceServerId)
  end
end

function LWZoneMobilizationSuppliesPointsInfo:GetSuppliesName()
  local configData = LocalController:instance():getLine(TableName.LWIceSupplies, self.cfgId)
  if configData then
    return Localization:GetString(GameDialogDefine.LEVEL_NUMBER, configData.level) .. " " .. Localization:GetString(configData.name)
  end
end

return LWZoneMobilizationSuppliesPointsInfo
