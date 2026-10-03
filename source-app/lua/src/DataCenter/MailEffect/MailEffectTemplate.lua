local MailEffectTemplate = BaseClass("MailEffectTemplate")

local function __init(self)
end

local function __delete(self)
  self.effectId = nil
  self.effectName = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.icon = row:getValue("icon")
  self.desc = row:getValue("desc")
  self.effectId = row:getValue("effectId")
  self.effectId = string.split(self.effectId, "|")
  for i = 1, #self.effectId do
    self.effectId[i] = tonumber(self.effectId[i])
  end
  local effectName = row:getValue("effectName")
  self.effectName = string.split(effectName, "|")
  if #self.effectId ~= #self.effectName then
    Logger.LogError(string.format("\233\133\141\232\161\168lw_technical_report\231\154\132%s\232\161\140effectId\229\146\140effectName\230\149\176\233\135\143\228\184\141\228\184\128\232\135\180", self.id))
  end
  self.scienceId = row:getValue("sciRouter")
  self.scienceId = string.split(self.scienceId, "|")
  for i = 1, #self.scienceId do
    self.scienceId[i] = tonumber(self.scienceId[i])
  end
end

MailEffectTemplate.__init = __init
MailEffectTemplate.__delete = __delete
MailEffectTemplate.InitData = InitData
return MailEffectTemplate
