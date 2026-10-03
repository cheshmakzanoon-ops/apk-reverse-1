local DecoratorUpgradeMessage = BaseClass("DecoratorUpgradeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, buildUuid, decortores)
  base.OnCreate(self)
  self.sfsObj:PutLong("buildUuid", buildUuid)
  if decortores then
    local decortorArray = SFSArray.New()
    local itemId = ""
    for i, decortor in pairs(decortores) do
      itemId = tostring(decortor.itemId)
      local glueGoodIdStr = tostring(GLUE_GOOD_ID)
      if not string.IsNullOrEmpty(itemId) and itemId ~= glueGoodIdStr and decortor.count > 0 then
        local obj = SFSObject.New()
        obj:PutUtfString("itemId", tostring(decortor.itemId))
        obj:PutInt("count", decortor.count)
        decortorArray:AddSFSObject(obj)
      elseif not string.IsNullOrEmpty(itemId) and itemId == glueGoodIdStr and decortor.count > 0 then
        local obj = SFSObject.New()
        obj:PutUtfString("itemId", glueGoodIdStr)
        obj:PutInt("count", decortor.count)
        local itemArray = SFSArray.New()
        itemArray:AddSFSObject(obj)
        self.sfsObj:PutSFSArray("costItem", itemArray)
      end
    end
    self.sfsObj:PutSFSArray("cost", decortorArray)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BuildManager:HandleDecorationUpgradeMessage(t)
  end
  EventManager:GetInstance():Broadcast(EventId.DecoratorLevelUpgradeMessageOnReceive)
end

DecoratorUpgradeMessage.OnCreate = OnCreate
DecoratorUpgradeMessage.HandleMessage = HandleMessage
return DecoratorUpgradeMessage
