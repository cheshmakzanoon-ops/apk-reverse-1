local MonsterShopInfoMessage = BaseClass("MonsterShopInfoMessage", SFSBaseMessage)
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
    DataCenter.ActivityMonsterInvasionDataManager:UpdateActShopData(t)
    EventManager:GetInstance():Broadcast(EventId.MonsterInvasionShopDataUpdate)
  end
end

MonsterShopInfoMessage.OnCreate = OnCreate
MonsterShopInfoMessage.HandleMessage = HandleMessage
return MonsterShopInfoMessage
