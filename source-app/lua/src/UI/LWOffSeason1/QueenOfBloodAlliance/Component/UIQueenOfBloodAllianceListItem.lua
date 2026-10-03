local base = UIBaseContainer
local UIQueenOfBloodAllianceListItem = BaseClass("UIQueenOfBloodAllianceListItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIQueenOfBloodAllianceListItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIQueenOfBloodAllianceListItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIQueenOfBloodAllianceListItem:ComponentDefine()
  self.imgItemBg = self:AddComponent(UIImage, "ItemBg")
  self.imgItemBgSelf = self:AddComponent(UIImage, "ItemBgSelf")
  self.btnItemFlag = self:AddComponent(UIButton, "ItemFlag")
  self.imgItemFlagIcon = self:AddComponent(UIImage, "ItemFlag/ItemFlagIcon")
  self.textItemNameInfo = self:AddComponent(UITextMeshProUGUIEx, "ItemInfos/ItemNameInfo")
  self.textItemPowerInfo = self:AddComponent(UITextMeshProUGUIEx, "ItemInfos/ItemPowerInfo")
  self.textItemMemberInfo = self:AddComponent(UITextMeshProUGUIEx, "ItemInfos/ItemMemberInfo")
  self.btnLook = self:AddComponent(UIButton, "lookBtn")
  self.btnLook:SetOnClick(function()
    self:OnBtnLookClick()
  end)
end

function UIQueenOfBloodAllianceListItem:ComponentDestroy()
  self.imgItemBg = nil
  self.btnItemFlag = nil
  self.imgItemFlagIcon = nil
  self.textItemNameInfo = nil
  self.textItemPowerInfo = nil
  self.textItemMemberInfo = nil
  self.btnLook = nil
  self.imgItemBgSelf = nil
end

function UIQueenOfBloodAllianceListItem:DataDefine()
  self.allianceData = nil
end

function UIQueenOfBloodAllianceListItem:DataDestroy()
  self.allianceData = nil
end

function UIQueenOfBloodAllianceListItem:OnAddListener()
  base.OnAddListener(self)
end

function UIQueenOfBloodAllianceListItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIQueenOfBloodAllianceListItem:ReInit(data)
  self.allianceData = data
  self.imgItemFlagIcon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, self.allianceData.icon))
  self.textItemNameInfo:SetLocalText(311026, self.allianceData.abbr, self.allianceData.alliancename)
  self.textItemPowerInfo:SetLocalText(100392, string.GetFormattedSeperatorNum(self.allianceData.power))
  self.textItemMemberInfo:SetLocalText("s1_QueenChallenge_signUpList_member", self.allianceData.curMember)
  local hasAlliance = LuaEntry.Player:IsInAlliance()
  local myAllianceId = LuaEntry.Player:GetAllianceUid()
  if hasAlliance and myAllianceId then
    self.imgItemBgSelf:SetActive(myAllianceId == self.allianceData.allianceId)
    self.imgItemBg:SetActive(myAllianceId ~= self.allianceData.allianceId)
    self.btnLook:SetActive(myAllianceId ~= self.allianceData.allianceId)
  else
    self.imgItemBgSelf:SetActive(false)
    self.imgItemBg:SetActive(true)
    self.btnLook.gameObject:SetActive(true)
  end
end

function UIQueenOfBloodAllianceListItem:OnBtnLookClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true}, self.allianceData.alliancename, self.allianceData.allianceId)
end

return UIQueenOfBloodAllianceListItem
