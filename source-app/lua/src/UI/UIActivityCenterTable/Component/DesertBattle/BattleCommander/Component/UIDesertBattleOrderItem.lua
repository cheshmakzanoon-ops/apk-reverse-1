local UIDesertBattleOrderItem = BaseClass("UIDesertBattleOrderItem", UIBaseContainer)
local base = UIBaseContainer
local ActDragonCommandOrderData = require("DataCenter.ActDragonManager.ActDragonCommandOrderData")

function UIDesertBattleOrderItem:OnCreate()
  base.OnCreate(self)
  self.order = ActDragonCommandOrderData.New()
  self.selected = true
  self.anim = self:AddComponent(UIAnimator, "")
  self.btn = self:AddComponent(UIButton, "Btn")
  self.btn:SetOnClick(BindCallback(self, self.OnClick))
  self.img_sel = self:AddComponent(UIBaseComponent, "Sel")
  self.empty = self:AddComponent(UIBaseComponent, "Empty")
  self.info = self:AddComponent(UIBaseComponent, "Info")
  self.head = self:AddComponent(UICommonHead, "Info/Head/UIPlayerHead")
  self.img_type = self:AddComponent(UIImage, "Info/state/TypeImg")
  self.text_num = self:AddComponent(UIText, "Info/state/NumText")
  self.icon_build = self:AddComponent(UIImage, "Info/BuildIcon")
  self.text_pos = self:AddComponent(UIText, "Info/PosText")
end

function UIDesertBattleOrderItem:OnDestroy()
  if self.animTimer then
    self.animTimer:Stop()
  end
  self.animTimer = nil
  self.selected = false
  self.order = nil
  base.OnDestroy(self)
end

function UIDesertBattleOrderItem:OnClick()
  if self.selected then
    return
  end
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self:SetSelect(true)
  if self.cb then
    self.cb(self.idx)
  end
end

function UIDesertBattleOrderItem:SetSelect(bSel)
  self.selected = bSel
  self.img_sel:SetActive(bSel)
end

function UIDesertBattleOrderItem:ReInit(idx, curIdx, cb)
  self.idx = idx
  self.cb = cb
  self:SetSelect(idx == curIdx)
  self:PlayOrderAnim("BattleCommanderItemidle", nil, function()
    local order = DataCenter.ActDragonManager:GetOrderByIndex(idx)
    if order == nil and self.order.index ~= 0 then
      self.empty:SetActive(false)
      self.info:SetActive(true)
      self:PlayOrderAnim("BattleCommanderItemClose", nil, function()
        self:Refresh(nil)
      end)
    elseif order ~= nil and self.order.index == 0 then
      self:Refresh(order)
      self:PlayOrderAnim("BattleCommanderItemIn")
    elseif order == nil and self.order.index == 0 then
      self:Refresh(nil)
    elseif self.order:IsSame(order) then
      self:Refresh(order)
    else
      self.empty:SetActive(false)
      self.info:SetActive(true)
      self:PlayOrderAnim("BattleCommanderItemChange", 0.2, function()
        self:Refresh(order)
      end)
    end
  end)
end

function UIDesertBattleOrderItem:Refresh(order)
  self.order:CopyOrder(order)
  if order == nil then
    self.empty:SetActive(true)
    self.info:SetActive(false)
    return
  end
  local mgr = DataCenter.ActDragonManager
  self.empty:SetActive(false)
  self.info:SetActive(true)
  local pInfo = mgr:GetPlayerInfoByUID(order.commander)
  if pInfo then
    self.head:SetHeadAndFrame(pInfo.uid, pInfo.pic, pInfo.picVer, false, pInfo.headSkinId, pInfo.headSkinET)
  end
  self.img_type:LoadSpriteAuto(mgr:GetOrderImgByType(order.type))
  self.text_num:SetText(order.joinCount)
  local icon = mgr:GetOrderIcon(order)
  if not string.IsNullOrEmpty(icon) then
    self.icon_build:LoadSpriteAsyncWithCallback(icon, function()
      if self.icon_build then
        self.icon_build:SetNativeSize()
      end
    end)
  end
  local pos = SceneUtils.IndexToTilePos(order.point, ForceChangeScene.World)
  self.text_pos:SetText(string.format("X: %s, Y: %s", tostring(pos.x), tostring(pos.y)))
end

function UIDesertBattleOrderItem:PlayOrderAnim(name, percent, cb)
  if self.animTimer then
    self.animTimer:Stop()
  end
  self.animTimer = nil
  self.anim:Enable(true)
  local ret, time = self.anim:PlayAnimationReturnTime(name)
  if ret then
    if percent then
      time = percent * time
    end
    self.animTimer = TimerManager:GetInstance():DelayInvoke(function()
      if percent == nil then
        if self.animTimer then
          self.animTimer:Stop()
        end
        self.animTimer = nil
        self.anim:Enable(false)
      end
      if cb then
        cb()
      end
    end, time)
  end
end

return UIDesertBattleOrderItem
