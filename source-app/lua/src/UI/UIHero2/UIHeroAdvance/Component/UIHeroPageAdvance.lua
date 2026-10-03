local UIHeroPageAdvance = BaseClass("UIHeroPageAdvance", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroAdvanceCell = require("UI.UIHero2.UIHeroAdvance.Component.UIHeroAdvanceCell")
local UIHeroAdvanceSlot = require("UI.UIHero2.UIHeroAdvance.Component.UIHeroAdvanceSlot")
local UIHeroAdvanceListTitleLine = require("UI.UIHero2.UIHeroAdvance.Component.UIHeroAdvanceListTitleLine")
local UIHeroAdvanceListRow = require("UI.UIHero2.UIHeroAdvance.Component.UIHeroAdvanceListRow")
local UIHeroCell = require("UI.UIHero2.Common.UIHeroCellSmall")
local UIGray = CS.UIGray
local AdvanceReqData = require("DataCenter.HeroData.AdvanceReqData")
local UIHeroDebrisItemCell = require("UI.UIHero2.Common.UIHeroDebrisItemCell")
local Toggle1_Index = 1
local Toggle2_Index = 2
local Toggle3_Index = 3
local AdvanceReqDatas = {}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, CommonShopType.HeroReset)
end

local function OnDestroy(self)
  HeroAdvanceController:GetInstance():SetAdvanceHeroUuid(nil)
  self:SetAllCellsDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.tabCamps = {}
  self.redPot = {}
  self.blueHero = true
  for i = 0, 3 do
    local path = string.format("RightPanel/TabContent/%s", i)
    local tab = self:AddComponent(UIButton, path)
    tab:SetOnClick(function()
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      self:OnSwitchCamp(i)
    end)
    local red = self:AddComponent(UIBaseContainer, path .. "/" .. "RedPoint_" .. i)
    self.tabCamps[i] = tab
    self.redPot[i] = red
  end
  self.rightPanel = self:AddComponent(UIBaseContainer, "RightPanel")
  self.rightPanel:SetActive(true)
  self.content = self:AddComponent(UIBaseContainer, "RightPanel/layout/LoopScroll/Viewport/Content")
  self.scroll_view_hero = self:AddComponent(UILoopListView2, "RightPanel/layout/LoopScroll")
  self.scroll_view_hero:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.content_food = self:AddComponent(UIBaseContainer, "RightPanel/layout/LoopScroll_Food/Viewport/Content_Food")
  self.scroll_view_food = self:AddComponent(UILoopListView2, "RightPanel/layout/LoopScroll_Food")
  self.scroll_view_food:InitListView(0, function(loopView, index)
    return self:OnGetFoodItemByIndex(loopView, index)
  end)
  self.objHero = self:AddComponent(UIBaseContainer, "ObjHero")
  self.imgQualityBg = self:AddComponent(UIImage, "ObjHero/ImgQualityBg")
  self.imgCamp = self:AddComponent(UIImage, "ObjHero/ImgQualityBg/ImgCamp")
  self.textHeroName = self:AddComponent(UIText, "ObjHero/ImgQualityBg/TextHeroName")
  self.textHeroNickName = self:AddComponent(UIText, "ObjHero/ImgQualityBg/TextNickName")
  self.nodeStarBox = self:AddComponent(UIBaseContainer, "ObjHero/ImgQualityBg/StarBox")
  self.debrisCell = self:AddComponent(UIHeroDebrisItemCell, "UIHeroDebrisItemCell")
  self.debrisCell:SetData(HeroUtils.GetGoldHeroDebrisId())
  self.btnAdvance = self:AddComponent(UIButton, "RightPanel/layout/BtnAdvance")
  self.btnAdvance:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnAdvanceClick()
  end)
  self.textTip1 = self:AddComponent(UIText, "RightPanel/layout/TextTip1")
  self.textTip1:SetLocalText(129124)
  self.textAdvance = self:AddComponent(UIText, "RightPanel/layout/BtnAdvance/BtnText")
  self.textAdvance_shadow = self:AddComponent(UIShadow, "RightPanel/layout/BtnAdvance/BtnText")
  self.textAdvance:SetLocalText(150115)
  self.oneKey = self:AddComponent(UIBaseContainer, "RightPanel/layout/OneKey")
  self.btnOneKeyAdvance = self:AddComponent(UIButton, "RightPanel/layout/OneKey/BtnOneKeyAdvance")
  self.btnOneKeyAdvance:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    local openFlag = self:CheckToggleIsOpen()
    if openFlag == false then
      self:ShowOneKeyCondition()
      return
    end
    self:OnOneKeyBtnAdvanceClick(self.oneKeyQuality)
  end)
  self.btnOneKeyAdvanceText = self:AddComponent(UIText, "RightPanel/layout/OneKey/BtnOneKeyAdvance/BtnOneKeyAdvanceText")
  self.btnOneKeyAdvanceText:SetLocalText(129222)
  self.coreHeroSlot = self:AddComponent(UIHeroCell, "ObjHero/HeroAdvanceContent/UIAdvanceCore/UIHeroCellSmall")
  local btnCoreHero = self:AddComponent(UIButton, "ObjHero/HeroAdvanceContent/UIAdvanceCore")
  btnCoreHero:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnCancelCore()
  end)
  local btnCoreHeroCancel = self:AddComponent(UIButton, "ObjHero/HeroAdvanceContent/UIAdvanceCore/CoreClose")
  btnCoreHeroCancel:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnCancelCore()
  end)
  self.consumeObjList = {}
  for i = 1, HeroUtils.ConsumeSlotMax do
    local slot = self:AddComponent(UIHeroAdvanceSlot, "ObjHero/HeroAdvanceContent/ConsumeSlot" .. i)
    slot:SetParent(self)
    self.consumeObjList[i] = slot
  end
  self.oneKeyConfig = self:AddComponent(UIButton, "RightPanel/layout/OneKey/BtnOneKeyConfig")
  self.oneKeyConfig:SetActive(false)
  self.oneKeyConfig:SetOnClick(function()
    self:OneKeyConfigClick()
  end)
  self.choosePanel = self:AddComponent(UIBaseContainer, "RightPanel/layout/OneKey/ChoosePanel")
  self.choosePanelTitle = self:AddComponent(UIText, "RightPanel/layout/OneKey/ChoosePanel/ChoosePanelTitle")
  self.choosePanelTitle:SetLocalText(129233)
  self.choosePanel:SetActive(false)
  self.toggle1 = self:AddComponent(UIToggle, "RightPanel/layout/OneKey/ChoosePanel/toggleGroup/Toggle1")
  self.toggle2 = self:AddComponent(UIToggle, "RightPanel/layout/OneKey/ChoosePanel/toggleGroup/Toggle2")
  self.toggle3 = self:AddComponent(UIToggle, "RightPanel/layout/OneKey/ChoosePanel/toggleGroup/Toggle3")
  self.toggle1:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS(Toggle1_Index, 3)
    end
  end)
  self.toggle2:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS(Toggle2_Index, 5)
    end
  end)
  self.toggle3:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS(Toggle3_Index, 7)
    end
  end)
  self.currentToggle = Toggle1_Index
  self.oneKeyQuality = 3
  if self.toggle1:GetIsOn() then
    self:ToggleControlBorS(Toggle1_Index, 3)
  elseif self.toggle2:GetIsOn() then
    self:ToggleControlBorS(Toggle2_Index, 5)
  elseif self.toggle3:GetIsOn() then
    self:ToggleControlBorS(Toggle3_Index, 7)
  end
  local openFlag = self:CheckToggleIsOpen()
  self.oneKeyConfig:SetActive(openFlag)
  self.oneKeyBg = self:AddComponent(UIButton, "RightPanel/layout/OneKey/ChoosePanel/OneKeyBg")
  self.oneKeyBg:SetOnClick(function()
    self:OneKeyConfigClick()
  end)
  self.holeImg = self:AddComponent(UIBaseContainer, "HoleImg")
  self.maskImg = self:AddComponent(UIImage, "HoleImg/MaskImg")
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  self.maskImg.rectTransform.sizeDelta = Vector2.New(Screen.width * scaleFactor, Screen.height * scaleFactor)
  self.holeImg:SetActive(false)
  self.exchangeBtn = self:AddComponent(UIButton, "BtnExchange")
  self.exchangeIcon = self:AddComponent(UIImage, "BtnExchange/BtnExchangeIcon")
  self.exchangeNum = self:AddComponent(UIText, "BtnExchange/BtnExchangeNum")
  self.exchangeText = self:AddComponent(UIText, "BtnExchange/BtnExchangeText")
  self.exchangeText:SetLocalText(110029)
  self.exchangeBtn:SetActive(false)
  self.exchangeBtn:SetOnClick(function()
    self:OnExchangeClick()
  end)
