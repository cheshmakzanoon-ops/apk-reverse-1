local UICapacityBoxSelectTypeTWSkillChipCtrl = BaseClass("UICapacityBoxSelectTypeTWSkillChipCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UICapacityBoxSelectTypeTWSkillChipCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICapacityBoxSelectTypeTWSkillChip)
end

function UICapacityBoxSelectTypeTWSkillChipCtrl:Close()
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

function UICapacityBoxSelectTypeTWSkillChipCtrl:UseItem(type, uuid, count, param)
  SFSNetwork.SendMessage(MsgDefines.ItemUse, {
    uuid = uuid,
    num = count,
    para1 = tostring(param)
  })
  self:CloseSelf()
end

return UICapacityBoxSelectTypeTWSkillChipCtrl
