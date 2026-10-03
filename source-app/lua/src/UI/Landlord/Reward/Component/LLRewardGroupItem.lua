local base = UIBaseContainer
local LLRewardGroupItem = BaseClass("LLRewardGroupItem", UIBaseContainer)
local bg_path = "Bg"
local text_path = "Text"
local arrow_path = "Arrow"

function LLRewardGroupItem:OnCreate()
  base.OnCreate(self)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.arrow = self:AddComponent(UIImage, arrow_path)
end

function LLRewardGroupItem:OnDestroy()
  self.bg = nil
  self.text = nil
  self.arrow = nil
  self.cb = nil
  base.OnDestroy(self)
end

function LLRewardGroupItem:OnBtnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.cb then
    self.cb(self.idx)
  end
end

function LLRewardGroupItem:SetData(idx, curIdx, cb)
  self.idx = idx
  self.cb = cb
  local bCur = idx == curIdx
  self.bg:SetActive(bCur)
  local key = DataCenter.LandlordMgr:GetRankTypeKey(idx)
  self.text:SetLocalText(key)
  self.text:SetColorHex(bCur and "#2A2830" or "#7D7A8A")
  self.arrow:SetActive(bCur)
end

return LLRewardGroupItem
