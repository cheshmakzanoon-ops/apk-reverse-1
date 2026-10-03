local UILWSeasonStoveConditionView = BaseClass("UILWSeasonStoveConditionView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UILWSeasonStoveConditionItem = require("UI.LWSeason2.LWSeasonStoveCondition.Component.UILWSeasonStoveConditionItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local desc_text_path = "PopUpTitle/Content/descText"
local content_path = "PopUpTitle/Content/ScrollView/Viewport/Content"
local condition_item_path = "PopUpTitle/Content/ScrollView/Viewport/Content/StoveConditionItem"
local btn_build_path = "PopUpTitle/Content/BtnBuild"
local text_path = "PopUpTitle/Content/BtnBuild/Text"

function UILWSeasonStoveConditionView:OnCreate()
  base.OnCreate(self)
  self.buildId = toInt(self:GetUserData())
  if self.buildId > 0 then
    self:ComponentDefine()
    self:UpdateData()
  else
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonStoveCondition)
  end
end

function UILWSeasonStoveConditionView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonStoveConditionView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
  self.btn_build = self:AddComponent(UIButton, btn_build_path)
  self.btn_text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.btn_build:SetOnClick(function()
    self:BuildStoveCenter()
  end)
  self.theItem = self.transform:Find(condition_item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.dialog_title_text:SetLocalText("season_s2_alliance_building_ui003")
  self.desc_text:SetLocalText("season_s2_alliance_building_ui004")
  self.btn_text:SetLocalText("season_s2_alliance_building_ui008")
end

function UILWSeasonStoveConditionView:ComponentDestroy()
  if self.content then
    self.content:RemoveComponents(UILWSeasonStoveConditionItem)
    self.content = nil
  end
  if self.theItem then
    self.theItem:GameObjectRecycleAll()
    self.theItem = nil
  end
end

function UILWSeasonStoveConditionView:UpdateData()
  self.content:RemoveComponents(UILWSeasonStoveConditionItem)
  self.theItem:GameObjectRecycleAll()
  local ok = true
  local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(self.buildId)
  if template ~= nil then
    local goItem, theItem
    if self.buildId == BuildingTypes.SEASON_STOVE_CENTER_CARRIER then
      local theCarrier = DataCenter.AllianceMineManager:GetAllianceStoveCenterCarrier()
      if theCarrier == nil then
        goItem = self.theItem:GameObjectSpawn(self.content.transform)
        goItem.name = "item_" .. BuildingTypes.SEASON_STOVE_CENTER_CARRIER
        goItem:SetActive(true)
        theItem = self.content:AddComponent(UILWSeasonStoveConditionItem, goItem.name)
        if theItem:ReInit(0, AlMineConditionType.Resource, template) ~= true then
          ok = false
        end
      end
    end
    for k, v in pairs(AlMineConditionType) do
      if v == AlMineConditionType.MemberCount or v == AlMineConditionType.Power then
        goItem = self.theItem:GameObjectSpawn(self.content.transform)
        goItem.name = "item_" .. k
        goItem:SetActive(true)
        theItem = self.content:AddComponent(UILWSeasonStoveConditionItem, goItem.name)
        if theItem:ReInit(k, v, template) ~= true then
          ok = false
        end
      end
    end
  end
  CS.UIGray.SetGray(self.btn_build.transform, not ok, ok)
end

function UILWSeasonStoveConditionView:BuildStoveCenter()
  if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    UIUtil.ShowTipsId(803040)
    return
  end
  if LuaEntry.Player:AtHomeNow() then
    local mineId = self.buildId
    local theActiveBuildId, theActiveBuildCD = DataCenter.AllianceMineManager:GetLastActiveBuildInfo()
    if theActiveBuildId == mineId and theActiveBuildCD ~= nil then
      local now = UITimeManager:GetInstance():GetServerTime()
      local leftTime = theActiveBuildCD - now
      if 1000 < leftTime then
        local txt = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
        UIUtil.ShowTips(Localization:GetString("season4_build_tips01", txt))
        return
      end
    end
    GoToUtil.CloseAllWindows()
    if SceneUtils.GetIsInWorld() then
      local pointId = SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget)
      BuildingUtils.ShowPutAllianceBuild(mineId, 0, pointId, PlaceBuildType.Build)
    else
      do
        local pointId = LuaEntry.Player:GetMainWorldPos()
        GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World), nil, 0.02, function()
          BuildingUtils.ShowPutAllianceBuild(mineId, 0, pointId, PlaceBuildType.Build)
        end, LuaEntry.Player:GetSourceServerId())
      end
    end
  else
    UIUtil.ShowMessage(Localization:GetString("season_tips142", ""), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      CrossServerUtil.BackToSrcServer()
    end)
  end
end

return UILWSeasonStoveConditionView
