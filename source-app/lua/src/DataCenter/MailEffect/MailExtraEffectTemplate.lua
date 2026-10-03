local MailExtraEffectTemplate = BaseClass("MailExtraEffectTemplate")

local function __init(self)
end

local function __delete(self)
  self.effectId = nil
  self.effectName = nil
  self.othertabtype = nil
  self.groupid = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.icon = row:getValue("icon")
  self.desc = row:getValue("desc")
  local eidStr = row:getValue("effectId") or "0"
  local eidNum = tonumber(eidStr) or 0
  self.effectId = {eidNum}
  local ename = row:getValue("effectName") or ""
  self.effectName = {ename}
  local gtStr = row:getValue("gotoType") or "0"
  local gpStr = row:getValue("gotoParam") or "0"
  self.gotoType = {
    tonumber(gtStr) or 0
  }
  self.gotoParam = {
    tonumber(gpStr) or 0
  }
  self.othertabtype = tonumber(row:getValue("othertabtype")) or 0
  self.groupid = row:getValue("groupid") or ""
end

MailExtraEffectTemplate.__init = __init
MailExtraEffectTemplate.__delete = __delete
MailExtraEffectTemplate.InitData = InitData
return MailExtraEffectTemplate
