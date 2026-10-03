local UILWInfiniteGiftView = BaseClass("UILWInfiniteGiftView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWInfiniteGiftItem = require("UI.UILWInfiniteGift.Component.UILWInfiniteGiftItem")
local giftItem_path = "Root/Content/Packs/PackItem%d"
local titleText_path = "Root/Content/TitleTxt"
local time_path = "Root/Content/Time"
local timeText_path = "Root/Content/Time/TimeText"
local descText_path = "Root/Content/DescText"
local infoBtn_path = "Root/Content/InfoBtn"
local tipContent_path = "Tips"
local tipContentText_path = "Tips/TipBg/TipText"
local tipBg_path = "Tips/TipBg"
local emptyText_path = "Root/Content/EmptyText"
local packsContent_path = "Root/Content/Packs"
local banner_path = "Root/Content/UICommonPopBg/TitleBg"
local discount_path = "Root/Content/Discount"
local discount_txt_path = "Root/Content/Discount/DiscountText"

local function ShowTip(self)
  self.tipContent:SetActive(true)
end

local function HideTip(self)
  self.tipContent:SetActive(false)
end

local function ComponentDefine(self)
  self.giftItems = {}
  for i = 1, 3 do
    self.giftItems[i] = self:AddComponent(UILWInfiniteGiftItem, string.format(giftItem_path, i))
  end
  self.closePanelBtn = self:AddComponent(UIButton, "Panel")
  self.closePanelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn = self:AddComponent(UIButton, "Root/Content/UICommonPopBg/CloseBtn")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.actTitleText = self:AddComponent(UIText, titleText_path)
  self.time = self:AddComponent(UIBaseContainer, time_path)
  self.timeText = self:AddComponent(UIText, timeText_path)
  self.descText = self:AddComponent(UIText, descText_path)
  self.time:SetActive(true)
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.infoBtn:SetOnClick(function()
    ShowTip(self)
  end)
  self.tipContent = self:AddComponent(UIBaseContainer, tipContent_path)
  self.tipContent:SetActive(false)
  self.tipContentText = self:AddComponent(UIText, tipContentText_path)
  self.tipContentText:SetLocalText(2010803)
  self.tipBg = self:AddComponent(UIButton, tipBg_path)
  self.tipBg:SetOnClick(function()
    HideTip(self)
  end)
  self.emptyText = self:AddComponent(UIText, emptyText_path)
  self.packsContent = self:AddComponent(UIBaseContainer, packsContent_path)
  self.animator = self:AddComponent(UISimpleAnimation, "")
  self.banner = self:AddComponent(UIRawImage, banner_path)
  self.discount = self:AddComponent(UIBaseContainer, discount_path)
  self.discount_txt = self:AddComponent(UIText, discount_txt_path)
  self.actTitleTextOutLine = self:AddComponent(UIOutline, titleText_path)
  self.timeTextOutLine = self:AddComponent(UIOutline, timeText_path)
  self.descTextOutLine = self:AddComponent(UIOutline, descText_path)
  self.actTitleTextShadow = self:AddComponent(UIShadow, titleText_path)
  self.timeTextShadow = self:AddComponent(UIShadow, timeText_path)
end

local function ComponentDestroy(self)
  self.giftItems = nil
  self.closePanelBtn = nil
  self.closeBtn = nil
  self.actTitleText = nil
  self.time = nil
  self.timeText = nil
  self.descText = nil
  self.time = nil
  self.infoBtn = nil
  self.tipContent = nil
  self.tipContentText = nil
  self.tipBg = nil
  self.emptyText = nil
  self.packsContent = nil
  self.animator = nil
end

local function DataDefine(self)
  self.timer_action = BindCallback(self, self.RefreshTime)
  self.isHaveSetViewColor = false
end

local function DataDestroy(self)
  self.timer_action = nil
  self.actId = nil
  self.baseActInfo = nil
  self.actDetailInfo = nil
  self.viewDatas = nil
  self.endTime = nil
  self.timer = nil
  self.emptyText = nil
  self.packsContent = nil
  self.isHaveSetViewColor = nil
end

local function OnCreate(self)
  base.OnCreate(self)
  DataDefine(self)
  ComponentDefine(self)
  local openType
  self.actId, openType = self:GetUserData()
  if not self.actId then
    self.ctrl:CloseSelf()
    return
  end
  self.baseActInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.actId)
  self.actDetailInfo = DataCenter.ActInfiniteGiftDataManager:GetActDetailInfo(self.actId)
  if not self.baseActInfo or not self.actDetailInfo then
    self.ctrl:CloseSelf()
    return
  end
  if not self.baseActInfo:IsValid() then
    self.ctrl:CloseSelf()
    return
  end
  if openType then
    PostEventLog.Track(PostEventLog.Defines.OpenInfiniteGiftWindow, {openType = openType})
  end
  self.endTime = self.baseActInfo.endTime
  self:AddTimer()
  self:SetViewColor()
  self:Refresh()
  if self.animator then
    self.animator:SampleAnimationAtTime("XianShi", 0)
    self.animator:Play("XianShi")
  end
