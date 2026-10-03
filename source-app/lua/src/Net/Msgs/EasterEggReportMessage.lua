local EasterEggReportMessage = BaseClass("EasterEggReportMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EasterEggReportMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutLong("msgCreateTime", param.msgCreateTime)
  self.sfsObj:PutUtfString("reportUid", param.reportUid)
  local array = SFSArray.New()
  table.walk(param.reportTypes, function(k, v)
    array:AddInt(k)
  end)
  self.sfsObj:PutSFSArray("reportTypes", array)
  self.sfsObj:PutUtfString("content", param.content)
  self.sfsObj:PutUtfString("custom", param.custom)
  self.sfsObj:PutUtfString("eggUuid", param.eggUuid)
  local extra = {}
  extra.eggUuid = param.eggUuid
  self.sfsObj:PutLuaTable("extra", extra)
end

function EasterEggReportMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return EasterEggReportMessage
