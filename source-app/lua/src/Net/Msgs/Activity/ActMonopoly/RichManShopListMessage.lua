local RichManShopListMessage = BaseClass("RichManShopListMessage", SFSBaseMessage)
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
  else
    DataCenter.ActMonopolyDataManager:OnGetShopListDataMsg(t)
    EventManager:GetInstance():Broadcast(EventId.GetActMonopolyShopMsg)
  end
end

RichManShopListMessage.OnCreate = OnCreate
RichManShopListMessage.HandleMessage = HandleMessage
return RichManShopListMessage
