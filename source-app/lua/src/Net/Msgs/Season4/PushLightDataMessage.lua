local PushLightDataMessage = BaseClass("PushLightDataMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushLightDataMessage:OnCreate()
  base.OnCreate(self)
end

function PushLightDataMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.lightDataChange ~= nil then
    local lightData = PBController.ParsePbFromBytes(t.lightDataChange, "protobuf.PushLightChange")
    if lightData ~= nil and lightData.state ~= nil and lightData.light ~= nil then
      DataCenter.SeasonLightDataManager:UpdateLightData(lightData.state, lightData.light)
    end
  end
  SFSNetwork.SendMessage(MsgDefines.FetchCityLightStatusInfo)
end

return PushLightDataMessage
