local UIRedEquipLimitTipCtrl = BaseClass("UIExitGameTipCtrl", UIBaseCtrl)

function UIRedEquipLimitTipCtrl:GetAllEquipList()
  local allEquips = DataCenter.EquipDataManager:GetAllEquipList()
  local equiped_list = {}
  local unequiped_list = {}
  table.walk(allEquips, function(k, v)
    if v.config.quality == 5 then
      local equiped = v.heroUuid and v.heroUuid > 0
      if equiped then
        table.insert(equiped_list, v)
      else
        table.insert(unequiped_list, v)
      end
    end
  end)
  table.sort(equiped_list, function(a, b)
    return self:EquipSortFunc(a, b)
  end)
  table.sort(unequiped_list, function(a, b)
    return self:EquipSortFunc(a, b)
  end)
  local result = {}
  table.walk(equiped_list, function(k, v)
    table.insert(result, v)
  end)
  table.walk(unequiped_list, function(k, v)
    table.insert(result, v)
  end)
  return result
end

function UIRedEquipLimitTipCtrl:EquipSortFunc(lValue, rValue)
  if lValue.level ~= rValue.level then
    return lValue.level > rValue.level
  else
    return lValue.config.id < rValue.config.id
  end
end

function UIRedEquipLimitTipCtrl:CloseSelf(self, noPlayCloseEffect)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRedEquipLimitTip)
end

function UIRedEquipLimitTipCtrl:Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

return UIRedEquipLimitTipCtrl
