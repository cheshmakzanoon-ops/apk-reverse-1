local ActivityDecorationGachaWishView = BaseClass("ActivityDecorationGachaWishView", UIBaseView)
local ActivityDecorationGachaWishItemComponent = require("UI/UIActivityCenterTable/Component/ActivityDecorationGacha/Wish/Component/ActivityDecorationGachaWishItemComponent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
ActivityDecorationGachaWishView.SortType = {Default = 1, GainFirst = 2}

function ActivityDecorationGachaWishView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function ActivityDecorationGachaWishView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActivityDecorationGachaWishView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self:AddComponent(UIText, "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText")
  self.textTitle:SetText(Localization:GetString("decoration_recruit_desc41"))
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/Common_bg_orange/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTopDes = self:AddComponent(UIText, "Content/TopContent/TopDesText")
  self.textTopDes:SetText(Localization:GetString("decoration_recruit_desc38"))
  self.btnSelect = self:AddComponent(UIButton, "Content/TopContent/SelectBtn")
  self.btnSelect:SetOnClick(function()
    self:OnBtnSelectClick()
  end)
  self.compCurSelectItem = self:AddComponent(UICommonResItem, "Content/TopContent/CurSelectItem")
  self.compCheckBtn = self:AddComponent(UIBaseContainer, "Content/TopContent/CheckBtn")
  self.textCurSelectLevel = self:AddComponent(UIText, "Content/TopContent/CurSelectLevelText")
  self.textSelect = self:AddComponent(UIText, "Content/TopContent/SelectText")
  self.textSelect:SetText(Localization:GetString("decoration_recruit_desc39"))
  self.textMidTitle = self:AddComponent(UIText, "Content/MidContent/MidTitleText")
  self.textMidTitle:SetText(Localization:GetString("decoration_recruit_desc37"))
  self.textMidSort = self:AddComponent(UIText, "Content/MidContent/MidSortText")
  self.btnMidSort = self:AddComponent(UIButton, "Content/MidContent/MidSortBtn")
  self.btnMidSort:SetOnClick(function()
    self:OnBtnMidSortClick()
  end)
  self.compUIDecorationGachaWishItem = self:AddComponent(ActivityDecorationGachaWishItemComponent, "Content/MidContent/Scroll/UIDecorationGachaWishItem")
  self.compUIDecorationGachaWishItem:SetActive(false)
  self.compUIDecorationGachaWishItem.gameObject:GameObjectCreatePool()
  self.compContent = self:AddComponent(UIBaseContainer, "Content/MidContent/Scroll/Viewport/Content")
  self.btnComfirm = self:AddComponent(UIButton, "Content/ComfirmBtn")
  self.btnComfirm:SetOnClick(function()
    self:OnBtnComfirmClick()
  end)
  self.textBtn = self:AddComponent(UIText, "Content/ComfirmBtn/Btn/BtnText")
  self.textBtn:SetText(Localization:GetString("decoration_recruit_desc42"))
  self.textConfirmDes = self:AddComponent(UIText, "Content/ConfirmDesText")
  self.compHighlightImage = self:AddComponent(UIBaseContainer, "Content/MidContent/Scroll/HighlightImg")
end

function ActivityDecorationGachaWishView:ComponentDestroy()
  self:ClearAllItem()
  self.btnPanel = nil
  self.textTitle = nil
  self.btnClose = nil
  self.textTopDes = nil
  self.btnSelect = nil
  self.compCurSelectItem = nil
  self.textSelect = nil
  self.textMidTitle = nil
  self.textMidSort = nil
  self.btnMidSort = nil
  self.compContent = nil
  self.btnComfirm = nil
  self.textBtn = nil
  self.compUIDecorationGachaWishItem = nil
  self.textCurSelectLevel = nil
  self.compCheckBtn = nil
  self.textConfirmDes = nil
  self.compHighlightImage = nil
end

function ActivityDecorationGachaWishView:DataDefine()
  self.itemList = nil
  self.sortType = self.SortType.GainFirst
  self.ctrl:ClearCurSelectWishData()
end

function ActivityDecorationGachaWishView:DataDestroy()
  self.itemList = nil
  if self.delayHideHighlightTimer then
    self.delayHideHighlightTimer:Stop()
    self.delayHideHighlightTimer = nil
  end
end

function ActivityDecorationGachaWishView:OnAddListener()
  base.OnAddListener(self)
end

function ActivityDecorationGachaWishView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ActivityDecorationGachaWishView:OnOpen()
  self.param = self:GetUserData()
  if self.param == nil or self.param.activityId == nil then
    return
  end
  self.activityId = self.param.activityId
  self.compHighlightImage:SetActive(false)
  self:UpdateCurSelect()
  self:UpdateContent(true)
  self:UpdateSortBtn()
  local activityData = DataCenter.ActivityDecorationGachaManager:GetActivityData(self.activityId)
  if activityData ~= nil then
    self.textConfirmDes:SetLocalText("decoration_recruit_desc49", tostring(activityData:GetPity()))
  end
  PostEventLog.Track(PostEventLog.Defines.ActivityDecorationGachaOpenWish, {
    activityId = tostring(self.activityId)
  })
end

function ActivityDecorationGachaWishView:UpdateCurSelect()
  if self.activityId == nil or self.ctrl == nil then
    return
  end
  local activityData = DataCenter.ActivityDecorationGachaManager:GetActivityData(self.activityId)
  if activityData == nil then
    return
  end
  local curSelectWishData = self.ctrl:GetCurSelectWishData(self.activityId)
  local hasSelected = curSelectWishData ~= nil
  self.btnSelect:SetActive(not hasSelected)
  self.compCurSelectItem:SetActive(hasSelected)
  self.textCurSelectLevel:SetActive(hasSelected)
  self.compCheckBtn:SetActive(hasSelected)
  if hasSelected then
    self.compCurSelectItem:ReInit(curSelectWishData)
    local itemData = DataCenter.ActivityDecorationGachaManager:GetItemDataByItemId(self.activityId, curSelectWishData.itemId)
    if itemData ~= nil and itemData.decorationBuildingId > 0 then
      local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(itemData.decorationBuildingId)
      if buildTemplate ~= nil then
        self.textCurSelectLevel:SetText("Lv." .. tostring(buildTemplate.level))
      end
    end
  end
end

function ActivityDecorationGachaWishView:ClearAllItem()
  self.compContent:RemoveComponents(ActivityDecorationGachaWishItemComponent)
  self.compUIDecorationGachaWishItem.gameObject:GameObjectRecycleAll()
  self.itemList = nil
end

function ActivityDecorationGachaWishView:UpdateContent(forceClear)
  if self.activityId == nil then
    return
  end
  local activityData = DataCenter.ActivityDecorationGachaManager:GetActivityData(self.activityId)
  if activityData == nil then
    return
  end
  if forceClear then
    local allWishData = activityData:GetAllWishDataInOrder()
    table.sort(allWishData, function(a, b)
      return self:WishItemComparer(a, b)
    end)
    self:ClearAllItem()
    self.itemList = {}
    for i, v in pairs(allWishData) do
      local item = self.compUIDecorationGachaWishItem.gameObject:GameObjectSpawn(self.compContent.transform)
      item.name = tostring(i)
      local obj = self.compContent:AddComponent(ActivityDecorationGachaWishItemComponent, item.name)
      obj:SetActive(true)
      obj:ReInit(v, self.activityId)
      self.itemList[i] = obj
    end
  elseif self.itemList ~= nil then
    for i, v in pairs(self.itemList) do
      v:Refresh()
    end
  end
end

function ActivityDecorationGachaWishView:WishItemComparer(a, b)
  if self.activityId == nil then
    return false
  end
  local activityData = DataCenter.ActivityDecorationGachaManager:GetActivityData(self.activityId)
  if activityData == nil then
    return false
  end
  local curSelectWishData = activityData:GetCurSelectWishData()
  local isSelectA = curSelectWishData ~= nil and curSelectWishData.itemId == a.itemId and curSelectWishData.count == a.count
  local isSelectB = curSelectWishData ~= nil and curSelectWishData.itemId == b.itemId and curSelectWishData.count == b.count
  local templateA = DataCenter.ActivityDecorationGachaManager:GetItemDataByItemId(self.activityId, a.itemId)
  local templateB = DataCenter.ActivityDecorationGachaManager:GetItemDataByItemId(self.activityId, b.itemId)
  if templateA == nil or templateA.decorationBuildingTemplate == nil or templateB == nil or templateB.decorationBuildingTemplate == nil then
    return false
  end
  if self.sortType == self.SortType.Default then
    if isSelectA ~= isSelectB then
      return isSelectA and true or false
    end
    local qualityA = templateA:GetDecorationQuality()
    local qualityB = templateB:GetDecorationQuality()
    if qualityA ~= qualityB then
      return qualityA > qualityB
    end
    return templateA.itemId < templateB.itemId
  else
    local hasA = DataCenter.BuildManager:HasBuilding(templateA.decorationBuildingBaseId, true)
    local hasB = DataCenter.BuildManager:HasBuilding(templateB.decorationBuildingBaseId, true)
    if hasA ~= hasB then
      if hasA then
        return false
      else
        return true
      end
    end
    if a.index ~= b.index then
      return a.index < b.index
    end
    if hasA and hasB then
      local buildDataA = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(templateA.decorationBuildingBaseId, true)
      local buildDataB = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(templateB.decorationBuildingBaseId, true)
      local hasCountA, needCountA = DataCenter.BuildManager:IsCanUpgradeDecoration(buildDataA.itemId, buildDataA.level, true)
      local hasCountB, needCountB = DataCenter.BuildManager:IsCanUpgradeDecoration(buildDataB.itemId, buildDataB.level, true)
      if needCountA ~= 0 and needCountB ~= 0 then
        local progressA = hasCountA / needCountA
        local progressB = hasCountB / needCountB
        if progressA ~= progressB then
          return progressA > progressB
        end
      end
      local qualityA = templateA:GetDecorationQuality()
      local qualityB = templateB:GetDecorationQuality()
      if qualityA ~= qualityA then
        return qualityA > qualityB
      end
    end
    return templateA.itemId < templateB.itemId
  end
end

function ActivityDecorationGachaWishView:SelectWishItem(wishData)
  if wishData == nil or self.ctrl == nil then
    return
  end
  local needRefresh = self.ctrl:SetCurSelectWishData(wishData)
  if needRefresh then
    self:UpdateContent(false)
    self:UpdateCurSelect()
  end
end

function ActivityDecorationGachaWishView:UpdateSortBtn()
  if self.sortType == self.SortType.Default then
    self.textMidSort:SetLocalText("decoration_recruit_desc36")
  else
    self.textMidSort:SetLocalText("decoration_recruit_desc35")
  end
end

function ActivityDecorationGachaWishView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function ActivityDecorationGachaWishView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function ActivityDecorationGachaWishView:OnBtnSelectClick()
  self.compHighlightImage:SetActive(true)
  if self.delayHideHighlightTimer then
    self.delayHideHighlightTimer:Stop()
    self.delayHideHighlightTimer = nil
  end
  self.delayHideHighlightTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.compHighlightImage then
      self.compHighlightImage:SetActive(false)
    end
  end, 2)
