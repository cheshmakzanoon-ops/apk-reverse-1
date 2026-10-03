local base = UIBaseContainer
local UIIdleGameTaskEventDetailInvite = BaseClass("UIIdleGameTaskEventDetailInvite", UIBaseContainer)
local UIIdleGameTaskEventInvitePlayerItemComponent = require("UI.T11IdleGame.T11IdleGameTaskEventDetail.Component.UIIdleGameTaskEventInvitePlayerItemComponent")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function UIIdleGameTaskEventDetailInvite:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIIdleGameTaskEventDetailInvite:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIIdleGameTaskEventDetailInvite:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textInviteTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnMore = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnMore:SetOnClick(function()
    self:OnBtnMoreClick()
  end)
  self.compHeadIconList = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
end

function UIIdleGameTaskEventDetailInvite:ComponentDestroy()
  self.viewSkin = nil
  self.textInviteTitle = nil
  self.btnMore = nil
  self.compHeadIconList = nil
end

function UIIdleGameTaskEventDetailInvite:DataDefine()
  self.playerHeadReqsList = {}
  self.playerHeadScriptList = {}
  self.eventUuid = nil
end

function UIIdleGameTaskEventDetailInvite:DataDestroy()
  self:ClearContent()
  self.eventUuid = nil
end

function UIIdleGameTaskEventDetailInvite:OnAddListener()
  base.OnAddListener(self)
end

function UIIdleGameTaskEventDetailInvite:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIIdleGameTaskEventDetailInvite:RefreshShow(eventUuid, requirementStr)
  self.textInviteTitle:SetText(requirementStr)
  self.eventUuid = eventUuid
  self:ClearContent()
  local invitePlayerInfoList = DataCenter.T11IdleGameDataManager:GetInvitePlayerInfoList(eventUuid)
  local tempPlayerInfoList = DeepCopy(invitePlayerInfoList)
  if #tempPlayerInfoList < 4 then
    local remainDataNum = 4 - #tempPlayerInfoList
    for i = 1, remainDataNum do
      table.insert(tempPlayerInfoList, {isEmptyPlace = true})
    end
  else
    local tmpList = tempPlayerInfoList
    tempPlayerInfoList = {}
    for i = 1, 4 do
      tempPlayerInfoList[i] = tmpList[i]
    end
  end
  self:RefreshPlayerHeads(tempPlayerInfoList, self.compHeadIconList)
end

function UIIdleGameTaskEventDetailInvite:ClearContent()
  if table.count(self.playerHeadScriptList) > 0 then
    self.compHeadIconList:RemoveComponents(UIIdleGameTaskEventInvitePlayerItemComponent)
    self.playerHeadScriptList = {}
  end
  if table.count(self.playerHeadReqsList) then
    for _, req in pairs(self.playerHeadReqsList) do
      req:Destroy()
    end
    self.playerHeadReqsList = {}
  end
end

function UIIdleGameTaskEventDetailInvite:RefreshPlayerHeads(invitePlayerInfoList, contentScript)
  if not table.IsNullOrEmpty(invitePlayerInfoList) then
    for i, data in pairs(invitePlayerInfoList) do
      local req = self:GameObjectInstantiateAsync(Const.InvitePlayerItemPath, function(req)
        if req == nil or IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = "UIIdleGameTaskEventInvitePlayerItemComponent" .. i
        item:SetActive(true)
        item.transform:SetParent(contentScript.transform)
        item.transform:Set_localScale(1, 1, 1)
        item.transform:Set_sizeDelta(90, 90)
        item.transform:Set_pivot(0.5, 0.5)
        local cell = contentScript:AddComponent(UIIdleGameTaskEventInvitePlayerItemComponent, item.name)
        cell:ReInit(data, false)
        table.insert(self.playerHeadScriptList, cell)
      end)
      table.insert(self.playerHeadReqsList, req)
    end
  end
end

function UIIdleGameTaskEventDetailInvite:OnBtnMoreClick()
  DataCenter.T11IdleGameDataManager:SendIdleGameEventGetMessage(LuaEntry.Player.uid, self.eventUuid, Const.IdleGameEventGetType.GetDataAndOpenHelpView)
end

return UIIdleGameTaskEventDetailInvite