end

local function OnDestroy(self)
  self:RemoveTimer()
  DataDestroy(self)
  ComponentDestroy(self)
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnDataUpdate(self)
  self:RefreshItems()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.InfiniteGiftUpdate, self.OnDataUpdate)
  self:AddUIListener(EventId.UpdateGiftPackData, self.OnDataUpdate)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.InfiniteGiftUpdate, self.OnDataUpdate)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.OnDataUpdate)
end

local function RefreshData(self)
  self.viewDatas = {}
  if not self.baseActInfo or not self.actDetailInfo then
    return
  end
  local curGid = self.actDetailInfo.gid
  local nGid = self.actDetailInfo.ngid
  if not (curGid and nGid) or curGid <= 0 then
    return
  end
  local curGroupTemplate = DataCenter.ActInfiniteGiftTemplateDataManager:GetTemplate(curGid)
  local firstItemState = self.actDetailInfo.firstState
  if firstItemState == 0 then
    local itemData = {}
    itemData.type = InfiniteGiftType.GiftPackage
    local giftPackId = curGroupTemplate.exchangeId
    itemData.curGid = curGid
    itemData.gid = curGid
    itemData.rewards = {}
    local giftPackData = GiftPackageData.get(tostring(giftPackId))
    if giftPackData then
      itemData.rewards = giftPackData:getItems()
    end
    itemData.value = curGroupTemplate:GetValueByIndex(1)
    itemData.unlock = true
    itemData.id = giftPackId
    itemData.canRefresh = curGroupTemplate.can_refresh == 1
    itemData.pic = curGroupTemplate:GetPicTypeByIndex(1)
    table.insert(self.viewDatas, itemData)
  end
  if 0 <= self.actDetailInfo.secondState and self.actDetailInfo.secondState < 2 then
    local itemData = {}
    itemData.type = InfiniteGiftType.Reawrd
    itemData.curGid = curGid
    itemData.gid = curGid
    itemData.rewards = self.actDetailInfo.curGroupFirstFreeRewards
    itemData.value = curGroupTemplate:GetValueByIndex(2)
    itemData.unlock = #self.viewDatas == 0
    itemData.index = 1
    itemData.canRefresh = curGroupTemplate.can_refresh == 1
    itemData.pic = curGroupTemplate:GetPicTypeByIndex(2)
    table.insert(self.viewDatas, itemData)
  end
  if 0 <= self.actDetailInfo.thirdState and 2 > self.actDetailInfo.thirdState then
    local itemData = {}
    itemData.type = InfiniteGiftType.Reawrd
    itemData.curGid = curGid
    itemData.gid = curGid
    itemData.rewards = self.actDetailInfo.curGroupSecondFreeRewards
    itemData.value = curGroupTemplate:GetValueByIndex(3)
    itemData.unlock = #self.viewDatas == 0
    itemData.index = 2
    itemData.canRefresh = curGroupTemplate.can_refresh == 1
    itemData.pic = curGroupTemplate:GetPicTypeByIndex(3)
    table.insert(self.viewDatas, itemData)
  end
  if #self.viewDatas < 3 and 0 < nGid then
    local nextGroupTemplate = DataCenter.ActInfiniteGiftTemplateDataManager:GetTemplate(nGid)
    if nextGroupTemplate then
      if 0 < nextGroupTemplate.exchangeId then
        local itemData = {}
        itemData.type = InfiniteGiftType.GiftPackage
        local giftPackId = nextGroupTemplate.exchangeId
        itemData.curGid = curGid
        itemData.gid = nGid
        itemData.rewards = {}
        local giftPackData = GiftPackageData.get(tostring(giftPackId))
        if giftPackData then
          itemData.rewards = giftPackData:getItems()
        end
        itemData.value = nextGroupTemplate:GetValueByIndex(1)
        itemData.unlock = #self.viewDatas == 0
        itemData.id = giftPackId
        itemData.pic = nextGroupTemplate:GetPicTypeByIndex(1)
        table.insert(self.viewDatas, itemData)
      end
      if #self.viewDatas >= 3 then
        return
      end
      if 0 < nextGroupTemplate.reward1Id then
        local itemData = {}
        itemData.type = InfiniteGiftType.Reawrd
        itemData.curGid = curGid
        itemData.gid = nGid
        itemData.rewards = self.actDetailInfo.nextGroupFirstFreeRewards
        itemData.value = nextGroupTemplate:GetValueByIndex(2)
        itemData.unlock = #self.viewDatas == 0
        itemData.pic = nextGroupTemplate:GetPicTypeByIndex(2)
        table.insert(self.viewDatas, itemData)
      end
      if #self.viewDatas >= 3 then
        return
      end
      if 0 < nextGroupTemplate.reward2Id then
        local itemData = {}
        itemData.type = InfiniteGiftType.Reawrd
        itemData.curGid = curGid
        itemData.gid = nGid
        itemData.rewards = self.actDetailInfo.nextGroupSecondFreeRewards
        itemData.value = nextGroupTemplate:GetValueByIndex(3)
        itemData.unlock = #self.viewDatas == 0
        itemData.pic = curGroupTemplate:GetPicTypeByIndex(3)
        table.insert(self.viewDatas, itemData)
      end
    end
  end
