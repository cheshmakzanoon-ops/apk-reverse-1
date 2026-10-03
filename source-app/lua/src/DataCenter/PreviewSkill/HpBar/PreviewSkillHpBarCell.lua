local base = require("DataCenter.ZombieBattle.HpBar.HpBarCell")
local PreviewSkillHpBarCell = BaseClass("PreviewSkillHpBarCell", base)
local Resource = CS.GameEntry.Resource
local UnityRectTransform = typeof(CS.UnityEngine.RectTransform)
local Const = require("Scene.LWBattle.Const")
local UnityText = typeof(CS.UnityEngine.UI.Text)
local greenBarPath = "Assets/Main/Prefabs/LWBattle/HpBarGreen.prefab"
local hp_fg = "Content/fg"
local hp_text = "Content/text"

function PreviewSkillHpBarCell:LoadAndSetHp(curHp, maxHp)
  self.req = Resource:InstantiateAsync(self:GetBarAsset())
  self.req:completed("+", function(req)
    local go = req.gameObject
    local hpBarParent = DataCenter.PreviewSkillEffectManager:GetHpBarParent()
    if IsNull(hpBarParent) then
      return
    end
    go.transform:SetParent(hpBarParent.transform)
    self.gameObject = go
    self.transform = go.transform
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self:InitComponent()
    self:SetHp(curHp, maxHp)
  end)
end

function PreviewSkillHpBarCell:Load()
  self.req = Resource:InstantiateAsync(self:GetBarAsset())
  self.req:completed("+", function(req)
    local go = req.gameObject
    local hpBarParent = DataCenter.PreviewSkillEffectManager:GetHpBarParent()
    if IsNull(hpBarParent) then
      return
    end
    go.transform:SetParent(hpBarParent.transform)
    self.gameObject = go
    self.transform = go.transform
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self:InitComponent()
  end)
end

function PreviewSkillHpBarCell:UpdatePos()
  local modelPos = self.target.position + Vector3.New(0, self.height, 0)
  local newPos = DataCenter.PreviewSkillEffectManager:GetHpBarCellPos(modelPos)
  self.transform:Set_localPosition(newPos.x, newPos.y, 0)
end

return PreviewSkillHpBarCell
