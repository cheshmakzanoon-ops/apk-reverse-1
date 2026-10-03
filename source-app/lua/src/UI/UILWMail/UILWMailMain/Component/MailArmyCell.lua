local MailArmyCell = BaseClass("MailArmyCell", UIBaseContainer)
local base = UIBaseContainer
local MailBattleParseHelper = require("DataCenter.MailData.MailBattleParseHelper")
local Localization = CS.GameEntry.Localization

function MailArmyCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailArmyCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailArmyCell:ComponentDefine()
  self.left = self:AddComponent(UIBaseComponent, "left")
  self.right = self:AddComponent(UIBaseComponent, "right")
  self.name1 = self:AddComponent(UIText, "left/horiLayout/name1")
  self.name2 = self:AddComponent(UIText, "right/horiLayout/name2")
  self.head1 = self:AddComponent(UICommonHead, "left/head1")
  self.head2 = self:AddComponent(UICommonHead, "right/head2")
  self.fullPower1 = self:AddComponent(UIText, "left/fullPower1")
  self.lostPower1 = self:AddComponent(UIText, "left/lostPower1")
  self.fullPower2 = self:AddComponent(UIText, "right/fullPower2")
  self.lostPower2 = self:AddComponent(UIText, "right/lostPower2")
  self.sliderBlack1 = self:AddComponent(UISlider, "left/sliderBlack1")
  self.sliderBlue1 = self:AddComponent(UISlider, "left/sliderBlue1")
  self.sliderBlack2 = self:AddComponent(UISlider, "right/sliderBlack2")
  self.sliderRed2 = self:AddComponent(UISlider, "right/sliderRed2")
  self.anonymityBtn1 = self:AddComponent(UIButton, "left/horiLayout/anonymityBtn1")
  self.anonymityBtn1:SetOnClick(function()
    self:OnClickAnonymityBtn1()
  end)
  self.anonymityBtn2 = self:AddComponent(UIButton, "right/horiLayout/anonymityBtn2")
  self.anonymityBtn2:SetOnClick(function()
    self:OnClickAnonymityBtn2()
  end)
end

function MailArmyCell:ComponentDestroy()
end

function MailArmyCell:SetData(data)
  if data[1] then
    self.left:SetActive(true)
    local army = data[1]
    if MailBattleParseHelper.IsWerewolf(army) then
      self.hideType1 = HideType.Werewolf
      self.head1:ShowWerewolf()
      self.anonymityBtn1:SetActive(true)
      self.name1:SetLocalText(GameDialogDefine.WEREWOLF)
    elseif army.isActiveAnonymity then
      self.hideType1 = HideType.Anonymity
      self.head1:SetHead("-1")
      self.anonymityBtn1:SetActive(true)
      self.name1:SetText(army.name)
    else
      self.hideType1 = HideType.None
      self.head1:SetHead(army.uid, army.pic, army.picVer)
      self.anonymityBtn1:SetActive(false)
      self.name1:SetText(army.name)
    end
    local sliderMaxNum = army.maxMaxSoldierPower or 0
    local sliderBeforeNum = army.soldierCountBeforeStart
    local sliderCurNum = army.soldierCount
    if sliderBeforeNum < sliderMaxNum * 0.05 then
      sliderMaxNum = sliderBeforeNum * 20
    end
    self.sliderBlack1:SetValue(sliderMaxNum == 0 and 0 or sliderBeforeNum / sliderMaxNum)
    self.sliderBlue1:SetValue(sliderMaxNum == 0 and 0 or sliderCurNum / sliderMaxNum)
    local beforeNum = string.GetFormattedSeperatorNum(math.floor(sliderBeforeNum))
    local deadNum = string.GetFormattedSeperatorNum(math.floor(sliderCurNum - sliderBeforeNum))
    self.fullPower1:SetText(beforeNum)
    self.lostPower1:SetText(deadNum)
    self.head1:SetEnableClickShowInfo(true, true)
  else
    self.left:SetActive(false)
  end
  if data[2] then
    self.right:SetActive(true)
    local army = data[2]
    if MailBattleParseHelper.IsWerewolf(army) then
      self.hideType2 = HideType.Werewolf
      self.head2:ShowWerewolf()
      self.anonymityBtn2:SetActive(true)
      self.name2:SetLocalText(GameDialogDefine.WEREWOLF)
    elseif army.isActiveAnonymity then
      self.hideType2 = HideType.Anonymity
      self.head2:SetHead("-1")
      self.anonymityBtn2:SetActive(true)
      self.name2:SetText(army.name)
    else
      self.hideType2 = HideType.None
      self.head2:SetHead(army.uid, army.pic, army.picVer)
      self.anonymityBtn2:SetActive(false)
      self.name2:SetText(army.name)
    end
    local sliderMaxNum = army.maxMaxSoldierPower or 0
    local sliderBeforeNum = army.soldierCountBeforeStart
    local sliderCurNum = army.soldierCount
    if sliderBeforeNum < sliderMaxNum * 0.05 then
      sliderMaxNum = sliderBeforeNum * 20
    end
    self.sliderBlack2:SetValue(sliderMaxNum == 0 and 0 or sliderBeforeNum / sliderMaxNum)
    self.sliderRed2:SetValue(sliderMaxNum == 0 and 0 or sliderCurNum / sliderMaxNum)
    local beforeNum = string.GetFormattedSeperatorNum(math.floor(sliderBeforeNum))
    local deadNum = string.GetFormattedSeperatorNum(math.floor(sliderCurNum - sliderBeforeNum))
    self.fullPower2:SetText(beforeNum)
    self.lostPower2:SetText(deadNum)
    self.head2:SetEnableClickShowInfo(true, true)
    self.anonymityBtn2:SetActive(army.isActiveAnonymity)
  else
    self.right:SetActive(false)
  end
end

function MailArmyCell:DataDefine()
end

function MailArmyCell:DataDestroy()
  self.hideType1 = nil
  self.hideType2 = nil
end

function MailArmyCell:OnEnable()
  base.OnEnable(self)
end

function MailArmyCell:OnDisable()
  base.OnDisable(self)
end

function MailArmyCell:OnAddListener()
  base.OnAddListener(self)
end

function MailArmyCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function MailArmyCell:OnClickAnonymityBtn1()
  local langKey = self.hideType1 == HideType.Werewolf and "season_s4_activity_1200011_desc25" or "season_mastery_tips_24"
  UIUtil.ShowBubbleTips(Localization:GetString(langKey), self.anonymityBtn1.transform.position, 0, -20, 0)
end

function MailArmyCell:OnClickAnonymityBtn2()
  local langKey = self.hideType2 == HideType.Werewolf and "season_s4_activity_1200011_desc25" or "season_mastery_tips_24"
  UIUtil.ShowBubbleTips(Localization:GetString(langKey), self.anonymityBtn2.transform.position, 0, -20, 0)
end

return MailArmyCell
