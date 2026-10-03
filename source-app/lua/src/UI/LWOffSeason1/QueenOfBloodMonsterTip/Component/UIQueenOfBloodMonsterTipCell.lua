local base = UIBaseContainer
local UIQueenOfBloodMonsterTipCell = BaseClass("UIQueenOfBloodMonsterTipCell", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIQueenOfBloodMonsterTipCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIQueenOfBloodMonsterTipCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIQueenOfBloodMonsterTipCell:ComponentDefine()
  self.textName = self:AddComponent(UITextMeshProUGUIEx, "NameText")
  self.textDes = self:AddComponent(UITextMeshProUGUIEx, "DesText")
  self.textTip = self:AddComponent(UITextMeshProUGUIEx, "TipText")
  self.imgMonsterIcon = self:AddComponent(UIImage, "MonsterIcon")
  self.textScore = self:AddComponent(UITextMeshProUGUIEx, "ScoreText")
end

function UIQueenOfBloodMonsterTipCell:ComponentDestroy()
  self.textName = nil
  self.textDes = nil
  self.textTip = nil
  self.imgMonsterIcon = nil
  self.textScore = nil
end

function UIQueenOfBloodMonsterTipCell:DataDefine()
end

function UIQueenOfBloodMonsterTipCell:DataDestroy()
end

function UIQueenOfBloodMonsterTipCell:OnAddListener()
  base.OnAddListener(self)
end

function UIQueenOfBloodMonsterTipCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIQueenOfBloodMonsterTipCell:SetData(data)
  local cfg = DataCenter.MonsterTemplateManager:GetMonsterTemplate(data.monsterId)
  self.imgMonsterIcon:LoadSpriteAuto(cfg:GetIcon())
  self.textName:SetLocalText(cfg.name)
  self.textDes:SetLocalText(cfg.desc)
  self.textTip:SetLocalText(data.tipId)
  self.textScore:SetLocalText("300644", string.GetFormattedStr0(cfg.recommend_power))
end

return UIQueenOfBloodMonsterTipCell
