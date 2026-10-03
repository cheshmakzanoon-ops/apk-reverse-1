local base = UIBaseContainer
local UIActCookFood = BaseClass("UIActCookFood", base)
local Localization = CS.GameEntry.Localization
local Camera = CS.UnityEngine.Camera
local UIActCookFoofMenuTip = require("UI.LWSeason.UILWSingleActivityContainer.Component.UIActCookFoofMenuTip")
local CommonTexImg = require("UI.LWSeason.UILWSingleActivityContainer.Component.CommonTexImg")
local ActOwnFoodSlot = require("UI.LWSeason.UILWSingleActivityContainer.Component.ActOwnFoodSlot")
local ActUseFoodItem = require("UI.LWSeason.UILWSingleActivityContainer.Component.ActUseFoodItem")
local title_path = "content/title"
local countdown_path = "content/countdown"
local infoBtn_path = "content/DesBtn"
local rewardBtn_path = "content/rightTop/RewardBtn/RewardBtn"
local exChangeBtn_path = "content/rightTop/exChangeBtn/exChangeBtn"
local ownFoodParent_path = "content/bottom/ownFood"
local useFoodParent_path = "content/bottom/useFood"
local cookBtn_path = "DoBtn"
local menuTip_path = "content/menuTip"
local menuBtn_path = "content/rightTop/menuBtn/menuBtn"
local plotFoodIcon_path = "content/bottom/plot/plotFoodIcon"
local plotFoodName_path = "content/bottom/plot/plotFoodName"
local plotDes_path = "content/bottom/plot/plotDes"
local uiAnimator_path = ""
local renderTex_path = "content/bottom/CommonTexImg"
local plotObj_path = "content/bottom/plot"
local redPoint_path = "content/rightTop/menuBtn/menuBtn/RedPoint"
local clickDotBtn_path = "content/bottom/CommonTexImg/clickDog"
local ownFoodSlotItem_path = {
  "content/bottom/ownFood/ActOwnFoodSlot1",
  "content/bottom/ownFood/ActOwnFoodSlot2",
  "content/bottom/ownFood/ActOwnFoodSlot3",
  "content/bottom/ownFood/ActOwnFoodSlot4"
}
local useFoodItem_path = {
  "content/bottom/useFood/ActUseFoodItem1",
  "content/bottom/useFood/ActUseFoodItem2",
  "content/bottom/useFood/ActUseFoodItem3",
  "content/bottom/useFood/ActUseFoodItem4"
}
local ITEM_COUNT = 4

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
  self.title = self:AddComponent(UIText, title_path)
  self.countdown = self:AddComponent(UIText, countdown_path)
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.rewardBtn = self:AddComponent(UIButton, rewardBtn_path)
  self.exChangeBtn = self:AddComponent(UIButton, exChangeBtn_path)
  self.ownFoodParent = self:AddComponent(UIBaseContainer, ownFoodParent_path)
  self.useFoodParent = self:AddComponent(UIBaseContainer, useFoodParent_path)
  self.cookBtn = self:AddComponent(UIButton, cookBtn_path)
  self.menuTip = self:AddComponent(UIActCookFoofMenuTip, menuTip_path)
  self.menuBtn = self:AddComponent(UIButton, menuBtn_path)
  self.plotFoodIcon = self:AddComponent(UIImage, plotFoodIcon_path)
  self.plotFoodName = self:AddComponent(UIText, plotFoodName_path)
  self.plotDes = self:AddComponent(UIText, plotDes_path)
  self.uiAnimator = self:AddComponent(UIAnimator, uiAnimator_path)
  self.renderTex = self:AddComponent(CommonTexImg, renderTex_path)
  self.plotObj = self:AddComponent(UIBaseContainer, plotObj_path)
  self.redPoint = self:AddComponent(UIBaseContainer, redPoint_path)
  self.clickDotBtn = self:AddComponent(UIButton, clickDotBtn_path)
  self.ownFoodSlotItem = {
    self:AddComponent(ActOwnFoodSlot, ownFoodSlotItem_path[1]),
    self:AddComponent(ActOwnFoodSlot, ownFoodSlotItem_path[2]),
    self:AddComponent(ActOwnFoodSlot, ownFoodSlotItem_path[3]),
    self:AddComponent(ActOwnFoodSlot, ownFoodSlotItem_path[4])
  }
  self.useFoodItem = {
    self:AddComponent(ActUseFoodItem, useFoodItem_path[1]),
    self:AddComponent(ActUseFoodItem, useFoodItem_path[2]),
    self:AddComponent(ActUseFoodItem, useFoodItem_path[3]),
    self:AddComponent(ActUseFoodItem, useFoodItem_path[4])
  }
  local initData = {}
  initData.prefabPath = "Assets/Main/Prefabs/UI/UIHero/New/HeroPreview/DisplayScenePetFeedScene.prefab"
  
  function initData.loadFinish()
    self:RenderTextureLoadFinish()
  end
  
  self.renderTex:InitData(initData)
  self.infoBtn:SetSafeClickMode(true)
  self.rewardBtn:SetSafeClickMode(true)
  self.exChangeBtn:SetSafeClickMode(true)
  self.cookBtn:SetSafeClickMode(true)
  self.cookBtn:SetSafeClickModeTime(1)
  self.infoBtn:SetOnClick(function()
    self:InfoBtnClick()
  end)
  self.rewardBtn:SetOnClick(function()
    self:RewardBtnClick()
  end)
  self.exChangeBtn:SetOnClick(function()
    self:ExchangeBtnClick()
  end)
  self.cookBtn:SetOnClick(function()
    self:OnCookBtnClick()
  end)
  self.menuBtn:SetOnClick(function()
    self:OnMenuBtnClick()
  end)
  self.clickDotBtn:SetOnClick(function()
    self:ClickDog()
  end)
  self.menuTip:SetActive(false)
