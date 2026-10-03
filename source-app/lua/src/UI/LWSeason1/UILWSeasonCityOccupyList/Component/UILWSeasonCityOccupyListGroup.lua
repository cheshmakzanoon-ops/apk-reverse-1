local UILWSeasonCityOccupyListGroup = BaseClass("UILWSeasonCityOccupyListGroup", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local OccupyListItem = require("UI.LWSeason1.UILWSeasonCityOccupyList.Component.UILWSeasonCityOccupyListItem")

function UILWSeasonCityOccupyListGroup:OnCreate()
  base.OnCreate(self)
  self.city_item1 = self:AddComponent(OccupyListItem, "UIAttackCityItem1")
  self.city_item2 = self:AddComponent(OccupyListItem, "UIAttackCityItem2")
  self.city_item3 = self:AddComponent(OccupyListItem, "UIAttackCityItem3")
end

function UILWSeasonCityOccupyListGroup:OnDestroy()
  self.city_item1 = nil
  self.city_item2 = nil
  self.city_item3 = nil
  base.OnDestroy(self)
end

function UILWSeasonCityOccupyListGroup:ReInit(index, data, serverId)
  if data then
    local dataList = data.data
    if dataList then
      self.city_item1:SetActive(dataList[1] ~= nil)
      self.city_item2:SetActive(dataList[2] ~= nil)
      self.city_item3:SetActive(dataList[3] ~= nil)
      if dataList[1] ~= nil then
        self.city_item1:ReInit(1, dataList[1], serverId)
      end
      if dataList[2] ~= nil then
        self.city_item2:ReInit(2, dataList[2], serverId)
      end
      if dataList[3] ~= nil then
        self.city_item3:ReInit(3, dataList[3], serverId)
      end
      return
    end
  end
  self.city_item1:SetActive(false)
  self.city_item2:SetActive(false)
  self.city_item3:SetActive(false)
end

return UILWSeasonCityOccupyListGroup
