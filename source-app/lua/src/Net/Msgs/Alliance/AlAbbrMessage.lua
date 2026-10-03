local AlAbbrMessage = BaseClass("AlAbbrMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, abbr)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("abbr", abbr)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.result ~= nil then
    local exist = t.result
    EventManager:GetInstance():Broadcast(EventId.AllianceChangeAbbrSuccess, exist and CheckNameType.Exist or CheckNameType.None)
  end
end

AlAbbrMessage.OnCreate = OnCreate
AlAbbrMessage.HandleMessage = HandleMessage
return AlAbbrMessage
