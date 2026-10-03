local LWUIMigrationView_GroupCell = BaseClass("LWUIMigrationView_GroupCell", UIBaseContainer)
local base = UIBaseContainer
local bg_path = "Bg"
local text_path = "Text"

function LWUIMigrationView_GroupCell:OnCreate()
  base.OnCreate(self)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(BindCallback(self, self.OnClick))
  self.bg = self:AddComponent(UIImage, bg_path)
  self.text = self:AddComponent(UIText, text_path)
end

function LWUIMigrationView_GroupCell:OnDestroy()
  self.cb = nil
  base.OnDestroy(self)
end

function LWUIMigrationView_GroupCell:OnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.cb then
    self.cb(self.type, self.num)
  end
end

function LWUIMigrationView_GroupCell:SetData(type, num, cb, idx)
  self.type = type
  self.num = num
  self.cb = cb
  self.bg:SetActive(idx % 2 == 0)
  self.text:SetText(string.GetFormattedSeparatorNum(math.floor(num)))
end

return LWUIMigrationView_GroupCell
