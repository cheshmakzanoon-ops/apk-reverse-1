local LWUIMigrationView_DescItem = BaseClass("LWUIMigrationView_DescItem", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local btn_path = "root/Btn"
local sign_path = "root/Sign"
local text_tip_path = "root/TipText"

function LWUIMigrationView_DescItem:OnCreate()
  base.OnCreate(self)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(BindCallback(self, self.OnBtnClick))
  self.text_tip = self:AddComponent(UIText, text_tip_path)
  self.sign = self:AddComponent(UIImage, sign_path)
end

function LWUIMigrationView_DescItem:OnDestroy()
  self.btn = nil
  self.text_tip = nil
  self.sign = nil
  base.OnDestroy(self)
end

function LWUIMigrationView_DescItem:OnBtnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local strTip = Localization:GetString(self.tipsStr)
  UIUtil.ShowBubbleTips(strTip, self.btn.transform.position, 0, 70, 0, nil, nil, {reversal = true})
end

function LWUIMigrationView_DescItem:SetData(config)
  self.config = config
  self:RefreshView()
end

function LWUIMigrationView_DescItem:UpdateData()
  if self.config == nil then
    return
  end
  local textStr = self.config.nameList or ""
  local imgStr = self.config.iconList or ""
  self.tipsStr = self.config.descList or ""
  self.text_tip:SetLocalText(textStr)
  if not string.IsNullOrEmpty(imgStr) then
    self.sign:LoadSpriteAuto(imgStr)
  end
end

return LWUIMigrationView_DescItem
