local UBStoreUpgradeMessage = BaseClass("UBStoreUpgradeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UBStoreUpgradeMessage:OnCreate(param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutLong("bUuid", param.bUuid)
    self.sfsObj:PutBool("useGold", param.useGold)
    if param.resources ~= nil then
      local arr = SFSArray.New()
      for k, v in pairs(param.resources) do
        local obj = SFSObject.New()
        obj:PutInt("type", k)
        obj:PutInt("value", v)
        arr:AddSFSObject(obj)
      end
      self.sfsObj:PutSFSArray("resources", arr)
    end
    if param.resourceItems ~= nil then
      local arr = SFSArray.New()
      for k, v in pairs(param.resourceItems) do
        local obj = SFSObject.New()
        obj:PutInt("type", k)
        obj:PutInt("value", v)
        arr:AddSFSObject(obj)
      end
      self.sfsObj:PutSFSArray("resourceItems", arr)
    end
    if param.items ~= nil then
      local arr = SFSArray.New()
      for k, v in pairs(param.items) do
        local obj = SFSObject.New()
        obj:PutUtfString("type", tostring(k))
        obj:PutInt("value", v)
        arr:AddSFSObject(obj)
      end
      self.sfsObj:PutSFSArray("items", arr)
    end
  end
end

function UBStoreUpgradeMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  DataCenter.BuildUpgradeStockManager:UBStoreUpgradeHandle(message)
end

return UBStoreUpgradeMessage
