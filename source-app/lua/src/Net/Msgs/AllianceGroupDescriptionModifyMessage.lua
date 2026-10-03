local AllianceGroupDescriptionModifyMessage = BaseClass("AllianceGroupDescriptionModifyMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceGroupDescriptionModifyMessage:OnCreate(param)
  base.OnCreate(self)
  if param.viewOpen ~= nil then
    self.sfsObj:PutInt("viewOpen", param.viewOpen)
  end
  if param.groupDescription then
    self.sfsObj:PutUtfStringArray("groupDescription", param.groupDescription)
  end
end

function AllianceGroupDescriptionModifyMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    EventManager:GetInstance():Broadcast(EventId.Al_RankNameModify, {})
  else
    local param = {
      result = t.result,
      groupDescription = t.groupDescription or {},
      viewOpen = t.viewOpen or 1
    }
    EventManager:GetInstance():Broadcast(EventId.Al_RankNameModify, param)
    if param.result == 0 then
      DataCenter.AllianceMemberDataManager:UpdateAllianceRankName(t.groupDescription)
      DataCenter.AllianceMemberDataManager:UpdateAllianceRankVisible(t.viewOpen)
      EventManager:GetInstance():Broadcast(EventId.AllianceMember)
    end
  end
end

return AllianceGroupDescriptionModifyMessage
