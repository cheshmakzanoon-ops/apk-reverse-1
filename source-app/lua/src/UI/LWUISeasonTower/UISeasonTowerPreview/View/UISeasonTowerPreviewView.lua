local UISeasonTowerPreviewView = BaseClass("UISeasonTowerPreviewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UISeasonTowerPreviewView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:SetData()
end

function UISeasonTowerPreviewView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISeasonTowerPreviewView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnIntro = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnIntro:SetOnClick(function()
    self:OnBtnIntroClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compRewardContent = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.btnBackBlack = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnBackBlack:SetOnClick(function()
    self:OnBtnBackBlackClick()
  end)
end

function UISeasonTowerPreviewView:ComponentDestroy()
  self.viewSkin = nil
  self.btnIntro = nil
  self.textTitle = nil
  self.textDesc = nil
  self.textTime = nil
  self.compRewardContent = nil
  self.btnBackBlack = nil
end

function UISeasonTowerPreviewView:DataDefine()
end

function UISeasonTowerPreviewView:DataDestroy()
end

function UISeasonTowerPreviewView:OnAddListener()
  base.OnAddListener(self)
end

function UISeasonTowerPreviewView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UISeasonTowerPreviewView:OnBtnIntroClick()
  local param = {}
  param.activityRulesStr = Localization:GetString("season_tower_info")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function UISeasonTowerPreviewView:OnBtnBackBlackClick()
  self.ctrl:CloseSelf()
end

function UISeasonTowerPreviewView:SetData()
  self.textTitle:SetLocalText("season_tower_pre_name")
  self.textDesc:SetLocalText("season_tower_pre_desc")
  self:RefreshReward()
  self:Update1000MS()
end

function UISeasonTowerPreviewView:Update1000MS()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = DataCenter.LWSeasonTowerManager:GetFirstStageOpenTime()
  if endTime then
    local leftTime = math.max(endTime - curTime, 0)
    local leftTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    self.textTime:SetText(leftTimeStr)
  end
end

function UISeasonTowerPreviewView:SetAllCellDestroy()
  self.compRewardContent:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function UISeasonTowerPreviewView:RefreshReward()
  self:SetAllCellDestroy()
  self.showList = DataCenter.LWSeasonTowerManager:GetPreviewRewardList()
  self.model = {}
  if self.showList ~= nil then
    for i = 1, table.length(self.showList) do
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.compRewardContent.transform)
        go.transform:Set_localScale(0.9, 0.9, 1)
        go.transform:Set_sizeDelta(150, 150)
        go.transform.pivot = Vector2.New(0.5, 0.5)
        go.name = "item" .. i
        local cell = self.compRewardContent:AddComponent(UICommonResItem, go.name)
        cell:ReInit(self.showList[i])
      end)
    end
  end
end

return UISeasonTowerPreviewView
