local UIHSRPersonalHistoryDetailView = BaseClass("UIHSRPersonalHistoryDetailView", UIBaseView)
local RecordConsignComponent = require("UI/UIHSR/UIHSRPersonalHistoryDetail/RecordConsignComponent")
local RecordDumpComponent = require("UI/UIHSR/UIHSRPersonalHistoryDetail/RecordDumpComponent")
local RecordRobComponent = require("UI/UIHSR/UIHSRPersonalHistoryDetail/RecordRobComponent")
local RecordFailureComponent = require("UI/UIHSR/UIHSRPersonalHistoryDetail/RecordFailureComponent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local btn_jump_path = "PopUpContent/root/BtnJump"
local jump_text_path = "PopUpContent/root/BtnJump/JumpText"

function UIHSRPersonalHistoryDetailView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIHSRPersonalHistoryDetailView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIHSRPersonalHistoryDetailView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textCurStation = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textSold = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textProfit = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textNextStation = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textCurStationNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textProfitNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textSoldNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textGoods = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textGoodsNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.imgSlider = self.viewSkin:AddComponent(self, UIImage, 13)
  self.textNextStationNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseComponent, 15)
  self.compNextStation = self.viewSkin:AddComponent(self, UIBaseComponent, 16)
  self.compCurStation = self.viewSkin:AddComponent(self, UIBaseComponent, 17)
  self.compProgress = self.viewSkin:AddComponent(self, UIBaseComponent, 18)
  self.jump_text = self:AddComponent(UITextMeshProUGUIEx, jump_text_path)
  self.jump_text:SetLocalText("dispatch_des031")
  self.btn_jump = self:AddComponent(UIButton, btn_jump_path)
  self.btn_jump:SetOnClick(function()
    if self.mailUid then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMailMain, {anim = false}, UIMailOpenType.Detail, self.mailUid)
    else
      UIUtil.ShowTipsId(310112)
    end
  end)
  self.textTitle:SetLocalText("activity_1200044_tips15")
  self.textCurStation:SetLocalText("activity_1200044_tips43", "")
  self.textNextStation:SetLocalText("activity_1200044_tips4", "")
  self.textGoods:SetLocalText("activity_1200044_tips16", "")
  self.textSold:SetLocalText("activity_1200044_tips17", "")
  self.textProfit:SetLocalText("activity_1200044_tips18", "")
  self.items = {}
end

function UIHSRPersonalHistoryDetailView:ComponentDestroy()
  self:RemoveItems()
  self.viewSkin = nil
  self.textTitle = nil
  self.btnPanel = nil
  self.btnClose = nil
  self.textCurStation = nil
  self.textSold = nil
  self.textProfit = nil
  self.textNextStation = nil
  self.textCurStationNum = nil
  self.textProfitNum = nil
  self.textSoldNum = nil
  self.textGoods = nil
  self.textGoodsNum = nil
  self.imgSlider = nil
  self.textNextStationNum = nil
  self.compContent = nil
  self.compNextStation = nil
  self.compCurStation = nil
  self.compProgress = nil
end

function UIHSRPersonalHistoryDetailView:OnEnable()
  base.OnEnable(self)
  RailwayUtil.CheckHSRMailExistAndHasReward(self.hsrUuid, function(mailUid)
    self.mailUid = mailUid
    self.btn_jump:SetActive(mailUid)
  end)
end

function UIHSRPersonalHistoryDetailView:DataDefine()
  self.hsrUuid = self:GetUserData()
  if self.hsrUuid == nil then
    self.going = true
    local data = DataCenter.HSRDataManager:GetActivityData()
    if not data then
      Logger.LogError("UIHSRPersonalHistoryDetailView:DataDefine hsrUuid is nil")
      return
    end
    self.hsrUuid = data.uuid
  end
  DataCenter.HSRDataManager:FetchMyHistoryByTrain(self.hsrUuid)
  self.data = DataCenter.HSRDataManager:GetMyHistoryByUuid(self.hsrUuid)
end

function UIHSRPersonalHistoryDetailView:DataDestroy()
end

function UIHSRPersonalHistoryDetailView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.HSRPersonalHistoryDetailRefresh, self.HandleServerData)
end

function UIHSRPersonalHistoryDetailView:OnRemoveListener()
  self:RemoveUIListener(EventId.HSRPersonalHistoryDetailRefresh, self.HandleServerData)
  base.OnRemoveListener(self)
end

function UIHSRPersonalHistoryDetailView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIHSRPersonalHistoryDetailView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIHSRPersonalHistoryDetailView:HandleServerData(uuid)
  if self.hsrUuid == uuid then
    self.data = DataCenter.HSRDataManager:GetMyHistoryByUuid(self.hsrUuid)
    self:RefreshView()
  end
end

function UIHSRPersonalHistoryDetailView:RefreshView()
  self:RemoveItems()
  local activityData = DataCenter.HSRDataManager:GetActivityData()
  if self.going and activityData then
    local _, progress = DataCenter.HSRDataManager:GetDrivingProgress()
    local totalStationCount = DataCenter.HSRDataManager:GetStationCount()
    self.imgSlider:SetFillAmount(progress / totalStationCount)
    local prevServerId, curServerId = DataCenter.HSRDataManager:GetServerIdPrevAndCurByStationId(activityData.nextCity)
    self.textCurStationNum:SetText(UIUtil.FormatServerName(prevServerId))
    self.textNextStationNum:SetText(UIUtil.FormatServerName(curServerId))
    self.compProgress:SetActive(true)
    self.compCurStation:SetActive(0 < progress)
    self.compNextStation:SetActive(true)
  else
    self.compProgress:SetActive(false)
    self.compCurStation:SetActive(false)
    self.compNextStation:SetActive(false)
  end
  if self.data then
    local trade = self.data.trade
    self.textGoodsNum:SetText(string.GetFormattedSeparatorNum(trade.totalNum))
    self.textSoldNum:SetText(string.GetFormattedSeparatorNum(trade.sellNum))
    self.textProfitNum:SetText(string.GetFormattedSeparatorNum(trade.profit))
    local records = self.data.records
    for i, v in ipairs(records) do
      local item
      if v.type == HSRSellType.Consign then
        item = self.compContent:LoadComponentAsync(RecordConsignComponent, "Assets/Main/SeasonRes/S5/Prefabs/UI/HSR/RecordConsign.prefab")
      elseif v.type == HSRSellType.Dump then
        item = self.compContent:LoadComponentAsync(RecordDumpComponent, "Assets/Main/SeasonRes/S5/Prefabs/UI/HSR/RecordDump.prefab")
      elseif v.type == HSRSellType.BeLooted then
        item = self.compContent:LoadComponentAsync(RecordRobComponent, "Assets/Main/SeasonRes/S5/Prefabs/UI/HSR/RecordRob.prefab")
      elseif v.type == HSRSellType.Failure then
        item = self.compContent:LoadComponentAsync(RecordFailureComponent, "Assets/Main/SeasonRes/S5/Prefabs/UI/HSR/RecordFailure.prefab")
      end
      item:SetData(v, i == #records)
      table.insert(self.items, item)
    end
  end
end

function UIHSRPersonalHistoryDetailView:RemoveItems()
  for _, v in pairs(self.items) do
    self.compContent:RemoveAsyncComponent(v)
  end
  self.items = {}
end

return UIHSRPersonalHistoryDetailView
