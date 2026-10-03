local base = require("DataCenter.PreviewSkill.HpBar.PreviewSkillHpBarCell")
local PreviewSkillMultHpBarCell = BaseClass("PreviewSkillMultHpBarCell", base)
local Const = require("Scene.LWBattle.Const")
local asset = "Assets/Main/Prefabs/LWBattle/MultHpBar.prefab"
local hp_fg1 = "Content/fg1"
local hp_fg2 = "Content/fg2"
local hp_text = "Content/text"
local Resource = CS.GameEntry.Resource
local UnitySlider = typeof(CS.UnityEngine.UI.Slider)
local UnityText = typeof(CS.UnityEngine.UI.Text)

function PreviewSkillMultHpBarCell:__init(style, transform, height, barNum)
  self.barNum = barNum
end

function PreviewSkillMultHpBarCell:Load()
  self.req = Resource:InstantiateAsync(asset)
  self.req:completed("+", function(req)
    local go = req.gameObject
    local hpBarParent = DataCenter.PreviewSkillEffectManager:GetHpBarParent()
    if IsNull(hpBarParent) then
      return
    end
    go.transform:SetParent(hpBarParent.transform)
    self.gameObject = go
    self.transform = go.transform
    self:InitComponent()
  end)
end

function PreviewSkillMultHpBarCell:InitComponent()
  self.fg1 = self.transform:Find(hp_fg1):GetComponent(UnitySlider)
  self.fg2 = self.transform:Find(hp_fg2):GetComponent(UnitySlider)
  self.text = self.transform:Find(hp_text):GetComponent(UnityText)
  self:SetHp(1, 1)
end

function PreviewSkillMultHpBarCell:SetHp(curHp, maxHp)
  if not self.gameObject then
    return
  end
  local percent = curHp / maxHp
  if percent == 0 then
    self.fg1.value = 0
    self.fg2.value = 0
    self.text.text = "x0"
    return
  end
  local step = 1 / self.barNum
  local result = {}
  for i = 1, self.barNum do
    local value = math.min(step, percent)
    percent = percent - value
    if 0 < value then
      table.insert(result, value)
    end
  end
  local v1 = result[#result]
  local v2 = result[#result - 1]
  if v1 then
    local bar1, bar2
    if #result % 2 == 0 then
      bar1 = self.fg1
      bar2 = self.fg2
    else
      bar1 = self.fg2
      bar2 = self.fg1
    end
    bar1.transform:SetAsLastSibling()
    bar1.value = v1 / step
    if v2 then
      bar2.value = 1
    else
      bar2.value = 0
    end
  end
  self.text.text = "x" .. #result
end

return PreviewSkillMultHpBarCell
