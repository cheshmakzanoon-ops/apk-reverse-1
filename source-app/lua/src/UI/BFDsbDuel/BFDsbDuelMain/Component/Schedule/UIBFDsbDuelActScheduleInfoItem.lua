local base = UIBaseContainer
local UIBFDsbDuelActScheduleInfoItem = BaseClass("UIBFDsbDuelActScheduleInfoItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local SpritePathFormat = LoadPath.LWBattleFieldDsbDuelPath
local ImagePathList = {
  "lrb_daluandou_duizhan",
  "lrb_daluandou_fenzu",
  "lrb_daluandou_guize",
  "lrb_daluandou_jiangli"
}
local KeyList = {
  "dsb_duel_guide_tips_1001",
  "dsb_duel_guide_tips_1002",
  "dsb_duel_guide_tips_1003",
  "dsb_duel_guide_tips_1004"
}

function UIBFDsbDuelActScheduleInfoItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActScheduleInfoItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActScheduleInfoItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btn = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
end

function UIBFDsbDuelActScheduleInfoItem:ComponentDestroy()
  self.viewSkin = nil
  self.btn = nil
  self.imgBg = nil
  self.textTip = nil
end

function UIBFDsbDuelActScheduleInfoItem:DataDefine()
end

function UIBFDsbDuelActScheduleInfoItem:DataDestroy()
end

function UIBFDsbDuelActScheduleInfoItem:OnAddListener()
  base.OnAddListener(self)
end

function UIBFDsbDuelActScheduleInfoItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActScheduleInfoItem:OnBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActRules, {anim = true}, self.index)
end

function UIBFDsbDuelActScheduleInfoItem:SetData(index)
  self.index = index
  self.textTip:SetText(Localization:GetString(KeyList[index]))
  self.imgBg:LoadSpriteAuto(string.format(SpritePathFormat, ImagePathList[index]))
end

return UIBFDsbDuelActScheduleInfoItem
