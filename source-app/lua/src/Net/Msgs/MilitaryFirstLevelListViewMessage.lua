local MilitaryFirstLevelListViewMessage = BaseClass("MilitaryFirstLevelListViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MilitaryFirstLevelListViewMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("viewLevel", param.viewLevel)
end

function MilitaryFirstLevelListViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonMilitaryManager:OnRoralCallback(t)
  end
end

return MilitaryFirstLevelListViewMessage
