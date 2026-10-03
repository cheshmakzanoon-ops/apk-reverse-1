local LWMakingCoffeeCtrl = BaseClass("LWMakingCoffeeCtrl", UIBaseCtrl)

function LWMakingCoffeeCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWMakingCoffeeView)
end

function LWMakingCoffeeCtrl:GetRow(list)
  local result = {}
  local i = 1
  if not list then
    return result
  end
  while i <= #list do
    local group = {}
    group.list = {}
    group.isRow = true
    table.insert(group.list, list[i])
    if i + 1 <= #list then
      table.insert(group.list, list[i + 1])
    end
    if i + 2 <= #list then
      table.insert(group.list, list[i + 2])
    end
    table.insert(result, group)
    i = i + 3
  end
  return result
end

local function SortCoffeeList(list)
  table.sort(list, function(a, b)
    return a.order < b.order
  end)
end

function LWMakingCoffeeCtrl:GetAllCoffee(selectCoffeeId)
  local allList = DataCenter.MakingCoffeeTemplateManager:GetAllCoffeeList()
  if not allList then
    return {}, nil
  end
  allList = DeepCopy(allList)
  local unlockedList, lockedList, canUnlockedList = {}, {}, {}
  for _, config in pairs(allList) do
    if DataCenter.MakingCoffeeManager:GetIsUnlock(config.id) then
      table.insert(unlockedList, config)
    elseif DataCenter.MakingCoffeeManager:IsCanUnlocked(config.id) then
      table.insert(canUnlockedList, config)
    else
      table.insert(lockedList, config)
    end
  end
  SortCoffeeList(unlockedList)
  SortCoffeeList(lockedList)
  SortCoffeeList(canUnlockedList)
  local finalList = {}
  for _, c in ipairs(unlockedList) do
    table.insert(finalList, c)
  end
  for _, c in ipairs(canUnlockedList) do
    table.insert(finalList, c)
  end
  for _, c in ipairs(lockedList) do
    table.insert(finalList, c)
  end
  local rowList = self:GetRow(finalList)
  local targetConfig, targetRowIndex
  if selectCoffeeId then
    for rowIndex, group in ipairs(rowList) do
      for _, c in ipairs(group.list) do
        if c.id == selectCoffeeId then
          targetConfig = c
          targetRowIndex = rowIndex
          break
        end
      end
      if targetRowIndex then
        break
      end
    end
  end
  if not targetConfig then
    for _, config in ipairs(unlockedList) do
      if not targetConfig or config.order > targetConfig.order then
        targetConfig = config
      end
    end
    if targetConfig then
      for rowIndex, group in ipairs(rowList) do
        for _, c in ipairs(group.list) do
          if c.id == targetConfig.id then
            targetRowIndex = rowIndex
            break
          end
        end
        if targetRowIndex then
          break
        end
      end
    end
  end
  targetRowIndex = targetRowIndex or 1
  return rowList, targetRowIndex, targetConfig
end

return LWMakingCoffeeCtrl
