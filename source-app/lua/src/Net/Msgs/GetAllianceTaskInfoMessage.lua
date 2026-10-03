local GetAllianceTaskInfoMessage = BaseClass("GetAllianceTaskInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, isSeason)
  base.OnCreate(self)
  self.sfsObj:PutBool("isSeason", isSeason == true)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.isSeason then
    DataCenter.AllianceSeasonTaskManager:UpdateAllianceTaskInfoDic(t)
  else
    DataCenter.AllianceTaskManager:UpdateAllianceTaskInfoDic(t)
  end
end

GetAllianceTaskInfoMessage.OnCreate = OnCreate
GetAllianceTaskInfoMessage.HandleMessage = HandleMessage
return GetAllianceTaskInfoMessage
