local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Config = _G.UniversalUtility.Config

_G.UniversalUtility.UI = {}

local oldGui = CoreGui:FindFirstChild("UniversalUtility") or (gethui and gethui():FindFirstChild("UniversalUtility"))
if oldGui then oldGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalUtility"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end

_G.UniversalUtility.UI.ScreenGui = ScreenGui
_G.UniversalUtility.UI.TweenPresets = {
    Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Medium = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Slow = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Back = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    BackIn = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In),
    Elastic = TweenInfo.new(0.6, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    Smooth = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
}

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Visible = false

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 16)

local dragToggle = nil
local dragSpeed = 0
local dragInput = nil
local dragStart = nil
local startPos = nil
local dragConnection = nil

local function updateInput(input)
    local delta = input.Position - dragStart
    local position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
    MainFrame.Position = position
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        if dragConnection then
            dragConnection:Disconnect()
        end
        
        dragConnection = UserInputService.InputChanged:Connect(function(inputChanged)
            if inputChanged.UserInputType == Enum.UserInputType.MouseMovement or inputChanged.UserInputType == Enum.UserInputType.Touch then
                if dragToggle then
                    updateInput(inputChanged)
                end
            end
        end)
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragToggle = false
                if dragConnection then
                    dragConnection:Disconnect()
                    dragConnection = nil
                end
                _G.UniversalUtility.SaveConfig()
            end
        end)
    end
end)

local Shadow = Instance.new("ImageLabel", MainFrame)
Shadow.Name = "Shadow"
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.ZIndex = 0
Shadow.Image = "rbxassetid://6014261993"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(49, 49, 450, 450)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.Position = UDim2.new(0, 0, 0, 5)
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
TopBar.BackgroundTransparency = 0
TopBar.BorderSizePixel = 0

local TopBarCorner = Instance.new("UICorner", TopBar)
TopBarCorner.CornerRadius = UDim.new(0, 16)

local TopBarGradient = Instance.new("UIGradient", TopBar)
TopBarGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 42)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 37))
}
TopBarGradient.Rotation = 90

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ Universal Utility"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("ImageButton", TopBar)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0.5, 0)
CloseButton.AnchorPoint = Vector2.new(0, 0.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Image = "rbxassetid://3926305904"
CloseButton.ImageRectOffset = Vector2.new(284, 4)
CloseButton.ImageRectSize = Vector2.new(24, 24)
CloseButton.ImageColor3 = Color3.fromRGB(255, 255, 255)

local CloseButtonCorner = Instance.new("UICorner", CloseButton)
CloseButtonCorner.CornerRadius = UDim.new(0, 8)

local SideNav = Instance.new("Frame", MainFrame)
SideNav.Name = "SideNav"
SideNav.Size = UDim2.new(0, 180, 1, -57)
SideNav.Position = UDim2.new(0, 2.5, 0, 50)
SideNav.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
SideNav.BorderSizePixel = 0

local SideNavCorner = Instance.new("UICorner", SideNav)
SideNavCorner.CornerRadius = UDim.new(0, 12)

local SideNavGradient = Instance.new("UIGradient", SideNav)
SideNavGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 30))
}
SideNavGradient.Rotation = 90

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -180, 1, -40)
ContentFrame.Position = UDim2.new(0, 180, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ClipsDescendants = true

local ReopenButton = Instance.new("ImageButton", ScreenGui)
ReopenButton.Name = "ReopenButton"
ReopenButton.Size = UDim2.new(0, 0, 0, 0)
ReopenButton.Position = UDim2.new(0.5, 0, 0, 30)
ReopenButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
ReopenButton.BorderSizePixel = 0
ReopenButton.Visible = false
ReopenButton.ZIndex = 10
ReopenButton.Active = true

local ReopenCorner = Instance.new("UICorner", ReopenButton)
ReopenCorner.CornerRadius = UDim.new(1, 0)

local ReopenGradient = Instance.new("UIGradient", ReopenButton)
ReopenGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 130, 235))
}
ReopenGradient.Rotation = 45

local ReopenIcon = Instance.new("TextLabel", ReopenButton)
ReopenIcon.Size = UDim2.new(1, 0, 1, 0)
ReopenIcon.BackgroundTransparency = 1
ReopenIcon.Text = "⚡"
ReopenIcon.Font = Enum.Font.GothamBold
ReopenIcon.TextSize = 24
ReopenIcon.TextColor3 = Color3.fromRGB(255, 255, 255)

