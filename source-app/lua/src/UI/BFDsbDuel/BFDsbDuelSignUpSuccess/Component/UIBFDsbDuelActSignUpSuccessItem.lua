local base = UIBaseContainer
local UIBFDsbDuelActSignUpSuccessItem = BaseClass("UIBFDsbDuelActSignUpSuccessItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActSignUpSuccessItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActSignUpSuccessItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActSignUpSuccessItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.compWaiting = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.compWaiting:SetActive(false)
end

function UIBFDsbDuelActSignUpSuccessItem:ComponentDestroy()
  self.viewSkin = nil
  self.textTxt = nil
  self.imgIcon = nil
  self.compWaiting = nil
end

function UIBFDsbDuelActSignUpSuccessItem:DataDefine()
  self.itemData = nil
end

function UIBFDsbDuelActSignUpSuccessItem:DataDestroy()
  self.itemData = nil
end

function UIBFDsbDuelActSignUpSuccessItem:OnAddListener()
  base.OnAddListener(self)
end

function UIBFDsbDuelActSignUpSuccessItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActSignUpSuccessItem:SetData(itemData)
  self.itemData = itemData
  self:RefreshUI()
end

function UIBFDsbDuelActSignUpSuccessItem:RefreshUI()
  local idx = self.itemData.index
  if idx == 1 then
    self.textTxt:SetLocalText("dsb_duel_interface_1010", self.itemData.param)
  elseif idx == 2 then
    self.textTxt:SetLocalText("dsb_duel_interface_1011", self.itemData.param)
  elseif idx == 3 then
    self.textTxt:SetLocalText("dsb_duel_interface_1012", self.itemData.param)
  end
  local state = self.itemData.state
  self.compWaiting:SetActive(self.itemData.showWait)
  if state == -1 or self.itemData.showWait then
    self.imgIcon:SetActive(false)
  else
    self.imgIcon:SetActive(true)
    self.imgIcon:LoadSpriteAuto(state == 1 and "Assets/Main/Sprites/UI/UILWAllianceLog/lrb_rumengtiaojian_duihao.png" or "Assets/Main/Sprites/UI/UIAllianceFirstJoin/lrb_rumengtiaojian_cha.png")
  end
end

return UIBFDsbDuelActSignUpSuccessItem
