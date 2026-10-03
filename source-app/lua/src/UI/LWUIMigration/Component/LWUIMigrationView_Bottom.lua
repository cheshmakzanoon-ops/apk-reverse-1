local LWUIMigrationView_Bottom = BaseClass("LWUIMigrationView_Bottom", UIAsyncContainer)
local base = UIAsyncContainer
local btn_point_path = "PointDesc"
local img_type_path = "PointNum/PointIcon"
local text_point_path = "PointNum/PointNumText"
local btn_item_path = "Item"
local img_item_path = "Item/Icon"
local text_item_path = "Item/ItemNumText"

function LWUIMigrationView_Bottom:OnCreate()
  base.OnCreate(self)
  self.btn_point = self:AddComponent(UIButton, btn_point_path)
  self.btn_point:SetOnClick(BindCallback(self, self.OnBtnPointClick))
  self.img_type = self:AddComponent(UIImage, img_type_path)
  self.text_point = self:AddComponent(UIText, text_point_path)
  self.btn_item = self:AddComponent(UIButton, btn_item_path)
  self.btn_item:SetOnClick(BindCallback(self, self.OnBtnItemClick))
  self.img_item = self:AddComponent(UIImage, img_item_path)
  local iconPath = DataCenter.ActMigrationManager:GetItemIcon()
  if iconPath then
    self.img_item:LoadSpriteAuto(iconPath)
  end
  self.text_item = self:AddComponent(UIText, text_item_path)
  if self.text_item.unity_tmpro then
    self.text_item.unity_tmpro.richText = true
  end
end

function LWUIMigrationView_Bottom:OnDestroy()
  base.OnDestroy(self)
end

function LWUIMigrationView_Bottom:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.RefreshView)
end

function LWUIMigrationView_Bottom:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshView)
  base.OnRemoveListener(self)
end

function LWUIMigrationView_Bottom:OnBtnPointClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMigrationScore, {anim = true}, false)
end

function LWUIMigrationView_Bottom:OnBtnItemClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  GoToUtil.GotoMigrationTicketShop()
end

function LWUIMigrationView_Bottom:UpdateData()
  local mgr = DataCenter.ActMigrationManager
  local myInfo = mgr:GetMyInfo()
  local migrated = myInfo ~= nil and myInfo.migrated or 0
  local identity = myInfo ~= nil and myInfo.identity or 0
  local imgPath = mgr:GetPlayerTypeImg(identity)
  self.img_type:LoadSpriteAuto(imgPath)
  local curHave = mgr:GetItemHave()
  local pInfo = mgr:GetMyPersonStandard()
  self.text_point:SetLocalText(pInfo ~= nil and pInfo.name or "")
  local costNum = pInfo ~= nil and pInfo.cost or 1
  if migrated == 1 then
    costNum = 0
  end
  local str = curHave < costNum and "<color=#f53c3d>" or "<color=#099b4a>"
  self.text_item:SetText(str .. curHave .. "</color>/" .. costNum)
end

return LWUIMigrationView_Bottom