end

local function AdjustTextByAct(self)
end

local function RefreshBaseInfo(self)
  if not self.baseActInfo or not self.actDetailInfo then
    return
  end
  if not string.IsNullOrEmpty(self.baseActInfo.activity_pic) then
    self.banner:LoadSprite(string.format(LoadPath.ActivityInfiniteGiftBannerPath, self.baseActInfo.activity_pic))
  end
  self.actTitleText:SetLocalText(self.baseActInfo.name)
  self.descText:SetLocalText(self.baseActInfo.story)
  local isShowDiscount = not string.IsNullOrEmpty(self.baseActInfo.para_3)
  self.discount:SetActive(isShowDiscount)
  if isShowDiscount then
    self.discount_txt:SetText(string.format([[
%d%%
OFF]], tonumber(self.baseActInfo.para_3)))
  end
  AdjustTextByAct(self)
end

local function RefreshItems(self)
  if not self.baseActInfo or not self.actDetailInfo then
    return
  end
  self:RefreshData()
  for i = 1, 3 do
    if self.viewDatas[i] then
      self.giftItems[i]:SetData(self.viewDatas[i])
    else
      self.giftItems[i]:SetActive(false)
    end
  end
  if #self.viewDatas == 0 then
    self.emptyText:SetActive(true)
    self.packsContent:SetActive(false)
  else
    self.emptyText:SetActive(false)
    self.packsContent:SetActive(true)
  end
end

local function Refresh(self)
  self:RefreshBaseInfo()
  self:RefreshItems()
end

