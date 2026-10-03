local base = UIBaseContainer
local UIOffSeason1RecaptureCityItem = BaseClass("UIOffSeason1RecaptureCityItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIOffSeason1RecaptureFeatureItem = require("UI.LWOffSeason1.Recapture.UIOffSeason1RecaptureFeatureItem")

function UIOffSeason1RecaptureCityItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIOffSeason1RecaptureCityItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIOffSeason1RecaptureCityItem:ComponentDefine()
  self.compBgWhite = self:AddComponent(UIBaseComponent, "BgWhite")
  self.imgType = self:AddComponent(UIImage, "TypeBg")
  self.imgIcon = self:AddComponent(UIImage, "Icon")
  self.textLevel = self:AddComponent(UITextMeshProUGUIEx, "LevelText")
  self.btnPos = self:AddComponent(UIButton, "PosBtn")
  self.btnPos:SetOnClick(function()
    self:OnBtnPosClick()
  end)
  self.textPos = self:AddComponent(UITextMeshProUGUIEx, "PosBtn/PosText")
  self.textSlider = self:AddComponent(UITextMeshProUGUIEx, "HpSlider/TextSlider")
  self.slider = self:AddComponent(UISlider, "HpSlider/Slider")
  self.featureItem = self:AddComponent(UIOffSeason1RecaptureFeatureItem, "FeatureItem")
  self.compBgRed = self:AddComponent(UIBaseComponent, "BgRed")
  self.tipRoot = self:AddComponent(UIBaseComponent, "TipRoot")
  self.tipText = self:AddComponent(UIText, "TipRoot/Content/TipText")
  self.tipRoot:SetActive(false)
end

function UIOffSeason1RecaptureCityItem:ComponentDestroy()
  self.compBgWhite = nil
  self.imgType = nil
  self.imgIcon = nil
  self.textLevel = nil
  self.btnPos = nil
  self.textPos = nil
  self.textSlider = nil
  self.slider = nil
  self.featureItem = nil
  self.compBgRed = nil
  self.tipRoot = nil
  self.tipText = nil
end

function UIOffSeason1RecaptureCityItem:DataDefine()
end

function UIOffSeason1RecaptureCityItem:DataDestroy()
end

function UIOffSeason1RecaptureCityItem:OnEnable()
  base.OnEnable(self)
end

function UIOffSeason1RecaptureCityItem:OnDisable()
  if self.closeGuideTipTimer then
    self.closeGuideTipTimer:Stop()
    self.closeGuideTipTimer = nil
  end
  self.tipRoot:SetActive(false)
  base.OnDisable(self)
end

function UIOffSeason1RecaptureCityItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CloseOffSeason1RecaptureMainTipBubble, self.HideTipRoot)
end

function UIOffSeason1RecaptureCityItem:OnRemoveListener()
  self:RemoveUIListener(EventId.CloseOffSeason1RecaptureMainTipBubble, self.HideTipRoot)
  base.OnRemoveListener(self)
end

function UIOffSeason1RecaptureCityItem:OnBtnPosClick()
  if self.cityPos ~= nil and self.cityPos.x ~= nil and self.cityPos.y ~= nil then
    local v3 = SceneUtils.TileToWorld(self.cityPos, ForceChangeScene.World)
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, nil, nil, LuaEntry.Player:GetSourceServerId())
  end
end

function UIOffSeason1RecaptureCityItem:Refresh(monsterInfo)
  self.monsterInfo = monsterInfo
  local monsterCfg = DataCenter.MonsterTemplateManager:GetMonsterTemplate(self.monsterInfo.monsterId)
  self.cityPos = SceneUtils.IndexToTilePos(monsterInfo.startPos, ForceChangeScene.World)
  self.textPos:SetText("<u>" .. Localization:GetString("300015", self.cityPos.x, self.cityPos.y) .. "</u>")
  self.imgIcon:LoadSpriteAuto(monsterCfg:GetIcon())
  self.textLevel:SetLocalText("300665", monsterCfg.level)
  local cityBattleS1MonsterInfo = self.monsterInfo.cityBattleS1MonsterInfo
  if cityBattleS1MonsterInfo ~= nil then
    local cityIconType = toInt(cityBattleS1MonsterInfo.soldierType)
    if cityIconType == 1 then
      self.imgType:LoadSprite("Assets/Main/Sprites/UI/LWOffSeason1/Recapture/zxl_boss_bingzhong_tanke.png")
    elseif cityIconType == 2 then
      self.imgType:LoadSprite("Assets/Main/Sprites/UI/LWOffSeason1/Recapture/zxl_boss_bingzhong_daodan.png")
    elseif cityIconType == 3 then
      self.imgType:LoadSprite("Assets/Main/Sprites/UI/LWOffSeason1/Recapture/zxl_boss_bingzhong_feiji.png")
    end
  end
  local progressValue = 0
  if 0 < self.monsterInfo.maxHp then
    progressValue = Mathf.Clamp(self.monsterInfo.curHp / self.monsterInfo.maxHp, 0, 1)
  end
  self.slider:SetValue(progressValue)
  self.textSlider:SetText(string.percentage(self.monsterInfo.curHp, self.monsterInfo.maxHp, 2))
  self.featureItem:Refresh(self.monsterInfo.presidentChoose, self.monsterInfo.uuid)
  self.compBgRed:SetActive(self.monsterInfo.presidentChoose)
  self.compBgWhite:SetActive(not self.monsterInfo.presidentChoose)
end

function UIOffSeason1RecaptureCityItem:ShowGuideTip(tipStr)
  if not string.IsNullOrEmpty(tipStr) then
    self:ShowTipRoot(tipStr, false)
    if self.closeGuideTipTimer == nil then
      self.closeGuideTipTimer = TimerManager:GetInstance():DelayInvoke(function()
        self:HideTipRoot()
      end, 3)
    end
  end
end

function UIOffSeason1RecaptureCityItem:ShowTipRoot(tipStr, showTipPanel)
  self.tipRoot:SetActive(true)
  self.tipText:SetLocalText(tipStr)
  if showTipPanel then
    EventManager:GetInstance():Broadcast(EventId.OpenOffSeason1RecaptureMainCloseTipPanel)
  end
end

function UIOffSeason1RecaptureCityItem:HideTipRoot()
  self.tipRoot:SetActive(false)
end

return UIOffSeason1RecaptureCityItem