end

local function OnGetFoodItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.dogFoodsList then
    return nil
  end
  local dt = self.dogFoodsList[index]
  if type(dt) == "number" then
    local item = loopScroll:NewListViewItem("TitleLine_Food")
    local script = self.content_food:GetComponent(item.gameObject.name, UIHeroAdvanceListTitleLine)
    if script == nil then
      local objectName = self:GetItemNameSequence()
      item.gameObject.name = objectName
      if not item.IsInitHandlerCalled then
        item.IsInitHandlerCalled = true
      end
      script = self.content_food:AddComponent(UIHeroAdvanceListTitleLine, objectName)
    end
    script:SetActive(true)
    script:SetData(dt)
    return item
  end
  local item = loopScroll:NewListViewItem("HeroRow_Food")
  local script = self.content_food:GetComponent(item.gameObject.name, UIHeroAdvanceListRow)
  if script == nil then
    local objectName = self:GetItemNameSequence()
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.content_food:AddComponent(UIHeroAdvanceListRow, objectName)
  end
  script:SetActive(true)
  script:SetData(dt, BindCallback(self, self.OnCellClick), self.pointer, self.showAdvanceParticle, self.newHeroes, nil, nil, index)
  return item
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.dataList then
    return nil
  end
  local dt = self.dataList[index]
  if type(dt) == "number" then
    local item = loopScroll:NewListViewItem("TitleLine")
    local script = self.content:GetComponent(item.gameObject.name, UIHeroAdvanceListTitleLine)
    if script == nil then
      local objectName = self:GetItemNameSequence()
      item.gameObject.name = objectName
      if not item.IsInitHandlerCalled then
        item.IsInitHandlerCalled = true
      end
      script = self.content:AddComponent(UIHeroAdvanceListTitleLine, objectName)
    end
    script:SetActive(true)
    script:SetData(dt)
    return item
  end
  local item = loopScroll:NewListViewItem("HeroRow")
  local script = self.content:GetComponent(item.gameObject.name, UIHeroAdvanceListRow)
  if script == nil then
    local objectName = self:GetItemNameSequence()
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.content:AddComponent(UIHeroAdvanceListRow, objectName)
  end
  script:SetActive(true)
  script:SetData(dt, BindCallback(self, self.OnCellClick), self.pointer, self.newHeroes, self.showAdvanceParticle, self.maxMasterAdvanceRarity, index)
  return item
end

