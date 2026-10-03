local LWSeasonCityItem = BaseClass("LWSeasonCityItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local mineIcon_path = "Bg/icon"
local mineLv_path = "Bg/icon/level"
local mineName_path = "Bg/name"
local minePos_path = "Bg/pos"
local info_btn_path = "Bg/infoBtn"
local buildBtn_path = "Bg/buildBtn"
local repairBtn_path = "Bg/repairBtn"
local lock_btn_path = "Bg/lockBtn"
local goto_btn_path = "Bg/gotoBtn"
local pos_btn_path = "Bg/pos/posBtn"
local content_path = "Bg/ScrollView/Viewport/Content"
local slider_path = "Bg/icon/Slider"
local hp_txt_path = "Bg/icon/Slider/hpTxt"

function LWSeasonCityItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWSeasonCityItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonCityItem:ComponentDefine()
  self.mineIconN = self:AddComponent(UIImage, mineIcon_path)
  self.iconLock = self:AddComponent(UIImage, "Bg/icon/lock")
  self.mineLvN = self:AddComponent(UIText, mineLv_path)
  self.mineNameN = self:AddComponent(UIText, mineName_path)
  self.minePosN = self:AddComponent(UIText, minePos_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    if self.mineTemplate then
      UIUtil.ShowDetail(Localization:GetString(self.mineTemplate.desc))
    end
  end)
  self.hp_slider = self:AddComponent(UISlider, slider_path)
  self.hp_txt = self:AddComponent(UIText, hp_txt_path)
  self.pos_btn = self:AddComponent(UIButton, pos_btn_path)
  self.pos_btn:SetOnClick(function()
    self:OnClickJumpBtn()
  end)
  self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
  self.goto_btn:SetOnClick(function()
    self:OnClickJumpBtn()
  end)
  self.lock_btn = self:AddComponent(UIButton, lock_btn_path)
  self.lock_btn:SetOnClick(function()
    for _, key in pairs(AlMineConditionType) do
      local ok, desc = DataCenter.AllianceMineManager:GetConditionInfo(self.mineTemplate, key)
      if not ok and not string.IsNullOrEmpty(desc) then
        UIUtil.ShowTips(desc)
        if key == AlMineConditionType.Science and self.mineTemplate.limit_alliance_tec then
          local science_id = self.mineTemplate.limit_alliance_tec.science_id
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceScience, {anim = true, hideTop = true}, {autoOpenRecScience = false, openScienceId = science_id})
        end
        return
      end
    end
    UIUtil.ShowTipsId("E100008")
  end)
  self.buildBtnN = self:AddComponent(UIButton, buildBtn_path)
  self.buildBtnN:SetOnClick(function()
    self:OnClickBuildBtn()
  end)
  self.repairBtnN = self:AddComponent(UIButton, repairBtn_path)
  self.repairBtnN:SetOnClick(function()
    self:OnClickRepairBtn()
  end)
  self.conditionList = self:AddComponent(UIText, content_path)
end

function LWSeasonCityItem:ComponentDestroy()
  self.mineIconN = nil
  self.mineLvN = nil
  self.mineNameN = nil
  self.minePosN = nil
  self.conditionTxtN = nil
  self.conditionFitN = nil
  self.buildBtnN = nil
end

function LWSeasonCityItem:UpdateData()
  self.mineInfo = DataCenter.AllianceMineManager:GetAllianceCenterDataByBuildId(self.mineTemplate.id)
  self:RefreshAll()
end

function LWSeasonCityItem:SetItemShow(mineTemplate)
  self.mineTemplate = mineTemplate
  self.mineInfo = DataCenter.AllianceMineManager:GetAllianceCenterDataByBuildId(self.mineTemplate.id)
  self:RefreshAll()
end

function LWSeasonCityItem:RefreshAll()
  self.mineIconN:LoadSprite(self.mineTemplate:GetIconPath())
  self.mineNameN:SetLocalText(self.mineTemplate.name)
  self.mineLvN:SetLocalText("300665", self.mineTemplate.level)
  self:RefreshMine()
end

