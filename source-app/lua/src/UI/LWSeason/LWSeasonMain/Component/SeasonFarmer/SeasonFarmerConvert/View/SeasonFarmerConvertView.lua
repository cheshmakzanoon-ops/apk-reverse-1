local SeasonFarmerConvertView = BaseClass("SeasonFarmerConvertView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ConvertItem = require("UI.LWSeason.LWSeasonMain.Component.SeasonFarmer.SeasonFarmerConvert.Component.SeasonFarmerConvertItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local scroll_view_path = "PopUpTitle/ScrollView"
local arrow_path = "PopUpTitle/Arrow"
local content_path = "PopUpTitle/ScrollView/Content"
local item_path = "PopUpTitle/ScrollView/Content/SeasonFarmerConvertItem"
local btn_path = "PopUpTitle/Btn"
local btn_time_text_path = "PopUpTitle/Btn/TimeText"
local limit_text_path = "PopUpTitle/LimitText"

function SeasonFarmerConvertView:OnCreate()
  base.OnCreate(self)
  self.dataList = {}
  self:ComponentDefine()
  self:RefreshList()
  SFSNetwork.SendMessage(MsgDefines.SeasonBuilderCheckCondition)
end

function SeasonFarmerConvertView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonFarmerConvertView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonFarmerStateChange, self.SeasonFarmerStateChange)
  self:AddUIListener(EventId.SeasonBuilderCheckCondition, self.SeasonBuilderCheckCondition)
end

function SeasonFarmerConvertView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.SeasonFarmerStateChange, self.SeasonFarmerStateChange)
  self:RemoveUIListener(EventId.SeasonBuilderCheckCondition, self.SeasonBuilderCheckCondition)
end

