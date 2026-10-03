local RequestHelpStopCityFireMessage = BaseClass("RequestHelpStopCityFireMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param.roomId then
    self.sfsObj:PutUtfString("roomId", param.roomId)
  end
  if param.post then
    self.sfsObj:PutInt("post", param.post)
  end
  if param.oname then
    self.sfsObj:PutUtfString("oname", param.oname)
  end
  if param.sid then
    self.sfsObj:PutInt("sid", param.sid)
  end
  if param.worldId then
    self.sfsObj:PutInt("worldId", param.worldId)
  end
  if param.y then
    self.sfsObj:PutInt("y", param.y)
  end
  if param.x then
    self.sfsObj:PutInt("x", param.x)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

RequestHelpStopCityFireMessage.OnCreate = OnCreate
RequestHelpStopCityFireMessage.HandleMessage = HandleMessage
return RequestHelpStopCityFireMessage
