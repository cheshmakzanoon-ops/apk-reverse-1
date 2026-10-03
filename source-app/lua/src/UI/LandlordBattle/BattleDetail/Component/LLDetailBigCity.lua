local base = UIAsyncContainer
local LLDetailBigCity = BaseClass("LLDetailBigCity", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.LandlordMgr
local CLS = "UI.LandlordBattle.BattleDetail.Component.LLDetailSubCity"
local PREFAB = "Assets/Main/Prefabs/UI/Landlord/World/LLWorldBattleDetailSubBuildingItem.prefab"
local CLS_PROGRESS_BASE = "UI.LandlordBattle.BattleDetail.Component.LLDetailProgress%s"
local PREFAB_PROGRESS_BASE = "Assets/Main/Prefabs/UI/Landlord/World/LLWorldBattleDetailProgress%s.prefab"

function LLDetailBigCity:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLDetailBigCity:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLDetailBigCity:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBuilding = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgTime = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgBuildingIcon = self.viewSkin:AddComponent(self, UIImage, 4)
  self.textPos = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textRuinPoints = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnPosText = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnPosText:SetOnClick(function()
    self:OnBtnPosTextClick()
  end)
  self.textCurOccupy = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.compBG = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.textEnemy = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textOur = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 13)
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 14)
end

function LLDetailBigCity:ComponentDestroy()
  self.viewSkin = nil
  self.imgBuilding = nil
  self.imgTime = nil
  self.textTime = nil
  self.imgBuildingIcon = nil
  self.textPos = nil
  self.textName = nil
  self.textRuinPoints = nil
  self.btnPosText = nil
  self.textCurOccupy = nil
  self.compBG = nil
  self.textEnemy = nil
  self.textOur = nil
  self.compContent = nil
  self.imgBg = nil
end

function LLDetailBigCity:DataDefine()
end

function LLDetailBigCity:DataDestroy()
  if self.rebuildLayoutTimer then
    self.rebuildLayoutTimer:Stop()
    self.rebuildLayoutTimer = nil
  end
  self.compProgress = nil
  self.data = nil
  self.subList = nil
  self.subCityItems = nil
  self.checkCb = nil
end

function LLDetailBigCity:OnAddListener()
  base.OnAddListener(self)
end

function LLDetailBigCity:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLDetailBigCity:OnBtnPosTextClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.data == nil then
    return
  end
  ActMgr:JumpToCity(self.data.cityId)
end

function LLDetailBigCity:SetData(tabIdx, data, subList, checkCb)
  self.tabIdx = tabIdx
  self.data = data
  self.subList = subList
  self.checkCb = checkCb
  self:RefreshView()
end

function LLDetailBigCity:UpdateData()
  if self.data == nil then
    return
  end
  local data = self.data
  local myGroup = ActMgr:GetMyGroup()
  ActMgr:SetDetailCityShow(data, self.imgBuilding, self.imgTime, self.imgBg, self.textCurOccupy, self.textPos)
  local myNum = myGroup == LLConst.LandLordGroup.LORD and self.data.landlordNum or self.data.farmerNum
  local enemyNum = myGroup == LLConst.LandLordGroup.LORD and self.data.farmerNum or self.data.landlordNum
  self.textOur:SetText(myNum)
  self.textEnemy:SetText(enemyNum)
  local template = ActMgr:GetCityTemplate(data.cityId)
  if template ~= nil then
    local icon = data.state == LLConst.ZWLBuildingState.RUIN and template.ruins_icon or template:GetIconPath()
    self.imgBuildingIcon:LoadSpriteAsyncWithCallback(icon, function()
      self.imgBuildingIcon:SetAspectSize(190)
    end)
    local cityPos = template.pos
    self.textPos:SetLocalText(300015, cityPos.x, cityPos.y)
    self.textName:SetText(template:GetFullName())
    self.textRuinPoints:SetText(template.ruins_points)
  end
  self:RefreshProgress()
  self:RefreshSubCity()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
end

function LLDetailBigCity:RefreshProgress()
  if self.compProgress == nil then
    local key = self.tabIdx == 4 and "King" or "Build"
    local clsP = string.format(CLS_PROGRESS_BASE, key)
    local prefabP = string.format(PREFAB_PROGRESS_BASE, key)
    self.compProgress = self:LoadComponentAsync(clsP, prefabP, self.compBG, function(_, go, comp)
      local x, y = comp:GetLocalPositionXYZ()
      if self.tabIdx == 3 then
        y = 15
      else
        y = -10
      end
      comp:SetLocalPositionXYZ(x, y, 0)
    end)
  end
  self.compProgress:SetData(self.data, self.textTime)
end

function LLDetailBigCity:RefreshSubCity()
  local count = self.subList ~= nil and #self.subList or 0
  self.compContent:SetActive(0 < count)
  if count == 0 then
    return
  end
  self.subCityItems = self.subCityItems or {}
  local maxCnt = math.max(#self.subCityItems, count)
  if maxCnt == 0 then
    self:CheckFinish(0, 0)
    return
  end
  for i = 1, maxCnt do
    local subCityData = self.subList ~= nil and self.subList[i] or nil
    local subCity = self.subCityItems[i]
    if subCityData ~= nil then
      if subCity == nil then
        subCity = self:LoadComponentAsync(CLS, PREFAB, self.compContent, function()
          subCity:SetName("Item_" .. i)
          subCity:SetLocalScaleXYZ(0.95, 0.95, 0.95)
          self:CheckFinish()
        end)
        self.subCityItems[i] = subCity
      end
      subCity:SetActive(true)
      subCity:SetData(subCityData)
    elseif subCity ~= nil then
      subCity:SetActive(false)
    end
  end
  self:CheckFinish()
end

function LLDetailBigCity:CheckFinish()
  if self.rebuildLayoutTimer then
    self.rebuildLayoutTimer:Stop()
    self.rebuildLayoutTimer = nil
  end
  self.rebuildLayoutTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.rebuildLayoutTimer = nil
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compContent.transform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
    if self.checkCb then
      self.checkCb()
    end
  end, 0.5)
end

return LLDetailBigCity
