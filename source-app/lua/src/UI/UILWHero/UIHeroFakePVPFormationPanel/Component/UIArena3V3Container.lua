local UIArena3V3Container = BaseClass("UIArena3V3Container", UIBaseContainer)
local base = UIBaseContainer
local compBook = {
  {
    path = "bgLeft/txtPowerLeft",
    name = "txtPowerLeft",
    type = UIText
  },
  {
    path = "bgRight/txtPowerRight",
    name = "txtPowerRight",
    type = UIText
  },
  {
    path = "HeadLeft",
    name = "headLeft",
    type = UICommonHead
  },
  {
    path = "HeadRight",
    name = "headRight",
    type = UICommonHead
  },
  {
    path = "RoundIcon",
    name = "roundIcon",
    type = UIImage
  },
  {
    path = "LeftBtn",
    name = "leftBtn",
    type = UIButton
  },
  {
    path = "RightBtn",
    name = "rightBtn",
    type = UIButton
  },
  {
    path = "OppoWeapon",
    name = "oppoWeaponBtn",
    type = UIButton
  },
  {
    path = "OppoWeapon/OppoWeaponLevelNumberText",
    name = "oppoWeaponLevelNumberText",
    type = UIText
  },
  {
    path = "bgLeft",
    name = "bgLeftBtn",
    type = UIButton
  },
  {
    path = "bgLeft/imgPowerLeft",
    name = "imgPowerLeft",
    type = UIBaseContainer
  }
}

function UIArena3V3Container:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIArena3V3Container:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIArena3V3Container:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.leftBtn:SetOnClick(function()
    if self.squadIndex and self.squadIndex > 1 then
      self:SwitchTeam(self.squadIndex - 1)
    end
  end)
  self.rightBtn:SetOnClick(function()
    if self.squadIndex and self.squadIndex < 3 then
      self:SwitchTeam(self.squadIndex + 1)
    end
  end)
  self.oppoWeaponBtn:SetOnClick(function()
    if self.oppoWeaponInfo then
      local defTeamInfo = DataCenter.LW3V3Manager:GetOpponentDefenceTeam(self.squadIndex)
      if self.source and self.source == EnterHeroSquadPanelWay.KOFAttack then
        defTeamInfo = DataCenter.LWKOFBattleManager:GetOpponentDefenceTeam(self.squadIndex)
      end
      local skillChips = defTeamInfo.skillChipArr
      local power = self.oppoWeaponInfo:GetPower()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeaponTip, {anim = true}, self.oppoWeaponInfo, self.oppoEquips, self.oppoWeaponBtn, self.oppoWeaponSkinId, skillChips, power)
    end
  end)
  self.bgLeftBtn:SetOnClick(function()
    self:ShowPowerInfo()
  end)
end

function UIArena3V3Container:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIArena3V3Container:SwitchTeam(index)
  if self.source and self.source == EnterHeroSquadPanelWay.KOFAttack then
    EventManager:GetInstance():Broadcast(EventId.KOFBattleSwitchTeam, index)
  else
    EventManager:GetInstance():Broadcast(EventId.Arena3V3BattleSwitchTeam, index)
  end
end

function UIArena3V3Container:Refresh(playerInfoLeft, playerInfoRight, squadIndex, oppoWeaponInfo, powerDetailData, source)
  self.source = source
  self.powerDetailData = powerDetailData
  self.txtPowerLeft:SetText(string.GetFormattedStr2(playerInfoLeft.power))
  self.txtPowerRight:SetText(string.GetFormattedStr2(playerInfoRight.power))
  self.headLeft:SetData(playerInfoLeft.uid, playerInfoLeft.pic, playerInfoLeft.picVer, nil, playerInfoLeft.headFrame)
  self.headLeft:SetFlag(playerInfoRight.countryflag)
  self.headRight:SetData(playerInfoRight.uid, playerInfoRight.pic, playerInfoRight.picVer, nil, playerInfoRight.headFrame)
  self.headRight:SetFlag(playerInfoRight.countryflag)
  self.leftBtn:SetActive(1 < squadIndex)
  self.rightBtn:SetActive(squadIndex < 3)
  self.roundIcon:LoadSprite(string.format("Assets/Main/Sprites/UI/LWPVPArena/zyf_3v3jingjichang_round%d.png", squadIndex))
  self.roundIcon:SetNativeSize()
  self.squadIndex = squadIndex
  if oppoWeaponInfo then
    self.oppoWeaponBtn:SetActive(true)
    if not self.oppoWeaponInfo then
      self.oppoWeaponInfo = TacticalWeaponInfo.New()
    end
    self.oppoWeaponInfo:CreateFromTemplate(oppoWeaponInfo.id, oppoWeaponInfo.lv, 0, oppoWeaponInfo.props)
    self.oppoWeaponInfo.power = oppoWeaponInfo.power or self.oppoWeaponInfo.power
    self.oppoWeaponSkinId = oppoWeaponInfo.uavSkinId
    local equips = {}
    if not string.IsNullOrEmpty(oppoWeaponInfo.uavEquips) then
      local equipIds = string.split(oppoWeaponInfo.uavEquips, "|")
      local expStrList
      if oppoWeaponInfo.uavEquipExps then
        expStrList = string.split(oppoWeaponInfo.uavEquipExps, "|")
      end
      for i = 1, #equipIds do
        local exp = 0
        if expStrList then
          exp = tonumber(expStrList[i])
        end
        local equipId = tonumber(equipIds[i])
        local equipInfo = CommonEquipInfo.New()
        equipInfo:UpdateInfo({cfgId = equipId, exp = exp})
        equips[equipInfo:GetConfigSlot()] = equipInfo
      end
    end
    self.oppoEquips = equips or {}
    self.oppoWeaponLevelNumberText:SetText(self.oppoWeaponInfo.level)
  else
    self.oppoWeaponBtn:SetActive(false)
  end
end

function UIArena3V3Container:ShowPowerInfo()
  if self.powerDetailData then
    UIUtil.ShowArmyFormationPowerTips(self.imgPowerLeft.transform.position, 0, -20, self.powerDetailData)
  end
end

return UIArena3V3Container
