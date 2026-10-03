local UIFormationSoldierTip = BaseClass("UIFormationSoldierTip", UIBaseView)
local base = UIBaseView
local SoldierTipItem = require("UI.UIFormation.UIFormationSoldierTip.Component.UISoldierTipItem")
local content_path = "Tip/Bg"
local arrow_path = "Tip/Arrow"
local allCloseBtn_path = "Mask"
local closeBtn_path = "Tip/Bg/CloseBtn/Btn"
local topTitle_path = "Tip/Bg/TitleText"
local topDesc_path = "Tip/Bg/DescRoot/DescText"
local topDescRoot_path = "Tip/Bg/DescRoot"
local scrollTopTextRoot_path = "Tip/Bg/TitleName"
local scrollRoot_path = "Tip/Bg/ItemScroll"
local scrollContent_path = "Tip/Bg/ItemScroll/Viewport/Content"
local scorllTopRank_path = "Tip/Bg/TitleName/SoldierRank"
local scrollTopCount_path = "Tip/Bg/TitleName/SoldierCount"
local scrollTopMorale_path = "Tip/Bg/TitleName/SoldierMorale"
local itemContent_path = "Tip/Bg/ItemScroll/Viewport/Item"
local scrollBottomTextRoot_path = "Tip/Bg/TotalInfo"
local scorllBottomRank_path = "Tip/Bg/TotalInfo/TotalTitle"
local scrollBottomCount_path = "Tip/Bg/TotalInfo/TotalCount"
local scrollBottomMorale_path = "Tip/Bg/TotalInfo/TotalMorale"
local bottom_soldierInfoRoot_path = "Tip/Bg/SoldierInfo"
local bottom_soldierInfoTitle_path = "Tip/Bg/SoldierInfo/Bg/TextDamage/SoldierDescText"
local bottom_soldierInfoNum_path = "Tip/Bg/SoldierInfo/Bg/TextDamage/SoldierNumText"
local bottom_soldierInfoDesc_path = "Tip/Bg/SoldierInfo/Bg/DescText/SDescText"
local bottom_soldierInfoSlider_path = "Tip/Bg/SoldierInfo/Bg/SSlider"
local bottom_soldierInfoSliderNum_path = "Tip/Bg/SoldierInfo/Bg/SSlider/SRatio"
local bottom_moraleInfoRoot_path = "Tip/Bg/MoraleInfo"
local bottom_moraleInfoTitle_path = "Tip/Bg/MoraleInfo/Bg/TextDamage/MoraleDescText"
local bottom_moraleInfoNum_path = "Tip/Bg/MoraleInfo/Bg/TextDamage/MoraleNumText"
local bottom_moraleInfoDesc_path = "Tip/Bg/MoraleInfo/Bg/DescText/MDescText"
local bottom_moraleInfoSlider_path = "Tip/Bg/MoraleInfo/Bg/MSlider"
local bottom_moraleInfoSliderNum_path = "Tip/Bg/MoraleInfo/Bg/MSlider/MRatio"
local tSignFirst_path = "Tip/Bg/TotalInfo/fImg"
local tSignSec_path = "Tip/Bg/TotalInfo/sImg"
local signFirst_path = "Tip/Bg/MoraleInfo/Bg/TextDamage/mImg"
local signSec_path = "Tip/Bg/SoldierInfo/Bg/TextDamage/sImg"
local line_path = "Tip/Bg/MoraleInfo/Bg/Line"
local itemRoot_path = "Tip/Bg/ItemRoot"

function UIFormationSoldierTip:OnCreate()
  base.OnCreate(self)
  self:DefineComponent()
end

