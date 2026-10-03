local UITCChoiceBoxCtrl = BaseClass("UITCChoiceBoxCtrl", UIBaseCtrl)

function UITCChoiceBoxCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITCChoiceBox)
end

function UITCChoiceBoxCtrl:UseItem(type, uuid, count, selectedIndex)
  SFSNetwork.SendMessage(MsgDefines.ItemUse, {
    uuid = uuid,
    num = count,
    para1 = tostring(selectedIndex)
  })
  self:CloseSelf()
end

function UITCChoiceBoxCtrl:UseItemNew(itemId, num, findIndex)
  SFSNetwork.SendMessage(MsgDefines.BattleCardChooseBox, {
    itemId = tostring(itemId),
    num = num,
    findIndex = findIndex
  })
  self:CloseSelf()
end

return UITCChoiceBoxCtrl
