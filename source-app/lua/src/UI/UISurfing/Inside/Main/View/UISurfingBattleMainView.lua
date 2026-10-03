local UISurfingBattleMainView = BaseClass("UISurfingBattleMainView", UIBaseView)
local base = UIBaseView
local UISurfingResItem = require("UI.UISurfing.Inside.Main.Component.UISurfingResItem")
local UISurfingBuffItem = require("UI.UISurfing.Inside.Main.Component.UISurfingBuffItem")
local UISurfingBattleGMItem = require("UI.UISurfing.Inside.Main.Component.UISurfingBattleGMItem")
local Const = require("Scene.LWBattle.Const")
local res_node_path = "SafeArea/ResNode"
local resource_rect_path = "SafeArea/ResNode/ResourceRect"
local pause_btn_path = "SafeArea/BottomGroup/PauseBtn"
local buff_root_path = "SafeArea/BottomGroup/BuffRoot"
local buff_item_path = "SafeArea/BottomGroup/BuffRoot/BuffItem"
local mileage_text_path = "SafeArea/MileageRoot/Root/MileageText"
local g_m_path = "SafeArea/GM"
local Localization = CS.GameEntry.Localization
local table_IsNullOrEmpty = table.IsNullOrEmpty

function UISurfingBattleMainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UISurfingBattleMainView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UISurfingBattleMainView:ComponentDefine()
  self.res_node = self:AddComponent(UIBaseContainer, res_node_path)
  self.res_item_go = self.transform:Find(resource_rect_path).gameObject
  self.res_item_go:GameObjectCreatePool()
  self.pause_btn = self:AddComponent(UIButton, pause_btn_path)
  self.pause_btn:SetOnClick(function()
    self:OnPauseBtnClick()
  end)
  self.buff_root = self:AddComponent(UIBaseContainer, buff_root_path)
  self.buff_item_go = self.transform:Find(buff_item_path).gameObject
  self.buff_item_go:GameObjectCreatePool()
  self.mileage_text = self:AddComponent(UITextMeshProUGUIEx, mileage_text_path)
  local isDebug = CS.CommonUtils.IsDebug()
  local isEditor = CS.UnityEngine.Application.isEditor
  if isDebug or isEditor then
    self.g_m = self:AddComponent(UISurfingBattleGMItem, g_m_path)
    self.g_m:SetActive(true)
  end
  if isDebug then
    self.GMText = self:AddComponent(UIText, "GmTop/GMTopText")
    self.stageId = DataCenter.LWBattleManager:GetCurBattleLogic():GetStageId()
    local curScene = DataCenter.LWBattleManager:GetCurBattleLogic().curScene
    if curScene then
      self:OnSurfingSceneChanged(curScene)
    else
      self.GMText:SetText(self.stageId)
    end
  else
    self.transform:Find("GmTop").gameObject:SetActive(false)
  end
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if logic and logic.isGuide then
    self.pause_btn:SetActive(false)
  else
    self.pause_btn:SetActive(true)
  end
end

function UISurfingBattleMainView:ComponentDestroy()
  self.res_node = nil
  self.res_item_go:GameObjectRecycleAll()
  self.res_item_go = nil
  self.pause_btn = nil
  self.buff_root = nil
  self.buff_item_go:GameObjectRecycleAll()
  self.buff_item_go = nil
  self.g_m = nil
end

function UISurfingBattleMainView:DataDefine()
  self.goodsList = {}
  self.resData = {}
  self.validBuffList = {}
  self.buffList = {}
  self.buffCount = 0
  self.logic = nil
  self.displayDistance = nil
  self.pause = nil
end

function UISurfingBattleMainView:DataDestroy()
  self.goodsList = nil
  self.resData = nil
  self.validBuffList = nil
  self.buffList = nil
  self.buffCount = nil
  self.logic = nil
  self.displayDistance = nil
  self.pause = nil
end

function UISurfingBattleMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnPVEBattleGetGoods, self.OnPVEBattleGetGoods)
  self:AddUIListener(EventId.SurfingOnBuffAdd, self.OnBuffAdd)
  self:AddUIListener(EventId.SurfingOnBuffRemove, self.OnBuffRemove)
  self:AddUIListener(EventId.SurfingSceneChanged, self.OnSurfingSceneChanged)
  self:AddUIListener(EventId.SurfingOnGameStateChanged, self.OnGameStateChanged)
  self:AddUIListener(EventId.SurfingOnPlayerDeathModifyZ, self.OnPlayerDeathModifyZ)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

function UISurfingBattleMainView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnPVEBattleGetGoods, self.OnPVEBattleGetGoods)
  self:RemoveUIListener(EventId.SurfingOnBuffAdd, self.OnBuffAdd)
  self:RemoveUIListener(EventId.SurfingOnBuffRemove, self.OnBuffRemove)
  self:RemoveUIListener(EventId.SurfingSceneChanged, self.OnSurfingSceneChanged)
  self:RemoveUIListener(EventId.SurfingOnGameStateChanged, self.OnGameStateChanged)
  self:RemoveUIListener(EventId.SurfingOnPlayerDeathModifyZ, self.OnPlayerDeathModifyZ)
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  base.OnRemoveListener(self)
end

function UISurfingBattleMainView:Update()
  if self.pause then
    return
  end
  if self.logic then
    local distance = self.logic:GetCurDistanceData()
    local currentInt = Mathf.Floor(distance)
    if currentInt ~= self.displayDistance then
      self.mileage_text:SetLocalText("parkour_meters_show", currentInt)
      self.displayDistance = currentInt
    end
  end
end

