local WorldDelCountryMarkMessage = BaseClass("WorldDelCountryMarkMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, markType)
  base.OnCreate(self)
  self.sfsObj:PutInt("markType", markType)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.WorldFavoDataManager:OnDelCountryMark(t)
  end
end

WorldDelCountryMarkMessage.OnCreate = OnCreate
WorldDelCountryMarkMessage.HandleMessage = HandleMessage
return WorldDelCountryMarkMessage
