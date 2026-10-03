local UICommonItemProbabilityView = BaseClass("UICommonItemProbabilityView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIDetailsCell = require("UI.UIBuildUpgrade.Component.UIDetailsCell")

function UICommonItemProbabilityView:OnCreate()
  base.OnCreate(self)
  self.title = self:AddComponent(UIText, "UICommonMidPopUpTitle/titleText")
  self.close_btn = self:AddComponent(UIButton, "UICommonMidPopUpTitle/CloseBtn")
  self.return_btn = self:AddComponent(UIButton, "UICommonMidPopUpTitle/panel")
  self.close_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self.return_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self._title_txt = {}
  for i = 1, 3 do
    self._title_txt[i] = self:AddComponent(UIText, "DetailTitleCell/Text" .. i)
  end
  self._scroll_view = self:AddComponent(UIScrollView, "ScrollView")
  self._scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self._scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.template_obj = self:AddComponent(UIBaseContainer, "Template")
  self._select_img = self:AddComponent(UIImage, "Template/Img_Select")
end

function UICommonItemProbabilityView:OnDestroy()
  self._select_img.transform:SetParent(self.template_obj.transform)
  self.title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.text2 = nil
  self.action1 = nil
  self.closeAction = nil
  self.action2 = nil
  self.title = nil
  self.btn_2 = nil
  self.btn_2_txt = nil
  self.close_btn = nil
  self.return_btn = nil
  self._curNum_txt = nil
  base.OnDestroy(self)
end

function UICommonItemProbabilityView:OnEnable()
  base.OnEnable(self)
  self:RefreshData()
end

function UICommonItemProbabilityView:OnDisable()
  base.OnDisable(self)
end

function UICommonItemProbabilityView:RefreshData()
  self:ClearScroll()
  self.list, self.titleList, self.titleTxt, self.showIndex = self:GetUserData()
  self._select_img:SetActive(false)
  self.title:SetLocalText(self.titleTxt)
  for i = 1, 3 do
    if self.titleList[i] then
      self._title_txt[i]:SetActive(true)
      self._title_txt[i]:SetLocalText(self.titleList[i])
    else
      self._title_txt[i]:SetActive(false)
    end
  end
  if #self.list > 0 then
    self._scroll_view:SetTotalCount(#self.list)
    local toIndex = self.showIndex
    if self.showIndex and self.showIndex ~= 1 then
      toIndex = self.showIndex - 1
      if toIndex > #self.list - 6 then
        toIndex = #self.list - 6
      end
    end
    self._scroll_view:RefillCells(toIndex)
  end
end

function UICommonItemProbabilityView:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self._scroll_view:AddComponent(UIDetailsCell, itemObj)
  cellItem:ReInit(self.list[index])
  if self.showIndex and index == self.showIndex then
    self._select_img.transform:SetParent(cellItem.transform)
    self._select_img.transform:SetAsFirstSibling()
    self._select_img.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self._select_img.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self._select_img:SetActive(true)
  end
end

function UICommonItemProbabilityView:OnDeleteCell(itemObj, index)
  self._scroll_view:RemoveComponent(itemObj.name, UIDetailsCell)
  if self.showIndex and index == self.showIndex then
    self._select_img.transform:SetParent(self.template_obj.transform)
    self._select_img:SetActive(false)
  end
end

function UICommonItemProbabilityView:ClearScroll()
  self._scroll_view:ClearCells()
  self._scroll_view:RemoveComponents(UIDetailsCell)
end

function UICommonItemProbabilityView:OnClickFunc()
end

function UICommonItemProbabilityView:OnCloseInTimer()
end

return UICommonItemProbabilityView
