local RankItemShow = {
  type = RankingTypeServer.DEFAULT,
  isAlliance = false,
  uid = "",
  firstName = "",
  secondName = "",
  rank = -1,
  power = "",
  allianceName = "",
  icon = ""
}
local UIJeepAdventureMainCtrl = BaseClass("UIJeepAdventureMainCtrl", UIBaseCtrl)
local OneData = DataClass("OneData", RankItemShow)

function UIJeepAdventureMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIJeepAdventureMain)
end

function UIJeepAdventureMainCtrl:SendGetFirstReward(pageType, id)
  if pageType == JeepAdventurePageType.Domintor then
    SFSNetwork.SendMessage(MsgDefines.LWReveiveDominatorUpFirstReward, id)
  elseif pageType == JeepAdventurePageType.TowerUp then
    SFSNetwork.SendMessage(MsgDefines.LWReveiveTowerUpFirstReward, id)
  end
end

function UIJeepAdventureMainCtrl:OnCustomKeyCodeEscape()
end

return UIJeepAdventureMainCtrl