function UISurfingBattleMainView:Update100MS()
  if self.buffCount and self.buffCount > 0 then
    for _, v in pairs(self.validBuffList) do
      if v then
        v:OnUpdate()
      end
    end
  end
end

function UISurfingBattleMainView:InitView()
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  self.logic = logic
  local ids = logic:GetPropsId()
  self:InitResGroup(ids)
end

local function GetGoodsParam(self, goodsId)
  local itemTemplate = DataCenter.ItemTemplateManager:TryGetItemTemplate(goodsId)
  if itemTemplate then
    local iconUrl = string.format(LoadPath.ItemPath, itemTemplate.icon)
    local param = {}
    param.iconName = iconUrl
    param.showCount = 0
    return param
  end
end

function UISurfingBattleMainView:InitResGroup(ids)
  if ids then
    local name
    for i, v in ipairs(ids) do
      if DataCenter.LWSurfingDataManager:CheckBoxOpen(v) then
        local item = self.res_item_go:GameObjectSpawn(self.res_node.transform)
        name = tostring(i)
        item.name = name
        local cell = self.res_node:AddComponent(UISurfingResItem, name)
        cell:SetActive(true)
        cell:SetData(GetGoodsParam(self, v))
        self.goodsList[v] = cell
      end
    end
  end
end

function UISurfingBattleMainView:AddBuffItem(param)
  if param then
    local buff = param.buff
    if buff then
      local buffId = buff.meta.id
      local bType = buff.meta.type
      local item = self.validBuffList[bType]
      if item == nil then
        if self.buffList and self.buffList[bType] then
          item = self.buffList[bType]
          self.buffList[bType] = nil
          if item then
            self.validBuffList[bType] = item
            self.buffCount = self.buffCount + 1
            if not item:GetActive() then
              item:SetActive(true)
              item.transform:SetAsLastSibling()
            end
            item:UpdateData(buff)
            return
          end
        end
        local go = self.buff_item_go:GameObjectSpawn(self.buff_root.transform)
        local name = buffId .. "_" .. bType
        go.name = name
        item = self.buff_root:AddComponent(UISurfingBuffItem, name)
        item:SetActive(true)
        item:SetData(buff)
        self.validBuffList[bType] = item
        self.buffCount = self.buffCount + 1
      else
        if not item:GetActive() then
          item:SetActive(true)
          item.transform:SetAsLastSibling()
        end
        item:UpdateData(buff)
      end
    end
  end
end

function UISurfingBattleMainView:RemoveBuff(buff)
  if buff then
    local bType = buff.meta.type
    local item = self.validBuffList[bType]
    if item then
      self.validBuffList[bType] = nil
      self.buffCount = self.buffCount - 1
      item:SetActive(false)
      item:ResetData()
      self.buffList[bType] = item
    end
  end
end

function UISurfingBattleMainView:OnPVEBattleGetGoods(param)
  self:AddRes(param.goodsId, param.goodsCount)
end

function UISurfingBattleMainView:AddRes(goodsId, goodsCount)
  if self.resData[goodsId] == nil then
    self.resData[goodsId] = 0
  end
  self.resData[goodsId] = self.resData[goodsId] + goodsCount
  local showCount = self.resData[goodsId]
  local item = self.goodsList[goodsId]
  if item then
    item:RefreshData(showCount)
  end
end

function UISurfingBattleMainView:OnPauseBtnClick()
  if self.logic and self.logic.isGuide then
    UIUtil.ShowConfirmNew({
      contentText = Localization:GetString("parkour_guide_check"),
      btnNum = 2,
      showToggle = false,
      confirmBtnParam = {
        action = function()
          DataCenter.LWBattleManager:SetGameOver(true)
          UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleGuide)
          local rewarded = DataCenter.LWSurfingDataManager:IsGuideReward()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UISurfingBattleGuideFinish, {anim = true}, {skip = true, rewarded = rewarded})
          DataCenter.LWSurfingDataManager:ReqGuideReward()
        end
      }
    })
    return
  end
  if self.logic then
    self.logic:PauseGame()
  end
end

function UISurfingBattleMainView:OnBuffAdd(param)
  self:AddBuffItem(param)
end

function UISurfingBattleMainView:OnBuffRemove(buff)
  self:RemoveBuff(buff)
end

function UISurfingBattleMainView:OnSurfingSceneChanged(curScene)
  if self.GMText == nil then
    return
  end
  if curScene == nil then
    return
  end
  local config = curScene.sceneData.config
  local stageSceneId = config.groupId
  local stageSceneIndex = config.groupIndex
  local sceneId = config.sceneId
  local sceneIndex = config.index
  local speed = config.speed_z
  self.GMText:SetText(self.stageId .. [[

 ]] .. stageSceneIndex .. " - " .. stageSceneId .. [[

 ]] .. sceneIndex .. " - " .. sceneId .. [[

 speed : ]] .. speed)
end

function UISurfingBattleMainView:OnGameStateChanged(state)
  self.pause = state == nil or state ~= Const.SurfingState.Surfing
end

function UISurfingBattleMainView:OnPlayerDeathModifyZ()
  local distance = self.logic and self.logic:GetCurDistanceData() or 0
  local currentInt = Mathf.Floor(distance)
  if currentInt ~= self.displayDistance then
    self.mileage_text:SetLocalText("parkour_meters_show", currentInt)
    self.displayDistance = currentInt
  end
end

function UISurfingBattleMainView:OnKeyCodeEscape()
  if Config.IsPC() or CS.CommonUtils.IsDebug() then
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISurfingBattleCountDown) then
      return
    end
    self:OnPauseBtnClick()
  end
end

return UISurfingBattleMainView
