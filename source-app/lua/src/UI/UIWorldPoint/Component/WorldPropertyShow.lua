local WorldPropertyShow = BaseClass("WorldPropertyShow", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local property_name1_path = "root/List/item1/propertyName1"
local value1_path = "root/List/item1/value1"
local property_name2_path = "root/List/item2/propertyName2"
local value2_path = "root/List/item2/value2"
local property_name3_path = "root/List/item3/propertyName3"
local value3_path = "root/List/item3/value3"

function WorldPropertyShow:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function WorldPropertyShow:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function WorldPropertyShow:ComponentDefine()
  self.property_name = self:AddComponent(UIText, property_name1_path)
  self.value = self:AddComponent(UIText, value1_path)
  self.property_name1 = self:AddComponent(UIText, property_name2_path)
  self.value1 = self:AddComponent(UIText, value2_path)
  self.property_name2 = self:AddComponent(UIText, property_name3_path)
  self.value2 = self:AddComponent(UIText, value3_path)
  self.property_name:SetLocalText(GameDialogDefine.POWER)
  self.property_name1:SetLocalText(GameDialogDefine.KILL_NUM)
  self.property_name2:SetLocalText(GameDialogDefine.ALLIANCE)
end

function WorldPropertyShow:ComponentDestroy()
  self.property_name = nil
  self.value = nil
  self.property_name1 = nil
  self.value1 = nil
  self.property_name2 = nil
  self.value2 = nil
end

function WorldPropertyShow:RefreshData(pointData)
  self.serverData = pointData
  if self.serverData.playerData.alAbbr ~= nil and self.serverData.playerData.alAbbr ~= "" then
    self.value2:SetText("[" .. self.serverData.playerData.alAbbr .. "]" .. self.serverData.playerData.allianceName)
  else
    self.value2:SetText("-")
  end
  self.value:SetText(string.GetFormattedSeperatorNum(math.floor(self.serverData.playerData.power)))
  self.value1:SetText(string.GetFormattedSeperatorNum(math.floor(self.serverData.playerData.armyKill)))
end

return WorldPropertyShow
