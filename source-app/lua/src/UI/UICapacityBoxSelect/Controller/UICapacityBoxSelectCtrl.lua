local UICapacityBoxSelectCtrl = BaseClass("UICapacityBoxSelectCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UICapacityBoxSelectCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICapacityBoxSelect)
end

function UICapacityBoxSelectCtrl:Close()
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Background)
end

function UICapacityBoxSelectCtrl:InitData()
end

function UICapacityBoxSelectCtrl:UseItem(type, uuid, count, param)
  if type == GOODS_TYPE.GOODS_TYPE_102 then
    SFSNetwork.SendMessage(MsgDefines.ItemUse, {
      uuid = uuid,
      num = count,
      heroId = param
    })
  elseif type == GOODS_TYPE.GOODS_TYPE_59 or type == GOODS_TYPE.GOODS_TYPE_107 then
    SFSNetwork.SendMessage(MsgDefines.ItemUse, {
      uuid = uuid,
      num = count,
      para1 = tostring(param)
    })
  elseif count then
    SFSNetwork.SendMessage(MsgDefines.ItemUse, {uuid = uuid, num = count})
  end
  self:CloseSelf()
end

return UICapacityBoxSelectCtrl
