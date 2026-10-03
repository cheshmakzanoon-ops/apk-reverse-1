local DispatchDigTreasureMessage = BaseClass("DispatchDigTreasureMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, type, times)
  base.OnCreate(self)
  if type ~= nil then
    self.sfsObj:PutInt("exchangeType", type)
  end
  if times ~= nil then
    self.sfsObj:PutInt("times", times)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode ~= nil then
      UIUtil.ShowTipsId(t.errorCode)
    elseif t[DIG_DISPATCH_GUARANTEE_NUM] ~= nil then
      DataCenter.ActivityListDataManager:UpdateExtraData(DIG_DISPATCH_GUARANTEE_NUM, t[DIG_DISPATCH_GUARANTEE_NUM])
    end
    EventManager:GetInstance():Broadcast(EventId.DispatchTreasureDigReward, t)
  end
end

DispatchDigTreasureMessage.OnCreate = OnCreate
DispatchDigTreasureMessage.HandleMessage = HandleMessage
return DispatchDigTreasureMessage
