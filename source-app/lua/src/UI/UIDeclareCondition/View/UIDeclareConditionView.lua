local UIDeclareConditionView = BaseClass("UIDeclareConditionView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local DeclareConditionItem = require("UI.UIDeclareCondition.Component.DeclareConditionItem")
local panel_path = "UICommonMiniPopUpTitle/panel"
local title_text_path = "UICommonMiniPopUpTitle/titleText"
local close_btn_path = "UICommonMiniPopUpTitle/CloseBtn"
local title_path = "Root/ScrollView/Viewport/Content/title"
local content_path = "Root/ScrollView/Viewport/Content"
local confirm_path = "Root/Confirm"
local confirm_txt_path = "Root/Confirm/ConfirmTxt"
local condition_item_path = "Root/ScrollView/Viewport/Content/ConditionItem"

function UIDeclareConditionView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIDeclareConditionView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIDeclareConditionView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.title_text:SetLocalText("new_city_activity_battle_declear_tips1011")
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.title:SetLocalText("new_city_activity_battle_declear_tips1012")
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.confirm = self:AddComponent(UIButton, confirm_path)
  self.confirm_txt = self:AddComponent(UITextMeshProUGUIEx, confirm_txt_path)
  self.confirm_txt:SetLocalText(458522)
  self.panel:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self.close_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self.confirm:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self.condition_item = self.transform:Find(condition_item_path).gameObject
  self.condition_item:GameObjectCreatePool()
  self.condition_item:SetActive(false)
end

function UIDeclareConditionView:ComponentDestroy()
end

function UIDeclareConditionView:OnAddListener()
  base.OnAddListener(self)
end

function UIDeclareConditionView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIDeclareConditionView:RemoveAlliItems()
  self.content:RemoveComponents(DeclareConditionItem)
  self.condition_item:GameObjectRecycleAll()
end

function UIDeclareConditionView:DataDefine()
  if DataCenter.AllianceBaseDataManager:IsR4orR5() then
    DataCenter.AllianceDeclareWarManager:SetWarCityParam(nil)
    SFSNetwork.SendMessage(MsgDefines.AllianceGetCityDeclareTimes)
  end
  local cityId, serverId = self:GetUserData()
  self.cityId = tostring(cityId)
  self.serverId = toInt(serverId or LuaEntry.Player:GetCurServerId())
  self.conditions = {}
  local protectTime = DataCenter.WorldAllianceCityDataManager:GetCityProtectTime(tonumber(self.cityId))
  local now = UITimeManager:GetInstance():GetServerTime()
  local isPre = protectTime > now
  if not SeasonUtil.CurServerIsInSeason() then
    local myCitiesCount = DataCenter.WorldAllianceCityDataManager:GetCitiesCountByAlId(LuaEntry.Player:GetAllianceUid(), true)
    if 0 < myCitiesCount then
      table.insert(self.conditions, DeclareCondition.AdjacentCity)
    else
      local template = DataCenter.AllianceCityTemplateManager:GetTemplate(self.cityId, self.serverId)
      if template.level ~= 1 then
        table.insert(self.conditions, DeclareCondition.LevelOne)
      end
    end
  elseif SeasonUtil.IsInSeasonCityStrongholdMode() or SeasonUtil.IsInSeasonSnowMode() or SeasonUtil.IsInSeasonMummyMode() or SeasonUtil.IsInSeasonDarknessMode() then
    table.insert(self.conditions, DeclareCondition.AdjacentStronghold)
  elseif SeasonUtil.IsInSeasonDesertMode() then
    table.insert(self.conditions, DeclareCondition.AdjacentDesert)
  end
  local kingCityId, kingCityPosIndex = SeasonUtil.GetKingCityId(LuaEntry.Player:GetCurServerId())
  if toInt(cityId) == kingCityId or DataCenter.SeasonCampDestroyManager:IsEnemyServer(serverId) then
  else
    table.insert(self.conditions, DeclareCondition.OccupyLimit)
  end
  if isPre then
    if UITimeManager:GetInstance():IsTodayServer(protectTime) then
      table.insert(self.conditions, DeclareCondition.DeclareLimit)
    end
  else
    table.insert(self.conditions, DeclareCondition.DeclareLimit)
  end
  table.insert(self.conditions, DeclareCondition.NewAlliance)
  table.insert(self.conditions, DeclareCondition.SmallAlliance)
end

function UIDeclareConditionView:DataDestroy()
  self.conditions = {}
end

function UIDeclareConditionView:OnEnable()
  base.OnEnable(self)
end

function UIDeclareConditionView:OnDisable()
  base.OnDisable(self)
end

function UIDeclareConditionView:ReInit()
  self:RemoveAlliItems()
  for i = 1, #self.conditions do
    local item = self.condition_item:GameObjectSpawn(self.content.transform)
    item.name = "DeclareConditionItem" .. i
    item.transform:SetParent(self.content.transform)
    local obj = self.content:AddComponent(DeclareConditionItem, item.name)
    local satisfy = obj:Refresh(self.conditions[i])
  end
end

function UIDeclareConditionView:GetCityId()
  return self.cityId
end

function UIDeclareConditionView:GetServerId()
  return self.serverId
end

return UIDeclareConditionView
