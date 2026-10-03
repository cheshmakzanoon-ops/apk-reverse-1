local WorldGetCountryMarkMessage = BaseClass("WorldGetCountryMarkMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.WorldFavoDataManager:OnInitCountryMarkDic(t)
  end
end

WorldGetCountryMarkMessage.OnCreate = OnCreate
WorldGetCountryMarkMessage.HandleMessage = HandleMessage
return WorldGetCountryMarkMessage
