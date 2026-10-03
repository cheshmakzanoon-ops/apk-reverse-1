local base = UIAsyncContainer
local StationItemComponent = BaseClass("StationItemComponent", UIAsyncContainer)
local UIServerBattleZoneInfo = require("UI.UIGovernment.ServerBattleMain.Component.UIServerBattleZoneInfo")
local Localization = CS.GameEntry.Localization

function StationItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function StationItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function StationItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textGoodsNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textPriceNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnDetail = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnDetail:SetOnClick(function()
    self:OnBtnDetailClick()
  end)
  self.textGoods2Num = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compGoods2 = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.compGoods = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.zone_item_up = self:AddComponent(UIServerBattleZoneInfo, "ZoneItemUp")
end

function StationItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textGoodsNum = nil
  self.textPriceNum = nil
  self.btnDetail = nil
  self.textGoods2Num = nil
  self.compGoods2 = nil
  self.compGoods = nil
end

function StationItemComponent:DataDefine()
end

function StationItemComponent:DataDestroy()
  self.data = nil
end

function StationItemComponent:OnBtnDetailClick()
  if self.index then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHSRStationHistoryDetail, {anim = true}, self.index)
  end
end

function StationItemComponent:SetData(index, data, showBtn, progress)
  self.data = data
  self.index = index
  self.showBtn = showBtn
  self.progress = progress
end

function StationItemComponent:UpdateData()
  self.zone_item_up:SetServerId(self.data.server)
  if not self.showBtn then
    self.compGoods:SetActive(false)
    self.compGoods2:SetActive(true)
    self.textGoods2Num:SetText(self.data.realBuyNum .. "/" .. self.data.buyMaxNum)
    self.textPriceNum:SetText(self.data.maxPrice)
  else
    self.compGoods:SetActive(true)
    self.compGoods2:SetActive(false)
    self.textGoodsNum:SetText(self.data.buyMaxNum)
    if DataCenter.HSRDataManager:GetSortType() == HSRStationSortType.Station then
      if self.index == 1 then
        self.textPriceNum:SetLocalText("server_train_station_title_1")
      elseif self.index > self.progress + 1 then
        self.textPriceNum:SetLocalText("server_train_not_arrived_title")
      else
        self.textPriceNum:SetText(self.data.maxPrice)
      end
    elseif self.data.maxPrice <= 0 then
      self.textPriceNum:SetLocalText("server_train_not_arrived_title")
    else
      self.textPriceNum:SetText(self.data.maxPrice)
    end
  end
end

return StationItemComponent
