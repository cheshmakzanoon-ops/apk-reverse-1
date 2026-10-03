local DispatchTreasureGetALInfoMessage = BaseClass("DispatchTreasureGetALInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutInt("type", param.type)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.SplinterExchangeManager:RefreshALInfoList(t)
      EventManager:GetInstance():Broadcast(EventId.SplinterRefreshAL, t.type)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

DispatchTreasureGetALInfoMessage.OnCreate = OnCreate
DispatchTreasureGetALInfoMessage.HandleMessage = HandleMessage
return DispatchTreasureGetALInfoMessage
