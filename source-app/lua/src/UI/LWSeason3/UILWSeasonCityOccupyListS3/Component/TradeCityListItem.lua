local base = UIBaseContainer
local TradeCityListItem = BaseClass("TradeCityListItem", base)
local itemBg1_path = "content/itemBg1"
local itemBg2_path = "content/itemBg2"
local tradeStation_path = "content/tradeStation"
local shopItemInfo_path = "content/shopItemInfo"
local buildIcon_path = "content/tradeStation/building/icon"
local buildLevel_path = "content/tradeStation/txtLevel"
local posText_path = "content/tradeStation/Pos/Text"
local posBtn_path = "content/tradeStation/Pos"
local lordParent_path = "content/tradeStation/lorderParent"
local lordHead_path = "content/tradeStation/lorderParent/UIPlayerHead"
local scroll_view_path = "content/shopItemInfo/shopItemList"
local shopMaskBtn_path = "content/shopItemInfo/shopMaskBtn"
local shopOpenBtn_path = "content/shopItemInfo/openBtn"
local buildClickBtn_path = "content/tradeStation/buildClickBtn"
local taxesInfo_path = "content/tradeStation/taxesInfo"
local taxesCount_path = "content/tradeStation/taxesInfo/taxesCount"
local stateText_path = "content/tradeStation/stateText"
local stateTime_path = "content/tradeStation/stateTime"
local animator_path = "content"
local taxes_icon_path = "content/tradeStation/taxesInfo/Image"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.itemBg1 = self:AddComponent(UIImage, itemBg1_path)
  self.itemBg2 = self:AddComponent(UIImage, itemBg2_path)
  self.tradeStation = self:AddComponent(UIBaseContainer, tradeStation_path)
  self.shopItemInfo = self:AddComponent(UIBaseContainer, shopItemInfo_path)
  self.buildIcon = self:AddComponent(UIImage, buildIcon_path)
  self.buildLevel = self:AddComponent(UIText, buildLevel_path)
  self.posText = self:AddComponent(UIText, posText_path)
  self.posBtn = self:AddComponent(UIButton, posBtn_path)
  self.lordParent = self:AddComponent(UIBaseContainer, lordParent_path)
  self.lordHead = self:AddComponent(UIBaseContainer, lordHead_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.shopMaskBtn = self:AddComponent(UIButton, shopMaskBtn_path)
  self.shopOpenBtn = self:AddComponent(UIButton, shopOpenBtn_path)
  self.buildClickBtn = self:AddComponent(UIButton, buildClickBtn_path)
  self.taxesInfo = self:AddComponent(UIBaseContainer, taxesInfo_path)
  self.taxesCount = self:AddComponent(UIText, taxesCount_path)
  self.stateText = self:AddComponent(UIText, stateText_path)
  self.stateTime = self:AddComponent(UIText, stateTime_path)
  self.animator = self:AddComponent(UIAnimator, animator_path)
  self.taxes_icon = self:AddComponent(UIImage, taxes_icon_path)
  self.loadPlayerHead = self:AddComponent(UICommonHead, lordHead_path)
  self.loadPlayerHead:SetEnableClickShowInfo(true, true)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.posBtn:SetOnClick(function()
    local v3 = SceneUtils.TileToWorld(self.data.pos, ForceChangeScene.World)
    local serverId = toInt(self.data.serverId)
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, LookAtFocusTime, nil, serverId, 0)
  end)
  self.shopMaskBtn:SetOnClick(function()
    self:ShowBuild()
  end)
  self.buildClickBtn:SetOnClick(function()
    self:ShowShop()
  end)
  self.shopOpenBtn:SetOnClick(function()
    local shopState = self.data:GetShopState()
    if shopState == 0 then
      UIUtil.ShowTipsId("season_s3_trade_city012")
      return
    end
    if shopState == 2 then
      UIUtil.ShowTipsId("season_s3_trade_city014")
      return
    end
    if shopState == 1 then
      DataCenter.SeasonTradeShopDataManager:EnterShop(self.data.tradeId, self.data.serverId)
      return
    end
  end)
end

