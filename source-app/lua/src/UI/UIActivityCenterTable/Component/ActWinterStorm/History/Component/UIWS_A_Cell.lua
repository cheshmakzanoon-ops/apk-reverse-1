local base = UIAsyncContainer
local UIWS_A_Cell = BaseClass("UIWS_A_Cell", UIAsyncContainer)
local BG_PATH = "ChatItems/FX_common_diban_bai.png"

function UIWS_A_Cell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWS_A_Cell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWS_A_Cell:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 4)
end

function UIWS_A_Cell:ComponentDestroy()
  self.viewSkin = nil
  self.imgIcon = nil
  self.textName = nil
  self.textDesc = nil
  self.imgBg = nil
end

function UIWS_A_Cell:DataDefine()
  local chatMode = self.view.chatMode
  self.imgBg:LoadSpriteAuto(ChatUIThemeConfig.UIPrefix[chatMode] .. BG_PATH)
  local color = ChatUIThemeConfig.BF_Winter_Achievement_TextColor[1][chatMode]
  self.textName:SetColor(color)
  color = ChatUIThemeConfig.BF_Winter_Achievement_TextColor[2][chatMode]
  self.textDesc:SetColor(color)
end

function UIWS_A_Cell:DataDestroy()
  self.id = nil
end

function UIWS_A_Cell:OnAddListener()
  base.OnAddListener(self)
end

function UIWS_A_Cell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIWS_A_Cell:SetData(id)
  self.id = id
  self:RefreshView()
end

function UIWS_A_Cell:UpdateData()
  if self.id == nil then
    return
  end
  local lineData = LocalController:instance():getLine(TableName.LW_BattleField_Achievement, self.id)
  if lineData ~= nil then
    local icon = lineData:getValue("icon")
    if not string.IsNullOrEmpty(icon) then
      self.imgIcon:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldWinterAchievementPath, icon))
    end
    self.textName:SetLocalText(lineData:getValue("name"))
    self.textDesc:SetLocalText(lineData:getValue("desc"), lineData:getValue("value"))
  end
end

return UIWS_A_Cell
