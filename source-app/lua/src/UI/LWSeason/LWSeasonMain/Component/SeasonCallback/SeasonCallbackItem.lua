local base = UIBaseContainer
local SeasonCallbackItem = BaseClass("SeasonCallbackItem", base)
local UILostSoldierTip = require("UI.UILostSoldierTip.View.UILostSoldierTipView")
local IconImg_path = "IconImg"
local DesText_path = "DesText"
local GotoBtn_path = "GotoBtn"
local TitleText_path = "TitleText"
local ImageBg_path = ""
local DesBtn_path = "DesBtn"

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

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.IconImg = self:AddComponent(UIRawImage, IconImg_path)
  self.DesText = self:AddComponent(UIText, DesText_path)
  self.GotoBtn = self:AddComponent(UIButton, GotoBtn_path)
  self.TitleText = self:AddComponent(UIText, TitleText_path)
  self.ImageBg = self:AddComponent(UIImage, ImageBg_path)
  self.DesBtn = self:AddComponent(UIButton, DesBtn_path)
  self.canvas = self:AddComponent(UICanvasGroup, "")
  self.GotoBtn:SetOnClick(function()
    self:Jump()
  end)
  self.DesBtn:SetOnClick(function()
    self:OpenValue()
  end)
end

local function ComponentDestroy(self)
  self.info = nil
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
  self.IconImg = nil
  self.DesText = nil
  self.GotoBtn = nil
  self.TitleText = nil
  self.ImageBg = nil
  self.DesBtn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonCallbackItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonCallbackValueChange, self.OnCallbackValueChange)
end

function SeasonCallbackItem:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonCallbackValueChange, self.OnCallbackValueChange)
  base.OnRemoveListener(self)
end

local function ReInit(self, index, info)
  self.index = index
  self.info = info
  self.TitleText:SetLocalText(info.name)
  local enableBtn = false
  if info.type == SeasonCallbackType.SystemBuff then
    local value = DataCenter.SeasonCallbackManager:GetCallbackDescValue(info)
    self.DesText:SetLocalText(info.desc_1, value)
    local callbackId = info.callback_id_list[1]
    self.GotoBtn:SetActive(callbackId ~= nil and 0 < callbackId)
    enableBtn = 0 < value
  else
    self.DesText:SetLocalText(info.desc_1)
    self.GotoBtn:SetActive(true)
  end
  self.DesBtn:SetActive(enableBtn)
  self.IconImg:LoadSpriteAsyncWithCallback(info.activity_show, function(texture)
    if self.IconImg ~= nil then
      self.IconImg:SetNativeSize()
    end
  end)
  if not string.IsNullOrEmpty(info.banner) then
    self.ImageBg:LoadSpriteAuto(info.banner)
  end
end

local function OnCallbackValueChange(self)
  if self.info and self.info.type == SeasonCallbackType.SystemBuff then
    self:ReInit(self.index, self.info)
  end
end

local function OpenValue(self)
  if self.info == nil then
    return
  end
  if self.info.type == SeasonCallbackType.SystemBuff then
    local data = DataCenter.SeasonCallbackManager:GetCallbackData(self.info)
    if table.IsNullOrEmpty(data) then
      return
    end
    local param = UILostSoldierTip.ParamDataClass.New()
    param.position = self.DesBtn:GetPosition()
    param.deltaY = 25
    param.data = {soldierData = nil, dataList = data}
    param.topDesc = "season_s6_callback_UI_12"
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILostSoldierTip, {anim = true}, param)
  end
end

local function Jump(self)
  if not self.info then
    return
  end
  local callbackType = self.info.type
  local callbackId = self.info.callback_id_list[1]
  if callbackId == nil then
    UIUtil.ShowTipsId(self.info.error_tips)
    return
  end
  if callbackType == SeasonCallbackType.Base then
    EventManager:GetInstance():Broadcast(EventId.UIDecorationMainViewOpen)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, DecorationType_Main_City, callbackId)
    return
  end
  if callbackType == SeasonCallbackType.Drone then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalWeaponSkinPage, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, callbackId)
    return
  end
  if callbackType == SeasonCallbackType.Decoration then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWDecorationBook, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    }, DecorationBookTab.Illustrated)
    local hasBuilding = DataCenter.BuildManager:HasBuilding(callbackId, true)
    if hasBuilding then
      local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(callbackId, true)
      local oneData = {}
      oneData.buildUuid = buildData.uuid
      oneData.isShowShortCutKey = false
      oneData.hasBuilding = true
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWDecorationBookUpgrade, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, oneData)
    else
      local oneData = {}
      oneData.itemId = callbackId
      oneData.level = 1
      oneData.max_level = 5
      oneData.type = Building_Upgrade_Type.DecorationBook
      oneData.isShowShortCutKey = false
      oneData.hasBuilding = false
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWDecorationBookUpgrade, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, oneData)
    end
    return
  end
  if callbackType == SeasonCallbackType.Hero then
    local heroId = 0
    for i = #self.info.callback_id_list, 1, -1 do
      heroId = self.info.callback_id_list[i]
      if DataCenter.HeroDataManager:GetHeroByHeroId(heroId) then
        break
      end
    end
    if heroId ~= 0 then
      GoToUtil.GoHeroDetails(heroId)
    else
      UIUtil.ShowTipsId(self.info.error_tips)
    end
    return
  end
end

local function ShowFadeInEffect(self)
  UIUtil.ShowListItemAnim(self, self.index, self.canvas)
end

SeasonCallbackItem.OnCreate = OnCreate
SeasonCallbackItem.OnDestroy = OnDestroy
SeasonCallbackItem.OnEnable = OnEnable
SeasonCallbackItem.OnDisable = OnDisable
SeasonCallbackItem.ComponentDefine = ComponentDefine
SeasonCallbackItem.ComponentDestroy = ComponentDestroy
SeasonCallbackItem.DataDefine = DataDefine
SeasonCallbackItem.DataDestroy = DataDestroy
SeasonCallbackItem.ReInit = ReInit
SeasonCallbackItem.Jump = Jump
SeasonCallbackItem.ShowFadeInEffect = ShowFadeInEffect
SeasonCallbackItem.OnCallbackValueChange = OnCallbackValueChange
SeasonCallbackItem.OpenValue = OpenValue
return SeasonCallbackItem
