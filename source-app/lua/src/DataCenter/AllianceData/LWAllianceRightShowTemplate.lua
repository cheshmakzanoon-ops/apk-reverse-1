local LWAllianceRightShowTemplate = BaseClass("LWAllianceRightShowTemplate")

function LWAllianceRightShowTemplate:__init()
  self.id = 0
  self.gift_lv = 0
  self.icon = ""
  self.title = ""
  self.desc = ""
  self.type = 0
  self.para1 = 0
  self.is_train_right = 0
end

function LWAllianceRightShowTemplate:__delete()
  self.id = nil
  self.gift_lv = nil
  self.icon = nil
  self.title = nil
  self.desc = nil
  self.type = nil
  self.para1 = nil
  self.is_train_right = nil
end

function LWAllianceRightShowTemplate:Init(row)
  self.id = row:getValue("id") or 0
  self.gift_lv = row:getValue("gift_lv") or 0
  self.icon = row:getValue("icon") or ""
  self.title = row:getValue("title") or ""
  self.desc = row:getValue("desc") or ""
  self.type = tonumber(row:getValue("type")) or 0
  self.para1 = row:getValue("para1") or 0
  self.is_train_right = tonumber(row:getValue("is_train_right")) or 0
end

function LWAllianceRightShowTemplate:GetTypeValue()
  if self.type == AlliancePrivilegeType.R4Expansion or self.type == AlliancePrivilegeType.DetectTreasureGetRewardNumExpansion then
    return tonumber(self.para1)
  end
end

return LWAllianceRightShowTemplate
