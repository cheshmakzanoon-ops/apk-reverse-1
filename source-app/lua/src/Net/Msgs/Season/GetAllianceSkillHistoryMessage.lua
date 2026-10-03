local GetAllianceSkillHistoryMessage = BaseClass("GetAllianceSkillHistoryMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetAllianceSkillHistoryMessage:OnCreate(pageNum, pageSize, skillFlag)
  base.OnCreate(self)
  self.sfsObj:PutInt("pageNum", pageNum)
  self.sfsObj:PutInt("pageSize", pageSize or 100)
  self.sfsObj:PutInt("skillType", skillFlag or 0)
end

function GetAllianceSkillHistoryMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  EventManager:GetInstance():Broadcast(EventId.LWSeasonGovernmentSkillHistory, t)
end

return GetAllianceSkillHistoryMessage
