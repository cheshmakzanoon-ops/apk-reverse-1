local UIWorldTrendRankItem = require("UI.UIWorldTrend.UIWorldTrendRank.Component.UIWorldTrendRankItem")
local UIWorldTrendRankView = BaseClass("UIWorldTrendRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Screen = CS.UnityEngine.Screen

function UIWorldTrendRankView:OnCreate()
  base.OnCreate(self)
  self.rankInfo = self:GetUserData()
  self:ComponentDefine()
  self:OnRefresh()
end

function UIWorldTrendRankView:ComponentDefine()
  self._title_txt = self:AddComponent(UIText, "UICommonPopUpTitle/Common_img_title/titleText")
  self.return_btn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.close_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self._titleName_txt = self:AddComponent(UIText, "ImgBg/select/Txt_TitleName")
  self._titleProgess_txt = self:AddComponent(UIText, "ImgBg/select/Txt_TitleProgress")
  self.ScrollView = self:AddComponent(UIScrollView, "ImgBg/ScrollView")
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function UIWorldTrendRankView:OnDestroy()
  self:ClearScroll()
  self._title_txt = nil
  self.return_btn = nil
  self.close_btn = nil
  self._titleName_txt = nil
  self._titleProgess_txt = nil
  self.ScrollView = nil
  base.OnDestroy(self)
end

function UIWorldTrendRankView:OnEnable()
  base.OnEnable(self)
end

function UIWorldTrendRankView:OnDisable()
  base.OnDisable(self)
end

function UIWorldTrendRankView:OnRefresh()
  self._title_txt:SetLocalText(302144)
  self._titleName_txt:SetLocalText(390288)
  local param = DataCenter.WorldTrendManager:GetParam()
  if param.type == 4 then
    self._titleProgess_txt:SetLocalText(302140)
  elseif param.type == 7 then
    local template = DataCenter.WorldTrendTemplateManager:GetTemplateById(param.id)
    self._titleProgess_txt:SetLocalText(302134, template:GetParam())
  end
  self.ScrollView:SetTotalCount(#self.rankInfo)
  self.ScrollView:RefillCells()
end

function UIWorldTrendRankView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(UIWorldTrendRankItem, itemObj)
  cellItem:RefreshData(self.rankInfo[index], index)
end

function UIWorldTrendRankView:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, UIWorldTrendRankItem)
end

function UIWorldTrendRankView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(UIWorldTrendRankItem)
end

return UIWorldTrendRankView
