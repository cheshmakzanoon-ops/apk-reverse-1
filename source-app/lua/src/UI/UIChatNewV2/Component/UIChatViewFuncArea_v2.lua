local base = UIBaseContainer
local UIChatViewFuncArea_v2 = BaseClass("UIChatViewFuncArea_v2", base)
local UIFuncItemScript = require("UI.UIChatNewV2.Component.UIChatViewFuncAreaItem_v2")
local gridRoot_path = "Main/Grid"
local InstanceRequestState = CS.InstanceRequest.State

function UIChatViewFuncArea_v2:OnCreate()
  base.OnCreate(self)
  self.gridRoot = self:AddComponent(UIBaseContainer, gridRoot_path)
  self.funcItemModelList = {}
  self.funcItemScriptList = {}
  self.FuncsPanelRoomSet = {
    Private = {
      funcTypes = {
        ChatBottomFuncConfig.RedPackage,
        ChatBottomFuncConfig.PhotoAlbum,
        ChatBottomFuncConfig.TranslateAll,
        ChatBottomFuncConfig.Gift,
        ChatBottomFuncConfig.ShareMyPoint
      },
      category = ChatRoomCategory.PRIVATE,
      group = ChatGroupType.GROUP_CUSTOM
    },
    GroupChat = {
      funcTypes = {
        ChatBottomFuncConfig.PhotoAlbum,
        ChatBottomFuncConfig.TranslateAll,
        ChatBottomFuncConfig.ShareMyPoint
      },
      category = ChatRoomCategory.PRIVATE,
      group = ChatGroupType.GROUP_CUSTOM_GROUP
    },
    FriendsCircleComment = {
      funcTypes = {
        ChatBottomFuncConfig.TranslateAll
      },
      group = ChatGroupType.GROUP_FRIENDS_CIRCLE_COMMENT_ROOM
    },
    GROUP_COUNTRY = {
      funcTypes = {
        ChatBottomFuncConfig.RedPackage,
        ChatBottomFuncConfig.TranslateAll,
        ChatBottomFuncConfig.ShareMyPoint
      },
      group = ChatGroupType.GROUP_COUNTRY
    },
    GROUP_LANGUAGE = {
      funcTypes = {
        ChatBottomFuncConfig.RedPackage,
        ChatBottomFuncConfig.TranslateAll,
        ChatBottomFuncConfig.ShareMyPoint
      },
      group = ChatGroupType.GROUP_LANGUAGE
    },
    GROUP_ALLIANCE = {
      funcTypes = {
        ChatBottomFuncConfig.RedPackage,
        ChatBottomFuncConfig.PhotoAlbum,
        ChatBottomFuncConfig.TranslateAll,
        ChatBottomFuncConfig.ShareMyPoint
      },
      group = ChatGroupType.GROUP_ALLIANCE
    },
    GROUP_ALLIANCE_NOTICE = {
      funcTypes = {
        ChatBottomFuncConfig.RedPackage
      },
      group = ChatGroupType.GROUP_ALLIANCE_NOTICE
    },
    GROUP_ALLIANCE_MANAGER = {
      funcTypes = {
        ChatBottomFuncConfig.RedPackage,
        ChatBottomFuncConfig.PhotoAlbum,
        ChatBottomFuncConfig.TranslateAll,
        ChatBottomFuncConfig.ShareMyPoint
      },
      group = ChatGroupType.GROUP_ALLIANCE_MANAGER
    },
    GROUP_CROSS_SERVER = {
      funcTypes = {
        ChatBottomFuncConfig.RedPackage,
        ChatBottomFuncConfig.TranslateAll,
        ChatBottomFuncConfig.ShareMyPoint
      },
      group = ChatGroupType.GROUP_CROSS_SERVER
    },
    GROUP_DRAGON_ALL_SERVER = {
      funcTypes = {
        ChatBottomFuncConfig.RedPackage,
        ChatBottomFuncConfig.TranslateAll,
        ChatBottomFuncConfig.ShareMyPoint
      },
      group = ChatGroupType.GROUP_DRAGON_ALL_SERVER
    },
    GROUP_DRAGON_SELF_SERVER = {
      funcTypes = {
        ChatBottomFuncConfig.RedPackage,
        ChatBottomFuncConfig.TranslateAll,
        ChatBottomFuncConfig.ShareMyPoint
      },
      group = ChatGroupType.GROUP_DRAGON_SELF_SERVER
    },
    GROUP_SEASON_ROOM = {
      funcTypes = {
        ChatBottomFuncConfig.RedPackage,
        ChatBottomFuncConfig.TranslateAll,
        ChatBottomFuncConfig.ShareMyPoint
      },
      group = ChatGroupType.GROUP_SEASON_ROOM
    },
    GROUP_ALLIANCE_NOTICE_COMMENTS = {
      funcTypes = {
        ChatBottomFuncConfig.RedPackage
      },
      group = ChatGroupType.GROUP_ALLIANCE_NOTICE_COMMENTS
    },
    GROUP_SEASON_FACTION_WAR_ROOM = {
      funcTypes = {
        ChatBottomFuncConfig.RedPackage,
        ChatBottomFuncConfig.TranslateAll
      },
      group = ChatGroupType.GROUP_SEASON_FACTION_WAR_ROOM
    },
    GROUP_ALLIANCE_FRIEND_ROOM = {
      funcTypes = {
        ChatBottomFuncConfig.RedPackage,
        ChatBottomFuncConfig.TranslateAll,
        ChatBottomFuncConfig.ShareMyPoint
      },
      group = ChatGroupType.GROUP_ALLIANCE_FRIEND_ROOM
    },
    GROUP_LANDLORD_FARMER = {
      funcTypes = {
        ChatBottomFuncConfig.TranslateAll
      },
      group = ChatGroupType.GROUP_LANDLORD_FARMER
    },
    GROUP_LANDLORD_LORD = {
      funcTypes = {
        ChatBottomFuncConfig.TranslateAll
      },
      group = ChatGroupType.GROUP_LANDLORD_LORD
    },
    Default = {
      funcTypes = {
        ChatBottomFuncConfig.RedPackage,
        ChatBottomFuncConfig.TranslateAll
      },
      group = nil
    }
  }
