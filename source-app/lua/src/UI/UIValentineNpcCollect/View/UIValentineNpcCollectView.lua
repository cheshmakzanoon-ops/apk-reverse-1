local UIValentineNpcCollectView = BaseClass("UIValentineNpcCollectView", UIBaseView)
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")
local SendGiftListItem = require("UI.LWUIActValentineSendGiftList.Component.SendGiftListItemComponent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIValentineNpcCollectView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIValentineNpcCollectView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIValentineNpcCollectView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnMask:SetOnClick(function()
    self:OnBtnMaskClick()
  end)
  self.compCommonActivityPopUpBgPart = self.viewSkin:AddComponent(self, CommonActivityPopUpBgPart, 2)
  self.compCommonActivityPopUpBgPart:SetTitle("Valentine_npc_pic_title_01")
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
end

function UIValentineNpcCollectView:ComponentDestroy()
  self.viewSkin = nil
  self.btnMask = nil
  self.compCommonActivityPopUpBgPart = nil
  self.compContent = nil
end

function UIValentineNpcCollectView:ReInit()
  self.activityId = self:GetUserData()
  self.compCommonActivityPopUpBgPart:InitByActivityId(self.activityId)
  self.compCommonActivityPopUpBgPart:SetCloseCallback(function()
    self.ctrl:CloseSelf()
  end)
  self:ReqNpcHistoryData()
end

function UIValentineNpcCollectView:OnRefreshHistoryNodeStatus()
  local dataList = DataCenter.ValentineDataManager:GetCompleteNpc()
  if not dataList or #dataList == 0 then
    Logger.LogError("\230\178\161\230\156\137npc\230\149\176\230\141\174\228\189\134\230\152\175\230\137\147\229\188\128\232\191\153\228\184\170\231\149\140\233\157\162\228\186\134!  self.activityId:" .. tostring(self.activityId))
    return
  end
  for i, v in ipairs(dataList) do
    self:CreateItem(v, i)
  end
end

function UIValentineNpcCollectView:CreateItem(data, index)
  self:GameObjectInstantiateAsync(UIAssets.SendGiftListItem, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.compContent.transform)
    go.transform:Set_localScale(1, 1, 1)
    local name = tostring(index)
    go.name = name
    go:SetActive(true)
    local cellComp = self.compContent:AddComponent(SendGiftListItem, name)
    local param = {}
    param.activityId = self.activityId
    param.npcId = data.npcId
    cellComp:SetData(param)
    cellComp:SetCustomClick(function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeadIconShow, {anim = true}, "-1", "", nil, data.headIcons, HeadIconType.Npc)
    end)
  end)
end

function UIValentineNpcCollectView:DataDefine()
end

function UIValentineNpcCollectView:DataDestroy()
  self.compContent:RemoveComponents(SendGiftListItem)
end

function UIValentineNpcCollectView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ValentineNpcHistoryUpdate, self.OnRefreshHistoryNodeStatus)
end

function UIValentineNpcCollectView:OnRemoveListener()
  self:RemoveUIListener(EventId.ValentineNpcHistoryUpdate, self.OnRefreshHistoryNodeStatus)
  base.OnRemoveListener(self)
end

function UIValentineNpcCollectView:ReqNpcHistoryData()
  local param = {
    activityId = tonumber(self.activityId)
  }
  SFSNetwork.SendMessage(MsgDefines.ValentineSendNpcHistory, param)
end

function UIValentineNpcCollectView:OnBtnMaskClick()
  self.ctrl:CloseSelf()
end

return UIValentineNpcCollectView
