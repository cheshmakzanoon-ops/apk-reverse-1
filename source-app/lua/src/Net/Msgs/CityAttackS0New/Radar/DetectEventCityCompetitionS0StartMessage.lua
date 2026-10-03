local DetectEventCityCompetitionS0StartMessage = BaseClass("DetectEventCityCompetitionS0StartMessage", SFSBaseMessage)
local base = SFSBaseMessage
local ExtendData

function DetectEventCityCompetitionS0StartMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("eventType", param.eventType)
  self.sfsObj:PutUtfString("uuid", tostring(param.uuid))
  ExtendData = param
end

function DetectEventCityCompetitionS0StartMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif ExtendData and ExtendData.featureConfigId then
    local param = {}
    param.type = PVEType.Parkour
    param.enterType = PVEEnterType.DetectAttackCityS0
    param.levelId = ExtendData.featureConfigId
    param.backWorldPos = SceneUtils.TileIndexToWorld(ExtendData.pointId, ForceChangeScene.World)
    param.extraData = ExtendData
    DataCenter.LWBattleManager:Enter(param)
    EventManager:GetInstance():Broadcast(EventId.GF_goto_pve_battle, param)
  else
    SFSNetwork.SendMessage(MsgDefines.DetectEventCityCompetitionS0End, t.uuid, t.eventType)
  end
end

return DetectEventCityCompetitionS0StartMessage
