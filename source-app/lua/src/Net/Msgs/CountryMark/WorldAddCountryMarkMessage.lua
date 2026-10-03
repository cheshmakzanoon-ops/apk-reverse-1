local WorldAddCountryMarkMessage = BaseClass("WorldAddCountryMarkMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, markType, point, pointWorldId, pointServerId, pointInfo, planTimeStamp, notice)
  base.OnCreate(self)
  self.sfsObj:PutInt("markType", markType)
  self.sfsObj:PutInt("point", point)
  self.sfsObj:PutInt("pointWorldId", pointWorldId or LuaEntry.Player:GetCurWorldId())
  self.sfsObj:PutInt("pointServerId", pointServerId)
  if pointInfo ~= nil and pointInfo ~= "" then
    self.sfsObj:PutUtfString("pointInfo", pointInfo)
  end
  if planTimeStamp and 0 < planTimeStamp then
    self.sfsObj:PutLong("planTimeStamp", planTimeStamp)
    self.sfsObj:PutBool("notice", notice == true)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.errorPara2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(t.errorPara2)))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    DataCenter.WorldFavoDataManager:HandleAddCountryMarkMessage(t)
  end
end

WorldAddCountryMarkMessage.OnCreate = OnCreate
WorldAddCountryMarkMessage.HandleMessage = HandleMessage
return WorldAddCountryMarkMessage