function UIFormationSoldierTip:DefineComponent()
  self.content = self:AddComponent(UIBaseContainer, arrow_path)
  self.imgArrow = self:AddComponent(UIBaseContainer, content_path)
  self.allCloseBtn = self:AddComponent(UIButton, allCloseBtn_path)
  self.allCloseBtn:SetOnClick(function()
    self.view.ctrl:CloseSelf()
  end)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtn:SetOnClick(function()
    self.view.ctrl:CloseSelf()
  end)
  self.itemRoot = self:AddComponent(UIBaseContainer, itemRoot_path)
  self.topTitle = self:AddComponent(UIText, topTitle_path)
  self.topDesc = self:AddComponent(UIText, topDesc_path)
  self.topDescRoot = self.transform:Find(topDescRoot_path).gameObject
  self.scrollRoot = self.transform:Find(scrollRoot_path)
  self.scrollTopTextRoot = self.transform:Find(scrollTopTextRoot_path)
  self.scorllTopRank = self:AddComponent(UIText, scorllTopRank_path)
  self.scrollTopCount = self:AddComponent(UIText, scrollTopCount_path)
  self.scrollTopMorale = self:AddComponent(UIText, scrollTopMorale_path)
  self.itemGo = self.transform:Find(itemContent_path).gameObject
  self.itemGo:GameObjectCreatePool()
  self.scorllBottomRankRoot = self.transform:Find(scrollBottomTextRoot_path)
  self.scorllBottomRank = self:AddComponent(UIText, scorllBottomRank_path)
  self.scrollBottomCount = self:AddComponent(UIText, scrollBottomCount_path)
  self.scrollBottomMorale = self:AddComponent(UIText, scrollBottomMorale_path)
  self.bottomSoldierInfoRoot = self.transform:Find(bottom_soldierInfoRoot_path)
  self.bottomSoldierInfoTitle = self:AddComponent(UIText, bottom_soldierInfoTitle_path)
  self.bottomSoldierInfoNum = self:AddComponent(UIText, bottom_soldierInfoNum_path)
  self.bottomSoldierInfoDesc = self:AddComponent(UIText, bottom_soldierInfoDesc_path)
  self.bottomSoldierSlider = self:AddComponent(UISlider, bottom_soldierInfoSlider_path)
  self.bottomSoldierInfoSliderNum = self:AddComponent(UIText, bottom_soldierInfoSliderNum_path)
  self.bottomMoraleInfoRoot = self.transform:Find(bottom_moraleInfoRoot_path)
  self.bottomMoraleInfoTitle = self:AddComponent(UIText, bottom_moraleInfoTitle_path)
  self.bottomMoraleInfoNum = self:AddComponent(UIText, bottom_moraleInfoNum_path)
  self.bottomMoraleInfoDesc = self:AddComponent(UIText, bottom_moraleInfoDesc_path)
  self.bottomMoraleSlider = self:AddComponent(UISlider, bottom_moraleInfoSlider_path)
  self.bottomMoraleInfoSliderNum = self:AddComponent(UIText, bottom_moraleInfoSliderNum_path)
  self.tSignFirst = self.transform:Find(tSignFirst_path).gameObject
  self.tSignSec = self.transform:Find(tSignSec_path).gameObject
  self.signFirst = self.transform:Find(signFirst_path).gameObject
  self.signSec = self.transform:Find(signSec_path).gameObject
  self.line = self.transform:Find(line_path).gameObject
end

function UIFormationSoldierTip:OnEnable()
  self.param = self:GetUserData()
  self.data = self.param.data
  self:SetPos()
  self:RefreshContent()
end

local ParamData = {
  position = Vector2.zero,
  deltaX = 0,
  deltaY = 0,
  contentX = 0,
  closeCallBack = nil,
  data = nil
}
UIFormationSoldierTip.ParamDataClass = DataClass("ParamDataClass", ParamData)

