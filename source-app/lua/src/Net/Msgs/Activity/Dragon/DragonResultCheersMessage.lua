local DragonResultCheersMessage = BaseClass("DragonResultCheersMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DragonResultCheersMessage:OnCreate(operate)
  base.OnCreate(self)
  local curGroup = DataCenter.ActDragonManager:GetCurGroup()
  local group = curGroup ~= nil and curGroup.group or 0
  self.sfsObj:PutInt("group", group)
  self.sfsObj:PutInt("operate", operate)
end

function DragonResultCheersMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.DragonResultCheersSuccess, t.operate)
  end
end

return DragonResultCheersMessage
