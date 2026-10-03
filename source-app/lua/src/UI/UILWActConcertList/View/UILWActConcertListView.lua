local UILWActConcertListView = BaseClass("UILWActConcertListView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWActConcertItem = require("UI.UILWActConcertList.Component.UILWActConcertItem")
local panel_btn_path = "PanelBtn"
local title_text_path = "Content/TitleText"
local close_tips_text_path = "Content/CloseTipsText"
local bg_raw_image_path = "Content/BgRawImage"
local close_btn_path = "Content/CloseBtn"
local player_scroll_view_path = "Content/PlayerScrollView"
local no_alliance_content_path = "Content/NoAllianceContent"
local add_a_l_btn_path = "Content/NoAllianceContent/AddALBtn"
local have_get_tips_text_path = "Content/HaveGetTipsText"
local btn_info_path = "Content/BtnInfo"
local alliance_top_content_path = "Content/NoAllianceContent/allianceTopContent"
local center_tip_txt_path = "Content/NoAllianceContent/centerContent/centerTipTxt"
local top_tip_txt_path = "Content/NoAllianceContent/allianceTopContent/topTipTxt"
local common_bg_orange_path = "Content/Common_bg_orange"
local common_bg_orange2_path = "Content/Common_bg_orange2"
local center_content_path = "Content/NoAllianceContent/centerContent"
local corner1_path = "Content/NoAllianceContent/centerContent/lineContent/corner1"
local corner2_path = "Content/NoAllianceContent/centerContent/lineContent/corner2"
local corner3_path = "Content/NoAllianceContent/centerContent/lineContent/corner3"
local corner4_path = "Content/NoAllianceContent/centerContent/lineContent/corner4"
local top_line_path = "Content/NoAllianceContent/centerContent/lineContent/topLine"
local bottom_line_path = "Content/NoAllianceContent/centerContent/lineContent/bottomLine"
local left_line_path = "Content/NoAllianceContent/centerContent/lineContent/leftLine"
local right_line_path = "Content/NoAllianceContent/centerContent/lineContent/rightLine"
local line_content_icon_path = "Content/NoAllianceContent/centerContent/lineContentIcon"
local effect_v_f_x_path = "Content/Effect_VFX"
local bannerEffectPath = "Assets/Main/Prefabs/UI/ActMusicFestival2025/Effect/Eff_ui_2025Music_banner_Variant.prefab"

function UILWActConcertListView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.activityId = self:GetUserData()
  self.haveSendMsg = false
  self:SetConfigView()
  self:RequestConcertList()
end

function UILWActConcertListView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWActConcertListView:ComponentDefine()
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.close_tips_text = self:AddComponent(UITextMeshProUGUIEx, close_tips_text_path)
  self.close_tips_text:SetLocalText("radar_tips_10")
  self.panel_btn = self:AddComponent(UIButton, panel_btn_path)
  self.panel_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.bg_raw_image = self:AddComponent(UIRawImage, bg_raw_image_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.showCellItems = {}
  self.player_scroll_view = self:AddComponent(UIScrollView, player_scroll_view_path)
  self.player_scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnPlayerItemMoveIn(itemObj, index)
  end)
  self.player_scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnPlayerItemMoveOut(itemObj, index)
  end)
  self.no_alliance_content = self:AddComponent(UIBaseContainer, no_alliance_content_path)
  self.add_a_l_btn = self:AddComponent(UIButton, add_a_l_btn_path)
  self.add_a_l_btn:SetOnClick(function()
    self:OnAddALBtnClick()
  end)
  self.have_get_tips_text = self:AddComponent(UITextMeshProUGUIEx, have_get_tips_text_path)
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_info:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.alliance_top_content = self:AddComponent(UIImage, alliance_top_content_path)
  self.center_tip_txt = self:AddComponent(UITextMeshProUGUIEx, center_tip_txt_path)
  self.top_tip_txt = self:AddComponent(UITextMeshProUGUIEx, top_tip_txt_path)
  self.common_bg_orange = self:AddComponent(UIButton, common_bg_orange_path)
  self.common_bg_orange2 = self:AddComponent(UIImage, common_bg_orange2_path)
  self.center_content = self:AddComponent(UIImage, center_content_path)
  self.corner1 = self:AddComponent(UIImage, corner1_path)
  self.corner2 = self:AddComponent(UIImage, corner2_path)
  self.corner3 = self:AddComponent(UIImage, corner3_path)
  self.corner4 = self:AddComponent(UIImage, corner4_path)
  self.top_line = self:AddComponent(UIImage, top_line_path)
  self.bottom_line = self:AddComponent(UIImage, bottom_line_path)
  self.left_line = self:AddComponent(UIImage, left_line_path)
  self.right_line = self:AddComponent(UIImage, right_line_path)
  self.line_content_icon = self:AddComponent(UIImage, line_content_icon_path)
  self.effect_v_f_x = self:AddComponent(UIVfx, effect_v_f_x_path)
  self.effect_v_f_x:PlayByStay(bannerEffectPath, {isBreak = true})
