local UITrainRightsItemComponent = BaseClass("UITrainRightsItemComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIImage, "RightsItem/icon")
  self.button = self:AddComponent(UIButton, "RightsItem")
  self.button:SetOnClick(function()
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.button = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.param = nil
  self.trainData = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetRightInfo(self, rightInfo, nowGiftLevel, index, data)
  self.icon:LoadSprite(rightInfo.icon)
  self.param = {
    title = rightInfo.title,
    desc = rightInfo.desc,
    needLv = rightInfo.gift_lv,
    satisfyCondition = nowGiftLevel >= rightInfo.gift_lv,
    index = index
  }
  self.trainData = nil
  if data then
    self.trainData = data
  else
    self.trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  end
  if self.trainData then
    if not self.param.satisfyCondition and self.trainData.buyFlag == 0 then
      CS.UIGray.SetGrayWithIgnore(self.button.transform, true, "")
    else
      self.icon:SetMaterial(nil)
    end
  end
end

local function OnBtnClick(self)
  self.view:SetBubbleInfo(self.param, self.trainData.buyFlag == 1)
end

UITrainRightsItemComponent.OnCreate = OnCreate
UITrainRightsItemComponent.OnDestroy = OnDestroy
UITrainRightsItemComponent.OnEnable = OnEnable
UITrainRightsItemComponent.OnDisable = OnDisable
UITrainRightsItemComponent.ComponentDefine = ComponentDefine
UITrainRightsItemComponent.ComponentDestroy = ComponentDestroy
UITrainRightsItemComponent.DataDefine = DataDefine
UITrainRightsItemComponent.DataDestroy = DataDestroy
UITrainRightsItemComponent.OnAddListener = OnAddListener
UITrainRightsItemComponent.OnRemoveListener = OnRemoveListener
UITrainRightsItemComponent.SetRightInfo = SetRightInfo
UITrainRightsItemComponent.OnBtnClick = OnBtnClick
return UITrainRightsItemComponent
