local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UIActBountyHunterRootComponent = BaseClass("UIActBountyHunterRootComponent", base)
local Localization = CS.GameEntry.Localization
local UIActBountyHunterMain = require("UI/UIActivityCenterTable/Component/ActBountyHunter/UIActBountyHunterMain")
local UIActBountyHunterGuideComponent = require("UI/UIActivityCenterTable/Component/ActBountyHunter/Component/UIActBountyHunterGuideComponent")
local Const = require("UI/UIActivityCenterTable/Component/ActBountyHunter/BountyHunterConstant")

function UIActBountyHunterRootComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActBountyHunterRootComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActBountyHunterRootComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compGuideRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.compMainRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
end

function UIActBountyHunterRootComponent:ComponentDestroy()
  if self.mainCompReq then
    self.mainCompReq:Destroy()
    self.mainCompReq = nil
  end
  if self.guideCompReq then
    self.guideCompReq:Destroy()
    self.guideCompReq = nil
  end
  self.compMain = nil
  self.compGuide = nil
  self.viewSkin = nil
  self.compGuideRoot = nil
  self.compMainRoot = nil
end

function UIActBountyHunterRootComponent:DataDefine()
end

function UIActBountyHunterRootComponent:DataDestroy()
end

function UIActBountyHunterRootComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIActBountyHunterRootComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActBountyHunterRootComponent:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = tonumber(activityId)
  if not self.activityId then
    return
  end
  self.bountyHunterData = DataCenter.BountyHunterActDataManager:GetActData(self.activityId)
  if not self.bountyHunterData then
    Logger.LogError("bountyHunterData is null! " .. activityId)
    return
  end
  local showGuide = not self.bountyHunterData:HasShownFirstGuideUI()
  if showGuide then
    self.compGuideRoot:SetActive(true)
    if self.guideCompReq == nil then
      self.guideCompReq = self:GameObjectInstantiateAsync(Const.FIRST_GUIDE_UI_PREFAB_PATH, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.compGuideRoot.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        self.compGuide = self.compGuideRoot:AddComponent(UIActBountyHunterGuideComponent, go.name)
        self.compGuide:ReInit(self.activityId, function()
          self:OnGuideEnterClick()
        end, function()
          return self:IsCanEnter()
        end, function()
          self:OnGuideClose()
        end)
        self.compGuide:SetOffsetMinXY(0, 0)
        self.compGuide:SetOffsetMaxXY(0, 0)
      end)
    elseif self.compGuide ~= nil then
      self.compGuide:ReInit(self.activityId, function()
        self:OnGuideEnterClick()
      end, function()
        return self:IsCanEnter()
      end, function()
        self:OnGuideClose()
      end)
    end
  end
  self.compMainRoot:SetActive(not showGuide)
  if self.mainCompReq == nil then
    self.mainCompReq = self:GameObjectInstantiateAsync(Const.MAIN_UI_PREFAB_PATH, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.compMainRoot.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      self.compMain = self.compMainRoot:AddComponent(UIActBountyHunterMain, go.name)
      self.compMain:SetData(self.activityId, not showGuide)
    end)
  elseif self.compMain ~= nil then
    self.compMain:SetData(self.activityId, not showGuide)
  end
  PostEventLog.Track(PostEventLog.Defines.BountyHunterOpenMain)
end

function UIActBountyHunterRootComponent:OnGuideEnterClick()
  self.compMainRoot:SetActive(true)
  if self.compMain then
    self.compMain:ShowScene()
  end
end

function UIActBountyHunterRootComponent:OnGuideClose()
  if self.compMain then
    self.compMain:EnterScene()
  end
  if self.compGuideRoot then
    self.compGuideRoot:SetActive(false)
  end
end

function UIActBountyHunterRootComponent:IsCanEnter()
  if self.compMain and self.compMain:IsReadyToEnter() then
    return true
  end
  return false
end

return UIActBountyHunterRootComponent
