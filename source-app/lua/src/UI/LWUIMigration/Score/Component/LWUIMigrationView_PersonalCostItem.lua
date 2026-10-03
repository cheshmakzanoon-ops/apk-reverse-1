local LWUIMigrationView_PersonalCostItem = BaseClass("LWUIMigrationView_PersonalCostItem", UIBaseContainer)
local base = UIBaseContainer

function LWUIMigrationView_PersonalCostItem:OnCreate()
  base.OnCreate(self)
  self.img = self:AddComponent(UIImage, "")
  self.t1 = self:AddComponent(UIText, "T1")
  self.t2 = self:AddComponent(UIText, "T2")
  self.t3 = self:AddComponent(UIText, "T3")
  self.icon = self:AddComponent(UIImage, "CostIcon")
  local iconPath = DataCenter.ActMigrationManager:GetItemIcon()
  if iconPath then
    self.icon:LoadSpriteAuto(iconPath)
  end
end

function LWUIMigrationView_PersonalCostItem:OnDestroy()
  base.OnDestroy(self)
end

function LWUIMigrationView_PersonalCostItem:SetData(info, idx, myScore, colorList)
  local bMy = false
  if idx == 1 then
    local max = toInt(colorList[3])
    bMy = myScore < max
    self.t1:SetText("<" .. string.GetFormattedStr2(max))
  elseif idx == 2 then
    local max = toInt(colorList[2])
    local min = toInt(colorList[3])
    bMy = myScore >= min and myScore < max
    self.t1:SetText(string.GetFormattedStr2(min) .. "-" .. string.GetFormattedStr2(max))
  elseif idx == 3 then
    local max = toInt(colorList[1])
    local min = toInt(colorList[2])
    bMy = myScore >= min and myScore < max
    self.t1:SetText(string.GetFormattedStr2(min) .. "-" .. string.GetFormattedStr2(max))
  elseif idx == 4 then
    local min = toInt(colorList[1])
    bMy = myScore >= min
    self.t1:SetText(">" .. string.GetFormattedStr2(min))
  end
  self.t2:SetLocalText(info.name)
  self.t3:SetText("\195\151" .. (info.cost or 0))
  if bMy then
    self.t1:SetColorRGBA255(9, 155, 74, 255)
    self.t2:SetColorRGBA255(9, 155, 74, 255)
    self.t3:SetColorRGBA255(9, 155, 74, 255)
    self.img:SetColorRGBA255(221, 242, 186, 255)
  else
    self.t1:SetColorRGBA255(115, 104, 99, 255)
    self.t2:SetColorRGBA255(115, 104, 99, 255)
    self.t3:SetColorRGBA255(115, 104, 99, 255)
    self.img:SetColorRGBA(1, 1, 1, idx % 2 == 0 and 0.2 or 0)
  end
end

return LWUIMigrationView_PersonalCostItem
