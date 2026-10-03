local ActivityHunterFreeBoxTemplate = BaseClass("ActivityHunterFreeBoxTemplate")

function ActivityHunterFreeBoxTemplate:__init()
  self.id = 0
  self.group = 0
  self.rate = 0
  self.type = 0
  self.color = 0
  self.effect = ""
  self.prefab = ""
  self.reward = 0
  self.reward_show = ""
  self.name = ""
  self.desc = ""
  self.goods = ""
end

function ActivityHunterFreeBoxTemplate:__delete()
  self.id = nil
  self.group = nil
  self.rate = nil
  self.type = nil
  self.color = nil
  self.effect = nil
  self.prefab = nil
  self.reward = nil
  self.reward_show = nil
  self.name = nil
  self.desc = nil
  self.goods = nil
end

function ActivityHunterFreeBoxTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.group = rowData:getValue("group") or 0
  self.rate = rowData:getValue("rate") or 0
  self.type = rowData:getValue("type") or 0
  self.color = rowData:getValue("color") or 0
  self.effect = rowData:getValue("effect") or ""
  self.prefab = rowData:getValue("prefab") or ""
  self.reward = rowData:getValue("reward") or 0
  self.reward_show = rowData:getValue("reward_show") or ""
  self.name = rowData:getValue("name") or ""
  self.desc = rowData:getValue("desc") or ""
  self.goods = rowData:getValue("goods") or ""
end

return ActivityHunterFreeBoxTemplate
