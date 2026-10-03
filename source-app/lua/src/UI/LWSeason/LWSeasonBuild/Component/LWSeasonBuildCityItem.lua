local LWSeasonBuildCityItem = BaseClass("LWSeasonBuildCityItem", UIBaseContainer)
local base = UIBaseContainer
local UnityText = typeof(CS.UnityEngine.UI.Text)
local Localization = CS.GameEntry.Localization
local icon_path = "bg/icon"
local slider_path = "bg/Slider"
local hp_txt_path = "bg/Slider/hpTxt"
local name_path = "name"
local desc_path = "desc"
local pos_path = "pos"
local info_btn_path = "InfoBtn"
local btn_build_path = "BtnBuild"
local btn_text_path = "BtnBuild/BtnText"
local red_point_path = "BtnBuild/RedPoint"
local common_path = "ScrollView/Viewport/Common"
local item_path = "ScrollView/Viewport/Common/item"

function LWSeasonBuildCityItem:OnCreate()
  base.OnCreate(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.name = self:AddComponent(UIText, name_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.hp_txt = self:AddComponent(UIText, hp_txt_path)
  self.pos_text = self:AddComponent(UIText, pos_path)
  self.btn_text = self:AddComponent(UIText, btn_text_path)
  self.BuffList = self:AddComponent(UIBaseContainer, common_path)
  self.theItem = self:AddComponent(UIBaseContainer, item_path)
  self.theItem.gameObject:GameObjectCreatePool()
  self.red_point = self:AddComponent(UIImage, red_point_path)
  self.red_point:SetActive(false)
  self.slider:SetActive(false)
  self.pos_btn = self:AddComponent(UIButton, pos_path)
  self.pos_btn:SetOnClick(function()
    if self.buildData and self.buildData.pointId then
      local serverId = LuaEntry.Player:GetSourceServerId()
      GoToUtil.CloseAllWindows()
      local pos = SceneUtils.TileIndexToWorld(self.buildData.pointId, ForceChangeScene.World)
      GoToUtil.GotoWorldPos(pos, nil, nil, function()
      end, serverId, 0)
    end
  end)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    if self.config and self.config.long_description then
      UIUtil.ShowDetail(Localization:GetString(self.config.long_description))
    end
  end)
  self.btnBuild = self:AddComponent(UIButton, btn_build_path)
  self.btnBuild:SetOnClick(function()
    local serverId = LuaEntry.Player:GetSourceServerId()
    if self.buildData then
      GoToUtil.CloseAllWindows()
      if LuaEntry.Player:AtHomeNow() then
        GoToUtil.MoveToWorldPointAndOpen(self.buildData.pointId, nil, nil, serverId, 0)
      else
        local pos = SceneUtils.TileIndexToWorld(self.buildData.pointId, ForceChangeScene.World)
        GoToUtil.GotoWorldPos(pos, nil, nil, function()
        end, serverId, 0)
      end
    elseif self.mineInfo ~= nil then
      if self.mineInfo.status == AllianceMineStatus.Build then
        UIUtil.ShowTipsId("season_tips109")
        return
      end
      if self.buildTemplate then
        local effectCondition = self.buildTemplate.effectCondition
        if effectCondition and effectCondition.effectId then
          local effectId = effectCondition.effectId
          local effectValue = LuaEntry.Effect:GetGameEffect(effectId)
          local effectName = GetTableData(TableName.LW_Effect_Number, effectId, "name")
          if effectValue == nil or effectValue == 0 then
            UIUtil.ShowTips(Localization:GetString("454101", Localization:GetString(effectName)))
            local tmp = DataCenter.AllianceScienceTemplateManager:GetAlScienceTemplateByBuffId(effectId)
            if tmp then
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceScience, {anim = true, hideTop = true}, {
                autoOpenRecScience = false,
                openScienceId = toInt(tmp.science_id)
              })
            end
            return
          end
        end
      end
      if LuaEntry.Player:AtHomeNow() then
        local cityPos = SceneUtils.TileIndexToWorld(self.mineInfo.pointId, ForceChangeScene.World)
        GoToUtil.GotoWorldPos(Vector3.New(cityPos.x, 0, cityPos.z - 4), nil, nil, function()
          local pointId = SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget)
          GoToUtil.CloseAllWindows()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildList, self.data.id, nil, nil, 1, pointId)
        end)
      else
        UIUtil.ShowMessage(Localization:GetString("season_tips142", Localization:GetString(self.config.name)), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          CrossServerUtil.BackToSrcServer()
        end)
      end
    elseif self.allianceCenterData then
      UIUtil.ShowTips(Localization:GetString("170385", Localization:GetString(self.allianceCenterData.name)))
    end
  end)
end

function LWSeasonBuildCityItem:OnDestroy()
  self.theItem.gameObject:GameObjectRecycleAll()
  base.OnDestroy(self)
end

