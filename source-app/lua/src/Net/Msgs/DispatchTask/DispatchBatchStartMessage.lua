local DispatchBatchStartMessage = BaseClass("DispatchBatchStartMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DispatchBatchStartMessage:OnCreate(list)
  base.OnCreate(self)
  self.sfsObj:PutSFSArray("list", list)
end

function DispatchBatchStartMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
    return
  end
  if message.array then
    local uuidList = {}
    for _, one in ipairs(message.array) do
      if one then
        DataCenter.ActDispatchTaskDataManager:UpdateOneSingleTask(one, true)
        DataCenter.ActDispatchTaskFakeMarchManager:AddMarchIndex(one.pointId, LuaEntry.Player:GetMainWorldPos(), false)
        if one.uuid then
          table.insert(uuidList, one.uuid)
        end
      end
    end
    if 0 < #uuidList then
      DataCenter.InteractionBubbleManager:HandleDispatchStartMessage(uuidList)
    end
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

return DispatchBatchStartMessage
