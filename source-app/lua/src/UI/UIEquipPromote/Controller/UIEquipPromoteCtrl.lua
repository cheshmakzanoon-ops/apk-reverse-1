local UIEquipPromoteCtrl = BaseClass("UIEquipPromoteCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIEquipPromote)
  EventManager:GetInstance():Broadcast(EventId.ExitEquipPromote, self:GetCurEquipUuid())
end

local function OnCustomKeyCodeEscape(self)
  self:CloseSelf()
end

local function SetCurEquipUuid(self, uuid)
  self.curEquipUuid = uuid
end

local function GetCurEquipUuid(self)
  return self.curEquipUuid
end

UIEquipPromoteCtrl.CloseSelf = CloseSelf
UIEquipPromoteCtrl.Close = Close
UIEquipPromoteCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
UIEquipPromoteCtrl.SetCurEquipUuid = SetCurEquipUuid
UIEquipPromoteCtrl.GetCurEquipUuid = GetCurEquipUuid
return UIEquipPromoteCtrl
