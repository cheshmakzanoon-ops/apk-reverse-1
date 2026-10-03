local WorldGetAllianceMarkMessage = BaseClass("WorldGetAllianceMarkMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.WorldFavoDataManager:OnInitAllianceMarkDic(t)
  end
end

WorldGetAllianceMarkMessage.HandleMessage = HandleMessage
WorldGetAllianceMarkMessage.OnCreate = OnCreate
return WorldGetAllianceMarkMessage
