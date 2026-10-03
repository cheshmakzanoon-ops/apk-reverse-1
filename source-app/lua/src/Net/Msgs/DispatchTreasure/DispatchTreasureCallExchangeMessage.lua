local DispatchTreasureCallExchangeMessage = BaseClass("DispatchTreasureCallExchangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutInt("type", param.type)
    self.sfsObj:PutUtfString("needFragment", tostring(param.needFragment))
    self.sfsObj:PutUtfString("costFragment", tostring(param.costFragment))
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.SplinterExchangeManager:RefreshSelfInfo(t)
      EventManager:GetInstance():Broadcast(EventId.SplinterRefreshSelf, t.type)
      UIUtil.ShowTipsId("Treasure_map_34")
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

DispatchTreasureCallExchangeMessage.OnCreate = OnCreate
DispatchTreasureCallExchangeMessage.HandleMessage = HandleMessage
return DispatchTreasureCallExchangeMessage
