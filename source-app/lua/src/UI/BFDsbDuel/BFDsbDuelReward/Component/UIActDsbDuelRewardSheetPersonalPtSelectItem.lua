local base = UIBaseContainer
local UIActDsbDuelRewardSheetPersonalPtSelectItem = BaseClass("UIActDsbDuelRewardSheetPersonalPtSelectItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIActDsbDuelRewardSheetPersonalPtSelectItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActDsbDuelRewardSheetPersonalPtSelectItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActDsbDuelRewardSheetPersonalPtSelectItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.text = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.imgArrow = self.viewSkin:AddComponent(self, UIImage, 2)
  self.compLine = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.btnGroupCell = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnGroupCell:SetOnClick(function()
    self:OnBtnGroupCellClick()
  end)
end

function UIActDsbDuelRewardSheetPersonalPtSelectItem:ComponentDestroy()
  self.viewSkin = nil
  self.text = nil
  self.imgArrow = nil
  self.compLine = nil
  self.btnGroupCell = nil
end

function UIActDsbDuelRewardSheetPersonalPtSelectItem:DataDefine()
end

function UIActDsbDuelRewardSheetPersonalPtSelectItem:DataDestroy()
end

function UIActDsbDuelRewardSheetPersonalPtSelectItem:OnAddListener()
  base.OnAddListener(self)
end

function UIActDsbDuelRewardSheetPersonalPtSelectItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActDsbDuelRewardSheetPersonalPtSelectItem:SetData(data)
  self.data = data
  local txt = data.text
  if self.data.groupIndex == BattlefieldDsbDuelUtils.GetMyAllianceRankInBattle() then
    txt = string.format("%s (%s)", txt, Localization:GetString("100354"))
  end
  self.text:SetText(txt)
  self.imgArrow:SetActive(data.isSelect)
  self.compLine:SetActive(data.groupIndex ~= BattlefieldDsbConst.BF_DSB_REWARD_RANK.Max)
end

function UIActDsbDuelRewardSheetPersonalPtSelectItem:OnBtnGroupCellClick()
  if self.data and self.data.callback then
    self.data.callback(self.data.groupIndex)
  end
end

return UIActDsbDuelRewardSheetPersonalPtSelectItem
