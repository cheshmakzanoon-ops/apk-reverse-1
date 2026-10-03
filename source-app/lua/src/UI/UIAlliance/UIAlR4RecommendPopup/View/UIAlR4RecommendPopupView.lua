local UIAlR4RecommendPopupView = BaseClass("UIAlR4RecommendPopupView", UIBaseView)
local UIAlR4RecommendPlayerCardItem = require("UI/UIAlliance/UIAlR4RecommendPopup/Component/UIAlR4RecommendPlayerCardItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIAlR4RecommendPopupView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitPopup()
end

function UIAlR4RecommendPopupView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAlR4RecommendPopupView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnMask:SetOnClick(function()
    self:OnBtnMaskClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compPlayerCardItem3 = self.viewSkin:AddComponent(self, UIAlR4RecommendPlayerCardItem, 5)
  self.compPlayerCardItem2 = self.viewSkin:AddComponent(self, UIAlR4RecommendPlayerCardItem, 6)
  self.compPlayerCardItem1 = self.viewSkin:AddComponent(self, UIAlR4RecommendPlayerCardItem, 7)
  self.compPlayerCardItemList = {
    self.compPlayerCardItem1,
    self.compPlayerCardItem2,
    self.compPlayerCardItem3
  }
end

function UIAlR4RecommendPopupView:ComponentDestroy()
  self.viewSkin = nil
  self.btnMask = nil
  self.textTitle = nil
  self.btnClose = nil
  self.textTip = nil
  self.compPlayerCardItem3 = nil
  self.compPlayerCardItem2 = nil
  self.compPlayerCardItem1 = nil
  self.compPlayerCardItemList = nil
end

function UIAlR4RecommendPopupView:DataDefine()
  self.recommendDataList = {}
end

function UIAlR4RecommendPopupView:DataDestroy()
  self.recommendDataList = nil
end

function UIAlR4RecommendPopupView:OnBtnMaskClick()
  self.ctrl:CloseSelf()
end

function UIAlR4RecommendPopupView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIAlR4RecommendPopupView:InitPopup()
  local initParam = self:GetUserData() or {}
  self.recommendDataList = initParam
  self.textTitle:SetLocalText("r4Recommend_title")
  self.textTip:SetLocalText("r4Recommend_desc")
  self:UpdatePlayerCardList()
end

function UIAlR4RecommendPopupView:UpdatePlayerCardList()
  for i, compPlayerCartItem in ipairs(self.compPlayerCardItemList) do
    local recommendData = self.recommendDataList[i]
    if table.IsNullOrEmpty(recommendData) or table.IsNullOrEmpty(recommendData.recommendInfo) or table.IsNullOrEmpty(recommendData.roleInfo) then
      compPlayerCartItem:SetActive(false)
    else
      compPlayerCartItem:SetActive(true)
      compPlayerCartItem:UpdatePlayerCard(recommendData)
    end
  end
end

return UIAlR4RecommendPopupView
