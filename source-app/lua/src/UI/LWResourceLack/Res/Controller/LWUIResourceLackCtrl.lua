local LWUIResourceLackCtrl = BaseClass("LWUIResourceLackCtrl", UIBaseCtrl)

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWResourceLack, {anim = useAnimation})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetHaveResCount(ContextType, itemId)
  local have = 0
  if ContextType == ResLackContextType.ResItem then
    have = DataCenter.ResourceItemDataManager:GetCountByItemId(itemId)
  elseif ContextType == ResLackContextType.Good then
    have = DataCenter.ItemData:GetItemCount(itemId)
  elseif ContextType == ResLackContextType.Soldier then
    have = DataCenter.SoldierDataManager:GetPlayerSoldiers(SoldierType.Player)
  else
    have = LuaEntry.Resource:GetCntByResType(itemId)
  end
  return have
end

LWUIResourceLackCtrl.CloseSelf = CloseSelf
LWUIResourceLackCtrl.Close = Close
LWUIResourceLackCtrl.GetHaveResCount = GetHaveResCount
return LWUIResourceLackCtrl