local ReopenHitbox = Instance.new("Frame", ReopenButton)
ReopenHitbox.Name = "Hitbox"
ReopenHitbox.Size = UDim2.new(1, 20, 1, 20)
ReopenHitbox.Position = UDim2.new(0.5, 0, 0.5, 0)
ReopenHitbox.AnchorPoint = Vector2.new(0.5, 0.5)
ReopenHitbox.BackgroundTransparency = 1
ReopenHitbox.ZIndex = 11

_G.UniversalUtility.UI.ReopenDragToggle = false
_G.UniversalUtility.UI.ReopenDragMoved = false

local reopenDragToggle = nil
local reopenDragStart = nil
local reopenStartPos = nil
local reopenDragConnection = nil

local function updateReopenInput(input)
    local delta = input.Position - reopenDragStart
    if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
        _G.UniversalUtility.UI.ReopenDragMoved = true
    end
    local position = UDim2.new(
        reopenStartPos.X.Scale,
        reopenStartPos.X.Offset + delta.X,
        0,
        reopenStartPos.Y.Offset + delta.Y
    )
    ReopenButton.Position = position
end

ReopenButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        reopenDragToggle = true
        _G.UniversalUtility.UI.ReopenDragToggle = true
        _G.UniversalUtility.UI.ReopenDragMoved = false
        reopenDragStart = input.Position
        reopenStartPos = ReopenButton.Position
        
        if reopenDragConnection then
            reopenDragConnection:Disconnect()
        end
        
        reopenDragConnection = UserInputService.InputChanged:Connect(function(inputChanged)
            if inputChanged.UserInputType == Enum.UserInputType.MouseMovement or inputChanged.UserInputType == Enum.UserInputType.Touch then
                if reopenDragToggle then
                    updateReopenInput(inputChanged)
                end
            end
        end)
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                reopenDragToggle = false
                if reopenDragConnection then
                    reopenDragConnection:Disconnect()
                    reopenDragConnection = nil
                end
                task.wait(0.1)
                _G.UniversalUtility.UI.ReopenDragToggle = false
                if _G.UniversalUtility.UI.ReopenDragMoved then
                    _G.UniversalUtility.SaveConfig()
                end
                _G.UniversalUtility.UI.ReopenDragMoved = false
            end
        end)
    end
end)

_G.UniversalUtility.UI.MainFrame = MainFrame
_G.UniversalUtility.UI.ContentFrame = ContentFrame
_G.UniversalUtility.UI.SideNav = SideNav
_G.UniversalUtility.UI.CloseButton = CloseButton
_G.UniversalUtility.UI.ReopenButton = ReopenButton
_G.UniversalUtility.UI.TabButtons = {}
_G.UniversalUtility.UI.TabContents = {}
_G.UniversalUtility.UI.ActiveTweens = {}

local executor = (identifyexecutor and identifyexecutor()) or 
                 (getexecutorname and getexecutorname()) or 
                 "Unknown Executor"

function _G.UniversalUtility.UI.CancelTween(object)
    if _G.UniversalUtility.UI.ActiveTweens[object] then
        _G.UniversalUtility.UI.ActiveTweens[object]:Cancel()
        _G.UniversalUtility.UI.ActiveTweens[object] = nil
    end
end

function _G.UniversalUtility.UI.PlayTween(object, tweenInfo, properties)
    _G.UniversalUtility.UI.CancelTween(object)
    local tween = TweenService:Create(object, tweenInfo, properties)
    _G.UniversalUtility.UI.ActiveTweens[object] = tween
    tween:Play()
    tween.Completed:Connect(function()
        _G.UniversalUtility.UI.ActiveTweens[object] = nil
    end)
    return tween
end

function _G.UniversalUtility.UI.LoadPlayerInfo()
    task.spawn(function()
        pcall(function()
            if _G.UniversalUtility.UI.PlayerImage then
                _G.UniversalUtility.UI.PlayerImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"
            end
            if _G.UniversalUtility.UI.GameName and _G.UniversalUtility.UI.GameImage then
                local gameInfo = MarketplaceService:GetProductInfo(game.PlaceId)
                _G.UniversalUtility.UI.GameName.Text = gameInfo.Name
                if gameInfo.IconImageAssetId and gameInfo.IconImageAssetId ~= 0 then
                    _G.UniversalUtility.UI.GameImage.Image = "rbxthumb://type=Asset&id=" .. gameInfo.IconImageAssetId .. "&w=420&h=420"
                end
            end
        end)
    end)
end

return _G.UniversalUtility.UI
