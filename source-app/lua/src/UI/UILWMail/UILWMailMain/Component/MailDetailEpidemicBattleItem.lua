local MailDetailEpidemicBattleItem = BaseClass("MailDetailEpidemicBattleItem", UIBaseContainer)
local base = UIBaseContainer

function MailDetailEpidemicBattleItem:OnCreate()
  base.OnCreate(self)
  self.NameText = self:AddComponent(UIText, "name")
  self.PowerText = self:AddComponent(UIText, "power")
  self.DescText = self:AddComponent(UIText, "DescText")
  self.playerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
end

function MailDetailEpidemicBattleItem:OnDestroy()
  self.NameText = nil
  self.PowerText = nil
  self.DescText = nil
  self.playerHead = nil
  base.OnDestroy(self)
end

function MailDetailEpidemicBattleItem:SetData(data)
  if data == nil then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.NameText:SetText(data.name)
  self.playerHead:SetData(data.uid, data.pic, data.picVer)
  self.PowerText:SetText(data.score)
  local type = data.type
  local key = "YiBianJinQu_battle_result_tips_" .. type + 5
  self.DescText:SetLocalText(key)
end

return MailDetailEpidemicBattleItem
