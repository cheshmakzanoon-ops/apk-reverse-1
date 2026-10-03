local UILWRedPacketBagView = BaseClass("UILWRedPacketBagView", UIBaseView)
local base = UIBaseView
local UILWRedPacketItem = require("UI.UILWRedPacketBag.Component.UILWRedPacketItem")
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local tip_txt_path = "safearea/tipTxt"

function UILWRedPacketBagView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

function UILWRedPacketBagView:ComponentDefine()
  self.closeBtn = self:AddComponent(UIButton, "safearea/BottomBar/BtnBack")
  self.panelBtn = self:AddComponent(UIButton, "Panel")
  self.titleText = self:AddComponent(UITextMeshProUGUIEx, "safearea/TopBar/TextTitle")
  self.emptyContentText = self:AddComponent(UITextMeshProUGUIEx, "safearea/emptyContentText")
  self.introBtn = self:AddComponent(UIButton, "safearea/Intro")
  self.introBtn:SetOnClick(function()
    self:ShowIntro()
  end)
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.redPacketScrollView = self:AddComponent(UIScrollView, "safearea/scroll_view")
  self.redPacketScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.redPacketScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.titleText:SetLocalText("red_pocket_desc4")
  self.emptyContentText:SetLocalText("red_pocket_desc31")
  self.tip_txt = self:AddComponent(UITextMeshProUGUIEx, tip_txt_path)
end

function UILWRedPacketBagView:ShowIntro()
  local param = {}
  local key = LuaEntry.DataConfig:TryGetStr("red_pocket_config", "k6")
  param.activityRulesStr = Localization:GetString(key)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function UILWRedPacketBagView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.ReInit)
end

function UILWRedPacketBagView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.ReInit)
end

function UILWRedPacketBagView:ClearScroll()
  self.redPacketScrollView:ClearCells()
  self.redPacketScrollView:RemoveComponents(UILWRedPacketItem)
end

function UILWRedPacketBagView:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.redPacketScrollView:AddComponent(UILWRedPacketItem, itemObj)
  item:Refresh(self.items[index])
end

function UILWRedPacketBagView:OnDeleteCell(itemObj, index)
  self.redPacketScrollView:RemoveComponent(itemObj.name, UILWRedPacketItem)
end

function UILWRedPacketBagView:ComponentDestroy()
  self.redPacketScrollView = nil
  self.closeBtn = nil
  self.tip_txt = nil
end

function UILWRedPacketBagView:ReInit()
  self:ClearScroll()
  self.items = DataCenter.RedPacketManager:GetOpenShowAllRedPacketList()
  if self.items and #self.items > 0 then
    self.redPacketScrollView:SetTotalCount(#self.items)
    self.redPacketScrollView:RefillCells()
    self.emptyContentText:SetActive(false)
    DataCenter.RedPacketManager:SetRedPackRedDot()
  else
    self.emptyContentText:SetActive(true)
  end
  local curGetNum = DataCenter.RedPacketManager:GetRedPacketGetNum()
  local maxGetNum = DataCenter.RedPacketManager:GetRedPacketGetMaxNum()
  self.tip_txt:SetLocalText("red_pocket_desc35", curGetNum, maxGetNum)
  self:RefreshExpiredTime()
  self:Update1000MS()
end

function UILWRedPacketBagView:RefreshExpiredTime()
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  self.expiredTime = nil
  for i = #self.items, 1, -1 do
    local item = self.items[i]
    local curExpiredTime
    if not string.IsNullOrEmpty(item.otherParam) and item.GetOtherParamTab then
      local otherPara = item:GetOtherParamTab()
      if otherPara and otherPara.expireTime then
        curExpiredTime = otherPara.expireTime
      end
    end
    if curExpiredTime then
      if curTime > curExpiredTime then
        table.remove(self.items, i)
      elseif not self.expiredTime or curExpiredTime < self.expiredTime then
        self.expiredTime = curExpiredTime
      end
    end
  end
end

function UILWRedPacketBagView:Update1000MS()
  if self.expiredTime == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if curTime >= self.expiredTime then
    self:ReInit()
  end
end

function UILWRedPacketBagView:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWRedPacketBagView:OnEnable()
  base.OnEnable(self)
end

function UILWRedPacketBagView:OnDisable()
  base.OnDisable(self)
end

function UILWRedPacketBagView:DataDefine()
end

function UILWRedPacketBagView:DataDestroy()
end

return UILWRedPacketBagView
