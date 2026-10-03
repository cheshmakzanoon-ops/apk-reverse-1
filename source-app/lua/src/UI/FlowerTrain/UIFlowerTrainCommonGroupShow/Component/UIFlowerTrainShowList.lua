local UIFlowerTrainShowList = BaseClass("UIFlowerTrainShowList", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIFlowerTrainShowListItem = require("UI.FlowerTrain.UIFlowerTrainCommonGroupShow.Component.UIFlowerTrainShowListItem")
local title_text_path = "TitleText"
local close_tips_text_path = "CloseTipsText"
local bg_raw_image_path = "BgRawImage"
local close_btn_path = "CloseBtn"
local player_scroll_view_path = "PlayerScrollView"
local player_scroll_view_new_path = "PlayerScrollViewNew"
local content_path = "PlayerScrollViewNew/Viewport/Content"
local no_alliance_content_path = "NoAllianceContent"
local add_a_l_btn_path = "NoAllianceContent/AddALBtn"
local have_get_tips_text_path = "HaveGetTipsText"
local btn_info_path = "BtnInfo"
local btn_tips_path = "BtnTips"
local alliance_top_content_path = "NoAllianceContent/allianceTopContent"
local center_tip_txt_path = "NoAllianceContent/centerContent/centerTipTxt"
local top_tip_txt_path = "NoAllianceContent/allianceTopContent/topTipTxt"
local common_bg_orange_path = "Common_bg_orange"
local common_bg_orange2_path = "Common_bg_orange2"
local center_content_path = "NoAllianceContent/centerContent"
local corner1_path = "NoAllianceContent/centerContent/lineContent/corner1"
local corner2_path = "NoAllianceContent/centerContent/lineContent/corner2"
local corner3_path = "NoAllianceContent/centerContent/lineContent/corner3"
local corner4_path = "NoAllianceContent/centerContent/lineContent/corner4"
local top_line_path = "NoAllianceContent/centerContent/lineContent/topLine"
local bottom_line_path = "NoAllianceContent/centerContent/lineContent/bottomLine"
local left_line_path = "NoAllianceContent/centerContent/lineContent/leftLine"
local right_line_path = "NoAllianceContent/centerContent/lineContent/rightLine"
local line_content_icon_path = "NoAllianceContent/centerContent/lineContentIcon"
local needRefreshTime = -1
local ArrExpireTime = 2000

function UIFlowerTrainShowList:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.groupId, self.activityId, self.actBanquetId = self.view:GetUserData()
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  local partyNewId = actInfo.subType
  local actBanquetTemplate = DataCenter.ActivityPartyNewTemplateManager:GetActBanquetTemplate(partyNewId)
  self.itemTemplateId = actBanquetTemplate.treasure_id
  self.paraMeta = FlowerTrainUtils.GetFlowerTrainParaMetaByGoodsId(self.itemTemplateId)
  self.haveSendMsg = false
  self:SetConfigView()
  FlowerTrainUtils.ShowRecentlyLikeAndCheers()
  PostEventLog.Track(PostEventLog.Defines.FlowerTrain_Show_Alliance_Panel)
end

function UIFlowerTrainShowList:OnDestroy()
  self:DestroyData()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFlowerTrainShowList:ComponentDefine()
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.close_tips_text = self:AddComponent(UITextMeshProUGUIEx, close_tips_text_path)
  self.close_tips_text:SetLocalText("radar_tips_10")
  self.bg_raw_image = self:AddComponent(UIRawImage, bg_raw_image_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.showCellItems = {}
  self.player_scroll_view_new = self:AddComponent(UILoopListView2, player_scroll_view_new_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.player_scroll_view_new:InitListViewParam2(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end, nil, nil, function(loopListViewItem)
    self:OnRecycleItemFunc(loopListViewItem)
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
  self.btn_tips = self:AddComponent(UIButton, btn_tips_path)
  self.btn_tips:SetOnClick(function()
    self:OnBtnTipsClick()
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

function UIFlowerTrainShowList:ComponentDestroy()
  self.content:RemoveComponents(UIFlowerTrainShowListItem)
  self.player_scroll_view_new:ClearAllItems()
  self.player_scroll_view_new = nil
  self.panel_btn = nil
  self.title_text = nil
  self.close_tips_text = nil
  self.bg_raw_image = nil
  self.close_btn = nil
  self.showCellItems = nil
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
  self.player_scroll_view_new = nil
  self.content = nil
end

function UIFlowerTrainShowList:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceBaseDataUpdated, self.RefreshView)
  self:AddUIListener(EventId.FlowerTrainGetFinishReward, self.RefreshViewWithMessage)
  self:AddUIListener(EventId.UIFlowerTrain_ShowAllianceTrainList, self.OnDataReceive)
end

function UIFlowerTrainShowList:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceBaseDataUpdated, self.RefreshView)
  self:RemoveUIListener(EventId.FlowerTrainGetFinishReward, self.RefreshViewWithMessage)
  self:RemoveUIListener(EventId.UIFlowerTrain_ShowAllianceTrainList, self.OnDataReceive)
end

function UIFlowerTrainShowList:ClearRefreshViewTimer()
  if self.refreshViewTimer ~= nil then
    self.refreshViewTimer:Stop()
    self.refreshViewTimer = nil
  end
end

function UIFlowerTrainShowList:DataDefine()
  self.itemIndex = 0
  self.data = {}
  self:ClearRefreshViewTimer()
end

function UIFlowerTrainShowList:DestroyData()
  self.itemIndex = 0
  self.data = {}
  self:ClearRefreshViewTimer()
end

function UIFlowerTrainShowList:OnDataReceive(arr)
  self.data.arr = arr
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.data.expireTime = curTime + ArrExpireTime
  self:RefreshView()
end

function UIFlowerTrainShowList:OnGetItemByIndex(listview, index)
  if self.showData == nil or index < 0 or index >= #self.showData then
    return nil
  end
  index = index + 1
  local item = listview:NewListViewItem("UIFlowerTrainShowItem")
  if item == nil then
    return
  end
  local script = self.content:GetComponent(item.gameObject.name, UIFlowerTrainShowListItem)
  if script == nil then
    local objectName = item.gameObject.name .. tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.content:AddComponent(UIFlowerTrainShowListItem, objectName)
  end
  script:SetActive(true)
  script:ReInit(self.showData[index], self.activityId, self.actBanquetId)
  self.showCellItems[item.name] = script
  return item
end

function UIFlowerTrainShowList:OnRecycleItemFunc(loopListViewItem)
  if loopListViewItem == nil then
    return
  end
  self.showCellItems[loopListViewItem.name] = nil
end

function UIFlowerTrainShowList:RefreshView()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local data = self.data
  self.showData = {}
  local expireTime = 0
  needRefreshTime = -1
  if data and data.arr and data.expireTime then
    for k, v in ipairs(data.arr) do
      if v.arriveTime and curTime < v.arriveTime or v.uid == LuaEntry.Player.uid then
        table.insert(self.showData, v)
        if curTime < v.arriveTime and (needRefreshTime < 0 or needRefreshTime > v.arriveTime) then
          needRefreshTime = v.arriveTime
        end
      end
    end
    expireTime = data.expireTime
  end
  table.sort(self.showData, function(a, b)
    local selfUid = LuaEntry.Player.uid
    local aIsSelf = a.uid == selfUid
    local bIsSelf = b.uid == selfUid
    if aIsSelf ~= bIsSelf then
      return aIsSelf
    end
    return a.arriveTime < b.arriveTime
  end)
  if curTime >= expireTime then
    SFSNetwork.SendMessage(MsgDefines.FlowerTrainAlliance)
  end
  self.player_scroll_view_new:SetListItemCount(#self.showData, false, false)
  self.player_scroll_view_new:RefreshAllShownItem()
  if #self.showData > 0 then
    self.no_alliance_content:SetActive(false)
  else
    self.no_alliance_content:SetActive(true)
    local hasAlliance = LuaEntry.Player:IsInAlliance()
    if hasAlliance then
      self.alliance_top_content:SetActive(true)
    else
      self.alliance_top_content:SetActive(false)
    end
  end
  local curNum = FlowerTrainUtils.GetFlowerTrainClaimLvBoxCount(self.itemTemplateId)
  local maxNum = FlowerTrainUtils.GetFlowerTrainWorldTreasureMetaDailyMax(self.itemTemplateId)
  self.have_get_tips_text:SetLocalText("2025halloween_treasure_list_tips1", curNum, maxNum)
end

function UIFlowerTrainShowList:RefreshViewWithMessage()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.data.expireTime = curTime
  self:RefreshView()
end

function UIFlowerTrainShowList:OnAddALBtnClick()
  self.ctrl:CloseSelf()
end

function UIFlowerTrainShowList:Update1000MS()
  if self.showCellItems == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for k, v in pairs(self.showCellItems) do
    v:UpdateTimeView()
  end
  if 0 < needRefreshTime and curTime > needRefreshTime then
    self:RefreshViewWithMessage()
  end
end

function UIFlowerTrainShowList:OnBtnInfoClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFlowerTrainProbability, {anim = true}, {
    itemId = self.itemTemplateId
  })
end

function UIFlowerTrainShowList:OnBtnTipsClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFlowerTrainRules, {anim = true}, {
    itemId = self.itemTemplateId
  })
end

function UIFlowerTrainShowList:SetConfigView()
  local data = DataCenter.ActivityPartyNewTemplateManager:GetActBanquetTemplate(self.actBanquetId)
  if data == nil then
    return
  end
  local treasure_para = data.treasure_para
  if string.IsNullOrEmpty(treasure_para) then
    return
  end
  local paraTemp = string.split(treasure_para, "|")
  if not string.IsNullOrEmpty(paraTemp[1]) then
    local path = string.format(UIAssets.UIActMonopolyTexturePath, paraTemp[1])
    self.bg_raw_image:LoadSprite(path)
  end
  if not string.IsNullOrEmpty(paraTemp[2]) then
    local path = string.format(UIAssets.UIActMonopolyTexturePath, paraTemp[2])
    self.common_bg_orange:LoadSprite(path)
  end
  if not string.IsNullOrEmpty(paraTemp[5]) then
    local path = string.format(UIAssets.UIActDetectTreasureSpritePath, paraTemp[5])
    self.common_bg_orange2:LoadSprite(path)
  end
  if not string.IsNullOrEmpty(paraTemp[7]) then
    local showData = {}
    for i = 8, 15 do
      table.insert(showData, paraTemp[i])
    end
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
  self.center_tip_txt:SetLocalText(paraTemp[16] or "")
  self.top_tip_txt:SetLocalText(paraTemp[17] or "")
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if activityInfo then
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
end

return UIFlowerTrainShowList
