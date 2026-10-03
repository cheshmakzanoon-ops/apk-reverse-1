local FindResourceMessage = BaseClass("FindResourceMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, level, resourceType)
  base.OnCreate(self)
  self.sfsObj:PutInt("level", level)
  self.sfsObj:PutInt("resourceType", resourceType)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.pointId ~= nil then
    local param = {}
    param.pointId = t.pointId
    param.uuid = t.uuid
    EventManager:GetInstance():Broadcast(EventId.END_SEARCH, param)
  end
end

FindResourceMessage.OnCreate = OnCreate
FindResourceMessage.HandleMessage = HandleMessage
return FindResourceMessage
