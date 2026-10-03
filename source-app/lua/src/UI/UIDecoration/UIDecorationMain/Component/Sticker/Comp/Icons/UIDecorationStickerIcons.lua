local base = UIBaseContainer
local map_sticker_scroll_view_path = "mapStickerScrollView"
local UIDecorationStickerIconCell = require("UI.UIDecoration.UIDecorationMain.Component.Sticker.Comp.Icons.UIDecorationStickerIconCell")
local remain_time_path = "RemainTime"
local remain_time_text_path = "RemainTime/RemainTimeText"
local remain_time_info_btn_path = "RemainTime/RemainTimeInfoBtn"
local p_text_icons_select_name_path = "p_text_icons_select_name"
local UIDecorationStickerIcons = BaseClass("UIDecorationStickerIcons", UIBaseContainer)

function UIDecorationStickerIcons:ComponentDefine()
  self.mapStickerScrollView = self:AddComponent(UIScrollView, map_sticker_scroll_view_path)
  self.mapStickerScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateTowColCell(itemObj, index, self.mapStickerScrollView)
  end)
  self.mapStickerScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteTwoColCell(itemObj, index, self.mapStickerScrollView)
  end)
  self.remain_time = self:AddComponent(UIBaseContainer, remain_time_path)
  self.remain_time_text = self:AddComponent(UIText, remain_time_text_path)
  self.remain_time_info_btn = self:AddComponent(UIButton, remain_time_info_btn_path)
  self.remain_time_info_btn:SetOnClick(function()
    UIUtil.ShowBubbleTips(CS.GameEntry.Localization:GetString("season_mastery_s2_UI_25"), self.remain_time_info_btn.transform.position, 0, -20, -20)
  end)
  self.p_text_icons_select_name = self:AddComponent(UITextMeshProUGUIEx, p_text_icons_select_name_path)
end

function UIDecorationStickerIcons:ComponentDestroy()
  self.remain_time = nil
  self.remain_time_text = nil
  self.remain_time_info_btn = nil
  self.remain_time_info_btn = nil
  self.p_text_icons_select_name = nil
end

function UIDecorationStickerIcons:DataDefine()
end

function UIDecorationStickerIcons:DataDestroy()
end

function UIDecorationStickerIcons:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIDecorationStickerIcons:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDecorationStickerIcons:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DecorationStickerIconSelect, self.OnSelectEvent)
end

function UIDecorationStickerIcons:OnRemoveListener()
  self:RemoveUIListener(EventId.DecorationStickerIconSelect, self.OnSelectEvent)
  base.OnRemoveListener(self)
end

function UIDecorationStickerIcons:SetData(dataList, currentSelect, curSubType)
  self.dataList = dataList
  self.currentSelect = currentSelect
  self.curSubType = curSubType
  self:RefreshScrollView()
  self:RefreshBtn()
  self:RefreshRemainTime()
end

function UIDecorationStickerIcons:RefreshScrollView()
  self.mapStickerScrollView:SetActive(true)
  self:ClearTwoScroll()
  local count = table.count(self.dataList)
  self.mapStickerScrollView:SetTotalCount(count)
  self.mapStickerScrollView:RefillCells()
end

function UIDecorationStickerIcons:OnCreateTowColCell(itemObj, index)
  local scrollView = self.mapStickerScrollView
  itemObj.name = tostring(index)
  local cellItem = scrollView:AddComponent(UIDecorationStickerIconCell, itemObj)
  local data = self.dataList[index]
  cellItem:ReInit(data, self.currentSelect, UIDecorationIconCellParentType.UIDecorationIconCell)
end

function UIDecorationStickerIcons:OnDeleteTwoColCell(itemObj, index)
  local scrollView = self.mapStickerScrollView
  scrollView:RemoveComponent(itemObj.name, UIDecorationStickerIconCell)
end

function UIDecorationStickerIcons:ClearTwoScroll()
  local scrollView = self.mapStickerScrollView
  scrollView:ClearCells()
  scrollView:RemoveComponents(UIDecorationStickerIconCell)
end

function UIDecorationStickerIcons:RefreshBtn()
  local data = DataCenter.DecorationDataManager:GetSkinDataById(self.currentSelect)
  local template = DataCenter.DecorationTemplateManager:GetTemplate(self.currentSelect)
  if not template then
    self.remain_time:SetActive(false)
    self.p_text_icons_select_name:SetActive(false)
    return
  else
    self.remain_time:SetActive(true)
    self.p_text_icons_select_name:SetActive(true)
  end
  if template.customVariable and tonumber(template.customVariable) > 0 then
    local stickerTemplate = DataCenter.ChatEmojiTemplateManager:GetStickerTempData(tonumber(template.customVariable))
    if stickerTemplate then
      self.p_text_icons_select_name:SetLocalText(stickerTemplate.sticker_name)
    end
  end
  local isSeasonSkinId = DataCenter.DecorationTemplateManager:IsSeasonSkin(self.currentSelect)
  local showTime = false
  local showUnlock = true
  if data == nil then
    if template:IsDefault() then
      showTime = true
      showUnlock = false
    end
  elseif data:IsInExpireTime() then
    showUnlock = false
    showTime = true
  end
  if showUnlock == true then
    local isUnlock = DataCenter.StickerWithDecorationLinkManager:CheckIsUnlockByDecoId(self.currentSelect)
    if isUnlock then
      showTime = true
    end
  end
  self.remain_time:SetActive(showTime)
  self.remain_time_info_btn:SetActive(isSeasonSkinId)
end

function UIDecorationStickerIcons:RefreshRemainTime()
  if self.remain_time and self.remain_time:GetActive() then
    local now = UITimeManager:GetInstance():GetServerTime()
    local template = DataCenter.DecorationTemplateManager:GetTemplate(self.currentSelect)
    local restTimeStr = ""
    local data = DataCenter.DecorationDataManager:GetSkinDataById(self.currentSelect)
    if not template then
      return
    end
    local expireTime = DataCenter.StickerWithDecorationLinkManager:GetExpireTimeByDecoId(self.currentSelect)
    if expireTime and 0 < expireTime then
      local restTime = expireTime - now
      restTime = math.max(0, restTime)
      restTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(restTime)
      if restTime <= 0 then
        self:OnUserSkinUpdate()
      end
    else
      restTimeStr = CS.GameEntry.Localization:GetString("2000464")
    end
    self.remain_time_text:SetText(restTimeStr)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.remain_time.transform)
end

function UIDecorationStickerIcons:OnUserSkinUpdate()
  self:RefreshBtn()
end

function UIDecorationStickerIcons:OnSelectEvent(decorationId)
  self.currentSelect = decorationId
  self:RefreshBtn()
  self:RefreshRemainTime()
end

function UIDecorationStickerIcons:Update1000MS()
  self:RefreshRemainTime()
end

return UIDecorationStickerIcons
