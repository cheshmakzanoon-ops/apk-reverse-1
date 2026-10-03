local AllianceMemberBtnItem = require("UI.UIAlliance.UIAllianceMemberTip.Component.AllianceMemberBtnItem")
local UIAllianceMemberTipView = BaseClass("UIAllianceMemberTipView", UIBaseView)
local base = UIBaseView
local tips_path = "Tips"
local content_path = "Tips/content"
local return_btn_path = "Panel"
local arrow_path = "Tips/arrow"

local function OnCreate(self)
  base.OnCreate(self)
  self.tips = self:AddComponent(UIBaseContainer, tips_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.content_view = self.content.transform:GetComponent(typeof(CS.UnityEngine.UI.GridLayoutGroup))
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.arrowN = self:AddComponent(UIBaseContainer, arrow_path)
  local uid, rank, posX, posY, selfRank, UIName, name, openType = self:GetUserData()
  self:Refresh(uid, rank, posX, posY, selfRank, UIName, name, openType)
end

local function OnDestroy(self)
  self.content = nil
  self.tips = nil
  self.return_btn = nil
  base.OnDestroy(self)
end

local function SetAllCellDestroy(self)
  self.content:RemoveComponents(AllianceMemberBtnItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnDragUICloseTip, self.OnClickCloseBtn)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnDragUICloseTip, self.OnClickCloseBtn)
  base.OnRemoveListener(self)
end

local function Refresh(self, uid, rank, posX, posY, selfRank, UIName, name, openType)
  self.rank = rank
  self.uid = uid
  self.posX = posX + 25
  self.posY = posY
  self.selfRank = selfRank
  self.name = name
  self.UIName = UIName
  self.openType = openType
  self:RefreshData()
end

local function RefreshData(self)
  local v3 = self.tips.transform.position
  v3.x = self.posX
  v3.y = self.posY
  self.tips.transform.position = v3
  local columnCount = self.openType ~= AllianceMemberOpenType.AllianceMember and self.openType ~= AllianceMemberOpenType.OtherAlMember and 1 or 2
  self.content_view.constraintCount = columnCount
  self:SetAllCellDestroy()
  local list = self.view.ctrl:GetAllianceMemberBtnList(self.rank, self.uid, self.selfRank, self.UIName, self.name, self.openType)
  if list ~= nil then
    self.modelCount = 0
    for i = 1, table.length(list) do
      self.modelCount = self.modelCount + 1
      self.model[self.modelCount] = self:GameObjectInstantiateAsync(UIAssets.AllianceMemberBtnItem, function(request)
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
        local cell = self.content:AddComponent(AllianceMemberBtnItem, nameStr, list[i])
      end)
    end
  end
  self:CheckAlign()
end

local function CheckAlign(self)
  local ScreenSize = CS.UnityEngine.Screen
  local ScreenWidth = ScreenSize.width
  local ScreenHeight = ScreenSize.height
  local scale = ScreenHeight / 750.0
  local _rect = self.content.rectTransform.rect
  local BgWidth = _rect.width * scale
  local BgHeight = _rect.height * scale
  local _screenPos = PosConverse.WorldToScreenPos(self.tips.transform.position)
  local overY = _screenPos.y - BgHeight / 2
  if overY < 0 then
    local tipsX, tipsY = self.tips.transform:Get_localPosition()
    self.tips.transform:SetLocalPositionY(tipsY - overY)
  end
  self.arrowN.transform:SetPositionY(self.posY)
end

local function OnClickCloseBtn(self)
  self.ctrl:CloseSelf()
end

UIAllianceMemberTipView.OnCreate = OnCreate
UIAllianceMemberTipView.OnDestroy = OnDestroy
UIAllianceMemberTipView.RefreshData = RefreshData
UIAllianceMemberTipView.Refresh = Refresh
UIAllianceMemberTipView.OnEnable = OnEnable
UIAllianceMemberTipView.OnDisable = OnDisable
UIAllianceMemberTipView.SetAllCellDestroy = SetAllCellDestroy
UIAllianceMemberTipView.CheckAlign = CheckAlign
UIAllianceMemberTipView.OnAddListener = OnAddListener
UIAllianceMemberTipView.OnRemoveListener = OnRemoveListener
UIAllianceMemberTipView.OnClickCloseBtn = OnClickCloseBtn
return UIAllianceMemberTipView
