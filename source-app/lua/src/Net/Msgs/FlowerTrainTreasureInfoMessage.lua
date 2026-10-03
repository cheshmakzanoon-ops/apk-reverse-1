local FlowerTrainTreasureInfoMessage = BaseClass("FlowerTrainTreasureInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FlowerTrainTreasureInfoMessage:OnCreate(serverId, uuid)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutLong("uuid", uuid)
end

function FlowerTrainTreasureInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local boxUuid, fromTrainOwnerName
    if t.uuid then
      boxUuid = t.uuid
    end
    if t.name then
      fromTrainOwnerName = t.name
    end
    if boxUuid and fromTrainOwnerName then
      local params = {}
      params.uuid = boxUuid
      params.name = fromTrainOwnerName
      EventManager:GetInstance():Broadcast(EventId.FlowerTrainGetFlowerBoxInfoSuccess, params)
    end
  end
end

return FlowerTrainTreasureInfoMessage
