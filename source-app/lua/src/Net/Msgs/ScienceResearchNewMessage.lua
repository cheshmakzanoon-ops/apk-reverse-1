local ScienceResearchNewMessage = BaseClass("ScienceResearchNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutInt("itemId", param.itemId)
    self.sfsObj:PutInt("useGold", param.useGold)
    self.sfsObj:PutLong("bUuid", param.bUuid)
    if param.items then
      local itemIdStr = ""
      for i = 1, #param.items do
        if string.IsNullOrEmpty(itemIdStr) then
          itemIdStr = param.items[i].item.itemId .. ";" .. param.items[i].item.count
        else
          itemIdStr = itemIdStr .. "|" .. param.items[i].item.itemId .. ";" .. param.items[i].item.count
        end
      end
      self.sfsObj:PutUtfString("speedGoods", itemIdStr)
    end
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  EventManager:GetInstance():Broadcast(EventId.UnLockScienceResearchNewMsg)
  DataCenter.ScienceManager:ScienceResearchNewMessageHandle(t)
end

ScienceResearchNewMessage.OnCreate = OnCreate
ScienceResearchNewMessage.HandleMessage = HandleMessage
return ScienceResearchNewMessage
