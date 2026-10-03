local WorldTriggerTemplate = BaseClass("WorldTriggerTemplate")

function WorldTriggerTemplate:__init()
end

function WorldTriggerTemplate:__delete()
  self.effect = nil
end

function WorldTriggerTemplate:InitConfig(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.type = row:getValue("type")
  self.level = row:getValue("level")
  self.name = row:getValue("name")
  self.desc = row:getValue("desc")
  self.desc_more = row:getValue("desc_more")
  self.desc_more_para = row:getValue("desc_more_para")
  self.effect_number = row:getValue("effect_num")
  self.effect = row:getValue("effect")
  self.size = row:getValue("size")
  self.time = row:getValue("time")
  self.grayIcon = row:getValue("grayIcon")
  self.icon = row:getValue("icon")
  self.prefab = row:getValue("prefab")
  self.battle_report = row:getValue("battle_report")
  self.explode = row:getValue("explode")
  self.plot = row:getValue("plot")
end

function WorldTriggerTemplate:GetName()
  return CS.GameEntry.Localization:GetString(self.name, self.level)
end

return WorldTriggerTemplate
