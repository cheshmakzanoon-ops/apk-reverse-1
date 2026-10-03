local UILWActDetectTreasureALPanelView = BaseClass("UILWActDetectTreasureALPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWActDetectTreasureALPanelPlayerItemRender = require("UI.UIActMonopoly.UILWActDetectTreasureALPanel.Component.UILWActDetectTreasureALPanelPlayerItemRender")
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
local needRefreshTime = -1

function UILWActDetectTreasureALPanelView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.activityId = self:GetUserData()
  self.haveSendMsg = false
  self:SetConfigView()
  self:RefreshView()
  PostEventLog.Track(PostEventLog.Defines.ActMonopolyActRadarTreasureListOpen, {})
end

function UILWActDetectTreasureALPanelView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWActDetectTreasureALPanelView:ComponentDefine()
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
  self.common_bg_orange = self:AddComponent(UIRawImage, common_bg_orange_path)
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
end

function UILWActDetectTreasureALPanelView:ComponentDestroy()
  self.panel_btn = nil
  self.title_text = nil
  self.close_tips_text = nil
  self.bg_raw_image = nil
  self.close_btn = nil
  self.showCellItems = nil
  self.player_scroll_view:ClearCells()
  self.player_scroll_view:RemoveComponents(UILWActDetectTreasureALPanelPlayerItemRender)
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
end

function UILWActDetectTreasureALPanelView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceBaseDataUpdated, self.RefreshView)
  self:AddUIListener(EventId.ActDetectTreasureInfoGet, self.RefreshView)
end

function UILWActDetectTreasureALPanelView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceBaseDataUpdated, self.RefreshView)
  self:RemoveUIListener(EventId.ActDetectTreasureInfoGet, self.RefreshView)
end

function UILWActDetectTreasureALPanelView:RefreshView()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local data = DataCenter.ActDetectTreasureDataManager:GetArrData(self.activityId)
  self.showData = {}
  local expireTime = 0
  needRefreshTime = -1
  if data and data.arr and data.expireTime then
    for k, v in ipairs(data.arr) do
      if curTime < v.endTime then
        table.insert(self.showData, v)
        if needRefreshTime < 0 or needRefreshTime < v.endTime then
          needRefreshTime = v.endTime
        end
      end
    end
    expireTime = data.expireTime
  end
  table.sort(self.showData, function(a, b)
    local aReceiveState = a.receiveState and a.receiveState or 0
    local bReceiveState = b.receiveState and b.receiveState or 0
    if aReceiveState ~= bReceiveState then
      return aReceiveState < bReceiveState
    end
    if a.state ~= b.state then
      return a.state > b.state
    end
    return a.endTime < b.endTime
  end)
  if curTime >= expireTime and not self.haveSendMsg then
    self.haveSendMsg = true
    SFSNetwork.SendMessage(MsgDefines.ActivityDetectList, self.activityId)
  end
  if #self.showData > 0 then
    self.player_scroll_view:SetActive(true)
    self.no_alliance_content:SetActive(false)
    self.player_scroll_view:SetTotalCount(#self.showData)
    self.player_scroll_view:RefillCells()
  else
    self.player_scroll_view:SetActive(false)
    self.no_alliance_content:SetActive(true)
    local hasAlliance = LuaEntry.Player:IsInAlliance()
    local isCrossServer = CrossServerUtil.CheckCrossServerWithWatchAndJoinType()
    if hasAlliance then
      self.alliance_top_content:SetActive(true)
      if not isCrossServer then
        self.top_tip_txt:SetLocalText("activity_sports_uitips_019")
      else
        self.top_tip_txt:SetLocalText("activity_wajueji_27001_tips5")
      end
    else
      self.alliance_top_content:SetActive(false)
    end
  end
  local curNum = DataCenter.ActDetectTreasureDataManager:GetCurDigTimesByActivityId(self.activityId)
  local maxNum = DataCenter.ActDetectTreasureDataManager:GetMaxDigTimesByActivityId(self.activityId)
  self.have_get_tips_text:SetLocalText("activity_sports_uitips_014", string.format("%s/%s", curNum, maxNum))
end

function UILWActDetectTreasureALPanelView:OnPlayerItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.player_scroll_view:AddComponent(UILWActDetectTreasureALPanelPlayerItemRender, itemObj)
  self.showCellItems[itemObj.name] = itemRender
  itemRender:ReInit(self.showData[index], self.activityId)
end

function UILWActDetectTreasureALPanelView:OnPlayerItemMoveOut(itemObj, index)
  self.showCellItems[itemObj.name] = nil
  self.player_scroll_view:RemoveComponent(itemObj.name, UILWActDetectTreasureALPanelPlayerItemRender)
end

function UILWActDetectTreasureALPanelView:OnAddALBtnClick()
  self.ctrl:CloseSelf()
end

function UILWActDetectTreasureALPanelView:Update1000MS()
  if self.showCellItems == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for k, v in pairs(self.showCellItems) do
    v:UpdateTimeView()
  end
  if 0 < needRefreshTime and curTime > needRefreshTime then
    self:RefreshView()
  end
end

function UILWActDetectTreasureALPanelView:OnBtnInfoClick()
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if activityInfo == nil then
    return
  end
  local eventId = 0
  local detect_para = activityInfo.detect_para
  local paraList = string.string2array_i_oneSep(detect_para, ";")
  if paraList and 2 <= #paraList then
    eventId = paraList[1]
  end
  if eventId <= 0 then
    return
  end
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(tostring(eventId))
  if template == nil then
    return
  end
  local goodId = 0
  local para = template.para3
  local paraList = string.string2array_i_oneSep(para, ";")
  if paraList and #paraList == 2 then
    goodId = paraList[1]
  end
  if goodId <= 0 then
    return
  end
  local goodsTemp = DataCenter.ItemTemplateManager:GetItemTemplate(goodId)
  local dropInfoDetail = 0
  if goodsTemp then
    dropInfoDetail = goodsTemp.drop_info_para
  end
  if 0 < dropInfoDetail then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIProbabilityNotice, {anim = true}, dropInfoDetail, "richman_boss_desc2")
  end
