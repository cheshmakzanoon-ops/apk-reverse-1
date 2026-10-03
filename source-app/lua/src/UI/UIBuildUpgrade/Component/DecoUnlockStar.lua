local DecoUnlockStar = BaseClass("DecoUnlockStar", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIDesCell = require("UI.UIBuildUpgrade.Component.DecoStarDesc")
local star_stage_tips_path = "StarStageTips"
local active_state_text_path = "StarStageTips/ActiveStateText"
local unlock_num_text_path = "StarStageTips/UnlockNumText"
local stage_title_text_path = "StarStageTips/StageTitleText"
local arrow_img_path = "StarStageTips/ArrowImg"
local unlcok_prop_layout_path = "StarStageTips/UnlcokPropLayout"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.closeBtn = self:AddComponent(UIButton, "")
  self.closeBtn:SetOnClick(function()
    if not IsNull(self.gameObject) then
      self.gameObject:SetActive(false)
    end
  end)
  self.tipRootObj = self:AddComponent(UIBaseContainer, star_stage_tips_path)
  self.titleText = self:AddComponent(UIText, stage_title_text_path)
  self.activeStateText = self:AddComponent(UIText, active_state_text_path)
  self.unlockProgressText = self:AddComponent(UIText, unlock_num_text_path)
  self.arrowObj = self:AddComponent(UIBaseContainer, arrow_img_path)
  self.descRoot = self:AddComponent(UIBaseContainer, unlcok_prop_layout_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.desCells = {}
end

local function DataDestroy(self)
  self.desCells = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function DecoUnlockStar:SetData(screenPosition, curProgress, progressData, isMaxLv)
  if not curProgress or not progressData then
    return
  end
  self.progressData = progressData
  self.isMaxLv = isMaxLv
  self.gameObject:SetActive(true)
  local offsetY = -50
  local ScreenSize = CS.UnityEngine.Screen
  local screenWidth = ScreenSize.width
  local tipWidth, tipHeight = self.tipRootObj.rectTransform:Get_sizeDelta()
  local halfWidth = tipWidth / 2
  local minScreenX = 0
  local maxScreenX = screenWidth
  local uiPos = PosConverse.ScreenToUIPos(self.transform, screenPosition)
  local minUIPosX = PosConverse.ScreenToUIPos(self.transform, Vector2.New(minScreenX, 0)).x + halfWidth
  local maxUIPosX = PosConverse.ScreenToUIPos(self.transform, Vector2.New(maxScreenX, 0)).x - halfWidth
  local fixUIPosX = Mathf.Clamp(uiPos.x, minUIPosX, maxUIPosX)
  self.tipRootObj.transform.localPosition = Vector3.New(fixUIPosX, uiPos.y + offsetY, 0)
  local arrowUIPos = PosConverse.ScreenToUIPos(self.tipRootObj.transform, screenPosition)
  self.arrowObj.transform.localPosition = Vector3.New(arrowUIPos.x, self.arrowObj.transform.localPosition.y, 0)
  local isUnlock = curProgress >= progressData.stage_need or self.isMaxLv
  if isUnlock then
    local str = Localization:GetString(280124)
    self.activeStateText:SetText(string.format("<color=#2A2830>%s</color>", str))
    self.titleText:SetLocalText("new_uav_level_obtain_desc2")
  else
    local str = Localization:GetString(130261)
    self.activeStateText:SetText(string.format("<color=#736863>%s</color>", str))
    self.titleText:SetLocalText("worker_preview_desc2")
  end
  local groupId = progressData.group
  local level = progressData.level
  local maxProgressForLv = DataCenter.DecorationUpgradeTemplateManager:GetMaxProgressInfo(groupId, level)
  if not maxProgressForLv then
    return
  end
  self.unlockProgressText:SetText(string.format("%s/%s", progressData.stage_need, maxProgressForLv.stage_need))
  self:InitInfoDes()
end

function DecoUnlockStar:InitInfoDes()
  self:ClearAllDescCell()
  self.desCells = {}
  local paramList = DataCenter.DecorationUpgradeTemplateManager:GetSingleStarEffect(self.progressData.group, self.progressData.level, self.progressData.progressIndex)
  for id, v in pairs(paramList) do
    local data = {}
    data.effectId = id
    data.effectValue = v
    self:AddDesCell(data)
  end
end

function DecoUnlockStar:ClearAllDescCell()
  if self.desCells then
    for _, v in ipairs(self.desCells) do
      v.inst:Destroy()
    end
  end
  self.desCells = nil
end

function DecoUnlockStar:AddDesCell(param)
  local cell = {}
  cell.param = param
  table.insert(self.desCells, cell)
  cell.inst = self:GameObjectInstantiateAsync(UIAssets.DesCell4DecoStarUnlock, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.descRoot.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.transform:SetAsLastSibling()
    local nameStr = tostring(NameCount)
    go.name = nameStr
    NameCount = NameCount + 1
    local temp = self.descRoot:AddComponent(UIDesCell, nameStr)
    temp:ReInit(cell.param)
    cell.model = temp
  end)
end

DecoUnlockStar.OnCreate = OnCreate
DecoUnlockStar.OnDestroy = OnDestroy
DecoUnlockStar.OnEnable = OnEnable
DecoUnlockStar.OnDisable = OnDisable
DecoUnlockStar.ComponentDefine = ComponentDefine
DecoUnlockStar.ComponentDestroy = ComponentDestroy
DecoUnlockStar.DataDefine = DataDefine
DecoUnlockStar.DataDestroy = DataDestroy
DecoUnlockStar.OnAddListener = OnAddListener
DecoUnlockStar.OnRemoveListener = OnRemoveListener
return DecoUnlockStar