local function OnCellClick(self, trans, heroUuid)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  local fromType = UIHeroInfoView.FromType.HeroList
  local isArrow
  if self.view.ctrl:GetArrow() == ArrowTypeHero.LvUpHero then
    isArrow = 1
    self.view.ctrl:SetArrow()
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroInfo, {anim = false}, fromType, heroUuid, self.pureDataList, nil, nil, isArrow)
end

local function ComponentDestroy(self)
  self.tabCamps = nil
  self.scroll_view_hero = nil
  self.objHero = nil
  self.imgQualityBg = nil
  self.imgCamp = nil
  self.textHeroName = nil
  self.textHeroNickName = nil
  self.btnAdvance = nil
  self.textAdvance_shadow = nil
  self.coreHeroSlot = nil
  self.consumeObjList = nil
  self.tabCamps = nil
  self.redPot = nil
  if self.openDelayTimer ~= nil then
    self.openDelayTimer:Stop()
    self.openDelayTimer = nil
  end
end

local function OnSwitchCamp(self, camp)
  if HeroAdvanceController:GetInstance():GetAdvanceHeroUuid() ~= nil then
    self:OnCancelCore()
  end
  for k, tab in pairs(self.tabCamps) do
    tab.transform:Find("selected").gameObject:SetActive(k == camp)
    tab.transform:Find("normal").gameObject:SetActive(k ~= camp)
  end
  self.selectCamp = camp
  self:ResetRedPoint()
  self:ShowHeroScroll(true)
end

local function OnBtnAdvanceClick(self)
  if not HeroAdvanceController:GetInstance():IsConsumeFull() then
    return
  end
  
  local function Confirm()
    local coreHeroUuid = HeroAdvanceController:GetInstance():GetAdvanceHeroUuid()
    local consumeMap = HeroAdvanceController:GetInstance():GetCurConsumeMap()
    local data = DataCenter.HeroDataManager:GetHeroByUuid(coreHeroUuid)
    if not data.isMaster then
      SFSNetwork.SendMessage(MsgDefines.HeroAdvance, coreHeroUuid, table.values(consumeMap))
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroAdvanceDetail, function()
      local coreHeroUuid = HeroAdvanceController:GetInstance():GetAdvanceHeroUuid()
      local consumeMap = HeroAdvanceController:GetInstance():GetCurConsumeMap()
      SFSNetwork.SendMessage(MsgDefines.HeroAdvance, coreHeroUuid, table.values(consumeMap))
    end)
  end
  
  local function OptimalCheck()
    local coreHeroUuid = HeroAdvanceController:GetInstance():GetAdvanceHeroUuid()
    local coreHeroData = DataCenter.HeroDataManager:GetHeroByUuid(coreHeroUuid)
    local rarity = coreHeroData.rarity
    local nextQuality = coreHeroData.quality + 1
    if rarity ~= HeroUtils.RarityType.S and rarity ~= HeroUtils.RarityType.A then
      Confirm()
      return
    end
    local ret, uuid = DataCenter.HeroDataManager:IsTheOptimalHeroInSameId(coreHeroData)
    if ret then
      Confirm()
      return
    end
    local optimalHeroData = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
    local express1 = rarity == HeroUtils.RarityType.S and optimalHeroData.quality > 6 and 6 < nextQuality
    local express2 = rarity == HeroUtils.RarityType.A and optimalHeroData.quality > 9 and 9 < nextQuality
    if express1 or express2 then
      local heroName = string.format("<color='%s'>%s</color>", HeroUtils.GetRarityColorStr(optimalHeroData.rarity), optimalHeroData:GetName())
      UIUtil.ShowMessage(Localization:GetString("129127", heroName), 1, GameDialogDefine.CONFIRM)
      return
    end
    if optimalHeroData.quality > 5 and 5 < nextQuality then
      local heroName = string.format("<color='%s'>%s</color>", HeroUtils.GetRarityColorStr(optimalHeroData.rarity), optimalHeroData:GetName())
      UIUtil.ShowMessage(Localization:GetString("129126", heroName), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, Confirm)
      return
    end
    Confirm()
  end
  
  local function CheckRarityOfConsume()
    local ret, str = HeroAdvanceController:GetInstance():HasRaritySOrAHeroInConsume()
    if ret then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroAdvanceRarityConfirm, OptimalCheck)
    else
      OptimalCheck()
    end
  end
  
  local ret, _, buildNames = HeroAdvanceController:GetInstance():HasStationedHeroInConsume()
  if ret then
    local buildName = buildNames[1]
    UIUtil.ShowMessage(Localization:GetString("162011", buildName), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, CheckRarityOfConsume)
  else
    CheckRarityOfConsume()
  end
end

local function ShowHeroScroll(self, needReGenerate, newHeroes)
  self.scroll_view_food:SetActive(false)
  self.scroll_view_hero:SetActive(true)
  self.exchangeBtn:SetActive(false)
  self.oneKey:SetActive(true)
  if not needReGenerate then
    return
  end
  newHeroes = newHeroes or {}
  self.newHeroes = newHeroes
  self.showAdvanceParticle = {}
  self.dataList, self.pointer, self.maxMasterAdvanceRarity = self.view.ctrl:GetHeroListByCamp(self.selectCamp, 4, self.isAdvanceGuide, self.advanceGuideQuality)
  local showIndex = 0
  local diffY = 0
  if 0 < table.count(newHeroes) then
    for k, v in ipairs(self.dataList) do
      if type(v) ~= "number" then
        for _, hero in ipairs(v) do
          if newHeroes[hero.uuid] ~= nil then
            showIndex = k - 1
            diffY = 70
            goto lbl_70
          end
        end
      end
    end
  end
  ::lbl_70::
  showIndex = math.max(0, showIndex)
  local dataCount = table.count(self.dataList)
  self:RefreshOneKeyBtn()
  if self.oneKey:GetActive() then
    self.textTip1:SetActive(false)
  else
    self.textTip1:SetActive(true)
  end
  self.scroll_view_hero:SetListItemCount(dataCount, false, false)
  self.scroll_view_hero:MovePanelToItemIndex(showIndex, math.abs(diffY))