local function SetViewColor(self)
  if self.isHaveSetViewColor == true then
    return
  end
  self.isHaveSetViewColor = true
  local showTemp = self.baseActInfo:GetShowConfigTemp()
  if showTemp == nil then
    return
  end
  local targetColor = {
    255,
    255,
    255,
    255
  }
  targetColor = {
    255,
    255,
    255,
    255
  }
  if #showTemp.title_color_tab == 4 then
    targetColor = showTemp.title_color_tab
  end
  self.actTitleText:SetColorRGBA255(table.unpack(targetColor))
  targetColor = {
    30,
    3,
    6,
    255
  }
  if #showTemp.title_stroke_color_tab == 4 then
    targetColor = showTemp.title_stroke_color_tab
  end
  self.actTitleTextOutLine:SetColorRGBA255(table.unpack(targetColor))
  targetColor = {
    30,
    3,
    6,
    255
  }
  if #showTemp.title_shadow_color_tab == 4 then
    targetColor = showTemp.title_shadow_color_tab
  end
  self.actTitleTextShadow:SetColorRGBA255(table.unpack(targetColor))
  targetColor = {
    255,
    255,
    255,
    255
  }
  if #showTemp.desc_color_tab == 4 then
    targetColor = showTemp.desc_color_tab
  end
  self.descText:SetColorRGBA255(table.unpack(targetColor))
  targetColor = {
    203,
    80,
    6,
    255
  }
  if #showTemp.desc_stroke_color_tab == 4 then
    targetColor = showTemp.desc_stroke_color_tab
  end
  self.descTextOutLine:SetColorRGBA255(table.unpack(targetColor))
  targetColor = {
    255,
    255,
    255,
    255
  }
  if #showTemp.time_color_tab == 4 then
    targetColor = showTemp.time_color_tab
  end
  self.timeText:SetColorRGBA255(table.unpack(targetColor))
  targetColor = {
    8,
    8,
    8,
    255
  }
  if #showTemp.time_stroke_color_tab == 4 then
    targetColor = showTemp.time_stroke_color_tab
  end
  self.timeTextOutLine:SetColorRGBA255(table.unpack(targetColor))
  targetColor = {
    8,
    8,
    8,
    255
  }
  if #showTemp.time_shadow_color_tab == 4 then
    targetColor = showTemp.time_shadow_color_tab
  end
  self.timeTextShadow:SetColorRGBA255(table.unpack(targetColor))
end

local function AddTimer(self)
  if self.timer then
    return
  end
  self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action)
  self.timer:Start()
end

local function RemoveTimer(self)
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

local function RefreshTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= self.endTime then
    self.ctrl:CloseSelf()
    return
  else
    self.timeText:SetText(UITimeManager:GetInstance():SecondToFmtString((self.endTime - curTime) / 1000))
  end
end

local function ClaimReward(self, data)
  if not data then
    return
  end
  DataCenter.ActInfiniteGiftDataManager:ClaimReward(self.actId, data.gid, data.index)
end

local function RefreshGroup(self, data)
  if not data then
    return
  end
  DataCenter.ActInfiniteGiftDataManager:RefreshActDetailInfo(self.actId, data.gid)
end

local function GetRefreshTime(self)
  if not self.actId then
    return 0
  end
  return DataCenter.ActInfiniteGiftDataManager:GetNextRefreshTime(self.actId)
end

UILWInfiniteGiftView.OnCreate = OnCreate
UILWInfiniteGiftView.OnDestroy = OnDestroy
UILWInfiniteGiftView.OnEnable = OnEnable
UILWInfiniteGiftView.OnDisable = OnDisable
UILWInfiniteGiftView.OnAddListener = OnAddListener
UILWInfiniteGiftView.OnRemoveListener = OnRemoveListener
UILWInfiniteGiftView.Refresh = Refresh
UILWInfiniteGiftView.RefreshData = RefreshData
UILWInfiniteGiftView.RefreshTime = RefreshTime
UILWInfiniteGiftView.AddTimer = AddTimer
UILWInfiniteGiftView.RemoveTimer = RemoveTimer
UILWInfiniteGiftView.OnDataUpdate = OnDataUpdate
UILWInfiniteGiftView.RefreshBaseInfo = RefreshBaseInfo
UILWInfiniteGiftView.RefreshItems = RefreshItems
UILWInfiniteGiftView.ClaimReward = ClaimReward
UILWInfiniteGiftView.RefreshGroup = RefreshGroup
UILWInfiniteGiftView.GetRefreshTime = GetRefreshTime
UILWInfiniteGiftView.SetViewColor = SetViewColor
return UILWInfiniteGiftView
