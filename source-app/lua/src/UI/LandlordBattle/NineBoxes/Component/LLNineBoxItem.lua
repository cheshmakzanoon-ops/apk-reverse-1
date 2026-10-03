local base = UIBaseContainer
local LLNineBoxItem = BaseClass("LLNineBoxItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.LandlordMgr

function LLNineBoxItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLNineBoxItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLNineBoxItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.compVFXUiBoxLight = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 3)
  self.compVFXUiBoxReward = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.btn = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.compDimondBg = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.textDimondTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.animatorIcon = self.viewSkin:AddComponent(self, UIAnimator, 8)
end

function LLNineBoxItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg = nil
  self.compVFXUiBoxLight = nil
  self.imgIcon = nil
  self.compVFXUiBoxReward = nil
  self.btn = nil
  self.compDimondBg = nil
  self.textDimondTxt = nil
  self.animatorIcon = nil
end

function LLNineBoxItem:DataDefine()
end

function LLNineBoxItem:DataDestroy()
end

function LLNineBoxItem:OnAddListener()
  base.OnAddListener(self)
end

function LLNineBoxItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLNineBoxItem:OnBtnClick()
  local state = ActMgr:GetNineBoxState(self.boxIndex)
  if state ~= 2 then
    self:ShowRewardTips(self.boxIndex)
    return
  end
  ActMgr:ReqGetNineBox(self.boxIndex)
end

function LLNineBoxItem:ShowRewardTips(index)
  local newIndex = (index - 1) % 3 + 1
  local isLeft = newIndex == 1
  local x = self.transform.position.x
  local y = self.transform.position.y
  local offset = 0
  local width = self.rectTransform.rect.width
  if isLeft then
    width = width * 0.75
  else
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityRewardTip, Localization:GetString("370101", self.config.value), EnumActivity.ActLandlord.Type, x, y, isLeft, index, width, offset)
end

function LLNineBoxItem:SetBoxInfo(boxIndex, config)
  self.boxIndex = boxIndex
  self.config = config
  local state = ActMgr:GetNineBoxState(boxIndex)
  self.compVFXUiBoxLight:SetActive(state == 2)
  local iconId = (boxIndex - 1) % 3
  if iconId == 1 then
    iconId = 2
  elseif iconId == 2 then
    iconId = 1
  end
  self.imgBg:LoadSpriteAuto(string.format(LoadPath.LandlordPath, state ~= 3 and "lrb_jinmai_shuoming_ban01.png" or "lrb_jinmai_shuoming_ban02.png"))
  iconId = (state == 3 and 2 or 1) + iconId * 2
  self.imgIcon:LoadSpriteAuto(string.format(LoadPath.LandlordPath, string.format("LXY_s5_Baoxiang%s_icon.png", iconId)))
  self.animatorIcon:Play(state == 2 and "box_open" or "box_unOpen", 0, 0)
  self.compVFXUiBoxReward:SetActive(state == 2)
  self.compDimondBg:SetActive(state ~= 3)
  self.textDimondTxt:SetText(string.GetFormattedSeperatorNum(toInt(config.value)))
end

return LLNineBoxItem
