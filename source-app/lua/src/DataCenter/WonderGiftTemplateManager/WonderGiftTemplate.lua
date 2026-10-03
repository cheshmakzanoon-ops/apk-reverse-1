local WonderGiftTemplate = BaseClass("WonderGiftTemplate")

function WonderGiftTemplate:__init()
  self.id = 0
  self.name = 0
  self.type = 0
  self.act_type = 0
  self.num = 0
  self.icon = ""
  self.worth = 0
  self.season = 0
end

function WonderGiftTemplate:__delete()
  self.id = 0
  self.name = 0
  self.type = 0
  self.act_type = 0
  self.num = 0
  self.icon = ""
  self.worth = 0
  self.season = 0
end

function WonderGiftTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.name = row:getValue("name")
  self.type = row:getValue("type")
  self.act_type = tonumber(row:getValue("act_type"))
  self.num = row:getValue("num")
  self.icon = row:getValue("icon")
  self.worth = row:getValue("worth") or 0
  self.season = row:getValue("season") or 0
  self.reward_show = row:getValue("reward_show")
end

return WonderGiftTemplate
