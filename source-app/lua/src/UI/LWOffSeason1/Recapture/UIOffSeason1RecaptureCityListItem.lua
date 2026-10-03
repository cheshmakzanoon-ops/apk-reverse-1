local base = UIBaseContainer
local UIOffSeason1RecaptureCityListItem = BaseClass("UIOffSeason1RecaptureCityListItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIOffSeason1RecaptureCityItem = require("UI.LWOffSeason1.Recapture.UIOffSeason1RecaptureCityItem")
local UIOffSeason1RecaptureFeatureItem = require("UI.LWOffSeason1.Recapture.UIOffSeason1RecaptureFeatureItem")

function UIOffSeason1RecaptureCityListItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIOffSeason1RecaptureCityListItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIOffSeason1RecaptureCityListItem:ComponentDefine()
  self.compArrowIcon = self:AddComponent(UIBaseComponent, "TitleContent/ArrowIcon")
  self.compArrowIconSelect = self:AddComponent(UIBaseComponent, "TitleContent/ArrowIconSelect")
  self.textMember = self:AddComponent(UITextMeshProUGUIEx, "TitleContent/MemberText")
  self.compTipsContent = self:AddComponent(UIBaseComponent, "TipsContent")
  self.textTips = self:AddComponent(UITextMeshProUGUIEx, "TipsContent/TipsText")
  self.compDivide = self:AddComponent(UIBaseComponent, "Divide")
  self.btn = self:AddComponent(UIButton, "TitleContent")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.cityItem = self:AddComponent(UIBaseComponent, "CityListContent/CityItem")
  self.cityListContent = self:AddComponent(UIBaseContainer, "CityListContent")
  self.cityItem:SetActive(false)
  self.cityItemPool = self.cityItem.gameObject
  self.cityItemPool:GameObjectCreatePool()
  self.cityItems = {}
  self.featureItem = self:AddComponent(UIOffSeason1RecaptureFeatureItem, "TitleContent/FeatureItem")
end

function UIOffSeason1RecaptureCityListItem:ComponentDestroy()
  self:ClearContent()
  self.compArrowIcon = nil
  self.compArrowIconSelect = nil
  self.textMember = nil
  self.compTipsContent = nil
  self.textTips = nil
  self.compDivide = nil
  self.btn = nil
  self.cityItem = nil
  self.cityListContent = nil
  self.featureItem = nil
end

function UIOffSeason1RecaptureCityListItem:DataDefine()
  self:SetSelect(false)
end

function UIOffSeason1RecaptureCityListItem:DataDestroy()
  self.isSelect = nil
  self.textMemberText = nil
end

function UIOffSeason1RecaptureCityListItem:OnAddListener()
  base.OnAddListener(self)
end

function UIOffSeason1RecaptureCityListItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIOffSeason1RecaptureCityListItem:Refresh(level, monsterInfoList, presidentChooseIndex)
  self.presidentChooseIndex = presidentChooseIndex
  self.monsterInfoList = monsterInfoList
  self.textMemberText = Localization:GetString("s1_offseason_activity_recapture_cityTap", level, #monsterInfoList)
  self.textMember:SetText(self.textMemberText)
  self:SetSelect(self.isSelect)
  self.featureItem:Refresh(presidentChooseIndex ~= nil, nil)
end

function UIOffSeason1RecaptureCityListItem:GetTextMemberText()
  return self.textMemberText
end

function UIOffSeason1RecaptureCityListItem:SetSelect(isSelect)
  self.isSelect = isSelect
  if self.isSelect then
    self.compDivide:SetActive(true)
    if self.monsterInfoList and #self.monsterInfoList > 0 then
      self.cityListContent:SetActive(true)
      self.compTipsContent:SetActive(false)
      self:RefreshCityListContent()
    else
      self.cityListContent:SetActive(false)
      self.compTipsContent:SetActive(true)
    end
  else
    self.cityListContent:SetActive(false)
    self.compTipsContent:SetActive(false)
    self.compDivide:SetActive(true)
  end
end

function UIOffSeason1RecaptureCityListItem:RefreshCityListContent()
  local count = #self.monsterInfoList
  for i = 1, count do
    local item = self.cityItems[i]
    if item == nil then
      local go = self.cityItemPool:GameObjectSpawn(self.cityListContent.transform)
      go.name = "monsterItem" .. i
      item = self.cityListContent:AddComponent(UIOffSeason1RecaptureCityItem, go.name)
      self.cityItems[i] = item
    end
    item:SetActive(true)
    item:Refresh(self.monsterInfoList[i])
  end
  for i = count + 1, #self.cityItems do
    self.cityItems[i]:SetActive(false)
  end
end

function UIOffSeason1RecaptureCityListItem:ClearContent()
  self.cityListContent:RemoveComponents(UIOffSeason1RecaptureCityItem)
  self.cityItemPool:GameObjectRecycleAll()
  self.cityItems = nil
end

function UIOffSeason1RecaptureCityListItem:OnBtnClick()
  self:SetSelect(not self.isSelect)
end

function UIOffSeason1RecaptureCityListItem:ShowGuideTip(tipStr)
  if self.cityItems and self.cityItems[1] then
    self.cityItems[1]:ShowGuideTip(tipStr)
  end
end

return UIOffSeason1RecaptureCityListItem
