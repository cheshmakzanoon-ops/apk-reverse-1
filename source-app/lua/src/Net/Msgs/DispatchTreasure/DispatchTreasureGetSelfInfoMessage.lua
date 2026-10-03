local DispatchTreasureGetSelfInfoMessage = BaseClass("DispatchTreasureGetSelfInfoMessage", SFSBaseMessage)
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
      DataCenter.SplinterExchangeManager:RefreshSelfInfo(t)
      EventManager:GetInstance():Broadcast(EventId.SplinterRefreshSelf, t.type)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

DispatchTreasureGetSelfInfoMessage.OnCreate = OnCreate
DispatchTreasureGetSelfInfoMessage.HandleMessage = HandleMessage
return DispatchTreasureGetSelfInfoMessage
