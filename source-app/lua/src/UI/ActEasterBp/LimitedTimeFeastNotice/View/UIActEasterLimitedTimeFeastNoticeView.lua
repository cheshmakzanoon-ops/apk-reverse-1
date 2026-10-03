local UIActEasterLimitedTimeFeastNoticeView = BaseClass("UIActEasterLimitedTimeFeastNoticeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LimitedTimeFeastNoticeNewItem = require("UI.LimitedTimeFeastNotice.Component.LimitedTimeFeastNoticeNewItem")
local LimitedTimeFeastNoticeTipNewItem = require("UI.LimitedTimeFeastNotice.Component.LimitedTimeFeastNoticeTipNewItem")
local bg1DefaultPath = "Assets/Main/Sprites/UI/CommonBG/cfm_tongyon_tanchuang_da_diban.png"
local bg2DefaultPath = "Assets/Main/Sprites/UI/CommonBG/cfm_tongyon_tanchuang_erjichen.png"
local contentBodyDefaultColor = Color.New(0.45098039215686275, 0.40784313725490196, 0.38823529411764707, 1.0)
local common_bg_orange_path = "UICommonPopUpTitle/Common_bg_orange"
local common_bg_path = "Root/Common_bg"
local v_f_x_effect_path = "UICommonPopUpTitle/Common_bg_orange/VFX_effect"
local tip_txt_path = "Root/LoopListScroll/TipTxtItem/TipTxt"
local content_path = "Root/LoopListScroll/viewPort/Content"
local ItemType = {Text = 1, RateItem = 2}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
  self:RefreshViewPacking()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.showData then
    return nil
  end
  local packData = self.showData[index]
  local itemObjName = "noticeItem"
  if packData.type == ItemType.Text then
    itemObjName = "TipTxtItem"
  end
  local item = loopScroll:NewListViewItem(itemObjName)
  local scriptType = LimitedTimeFeastNoticeNewItem
  if packData.type == ItemType.Text then
    scriptType = LimitedTimeFeastNoticeTipNewItem
  end
  local script = self.content:GetComponent(item.gameObject.name, scriptType)
  if script == nil then
    NameCount = NameCount + 1
    local objectName = itemObjName .. tostring(NameCount)
    item.gameObject.name = objectName
    script = self.content:AddComponent(scriptType, objectName)
  end
  script:SetActive(true)
  script:SetData(packData, self.scroll_view, index - 1)
  return item
end

local function ComponentDefine(self)
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(BindCallback(self, self.OnClickCloseBtn))
  self.closeBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/Common_bg_orange/CloseBtn")
  self.closeBtn:SetOnClick(BindCallback(self, self.OnClickCloseBtn))
  self.textTitle = self:AddComponent(UIText, "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText")
  self.scroll_view = self:AddComponent(UILoopListView2, "Root/LoopListScroll")
  self.scroll_view:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.common_bg_orange = self:AddComponent(UIImage, common_bg_orange_path)
  self.v_f_x_effect = self:AddComponent(UIVfx, v_f_x_effect_path)
  self.common_bg_orange2 = self:AddComponent(UIImage, common_bg_path)
  self.contentText = self:AddComponent(UIText, tip_txt_path)
end

local function ComponentDestroy(self)
  self:ClearContent()
  self.btnPanel = nil
  self.closeBtn = nil
  self.textTitle = nil
  self.common_bg_orange = nil
  self.common_bg_orange2 = nil
  self.v_f_x_effect:Remove()
  self.v_f_x_effect = nil
  self.contentText = nil
end

local function DataDefine(self)
  self.param = self:GetUserData()
  self.activityId = self.param.activityId
  self.dataList = self.param.dataList
end

local function DataDestroy(self)
  self.param = nil
  self.activityId = nil
  self.dataList = nil
end

local function ClearContent(self)
  self.content:RemoveAllComponentes()
  self.scroll_view:ClearAllItems()
end

local function OnOpen(self)
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.showData = {}
  if activityInfo and not string.IsNullOrEmpty(activityInfo.story) then
    table.insert(self.showData, {
      type = ItemType.Text,
      text = activityInfo.story
    })
  end
  for i, v in ipairs(self.dataList) do
    table.insert(self.showData, {
      type = ItemType.RateItem,
      data = v
    })
  end
  if #self.showData > 0 then
    self.scroll_view:SetListItemCount(#self.showData, false, false)
    self.scroll_view:RefreshAllShownItem()
    self.scroll_view:MovePanelToItemIndex(0)
  end
end

local function OnClickCloseBtn(self)
  self.ctrl:CloseSelf()
end

function UIActEasterLimitedTimeFeastNoticeView:RefreshViewPacking()
  if self.activityId then
    local lineData = LocalController:instance():getLine(TableName.Activity, self.activityId)
    if lineData == nil then
      Logger.LogError("Activity GetTemplate lineData is nil id:" .. self.param.activityId)
      return nil
    end
    if string.IsNullOrEmpty(lineData.festival_interface_config) then
      self:SetDefaultPacking()
      return
    end
    self:ModifyPanelPacking(tonumber(lineData.festival_interface_config))
  else
    self:SetDefaultPacking()
  end
end

function UIActEasterLimitedTimeFeastNoticeView:SetDefaultPacking()
  self.common_bg_orange:LoadSprite(bg1DefaultPath)
  self.common_bg_orange2:LoadSprite(bg2DefaultPath)
  self.v_f_x_effect:Remove()
  self.v_f_x_effect:SetActive(false)
  self.contentText:SetColor(contentBodyDefaultColor)
end

function UIActEasterLimitedTimeFeastNoticeView:ModifyPanelPacking(festivalInterfaceCfgId)
  local lineData = LocalController:instance():getLine(TableName.Festival_Interface_Config, festivalInterfaceCfgId)
  if lineData == nil then
    Logger.LogError("Festival_Interface_Config GetTemplate lineData is nil id:" .. festivalInterfaceCfgId)
    return
  end
  if string.IsNullOrEmpty(lineData.board_di) then
    self.common_bg_orange:LoadSprite(bg1DefaultPath)
  else
    local path = DataCenter.ActivityListDataManager:GetActivityModLoadPath(UIAssets.UIActLWUIActEasterCommonPath, lineData.board_di)
    self.common_bg_orange:LoadSprite(path)
  end
  if string.IsNullOrEmpty(lineData.board_di_text) then
    self.common_bg_orange2:LoadSprite(bg2DefaultPath)
    self.contentText:SetColor(contentBodyDefaultColor)
  else
    local configList = string.split(lineData.board_di_text, "|")
    local path = DataCenter.ActivityListDataManager:GetActivityModLoadPath(UIAssets.UIActLWUIActEasterCommonPath, configList[1])
    self.common_bg_orange2:LoadSprite(path)
    local tmpColor255 = string.string2array_i_oneSep(configList[2], ",")
    local targetColor = Color.New(tmpColor255[1] / 255, tmpColor255[2] / 255, tmpColor255[3] / 255, tmpColor255[4] / 255)
    self.contentText:SetColor(targetColor)
  end
  if string.IsNullOrEmpty(lineData.board_prefab) then
    self.v_f_x_effect:SetActive(false)
    self.v_f_x_effect:Remove()
  else
    self.v_f_x_effect:SetActive(true)
    self.v_f_x_effect:PlayByStay(lineData.board_prefab, {isBreak = true})
  end
end

UIActEasterLimitedTimeFeastNoticeView.OnCreate = OnCreate
UIActEasterLimitedTimeFeastNoticeView.OnDestroy = OnDestroy
UIActEasterLimitedTimeFeastNoticeView.ComponentDefine = ComponentDefine
UIActEasterLimitedTimeFeastNoticeView.ComponentDestroy = ComponentDestroy
UIActEasterLimitedTimeFeastNoticeView.DataDefine = DataDefine
UIActEasterLimitedTimeFeastNoticeView.DataDestroy = DataDestroy
UIActEasterLimitedTimeFeastNoticeView.ClearContent = ClearContent
UIActEasterLimitedTimeFeastNoticeView.OnClickCloseBtn = OnClickCloseBtn
UIActEasterLimitedTimeFeastNoticeView.OnOpen = OnOpen
return UIActEasterLimitedTimeFeastNoticeView
