local PVPArenaTopBar = BaseClass("PVPArenaTopBar", UIBaseContainer)
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

function PVPArenaTopBar:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function PVPArenaTopBar:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function PVPArenaTopBar:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.oppoWeaponBtn:SetOnClick(function()
    if self.oppoWeaponInfo then
      local power = self.oppoWeaponInfo:GetPower()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeaponTip, {anim = true}, self.oppoWeaponInfo, self.oppoEquips, self.oppoWeaponBtn, self.oppoWeaponSkinId, self.oppoWeaponChips, power)
    end
  end)
  self.bgLeftBtn:SetOnClick(function()
    self:ShowPowerInfo()
  end)
end

function PVPArenaTopBar:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function PVPArenaTopBar:Refresh(playerInfoLeft, playerInfoRight, oppoWeaponInfo, weaponChips, powerDetailData)
  self.powerDetailData = powerDetailData
  self.txtPowerLeft:SetText(string.GetFormattedStr2(playerInfoLeft.totalPower))
  self.txtPowerRight:SetText(string.GetFormattedStr2(playerInfoRight.totalPower))
  self.headLeft:SetHeadAndFrame(playerInfoLeft.uid, playerInfoLeft.pic, playerInfoLeft.picver, false, playerInfoLeft.headSkinId)
  self.headRight:SetHeadAndFrame(playerInfoRight.uid, playerInfoRight.pic, playerInfoRight.picver, false, playerInfoRight.headSkinId)
  if oppoWeaponInfo then
    self.oppoWeaponBtn:SetActive(true)
    if not self.oppoWeaponInfo then
      self.oppoWeaponInfo = TacticalWeaponInfo.New()
    end
    self.oppoWeaponInfo:CreateFromTemplate(oppoWeaponInfo.id, oppoWeaponInfo.lv, 0, oppoWeaponInfo.props)
    self.oppoWeaponInfo.power = oppoWeaponInfo.power or self.oppoWeaponInfo.power
    self.oppoWeaponSkinId = oppoWeaponInfo.uavSkinId
    self.oppoWeaponChips = weaponChips
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

function PVPArenaTopBar:ShowPowerInfo()
  if self.powerDetailData then
    UIUtil.ShowArmyFormationPowerTips(self.imgPowerLeft.transform.position, 0, -20, self.powerDetailData)
  end
end

return PVPArenaTopBar