end

function UIChatViewFuncArea_v2:OnDestroy()
  self.funcItemScriptList = nil
  self.gridRoot:RemoveComponents(UIFuncItemScript)
  if self.funcItemModelList ~= nil then
    for k, v in pairs(self.funcItemModelList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.funcItemModelList = nil
  self.FuncsPanelRoomSet = nil
  base.OnDestroy(self)
end

function UIChatViewFuncArea_v2:OnEnable()
  base.OnEnable(self)
end

function UIChatViewFuncArea_v2:OnDisable()
  base.OnDisable(self)
  self:ClearLoadingFuncItem()
end

function UIChatViewFuncArea_v2:OnAddListener()
  base.OnAddListener(self)
end

function UIChatViewFuncArea_v2:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIChatViewFuncArea_v2:GetCurRoomFuncsTypes()
  local curRoom = self.view:GetSelectedRoom()
  if curRoom == nil then
    Logger.LogError("\229\189\147\229\137\141\230\136\191\233\151\180\228\184\186\231\169\186\239\188\129")
    return nil
  end
  if curRoom.category and curRoom.category == ChatRoomCategory.PRIVATE then
    if curRoom.group == ChatGroupType.GROUP_CUSTOM_GROUP then
      return self.FuncsPanelRoomSet.GroupChat.funcTypes
    end
    return self.FuncsPanelRoomSet.Private.funcTypes
  elseif curRoom.group == ChatGroupType.GROUP_FRIENDS_CIRCLE_COMMENT_ROOM then
    return self.FuncsPanelRoomSet.FriendsCircleComment.funcTypes
  else
    for _, funcRoomSet in pairs(self.FuncsPanelRoomSet) do
      if curRoom.group == funcRoomSet.group then
        return funcRoomSet.funcTypes
      end
    end
  end
  Logger.LogError("\230\156\170\230\137\190\229\136\176\230\136\191\233\151\180\229\175\185\229\186\148\231\154\132\229\138\159\232\131\189\233\161\181\231\173\190\230\149\176\230\141\174\239\188\154" .. curRoom.group)
  return self.FuncsPanelRoomSet.Default.funcTypes
end

function UIChatViewFuncArea_v2:ShowFuncsPanel()
  local curRoomFuncTypes = self:GetCurRoomFuncsTypes()
  if curRoomFuncTypes == nil then
    return
  end
  local curRoomGroup
  local currRoom = self.view:GetSelectedRoom()
  if currRoom then
    curRoomGroup = currRoom.group
  end
  for i = #curRoomFuncTypes, 1, -1 do
    if not curRoomFuncTypes[i].getIsUnlock(curRoomGroup) then
      table.remove(curRoomFuncTypes, i)
    end
  end
  if self.funcItemModelList == nil or self.funcItemScriptList == nil then
    self.funcItemModelList = {}
    self.funcItemScriptList = {}
  end
  for i = 1, #curRoomFuncTypes do
    local curFuncConfig = curRoomFuncTypes[i]
    if self.funcItemScriptList[i] then
      self.funcItemScriptList[i]:UpdateItem(curFuncConfig)
      self.funcItemScriptList[i]:SetActive(true)
    elseif self.funcItemScriptList[i] == nil then
      self.funcItemModelList[i] = self:GameObjectInstantiateAsync(UIAssets.UIChatViewBottomBtnItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.gridRoot.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.name = "BtnFuncCell_" .. i
        local cellScript = self.gridRoot:GetComponent(go.name, UIFuncItemScript)
        if cellScript == nil then
          cellScript = self.gridRoot:AddComponent(UIFuncItemScript, go.name)
        end
        cellScript:UpdateItem(curFuncConfig)
        cellScript:SetActive(true)
        self.funcItemScriptList[i] = cellScript
      end)
    end
  end
  for i = #curRoomFuncTypes + 1, #self.funcItemScriptList do
    if self.funcItemScriptList[i] then
      self.funcItemScriptList[i]:SetActive(false)
    end
  end
end

function UIChatViewFuncArea_v2:ClearLoadingFuncItem()
  if self.funcItemModelList ~= nil then
    for k, v in pairs(self.funcItemModelList) do
      if v.state == InstanceRequestState.Init or v.state == InstanceRequestState.Loading then
        self:GameObjectDestroy(v)
      end
    end
  end
end

return UIChatViewFuncArea_v2