function UIFormationSoldierTip:RefreshContent()
  if self.data.curSoldierNum == 0 then
    self:OnSoldierCapacityIsZero()
  else
    self:OnSoldierCapacityIsNotZero()
    if self.data.curSoldierNum == self.data.totalSoldierNum then
      self.topDescRoot:SetActive(false)
    else
      local mySoldierPercent = math.floor(self.data.curSoldierNum / self.data.totalSoldierNum * 100)
      self.topDescRoot:SetActive(true)
      self.topDesc:SetLocalText(458604, mySoldierPercent)
    end
  end
end

function UIFormationSoldierTip:OnSoldierCapacityIsZero()
  self.topDesc:SetLocalText("458575")
  self.scrollRoot.gameObject:SetActive(false)
  self.scrollTopTextRoot.gameObject:SetActive(false)
end

function UIFormationSoldierTip:OnSoldierCapacityIsNotZero()
  self:GenerateSoldierListView()
end

function UIFormationSoldierTip:OnArmyMoraleNotZero()
  local myMoraleBig = true
  local moralePercent = 0
  local value
  if self.data.armySoldierMorale < self.data.mySoldierMorale then
    local percent = self.data.mySoldierMorale / self.data.armySoldierMorale - 1
    if 1 <= percent then
      percent = 1
    elseif percent <= 0 then
      percent = 0
    end
    moralePercent = percent * 100
  else
    local percent = self.data.armySoldierMorale / self.data.mySoldierMorale - 1
    if 1 <= percent then
      percent = 1
    elseif percent <= 0 then
      percent = 0
    end
    moralePercent = percent * 100
    myMoraleBig = false
  end
  if myMoraleBig then
    value = math.floor(self.data.mySoldierMorale / self.data.armySoldierMorale * 10) / 10
    self.bottomMoraleInfoTitle:SetLocalText("458571")
    self.bottomSoldierInfoTitle:SetLocalText("458573")
    if 1 < value then
      self.bottomMoraleInfoDesc:SetLocalText(458602, value)
    else
      self.bottomMoraleInfoDesc:SetLocalText(458599, value)
    end
    self.bottomMoraleInfoNum:SetText(string.format("<color=#099b4a>%s</color>", math.floor(moralePercent) .. "%"))
    local sliderValue = math.min(1, self.data.mySoldierMorale / (self.data.armySoldierMorale + self.data.mySoldierMorale))
    self.bottomMoraleSlider:SetValue(sliderValue)
  else
    value = math.floor(self.data.armySoldierMorale / self.data.mySoldierMorale * 10) / 10
    self.bottomMoraleInfoTitle:SetLocalText("458572")
    self.bottomSoldierInfoTitle:SetLocalText("458572")
    if 1 < value then
      self.bottomMoraleInfoDesc:SetLocalText(458603, value)
    else
      self.bottomMoraleInfoDesc:SetLocalText(458600, value)
    end
    self.bottomMoraleInfoNum:SetText(string.format("<color=#ea4242>%s</color>", math.floor(moralePercent) .. "%"))
    local sliderValue = math.min(1, self.data.armySoldierMorale / (self.data.armySoldierMorale + self.data.mySoldierMorale))
    self.bottomMoraleSlider:SetValue(1 - sliderValue)
  end
  local moraleDescNum = string.GetFormattedStr(math.floor(self.data.mySoldierMorale)) .. ": " .. string.GetFormattedStr(math.floor(self.data.armySoldierMorale))
  self.bottomMoraleInfoSliderNum:SetText(moraleDescNum)
end

function UIFormationSoldierTip:OnArmyMoraleIsZero()
  self.bottomMoraleInfoTitle:SetLocalText(454132)
  self.bottomSoldierInfoTitle:SetLocalText(458573)
  self.bottomMoraleInfoNum:SetText("")
  self.bottomSoldierInfoNum:SetText("")
  self.bottomMoraleInfoDesc:SetLocalText(458579)
  self.bottomMoraleSlider:SetValue(0.5)
  local moraleDescNum = string.GetFormattedStr(math.floor(self.data.mySoldierMorale)) .. ":" .. "\239\188\159\239\188\159\239\188\159"
  self.bottomMoraleInfoSliderNum:SetText(moraleDescNum)