end

local function ClearHeroScroll(self)
  self.content:RemoveComponents(UIHeroAdvanceListRow)
  self.content:RemoveComponents(UIHeroAdvanceListTitleLine)
  self.scroll_view_hero:ClearAllItems()
end

local function ShowFoodScroll(self)
  self.scroll_view_hero:SetActive(false)
  self.scroll_view_food:SetActive(true)
  self.oneKey:SetActive(false)
  self:RefreshExchangeBtn()
  self.dogFoodsList, self.minRarity = self.view.ctrl:GetDogFoods(4)
  local foodsCount = table.count(self.dogFoodsList)
  self.scroll_view_food:SetListItemCount(foodsCount, false, false)
  self.scroll_view_food:RefreshAllShownItem()
end

local function RefreshExchangeBtn(self)
  local coreHeroData = HeroAdvanceController:GetInstance():GetAdvanceHeroData()
  if coreHeroData == nil or coreHeroData.rarity ~= HeroUtils.RarityType.S then
    self.exchangeBtn:SetActive(false)
    return
  end
  local goodsList = DataCenter.CommonShopManager:GetGoodsListByShopType(CommonShopType.HeroReset)
  local isInShop = false
  if goodsList ~= nil and coreHeroData ~= nil then
    for _, good in ipairs(goodsList) do
      if not string.IsNullOrEmpty(good.hero) and toInt(good.hero) == coreHeroData.heroId then
        isInShop = true
        break
      end
    end
  end
  if not isInShop then
    self.exchangeBtn:SetActive(false)
    return
  end
  local isEmpty = true
  local type99Items = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_99)
  for _, v in ipairs(type99Items) do
    if toInt(v.para2) == coreHeroData.heroId then
      local count = DataCenter.ItemData:GetItemCount(v.id)
      self.exchangeNum:SetText(string.GetFormattedSeperatorNum(count))
      self.exchangeIcon:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(tonumber(v.id)))
      isEmpty = false
      break
    end
  end
  if coreHeroData == nil then
    isEmpty = true
  end
  self.exchangeBtn:SetActive(not isEmpty)
end

local function ClearFoodScroll(self)
  self.content_food:RemoveComponents(UIHeroAdvanceListRow)
  self.content_food:RemoveComponents(UIHeroAdvanceListTitleLine)
  self.scroll_view_food:ClearAllItems()
end

local function DataDefine(self)
  self.selectCamp = 2
  self.newHeroes = {}
  self.showAdvanceParticle = {}
  self.isAdvanceGuide = false
  self.advanceGuideQuality = nil
  self:ResetRedPoint()
end

local function DataDestroy(self)
  self.selectCamp = nil
  self.isAdvanceGuide = false
  self.advanceGuideQuality = nil
  self.curSelectCell = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  HeroAdvanceController:GetInstance():SetAdvanceHeroUuid(nil)
  local camp = self:GetDefaultCamp()
  self:OnSwitchCamp(camp)
  self.objHero:SetActive(false)
  self.view.modelViewer:ShowEmptyScene()
  self.btnAdvance:SetActive(false)
  if self.oneKey:GetActive() then
    self.textTip1:SetActive(false)
  else
    self.textTip1:SetActive(true)
  end
end

local function GetDefaultCamp(self)
  local camp = 2
  local guide = true
  if guide and not HeroAdvanceController:GetInstance():GetRedPointState(camp) then
    for k, v in pairs(self.redPot) do
      if v ~= nil then
        local showStatus = HeroAdvanceController:GetInstance():GetRedPointState(k)
        if showStatus then
          camp = k
          break
        end
      end
    end
  end
  return camp
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetAllCellsDestroy(self)
  self:ClearHeroScroll()
  self:ClearFoodScroll()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroAdvanceSuccess, self.OnHeroAdvanceSuccess)
  self:AddUIListener(EventId.OnAdvanceSuccessClosed, self.OnAdvanceSuccessClosed)
  self:AddUIListener(EventId.OnOneKeyAdvanceSuccess, self.OnOneKeyAdvanceSuccessHandler)
  self:AddUIListener(EventId.OnOneKeyAdvanceSuccessClosed, self.OnOneKeyAdvanceSuccessClosedHandler)
  self:AddUIListener(EventId.HeroAdvanceGuide, self.DoHeroAdvanceGuide)
  self:AddUIListener(EventId.RefreshItems, self.RefreshHeroDebris)
  self:AddUIListener(EventId.OnBuyCommonGoodsSucc, self.OnHeroStationUpdate)
end

local function RefreshHeroDebris(self)
  if self.debrisCell ~= nil and self.debrisCell:GetActive() then
    self.debrisCell:RefreshView()
  end
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshHeroDebris)
  self:RemoveUIListener(EventId.OnBuyCommonGoodsSucc, self.OnHeroStationUpdate)
  self:RemoveUIListener(EventId.HeroAdvanceSuccess, self.OnHeroAdvanceSuccess)
  self:RemoveUIListener(EventId.OnAdvanceSuccessClosed, self.OnAdvanceSuccessClosed)
  self:RemoveUIListener(EventId.OnOneKeyAdvanceSuccess, self.OnOneKeyAdvanceSuccessHandler)
  self:RemoveUIListener(EventId.OnOneKeyAdvanceSuccessClosed, self.OnOneKeyAdvanceSuccessClosedHandler)
  self:RemoveUIListener(EventId.HeroAdvanceGuide, self.DoHeroAdvanceGuide)
  base.OnRemoveListener(self)
