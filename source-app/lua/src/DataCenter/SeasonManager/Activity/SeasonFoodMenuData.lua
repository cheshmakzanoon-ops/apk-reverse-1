local SeasonFoodMenuData = BaseClass("SeasonFoodMenuData")

function SeasonFoodMenuData:__init()
  self.id = nil
  self.group = nil
  self.food_item1 = nil
  self.food_item2 = nil
  self.food_item3 = nil
  self.food_item4 = nil
  self.food_goods = nil
  self.reward_prefect = nil
  self.reward_normal = nil
  self.weight = nil
  self.plot1 = nil
  self.plot2 = nil
  self.plot3 = nil
  self.plot4 = nil
end

function SeasonFoodMenuData:__delete()
end

function SeasonFoodMenuData:SetData(tableData)
  self.id = tableData.id
  self.group = tableData.group
  self.food_item1 = tableData.food_item1
  self.food_item2 = tableData.food_item2
  self.food_item3 = tableData.food_item3
  self.food_item4 = tableData.food_item4
  self.food_goods = tableData.food_goods
  self.reward_prefect = tableData.reward_prefect
  self.reward_normal = tableData.reward_normal
  self.weight = tableData.weight
  self.plot1 = tableData.plot1
  self.plot2 = tableData.plot2
  self.plot3 = tableData.plot3
  self.plot4 = tableData.plot4
  self.foods = {
    self.food_item1,
    self.food_item2,
    self.food_item3,
    self.food_item4
  }
  table.sort(self.foods, function(a, b)
    return b < a
  end)
  self.key = ""
  for index, value in ipairs(self.foods) do
    self.key = self.key .. tostring(value)
  end
end

function SeasonFoodMenuData:GetDataKey()
  return self.key
end

function SeasonFoodMenuData:GetFoodData()
  return self.foods
end

return SeasonFoodMenuData
