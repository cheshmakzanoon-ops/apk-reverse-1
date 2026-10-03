local base = UIBaseContainer
local UILWAlSwitchJobInfoCell = BaseClass("UILWAlSwitchJobInfoCell", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWAlSwitchJobInfoCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlSwitchJobInfoCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlSwitchJobInfoCell:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTarget = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.imgOwnDiff = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textOwn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgTargetDiff = self.viewSkin:AddComponent(self, UIImage, 4)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 6)
  self.textCell = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.imgOwnDiff:SetActive(false)
end

function UILWAlSwitchJobInfoCell:ComponentDestroy()
  self.viewSkin = nil
  self.textTarget = nil
  self.imgOwnDiff = nil
  self.textOwn = nil
  self.imgTargetDiff = nil
  self.btnInfo = nil
  self.imgIcon = nil
  self.textCell = nil
end

function UILWAlSwitchJobInfoCell:DataDefine()
end

function UILWAlSwitchJobInfoCell:DataDestroy()
end

function UILWAlSwitchJobInfoCell:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlSwitchJobInfoCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlSwitchJobInfoCell:OnBtnInfoClick()
  if self.setting then
    UIUtil.ShowBubbleTipsAuto(Localization:GetString(self.setting.dialogTextId), self.imgIcon.transform.position, 0, -30, 0)
  end
end

function UILWAlSwitchJobInfoCell:SetData(cellType, nowInfo, switchInfo, data)
  self.setting = AllianceInvite_CellSetting[cellType]
  if self.setting == nil then
    return
  end
  self.imgIcon:LoadSpriteAuto(self.setting.IconPath)
  self.textCell:SetLocalText(self.setting.nameTextId)
  local nowNum = 0
  local switchNum = 0
  if cellType == AllianceInvite_CellType.Member then
    self.textOwn:SetText(nowInfo.curMember)
    self.textTarget:SetText(switchInfo.curMember)
    nowNum = nowInfo.curMember or 0
    switchNum = switchInfo.curMember or 0
  elseif cellType == AllianceInvite_CellType.Power then
    self.textOwn:SetText(nowInfo:GetPowerStr())
    self.textTarget:SetText(switchInfo:GetPowerStr())
    nowNum = nowInfo.power or 0
    switchNum = switchInfo.power or 0
  elseif cellType == AllianceInvite_CellType.Gift then
    self.textOwn:SetText(nowInfo:GetGiftLevelStr())
    self.textTarget:SetText(switchInfo:GetGiftLevelStr())
    nowNum = nowInfo.giftLevel or 0
    switchNum = switchInfo.giftLevel or 0
  elseif cellType == AllianceInvite_CellType.Engagement then
    self.textOwn:SetText(nowInfo:GetAllianceEngagementPointStr())
    self.textTarget:SetText(switchInfo:GetAllianceEngagementPointStr())
    nowNum = nowInfo.allianceEngagementPoint or 0
    switchNum = switchInfo.allianceEngagementPoint or 0
  elseif cellType == AllianceInvite_CellType.GiftNum then
    self.textOwn:SetText(data.rewardCount)
    self.textTarget:SetText(data.recommendRewardCount)
    nowNum = data.rewardCount or 0
    switchNum = data.recommendRewardCount or 0
  end
  if nowNum == switchNum then
    self.imgTargetDiff:SetActive(false)
  else
    self.imgTargetDiff:SetActive(true)
    if nowNum < switchNum then
      self.imgTargetDiff:LoadSpriteAuto("Assets/Main/Sprites/UI/UIAllianceInvite/zyf_tongmengguanli_tiaocao_jiantou_lv.png")
    else
      self.imgTargetDiff:LoadSpriteAuto("Assets/Main/Sprites/UI/UIAllianceInvite/zyf_tongmengguanli_tiaocao_jiantou_hong.png")
    end
  end
end

return UILWAlSwitchJobInfoCell