end

local function OnHeroStationUpdate(self)
  if self.scroll_view_food:GetActive() then
    self:ShowFoodScroll()
  end
end

local function RefreshOneKeyBtn(self)
  self.oneKeyConfig:SetActive(self:CheckToggleIsOpen())
end

local function UpdateHeroDisplay(self)
  local coreHeroData = HeroAdvanceController:GetInstance():GetAdvanceHeroData()
  local isEmpty = coreHeroData == nil
  self.objHero:SetActive(not isEmpty)
  if isEmpty then
    self.view.modelViewer:ShowEmptyScene()
    self:RefreshOneKeyBtn()
    self.textTip1:SetLocalText(129124)
    self.btnAdvance:SetActive(false)
    if self.oneKey:GetActive() then
      self.textTip1:SetActive(false)
    else
      self.textTip1:SetActive(true)
    end
    return
  end
  local curAdvanceUuid = coreHeroData.uuid
  self.imgQualityBg:LoadSprite(HeroUtils.GetQualityBgPath(coreHeroData.quality))
  self.imgCamp:LoadSprite(HeroUtils.GetCampIconPath(coreHeroData.camp))
  self.textHeroName:SetLocalText(coreHeroData.config.name)
  self.textHeroNickName:SetLocalText(coreHeroData.config.desc)
  self.nodeStarBox:SetActive(coreHeroData.quality > HeroUtils.HeroColorCount)
  if coreHeroData.quality > HeroUtils.HeroColorCount then
    for i = 1, HeroUtils.HeroStarMax do
      local star = self.nodeStarBox.transform:Find("star" .. i)
      star.gameObject:SetActive(coreHeroData.quality >= HeroUtils.HeroColorCount + i)
    end
  end
  self.coreHeroSlot:SetData(curAdvanceUuid)
  self.coreHeroSlot:SetCampActive(false)
  local consumeDataMap = DeepCopy(HeroAdvanceController:GetInstance():GetCurConsumeMap())
  local requireNum = HeroAdvanceController:GetInstance():GetCurAdvanceRequireNum()
  local consume = coreHeroData:GetAdvanceConsume()
  local sameHeroQuality, sameHeroNum = consume:GetConditionByType(HeroAdvanceConsumeType.ConsumeType_Same_Hero)
  local sameCampQuality, sameCampNum = consume:GetConditionByType(HeroAdvanceConsumeType.ConsumeType_Same_Camp)
  sameHeroNum = sameHeroNum or 0
  sameCampNum = sameCampNum or 0
  for k = 1, requireNum do
    local slot = self.consumeObjList[k]
    if k <= sameHeroNum then
      slot:SetData(consumeDataMap[k], HeroAdvanceConsumeType.ConsumeType_Same_Hero, sameHeroQuality)
    else
      slot:SetData(consumeDataMap[k], HeroAdvanceConsumeType.ConsumeType_Same_Camp, sameCampQuality)
    end
    slot:SetActive(true)
  end
  for k = requireNum + 1, HeroUtils.ConsumeSlotMax do
    self.consumeObjList[k]:SetActive(false)
  end
  local isFull = HeroAdvanceController:GetInstance():IsConsumeFull()
  self.btnAdvance:SetActive(isFull)
  self.textTip1:SetActive(not isFull)
  self.textTip1:SetLocalText(isEmpty and 129124 or 129130)
  UIGray.SetGray(self.btnAdvance.transform, not isFull, isFull)
  self.textAdvance_shadow:SetAllColor(not isFull and YellowBtnShadowGrayColor or GreenBtnShadowLightColor)
  if self.openDelayTimer ~= nil then
    self.openDelayTimer:Stop()
    self.openDelayTimer = nil
  end
  if isFull and coreHeroData.isMaster then
    self.btnAdvance:SetActive(false)
    self.openDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroAdvanceSuccess, HeroAdvanceController:GetInstance():GetAdvanceHeroUuid())
      self.view:OnAdvanceSuccessShown()
      self.objHero:SetActive(false)
      self:HideAdvanceHeroHoleImg()
      if self.openDelayTimer ~= nil then
        self.openDelayTimer:Stop()
        self.openDelayTimer = nil
      end
    end, 0.6)
  end
end

local function OnHeroCellClick(self, trans, heroUuid)
end

local function OnSelectCore(self, heroUuid)
  HeroAdvanceController:GetInstance():SetAdvanceHeroUuid(heroUuid)
  self.newHeroes = {}
  self.showAdvanceParticle = {}
  EventManager:GetInstance():Broadcast(EventId.HideAdvanceNew)
  self:UpdateHeroDisplay()
  local coreHeroData = HeroAdvanceController:GetInstance():GetAdvanceHeroData()
  self.view.modelViewer:SetHeroId(coreHeroData.heroId, false)
  local debrisIds = HeroUtils.GetHeroDebrisIds()
  self:ShowFoodScroll()
end

local function OnCancelCore(self)
  HeroAdvanceController:GetInstance():SetAdvanceHeroUuid(nil)
  self:UpdateHeroDisplay()
  self:ShowHeroScroll(false)
end

local function OnToggleDogFood(self, dogFoodUuid)
  HeroAdvanceController:GetInstance():OnToggleDogFood(dogFoodUuid)
  self.scroll_view_food:RefreshAllShownItem()
  self:UpdateHeroDisplay()
end

