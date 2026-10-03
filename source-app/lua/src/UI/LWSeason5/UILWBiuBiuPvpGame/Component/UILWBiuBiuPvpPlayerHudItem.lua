local base = UIBaseContainer
local UILWBiuBiuPvpPlayerHudItem = BaseClass("UILWBiuBiuPvpPlayerHudItem.lua", base)
local UILWBiuBiuPvpPlayerHpHudItem = require("UI.LWSeason5.UILWBiuBiuPvpGame.Component.UILWBiuBiuPvpPlayerHpHudItem")
local hp_path = "Info/go_hp/hp"
local go_cd_path = "Info/go_hp/go_cd"
local img_cd_path = "Info/go_hp/go_cd/img_cd"

function UILWBiuBiuPvpPlayerHudItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.playerId = nil
  self.curCd = nil
  self.maxCd = nil
  self.controller = nil
  self.isMe = nil
  self.parentRect = nil
end

function UILWBiuBiuPvpPlayerHudItem:OnDestroy()
  self.playerId = nil
  self.curCd = nil
  self.maxCd = nil
  self.controller = nil
  self.isMe = nil
  self.parentRect = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWBiuBiuPvpPlayerHudItem:ComponentDefine()
  self.hp = self:AddComponent(UILWBiuBiuPvpPlayerHpHudItem, hp_path)
  self.go_cd = self:AddComponent(UIImage, go_cd_path)
  self.img_cd = self:AddComponent(UIImage, img_cd_path)
end

function UILWBiuBiuPvpPlayerHudItem:ComponentDestroy()
  self.hp = nil
  self.go_cd = nil
  self.img_cd = nil
end

function UILWBiuBiuPvpPlayerHudItem:InitData(index, parent)
  self.playerId = index
  self.parentRect = parent
end

function UILWBiuBiuPvpPlayerHudItem:BindController(uiPlayerBind)
  self.controller = uiPlayerBind.Controller
end

function UILWBiuBiuPvpPlayerHudItem:RefreshInfo(uiShowInfo)
  self.isMe = uiShowInfo.PlayerID == self.playerId
  self.go_cd:SetActive(self.isMe)
  if self.isMe then
    self.curCd = uiShowInfo.GunReloadCurCD
    self.maxCd = uiShowInfo.GunReloadMaxCD
  end
  local curHp = uiShowInfo.CurHp[self.playerId]
  local maxHp = uiShowInfo.MaxHp[self.playerId]
  self.hp:Refresh(self.isMe, curHp, maxHp)
end

function UILWBiuBiuPvpPlayerHudItem:Update()
  self:UpdatePos()
  if self.maxCd == 0 then
    return
  end
  if self.curCd ~= nil and self.maxCd ~= nil then
    if 0 < self.curCd then
      self.curCd = self.curCd - Time.deltaTime
    else
      self.curCd = 0
    end
    self.img_cd:SetFillAmount(math.min(1 - self.curCd / self.maxCd, 1))
  end
end

function UILWBiuBiuPvpPlayerHudItem:UpdatePos()
  if not IsNull(self.controller) and not IsNull(self.controller.Camera) then
    local screenPos = self.controller.Camera:WorldToScreenPoint(self.controller.UIPos.position)
    local uiPos = PosConverse.ScreenToUIPos(self.parentRect, Vector2.New(screenPos.x, screenPos.y))
    self.rectTransform.anchoredPosition = uiPos
  end
end

return UILWBiuBiuPvpPlayerHudItem
