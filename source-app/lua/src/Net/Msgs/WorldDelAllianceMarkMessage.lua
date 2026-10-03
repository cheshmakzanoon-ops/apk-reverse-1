local WorldDelAllianceMarkMessage = BaseClass("WorldDelAllianceMarkMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, marktype)
  base.OnCreate(self)
  self.sfsObj:PutInt("markType", marktype)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.WorldFavoDataManager:OnDelAllianceMark(t)
  end
end

WorldDelAllianceMarkMessage.OnCreate = OnCreate
WorldDelAllianceMarkMessage.HandleMessage = HandleMessage
return WorldDelAllianceMarkMessage
