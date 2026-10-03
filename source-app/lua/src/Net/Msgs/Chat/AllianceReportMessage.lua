local AllianceReportMessage = BaseClass("AllianceReportMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, allianceId, type, reportTypeList, content, extraNote, extraInfo)
  local array = SFSArray.New()
  table.walk(reportTypeList, function(k, v)
    array:AddInt(k)
  end)
  self.sfsObj:PutSFSArray("reportTypes", array)
  self.sfsObj:PutUtfString("allianceId", allianceId)
  self.sfsObj:PutInt("type", type)
  content = content or ""
  self.sfsObj:PutUtfString("content", content)
  if not string.IsNullOrEmpty(extraNote) then
    self.sfsObj:PutUtfString("custom", tostring(extraNote))
  end
  if not string.IsNullOrEmpty(extraInfo) then
    self.sfsObj:PutUtfString("extraInfo", extraInfo)
  end
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
end

AllianceReportMessage.OnCreate = OnCreate
AllianceReportMessage.HandleMessage = HandleMessage
return AllianceReportMessage