local function OnHeroAdvanceSuccess(self, message)
  local coreHeroUuid
  if message ~= nil and message.heroInfo ~= nil then
    coreHeroUuid = message.heroInfo.uuid
  end
  local newHeroes = {}
  local data = DataCenter.HeroDataManager:GetHeroByUuid(coreHeroUuid)
  if coreHeroUuid ~= nil then
    newHeroes[coreHeroUuid] = 1
  end
  self:ShowHeroScroll(true, newHeroes)
  if data ~= nil and not data.isMaster then
    self:UpdateHeroDisplay()
    self:ResetRedPoint()
  else
    self.objHero:SetActive(false)
    self.view.modelViewer:ShowHeroAdvanceEffect()
    self:ResetRedPoint()
  end
end

local function OnAdvanceSuccessClosed(self)
  local coreHeroData = HeroAdvanceController:GetInstance():GetAdvanceHeroData()
  self:UpdateHeroDisplay()
  if coreHeroData ~= nil then
    self.scroll_view_food:RefreshAllShownItem()
  else
    self:ShowHeroScroll(false)
    self.view.modelViewer:HideHeroAdvanceEffect()
    self:ResetRedPoint()
  end
end

local function OnOneKeyAdvanceSuccessHandler(self, message)
  local newHeroes = {}
  if message.heros ~= nil then
    table.walk(message.heros, function(k, v)
      newHeroes[v.uuid] = 1
    end)
  end
  self.view.modelViewer:HideHeroAdvanceEffect()
  self:ShowHeroScroll(true, newHeroes)
  self:UpdateHeroDisplay()
  self:ResetRedPoint()
  self.rightPanel:SetActive(false)
end

local function OnOneKeyAdvanceSuccessClosedHandler(self)
  self.rightPanel:SetActive(true)
end

local function ResetRedPoint(self)
  if self.redPot == nil then
    return
  end
  for k, v in pairs(self.redPot) do
    if v ~= nil then
      local showStatus = HeroAdvanceController:GetInstance():GetRedPointState(k)
      v:SetActive(showStatus)
    end
  end
end

local function GetItemNameSequence(self)
  NameCount = NameCount + 1
  return tostring(NameCount)
end

local function GetEat(self, heroData, currentQuality, toQuality, dogFoodsList, eatList, tmpEatList, exceptList, tmpExceptList)
  if currentQuality == toQuality then
    return true
  end
  local advanceData = self:GetAdvanceReqData(HeroUtils.GetConfigQuality(heroData.heroId, currentQuality))
  tmpExceptList[heroData.uuid] = 1
  if advanceData ~= nil then
    local sameHeroQuality, sameHeroNum = advanceData:GetConditionByType(HeroAdvanceConsumeType.ConsumeType_Same_Hero)
    local sameCampQuality, sameCampNum = advanceData:GetConditionByType(HeroAdvanceConsumeType.ConsumeType_Same_Camp)
    sameHeroNum = sameHeroNum or 0
    sameCampNum = sameCampNum or 0
    local currentSameHeroNum = 0
    local currentSameCampNum = 0
    for _, v in ipairs(dogFoodsList) do
      if currentSameHeroNum == sameHeroNum and currentSameCampNum == sameCampNum then
        break
      end
      if eatList[v.uuid] == nil and tmpEatList[v.uuid] == nil and exceptList[v.uuid] == nil and tmpExceptList[v.uuid] == nil then
        if sameHeroNum > currentSameHeroNum and heroData.heroId == v.heroId and sameHeroQuality == v.quality then
          tmpEatList[v.uuid] = 1
          currentSameHeroNum = currentSameHeroNum + 1
        else
          if sameCampNum > currentSameCampNum and sameCampQuality == v.quality then
            tmpEatList[v.uuid] = 1
            currentSameCampNum = currentSameCampNum + 1
          else
          end
        end
      end
    end
    if currentSameHeroNum == sameHeroNum and currentSameCampNum == sameCampNum then
      return self:GetEat(heroData, currentQuality + 1, toQuality, dogFoodsList, eatList, tmpEatList, exceptList, tmpExceptList)
    else
      for _, v in ipairs(dogFoodsList) do
        if currentSameHeroNum == sameHeroNum and currentSameCampNum == sameCampNum then
          break
        end
        if eatList[v.uuid] == nil and tmpEatList[v.uuid] == nil and exceptList[v.uuid] == nil and tmpExceptList[v.uuid] == nil then
          if sameHeroNum > currentSameHeroNum and heroData.heroId == v.heroId and sameHeroQuality > v.quality then
            local findResult = self:GetEat(v, v.quality, sameHeroQuality, dogFoodsList, eatList, tmpEatList, exceptList, tmpExceptList)
            if findResult == true then
              currentSameHeroNum = currentSameHeroNum + 1
              tmpEatList[v.uuid] = 1
            end
          end
          if sameCampNum > currentSameCampNum and sameCampQuality > v.quality then
            local findResult = self:GetEat(v, v.quality, sameCampQuality, dogFoodsList, eatList, tmpEatList, exceptList, tmpExceptList)
            if findResult == true then
              currentSameCampNum = currentSameCampNum + 1
              tmpEatList[v.uuid] = 1
            end
          end
        end
      end
      if sameHeroNum > currentSameHeroNum or sameCampNum > currentSameCampNum then
        return false
      else
        return self:GetEat(heroData, currentQuality + 1, toQuality, dogFoodsList, eatList, tmpEatList, exceptList, tmpExceptList)
      end
    end
  end
  return false
end