function SeasonFarmerConvertView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.btn_time_text = self:AddComponent(UIText, btn_time_text_path)
  self.limit_text = self:AddComponent(UIText, limit_text_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.ScrollView = self:AddComponent(UIScrollRect, scroll_view_path)
  self.ScrollView:AddValueChangeListener(function()
    self:ScrollViewChange()
  end)
  self.arrow = self:AddComponent(UIButton, arrow_path)
  self.arrow:SetOnClick(BindCallback(self, self.OnClickArrow))
  self.theItem = self.transform:Find(item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(BindCallback(self, self.OnClickBtn))
  self.dialog_title_text:SetLocalText("season_builders_alliance_UI_22")
  self:InitBtn()
end

function SeasonFarmerConvertView:ComponentDestroy()
  self.btn_back = nil
  self.btn_text = nil
end

function SeasonFarmerConvertView:Update1000MS()
  if self.clickTime then
    self.clickTime = self.clickTime - 1
    if self.clickTime <= 0 then
      self.clickTime = nil
    end
    self.btnDirty = false
    self:RefreshBtnState()
  elseif self.btnDirty then
    self.btnDirty = false
    self:RefreshBtnState()
  end
end

function SeasonFarmerConvertView:RefreshList()
  local mainCfg = DataCenter.SeasonFarmerTemplateManager:GetMainCfg()
  local maxCount = mainCfg and mainCfg.suggested_quantity or 0
  local curCount = self.netData and self.netData.totalNum or 0
  self.limit_text:SetText(Localization:GetString("season_builders_alliance_UI_42", maxCount, curCount))
  self:UpdateData()
  local dataCount = #self.dataList
  self:ClearItemCell()
  local goItem, theItem
  for i = 1, dataCount do
    goItem = self.theItem:GameObjectSpawn(self.content.transform)
    goItem.name = "item_" .. i
    goItem:SetActive(true)
    theItem = self.content:AddComponent(ConvertItem, goItem.name)
    theItem:ReInit(i, self.dataList[i], dataCount, function(data)
      self.btnDirty = true
    end)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.transform)
end

function SeasonFarmerConvertView:ClearItemCell()
  self.ScrollView:SetVerticalNormalizedPosition(1)
  self.content:RemoveComponents(ConvertItem)
  self.theItem:GameObjectRecycleAll()
end

function SeasonFarmerConvertView:SeasonFarmerStateChange()
  self.ctrl:CloseSelf()
end

function SeasonFarmerConvertView:SeasonBuilderCheckCondition(netData)
  self.netData = netData
  self:RefreshList()
end

function SeasonFarmerConvertView:UpdateData()
  if table.IsNullOrEmpty(self.dataList) then
    local conf = DataCenter.SeasonFarmerTemplateManager:GetMainCfg()
    local dataList = {}
    self.dataList = dataList
    if conf and conf.warning_dec then
      local strList = string.split(conf.warning_dec, "|")
      for i = 1, #strList do
        local str = strList[i]
        local strList2 = string.split(str, ";")
        local data = {}
        dataList[i] = data
        data.index = i
        data.type = 0
        data.result = false
        data.currentNum = 0
        data.configNum = 0
        data.configNum2 = 0
        data.desc = strList2[1]
        data.param = strList2[2]
        data.serverStrongholdArr = nil
      end
    end
  end
  if not self.netData or not self.netData.conditionArr then
    return
  end
  for k, v in pairs(self.netData.conditionArr) do
    local index = v.index + 1
    local data = self.dataList[index]
    if data then
      data.index = index
      data.type = v.type
      data.currentNum = v.currentNum
      data.configNum = v.configNum
      data.configNum2 = v.configNum2
      data.result = v.result
      data.serverStrongholdArr = v.serverStrongholdArr
    end
  end
end

function SeasonFarmerConvertView:InitBtn()
  self.clickTime = 10
  self:RefreshBtnState()
  local isInValidTime, endLimitDay = self:IsInValidTime()
  if not isInValidTime then
    UIUtil.ShowTips(Localization:GetString("season_builders_alliance_tips_1", endLimitDay))
    return
  end
end

function SeasonFarmerConvertView:HasAllSelect()
  if table.IsNullOrEmpty(self.dataList) then
    return false
  end
  for k, v in pairs(self.dataList) do
    if not v.result or not v.select then
      return false, v
    end
  end
  return true
end

function SeasonFarmerConvertView:IsInValidTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local seasonStartTime = DataCenter.SeasonDataManager:GetSeasonStartTime()
  local seasonLeftDay = SeasonUtil.GetSeasonLeftDay()
  local conf = DataCenter.SeasonFarmerTemplateManager:GetMainCfg()
  local endLimitDay = conf and conf.end_limit or 0
  if curTime > seasonStartTime and (endLimitDay <= 0 or seasonLeftDay >= endLimitDay) then
    return true, endLimitDay
  end
  return false, endLimitDay
end

function SeasonFarmerConvertView:RefreshBtnState()
  if self.clickTime then
    self.btn:SetInteractable(false)
    CS.UIGray.SetGray(self.btn.transform, true, true)
    self.btn_time_text:SetActive(true)
    self.btn_time_text:SetText(string.format("%ss", self.clickTime))
    return
  end
  self.btn:SetInteractable(true)
  self.btn_time_text:SetActive(false)
  local hasAllSelect = self:HasAllSelect()
  local isGray = not hasAllSelect
  if not isGray and not self:IsInValidTime() then
    isGray = true
  end
  CS.UIGray.SetGray(self.btn.transform, isGray, true)
end

function SeasonFarmerConvertView:OnClickBtn()
  if not DataCenter.AllianceBaseDataManager:IsSelfLeader() then
    UIUtil.ShowTipsId("season_builders_alliance_tips_30")
    return
  end
  local isInValidTime, endLimitDay = self:IsInValidTime()
  if not isInValidTime then
    UIUtil.ShowTips(Localization:GetString("season_builders_alliance_tips_1", endLimitDay))
    return
  end
  if not self:HasAllSelect() then
    UIUtil.ShowTipsId("season_builders_alliance_tips_2")
    return
  end
  UIUtil.ShowSecondMessageByParam({
    tipText = Localization:GetString("season_builders_alliance_tips_24"),
    btnNum = 2,
    showToggle = false,
    sureAction = function()
      SFSNetwork.SendMessage(MsgDefines.SeasonConvertToFarmer)
    end
  })
end

function SeasonFarmerConvertView:ScrollViewChange()
  self.arrow:SetActive(self.ScrollView:GetVerticalNormalizedPosition() > 0)
end

function SeasonFarmerConvertView:OnClickArrow()
  self.ScrollView:AnimVerticalNormalizedPos(0, 0.15)
end

return SeasonFarmerConvertView
