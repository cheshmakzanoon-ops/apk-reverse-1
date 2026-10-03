local AllianceGroupDescriptionViewOpenMessage = BaseClass("AllianceGroupDescriptionViewOpenMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceGroupDescriptionViewOpenMessage:OnCreate(param)
  base.OnCreate(self)
  if param.viewOpen ~= nil then
    self.sfsObj:PutInt("viewOpen", param.viewOpen)
  end
end

function AllianceGroupDescriptionViewOpenMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    EventManager:GetInstance():Broadcast(EventId.Al_RankVisibleModify, {})
  else
    local param = {
      result = t.result,
      viewOpen = t.viewOpen or 1
    }
    EventManager:GetInstance():Broadcast(EventId.Al_RankVisibleModify, param)
    if param.result == 0 then
      DataCenter.AllianceMemberDataManager:UpdateAllianceRankVisible(t.viewOpen)
    end
  end
end

return AllianceGroupDescriptionViewOpenMessage