local function OnOneKeyBtnAdvanceClick(self, quality)
  local result = {}
  local heroes1 = {}
  local heroes2 = {}
  local allHeroes = DataCenter.HeroDataManager:GetAllHeroList()
  local heroes = table.values(allHeroes)
  for _, heroData in pairs(heroes) do
    if heroData.camp == self.selectCamp and not heroData.isMaster and heroData.rarity ~= HeroUtils.RarityType.S and heroData.rarity ~= HeroUtils.RarityType.A and (self.blueHero or heroData.rarity ~= HeroUtils.RarityType.B) then
      if quality > heroData.quality and quality <= heroData:GetMaxQuality() then
        table.insert(heroes1, heroData)
      end
      table.insert(heroes2, heroData)
    end
  end
  table.sort(heroes1, function(k, v)
    if k.rarity ~= v.rarity then
      return k.rarity < v.rarity
    end
    if k.quality ~= v.quality then
      return k.quality > v.quality
    end
  end)
  table.sort(heroes2, function(k, v)
    if k.rarity ~= v.rarity then
      return k.rarity > v.rarity
    end
    if k.quality ~= v.quality then
      return k.quality > v.quality
    end
  end)
  local index = 1
  local total = #heroes1
  local eatList = {}
  local exceptList = {}
  local tmpExceptList = {}
  local tmpEatList = {}
  local findNum = 0
  while index <= total do
    local data = heroes1[index]
    tmpExceptList = {}
    tmpEatList = {}
    if exceptList[data.uuid] == nil then
      local eatResult = self:GetEat(data, data.quality, quality, heroes2, eatList, tmpEatList, exceptList, tmpExceptList)
      if eatResult == true then
        table.walk(tmpEatList, function(k, v)
          eatList[k] = 1
          exceptList[k] = 1
        end)
        result[data.uuid] = tmpEatList
        exceptList[data.uuid] = 1
        findNum = findNum + 1
      end
    end
    index = index + 1
  end
  if 0 < table.count(result) then
    local panelStr = ""
    if self.blueHero then
      panelStr = Localization:GetString("129239", Mathf.Round((quality - 1) / 2))
    else
      panelStr = Localization:GetString("129238", Mathf.Round((quality - 1) / 2))
    end
    UIUtil.ShowMessage(panelStr, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.HeroAdvanceMulti, quality, result)
    end)
  else
    UIUtil.ShowTipsId(129235)
  end
end

local function GetAdvanceReqData(self, configQuality)
  if AdvanceReqDatas[configQuality] ~= nil then
    return AdvanceReqDatas[configQuality]
  end
  local data = AdvanceReqData.New(configQuality)
  AdvanceReqDatas[configQuality] = data
  return data
end

local function OneKeyConfigClick(self)
  self.choosePanel:SetActive(not self.choosePanel:GetActive())
end

local function ToggleControlBorS(self, selectToggleIndex, quality)
  local flag = self:CheckToggleIsOpen(selectToggleIndex)
  if not flag then
    return
  end
  self.oneKeyQuality = quality
  self.currentToggle = selectToggleIndex
end

local function CheckToggleIsOpen(self)
  local effect = Mathf.Round(LuaEntry.Effect:GetGameEffect(EffectDefine.HERO_ONE_KEY_OPEN))
  return 0 < effect
end

local function ShowOneKeyCondition(self)
  local allVip = DataCenter.VIPTemplateManager:GetAllTemplate()
  for _, k in pairs(allVip) do
    for _, v in ipairs(k.display) do
      if tonumber(v) == EffectDefine.HERO_ONE_KEY_OPEN then
        UIUtil.ShowMessage(Localization:GetString("129248", tostring(k.level)), 2, "110003", GameDialogDefine.CANCEL, function()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIVip, {anim = true, hideTop = true}, k.level)
        end)
        return
      end
    end
  end
end

local function ShowFirstAdvanceHeroHoleImg(self)
  local btn = self:GetGuideCoreBtn()
  if btn ~= nil then
    self.holeImg:SetActive(true)
    self.holeImg.transform:Set_position(btn.transform:Get_position())
    self.maskImg.transform:Set_position(ResetPosition)
  end
end

local function ShowFirstDogFoodHoleImg(self)
  local btn = self:GetGuideDogFoodBtn()
  if btn ~= nil then
    self.holeImg:SetActive(true)
    self.holeImg.transform:Set_position(btn.transform:Get_position())
    self.maskImg.transform:Set_position(ResetPosition)
  end
end

local function GetGuideCoreBtn(self)
  local curAdvanceUuid = HeroAdvanceController:GetInstance():GetAdvanceHeroUuid()
  if curAdvanceUuid ~= nil and curAdvanceUuid ~= 0 then
    return nil
  end
  local components = self.content:GetComponents(UIHeroAdvanceListRow)
  local btn
  table.sort(components, function(k, v)
    return toInt(k.index) < toInt(v.index)
  end)
  if components then
    for _, v in pairs(components) do
      local tmpBtn = v:GetHeroCellAdvanceGuideBtn(self.pointer)
      if tmpBtn ~= nil then
        btn = tmpBtn
        break
      end
    end
  end
  return btn
end

local function GetGuideDogFoodBtn(self)
  local curAdvanceUuid = HeroAdvanceController:GetInstance():GetAdvanceHeroUuid()
  if curAdvanceUuid == nil or curAdvanceUuid == 0 then
    return nil
  end
  local components = self.content_food:GetComponents(UIHeroAdvanceListRow)
  local btn
  table.sort(components, function(k, v)
    return toInt(k.index) < toInt(v.index)
  end)
  if components then
    for _, v in pairs(components) do
      local tmpBtn = v:GetDogFoodGuideBtn(self.pointer)
      if tmpBtn ~= nil then
        btn = tmpBtn
        break
      end
    end
  end
  return btn
end

local function HideAdvanceHeroHoleImg(self)
  self.holeImg:SetActive(false)
end

