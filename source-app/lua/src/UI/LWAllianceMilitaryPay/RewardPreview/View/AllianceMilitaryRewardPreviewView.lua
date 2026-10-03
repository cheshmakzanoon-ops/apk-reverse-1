local AllianceMilitaryRewardPreviewView = BaseClass("AllianceMilitaryRewardPreviewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local OptionData = CS.TMPro.TMP_Dropdown.OptionData
local Item = require("UI/LWAllianceMilitaryPay/RewardPreview/Component/AllianceMilitaryRewardPreviewItem")

function AllianceMilitaryRewardPreviewView:OnCreate()
  base.OnCreate(self)
  self.data = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function AllianceMilitaryRewardPreviewView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllianceMilitaryRewardPreviewView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.txtDesc1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.txtGiftDesc1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.txtGiftDesc2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.txtGiftLevel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.scrollView = self.viewSkin:AddComponent(self, UIScrollView, 5)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.txtTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnBg = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnBg:SetOnClick(function()
    self:OnBtnBgClick()
  end)
  self.compJpSpine = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.compSpine = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.txtTitle:SetLocalText("alliance_pay_title_reward")
  self.txtDesc1:SetLocalText("alliance_pay_desc_reward")
  self.txtGiftDesc1:SetLocalText("alliance_pay_desc_giftLv")
  self.txtGiftDesc2:SetLocalText("alliance_pay_desc_selectPreview")
  self.drop = self:AddComponent(UIDropdown, "mid/levelDrop")
  self.drop:SetOnValueChanged(function(idx)
    self:OnLevelDropChange(idx)
  end)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function AllianceMilitaryRewardPreviewView:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.txtDesc1 = nil
  self.txtGiftDesc1 = nil
  self.txtGiftDesc2 = nil
  self.txtGiftLevel = nil
  self.scrollView = nil
  self.btnClose = nil
  self.txtTitle = nil
  self.btnBg = nil
  self.compJpSpine = nil
  self.compSpine = nil
end

function AllianceMilitaryRewardPreviewView:InitView()
  self:InitDrop()
  self:RefreshScrollView()
  self.txtGiftLevel:SetText(string.format("Lv.%d", self.data.giftLevel))
  self:SetSpinePos()
end

function AllianceMilitaryRewardPreviewView:InitDrop()
  self.drop:Clear()
  local str = LuaEntry.DataConfig:TryGetStr("alliance_pay_config", "k1")
  local arr = string.string2table_ii_toList(str, ";", "|")
  local selectedIndex = 0
  for i = 1, #arr do
    local optionData = OptionData()
    local minLevel = arr[i][1]
    local maxLevel = arr[i][2]
    if minLevel == maxLevel then
      optionData.text = string.format("Lv.%d", minLevel)
    else
      optionData.text = string.format("Lv.%d-%d", minLevel, maxLevel)
    end
    self.drop:Add(optionData)
    if minLevel <= self.data.giftLevel and maxLevel >= self.data.giftLevel then
      selectedIndex = i - 1
    end
  end
  self.drop:SetValueWithoutNotify(selectedIndex)
  self.curLevel = selectedIndex + 1
end

function AllianceMilitaryRewardPreviewView:DataDefine()
  self:InitShowTemplate()
end

function AllianceMilitaryRewardPreviewView:InitShowTemplate()
  local templates = DataCenter.AlliancePayTemplateManager:GetTemplatesByType(AllianceSalaryType.WeeklySalary)
  table.sort(templates, function(a, b)
    return a.order < b.order
  end)
  self.templates = {}
  for k, v in ipairs(templates) do
    if DataCenter.AllianceBaseDataManager:IsR4orR5() and v.show_type == 1 then
      table.insert(self.templates, v)
    elseif v.show_type == 0 then
      table.insert(self.templates, v)
    end
  end
end

function AllianceMilitaryRewardPreviewView:DataDestroy()
end

function AllianceMilitaryRewardPreviewView:OnAddListener()
  base.OnAddListener(self)
end

function AllianceMilitaryRewardPreviewView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AllianceMilitaryRewardPreviewView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function AllianceMilitaryRewardPreviewView:OnLevelDropChange(idx)
  self.curLevel = idx + 1
  self:RefreshScrollView()
end

function AllianceMilitaryRewardPreviewView:RefreshScrollView()
  if #self.templates > 0 then
    self.scrollView:SetTotalCount(#self.templates)
    self.scrollView:RefillCells()
  end
end

function AllianceMilitaryRewardPreviewView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(Item, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(self.templates[index], self.curLevel)
  end
end

function AllianceMilitaryRewardPreviewView:OnItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, Item)
end

function AllianceMilitaryRewardPreviewView:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(Item)
end

function AllianceMilitaryRewardPreviewView:OnBtnBgClick()
  self.ctrl:CloseSelf()
end

function AllianceMilitaryRewardPreviewView:SetSpinePos()
  local isJap = LuaEntry.Player.JPUser and DataCenter.LWSaveGirlManager:IsJPGirlOpen()
  self.compJpSpine:SetActive(isJap)
  self.compSpine:SetActive(not isJap)
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self.compJpSpine:SetLocalScaleXYZ(0.28, 0.28, 0.28)
    self.compSpine:SetLocalScaleXYZ(0.3, 0.3, 4.21)
  else
    self.compJpSpine:SetLocalScaleXYZ(-0.28, 0.28, 0.28)
    self.compSpine:SetLocalScaleXYZ(-0.3, 0.3, 4.21)
  end
end

return AllianceMilitaryRewardPreviewView
