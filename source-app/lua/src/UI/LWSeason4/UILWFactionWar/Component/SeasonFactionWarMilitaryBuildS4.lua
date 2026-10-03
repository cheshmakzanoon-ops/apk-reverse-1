local base = UIButton
local SeasonFactionWarMilitaryBuildS4 = BaseClass("SeasonFactionWarMilitaryBuildS4", base)
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization

function SeasonFactionWarMilitaryBuildS4:OnCreate()
  base.OnCreate(self)
  self.hp_bar = self:AddComponent(UISlider, "HPBar")
  self.statusRoot = self:AddComponent(UIBaseContainer, "status")
  self.statusIcon = self:AddComponent(UIImage, "status/icon")
  self.statusText = self:AddComponent(UITextMeshProUGUIEx, "status/StatusText")
  self:SetOnClick(function()
    if self.parentView and self.fightResult ~= 0 then
      pcall(self.parentView.OnBuildClick, self.parentView, self, self.lootNumChangeList, self.scoreList, self.buildData)
    elseif self.buildData and self.linkInfo then
      GoToUtil.TryJumpToWorld(self.linkInfo)
    end
  end)
end

function SeasonFactionWarMilitaryBuildS4:OnDestroy()
  self.hp_bar = nil
  self.statusRoot = nil
  self.statusIcon = nil
  self.statusText = nil
  base.OnDestroy(self)
end

function SeasonFactionWarMilitaryBuildS4:ReInit(view, buildId, data, s3lootNumChangeObj, fightResult)
  self.data = data
  self.parentView = view
  self.fightResult = fightResult
  if data and data.buildList then
    for k, v in pairs(data.buildList) do
      if v and v.buildId == buildId then
        self.buildData = v
        break
      end
    end
  end
  if data and data.scoreList and self.buildData then
    for k, v in pairs(data.scoreList) do
      if v and v.uuid == self.buildData.uuid then
        self.scoreList = v.list
        break
      end
    end
  end
  if s3lootNumChangeObj and self.buildData then
    for k, v in pairs(s3lootNumChangeObj) do
      if v and v.uuid == self.buildData.uuid then
        self.lootNumChangeList = v.list
        break
      end
    end
  end
  local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(buildId)
  if meta ~= nil then
    self:LoadSprite(meta:GetIconPath())
  end
  if self.buildData then
    if self.buildData.durability == 0 then
      self.hp_bar:SetActive(false)
      self.statusRoot:SetActive(true)
      self.statusIcon:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/LWCommon/zxl_tubiao_xiuli.png")
      self.statusText:SetText("<color=#F97077>" .. Localization:GetString("season_s3_alliance_building_ui06") .. "</color>")
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.statusRoot.transform)
    else
      self.statusRoot:SetActive(false)
      local hp = toInt(self.buildData.durability)
      local hpMax = toInt(self.buildData.maxdurability)
      if hp ~= hpMax and hpMax ~= 0 then
        self.hp_bar:SetActive(true)
        self.hp_bar:SetValue(math.max(hp / hpMax, 0.05))
      else
        self.hp_bar:SetActive(false)
      end
    end
    if self.buildData and self.buildData.pointId then
      local link = {
        action = "Jump",
        pointId = self.buildData.pointId,
        server = self.buildData.buildServerId,
        worldId = 0
      }
      self.linkInfo = link
    end
  else
    self.hp_bar:SetActive(false)
    self.statusRoot:SetActive(true)
    self.statusIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_tubiao_suo.png")
    self.statusText:SetText("<color=#FFFFFF>" .. Localization:GetString("2000292") .. "</color>")
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.statusRoot.transform)
  end
end

return SeasonFactionWarMilitaryBuildS4
