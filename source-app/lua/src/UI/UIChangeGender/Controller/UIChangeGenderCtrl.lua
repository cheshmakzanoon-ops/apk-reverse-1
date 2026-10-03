local UIChangeGenderCtrl = BaseClass("UIChangeGenderCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChangeGender)
end

local function GetConsumeDiamond(self)
  return DataCenter.ItemTemplateManager:GetItemPrice(SpecialItemId.CHANGE_GENDER)
end

local function GetPayType(self)
  local pay_type = 1
  if LuaEntry.Player:GetGender() == 0 then
    pay_type = 0
  end
  return pay_type
end

local function SendChangeGenderMessage(self, value)
  SFSNetwork.SendMessage(MsgDefines.GenderChange, value)
end

UIChangeGenderCtrl.CloseSelf = CloseSelf
UIChangeGenderCtrl.GetConsumeDiamond = GetConsumeDiamond
UIChangeGenderCtrl.GetPayType = GetPayType
UIChangeGenderCtrl.SendChangeGenderMessage = SendChangeGenderMessage
return UIChangeGenderCtrl
