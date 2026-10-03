local UISetPlayerNationCtrl = BaseClass("UISetPlayerNationCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UISetPlayerNation)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function GetAllNationsSorted(self)
  local nationList = DataCenter.NationTemplateManager:GetAllNationsList()
  local playerNation = LuaEntry.Player.countryFlag
  table.sort(nationList, function(a, b)
    if a.nation == playerNation then
      return true
    elseif b.nation == playerNation then
      return false
    else
      return a.order < b.order
    end
  end)
  return nationList
end

UISetPlayerNationCtrl.CloseSelf = CloseSelf
UISetPlayerNationCtrl.Close = Close
UISetPlayerNationCtrl.GetAllNationsSorted = GetAllNationsSorted
return UISetPlayerNationCtrl
