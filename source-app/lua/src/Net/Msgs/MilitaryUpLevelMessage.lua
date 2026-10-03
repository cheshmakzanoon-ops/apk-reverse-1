local MilitaryUpLevelMessage = BaseClass("MilitaryUpLevelMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MilitaryUpLevelMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("viewLevel", param.level)
end

function MilitaryUpLevelMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t ~= nil then
    DataCenter.SeasonMilitaryManager:OnLevelUpCallback(t)
  end
end

return MilitaryUpLevelMessage
