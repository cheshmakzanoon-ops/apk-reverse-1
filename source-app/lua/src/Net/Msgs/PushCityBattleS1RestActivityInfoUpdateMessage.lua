local PushCityBattleS1RestActivityInfoUpdateMessage = BaseClass("PushCityBattleS1RestActivityInfoUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushCityBattleS1RestActivityInfoUpdateMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushCityBattleS1RestActivityInfoUpdateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if not DataCenter.ActivityListDataManager:CheckIfActivityOpen(EnumActivity.OffSeason1Recapture.Type) then
      return
    end
    if t.updateType and t.updateType == RecaptureActUpdateType.TASK_INFO_UPDATE then
      SFSNetwork.SendMessage(MsgDefines.CityBattleActivityGainTaskInfo, OffSeason1TaskGroup.OffSeason1Recapture)
    elseif t.updateType and t.updateType == RecaptureActUpdateType.PRESIDENT_CHOOSE_UPDATE then
      SFSNetwork.SendMessage(MsgDefines.CityBattleS1RestGainActivityInfo, t)
    else
      SFSNetwork.SendMessage(MsgDefines.CityBattleS1RestGainActivityInfo, t)
    end
  end
end

return PushCityBattleS1RestActivityInfoUpdateMessage