local function DoHeroAdvanceGuide(self, param)
  local eventType = param.eventType
  local quality = param.quality
  if eventType == HeroAdvanceGuideSignalType.Enter then
    self.isAdvanceGuide = true
    self.advanceGuideQuality = quality
    local camp = self:GetDefaultCamp()
    if self.selectCamp == camp then
      self:ShowHeroScroll(true)
    else
      self:OnSwitchCamp(camp)
    end
  elseif eventType == HeroAdvanceGuideSignalType.ShowMainHeroBlack then
    self:ShowFirstAdvanceHeroHoleImg()
  elseif eventType == HeroAdvanceGuideSignalType.HideMainHeroBlack then
    self.isAdvanceGuide = false
    self.advanceGuideQuality = nil
    self:HideAdvanceHeroHoleImg()
  elseif eventType == HeroAdvanceGuideSignalType.ShowSubHeroBlack then
    self:ShowFirstDogFoodHoleImg()
  elseif eventType == HeroAdvanceGuideSignalType.HideSubHeroBlack then
    self:HideAdvanceHeroHoleImg()
  end
end

local function OnExchangeClick(self)
  local goodsList = DataCenter.CommonShopManager:GetGoodsListByShopType(CommonShopType.HeroReset)
  local coreHeroData = HeroAdvanceController:GetInstance():GetAdvanceHeroData()
  if goodsList ~= nil and coreHeroData ~= nil then
    for _, good in ipairs(goodsList) do
      if not string.IsNullOrEmpty(good.hero) and toInt(good.hero) == coreHeroData.heroId then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroExchange, {anim = true}, good)
        break
      end
    end
  end
end

UIHeroPageAdvance.GetGuideCoreBtn = GetGuideCoreBtn
UIHeroPageAdvance.GetGuideDogFoodBtn = GetGuideDogFoodBtn
UIHeroPageAdvance.OnCreate = OnCreate
UIHeroPageAdvance.OnDestroy = OnDestroy
UIHeroPageAdvance.OnEnable = OnEnable
UIHeroPageAdvance.OnDisable = OnDisable
UIHeroPageAdvance.OnAddListener = OnAddListener
UIHeroPageAdvance.OnRemoveListener = OnRemoveListener
UIHeroPageAdvance.ComponentDefine = ComponentDefine
UIHeroPageAdvance.ComponentDestroy = ComponentDestroy
UIHeroPageAdvance.DataDefine = DataDefine
UIHeroPageAdvance.DataDestroy = DataDestroy
UIHeroPageAdvance.SetAllCellsDestroy = SetAllCellsDestroy
UIHeroPageAdvance.ShowOneKeyCondition = ShowOneKeyCondition
UIHeroPageAdvance.ShowHeroScroll = ShowHeroScroll
UIHeroPageAdvance.ClearHeroScroll = ClearHeroScroll
UIHeroPageAdvance.ShowFoodScroll = ShowFoodScroll
UIHeroPageAdvance.ClearFoodScroll = ClearFoodScroll
UIHeroPageAdvance.GetEat = GetEat
UIHeroPageAdvance.OnSwitchCamp = OnSwitchCamp
UIHeroPageAdvance.OnBtnAdvanceClick = OnBtnAdvanceClick
UIHeroPageAdvance.UpdateHeroDisplay = UpdateHeroDisplay
UIHeroPageAdvance.OnHeroCellClick = OnHeroCellClick
UIHeroPageAdvance.OnSelectCore = OnSelectCore
UIHeroPageAdvance.OnCancelCore = OnCancelCore
UIHeroPageAdvance.OnToggleDogFood = OnToggleDogFood
UIHeroPageAdvance.OnHeroAdvanceSuccess = OnHeroAdvanceSuccess
UIHeroPageAdvance.OnAdvanceSuccessClosed = OnAdvanceSuccessClosed
UIHeroPageAdvance.ResetRedPoint = ResetRedPoint
UIHeroPageAdvance.OnGetItemByIndex = OnGetItemByIndex
UIHeroPageAdvance.OnGetFoodItemByIndex = OnGetFoodItemByIndex
UIHeroPageAdvance.GetItemNameSequence = GetItemNameSequence
UIHeroPageAdvance.OnCellClick = OnCellClick
UIHeroPageAdvance.OnOneKeyBtnAdvanceClick = OnOneKeyBtnAdvanceClick
UIHeroPageAdvance.RefreshOneKeyBtn = RefreshOneKeyBtn
UIHeroPageAdvance.OnOneKeyAdvanceSuccessHandler = OnOneKeyAdvanceSuccessHandler
UIHeroPageAdvance.OnOneKeyAdvanceSuccessClosedHandler = OnOneKeyAdvanceSuccessClosedHandler
UIHeroPageAdvance.GetAdvanceReqData = GetAdvanceReqData
UIHeroPageAdvance.OneKeyConfigClick = OneKeyConfigClick
UIHeroPageAdvance.ToggleControlBorS = ToggleControlBorS
UIHeroPageAdvance.CheckToggleIsOpen = CheckToggleIsOpen
UIHeroPageAdvance.ShowFirstAdvanceHeroHoleImg = ShowFirstAdvanceHeroHoleImg
UIHeroPageAdvance.HideAdvanceHeroHoleImg = HideAdvanceHeroHoleImg
UIHeroPageAdvance.GetDefaultCamp = GetDefaultCamp
UIHeroPageAdvance.ShowFirstDogFoodHoleImg = ShowFirstDogFoodHoleImg
UIHeroPageAdvance.DoHeroAdvanceGuide = DoHeroAdvanceGuide
UIHeroPageAdvance.RefreshHeroDebris = RefreshHeroDebris
UIHeroPageAdvance.OnHeroStationUpdate = OnHeroStationUpdate
UIHeroPageAdvance.RefreshExchangeBtn = RefreshExchangeBtn
UIHeroPageAdvance.OnExchangeClick = OnExchangeClick
return UIHeroPageAdvance
