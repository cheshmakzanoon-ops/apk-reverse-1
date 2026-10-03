local ServerBattleCampDetailCtrl = BaseClass("ServerBattleCampDetailCtrl", UIBaseCtrl)

function ServerBattleCampDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.ServerBattleCampDetail)
end

return ServerBattleCampDetailCtrl
