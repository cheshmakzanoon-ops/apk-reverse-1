local UIBFBaseSelectUserCtrl = BaseClass("UIBFBaseSelectUserCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local BattleFieldSelectUserModuleConfig = {
  [BattleFieldType.DsbDuel] = {
    BattleFieldSelectUserModule.ShowBattleTime
  },
  [BattleFieldType.EpidemicZone] = {
    BattleFieldSelectUserModule.Commander,
    BattleFieldSelectUserModule.TeamSelectBattleTime
  },
  [BattleFieldType.Desert] = {
    BattleFieldSelectUserModule.Commander,
    BattleFieldSelectUserModule.ShowBattleTime,
    BattleFieldSelectUserModule.TeamSelectBattleTime
  }
}

function UIBFBaseSelectUserCtrl:IsCommanderModuleEnable()
  local battlefieldType = self:GetBattlefieldType()
  if battlefieldType ~= nil and BattleFieldSelectUserModuleConfig[battlefieldType] then
    return table.hasvalue(BattleFieldSelectUserModuleConfig[battlefieldType], BattleFieldSelectUserModule.Commander)
  end
end

function UIBFBaseSelectUserCtrl:IsShowBattleTimeModuleEnable()
  local battlefieldType = self:GetBattlefieldType()
  if battlefieldType ~= nil and BattleFieldSelectUserModuleConfig[battlefieldType] then
    return table.hasvalue(BattleFieldSelectUserModuleConfig[battlefieldType], BattleFieldSelectUserModule.ShowBattleTime)
  end
end

function UIBFBaseSelectUserCtrl:IsTeamSelectBattleTimeModuleEnable()
  local battlefieldType = self:GetBattlefieldType()
  if battlefieldType ~= nil and BattleFieldSelectUserModuleConfig[battlefieldType] then
    return table.hasvalue(BattleFieldSelectUserModuleConfig[battlefieldType], BattleFieldSelectUserModule.TeamSelectBattleTime)
  end
end

function UIBFBaseSelectUserCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBattleFieldBaseSelectUser)
end

function UIBFBaseSelectUserCtrl:GetMemberListByRank(rank)
  local showList = {}
  local list = DataCenter.AllianceMemberDataManager:GetAllianceMemberListByRank(rank)
  local selfUid = LuaEntry.Player.uid
  if list ~= nil then
    table.walk(list, function(k, v)
      local oneData = {}
      oneData.name = v.name
      oneData.gender = v.gender
      oneData.power = v.power
      oneData.uid = v.uid
      oneData.rank = v.rank
      oneData.pic = v.pic or ""
      oneData.picVer = v.picVer or 0
      oneData.headBg = v:GetHeadBgImg()
      oneData.mainCityLv = v.mainCityLv
      oneData.joinTime = v.joinTime
      oneData.isSelfAlliance = true
      oneData.isInactive = v:CheckIfIsInactivePlayer()
      oneData.online_time = ""
      oneData.isOnline = v.online
      if v.online then
        oneData.online_time = Localization:GetString("390188")
      else
        local deltaTime = UITimeManager:GetInstance():GetServerTime() - v.offLineTime
        if 86400000 < deltaTime then
          local day = math.floor(deltaTime / 86400000)
          oneData.online_time = Localization:GetString("390506", day)
        elseif 3600000 < deltaTime then
          local hour = math.floor(deltaTime / 3600000)
          oneData.online_time = Localization:GetString("390505", hour)
        elseif 60000 < deltaTime then
          local minute = math.floor(deltaTime / 60000)
          oneData.online_time = Localization:GetString("390504", minute)
        else
          oneData.online_time = Localization:GetString("390504", 1)
        end
      end
      if v.uid == selfUid then
        table.insert(showList, 1, oneData)
      else
        table.insert(showList, oneData)
      end
    end)
  end
  return showList
end

function UIBFBaseSelectUserCtrl:SetFilterBattleTimeData(battleTimeData)
  self.filterBattleTimeData = battleTimeData
end

function UIBFBaseSelectUserCtrl:GetFilterBattleTimeData()
  return self.filterBattleTimeData
end

function UIBFBaseSelectUserCtrl:GetCurCommanderNum(curTabIdx)
  if self:IsCommanderModuleEnable() then
    Logger.LogError(string.format("[NotImplementedException] %s.%s NOT implemented", self.__cname, "GetCurCommanderNum"))
  end
end

function UIBFBaseSelectUserCtrl:SendCommanderModify(uid, group, isSet)
  if self:IsCommanderModuleEnable() then
    Logger.LogError(string.format("[NotImplementedException] %s.%s NOT implemented", self.__cname, "SendCommanderModify"))
  end
end

function UIBFBaseSelectUserCtrl:IsCommander(userInfo)
  if self:IsCommanderModuleEnable() then
    Logger.LogError(string.format("[NotImplementedException] %s.%s NOT implemented", self.__cname, "IsCommander"))
  end
end

ImplementChildClass(UIBFBaseSelectUserCtrl, InterfaceConfig.UIBFBaseSelectUserCtrl)
return UIBFBaseSelectUserCtrl