end

local function ComponentDestroy(self)
  self.title = nil
  self.countdown = nil
  self.infoBtn = nil
  self.rewardBtn = nil
  self.exChangeBtn = nil
  self.ownFoodParent = nil
  self.useFoodParent = nil
  self.cookBtn = nil
  self.menuTip = nil
  self.menuBtn = nil
  self.plotFoodIcon = nil
  self.plotFoodName = nil
  self.plotDes = nil
  self.uiAnimator = nil
  self.renderTex = nil
  self.plotObj = nil
  self.redPoint = nil
  self.clickDotBtn = nil
  self.ownFoodSlotItem = nil
  self.useFoodItem = nil
end

function UIActCookFood:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSasonFoodInfoUpdate, self.LWSasonFoodInfoUpdate)
  self:AddUIListener(EventId.LWSasonCookFoodSuccess, self.LWSasonCookFoodSuccess)
  self:AddUIListener(EventId.GF_plot_group_done, self.PlotGroupDone)
  self:AddUIListener(EventId.SCREEN_TOUCH_CLICK_IGNORE_UI, self.OnScreenTouch)
  self:AddUIListener(EventId.SplinterRefreshSelf, self.RefreshItemCount)
  self:AddUIListener(EventId.DispatchTreasureALExchangeSuccess, self.RefreshItemCount)
  self:AddUIListener(EventId.RefreshItems, self.RefreshItemCount)
end

