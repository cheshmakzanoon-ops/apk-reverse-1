local DetectEventGetTreasureClaimInfoMessage = BaseClass("DetectEventGetTreasureClaimInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function DetectEventGetTreasureClaimInfoMessage:OnCreate(uuid, source, targetServer)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  if source == nil then
    self.sfsObj:PutInt("source", SeeDetectEventGetTreasureClaimInfoType.Chat)
  else
    self.sfsObj:PutInt("source", source)
  end
  if targetServer == nil then
    targetServer = LuaEntry.Player:GetSourceServerId()
  end
  self.sfsObj:PutInt("targetServer", targetServer)
end

function DetectEventGetTreasureClaimInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.RadarCenterDataManager:GetDetectEventTreasureClaimInfo(message)
end

return DetectEventGetTreasureClaimInfoMessage