end

function UILWActDetectTreasureALPanelView:SetConfigView()
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if activityInfo == nil then
    return
  end
  local activityDetailData = DataCenter.ActMonopolyDataManager:GetActData(self.activityId)
  if activityDetailData == nil then
    return
  end
  local paraTemp = DataCenter.ActMonopolyDataManager:GetMonopolyParaTempById(activityInfo.richman_para)
  if paraTemp == nil then
    return
  end
  if not string.IsNullOrEmpty(paraTemp.para13) then
    local path = string.format(UIAssets.UIActMonopolyTexturePath, paraTemp.para13)
    self.bg_raw_image:LoadSprite(path)
  end
  if not string.IsNullOrEmpty(paraTemp.para14) then
    local showData = string.split(paraTemp.para14, "|")
    if #showData == 5 then
      local path = string.format(UIAssets.UIActMonopolyTexturePath, showData[1])
      self.common_bg_orange:LoadSprite(path)
      if self.showData and #self.showData == 0 then
        path = string.format(UIAssets.UIActDetectTreasureSpritePath, showData[3])
      else
        path = string.format(UIAssets.UIActDetectTreasureSpritePath, showData[4])
      end
      self.common_bg_orange2:LoadSprite(path)
    end
  end
  if not string.IsNullOrEmpty(paraTemp.para15) then
    local showData = string.split(paraTemp.para15, "|")
    if #showData == 8 then
      local path = string.format(UIAssets.UIActMonopolySpritePath, showData[1])
      self.alliance_top_content:LoadSprite(path)
      local colorList = string.string2array_i_oneSep(showData[2], ",")
      if #colorList == 4 then
        self.top_tip_txt:SetColorRGBA255(colorList[1], colorList[2], colorList[3], colorList[4])
      end
      path = string.format(UIAssets.UIActMonopolySpritePath, showData[3])
      self.line_content_icon:LoadSprite(path)
      path = string.format(UIAssets.UIActMonopolySpritePath, showData[4])
      self.center_content:LoadSprite(path)
      path = string.format(UIAssets.UIActMonopolySpritePath, showData[5])
      self.corner1:LoadSprite(path)
      self.corner2:LoadSprite(path)
      self.corner3:LoadSprite(path)
      self.corner4:LoadSprite(path)
      path = string.format(UIAssets.UIActMonopolySpritePath, showData[6])
      self.top_line:LoadSprite(path)
      self.bottom_line:LoadSprite(path)
      path = string.format(UIAssets.UIActMonopolySpritePath, showData[7])
      self.left_line:LoadSprite(path)
      self.right_line:LoadSprite(path)
      colorList = string.string2array_i_oneSep(showData[8], ",")
      if #colorList == 4 then
        self.center_tip_txt:SetColorRGBA255(colorList[1], colorList[2], colorList[3], colorList[4])
      end
    end
  end
  self.center_tip_txt:SetLocalText(paraTemp.party_empty)
  local detect_para = activityInfo.detect_para
  local paraList = string.string2array_i_oneSep(detect_para, ";")
  local eventId = 0
  if paraList and 2 <= #paraList then
    eventId = paraList[1]
  end
  if 0 < eventId then
    local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(tostring(eventId))
    if template then
      self.title_text:SetLocalText(template.name)
    end
  end
end

return UILWActDetectTreasureALPanelView
