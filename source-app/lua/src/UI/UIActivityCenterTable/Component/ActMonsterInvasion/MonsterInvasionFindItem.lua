local MonsterInvasionFindItem = BaseClass("MonsterInvasionFindItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local MonsterIDistanceItem = require("UI.UIActivityCenterTable.Component.ActMonsterInvasion.MonsterIDistanceItem")
local posText_path = "posText"
local btn_path = "btn"
local nameText_path = "nameText"
local txt_Times_path = "TimeContent/Txt_Times"
local attacking_path = "attacking"
local item_bg_path = "item_bg"
local item_icon_path = "item_bg/ItemIcon"
local fullPath = "Assets/Main/Sprites/UI/UIMonsterInvasion/%s.png"
local defaultIcon = "zyf_guaiwuruqin_sangshi"
local fullBgPath = "Assets/Main/Sprites/UI/UISearch/%s.png"
local defaultBgIcon = "zyf_shijiesouguai_guaiwudikuang"
local eff_ui_special_base_path = "item_bg/Eff_ui_special_base"
local eff_ui_broken_path = "item_bg/Eff_ui_broken"
local eff_ui_broken1_path = "item_bg/Eff_ui_broken1"
local distance_group_path = "DistanceGroup"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.posText = self:AddComponent(UIText, posText_path)
  self.nameText = self:AddComponent(UIText, nameText_path)
  self.txt_Times = self:AddComponent(UIText, txt_Times_path)
  self.attacking = self:AddComponent(UIBaseContainer, attacking_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.item_bg = self:AddComponent(UIImage, item_bg_path)
  self.eff_ui_special_base = self:AddComponent(UIImage, eff_ui_special_base_path)
  self.eff_ui_broken = self:AddComponent(UIBaseContainer, eff_ui_broken_path)
  self.eff_ui_broken1 = self:AddComponent(UIBaseContainer, eff_ui_broken1_path)
  self.distance_group = self:AddComponent(MonsterIDistanceItem, distance_group_path)
end

local function ComponentDestroy(self)
  self.posText = nil
  self.nameText = nil
  self.txt_Times = nil
  self.btn = nil
  self.attacking = nil
  self.item_icon = nil
  self.eff_ui_special_base = nil
  self.eff_ui_broken = nil
  self.eff_ui_broken1 = nil
  self.item_bg = nil
  self.distance_group = nil
end

local function DataDefine(self)
  self.timer = nil
end

local function DataDestroy(self)
  if self.timer then
    self.timer:Stop()
  end
  self.timer = nil
end

local function ReInit(self, param, selectType, resourcePathList)
  self.param = param
  self.selectType = selectType
  local resourcePath = resourcePathList
  local pointId = self.param.targetPos
  local posStr = ""
  local posTxtColor = Color.New(0.07450980392156863, 0.7411764705882353, 0.3686274509803922, 1)
  if self.selectType == MonsterInvasionFindSelectType.Self then
    local pos = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
    posStr = string.format("(%s,%s)", toInt(pos.x), toInt(pos.y))
  elseif self.selectType == MonsterInvasionFindSelectType.Alliance then
    posStr = self.param.ownerName
    posTxtColor = Color.New(0.32941176470588235, 0.7686274509803922, 0.9490196078431372, 1)
  end
  self.posText:SetColor(posTxtColor)
  self.posText:SetText(posStr)
  local monsterId = self.param.monsterId
  self.eff_ui_special_base:SetActive(false)
  self.eff_ui_broken:SetActive(false)
  self.eff_ui_broken1:SetActive(false)
  if not string.IsNullOrEmpty(monsterId) then
    local showStr = ""
    local template = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
    if template then
      local name = template.name
      local level = template.level
      local lvString = Localization:GetString("300665", level)
      local nameStr = Localization:GetString(name)
      local monsterIcon = template.pic
      showStr = lvString .. " " .. nameStr
      self.nameText:SetText(showStr)
      local special = template.special
      if special == WorldMonsterSpecialType.InvasionBigBoss then
        local actData = DataCenter.ActivityMonsterInvasionDataManager:GetActivityData()
        if actData and not string.IsNullOrEmpty(actData.challengeIcon) then
          self.item_icon:LoadSpriteAsync(actData.challengeIcon)
        end
        self.eff_ui_special_base:SetActive(true)
      else
        self.item_icon:LoadSprite(string.format(fullPath, monsterIcon))
      end
      local find = false
      for _, v in ipairs(resourcePath) do
        if level >= v.minLevel and level <= v.maxLevel then
          self.item_bg:LoadSprite(string.format(fullBgPath, v.resourcePath))
          find = true
          break
        end
      end
      if not find then
        self.item_bg:LoadSprite(string.format(fullBgPath, defaultBgIcon))
      end
    end
  end
  if not self.param.isAtk then
    self.distance_group:ReInit(pointId)
  end
  self.distance_group:SetActive(not self.param.isAtk)
  self.attacking:SetActive(self.param.isAtk == true)
  self:Update1000MS()
end

local function OnBtnClick(self)
  local pointId = self.param.targetPos
  local pointUuid = self.param.uuid
  local serverId = self.param.server
  GoToUtil.CloseAllWindows()
  GoToUtil.MoveToWorldPointAndOpen(pointId, nil, pointUuid, serverId, 0)
end

local function Update1000MS(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.param.refreshTime - curTime
  if leftTime < 0 then
    leftTime = 0
    self.gameObject:SetActive(false)
    return
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  if leftTime <= 1800000 then
    countDownTimeStr = "<color=#FF0000>" .. countDownTimeStr .. "</color>"
  end
  self.txt_Times:SetText(countDownTimeStr)
end

local function PlayBrokenEffect(self)
  if self.eff_ui_broken and self.eff_ui_broken1 then
    self.eff_ui_broken:SetActive(true)
    self.eff_ui_broken1:SetActive(true)
    if self.timer then
      self.timer:Stop()
    end
  end
end

local function GetPos(self)
  if self.item_icon then
    return self.item_icon.transform.position
  end
end

MonsterInvasionFindItem.OnCreate = OnCreate
MonsterInvasionFindItem.OnDestroy = OnDestroy
MonsterInvasionFindItem.ComponentDefine = ComponentDefine
MonsterInvasionFindItem.ComponentDestroy = ComponentDestroy
MonsterInvasionFindItem.DataDefine = DataDefine
MonsterInvasionFindItem.DataDestroy = DataDestroy
MonsterInvasionFindItem.ReInit = ReInit
MonsterInvasionFindItem.OnBtnClick = OnBtnClick
MonsterInvasionFindItem.Update1000MS = Update1000MS
MonsterInvasionFindItem.PlayBrokenEffect = PlayBrokenEffect
MonsterInvasionFindItem.GetPos = GetPos
return MonsterInvasionFindItem
