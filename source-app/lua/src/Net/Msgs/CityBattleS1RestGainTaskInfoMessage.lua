local CityBattleS1RestGainTaskInfoMessage = BaseClass("CityBattleS1RestGainTaskInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CityBattleS1RestGainTaskInfoMessage:OnCreate(group)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", group)
end

function CityBattleS1RestGainTaskInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.OffSeason1TaskDataManager:ParseTaskServerData(t)
  end
end

return CityBattleS1RestGainTaskInfoMessage
