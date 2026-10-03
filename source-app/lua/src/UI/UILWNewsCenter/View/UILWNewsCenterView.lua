local UILWNewsCenterView = BaseClass("UILWNewsCenterView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UINewsPersonalBattle = require("UI.UILWNewsCenter.Component.UILWNewsPersonalBattle")
local UINewsAllianceBattle = require("UI.UILWNewsCenter.Component.UILWNewsAllianceBattle")
local UINewsOccupyCity = require("UI.UILWNewsCenter.Component.UILWNewsOccupyCity")
local UINewsAppointOffical = require("UI.UILWNewsCenter.Component.UILWNewsAppointOffical")
local UINewsTrainRob = require("UI.UILWNewsCenter.Component.UILWNewsTrainRob")
local UINewsArenaChampion = require("UI.UILWNewsCenter.Component.UILWNewsArenaChampion")
local NewsItemComps = {
  UINewsPersonalBattle,
  UINewsAllianceBattle,
  UINewsOccupyCity,
  UINewsAppointOffical,
  UINewsTrainRob,
  UINewsArenaChampion
}
local UIHead = require("UI.UILWNewsCenter.Component.UILWNewsUserCell")
local compBook = {
  {
    path = "root/txtTitle",
    name = "txtTitle",
    type = UIText
  },
  {
    path = "root/btnBack",
    name = "btnBack",
    type = UIButton
  },
  {
    path = "root/tabAlliance",
    name = "tabAlliance",
    type = UIButton
  },
  {
    path = "root/tabZone",
    name = "tabZone",
    type = UIButton
  },
  {
    path = "root/tabAlliance/On",
    name = "tabAlliance_On",
    type = nil
  },
  {
    path = "root/tabAlliance/Off",
    name = "tabAlliance_Off",
    type = nil
  },
  {
    path = "root/tabZone/On",
    name = "tabZone_On",
    type = nil
  },
  {
    path = "root/tabZone/Off",
    name = "tabZone_Off",
    type = nil
  },
  {
    path = "root/tabAlliance/On/txtAlliance_On",
    name = "txtAlliance_On",
    type = UIText
  },
  {
    path = "root/tabAlliance/Off/txtAlliance_Off",
    name = "txtAlliance_Off",
    type = UIText
  },
  {
    path = "root/tabZone/On/txtZone_On",
    name = "txtZone_On",
    type = UIText
  },
  {
    path = "root/tabZone/Off/txtZone_Off",
    name = "txtZone_Off",
    type = UIText
  },
  {
    path = "root/txtEmpty",
    name = "txtEmpty",
    type = UIText
  },
  {
    path = "root/Scroll View",
    name = "scrollNews",
    type = UIDynamicVerticleScrollRectEx
  },
  {
    path = "floatLike",
    name = "floatLike",
    type = nil
  },
  {
    path = "floatLike/headLike",
    name = "headLike",
    type = UIHead
  }
}
local Tab = {Zone = 1, Alliance = 2}

function UILWNewsCenterView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.currTab = nil
  local userData = self:GetUserData()
  self.ctrl.fromChatRoomId = userData.fromChatRoomId
  self:SwitchTab(Tab.Zone)
  self.floatInsts = {}
end

function UILWNewsCenterView:OnDestroy()
  if self.floatInsts then
    for _, floatInst in ipairs(self.floatInsts) do
      if not IsNull(floatInst) then
        CS.UnityEngine.GameObject.Destroy(floatInst)
      end
    end
    self.floatInsts = nil
  end
  if self.itemDatas then
    for _, itemData in ipairs(self.itemDatas) do
      if itemData.isNew then
        itemData:SetRead()
      end
    end
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWNewsCenterView:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UILWNewsCenterView:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.txtTitle:SetText(Localization:GetString("800940"))
  self.txtAlliance_On:SetText(Localization:GetString("393081"))
  self.txtAlliance_Off:SetText(Localization:GetString("393081"))
  self.txtZone_On:SetText(Localization:GetString("100171"))
  self.txtZone_Off:SetText(Localization:GetString("100171"))
  self.btnBack:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.tabAlliance:SetOnClick(function()
    if LuaEntry.Player:IsInAlliance() then
      self:SwitchTab(Tab.Alliance)
    else
      UIUtil.ShowTips(Localization:GetString("800935"))
    end
  end)
  self.tabZone:SetOnClick(function()
    self:SwitchTab(Tab.Zone)
  end)
  self.itemIncNo = 1
  self.newsItemMap = {}
  self.scrollNews:AddInstantiateItemListener(function(itemObj, prefabIdx)
    itemObj.name = "recordItem_" .. self.itemIncNo
    self.itemIncNo = self.itemIncNo + 1
    local UINewsComp = NewsItemComps[prefabIdx + 1]
    local newsItem = self:AddComponent(UINewsComp, itemObj)
    self.newsItemMap[itemObj] = newsItem
  end)
  self.scrollNews:AddDisplayItemListener(function(itemObj, dataIdx)
    local newsItem = self.newsItemMap[itemObj]
    if newsItem then
      newsItem:RefreshView(self.itemDatas[dataIdx + 1])
    end
  end)
  self.floatLike:SetActive(false)
  self.headLike:Refresh(LuaEntry.Player.uid, LuaEntry.Player.pic, LuaEntry.Player.picVer, nil, nil, nil)
end

function UILWNewsCenterView:SwitchTab(tab)
  if self.currTab == tab then
    return
  end
  self.currTab = tab
  self.tabAlliance_On:SetActive(tab == Tab.Alliance)
  self.tabAlliance_Off:SetActive(tab ~= Tab.Alliance)
  self.tabZone_On:SetActive(tab == Tab.Zone)
  self.tabZone_Off:SetActive(tab ~= Tab.Zone)
  self:RefreshNews()
end

local function __GetItemTemplateByInfo(self, info)
  if info.smallType == NewsSubType.PERSONAL_BATTLE then
    return 0
  elseif info.smallType == NewsSubType.ALLIANCE_BATTLE then
    return 1
  elseif info.smallType == NewsSubType.ALLIANCE_ATK_ALLIANCE_CITY then
    return 2
  elseif info.smallType == NewsSubType.APPOINT_OFFICAL then
    return 3
  elseif info.smallType == NewsSubType.TRAIN_ROB then
    return 4
  elseif info.smallType == NewsSubType.ARENA_CHAMPION then
    return 5
  end
  return nil
end

function UILWNewsCenterView:RefreshNews()
  local prefabIdxs = {}
  self.itemDatas = DataCenter.LWNewsCenterManager:FilterNews(self.currTab)
  if self.itemDatas and #self.itemDatas > 0 then
    for _, info in ipairs(self.itemDatas) do
      local prefabIdx = __GetItemTemplateByInfo(self, info)
      if prefabIdx then
        table.insert(prefabIdxs, prefabIdx)
      end
    end
    self.txtEmpty:SetActive(false)
  else
    if self.currTab == Tab.Zone then
      self.txtEmpty:SetText(Localization:GetString(800933))
    elseif self.currTab == Tab.Alliance then
      self.txtEmpty:SetText(Localization:GetString(800934))
    end
    self.txtEmpty:SetActive(true)
  end
  self.scrollNews:SetDatas(prefabIdxs)
  for dataIdx, prefabIdx in ipairs(prefabIdxs) do
    if NewsItemComps[prefabIdx + 1] == UINewsPersonalBattle then
      self.scrollNews:SetOverrideItemHeight(dataIdx - 1, UINewsPersonalBattle.GetOVerrideHeight(self.itemDatas[dataIdx]))
    end
  end
end

function UILWNewsCenterView:RefreshSingleNews(newsUuid)
  if self.itemDatas and #self.itemDatas > 0 then
    for i, info in ipairs(self.itemDatas) do
      if info.uuid == newsUuid then
        local dataIdx = i - 1
        local itemObj = self.scrollNews:FindItemByDataIdx(dataIdx)
        local newsItem = not IsNull(itemObj) and self.newsItemMap[itemObj] or nil
        if newsItem then
          newsItem:RefreshView(info)
        end
        break
      end
    end
  end
end

function UILWNewsCenterView:ShowFloatLike(startY)
  local floatInst = CS.UnityEngine.GameObject.Instantiate(self.floatLike, self.floatLike.transform.parent)
  floatInst:SetActive(true)
  table.insert(self.floatInsts, floatInst)
  floatInst.transform.anchoredPosition = Vector2.New(0, startY - 200)
  floatInst.transform:DOAnchorPosY(startY - 100, 2)
  floatInst:GetComponent(typeof(CS.UnityEngine.CanvasGroup)):DOFade(0, 2):OnComplete(function()
    CS.UnityEngine.GameObject.Destroy(floatInst)
  end)
end

return UILWNewsCenterView
