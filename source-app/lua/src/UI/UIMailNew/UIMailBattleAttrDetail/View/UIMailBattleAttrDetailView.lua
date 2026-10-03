local MailBattleAttrDetailTitle = require("UI.UIMailNew.UIMailBattleAttrDetail.Component.MailBattleAttrDetailTitle")
local UIMailBattleAttrDetailView = BaseClass("UIMailBattleAttrDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local return_btn_path = "UICommonPopUpTitle/panel"
local title_txt_Path = "UICommonPopUpTitle/Common_img_title/titleText"
local content_path = "ScrollView/Viewport/Content"
local empty_txt_path = "TxtEmpty"
local txt_left_path = "Maintitlebg/leftName"
local txt_center_path = "Maintitlebg/centerName"
local txt_right_path = "Maintitlebg/rightName"

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

local function ComponentDefine(self)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.title_txt = self:AddComponent(UIText, title_txt_Path)
  self.empty_txt = self:AddComponent(UIText, empty_txt_path)
  self.title_txt:SetLocalText(311048)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.txt_left = self:AddComponent(UIText, txt_left_path)
  self.txt_center = self:AddComponent(UIText, txt_center_path)
  self.txt_right = self:AddComponent(UIText, txt_right_path)
  self.txt_center:SetLocalText(163142)
  self.txt_left:SetLocalText(310164)
  self.txt_right:SetLocalText(310165)
end

local function ComponentDestroy(self)
  self:SetAllCellDestroy()
  self.close_btn = nil
  self.return_btn = nil
  self.title_txt = nil
end

local function DataDefine(self)
  local param = self:GetUserData()
  self.leftFightData = param.leftFightData
  self.rightFightData = param.rightFightData
  self.leftBattleEffect = param.leftBattleEffect
  self.rightBattleEffect = param.rightBattleEffect
  self.leftUuid = param.leftUuid
  self.rightUuid = param.rightUuid
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshData()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self)
  self:SetAllCellDestroy()
  local list = self.ctrl:GetDetailList(self.leftFightData, self.rightFightData, self.leftBattleEffect, self.rightBattleEffect, self.leftUuid, self.rightUuid)
  local totalNum = 0
  local createNum = 0
  for k, v in pairs(list) do
    if 0 < v.leftNum or 0 < v.rightNum then
      totalNum = totalNum + 1
      if self.model[k] == nil then
        self.model[k] = self:GameObjectInstantiateAsync(UIAssets.MailBattleAttrDetailTitle, function(request)
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
          local cell = self.content:AddComponent(MailBattleAttrDetailTitle, nameStr)
          cell:ReInit(v)
        end)
      end
    end
  end
  if totalNum <= 0 then
    self.empty_txt:SetText(Localization:GetString("163135"))
  else
    self.empty_txt:SetText("")
  end
end

local function SetAllCellDestroy(self)
  self.content:RemoveComponents(MailBattleAttrDetailTitle)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

UIMailBattleAttrDetailView.OnCreate = OnCreate
UIMailBattleAttrDetailView.OnDestroy = OnDestroy
UIMailBattleAttrDetailView.OnEnable = OnEnable
UIMailBattleAttrDetailView.OnDisable = OnDisable
UIMailBattleAttrDetailView.ComponentDefine = ComponentDefine
UIMailBattleAttrDetailView.ComponentDestroy = ComponentDestroy
UIMailBattleAttrDetailView.DataDefine = DataDefine
UIMailBattleAttrDetailView.DataDestroy = DataDestroy
UIMailBattleAttrDetailView.RefreshData = RefreshData
UIMailBattleAttrDetailView.SetAllCellDestroy = SetAllCellDestroy
return UIMailBattleAttrDetailView
