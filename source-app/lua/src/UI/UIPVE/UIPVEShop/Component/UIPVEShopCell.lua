local UIPVEShopCell = BaseClass("UIPveBuffCell", UIBaseContainer)
local base = UIBaseContainer
local UIPVEShopCostCell = require("UI.UIPVE.UIPVEShop.Component.UIPVEShopCostCell")
local Localization = CS.GameEntry.Localization
local Const = require("Scene.PVEBattleLevel.Const")
local BgNameList = {
  "UIBattleBuff_bg_green",
  "UIBattleBuff_bg_blue",
  "UIBattleBuff_bg_purple"
}
local submit_btn_path = "Bg"
local buff_icon_path = "BuffIcon"
local cost_go_path = "CostGo"
local res_item_num_path = "Text_num"
local name_text_path = "NameText"
local level_text_path = "LevelText"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.submit_btn = self:AddComponent(UIButton, submit_btn_path)
  self.buff_icon = self:AddComponent(UIImage, buff_icon_path)
  self.cost_go = self:AddComponent(UIBaseContainer, cost_go_path)
  self.res_item_num = self:AddComponent(UIText, res_item_num_path)
  self.bg_icon = self:AddComponent(UIImage, submit_btn_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.level_text = self:AddComponent(UIText, level_text_path)
  self.submit_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnSubmitBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.bg_icon = nil
  self.submit_btn = nil
  self.buff_icon = nil
  self.cost_go = nil
  self.res_item_num = nil
  self.name_text = nil
  self.level_text = nil
end

local function DataDefine(self)
  self.param = nil
  self.list = {}
  self.req = {}
end

local function DataDestroy(self)
  self.param = nil
  self.list = nil
  self.req = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self, param)
  self.param = param
  self.trigger = DataCenter.BattleLevel:GetTriggerByTriggerId(self.param.id)
  local bgName = BgNameList[self.param.index % table.count(BgNameList)]
  self.name_text:SetActive(false)
  self.level_text:SetActive(false)
  self.bg_icon:LoadSprite(string.format(LoadPath.UIPveBattleBuff, bgName))
  if self.trigger ~= nil then
    if self.trigger.config.buffId ~= nil then
      local template = DataCenter.PveBuffTemplateManager:GetTemplate(self.trigger.config.buffId)
      if template ~= nil then
        self.buff_icon:LoadSprite(string.format(LoadPath.PVEScene, template.pic))
      end
      self.res_item_num:SetActive(false)
    elseif self.trigger.config.buyResItem ~= nil then
      local imagePic = Const.ResTypeIconPath[Const.UnlockToResType[self.trigger.config.buyResItem]] or Const.ResTypeIconPath[Const.CityCutResType.Brick]
      self.buff_icon:LoadSprite(imagePic)
      if self.trigger.config.buyResItemNum > 1 then
        self.res_item_num:SetActive(true)
        self.res_item_num:SetText("x" .. self.trigger.config.buyResItemNum)
      else
        self.res_item_num:SetActive(false)
      end
    elseif self.trigger.config.buyMoveManNum ~= nil then
      local imagePic = "Assets/Main/Sprites/ItemIcons/Common_icon_wait_move_person.png"
      self.buff_icon:LoadSprite(imagePic)
      if 1 < self.trigger.config.buyMoveManNum then
        self.res_item_num:SetActive(true)
        self.res_item_num:SetText("x" .. self.trigger.config.buyMoveManNum)
      else
        self.res_item_num:SetActive(false)
      end
    end
    self:Refresh(self.param.id)
    if self.trigger.config.needCostRes ~= nil then
      for _, v in ipairs(self.trigger.config.needCostRes) do
        self:CreateCostCell(v)
      end
    end
    if self.trigger.config.needCostResItem ~= nil then
      for _, v in ipairs(self.trigger.config.needCostResItem) do
        self:CreateCostCell(v)
      end
    end
  end
end

