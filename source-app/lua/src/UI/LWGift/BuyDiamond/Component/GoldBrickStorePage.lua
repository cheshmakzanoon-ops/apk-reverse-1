local GoldBrickStorePage = BaseClass("GoldBrickStorePage", UIBaseContainer)
local base = UIBaseContainer
local GoldBrickItemCell = require("UI.LWGift.BuyDiamond.Component.GoldBrickItemCell")

function GoldBrickStorePage:OnCreate()
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
  SFSNetwork.SendMessage(MsgDefines.GetGoldBrickInfo)
end

function GoldBrickStorePage:ClearScroll()
  if self.scroll then
    self.scroll:RemoveComponents(GoldBrickItemCell)
    self.grid:DestroyChildNode()
  end
end

function GoldBrickStorePage:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function GoldBrickStorePage:OnEnable()
  base.OnEnable(self)
  self.active = true
end

function GoldBrickStorePage:OnDisable()
  base.OnDisable(self)
  self.active = false
end

function GoldBrickStorePage:OnInitScroll(go, index)
  local item = self.scroll:AddComponent(GoldBrickItemCell, go)
  self.listGO[go] = item
end

function GoldBrickStorePage:OnUpdateScroll(go, index)
  local item = self.listGO[go]
  local package = self.packageList[index + 1]
  item:SetActive(package ~= nil)
  if package then
    item:Refresh(package)
  end
end

function GoldBrickStorePage:OnDestroyScrollItem(go, index)
end

function GoldBrickStorePage:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GoldBrickShopGetData, self.RefreshView)
end

function GoldBrickStorePage:OnRemoveListener()
  self:RemoveUIListener(EventId.GoldBrickShopGetData, self.RefreshView)
  base.OnRemoveListener(self)
end

function GoldBrickStorePage:RefreshView()
  if not self.active then
    return
  end
  self.packageList = WelfareController.GetGoldBrickList()
  table.sort(self.packageList, function(a, b)
    return tonumber(a.amount) > tonumber(b.amount)
  end)
  local dataCount = table.count(self.packageList)
  if 0 < dataCount then
    if not self.hasInitGrid then
      local bindFunc1 = BindCallback(self, self.OnInitScroll)
      local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
      local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
      self.grid:Init(bindFunc1, bindFunc2, bindFunc3)
      self.hasInitGrid = true
    end
    self.grid:SetItemCount(dataCount)
    self.grid:ForceUpdate()
  end
end

function GoldBrickStorePage:ComponentDefine()
  self.infoBtn = self:AddComponent(UIButton, "NameInfoBtn")
  self.infoBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
      howToPlayList = {600020}
    })
  end)
  self.grid = self:AddComponent(GridInfinityScrollView, "CellGrid/Content")
  self.scroll = self:AddComponent(UIBaseContainer, "CellGrid")
end

function GoldBrickStorePage:ComponentDestroy()
  self.grid = nil
  self.scroll = nil
end

function GoldBrickStorePage:DataDefine()
  self.listGO = {}
  self.hasInitGrid = false
  self.active = false
end

function GoldBrickStorePage:DataDestroy()
  self.hasInitGrid = false
end

return GoldBrickStorePage
