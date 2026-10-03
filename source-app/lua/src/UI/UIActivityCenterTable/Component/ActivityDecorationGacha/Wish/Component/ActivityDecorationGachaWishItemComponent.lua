local base = UIBaseContainer
local ActivityDecorationGachaWishItemComponent = BaseClass("ActivityDecorationGachaWishItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function ActivityDecorationGachaWishItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActivityDecorationGachaWishItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActivityDecorationGachaWishItemComponent:ComponentDefine()
  self.imgBG = self:AddComponent(UIImage, "Btn/BG")
  self.imgIcon = self:AddComponent(UIImage, "Btn/Icon")
  self.compDarkMask = self:AddComponent(UIBaseContainer, "Btn/DarkMask")
  self.compHaveContent = self:AddComponent(UIBaseContainer, "Btn/HaveContent")
  self.textLv = self:AddComponent(UIText, "Btn/HaveContent/Lv")
  self.slider = self:AddComponent(UISlider, "Btn/HaveContent/Slider")
  self.compNoHaveContent = self:AddComponent(UIBaseContainer, "Btn/NoHaveContent")
  self.textNoHaveTag = self:AddComponent(UIText, "Btn/NoHaveContent/NoHaveTagImage/NoHaveTagText")
  self.textNoHaveTag:SetText(Localization:GetString("decoration_recruit_desc11"))
  self.compMaxContent = self:AddComponent(UIBaseContainer, "Btn/MaxContent")
  self.textMax = self:AddComponent(UIText, "Btn/MaxContent/MaxText")
  self.textMax:SetText(Localization:GetString("decoration_recruit_desc12"))
  self.compSelectContent = self:AddComponent(UIBaseContainer, "Btn/SelectContent")
  self.compLightContent = self:AddComponent(UIBaseContainer, "Btn/LightContent")
  self.textLightName = self:AddComponent(UIText, "Btn/LightContent/LightNameText")
  self.textLightCount = self:AddComponent(UIText, "Btn/LightContent/LightCountText")
  self.compDarkContent = self:AddComponent(UIBaseContainer, "Btn/DarkContent")
  self.textDarkName = self:AddComponent(UIText, "Btn/DarkContent/DarkNameText")
  self.textDarkCount = self:AddComponent(UIText, "Btn/DarkContent/DarkCountText")
  self.btn = self:AddComponent(UIButton_LongPress, "Btn")
  self.btn:SetClickAction(function()
    self:OnBtnClick()
  end)
  self.btn:SetLongPressAction(function()
    self:OnBtnLongPress()
  end)
end

function ActivityDecorationGachaWishItemComponent:ComponentDestroy()
  self.imgBG = nil
  self.imgIcon = nil
  self.compDarkMask = nil
  self.compHaveContent = nil
  self.textLv = nil
  self.slider = nil
  self.compNoHaveContent = nil
  self.textNoHaveTag = nil
  self.compMaxContent = nil
  self.textMax = nil
  self.compSelectContent = nil
  self.compLightContent = nil
  self.textLightName = nil
  self.textLightCount = nil
  self.compDarkContent = nil
  self.textDarkName = nil
  self.textDarkCount = nil
  self.btnUIDecorationGachaWishItem = nil
end

function ActivityDecorationGachaWishItemComponent:DataDefine()
end

function ActivityDecorationGachaWishItemComponent:DataDestroy()
end

function ActivityDecorationGachaWishItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function ActivityDecorationGachaWishItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ActivityDecorationGachaWishItemComponent:Refresh()
  if self.wishData ~= nil and self.activityId ~= nil then
    self:ReInit(self.wishData, self.activityId)
  end
end

function ActivityDecorationGachaWishItemComponent:ReInit(wishData, activityId)
  if wishData == nil or activityId == nil or self.view == nil or self.view.ctrl == nil then
    return
  end
  self.wishData = wishData
  self.activityId = activityId
  self.itemDataTemplate = DataCenter.ActivityDecorationGachaManager:GetItemDataByItemId(activityId, self.wishData.itemId)
  if self.itemDataTemplate == nil or self.itemDataTemplate.decorationBuildingTemplate == nil then
    return
  end
  local baseImage = self.itemDataTemplate:GetDecorationBaseImage()
  if baseImage ~= nil then
    self.imgBG:LoadSprite(baseImage)
  end
  local image = self.itemDataTemplate:GetDecorationImage()
  self.imgIcon:LoadSpriteAuto(image)
  local showDark = false
  local curSelectWishData = self.view.ctrl:GetCurSelectWishData(self.activityId)
  local isSelect = curSelectWishData ~= nil and curSelectWishData.itemId == self.wishData.itemId and curSelectWishData.count == self.wishData.count
  if isSelect then
  end
  self.compSelectContent:SetActive(isSelect)
  self.buildDataExist = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(self.itemDataTemplate.decorationBuildingBaseId, false)
  self.buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(self.itemDataTemplate.decorationBuildingBaseId, true)
  self.compHaveContent:SetActive(false)
  self.compNoHaveContent:SetActive(false)
  self.compMaxContent:SetActive(false)
  self.compLightContent:SetActive(false)
  self.compDarkContent:SetActive(false)
  local isHave = self.buildData ~= nil
  if isHave then
    local isMax = self.buildData.level >= self.itemDataTemplate.decorationBuildingTemplate.max_level
    if isMax then
      self:UpdateMax(showDark)
    else
      self:UpdateHave(showDark)
    end
  else
    self:UpdateNotHave(showDark)
  end
  self.compDarkMask:SetActive(showDark)
end

function ActivityDecorationGachaWishItemComponent:OnBtnClick()
  if self.wishData == nil or self.activityId == nil or self.view == nil or self.view.ctrl == nil then
    return
  end
  self.view:SelectWishItem(self.wishData)
end

function ActivityDecorationGachaWishItemComponent:UpdateNotHave(showDark)
  self.compLightContent:SetActive(not showDark)
  self.compDarkContent:SetActive(showDark)
  if showDark then
    self.textDarkName:SetLocalText(self.itemDataTemplate.decorationBuildingTemplate.name)
    self.textDarkCount:SetActive(false)
  else
    self.textLightName:SetLocalText(self.itemDataTemplate.decorationBuildingTemplate.name)
    self.textLightCount:SetActive(false)
  end
  self.compNoHaveContent:SetActive(true)
end

function ActivityDecorationGachaWishItemComponent:UpdateMax(showDark)
  self.compLightContent:SetActive(not showDark)
  self.compDarkContent:SetActive(showDark)
  if showDark then
    self.textDarkName:SetLocalText(self.itemDataTemplate.decorationBuildingTemplate.name)
    self.textDarkCount:SetActive(false)
  else
    self.textLightName:SetLocalText(self.itemDataTemplate.decorationBuildingTemplate.name)
    self.textLightCount:SetActive(false)
  end
  self.compMaxContent:SetActive(true)
end

function ActivityDecorationGachaWishItemComponent:UpdateHave(showDark)
  local hasScore, needScore = 0
  local uuid = self.buildData.uuid
  if self.buildDataExist and self.buildData.level == self.buildDataExist.level then
    uuid = self.buildDataExist.uuid
  end
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  local curProgress, maxProgress = BuildingUtils.GetDecoProgressInfo(buildData.itemId, buildData.level)
  curProgress = curProgress or 0
  maxProgress = maxProgress or 0
  self.compLightContent:SetActive(not showDark)
  self.compDarkContent:SetActive(showDark)
  if showDark then
    self.textDarkName:SetLocalText(self.itemDataTemplate.decorationBuildingTemplate.name)
    self.textDarkCount:SetText(tostring(math.floor(curProgress)) .. "/" .. tostring(math.floor(maxProgress)))
    self.textDarkCount:SetActive(true)
  else
    self.textLightName:SetLocalText(self.itemDataTemplate.decorationBuildingTemplate.name)
    self.textLightCount:SetText(tostring(math.floor(curProgress)) .. "/" .. tostring(math.floor(maxProgress)))
    self.textLightCount:SetActive(true)
  end
  self.compHaveContent:SetActive(true)
  self.slider:SetValue(curProgress / maxProgress)
  self.textLv:SetLocalText("season_mastery_163", self.buildData.level)
end

function ActivityDecorationGachaWishItemComponent:OnBtnLongPress()
  if self.itemDataTemplate == nil or self.itemDataTemplate.decorationBuildingBaseId == nil then
    return
  end
  local param = {}
  param.baseBuildingId = self.itemDataTemplate.decorationBuildingBaseId
  param.alignObject = self.btn
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWDecorationBookProperty, {anim = false}, param)
end

return ActivityDecorationGachaWishItemComponent