end

function UIFormationSoldierTip:GenerateSoldierListView()
  self.cellsGo = {}
  self.cellItem = {}
  self.itemRoot:RemoveComponents(SoldierTipItem)
  self.itemGo:GameObjectRecycleAll()
  local list = self.data.soldierList
  local index = 1
  local totalCount = 0
  local totalMorale = 0
  if list ~= nil then
    for k, v in pairs(list) do
      local item = self.itemGo:GameObjectSpawn(self.itemRoot.transform)
      item.name = tostring(index)
      table.insert(self.cellsGo, item)
      local cell = self.itemRoot:AddComponent(SoldierTipItem, item.name, v)
      cell:SetData(v)
      index = index + 1
      totalCount = totalCount + v.count
      totalMorale = totalMorale + cell:GetTotalMorale()
    end
  end
  self.scrollBottomCount:SetText(string.GetFormattedStr(totalCount))
  self.scrollBottomMorale:SetText(string.GetFormattedStr(totalMorale))
end

function UIFormationSoldierTip:SetPos()
  local contentDeltaX = 166
  local contentDeltaY = 5
  local arrowMidPosX = 80
  self.contentWidth = self.content.transform.sizeDela
  local arrowX = self.param.position.x + self.param.deltaX
  local arrowY = self.param.position.y + self.param.deltaY
  self.imgArrow:SetPositionXYZ(arrowX, arrowY, 0)
  local anchoredPosition = self.imgArrow:GetAnchoredPosition()
  local contentPosX = 0
  local contentPosY = 0
  arrowX = anchoredPosition.x
  arrowY = anchoredPosition.y
  if anchoredPosition.x > 0 then
    if arrowMidPosX < anchoredPosition.x then
      contentPosX = arrowX - contentDeltaX
    else
      contentPosX = arrowX - contentDeltaX - (arrowMidPosX - anchoredPosition.x)
    end
  elseif anchoredPosition.x < -arrowMidPosX then
    contentPosX = arrowX + contentDeltaX
  else
    contentPosX = arrowX + contentDeltaX - (arrowMidPosX - anchoredPosition.x)
  end
  contentPosY = arrowY + contentDeltaY
  contentPosX = contentPosX + self.param.contentX
  self.content:SetAnchoredPositionXY(contentPosX, contentPosY)
end

function UIFormationSoldierTip:OnDestroy()
  self:ComponentDestroy()
  if self.cellsGo then
    for _, v in pairs(self.cellsGo) do
      v:GameObjectRecycle()
    end
  end
  self.cellsGo = nil
end

function UIFormationSoldierTip:ComponentDestroy()
  self.content = nil
  self.imgArrow = nil
  self.allCloseBtn = nil
  self.closeBtn = nil
  self.topTitle = nil
  self.topDesc = nil
  self.scrollRoot = nil
  self.scorllTopRank = nil
  self.scrollTopCount = nil
  self.scrollTopMorale = nil
  self.itemGo.gameObject:GameObjectRecycleAll()
  self.itemGo = nil
  self.scorllBottomRank = nil
  self.scorllBottomRank = nil
  self.scrollBottomCount = nil
  self.scrollBottomMorale = nil
  self.bottomSoldierInfoRoot = nil
  self.bottomSoldierInfoTitle = nil
  self.bottomSoldierInfoNum = nil
  self.bottomSoldierInfoDesc = nil
  self.bottomSoldierSlider = nil
  self.bottomSoldierInfoSliderNum = nil
  self.bottomMoraleInfoRoot = nil
  self.bottomMoraleInfoTitle = nil
  self.bottomMoraleInfoNum = nil
  self.bottomMoraleInfoDesc = nil
  self.bottomMoraleSlider = nil
  self.bottomMoraleInfoSliderNum = nil
end

return UIFormationSoldierTip
