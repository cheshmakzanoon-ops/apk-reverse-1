local ActiveGolloesFuncMessage = BaseClass("ActiveGolloesFuncMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, golloesParam)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", golloesParam)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.GolloesCampManager:UpdateGolloesInfo(t)
  end
end

ActiveGolloesFuncMessage.OnCreate = OnCreate
ActiveGolloesFuncMessage.HandleMessage = HandleMessage
return ActiveGolloesFuncMessage
