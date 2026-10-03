local BrickGiftPackPage = BaseClass("BrickGiftPackPage", UIBaseContainer)
local base = UIBaseContainer
local M = BrickGiftPackPage
local BrickGiftPackPackItem = require("UI.UIGiftPackage.Component.BrickGiftPack.BrickGiftPackPackItem")
local BrickGiftPackDirectItem = require("UI.UIGiftPackage.Component.BrickGiftPack.BrickGiftPackDirectItem")

function M:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  local isShowHowToPlay = CS.GameEntry.Setting:GetBool("GoldBrickHowToPlaySign", false)
  if not isShowHowToPlay then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
      howToPlayList = {600020}
    })
    CS.GameEntry.Setting:SetBool("GoldBrickHowToPlaySign", true)
  end
end

function M:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function M:OnEnable()
  base.OnEnable(self)
  self.active = true
end

function M:OnDisable()
  base.OnDisable(self)
  self.active = false
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGiftPackData, self.RefreshView)
end

function M:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.RefreshView)
  base.OnRemoveListener(self)
end

function M:RefreshView()
  if not self.active then
    return
  end
  local rechargeCfg = DataCenter.RechargeManager:GetLine(GoldBrickConst.RechargeId)
  if not rechargeCfg then
    return
  end
  local packIds = rechargeCfg.para1 and string.split(rechargeCfg.para1, "|") or {}
  self.giftContent:RemoveComponents(BrickGiftPackPackItem)
  self.giftItemPrefab:GameObjectRecycleAll()
  for i = 1, #packIds do
    local item = self.giftItemPrefab:GameObjectSpawn(self.giftContent.transform)
    item.name = "BrickGiftPack" .. i
    local cell = self.giftContent:AddComponent(BrickGiftPackPackItem, item.name)
    local packData = GiftPackageData.get(packIds[i])
    cell:ReInit(packData)
  end
  local directIds = rechargeCfg.para2 and string.split(rechargeCfg.para2, "|") or {}
  self.directContent:RemoveComponents(BrickGiftPackDirectItem)
  self.directItemPrefab:GameObjectRecycleAll()
  for i = 1, #directIds do
    local item = self.directItemPrefab:GameObjectSpawn(self.directContent.transform)
    item.name = "BrickDirect" .. i
    local cell = self.directContent:AddComponent(BrickGiftPackDirectItem, item.name)
    local packData = GiftPackageData.get(directIds[i])
    cell:ReInit(packData)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.scrollContent.rectTransform)
end

function M:Update1000MS()
  if self.timeRefreshText then
    local nextMonthTime = UITimeManager:GetInstance():GetNextMonth()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if nextMonthTime ~= nil then
      local remainTime = nextMonthTime - curTime
      if 0 < remainTime then
        local txt = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
        self.timeRefreshText:SetLocalText("goldbrick_lawshop_time_des", txt)
      else
        self.timeRefreshText:SetLocalText("goldbrick_lawshop_time_des", "0:00:00")
      end
    else
      self.timeRefreshText:SetLocalText("goldbrick_lawshop_time_des", "0:00:00")
    end
  end
end

function M:ComponentDefine()
  self.scrollContent = self:AddComponent(UIBaseContainer, "Scroll/Content")
  self.giftContent = self:AddComponent(UIBaseContainer, "Scroll/Content/BrickGiftPack")
  self.giftItemPrefab = self.giftContent.transform:Find("BrickGiftPackPackItem").gameObject
  self.giftItemPrefab:GameObjectCreatePool()
  self.directContent = self:AddComponent(UIBaseContainer, "Scroll/Content/DirectPurchase")
  self.directItemPrefab = self.directContent.transform:Find("BrickGiftPackDirectItem").gameObject
  self.directItemPrefab:GameObjectCreatePool()
  self.timeRefreshText = self:AddComponent(UIText, "RefreshText")
  self.infoBtn = self:AddComponent(UIButton, "Scroll/Content/BricsDirectLine/NameInfoBtn")
  self.infoBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
      howToPlayList = {600020}
    })
  end)
end

function M:ComponentDestroy()
  self.scrollContent = nil
  self.giftContent:RemoveComponents(BrickGiftPackPackItem)
  self.giftContent = nil
  self.giftItemPrefab:GameObjectRecycleAll()
  self.giftItemPrefab = nil
  self.directContent:RemoveComponents(BrickGiftPackDirectItem)
  self.directContent = nil
  self.directItemPrefab:GameObjectRecycleAll()
  self.directItemPrefab = nil
end

function M:DataDefine()
  self.active = false
end

function M:DataDestroy()
end

return M