function LWSeasonBuildCityItem:ReInit(tabIndex, index, data, mineInfo, allianceCenterBaseId)
  self.tabIndex = tabIndex
  self.index = index
  self.data = data
  self.mineInfo = mineInfo
  self.allianceCenterBaseId = allianceCenterBaseId
  self.buildData = nil
  self.allianceCenterData = DataCenter.AllianceMineManager:GetAllianceMineTemplate(allianceCenterBaseId)
  self.config = data.buildTemplate
  self.desc:SetLocalText(self.config.des)
  self.icon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(data.id, 1), DefaultImage)
  self.buildTemplate = self.config
  self.buildCurLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(data.id, 1)
  self.red_point:SetActive(false)
  if self.mineInfo == nil then
    self.btn_text:SetLocalText("season_building_UI102")
    self.pos_btn:SetActive(false)
    self.name:SetText(Localization:GetString(self.config.name))
    CS.UIGray.SetGray(self.btnBuild.transform, true, true)
  else
    local buildLevel = 0
    local buildDic = DataCenter.DesertDataManager:GetSeasonBuildList()
    for k, v in pairs(buildDic) do
      if v.itemId == data.id and v.posV2 and v.pointId then
        self.buildData = v
        buildLevel = v.level
        if buildLevel == 0 then
          self.buildCurLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(data.id, 1)
        else
          self.buildCurLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(data.id, buildLevel)
        end
        self.pos_text:SetText(string.format("( X:%s Y:%s )", v.posV2.x, v.posV2.y))
        break
      end
    end
    if self.buildData == nil then
      local thePlayerBuildList = DataCenter.SeasonDataManager.PlayerBuildList
      if thePlayerBuildList then
        for k, v in ipairs(thePlayerBuildList) do
          if v.id and v.pointId then
            local buildId = toInt(v.id)
            local level = buildId % 1000
            if buildId - level == data.id then
              if 0 < level and v.state ~= BuildingStateType.FoldUp then
                local posV2 = SceneUtils.IndexToTilePos(v.pointId, ForceChangeScene.World)
                self.buildData = {
                  pointId = v.pointId,
                  posV2 = posV2,
                  level = level
                }
                self.pos_text:SetText(string.format("( X:%s Y:%s )", posV2.x, posV2.y))
              end
              buildLevel = level
              self.buildCurLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(data.id, buildLevel)
              break
            end
          end
        end
      end
    end
    if buildLevel == 0 then
      self.name:SetText(Localization:GetString(self.config.name))
    else
      self.name:SetLocalText(310161, Localization:GetString(self.config.name), buildLevel)
    end
    if self.buildData == nil then
      self.btn_text:SetLocalText("season_building_UI102")
      self.red_point:SetActive(SeasonUtil.CanBuildPlayerBuilding(self.config.id))
    else
      if buildLevel == 0 then
        self.name:SetLocalText(130084, Localization:GetString(self.config.name))
      end
      self.btn_text:SetLocalText("110003")
      self.red_point:SetActive(false)
    end
    self.pos_btn:SetActive(self.buildData ~= nil)
    CS.UIGray.SetGray(self.btnBuild.transform, false, true)
  end
  self:ShowDesCells()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.BuffList.transform)
end

function LWSeasonBuildCityItem:ShowDesCells()
  local curNums = self.buildCurLevelTemplate.local_num
  local maxCount = table.count(curNums)
  local diaCount = table.count(self.buildTemplate.effect_Local_dialog)
  if maxCount > diaCount then
    maxCount = diaCount
  end
  self.theItem.gameObject:GameObjectRecycleAll()
  if 0 < maxCount then
    for i = 1, maxCount do
      local param = {}
      local type = self.buildTemplate.effect_Local_type[i]
      local needAdd = true
      if type == EffectLocalType.Dialog then
        local val = DataCenter.BuildManager:GetEffectNumWithType(tonumber(curNums[i]) or 0, type)
        if val == nil or val == "" then
          needAdd = false
        end
        param.addValue = val
      else
        param.addValue = DataCenter.BuildManager:GetEffectNumWithType(tonumber(curNums[i]) or 0, type)
      end
      if needAdd then
        param.name = Localization:GetString(self.buildTemplate.effect_Local_dialog[i])
        self:AddOneDesCells(param)
      end
    end
  end
  self:AddPowerDesCell()
end

function LWSeasonBuildCityItem:AddPowerDesCell()
  local power = self.buildCurLevelTemplate.power
  if power ~= nil and power ~= 0 then
    local showPower = LuaEntry.DataConfig:TryGetNum("show_power", "k1", 0)
    if showPower <= DataCenter.BuildManager.MainLv then
      local param = {}
      param.name = Localization:GetString(GameDialogDefine.POWER)
      param.addValue = power
      self:AddOneDesCells(param)
    end
  end
end

function LWSeasonBuildCityItem:AddOneDesCells(param)
  local goItem = self.theItem.gameObject:GameObjectSpawn(self.BuffList.transform)
  if goItem then
    goItem:SetActive(true)
    goItem.transform:Find("AccelerateText"):GetComponent(UnityText).text = param.name
    goItem.transform:Find("AddValue"):GetComponent(UnityText).text = tostring(param.addValue)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(goItem.transform)
  end
end

return LWSeasonBuildCityItem