local function ComponentDestroy(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIBaseContainer)
  if not IsNull(self.sequence) then
    self.sequence:Pause()
    self.sequence:Kill()
    self.sequence = nil
  end
  self.itemBg1 = nil
  self.itemBg2 = nil
  self.tradeStation = nil
  self.shopItemInfo = nil
  self.buildIcon = nil
  self.buildLevel = nil
  self.posText = nil
  self.posBtn = nil
  self.lordParent = nil
  self.lordHead = nil
  self.scroll_view = nil
  self.shopMaskBtn = nil
  self.shopOpenBtn = nil
  self.buildClickBtn = nil
  self.taxesInfo = nil
  self.taxesCount = nil
  self.stateText = nil
  self.stateTime = nil
  self.animator = nil
  self.taxes_icon = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function TradeCityListItem:ReInit(index, data, showTax, playAnim, showShop_)
  self.index = index
  self.data = data
  self.shopState = self.data:GetShopState()
  self.posText:SetText(string.format("#%s %s", self.data.serverId, self.data.posStr))
  if self.data.occupyInfoUserInfo then
    self.loadPlayerHead:SetHeadAndFrame(self.data.occupyInfoUserInfo.uid, self.data.occupyInfoUserInfo.pic, self.data.occupyInfoUserInfo.picVer, false, self.data.occupyInfoUserInfo.headSkinId, self.data.occupyInfoUserInfo.headSkinET)
    self.lordParent:SetActive(true)
  else
    self.lordParent:SetActive(false)
  end
  self.buildIcon:LoadSprite(self.data.iconPath)
  self.buildLevel:SetLocalText("140002", self.data.level)
  self.list = nil
  if showShop_ then
    self:ShowShop()
  else
    self:ShowBuild()
  end
  self.endTime = nil
  local state, str = self.data:GetTimeState()
  if showTax then
    self.stateTime:SetActive(false)
    if self.shopState == 2 then
      self.taxesCount:SetLocalText("champion_duel_tips1055")
      self.taxes_icon:SetActive(false)
    else
      self.taxesCount:SetText(self.data:GetTaxes())
      self.taxes_icon:SetActive(true)
    end
    self.taxesInfo:SetActive(true)
    if state == AllianceCityShowTimeState.TradeLock then
      if self.shopState == 1 then
        str = "season_alliance_trade_list_6"
      elseif self.shopState == 2 then
        str = 320268
      else
        str = "season_alliance_trade_list_5"
      end
      self.stateText:SetLocalText(str)
    elseif state == AllianceCityShowTimeState.TradeBattle then
      self.stateText:SetLocalText("season_alliance_trade_list_7")
    else
      self.stateText:SetLocalText(self.shopState == 1 and "season_s3_activity_1000072_desc11" or "season_s3_activity_1000072_desc12")
    end
    return
  end
  self.taxesInfo:SetActive(false)
  if state == AllianceCityShowTimeState.TradeLock then
    if self.shopState == 1 then
      str = "season_s3_activity_1000072_desc11"
    elseif self.shopState == 2 then
      str = 320268
    else
      str = "season_alliance_trade_list_15"
    end
    self.stateText:SetLocalText(str)
  elseif state == AllianceCityShowTimeState.TradeBattle then
    self.stateText:SetLocalText("season_s3_activity_1000072_desc13")
    self.endTime = self.data.battleEndTime
  else
    self.stateText:SetLocalText(self.shopState == 1 and "season_s3_activity_1000072_desc11" or "season_s3_activity_1000072_desc12")
  end
  self.stateTime:SetActive(self.endTime ~= nil)
end

function TradeCityListItem:ShowBuild()
  self.tradeStation:SetActive(true)
  self.shopItemInfo:SetActive(false)
  self.itemBg1:SetActive(true)
  self.itemBg2:SetActive(false)
end

function TradeCityListItem:ShowShop()
  self.tradeStation:SetActive(false)
  self.shopItemInfo:SetActive(true)
  self.itemBg1:SetActive(false)
  self.itemBg2:SetActive(true)
  if self.list == nil or self.cityTemplate == nil then
    self.cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(self.data.tradeId, self.data.serverId)
    local shopId = self.cityTemplate ~= nil and self.cityTemplate:GetShopId()
    self.list = DataCenter.SeasonTradeShopDataManager:GetItemsByShopId(shopId)
    local cnt = #self.list
    self.scroll_view:SetTotalCount(cnt)
    self.scroll_view:RefillCells()
  end
end

function TradeCityListItem:Update1000MS()
  if self.endTime then
    UIUtil.SetLeftTimeText(self.stateTime, nil, self.endTime)
  end
end

function TradeCityListItem:OnItemMoveIn(itemObj, idx)
  itemObj.name = tostring(idx)
  local cellItem = self.scroll_view:AddComponent(UIBaseContainer, itemObj)
  if cellItem == nil then
    return
  end
  local item = cellItem.resItem
  if item == nil then
    item = cellItem:AddComponent(UICommonResItem, "UICommonResItem")
    cellItem.resItem = item
    cellItem.mask = cellItem.transform:Find("Mask").gameObject
    cellItem.itemParam = UICommonResItem.Param.New()
  end
  local template = self.list[idx]
  local itemParam = cellItem.itemParam
  itemParam = UICommonResItem.Param.New()
  itemParam.rewardType = template.rewardType
  itemParam.itemId = template.itemId
  itemParam.count = template.count
  itemParam.enableClick = true
  item:ReInit(itemParam)
  cellItem.mask:SetActive(self.shopState ~= 1)
end

function TradeCityListItem:OnItemMoveOut(itemObj, _)
  self.scroll_view:RemoveComponent(itemObj.name, UIBaseContainer)
end

TradeCityListItem.OnCreate = OnCreate
TradeCityListItem.OnDestroy = OnDestroy
TradeCityListItem.OnEnable = OnEnable
TradeCityListItem.OnDisable = OnDisable
TradeCityListItem.ComponentDefine = ComponentDefine
TradeCityListItem.ComponentDestroy = ComponentDestroy
TradeCityListItem.DataDefine = DataDefine
TradeCityListItem.DataDestroy = DataDestroy
return TradeCityListItem
