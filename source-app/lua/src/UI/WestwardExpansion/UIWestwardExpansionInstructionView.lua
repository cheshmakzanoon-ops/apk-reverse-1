local UIWestwardExpansionInstructionView = BaseClass("UIWestwardExpansionInstructionView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIWestwardExpansionInstructionView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIWestwardExpansionInstructionView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWestwardExpansionInstructionView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgMonster3 = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgMonster1 = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.imgMonster2 = self.viewSkin:AddComponent(self, UIImage, 6)
  self.reqs = {}
  self.textTitle:SetLocalText(2000047)
  self.textDesc:SetLocalText("activity_1200043_tips13")
  self.panel = self:AddComponent(UIButton, "panel")
  self.panel:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  local activity = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.WestwardExpansion.Type)
  if activity then
    local activityRulesStr = Localization:GetString(activity.story)
    activityRulesStr = activityRulesStr .. [[


]] .. Localization:GetString("activity_1200043_tips13")
    self.textDesc:SetText(activityRulesStr)
  end
end

function UIWestwardExpansionInstructionView:ComponentDestroy()
  self.viewSkin = nil
  self.imgMonster3 = nil
  self.imgMonster1 = nil
  self.textDesc = nil
  self.btnClose = nil
  self.textTitle = nil
  self.imgMonster2 = nil
  if self.reqs then
    for _, v in pairs(self.reqs) do
      v:Destroy()
    end
  end
  self.reqs = {}
end

function UIWestwardExpansionInstructionView:DataDefine()
  self.data = {}
  for i = 1, 3 do
    local monster = LuaEntry.DataConfig:TryGetStr("monster_refresh_map_dialog", "k" .. i)
    monster = string.split(monster, "|")
    table.insert(self.data, monster)
  end
end

function UIWestwardExpansionInstructionView:DataDestroy()
end

function UIWestwardExpansionInstructionView:OnAddListener()
  base.OnAddListener(self)
end

function UIWestwardExpansionInstructionView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIWestwardExpansionInstructionView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

local prefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/WestwardExpansion/ExpansionInstructionCell.prefab"

function UIWestwardExpansionInstructionView:RefreshView()
  if self.reqs then
    for _, v in pairs(self.reqs) do
      v:Destroy()
    end
  end
  self.reqs = {}
  for i = 1, 3 do
    local data = self.data[i]
    for _, key in pairs(data) do
      self.reqs[key] = self:GameObjectInstantiateAsync(prefabPath, function(req)
        if IsNull(req) then
          return
        end
        local gameObject = req.gameObject
        local transform = gameObject.transform
        transform:SetParent(self["imgMonster" .. i].transform)
        transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local text = transform:Find("LocationText"):GetComponent(typeof(CS.TextMeshProUGUIEx))
        text:Native_SetText(Localization:GetString(key))
      end)
    end
  end
end

return UIWestwardExpansionInstructionView
