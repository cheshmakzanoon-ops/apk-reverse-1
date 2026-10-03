local base = UIBaseContainer
local LLRuleBuildGroupItem = BaseClass("LLRuleBuildGroupItem", UIBaseContainer)
local ActMgr = DataCenter.LandlordMgr
local bg_path = "Bg"
local text_path = "Text"
local arrow_path = "Arrow"

function LLRuleBuildGroupItem:OnCreate()
  base.OnCreate(self)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.arrow = self:AddComponent(UIImage, arrow_path)
end

function LLRuleBuildGroupItem:OnDestroy()
  self.bg = nil
  self.text = nil
  self.arrow = nil
  self.cb = nil
  base.OnDestroy(self)
end

function LLRuleBuildGroupItem:OnBtnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.cb then
    self.cb(self.idx)
  end
end

function LLRuleBuildGroupItem:SetData(config, idx, curIdx, cb)
  self.idx = idx
  self.cb = cb
  local bCur = idx == curIdx
  self.bg:SetActive(bCur)
  self.text:SetLocalText(config.tittle)
  self.text:SetColorHex(bCur and "#2A2830" or "#7D7A8A")
  self.arrow:SetActive(bCur)
end

return LLRuleBuildGroupItem
