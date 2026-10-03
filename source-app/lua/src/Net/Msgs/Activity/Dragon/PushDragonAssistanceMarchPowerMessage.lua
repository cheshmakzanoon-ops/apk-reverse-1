local PushDragonAssistanceMarchPowerMessage = BaseClass("PushDragonAssistanceMarchPowerMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushDragonAssistanceMarchPowerMessage:OnCreate(allianceId)
  base.OnCreate(self)
  self.sfsObj:PutInt("openHide", 1)
  self.sfsObj:PutUtfString("allianceId", allianceId)
end

function PushDragonAssistanceMarchPowerMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.infos then
    for _, v in pairs(t.infos) do
      local marchData = DataCenter.WorldMarchDataManager:GetMarch(v.uuid)
      if marchData then
        marchData.power = v.power
      end
    end
    EventManager:GetInstance():Broadcast(EventId.DragonAssistanceMarchPowerChanged)
  end
end

return PushDragonAssistanceMarchPowerMessage
