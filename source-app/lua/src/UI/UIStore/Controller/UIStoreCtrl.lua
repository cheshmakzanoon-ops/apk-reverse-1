local UIBagCtrl = BaseClass("UIBagCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIStore)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function GetStoreBtnTypeData(self)
  local mainLv = DataCenter.BuildManager.MainLv
  local result = {}
  for k, v in pairs(UIBagBtnType) do
    local list = DataCenter.ItemTemplateManager:GetStoreByBtnType(v)
    if list ~= nil then
      for k1, v1 in pairs(list) do
        local lv = v1.lv
        if mainLv >= lv then
          self:AddOneUIBagBtnType(result, v, v1)
        end
      end
    end
  end
  return result
end

local function AddOneUIBagBtnType(self, result, type, value)
  local list = result[type]
  if list == nil then
    result[type] = {value}
  else
    table.insert(list, value)
  end
end

local function GetBtnTypeName(self, type)
  if type == UIBagBtnType.Hot then
    return Localization:GetString("320013")
  elseif type == UIBagBtnType.War then
    return Localization:GetString("100158")
  elseif type == UIBagBtnType.Buff then
    return Localization:GetString("100162")
  elseif type == UIBagBtnType.Resource then
    return Localization:GetString("100024")
  elseif type == UIBagBtnType.Other then
    return Localization:GetString("100374")
  end
end

local function OnItemBuy(self, id, count)
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(id)
  local price = template.price
  if LuaEntry.Player.gold < price * count then
    UIUtil.ShowTipsId("E100001")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.UIShopBuy, {itemId = id, num = count})
end

UIBagCtrl.CloseSelf = CloseSelf
UIBagCtrl.Close = Close
UIBagCtrl.GetStoreBtnTypeData = GetStoreBtnTypeData
UIBagCtrl.AddOneUIBagBtnType = AddOneUIBagBtnType
UIBagCtrl.GetBtnTypeName = GetBtnTypeName
UIBagCtrl.OnItemBuy = OnItemBuy
return UIBagCtrl
