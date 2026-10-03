local MeteoriteStates = BaseClass("MeteoriteStates", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local crystal_node_path = "crystalNode"
local nucleus_node_path = "nucleusNode"
local img_line_path = "imgLine"
local tmp_crystal_count_path = "crystalNode/tmpCrystalCount"
local tmp_crystal_speed_path = "crystalNode/tmpCrystalSpeed"
local tmp_nucleus_count_path = "nucleusNode/tmpNucleusCount"
local tmp_nucleus_speed_path = "nucleusNode/tmpNucleusSpeed"
local drop_crystal_path = "crystalNode/dropCrystal"
local drop_nucleus_path = "nucleusNode/dropNucleus"

function MeteoriteStates:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function MeteoriteStates:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MeteoriteStates:ComponentDefine()
  self.objCrystal = self.transform:Find(crystal_node_path).gameObject
  self.objNucleus = self.transform:Find(nucleus_node_path).gameObject
  self.objImg = self.transform:Find(img_line_path).gameObject
  self.tmp_crystal_count = self:AddComponent(UITextMeshProUGUIEx, tmp_crystal_count_path)
  self.tmp_crystal_speed = self:AddComponent(UITextMeshProUGUIEx, tmp_crystal_speed_path)
  self.tmp_nucleus_count = self:AddComponent(UITextMeshProUGUIEx, tmp_nucleus_count_path)
  self.tmp_nucleus_speed = self:AddComponent(UITextMeshProUGUIEx, tmp_nucleus_speed_path)
  self.drop_crystal = self:AddComponent(UIButton, drop_crystal_path)
  self.drop_nucleus = self:AddComponent(UIButton, drop_nucleus_path)
end

function MeteoriteStates:ComponentDestroy()
  self.pointId = nil
  self.userId = nil
  self.tmp_crystal_count = nil
  self.tmp_crystal_speed = nil
  self.tmp_nucleus_count = nil
  self.objCrystal = nil
  self.objNucleus = nil
  self.objImg = nil
end

function MeteoriteStates:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UPDATE_POINTS_DATA, self.RefreshView)
end

function MeteoriteStates:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UPDATE_POINTS_DATA, self.RefreshView)
end

function MeteoriteStates:Refresh(userId, pointId)
  self.pointId = pointId
  self.userId = userId
  self:RefreshView()
end

function MeteoriteStates:RefreshView()
  ProfilerUtil.BeginSample("MeteoriteStates:RefreshView")
  if not self.pointId then
    self.objCrystal:SetActive(false)
    self.objNucleus:SetActive(false)
    self.objImg:SetActive(false)
    ProfilerUtil.EndSample()
    return
  end
  if not self.userId or self.userId ~= LuaEntry.Player.uid then
    self.drop_crystal:SetActive(false)
    self.drop_nucleus:SetActive(false)
  else
    self.drop_crystal:SetActive(false)
    self.drop_nucleus:SetActive(false)
  end
  self.pointInfo = CS.SceneManager.World:GetPointInfoByUuid(self.pointId)
  cast(self.pointInfo, typeof(CS.BuildPointInfo))
  if not self.pointInfo then
    self.objCrystal:SetActive(false)
    self.objNucleus:SetActive(false)
    self.objImg:SetActive(false)
    ProfilerUtil.EndSample()
    return
  end
  local crystalCount = self.pointInfo.crystal or 0
  local nucleusCount = self.pointInfo.nucleus or 0
  if crystalCount <= 0 and nucleusCount <= 0 then
    self.objCrystal:SetActive(false)
    self.objNucleus:SetActive(false)
    self.objImg:SetActive(false)
    ProfilerUtil.EndSample()
    return
  end
  local ID_CRYSTAL = 101
  local ID_NUCLEUS = 102
  if 0 < crystalCount then
    local config = DataCenter.ActMeteoriteBattleManager:GetEntityConfigById(ID_CRYSTAL)
    local spd = config and tonumber(config.point_produce_per_second_on_base) or 0
    local name = Localization:GetString(config.name)
    self.objCrystal:SetActive(true)
    self.tmp_crystal_count:SetText(string.format("%s:<b>x%s</b>", name, crystalCount))
    self.tmp_crystal_speed:SetText(string.format("%s/s", crystalCount * spd))
  else
    self.objCrystal:SetActive(false)
  end
  if 0 < nucleusCount then
    local config = DataCenter.ActMeteoriteBattleManager:GetEntityConfigById(ID_NUCLEUS)
    local spd = config and tonumber(config.point_produce_per_second_on_base) or 0
    local name = Localization:GetString(config.name)
    self.objNucleus:SetActive(true)
    self.tmp_nucleus_count:SetText(string.format("%s:<b>x%s</b>", name, nucleusCount))
    self.tmp_nucleus_speed:SetText(string.format("%s/s", nucleusCount * spd))
  else
    self.objNucleus:SetActive(false)
  end
  self.objImg:SetActive(0 < nucleusCount and 0 < crystalCount)
  ProfilerUtil.EndSample()
end

function MeteoriteStates:UpdatePointDataSignal()
  self:RefreshView()
end

function MeteoriteStates:DropCrystal()
  if DataCenter.ActMeteoriteBattleManager:NeedNoticeManualDrop() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMeteoriteDropNoticeNotice, {anim = true}, {
      ok = function()
        DataCenter.ActMeteoriteBattleManager:HiDaddyIWantDropMeteorite(101)
        UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldPoint)
      end,
      notice = "yuntieBattle_tips_1008",
      crystal = 1,
      nucleus = 0,
      ignoreKey = SettingKeys.NO_METEORITE_DROP_PROMPT2
    })
  else
    DataCenter.ActMeteoriteBattleManager:HiDaddyIWantDropMeteorite(101)
    UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldPoint)
  end
end

function MeteoriteStates:DropNucleus()
  if DataCenter.ActMeteoriteBattleManager:NeedNoticeManualDrop() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMeteoriteDropNoticeNotice, {anim = true}, {
      ok = function()
        DataCenter.ActMeteoriteBattleManager:HiDaddyIWantDropMeteorite(102)
        UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldPoint)
      end,
      notice = "yuntieBattle_tips_1008",
      crystal = 0,
      nucleus = 1,
      ignoreKey = SettingKeys.NO_METEORITE_DROP_PROMPT2
    })
  else
    DataCenter.ActMeteoriteBattleManager:HiDaddyIWantDropMeteorite(102)
    UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldPoint)
  end
end

return MeteoriteStates