function LWSeasonCityItem:RefreshMine()
  self.repairBtnN:SetActive(false)
  self.buildBtnN:SetActive(false)
  self.goto_btn:SetActive(false)
  self.lock_btn:SetActive(false)
  local allFit, fitDic = DataCenter.AllianceMineManager:CheckIfConditionFits(self.mineTemplate)
  self.fitDic = fitDic
  if self.mineInfo then
    self.conditionList:SetActive(true)
    self.goto_btn:SetActive(true)
    self.minePosN:SetActive(true)
    self.iconLock:SetActive(false)
    self.mineIconN:SetColorRGBA(1, 1, 1, 1)
    self.hp_slider:SetActive(true)
    local tilePos = SceneUtils.IndexToTilePos(self.mineInfo.pointId, ForceChangeScene.World)
    if WorldAllianceBuildUtil.IsAllianceCenterGroup(self.mineInfo.buildId) == true then
      if LuaEntry.Player:AtHomeNow() then
        self.minePosN:SetText("( " .. tilePos.x .. ", " .. tilePos.y .. " ) ")
      else
        self.minePosN:SetText("#" .. LuaEntry.Player:GetSourceServerId() .. " ( " .. tilePos.x .. ", " .. tilePos.y .. " ) ")
      end
    else
      self.minePosN:SetText("#" .. self.mineInfo.curServerId .. " ( " .. tilePos.x .. ", " .. tilePos.y .. " ) ")
    end
    self:Update1000MS()
  else
    self.hp_slider:SetActive(false)
    self.conditionList:SetActive(true)
    self.minePosN:SetActive(false)
    local IsR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
    if allFit then
      if IsR4orR5 then
        local isFlag = WorldAllianceBuildUtil.IsAllianceCenterFlag(self.mineTemplate.id)
        if isFlag and LuaEntry.Player:IsInSourceServer() then
          CS.UIGray.SetGray(self.buildBtnN.transform, true, false)
        else
          CS.UIGray.SetGray(self.buildBtnN.transform, false, true)
        end
      else
        CS.UIGray.SetGray(self.buildBtnN.transform, true, true)
      end
      self.buildBtnN:SetActive(true)
      self.iconLock:SetActive(false)
      self.mineIconN:SetColorRGBA(1, 1, 1, 1)
    else
      if IsR4orR5 then
        CS.UIGray.SetGray(self.lock_btn.transform, false, true)
      else
        CS.UIGray.SetGray(self.lock_btn.transform, true, true)
      end
      self.lock_btn:SetActive(true)
      self.iconLock:SetActive(true)
      self.mineIconN:SetColorRGBA(0.5, 0.5, 0.5, 1)
    end
  end
  self:RefreshConditions(table.values(AlMineConditionType))
end

