local UIBargainShopRulesView = BaseClass("UIBargainShopRulesView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")
local UIBargainShopDayProbItem = require("UI.UIActivityCenterTable.Component.UIBargainShop.UIBargainShopRules.Component.UIBargainShopDayProbItem")
local brief_text_path = "descContent/Common_bg_desc/descScroll/Viewport/descLayout/desc_txt"
local common_activity_pop_up_bg_part_path = "CommonActivityPopUpBgPart"
local prob_scroll_path = "probContent/Common_bg_prob/probScroll"
local prob_scroll_content_path = "probContent/Common_bg_prob/probScroll/Viewport/Content"
UIBargainShopRulesView.TabType = {Prob = 1, Desc = 2}

function UIBargainShopRulesView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.curSelectTab = self.TabType.Prob
  self:UpdateTab()
  self:UpdateContent()
  self.commonActivityPopUpBgPart:InitByActivityId(self.activityId, UIWindowNames.UIBargainShopRules)
  if self.actTemplate and self.actTemplate.name then
    self.commonActivityPopUpBgPart:SetTitle(self.actTemplate.name)
  end
  self:ModifyByConfig()
end

function UIBargainShopRulesView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBargainShopRulesView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self:AddComponent(UIText, "Common_img_title/titleText")
  self.textTitle:SetLocalText("bargain_shop_2026_1_title")
  self.compTabLayout = self:AddComponent(UIBaseContainer, "TabLayout")
  self.compTabList = {}
  for i, v in pairs(self.TabType) do
    local tab = {}
    tab.tabType = v
    local tabPath = "TabLayout/Tab" .. tostring(v)
    tab.objRoot = self:AddComponent(UIBaseContainer, tabPath)
    tab.objSelect = tab.objRoot:AddComponent(UIBaseContainer, "Select")
    tab.objUnSelect = tab.objRoot:AddComponent(UIBaseContainer, "UnSelect")
    tab.btn = tab.objRoot:AddComponent(UIButton, "Btn")
    tab.unselectBg = tab.objRoot:AddComponent(UIImage, "UnSelect")
    tab.selectBg = tab.objRoot:AddComponent(UIImage, "Select")
    local index = v
    tab.btn:SetOnClick(function()
      self:OnSelectTab(index)
    end)
    self.compTabList[index] = tab
  end
  self.compBriefContent = self:AddComponent(UIBaseContainer, "descContent")
  self.compBriefTextContent = self:AddComponent(UIBaseContainer, "descContent/Common_bg_desc/descScroll/Viewport/descLayout")
  self.brief_text = self:AddComponent(UITextMeshProUGUIEx, brief_text_path)
  self.compProbContent = self:AddComponent(UIBaseContainer, "probContent")
  self.probScroll = self:AddComponent(UILoopListView2, prob_scroll_path)
  self.probScrollContent = self:AddComponent(UIBaseContainer, prob_scroll_content_path)
  self.probScroll:InitListView(0, function(loopView, index)
    return self:OnGetProbItemByIndex(loopView, index)
  end)
  self.commonActivityPopUpBgPart = self:AddComponent(CommonActivityPopUpBgPart, common_activity_pop_up_bg_part_path)
  self.commonActivityPopUpBgPart:SetCloseCallback(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.bottom_txt = self:AddComponent(UIText, "bottom_txt")
end

function UIBargainShopRulesView:ComponentDestroy()
  self:ClearProbScroll()
  self.btnPanel = nil
  self.textTitle = nil
  self.compTabLayout = nil
  self.compBriefContent = nil
  self.compTabList = nil
  self.compBriefTextContent = nil
  self.compProbContent = nil
  self.probScroll = nil
  self.probScrollContent = nil
  self.commonActivityPopUpBgPart = nil
  self.bottom_txt = nil
end

function UIBargainShopRulesView:DataDefine()
  local data = self:GetUserData() or {}
  self.activityId = data.activityId
  self.actTemplate = data.actTemplate
  self.descText = ""
  if self.actTemplate and not string.IsNullOrEmpty(self.actTemplate.story) then
    self.descText = Localization:GetString(self.actTemplate.story)
  end
  local para7 = self.actTemplate and self.actTemplate.para_7 or nil
  self.probData = self:ParseProbData(para7)
  self.probDayList = nil
end

function UIBargainShopRulesView:DataDestroy()
  self.activityId = nil
  self.actTemplate = nil
  self.descText = nil
  self.probData = nil
  self.probDayList = nil
end

function UIBargainShopRulesView:OnAddListener()
  base.OnAddListener(self)
end

function UIBargainShopRulesView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBargainShopRulesView:UpdateTab()
  if self.compTabList == nil then
    return
  end
  for i, v in pairs(self.compTabList) do
    local isSelect = self.curSelectTab == v.tabType
    v.objSelect:SetActive(isSelect)
    v.objUnSelect:SetActive(not isSelect)
  end
end

function UIBargainShopRulesView:UpdateContent()
  if self.curSelectTab == nil then
    return
  end
  local isDesc = self.curSelectTab == self.TabType.Desc
  self.compBriefContent:SetActive(isDesc)
  self.compProbContent:SetActive(not isDesc)
  if isDesc then
    self.compBriefTextContent:SetAnchoredPositionXY(0, 0)
    self.brief_text:SetText(self.descText or "")
  else
    self:RefreshProbList()
  end
  if self.curSelectTab == self.TabType.Prob then
    self.bottom_txt:SetActive(true)
  else
    self.bottom_txt:SetActive(false)
  end
end

function UIBargainShopRulesView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIBargainShopRulesView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIBargainShopRulesView:OnSelectTab(tabType)
  if tabType == self.curSelectTab then
    return
  end
  self.curSelectTab = tabType
  self:UpdateTab()
  self:UpdateContent()
end

function UIBargainShopRulesView:ModifyByConfig()
  if not self.activityId then
    return
  end
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if not activityInfo or not activityInfo.GetFestivalInterfaceCfgId then
    return
  end
  local cfgId = activityInfo:GetFestivalInterfaceCfgId()
  if not cfgId then
    return
  end
  local lineData = LocalController:instance():getLine(TableName.Festival_Interface_Config, cfgId)
  if lineData == nil then
    return
  end
  self.commonActivityPopUpBgPart:ModifyPanelPacking(lineData, UIWindowNames.UIBargainShopRules, self.activityId)
  if not string.IsNullOrEmpty(lineData.board_page) then
    local pageList = string.split(lineData.board_page, "|")
    for _, v in pairs(self.compTabList) do
      v.selectBg:LoadSpriteAsync(string.format(LoadPath.ActivityThemPath, pageList[1]))
      v.unselectBg:LoadSpriteAsync(string.format(LoadPath.ActivityThemPath, pageList[2]))
    end
  end
end

function UIBargainShopRulesView:ParseProbData(para7)
  if string.IsNullOrEmpty(para7) then
    return {}
  end
  local str = tostring(para7)
  str = string.gsub(str, "\r\n", "\n")
  str = string.gsub(str, "\239\188\155", ";")
  local segments = self:SplitDaySegments(str)
  if not segments or #segments == 0 then
    return {}
  end
  local days = {}
  for dayIndex, seg in ipairs(segments) do
    local day = {
      title = "",
      items = {},
      columns = {},
      colIndex = {}
    }
    if not string.IsNullOrEmpty(seg.dayTitleKey) then
      day.title = Localization:GetString(seg.dayTitleKey)
    end
    for _, itemStr in ipairs(seg.items) do
      local item = self:ParseOneItemProb(itemStr)
      if item then
        if string.IsNullOrEmpty(day.title) and not string.IsNullOrEmpty(item.dayTitleKey) then
          day.title = Localization:GetString(item.dayTitleKey)
        end
        table.insert(day.items, item)
        for _, opt in ipairs(item.options) do
          local key = tostring(opt.price)
          if not day.colIndex[key] then
            day.colIndex[key] = true
            table.insert(day.columns, opt.price)
          end
        end
      end
    end
    if string.IsNullOrEmpty(day.title) then
      day.title = string.format("%d Day", dayIndex)
    end
    table.sort(day.columns, function(a, b)
      local na = tonumber(a) or 0
      local nb = tonumber(b) or 0
      return na < nb
    end)
    table.insert(days, day)
  end
  return days
end

function UIBargainShopRulesView:SplitDaySegments(str)
  local segments = {}
  local rawParts = {}
  for _, part in ipairs(string.split(str, ";")) do
    if not string.IsNullOrEmpty(part) then
      table.insert(rawParts, part)
    end
  end
  for _, part in ipairs(rawParts) do
    part = string.gsub(part, "^%s+", "")
    part = string.gsub(part, "%s+$", "")
    if not string.IsNullOrEmpty(part) then
      local payload = part
      local eqPos = string.find(part, "=")
      if eqPos then
        payload = string.sub(part, eqPos + 1)
      end
      local parts = {}
      if not string.IsNullOrEmpty(payload) then
        parts = string.split(payload, "|")
      end
      local dayTitleKey
      local items = parts
      if parts[1] and string.find(parts[1], ",") == nil then
        dayTitleKey = parts[1]
        items = {}
        for i = 2, #parts do
          table.insert(items, parts[i])
        end
      end
      table.insert(segments, {dayTitleKey = dayTitleKey, items = items})
    end
  end
  return segments
end

function UIBargainShopRulesView:ParseOneItemProb(itemStr)
  if string.IsNullOrEmpty(itemStr) then
    return nil
  end
  local fields = string.split(itemStr, ",")
  if not fields or #fields < 5 then
    return nil
  end
  local startIndex = 1
  local dayTitleKey
  local itemId = tonumber(fields[1])
  if itemId == nil then
    dayTitleKey = fields[1]
    startIndex = 2
    itemId = tonumber(fields[2])
  end
  if itemId == nil then
    return nil
  end
  local count = tonumber(fields[startIndex + 1]) or 0
  local originPrice = fields[startIndex + 2]
  local itemName = DataCenter.RewardManager:GetNameByType(RewardType.GOODS, itemId) or tostring(itemId)
  local options = {}
  local i = startIndex + 3
  while i <= #fields do
    local discountPrice = fields[i]
    local prob = fields[i + 1]
    if string.IsNullOrEmpty(discountPrice) or string.IsNullOrEmpty(prob) then
      break
    end
    table.insert(options, {price = discountPrice, prob = prob})
    i = i + 2
  end
  return {
    dayTitleKey = dayTitleKey,
    itemId = itemId,
    name = itemName,
    count = count,
    originPrice = originPrice,
    options = options
  }
end

function UIBargainShopRulesView:ClearProbScroll()
  if self.probScrollContent then
    self.probScrollContent:RemoveComponents(UIBargainShopDayProbItem)
  end
  if self.probScroll then
    self.probScroll:ClearAllItems()
  end
  self.probDayList = nil
end

function UIBargainShopRulesView:GetCurrencyIconPath()
  local actData = DataCenter.ActBargainShopData and DataCenter.ActBargainShopData:GetInfoByActId(self.activityId)
  if not (actData and actData.productList) or #actData.productList == 0 then
    return nil
  end
  local template = actData.productList[1] and actData.productList[1].template or nil
  if template and template.GetCurrencyIconPath then
    return template:GetCurrencyIconPath()
  end
  return nil
end

function UIBargainShopRulesView:BuildProbDayList()
  local days = {}
  if not self.probData or #self.probData == 0 then
    return days
  end
  
  local function formatProb(probVal)
    local n = tonumber(probVal)
    if n == nil then
      return ""
    end
    return tostring(n * 100) .. "%"
  end
  
  local iconPath = self:GetCurrencyIconPath()
  for _, day in ipairs(self.probData) do
    local dayData = {
      dayTitle = day.title,
      priceIconPath = iconPath,
      items = {}
    }
    for _, item in ipairs(day.items or {}) do
      local caseList = {}
      for _, opt in ipairs(item.options or {}) do
        table.insert(caseList, {
          discount = opt.price,
          prob = formatProb(opt.prob),
          iconPath = iconPath
        })
      end
      table.insert(dayData.items, {
        itemId = item.itemId,
        count = item.count,
        originPrice = item.originPrice,
        caseList = caseList
      })
    end
    table.insert(days, dayData)
  end
  return days
end

function UIBargainShopRulesView:RefreshProbList()
  self.probDayList = self:BuildProbDayList()
  local count = self.probDayList and #self.probDayList or 0
  self.probScroll:SetListItemCount(count, false, false)
  self.probScroll:RefreshAllShownItem()
  self.probScroll:ForceUpdate()
end

function UIBargainShopRulesView:OnGetProbItemByIndex(loopScroll, index)
  index = index + 1
  if not self.probDayList or index < 1 or index > #self.probDayList then
    return nil
  end
  local itemData = self.probDayList[index]
  local item = loopScroll:NewListViewItem("DayProbItem")
  local script = self.probScrollContent:GetComponent(item.gameObject.name, UIBargainShopDayProbItem)
  if script == nil then
    NameCount = NameCount + 1
    local name = tostring(NameCount)
    item.gameObject.name = name
    script = self.probScrollContent:AddComponent(UIBargainShopDayProbItem, name)
  end
  script:SetActive(true)
  script:SetData(itemData)
  TimerManager:GetInstance():DelayFrameInvoke(function()
    if self.probScroll then
      self.probScroll:OnItemSizeChanged(index - 1)
    end
  end, 1)
  return item
end

return UIBargainShopRulesView
