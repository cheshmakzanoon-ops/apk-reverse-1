local UISoldierDetailsCtrl = BaseClass("UIShowFakeNewHeroCtrl", UIBaseCtrl)

function UISoldierDetailsCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISoldierDetails)
end

function UISoldierDetailsCtrl:GetCitySoldiersInfo()
  local param = {}
  param.soldiers = DataCenter.SoldierDataManager:GetInsideSoldiers()
  table.sort(param.soldiers, function(a, b)
    return a.lv < b.lv
  end)
  param.content = 135219
  param.name = 135217
  param.outside = false
  return param
end

function UISoldierDetailsCtrl:GetOutsideSoldiersInfo()
  local param = {}
  param.soldiers = DataCenter.SoldierDataManager:GetOutsideSoldiers()
  table.sort(param.soldiers, function(a, b)
    return a.lv < b.lv
  end)
  param.content = 135220
  param.name = 135218
  param.outside = true
  return param
end

return UISoldierDetailsCtrl