function LWSeasonCityItem:RefreshConditions(keyList)
  local str = ""
  local dataList = {}
  for _, key in ipairs(keyList) do
    local ok, condDesc = DataCenter.AllianceMineManager:GetConditionInfo(self.mineTemplate, key)
    if not string.IsNullOrEmpty(condDesc) then
      table.insert(dataList, {status = ok, str = condDesc})
    end
  end
  local index = 1
  local count = #dataList
  for k, v in ipairs(dataList) do
    if count == 1 then
      if v.status then
        str = string.format("<color=#349D00>%s</color>", v.str)
      else
        str = string.format("<color=#F53C3D>%s</color>", v.str)
      end
    elseif k == 1 then
      if v.status then
        str = string.format("<color=#349D00>%s.%s</color>", index, v.str)
      else
        str = string.format("<color=#F53C3D>%s.%s</color>", index, v.str)
      end
    elseif v.status then
      str = str .. string.format([[

<color=#349D00>%s.%s</color>]], index, v.str)
    else
      str = str .. string.format([[

<color=#F53C3D>%s.%s</color>]], index, v.str)
    end
    index = index + 1
  end
  self.conditionList:SetText(str)
end

function LWSeasonCityItem:Update1000MS()
  if self.mineInfo ~= nil and self.mineTemplate ~= nil then
    if self.mineInfo.status == AllianceMineStatus.Ruin then
      local maxNum = self.mineTemplate.resDurable
      local curNum = 0
      local percent = math.min(curNum / maxNum, 1) * 100
      self.hp_txt:SetText(string.GetFormattedSeparatorNum(math.floor(curNum)) .. "/" .. string.GetFormattedSeparatorNum(math.floor(maxNum)))
      self.hp_slider:SetValue(percent)
    else
      local maxNum = self.mineTemplate.resDurable
      local curNum = math.min(self.mineInfo:GetAllianceCenterDurability(), maxNum)
      local percent = math.min(curNum / maxNum, 1) * 100
      self.hp_txt:SetText(string.GetFormattedSeparatorNum(math.floor(curNum)) .. "/" .. string.GetFormattedSeparatorNum(math.floor(maxNum)))
      self.hp_slider:SetValue(percent)
    end
  end
end

function LWSeasonCityItem:OnClickBuildBtn()
  if not LuaEntry.Player:AtHomeNow() then
    UIUtil.ShowMessage(Localization:GetString("season_tips142", Localization:GetString(self.mineTemplate.name)), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      CrossServerUtil.BackToSrcServer()
    end)
    return
  end
  if self.mineTemplate == nil then
    return
  end
  if self.mineTemplate and WorldAllianceBuildUtil.IsAllianceCenterFlag(self.mineTemplate.id) and LuaEntry.Player:IsInSourceServer() then
    return
  end
  if self.fitDic == nil then
    local allFit, fitDic = DataCenter.AllianceMineManager:CheckIfConditionFits(self.mineTemplate)
    self.fitDic = fitDic
  end
  for _, v in pairs(self.fitDic) do
    if v.status ~= true then
      UIUtil.ShowTips(v.desc)
      return
    end
  end
  if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    UIUtil.ShowTipsId(803040)
    return
  end
  local mineId = self.mineTemplate.id
  GoToUtil.CloseAllWindows()
  if SceneUtils.GetIsInWorld() then
    local pointId = SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget)
    BuildingUtils.ShowPutAllianceBuild(mineId, 0, pointId, PlaceBuildType.Build)
  else
    local pointId = LuaEntry.Player:GetMainWorldPos()
    GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World), nil, 0.02, function()
      BuildingUtils.ShowPutAllianceBuild(mineId, 0, pointId, PlaceBuildType.Build)
    end, LuaEntry.Player:GetSourceServerId())
  end
end

function LWSeasonCityItem:OnClickRepairBtn()
  self:OnClickJumpBtn()
end

function LWSeasonCityItem:OnClickJumpBtn()
  if self.mineInfo then
    GoToUtil.CloseAllWindows()
    local pos = SceneUtils.TileIndexToWorld(self.mineInfo.pointId, ForceChangeScene.World)
    if WorldAllianceBuildUtil.IsAllianceCenterGroup(self.mineInfo.buildId) == true then
      if LuaEntry.Player:AtHomeNow() then
        GoToUtil.MoveToWorldPointAndOpen(self.mineInfo.pointId, nil, nil, self.mineInfo.curServerId, 0)
      else
        GoToUtil.GotoWorldPos(pos, nil, nil, function()
        end, self.mineInfo.curServerId, 0)
      end
    else
      if self.mineInfo.curServerId == LuaEntry.Player:GetSelfServerId() then
        GoToUtil.MoveToWorldPointAndOpen(self.mineInfo.pointId, nil, nil, self.mineInfo.curServerId, 0)
        return
      end
      math.randomseed(SafeLocalOsTime())
      local tilePos = SceneUtils.IndexToTilePos(self.mineInfo.pointId, ForceChangeScene.World)
      local x = math.random(tilePos.x - 7, tilePos.x + 7)
      local y = math.random(tilePos.y - 7, tilePos.y + 7)
      if x >= WorldTileCount or y >= WorldTileCount or x <= 0 or y <= 0 then
        CrossServerUtil.JumpToServerByServerId(self.mineInfo.curServerId, MoveCrossServerType.SeasonBattleDesert, self.mineInfo.pointId, SeasonCrossCameraHeight)
      else
        local pointId = SceneUtils.TileXYToIndex(x, y, ForceChangeScene.World)
        CrossServerUtil.JumpToServerByServerId(self.mineInfo.curServerId, MoveCrossServerType.SeasonBattleDesert, pointId, SeasonCrossCameraHeight)
      end
    end
  end
end

return LWSeasonCityItem
