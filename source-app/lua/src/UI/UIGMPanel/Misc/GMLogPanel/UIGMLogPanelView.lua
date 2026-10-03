local UIGMLogPanelView = BaseClass("UIGMLogPanelView", UIBaseView)
local base = UIBaseView
local GameObject = CS.UnityEngine.GameObject
local Type_CS_Image = typeof(CS.UnityEngine.UI.Image)
local Type_CS_Button = typeof(CS.UnityEngine.UI.Button)
local ItemRenderer = require("UI.UIGMPanel.Misc.GMLogPanel.GMLogPanelItemRenderer")
local title_text_path = "DetailNode/UICommonPopUpTitle/Common_img_title/titleText"
local close_btn_path = "DetailNode/UICommonPopUpTitle/CloseBtn"
local detail_node_path = "DetailNode"
local scroll_view_path = "DetailNode/ScrollView"
local content_path = "DetailNode/ScrollView/View/Content"
local btn_refresh_path = "DetailNode/BottomBar/BtnRefresh"
local btn_clear_path = "DetailNode/BottomBar/BtnClear"
local tmp_btn_refresh_path = "DetailNode/BottomBar/BtnRefresh/TmpBtnRefresh"
local tmp_btn_clear_path = "DetailNode/BottomBar/BtnClear/TmpBtnClear"
local single_log_path = "DetailNode/SingleLog"
local btn_close_single_log_path = "DetailNode/SingleLog/BtnCloseSingleLog"
local img_type_icon_path = "DetailNode/SingleLog/ImgTypeIcon"
local tmp_single_time_path = "DetailNode/SingleLog/TmpSingleTime"
local single_log_content_path = "DetailNode/SingleLog/ScrollRect/ViewRect/SingleLogContent"
local btn_copy_path = "DetailNode/SingleLog/BtnCopy"
local toggle_warning_path = "DetailNode/Toggles/ToggleWarning"
local toggle_error_path = "DetailNode/Toggles/ToggleError"
local tmp_warning_label_path = "DetailNode/Toggles/ToggleWarning/TmpWarningLabel"
local tmp_error_label_path = "DetailNode/Toggles/ToggleError/TmpErrorLabel"
local warning_select_path = "DetailNode/Toggles/ToggleWarning/WarningSelect"
local error_select_path = "DetailNode/Toggles/ToggleError/ErrorSelect"

function UIGMLogPanelView:OnCreate()
  base.OnCreate(self)
  self.showDatalist = {}
  self.tmpDetailTitle = self:AddComponent(UIText, title_text_path)
  self.btnCloseDetail = self:AddComponent(UIButton, close_btn_path)
  self.goDetail = self.transform:Find(detail_node_path).gameObject
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.btnRefresh = self:AddComponent(UIButton, btn_refresh_path)
  self.btnClear = self:AddComponent(UIButton, btn_clear_path)
  self.tmpRefresh = self:AddComponent(UIText, tmp_btn_refresh_path)
  self.tmpClear = self:AddComponent(UIText, tmp_btn_clear_path)
  self.goSingleLog = self.transform:Find(single_log_path).gameObject
  self.btnCopy = self:AddComponent(UIButton, btn_copy_path)
  self.btnCloseSingleLog = self:AddComponent(UIButton, btn_close_single_log_path)
  self.imgTypeIcon = self:AddComponent(UIImage, img_type_icon_path)
  self.tmpSingleLogTime = self:AddComponent(UIText, tmp_single_time_path)
  self.tmpSingleLogDetail = self:AddComponent(UIText, single_log_content_path)
  self.toggle_warning = self:AddComponent(UIButton, toggle_warning_path)
  self.toggle_error = self:AddComponent(UIButton, toggle_error_path)
  self.warning_select = self:AddComponent(UIImage, warning_select_path)
  self.error_select = self:AddComponent(UIImage, error_select_path)
  self.tmp_warning_label = self:AddComponent(UITextMeshProUGUIEx, tmp_warning_label_path)
  self.tmp_error_label = self:AddComponent(UITextMeshProUGUIEx, tmp_error_label_path)
  self.btnCloseDetail:SetOnClick(BindCallback(self, self.CloseSelf))
  self.btnRefresh:SetOnClick(BindCallback(self, self.RefreshLogList))
  self.btnClear:SetOnClick(BindCallback(self, self.ClearLog))
  self.btnCloseSingleLog:SetOnClick(BindCallback(self, self.HideSingleLog))
  self.btnCopy:SetOnClick(BindCallback(self, self.CopyStacktrace))
  self.customBtns = {}
  self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.toggle_warning:SetOnClick(function()
    self:OnClickedWarning()
  end)
  self.toggle_error:SetOnClick(function()
    self:OnClickedError()
  end)
  self.tmpDetailTitle:SetText("Log")
  self.tmpRefresh:SetText("\229\136\183\230\150\176")
  self.tmpClear:SetText("\230\184\133\231\169\186\229\133\168\233\131\168")
  local lv = GMUtils.GetInt(GMConst.DebugLocalLogLevel, 3)
  self.showWarning = lv & 1 ~= 0
  self.showError = lv & 2 ~= 0
  self:HideSingleLog()
  self:RefreshLogList()
  self:RefreshToggleState()
