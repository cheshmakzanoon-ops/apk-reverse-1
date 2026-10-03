local DetectEventTaskRetryStartMessage = BaseClass("DetectEventTaskRetryStartMessage", SFSBaseMessage)
local base = SFSBaseMessage
local ExtendData

function DetectEventTaskRetryStartMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", param.uuid)
  self.sfsObj:PutInt("eventType", param.eventType)
  ExtendData = param
end

function DetectEventTaskRetryStartMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif ExtendData and ExtendData.featureConfigId then
    local param = {}
    param.type = PVEType.Parkour
    param.enterType = PVEEnterType.DetectRetryTask
    param.levelId = ExtendData.featureConfigId
    param.backWorldPos = SceneUtils.TileIndexToWorld(ExtendData.pointId, ForceChangeScene.World)
    param.extraData = ExtendData
    DataCenter.LWBattleManager:Enter(param)
    EventManager:GetInstance():Broadcast(EventId.GF_goto_pve_battle, param)
  end
end

return DetectEventTaskRetryStartMessage
