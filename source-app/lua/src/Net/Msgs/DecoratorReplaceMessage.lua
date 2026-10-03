local DecoratorReplaceMessage = BaseClass("DecoratorReplaceMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, oldUUid, newUUid)
  base.OnCreate(self)
  self.sfsObj:PutLong("oldUUid", oldUUid)
  self.sfsObj:PutLong("newUUid", newUUid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIUtil.ShowTipsId("building_center_tips1")
    if t.buildInfo then
      DataCenter.BuildManager:AddBuilding(t.buildInfo)
    end
    if t.newBuildInfo then
      DataCenter.BuildManager:AddBuilding(t.newBuildInfo)
    end
    EventManager:GetInstance():Broadcast(EventId.DecorateReplace)
    EventManager:GetInstance():Broadcast(EventId.DecorateRedPoint)
  end
end

DecoratorReplaceMessage.OnCreate = OnCreate
DecoratorReplaceMessage.HandleMessage = HandleMessage
return DecoratorReplaceMessage
