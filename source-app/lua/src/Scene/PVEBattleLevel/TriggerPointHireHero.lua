local TriggerPointHeroModel = BaseClass("TriggerPointHeroModel")
local Resource = CS.GameEntry.Resource
local PveLineup = require("Scene.BattlePveModule.PveLineup")
local top_path = "Top"
local level_path = "Top/Level"
local star_path = "Top/Star%s"
local bottom_path = "Bottom"

function TriggerPointHeroModel:__init(trigger)
  self.trigger = trigger
  self.heroReq = nil
  self.materialPropertyBlock = CS.UnityEngine.MaterialPropertyBlock()
  self.heroSignPropertyId = CS.UnityEngine.Shader.PropertyToID("_Color")
end

function TriggerPointHeroModel:__delete()
  self.trigger = nil
  self.heroReq = nil
  self.materialPropertyBlock = nil
  self.heroSignPropertyId = nil
end

function TriggerPointHeroModel:Create(transform)
  local heroData = self.trigger.config.heroData
  local modelName = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "prefab_low_exp")
  local modelPath = DataCenter.BattleLevel:GetPlayerModelPath(modelName)
  self.heroReq = Resource:InstantiateAsync(modelPath)
  self.heroReq:completed("+", function(req)
    if req.isError then
      return
    end
    local tf = req.gameObject.transform
    tf:SetParent(self.trigger.gameObject.transform)
    tf:Set_localPosition(0, 0, 0)
    tf.localRotation = Quaternion.identity
  end)
  local topGo = transform:Find(top_path).gameObject
  local levelText = transform:Find(level_path):GetComponent(typeof(CS.SuperTextMesh))
  levelText.text = "Lv." .. heroData.level
  for i = 1, 5 do
    local starGo = transform:Find(string.format(star_path, i)).gameObject
    if i <= heroData.quality then
      local x = (i * 2 - heroData.quality - 1) * 0.2
      starGo:SetActive(true)
      starGo.transform.localPosition = Vector3.New(x, 0, 0)
    else
      starGo:SetActive(false)
    end
  end
  self.trigger.textObj = topGo
  local bottomGo = transform:Find(bottom_path).gameObject
  local rarityIcon = {
    go = bottomGo,
    render1 = bottomGo.transform:GetComponent(typeof(CS.UnityEngine.Renderer)),
    render2 = bottomGo.transform:Find("V_plane"):GetComponent(typeof(CS.UnityEngine.Renderer))
  }
  self:SetRarity(rarityIcon, heroData.rarity)
end

function TriggerPointHeroModel:Destroy()
  if self.heroReq then
    self.heroReq:Destroy()
  end
end

function TriggerPointHeroModel:SetRarity(rarityIcon, rarity)
  if rarity and 0 < rarity then
    local vector1 = PveLineup.SignColors[rarity].Center
    vector1.w = 1
    local vector2 = PveLineup.SignColors[rarity].Border
    vector2.w = 1
    rarityIcon.go:SetActive(true)
    self.materialPropertyBlock:SetVector(self.heroSignPropertyId, vector1)
    rarityIcon.render1:SetPropertyBlock(self.materialPropertyBlock)
    self.materialPropertyBlock:SetVector(self.heroSignPropertyId, vector2)
    rarityIcon.render2:SetPropertyBlock(self.materialPropertyBlock)
  else
    rarityIcon.go:SetActive(false)
  end
end

return TriggerPointHeroModel
