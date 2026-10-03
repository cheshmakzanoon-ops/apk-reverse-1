local UIChampionDuelBattleLogDetailCtrl = BaseClass("UIChampionDuelBattleLogDetailCtrl", UIBaseCtrl)

function UIChampionDuelBattleLogDetailCtrl:CloseSelf()
  if self.currentView == 4 then
    self:SetCurrentView(nil)
    self.view:ContentTrans()
    return
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChampionDuelBattleLogDetail, {anim = false})
end

function UIChampionDuelBattleLogDetailCtrl:OnCustomKeyCodeEscape()
  self:CloseSelf()
end

function UIChampionDuelBattleLogDetailCtrl:SetView(view)
  self.view = view
end

function UIChampionDuelBattleLogDetailCtrl:ClearData()
  self.currentView = nil
  self.musterSoloData = nil
end

function UIChampionDuelBattleLogDetailCtrl:SetCurrentView(view)
  self.currentView = view
end

function UIChampionDuelBattleLogDetailCtrl:GetCurrentView()
  return self.currentView
end

function UIChampionDuelBattleLogDetailCtrl:GetCurrentMail()
  return self.view.uid
end

function UIChampionDuelBattleLogDetailCtrl:GetCurrentMailData()
  return self.mailData
end

function UIChampionDuelBattleLogDetailCtrl:SetMailData(mailData)
  self.mailData = mailData
end

function UIChampionDuelBattleLogDetailCtrl:FormatCoordinateText(pos, serverId)
  return ""
end

function UIChampionDuelBattleLogDetailCtrl:SetMusterSoloMailData(musterSoloData)
  self.musterSoloData = musterSoloData
end

function UIChampionDuelBattleLogDetailCtrl:GetMusterSoloMailData()
  return self.musterSoloData
end

return UIChampionDuelBattleLogDetailCtrl
