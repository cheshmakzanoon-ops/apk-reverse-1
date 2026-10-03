local LWCompleteImmdiatelyPanelView = BaseClass("LWCompleteImmdiatelyPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local speedUpIconPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_lijiwancheng_jiasu_icon.png"
local diamondIconPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_gold.png"

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
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText")
  self.textTitle:SetLocalText("110013")
  self.btnBlackPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnBlackPanel:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/Common_bg_orange/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnConfirm = self:AddComponent(UIButton, "UICommonPopUpTitle/Common_bg_orange/ConfirmBtn")
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.btnConfirmText = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/Common_bg_orange/ConfirmBtn/Text")
  self.btnConfirmText:SetLocalText("110013")
  self.commonResItemPrefab = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/Common_bg_orange/Content/UICommonResItem")
  self.resContent = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/Common_bg_orange/Content/ResContent")
  self.textResEnoughTitle = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/Common_bg_orange/Content/ResContent/ResEnoughTitle")
  self.textResEnoughTitle:SetLocalText("finish_resourceEnough")
  self.textResNoAvaliableTitle = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/Common_bg_orange/Content/ResContent/ResToUseContent/ResNoAvailableTitle")
  self.textResNoAvaliableTitle:SetLocalText("finish_noResource")
  self.resToUseContent = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/Common_bg_orange/Content/ResContent/ResToUseContent")
  self.resToUseScrollView = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/Common_bg_orange/Content/ResContent/ResToUseContent/ResItemScrollView")
  self.resItemsContent = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/Common_bg_orange/Content/ResContent/ResToUseContent/ResItemScrollView/Viewport/ResItemsContent")
  self.compResUsed1Labels = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/Common_bg_orange/Content/ResContent/ResToUseContent/ResUsed1Labels")
  self.compResUsed11Label = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/Common_bg_orange/Content/ResContent/ResToUseContent/ResUsed1Labels/ResUsed11Label")
  self.imgResUsed11Icon = self:AddComponent(UIImage, "UICommonPopUpTitle/Common_bg_orange/Content/ResContent/ResToUseContent/ResUsed1Labels/ResUsed11Label/ResUsed11Icon")
  self.textResUsed11 = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/Common_bg_orange/Content/ResContent/ResToUseContent/ResUsed1Labels/ResUsed11Label/ResUsed11Text")
  self.compResUsed12Label = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/Common_bg_orange/Content/ResContent/ResToUseContent/ResUsed1Labels/ResUsed12Label")
  self.imgResUsed12Icon = self:AddComponent(UIImage, "UICommonPopUpTitle/Common_bg_orange/Content/ResContent/ResToUseContent/ResUsed1Labels/ResUsed12Label/ResUsed12Icon")
  self.textResUsed12 = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/Common_bg_orange/Content/ResContent/ResToUseContent/ResUsed1Labels/ResUsed12Label/ResUsed12Text")
  self.compResUsed2Labels = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/Common_bg_orange/Content/ResContent/ResToUseContent/ResUsed2Labels")
  self.compResUsed21Label = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/Common_bg_orange/Content/ResContent/ResToUseContent/ResUsed2Labels/ResUsed21Label")
  self.imgResUsed21Icon = self:AddComponent(UIImage, "UICommonPopUpTitle/Common_bg_orange/Content/ResContent/ResToUseContent/ResUsed2Labels/ResUsed21Label/ResUsed21Icon")
  self.textResUsed21 = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/Common_bg_orange/Content/ResContent/ResToUseContent/ResUsed2Labels/ResUsed21Label/ResUsed21Text")
  self.compResUsed22Label = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/Common_bg_orange/Content/ResContent/ResToUseContent/ResUsed2Labels/ResUsed22Label")
  self.imgResUsed22Icon = self:AddComponent(UIImage, "UICommonPopUpTitle/Common_bg_orange/Content/ResContent/ResToUseContent/ResUsed2Labels/ResUsed22Label/ResUsed22Icon")
  self.textResUsed22 = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/Common_bg_orange/Content/ResContent/ResToUseContent/ResUsed2Labels/ResUsed22Label/ResUsed22Text")
  self.speedUpContent = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/Common_bg_orange/Content/SpeedUpContent")
  self.textSpeedUpEnoughTitle = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/Common_bg_orange/Content/SpeedUpContent/SpeedUpEnoughTitle")
  self.textSpeedUpNoAvaliableTitle = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/Common_bg_orange/Content/SpeedUpContent/SpeedUpToUseContent/SpeedUpNoAvailableTitle")
  self.textSpeedUpNoAvaliableTitle:SetLocalText("finish_noSpeedup")
  self.speedUpToUseContent = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/Common_bg_orange/Content/SpeedUpContent/SpeedUpToUseContent")
  self.speedUpToUseScrollView = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/Common_bg_orange/Content/SpeedUpContent/SpeedUpToUseContent/SpeedUpItemScrollView")
  self.speedUpItemsContent = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/Common_bg_orange/Content/SpeedUpContent/SpeedUpToUseContent/SpeedUpItemScrollView/Viewport/SpeedUpItemsContent")
  self.compSpeedUpUsedLabels = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/Common_bg_orange/Content/SpeedUpContent/SpeedUpToUseContent/SpeedUpUsedLabels")
  self.compSpeedUpUsedLabel = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/Common_bg_orange/Content/SpeedUpContent/SpeedUpToUseContent/SpeedUpUsedLabels/SpeedUpUsedLabel")
  self.imgSpeedUpUsedIcon = self:AddComponent(UIImage, "UICommonPopUpTitle/Common_bg_orange/Content/SpeedUpContent/SpeedUpToUseContent/SpeedUpUsedLabels/SpeedUpUsedLabel/SpeedUpUsedIcon")
  self.textSpeedUpUsed = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/Common_bg_orange/Content/SpeedUpContent/SpeedUpToUseContent/SpeedUpUsedLabels/SpeedUpUsedLabel/SpeedUpUsedText")
  self.compDiamondContent = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/Common_bg_orange/Content/DiamondContent")
  self.compResourceDiamondItem = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/Common_bg_orange/Content/DiamondContent/DiamondDetail/ResourceDiamondItem")
  self.textResDiamondLabel = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/Common_bg_orange/Content/DiamondContent/DiamondDetail/ResourceDiamondItem/ResDiamondLabel")
  self.textResDiamondLabel:SetLocalText("finish_diamondToResource")
  self.textResDiamondCount = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/Common_bg_orange/Content/DiamondContent/DiamondDetail/ResourceDiamondItem/ResDiamondIcon/ResDiamondCount")
  self.imgResDiamondCount = self:AddComponent(UIImage, "UICommonPopUpTitle/Common_bg_orange/Content/DiamondContent/DiamondDetail/ResourceDiamondItem/ResDiamondIcon")
  self.compAccDiamondItem = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/Common_bg_orange/Content/DiamondContent/DiamondDetail/AccDiamondItem")
  self.compTotalDiamondItem = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/Common_bg_orange/Content/DiamondContent/DiamondDetail/TotalDiamondItem")
  self.textAccDiamondCount = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/Common_bg_orange/Content/DiamondContent/DiamondDetail/AccDiamondItem/AccDiamondIcon/AccDiamondCount")
  self.imgAccDiamondCount = self:AddComponent(UIImage, "UICommonPopUpTitle/Common_bg_orange/Content/DiamondContent/DiamondDetail/AccDiamondItem/AccDiamondIcon")
  self.textAccDiamondLabel = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/Common_bg_orange/Content/DiamondContent/DiamondDetail/AccDiamondItem/AccDiamondLabel")
  self.textAccDiamondLabel:SetLocalText("finish_diamondToSpeedup")
  self.textTotalDiamondLabel = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/Common_bg_orange/Content/DiamondContent/DiamondDetail/TotalDiamondItem/TotalDiamondLabel")
  self.textTotalDiamondLabel:SetLocalText("finish_diamondTotal")
  self.textTotalDiamondCount = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/Common_bg_orange/Content/DiamondContent/DiamondDetail/TotalDiamondItem/TotalDiamondIcon/TotalDiamondCount")
  self.imgTotalDiamondCount = self:AddComponent(UIImage, "UICommonPopUpTitle/Common_bg_orange/Content/DiamondContent/DiamondDetail/TotalDiamondItem/TotalDiamondIcon")
  self.compDiamondContent:SetActive(false)
  self.speedUpContent:SetActive(false)
  self.resContent:SetActive(false)
  self.compResUsed1Labels:SetActive(false)
  self.compResUsed2Labels:SetActive(false)
  self.commonResPrefabGameObj = self.commonResItemPrefab.gameObject
  self.commonResPrefabGameObj:SetActive(false)
  self.commonResPrefabGameObj:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.textTitle = nil
  self.btnClose = nil
  self.btnConfirm = nil
  self.btnConfirmText = nil
  self.commonResItemPrefab = nil
  self.resContent = nil
  self.textResEnoughTitle = nil
  self.resToUseContent = nil
  self.resItemsContent = nil
  self.compResUsed1Labels = nil
  self.compResUsed11Label = nil
  self.imgResUsed11Icon = nil
  self.textResUsed11 = nil
  self.compResUsed12Label = nil
  self.imgResUsed12Icon = nil
  self.textResUsed12 = nil
  self.compResUsed2Labels = nil
  self.compResUsed21Label = nil
  self.imgResUsed21Icon = nil
  self.textResUsed21 = nil
  self.compResUsed22Label = nil
  self.imgResUsed22Icon = nil
  self.textResUsed22 = nil
  self.speedUpContent = nil
  self.textSpeedUpEnoughTitle = nil
  self.speedUpToUseContent = nil
  self.speedUpItemsContent = nil
  self.compSpeedUpUsedLabels = nil
  self.compSpeedUpUsedLabel = nil
  self.imgSpeedUpUsedIcon = nil
  self.textSpeedUpUsed = nil
  self.compDiamondContent = nil
  self.compResourceDiamondItem = nil
  self.textResDiamondLabel = nil
  self.textResDiamondCount = nil
  self.compAccDiamondItem = nil
  self.compTotalDiamondItem = nil
  self.textAccDiamondCount = nil
  self.textAccDiamondLabel = nil
  self.textTotalDiamondLabel = nil
  self.textTotalDiamondCount = nil
  self.imgTotalDiamondCount = nil
  self.imgAccDiamondCount = nil
  self.imgResDiamondCount = nil
  self.commonResPrefabGameObj:GameObjectRecycleAll()
  self.commonResPrefabGameObj = null
end

function LWCompleteImmdiatelyPanelView:InitResAllNeedPanel(goodsUseDatas)
  if self.resCommonItems then
    for i, item in ipairs(self.resCommonItems) do
      item.gameObject:GameObjectRecycle()
    end
  end
  self.resItemsContent:RemoveComponents(UICommonResItem)
  self.resCommonItems = {}
  self.compResUsed11Label:SetActive(false)
  self.compResUsed12Label:SetActive(false)
  self.compResUsed21Label:SetActive(false)
  self.compResUsed22Label:SetActive(false)
  local typeNoUseCount = 0
  local itemId = 1
  for j, goodsUsdData in ipairs(goodsUseDatas) do
    if #goodsUsdData.usedItems == 0 then
      typeNoUseCount = typeNoUseCount + 1
    end
    for k = 1, #goodsUsdData.usedItems do
      local goItem = self.commonResPrefabGameObj:GameObjectSpawn(self.resItemsContent.transform)
      goItem.name = "item_" .. itemId
      itemId = itemId + 1
      goItem:SetActive(true)
      local theItem = self.resItemsContent:AddComponent(UICommonResItem, goItem.name)
      theItem:ReInit(goodsUsdData.usedItems[k])
      table.insert(self.resCommonItems, theItem)
    end
    local resDiamond = 0 < goodsUsdData.stillDifferenceCount and CommonUtil.GetResGoldByType(goodsUsdData.resType, goodsUsdData.stillDifferenceCount) or 0
    self.totalResDiamond = self.totalResDiamond + resDiamond
    local icon = DataCenter.ResourceManager:GetResourceIconByType(goodsUsdData.resType)
    local needShowStr = string.format("<color=#2a2830>/ %s</color>", string.GetFormattedStr(goodsUsdData.totalNeedCount))
    local haveNum = goodsUsdData.totalNeedCount - goodsUsdData.stillDifferenceCount
    local haveShowStr = ""
    if 0 >= goodsUsdData.stillDifferenceCount then
      haveShowStr = string.format("<color=#099b4a> %s</color>", string.GetFormattedStr(haveNum))
    else
      haveShowStr = string.format("<color=#f53c3d> %s</color>", string.GetFormattedStr(haveNum))
    end
    local labelStr = haveShowStr .. needShowStr
    if j == 1 then
      self.compResUsed11Label:SetActive(true)
      self.imgResUsed11Icon:LoadSprite(icon)
      self.textResUsed11:SetText(labelStr)
    elseif j == 2 then
      self.compResUsed12Label:SetActive(true)
      self.imgResUsed12Icon:LoadSprite(icon)
      self.textResUsed12:SetText(labelStr)
    elseif j == 3 then
      self.compResUsed21Label:SetActive(true)
      self.imgResUsed21Icon:LoadSprite(icon)
      self.textResUsed21:SetText(labelStr)
    elseif j == 4 then
      self.compResUsed22Label:SetActive(true)
      self.imgResUsed22Icon:LoadSprite(icon)
      self.textResUsed22:SetText(labelStr)
    end
  end
  return typeNoUseCount
end

function LWCompleteImmdiatelyPanelView:CheckShowResContent()
  self.totalResDiamond = 0
  if not self.data or not self.data.resLackDatas then
    return
  end
  self.resContent:SetActive(true)
  if 0 < #self.data.resLackDatas then
    self.resGoodsNeedDatas = {}
    local showCollectTips = false
    for i, resData in ipairs(self.data.resLackDatas) do
      local resType = resData.resType
      local totalNeedCount = resData.totalNeedCount
      local alreadyOwnResNum = CommonUtil.GetResOrItemCount(resType)
      local differenceCount = totalNeedCount - alreadyOwnResNum
      if 0 < differenceCount then
        local collection = LWResourceLackUtil:TryCollectBuildingCollection(resType, differenceCount, true)
        differenceCount = differenceCount - collection
        local hangUpValue = LWResourceLackUtil:TryGetHangUpRewardCanCollectResNum(resType, true)
        differenceCount = differenceCount - hangUpValue
        if 0 < collection or 0 < hangUpValue then
          showCollectTips = true
        end
        if 0 < differenceCount then
          table.insert(self.resGoodsNeedDatas, {
            resType = resType,
            differenceCount = differenceCount,
            totalNeedCount = totalNeedCount
          })
        end
      end
    end
    if showCollectTips then
      UIUtil.ShowTipsId("fill_up_collect_resources")
    end
    self.compResUsed1Labels:SetActive(0 < #self.resGoodsNeedDatas)
    self.compResUsed2Labels:SetActive(#self.resGoodsNeedDatas > 2)
    if self.resGoodsNeedDatas and 0 < #self.resGoodsNeedDatas then
      self.textResEnoughTitle:SetActive(false)
      self.resToUseContent:SetActive(true)
      self.goodsUseDatas = {}
      for i, resGoodsNeedData in ipairs(self.resGoodsNeedDatas) do
        local resType = resGoodsNeedData.resType
        local differenceCount = resGoodsNeedData.differenceCount
        local totalNeedCount = resGoodsNeedData.totalNeedCount
        local usedItems, stillDifferenceCount = LWResourceLackUtil:GetResItemsToSupplementDatas(resType, differenceCount)
        table.insert(self.goodsUseDatas, {
          resType = resType,
          stillDifferenceCount = stillDifferenceCount,
          usedItems = usedItems,
          totalNeedCount = totalNeedCount
        })
      end
      local typeNoUseCount = self:InitResAllNeedPanel(self.goodsUseDatas)
      if typeNoUseCount >= #self.goodsUseDatas then
        self.textResNoAvaliableTitle:SetActive(true)
        self.resToUseScrollView:SetActive(false)
      else
        self.textResNoAvaliableTitle:SetActive(false)
        self.resToUseScrollView:SetActive(true)
      end
    else
      self.textResEnoughTitle:SetActive(true)
      self.resToUseContent:SetActive(false)
    end
  else
    self.textResEnoughTitle:SetActive(true)
    self.resToUseContent:SetActive(false)
  end
end

function LWCompleteImmdiatelyPanelView:CheckShowSpeedUpContent()
  self.totalSpeedUpDiamond = 0
  if not self.data or not self.data.speedUpData then
    return
  end
  self.speedUpContent:SetActive(true)
  local speedUpItems = self.data.speedUpData.speedUpItems
  local speedUpDifferentTime = self.data.speedUpData.speedUpDifferentTime or 0
  local speedUpTotalTime = self.data.speedUpData.speedUpTotalTime or 0
  if 0 < speedUpDifferentTime then
    self.totalSpeedUpDiamond = self.totalSpeedUpDiamond + CommonUtil.GetTimeDiamondCost(speedUpDifferentTime)
  end
  if self.speedUpCommonItems then
    for i, item in ipairs(self.speedUpCommonItems) do
      item.gameObject:GameObjectRecycle()
    end
  end
  self.speedUpItemsContent:RemoveComponents(UICommonResItem)
  self.speedUpCommonItems = {}
  if speedUpItems and 0 < #speedUpItems then
    self.textSpeedUpNoAvaliableTitle:SetActive(false)
    self.speedUpToUseScrollView:SetActive(true)
    local itemId = 1
    for k = 1, #speedUpItems do
      local goItem = self.commonResPrefabGameObj:GameObjectSpawn(self.speedUpItemsContent.transform)
      goItem.name = "item_" .. itemId
      itemId = itemId + 1
      goItem:SetActive(true)
      local theItem = self.speedUpItemsContent:AddComponent(UICommonResItem, goItem.name)
      theItem:ReInit(speedUpItems[k].item)
      table.insert(self.speedUpCommonItems, theItem)
    end
  else
    self.textSpeedUpNoAvaliableTitle:SetActive(true)
    self.speedUpToUseScrollView:SetActive(false)
  end
  self.compSpeedUpUsedLabels:SetActive(true)
  self.compSpeedUpUsedLabel:SetActive(true)
  self.imgSpeedUpUsedIcon:LoadSprite(speedUpIconPath)
  local totalSpeedUpTimeStr = string.format("<color=#2a2830>/ %s</color>", UITimeManager:GetInstance():MilliSecondToFmtString(speedUpTotalTime * 1000))
  local alreadySpeedUpTime = speedUpTotalTime - speedUpDifferentTime
  local formatedAlreadySpeedTime = UITimeManager:GetInstance():MilliSecondToFmtString(alreadySpeedUpTime * 1000)
  local alreadySpeedUpTimeStr = ""
  if speedUpDifferentTime <= 0 then
    alreadySpeedUpTimeStr = string.format("<color=#099b4a> %s</color>", formatedAlreadySpeedTime)
  else
    alreadySpeedUpTimeStr = string.format("<color=#f53c3d> %s</color>", formatedAlreadySpeedTime)
  end
  local labelStr = alreadySpeedUpTimeStr .. totalSpeedUpTimeStr
  self.textSpeedUpUsed:SetText(labelStr)
end

function LWCompleteImmdiatelyPanelView:CheckShowNeedDiamondContent()
  local totalNeedDiamond = self.totalResDiamond + self.totalSpeedUpDiamond
  if 0 < totalNeedDiamond then
    self.compDiamondContent:SetActive(true)
    self.compTotalDiamondItem:SetActive(true)
    self.textTotalDiamondCount:SetText(string.GetFormattedSeperatorNum(totalNeedDiamond))
    self.imgTotalDiamondCount:LoadSprite(diamondIconPath)
    self.imgAccDiamondCount:LoadSprite(diamondIconPath)
    self.imgResDiamondCount:LoadSprite(diamondIconPath)
    local hasDiamond = LuaEntry.Player.gold
    if totalNeedDiamond > hasDiamond then
      self.textTotalDiamondCount:SetColorRGBA(0.9607843, 0.2352941, 0.2392157, 1)
    else
      self.textTotalDiamondCount:SetColorRGBA(0.03529412, 0.6078432, 0.2901961, 1)
    end
    self.compResourceDiamondItem:SetActive(self.totalResDiamond > 0)
    self.textResDiamondCount:SetText(string.GetFormattedSeperatorNum(self.totalResDiamond))
    self.compAccDiamondItem:SetActive(self.totalSpeedUpDiamond > 0)
    self.textAccDiamondCount:SetText(string.GetFormattedSeperatorNum(self.totalSpeedUpDiamond))
  else
    self.compDiamondContent:SetActive(false)
  end
  self.totalNeedDiamond = totalNeedDiamond
end

local function DataDefine(self)
  self.data = self:GetUserData()
  self:Refresh()
end

function LWCompleteImmdiatelyPanelView:Refresh()
  self:CheckShowResContent()
  self:CheckShowSpeedUpContent()
  self:CheckShowNeedDiamondContent()
end

function LWCompleteImmdiatelyPanelView:GetResLackList(resType, need)
  local templates = DataCenter.LWResourceLackManager:GetResourceWay(resType)
  local tempDataList
  if not table.IsNullOrEmpty(templates) then
    tempDataList = LWResourceLackUtil:FilterResourceTemplates(templates, need)
  end
  if not tempDataList or #tempDataList == 0 then
    return
  end
  table.sort(tempDataList, function(a, b)
    return a.order < b.order
  end)
  local resLackList
  if 0 < table.count(tempDataList) then
    local giftPackageData = tempDataList[1]
    if giftPackageData.tips == LWResourceLackGetWay.GiftPackage or giftPackageData.tips == LWResourceLackGetWay.GiftPackageList then
      resLackList = {}
      if table.count(tempDataList) > 1 then
        for k = 2, table.count(tempDataList) do
          table.insert(resLackList, tempDataList[k])
        end
      end
    else
      resLackList = tempDataList
    end
  end
  resLackList = resLackList or {}
  return resLackList
end

local function DataDestroy(self)
  self.data = nil
  self.resGoodsNeedDatas = nil
  self.goodsUseDatas = nil
  self.itemsCount = nil
  self.speedUpCommonItems = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGold, self.CheckShowNeedDiamondContent)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateGold, self.CheckShowNeedDiamondContent)
  base.OnRemoveListener(self)
end

local function OnBtnCloseClick(self)
  self.ctrl:CloseSelf()
end

local function OnBtnConfirmClick(self)
  local hasDiamond = LuaEntry.Player.gold
  if self.totalNeedDiamond and self.totalNeedDiamond > 0 and hasDiamond < self.totalNeedDiamond then
    local data = {}
    table.insert(data, {
      resType = ResourceType.Gold,
      need = self.totalNeedDiamond
    })
    LWResourceLackUtil:GotoResLack(data)
    return
  end
  local totalDiamondCount = self.totalSpeedUpDiamond + self.totalResDiamond
  if 0 < totalDiamondCount then
    local param = {
      contentText = Localization:GetString(GameDialogDefine.USE_GOLF_TIP_DES),
      btnNum = 2,
      confirmBtnParam = {
        action = function()
          self:UseAllToCompleteImmediately()
          self.ctrl:CloseSelf()
        end
      }
    }
    UIUtil.TryShowDiamondConfirm(TodayNoSecondConfirmType.UpgradeUseDiamond, param)
  else
    self:UseAllToCompleteImmediately()
    self.ctrl:CloseSelf()
  end
end

function LWCompleteImmdiatelyPanelView:UseAllToCompleteImmediately()
  if self.data and self.data.OnClickImmediately then
    local callBackData = {}
    callBackData.timeGold = self.totalSpeedUpDiamond
    callBackData.resGold = self.totalResDiamond
    callBackData.speedUpItems = self.data.speedUpData and self.data.speedUpData.speedUpItems or {}
    callBackData.goodsUseDatas = self.goodsUseDatas or {}
    if self.data.CheckBeforeClickImmediately ~= nil and not self.data.CheckBeforeClickImmediately(callBackData) then
      return
    end
    self:UseShowedResItem()
    self.data.OnClickImmediately(callBackData)
  end
end

function LWCompleteImmdiatelyPanelView:UseShowedResItem()
  if not self.goodsUseDatas then
    return
  end
  for i, goodsUseData in ipairs(self.goodsUseDatas) do
    local usedItems = goodsUseData.usedItems
    for j, usedItem in ipairs(usedItems) do
      local items = DataCenter.ItemData:GetItemById(usedItem.itemId)
      if items ~= nil then
        local itemCount = items.count
        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(items.itemId)
        local goodType = tonumber(goods.type)
        if goodType == GOODS_TYPE.GOODS_TYPE_3 then
          local give = tonumber(goods.para2) or 0
          SFSNetwork.SendMessage(MsgDefines.ItemUse, {
            uuid = items.uuid,
            give = give,
            haveNum = itemCount,
            num = usedItem.count,
            opType = 1
          })
        elseif goodType == GOODS_TYPE.GOODS_TYPE_109 then
          local returnItem = DataCenter.AdaptiveBoxTemplateManager:GetReturnItem(tonumber(goods.para1), DataCenter.BuildManager.MainLv, tonumber(goods.para2))
          local give = returnItem.count * tonumber(goods.para3)
          SFSNetwork.SendMessage(MsgDefines.ItemUse, {
            uuid = items.uuid,
            give = give,
            haveNum = itemCount,
            num = usedItem.count,
            opType = 1
          })
        end
        if goods:IsSelectBox() and not goods:IsGuarantBox() and usedItem.chooseItemIndex then
          SFSNetwork.SendMessage(MsgDefines.ItemUse, {
            uuid = items.uuid,
            para1 = tostring(usedItem.chooseItemIndex),
            num = usedItem.count,
            continueUse = true,
            opType = 1
          })
        end
      end
    end
  end
end

LWCompleteImmdiatelyPanelView.OnCreate = OnCreate
LWCompleteImmdiatelyPanelView.OnDestroy = OnDestroy
LWCompleteImmdiatelyPanelView.OnEnable = OnEnable
LWCompleteImmdiatelyPanelView.OnDisable = OnDisable
LWCompleteImmdiatelyPanelView.ComponentDefine = ComponentDefine
LWCompleteImmdiatelyPanelView.ComponentDestroy = ComponentDestroy
LWCompleteImmdiatelyPanelView.DataDefine = DataDefine
LWCompleteImmdiatelyPanelView.DataDestroy = DataDestroy
LWCompleteImmdiatelyPanelView.OnAddListener = OnAddListener
LWCompleteImmdiatelyPanelView.OnRemoveListener = OnRemoveListener
LWCompleteImmdiatelyPanelView.OnBtnCloseClick = OnBtnCloseClick
LWCompleteImmdiatelyPanelView.OnBtnConfirmClick = OnBtnConfirmClick
return LWCompleteImmdiatelyPanelView
