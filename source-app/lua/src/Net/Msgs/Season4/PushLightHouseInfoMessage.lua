local PushLightHouseInfoMessage = BaseClass("PushLightHouseInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushLightHouseInfoMessage:OnCreate()
  base.OnCreate(self)
end

function PushLightHouseInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t ~= nil and t.active ~= nil then
    DataCenter.SeasonPowerWorkerManager:UpdateLightHouse(t)
    if t.updateType ~= nil then
      if t.updateType == LightHouseUpdateType.SELF_WORKER_UPDATE then
        SFSNetwork.SendMessage(MsgDefines.FetchPowerWorkerDetail)
      end
      CityDomeProtectEffectManager:GetInstance():UpdateBatteryPowerEffect(LuaEntry.Player:GetMainWorldPos(), t, true)
    else
      SFSNetwork.SendMessage(MsgDefines.FetchPowerWorkerDetail)
    end
  end
end

return PushLightHouseInfoMessage
