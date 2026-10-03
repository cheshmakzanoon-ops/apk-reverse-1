local ViewBloodNightTaskMessage = BaseClass("ViewBloodNightTaskMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ViewBloodNightTaskMessage:OnCreate(stageId)
  base.OnCreate(self)
  self.sfsObj:PutInt("planId", stageId)
end

function ViewBloodNightTaskMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.userBloodNightTaskArr or t.allianceBloodNightTaskArr then
    DataCenter.BloodyNightDataManager:HandleTaskList(t)
  end
end

return ViewBloodNightTaskMessage
