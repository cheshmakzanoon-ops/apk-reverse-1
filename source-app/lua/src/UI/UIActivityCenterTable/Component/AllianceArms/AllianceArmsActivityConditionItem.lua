local AllianceArmsActivityConditionItem = BaseClass("AllianceArmsActivityConditionItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroTipsView = require("UI.UIHeroTips.View.UIHeroTipsView")
local desTxt_path = "Content/TxtDesc"
local valueTxt_path = "Content/TxtValue"
local divImg_path = "ImgDiv"
local content_path = "Content"
local moneyImg_path = "Content/ImgMoney"
local infoBtn_path = "Content/TxtValue/tipBtn"
local jumpBtn_path = "Content/btnGoto"
local groupIcon_path = "Content/GroupIcon"

local function OnCreate(self)
  base.OnCreate(self)
  self.desTxt = self:AddComponent(UIText, desTxt_path)
  self.valueTxt = self:AddComponent(UIText, valueTxt_path)
  self.divImg = self:AddComponent(UIImage, divImg_path)
  self.content = self:AddComponent(UIButton, content_path)
  self.content:SetOnClick(function()
    self:OnClickGroupJumpBtn()
  end)
  self.moneyImg = self:AddComponent(UIImage, moneyImg_path)
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.infoBtn:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
  self.btnGoto = self:AddComponent(UIButton, jumpBtn_path)
  self.btnGoto.transform:Set_localScale(CommonUtil.IsArabic() and -1 or 1, 1, 1)
  self.btnGoto:SetOnClick(function()
    self:Goto()
  end)
  self.groupIcon = self:AddComponent(UIImage, groupIcon_path)
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function RefreshData(self, data, index)
  if data == nil then
    Logger.LogError("\230\156\170\230\159\165\230\137\190\229\136\176score\232\161\168\228\184\173group\233\133\141\231\189\174\229\135\134\231\161\174\230\149\176\230\141\174")
    return
  end
  self.data = data
  local id = data.id
  local name = data.name
  local value = data.value
  if value ~= nil and type(value) == "table" and value.Length > 0 then
    local valueLuaTable = {}
    for i = 1, value.Length do
      table.insert(valueLuaTable, value[i - 1])
    end
    local descExpand = CommonUtil.GetNameByParams(name, valueLuaTable)
    self.desTxt:SetText(descExpand)
  elseif data.valueStr ~= nil then
    local valueArr = string.split(data.valueStr, ",")
    local descExpand = CommonUtil.GetNameByParams(name, valueArr)
    self.desTxt:SetText(descExpand)
  else
    self.desTxt:SetLocalText(name, value)
  end
  if string.IsNullOrEmpty(data.points) or tonumber(data.points) == 0 then
    self.valueTxt:SetLocalText(372564)
    self.infoBtn:SetActive(true)
  else
    local num = self:JudgeScienceEffect()
    self.valueTxt:SetText("+ " .. num)
    self.infoBtn:SetActive(false)
  end
  local state = math.fmod(index, 2) == 1
  self.divImg:SetActive(state)
  local scoreId = self.data.id
  local iconPath = "Assets/Main/Sprites/UI/UILWBag/ljq_youling_tanhao.png"
  if 0 >= self.data.groupId then
    iconPath = tonumber(GetTableData(TableName.Score, scoreId, "icon_path")) or ""
  end
  self.groupIcon:SetActive(not string.IsNullOrEmpty(iconPath))
  if not string.IsNullOrEmpty(iconPath) then
    self.groupIcon:LoadSprite(iconPath)
  end
end

function AllianceArmsActivityConditionItem:JudgeScienceEffect()
  local num = self.data.points * 10
  local numStr = ""
  local effectNum = LuaEntry.Effect:GetAllianceArmsEffectNum(num, self.data.effectList)
  if num < effectNum then
    effectNum = effectNum * 0.1
    local finalNum = string.GetFormattedSeperatorNum(effectNum)
    numStr = string.format("<color=#94e138>%s</color>", finalNum)
    return numStr
  end
  num = num * 0.1
  return string.GetFormattedSeperatorNum(num)
end

local function OnClickInfoBtn(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.infoBtn.transform.position + Vector3.New(0, 10, 0) * scaleFactor
  local param = UIHeroTipsView.Param.New()
  param.content = Localization:GetString(self.data.tips)
  param.dir = UIHeroTipsView.Direction.ABOVE
  param.defWidth = 400
  param.pivot = 0.85
  param.position = position
  param.bindObject = self.gameObject
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTips, {anim = false}, param)
end

local function OnClickGroupJumpBtn(self)
  if self.data.groupId > 0 then
    local param = {}
    param.groupId = self.data.groupId
    param.listInGroup = self.data.listInGroup
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllyDuelGroupTip, {anim = true}, param)
  end
end

local function Goto(self)
  local scoreId = self.data.id
  local gotoType = tonumber(GetTableData(TableName.Score, scoreId, "gotype2")) or 0
  local gopara = GetTableData(TableName.Score, scoreId, "gopara") or ""
  local gotoPara = {}
  if not string.IsNullOrEmpty(gopara) then
    gotoPara = string.split(gopara, ";")
  end
  GoToUtil.GoToByTypeAndParam(gotoType, gotoPara)
end

AllianceArmsActivityConditionItem.OnCreate = OnCreate
AllianceArmsActivityConditionItem.OnDestroy = OnDestroy
AllianceArmsActivityConditionItem.RefreshData = RefreshData
AllianceArmsActivityConditionItem.OnClickInfoBtn = OnClickInfoBtn
AllianceArmsActivityConditionItem.OnClickGroupJumpBtn = OnClickGroupJumpBtn
AllianceArmsActivityConditionItem.Goto = Goto
return AllianceArmsActivityConditionItem
