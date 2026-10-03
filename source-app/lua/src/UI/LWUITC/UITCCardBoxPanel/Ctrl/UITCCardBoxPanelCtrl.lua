local UITCCardBoxPanelCtrl = BaseClass("UITCCardBoxPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITCCardBoxPanel)
end

function UITCCardBoxPanelCtrl:OpenBox(boxId, count)
  local boxTemplate = DataCenter.TacticalCardDataManager:GetBoxTemplate(boxId)
  local itemId = boxTemplate.goods_id
  if not itemId then
    return
  end
  if count > DataCenter.ItemData:GetItemCount(itemId) then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.TacticalCardOpenBox, itemId, count)
end

UITCCardBoxPanelCtrl.CloseSelf = CloseSelf
return UITCCardBoxPanelCtrl
