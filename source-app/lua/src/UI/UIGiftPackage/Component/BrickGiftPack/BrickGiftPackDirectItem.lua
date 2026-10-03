local BrickGiftPackDirectItem = BaseClass("BrickGiftPackDirectItem", UIBaseContainer)
local base = UIBaseContainer
local M = BrickGiftPackDirectItem

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function M:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function M:OnEnable()
  base.OnEnable(self)
end

function M:OnDisable()
  base.OnDisable(self)
end

function M:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "bg")
  self.btn:SetOnClick(function()
    self:OnShowClick()
  end)
  self.btn:SetSafeClickMode(true)
  self.txtPrice = self:AddComponent(UIText, "TextPrice")
  self.centerComp = self:AddComponent(UIBaseComponent, "Center")
  self.txtNum = self:AddComponent(UIText, "Center/TextNum")
  self.imgJp = self:AddComponent(UIImage, "Center/ImageJp")
  self.txtRemain = self:AddComponent(UIText, "TextRemain")
  self.icon = self:AddComponent(UIImage, "Icon")
end

function M:ComponentDestroy()
  self.btn = nil
  self.txtPrice = nil
  self.txtNum = nil
  self.icon = nil
end

function M:DataDefine()
end

function M:DataDestroy()
end

function M:ReInit(param)
  self.data = param
  local price = DataCenter.PayManager:GetDollarText(self.data:getPrice(), self.data:getProductID())
  self.txtPrice:SetText(price)
  self.txtNum:SetText(param:getGoldBrick())
  self.imgJp:SetActive(LuaEntry.Player.JPUser)
  local remainTime = self.data:getBuyTimes() - self.data:getHasGetCount()
  self.txtRemain:SetLocalText(2000707, string.format(" %s", remainTime))
  if remainTime <= 0 then
    CS.UIGray.SetGray(self.btn.transform, true, false)
    self.txtRemain:SetLocalText(129060)
  else
    CS.UIGray.SetGray(self.btn.transform, false, true)
  end
  self.icon:LoadSpriteAuto(self:GetGoldBrickIcon(tonumber(self.data:getGoldBrick())))
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.centerComp.rectTransform)
end

function M:GetGoldBrickIcon(brickNum)
  local tiers = {
    100,
    300,
    500,
    1000,
    2000,
    2500,
    5000,
    10000
  }
  local idx = 0
  for i, tier in ipairs(tiers) do
    if brickNum <= tier then
      idx = i - 1
      break
    end
  end
  local path = string.format("Assets/Main/Sprites/UI/LWGoldBrick/lrb_pc_Goldbricks_%02d.png", idx)
  return path
end

function M:OnShowClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  DataCenter.PayManager:BuyGift(self.data)
end

return M