end

function ActivityDecorationGachaWishView:OnBtnMidSortClick()
end

function ActivityDecorationGachaWishView:OnConfirmSelect(showSecondConfirm)
  if self.ctrl == nil then
    return
  end
  local curWishData = self.ctrl:GetRealCurSelectWishData()
  if curWishData == nil then
    return
  end
  if self.activityId == nil then
    return
  end
  local activityData = DataCenter.ActivityDecorationGachaManager:GetActivityData(self.activityId)
  if activityData == nil then
    return
  end
  local realCurSelect = activityData:GetCurSelectWishData()
  local isDifferent = realCurSelect == nil or curWishData.itemId ~= realCurSelect.itemId or curWishData.count ~= realCurSelect.count
  if isDifferent then
    if not showSecondConfirm then
      DataCenter.ActivityDecorationGachaManager:SendSelectWishMessage(self.activityId, curWishData)
      self.ctrl:CloseSelf()
    else
      local itemDataTemplate = DataCenter.ActivityDecorationGachaManager:GetItemDataByItemId(self.activityId, curWishData.itemId)
      if itemDataTemplate ~= nil and itemDataTemplate.decorationBuildingTemplate ~= nil then
        if itemDataTemplate:GetDecorationQuality() < 5 then
          UIUtil.ShowMessage(Localization:GetString("decoration_recruit_desc13"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
            self:OnConfirmSelect(false)
          end)
          return
        end
        if itemDataTemplate:IsDecorationBuildMaxOrUpgradeItemMax() then
          UIUtil.ShowMessage(Localization:GetString("decoration_recruit_desc21"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
            self:OnConfirmSelect(false)
          end)
          return
        end
        self:OnConfirmSelect(false)
      end
    end
  else
    self.ctrl:CloseSelf()
  end
end

function ActivityDecorationGachaWishView:OnBtnComfirmClick()
  self:OnConfirmSelect(true)
end

return ActivityDecorationGachaWishView
