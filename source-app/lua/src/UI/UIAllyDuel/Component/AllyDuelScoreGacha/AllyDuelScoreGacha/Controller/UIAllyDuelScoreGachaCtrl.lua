local AllyDuelScoreGachaCtrl = BaseClass("AllyDuelScoreGachaCtrl", UIBaseCtrl)

function AllyDuelScoreGachaCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.AllyDuelScoreGacha)
end

return AllyDuelScoreGachaCtrl
