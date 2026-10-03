local UIFarmActionView = BaseClass("UIFarmAction", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local _cp_plant = "Root/Img/btnToPlant"
local _cp_water = "Root/Img/btnToWater"
local _cp_reap = "Root/Img/btnToReap"
local _cp_guideArrow = "Root/Img/GuideArrow"

function UIFarmActionView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.needRemoveHead = true
  local state = self:GetUserData()
  self:HideAllBtn()
  if state == Wasteland_PlantState.ToPlant then
    self.btnToPlant.gameObject:SetActive(true)
  elseif state == Wasteland_PlantState.ToWater then
    self.btnToWater.gameObject:SetActive(true)
  elseif state == Wasteland_PlantState.ToReap then
    self.btnToReap.gameObject:SetActive(true)
  end
  local hasClicked = Setting:GetPrivateInt(SettingKeys.NEWBIE_FARM_BTN_CLICK .. state, 0) == 1 and true or false
  self.guideArrow:SetActive(not hasClicked)
  if not hasClicked then
    self:ShowHead(state)
  end
end

function UIFarmActionView:HideAllBtn()
  self.btnToPlant.gameObject:SetActive(false)
  self.btnToWater.gameObject:SetActive(false)
  self.btnToReap.gameObject:SetActive(false)
end

function UIFarmActionView:OnDestroy()
  self:RemoveHead()
  base.OnDestroy(self)
end

function UIFarmActionView:ComponentDefine()
  self.btnToPlant = self:AddComponent(UIButton, _cp_plant)
  self.btnToPlant:SetOnClick(BindCallback(self, self.OnClickToPlant))
  self.btnToWater = self:AddComponent(UIButton, _cp_water)
  self.btnToWater:SetOnClick(BindCallback(self, self.OnClickToWater))
  self.btnToReap = self:AddComponent(UIButton, _cp_reap)
  self.btnToReap:SetOnClick(BindCallback(self, self.OnClickToReap))
  self.guideArrow = self:AddComponent(UIBaseContainer, _cp_guideArrow)
end

function UIFarmActionView:OnClickToPlant()
  Setting:SetPrivateInt(SettingKeys.NEWBIE_FARM_BTN_CLICK .. Wasteland_PlantState.ToPlant, 1)
  self.guideArrow:SetActive(false)
  self.needRemoveHead = false
  CitySpaceMan:GetInstance():ToPlant()
  self.ctrl:CloseSelf()
end

function UIFarmActionView:OnClickToWater()
  Setting:SetPrivateInt(SettingKeys.NEWBIE_FARM_BTN_CLICK .. Wasteland_PlantState.ToWater, 1)
  self.guideArrow:SetActive(false)
  self.needRemoveHead = false
  CitySpaceMan:GetInstance():ToWater()
  self.ctrl:CloseSelf()
end

function UIFarmActionView:OnClickToReap()
  Setting:SetPrivateInt(SettingKeys.NEWBIE_FARM_BTN_CLICK .. Wasteland_PlantState.ToReap, 1)
  self.guideArrow:SetActive(false)
  self.needRemoveHead = false
  CitySpaceMan:GetInstance():ToReap()
  self.ctrl:CloseSelf()
end

function UIFarmActionView:ShowHead(state)
  self.showHead = true
  local headParam = {}
  if state == Wasteland_PlantState.ToPlant then
    headParam.dialog = Localization:GetString(GameDialogDefine.CLICK_PLANT)
  elseif state == Wasteland_PlantState.ToWater then
    headParam.dialog = Localization:GetString(GameDialogDefine.CLICK_WATER)
  elseif state == Wasteland_PlantState.ToReap then
    headParam.dialog = Localization:GetString(GameDialogDefine.CLICK_REAP)
  end
  headParam.modelName = "HeadSpine_ben"
  headParam.modelPosition = 1
  headParam.isRecommend = true
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideHeadTalk) then
    EventManager:GetInstance():Broadcast(EventId.RefreshUIGuideHeadTalk, headParam)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideHeadTalk, {anim = true, playEffect = false}, headParam)
  end
end

function UIFarmActionView:RemoveHead()
  if self.showHead and self.needRemoveHead then
    self.showHead = false
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideHeadTalk, {anim = true, playEffect = false})
  end
end

return UIFarmActionView
