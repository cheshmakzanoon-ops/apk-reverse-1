local UpgradeTreasureBoxTemplate = BaseClass("UpgradeTreasureBoxTemplate")

local function __init(self)
  self.id = 0
  self.group = 0
  self.box_id = 0
  self.is_init = ""
  self.box_effect = 0
  self.box_prefab = ""
  self.level_group = ""
  self.box_name = ""
  self.box_goods = ""
  self.color = 0
  self.upgradeBoxShowPara = ""
end

local function __delete(self)
  self.id = nil
  self.group = nil
  self.box_id = nil
  self.is_init = nil
  self.box_effect = nil
  self.box_prefab = nil
  self.level_group = nil
  self.box_name = nil
  self.box_goods = nil
  self.color = nil
  self.upgradeBoxShowPara = nil
end

local function UpdateData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.group = row:getValue("group")
  self.box_id = row:getValue("box_id")
  self.is_init = row:getValue("is_init")
  self.box_effect = row:getValue("box_effect")
  self.box_prefab = row:getValue("box_prefab")
  self.level_group = row:getValue("level_group")
  self.box_name = row:getValue("box_name")
  self.box_goods = row:getValue("box_goods")
  self.color = row:getValue("color")
  self.upgradeBoxShowPara = row:getValue("upgradebox_showpara")
end

UpgradeTreasureBoxTemplate.__init = __init
UpgradeTreasureBoxTemplate.__delete = __delete
UpgradeTreasureBoxTemplate.UpdateData = UpdateData
return UpgradeTreasureBoxTemplate
