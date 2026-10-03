local ActivityDecorationGachaGetRewardView = BaseClass("ActivityDecorationGachaGetRewardView", UIBaseView)
local UIActivityDecorationGachaGetRewardItemComponent = require("UI/UIActivityCenterTable/Component/ActivityDecorationGacha/GetReward/Component/UIActivityDecorationGachaGetRewardItemComponent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")

function ActivityDecorationGachaGetRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
  EventManager:GetInstance():Broadcast(EventId.ActivityDecorationGachaEndGacha)
end

function ActivityDecorationGachaGetRewardView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActivityDecorationGachaGetRewardView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "Panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitleTxt = self:AddComponent(UIText, "Content/bgContent1/titleBg/titleTxt")
  self.textTitleTxt:SetLocalText("decoration_recruit_desc43")
  self.textDes = self:AddComponent(UIText, "Content/DesText")
  self.textDes:SetLocalText("decoration_recruit_desc15")
  self.compItemContent = self:AddComponent(UIBaseContainer, "Content/ItemContent")
  self.textContinue = self:AddComponent(UIText, "Content/ContinueText")
  self.textContinue:SetLocalText("decoration_recruit_desc44")
  self.items = {}
end

function ActivityDecorationGachaGetRewardView:ComponentDestroy()
  self.items = nil
  self.compItemContent:RemoveComponents(UIActivityDecorationGachaGetRewardItemComponent)
  self.btnPanel = nil
  self.textTitleTxt = nil
  self.textDes = nil
  self.compItemContent = nil
  self.textContinue = nil
end

function ActivityDecorationGachaGetRewardView:DataDefine()
  self.logStr = ""
end

function ActivityDecorationGachaGetRewardView:DataDestroy()
  self.logStr = nil
end

function ActivityDecorationGachaGetRewardView:OnOpen()
  self.param = self:GetUserData()
  if self.param == nil then
    return
  end
  self.textDes:SetActive(self.param.isWishComplete)
  table.sort(self.param.data.rewardList, function(a, b)
    return a.pos < b.pos
  end)
  local showDataList = self.ctrl:GetShowDataList(self.param.data.rewardList)
  self:PrintTotalRewardLog(showDataList)
  self.textContinue:SetActive(false)
  local totalCount = #showDataList
  local index = 1
  for i, v in ipairs(showDataList) do
    self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/ActivityCenter/DecorationGacha/UIDecorationGachaGetRewardItem.prefab", function(request)
      if request.isError then
        return
      end
      request.gameObject.transform:SetParent(self.compItemContent.transform)
      request.gameObject.name = tostring(index)
      local cell = self.compItemContent:AddComponent(UIActivityDecorationGachaGetRewardItemComponent, request.gameObject.name)
      cell:ReInit(v, i)
      self.items[i] = cell
      if index == totalCount then
        self:StartPlay()
      end
      index = index + 1
    end)
  end
end

function ActivityDecorationGachaGetRewardView:StartPlay()
  self.textContinue:SetActive(true)
  if self.items then
    for i, v in ipairs(self.items) do
      v:ShowInTime(i * 0.2)
    end
  end
  local log = "ActivityDecorationGachaGetRewardView StartPlay"
  Logger.LogInfo(log)
end

function ActivityDecorationGachaGetRewardView:OnAddListener()
  base.OnAddListener(self)
end

function ActivityDecorationGachaGetRewardView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ActivityDecorationGachaGetRewardView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function ActivityDecorationGachaGetRewardView:PrintTotalRewardLog(list)
  local log = "ActivityDecorationGachaGetRewardView TotalReward: "
  if not table.IsNullOrEmpty(list) then
    local json = rapidjson.encode(list)
    log = log .. json
  end
  Logger.LogInfo(log)
end

return ActivityDecorationGachaGetRewardView
