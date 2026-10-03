local LetterConfigTemplate = BaseClass("LetterConfigTemplate")

function LetterConfigTemplate:__init()
  self.id = 0
  self.group = 0
  self.condition = ""
  self.type = 0
  self.goods = ""
  self.extra_display = ""
  self.title = ""
  self.desc = ""
  self.icon = ""
  self.effect_prefab = ""
  self.extra_pic = ""
  self.mail_bubble_pic = ""
end

function LetterConfigTemplate:__delete()
  self.id = nil
  self.group = nil
  self.condition = nil
  self.type = nil
  self.goods = nil
  self.extra_display = nil
  self.title = nil
  self.desc = nil
  self.icon = nil
  self.effect_prefab = nil
  self.extra_pic = nil
  self.mail_bubble_pic = nil
end

function LetterConfigTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.group = rowData:getValue("group") or 0
  self.condition = rowData:getValue("condition") or ""
  self.type = rowData:getValue("type") or 0
  self.goods = rowData:getValue("goods") or ""
  self.extra_display = rowData:getValue("extra_display") or ""
  self.title = rowData:getValue("title") or ""
  self.desc = rowData:getValue("desc") or ""
  self.icon = rowData:getValue("icon") or ""
  self.effect_prefab = rowData:getValue("effect_prefab") or ""
  self.extra_pic = rowData:getValue("extra_pic") or ""
  self.mail_bubble_pic = rowData:getValue("mail_bubble_pic") or ""
end

return LetterConfigTemplate
