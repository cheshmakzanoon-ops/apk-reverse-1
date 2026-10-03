local UIPveBattleSoldierTab = BaseClass("UIPveBattleSoldierTab", UIBaseContainer)
local base = UIBaseContainer
local UIPveBattleSoldierItem = require("UI.UIPVE.UIPveBattleSoldierList.Component.UIPveBattleSoldierItem")
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self.title = self:AddComponent(UIText, "layout/TextTitle")
  self.des = self:AddComponent(UIText, "TextDes")
  self.content = self:AddComponent(UIBaseContainer, "content")
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ClearContent(self)
  self.content:RemoveComponents(UIPveBattleSoldierItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

local function SetData(self, list, isLeft, maxNum)
  self:ClearContent()
  local count = 0
  if list ~= nil and 0 < #list then
    local length = #list
    local sizeDelta = self.rectTransform.sizeDelta
    local x = 750
    if length == 1 then
      x = 250
    elseif length == 2 then
      x = 500
    end
    local y = sizeDelta.y
    self.rectTransform:Set_sizeDelta(x, y)
    table.sort(list, function(aData, bData)
      if aData.level ~= bData.level then
        return aData.level > bData.level
      end
      return aData.armyId > bData.armyId
    end)
    for k, v in pairs(list) do
      count = count + tonumber(v.count)
      if self.model[v] == nil then
        self.model[v] = self:GameObjectInstantiateAsync(UIAssets.UIPveBattleSoliderItem, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          go.gameObject:SetActive(true)
          go.transform:SetParent(self.content.transform)
          go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          local nameStr = tostring(NameCount)
          go.name = nameStr
          NameCount = NameCount + 1
          local cell = self.content:AddComponent(UIPveBattleSoldierItem, nameStr)
          cell:SetItemShow(v)
        end)
      end
    end
  end
  if isLeft == true then
    local str = ": " .. string.GetFormattedSeperatorNum(count) .. "/" .. string.GetFormattedSeperatorNum(maxNum)
    self.title:SetText(Localization:GetString("400057") .. str)
    self.des:SetText(Localization:GetString("400032"))
  else
    local str = ": " .. string.GetFormattedSeperatorNum(count) .. "/" .. string.GetFormattedSeperatorNum(count)
    self.title:SetText(Localization:GetString("400057") .. str)
    self.des:SetText("")
  end
end

UIPveBattleSoldierTab.OnCreate = OnCreate
UIPveBattleSoldierTab.OnDestroy = OnDestroy
UIPveBattleSoldierTab.OnEnable = OnEnable
UIPveBattleSoldierTab.OnDisable = OnDisable
UIPveBattleSoldierTab.ClearContent = ClearContent
UIPveBattleSoldierTab.SetData = SetData
return UIPveBattleSoldierTab
