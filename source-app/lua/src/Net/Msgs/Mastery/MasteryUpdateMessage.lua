local MasteryUpdateMessage = BaseClass("MasteryUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.MasteryManager:GetHomeExpAddMsgHandle(t)
  EventManager:GetInstance():Broadcast(EventId.LWMasteryChangeMsgGet)
  if t.addExp and t.addExp > 0 then
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWUIMasteryExpGet) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMasteryExpGet)
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasteryExpGet, {anim = true}, t)
  end
end

MasteryUpdateMessage.OnCreate = OnCreate
MasteryUpdateMessage.HandleMessage = HandleMessage
return MasteryUpdateMessage
