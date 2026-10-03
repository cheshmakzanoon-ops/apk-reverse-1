local SurprisePointGetInfoMessage = BaseClass("SurprisePointGetInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.SurprisePointManager:OnSurprisePointGetInfo(t.pointIds, t.totalSize)
end

local function GetTestData(self)
end

SurprisePointGetInfoMessage.GetTestData = GetTestData
SurprisePointGetInfoMessage.OnCreate = OnCreate
SurprisePointGetInfoMessage.HandleMessage = HandleMessage
return SurprisePointGetInfoMessage
