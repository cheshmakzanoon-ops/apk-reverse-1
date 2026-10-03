local base = UIBaseContainer
local UIBFDsbDuelActScoreSelectItem = BaseClass("UIBFDsbDuelActScoreSelectItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActScoreSelectItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActScoreSelectItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActScoreSelectItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.text = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.imgArrow = self.viewSkin:AddComponent(self, UIImage, 2)
  self.compLine = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.btnUIBFDsbDuelActScoreSelectItem = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnUIBFDsbDuelActScoreSelectItem:SetOnClick(function()
    self:OnBtnUIBFDsbDuelActScoreSelectItemClick()
  end)
  self.compIncludeFlag = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
end

function UIBFDsbDuelActScoreSelectItem:ComponentDestroy()
  self.viewSkin = nil
  self.text = nil
  self.imgArrow = nil
  self.compLine = nil
  self.btnUIBFDsbDuelActScoreSelectItem = nil
  self.compIncludeFlag = nil
end

function UIBFDsbDuelActScoreSelectItem:DataDefine()
end

function UIBFDsbDuelActScoreSelectItem:DataDestroy()
end

function UIBFDsbDuelActScoreSelectItem:OnAddListener()
  base.OnAddListener(self)
end

function UIBFDsbDuelActScoreSelectItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActScoreSelectItem:SetData(data)
  self.data = data
  self.text:SetText(data.text)
  self.imgArrow:SetActive(data.isSelect)
  self.compLine:SetActive(data.groupIndex ~= data.lastIndex)
  self.compIncludeFlag:SetActive(data.groupIndex ~= 0 and data.groupIndex == BattlefieldDsbDuelUtils.ActInfo:GetSelfGroup())
end

function UIBFDsbDuelActScoreSelectItem:OnBtnUIBFDsbDuelActScoreSelectItemClick()
  if self.data and self.data.callback then
    self.data.callback(self.data.groupIndex)
  end
end

return UIBFDsbDuelActScoreSelectItem