end

function UILWActConcertListView:ComponentDestroy()
  self.panel_btn = nil
  self.title_text = nil
  self.close_tips_text = nil
  self.bg_raw_image = nil
  self.close_btn = nil
  self.showCellItems = nil
  self.player_scroll_view:ClearCells()
  self.player_scroll_view:RemoveComponents(UILWActConcertItem)
  self.player_scroll_view = nil
  self.center_tip_txt = nil
  self.top_tip_txt = nil
  self.common_bg_orange = nil
  self.common_bg_orange2 = nil
  self.center_content = nil
  self.corner1 = nil
  self.corner2 = nil
  self.corner3 = nil
  self.corner4 = nil
  self.top_line = nil
  self.bottom_line = nil
  self.left_line = nil
  self.right_line = nil
  self.line_content_icon = nil
  if self.effect_v_f_x then
    self.effect_v_f_x:Remove()
    self.effect_v_f_x = nil
  end
end

function UILWActConcertListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnRecSkinPartyList, self.RefreshView)
  self:AddUIListener(EventId.RefreshSkinPartyList, self.RefreshView)
end

function UILWActConcertListView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnRecSkinPartyList, self.RefreshView)
  self:RemoveUIListener(EventId.RefreshSkinPartyList, self.RefreshView)
end

function UILWActConcertListView:RequestConcertList()
  if CrossServerUtil:NeedIntercept() then
    return
  end
  DataCenter.ActConcertDataManager:RequestSkinPartyList(self.activityId)
end

function UILWActConcertListView:RefreshView()
  self.showData = DataCenter.ActConcertDataManager:GetConcertList()
  if #self.showData > 0 then
    self.player_scroll_view:SetActive(true)
    self.player_scroll_view:SetTotalCount(#self.showData)
    self.player_scroll_view:RefillCells()
    self.no_alliance_content:SetActive(false)
  else
    self.player_scroll_view:SetActive(false)
    self.no_alliance_content:SetActive(true)
  end
end

function UILWActConcertListView:OnPlayerItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.player_scroll_view:AddComponent(UILWActConcertItem, itemObj)
  self.showCellItems[itemObj.name] = itemRender
  itemRender:ReInit(self.showData[index], self.activityId)
end

function UILWActConcertListView:OnPlayerItemMoveOut(itemObj, index)
  self.showCellItems[itemObj.name] = nil
  self.player_scroll_view:RemoveComponent(itemObj.name, UILWActConcertItem)
end

function UILWActConcertListView:OnAddALBtnClick()
  EventManager:GetInstance():Broadcast(EventId.RemindChristmasTreeDonate)
  self.ctrl:CloseSelf()
end

function UILWActConcertListView:Update1000MS()
  if self.showCellItems == nil or self.showData == nil or #self.showData == 0 then
    return
  end
  for k, v in pairs(self.showCellItems) do
    v:UpdateTimeView()
  end
end

function UILWActConcertListView:OnBtnInfoClick()
  local goodsId = DataCenter.ActConcertDataManager:GetGoodsId(self.activityId)
  local goodsTemp = DataCenter.ItemTemplateManager:GetItemTemplate(goodsId)
  local dropInfoDetail = 0
  if goodsTemp then
    dropInfoDetail = goodsTemp.drop_info_para
  end
  if 0 < dropInfoDetail then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIProbabilityNotice, {anim = true}, dropInfoDetail, "richman_boss_desc2")
  end
end

function UILWActConcertListView:SetConfigView()
  local config = DataCenter.ActConcertDataManager:GetConcertListViewConfig(self.activityId)
  self.bg_raw_image:SetActive(false)
  if not string.IsNullOrEmpty(config.bgPicPath) then
    local path = string.format(UIAssets.ActConcertSpritePath, config.bgPicPath)
    self.common_bg_orange:LoadSprite(path)
  end
  if not string.IsNullOrEmpty(config.scrollPicPath) then
    local path = config.scrollPicPath
    self.common_bg_orange2:LoadSprite(path)
  end
  if not string.IsNullOrEmpty(config.title) then
    self.title_text:SetLocalText(config.title)
  end
  if not string.IsNullOrEmpty(config.emptyText) then
    self.top_tip_txt:SetLocalText(config.emptyText)
  end
  if not string.IsNullOrEmpty(config.getText) then
    self.center_tip_txt:SetLocalText(config.getText)
  end
  local curNum = DataCenter.ActConcertDataManager:GetClaimRewardCount(tonumber(config.status))
  local maxNum = config.bubbleLimit
  self.have_get_tips_text:SetLocalText("activity_sports_uitips_014", string.format("%s/%s", curNum, maxNum))
end

return UILWActConcertListView
