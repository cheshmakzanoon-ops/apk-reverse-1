local DiscountShopOpenMessage = BaseClass("DiscountShopOpenMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.success == 1 then
    UIUtil.ShowTipsId(372335)
    SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(t.activityId))
  end
end

DiscountShopOpenMessage.OnCreate = OnCreate
DiscountShopOpenMessage.HandleMessage = HandleMessage
return DiscountShopOpenMessage
