local ViewBloodNightActMessage = BaseClass("ViewBloodNightActMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ViewBloodNightActMessage:OnCreate(serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
  if IsNumber(serverId) and (serverId <= 2 or serverId == 4 or serverId == 7) then
    Logger.LogError("\228\184\141\229\173\152\229\156\168\231\154\132\230\156\141\229\138\161\229\153\168\239\188\129 ViewBloodNightActMessage:OnCreate " .. serverId)
  end
end

function ViewBloodNightActMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
  else
    DataCenter.BloodyNightDataManager:HandleActivityData(t)
  end
end

return ViewBloodNightActMessage