end

function UIGMLogPanelView:OnEnable()
  base.OnEnable(self)
  self:RefreshLogCount()
end

function UIGMLogPanelView:OnDisable()
  base.OnDisable(self)
end

function UIGMLogPanelView:OnDestroy()
  self:ClearScroll()
  self:ClearCustomBtns()
  self.itemDisplayModeMenu = nil
  base.OnDestroy(self)
end

function UIGMLogPanelView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GM_LOG_COUNT_CHANGED, self.RefreshLogCount)
end

function UIGMLogPanelView:OnRemoveListener()
  self:RemoveUIListener(EventId.GM_LOG_COUNT_CHANGED, self.RefreshLogCount)
  base.OnRemoveListener(self)
end

function UIGMLogPanelView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(ItemRenderer, itemObj)
  cellItem:SetData(index, self.showDatalist[index], self)
end

function UIGMLogPanelView:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, ItemRenderer)
end

function UIGMLogPanelView:RefreshLogCount()
  local warning, error = GMUtils.GetLogCount()
  self.tmp_warning_label:SetText(string.format("%s", warning))
  self.tmp_error_label:SetText(string.format("%s", error))
  if 0 < warning or 0 < error then
    self.btnRefresh.gameObject:SetActive(true)
  end
end

function UIGMLogPanelView:GetLogList(warning, error)
  local list = {}
  local queue = GMUtils.GetDebugLogQueue()
  if not queue then
    return list
  end
  local count = queue.Count
  local enumerator = queue:GetEnumerator()
  while enumerator:MoveNext() do
    local current = enumerator.Current
    local logType = current.logType
    if (logType ~= 2 or warning) and (logType ~= 0 or error) then
      local _ = {
        condition = current.condition,
        truncatedCondition = current.truncatedCondition,
        stacktrace = current.stacktrace,
        time = current.time,
        logType = logType
      }
      table.insert(list, 1, _)
    end
  end
  return list
end

function UIGMLogPanelView:ClearLog()
  GMUtils.ClearDebugLog()
  self:CloseSelf()
end

function UIGMLogPanelView:ClearScroll()
  if self.ScrollView then
    self.ScrollView:ClearCells()
    self.ScrollView:RemoveComponents(ItemRenderer)
  end
  self.showDatalist = {}
end

function UIGMLogPanelView:RefreshLogList()
  self:ClearScroll()
  self.showDatalist = self:GetLogList(self.showWarning, self.showError)
  if #self.showDatalist > 0 then
    self.ScrollView:SetTotalCount(#self.showDatalist)
    self.ScrollView:RefillCells()
    self.btnRefresh.gameObject:SetActive(false)
  end
end

function UIGMLogPanelView:CloseSelf()
  self.ctrl:CloseSelf()
end

function UIGMLogPanelView:ShowSingleLog(data)
  if not self.goSingleLog then
    return
  end
  self.currentSelectData = data
  self.goSingleLog:SetActive(true)
  local icon = "Assets/Main/Sprites/UI/LWUITacticalWeaponChip/FX_wurenjixingpian_jinggao.png"
  if data.logType ~= 2 then
    icon = "Assets/Main/Sprites/UI/LWUITacticalWeaponChip/FX_wurenjixingpian_jianhao.png"
  end
  self.imgTypeIcon:LoadSpriteAuto(icon)
  self.tmpSingleLogTime:SetText(UITimeManager:GetInstance():TimeStampToTimeForLocal(data.time))
  self.tmpSingleLogDetail:SetText(string.format([[
%s
%s]], data.condition, data.stacktrace))
end

function UIGMLogPanelView:HideSingleLog()
  if not self.goSingleLog then
    return
  end
  self.goSingleLog:SetActive(false)
  self.currentSelectData = nil
end

function UIGMLogPanelView:CopyStacktrace()
  if self.currentSelectData == nil then
    return
  end
  local txt = string.format([[
%s
%s]], self.currentSelectData.condition, self.currentSelectData.stacktrace)
  CommonUtil.CopyTextToClipboard(txt)
  UIUtil.ShowTipsId(128031)
end

function UIGMLogPanelView:ClearCustomBtns()
  if self.customBtns then
    for k, v in ipairs(self.customBtns) do
      local go = v.go
      if IsNotNull(go) then
        GameObject.Destroy(v.gameObject)
      end
    end
    self.customBtns = {}
  end
end

function UIGMLogPanelView:OnClickedWarning()
  self.showWarning = not self.showWarning
  self:RefreshToggleState()
  self:RefreshLogList()
end

function UIGMLogPanelView:OnClickedError()
  self.showError = not self.showError
  self:RefreshToggleState()
  self:RefreshLogList()
end

function UIGMLogPanelView:RefreshToggleState()
  self.warning_select:SetActive(self.showWarning)
  self.error_select:SetActive(self.showError)
  local warningLog = self.showWarning and 1 or 0
  local errorLog = self.showError and 2 or 0
  local lv = warningLog | errorLog
  GMUtils.SetInt(GMConst.DebugLocalLogLevel, lv)
end

function UIGMLogPanelView:OnClickedSetting()
  GMUtils.Open()
end

return UIGMLogPanelView
