local FindNearMonsterMessage = BaseClass("FindNearMonsterMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Special_Type = 0

local function OnCreate(self, specialType)
  base.OnCreate(self)
  Special_Type = specialType or 0
  self.sfsObj:PutInt("specialType", specialType or 0)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    local errorCode = t.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(t.errorCode))
    end
  elseif t.pointId ~= nil then
    local param = {}
    param.pointId = t.pointId
    param.uuid = t.uuid
    EventManager:GetInstance():Broadcast(EventId.END_SEARCH, param)
  else
    EventManager:GetInstance():Broadcast(EventId.SearchMonsterFailed, Special_Type)
  end
end

FindNearMonsterMessage.OnCreate = OnCreate
FindNearMonsterMessage.HandleMessage = HandleMessage
return FindNearMonsterMessage