function UIActCookFood:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSasonFoodInfoUpdate, self.LWSasonFoodInfoUpdate)
  self:RemoveUIListener(EventId.LWSasonCookFoodSuccess, self.LWSasonCookFoodSuccess)
  self:RemoveUIListener(EventId.SCREEN_TOUCH_CLICK_IGNORE_UI, self.OnScreenTouch)
  self:RemoveUIListener(EventId.GF_plot_group_done, self.PlotGroupDone)
  self:RemoveUIListener(EventId.SplinterRefreshSelf, self.RefreshItemCount)
  self:RemoveUIListener(EventId.DispatchTreasureALExchangeSuccess, self.RefreshItemCount)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshItemCount)
  base.OnRemoveListener(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.canClick = nil
  self.isPlayingAni = nil
  if self.combineAniDelay then
    self.combineAniDelay:Stop()
  end
  if self.delayAction then
    self.delayAction:Stop()
    self.delayAction = nil
  end
  DataCenter.SeasonFoodActivityDataManager:ResetSeasonFoodCookData()
end

function UIActCookFood:SetData(activityId)
  self.uiAnimator:Play("UIActCookFoodIn")
  self.doneGroupId = nil
  self.activityId = tonumber(activityId)
  if not self.activityId then
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if not self.activityInfo then
    self.cookBtn:SetActive(false)
    return
  end
  self.cookMaxNum = toInt(self.activityInfo.para_2)
  self.cookBtn:SetActive(true)
  self.title:SetText(Localization:GetString(self.activityInfo.name))
  self.finish = true
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.activityInfo.endTime then
    self.countdown:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.activityInfo.endTime - curTime))
    self.finish = false
  end
  local foodItems = self.activityInfo.para
  local data = string.split(foodItems, "|")
  local dataCount = #data
  for i = 1, ITEM_COUNT do
    self.ownFoodSlotItem[i]:SetData(data[i], function(itemId)
      return self:OwnItemClick(itemId)
    end)
    self.useFoodItem[i]:SetData(nil, function(itemId)
      return self:UseItemClick(itemId)
    end)
  end
  self.foodData = DataCenter.SeasonFoodActivityDataManager:GetSeasonFoodData(activityId)
  if self.foodData then
    local menuId = self.foodData.menuId
    self.menuTemplateData = DataCenter.SeasonFoodActivityDataManager:GetSeasonFoodMenuTemplateData(menuId)
    self:RefreshFood()
    self:OpenPlot()
  else
    self.cookBtn:SetActive(false)
    self.plotObj:SetActive(false)
    SFSNetwork.SendMessage(MsgDefines.LWSeasonActivityFoodMenuInfo, tonumber(activityId))
  end
  self:RefreshRedPoint()
end

function UIActCookFood:RefreshFood()
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.menuTemplateData.food_goods)
  if goods then
    self.plotFoodName:SetText(goods:GetName())
    self.plotFoodIcon:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
  end
  local menuData = self.menuTemplateData:GetFoodData()
  local list = {}
  for index, value in ipairs(menuData) do
    list[index] = value
  end
  table.insert(list, self.menuTemplateData.food_goods)
  self.menuTip:SetData(list)
  self.cookBtn:SetActive(self.foodData.num < self.cookMaxNum)
  self.plotObj:SetActive(self.foodData.num < self.cookMaxNum)
  if self.foodData.num < self.cookMaxNum then
    self.renderTex:LoadScene()
    self.renderTex:SetActive(true)
  else
    self.renderTex:SetActive(false)
  end
end

function UIActCookFood:OwnItemClick(itemId)
  if itemId then
    local flag = false
    for i = 1, ITEM_COUNT do
      if self.useFoodItem[i].itemId == nil then
        flag = true
        self.useFoodItem[i]:SetItemId(itemId, true)
        break
      end
    end
    if flag then
      return true
    end
  end
  return false
end

function UIActCookFood:UseItemClick(itemId)
  if itemId then
    local flag = false
    for i = 1, ITEM_COUNT do
      if self.ownFoodSlotItem[i].itemId == itemId then
        self.ownFoodSlotItem[i]:AddCount(1)
        flag = true
        break
      end
    end
    if flag then
      return true
    end
  end
  return false
end

function UIActCookFood:OpenPlot()
  local content
  if self.foodData.num < self.cookMaxNum then
    content = Localization:GetString(self.menuTemplateData.plot1)
  else
    local plotGroup = {
      id = toInt(self.menuTemplateData.plot4),
      plots = {}
    }
    local miss = false
    local plotId = plotGroup.id * 100 + 1
    while not miss do
      local plot = LocalController.instance():getLine(TableName.LW_Plot, plotId)
      if plot == nil then
        miss = true
      else
        table.insert(plotGroup.plots, plot)
      end
      plotId = plotId + 1
    end
    local key = table.randomKey(plotGroup.plots)
    if key ~= nil then
      local plotData = plotGroup.plots[key]
      content = Localization:GetString(plotData.content)
    end
  end
  self.plotDes:SetText(content)
end

function UIActCookFood:Update1000MS()
  if not self.finish then
    local data = self.activityInfo
    local flag = false
    if data then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if data.endTime and curTime < data.endTime then
        self.countdown:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(data.endTime - curTime))
      else
        flag = true
      end
    end
    if flag then
      self.countdown:SetText("")
      self.finish = true
    end
  end
