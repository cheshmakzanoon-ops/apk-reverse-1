local VipExtendPrivilegeTemplate = BaseClass("VipExtendPrivilegeTemplate")

function VipExtendPrivilegeTemplate:__init()
  self.id = 0
  self.displayPage = 0
  self.if_display = 0
  self.display_para1 = 0
  self.display_para2 = 0
  self.display_para3 = 0
  self.order = 0
end

function VipExtendPrivilegeTemplate:__delete()
  self.id = nil
  self.displayPage = nil
  self.if_display = nil
  self.display_para1 = nil
  self.display_para2 = nil
  self.display_para3 = nil
  self.order = nil
end

function VipExtendPrivilegeTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.displayPage = row:getValue("displayPage")
  self.if_display = row:getValue("if_display")
  self.display_para1 = row:getValue("display_para1")
  self.display_para2 = row:getValue("display_para2")
  self.display_para3 = row:getValue("display_para3")
  self.order = row:getValue("displayOrder")
end

return VipExtendPrivilegeTemplate
