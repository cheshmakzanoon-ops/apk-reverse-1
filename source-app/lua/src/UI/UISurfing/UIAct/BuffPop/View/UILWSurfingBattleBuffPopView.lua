local UILWSurfingBattleBuffPopView = BaseClass("UILWSurfingBattleBuffPopView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local buffCellItem = require("UI.UISurfing.UIAct.BuffPop.Component.BuffItem")

function UILWSurfingBattleBuffPopView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitUI()
end

function UILWSurfingBattleBuffPopView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSurfingBattleBuffPopView:ComponentDefine()
  self.btnClose = self:AddComponent(UIButton, "safeArea/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "safeArea/titleText")
  self.compContent = self:AddComponent(UIBaseContainer, "safeArea/scrollView/ViewPort/Content")
  self.scrollRectScrollView = self:AddComponent(UIScrollRect, "safeArea/scrollView")
  self.buffItem = self:AddComponent(UIBaseComponent, "safeArea/scrollView/ViewPort/Content/BuffCell")
  self.textResourceNum = self:AddComponent(UITextMeshProUGUIEx, "safeArea/resourceRect/resourceNum")
  self.imgResourceIcon = self:AddComponent(UIImage, "safeArea/resourceRect/resourceIcon")
  self.buffItem.gameObject:SetActive(false)
  self.buffItemPool = self.buffItem.gameObject
  self.buffItemPool:GameObjectCreatePool()
  self.buffItems = {}
end

function UILWSurfingBattleBuffPopView:ComponentDestroy()
  self.textResourceNum = nil
  self.imgResourceIcon = nil
  self.btnClose = nil
  self.btnPanel = nil
  self.textTitle = nil
  self.compContent = nil
  self.scrollRectScrollView = nil
  self.buffItem = nil
end

function UILWSurfingBattleBuffPopView:DataDefine()
  self.buffDataList = {}
end

function UILWSurfingBattleBuffPopView:DataDestroy()
  self:ClearContent()
  self.buffDataList = nil
end

function UILWSurfingBattleBuffPopView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SurfingCoinNumRefresh, self.UpdateCoinNum)
end

function UILWSurfingBattleBuffPopView:OnRemoveListener()
  self:RemoveUIListener(EventId.SurfingCoinNumRefresh, self.UpdateCoinNum)
  base.OnRemoveListener(self)
end

function UILWSurfingBattleBuffPopView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UILWSurfingBattleBuffPopView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UILWSurfingBattleBuffPopView:InitUI()
  self.buffDataList = DataCenter.LWSurfingDataManager:GetSurfingCultivatedBuffData()
  self.imgResourceIcon:LoadSpriteAsync("Assets/Main/Sprites/ItemIcons/lrb_paoku_jifen_daojv.png")
  self:InitScrollView()
  self:UpdateCoinNum()
end

function UILWSurfingBattleBuffPopView:UpdateCoinNum()
  self.coinNum = DataCenter.LWSurfingDataManager:GetCoinNum()
  self.textResourceNum:SetText(string.GetFormattedStr(self.coinNum))
end

function UILWSurfingBattleBuffPopView:SortBuffDataList()
  local now = UITimeManager:GetInstance():GetServerTime()
  table.sort(self.buffDataList, function(a, b)
    local aUnlocked = a.unlockTime ~= nil and now >= a.unlockTime
    local bUnlocked = b.unlockTime ~= nil and now >= b.unlockTime
    if aUnlocked ~= bUnlocked then
      return aUnlocked
    end
    if not aUnlocked and not bUnlocked then
      local aNil = a.unlockTime == nil
      local bNil = b.unlockTime == nil
      if aNil ~= bNil then
        return aNil
      end
    end
    return a.id < b.id
  end)
end

function UILWSurfingBattleBuffPopView:InitScrollView()
  self:SortBuffDataList()
  if self.buffDataList then
    local count = #self.buffDataList
    for i = 1, count do
      local item = self.buffItems[i]
      if item == nil then
        local go = self.buffItemPool:GameObjectSpawn(self.compContent.transform)
        go.name = "buff" .. i
        item = self.compContent:AddComponent(buffCellItem, go.name)
        self.buffItems[i] = item
      else
        item.gameObject.transform:SetParent(self.compContent.transform)
      end
      item:SetActive(true)
      item:ReInit(self.buffDataList[i])
    end
    for i = count + 1, #self.buffItems do
      local item = self.buffItems[i]
      if item then
        item:SetActive(false)
      end
    end
  end
end

function UILWSurfingBattleBuffPopView:ClearContent()
  self.compContent:RemoveComponents(buffCellItem)
  self.buffItemPool:GameObjectRecycleAll()
  self.buffItems = nil
end

return UILWSurfingBattleBuffPopView