end

function UIActCookFood:LWSasonFoodInfoUpdate()
  self.foodData = DataCenter.SeasonFoodActivityDataManager:GetSeasonFoodData(self.activityId)
  if self.foodData then
    local menuId = self.foodData.menuId
    self.menuTemplateData = DataCenter.SeasonFoodActivityDataManager:GetSeasonFoodMenuTemplateData(menuId)
    self:RefreshFood()
    self:OpenPlot()
    self:RefreshRedPoint()
  else
  end
end

function UIActCookFood:LWSasonCookFoodSuccess()
  self.uiAnimator:Play("UIActCookFoodCombine")
  self.foodData = DataCenter.SeasonFoodActivityDataManager:GetSeasonFoodData(self.activityId)
  if self.foodData.num < self.cookMaxNum then
  end
  if self.foodData then
    local menuId = self.foodData.menuId
    self.menuTemplateData = DataCenter.SeasonFoodActivityDataManager:GetSeasonFoodMenuTemplateData(menuId)
    for i = 1, ITEM_COUNT do
      self.ownFoodSlotItem[i]:RefreshCount()
      self.useFoodItem[i]:SetEmpty()
      self.useFoodItem[i].itemIconAniParent:SetActive(true)
    end
  else
  end
  self.combineAniDelay = TimerManager:GetInstance():DelayInvoke(function()
    self.combineAniDelay = nil
    local successData = DataCenter.SeasonFoodActivityDataManager.curCookSuccessData
    local param = {}
    param.rewardList = {}
    local rewardData = {}
    rewardData.rewardType = RewardType.GOODS
    rewardData.itemId = successData.food
    rewardData.count = 1
    param.rewardList[1] = rewardData
    param.title = Localization:GetString("season_s2_food_activity_48")
    param.clickTip = Localization:GetString("season_s2_food_activity_07")
    
    local function callback()
      local successData = DataCenter.SeasonFoodActivityDataManager.curCookSuccessData
      if successData then
        local group = toInt(self.menuTemplateData.plot2)
        if not successData.matched then
          group = toInt(self.menuTemplateData.plot3)
        end
        self.doneGroupId = group
        EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = group, hideMainUI = false})
      end
    end
    
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageRewardGet, {
      anim = true,
      playEffect = false,
      UIMainAnim = UIMainAnimType.LeftRightBottomHide
    }, param, callback)
  end, 1.3333333333333333)
end

function UIActCookFood:RefreshItemCount()
  for i = 1, ITEM_COUNT do
    self.ownFoodSlotItem[i]:RefreshCount()
    self.useFoodItem[i]:SetEmpty()
    self.useFoodItem[i].itemIconAniParent:SetActive(false)
  end
end

function UIActCookFood:OnCookBtnClick()
  if self.combineAniDelay then
    return
  end
  if self.foodData.num >= self.cookMaxNum then
    Logger.LogError("num: " .. tostring(self.foodData.num) .. ", maxNum : " .. tostring(self.cookMaxNum))
    return
  end
  local items = {}
  local flag = false
  for i = 1, ITEM_COUNT do
    if self.useFoodItem[i].itemId == nil then
      flag = true
      break
    else
      table.insert(items, tonumber(self.useFoodItem[i].itemId))
    end
  end
  if not flag and self.menuTemplateData then
    local dataKey = self.menuTemplateData:GetDataKey()
    table.sort(items, function(a, b)
      return b < a
    end)
    local key = ""
    for index, value in ipairs(items) do
      key = key .. tostring(value)
    end
    SFSNetwork.SendMessage(MsgDefines.LWSeasonActivityFoodMenuCook, self.activityId, items)
  else
    UIUtil.ShowTips(Localization:GetString("season_s2_activity_1000036_tips01"))
  end
end