local function CreateCostCell(self, data)
  local req = self:GameObjectInstantiateAsync(UIAssets.UIPVEShopCostCell, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.cost_go.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local nameStr = tostring(NameCount)
    go.name = nameStr
    NameCount = NameCount + 1
    local model = self.cost_go:AddComponent(UIPVEShopCostCell, nameStr)
    model:ReInit(data)
    self.list[nameStr] = model
  end)
  table.insert(self.req, req)
end

local function OnSubmitBtnClick(self)
  if not self.trigger:IsTriggerOK() then
    for k, v in ipairs(self.trigger.config.needCostRes) do
      if DataCenter.BattleLevel:GetResTypeCount(v.resType) < v.count then
        UIUtil.ShowTips(Localization:GetString(GameDialogDefine.RESOURCE_LACK))
        return
      end
    end
    for k, v in ipairs(self.trigger.config.needCostResItem) do
      if DataCenter.BattleLevel:GetResourceItemCountByResType(v.resItemId) < v.count then
        UIUtil.ShowTips(Localization:GetString(GameDialogDefine.RESOURCE_LACK))
        return
      end
    end
    DataCenter.BattleLevel:RemoveOneArrowById(self.view:GetTriggerPosId())
    local pos = self.trigger:GetPosition()
    for k, v in ipairs(self.trigger.config.needCostRes) do
      DataCenter.BattleLevel:ChangeResTypeCount(v.resType, -v.count, pos)
    end
    if self.trigger.config.buffId ~= nil then
      DataCenter.BattleLevel:DoTrigger(self.trigger, true)
    else
      if self.trigger:IsTypeBuyWaitResItem() then
        local destPos = self.view:GetWaitMovePosition()
        DataCenter.BattleLevel:AddOneWaitMove(self.trigger.config.buyResItem, self.trigger.config.buyResItemNum, destPos, self.view:GetId())
      elseif self.trigger:IsTypeBuyResItem() then
        DataCenter.BattleLevel:ChangeResItem(self.trigger.config.buyResItem, self.trigger.config.buyResItemNum)
      elseif self.trigger:IsTypeBuyWaitMoveMan() then
        DataCenter.BattleLevel:AddMoveManCount(self.trigger.config.buyMoveManNum)
      end
      local triggerId = self.trigger:GetTriggerId()
      local param = {}
      param.level = DataCenter.BattleLevel.levelId
      param.trigger = triggerId
      SFSNetwork.SendMessage(MsgDefines.PveTriggerCost, param)
      DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.PveShopBuyItem, tostring(triggerId))
      self.view:Refresh()
    end
    DataCenter.BattleLevel:RefreshCarryResourceText()
  end
end

local function Refresh(self, id)
  if self.trigger ~= nil then
    if self.trigger:GetTriggerId() == id then
      for k, v in pairs(self.list) do
        v:Refresh()
      end
    else
      self:ClearCostCell()
      self.param.id = id
      self:ReInit(self.param)
    end
  end
end

local function ClearCostCell(self)
  for k, v in ipairs(self.list) do
    v:OnDestroy()
  end
  self.list = {}
  for k, v in ipairs(self.req) do
    v:Destroy()
  end
  self.req = {}
end

UIPVEShopCell.OnCreate = OnCreate
UIPVEShopCell.OnDestroy = OnDestroy
UIPVEShopCell.ComponentDefine = ComponentDefine
UIPVEShopCell.ComponentDestroy = ComponentDestroy
UIPVEShopCell.DataDefine = DataDefine
UIPVEShopCell.DataDestroy = DataDestroy
UIPVEShopCell.OnEnable = OnEnable
UIPVEShopCell.OnDisable = OnDisable
UIPVEShopCell.OnAddListener = OnAddListener
UIPVEShopCell.OnRemoveListener = OnRemoveListener
UIPVEShopCell.ReInit = ReInit
UIPVEShopCell.CreateCostCell = CreateCostCell
UIPVEShopCell.OnSubmitBtnClick = OnSubmitBtnClick
UIPVEShopCell.Refresh = Refresh
UIPVEShopCell.ClearCostCell = ClearCostCell
return UIPVEShopCell
