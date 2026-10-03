local Arena3V3ChooseSquadPopup = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.Arena3V3ChooseSquadPopup")
local TruckChooseSquadPopup = BaseClass("TruckChooseSquadPopup", Arena3V3ChooseSquadPopup)
local base = Arena3V3ChooseSquadPopup
local Localization = CS.GameEntry.Localization

function TruckChooseSquadPopup:ComponentDefine()
  self:DefineCompsByBook(base.compBook)
  for i = 1, 4 do
    self["txtItem" .. i]:SetText(Localization:GetString("801114", i))
    self["item" .. i]:SetOnClick(function()
      local squadInfo = self:GetTeamByIndex(self.squadIndex)
      local buffIndex = squadInfo.localSquadNo
      if buffIndex == i then
        return
      end
      local usingSquadIndex = self:GetSquadIndexUsingBuff(i)
      if usingSquadIndex then
        local isBusy
        if self.isDef then
          local busyList = DataCenter.LWMyStationDataManager:GetBusyDefenceFormationIndexList()
          isBusy = busyList[usingSquadIndex] == true
        end
        if not isBusy then
          UIUtil.ShowMessage(Localization:GetString(500262, i, usingSquadIndex), 1, "110006", nil, function()
            self:SetSquadUsingBuff(self.squadIndex, i)
            self:SetSquadUsingBuff(usingSquadIndex, buffIndex)
            self:RefreshShow()
          end, nil, nil)
        else
          UIUtil.ShowTipsId("city_trade_tips1016")
        end
      else
        self:SetSquadUsingBuff(self.squadIndex, i)
        self:RefreshShow()
      end
    end)
  end
  self.btnClose:SetOnClick(function()
    self:SetActive(false)
  end)
  self.btnInfo:SetOnClick(function()
    UIUtil.ShowTipsId(801115)
  end)
end

function TruckChooseSquadPopup:GetTeamByIndex(index)
  if self.isDef then
    return DataCenter.LWMyStationDataManager:GetDefenceFormationByIndex(index)
  else
    return DataCenter.LWMyStationDataManager:GetAttackFormationByIndex(index)
  end
end

function TruckChooseSquadPopup:GetSquadIndexUsingBuff(index)
  if self.isDef then
    return DataCenter.LWMyStationDataManager:GetDefTeamIndexUsingBuff(index)
  else
    return DataCenter.LWMyStationDataManager:GetAtkTeamIndexUsingBuff(index)
  end
end

function TruckChooseSquadPopup:SetSquadUsingBuff(index, buffIndex)
  if self.isDef then
    return DataCenter.LWMyStationDataManager:SetDefTeamUsingBuff(index, buffIndex)
  else
    return DataCenter.LWMyStationDataManager:SetAtkTeamUsingBuff(index, buffIndex)
  end
end

return TruckChooseSquadPopup