function UIActCookFood:InfoBtnClick()
  if self.activityInfo ~= nil and self.activityInfo.story ~= nil then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.activityInfo.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function UIActCookFood:RewardBtnClick()
  if self.foodData then
    local menuId = self.foodData.menuId
    self.menuTemplateData = DataCenter.SeasonFoodActivityDataManager:GetSeasonFoodMenuTemplateData(menuId)
    local data = {}
    data.boxList = {}
    local boxData = {
      id = self.menuTemplateData.reward_prefect,
      boxIconPath = "Assets/Main/TextureEx/UIActivityBg/ActDispatchTreasure/FX_WB_xiangzi_cookfood_02.png",
      nameStrId = "season_s2_food_activity_05"
    }
    table.insert(data.boxList, boxData)
    boxData = {
      id = self.menuTemplateData.reward_normal,
      boxIconPath = "Assets/Main/TextureEx/UIActivityBg/ActDispatchTreasure/FX_WB_xiangzi_cookfood_01.png",
      nameStrId = "season_s2_food_activity_06"
    }
    table.insert(data.boxList, boxData)
    data.titleKey = "390334"
    data.desKey = "season_s2_food_activity_04"
    UIManager.Instance:OpenWindow(UIWindowNames.UICommonBoxRewardShow, {anim = true}, data)
  end
end

function UIActCookFood:ExchangeBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISplinterExchange, {anim = true}, SplinterExchangeType.CookingIngredients.Id, 1)
end

function UIActCookFood:PlotGroupDone(groupId)
  if groupId == self.doneGroupId then
    local successData = DataCenter.SeasonFoodActivityDataManager.curCookSuccessData
    if successData then
      DataCenter.RewardManager:ShowCommonReward(successData)
      DataCenter.SeasonFoodActivityDataManager:ResetSeasonFoodCookData()
      self.doneGroupId = nil
    end
    if self.foodData then
      self:RefreshFood()
      self:OpenPlot()
    end
  end
end

function UIActCookFood:OnMenuBtnClick()
  self.showFrame = Time.frameCount
  self.menuTip:SetActive(true)
  local strKey = "UIActCookFood_Menu_" .. LuaEntry.Player.uid
  local today = UITimeManager:GetInstance():GetDayOfYear(UITimeManager:GetInstance():GetServerTime())
  CS.GameEntry.Setting:SetInt(strKey, today)
  self:RefreshRedPoint()
end

function UIActCookFood:OnScreenTouch(info)
  if self.menuTip:GetActive() then
    if self.showFrame == Time.frameCount then
      return
    end
    if self.menuTip:CheckRect(info) then
      return
    end
    self.menuTip:SetActive(false)
  end
end

function UIActCookFood:RenderTextureLoadFinish()
  local cam = self.renderTex.sceneLoaded.gameObject.transform:Find("Camera"):GetComponentInChildren(typeof(Camera))
  self.renderTex:OnRenderTexture(cam)
  self.renderTex:Play("Default")
  self.canClick = true
  self.isPlayingAni = false
end

function UIActCookFood:ClickDog()
  if self.canClick and not self.isPlayingAni then
    self.isPlayingAni = true
    self.renderTex:Play("chongwugou_happy")
    self.renderTex:PlayQueued("Default")
    self.delayAction = TimerManager:GetInstance():DelayInvoke(function()
      self.isPlayingAni = false
      self.delayAction = nil
    end, 2.4)
  end
end

function UIActCookFood:RefreshRedPoint()
  if self.foodData then
    local strKey = "UIActCookFood_Menu_" .. LuaEntry.Player.uid
    local today = UITimeManager:GetInstance():GetDayOfYear(UITimeManager:GetInstance():GetServerTime())
    local localData = CS.GameEntry.Setting:GetInt(strKey, 0)
    if self.foodData.num < self.cookMaxNum and today ~= localData then
      self.redPoint:SetActive(true)
    else
      self.redPoint:SetActive(false)
    end
  else
    self.redPoint:SetActive(false)
  end
end

UIActCookFood.OnCreate = OnCreate
UIActCookFood.OnDestroy = OnDestroy
UIActCookFood.OnEnable = OnEnable
UIActCookFood.OnDisable = OnDisable
UIActCookFood.ComponentDefine = ComponentDefine
UIActCookFood.ComponentDestroy = ComponentDestroy
UIActCookFood.DataDefine = DataDefine
UIActCookFood.DataDestroy = DataDestroy
return UIActCookFood
